#INCLUDE "CFGX051.CH"

#IFDEF WINDOWS
	#INCLUDE "Protheus.Ch"
#ELSE
	#INCLUDE "InKey.Ch"
	#INCLUDE "SetCurs.Ch"
	#INCLUDE "Siga.Ch"
#ENDIF

#IFDEF TOP

#DEFINE F_IncluirSP	1
#DEFINE F_ExcluirSP	2

#DEFINE F_Amarelo	0
#DEFINE F_Verde		1
#DEFINE F_Vermelho	2

// Funções declaradas e usadas em procedures, que necessitam
// ser prefixadas no AS400 com o nome do banco ( schema )
// ( array usado na aplicação de stored procedures )
Static a400Funcs := { "MSDATEDIFF" , "MSDATEADD" }


/*/{Protheus.doc} CFGX051Id
//TODO Controle de versionamento do fonte CFGX051
@author reynaldo
@since 19/06/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Function CFGX051Id()

Return "20180619"

/*-------------------------------------------------------------------------------
Programa   CFGX051   Autor  Vicente Sementilli     Data  30/08/99 
Descrição  Gerenciamento de Stored Procedures                  
Observacao O fonte deste programa esta sendo controlado em conjunto em
           conjunto com os fontes das Stored Procedures (Versao COBOL).
           Nao alterar diretamente este fonte, pois as alteracoes deverao estar 
           registradas junto ao controle de versoes. Em caso de duvida, procurar 
           a area responsavel pela confecção de Stored Procedures. Obrigado.
-------------------------------------------------------------------------------*/
Function CFGX051()
Local nOpca      := 2
Local aProcessos := {}

Private aEmpres  := {}
Private cDir     := GetSrvProfString("StartPath",STR0072)

If !FwCanCfg( 'CFGX051' )
	Return NIL
EndIf
If !FWIsAdmin()
	_FWLogAccI( 'CFGX051' )
	FWHlpAcAdm()
	Return
Endif

If TcSrvType() == "AS/400"
	ApMsgStop( STR0008 ) // Procedures para servidores AS/400 não podem ser instaladas pelo configurador
	Return (.F.)
EndIf

// Ajusta opcoes
dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(Padr("CFG051",Len(SX1->X1_GRUPO), " ") +"01")
	If Empty( X1_DEF03)
		RecLock("SX1",.F.)
		Replace X1_DEF03   With "Consulta"
		Replace X1_DEFSPA3 With "Consulta"
		Replace X1_DEFENG3 With "View"
		MsUnlock()
	EndIf
EndIf

If Pergunte( "CFG051", .T. )
	If mv_par01 == 1
		// instalação de stored procedures
		IncluiSP()
	ElseIf mv_par01 == 2
		// Metodo novo - por processos
		// Exibir uma janela para usuario selecionar os processos a serem desinstalados
		aProcessos := {}
		SeleProcs(F_ExcluirSP, aProcessos, @nOpca)
		If nOpca == 1
			Processa({|lEnd| ExcluiSP(@lEnd, aProcessos)}, STR0077, STR0101, .T.) //"Desinstalar processos"###"Removendo stored procedures..."
		EndIf
	ElseIf mv_par01 == 3
		ConsultProc()
	EndIf
EndIf

Return Nil

/*-----------------------------------------------------------------------------
Função    IncluiSP   Autor Microsiga S/A           Data 25/08/2010
Descrição Instalação de procedures                                   
-----------------------------------------------------------------------------*/
Static Function IncluiSP()
Local i				:= 0
Local nOpca			:= 0
Local cTDataBase	:= AllTrim(Upper(TcGetDB()))
//Local oDlg
Local nPos			:= 0
Local cLine			:= ''
Local lTop4AS400	:= ('ISERIES'$Upper(TcSrvType()))
Local aSPS			:= Directory('*.SPS')
Local aDatabase		:= {{"MSSQL"		,"sq7"},;
						{"MSSQL7"		,"sq7"},;
						{"ORACLE"		,"ora"},;
						{"DB2"			,"db2"},;
						{"SYBASE"		,"syb"},;
						{"INFORMIX"		,"ifx"},;
						{"CTREESQL"		,"ctr"},;
						{"OPENEDGE"		,"ope"},;
						{"MYSQL"		,"mys"},;
						{"POSTGRES"		,"pos"}}

If TcSrvType() == "AS/400"
	ApMsgStop( STR0008 ) // Procedures para servidores AS/400 não podem ser instaladas pelo configurador
	Return (.F.)
ElseIf lTop4AS400
	// Top 4 para AS400, instala procedures = DB2
	aadd(aDatabase,{"AS400"      ,"db2"}) // remover posteriormente esta linha
	aadd(aDatabase,{"DB2/400"    ,"db2"})
EndIf

nPos:= Ascan( aDatabase, {|z| z[1] == cTDataBase })

If nPos == 0
	ApMsgStop( STR0009 ) // Dialeto não disponível
	Return (.F.)
EndIf

If Empty( aSPS )
	ApMsgInfo( STR0010 ) // Não existem procedures a migrar
	Return (.F.)
EndIf

// Metodo novo - por processos
// Exibir uma janela para usuario selecionar os processos a serem instalados
aProcessos := {}
SeleProcs(F_IncluirSP, aProcessos, @nOpca)
If nOpca == 1
	Processa({|lEnd| CFG051Proc(@lEnd, aProcessos, aDatabase[nPos][2])},STR0004,STR0005,.T.) 		//"Instalador de Stored Procedures"###"Compilando Procedures..."
EndIf

Return Nil

/*-----------------------------------------------------------------------------
Função    CFG051Proc Autor Microsiga S/A           Data 14/07/2008
Descrição Processa a compilação e instalação das procedures          
-----------------------------------------------------------------------------*/
Static Function CFG051Proc(lEnd, aProcessos, cDialeto)
Local lTools		:= .F.
Local lCopy			:= .F.
Local lInstTools	:= .F.
Local cLine
Local aProc 		:= {}
Local nPass 		:= 0
Local nTotProc		:= 0
Local cName 		:= ""
Local lSkipa 		:= .F.
Local ni, x, i, y
Local nLines
Local nProcs 		:= 0
Local nPosP 		:= 0
Local nPos	 		:= 0
Local nCount 		:= 0
Local lCancel 		:= .F.
Local cFilter
Local cNomeFile		:= ""
Local aRest1     	:= {}
Local aCampos		:= {}
Local lExecAdvpl 	:= .F.
Local cString 		:= ' '
//Local cCreate     	:= ''
Local cData     	:= ''
Local cHora     	:= ''
Local nChar			:= 0
Local cDataName		:= 'Microsoft SQL Server'
Local lCTB        	:= IIf(GetMV("MV_MCONTAB") = "CTB", .T., .F.)
Local lPCO			:= .F.
Local lSP_PCO		:= .F.
Local lTop4AS400 	:= ('ISERIES'$Upper(TcSrvType()))
Local cAssinat		:= ''
Local nPosAss		:= 0
Local cEmp        	:= cEmpAnt
Local cEmpOld     	:= cEmpAnt
Local cFilOld     	:= cFilAnt
Local cTOP400Alias	:= ""
Local cNomeTab      := "0_SP"
Local nX

Local nTotalQry     := 0

Default aProcessos  := {}

Do Case
	Case cDialeto == 'ora'
		cDataName:= 'Oracle'
	Case cDialeto == 'syb'
		cDataName:= 'SyBase'
	Case cDialeto == 'ifx'
		cDataName:= 'Informix'
	Case cDialeto == 'ctr'
		cDataName:= 'cTreeSql'
	Case cDialeto == 'ope'
		cDataName:= 'Openedge'
	Case cDialeto == 'db2'
		cDataName:= 'DB2'
		If lTop4AS400
			cDataName += ' (iSeries)'
		EndIf
	Case cDialeto == 'mys'
		cDataName:= 'MySQL'
	Case cDialeto == 'pos'
		cDataName:= 'Postgres'
EndCase

Private aErro   := {}

/*---------------------------------------------------------------------------
Variável para armazenar as procedures enviadas para o banco, pois no Oracle
as procedures que não são por empresas só devem ser enviadas uma única vez.
---------------------------------------------------------------------------*/
Private aProcs := {}

/*---------------------------------------------------------------------------
Variável para armazenar as empresas que serão enviadas as procedures
para o Banco.
---------------------------------------------------------------------------*/
//cType := ''

ApMsgInfo(OemToansi(STR0013 + cDataName), STR0012) // "Sera Compilado para : ", "Atenção"

DbSelectArea("SX2")
cFilter := SX2->(dbfilter())

/*---------------------------------------------------------------------------
Verifica a existência do campo SP_ASSINAT
---------------------------------------------------------------------------*/
If ChkCpoTOP_SP("SP_ASSINAT",Alltrim(upper(Tcgetdb())))
	If cDataName == "ORACLE"
		TCSqlExec( "ALTER TABLE TOP_SP ADD SP_ASSINAT CHAR(03)" )
	ElseIf cDataName == "AS400" .or. cDataName == "DB2/400"  // remover posteriormente "AS400"
		// Identifica nome do Schema ( Alias )
		cTOP400Alias := GetSrvProfString('DBALIAS','')
		If empty(cTOP400Alias)
			cTOP400Alias := GetSrvProfString('TOPALIAS','')
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOTVSDBACCESS','ALIAS','',GetAdv97())
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOPCONNECT','ALIAS','',GetAdv97())
		EndIf

		TCSqlExec( "ALTER TABLE " + cTOP400Alias + ".TOP_SP ADD SP_ASSINAT CHAR(03) CCSID 1208" )
	Else
		TCSqlExec( "ALTER TABLE TOP_SP ADD SP_ASSINAT VARCHAR(03)" )
	EndIf
EndIf

/*--------------------------------------------------------------------
Excluir a SOMA1. Deve ser MSSOMA1
--------------------------------------------------------------------*/
If TCSPExist("SOMA1")
	If cDataName == "AS400" .or. cDataName == "DB2/400"  // remover posteriormente "AS400"
		// Identifica nome do Schema ( Alias )
		cTOP400Alias := GetSrvProfString('DBALIAS','')
		If empty(cTOP400Alias)
			cTOP400Alias := GetSrvProfString('TOPALIAS','')
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOTVSDBACCESS','ALIAS','',GetAdv97())
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOPCONNECT','ALIAS','',GetAdv97())
		EndIf
		TCSqlExec("DROP PROCEDURE " + cTOP400Alias + ".SOMA1")
		TCSqlExec("DELETE FROM  " + cTOP400Alias + ".TOP_SP WHERE SP_NOME LIKE 'SOMA1_%'")
	Else
		TCSqlExec("DROP PROCEDURE SOMA1")
		TCSqlExec("DELETE FROM TOP_SP WHERE SP_NOME LIKE 'SOMA1_%'")
	EndIf
EndIf

/*---------------------------------------------------------------------------
// Armazena Alias/Recno/Indice do sigamat para posterior restauracao
---------------------------------------------------------------------------*/
DbSelectArea("SM0")
aRest1 := GETAREA()
DbGoTop()

/*---------------------------------------------------------------------------
// Função para armazenar empresas para posterior escolha.
---------------------------------------------------------------------------*/
AbreSM0()

For x:=1 To Len(aEmpres)
	nCount+=(IIF(aEmpres[x,1]="T",1,0))
Next x

// Obter o total de procedures a serem compiladas
For x := 1 to Len(aProcessos)
	nTotalQry += CountProcs( aProcessos[x, 1] )
Next x

nProcs := 0
nPosP  := 1
aProc  := { "" }

