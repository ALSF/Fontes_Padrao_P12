#INCLUDE "CNTA170.ch"

//Transacoes
#DEFINE DEF_TRAINC "015"//Inclusao de Documentos
#DEFINE DEF_TRAEDT "016"//Edicao de Documentos
#DEFINE DEF_TRAEXC "017"//Exclusao de Documentos
#DEFINE DEF_TRAVIS "034"//Visualizacao de Documentos
#DEFINE DEF_TRABCO "038"//Banco de Conhecimento
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
#DEFINE DEF_SREVD "10" //Revisado

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA170  ³ Autor ³ Marcelo Custodio      ³ Data ³09.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de Cadastro de Documentos                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA170()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNTA170()
Private cCadastro	:= STR0001 //Cadastro de Documentos
Private aRotina 	:= MenuDef()

mBrowse(6,1,22,75,"CNK")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN170BcoDoc³ Autor ³ Marcelo Custodio      ³ Data ³09.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de vinculacao ao banco de conhecimento               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN170Manut(cExp01,nExp02,nExp03)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Alias                                              ³±±
±±³          ³ cExp02 - Registro                                           ³±±
±±³          ³ cExp03 - Opcao                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN170BcoDoc(cAlias,nReg,nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida acesso ao banco de conhecimento    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CN240VldUsr(CNK->CNK_CONTRA,DEF_TRABCO,.T.)
	MsDocument(cAlias,nReg,nOpc)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN170Manut³ Autor ³ Marcelo Custodio      ³ Data ³09.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de Manutencao do Cadastro de Documentos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN170Manut(cExp01,nExp02,nExp03,xExp04,cExp05,cExp06,cExp07)±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Alias                                             ³±±
±±³          ³ cExp02 - Registro                                          ³±±
±±³          ³ cExp03 - Opcao                                             ³±±
±±³          ³ Parametros cExp04,cExp05,cExp06 usados apenas para inclusao³±±
±±³          ³ atraves da tela de verificacao de documentos (CNTA100)     ³±±
±±³          ³ xExp04 - Parametro padrao                                  ³±±
±±³          ³ cExp05 - Codigo do contrato                                ³±±
±±³          ³ cExp06 - Codigo do tipo de documento                       ³±±
±±³          ³ cExp07 - Codigo do documento - referencia                  ³±±
±±³          ³ lExp08 - Indica se o usuario podera VISUALIZAR a planilha  ³±±
±±³          ³ 			do contrato mesmo sem ter acesso ao mesmo. Esse	  ³±±
±±³          ³ 			parametro e enviado como .T. exclusivamente pela  ³±±
±±³          ³ 			rotina de liberacao (MATA097) quando o documento e³±±
±±³          ³ 			do tipo CT (Contrato) e o Aprovador nao possui    ³±±
±±³          ³ 			acesso ao contrato.					   			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN170Manut(cAlias,nReg,nOpc,xFiller,cContra,cTpDoc,cCod,lVisAprCt)
Local aSize      := MsAdvSize()
Local aArea      := GetArea()
Local aButtons   := {}
Local aCpos      := {}
Local aEditCpos  := {}
Local nOpca
Local lRet       := .T.  
Local lCN170VLG  := .F.
Local cTra       := ""
Local cCampo	:= ""
Local oDlg

If Type("cCadastro") # "C"
	cCadastro := STR0001 //Cadastro de Documentos
EndIf

If Type("aRotina") == "A"
	If(aRotina[nOpc,4]==3,DEF_TRAINC,If(aRotina[nOpc,4]==4,DEF_TRAEDT,DEF_TRAEXC))
EndIf

Do Case
	Case nOpc == 3
		cTra := DEF_TRAINC
	Case nOpc == 4
		cTra := DEF_TRAEDT
	Case nOpc == 5
		cTra := DEF_TRAEXC
	Otherwise
		cTra := DEF_TRAVIS 
EndCase 

lVisAprCt := (lVisAprCt != Nil .AND. lVisAprCt != .F.)	//DEFAULT

PRIVATE aTela    := {}
PRIVATE aGets    := {}

If cTra # DEF_TRAINC //Visualizacao OU Edicao OU Exclusao
	cContra := IIf(cContra == Nil, CNK->CNK_CONTRA , cContra)
	lRet := CN240VldUsr(cContra,cTra,.T.,lVisAprCt)
EndIf

If cTra == DEF_TRAEXC .And. CN9->(dbSeek(xFilial("CN9")+CNK->CNK_CONTRA))
	// Verifica se o contrato possui revisao
	If CN9->CN9_SITUAC == DEF_SREVD
		// Posiciona na revisao atual
		CN9->(dbSeek(xFilial("CN9")+ CN9->(CN9_NUMERO+CN9_REVATU) ) )
	Else
		CN9->(dbSeek(xFilial("CN9")+ CN9->(CN9_NUMERO+CN9_REVISA) ) )
	EndIf
	If CN9->CN9_SITUAC # DEF_SELAB //Verifica se o contrato está em fase de elaboração, caso não esteja não permite a exclusão do documento
		Help(" ",1,"CNTA100ELB") //"Acao disponivel apenas para contratos em Elaboracao"
		lRet:= .F.
	EndIf
EndIf
If lRet
	dbSelectArea("SX3")
	dbSeek("CNK")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona os campos do documento                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. SX3->X3_ARQUIVO == "CNK"
		cCampo := SX3->X3_CAMPO
		
		If X3Uso(GetSx3Cache(cCampo,'X3_USADO')) .And. cNivel >= GetSx3Cache(cCampo,'X3_NIVEL')
			Aadd(aCpos, cCampo )
		EndIF
		
		If	( GetSx3Cache(cCampo,'X3_CONTEXT') == "V"  .Or. nOpc == 3 )
			M->&(cCampo) := CriaVar(cCampo)
		Else
			M->&(cCampo) := CNK->(FieldGet(FieldPos(cCampo)))
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	aEditCpos := aClone(aCpos)
	
	If( nOpc == 3 .And. FwIsInCallStack('CN100IncDoc'))
		If(!Empty(cContra))
			M->CNK_CONTRA:= cContra
			
			If(aScan(aEditCpos,"CNK_CONTRA") > 0)				
				aDel(aEditCpos,aScan(aEditCpos,"CNK_CONTRA"))
				aSize(aEditCpos,Len(aEditCpos) - 1)
			EndIf
		EndIf
		If(!Empty(cTpDoc))
			M->CNK_TPDOC := cTpDoc
			aScan(aEditCpos,"CNK_TPDOC")
			
			If(aScan(aEditCpos,"CNK_TPDOC") > 0)				
				aDel(aEditCpos,aScan(aEditCpos,"CNK_TPDOC"))
				aSize(aEditCpos,Len(aEditCpos) - 1)
			EndIf
		EndIf
	EndIf
	
	// Calcula dimensões                                            
	oSize := FwDefSize():New()
	oSize:AddObject( "CABECALHO",  100, 100, .T., .T. )      
	oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
	oSize:Process() 	   // Dispara os calculos
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui botao do banco de conhecimento durante a    ³
	//³ visualizacao                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTra == DEF_TRAVIS
		AAdd(aButtons,{"clips", {|| CN170BcoDoc("CNK",CNK->(Recno()),nOpc) }, STR0008, STR0009 } )		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configura exibicao dos campos                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
	
	EnChoice( cAlias, nReg, nOpc,,,,aCpos ,;
					{oSize:GetDimension("CABECALHO","LININI"),oSize:GetDimension("CABECALHO","COLINI"),;
					 oSize:GetDimension("CABECALHO","LINEND"),oSize:GetDimension("CABECALHO","COLEND")},aEditCpos,,,,,,.T.)
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||If(Obrigatorio(aGets,aTela) .And. CN240VldUsr(M->CNK_CONTRA,cTra,.T.),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||(nOpcA:=2,oDlg:End())},,aButtons))
	
    If nOpcA == 1 .And. nOpc != 2
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Ponto de entrada permite ou não a gravação do documento    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
 		If (ExistBlock("CN170VLG"))
			 lCN170VLG := ExecBlock("CN170VLG",.F.,.F.,{nOpc})
			 If ValType(lCN170VLG) == "L"
				 lRet  := lCN170VLG
			 EndIf
		 EndIf    
		 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		 //³ Grava documento                                    ³
		 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
		 If lRet
			 lRet := CN170Grv(nOpc)
			 If lRet 
		         IF cCod != Nil
	    		     cCod := M->CNK_CODIGO
		         EndIf
	    	     If (__lSX8)
	                ConfirmSX8()
	             EndIf
	             EvalTrigger()
	             msUnlockAll()     
	         EndIf
   		EndIf
	Else
       lRet := .F.
   EndIf

	If !lRet 
		If (__lSX8)
	       RollBackSX8()
	    EndIf
	EndIf

