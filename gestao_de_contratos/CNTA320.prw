#include 'protheus.ch'
#include 'parmtype.ch'
#include 'CNTA320.ch'

//=============================================================================
/*/{Protheus.doc}  CNTA320
Efetua ajustes dos saldos do contrato

@author janaina.jesus
@since 24/07/2018
@version 1.0
/*/
//=============================================================================
Function CNTA320()
Local aLog       := {}
Local cLog       := ""

If MsgYesNo( STR0005, STR0001 ) //"Esta rotina efetua ajustes de saldos do contrato, das planilhas, dos itens e dos cronogramas com base nas medições realizadas até o momento. Processo será realizado apenas para contrato com Medição Eventual igual a Não. Deseja prosseguir?" 

	If Pergunte("CNTA320",.T.)
		processa({||aLog:= AjustaSaldos(), STR0001, STR0002})
		
		cLog:= MontaLog(aLog)
			
		If cLog == ""
			Aviso("CNTA320", STR0003)
		Else		
			GCTLog(cLog, STR0004, 1, .T.)
		EndIf
				
	EndIf
EndIf

return

//=============================================================================
/*/{Protheus.doc}  AjustaSaldos
Ajusta os campos CNA_SALDO e CN9_SALDO, com base nas medições realizadas para 
os itens da planilha.

@return aLog, Array, array com os contratos processados
@author janaina.jesus
@since 24/07/2018
@version 1.0
/*/
//=============================================================================
Function AjustaSaldos()
Local cAliasCNA  := GetNextAlias()
Local cAliasCNAP := GetNextAlias()
Local cContrato  := ""
Local cRevisa    := ""
Local cContraPos := ""
Local cLog       := ""
Local cRev       := ""
Local nCNASaldo  := 0
Local nNewSaldo  := 0
Local nDifSaldo  := 0
Local nX         := 1
Local nY         := 1
Local lAjustou   := .F.
Local aLog       := {}

BeginSql Alias cAliasCNA

	SELECT 	*
	FROM 	%table:CNA% CNA
	WHERE	CNA.CNA_FILIAL = %xFilial:CNA% AND
			CNA.CNA_CONTRA >= %exp:MV_PAR01% AND
			CNA.CNA_CONTRA <= %exp:MV_PAR02% AND
			CNA.%NotDel%
			ORDER BY
			CNA.CNA_CONTRA	
EndSQL

dbSelectArea("CNA")
dbSetOrder(1)

dbSelectArea("CN9")
dbSetOrder(1)

