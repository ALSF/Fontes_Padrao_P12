#INCLUDE "PROTHEUS.CH"
#INCLUDE "CNTA060.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA060  ³ Autor ³ Andre Lago            ³ Data ³15.07.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Tipos de Documentos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA060()                                                  ³±±
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
Function CNTA060(nPosArotina,lAutomato)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE cFiltraCN5	:= ""
PRIVATE aRotina		:= MenuDef()
PRIVATE cCadastro		:= OemToAnsi(STR0001)	//"Tipos de Documentos"

DEFAULT nPosArotina := 0
DEFAULT lAutomato   := .F.

If nModulo == 69
	cFiltraCN5 	:= "CN5_MODULO $ 'GCT|AMB'" //Pertence ao GCT e AMBOS
ElseIf nModulo == 6
	cFiltraCN5 	:= "CN5_MODULO $ 'FIN|AMB' .And. CN5_SEQ == '00'" //Pertence ao FIN e AMBOS
EndIf

dbSelectArea("CN5")
CN5->(dbSetFilter({|| &(cFiltraCN5)},cFiltraCN5))
If	nPosArotina > 0
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina,lAutomato)
Else
	mBrowse( 6, 1,22,75,"CN5")
EndIf
CN5->(dbClearFilter())


Return NIL

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CN060Man  ³ Autor ³ Andre Lago            ³ Data ³ 15/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Manutencao Tipo documento                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do Tipo documento                 ³±±
±±³          ³ExpN2: Recno do cabecalho do Tipo documento                 ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CN060Man()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN060Man(cAlias,nReg,nOpc,lAutomato)

Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()

Local cSeek     := ""
Local cWhile    := ""

Local oDlg

Local lContinua := .T.
Local lInclui   := (nOpc == 3)
Local lAltera   := (nOpc == 4)

Local nX        := 0
Local nOpca     := 0
Local nSaveSx8  := GetSx8Len()
Local aCpoGDa   := {'CN5_SEQ','CN5_CODOPC','CN5_DESOPC'} // Vetor responsavel pela montagem da aHeader
Local cFilCN5	  := ""
Local bFilCN5
Local nRecno	  := 0
Local n1Cnt	  := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCols     := {}
Private aHeader   := {}
Private aTELA[0][0],aGETS[0]
Private aYesFields := {}
Private aCampos	:= {}

DEFAULT lAutomato := .F.

dbSelectArea("CN5")
//Salva o filtro atual
cFilCN5 := cFiltraCN5
bFilCN5 := {|| &(cFilCN5)}

If nOpc > Len(aRotina)
	nOpc := 1
Endif

If nOpc == 5
	//Elimina o filtro criado pelo browse
	CN5->(dbClearFilter())

	lContinua := CN060DEL(CN5->CN5_CODIGO)

	//Filtra novamente os registros
	dbSetFilter(bFilCN5,cFilCN5)
Endif

