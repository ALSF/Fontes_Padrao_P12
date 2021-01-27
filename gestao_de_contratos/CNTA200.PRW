#INCLUDE "CNTA200.CH"
#INCLUDE "PROTHEUS.CH"

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

//Transacoes
#DEFINE DEF_TRAINC "007"//Inclusao de Planilhas
#DEFINE DEF_TRAEDT "008"//Edicao de Planilhas
#DEFINE DEF_TRAEXC "009	"//Exclusao de Planilhas
#DEFINE DEF_TRAVIS "032"//Visualizacao de Planilhas

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN200Flag³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o usuario atraves da solicitacao selecionada        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN200Flag()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200Flag()

Local aGrupoSC := UsrGrComp(RetCodUsr())
Local lSolic := IF(SuperGetMv("MV_RESTCOM")=="S",.T.,.F.)
Local cFlag	 := IIf(C1_QUJE>=C1_QUANT,'X',' ')+If(C1_TPOP=='P'.And.C1_APROV$"R,B",'X',' ');
+If(Empty(SC1->C1_GRUPCOM),' ',If(lSolic.And.aScan(aGrupoSC,SC1->C1_GRUPCOM) <= 0,'X',' '));
+If(SC1->C1_TPSC == '2','X',' ') + If(C1_APROV == 'B','X',' ') + If(C1_FLAGGCT == '1','X',' ' )

//Ponto de entrada para marcar SC's que não deverão ser apresentadas
If ExistBlock("CN200FLG")
	cFlag += ExecBlock("CN200FLG",.F.,.F.)
EndIf

Return cFlag

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN200AddMark³ Autor ³ Marcelo Custodio      ³ Data ³28.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Altera marcacao realizada pelo usuario                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN200AddMark(cExp01,aExp02,cExp03,cExp04)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Marca                                               ³±±
±±³          ³ aExp02 - Array com as marcacoes                              ³±±
±±³          ³ cExp03 - Campo de validacao                                  ³±±
±±³          ³ cExp04 - Alias do arquivo                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200AddMark(cMarca,aMarca,cCampoOk,cAlias)
Local cFilCod   := xFilial(cAlias)
Local cNum      := IIF(cAlias== "SC1",SC1->C1_NUM,SC7->C7_NUM)
Local cItem     := IIF(cAlias== "SC1",SC1->C1_ITEM,SC7->C7_ITEM)
Local cFilCodPos:= IIF(cAlias== "SC1","C1_FILIAL","C7_FILIAL")
Local cNumPos   := IIF(cAlias== "SC1","C1_NUM","C7_NUM")
Local nPosRec	:= 0

Local aCN200SPC := {}
Local lCN200SPC := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para customizar a marcacao da solicitacao de compra / Pedido de Compras  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CN200SPC")
	aCN200SPC := ExecBlock("CN200SPC",.F.,.F.,{cMarca,aMarca,cCampoOk,cAlias})
	If Valtype(aCN200SPC) == "A"
	   	aMarca    := aClone(aCN200SPC)
	   	lCN200SPC := .T.
    Endif
 EndIf

If !lCN200SPC

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no inicio da solicitacao de compra / Pedido de Compras  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSeek(xFilial(cAlias)+cNum)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre os itens da mesma solicitacao/ Pedido de Compras  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While (cAlias)->&cFilCodPos == cFilCod .And. (cAlias)->&cNumPos == cNum
		If (cAlias == 'SC1' .And. Empty(CN200Flag())) .Or. cAlias <> 'SC1' //Protecao para não marcar itens que não podem ser utilizados
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a solicitação de compra / Pedido de Compras já esta marcada   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosRec := aScan(aMarca, Recno()) 
			If nPosRec > 0
				aDel(aMarca, nPosRec)
				aSize(aMarca, Len(aMarca)-1)
				//Altera campo de marcacao para todos os itens
				If &(cCampoOk) == cMarca
					RecLock(cAlias,.F.)
					&(cCampoOk) := ""
					MsUnlock()
				EndIf
			Else
				AADD(aMarca,Recno())
				//Altera campo de marcacao para todos os itens
				If &(cCampoOk) != cMarca
					RecLock(cAlias,.F.)
					&(cCampoOk) := cMarca
					MsUnlock()
				EndIf
			EndIf
		EndIf
		dbSkip()
	EndDo

	//Retorna para o item selecionado
	dbSeek(xFilial(cAlias)+cNum+cItem)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN200VldCon³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida contrato                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200VldCon()
Local aArea     := GetArea()
Local lRet      := .T.
Local cContrato := M->CNA_CONTRA
Local cRevisa   := M->CNA_REVISA
Local cCtrFix	:= ""

