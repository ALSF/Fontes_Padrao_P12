#INCLUDE "PROTHEUS.CH"
#INCLUDE "CNTA210.ch"        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA210  ³ Autor ³ Marcelo Custodio      ³ Data ³29.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Amarracao Tipo de Contrato X Tipo de Documento X Situacao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA210()                                                  ³±±
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
Function CNTA210(nPosArotina,lAutomato)
Private cCadastro := STR0001 //Cadastro de Cauções

PRIVATE aRotina := MenuDef()

DEFAULT nPosArotina := 0
DEFAULT lAutomato   := .F.

dbSelectArea("CNJ")
dbSetOrder(1)

If	nPosArotina > 0
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina,lAutomato)
Else
	mBrowse(6,1,22,75,"CNJ")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN210Manut³ Autor ³ Marcelo Custodio      ³ Data ³29.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ gerencia a edicao/inclusao/alteracao da tabela CNJ         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN210Manut()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN210Manut(cAlias,nReg,nOpc,lAutomato)
Local aSize := MsAdvSize()
Local aObjects := {}
Local aNoFields:= {"CNJ_SITUAC","CNJ_TPCTO","CNJ_DESCTC"}//Colunas exibidas na enchoice 
Local aCpoEnch := {}//Colunas exibidas na enchoice
Local aPosObj  := {}
Local aInfo    := {}
Local cSeek    := ""
Local cWhile   := ""
Local cCampo	:= ""
Local oDlg

PRIVATE aTela := {}
PRIVATE aGets := {}

PRIVATE oGetd
Private aHeader := {}
Private aCols   := {}

DEFAULT lAutomato := .F. 

Aadd(aObjects, { 100,  50, .T., .T. } )
Aadd(aObjects, { 100, 140, .T., .T. } )

aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj := MsObjSize(aInfo, aObjects,.T.)

CNJ->(dbGoTo(nReg))
dbSelectArea("SX3")
MsSeek("CNJ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica campos da CNJ  - Monta Enchoice             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof() .And. SX3->X3_ARQUIVO == "CNJ"
	cCampo := SX3->X3_CAMPO
	If X3Uso(X3_USADO) .And. cNivel >= GetSx3Cache(cCampo,'X3_NIVEL')
		If Ascan(aNoFields,AllTrim(cCampo)) > 0 .Or. GetSx3Cache(cCampo,'X3_PROPRI') == "U" //Verifica se o campo vai para a enchoice ou getdados
			aAdd(aCpoEnch,cCampo)//Adiciona campo na enchoice
			If	( GetSx3Cache(cCampo,'X3_CONTEXT') == "V" .Or. aRotina[nOpc,4] == 3 )
				M->&(cCampo) := CriaVar(cCampo)
			Else
				M->&(cCampo) := CNJ->(FieldGet(FieldPos(cCampo)))
			EndIf
		EndIf
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If aRotina[nOpc,4] != 3
	dbSelectArea("CNJ")
	dbGoTo(nReg)
	
   cSeek	 := xFilial("CNJ")+CNJ->CNJ_SITUAC+CNJ->CNJ_TPCTO
   cWhile := "CNJ_FILIAL+CNJ_SITUAC+CNJ_TPCTO" 
	FillGetDados(nOPc,"CNJ",1,cSeek,{|| &cWhile },{|| .T. },aNoFields,,,,,,aHeader,aCols)				
Else
	FillGetDados(nOpc,"CNJ",1,,,,aNoFields,,,,,.T.,aHeader,aCols)
EndIf

//-- lAutomato, recurso exclusivo para teste da automação disparado pelo CNTA060TestCase
If	lAutomato
	If nOpc == 5
		CN210Grv({},{},{},nOpc,nReg)
	ElseIf FindFunction("GetParAuto")
		aRetAuto := GetParAuto("CNTA210TESTCASE")
		If	EnchAuto("CNJ",aRetAuto[1],,,aCpoEnch) .And. MsGetDAuto( aRetAuto[2],  {|| CN210LinOK(lAutomato) }, {|| CN210CabOk(aCpoEnch,oDlg,nReg,nOpc,lAutomato) .And. CN210VldTd(lAutomato) } , aRetAuto[1],nOpc)
			CN210Grv(aCols,aHeader,aCpoEnch,nOpc,nReg)
		EndIf	 	
	EndIf
Else			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta dialog                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configura Enchoice                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EnChoice( cAlias, nReg, nOpc,,,,aCpoEnch, aPosObj[1], , , , , , , , .T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configura getdados                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetd	:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(aRotina[nOpc,4]!=3 .And. aRotina[nOpc,4]!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),"CN210LinOK()",,,,,,,,,oDlg,aHeader,aCols)
	oGetd:oBrowse:bGotFocus	:= {||CN210CabOk(aCpoEnch,oDlg,nReg,nOpc) }
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(Obrigatorio(aGets,aTela) .And. CN210CabOk(aCpoEnch,oDlg,nReg,nOpc) .And. CN210VldTd() .And. CN210LinOK(),(CN210Grv(oGetd:aCols,oGetd:aHeader,aCpoEnch,nOpc,nReg),oDlg:End()),)},{||(oDlg:End())})
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN210Grv  ³ Autor ³ Marcelo Custodio      ³ Data ³29.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa gravação dos itens da amarracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN210Grv(aExp01,aExp02,aExp03,nExp04,nExp05)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Linhas da getdados                                ³±±
±±³          ³ aExp02 - Cabecalho da getdados                             ³±±
±±³          ³ aExp03 - Itens exibidos na Enchoice                        ³±±
±±³          ³ nExp04 - Opcao selecionada pelo usuario                    ³±±
±±³          ³ aExp05 - Registro atual da tabela                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN210Grv(aCols,aHeader,aCpoEnch,nOpc,nReg)
Local nx
Local nUsado := len(aHeader)
Local nCpo                  
Local cFilCod := xFilial("CNJ")
Local nPosTDc := aScan(aHeader,{|x| AllTrim(x[2]) == "CNJ_TPDOC"})
Local cSituac := ""
Local cTpCto  := ""

