#INCLUDE "CNTR040.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE ATOTAL   1
#DEFINE ADESCONT 2
#DEFINE AMULTAS  3
#DEFINE AVLBRUT  4
#DEFINE ARETENC  5
#DEFINE AIRRF    6
#DEFINE AISS     7
#DEFINE AINSS    8
#DEFINE APIS     9
#DEFINE ACOFIN   10
#DEFINE ACSLL    11
#DEFINE AVLLIQ   12
#DEFINE ABONIF   13

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณAndre Anjos         บ Data ณ  26/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime boletim da medicao.									บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CNTR040()
Local oReport := NIL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                       |
//| mv_par01     // Medicao de:                                |
//| mv_par02     // Medicao ate:	                            |
//ณ mv_par03     // Contrato de:                               ณ
//ณ mv_par04     // Contrato ate:                              ณ
//ณ mv_par05     // Data Inicio:                               ณ
//ณ mv_par06     // Data Fim:                                  ณ
//ณ mv_par07     // Situacao de:                               ณ
//ณ mv_par08     // Situacao ate:                              ณ
//ณ mv_par09     // Fornecedor de:                             ณ
//ณ mv_par10     // Fornecedor ate:                            ณ
//ณ mv_par11     // Tipo de Contrato?:                         ณ
//ณ mv_par12     // %IRRF											ณ
//ณ mv_par13     // %ISS												ณ
//ณ mv_par14     // %INSS											ณ
//ณ mv_par15     // Cliente de:  					             	ณ
//ณ mv_par16     // Cliente ate:									ณ
//ณ mv_par17     // Revisใo de:  					              ณ
//ณ mv_par18     // Revisใo ate:									ณ
//ณ mv_par19     // Data de referencia								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte("CNR040",.F.)
oReport := ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportDef บAutor  ณAndre Anjos         บ Data ณ  26/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Define estrutura do relatorio de Boletim de Medi็ใo.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR030                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport	:= TReport():New("CNTR040",STR0016,"CNR040",{|oReport| ReportPrin(oReport)},STR0002+STR0003+STR0004)
Local oSecMed	:= TRSection():New(oReport,STR0017,{"CND"},,,,,,,,.T.) //-- Medi็ใo
Local oSecIMe	:= TRSection():New(oSecMed,STR0075,{"CNE"}) //-- Itens da Medi็ใo
Local oSecTot	:= TRSection():New(oSecMed,STR0077) //-- "Totalizadores"

oSecMed:lHeaderVisible := .T.
TRCell():New(oSecMed,"CND_NUMMED","CND",STR0015)
TRCell():New(oSecMed,"CND_CONTRA","CND",STR0018)
TRCell():New(oSecMed,"CND_REVISA","CND",STR0073)
TRCell():New(oSecMed,"CND_NUMERO","CND",STR0019)
TRCell():New(oSecMed,"FORCLI"," ",STR0076,,TamSX3("A1_COD")[1],,{|| If(Empty(SECMED->CND_FORNEC),SECMED->CND_CLIENT,SECMED->CND_FORNEC)})
TRCell():New(oSecMed,"LJFORCLI"," ",RetTitle("A1_LOJA"),,TamSX3("A1_LOJA")[1],,{|| If(Empty(SECMED->CND_LJFORN),SECMED->CND_LOJACL,SECMED->CND_LJFORN)})
TRCell():New(oSecMed,"NOMEFC"," ",RetTitle("A1_NOME"),,TamSX3("A1_NOME")[1],,{|| If(Empty(SECMED->CND_FORNEC),;
													Posicione("SA1",1,xFilial("SA1")+SECMED->(CND_CLIENT+CND_LOJACL),"A1_NOME"),;
													Posicione("SA2",1,xFilial("SA2")+SECMED->(CND_FORNEC+CND_LJFORN),"A2_NOME")) })
TRCell():New(oSecMed,"CN9_VLATU","CN9",STR0021)
TRCell():New(oSecMed,"CN9_DTFIM","CN9",STR0022)
TRCell():New(oSecMed,"CND_COMPET","CND",STR0023)
TRCell():New(oSecMed,"CND_DTFIM","CND",STR0024)

