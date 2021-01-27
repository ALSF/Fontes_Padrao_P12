#INCLUDE "PROTHEUS.CH"
#INCLUDE "CNTA062.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA062  ³ Autor ³ Andre Lago            ³ Data ³19.07.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Amarracao Documentos X Situacao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA062()                                                  ³±±
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
Function CNTA062()

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

PRIVATE aRotina 	:= MenuDef()
PRIVATE cCadastro 	:= STR0001		//"Amarração Tipo de Documentos X Situação"

mBrowse( 6, 1,22,75,"FR9")

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CN062Man  ³ Autor ³ Andre Lago            ³ Data ³ 15/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Manutencao Tipo documento                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do Tipo documento                 ³±±
±±³          ³ExpN2: Recno do cabecalho do Tipo documento                 ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CN062Man()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA062                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN062Man(cAlias,nReg,nOpc)

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
Local aCpoGDa   := {'FR9_DOCUM','FR9_DESCRI'} // Vetor responsavel pela montagem da aHeader


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCols     := {}
Private aHeader   := {}
Private aTELA[0][0],aGETS[0]
Private aYesFields := {}
Private aCampos	:= {}

If nOpc > Len(aRotina)
	nOpc := 1
Endif

If nOpc == 5
	lContinua := CN062DEL(FR9->FR9_EVENTO)
Endif

If lContinua
	dbSelectArea("FR9")
	dbSetOrder(1)
	dbSeek(xFilial("FR9")+FR9->FR9_EVENTO,.F.)

	If lInclui
		RegToMemory( "FR9", .T., .F. )
	Else
		If SoftLock("FR9")
			RegToMemory( "FR9", .F., .F. )
		Else
			lContinua := .F.
		EndIf
	EndIf

	dbSelectArea("FR9")
	dbSetOrder(1)

	If lContinua

		// Carrega aHeader
		DbSelectArea("SX3")
		SX3->(DbSetOrder(2)) // Campo
		For nX := 1 to Len(aCpoGDa)
			If SX3->(DbSeek(aCpoGDa[nX]))
				Aadd(aHeader,{ AllTrim(X3Titulo()),;
							GetSx3Cache(aCpoGDa[nX],'X3_CAMPO')			,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_PICTURE')	,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_TAMANHO')	,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_DECIMAL')	,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_VALID')	,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_USADO')	,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_TIPO')		,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_F3')		,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_CONTEXT')	,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_CBOX')		,;
							GetSx3Cache(aCpoGDa[nX],'SX3->X3_RELACAO')})
			Endif
		Next nX

		If !lInclui
			cSeek  := xFilial("FR9")+M->FR9_EVENTO
			cWhile := "FR9->FR9_FILIAL+FR9->FR9_EVENTO"
         	nRecno := FR9->(Recno())
			// Carregue aqui a Montagem da sua aCol
			aAux := {}
			dbSelectArea("FR9")
			dbSetOrder(1)
			dbSeek(cSeek,.F.)
			While !eof() .and. cSeek == &cWhile
				aAux := {}
				For nX := 1 to Len(aCpoGDa)
					dbSelectArea("SX3")
					SX3->(DbSetOrder(2)) // Campo
					If DbSeek(aCpoGDa[nX])
						If GetSx3Cache(aCpoGDa[nX],'X3_CONTEXT') == "V"
							Aadd(aAux,Posicione("CN5",1,xFilial("CN5")+FR9->FR9_DOCUM+"00","CN5_DESCRI"))
						Else
							Aadd(aAux,FR9->&(GetSx3Cache(aCpoGDa[nX],'SX3->X3_CAMPO')))
						EndIf
					EndIf
				Next nX
				Aadd(aAux,.F.)
				Aadd(aCols,aAux)
				dbSelectArea("FR9")
				dbSkip()
			Enddo
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
		Endif

		aObjects := {}
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )

		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )

		aCampos := {"FR9_FILIAL","FR9_DOCUM","FR9_DESCRI"}

	 	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL
			EnChoice( "FR9", nReg, nOpc,,,,aCampos,aPosObj[1], , 3, , , , , ,.F. )
			oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(!lInclui.And.!lAltera,0,GD_INSERT+GD_UPDATE+GD_DELETE),"CN062LinOk()","CN062TudOk()","",/*alteraveis*/,/*freeze*/,4096,/*fieldok*/,/*superdel*/,/*delok*/,,aHeader,aCols)

		//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,aCols:=oGetD:aCols,If(Obrigatorio(aGets,aTela) .And. oGetD:TudoOk(),oDlg:End(), nOpca :=  0 )},{|| nOpca := 2,oDlg:End()})
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF(CN062LinOk() .And. CN062TudOk(),(nOpca:=1,aCols:=oGetD:aCols,oDlg:End()),) },{|| nOpca := 2,oDlg:End() }) CENTERED
		If nOpca == 1
			Begin Transaction
				lGravou := CN062Grava(nOpc-2,aCols,aHeader)

				If ( lGravou )
					EvalTrigger()
					While (GetSx8Len() > nSaveSx8)
						ConfirmSx8()
					EndDo
				EndIf

			End Transaction

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
±±³Fun‡…o    ³CN062Grava³ Autor ³ Andre Lago            ³ Data ³ 15/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Gravacao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do Tipo de Documento              ³±±
±±³          ³ExpN2: Recno do cabecalho do Tipo de Documento              ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CN062Grava()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA062                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function CN062Grava(nOpcao,aCols,aHeader)

