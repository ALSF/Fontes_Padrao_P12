#include "protheus.ch" 
#include "report.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CNTR121   ³Autor  ³Rogerio Melonio        ³Data  ³22/09/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de medicoes naoefetuadas                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CNTR121()
Local oReport
oReport := ReportDef()
oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³Autor  ³Rogerio Melonio        ³Data  ³25/09/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de medicoes naoefetuadas                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oCN9
Local oPlanTot
Local oPlanDet

oReport := TReport():New("CNTR121","Medições não Efetuadas" ,"CNTR121",{|oReport| ReportPrint(oReport)},"Este relatorio ira imprimir a relacao das Medições não Efetuadas conforme os parametros solicitados.")
Pergunte("CNTR121",.F.)

oCN9 := TRSection():New(oReport,OemToAnsi("Contrato"),{"CN9","CN1"})

TRCell():New(oCN9,"CN9_FILCTR","CN9")
TRCell():New(oCN9,"FILNAME",,"")
TRCell():New(oCN9,"CN9_NUMERO","CN9")
TRCell():New(oCN9,"CN9_REVISA","CN9")
TRCell():New(oCN9,"CN9_ESPCTR","CN9","Espécie de"+CRLF+"Contrato")
TRCell():New(oCN9,"CN9_TPCTO" ,"CN9","Tipo de"+CRLF+"Contrato")
TRCell():New(oCN9,"CN1_DESCRI","CN1")
TRCell():New(oCN9,"CN9_SITUAC","CN9")

oPlanTot := TRSection():New(oCN9,OemToAnsi("Planilhas"),{"CNA"})

TRCell():New(oPlanTot,"CNA_NUMERO","CNA")
TRCell():New(oPlanTot,"CNA_FORCLI",,"Fornecedor/Cliente")
TRCell():New(oPlanTot,"CNA_TIPPLA","CNA")
TRCell():New(oPlanTot,"CNL_DESCRI","CNL")
TRCell():New(oPlanTot,"QTAMED",,"Recorrências"+CRLF+"não medidas")
TRCell():New(oPlanTot,"VLAMED",,"Vlr. Previsto (Planilha))",PesqPict("CNA","CNA_VLTOT"))

oPlanDet := TRSection():New(oPlanTot,OemToAnsi("Medições"),{"CNA","CNF"})
TRCell():New(oPlanDet,"COMPET",,"Competência")
TRCell():New(oPlanDet,"CNA_PROMED",,"Data Prevista")
TRCell():New(oPlanDet,"CNA_PROPAR",,"Parcela"+CRLF+"ou Recorrência")
TRCell():New(oPlanDet,"VLRPREV",,"Vlr. Previsto (Parcela)",PesqPict("CNA","CNA_VLTOT"))

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ReportPrint³Autor ³Rogerio Melonio        ³Data  ³25/09/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Seleciona os contratos                                     ³±±
±±³          ³ Imprime o Relatorio tReport                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR121                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)
Local cSql  := ""
Local cSql2 := ""
Local oCN9     := oReport:Section(1)
Local oPlanTot := oReport:Section(1):Section(1)
Local oPlanDet := oReport:Section(1):Section(1):Section(1)
Local nX := 0
Local nQtdNaoMed := 0
Local nVlrNaoMed := 0

MakeSqlExp("CNTR121")

//- Filtra contrato por especie - 1 = Compra, 2 = Venda, 3 = Ambos
If !Empty(mv_par01) .And. mv_par01 <= 2
	cSql += " AND CN9_ESPCTR = '" + AllTrim(Str(mv_par01)) + "'"
EndIf

//- Filtra contrato por filiais
cSql += " AND CN9_FILCTR >= '" + mv_par02 + "' "
cSql += " AND CN9_FILCTR <= '" + mv_par03 + "' "

//- Filtra planilha por cliente
cSql += " AND CNA_CLIENT >= '" + mv_par04 + "' "
cSql += " AND CNA_CLIENT <= '" + mv_par06 + "' "

//- Filtra planilha por loja do cliente
cSql += " AND CNA_LOJACL >= '" + mv_par05 + "' "
cSql += " AND CNA_LOJACL <= '" + mv_par07 + "' "

//- Filtra planilha por fornecedor
cSql += " AND CNA_FORNEC >= '" + mv_par08 + "' "
cSql += " AND CNA_FORNEC <= '" + mv_par10 + "' "

//- Filtra planilha por loja do fornecedor
cSql += " AND CNA_LJFORN >= '" + mv_par09 + "' "
cSql += " AND CNA_LJFORN <= '" + mv_par11 + "' "

