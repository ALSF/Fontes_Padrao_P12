#INCLUDE "PROTHEUS.CH"
#INCLUDE "CNTA150.CH"
#INCLUDE "ApWizard.ch"

//Situacoes de contrato
#DEFINE DEF_SCANC "01" //Cancelado
#DEFINE DEF_SELAB "02" //Em Elaboracao
#DEFINE DEF_SEMIT "03" //Emitido
#DEFINE DEF_SAPRO "04" //Em Aprovacao
#DEFINE DEF_SVIGE "05" //Vigente
#DEFINE DEF_SPARA "06" //Paralisado
#DEFINE DEF_SSPAR "07" //Sol Fina.
#DEFINE DEF_SFINA "08" //Finalizado
#DEFINE DEF_SREVS "09" //Revisao
#DEFINE DEF_SREVD "10"//Revisado

//Tipos de Revisao
#DEFINE DEF_ADITI "1" //Aditivo
#DEFINE DEF_REAJU "2" //Reajuste
#DEFINE DEF_REALI "3" //Realinhamento
#DEFINE DEF_READQ "4" //Readequacao
#DEFINE DEF_PARAL "5" //Paralisacao
#DEFINE DEF_REINI "6" //Reinicio
#DEFINE DEF_CLAUS "7" //Alteracao de Clausula    
#DEFINE DEF_CRCTB "8" //Cronograma Contabil
#DEFINE DEF_INDIC "9" //Indice
#DEFINE DEF_FORNE "A" //Fornecedor

//Transacoes
#DEFINE DEF_TRAAPR "030"//AprovaГЦo de revisoes
/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    Ё CNTA150  Ё Autor Ё Marcelo Custodio      Ё Data Ё15.02.2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Aprovacao de Revisoes                                      Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CNTA150()                                                  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё                                                            Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё         ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL.             Ё╠╠
╠╠цддддддддддддбддддддддбддддддбдддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁProgramador Ё Data   Ё BOPS Ё  Motivo da Alteracao                     Ё╠╠
╠╠цддддддддддддеддддддддеддддддедддддддддддддддддддддддддддддддддддддддддд╢╠╠ 
╠╠Ё            Ё        Ё      Ё                                          Ё╠╠
╠╠юддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CNTA150()
Local cFiltraCN9:= ""
Local cCn150Fil := ""     
Local aIndexCN9 := {}

Local aCores := {	{ "Alltrim(CN9->CN9_SITUAC) == '01'", "BR_VERMELHO"	},;  // Cancelado
						{ "Alltrim(CN9->CN9_SITUAC) == '02'", "BR_AMARELO"	},;  // Elaboracao
						{ "Alltrim(CN9->CN9_SITUAC) == '03'", "BR_AZUL"		},;  // Emitido
						{ "Alltrim(CN9->CN9_SITUAC) == '04'", "BR_LARANJA"	},;  // Em Aprovacao
						{ "Alltrim(CN9->CN9_SITUAC) == '05'", "BR_VERDE"	},;  // Vigente
						{ "Alltrim(CN9->CN9_SITUAC) == '06'", "BR_CINZA"	},;  // Paralisado
						{ "Alltrim(CN9->CN9_SITUAC) == '07'", "BR_MARRON"	},;  // Sol. Finalizacao
						{ "Alltrim(CN9->CN9_SITUAC) == '08'", "BR_PRETO"	},;  // Finalizado
						{ "Alltrim(CN9->CN9_SITUAC) == '09'", "BR_PINK"		},;  // Revisao
						{ "Alltrim(CN9->CN9_SITUAC) == '10'", "BR_BRANCO"	}}   // Revisado

Private cCadastro	:= OemToAnsi(STR0001) //"Aprovacao de Revisoes"
Private aRotina		:= MenuDef()   


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Filtra MBrowse por Situacao = Revisao  			                   	   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("CN9")
dbSetOrder(2)


cFiltraCN9 	:= 'CN9_FILIAL == "'+xFilial("CN9")+'" .AND. CN9_SITUAC = "09" '    

If ExistBlock("CN150FIL")
	cCn150Fil := ExecBlock("CN150FIL",.F.,.F.,{cFiltraCN9})
	If ( ValType(cCn150Fil) == "C" ) .And. !Empty(cCn150Fil)
		cFiltraCN9 := cCn150Fil
	EndIf
EndIf 
       

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё mv_par01 - Mostra Lancamentos   S/N                          Ё
//Ё mv_par02 - Aglut Lancamentos    S/N                          Ё
//Ё mv_par03 - Lancamentos Online   S/N                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
SetKey(VK_F12,{|| Pergunte("CNT150",.T.)})

Pergunte("CNT150",.F.)     

mBrowse(6,1,22,75,"CN9",,,,,,aCores,,,,,,,,,,,,cFiltraCN9)

SetKey( VK_F12 , Nil )

Return Nil

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150AprovЁ Autor Ё Marcelo Custodio      Ё Data Ё15.02.2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Aprova revisao                                             Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150Aprov(cExp01,nExp02,nExp03)                           Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё CNTA150                                                    Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ -cExp01 - Alias selecionado                                Ё╠╠
╠╠Ё          Ё -nExp02 - Registro Atual                                   Ё╠╠
╠╠Ё          Ё -nExp03 - Opcao Atual                                      Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CN150Aprov(cAlias,nReg,nOpc)