ProcRegua( (cAliasCNA)->(LastRec()) )
While (cAliasCNA)->(!EOF())
	IncProc()	
	cRev:= MdRevAtu((cAliasCNA)->CNA_CONTRA)
		
	If (cAliasCNA)->CNA_CONTRA + (cAliasCNA)->CNA_REVISA == (cAliasCNA)->CNA_CONTRA + cRev	.And. !CN300RetSt("MEDEVE",0,(cAliasCNA)->CNA_NUMERO,(cAliasCNA)->CNA_CONTRA,,.F.)	

		cContrato := (cAliasCNA)->CNA_CONTRA
		cRevisa   := (cAliasCNA)->CNA_REVISA
		If nY == 1	
			aadd(aLog, {cContrato, cRevisa, "", 0 , 0, {}, lAjustou})
		EndIf
		aadd(aLog[nX][6], {cContrato, cRevisa, (cAliasCNA)->CNA_NUMERO, (cAliasCNA)->CNA_FORNEC, (cAliasCNA)->CNA_SALDO, 0, {}, {}})
		
		conout("Contrato: " + (cAliasCNA)->CNA_CONTRA + "Revisão: " + (cAliasCNA)->CNA_REVISA + "Planilha: " + (cAliasCNA)->CNA_NUMERO + "nX: " + cValtoChar(nX) + "nY: " + cValtoChar(ny))
		nNewSaldo := CalcSaldo((cAliasCNA)->CNA_CONTRA,(cAliasCNA)->CNA_REVISA,(cAliasCNA)->CNA_NUMERO, @aLog[nX][6][nY], @lAjustou)
		nDifSaldo := nNewSaldo - (cAliasCNA)->CNA_SALDO 
		
		If ABS(nDifSaldo) > 0.02
									
			If CNA->(dbSeek(xFilial('CNA')+(cAliasCNA)->CNA_CONTRA+(cAliasCNA)->CNA_REVISA+(cAliasCNA)->CNA_NUMERO))
				RecLock( "CNA", .F. )
				nCNASaldo:= CNA->CNA_SALDO += nDifSaldo
				CNA->( MsUnlock() )
				lAjustou := .T.
				aLog[nX][6][nY][6]+= nCNASaldo
			EndIf
			
		Else			
			aLog[nX][6][nY][6]+= (cAliasCNA)->CNA_SALDO								
		EndIf		
		
		ReajuCrono((cAliasCNA)->CNA_CONTRA, (cAliasCNA)->CNA_REVISA, (cAliasCNA)->CNA_NUMERO, @aLog[nX][6][nY], @lAjustou)			
		
		aLog[nX][7]:= lAjustou
				
		
		
		(cAliasCNA)->(dbSkip())
		cContraPos:= (cAliasCNA)->CNA_CONTRA+(cAliasCNA)->CNA_REVISA
		nY++
		If cContraPos != cContrato+cRevisa
			
			BeginSql Alias cAliasCNAP
			
				SELECT SUM (CNA.CNA_SALDO) CNA_SALDO
				FROM %table:CNA% CNA
				WHERE
				CNA.CNA_CONTRA = %exp:cContrato% AND
				CNA.CNA_REVISA = %exp:cRevisa% AND
				CNA.%NotDel%
			EndSql
		
			If CN9->(dbSeek(xFilial('CN9')+cContrato+cRevisa)) 	
				aLog[nX][3]:= CN9->CN9_TPCTO
				aLog[nX][4]:= CN9->CN9_SALDO
				
				If CN9->CN9_SALDO !=	 (cAliasCNAP)->CNA_SALDO
					RecLock( "CN9", .F. )
					CN9->CN9_SALDO := (cAliasCNAP)->CNA_SALDO	
					CN9->( MsUnlock() )
					lAjustou:= .T.
						
					aLog[nX][5]:= (cAliasCNAP)->CNA_SALDO
				Else
					aLog[nX][5]:= CN9->CN9_SALDO
				EndIf
									
			EndIf
			
			nX++
			nY:= 1	
			lAjustou := .F.		
			
			(cAliasCNAP)->(dbCloseArea())
					
		EndIf
	Else
		(cAliasCNA)->(dbSkip())
	EndIf
	
EndDo

(cAliasCNA)->(dbCloseArea())

Return aLog

//=============================================================================
/*/{Protheus.doc}  CalcSaldo
Calcula o saldo dos itens da planilha e efetua ajuste dos itens na CNB

@param cContra, character, Número do contrato
@param cRev, character, Revisão do contrato
@param cPlan, character, Planilha do contrato
@param aLog, array, Dados dos contratos processados
@param lAjustou, logico, verifica se houver ajuste

@return nSaldo, numerico, saldo da planilha

@author janaina.jesus
@since 24/07/2018
@version 1.0
/*/
//=============================================================================
Static Function CalcSaldo(cContra, cRev, cPlan, aLog, lAjustou)
Local nSaldo     := 0
Local nSldItem   := 0
Local nSldQtd    := 0
Local nQtdMed    := 0
Local nI         := 1
Local nDifQdt    := 0
Local nDifSld    := 0
Local cItem      := ""
Local cAliasCNB  := GetNextAlias()

Default aLog := {}
Default lAjustou := .F.

BeginSql Alias cAliasCNB

	SELECT 	*
	FROM 	%table:CNB% CNB
	WHERE	CNB.%NotDel% AND
			CNB.CNB_FILIAL = %xFilial:CNB% AND
			CNB.CNB_CONTRA = %exp:cContra% AND
			CNB.CNB_REVISA = %exp:cRev% AND
			CNB.CNB_NUMERO = %exp:cPlan% 

