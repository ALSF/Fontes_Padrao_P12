#INCLUDE "CNTA110.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "ApWizard.CH"
#INCLUDE "FWMVCDEF.CH"

//Situacoes de contrato
#DEFINE DEF_SCANC "01"//Cancelado
#DEFINE DEF_SELAB "02"//Em Elaboracao
#DEFINE DEF_SEMIT "03"//Emitido
#DEFINE DEF_SAPRO "04"//Em Aprovacao
#DEFINE DEF_SVIGE "05"//Vigente
#DEFINE DEF_SPARA "06"//Paralisado
#DEFINE DEF_SSPAR "07"//Sol Fina.
#DEFINE DEF_SFINA "08"//Finalizado
#DEFINE DEF_SREVS "09"//Revisao
#DEFINE DEF_SREVD "10"//Revisado

//Transações
#DEFINE DEF_TRAINC "011"//Inclusao de cronogramas
#DEFINE DEF_TRAEDT "012"//Edicao de cronogramas
#DEFINE DEF_TRAEXC "013"//Exclusao de cronogramas
#DEFINE DEF_TRAVIS "033"//Visualizacao de cronogramas

//Tipos de Revisao
#DEFINE DEF_REALI "3" //Realinhamento
#DEFINE DEF_REV_REAJU "2" //Reajuste

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CN110MtFsc  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Monta o aHeader do cronograma fisico com base no arquivo CNS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CN110MtFsc(aExp01)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array para montagem do cabecalho                    ³±±
±±³          ³ lExp02 - Visualiza cronograma fisico                         ³±±
±±³          ³ nExp03 - Numeracao de controle de incl/alter/consul          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN110MtFsc(aHeadParc,lVisu,nOpcX)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos nao exibidos                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCampos := "CNS_FILIAL|CNS_CONTRA|CNS_REVISA|CNS_CRONOG|CNS_PARCEL|CNS_PLANI"

Default lVisu := .F.

If lVisu
	cCampos += "|CNS_DISTSL"
EndIf

dbSelectArea("SX3")
dbSetOrder(1)

If dbSeek("CNS")
	While !Eof() .And. SX3->X3_ARQUIVO=="CNS"
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cCampos)
			AAdd(aHeadParc,{AllTrim(X3Titulo()),;
			AllTrim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT})
		EndIf
		dbSkip()
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcX <> 3
		ADHeadRec("CNS",aHeadParc)
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CN110VldVal ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida alteracao no valor de parcela                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CN110VldVal()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN110VldVal()

Local aAreaAnt	:= GetArea()

Local lReali := .F.
Local lRet   := .T.
Local lSaldoRec := .T.

Local cQryCNF := ""
Local cQuery    := ""

Local oModel   	 := FWModelActive()
Local oModelCNF	 := oModel:GetModel("CNFDETAIL")

If !IsIncallStack('CN300Rev') .And. Vazio() .And. !IsBlind()
	Help(" ",1,"CN300VLPRV")
	Return .F.
EndIf

If	FwFldGet("CN9_SITUAC") == DEF_SREVS
	dbSelectArea("CN0")
	dbSetOrder(1)
	dbSeek(xFilial("CN0") + FwFldGet("CN9_TIPREV"))
	lReali  := (CN0->CN0_TIPO == DEF_REALI) .And. (GetNewPar( "MV_CNREALM", "S" ) == "S")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para obter o valor das parcelas ja FATURADAS     ³
