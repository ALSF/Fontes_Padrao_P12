#INCLUDE "CNTA270.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CN270VldDt³ Autor ³ Aline Sebrian         ³ Data ³26/10/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida data prevista do cronograma contábil.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CN270VldDt()
Local lRet       := .T.
Local nPosDtPrv  := 0
Local nTot       := 0
Local nAtual     := 0
Local dData  	 := &(Readvar())
Local lVldVige   := GetNewPar("MV_CNFVIGE","N") == "N"
Local dInicio	 := CtoD("")
Local dFim	 	 := CtoD("")
Local oModel		:= FWModelActive()
Local oModelCNW		:= Nil
Local lMVC			:= ValType(oModel) <> "U"

If !lMVC
	nPosDtPrv  	:= aScan(oGetCtb:aHeader,{ |x|  UPPER(AllTrim(x[2])) == "CNW_DTPREV"})
	nTot       	:= len(oGetCtb:aCols)
	nAtual     	:= oGetCtb:OBROWSE:NAT
	dInicio	 	:= CN9->CN9_DTINIC
	dFim		:= CN9->CN9_DTFIM
Else
	oModelCNW 	:= oModel:GetModel("CNWDETAIL")

	nTot       	:= oModelCNW:Length()
	nAtual     	:= oModelCNW:nLine
	dInicio	 	:= FWFldGet("CN9_DTINIC")
	dFim		:= FWFldGet("CN9_DTFIM")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a previsao ultrapassa a proxima parcela se houver  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lMVC .AND. ( nAtual < nTot .And. oGetCtb:aCols[nAtual+1,nPosDtPrv] <= dData .Or. ;
	(lVldVige .And. (dData < dInicio .Or. dData > dFim)) )
	lRet := .F.

ElseIf lMVC

	If (nAtual < nTot)

		oModelCNW:GoLine( nAtual+1 )

		If oModelCNW:GetValue("CNW_DTPREV") <= dData
			lRet := .F.
		EndIf

		oModelCNW:GoLine( nAtual )

	ElseIf lVldVige .AND. ( dData < dInicio .OR. dData > dFim )
		lRet := .F.
	EndIf

EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CN270VldVal ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida alteracao no valor de parcela                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CN270VldVal()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA270                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CN270VldVal()
Local lRet := .T.
Local nPos1 := 0
Local oModel		:= FWModelActive()
Local lMVC			:= ValType(oModel) <> "U"

If !lMVC
	aScan(oGetCtb:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNW_VLPREV"})

	o:bEditCol := { || CN270AtuVal()}//Atualiza montante
EndIf

Return lRet
