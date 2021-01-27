#INCLUDE "CNTA090.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

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
#DEFINE DEF_SREVA "A" //Revisao - Aprovacao por Alcadas

//Transacoes
#DEFINE DEF_TRAINC "003"//Inclusao de caucoes
#DEFINE DEF_TRAEDT "004"//Edicao de caucoes
#DEFINE DEF_TRAEXC "005"//Exclusao de caucoes
#DEFINE DEF_TRAVIS "031"//Visualizacao de caucoes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA090  ³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de Cadastro de Caucoes                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA090()                                                  ³±±
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
Function CNTA090(nPosArotina,lAutomato,cTpCauc)
Private cCadastro := STR0001 //Cadastro de Caucoes

Private aRotina := MenuDef()
DEFAULT nPosArotina := 0
DEFAULT lAutomato := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Contabiliza   		S/N                          ³
//³ mv_par02 - Mostra Lanc Contab  	S/N                          ³
//³ mv_par03 - Aglut lancamentos	S/N                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	nPosArotina > 0
	Pergunte("CNT090",.F.)
	DbSelectArea("CN8")

	If	nPosArotina == 6	//-- Baixa
		bBlock := &( "{ |a,b,c,d| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina,lAutomato)
	Else
		bBlock := &( "{ |a,b,c,d,e,f,g| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e,f,g) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina,,,lAutomato,cTpCauc)
	EndIf
Else
	SetKey(VK_F12,{||Pergunte("CNT090",.T.)})

	If Pergunte("CNT090",.T.)
		mBrowse(6,1,22,75,"CN8")
	EndIf
	SetKey( VK_F12 , Nil )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090DlgTCau³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Tela para preenchimento do tipo de caucao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090DlgTCau()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN090DlgTCau()
Local oDlg
Local oFnt
Local oFnt2
Local oFnt3
Local oGroup
Local oGet01
Local cCodigo := "   "
Local cTitulo := STR0007// "Tipo de Caução"

DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo) FROM  165,115 TO 245,430 PIXEL
@ 5, 10 SAY OemToAnsi(cTitulo) SIZE 60, 8 OF oDlg PIXEL
@ 5,70  MSGET oGet01 VAR cCodigo PICTURE "999" F3 "CN3" SIZE 25,9 VALID ExistCpo("CN3", cCodigo )  OF oDlg PIXEL
DEFINE SBUTTON FROM 25, 93 TYPE 1 ACTION (if(!empty(cCodigo),oDlg:End(),)) ENABLE OF oDlg
DEFINE SBUTTON FROM 25, 123 TYPE 2 ACTION (cCodigo:="",oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

Return cCodigo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090Manut³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao das rotinas de visualizacao, inclusao, exclusao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090Manut()                                               ³±±
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
Function CN090Manut(cAlias,nReg,nOpc,xFiller,lVisAprCt,lAutomato,cTpCauc)
Local aArea     := GetArea()
Local nPosCampo := 0
Local nA        := 0
Local cCodCauc  := CN8->CN8_CODIGO
Local aCpoEnch  := {}
Local aPosEnch  := {}
Local nOpca     := 0
Local oDlg
Local oGetd
Local cCodTPc
Local lExibe    := .T.
Local lContinua := .T.
Local nStack    := GetSX8Len()
Local lVisual   := ( aRotina[ nOpc, 4 ] == 2 )
Local dDataBloq := GetNewPar("MV_ATFBLQM",CTOD("")) //Data de Bloqueio da Movimentação - MV_ATFBLQM
Local aNoFields := {"CNI_CODIGO","CNI_ITEM"}
Local cSeek	    := ""
Local cWhile    := ""

Default lVisAprCt := .F.
Default lAutomato := .F.
Default cTpCauc   := ""

Private lFin  := .F.
Private lAbat := .F.

//Verifica se existe bloqueio contábil
If (nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 5) .And. (lContinua := CtbValiDt(Nil, dDataBase,/*.T.*/ ,Nil ,Nil ,{"GCT001"}/*,"Data de apuração bloqueada pelo calendário contábil."*/) )
	If!Empty(dDataBloq) .AND. ( dDataBase <= dDataBloq)
		//Help(" ",1,"AF012ABLQM",,"Processo bloqueado pelo Calendário Contábil nesta data ou período. Caso possível altere a data de referência do processo ou contate o responsável pelo Módulo Contábil.",1,0) //"Processo bloqueado pelo Calendário Contábil nesta data ou período. Caso possível altere a data de referência do processo ou contate o responsável pelo Módulo Contábil."
		Help(" ",1,"ATFCTBBLQ") //P: Processo bloqueado pelo Calendário Contábil ou parâmetro de bloqueio nesta data ou período. S: Caso possível altere a data de referência do processo, verifique o parâmetro ou contate o responsável pelo Módulo Contábil.)
		lContinua := .F.
	End
EndIf

If lContinua
If(nOpc == 3)
	If	lAutomato
		cCodTPc := cTpCauc
	Else
		cCodTPc := CN090DlgTCau()//Executa rotina para preenchimento do tipo de caucao
	EndIf
Else
	cCodTPc := CN8->CN8_TPCAUC//Seleciona tipo de caução

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica transacao                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lContinua := CN240VldUsr(CN8->CN8_CONTRA,If(nOpc==4,DEF_TRAEDT,If(nOpc==5,DEF_TRAEXC,DEF_TRAVIS)),.T.,lVisAprCt)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a caucao esta baixada                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContinua .And. !Empty(CN8->CN8_DTBX) .And. !lVisual
		Help( " ", 1, "CNTA090_01" )
		lContinua := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a caucao esta trocada                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContinua .And. !Empty(CN8->CN8_TROCAD) .And. !lVisual
		Help( " ", 1, "CNTA090_02" )
		lContinua := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ocorreu movimentacao da caucao ( abatimento em nota ) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContinua .And. !lVisual
		If CN3->( MsSeek(xFilial('CN3') + cCodTPc ) )

			If ( CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI = "1" )
				lContinua := CN090VerPA()
			EndIf

		EndIf
	EndIf

	If lContinua .And. !lVisual

		DbSelectArea("CN9")
		dbSetOrder(1)

		If dbSeek(xFilial("CN9")+CN8->CN8_CONTRA+CN8->CN8_REVISA)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica situacao atual do contrato             ³
			//³ Situacoes que aceitam alt/exc de caucao:        ³
			//³  - 2 - Elaboracao                               ³
			//³  - 3 - Emitido                                  ³
			//³  - 4 - Em Aprovacao                             ³
			//³  - 9 - Revisao                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(CN9->CN9_SITUAC) != DEF_SELAB .AND. AllTrim(CN9->CN9_SITUAC) != DEF_SEMIT .AND. AllTrim(CN9->CN9_SITUAC) != DEF_SAPRO .And. AllTrim(CN9->CN9_SITUAC) != DEF_SREVS
				Help( " ", 1, "CNTA090_03" )//"A situação atual do contrato não permite a alteração/exclusão de cauções."
				lContinua := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

If lContinua .And. (!Empty(cCodTPc))
	DbSelectArea("CN3")
	DbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos que devem ser mostrados na Enchoice. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If( MsSeek(xFilial('CN3')+cCodTPc) )

		lFin  := (CN3->CN3_LIGFIN = "1")
		lAbat := (CN3->CN3_ABATI  = "1")

		DbSelectArea("SX3")
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("CN8"))
		While ( !Eof() .And. SX3->X3_ARQUIVO == "CN8" )
			cCampo := SX3->X3_CAMPO
			If	x3uso(GetSx3Cache(cCampo,'X3_USADO')) .And. cNivel >= GetSx3Cache(cCampo,'X3_NIVEL')

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui campos de controle                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lExibe := !(allTrim(cCampo) $ "CN8_TPCAUC|CN8_TROCAD|CN8_TROCAO")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui campos de abatimento quando o tipo de ³
				//³ caucao nao for de abatimento                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lExibe := !(!lExibe .Or. (!lAbat .And. allTrim(cCampo) $ "CN8_TPABAT|CN8_PERCAB"))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui campos de controle financeiro quando o tipo de ³
				//³ caucao nao tiver ligacao com financeiro               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lExibe := !(!lExibe .Or. (!lFin .And. allTrim(cCampo) $ "CN8_BANCO|CN8_AGENCI|CN8_CONTA|CN8_INDREJ|CN8_CORREC"))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui campos referentes a caucoes sem ligacao com ³
				//³ o financeiro, quando houver a ligacao              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lExibe := !(!lExibe .Or. (lFin .And. allTrim(cCampo) $ "CN8_EMITEN|CN8_NUMDOC|CN8_DTINVI|CN8_DTFIVI")				         )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui campos preenchidos automaticamente durante ³
				//³ a inclusao                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lExibe := !(!lExibe .Or. (nOpc == 3 .And. allTrim(cCampo) $ "CN8_DTBX|CN8_VLBX|CN8_SALDO|CN8_VLRRET"))

				If lExibe
					aAdd(aCpoEnch,cCampo)
				EndIf
				lExibe := .T.
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria campos na memoria                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	( SX3->X3_CONTEXT == "V"  .Or. Inclui )
				M->&(cCampo) := CriaVar(GetSx3Cache(cCampo,'X3_CAMPO'))
			Else
				M->&(cCampo) := CN8->(FieldGet(FieldPos(GetSx3Cache(cCampo,'X3_CAMPO'))))
			EndIf

			DbSelectArea("SX3")
			SX3->(DbSkip())
		EndDo
	EndIf

	CN090DescMoed()

	If	lAutomato
		If	nOpc == 5
			nOpca := 1
		ElseIf FindFunction("GetParAuto")

			aRetAuto := GetParAuto("CNTA090TESTCASE")

			//Configura campos referentes ao tipo de caucao
			CN090TPCauc(cCodTPc)

				If EnchAuto(cAlias,aRetAuto[1],,nOpc,,{|| Obrigatorio(aGets,aTela) .And. VldCTB() .And. CN090VldFor(oDlg) .And. CN090VldPa(cCodTpC) .And. cn090TotCau()})

					nOpca = 1
				Else
					nOpca = 0
				EndIf
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao de variaveis Privates.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Private aTela[0][0]
		Private aGets[0]
		Private aHeader  := {}
		Private aCols    := {}
		Private n        := 1
		Private nUsado   := 0
		Private aSize    := MsAdvSize(,.F.,430)
		Private aObjects := {}
		Private aPosObj  := {}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Devolve o tamanho da tela atualmente no micro do usuario.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Private aSizeAut := MsAdvSize()

		Aadd(aObjects, { 100,  70, .T., .T. } )
		Aadd(aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 }
		aPosObj := MsObjSize(aInfo, aObjects)

		If(nOpc != 3)
			dbSelectArea("CNI")
	      	cSeek		:= xFilial() + cCodCauc
		   	cWhile	:= "CNI_FILIAL+CNI_CODIGO"
	 	 	FillGetDados(nOPc,"CNI",1,cSeek,{|| &cWhile },{|| .T. },aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dialog.                                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If(nOpc == 3)//Altera layout na inclusao
			DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
			aSize := MsAdvSize()
			aObjects := {}
			AAdd( aObjects, { 100, 100, .T., .T. } )
			aInfo    := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 }
		   	aPosObj := MsObjSize( aInfo, aObjects )
			//aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}
			EnChoice( cAlias, nReg, nOpc,,,,aCpoEnch,aPosObj[1], , , , , , , , .T.)//Nao configura posicoes de tela
		Else
			DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
			EnChoice( cAlias, nReg, nOpc,,,,aCpoEnch, aPosObj[1], , , , , , , , .T.)
			oGetd	:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],1,,,,.F.,,,.T.,900,,,,,)
		EndIf

		//Configura campos referentes ao tipo de caucao
		CN090TPCauc(cCodTPc)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If((Obrigatorio(aGets,aTela) .And. VldCTB() .And. CN090VldFor(oDlg) .And. If( nOpc == 3 .Or. nOpc == 4, CN090VldPa(cCodTpC).And.cn090TotCau(), .T. ) ),{nOpca:=1,oDlg:End()},nOpca:=2)},{||(oDlg:End())})
	EndIf

	If(nOpca == 1 .And. nOpc != 2)
		Begin Transaction
		lContinua := CN090Grv(nOpc,cCodTPc)
		If !lContinua
			DisarmTransaction()
		EndIf
		End Transaction

		While GetSX8Len() > nStack
			ConfirmSX8()
		EndDo

		EvalTrigger()
		msUnlockAll()

	ElseIf nOpca == 0

		While GetSX8Len() > nStack
			RollBackSX8()
		EndDo

	EndIf

	RestArea(aArea)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN090Grv ³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de gravacao da caucao                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090Grv(nExp01,cExp02)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                       ³±±