EndIf

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN170Grv  ³ Autor ³ Marcelo Custodio      ³ Data ³09.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa gravacao do tipo de documento                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN170Grv(nExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN170Grv(nOpc)
Local nCntFor  := 0
Local lRet := .F.

Do Case
	Case nOpc == 3  //Incluir
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui documento                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNK")
		Reclock("CNK",.T.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)!="CNK_FILIAL")
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		CNK->CNK_FILIAL := xFilial("CNK")
		MsUnlock()
		lRet := .T.
	Case nOpc == 4  //Atualizar
		dbSelectArea("CNK")
		Reclock("CNK",.F.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)!="CNK_FILIAL")
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		CNK->CNK_FILIAL := xFilial("CNK")
		MsUnlock()
		lRet := .T.
	Case nOpc == 5  //Exclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui a amarracao com os conhecimentos                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MsDocument( "CNK", CNK->( RecNo() ), 2, , 3 )
		
		Reclock("CNK",.F.)
		dbDelete()
		MsUnlock()
		lRet := .T.
EndCase

If ExistBlock("CN170GRD")
	ExecBlock("CN170GRD",.F.,.F.,{nOpc})
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN170Conh ³ Autor ³ Marcelo Custodio      ³ Data ³09.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa base de conhecimento                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN170Conh()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN170Conh()
Local aRotBack := If(Type("aRotina") == "A",aClone( aRotina ),{})
Local nBack    := 0