dbSelectArea("CNJ")
dbSetOrder(1)

dbGoTo(nReg)
cSituac := CNJ->CNJ_SITUAC
cTpCto  := CNJ->CNJ_TPCTO

Do Case
	Case aRotina[nOpc,4] == 3//Inclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Replica cabecalho para todos os registros            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx:= 1 to len(aCols)
			If !aCols[nx,nUsado+1]
				RecLock("CNJ",.T.)
				For nCpo:=1 to len(aCpoEnch)//Preenche campos da enchoice
					If aCpoEnch[nCpo] == "CNJ_SITUAC"
					CNJ->&(aCpoEnch[nCpo]) := PadL(M->&(aCpoEnch[nCpo]),2,"0")
					Else
					CNJ->&(aCpoEnch[nCpo]) := M->&(aCpoEnch[nCpo])
					EndIF
				Next
				For nCpo:=1 to len(aHeader)//Preenche campos da getdados
					CNJ->&(aHeader[nCpo,2]) := aCols[nx,nCpo]
				Next
				CNJ->CNJ_FILIAL := cFilCod
				MsUnlock()
			EndIf
		Next
	Case aRotina[nOpc,4] == 4//Alteracao
		dbGoto(nReg)
		//-- Exclui itens
		CNJ->(DbSetOrder(1))		
		For nx:= 1 to len(aCols)
			If CNJ->(MsSeek(cFilCod+cSituac+cTpCto))
				RecLock("CNJ",.F.)
				dbDelete()
				MsUnlock()
			EndIF
		Next nx
		dbGoto(nReg)
		For nx:= 1 to len(aCols)
			If !aCols[nx,nUsado+1]
				If CNJ->(MsSeek(cFilCod+cSituac+cTpCto+aCols[nX,nPosTDc]))
					RecLock("CNJ",.F.)//Edita registro
				Else
					RecLock("CNJ",.T.)//Cria registro
					CNJ->CNJ_FILIAL := cFilCod
				EndIF
				For nCpo:=1 to len(aCpoEnch)//Preenche campos da enchoice
					CNJ->&(aCpoEnch[nCpo]) := M->&(aCpoEnch[nCpo])
				Next
				For nCpo:=1 to len(aHeader)//Preenche campos da getdados
					CNJ->&(aHeader[nCpo,2]) := aCols[nx,nCpo]
				Next
				MsUnlock()
			EndIf
		Next		
	Case aRotina[nOpc,4] == 5//Exclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui todos os registros da configuracao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSeek(cFilCod+M->CNJ_SITUAC+M->CNJ_TPCTO)
		While !Eof() .And. CNJ->CNJ_FILIAL == cFilCod .And. CNJ->CNJ_SITUAC == M->CNJ_SITUAC .And. CNJ->CNJ_TPCTO == M->CNJ_TPCTO
			RecLock("CNJ",.F.)
			dbDelete()
			MsUnlock()
			CNJ->(dbSkip())
		EndDo
