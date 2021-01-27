#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "GPEA003API.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWAdapterEAI.ch"

#DEFINE PAGESIZE_DEF	2000
#DEFINE ERRORCODE_DEF	400
#DEFINE ERRORSRV_DEF	500
#DEFINE TAB  			CHR ( 13 ) + CHR ( 10 )
#DEFINE URL_DEF			"http://tdn.totvs.com/x/Uzh_HQ"

// STR0001: "Serviço genérico para retorno das informações de coparticipação dos beneficiários referente aos benefícios a eles vinculados."
WSRESTFUL BeneficiariesCoparticipation DESCRIPTION oEmToAnsi(STR0001) FORMAT "application/json"
	WSDATA authorization As String
	WSDATA companyId	 As String
	WSDATA branchId	     As String
    WSDATA product	     As String
	WSDATA page			 As Integer Optional
	WSDATA pageSize		 As Integer Optional
	WSDATA datemodified	 As String  Optional

	// STR0004: "Exemplo de retorno de coparticipação."
	WSMETHOD GET DESCRIPTION oEmToAnsi(STR0004) PRODUCES APPLICATION_JSON WSSYNTAX "rh/v1/BeneficiariesCoparticipation/" PATH "rh/v1/BeneficiariesCoparticipation/" TTALK "v1"
END WSRESTFUL


WSMETHOD GET QUERYPARAM companyId, branchId, page, pageSize, datemodified, product HEADERPARAM authorization WSSERVICE BeneficiariesCoparticipation
	Local cResponse 	:= ""
	Local lRet 			:= .T.
	Local aEmpre        := {}
	Local oEmpData	    := JsonObject():New()
	Local nPage 		:= 0
	Local nPageSize  	:= 0
	Local cDateMod 	 	:= ""
	Local cCompId 		:= ""
	Local cBranchId  	:= ""
    Local cProd 		:= ""

	Private bError      := { |e| oError := e, Break(e) }
	Private bErrorBlock := ErrorBlock( bError )
	Private oError

	DEFAULT Self:authorization  := ""
	DEFAULT Self:page 			:= 1
	DEFAULT Self:pageSize 		:= PAGESIZE_DEF
	DEFAULT Self:datemodified 	:= ""
	DEFAULT Self:companyId 		:= ""
	DEFAULT Self:branchId 		:= ""
    DEFAULT Self:product 		:= ""

	BEGIN SEQUENCE
		nPage 	   := Self:page
		nPageSize  := Self:pageSize
		cDateMod   := Self:datemodified
		cCompId    := Self:companyId
		cBranchId  := Self:branchId
        cProd	   := Self:product

		// Verify PreValidations
		IF !fPreValid(@oEmpData, cBranchId, cDateMod, cCompId, cProd)
			lRet := .F.
		Endif

		If lRet
			fSetErrorHandler(EncodeUTF8(STR0005)) // STR0005: "Erro ao preparar o ambiente com a Empresa e Filial informados!"
			
			// Set nPageSize
			IF (nPageSize < 1) .OR. (nPageSize > PAGESIZE_DEF)
				nPageSize := PAGESIZE_DEF
			EndIf

			// Set nPage
			If nPage < 1
				nPage := 1
			EndIf

			// Prepare Environment
			aEmpre := FWSM0Util():GetSM0Data( cCompId , cBranchId, { "M0_CODIGO", "M0_CODFIL" } )

			// companyId Validation
			If Empty(aEmpre)
				
				// STR0006: "De-Para de Empresa e Filial não encontrado na base para companyId." STR0007: "e BranchId"
				SetRestFault(ERRORCODE_DEF, EncodeUTF8(STR0006) + " '" + cCompId + "' "+ EncodeUTF8(STR0007) + " '" + cBranchId + "' !", , , , URL_DEF, )
				lRet := .F.
			EndIf
		
			If lRet
				RESET ENVIRONMENT
				RPCSetType(3)
				PREPARE ENVIRONMENT EMPRESA aEmpre[1][2] FILIAL aEmpre[2][2] TABLES "RHO", "RHP" MODULO "GPE"
				fResetErrorHandler()

				// Get Data
				lRet := fGetData(@oEmpData, nPage, nPageSize, cDateMod, cBranchId)
			EndIf

		EndIf

		// Compress String And Set Response
		cResponse := fCompress(@oEmpData)
		::SetResponse(cResponse)

	RECOVER
		lRet := .f.
		ErrorBlock(bErrorBlock)
		SetRestFault(ERRORSRV_DEF, EncodeUTF8(STR0008) + TAB + oError:Description, , , , URL_DEF, ) // STR0008: "Ocorreu uma falha no retorno da informação."
	END SEQUENCE

Return lRet	


