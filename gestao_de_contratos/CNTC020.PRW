#INCLUDE "DBTREE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "CNTC020.CH" 
#INCLUDE "FWMVCDEF.CH"

#DEFINE IMG_EDIT "PMSTASK1"
#DEFINE IMG_NEW  "PMSTASK2"
#DEFINE IMG_OK   "PMSTASK3"
#DEFINE IMG_DEL  "PMSTASK4"

//Registros
#DEFINE NPOS_FIELD 1
#DEFINE NPOS_TITLE 2
#DEFINE NPOS_NALT  3
#DEFINE NPOS_ALIAS 4
#DEFINE NPOS_CHAVE 5
#DEFINE NPOS_ADD   6
#DEFINE NPOS_DEL   7
#DEFINE NPOS_DESCR 8

//Valores
#DEFINE APOS_ALIAS 1
#DEFINE APOS_FIELD 2
#DEFINE APOS_TITLE 3
#DEFINE APOS_VLORI 4
#DEFINE APOS_VLDST 5
#DEFINE APOS_CHAVE 6


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNTC020   ºAutor  ³Marcelo Custodio    º Data ³  02/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de comparação das revisoes de contrato              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CNTC020()

If Pergunte( "CNC020", .T., STR0001 ) //"Comparador de Revisão"
	dbSelectArea("CN9")
	dbSetOrder(1)
	
	If dbSeek(xFilial("CN9")+mv_par01+mv_par02) .And. dbSeek(xFilial("CN9")+mv_par01+mv_par03)
		CNC020()
	EndIf

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020    ³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Comparador de Revisoes de Contrato                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNC020()                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020()
Local aSize    := MsAdvSize( .F. ) 
Local aItens   := {}
Local aValores := {}
Local cValorA  := ""
Local cValorO  := ""
Local cSituCb  := "1"
Local lDif     := .T.
Local lSic     := .T.
Local oGetA
Local oGetO
Local oCbx
Local oSituCb
Local oTree
Local oTree2

Local oDif
Local oSic

Local lFisico := .F.//Informa se o contrato possui cronograma fisico

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta estrutura visual ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {} 
aObjects2 := {}