Local lCtrApr := .F.
Local lMedeve := (Posicione("CN1",1,xFilial("CN1")+CN9_TPCTO,"CN1_MEDEVE") == "1")//medicao eventual
Local lContab := (Posicione("CN1",1,xFilial("CN1")+CN9_TPCTO,"CN1_CROCTB") == "1")//cronograma contАbil
Local cEspCtr := Posicione("CN1",1,xFilial("CN1")+CN9_TPCTO,"CN1_ESPCTR")//especie do contrato
Local lCauc   := (CN9->CN9_FLGCAU == "1" .And. (CN9->CN9_TPCAUC == "1"))//Valida caucao
Local lRet    := .T.
Local lFisico := (Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")
Local lFixo   := .T.  
Local lAprovaVld:= ExistBlock("CN150VLD") 
Local lCN150VLD := .F.
Local lCNREVMD   := SuperGetMV("MV_CNREVMD",.F.,.T.)

Local aArea   := GetArea()     
Local aCronR  := {}

Local cFilter := CN9->( dbFilter() )
Local cContra := CN9->CN9_NUMERO
Local cRevisa := CN9->CN9_REVISA
Local cFilCod := xFilial("CN9")
Local cQuery  := ""
Local cAliasQr:= ""
Local cTpRev  := ""
Local cEsRev  := ""
Local cAliasQry := ""
Local cORev     := ""
Local cLctoRev  := "69G"

Local nTotPlan  := 0
Local nTotCron  := 0     
Local nTotCtb   := 0
Local nMinCauc  := 0
Local nTotCauc  := 0
Local nRegA     := 0
Local nVlInd    := 0
Local nQuant    := 0

Local cMVATESTCL := SuperGetMV("MV_ATESTCL",.F.,"")
Local cMVATESTLJ := SuperGetMV("MV_ATESTLJ",.F.,"")

Local nSaldoAntMed := 0

//зддддддддддддддддддддддддддддд©
//ЁLocalizar o tipo do contrato Ё
//юдддддддддддддддддддддддDeoддды
DbSelectArea("CN1")
DbSetOrder(1)
If DbSeek(xFilial("CN1")+CN9->CN9_TPCTO)

	//зддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁVerificar medicao eventual e controle de alcadaЁ
	//юдддддддддддддддддддддддддддддддддддддDeoддддддды
	lMedeve := CN1->CN1_MEDEVE == "1" //medicao eventual
	
	lCtrApr := CN1->CN1_CTRAPR == "1" //Controla alcada

	//зддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se o contrato possui planilha          Ё
	//юдддддддддддддддддддддддддддддддддддддддDeoддддддды
	lFixo := Empty(CN1->CN1_CTRFIX) .OR. CN1->CN1_CTRFIX == "1"


EndIf

lRet := CN240VldUsr(CN9->CN9_NUMERO,DEF_TRAAPR,.T.)//Valida Transacao

If lRet
	dbSelectArea("CN9")
	Set Filter to &("")
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Seleciona tipo de revisao                            Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("CN0")
	dbSetOrder(1)
	If dbSeek(xFilial("CN0")+CN9->CN9_TIPREV)
		cTpRev := CN0->CN0_TIPO//Tipo
		cEsRev := CN0->CN0_ESPEC//Especie
	EndIf
     
	//зддддддддддддддддддддддддд©
	//Ё Encontra revisao inicialЁ
	//юддддддддддддддддддддддддды
	cQuery := "SELECT CN9.CN9_REVISA "
	cQuery += "  FROM "+RetSqlName("CN9")+" CN9 "
	cQuery += " WHERE CN9.CN9_FILIAL = '"+xFilial("CN9")+"'"
	cQuery += "   AND CN9.CN9_NUMERO = '"+cContra+"'"
	cQuery += "   AND CN9.CN9_REVATU = '"+cRevisa+"'"
	cQuery += "   AND CN9.D_E_L_E_T_ = ' '"
	
	cAliasQr := GetNextAlias()
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQr,.F.,.T.)	
	
	cORev := (cAliasQr)->CN9_REVISA
	
	(cAliasQr)->( dbCloseArea() )

	//зддддддддддддддддддддддддд©
	//Ё Valida documentacao     Ё
	//юддддддддддддддддддддддддды	
	If cTpRev == DEF_PARAL
		lRet := CN100Doc(nReg,{DEF_SPARA,DEF_SREVS},.F.)
	Else
		lRet := CN100Doc(nReg,{DEF_SREVS},.F.)
	EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Visualiza Contrato na tela para Aprovacao da Revisao Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lRet .And. CN100Manut(cAlias,nReg,2) == 1
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁPonto de Entrada para validar a aprovaГЦo da RevisЦo do Contrato.Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lAprovaVld 
			lCN150VLD := ExecBlock("CN150VLD",.F.,.F.)
			If ValType(lCN150VLD) == "L"
				lRet := lCN150VLD
			Else
				lRet := .T.
			EndIf
		EndIf
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Valida caucao                                        Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lRet .And. lCauc
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Caucula valor minimo de caucao                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nMinCauc := (CN9->CN9_VLATU*CN9->CN9_MINCAU)/100
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Filtra total de caucao                               Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery := "SELECT SUM(CN8.CN8_VLEFET) as CN8_VLEFET "
			cQuery += "  FROM "+RetSQLName("CN8")+" CN8 "
			cQuery += " WHERE CN8.CN8_FILIAL = '"+xFilial("CN8")+"'"
			cQuery += "   AND CN8.CN8_CONTRA = '"+cContra+"'"
			cQuery += "   AND CN8.D_E_L_E_T_ <> '*'"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCN8",.F.,.T.)
			
			TCSetField( "TRBCN8", "CN8_VLEFET", "N", TamSX3("CN8_VLEFET")[1], TamSX3("CN8_VLEFET")[2] )
			
			If TRBCN8->( !Eof() )
				nTotCauc := TRBCN8->CN8_VLEFET
			EndIf
			
			TRBCN8->( dbCloseArea() )
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Valida total de caucao contra minimo estabelecido    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If nMinCauc > nTotCauc
				Aviso("CNTA150",OemtoAnsi(STR0005),{"Ok"}) //"A revisao nЦo possui o valor minimo de caucao"
				lRet := .F.
			EndIf
			
			If lRet
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Transfere as caucoes da revisao antiga para a nova   Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT CN8.R_E_C_N_O_ as RECNO "
				cQuery += "  FROM "+RetSQLName("CN8")+" CN8 "
				cQuery += " WHERE CN8.CN8_FILIAL = '"+xFilial("CN8")+"'"
				cQuery += "   AND CN8.CN8_CONTRA = '"+ cContra+"'"
				cQuery += "   AND CN8.D_E_L_E_T_ <> '*'"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCN8",.F.,.T.)
				
				While !TRBCN8->(Eof())
					CN8->(dbGoTo(TRBCN8->RECNO))
					RecLock("CN8",.F.)
						CN8->CN8_REVISA := cRevisa
					MsUnlock()
					TRBCN8->(dbSkip())
				EndDo
				
				TRBCN8->(dbCloseArea())
			EndIf
		EndIf
		
		If lRet .And. !lMedeve .And. (cTpRev != DEF_REAJU)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Totaliza as planilhas do contrato                    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery := "SELECT SUM(CNA.CNA_VLTOT) as CNA_VLTOT "
			cQuery += "  FROM "+RetSQLName("CNA")+" CNA "
			cQuery += " WHERE CNA.CNA_FILIAL = '"+xFilial("CNA")+"'"
			cQuery += "   AND CNA.CNA_CONTRA = '"+cContra+"'"
			cQuery += "   AND CNA.CNA_REVISA = '"+cRevisa+"'"
			cQuery += "   AND D_E_L_E_T_ <> '*'"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNA",.F.,.T.)
			
			nTotPlan := Round(TRBCNA->CNA_VLTOT,TamSx3("CNA_VLTOT")[2])
			
			TRBCNA->(dbCloseArea())
			
			If !lFisico
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Totaliza os cronogramas do contrato                  Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT SUM(CNF.CNF_VLPREV) as CNF_VLPREV "
				cQuery += "  FROM "+RetSQLName("CNF")+" CNF "
				cQuery += " WHERE CNF.CNF_FILIAL = '"+xFilial("CNF")+"'"
				cQuery += "   AND CNF.CNF_CONTRA = '"+cContra+"'"
				cQuery += "   AND CNF.CNF_REVISA = '"+cRevisa+"'"
				cQuery += "   AND CNF.D_E_L_E_T_ <> '*'"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNF",.F.,.T.)
				
				nTotCron := Round(TRBCNF->CNF_VLPREV,TamSx3("CNF_VLPREV")[2])
				
				TRBCNF->(dbCloseArea())
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Compara total das planilhas e do cronograma          Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If nTotCron <> nTotPlan
					Aviso("CNTA150",OemtoAnsi(STR0007),{"Ok"}) //"O total dos cronogramas diferem do total das planilhas, reestruture os cronogramas antes de aprovar a revisao"
					lRet := .F.
				EndIf
			Else
				cAliasQry := GetNextAlias()

				cQuery := "SELECT CNS.CNS_CONTRA, CNS.CNS_REVISA, CNS.CNS_PLANI, CNS.CNS_ITEM, "       
				cQuery += " 	  CNS.CNS_ITOR , "						
				cQuery += "       SUM(CNS.CNS_PRVQTD) AS CNS_PRVQTD "
				cQuery += "  FROM "+RetSQLName("CNS")+" CNS "
				cQuery += " WHERE CNS.CNS_FILIAL = '"+xFilial("CNS")+"'"
				cQuery += "   AND CNS.CNS_CONTRA = '"+cContra+"'"
				cQuery += "   AND CNS.CNS_REVISA = '"+cRevisa+"'"
				cQuery += "   AND CNS.D_E_L_E_T_ = ' ' "
				cQuery += " GROUP BY CNS.CNS_CONTRA, CNS.CNS_REVISA, CNS.CNS_PLANI, CNS.CNS_ITEM "   
				cQuery += " ,CNS.CNS_ITOR "
				cQuery := ChangeQuery( cQuery )			
				dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAliasQry, .T., .T. )

				TCSetField( cAliasQry, "CNS_PRVQTD", "N", TamSX3("CNS_PRVQTD")[1], TamSX3("CNS_PRVQTD")[2] )
				
				dbSelectArea("CNB")
				dbSetOrder(1)
				
				cFilCod := xFilial("CNB")
				While !(cAliasQry)->(Eof())
					If dbSeek(cFilCod+(cAliasQry)->CNS_CONTRA+(cAliasQry)->CNS_REVISA+(cAliasQry)->CNS_PLANI+(cAliasQry)->CNS_ITEM)  
						If Empty((cAliasQry)->CNS_ITOR)	
							If  CNB->CNB_QUANT != (cAliasQry)->CNS_PRVQTD 
						   		nQuant := CNB->CNB_QUANT  - (cAliasQry)->CNS_PRVQTD  
						   		If nQuant >= 0.01
									lRet := .F.
									Aviso(STR0026,STR0027+(cAliasQry)->CNS_ITEM+STR0028+(cAliasQry)->CNS_PLANI+STR0029,{"OK"},2)//"Atencao"##"O item "####" da planilha "##" possui saldo em aberto para distribuiГЦo no cronograma fМsico."
									Exit 
								EndIf
							EndIf 
						EndIf
						
					EndIf             
					nQuant := 0
					(cAliasQry)->(dbSkip())
				EndDo
			EndIf
			
			If lRet .And. lContab   
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Totaliza os cronogramas do contrato  contАbil        Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT SUM(CNW.CNW_VLPREV) as CNW_VLPREV "
				cQuery += "  FROM "+RetSQLName("CNW")+" CNW "
				cQuery += " WHERE CNW.CNW_FILIAL = '"+xFilial("CNW")+"'"
				cQuery += "   AND CNW.CNW_CONTRA = '"+cContra+"'"
				cQuery += "   AND CNW.CNW_REVISA = '"+cRevisa+"'"
				cQuery += "   AND CNW.D_E_L_E_T_ <> '*'"

				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNW",.F.,.T.)
				
				nTotCtb := Round(TRBCNW->CNW_VLPREV,TamSx3("CNW_VLPREV")[2])
				
				TRBCNW->(dbCloseArea())
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Compara total das planilhas e do cronograma          Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If nTotCtb <> nTotPlan
					Aviso("CNTA150",OemtoAnsi(STR0030),{"Ok"}) //"O total dos cronogramas diferem do total das planilhas, reestruture os cronogramas antes de aprovar a revisao"
					lRet := .F.
				EndIf
			EndIf
		EndIf
		
		If lRet
			//здддддддддддддддддддддддддддддддд©
			//Ё Inicializa lancanto do SIGAPCO Ё
			//юдддддддддддддддддддддддддддддддды
			PcoIniLan("000354")
		
			Begin Transaction       

			If cTpRev == DEF_REAJU
				dbSelectArea("CN9")
				dbSetOrDer(1)
				If dbSeek(xFilial("CN9")+cContra+cRevisa)
					dReaj  := CN9->CN9_DTREAJ					
					dAprov := CN150DgApr(dReaj,CN9->CN9_INDICE,@nVlInd)
					If !Empty(dAprov)
						Processa({|| lRet := CN150Reaj(cContra,cRevisa,cORev,lMedeve,dReaj,dAprov,nVlInd,lFisico,lFixo,lContab)})
					Else
						lRet := .F.
					EndIf
				EndIf
			EndIf
							
			If cTpRev == DEF_REALI .And. lFixo
				dbSelectArea("CN9")
				dbSetOrDer(1)
				If dbSeek(xFilial("CN9")+cContra+cRevisa)
					Processa({|| lRet := CN150Real(cContra,cRevisa,cORev,lMedeve,lFisico)})
				EndIf
			EndIf
			
			//здддддддддддддддддддддддддддддддддддддд©
			//ЁGera Base Instalada e Ordem de ServicoЁ
			//юдддддддддддддддддддддддддддддддддддддды
			If SuperGetMv("MV_CNINTFS",.F.,.F.) .And. cEspCtr == '2'
				lRet := CN100BIns(cContra,cRevisa,CN9->CN9_DTASSI)
			EndIf
			
			If lRet
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Filtra os contratos com o mesmo codigo de contrato   Ё
				//Ё que estao em processo de aprovacao                   Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT CN9.CN9_REVISA, CN9.CN9_SITUAC, CN9.CN9_TIPREV, CN9.R_E_C_N_O_ as RECNO "
				cQuery += "  FROM "+RetSQLName("CN9")+" CN9 "
				cQuery += " WHERE CN9.CN9_FILIAL = '"+xFilial("CN9")+"'"
				cQuery += "   AND CN9.CN9_NUMERO = '"+cContra+"'"
				cQuery += "   AND CN9.D_E_L_E_T_ <> '*'"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCN9",.F.,.T.)
				
				While !TRBCN9->(Eof())
					CN9->(dbgoTo(TRBCN9->RECNO))
					
					RecLock("CN9",.F.)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё O contrato vigente assume a situacao de revisado     Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If AllTrim(TRBCN9->CN9_SITUAC) == DEF_SVIGE .OR. AllTrim(TRBCN9->CN9_SITUAC) == DEF_SPARA
							CN9->CN9_SITUAC := DEF_SREVD
							cORev           := TRBCN9->CN9_REVISA
						EndIf
					
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё A revisao assume a nova situacao: Vigente/Paralisado Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If  TRBCN9->CN9_REVISA == cRevisa
							If cTpRev == DEF_PARAL
								CN9->CN9_SITUAC := DEF_SPARA
								CN9->CN9_DTINCP := dDataBase							
							Else
								CN9->CN9_SITUAC := DEF_SVIGE
							EndIf
							
							CN9->CN9_REVATU := ""
							
						Else
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Os outros contratos apenas alteram a flag de revisao Ё
							//Ё atual                                                Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							CN9->CN9_REVATU := cRevisa
						EndIf
						
					MsUnLock()
					TRBCN9->(dbSkip())
				EndDo
				
				TRBCN9->(dbCloseArea())
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza data de aniversario dos itens inclusos durante Ё
				//Ё a revisao                                               Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT CNB.R_E_C_N_O_ as RECNO "
				cQuery += "  FROM "+RetSQLName("CNB")+" CNB "
				cQuery += " WHERE CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
				cQuery += "   AND CNB.CNB_CONTRA = '"+cContra+"'"
				cQuery += "   AND CNB.CNB_REVISA = '"+cRevisa+"'"
				cQuery += "   AND CNB.CNB_DTANIV = '' "
				cQuery += "   AND CNB.D_E_L_E_T_ <> '*'"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNB",.F.,.T.)
				
				dbSelectArea("CNB")
				While !TRBCNB->(Eof())
					dbGoTo(TRBCNB->RECNO)
					RecLock("CNB",.F.)
						CNB->CNB_DTANIV := dDataBase
					MsUnlock()
					TRBCNB->(dbSkip())
				EndDo
				
				TRBCNB->(dbCloseArea())
				
				If SuperGetMV("MV_CNINTFS",.F.,.F.) .And. cTpRev == DEF_ADITI				
					//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Libera equipamentos dos itens do contrato que foram Ё
					//Ё "removidos": processo de troca ou substituicao.     Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cQuery := "SELECT CNB.R_E_C_N_O_ as RECNO "
					cQuery += "  FROM "+RetSQLName("CNB")+" CNB "
					cQuery += " WHERE CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
					cQuery += "   AND CNB.CNB_CONTRA = '"+cContra+"'"
					cQuery += "   AND CNB.CNB_REVISA = '"+cRevisa+"'"
					cQuery += "   AND CNB.CNB_GERBIN = '1' "
					cQuery += "   AND CNB.CNB_QUANT = CNB.CNB_QTDMED "
					cQuery += "   AND CNB.CNB_QUANT <> CNB.CNB_QTDORI "
					cQuery += "   AND CNB.D_E_L_E_T_ <> '*'"
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNB",.F.,.T.)
				
					dbSelectArea("CNB")
					While !TRBCNB->(Eof())
						dbGoTo(TRBCNB->RECNO)
					
						//зддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Deleta localizacao fisica.					    Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддды
						AGW->(dbSetOrder(2))
						If AGW->(dbSeek(xFilial("AGW")+CNB->(CNB_CONTRA+CNB_NUMERO+CNB_ITEM)))
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Caso MV_ATESTCL e MV_ATESTLJ estejam configurados, transfere base para cliente padrao.    Ё
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If !Empty(cMVATESTCL) .And. !Empty(cMVATESTLJ) .And.;
								!AA3->(dbSeek(xFilial("AA3")+AGW->(cMVATESTCL+cMVATESTLJ+AGW_PRODUT+AGW_NUMSER))) .And.;
								AA3->(dbSeek(xFilial("AA3")+AGW->(AGW_CLIENT+AGW_LOJA+AGW_PRODUT+AGW_NUMSER)))
			
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Atualiza o historico do equipamento para registrar a transferencia Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								Reclock("AAF",.T.)
								AAF->AAF_FILIAL := xFilial("AAF")
								AAF->AAF_CODCLI := cMVATESTCL
								AAF->AAF_LOJA   := cMVATESTLJ
								AAF->AAF_CODPRO := AA3->AA3_CODPRO
								AAF->AAF_NUMSER := AA3->AA3_NUMSER
								AAF->AAF_PRODAC := AA3->AA3_CODPRO
								AAF->AAF_NSERAC := AA3->AA3_NUMSER
								AAF->AAF_DTINI  := dDataBase
								AAF->AAF_CODFAB := AA3->AA3_CODFAB
								AAF->AAF_LOJAFA := AA3->AA3_LOJAFA
								AAF->AAF_LOGINI := Left(STR0031 + AA3->AA3_CODCLI + "/" + ; //RemoГЦo do equipamento do cliente/loja
													AA3->AA3_LOJA +STR0032 +CN9->CN9_NUMERO +".", Len(AAF->AAF_LOGINI)) //em funГЦo da revisЦo do contrato
								AAF->(MsUnlock())
								
								//здддддддддддддддддддддддддддддддддддддд©
								//Ё Troca cliente dos acessorios da base Ё
								//юдддддддддддддддддддддддддддддддддддддды
								AA4->(dbSeek(xFilial("AA4")+AA3->(AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER)))
								While AA4->(!Eof()) .And. AA4->(AA4_FILIAL+AA4_CODCLI+AA4_LOJA+AA4_CODPRO+AA4_NUMSER) == ;
															xFilial("AA4")+AA3->(AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER)
									dbSelectArea("AA4")
									RecLock("AA4",.F.)
									AA4->AA4_CODCLI := cMVATESTCL
									AA4->AA4_LOJA   := cMVATESTLJ
									AA4->(MsUnLock())
									
									AA4->(dbSkip())
								End
												
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Troca o cliente da base instalada                                 Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								dbSelectArea("AA3")
								RecLock("AA3",.F.)
								AA3->AA3_CODCLI := cMVATESTCL
								AA3->AA3_LOJA   := cMVATESTLJ
								AA3->AA3_CONTRT := ""
								AA3->AA3_CTAPRE := ""
								AA3->AA3_DTCTAM := Ctod("")
								
								//здддддддддддддддддддддддддддддддддддддддддд©
								//Ё Deleta localizacao fisica do equipamento Ё
								//юдддддддддддддддддддддддддддддддддддддддддды
								RecLock("AGW")
								AGW->(dbDelete())
								AGW->(MsUnLock())	
								
								//зддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Atualiza flag para caso um dia o eqto volte ao  Ё
								//Ё cliente gerar novamente a base instalada.	    Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддды
								RecLock("CNB",.F.)
								CNB->CNB_GERBIN := '2'
								MsUnlock()
							EndIf					
						EndIf
						TRBCNB->(dbSkip())
					EndDo
					
					TRBCNB->(dbCloseArea())
				End
				
	   			If !lCNREVMD
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Seleciona as medicoes da revisao original            Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cQuery := "SELECT CND.R_E_C_N_O_ as RECNO FROM " + RetSQLName("CND") + " CND "
					cQuery += "WHERE CND.CND_FILIAL = '" + xFilial("CND") + "' AND "
					cQuery += "CND.CND_CONTRA = '" + cContra + "' AND "
					cQuery += "CND.CND_REVISA = '" + cORev + "' AND "
					cQuery += "CND.D_E_L_E_T_ <> '*'"
					
					cQuery := ChangeQuery(cQuery)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCND",.F.,.T.)
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Migra as medicoes para a nova revisao                Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					While !TRBCND->(Eof())
						CND->(dbGoTo(TRBCND->RECNO))
						RecLock("CND",.F.)
						CND->CND_REVISA := cRevisa
						MsUnlock()
						TRBCND->(dbSkip())
					EndDo
					
					TRBCND->(dbCloseArea())
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Seleciona os itens de medicoes da revisao original   Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cQuery := "SELECT CNE.R_E_C_N_O_ as RECNO FROM " + RetSQLName("CNE") + " CNE "
					cQuery += "WHERE CNE.CNE_FILIAL = '" + xFilial("CNE") + "' AND "
					cQuery += "CNE.CNE_CONTRA = '" + cContra + "' AND "
					cQuery += "CNE.CNE_REVISA = '" + cORev + "' AND "
					cQuery += "CNE.D_E_L_E_T_ <> '*'"
					
					cQuery := ChangeQuery(cQuery)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNE",.F.,.T.)
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Migra os itens de medicoes para a nova revisao       Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					While !TRBCNE->(Eof())
						CNE->(dbGoTo(TRBCNE->RECNO))
						RecLock("CNE",.F.)
						CNE->CNE_REVISA := cRevisa
						MsUnlock()        					
						TRBCNE->(dbSkip())
					EndDo
					
					TRBCNE->(dbCloseArea())
				EndIf
			
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Ajusta campo de revisao dos pedidos de compra        Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT SC7.R_E_C_N_O_ as RECNO "
				cQuery += "  FROM "+RetSQLName("SC7")+" SC7 "
				cQuery += " WHERE SC7.C7_FILIAL  = '"+xFilial("SC7")+"'"
				cQuery += "   AND SC7.C7_CONTRA  = '"+cContra+"'"
				cQuery += "   AND SC7.C7_CONTREV = '"+cORev+"'"
				cQuery += "   AND SC7.D_E_L_E_T_ <> '*'"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSC7",.F.,.T.)
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Migra os itens de medicoes para a nova revisao       Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				While !TRBSC7->(Eof())
					SC7->(dbGoTo(TRBSC7->RECNO))
					RecLock("SC7",.F.)
						SC7->C7_CONTREV := cRevisa
					MsUnlock()
					TRBSC7->(dbSkip())
				EndDo
				
				TRBSC7->(dbCloseArea())

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  				//Ё Executa contabilizacao do contrato durante a aprovaГЦo da RevisЦo      Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды			
				CN150Contab(cLctoRev)				                             
				
				If !lMedeve .And. (GetNewPar( "MV_CNPROVI" ,  "S" ) == "S")
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Processa titulos provisorios                         Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					MsAguarde({||CN100ETit(cContra,cORev)},STR0008)//"Processando tМtulos provisСrios"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Nao gera titulos quando a revisao for paralisacao    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If cTpRev != DEF_PARAL
						MsAguarde({||CN100CTit(cContra,cRevisa)},STR0008)//"Processando tМtulos provisСrios"
					EndIf
				EndIf
							
			EndIf
			
			If lRet
				CNA->( FKCommit() )
				CNB->( FKCommit() )
			
				cAliasQr := GetNextAlias()

				//зддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Seleciona as planilhas criadas na revisao Ё
				//юддддддддддддддддддддддддддддддддддддддддддды			
				cQuery := "SELECT CNA.R_E_C_N_O_ as RECNO "
				cQuery += "  FROM "+RetSQLName("CNA")+" CNA "
				cQuery += " WHERE CNA.CNA_FILIAL = '"+xFilial("CNA")+"'"
				cQuery += "   AND CNA.CNA_CONTRA = '"+cContra+"'"
				cQuery += "   AND CNA.CNA_REVISA = '"+cRevisa+"'"
				cQuery += "   AND CNA.D_E_L_E_T_ = ' '"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQr,.F.,.T.)			
				
				dbSelectArea("CNA")

				//зддддддддддддддддддддддддддддддддд©
				//Ё Executa o lancamento do SIGAPCO Ё
				//юддддддддддддддддддддддддддддддддды
				While !(cAliasQr)->(Eof())
					CNA->(dbGoTo((cAliasQr)->RECNO))
					PcoDetLan("000354","03","CNTA200")
					(cAliasQr)->(dbskip())
				EndDo
				
				(cAliasQr)->(dbCloseArea())

				cAliasQr := GetNextAlias()

				//зддддддддддддддддддддддддддддддддддддддд©
				//Ё Seleciona os itens criados na revisao Ё
				//юддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT CNB.R_E_C_N_O_ as RECNO "
				cQuery += "  FROM "+RetSQLName("CNB")+" CNB "
				cQuery += " WHERE CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
				cQuery += "   AND CNB.CNB_CONTRA = '"+cContra+"'"
				cQuery += "   AND CNB.CNB_REVISA = '"+cRevisa+"'"
				cQuery += "   AND CNB.D_E_L_E_T_ = ' '"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQr,.F.,.T.)			
				
				dbSelectArea("CNB")
				
				//зддддддддддддддддддддддддддддддддд©
				//Ё Executa o lancamento do SIGAPCO Ё
				//юддддддддддддддддддддддддддддддддды
				While !(cAliasQr)->(Eof())
					CNB->(dbGoTo((cAliasQr)->RECNO))
					PcoDetLan("000354","04","CNTA200")
					(cAliasQr)->(dbskip())
				EndDo
				
				(cAliasQr)->(dbCloseArea())
			EndIf

			End Transaction

			//здддддддддддддддддддддддддддддддддд©
			//Ё Finaliza lancamentos do SIGAPCO  Ё
			//юдддддддддддддддддддддддддддддддддды
			PcoFinLan("000354")  
			PcoFreeBlq("000354")

			//здддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Executa ponto de entrada para aprovacao    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддды
			If ExistBlock("CN150APR")
				ExecBlock("CN150APR",.F.,.F.,{cContra,cRevisa,cORev,lMedeve,lFisico})
			EndIf
		EndIf
	Else
		lRet := .F.
	EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Executa rotina de analise dos fornecedores contra    Ё
	//Ё a nova situacao do contrato                          Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lRet .And. (cTpRev == DEF_PARAL .OR. cTpRev == DEF_REINI) .And. cEspCtr <> '2'
		CN220Aval("CNM",nReg,nOpc,,.F.,IF(cTpRev==DEF_PARAL,DEF_SPARA,DEF_SVIGE))
	EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Executa rotina geracao de historico da tabela COA -  Ё
	//Ё Avaliacao de Contratos		                         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lRet .And. !Empty(cRevisa)
		CN180Hist(cContra,cRevisa)
	EndIf      

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Executa rotina para tratamento de contratos GCT inte-  Ё
	//Ё grados ao GestЦo de ServiГos
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lRet
		At870Aprov(cContra, cRevisa)
	EndIf 
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Retorna filtro dos contratos                         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("CN9")
	Set Filter to &(cFilter)