If !Empty(cContrato)

 	If lContrEd
		If cContrato <> M->CN9_NUMERO
			lRet := .F.
			Help(" ",1,"CNTA200COP")//"Numero do contrato cadastrado na Planilha divergente ao Contrato.
		EndIf
	Else

		lRet:= ExistCpo("CN9",cContrato+cRevisa)
	EndIf

	lRet := If(lContrEd,lRet,lRet.And.CN240VldUsr(cContrato,DEF_TRAINC,.T.))

	If lRet
		dbSelectArea("CN9")
		dbSetOrder(1)

		If Empty(cRevisa)
			dbSeek(xFilial("CN9")+cContrato)
			//Seleciona revisao mais recente se houver
			If !Empty(CN9->CN9_REVATU)
				M->CNA_REVISA := cRevisa := CN9->CN9_REVATU
			EndIf
		EndIF

		//Verifica se o edital selecionado pertence a um edital
		If !Empty(CN9->CN9_CODED)
			lRet := .F.
			Help(" ",1,"CNTA200EDT",,STR0070,4,1)	//"Contrato foi gerado por um edital e por isso nao se pode inserir planilha"
		EndIf



		If dbSeek(xFilial("CN9")+cContrato+cRevisa) .And. lRet

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o contrato aceita planilha          ³
			//³ Situacoes que aceitam a inclusao de planilha    ³
			//³  - 2 - Elaboracao                               ³
			//³  - 3 - Emitido                                  ³
			//³  - 4 - Em Aprovacao                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(CN9->CN9_SITUAC) == DEF_SELAB .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO
				//Busca Tipo de Contrato
				If CN1->(dbSeek(xFilial("CN1")+CN9->CN9_TPCTO))
					cCtrFix := CN1->CN1_CTRFIX
				EndIf
				//Para tipo de contrato fixo nao permite inclusao de planilha
				If cCtrFix != "2"
					If Empty(CN9->CN9_CLIENT)
						//Quando altera o numero do contrato limpa o fornecedor
						cEspctr:="1"

		               	IF !Empty(CN9->CN9_REVATU)=.F.
							If ALTERA .And. M->CNA_CONTRA != CNA->CNA_CONTRA
								M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
								M->CNA_LOJA	  := Space(TamSX3("CNA_LOJA")[1])
							Endif

							//Retorna numero na sequencia do contrato para a planilha
					       	M->CNA_NUMERO := CN200PlaNum(cContrato,cRevisa)
							//Retorna data inicial do contrato, ou a data atual
				       	   	M->CNA_DTINI  := If((CN9->CN9_DTINIC > dDataBase),CN9->CN9_DTINIC,dDataBase)
							//Retorna data final do contrato, ou a data atual
					       	M->CNA_DTFIM  := If((CN9->CN9_DTFIM > dDataBase),CN9->CN9_DTFIM,dDataBase)

							dbSelectArea("CNC")
							dbSetOrder(1)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Seleciona primeiro fornecedor relacionado       ³
							//³ ao contrato                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If dbSeek(xFilial("CNC")+M->CNA_CONTRA+M->CNA_REVISA)
								M->CNA_FORNEC := CNC->CNC_CODIGO
								M->CNA_LJFORN := CNC->CNC_LOJA
							Else
								M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
								M->CNA_LJFORN := Space(TamSX3("CNA_LJFORN")[1])
							Endif
							lRet := .T.
						Else
							lRet := .F.
							Help(" ",1,"CNTA200CON") //"Contrato revisado, selecione a versão mais recente."
						EndIf
					Else
						//Quando altera o numero do contrato limpa o Vendedor
		    			cEspctr:="2"
		            	IF !Empty(CN9->CN9_REVATU)=.F.
							If ALTERA .And. M->CNA_CONTRA != CNA->CNA_CONTRA
								M->CNA_CLIENT := Space(TamSX3("CNA_CLIENT")[1])
								M->CNA_LOJACL := Space(TamSX3("CNA_LOJACL")[1])
							Endif

							//Retorna numero na sequencia do contrato para a planilha
					       	M->CNA_NUMERO := CN200PlaNum(cContrato,cRevisa)
							//Retorna data inicial do contrato, ou a data atual
				       		M->CNA_DTINI  := If((CN9->CN9_DTINIC > dDataBase),CN9->CN9_DTINIC,dDataBase)
							//Retorna data final do contrato, ou a data atual
				           	M->CNA_DTFIM  := If((CN9->CN9_DTFIM > dDataBase),CN9->CN9_DTFIM,dDataBase)

							dbSelectArea("SA1")
							dbSetOrder(1)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Seleciona primeiro cliente relacionado ao contrato  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If dbSeek(xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL)
								M->CNA_CLIENT := SA1->A1_COD
								M->CNA_LOJACL := SA1->A1_LOJA
							Else
								M->CNA_CLIENT := Space(TamSX3("A1_COD")[1])
								M->CNA_LOJACL := Space(TamSX3("A1_LOJA")[1])
							Endif
							lRet := .T.
						Else
							lRet := .F.
							Help(" ",1,"CNTA200CON") //"Contrato revisado, selecione a versão mais recente."
						EndIf
					Endif
				Else
					lRet := .F.
					M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
					Aviso(OemToAnsi(STR0018),OemToAnsi(STR0046),{"Ok"}) //"O tipo do Contrato selecionado não permite a inclusão de planilhas."
				EndIf
			Else
				lRet := .F.
				M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
				Help(" ",1,"CNTA200ATU") //"A situação atual do contrato não permite a inclusão de planilhas."
			EndIf

		ElseIf Empty(CN9->CN9_CODED)
			//Limpa revisao quando o contrato nao for encontrado
			M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
		Endif
	EndIf
Else
	lRet  := .F.