For x := 1 To Len(aEmpres)

	nCount := nTotalQry
	ProcRegua(nCount)

	If aEmpres[x,1] = "F"
		Loop
	EndIf
	DbSelectArea("SM0")
	DbSeek(aEmpres[x,2])

	//-- Inicializa empresas
	If cEmpOld <> aEmpres[x,2]
		cArqTab := ""
		GetEmpr(aEmpres[x,2]+aEmpres[x,4])
		cEmpOld := aEmpres[x,2]
	EndIf

	If aScan( aProcessos, {|x| x[2] == '04'} ) > 0 .or. aScan( aProcessos, {|x| x[2] == '06'} ) > 0 // Atualizacao de Saldos ON-LINE (CTBXFUN) - Processo 04/06
		If TcCanOpen("TRW"+SM0->M0_CODIGO+cNomeTab)
			TcDelFile("TRW"+SM0->M0_CODIGO+cNomeTab)
		EndIf

		aCampos:={}
		CriaTmpDb("CT2","TRW"+SM0->M0_CODIGO+cNomeTab,aCampos,.F.)
	EndIf

	If aScan( aProcessos, {|x| x[2] == '17'} ) > 0 // Virada de saldos (MATA280) - Processo 17
		If TcCanOpen("TRC"+SM0->M0_CODIGO+cNomeTab)
			TcDelFile("TRC"+SM0->M0_CODIGO+cNomeTab)
		EndIf

		aCampos:= GetTRCStru() // Esta Função esta codificada no arquivo MATXFUNA.PRX
		CriaTmpDb("","TRC"+SM0->M0_CODIGO+cNomeTab,aCampos,.F.)
		TcSqlExec("Create index TRC"+SM0->M0_CODIGO+"01 on " + "TRC"+SM0->M0_CODIGO+cNomeTab+"( TRC_COD )")

		If FindFunction('GetTRJStru')
			If TcCanOpen("TRJ"+SM0->M0_CODIGO+cNomeTab)
				TcDelFile("TRJ"+SM0->M0_CODIGO+cNomeTab)
			EndIf
			aCampos:= GetTRJStru() // Esta Função esta codificada no arquivo MATXFUNA.PRX
			CriaTmpDb("","TRJ"+SM0->M0_CODIGO+cNomeTab,aCampos,.F.)
			TcSqlExec("Create index TRJ"+SM0->M0_CODIGO+"01 on " + "TRJ"+SM0->M0_CODIGO+cNomeTab+"( BJ_FILIAL, BJ_COD, BJ_LOCAL, BJ_LOTECTL, BJ_NUMLOTE, BJ_DATA, D_E_L_E_T_ )")
		EndIf

		If FindFunction('GetTRKStru')
			If TcCanOpen("TRK"+SM0->M0_CODIGO+cNomeTab)
				TcDelFile("TRK"+SM0->M0_CODIGO+cNomeTab)
			EndIf
			aCampos:= GetTRKStru() // Esta Função esta codificada no arquivo MATXFUNA.PRX
			CriaTmpDb("","TRK"+SM0->M0_CODIGO+cNomeTab,aCampos,.F.)
			TcSqlExec("Create index TRK"+SM0->M0_CODIGO+"01 on " + "TRK"+SM0->M0_CODIGO+cNomeTab+"( BK_FILIAL, BK_COD, BK_LOCAL, BK_LOTECTL, BK_NUMLOTE, BK_LOCALIZ, BK_NUMSERI, BK_DATA, D_E_L_E_T_ )")
		EndIf
	EndIf

	If aScan( aProcessos, {|x| x[2] == '19'} ) > 0 // Recálculo do custo (MATA330) - Processo 19

		//--TRA
		cAliasTRA := "TRA"+ Alltrim(SM0->M0_CODIGO)+"SP"
		If TcCanOpen(cAliasTRA)
			TcDelFile(cAliasTRA)
		EndIf
		aCampos:=GetTRAStru() // Esta Função esta codificada no arquivo MATXFUNA.PRX
		CriaTmpDb("",cAliasTRA,aCampos,.T.)
		dbUseArea(.T., "TOPCONN",cAliasTRA,cAliasTRA, .T., .F.)
		DBCreateIndex(cAliasTRA +"01","TRA_FILIAL+TRA_NUMSEQ+TRA_CF+TRA_COD")
		DBCreateIndex(cAliasTRA +"02","TRA_FILIAL+TRA_RNOAUX")
		DbCloseArea()
		//--TRB
		cAliasTRB := "TRB"+ Alltrim(SM0->M0_CODIGO)+"SP"
		If TcCanOpen(cAliasTRB)
			TcDelFile(cAliasTRB)
		EndIf
		aCampos:= GetTRBStru() // Esta Função esta codificada no arquivo MATXFUNA.PRX
		CriaTmpDb("",cAliasTRB,aCampos,.T.)
		dbUseArea(.T., "TOPCONN",cAliasTRB,cAliasTRB, .T., .F.)
		DBCreateIndex(cAliasTRB +"01","TRB_FILIAL+TRB_ORDEM+TRB_COD+TRB_NIVEL+TRB_NIVSD3+TRB_CHAVE+TRB_SEQ")
		DBCreateIndex(cAliasTRB +"02","TRB_FILIAL+TRB_ALIAS+TRB_SEQ")
		DBCreateIndex(cAliasTRB +"03","TRB_DTBASE+TRB_SEQPRO+TRB_ORDEM+TRB_NIVEL+TRB_NIVSD3+TRB_CHAVE+TRB_SEQ")
		DBCreateIndex(cAliasTRB +"04","TRB_FILIAL+TRB_ALIAS+TRB_DOC+TRB_COD+TRB_LOCAL")
		DBCreateIndex(cAliasTRB +"05","TRB_DTORIG+TRB_SEQ+TRB_NIVEL+TRB_NIVSD3")
		DBCreateIndex(cAliasTRB +"06","TRB_FILIAL+TRB_USATRA+TRB_ALIAS+TRB_COD+TRB_FILTRA")
		DBCreateIndex(cAliasTRB +"07","TRB_FILIAL+TRB_RNOAUX")
		DBCreateIndex(cAliasTRB +"08","TRB_FILIAL+TRB_COD+TRB_LOCAL")
		DBCreateIndex(cAliasTRB +"09","TRB_RECNO+TRB_ALIAS")
		DbCloseArea()

		//--TRBSG1
		cAliasSG1TRB := "TRB"+ Alltrim(SM0->M0_CODIGO)+"SPSG1"
		If TcCanOpen(cAliasSG1TRB)
			TcDelFile(cAliasSG1TRB)
		EndIf
		aCampos:= SG1->(DBSTRUCT())
		CriaTmpDb("",cAliasSG1TRB,aCampos,.T.)
		dbUseArea(.T., "TOPCONN",cAliasSG1TRB,cAliasSG1TRB, .T., .F.)
		DBCreateIndex(cAliasSG1TRB +"01","G1_FILIAL+G1_COD+G1_COMP+G1_TRT")
		DBCreateIndex(cAliasSG1TRB +"02","G1_FILIAL")
		DbCloseArea()
		
		//--TRD
		cAliasTRD := "TRD"+ Alltrim(SM0->M0_CODIGO)+"SP"
		If TcCanOpen(cAliasTRD)
			TcDelFile(cAliasTRD)
		EndIf
		aCampos:= GetTRDStru() // Esta Função esta codificada no arquivo MATXFUNA.PRX
		CriaTmpDb("",cAliasTRD,aCampos,.T.)
		dbUseArea(.T., "TOPCONN",cAliasTRD,cAliasTRD, .T., .F.)
		DBCreateIndex(cAliasTRD +"01","TRD_FILIAL+TRD_CGC")	
		DbCloseArea()
		
		//--TRT
		cAliasTRT := "TRT"+ Alltrim(SM0->M0_CODIGO)+"SP"
		If TcCanOpen(cAliasTRT)
			TcDelFile(cAliasTRT)
		EndIf
		aCampos:= GetTRTStru() // Esta Função esta codificada no arquivo MATXFUNA.PRX
		CriaTmpDb("",cAliasTRT,aCampos,.T.)
		dbUseArea(.T., "TOPCONN",cAliasTRT,cAliasTRT, .T., .F.)
		DBCreateIndex(cAliasTRT +"01","TRB_FILIAL+TRB_COD")	
		DBCreateIndex(cAliasTRT +"02","TRB_FILIAL+TRB_RNOAUX")	
		DbCloseArea()
		
		//--TRX
		cAliasTRX := "TRX"+ Alltrim(SM0->M0_CODIGO)+"SP"
		If TcCanOpen(cAliasTRX)
			TcDelFile(cAliasTRX)
		EndIf
		aCampos:= GetTRXStru() // Esta Função esta codficada no arquivo MATXFUNA.PRX
		CriaTmpDb("",cAliasTRX,aCampos,.T.)		
		dbUseArea(.T., "TOPCONN",cAliasTRX,cAliasTRX, .T., .F.)
		DBCreateIndex(cAliasTRX +"01","TRX_FILIAL+TRX_DATA+TRX_OP+TRX_COD+TRX_LOCAL")
		DBCreateIndex(cAliasTRX +"02","TRX_FILIAL+TRX_RNOAUX")
		DbCloseArea()
		
		//--TRC
		cAliasTRC := "TRC"+ Alltrim(SM0->M0_CODIGO)+"SP"
		If TcCanOpen(cAliasTRC)
			TcDelFile(cAliasTRC)
		EndIf
		aCampos:= GetTRStru() // Esta Função esta codficada no arquivo MATXFUNA.PRX
		CriaTmpDb("",cAliasTRC,aCampos,.T.)	
		dbUseArea(.T., "TOPCONN",cAliasTRC,cAliasTRC, .T., .F.)
		DBCreateIndex(cAliasTRC +"01","TRC_FILIAL+TRC_SEQUEN")
		DbCloseArea()
	EndIf
	// Cálculo do custo de reposição (MATA320) - Processo 20
	If aScan( aProcessos, {|x| x[2] == '20'} ) > 0 
		// caso a procedure "MAT005_19_nn" exista, significa que a tabela TRBnnSG1 nao pode ser apagada
		If !TCSPExist( 'MAT005_19_'+SM0->M0_CODIGO )
			If TcCanOpen("TRB"+SM0->M0_CODIGO+"SPSG1")
				TcDelFile("TRB"+SM0->M0_CODIGO\+"SPSG1")
			EndIf
			aCampos:={}
			AADD(aCampos,{ "G1_RNOAUX" ,"N",12,0 } )
			CriaTmpDb("SG1","TRB"+SM0->M0_CODIGO+"SPSG1",aCampos,.F.)
	    	TcSqlExec("Create index TRB"+SM0->M0_CODIGO+"0SG1A on " + "TRB"+SM0->M0_CODIGO+"SPSG1( G1_FILIAL, G1_RNOAUX )")
		EndIf
	EndIf

		/*---------------------------------------------------------------------------
		Executa Função para abrir sx2 da empresa posicionada.
		---------------------------------------------------------------------------*/
		AbreSx2()

		DbSelectArea("SX2")
		DbSetOrder(1)
		Set Filter To

		//Verificar RELEASE - Flag install PCO Procedure - Protheus 8
		If FindFunction("GETRPORELEASE") .And. SuperGetMV("MV_PCOINTE",.F.,"2")=="1" .And. Len(RetSqlName("AKS")) > 0 .And. AKS->(FieldPos("AKS_TPSALD")) > 0
			lPCO := .T.
		Else
			lPCO := .F.
		EndIf

		/*------------------------------------------------------------------------------------
		Instala todos os pacotes contidos no vetor aProcessos para cada uma das empresas
		------------------------------------------------------------------------------------*/
		For y := 1 to Len(aProcessos)

			cNomeFile  := aProcessos[y, 1]
			lInstTools := .F.

			MsgRun( STR0011+': '+cNomeFile, STR0012,{|| nTotProc := CountProcs( cNomeFile )}) // "Validando Arquivo de Scripts", "Atenção"

			FT_FUSE(cNomeFile)
			FT_FGOTOP()

			WHILE !FT_FEOF()
				lSkipa := .F.

				If lCancel
					Exit
				EndIf

				cLine := FT_FREADLN()

				// Processa tools -----------------------------------------------

				If lTools .and. Left( cLine, 8 ) = 'FIMTOOLS'
					lInstTools := .T.
					aProc      := { "" }
					nPosP      := 1
					lTools     := .F.
					lCopy	   := .F.
				EndIf

				If lInstTools .and. lTools
					FT_FSkip()
					Loop
				EndIf

				If lTools .and. Left( cLine, 3 ) == 'FIM' .and. lCopy

					CriaProcedure(aProc, cName, @lCancel, cData, cHora, .T., cDialeto, "000", aProcessos[y,2])

					cName := ''
					aProc := {''}
					nPosP := 1
					lCopy := .F.
				EndIf

				If lCopy
					cNewLine := ""
					For ni := 1 to Len(cLine)
						nChar:= asc( SubStr( cLine, ni, 1 ))
						If nChar != 10 .and. nChar != 13
							cNewLine += chr( nChar - 20 )
						Else
							cNewLine += ''
						EndIf
					Next ni

					cNewLine := AllTrim(cNewLine)

					If nPass > 0 .And. SubStr(cNewLine,1,2) == "/*"
						ApMsgStop( STR0017 ) // "Problemas no Script"
					EndIf

					If SubStr(cNewLine,1,2) == "/*" .And. nPass == 0
						nPass := 1
					EndIf

					If nPass > 0 .And. "*/"$cNewLine .And. !("FROM"$Upper(cNewLine))
						nPass := 2
					EndIf

					If "--" == SubStr(cNewLine,1,2) .And. nPass == 0
						nPass := 2
					EndIf

					If nPass == 0
						aProc[nPosP] += cNewLine+Chr(13)+Chr(10)
					ElseIf nPass == 2
						nPass := 0
					EndIf

					If (Len(aProc[nPosP]) > ((32*1024)-64))
						aAdd(aProc,"")
						nPosP := Len(aProc)
					EndIf
				EndIf

				/*----------------------------------------
				Montando Script da Ferramenta (Tool)
				----------------------------------------*/
				If lTools .and. Left( cLine, 6 ) == 'INICIO'
					nPos  := AT( '#', cLine )
					cData := SubStr( cLine, nPos+1, 8 )
					cHora := SubStr( cLine, nPos+9, 8 )
					cName := Alltrim(SubStr(cLine, 7, nPos - 7))
					lCopy := Right( cLine, 3 ) == Lower(cDialeto)
				EndIf

				If Left( cLine, 5 ) == 'TOOLS'
					lTools:= .T.
				EndIf

				If lTools
					FT_FSKIP()
					Loop
				EndIf
				// Fim do processamento das tools ---------------------------------------------------

				If SubStr(cLine,1,6) == "INICIO"
					lSkipa  := .T.
					nPos	:= AT( '#', cLine )
					cData	:= SubStr( cLine, nPos+1, 8 )
					cHora	:= SubStr( cLine, nPos+9, 6 )
					cName	:= Alltrim(SubStr(cLine, 7, nPos - 7))
					nPosAss	:= AT( '!' ,cLine )
					cAssinat:= Iif( nPosAss > 0 , Substr( cLine, nPosAss+1, 3 ), " " )
					lSP_PCO := (Left(cName,3)=="PCO")

					If lSP_PCO
						If lPCO
							If lCTB .and. SubStr(cName, 1,3) <> "CON"       //ctb
								IncProc(STR0015 + cName + STR0016 + SM0->M0_CODIGO)	 // 'Compilando a query ' + cName + ' Empresa - '
							ElseIf !lCTB .and. SubStr(cName, 1,3) <> "CTB"   //con
								IncProc(STR0015 + cName + STR0016 + SM0->M0_CODIGO)	 // 'Compilando a query ' + cName + ' Empresa - '
							EndIf
						EndIf
					Else
						If lCTB .and. SubStr(cName, 1,3) <> "CON"       //ctb
							IncProc(STR0015 + cName + STR0016 + SM0->M0_CODIGO)	 // 'Compilando a query ' + cName + ' Empresa - '
						ElseIf !lCTB .and. SubStr(cName, 1,3) <> "CTB"   //con
							IncProc(STR0015 + cName + STR0016 + SM0->M0_CODIGO)	 // 'Compilando a query ' + cName + ' Empresa - '
						EndIf
					EndIf

				EndIf

				If SubStr(cLine,1,3) == "FIM"
					lSkipa := .T.

					If !Empty(aProc[1])
						If lSP_PCO
							If lPCO
								If lCTB .and. SubStr(cName, 1,3) <> "CON"       //ctb
									CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
								ElseIf !lCTB .and. SubStr(cName, 1,3) <> "CTB"   //con
									CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
								EndIf
							EndIf
						Else
							If lCTB .and. SubStr(cName, 1,3) <> "CON"       //ctb
								CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
							ElseIf !lCTB .and. SubStr(cName, 1,3) <> "CTB"   //con
								CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
							EndIf
						EndIf
						nProcs++
						nPass := 0
						nPosP := 1
						aProc := { "" }
					EndIf
					cName := ''
					cData := ''
					cHora := ''
				EndIf

				If SubStr(cLine,1,9) == "#ADVPLEND"
					lSkipa := .F.
					lExecAdvpl := .F.
					cLine := ExecAdvpl( cString )
					cString := ' '
				ElseIf SubStr(cLine,1,6) == "#ADVPL"
					lSkipa := .T.
					lExecAdvpl := .T.
				ElseIf lExecAdvpl
					lSkipa := .T.
					cString += cLine
				EndIf

				If !lSkipa .And. !Empty(cName)
					cNewLine := ""
					For ni := 1 to Len(cLine)
						nChar:= asc( SubStr( cLine, ni, 1 ))
						If nChar != 10 .and. nChar != 13
							cNewLine += chr( nChar - 20 )
						Else
							cNewLine += ''
						EndIf
					Next ni

					cNewLine := AllTrim(cNewLine)

					If nPass > 0 .And. SubStr(cNewLine,1,2) == "/*"
						ApMsgStop( STR0017 ) // "Problemas no Script"
					EndIf

					If SubStr(cNewLine,1,2) == "/*" .And. nPass == 0
						nPass := 1
					EndIf

					If nPass > 0 .And. "*/"$cNewLine .And. !("FROM"$Upper(cNewLine))
						nPass := 2
					EndIf

					If "--" == SubStr(cNewLine,1,2) .And. nPass == 0
						nPass := 2
					EndIf

					If nPass == 0
						aProc[nPosP] += cNewLine+Chr(13)+Chr(10)
					ElseIf nPass == 2
						nPass := 0
					EndIf

					If (Len(aProc[nPosP]) > ((32*1024)-64))
						aAdd(aProc,"")
						nPosP := Len(aProc)
					EndIf
				EndIf
				FT_FSKIP()

			EndDo
			FT_FUSE()

			If !Empty(aProc[1])
				If lSP_PCO
					If lPCO
						If lCTB .and. SubStr(cName, 1,3) <> "CON"       //ctb
							CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
						ElseIf !lCTB .and. SubStr(cName, 1,3) <> "CTB"   //con
							CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
						EndIf
					EndIf
				Else
					If lCTB .and. SubStr(cName, 1,3) <> "CON"       //ctb
						CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
					ElseIf !lCTB .and. SubStr(cName, 1,3) <> "CTB"   //con
						CriaProcedure( aProc, cName, @lCancel, cData, cHora,,, cAssinat, aProcessos[y,2])
					EndIf
				EndIf
				nProcs++
				nPosP := 1
				aProc := { "" }
			EndIf

			If Len( aErro ) > 0
				cBuffer := ""
				For i := 1 to Len( aErro )
					cBuffer += aErro[i] + chr(13) + chr(10)
				Next i
				MemoWrit("SPBUILD.LOG",cBuffer)
				ShowMemo("SPBUILD.LOG")
				Exit
			EndIf

		Next y // Loop nos arquivos .SPS (aProcessos)

Next x // Loop nas empresas

/*---------------------------------------------------------------------------
Restaura Sx2,Sigamat posicionado no inicio do processo.
---------------------------------------------------------------------------*/
If nCount =0
	ApMsgStop(OemToansi(STR0019),STR0012) //"Nenhuma Empresa Selecionada!", "Atenção"
ElseIf Len(aErro) = 0
	ApMsgInfo(OemToansi(STR0020),STR0004) //'Processo Concluido c/Sucesso!', "Atenção"
EndIf
RestArea(aRest1)
AbreSx2()

DbSelectArea("SX2")
DbSetOrder(1)
Set Filter to &cFilter

//-- Restaura Empresa
If cEmp <> cEmpOld
	cArqTab := ""
	GetEmpr(cEmp+cFilOld)
EndIf

Return Nil

/*-----------------------------------------------------------------------------
Função    CountProcs Autor Microsiga S/A           Data 14/07/2008
Descrição VerIfica o total de SPS do arquivo a ser executada         
-----------------------------------------------------------------------------*/
Static Function CountProcs( cNomeFile )
Local nProcedures := 0
Local nLines 	  := 0
Local cVar 		  := "INICIO"
Local lCount	  := .F.
Local cLine

If File(cNomeFile)
	FT_FUSE(cNomeFile)
	FT_FGOTOP()
	Do While !FT_FEOF()
		cLine := FT_FREADLN()
		nLines++

	   	If !lCount .and. Left( cLine, 8 ) == 'FIMTOOLS'
	   		lCount:= .T.
	   	EndIf

		If !lCount
			FT_FSKIP()
			Loop
		EndIf

		If SubStr(cLine,1,Len(cVar)) == cVar
			nProcedures++
		EndIf
		FT_FSKIP()
	EndDo
	FT_FUSE()
EndIf

Return(nProcedures)

/*-----------------------------------------------------------------------------
Função    CriaProced Autor Microsiga S/A           Data 14/07/2008
Descrição Monta o corpo das procedures a partir do arquivo original                                    
-----------------------------------------------------------------------------*/
Static Function CriaProcedure(aProc, cName, lCancel, cData, cHora, lTool, cDialeto, cAssinat, cProcesso)
Local cBuffer		:= ""
Local cCampo 		:= ""
Local aSeekFields	:= {}
Local LenCutText	:= 0
Local cOrigCampo	:= ''
Local cVerifica		:= "0"
Local cArquivo 		:= ""
Local lTop4AS400	:= ('ISERIES'$Upper(TcSrvType()))
Local lTop4ASASCII	:= .F.
Local nPTratRec		:= 0
Local cChaveUnica	:= ""
Local cRecnotext	:= ""
Local cBufferAux	:= ""
Local cDataName		:= Upper(AllTrim(Tcgetdb()))
Local nPos
Local nPos2
Local nPos3
Local lEmp
Local lTab
Local cAlias
Local nCnt01
Local nPosIni
Local nPosFim
Local lMantem       := .T.
Local cTabela
Local nPosFimBlc    := 0
Local cValid        := ""
Local cTRUE         := ""
Local cFALSE        := ""
Local cNomeTab      := "0_SP"
Local cQuery        := ""
Local cAliasBD      := GetNextAlias()
Local aArea         := {}
Local nTam			:= 0

Default cProcesso   := ''

If ( TcGetDB() == 'SYBASE')
	cVerifica := "1"
EndIf

lTool:= If( ValType( lTool ) != 'L', .F., lTool )

cBuffer := ""
For nCnt01 := 1 To Len(aProc)
	cBuffer += aProc[nCnt01] + " "
Next nCnt01

aProc := {""}
	