oSecIMe:lHeaderVisible := .T.
TRCell():New(oSecIMe,"CNE_ITEM","CNE",STR0025)
TRCell():New(oSecIMe,"CNE_PRODUT","CNE",STR0026)
TRCell():New(oSecIMe,"B1_DESC","SB1",STR0027)
TRCell():New(oSecIMe,"B1_UM","SB1",STR0028)
TRCell():New(oSecIMe,"CNE_VLUNIT","CNE",STR0029,,,,{|| xMoeda(SECIME->CNE_VLUNIT,SECMED->CND_MOEDA,1,If(Empty(mv_par19),dDataBase,mv_par19),TamSX3("CNE_VLUNIT")[2])})
TRCell():New(oSecIMe,"CNE_QTDSOL","CNE",STR0030)
TRCell():New(oSecIMe,"QACUMUL","CNE",STR0031,PesqPict("CNB","CNB_QTDMED"),,,{|| SECIME->(CNE_QTDSOL-CNE_QTAMED)})
TRCell():New(oSecIMe,"CNE_QUANT","CNE",STR0032)
TRCell():New(oSecIMe,"QACUTOT"," ",STR0033,PesqPict("CNB","CNB_QTDMED"),,,{|| SECIME->(CNE_QTDSOL-CNE_QTAMED+CNE_QUANT)})
TRCell():New(oSecIMe,"VACUMUL"," ",STR0034,PesqPict("CND","CND_VLTOT"),TamSX3("CND_VLTOT")[1],,;
	{|| xMoeda(SECIME->((CNE_QTDSOL-CNE_QTAMED)*CNE_VLUNIT),SECMED->CND_MOEDA,1,If(Empty(mv_par19),dDataBase,mv_par19),TamSX3("CNB_VLTOT")[2])})
TRCell():New(oSecIMe,"CNE_VLTOT","CNE",STR0035,,,,{|| xMoeda(SECIME->CNE_VLTOT,SECMED->CND_MOEDA,1,If(Empty(mv_par19),dDataBase,mv_par19),TamSX3("CNE_VLTOT")[2])})
TRCell():New(oSecIMe,"VACUTOT"," ",STR0036,PesqPict("CND","CND_VLTOT"),TamSX3("CND_VLTOT")[1],,;
	{|| xMoeda(SECIME->((CNE_QTDSOL-CNE_QTAMED+CNE_QUANT)*CNE_VLUNIT),SECMED->CND_MOEDA,1,If(Empty(mv_par19),dDataBase,mv_par19),TamSX3("CNB_QTDMED")[2])})

TRCell():New(oSecTot,"TEXTO"," ",STR0077,,40) //-- Totalizadores
TRCell():New(oSecTot,"VALACU"," ",STR0034,PesqPict("CND","CND_VLTOT"),TamSX3("CND_VLTOT")[1])
TRCell():New(oSecTot,"VALMED"," ",STR0035,PesqPict("CND","CND_VLTOT"),TamSX3("CND_VLTOT")[1])
TRCell():New(oSecTot,"VALACT"," ",STR0036,PesqPict("CND","CND_VLTOT"),TamSX3("CND_VLTOT")[1])