Local aArea     := GetArea()
Local bCampo 	:= {|nCPO| Field(nCPO) }
Local lGravou   := .F.
Local lOk		:= .T.
Local ni        := 0
Local nX        := 0
Local nY        := 0
Local lContinua := .F.
Local lAchou	:= .F.
Local nPosDoc	:= 0
Local lIgual	:= .F.

nPosDoc := aScan(aHeader,{|aCpos| AllTrim(aCpos[2])=="FR9_DOCUM"})

Do Case
Case nOpcao <> 3

	lContinua := .F.
	For nX := 1 To Len(aCols)
		If !Empty(aCols[nX][nPosDoc])
			lContinua := .T.
		Endif
	Next nX

	If lContinua

		dbSelectArea("FR9")
		dbSetOrder(1)		//FR9_FILIAL+FR9_EVENTO+FR9_DOCUM
		dbGoTop()

		//Verifica se o registro no aCols foi alterado para entao deletar o original no banco e incluir o novo depois
		If dbSeek(xFilial("FR9")+M->FR9_EVENTO)
			While !EoF() .And. FR9->FR9_EVENTO == M->FR9_EVENTO
				For nX := 1 To Len(aCols)
					If FR9->FR9_DOCUM == aCols[nX][nPosDoc]
						lAchou := .T.		//O registro no aCols se mantem inalterado
					EndIf
				Next nX
				If !lAchou		//O registro no aCols foi alterado
					RecLock("FR9",.F.)
					dbDelete()
					MsUnLock()
				EndIf
				lAchou := .F.
				dbSkip()
			End
		EndIf

		For nX := 1 To Len(aCols)

			If !aCols[nX,Len(aCols[nX])]

				If !Empty(aCols[nX][nPosDoc])
					If dbSeek(xFilial("FR9")+M->FR9_EVENTO+aCols[nX][nPosDoc])
						RecLock("FR9",.F.)
					Else
						RecLock("FR9",.T.)
					EndIf
				Endif

				For ni := 1 TO FCount()
					FieldPut(ni,M->&(EVAL(bCampo,ni)))
				Next ni

				For nY := 1 To Len(aHeader)
					If ( aHeader[nY][10] != "V" )
						FR9->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
					EndIf
				Next nY
				FR9->FR9_FILIAL := xFilial("FR9")
				MsUnLock()

			Else

				For nY := 1 To Len(aCols)
					If !aCols[nY,Len(aHeader)+1] .And. (aCols[nX][nPosDoc] == aCols[nY][nPosDoc])
						lIgual := .T.
					EndIf
				Next nY

				If !lIgual
					dbSelectArea("FR9")
					dbSetOrder(1)		//FR9_FILIAL+FR9_EVENTO+FR9_DOCUM
					If dbSeek(xFilial("FR9")+M->FR9_EVENTO+aCols[nX][nPosDoc])
						RecLock("FR9")
						dbDelete()
						MsUnlock()
					EndIf
				EndIf

			Endif

		Next nX

	Endif

	lGravou := .T.