For nCnt01 := 1 To Len(aProc)
	/*---------------------
	 Compila procedure 
	---------------------*/
	If lCancel
		Exit
	EndIf
	
	If !lTool
		//Inicia troca dos tipos float para number com decimais baseados em arquivos do siga
		dbSelectArea("SX3")
		dbSetOrder(2)
		Do While ("DECIMAL( '" $ Upper(cBuffer))
			nPos   := AT("DECIMAL( '", Upper(cBuffer)) + 10
			cCampo := ''
			aSeekFields:= {}
			LenCutText:= 0

			// Obtendo campos para consulta no dicionário
			For nPos2:= nPos to Len( cBuffer )
				LenCutText ++
				If substr( cBuffer, nPos2, 1) != "'"
					cCampo +=  substr( cBuffer, nPos2, 1)
				Else
					exit
				EndIf
			Next nPos2

			cOrigCampo:= cCampo

			/* Retorna o campo da lista com maior tamanho  */
			cCampo:= MaiorCampo(cCampo)

			/* Se o contador for maior que o tamanho do array nenhum campo foi localizado no SX3 */
			If Empty(cCampo)
				Aadd( aErro, STR0054 + ' ' + cOrigCampo + ' ' + STR0055 + ' ' + cName + ' ' + STR0056) //'Campo(s) ' ### ' declarado na procedure ' ### ' não localizado(s).'
				Return
			EndIf

			dbSeek( cCampo )

			// Realizando troca do nome do campo pelo seu tamanho
			cBuffer:= Substr( cBuffer, 1, nPos - 2 ) + AllTrim( Str( X3_TAMANHO ) ) + "," + AllTrim( Str( X3_DECIMAL ) ) +;
				Substr( cBuffer, nPos + LenCutText + 1, len( cBuffer ) - nPos )
		EndDo

		//Efetua tratamento da variavel cBuffer caso nao seja DB2 ou MySQL
		If Trim(TcGetDb()) <> 'DB2' .And. !lTop4AS400 .And. Trim(TcGetDb()) <> 'MYSQL'
			cBuffer	:= StrTran( cBuffer, 'SELECT @fim_CUR = 0', ' ' )
		EndIf
		
		/*-----------------------------------------
		Tratamento especifico para DB2 e MySQL 
		-----------------------------------------*/
		If Trim(TcGetDb()) = 'DB2' .Or. Trim(TcGetDb()) = 'MYSQL' 
			cBuffer	:= StrTran( cBuffer, "DATEDIFF(DAY "	, "MSDATEDIFF( 'DAY' " )
			cBuffer	:= StrTran( cBuffer, "DATEDIFF (DAY "	, "MSDATEDIFF( 'DAY' " )
			cBuffer	:= StrTran( cBuffer, "DATEDIFF( DAY "	, "MSDATEDIFF( 'DAY' " )
			cBuffer	:= StrTran( cBuffer, "DATEDIFF ( DAY "	, "MSDATEDIFF( 'DAY' " )
   		EndIf

		/*------------------------------------------------------------------------------
		Tratamento especifico na procedure MAT007 para os bancos ORACLE/DB2/AS400   
		Ajuste necessario devido a falha do CURSOR apos o termino do mesmo, ou seja 
		apos o termino a variavel do cursor mantem o seu conteudo.                  
		------------------------------------------------------------------------------*/
		If 'MSSQL' $ Trim(TcGetDb()) .or. Trim(TcGetDb()) = 'SYBASE' .or. Trim(TcGetDb()) = 'INFORMIX'
			If Substr(AllTrim(cName),1,6) == "MAT007"
				cBuffer	:= StrTran( cBuffer, "if @@fetch_status = -1 select @cCod = ' '", " " )
			EndIf
			If Substr(AllTrim(cName),1,6) == "MAT056"
				cBuffer	:= StrTran( cBuffer, "if @@fetch_status = -1 select @cB1Cod = ' '", " " )
			EndIf
		EndIf

		/*------------------------------------------------------------------------------
		Tratamento especifico na procedure MAT053 para o banco SYBASE. Ajuste       
		necessario devido a particularidade do banco referente a utilizacao do      
		comando NOT EXIST dentro de UPDATES.                                        
		------------------------------------------------------------------------------*/
		If 'SYBASE' $ Trim(TcGetDb()) .And. Substr(AllTrim(cName),1,6) == "MAT053"
			cBuffer	:= StrTran( cBuffer, "set BE_STATUS = '1'"	, " set BE_STATUS = '1' From SBE### SBE " )
			cBuffer	:= StrTran( cBuffer, "= BE_LOCAL"			, "= SBE.BE_LOCAL" )
			cBuffer	:= StrTran( cBuffer, "= BE_LOCALIZ"			, "= SBE.BE_LOCALIZ" )
		EndIf

		/*------------------------------------------------------------------------------
		Tratamento especifico na procedure MAT040 para o banco INFORMIX             
		------------------------------------------------------------------------------*/
		If Trim(TcGetDb()) = 'INFORMIX'
			If Substr(AllTrim(cName),1,6) == "MAT040"
				cBuffer	:= StrTran( cBuffer, "begin tran" , " " )
				cBuffer	:= StrTran( cBuffer, "Commit transaction", " " )
			EndIf
			If Substr(AllTrim(cName),1,6) $ "CTB211/CTB310"
				cBuffer	:= StrTran( cBuffer, "If @@Fetch_status = -1 select @cDATAP = ' '", " " )
			EndIf
			If Substr(AllTrim(cName),1,6) $ "CTB220/CTB300"
				cBuffer := StrTran( cBuffer, "If @@Fetch_status = -1 select @cDATA = ' '", " " )
			EndIf
			If Substr(AllTrim(cName),1,6) $ "CTB021/CTB230/CTB231/CTB167/CTB193/CTB194/CTB195/CTB196/CTB300/CTB310"
				cBuffer	:= StrTran( cBuffer, "if @@fetch_status = -1 select @cCONTA = ' '", " " )
			EndIf			
		EndIf
   		/**************************************************************************************************************************
   		 TRATAMENTO DO FIELDPOS NA PROCEDURE

   		 1 - Se todos os campos existirem na expressao do ##FIELDP, apenas os marcadores (##FIELDP e ##ENDFIELDP) serao retirados
   		 2 - Se um campo da lista não existir, os marcadores e todo o código contido entre eles serão removidos

   		 FORMATO:

   		 ##FIELDP01( 'SE5.E5_VRETPIS;SE5.E5_VRETCOF;SE5.E5_VRETCSL' )
   		 codigo
   		 	##FIELDP02( 'SES.ES_TIPORIG' )
   		 	codigo
   		 	##ENDFIELDP02
   		 codigo
   		 ##ENDFIELDP01

   		 O numero na expresso #FIELDP identifica cada marcador e nao deve ser repetido
   		****************************************************************************************************************************/

   	    Do While ("##FIELDP" $ Upper(cBuffer))
   	        nPosAux   := AT("##FIELDP",Upper(cBuffer))
   	        cNumField := substr(cBuffer,nPosAux + 8,2)
			nPosIni   := AT("##FIELDP" + cNumField +"( '", Upper(cBuffer))
			nPosFim   := AT("##ENDFIELDP" + cNumField, Upper(cBuffer))
			If nPosIni > nPosFim .or. nPosIni = 0
				MsgAlert('Error FIELDP/ENDFIELD procedure ' + Substr(AllTrim(cName),1,6) +", FIELDP/ENDFIELD # "+ cNumField )
				Exit
			EndIf
			cCampo := ''
			lMantem:=.T.
			// Verifica se os campos existem no banco
			For nPos2 := nPosIni+13 to Len( cBuffer )
				If substr( cBuffer, nPos2, 1) != "'" .and. substr( cBuffer, nPos2, 1) != ";".and. substr( cBuffer, nPos2, 1) != "."
					cCampo += substr( cBuffer, nPos2, 1)
				ElseIf substr( cBuffer, nPos2, 1) = "."
					cTabela := cCampo
					dbSelectArea("SX2")
				   If !dbseek(cCampo)
     					lMantem := .F.
     					exit
					EndIf
					cCampo := ''
				Else
					dbSelectArea("SX2")
					If dbseek(cTabela)
  						ChkFile(cTabela, .F.)
  						If cCampo <> "R_E_C_D_E_L_"
							lMantem := lMantem .and. ((cTabela)->(FieldPos( cCampo )) > 0)
							cCampo := ''
						Else
	  					   cChaveUnica := tcInternal(13, Alltrim(SX2->X2_ARQUIVO))
		  					If Empty(cChaveUnica)
		  						lMantem := .F.
		  						cCampo := ''
		  					Else
		  						lMantem := .T.
		  						cCampo := ''
		  					EndIf
		  				EndIf
					EndIf
				EndIf
				If substr( cBuffer, nPos2, 1) = "'"
					EXIT
				EndIf
			Next nPos2
			If !lMantem
				// os marcadores e todo o código contido entre eles serão removidos
				cBuffer:= Substr( cBuffer, 1, nPosIni-1 )+ Substr( cBuffer, nPosFim+13 )
			Else
				// Retira apenas as instrucoes #FIELDP  e ##ENDFIELDP
				cBuffer:= Substr( cBuffer, 1, nPosIni-1 ) + Substr( cBuffer, nPos2 + 3, nPosfim - nPos2 - 3 ) + Substr( cBuffer, nPosfim+13 )
			EndIf
		EndDo

   		/**************************************************************************************************************************
   		 TRATAMENTO DA CLAUSULA ##IF_nnn NA PROCEDURE

   		 1 - O parametro enviado deve ser do tipo codeblock.
   		 2 - A sentenca SQL sera formatada de acordo com o valor do codeblock enviado na expressao ##IF_nnn.
   		 3 - Sera executado o codeblock representando a validacao da condicao e a sentenca da procedure sera montada de acordo com
   		     o resultado (verdadeiro ou falso).

   		 FORMATO:

		 ##IF_001({|| IIf(cPaisloc == 'ARG' .And. SuperGetMV('MV_D2DTDIG', .F., .F.), .T., .F. )})
           codigo -- expressao de condicao valida, ou seja, o codeblock retornou VERDADEIRO
		 ##ELSE_001
           codigo -- expressao de condicao invalida, ou seja, o codeblock retornou FALSO
		 ##ENDIF_001

   		 O numero na expresso ##IF_nnn identifica cada marcador e nao deve ser repetido
   		****************************************************************************************************************************/

   	    Do While ("##IF_" $ Upper(cBuffer))
   	    	cTRUE      := ""
   	    	cFALSE     := ""
			nPosAux    := AT("##IF_",Upper(cBuffer))
			cNumField  := substr(cBuffer,nPosAux + 5, 3)
			nPosIni    := AT("##IF_"    + cNumField +"(", Upper(cBuffer))
			nPosFimBlc := AT("}"                        , Upper(cBuffer))
			nPosElse   := AT("##ELSE_"  + cNumField     , Upper(cBuffer))
			nPosFim    := AT("##ENDIF_" + cNumField     , Upper(cBuffer))
			If nPosIni > nPosFim .or. nPosIni = 0
				MsgAlert('Error IF/ELSE/ENDIF procedure ' + Substr(AllTrim(cName),1,6) +", IF/ELSE/ENDIF # "+ cNumField )
				Exit
			EndIf
			cValid  := SubStr(cBuffer, nPosIni    +  9, nPosFimBlc - nPosIni    -  8) // Texto do codeblock enviado como condicao do ##IF
			cTRUE   := SubStr(cBuffer, nPosFimBlc +  2, IIf(!Empty(nPosElse), nPosElse, nPosFim) - nPosFimBlc -  2) // Texto da condicao VERDADEIRA
			If nPosElse > 0
				cFALSE  := SubStr(cBuffer, nPosElse   + 10, nPosFim    - nPosElse   - 10) // Texto da condicao FALSA
			EndIf
			If Empty(cTRUE) .And. Empty(cFALSE)
				MsgAlert('Error IF/ELSE/ENDIF procedure ' + Substr(AllTrim(cName),1,6) +", IF/ELSE/ENDIF # "+ cNumField )
				Exit
			EndIf
			// Executa a condicao enviada no parametro "codeblock"
			If eVal(&cValid)
				// Condicao VERDADEIRA
				cBuffer := Substr( cBuffer, 1, nPosIni-1 )+ cTRUE  + Substr( cBuffer, nPosFim+12 )
			Else
				// Condicao FALSA
				cBuffer := Substr( cBuffer, 1, nPosIni-1 )+ cFALSE + Substr( cBuffer, nPosFim+12 )
			EndIf
		EndDo
		If Len( cBuffer)<=5  // Se for menor que 5, a procedure nao deve ser instalada.
			cBuffer := ""
			Return
		EndIf


   		/**************************************************************************************************************************
   		 TRATAMENTO DA CLAUSULA ##TamSx3Dic(' ')

   		 1 - O parametro enviado deve ser do tipo caracter.
   		 2 - A sentenca SQl ira retornar os espacos que o campo possui no dicinario.

   		 FORMATO:

    	select @cFilialAux = ##TAMSX3DIC_001('B1_FILIAL')##ENDTAMSX3DIC_001

   		 O numero na expresso ##TAMSX3DIC__nnn identifica cada marcador e nao deve ser repetido
   		****************************************************************************************************************************/

   	    Do While ("##TAMSX3DIC_" $ Upper(cBuffer))
   	        nPosAux    := AT("##TAMSX3DIC_",Upper(cBuffer))
   	        cNumField  := substr(cBuffer,nPosAux + 12, 3)
			nPosIni    := AT("##TAMSX3DIC_"    + cNumField +"(", Upper(cBuffer))
			nPosFim    := AT("##ENDTAMSX3DIC_"+ cNumField, Upper(cBuffer))
			If nPosIni > nPosFim .or. nPosIni = 0
				MsgAlert('Error TAMSX3DIC procedure ' + Substr(AllTrim(cName),1,6) +", TAMSX3DIC # "+ cNumField )
				Exit
			EndIf
			cNomeCampo := SubStr(cBuffer, nPosIni +17, (nPosFim-nPosIni) - 19) // Texto dentro da Função com o nome do campo
			If Empty(cNomeCampo)
				MsgAlert('Error TAMSX3DIC procedure ' + Substr(AllTrim(cName),1,6) +", TAMSX3DIC # "+ cNumField )
				Exit
			EndIf

			cEspacos := Space( TamSX3(cNomeCampo)[1])

			cBuffer := Substr( cBuffer, 1, nPosIni-1 ) +"'"+ cEspacos +"'"+ Substr( cBuffer, nPosFim+18)
		EndDo
		If Len( cBuffer)<=5  // Se for menor que 5, a procedure nao deve ser instalada.
			cBuffer := ""
			Return
		EndIf


   		/**************************************************************************************************************************
		TRATAMENTO PARA GRAVAR REGISTROS SIMULTANEAMENTE NA MESMA TABELA.
		##TRATARECNO nRecno
			codigo
			Insert Into Recno values ;
   		 	codigo
		##FIMTRATARECNO
   		****************************************************************************************************************************/
   	    Do While ("##TRATARECNO" $ Upper(cBuffer))
   	        nPTratRec	:= AT("##TRATARECNO",Upper(cBuffer))
   	        nPosFim		:= AT("\",Upper(cBuffer))
   	        //Retorna a variavel recno a ser aplicada no insert
   	        cRecnotext	:= Substr(cBuffer,nPTratRec+13,nPosFim-nPTratRec-13)
			nPosFim2	:= AT("##FIMTRATARECNO", Upper(cBuffer))

			//Retorna o INSERT para ser utilizado no tratamento.
			cInsertText	:= Substr( cBuffer, nPosFim+1,nPosFim2-nPosFim-1)

			//Seta as variaveis @ins_ini e @ins_fim, que serao utilizadas como marcador inicial e final no tratamento de INSERT.
           	cBufferAux	:= "select @ins_ini = " + cRecnotext + CRLF
			cBufferAux	+= cInsertText + CRLF
           	cBufferAux	+= "select @ins_fim = 1 " + CRLF
			cBuffer 	:= Stuff( cBuffer, nPTratRec,((nPosFim2+15)-nPTratRec),cBufferAux ) // Retira ##TRATARECNO e Inclui o Tratamento de Insert no cBuffer
		EndDo

		//Inclui declaracao de variaveis utilizadas para o tratamento de INSERT na procedure
		If nPTratRec <> 0
			nPos3 := at("BEGIN",upper(cBuffer))
			If nPos3 > 0
				cInsertText := "Declare @iLoop integer " + CRLF
				cInsertText += "Declare @ins_error integer " + CRLF
				cInsertText += "Declare @ins_ini integer " + CRLF
				cInsertText += "Declare @ins_fim integer " + CRLF
				cInsertText += "Declare @icoderror integer " + CRLF
				cBuffer	:= Stuff(cBuffer,(nPos3-2),0,cInsertText)
			EndIf
		EndIf

		/*--------------------------------------------------------
		Submete a procedure a MsParse                         
		O script sera adaptado para a plataforma SGBD em uso  
		--------------------------------------------------------*/
		If lTop4AS400
			cBuffer:= MSParse(cBuffer,"DB2")
			If Empty(cBuffer) .and. lMantem
				MsgAlert(MsParseError())
			ElseIf Empty(cBuffer) .and. !lMantem
				Return
			EndIf
		Else
			cBuffer:= MSParse(cBuffer, cDataName)
			If Empty(cBuffer) .and. lMantem
				MsgAlert(MsParseError())
			ElseIf Empty(cBuffer) .and. !lMantem
				Return
			EndIf
		EndIf
		
		/*------------------------------------------------------------------------------
		Metodo novo - Por processos                                                 
		Depois do MSParse eh necessario realizar tratamento para adicionar o codigo 
		do processo nas chamadas das Tools                                          
		------------------------------------------------------------------------------*/
		cBuffer	:= StrTran( cBuffer, "MSDATEADD"  , "MSDATEADD_"  + cProcesso + "_##" )
		cBuffer	:= StrTran( cBuffer, "MSDATEDIFF" , "MSDATEDIFF_" + cProcesso + "_##" )
		cBuffer	:= StrTran( cBuffer, "MSSTUFF"    , "MSSTUFF_"    + cProcesso + "_##" )
		cBuffer	:= StrTran( cBuffer, "MSSOMA1"    , "MSSOMA1_"    + cProcesso + "_##" )
		cBuffer	:= StrTran( cBuffer, "MSEXIST"    , "MSEXIST_"    + cProcesso + "_##" )
		cBuffer	:= StrTran( cBuffer, "MSSTRZERO"  , "MSSTRZERO_"  + cProcesso + "_##" )
		cBuffer	:= StrTran( cBuffer, "MSTRUNCATE" , "MSTRUNCATE_" + cProcesso + "_##" )
		/*----------------------------------------------------------------------------------------
		 Essa alteracao esta aqui apenas por compatibilidade. Essa Função e usada apenas pela 
		 CON003.SQL que e executada na versao 8.                                              
		----------------------------------------------------------------------------------------*/
		cBuffer	:= StrTran( cBuffer, "MSCALCPER"  , "MSCALCPER_"  + cProcesso + "_##" )
		/*----------------------------------------------------------------------------------------
		 O PARSE altera a Função CharIndex por MSCHARINDEX, entao deve-se alterar para conter 
		 o codigo do processo e a empresa.                                                    
		----------------------------------------------------------------------------------------*/
		cBuffer	:= StrTran( cBuffer, "MSCHARINDEX", "MSCHARIND_"  + cProcesso + "_##" )

		/*-------------------------------------
		 Tratamento de INSERT na procedure 
		-------------------------------------*/
		If nPTratRec <> 0
			cBuffer	:= InsertPutSql( TcGetDb(), cBuffer )
			
			Do Case
				Case (Trim(TcGetDb()) = 'DB2' .Or. lTop4AS400)
					nPos3 := at("DECLARE FIM_CUR INTEGER DEFAULT 0;",upper(cBuffer))
					If nPos3 > 0
						cInsertText := "Declare fim_CUR integer default 0;" + CRLF
						cInsertText += "Declare v_dup_key CONDITION for sqlstate '23505';" + CRLF
						cBuffer	:= Stuff(cBuffer,nPos3,34,cInsertText)
					EndIf
					nPos3 := at("SET FIM_CUR = 1;",upper(cBuffer))
					If nPos3 > 0
						cInsertText := "SET fim_CUR = 1;" + CRLF
						cInsertText += "DECLARE CONTINUE HANDLER FOR v_dup_key SET vicoderror = 1;" + CRLF
						cBuffer	:= Stuff(cBuffer,nPos3,16,cInsertText)
					EndIf
					
				Case (Trim(TcGetDb()) = 'MYSQL')
					nPos3 := at("DECLARE FIM_CUR INTEGER DEFAULT 0;",upper(cBuffer))
					If nPos3 > 0
						cInsertText := "Declare fim_CUR integer default 0;" + CRLF
						cInsertText += "Declare v_dup_key CONDITION for sqlstate '23000';" + CRLF
						cBuffer	:= Stuff(cBuffer,nPos3,34,cInsertText)
					EndIf
					nPos3 := at("SET FIM_CUR = 1;",upper(cBuffer))
					If nPos3 > 0
						cInsertText := "SET fim_CUR = 1;" + CRLF
						cInsertText += "DECLARE CONTINUE HANDLER FOR v_dup_key SET vicoderror = 1;" + CRLF
						cBuffer	:= Stuff(cBuffer,nPos3,16,cInsertText)
					EndIf
					
			EndCase
			
		EndIf

		/*-----------------------------------------------------
		Se for SYBASE efetua a troca de LEN por DATALENGTH 
		-----------------------------------------------------*/
        If ( cVerifica == "1")
            cBuffer := strtran(cBuffer," LEN("," DATALENGTH(")
            cBuffer := strtran(cBuffer," Len("," DATALENGTH(")
            cBuffer := strtran(cBuffer," len("," DATALENGTH(")

        	cBuffer := strtran(cBuffer,"(LEN(","(DATALENGTH(")
        	cBuffer := strtran(cBuffer,"(Len(","(DATALENGTH(")
            cBuffer := strtran(cBuffer,"(len(","(DATALENGTH(")

        	cBuffer := strtran(cBuffer," LEN ("," DATALENGTH (")
  			cBuffer := strtran(cBuffer," Len ("," DATALENGTH (")
  			cBuffer := strtran(cBuffer," len ("," DATALENGTH (")
		EndIf

		If 'MSSQL' $ Trim(TcGetDb()) .or. Trim(TcGetDb()) = 'SYBASE'
			cBuffer := StrTran(cBuffer, 'SET @iTranCount = 0', " Commit Transaction ")
			cBuffer := StrTran(cBuffer, 'SET @iTranCount  = 0', " Commit Transaction ")
		EndIf

		/*------------------------------------------------------------------------------
		//Tratamento especifico na procedure MAT053 para os bancos SYBASE             
		------------------------------------------------------------------------------*/
		If 'SYBASE' $ Trim(TcGetDb()) .And. Substr(AllTrim(cName),1,6) == "MAT053"
			cBuffer := StrTran(cBuffer, "SET BE_STATUS  = '1' SBE", "SET BE_STATUS  = '1' FROM SBE")
		EndIf

		If Trim(TcGetDb()) = 'INFORMIX'
			cBuffer := StrTran(cBuffer, 'LET viTranCount  = 0', "COMMIT WORK")
			cBuffer := StrTran(cBuffer, 'LTRIM ( RTRIM (', "TRIM((")
			If Substr(AllTrim(cName),1,6) $ "CTB211/CTB300/CTB310"
				cBuffer := StrTran(cBuffer, "GROUP BY CT2_FILIAL , SUBSTR ( CT2_DATA , 1 , 6 )", "GROUP BY CT2_FILIAL , 2")	      
			EndIf
			
			If Substr(AllTrim(cName),1,6) $ "CTB021/CTB230/CTB232"
				cBuffer := StrTran(cBuffer, "GROUP BY CQ1_FILIAL , CQ1_CONTA , CQ1_MOEDA , SUBSTR ( CQ1_DATA , 1 , 6 )", "GROUP BY CQ1_FILIAL, CQ1_CONTA , CQ1_MOEDA, 4")	      
				cBuffer := StrTran(cBuffer, "GROUP BY CQ3_FILIAL , CQ3_CONTA , CQ3_CCUSTO , CQ3_MOEDA , SUBSTR ( CQ3_DATA , 1 , 6 )", "GROUP BY CQ3_FILIAL, CQ3_CONTA ,CQ3_CCUSTO, CQ3_MOEDA, 5")	      	      
				cBuffer := StrTran(cBuffer, "GROUP BY CQ5_FILIAL , CQ5_CONTA , CQ5_CCUSTO , CQ5_ITEM , CQ5_MOEDA , SUBSTR ( CQ5_DATA , 1 , 6 )", "GROUP BY CQ5_FILIAL, CQ5_CONTA ,CQ5_CCUSTO,CQ5_ITEM, CQ5_MOEDA, 6")	      
     			cBuffer := StrTran(cBuffer, "GROUP BY CQ7_FILIAL , CQ7_CONTA , CQ7_CCUSTO , CQ7_ITEM , CQ7_CLVL , CQ7_MOEDA , SUBSTR ( CQ7_DATA , 1 , 6 )", "GROUP BY CQ7_FILIAL, CQ7_CONTA ,CQ7_CCUSTO,CQ7_ITEM,CQ7_CLVL, CQ7_MOEDA, 7")
     			cBuffer := StrTran(cBuffer, "GROUP BY CQ9_FILIAL , CQ9_IDENT , CQ9_CODIGO , CQ9_MOEDA , SUBSTR ( CQ9_DATA , 1 , 6 )", "GROUP BY CQ9_FILIAL, CQ9_IDENT ,CQ9_CODIGO , CQ9_MOEDA, 5")
			                                
			EndIf
			If Substr(AllTrim(cName),1,6) == "CTB209"
				cBuffer := StrTran(cBuffer, "GROUP BY CVX_FILIAL , CVX_CONFIG , CVX_MOEDA , CVX_TPSALD , SUBSTR ( CVX_DATA , 1 , 6 )", "GROUP BY CVX_FILIAL , CVX_CONFIG , CVX_MOEDA , CVX_TPSALD , 5")
			EndIf
		EndIf
		/*------------------------------------------------------------------------------
		Tratamento especifico na procedure MAT006 para os bancos INFORMIX 9.4       
		------------------------------------------------------------------------------*/
		If Trim(TcGetDb()) = 'INFORMIX' .And. Substr(AllTrim(cName),1,6) == "MAT006"
			cBuffer := StrTran(cBuffer, 'MAX ( SUBSTR ( B9_DATA , 1 , 8 ))', 'MAX ( B9_DATA ) ')
		EndIf

		/*------------------------------------------------
		 Efetua tratamento para o DB2 / AS400 / MySQL 
		------------------------------------------------*/
		If Trim(TcGetDb()) = 'DB2' .Or. lTop4AS400 .Or. Trim(TcGetDb()) = 'MYSQL'
			cBuffer	:= StrTran( cBuffer, 'set vfim_CUR  = 0 ;', 'set fim_CUR = 0;' )
			cBuffer	:= StrTran( cBuffer, "IF fim_CUR <> 1 THEN", "IF fim_CUR = 1 THEN")
		EndIf

		/*----------------------------------------------------------------------------------
		Tratamento especifico na procedure MAT007 para os bancos ORACLE/DB2/AS400/MYSQL 
		Ajuste necessario devido a falha de finalizacao do CURSOR: apos o seu termino   
		a variavel do cursor mantem o seu conteudo.                                     
		----------------------------------------------------------------------------------*/
		If Substr(AllTrim(cName),1,6) == "MAT007"
			If Trim(TcGetDb()) = 'ORACLE'
				cBuffer	:= StrTran( cBuffer, "CUR_A330INI%NOTFOUND1", "CUR_A330INI%NOTFOUND")
			ElseIf Trim(TcGetDb()) = 'DB2' .Or. Trim(TcGetDb()) = 'MYSQL'
				cBuffer	:= StrTran( cBuffer, "IF fim_CUR <> 1 THEN", "IF fim_CUR = 1 THEN")
			EndIf
		EndIf

		If Empty(cBuffer)
			Aadd( aErro, STR0071 + cName + '.I/O: ' + MSParseError()) //'Erro na compilação da procedure '
			Return
		EndIf
	EndIf

	/*---------------------------------------------------------------
	 Efetua tratamento para a MSDATEADD no DB2 com versao <= 9.5 
	---------------------------------------------------------------*/
	If Alltrim(TcGetDb()) == "DB2" .And. "MSDATEADD" $ cName
		aArea := GetArea()
		cQuery := "SELECT SERVICE_LEVEL, FIXPACK_NUM FROM TABLE(SYSPROC.ENV_GET_INST_INFO())"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasBD,.T.,.T.)
		If !(cAliasBD)->(EOF())
			If substr(alltrim((cAliasBD)->SERVICE_LEVEL), at("v",alltrim((cAliasBD)->SERVICE_LEVEL))+1, 3) <= "9.5"
				cBuffer := StrTran(cBuffer,	"SET VDATA = YEAR(VDATA)||RIGHT('0'||MONTH(VDATA),2)||RIGHT('0'||DAY(VDATA),2);",;
												"SET VDATA = SUBSTR(VDATA,7,4)||SUBSTR(VDATA,1,2)||SUBSTR(VDATA,4,2);")
			EndIf
		EndIf
		(cAliasBD)->(dbCloseArea())
		RestArea(aArea)
	EndIf

	Do While ("##" $ cBuffer)
		nPos := AT("##",cBuffer)
		lEmp := .F.
		lTab := .F.
		If (nPos > 1)
			If SubStr(cBuffer,nPos-1,1) == "_"   // Empresa
				lEmp := .T.
			EndIf
		EndIf
		If (nPos > 3)
			If SubStr(cBuffer,nPos+2,1) == "#"  // Tabela
				lTab := .T.
			EndIf
		EndIf
		If lEmp
			aProc[nCnt01] += SubStr(cBuffer,1,nPos-1)+SM0->M0_CODIGO
			cBuffer       := SubStr(cBuffer,nPos+2)
		ElseIf lTab
			cAlias := SubStr(cBuffer,nPos-3,3)
			dbSelectArea("SX2")
			If dbseek(cAlias) .And. !(cAlias$"TRT#TRB#TRX#TRA#TRW#TRC#TRD#TRJ#TRK")
				aProc[nCnt01] += SubStr(cBuffer,1,nPos-4)+Alltrim(SX2->X2_ARQUIVO)
				cBuffer       := SubStr(cBuffer,nPos+3)
				ChkFile(Alltrim(SX2->X2_CHAVE), .F.)
			ElseIf (cAlias$"TRT#TRB#TRX#TRA#TRW#SX2#TRC#TRD#TRK#TRJ")
				If AllTrim(cAlias) == "SX2"
					aProc[nCnt01] += SubStr(cBuffer,1,nPos-4)+cAlias+SM0->M0_CODIGO+"0"
				Else
					aProc[nCnt01] += SubStr(cBuffer,1,nPos-4)+cAlias+SM0->M0_CODIGO+Iif(cProcesso=="19" .or. cProcesso =="20","SP",cNomeTab)
				EndIf
				cBuffer       := SubStr(cBuffer,nPos+3)
			Else
				aProc[nCnt01] += SubStr(cBuffer,1,nPos+1)
				cBuffer       := SubStr(cBuffer,nPos+2)
			EndIf
		Else
			aProc[nCnt01] += SubStr(cBuffer, 1,nPos+1)
			cBuffer       := SubStr(cBuffer,nPos+2)
		EndIf
	EndDo
	aProc[nCnt01] += cBuffer

	// Inicia troca dos tipos char e varchar baseados em arquivos do siga
	cBuffer       := aProc[nCnt01]
	aProc[nCnt01] := ""

	// Sendo tool ou nao, ajusta sintaxe para AS400 com TOP4
	If lTop4AS400
		// Identifica se o TOP4 AS400 é o build novo, com tratamento ASCII
		If val(TCInternal(80)) >= 20081008
			lTop4ASASCII := .T.
		EndIf

		// Identifica nome do Schema ( Alias )
		cTOP400Alias := GetSrvProfString('DBALIAS','')
		If empty(cTOP400Alias)
			cTOP400Alias := GetSrvProfString('TOPALIAS','')
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOTVSDBACCESS','ALIAS','',GetAdv97())
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOPCONNECT','ALIAS','',GetAdv97())
		EndIf

		// Troca operadores
		cBuffer	:= StrTran( cBuffer, '||', ' CONCAT ' )
		cBuffer	:= StrTran( cBuffer, '!=', '<>' )

		// Se for criação de FUNCTION, deve ser especificado
		// LANGUAGE SQL NOT FENCED antes do BEGIN

		If !"LANGUAGE SQL"$upper(cBuffer)
			nPos3 := at("BEGIN",upper(cBuffer))
			If nPos3 > 0
				cBuffer	:= Stuff(cBuffer,nPos3,0,"LANGUAGE SQL NOT FENCED"+CRLF)
			EndIf
		EndIf

		// Localiza o begin novamente, e acrescenta o sort sequence
		// diferenciado para  o TOP4 AS400
		// Mas apenas coloca isso se for build antigo, antes do ASCII
		If !lTop4ASASCII
			nPos3 := at("BEGIN",upper(cBuffer))
			If nPos3 > 0
				cBuffer	:= Stuff(cBuffer,nPos3,0,"SET OPTION SRTSEQ = TOP40/TOPASCII"+CRLF)
			EndIf
		EndIf

		// Prefixa as chamadas de stored procedures com o nome do banco/alias atual
		cBuffer := UPstrtran(cBuffer,"CALL ","CALL "+cTOP400Alias+".")

		// Prefixa as chamadas de functions com o alias do banco (schema) atual
		aEval(a400Funcs , {|x| cBuffer := UPstrtran(cBuffer,x,cTOP400Alias+"."+x) } )

		// Remove os "COMMIT;" ... nao precisa no AS400 ...
		// Isolation Level já está *NONE ... se chamar COMMIT, ocorre erro no AS400
		cBuffer := UPstrtran(cBuffer,"COMMIT;","")

	EndIf

	dbSelectArea("SX3")
	dbSetOrder(2)

	Do While ("CHAR( '" $ Upper(cBuffer))
		nPos   := AT("CHAR( '", Upper(cBuffer)) + 7
		cCampo := ''
		aSeekFields:= {}
		LenCutText:= 0

		// Obtendo campos para consulta no dicionário
		For nPos2:= nPos to Len( cBuffer )
			LenCutText ++
			If substr( cBuffer, nPos2, 1) != "'"
				cCampo +=  substr( cBuffer, nPos2, 1)
			Else
				Exit
			EndIf
		Next nPos2

		cOrigCampo:= cCampo
		
		If At(",",cCampo) >0 .AND. At("+",cCampo) >0
			Aadd( aErro, STR0054 + ' ' + cOrigCampo + ' ' + STR0055 + ' ' + cName + ' ' + STR0056 ) //'Campo(s) ' ## ' declarado na procedure ' ## ' não localizado(s).'
			Return
		Else
			If At("+",cCampo) >0
				/* Retorna o tamanho da variavel, apos contatena-las*/
				nTam := SomaCampos(cCampo)
				If nTam <=0
					Aadd( aErro, STR0054 + ' ' + cOrigCampo + ' ' + STR0055 + ' ' + cName + ' ' + STR0056  ) //'Campo(s) ' ## ' declarado na procedure ' ## ' não localizado(s).'
					Return
				Else
					// Realizando troca do nome do campo pelo seu tamanho
					cBuffer:=	Substr( cBuffer, 1, nPos - 2 )+AllTrim(Str(nTam)) + ;
								Substr( cBuffer, nPos + LenCutText + 1, len(cBuffer) - nPos )
				EndIf
			Else
				/* Retorna o campo da lista com maior tamanho  */
				cCampo:= MaiorCampo(cCampo)
				/* Se o contador for maior que o tamanho do array nenhum campo foi localizado no SX3 */
				If Empty(cCampo)
					Aadd( aErro, STR0054 + ' ' + cOrigCampo + ' ' + STR0055 + ' ' + cName + ' ' + STR0056 ) //'Campo(s) ' ## ' declarado na procedure ' ## ' não localizado(s).'
					Return
				EndIf
		
				dbSeek( cCampo )
		
				// Realizando troca do nome do campo pelo seu tamanho
				cBuffer:=	Substr( cBuffer, 1, nPos - 2 )+AllTrim(Str(X3_TAMANHO)) + ;
							Substr( cBuffer, nPos + LenCutText + 1, len(cBuffer) - nPos )

			Endif

		EndIf

	EndDo
	aProc[nCnt01] += cBuffer