//- Filtra contratos
cSql += " AND CN9_NUMERO >= '" + mv_par12 + "' "
cSql += " AND CN9_NUMERO <= '" + mv_par13 + "' "

cSql2 := cSql

cSql  += " AND ( CNA_PROMED >= '" + Dtos(mv_par14) + "' AND CNA_PROMED <= '" + Dtos(mv_par15) + "' OR "
cSql  += " ( CNA_ULTMED < '" + Dtos(mv_par14) + "' AND CNA_ULTMED <> '' ) )"
cSql2 += " AND CNF_PRUMED >= '" + Dtos(mv_par14) + "' AND CNF_PRUMED <= '" + Dtos(mv_par15) + "' "

cSql  := "%"+cSql+"%"
cSql2 := "%"+cSql2+"%"

If mv_par16 = 1
	BeginSql alias "QRY"
		SELECT DISTINCT * FROM
			(
			SELECT
				CN9_FILCTR,
				CN9_NUMERO,
				CN9_REVISA,
				CN9_TPCTO,
				CN9_ESPCTR,
				CN9_SITUAC,

				CN1_DESCRI,
				CN1_MEDEVE,

				CNA_CONTRA,
				CNA_FORNEC,
				CNA_LJFORN,
				CNA_CLIENT,
				CNA_LOJACL,
				CNL_MEDEVE

				FROM
					%table:CN9% CN9,
					%table:CNA% CNA,
					%table:CN1% CN1,
					%table:CNL% CNL

				WHERE
						CN9.%notDel%
					AND CN9.CN9_SITUAC IN ('05','06')

					AND CNA.%notDel%
					AND CNA.CNA_FILIAL = CN9.CN9_FILIAL
					AND CNA.CNA_CONTRA = CN9.CN9_NUMERO
					AND CNA.CNA_REVISA = CN9.CN9_REVISA
					AND CNA.CNA_PERIOD <> ''

					AND CNL.%notDel%
					AND CNL.CNL_FILIAL = CN9.CN9_FILIAL
					AND CNL.CNL_CODIGO = CNA.CNA_TIPPLA

					AND CN1.%notDel%
					AND	CN1.CN1_FILIAL = CN9.CN9_FILIAL
					AND CN1.CN1_CODIGO = CN9.CN9_TPCTO
					%exp:cSql%

				UNION ALL

				SELECT
					CN9_FILCTR,
					CN9_NUMERO,
					CN9_REVISA,
					CN9_TPCTO,
					CN9_ESPCTR,
					CN9_SITUAC,

					CN1_DESCRI,
					CN1_MEDEVE,

					CNA_CONTRA,
					CNA_FORNEC,
					CNA_LJFORN,
					CNA_CLIENT,
					CNA_LOJACL,

					CNL_MEDEVE

				FROM
					%table:CN9% CN9,
					%table:CNA% CNA,
					%table:CN1% CN1,
					%table:CNF% CNF,
					%table:CNL% CNL

				WHERE
						CN9.%notDel%
					AND CN9.CN9_SITUAC IN ('05','06')

					AND CNA.%notDel%
					AND	CNA.CNA_FILIAL = CN9.CN9_FILIAL
					AND CNA.CNA_CONTRA = CN9.CN9_NUMERO
					AND CNA.CNA_REVISA = CN9.CN9_REVISA
					AND CNA.CNA_PERIOD = ''

					AND CNL.%notDel%
					AND	CNL.CNL_FILIAL = %xfilial:CNL%
					AND CNL.CNL_CODIGO = CNA.CNA_TIPPLA

					AND CN1.%notDel%
					AND	CN1.CN1_FILIAL = %xfilial:CN1%
					AND CN1.CN1_CODIGO = CN9.CN9_TPCTO

					AND CNF.%notDel%
					AND	CNF.CNF_FILIAL = CN9.CN9_FILIAL
					AND CNF.CNF_CONTRA = CN9.CN9_NUMERO
					AND CNF.CNF_REVISA = CN9.CN9_REVISA
					AND CNF.CNF_NUMPLA = CNA.CNA_NUMERO
					AND CNF.CNF_SALDO > 0

					%exp:cSql2%
				) RESUMO
		WHERE
			(RESUMO.CN1_MEDEVE <> '1' AND RESUMO.CNL_MEDEVE <> '1')
			OR
			(RESUMO.CNL_MEDEVE <> '1' )

		ORDER BY
			RESUMO.CN9_FILCTR,
			RESUMO.CN9_NUMERO
	EndSql