Endif

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN200PlaNum³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna numero sequencial da planilha de acordo com o contrato³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ cExp01 := CN200PlaNum(cExp02,cExp03)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Numero sequencial da planilha                        ³±±
±±³          ³ cExp02 - Numero do contrato                                   ³±±
±±³          ³ cExp03 - Numero da revisao                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200PlaNum(cContra,cRevisa)
Local cNumPla := Strzero(0,TamSX3("CNA_NUMERO")[1])
Local cFilCod
Local aArea   := GetArea()

dbSelectArea("CNA")
dbSetOrder(1)

cFilCod := xFilial("CNA")
dbSeek(cFilCod+cContra+cRevisa)
//Seleciona planilha mais recente
While CNA->CNA_FILIAL == cFilCod .And. CNA->CNA_CONTRA == cContra .And. CNA->CNA_REVISA == cRevisa
	cNumPla := CNA->CNA_NUMERO
	dbSkip()
EndDo

cNumPla := Soma1(cNumPla)

RestArea(aArea)
Return cNumPla

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN200FilFor³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de filtro da consulta padrao para filtrar apenas os    ³±±
±±³          ³ fornecedores do contrato                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOpc - Opcao selecionada                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200FilFor()
Local lRet    := .F.
Local cProg   := FunName()
Local cRevisa := ""

Do Case
	case cProg == "CNTA200" .OR. cProg == "CNTA100"
		If !lContrEd
			cRevisa := M->CNA_REVISA
	  		lRet := CNC->(dbSeek(xFilial("CNC")+M->CNA_CONTRA+cRevisa+SA2->A2_COD+SA2->A2_LOJA))
	 	Else
	 	   lRet := (aScan(aForn,{|x| x[1] == SA2->A2_COD .And. x[2] == SA2->A2_LOJA}) > 0)
	 	EndIf
	case cProg == "CNTA120"
		cRevisa := M->CND_REVISA
		lRet := CNC->(dbSeek(xFilial("CNC")+M->CND_CONTRA+cRevisa+SA2->A2_COD+SA2->A2_LOJA))
	case cProg == "CNTA090"
		cRevisa := M->CN8_REVISA
		lRet := CNC->(dbSeek(xFilial("CNC")+M->CN8_CONTRA+cRevisa+SA2->A2_COD+SA2->A2_LOJA))
	case cProg == "CNTA220"
		cRevisa := Posicione("CN9",1,xFilial("CNC")+M->CNM_CONTRA,"CN9_REVATU")
		lRet := CNC->(dbSeek(xFilial("CNC")+M->CNM_CONTRA+cRevisa+SA2->A2_COD+SA2->A2_LOJA))
	OtherWise
		lRet := .T.
End Case
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN200VldDini³ Autor ³ Marcelo Custodio      ³ Data ³ 16.01.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica data de inicio da planilha                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200VldDini()

Local dTIniCtr		:= CtoD("")
Local dTFimCtr		:= CtoD("")
Local dDtFim		:= CtoD("")
Local lRet 		:= .T.
Local oModel		:= FWModelActive()
Local lMVC			:= ValType(oModel) <> "U"

If lMVC
	dTIniCtr	:= oModel:GetModel("CN9MASTER"):GetValue("CN9_DTINIC") // Data Inicio do contrato
	dTFimCtr	:= oModel:GetModel("CN9MASTER"):GetValue("CN9_DTFIM") // Data final do contrato
	dDtFim		:= oModel:GetModel("CNADETAIL"):GetValue("CNA_DTFIM") // Data final da planilha
Else
	dTIniCtr	:= CN9->CN9_DTINIC	// Data final do contrato
	dTFimCtr	:= CN9->CN9_DTFIM		// Data inicio do contrato
	dDtFim 		:= M->CNA_DTFIM		// Data final da planilha
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de contrato                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lMVC .And. ( CN9->CN9_NUMERO != M->CNA_CONTRA .And. CN9->CN9_REVISA != M->CNA_REVISA )
	CN9->(dbSetOrder(1))
	CN9->(dbSeek(xFilial("CN9")+M->CNA_CONTRA+M->CNA_REVISA))

	dTIniCtr	:= CN9->CN9_DTINIC	// Data final do contrato
	dTFimCtr	:= CN9->CN9_DTFIM		// Data inicio do contrato
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de inicio em relacao ao contrato  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Type("dCN9FIM") != "U" )  .And. dCN9FIM != NIL
	If M->CNA_DTINI < dTIniCtr .Or. M->CNA_DTINI > dCN9FIM
		Help(" ",1,"CNTA200DTI") //"Data de início inválida"
		lRet := .F.
	EndIf
Else
	If M->CNA_DTINI < dTIniCtr .Or. M->CNA_DTINI > dTFimCtr
		Help(" ",1,"CNTA200DTI") //"Data de início inválida"
		lRet := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de inicio em relacao a data de termino³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !Empty(dDtFim) .And. M->CNA_DTINI > dDtFim
	Help(" ",1,"CNTA200MEN") //"A data de início não pode ser menor que a data final da planilha"
	lRet := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN200VldDfim³ Autor ³ Marcelo Custodio      ³ Data ³ 16.01.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica data de termino da planilha                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200VldDfim()

