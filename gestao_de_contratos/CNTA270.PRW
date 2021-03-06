#INCLUDE "CNTA270.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CN270VldDt� Autor � Aline Sebrian         � Data �26/10/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida data prevista do cronograma cont�bil.               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������������������������������������������Ŀ
//�Verifica se a previsao ultrapassa a proxima parcela se houver  �
//�����������������������������������������������������������������
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
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    |CN270VldVal � Autor � Marcelo Custodio      � Data �26.12.2005���
���������������������������������������������������������������������������Ĵ��
���Descri�ao �Valida alteracao no valor de parcela                          ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �CN270VldVal()                                                 ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � CNTA270                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
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