±±³          ³ cExp02 - Tipo de caucao                                    ³±±
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
Function CN090Grv(nOpc,cCodTPc)
Local nCntFor  := 0
Local nTam     := 0
Local lGeraMov := (CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI # "1")
Local lGeraPA  := (CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI = "1")
Local lContinua:= .T.

Do Case
	Case nOpc == 3	// Inclusao

		If lGeraPA
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inclui o titulo de abatimento                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lContinua := CN090GerPA(nOpc)
		EndIf

		If lContinua
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Preenche campos da caucao                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CN8")
			Reclock("CN8",.T.)
			For nCntFor := 1 To FCount()
				If (FieldName(nCntFor)=="CN8_FILIAL")
					CN8->CN8_FILIAL := xFilial()
				ElseIf (FieldName(nCntFor)=="CN8_TPCAUC")
					CN8->CN8_TPCAUC := cCodTPc
				ElseIf (FieldName(nCntFor)=="CN8_VLEFET")
					CN8->CN8_VLEFET := M->CN8_VLEFET
				ElseIf (FieldName(nCntFor)=="CN8_VLRRET") .And. lGeraPA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se tiver abatimento em nota, grava o valor efetivo como valor a reter   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CN8->CN8_VLRRET := M->CN8_VLEFET
				Else
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				EndIf
			Next nCntFor
			MsUnlock()

			If lContinua
				If lGeraMov
					lContinua := CN090MvEntr(CN8->CN8_VLEFET)
				    If !lContinua
				    	lRet := .F.
				    EndIf
				EndIf
			EndIf

			CN090Contab(1)
		EndIf

	Case nOpc == 4  //Alteracao

		If lGeraPA
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui o titulo de abatimento atual                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			CN090ExcPA()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inclui o titulo de abatimento                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lContinua := CN090GerPA(nOpc)
		EndIf

		If lContinua
			If lGeraMov
				Processa({|| CN090MvEntr(, .T.)},,STR0020)//Estorna Movimentacao Bancaria de Entrada
			EndIf

			CN090Contab(2)

			dbSelectArea("CN8")
			Reclock("CN8",.F.)
			For nCntFor := 1 To FCount()
				If (FieldName(nCntFor)=="CN8_FILIAL")
					CN8->CN8_FILIAL := xFilial()
				ElseIf (FieldName(nCntFor)=="CN8_TPCAUC")
					CN8->CN8_TPCAUC := cCodTPc
				ElseIf (FieldName(nCntFor)=="CN8_VLEFET")
					CN8->CN8_VLEFET := M->CN8_VLEFET
				ElseIf (FieldName(nCntFor)=="CN8_VLRRET") .And. lGeraPA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se tiver abatimento em nota, grava o valor efetivo como valor a reter   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CN8->CN8_VLRRET := M->CN8_VLEFET
				Else
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				EndIf
			Next nCntFor
			MsUnlock()

			// Gera Movimentacao Bancaria de Entrada
			If lGeraMov
				Processa({|| CN090MvEntr()},,STR0021)
			EndIf

			CN090Contab(1)
		EndIf

	Case nOpc == 5  //Exclusao

		//Estorna a Movimentacao Bancaria de Entrada
		If lGeraMov
			Processa({|| CN090MvEntr(, .T.)},,STR0020)
		EndIf

		CN090Contab(2)

		If lGeraPA
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui o titulo de abatimento                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			CN090ExcPA()
		EndIf

		dbSelectArea("CN8")
		Reclock("CN8",.F.)
		dbDelete()
		MsUnlock()
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada apos a gravacao da caucao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CNT090GRV")
	ExecBlock("CNT090GRV",.F.,.F.)
EndIf

Return lContinua

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090TPCauc³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Preenche campos referentes ao tipo de caucao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090TPCauc(cExp02)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp02 - Codigo do tipo de caucao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN090TPCauc(cCodTPc)

CN3->( dbsetorder(1) )
CN3->( dbseek(xFilial("CN3")+cCodTPc) )
M->CN8_CORREC := If(CN3->CN3_LIGFIN = "1","1","2")
//Configura Indice

M->CN8_INDREJ := CN3->CN3_INDREJ

//Configura Descricao
M->CN8_DESCAU := CN3->CN3_DESCRI
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090FilFor³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina usada na consulta padrao para filtrar os fornecedores³±±
±±³          ³ do contrato selecionado                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090FilFor()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN090FilFor()
Local lRet := .F.
Local cRevisa := Posicione("CN9",1,xFilial("CN9")+M->CN8_CONTRA,"CN9_REVATU")

lRet := CNC->(dbSeek(xFilial("CNC")+M->CN8_CONTRA+cRevisa+SA2->A2_COD+SA2->A2_LOJA))

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090VldFor³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o fornecedor selecionado                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090VldFor()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN090VldFor(oDlg,lAutomato)
Local lRet    := .F.
Local nI       := 0
Local cRevisa := Posicione("CN9",1,xFilial("CN9")+M->CN8_CONTRA,"CN9_REVATU")

DEFAULT lAutomato := .F.

/*Local cQuery    := ""
Local cAliasQry := ""

cAliasQry := GetNextAlias()*/

If !EMPTY(M->CN8_FORNEC)

	lRet := CNC->(dbSeek(xFilial("CNC")+M->CN8_CONTRA+cRevisa+M->CN8_FORNEC+M->CN8_LOJA))

	If(!lRet)

		//Verifica se o fornecedor foi deletado do contrato
		/*cQuery := "SELECT COUNT(*) CAUDEL FROM " + RetSqlName( "CNC" ) + " "
		cQuery += "WHERE CNC_NUMERO = '" + M->CN8_CONTRA + "' "
		cQuery += "AND CNC_REVISA = '" + cRevisa + "' "
		cQuery += "AND CNC_CODIGO = '" + M->CN8_FORNEC + "' "
		cQuery += "AND D_E_L_E_T_ = '*' "

		cQuery    := ChangeQuery( cQuery )
		cAliasQry := GetNextAlias()

		dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )

		If (cAliasQry)->CAUDEL = 0*/
			Help( " ", 1, "CNTA090_04" )//"Fornecedor inválido para o contrato"
			M->CN8_LOJA := Space(2)//Limpa campo loja
			If	!lAutomato
				nI := ascan(oDlg:acontrols,{|x| x:CREADVAR = "M->CN8_FORNEC"})//Encontra posicao do controle referente ao campo fornecedor
				If(nI > 0)
					oDlg:acontrols[nI]:SetFocus()//Move o foco para o fornecedor
				EndIf
			EndIf
		/*EndIf*/
	EndIf
Else
   lRet := .T.
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090VldCon³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o contrato selecionado                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090VldCon()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN090VldCon()
Local aArea		:= GetArea()
Local lRet			:= .F.
Local cContrato	:= M->CN8_CONTRA
Local cRevisa		:= M->CN8_REVISA
Local lTRevisa		:= .F.
Local cEspctr		:= ""
Local lRevGer	:= CN8->(Columnpos('CN8_REVGER')) > 0

If cRevisa != CN9->CN9_REVISA
	cRevisa := CN9->CN9_REVISA
EndIf

cEspCtr := CN9->CN9_ESPCTR

If !Empty(cContrato)
	lRet := CN240VldUsr(cContrato,DEF_TRAINC,.T.)

	If lRet
		dbSelectArea("CN9")
		dbSetOrder(1)
		dbSeek(xFilial("CN9")+cContrato+cRevisa)

		//Seleciona revisao mais recente se houver
		If !Empty(CN9->CN9_REVATU)
			dbSeek(xFilial("CN9")+cContrato+CN9->CN9_REVATU)
		EndIf

		//Verifica se o contrato possui revisao ainda nao aprovada
		lTRevisa := (!Empty(CN9->CN9_REVATU) .And. (AllTrim(CN9->CN9_SITUAC) == DEF_SVIGE .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SPARA))

		If Empty(CN9->CN9_REVATU) .Or. lTRevisa
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o contrato aceita caucao e a        ³
			//³ situacao atual do mesmo                         ³
			//³ Situacoes que aceitam caucao:                   ³
			//³  - 2 - Elaboracao                               ³
			//³  - 3 - Emitido                                  ³
			//³  - 4 - Em Aprovacao                             ³
			//³  - 9 - Revisao   								³
			//³  - A - Revisao - Aprovacao por Alcadas          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If CN9->CN9_FLGCAU == "1" .And. CN9->CN9_TPCAUC == "1"
				If (AllTrim(CN9->CN9_SITUAC) == DEF_SELAB .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SREVS .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SREVA) .Or. lTRevisa

					//Preenche Revisa
					M->CN8_REVISA := CN9->CN9_REVISA

					//Preenche Revisao Geradora
					If	lRevGer
						M->CN8_REVGER := CN9->CN9_REVISA
					Endif 						
					
					//Atualiza data de inicio da caucao
					M->CN8_DTINVI := If(CN9->CN9_DTINIC > dDataBase,CN9->CN9_DTINIC,dDataBase)

					//Quando altera o numero do contrato limpa o fornecedor
					If ALTERA .And. M->CN8_CONTRA != CN8->CN8_CONTRA
						M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
						M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
						M->CN8_NOME	  := ""
					EndIf

					If cEspctr == "1"		//Verifica se contrato é Compra
						dbSelectArea("CNC")
						dbSetOrder(1)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Seleciona primeiro fornecedor relacionado       ³
						//³ ao contrato                                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If dbSeek(xFilial("CNC")+M->CN8_CONTRA+cRevisa)
							M->CN8_CLIENT := Space(TamSX3("CN8_CLIENT")[1])
							M->CN8_LOJACL := Space(TamSX3("CN8_LOJACL")[1])
							M->CN8_NOMCLI := ""
							M->CN8_FORNEC := CNC->CNC_CODIGO
							M->CN8_LOJA	:= CNC->CNC_LOJA
							M->CN8_NOME   := Posicione("SA2",1,xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA,"A2_NOME")
						Else
							M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
							M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
							M->CN8_NOME	  := ""
						EndIf
					Else //Senão é contrato de Venda
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Seleciona primeiro client relacionado           ³
						//³ ao contrato                                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea('CNC')
						DbSetOrder(1)
						If dbSeek(xFilial("CNC")+M->CN8_CONTRA+cRevisa)
							M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
							M->CN8_LOJA	:= Space(TamSX3("CN8_LOJA")[1])
							M->CN8_NOME	:= ""
							M->CN8_CLIENT := CNC->CNC_CLIENT
							M->CN8_LOJACL := CNC->CNC_LOJACL
							M->CN8_NOMCLI := Posicione("SA1",1,xFilial("SA1")+CNC->CNC_CLIENT+CNC->CNC_LOJACL,"A1_NOME")
						Else
							M->CN8_CLIENT := Space(TamSX3("CN8_CLIENT")[1])
							M->CN8_LOJACL := Space(TamSX3("CN8_LOJACL")[1])
							M->CN8_NOMCLI := ""
						EndIf
					EndIf
					lRet := .T.
				Else
					lRet := .F.
					Help( " ", 1, "CNTA090_05" )//"A situação atual do contrato não permite a inclusão de cauções."
				EndIf
			Else
				lRet := .F.
				Help( " ", 1, "CNTA090_06" )//"Este contrato não pode ser caucionado"
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090MvEntr³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera movimentacao bancaria                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090MvEntr(lExp01,nExp02,lExp03,lExp04)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lExp01 - Informa se e movimentacao de juros                 ³±±
±±³          ³ nExp02 - Valor da Movimentacao                              ³±±
±±³          ³ lExp03 - Informa se e uma movimentacao de estorno           ³±±
±±³          ³ lExp04 - informa se exibe mensagem de confirmacao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN090MvEntr( nValMov, lEstorno, lJuros )
Local aArea		:= GetArea()
Local cHistorico	:= ""
Local cRecPag		:= ""
Local cTipoLan		:= ""
Local cAliasQry	:= ""
Local cQuery		:= ""
Local cEspCtr		:= ""
Local cNaturez	:= PadR(GetNewPar("MV_CAUCNAT",""),TamSX3("E5_NATUREZ")[1])
Local lMovEst		:= .F.
Local oModelMov 	:= NIL
Local oSubFK5
Local oSubFKA
Local cLog 		:= ""
Local cCamposE5 	:= ""
Local lRet 		:= .T.

Private cLote    := "111"
Private cArquivo := " "

Default lEstorno := .F.
Default lJuros   := .F.
Default nValMov  := CN8->CN8_VLEFET

cEspCtr := CN9->CN9_ESPCTR

// -- Quantidade de passos do processo -- //
ProcRegua(3)

If !lEstorno
	cRecPag  := If(cEspCtr == "1","R","P")
	cTipoLan := If(cEspCtr == "1","D","C")

	If lJuros
		cHistorico := GetNewPar("MV_CAUCHIJ","histjur")
	Else
		cHistorico := GetNewPar("MV_CAUCHIS","hist")
	EndIf

	//-- Adiciona o numero da caucao no final do historico
	cHistorico := cHistorico + "-" + CN8->CN8_CODIGO
Else
	cRecPag  := If(cEspCtr == "1","P","R")
	cTipoLan := If(cEspCtr == "1","C","D")

	If lJuros
		cHistorico := GetNewPar("MV_CAUCHEJ","histjur")
	Else
		cHistorico := GetNewPar("MV_CAUCHES","hist")
	EndIf

	//-- Adiciona o numero da caucao no final do historico
	cHistorico := cHistorico + "-" + CN8->CN8_CODIGO

	//Seleciona a movimentacao referente a caucao
	cQuery := "SELECT SE5.R_E_C_N_O_ AS RECNO FROM "+RetSQLName("SE5")+" SE5 WHERE "
	cQuery += "SE5.E5_DOCUMEN = 'CA"+CN8->CN8_CODIGO+"' AND "
	cQuery += "SE5.E5_HISTOR = '"+cHistorico+"' AND "
	cQuery += "SE5.E5_SITUACA = ' ' AND "
	cQuery += "SE5.D_E_L_E_T_ = ' '"

	cQuery    := ChangeQuery( cQuery )
	cAliasQry := GetNextAlias()

	dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )

	If !(cAliasQry)->(Eof())
		dbSelectArea("SE5")
		SE5->( dbGoTo( (cAliasQry)->RECNO ) )
		//Verifica a data da movimentacao
		If SE5->E5_DATA == CN8->CN8_DTENT
			lMovEst  := .T. //Inverte que deve ser gerado movimentacao de estorno
		EndIf
	EndIf