oSecMed:SetTotalInLine(.F.)
oSecIMe:SetTotalInLine(.F.)
oSecTot:SetReadOnly(.T.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |ReportPrinบAutor  ณAndre Anjos         บ Data ณ  26/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao do relatorio de medi็๕es.		                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR030                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrin(oReport)
Local nX		:= 0
Local nValAcu	:= 0
Local nValMed	:= 0
Local nValAct	:= 0
Local nDesAcum	:= 0
Local nDesMed	:= 0
Local nMulAcum	:= 0
Local nMulMed	:= 0
Local nBonAcum	:= 0
Local nBonMed	:= 0
Local nLiqAcu	:= 0
Local nLiqMed	:= 0
Local nLiqAct	:= 0
Local nRegs	:= 0
Local aValImp := {0,0,0}
Local dDataRef	:= If(Empty(mv_par19),dDataBase,mv_par19)
Local oSecMed	:= oReport:Section(1)
Local oSecIMe	:= oSecMed:Section(1)
Local oSecTot	:= oSecMed:Section(2)
Local cExpFil := "%"

MakeSqlExp("CNR040")

cExpFil += "CND.CND_FILCTR = CN9.CN9_FILCTR AND%"

//-- Monta query da se็ใo de medi็๕es
oSecMed:BeginQuery()
BeginSQL Alias "SECMED"

SELECT CND.*, CN9.*
FROM %Table:CND% CND
JOIN %Table:CN9% CN9 ON
	CN9.%NotDel% AND
	CN9.CN9_FILIAL = %xFilial:CN9% AND
	CN9.CN9_NUMERO = CND.CND_CONTRA AND
	CN9.CN9_REVISA = CND.CND_REVISA AND
	CN9.CN9_NUMERO BETWEEN %Exp:mv_par03% AND %Exp:mv_par04% AND
	CN9.CN9_REVISA BETWEEN %Exp:mv_par17% AND %Exp:mv_par18% AND
	CN9.CN9_DTINIC BETWEEN %Exp:DToS(mv_par05)% AND %Exp:DToS(mv_par06)% AND
	CN9.CN9_SITUAC BETWEEN %Exp:mv_par07% AND %Exp:mv_par08% AND
	(%Exp:mv_par11% = %Exp:CriaVar("CN9_TPCTO",.F.)% OR CN9.CN9_TPCTO = %Exp:mv_par11%)
WHERE CND.%NotDel% AND
	%Exp:cExpFil%
	CND.CND_NUMMED BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
	(CND.CND_FORNEC = %Exp:CriaVar("CND_FORNEC",.F.)% OR CND.CND_FORNEC BETWEEN %Exp:mv_par09% AND %Exp:mv_par10%) AND
	(CND.CND_CLIENT = %Exp:CriaVar("CND_CLIENT",.F.)% OR CND.CND_CLIENT BETWEEN %Exp:mv_par15% AND %Exp:mv_par16%)

EndSQL
oSecMed:EndQuery()

SECMED->(dbEval({|| nRegs++}))

oReport:SetMeter(nRegs)

TRPosition():New(oSecMed,"CN1",1,{|| xFilial("SB1")+SECMED->CN9_TPCTO})
TRPosition():New(oSecIMe,"SB1",1,{|| xFilial("SB1")+SECIME->CNE_PRODUT})

SECMED->(dbGoTop())
While !SECMED->(EOF())
	oReport:IncMeter()

	oSecMed:Init()
	oSecMed:PrintLine()

	nValAcu := 0
	nValMed := 0
	nValAct := 0

	//-- Monta query da se็ใo de itens da medi็ใo
	oSecIMe:BeginQuery()
	BeginSQL Alias "SECIME"

	SELECT CNE.*
	FROM %Table:CNE% CNE
	WHERE CNE.%NotDel% AND
	CNE.CNE_FILIAL = %Exp:SECMED->CND_FILIAL% AND
	CNE.CNE_NUMMED = %Exp:SECMED->CND_NUMMED% AND
	CNE.CNE_REVISA = %Exp:SECMED->CND_REVISA%

	EndSQL
	oSecIMe:EndQuery()

	oSecIMe:Init()
	While !SECIME->(EOF())
		oSecIMe:PrintLine()
		nValAcu += SECIME->((CNE_QTDSOL - CNE_QTAMED) * CNE_VLUNIT)
		nValMed += SECIME->CNE_VLTOT
		nValAct += SECIME->((CNE_QTDSOL - CNE_QTAMED + CNE_QUANT) * CNE_VLUNIT)

		SECIME->(dbSkip())
	End
	oSecIMe:Finish()

	//-- Impressใo dos totaliadores
	oSecTot:Init()
	For nX := 1 To 13
		Do Case
			Case nX == 1 //-- Total da medi็ใo
				oSecTot:Cell("TEXTO"):SetValue(STR0037)
				oSecTot:Cell("VALACU"):SetValue(nValAcu)
				oSecTot:Cell("VALMED"):SetValue(nValMed)
				oSecTot:Cell("VALACT"):SetValue(nValAct)
			Case nX == 2 //-- Descontos
				nDesAcum	:= SECMED->(xMoeda(CNR040VlDc(CND_NUMMED,.T.,CND_CONTRA,CND_REVISA,CND_NUMERO,CND_FILCTR,CND_MOEDA,1,dDataRef,TamSX3("CNQ_VALOR")[2])))
				nDesMed	:= xMoeda(SECMED->CND_DESCME,SECMED->CND_MOEDA,1,dDataRef,TamSX3("CNQ_VALOR")[2])

				oSecTot:Cell("TEXTO"):SetValue(STR0038)
				oSecTot:Cell("VALACU"):SetValue(nDesAcum)
				oSecTot:Cell("VALMED"):SetValue(nDesMed)
				oSecTot:Cell("VALACT"):SetValue(nDesAcum + nDesMed)
			Case nX == 3 //-- Multas
				nMulAcum	:= SECMED->(xMoeda(CNR040VlMt(CND_NUMMED,.T.,CND_CONTRA,CND_REVISA,CND_NUMERO,"1",CND_FILCTR,CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])))
				nMulMed	:= SECMED->(xMoeda(CNR040VlMt(CND_NUMMED,.F.,CND_CONTRA,CND_REVISA,CND_NUMERO,"1",CND_FILCTR,CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])))

				oSecTot:Cell("TEXTO"):SetValue(STR0039)
				oSecTot:Cell("VALACU"):SetValue(nMulAcum)
				oSecTot:Cell("VALMED"):SetValue(nMulMed)
				oSecTot:Cell("VALACT"):SetValue(nMulAcum + nMulMed)
			Case nX == 4 //-- Bonifica็๕es
				nBonAcum	:= SECMED->(xMoeda(CNR040VlMt(CND_NUMMED,.T.,CND_CONTRA,CND_REVISA,CND_NUMERO,"2",CND_FILCTR,CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])))
				nBonMed	:= SECMED->(xMoeda(CNR040VlMt(CND_NUMMED,.F.,CND_CONTRA,CND_REVISA,CND_NUMERO,"2",CND_FILCTR,CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])))

				oSecTot:Cell("TEXTO"):SetValue(STR0011)
				oSecTot:Cell("VALACU"):SetValue(nBonAcum)
				oSecTot:Cell("VALMED"):SetValue(nBonMed)
				oSecTot:Cell("VALACT"):SetValue(nBonAcum + nBonMed)
			Case nX == 5 //-- Vl. Bruto
			
			If SECMED->CN9_ESPCTR == '2' // Ajuste para calculo da Bonifica็ao em caso de Ctr Compra
				nLiqAcu := nValAcu-nDesAcum+nMulAcum-nBonAcum
				nLiqMed := nValMed-nDesMed+nMulMed-nBonMed
				nLiqAct := nValAct-(nDesAcum + nDesMed)+(nMulAcum + nMulMed)-(nBonAcum + nBonMed)
			Else
			nLiqAcu := nValAcu-nDesAcum+nMulAcum+nBonAcum
				nLiqMed := nValMed-nDesMed+nMulMed+nBonMed
				nLiqAct := nValAct-(nDesAcum + nDesMed)+(nMulAcum + nMulMed)+(nBonAcum + nBonMed)
			EndIF

				oSecTot:Cell("TEXTO"):SetValue(STR0040)
				oSecTot:Cell("VALACU"):SetValue(nLiqAcu)
				oSecTot:Cell("VALMED"):SetValue(nLiqMed)
				oSecTot:Cell("VALACT"):SetValue(nLiqAct)
			Case nX == 6 //-- Reten็ใo
				aValImp[1] := SECMED->(xMoeda(CNR040VlRet(CND_NUMMED,CND_CONTRA,CND_REVISA,CND_NUMERO,CND_FILCTR,CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])))
				aValImp[2] := xMoeda(SECMED->CND_RETCAC,SECMED->CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])
				aValImp[3] := aValImp[1] + aValImp[2]

				oSecTot:Cell("TEXTO"):SetValue(STR0041)
			Case nX == 7 //-- IRRF
				aValImp[1] := (nValAcu * CN1->CN1_ALQTIR) / 100
				aValImp[2] := (nValMed * CN1->CN1_ALQTIR) / 100
				aValImp[3] := (nValAct * CN1->CN1_ALQTIR) / 100

				oSecTot:Cell("TEXTO"):SetValue(STR0042)
			Case nX == 8 //-- ISS
				aValImp[1] := (nValAcu * SECMED->CN9_ALCISS) / 100
				aValImp[2] := (nValMed * SECMED->CN9_ALCISS) / 100
				aValImp[3] := (nValAct * SECMED->CN9_ALCISS) / 100

				oSecTot:Cell("TEXTO"):SetValue(STR0043)
			Case nX == 9 //-- INSS
				aValImp[1] := (((nValAcu * SECMED->CN9_INSSMO) / 100) * CN1->CN1_ALINSS) / 100
				aValImp[2] := (((nValMed * SECMED->CN9_INSSMO) / 100) * CN1->CN1_ALINSS) / 100
				aValImp[3] := (((nValAct * SECMED->CN9_INSSMO) / 100) * CN1->CN1_ALINSS) / 100

				oSecTot:Cell("TEXTO"):SetValue(STR0044)
			Case nX == 10 //-- PIS
				aValImp[1] := (nValAcu * CN1->CN1_ALQPIS) / 100
				aValImp[2] := (nValMed * CN1->CN1_ALQPIS) / 100
				aValImp[3] := (nValAct * CN1->CN1_ALQPIS) / 100

				oSecTot:Cell("TEXTO"):SetValue(STR0066)
			Case nX == 11 //-- COFINS
				aValImp[1] := (nValAcu * CN1->CN1_ALCOFI) / 100
				aValImp[2] := (nValMed * CN1->CN1_ALCOFI) / 100
				aValImp[3] := (nValAct * CN1->CN1_ALCOFI) / 100

				oSecTot:Cell("TEXTO"):SetValue(STR0067)
			Case nX == 12 //-- CSLL
				aValImp[1] := (nValAcu * CN1->CN1_ALCSLL) / 100
				aValImp[2] := (nValMed * CN1->CN1_ALCSLL) / 100
				aValImp[3] := (nValAct * CN1->CN1_ALCSLL) / 100

				oSecTot:Cell("TEXTO"):SetValue(STR0068)
			Case nX == 13 //-- Vl. Lํquido
				oSecTot:Cell("TEXTO"):SetValue(STR0045)
				oSecTot:Cell("VALACU"):SetValue(nLiqAcu)
				oSecTot:Cell("VALMED"):SetValue(nLiqMed)
				oSecTot:Cell("VALACT"):SetValue(nLiqAct)
		EndCase

		If nX > 5 .And. nX < 13
			oSecTot:Cell("VALACU"):SetValue(aValImp[1])
			oSecTot:Cell("VALMED"):SetValue(aValImp[2])
			oSecTot:Cell("VALACT"):SetValue(aValImp[3])

			nLiqAcu -= aValImp[1]
			nLiqMed -= aValImp[2]
			nLiqAct -= aValImp[3]
		EndIf

		oSecTot:PrintLine()
	Next nX
	oSecTot:Finish()

	oSecMed:Finish()

	SECMED->(dbSkip())
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณMarcelo Custodio    บ Data ณ  23/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTotaliza valores da retencao                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcNumMed    - Codigo da medicao                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CNR040VlRet(cNumMed,cContra,cRevisa,cPlanil,cFilCtr)
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea  := GetArea()
Local nTot   := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seleciona as medicoes para calculo dos valores retidos   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT SUM(CND.CND_RETCAC) AS TOTRET "
cQuery += "  FROM "+RetSQLName("CND")+" CND "
cQuery += " WHERE CND.CND_FILCTR = '"+cFilCtr+"'"
cQuery += "   AND CND.CND_NUMMED < '"+cNumMed+"'"
cQuery += "   AND CND.CND_CONTRA = '"+cContra+"'"
cQuery += "   AND CND.CND_REVISA = '"+cRevisa+"'"
cQuery += "   AND CND.CND_NUMERO = '"+cPlanil+"'"
cQuery += "   AND CND.D_E_L_E_T_ = ' '"