OtherWise

	If lOk

		lContinua := .F.
		For nX := 1 To Len(aCols)
			If !Empty(aCols[nX][nPosDoc])
				lContinua := .T.
			Endif
		Next nX

		If lContinua

			dbSelectArea("FR9")
			For nX := 1 To Len(aCols)
				If !Empty(aCols[nX][nPosDoc])
					If dbSeek(xFilial("FR9")+M->FR9_EVENTO+aCols[nX][nPosDoc])
						RecLock("FR9")
						dbDelete()
						MsUnlock()
					EndIf
				Endif
			Next nX

	    Endif

		lGravou := .T.
	EndIf

EndCase

RestArea(aArea)

Return(lGravou)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CN062LinOk³ Autor ³Andre Lago             ³ Data ³15/07/2010³±±
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
Function CN062LinOk()

Local lRet		:= .T.
Local nCont		:= 0
Local nI		:= 0
Local nPosDoc	:= 0

nPosDoc := ASCAN(oGetD:aHeader, {|aCpos| AllTrim(aCpos[2]) == "FR9_DOCUM"})

If (nPosDoc > 0)
	For nI := 1 To Len(oGetD:aCols)
		If !oGetD:aCols[nI][Len(oGetD:aHeader)+1]
			If Empty(AllTrim(oGetD:aCols[nI][nPosDoc]))
				Help(" ",1,"CA062DOC3")		//"Código do documento não informado."##"Informe o código do documento."
				lRet := .F.
				Exit
			ElseIf (nI != oGetD:nAt) .And. (AllTrim(oGetD:aCols[nI][nPosDoc]) == AllTrim(oGetD:aCols[oGetD:nAt][nPosDoc]));
					 .And. !oGetD:aCols[oGetD:nAt][Len(oGetD:aHeader)+1]
				Help(" ",1,"CA062DOC1")		//"Codigo de documento ja cadastrado, não permitido."##"Informe um código diferente."
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next nI
EndIf

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CN062TudOk³ Autor ³Andre Lago             ³ Data ³15/07/2010³±±
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
Function CN062TudOk()

Local lRet     := .T.

If Empty(AllTrim(M->FR9_EVENTO))
	lRet := .F.
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN062DEL ³ Autor ³ Marcelo Custodio      ³ Data ³06.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da exclusao do tipo de documento                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN062DEL()                                                 ³±±
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
Function CN062DEL()

Local lRet 		:= .T.

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
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     	  ³±±
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

Aadd( aRotina, {STR0012	,"AxPesqui"  , 0 , 1,0,.F.  } )		//Pesquisar
Aadd( aRotina, {STR0013	,"CN062Man"  , 0 , 2,0,nil  } )		//Visualizar
Aadd( aRotina, {STR0014	,"CN062Man"  , 0 , 3,0,nil  } )		//Incluir
Aadd( aRotina, {STR0015	,"CN062Man"  , 0 , 4,0,nil  } )		//Alterar
Aadd( aRotina, {STR0016	,"CN062Man"  , 0 , 5,3,nil	} )		//Excluir