Next nCnt01 // loop nas procedures

If !SQLMgrFile( cName,SM0->M0_CODIGO,aProc,cData,cHora,cDialeto, cAssinat)
	AADD( aErro , STR0057 + ' ' + cName + Chr(10) + Chr(13) + STR0058 + ' ' + TCSqlError() ) //"Erro no Script  " ## "Erro TOP : "
EndIf

Return Nil

/*-----------------------------------------------------------------------------
Função    CheckFile  Autor Microsiga S/A           Data 14/07/2008
Descrição Verifica a necessidade de criação de arquivos/índices      
-----------------------------------------------------------------------------*/
Function CheckFile(cAlias,cArquivo)
Local aCampos := {}

If !TCCanOpen(cArquivo)
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek(cAlias)

	Do While !Eof() .And. X3_ARQUIVO == cAlias
		If X3_CONTEXT != "V"
			AADD(aCampos,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		EndIf
		DbSelectArea("SX3")
		DbSkip()
	EndDo
	DbCreate(cArquivo,aCampos,"TOPCONN")
EndIf
DbSelectArea("SX3")

Return Nil

/*-----------------------------------------------------------------------------
Função    SQLMgrFile Autor Microsiga S/A           Data 14/07/2008
Descrição Executa a instalação da stored procedure no banco          
-----------------------------------------------------------------------------*/
Function SQLMgrFile( cName, cCrrFil, aProc, cData, cHora, cDialeto, cAssinat)
Local cDropQry	  := ""
Local lBack       := .T.
Local cProc       := ""
Local nCnt01      := 0
Local nCaracter   := 32
Local xProc
Local aPtoEntrada := {	"MA330CP"		,;
						"M330INB2CP"	,;
						"M330INC2CP"	,;
						"MA280INB9CP"	,;
						"MA280INC2CP"	,;
						"M300SB8"		,;
						"M330CMU"		,;
						"MA330AL"		,;
						"MA280CON"		,;
						"MA330SEQ"		,;
						"ATFCONTA"		,;
						"ATFSINAL"		,;
						"ATFTIPO"		,;
						"ATFGRSLD"		,;
	                    "A30EMBRA"		,;
						"AF050CAL"		,;
						"AF050FPR"		,;
						"M280SB9"}

/*---------------------------------------------------------------------------
 Procedures que comecam com "MS" nao levam o numero da empresa no final do 
 nome, no oracle a mesma so pode ser enviada uma vez para o banco, sendo   
 assim eliminamos sua ida mais de uma vez.                                 
---------------------------------------------------------------------------*/

If Left(cName,2) = 'MS'
	
	If Ascan(aProcs,{|z|z[1] == cName}) > 0
		
		Return(lBack)
		
   EndIf
   
EndIf

If Left(cName,2) = 'MS'
	
	cName += "_"+ cCrrFil // adiciona a empresa ao nome da procedure TOOL
	If TCSPExist(cName)
		
		// Para alguns bancos como o ORACLE, DB2, CTREESQL e MySQL algumas procedures são na verdade "FUNCTION"
		// Postgres só tem funções, mas o MsParser reconhece o comando "DROP PROCEDURE", e o converte para o padrão do banco.
		If	(upper(cDialeto) = 'DB2' .and. ( 'MSDATEADD' $ cName .or. 'MSDATEDIFF' $ cName )) .or.;
			(upper(cDialeto) = 'CTR' .and. ( 'MSDATEADD' $ cName .or. 'MSDATEDIFF' $ cName .or. 'MSSTUFF' $ cName)) .or.;
			(upper(cDialeto) = 'MYS' .and. ( 'MSDATEADD' $ cName .or. 'MSDATEDIFF' $ cName .or. 'MSSTUFF' $ cName)) .or.;
			(upper(cDialeto) = 'ORA' .and. ( 'MSDATEADD' $ cName .or. 'MSDATEDIFF' $ cName .or. 'MSSTUFF' $ cName))
			
			cDropQry := "DROP FUNCTION " + cName
			
		Else
			
			cDropQry := "DROP PROCEDURE " + cName
			
		EndIf
		
		If TCSqlExec( cDropQry ) <> 0
			UserException( "Error on deinstall procedure/function: " + cName + " - Query: " + cDropQry + " - Error: " + TCSQLError() )
		EndIf
		
	EndIf
	
Else
	
	If TCSPExist(cName + "_" + cCrrFil)
		
		//Verifica se existe ponto de entrada no banco, caso exista, nao pode altera-la.
		If Ascan(aPtoEntrada,cName) > 0
			Return(lBack)
		EndIf
		
		cDropQry := "DROP PROCEDURE " + cName + "_" + cCrrFil
		
		If TCSqlExec( cDropQry ) <> 0
			UserException( "Error on deinstall procedure/function: " + cName + " - Query: " + cDropQry + " - Error: " + TCSQLError() )
		EndIf
		
	EndIf
	
EndIf

For nCnt01 := 1 To Len(aProc)
	
	/*------------------------------------------------------------------------------------
	 O tamanho do script passou de 64K para 128K
	 Motivo: o cTreeSQL e o OpenEdge utilizam o que se chama de "snippet Java", ou seja,
	 um codigo híbrido em JAVA e lingaguem SQL. Isso aumenta o tamanho da SP.
	------------------------------------------------------------------------------------*/
    If (lBack := (Len(cProc)+Len(aProc[nCnt01])) < ((128*1024)-128))
    	
    	cProc += Alltrim(aProc[nCnt01])
    	
   	EndIf
   	
Next nCnt01

xProc := ''
For nCnt01 := 1 to Len(cProc)
	
	nCaracter := asc(Substr(cProc,nCnt01,1))
	
	If nCaracter == 13
		
		xProc += ''
		
	ElseIf nCaracter == 10
		
		xProc +=chr(10)
		
	Else
		
		xProc += Subs(cProc,nCnt01,1)
		
	EndIf
	
Next nCnt01

// Executa o comando de instalação da SP
If lBack
	
	lBack := !(TCSqlExec(xProc) < 0)
	
EndIf

If !lBack
	
	Aadd( aErro, STR0059 + ' ' +cName )	 //'Erro ao instalar procedure '
	
Else

	/* -------------------------------------------------------------
		Atualiza tabela de versoes
	------------------------------------------------------------- */
	If Left(cName,2) == 'MS'
	
		CheckTOP_SP( cName, cData, cHora, cAssinat, cDialeto )
		
	Else
		
		CheckTOP_SP( cName+"_"+cCrrFil, cData, cHora, cAssinat, cDialeto )
		
	EndIf
	
EndIf

Return(lBack)

#ELSE

Function CFGX051()
	ApMsgStop(STR0007) //"Função disponível só para TopConnect"
Return

#ENDIF

/*-----------------------------------------------------------------------------
Função    AbreSx2    Autor Jaqueson Santos Lopes   Data 30/10/2000
Descrição Abre o SX2 de acordo com empresa no SMO.                   
-----------------------------------------------------------------------------*/
Static Function AbreSx2()
//Local cIndSx2
//Local cArqSx2

If SX2->(Used())
	dbSelectArea("SX2")
	dbCloseArea()
EndIf

OpenSxs(,,,,,"SX2","SX2")

Return Nil

/*-----------------------------------------------------------------------------
Função    AbreSM0    Autor Jaqueson Santos Lopes   Data 07/11/2000
Descrição Abre o SIGAMAT.EMP e carrega as empresas.                           
-----------------------------------------------------------------------------*/
Static Function AbreSM0()
Local oDlg2,nOpca := 1
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
Local nAt,oLbx
Local nSizeFil := 2

//-- Atualiza o conteúdo da filial
If FindFunction("FWSizeFilial")
	nSizeFil := FWSizeFilial()
EndIf

DbSelectArea("SM0")
DbGoTop()
Do While !Eof()
   If Ascan(aEmpres,{|z|z[2] == SM0->M0_CODIGO}) = 0
       Aadd(aEmpres,{"F",SM0->M0_CODIGO,SM0->M0_NOME,Pad(SM0->M0_CODFIL,nSizeFil)})
   EndIf
   dbSkip()
EndDo

DEFINE MSDIALOG oDlg2 FROM  170,19 TO 350,400 TITLE OemToAnsi(STR0060) PIXEL //"Selecao de Empresas"
DEFINE SBUTTON FROM 75, 160 TYPE 1 ACTION oDlg2:End() ENABLE OF oDlg2

@ 5,5 LISTBOX oLbx FIELDS HEADER "OK", STR0091, STR0092 SIZE 180,60 PIXEL OF oDlg2;
  ON DBLCLICK ( If( aEmpres[oLbx:nAt,1] == "T" , aEmpres[oLbx:nAt,1] := "F" , ;
                    aEmpres[oLbx:nAt,1] := "T" ) , oLbx:Refresh() )
oLbx:SetArray( aEmpres )
oLbx:bLine := { || {If(aEmpres[oLbx:nAt,1]=="T",oOk,oNo),aEmpres[oLbx:nAt,2],aEmpres[oLbx:nAt,3]} }
oLbx:SetFocus()
ACTIVATE MSDIALOG oDlg2 CENTERED

Return Nil

/*-----------------------------------------------------------------------------
Função    CRIATMPDB  Autor Jaqueson S. Lopes       Data 26/06/2000
Descrição Esta Função e responsavel pela criacao de um arquivo, sendo este 
          baseado estruturalmente em um alias do Siga ja existente no SX3 
          mais a inclusao de alguns campos definidos passa do como parametro. 
          Somente usado para controle em stored procedures.                                                
-----------------------------------------------------------------------------*/
Function CRIATMPDB(cAlias,cArquivo,aCamposAd,lRecValid)
Local aCampos := {}
Local n

Default cAlias := ""

If TCCanOpen(cArquivo)
	cString := "DROP TABLE "+cArquivo
	TCSqlExec(cString)
EndIf

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias)