Local dTIniCtr		:= CtoD("")
Local dTFimCtr		:= CtoD("")
Local dDtIni		:= CtoD("")
Local dDtFim		:= CtoD("")
Local lRet 			:= .T.
Local oModel		:= FWModelActive()
Local lMVC			:= ValType(oModel) <> "U"

If lMVC
	dTIniCtr	:= oModel:GetModel("CN9MASTER"):GetValue("CN9_DTINIC") 	// Data Inicio do contrato
	dTFimCtr	:= oModel:GetModel("CN9MASTER"):GetValue("CN9_DTFIM") 	// Data Final do contrato
	dDtIni		:= oModel:GetModel("CNADETAIL"):GetValue("CNA_DTINI") 	// Data Inicio da planilha
	dDtFim		:= oModel:GetModel("CNADETAIL"):GetValue("CNA_DTFIM") 	// Data Final da planilha
Else
	dTIniCtr	:= CN9->CN9_DTINIC	// Data final do contrato
	dTFimCtr	:= CN9->CN9_DTFIM		// Data inicio do contrato
	dDtIni 		:= M->CNA_DTINI		// Data final da planilha
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de contrato                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lMVC .AND. (CN9->CN9_NUMERO != M->CNA_CONTRA .And. CN9->CN9_REVISA != M->CNA_REVISA)
	CN9->(dbSetOrder(1))
	CN9->(dbSeek(xFilial("CN9")+M->CNA_CONTRA+M->CNA_REVISA))

	dTIniCtr	:= CN9->CN9_DTINIC	// Data final do contrato
	dTFimCtr	:= CN9->CN9_DTFIM		// Data inicio do contrato
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de termino em relacao ao contrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Type("dCN9FIM") != "U" )  .AND. dCN9FIM != NIL .And. !lMVC
	If M->CNA_DTFIM < M->CN9_DTINIC .Or. M->CNA_DTFIM > dCN9FIM
		Help(" ",1,"CNTA200DTF")  //"Data final inválida"
		lRet := .F.
	EndIf
ElseIf !lMVC
	If M->CNA_DTFIM < dTIniCtr .Or. M->CNA_DTFIM > dTFimCtr
		Help(" ",1,"CNTA200DTF")  //"Data final inválida"
		lRet := .F.
	EndIf
ElseIf lMVC .And. !IsInCallStack('GCP200CtCE')
	If dDtFim < dTIniCtr .And. dDtFim > dTFimCtr
		Help(" ",1,"CNTA200DTF")  //"Data final inválida"
		lRet := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de termino em relacao a data de inicio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !Empty(dDtIni) .And. dDtIni > M->CNA_DTFIM
	Help(" ",1,"CNTA200DFM") //"A data final não pode ser menor que a data de início da planilha"
	lRet := .F.
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN200FlagPC³ Autor ³ Aline Sebrian         ³ Data ³04/11/09³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o usuario atraves da pedido de compras selecionado  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN200FlagPC()                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200FlagPC()
Local lPedido := IF(SuperGetMv("MV_RESTPED")=="S",.T.,.F.)
Local aGpoPC	:= IF(Type("aGrupoPC") <> "U",aClone(aGrupoPC),UsrGrComp(RetCodUsr()))
Local cFlag	  := IIf(C7_QUJE>=C7_QUANT,'X',' ')+If(C7_TPOP=='P'.And.C7_APROV$"R,B",'X',' ');
+If(Empty(SC7->C7_GRUPCOM),' ',If(lPedido.And.aScan(aGpoPC,SC7->C7_GRUPCOM) <= 0,'X',' '))
Return cFlag


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C200VisuPC³ Autor ³ Aline Sebrian        ³ Data ³04/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama a rotina de visualizacao dos Pedidos de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C200VisuPC()                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function C200VisuPC(nRecSC7)
	Local aAreas		:= {SC7->(GetArea()),GetArea()}
	Local cSavCadastro	:= IIF( Type("cCadastro") == 'C', cCadastro, "")	
	Local cFilBkp	   	:= cFilAnt
	Local lRet			:= .F.
	Local nFuncao := 1 //1=Ped.Compra | 2=Aut.Entrega
	Local nOpcAuto:= 2 //2=Visualizar
	PRIVATE cCadastro 	:= STR0053
	
	SC7->(DbGoto(nRecSC7))	
	If (SC7->(!EOF() .And. !Empty(C7_NUM)))
		cFilAnt 	:= SC7->( IIF(!Empty(C7_FILIAL), C7_FILIAL, cFilAnt) )
		
		Mata120(nFuncao,/*xAutoCab*/,/*xAutoItens*/,nOpcAuto)
		
		cFilant 	:= cFilBkp
		cCadastro	:= cSavCadastro
		lRet		:= .T.
	EndIf
	
	aEval(aAreas,{|x|RestArea(x)})
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN200VldProd³ Autor ³ Allyson Freitas       ³ Data ³ 11.01.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida permissao de Produto                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cProd: Produto                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200VldProd(cProd)
Local lRet 	 	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o usuario tem permissao de inclusao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Inclui
	lRet := MaAvalPerm(1,{cProd,"CNT200",3})
	If !lRet
		Help(,,1,'SEMPERM')
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN200FldOk  ³ Autor ³ Allyson Freitas       ³ Data ³ 11.01.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida permissao de Produto                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200FldOk()
Local lRet			:= .T.
Local cFieldCNB	:= ReadVar()
Local cFieldEdit	:= SubStr(cFieldCNB,4,Len(cFieldCNB))
Local nPProduto	:= 0
Local oModel		:= FWModelActive()
Local oModelCNB	:= Nil
Local lMVC			:= ValType(oModel) <> "U"