Return (aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³CN062NecDocs  ³ Autores ³ Andre Lago        ³ Data ³20/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por permitir a selecao dos documentos nece³±±
±±³           ³ ssarios ao titulos                                           ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN062NecDocs()

Local lRet 			:= .T.
Local aArea			:= GetArea()
Local cVar			:= Nil
Local cTitulo		:= ""
Local lMark			:= .F.
Local oOk			:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo			:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk			:= Nil
Local nChk        	:= 0
Local ni			:=1

Private lChk		:= .F.
Private oLbxDoc		:= Nil
Private oDocs		:= Nil
Private aVetor		:= {}

dbSelectArea("CN5") //Tabela de Validacoes da Contrato e Cliente
dbSetOrder(4)
dbGoTop()

//Carrega os Documentos.
aVetor    := {}
nRecno    := 0

While !eof()
	If (CN5->CN5_MODULO $ "FIN|AMB|") .AND. (CN5->CN5_SEQ == "00")
		aAdd(aVetor,{lMark,CN5_CODIGO,CN5_DESCRI})
	EndIf
	dbSkip()
EndDo

//Traz marcados os documentos ja vinculados ao titulo
dbSelectArea("FRD")
dbSetOrder(1)		//FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD_FORNEC+FRD_LOJA+FRD_DOCUM
dbGoTop()
aEval(aVetor,{|aDocs| IIF(FRD->(dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+aDocs[2])),aDocs[1] := .T.,) })

If Len(aVetor) > 0
	cTitulo := STR0004		//"Relação de Documentos"
	DEFINE MSDIALOG oDocs TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER " ", STR0005, STR0006 ; //"Codigo"##"Descricao";
	SIZE 230,095 OF oDocs PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),aVetor[oLbx:nAt,2],aVetor[oLbx:nAt,3]}}
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDocs:End() ENABLE OF oDocs
	ACTIVATE MSDIALOG oDocs CENTER

	nChk := 0
	For ni:=1 to len(aVetor)
		If aVetor[ni,1]
			nChk++
		EndIf
	Next

	If nChk == 0
		//MsgInfo(STR0007,STR0003)		//"Obrigatório escolher pelo menos um Documento!"##"Atenção"
		Help(" ",1,"CA062DOC2")		//"Documento não escolhido."##"Obrigatório escolher pelo menos um documento."
		lRet := .F.
	EndIf

	If lRet
		CN062GravDocs(aVetor)
	EndIf

Else

	//Help( " ", 1, "F50NODOCS",,"Não existem documentos cadastrados para relacionamento.",1)
	//Help( " ", 1, "F50NODOCS",,STR0011,1)
	Help( " ", 1, "F50NODOCS",,,1)
	lRet := .F.
	M->E2_TEMDOCS := '2'

Endif

RestArea(aArea)
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN062GravDocs  ºAutor  ³Microsiga      º Data ³  07/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava os documentos do titulo                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN062GravDocs(aVetor)

Local aArea		:= GetArea()
Local ni		:= 1
Local lGrava	:= .F.

dbSelectArea("FRD")
dbSetOrder(1)			//FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD_FORNEC+FRD_LOJA+FRD_DOCUM
dbGoTop()

For ni := 1 to len(aVetor)
	If dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+aVetor[ni,2])
		If aVetor[ni,1]		//Se o documento ja estava vinculado e continua marcado, grava a alteracao
			lGrava := .F.
			Loop
		Else				//Se o documento ja estava vinculado e foi desmarcado, apaga o vinculo
			RecLock("FRD",.F.)
			dbDelete()
			MsUnLock()
			lGrava := .F.
		EndIf
	Else
		If aVetor[ni,1]		//Se o documento nao estava vinculado e foi marcado, grava a inclusao
			RecLock("FRD",.T.)
			lGrava := .T.
		Else
			lGrava := .F.
			Loop
		EndIf
	EndIf
	If lGrava
		FRD->FRD_FILIAL 	:= xFilial("SE2")
		FRD->FRD_PREFIX 	:= E2_PREFIXO
		FRD->FRD_NUM   		:= E2_NUM
		FRD->FRD_PARCEL 	:= E2_PARCELA
		FRD->FRD_TIPO 		:= E2_TIPO
		FRD->FRD_FORNEC 	:= E2_FORNECE
		FRD->FRD_LOJA 		:= E2_LOJA
		FRD->FRD_DOCUM 		:= aVetor[ni,2]
		FRD->FRD_RECEB 		:= "2"
		MsUnLock()
	EndIf
