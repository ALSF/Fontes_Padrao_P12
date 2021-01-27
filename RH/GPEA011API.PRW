#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "GPEA011API.CH"
#Include "TBICONN.CH"
#Include "FWAdapterEAI.ch"

#DEFINE PAGESIZE_DEFAULT 2000
#DEFINE PAGE_DEFAULT     1

#DEFINE TAB 			 CHR ( 13 ) + CHR ( 10 )


/*
{Protheus.doc} PayrollControl
	API de Controle de Pagamentos de Benefícios                              
		
	@author	Wesley Alves Pereira
	@version	P12
	@since	07/05/2019
*/

WSRESTFUL PayrollControl DESCRIPTION STR0001 FORMAT "application/json" // STR0001: "Serviço genérico para retorno das informações de Controle de Pagamentos de Benefícios."
	WSDATA companyId	 As String
	WSDATA branchId	     As String
	WSDATA product	     As String
	WSDATA providerType  AS String
	WSDATA page			 As Integer Optional
	WSDATA pageSize		 As Integer Optional
	WSDATA dateModified	 As String  Optional

	WSMETHOD GET DESCRIPTION oEmToAnsi(STR0006) PRODUCES 'application/json;charset=utf-8' WSSYNTAX "/rh/v1/PayrollControl/ || /rh/v1/PayrollControl/{id}" TTALK "v1"TTALK "v1"

END WSRESTFUL

WSMETHOD GET WSRECEIVE companyId, branchId, product, providerType, page, pageSize, dateModified WSSERVICE PayrollControl
	Local cResponse 	:= ""
	Local lRet 			:= .T.
	Local aEmpre        := {}
	
	Local cCompanId := ""
	Local cBranchId := ""
	Local cNomeProd := ""
	Local cTpBenefi := ""
	Local nNumePage	:= 1
	Local nPageSize := 1
	Local cDtUpDate := ""
	
	Local oGroupData := JsonObject():new()
		
	Private bError      := { |e| oError := e, Break(e) }
	Private bErrorBlock := ErrorBlock( bError )
	Private oError
	
	DEFAULT Self:companyId 		:= ""
	DEFAULT Self:branchId 		:= ""
	DEFAULT Self:product 		:= ""
	DEFAULT Self:providerType   := ""
	DEFAULT Self:page 			:= PAGE_DEFAULT
	DEFAULT Self:pageSize 		:= PAGESIZE_DEFAULT
	DEFAULT Self:dateModified 	:= ""
	
	BEGIN SEQUENCE
	
		cCompanId := Self:companyId
		cBranchId := Self:branchId
		cNomeProd := Self:product
		cTpBenefi := Self:providerType
		nNumePage := Self:page
		nPageSize := Self:pageSize
		cDtUpDate := Self:dateModified
		
		fResetErrorHandler()
		fSetErrorHandler(oEmToAnsi(STR0010)) // STR0010: "Erro ao preparar o ambiente com a Empresa e Filial informados!"
		
		// Set Default nPageSize
		If ( Empty(nPageSize)) .OR. ( nPageSize > PAGESIZE_DEFAULT ) .OR. ( nPageSize < 1 )
			nPageSize := PAGESIZE_DEFAULT
		EndIf
		
		// Set Default nPage
		If ( Empty(nNumePage)) .OR. ( nNumePage < 1 )
			nNumePage := PAGE_DEFAULT
		EndIf

		If ! fcheckInfor(cCompanId,cBranchId,cNomeProd,cTpBenefi,nNumePage,nPageSize,cDtUpDate)		
			lRet := .F.
			Return ( lRet )
		EndIf
		
		RESET ENVIRONMENT
		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA cCompanId FILIAL cBranchId TABLES "SRA", "RCC", "RFQ", "RCH", "RHR", "RHS" MODULO "GPE"
		
		fResetErrorHandler()
		
		fSendError(500,STR0009,.T.,500,STR0009,,) // STR0009: "Falha ao buscar o banco de dados do cliente!"
		
		// Create employeeList Object And items
		lRet := fGetData(@oGroupData, cTpBenefi, nNumePage, nPageSize, cDtUpDate)
		
		// Compress String And Set Response
		cResponse := fCompress(@oGroupData)
		::SetResponse(cResponse)		

	RECOVER
		lRet := .F.
		ErrorBlock(bErrorBlock)
		fSendError(500,oError:Description,.T.,500,STR0002,,) // STR0002: "Ocorreu uma falha no retorno da informação."		
	END SEQUENCE

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} function fSetErrorHandler
Seta código e mensagem de erro
@author  Wesley Alves Pereira
@since   02/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fSetErrorHandler(cTitle)