EndCase
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN210VldTd³ Autor ³ Marcelo Custodio      ³ Data ³29.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida amarracao SituacaoXTipo de ContratoXTipo de Docs.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN210VldTd()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN210VldTd(lAutomato)
Local lRet := .T.
Local nPosTd:= 0
DEFAULT lAutomato := .F.

If	!lAutomato
	aHeader := AClone(oGetd:aHeader)
	aCols	:= AClone(oGetd:aCols)
EndIf

nPosTd:= aScan(aHeader,{|x| AllTrim(x[2])=="CNJ_TPDOC"})

if len(aCols) == 1 .And. (Empty(aCols[1,nPosTd]) .OR. aCols[1,len(aHeader)+1])
	Aviso("CNTA210",OemToAnsi(STR0008),{"OK"})
	lRet:=.F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN210CabOk³ Autor ³ Marcelo Custodio      ³ Data ³29.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida cabecalho da amarracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN210CabOk(aExp01,oExp02,nExp03,nExp04)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Itens exibidos na enchoice                        ³±±
±±³          ³ oExp02 - Dialog                                            ³±±
±±³          ³ nExp03 - Registro atual                                    ³±±
±±³          ³ nExp04 - Opcao selecionada pelo usuario                    ³±±
±±³          ³ lExp05 - Execução pelo robo de testes                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN210CabOk(aCpoEnch,oDlg,nReg,nOpc,lAutomato)
Local lRet 	  	 := .T.
Local lAuxRet1 	 := .T.
Local lAlcDocCtr := .F.
Local n			 := 0
Local cSitOrg	 := ""
Local cTpcOrg	 := ""

DEFAULT lAutomato:=.F.

If(aRotina[nOpc,4] == 5)//Exclusao
	lRet := .T.
Else
	dbSelectArea("CNJ")
	dbSetOrder(1)
	
	If dbSeek(xFilial("CNJ")+M->CNJ_SITUAC+M->CNJ_TPCTO)
		If(aRotina[nOpc,4] == 3)//Inclusao
			lRet := .F.//Nao permite duplicacao
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Armazena situacao e tipo de contrato alterados para  ³
			//³ comparacao com o original, pois em caso de alteracao ³
			//³ deve ser verificado se o registro encontrado nao se  ³
			//³ trata do mesmo em edicao                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSitOrg := M->CNJ_SITUAC
			cTpcOrg := M->CNJ_TPCTO
			dbGoTo(nReg)
			If cSitOrg != CNJ->CNJ_SITUAC .OR. cTpcOrg != CNJ->CNJ_TPCTO
				lRet := .F.
			EndIf
		EndIf
	Else
		//Verifica se o contrato possui controle de alçada para bloquear a amarração com a situação VIGENTE
		DbSelectArea("CN1")
		CN1->(DbSetOrder(1))
		If CN1->(DbSeek(xFilial("CN1")+M->(CNJ_TPCTO)))
			lAlcDocCtr := ( CN1->CN1_ALCCTR $ "0|1" )
			
			If lAlcDocCtr .AND. M->(CNJ_SITUAC) == "05"
				lRet 	 := .F.
				lAuxRet1 := .F.
			EndIf
		EndIf
	EndIf
	
	If !lRet
	
		If !lAuxRet1
			Aviso("CNTA210",OemToAnsi(STR0010)+CRLF+OemToAnsi(STR0011),{"OK"})	//"Este tipo de contrato possui controle de aprovação por alçada." ##
																				//"Nesse caso não é permitida a amarração de documentos com a situação VIGENTE."
		Else
			Aviso("CNTA210",OemToAnsi(STR0007),{"OK"}) //"A configuração informada já se encontrada registrada no sistema."
		EndIf
		If !lAutomato
			n := ascan(oDlg:acontrols,{|x| x:CREADVAR = "M->CNJ_SITUAC"})//Encontra posicao do controle referente a situacao
			if(n > 0)
				oDlg:acontrols[n]:SetFocus()//Move o foco para a situacao
			EndIF
		EndIf
	EndIF
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN210LinOk³ Autor ³ Marcelo Custodio      ³ Data ³29.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida linha da getdados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN210linOk()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN210LinOK(lAutomato)  
Local nPosTD  := 0
Local lRet    := .T.
Local nUsado  := 0
Local nA      := 1
Local nI      := 0
Local lRepetido := .F.
Local lExist	:= .F.