If lContinua
	dbSelectArea("CN5")
	dbSetOrder(4)
	dbSeek(xFilial("CN5")+CN5->CN5_CODIGO+"00",.F.)

	If lInclui
		RegToMemory( "CN5", .T., .F. )
	Else
		If SoftLock("CN5")
			RegToMemory( "CN5", .F., .F. )
		Else
			lContinua := .F.
		EndIf
	EndIf

	dbSelectArea("CN5")
	dbSetOrder(4)

	If lContinua

		// Carrega aHeader
		DbSelectArea("SX3")
		SX3->(DbSetOrder(2)) // Campo
		For nX := 1 to Len(aCpoGDa)
			If SX3->(DbSeek(aCpoGDa[nX]))
				Aadd(aHeader,{ AllTrim(X3Titulo()),;
							GetSx3Cache(aCpoGDa[nX],'X3_CAMPO')		,;
							GetSx3Cache(aCpoGDa[nX],'X3_PICTURE')	,;
							GetSx3Cache(aCpoGDa[nX],'X3_TAMANHO')	,;
							GetSx3Cache(aCpoGDa[nX],'X3_DECIMAL')	,;
							GetSx3Cache(aCpoGDa[nX],'X3_VALID')		,;
							GetSx3Cache(aCpoGDa[nX],'X3_USADO')		,;
							GetSx3Cache(aCpoGDa[nX],'X3_TIPO')		,;
							GetSx3Cache(aCpoGDa[nX],'X3_F3')		,;
							GetSx3Cache(aCpoGDa[nX],'X3_CONTEXT')	,;
							GetSx3Cache(aCpoGDa[nX],'X3_CBOX')		,;
							GetSx3Cache(aCpoGDa[nX],'X3_RELACAO')})
			Endif
		Next nX

		If !lInclui
			cSeek  := xFilial("CN5")+M->CN5_CODIGO
			cWhile := "CN5->CN5_FILIAL+CN5->CN5_CODIGO"
	        nRecno := CN5->(Recno())
			// Carregue aqui a Montagem da sua aCol
			aAux := {}
			dbSelectArea("CN5")
			//Elimina o filtro criado pelo browse
			EndFilBrw("CN5")
			dbSetOrder(4)
			dbSeek(cSeek,.F.)
			While CN5->(!eof()) .and. cSeek == &cWhile
				aAux := {}
				If CN5->CN5_SEQ == "00"
					CN5->(dbSkip())
					Loop
				EndIf
				For nX := 1 to Len(aCpoGDa)
					dbSelectArea("SX3")
					SX3->(DbSetOrder(2)) // Campo
					If DbSeek(aCpoGDa[nX])
						If GetSx3Cache(aCpoGDa[nX],'X3_CONTEXT') == "V"
							nRecno := CN5->(recno())
							Aadd(aAux,Posicione("CN5",1,xFilial("CN5")+CN5->CN5_CODOPC+"00","CN5_DESCRI"))
							CN5->(dbGoTo(nRecno))
						Else
							Aadd(aAux,CN5->&(GetSx3Cache(aCpoGDa[nX],'X3_CAMPO')))
						EndIf
					EndIf
				Next nX
				Aadd(aAux,.F.)
				Aadd(aCols,aAux)
				dbSelectArea("CN5")
		   	dbSkip()
			Enddo
			//Filtra novamente os registros
		  	dbSetFilter(bFilCN5,cFilCN5)
         	dbGoTo(nRecno)
		Endif

		If Empty(aCols)
			aAux := {}
			For nX := 1 to Len(aCpoGDa)
				dbSelectArea("SX3")
				SX3->(DbSetOrder(2)) // Campo
				If DbSeek(aCpoGDa[nX])
					Aadd(aAux,CriaVar(AllTrim(GetSx3Cache(aCpoGDa[nX],'X3_CAMPO'))))
				Endif
			Next nX
			Aadd(aAux,.F.)
			Aadd(aCols,aAux)
			aCols[1][aScan(aHeader,{|x| Trim(x[2])=="CN5_SEQ"})] := StrZero(1,Len(CN5->CN5_SEQ))
		Endif
		If	lAutomato
			If	nOpc == 5
				nOpca := 1
			ElseIf	FindFunction("GetParAuto")
				aRetAuto := GetParAuto("CNTA060TESTCASE")
				M->CN5_CODIGO := aRetAuto[1,1,2]
				M->CN5_DESCRI := aRetAuto[1,2,2]
				M->CN5_IMPFIN := aRetAuto[1,3,2]
				M->CN5_MODULO := aRetAuto[1,4,2]
				M->CN5_EMAIL  := aRetAuto[1,5,2]
				If	Len(aRetAuto[2])>0
					aCols:={}
					For nX := 1 To Len(aRetAuto[2])
						AAdd(aCols,Array(Len(aHeader)+1))
						For n1Cnt := 1 To Len(aRetAuto[2,nX])

							nSeek := ASCan(aHeader,{|x| AllTrim(x[2])==aRetAuto[2,nX,n1Cnt,1]})

							aCols[Len(aCols),nSeek]:=aRetAuto[2,nX,n1Cnt,2]
						Next
						aCols[Len(aCols)][Len(aHeader)+1] := .F.
					Next
				EndIf
				nOpca := 1
			EndIf
		Else

			aObjects := {}
			AAdd( aObjects, { 100, 100, .t., .t. } )
			AAdd( aObjects, { 100, 100, .t., .t. } )

			aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
			aPosObj := MsObjSize( aInfo, aObjects )

			aCampos := { "CN5_CODIGO", "CN5_DESCRI", "CN5_IMPFIN", "CN5_MODULO", "CN5_EMAIL" }
			
		 	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL
				EnChoice( "CN5", nReg, nOpc,,,,aCampos,aPosObj[1], , 3, , , , , ,.F. )
				oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(!lInclui.And.!lAltera,0,GD_INSERT+GD_UPDATE+GD_DELETE),"CN060LinOk()","CN060TudOk()","+CN5_SEQ",/*alteraveis*/,/*freeze*/,4096,/*fieldok*/,/*superdel*/,/*delok*/,,aHeader,aCols)

			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,aCols:=oGetD:aCols,If(Obrigatorio(aGets,aTela) .And. oGetD:TudoOk(),oDlg:End(), nOpca :=  0 )},{|| nOpca := 2,oDlg:End()})
		EndIf

		If nOpca == 1
			EndFilBrw("CN5")
			Begin Transaction
				lGravou := CN060Grava(nOpc-2,aCols,aHeader)

				If ( lGravou )
					EvalTrigger()
					While (GetSx8Len() > nSaveSx8)
						ConfirmSx8()
					EndDo
				EndIf

			End Transaction

			dbSetFilter(bFilCN5,cFilCN5)

			While (GetSx8Len() > nSaveSx8)
				RollBackSx8()
			EndDo

			MsUnlockAll()
		Else
			While (GetSx8Len() > nSaveSx8)
				RollBackSx8()
			EndDo
		Endif
	Endif