AAdd( aObjects, { 100, 90, .T., .T., .T. } )
AAdd( aObjects, { 100, If(oMainWnd:nClientWidth > 800,25,40), .T., .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 4, 4 } 
aPosObj1 := MsObjSize( aInfo, aObjects, .T., .F. ) 

AAdd( aObjects2, { 100, 100, .T., .T., .F. } )
AAdd( aObjects2, { 100, 100, .T., .T., .F. } )

aInfo := { aPosObj1[1,1], aPosObj1[1,2], aPosObj1[1,3], aPosObj1[1,4], 4, 4 } 
aPosObj2 := MsObjSize( aInfo, aObjects2, .T., .T. ) 
	
DEFINE MSDIALOG oDlg FROM	aSize[7],00 TO aSize[6],aSize[5] TITLE STR0001 OF oMainWnd PIXEL//"Comparador de Revisão"

oTree  := DbTree():New(aPosObj2[1,1],aPosObj2[1,2],aPosObj2[1,3],aPosObj2[1,4],oDlg,{|| CNC020LdVl(oTree,oTree2,"1",@cValorA,@cValorO,aValores,lSic),oGetA:Refresh(),oGetO:Refresh()},,.T.)
oTree2 := DbTree():New(aPosObj2[2,1],aPosObj2[2,2],aPosObj2[2,3],aPosObj2[2,4],oDlg,{|| CNC020LdVl(oTree,oTree2,"2",@cValorA,@cValorO,aValores,lSic),oGetA:Refresh(),oGetO:Refresh()},,.T.)
	
aValores := CNC020Ld("1",oTree,oTree2,lDif,lFisico)

@ aPosObj1[2,1],aPosObj1[2,2] TO aPosObj1[2,3],aPosObj1[2,4] OF oDlg PIXEL

@ aPosObj1[2,1]+7,aPosObj1[2,2]+5 Say STR0002 Size 20,8 PIXEL//"Entidade"
@ aPosObj1[2,1]+5,aPosObj1[2,2]+30 ComboBox oSituCb Var cSituCb ON CHANGE {aValores := CNC020Ld(cSituCb,oTree,oTree2,lDif, lFisico)} SIZE 80,5 OF oDlg PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza combobox      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CNC020Cbo(oSituCb,@cSituCb)

@ aPosObj1[2,1]+18,aPosObj1[2,2]+5 CheckBox oDif Var lDif Prompt STR0003 Size 060, 015 PIXEL OF oDlg On Click {aValores := CNC020Ld(cSituCb,oTree,oTree2,lDif,lFisico)}//"Apenas Diferencas"
@ aPosObj1[2,1]+28,aPosObj1[2,2]+5 CheckBox oSic Var lSic Prompt STR0004 Size 060, 015 PIXEL OF oDlg//"Sincronizar"

@ aPosObj1[2,1]+7,aPosObj1[2,2]+125 Say STR0005 Size 40,8 PIXEL//"Valor Original"
@ aPosObj1[2,1]+5, aPosObj1[2,2]+180 MsGet oGetO Var cValorO SIZE 70,8 WHEN .F. RIGHT PIXEL
@ aPosObj1[2,1]+22,aPosObj1[2,2]+125 Say STR0006 Size 40,8 PIXEL//"Valor Atual"
@ aPosObj1[2,1]+20, aPosObj1[2,2]+180 MsGet oGetA Var cValorA SIZE 70,8 WHEN .F. RIGHT PIXEL

@ aPosObj1[2,1]+5, aPosObj1[2,4]-45 BUTTON STR0007 SIZE 040,012 FONT oDlg:oFont ACTION {aValores := CNC020Ld(cSituCb,oTree,oTree2,lDif, lFisico)} OF oDlg PIXEL//"Atualizar"
@ aPosObj1[2,1]+18, aPosObj1[2,4]-45 BUTTON STR0008 SIZE 040,012 FONT oDlg:oFont ACTION (If(Pergunte( "CNC020", .T., "Comparador" ),{CNC020Cbo(oSituCb,cSituCb),aValores := CNC020Ld(cSituCb,oTree,oTree2,lDif, lFisico)},)) OF oDlg PIXEL//"Parãmetros"
@ aPosObj1[2,1]+31, aPosObj1[2,4]-45 BUTTON STR0022 SIZE 040,012 FONT oDlg:oFont ACTION (CNC020Leg()) OF oDlg PIXEL//"Legenda"
@ aPosObj1[2,1]+44, aPosObj1[2,4]-45 BUTTON STR0009 SIZE 040,012 FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL//"Sair"

MENU oMnTree POPUP
	MENUITEM STR0010 Action CNC020Vis(oTree,.T.)//"Visualizar"
ENDMENU

MENU oMnTree2 POPUP
	MENUITEM STR0010 Action CNC020Vis(oTree2,.F.)//"Visualizar"
ENDMENU

oTree:bRClicked    := { |oObject,nx,ny| oMnTree:Activate( nX-30, nY-120, oObject ) }
oTree2:bRClicked   := { |oObject,nx,ny| oMnTree2:Activate( nX-500, nY-120, oObject ) }

ACTIVATE MSDIALOG oDlg 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Cbo ³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Configura o ComboBox das Entidades                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNC020Cbo(oExp01,cExp02)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - ComboBox                                          ³±±
±±³          ³ oExp01 - ComboBox                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Cbo(oSituCb,cSituCb)
Local aItens := {}

dbSelectArea("CN9")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no crontrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dbSeek(xFilial("CN9")+mv_par01+mv_par02)
	dbSelectArea("CN1")
	dbSetOrder(1)
	If dbSeek(xFilial("CN1")+CN9->CN9_TPCTO)
		lFisico := (CN1->CN1_CROFIS == "1")//Informa se o contrato possui cronograma fisico
	EndIf
EndIf

aItens := {STR0011}//"1=Contrato"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza controle visual ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSituCb:aItems := aItens
cSituCb := "1"
oSituCb:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Ld  ³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Processa a atualizacao da entidade                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aExp01 := CNC020Ld(cExp01,oExp02,oExp03,lExp04)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Retorna array com os valores                      ³±±
±±³          ³ Estrutura:                                                 ³±±
±±³          ³ aExp01 - Resultado:                                        ³±±
±±³          ³             aExp01[x,APOS_ALIAS] - Alias                   ³±±
±±³          ³             aExp01[x,APOS_FIELD] - Campo                   ³±±
±±³          ³             aExp01[x,APOS_TITLE] - Titulo do Campo         ³±±
±±³          ³             aExp01[x,APOS_VLORI] - Valor Original          ³±±
±±³          ³             aExp01[x,APOS_VLDST] - Valor Atual             ³±±
±±³          ³             aExp01[x,APOS_CHAVE] - Chave do item           ³±±
±±³          ³ cExp02 - Opcao selecionada (1-Contrato,2-Planilha,3-Cronogr³±±
±±³          ³          ama fisico/financeiro,4-cronograma contabil)      ³±±
±±³          ³ oExp03 - Objeto tree original                              ³±±
±±³          ³ oExp04 - Objeto tree atual                                 ³±±
±±³          ³ lExp05 - Informa se exibe apenas diferencas                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Ld(cOpc,oTree,oTree2,lDif, lFisico)
Local aRet := {}
	
Processa( {|| aRet := CNC020Val(cOpc,oTree,oTree2,lDif,lFisico) } , STR0015 )//"Processando Registros"

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Val ³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza a entidade do contrato                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aExp01 := CNC020Val(cExp01,oExp02,oExp03,lExp04)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Retorna array com os valores                      ³±±
±±³          ³ Estrutura:                                                 ³±±
±±³          ³ aExp01 - Resultado:                                        ³±±
±±³          ³             aExp01[x,APOS_ALIAS] - Alias                   ³±±
±±³          ³             aExp01[x,APOS_FIELD] - Campo                   ³±±
±±³          ³             aExp01[x,APOS_TITLE] - Titulo do Campo         ³±±
±±³          ³             aExp01[x,APOS_VLORI] - Valor Original          ³±±
±±³          ³             aExp01[x,APOS_VLDST] - Valor Atual             ³±±
±±³          ³             aExp01[x,APOS_CHAVE] - Chave do item           ³±±
±±³          ³ cExp02 - Opcao selecionada (1-Contrato,2-Planilha,3-Cronogr³±±
±±³          ³          ama fisico/financeiro,4-cronograma contabil)      ³±±
±±³          ³ oExp03 - Objeto tree original                              ³±±
±±³          ³ oExp04 - Objeto tree atual                                 ³±±
±±³          ³ lExp05 - Informa se exibe apenas diferencas                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Val(cOpc,oTree,oTree2,lDif,lFisico)
Local nx:=0
Local ny:=0
Local nz:=0
Local cEntidade :="" 
Local cEntidade2:="" 
Local aRet :={}
Local aRet2:={}
Local nTamChv :=""
Local nTamChv2:=""
Local cCargoIni:= ""
Local aVal := {}
Local aOri := {}
Local aDst := {}
Local aVal2 := {}
Local aOri2 := {}
Local aDst2 := {}
Local lSub  := .F.
Local aFields := {}
Local aCurrent  := {}
Local aCurrent2 := {}
Local aChave := {}
Local cAlias := ""
Local cRsc := ""
Local cChave := ""
Local lEmpty := .T.
Local lFuser := ExistBlock("CTC020FLD")
Local aFuser := {}
Local nPos   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada para selecao dos campos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTC020FLD")
	aFuser := ExecBlock("CTC020FLD",.F.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa atualizacao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CursorWait()
oTree:BeginUpdate()
oTree2:BeginUpdate()

Do Case
	Case cOpc == "1"//Contrato
		ProcRegua(7)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica campos do ponto de entrada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aFuser,{|x| x[1] == "CN9"})) > 0
			aFields := aFuser[nPos,2]
		Else
			aFields := {"CN9_NUMERO","CN9_REVISA","CN9_VLATU","CN9_DTFIM"}
		EndIf
		
		aChave  := {"CN9_NUMERO"}//Chave
		cAlias  := "CN9"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega tabela do contrato - CN9    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRet := CNC020Prt(cAlias,aChave,aFields,lDif,"CN9_NUMERO = '"+mv_par01+"' AND CN9_REVISA = '"+mv_par02+"'","CN9_NUMERO = '"+mv_par01+"' AND CN9_REVISA = '"+mv_par03+"'",.T.,"Contrato")
		nTamChv   := TamSX3("CN9_NUMERO")[1]//Tamanho da chave
		
	Case cOpc == "2"
		ProcRegua(10)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica campos do ponto de entrada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aFuser,{|x| x[1] == "CNA"})) > 0
			aFields := aFuser[nPos,2]
		Else
			aFields := {"CNA_NUMERO","CNA_REVISA","CNA_VLTOT","CNA_VLCOMS"}
		EndIf
		
		aChave  := {"CNA_NUMERO"}//Chave
		cAlias  := "CNA"	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega tabela da planilha - CNA    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRet := CNC020Prt(cAlias,aChave,aFields,lDif,"CNA_CONTRA = '"+mv_par01+"' AND CNA_REVISA = '"+mv_par02+"'","CNA_CONTRA = '"+mv_par01+"' AND CNA_REVISA = '"+mv_par03+"'",.F.,"Planilha")
		nTamChv   := TamSX3("CNA_NUMERO")[1]//Tamanho da chave
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica campos do ponto de entrada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aFuser,{|x| x[1] == "CNB"})) > 0
			aFields := aFuser[nPos,2]
		Else
			aFields := {"CNB_ITEM","CNB_QUANT","CNB_VLUNIT","CNB_VLTOT"}
		EndIf
		
		aChave  := {"CNB_NUMERO","CNB_ITEM"}//Chave
		cAlias  := "CNB"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega tabela dos itens de planilha - CNB³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRet2 := CNC020Prt(cAlias,aChave,aFields,lDif,"CNB_CONTRA = '"+mv_par01+"' AND CNB_REVISA = '"+mv_par02+"'","CNB_CONTRA = '"+mv_par01+"' AND CNB_REVISA = '"+mv_par03+"'",.T.,"Itens")
		nTamChv2   := TamSX3("CNB_NUMERO")[1]+TamSX3("CNB_ITEM")[1]//Tamanho da chave

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica limite da chave ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nTamChv2 > nTamChv
			nTamChv := nTamChv2
		EndIf
		
		lSub := .T.//Informa que a entidade possui sub-itens
		
	Case cOpc == "3"                                                                                   	
		ProcRegua(If(lFisico,10,7))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica campos do ponto de entrada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aFuser,{|x| x[1] == "CNF"})) > 0
			aFields := aFuser[nPos,2]
		Else
			aFields := {"CNF_NUMERO","CNF_PARCEL","CNF_COMPET","CNF_PRUMED","CNF_VLPREV","CNF_SALDO"}
		EndIf

		aChave  := {"CNF_NUMERO","CNF_PARCEL"}//Chave
		cAlias  := "CNF"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega tabela do cronograma financeiro - CNF³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRet := CNC020Prt(cAlias,aChave,aFields,lDif,"CNF_CONTRA = '"+mv_par01+"' AND CNF_REVISA = '"+mv_par02+"'","CNF_CONTRA = '"+mv_par01+"' AND CNF_REVISA = '"+mv_par03+"'",!lFisico,"Cronograma Financeiro")
		nTamChv   := TamSX3("CNF_NUMERO")[1]+TamSX3("CNF_PARCEL")[1]//Tamanho da Chave

		If lFisico

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica campos do ponto de entrada ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nPos := aScan(aFuser,{|x| x[1] == "CNS"})) > 0
				aFields := aFuser[nPos,2]
			Else
				aFields := {"CNS_PRVQTD","CNS_SLDQTD"}
			EndIf

			aChave  := {"CNS_CRONOG","CNS_PARCEL","CNS_ITEM"}//Chave
			cAlias  := "CNS"
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega tabela do cronograma fisico - CNS  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aRet2 := CNC020Prt(cAlias,aChave,aFields,lDif,"CNS_CONTRA = '"+mv_par01+"' AND CNS_REVISA = '"+mv_par02+"'","CNS_CONTRA = '"+mv_par01+"' AND CNS_REVISA = '"+mv_par03+"'",.T.,"Cronograma Fisico")
			nTamChv2   := TamSX3("CNS_CRONOG")[1]+TamSX3("CNS_PARCEL")[1]+TamSX3("CNS_ITEM")[1]//Tamanho da Chave
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica limite da chave ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTamChv2 > nTamChv
				nTamChv := nTamChv2
			EndIf  

			lSub := .T.//Informa que a entidade possui sub-itens
		EndIf
		
	Case cOpc == "4"	
		ProcRegua(10)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica campos do ponto de entrada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aFuser,{|x| x[1] == "CNV"})) > 0
			aFields := aFuser[nPos,2]
		Else
			aFields := {"CNV_NUMERO"}
		EndIf

		aChave  := {"CNV_NUMERO"}//Chave
		cAlias  := "CNV"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega tabela do cronograma contabil - CNV  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRet := CNC020Prt(cAlias,aChave,aFields,lDif,"CNV_CONTRA = '"+mv_par01+"' AND CNV_REVISA = '"+mv_par02+"'","CNV_CONTRA = '"+mv_par01+"' AND CNV_REVISA = '"+mv_par03+"'",.F.,"Cronograma Contabil")	
		nTamChv   := TamSX3("CNV_NUMERO")[1]//Tamanho da Chave
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica campos do ponto de entrada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aFuser,{|x| x[1] == "CNW"})) > 0
			aFields := aFuser[nPos,2]
		Else
			aFields := {"CNW_DTPREV","CNW_VLPREV"}
		EndIf

		aChave  := {"CNW_NUMERO","CNW_PARCEL"}//Chave
		cAlias  := "CNW"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega tabela das parcelas dos cronogramas contabeis - CNW  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRet2 := CNC020Prt(cAlias,aChave,aFields,lDif,"CNW_CONTRA = '"+mv_par01+"' AND CNW_REVISA = '"+mv_par02+"'","CNW_CONTRA = '"+mv_par01+"' AND CNW_REVISA = '"+mv_par03+"'",.T.,"Parcela")
		nTamChv2   := TamSX3("CNW_NUMERO")[1]+TamSX3("CNW_PARCEL")[1]//Tamanho da Chave

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica limite da chave ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nTamChv2 > nTamChv
			nTamChv := nTamChv2
		EndIf  

		lSub := .T.//Informa que a entidade possui sub-itens