EndIf

// -- Processo -- //
IncProc()

//-- Posiciona no Banco
DbSelectArea("SA6")
DbSetOrder(1)
DbSeek(xFilial("SA6")+CN8->CN8_BANCO+CN8->CN8_AGENCI+CN8->CN8_CONTA)

cCamposE5 := ""

cCamposE5 += "{"
cCamposE5 += "{'E5_VENCTO'	, SE5->E5_DATA			}"
cCamposE5 += ",{'E5_TIPO'	, '   '					}"
cCamposE5 += ",{'E5_CCD'		, '1'						}"
cCamposE5 += ",{'E5_CCC'		, '1'						}"
cCamposE5 += ",{'E5_TIPOLAN', '"  + cTipoLan + "'	}"

If cEspCtr == "1"
	cCamposE5 += ",{'E5_CLIFOR'	, CN8->CN8_FORNEC		}"
	cCamposE5 += ",{'E5_LOJA'	, CN8->CN8_LOJA		}"
	cCamposE5 += ",{'E5_BENEF'	, Posicione('SA2',1,xFilial('SA2')+CN8->CN8_FORNEC+CN8->CN8_LOJA,'A2_NOME')}"
Else
	cCamposE5 += ",{'E5_CLIFOR'	, CN8->CN8_CLIENT		}"
	cCamposE5 += ",{'E5_LOJA'	, CN8->CN8_LOJACL		}"
	cCamposE5 += ",{'E5_BENEF'	, Posicione('SA1',1,xFilial('SA1')+CN8->CN8_CLIENT+CN8->CN8_LOJACL,'A1_NOME')}"
EndIf
cCamposE5 += ",{'E5_DTDIGIT', dDataBase				}"

If lMovEst
	cCamposE5 += ",{'E5_SITUACA', 'E'}"
EndIf

cCamposE5 += "}"

//Gera movimentacao bancaria
oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)

If lMovEst

	oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
	oModelMov:Activate()
	oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação SE5
	oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
	//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
	//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
	//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
	oModelMov:SetValue( "MASTER", "E5_OPERACAO", 2 ) //E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5

	//Posiciona a FKA com base no IDORIG da SE5 posicionada
	oSubFKA := oModelMov:GetModel( "FKADETAIL" )
	oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

	If oModelMov:VldData()
	   	oModelMov:CommitData()
	Else
		lRet := .F.
	    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
	    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
	    cLog += cValToChar(oModelMov:GetErrorMessage()[6])
	    Help( ,,"M030VALID",,cLog, 1, 0 )
	Endif
	oModelMov:DeActivate()
Else
	oModelMov:SetOperation( MODEL_OPERATION_INSERT ) //Inclusao
	oModelMov:Activate()
	oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou não
	oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
	oModelMov:SetValue( "MASTER", "NOVOPROC", .T. ) //Informa que a inclusão será feita com um novo número de processo

	//Dados do Processo
	oSubFKA := oModelMov:GetModel("FKADETAIL")
	oSubFKA:SetValue( "FKA_IDORIG", FWUUIDV4() )
	oSubFKA:SetValue( "FKA_TABORI", "FK5" )

	//Informacoes do movimento
	oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
	oSubFK5:SetValue( "FK5_DATA"	, dDataBase )
	oSubFK5:SetValue( "FK5_MOEDA"	, strzero(CN8->CN8_MOEDA,2)	 )
	oSubFK5:SetValue( "FK5_VALOR"	, xMoeda(nValMov,CN8->CN8_MOEDA,1,dDataBase) )
	oSubFK5:SetValue( "FK5_NATURE"	, cNaturez )
	oSubFK5:SetValue( "FK5_TPDOC"	, CN8->CN8_TPDOC )
	oSubFK5:SetValue( "FK5_DOC"		, "CA"+CN8->CN8_CODIGO )
	oSubFK5:SetValue( "FK5_BANCO"	, CN8->CN8_BANCO )
	oSubFK5:SetValue( "FK5_AGENCI"	, CN8->CN8_AGENCIA )
	oSubFK5:SetValue( "FK5_CONTA"	, CN8->CN8_CONTA )
	oSubFK5:SetValue( "FK5_RECPAG"	, cRecPag )
	oSubFK5:SetValue( "FK5_HISTOR"	, cHistorico )
	oSubFK5:SetValue( "FK5_DTDISP"	, SE5->E5_DATA )
	oSubFK5:SetValue( "FK5_LA"		, " " )
	oSubFK5:SetValue( "FK5_FILORI", xFilial("SE5") )
	oSubFK5:SetValue( "FK5_ORIGEM", FunName() )

	If oModelMov:VldData()
	   	oModelMov:CommitData()
	Else
		lRet := .F.
	    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
	    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
	    cLog += cValToChar(oModelMov:GetErrorMessage()[6])
	    Help( ,,"M030VALID",,cLog, 1, 0 )
	Endif
	oModelMov:DeActivate()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para alterar as informacoes do movimento financeiro ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CN090MVFIN")
	ExecBlock("CN090MVFIN",.F.,.F.)