Endif

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CN060Grava³ Autor ³ Andre Lago            ³ Data ³ 15/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Gravacao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do Tipo de Documento              ³±±
±±³          ³ExpN2: Recno do cabecalho do Tipo de Documento              ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CN060Grava()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function CN060Grava(nOpcao,aCols,aHeader)

Local aArea     := GetArea()
Local bCampo 	:= {|nCPO| Field(nCPO) }
Local lGravou   := .F.
Local lOk		:= .T.
Local ni        := 0
Local nX        := 0
Local nY        := 0
Local lContinua := .F.
Local nPosOpc	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="CN5_CODOPC"})
Local nPosSeq	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="CN5_SEQ"})

Do Case
Case nOpcao <> 3

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava o Cabecalho                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CN5")
	dbSetOrder(4)		//CN5_FILIAL+CN5_CODIGO+CN5_SEQ
	If MsSeek(xFilial("CN5")+M->CN5_CODIGO)
		RecLock("CN5",.F.)
	Else
		RecLock("CN5",.T.)
	EndIf
	For nX := 1 TO FCount()
		FieldPut(nX,M->&(EVAL(bCampo,nX)))
	Next nX
	CN5->CN5_FILIAL := xFilial("CN5")
	CN5->CN5_CODOPC := ""
	CN5->CN5_SEQ    := "00"

	CN5->(FkCommit())

	lContinua := .F.
	For nX := 1 To Len(aCols)
		If !Empty(aCols[nX][nPosOpc])
			lContinua := .T.
		Endif
	Next nX

	If lContinua

		dbSelectArea("CN5")

		For nX := 1 To Len(aCols)

			If !aCols[nX,Len(aCols[nX])]

				If !Empty(aCols[nX][nPosOpc])
					If CN5->(dbSeek(xFilial("CN5")+M->CN5_CODIGO+aCols[nX][nPosSeq]))
						RecLock("CN5",.F.)
					Else
						RecLock("CN5",.T.)
					EndIf
				Endif

				For ni := 1 TO FCount()
					FieldPut(ni,M->&(EVAL(bCampo,ni)))
				Next ni

				For nY := 1 To Len(aHeader)
					If ( aHeader[nY][10] != "V" )
						CN5->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
					EndIf
				Next nY
				CN5->CN5_FILIAL := xFilial("CN5")
				MsUnLock()

			Else

				dbSelectArea("CN5")
				If !Empty(aCols[nX][nPosOpc])
					If CN5->(dbSeek(xFilial("CN5")+M->CN5_CODIGO+aCols[nX][nPosSeq]))
						RecLock("CN5")
						dbDelete()
						MsUnlock()
					Endif
				EndIf

			Endif

		Next nX

	Endif

	lGravou := .T.