// Get Requested Data
Static Function fGetData(oEmpData, page, nPageSize, cDateMod, cBranchId)
	Local oItemData
	Local nPosTab		:= 0
	Local cQuery  		:= ""
	Local cPeriodo		:= ""
	Local cCurenReg 	:= ""
	Local lRet 			:= .T.
	Local aItemQry 		:= {}
	Local cAlias 		:= GetNextAlias()
	Local cAliasPer 	:= GetNextAlias()
	Local oHeadData		:= JsonObject():new()
	Local cDataBase 	:= AllTrim( Upper( TcGetDb() ) )

	DEFAULT oEmpData := JsonObject():New()

	oHeadData["hasNext"] := .T.

	fSetErrorHandler(EncodeUTF8(STR0014)) // STR0014: "Falha ao buscar dados do cliente!"

	// Verifiy opened conections
	If Select ("RHO") > 0
		RHO->( dbCloseArea() )
	Endif
	
	If Select ("RHP") > 0
		RHP->( dbCloseArea() )
	Endif

	If !Empty(cDateMod)
		cDateMod := fDateFormat(cDateMod)

		// Create Paging Control
		cQuery := "SELECT RCHQRY.DTFECH DTFECH, RCHQRY.PERIODO PERIODO FROM ( "
		cQuery += "SELECT RCH_DTFECH DTFECH, RCH_PER PERIODO FROM "+ RetSqlName("RCH") + " WHERE RCH_PER IN ( "
		cQuery += "SELECT RFQ_PERIOD as PERIODO FROM ( "

		If cDataBase == "ORACLE"
			cQuery += "SELECT RFQ_PERIOD, ROWNUM ITEMNUMBER "
		Else
			cQuery += "SELECT RFQ_PERIOD, ROW_NUMBER() OVER( ORDER BY RFQ_PERIOD ) ITEMNUMBER "
		EndIf

		cQuery += "FROM "+ RetSqlName("RFQ") + " "
		cQuery += "WHERE RFQ_FILIAL = '" + xFilial("RFQ", cBranchId) + "'  AND ('" + cDateMod + "' BETWEEN RFQ_DTINI AND RFQ_DTFIM) AND RFQT10.D_E_L_E_T_ = ' ' "
		cQuery += ") RFQQRY "
		cQuery += "WHERE RFQQRY.ITEMNUMBER = 1 "
		cQuery += ") AND RCH_FILIAL = '" + xFilial("RCH", cBranchId) + "' AND RCH_ROTEIR = 'PLA' "
		cQuery += ") RCHQRY "

		// Execute Query
		DBUseArea( .T., "TOPCONN", TcGenQry( , ,cQuery), cAliasPer, .T., .T. )

		If (cAliasPer)->(!Eof())
			cPeriodo := (cAliasPer)->PERIODO

			// Query
			cQuery := "SELECT * FROM ( "

			If cDataBase == "ORACLE"
				cQuery +=  "SELECT ROWNUM ITEMNUMBER, COUNT(1) OVER() AS TOTALNUMBER,"
			Else
				cQuery += "SELECT ROW_NUMBER() OVER( ORDER BY MAT ) ITEMNUMBER, COUNT (1) OVER() TOTALNUMBER,"
			EndIf

			cQuery += 	"SOURCETABLE,FILIAL,MAT,DT_OCOR,TPFORN, CODFOR,ORIGEM,CODIGO,PD,COMPPG,VLRFUN,CDESPE,CID,TPATEN "
			cQuery += 	"FROM ( "
			cQuery += 		"SELECT " 
			cQuery += 			"'RHO' 		AS SOURCETABLE, "
			cQuery += 			"RHO_MAT 	AS MAT, "
			cQuery += 			"RHO_DTOCOR AS DT_OCOR, "
			cQuery += 			"RHO_TPFORN AS TPFORN, "
			cQuery += 			"RHO_CODFOR AS CODFOR, "
			cQuery += 			"RHO_CODIGO AS CODIGO, "
			cQuery += 			"RHO_PD 	AS PD, "
			cQuery += 			"RHO_COMPPG AS COMPPG, "
			cQuery += 			"RHO_FILIAL AS FILIAL, "
			cQuery += 			"RHO_ORIGEM AS ORIGEM, "
			cQuery += 			"RHO_VLRFUN	AS VLRFUN, "
			cQuery += 			"RHO_CDESPE	AS CDESPE, "
			cQuery += 			"RHO_CID 	AS CID, "
			cQuery += 			"RHO_TPATEN	AS TPATEN "
			cQuery += 		"FROM " + RetSqlName("RHO") + " RHO "
			cQuery += 		"WHERE "
			cQuery += 			"RHO_FILIAL 	= '" + xFilial("RHO", cBranchId) + "' "
			cQuery += 			"AND RHO_TPLAN 	= '1' "
			cQuery += 			"AND RHO_COMPPG = '" + cPeriodo + "' "
			cQuery += 			"AND RHO.D_E_L_E_T_ 	= ' ' "
			cQuery += 		"UNION ALL "
			cQuery += 		"SELECT 'RHP' 	AS SOURCETABLE, "
			cQuery += 			"RHP_MAT    AS MAT, "
			cQuery += 			"RHP_DTOCOR AS DT_OCOR, "
			cQuery += 			"RHP_TPFORN AS TPFORN, "
			cQuery += 			"RHP_CODFOR AS CODFOR, "
			cQuery += 			"RHP_CODIGO AS CODIGO, "
			cQuery += 			"RHP_PD 	AS PD, "
			cQuery += 			"RHP_COMPPG AS COMPPG, "
			cQuery += 			"RHP_FILIAL AS FILIAL, "
			cQuery += 			"RHP_ORIGEM AS ORIGEM, "
			cQuery += 			"RHP_VLRFUN	AS VLRFUN, "
			cQuery += 			"RHP_CDESPE AS CDESPE, "
			cQuery += 			"RHP_CID 	AS CID, "
			cQuery += 			"RHP_TPATEN AS TPATEN "
			cQuery += 		"FROM " + RetSqlName("RHP") + " RHP "
			cQuery += 		"WHERE "
			cQuery += 			"RHP_FILIAL 			= '" + xFilial("RHP", cBranchId) + "' "
			cQuery += 			"AND RHP_TPLAN 			= '1' "
			cQuery += 			"AND RHP_COMPPG 		= '" + cPeriodo + "' "
			cQuery += 			"AND RHP.D_E_L_E_T_ 	= ' ' "

			IF cDataBase == "POSTGRES"
				cQuery += 		"AND (RHP_FILIAL || RHP_MAT || RHP_DTOCOR || RHP_TPFORN || RHP_CODFOR || RHP_ORIGEM || RHP_CODIGO || RHP_PD || RHP_COMPPG) NOT IN ( "
				cQuery += 			"SELECT (RHO_FILIAL || RHO_MAT || RHO_DTOCOR || RHO_TPFORN || RHO_CODFOR || RHO_ORIGEM || RHO_CODIGO || RHO_PD || RHO_COMPPG) "
			Else
				cQuery += 		"AND (RHP_FILIAL+RHP_MAT+RHP_DTOCOR+RHP_TPFORN+RHP_CODFOR+RHP_ORIGEM+RHP_CODIGO+RHP_PD+RHP_COMPPG) NOT IN ( "
				cQuery += 			"SELECT RHO_FILIAL + RHO_MAT + RHO_DTOCOR + RHO_TPFORN + RHO_CODFOR + RHO_ORIGEM + RHO_CODIGO +RHO_PD + RHO_COMPPG "
			EndIf

			cQuery += 				"FROM " + RetSqlName("RHO") + " RHO "
			cQuery += 				"WHERE RHO_FILIAL = '" + xFilial("RHO", cBranchId) + "' AND RHO_TPLAN = '1' AND RHO.D_E_L_E_T_ 	= ' ' AND RHO_COMPPG = '" + cPeriodo + "') "
			cQuery += 	") ALLDATA "
			cQuery += ") FINAL "
			cQuery += "WHERE (FINAL.ITEMNUMBER BETWEEN " + Alltrim(Str((page - 1) * nPageSize + 1)) + " AND " + Alltrim(Str((page * nPageSize))) + ") "
		
		ELSE // RCH Data not found
			lRet 		:= .F.
			cMessage	:= STR0002 // STR0002: "Nenhum registro localizado."
			SetRestFault(ERRORCODE_DEF, EncodeUTF8(cMessage), , , , URL_DEF, )
		EndIF

		(cAliasPer)->(DbCloseArea())

	Else
		// Initial Charge - Get all information from RHO and RHP without using Date filter
		cQuery := "SELECT * FROM ( "
			
			If cDataBase == "ORACLE"
				cQuery +=  "SELECT ROWNUM ITEMNUMBER, COUNT(1) OVER() AS TOTALNUMBER,"
			Else
				cQuery += "SELECT ROW_NUMBER() OVER( ORDER BY MAT ) ITEMNUMBER, COUNT (1) OVER() TOTALNUMBER,"
			EndIf

			cQuery += 		"SOURCETABLE,FILIAL,MAT,DT_OCOR,TPFORN, CODFOR,ORIGEM,CODIGO,PD,COMPPG,VLRFUN,CDESPE,CID,TPATEN "
			cQuery += 	"FROM ( "
			cQuery += 		"SELECT " 
			cQuery += 			"'RHO' 		AS SOURCETABLE, "
			cQuery += 			"RHO_MAT 	AS MAT, "
			cQuery += 			"RHO_DTOCOR AS DT_OCOR, "
			cQuery += 			"RHO_TPFORN AS TPFORN, "
			cQuery += 			"RHO_CODFOR AS CODFOR, "
			cQuery += 			"RHO_CODIGO AS CODIGO, "
			cQuery += 			"RHO_PD 	AS PD, "
			cQuery += 			"RHO_COMPPG AS COMPPG, "
			cQuery += 			"RHO_FILIAL AS FILIAL, "
			cQuery += 			"RHO_ORIGEM AS ORIGEM, "
			cQuery += 			"RHO_VLRFUN	AS VLRFUN, "
			cQuery += 			"RHO_CDESPE	AS CDESPE, "
			cQuery += 			"RHO_CID 	AS CID, "
			cQuery += 			"RHO_TPATEN	AS TPATEN "
			cQuery += 		"FROM " + RetSqlName("RHO") + " RHO "
			cQuery += 		"WHERE "
			cQuery += 			"RHO_FILIAL 	= '" + xFilial("RHO", cBranchId) + "' "
			cQuery += 			"AND RHO_TPLAN 	= '1' "
			cQuery += 			"AND RHO.D_E_L_E_T_ 	= ' ' "
			cQuery += 		"UNION ALL "
			cQuery += 		"SELECT 'RHP' 	AS SOURCETABLE, "
			cQuery += 			"RHP_MAT    AS MAT, "
			cQuery += 			"RHP_DTOCOR AS DT_OCOR, "
			cQuery += 			"RHP_TPFORN AS TPFORN, "
			cQuery += 			"RHP_CODFOR AS CODFOR, "
			cQuery += 			"RHP_CODIGO AS CODIGO, "
			cQuery += 			"RHP_PD 	AS PD, "
			cQuery += 			"RHP_COMPPG AS COMPPG, "
			cQuery += 			"RHP_FILIAL AS FILIAL, "
			cQuery += 			"RHP_ORIGEM AS ORIGEM, "
			cQuery += 			"RHP_VLRFUN	AS VLRFUN, "
			cQuery += 			"RHP_CDESPE AS CDESPE, "
			cQuery += 			"RHP_CID 	AS CID, "
			cQuery += 			"RHP_TPATEN AS TPATEN "
			cQuery += 		"FROM " + RetSqlName("RHP") + " RHP "
			cQuery += 		"WHERE "
			cQuery += 			"RHP_FILIAL 			= '" + xFilial("RHP", cBranchId) + "' "
			cQuery += 			"AND RHP_TPLAN 			= '1' "
			cQuery += 			"AND RHP.D_E_L_E_T_ 	= ' ' "

			IF cDataBase == "POSTGRES"
				cQuery += 		"AND (RHP_FILIAL || RHP_MAT || RHP_DTOCOR || RHP_TPFORN || RHP_CODFOR || RHP_ORIGEM || RHP_CODIGO || RHP_PD || RHP_COMPPG) NOT IN ( "
				cQuery += 			"SELECT (RHO_FILIAL || RHO_MAT || RHO_DTOCOR || RHO_TPFORN || RHO_CODFOR || RHO_ORIGEM || RHO_CODIGO || RHO_PD || RHO_COMPPG) "
			Else
				cQuery += 		"AND (RHP_FILIAL+RHP_MAT+RHP_DTOCOR+RHP_TPFORN+RHP_CODFOR+RHP_ORIGEM+RHP_CODIGO+RHP_PD+RHP_COMPPG) NOT IN ( "
				cQuery += 			"SELECT RHO_FILIAL + RHO_MAT + RHO_DTOCOR + RHO_TPFORN + RHO_CODFOR + RHO_ORIGEM + RHO_CODIGO +RHO_PD + RHO_COMPPG "
			EndIf

			cQuery += 				"FROM " + RetSqlName("RHO") + " RHO "
			cQuery += 				"WHERE RHO_FILIAL = '" + xFilial("RHO", cBranchId) + "' AND RHO_TPLAN = '1' AND RHO.D_E_L_E_T_ 	= ' ') "
			cQuery += 	") ALLDATA "
			cQuery += ") FINAL "
			cQuery += "WHERE (FINAL.ITEMNUMBER BETWEEN " + Alltrim(Str((page - 1) * nPageSize + 1)) + " AND " + Alltrim(Str((page * nPageSize))) + ") "
	EndIf

	If lRet
		// Execute Query
		DBUseArea( .T., "TOPCONN", TcGenQry( , ,cQuery), cAlias, .T., .T. )

		// Reset Catch
		fResetErrorHandler()

		// Check Query
		IF !fPosValid(@oEmpData, page, (cAlias)->ITEMNUMBER, (cAlias)->TOTALNUMBER)
			lRet := .F.
		Endif

		oHeadData["total"]  := (cAlias)->TOTALNUMBER

		// Get items Properties
		While (cAlias)->(!Eof())

			// Set hasNext propertie
			IF ((cAlias)->TOTALNUMBER == (cAlias)->ITEMNUMBER) .OR. (nPageSize >= (cAlias)->TOTALNUMBER)
				oHeadData["hasNext"] := .F.
			EndIf

			oItemData := JsonObject():new()

			cCurenReg := SM0->M0_CODIGO   + "|" + (cAlias)->FILIAL + "|" + (cAlias)->MAT + "|" + formatDate((cAlias)->DT_OCOR) + "|"
			cCurenReg += (cAlias)->TPFORN + "|" + (cAlias)->CODFOR + "|" + (cAlias)->ORIGEM + "|" + (cAlias)->CODIGO + "|" + (cAlias)->PD + "|" + (cAlias)->COMPPG

			If !Empty(cDateMod) .OR. (cAlias)->SOURCETABLE == "RHO"
				oItemData["id"]                             := cCurenReg 																// "Chave única que identifica os registros dos lançamentos de coparticipações. Referente ao índice 4(RHOT10_UNQ) da tabela RHO.
				oItemData["companyKey"]      				:= SM0->M0_CODIGO + "|" + (cAlias)->FILIAL 									// "Agrupamento de Empresa, Unidade de negócio e Filial" - SM0->M0_CODIGO
				oItemData["branch"]          	            := (cAlias)->FILIAL	                            							// "Filial referente a coparticipação lançada."
				oItemData["employeeCode"]                   := (cAlias)->MAT		 	                                    			// "Matrícula do Beneficiário dentro do Produto TOTVS."
				oItemData["employeeName"]                  	:= POSICIONE( "SRA", 1, xFilial("SRA", (cAlias)->FILIAL)+(cAlias)->MAT, "SRA->RA_NOME" ) //"Nome do Beneficiário do Funcionário dentro do Produto TOTVS."
				oItemData["dependentCode"]                  := If(Empty((cAlias)->CODIGO), "00", (cAlias)->CODIGO)  					// "Matrícula do Dependente do Beneficiário dentro do Produto TOTVS."
				oItemData["dependentName"]              	:= If(((cAlias)->ORIGEM) == "2", RTrim(LTrim(POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL) + (cAlias)->MAT + (cAlias)->CODIGO, "SRB->RB_NOME"))), POSICIONE( "SRA", 1, xFilial("SRA", (cAlias)->FILIAL)+(cAlias)->MAT, "SRA->RA_NOME" )) // "Nome do Dependente do Beneficiário dentro do Produto TOTVS."
				oItemData["degreeEmployeeDependency"]       := If(((cAlias)->ORIGEM) == "2", POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL) + (cAlias)->MAT + (cAlias)->CODIGO, "SRB->RB_GRAUPAR"), "") //"Grau de dependência do Funcionário no Datasul."			
				oItemData["occurrencyDate"]                 := formatDate((cAlias)->DT_OCOR)											// "Data de ocorrência do lançamento da coparticipação para o beneficiário."
				oItemData["serviceProvider"]                := (cAlias)->CODFOR		 	                                    			// "Identificador do Prestador de Serviço."
				oItemData["serviceProviderContractType"]    := (cAlias)->TPFORN		 	                                    			// "Tipo de Contrato do Prestador de Serviço indicado no lançamento da Coparticipação do Beneficiário: 1 - Assistência Médica | 2 - Assistência Odontológica | 3 - VR | 4 - VA | 5 - VT | 9 - Outros"
				oItemData["coparticipationValue"]           := Alltrim(Transform((cAlias)->VLRFUN,"@R 99999999999.99"))        			// "Valor referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
				oItemData["yearMonthReference"]             := (cAlias)->COMPPG		 	                                    			// "Ano e mês de referência do lançamento da coparticipação do beneficiário no Produto TOTVS."
				oItemData["specialtyName"]                  := ALLTRIM((cAlias)->CDESPE)	                                   			// "Nome da especialidade do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
				oItemData["internationalCodeDiseases"]      := (cAlias)->CID		 	                                    			// "Código internacional de Doenças lançado da coparticipação do beneficiário no Produto TOTVS."
				oItemData["serviceType"]                    := ALLTRIM((cAlias)->TPATEN)                                    			// "Tipo de Atendimento informado pelo Prestador de Serviço no lançamento da Coparticipação do Beneficiário: 1 - Eletivo | 2 - PS | 3 - Exame | 4 - PAC | 5 - Material/Medicamento | 6 - Internação | 7 - Terapia | 8 - Taxa/Diária| 9 - Case | 10 - Reembolso | 11 - Remoção | 12 - Não Informado | 13 - Ambulatório"
				oItemData["coparticipationDescription"]     := ""		 	                                                        	// "Descrição da Coparticipação referente ao lançamento no histórico do beneficiário no Produto TOTVS."
				oItemData["amountUse"]  					:= "1"	 																	// "Quantidade de utilização de coparticipação por parte do beneficiário e seus dependentes dentro do Produto TOTVS."

				// "Número do Contrato do Prestador de Serviço indicado no lançamento da Coparticipação do Beneficiário."
				nPosTab := fPosTab( "S074",(cAlias)->CODFOR,"=",7,(cAlias)->TPFORN,"=",6,,,,.T., (cAlias)->FILIAL,,,,,,,.T.,.T.)
				oItemData["serviceProviderContract"] := fTabela("S074",nPosTab,4)

				// Plano de Saúde
				IF (cAlias)->TPFORN == "1"
					nPosTab := fPosTab( "S016",(cAlias)->CODFOR, "=", 4,,,,,,,.T., (cAlias)->FILIAL,,,,,,,.T.,.T.)
					oItemData["serviceProviderId"]    := fTabela("S016",nPosTab,6)			// "CNPJ do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
					oItemData["serviceProviderName"]  := ALLTRIM(fTabela("S016",nPosTab,5))	// "Nome do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."

				// Plano odontológico
				ELSE
					nPosTab := fPosTab( "S017",(cAlias)->CODFOR, "=", 4,,,,,,,.T., (cAlias)->FILIAL,,,,,,,.T.,.T.)
					oItemData["serviceProviderId"]    := fTabela("S017",nPosTab,6)			// "CNPJ do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
					oItemData["serviceProviderName"]  := ALLTRIM(fTabela("S017",nPosTab,5))	// "Nome do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
				EndIf

			Else
				// "Chave única que identifica os registros dos lançamentos de histórico de coparticipações. Referente ao índice 3(RHPT10_UNQ) da tabela RHP.
				oItemData["id"]                             := cCurenReg
				oItemData["companyKey"]      				:= SM0->M0_CODIGO + "|" + (cAlias)->FILIAL 							// "Agrupamento de Empresa, Unidade de negócio e Filial" - SM0->M0_CODIGO
				oItemData["branch"]          	            := (cAlias)->FILIAL	                            					// "Filial referente a coparticipação lançada."
				oItemData["employeeCode"]                   := (cAlias)->MAT		 	                                    	// "Matrícula do Beneficiário dentro do Produto TOTVS."
				oItemData["employeeName"]                  	:= POSICIONE( "SRA", 1, xFilial("SRA", (cAlias)->FILIAL)+(cAlias)->MAT, "SRA->RA_NOME" ) // "Nome do Beneficiário do Funcionário dentro do Produto TOTVS."
				oItemData["dependentCode"]                  := If(Empty((cAlias)->CODIGO), "00", (cAlias)->CODIGO)  			// "Matrícula do Dependente do Beneficiário dentro do Produto TOTVS."
				oItemData["dependentName"]              	:= If(((cAlias)->ORIGEM) == "2", RTrim(LTrim(POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL) + (cAlias)->MAT + (cAlias)->CODIGO, "SRB->RB_NOME"))), POSICIONE( "SRA", 1, xFilial("SRA", (cAlias)->FILIAL)+(cAlias)->MAT, "SRA->RA_NOME" )) // "Nome do Dependente do Beneficiário dentro do Produto TOTVS."
				oItemData["degreeEmployeeDependency"]       := If(((cAlias)->ORIGEM) == "2", POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL) + (cAlias)->MAT + (cAlias)->CODIGO, "SRB->RB_GRAUPAR"), "") //"Grau de dependência do Funcionário no Datasul."			
				oItemData["occurrencyDate"]                 := formatDate((cAlias)->DT_OCOR)									// "Data de ocorrência do lançamento da coparticipação para o beneficiário."
				oItemData["serviceProvider"]                := (cAlias)->CODFOR		 	                                    	// "Identificador do Prestador de Serviço."
				oItemData["serviceProviderContractType"]    := (cAlias)->TPFORN		 	                                    	// "Tipo de Contrato do Prestador de Serviço indicado no lançamento da Coparticipação do Beneficiário: 1 - Assistência Médica | 2 - Assistência Odontológica | 3 - VR | 4 - VA | 5 - VT | 9 - Outros"
				oItemData["coparticipationValue"]           := Alltrim(Transform((cAlias)->VLRFUN,"@R 99999999999.99"))	       	// "Valor referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
				oItemData["yearMonthReference"]             := (cAlias)->COMPPG		 	                        				// "Ano e mês de referência do lançamento da coparticipação do beneficiário no Produto TOTVS."
				oItemData["specialtyName"]                  := ALLTRIM((cAlias)->CDESPE)                                    	// "Nome da especialidade do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
				oItemData["internationalCodeDiseases"]      := (cAlias)->CID			                                    	// "Código internacional de Doenças lançado da coparticipação do beneficiário no Produto TOTVS."
				oItemData["serviceType"]                    := ALLTRIM((cAlias)->TPATEN)                                    	// "Tipo de Atendimento informado pelo Prestador de Serviço no lançamento da Coparticipação do Beneficiário: 1 - Eletivo | 2 - PS | 3 - Exame | 4 - PAC | 5 - Material/Medicamento | 6 - Internação | 7 - Terapia | 8 - Taxa/Diária| 9 - Case | 10 - Reembolso | 11 - Remoção | 12 - Não Informado | 13 - Ambulatório"
				oItemData["coparticipationDescription"]     := ""		 	                                                    // "Descrição da Coparticipação referente ao lançamento no histórico do beneficiário no Produto TOTVS."
				oItemData["amountUse"]  					:= "1"	 															// "Quantidade de utilização de coparticipação por parte do beneficiário e seus dependentes dentro do Produto TOTVS."
				
				// "Número do Contrato do Prestador de Serviço indicado no lançamento da Coparticipação do Beneficiário."
				nPosTab := fPosTab( "S074",(cAlias)->CODFOR,"=",7,(cAlias)->TPFORN,"=",6,,,,.T., (cAlias)->FILIAL,,,,,,,.T.,.T.)
				oItemData["serviceProviderContract"]    := fTabela("S074",nPosTab,4)	

				// Plano de Saúde
				IF (cAlias)->TPFORN == "1"
					nPosTab := fPosTab( "S016",(cAlias)->CODFOR, "=", 4,,,,,,,.T., (cAlias)->FILIAL,,,,,,,.T.,.T.)
					oItemData["serviceProviderId"]    := fTabela("S016",nPosTab,6)			// "CNPJ do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
					oItemData["serviceProviderName"]  := ALLTRIM(fTabela("S016",nPosTab,5))	// "Nome do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."

				// Plano odontológico
				ELSE
					nPosTab := fPosTab( "S017",(cAlias)->CODFOR, "=", 4,,,,,,,.T., (cAlias)->FILIAL,,,,,,,.T.,.T.)
					oItemData["serviceProviderId"]    := fTabela("S017",nPosTab,6)			// "CNPJ do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
					oItemData["serviceProviderName"]  := ALLTRIM(fTabela("S017",nPosTab,5))	// "Nome do Prestador de Serviço referente ao lançamento da coparticipação do beneficiário no Produto TOTVS."
				EndIf
			EndIf

			AAdd(aItemQry, oItemData)
			(cAlias)->(DBSkip())
		EndDo
		
		oHeadData["items"]  := aItemQry
		oEmpData 			:= oHeadData

		fResetErrorHandler()
		(cAlias)->(DbCloseArea())
	EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function fPreValid