EndIf

// -- Processo -- //
IncProc()

AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")

// -- Processo -- //
IncProc()

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090DescMo³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Altera descricao da moeda                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090DescMo()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN090DescMo()
M->CN8_DESCMO := SuperGetMv("MV_MOEDA"+AllTrim(Str(M->CN8_MOEDA,2)),,"")
Return .T.

/*/{Protheus.doc} CN090VldDIn
(Valida data de inicio da vigencia)
@type function
@author Marcelo Custodio
@since 20.01.2006
@version 2.0
@return ${lRet}, ${Data de inicio da vigencia valida?}
@example
/*/Function CN090VldDIn()
Local lRet := CN090VldDEn()
Return lRet

/*/{Protheus.doc} CN090VldDTr
(Valida data de termino da vigencia)
@type function
@author Marcelo Custodio
@since 20.01.2006
@version 2.0
@return ${lRet}, ${Data de termino da vigencia valida}
@example
/*/Function CN090VldDTr()
Local lRet := CN090VldDEn()
Return lRet

/*/{Protheus.doc} CN090VldDEn
(Valida data de entrega da caucao )
@type function
@author Marcelo Custodio
@since 20.01.2006
@version 2.0
@param cHelp, character, (Descrição do parâmetro)
@return ${lRet}, ${Validação da data de entrega}
/*/Function CN090VldDEn()
Local lRet := .T.
Local cHelp :=""

dbSelectArea("CN9")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no contrato         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CN9->CN9_NUMERO != M->CN8_CONTRA .OR. CN9->CN9_REVISA != M->CN8_REVISA
	dbSeek(xFilial("CN9")+M->CN8_CONTRA+M->CN8_REVISA)
EndIf

If !Empty(CN9->CN9_CODED)

	If M->CN8_DTENT > CntPrxData( CN9->CN9_DTFIM, 3, 'M', 1 ) //Verifica data de entrega
		lRet := .F.
		cHelp := "CNTA090_09"//"Data de entrega inválida"
	ElseIf !Empty(M->CN8_DTFIVI) .And. M->CN8_DTENT > CntPrxData( M->CN8_DTFIVI, 3, 'M', 1 )  //Verifica data de termino da vigencia
		lRet := .F.
		cHelp := "CNTA090_08"//"Data de término da vigência inválida"
	EndIf

Else

	If CN9->CN9_DTFIM < M->CN8_DTENT//Verifica data de entrega
		lRet := .F.
		cHelp := "CNTA090_09"//"Data de entrega inválida"
	ElseIf !Empty(M->CN8_DTFIVI) .And. M->CN8_DTFIVI < M->CN8_DTENT//Verifica data de termino da vigencia
		lRet := .F.
		cHelp := "CNTA090_08"//"Data de término da vigência inválida"
	EndIf

EndIf

If !Empty(M->CN8_DTINVI) .And. M->CN8_DTINVI > M->CN8_DTENT//Verifica data de inicio da vigencia
	lRet := .F.
	cHelp := "CNTA090_07"//"Data de início da vigência inválida"
EndIf

If !lRet
	Help( " ", 1, cHelp )
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090GerPA ³ Autor ³ Sergio Silveira       ³ Data ³31/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera o titulo de pagamento antecipado da caucao             ³±±
±±³          ³ Apenas quando for do tipo abatimento em nota                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := CN090GerPA()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> .T. - Sucesso na gravacao / .F. - Insucesso        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN090GerPA()

Local aRotAuto := {}
Local cMoeda   := CN9->CN9_MOEDA
Local cParcela := ""
Local lRet     := .T.
Local lExcPms  := IntePMS() .And. (GetNewPar( "MV_CNEXPMS", "N" ) == "S")
Local lMoeda   := (GetNewPar( "MV_CNMOEDA", "S" ) == "S")
Local aAfxBck
Local cNumTit  := StrZero( Val( M->CN8_CODIGO ), Len( SE2->E2_NUM ) )
Local cPref    := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE2->E2_PREFIXO ) )
Local nValor   := 0
Local cEspCtr  := ""


cEspCtr := CN9->CN9_ESPCTR

Private lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula valor conforme definido no parametro MV_CNMOEDA    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMoeda
	nValor := M->CN8_VLEFET
Else
	nValor := xMoeda(M->CN8_VLEFET,M->CN8_MOEDA,1,dDataBase)
EndIf
If cEspCtr == "1"
	cNumTit  := StrZero( Val( M->CN8_CODIGO ), Len( SE2->E2_NUM ) )
	cPref    := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE2->E2_PREFIXO ) )
	cParcela := Space(Len(SE2->E2_PARCELA))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe integracao com o PMS    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExcPms
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Simula chamada do FINA050  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Private aRatAfr     := {}
		Private lF050Auto   := .T.
		Private M->E2_VALOR := M->CN8_VLEFET
		Private M->E2_MOEDA := cMoeda

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa Dialog para preenchimento do projeto  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAreaSub := GetArea()
		PmsDlgFS(3,cPref,cNumTit,cParcela,"PA",M->CN8_FORNEC,M->CN8_LOJA)
		RestArea(aAreaSub)
		aAfxBck  := aRatAfr
	EndIf

	If ExistBlock("CNTVLDPMS")
		lRet := ExecBlock("CNTVLDPMS",.F.,.F.,{M->CN8_VLEFET,"1"})
	EndIf

	If lRet
		AAdd( aRotAuto, { "E2_NUM"    , StrZero( Val( M->CN8_CODIGO ), Len( SE2->E2_NUM ) ), NIL } )
		AAdd( aRotAuto, { "E2_PREFIXO", cPref, NIL } )
		AADD( aRotAuto, { "E2_PARCELA", cParcela, NIL})
		AAdd( aRotAuto, { "E2_NATUREZ", PadR( GetNewPar( "MV_CAUCNAT",  "" ), Len( SE2->E2_NATUREZ ) ), NIL } )
		AAdd( aRotAuto, { "E2_TIPO"   , "PA", NIL } )
		AAdd( aRotAuto, { "E2_FORNECE", M->CN8_FORNEC, NIL } )
		AAdd( aRotAuto, { "E2_LOJA"   , M->CN8_LOJA  , NIL } )
		AAdd( aRotAuto, { "E2_VALOR"  , nValor, NIL } )
		If lMoeda
			AADD( aRotAuto, { "E2_MOEDA"   , M->CN8_MOEDA, NIL})
			AAdd( aRotAuto, { "E2_TXMOEDA" , RecMoeda(dDatabase,M->CN8_MOEDA), NIL } )
		Else
	  		AADD( aRotAuto, { "E2_MOEDA"  , 1, NIL})
		EndIf
		AAdd( aRotAuto, { "E2_EMISSAO", dDataBase, NIL } )
		AAdd( aRotAuto, { "E2_VENCTO" , dDataBase, NIL } )
		AAdd( aRotAuto, { "E2_VENCREA", DataValida( dDataBase ), NIL } )
		AADD( aRotAuto, { "E2_VENCORI", DataValida( Ddatabase,.T.),NIL })
		AADD( aRotAuto, { "E2_MDCONTR", M->CN8_CONTRA, NIL})
		AADD( aRotAuto, { "E2_MDREVIS", M->CN8_REVISA, NIL})
		AADD( aRotAuto, { "E2_ORIGEM" , "CNTA090"    , NIL})
		AAdd( aRotAuto, { "AUTBANCO"  , M->CN8_BANCO , NIL } )
		AAdd( aRotAuto, { "AUTAGENCIA", M->CN8_AGENCI, NIL } )
		AAdd( aRotAuto, { "AUTCONTA"  , M->CN8_CONTA , NIL } )

		MSExecAuto({|x, y| FINA050(x, y)}, aRotAuto, 3)

		If !lMsErroAuto
			aRatAfr := aAfxBck
			If !Empty(aRatAfr)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava informacao de despesa do projeto  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PmsWriteFI(1,"SE2")
				aRatAfr := {}
			EndIf
		EndIf
	EndIf