/*---------------------------------------------------------------------------
 Adiciono campos que serão criados.                                        
---------------------------------------------------------------------------*/
Do While !Eof() .And. X3_ARQUIVO == cAlias
	If X3_CONTEXT != "V"
		AADD(aCampos,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
	EndIf
	DbSelectArea("SX3")
	DbSkip()
EndDo

/*---------------------------------------------------------------------------
 Inclusao dos Campos adicionais passados como parametros.                  
---------------------------------------------------------------------------*/
For n:=1 to Len(aCamposAd)
    AADD(aCampos,{aCamposAd[n,1],aCamposAd[n,2],aCamposAd[n,3],aCamposAd[n,4]})
Next n

If lRecValid
	FWDBCreate(cArquivo,aCampos,"TOPCONN",.T.)
Else
	DbCreate(cArquivo,aCampos,"TOPCONN")
EndIf

DbSelectArea("SX3")
Return Nil

/*-----------------------------------------------------------------------------
Função    ExecAdvpl  Autor Emerson Tobar           Data 02/01/2002
Descrição Localiza e executa um bloco de instrucao Advpl dentro do   
          corpo da procedure.                                        
-----------------------------------------------------------------------------*/
Static Function ExecAdvpl( cString )
Local cb
Local cBufAux

cb := __compstr( cString )
cBufAux := __runcb( cb )

Return cBufAux

/*-----------------------------------------------------------------------------
Programa  CFGX051   Autor  Ricardo Goncalves    Data   03/22/02   
Descrição Verifica a versão da procedure                               
-----------------------------------------------------------------------------*/
Function CheckTOP_SP( cProcName, cData, cHora, cAssinat, cDialeto )
Local cStatement	:= ''
Local cQuery 		:= "select * from TOP_SP where SP_NOME = '" + cProcName +"' and SP_VERSAO = '" + cVersao + "' "

If !TcCanOpen( "TOP_SP" )
	If cDialeto == 'ora'
		TCSqlExec('CREATE TABLE TOP_SP ( SP_NOME CHAR( 20 ), SP_VERSAO CHAR(20), SP_DATA CHAR(08), SP_HORA CHAR(08), SP_ASSINAT CHAR(03) )' )
	Else
		TCSqlExec('CREATE TABLE TOP_SP ( SP_NOME VARCHAR( 20 ), SP_VERSAO VARCHAR(20), SP_DATA VARCHAR(08), SP_HORA VARCHAR(08), SP_ASSINAT VARCHAR(03) )' )
	EndIf
EndIf

If Upper(Alltrim(TCGetDB())) == 'SYBASE'
	cStatement := 'ALTER TABLE TOP_SP add constraint TOP_SP1 unique nonclustered (SP_NOME asc, SP_VERSAO asc, SP_DATA asc, SP_HORA asc)'
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TOPSP' )

If Empty(cAssinat)
	cAssinat:='000'
EndIf
If Eof()
	cStatement:= "INSERT INTO TOP_SP ( SP_NOME, SP_VERSAO, SP_DATA, SP_HORA, SP_ASSINAT ) "
	cStatement+= "     VALUES ( '"+cProcName+"', '"+cVersao+"', '"+cData+"', '"+cHora+"', '"+cAssinat+"' )"
Else
	cStatement:= "UPDATE TOP_SP "
	cStatement+= "   SET SP_VERSAO = '" + cVersao   + "',"
	cStatement+= "       SP_DATA   = '" + cData     + "',"
	cStatement+= "       SP_HORA   = '" + cHora     + "',"
	cStatement+= "       SP_ASSINAT= '" + cAssinat  + "' "
	cStatement+= " WHERE SP_NOME   = '" + cProcName + "' AND "
	cStatement+= "       SP_VERSAO = '" + cVersao   + "'"
EndIf

TCSqlExec( cStatement )

TOPSP->(dbCloseArea())

Return Nil

/*-----------------------------------------------------------------------------
Programa  ShowMemo  Autor  Ricardo Gonçalves    Data   05/16/01   
Descrição Mostra o memo na tela                                      
-----------------------------------------------------------------------------*/
Function ShowMemo( cFileName )
Local cMemo	:= ''
Local nEOF	:= 0
Local oMemo
Local oDlg
Local nHandle
Local oFont:= TFont():New('Courier New',,-11,.T.)

If !File( cFileName )
	ApMsgStop( STR0061 + ' ' + cFileName + ' ' +STR0062 ) //'Arquivo ' ## ' não localizado!'
	Return
EndIf

If (nHandle:= FOpen( cFileName, 0 )) >= 0 // aberto somente para leitura

	nEOF:= FSeek( nHandle, 0, 2 ) // obtem tamanho do arquivo em bytes
	cMemo:= Space( nEOF )

	FSeek( nHandle, 0, 0 )
	FRead( nHandle, @cMemo, nEOF - 1 )

	FClose( nHandle )
Else
	ApMsgStop( STR0063 ) //'Erro ao abrir o arquivo'
EndIf

DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0064) From 0,0 To 540,800 OF oMainWnd PIXEL //'Listar Campos'
	tButton():New(04,365,'Fechar',oDlg,{||oDlg:End()},32,14,,,,.T.)

	oMemo:= tMultiget():New(04,04,{|u|if(Pcount()>0,cMemo:=u,cMemo)},oDlg,355, 260,oFont,,,,,.T.)
	oMemo:lWordWrap:= .F.
	oMemo:EnableHScroll( .T. )
	oMemo:EnableVScroll( .T. )

ACTIVATE MSDIALOG oDlg CENTER

Return Nil

/*-----------------------------------------------------------------------------
Programa  ExcluiSP  Autor  Emerson Tobar        Data   21/12/05   
Descrição Exclui as procedures da empresa selecionada                
-----------------------------------------------------------------------------*/
Static Function ExcluiSP(lEnd, aProcessos)
Local cQuery       := ""
Local cNome        := ""
Local cGetDB       := TCGetDB()
Local cTOP400Alias := ""
Local n1           := 0
Local n2           := 0
Local cNomeTab     := "0_SP"
Local aPtoEntrada  := {	{"MA330CP"    ,'19'},;
							{"M330INB2CP" ,'19'},;
							{"M330INC2CP" ,'19'},;
							{"MA280INB9CP",'17'},;
							{"MA280INC2CP",'17'},;
							{"M300SB8"    ,'18'},;
							{"M330CMU"    ,'19'},;
							{"MA330AL"    ,'19'},;
							{"MA280CON"   ,'17'},;
							{"MA330SEQ"   ,'19'},;
							{"ATFCONTA"   ,'11'},;
							{"ATFSINAL"   ,'11'},;
							{"ATFTIPO"    ,'11'},;
							{"ATFGRSLD"   ,'11'},;
							{"A30EMBRA"   ,'11'},;
							{"AF050CAL"   ,'11'},;
							{"AF050FPR"   ,'11'},;
							{"M280SB9"    ,'17'}}
/*--------------------------------------------------------------------------------------------------
 MV_DROPPE  - Parâmetro criado para apagar os pontos de entrada utilizados pelas stored procedures.                                                  
--------------------------------------------------------------------------------------------------*/
Local lDropPE     := GetMv("MV_DROPPE",.F.,.F.)
Local nCount      := 0

Default lEnd      := .F.
Default aProcessos:= {}

AbreSM0()

If cGetDB == "AS400" .or. cGetDB == "DB2/400"  // remover posteriormente "AS400"
	// Identifica nome do Schema ( Alias )
	cTOP400Alias := GetSrvProfString('DBALIAS','')
	If empty(cTOP400Alias)
		cTOP400Alias := GetSrvProfString('TOPALIAS','')
	EndIf
	If empty(cTOP400Alias)
		cTOP400Alias := GetPvProfString('TOTVSDBACCESS','ALIAS','',GetAdv97())
	EndIf
	If empty(cTOP400Alias)
		cTOP400Alias := GetPvProfString('TOPCONNECT','ALIAS','',GetAdv97())
	EndIf
EndIf