//|no Contrato se parametro MV_CNREALM = Sim              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lReali
	cQryCNF := GetNextAlias()

	cQuery := "SELECT CNF_CONTRA ,  CNF_REVISA, SUM(CNB.CNB_QUANT)AS QUANT , SUM(CNB.CNB_SLDREC) AS RECEBIDO "
	cQuery += "  FROM " + RetSqlName("CNB") + " CNB ," + RetSqlName("CNF") + " CNF "
	cQuery += " WHERE CNF_FILIAL     = '" + xFilial( "CNF" ) + "'"
	cQuery += "   AND CNB_FILIAL     = '" + xFilial( "CNB" ) + "'"
	cQuery += "   AND CNF.CNF_CONTRA = '"+ FwFldGet("CN9_NUMERO")+ "'"
	cQuery += "   AND CNF.CNF_REVISA = '"+ FwFldGet("CN9_REVISA")+ "'"
	cQuery += "   AND CNB.CNB_CONTRA = CNF.CNF_CONTRA "
	cQuery += "   AND CNB.CNB_REVISA = CNF.CNF_REVISA "
	cQuery += "   AND CNB.D_E_L_E_T_ = ' ' "
	cQuery += "   AND CNF.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY CNF_CONTRA ,  CNF_REVISA "

	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cQryCNF, .F., .T. )
	TCSetField( cQryCNF, "QUANT"   , "N", TamSX3("CNB_QUANT")[1] , TamSX3("CNB_QUANT")[2] )
	TCSetField( cQryCNF, "RECEBIDO", "N", TamSX3("CNB_SLDREC")[1], TamSX3("CNB_SLDREC")[2] )

	If !(cQryCNF)->(Eof())
		lSaldoRec:=(cQryCNF)->QUANT <> (cQryCNF)->RECEBIDO
	EndIf
	If Select(cQryCNF) > 0
		(cQryCNF)->( dbCloseArea() )
	EndIF

EndIf

If !lReali .Or. lSaldoRec
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se previsao e menor que realizado    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If &(Readvar()) < oModelCNF:GetValue("CNF_VLREAL")
		Help(" ",1,"CNTA110REA") //"Valor previsto não deve ser menor que realizado"
		lRet := .F.
	EndIf

Else

	If (&(Readvar()) < (oModelCNF:GetValue("CNF_VLREAL") + oModelCNF:GetValue("CNF_SALDO")) ) .AND. ( !Empty(oModelCNF:GetValue("CNF_VLREAL")) .AND. !Empty(oModelCNF:GetValue("CNF_SALDO")) )

		lRet := .F.
		Help(" ",1,"CNTA110REP") //"Valor previsto não deve ser menor que a soma do realizado com o saldo parcial para a Revisão de Realinhamento com parcelas parcialmente medidas."

	ElseIf (&(Readvar()) < oModelCNF:GetValue("CNF_VLREAL") ) .AND. ( !Empty(oModelCNF:GetValue("CNF_VLREAL")) .AND. Empty(oModelCNF:GetValue("CNF_SALDO")) )

		lRet := .F.
		Help(" ",1,"CNTA110RET") //"Valor previsto não deve ser menor que o realizado com o para a Revisão de Realinhamento com parcelas totalmente medidas."

	EndIf

EndIf

RestArea(aAreaAnt)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CN100FsVls  ³ Autor ³ Marcelo Custodio      ³ Data ³16.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida quantidade do cronograma fisico                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN110FsVld(nOldValue)
Local oModel		:= FWModelActive()
Local oModelCNS	:= oModel:GetModel("CNSDETAIL")
Local oModelCNF	:= oModel:GetModel("CNFDETAIL")

Local lRet			:= .F.

Local nPosDist	:= 0
Local nTotItens	:= 0
Local nTamTot	:= TamSX3("CNF_VLPREV")[2]
Local nx		:= 0
Local nDesc		:= 0
Local nLine		:= oModelCNS:GetLine()

Local cContra	:= FwFldGet('CN9_NUMERO')
Local cRevisa	:= FwFldGet('CN9_REVISA')
Local cClient	:= ""

Local aPropsCNF	:= {oModelCNF:CanDeleteLine(),oModelCNF:CanInsertLine(),oModelCNF:CanUpdateLine()}
Local aSaveLines:= FWSaveRows()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o valor informado < que o saldo - quantidade medida    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsInCallStack("A300AtuCrF")
	lRet := .T.
Else
	lRet := (M->CNS_PRVQTD >= oModelCNS:GetValue("CNS_RLZQTD"))
EndIf