bError  := { |e| oError := e , oError:Description := cTitle + TAB + oError:Description, Break(e) }
bErrorBlock    := ErrorBlock( bError )

Return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} function fResetErrorHandler
Reseta código e mensagem de erro
@author  Wesley Alves Pereira
@since   02/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fResetErrorHandler(cTitle)

bError  := { |e| oError := e , Break(e) }
bErrorBlock    := ErrorBlock( bError )

Return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} function fcheckInfor
Valida as informações recebidas na assinatura da mensagem
@author  Wesley Alves Pereira
@since   03/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fcheckInfor(cCompanId,cBranchId,cNomeProd,cTpBenefi,nNumePage,nPageSize,cDtUpDate)
Local dDataAss
Local lRHRGA  := If(RHR->(ColumnPos("RHR_USERGA")) > 0, .T., .F.)
Local lRHSGA  := If(RHS->(ColumnPos("RHS_USERGA")) > 0, .T., .F.)
Local cMessage := ""
Local cFormData := " (yyyy-mm-ddThh:mm:ss)"
If Empty(cCompanId)
	cMessage := oEmToAnsi(STR0004) + "companyId"
ElseIf Empty(cBranchId)
	cMessage := oEmToAnsi(STR0004) + "branchId"
ElseIf Empty(cNomeProd)
	cMessage := oEmToAnsi(STR0004) + "product"
ElseIf ! ( cTpBenefi $ "12A" )
	cMessage := oEmToAnsi(STR0004) + "providerType"
EndIf

If ! Empty( cDtUpDate ) 
	If ! fValidDate(cDtUpDate)
		cMessage := oEmToAnsi(STR0004) + "dateModified" + cFormData
	EndIf
EndIf

If ! Empty( cDtUpDate )
	dDataAss := fClearDate(cDtUpDate) 
	lDataUp := .T.
	
	If Empty(cMessage)
		If Empty( dDataAss ) 
			cMessage := oEmToAnsi(STR0004) + "dateModified" + cFormData
		EndIf
	EndIf
EndIf

If Empty(cMessage)
	If ! FWFilExist(cCompanId,cBranchId)
		cMessage := oEmToAnsi(STR0004) + "companyId + branchId "
	EndIf	
EndIf

If Empty(cMessage)
	If !lRHRGA
		cMessage := oEmToAnsi(STR0003) + oEmToAnsi(STR0007)// STR0003 + STR0007 : "Campo USERLGA não foi encontrado. Entidade (RHR)."
	Elseif !lRHSGA
		cMessage := oEmToAnsi(STR0003) + oEmToAnsi(STR0005)// STR0003 + STR0005 : "Campo USERLGA não foi encontrado. Entidade (RHS)."
	Endif
EndIf

If ! Empty(cMessage)
	
	fSendError(400,cMessage,.T.,400,cMessage,,)
	
	Return (.F.)
	
EndIf