If Type( "N" ) == "N"
	nBack := N
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Simula aRotina                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina := {}

Aadd(aRotina,{STR0007,"MsDocument", 0 , 4}) //"Conhecimento"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa banco de conhecimento                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsDocument( "CNK", CNK->( Recno() ), 1 )

aRotina := AClone( aRotBack )

If !Empty( nBack )
	N := nBack
EndIf

Return( .t. )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³19/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()     
PRIVATE aRotina	:= 	{ 	{ OemToAnsi(STR0002), "AxPesqui"	, 0, 1, 0, .F.},; 	 //"Pesquisar"
								{ OemToAnsi(STR0003), "CN170Manut"	, 0, 2, 0, nil},;		//"Visualizar"
								{ OemToAnsi(STR0004), "CN170Manut"	, 0, 3, 0, nil},;		//"Incluir"
								{ OemToAnsi(STR0005), "CN170Manut"	, 0, 4, 0, nil},;		//"Alterar"
								{ OemToAnsi(STR0006), "CN170Manut"	, 0, 5, 0, nil},;		//"Excluir"
								{ OemToAnsi(STR0007), "CN170BcoDoc" , 0, 4, 0, nil}}   //Conhecimento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTA170MNU")
	ExecBlock("CTA170MNU",.F.,.F.)
EndIf
Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN170VLDDT³ Autor ³ Marcelo Custodio      ³ Data ³18/12/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida as datas do documento de contrato                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN170VLDDT()                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN170VLDDT(nCampo)
Local lRet := .T.

If !Empty(M->CNK_DTEMIS) .And. !Empty(M->CNK_DTVALI) .And. M->CNK_DTEMIS > M->CNK_DTVALI
	lRet := .F.
	Aviso (STR0012,STR0011,{STR0013},2)//"Atenção"##"A data de emissão deve ser inferior a data de vencimento"##"OK"
EndIf

Return lRet