Next ni

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN062ApagDocs  ºAutor  ³Microsiga      º Data ³  07/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apaga documentos quando da exclusao do titulo.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN062ApagDocs(aFatCan)

Local aArea := GetArea()
Local nX	:= 0

dbSelectArea("FRD")
dbSetOrder(1)		//FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD_FORNEC+FRD_LOJA+FRD_DOCUM
//Verifica se o titulo a cancelar é uma fatura
If aFatCan != NIL
	For nX := 1 To Len(aFatCan)
		If dbSeek(aFatCan[nX,1]+aFatCan[nX,2]+aFatCan[nX,3]+aFatCan[nX,4]+aFatCan[nX,5]+aFatCan[nX,6]+aFatCan[nX,7])
			While !EoF() .And. (aFatCan[nX,1]+aFatCan[nX,2]+aFatCan[nX,3]+aFatCan[nX,4]+aFatCan[nX,5]+aFatCan[nX,6]+aFatCan[nX,7]) == FRD->(FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD->FRD_FORNEC+FRD_LOJA)
				RecLock("FRD",.F.)
				dbDelete()
				MsUnLock()
				dbSkip()
			End
		EndIf
	Next nX
Else
	dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
	While !eof() .and. (xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)) == FRD->(FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD->FRD_FORNEC+FRD_LOJA)
		RecLock("FRD",.F.)
		dbDelete()
		MsUnLock()
		dbSkip()
	EndDo
EndIf

RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN062ValDocs   ºAutor  ³Microsiga      º Data ³  07/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida as movimentacoes financeiras dos titulos com relacaoº±±
±±º          ³ aos documentos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function CN062ValDocs(cFuncao,lAuto,lEmail,lTodos,lPrimeiro)

Local aArea 	:= {}
Local aAreaSE2	:= {}
Local lRet	   	:= .T.
Local aDocs		:= {}
Local ni		:= 1
Local nPos		:= 0
Local nPosOpc	:= 0
Local lFalNImp	:= .F.
Local lFalImp	:= .F.
Local lEnvia	:= .F.
Local aDados	:= {}		//Array com o texto da mensagem do e-mail
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios

Default lAuto	:= .F.
Default lEmail	:= .F.
Default lTodos	:= .F.
Default lPrimeiro:=.F. //indica se deve mostrar help