End Case

IncProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega retorno dos processamentos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVal := aRet[1]//Valores
aOri := aRet[2]//Origem
aDst := aRet[3]//Atual

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem subitens       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSub
	aVal2 := aRet2[1]//Valores
	aOri2 := aRet2[2]//Origem
	aDst2 := aRet2[3]//Atual
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa cargo com o tamanho limite da chave  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCargoIni := Space(nTamChv+13)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa preenchimento dos dbTree   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTree:Reset()
oTree:AddItem(PadR(STR0016+" - " + mv_par01 + If(!Empty(mv_par02)," - " + STR0017 + " - "+ mv_par02,""),100),cCargoIni)//"Contrato"##"Revisão"
oTree2:Reset()
oTree2:AddItem(PadR(STR0016+" - " + mv_par01 + If(!Empty(mv_par03)," - "+ STR0017 +" - " + mv_par03,""),100),cCargoIni)//"Contrato"##"Revisão"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega dbTree - origem  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CNC020Tree(oTree,aOri,aOri2,lSub,cCargoIni)
IncProc()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega dbTree - destino ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CNC020Tree(oTree2,aDst,aDst2,lSub,cCargoIni)
IncProc()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza atualizacao dos dbTree ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTree:TreeSeek(cCargoIni)
oTree2:TreeSeek(cCargoIni)
oTree:EndUpdate()
oTree2:EndUpdate() 