Else
	If mv_par17 = 1

		BeginSql alias "QRY"
			SELECT DISTINCT * FROM
				(
				SELECT DISTINCT
					CN9_FILCTR,
					CN9_NUMERO,
					CN9_REVISA,
					CN9_ESPCTR,
					CN9_TPCTO,
					CN9_SITUAC,

					CN1_DESCRI,
					CN1_MEDEVE,

					CNA_CONTRA,
					CNA_NUMERO,
					CNA_TIPPLA,
					CNA_PERIOD,
					CNA_FORNEC,
					CNA_LJFORN,
					CNA_CLIENT,
					CNA_LOJACL,

					CNL_DESCRI,
					CNL_MEDEVE

				FROM
					%table:CN9% CN9,
					%table:CNA% CNA,
					%table:CN1% CN1,
					%table:CNL% CNL

				WHERE
					CN9.%notDel%
					AND CN9.CN9_SITUAC IN ('05','06')

					AND CNA.%notDel%
					AND	CNA.CNA_FILIAL = CN9.CN9_FILIAL
					AND CNA.CNA_CONTRA = CN9.CN9_NUMERO
					AND CNA.CNA_REVISA = CN9.CN9_REVISA
					AND CNA.CNA_PERIOD <> ''

					AND CNL.%notDel%
					AND	CNL.CNL_FILIAL = %xfilial:CNL%
					AND CNL.CNL_CODIGO = CNA.CNA_TIPPLA

					AND CN1.%notDel%
					AND CN1.CN1_FILIAL = %xfilial:CN1%
					AND CN1.CN1_CODIGO = CN9.CN9_TPCTO
					%exp:cSql%

				UNION ALL

				SELECT DISTINCT
					CN9_FILCTR,
					CN9_NUMERO,
					CN9_REVISA,
					CN9_ESPCTR,
					CN9_TPCTO,
					CN9_SITUAC,

					CN1_DESCRI,
					CN1_MEDEVE,

					CNA_CONTRA,
					CNA_NUMERO,
					CNA_TIPPLA,
					CNA_PERIOD,
					CNA_FORNEC,
					CNA_LJFORN,
					CNA_CLIENT,
					CNA_LOJACL,

					CNL_DESCRI,
					CNL_MEDEVE

				FROM
					%table:CN9% CN9,
					%table:CNA% CNA,
					%table:CN1% CN1,
					%table:CNL% CNL,
					%table:CNF% CNF

				WHERE
						CN9.%notDel%
					AND CN9.CN9_SITUAC IN ('05','06')

					AND CNA.%notDel%
					AND	CNA.CNA_FILIAL = CN9.CN9_FILIAL
					AND CNA.CNA_CONTRA = CN9.CN9_NUMERO
					AND CNA.CNA_REVISA = CN9.CN9_REVISA
					AND CNA.CNA_PERIOD = ''

					AND CNL.%notDel%
					AND	CNL.CNL_FILIAL = %xfilial:CNL%
					AND CNL.CNL_CODIGO = CNA.CNA_TIPPLA

					AND CN1.%notDel%
					AND	CN1.CN1_FILIAL = %xfilial:CN1%
					AND CN1.CN1_CODIGO = CN9_TPCTO

					AND CNF.%notDel%
					AND CNF.CNF_FILIAL = CN9.CN9_FILIAL
					AND CNF.CNF_CONTRA = CN9_NUMERO
					AND CNF.CNF_REVISA = CN9_REVISA
					AND CNF.CNF_NUMPLA = CNA.CNA_NUMERO
					AND CNF.CNF_SALDO > 0
					%exp:cSql2%
				) RESUMO

			WHERE
				(RESUMO.CN1_MEDEVE <> '1' AND RESUMO.CNL_MEDEVE <> '1')
				OR
				(RESUMO.CNL_MEDEVE <> '1')

			ORDER BY
				RESUMO.CN9_FILCTR,
				RESUMO.CN9_NUMERO,
				RESUMO.CNA_NUMERO
		EndSql

	Else

		BeginSql alias "QRY"
			SELECT DISTINCT * FROM
				(
				SELECT
					CN9_FILCTR,
					CN9_NUMERO,
					CN9_REVISA,
					CN9_ESPCTR,
					CN9_TPCTO,
					CN9_SITUAC,

					CN1_DESCRI,
					CN1_MEDEVE,

					CNA_CONTRA,
					CNA_NUMERO,
					CNA_TIPPLA,
					CNA_CRONOG,
					CNA_PERIOD,
					CNA_FORNEC,
					CNA_LJFORN,
					CNA_CLIENT,
					CNA_LOJACL,

					CNL_DESCRI,
					CNL_MEDEVE,

					CNA_CRONOG AS CNF_NUMERO,
					''  	   AS COMPET,
					CNA_PROMED AS PROMED,
					CNA_PROPAR AS PROPAR,
					CNA_VLTOT  AS VLRPREV

				FROM
					%table:CN9% CN9,
					%table:CNA% CNA,
					%table:CN1% CN1,
					%table:CNL% CNL

				WHERE
						CN9.%notDel%
					AND CN9_SITUAC IN ('05','06')

					AND	CNA_FILIAL = %xfilial:CNA%
					AND CNA.%notDel%
					AND CNA_CONTRA = CN9_NUMERO
					AND CNA_REVISA = CN9_REVISA
					AND CNA_PERIOD <> ''

					AND CNL_FILIAL = %xfilial:CNL%
					AND CNL.%notDel%
					AND CNL_CODIGO = CNA_TIPPLA

					AND CN1_FILIAL = %xfilial:CN1%
					AND CN1.%notDel%
					AND CN1_CODIGO = CN9_TPCTO
					%exp:cSql%

				UNION ALL

				SELECT
					CN9_FILCTR,
					CN9_NUMERO,
					CN9_REVISA,
					CN9_ESPCTR,
					CN9_TPCTO,
					CN9_SITUAC,

					CN1_DESCRI,
					CN1_MEDEVE,

					CNA_CONTRA,
					CNA_NUMERO,
					CNA_TIPPLA,
					CNA_CRONOG,
					CNA_PERIOD,
					CNA_FORNEC,
					CNA_LJFORN,
					CNA_CLIENT,
					CNA_LOJACL,

					CNL_DESCRI,
					CNL_MEDEVE,

					CNF_NUMERO,
					CNF_COMPET  AS COMPET,
					CNF_PRUMED 	AS PROMED,
					CNF_PARCEL 	AS PROPAR,
					CNF_SALDO 	AS VLRPREV

				FROM
					%table:CN9% CN9,
					%table:CNA% CNA,
					%table:CN1% CN1,
					%table:CNL% CNL,
					%table:CNF% CNF

				WHERE
						CN9.%notDel%
					AND CN9.CN9_SITUAC IN ('05','06')

					AND CNA.%notDel%
					AND CNA.CNA_FILIAL = CN9.CN9_FILIAL
					AND CNA.CNA_CONTRA = CN9.CN9_NUMERO
					AND CNA.CNA_REVISA = CN9.CN9_REVISA
					AND CNA.CNA_PERIOD = ''

					AND CNL.%notDel%
					AND CNL.CNL_FILIAL = %xfilial:CNL%
					AND CNL.CNL_CODIGO = CNA.CNA_TIPPLA

					AND CN1.%notDel%
					AND	CN1.CN1_FILIAL = %xfilial:CN1%
					AND CN1.CN1_CODIGO = CN9.CN9_TPCTO

					AND CNF.%notDel%
					AND CNF.CNF_FILIAL = CN9.CN9_FILIAL
					AND CNF.CNF_CONTRA = CN9.CN9_NUMERO
					AND CNF.CNF_REVISA = CN9.CN9_REVISA
					AND CNF.CNF_NUMPLA = CNA.CNA_NUMERO
					AND CNF.CNF_SALDO > 0
					%exp:cSql2%
				) RESUMO

			WHERE
				((RESUMO.CN1_MEDEVE <> '1' AND RESUMO.CNL_MEDEVE <> '1')
				OR
				(RESUMO.CNL_MEDEVE <> '1'))
				AND RESUMO.COMPET <> ''

			ORDER BY
				RESUMO.CN9_FILCTR,
				RESUMO.CN9_NUMERO,
				RESUMO.CNA_NUMERO,
				RESUMO.CNA_CRONOG,
				RESUMO.PROMED
		EndSql

	Endif