Else
	cNumTit  := StrZero( Val( M->CN8_CODIGO ), Len( SE1->E1_NUM ) )
	cPref    := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE1->E1_PREFIXO ) )
	cParcela := Space(Len(SE1->E1_PARCELA))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe integracao com o PMS    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExcPms
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Simula chamada do FINA040  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Private aRatAft := {}
		Private M->E1_VALOR := M->CN8_VLEFET
		Private M->E1_MOEDA := cMoeda

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa Dialog para preenchimento do projeto  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAreaSub := GetArea()
		PmsDlgRC(3,cPref,cNumTit,cParcela,"PA",M->CN8_CLIENT,M->CN8_LOJACL)
		RestArea(aAreaSub)
		aAfxBck  := aRatAft
	EndIf

	If ExistBlock("CNTVLDPMS")
		lRet := ExecBlock("CNTVLDPMS",.F.,.F.,{M->CN8_VLEFET,"2"})
	EndIf

	If lRet
		AAdd( aRotAuto, { "E1_NUM"    , cNumTit, NIL } )
	    AAdd( aRotAuto, { "E1_PARCELA", cParcela, NIL } )
		AAdd( aRotAuto, { "E1_PREFIXO", cPref, NIL } )
		AAdd( aRotAuto, { "E1_NATUREZ", PadR( GetNewPar( "MV_CAUCNAT",  "" ), Len( SE1->E1_NATUREZ ) ), NIL } )
		AAdd( aRotAuto, { "E1_TIPO"   , "RA", NIL } )
		AAdd( aRotAuto, { "E1_CLIENTE", M->CN8_CLIENT, NIL } )
		AAdd( aRotAuto, { "E1_LOJA"   , M->CN8_LOJACL, NIL } )
		AAdd( aRotAuto, { "E1_VALOR"  , nValor, NIL } )
		If lMoeda
			AADD( aRotAuto, { "E1_MOEDA"   , M->CN8_MOEDA, NIL})
			AAdd( aRotAuto, { "E1_TXMOEDA" , RecMoeda(dDatabase,M->CN8_MOEDA), NIL } )
		Else
	  		AADD( aRotAuto, { "E1_MOEDA"  , 1, NIL})
		EndIf
		AAdd( aRotAuto, { "E1_EMISSAO", dDataBase, NIL } )
		AAdd( aRotAuto, { "E1_VENCTO" , dDataBase, NIL } )
		AAdd( aRotAuto, { "E1_VENCREA", DataValida( dDataBase ), NIL } )
		AADD( aRotAuto, { "E1_VENCORI", DataValida( Ddatabase,.T.),NIL })
		AADD( aRotAuto, { "E1_MDCONTR", M->CN8_CONTRA, NIL})
		AADD( aRotAuto, { "E1_MDREVIS", M->CN8_REVISA, NIL})
		AADD( aRotAuto, { "E1_ORIGEM" , "CNTA090"    , NIL})
		AAdd( aRotAuto, { "CBCOAUTO"  , M->CN8_BANCO , NIL } )
		AAdd( aRotAuto, { "CAGEAUTO"  , M->CN8_AGENCI, NIL } )
		AAdd( aRotAuto, { "CCTAAUTO"  , M->CN8_CONTA , NIL } )

		MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3)

		If !lMsErroAuto
			aRatAft := aAfxBck
			If !Empty(aRatAft)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava informacao de despesa do projeto  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PmsWriteRC(1,"SE1")
				aRatAft := {}
			EndIf
		EndIf
	EndIf
EndIf

If lMsErroAuto
	MOSTRAERRO()
EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090ExcPA ³ Autor ³ Sergio Silveira       ³ Data ³31/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exclui o titulo de pagamento antecipado da caucao           ³±±
±±³          ³ Apenas quando for do tipo abatimento em nota                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := CN090ExcPA()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> .T. - Sucesso na exclusao / .F. - Insucesso        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN090ExcPA()

Local aRotAuto  := {}
Local cParcela  := ""
Local cTipo     := ""
Local cPrefixo  := ""
Local cNumero   := ""
Local cFornece  := ""
Local cCliente  := ""
Local cLoja     := ""

Private lMsErroAuto := .F.

If !Empty(CN8->CN8_CLIENT)=.F.
	cTipo     := PadR( "PA", Len( SE2->E2_TIPO ) )
	cPrefixo  := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE2->E2_PREFIXO ) )
	cNumero   := StrZero( Val( CN8->CN8_CODIGO ), Len( SE2->E2_NUM ) )
	cFornece  := CN8->CN8_FORNEC
	cLoja     := CN8->CN8_LOJA
	cParcela  := Space(TamSX3("E2_PARCELA")[1])

	SE2->( dbSetOrder( 1 ) )
	If SE2->( MsSeek( xFilial( "SE2" ) + cPrefixo + cNumero + cParcela + cTipo + cFornece + cLoja ) )

		AAdd( aRotAuto, { "E2_NUM"    , cNumero ,NIL } )
		AAdd( aRotAuto, { "E2_PREFIXO", cPrefixo,NIL } )
		AAdd( aRotAuto, { "E2_TIPO"   , cTipo   ,NIL } )
		AAdd( aRotAuto, { "E2_FORNECE", cFornece,NIL } )
		AAdd( aRotAuto, { "E2_LOJA"   , cLoja   ,NIL } )
		AAdd( aRotAuto, { "E2_PARCELA", cParcela,NIL } )

		MSExecAuto({|x, y, z | FINA050(x, y, z)}, aRotAuto, 5, 5 )

		SE2->( FKCommit() )

		If lMsErroAuto .And. !IsBlind()
			MOSTRAERRO()
		EndIf
	EndIf
Else
	cTipo     := PadR( "RA", Len( SE1->E1_TIPO ) )
	cPrefixo  := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE1->E1_PREFIXO ) )
	cNumero   := StrZero( Val( CN8->CN8_CODIGO ), Len( SE1->E1_NUM ) )
	cCliente  := CN8->CN8_CLIENT
	cLoja     := CN8->CN8_LOJACL
	cParcela  := Space(TamSX3("E1_PARCELA")[1])

	SE1->( dbSetOrder( 1 ) )
	If SE1->( MsSeek( xFilial( "SE1" ) + cPrefixo + cNumero + cParcela + cTipo ) )
		AAdd( aRotAuto, { "E1_NUM"    , cNumero ,NIL } )
		AAdd( aRotAuto, { "E1_PREFIXO", cPrefixo,NIL } )
		AAdd( aRotAuto, { "E1_TIPO"   , cTipo   ,NIL } )
		AAdd( aRotAuto, { "E1_CLIENTE", cCliente,NIL } )
		AAdd( aRotAuto, { "E1_LOJA"   , cLoja   ,NIL } )
		AAdd( aRotAuto, { "E1_PARCELA", cParcela,NIL } )

		MSExecAuto({|x, y, z | FINA040(x, y, z)}, aRotAuto, 5, 5 )

		SE1->( FKCommit() )

		If lMsErroAuto .And. !IsBlind()
			MOSTRAERRO()
		EndIf

	EndIf
EndIf

Return( !lMsErroAuto )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090VerPA ³ Autor ³ Sergio Silveira       ³ Data ³31/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se o titulo de abatimento sofreu movimentacao      ³±±
±±³          ³ Apenas quando for do tipo abatimento em nota                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := CN090VerPA()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> .T. - Sucesso na exclusao / .F. - Insucesso        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN090VerPA()

Local cTipo
Local cPrefixo
Local cNumero
Local cFornece  := CN8->CN8_FORNEC
Local cLoja     := CN8->CN8_LOJA
Local cParcela  := ""