If Type('ALTERA') <> 'U' .And. ALTERA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o usuario tem permissao de alteracao. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cFieldEdit $ "CNB_PRODUT"
		If !lMVC
			nPProduto := aScan(aHeader,{|x| AllTrim(x[2])== "CNB_PRODUT"})
			If !(lRet := MaAvalPerm(1,{aCols[n][nPProduto],"CNT200",5}) .And. MaAvalPerm(1,{cCampo,"CNT200",3}))
				Help(,,1,'SEMPERM')
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamentos para interface em MVC ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oModelCNB := oModel:GetModel("CNBDETAIL")
	   		lRet := MaAvalPerm(1,{oModelCNB:GetValue("CNB_PRODUT"),"CNT200",5}) .And. MaAvalPerm(1,{oModelCNB:GetValue("CNB_PRODUT"),"CNT200",3})
			If !lRet
				Help(,,1,'SEMPERM')
			EndIf
		EndIf
	Else
		If !lMVC
			nPProduto := aScan(aHeader,{|x| AllTrim(x[2])== "CNB_PRODUT"})
			If !(lRet := MaAvalPerm(1,{aCols[n][nPProduto],"CNT200",4}))
				Help(,,1,'SEMPERM')
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamentos para interface em MVC ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oModelCNB := oModel:GetModel("CNBDETAIL")
	   		lRet := lRet := MaAvalPerm(1,{oModelCNB:GetValue("CNB_PRODUT"),"CNT200",4})
			If !lRet
				Help(,,1,'SEMPERM')
			EndIf
		EndIf
	EndIF
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN200DelOk  ³ Autor ³ Allyson Freitas       ³ Data ³ 11.01.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida permissao de Produto                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200DelOk()
Local lRet := .T.
Local nPProduto := 0
Local oModel	:= FWModelActive()
Local oModelCNB	:= Nil
Local lMVC		:= ValType(oModel) <> "U"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o usuario tem permissao de exclusao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lMVC

	nPProduto := aScan(aHeader,{|x| AllTrim(x[2])== "CNB_PRODUT"})

	If !(lRet := MaAvalPerm(1,{aCols[n][nPProduto],"CNT200",5}))
		Help(,,1,'SEMPERM')
	EndIf

	    Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamentos para interface em MVC ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModelCNB := oModel:GetModel("CNBDETAIL")

	If !(lRet := MaAvalPerm(1,{oModelCNB:GetValue("CNB_PRODUT"),"CNT200",5}))
		Help(,,1,'SEMPERM')
	EndIf
EndIf


Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³cn200MultT ³ Autor ³ Aline S Damasceno    ³ Data ³ 03/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a Validacao dos campos digitados quanto a quantidade³±±
±±³          ³,preco, desconto e quantidade liberada.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function cn200MultT()
Local aArea		:= GetArea()
Local cEspecie		:= ""
Local oObj			:= Nil
Local nX			:= 0
Local nTotal		:= 0
Local lRetorno		:= .T.
Local cReadVar		:= ReadVar()
Local xConteudo	:= &(cReadVar)
Local oModel		:= FWModelActive()
Local oModelCN9	:= Nil
Local oModelCNB	:= Nil
Local oModelCNS	:= Nil
Local oModelCNF	:= Nil
Local lMVC		:= ValType(oModel) <> "U"
Local aSaveLines:= FWSaveRows()
Local nCalcTot1	:= 0
Local nCalcTot2	:= 0
Local nTamTot	:= TamSX3("CNB_VLTOT")[2]
Local cNumCtrt	:= ""
Local nProd		:= ""
Local cAliasSB1 := ""
Local aTipProd	:= {}
Local cTipo		:= ""
Local cGrupo	:= ""
Local cRevAnt := Tira1(oModel:GetValue("CN9MASTER","CN9_REVISA"))

//- Tratamento para primeira revisão
cRevAnt := Iif(Val(cRevAnt) == 0,space(TAMSX3('CN9_REVISA')[1]),cRevAnt)

//- Tratamentos para interface em MVC
oModelCN9	:= oModel:GetModel("CN9MASTER")
oModelCNB 	:= oModel:GetModel("CNBDETAIL")
oModelCNS	:= oModel:GetModel("CNSDETAIL")
oModelCNF	:= oModel:GetModel("CNFDETAIL")

cEspecie  := oModelCN9:GetValue("CN9_ESPCTR")