cAlias := GetNextAlias()
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza estrutura do total   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TCSetField(cAlias,"TOTRET", "N",TamSx3("CND_RETCAC")[1],TamSx3("CND_RETCAC")[2])

nTot := (cAlias)->TOTRET

(cAlias)->(dbCloseArea())

RestArea(aArea)

Return nTot

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณMarcelo Custodio    บ Data ณ  23/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTotaliza valores das multas                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcNumMed    - Codigo da medicao                              บฑฑ
ฑฑบ          ณlAcumulado - Informa se busca as medicoes anteriores        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CNR040VlMt(cNumMed,lAcumulado,cContra,cRevisa,cNumero,cTipo,cFilCtr)
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local aArea	:= GetArea()
Local nTot		:= 0

Default cTipo := "1"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seleciona as medicoes para calculo das multas    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT CNR.CNR_VALOR AS TOTMULT, CNR.CNR_TIPO, CNR.CNR_CONTRA "
cQuery += "  FROM "+RetSQLName("CNR")+" CNR, "+RetSQLName("CND")+" CND "
cQuery += "  WHERE CNR.CNR_FILIAL = CND.CND_FILIAL "
cQuery += "   AND CNR.CNR_TIPO = '" +cTipo +"' "
cQuery += "AND CND.CND_FILCTR = '" +cFilCtr +"' "
cQuery += "   AND CNR.CNR_NUMMED = CND.CND_NUMMED "
If lAcumulado
	cQuery += "AND CND.CND_NUMMED < '" +cNumMed +"' "//Busca as medicoes anteriores