EndIf

RestArea( aArea )
Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150DgAprЁ Autor Ё Marcelo Custodio      Ё Data Ё20.04.2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Dialog para preenchimento da data de aprovacao do reajuste Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150DgApr(dExp01,cExp02,nExp03)                           Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё CN150DgApr                                                 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ -dExp01 - Data de inicio do reajuste                       Ё╠╠
╠╠Ё          Ё -cExp02 - Codigo do indice do contrato                     Ё╠╠
╠╠Ё          Ё -nExp03 - Valor do indice - referencia                     Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CN150DgApr(dReaj,cInd,nVlInd)
Local oDlg
Local oFnt
Local oFnt2
Local oFnt3
Local oGroup
Local oGet01
Local dDataApr := CTOD("  /  /  ")
Local cTitulo  := STR0009//"Data de AprovaГЦo do Reajuste" 

DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo) FROM  165,115 TO 265,370 PIXEL

@ 07,10 SAY OemToAnsi(STR0011) SIZE 60, 8 OF oDlg PIXEL//"Dt Inicio Rej."
@ 05,55  MSGET oGet01 VAR dReaj PICTURE "@D" When .F. SIZE 40,9 OF oDlg PIXEL

@ 22,10 SAY OemToAnsi(STR0010) SIZE 60, 8 OF oDlg PIXEL//"Dt AprovaГЦo"
@ 20,55  MSGET oGet01 VAR dDataApr PICTURE "@D" VALID CN150VdApr(dDataApr,dReaj,cInd,@nVlInd) SIZE 40,9 OF oDlg PIXEL