//Valida o valor total
If 'CNB_VLTOT' $ cReadVar
	nTotal := oModelCNB:GetValue("CNB_VLTOT")
	nCalcTot1 := NoRound(oModelCNB:GetValue("CNB_QUANT") * oModelCNB:GetValue("CNB_VLUNIT"),nTamTot)
	nCalcTot2 := Round(oModelCNB:GetValue("CNB_QUANT") * oModelCNB:GetValue("CNB_VLUNIT"),nTamTot)

	If Round(nCalcTot1,nTamTot) # Round(nTotal,nTamTot) .And. Round(nCalcTot2,nTamTot) # Round(nTotal,nTamTot)
		Help(" ",1,"CN300PLVTO")	//-- Valor total inválido!
		lRetorno := .F.
	EndIf
EndIf

If lRetorno .And. (Posicione("CN1",1,xFilial("CN1")+oModelCN9:GetValue("CN9_TPCTO"),"CN1_CROFIS") == "1") .And. "CNB_PRODUT" $ cReadVar
	For nX := 1 To oModelCNF:Length()
		oModelCNF:GoLine(nX)
		If !oModelCNF:IsDeleted() .And. !Empty(oModelCNF:GetValue("CNF_COMPET"))
			If oModelCNS:Length() < Val(oModelCNB:GetValue("CNB_ITEM"))
				Exit
			EndIf
			oModelCNS:GoLine(oModelCNB:GetLine())
			oModelCNS:LoadValue("CNS_PRODUT",oModelCNB:GetValue("CNB_PRODUT"))
			oModelCNS:LoadValue("CNS_DESCRI",Posicione("SB1",1,xFilial("SB1")+oModelCNB:GetValue("CNB_PRODUT"),"B1_DESC"))
		EndIf
	Next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamentos para aditivo do contrato oriundo do GCP ³
//³Validando vínculo do novo item com o objeto contratado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lRetorno .And. IsInCallStack("CN300REV") .And. !Empty(FwFldGet("CN9_CODED"))
	CN0->(dbsetOrder(1))
	If CN0->(dbSeek(xFilial("CN0")+FwFldGet("CN9_TIPREV")))
		cTpRev	:= CN0->CN0_TIPO
        EndIf

	If cTpRev == "1"
		lRetorno := CN300ExcArt(oModel,'ADITIVO')
		If lRetorno
			cNumCtrt	:= FwFldGet("CN9_NUMERO")
			nProd		:= FwFldGet("CNB_PRODUT")
			cAliasSB1 := GetNextAlias()

			BeginSql Alias cAliasSB1
				Select DISTINCT SB1.B1_TIPO TIPO,
						SB1.B1_GRUPO GRUPO

				FROM %table:SB1% SB1,
				     %table:CNB% CNB

				WHERE
				CNB.CNB_FILIAL = %xfilial:CNB%
				AND CNB.CNB_CONTRA = %exp:cNumCtrt%
				AND CNB.CNB_REVISA = %exp:cRevAnt%
				AND CNB.%NotDel%
				AND SB1.B1_FILIAL = %xfilial:SB1%
				AND SB1.B1_COD = CNB.CNB_PRODUT

				ORDER BY
					TIPO, GRUPO

			EndSql

			While (cAliasSB1)->(!Eof())
				aAdd(aTipProd, {(cAliasSB1)->TIPO,(cAliasSB1)->GRUPO})
				(cAliasSB1)->(dbSkip())
			EndDo

			DbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+nProd))
				cTipo	:= SB1->B1_TIPO
				cGrupo := SB1->B1_GRUPO

				//Grupo e Tipo do prooduto não podem estar em branco
				If !Empty(cTipo) .And. !Empty(cGrupo)
					If Ascan(aTipProd, {|a| a[1] == cTipo .and. a[2] == cGrupo}) == 0
						Help(" ",1,"CN30065PRD")
						lRetorno := .F.
					EndIf
				Else
					Help(" ",1,"CN30065TP")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

If lRetorno
	A300RevSrv()
EndIf

RestArea(aArea)
FWRestRows(aSaveLines)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CN200Loca  ºAutor³João Gonçalves de Oliveira º Data ³ 10/02/11      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Chamada da função de atualização da localização física              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ CN200Loca(ExpO1,ExpC2,ExpC3,ExpC4,ExpC5)                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros³ Nenhum                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nenhum                                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200Loca(cContra,cRevisa,cPlanil,oGetDados,aLocais,aPlani,lVisual)
Local nPRODUT   := aScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "CNB_PRODUT"})
Local nQUANT    := aScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "CNB_QUANT"})
Local nBASINS   := aScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "CNB_BASINS"})
Local nITEM     := aScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "CNB_ITEM"})
Local nPosLocal := 0
Local nX 	    := 0
Local nY		:= 0
Local nPLANIL 	:= 0
Local nITEM2  	:= 0
Local nCLIENT 	:= 0
Local nLOJA   	:= 0
Local nCODFAB 	:= 0
Local nLOJAFA 	:= 0
Local nPRODUT2 	:= 0
Local nNUMSER 	:= 0
Local aDadosCtr := {}
Local lBkpINC   := INCLUI
Local lBkpALT   := ALTERA
Local lConfirm  := .F.
Local lValidou  := .F.
Local lCntEdit  := If(Type("lContrEd") == "L" .And. lContrEd,.T.,.F.)
Local cCliente  := If(lCntEdit,M->CN9_CLIENT,Posicione("CN9",1,xFilial("CN9")+cContra+cRevisa,"CN9_CLIENT"))
Local cLojaCli  := If(lCntEdit,M->CN9_LOJACL,Posicione("CN9",1,xFilial("CN9")+cContra+cRevisa,"CN9_LOJACL"))