For n1 := 1 To Len( aEmpres )
	nCount := Len(aProcessos)
	ProcRegua(nCount)

	If aEmpres[ n1, 1 ] = "F"
		Loop
	EndIf

	For n2 := 1 to Len(aProcessos)

		IncProc(STR0102 + aProcessos[n2,2] + " - " + STR0016 + aEmpres[n1,2])

		/* Metodo novo: somente as SP's do processo serao desinstaladas do banco */
		If lDropPE
			/* Verifica a desinstalação dos PE's associados a cada processo */
			If cGetDB == "ORACLE"
				cQuery := "select SP_NOME from TOP_SP where SP_VERSAO = '" + cVersao + "' and ( RTrim( SP_NOME ) like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + "' or RTrim( SP_NOME ) in ("+GetPEProc(aPtoEntrada, aProcessos[n2,2], aEmpres[ n1, 2 ])+") ) "
			ElseIf cGetDB == "AS400" .or. cGetDB == "DB2/400"  // remover posteriormente "AS400"
				cQuery := "select SP_NOME from " + cTOP400Alias + ".TOP_SP where SP_VERSAO = '"+cVersao+"' and ( SP_NOME like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + " %' or SP_NOME in ("+GetPEProc(aPtoEntrada, aProcessos[n2,2], aEmpres[ n1, 2 ])+") ) "
			ElseIf cGetDB == "POSTGRES"
				cQuery := "select SP_NOME from TOP_SP where SP_VERSAO = '" + cVersao + "' and ( SP_NOME like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + "%' or SP_NOME in ("+GetPEProc(aPtoEntrada, aProcessos[n2,2], aEmpres[ n1, 2 ])+") ) "
			Else
				cQuery := "select SP_NOME from TOP_SP where SP_VERSAO = '" + cVersao + "' and ( SP_NOME like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + "' or SP_NOME in ("+GetPEProc(aPtoEntrada, aProcessos[n2,2], aEmpres[ n1, 2 ])+") ) "
			EndIf
		Else
			/* Os PE's devem permanecer na base */
			If cGetDB == "ORACLE"
				cQuery := "select SP_NOME from TOP_SP where SP_VERSAO = '" + cVersao + "' and RTrim( SP_NOME ) like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + "' "
			ElseIf cGetDB == "AS400" .or. cGetDB == "DB2/400"  // remover posteriormente "AS400"
				cQuery := "select SP_NOME from " + cTOP400Alias + ".TOP_SP where SP_VERSAO = '"+cVersao+"' and SP_NOME like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + " %' "
			ElseIf cGetDB == "POSTGRES"
				cQuery := "select SP_NOME from TOP_SP where SP_VERSAO = '" + cVersao + "' and SP_NOME like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + "%' "
			Else
				cQuery := "select SP_NOME from TOP_SP where SP_VERSAO = '" + cVersao + "' and SP_NOME like '%_" + aProcessos[n2,2] + "_" + aEmpres[ n1, 2 ] + "' "
			EndIf
		EndIf

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TOPSP" )

		Do While !TOPSP->( Eof() )
			cNome := Alltrim( TOPSP->SP_NOME )
			If TCSPExist( cNome )
				If cGetDB == "AS400"  .or. cGetDB == "DB2/400"  // remover posteriormente "AS400"
					If (Substring(cNome, 1, 10) = "MSDATEDIFF"  .or. Substring(cNome, 1, 9) = "MSDATEADD")
						cQuery := "DROP FUNCTION " + cTOP400Alias +  "." + Upper(cNome)
					Else
						cQuery := "DROP PROCEDURE " + cTOP400Alias +  "." +  Upper(cNome)
					EndIf
				Else
					// Para alguns bancos como o ORACLE, DB2, CTREESQL e MySQL algumas procedures são na verdade "FUNCTION"
					// Postgres só tem funções, mas o MsParser reconhece o comando "DROP PROCEDURE", e o converte para o padrão do banco.
					If	(cGetDB == "DB2"      .and. (Substring(cNome, 1, 10) = "MSDATEDIFF"  .or. Substring(cNome, 1, 9) = "MSDATEADD")) .Or.;
						(cGetDB == "CTREESQL" .and. (Substring(cNome, 1, 10) = "MSDATEDIFF"  .or. Substring(cNome, 1, 9) = "MSDATEADD" .or. Substring(cNome, 1, 7) = "MSSTUFF")) .or.;
						(cGetDB == "MYSQL"    .and. (Substring(cNome, 1, 10) = "MSDATEDIFF"  .or. Substring(cNome, 1, 9) = "MSDATEADD" .or. Substring(cNome, 1, 7) = "MSSTUFF")) .or.;
						(cGetDB == "ORACLE"   .and. (Substring(cNome, 1, 10) = "MSDATEDIFF"  .or. Substring(cNome, 1, 9) = "MSDATEADD" .or. Substring(cNome, 1, 7) = "MSSTUFF"))
						cQuery := "DROP FUNCTION " + cNome
					Else
						cQuery := "drop procedure " + iif( cGetDB == "INFORMIX", Lower( cNome ), cNome )
					EndIf
				EndIf
				If TCSqlExec( cQuery ) <> 0
					UserException( "Error on deinstall procedure/function: " + cNome + " - Query: " + cQuery + " - Error: " + TCSQLError() )
				EndIf
			EndIf
			
			If cGetDB == "AS400" .or. cGetDB == "DB2/400"  // remover posteriormente "AS400"
				cQuery := "delete from " + cTOP400Alias +  ".TOP_SP where SP_NOME = '" + cNome + "' and SP_VERSAO = '" + cVersao + "' "
			Else
				cQuery := "delete from TOP_SP where SP_NOME = '" + cNome + "' and SP_VERSAO = '" + cVersao + "' "
			EndIf
			If TCSqlExec( cQuery ) <> 0
				UserException( "Error updating table TOP_SP - procedure/function: " + cNome + " - Query: " + cQuery + " - Error: " + TCSQLError() )
			EndIf
			TOPSP->( dbSkip() )
		EndDo
		TOPSP->( dbCloseArea() )

		/*--------------------------------------------------------------------
		 Tratamento para exclusao das Stored procedures MAT014 e MAT015,
		 caso exista na base, pois não são mais utilizadas.
		--------------------------------------------------------------------*/
		If TCSPExist( 'MAT014_'+aEmpres[ n1, 2 ] )
			If cGetDB == "AS400" .or. cGetDB == "DB2/400"  // remover posteriormente "AS400"
				cQuery := "DROP PROCEDURE " + cTOP400Alias +  ".MAT014_"+aEmpres[ n1, 2 ]
			Else
				cQuery := "drop procedure " + iif( cGetDB == "INFORMIX", Lower( 'MAT014_'+aEmpres[ n1, 2 ] ), 'MAT014_'+aEmpres[ n1, 2 ] )
			EndIf
			If TCSqlExec( cQuery ) <> 0
				UserException( "Error on deinstall procedure - " + 'MAT014_'+aEmpres[ n1, 2 ] + " - Query: " + cQuery + " - Error: " + TCSQLError() )
			EndIf
		EndIf

		If TCSPExist( 'MAT015_'+aEmpres[ n1, 2 ] )
			If cGetDB == "AS400" .or. cGetDB == "DB2/400"  // remover posteriormente "AS400"
				cQuery := "DROP PROCEDURE " + cTOP400Alias +  ".MAT015_"+aEmpres[ n1, 2 ]
			Else
				cQuery := "drop procedure " + iif( cGetDB == "INFORMIX", Lower( 'MAT015_'+aEmpres[ n1, 2 ] ), 'MAT015_'+aEmpres[ n1, 2 ] )
			EndIf
			If TCSqlExec( cQuery ) <> 0
				UserException( "Error on deinstall procedure - " + 'MAT015_'+aEmpres[ n1, 2 ]  + " - Query: " + cQuery + " - Error: " + TCSQLError() )
			EndIf
		EndIf

		/*----------------------------------------------------------------
		 Apaga Arquivos de Trabalho - Classe "TR"                     
		----------------------------------------------------------------*/
		// Tabelas temporárias da Atualizacao de Saldos ON-LINE (CTBXFUN) - Processo 04
		If aProcessos[n2,2] == '04' .or. aProcessos[n2,2] == '06'
			If TcCanOpen("TRW"+aEmpres[n1,2]+cNomeTab)
				TcDelFile("TRW"+aEmpres[n1,2]+cNomeTab)
			EndIf
		EndIf

		// Tabelas temporárias da virada de saldos (MATA280) - Processo 17
		If aProcessos[n2,2] == '17'
			If TcCanOpen("TRC"+aEmpres[n1,2]+cNomeTab)
				TcDelFile("TRC"+aEmpres[n1,2]+cNomeTab)
			EndIf
			If TcCanOpen("TRJ"+aEmpres[n1,2]+cNomeTab)
				TcDelFile("TRJ"+aEmpres[n1,2]+cNomeTab)
			EndIf
			If TcCanOpen("TRK"+aEmpres[n1,2]+cNomeTab)
				TcDelFile("TRK"+aEmpres[n1,2]+cNomeTab)
			EndIf
		EndIf

		// Tabelas temporárias do recálculo (MATA330) - Processo 19
		If aProcessos[n2,2] == '19'
			If TcCanOpen("TRA"+aEmpres[n1,2]+"SP")
				TcDelFile("TRA"+aEmpres[n1,2]+"SP")
			EndIf
			If TcCanOpen("TRB"+aEmpres[n1,2]+"SP")
				TcDelFile("TRB"+aEmpres[n1,2]+"SP")
			EndIf
			// caso a procedure "MAT005_20_nn" exista, significa que a tabela TRBnnSG1 nao pode ser apagada
			If !TCSPExist( 'MAT005_20_'+aEmpres[n1,2] )
				If TcCanOpen("TRB"+aEmpres[n1,2]+"SPSG1")
					TcDelFile("TRB"+aEmpres[n1,2]+"SPSG1")
				EndIf
			EndIf
			If TcCanOpen("TRD"+aEmpres[n1,2]+"SP")
				TcDelFile("TRD"+aEmpres[n1,2]+"SP")
			EndIf
			If TcCanOpen("TRT"+aEmpres[n1,2]+"SP")
				TcDelFile("TRT"+aEmpres[n1,2]+"SP")
			EndIf
			If TcCanOpen("TRX"+aEmpres[n1,2]+"SP")
				TcDelFile("TRX"+aEmpres[n1,2]+"SP")
			EndIf
		EndIf

		// Tabelas temporárias do Cálculo do custo de reposição (MATA320) - Processo 20
		If aProcessos[n2,2] == '20'
			// caso a procedure "MAT005_19_nn" exista, significa que a tabela TRBnnSG1 nao pode ser apagada
			If !TCSPExist( 'MAT005_19_'+aEmpres[n1,2] )
				If TcCanOpen("TRB"+aEmpres[n1,2]+"SPSG1")
					TcDelFile("TRB"+aEmpres[n1,2]+"SPSG1")
				EndIf
			EndIf
		EndIf
	Next n2 // Loop nos processos
Next n1	// Loop nas empresas

ApMsgInfo( STR0020, STR0077) //'Processo Concluido c/Sucesso!', "Atenção"

Return Nil

/*--------------------------------------------------------------------------------
Programa  ChkCpoTop_SP Autor  Marcelo Pimentel     Data   23/07/07   
Descrição Verifica se existe o campo SP_ASSINAT: controle de assinatura entre o 
          programa fonte ADVPL e a stored procedure                     
--------------------------------------------------------------------------------*/
Function ChkCpoTop_SP(cCpo,cDataName)
Local lRet		:= .F.
Local cQuery	:= ""
Local cTOP400Alias	:= ""

Do Case
	Case (cDataName $ "MSSQL/MSSQL7/SYBASE")
		cQuery	:= "select syscolumns.name "
		cQuery	+=  " from syscolumns,sysobjects "
		cQuery	+= " where sysobjects.name = 'TOP_SP' "
		cQuery	+=   " and syscolumns.id   = sysobjects.id "
		cQuery	+=   " and syscolumns.name = '" + cCpo + "'"
		
	Case (cDataName == "ORACLE")
		cQuery	:= "select column_name "
		cQuery	+=  " from user_tab_columns "
		cQuery	+= " where table_name = 'TOP_SP' "
		cQuery	+=   " and column_name =  '" + cCpo + "'"
		
	Case (cDataName == "DB2")
		cQuery	:= "select column_name "
		cQuery	+=  " from sysibm.columns "
		cQuery	+= " where table_name  = 'TOP_SP' "
		cQuery	+=   " and column_name = '" + cCpo + "'"
		
	Case (cDataName == "INFORMIX")
		cQuery	:= "select syscolumns.colname "
		cQuery	+=  " from systables,syscolumns "
		cQuery	+= " where systables.tabname  = 'top_sp'"
		cQuery	+=   " and systables.tabid    = syscolumns.tabid "
		cQuery	+=   " and syscolumns.colname = '" + lower(cCpo) + "'"
		
	Case ((cDataName == "AS400") .or. (cDataName == "DB2/400"))  // remover posteriormente "AS400"
		cTOP400Alias := GetSrvProfString('DBALIAS','')
		If empty(cTOP400Alias)
			cTOP400Alias := GetSrvProfString('TOPALIAS','')
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOTVSDBACCESS','ALIAS','',GetAdv97())
		EndIf
		If empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOPCONNECT','ALIAS','',GetAdv97())
		EndIf
		
		cQuery	:= "select column_name "
		cQuery	+= " from " + cTOP400Alias + ".SYSCOLUMNS as coluna"
		cQuery  += " where table_name = 'TOP_SP'"
		cQuery  += " and column_name = '" + cCpo + "'"
		
	Case (cDataName == "CTREESQL")
		cQuery	:= "select col "
		cQuery	+=  " from syscolumns "
		cQuery	+= " where tbl  = 'top_sp' "
		cQuery	+=   " and col = '" + lower(cCpo) + "'"
		
	Case (cDataName == "OPENEDGE")
		cQuery	:= "select col "
		cQuery	+=  " from sysprogress.syscolumns "
		cQuery	+= " where tbl = 'top_sp' "
		cQuery	+=   " and col = '" + lower(cCpo) + "'"
		
	Case (cDataName == "MYSQL")
		cQuery  := "select column_name " 
 		cQuery  +=  " from information_schema.columns " 
		cQuery  += " where table_name  = 'TOP_SP' "
		cQuery  +=   " and column_name = '" + lower(cCpo) + "'"
		
	Case (cDataName == "POSTGRES")
		cQuery  := "select column_name " 
 		cQuery  +=  " from information_schema.columns " 
		cQuery  += " where table_name  = 'top_sp' "
		cQuery  +=   " and column_name = '" + lower(cCpo) + "'"
		
	Otherwise
		
		conout("WARNING : ChkCpoTop_SP : DATABASE ["+cDataName+"] NOT SUPPORTED")
		
EndCase

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), 'TOPSPCPO' )
lRet	:= TOPSPCPO->(Eof())
TOPSPCPO->(dbCloseArea())

Return lRet

/*--------------------------------------------------------------------------------
Programa  ConsultProc  Autor  Marcelo Pimentel     Data   28/11/07   
Descrição Consulta no controle de stored procedures versus programas associados                                                     
--------------------------------------------------------------------------------*/
Function ConsultProc()
Local cQuery	   := ''
Local cNome		   := ''
Local cDescEmp     := ''
Local cDescFil     := ''
Local nPos		   := 0
Local aProcBk      := {}
Local aProcessos   := {}
Local aButtons     := {}
Local nC		   := 0
Local aSizeAut     := MsAdvSize(,.F.,400)
Local aInfo 	   := {}
Local aPosGet	   := {}
Local aPosObj	   := {}
Local cEmp		   := cEmpAnt
Local cTOP400Alias := ""
Local cDataName	   := Tcgetdb()
Local oAmarelo     := LoadBitmap( GetResources(), "BR_AMARELO" )
Local oVerde       := LoadBitmap( GetResources(), "BR_VERDE" )
Local oVermelho    := LoadBitmap( GetResources(), "BR_VERMELHO" )
Local oProcess
Local oFont
Local oDlg

/*----------------------------------------------------------------
 Montagem das variaveis do cabecalho                          
----------------------------------------------------------------*/
aAdd(aButtons, {'SVM',{||CFGX051LEG()}, STR0095, STR0095}) //"Exibe a legenda da rotina"

/*---------------------------------------------------------------------------
 Verifica a existencia do campo SP_ASSINAT                                 
---------------------------------------------------------------------------*/
If ChkCpoTOP_SP("SP_ASSINAT",Alltrim(upper(Tcgetdb())))
	If cDataName == "ORACLE"
		TCSqlExec( "ALTER TABLE TOP_SP ADD SP_ASSINAT CHAR(03)" )
	ElseIf cDataName == "AS400" .or. cDataName == "DB2/400"  // remover posteriormente "AS400"
		// Identifica nome do Schema ( Alias )
		cTOP400Alias := GetSrvProfString('DBALIAS','')
		If Empty(cTOP400Alias)
			cTOP400Alias := GetSrvProfString('TOPALIAS','')
		EndIf
		If Empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOTVSDBACCESS','ALIAS','',GetAdv97())
		EndIf
		If Empty(cTOP400Alias)
			cTOP400Alias := GetPvProfString('TOPCONNECT','ALIAS','',GetAdv97())
		EndIf

		TCSqlExec( "ALTER TABLE " + cTOP400Alias + ".TOP_SP ADD SP_ASSINAT CHAR(03)" )
	Else
		TCSqlExec( "ALTER TABLE TOP_SP ADD SP_ASSINAT VARCHAR(03)" )
	EndIf
EndIf

// Carrega os processos em um vetor para posterior exibicao
LoadProcs(aProcBk)

// Adiciona o codigo do processo ao vetor na ordem correta para exibicao na consulta
For nC := 1 to Len(aProcBk)
	aAdd( aProcessos, {F_Vermelho,aProcBk[nC,2],aProcBk[nC,7],aProcBk[nC,3],aProcBk[nC,4],aProcBk[nC,5],aProcBk[nC,6],aProcBk[nC,7]} )
Next nC

If cDataName == "AS400" .or. cDataName == "DB2/400"  // remover posteriormente "AS400"
	// Identifica nome do Schema ( Alias )
	cTOP400Alias := GetSrvProfString('DBALIAS','')
	If empty(cTOP400Alias)
		cTOP400Alias := GetSrvProfString('TOPALIAS','')
	EndIf
	If empty(cTOP400Alias)
		cTOP400Alias := GetPvProfString('TOTVSDBACCESS','ALIAS','',GetAdv97())
	EndIf
	If empty(cTOP400Alias)
		cTOP400Alias := GetPvProfString('TOPCONNECT','ALIAS','',GetAdv97())
	EndIf

	cQuery := "select SP_NOME,SP_ASSINAT from " + cTOP400Alias + ".TOP_SP where SP_VERSAO = '" + cVersao + "' and RTrim( SP_NOME ) like '%_" + cEmp + "'""
Else
	cQuery := "select SP_NOME,SP_ASSINAT from TOP_SP where SP_VERSAO = '" + cVersao + If(Upper(Trim(TcGetDb())) = "INFORMIX","' and Trim( SP_NOME ) like '%_","' and RTrim( SP_NOME ) like '%_") + cEmp + "'""
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TOPSP" )
Do While !TOPSP->( Eof() )
	cNome := Substr(TOPSP->SP_NOME,1,Len(AllTrim(TOPSP->SP_NOME))-3)
	nPos := Ascan(aProcessos, {|x| AllTrim(x[7])==cNome } )

	If nPos > 0
		For nC := 1 To Len(aProcessos)
			If aProcessos[nC,7] == aProcessos[nPos,7]
				aProcessos[nC,1] := iIf( TOPSP->SP_ASSINAT == aProcessos[nC,5], F_Verde, F_Amarelo )
				aProcessos[nC,4] := TOPSP->SP_ASSINAT
				If aProcessos[nC,5] <> NIL
					If TOPSP->SP_ASSINAT <> aProcessos[nC,5]
						aProcessos[nC,6] := iIf(  TOPSP->SP_ASSINAT > aProcessos[nC,5], STR0044, STR0089) //'Rotina desatualizada'###'Processo desatualizado'
					Else
						aProcessos[nC,6] := 'Ok'
					EndIf
				Else
					aProcessos[nC,5] := STR0044	// Rotina desatualizada.
				EndIf
			EndIf
		Next nC
	EndIf
	TOPSP->( dbSkip() )