DEFINE SBUTTON FROM 35, 63 TYPE 1 ACTION (if(!Empty(dDataApr) .And. CN150VdApr(dDataApr,dReaj,cInd,@nVlInd),oDlg:End(),)) ENABLE OF oDlg
DEFINE SBUTTON FROM 35, 93 TYPE 2 ACTION (dDataApr:=CTOD("  /  /  "),oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg 

Return dDataApr

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150VdAprЁ Autor Ё Marcelo Custodio      Ё Data Ё20.04.2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Valida data de aprovacao                                   Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150VdApr(dExp01,dExp02,cExp03,nExp04)                    Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё CN150VdApr                                                 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ -dExp01 - Data de aprovacao                                Ё╠╠
╠╠Ё          Ё -dExp02 - Data de inicio do reajuste                       Ё╠╠
╠╠Ё          Ё -cExp03 - Codigo do indice                                 Ё╠╠
╠╠Ё          Ё -nExp04 - Valor do indice - referencia                     Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CN150VdApr(dDataApr,dReaj,cIndc,nVlInd)
Local lRet := .T.
Local nUsrVldInd := 0 

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Data de aprovacao deve ser maior que a data de inicioЁ
//Ё do reajuste                                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
If dDataApr < dReaj .And. !Empty(dDataApr) .And. !Empty(dReaj)
	Aviso("CNTA150",OemtoAnsi(STR0012),{"OK"})//"A data de referЙncia deve igual ou posterior a data de inМcio do reajuste."
	lRet := .F.
EndIf

If lRet
	
	If ExistBlock("CN150IND")
		nUsrVldInd := ExecBlock("CN150IND",.f.,.f.,{dDataApr,cIndc,nVlInd})
		If ValType(nUsrVldInd) == "N"
			nVlInd := nUsrVldInd
		Else
			lRet := .F.
		EndIf
	Else
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Seleciona indice do contrato                         Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If Posicione("CN6",1,xFilial("CN6")+cIndc,"CN6_TIPO") == "1"//Diario
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Seleciona historico do indice diario                 Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("CN7")
			dbSetOrder(1)
			If !dbSeek(xFilial("CN7")+cIndc+DTOS(dDataApr))
				Aviso("CNTA150",OemToAnsi(STR0014),{"OK"})//"NЦo hА histСrico para o Мndice do contrato na data de referЙncia informada."
				lRet := .F.
			Else
				nVlInd := CN7->CN7_VLREAL
			EndIf
		Else
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Seleciona historico do indice mensal                 Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("CN7")
			dbSetOrder(2)
			If !dbSeek(xFilial("CN7")+cIndc+strzero(Month(dDataApr),2)+"/"+strzero(Year(dDataApr),4))
				Aviso("CNTA150",OemToAnsi(STR0014),{"OK"})//"NЦo hА histСrico para o Мndice do contrato na data de referЙncia informada."
				lRet := .F.
			Else
				nVlInd := CN7->CN7_VLREAL
			EndIf
		EndIf
	EndIf
EndIf

Return lRet

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150Reaj Ё Autor Ё Marcelo Custodio      Ё Data Ё20.04.2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Executa reajuste do contrato                               Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150Reaj(cExp01,cExp02,cExp03,lExp04)                     Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё CN150VdApr                                                 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ -cExp01 - Codigo do contrato                               Ё╠╠
╠╠Ё          Ё -cExp02 - Codigo da revisao                                Ё╠╠
╠╠Ё          Ё -cExp03 - Codigo da revisao de origem                      Ё╠╠
╠╠Ё          Ё -lExp04 - Medicao eventual S/N                             Ё╠╠
╠╠Ё          Ё -lExp05 - Cronograma ContАbil S/N                          Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CN150Reaj(cContra,cRevisa,cORev,lMedeve,dReaj,dAprov,nVlInd,lFisico,lFixo,lContab)
Local aArea := GetArea()
Local nx := 0
Local ny := 0
Local lRet := .T.
Local cQuery := ""  

//Itens das planilha
Local nVlTot   := 0 //Valor total antes do reajuste
Local nVlDesc  := 0 //Valor do desconto antes do reajuste
Local nReajTot := 0 //Rejuste do item
Local nReajUnt := 0 //Reajuste do valor unitario
Local nMReajUnt:= 0 //Reajuste do valor unitario da Medicao
Local nReajDsc := 0 //Reajuste do desconto
Local lCopia   := .F.

//Planilhas
Local nReajPl  := 0 //Total de reajuste da planilha
Local nMaxItem := 0 //Armazena sequencia dos itens das planilhas
Local nItMed   := 0 //Armazena quantidade a ser recebida
Local nPlani   := 0
Local nPlItm   := 0
Local nPosNumP := 0
Local nPosItPla:= 0

Local aCopIt   := {} //Itens que serao copiados
Local aItAtd   := {} //Itens nao recebidos
Local aItDpl   := {} //Armazena itens duplicados

//Cronogramas
Local aCrons   := {} //Armazenas parcelas medidas e reajustadas
Local nPosCron := 0
Local cCondQu  := ""

//Medicao
Local nReajMed := 0
Local nPosPlan := 0
Local nPosIt   := 0

//Contrato
Local nReajCotr:= 0 //Total de reajuste do contrato
Local nReajSald:= 0 //Total de reajuste do saldo    
Local nReajSld := 0 //Saldo do item da planilha      

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Parametro que informa se havera reajuste das medicoesЁ
//Ё dentro do periodo de pesquisa                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local lReajMed  := (GetNewPar( "MV_CNREAJM", "S" ) == "S")
Local lCNRevMd  := SuperGetMV("MV_CNREVMD",.F.,.T.)
Local lCn150Pla :=ExistBlock("CN150PLA")
Local lCn150Cro :=ExistBlock("CN150CRO")    
Local lCn150ItPl:=ExistBlock("CN150ITPL")   
Local nNewInd   := 0

ProcRegua(10)
IncProc( STR0015 )//"Calculando Reajuste" 

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Posiciona no contrato                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("CN9")
dbSetOrder(1)
If dbSeek(xFilial("CN9")+cContra+cRevisa)  
	//здддддддддддддддддддддддддддддддд©
	//ЁIdentifica especie do contrato  Ё
	//Ё1 - Compra                      Ё
	//Ё2 - Venda                       Ё
	//юдддддддддддддддддддддддддддддддды
	cEspCtr := CN9->CN9_ESPCTR
	
	If !Empty(dAprov)
		IncProc( STR0016 )//"Verificando mediГУes do perМodo"
		               
		If lReajMed
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Retorna total dos itens medidos mas nao recebidos    Ё
			//Ё antes da data de inicio do reajuste                  Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery := "SELECT CNE.CNE_NUMERO, CNE.CNE_ITEM, CNE.CNE_QUANT "
			cQuery += "  FROM "+RetSQLName("CNE")+" CNE,"+RetSQLName("CND")+" CND"
			cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
			cQuery += "   AND CND.CND_FILIAL = '"+xFilial("CND")+"'"
			cQuery += "   AND CNE.CNE_CONTRA = '"+cContra+"'"
			cQuery += "   AND CNE.CNE_REVISA = '"+If(lCNRevMd,cRevisa,cORev)+"'"
			cQuery += "   AND CND.CND_DTFIM  < '"+DTOS(dReaj)+"'"    
			cQuery += "   AND "
			cQuery += "     (SELECT SUM(SC7.C7_QUJE) AS C7_QUJE "
			cQuery += "        FROM "+RetSQLName("SC7")+" SC7 "
			cQuery += "       WHERE SC7.C7_MEDICAO = CND.CND_NUMMED "
			cQuery += "         AND SC7.D_E_L_E_T_ = ' ') = 0 "
			cQuery += "   AND CNE.CNE_CONTRA = CND.CND_CONTRA "
			cQuery += "   AND CNE.CNE_REVISA = CND.CND_REVISA "
			cQuery += "   AND CNE.CNE_NUMMED = CND.CND_NUMMED "
			cQuery += "   AND CNE.D_E_L_E_T_ = '' "
			cQuery += "   AND CND.D_E_L_E_T_ = '' "
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCND",.F.,.T.)
			
			While !TRBCND->(Eof())
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Preenche array com os itens medidos que ainda nao    Ё
				//Ё possuem entrada                                      Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				nx := aScan(aItAtd,{|x| x[1,1] = TRBCND->CNE_NUMERO})
				If nx == 0
					aAdd(aItAtd,{})
				EndIf
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Estrutura do aItAtd                                  Ё
				//Ё aItAtd[x][1] - Numero da planilha                    Ё
				//Ё aItAtd[x][2] - Item da medicao                       Ё
				//Ё aItAtd[x][3] - Quantidade medida                     Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				aAdd(aItAtd[len(aItAtd)],{TRBCND->CNE_NUMERO,TRBCND->CNE_ITEM,TRBCND->CNE_QUANT})
				TRBCND->(dbSkip())
			EndDo
			
			TRBCND->(dbCloseArea())
		EndIf

		If lFixo
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Seleciona planilhas que permitem reajuste            Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery := "SELECT CNA.CNA_NUMERO,CNA.CNA_FLREAJ,CNA.R_E_C_N_O_ as RECNO "
			cQuery += "  FROM "+RetSQLName("CNA")+" CNA "
			cQuery += " WHERE CNA.CNA_FILIAL  = '"+xFilial("CNA")+"'"
			cQuery += "   AND CNA.CNA_CONTRA  = '"+cContra+"'"
			cQuery += "   AND CNA.CNA_REVISA  = '"+cRevisa+"'"
			cQuery += "   AND CNA.D_E_L_E_T_ <> '*'"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB150CNA",.F.,.T.)
			
			While !TRB150CNA->(Eof())
				IncProc( STR0017+ TRB150CNA->CNA_NUMERO )//"Verificando planilha "
				
				If lCn150Pla
					nNewInd := ExecBlock("CN150PLA",.F.,.F.,{TRB150CNA->RECNO,dAprov})
					If ValType(nNewInd) == "N"
						nVlInd := nNewInd
					EndIf
				EndIf
				
				If TRB150CNA->CNA_FLREAJ == '1'
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Seleciona itens das planilhas que tenham sido        Ё
					//Ё adicionados antes da data de inicio do reajuste      Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cQuery := "SELECT CNB.CNB_ITEM,CNB.R_E_C_N_O_ as RECNO "
					cQuery += "  FROM "+RetSQLName("CNB")+" CNB "
					cQuery += " WHERE CNB.CNB_FILIAL  = '"+xFilial("CNB")+"'"
					cQuery += "   AND CNB.CNB_CONTRA  = '"+cContra+"'"
					cQuery += "   AND CNB.CNB_REVISA  = '"+cRevisa+"'"
					cQuery += "   AND CNB.CNB_NUMERO  = '"+TRB150CNA->CNA_NUMERO+"'"
					cQuery += "   AND CNB.D_E_L_E_T_  <> '*'"
					
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNB",.F.,.T.)
					
					nMaxItem := TRBCNB->CNB_ITEM
					nSldNRej := 0
					
					While !TRBCNB->(Eof())
						dbSelectArea("CNB")
						dbGoTo(TRBCNB->RECNO)   
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//ЁPonto de entrada para alterar o valor do indice de reajuste do contrato,          |
						//Ёbaseando-se pelos itens da planilha.                                              |
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If lCn150ItPl
							nNewInd := ExecBlock("CN150ITPL",.F.,.F.,{dAprov,nVlInd})
							If ValType(nNewInd) == "N"
								nVlInd := nNewInd
							EndIf
						EndIf
						
						lCopia := .F.
						
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifica se ha saldo para o item, itens sem saldo    Ё
						//Ё nao serao reajustados pois ja estao relacionados     Ё
						//Ё com as medicoes,pedidos de compra e notas de entrada Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If CNB->CNB_SLDREC > 0
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Verifica se o item possui valores a serem recebidos  Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							nPlani := aScan(aItAtd,{|x| x[1,1] == CNB->CNB_NUMERO})
							If nPlani > 0
								nPlItm := aScan(aItAtd[nPlani],{|x| x[2] == CNB->CNB_ITEM})
								If nPlItm > 0
									nItMed := aItAtd[nPlani,nPlItm,3]
								Else
									nItMed := 0
								EndIf
							Else
								nItMed := 0
							EndIf
							
							If lReajMed
								lCopia := (CNB->CNB_SLDREC < CNB_QUANT .Or. nItMed > 0)
							else
								lCopia := (CNB->CNB_SLDMED < CNB->CNB_QUANT .And. CNB->CNB_SLDMED > 0)
							EndIf
							
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Verifica se ha itens recebidos, caso exista saldo    Ё
							//Ё recebido sera gerado uma copia do item na planilha   Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If lCopia
							
								If  (CNB->CNB_SLDREC-nItMed) > 0
									//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//Ё Preenche array com os itens que serao copiados       Ё
									//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
									aAdd(aCopIt,Array(CNB->(FCount())))
									For nx:=1 to CNB->(FCount())
										aCopIt[len(aCopIt),nx] := CNB->(FieldGet(nx))
									Next
									
									If lReajMed
										//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
										//Ё Atualiza valores do item que sera copiado            Ё
										//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
										aCopIt[len(aCopIt),CNB->(FieldPos("CNB_QUANT"))]  := CNB->CNB_SLDREC-nItMed
										aCopIt[len(aCopIt),CNB->(FieldPos("CNB_SLDREC"))] := CNB->CNB_SLDREC-nItMed
										
										RecLock("CNB",.F.)   
											CNB->CNB_QUANT -= CNB->CNB_SLDREC-nItMed  //Soma itens recebidos ou que ainda serao recebidos
											CNB->CNB_VLTOT := CNB->CNB_QUANT*CNB->CNB_VLUNIT
											CNB->CNB_VLDESC:= (CNB->CNB_VLTOT*CNB->CNB_DESC)/100
											CNB->CNB_SLDMED:= 0  //Zera saldo
											CNB->CNB_SLDREC:= nItMed
											CNB->CNB_QTDMED:= CNB->CNB_QUANT
										MsUnlock()
									Else
										//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
										//Ё Atualiza valores do item que sera copiado            Ё
										//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
										aCopIt[len(aCopIt),CNB->(FieldPos("CNB_QUANT"))]  := CNB->CNB_SLDMED
										aCopIt[len(aCopIt),CNB->(FieldPos("CNB_SLDREC"))] := CNB->CNB_SLDMED
										
										RecLock("CNB",.F.)  
											CNB->CNB_QUANT -= CNB->CNB_SLDMED//Soma itens recebidos ou que ainda serao recebidos
											CNB->CNB_VLTOT := CNB->CNB_QUANT*CNB->CNB_VLUNIT
											CNB->CNB_VLDESC:= (CNB->CNB_VLTOT*CNB->CNB_DESC)/100
											CNB->CNB_SLDREC-= CNB->CNB_SLDMED
											CNB->CNB_SLDMED:= 0//Zera saldo
											CNB->CNB_QTDMED:= CNB->CNB_QUANT
										MsUnlock()
									EndIf
								EndIf
							ElseIf CNB->CNB_SLDMED > 0
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Calcula e soma reajuste do item                      Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								nReajTot := (CNB->CNB_VLTOT*nVlInd)/100
								nReajUnt := (CNB->CNB_VLUNIT*nVlInd)/100
								nReajDsc := (CNB->CNB_VLDESC*nVlInd)/100  

								RecLock("CNB",.F.) 				
									CNB->CNB_VLTOT += nReajTot
									CNB->CNB_VLUNIT+= nReajUnt
									CNB->CNB_VLDESC+= nReajDsc
								MsUnlock()
								   
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Soma total do reajuste da planilha                   Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								nReajPl += (nReajTot-nReajDsc)	 												
							EndIf
						EndIf
						
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifica ordem dos itens para permitir inclusao na   Ё
						//Ё sequencia                                            Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If nMaxItem < CNB->CNB_ITEM
							nMaxItem := CNB->CNB_ITEM
						EndIf
							
						nMaxItem := Soma1(nMaxItem)
												
						RecLock("CNB",.F.) 	
							CNB->CNB_ITMDST := nMaxItem
						MsUnlock()

							
						TRBCNB->(dbSkip())
					EndDo
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Verifica se ha itens a serem copiados                Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If len(aCopIt) > 0
						IncProc( STR0018 )//"Gerando itens reajustados"
						nPosNumP  := CNB->(FieldPos("CNB_NUMERO"))
						nPosItPla := CNB->(FieldPos("CNB_ITEM"))
						For nx:=1 to len(aCopIt)
							
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Armazena itens duplicados, com a origem e o destino  Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If aScan(aItDpl,{|x| x[1,1] == aCopIt[nx,nPosNumP]}) == 0
								aAdd(aItDpl,{})
							EndIf
							
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Estrutura do aItDpl                                  Ё
							//Ё aItDpl[x,1] - Numero da Planilha                     Ё
							//Ё aItDpl[x,2] - Item Original                          Ё
							//Ё aItDpl[x,3] - Item de destino                        Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							aAdd(aItDpl[len(aItDpl)],{aCopIt[nx,nPosNumP],aCopIt[nx,nPosItPla],nMaxItem})
							
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Gera copia do item                                   Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							RecLock("CNB",.T.)
								For nY := 1 to FCount()
									FieldPut(ny,aCopIt[nx,ny])
								Next nY
								
								nReajUnt := (CNB->CNB_VLUNIT*nVlInd)/100
								nVlTot   := CNB->CNB_QUANT*CNB->CNB_VLUNIT    //Valor total dos itens antes do reajuste
								nVlDesc  := (nVlTot*CNB->CNB_DESC)/100        //Valor do desconto sem reajuste
								
								CNB->CNB_ITEM	  := nMaxItem
								CNB->CNB_VLUNIT += nReajUnt
								CNB->CNB_VLTOT  := CNB->CNB_QUANT*CNB->CNB_VLUNIT
								CNB->CNB_VLDESC := (CNB_VLTOT*CNB->CNB_DESC)/100
								CNB->CNB_QTDMED := CNB->CNB_QUANT-CNB->CNB_SLDMED
							MsUnlock()
													                                                                                                 			
							nReajTot := CNB->CNB_VLTOT-nVlTot
							nReajDsc := CNB->CNB_VLDESC-nVlDesc
							
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Soma reajuste da planilha                            Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							nReajPl  += nReajTot-nReajDsc
						Next nx
						
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Limpa array de copias                                Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						aCopIt := {}
					EndIf
					
					TRBCNB->(dbCloseArea())
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Aplica reajuste ao cabecalho da planilha             Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					dbSelectArea("CNA")
					dbGoTo(TRB150CNA->RECNO)
					RecLock("CNA",.F.)
						CNA->CNA_VLTOT += nReajPl
						CNA->CNA_SALDO += (CNA_SALDO*nVlInd)/100
					MsUnlock()
		
					nReajSald += CNA->CNA_SALDO
					
					If lReajMed
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Seleciona medicoes nao zeradas e nao recebidas       Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cQuery := "SELECT CND.R_E_C_N_O_ as RECNO,CND.CND_NUMMED "
						cQuery += "  FROM "+RetSQLName("CND")+" CND "
						cQuery += " WHERE CND.CND_FILIAL = '"+xFilial("CND")+"'"
						cQuery += "   AND CND.CND_DTFIM >= '"+DTOS(dReaj)+"'"
						cQuery += "   AND CND.CND_DTFIM <= '"+DTOS(dAprov)+"'"
						cQuery += "   AND CND.CND_NUMERO = '"+CNA->CNA_NUMERO+"'"
						cQuery += "   AND CND.CND_CONTRA = '"+cContra+"'"
						cQuery += "   AND CND.CND_REVISA = '"+If(lCNRevMd,cRevisa,cORev)+"'"
						cQuery += "   AND CND.CND_ZERO   = '2'"
						cQuery += "   AND "
						If cEspCtr=="1"
							cQuery += "   (SELECT SUM(SC7.C7_QUJE) AS C7_QUJE "
							cQuery += "      FROM "+RetSQLName("SC7")+" SC7 "
							cQuery += "     WHERE SC7.C7_MEDICAO = CND.CND_NUMMED "
							cQuery += "       AND SC7.D_E_L_E_T_ = ' ') = 0 "
							cQuery += " AND "
						EndIf
						cQuery += "CND.D_E_L_E_T_ = ' '"
						
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCND",.F.,.T.)
						
						While !TRBCND->(Eof())
							IncProc( STR0019 + TRBCND->CND_NUMMED )//"Verificando mediГЦo "
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Seleciona itens da medicao                           Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							cQuery := "SELECT CNE.R_E_C_N_O_ as RECNO, CNE.CNE_PEDIDO "
							cQuery += "  FROM "+RetSQLName("CNE")+" CNE "
							cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
							cQuery += "   AND CNE.CNE_CONTRA = '"+cContra+"'"
							cQuery += "   AND CNE.CNE_REVISA = '"+If(lCNRevMd,cRevisa,cORev)+"'"
							cQuery += "   AND CNE.CNE_NUMMED = '"+TRBCND->CND_NUMMED+"'"
							cQuery += "   AND CNE.D_E_L_E_T_ = ' '"
							
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPCNE",.F.,.T.)
							
							IncProc( STR0020 + TMPCNE->CNE_PEDIDO  )//"Estornando Pedido de Compra "
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Estorna pedido de compra da medicao                  Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды   
							If cEspCtr=="1"
								MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,{{"C7_NUM",TMPCNE->CNE_PEDIDO,NIL}},{},5,.F.)
	                        Else
								MSExecAuto({|x,y,z| Mata410(x,y,z)},{{"C5_NUM",TMPCNE->CNE_PEDIDO,NIL}},{},5)     
							EndIf
							
							dbSelectArea("CNE")
							While !TMPCNE->(Eof())
								CNE->(dbGoTo(TMPCNE->RECNO))
								
								nMReajUnt := (CNE->CNE_VLUNIT*nVlInd)/100								
								
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Verifica se o item foi duplicado na planilha         Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								nPosPlan := nPosIt := 0
								nPosPlan := ascan(aItDpl,{|x| x[1,1] = CNE->CNE_NUMERO})
								If nPosPlan > 0
									nPosIt := ascan(aItDpl[nPosPlan],{|x| x[2] = CNE->CNE_ITEM})
								EndIf
								
								RecLock("CNE",.F.)
									//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//Ё Altera item da medicao de acordo com a copia gerada  Ё
									//Ё na planilha                                          Ё
									//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
									If nPosIt > 0
										CNE->CNE_ITEM := aItDpl[nPosPlan,nPosIt,3]
									EndIf
								
									//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//Ё Aplica reajuste no item da medicao                   Ё
									//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
									CNE->CNE_VLUNIT += nMReajUnt
									CNE->CNE_VLTOT  += nMReajUnt*CNE->CNE_QUANT
									CNE->CNE_VLDESC += (CNE->CNE_VLTOT*CNE->CNE_PDESC)/100
								MsUnlock()
								TMPCNE->(dbSkip())
							EndDo
							TMPCNE->(dbCloseArea())
							
							dbSelectArea("CND")
							dbGoto(TRBCND->RECNO)
							
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Calcula e aplica reajuste na medicao                 Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							nReajMed := (CND->CND_VLTOT*nVlInd)/100
							RecLock("CND",.F.)
								CND->CND_VLREAJ += nReajMed
								CND->CND_VLTOT  += nReajMed
								If !lMedeve
									CND->CND_VLPREV += nReajMed
								EndIf
							msUnlock()
							
							CNB->(FKCommit())
							CND->(FKCommit())
							CNE->(FKCommit())  
							
							CNB->(dbCommit())
							CND->(dbCommit())
							CNE->(dbCommit())	
							
						   IncProc( STR0021 )//"Gerando Pedido de Compra"
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Gera novo pedido de compra para a medicao            Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							CN120GrvPed(TRBCND->CND_NUMMED,cRevisa,,,cContra)
							
							If !lMedeve
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Armazena parcela do cronograma e valor de reajuste   Ё
								//Ё                                                      Ё
								//Ё Estrutura do aCrons:                                 Ё
								//Ё aCrons[x,1] - Numero do cronograma                   Ё
								//Ё aCrons[x,2] - Competencia da parcela                 Ё
								//Ё aCrons[x,3] - Valor do reajuste                      Ё
								//| aCrons[x,4] - Quantidade de Parcelas Reajustadas     |
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If (nPosCron := aScan(aCrons,{|x| x[1] == CNA->CNA_CRONOG .AND. x[2] == CND->CND_COMPET})) > 0
									//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//Ё Soma valor do reajuste, ja que uma parcela pode ser  Ё
									//Ё medida mais de uma vez                               Ё
									//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
									aCrons[nPosCron,3] += nReajMed
									aCrons[nPosCron,4] += 1     
								Else
									aAdd(aCrons,{CNA->CNA_CRONOG,CND->CND_COMPET,nReajMed,1})
								EndIf
							EndIf
							
							TRBCND->(dbSkip())
						EndDo
						
						TRBCND->(dbCloseArea())
					EndIf
					
					//здддддддддддддддддддддддддддддддддддддд;дддддддддддддддд©
					//Ё Soma reajuste do contrato                            Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					nReajCotr += nReajPl
					
					nReajPl := 0   
				Else
					dbSelectArea("CNA")
					dbGoTo(TRB150CNA->RECNO)
					nReajSald += CNA->CNA_SALDO
				EndIf
				
				TRB150CNA->(dbSkip())
			EndDo
			TRB150CNA->(dbCloseArea())
			
			IncProc( STR0022 )//"Atualizando saldo do contrato"
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza reajuste do contrato                        Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			RecLock("CN9",.F.)
				CN9->CN9_VLREAJ += nReajCotr
				CN9->CN9_VLATU  += nReajCotr
				CN9->CN9_SALDO  := nReajSald
			MsUnlock()
		Else
			nReajCotr := (CN9->CN9_SALDO*nVlInd)/100

			IncProc( STR0022 )//"Atualizando saldo do contrato"
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza reajuste do contrato                        Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			RecLock("CN9",.F.)
				CN9->CN9_VLREAJ += nReajCotr
				CN9->CN9_VLATU  += nReajCotr
				CN9->CN9_SALDO  += nReajCotr//(CN9->CN9_SALDO*nVlInd)/100
			MsUnlock()
		EndIf

		
		If !lMedeve
			IncProc( STR0023 )//"Verificando reajuste dos cronogramas"
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Filtra cronogramas com saldo maior que zero, e que   Ё
			//Ё pertencam a planilhas reajustadas                    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery := "SELECT CNF.R_E_C_N_O_ AS RECNO "
			cQuery += "  FROM "+RetSQLName("CNF")+" CNF, "+RetSQLName("CNA")+" CNA "
			cQuery += " WHERE CNF.CNF_FILIAL = '"+xFilial("CNF")+"'"
			cQuery += "   AND CNF.CNF_CONTRA = '"+cContra+"'"
			cQuery += "   AND CNF.CNF_REVISA = '"+cRevisa+"'"
			cQuery += "   AND CNA.CNA_FILIAL = '"+xFilial("CNA")+"'"
			cQuery += "   AND CNA.CNA_FLREAJ = '1' "
			cQuery += "   AND CNF.CNF_SALDO  > 0   "
			cQuery += "   AND CNF.CNF_CONTRA = CNA.CNA_CONTRA "
			cQuery += "   AND CNF.CNF_REVISA = CNA.CNA_REVISA "
			cQuery += "   AND CNF.CNF_NUMERO = CNA.CNA_CRONOG "
			cQuery += "   AND CNF.D_E_L_E_T_ = '' "
			cQuery += "   AND CNA.D_E_L_E_T_ = '' "
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB150CNF",.F.,.T.)
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Executa reajuste das parcelas dos cronogramas        Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("CNF")
			While !TRB150CNF->(Eof())
				dbGoto(TRB150CNF->RECNO)

				If lCn150Cro
					nNewInd := ExecBlock("CN150CRO",.F.,.F.,{cContra,cRevisa,CNF->CNF_NUMERO,dAprov})
					If ValType(nNewInd) == "N"
						nVlInd := nNewInd
					EndIf
				EndIf

				RecLock("CNF",.F.)
					CNF->CNF_VLPREV += (CNF->CNF_SALDO*nVlInd)/100//(CNF->CNF_VLPREV*nVlInd)/100
					CNF->CNF_SALDO  += (CNF->CNF_SALDO*nVlInd)/100
				MsUnlock()
				
				TRB150CNF->(dbSkip())
			EndDo
			TRB150CNF->(dbCloseArea())
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se existem parcelas medidas que serao       Ё
			//Ё reajustadas de acordo com as medicoes                Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If len(aCrons) > 0 .And. lReajMed
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Monta query de acorodo com o array de cronogramas    Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT CNF.R_E_C_N_O_ AS RECNO "
				cQuery += "  FROM "+RetSQLName("CNF")+" CNF "
				cQuery += " WHERE CNF.CNF_FILIAL = '"+xFilial("CNF")+"'"
				cQuery += "   AND CNF.CNF_CONTRA = '"+cContra+"'"
				cQuery += "   AND CNF.CNF_REVISA = '"+cRevisa+"'"
				cQuery += "   AND "
				
				cCondQu := ""
				
				For nx := 1 to len(aCrons)
					cCondQu += "(CNF.CNF_NUMERO = '"+aCrons[nx,1]+"' AND CNF.CNF_COMPET = '"+aCrons[nx,2]+"')"
					If nx != len(aCrons)
						cCondQu += " OR "
					EndIf
				Next
				cQuery += "("+cCondQu+") AND "
				cQuery += "CNF.D_E_L_E_T_ = ''"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB150CNF",.F.,.T.)
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Varre as parcelas que serao reajustadas              Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				dbSelectArea("CNF")
				while !TRB150CNF->(Eof())
					dbGoto(TRB150CNF->RECNO)
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Verifica posicao no array e executa reajuste da      Ё
					//Ё parcela de acordo com a medicao reajustada           Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If (nPosCron := aScan(aCrons,{|x| x[1] == CNF->CNF_NUMERO .AND. x[2] == CNF->CNF_COMPET})) > 0
						RecLock("CNF",.F.)
							If CNF->CNF_VLREAL <> 0  // Soma reajuste somente se a parcela jА tenha sido medida
								CNF->CNF_VLREAL += aCrons[nPosCron,3] / aCrons[nPosCron,4]
								CNF->CNF_VLPREV += aCrons[nPosCron,3] / aCrons[nPosCron,4]
							EndIf
						MsUnlock()
					EndIf
					TRBCNF->(dbSkip())
				EndDo
				TRBCNF->(dbCloseArea())
			EndIf
		EndIf              
		
		If lContab
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Executa reajuste das parcelas dos cronogramas contАbil    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды     
			CN150AtuCtb(cContra,cRevisa,nVlInd,lReajMed)
		EndIf		
	Else
		lRet := .F.
	EndIf