Endif

DbSelectArea("QRY")
Count To nRecCN9
dbGoTop()

If mv_par16 = 2
	TRCell():New(oCN9,"QTAMED",,"Qtd. medições"+CRLF+"não realizadas")
Endif

TRCell():New(oCN9,"VLAMED",,"Valor não medido",PesqPict("CNA","CNA_VLTOT"))

If nRecCN9 > 0
	oReport:SetMeter(nRecCN9)
	If mv_par16 = 1
		oCN9:Init()
	Endif
	While !QRY->(EOF()) .And. !oReport:Cancel()
		nQtdNaoMed := CN121Qtd(QRY->CN9_NUMERO,QRY->CN9_REVISA)
		If nQtdNaoMed = 0
			oReport:IncMeter()
			QRY->(dbSkip())
			Loop
		Endif
		nVlrNaoMed := CN121Vlr(QRY->CN9_NUMERO,QRY->CN9_REVISA)

		If mv_par16 = 2
			oCN9:Init()
		Endif

		oCN9:Cell("CN9_FILCTR"):SetValue(QRY->CN9_FILCTR)
		oCN9:Cell("FILNAME"):SetValue(AllTrim(FWFilialName(,QRY->CN9_FILCTR)))
		oCN9:Cell("CN9_NUMERO"):SetValue(QRY->CN9_NUMERO)
		oCN9:Cell("CN9_REVISA"):SetValue(QRY->CN9_REVISA)
		oCN9:Cell("CN9_ESPCTR"):SetValue(CNR121Combo("CN9_ESPCTR",QRY->CN9_ESPCTR))
		oCN9:Cell("CN9_TPCTO" ):SetValue(QRY->CN9_TPCTO)
		oCN9:Cell("CN1_DESCRI"):SetValue(QRY->CN1_DESCRI)
		oCN9:Cell("CN9_SITUAC"):SetValue(CNR121Combo("CN9_SITUAC",QRY->CN9_SITUAC))
		oCN9:Cell("VLAMED"):SetValue(nVlrNaoMed)

		If mv_par16 = 2
			oCN9:Cell("QTAMED"):SetValue(nQtdNaoMed)
			oCN9:PrintLine()
				cQuebra := QRY->CN9_FILCTR + QRY->CN9_NUMERO + QRY->CN9_REVISA
				While !QRY->(EOF()) .And. !oReport:Cancel() .And. QRY->CN9_FILCTR + QRY->CN9_NUMERO + QRY->CN9_REVISA = cQuebra
					oPlanTot:Init()
					oPlanTot:Cell("CNA_NUMERO"):SetValue(QRY->CNA_NUMERO)
					If QRY->CN9_ESPCTR == '2'
						oPlanTot:Cell("CNA_FORCLI"):SetValue(Posicione("SA1",1,xFilial('SA1')+QRY->(CNA_CLIENT+CNA_LOJACL),"A1_NOME")) //(1) A1_FILIAL+A1_COD+A1_LOJA
					Else
						oPlanTot:Cell("CNA_FORCLI"):SetValue(Posicione("SA2",1,xFilial('SA2')+QRY->(CNA_FORNEC+CNA_LJFORN),"A2_NOME")) //(1) A2_FILIAL+A2_COD+A2_LOJA
					EndIf
					oPlanTot:Cell("CNA_TIPPLA"):SetValue(QRY->CNA_TIPPLA)
					oPlanTot:Cell("CNL_DESCRI"):SetValue(QRY->CNL_DESCRI)
					If Empty(QRY->CNA_PERIOD)
						oPlanTot:Cell("QTAMED"):SetTitle("Parcelas não"+CRLF+"medidas")
					Else
						oPlanTot:Cell("QTAMED"):SetTitle("Recorrências"+CRLF+"não medidas")
					Endif
					oPlanTot:Cell("QTAMED"):SetValue(CN121Qtd(QRY->CN9_NUMERO,QRY->CN9_REVISA,QRY->CNA_NUMERO))
					oPlanTot:Cell("VLAMED"):SetValue(CN121Vlr(QRY->CN9_NUMERO,QRY->CN9_REVISA,QRY->CNA_NUMERO))
					oPlanTot:PrintLine()
					If mv_par17 = 2
						oPlanDet:Init()
						If Empty(QRY->CNA_PERIOD)
							cQuebr2 := QRY->CN9_FILCTR + QRY->CN9_NUMERO + QRY->CN9_REVISA + QRY->CNA_NUMERO + QRY->CNF_NUMERO
							While !QRY->(EOF()) .And. !oReport:Cancel() .And. QRY->CN9_FILCTR + QRY->CN9_NUMERO + QRY->CN9_REVISA + QRY->CNA_NUMERO + QRY->CNF_NUMERO = cQuebr2
								oPlanDet:Cell("COMPET"):SetValue(QRY->COMPET)
								oPlanDet:Cell("CNA_PROMED"):SetValue(Stod(QRY->PROMED))
								oPlanDet:Cell("CNA_PROPAR"):SetValue(QRY->PROPAR)
								oPlanDet:Cell("CNA_PROPAR"):SetTitle("Parcela")
								oPlanDet:Cell("VLRPREV"):SetValue(QRY->VLRPREV)
								oPlanDet:PrintLine()
								oReport:IncMeter()
								QRY->(dbSkip())
							EndDo
							oPlanDet:Finish()
							oPlanTot:Finish()
						Else
							aRecorre := CN121Reco(QRY->CN9_NUMERO,QRY->CN9_REVISA,QRY->CNA_NUMERO)
							For nX := 1 To Len(aRecorre)
								oPlanDet:Cell("CNA_PROMED"):SetValue(aRecorre[nX][2])
								oPlanDet:Cell("CNA_PROPAR"):SetTitle("Recorrência")
								oPlanDet:Cell("CNA_PROPAR"):SetValue(aRecorre[nX][1])
								oPlanDet:Cell("VLRPREV"):SetValue(aRecorre[nX][3])
								oPlanDet:PrintLine()
								oReport:IncMeter()
							Next nX
							oPlanDet:Finish()
							oPlanTot:Finish()
							QRY->(dbSkip())
						Endif
						oReport:SkipLine()
					Else
						oReport:IncMeter()
						QRY->(dbSkip())
					Endif
				EndDo
				If mv_par17 = 1
					oPlanTot:Finish()
					oReport:SkipLine()
				Endif
				oReport:ThinLine()
			oCN9:Finish()
		Else
			oCN9:PrintLine()
			oReport:IncMeter()
			QRY->(dbSkip())
		Endif
	EndDo
	If mv_par16 = 1
		oCN9:Finish()
	Endif