Check Pre-Validations
@author  oliveira.hugo
@since   30/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fPreValid(oObj, cBranchId, cDateMod, cCompId, cProd)
	Local lRet 	   		:= .T. 
	Local cMessage 		:= ""
	
	Local lRHOCDESPE    := If(RHO->(ColumnPos("RHO_CDESPE")) > 0, .T., .F.)
	Local lRHOCID 	    := If(RHO->(ColumnPos("RHO_CID")) > 0, .T., .F.)
	Local lRHOTPATEN 	:= If(RHO->(ColumnPos("RHO_TPATEN")) > 0, .T., .F.)
	
	Local lRHPCDESPE    := If(RHP->(ColumnPos("RHP_CDESPE")) > 0, .T., .F.)
	Local lRHPCID 	    := If(RHP->(ColumnPos("RHP_CID")) > 0, .T., .F.)
	Local lRHPTPATEN 	:= If(RHP->(ColumnPos("RHP_TPATEN")) > 0, .T., .F.)
	
	Local nSM0			As Integer
	Local aSM0			As Array

	aSM0		:= FWLoadSM0()

	// Check Fields
	If ( lRHOCDESPE == .F. .OR. lRHOCID == .F. .OR. lRHOTPATEN == .F. .OR. lRHPCDESPE == .F. .OR. lRHPCID == .F. .OR. lRHPTPATEN == .F.)
		cMessage := STR0003 // STR0003: "Os campos RHO_CDESPE, RHO_CID, RHO_TPATEN, RHP_CDESPE, RHP_CID e RHP_TPATEN são obrigatórios."
		lRet := .F.

    // Check cProd
	ElseIf Empty(cProd)
		cMessage := STR0015 // STR0015: "O parâmetro product é obrigatório."
		lRet 	 := .F.
    
	// Check cCompId
	ElseIf Empty(cCompId)
		cMessage := STR0009 // STR0009: "O parâmetro companyId é obrigatório."
		lRet 	 := .F.

	// Check cBranchId
	ElseIf Empty(cBranchId)
		cMessage := STR0010 // STR0010: "O parâmetro branchId é obrigatório."
		lRet 	 := .F.
	
	ElseIf !fValidDate(cDateMod)
		cMessage := STR0011 // STR0011: "Se preenchido, o parâmetro datemodified deve estar no formato: '2019-05-01T18:25:43'."
		lRet 	 := .F.

	// cBranchId Validation
	ElseIf (nSM0:=ascan(aSM0,{|X| Alltrim(X[1]) == cCompId .AND. Alltrim(X[2])==cBranchId })) == 0
		cMessage := STR0012 + cCompId + " " + cBranchId // STR0012: "Filial não encontrada para os valores informados de empresa e Filial: "
		lRet 	 := .F.
	EndIf

	If !lRet
		SetRestFault(ERRORCODE_DEF, EncodeUTF8(cMessage), , , , URL_DEF, )
	EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function fPosValid