EndSQL

dbSelectArea("CNB")
dbSetOrder(1)

While (cAliasCNB)->(!EOF())
	IncProc()
	cItem		:= (cAliasCNB)->CNB_ITEM
	nQtdMed	:= QuantMed(cContra, cRev, cPlan, cItem,(cAliasCNB)->CNB_VLTOT, (cAliasCNB)->CNB_QUANT)
	nSldQtd	:= (cAliasCNB)->CNB_QUANT - nQtdMed
	nSldItem	:= nSldQtd * (cAliasCNB)->CNB_VLUNIT
	nQtdMed	:= Round(nQtdMed, TamSx3("CNB_QTDMED")[2])
	nDifQdt	:= nQtdMed - (cAliasCNB)->CNB_QTDMED
	nDifSld	:= nSldQtd - (cAliasCNB)->CNB_SLDMED
	
	If nSldItem > 0 
		nSaldo += nSldItem
	EndIf
	
	aadd(aLog[7], {(cAliasCNB)->CNB_ITEM, (cAliasCNB)->CNB_PRODUT, (cAliasCNB)->CNB_DESCRI, (cAliasCNB)->CNB_QTDMED, (cAliasCNB)->CNB_SLDMED, 0, 0})
	
	If nQtdMed < 0
		nQtdMed := 0
	EndIf
	If nSldQtd < 0
		nSldQtd := 0
	EndIf
	
	If ABS(nDifQdt) > 0.001 .Or. ABS(nDifSld) > 0.001 .And. ((cAliasCNB)->CNB_QTDMED != nQtdMed .Or. (cAliasCNB)->CNB_SLDMED != nSldQtd )

		If CNB->( dbSeek( xFilial('CNB') + (cAliasCNB)->CNB_CONTRA + (cAliasCNB)->CNB_REVISA + (cAliasCNB)->CNB_NUMERO + (cAliasCNB)->CNB_ITEM ) )
			
			RecLock( "CNB", .F. )
			CNB->CNB_QTDMED := nQtdMed
			CNB->CNB_SLDMED := nSldQtd
			CNB->( MsUnlock() )
			lAjustou := .T.
			
			aLog[7][nI][6]:= nQtdMed	//Quantidade Medida		
			aLog[7][nI][7]:= nSldQtd //Quantidade a Medir
			
		EndIf	
	Else						
		aLog[7][nI][6]:= (cAliasCNB)->CNB_QTDMED	//Quantidade Medida		
		aLog[7][nI][7]:= (cAliasCNB)->CNB_SLDMED //Quantidade a Medir		
	EndIf

	(cAliasCNB)->(dbSkip())
	nI++
End

(cAliasCNB)->(dbCloseArea())

return nSaldo

//=============================================================================
/*/{Protheus.doc} QuantMed
Retorna a quantidade medida do item da planilha

@param cContra, character, Número do contrato
@param cRev, character, Revisão do contrato
@param cPlan, character, Planilha do contrato
@param cItem, character, Item da planilha
@param nTotItem, numerico, Valor total do item no contrato
@param nQtdItem, numerico, Quantidade total do item no contrato

@return nQtdMed, numérico, Quatidade medida do item do contrato
    
@author janaina.jesus
@since 24/07/2018
@version 1.0
/*/
//============================================================================
Function QuantMed(cContra, cRev, cPlan, cItem, nTotItem, nQtdItem)
Local aArea      := GetArea()
Local cAliasCNE  := GetNextAlias()
Local nQtdMed    := 0
Local cWhere     := ""

cWhere += "AND CNE.CNE_CONTRA = '" + cContra + "' "
cWhere += "AND CNE.CNE_REVISA = '" + cRev + "' "
cWhere += "AND CNE.CNE_NUMERO = '" + cPlan + "' "
cWhere += "AND CNE.CNE_ITEM = '" + cItem + "' "
cWhere += "AND CND.CND_DTFIM != ''"

	
cWhere := '%'+cWhere+'%'