Endif
QRY->(dbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CN121Qtd	 ³Autor ³Rogerio Melonio        ³Data  ³25/09/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula a quantidade de parcelas/recorrencias nao medidas  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR121                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CN121Qtd(cContrato,cRevisa,cPlanilha)
Local lRet 		:= .F.
Local aArea 	:= GetArea()
Local aAreaCNA 	:= CNA->(GetArea())
Local aAreaCNF 	:= CNF->(GetArea())
Local aParcelas := {}

Local dDataPriMed := dDataBase
Local cCpoParcela := ""
Local cStrRec 	  := "/"

Local nQtdNaoMed:= 0
Local nX 		:= 0

Default cPlanilha := ""

CNA->(dbSetOrder(1))
lRet := CNA->(MsSeek(xFilial("CNA")+cContrato+cRevisa+cPlanilha))

If lRet
	While !CNA->(EOF()) .And. CNA->CNA_FILIAL+CNA->CNA_CONTRA+CNA->CNA_REVISA == xFilial("CNA")+cContrato+cRevisa .And. Iif(Empty(cPlanilha),.T.,CNA->CNA_NUMERO <= cPlanilha )
		If !Empty(CNA->CNA_PERIOD)
			If ( CNA->CNA_PROMED >= mv_par14 .And. CNA->CNA_PROMED <= mv_par15 ) .Or. ( CNA->CNA_ULTMED < mv_par14 )
				CXN->(dbSetOrder(2))
				CXN->(MsSeek(xFilial("CXN")+cContrato+cRevisa+CNA->CNA_NUMERO))

				While !CXN->(Eof()) .And. CXN->CXN_FILIAL+CXN->CXN_CONTRA+CXN->CXN_REVISA+CXN->CXN_NUMPLA == xFilial("CXN")+cContrato+cRevisa+CNA->CNA_NUMERO
					cStrRec += CXN->CXN_PARCELA + "/"
					CXN->(dbSkip())
				End

				cCpoParcela := IIf( Empty(CNA->CNA_FORNEC),"E1_PARCELA","E2_PARCELA" )
				dDataPriMed := CN300RetMed(CNA->CNA_PERIOD,CNA->CNA_DTINI,CNA->CNA_DIAMES,CNA->CNA_DIASEM,CNA->CNA_PERREC,.T.)
				aParcelas 	:= CN100ParRc(CNA->CNA_PERIOD,CNA->CNA_QTDREC,CNA->CNA_DIASEM,CNA->CNA_DIAMES,dDataPriMed,CNA->CNA_DTINI,CNA->CNA_DTFIM,cCpoParcela,CNA->CNA_PERREC)

				For nX := 1 To Len(aParcelas)
					If ( aParcelas[nX][2] >= mv_par14 .And. aParcelas[nX][2] <= CNA->CNA_PROMED ) .Or. ( aParcelas[nX][2] > CNA->CNA_ULTMED .And. aParcelas[nX][2] <= mv_par14  )
						If !("/"+aParcelas[nX][1]+"/" $ cStrRec)
							nQtdNaoMed := nQtdNaoMed + 1
						Endif
					Endif
				Next nX
			Endif
		Else
			CNF->(dbSetOrder(3))
			CNF->(MsSeek(xFilial("CNF")+cContrato+cRevisa+CNA->CNA_CRONOG))

			While !CNF->(EOF()) .And. CNF->CNF_FILIAL+CNF->CNF_CONTRA+CNF->CNF_REVISA+CNF->CNF_NUMERO == xFilial("CNF")+cContrato+cRevisa+CNA->CNA_CRONOG .And. CNF->CNF_PRUMED <= mv_par15
				If CNF->CNF_PRUMED >= mv_par14 .And. CNF->CNF_PRUMED <= mv_par15 .And. CNF->CNF_SALDO > 0
					nQtdNaoMed := nQtdNaoMed + 1
				Endif
				CNF->(dbSkip())
			EndDo
		Endif
		CNA->(dbSkip())
	EndDo
Endif

CNF->(RestArea(aAreaCNF))
CNA->(RestArea(aAreaCNA))
RestArea(aArea)

Return(nQtdNaoMed)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CN121Vlr	 ³Autor ³Rogerio Melonio        ³Data  ³25/09/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula o valor das parcelas/recorrencias nao medidas  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR121                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CN121Vlr(cContrato,cRevisa,cPlanilha)
Local lRet := .F.
Local aArea := GetArea()
Local aAreaCNA := CNA->(GetArea())
Local aAreaCNF := CNF->(GetArea())
Local nQtdNaoMed := 0
Local nVlrNaoMed := 0
Local aParcelas := {}
Local dDataPriMed := dDataBase
Local cCpoParcela := ""
Local cStrRec := "/"
Local nX := 0

Default cPlanilha := ""

CNA->(dbSetOrder(1))
lRet := CNA->(MsSeek(xFilial("CNA")+cContrato+cRevisa+cPlanilha))

If lRet
	While !CNA->(EOF()) .And. CNA->CNA_FILIAL+CNA->CNA_CONTRA+CNA->CNA_REVISA == xFilial("CNA")+cContrato+cRevisa .And. Iif(Empty(cPlanilha),.T.,CNA->CNA_NUMERO <= cPlanilha )
		If !Empty(CNA->CNA_PERIOD)
			If ( CNA->CNA_PROMED >= mv_par14 .And. CNA->CNA_PROMED <= mv_par15 ) .Or. ( CNA->CNA_ULTMED < mv_par14 )
				CXN->(dbSetOrder(2))
				CXN->(MsSeek(xFilial("CXN")+cContrato+cRevisa+CNA->CNA_NUMERO))
				While !CXN->(Eof()) .And. CXN->CXN_FILIAL+CXN->CXN_CONTRA+CXN->CXN_REVISA+CXN->CXN_NUMPLA == xFilial("CXN")+cContrato+cRevisa+CNA->CNA_NUMERO
					cStrRec += CXN->CXN_PARCELA + "/"
					CXN->(dbSkip())
				End
				cCpoParcela := IIf( Empty(CNA->CNA_FORNEC),"E1_PARCELA","E2_PARCELA" )
				dDataPriMed := CN300RetMed(CNA->CNA_PERIOD,CNA->CNA_DTINI,CNA->CNA_DIAMES,CNA->CNA_DIASEM,CNA->CNA_PERREC,.T.)
				aParcelas := CN100ParRc(CNA->CNA_PERIOD,CNA->CNA_QTDREC,CNA->CNA_DIASEM,CNA->CNA_DIAMES,dDataPriMed,CNA->CNA_DTINI,CNA->CNA_DTFIM,cCpoParcela,CNA->CNA_PERREC)
				For nX := 1 To Len(aParcelas)
					If ( aParcelas[nX][2] >= mv_par14 .And. aParcelas[nX][2] <= CNA->CNA_PROMED ) .Or. ( aParcelas[nX][2] > CNA->CNA_ULTMED .And. aParcelas[nX][2] <= mv_par14  )
						If !("/"+aParcelas[nX][1]+"/" $ cStrRec)
							nQtdNaoMed := nQtdNaoMed + 1
						Endif
					Endif
				Next nX
				nVlrNaoMed += (nQtdNaoMed*CNA->CNA_VLTOT)
			Endif
		ElseIf !Empty(CNA->CNA_CRONOG)
			CNF->(dbSetOrder(3))
			CNF->(MsSeek(xFilial("CNF")+cContrato+cRevisa+CNA->CNA_CRONOG))
			While !CNF->(EOF()) .And. CNF->CNF_FILIAL+CNF->CNF_CONTRA+CNF->CNF_REVISA+CNF->CNF_NUMERO == xFilial("CNF")+cContrato+cRevisa+CNA->CNA_CRONOG;
				.And. CNF->CNF_PRUMED <= mv_par15
				If CNF->CNF_PRUMED >= mv_par14 .And. CNF->CNF_PRUMED <= mv_par15 .And. CNF->CNF_SALDO > 0
					nVlrNaoMed += CNF->CNF_SALDO
				Endif
				CNF->(dbSkip())
			EndDo
		Endif
		CNA->(dbSkip())
	EndDo
Endif

CNF->(RestArea(aAreaCNF))
CNA->(RestArea(aAreaCNA))
RestArea(aArea)

Return(nVlrNaoMed)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CN121Reco	 ³Autor ³Rogerio Melonio        ³Data  ³25/09/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna as recorencias nao medidas                     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR121                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CN121Reco(cContrato,cRevisa,cPlanilha)
Local lRet := .F.
Local aArea := GetArea()
Local aAreaCNA := CNA->(GetArea())
Local aParcelas := {}
Local dDataPriMed := dDataBase
Local cCpoParcela := ""
Local nX := 0
Local aRecorre := {}
Local cStrRec := "/"

CNA->(dbSetOrder(1))
lRet := CNA->(MsSeek(xFilial("CNA")+cContrato+cRevisa+cPlanilha))

If lRet
	If ( CNA->CNA_PROMED >= mv_par14 .And. CNA->CNA_PROMED <= mv_par15 ) .Or. ( CNA->CNA_ULTMED < mv_par14 )
		CXN->(dbSetOrder(2))
		CXN->(MsSeek(xFilial("CXN")+cContrato+cRevisa+cPlanilha))
		While !CXN->(Eof()) .And. CXN->CXN_FILIAL+CXN->CXN_CONTRA+CXN->CXN_REVISA+CXN->CXN_NUMPLA == xFilial("CXN")+cContrato+cRevisa+cPlanilha
			cStrRec += CXN->CXN_PARCELA + "/"
			CXN->(dbSkip())
		End
		cCpoParcela := IIf( Empty(CNA->CNA_FORNEC),"E1_PARCELA","E2_PARCELA" )
		dDataPriMed := CN300RetMed(CNA->CNA_PERIOD,CNA->CNA_DTINI,CNA->CNA_DIAMES,CNA->CNA_DIASEM,CNA->CNA_PERREC,.T.)
		aParcelas := CN100ParRc(CNA->CNA_PERIOD,CNA->CNA_QTDREC,CNA->CNA_DIASEM,CNA->CNA_DIAMES,dDataPriMed,CNA->CNA_DTINI,CNA->CNA_DTFIM,cCpoParcela,CNA->CNA_PERREC)
		For nX := 1 To Len(aParcelas)
			If ( aParcelas[nX][2] >= mv_par14 .And. aParcelas[nX][2] <= CNA->CNA_PROMED ) .Or. ( aParcelas[nX][2] > CNA->CNA_ULTMED .And. aParcelas[nX][2] <= mv_par14  )
				If !("/"+aParcelas[nX][1]+"/" $ cStrRec)
					aAdd(aRecorre, { aParcelas[nX][1],aParcelas[nX][2],CNA->CNA_VLTOT } )
				Endif
			Endif
		Next
	EndIf
Endif

CNA->(RestArea(aAreaCNA))
RestArea(aArea)

Return aRecorre

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CNR121Combo³Autor ³Rogerio Melonio        ³Data  ³28/09/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna descricao de campo combo                       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR121                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CNR121Combo(cCampo,cValor)
Local aSx3Box := RetSx3Box( Posicione("SX3", 2, cCampo, "X3CBox()" ),,, 1 )
Local cTxtBox := ""
Local nQual	  := Iif(cCampo=="CN9_SITUAC",1,2)
Local nPosBox := Ascan( aSx3Box, { |aBox| aBox[nQual] = cValor } )

cTxtBox := Upper(AllTrim( aSx3Box[nPosBox][3] ))

Return cTxtBox