Check data validation after Query
@author  oliveira.hugo
@since   30/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fPosValid(oObj, nPage, nReg, nTotalReg)
	Local lRet		:= .T.
	Local cMessage	:= ""

	DEFAULT  nPage		:= 0
	DEFAULT  nReg		:= 0
	DEFAULT  nTotalReg	:= 0

	If nReg == 0 .OR. nTotalReg == 0
		cURL		:= URL_DEF
		cMessage	:= STR0002 // STR0002: "Nenhum registro localizado."
		lRet		:= .F.
	EndIf

	If !lRet
		SetRestFault(ERRORCODE_DEF, EncodeUTF8(cMessage), , , , URL_DEF, )
	EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function fDateValid
Verify Date Input
@author  oliveira.hugo
@since   10/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fValidDate(cDate)
	Local lRet := .T.

	// Formato Considerado como válido: "2001-01-01T18:25:43"
	If !Empty(cDate)
		If  SubStr(cDate, 5,  1) != "-" .OR. SubStr(cDate, 8,  1) != "-" .OR. SubStr(cDate, 11, 1) != "T" .OR. SubStr(cDate, 14, 1) != ":" .OR. SubStr(cDate, 17, 1) != ":"
				lRet := .F.
		EndIf
	EndIf
Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function formatDate
Input Format: 20190101
Return JSON Date Format
@author  oliveira.hugo
@since   26/04/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function formatDate(cDate)
	Local cNewDate := ""
	
	DEFAULT cDate := ""

	IF !Empty(cDate)
		cNewDate := SubStr(cDate,1,4) + "-" + SubStr(cDate, 5, 2) + "-" + SubStr(cDate, 7, 2) + "T" + "00:00:00"
	EndIf