EndDo

cDescEmp  := STR0065 + cEmpAnt + " - " + AllTrim(Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_NOME")) //"Empresa: "
cDescFil  := STR0066 + cFilAnt + " - " + AllTrim(Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL")) //"Filial: "

aObjects := {}
AAdd( aObjects, { 100, 100, .T. , .T. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    75, .T., .F. } )
aInfo 	:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(	aSizeAut[3]-aSizeAut[1]	,;
						305						,;
						{	{050,050,320,610}	,;
							{009,006,500,008}	,;
							{015,006,500,008}	,;
							{021,006,500,008}	,;
							{027,006,500,008}	,;
							{034,006}			,;
							{014,140,040,040,040,270,95} } )

DEFINE MSDIALOG oDlg TITLE STR0100 From aPosGet[1][1],aPosGet[1][2] To aPosGet[1][3],aPosGet[1][4] PIXEL	//"Controle de Assinaturas para Stored Procedures x Programas Associados"
oDlg:lCentered := .T.

DEFINE FONT oFont NAME "MS Sans SerIf" SIZE 0, -9 BOLD

@ aPosGet[2][1],aPosGet[2][2] SAY STR0096 SIZE aPosGet[2][3],aPosGet[2][4] OF oDlg PIXEL FONT oFont	// "Consulta utilizada para garantir a compatibilidade entre Stored Procedure e Rotinas Associadas"
@ aPosGet[3][1],aPosGet[3][2] SAY STR0097 SIZE aPosGet[3][3],aPosGet[3][4] OF oDlg PIXEL FONT oFont	// "VerIfique abaixo as informações sobre as rotinas e suas respectivas stored procedures."
@ aPosGet[4][1],aPosGet[4][2] SAY STR0069 + cVersao +" / "+ STR0090 + DTOC(STOD(STR(CFGX051_V(),8))) + ' ' +STR0070 + TCGetDB() SIZE aPosGet[4][3],aPosGet[4][4] OF oDlg PIXEL  // "Versão: MP8.11 / Data do Instalador: " #### " / Top DataBase: "
@ aPosGet[5][1],aPosGet[5][2] SAY cDescEmp + " / " + cDescFil SIZE aPosGet[5][3],aPosGet[5][4] OF oDlg PIXEL

@ aPosGet[6][1],aPosGet[6][2] LISTBOX oProcess FIELDS HEADER " ", STR0049, STR0083, STR0098, STR0051, STR0052 FIELDSIZES aPosGet[7][1],aPosGet[7][2]-60,aPosGet[7][3]-30,aPosGet[7][3],aPosGet[7][4],aPosGet[7][5] SIZE aPosGet[7][6],aPosGet[7][7] PIXEL OF oDlg		//"Descrição das Rotinas"###"Assinatura Procedure"###"Assinatura Rotina"###"Status"

If Len(aProcessos) == 0
	aadd(aProcessos,{.T.,'','','','',''})
EndIf

aProcessos := ASort( aProcessos,,,{ |x,y| x[8] < y[8] } )

oProcess:SetArray(aProcessos)
oProcess:bLine := {|| {IIf(aProcessos[oProcess:nAt,1]==F_Verde,oVerde,IIf(aProcessos[oProcess:nAt,1]==F_Vermelho,oVermelho,oAmarelo)),aProcessos[oProcess:nAt,2],aProcessos[oProcess:nAt,3],aProcessos[oProcess:nAt,4],aProcessos[oProcess:nAt,5],aProcessos[oProcess:nAt,6]} }
oProcess:Refresh()
oProcess:GoTop()

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg, {|| oDlg:End() },{|| oDlg:End()},, aButtons ) )
TOPSP->(dbCloseArea())
Return .T.

/*--------------------------------------------------------------------------------
Programa  InsertPutSql Autor  Marcelo Pimentel     Data   16/10/07   
Descrição Inclui o tratamento inserção múltipla: 
          - O tratamento é feito de maneira específica para cada tipo de banco                                              
--------------------------------------------------------------------------------*/
Function InsertPutSql( cDataName, cBuffer )
Local cBufferAux 	:= ""
Local nPTratRec		:= 0
Local nPos			:= 0
Local cQuery		:= ""
Local cVersao		:= ""
Local nVersao		:= 8

If 'MSSQL' $ cDataName
	//Verifica a versao do SQL SERVER
	//O tratamento de Insert NAO funciona para SQL SERVER 2000, o PK Violation eh um erro fatal e nao ha tratamento.
	//Funciona para SQL SERVER 2005.
	cQuery :=" SELECT CONVERT(VARCHAR,SERVERPROPERTY('PRODUCTVERSION')) AS INFORMATION "
	cVersao := MpSysExecScalar(cQuery,"INFORMATION")
	cVersao := SubStr(cVersao,1,At('.',cVersao)-1)
	nVersao	:= Val(cVersao)

	If nVersao >= 9
		Do While ("SET @INS_INI  = " $ upper(cBuffer))
			nPTratRec	:= AT("SET @INS_INI  =", upper(cBuffer))
			nPosFim2	:= AT("SET @INS_FIM  = 1", upper(cBuffer))
			cCampo		:= ""
			nPos		:= 0
			nPosFim		:= 0
			//Retorna a variavel recno a ser aplicada no insert
			For nPos := nPTratRec+16 to Len( cBuffer )
				If substr( cBuffer, nPos, 1) = " "
					nPosFim	:= nPos+2
					EXIT
				EndIf
				cCampo += substr( cBuffer, nPos, 1)
			Next
			//Retorna a linha de insert a ser aplicada.
			cInsertText	:= Substr( cBuffer, nposFim,nPosFim2-nPosFim)

			// tratamento para retirar o begin tran de dentro do try/catch
			nPosTranB	:= AT("BEGIN TRAN", UPPER(cInsertText))
			If nPosTranB <> 0
				cBufferX1  := Substr(cInsertText,1, nPosTranB-1 )
				cBufferX1  += Substr(cInsertText, nPosTranB+10)

				cInsertText := cBufferX1
			Endif

			nPosTranC	:= AT("COMMIT TRAN", UPPER(cInsertText))
			If nPosTranC <> 0
				cBufferX1  := Substr(cInsertText,1, nPosTranC-1 )
				cBufferX1  += Substr(cInsertText, nPosTranC+11)

				cInsertText := cBufferX1
			EndIf

			cBufferAux	:= "select @iLoop = 0 " + CRLF
			cBufferAux	+= "While @iLoop = 0 begin "+ CRLF
			//Tratamento SOMENTE para SQLSERVER 2005
			cBufferAux  += " Begin tran"+ CRLF
			cBufferAux	+= "  BEGIN TRY "+ CRLF
			cBufferAux  += cInsertText + CRLF
			cBufferAux	+= "    select @iLoop = 1 "+ CRLF
			cBufferAux	+= "  END TRY "+ CRLF
			cBufferAux	+= "  BEGIN CATCH "+ CRLF
			cBufferAux  += "    select @ins_error = @@ERROR"+ CRLF
			cBufferAux  += "    If @ins_error = 2627 "+ CRLF
			cBufferAux  += "      begin"+ CRLF
			cBufferAux	+= "        select "+ cCampo + " = " + cCampo + " + 1 "+ CRLF
			cBufferAux	+= "    End "+ CRLF
			cBufferAux	+= "    If ( @ins_error <> 2627 )"+CRLF /* and @ins_error <> 2601 )"+ CRLF  */
			cBufferAux	+= "    begin"+ CRLF 
			cBufferAux	+= "       select @iLoop = 1"+ CRLF 
			cBufferAux	+= "    End"+ CRLF
			cBufferAux  += "  END CATCH" + CRLF
			cBufferAux  += "  commit Tran" + CRLF
			cBufferAux	+= "End "+ CRLF

			/*
				TRATAMENTO PARA O SQL SERVER 2000
				NAO SERAH FEITO DEVIDO A FALHA NO SQL POR NAO TRATAR CORRETAMENTE a violacao de chave primaria.

				cBufferAux	+= "  select @ins_error = @@ERROR "+ CRLF
				cBufferAux	+= "  If @ins_error = 2627 begin"+ CRLF
				cBufferAux	+= "    select @iLoop = 0 "+ CRLF
				cBufferAux	+= "    select "+ cCampo + " = " + cCampo + " + 1 "+ CRLF
				cBufferAux	+= "  end else begin "+ CRLF
				cBufferAux	+= "    select @iLoop = 1 "+ CRLF
				cBufferAux	+= "  End "+ CRLF
				cBufferAux	+= "End "+ CRLF
			*/
			// Retira SET VINS_INI  = / SET VINS_FIM  = 1 e Inclui o Tratamento de Insert no cBuffer
			cBuffer 	:= Stuff( cBuffer, nPTratRec,(nPosFim2+17)-nPTratRec,cBufferAux )
		EndDo
    EndIf
ElseIf cDataName == "ORACLE"
	Do While ("VINS_INI  := " $ upper(cBuffer))
		nPTratRec	:= AT("VINS_INI  :=", upper(cBuffer))
		nPosFim2	:= AT("VINS_FIM  := 1 ;", upper(cBuffer))
		cCampo		:= ""
		nPos		:= 0
		nPosFim		:= 0
		//Retorna a variavel recno a ser aplicada no insert
		For nPos := nPTratRec+13 to Len( cBuffer )
			If substr( cBuffer, nPos, 1) = ";"
				nPosFim	:= nPos+2
				EXIT
			EndIf
			cCampo += substr( cBuffer, nPos, 1)
		Next nPos
		//Retorna a linha de insert a ser aplicada.
		cInsertText	:= Substr( cBuffer, nposFim,nPosFim2-nPosFim)		
		cBufferAux	:= "viLoop := 0;" + CRLF
		cBufferAux	+= "While ( viLoop = 0 ) LOOP " + CRLF
		cBufferAux	+= "  Begin"  + CRLF
		cBufferAux	+= cInsertText + CRLF
		cBufferAux	+= "  viLoop :=1;" + CRLF
		cBufferAux	+= "  Exception" + CRLF
		cBufferAux	+= "  When DUP_VAL_ON_INDEX then " + CRLF
		cBufferAux	+= cCampo + " := " + cCampo + " + 1 ;" + CRLF
		cBufferAux	+= "  End;" + CRLF
		cBufferAux	+= "End LOOP;"+CRLF
		// Retira SET VINS_INI  = / SET VINS_FIM  = 1 e Inclui o Tratamento de Insert no cBuffer
		cBuffer 	:= Stuff( cBuffer, nPTratRec,(nPosFim2+16)-nPTratRec,cBufferAux )
	EndDo
ElseIf cDataName == "DB2" .Or. cDataName == "AS400" .Or. cDataName == "DB2/400" .Or. cDataName == "MYSQL"
	Do While ("SET VINS_INI  =" $ upper(cBuffer))
		nPTratRec	:= AT("SET VINS_INI  =", upper(cBuffer))
		nPosFim2	:= AT("SET VINS_FIM  = 1 ;", upper(cBuffer))
		cCampo		:= ""
		nPos		:= 0
		nPosFim		:= 0
		//Retorna a variavel recno a ser aplicada no insert
		For nPos := nPTratRec+15 to Len( cBuffer )
			If substr( cBuffer, nPos, 1) = ";"
				nPosFim	:= nPos+2
				EXIT
			EndIf
			cCampo += substr( cBuffer, nPos, 1)
		Next nPos
		//Retorna a linha de insert a ser aplicada.
		cInsertText	:= Substr( cBuffer, nposFim,nPosFim2-nPosFim)
		cBufferAux	:= "SET viLoop= 0; " + CRLF
		cBufferAux	+= "WHILE ( viLoop=0 ) DO" + CRLF
		cBufferAux  += cInsertText + CRLF
		cBufferAux	+= "    IF vicoderror = 1 then "+ CRLF
		cBufferAux	+= "      SET vicoderror =0;"+CRLF
		cBufferAux	+= "      SET viLoop = 0;"+CRLF
		cBufferAux	+= "      SET " + cCampo + " = " + cCampo + " + 1 ;" + CRLF
		cBufferAux	+= "    ELSE " + CRLF
		cBufferAux	+= "      SET viLoop =1; " + CRLF
		cBufferAux	+= "    END IF;" + CRLF
		cBufferAux	+= "  END WHILE;" + CRLF
		// Retira SET VINS_INI  = / SET VINS_FIM  = 1 e Inclui o Tratamento de Insert no cBuffer
		cBuffer 	:= Stuff( cBuffer, nPTratRec,(nPosFim2+19)-nPTratRec,cBufferAux )
	EndDo
ElseIf cDataName == "INFORMIX"
	Do While ("LET VINS_INI  =" $ upper(cBuffer))
		nPTratRec	:= AT("LET VINS_INI  =", upper(cBuffer))
		nPosFim2	:= AT("LET VINS_FIM  = 1 ;", upper(cBuffer))
		cCampo		:= ""
		nPos		:= 0
		nPosFim		:= 0
		//Retorna a variavel recno a ser aplicada no insert
		For nPos := nPTratRec+15 to Len( cBuffer )
			If substr( cBuffer, nPos, 1) = ";"
				nPosFim	:= nPos+2
				EXIT
			EndIf
			cCampo += substr( cBuffer, nPos, 1)
		Next nPos
		//Retorna a linha de insert a ser aplicada.
		cInsertText	:= Substr( cBuffer, nposFim,nPosFim2-nPosFim)
		cBufferAux	:= "LET viLoop = 1; " + CRLF
		cBufferAux	+= "WHILE (viLoop = 1) " + CRLF
		cBufferAux	+= "  BEGIN " + CRLF
		cBufferAux	+= "	ON EXCEPTION SET vicoderror " + CRLF
		cBufferAux	+= "       if vicoderror = -268 then " + CRLF
		cBufferAux	+= "         let " + cCampo + " = " + cCampo + " + 1 ;" + CRLF
		cBufferAux	+= "         let viLoop = 1; " + CRLF
		cBufferAux	+= "       end if;" + CRLF
		cBufferAux	+= "    END EXCEPTION; " + CRLF
		cBufferAux	+= "    LET viLoop = 0; " + CRLF
		cBufferAux	+= cInsertText + CRLF
		cBufferAux	+= "  END "+ CRLF
		cBufferAux	+= "END WHILE "+ CRLF
		// Retira SET VINS_INI  = / SET VINS_FIM  = 1 e Inclui o Tratamento de Insert no cBuffer
		cBuffer 	:= Stuff( cBuffer, nPTratRec,(nPosFim2+19)-nPTratRec,cBufferAux )
	EndDo
/*
ElseIf cDataName == "CTREESQL"
	Do While ("VINS_INI = VIRECNO" $ upper(cBuffer))
		nPTratRec	:= AT("VINS_INI = VIRECNO", upper(cBuffer))
		nPosFim2	:= AT("VINS_FIM = NEW INTEGER(1)", upper(cBuffer))
		cCampo		:= ""
		nPos		:= 0
		nPosFim		:= 0
		//Retorna a variavel recno a ser aplicada no insert
		For nPos := nPTratRec+11 to Len( cBuffer )
			If substr( cBuffer, nPos, 1) = ";"
				nPosFim	:= nPos+2
				EXIT
			EndIf
			cCampo += substr( cBuffer, nPos, 1)
		Next nPos
		//Retorna a linha de insert a ser aplicada.
		cInsertText	:= Substr( cBuffer, nposFim,nPosFim2-nPosFim)
		cBufferAux	:= "iLoop = 0;" + CRLF
		cBufferAux	+= "while( iLoop == 0 ) {" + CRLF
		cBufferAux	+= "  try {"  + CRLF
		cBufferAux	+= "SQLIStatement ins_tab = new SQLIStatement ("+ cInsertText + ");" + CRLF
		cBufferAux	+= "ins_tab.execute(); "  + CRLF
		cBufferAux	+= " iLoop = 1; "  + CRLF
		cBufferAux	+= "      }"  + CRLF
		cBufferAux	+= "catch( DhSQLException e ) { "  + CRLF
		cBufferAux	+= "if( e.sqlErr == -17002 ) {"  + CRLF
		cBufferAux	+= cCampo + " = " + cCampo + " + 1 ;" + CRLF
		cBufferAux	+= "      }"  + CRLF
		cBufferAux	+= "else { "  + CRLF
		cBufferAux	+= " iLoop = 0;"  + CRLF
		cBufferAux	+= "throw e;"  + CRLF
		cBufferAux	+= "      }"  + CRLF
        cBufferAux	+= "   }"  + CRLF
        cBufferAux	+= "}"  + CRLF

		// Retira SET VINS_INI  = / SET VINS_FIM  = 1 e Inclui o Tratamento de Insert no cBuffer
		cBuffer 	:= Stuff( cBuffer, nPTratRec,(nPosFim2+20)-nPTratRec,cBufferAux )
	EndDo
*/
ElseIf cDataName == "SYBASE"
	Do While ("SELECT @INS_INI  = " $ upper(cBuffer))
		nPTratRec	:= AT("SELECT @INS_INI  =", upper(cBuffer))
		nPosFim2	:= AT("SELECT @INS_FIM  = 1", upper(cBuffer))
		cCampo		:= ""
		nPos		:= 0
		nPosFim		:= 0
		//Retorna a variavel recno a ser aplicada no insert
		For nPos := nPTratRec+19 to Len( cBuffer )
			If substr( cBuffer, nPos, 1) = " "
				nPosFim	:= nPos+2
				EXIT
			EndIf
			cCampo += substr( cBuffer, nPos, 1)
		Next nPos
		//Retorna a linha de insert a ser aplicada.
		cInsertText	:= Substr( cBuffer, nposFim,nPosFim2-nPosFim)
		cBufferAux	:= "select @iLoop = 0 " + CRLF
		cBufferAux	+= "While @iLoop = 0 begin "+ CRLF
		cBufferAux	+= cInsertText + CRLF
		cBufferAux	+= "  select @ins_error = @@ERROR "+ CRLF
		cBufferAux	+= "  If ( @ins_error != 0) begin "+ CRLF
		cBufferAux	+= "    select @iLoop = 0 "+ CRLF
		cBufferAux	+= "    select "+ cCampo + " = " + cCampo + " + 1 "+ CRLF
		cBufferAux	+= "  end else begin "+ CRLF
		cBufferAux	+= "    select @iLoop = 1 "+ CRLF
		cBufferAux	+= "  End "+ CRLF
		cBufferAux	+= "End "+ CRLF
		//Retira SET VINS_INI  = / SET VINS_FIM  = 1 e Inclui o Tratamento de Insert no cBuffer
		cBuffer 	:= Stuff( cBuffer, nPTratRec,(nPosFim2+20)-nPTratRec,cBufferAux )
	EndDo
