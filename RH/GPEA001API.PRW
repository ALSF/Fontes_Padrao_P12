#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "GPEA001API.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWAdapterEAI.ch"

#DEFINE PAGESIZE_DEF	2000
#DEFINE ERRORCODE_DEF	400
#DEFINE ERRORSRV_DEF	500
#DEFINE TAB  			CHR ( 13 ) + CHR ( 10 )
#DEFINE URL_DEF			"http://tdn.totvs.com/x/Uzh_HQ"

// STR0001: "Serviço genérico para retorno das informações de Plano de Saúde do Microsiga Protheus."
WSRESTFUL BeneficiariesDataContent DESCRIPTION oEmToAnsi(STR0001) FORMAT "application/json"
	WSDATA authorization As String
	WSDATA companyId	 As String
	WSDATA branchId	     As String
	WSDATA product	     As String
	WSDATA page			 As Integer Optional
	WSDATA pageSize		 As Integer Optional
	WSDATA datemodified	 As String  Optional

	// STR0005: "Exemplo de retorno de Plano de Saúde - Titular/Dependentes."
	WSMETHOD GET DESCRIPTION oEmToAnsi(STR0005) PRODUCES APPLICATION_JSON WSSYNTAX "rh/v1/BeneficiariesDataContent/" PATH "rh/v1/BeneficiariesDataContent/" TTALK "v1"
END WSRESTFUL


WSMETHOD GET QUERYPARAM companyId, branchId, page, pageSize, datemodified, product HEADERPARAM authorization WSSERVICE BeneficiariesDataContent
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
		nPage 	   	:= Self:page
		nPageSize  	:= Self:pageSize
		cDateMod   	:= Self:datemodified
		cCompId    	:= Self:companyId
		cBranchId  	:= Self:branchId
		cProd		:= Self:product

		// Verify PreValidations
		IF !fPreValid(@oEmpData, cBranchId, cDateMod, cCompId, cProd)
			lRet := .F.
		Endif

		If lRet
			fSetErrorHandler(EncodeUTF8(STR0006)) // STR0006: "Erro ao preparar o ambiente com a Empresa e Filial informados!"
			
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
				
				// STR0007: "De-Para de Empresa e Filial não encontrado na base para companyId." STR0008: "e BranchId"
				SetRestFault(ERRORCODE_DEF, EncodeUTF8(STR0007) + " '" + cCompId + "' "+ EncodeUTF8(STR0008) + " '" + cBranchId + "' !", , , , URL_DEF, )
				lRet := .F.
			EndIf
		
			If lRet
				RESET ENVIRONMENT
				RPCSetType(3)
				PREPARE ENVIRONMENT EMPRESA aEmpre[1][2] FILIAL aEmpre[2][2] TABLES "RHK", "RHL" MODULO "GPE"
				fResetErrorHandler()

				// Get RHK Data
				lRet := fGetData(@oEmpData, nPage, nPageSize, cDateMod, cBranchId)
			EndIf

		EndIf

		// Compress String And Set Response
		cResponse := fCompress(@oEmpData)
		::SetResponse(EncodeUTF8(cResponse))

	RECOVER
		lRet := .F.
		ErrorBlock(bErrorBlock)
		SetRestFault(ERRORSRV_DEF, EncodeUTF8(STR0009) + TAB + oError:Description, , , , URL_DEF, ) // STR0009: "Ocorreu uma falha no retorno da informação."

	END SEQUENCE

Return lRet