Return cNewDate


//-------------------------------------------------------------------
/*/{Protheus.doc} function fDateValid
Return Formated Date. Input Date: '1990-01-01T00:00:00'. Output Date: '19900101'
@author  oliveira.hugo
@since   30/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fDateFormat(cDate)
	Local cNewDate := ""

	cNewDate := SubStr(cDate, 1,  4) + SubStr(cDate, 6,  2) + SubStr(cDate, 9,  2)

Return cNewDate


//-------------------------------------------------------------------
/*/{Protheus.doc} function fCompress
Compress String Object
@author  oliveira.hugo
@since   30/05/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fCompress(oObj)
	Local cJson    := ""
	Local cComp    := ""
	Local lCompact := .F.
	
	// Set gzip format to Json Object
	cJson := oObj:toJSON()
	
	cJson := EncodeUTF8(cJson)

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


/*
{Protheus.doc} fSetErrorHandler
Function fSetErro
@Uso    Seta código e mensagem de erro 
@param  Objeto de erro
@return	Nenhum
@Autor  Lucas Peixoto Sepe - TOTVS
*/
Static Function fSetErrorHandler(cTitle)
	bError  := { |e| oError := e , oError:Description := cTitle + TAB + oError:Description, Break(e) }
	bErrorBlock    := ErrorBlock( bError )
Return(.T.)


/*
{Protheus.doc} fResetErrorHandler
Function fSetErro
@Uso    Seta código e mensagem de erro 
@param  Objeto de erro
@return	Nenhum
@Autor  Lucas Peixoto Sepe - TOTVS
*/
Static Function fResetErrorHandler(cTitle)
	bError  := { |e| oError := e , Break(e) }
	bErrorBlock    := ErrorBlock( bError )
Return(.T.)