CursorArrow()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Une os itens e os subitens      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSub .And. len(aRet2) > 0
	aEval(aVal2,{|x| aAdd(aVal,x)})
EndIf

IncProc()

Return aVal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Prt ³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza a entidade do contrato                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aExp01 := CNC020Prt(cExp02,aExp03,aExp04,lExp05,cExp06,    ³±±
±±³          ³ cExp07,lExp08,cExp09)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Retorna array com os valores originais e atuais   ³±±
±±³          ³ Estrutura:                                                 ³±±
±±³          ³ aExp01[1] - Resultado:                                     ³±±
±±³          ³             aExp01[1,x,APOS_ALIAS] - Alias                 ³±±
±±³          ³             aExp01[1,x,APOS_FIELD] - Campo                 ³±±
±±³          ³             aExp01[1,x,APOS_TITLE] - Titulo do Campo       ³±±
±±³          ³             aExp01[1,x,APOS_VLORI] - Valor Original        ³±±
±±³          ³             aExp01[1,x,APOS_VLDST] - Valor Atual           ³±±
±±³          ³             aExp01[1,x,APOS_CHAVE] - Chave do item         ³±±
±±³          ³ aExp01[2] - Origem - Agrupado pela chave                   ³±±
±±³          ³             aExp01[2,x,y,NPOS_FIELD] - Campo               ³±±
±±³          ³             aExp01[2,x,y,NPOS_TITLE] - Titulo do Campo     ³±±
±±³          ³             aExp01[2,x,y,NPOS_NALT] - Informa se o registro³±±
±±³          ³                                       manteve o valor orig.³±±
±±³          ³             aExp01[2,x,y,NPOS_ALIAS] - Alias               ³±±
±±³          ³             aExp01[2,x,y,NPOS_CHAVE] - Chave               ³±±
±±³          ³             aExp01[2,x,y,NPOS_ADD]   - Informa se o item   ³±±
±±³          ³                                        foi adicionado      ³±±
±±³          ³             aExp01[2,x,y,NPOS_DEL]   - Informa se o item   ³±±
±±³          ³                                        foi excluso         ³±±
±±³          ³             aExp01[2,x,y,NPOS_DESCR] - Descricao da chave  ³±±
±±³          ³ aExp01[3] - Valores Atuais  - Agrupado pela chave          ³±±
±±³          ³             aExp01[3,x,y,NPOS_FIELD] - Campo               ³±±
±±³          ³             aExp01[3,x,y,NPOS_TITLE] - Titulo do Campo     ³±±
±±³          ³             aExp01[3,x,y,NPOS_NALT] - Informa se o registro³±±
±±³          ³                                       manteve o valor orig.³±±
±±³          ³             aExp01[3,x,y,NPOS_ALIAS] - Alias               ³±±
±±³          ³             aExp01[3,x,y,NPOS_CHAVE] - Chave               ³±±
±±³          ³             aExp01[3,x,y,NPOS_ADD]   - Informa se o item   ³±±
±±³          ³                                        foi adicionado      ³±±
±±³          ³             aExp01[3,x,y,NPOS_DEL]   - Informa se o item   ³±±
±±³          ³                                        foi excluso         ³±±
±±³          ³             aExp01[3,x,y,NPOS_DESCR] - Descricao da chave  ³±±
±±³          ³ cExp02 - Alias                                             ³±±
±±³          ³ aExp03 - Array com os campos da chave                      ³±±
±±³          ³ aExp04 - Array com os campos que serao analisados          ³±±
±±³          ³ lExp05 - Informa se retorna apenas as diferencas           ³±±
±±³          ³ cExp06 - Condicao SQL para a versao original               ³±±
±±³          ³ cExp07 - Condicao SQL para a versao atual                  ³±±
±±³          ³ lExp08 - Informa se suprime os grupos sem alteracao        ³±±
±±³          ³ cExp09 - Entidade avaliada                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Prt(cAlias,aChave,aCpos,lDif,cCond1,cCond2,lSupr,cEntidade)
Local cQuery  := ""
Local aStruct := (cAlias)->(dbStruct())
Local cAlias1 := GetNextAlias()
Local cAlias2 := GetNextAlias()
Local aOrig   := {}
Local aAtu    := {}
Local aResult := {}
Local nx      := 0
Local ny      := 0
Local cDecCh  := 0
Local cOrder  := ""
Local uValO   := NIL  
Local uValA   := NIL
Local lEnc    := .T.
Local lChag   := .T.
Local cField  := ""
Local cTitle  := ""
Local cGrupo  := ""
Local nLastA  := 0
Local nLastO  := 0
Local cValGr  := ""
Local aNew    := {}
Local aDel    := {}
Local lFstO   := .T.
Local lFstA   := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta ordem e agrupamento de acordo com a chave ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aChave) > 0
	For nX:=1 to len(aChave)
		cOrder += aChave[nX]+","
		cGrupo += aChave[nX]+"+"
	next
	
	cOrder := SubStr(cOrder,1,len(cOrder)-1)
	cGrupo := SubStr(cGrupo,1,len(cGrupo)-1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta query para os registros originais e ordena pela chave ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT "+ cAlias +".* FROM "+ RetSQLName(cAlias) + " " + cAlias + " WHERE "
cQuery += cAlias+"."+cAlias+"_FILIAL = '"+xFilial(cAlias)+"' AND "
cQuery += cCond1 + " AND "
cQuery += cAlias+".D_E_L_E_T_ = ' ' "
If len(cOrder) > 0
	cQuery += "ORDER BY " + cOrder
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias1,.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta query para os registros atuais e ordena pela chave ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT "+ cAlias +".* FROM "+ RetSQLName(cAlias) + " " + cAlias + " WHERE "
cQuery += cAlias+"."+cAlias+"_FILIAL = '"+xFilial(cAlias)+"' AND "
cQuery += cCond2 + " AND "
cQuery += cAlias+".D_E_L_E_T_ = ' ' "
If len(cOrder) > 0
	cQuery += "ORDER BY " + cOrder
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias2,.F.,.T.)