If lRet
	nPosDist := oModelCNS:GetValue("CNS_DISTSL")
	nPosDist -= oModelCNS:GetValue("CNS_PRVQTD") - nOldValue
	nTotItens := Cn100CFisT(oModel)

	//-- Atualiza valor da parcela no cronog. financeiro quando campo alterado pelo usuario
	If A300GTPREV() <> DEF_REV_REAJU  .And. !IsInCallstack("CN300MKCRG")
		CNTA300BlMd(oModelCNF,.F.,.T.)
		oModelCNF:GetStruct():SetProperty('CNF_VLPREV',MODEL_FIELD_WHEN,{||.T.})
		oModelCNF:GetStruct():SetProperty('CNF_SALDO' ,MODEL_FIELD_WHEN,{||.T.})
		
		lRet := oModelCNF:SetValue("CNF_VLPREV",nTotItens)
		
		oModelCNF:SetNoDeleteLine(!aPropsCNF[1])
		oModelCNF:SetNoInsertLine(!aPropsCNF[2])
		oModelCNF:SetNoUpdateLine(!aPropsCNF[3])

		oModelCNF:GetStruct():SetProperty('CNF_VLPREV',MODEL_FIELD_WHEN,{||.F.})
		oModelCNF:GetStruct():SetProperty('CNF_SALDO' ,MVC_VIEW_CANCHANGE, .F.)
	EndIf
	
	If lRet
		//-- Atualiza total da parcela no header
		oModel:GetModel("CALC_CNS"):LoadValue("TCNS_VTOT",nTotItens)

		//-- Atualiza saldo a distribuir em todas as parcelas
		For nX := 1 To oModelCNF:Length()
			oModelCNF:GoLine(nX)
			If !oModelCNF:IsDeleted() .And. oModelCNS:Length() >= nLine
				oModelCNS:GoLine(nLine)
				oModelCNS:SetValue("CNS_DISTSL",nPosDist)
			EndIf
		Next nX
	EndIf

EndIf

FWRestRows(aSaveLines)
Return lRet

//=============================================================================
/*/{Protheus.doc} Cn100CFisT(oModel)
Função responsável por calcular o valor total do cronograma fisico 

@author israel.escorizza
@since 24/04/2018
@return
/*/
//=============================================================================

Function Cn100CFisT(oModel)
Local aArea			:= GetArea()
Local aSaveLines	:= FwSaveRows()
Local nX		:= 0
Local nValor	:= 0
Local oModelCNS	:= oModel:GetModel("CNSDETAIL")
Local oModelCNF	:= oModel:GetModel("CNFDETAIL")
Local oModelCNB := oModel:GetModel("CNBDETAIL")

For nX := 1 To oModelCNS:Length()
	oModelCNS:GoLine(nX)
	nValor += oModelCNS:GetValue('CNS_PRVQTD') * oModelCNB:GetValue('CNB_VLUNIT',nX) - (oModelCNB:GetValue('CNB_VLDESC',nX)/oModelCNB:GetValue('CNB_QUANT',nX))
Next nX

FWRestRows(aSaveLines)
RestArea(aArea)
Return Round(nValor,TamSX3("CNF_VLPREV")[2])

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CN110VisFis ³ Autor ³ Marcelo Custodio      ³ Data ³16.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exibe e permite carregar os valores previstos no cronograma  ³±±
±±³          ³ fisico no momento da medicao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do contrato                                  ³±±
±±³          ³ cExp02 - Codigo da revisao                                   ³±±
±±³          ³ cExp03 - Codigo da planilha                                  ³±±
±±³          ³ cExp04 - Competencia                                         ³±±
±±³          ³ oExp04 - Objeto getdados da medicao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA130                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN110VisFis(cContra,cRevisa,cPlan,cCompet,oGet,lVisu,cParcel)

Local oDlg
Local ogetFsc

Local lRet      := .F.

Local nx        := 0
Local ny        := 0
Local nPosCNE   := 0
Local nPosCNS   := 0
Local nPosQuant := 0
Local nPosSld   := 0
Local nPosSldMed:= 0
Local nPosItCNE := aScan(oGet:aHeader,{|x| AllTrim(x[2])=="CNE_ITEM"})
Local nOpca