EndIf

If lRet .And. lFisico .And. len(aItDpl) > 0
	CNA->(FkCommit())
	CNB->(FkCommit())
	CNF->(FkCommit())
	CNS->(FkCommit())
	CN150AtuFsc(cContra,cORev,cRevisa,aItDpl)
EndIf   

CNA->(dbCommit())
CNB->(dbCommit())
CNF->(dbCommit())
CNS->(dbCommit())

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё PE apСs aprovaГЦo da RevisЦo de Reajuste do contrato       Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ExistBlock("CN150REJ")
	ExecBlock("CN150REJ",.F.,.F.,{cContra,cRevisa,cORev,lMedeve,dReaj,dAprov,nVlInd,lFisico,lFixo,lContab})
EndIf

RestArea(aArea)
Return lRet

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150Real Ё Autor Ё Marcelo Custodio      Ё Data Ё20.04.2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Executa realinhamento do contrato                          Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150Real(cExp01,cExp02,cExp03,lExp04)                     Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё CNTA150                                                    Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ -cExp01 - Codigo do contrato                               Ё╠╠
╠╠Ё          Ё -cExp02 - Codigo da revisao                                Ё╠╠
╠╠Ё          Ё -cExp03 - Codigo da revisao de origem                      Ё╠╠
╠╠Ё          Ё -lExp04 - Medicao eventual S/N                             Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CN150Real(cContra,cRevisa,cORev,lMedeve,lFisico)
Local aArea   := GetArea()
Local nx      := 0
Local ny      := 0
Local lRet    := .T.
Local cQuery  := ""
Local cEspCtr := ""  