For nx:=1 to len(aStruct)
	If aStruct[nx,2] <> "C"
		TCSetField( cAlias1, aStruct[nx,1], aStruct[nx,2], aStruct[nx,3], aStruct[nx,4] )
		TCSetField( cAlias2, aStruct[nx,1], aStruct[nx,2], aStruct[nx,3], aStruct[nx,4] )
	EndIF
Next

IncProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre os registros da origem ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !(cAlias1)->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis de controle ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lAdd  := .F.
	lEnc  := .F.
	lDel  := .F.
	lExit := .F.
	lNext := .T.
	nJmp  := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Varre os registros atuais        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !lExit	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se os registros sao iguais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (lEnc := (cAlias1)->&(cGrupo) == (cAlias2)->&(cGrupo))
			lExit := .T.
		EndIf
		
		If !lEnc
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o registro foi deletado ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (cAlias2)->&(cGrupo) > (cAlias1)->&(cGrupo) .Or. (cAlias2)->(Eof())
				lEnc := .T.
				lDel := .T.
				lExit := .T.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o registro foi incluso  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nJmp == 1
					lEnc := .T.
					lAdd := .T.
					lExit := .T.
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Segue para o proximo registro atual ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					(cAlias2)->(dbSkip())
					nJmp++
				EndIf
			EndIf
		EndIf
	EndDo

	If lEnc
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica grupo dos registros        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cValgr != If(lAdd,(cAlias2)->&(cGrupo),(cAlias1)->&(cGrupo))
			cValgr := If(lAdd,(cAlias2)->&(cGrupo),(cAlias1)->&(cGrupo))
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o grupo anterior nao possui informacao ³
			//³ e se foi solicitado para suprimir os registros     ³
			//³ entao utiliza a mesma posicao                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLastO == 0 .Or. len(aOrig[nLastO]) > 0 .Or. !lSupr
				aAdd(aOrig,{})
				nLastO := len(aOrig)
				lFstO := .T.
			EndIf
			If nLastA == 0 .Or. len(aAtu[nLastA]) > 0 .Or. !lSupr
				aAdd(aAtu,{})
				nLastA := len(aAtu)
				lFstA := .T.
			EndIf
		EndIf
	
		For nx:=1 to len(aCpos)
			cField:= PadR(aCpos[nx],10)
			uValO := uValA := NIL
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Solicita valor da origem  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAdd
				uValO := (cAlias1)->&(cField)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Solicita valor de destino ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lDel
				uValA := (cAlias2)->&(cField)
			EndIf
         
			cTitle := AllTrim(RetTitle(cField))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Preenche os arrays             ³
			//³ aOrig - Registros originais    ³
			//³ aAtu - Registros atuais        ³
			//³ aResult - Array com os valores ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         If lAdd//Registro incluso
				aAdd(aResult,{cAlias,cField,cTitle,NIL,(cAlias2)->&(cField),AllTrim((cAlias2)->&(cGrupo))})
				
				aAdd(aAtu[nLastA],{cField,cTitle,.F.,cAlias,(cAlias2)->&(cGrupo),.T.,.F.,""})         
				lNext := .F.
         ElseIf lDel//Registro excluso
				aAdd(aResult,{cAlias,cField,cTitle,(cAlias1)->&(cField),NIL,AllTrim((cAlias1)->&(cGrupo))})
				
				aAdd(aOrig[nLastO],{cField,cTitle,.F.,cAlias,(cAlias1)->&(cGrupo),.F.,.T.,""})
         Else
	         lCha := (uValO != uValA)//Verifica se existe diferenca
	   		
	   		If lCha .Or. !lDif//Verifica se exibe apenas diferenca
					aAdd(aResult,{cAlias,cField,cTitle,(cAlias1)->&(cField),(cAlias2)->&(cField),AllTrim((cAlias1)->&(cGrupo))})
				
					aAdd(aOrig[nLastO],{cField,cTitle,!lCha,cAlias,(cAlias1)->&(cGrupo),.F.,.F.,""})
					aAdd(aAtu[nLastA],{cField,cTitle,!lCha,cAlias,(cAlias2)->&(cGrupo),.F.,.F.,""})
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Preenche o descritivo da chave no primeiro item do grupo ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lAdd .And. lFstO .And. len(aOrig[nLastO]) > 0
				lFstO := .F.
		  		aOrig[nLastO,len(aOrig[nLastO]),8] := CNC020Chav(aChave,cEntidade,cAlias1)
			EndIf
			If !lDel .And. lFstA .And. len(aAtu[nLastA]) > 0
				lFstA := .F.
		  		aAtu[nLastA,len(aAtu[nLastA]),8] := CNC020Chav(aChave,cEntidade,cAlias2)
			EndIf
		Next
      
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui item em branco quando for solicitado ao menos     ³
		//³ um item por grupo                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lSupr
			If len(aOrig[nLastO]) == 0 .And. !lAdd
				aAdd(aOrig[nLastO],{"","",.F.,cAlias,(cAlias1)->&(cGrupo),.F.,.F.,CNC020Chav(aChave,cEntidade,cAlias1)})
			EndIf
			If len(aAtu[nLastA]) == 0 .And. !lDel
				aAdd(aAtu[nLastA],{"","",.F.,cAlias,(cAlias1)->&(cGrupo),.F.,.F.,CNC020Chav(aChave,cEntidade,cAlias1)})
			EndIf			
		EndIf

	EndIf

	If lNext
		(cAlias1)->(dbSkip())
	EndIf