OtherWise

	If lOk

		lContinua := .F.
		For nX := 1 To Len(aCols)
			If !Empty(aCols[nX][nPosOpc])
				lContinua := .T.
			Endif
		Next nX

		If lContinua

			dbSelectArea("CN5")
			For nX := 1 To Len(aCols)
				If !Empty(aCols[nX][nPosOpc])
					If CN5->(dbSeek(xFilial("CN5")+M->CN5_CODIGO+aCols[nX][nPosSeq]))
						RecLock("CN5")
						dbDelete()
						MsUnlock()
					EndIf
				Endif
			Next nX

	    Endif

		If CN5->(dbSeek(xFilial("CN5")+M->CN5_CODIGO+"00"))
			RecLock("CN5",.F.)
			dbDelete()
			MsUnlock()
		EndIf

		lGravou := .T.
	EndIf

EndCase

RestArea(aArea)

Return(lGravou)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CN060LinOk³ Autor ³Andre Lago             ³ Data ³15/07/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da Linha Ok da Getdados do desmembramento do      ³±±
±±³          ³Tipo de Documento                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a linha e valida                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao da linhaOk³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN060LinOk()

Local lRet     := .T.

If M->CN5_CODIGO == aCols[n][aScan(aHeader,{|x| Trim(x[2])=="CN5_CODOPC"})]
	Help(" ",1,"CA060DOC1")		//"Tipo de Documento não pode ser opcional dele mesmo!"##"Informe outro código como opcional."
	lRet := .F.
EndIf
//reset na variavel para nao duplicar na browse
IIf(!Empty(M->CN5_CODOPC),M->CN5_CODOPC := "",.F.)

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CN060TudOk³ Autor ³Andre Lago             ³ Data ³15/07/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da TudoOk da Getdados do desmembramento do tipo de³±±
±±³          ³documento                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se todos os itens sao validos                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao da TudoOk ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN060TudOk()

Local lRet     := .T.
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN060DEL ³ Autor ³ Marcelo Custodio      ³ Data ³06.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da exclusao do tipo de documento                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN060DEL()                                                 ³±±
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
Function CN060DEL()

Local lRet := .T.
Local nRecno 	:= Recno()
Local aArea    := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida a existencia do registro na amarracao                             ³
//³Tipo de Documento X Tipo de Contrato X Situacao                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNJ")
dbSetOrder(3)//Tipo de Documento

lRet := !(MsSeek(xFilial('CNJ')+CN5->CN5_CODIGO, .F.))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida a existencia do registro no cadastro de documentos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if lRet
	dbSelectArea("CNK")
	dbSetOrder(2)//Tipo de Documento
	lRet := !(MsSeek(xFilial('CNK')+CN5->CN5_CODIGO, .F.))
EndIf

If lRet
	dbSelectArea("CN5")
	dbSetOrder(3)		//CN5_FILIAL+CN5_CODOPC
	lRet := !(MsSeek(xFilial('CN5')+CN5->CN5_CODIGO, .F.))
	dbGoTo(nRecno)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida a existencia do registro no cadastro de amarração entre doc x evento	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	dbSelectArea("FR9")
	dbSetOrder(2)		//FR9_FILIAL+FR9_DOCUM+FR9_EVENTO
	lRet := !(MsSeek(xFilial('FR9')+CN5->CN5_CODIGO, .F.))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida a existencia de titulos a pagar vinculados ao tipo de documento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	dbSelectArea("FRD")
	dbSetOrder(2)
	lRet := !(MsSeek(xFilial('FRD')+CN5->CN5_CODIGO, .F.))
EndIf

If !lRet
	Help( " ", 1, "CNTA060_01" )
Endif

RestArea(aArea)

return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³05/10/2006³±±
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
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     		  ³±±
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

Private aRotina	:= {}

Aadd( aRotina, {STR0004	,"AxPesqui" , 0 , 1,0,.F.  } )	//"Pesquisar"
Aadd( aRotina, {STR0005	,"CN060Man" , 0 , 2,0,nil  } )	//"Visualizar"
Aadd( aRotina, {STR0006	,"CN060Man" , 0 , 3,0,nil  } )	//"Incluir"
Aadd( aRotina, {STR0007	,"CN060Man" , 0 , 4,0,nil  } )	//"Alterar"
Aadd( aRotina, {STR0008	,"CN060Man" , 0 , 5,3,nil  } )	//"Excluir"

Return (aRotina)