Return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} function fGetData
Busca os dados referente ao pagamento dos beneficios
@author  Wesley Alves Pereira
@since   02/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fGetData(oGroupData, cTpBenefi, nNumePage, nPageSize, cDtUpDate)

	Local cQuery  	 := ""
	Local lRet 		 := .T.
	Local dDataAss
	Local lDataUp    := .F.
	Local cDataMov   := ""
	Local cDataPag   := ""
	Local nPos       := 0
	Local cCodFor    := ""
	Local oItemData
	Local aItemQry   := {}    
	Local oCabecData := JsonObject():new()
	Local cDataBase  := TcGetDB() 
	Local cIdTab := ""
	
	Local cQrAlias := GetNextAlias()
	
	If ! Empty( cDtUpDate )
		dDataAss := fClearDate(cDtUpDate) 
		lDataUp := .T.
	EndIf
	
	// Create Paging Control
	cQuery := "		SELECT JSO.* FROM ( "
		
	If cDataBase == "ORACLE"
		cQuery +=  "	SELECT ROWNUM ITEMNUMBER, COUNT(1) OVER() AS TOTALNUMBER, DADOS.*  "
	ElseIF cDataBase == "POSTGRES"
		cQuery += "		SELECT ROW_NUMBER() OVER( ORDER BY FLAG ) ITEMNUMBER, COUNT (1) OVER() TOTALNUMBER, DADOS.* "
	Else
		cQuery += "		SELECT ROW_NUMBER() OVER( ORDER BY FLAG ) ITEMNUMBER, COUNT(1) OVER() TOTALNUMBER, DADOS.* "
	EndIf
	
	cQuery += "			FROM (	"
	cQuery += "			SELECT 'ABERTO' AS FLAG,	" 	
	cQuery += "					SRA.RA_FILIAL FIL_FUNC,	"
	cQuery += "					SRA.RA_MAT    MAT_FUNC,	"
	cQuery += "					RHR.RHR_DATA DT_MOVIMENT, 	"
	cQuery += "					CASE RHR.RHR_ORIGEM WHEN '1' THEN '1 - Titular'	"
	cQuery += "										WHEN '2' THEN '2 - Dependente'	"
	cQuery += "										WHEN '3' THEN '3 - Agregado'	"
	cQuery += "										ELSE '4 - Outros'	"
	cQuery += "					END AS ORIGEM,	" 
	cQuery += "					RHR.RHR_CODFOR COD_PROVEDOR,	"
	cQuery += "					CASE RHR.RHR_TPFORN WHEN '1' THEN '1 - Ass. Medica'	"
	cQuery += "										WHEN '2' THEN '2 - Ass. Odontologica'	"							
	cQuery += "										ELSE '3 - Outros'	"
	cQuery += "					END AS TIP_PROVEDOR,	" 
	cQuery += "					'' COD_CONTRATO,	"
	cQuery += "					RHR.RHR_PLANO COD_PLANO,	"
	cQuery += "					RHR.RHR_PD IDENT_PAG,	"
	cQuery += "					RHR.RHR_VLRFUN VAL_FUN,	"
	cQuery += "					RCH.RCH_DTPAGO PER_PAG,	"
	cQuery += "					RHR.RHR_TPPLAN TIP_PLAN,"
	cQuery += "					RHR.RHR_COMPPG COM_PAG,	"
	cQuery += "					RHR.RHR_CODIGO COD_PAG,	"
	cQuery += "					RHR.RHR_TPLAN  TP_PLAN	"
	
	cQuery += "			FROM "+RetSqlName("RFQ") + " RFQ, " +RetSqlName("RCH") + " RCH, " +RetSqlName("SRA") + " SRA," +RetSqlName("RHR") + " RHR" 
	cQuery += "			WHERE RFQ.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   RCH.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   SRA.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   RHR.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   RFQ.RFQ_PERIOD = RHR.RHR_COMPPG "	
	cQuery += "			AND   RFQ.RFQ_PERIOD = RCH.RCH_PER	"
	cQuery += "			AND   RFQ.RFQ_PROCES = RCH.RCH_PROCES	"
	cQuery += "			AND   RFQ.RFQ_ANO    = RCH.RCH_ANO	"
	cQuery += "			AND   RFQ.RFQ_MES    = RCH.RCH_MES	"
	cQuery += "			AND   RFQ.RFQ_MODULO = RCH.RCH_MODULO	"
	cQuery += "			AND   RFQ.RFQ_NUMPAG = RCH.RCH_NUMPAG	"
	cQuery += "			AND   RFQ.RFQ_PROCES = SRA.RA_PROCES	"
	cQuery += "			AND   SRA.RA_MAT     = RHR.RHR_MAT	"
	cQuery += "			AND	  RHR.RHR_ORIGEM IN ('1','2')	"
	cQuery += "			AND   RCH.RCH_ROTEIR = 'PLA'	"
	cQuery += "			AND   RCH.RCH_DTFECH = ' '	"

	If cTpBenefi == '1'
		cQuery += "			AND   RHR.RHR_TPFORN = '1' " //1 = MEDICO / 2 = ODONTO
	ElseIf cTpBenefi == '2'
		cQuery += "			AND   RHR.RHR_TPFORN = '2' " //1 = MEDICO / 2 = ODONTO
	EndIf	
	
	cQuery += "			AND   RFQ.RFQ_FILIAL = '" +xFilial("RFQ") + "'" 
	cQuery += "			AND   RCH.RCH_FILIAL = '" +xFilial("RCH") + "'"
	cQuery += "			AND   SRA.RA_FILIAL  = '" +xFilial("SRA") + "'" 
	cQuery += "			AND   RHR.RHR_FILIAL = '" +xFilial("RHR") + "'"
	
	If lDataUp
		cQuery += "     AND RHR_USERGA <> ' ' "
			If cDataBase == "ORACLE"
				cQuery += " 	AND REPLACE(TO_DATE('19960101','YYYYMMDD') + TO_NUMBER(CONCAT(TO_CHAR(ASCII(SUBSTR(RTRIM(RHR_USERGA),12,1))-50), TO_CHAR(ASCII(SUBSTR(RHR_USERGA,16,1))-50))) ,'/','') >= '" + DTOS(dDataAss) + "'"		
			ElseIF cDataBase == "POSTGRES"
				cQuery += "AND (REPLACE(CAST(to_date('19960101','YYYYMMDD') + " 
				cQuery += "CAST(CONCAT(REPLACE(CAST((ASCII(SUBSTR(RHR_USERGA,12,1))-50) AS VARCHAR),' ',''),"
				cQuery += "REPLACE(CAST((ASCII(SUBSTR(RHR_USERGA,16,1))-50) AS VARCHAR),' ','')) AS INT ) AS VARCHAR ),'-','')) >= '" + DTOS(dDataAss) + "' "
			ElseIF cDataBase == "DB2"
				cQuery += " AND REPLACE(CONVERT(CHARACTER,DATEADD(DAY,CAST(CONCAT(REPLACE(CAST(ASCII(SUBSTR(RHR_USERGA,12,1))-50 AS CHAR),' ',''),REPLACE(CAST(ASCII(SUBSTR(RHR_USERGA,16,1))-50 AS CHAR),' ','')) AS INT) '19960101'),102),'.','')   >= '" + DTOS(dDataAss) + "'"
			ElseIF cDataBase == "INFORMIX"
				cQuery += " AND REPLACE(CAST(CAST( ADD_DAYS ('1996-01-01',CAST(CONCAT(REPLACE(CAST(ASCII(SUBSTR(RHR_USERGA,12,1))-50 AS CHAR),' ',''),REPLACE(CAST(ASCII(SUBSTR(RHR_USERGA,16,1))-50 AS CHAR),' ',''))AS INT)) AS INT) AS CHAR),'.','') >= '" + DTOS(dDataAss) + "'"
			ElseIF cDataBase == "MYSQL"
				cQuery += " AND REPLACE(CONVERT(CHARACTER,DATEADD(DAY,CAST(CONCAT(REPLACE(CAST(ASCII(SUBSTR(RHR_USERGA,12,1))-50 AS CHAR),' ',''),REPLACE(CAST(ASCII(SUBSTR(RHR_USERGA,16,1))-50 AS CHAR),' ','')) AS INT),'19960101'),102),'.','')   >= '" + DTOS(dDataAss) + "'"
			Else
				cQuery += " AND REPLACE(CONVERT(VARCHAR, DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHR_USERGA),12,1))-50)+CONVERT(VARCHAR,ASCII(SUBSTRING(RHR_USERGA,16,1))-50)),'19960101'), 102),'.','')   >= '" + DTOS(dDataAss) + "'"			
		EndIf
	EndIf	
					
	cQuery += "			UNION ALL	" 
					
	cQuery += "			SELECT 'FECHADO' AS FLAG,	" 		
	cQuery += "					SRA.RA_FILIAL FIL_FUNC,	"
	cQuery += "					SRA.RA_MAT    MAT_FUNC,	"
	cQuery += "					RHS.RHS_DATA DT_MOVIMENT, 	"
	cQuery += "					CASE RHS.RHS_ORIGEM WHEN '1' THEN '1 - Titular'	"
	cQuery += "										WHEN '2' THEN '2 - Dependente'	"
	cQuery += "										WHEN '3' THEN '3 - Agregado'	"
	cQuery += "										ELSE '4 - Outros'	"
	cQuery += "					END AS ORIGEM,	" 
	cQuery += "					RHS.RHS_CODFOR COD_PROVEDOR,	"
	cQuery += "					CASE RHS.RHS_TPFORN WHEN '1' THEN '1 - Ass. Medica'	"
	cQuery += "										WHEN '2' THEN '2 - Ass. Odontologica'	"							
	cQuery += "										ELSE '3 - Outros'	"
	cQuery += "					END AS TIP_PROVEDOR,	" 
	cQuery += "					'' COD_CONTRATO,	"
	cQuery += "					RHS.RHS_PLANO COD_PLANO,	"
	cQuery += "					RHS.RHS_PD IDENT_PAG,	"
	cQuery += "					RHS.RHS_VLRFUN VAL_FUN,	"
	cQuery += "					RHS.RHS_DATPGT PER_PAG,	"
	cQuery += "					RHS.RHS_TPPLAN TIP_PLAN,"
	cQuery += "					RHS.RHS_COMPPG COM_PAG,	"
	cQuery += "					RHS.RHS_CODIGO COD_PAG,	"
	cQuery += "					RHS.RHS_TPLAN  TP_PLAN	"
	
	cQuery += "			FROM "+RetSqlName("RFQ") + " RFQ, " +RetSqlName("RCH") + " RCH, " +RetSqlName("SRA") + " SRA," +RetSqlName("RHS") + " RHS" 
	cQuery += "			WHERE RFQ.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   RCH.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   SRA.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   RHS.D_E_L_E_T_ <> '*'	"
	cQuery += "			AND   RFQ.RFQ_PERIOD = RHS.RHS_COMPPG "
	cQuery += "			AND   RFQ.RFQ_PERIOD = RCH.RCH_PER	"
	cQuery += "			AND   RFQ.RFQ_PROCES = RCH.RCH_PROCES	"
	cQuery += "			AND   RFQ.RFQ_ANO    = RCH.RCH_ANO	"
	cQuery += "			AND   RFQ.RFQ_MES    = RCH.RCH_MES	"
	cQuery += "			AND   RFQ.RFQ_MODULO = RCH.RCH_MODULO	"
	cQuery += "			AND   RFQ.RFQ_NUMPAG = RCH.RCH_NUMPAG	"
	cQuery += "			AND   RFQ.RFQ_PROCES = SRA.RA_PROCES	"
	cQuery += "			AND   SRA.RA_MAT     = RHS.RHS_MAT	"
	cQuery += "			AND	  RHS.RHS_ORIGEM IN ('1','2')	"
	cQuery += "			AND   RCH.RCH_ROTEIR = 'PLA'	"
	cQuery += "			AND   RCH.RCH_DTFECH <> ' '	"
	
	If cTpBenefi == '1'
		cQuery += "			AND   RHS.RHS_TPFORN = '1'" //1 = MEDICO / 2 = ODONTO	"
	ElseIf cTpBenefi == '2'
		cQuery += "			AND   RHS.RHS_TPFORN = '2'" //1 = MEDICO / 2 = ODONTO	"
	EndIf
	
	cQuery += "			AND   RFQ.RFQ_FILIAL = '" +xFilial("RFQ") + "'" 
	cQuery += "			AND   RCH.RCH_FILIAL = '" +xFilial("RCH") + "'"
	cQuery += "			AND   SRA.RA_FILIAL  = '" +xFilial("SRA") + "'" 
	cQuery += "			AND   RHS.RHS_FILIAL = '" +xFilial("RHS") + "'"
	
	If lDataUp
		cQuery += "     AND RHS_USERGA <> ' ' "
			If cDataBase == "ORACLE"
				cQuery += " 	AND REPLACE(TO_DATE('19960101','YYYYMMDD') + TO_NUMBER(CONCAT(TO_CHAR(ASCII(SUBSTR(RTRIM(RHS_USERGA),12,1))-50), TO_CHAR(ASCII(SUBSTR(RHS_USERGA,16,1))-50))) ,'/','') >= '" + DTOS(dDataAss) + "'"		
			ElseIF cDataBase == "POSTGRES"
				cQuery += "AND (REPLACE(CAST(to_date('19960101','YYYYMMDD') + " 
				cQuery += "CAST(CONCAT(REPLACE(CAST((ASCII(SUBSTR(RHS_USERGA,12,1))-50) AS VARCHAR),' ',''),"
				cQuery += "REPLACE(CAST((ASCII(SUBSTR(RHS_USERGA,16,1))-50) AS VARCHAR),' ','')) AS INT ) AS VARCHAR ),'-','')) >= '" + DTOS(dDataAss) + "' "
			ElseIF cDataBase == "DB2"
				cQuery += " AND REPLACE(CONVERT(CHARACTER,DATEADD(DAY,CAST(CONCAT(REPLACE(CAST(ASCII(SUBSTR(RHS_USERGA,12,1))-50 AS CHAR),' ',''),REPLACE(CAST(ASCII(SUBSTR(RHS_USERGA,16,1))-50 AS CHAR),' ','')) AS INT) '19960101'),102),'.','')   >= '" + DTOS(dDataAss) + "'"
			ElseIF cDataBase == "INFORMIX"
				cQuery += " AND REPLACE(CAST(CAST( ADD_DAYS ('1996-01-01',CAST(CONCAT(REPLACE(CAST(ASCII(SUBSTR(RHS_USERGA,12,1))-50 AS CHAR),' ',''),REPLACE(CAST(ASCII(SUBSTR(RHS_USERGA,16,1))-50 AS CHAR),' ',''))AS INT)) AS INT) AS CHAR),'.','') >= '" + DTOS(dDataAss) + "'"
			ElseIF cDataBase == "MYSQL"
				cQuery += " AND REPLACE(CONVERT(CHARACTER,DATEADD(DAY,CAST(CONCAT(REPLACE(CAST(ASCII(SUBSTR(RHS_USERGA,12,1))-50 AS CHAR),' ',''),REPLACE(CAST(ASCII(SUBSTR(RHS_USERGA,16,1))-50 AS CHAR),' ','')) AS INT),'19960101'),102),'.','')   >= '" + DTOS(dDataAss) + "'"
			Else
				cQuery += " AND REPLACE(CONVERT(VARCHAR, DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHS_USERGA),12,1))-50)+CONVERT(VARCHAR,ASCII(SUBSTRING(RHS_USERGA,16,1))-50)),'19960101'), 102),'.','')   >= '" + DTOS(dDataAss) + "'"			
		EndIf
	EndIf	
	 
	cQuery += "			) DADOS "
	
	cQuery += "			) JSO"
	cQuery += "	        WHERE JSO.ITEMNUMBER BETWEEN " + Alltrim(Str((nNumePage - 1) * nPageSize + 1)) + " AND " + Alltrim(Str((nNumePage * nPageSize))) + " "
	cQuery += "			ORDER BY 1,2,3,4,5	"
	
	DBUseArea( .T., "TOPCONN", TcGenQry( , ,cQuery), cQrAlias, .T., .T. )
	
	// Check return Query
	IF !fValid(nNumePage, (cQrAlias)->ITEMNUMBER)
		lRet := .F.
	Endif
	
	(cQrAlias)->(DBGoTop())
	
	If lRet
	
		oCabecData['total'] := (cQrAlias)->TOTALNUMBER
		
		// Get items Properties
		While (cQrAlias)->(!Eof())
			
			cDataMov := SubStr((cQrAlias)->DT_MOVIMENT,1,4)+"-"+SubStr((cQrAlias)->DT_MOVIMENT,5,2)+"-"+SubStr((cQrAlias)->DT_MOVIMENT,7,2)+"T"+"00:00:00"
			If !Empty((cQrAlias)->PER_PAG)
				cDataPag := SubStr((cQrAlias)->PER_PAG,1,4)+"-"+SubStr((cQrAlias)->PER_PAG,5,2)+"-"+SubStr((cQrAlias)->PER_PAG,7,2)+"T"+"00:00:00"
			Else
				cDataPag := " "
			EndIf
			
			nPos := fPosTab( "S074",(cQrAlias)->COD_PROVEDOR,"=",7,SubStr((cQrAlias)->TIP_PROVEDOR,1,1),"=",6,,,,.T.,(cQrAlias)->FIL_FUNC,,,,,,,.T.,.T.)
			cCodFor := fTabela("S074", nPos , 4)   
			
			oItemData := JsonObject():new()
			
			cIdTab := cEmpAnt                                         	+ "|"
			cIdTab += (cQrAlias)->FIL_FUNC								+ "|"
			cIdTab += (cQrAlias)->MAT_FUNC								+ "|"	 
			cIdTab += (cQrAlias)->COM_PAG								+ "|"
			cIdTab += SubStr(Alltrim((cQrAlias)->ORIGEM),1,1) 			+ "|"
			cIdTab += (cQrAlias)->COD_PAG 								+ "|"
			cIdTab += (cQrAlias)->TP_PLAN								+ "|"
			cIdTab += SubStr(Alltrim((cQrAlias)->TIP_PROVEDOR),1,1)		+ "|"
			cIdTab += (cQrAlias)->COD_PROVEDOR							+ "|"
			cIdTab += (cQrAlias)->TIP_PLAN								+ "|"
			cIdTab += (cQrAlias)->COD_PLANO								+ "|"
			cIdTab += (cQrAlias)->IDENT_PAG								
			
			oItemData["companyKey"]        := cEmpAnt + "|" + cFilAnt 						     
			oItemData["branch"]            := (cQrAlias)->FIL_FUNC			  						     
			oItemData["code"]              := (cQrAlias)->MAT_FUNC			 						     
			oItemData["internalIdCode"]    := cEmpAnt + "|" + (cQrAlias)->FIL_FUNC + "|" + (cQrAlias)->MAT_FUNC
			oItemData["movimentDate"]      := cDataMov											 
			oItemData["originalRecord"]    := Alltrim((cQrAlias)->ORIGEM)										 
			oItemData["providerCode"]      := (cQrAlias)->COD_PROVEDOR									 
			oItemData["providerType"]      := Alltrim((cQrAlias)->TIP_PROVEDOR)					
			oItemData["contractCode"]      := Alltrim(cCodFor)			
			oItemData["productCode"]       := (cQrAlias)->COD_PLANO
			oItemData["payrollIdentifier"] := (cQrAlias)->IDENT_PAG
			oItemData["paymentAmount"]     := Alltrim(Transform((cQrAlias)->VAL_FUN,"@R 99999999999.99"))
			oItemData["paymentDate"]       := cDataPag
			oItemData["paymentPeriod"]     := (cQrAlias)->COM_PAG
			oItemData["id"]                := cIdTab
			
			AAdd(aItemQry, oItemData )
			
			oCabecData["hasNext"] 		  := Iif((cQrAlias)->ITEMNUMBER >= (cQrAlias)->TOTALNUMBER, .F., .T.)			
						
			(cQrAlias)->(DBSkip())
			
		EndDo
		
		oCabecData["items"] := aItemQry
		
		oGroupData := oCabecData
		
	EndIf

	fResetErrorHandler()
	(cQrAlias)->(DbCloseArea())

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} function fValid
Valida os dados da assinatura do metodo
@author  Wesley Alves Pereira
@since   02/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fValid(nNumePage, nItemNumb)
	Local cMessage := ""
	
	// Check Page
	If nItemNumb == 0
		cMessage := oEmToAnsi(STR0011) // STR0011: "Nenhum registro localizado."
	ElseIf nNumePage > nItemNumb
		cMessage := oEmToAnsi(STR0008) // STR0008: "A página solicitada é maior do que a quantidade disponível na consulta"
	EndIf

	If ! Empty(cMessage)
		fSendError(404,cMessage,.T.,404,cMessage,,)
		Return (.F.)
	Endif
	