EndDo

IncProc()
                     
(cAlias2)->(dbSkip())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica inclusoes nao selecionadas                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !(cAlias2)->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica grupo de acordo com a chave                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cValgr != (cAlias2)->&(cGrupo)
		cValgr := (cAlias2)->&(cGrupo)

		If nLastA == 0 .Or. len(aAtu[nLastA]) > 0 .Or. !lSupr
			aAdd(aAtu,{})
			nLastA := len(aAtu)
			lFstA := .T.
		EndIf
	EndIf

	For nx:=1 to len(aCpos)
		cField:= PadR(aCpos[nx],10)
		uValO := uValA := NIL
		uValA := (cAlias2)->&(cField)
         
		cTitle := AllTrim(RetTitle(cField))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona os novos itens no array atual  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aResult,{cAlias,cField,cTitle,NIL,(cAlias2)->&(cField),AllTrim((cAlias2)->&(cGrupo)),.T.,.F.})
		aAdd(aAtu[nLastA],{cField,cTitle,.F.,cAlias,(cAlias2)->&(cGrupo),.T.,.F.,""})         

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche o descritivo da chave no primeiro item do grupo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFstA .And. len(aAtu[nLastA]) > 0
			lFstA := .F.
			cDecCh:= cEntidade
			For ny:=1 to len(aChave)
				cDecCh += " - " + AllTrim(RetTitle(aChave[ny])) + ": " + (cAlias2)->&(aChave[ny])
			Next
	  		aAtu[nLastA,len(aAtu[nLastA]),8] := cDecCh
		EndIf
	Next
	
	(cAlias2)->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o ultimo grupo possui registros e limpa caso ³
//³ necessario                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastO > 0 .And. len(aOrig[nLastO]) == 0 .And. lSupr
	aDel(aOrig,len(aOrig))
	aSize(aOrig,nLastO-1)
EndIf

If nLastA > 0 .And. len(aAtu[nLastA]) == 0 .And. lSupr
	aDel(aAtu,len(aAtu))
	aSize(aAtu,nLastA-1)
EndIf

IncProc()

Return  {aResult,aOrig,aAtu}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020LdVl³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Carrega os valores dos itens selecionados                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNC020LdVl(oExp01,oExp02,cExp03,cExp04,cExp05,aExp06,      ³±±
±±³          ³ aExp07)                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Componente tree de origem                         ³±±
±±³          ³ oExp02 - Componente tree dos valores atuais                ³±±
±±³          ³ cExp03 - Informa se a chamada foi feita pelo tree de origem³±±
±±³          ³          '1' ou destino '2'                                ³±±
±±³          ³ cExp04 - Valor Atual                                       ³±±
±±³          ³ cExp05 - Valor original                                    ³±±
±±³          ³ aExp06 - Array contendo os valores originais e atuais      ³±±
±±³          ³ aExp07 - Informa se sincroniza a selecao em ambos ambientes³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020LdVl(oTree,oTree2,cTree,cValorA,cValorO,aValores,lSic)
Local cCargo := If(cTree=="1",oTree:GetCargo(),oTree2:GetCargo())
Local cAlias := ""
Local cRecno := ""
Local cField := ""
Local nPos   := 0
Local cType  := ""
Local cEmpty := "--------------------------------------------------------------------"