Local cQuery    := ""
Local cAlias    := ""

Local aArea       := GetArea()
Local aSavaHeader := aClone(oGet:aHeader)
Local aStrucCNS   := CNS->(dbStruct())
Local aHeadParc   := {}
Local aColsParc   := {}

DEFAULT lVisu   := .F.
DEFAULT cParcel := ""

dbSelectArea("CNF")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta estrutura fisica              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CN110MtFsc(aHeadParc,.T.)

cAlias := GetNextAlias()
cQuery := "SELECT CNS.*,CNB.CNB_PRODUT,CNB.CNB_DESCRI,CNB.CNB_QUANT,CNB.R_E_C_N_O_ RECNOCNB "
cQuery += "  FROM "+RetSQLName("CNS")+" CNS, "+RetSQLName("CNA")+" CNA, "+RetSQLName("CNF")+" CNF , "+RetSQLName("CNB")+" CNB "
cQuery += " WHERE CNS.CNS_FILIAL = '"+xFilial("CNS")+"'"
cQuery += "   AND CNA.CNA_FILIAL = '"+xFilial("CNA")+"'"
cQuery += "   AND CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
cQuery += "   AND CNF.CNF_FILIAL = '"+xFilial("CNF")+"'"
cQuery += "   AND CNS.CNS_CONTRA = '"+cContra+"'"
cQuery += "   AND CNS.CNS_CONTRA = CNA.CNA_CONTRA "
cQuery += "   AND CNS.CNS_CONTRA = CNB.CNB_CONTRA "
cQuery += "   AND CNS.CNS_CONTRA = CNF.CNF_CONTRA "
cQuery += "   AND CNS.CNS_REVISA = '"+cRevisa+"' "
cQuery += "   AND CNS.CNS_REVISA = CNA.CNA_REVISA "
cQuery += "   AND CNS.CNS_REVISA = CNB.CNB_REVISA "
cQuery += "   AND CNS.CNS_REVISA = CNF.CNF_REVISA "
cQuery += "   AND CNA.CNA_NUMERO = '"+cPlan+"'"
cQuery += "   AND CNS.CNS_CRONOG = CNA.CNA_CRONOG "
cQuery += "   AND CNS.CNS_CRONOG = CNF.CNF_NUMERO "
cQuery += "   AND CNF.CNF_COMPET = '"+cCompet+"' AND "
If !Empty(cParcel)
	cQuery += " CNF.CNF_PARCEL = '"+cParcel+"' AND "
EndIf
cQuery += "       CNS.CNS_PARCEL = CNF.CNF_PARCEL "
cQuery += "   AND CNS.CNS_ITEM   = CNB.CNB_ITEM   "
cQuery += "   AND CNA.CNA_NUMERO = CNB.CNB_NUMERO "
cQuery += "   AND CNS.D_E_L_E_T_ = ' ' "
cQuery += "   AND CNA.D_E_L_E_T_ = ' ' "
cQuery += "   AND CNB.D_E_L_E_T_ = ' ' "
cQuery += "   AND CNF.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY CNS.CNS_ITEM "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

For nx:=1 to len(aStrucCNS)
	if (cAlias)->(FieldPos(aStrucCNS[nx,1])) > 0 .And. aStrucCNS[nx,2] <> "C"
		TCSetField( cAlias, aStrucCNS[nx,1], aStrucCNS[nx,2], aStrucCNS[nx,3], aStrucCNS[nx,4] )
	endif