//Itens das planilha
Local nVlTot   := 0		//Valor total antes do realinhamento
Local nVlDesc  := 0		//Valor do desconto antes do realinhamento
Local dIniReal := dDataBase	//Menor data de realinhamento da planilha
Local aDtReal  := {}	//Data base de realinhamento dos itens
Local lCopia   := .F.	//Gera copia

//Planilhas
Local nMaxItem := 0  //Armazena sequencia dos itens das planilhas
Local nPlani   := 0
Local nPosNumP := 0
Local nPosItPla:= 0
Local nItMed   := 0  //Armazena quantidade a ser recebida
Local aCopIt   := {} //Itens que serao copiados
Local aItAtd   := {} //Itens nao recebidos
Local aItDpl   := {} //Armazena itens duplicados

//Cronogramas
Local aCrons   := {} //Armazenas parcelas medidas e realinhadas
Local nPosCron := 0
Local cCondQu  := "" 

//Medicao
Local nPosPlan := 0
Local nPosIt   := 0
Local nRealMed := 0  //Valor realinhado da medicao
Local nTotMedA := 0  //Valor realinhado dos itens
Local nPercCNF := 0 

Local lRealIMed:= .F.
Local lCn150Reali := ExistBlock("CN150REALI")

Local cPedido  := "" //Armazena codigo do pedido de compra 
Local cCompet  := ""

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Parametro que informa se havera realinhamento das medicoesЁ
//Ё dentro do periodo de pesquisa                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local lRealMed := (GetNewPar( "MV_CNREALM", "S" ) == "S")

Local lCNRevMd := SuperGetMV("MV_CNREVMD",.F.,.T.)

Private cFilCTR:= cFilAnt