Local lRetorno  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o titulo de adiantamento                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(CN8->CN8_CLIENT)=.F.
	cParcela  := Space(Len(SE2->E2_PARCELA))
	cTipo     := PadR( "PA", Len( SE2->E2_TIPO ) )
	cNumero   := StrZero( Val( CN8->CN8_CODIGO ), Len( SE2->E2_NUM ) )
	cPrefixo  := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE2->E2_PREFIXO ) )

	SE2->( dbSetOrder( 1 ) )
	If SE2->( MsSeek( xFilial( "SE2" ) + cPrefixo + cNumero + cParcela + cTipo + cFornece + cLoja ) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o titulo de adiantamento ja sofreu baixas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE2->E2_VALOR <> SE2->E2_SALDO
			Aviso( STR0026, STR0027, { STR0028 }, 2 ) // "Atencao !", "A caucao nao podera ser alterada ou excluida pois a mesma ja sofreu movimentacao !","Ok"
			lRetorno := .F.
		EndIf
	Else
		If Aviso( STR0026, STR0029, { STR0035,STR0036 }, 2 ) == 2 // "Atencao !", "O Titulo de adiantamento para esta Caução não foi encontrado. Deseja Continua ?"
			lRetorno := .F.
		EndIf
	EndIf
Else
	cTipo     := PadR( "RA", Len( SE1->E1_TIPO ) )
	cParcela  := Space(Len(SE1->E1_PARCELA))
	cPrefixo  := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE1->E1_PREFIXO ) )
	cNumero   := StrZero( Val( CN8->CN8_CODIGO ), Len( SE1->E1_NUM ) )

	SE1->( dbSetOrder( 1 ) )
	If SE1->( MsSeek( xFilial( "SE1" ) + cPrefixo + cNumero + cParcela + cTipo +CN8->CN8_CLIENT+ CN8->CN8_LOJACL,.T. ) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o titulo de adiantamento ja sofreu baixas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE1->E1_VALOR <> SE1->E1_SALDO
			Aviso( STR0026, STR0027, { STR0028 }, 2 ) // "Atencao !", "A caucao nao podera ser alterada ou excluida pois a mesma ja sofreu movimentacao !","Ok"
			lRetorno := .F.
		EndIf
	Else
		If Aviso( STR0026, STR0029, { STR0035,STR0036 }, 2 ) == 2 // "Atencao !", "O Titulo de adiantamento para esta Caução não foi encontrado. Deseja Continua ?"
			lRetorno := .F.
		EndIf
	EndIf
EndIf

Return( lRetorno )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090VldPA ³ Autor ³ Sergio Silveira       ³ Data ³17/04/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se os dados necessarios a geracao do titulo de     ³±±
±±³          ³ pagamento antecipado estao presentes                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := CN090VldPA()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> .T. - Validacao / .F. - Insucesso                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Function CN090VldPa(cCodTpC)

Local cNatureza := ""

Local lGeraPA   := .F.
Local lRet      := .T.
Local cBanco    := M->CN8_BANCO
Local cAgenci   := M->CN8_AGENCI
Local cConta    := M->CN8_CONTA


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o tipo de caucao                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CN3->( dbSetOrder( 1 ) )
CN3->( MsSeek( xFilial( "CN3" ) + cCodTpC ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se gera pagamento antecipado                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lGeraPA := (CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI = "1")
If lGeraPA

	//-- Posiciona no Banco
	DbSelectArea("SA6")
	DbSetOrder(1)
	If lRet .And. !SA6->(MsSeek(xFilial("SA6")+cBanco+cAgenci+cConta))
		Aviso( STR0026, STR0061, { STR0028 }, 2 ) // "Atencao !", "A Agencia ou Banco definido na Caução não esta cadastrada na rotina de Bancos.", "Ok"
		lRet := .F.
	EndIf
EndIf

If CN3->CN3_LIGFIN = '1'
	If CN3->(dbseek(xFilial("CN3")+cCodTPc)) .And. Empty(M->CN8_TPDOC)
		lRet := .F.
		Help( " ", 1, "CN090Grv")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a natureza esta informada ou se eh valida  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		cNatureza := PadR( GetNewPar( "MV_CAUCNAT",  "" ), Len( SE2->E2_NATUREZ ) )
		If Empty( cNatureza )
			Aviso( STR0026, STR0030, { STR0028 }, 2 )	// "Atencao !", "Configurar a natureza financeira do titulo de caucao atraves do parametro MV_CAUCNAT.", "Ok"
			lRet := .F.
		EndIf

		If lRet
			SED->( dbSetOrder( 1 ) )
			If !SED->( MsSeek( xFilial( "SED" ) + cNatureza ) )
				Aviso( STR0026, STR0031, { STR0028 }, 2 ) // "Atencao !", "A natureza definida pelo parametro MV_CAUCNAT nao esta cadastrada.", "Ok"
				lRet	 := .F.
			EndIf
		EndIf
	EndIf
EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090Bx    ³ Autor ³ Sergio Silveira       ³ Data ³17/04/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Baixa a caucao                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := CN090Bx( ExpC1, ExpN2, ExpN3 )                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Alias / ExpN2 -> Recno / ExpN3 -> Opcao do arotina ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> .T. - Validacao / .F. - Insucesso                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN090Bx(cAlias,nReg,nOpcx,lAutomato)

Local cPicValor  := PesqPict("CN8","CN8_VLEFET")
Local nOpcA      := 0
Local lCaucDinhe := .T.
Local lRet       := .T.
Local oBold

Private oDlg
Private nValorJur := 0
Private nValorResg := 0

DEFAULT lAutomato := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ posiciona atraves do recno do registro selecionado    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄadminÄÄÄÄÙ
dbSelectArea("CN8")
CN8->(dbGoTo(nReg))

If !Empty(CN8->CN8_DTBX)
	Aviso( STR0026, STR0032, { STR0028 } ) // "Atencao", "Esta Caução já esta Baixada.", "Ok"
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se existe contrato / vigência                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !Empty(CN8->CN8_CONTRA)
	dbSelectArea("CN9")
	dbSetOrder(1)
	If !MsSeek(xFilial("CN9")+CN8->CN8_CONTRA+CN8->CN8_REVISA)
		Aviso( STR0026 , STR0033, { STR0028 } )  // "Atencao","Contrato não encontrado.", "Ok"
		lRet := .F.
	Else
	    If CN9->CN9_SITUAC#DEF_SVIGE
    		Aviso( STR0026 , STR0060, { STR0028 } )  // "Atencao","Para baixar a caução, é necessário que o contrato esteja Vigente !", "Ok"
			lRet := .F.
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se tipo de caucao eh dinheiro pra baixar a caucao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CN3")
dbSetOrder(1)
If lRet .And. CN3->( MsSeek(xFilial("CN3")+CN8->CN8_TPCAUC) )
	If !(CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI # "1")
		nValorResg := CN8->CN8_VLEFET
		If !lAutomato .And. Aviso( STR0026, STR0034,{ STR0035, STR0036 } ) <> 1 // "Atencao", "Confirma a Baixa da Caução?","Sim","Nao"
			lRet := .F.
		EndIf
		lCaucDinhe := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ valor do resgate quando a caução for em dinheiro           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet

	If lCaucDinhe

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a Tela ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		DEFINE MSDIALOG oDlg TITLE STR0037 FROM 0,0 TO 280, 360 OF oMainWnd PIXEL // "Baixa da caucao"

		DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

		@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 55, 1000 NOBORDER WHEN .F. PIXEL

		@ 03, 40 SAY STR0037 FONT oBold PIXEL // "Baixa da caucao"

		@ 14, 30 TO 16 ,400 LABEL '' OF oDlg   PIXEL

		@ 30, 40 Say STR0038 Size 80,8 PIXEL // "Digite o Valor Total do Resgate"

		@ 45,  40 Say STR0039 Size 60,8 PIXEL // "Código da Caução :"
		@ 45, 100 MsGet CN8->CN8_CODIGO SIZE 55,8 WHEN .F. PIXEL

		@ 60,  40 Say STR0040 Size 60,8 PIXEL // "Valor Efetivo :"
		@ 60, 100 MsGet CN8->CN8_VLEFET Picture cPicValor SIZE 55,8 WHEN .F. PIXEL

		@ 75,  40 Say STR0041 Size 60,8 PIXEL // "Valor do Resgate :"
		@ 75, 100 MsGet nValorResg Picture cPicValor Valid CN090VlBaix() SIZE 55,8 WHEN .T. PIXEL

		@ 90,  40 Say STR0042 Size 60,8 Of oDlg PIXEL // "Valor dos Juros :"
		@ 90, 100 MsGet nValorJur Picture cPicValor SIZE 55,8 WHEN .F. PIXEL

		DEFINE SBUTTON FROM 110,090 TYPE 1 ACTION (nOpcA := 1,If( Aviso( STR0026, STR0034, { STR0035, STR0036 } )==1,; // "Atencao", "Confirma a Baixa da Caução?", Sim","Nao"
		oDlg:End(), nOpcA:=0)) ENABLE OF oDlg
		DEFINE SBUTTON FROM 110,125 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpcA ==  1

			Begin Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera Titulo a Pagar/Receber para o total baixado           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	      Processa({|| lRet := CN090GrPgto(CN8->CN8_VLEFET, nValorJur)},,If(Empty(CN8->CN8_CLIENT),STR0044,STR0055)) // "Gerando Titulo a Pagar..."##"Gerando Titulo a Receber..."

			If lRet
				If nValorJur > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gera a Movimentacao Bancaria de Entrada para os Juros      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Processa({|| CN090MvEntr(nValorJur,NIL,.T.)},,STR0043) // "Gerando Movimento de Juros..."
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ baixa a caucao                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("CN8")
				dbSetOrder(1)
				RecLock("CN8",.F.)
				CN8->CN8_DTBX := dDataBase
				CN8->CN8_VLBX := nValorResg
				MsUnlock()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ contabilizar baixa caucao                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				CN090Contab(3)

				If (__lSX8)
					ConfirmSX8()
				EndIf
				EvalTrigger()
			EndIf

			End Transaction

		Else
			lRet := .F.
		EndIf
	EndIf

	If lRet .And. !lCaucDinhe

		Begin transaction

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ baixa a caucao                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CN8")
		dbSetOrder(1)
		RecLock("CN8",.F.)
		CN8->CN8_DTBX := dDataBase
		CN8->CN8_VLBX := nValorResg
		MsUnlock()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ contabilizar baixa caucao                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CN090Contab(3)

		End transaction

	EndIf

EndIf

return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090Contab³ Autor ³ Sergio Silveira       ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera contabilizacao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090Contab(ExpN1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Tipo de contabilizacao E (Entrada) ou B (Baixa)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN090Contab(nTipMov)

LOCAL aArea     := GetArea()

LOCAL cPadrao   := ""
LOCAL cLoteCtb  := ""

LOCAL lDigita   := If(MV_PAR02==1,.T.,.F.)
LOCAL lPadrao   := .F.

LOCAL nHdlPrv   := 0
LOCAL nTotal    := 0
LOCAL aCtbDia	:= {}

Private cArquivo := " "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no fornecedor                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !EMPTY(CN8->CN8_CLIENT)=.F.
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+CN8->CN8_FORNEC+CN8->CN8_LOJA)
Else
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+CN8->CN8_CLIENT+CN8->CN8_LOJACL)

Endif

Begin Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os lancamentos padroes                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTipMov == 1 // Inclusao
	cPadrao := "690"
ElseIf nTipMov == 2 // Exclusao
	cPadrao := "691"
Else // Baixa
	cPadrao := "692"
EndIf

lPadrao := VerPadrao(cPadrao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Lancamento Contabil³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lPadrao .and. MV_PAR01 == 1 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o numero do lote contabil                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSetOrder(1)
	If MsSeek(xFilial()+"09GCT")
		cLoteCtb := AllTrim(X5Descri())
	Else
		cLoteCtb := "GCT "
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa um execblock                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At(UPPER("EXEC"),X5Descri()) > 0
		cLoteCtb := &(X5Descri())
	EndIf

	nHdlPrv := HeadProva(cLoteCtb,"CNTA090",Substr(cUsuario,7,6),@cArquivo)
	nTotal  += DetProva(nHdlPrv,cPadrao,"CNTA090",cLoteCtb)
	RodaProva(nHdlPrv,nTotal)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia para Lancamento Contabil³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc == "PTG"
		aCtbDia := {{"CN8",CN8->(RECNO()),CN8->CN8_DIACTB,"CN8_NODIA"}}
	Else
	    aCtbDia := {}
	EndIF
	cA100Incl(cArquivo,nHdlPrv,3,cLoteCtb,lDigita,.F.,,,,,,aCtbDia)
EndIf

End Transaction

RestArea(aArea)
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090VlBaix³ Autor ³ Sergio Silveira       ³ Data ³10/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o valor do resgate                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090VlBaix()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Tipo de contabilizacao E (Entrada) ou B (Baixa)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN090VlBaix()
Local lRet := .T.

If nValorResg < CN8->CN8_VLEFET
	Aviso(STR0026, STR0045,{STR0028},2) // "Atencao","O Valor do Resgate não pode ser menor que o Valor Efetivo da Caução!","Ok"
	lRet := .F.
Else
	nValorJur := nValorResg - CN8->CN8_VLEFET
EndIf

oDlg:Refresh()

Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090GrPgto³ Autor ³ Sergio Silveira       ³ Data ³12/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera titulo a pagar/receber para a devolucao da caucao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090GrPgto(ExpN1,ExpN2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³robson Nayla³18/10/06³      ³Inclusao da geracao dos titulos a receber  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Function CN090GrPgto(nValTit, nValJuros)

Local aTit       := {}

Local cNumTit    := ""

Local cPrefixo   := PadR( GetNewPar( "MV_CAUCPRF", "CPX" ), Len( SE2->E2_PREFIXO ) )
Local cNaturez   := PadR( GetNewPar( "MV_CAUCNAT", "" )   , Len( SE2->E2_NATUREZ ) )
local cTipo      := MVDUPLIC
Local cParcela   := ""
Local lRet       := .T.
Local lExcPms    := IntePMS() .And. (GetNewPar( "MV_CNEXPMS", "N" ) == "S")
Local lMoeda     := (GetNewPar( "MV_CNMOEDA", "S" ) == "S")
Local aAfrBck
Local aAfxBck

Local oDlg
Local oBmp
Local oBut
Local oBold

Private lMSerroAuto

// -- Quantidade de passos do processo -- //
ProcRegua(2)

//-- Posiciona no Banco
DbSelectArea("SA6")
DbSetOrder(1)
DbSeek(xFilial("SA6")+CN8->CN8_BANCO+CN8->CN8_AGENCI+CN8->CN8_CONTA)

If !lMoeda
	nValTit := xMoeda(nValTit,CN8->CN8_MOEDA,1,dDataBase)
EndIf
If !Empty(CN8->CN8_CLIENT)=.F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera numero do titulo a pagar              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumTit  := GetSXENum("SE2","E2_NUM")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Numero da Parcela                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cParcela := Space(Len(SE2->E2_PARCELA))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe integracao com o PMS    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExcPms
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Simula chamada do FINA050  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Private aRatAfr := {}
		Private lF050Auto := .T.
		Private M->E2_VALOR := nValTit
		Private M->E2_MOEDA := CN8->CN8_MOEDA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa Dialog para preenchimento do projeto  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAreaSub := GetArea()
		PmsDlgFS(3,cPrefixo,cNumTit,cParcela,cTipo,CN8->CN8_FORNEC,CN8->CN8_LOJA)
		RestArea(aAreaSub)
		aAfrBck  := aRatAfr
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para validacao do lancamento de projeto - PMS ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("CNTVLDPMS")
		lRet := ExecBlock("CNTVLDPMS",.F.,.F.,{nValTit,"1"})
	EndIf

	If lRet
		aTit := {	{"E2_NUM"     , cNumTit          , NIL },;
					{"E2_PREFIXO" , cPrefixo         , NIL },;
					{"E2_PARCELA" , cParcela         , NIL },;
					{"E2_TIPO"    , cTipo            , NIL },;
					{"E2_NATUREZ" , cNaturez         , NIL },;
					{"E2_FORNECE" , CN8->CN8_FORNEC  , NIL },;
					{"E2_LOJA"    , CN8->CN8_LOJA    , NIL },;
					{"E2_EMISSAO" , dDataBase        , NIL },;
					{"E2_VENCTO"  , dDataBase        , NIL },;
					{"E2_VENCREA" , dDataBase        , NIL },;
					{"E2_VENCORI" , dDataBase        , NIL },;
					{"E2_VALOR"   , nValTit          , NIL },;
					{"E2_VLCRUZ"  , nValTit          , NIL },;
					{"E2_EMIS1"   , dDataBase        , NIL },;
					{"E2_MDCONTR" , CN8->CN8_CONTRA  , NIL },;
					{"E2_MDREVIS" , CN8->CN8_REVISA  , NIL },;
					{"E2_ORIGEM"  , "CNTA090"        , NIL },;
					{"E2_CAUCOES" , CN8->CN8_CODIGO  , NIL },;
					{"E2_MOEDA"   , iIf(lMoeda,CN8->CN8_MOEDA,1)                    , NIL },;
					{"E2_TXMOEDA" , iIf(lMoeda,RecMoeda(dDatabase,CN8->CN8_MOEDA),0), NIL },;
					{"E2_ACRESC"  , nValJuros        , NIL }}

		// -- Processo -- //
		IncProc()

		dbSelectArea("SE2")
		lMsErroAuto := .F.
		FinA050(aTit,,3)
		If !lMSErroAuto
			If ( __lSx8 )
				ConfirmSX8()
			EndIf

			aRatAfr := aAfrBck
			If !Empty(aRatAfr)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava informacao de despesa do projeto  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PmsWriteFI(1,"SE2")
				aRatAfr := {}
			EndIf
		Else
			Aviso( STR0026, STR0046, { STR0028 }, 2 ) // "Não foi possível gerar o Título a Pagar."
			RollBackSx8()
			DisarmTransaction()
			MostraErro()

			lRet := .F.
		EndIf
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera numero do titulo a receber            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumTit    := GetSXENum("SE1","E1_NUM")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Numero da Parcela                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cParcela   := Space(Len(SE1->E1_PARCELA))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe integracao com o PMS    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExcPms
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Simula chamada do FINA040  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Private aRatAft     := {}
		Private M->E1_VALOR := nValTit
		Private M->E1_MOEDA := CN8->CN8_MOEDA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa Dialog para preenchimento do projeto  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAreaSub := GetArea()
		PmsDlgRC(3,cPrefixo,cNumTit,cParcela,"PA",CN8->CN8_CLIENT,CN8->CN8_LOJACL)
		RestArea(aAreaSub)
		aAfxBck  := aRatAft
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para validacao do lancamento de projeto - PMS ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("CNTVLDPMS")
		lRet := ExecBlock("CNTVLDPMS",.F.,.F.,{nValTit,"2"})
	EndIf

	If lRet
		aTit := {	{"E1_NUM"     , cNumTit          , NIL },;
					{"E1_PREFIXO" , cPrefixo         , NIL },;
					{"E1_PARCELA" , cParcela         , NIL },;
					{"E1_TIPO"    , cTipo            , NIL },;
					{"E1_NATUREZ" , cNaturez         , NIL },;
					{"E1_CLIENTE" , CN8->CN8_CLIENT  , NIL },;
					{"E1_LOJA"    , CN8->CN8_LOJACL  , NIL },;
					{"E1_EMISSAO" , dDataBase        , NIL },;
					{"E1_VENCTO"  , dDataBase        , NIL },;
					{"E1_VENCREA" , dDataBase        , NIL },;
					{"E1_VENCORI" , dDataBase        , NIL },;
					{"E1_VALOR"   , nValTit          , NIL },;
					{"E1_VLCRUZ"  , nValTit          , NIL },;
					{"E1_MDCONTR" , CN8->CN8_CONTRA  , NIL },;
					{"E1_MDREVIS" , CN8->CN8_REVISA  , NIL },;
					{"E1_EMIS1"   , dDataBase        , NIL },;
					{"E1_ORIGEM"  , "CNTA090"        , NIL },;
					{"E1_MOEDA"   , iIf(lMoeda,CN8->CN8_MOEDA,1)                    , NIL },;
					{"E1_TXMOEDA" , iIf(lMoeda,RecMoeda(dDatabase,CN8->CN8_MOEDA),0), NIL },;
					{"E1_ACRESC"  , nValJuros        , NIL }}

		// -- Processo -- //
		IncProc()

		dbSelectArea("SE1")
		lMsErroAuto := .F.
		FinA040(aTit,,3)
		If !lMSErroAuto
			If ( __lSx8 )
				ConfirmSX8()
			EndIf

			aRatAft := aAfxBck
			If !Empty(aRatAft)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava informacao de receita do projeto  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PmsWriteRC(1,"SE1")
				aRatAft := {}
			EndIf
		Else
			Aviso( STR0026, STR0054, { STR0028 }, 2 ) // "Não foi possível gerar o Título a Receber."
			RollBackSx8()
			DisarmTransaction()
			MostraErro()

			lRet := .F.
		EndIf
	EndIf
EndIf

// -- Processo -- //
IncProc()

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe o resumo                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(CN8->CN8_CLIENT)=.F.
		DEFINE MSDIALOG oDlg TITLE STR0047 FROM 9,0 TO 25,50 OF oMainWnd //"Resumo"
		@ 00,00 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 30, 120 NOBORDER WHEN .F. PIXEL
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		@ 08,38 SAY STR0047 FONT oBold PIXEL
	Else
		DEFINE MSDIALOG oDlg TITLE STR0056 FROM 9,0 TO 25,50 OF oMainWnd //"Resumo"
		@ 00,00 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 30, 120 NOBORDER WHEN .F. PIXEL
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		@ 08,38 SAY STR0056 FONT oBold PIXEL
	EndIf

	@ 24,30 TO 26 ,400 LABEL '' OF oDlg   PIXEL

	@ 31,38 SAY STR0048 PIXEL OF oDlg // "Prefixo"
	@ 41,38 SAY STR0049 PIXEL OF oDlg // "Numero do Titulo"
	@ 51,38 SAY STR0050 PIXEL OF oDlg // "Parcela"
	@ 61,38 SAY STR0051 PIXEL OF oDlg // "Tipo"
	@ 71,38 SAY STR0052 PIXEL OF oDlg // "Valor"
	@ 81,38 SAY STR0053 PIXEL OF oDlg // "Acrescimo"

	@ 31,110 SAY cPrefixo SIZE 80, 10 PIXEL   RIGHT
	@ 41,110 SAY cNumTit  SIZE 80, 10 PIXEL   RIGHT
	@ 51,110 SAY cParcela SIZE 80, 10 PIXEL   RIGHT
	@ 61,110 SAY cTipo    SIZE 80, 10 PIXEL   RIGHT
	If !Empty(CN8->CN8_CLIENT)=.F.
		@ 71,110 SAY Transform(nValTit  ,PesqPict("SE2","E2_VALOR"))  SIZE 80, 10 PIXEL   RIGHT
		@ 81,110 SAY Transform(nValJuros,PesqPict("SE2","E2_ACRESC")) SIZE 80, 10 PIXEL   RIGHT
	Else
		@ 71,110 SAY Transform(nValTit  ,PesqPict("SE1","E1_VALOR"))  SIZE 80, 10 PIXEL   RIGHT
		@ 81,110 SAY Transform(nValJuros,PesqPict("SE1","E1_ACRESC")) SIZE 80, 10 PIXEL   RIGHT
	EndIf

	@ 90,030 TO 92 ,400 LABEL '' OF oDlg PIXEL

	DEFINE SBUTTON oBut FROM 101,162  TYPE 1 ACTION ( oDlg:End() ) ENABLE of oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³31/10/2006³±±
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
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
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
Private aRotina	:= { 	{ STR0002, "AxPesqui"  	, 0, 1, 0, .F.},;	//"Pesquisar"
							{ STR0003, "CN090Manut"	, 0, 2, 0, nil},;	//"Visualizar"
							{ STR0004, "CN090Manut" , 0, 3, 0, nil},;	//"Incluir"
							{ STR0005, "CN090Manut"	, 0, 4, 0, nil},;	//"Alterar"
							{ STR0006, "CN090Manut"	, 0, 5, 0, nil},;	//"Excluir"
							{ STR0008, "CN090Bx" 	, 0, 6, 0, nil},;	//"Baixar"
							{ "Estorn.Baixa", "CN090Est"	, 0, 5, 0, nil} }	//"Estorn.Baixa"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTA090MNU")
	ExecBlock("CTA090MNU",.F.,.F.)
EndIf
Return(aRotina)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldCTB     ³ Autor ³ Andre Sperandio      ³ Data ³ 23.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao utilizada para validacao da contabilizacao em 	  ³±±
±±³			 ³ Portugal												  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA090                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCTB()
Local lRet:= .T.

If cPaisloc == "PTG"
	lRet:= CTBVldDiario(M->CN8_DIACTB)
Endif
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³cn090TotCau³ Autor ³ Aline Sebrian        ³ Data ³ 07.08.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a soma do valor efetivo da caução está maior que³±±
±±³          ³o valor atual do contrato.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA090                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function cn090TotCau()
Local lRet      := .T.
Local cQuery    := ""
Local cAliasQry := .T.

cAliasQry := GetNextAlias()

cQuery := "SELECT SUM(CN8_VLEFET) AS VLEFET FROM " + RetSqlName( "CN8" ) + " "
cQuery += " WHERE CN8_FILIAL =  '" + xFilial( "CN8" )+ "'"
cQuery += "   AND CN8_CONTRA =  '" + CN9->CN9_NUMERO + "'"
cQuery += "   AND CN8_REVISA =  '" + CN9->CN9_REVISA + "'"
cQuery += "   AND CN8_CODIGO <> '" + M->CN8_CODIGO + "'"
cQuery += "   AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )

TCSetField( cAliasQry, "VLEFET", "N", TamSX3("CN8_VLEFET")[1], TamSX3("CN8_VLEFET")[2] )

nVlEfet := Round(( cAliasQry )->VLEFET + M->CN8_VLEFET,TamSx3("CN8_VLEFET")[2])

( cAliasQry )->( dbCloseArea() )

//Posiciona na revisão atual do contrato
CN9->(dbSeek(xFilial('CN9')+M->CN8_CONTRA+M->CN8_REVISA))

If nVlEfet > Round(CN9->CN9_VLATU,TamSx3("CN8_VLEFET")[2])
	lRet := .F.
    Help( " ", 1, "CNTA090_10" )//"Este contrato não pode ser caucionado."
EndIf

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CN9CauEsp  ³ Autor ³ Aline Sebrian         ³ Data ³07/10/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera consulta especifica do contrato ao caução              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CNTA090                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN9CauEsp()
Local lExport    := .T.
Local aColsBck   := {}
Local aHeaderBck := {}
Local aArea      := GetArea()
Local oList
Local oDlg
Local cQuery
Local TRBCN9     := ""

Local lBck       := .F.
Local aContrato  := {}
Local nOAT

Local cContra
Local cRevisa

If Type("aHeader")=="A"
	 lBck := .T.
     aHeaderBck:= aHeader
     aColsBck  := aCols
EndIf

cQuery := " SELECT CN9_NUMERO, MAX(CN9_REVISA) AS CN9_REVISA "
cQuery += "   FROM " + RetSqlName("CN9")
cQuery += " WHERE CN9_FILIAL =  '" + xFilial("CN9") + "' AND D_E_L_E_T_='' AND"
cQuery += "       CN9_FLGCAU = '1' AND CN9_TPCAUC = '1' "
cQuery += " GROUP BY CN9_NUMERO "
cQuery += " ORDER BY CN9_NUMERO,CN9_REVISA "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCN9",.F.,.T.)


While !TRBCN9->(Eof())
	Aadd(aContrato,{TRBCN9->CN9_NUMERO,TRBCN9->CN9_REVISA})
	dbSelectArea("TRBCN9")
	dbSkip()
EndDo

TRBCN9->(dbCloseArea())

If Len(aContrato) == 0
	Help("CNTA090",1,"REGNOIS")
	lExport:= .F.
EndIf

If lExport


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria tela de consulta dos contratos          	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0057) FROM 009,000 TO 025,060 OF oMainWnd
	@005,005 LISTBOX oList FIELDS HEADER STR0058,STR0059 size 230,090 of odlg pixel
	oList:SetArray(aContrato)
	oList:bLine      := {||{aContrato[oList:nAt,1],aContrato[oList:nAt,2]}}
	oList:blDblClick := {|| lExport,oDlg:End()}

	DEFINE SBUTTON FROM 105, 203 TYPE 1 ACTION (lExport,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oList:nAT,.T.) CENTERED

	dbSelectArea("CN9")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no registro da CN9 selecionado        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(xFilial("CN9")+aContrato[ nOAT, 1 ]+aContrato[ nOAT, 2 ])
EndIf

If lBck
	aHeader:= aHeaderBck
	aCols  := aColsBck
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna area        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)
Return lExport

//-------------------------------------------------------------------
/*/{Protheus.doc} CN090EST()
Estorno do Caução

@author jose.eulalio
@since 27/01/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Function CN090EST(cAlias,nReg,nOpcx)
Local lGeraMov
Local lGeraPA
Local aArea     := GetArea()
Local lRet		:= .F.

//Posiciona atraves do recno do registro selecionado    ³
dbSelectArea("CN8")
CN8->(dbGoTo(nReg))

DbSelectArea("CN3")
DbSetOrder(1)

//Verifica se a Caução já foi baixada
If !Empty(CN8->CN8_DTBX)

	//Posiciona CN3 para verificar o Tipo de Caução
	If CN3->( MsSeek(xFilial('CN3') + CN8->CN8_TPCAUC ) )

		lGeraPA  := (CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI = "1")
		lGeraMov := (CN3->CN3_LIGFIN = "1" .and. CN3->CN3_ABATI # "1")

		//Exclui o titulo de abatimento atual
		If lGeraPA
			CN090ExcPA()
		EndIf

		If lGeraMov
			Processa({|| CN090MvEntr(, .T.)},,STR0020)//Estorna Movimentacao Bancaria de Entrada
		EndIf
	EndIf

	CN090Contab(2)

	RecLock("CN8",.F.)
	CN8->CN8_DTBX 	:= CTOD("  /  /  ")
	CN8->CN8_VLBX 	:= 0
	CN8->CN8_VLEFET	:= 0
	MsUnlock()

	lRet := .T.

Else
	Help( " ",1,"CNTA090BXC") //"Não é possível Estornar uma Caução que não foi baixada"
EndIf

RestArea(aArea)

If lRet
	Aviso( STR0026 , STR0062, { STR0028 }, 1 ) // "Atenção!" //"Operação realizada com sucesso!" //"OK"
EndIf

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} CntCalcRef
Executa somas e subtracoes de quantidade de meses em dados de formato ano/mes
Uso Geral.

@param 	cAnoMes		Referencia ano/mes no formato AAAAMM
@param 	nQtdMeses	Quantidade de meses a ser somado ou subtraido
@param 	nSomaSub	Operacao: 1=Soma, 2=Subtrai

@Return	cRet		Nova referencia ano/mes

@sample
cAnoMes    := '200908'

cNewAnoMes := CntCalcRef( cAnomes, 3 )
// Retorna '200911'

Alert( cNewAnoMes )

Return NIL

@author Marcelo Araujo Dente
@since 26/08/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Function CntCalcRef( cAnoMes, nQtdMeses, nSomaSub )
Local cRet := ''
Local nI   := 0
Local nAno := 0
Local nMes := 0

ParamType 0 Var cAnoMes    As Character Optional Default SubStr( DToS( dDataBase ), 1, 6 )
ParamType 1 Var nQtdMeses  As Numeric   Optional Default 1
ParamType 2 Var nSomaSub   As Numeric   Optional Default 1

nAno := Val(  Left( cAnoMes, 4 ) )
nMes := Val( Right( cAnoMes, 2 ) )

If     nSomaSub == 1  // Soma Meses

	For nI := 1 To nQtdMeses
		nMes++

		If nMes == 13
			nMes := 1
			nAno++
		EndIf
	Next

ElseIf nSomaSub == 2  // Subtrai Meses

	For nI := nQtdMeses To 1 Step -1
		nMes--

		If nMes == 0
			nMes := 12
			nAno--
		EndIf

	Next

EndIf

cRet := StrZero( nAno, 4 ) + StrZero( nMes, 2 )

Return cRet


//-------------------------------------------------------------------
/*/{Protheus.doc} CntPrxData
Executa somas e subtracoes em datas com unidades de dias, meses ou anos
Uso Geral.

@param 	dData		Data de Referencia
@param 	nQuant		Quantidade a ser somado ou subtraido
@param 	nUnidade	Unidade: A=Anos, M=Meses, D=Dias
@param 	nSomaSub	Operacao: 1=Soma, 2=Subtrai

@Return	dRet		Nova Data

@sample

dVar := CntPrxData()
// Retorna o dDataDase somado de um mes

dVar := CntPrxData( CToD( '31/07/09' ) )
// Retorna 31/08/09

dVar := CntPrxData( CToD( '31/08/09' ) )
// Retorna 30/09/09

dVar := CntPrxData( CToD( '31/08/09' ) ,  1, 'A'    )
// Retorna 31/08/10

dVar := CntPrxData( CToD( '30/06/09' ) ,  2         )
// Retorna 30/08/09

dVar := CntPrxData( CToD( '29/02/04' ) ,  2, 'A'    )
// Retorna 28/02/06

dVar := CntPrxData( CToD( '28/02/06' ) ,  2, 'A', 2 )
// Retorna 28/02/04

@author Marcelo Araujo Dente
@since 26/08/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Function CntPrxData( dData, nQuant, cUnidade, nSomaSub )
Local dRet       := ''
Local cNewAnoMes := ''
Local cAnoNovo   := ''
Local cMesNovo   := ''
Local dUltDiaMes := CToD( '  /  /  '  )

ParamType 0 Var dData      As Date      Optional Default dDataBase
ParamType 1 Var nQuant     As Numeric   Optional Default 1
ParamType 2 Var cUnidade   As Character Optional Default 'M'
ParamType 3 Var nSomaSub   As Numeric   Optional Default 1

dRet     := dData
cUnidade := Upper( cUnidade )

If     cUnidade == 'M' .OR. cUnidade == 'A'

	cNewAnoMes  := CntCalcRef( SubStr( DToS( dData ) , 1, 6 ), IIf( cUnidade == 'M', nQuant, nQuant * 12 ), nSomaSub )
	cAnoNovo    := Left(  cNewAnoMes, 4 )
	cMesNovo    := Right( cNewAnoMes, 2 )
	dUltDiaMes  := LastDay( CToD( '01/' + cMesNovo + '/' + cAnoNovo ) )

	If Day( dData ) > Day( dUltDiaMes )
		dRet := dUltDiaMes
	Else
		dRet := SToD( cAnoNovo + cMesNovo + StrZero( Day( dData ), 2 ) )
	EndIf

ElseIf cUnidade == 'D'
	dRet := dData + IIf( nSomaSub == 1, nQuant, nQuant * -1 )

EndIf

Return dRet