EndIf
Return cBuffer

/*-----------------------------------------------------------------------------
Função     CFGX051_V  Autor  Microsiga S/A         Data  10/07/08 
Descrição  Função utilizada para verificar a ultima versao do fonte   
           CFGX051 aplicado no rpo do cliente, verificando assim a    
           necessidade de uma atualizacao neste fonte.                
-----------------------------------------------------------------------------*/
Function CFGX051_V()
Local nRet := 20170601 // 01 de Junho de 2017
Return nRet

/*-----------------------------------------------------------------------------
Função     CFGX051LEG  Autor  Emerson R. Oliveira  Data  20/08/10 
Descrição  Exibe Legendas                                             
Sintaxe    CFGX051LEG(Nil)                                            
-----------------------------------------------------------------------------*/
Function CFGX051LEG()
Local aLegenda := {	{"BR_VERMELHO", STR0088 },;
					{"BR_AMARELO" , STR0093 },;
					{"BR_VERDE"   , STR0094 }}

BrwLegenda(STR0099, STR0095, aLegenda)
Return .T.

/*-----------------------------------------------------------------------------
Função     GetSPName  Autor  Emerson R. Oliveira   Data  09/06/10 
Descrição  Função utilizada para verificar se esta sendo utilizado o  
           modo de procedures por processo ou nao. Sera avaliada a    
           existencia e o conteudo do parametro MV_PROCSP             
Parametros cProcName - Nome da procedure no modo antigo                
           cProcesso - Codigo do processo a ser executado              

Retorno    cName - Nome da procedure contendo ou nao o codigo do       
           processo. (dependendo do MV_PROCSP)                         
-----------------------------------------------------------------------------*/
Function GetSPName(cProcName, cProcesso)
Local cName := cProcName
Default cProcesso := ""
/*------------------------------------------------------------------------------------
 A partir da versão 11.5 o parametro "MV_PROCSP" nao sera mais utilizado pelo     
 modulo configurador durante o procedimento de manutenção de Stored Procedures.   
 Foram retirados todos os tratamentos realizados para este parametro. A partir    
 dessa versao, o modulo configurador trabalhara apenas com a hipotese de pacotes  
 individuais de procedures. Toda funcionalidade referente ao unico pacote de      
 procedures foi retirada do codigo fonte.                                         
------------------------------------------------------------------------------------*/
#IFDEF TOP
	cName += "_" + cProcesso
#ENDIF

Return cName

/*-----------------------------------------------------------------------------
Função     SeleProcs  Autor  Emerson R. Oliveira   Data  05/07/10 
Descrição  Função utilizada para exibir janela com os processos a     
           serem instalados/desinstalados.                            
Parametros nOper    - Tipo de operacao a ser realizada:                
                      1 - Instalação / 2 - Desinstalação                   
           aProcess - Vetor que armazenará os nomes dos arquivos .SPS  
           nOpca    - Resultado da seleção do usuário (OK ou Cancelar) 
Retorno    Nenhum                                                      
-----------------------------------------------------------------------------*/
Static Function SeleProcs(nOper, aProcessos, nOpca)
Local aSelProces := {}
Local aProcBk    := {}
Local aSizeAut   := MsAdvSize(,.F.,400)
Local aInfo 	 := {}
Local aPosGet	 := {}
Local aPosObj	 := {}
Local nX         := 0
Local nAt        := 0
Local oOk        := LoadBitmap( GetResources(), "LBOK" )
Local oNo        := LoadBitmap( GetResources(), "LBNO" )
Local oProcess
Local oFont
Local oDlg
Local oChkSel

// Carrega os processos em um vetor para posterior exibicao
LoadProcs(aProcBk)

For nX := 1 to Len(aProcBk)
	AADD( aSelProces, {.F.,aProcBk[nX,2],aProcBk[nX,7],IIf(len(cVersao)==2,'P'+cVersao,cVersao)+'_'+aProcBk[nX,7]+'.SPS'} )
Next nX

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 000, 075, .T., .F. } )
aInfo 	:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(	aSizeAut[3]-aSizeAut[1]	, 305, {{050,050,320,610}, {009,006,500,008}, {015,006,500,008}, {021,006,500,008}, {027,006,500,008},  {034,006}, {014,140,040,040,040,270,95}} )

DEFINE MSDIALOG oDlg TITLE IIf(nOper==1,STR0076,STR0077) From aPosGet[1][1],aPosGet[1][2] To aPosGet[1][3],aPosGet[1][4] PIXEL
oDlg:lCentered := .T.
DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -9 BOLD

If nOper == 1
	// instalação
	@ aPosGet[2][1],aPosGet[2][2] SAY STR0078 SIZE aPosGet[2][3],aPosGet[2][4] OF oDlg PIXEL FONT oFont
	@ aPosGet[3][1],aPosGet[3][2] SAY STR0079+cDir SIZE aPosGet[3][3],aPosGet[3][4] OF oDlg PIXEL FONT oFont
ElseIf nOper == 2
	//Desinstalação
	@ aPosGet[3][1],aPosGet[3][2] SAY STR0080 SIZE aPosGet[3][3],aPosGet[3][4] OF oDlg PIXEL FONT oFont
EndIf
@ aPosGet[4][1],aPosGet[4][2] SAY STR0069 + cVersao + " / " + STR0090 + DTOC(STOD(STR(CFGX051_V(),8))) + ' ' +STR0070 + TCGetDB() SIZE aPosGet[4][3],aPosGet[4][4] OF oDlg PIXEL  // "Versão: MP8.11 / Data do Instalador: " #### " / Top DataBase: "

//Controle para marcar todos os processos
@ aPosGet[5][1],aPosGet[5][2] CHECKBOX oChkSel PROMPT STR0081 SIZE aPosGet[5][3],aPosGet[5][4];
	OF oDlg PIXEL;
	ON CLICK (aEval(aSelProces, {|x| x[1] := oChkSel} ),;
	oProcess:Refresh())

@ aPosGet[6][1],aPosGet[6][2] LISTBOX oProcess FIELDS HEADER " ", STR0082, STR0083, STR0084 FIELDSIZES aPosGet[7][1],aPosGet[7][2],aPosGet[7][3],aPosGet[7][4] SIZE aPosGet[7][6],aPosGet[7][7] PIXEL OF oDlg ; //"Descrição do processo"###"Código do processo"###"Nome do pacote"
  ON DBLCLICK ( If( aSelProces[oProcess:nAt,1] == .T. , aSelProces[oProcess:nAt,1] := .F. , ;
                    aSelProces[oProcess:nAt,1] := .T. ) , oProcess:Refresh() )

If Len(aSelProces) == 0
	aAdd(aSelProces,{.T.,'','',''})
EndIf
aSelProces := ASort( aSelProces,,,{ |x,y| x[3] < y[3] } )
oProcess:SetArray(aSelProces)
oProcess:bLine := {|| {iif(aSelProces[oProcess:nAt,1],oOk,oNo),aSelProces[oProcess:nAt,2],aSelProces[oProcess:nAt,3],aSelProces[oProcess:nAt,4]} }
oProcess:Refresh()
oProcess:GoTop()
ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg, {|| nOpca := 1, If(ValidSPS(nOper, aSelProces, aProcessos), oDlg:End(), nOpca := 0)},{|| nOpca := 0, oDlg:End()} ) )

Return Nil

/*--------------------------------------------------------------------------------
Função     LoadProcs   Autor  Emerson R. Oliveira   Data  05/07/10 
Descrição  Função utilizada para carregar os processos em um vetor     
Parametros aProcessos - Vetor que armazenara os nomes dos processos    
Retorno    O vetor enviado nos parâmetros será carregado com os processos ativos                                                      
--------------------------------------------------------------------------------*/
Function LoadProcs(aProcessos)
Local lPCO     := FindFunction("GETRPORELEASE") .And. SuperGetMV("MV_PCOINTE",.F.,"2")=="1"

// ***************************************************************************************** //
// *** Variaveis para identificar os nomes das procedures no novo modelo - Por processos *** //
// ***************************************************************************************** //
// ************************************* Controladoria ************************************* //
Local cSPCTB020   := GetSPName("CTB020","01")
Local cSPCTB001   := GetSPName("CTB001","02")
Local cSPCTB220   := GetSPName("CTB020","03")
Local cSPCTB185   := GetSPName("CTB185","06")
Local cSPCTB193   := GetSPName("CTB193","23")
Local cSPCTB165   := GetSPName("CTB165","07")
Local cSPFIN001   := GetSPName("FIN001","08")
Local cSPFIN003   := GetSPName("FIN003","09")
Local cSPFIN002   := GetSPName("FIN002","10")
Local cSPATF001   := GetSPName("ATF001","11")
Local cSPPCO001   := GetSPName("PCO001","12")
Local cSPPCO003   := GetSPName("PCO003","13")
// **************************************** Materiais ************************************** //
Local cSPMAT006   := GetSPName("MAT006","14")
Local cSPMAT041   := GetSPName("MAT041","15")
Local cSPMAT043   := GetSPName("MAT043","16")
Local cSPMAT038   := GetSPName("MAT038","17")
Local cSPMAT040   := GetSPName("MAT040","18")
Local cSPMAT004   := GetSPName("MAT004","19")
Local cSPMAT005   := GetSPName("MAT005","20")
Local cSPMAT026   := GetSPName("MAT026","21")
Local cSPMAT056   := GetSPName("MAT056","22")

aProcessos := {}

AADD( aProcessos, {.F., STR0022, '', STATICCALL(CTBA190,VERIDPROC2)		, STR0088, cSPCTB020  , '01'} )	//'CTBA190 - Reproc. Contábil'
AADD( aProcessos, {.F., STR0023, '', STATICCALL(CTBA190,VERIDPROC)		, STR0088, cSPCTB001  , '02'} )	//'CTBA190 - Reproc. Contábil de Orçamentos'
AADD( aProcessos, {.F., STR0024, '', STATICCALL(CTBA220,VERIDPROC)		, STR0088, cSPCTB220  , '03'} )	//'CTBA220 - Consolidacao geral de empresas'

AADD( aProcessos, {.F., STR0025, '', STATICCALL(CTBXATU,VERIDPROC3)		, STR0088, cSPCTB185  , '06'} ) //'CTBXATU - Atualizacao de Saldos ON-LINE'

AADD( aProcessos, {.F., STR0073, '', STATICCALL(JOB192,VERIDPROC)		, STR0088, cSPCTB165  , '07'} )	//'JOB192  - Reprocessamento por Contas'
AADD( aProcessos, {.F., STR0032, '', STATICCALL(MATXFUNB,VERIDPROC2)	, STR0088, cSPFIN001  , '08'} )	//'MATXFUNB- Somatória dos Abatimentos'
AADD( aProcessos, {.F., STR0033, '', STATICCALL(FINA410,VERIDPROC)		, STR0088, cSPFIN003  , '09'} )	//'FINA410 - Refaz Clientes / Fornecedores'
AADD( aProcessos, {.F., STR0105, '', STATICCALL(FINXFIN,VERIDPROC)		, STR0088, cSPFIN002  , '10'} )	//'FINXFUN - Saldo do Titulo'
AADD( aProcessos, {.F., STR0035, '', STATICCALL(ATFA050,VERIDPROC)		, STR0088, cSPATF001  , '11'} )	//'ATFA050 - Cálculo de depreciação de ativos'

If lPCO
	AADD( aProcessos, {.F., STR0036, '', STATICCALL(PCOXSLD,VERIDPROC) 	, STR0088, cSPPCO001  , '12'} )	//'PCOXSLD - Atualiza os saldos dos cubos nas datas posteriores ao movimento'
	AADD( aProcessos, {.F., STR0053, '', STATICCALL(PCOXSLD,VERIDPROC1)	, STR0088, cSPPCO003  , '13'} )	//'PCOXSLD - Atualiza os saldos dos cubos por Chave'
EndIf

AADD( aProcessos, {.F., STR0031, '', STATICCALL(MATXFUNB,VERIDPROC)		, STR0088, cSPMAT006  , '14'} ) //'MATXFUNB - Calculo de Estoque'
AADD( aProcessos, {.F., STR0037, '', STATICCALL(MATA216,VERIDPROC)		, STR0088, cSPMAT041  , '15'} ) //'MATA216  - Refaz poder de terceiros'
AADD( aProcessos, {.F., STR0038, '', STATICCALL(MATA225,VERIDPROC)		, STR0088, cSPMAT043  , '16'} ) //'MATA225  - Saldos em Estoque'
AADD( aProcessos, {.F., STR0039, '', STATICCALL(MATA280,VERIDPROC)		, STR0088, cSPMAT038  , '17'} ) //'MATA280  - Virada de saldos'
AADD( aProcessos, {.F., STR0040, '', STATICCALL(MATA300,VERIDPROC)		, STR0088, cSPMAT040  , '18'} ) //'MATA300  - Saldo atual'
AADD( aProcessos, {.F., STR0042, '', STATICCALL(MATA330,VERIDPROC)		, STR0088, cSPMAT004  , '19'} ) //'MATA330  - Recálculo do custo médio'
AADD( aProcessos, {.F., STR0041, '', STATICCALL(MATA320,VERIDPROC)		, STR0088, cSPMAT005  , '20'} ) //'MATA320  - Cálculo do custo de reposição'
AADD( aProcessos, {.F., STR0043, '', STATICCALL(MATA350,VERIDPROC)		, STR0088, cSPMAT026  , '21'} ) //'MATA350  - Saldo atual para final'
AADD( aProcessos, {.F., STR0103, '', STATICCALL(MATR320,VERIDPROC)		, STR0088, cSPMAT056  , '22'} ) //'MATR320  - Relatório de entradas e saídas'
AADD( aProcessos, {.F., STR0104, '', STATICCALL(CTBA193,VERIDPROC)		, STR0088, cSPCTB193  , '23'} ) //"CTBA193 - Processamento de Saldo em Fila"

Return Nil

/*-----------------------------------------------------------------------------
Função     ValidSPS   Autor  Emerson R. Oliveira   Data  05/07/10 
Descrição  Função utilizada para verificar a existencia dos arquivos *.SPS no 
           diretório "StartPath".                             
Parametros nOper      - Tipo de operação a ser realizada:     
                        1 - Instalação / 2 - Desinstalação                 
           aSelProces - Vetor contendo os processos selecionados       
           aProcess   - Vetor que armazenará os nomes dos arquivos .SPS
                        encontrados no diretório.                      
Retorno    Boolean: .T. / .F.                                          
-----------------------------------------------------------------------------*/
Static Function ValidSPS(nOper, aSelProces, aProcessos)
Local aSPS      := Directory('*.SPS')
Local aMissing  := {}
Local cMsg		:= ""
Local lRet      := .T.
Local nX        := 0

aProcessos := {} // Limpa o conteudo do vetor, antes de carrega-lo novamente.

If nOper == 1
	// instalação
	For nX := 1 to Len(aSelProces)
		If aSelProces[nX,1]
			If aScan( aSPS, {|x| x[1] == aSelProces[nX, 4]}) == 0
				// Nao encontrou o arquivo .SPS
				aAdd( aMissing, {aSelProces[nX, 4], aSelProces[nX, 3]} ) // Nome e codigo do pacote
			Else
				// Encontrou o arquivo .SPS
				aAdd( aProcessos, {aSelProces[nX, 4], aSelProces[nX, 3]} ) // Nome e codigo do pacote
			EndIf
		EndIf
	Next nX

	If Len(aMissing) > 0
		lRet := .F.
		cMsg := STR0085+cDir+Chr(10)+Chr(13)
		cMsg += STR0086+Chr(10)+Chr(13)
		For nX := 1 to Len(aMissing)
			cMsg += aMissing[nX,1]+', '
		Next nX
		cMsg := Substr(cMsg, 1, Len(cMsg)-2)
		Alert(cMsg, STR0012)
	EndIf

	If lRet
		If Len(aProcessos) == 0
			lRet := .F.
			Alert(STR0087, STR0012)
		EndIf
	EndIf
ElseIf nOper == 2
	// Desinstalação
	For nX := 1 to Len(aSelProces)
		If aSelProces[nX,1]
			aAdd( aProcessos, {aSelProces[nX, 4], aSelProces[nX, 3]} ) // Nome e codigo do pacote
		EndIf
	Next nX

	If Len(aProcessos) == 0
		lRet := .F.
		Alert(STR0087, STR0012)
	EndIf
EndIf

Return lRet

/*-----------------------------------------------------------------------------
Função     GetPEProc  Autor  Emerson R. Oliveira   Data  06/07/10 
Descrição  Função utilizada para retornar os nomes dos PE's associados
           ao processo que sera desinstalado.                         
Parametros aPtoEntrada - Vetor contendo os PE's existentes atualmente  
           cProcesso   - Codigo do processo que sera desinstalado      
           cEmpresa    - Codigo da empresa atual                       
Retorno    String: nome dos PE's associados ao processo                
-----------------------------------------------------------------------------*/
Static Function GetPEProc(aPtoEntrada, cProcesso, cEmpresa)
Local cNomePE := ""
Local nX      := 0

// Indica que devem ser desinstaladas as procedures de ponto de entrada para o processo
For nX := 1 to Len(aPtoEntrada)
	If aPtoEntrada[nX,2] == cProcesso
		cNomePE += IIf(Empty(cNomePE),"",",")+"'"+aPtoEntrada[nX,1]+"_"+cEmpresa+"'"
	EndIf
Next Nx

If Empty(cNomePE)
	cNomePE := "''"
EndIf

Return cNomePE