ProcRegua(10)
IncProc( STR0024 )//"Calculando Realinhamento" 

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Posiciona no contrato                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("CN9")
dbSetOrder(1)
If dbSeek(xFilial("CN9")+cContra+cRevisa)         
		cEspCtr := CN9->CN9_ESPCTR
	
		IncProc( STR0016 )//"Verificando mediГУes do perМodo"
		    
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддH©
		//ЁRetorna total dos itens medidos mas nao recebidos    	   Ё
		//Ёantes da data atual                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддHы 
		
		aItAtd := VerItNMed(cContra,cRevisa,lRealMed)
	

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Seleciona planilhas                                  Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery := "SELECT CNA.CNA_NUMERO,CNA.R_E_C_N_O_ as RECNO "
		cQuery += "  FROM "+RetSQLName("CNA")+" CNA "
		cQuery += " WHERE CNA.CNA_FILIAL  = '"+xFilial("CNA")+"'"
		cQuery += "   AND CNA.CNA_CONTRA  = '"+cContra+"'"
		cQuery += "   AND CNA.CNA_REVISA  = '"+cRevisa+"'"
		cQuery += "   AND "
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Filtra apenas planilhas realinhadas                  Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery += "      (SELECT SUM(CNB.CNB_VLTOTR) "
		cQuery += "         FROM "+RetSQLName("CNB")+" CNB "
		cQuery += "        WHERE CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
		cQuery += "          AND CNB.CNB_CONTRA = CNA.CNA_CONTRA "
		cQuery += "          AND CNB.CNB_REVISA = CNB.CNB_REVISA "
		cQuery += "          AND CNB.CNB_NUMERO = CNA.CNA_NUMERO "
		cQuery += "          AND CNB.D_E_L_E_T_ = '') > 0 "
		cQuery += " AND CNA.D_E_L_E_T_ <> '*'"
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB150CNA",.F.,.T.)
		
		While !TRB150CNA->(Eof())
			IncProc( STR0017+ TRB150CNA->CNA_NUMERO )//"Verificando planilha "
			
			dbSelectArea("CNA")
			dbGoTo(TRB150CNA->RECNO)//Posiciona na planilha
			
			dIniReal := dDataBase
			aDtReal  := {}
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Seleciona itens das planilhas                        Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery := "SELECT CNB.CNB_ITEM, CNB.R_E_C_N_O_ as RECNO "
			cQuery += "  FROM "+RetSQLName("CNB")+" CNB "
			cQuery += " WHERE CNB.CNB_FILIAL  = '"+xFilial("CNB")+"'"
			cQuery += "   AND CNB.CNB_CONTRA  = '"+cContra+"'"
			cQuery += "   AND CNB.CNB_REVISA  = '"+cRevisa+"'"
			cQuery += "   AND CNB.CNB_NUMERO  = '"+TRB150CNA->CNA_NUMERO+"'"
			cQuery += "   AND CNB.D_E_L_E_T_ <> '*'"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNB",.F.,.T.)
			
			nMaxItem := TRBCNB->CNB_ITEM
			nSldNRej := 0
			
			While !TRBCNB->(Eof())
				dbSelectArea("CNB")
				
				dbGoTo(TRBCNB->RECNO)
				lCopia := .F.
				
				If CNB->CNB_DTREAL < dIniReal
					dIniReal := CNB->CNB_DTREAL
				EndIf
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Armazena datas base do realinhamento para recalculo  Ё
				//Ё das medicoes                                         Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				aAdd(aDtReal,{CNB->CNB_ITEM,CNB_DTREAL,CNB->CNB_REALI})
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica se ha saldo para o item, itens sem saldo    Ё
				//Ё nao serao realinhados pois ja estao relacionados     Ё
				//Ё com as medicoes,pedidos de compra e notas de entrada Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If CNB->CNB_SLDREC > 0
					//зддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Verifica se o item possui valor a ser recebido  Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддды
					nPlani := aScan(aItAtd,{|x| x[1,1] == CNB->CNB_NUMERO})
					If nPlani > 0
						//зддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Considera apenas valores anteriores a data base Ё
						//Ё de realinhamento, pois as medicoes posteriores  Ё
						//Ё serao recalculadas                              Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддды
						nItMed := 0
						aEval(aItAtd[nPlani],{|x| nItMed += If(x[2] == CNB->CNB_ITEM .AND. x[4] < DTOS(CNB->CNB_DTREAL),x[3],0)})
					Else
						nItMed := 0
					EndIf
										
					If lRealMed
						lCopia := (CNB->CNB_SLDREC < CNB_QUANT .Or. nItMed > 0)
					else
						lCopia := (CNB->CNB_SLDMED < CNB->CNB_QUANT .And. CNB->CNB_SLDMED > 0)
					EndIf
					                         
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Verifica se ha itens recebidos, caso exista saldo    Ё
					//Ё recebido sera gerado uma copia do item na planilha   Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If lCopia
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifica se ha itens a serem realinhados             Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды						
						If  (CNB->CNB_SLDREC-nItMed) > 0
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Preenche array com os itens que serao copiados       Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							aAdd(aCopIt,Array(FCount()))
							For nx:=1 to FCount()
								aCopIt[len(aCopIt),nx] := CNB->(FieldGet(nx))
							Next
							
							If lRealMed
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Atualiza valores do item que sera copiado            Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								aCopIt[len(aCopIt),CNB->(FieldPos("CNB_QUANT"))]  := CNB->CNB_SLDREC-nItMed
								aCopIt[len(aCopIt),CNB->(FieldPos("CNB_SLDREC"))] := CNB->CNB_SLDREC-nItMed
								
								RecLock("CNB",.F.)       
									CNB->CNB_QUANT -= CNB->CNB_SLDREC-nItMed  //Soma itens recebidos ou que ainda serao recebidos
									CNB->CNB_VLTOT := CNB->CNB_QUANT*CNB->CNB_VLUNIT
									CNB->CNB_VLDESC:= (CNB->CNB_VLTOT*CNB->CNB_DESC)/100
									CNB->CNB_SLDMED:= 0  //Zera saldo para item de historico
									CNB->CNB_SLDREC:= 0  //Zera saldo a receber para o item de historico
									CNB->CNB_QTDMED:= CNB->CNB_QUANT
								MsUnlock()
							ElseIf CNB->CNB_SLDMED < CNB->CNB_QUANT
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Atualiza valores do item que sera copiado            Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								aCopIt[len(aCopIt),CNB->(FieldPos("CNB_QUANT"))]  := CNB->CNB_SLDMED
								aCopIt[len(aCopIt),CNB->(FieldPos("CNB_SLDREC"))] := CNB->CNB_SLDMED
								
								RecLock("CNB",.F.) 
									CNB->CNB_QUANT -= CNB->CNB_SLDMED  //Soma itens recebidos ou que ainda serao recebidos
									CNB->CNB_VLTOT := CNB->CNB_QUANT*CNB->CNB_VLUNIT
									CNB->CNB_VLDESC:= (CNB->CNB_VLTOT*CNB->CNB_DESC)/100
									CNB->CNB_SLDMED:= 0  //Zera saldo para item de historico
									CNB->CNB_SLDREC:= 0  //Zera saldo a receber para o item de historico
									CNB->CNB_QTDMED:= CNB->CNB_QUANT
								MsUnlock()
							EndIf
						EndIf
					ElseIf CNB->CNB_SLDMED > 0
						nVlTot := CNB->CNB_QUANT*CNB->CNB_REALI
						nVlDesc:= (nVlTot*CNB->CNB_DESC)/100
						
						If CNB->CNB_REALI <> 0 
							RecLock("CNB",.F.)  
								CNB->CNB_VLTOT := nVlTot
								CNB->CNB_VLUNIT:= CNB->CNB_REALI
								CNB->CNB_VLDESC:= nVlDesc   
								If lRealMed   .And. len(aCopIt)>0
									CNB->CNB_SLDMED:= CNB->CNB_QUANT
									CNB->CNB_QTDMED:= 0
								EndIf
							MsUnlock()             
						EndIf
					EndIf
				EndIf
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica ordem dos itens para permitir inclusao das  Ё
				//Ё copias na sequencia                                  Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If nMaxItem < CNB->CNB_ITEM
					nMaxItem := CNB->CNB_ITEM
				EndIf
				
				TRBCNB->(dbSkip())
			EndDo
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se ha itens a serem copiados                Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If len(aCopIt) > 0
				IncProc( STR0025 )//"Gerando itens realinhados"
				nPosNumP  := CNB->(FieldPos("CNB_NUMERO"))
				nPosItPla := CNB->(FieldPos("CNB_ITEM"))
				For nx:=1 to len(aCopIt)
					nMaxItem := Soma1(nMaxItem)
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Armazena itens duplicados, com a origem e o destino  Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If aScan(aItDpl,{|x| x[1,1] == aCopIt[nx,nPosNumP]}) == 0
						aAdd(aItDpl,{})
					EndIf
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Estrutura do aItDpl                                  Ё
					//Ё aItDpl[x,1] - Numero da Planilha                     Ё
					//Ё aItDpl[x,2] - Item Original                          Ё
					//Ё aItDpl[x,3] - Item de destino                        Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					aAdd(aItDpl[len(aItDpl)],{aCopIt[nx,nPosNumP],aCopIt[nx,nPosItPla],nMaxItem})
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Gera copia do item                                   Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					RecLock("CNB",.T.)
						For ny:=1 to FCount()
							FieldPut(ny,aCopIt[nx,ny])
						Next
						CNB->CNB_ITEM   := nMaxItem 
						CNB->CNB_VLUNIT := CNB->CNB_REALI//Assume valor realinhado
						CNB->CNB_VLTOT  := CNB->CNB_QUANT*CNB->CNB_REALI
						CNB->CNB_VLDESC := (CNB_VLTOT*CNB->CNB_DESC)/100
					 	CNB->CNB_QTDMED := CNB->CNB_QUANT-CNB->CNB_SLDMED
						CNB->CNB_REALI := 0
						CNB->CNB_DTREAL:= CTOD("")
						CNB->CNB_VLTOTR:= 0
						If lCn150Reali
							ExecBlock("CN150REALI",.F.,.F.,{aCopIt[nx]})
						EndIf
					MsUnlock()							
				Next nx
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Limpa array de copias                                Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				aCopIt := {}
			EndIf
			
			TRBCNB->(dbCloseArea())
						
			If lRealMed
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Seleciona medicoes nao zeradas e nao recebidas, que  Ё
				//Ё estejam no periodo entre a data atual e a menor data Ё
				//Ё base informada                                       Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT CND.R_E_C_N_O_ as RECNO, CND.CND_NUMMED, CND.CND_DTFIM, CND.CND_COMPET" 
				cQuery += "  FROM "+RetSQLName("CND")+" CND "
				cQuery += " WHERE CND.CND_FILIAL = '"+xFilial("CND")+"'"
				cQuery += "   AND CND.CND_DTFIM >= '"+DTOS(dIniReal)+"'"
				cQuery += "   AND CND.CND_DTFIM <= '"+DTOS(dDataBase)+"'"
				cQuery += "   AND CND.CND_NUMERO = '"+CNA->CNA_NUMERO+"'"
				cQuery += "   AND CND.CND_CONTRA = '"+cContra+"'"
				cQuery += "   AND CND.CND_REVISA = '"+If(lCNRevMd,cRevisa,cORev)+"'"
				cQuery += "   AND CND.CND_ZERO   = '2'"
				cQuery += "   AND "
				
				If cEspCtr == "1"
					cQuery += "      (SELECT SUM(SC7.C7_QUJE) AS C7_QUJE     "
					cQuery += "         FROM "+ RetSQLName("SC7") +" SC7    "
					cQuery += "        WHERE SC7.C7_MEDICAO = CND.CND_NUMMED "
					cQuery += "          AND SC7.D_E_L_E_T_ = ' ') = 0       "     
				Else			
					cQuery += "      (SELECT SUM(SC6.C6_QTDENT) AS C6_QTDENT "
					cQuery += "         FROM "+ RetSQLName("SC5") +" SC5,    " + RetSQLName("SC6") +" SC6 "
					cQuery += "        WHERE SC5.C5_MDNUMED = CND.CND_NUMMED "
					cQuery += "          AND SC5.C5_NUM     = SC6.C6_NUM     "   
					cQuery += "          AND SC5.D_E_L_E_T_ = ' '			 "	  
					cQuery += "          AND SC6.D_E_L_E_T_ = ' ') = 0       "
				EndIf
								
				cQuery += "   AND CND.D_E_L_E_T_ = ' '"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCND",.F.,.T.)
				
				lRealIMed := .F. 
				
				While !TRBCND->(Eof())
					IncProc( STR0019 + TRBCND->CND_NUMMED )//"Verificando mediГЦo "

					nRealMed := 0     
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona o cronograma                               Ё
    				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
    				cCompet   := TRBCND->CND_COMPET				
					dbSelectArea("CNF")
					dbSetOrder(2)
					dbSeek(xFilial("CNF")+cContra+cRevisa+CNA->CNA_CRONOG+cCompet)
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Seleciona itens da medicao                           Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cQuery := "SELECT CNE.R_E_C_N_O_ as RECNO, CNE.CNE_PEDIDO "
					cQuery += "  FROM "+RetSQLName("CNE")+" CNE "
					cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
					cQuery += "   AND CNE.CNE_CONTRA = '"+cContra+"'"
					cQuery += "   AND CNE.CNE_REVISA = '"+If(lCNRevMd,cRevisa,cORev)+"'"
					cQuery += "   AND CNE.CNE_NUMMED = '"+TRBCND->CND_NUMMED+"'"
					cQuery += "   AND CNE.D_E_L_E_T_ = ' '"
					
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPCNE",.F.,.T.)
					
					IncProc( STR0020 + TMPCNE->CNE_PEDIDO  )//"Estornando Pedido de Compra "
				
					dbSelectArea("CNE")
					While !TMPCNE->(Eof())			
						CNE->(dbGoTo(TMPCNE->RECNO))
						
						nPosItem = aScan(aDtReal,{|x| x[1] == CNE->CNE_ITEM})
					
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifica se a data da medicao e maior que a data     Ё
						//Ё base de realinhamento                                Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If TRBCND->CND_DTFIM >= DTOS(aDtReal[nPosItem,2])
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Informa que houve realinhamento na medicao           Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							lRealIMed := .T.
							cPedido   := TMPCNE->CNE_PEDIDO

							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Verifica se o item foi duplicado na planilha         Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							nPosPlan := nPosIt := 0
							nPosPlan := ascan(aItDpl,{|x| x[1,1] = CNE->CNE_NUMERO})
							If nPosPlan > 0
								nPosIt := ascan(aItDpl[nPosPlan],{|x| x[2] = CNE->CNE_ITEM})
							EndIf

							RecLock("CNE",.F.)
			   					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Altera item da medicao de acordo com a copia gerada  Ё
								//Ё na planilha                                          Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If nPosIt > 0
									CNE->CNE_ITEM := aItDpl[nPosPlan,nPosIt,3]
								EndIf
							
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Atualiza percentual medido                           Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								nPercCNF := CNE->CNE_PERC
																				
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Grava Saldo Anterior do item da MediГЦo              Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								nSaldoAntMed := CNE->CNE_VLTOT
																				
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Aplica realinhamento no item da medicao              Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
								CNE->CNE_VLUNIT := aDtReal[nPosItem,3] 
								CNE->CNE_QUANT  := Round((CNB->CNB_QUANT*nPercCNF)/100,TamSX3("CNE_QUANT")[2])
								CNE->CNE_VLTOT  := CNE->CNE_QUANT*aDtReal[nPosItem,3] 
								CNE->CNE_VLDESC := (CNE->CNE_VLTOT*CNE->CNE_PDESC)/100
							MsUnlock()

							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Armazena valor total do realinhamento                Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды							
							nRealMed += ((CNE->CNE_QUANT*aDtReal[nPosItem,3])-CNE->CNE_VLDESC)
							
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Acerta Saldo Contrato/Planilha de acordo com a mediГЦoЁ
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддды							
							If nSaldoAntMed - CNE->CNE_VLTOT <> 0
								// Acerta Saldo do Contrato
								Reclock("CN9",.F.)
								CN9->CN9_SALDO += (nSaldoAntMed - CNE->CNE_VLTOT)
								CN9->(MsUnlock())
								// Acerta Saldo da Planilha
								Reclock("CNA",.F.)
								CNA->CNA_SALDO += (nSaldoAntMed - CNE->CNE_VLTOT)
								CNA->(MsUnlock())
							Endif

							
						EndIf
						
						TMPCNE->(dbSkip())
					EndDo
					TMPCNE->(dbCloseArea())
					
					dbSelectArea("CND")
					dbGoto(TRBCND->RECNO)
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Calcula e aplica realinhamento na medicao            Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					RecLock("CND",.F.)
						CND->CND_VLTOT  := nRealMed
						CND->CND_VLPREV := nRealMed
					MsUnlock()    
				
					
					CNB->(FKCommit())
					CND->(FKCommit())
					CNE->(FKCommit())        
					
					CNB->(dbCommit())
					CND->(dbCommit())
					CNE->(dbCommit())					
					
				   IncProc( STR0021 )//"Gerando Pedido de Compra"

 					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Estorna e regera pedido de compra da medicao quando houver    Ё
					//Ё realinhamento                                                 Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If lRealIMed   
						If cEspCtr == "1"
							MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,{{"C7_NUM",cPedido,NIL}},{},5,.F.)						
						Else                                                     
							MSExecAuto({|x,y,z| Mata410(x,y,z)},{{"C5_NUM",cPedido,NIL}},{},5)
						EndIf                                                                                  
						CN120GrvPed(TRBCND->CND_NUMMED,cRevisa,,,cContra)
					EndIf
		
				   	If !lMedeve
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Armazena parcela do cronograma e valor realinhadoe   Ё
						//Ё                                                      Ё
						//Ё Estrutura do aCrons:                                 Ё
						//Ё aCrons[x,1] - Numero do cronograma                   Ё
						//Ё aCrons[x,2] - Competencia da parcela                 Ё
						//Ё aCrons[x,3] - Valor realinhado                       Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If (nPosCron := aScan(aCrons,{|x| x[1] == CNA->CNA_CRONOG .AND. x[2] == CND->CND_COMPET .AND. x[4] == CND->CND_PARCEL})) > 0
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Soma valor realinhado, ja que uma parcela pode ser   Ё
							//Ё medida mais de uma vez                               Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
							aCrons[nPosCron,3] += nRealMed
						Else
							aAdd(aCrons,{CNA->CNA_CRONOG,CND->CND_COMPET,nRealMed,CND->CND_PARCEL})
						EndIf
					EndIf	
					
					TRBCND->(dbSkip())
				EndDo
				
				TRBCND->(dbCloseArea())
			EndIf
				
			TRB150CNA->(dbSkip())
		EndDo
		TRB150CNA->(dbCloseArea())
		
		IncProc( STR0022 )//"Atualizando saldo do contrato"

	 	If !lMedeve 
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se existem parcelas medidas que serao       Ё
			//Ё realinhadas de acordo com as medicoes                Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If len(aCrons) > 0 .And. lRealMed
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Monta query de acordo com o array de cronogramas    Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuery := "SELECT CNF.R_E_C_N_O_ AS RECNO "
				cQuery += "  FROM "+RetSQLName("CNF")+" CNF "
				cQuery += " WHERE CNF.CNF_FILIAL = '"+xFilial("CNF")+"'"
				cQuery += "   AND CNF.CNF_CONTRA = '"+ cContra +"'"
				cQuery += "   AND CNF.CNF_REVISA = '"+ cRevisa +"'"
				cQuery += "   AND "
				cCondQu := ""
				For nx := 1 to len(aCrons)
					cCondQu += "(CNF.CNF_NUMERO = '"+aCrons[nx,1]+"' AND CNF.CNF_COMPET = '"+aCrons[nx,2]+"')"
					If nx != len(aCrons)
						cCondQu += " OR "
					EndIf
				Next
				cQuery += "("+cCondQu+") AND "
				cQuery += "CNF.D_E_L_E_T_ = ''"
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNF",.F.,.T.)
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Varre as parcelas que serao realinhadas              Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
				dbSelectArea("CNF")
				while !TRBCNF->(Eof())
					dbGoto(TRBCNF->RECNO)
					
					//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Verifica posicao no array e executa calculo da      Ё
					//Ё parcela de acordo com a medicao realinhada          Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If (nPosCron := aScan(aCrons,{|x| x[1] == CNF->CNF_NUMERO .AND. x[2] == CNF->CNF_COMPET .AND. x[4] == CNF->CNF_PARCEL})) > 0
						RecLock("CNF",.F.)
							//CNF->CNF_VLPREV := aCrons[nPosCron,3] -- Nao alterar a previsao efetuada manualmente
							CNF->CNF_VLREAL := aCrons[nPosCron,3]
							CNF->CNF_SALDO  := CNF->CNF_VLPREV - CNF->CNF_VLREAL
						MsUnlock()
					EndIf
					TRBCNF->(dbSkip())
				EndDo
				TRBCNF->(dbCloseArea())
			EndIf
		EndIf         		