Else
	cQuery += "AND CND.CND_NUMMED = '" +cNumMed +"' "//Busca medicao atual
EndIf
cQuery += "  AND CND.CND_CONTRA = '" +cContra +"'"
cQuery += "  AND CND.CND_REVISA = '" +cRevisa +"'"
cQuery += "  AND CND.CND_NUMERO = '" +cNumero +"'"
cQuery += "  AND CND.D_E_L_E_T_ = ' '"
cQuery += "  AND CNR.D_E_L_E_T_ = ' '"

cAlias := GetNextAlias()
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza estrutura do total   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TCSetField(cAlias,"TOTMULT", "N",TamSx3("CNR_VALOR")[1],TamSx3("CNR_VALOR")[2])

While !(cAlias)->(Eof())
	nTot += (cAlias)->TOTMULT

	(cAlias)->(dbSkip())
EndDo

(cAlias)->(dbCloseArea())

RestArea(aArea)

Return nTot

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณMarcelo Custodio    บ Data ณ  23/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTotaliza valores dos descontos                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcNumMed    - Codigo da medicao                              บฑฑ
ฑฑบ          ณlAcumulado - Informa se busca as medicoes anteriores        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CNR040VlDc(cNumMed,lAcumulado,cContra,cRevisa,cPlanil,cFilCtr)
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea  := GetArea()
Local nTot   := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seleciona as medicoes para calculo dos descontos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT SUM(CNQ.CNQ_VALOR) AS TOTDESC "
cQuery += "  FROM "+RetSQLName("CNQ")+" CNQ, "+RetSQLName("CND")+" CND "
cQuery += " WHERE CNQ.CNQ_FILIAL = CND.CND_FILIAL "
cQuery += "AND CND.CND_FILCTR = '" +cFilCtr +"' "
cQuery += "   AND CNQ.CNQ_NUMMED = CND.CND_NUMMED "
cQuery += "   AND CNQ.CNQ_CONTRA = CND.CND_CONTRA "
If lAcumulado
	cQuery += "AND CND.CND_NUMMED < '" +cNumMed +"' "//Busca as medicoes anteriores