BeginSql Alias cAliasCNE

	SELECT CND.CND_SERVIC, CNE.CNE_QUANT, CNE.CNE_VLTOT
	FROM 	%table:CNE% CNE
	INNER JOIN %table:CND% CND ON
		CNE.CNE_FILIAL = CND.CND_FILIAL AND 
		CNE.CNE_CONTRA = CND.CND_CONTRA AND 
		CNE.CNE_REVISA = CND.CND_REVISA AND 
		CNE.CNE_NUMMED = CND.CND_NUMMED 
	WHERE	CNE.CNE_FILIAL = %xFilial:CNE% AND
			CNE.%NotDel% AND
			CND.%NotDel%
			%exp:cWhere%

EndSQL

While (cAliasCNE)->(!EOF()) 

	If (cAliasCNE)->CND_SERVIC == "1"
		nQtdMed += (cAliasCNE)->CNE_QUANT		
	Else	
		nQtdMed += ( ( (cAliasCNE)->CNE_VLTOT / nTotItem ) * nQtdItem )	
	EndIf
	(cAliasCNE)->(dbSkip())
EndDo

(cAliasCNE)->(dbCloseArea())

RestArea(aArea)
Return nQtdMed

//=============================================================================
/*/{Protheus.doc} ReajuCrono
Efetua o ajuste do saldo do cronograma financeiro do contrato.

@param cContra, character, Número do contrato
@param cRev, character, Revisão do contrato
@param cPlan, character, Planilha do contrato
@param cItem, character, Item da planilha
@param aLog, array, Dados dos contratos processados
@param lAjustou, logico, verifica se houver ajuste

@return nQtdMed, numérico, Quatidade medida do item do contrato
    
@author janaina.jesus
@since 24/07/2018
@version 1.0
/*/
//============================================================================
Function ReajuCrono(cContra, cRev, cPlan, aLog, lAjustou)
Local cAliasCNF  := GetNextAlias()
Local nSaldo     := 0
Local nDifSaldo  := 0
Local nVlrMed    := 0
Local nX         := 1

Default aLog := {}
Default lAjustou := .F.

BeginSql Alias cAliasCNF

	SELECT 	*
	FROM 	%table:CNF% CNF
	WHERE	CNF.%NotDel% AND
			CNF.CNF_FILIAL = %xFilial:CNF% AND
			CNF.CNF_CONTRA = %exp:cContra% AND
			CNF.CNF_REVISA = %exp:cRev% AND
			CNF.CNF_NUMPLA = %exp:cPlan% 
			ORDER BY
			CNF.CNF_PARCEL

EndSQL

dbSelectArea("CNF")
dbSetOrder(3) //CNF_FILIAL+CNF_CONTRA+CNF_REVISA+CNF_NUMERO+CNF_PARCEL                                                                                                                                                                                                                 