Default lVisual := .F.

If Len(oGetDados:aCols) > 0
	If Empty(oGetDados:aCols[oGetDados:nAt,nPRODUT])
		Aviso(STR0059,STR0066,{"OK"}) //-- Informe o código do produto/eqpto.
	ElseIf oGetDados:aCols[oGetDados:nAt,nBASINS] <> "1"
		Aviso(STR0059,STR0068,{"OK"}) //-- Produto/eqpto não configurado para geração de base instalada.
	ElseIf Posicione("CNB",1,xFilial("CNB")+cContra+cRevisa+cPlanil+oGetDados:aCols[oGetDados:nAt,nITEM],"CNB_GERBIN") == "1"
		Aviso(STR0059,STR0069,{"OK"}) //-- Já foi gerada base instalada para este produto/eqpto.
	Else
		AGW->(dbSetOrder(2))
		If lVisual
			If AGW->(dbSeek(xFilial("AGW")+cContra+cPlanil+oGetDados:aCols[oGetDados:nAt,nITEM]))
				AT110Man("AGW",AGW->(Recno()),2,,,oGetDados:aHeader,oGetDados:aCols)
			EndIf
		ElseIf (nPosLocal := aScan(aLocais,{|x| x[1] == oGetDados:aCols[oGetDados:nAt,nITEM]})) > 0
			If !AGW->(dbSeek(xFilial("AGW")+cContra+cPlanil+oGetDados:aCols[oGetDados:nAt,nITEM]))
				INCLUI := .T.
				ALTERA := .F.
			Else
				INCLUI := .F.
				ALTERA := .T.
			EndIf

			If nPosLocal > 0
				aDadosCtr := aClone(aLocais[nPosLocal,2])
				//-- Tratamento para troca do produto
				If (nPRODUT2 := aScan(aDadosCtr,{|x| x[1] == "AGW_PRODUT"})) > 0
					aDadosCtr[nPRODUT2,2] := oGetDados:aCols[oGetDados:nAt,nPRODUT]
				EndIf
			Else
				For nX := 1 To AGW->(FCount())
					aAdd(aDadosCtr,{Trim(AGW->(FieldName(nX))),AGW->&(FieldName(nX))})
				Next nX
			EndIf

			lConfirm := AT110Man("AGW",AGW->(Recno()),If(AGW->(Found()),4,3),aDadosCtr,cPlanil,oGetDados:aHeader,oGetDados:aCols)
		Else
			INCLUI := .T.
			ALTERA := .F.

			aAdd(aDadosCtr,{"AGW_CONTRA",cContra,.F.})
			aAdd(aDadosCtr,{"AGW_PLANIL",cPlanil,.F.})
			aAdd(aDadosCtr,{"AGW_ITEM",oGetDados:aCols[oGetDados:nAt,nITEM],.F.})
			aAdd(aDadosCtr,{"AGW_CLIENT",cCliente,.F.})
			aAdd(aDadosCtr,{"AGW_LOJA",cLojaCli,.F.})
			aAdd(aDadosCtr,{"AGW_PRODUT",oGetDados:aCols[oGetDados:nAt,nPRODUT],.F.})
			aAdd(aDadosCtr,{"AGW_DESCRI",Posicione("SB1",1,xFilial("SB1")+oGetDados:aCols[oGetDados:nAt,nPRODUT],"B1_DESC"),.F.})

			lConfirm := AT110Man("AGW",0,3,aDadosCtr,cPlanil,oGetDados:aHeader,oGetDados:aCols)
		EndIf

		//-- Valida chaves
		While aPlani # NIL .And. lConfirm .And. !lValidou
			lValidou := .T.

			nPLANIL  := aScan(aDadosCtr,{|x| x[1] == "AGW_PLANIL"})
			nITEM2   := aScan(aDadosCtr,{|x| x[1] == "AGW_ITEM"})
			nCLIENT  := aScan(aDadosCtr,{|x| x[1] == "AGW_CLIENT"})
			nLOJA    := aScan(aDadosCtr,{|x| x[1] == "AGW_LOJA"})
			nCODFAB  := aScan(aDadosCtr,{|x| x[1] == "AGW_CODFAB"})
			nLOJAFA  := aScan(aDadosCtr,{|x| x[1] == "AGW_LOJAFA"})
			nPRODUT2 := aScan(aDadosCtr,{|x| x[1] == "AGW_PRODUT"})
			nNUMSER  := aScan(aDadosCtr,{|x| x[1] == "AGW_NUMSER"})

			For nX := 1 To Len(aPlani)
				//-- Planilha sem localizacoes
				If Empty(aTail(aPlani[nX]))
					Loop
				EndIf

				For nY := 1 To Len(aTail(aPlani[nX]))
					//-- Mesmo item da mesma planilha
					If aTail(aPlani[nX])[nY,2,nPLANIL,2]+aTail(aPlani[nX])[nY,2,nITEM2,2] == cPlanil+oGetDados:aCols[oGetDados:nAt,nITEM]
						Loop
					EndIf

					If aTail(aPlani[nX])[nY,2,nCLIENT,2] == aDadosCtr[nCLIENT,2] .And.;
									aTail(aPlani[nX])[nY,2,nLOJA,2] == aDadosCtr[nLOJA,2] .And.;
									aTail(aPlani[nX])[nY,2,nPRODUT2,2] == aDadosCtr[nPRODUT2,2] .And.;
									aTail(aPlani[nX])[nY,2,nNUMSER,2] == aDadosCtr[nNUMSER,2]
						Help(" ",1,"AT040INC01")
						lValidou := .F.
					EndIf
				Next nY
			Next nX

			If !lValidou
				lConfirm := AT110Man("AGW",0,If(lCntEdit,3,4),aDadosCtr,cPlanil,oGetDados:aHeader,oGetDados:aCols)
			EndIf
		End

		If lConfirm
			If (nPosLocal := aScan(aLocais,{|x| x[1] == oGetDados:aCols[oGetDados:nAt,nITEM]})) == 0
				aAdd(aLocais,{oGetDados:aCols[oGetDados:nAt,nITEM],aClone(aDadosCtr)})
			Else
				aLocais[nPosLocal,2] := aClone(aDadosCtr)
			EndIf
		EndIf
	EndIf