If lFinVDoc

	aArea := GetArea()

	If Select("SE2") > 0
		aAreaSE2 := SE2->(GetArea())
	EndIf

	If SE2->E2_TEMDOCS == "1" //Se necessita documentos

		//Monta array com os documentos necessarios.
		dbSelectArea("FR9")
		dbSetOrder(1)
		dbSeek(xFilial("FR9")+cFuncao)
		While !eof() .and. cFuncao == FR9->FR9_EVENTO
			aAdd(aDocs,{FR9->FR9_DOCUM,{},.F.,.F.,.F.})    //documento, opcionais, email, impede fin, recebido
			dbSelectArea("FR9")
			dbSkip()
		EndDo

		If Len(aDocs) > 0
			// Complementa as informacoes dos documentos.
			For ni:=1 to Len(aDocs)
				dbSelectArea("CN5")
				dbSetOrder(4)		//CN5_FILIAL+CN5_CODIGO+CN5_SEQ
				dbSeek(xFilial("CN5")+aDocs[ni][1])
				While !eof() .and. CN5->CN5_CODIGO == aDocs[ni][1]
					If CN5->CN5_SEQ == "00"
						aDocs[ni][3] := (CN5->CN5_EMAIL == "1")
						aDocs[ni][4] := (CN5->CN5_IMPFIN == "1")
					Else
						aAdd(aDocs[ni][2],CN5->CN5_CODOPC)
					EndIf
					dbSelectArea("CN5")
					dbSkip()
				EndDo
			Next

	      	// Complementa array com os documentos apontados no titulo.
			dbSelectArea("FRD")
			dbSetOrder(1)			//FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD_FORNEC+FRD_LOJA+FRD_DOCUM
			dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
			While !eof() .and. (xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)) == FRD->(FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD->FRD_FORNEC+FRD_LOJA)
				nPos := 0
				nPosOpc	:= 0
				nPos := ASCAN(aDocs,{|x| x[1] == FRD->FRD_DOCUM})
				If nPos == 0
					For ni:=1 to Len(aDocs)
						nPosOpc := aScan(aDocs[ni][2],{|x| x == FRD->FRD_DOCUM})
						If nPosOpc <> 0
							If !aDocs[ni][5]
								aDocs[ni][5] := (FRD->FRD_RECEB == "1")
							EndIf
						EndIf
			      Next
				ElseIf !aDocs[nPos][5]
					aDocs[nPos][5] := (FRD->FRD_RECEB == "1")
				EndIf
				dbSelectArea("FRD")
				dbSkip()
			EndDo

			For ni:=1 to Len(aDocs)
				//	Impede Financeiro este com SIM e o parâmetro MV_CTLIPAG esteja com .T., o sistema não irá permitir que o título seja liberado pelo processo Liberação P/ Baixa.
				//	Impede Financeiro este com SIM e o parâmetro MV_CTLIPAG esteja com .F., o sistema não irá permitir que o título seja baixado por nenhum processo considerado como baixa do título (cheque, borderô, baixa manual, baixa automática). Para os processos onde são gerados novos títulos baseados em outros, tais como Liquidação e Fatura, o(s) documento(s) atrelado(s) será(ão) transferido(s) para os novos.
				//	Impede Financeiro este com NÃO e o parâmetro MV_CTLIPAG esteja com .T., o sistema irá permitir que o título seja liberado pelo processo Liberação P/ Baixa, contudo estará gerando mensagem na tela alertado o usuário da falta do(s) documento(s) e caso o campo Envia e-mail esteja com SIM enviará um e-mail para o gestor financeiro.
				//	Impede Financeiro este com NÃO e o parâmetro MV_CTLIPAG esteja com .F., o sistema irá permitir que o título seja baixado por qualquer processo considerado como baixa do título (cheque, borderô, baixa manual, baixa automática). Para os processos onde são gerados novos títulos baseados em outros, tais como Liquidação e Fatura, o(s) documento(s) atrelado(s) será(ão) transferido(s) para os novos.
				If aDocs[ni][4]
					If !aDocs[ni][5]
						lRet := .F.
					EndIf
				Else
					If !aDocs[ni][5]
						lFalNImp := .T.
						If aDocs[ni][3]
							lEnvia := .T.
							AADD(aDados,AllTrim(cFuncao))		//Funcao
							AADD(aDados,AllTrim(aDocs[ni][1]))		//Documento
							AADD(aDados,AllTrim(Posicione("CN5",1,xFilial("CN5")+aDocs[ni][1]+"00","CN5_DESCRI")))		//Descricao do documento
							AADD(aDados,SE2->E2_FILIAL)		//Filial
							AADD(aDados,SE2->E2_PREFIXO)		//Prefixo
							AADD(aDados,SE2->E2_NUM)		//Numero
							AADD(aDados,SE2->E2_PARCELA)		//Parcela
							AADD(aDados,SE2->E2_TIPO)		//Tipo
							AADD(aDados,SE2->E2_FORNECE)		//Fornecedor
							AADD(aDados,SE2->E2_LOJA)		//Loja
						EndIf
					EndIf
				EndIf
			Next

			If !lAuto .And. !lEmail .And. !lRet .And. !lTodos
				Help(" ",1,"CN062NODOC")		//"Exite(m) documento(s) não apresentado(s) para o(s) título(s)."##"Não é permitida a liberação / movimentação do(s) título(s)."
			ElseIf !lAuto .And. !lEmail .And. lFalNImp .And. !lTodos
				Help(" ",1,"CN062DOC")		//"Exite(m) documento(s) não apresentado(s) para o(s) título(s)."
			ElseIf lPrimeiro  .and. !lEmail .and. lFalNImp // veio de lote ou automatico. Só mostrará o help uma vez
				lPrimeiro:=.F.
				Help(" ",1,"CN062DOC")		//"Exite(m) documento(s) não apresentado(s) para o(s) título(s)."
			ElseIf lPrimeiro  .and. !lEmail .and. !lRet// veio de lote ou automatico. Só mostrará o help uma vez.
				lPrimeiro:=.F.
				Help(" ",1,"CN062NODOC")		//"Exite(m) documento(s) não apresentado(s) para o(s) título(s)."##"Não é permitida a liberação / movimentação do(s) título(s)."
			EndIf

			If lRet .And. lEmail .And. lEnvia
				If !Empty(aDados)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Envia e-mail do Evento 048                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MEnviaMail("048",aDados,,,,.T.)
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSE2)
	RestArea(aArea)

EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN062GrvFat   ºAutor  ³Microsiga       º Data ³  07/24/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava os documentos de faturas e                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Function CN062GrvFat(aDocsOri,aDocsDes)

Local aArea := GetArea()
Local nx 	:= 1
Local ny 	:= 1
Local aDocs := {}

dbSelectArea("FRD")
dbSetOrder(1)

For nx:=1 to len(aDocsOri)

	dbSeek(aDocsOri[nx,1]+aDocsOri[nx,2]+aDocsOri[nx,3]+aDocsOri[nx,4]+aDocsOri[nx,5]+aDocsOri[nx,6]+aDocsOri[nx,7])
	While !eof() .and. aDocsOri[nx,1]+aDocsOri[nx,2]+aDocsOri[nx,3]+aDocsOri[nx,4]+aDocsOri[nx,5]+aDocsOri[nx,6]+aDocsOri[nx,7] == FRD->(FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD->FRD_FORNEC+FRD_LOJA)
		aAdd(aDocs,{FRD->FRD_DOCUM,FRD->FRD_RECEB})
		dbSkip()
	EndDo

Next

For nx:=1 to len(aDocsDes)

	For ny := 1 to len(aDocs)

		dbSelectArea("FRD")
		dbSetOrder(1)			//FRD_FILIAL+FRD_PREFIX+FRD_NUM+FRD_PARCEL+FRD_TIPO+FRD_FORNEC+FRD_LOJA+FRD_DOCUM
		If dbSeek(aDocsDes[nx,1]+aDocsDes[nx,2]+aDocsDes[nx,3]+aDocsDes[nx,4]+aDocsDes[nx,5]+aDocsDes[nx,6]+aDocsDes[nx,7]+aDocs[ny,1])
			RecLock("FRD",.F.)
      	Else
			RecLock("FRD",.t.)
		EndIf
			FRD->FRD_FILIAL 	:= aDocsDes[nx,1] 	//Filial
			FRD->FRD_PREFIX 	:= aDocsDes[nx,2] 	//Prefixo
			FRD->FRD_NUM   		:= aDocsDes[nx,3] 	//Titulo
			FRD->FRD_PARCEL 	:= aDocsDes[nx,4] 	//Parcela
			FRD->FRD_TIPO 		:= aDocsDes[nx,5] 	//Tipo
			FRD->FRD_FORNEC 	:= aDocsDes[nx,6] 	//Fornecedor
			FRD->FRD_LOJA 		:= aDocsDes[nx,7] 	//Loja
			FRD->FRD_DOCUM 		:= aDocs[ny,1]		//Documento
			FRD->FRD_RECEB 		:= aDocs[ny,2]		//Recebido
		MsUnLock()

	Next

Next

RestArea(aArea)
Return