While (cAliasCNF)->(!EOF())
	
	nVlrMed := CN320VlrMed(cContra, cRev, cPlan, (cAliasCNF)->CNF_COMPET)
	nSaldo := ((cAliasCNF)->CNF_VLPREV - (cAliasCNF)->CNF_VLREAL)
	nDifSaldo:= (cAliasCNF)->CNF_SALDO - nSaldo
	
	aadd(aLog[8], {(cAliasCNF)->CNF_PARCEL, (cAliasCNF)->CNF_SALDO, 0, (cAliasCNF)->CNF_VLREAL,0})
	
	If (cAliasCNF)->CNF_VLREAL <> nVlrMed
		
		If CNF->(dbSeek(xFilial('CNF')+(cAliasCNF)->CNF_CONTRA+(cAliasCNF)->CNF_REVISA+(cAliasCNF)->CNF_NUMERO+(cAliasCNF)->CNF_PARCEL))
			RecLock( "CNF", .F. )
			CNF->CNF_VLREAL := nVlrMed
			nSaldo := CNF->CNF_VLPREV - CNF->CNF_VLREAL
			CNF->CNF_SALDO := nSaldo
			CNF->( MsUnlock() )
			
			aLog[8][nX][3] := nSaldo
			aLog[8][nX][5] := nVlrMed
						
			lAjustou := .T.
		EndIf
	ElseIf ABS(nDifSaldo) > 0.02
													
		If CNF->(dbSeek(xFilial('CNF')+(cAliasCNF)->CNF_CONTRA+(cAliasCNF)->CNF_REVISA+(cAliasCNF)->CNF_NUMERO+(cAliasCNF)->CNF_PARCEL))
			RecLock( "CNF", .F. )
			CNF->CNF_SALDO := nSaldo
			CNF->( MsUnlock() )
			
			aLog[8][nX][3] := nSaldo
			
			lAjustou := .T.
		EndIf	
			
	Else			
		aLog[8][nX][3] := (cAliasCNF)->CNF_SALDO						
	EndIf	
	nX++
	(cAliasCNF)->(dbSkip())
	
EndDo
(cAliasCNF)->(dbCloseArea())

Return 

//=============================================================================
/*/{Protheus.doc} CN320VlrMed
Retorna o valor total medido pela competencia.

@param cContra, character, Número do contrato
@param cRev, character, Revisão do contrato
@param cPlan, character, Planilha do contrato
@param cCompet, character, Competência do Cronograma

@return nVlrMed, numérico, Valor medido na competencia do Cronograma Financeiro.
    
@author janaina.jesus
@since 24/07/2018
@version 1.0
/*/
//============================================================================
Function CN320VlrMed(cContra, cRev, cPlan, cCompet)
Local cAliasCND  := GetNextAlias()
Local nVlrMed    := 0
Local aArea      := GetArea()

BeginSql Alias cAliasCND

		SELECT 	SUM (CND_VLTOT) CND_VLTOT
			FROM 	%table:CND% CND
			
			INNER JOIN %table:CNF% CNF ON
			CND.CND_FILIAL = CNF.CNF_FILIAL AND
			CND.CND_CONTRA = CNF.CNF_CONTRA AND
			CND.CND_REVISA = CNF.CNF_REVISA AND
			CND.CND_COMPET = CNF.CNF_COMPET
			
			INNER JOIN %table:CXJ% CXJ ON 
			CND.CND_FILIAL = CXJ.CXJ_FILIAL	AND
			CND.CND_CONTRA = CXJ_CONTRA 	AND
			CND.CND_NUMMED = CXJ.CXJ_NUMMED	AND
			CNF.CNF_NUMPLA = CXJ.CXJ_NUMPLA
			
			WHERE	CND.CND_DTFIM <> '' 				AND
					CND.CND_FILIAL = %xFilial:CND% 	AND
					CND.CND_CONTRA = %exp:cContra% 	AND
					CND.CND_REVISA = %exp:cRev%  	AND
					CND.CND_COMPET = %exp:cCompet%	AND
					CNF.CNF_NUMPLA = %exp:cPlan% 	AND
					CND.%NotDel% AND
					CNF.%NotDel% AND
					CXJ.%NotDel%
		UNION ALL
		SELECT 	SUM (CND_VLTOT) CND_VLTOT
			FROM 	%table:CND% CND
			
			INNER JOIN %table:CNF% CNF ON
			CND.CND_FILIAL = CNF.CNF_FILIAL AND
			CND.CND_CONTRA = CNF.CNF_CONTRA AND
			CND.CND_REVISA = CNF.CNF_REVISA AND
			CND.CND_COMPET = CNF.CNF_COMPET AND
			CND.CND_NUMERO = CNF.CNF_NUMPLA
						
			WHERE	CND.CND_DTFIM <> '' 				AND
					CND.CND_FILIAL = %xFilial:CND% 	AND
					CND.CND_CONTRA = %exp:cContra% 	AND
					CND.CND_REVISA = %exp:cRev%  	AND
					CND.CND_COMPET = %exp:cCompet%	AND
					CNF.CNF_NUMPLA = %exp:cPlan% 	AND
					CND.%NotDel% AND
					CNF.%NotDel%		