Next
TCSetField(cAlias,"CNB_QUANT"  ,"N",TamSX3("CNB_QUANT")[1],TamSX3("CNB_QUANT")[2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ADHeadRec("CNB",aHeadParc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche os itens do cronograma fisico³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !(cAlias)->(Eof())
	For ny:=1 to len(oGet:aCols)
		If (cAlias)->CNS_ITEM == oGet:aCols[ny,nPosItCNE]
			aAdd(aColsParc,Array(len(aHeadParc)+1))

			For nx:=1 to len(aHeadParc)
				If	IsHeadRec(aHeadParc[nX,2])
					aColsParc[len(aColsParc),nx] := (cAlias)->RECNOCNB
				ElseIf IsHeadAlias(aHeadParc[nX,2])
					aColsParc[len(aColsParc),nx] := "CNB"
				ElseIf aHeadParc[nx,10] != "V"
					aColsParc[len(aColsParc),nx] := (cAlias)->&(aHeadParc[nX,2])
				Else
					Do Case
						Case aHeadParc[nx,2] == "CNS_PRODUT"//Preenche o codigo do produto
							aColsParc[len(aColsParc),nx] := (cAlias)->CNB_PRODUT
						Case aHeadParc[nx,2] == "CNS_DESCRI"//Preenche a descricao do produto
							aColsParc[len(aColsParc),nx] := (cAlias)->CNB_DESCRI
						Case aHeadParc[nx,2] == "CNS_TOTQTD"//Preenche a quantidade total
							aColsParc[len(aColsParc),nx] := (cAlias)->CNB_QUANT
						OtherWise
							aColsParc[len(aColsParc),nx] := CriaVar(aHeadParc[nx,2])
					EndCase
				EndIf
			Next
			aColsParc[len(aColsParc),(len(aHeadParc)+1)] := .F.
		EndIf
	Next

	(cAlias)->(dbSkip())
EndDo

(cAlias)->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta Dialog                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0072) FROM 009,000 TO 025,060 OF oMainWnd//"Cronograma Fisico"

@ 005, 005 SAY OemToAnsi(STR0081) PIXEL // "Cronograma Fisico"

ogetFsc := MsNewGetDados():New(013,005,100,232,0,,,,,,,,,,oDlg,aHeadParc,aColsParc)

DEFINE SBUTTON FROM 105, 203 TYPE 1 ACTION (oDlg:End()) ENABLE OF oDlg

If !lVisu
	@ 105,172 BUTTON OemToAnsi(STR0079) SIZE 29 ,13  ACTION (nOpca:=1,oDlg:End()) OF oDlg PIXEL//"Carregar"
EndIf
@ 105,203 BUTTON OemToAnsi(STR0080) SIZE 29 ,13  ACTION (nOpca:=2,oDlg:End()) OF oDlg PIXEL//"Fechar"

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza aCols da medicao           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols     := oGet:aCols
	nPosQuant := aScan(oGet:aHeader,{|x| AllTrim(x[2])=="CNE_QUANT"})
	nPosSld   := aScan(aHeadParc,{|x| AllTrim(x[2]) == "CNS_SLDQTD"})
	nPosSldMed:= aScan(oGet:aHeader,{|x| AllTrim(x[2])=="CNE_QTAMED"})
	For nx:=1 to len(aColsParc)
		If aColsParc[nx,nPosSld] <= oGet:aCols[nx,nPosSldMed]
			oGet:aCols[nx,nPosQuant] := If((aColsParc[nx,nPosSld]>0),aColsParc[nx,nPosSld],0)
		Else
			oGet:aCols[nx,nPosQuant] := oGet:aCols[nx,nPosSldMed]
		EndIf
		RunTrigger(2,nx,,,"CNE_QUANT ")
	Next
	oGet:aCols := aCols

	lRet := .T.
EndIf


oGet:aHeader:= aClone(aSavaHeader)
RestArea(aArea)
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CN110VldDt³ Autor ³ Marcelo Custodio      ³ Data ³11/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida data prevista                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN110VldDt()

Local oModel		:= FWModelActive()
Local oModelCNF	:= oModel:GetModel("CNFDETAIL")

Local lRet			:= .T.
Local lVldVige		:= GetNewPar("MV_CNFVIGE","N") == "N"
Local lDtCompet		:= SuperGetMV("MV_CNFDTCP",.F.,.T.)

Local nTot			:= oModelCNF:Length()
Local nAtual		:= oModelCNF:nLine

Local cCampo		:= Readvar()

Local dData		:= &(Readvar())
Local dInicio		:= FwFldGet("CN9_DTINIC")
Local dFim			:= FwFldGet("CN9_DTFIM")

Local aSaveLines	:= FWSaveRows()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a validação for por competência, aponta para o 1º dia do mes para fazer as comparações. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCampo == "M->CNF_COMPET"
	dData    :=	CtoD("01/"+dData)
	dInicio  := CtoD("01/"+StrZero(Month(dInicio),2)+"/"+StrZero(Year(dInicio),4))
	dFim	 := CtoD("01/"+StrZero(Month(dFim),2)+"/"+StrZero(Year(dFim),4))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a previsao ultrapassa a proxima parcela se houver  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nAtual < nTot )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a proxima parcela³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModelCNF:GoLine(nAtual+1)

	If 	( oModelCNF:GetValue("CNF_PRUMED") <= dData )
	  	lRet := .F.
	ElseIf ( oModelCNF:GetValue("CNF_DTVENC") <= dData )
	  	lRet := .F.
	ElseIf ( cCampo == "M->CNF_COMPET" .AND. CtoD("01/" + oModelCNF:GetValue("CNF_COMPET") ) < dData)
	  	lRet := .F.
	ElseIf lVldVige .AND. ( (dData < dInicio) .Or. (dData > dFim) )
	  	lRet := .F.
  	EndIf

 	oModelCNF:GoLine(nAtual)
 EndIf

If ( cCampo == "M->CNF_PRUMED" )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza data de vencimento e competencia da parcela  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lDtCompet
		FWFldPut("CNF_DTVENC" , dData )
	EndIf
	
	If Empty(oModelCNF:GetValue("CNF_COMPET")) .Or. lDtCompet
		oModelCNF:LoadValue("CNF_COMPET" , StrZero(Month(dData),2)+"/"+StrZero(Year(dData),4) )
	EndIf
		
EndIf

FWRestRows(aSaveLines)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CN110VldRlz ³ Autor ³ Felipe Bittar         ³ Data ³22.08.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida alteracao no valor realizado da parcela                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CN110VldRlz()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100 >>> X3_VALID do campo CNF_VLREAL                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN110VldRlz()
Local lRet := .T.
Local oModel	:= FwModelactive()
Local oModelCNF	:= oModel:GetModel("CNFDETAIL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se previsao e menor que realizado    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oModelCNF:GetValue('CNF_VLREAL') > oModelCNF:GetValue('CNF_VLPREV')
	lRet := .F.
	Aviso(STR0033,STR0082,{"OK"})//"Atencao"#"O valor realizado não pode ser maior do que o valor previsto!"
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CalcAvanco³ Autor ³ Felipe Toledo Bittar  ³ Data ³17/09/2008    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calcula quantidade de dias para avancar e obter a proxima      ³±±
±±³          ³ data prevista                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ nExp01 - Dias de avanco                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dExp01 - Data da parcela atual                                 ³±±
±±³ 	     ³ lExp02 - Ajusta data para o final quando passar no mes 02      ³±±
±±³          ³ lExp03 - Ajusta deslocamento do dia 29 quando passar no mes 02 ³±±
±±³ 	     ³ nExp04 - Data da primeira parcela							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CalcAvanco(dPrevista,lAjFim,lAjFev,nDia)
Local nMes      := 0
Local nAno      := 0
Local dDtAux

DEFAULT nDia    := Day(dPrevista)
DEFAULT lAjFim  := .F.
DEFAULT lAjFev  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se dia da data prevista não for 1º (exceto se a primeira parcela for dia 1º),³
//³ avança para o mês seguinte.                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Day(dPrevista)<>1 .Or. nDia == 1
    nMes := (Month(dPrevista)+1)
Else
	nMes := Month(dPrevista)
EndIf

nAno := year (dPrevista)

If nMes == 13
	nMes := 1
	nAno += 1
EndIf

dDtAux := cTod(strzero(nDia,2)+"/"+strzero(nMes,2)+"/"+str(nAno,4),"ddmmyyyy")

If Empty(dDtAux)  //Se data estiver vazia, obtém os primeiro dia do mês seguinte.
	If lAjFim
		nAvanco   := LastDay(CtoD("01/"+strzero(nMes,2)+"/"+str(nAno,4),"ddmmyyyy"))-dPrevista
	Else
		nAvanco   := LastDay(CtoD("01/"+strzero(nMes,2)+"/"+str(nAno,4),"ddmmyyyy"))+1-dPrevista
	EndIf
Else
	nAvanco   := dDtAux - dPrevista
EndIf

Return nAvanco

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CN110VlVnc³ Autor ³ Aline Sebrian         ³ Data ³22/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida data de vencimento                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN110VlVnc()
Local lRet			:= .T.
Local lVldVige		:= GetNewPar("MV_CNFVIGE","N") == "N"

Local nPosDtVct	:= 0
Local nTot			:= 0
Local nAtual		:= 0

Local dData		:= &(Readvar())
Local dInicio		:= CtoD("")
Local dFim			:= CtoD("")

Local oModel		:= FWModelActive()
Local oModelCNF	:= Nil
Local lMVC			:= ValType(oModel) <> "U"

Local aSaveLines	:= FWSaveRows()

If !lMVC
	nPosDtVct	:= aScan(oGetDados:aHeader,{ |x|  UPPER(AllTrim(x[2])) == "CNF_DTVENC"})
	nTot		:= len(oGetDados:aCols)
	nAtual     := oGetDados:OBROWSE:NAT
	dInicio	:= CN9->CN9_DTINIC
	dFim		:= CN9->CN9_DTFIM

Else
	oModelCNF	:= oModel:GetModel("CNFDETAIL")

	dInicio	:= FwFldGet("CN9_DTINIC")
	dFim		:= FwFldGet("CN9_DTFIM")
	nAtual		:= oModelCNF:nLine
	nTot		:= oModelCNF:Length()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a previsao ultrapassa a proxima parcela se houver  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldVige
	If (dData < dInicio)
		Aviso(OemToAnsi(STR0033),OemToAnsi(STR0097),{"Ok"})
		lRet := .F.
	EndIf

	If lRet .And. (dData > dFim)
		Aviso(OemToAnsi(STR0033),OemToAnsi(STR0098),{"Ok"})
		lRet := .F.
	EndIf

	If lRet .And. (nAtual < nTot)
		If !lMVC .AND.(oGetDados:aCols[nAtual+1,nPosDtVct] <= dData)
			Aviso(OemToAnsi(STR0033),OemToAnsi(STR0099),{"Ok"})
			lRet := .F.
		ElseIf lMVC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a proxima parcela³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oModelCNF:GoLine(nAtual+1)

			If !oModelCNF:IsDeleted() .And. oModelCNF:GetValue("CNF_DTVENC") <= dData
			  	lRet := .F.
			  	Aviso(OemToAnsi(STR0033),OemToAnsi(STR0099),{"Ok"})
		  	EndIf

		  	oModelCNF:GoLine(nAtual)
		EndIf
	EndIf
EndIf

FWRestRows(aSaveLines)
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CalcDiaCom³ Autor ³ Aline S Damasceno     ³ Data ³24/02/2012    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Define o dia para a competencia								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ nExp01 - Dias de avanco                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dExp01 - Data da parcela atual                                 ³±±
±±³ 	     ³ cExp02 - Competencia	atual									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CalcDiaCom(dPrevista,cCompete)
Local dDtAux

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o ultimo dia da data prevista for diferente da competenciaa, aponta para  ³
//³ o ultimo dia da competencia.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If LastDay(dPrevista) <> LastDay(CtoD("01/"+cCompete,"ddmmyy"))
    dDtAux := LastDay(CtoD("01/"+cCompete,"ddmmyy"))
Else
	dDtAux := CTOD(Str(Day(dPrevista))+"/"+cCompete)
EndIf


Return dDtAux