If len(cCargo) > 13
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona alias  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAlias := SubStr(cCargo,1,3)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona campo  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cField := SubStr(cCargo,4,10)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona chave  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChave := AllTrim(SubStr(cCargo,14,len(cCargo)))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Encontra item no array de valores ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nPos := aScan(aValores,{|x| x[APOS_ALIAS] == cAlias .And. x[APOS_FIELD] == cField .And. x[APOS_CHAVE] == cChave})

	If nPos > 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o tipo do campo     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aValores[nPos,NPOS_ALIAS] != NIL
			cType := ValType(aValores[nPos,APOS_VLORI])
		Else
			cType := ValType(aValores[nPos,APOS_VLDST])
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche os valores originais e atuais ³
		//³ de acordo com o tipo                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case cType == "C"
				cValorA := If(aValores[nPos,APOS_VLDST]!=NIL,aValores[nPos,APOS_VLDST],cEmpty)
				cValorO := If(aValores[nPos,APOS_VLORI]!=NIL,aValores[nPos,APOS_VLORI],cEmpty)
			Case cType == "N"
				cValorA := If(aValores[nPos,APOS_VLDST]!=NIL,Transform(aValores[nPos,APOS_VLDST],PesqPict(cAlias,cField)),cEmpty)
				cValorO := If(aValores[nPos,APOS_VLORI]!=NIL,Transform(aValores[nPos,APOS_VLORI],PesqPict(cAlias,cField)),cEmpty)
			Case cType == "L"
				cValorA := If(aValores[nPos,APOS_VLDST]!=NIL,str(aValores[nPos,APOS_VLDST]),cEmpty)
				cValorO := If(aValores[nPos,APOS_VLORI]!=NIL,str(aValores[nPos,APOS_VLORI]),cEmpty)
			Case cType == "D"
				cValorA := If(aValores[nPos,APOS_VLDST]!=NIL,DTOC(aValores[nPos,APOS_VLDST]),cEmpty)
				cValorO := If(aValores[nPos,APOS_VLORI]!=NIL,DTOC(aValores[nPos,APOS_VLORI]),cEmpty)
		End Case
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sincroniza os dbtree                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSic
		If(cTree=="1",oTree2:TreeSeek(cCargo),oTree:TreeSeek(cCargo))
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Vis ³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa visualizacao do item selecionado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNC020Vis(oExp01,lExp02)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Componente tree                                   ³±±
±±³          ³ lExp02 - Informa se a chamada foi feita no tree de origem  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Vis(oTree,lOri)
Local cCargo   := oTree:GetCargo()
Local cAlias   := ""
Local aRotBack := {}
Local cCadBack := ""
Local lIncBack := .F.
Local lAltBack := .F.

If Type( "aRotina" ) == "A"
	aRotBack := AClone( aRotina )
EndIf

If Type( "cCadastro" ) == "C"
	cCadBack := cCadastro
EndIf

If Type( "INCLUI" ) == "L"
	lIncBack := INCLUI
EndIf

If Type( "ALTERA" ) == "L"
	lAltBack := ALTERA
EndIf

If len(cCargo) > 3
	INCLUI := .F.
	ALTERA := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona o alias      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAlias := SubStr(cCargo,1,3)
	
	cContra := mv_par01//Codigo do contrato
	
	If lOri
		cRevisa := mv_par02//Revisao original
	Else
		cRevisa := mv_par03//Revisao atual
	EndIf

	dbSelectArea("CN9")
	dbSetOrder(1)

	If dbSeek(xFilial("CN9")+cContra+cRevisa)

		cCadastro :=   STR0021//"Contrato"
		aRotina   := 	{ 	{ ""     , "AxPesqui"  , 0, 1},;
					  			{ STR0010, "CN100Manut", 0, 2} }//"Visualizar"
	   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Visualiza o contrato  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FWExecView(STR0010,If(CN9->CN9_ESPCTR == "1","CNTA300","CNTA301"),MODEL_OPERATION_VIEW,,{|| .T.})//"Visualizar"
	EndIf

EndIf

If ValType( "aRotBack" ) == "A"
	aRotina := AClone( aRotBack )
EndIf

If Type( "cCadBack" ) == "C"
	cCadastro := cCadBack
EndIf

If Type( "lIncBack" ) == "L"
	INCLUI := lIncBack
EndIf