// Get Requested Data
Static Function fGetData(oEmpData, page, nPageSize, cDateMod, cBranchId)
	Local oItemData
	Local nPosTab		:= 0
	Local cQuery  		:= ""
	Local lRet 			:= .T.
	Local aItemQry 		:= {}
	Local cAlias 		:= GetNextAlias() 
	Local oHeadData		:= JsonObject():new()
	Local cDataBase 	:= AllTrim( Upper( TcGetDb() ) )

	DEFAULT oEmpData := JsonObject():New()

	oHeadData["hasNext"] := .T.

	fSetErrorHandler(EncodeUTF8(STR0017)) // STR0017: "Falha ao buscar dados do cliente!"

	// Verifiy opened conections
	If Select ("RHK") > 0
		RHK->( dbCloseArea() )
	Endif
	
	If Select ("RHL") > 0
		RHL->( dbCloseArea() )
	Endif

	// Create Paging Control
	cQuery := "SELECT * FROM ( "

	If cDataBase == "ORACLE"
		cQuery +=  "SELECT ROWNUM ITEMNUMBER, COUNT(1) OVER() AS TOTALNUMBER,"
		cQuery +=  "SOURCETABLE,FILIAL,MAT,MATSAU,MATODO,CNS,CODFOR,TPFORN,PLANO,PERINI,PERFIM,TPPLAN,CODIGO "
	Else
		cQuery += "SELECT ROW_NUMBER() OVER(ORDER BY MAT) ITEMNUMBER, COUNT (1) OVER() TOTALNUMBER,"
		cQuery += "SOURCETABLE,FILIAL,MAT,MATSAU,MATODO,CNS,CODFOR,TPFORN,PLANO,PERINI,PERFIM,TPPLAN,CODIGO "
	EndIf

	// Begin Get RHK Data
	If !Empty(cDateMod)
		cQuery += "FROM ( "
		cQuery += "SELECT "
		cQuery += "'RHK' AS SOURCETABLE,RHK_FILIAL AS FILIAL,RHK_MAT AS MAT,RHK_MATSAU AS MATSAU, RHK_MATODO AS MATODO,RHK_CNS AS CNS,RHK_CODFOR AS CODFOR,RHK_TPFORN AS TPFORN,"
		cQuery += "RHK_PLANO AS PLANO,RHK_PERINI AS PERINI,RHK_PERFIM AS PERFIM,RHK_TPPLAN AS TPPLAN, 'CODIGO' AS CODIGO "
		cQuery += "FROM RHKT10 RHK "
		cQuery += "WHERE RHK.RHK_FILIAL = '" + cBranchId + "' "
		cQuery += "AND RHK.D_E_L_E_T_ = ' ' "
		cQuery += "AND RHK_USERGA != ' ' "

		// Set cDateMod
		cDateMod := fClearDate(cDateMod)

		// Check Database (RHK)
		If cDataBase == "ORACLE"
			cQuery += "AND REPLACE(TO_DATE('19960101','YYYYMMDD') + "
			cQuery += "TO_NUMBER(CONCAT(TO_CHAR(ASCII(SUBSTR(RTRIM(RHK_USERGA),12,1))-50), TO_CHAR(ASCII(SUBSTR(RTRIM(RHK_USERGA),16,1))-50))) ,'/','') >= '" + cDateMod + "' "

		ElseIF cDataBase == "POSTGRES"
			cQuery += "AND (REPLACE(CAST(to_date('19960101','YYYYMMDD') + " 
			cQuery += "CAST(CONCAT(REPLACE(CAST((ASCII(SUBSTR(RHK_USERGA,12,1))-50) AS VARCHAR),' ',''),"
			cQuery += "REPLACE(CAST((ASCII(SUBSTR(RHK_USERGA,16,1))-50) AS VARCHAR),' ','')) AS INT ) AS VARCHAR ),'-','')) >= '" + cDateMod + "' "
		
		ElseIF cDataBase == "DB2"
			cQuery += "AND REPLACE(CONVERT(VARCHAR, DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "

		ElseIF cDataBase == "INFORMIX"
			cQuery += "AND REPLACE(CONVERT(VARCHAR, DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "

		ElseIF cDataBase == "MYSQL"
			cQuery += "AND REPLACE(CONVERT(VARCHAR, DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "

		Else 
			// SQL Server ("MSSQL|MSSQL7")
			cQuery += "AND REPLACE(CONVERT(VARCHAR, DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RTRIM(RHK_USERGA),16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "
		Endif

		cQuery += "UNION ALL "
		cQuery += "SELECT "
		cQuery += "'RHL'AS SOURCETABLE,RHL_FILIAL AS FILIAL,RHL_MAT AS MAT,RHL_MATSAU AS MATSAU,RHL_MATODO AS MATODO,RHL_CNS AS CNS,RHL_CODFOR AS CODFOR,RHL_TPFORN AS TPFORN,"
		cQuery += "RHL_PLANO AS PLANO,RHL_PERINI AS PERINI,RHL_PERFIM AS PERFIM,RHL_TPPLAN AS TPPLAN, RHL_CODIGO AS CODIGO "
		cQuery += "FROM RHLT10 RHL "
		cQuery += "WHERE RHL_FILIAL = '" + cBranchId + "' "
		cQuery += "AND RHL.D_E_L_E_T_ = ' ' "
		cQuery += "AND RHL_USERGA != ' ' "

		// Check Database (RHL)
		If cDataBase == "ORACLE"
			cQuery += "AND REPLACE(TO_DATE('19960101','YYYYMMDD') + TO_NUMBER(CONCAT(TO_CHAR(ASCII(SUBSTR(RHL_USERGA,12,1))-50), TO_CHAR(ASCII(SUBSTR(RHL_USERGA,16,1))-50))) ,'/','') >= '" + cDateMod + "' "

		ElseIF cDataBase == "POSTGRES"
			cQuery += "AND (REPLACE(CAST(to_date('19960101','YYYYMMDD') + CAST(CONCAT(REPLACE(CAST((ASCII(SUBSTR(RHL_USERGA,12,1))-50) AS VARCHAR),' ',''), "
			cQuery += "REPLACE(CAST((ASCII(SUBSTR(RHL_USERGA,16,1))-50) AS VARCHAR),' ','')) AS INT ) AS VARCHAR ),'-','')) >= '" + cDateMod + "' "
	
		ElseIF cDataBase == "DB2"
			cQuery += "AND REPLACE(CONVERT(VARCHAR,DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "

		ElseIF cDataBase == "INFORMIX" 
			cQuery += "AND REPLACE(CONVERT(VARCHAR,DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "

		ElseIF cDataBase == "MYSQL"
			cQuery += "AND REPLACE(CONVERT(VARCHAR,DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "

		Else // SQL Server ("MSSQL|MSSQL7")
			cQuery += "AND REPLACE(CONVERT(VARCHAR,DATEADD(DAY,CONVERT(NUMERIC,CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,12,1))-50) + "
			cQuery += "CONVERT(VARCHAR,ASCII(SUBSTRING(RHL_USERGA,16,1))-50)),'19960101'), 102),'.','') >= '" + cDateMod + "' "
		EndIf

		cQuery += "AND RHL_USERGA != ' ' "
		cQuery += ") HIST ) QRY "
		cQuery += "WHERE (QRY.ITEMNUMBER BETWEEN " + Alltrim(Str((page - 1) * nPageSize + 1)) + " AND " + Alltrim(Str((page * nPageSize))) + ") "
	Else 
		// Initial Charge - Get All data from union tables
		cQuery += "FROM ( "
		cQuery += "SELECT "
		cQuery += "'RHK' AS SOURCETABLE,RHK_FILIAL AS FILIAL,RHK_MAT AS MAT,RHK_MATSAU AS MATSAU, RHK_MATODO AS MATODO,RHK_CNS AS CNS,RHK_CODFOR AS CODFOR,RHK_TPFORN AS TPFORN,"
		cQuery += "RHK_PLANO AS PLANO,RHK_PERINI AS PERINI,RHK_PERFIM AS PERFIM,RHK_TPPLAN AS TPPLAN, 'CODIGO' AS CODIGO "
		cQuery += "FROM RHKT10 RHK "
		cQuery += "WHERE RHK.D_E_L_E_T_ = ' ' "
		cQuery += "UNION ALL "
		cQuery += "SELECT "
		cQuery += "'RHL'AS SOURCETABLE,RHL_FILIAL AS FILIAL,RHL_MAT AS MAT,RHL_MATSAU AS MATSAU,RHL_MATODO AS MATODO,RHL_CNS AS CNS,RHL_CODFOR AS CODFOR,RHL_TPFORN AS TPFORN,"
		cQuery += "RHL_PLANO AS PLANO,RHL_PERINI AS PERINI,RHL_PERFIM AS PERFIM,RHL_TPPLAN AS TPPLAN, RHL_CODIGO AS CODIGO "
		cQuery += "FROM RHLT10 RHL "
		cQuery += "WHERE RHL.D_E_L_E_T_ = ' ' "
		cQuery += ") HIST "
		cQuery += ") QRY "
		cQuery += "WHERE (QRY.ITEMNUMBER BETWEEN " + Alltrim(Str((page - 1) * nPageSize + 1)) + " AND " + Alltrim(Str((page * nPageSize))) + ") "
	EndIf

	// Execute Query
	DBUseArea( .T., "TOPCONN", TcGenQry( , ,cQuery), cAlias, .T., .T. )
	
	fResetErrorHandler()

	// Check RHK Query
	IF !fPosValid(@oEmpData, page, (cAlias)->ITEMNUMBER, (cAlias)->TOTALNUMBER)
		lRet := .F.
	Endif

	If lRet
		// Create items Array
		oHeadData["total"] := (cAlias)->TOTALNUMBER

		// Get items Properties - "Plano de Saúde - Titular"
		While (cAlias)->(!Eof())
			
			// Set hasNext propertie
			IF ((cAlias)->TOTALNUMBER == (cAlias)->ITEMNUMBER) .OR. (nPageSize >= (cAlias)->TOTALNUMBER)
				oHeadData["hasNext"] := .F.
			EndIf

			oItemData := JsonObject():new()
			
			If (cAlias)->SOURCETABLE == "RHK"

				//  Get RHK item
				oItemData["companyKey"]      				:= SM0->M0_CODIGO + "|" + (cAlias)->FILIAL 	// "Agrupamento de Empresa, Unidade de negócio e Filial"
				oItemData["branch"]          				:= xFilial("RHK", (cAlias)->FILIAL)		 	// "Filial"
				oItemData["code"]            				:= "00"								 		// "Código do Beneficiário"
				
				// "Chave única do Beneficiário, concatenação dos campos existente no índice 3(RHKT10_UNQ)"
				oItemData["id"]            					:= SM0->M0_CODIGO + "|" + xFilial("RHK", (cAlias)->FILIAL) + "|" +	(cAlias)->MAT + "|" + (cAlias)->TPFORN + "|" + (cAlias)->CODFOR + "|" + (cAlias)->TPPLAN + "|" + (cAlias)->PLANO + "|" + (cAlias)->PERINI
				
				oItemData["benefitsVendorCode"]				:= 	(cAlias)->CODFOR			 			// "Identificador do Fornecedor de Benefícios"
				oItemData["benefitVendorInternalId"]		:= 	""			 							// "Identificador Interno do Fornecedor de Benefícios"
				oItemData["benefitVendorSegmentCode"]		:= 	(cAlias)->TPFORN			 			// "Código do tipo de segmento do fornecedor do Benefício: 1 - Assistência Médica | 2 - Assistência Odontológica"
				oItemData["benefitCode"]					:= 	(cAlias)->PLANO			 				// "Código do Benefício"
				oItemData["benefitInternalId"]				:= 	""			 							// "Identificador Interno do Benefício"
				oItemData["beginDate"]						:= 	fNewDate("beginDate",(cAlias)->PERINI)	// "Início da vigência do Benefício ao beneficiário"
				oItemData["finalDate"]						:= 	fNewDate("FinalDate",(cAlias)->PERINI)	// "Fim da vigência do Benefício ao beneficiário"

				nPosTab := fPosTab( "S074",(cAlias)->CODFOR,"=",7,(cAlias)->TPFORN,"=",6,,,,.T., xFilial("RHK", (cAlias)->FILIAL),,,,,,,.T.,.T.)
				oItemData["contractNumberCode"]				:= 	fTabela("S074",nPosTab,4)				// "Código do Contrato"

				oItemData["contractNumberInternalId"]		:= 	""			 							// "Identificador interno do Contrato"
				oItemData["employeeCode"]					:= 	(cAlias)->MAT					 		// "Identificado do Funcionário"
				oItemData["employeeInternalId"]				:= 	""			 							// "Identificado interno do Funcionário"
				oItemData["registryType"]					:= 	""			 							// "Tipo do Registro do Beneficiário"
				oItemData["degreeOfRelatedness"]			:= 	"T"			 							// "Grau de parentesco do dependente com o Titular: T - Titular, C - Casado, D - desquitado, E - União Estável, I - Divorciado, O - Outros, P - Separado, S - Solteiro, V - Viúvo"
				oItemData["name"]							:= 	RTrim(POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_NOME"))			// "Nome do Beneficiário"
				oItemData["benefitCPF"]						:= 	POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_CIC")					// "CPF do Beneficiário"
				oItemData["motherName"]						:= 	RTrim(LTrim(POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_MAE" ))) 	// "Nome da Mãe do beneficiário titular"
				oItemData["gender"]							:= 	POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_SEXO") 					// "Sexo do beneficiário: M - Masculino, F - Feminino"
				oItemData["maritalState"]					:= 	POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_ESTCIVI")				// "Estado Civil C - Casado | D - Desquitado | E - União Estável | I - Divorciado | O - Outros | P - Separado | S - Solteiro | V - Viúvo"
				oItemData["birth"]							:= 	POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_NASC") 					// "Data de aniversário do beneficiário"
				oItemData["identityNumber"]					:= 	ALLTRIM(POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_RG")) 			// "Identidade da pessoa (RG)"
				oItemData["identityNumberEmitterAgency"]	:= 	ALLTRIM(POSICIONE("SRA",1,xFilial("SRA",(cAlias)->FILIAL)+(cAlias)->MAT,"RA_RGEXP")) 		// "Orgão emissor da identidade da pessoa (RG)"
				oItemData["medicalAssistanceCard"]			:= 	(cAlias)->MATSAU 						// "Número do Cartão de Assistência Médica"
				oItemData["dentalAssistanceCardCode"]		:= 	(cAlias)->MATODO						// "Número do Cartão de Assistência Odontológica"
				oItemData["foodCardsCode"]					:= 	""										// "Número do Cartão para Alimentação"
				oItemData["mealCardsCode"]					:= 	""										// "Número do Cartão para Refeição"
				oItemData["SUSCardCode"]					:= (cAlias)->CNS							// "Número do Cartão do SUS"
				oItemData["bornAlive"]						:= 	"1"										// "Flag que determina se o beneficiário foi nascido vivo: 1 - Nascido Vivo , 0 - Não Nascido Vivo"
				oItemData["beneficiaryWeight"]				:= 	""										// "Peso em (gr) do Beneficiário"
				oItemData["beneficiaryTall"]				:= 	""										// "Altura em (cm) do beneficiário"
			
			Else
				//  Get RHL item
				oItemData["companyKey"]      				:= SM0->M0_CODIGO + "|" + (cAlias)->FILIAL 	// "Agrupamento de Empresa, Unidade de negócio e Filial"		
				oItemData["branch"]          				:= xFilial("RHL", (cAlias)->FILIAL)		 	// "Filial"
				oItemData["code"]            				:= (cAlias)->CODIGO							// "Código do Beneficiário"
				
				// "Chave única do Beneficiário, concatenação dos campos existente no índice 4(RHLT10_UNQ)"
				oItemData["id"]            					:= SM0->M0_CODIGO + "|" + xFilial("RHL", (cAlias)->FILIAL) + "|" +	(cAlias)->MAT + "|" + (cAlias)->CODIGO + "|" + (cAlias)->TPFORN + "|" + (cAlias)->CODFOR + "|" + (cAlias)->TPPLAN + "|" + (cAlias)->PLANO
				
				oItemData["benefitsVendorCode"]				:= (cAlias)->CODFOR			 				// "Identificador do Fornecedor de Benefícios"
				oItemData["benefitVendorInternalId"]		:= ""			 							// "Identificador Interno do Fornecedor de Benefícios"
				oItemData["benefitVendorSegmentCode"]		:= (cAlias)->TPFORN			 				// "Código do tipo de segmento do fornecedor do Benefício: 1 - Assistência Médica | 2 - Assistência Odontológica"
				oItemData["benefitCode"]					:= (cAlias)->PLANO			 				// "Código do Benefício"
				oItemData["benefitInternalId"]				:= ""			 							// "Identificador Interno do Benefício"
				oItemData["beginDate"]						:= fNewDate("beginDate",(cAlias)->PERINI)	// "Início da vigência do Benefício ao beneficiário"
				oItemData["finalDate"]						:= fNewDate("FinalDate",(cAlias)->PERFIM)	// "Fim da vigência do Benefício ao beneficiário"

				nPosTab := fPosTab( "S074",(cAlias)->CODFOR,"=",7,(cAlias)->TPFORN,"=",6,,,,.T., xFilial("RHL", (cAlias)->FILIAL),,,,,,,.T.,.T.)
				oItemData["contractNumberCode"]				:= 	fTabela("S074",nPosTab,4)				// "Código do Contrato"

				oItemData["contractNumberInternalId"]		:= 	""			 							// "Identificador interno do Contrato"
				oItemData["employeeCode"]					:= 	(cAlias)->MAT					 		// "Identificado do Funcionário"
				oItemData["employeeInternalId"]				:= 	""			 							// "Identificado interno do Funcionário"
				oItemData["registryType"]					:= 	""			 							// "Tipo do Registro do Beneficiário"
				oItemData["degreeOfRelatedness"]			:= 	POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL)+(cAlias)->MAT + (cAlias)->CODIGO, "RB_GRAUPAR" )				// "Grau de parentesco do dependente com o Titular: T - Titular, C - Casado, D - desquitado, E - União Estável, I - Divorciado, O - Outros, P - Separado, S - Solteiro, V - Viúvo"
				oItemData["name"]							:= 	RTrim(LTrim(POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL)+(cAlias)->MAT + (cAlias)->CODIGO, "RB_NOME" )))	// "Tipo do Registro do Beneficiário"
				oItemData["benefitCPF"]						:= 	POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL)+(cAlias)->MAT + (cAlias)->CODIGO, "RB_CIC" )					// "CPF do Beneficiário"
				oItemData["motherName"]						:= 	"" 										// "Nome da Mãe do beneficiário titular"
				oItemData["gender"]							:= 	POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL)+(cAlias)->MAT + (cAlias)->CODIGO, "RB_SEXO") 					// "Sexo do beneficiário: M - Masculino, F - Feminino"
				oItemData["maritalState"]					:= 	"" 										// "Estado Civil C - Casado | D - Desquitado | E - União Estável | I - Divorciado | O - Outros | P - Separado | S - Solteiro | V - Viúvo"
				oItemData["birth"]							:= 	POSICIONE("SRB", 1, xFilial("SRB", (cAlias)->FILIAL)+(cAlias)->MAT + (cAlias)->CODIGO, "RB_DTNASC") 				// "Data de aniversário do beneficiário"
				oItemData["identityNumber"]					:= 	""										// "Identidade da pessoa (RG)"
				oItemData["identityNumberEmitterAgency"]	:= 	"" 										// "Orgão emissor da identidade da pessoa (RG)"
				oItemData["medicalAssistanceCard"]			:= 	(cAlias)->MATSAU		 				// "Número do Cartão de Assistência Médica"
				oItemData["dentalAssistanceCardCode"]		:= 	(cAlias)->MATODO		 				// "Número do Cartão de Assistência Odontológica"
				oItemData["foodCardsCode"]					:= 	""										// "Número do Cartão para Alimentação"
				oItemData["mealCardsCode"]					:= 	""										// "Número do Cartão para Refeição"
				oItemData["SUSCardCode"]					:= 	(cAlias)->CNS							// "Número do Cartão do SUS"
				oItemData["bornAlive"]						:= 	"1"										// "Flag que determina se o beneficiário foi nascido vivo: 1 - Nascido Vivo , 0 - Não Nascido Vivo"
				oItemData["beneficiaryWeight"]				:= 	""										// "Peso em (gr) do Beneficiário"
				oItemData["beneficiaryTall"]				:= 	""										// "Altura em (cm) do beneficiário"
			EndIf
			
			AAdd(aItemQry, oItemData)
			(cAlias)->(DBSkip())
		EndDo

		oHeadData["items"]  := aItemQry
		oEmpData 			:= oHeadData
	EndIf

	fResetErrorHandler()
	(cAlias)->(DbCloseArea())

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function fPreValid
Check Pre-Validations
@author  oliveira.hugo
@since   26/04/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fPreValid(oObj, cBranchId, cDateMod, cCompId, cProd)
	Local lRet 	   		:= .T. 
	Local cMessage 		:= ""
	
	Local lRHKUSERGA	:= If(RHK->(ColumnPos("RHK_USERGA")) > 0, .T., .F.)	
	Local lRHKMATSAU 	:= If(RHK->(ColumnPos("RHK_MATSAU")) > 0, .T., .F.)
	Local lRHKMATODO 	:= If(RHK->(ColumnPos("RHK_MATODO")) > 0, .T., .F.)
	Local lRHKCNS 		:= If(RHK->(ColumnPos("RHK_CNS")) > 0, .T., .F.)
	
	Local lRHLUSERGA 	:= If(RHL->(ColumnPos("RHL_USERGA")) > 0, .T., .F.)
	Local lRHLMATSAU 	:= If(RHL->(ColumnPos("RHL_MATSAU")) > 0, .T., .F.)
	Local lRHLMATODO 	:= If(RHL->(ColumnPos("RHL_MATODO")) > 0, .T., .F.)
	Local lRHLCNS 		:= If(RHL->(ColumnPos("RHL_CNS")) > 0, .T., .F.)
	
	// Check Fields
	If lRHKUSERGA == .F. .OR. lRHLUSERGA == .F. .OR. lRHKMATSAU == .F. .OR. lRHKMATODO == .F. .OR. lRHKCNS == .F. .OR. lRHLMATSAU == .F. .OR. lRHLMATODO == .F. .OR. lRHLCNS == .F.
		cMessage := STR0003 // STR0003: "Os campos RHK_USERGA, RHL_USERGA, RHK_MATSAU, RHK_MATODO, RHK_CNS, RHL_MATSAU, RHL_MATODO e RHL_CNS são obrigatórios e não foram encontrados."
		lRet := .F.

	// Check cProd
	ElseIf Empty(cProd)
		cMessage := STR0010 // STR0010: "O parâmetro product é obrigatório."
		lRet 	 := .F.
	
	// Check cCompId
	ElseIf Empty(cCompId)
		cMessage := STR0011 // STR0011: "O parâmetro companyId é obrigatório."
		lRet 	 := .F.

	// Check cBranchId
	ElseIf Empty(cBranchId)
		cMessage := STR0012 // STR0012: "O parâmetro branchId é obrigatório."
		lRet 	 := .F.
	
	ElseIf !fValidDate(cDateMod)
		cMessage := STR0014 // STR0014: "Se preenchido, o parâmetro datemodified deve estar no formato: '2019-05-01T18:25:43'."
		lRet 	 := .F.

	// cBranchId Validation
	ElseIf !(Empty(cDateMod)) .AND. !(FWFilExist(cCompId,cBranchId))
		cMessage := STR0015 + cCompId + " " + cBranchId // STR0015: "Filial não encontrada para os valores informados de empresa e Filial: "
		lRet 	 := .F.
	EndIf

	If !lRet
		SetRestFault(ERRORCODE_DEF, EncodeUTF8(cMessage), , , , URL_DEF, )
	EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function fPosValid