EndIf

INCLUI := lBkpINC
ALTERA := lBkpALT

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CNAGWLoadºAutor  ³ Andre Anjos		 º Data ³  18/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna array com as localizacoes fisicas (AGW).           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CNTA200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CNAGWLoad(nOpc,cContra,cPlanil)
Local aRet := {}
Local nX   := 0

Default cContra := CNA->CNA_CONTRA
Default cPlanil := CNA->CNA_NUMERO

If nOpc # 3
	AGW->(dbSetOrder(2))
	AGW->(dbSeek(xFilial("AGW")+cContra+cPlanil))
	While !AGW->(EOF()) .And. AGW->(AGW_FILIAL+AGW_CONTRA+AGW_PLANIL) == xFilial("AGW")+cContra+cPlanil
		aAdd(aRet,{AGW->AGW_ITEM,Array(AGW->(FCount()))})
		For nX := 1 To Len(aTail(aRet)[2])
			aTail(aRet)[2,nX] := {AGW->(FieldName(nX)),AGW->&(FieldName(nX))}
		Next nX

		AGW->(dbSkip())
	End
EndIf

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN200VlBasºAutor  ³ Andre Anjos        º Data ³  29/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida alteracao do campo de integracao com Gestao de Serv.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCT                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN200VlBas()
Local lRet 		:= .T.
Local oObj 		:= NIL
Local oModel		:= FWModelActive()
Local lMVC			:= ValType(oModel) <> "U" .And. nModulo <> 28



If !lMVC

	oObj:= If(FunName() == "CNTA140",oGetDad1,oGetDados)

	If M->CNB_BASINS == '1' .And. !Empty(oObj:aCols[oObj:nAt,aScan(oObj:aHeader, {|x| AllTrim(x[2]) == "CNB_QTDMED"})])
		Aviso(STR0059,STR0064,{"OK"}) //Este item não poderá gerar base instalada pois já foi movimentado.
		lRet := .F.
	ElseIf M->CNB_BASINS # '1' .And. !Empty(oObj:aCols[oObj:nAt,Len(oObj:aHeader)])
		CNB->(dbGoTo(oObj:aCols[oObj:nAt,Len(oObj:aHeader)]))
		If CNB->CNB_GERBIN == '1'
			Aviso(STR0059,STR0065,{"OK"}) //Este item da planilha já gerou base instalada e por isso este campo não pode ser alterado.
			lRet := .F.
		EndIf
	EndIf
Else
	If oModel:GetValue("CNBDETAIL","CNB_BASINS") == '1' .AND. !EMPTY(oModel:GetValue("CNBDETAIL","CNB_QTDMED"))
		Aviso(STR0059,STR0064,{"OK"}) //Este item não poderá gerar base instalada pois já foi movimentado.
		lRet := .F.
	ElseIF 	oModel:GetValue("CNBDETAIL","CNB_BASINS") != '1' .AND. oModel:GetModel("CNBDETAIL"):IsUpdated()
		CNB -> (dBGoto(oModel:GetModel("CNBDETAIL"):GetDataID()))
		If oModel:GetValue("CNBDETAIL","CNB_GERBIN") == '1'
			Aviso(STR0059,STR0065,{"OK"}) //Este item da planilha já gerou base instalada e por isso este campo não pode ser alterado.
			lRet := .F.
		EndIf
	EndIf
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C200BIWhenºAutor  ³ Andre Anjos 		 º Data ³  29/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ When dos campos CNB_BASINS e CNB_TABPRC.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCT                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function C200BIWhen(cCampo)
Local lRet := .T.

If cCampo == "CNB_BASINS"
	lRet := SuperGetMV("MV_CNINTFS",.F.,.F.)
EndIf

If lRet
	Do Case
		Case FunName() $ "CNTA100*CNTA200"
			lRet := !Empty(M->CNA_CLIENT)
		Case FunName() == "CNTA140"
			lRet := !Empty(CN9->CN9_CLIENT)
	EndCase
EndIf

Return lRet