DEFAULT lAutomato := .F.

If	!lAutomato
	aHeader := AClone(oGetd:aHeader)
	aCols   := AClone(oGetd:aCols)
	nA      := oGetd:nAt
EndIf
nPosTD := aScan(aHeader,{|x| AllTrim(x[2]) == "CNJ_TPDOC"})
nUsado := len(aHeader)+1

//Alteração feita para automatização do robo
//Verificação do conteudo informado para não permitir a gravação de codigo inexistente
If lAutomato
	For nI := 1 to Len(aCols)
		If !Empty(aCols[nI,nPosTD])
			lExist := ExistCpo("CN5",aCols[nI,nPosTD])		
			If !lExist
				Help(" ",1,"REGNOIS")
				lRet := .F.			
			EndIf					
		EndIf
	Next nI
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe outro item com a mesma configuracao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !Empty(aCols[nA,nPosTD])
	If Len( aCols ) > 1 .And. !aCols[nA][nUsado]
		
		For nI:= 1 To Len( aCols )
			If ( nI != nA ) .and. !aCols[nI][nUsado]
				If aCols[nI,nPosTD] == aCols[nA,nPosTD]
					lRepetido := .T.
					Exit
				Endif
			Endif
		Next nI
		
		If lRepetido
			lRet:=.F.
			Help(" ",1,"JAGRAVADO")
		End
	Endif
Else
	Aviso("CNTA210",OemToAnsi(STR0009),{"OK"})//"Preencha o tipo do documento"
	lRet := .F.
EndIf

Return lRet  

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
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
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
PRIVATE aRotina	:= 	{ 	{ STR0002, "AxPesqui"  	, 0, 1, 0, .F.},;//"Pesquisar"
						{ STR0003, "CN210Manut"	, 0, 2, 0, nil},;//"Visualizar"
						{ STR0004, "CN210Manut" , 0, 3, 0, nil},;//"Incluir"
						{ STR0005, "CN210Manut"	, 0, 4, 0, nil},;//"Alterar"
						{ STR0006, "CN210Manut"	, 0, 5, 0, nil} }//"Excluir"	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTA210MNU")
	ExecBlock("CTA210MNU",.F.,.F.)
EndIf
Return(aRotina) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN210TpDoc³ Autor ³ Antenor Silva         ³ Data ³21.03.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida tipo de documentos                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN210TpDoc()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN210TpDoc()
Local cValor  := &(ReadVar())
Local nPosTD  := 0
Local lRet    := .T.
Local nUsado  := 0
Local nA      := 1
Local nI      := 0

nPosTD := aScan(aHeader,{|x| AllTrim(x[2]) == "CNJ_TPDOC"})
nUsado := len(aHeader)+1

If !Empty(aCols[nA,nPosTD])
	If Len( aCols ) > 1 .And. !aCols[nA][nUsado]		
		For nI:= 1 To Len( aCols )
			If ( nI != nA ) .and. !aCols[nI][nUsado]
				If cValor == aCols[nI,nPosTD]
					lRet:=.F.
					Help(" ",1,"JAGRAVADO")
					Exit
				EndIf
			EndIf
		Next nI
	EndIf
EndIf

Return lRet