EndSQL

While (cAliasCND)->(!EOF())
	nVlrMed += (cAliasCND)->CND_VLTOT
	(cAliasCND)->(dbSkip())
EndDo

(cAliasCND)->(dbCloseArea())

RestArea(aArea)

Return nVlrMed

//=============================================================================
/*/{Protheus.doc} MontaLog
Retorna a quantidade medida do item da planilha

@param aLog, array, Dados dos contratos processados

@return cLog, character, Log a ser exibido para o usuário
    
@author janaina.jesus
@since 25/07/2018
@version 1.0
/*/
//============================================================================
Function MontaLog(aLog)
Local cLog       := ""
Local nX         := 0 //Contratos
Local nY         := 0 //Planilhas
Local nW         := 0 //Itens
Local nZ         := 0 //Cronograma
Local nContratos := 0

Default aLog:= {}

nContratos:= Len(aLog)

For nX:= 1 To nContratos

	If aLog[nX][7]
	
		cLog += "___________________________________ Contratos ___________________________________" + CRLF
		cLog += "Contrato | Revisão | Tp Contr. | Saldo Anterior | Saldo Atual" + CRLF
		cLog += aLog[nX][1] + " | " + aLog[nX][2] + " | " + aLog[nX][3] + " | " + cValToChar(aLog[nX][4]) + " | " + cValToChar(aLog[nX][5]) + CRLF
		
		For nY:= 1 To Len(aLog[nX][6])
			cLog += "____________________________________ Planilha ____________________________________" + CRLF
			cLog += "Contrato | Revisão | Planilha | Cod. Fornecedor | Saldo Anterior | Saldo Atual" + CRLF
			cLog += aLog[nX][6][nY][1] + " | " + aLog[nX][6][nY][2] + " | " + aLog[nX][6][nY][3] + " | " + aLog[nX][6][nY][4] + " | " + cValToChar(aLog[nX][6][nY][5]) + " | " + cValToChar(aLog[nX][6][nY][6]) + CRLF
			cLog += "  _____________________________________ Itens ____________________________________" + CRLF
			cLog += "  Item | Cod Prod | Descrição | Qtd Med Anterior | Sld Med Anterior | Qtd Med Atual | Sld Med Atual" + CRLF
			
			For nW:= 1 to Len(aLog[nX][6][nY][7])
				cLog += "  " + aLog[nX][6][nY][7][nW][1] + " | " + aLog[nX][6][nY][7][nW][2] + " | " + aLog[nX][6][nY][7][nW][3] + " | " + cValToChar(aLog[nX][6][nY][7][nW][4]) + " | " + cValToChar(aLog[nX][6][nY][7][nW][5]) +  " | " +;
							cValToChar(aLog[nX][6][nY][7][nW][6]) + " | " + cValToChar(aLog[nX][6][nY][7][nW][7]) + CRLF  
			Next nW
			
			cLog += "  __________________________________ Cronograma _________________________________" + CRLF
			cLog += "  Parcela | Saldo Anterior | Saldo Atual|Vlr Realizando Anterior| Vlr Realizado Atual" + CRLF
			
			For nZ:= 1 to Len(aLog[nX][6][nY][8])
				cLog += "  " + aLog[nX][6][nY][8][nZ][1] + " | " + cValToChar(aLog[nX][6][nY][8][nZ][2]) + " | " + cValToChar(aLog[nX][6][nY][8][nZ][3]) + " | " + cValToChar(aLog[nX][6][nY][8][nZ][4]) + " | " + cValToChar(aLog[nX][6][nY][8][nZ][5]) +CRLF  
			Next nZ
			
		Next nY
		
		cLog += CRLF + "+=======================================================================================================+" + CRLF + CRLF
		
	EndIf
	
Next nX

Return cLog