Check data validation after RHK Query
@author  oliveira.hugo
@since   26/04/2019
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
		cURL		:= ""
		cMessage	:= EncodeUTF8(STR0002) // STR0002: "Nenhum registro localizado."
		lRet		:= .F.
	EndIf

	If !lRet
		SetRestFault(ERRORCODE_DEF, EncodeUTF8(cMessage), , , , URL_DEF, )
	EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} function ClearDate
Clean especial character from Date Input. Input Format: 2012-04-23T18:25:43.511Z
@author  oliveira.hugo
@since   26/04/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fClearDate(cDate)
	cDate := StrTran(cDate, "T", "")
	cDate := StrTran(cDate, ":", "")
	cDate := StrTran(cDate, "-", "")
	cDate := SubStr(cDate,1,8)
Return cDate


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
/*/{Protheus.doc} function fNewDate 
Convert Date Input("062019") to DATETIME Format("yyyy-mm-ddT00:00:00")
@author  oliveira.hugo
@since   17/06/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fNewDate(cPropert,cDate)
	Local cRet 		:= ""
	Local cDay 		:= ""
	Local cMonth	:= ""
	Local cYear		:= ""
	Local cLastDay 	:= ""

	If !Empty(cDate)
		cDay 	 := "01"
		cMonth 	 := SubStr(cDate,1,2)
		cYear 	 := SubStr(cDate,3,4)
		cLastDay := SubStr(DTOC(Lastday( CTOD("'" + cDay + "/"+ cMonth + "/" + cYear + "'"), 0)), 1, 2)

		IF cPropert = "beginDate"
			cRet := cYear + "-" + cMonth + "-" + cDay + "T00:00:00"
		Else
			cRet := cYear + "-" + cMonth + "-" + cLastDay + "T00:00:00"
		EndIf
	Else
		cRet := ""
	EndIf
Return cRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function fCompress
Compress String Object
@author  oliveira.hugo
@since   26/04/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fCompress(oObj)
	Local cJson    := ""
	Local cComp    := ""
	Local lCompact := .F.
	
	// Set gzip format to Json Object
	cJson := oObj:toJSON()

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