Else
	cQuery += "AND CND.CND_NUMMED = '" +cNumMed +"' "//Busca a medicao atual
EndIf
cQuery += "  AND CND.CND_CONTRA = '" +cContra +"'"
cQuery += "  AND CND.CND_REVISA = '" +cRevisa +"'"
cQuery += "  AND CND.CND_NUMERO = '" +cPlanil +"'"
cQuery += "  AND CND.D_E_L_E_T_ = ' '"
cQuery += "  AND CNQ.D_E_L_E_T_ = ' '"

cAlias := GetNextAlias()
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza estrutura do total   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TCSetField(cAlias,"TOTDESC", "N",TamSx3("CNQ_VALOR")[1],TamSx3("CNQ_VALOR")[2])

nTot := (cAlias)->TOTDESC

(cAlias)->(dbCloseArea())

RestArea(aArea)

Return nTot

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCNR040ClFrณ Autor ณ Aline Sebrian         ณ Data ณ 11.04.11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณValida os parametro do Cliente e Fornecedor no relatorio.   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณCNR040ClFr()                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณCNR040ClFr()                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Function CNR040ClFr(cTipo)
Local aSaveArea	:= GetArea()

If cTipo=="1"
	If !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("A2_COD")[1]))
		MV_PAR15	:= Space(6)
		MV_PAR16	:= REPLICATE("Z",TamSx3("A1_COD")[1])
	EndIf
Else
	If !Empty(mv_par15) .Or. (!Empty(mv_par16) .And. UPPER(mv_par16) != REPLICATE("Z",TamSx3("A1_COD")[1]))
		MV_PAR09	:= Space(6)
		MV_PAR10	:= REPLICATE("Z",TamSx3("A2_COD")[1])
	EndIf
EndIf

RestArea(aSaveArea)
Return