EndIf         

If lRet .And. lFisico .And. len(aItDpl) > 0
	CNA->(FkCommit())
	CNB->(FkCommit())
	CNF->(FkCommit())
	CNS->(FkCommit())
	CN150AtuFsc(cContra,cORev,cRevisa,aItDpl)
EndIf
       
CNA->(dbCommit())
CNB->(dbCommit())
CNF->(dbCommit())
CNS->(dbCommit())

RestArea(aArea)
Return lRet

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150AtuFscЁ Autor Ё Marcelo Custodio      Ё Data Ё28.08.2006Ё╠╠
╠╠цддддддддддедддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Atualiza o cronograma fisico quando houver novos itens      Ё╠╠
╠╠Ё          Ё no contrato                                                 Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150AtuFsc(cExp01,cExp02,cExp03,aExp04)                    Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё CNTA150                                                     Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ -cExp01 - Codigo do contrato                                Ё╠╠
╠╠Ё          Ё -cExp02 - Codigo da revisao de origem                       Ё╠╠
╠╠Ё          Ё -cExp03 - Codigo da revisao                                 Ё╠╠
╠╠Ё          Ё -aExp04 - Array contendo as origens e destinos dos itens    Ё╠╠
╠╠Ё          Ё           duplicador por planilha                           Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CN150AtuFsc(cContra,cRevisa,cNRevisa,aItDpl)       
Local cQuery    := ""
Local cCronog   := ""
Local cFilCNS   := xFilial("CNS")
Local cFilCNA   := xFilial("CNA")
Local cPlan     := ""
Local nx,ny

//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Varre as planilhas                                  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nx:=1 to len(aItDpl)
	If len(aItDpl[nx]) > 0//Verifica se existem itens duplicados
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Seleciona codigo da planilha do primeiro item       Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cPlan := aItDpl[nx,1,1]
		dbSelectArea("CNA")
		dbSetOrder(1)
		dbSeek(cFilCNA+cContra+cRevisa+cPlan)
 	    cCronog := CNA->CNA_CRONOG

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Varre os itens                                      Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For ny:=1 to len(aItDpl[nx])
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Pesquisa as parcelas do item de origem              Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery := "SELECT CNS.*,CNS.R_E_C_N_O_ as RECNO "
			cQuery += "  FROM "+RetSQLName("CNS")+" CNS "
			cQuery += " WHERE CNS.CNS_FILIAL  = '"+cFilCNS+"'"
			cQuery += "   AND CNS.CNS_PLANI   = '"+cPlan+"'"
			cQuery += "   AND CNS.CNS_CRONOG  = '"+cCronog+"'"
			cQuery += "   AND CNS.CNS_CONTRA  = '"+cContra+"'"
			cQuery += "   AND CNS.CNS_REVISA  = '"+cNRevisa+"'"
			cQuery += "   AND CNS.CNS_ITEM    = '"+aItDpl[nx,ny,2]+"'"
			cQuery += "   AND CNS.D_E_L_E_T_ = ' '"
			
			cAliasCNS := GetNextAlias()
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCNS,.F.,.T.)
			
			dbSelectArea("CNS")
			While !(cAliasCNS)->(Eof())
				dbGoTo((cAliasCNS)->RECNO)
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Exclui o saldo do item de origem                    Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
				RecLock("CNS",.F.)
					CNS->CNS_PRVQTD := CNS->CNS_RLZQTD 
					CNS->CNS_SLDQTD := 0          
					CNS->CNS_ITOR   := aItDpl[nx,ny,3]  
				MsUnlock()
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Inclui novo item com o saldo restante               Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
				RecLock("CNS",.T.)
					CNS->CNS_FILIAL := cFilCNS
					CNS->CNS_CONTRA := cContra
					CNS->CNS_REVISA := cNRevisa
					CNS->CNS_CRONOG := cCronog
					CNS->CNS_PARCEL := (cAliasCNS)->CNS_PARCEL
					CNS->CNS_PLANI  := cPlan
					CNS->CNS_ITEM   := aItDpl[nx,ny,3]
					CNS->CNS_PRVQTD := (cAliasCNS)->CNS_SLDQTD
					CNS->CNS_SLDQTD := (cAliasCNS)->CNS_SLDQTD
					CNS->CNS_RLZQTD := 0 
				MsUnlock()
				(cAliasCNS)->(dbSkip())
			EndDo
			
			(cAliasCNS)->(dbCloseArea())
		Next
	EndIf
Next

Return 

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁMenuDef   Ё Autor Ё Fabio Alves Silva     Ё Data Ё2006	  Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Utilizacao de menu Funcional                               Ё╠╠
╠╠Ё          Ё                                                            Ё╠╠
╠╠Ё          Ё                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   ЁArray com opcoes da rotina.                                 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁParametros do array a Rotina:                               Ё╠╠
╠╠Ё          Ё1. Nome a aparecer no cabecalho                             Ё╠╠
╠╠Ё          Ё2. Nome da Rotina associada                                 Ё╠╠
╠╠Ё          Ё3. Reservado                                                Ё╠╠
╠╠Ё          Ё4. Tipo de Transa┤└o a ser efetuada:                        Ё╠╠
╠╠Ё          Ё	  1 - Pesquisa e Posiciona em um Banco de Dados  		  Ё╠╠
╠╠Ё          Ё    2 - Simplesmente Mostra os Campos                       Ё╠╠
╠╠Ё          Ё    3 - Inclui registros no Bancos de Dados                 Ё╠╠
╠╠Ё          Ё    4 - Altera o registro corrente                          Ё╠╠
╠╠Ё          Ё    5 - Remove o registro corrente do Banco de Dados        Ё╠╠
╠╠Ё          Ё5. Nivel de acesso                                          Ё╠╠
╠╠Ё          Ё6. Habilita Menu Funcional                                  Ё╠╠
╠╠цддддддддддедддддддддддддддбдддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё   DATA   Ё Programador   ЁManutencao efetuada                         Ё╠╠
╠╠цддддддддддедддддддддддддддедддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё          Ё               Ё                                            Ё╠╠
╠╠юддддддддддадддддддддддддддадддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/

Static Function MenuDef()     
PRIVATE aRotina	:= 	{ 	{ OemToAnsi(STR0002), "AxPesqui"  , 0, 1, 0, .F.},;//"Pesquisar"
							{ OemToAnsi(STR0003), "CN100Manut", 0, 2, 0, nil},;//"Visualizar"
							{ OemToAnsi(STR0004), "CN150Aprov", 0, 4, 0, nil},;//"Aprovar"
							{ OemToAnsi(STR0006), "CN140Cron" , 0, 4, 0, nil},; //"Cronogramas"
							{ OemToAnsi(STR0034), "CN100Legenda",0,6, 0, .F.}} //"Legenda"	

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ponto de entrada utilizado para inserir novas opcoes no array aRotina  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ExistBlock("CTA150MNU")
	ExecBlock("CTA150MNU",.F.,.F.)
EndIf
Return(aRotina) 

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150AtuCtbЁ Autor Ё Aline Sebrian         Ё Data Ё28.08.2009Ё╠╠
╠╠цддддддддддедддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Executa reajuste no cronograma contАbil					   Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150AtuCtb(cExp01,cExp02,nExp03,lExp04)    		          Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё CNTA150                                                     Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ -cExp01 - Codigo do contrato                                Ё╠╠
╠╠Ё          Ё -cExp02 - Codigo da revisao 			                       Ё╠╠
╠╠Ё          Ё -nExp03 - Valor do indice - referencia                      Ё╠╠
╠╠Ё          Ё -lExp04 - Informa se havera reajuste das medicoesЁ 		   Ё╠╠
╠╠Ё          Ё           dentro do periodo de pesquisa                     Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/                    
Function CN150AtuCtb(cContra,cRevisa,nVlInd,lReajMed)	 
Local cQuery     := ""    

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Filtra cronogramas com saldo maior que zero, e que   Ё
//Ё pertencam a planilhas reajustadas                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
cQuery := "SELECT CNW.R_E_C_N_O_ AS RECNO "
cQuery += "  FROM "+ RetSQLName("CNW")+" CNW, "+RetSQLName("CNA")+" CNA "
cQuery += " WHERE CNW.CNW_FILIAL = '"+xFilial("CNW")+"'"
cQuery += "   AND CNW.CNW_CONTRA = '"+cContra +"'"
cQuery += "   AND CNW.CNW_REVISA = '"+cRevisa +"'"
cQuery += "   AND CNA.CNA_FILIAL = '"+xFilial("CNA")+"'"
cQuery += "   AND CNA.CNA_FLREAJ = '1' "
cQuery += "   AND CNW.CNW_CONTRA = CNA.CNA_CONTRA "
cQuery += "   AND CNW.CNW_REVISA = CNA.CNA_REVISA "
cQuery += "   AND CNW.CNW_NUMERO = CNA.CNA_CRONCT "
cQuery += "   AND CNW.D_E_L_E_T_ = '' "
cQuery += "   AND CNA.D_E_L_E_T_ = '' "
			
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNW",.F.,.T.)
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Executa reajuste das parcelas dos cronogramas        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("CNW")
While !TRBCNW->(Eof())
	dbGoto(TRBCNW->RECNO)

	RecLock("CNW",.F.)
		CNW->CNW_VLPREV += (CNW->CNW_VLPREV*nVlInd)/100
	MsUnlock()
				
	TRBCNW->(dbSkip())
EndDo
TRBCNW->(dbCloseArea())
Return 

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤ao    ЁCN150ContabЁ Autor Ё Aline S Damasceno     Ё Data Ё21/06/2012Ё╠╠
╠╠цддддддддддедддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Contabiliza a revisЦo do contrato                           Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё CN150Contab()                                               Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function CN150Contab(cPadrao)

LOCAL aArea     := GetArea()
LOCAL aCtbDia	:= {}

LOCAL cLoteCtb  := ""

LOCAL lDigita   := If(MV_PAR02==1,.T.,.F.)                           
LOCAL lPadrao   := .F.

LOCAL nHdlPrv   := 0
LOCAL nTotal    := 0

Private cArquivo := " "

dbSelectArea("CN9")
dbSetOrder(1)

lPadrao := VerPadrao(cPadrao)

//зддддддддддддддддддд©
//ЁLancamento ContabilЁ
//юддддддддддддддддддды
If ( lPadrao .and. MV_PAR01 == 1 )
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica o numero do lote contabil                        Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("SX5")
	dbSetOrder(1)
	If MsSeek(xFilial()+"09GCT")
		cLoteCtb := AllTrim(X5Descri())
	Else
		cLoteCtb := "GCT "
	EndIf

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Executa o execblock                                       Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If At(UPPER("EXEC"),X5Descri()) > 0
		cLoteCtb := &(X5Descri())
	EndIf
	
	nHdlPrv := HeadProva(cLoteCtb,"CNTA150",Substr(cUsuario,7,6),@cArquivo)
	nTotal  += DetProva(nHdlPrv,cPadrao,"CNTA150",cLoteCtb)
	RodaProva(nHdlPrv,nTotal)
	
	//здддддддддддддддддддддддддддддд©
	//ЁEnvia para Lancamento ContabilЁ
	//юдддддддддддддддддддддддддддддды
	If cPaisLoc == "PTG"
		aCtbDia := {{"CN9",CN9->(RECNO()),CN9->CN9_DIACTB,"CN9_NODIA"}}
	Else
	    aCtbDia := {}
	EndIF    
	cA100Incl(cArquivo,nHdlPrv,3,cLoteCtb,lDigita,.F.,,,,,,aCtbDia)
EndIf

RestArea(aArea)
Return(.T.)