Return (.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} function fCompress
Compacta os dados do retorno solicitado
@author  Wesley Alves Pereira
@since   02/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fCompress(oObj)
	Local cJson    := ""
	Local cComp    := ""
	Local lCompact := .F.
	
	// Set gzip format to Json Object
	cJson := FWJsonSerialize(oObj,.T.,.T.)

	If Type("::GetHeader('Accept-Encoding')") != "U"  .and. 'GZIP' $ Upper(::GetHeader('Accept-Encoding') )
		lCompact := .T.
	EndIf
	
	If(lCompact)
		::SetHeader('Content-Encoding','gzip')
		GzStrComp(cJson, @cComp, @nLenComp )
	Else
		cComp := cJson
	Endif

Return cComp

/*/{Protheus.doc} function fDateValid
Verify Date Input
@author  Wesley Alves Pereira
@since   02/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fValidDate(cDate)
	Local lRet := .T.

	// Formato Considerado como válido: "2001-01-01T18:25:43"
	If !Empty(cDate)
		If  SubStr(cDate, 5,  1) != "-" .OR. SubStr(cDate, 8,  1) != "-" .OR. ;
			SubStr(cDate, 11, 1) != "T" .OR. SubStr(cDate, 14, 1) != ":" .OR. ; 
			SubStr(cDate, 17, 1) != ":" 
				lRet := .F.
		EndIf
	EndIf
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} function ClearDate
Clean especial character from Date Input. Input Format: 2012-04-23T18:25:43
@author  Wesley Alves Pereira
@since   02/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fClearDate(cDate)
Local dData := STOD("")
	
	cDate := StrTran(cDate, "T", "")
	cDate := StrTran(cDate, ":", "")
	cDate := StrTran(cDate, "-", "")
	cDate := SubStr(cDate,1,8)
	dData := StoD(cDate)
	
Return ( dData )


//-------------------------------------------------------------------
/*/{Protheus.doc} function SendError
Gera as mensagens de erro tratados para o retorno REST/JSON
@author  Wesley Alves Pereira
@since   23/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fSendError(nCode,cMessage,lJson,nStatus,cDetailMsg,cHelpUrl,aDetails)

DEFAULT nCode := 500
DEFAULT cMessage := STR0002
DEFAULT lJson := .T.
DEFAULT nStatus := 500
Default cDetailMsg := STR0002
Default cHelpUrl := "http://tdn.totvs.com/x/Uzh_HQ"
DEFAULT aDetails := {}

SetRestFault(nCode,encodeUTF8(cMessage),lJson,nStatus,encodeUTF8(cDetailMsg),cHelpUrl,aDetails)

Return (.T.)