If Type( "lAltBack" ) == "L"
	ALTERA := lAltBack
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Chav³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa visualizacao do item selecionado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNC020Chav(aExp01,cExp02,cExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Informa os campos da chave                        ³±±
±±³          ³ cExp02 - Descricao da entidade selecionada                 ³±±
±±³          ³ cExp03 - Alias                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Chav(aChave,cEntidade,cAlias)
Local ny := 0
Local cChave := ""

cChave := cEntidade
For ny:=1 to len(aChave)
	cChave += " - " + AllTrim(RetTitle(aChave[ny])) + ": " + (cAlias)->&(aChave[ny])
Next

Return cChave 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Tree³ Autor ³ Marcelo Custodio      ³ Data ³16.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Preenche dbtree                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNC020Tree(oExp01,aExp02,aExp03,lExp04,cExp05)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Componente dbTree                                 ³±±
±±³          ³ aExp02 - Array contendo os itens                           ³±±
±±³          ³ aExp03 - Array contendo os subitens                        ³±±
±±³          ³ lExp04 - Informa se possui subitens                        ³±±
±±³          ³ cExp05 - Informa chave inicial                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Tree(oTree,aIts,aSub,lSub,cCargoIni)
Local cRsc      := ""
Local cAlias    := ""
Local cChave    := ""
Local aCurrent  := {}
Local aCurrent2 := {}
Local nTamChv   := 0
Local nx        := 0
Local nz        := 0
Local ny        := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa controle dos subitens      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nz := 1 

For nx:=1 to len(aIts)

	If len(aIts[nx]) > 0

		aCurrent := aIts[nx]//Armazena item atual

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica imagem do item   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cRsc := ""
		If aCurrent[1,NPOS_ADD]//Item Adicionado
			cRsc := IMG_NEW
		ElseIf aCurrent[1,NPOS_DEL]//Item excluso
			cRsc := IMG_DEL
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe alteracao nos subitens ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aCurrent,{|x| !x[NPOS_NALT]}) > 0
				cRsc := IMG_EDIT//Edicao
			Else
		  		cRsc := IMG_OK//Sem alteracao
		 	EndIf
		EndIf
		
		oTree:TreeSeek(cCargoIni)//Posiciona no inicio
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona item pai, baseado no primeiro elemento do item atual ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		oTree:AddItem(aCurrent[1,NPOS_DESCR],aCurrent[1,NPOS_ALIAS]+aCurrent[1,NPOS_CHAVE],cRsc)
		oTree:TreeSeek(aCurrent[1,NPOS_ALIAS]+aCurrent[1,NPOS_CHAVE])

		nTamChv := len(aCurrent[1,NPOS_ALIAS]+aCurrent[1,NPOS_CHAVE])//Calcula tamanho da chave
		cAlias  := aCurrent[1,NPOS_ALIAS]
		cChave  := aCurrent[1,NPOS_ALIAS]+aCurrent[1,NPOS_CHAVE]
		
		For ny:=1 to len(aCurrent)
			If !Empty(aCurrent[ny,NPOS_FIELD])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona os itens - Campos ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				oTree:AddItem(aCurrent[ny,NPOS_TITLE],aCurrent[ny,NPOS_ALIAS]+aCurrent[ny,NPOS_FIELD]+aCurrent[ny,NPOS_CHAVE],If(aCurrent[ny,NPOS_NALT],IMG_OK,If(aCurrent[ny,NPOS_ADD],IMG_NEW,If(aCurrent[ny,NPOS_DEL],IMG_DEL,IMG_EDIT))))
			EndIf
		Next
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe subitens³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If lSub .And. nz <= len(aSub)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Varre a partir da posicao armazenada em nz ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While nz <= len(aSub) .And. cChave == (cChave2 := SubStr(cAlias+aSub[nz,1,NPOS_CHAVE],1,nTamChv))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Armazena item corrente  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCurrent2 := aSub[nz]

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica imagem do item ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cRsc := ""
			If aCurrent2[1,NPOS_ADD]//Adicionado
				cRsc := IMG_NEW
			ElseIf aCurrent2[1,NPOS_DEL]//Excluso
				cRsc := IMG_DEL
			Else
				If aScan(aCurrent2,{|x| !x[NPOS_NALT]}) > 0//Alteracao nos subitens
					cRsc := IMG_EDIT
				Else                                                                              	
			  		cRsc := IMG_OK
			 	EndIf
			EndIf

			oTree:TreeSeek(cChave)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona subitem ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oTree:AddItem(aCurrent2[1,NPOS_DESCR],aCurrent2[1,NPOS_ALIAS]+aCurrent2[1,NPOS_CHAVE],cRsc)
			oTree:TreeSeek(aCurrent2[1,NPOS_ALIAS]+aCurrent2[1,NPOS_CHAVE])
			
			For ny:=1 to len(aCurrent2)
		 		If !Empty(aCurrent2[ny,NPOS_FIELD])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Adiciona itens - campos do subitem ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			  		oTree:AddItem(aCurrent2[ny,NPOS_TITLE],aCurrent2[ny,NPOS_ALIAS]+aCurrent2[ny,NPOS_FIELD]+aCurrent2[ny,NPOS_CHAVE],If(aCurrent2[ny,NPOS_NALT],IMG_OK,If(aCurrent2[ny,NPOS_ADD],IMG_NEW,If(aCurrent2[ny,NPOS_DEL],IMG_DEL,IMG_EDIT))))
			  EndIf
			Next
			nz++
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha arvore do dbTree ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTree:TreeSeek(aCurrent[1,NPOS_ALIAS]+aCurrent[1,NPOS_CHAVE])
		oTree:PTCollapse()
	EndIf
Next

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNC020Leg ³ Autor ³ Marcelo Custodio      ³ Data ³26.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exibe legenda                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNC020Leg()                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNC020Leg()

Local oDlgLeg

DEFINE MSDIALOG oDlgLeg FROM	00,00 TO 100,100 TITLE STR0022 OF oMainWnd PIXEL

@ 5,5 BITMAP oRes1 RESOURCE IMG_OK SIZE 8,8 Of oDlgLeg PIXEL NOBORDER
@ 5,15 Say STR0023 Size 70,8 PIXEL//"Não Modificado"
@ 15,5 BITMAP oRes2 RESOURCE IMG_EDIT SIZE 8,8 Of oDlgLeg PIXEL NOBORDER
@ 15,15 Say STR0024 Size 70,8 PIXEL//"Modificado" 
@ 25,5 BITMAP oRes3 RESOURCE IMG_NEW SIZE 8,8 Of oDlgLeg PIXEL NOBORDER
@ 25,15 Say STR0025 Size 70,8 PIXEL//"Novo" 
@ 35,5 BITMAP oRes4 RESOURCE IMG_DEL SIZE 8,8 Of oDlgLeg PIXEL NOBORDER
@ 35,15 Say STR0026 Size 70,8 PIXEL//"Excluído"

ACTIVATE MSDIALOG oDlgLeg 

Return