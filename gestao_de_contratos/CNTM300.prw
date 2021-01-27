#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "CNTM300.CH"
#INCLUDE "FILEIO.CH"

//------------------------------------------------------------------------------
/*/{Protheus.doc} WSCNTA300

Classe responsavel por retornar os dados do contrato para o app do SIGAGCT

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17
/*/
//------------------------------------------------------------------------------
WSRESTFUL WSCNTA300 DESCRIPTION STR0001
 
	WSDATA page					AS INTEGER	OPTIONAL
	WSDATA pageSize 			AS INTEGER	OPTIONAL
	WSDATA status 				AS INTEGER	OPTIONAL
	WSDATA expiring				AS BOOLEAN	OPTIONAL 
	WSDATA schedule				AS BOOLEAN  OPTIONAL
	WSDATA allTypes				AS BOOLEAN 	OPTIONAL
	WSDATA byId					AS BOOLEAN	OPTIONAL	
	WSDATA searchKey 			AS STRING	OPTIONAL
	WSDATA _type				AS STRING 	OPTIONAL
	WSDATA customer				AS STRING 	OPTIONAL
	WSDATA supplier				AS STRING	OPTIONAL
	WSDATA unit					AS STRING 	OPTIONAL
	WSDATA order				AS STRING 	OPTIONAL
	WSDATA revisionFilter		AS STRING	OPTIONAL
	WSDATA coin					AS STRING
	WSDATA contractID			AS STRING
	WSDATA rev					AS STRING
	WSDATA doc					AS STRING	
	WSDATA spreadSheetNumber	AS STRING
	WSDATA plan					AS STRING
	
	WSMETHOD GET 	customers 	DESCRIPTION STR0002 WSSYNTAX '/customers'  										PATH 'customers' TTALK 'V1' PRODUCES APPLICATION_JSON  //-- Retorna lista de clientes.	
	WSMETHOD GET 	suppliers 	DESCRIPTION STR0004 WSSYNTAX '/suppliers'  										PATH 'suppliers' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de fornecedores.	
	WSMETHOD GET 	contracts 	DESCRIPTION STR0005 WSSYNTAX '/contracts' 										PATH 'contracts' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de contratos.	
	WSMETHOD GET 	totalCtr  	DESCRIPTION STR0008 WSSYNTAX '/contracts/total'									PATH 'contracts/total' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna a quantidade total de contratos.	
	WSMETHOD GET 	detailCtr 	DESCRIPTION STR0006 WSSYNTAX '/contracts/{contractID}/{rev}'  					PATH 'contracts/{contractID}/{rev}' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de fornecedores.	
	WSMETHOD GET 	balanceDt 	DESCRIPTION STR0007 WSSYNTAX '/contracts/{contractID}/{rev}/spreadsheets/{spreadSheetNumber}/balances'  PATH 'contracts/{contractID}/{rev}/spreadsheets/{spreadSheetNumber}/balances' TTALK 'V1' PRODUCES APPLICATION_JSON //"Retorna os valores previstos e realizados da planilha."
	WSMETHOD GET 	forecast  	DESCRIPTION STR0009 WSSYNTAX '/contracts/{contractID}/{rev}/forecast' 			PATH 'contracts/{contractID}/{rev}/forecast' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna a projecao financeira para os proximos 6 meses.
	
	WSMETHOD GET 	1customers 	DESCRIPTION STR0002 WSSYNTAX '/api/protheus/wscnta300/v1/customers'  					PATH 'api/protheus/wscnta300/v1/customers' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de clientes.
	WSMETHOD GET 	1suppliers 	DESCRIPTION STR0004 WSSYNTAX '/api/protheus/wscnta300/v1/suppliers'  					PATH 'api/protheus/wscnta300/v1/suppliers' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de fornecedores.
	WSMETHOD GET 	1contracts 	DESCRIPTION STR0005 WSSYNTAX '/api/protheus/wscnta300/v1/contracts' 					PATH 'api/protheus/wscnta300/v1/contracts' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de contratos.
	WSMETHOD GET 	1totalCtr  	DESCRIPTION STR0008 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/total'				PATH 'api/protheus/wscnta300/v1/contracts/total' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna a quantidade total de contratos.
	WSMETHOD GET 	1detailCtr 	DESCRIPTION STR0006 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}'  PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de fornecedores.
	WSMETHOD GET 	1balanceDt 	DESCRIPTION STR0007 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/spreadsheets/{spreadSheetNumber}/balances'  PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/spreadsheets/{spreadSheetNumber}/balances' TTALK 'V1' PRODUCES APPLICATION_JSON //"Retorna os valores previstos e realizados da planilha."
	WSMETHOD GET 	1forecast  	DESCRIPTION STR0009 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/forecast' PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/forecast' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna a projecao financeira para os proximos 6 meses.

	WSMETHOD GET 	stoppages	DESCRIPTION STR0061 WSSYNTAX '/api/protheus/wscnta300/v1/stoppages'				PATH 'api/protheus/wscnta300/v1/stoppages' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista dos motivos de paralizacao	
	WSMETHOD GET 	indexes   	DESCRIPTION STR0016 WSSYNTAX '/api/protheus/wscnta300/v1/indexes' 				PATH 'api/protheus/wscnta300/v1/indexes' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de indices de reajuste
	WSMETHOD GET 	products  	DESCRIPTION STR0017 WSSYNTAX '/api/protheus/wscnta300/v1/products' 				PATH 'api/protheus/wscnta300/v1/products' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de produtos
    WSMETHOD GET 	costCenter 	DESCRIPTION STR0018 WSSYNTAX '/api/protheus/wscnta300/v1/costCenters'			PATH 'api/protheus/wscnta300/v1/costCenters' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna a lista de centro de custos
    WSMETHOD GET 	accAccount 	DESCRIPTION STR0019 WSSYNTAX '/api/protheus/wscnta300/v1/financialAccounts' 	PATH 'api/protheus/wscnta300/v1/financialAccounts' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna a lista de contas contábeis
    WSMETHOD GET 	accItems   	DESCRIPTION STR0020 WSSYNTAX '/api/protheus/wscnta300/v1/accountingItems' 		PATH 'api/protheus/wscnta300/v1/accountingItems' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna a lista de items contábeis
    WSMETHOD GET 	valueClass 	DESCRIPTION STR0021 WSSYNTAX '/api/protheus/wscnta300/v1/valueClasses' 			PATH 'api/protheus/wscnta300/v1/valueClasses' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna a lista de classes de valor
	WSMETHOD GET 	schedule 	DESCRIPTION STR0022 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/spreadsheets/{spreadsheetNumber}/schedule' PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/spreadsheets/{spreadsheetNumber}/schedule' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna as parcelas do cronograma financeiro
	WSMETHOD GET 	payments 	DESCRIPTION STR0023 WSSYNTAX '/api/protheus/wscnta300/v1/paymentConditions' 	PATH 'api/protheus/wscnta300/v1/paymentConditions' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna condicoes de pagamento
	WSMETHOD GET    classes		DESCRIPTION STR0057	WSSYNTAX '/api/protheus/wscnta300/v1/classes'				PATH 'api/protheus/wscnta300/v1/classes' TTALK 'V1' PRODUCES APPLICATION_JSON //Retorna as naturezas
	WSMETHOD GET 	approval	DESCRIPTION STR0024 WSSYNTAX '/api/protheus/wscnta300/v1/approvalGroups' 		PATH 'api/protheus/wscnta300/v1/approvalGroups' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna grupos de aprovação
	WSMETHOD GET 	coins     	DESCRIPTION STR0025 WSSYNTAX '/api/protheus/wscnta300/v1/coins' 				PATH 'api/protheus/wscnta300/v1/coins' TTALK 'V1' PRODUCES APPLICATION_JSON	//-- Retorna lista de moedas
	WSMETHOD GET 	typesCont	DESCRIPTION STR0026 WSSYNTAX '/api/protheus/wscnta300/v1/typesOfContract' 		PATH 'api/protheus/wscnta300/v1/typesOfContract' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna os tipos de contrato
	WSMETHOD GET 	typesSpred 	DESCRIPTION STR0027 WSSYNTAX '/api/protheus/wscnta300/v1/typesOfSpreadsheet' 	PATH 'api/protheus/wscnta300/v1/typesOfSpreadsheet' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna os tipos de planilha
	WSMETHOD GET 	department 	DESCRIPTION STR0029 WSSYNTAX '/api/protheus/wscnta300/v1/departments' 			PATH 'api/protheus/wscnta300/v1/departments' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna departamentos do contrato
	WSMETHOD GET 	getDoc	 	DESCRIPTION STR0043 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/documents' 		PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/documents' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna lista de documentos anexados ao contrato
	WSMETHOD GET	document	DESCRIPTION STR0043	WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/documents/{doc}' 	PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/documents/{doc}' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna o documento solicitado no formato base64
	WSMETHOD GET    revisions	DESCRIPTION STR0042	WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/historic/revisions' 	PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/historic/revisions' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna o histórico de revisoes do contrato
	WSMETHOD GET	cdrevision 	DESCRIPTION STR0047 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/type/revisions' 		PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/type/revisions' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna o número da revisão e seu tipo
	WSMETHOD GET	accPlan		DESCRIPTION STR0059	WSSYNTAX '/api/protheus/wscnta300/v1/accountingPlans'								PATH 'api/protheus/wscnta300/v1/accountingPlans'	TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna os codigos dos planos de contas adicionais
	WSMETHOD GET	accEnt		DESCRIPTION	STR0060	WSSYNTAX '/api/protheus/wscnta300/v1/accountingEntities/{plan}'						PATH 'api/protheus/wscnta300/v1/accountingEntities/{plan}'	TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna as entidades contabeis de acordo com o plano de contas informado
	
	WSMETHOD PUT  	altCtr		DESCRIPTION STR0037	WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}' 					PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}' TTALK 'V1' PRODUCES APPLICATION_JSON  //-- Altera um contrato
	WSMETHOD PUT 	status		DESCRIPTION STR0041 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/status' 			PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/status' TTALK 'V1' PRODUCES APPLICATION_JSON  //-- Altera a situacao do contrato
	WSMETHOD PUT 	aprRev		DESCRIPTION STR0050 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/approveRevision'	PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/approveRevision' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Aprova revisão do contrato
	
	WSMETHOD POST	coinRate	DESCRIPTION STR0058 WSSYNTAX '/api/protheus/wscnta300/v1/coins/{coin}/rates'	       					PATH 'api/protheus/wscnta300/v1/coins/{coin}/rates' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Retorna as taxas da moedas de acordo com a data especificada
	WSMETHOD POST 	incCtr		DESCRIPTION STR0028	WSSYNTAX '/api/protheus/wscnta300/v1/contracts' 									PATH 'api/protheus/wscnta300/v1/contracts' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Inclui um contrato
	WSMETHOD POST 	postDoc		DESCRIPTION STR0035	WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/documents' 				PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/documents' TTALK 'V1' PRODUCES APPLICATION_JSON //-- anexa um documento ao contrato
	WSMETHOD POST 	incRev		DESCRIPTION STR0048 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/revision'			PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/revision' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Cria uma revisao para o contrato
	WSMETHOD POST 	readj		DESCRIPTION STR0051	WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/readjustment'		PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/readjustment' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Aplica reajuste aos contratos
	WSMETHOD POST 	rein		DESCRIPTION STR0053 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID/{rev}/restart'           PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/restart' TTALK 'V1' PRODUCES APPLICATION_JSON //- Reinicia um contrato paralisado.
	
	WSMETHOD DELETE	delCtr 		DESCRIPTION STR0039	WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}' 					PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}' TTALK 'V1' PRODUCES APPLICATION_JSON  //-- Exclui um contrato
	WSMETHOD DELETE docDel		DESCRIPTION STR0046 WSSYNTAX '/api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/documents/{doc}' 	PATH 'api/protheus/wscnta300/v1/contracts/{contractID}/{rev}/documents/{doc}' TTALK 'V1' PRODUCES APPLICATION_JSON //-- Exclui um documento anexado ao contrato

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / customers
Retorna a lista de clientes disponíveis para filtrar os contratos exibidos.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo a lista de clientes

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET customers WSRECEIVE searchKey, page, pageSize, unit WSREST WSCNTA300
	
	Local lRet:= .T.
	
	lRet := Customers( self )

Return( lRet ) 

WSMETHOD GET 1customers WSRECEIVE searchKey, page, pageSize, unit, byId WSREST WSCNTA300
	
	Local lRet:= .T.
	
	lRet := Customers( self )

Return( lRet ) 


Static Function Customers( oSelf )

	Local aListCli	:= {}
	
	Local cAliasSA1		:= GetNextAlias()
	Local cMessage		:= "Internal Server Error"
	Local cJsonCli		:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND SA1.A1_FILIAL = '"+xFilial('SA1')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStatusCode	:= 500
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonCli	:= JsonObject():New()
		
	Default oself:searchKey 	:= ''
	Default oself:unit		:= ''
	Default oself:page		:= 1
	Default oself:pageSize	:= 20 
	Default oself:byId		:=.F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(oself:searchKey)
		cSearch := Upper( oself:SearchKey )
		If oself:byId
			cWhere += " AND SA1.A1_COD = '"	+ cSearch + "'"
		Else
			cWhere += " AND ( SA1.A1_COD LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " SA1.A1_LOJA LIKE '%" + cSearch + "%' OR "
			cWhere	+= " SA1.A1_NOME LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " SA1.A1_NOME LIKE '%" + cSearch + "%' ) "
		EndIf
	EndIf
	
	If !Empty(oself:unit)
		cWhere += " AND SA1.A1_LOJA = '"+oself:unit+"'"
	EndIf
	
	dbSelectArea('SA1')
	If SA1->( Columnpos('A1_MSBLQL') > 0 )
		cWhere += " AND SA1.A1_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar clientes
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasSA1
	
		SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME
		FROM 	%table:SA1% SA1
		WHERE 	SA1.%NotDel%
		%exp:cWhere%
		ORDER BY A1_COD
	
	ENDSQL
	
	If ( cAliasSA1 )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If oself:page > 1
			nStart := ( ( oself:page - 1 ) * oself:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasSA1 )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > oself:pageSize
			oJsonCli['hasNext'] := .T.
		Else
			oJsonCli['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonCli['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasSA1 )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aListCli , JsonObject():New() )
			
			aListCli[nAux]['id']	:= ( cAliasSA1 )->A1_COD
			aListCli[nAux]['name']	:= Alltrim( EncodeUTF8( ( cAliasSA1 )->A1_NOME ) )
			aListCli[nAux]['unit']	:= ( cAliasSA1 )->A1_LOJA
			
			If Len(aListCli) >= oself:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasSA1 )->( DBSkip() )
		
	End
	
	( cAliasSA1 )->( DBCloseArea() )
	
	oJsonCli['clients'] := aListCli
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCli:= FwJsonSerialize( oJsonCli )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCli)
	
	oself:SetResponse( cJsonCli ) //-- Seta resposta

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / suppliers
Retorna a lista de fornecedores disponíveis para filtrar os contratos exibidos.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo a lista de fornecedores

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET suppliers WSRECEIVE searchKey, page, pageSize, unit WSREST WSCNTA300
	
	Local lRet := .T.
	lRet := suppliers ( self )
	
Return( lRet ) 

WSMETHOD GET 1suppliers WSRECEIVE searchKey, page, pageSize, unit WSREST WSCNTA300
	
	Local lRet := .T.
	lRet := suppliers ( self )
	
Return( lRet ) 

Static Function suppliers ( oSelf )

	Local aListFor	:= {}
	
	Local cAliasSA2		:= GetNextAlias()
	Local cMessage		:= "Internal Server Error"
	Local cJsonFor		:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND SA2.A2_FILIAL = '"+xFilial('SA2')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStatusCode	:= 500
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonFor	:= JsonObject():New() 
		
	Default oSelf:searchKey 	:= ''
	Default oSelf:unit	:= ''
	Default oSelf:page		:= 1
	Default oSelf:pageSize	:= 20 
	Default oSelf:byId		:=.F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(oSelf:searchKey)
		cSearch := Upper( oSelf:SearchKey  )
		If oSelf:byId
			cWhere += " AND SA2.A2_COD = '"	+ cSearch + "'"
		Else
			cWhere += " AND ( SA2.A2_COD LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " SA2.A2_LOJA LIKE '%" + cSearch + "%' OR "
			cWhere	+= " SA2.A2_NOME LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " SA2.A2_NOME LIKE '%" + cSearch + "%' ) " 
		EndIf
	EndIf
	
	If !Empty(oself:unit)
		cWhere += " AND SA2.A2_LOJA = '"+oself:unit+"'"
	EndIf
	
	dbSelectArea('SA2')
	If SA2->( Columnpos('A2_MSBLQL') > 0 )
		cWhere += " AND SA2.A2_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar fornecedores
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasSA2
	
		SELECT SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NOME
		FROM 	%table:SA2% SA2
		WHERE 	SA2.%NotDel%
		%exp:cWhere%
		ORDER BY A2_COD
	
	ENDSQL
	
	If ( cAliasSA2 )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If oSelf:page > 1
			nStart := ( ( oSelf:page - 1 ) * oSelf:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasSA2 )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > oSelf:pageSize
			oJsonFor['hasNext'] := .T. 
		Else
			oJsonFor['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonFor['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasSA2 )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aListFor , JsonObject():New() )
			
			aListFor[nAux]['id']	:= ( cAliasSA2 )->A2_COD
			aListFor[nAux]['name']	:= Alltrim( EncodeUTF8( ( cAliasSA2 )->A2_NOME ) )
			aListFor[nAux]['unit']	:= ( cAliasSA2 )->A2_LOJA
			
			If Len(aListFor) >= oSelf:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasSA2 )->( DBSkip() )
		
	End
	
	( cAliasSA2 )->( DBCloseArea() )
	
	oJsonFor['suppliers'] := aListFor
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonFor:= FwJsonSerialize( oJsonFor )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonFor)
	
	oSelf:SetResponse( cJsonFor ) //-- Seta resposta

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / contracts
Retorna a lista de contratos disponíveis para consulta.

@param	Page			, numerico, numero da pagina 
@param	PageSize		, numerico, quantidade de registros por pagina
@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
@param	_type			, caracter, tipo do contrato
@param	customer		, caracter, cliente relacionado ao contrato
@param	supplier		, caracter, fornecedor relacionado ao contrato
@param	unit			, caracter, loja do cliente ou fornecedor relacionado ao contrato
@param	expiring		, logico,   indicador de contratos a vencer
@param	status			, caracter,	status do contrato:
									0 - Todos os contratos (Valor default);
									1 - Contratos vigentes;
									2 - Contratos em elaboração;
									3 - Contratos aguardando aprovação;
									4 - Contratos paralisados;
									5 - Contratos em reajuste;
									6 - Contratos vencidos;
									7 - Contratos a vencer;

@return cResponse		, caracter, JSON contendo a lista de contratos

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET contracts WSRECEIVE page, pageSize, searchKey, _type, customer, supplier, unit, expiring, status, order  WSREST WSCNTA300

	Local lRet:= .T.
	
	lRet := contracts( self )
	
Return( lRet )

WSMETHOD GET 1contracts WSRECEIVE page, pageSize, searchKey, _type, customer, supplier, unit, expiring, status, order  WSREST WSCNTA300

	Local lRet:= .T.
	
	lRet := contracts( self )
	
Return( lRet )


Static Function contracts( oSelf )
	
	Local aListCtr	:= {}
	Local aGrupos	:= {}
	
	Local cAliasCN9		:= GetNextAlias()
	Local cMessage		:= "Internal Server Error"
	Local cJsonCtr		:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cQuery		:= ""
	Local cQuery1		:= ""
	Local cQuery2		:= ""
	Local cQuery3		:= ""
	Local cQuery4		:= ""
	Local cQuery5		:= ""
	Local cQuery6		:= ""
	Local cCodUsr		:= __cUserId
	Local cGrupos		:= ''
	Local cSituac		:= '05'
	Local cDataBase 	:= DtoS( dDataBase )
	Local cDataAux 		:= ''
	Local cOrder		:= ''
	
	Local lRet		:= .T.
	Local lHasNext	:= .F.	
	Local lDepart	:= .F.
	
	Local nCount		:= 0
	Local nStatusCode	:= 500
	Local nStart		:= 1
	Local nReg			:= 0
	Local nAux			:= 0
	Local nX			:= 0
	Local nDiasVenc		:= 0
	Local nDiasKPIV	:= SuperGetMV( 'MV_GCTKPIV' , .F. , 30 )
	Local nDiasKPIR	:= SuperGetMV( 'MV_GCTKPIR' , .F. , 0 )
	
	Local oJsonCtr	:= JsonObject():New() 
		
	Default oSelf:page		:= 1
	Default oSelf:pageSize	:= 20 
	Default oSelf:searchKey 	:= ''
	Default oSelf:_type		:= ''
	Default oSelf:customer 	:= ''
	Default oSelf:supplier 	:= ''
	Default oSelf:unit 		:= ''
	Default oSelf:order		:= ''
	Default oSelf:expiring	:= .F.
	Default oSelf:status		:= 1
	
	If !Empty( oSelf:customer )
		oSelf:customer	:= PadR( oSelf:customer , TAMSX3('A1_COD')[1] )
		oSelf:unit	:= PadR( oSelf:unit , TAMSX3('A1_LOJA')[1] )
	ElseIf !Empty( oSelf:supplier )
		oSelf:supplier	:= PadR( oSelf:supplier , TAMSX3('A2_COD')[1] )
		oSelf:unit	:= PadR( oSelf:unit , TAMSX3('A2_LOJA')[1] )
	EndIf
	
	Do Case
		Case oSelf:status == 2	//-- Contratos em elaboração
			cSituac := '02'
		Case oSelf:status == 3	//-- Contratos em aprovacao
			cSituac := '04'
		Case oSelf:status == 4	//-- Contratos paralisados
			cSituac := '06'
	End Case

	cOrder := WS300Order( oSelf:order )
	
	aGrupos := UsrRetGrp( UsrRetName( cCodUsr ) )

	For nX := 1 to len( aGrupos )
		cGrupos += "'" + aGrupos[nX] + "',"
	Next
	
	cGrupos := SubStr( cGrupos , 1 , len( cGrupos ) -1 )
	
	dbSelectArea('CN9')
	lDepart	:= CN9->(Columnpos('CN9_DEPART')) > 0
	
	//-------------------------------------------------------------------
	// Query para selecionar contratos
	//-------------------------------------------------------------------
	
	cQuery1 := "SELECT DISTINCT CN9.CN9_NUMERO, CN9.CN9_REVISA, CN9.CN9_ESPCTR, CN9.CN9_DTINIC, CN9.CN9_DESCRI, " 
	cQuery1 += "CN9.CN9_DTFIM, CN9.CN9_SALDO, CN9.CN9_VLATU, CN9.CN9_MOEDA, CN9.CN9_TPCTO, CN9.CN9_FILIAL , CN1.CN1_DESCRI, "
	cQuery1 += "CN9.CN9_SITUAC, CN9.CN9_APROV, CN9.CN9_FLGREJ "
	
	If lDepart
		cQuery1 += ", CN9.CN9_DEPART"
	EndIf
		
	cQuery1	+= "FROM " + RetSQLName("CN9") + " CN9 "
	
	cQuery1 += "INNER JOIN " + RetSQLName("CN1") + " CN1 ON "
	cQuery1 += "CN1.CN1_FILIAL = '" + xFilial("CN1") + "' AND "
	cQuery1 += "CN1.CN1_CODIGO = CN9.CN9_TPCTO AND "
	cQuery1 += "CN1.D_E_L_E_T_ = ' ' "

	If oSelf:status == 5
		cDataAux := DtoS( dDataBase + nDiasKPIR )
		cQuery1 += "INNER JOIN " + RetSQLName("CNA") + " CNA ON "
		cQuery1 += "CNA.CNA_CONTRA = CN9.CN9_NUMERO AND "
		cQuery1 += "CNA.CNA_REVISA = CN9.CN9_REVISA AND "
		cQuery1 += "CNA.CNA_FILIAL = CN9.CN9_FILIAL AND "
		cQuery1 += "CNA.CNA_PROXRJ < '" + cDataAux + "' AND "
		cQuery1 += "CNA.CNA_PROXRJ <> '" + Space(TAMSX3("CNA_PROXRJ")[1]) + "' AND "
		cQuery1 += "CNA.D_E_L_E_T_ = ' ' "
	EndIf
	
	If !Empty(oSelf:supplier) .And. !Empty(oSelf:unit)	//-- Filtro de fornecedor
		cQuery1 += "INNER JOIN " + RetSQLName("CNC") + " CNC ON "
		cQuery1 += "CNC.CNC_FILIAL = '" + xFilial("CNC") + "' AND "
		cQuery1 += "CNC.CNC_NUMERO = CN9.CN9_NUMERO AND "
		cQuery1 += "CNC.CNC_REVISA = CN9.CN9_REVISA AND "
		cQuery1 += "CNC.CNC_CODIGO = '" + oSelf:supplier + "' AND "
		cQuery1 += "CNC.CNC_LOJA = '" + oSelf:unit + "' AND "
		cQuery1 += "CNC.D_E_L_E_T_ = ' ' "
	ElseIf !Empty(oSelf:customer) .And. !Empty(oSelf:unit)	//-- Filtro de Contrato
		cQuery1 += "INNER JOIN " + RetSQLName("CNC") + " CNC ON "
		cQuery1 += "CNC.CNC_FILIAL = '" + xFilial("CNC") + "' AND "
		cQuery1 += "CNC.CNC_NUMERO = CN9.CN9_NUMERO AND "
		cQuery1 += "CNC.CNC_REVISA = CN9.CN9_REVISA AND "
		cQuery1 += "CNC.CNC_CLIENT = '" + oSelf:customer + "' AND "
		cQuery1 += "CNC.CNC_LOJACL = '" + oSelf:unit + "' AND "
		cQuery1 += "CNC.D_E_L_E_T_ = ' ' "
	EndIf
	
	//-- Filtra permissao ( Controle Total ou Visualizacao do Contrato)
	cQuery2 += "INNER JOIN " +RetSQLName("CNN") + " CNN ON "
	cQuery2 += "CNN.CNN_FILIAL = '" + xFilial("CNN") + "' AND "
	cQuery2 += "CNN.CNN_CONTRA = CN9.CN9_NUMERO AND "
	
	If Empty(cGrupos)
		cQuery2 += "CNN.CNN_USRCOD = '" + cCodUsr + "' AND "
	Else	
		cQuery2 += "( CNN.CNN_USRCOD = '" + cCodUsr + "' OR CNN.CNN_GRPCOD IN ("+ cGrupos +") ) AND "
	EndIf
	
	cQuery2 += "CNN.CNN_TRACOD IN ( '001' , '037' )  AND "
	cQuery2 += "CNN.D_E_L_E_T_ = ' ' "
	
	cQuery3 += "WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
	
	If oSelf:status == 0
		cQuery3 += "CN9.CN9_SITUAC NOT IN ('09','10') AND "
	ElseIf oSelf:status == 8
		cQuery3 += "CN9.CN9_SITUAC NOT IN ('10') AND "
	Else
		cQuery3	+= "CN9.CN9_SITUAC = '"+cSituac+"' AND "
	EndIf

	If oSelf:status == 6
		cQuery3 += "CN9.CN9_DTFIM < '"+cDataBase+"' AND "
	ElseIf oSelf:status == 7
		cDataAux := DtoS( dDataBase + nDiasKPIV )
		cQuery3 += "CN9.CN9_DTFIM >= '"+cDataBase+"' AND "
		cQuery3 += "CN9.CN9_DTFIM < '"+cDataAux+"' AND "
	EndIf

	cQuery3 += "CN9.D_E_L_E_T_ = ' ' "
	
	If !Empty(oSelf:_type)	//-- Filtro de tipo (compra ou venda)
		cQuery3 += "AND CN9.CN9_ESPCTR = '" + oSelf:_type + "' " 
	EndIf
	
	If !Empty(oSelf:searchKey)	//-- Chave de busca do usuario
		cSearch := Upper( oSelf:SearchKey ) //-- Busca com acentuacao
		cQuery3 += " AND ( CN9.CN9_NUMERO LIKE '%"	+ cSearch + "%' OR "
		cQuery3 += " CN9.CN9_REVISA LIKE '%" + cSearch + "%' OR "
		cQuery3 += " CN1.CN1_DESCRI LIKE '%" + cSearch + "%' OR "
		cQuery3 += " CN1.CN1_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		cQuery3 += " UPPER(CN9.CN9_DESCRI) LIKE '%" + cSearch + "%' OR "
		cQuery3 += " UPPER(CN9.CN9_DESCRI) LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		If lDepart
			cQuery3 += " CN9.CN9_DEPART LIKE '%" + cSearch + "%' OR "
			cQuery3 += " CN9.CN9_DEPART LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		EndIf
		cQuery3 += " CN9.CN9_DTINIC LIKE '%" + cSearch + "%' OR "
		cQuery3 += " CN9.CN9_DTFIM LIKE '%" + cSearch + "%' ) " 
	EndIf
	
	cQuery4 += " AND CN9_VLDCTR = '2' "
	
	cQuery5 += " AND CN9_VLDCTR IN( ' ' , '1' ) "
	
	cQuery6 += "ORDER BY " + cOrder
	
	cQuery := cQuery1 + cQuery2 + cQuery3 + cQuery5	//-- Contratos com controle de permissao 
	cQuery += " UNION "
	cQuery += cQuery1 + cQuery3 + cQuery4 	//-- Contratos sem controle de permissao
	cQuery += cQuery6 //-- Order By

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasCN9,.F.,.T.)
	
	//-------------------------------------------------------------------
	// nStart -> primeiro registro da pagina
	//-------------------------------------------------------------------
	If oSelf:page > 1
		nStart := ( ( oSelf:page - 1 ) * oSelf:pageSize ) + 1
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de contratos
	//-------------------------------------------------------------------
	While ( cAliasCN9 )->( ! Eof() ) 
		
		//-------------------------------------------------------------------
		// Dias para o vencimento do contrato
		//-------------------------------------------------------------------
		nDiasVenc := WS300Venc( ( cAliasCN9 )->CN9_TPCTO , ( cAliasCN9 )->CN9_FILIAL , STOD( ( cAliasCN9 )->CN9_DTFIM ) )
		
		//-------------------------------------------------------------------
		// Se filtro de contratos a vencer estiver ativo e o contrato nao possuir controle de vencimento pula para o  proximo registro
		//-------------------------------------------------------------------
		If oSelf:expiring .And. nDiasVenc < -1	
			( cAliasCN9 )->( DBSkip() )
			Loop
		EndIf
		
		nCount++	

		If nCount >= nStart
			
			nAux++		
			aAdd( aListCtr , JsonObject():New() )
			
			aListCtr[nAux]['number']	:= ( cAliasCN9 )->CN9_NUMERO
			aListCtr[nAux]['rev']	:= ( cAliasCN9 )->CN9_REVISA
			aListCtr[nAux]['_type']	:= ( cAliasCN9 )->CN9_ESPCTR 
			aListCtr[nAux]['startDate']	:= ( cAliasCN9 )->CN9_DTINIC
			aListCtr[nAux]['endDate']	:= ( cAliasCN9 )->CN9_DTFIM
			aListCtr[nAux]['description']	:= If( !Empty( ( cAliasCN9 )->CN9_DESCRI ) , Alltrim( EncodeUTF8( ( cAliasCN9 )->CN9_DESCRI ) ) , Alltrim( EncodeUTF8( ( cAliasCN9 )->CN1_DESCRI ) ) ) 
			If lDepart
				aListCtr[nAux]['department']	:= Alltrim( EncodeUTF8( Posicione('CXQ', 1, xFilial("CXQ")+( cAliasCN9 )->CN9_DEPART, 'CXQ_DESCRI' ) ) )
			EndIf
			aListCtr[nAux]['daysToFinish']	:= If( dDataBase < STOD( ( cAliasCN9 )->CN9_DTFIM )  , DateDiffDay( dDataBase , STOD( ( cAliasCN9 )->CN9_DTFIM ) ) , 0 )
			aListCtr[nAux]['balance']	:= JsonObject():New() 
			aListCtr[nAux]['balance']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
			aListCtr[nAux]['balance']['total']	:= ( cAliasCN9 )->CN9_SALDO 
			aListCtr[nAux]['current_value']	:= JsonObject():New() 
			aListCtr[nAux]['current_value']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
			aListCtr[nAux]['current_value']['total']	:= ( cAliasCN9 )->CN9_VLATU 
			aListCtr[nAux]['readjustment'] := ( cAliasCN9 )->CN9_FLGREJ
			aListCtr[nAux]['revision_in_preparation'] := WS300Rev( ( cAliasCN9 )->CN9_NUMERO ) 

			If nDiasVenc >= -1 
				aListCtr[nAux]['expiresIn'] := nDiasVenc
			Else
				aListCtr[nAux]['expiresIn'] := Nil
			EndIf

			If Alltrim( (cAliasCN9)->CN9_SITUAC ) == '09' .And. ( Empty( (cAliasCN9)->CN9_APROV ) .OR. !ExistSCR2( 'RV', (cAliasCN9)->(CN9_NUMERO+CN9_REVISA) ) )
				aListCtr[nAux]['situation'] := '09'
			ElseIf Alltrim( (cAliasCN9)->CN9_SITUAC ) == 'A' .Or. ( Alltrim( (cAliasCN9)->CN9_SITUAC ) == '09' .And. !Empty( (cAliasCN9)->CN9_APROV ) )
				aListCtr[nAux]['situation'] := '12'
			Else
				aListCtr[nAux]['situation'] := (cAliasCN9)->CN9_SITUAC
			EndIf
			
		EndIf
		
		( cAliasCN9 )->( DBSkip() )
		
		If Len(aListCtr) >= oSelf:pageSize
			Exit
		EndIf
		
	End
	
	//-------------------------------------------------------------------
	// Valida a exitencia de mais paginas
	//-------------------------------------------------------------------
	If	oSelf:expiring
		
		//-------------------------------------------------------------------
		// Verifica existencia de contratos a vencer
		//-------------------------------------------------------------------
		While ( cAliasCN9 )->( ! Eof() ) 
			
			nDiasVenc := WS300Venc( ( cAliasCN9 )->CN9_TPCTO , ( cAliasCN9 )->CN9_FILIAL , STOD( ( cAliasCN9 )->CN9_DTFIM ) )
			
			If nDiasVenc >= -1		//-- encontrou contrato a vencer 
				oJsonCtr['hasNext'] := .T.	
				lHasNext	:= .T.
				Exit			
			EndIf
			
			( cAliasCN9 )->( DBSkip() )
		End
		
		If !lHasNext 	//-- nao encontrou contratos a vencer
			oJsonCtr['hasNext'] := .F.
		EndIf
		
	Else
		
		If ( cAliasCN9 )->( ! Eof() )
			oJsonCtr['hasNext'] := .T.
		Else
			oJsonCtr['hasNext'] := .F.
		EndIf
		
	EndIf 
	
	//-------------------------------------------------------------------
	// Alimenta objeto Json com a lista de contratos e o numero de contratos a expirar
	//-------------------------------------------------------------------
	oJsonCtr['contracts'] := aListCtr
	oJsonCtr['contractsToExpire'] := WS300QExp( cAliasCN9 )
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCtr:= FwJsonSerialize( oJsonCtr )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCtr)
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	oSelf:SetResponse( cJsonCtr ) 

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / contracts / contractID / rev
Retorna  os detalhes de um contrato.

@param	contractID		, caracter, numero do contrato 
		rev				, caracter, numero da revisao

@return cResponse		, caracter, JSON contendo os detalhes do contrato

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET detailCtr PATHPARAM contractID, rev WSRECEIVE schedule WSREST WSCNTA300
	
	Local lRet	:= .T.
	
	lRet := detailCtr( self )

Return( lRet )

WSMETHOD GET 1detailCtr PATHPARAM contractID, rev WSRECEIVE schedule WSREST WSCNTA300
	
	Local lRet	:= .T.
	
	lRet := detailCtr( self )

Return( lRet )

Static Function detailCtr( oSelf )

	Local aListPlan	:= {}
	Local aTotais	:=	{}
	
	Local cAliasCN9	:= GetNextAlias()
	Local cMessage	:= "Internal Server Error"
	Local cJsonCtr	:= ''
	Local cFilCN1	:= xFilial('CN1')
	Local cFilCNL	:= xFilial('CNL')
	Local cFilSA1	:= xFilial('SA1')
	Local cFilSA2	:= xFilial('SA2')
	Local cFilCN6	:= xFilial('CN6')
	Local cCampos	:= ""
	
	Local oJsonCtr	:= JsonObject():New() 
	
	Local nStatusCode	:= 500
	Local nDiasVenc		:= 0
	Local nAux			:= 0
	
	Local lProjFlex	:= .F.
	Local lRet	:= .T.
	Local lNewFields	:= .F.

	Default oSelf:schedule := .F.
	
	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(oSelf:rev) == 0
		oSelf:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf
	
	dbSelectArea('CN9')
	dbSelectArea('CNA')
	lNewFields	:= CN9->(Columnpos('CN9_GESTC')) .And. CN9->(Columnpos('CN9_DEPART')) .And. CNA->(Columnpos('CNA_DESCPL')) 
	
	//-------------------------------------------------------------------
	// Query para selecionar o contrato e suas planilhas
	//-------------------------------------------------------------------
	cCampos := 	"CN9.CN9_NUMERO, CN9.CN9_REVISA, CN9.CN9_FILCTR, CN9.CN9_FILIAL, CN9.CN9_ESPCTR, CN9.CN9_VLATU, CN9.CN9_VIGE, CN9.CN9_APROV, CN9.CN9_GRPAPR, "
	cCampos +=	"CN9.CN9_UNVIGE, CN9.CN9_VIGE, CN9.CN9_DTINIC, CN9.CN9_DTFIM, CN9.CN9_TPCTO, CN9.CN9_MOEDA, CN9.CN9_SALDO, CN9.CN9_SITUAC, CN9_DTFIMP, "
	cCampos	+= 	"CN9.CN9_CONDPG, CN9.CN9_CODOBJ, CN9.CN9_CODCLA, CN9.CN9_TPCAUC, CN9.CN9_MINCAU, CN9.CN9_CODJUS, CN9.CN9_MOTPAR, CN9.CN9_NATURE, CN9.CN9_DESCRI, "
	cCampos += 	"CNA.CNA_NUMERO, CNA.CNA_TIPPLA, CNA.CNA_FORNEC, CNA.CNA_INDICE, CNA_PROXRJ, CNA.CNA_LJFORN, CNA.CNA_CLIENT, CNA.CNA_LOJACL, CNA.CNA_SALDO, " 
	cCampos +=	"CNA.CNA_VLTOT, CNA.CNA_MODORJ, CNA.CNA_UNPERI, CNA.CNA_PERI "	
	
	If lNewFields
		cCampos += ", CN9.CN9_GESTC, CN9.CN9_DEPART, CNA.CNA_DESCPL"
	EndIf
	
	cCampos := '%'+cCampos+'%'
	
	BEGINSQL Alias cAliasCN9
	
		SELECT 	%exp:cCampos%
		
		FROM 	%table:CN9% CN9
		
		INNER JOIN %table:CNA% CNA ON 	CNA.CNA_CONTRA = CN9.CN9_NUMERO AND
											CNA.CNA_REVISA = CN9.CN9_REVISA AND
											CNA.CNA_FILIAL = %xFilial:CNA% AND
											CNA.%NotDel%
		
		WHERE	CN9.CN9_NUMERO = 	%exp:oSelf:contractID% AND
				CN9.CN9_REVISA = 	%exp:oSelf:rev% AND
				CN9.CN9_FILIAL = 	%xFilial:CN9% AND
				CN9.%NotDel%
	
	ENDSQL
	
	If ( cAliasCN9 )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Detalhes do contrato
		//-------------------------------------------------------------------
		
		aTotais := WS300VlTot( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CN9_FILCTR , @lProjFlex )
		
		oJsonCtr['number']	:=	( cAliasCN9 )->CN9_NUMERO
		oJsonCtr['rev']	:=	( cAliasCN9 )->CN9_REVISA
		oJsonCtr['_type']	:=	( cAliasCN9 )->CN9_ESPCTR
		oJsonCtr['type_of_contract_id'] := ( cAliasCN9 )->CN9_TPCTO
		oJsonCtr['type_of_contract_description'] := Alltrim( EncodeUTF8( Posicione( 'CN1' , 1 , cFilCN1 + ( cAliasCN9 )->CN9_TPCTO , 'CN1_DESCRI' ) ) )
		oJsonCtr['startDate']	:=	( cAliasCN9 )->CN9_DTINIC
		oJsonCtr['endDate']	:= ( cAliasCN9 )->CN9_DTFIM
		oJsonCtr['coin'] := ( cAliasCN9 )->CN9_MOEDA
		oJsonCtr['payment_condition'] := ( cAliasCN9 )->CN9_CONDPG
		oJsonCtr['payment_condition_description'] := Alltrim( EncodeUTF8( Posicione( 'SE4' , 1 , xFilial('SE4') + ( cAliasCN9 )->CN9_CONDPG , "E4_DESCRI" ) ) )
		oJsonCtr['daysToFinish'] := If( dDataBase < STOD( ( cAliasCN9 )->CN9_DTFIM )  , DateDiffDay( dDataBase , STOD( ( cAliasCN9 )->CN9_DTFIM ) ) , 0 )
		oJsonCtr['description']	:= If( !Empty( ( cAliasCN9 )->CN9_DESCRI ), Alltrim( EncodeUTF8( ( cAliasCN9 )->CN9_DESCRI ) ) ,  Alltrim( EncodeUTF8( Posicione( 'CN1' , 1 , cFilCN1 + ( cAliasCN9 )->CN9_TPCTO , 'CN1_DESCRI' ) ) ) )
		oJsonCtr['contract_approval_id'] := ( cAliasCN9 )->CN9_APROV
		oJsonCtr['contract_approval_description'] :=  Alltrim( EncodeUTF8( Posicione( 'SAL' , 1 , xFilial('SAL') + ( cAliasCN9 )->CN9_APROV , "AL_DESC" ) ) )
		oJsonCtr['measurement_approval_id'] := ( cAliasCN9 )->CN9_GRPAPR
		oJsonCtr['measurement_approval_description'] :=  Alltrim( EncodeUTF8( Posicione( 'SAL' , 1 , xFilial('SAL') + ( cAliasCN9 )->CN9_GRPAPR , "AL_DESC" ) ) )
		oJsonCtr['bail_type'] := ( cAliasCN9 )->CN9_TPCAUC
		oJsonCtr['retention_percentage'] := ( cAliasCN9 )->CN9_MINCAU
		oJsonCtr['object'] := EncodeUTF8( MSMM( ( cAliasCN9 )->CN9_CODOBJ ) ) 
		oJsonCtr['clause'] := EncodeUTF8( MSMM( ( cAliasCN9 )->CN9_CODCLA ) ) 
		oJsonCtr['balance']	:= JsonObject():New() 
		oJsonCtr['balance']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
		oJsonCtr['balance']['total']	:= ( cAliasCN9 )->CN9_SALDO 
		oJsonCtr['current_value']	:= JsonObject():New() 
		oJsonCtr['current_value']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
		oJsonCtr['current_value']['total_fixed']	:= aTotais[1] 
		oJsonCtr['current_value']['total_flex']	:= aTotais[2]
		oJsonCtr['current_value']['sum_total'] := ( cAliasCN9 )->CN9_VLATU
		oJsonCtr['balanceHistory'] := JsonObject():New() 
		oJsonCtr['balanceHistory']['fixed'] := WS300HFix( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CN9_FILCTR , STOD( ( cAliasCN9 )->CN9_DTINIC ) )
		oJsonCtr['balanceHistory']['flex'] := WS300HFlex( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CN9_FILCTR , STOD( ( cAliasCN9 )->CN9_DTINIC ) )
		oJsonCtr['balanceHistory']['projection_flex']	:= lProjFlex
		oJsonCtr['class_id'] := ( cAliasCN9 )->CN9_NATURE
		oJsonCtr['class_description'] := Alltrim( EncodeUTF8( Posicione( 'SED' , 1 , xFilial('SED') + ( cAliasCN9 )->CN9_NATURE , "ED_DESCRIC" ) ) )
		
		If lNewFields
			oJsonCtr['manager_id']	:= ( cAliasCN9 )->CN9_GESTC
			oJsonCtr['manager_description']	:= Alltrim( EncodeUTF8( UsrFullName( ( cAliasCN9 )->CN9_GESTC ) ) )
			oJsonCtr['department_id'] :=  Alltrim( EncodeUTF8( ( cAliasCN9 )->CN9_DEPART ) )
			oJsonCtr['department_description'] := Alltrim( EncodeUTF8( Posicione( 'CXQ' , 1 , xFilial('CXQ') + ( cAliasCN9 )->CN9_DEPART , "CXQ_DESCRI" ) ) ) 
		EndIf
		
		//Campos especificos de uma revisao
		oJsonCtr['justification'] := EncodeUTF8( MSMM( ( cAliasCN9 )->CN9_CODJUS ) ) 
		oJsonCtr['end_stoppage'] := ( cAliasCN9 )->CN9_DTFIMP
		oJsonCtr['stoppage_id'] := ( cAliasCN9 )->CN9_MOTPAR
		oJsonCtr['stoppage_description'] := Alltrim( EncodeUTF8( Posicione( 'CN2' , 1 , xFilial('CN2') + ( cAliasCN9 )->CN9_MOTPAR , 'CN2_DESCRI' ) ) )
		
		oJsonCtr['documents'] := WS300Docs( ( cAliasCN9 )->CN9_NUMERO )
		
		If ( cAliasCN9 )->CN9_UNVIGE == '1'
			oJsonCtr['validity'] := Alltrim( Str( ( cAliasCN9 )->CN9_VIGE ) ) + ' ' + If( ( cAliasCN9 )->CN9_VIGE == 1 , STR0010 , STR0011 )
		ElseIf ( cAliasCN9 )->CN9_UNVIGE == '2'
			oJsonCtr['validity'] := Alltrim( Str( ( cAliasCN9 )->CN9_VIGE ) ) + ' ' + If( ( cAliasCN9 )->CN9_VIGE == 1 , STR0012 , STR0013 ) 
		ElseIf ( cAliasCN9 )->CN9_UNVIGE == '3'
			oJsonCtr['validity'] := Alltrim( Str( ( cAliasCN9 )->CN9_VIGE ) ) + ' ' + If( ( cAliasCN9 )->CN9_VIGE == 1 , STR0014 , STR0015 )
		ElseIf ( cAliasCN9 )->CN9_UNVIGE == '4'
			oJsonCtr['validity'] := Alltrim( Str( DateDiffDay( STOD( ( cAliasCN9 )->CN9_DTINIC ) , STOD( ( cAliasCN9 )->CN9_DTFIM ) ) ) ) + ' ' + STR0011 
		EndIf
		
		If ( cAliasCN9 )->CN9_UNVIGE == '4'
			oJsonCtr['validity_quant'] := DateDiffDay( STOD( ( cAliasCN9 )->CN9_DTINIC ) , STOD( ( cAliasCN9 )->CN9_DTFIM ) )
			oJsonCtr['validity_unity'] := '1'
		Else
			oJsonCtr['validity_quant'] := ( cAliasCN9 )->CN9_VIGE
			oJsonCtr['validity_unity'] := ( cAliasCN9 )->CN9_UNVIGE
		EndIf

		nDiasVenc := WS300Venc( ( cAliasCN9 )->CN9_TPCTO , ( cAliasCN9 )->CN9_FILIAL , STOD( ( cAliasCN9 )->CN9_DTFIM ) )
		
		If nDiasVenc >= -1
			oJsonCtr['expiresIn']	:= nDiasVenc
		Else
			oJsonCtr['expiresIn'] := Nil
		EndIf

		If Alltrim( (cAliasCN9)->CN9_SITUAC ) == '09' .And. ( Empty( (cAliasCN9)->CN9_APROV ) .OR. !ExistSCR2( 'RV', (cAliasCN9)->(CN9_NUMERO+CN9_REVISA) ) )
			oJsonCtr['situation'] := '09'
		ElseIf Alltrim( (cAliasCN9)->CN9_SITUAC ) == 'A' .Or. ( Alltrim( (cAliasCN9)->CN9_SITUAC ) == '09' .And. !Empty( (cAliasCN9)->CN9_APROV ) )
			oJsonCtr['situation'] := '12'
		Else
			oJsonCtr['situation'] := (cAliasCN9)->CN9_SITUAC
		EndIf
		
		//-------------------------------------------------------------------
		// Alimenta array de planilhas
		//-------------------------------------------------------------------
		While ( cAliasCN9 )->( ! Eof() ) 
			
			nAux++		
			
			aAdd( aListPlan , JsonObject():New() )
			
			aListPlan[nAux]['number'] := ( cAliasCN9 )->CNA_NUMERO
			aListPlan[nAux]['next_measurement'] := WS300NextM( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CNA_NUMERO )
			aListPlan[nAux]['index'] := Posicione( 'CN6' , 1 , cFilCN6 + ( cAliasCN9 )->CNA_INDICE , "CN6_DESCRI" )
			aListPlan[nAux]['index_id'] := ( cAliasCN9 )->CNA_INDICE
			aListPlan[nAux]['readjust_date'] := ( cAliasCN9 )->CNA_PROXRJ
			aListPlan[nAux]['type_id'] := ( cAliasCN9 )->CNA_TIPPLA
			aListPlan[nAux]['type_description'] := Alltrim( EncodeUTF8( Posicione( 'CNL' , 1 , cFilCNL + ( cAliasCN9 )->CNA_TIPPLA , 'CNL_DESCRI' ) ) )
			aListPlan[nAux]['readjust_mode'] := ( cAliasCN9 )->CNA_MODORJ
			aListPlan[nAux]['readjust_unit'] := ( cAliasCN9 )->CNA_UNPERI
			aListPlan[nAux]['readjust_frequency'] := ( cAliasCN9 )->CNA_PERI
			aListPlan[nAux]['editable'] := WS300AltPl( ( cAliasCN9 )->CNA_TIPPLA )
			
			If lNewFields
				If Empty( ( cAliasCN9 )->CNA_DESCPL )
					aListPlan[nAux]['description'] := Alltrim( EncodeUTF8( Posicione( 'CNL' , 1 , cFilCNL + ( cAliasCN9 )->CNA_TIPPLA , 'CNL_DESCRI' ) ) )
				Else
					aListPlan[nAux]['description'] := Alltrim( EncodeUTF8( ( cAliasCN9 )->CNA_DESCPL ) )
				EndIf
			EndIf
			
			If ( cAliasCN9 )->CN9_ESPCTR == '1'
				aListPlan[nAux]['related_id'] := ( cAliasCN9 )->CNA_FORNEC
				aListPlan[nAux]['related_unit'] := ( cAliasCN9 )->CNA_LJFORN
				aListPlan[nAux]['related_cnpj'] := Transform( Posicione( 'SA2' , 1 , cFilSA2 + ( cAliasCN9 )->CNA_FORNEC + ( cAliasCN9 )->CNA_LJFORN , 'A2_CGC' ) , X3Picture( 'A2_CGC' ) )
				aListPlan[nAux]['related'] := Alltrim( EncodeUTF8( Posicione( 'SA2' , 1 , cFilSA2 + ( cAliasCN9 )->CNA_FORNEC + ( cAliasCN9 )->CNA_LJFORN , 'A2_NOME' ) ) )
			Else
				aListPlan[nAux]['related_id'] := ( cAliasCN9 )->CNA_CLIENT
				aListPlan[nAux]['related_unit'] := ( cAliasCN9 )->CNA_LOJACL
				aListPlan[nAux]['related_cnpj'] := Transform( Posicione( 'SA2' , 1 , cFilSA2 + ( cAliasCN9 )->CNA_CLIENT + ( cAliasCN9 )->CNA_LOJACL , 'A2_CGC' ) , X3Picture( 'A2_CGC' ) )
				aListPlan[nAux]['related'] := Alltrim( EncodeUTF8( Posicione( 'SA1' , 1 , cFilSA1 + ( cAliasCN9 )->CNA_CLIENT + ( cAliasCN9 )->CNA_LOJACL , 'A1_NOME' ) ) )
			EndIf

			aListPlan[nAux]['balance'] := JsonObject():New() 
			aListPlan[nAux]['balance']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
			aListPlan[nAux]['balance']['total']	:= ( cAliasCN9 )->CNA_SALDO

			aListPlan[nAux]['current_value'] := JsonObject():New() 
			aListPlan[nAux]['current_value']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
			aListPlan[nAux]['current_value']['total'] := ( cAliasCN9 )->CNA_VLTOT

			aListPlan[nAux]['itens'] := WS300Item( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CNA_NUMERO , ( cAliasCN9 )->CN9_MOEDA )
			
			If oSelf:schedule
				aListPlan[nAux]['schedule'] := WS300Cron( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CNA_NUMERO , ( cAliasCN9 )->CN9_MOEDA )
			EndIf
			
			( cAliasCN9 )->( DBSkip() )
			
		End
		
		oJsonCtr['spreadsheets'] := aListPlan

	EndIf
	
	( cAliasCN9 )->( DBCloseArea() )
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCtr:= FwJsonSerialize( oJsonCtr )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCtr)
	
	oSelf:SetResponse( cJsonCtr ) //-- Seta resposta

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET /contracts/contractID/rev/spreadsheets/spreadSheetNumber/balances
Retorna os valores previstos e realizados da planilha

@param	contractID		, caracter, numero do contrato 
		rev				, caracter, numero da revisao
		spreadSheetNumber	, caracter	, numero da planilha

@return cResponse		, caracter, JSON contendo a previsao financeira da planilha

@author	jose.delmondes
@since		18/01/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET balanceDt PATHPARAM contractID, rev, spreadSheetNumber WSREST WSCNTA300
	
	Local lRet	:= .T.
	
	lRet:= balanceDt( self )

Return( lRet )

WSMETHOD GET 1balanceDt PATHPARAM contractID, rev, spreadSheetNumber WSREST WSCNTA300
	
	Local lRet	:= .T.
	
	lRet:= balanceDt( self )

Return( lRet )

Static Function balanceDt( oSelf )

	Local aCompet	:= {}
	
	Local cAliasCNF	:= GetNextAlias()
	Local cJsonBal	:= ''
	Local cCompet	:= ''
	Local cDataBase	:= ''
	Local cDataAux	:= ''
	
	Local dDataAux	:= CTOD( ' ' )
	
	Local lRet		:= .T.
	Local lMedeve	:= CN300RetSt( 'MEDEVE' , 0 , oSelf:spreadSheetNumber , oSelf:contractID , , .F. )
	
	Local nValPrev	:= 0
	Local nValReal	:= 0
	
	Local oJsonBal	:= JsonObject():New() 
	
	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(oSelf:rev) == 0
		oSelf:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf
	
	If lMedeve		//-- Planilha sem cronograma financeiro
		
		DBSelectArea('CNA')
		
		CNA->( DBSetOrder(1) ) 
		
		If CNA->( DBSeek( xFilial('CNA') + oSelf:contractID + oSelf:rev + oSelf:spreadSheetNumber ) )
			
			nValPrev	:= CNA->CNA_VLTOT / ( DateDiffMonth( CNA->CNA_DTINI , CNA->CNA_DTFIM ) + 1 )
			
			dDataAux	:= CNA->CNA_DTINI 
				
			//-------------------------------------------------------------------
			// Preenche array de competencias ate a database
			//-------------------------------------------------------------------
			While ( dDataAux <= LastDate( dDatabase  ) )
				
				cCompet	:= Year2Str( dDataAux ) + Month2Str( dDataAux ) //-- competencia no formato yyyyaa
				nValReal	:= WS300VReal( CNA->CNA_CONTRA , CNA->CNA_REVISA , cFilAnt , cCompet , .F. , CNA->CNA_NUMERO )	//-- valore realizado da competencia
		
				aADD( aCompet , { cCompet , nValPrev , nValReal } )
				
				dDataAux := MonthSum( dDataAux , 1 )
			
			End
			
		EndIf
		
	Else	//-- Planilha com cronograma financeiro
	
		//-------------------------------------------------------------------
		// Query para selecionar as parcelas do cronograma
		//-------------------------------------------------------------------
		BEGINSQL Alias cAliasCNF
			
			SELECT	CNF.CNF_COMPET, CNF.CNF_VLPREV, CNF.CNF_VLREAL
			
			FROM	%table:CNF% CNF
			
			WHERE	CNF.CNF_CONTRA = 	%exp:oSelf:contractID% AND
					CNF.CNF_REVISA = 	%exp:oSelf:rev% AND
					CNF.CNF_NUMPLA = 	%exp:oSelf:spreadSheetNumber% AND
					CNF.CNF_FILIAL = 	%xFilial:CNF% AND
					CNF.%NotDel%
			
		ENDSQL	
	
		//-------------------------------------------------------------------
		// preenche array de competencias ate a database
		//-------------------------------------------------------------------
		While ( cAliasCNF )->( ! Eof() ) 
		
			dDataAux := CTOD( '01/' + ( cAliasCNF )->CNF_COMPET )
			
			If dDataAux <= dDataBase
				
				cCompet	:= Right( Alltrim( ( cAliasCNF )->CNF_COMPET ) , 4 ) + Left( Alltrim( ( cAliasCNF )->CNF_COMPET ) , 2 ) //-- competencia no formato yyyyaa
				nValPrev	:= ( cAliasCNF )->CNF_VLPREV	//-- valor previsto da competencia
				nValReal	:= ( cAliasCNF )->CNF_VLREAL 	//-- valore realizado da competencia
		
				aADD( aCompet , { cCompet , nValPrev , nValReal } )
			
			EndIf
			
			( cAliasCNF )->( DBSkip( ) )
		
		End
		
		( cAliasCNF )->( DBCloseArea( ) )
	EndIf
	
	//-------------------------------------------------------------------
	// alimenta objeto json com array de competencias
	//-------------------------------------------------------------------
	oJsonBal['competences'] := aCompet
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonBal:= FwJsonSerialize( oJsonBal )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonBal )
	
	//-------------------------------------------------------------------
	// Seta Resposta
	//-------------------------------------------------------------------
	oSelf:SetResponse( cJsonBal ) 

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET /contracts/total
Retorna a quantidade total de contratos com um determinado status

@param	status	, caracter ,	status do contrato:
								0 - Todos os contratos (Valor default);
								1 - Contratos vigentes;
								2 - Contratos em elaboração;
								3 - Contratos aguardando aprovação;
								4 - Contratos paralisados;
								5 - Contratos em reajuste;
								6 - Contratos vencidos;
								7 - Contratos a vencer;

@return cResponse		, caracter, JSON contendo a quantidade total de contratos

@author	jose.delmondes
@since		08/08/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET totalCtr WSRECEIVE status WSREST WSCNTA300

	Local lRet		:= .T.
	
	lRet := totalCtr( self )

Return( lRet )

WSMETHOD GET 1totalCtr WSRECEIVE status WSREST WSCNTA300

	Local lRet		:= .T.
	
	lRet := totalCtr( self )

Return( lRet )

Static Function totalCtr( oSelf )

	Local lRet		:= .T.
	
	Local aGrupos	:= {}

	Local cAliasCN9	:= GetNextAlias()	
	Local cSituac	:= ''
	Local cDataBase	:= ''
	Local cDataAux	:= ''
	Local cJsonCtr  := ''
	Local cCodUsr	:= __cUserId
	Local cGrupos	:= ''
	Local cQuery	:= ''
	Local cQuery1	:= ''
	Local cQuery2	:= ''
	Local cQuery3	:= ''
	Local cQuery4 	:= ''
	Local cQuery5	:= ''
	
	Local nDiasKPIV	:= SuperGetMV( 'MV_GCTKPIV' , .F. , 30 )
	Local nDiasKPIR	:= SuperGetMV( 'MV_GCTKPIR' , .F. , 0 )
	Local nTotal	:= 0
	Local nX		:= 0

	Local oJsonCtr	:= JsonObject():New() 

	Default oSelf:status := 0

	aGrupos := UsrRetGrp( UsrRetName( cCodUsr ) )

	For nX := 1 to len( aGrupos )
		cGrupos += "'" + aGrupos[nX] + "',"
	Next
	
	cGrupos := SubStr( cGrupos , 1 , len( cGrupos ) -1 )

	//-- Filtro de permissao ( Controle Total ou Visualizacao do Contrato)
	cQuery2 += "INNER JOIN " +RetSQLName("CNN") + " CNN ON "
	cQuery2 += "CNN.CNN_FILIAL = '" + xFilial("CNN") + "' AND "
	cQuery2 += "CNN.CNN_CONTRA = CN9.CN9_NUMERO AND "
	
	If Empty(cGrupos)
		cQuery2 += "CNN.CNN_USRCOD = '" + cCodUsr + "' AND "
	Else	
		cQuery2 += "( CNN.CNN_USRCOD = '" + cCodUsr + "' OR CNN.CNN_GRPCOD IN ("+ cGrupos +") ) AND "
	EndIf
	
	cQuery2 += "CNN.CNN_TRACOD IN ( '001' , '037' )  AND "
	cQuery2 += "CNN.D_E_L_E_T_ = ' ' "

	cQuery4 += " AND CN9_VLDCTR IN( ' ' , '1' ) "

	cQuery5 += " AND CN9_VLDCTR = '2' "
	
	Do Case

		Case oSelf:status == 0	//-- Todos os contratos
			
			cQuery1 += "SELECT 	COUNT( DISTINCT CN9_NUMERO ) TOTAL "
			cQuery1 += "FROM " + RetSQLName("CN9") + " CN9 "

			cQuery3 += "WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
			cQuery3 += "CN9.D_E_L_E_T_ = ' ' "

			cQuery += cQuery1 + cQuery2 + cQuery3 + cQuery4 + " UNION " + cQuery1 + cQuery3 + cQuery5

			cQuery := ChangeQuery(cQuery)
	
			dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasCN9,.F.,.T.)

			While ( cAliasCN9 )->( !Eof() )  
			
				nTotal += (cAliasCN9)->TOTAL
				( cAliasCN9 )->( DBSkip() )
			
			End

			(cAliasCN9)->(dbCloseArea())
			
		Case oSelf:status > 0 .And. oSelf:status <= 4

			Do Case
				Case oSelf:status == 1	//-- Contratos Vigentes
					cSituac := '05'		
				Case oSelf:status == 2	//-- Contratos em elaboração
					cSituac := '02'
				Case oSelf:status == 3	//-- Contratos em aprovacao
					cSituac := '04'
				Case oSelf:status == 4	//-- Contratos paralisados
					cSituac := '06'
			End Case

			cQuery1 += "SELECT 	COUNT( DISTINCT CN9_NUMERO ) TOTAL "
			cQuery1 += "FROM " + RetSQLName("CN9") + " CN9 "

			cQuery3 += "WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
			cquery3 += "CN9.CN9_SITUAC = '" + cSituac + "' AND "
			cQuery3 += "CN9.D_E_L_E_T_ = ' ' "

			cQuery += cQuery1 + cQuery2 + cQuery3 + cQuery4 + " UNION " + cQuery1 + cQuery3 + cQuery5

			cQuery := ChangeQuery(cQuery)
	
			dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasCN9,.F.,.T.)

			While ( cAliasCN9 )->( !Eof() )  
			
				nTotal += (cAliasCN9)->TOTAL
				( cAliasCN9 )->( DBSkip() )
			
			End

			(cAliasCN9)->(dbCloseArea())

		Case oSelf:status == 5	//-- Contratos em reajuste

			cDataBase := DtoS( dDataBase + nDiasKPIR )

			cQuery1 += "SELECT 	COUNT( DISTINCT CN9_NUMERO ) TOTAL "
			cQuery1 += "FROM " + RetSQLName("CN9") + " CN9 "

			cQuery1 += "INNER JOIN " + RetSQLName("CNA") + " CNA ON "
			cQuery1 += "CNA.CNA_FILIAL = CN9.CN9_FILIAL AND "
			cQuery1 += "CNA.CNA_CONTRA = CN9.CN9_NUMERO AND "
			cQuery1 += "CNA.CNA_REVISA = CN9.CN9_REVISA AND "
			cQuery1 += "CNA.CNA_PROXRJ < '" + cDataBase + "' AND "
			cQuery1 += "CNA.CNA_PROXRJ <> '" + Space(TAMSX3("CNA_PROXRJ")[1]) + "' AND "
			cQuery1 += "CNA.D_E_L_E_T_ = ' ' "

			cQuery3 += "WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
			cquery3 += "CN9.CN9_SITUAC = '05' AND "
			cQuery3 += "CN9.D_E_L_E_T_ = ' ' "

			cQuery += cQuery1 + cQuery2 + cQuery3 + cQuery4 + " UNION " + cQuery1 + cQuery3 + cQuery5

			cQuery := ChangeQuery(cQuery)
	
			dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasCN9,.F.,.T.)

			While ( cAliasCN9 )->( !Eof() )  
			
				nTotal += (cAliasCN9)->TOTAL
				( cAliasCN9 )->( DBSkip() )
			
			End

			(cAliasCN9)->(dbCloseArea())

		Case oSelf:status == 6 	//-- Contratos vencidos

			cDataBase := DtoS( dDataBase )

			cQuery1 += "SELECT 	COUNT( CN9_NUMERO ) TOTAL "
			cQuery1 += "FROM " + RetSQLName("CN9") + " CN9 "

			cQuery3 += "WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
			cQuery3 += "CN9.CN9_DTFIM < '" + cDataBase + "' AND "
			cquery3 += "CN9.CN9_SITUAC = '05' AND "
			cQuery3 += "CN9.D_E_L_E_T_ = ' ' "

			cQuery += cQuery1 + cQuery2 + cQuery3 + cQuery4 + " UNION " + cQuery1 + cQuery3 + cQuery5

			cQuery := ChangeQuery(cQuery)
	
			dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasCN9,.F.,.T.)

			While ( cAliasCN9 )->( !Eof() )  
			
				nTotal += (cAliasCN9)->TOTAL
				( cAliasCN9 )->( DBSkip() )
			
			End

			(cAliasCN9)->(dbCloseArea())

		Case oSelf:status == 7 //-- Contratos a vencer em 30 dias

			cDataAux :=  DtoS( dDataBase + nDiasKPIV )

			cDataBase := DtoS( dDataBase )

			cQuery1 += "SELECT 	COUNT( CN9_NUMERO ) TOTAL "
			cQuery1 += "FROM " + RetSQLName("CN9") + " CN9 "

			cQuery3 += "WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
			cQuery3 += "CN9.CN9_DTFIM >= '" + cDataBase + "' AND "
			cQuery3 += "CN9.CN9_DTFIM < '" + cDataAux + "' AND "
			cquery3 += "CN9.CN9_SITUAC = '05' AND "
			cQuery3 += "CN9.D_E_L_E_T_ = ' ' "

			cQuery += cQuery1 + cQuery2 + cQuery3 + cQuery4 + " UNION " + cQuery1 + cQuery3 + cQuery5

			cQuery := ChangeQuery(cQuery)
	
			dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasCN9,.F.,.T.)

			While ( cAliasCN9 )->( !Eof() )  
			
				nTotal += (cAliasCN9)->TOTAL
				( cAliasCN9 )->( DBSkip() )
			
			End

			(cAliasCN9)->(dbCloseArea())

	EndCase

	//-------------------------------------------------------------------
	// Quantidade total de contratos
	//-------------------------------------------------------------------
	oJsonCtr['total'] := nTotal

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCtr:= FwJsonSerialize( oJsonCtr )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonCtr )
	
	//-------------------------------------------------------------------
	// Seta Resposta
	//-------------------------------------------------------------------
	oSelf:SetResponse( cJsonCtr ) 

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET /contracts/contractID/rev/forecast
Retorna a projecao financeira para os proximos 6 meses

@param	contractID		, caracter, numero do contrato 
		rev				, caracter, numero da revisao

@return cResponse		, caracter, JSON contendo a projecao financeira

@author	jose.delmondes
@since		18/01/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET forecast PATHPARAM contractID, rev WSREST WSCNTA300

	Local lRet	:= .T.
	
	lRet :=  forecast ( self )

Return( lRet )

WSMETHOD GET 1forecast PATHPARAM contractID, rev WSREST WSCNTA300

	Local lRet	:= .T.
	
	lRet :=  forecast ( self )

Return( lRet )

Static Function forecast ( oSelf )

	Local aCompet	:= {}
	
	Local cAliasQRY	:= GetNextAlias()
	Local cJsonCtr  := ''
	Local cFilCtr	:= ''
	Local cCompet	:= ''
	Local cCompet2	:= ''

	Local dDataIni	:= dDatabase
	Local dDataFim 	:= MonthSum( dDataIni , 6 )
	Local dDataAnt	:= MonthSub( dDataIni , 6 )

	Local lRet	:= .T.

	Local nProjFix	:= 0
	Local nProjFlex	:= 0
	Local nValReal	:= 0

	Local oJsonCtr	:= JsonObject():New() 

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(oSelf:rev) == 0
		oSelf:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf

	//-------------------------------------------------------------------
	// Query para obter o valor atual e o saldo do contrato
	//-------------------------------------------------------------------
	BeginSQL Alias cAliasQRY
	
		SELECT 	CN9_SALDO, CN9_VLATU, CN9_MOEDA, CN9_FILCTR
		FROM	%Table:CN9% CN9
		WHERE	CN9.CN9_NUMERO = %exp:oSelf:contractID% AND
				CN9.CN9_REVISA = %exp:oSelf:rev% AND
				CN9.CN9_FILIAL = %xFilial:CN9% AND
				CN9.%NotDel%

	EndSQL

	cFilCtr := ( cAliasQRY )->CN9_FILCTR

	oJsonCtr['balance'] := JsonObject():New()
	oJsonCtr['balance']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasQRY )->CN9_MOEDA ) , , "" )
	oJsonCtr['balance']['total'] := ( cAliasQRY )->CN9_SALDO 

	oJsonCtr['current_value'] := JsonObject():New()
	oJsonCtr['current_value']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasQRY )->CN9_MOEDA ) , , "" )
	oJsonCtr['current_value']['total'] := ( cAliasQRY )->CN9_VLATU

	( cAliasQRY )->( dbCloseArea() )

	//--------------------------------------------------------------------------
	// contabiliza medicoes realizadas nos ultimos seis meses (sem cronograma)
	//--------------------------------------------------------------------------
	While dDataAnt  < FirstDate( dDataBase )
		cCompet		:= Year2Str( dDataAnt ) + Month2Str( dDataAnt )										//-- competencia no formato YYYYMM
		nValReal	+= WS300VReal( oSelf:contractID, oSelf:rev, cFilCtr, cCompet, .F. )		//-- valor realizado
		dDataAnt 	:= MonthSum( dDataAnt , 1 )															//- vai para o proximo mes
	End

	//--------------------------------------------------------------------------
	// Projecao Flex eh a media do valor (flex) medido nos ultimos 6 meses 
	//--------------------------------------------------------------------------
	nProjFlex := nValReal / 6

	//--------------------------------------------------------------------------
	// Monta array com a projecao dos proximos 6 meses
	//--------------------------------------------------------------------------
	While dDataIni <= LastDate( dDataFim )
		cCompet		:= Year2Str( dDataIni ) + Month2Str( dDataIni )			//-- competencia no formato YYYYMM
		cCompet2	:= Month2Str( dDataIni ) + '/' + Year2Str( dDataIni ) 	//-- competencia no formato MM/YYYY
		nProjFix	:= WS300VPFix( oSelf:contractID, oSelf:rev, cCompet2 )	//-- valor previsto

		AADD( aCompet , { cCompet, nProjFix + nProjFlex } )					//-- competencia, valor projetado
			
		dDataIni := MonthSum( dDataIni , 1 )								//- vai para o proximo mes
	End

	oJsonCtr['forecast'] :=  aCompet

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCtr:= FwJsonSerialize( oJsonCtr )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonCtr )
	
	//-------------------------------------------------------------------
	// Seta Resposta
	//-------------------------------------------------------------------
	oSelf:SetResponse( cJsonCtr ) 

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET /contracts/contractID/rev/spreadsheets/spreadsheetNumber/schedule
Retorna as parcelas do cronograma financeiro

@param	contractID		, caracter, numero do contrato 
@param	rev				, caracter, numero da revisao
@param	spreadsheetNumber, caracter, numero da planilha

@return cResponse		, caracter, JSON contendo as parcelas do cronograma financeiro

@author		jose.delmondes
@since		19/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET schedule PATHPARAM contractID, rev, spreadsheetNumber WSRECEIVE searchKey, page, pageSize  WSREST WSCNTA300

	Local aSchedule	:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonSched	:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CNF.CNF_FILIAL = '"+xFilial('CNF')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonSched	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(Self:rev) == 0
		Self:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		cWhere  += " AND ( CNF.CNF_PARCEL LIKE '%"	+ cSearch + "%' OR "
		cWhere	+= " CNF.CNF_COMPET LIKE '%" + cSearch + "%' ) " 
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar as parcelas do cronograma
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CNF.CNF_PARCEL, CNF.CNF_COMPET, CNF.CNF_PRUMED, CNF.CNF_DTREAL, 
				CNF.CNF_VLPREV, CNF.CNF_SALDO, CN9.CN9_MOEDA
		
		FROM 	%table:CNF% CNF

		INNER JOIN %table:CN9% CN9 ON 	CN9.CN9_NUMERO = CNF.CNF_CONTRA AND
										CN9.CN9_REVISA = CNF.CNF_REVISA  AND
										CN9.CN9_FILIAL = CNF.CNF_FILIAL AND
										CN9.%NotDel%
		
		WHERE 	CNF.CNF_CONTRA = %exp:self:contractID% AND
				CNF.CNF_REVISA = %exp:self:rev% AND
				CNF.CNF_NUMPLA = %exp:self:spreadSheetNumber% AND
				CNF.%NotDel%
				%exp:cWhere%
		
		ORDER BY CNF_PARCEL
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonSched['hasNext'] := .T.
		Else
			oJsonSched['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonSched['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aSchedule , JsonObject():New() )
			
			aSchedule[nAux]['parcel']	:= ( cAliasQry )->CNF_PARCEL
			aSchedule[nAux]['competence']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CNF_COMPET ) )
			aSchedule[nAux]['forecastDate']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CNF_PRUMED ) )
			aSchedule[nAux]['executionDate'] := Alltrim( EncodeUTF8( ( cAliasQry )->CNF_DTREAL) )

			aSchedule[nAux]['balance'] := JsonObject():New()
			aSchedule[nAux]['balance']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasQRY )->CN9_MOEDA ) , , "" )
			aSchedule[nAux]['balance']['total'] := ( cAliasQRY )->CNF_SALDO

			aSchedule[nAux]['forecastValue'] := JsonObject():New()
			aSchedule[nAux]['forecastValue']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasQRY )->CN9_MOEDA ) , , "" )
			aSchedule[nAux]['forecastValue']['total'] := ( cAliasQRY )->CNF_VLPREV

			If Empty( ( cAliasQry )->CNF_DTREAL )
				aSchedule[nAux]['status'] := '1'
			ElseIf ( cAliasQRY )->CNF_SALDO > 0 
				aSchedule[nAux]['status'] := '2'
			Else
				aSchedule[nAux]['status'] := '3'
			EndIf
			
			If Len(aSchedule) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonSched['parcels'] := aSchedule
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonSched:= FwJsonSerialize( oJsonSched )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonSched)
	
	Self:SetResponse( cJsonSched ) //-- Seta resposta


Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / indexes
Retorna a lista de indices de reajuste.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo a lista de indices

@author		jose.delmondes
@since		01/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET indexes WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300
	
	Local aListIndex	:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonIndex	:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CN6.CN6_FILIAL = '"+xFilial('CN6')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonIndex	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId		:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId
			cWhere  += " AND CN6.CN6_CODIGO = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CN6.CN6_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CN6.CN6_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " CN6.CN6_DESCRI LIKE '%" + cSearch + "%' ) "
		EndIf
	EndIf
	
	dbSelectArea('CN6')
	If CN6->( Columnpos('CN6_MSBLQL') > 0 )
		cWhere += " AND CN6.CN6_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar indices de reajuste
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CN6.CN6_CODIGO, CN6.CN6_DESCRI
		FROM 	%table:CN6% CN6
		WHERE 	CN6.%NotDel%
		%exp:cWhere%
		ORDER BY CN6_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonIndex['hasNext'] := .T.
		Else
			oJsonIndex['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonIndex['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aListIndex , JsonObject():New() )
			
			aListIndex[nAux]['id']	:= ( cAliasQry )->CN6_CODIGO
			aListIndex[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CN6_DESCRI ) )
			
			If Len(aListIndex) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonIndex['indexes'] := aListIndex
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonIndex:= FwJsonSerialize( oJsonIndex )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonIndex)
	
	Self:SetResponse( cJsonIndex ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / products
Retorna a lista de produtos.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo a lista de produtos

@author		jose.delmondes
@since		01/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET products WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300
	
	Local aListProd		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonProd		:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND SB1.B1_FILIAL = '"+xFilial('SB1')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonProd	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20
	Default self:byId	:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId	
			cWhere  += " AND SB1.B1_COD = '" + cSearch + "'"
		Else
			cWhere  += " AND ( SB1.B1_COD LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " SB1.B1_DESC LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " SB1.B1_DESC LIKE '%" + cSearch + "%' ) " 
		EndIf
	EndIf
	
	dbSelectArea('SB1')
	If SB1->( Columnpos('B1_MSBLQL') > 0 )
		cWhere += " AND SB1.B1_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar produtos
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	SB1.B1_COD, SB1.B1_DESC
		FROM 	%table:SB1% SB1
		WHERE 	SB1.%NotDel%
		%exp:cWhere%
		ORDER BY B1_COD
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonProd['hasNext'] := .T.
		Else
			oJsonProd['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonProd['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aListProd , JsonObject():New() )
			
			aListProd[nAux]['id']	:= ( cAliasQry )->B1_COD
			aListProd[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->B1_DESC ) )
			
			If Len(aListProd) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonProd['products'] := aListProd
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonProd:= FwJsonSerialize( oJsonProd )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonProd)
	
	Self:SetResponse( cJsonProd ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300Venc( cPeriod )
Retorna a quantidade de dias restantes para expiracao do contrato

@param		cTipCto		, caracter	, tipo do contrato
			cFilCtr		, caracter	, filial do contrato
			dDtFim		, data		, data final do contrato

@return 	nDias 		, numerico	, quantidade de dias para o vencimento do contrato

@author	jose.delmondes
@since		11/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300Venc( cTipCto , cFilCtr , dDtFim )

	Local nDias		:= -2
	Local nDiffDay	:= 0
	Local aDatas	:= {}
	
	
	If dDataBase > dDtFim 	
		
		//-------------------------------------------------------------------
		// Contrato Vencido
		//-------------------------------------------------------------------
		nDias := -1
	
	ElseIf dDataBase == dDtFim 	
		
		//-------------------------------------------------------------------
		// Contrato Vence na database
		//-------------------------------------------------------------------
		nDias := 0
	
	Else 
	
		//-------------------------------------------------------------------
		// Verifica a configuracao de alerta de vencimento	
		//-------------------------------------------------------------------
		aDatas	:= ASORT( CtaDtAviso( cTipCto ,cFilCtr ) )	
		
		If !Empty(aDatas)
			
			nDiffDay := DateDiffDay( dDataBase , dDtFim )
			
			If nDiffDay  <= aDatas[len(aDatas)]
				nDias := nDiffDay
			EndIf
			
		EndIf
		
	EndIf

Return nDias

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300HFix( cContra , cRevisa , cFilCtr , dDataIni )
Retorna historico de valores previsto e realizado de cada competencia

@param		cContra		, caracter	, numero do contrato
			cRev		, caracter	, revisao do contrato
			cFilCtr		, caracter	, filial do contrato
			dDataIni	, data		, data inicial do contrato

@return 	aCompet 	, array		, valor previsto e realizado de cada competencia

@author	jose.delmondes
@since		11/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300HFix( cContra , cRev , cFilCtr , dDataIni )
	
	Local aCompet	:= {}
	Local aArea		:= GetArea()
	
	Local cAliasCNF	:= GetNextAlias()
	Local cCompet	:= ''
	Local cCompet2	:= ''	
	
	//-------------------------------------------------------------------
	// Verifica se o contrato possui cronograma financeiro
	//-------------------------------------------------------------------
	BeginSQL Alias cAliasCNF
	
		SELECT	CNF_NUMERO
		
		FROM 	%table:CNF% CNF
		
		WHERE 	CNF.CNF_CONTRA = %exp:cContra% AND
				CNF.CNF_REVISA = %exp:cRev% AND
				CNF.CNF_FILIAL = %xFilial:CNF% AND
				CNF.%NotDel%
	EndSQL
	
	If ( cAliasCNF )->( ! Eof() )
		
		While dDataIni <= LastDate( dDataBase )
			cCompet	:= Month2Str( dDataIni ) + '/' + Year2Str( dDataIni ) 	//-- competencia no formato MM/YYYY
			cCompet2	:= Year2Str( dDataIni ) + Month2Str( dDataIni )			//-- competencia no formato YYYYMM
			nValPrev	:= WS300VPFix( cContra, cRev, cCompet )					//-- valor previsto
			nValRel	:= WS300VReal( cContra, cRev, cFilCtr, cCompet2 , .T. )	//-- valor realizado

			AADD( aCompet , { cCompet2, nValPrev, nValRel })	//-- competencia, valor previsto, valor realizado
			
			dDataIni := MonthSum( dDataIni , 1 )	//- vai para o proximo mes
		End
		
	EndIf
	
	( cAliasCNF )->( DBCloseArea() )
	
	RestArea( aArea )
	
	If Empty( aCompet )
		Return Nil
	EndIf

Return aCompet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / costCenters
Retorna a lista de centros de custo.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo a lista de centros de custo

@author		lucas.celestino
@since		01/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET costCenter WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aListCost		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonCost		:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CTT.CTT_FILIAL = '"+xFilial('CTT')+"' AND CTT.CTT_CLASSE = '2' AND CTT.CTT_BLOQ = '2' "
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonCost	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20
	Default self:byId	:= .F.	
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId	
			cWhere  += " AND CTT.CTT_CUSTO = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CTT.CTT_CUSTO LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CTT.CTT_DESC01 LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " CTT.CTT_DESC01 LIKE '%" + cSearch + "%' ) " 
		EndIf
	EndIf
	
	dbSelectArea('CTT')
	If CTT->( Columnpos('CTT_MSBLQL') > 0 )
		cWhere += " AND CTT.CTT_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar centros de custo
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CTT.CTT_CUSTO, CTT.CTT_DESC01
		FROM 	%table:CTT% CTT
		WHERE 	CTT.%NotDel%
		%exp:cWhere%
		ORDER BY CTT_CUSTO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonCost['hasNext'] := .T.
		Else
			oJsonCost['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonCost['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de centros de custo
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListCost , JsonObject():New() )
			
			aListCost[nAux]['id'] := ( cAliasQry )->CTT_CUSTO
			aListCost[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CTT_DESC01 ) )
			
			If Len(aListCost) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonCost['costCenters'] := aListCost
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCost:= FwJsonSerialize( oJsonCost )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCost)
	
	Self:SetResponse( cJsonCost ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / financial Account
Retorna a lista de contas contábeis.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo a lista de centros de custo

@author		lucas.celestino
@since		02/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET accAccount WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aListCost		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonCost		:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CT1.CT1_FILIAL = '"+xFilial('CT1')+"' AND CT1.CT1_CLASSE = '2' AND CT1.CT1_BLOQ = '2' "
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonCost	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId	:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId	
			cWhere  += " AND CT1.CT1_CONTA = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CT1.CT1_CONTA LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CT1.CT1_DESC01 LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " CT1.CT1_DESC01 LIKE '%" + cSearch + "%' ) " 
		EndIf
	EndIf
	
	dbSelectArea('CT1')
	If CT1->( Columnpos('CT1_MSBLQL') > 0 )
		cWhere += " AND CT1.CT1_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar contas contábeis
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CT1.CT1_CONTA, CT1.CT1_DESC01
		FROM 	%table:CT1% CT1			
		WHERE 	CT1.%NotDel%
		%exp:cWhere%
		ORDER BY CT1_CONTA
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonCost['hasNext'] := .T.
		Else
			oJsonCost['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonCost['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de contas contábeis
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListCost , JsonObject():New() )
			
			aListCost[nAux]['id']	:= ( cAliasQry )->CT1_CONTA
			aListCost[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CT1_DESC01 ) )
			
			If Len(aListCost) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonCost['financialAccounts'] := aListCost
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCost:= FwJsonSerialize( oJsonCost )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCost)
	
	Self:SetResponse( cJsonCost ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / accountingItems
Retorna a lista de items contábeis.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo a lista de centros de custo

@author		lucas.celestino
@since		02/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET accItems WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aListCost		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonCost		:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CTD.CTD_FILIAL = '"+xFilial('CTD')+"' AND CTD.CTD_CLASSE = '2' AND CTD.CTD_BLOQ = '2'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonCost	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId	:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId	
			cWhere  += " AND CTD.CTD_ITEM = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CTD.CTD_ITEM LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CTD.CTD_DESC01 LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " CTD.CTD_DESC01 LIKE '%" + cSearch + "%' ) " 
		EndIf
	EndIf
	
	dbSelectArea('CTD')
	If CTD->( Columnpos('CTD_MSBLQL') > 0 )
		cWhere += " AND CTD.CTD_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar items contábeis
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CTD.CTD_ITEM, CTD.CTD_DESC01
		FROM 	%table:CTD% CTD
		WHERE 	CTD.%NotDel%
		%exp:cWhere%
		ORDER BY CTD_ITEM
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonCost['hasNext'] := .T.
		Else
			oJsonCost['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonCost['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de items contábeis
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListCost , JsonObject():New() )
			
			aListCost[nAux]['id']	:= ( cAliasQry )->CTD_ITEM
			aListCost[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CTD_DESC01 ) )
			
			If Len(aListCost) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonCost['accountingItems'] := aListCost
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCost:= FwJsonSerialize( oJsonCost )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCost)
	
	Self:SetResponse( cJsonCost ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / valueClasses
Retorna a lista de classes de valor.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo a lista de classes de valor

@author		lucas.celestino
@since		02/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET valueClass WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aListCost		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonCost		:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CTH.CTH_FILIAL = '"+xFilial('CTH')+"' AND CTH.CTH_CLASSE = '2' AND CTH.CTH_BLOQ = '2' "
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonCost	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId	:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId	
			cWhere  += " AND CTH.CTH_CLVL = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CTH.CTH_CLVL LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CTH.CTH_DESC01 LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " CTH.CTH_DESC01 LIKE '%" + cSearch + "%' ) " 
		EndIf
	EndIf
	
	dbSelectArea('CTH')
	If CTH->( Columnpos('CTH_MSBLQL') > 0 )
		cWhere += " AND CTH.CTH_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar classes de valor
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CTH.CTH_CLVL, CTH.CTH_DESC01
		FROM 	%table:CTH% CTH
		WHERE 	CTH.%NotDel%
		%exp:cWhere%
		ORDER BY CTH_CLVL
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonCost['hasNext'] := .T.
		Else
			oJsonCost['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonCost['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de classes de valor
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListCost , JsonObject():New() )
			
			aListCost[nAux]['id']	:= ( cAliasQry )->CTH_CLVL
			aListCost[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CTH_DESC01 ) )
			
			If Len(aListCost) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonCost['valueClasses'] := aListCost
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCost:= FwJsonSerialize( oJsonCost )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCost)
	
	Self:SetResponse( cJsonCost ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / payments
Retorna a lista de condições de pagamento.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo a lista de condiï¿½ï¿½es de pagamento

@author		jose.delmondes
@since		01/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET payments WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aListPay		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonPay		:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND SE4.E4_FILIAL = '"+xFilial('SE4')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonPay	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId		:=.F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId
			cWhere  += " AND SE4.E4_CODIGO = '"	+ cSearch + "'"
		Else
			cWhere  += " AND ( SE4.E4_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere  += " SE4.E4_DESCRI LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " SE4.E4_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%')"
		EndIf
	EndIf
	
	dbSelectArea('SE4')
	If SE4->( Columnpos('E4_MSBLQL') > 0 )
		cWhere += " AND SE4.E4_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar condições de pagamento
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	SE4.E4_CODIGO, SE4.E4_DESCRI
		FROM 	%table:SE4% SE4
		WHERE 	SE4.%NotDel%
		%exp:cWhere%
		ORDER BY E4_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonPay['hasNext'] := .T.
		Else
			oJsonPay['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonPay['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de condicoes de pagamento
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListPay , JsonObject():New() )

			aListPay[nAux]['id']	:= ( cAliasQry )->E4_CODIGO
			aListPay[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->E4_DESCRI ) )
			
			If Len(aListPay) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonPay['paymentConditions'] := aListPay
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonPay:= FwJsonSerialize( oJsonPay )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonPay)
	
	Self:SetResponse( cJsonPay ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / approval
Retorna os grupos de aprovação.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo os grupos de aprovaï¿½ï¿½o

@author		jose.delmondes
@since		01/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET approval WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aListAprov	:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonAprov	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND SAL.AL_FILIAL = '"+xFilial('SAL')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonAprov	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId		:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId
			cWhere  += " AND SAL.AL_COD = '" + cSearch + "'"
		Else
			cWhere  += " AND ( SAL.AL_COD LIKE '%"	+ cSearch + "%' OR "
			cWhere 	+= " SAL.AL_DESC LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " SAL.AL_DESC LIKE '%" + FwNoAccent( cSearch ) + "%')"
		EndIf
	EndIf
	
	dbSelectArea('SAL')
	If SAL->( Columnpos('AL_MSBLQL') > 0 )
		cWhere += " AND SAL.AL_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar grupos de aprovacao
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT DISTINCT	SAL.AL_COD, SAL.AL_DESC
		FROM 	%table:SAL% SAL
		WHERE 	SAL.%NotDel%
		%exp:cWhere%
		ORDER BY AL_COD
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonAprov['hasNext'] := .T.
		Else
			oJsonAprov['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonAprov['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de grupos de aprovacao
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListAprov , JsonObject():New() )

			aListAprov[nAux]['id']	:= ( cAliasQry )->AL_COD
			aListAprov[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->AL_DESC ) )
			
			If Len(aListAprov) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonAprov['approvalGroups'] := aListAprov
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonAprov:= FwJsonSerialize( oJsonAprov )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonAprov)
	
	Self:SetResponse( cJsonAprov ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / departments
Retorna os departamentos do contrato.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo os gdepartamentos do contrato

@author		jose.delmondes
@since		19/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET department WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aList			:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJson			:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CXQ.CXQ_FILIAL = '"+xFilial('CXQ')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJson			:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId		:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId
			cWhere  += " AND CXQ.CXQ_CODIGO = '"	+ cSearch + "'"
		Else
			cWhere  += " AND ( CXQ.CXQ_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere 	+= " CXQ.CXQ_DESCRI LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CXQ.CXQ_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%')"
		EndIf
	EndIf
	
	dbSelectArea('CXQ')
	If CXQ->( Columnpos('CXQ_MSBLQL') > 0 )
		cWhere += " AND CXQ.CXQ_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar os departamentos do contrato
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT	CXQ.CXQ_CODIGO, CXQ.CXQ_DESCRI, CXQ.CXQ_GESTOR 
		FROM 	%table:CXQ% CXQ
		WHERE 	CXQ.%NotDel% AND
				CXQ.CXQ_STATUS = '1'
		%exp:cWhere%
		ORDER BY CXQ_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJson['hasNext'] := .T.
		Else
			oJson['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJson['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de departamentos do contrato
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aList , JsonObject():New() )

			aList[nAux]['id']	:= ( cAliasQry )->CXQ_CODIGO
			aList[nAux]['description']	:= EncodeUTF8( ( cAliasQry )->CXQ_DESCRI )
			aList[nAux]['manager_id'] := ( cAliasQry )->CXQ_GESTOR
			aList[nAux]['manager_name'] := EncodeUTF8( UsrRetName( ( cAliasQry )->CXQ_GESTOR ) )
			
			If Len(aList) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJson['departments'] := aList
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJson := FwJsonSerialize( oJson )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJson )
	
	Self:SetResponse( cJson ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / typesOfContract
Retorna os tipos de contrato

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		_type			, caracter, tipo do contrato (1=compra, 2=venda)

@return cResponse		, caracter, JSON contendo os tipos de contrato

@author		jose.delmondes
@since		01/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET typesCont WSRECEIVE searchKey, page, pageSize, _type, byId WSREST WSCNTA300

    Local aListType		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonType		:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CN1.CN1_FILIAL = '"+xFilial('CN1')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonType	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:_type		:= ''
	Default self:byId 		:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId			
			cWhere  += " AND CN1.CN1_CODIGO = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CN1.CN1_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere 	+= " CN1.CN1_DESCRI LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CN1.CN1_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%')"
		EndIf
	EndIf

	If !Empty(self:_type)
		If (self:_type) == '1'
			cWhere += " AND CN1.CN1_ESPCTR = '1'"
		ElseIf (self:_type) == '2'
			cWhere += " AND CN1.CN1_ESPCTR = '2'"
		EndIf
	EndIf
	
	dbSelectArea('CN1')
	If CN1->( Columnpos('CN1_MSBLQL') > 0 )
		cWhere += " AND CN1.CN1_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar tipos de contrato
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CN1.CN1_CODIGO, CN1.CN1_DESCRI
		FROM 	%table:CN1% CN1
		WHERE 	CN1.%NotDel%
		%exp:cWhere%
		ORDER BY CN1_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonType['hasNext'] := .T.
		Else
			oJsonType['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonType['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de tipos de contrato
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListType , JsonObject():New() )

			aListType[nAux]['id']	:= ( cAliasQry )->CN1_CODIGO
			aListType[nAux]['description']	:= EncodeUTF8( ( cAliasQry )->CN1_DESCRI )
			
			If Len(aListType) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonType['typesOfContract'] := aListType
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonType:= FwJsonSerialize( oJsonType )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonType)
	
	Self:SetResponse( cJsonType ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / typesOfSpreadsheet
Retorna os tipos de planilha

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo os tipos de planilha

@author		jose.delmondes
@since		01/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET typesSpred WSRECEIVE searchKey, page, pageSize, allTypes, byId WSREST WSCNTA300

    Local aListType		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonType		:= ''
	Local cSearch		:= ''
	Local cWhere		:= ''
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonType	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20
	Default self:allTypes	:= .F. 
	Default self:byId 		:= .F.

	cWhere += "AND CNL.CNL_FILIAL = '"+xFilial('CNL')+"' "
	
	If !self:allTypes
		cWhere += "AND (CNL_MEDEVE = '2' OR (CNL_MEDEVE = '1' AND CNL_CTRFIX IN('1','2'))) "
		cWhere += "AND CNL_CROCTB = '2' "
		cWhere += "AND CNL_CROFIS = '2' "
		cWhere += "AND CNL_PLSERV = '2'"
	EndIf
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		If self:byId
			cWhere  += " AND CNL.CNL_CODIGO = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CNL.CNL_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere 	+= " CNL.CNL_DESCRI LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CNL.CNL_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%')"
		EndIf
	EndIf

	dbSelectArea('CNL')
	If CNL->( Columnpos('CNL_MSBLQL') > 0 )
		cWhere += " AND CNL.CNL_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar tipos de planilha
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CNL.CNL_CODIGO, CNL.CNL_DESCRI, CNL.CNL_MEDEVE, CNL.CNL_CTRFIX, CNL.CNL_VLRPRV
		FROM 	%table:CNL% CNL
		WHERE 	CNL.%NotDel%
		%exp:cWhere%
		ORDER BY CNL_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonType['hasNext'] := .T.
		Else
			oJsonType['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonType['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de tipos de planilha
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListType , JsonObject():New() )

			aListType[nAux]['id']	:= ( cAliasQry )->CNL_CODIGO
			aListType[nAux]['description']	:= EncodeUTF8( ( cAliasQry )->CNL_DESCRI )

			If ( cAliasQry )->CNL_MEDEVE == '2'
				aListType[nAux]['type'] := '1' 	//-- fixa com cronograma financeiro 
			ElseIf ( cAliasQry )->CNL_CTRFIX == '1' .And. ( cAliasQry )->CNL_MEDEVE == '1'
				aListType[nAux]['type'] := '2'	//-- fixa sem cronograma financeiro
			ElseIf ( cAliasQry )->CNL_CTRFIX == '2' .And. ( cAliasQry )->CNL_VLRPRV == '1'
				aListType[nAux]['type'] := '3'	//-- flex com previsão financeira
			ElseIf ( cAliasQry )->CNL_CTRFIX == '2'
				aListType[nAux]['type'] := '4'	//-- flex sem previsão financeira
			Else
				aListType[nAux]['type'] := '5'	//-- flex sem previsão financeira
			EndIf

			If Len(aListType) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonType['typesOfSpreadsheet'] := aListType
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonType:= FwJsonSerialize( oJsonType )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonType)
	
	Self:SetResponse( cJsonType ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / coins
Retorna lista de moedas e seus respectivos simbolos.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo os grupos de aprovação

@author		jose.delmondes
@since		01/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET coins WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300

    Local aListCoin		:= {}

	Local cJsonCoin		:= ''
	Local cMoeda		:= ''
	Local cSimbolo		:= ''
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	Local nFiltro		:= 0
	Local nQtdCoin 		:= MoedFin()
	
	Local oJsonCoin		:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20
	Default self:byid		:= .F.
	
	If !self:byId	
		self:pageSize := MIN( self:pageSize , nQtdCoin ) 
	
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nQtdCoin - nStart + 1
		Else
			nReg := nQtdCoin
		EndIf
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonCoin['hasNext'] := .T.
		Else
			oJsonCoin['hasNext'] := .F.
		EndIf

		If Empty( self:searchKey )
			nCount := nStart - 1
		EndIf

		While ( Len( aListCoin ) < self:pageSize .And. nCount <= (nQtdCoin-1) )
			
			nCount++
	
			If !Empty( self:searchKey )
				If nCount <= 5
					cMoeda := SuperGetMv( "MV_MOEDA" + cValToChar( nCount ) , , "" )
				ElseIf nCount <= 9
					cMoeda := SuperGetMv( "MV_MOEDAP" + cValToChar( nCount ) , , "" )
				Else 
					cMoeda := SuperGetMv( "MV_MOEDP" + cValToChar( nCount ) , , "" )
				EndIf
					
				cSimbolo := SuperGetMv( "MV_SIMB" + cValToChar( nCount ) , , "" )
	
				If !( At( self:searchKey , cMoeda ) > 0 .Or. At( self:searchKey , cSimbolo ) > 0 .Or. At( self:searchKey , cValToChar(nCount) ) > 0 )
					Loop
				EndIf 
	
				nFiltro++
	
				If (nFiltro < nStart)
					Loop
				EndIf
			EndIf
	
			nAux++
			aAdd( aListCoin, JsonObject():New() )
			
			aListCoin[nAux]['id']	:= nCount
			aListCoin[nAux]['symbol']	:= Alltrim( EncodeUTF8( SuperGetMv( "MV_SIMB" + cValToChar( nCount ) , , "" ) ) )
			
			If nCount <= 5
				aListCoin[nAux]['description']	:= Alltrim( EncodeUTF8( SuperGetMv( "MV_MOEDA" + cValToChar( nCount ) , , "" ) ) )
			ElseIf nCount <= 9
				aListCoin[nAux]['description']	:= Alltrim( EncodeUTF8( SuperGetMv( "MV_MOEDAP" + cValToChar( nCount ) , , "" ) ) )
			Else
				aListCoin[nAux]['description']	:= Alltrim( EncodeUTF8( SuperGetMv( "MV_MOEDP" + cValToChar( nCount ) , , "" ) ) )
			EndIf
	
		End 

		If !Empty( self:searchKey )
			oJsonCoin['hasNext'] := .F.
			
			While ( nCount <= (nQtdCoin-1) )
				
				nCount++
				If nCount <= 5
					cMoeda := SuperGetMv( "MV_MOEDA" + cValToChar( nCount ) , , "" )
				ElseIf nCount <= 9
					cMoeda := SuperGetMv( "MV_MOEDAP" + cValToChar( nCount ) , , "" )
				Else 
					cMoeda := SuperGetMv( "MV_MOEDP" + cValToChar( nCount ) , , "" )
				EndIf
				
				cSimbolo := SuperGetMv( "MV_SIMB" + cValToChar( nCount ) , , "" )
	
				If ( At( self:searchKey , cMoeda ) > 0 .Or. At( self:searchKey , cSimbolo ) > 0 .Or. At( self:searchKey , cValToChar(nCount) ) > 0 )
					oJsonCoin['hasNext'] := .T.
					Exit
				EndIf 
			End
		EndIf
	Else
	
		If val(self:searchkey) <= 5
			cMoeda := SuperGetMv( "MV_MOEDA" + self:searchkey , , "" )
		ElseIf val(self:searchkey) <= 9
			cMoeda := SuperGetMv( "MV_MOEDAP" + self:searchkey , , "" )
		Else 
			cMoeda := SuperGetMv( "MV_MOEDP" + self:searchkey , , "" )
		EndIf
	
		aAdd( aListCoin, JsonObject():New() )
		aListCoin[1]['id']	:= self:searchkey
		aListCoin[1]['description']	:= Alltrim( EncodeUTF8( cMoeda ) )
		aListCoin[1]['symbol']	:= Alltrim( EncodeUTF8( SuperGetMv( "MV_SIMB" + self:searchkey , , "" ) ) )
	
	EndIf
	
	oJsonCoin['coins'] := aListCoin
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCoin:= FwJsonSerialize( oJsonCoin )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCoin)
	
	Self:SetResponse( cJsonCoin ) //-- Seta resposta

Return( lRet )


//-------------------------------------------------------------------
/*/{Protheus.doc} WS300VPFix( cContra, cRev, cCompet)
Retorna a soma dos valores previstos para determinada competencia

@param		cContra		, caracter	, numero do contrato
			cRev		, caracter	, revisao do contrato
			cCompet		, caracter	, competencia do contrato MM/YYYY

@return 	nValPrev 	, numerico	, soma do valor previsto para a competencia

@author	jose.delmondes
@since		11/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300VPFix( cContra, cRev, cCompet)

	Local aArea	:= GetArea()
	
	Local nValPrev := 0
	
	Local cAliasCNF	:= GetNextAlias()
	
	//-------------------------------------------------------------------
	// Soma o valor previsto da competencia
	//-------------------------------------------------------------------
	BeginSQL Alias cAliasCNF
	
		SELECT	SUM( CNF.CNF_VLPREV ) TOTPREV
		
		FROM 	%table:CNF% CNF
		
		WHERE 	CNF.CNF_CONTRA = %exp:cContra% AND
				CNF.CNF_REVISA = %exp:cRev% AND
				CNF.CNF_COMPET = %exp:cCompet% AND
				CNF.CNF_FILIAL = %xFilial:CNF% AND
				CNF.%NotDel%
				
	EndSQL
	
	If ( cAliasCNF )->( ! Eof() )
		nValPrev := ( cAliasCNF )->TOTPREV 
	EndIf
	
	( cAliasCNF )->( DBCloseArea() )
	
	RestArea( aArea )

Return nValPrev

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300VRFix( cContra, cRev, cCompet)
Retorna a soma dos valores realizados para determinada competencia

@param		cContra		, caracter	, numero do contrato
			cRev		, caracter	, revisao do contrato
			cFilCtr		, caracter	, filial do contrato
			cCompet		, caracter	, competencia do contrato YYYYMM
			lCron		, logico	, medicoes de planilhas com ou sem cronograma
				
@return 	nValReal 	, numerico	, soma do valor realizado na competencia

@author	jose.delmondes
@since		11/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300VReal( cContra, cRev, cFilCtr, cCompet, lCron , cNumPla )

	Local aArea	:= GetArea()

	Local nValReal	:= 0
	
	Local cAliasCNE	:= GetNextAlias()
	Local cWhere	:= ''
	
	Default cNumPla := ''
	
	cCompet += '%'
	
	If lCron
		cWhere := " EXISTS "
	Else
		cWhere := " NOT EXISTS "
	EndIf
	
	cWhere += "( SELECT CNF.CNF_NUMERO "
	cWhere += "FROM " + RetSQLName("CNF") + " CNF "
	cWhere += "WHERE CNF.CNF_CONTRA = CNE.CNE_CONTRA AND "
	cWhere += "CNF.CNF_REVISA = CNE.CNE_REVISA AND "
	cWhere += "CNF.CNF_NUMPLA = CNE.CNE_NUMERO AND "
	cWhere += "CNF.CNF_FILIAL = '" + xFilial("CNF",cFilCtr) + "' AND "
	cWhere += "CNF.D_E_L_E_T_ = ' ' )"
	
	If !Empty( cNumPla )
		cWhere += " AND CNE.CNE_NUMERO = '" + cNumPla + "'"
	EndIf	
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Soma o valor realizado na competencia
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasCNE
		
		SELECT	SUM( CNE.CNE_VLTOT ) TOTREAL
		
		FROM 	%table:CNE% CNE
		
		INNER JOIN %table:CND% CND ON	CND.CND_CONTRA = CNE.CNE_CONTRA AND
											CND.CND_REVISA = CNE.CNE_REVISA AND
											CND.CND_NUMMED = CNE.CNE_NUMMED AND
											CND.CND_FILCTR = %exp:cFilCtr% AND
											CND.CND_DTFIM LIKE %exp:cCompet% AND
											CND.%NotDel%
											
		WHERE	CNE.CNE_CONTRA = %exp:cContra% AND
				CNE.CNE_REVISA = %exp:cRev% AND
				CNE.CNE_FILIAL = CND.CND_FILIAL AND
				CNE.%NotDel% AND 
				%exp:cWhere%
	
	EndSQL
	
	
	If ( cAliasCNE )->( ! Eof() )
		nValReal := ( cAliasCNE )->TOTREAL 
	EndIf
	
	( cAliasCNE )->( DBCloseArea() )
	
	RestArea( aArea )
		
Return nValReal

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300HFlex( cContra , cRevisa , cFilCtr , dDataIni )
Retorna historico de valores previsto e realizado de cada competencia, para planilha flex

@param		cContra		, caracter	, numero do contrato
			cRev		, caracter	, revisao do contrato
			cFilCtr		, caracter	, filial do contrato
			dDataIni	, data		, data inicial do contrato

@return 	aCompet 	, array		, valor previsto e realizado de cada competencia

@author	jose.delmondes
@since		11/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300HFlex( cContra , cRev , cFilCtr , dDataIni )
	
	Local aCompet		:= {}
	Local aCompetPrv	:= WS300VPFlx( cContra, cRev )
	Local aArea			:= GetArea()
	
	Local cCompet	:= ''
	Local cCompet2	:= ''
	
	Local nPAux	:= 0
	
	If !Empty( aCompetPrv ) //-- array contendo competencia e previsao de planilhas sem cronograma e com previsao financeira
		
		//-------------------------------------------------------------------
		// Preenche array de competencias
		//-------------------------------------------------------------------
		While dDataIni <= LastDate( dDataBase )
			
			cCompet	:= Month2Str( dDataIni ) + '/' + Year2Str( dDataIni )	//-- MM/YYYY
			cCompet2	:= Year2Str( dDataIni ) + Month2Str( dDataIni )			//-- YYYYMM
			
			nPAux := aScan( aCompetPrv , { |x| x[1] == cCompet } )
			
			If nPAux >0
				nValPrev	:= aCompetPrv[nPAux][2]	//-- Valor previsto para a competencia
			Else
				nValPrev	:= 0
			EndIf
			
			nValRel	:= WS300VReal( cContra, cRev, cFilCtr, cCompet2 , .F. )	//-- Valore realizado para a competencia
		
			AADD( aCompet , { cCompet2, nValPrev, nValRel })	//-- competencia, valor previsto, valor realizado
			
			dDataIni := MonthSum( dDataIni , 1 )	//-- vai para o proximo mes
		End
		
	EndIf
	
	RestArea( aArea )
	
	If Empty( aCompet )
		Return Nil
	EndIf

Return aCompet

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300VPFlx( cContra, cRev )
Calcula previsão de medicoes para planilhas flexiveis

@param		cContra		, caracter	, numero do contrato
			cRev		, caracter	, revisao do contrato

@return 	aCompet		, array		, competencias e valores previstos

@author	jose.delmondes
@since		11/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300VPFlx( cContra, cRev )

	Local aArea		:= GetArea()
	Local aAreaCNA	:= {}
	Local aCompet	:= {}

	Local cAliasCNF	:= GetNextAlias()
	Local cCompet	:= ''
	
	Local dDataAux	:= CTOD( " " )
	
	Local nValPrev := 0
	Local nPCompet := 0

	
	DBSelectArea('CNA')
	
	aAreaCNA := CNA->( GetArea( ) )
	
	CNA->( DBSetOrder(1) ) 
	
	If CNA->( DBSeek( xFilial('CNA') + cContra + cRev ) )
		
		//-------------------------------------------------------------------
		// Percorre planilhas do contrato
		//-------------------------------------------------------------------
		While( CNA->CNA_FILIAL + CNA->CNA_CONTRA + CNA->CNA_REVISA == xFilial('CNA') + cContra + cRev )	
			
			//--------------------------------------------------------------------------------------------
			// Verifica se a planilha nao possui cronograma financeiro
			//--------------------------------------------------------------------------------------------
			If 	CN300RetSt( 'MEDEVE' , 0 , CNA->CNA_NUMERO , CNA->CNA_CONTRA , , .F. ) 
				
				nValPrev	:= CNA->CNA_VLTOT / ( DateDiffMonth( CNA->CNA_DTINI , CNA->CNA_DTFIM ) + 1 )	//-- Valor previsto mensal
				dDataAux	:= CNA->CNA_DTINI 
				
				//-------------------------------------------------------------------
				// Preenche array de competencias
				//-------------------------------------------------------------------
				While ( dDataAux <= LastDate( CNA->CNA_DTFIM  ) )
					
					cCompet := Month2Str( dDataAux ) + '/' + Year2Str( dDataAux )
					
					If Empty(aCompet)
					
						aAdd( aCompet , { cCompet , nValPrev } )
					
					Else
						
						nPCompet := aScan( aCompet , { |x| x[1] == cCompet } )
						
						If nPCompet > 0
							aCompet[nPCompet][2] += nValPrev
						Else
							aAdd( aCompet , { cCompet , nValPrev } )
						EndIf
						
					EndIf
					
					dDataAux := MonthSum( dDataAux , 1)
					
				End
			EndIf
			
			CNA->( DBSkip( ) )
		End
	EndIf

	RestArea( aAreaCNA )	
	RestArea( aArea )

Return aCompet

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300VlTot( cContra, cRev, cFilCtr )
Retorna a soma dos valores totais de planilhas com e sem cronograma financeiro

@param		cContra		, caracter	, numero do contrato
			cRev		, caracter	, revisao do contrato
			cFilCtr	, caracter , filial do contrato
			lProjFlex	, logico	, indica se planilha flex possui previsao financeira

@return 	aTotais		, array		, total de planilhas com e sem cronograma financeiro

@author	jose.delmondes
@since		30/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300VlTot( cContra, cRev, cFilCtr ,lProjFlex )
	
	Local aArea		:= GetArea()
	Local aAreaCNA	:= {}
	Local aTotais		:= { 0 , 0 }

	DBSelectArea('CNA')
	
	aAreaCNA := CNA->( GetArea( ) )
	
	CNA->( DBSetOrder(1) ) 
	
	If CNA->( DBSeek( xFilial('CNA') + cContra + cRev ) )

		//-------------------------------------------------------------------
		// Percorre planilhas do contrato
		//-------------------------------------------------------------------
		While( CNA->CNA_FILIAL + CNA->CNA_CONTRA + CNA->CNA_REVISA == xFilial('CNA') + cContra + cRev )	
			
			//--------------------------------------------------------------------------------------------
			// Verifica se a planilha nao possui cronograma financeiro, mas possui uma previsao financeira
			//--------------------------------------------------------------------------------------------
			If 	CN300RetSt( 'MEDEVE' , 0 , CNA->CNA_NUMERO , CNA->CNA_CONTRA , , .F. ) 
				If CNA->CNA_VLTOT	> 0 
					lProjFlex	:= .T.
					aTotais[2] += CNA->CNA_VLTOT
				Else
					aTotais[2] += WS300TotMd( cContra, cRev, CNA->CNA_NUMERO, cFilCTR )
				EndIf
			Else
				aTotais[1] += CNA->CNA_VLTOT
			EndIf
			
			CNA->( DBSkip( ) )
		End
	EndIf
		
	RestArea( aAreaCNA )	
	RestArea( aArea )

Return aTotais

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300QExp( cAliasQry )
Retorna a quantidade de contratos a expirar

@param		cAliasQry		, caracter	, alias da query de contratos

@return 	nQuant			, numerico	, quantidade de contratos a expirar

@author	jose.delmondes
@since		30/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300QExp( cAliasQry )
	
	Local aArea	:= ( cAliasQry )->( GetArea() )
	Local nQuant	:= 0
	
	( cAliasQry )->( DBGoTop() )
	
	//-------------------------------------------------------------------
	// Percorre contratos contabilizando o numero de contratos a expirar
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		//-------------------------------------------------------------------
		// Dias para o vencimento do contrato
		//-------------------------------------------------------------------
		nDiasVenc := WS300Venc( ( cAliasQry )->CN9_TPCTO , ( cAliasQry )->CN9_FILIAL , STOD( ( cAliasQry )->CN9_DTFIM ) )
		
		If nDiasVenc >= -1 
			nQuant++			//-- Total de contratos a expirar
		EndIf
		
		( cAliasQry )->( DBSkip() )
	End
	
	RestArea( aArea )

Return nQuant

//-------------------------------------------------------------------
/*/{Protheus.doc}  WS300TotMd( cContra, cRev, cPlan, cFilCTR )
Retorna o valor total medido de uma determinada planilha

@param		cContra	, caracter	, numero do contrato
			cRev		, caracter , numero da revisao
			cPlan		, caracter , numero da planilha
			cFilCTR	, caracter , filial do contrato

@return 	nTotal		, numerico	, total medido

@author	jose.delmondes
@since		31/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300TotMd( cContra, cRev, cPlan, cFilCTR )
	
	Local aArea	:= GetArea()
	
	Local cAliasCNE	:= GetNextAlias()
	
	Local nTotal	:= 0
	
	//-------------------------------------------------------------------
	// Soma o valor total medido de uma planilha
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasCNE
	
		SELECT SUM( CNE_VLTOT ) AS TOTAL
		
		FROM 	%table:CNE% CNE
		
		INNER JOIN %table:CND% CND ON 	CND.CND_CONTRA = CNE.CNE_CONTRA AND
											CND.CND_REVISA = CNE.CNE_REVISA AND
											CND.CND_NUMMED = CNE.CNE_NUMMED AND
											CND.CND_FILIAL = CNE.CNE_FILIAL AND
											CND.CND_DTFIM <> '' AND
											CND.%NotDel%
		
		WHERE 	CNE.%NotDel% AND
				CNE.CNE_FILIAL = %exp:xFilial('CNE',cFilCTR)%  AND
				CNE.CNE_CONTRA = %exp:cContra% AND
				CNE.CNE_REVISA = %exp:cRev% AND
				CNE.CNE_NUMERO = %exp:cPlan% 
				
	ENDSQL
	
	nTotal := ( cAliasCNE )->TOTAL
	
	( cAliasCNE )->( DBCloseArea( ) )
	
	RestArea( aArea )

Return nTotal

//-------------------------------------------------------------------
/*/{Protheus.doc}  WS300Order( cOrder )
Retorna a expressao ADVPL para ser utilizada na clausala Order
da consulta SQL

@param		cOrder	, caracter	, campo json utilizado para ordenacao

@return 	cExpOrder , caracter , expressao ADVPL

@author	jose.delmondes
@since		30/08/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300Order( cOrder )

	Local cExpOrder := ''
	Local lDesc		:= .F.

	If Left( cOrder , 1 ) == '-'
		lDesc := .T.
		cOrder := SubStr( cOrder , 2 ) 
	EndIf

	Do Case
		Case cOrder == 'number' .Or. Empty(cOrder)
			cExpOrder := 'CN9_NUMERO'
		Case cOrder == 'description'
			cExpOrder := 'CN9_DESCRI, CN1_DESCRI'
		Case cOrder == 'balance'
			cExpOrder := 'CN9_SALDO'
		Case cOrder == 'current_value'
			cExpOrder := 'CN9_VLATU'
		Case cOrder == 'department'
			cExpOrder := 'CN9_DEPART'
		Case cOrder == 'daysToFinish'
			cExpOrder := 'CN9_DTFIM'
	EndCase

	If lDesc .Or. Empty(cOrder)
		cExpOrder += ' DESC'
	EndIf

Return cExpOrder

//-------------------------------------------------------------------
/*/{Protheus.doc}  WS300NextM( cContra, cRev, cPlan )
Retorna a expressao a competencia da proxima parcela a ser medida

@param		cContra	, caracter	, numero do contrato
@param 		crev	, caracter	, codigo da revisao do contrato
@param 		cPlan	, caracter	, codigo da planilha

@return 	cProxMed , caracter , competencia da proxima medicao

@author	jose.delmondes
@since		06/09/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300NextM( cContra, cRev, cPlan )

	Local aArea := GetArea()
	
	Local cProxMed	:= ''
	
	Local cAliasQry := GetNextAlias()

	//-------------------------------------------------------------------
	// Retorna competencia da proxima parcela em aberto
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT CNF_COMPET
		
		FROM 	%table:CNF% CNF
		
		WHERE 	CNF.%NotDel% AND
				CNF.CNF_FILIAL = %xFilial:CNF%  AND
				CNF.CNF_CONTRA = %exp:cContra% AND
				CNF.CNF_REVISA = %exp:cRev% AND
				CNF.CNF_NUMPLA = %exp:cPlan% AND
				CNF.CNF_VLREAL = 0 AND
				CNF.CNF_VLPREV > 0 
		
		ORDER BY CNF_PARCEL
				
	ENDSQL

	cProxMed := ( cAliasQry )->CNF_COMPET
	
	( cAliasQry )->( DBCloseArea( ) )

	RestArea( aArea )

Return cProxMed

//-------------------------------------------------------------------
/*/{Protheus.doc}  WS300Item( cContra, cRev, cPlan, nMoeda )
Retorna array com os itens da planilha do contrato

@param		cContra	, caracter	, numero do contrato
@param 		crev	, caracter	, codigo da revisao do contrato
@param 		cPlan	, caracter	, codigo da planilha
@param		nMoeda	, numerico	, moeda do contrato

@return 	aItens , array, array com itens da planilha

@author		jose.delmondes
@since		06/09/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300Item( cContra, cRev, cPlan, nMoeda )

	Local aArea := GetArea()
	Local aItens := {}
	Local aRateio := {}
	Local aCTBEnt	:= CTBEntArr()
	
	Local cAliasQry := GetNextAlias()
	Local cFilSB1	:= xFilial('SB1')
	Local cCampos	:= ""	

	Local nAux	:= 0
	Local nX	:= 0

	cCampos :=	"CNB.CNB_ITEM, CNB.CNB_PRODUT, CNB.CNB_QUANT, CNB.CNB_QTDMED, CNB.CNB_VLUNIT, CNB.CNB_DESC, "	
	cCampos +=  "CNB.CNB_VLTOT, CNB.CNB_RATEIO, CNB.CNB_CC, CNB.CNB_CLVL, CNB.CNB_CONTA, CNB.CNB_ITEMCT"
	
	For nX := 1 To Len(aCTBEnt)
		cCampos += ", CNB_EC"+aCTBEnt[nX]+"CR" 
		cCampos += ", CNB_EC"+aCTBEnt[nX]+"DB"
	Next nX
	
	cCampos := '%'+cCampos+'%'
	
	//-------------------------------------------------------------------
	// Retorna itens da planilha
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	%exp:cCampos%
		
		FROM 	%table:CNB% CNB
		
		WHERE 	CNB.%NotDel% AND
				CNB.CNB_FILIAL = %xFilial:CNB%  AND
				CNB.CNB_CONTRA = %exp:cContra% AND
				CNB.CNB_REVISA = %exp:cRev% AND
				CNB.CNB_NUMERO = %exp:cPlan%
 		
		ORDER BY CNB_ITEM
				
	ENDSQL

	While ( cAliasQry )->( ! Eof() ) 
				
		aRateio := {}
		nAux++		
		aAdd( aItens , JsonObject():New() )
			
		aItens[nAux]['id']	:= ( cAliasQry )->CNB_ITEM
		aItens[nAux]['productId']	:= ( cAliasQry )->CNB_PRODUT
		aItens[nAux]['product']	:= Alltrim( EncodeUTF8( Posicione( 'SB1' , 1 , cFilSB1 + ( cAliasQry )->CNB_PRODUT , 'B1_DESC' ) ) )
		aItens[nAux]['quantity'] := ( cAliasQry )->CNB_QUANT
		aItens[nAux]['measured_quantity'] := ( cAliasQry )->CNB_QTDMED
		aItens[nAux]['discount'] := ( cAliasQry )->CNB_DESC

		aItens[nAux]['unitary_value']	:= JsonObject():New() 
		aItens[nAux]['unitary_value']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( nMoeda ) , , "" )
		aItens[nAux]['unitary_value']['value']	:= ( cAliasQry )->CNB_VLUNIT
		
		aItens[nAux]['amount']	:= JsonObject():New() 
		aItens[nAux]['amount']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( nMoeda ) , , "" )
		aItens[nAux]['amount']['value']	:= ( cAliasQry )->CNB_VLTOT

		If ( cAliasQry )->CNB_RATEIO == '2'
			
			If !Empty( ( cAliasQry )->CNB_CC ) .Or. !Empty( ( cAliasQry )->CNB_CONTA ) .Or. !Empty( ( cAliasQry )->CNB_ITEMCT ) .Or. !Empty( ( cAliasQry )->CNB_CLVL )

				aAdd( aRateio , JsonObject():New() )

				aRateio[1]['item'] := '01'
				aRateio[1]['cost_center'] := ( cAliasQry )->CNB_CC
				aRateio[1]['cost_center_description'] := Alltrim( EncodeUTF8( Posicione( 'CTT' , 1 , xFilial('CTT') + ( cAliasQry )->CNB_CC , 'CTT_DESC01' ) ) )
				aRateio[1]['accounting_account'] := ( cAliasQry )->CNB_CONTA
				aRateio[1]['accounting_account_description'] :=  Alltrim( EncodeUTF8( Posicione( 'CT1' , 1 , xFilial('CT1') + ( cAliasQry )->CNB_CONTA , 'CT1_DESC01' ) ) )
				aRateio[1]['accounting_item'] := ( cAliasQry )->CNB_ITEMCT
				aRateio[1]['accounting_item_description'] := Alltrim( EncodeUTF8( Posicione( 'CTD' , 1 , xFilial('CTD') + ( cAliasQry )->CNB_ITEMCT , 'CTD_DESC01' ) ) )
				aRateio[1]['value_class'] := ( cAliasQry )->CNB_CLVL
				aRateio[1]['value_class_description'] := Alltrim( EncodeUTF8( Posicione( 'CTH' , 1 , xFilial('CTH') + ( cAliasQry )->CNB_CLVL , 'CTH_DESC01' ) ) )
				aRateio[1]['percentage'] := 100

				aRateio[1]['amount']	:= JsonObject():New() 
				aRateio[1]['amount']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( nMoeda ) , , "" )
				aRateio[1]['amount']['value']	:= ( cAliasQry )->CNB_VLTOT
				
				For nX := 1 to Len(aCTBEnt)
					aRateio[1]['credit_entity_'+aCTBEnt[nX]]	:= ( cAliasQry )->&("CNB_EC"+aCTBEnt[nX]+"CR")
					aRateio[1]['credit_entity_'+aCTBEnt[nX]+'_description']	:= If(!Empty(( cAliasQry )->&("CNB_EC"+aCTBEnt[nX]+"CR")),Alltrim( EncodeUTF8( Posicione( 'CV0' , 1 , xFilial('CV0') + aCTBEnt[nX] + ( cAliasQry )->&("CNB_EC"+aCTBEnt[nX]+"CR") , 'CV0_DESC' ) ) ),'')
					aRateio[1]['debit_entity_'+aCTBEnt[nX]] 	:=  ( cAliasQry )->&("CNB_EC"+aCTBEnt[nX]+"DB")
					aRateio[1]['debit_entity_'+aCTBEnt[nX]+'_description'] 	:= If(!Empty(( cAliasQry )->&("CNB_EC"+aCTBEnt[nX]+"DB")),Alltrim( EncodeUTF8( Posicione( 'CV0' , 1 , xFilial('CV0') + aCTBEnt[nX] + ( cAliasQry )->&("CNB_EC"+aCTBEnt[nX]+"DB") , 'CV0_DESC' ) ) ),'')
				Next nX			
				
			EndIf

		Else

			aRateio :=  WS300Rat( cContra, cRev, cPlan, ( cAliasQry )->CNB_ITEM, nMoeda )

		EndIf

		aItens[nAux]['accounting_apportionment'] := aRateio
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )

	RestArea( aArea )

Return aItens

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300Rat( cContra, cRev, cPlan, cItem, nMoeda )
Retorna array com o rateio contabil do item do contrato

@param		cContra	, caracter	, numero do contrato
@param 		crev	, caracter	, codigo da revisao do contrato
@param 		cPlan	, caracter	, codigo da planilha
@param		citem	, caracter	, item da planilha
@param 		nMoeda	, numerico 	, moeda do contrato

@return 	aRateio , array		, array com o rateio contabil do item do contrato

@author		jose.delmondes
@since		10/09/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300Rat( cContra, cRev, cPlan, cItem, nMoeda )

	Local aArea := GetArea()
	Local aRateio := {}
	Local aCTBEnt	:= CTBEntArr()
	
	Local cAliasQry := GetNextAlias()
	Local cCampos	:= ""	

	Local nAux := 0
	Local nX := 0
	
	cCampos :=	"CNZ.CNZ_ITEM, CNZ.CNZ_PERC, CNZ.CNZ_CC, CNZ.CNZ_CONTA, CNZ.CNZ_ITEMCT, "	
	cCampos +=  "CNZ.CNZ_CLVL, CNZ.CNZ_VALOR1"
	
	For nX := 1 To Len(aCTBEnt)
		cCampos += ", CNZ_EC"+aCTBEnt[nX]+"CR" 
		cCampos += ", CNZ_EC"+aCTBEnt[nX]+"DB"
	Next nX
	
	cCampos := '%'+cCampos+'%'

	//-------------------------------------------------------------------
	// Retorna itens da planilha
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	%exp:cCampos%
		
		FROM 	%table:CNZ% CNZ
		
		WHERE 	CNZ.%NotDel% AND
				CNZ.CNZ_FILIAL = %xFilial:CNZ%  AND
				CNZ.CNZ_CONTRA = %exp:cContra% AND
				CNZ.CNZ_REVISA = %exp:cRev% AND
				CNZ.CNZ_CODPLA = %exp:cPlan% AND
				CNZ.CNZ_ITCONT = %exp:cItem% AND
				CNZ.CNZ_NUMMED = %exp:Space(TAMSX3("CNA_PROXRJ")[1])%
 		
		ORDER BY CNZ_ITEM
				
	ENDSQL

	While ( cAliasQry )->( ! Eof() ) 
			
		nAux++
		aAdd( aRateio , JsonObject():New() )

		aRateio[nAux]['item'] := ( cAliasQry )->CNZ_ITEM
		aRateio[nAux]['cost_center'] := ( cAliasQry )->CNZ_CC
		aRateio[nAux]['cost_center_description'] := Alltrim( EncodeUTF8( Posicione( 'CTT' , 1 , xFilial('CTT') + ( cAliasQry )->CNZ_CC , 'CTT_DESC01' ) ) )
		aRateio[nAux]['accounting_account'] := ( cAliasQry )->CNZ_CONTA
		aRateio[nAux]['accounting_account_description'] :=  Alltrim( EncodeUTF8( Posicione( 'CT1' , 1 , xFilial('CT1') + ( cAliasQry )->CNZ_CONTA , 'CT1_DESC01' ) ) )
		aRateio[nAux]['accounting_item'] := ( cAliasQry )->CNZ_ITEMCT
		aRateio[nAux]['accounting_item_description'] := Alltrim( EncodeUTF8( Posicione( 'CTD' , 1 , xFilial('CTD') + ( cAliasQry )->CNZ_ITEMCT , 'CTD_DESC01' ) ) )
		aRateio[nAux]['value_class'] := ( cAliasQry )->CNZ_CLVL
		aRateio[nAux]['value_class_description'] := Alltrim( EncodeUTF8( Posicione( 'CTH' , 1 , xFilial('CTH') + ( cAliasQry )->CNZ_CLVL , 'CTH_DESC01' ) ) )
		aRateio[nAux]['percentage'] := ( cAliasQry )->CNZ_PERC

		aRateio[nAux]['amount']	:= JsonObject():New() 
		aRateio[nAux]['amount']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( nMoeda ) , , "" )
		aRateio[nAux]['amount']['value']	:= ( cAliasQry )->CNZ_VALOR1
		
		For nX := 1 to Len(aCTBEnt)
			aRateio[nAux]['credit_entity_'+aCTBEnt[nX]]	:= ( cAliasQry )->&("CNZ_EC"+aCTBEnt[nX]+"CR")
			aRateio[nAux]['credit_entity_'+aCTBEnt[nX]+'_description']	:= If(!Empty(( cAliasQry )->&("CNZ_EC"+aCTBEnt[nX]+"CR")),Alltrim( EncodeUTF8( Posicione( 'CV0' , 1 , xFilial('CV0') + aCTBEnt[nX] + ( cAliasQry )->&("CNZ_EC"+aCTBEnt[nX]+"CR") , 'CV0_DESC' ) ) ),'')
			aRateio[nAux]['debit_entity_'+aCTBEnt[nX]] 	:=  ( cAliasQry )->&("CNZ_EC"+aCTBEnt[nX]+"DB")
			aRateio[nAux]['debit_entity_'+aCTBEnt[nX]+'_description'] 	:= If(!Empty(( cAliasQry )->&("CNZ_EC"+aCTBEnt[nX]+"DB")),Alltrim( EncodeUTF8( Posicione( 'CV0' , 1 , xFilial('CV0') + aCTBEnt[nX] + ( cAliasQry )->&("CNZ_EC"+aCTBEnt[nX]+"DB") , 'CV0_DESC' ) ) ),'')
		Next nX	

		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )

	RestArea( aArea )

Return aRateio

//-------------------------------------------------------------------
/*/{Protheus.doc} POST / contracts
Inclui um contrato.

@param	body		, json , campos do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		19/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD POST incCtr WSREST WSCNTA300

	Local aCTBEnt	:= CTBEntArr()
	
	Local cBody		:= ""
	Local cJsonResp	:= ""
	Local cNumCrg	:= ""
	Local cEntCredito	:= ""
	Local cEntDebito	:= ""
	
	Local dVenc	:=  CTOD("")

	Local lRet		:= .T.

	Local nX	:= 0
	Local nY	:= 0
	Local nZ	:= 0
	Local nW	:= 0 
	Local nStack := GetSX8Len()

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()
	Local oModel	:= Nil
	Local oModelCN9	:= Nil
	Local oModelCNA := Nil
	Local oModelCNC := Nil
	Local oModelCNB := Nil
	Local oModelCNZ := Nil
	Local oModelCNF := Nil

	cBody	:= Self:GetContent()

	//-- inicializa objeto json com o contrato 
	If !Empty( cBody )
		FWJsonDeserialize( cBody , @oJsonReqst ) 
	EndIf

	//-- inicializa o modelo do contrato
	If oJsonReqst:specie == '1'
		oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
	Else
		oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
	EndIf

	oModel:SetOperation( MODEL_OPERATION_INSERT ) //-- Seta operacao de inclusao
	
	If oModel:Activate( )	//-- Ativa o modelo

		//-- Carrega submodelos
		oModelCN9 := oModel:GetModel( 'CN9MASTER' )
		oModelCNA := oModel:GetModel( 'CNADETAIL' )
		oModelCNC := oModel:GetModel( 'CNCDETAIL' )
		oModelCNB := oModel:GetModel( 'CNBDETAIL' )
		oModelCNZ := oModel:GetModel( 'CNZDETAIL' )
		oModelCNF := oModel:GetModel( 'CNFDETAIL' )

		//-- se o usuario informou a numeracao sobrescreve a numeracao automatica
		If !Empty( oJsonReqst:number )
			oModelCN9:SetValue( 'CN9_NUMERO' , oJsonReqst:number )
		EndIf
		
		//--Cabecalho do contrato
		oModelCN9:SetValue( 'CN9_TPCTO'	, oJsonReqst:type )
		oModelCN9:SetValue( 'CN9_DESCRI', DecodeUTF8( oJsonReqst:description ) )
		oModelCN9:SetValue( 'CN9_MOEDA' , oJsonReqst:coin )
		oModelCN9:SetValue( 'CN9_CONDPG', oJsonReqst:payment_condition )
		oModelCN9:SetValue( 'CN9_DTINIC', STOD( oJsonReqst:start_date ) )
		oModelCN9:SetValue( 'CN9_UNVIGE', oJsonReqst:validity_unity )
		oModelCN9:SetValue( 'CN9_VIGE' 	, oJsonReqst:validity )
		oModelCN9:SetValue( 'CN9_GRPAPR', oJsonReqst:measurement_approval )
		oModelCN9:SetValue( 'CN9_APROV'	, oJsonReqst:contract_approval )
		oModelCN9:SetValue( 'CN9_OBJCTO', DecodeUTF8( oJsonReqst:object ) )
		oModelCN9:SetValue( 'CN9_ALTCLA', DecodeUTF8( oJsonReqst:clause ) )
		oModelCN9:SetValue( 'CN9_DEPART', oJsonReqst:department_id )
		oModelCN9:SetValue( 'CN9_GESTC' , oJsonReqst:manager_id )
		oModelCN9:SetValue( 'CN9_NATURE', oJsonReqst:class )

		//-- Caucao
		If oJsonReqst:retention_percentage > 0
			oModelCN9:SetValue( 'CN9_FLGCAU' , '1' )
			oModelCN9:SetValue( 'CN9_TPCAUC' , oJsonReqst:bail_type )
			oModelCN9:SetValue( 'CN9_MINCAU' , oJsonReqst:retention_percentage )
		EndIf 

		//-- Verifica a existencia de planilhas
		If !Empty( oJsonReqst:spreadsheets )
			
			For nX := 1 To Len( oJsonReqst:spreadsheets )

				If !lRet
					Exit
				EndIf

				If nX > 1
					If oModelCNA:AddLine() <> nX
						lRet := .F.
						Exit //-- Se ocorreu erro na adicao de linha sai do laco
					EndIf
				EndIf

				//-- Cabecalho da planilha
				oModelCNA:SetValue( 'CNA_NUMERO' , oJsonReqst:spreadsheets[nX]:number )
				oModelCNA:SetValue( 'CNA_TIPPLA' , oJsonReqst:spreadsheets[nX]:type )
				oModelCNA:SetValue( 'CNA_DESCPL' , DecodeUTF8( oJsonReqst:spreadsheets[nX]:description ) )

				If oJsonReqst:specie == '1'	//-- Preenche grid de fornecedores

					If !oModelCNC:SeekLine( { { "CNC_CODIGO" , oJsonReqst:spreadsheets[nX]:related_id } , { "CNC_LOJA" , oJsonReqst:spreadsheets[nX]:related_unit } } )
						
						If nX > 1
							oModelCNC:AddLine()
						EndIf

						oModelCNC:SetValue( 'CNC_CODIGO' , oJsonReqst:spreadsheets[nX]:related_id )
						oModelCNC:SetValue( 'CNC_LOJA' 	 , oJsonReqst:spreadsheets[nX]:related_unit )

					EndIf

					oModelCNA:SetValue( 'CNA_FORNEC' , oJsonReqst:spreadsheets[nX]:related_id )
					oModelCNA:SetValue( 'CNA_LJFORN' , oJsonReqst:spreadsheets[nX]:related_unit )

				Else //--Preenche grid de clientes

					If !oModelCNC:SeekLine( { { "CNC_CLIENT" , oJsonReqst:spreadsheets[nX]:related_id } , { "CNC_LOJACL" , oJsonReqst:spreadsheets[nX]:related_unit } } )
						
						If nX > 1
							oModelCNC:AddLine()
						EndIf
						
						oModelCNC:SetValue( 'CNC_CLIENT' , oJsonReqst:spreadsheets[nX]:related_id )
						oModelCNC:SetValue( 'CNC_LOJACL' 	 , oJsonReqst:spreadsheets[nX]:related_unit )

					EndIf

					oModelCNA:SetValue( 'CNA_CLIENT' , oJsonReqst:spreadsheets[nX]:related_id )
					oModelCNA:SetValue( 'CNA_LOJACL' , oJsonReqst:spreadsheets[nX]:related_unit )

				EndIf
				
				//-- Campos de reajuste do contrato sao iguais aos da primeira planilha, pois no portal a informacao oh eh preenchida na planilha
				If !Empty( oJsonReqst:spreadsheets[nX]:readjust_index )
				 	
					If oModelCN9:GetValue( 'CN9_FLGREJ' ) == '2'
						oModelCN9:SetValue( 'CN9_FLGREJ', '1' )
						oModelCN9:SetValue( 'CN9_INDICE', oJsonReqst:spreadsheets[nX]:readjust_index )
						oModelCN9:SetValue( 'CN9_MODORJ', oJsonReqst:spreadsheets[nX]:readjust_mode )
						oModelCN9:SetValue( 'CN9_UNPERI', oJsonReqst:spreadsheets[nX]:readjust_unity )
						oModelCN9:SetValue( 'CN9_PERI' 	, oJsonReqst:spreadsheets[nX]:readjust_frequency )
					EndIf
					
					oModelCNA:SetValue( 'CNA_FLREAJ', '1' )
					oModelCNA:SetValue( 'CNA_INDICE', oJsonReqst:spreadsheets[nX]:readjust_index )
					oModelCNA:SetValue( 'CNA_MODORJ', oJsonReqst:spreadsheets[nX]:readjust_mode )
					oModelCNA:SetValue( 'CNA_UNPERI', oJsonReqst:spreadsheets[nX]:readjust_unity )
					oModelCNA:SetValue( 'CNA_PERI' 	, oJsonReqst:spreadsheets[nX]:readjust_frequency )

				EndIf

				//-- Preenche o valor total da planilha quando ela for flex c/ previsao financeira
				If Len( oJsonReqst:spreadsheets[nX]:items ) == 0 .And. oJsonReqst:spreadsheets[nX]:current_value > 0 
					oModelCNA:SetValue( 'CNA_VLTOT', oJsonReqst:spreadsheets[nX]:current_value )
				EndIf

				//-- Itens do contrato
				For nY := 1 To Len( oJsonReqst:spreadsheets[nX]:items )
					
					If !lRet
						Exit
					EndIf

					If nY > 1
						If oModelCNB:AddLine() <> nY
							lRet := .F.
							Exit //-- Se ocorreu erro na adicao de linha sai do laco
						EndIf
					EndIf

					oModelCNB:SetValue( 'CNB_ITEM' 	, oJsonReqst:spreadsheets[nX]:items[nY]:id )
					oModelCNB:SetValue( 'CNB_PRODUT', oJsonReqst:spreadsheets[nX]:items[nY]:product_id )
					oModelCNB:SetValue( 'CNB_QUANT' , oJsonReqst:spreadsheets[nX]:items[nY]:quantity )
					oModelCNB:SetValue( 'CNB_VLUNIT', oJsonReqst:spreadsheets[nX]:items[nY]:unitary_value )
					oModelCNB:SetValue( 'CNB_DESC'	, oJsonReqst:spreadsheets[nX]:items[nY]:discount )

					//-- se existir apenas uma linha de rateio contabil, a informacao serah gravada na tabela CNB
					If Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment ) == 1

						oModelCNB:SetValue( 'CNB_CC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:cost_center )
						oModelCNB:SetValue( 'CNB_CLVL'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:value_class )
						oModelCNB:SetValue( 'CNB_ITEMCT', oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:accounting_item )
						oModelCNB:SetValue( 'CNB_CONTA'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:accounting_account )
						
						For nW := 1 To Len(aCTBEnt)
							cEntCredito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:credit_entity_"+aCTBEnt[nW]
							cEntDebito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:debit_entity_"+aCTBEnt[nW]
						
							oModelCNB:SetValue("CNB_EC"+aCTBEnt[nW]+"CR" , &(cEntCredito))
							oModelCNB:SetValue("CNB_EC"+aCTBEnt[nW]+"DB" , &(cEntDebito))
						Next nW

					ElseIf Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment ) > 1

						//-- Rateio contabil
						For nZ := 1 To Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment  )

							If !lRet
								Exit
							EndIf

							If nZ > 1
								If oModelCNZ:AddLine() <> nZ
									lRet := .F.
									Exit //-- Se ocorreu erro na adicao de linha sai do laco
								EndIf
							EndIf

							oModelCNZ:SetValue( 'CNZ_ITEM'  , oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:item )
							oModelCNZ:SetValue( 'CNZ_PERC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:percentage )
							oModelCNZ:SetValue( 'CNZ_CC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:cost_center )
							oModelCNZ:SetValue( 'CNZ_CLVL'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:value_class )
							oModelCNZ:SetValue( 'CNZ_ITEMCT', oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:accounting_item )
							oModelCNZ:SetValue( 'CNZ_CONTA'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:accounting_account )
							
							For nW := 1 To Len(aCTBEnt)
								cEntCredito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:credit_entity_"+aCTBEnt[nW]
								cEntDebito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:debit_entity_"+aCTBEnt[nW]
								
								oModelCNZ:SetValue("CNZ_EC"+aCTBEnt[nW]+"CR" , &(cEntCredito) )
								oModelCNZ:SetValue("CNZ_EC"+aCTBEnt[nW]+"DB" , &(cEntDebito) )
							Next nW

						next nZ 

					EndIf

				Next nY 

				//-- Cronograma financeiro
				For nY := 1 To Len( oJsonReqst:spreadsheets[nX]:financial_schedule )

					If !lRet
						Exit
					EndIf

					If nY > 1
						If oModelCNF:AddLine() <> nY
							lRet := .F.
							Exit
						EndIf
					Else
						cNumCrg	:= GetSX8Num("CNF","CNF_NUMERO")
						CNTA300BlMd( oModelCNF , .F. )
					EndIf

					//-- caso nao exista taxa da moeda projetada para a data de vencimento da parcela
					//-- sera utilizada a taxa da data base
					dVenc := STOD( oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:date )
					If Empty(oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:rate)
						cTxMoeda := ""
						cTxMoeda := RecMoeda( dVenc , oModelCN9:GetValue( "CN9_MOEDA" ) )
						If Empty( cTxMoeda )
							cTxMoeda := RecMoeda( dDataBase , oModelCN9:GetValue( "CN9_MOEDA" ) )
						EndIf
					Else
						cTxMoeda := oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:rate
					EndIf

					oModelCNF:SetValue( 'CNF_NUMERO' , cNumCrg )
					oModelCNF:SetValue( 'CNF_PARCEL' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:parcel )
					oModelCNF:SetValue( 'CNF_COMPET' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:competence )
					oModelCNF:SetValue( 'CNF_DTVENC' , dVenc )
					oModelCNF:SetValue( 'CNF_PRUMED' , dVenc )
					oModelCNF:SetValue( 'CNF_VLPREV' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:value )
					oModelCNF:SetValue( 'CNF_SALDO'  , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:value )
					oModelCNF:SetValue( 'CNF_VLREAL' , 0 )
					oModelCNF:SetValue( 'CNF_TXMOED' , cTxMoeda )

				Next nY

			Next nX

			If lRet .And. oModel:VldData() .And. oModel:CommitData()				
				
				While GetSX8Len() > nStack //-- Confirma num. sequencial
					ConfirmSX8()
				End
				
				//-- Inclusao realizada com sucesso
				oJsonResp['code'] := 201
				oJsonResp['contract_number'] := oModelCN9:GetValue( 'CN9_NUMERO' )

			Else

				//-- Retorna numeracao
				While GetSX8Len() > nStack
					RollBackSX8()
				End

				//-- Erro na inclusao
				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )

			EndIf

		EndIf

	Else
		//-- Erro na ativacao do modelo
		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
	EndIf

	//-------------------------------------------------------------------
	// Destroi o modelo
	//-------------------------------------------------------------------
	oModel:Destroy()

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return ( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} PUT / contracts / {contractID} / {rev}
Altera um contrato.

@param	body		, json , campos do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		23/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD PUT altCtr PATHPARAM contractID, rev WSREST WSCNTA300
	
	Local aCTBEnt	:= CTBEntArr()
	
	Local cBody		:= ""
	Local cJsonResp	:= ""
	Local cNumCrg	:= ""
	Local cEntCredito	:= ""
	Local cEntDebito	:= ""

	Local dVenc	:= CTOD("")

	Local lRet		:= .T.
	Local lRevisao	:= .F.

	Local nX	:= 0
	Local nY	:= 0
	Local nZ	:= 0
	Local nW	:= 0
	Local nStack := GetSX8Len()

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()
	Local oModel	:= Nil
	Local oModelCN9	:= Nil
	Local oModelCNA := Nil
	Local oModelCNC := Nil
	Local oModelCNB := Nil
	Local oModelCNZ := Nil
	Local oModelCNF := Nil

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(Self:rev) == 0
		Self:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf
	
	If !Empty( Self:rev )
		lRevisao := .T.
	EndIf

	cBody	:= Self:GetContent()

	//-- inicializa objeto json com o contrato 
	If !Empty( cBody )
		FWJsonDeserialize( cBody , @oJsonReqst ) 
	EndIf

	dbSelectArea('CN9')
	dbSetOrder(1)
	
	If CN9->( dbSeek( xFilial('CN9') + Self:contractID + Self:rev) )
	
		If lRevisao
			If Cn300RetSt( 'TIPREV' , , , CN9->CN9_NUMERO , CN9->CN9_FILCTR , .F. ) == 'G'
				A300STpRev("G")
			Else 
				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( "Edição permitida apenas para revisões do tipo Aberta (G)." )
			EndIf
		EndIf

		If lRet
			//-- inicializa o modelo do contrato
			If CN9->CN9_ESPCTR == '1'
				oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
			Else
				oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
			EndIf

			oModel:SetOperation( MODEL_OPERATION_UPDATE ) //-- Seta operacao de inclusao
		
			If oModel:Activate( )	//-- Ativa o modelo

				//-- Carrega submodelos
				oModelCN9 := oModel:GetModel( 'CN9MASTER' )
				oModelCNA := oModel:GetModel( 'CNADETAIL' )
				oModelCNC := oModel:GetModel( 'CNCDETAIL' )
				oModelCNB := oModel:GetModel( 'CNBDETAIL' )
				oModelCNZ := oModel:GetModel( 'CNZDETAIL' )
				oModelCNF := oModel:GetModel( 'CNFDETAIL' )
			
				If lRevisao
					oModelCN9:SetValue( 'CN9_JUSTIF', DecodeUTF8( oJsonReqst:justification ) )
					oModelCN9:SetValue( 'CN9_MOTPAR', oJsonReqst:stoppage_id )
					oModelCN9:SetValue( 'CN9_DTFIMP', STOD( oJsonReqst:end_stoppage ) )
				Else
					oModelCN9:SetValue( 'CN9_TPCTO'	, oJsonReqst:type )
					oModelCN9:SetValue( 'CN9_MOEDA' , oJsonReqst:coin )
					oModelCN9:SetValue( 'CN9_DTINIC', STOD( oJsonReqst:start_date ) )
					oModelCN9:SetValue( 'CN9_NATURE', oJsonReqst:class )
				EndIf
		
				//--Cabecalho do contrato
				oModelCN9:SetValue( 'CN9_DESCRI', DecodeUTF8( oJsonReqst:description ) )
				oModelCN9:SetValue( 'CN9_CONDPG', oJsonReqst:payment_condition )
				oModelCN9:SetValue( 'CN9_UNVIGE', oJsonReqst:validity_unity )
				oModelCN9:SetValue( 'CN9_VIGE' 	, oJsonReqst:validity )
				oModelCN9:SetValue( 'CN9_GRPAPR', oJsonReqst:measurement_approval )
				oModelCN9:SetValue( 'CN9_APROV'	, oJsonReqst:contract_approval )
				oModelCN9:SetValue( 'CN9_OBJCTO', DecodeUTF8( oJsonReqst:object ) )
				oModelCN9:SetValue( 'CN9_ALTCLA', DecodeUTF8( oJsonReqst:clause ) )
				oModelCN9:SetValue( 'CN9_DEPART', oJsonReqst:department_id )
				oModelCN9:SetValue( 'CN9_GESTC' , oJsonReqst:manager_id )

				//-- Caucao
				If lRevisao
					If oModelCN9:GetValue('CN9_FLGCAU') == '1' .And. oModelCN9:GetValue('CN9_TPCAUC') == '1'		
						oModelCN9:SetValue( 'CN9_MINCAU' , oJsonReqst:retention_percentage )
					ElseIf oModelCN9:GetValue('CN9_FLGCAU') == '2' .And. oJsonReqst:retention_percentage > 0
						oModelCN9:SetValue( 'CN9_FLGCAU' , '1' )
						oModelCN9:SetValue( 'CN9_TPCAUC' , oJsonReqst:bail_type )
						oModelCN9:SetValue( 'CN9_MINCAU' , oJsonReqst:retention_percentage )
					EndIf
				Else
					If oJsonReqst:retention_percentage > 0
						oModelCN9:SetValue( 'CN9_FLGCAU' , '1' )
						oModelCN9:SetValue( 'CN9_TPCAUC' , oJsonReqst:bail_type )
						oModelCN9:SetValue( 'CN9_MINCAU' , oJsonReqst:retention_percentage )
					ElseIf ( oJsonReqst:retention_percentage == 0 .And. oModelCN9:GetValue( 'CN9_FLGCAU' ) == '1' )
						oModelCN9:SetValue( 'CN9_FLGCAU' , '2' )		
					EndIf 
				EndIf

				//-- Verifica a existencia de planilhas
				If !Empty( oJsonReqst:spreadsheets )
				
					For nX := 1 To Len( oJsonReqst:spreadsheets )
	
						If !lRet
							Exit
						EndIf
						
						If !oJsonReqst:spreadsheets[nX]:editable
							Loop
						EndIf
	
						If !oModelCNA:SeekLine( { { "CNA_NUMERO" , oJsonReqst:spreadsheets[nX]:number } } )
							nTamGrid := oModelCNA:Length()
							If oModelCNA:AddLine() <> nTamGrid + 1
								lRet := .F.
								Exit //-- Se ocorreu erro na adicao de linha sai do laco
							EndIf
						ElseIf oJsonReqst:spreadsheets[nX]:deleted
							oModelCNA:DeleteLine()
							Loop
						EndIf
	
						//-- Cabecalho da planilha
						If oModelCNA:IsInserted()
							oModelCNA:LoadValue( 'CNA_NUMERO' , oJsonReqst:spreadsheets[nX]:number )
							If lRevisao
								oModelCNA:SetValue( 'CNA_TIPPLA' , oJsonReqst:spreadsheets[nX]:type )
							EndIf
						EndIf
						
						If !lRevisao
							oModelCNA:SetValue( 'CNA_TIPPLA' , oJsonReqst:spreadsheets[nX]:type )
						EndIf
						
						//-- Forca abertura/bloqueio de modelos de acrodo com o tipo da planilha
						CN300TpPla( .F., oModel )
						
						oModelCNA:SetValue( 'CNA_DESCPL' , DecodeUTF8( oJsonReqst:spreadsheets[nX]:description ) )
						
						//-- Desbloqueia o modelo de cliente/fornecedor para edicao
						CNTA300BlMd( oModelCNC , .F. )
						
						If CN9->CN9_ESPCTR == '1'	//-- Preenche grid de fornecedores
	
							If !oModelCNC:SeekLine( { { "CNC_CODIGO" , oJsonReqst:spreadsheets[nX]:related_id } , { "CNC_LOJA" , oJsonReqst:spreadsheets[nX]:related_unit } } )
							
								If !Empty( oModelCNC:GetValue('CNC_CODIGO') )
									oModelCNC:AddLine()
								EndIf
	
								oModelCNC:SetValue( 'CNC_CODIGO' , oJsonReqst:spreadsheets[nX]:related_id )
								oModelCNC:SetValue( 'CNC_LOJA' 	 , oJsonReqst:spreadsheets[nX]:related_unit )
	
							EndIf
	
							oModelCNA:SetValue( 'CNA_FORNEC' , oJsonReqst:spreadsheets[nX]:related_id )
							oModelCNA:SetValue( 'CNA_LJFORN' , oJsonReqst:spreadsheets[nX]:related_unit )
	
						Else //--Preenche grid de clientes
	
							If !oModelCNC:SeekLine( { { "CNC_CLIENT" , oJsonReqst:spreadsheets[nX]:related_id } , { "CNC_LOJACL" , oJsonReqst:spreadsheets[nX]:related_unit } } )
								
								If !Empty( oModelCNC:GetValue('CNC_CLIENT') )
									oModelCNC:AddLine()
								EndIf
								
								oModelCNC:SetValue( 'CNC_CLIENT' , oJsonReqst:spreadsheets[nX]:related_id )
								oModelCNC:SetValue( 'CNC_LOJACL' 	 , oJsonReqst:spreadsheets[nX]:related_unit )
	
							EndIf
	
							oModelCNA:SetValue( 'CNA_CLIENT' , oJsonReqst:spreadsheets[nX]:related_id )
							oModelCNA:SetValue( 'CNA_LOJACL' , oJsonReqst:spreadsheets[nX]:related_unit )
	
						EndIf
						
						If !lRevisao
							oModelCNA:SetValue( 'CNA_DTINI', oModelCN9:GetValue('CN9_DTINIC') )
						EndIf
						
						oModelCNA:SetValue( 'CNA_DTFIM', oModelCN9:GetValue('CN9_DTFIM') )
					
						//-- Campos de reajuste do contrato sao iguais aos da primeira planilha, pois no portal a informacao oh eh preenchida na planilha
						If !Empty( oJsonReqst:spreadsheets[nX]:readjust_index )
					 	
							If oModelCN9:GetValue( 'CN9_FLGREJ' ) == '2'
								oModelCN9:SetValue( 'CN9_FLGREJ', '1' )
								oModelCN9:SetValue( 'CN9_INDICE', oJsonReqst:spreadsheets[nX]:readjust_index )
								oModelCN9:SetValue( 'CN9_MODORJ', oJsonReqst:spreadsheets[nX]:readjust_mode )
								oModelCN9:SetValue( 'CN9_UNPERI', oJsonReqst:spreadsheets[nX]:readjust_unity )
								oModelCN9:SetValue( 'CN9_PERI' 	, oJsonReqst:spreadsheets[nX]:readjust_frequency )
							EndIf
						
							oModelCNA:SetValue( 'CNA_FLREAJ', '1' )
							oModelCNA:SetValue( 'CNA_INDICE', oJsonReqst:spreadsheets[nX]:readjust_index )
							oModelCNA:SetValue( 'CNA_MODORJ', oJsonReqst:spreadsheets[nX]:readjust_mode )
							oModelCNA:SetValue( 'CNA_UNPERI', oJsonReqst:spreadsheets[nX]:readjust_unity )
							oModelCNA:SetValue( 'CNA_PERI' 	, oJsonReqst:spreadsheets[nX]:readjust_frequency )
						
						ElseIf oModelCNA:GetValue( 'CNA_FLREAJ' ) == '1'
	
							oModelCNA:SetValue( 'CNA_FLREAJ', '2' )
						
						EndIf
	
						//-- Preenche o valor total da planilha quando ela for flex c/ previsao financeira
						If Len( oJsonReqst:spreadsheets[nX]:items ) == 0 .And. oJsonReqst:spreadsheets[nX]:current_value > 0 
							oModelCNA:SetValue( 'CNA_VLTOT', oJsonReqst:spreadsheets[nX]:current_value )
						EndIf
	
						//-- Itens do contrato
						For nY := 1 To Len( oJsonReqst:spreadsheets[nX]:items )
						
							If !lRet
								Exit
							EndIf
	
							If !Empty(oModelCNB:GetValue('CNB_ITEM')) .And. !oModelCNB:SeekLine( { { "CNB_ITEM" , oJsonReqst:spreadsheets[nX]:items[nY]:id } } )
								nTamGrid := oModelCNB:Length()
								If oModelCNB:AddLine() <> nTamGrid + 1
									lRet := .F.
									Exit //-- Se ocorreu erro na adicao de linha sai do laco
								EndIf
							ElseIf oJsonReqst:spreadsheets[nX]:items[nY]:deleted
								oModelCNB:DeleteLine()
								Loop
							EndIf
	
							If oModelCNB:IsInserted()
								oModelCNB:SetValue( 'CNB_ITEM' 	, oJsonReqst:spreadsheets[nX]:items[nY]:id )
								If lRevisao
									oModelCNB:SetValue( 'CNB_PRODUT', oJsonReqst:spreadsheets[nX]:items[nY]:product_id )
								EndIf
							EndIf
	
							If !lRevisao
								oModelCNB:SetValue( 'CNB_PRODUT', oJsonReqst:spreadsheets[nX]:items[nY]:product_id )
							EndIf
							
							oModelCNB:SetValue( 'CNB_QUANT' , oJsonReqst:spreadsheets[nX]:items[nY]:quantity )
							oModelCNB:SetValue( 'CNB_VLUNIT', oJsonReqst:spreadsheets[nX]:items[nY]:unitary_value )
							oModelCNB:SetValue( 'CNB_DESC'	, oJsonReqst:spreadsheets[nX]:items[nY]:discount )
	
							//-- se existir apenas uma linha de rateio contabil, a informacao serah gravada na tabela CNB
							If Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment ) == 1
	
								oModelCNB:SetValue( 'CNB_CC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:cost_center )
								oModelCNB:SetValue( 'CNB_CLVL'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:value_class )
								oModelCNB:SetValue( 'CNB_ITEMCT', oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:accounting_item )
								oModelCNB:SetValue( 'CNB_CONTA'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:accounting_account)
								
								For nW := 1 To Len(aCTBEnt)
									cEntCredito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:credit_entity_"+aCTBEnt[nW]
									cEntDebito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:debit_entity_"+aCTBEnt[nW]
								
									oModelCNB:SetValue("CNB_EC"+aCTBEnt[nW]+"CR" , &(cEntCredito))
									oModelCNB:SetValue("CNB_EC"+aCTBEnt[nW]+"DB" , &(cEntDebito))
								Next nW
	
								If oModelCNZ:Length() > 1 .Or. oModelCNZ:GetValue('CNZ_PERC') > 0
									CNTA300DlMd(oModelCNZ,'CNZ_PERC')
								EndIf
	
							ElseIf Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment ) > 1
								
								oModelCNB:SetValue( 'CNB_RATEIO', '1' )
								
								For nZ := 1 To Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment )
									If oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:deleted .And. oModelCNZ:SeekLine( { { "CNZ_ITEM" , oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:item } } )
										oModelCNZ:DeleteLine()
									EndIf
								Next nZ
	
								//-- Rateio contabil
								For nZ := 1 To Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment )
	
									If !lRet
										Exit
									EndIf
	
									If oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:deleted
										Loop
									EndIf
	
									If !Empty(oModelCNZ:GetValue('CNZ_ITEM')) .And. !oModelCNZ:SeekLine( { { "CNZ_ITEM" , oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:item } } )
										nTamGrid := oModelCNZ:Length()
										If oModelCNZ:AddLine() <> nTamGrid + 1
											lRet := .F.
											Exit //-- Se ocorreu erro na adicao de linha sai do laco
										EndIf
									EndIf
	
									If oModelCNZ:isInserted()
										oModelCNZ:SetValue( 'CNZ_ITEM'  , oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:item )
									EndIf
	
									oModelCNZ:LoadValue( 'CNZ_PERC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:percentage )
									oModelCNZ:SetValue( 'CNZ_CC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:cost_center )
									oModelCNZ:SetValue( 'CNZ_CLVL'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:value_class )
									oModelCNZ:SetValue( 'CNZ_ITEMCT', oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:accounting_item )
									oModelCNZ:SetValue( 'CNZ_CONTA'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:accounting_account )
									
									For nW := 1 To Len(aCTBEnt)
										cEntCredito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:credit_entity_"+aCTBEnt[nW]
										cEntDebito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:debit_entity_"+aCTBEnt[nW]
									
										oModelCNZ:SetValue("CNZ_EC"+aCTBEnt[nW]+"CR" , &(cEntCredito))
										oModelCNZ:SetValue("CNZ_EC"+aCTBEnt[nW]+"DB" , &(cEntDebito))
									Next nW
	
								next nZ 
	
							EndIf
	
						Next nY 

						//-- Cronograma financeiro
						If Len(oJsonReqst:spreadsheets[nX]:financial_schedule) > 0 
							If Empty( oModelCNF:GetValue('CNF_NUMERO') )
								cNumCrg	:= GetSX8Num('CNF','CNF_NUMERO')
							Else
								cNumCrg := oModelCNF:GetValue('CNF_NUMERO')
							EndIf
						EndIf

						For nY := 1 To Len( oJsonReqst:spreadsheets[nX]:financial_schedule )
	
							If !lRet
								Exit
							EndIf
	
							If !Empty(oModelCNF:GetValue('CNF_PARCEL')) .And.!oModelCNF:SeekLine( { { "CNF_PARCEL" , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:parcel } } )
								nTamGrid := oModelCNF:Length()
								If oModelCNF:AddLine() <> nTamGrid + 1
									lRet := .F.
									Exit //-- Se ocorreu erro na adicao de linha sai do laco
								EndIf
							ElseIf oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:deleted
								oModelCNF:DeleteLine()
								Loop
							EndIf
	
							If nY == 1
								CNTA300BlMd( oModelCNF , .F. )
							EndIf
	
							//-- caso nao exista taxa da moeda projetada para a data de vencimento da parcela
							//-- sera utilizada a taxa da data base
							dVenc := STOD( oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:date )
							If Empty(oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:rate)
								cTxMoeda := ""
								cTxMoeda := RecMoeda( dVenc , oModelCN9:GetValue( "CN9_MOEDA" ) )
								If Empty( cTxMoeda )
									cTxMoeda := RecMoeda( dDataBase , oModelCN9:GetValue( "CN9_MOEDA" ) )
								EndIf
							Else
								cTxMoeda := oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:rate
							EndIf							
				
							If oModelCNF:isInserted()
								oModelCNF:SetValue( 'CNF_NUMERO' , cNumCrg )
								If lRevisao
									oModelCNF:SetValue( 'CNF_PARCEL' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:parcel )
									oModelCNF:SetValue( 'CNF_VLREAL' , 0 )
								EndIf
							EndIf
							
							If !lRevisao
								oModelCNF:SetValue( 'CNF_PARCEL' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:parcel )
								oModelCNF:SetValue( 'CNF_VLREAL' , 0 )
							EndIf
							
							oModelCNF:SetValue( 'CNF_COMPET' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:competence )
							oModelCNF:SetValue( 'CNF_DTVENC' , dVenc )
							oModelCNF:SetValue( 'CNF_PRUMED' , dVenc )
							oModelCNF:SetValue( 'CNF_VLPREV' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:value )
							oModelCNF:SetValue( 'CNF_TXMOED' , cTxMoeda )
	
						Next nY
	
					Next nX
	
					If lRet .And. oModel:VldData() .And. oModel:CommitData()				
					
						While GetSX8Len() > nStack //-- Confirma num. sequencial
							ConfirmSX8()
						End
					
						//-- Alteracao realizada com sucesso
						oJsonResp['code'] := 200
						oJsonResp['contract_number'] := oModelCN9:GetValue( 'CN9_NUMERO' )
	
					Else
	
						//-- Retorna numeracao
						While GetSX8Len() > nStack
							RollBackSX8()
						End
	
						//-- Erro na inclusao
						lRet := .F.
						oJsonResp['code'] := 403
						oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
	
					EndIf
	
				EndIf
	
			Else
				//-- Erro na ativacao do modelo
				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
			EndIf

			//-------------------------------------------------------------------
			// Destroi o modelo
			//-------------------------------------------------------------------
			oModel:Destroy()
		
		EndIf

	Else

		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0036 ) //-- Contrato não encontrado.

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return ( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} PUT / contracts / {contractID} / {rev}
Inclui uma revisão para o contrato.

@param	body		, json , campos do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		10/01/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD POST incRev PATHPARAM contractID, rev WSREST WSCNTA300
	
	Local aCTBEnt	:= CTBEntArr()
	
	Local cBody		:= ""
	Local cJsonResp	:= ""
	Local cNumCrg	:= ""
	Local cTipRev	:= SuperGetMV( 'MV_GCTRVAB', .F., '' )
	Local cEntCredito	:= ""
	Local cEntDebito	:= ""
	
	Local dVenc	:= CTOD("")

	Local lRet		:= .T.

	Local nX	:= 0
	Local nY	:= 0
	Local nZ	:= 0
	Local nW	:= 0
	Local nStack := GetSX8Len()

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()
	Local oModel	:= Nil
	Local oModelCN9	:= Nil
	Local oModelCNA := Nil
	Local oModelCNC := Nil
	Local oModelCNB := Nil
	Local oModelCNZ := Nil
	Local oModelCNF := Nil

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(Self:rev) == 0
		Self:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf

	cBody	:= Self:GetContent()

	//-- inicializa objeto json com o contrato 
	If !Empty( cBody )
		FWJsonDeserialize( cBody , @oJsonReqst ) 
	EndIf

	If Empty(cTipRev)
		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0056 )
	EndIf
	
	dbSelectArea('CN9')
	dbSetOrder(1)
	
	If lRet .And. CN9->( dbSeek( xFilial('CN9') + Self:contractID + Self:rev) )
		
		//-- Seta o tipo de revisao
		A300STpRev("G")
		
		//-- inicializa o modelo do contrato
		If CN9->CN9_ESPCTR == '1'
			oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
		Else
			oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
		EndIf

		oModel:SetOperation( MODEL_OPERATION_INSERT ) //-- Seta operacao de inclusao
	
		If oModel:Activate( .T. )	//-- Ativa o modelo

			//-- Carrega submodelos
			oModelCN9 := oModel:GetModel( 'CN9MASTER' )
			oModelCNA := oModel:GetModel( 'CNADETAIL' )
			oModelCNC := oModel:GetModel( 'CNCDETAIL' )
			oModelCNB := oModel:GetModel( 'CNBDETAIL' )
			oModelCNZ := oModel:GetModel( 'CNZDETAIL' )
			oModelCNF := oModel:GetModel( 'CNFDETAIL' )
		
			//--Cabecalho do contrato
			oModelCN9:SetValue( 'CN9_TIPREV', cTipRev )
			oModelCN9:SetValue( 'CN9_JUSTIF', DecodeUTF8( oJsonReqst:justification ) )
			oModelCN9:SetValue( 'CN9_DESCRI', DecodeUTF8( oJsonReqst:description ) )
			oModelCN9:SetValue( 'CN9_CONDPG', oJsonReqst:payment_condition )
			oModelCN9:SetValue( 'CN9_UNVIGE', oJsonReqst:validity_unity )
			oModelCN9:SetValue( 'CN9_VIGE' 	, oJsonReqst:validity )
			oModelCN9:SetValue( 'CN9_GRPAPR', oJsonReqst:measurement_approval )
			oModelCN9:SetValue( 'CN9_APROV'	, oJsonReqst:contract_approval )
			oModelCN9:SetValue( 'CN9_OBJCTO', DecodeUTF8( oJsonReqst:object ) )
			oModelCN9:SetValue( 'CN9_ALTCLA', DecodeUTF8( oJsonReqst:clause ) )
			oModelCN9:SetValue( 'CN9_DEPART', oJsonReqst:department_id )
			oModelCN9:SetValue( 'CN9_GESTC' , oJsonReqst:manager_id )
			oModelCN9:SetValue( 'CN9_MOTPAR', oJsonReqst:stoppage_id )
			oModelCN9:SetValue( 'CN9_DTFIMP', STOD( oJsonReqst:end_stoppage ) )

			//-- Caucao
			If oModelCN9:GetValue('CN9_FLGCAU') == '1' .And. oModelCN9:GetValue('CN9_TPCAUC') == '1'		
				oModelCN9:SetValue( 'CN9_MINCAU' , oJsonReqst:retention_percentage )
			ElseIf oModelCN9:GetValue('CN9_FLGCAU') == '2' .And. oJsonReqst:retention_percentage > 0
				oModelCN9:SetValue( 'CN9_FLGCAU' , '1' )
				oModelCN9:SetValue( 'CN9_TPCAUC' , oJsonReqst:bail_type )
				oModelCN9:SetValue( 'CN9_MINCAU' , oJsonReqst:retention_percentage )
			EndIf
			
			//-- Verifica a existencia de planilhas
			If !Empty( oJsonReqst:spreadsheets )
			
				For nX := 1 To Len( oJsonReqst:spreadsheets )

					If !lRet
						Exit
					EndIf

					If !oModelCNA:SeekLine( { { "CNA_NUMERO" , oJsonReqst:spreadsheets[nX]:number } } )
						nTamGrid := oModelCNA:Length()
						If oModelCNA:AddLine() <> nTamGrid + 1
							lRet := .F.
							Exit //-- Se ocorreu erro na adicao de linha sai do laco
						EndIf
					ElseIf oJsonReqst:spreadsheets[nX]:deleted
						oModelCNA:DeleteLine()
						Loop
					EndIf

					//-- Cabecalho da planilha
					If oModelCNA:IsInserted()
						oModelCNA:LoadValue( 'CNA_NUMERO' , oJsonReqst:spreadsheets[nX]:number )
						oModelCNA:SetValue( 'CNA_TIPPLA' , oJsonReqst:spreadsheets[nX]:type )
						oModelCNA:SetValue( 'CNA_DTINI', oModelCN9:GetValue('CN9_DTINIC') )
					EndIf
					
					oModelCNA:SetValue( 'CNA_DESCPL' , DecodeUTF8( oJsonReqst:spreadsheets[nX]:description ) )
					
					//-- Desbloqueia o modelo de cliente/fornecedor para edicao
					CNTA300BlMd( oModelCNC , .F. )
					
					If CN9->CN9_ESPCTR == '1'	//-- Preenche grid de fornecedores

						If !oModelCNC:SeekLine( { { "CNC_CODIGO" , oJsonReqst:spreadsheets[nX]:related_id } , { "CNC_LOJA" , oJsonReqst:spreadsheets[nX]:related_unit } } )
						
							If !Empty( oModelCNC:GetValue('CNC_CODIGO') )
								oModelCNC:AddLine()
							EndIf

							oModelCNC:SetValue( 'CNC_CODIGO' , oJsonReqst:spreadsheets[nX]:related_id )
							oModelCNC:SetValue( 'CNC_LOJA' 	 , oJsonReqst:spreadsheets[nX]:related_unit )

						EndIf

						oModelCNA:SetValue( 'CNA_FORNEC' , oJsonReqst:spreadsheets[nX]:related_id )
						oModelCNA:SetValue( 'CNA_LJFORN' , oJsonReqst:spreadsheets[nX]:related_unit )

					Else //--Preenche grid de clientes

						If !oModelCNC:SeekLine( { { "CNC_CLIENT" , oJsonReqst:spreadsheets[nX]:related_id } , { "CNC_LOJACL" , oJsonReqst:spreadsheets[nX]:related_unit } } )
							
							If !Empty( oModelCNC:GetValue('CNC_CLIENT') )
								oModelCNC:AddLine()
							EndIf
							
							oModelCNC:SetValue( 'CNC_CLIENT' , oJsonReqst:spreadsheets[nX]:related_id )
							oModelCNC:SetValue( 'CNC_LOJACL' 	 , oJsonReqst:spreadsheets[nX]:related_unit )

						EndIf

						oModelCNA:SetValue( 'CNA_CLIENT' , oJsonReqst:spreadsheets[nX]:related_id )
						oModelCNA:SetValue( 'CNA_LOJACL' , oJsonReqst:spreadsheets[nX]:related_unit )

					EndIf
				
					oModelCNA:SetValue( 'CNA_DTFIM', oModelCN9:GetValue('CN9_DTFIM') )
				
					//-- Campos de reajuste do contrato sao iguais aos da primeira planilha, pois no portal a informacao soh eh preenchida na planilha
					If !Empty( oJsonReqst:spreadsheets[nX]:readjust_index )
				 	
						If oModelCN9:GetValue( 'CN9_FLGREJ' ) == '2'
							oModelCN9:SetValue( 'CN9_FLGREJ', '1' )
							oModelCN9:SetValue( 'CN9_INDICE', oJsonReqst:spreadsheets[nX]:readjust_index )
							oModelCN9:SetValue( 'CN9_MODORJ', oJsonReqst:spreadsheets[nX]:readjust_mode )
							oModelCN9:SetValue( 'CN9_UNPERI', oJsonReqst:spreadsheets[nX]:readjust_unity )
							oModelCN9:SetValue( 'CN9_PERI' 	, oJsonReqst:spreadsheets[nX]:readjust_frequency )
						EndIf
					
						oModelCNA:SetValue( 'CNA_FLREAJ', '1' )
						oModelCNA:SetValue( 'CNA_INDICE', oJsonReqst:spreadsheets[nX]:readjust_index )
						oModelCNA:SetValue( 'CNA_MODORJ', oJsonReqst:spreadsheets[nX]:readjust_mode )
						oModelCNA:SetValue( 'CNA_UNPERI', oJsonReqst:spreadsheets[nX]:readjust_unity )
						oModelCNA:SetValue( 'CNA_PERI' 	, oJsonReqst:spreadsheets[nX]:readjust_frequency )
					
					ElseIf oModelCNA:GetValue( 'CNA_FLREAJ' ) == '1'

						oModelCNA:SetValue( 'CNA_FLREAJ', '2' )
					
					EndIf

					//-- Preenche o valor total da planilha quando ela for flex c/ previsao financeira
					If Len( oJsonReqst:spreadsheets[nX]:items ) == 0 .And. oJsonReqst:spreadsheets[nX]:current_value > 0 
						oModelCNA:LoadValue( 'CNA_VLTOT', oJsonReqst:spreadsheets[nX]:current_value )
					EndIf

					//-- Itens do contrato
					For nY := 1 To Len( oJsonReqst:spreadsheets[nX]:items )
					
						If !lRet
							Exit
						EndIf

						If !Empty(oModelCNB:GetValue('CNB_ITEM')) .And. !oModelCNB:SeekLine( { { "CNB_ITEM" , oJsonReqst:spreadsheets[nX]:items[nY]:id } } )
							nTamGrid := oModelCNB:Length()
							If oModelCNB:AddLine() <> nTamGrid + 1
								lRet := .F.
								Exit //-- Se ocorreu erro na adicao de linha sai do laco
							EndIf
						ElseIf oJsonReqst:spreadsheets[nX]:items[nY]:deleted
							oModelCNB:DeleteLine()
							Loop
						EndIf

						If oModelCNB:IsInserted()
							oModelCNB:SetValue( 'CNB_ITEM' 	, oJsonReqst:spreadsheets[nX]:items[nY]:id )
							oModelCNB:SetValue( 'CNB_PRODUT', oJsonReqst:spreadsheets[nX]:items[nY]:product_id )
						EndIf

						oModelCNB:SetValue( 'CNB_QUANT' , oJsonReqst:spreadsheets[nX]:items[nY]:quantity )
						oModelCNB:SetValue( 'CNB_VLUNIT', oJsonReqst:spreadsheets[nX]:items[nY]:unitary_value )
						oModelCNB:SetValue( 'CNB_DESC'	, oJsonReqst:spreadsheets[nX]:items[nY]:discount )

						//-- se existir apenas uma linha de rateio contabil, a informacao serah gravada na tabela CNB
						If Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment ) == 1

							oModelCNB:SetValue( 'CNB_CC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:cost_center )
							oModelCNB:SetValue( 'CNB_CLVL'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:value_class )
							oModelCNB:SetValue( 'CNB_ITEMCT', oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:accounting_item )
							oModelCNB:SetValue( 'CNB_CONTA'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:accounting_account)
							
							For nW := 1 To Len(aCTBEnt)
								cEntCredito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:credit_entity_"+aCTBEnt[nW]
								cEntDebito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[1]:debit_entity_"+aCTBEnt[nW]
							
								oModelCNB:SetValue("CNB_EC"+aCTBEnt[nW]+"CR" , &(cEntCredito))
								oModelCNB:SetValue("CNB_EC"+aCTBEnt[nW]+"DB" , &(cEntDebito))
							Next nW

							If oModelCNZ:Length() > 1 .Or. oModelCNZ:GetValue('CNZ_PERC') > 0
								CNTA300DlMd(oModelCNZ,'CNZ_PERC')
							EndIf

						ElseIf Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment ) > 1

							For nZ := 1 To Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment )
								If oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:deleted .And. oModelCNZ:SeekLine( { { "CNZ_ITEM" , oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:item } } )
									oModelCNZ:DeleteLine()
								EndIf
							Next nZ

							//-- Rateio contabil
							For nZ := 1 To Len( oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment )

								If !lRet
									Exit
								EndIf

								If oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:deleted
									Loop
								EndIf

								If !Empty(oModelCNZ:GetValue('CNZ_ITEM')) .And. !oModelCNZ:SeekLine( { { "CNZ_ITEM" , oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:item } } )
									nTamGrid := oModelCNZ:Length()
									If oModelCNZ:AddLine() <> nTamGrid + 1
										lRet := .F.
										Exit //-- Se ocorreu erro na adicao de linha sai do laco
									EndIf
								EndIf

								If oModelCNZ:isInserted()
									oModelCNZ:SetValue( 'CNZ_ITEM'  , oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:item )
								EndIf

								oModelCNZ:LoadValue( 'CNZ_PERC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:percentage )
								oModelCNZ:SetValue( 'CNZ_CC'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:cost_center )
								oModelCNZ:SetValue( 'CNZ_CLVL'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:value_class )
								oModelCNZ:SetValue( 'CNZ_ITEMCT', oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:accounting_item )
								oModelCNZ:SetValue( 'CNZ_CONTA'	, oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:accounting_account )
								
								For nW := 1 To Len(aCTBEnt)
									cEntCredito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:credit_entity_"+aCTBEnt[nW]
									cEntDebito	:= "oJsonReqst:spreadsheets[nX]:items[nY]:accounting_apportionment[nZ]:debit_entity_"+aCTBEnt[nW]
								
									oModelCNZ:SetValue("CNZ_EC"+aCTBEnt[nW]+"CR" , &(cEntCredito))
									oModelCNZ:SetValue("CNZ_EC"+aCTBEnt[nW]+"DB" , &(cEntDebito))
								Next nW

							next nZ 

						EndIf

					Next nY 

					//-- Cronograma financeiro
					If Len(oJsonReqst:spreadsheets[nX]:financial_schedule) > 0 
						If Empty( oModelCNF:GetValue('CNF_NUMERO') )
							cNumCrg	:= GetSX8Num('CNF','CNF_NUMERO')
						Else
							cNumCrg := oModelCNF:GetValue('CNF_NUMERO')
						EndIf
					EndIf

					For nY := 1 To Len( oJsonReqst:spreadsheets[nX]:financial_schedule )

						If !lRet
							Exit
						EndIf

						If !Empty(oModelCNF:GetValue('CNF_PARCEL')) .And.!oModelCNF:SeekLine( { { "CNF_PARCEL" , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:parcel } } )
							nTamGrid := oModelCNF:Length()
							If oModelCNF:AddLine() <> nTamGrid + 1
								lRet := .F.
								Exit //-- Se ocorreu erro na adicao de linha sai do laco
							EndIf
						ElseIf oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:deleted
							oModelCNF:DeleteLine()
							Loop
						EndIf

						If nY == 1
							CNTA300BlMd( oModelCNF , .F. )
						EndIf

						//-- caso nao exista taxa da moeda projetada para a data de vencimento da parcela
						//-- sera utilizada a taxa da data base
						dVenc := STOD( oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:date )
						If Empty(oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:rate)
							cTxMoeda := ""
							cTxMoeda := RecMoeda( dVenc , oModelCN9:GetValue( "CN9_MOEDA" ) )
							If Empty( cTxMoeda )
								cTxMoeda := RecMoeda( dDataBase , oModelCN9:GetValue( "CN9_MOEDA" ) )
							EndIf
						Else
							cTxMoeda := oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:rate
						EndIf	

						If oModelCNF:isInserted()
							oModelCNF:SetValue( 'CNF_NUMERO' , cNumCrg )
							oModelCNF:SetValue( 'CNF_PARCEL' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:parcel )
							oModelCNF:SetValue( 'CNF_VLREAL' , 0 )
						EndIf
						
						oModelCNF:SetValue( 'CNF_COMPET' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:competence )
						oModelCNF:SetValue( 'CNF_DTVENC' , dVenc )
						oModelCNF:SetValue( 'CNF_PRUMED' , dVenc )
						oModelCNF:SetValue( 'CNF_VLPREV' , oJsonReqst:spreadsheets[nX]:financial_schedule[nY]:value )
						oModelCNF:SetValue( 'CNF_TXMOED' , cTxMoeda )

					Next nY

				Next nX

				If lRet .And. oModel:VldData() .And. oModel:CommitData()				
				
					While GetSX8Len() > nStack //-- Confirma num. sequencial
						ConfirmSX8()
					End
				
					//-- Alteracao realizada com sucesso
					oJsonResp['code'] := 200
					oJsonResp['contract_number'] := oModelCN9:GetValue( 'CN9_NUMERO' )
					oJsonResp['revision'] := oModelCN9:GetValue( 'CN9_REVISA' )

				Else

					//-- Retorna numeracao
					While GetSX8Len() > nStack
						RollBackSX8()
					End

					//-- Erro na inclusao
					lRet := .F.
					oJsonResp['code'] := 403
					oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )

				EndIf

			EndIf

		Else
			//-- Erro na ativacao do modelo
			lRet := .F.
			oJsonResp['code'] := 403
			oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
		EndIf

		//-------------------------------------------------------------------
		// Destroi o modelo
		//-------------------------------------------------------------------
		oModel:Destroy()

	ElseIf lRet

		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0036 ) //-- Contrato nao encontrato

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return ( lRet )


//-------------------------------------------------------------------
/*/{Protheus.doc} DELETE / contracts / {contractID} / {rev}
Exlui um contrato.

@param	body		, json , campos do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		27/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD DELETE delCtr PATHPARAM contractID, rev WSREST WSCNTA300

	Local cBody		:= ""
	Local cJsonResp	:= ""

	Local lRet		:= .T.

	Local oJsonResp		:= JsonObject():New()
	Local oModel	:= Nil

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(Self:rev) == 0
		Self:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf

	cBody	:= Self:GetContent()

	//-- inicializa objeto json com o contrato 
	If !Empty( cBody )
		FWJsonDeserialize( cBody , @oJsonReqst ) 
	EndIf

	dbSelectArea('CN9')
	dbSetOrder(1)
	
	If CN9->( dbSeek( xFilial('CN9') + Self:contractID + Self:rev) )

		//-- inicializa o modelo do contrato
		If CN9->CN9_ESPCTR == '1'
			oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
		Else
			oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
		EndIf

		oModel:SetOperation( MODEL_OPERATION_DELETE ) //-- Seta operacao de exclusão
	
		If oModel:Activate( )
			
			If oModel:VldData() .And. oModel:CommitData()				
				
				//-- Exclusao realizada com sucesso
				oJsonResp['code'] := 201
				oJsonResp['message'] := EncodeUTF8( STR0038 )

			Else

				//-- Erro na exclusao
				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )

			EndIf

		Else
				
			//-- Erro na ativacao do modelo
			lRet := .F.
			oJsonResp['code'] := 403
			oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )

		EndIf	

		//-------------------------------------------------------------------
		// Destroi o modelo
		//-------------------------------------------------------------------
		oModel:Destroy()

	Else

		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0036 ) //-- Contrato nao encontrato

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )

Return ( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} PUT / contracts / {contractID} / {rev} /status
Altera a situacao de um contrato.

@param	body		, json , campos do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		27/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD PUT status PATHPARAM contractID, rev WSREST WSCNTA300
	
	Local aError    := {}

	Local cBody		:= ""
	Local cJsonResp	:= ""
	Local cSituac 	:= ""
	Local cError 	:= ""

	Local nX	:= 0

	Local lRet		:= .T.

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()

	Private lMsErroAuto := .F.
	Private lMsHelpAuto	:= .T.
	Private lAutoErrNoFile := .T.

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(Self:rev) == 0
		Self:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf

	cBody	:= Self:GetContent()

	If !Empty( cBody )
		//-- inicializa objeto json com o documento
		If FWJsonDeserialize( cBody , @oJsonReqst ) 

			cSituac := oJsonReqst:status

			dbSelectArea('CN9')
			dbSetOrder(1)

			If CN9->( dbSeek( xFilial('CN9') + Self:contractID + Self:rev) )

				If !(CN9->CN9_SITUAC == "02" .And. cSituac $ "03*05") .And.;
				   !(CN9->CN9_SITUAC == "03" .And. cSituac $ "02*05*01") .And.;
				   !(CN9->CN9_SITUAC == "04" .And. cSituac $ "02*01") .And.;
				   !(CN9->CN9_SITUAC == "05" .And. cSituac $ "02*07*01") .And.;
				   !(CN9->CN9_SITUAC == "07" .And. cSituac $ "08*01") .And.;
				   !(CN9->CN9_SITUAC == "11" .And. cSituac $ "02*01")

				   lRet := .F.

					oJsonResp['code'] := 403
					oJsonResp['message']	:= EncodeUTF8( STR0040 )

				EndIf

				If lRet
					MsExecAuto( {|a,b,c,d,e| CN100SitCh(a,b,c,d,e)}, CN9->CN9_NUMERO, CN9->CN9_REVISA, cSituac, CN9->CN9_APROV, .F. )

					If lMsErroAuto
						
						lRet	:= .F. 
						aError  := GetAutoGRLog()

						For nX := 1 To Len(aError) 
							cError += aError[nX] + CRLF  
						Next nX

						oJsonResp['code'] := 403
						oJsonResp['message']	:= EncodeUTF8( cError ) //EncodeUTF8("Erro na alteração da situação do contrato.")

					Else
						
						//-- Alteração da situação realizada com sucesso
						oJsonResp['code'] := 200
						oJsonResp['number'] := CN9->CN9_NUMERO
						oJsonResp['revision'] := CN9->CN9_REVISA
						oJsonResp['status'] := CN9->CN9_SITUAC

					EndIf
				EndIf
			
			Else

				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( STR0036 ) //-- Contrato nao encontrado

			EndIf
	
		Else
			lRet := .F.
			oJsonResp['code'] := 500
			oJsonResp['message'] :=	EncodeUTF8( STR0033 )
		EndIf
	Else
		lRet := .F.
		oJsonResp['code'] := 400
		oJsonResp['message'] := EncodeUTF8( STR0034 )	//-- Corpo da mensagem vazio.
	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return ( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / contracts / {contractID} / historic / revisions
Retorna o historico de revisoes do contrato.

@param	contractID		, caracter, numero do contrato 
		revisionFilter	, caracter, filtro de revisoes
		page			, numerico, numero da pagina
		pageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo o historico de revisoes

@author		jose.delmondes
@since		29/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET revisions PATHPARAM contractID WSRECEIVE searchKey, page, revisionFilter WSREST WSCNTA300

	Local aListPlan	:= {}
	Local aListRev	:= {}
	Local aTotais	:=	{}
	
	Local cAliasCN9	:= GetNextAlias()
	Local cAliasQry := GetNextAlias()
	Local cJsonCtr	:= ''
	Local cFilCN1	:= xFilial('CN1')
	Local cFilCNL	:= xFilial('CNL')
	Local cFilSA1	:= xFilial('SA1')
	Local cFilSA2	:= xFilial('SA2')
	Local cFilCN6	:= xFilial('CN6')
	Local cFilCN0	:= xFilial('CN0')
	Local cFilSE4 	:= xFilial('SE4') 
	Local cFilCXQ	:= xFilial('CXQ')
	Local cFilSAL	:= xFilial('SAL')
	Local cWhere	:= "AND CN9.CN9_FILIAL = '"+xFilial('CN9')+"'"
	Local cRevAtu	:= ""
	
	Local oJsonCtr	:= JsonObject():New() 
	
	Local nStatusCode	:= 500
	Local nDiasVenc		:= 0
	Local nAuxPlan		:= 0
	Local nAuxRev		:= 0
	Local nCount		:= 0
	Local nStart 		:= 1
	
	Local lProjFlex	:= .F.
	Local lRet	:= .T.

	Default self:revisionFilter 	:= ''
	Default self:page			:= 1
	Default self:pageSize		:= 20 
	
	//-------------------------------------------------------------------
	// Tratativas para o filtro de revisoes
	//-------------------------------------------------------------------
	If !Empty(self:revisionFilter)
		If self:revisionFilter == "000"
			self:revisionFilter := StrTran(self:revisionFilter,'000',"'   '")
		Else
			self:revisionFilter := StrTran(self:revisionFilter,'000',"   ")
			self:revisionFilter := "'"+StrTran(self:revisionFilter,",","','")+"'"
		EndIf		
		cWhere	+= "AND CN9.CN9_REVISA IN (" + self:revisionFilter  + ") " 
	EndIf
	
	cWhere := '%'+cWhere+'%'

	BeginSQL Alias cAliasQRY

		SELECT 	COUNT( CN9_NUMERO ) TOTAL 
		FROM 	%Table:CN9% CN9
		WHERE	CN9.CN9_NUMERO = %exp:Self:contractID% AND
				CN9.%NotDel%
				%exp:cWhere%

	EndSQL

	nRecord := (cAliasQRY)->TOTAL

	(cAliasQRY)->(dbCloseArea())
		
	//-------------------------------------------------------------------
	// nStart -> primeiro registro da pagina
	// nReg -> numero de registros do inicio da pagina ao fim do arquivo
	//-------------------------------------------------------------------
	If self:page > 1
		nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
		nReg := nRecord - nStart + 1
	Else
		nReg := nRecord
	EndIf
		
	//-------------------------------------------------------------------
	// Valida a exitencia de mais paginas
	//-------------------------------------------------------------------
	If nReg  > self:pageSize
		oJsonCtr['hasNext'] := .T.
	Else
		oJsonCtr['hasNext'] := .F.
	EndIf
		
	If nRecord >= nStart
		//-------------------------------------------------------------------
		// Query para selecionar o contrato e suas planilhas
		//-------------------------------------------------------------------
		BEGINSQL Alias cAliasCN9
		
			SELECT	CN9.CN9_NUMERO, CN9.CN9_REVISA, CN9.CN9_FILCTR, CN9.CN9_FILIAL, CN9.CN9_ESPCTR, CN9.CN9_VLATU, CN9.CN9_VIGE, CN9.CN9_APROV, CN9.CN9_GRPAPR,
					CN9.CN9_UNVIGE, CN9.CN9_VIGE, CN9.CN9_DTINIC, CN9.CN9_DTFIM, CN9.CN9_TPCTO, CN9.CN9_MOEDA, CN9.CN9_SALDO, CN9.CN9_GESTC, CN9.CN9_SITUAC, CN9.CN9_TIPREV,
					CN9.CN9_CONDPG, CN9.CN9_CODOBJ, CN9.CN9_CODCLA, CN9.CN9_CODJUS, CN9.CN9_DESCRI, CN9.CN9_DEPART, CN9.CN9_TPCAUC, CN9.CN9_MINCAU, 
					CNA.CNA_NUMERO, CNA.CNA_TIPPLA, CNA.CNA_FORNEC, CNA.CNA_INDICE, CNA_PROXRJ, CNA.CNA_LJFORN, CNA.CNA_CLIENT, CNA.CNA_LOJACL, CNA.CNA_SALDO, 
					CNA.CNA_VLTOT, CNA.CNA_DESCPL, CNA.CNA_MODORJ, CNA.CNA_UNPERI, CNA.CNA_PERI
			
			FROM 	%table:CN9% CN9
			
			INNER JOIN %table:CNA% CNA ON 	CNA.CNA_CONTRA = CN9.CN9_NUMERO AND
											CNA.CNA_REVISA = CN9.CN9_REVISA AND
											CNA.CNA_FILIAL = %xFilial:CNA% AND
											CNA.%NotDel%
			
			WHERE	CN9.CN9_NUMERO = 	%exp:Self:contractID% AND
					CN9.%NotDel%
					%exp:cWhere%

			ORDER BY CN9_REVISA, CNA_NUMERO
		
		ENDSQL
		
		oJsonCtr['number']	:=	( cAliasCN9 )->CN9_NUMERO
		oJsonCtr['_type']	:=	( cAliasCN9 )->CN9_ESPCTR
		oJsonCtr['type_of_contract_id'] := ( cAliasCN9 )->CN9_TPCTO
		oJsonCtr['type_of_contract_description'] := Alltrim( EncodeUTF8( Posicione( 'CN1' , 1 , cFilCN1 + ( cAliasCN9 )->CN9_TPCTO , 'CN1_DESCRI' ) ) )
		oJsonCtr['startDate']	:=	( cAliasCN9 )->CN9_DTINIC
		oJsonCtr['coin'] := ( cAliasCN9 )->CN9_MOEDA

		While ( cAliasCN9 )->( ! Eof() )

			If cRevAtu <> ( cAliasCN9 )->CN9_REVISA

				nCount++
				cRevAtu := ( cAliasCN9 )->CN9_REVISA

				If nCount >= nStart

					If !Empty(aListPlan) .And. nAuxRev > 0
						aListRev[nAuxRev]['spreadsheets'] := aListPlan
						aListPlan := {}
						nAuxPlan := 0
					EndIf
			
					//-------------------------------------------------------------------
					// Detalhes do contrato
					//-------------------------------------------------------------------
					nAuxRev++		
					aAdd( aListRev , JsonObject():New() )
				
					aTotais := WS300VlTot( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CN9_FILCTR , @lProjFlex )
			
					aListRev[nAuxRev]['revision']	:=	( cAliasCN9 )->CN9_REVISA
					aListRev[nAuxRev]['revision_type_code'] := ( cAliasCN9 )->CN9_TIPREV
					aListRev[nAuxRev]['revision_type'] := Posicione( 'CN0' , 1 , cFilCN0 + ( cAliasCN9 )->CN9_TIPREV , "CN0_TIPO" )
					aListRev[nAuxRev]['revision_description'] := Alltrim( EncodeUTF8( Posicione( 'CN0' , 1 , cFilCN0 + ( cAliasCN9 )->CN9_TIPREV , "CN0_DESCRI" ) ) )
					aListRev[nAuxRev]['endDate']	:= ( cAliasCN9 )->CN9_DTFIM
					aListRev[nAuxRev]['payment_condition_id'] := ( cAliasCN9 )->CN9_CONDPG
					aListRev[nAuxRev]['payment_condition_description'] := Alltrim( EncodeUTF8( Posicione( 'SE4' , 1 , cFilSE4 + ( cAliasCN9 )->CN9_CONDPG , "E4_DESCRI" ) ) )
					aListRev[nAuxRev]['daysToFinish'] := If( dDataBase < STOD( ( cAliasCN9 )->CN9_DTFIM )  , DateDiffDay( dDataBase , STOD( ( cAliasCN9 )->CN9_DTFIM ) ) , 0 )
					aListRev[nAuxRev]['description']	:= If( !Empty( ( cAliasCN9 )->CN9_DESCRI ), Alltrim( EncodeUTF8( ( cAliasCN9 )->CN9_DESCRI ) ) ,  Alltrim( EncodeUTF8( Posicione( 'CN1' , 1 , cFilCN1 + ( cAliasCN9 )->CN9_TPCTO , 'CN1_DESCRI' ) ) ) )
					aListRev[nAuxRev]['manager_id']	:= ( cAliasCN9 )->CN9_GESTC
					aListRev[nAuxRev]['manager_description']	:= Alltrim( EncodeUTF8( UsrFullName( ( cAliasCN9 )->CN9_GESTC ) ) )
					aListRev[nAuxRev]['department_id'] :=  Alltrim( EncodeUTF8( ( cAliasCN9 )->CN9_DEPART ) )
					aListRev[nAuxRev]['department_description'] := Alltrim( EncodeUTF8( Posicione( 'CXQ' , 1 , cFilCXQ + ( cAliasCN9 )->CN9_DEPART , "CXQ_DESCRI" ) ) ) 
					aListRev[nAuxRev]['contract_approval_id'] := ( cAliasCN9 )->CN9_APROV
					aListRev[nAuxRev]['contract_approval_description'] :=  Alltrim( EncodeUTF8( Posicione( 'SAL' , 1 , cFilSAL + ( cAliasCN9 )->CN9_APROV , "AL_DESC" ) ) )
					aListRev[nAuxRev]['measurement_approval_id'] := ( cAliasCN9 )->CN9_GRPAPR
					aListRev[nAuxRev]['measurement_approval_description'] :=  Alltrim( EncodeUTF8( Posicione( 'SAL' , 1 , cFilSAL + ( cAliasCN9 )->CN9_GRPAPR , "AL_DESC" ) ) )
					aListRev[nAuxRev]['bail_type'] := ( cAliasCN9 )->CN9_TPCAUC
					aListRev[nAuxRev]['retention_percentage'] := ( cAliasCN9 )->CN9_MINCAU
					aListRev[nAuxRev]['object'] := EncodeUTF8( MSMM( ( cAliasCN9 )->CN9_CODOBJ ) ) 
					aListRev[nAuxRev]['clause'] := EncodeUTF8( MSMM( ( cAliasCN9 )->CN9_CODCLA ) ) 
					aListRev[nAuxRev]['justification'] := EncodeUTF8( MSMM( ( cAliasCN9 )->CN9_CODJUS ) )
					aListRev[nAuxRev]['balance']	:= JsonObject():New() 
					aListRev[nAuxRev]['balance']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
					aListRev[nAuxRev]['balance']['total']	:= ( cAliasCN9 )->CN9_SALDO 
					aListRev[nAuxRev]['current_value']	:= JsonObject():New() 
					aListRev[nAuxRev]['current_value']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
					aListRev[nAuxRev]['current_value']['total_fixed']	:= aTotais[1] 
					aListRev[nAuxRev]['current_value']['total_flex']	:= aTotais[2]
					aListRev[nAuxRev]['current_value']['sum_total'] := ( cAliasCN9 )->CN9_VLATU
					aListRev[nAuxRev]['balanceHistory'] := JsonObject():New() 
					aListRev[nAuxRev]['balanceHistory']['fixed'] := WS300HFix( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CN9_FILCTR , STOD( ( cAliasCN9 )->CN9_DTINIC ) )
					aListRev[nAuxRev]['balanceHistory']['flex'] := WS300HFlex( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CN9_FILCTR , STOD( ( cAliasCN9 )->CN9_DTINIC ) )
					aListRev[nAuxRev]['balanceHistory']['projection_flex']	:= lProjFlex
			
					If ( cAliasCN9 )->CN9_UNVIGE == '1'
						aListRev[nAuxRev]['validity'] := Alltrim( Str( ( cAliasCN9 )->CN9_VIGE ) ) + ' ' + If( ( cAliasCN9 )->CN9_VIGE == 1 , STR0010 , STR0011 )
					ElseIf ( cAliasCN9 )->CN9_UNVIGE == '2'
						aListRev[nAuxRev]['validity'] := Alltrim( Str( ( cAliasCN9 )->CN9_VIGE ) ) + ' ' + If( ( cAliasCN9 )->CN9_VIGE == 1 , STR0012 , STR0013 ) 
					ElseIf ( cAliasCN9 )->CN9_UNVIGE == '3'
						aListRev[nAuxRev]['validity'] := Alltrim( Str( ( cAliasCN9 )->CN9_VIGE ) ) + ' ' + If( ( cAliasCN9 )->CN9_VIGE == 1 , STR0014 , STR0015 )
					ElseIf ( cAliasCN9 )->CN9_UNVIGE == '4'
						oJsonCtr['validity'] := Alltrim( Str( DateDiffDay( STOD( ( cAliasCN9 )->CN9_DTINIC ) , STOD( ( cAliasCN9 )->CN9_DTFIM ) ) ) ) + ' ' + STR0011 
					EndIf
					
					If ( cAliasCN9 )->CN9_UNVIGE == '4'
						oJsonCtr['validity_quant'] := DateDiffDay( STOD( ( cAliasCN9 )->CN9_DTINIC ) , STOD( ( cAliasCN9 )->CN9_DTFIM ) )
						oJsonCtr['validity_unity'] := '1'
					Else
						oJsonCtr['validity_quant'] := ( cAliasCN9 )->CN9_VIGE
						oJsonCtr['validity_unity'] := ( cAliasCN9 )->CN9_UNVIGE
					EndIf

					nDiasVenc := WS300Venc( ( cAliasCN9 )->CN9_TPCTO , ( cAliasCN9 )->CN9_FILIAL , STOD( ( cAliasCN9 )->CN9_DTFIM ) )
					
					If nDiasVenc >= -1
						aListRev[nAuxRev]['expiresIn']	:= nDiasVenc
					Else
						aListRev[nAuxRev]['expiresIn'] := Nil
					EndIf

					If Alltrim( (cAliasCN9)->CN9_SITUAC ) == '09' .And. ( Empty( (cAliasCN9)->CN9_APROV ) .OR. !ExistSCR2( 'RV', (cAliasCN9)->(CN9_NUMERO+CN9_REVISA) ) )
						aListRev[nAuxRev]['situation'] := '09'
					ElseIf Alltrim( (cAliasCN9)->CN9_SITUAC ) == 'A' .Or. ( Alltrim( (cAliasCN9)->CN9_SITUAC ) == '09' .And. !Empty( (cAliasCN9)->CN9_APROV ) )
						aListRev[nAuxRev]['situation'] := '12'
					Else
						aListRev[nAuxRev]['situation'] := (cAliasCN9)->CN9_SITUAC
					EndIf
				EndIf
			EndIf
			
			//-------------------------------------------------------------------
			// Alimenta array de planilhas
			//-------------------------------------------------------------------

			If nCount >= nStart	
				nAuxPlan++		
					
				aAdd( aListPlan , JsonObject():New() )
					
				aListPlan[nAuxPlan]['number'] := ( cAliasCN9 )->CNA_NUMERO
				aListPlan[nAuxPlan]['next_measurement'] := WS300NextM( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CNA_NUMERO )
				aListPlan[nAuxPlan]['index'] := Alltrim( EncodeUTF8( Posicione( 'CN6' , 1 , cFilCN6 + ( cAliasCN9 )->CNA_INDICE , "CN6_DESCRI" ) ) )
				aListPlan[nAuxPlan]['index_id'] := ( cAliasCN9 )->CNA_INDICE
				aListPlan[nAuxPlan]['readjust_date'] := ( cAliasCN9 )->CNA_PROXRJ
				aListPlan[nAuxPlan]['type_id'] := ( cAliasCN9 )->CNA_TIPPLA
				aListPlan[nAuxPlan]['type_description'] := Alltrim( EncodeUTF8( Posicione( 'CNL' , 1 , cFilCNL + ( cAliasCN9 )->CNA_TIPPLA , 'CNL_DESCRI' ) ) )
				aListPlan[nAuxPlan]['readjust_mode'] := ( cAliasCN9 )->CNA_MODORJ
				aListPlan[nAuxPlan]['readjust_unit'] := ( cAliasCN9 )->CNA_UNPERI
				aListPlan[nAuxPlan]['readjust_frequency'] := ( cAliasCN9 )->CNA_PERI
				
				If Empty( ( cAliasCN9 )->CNA_DESCPL )
					aListPlan[nAuxPlan]['description'] := Alltrim( EncodeUTF8( Posicione( 'CNL' , 1 , cFilCNL + ( cAliasCN9 )->CNA_TIPPLA , 'CNL_DESCRI' ) ) )
				Else
					aListPlan[nAuxPlan]['description'] := Alltrim( EncodeUTF8( ( cAliasCN9 )->CNA_DESCPL ) )
				EndIf
				
				If ( cAliasCN9 )->CN9_ESPCTR == '1'
					aListPlan[nAuxPlan]['related_id'] := ( cAliasCN9 )->CNA_FORNEC
					aListPlan[nAuxPlan]['related_unit'] := ( cAliasCN9 )->CNA_LJFORN
					aListPlan[nAuxPlan]['related_cnpj'] := Transform( Posicione( 'SA2' , 1 , cFilSA2 + ( cAliasCN9 )->CNA_FORNEC + ( cAliasCN9 )->CNA_LJFORN , 'A2_CGC' ) , X3Picture( 'A2_CGC' ) )
					aListPlan[nAuxPlan]['related'] := Alltrim( EncodeUTF8( Posicione( 'SA2' , 1 , cFilSA2 + ( cAliasCN9 )->CNA_FORNEC + ( cAliasCN9 )->CNA_LJFORN , 'A2_NOME' ) ) )
				Else
					aListPlan[nAuxPlan]['related_id'] := ( cAliasCN9 )->CNA_CLIENT
					aListPlan[nAuxPlan]['related_unit'] := ( cAliasCN9 )->CNA_LOJACL
					aListPlan[nAuxPlan]['related_cnpj'] := Transform( Posicione( 'SA2' , 1 , cFilSA2 + ( cAliasCN9 )->CNA_CLIENT + ( cAliasCN9 )->CNA_LOJACL , 'A2_CGC' ) , X3Picture( 'A2_CGC' ) )
					aListPlan[nAuxPlan]['related'] := Alltrim( EncodeUTF8( Posicione( 'SA1' , 1 , cFilSA1 + ( cAliasCN9 )->CNA_CLIENT + ( cAliasCN9 )->CNA_LOJACL , 'A1_NOME' ) ) )
				EndIf

				aListPlan[nAuxPlan]['balance'] := JsonObject():New() 
				aListPlan[nAuxPlan]['balance']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
				aListPlan[nAuxPlan]['balance']['total']	:= ( cAliasCN9 )->CNA_SALDO

				aListPlan[nAuxPlan]['current_value'] := JsonObject():New() 
				aListPlan[nAuxPlan]['current_value']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( (cAliasCN9 )->CN9_MOEDA ) , , "" )
				aListPlan[nAuxPlan]['current_value']['total'] := ( cAliasCN9 )->CNA_VLTOT

				aListPlan[nAuxPlan]['itens'] := WS300Item( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CNA_NUMERO , ( cAliasCN9 )->CN9_MOEDA ) 
				aListPlan[nAuxPlan]['schedule'] := WS300Cron( ( cAliasCN9 )->CN9_NUMERO , ( cAliasCN9 )->CN9_REVISA , ( cAliasCN9 )->CNA_NUMERO , ( cAliasCN9 )->CN9_MOEDA )
			
			EndIf

			If Len(aListRev) >= self:pageSize
				Exit
			EndIf

			( cAliasCN9 )->( DBSkip() ) 

		End
		
		If !Empty(aListPlan) .And. nAuxRev > 0
			aListRev[nAuxRev]['spreadsheets'] := aListPlan
			aListPlan := {}
			nAuxPlan := 0
		EndIf
		
		( cAliasCN9 )->( DBCloseArea() )

	EndIf

	oJsonCtr['revisions']	:=	aListRev
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCtr:= FwJsonSerialize( oJsonCtr )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCtr)
	
	Self:SetResponse( cJsonCtr ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} POST / contracts / {contractID} / documents
Vincula um documento ao contrato

@param	body		, json , com o documento no formato base 64

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		21/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD POST postDoc PATHPARAM contractID WSREST WSCNTA300

	Local cBody		:= ""
	Local cJsonResp	:= ""
	Local cName 	:= ""
	Local cContent 	:= ""
	Local cDirDocs 	:= MsDocPath()

	Local lRet		:= .T.

	Local nStack := GetSX8Len()

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()

	cBody	:= Self:GetContent()

	If !Empty( cBody )
		//-- inicializa objeto json com o documento
		If FWJsonDeserialize( cBody , @oJsonReqst ) 

			cName := oJsonReqst:name
			cContent := oJsonReqst:content
			cDescription := oJsonReqst:description

			//-- Cria o documento no diretorio do banco de conhecimento
			nHandle:= FCREATE( cDirDocs + "\" + cName , 0 ) 

			If nHandle == -1
				lRet := .F.
				oJsonResp['code'] := 500
				oJsonResp['message'] := EncodeUTF8( STR0030 )//-- Erro na criação do arquivo.
			Else
				
				//-- Escreve documento
				FWRITE( nHandle , Decode64(cContent) )
				
				//-- Valida criacao do documento
				If FCLOSE( nHandle ) .And. File( cDirDocs + "\" + cName )

					//-- Grava tabelas do banco de conhecimento
					RecLock( "ACB" , .T. )

					ACB->ACB_FILIAL := xFilial("ACB")
					ACB->ACB_CODOBJ := GetSX8Num( "ACB" , "ACB_CODOBJ" )
					ACB->ACB_OBJETO := cName
					ACB->ACB_DESCRI := cDescription
					
					ACB->( MsUnlock() )

					RecLock( "AC9", .T. )
					
					AC9->AC9_FILIAL := xFilial("AC9")
					AC9->AC9_FILENT := xFilial("CN9")
					AC9->AC9_ENTIDA := "CN9"
					AC9->AC9_CODENT := self:contractID 
					AC9->AC9_CODOBJ := ACB->ACB_CODOBJ

					AC9->( MsUnlock() )

					While GetSX8Len() > nStack //-- Confirma num. sequencial
						ConfirmSX8()
					End

					//-- Inclusao realizada com sucesso
					oJsonResp['code'] := 201
					oJsonResp['id'] := ACB->ACB_CODOBJ
					oJsonResp['message'] := EncodeUTF8( STR0031 )	//-- Documento anexado ao contrato com sucesso

				Else
					lRet := .F.
					oJsonResp['code'] := 500
					oJsonResp['message'] := EncodeUTF8( STR0032 )	//-- Erro ao salvar o arquivo
				EndIf

			EndIf
		Else
			lRet := .F.
			oJsonResp['code'] := 500
			oJsonResp['message'] := EncodeUTF8( STR0033 )	//-- Erro ao realizar o parse do arquivo json
		EndIf
	Else
		lRet := .F.
		oJsonResp['code'] := 400
		oJsonResp['message'] := EncodeUTF8( STR0034 )	//-- Corpo da mensagem vazio.
	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['error'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return ( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / contracts / {contractID} / documents
retorna as referencias dos documentos anexados ao contrato

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse	, json , json contento os documentos anexado ao contrato

@author		jose.delmondes
@since		21/11/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET getDoc PATHPARAM contractID, rev WSRECEIVE searchKey, page, pageSize WSREST WSCNTA300

	Local aList			:= {} 
	
	Local cAliasQry		:= GetNextAlias()
	Local cJson			:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND ACB.ACB_FILIAL = '"+xFilial('ACB')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJson	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		cWhere  += " AND ( ACB.ACB_CODOBJ LIKE '%"	+ cSearch + "%' OR "
		cWhere	+= " ACB.ACB_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		cWhere	+= " ACB.ACB_DESCRI LIKE '%" + cSearch + "%' ) " 
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar os documentos
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	ACB.ACB_CODOBJ, ACB.ACB_OBJETO, ACB.ACB_DESCRI
		
		FROM 	%table:ACB% ACB
		
		INNER JOIN %table:AC9% AC9 ON 	AC9.AC9_CODOBJ = ACB.ACB_CODOBJ AND
										AC9.AC9_FILIAL = ACB.ACB_FILIAL AND
										AC9.AC9_ENTIDA = 'CN9' AND
										AC9.AC9_CODENT = %exp:self:contractID% AND
										AC9.%NotDel%

		WHERE	ACB.%NotDel%
				%exp:cWhere%
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJson['hasNext'] := .T.
		Else
			oJson['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJson['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de documentos
	//-------------------------------------------------------------------
	While ( cAliasQry )->( !Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aList , JsonObject():New() )
			
			aList[nAux]['id']	:= ( cAliasQry )->ACB_CODOBJ
			aList[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->ACB_DESCRI ) )
			
			If Len(aList) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJson['documents'] := aList
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJson:= FwJsonSerialize( oJson )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJson )
	
	Self:SetResponse( cJson ) //-- Seta resposta

Return (.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / contracts / {contractID} / documents / {doc}
retorna o documento solicitado

@param	contractID		, caracter, codigo do contrato
		rev				, caracter, revisao do contrato
		doc				, caracter, codigo de referencia do documento

@return cResponse		, json , json contento o documento no formato base64

@author		jose.delmondes
@since		03/12/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET document PATHPARAM contractID, rev, doc WSREST WSCNTA300
	
	Local cFile 		:= ''
	Local cDirDocs		:= ''
	Local cPathFile		:= ''
	Local cData			:= ''
	
	Local lMsMultDir 	:= MsMultDir()
	Local lRet	:= .T.

	Local nFile := 0

	Local oJson	:= JsonObject():New() 

	dbSelectArea('ACB')
	dbSetOrder(1)
	
	If ACB->( dbSeek( xFilial('ACB') + self:doc ) )

		cFile := Alltrim( ACB->ACB_OBJETO )

		If !lMsMultDir
			cDirDocs := MsDocPath()
		Else
			cDirDocs := MsRetPath( cFile )
		EndIf

		cDirDocs  := MsDocRmvBar( cDirDocs )
		cPathFile := cDirDocs + "\" + cFile

		nFile := FOpen(cPathFile)

		If nFile > -1

			// le o conteudo
			cData := ReadAllFile(nFile)
			FClose(nFile)

			oJson['id'] := ACB->ACB_CODOBJ
			oJson['name'] := ACB->ACB_OBJETO	
			oJson['description'] := Alltrim( EncodeUTF8( ACB->ACB_DESCRI ) )	
			oJson['file'] := Encode64( cData )

		Else
			
			lRet := .F.
			oJson['code'] := 403
			oJson['message'] := EncodeUTF8( STR0044 )	//-- Erro na abertura do arquivo

		EndIf
	
	Else
		
		lRet := .F.
		oJson['code'] := 403
		oJson['message'] := EncodeUTF8( STR0045 )	//-- Documento nao encontrado

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJson := FwJsonSerialize( oJson )

	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
		Self:SetResponse( cJson )
	Else
		SetRestFault( oJson['code'] , oJson['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJson )

Return ( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} ReadAllFile(nHandle)
realiza a leitura completa de um arquivo

@param	nHandle		, numerico, numero de manipulação que identifica o arquivo a ser lido

@return cData		, caracter , arquivo completo

@author		jose.delmondes
@since		04/12/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function ReadAllFile(nHandle)
    
	Local cBuff := Space(2048)
    Local cData := ""
    Local nLido := 0

    While (nLido := FRead(nHandle, @cBuff, Len(cBuff))) > 0
        cData += Left(cBuff, nLido)
    End

Return cData

//-------------------------------------------------------------------
/*/{Protheus.doc} DELETE / contracts / {contractID} / {rev} / documents / {doc}
Exclui um documento vinculado ao contrato

@param	contractID		, caracter, codigo do contrato
		rev				, caracter, revisao do contrato
		doc				, caracter, codigo de referencia do documento

@return cResponse		, json , json contento o documento no formato base64

@author		jose.delmondes
@since		03/12/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD DELETE docDel PATHPARAM contractID, rev, doc WSREST WSCNTA300
	
	Local cFile 		:= ''
	Local cDirDocs		:= ''
	Local cPathFile		:= ''
	Local cData			:= ''
	
	Local lMsMultDir 	:= MsMultDir()
	Local lRet	:= .T.

	Local nFile := 0

	Local oJson	:= JsonObject():New() 

	dbSelectArea('AC9')
	dbSetOrder(1)
	
	If AC9->( dbSeek( xFilial('AC9') + self:doc + 'CN9' + xFilial('CN9') + self:contractID ) )

		RecLock("AC9",.F.)
			AC9->( dbDelete() )
		AC9->( MsUnlock() )

		If !( AC9->( dbSeek( xFilial('AC9') + self:doc ) ) ) 

			dbSelectArea('ACB')
			dbSetOrder(1)
			
			If ACB->( dbSeek( xFilial('ACB') + self:doc ) )

				cFile := Alltrim( ACB->ACB_OBJETO )

				If !lMsMultDir
					cDirDocs := MsDocPath()
				Else
					cDirDocs := MsRetPath( cFile )
				EndIf

				cDirDocs  := MsDocRmvBar( cDirDocs )
				cPathFile := cDirDocs + "\" + cFile

				RecLock("ACB",.F.)
					ACB->( dbDelete() )
				ACB->( MsUnlock() )

				FErase( cPathFile )
			
			EndIf

		EndIf

		//-- Exclusao realizada com sucesso
		oJson['code'] := 201
		oJson['message'] := EncodeUTF8( STR0038 )

	Else
		
		lRet := .F.
		oJson['code'] := 403
		oJson['message'] := EncodeUTF8( STR0045 )	//-- Documento nao encontrado

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJson := FwJsonSerialize( oJson )

	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
		Self:SetResponse( cJson )
	Else
		SetRestFault( oJson['code'] , oJson['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJson )

Return ( lRet )


//-------------------------------------------------------------------
/*/{Protheus.doc} WS300Cron(cContra, cRev, cPlan, cMoeda)
Retorna as parcelas do cronograma financeiro

@param	cContra		, caracter, numero do contrato 
@param	cRev		, caracter, numero da revisao
@param	cPlan		, caracter, numero da planilha

@return cResponse		, array, Array contendo as parcelas do cronograma

@author		jose.delmondes
@since		06/12/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300Cron(cContra, cRev, cPlan, cMoeda)

	Local aSchedule	:= {}
	
	Local cAliasQry		:= GetNextAlias()
	
	Local nAux			:= 0

	//-------------------------------------------------------------------
	// Query para selecionar as parcelas do cronograma
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CNF.CNF_PARCEL, CNF.CNF_COMPET, CNF.CNF_PRUMED, CNF.CNF_DTREAL, 
				CNF.CNF_VLPREV, CNF.CNF_SALDO
		
		FROM 	%table:CNF% CNF
	
		WHERE 	CNF.CNF_CONTRA = %exp:cContra% AND
				CNF.CNF_REVISA = %exp:cRev% AND
				CNF.CNF_NUMPLA = %exp:cPlan% AND
				CNF.CNF_FILIAL = %xFilial:CNF% AND
				CNF.%NotDel%
		
		ORDER BY CNF_PARCEL
	
	ENDSQL

	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
			
		nAux++		
		aAdd( aSchedule , JsonObject():New() )
		
		aSchedule[nAux]['parcel']	:= ( cAliasQry )->CNF_PARCEL
		aSchedule[nAux]['competence']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CNF_COMPET ) )
		aSchedule[nAux]['forecastDate']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CNF_PRUMED ) )
		aSchedule[nAux]['executionDate'] := Alltrim( EncodeUTF8( ( cAliasQry )->CNF_DTREAL) )

		aSchedule[nAux]['balance'] := JsonObject():New()
		aSchedule[nAux]['balance']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( cMoeda ) , , "" )
		aSchedule[nAux]['balance']['total'] := ( cAliasQRY )->CNF_SALDO

		aSchedule[nAux]['forecastValue'] := JsonObject():New()
		aSchedule[nAux]['forecastValue']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( cMoeda ) , , "" )
		aSchedule[nAux]['forecastValue']['total'] := ( cAliasQRY )->CNF_VLPREV

		If Empty( ( cAliasQry )->CNF_DTREAL )
			aSchedule[nAux]['status'] := '1'
		ElseIf ( cAliasQRY )->CNF_SALDO > 0 
			aSchedule[nAux]['status'] := '2'
		Else
			aSchedule[nAux]['status'] := '3'
		EndIf

		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
Return( aSchedule )
//-------------------------------------------------------------------
/*/{Protheus.doc} GET / codrevisions
Retorna a lista de revisões e seu tipo.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina
		PageSize		, numerico, quantidade de registros por pagina

@return cResponse		, caracter, JSON contendo a lista de revisões

@author	janaina.jesus
@since		05/12/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET cdrevision PATHPARAM contractID WSRECEIVE searchKey, page, pageSize WSREST WSCNTA300
	
	Local aListRev   := {}
	
	Local cAliasCN9  := GetNextAlias()
	Local cJsonRev   := ''
	Local cSearchKey := ''
	Local cSearch    := ''
	Local cWhere     := "CN9.CN9_FILIAL = '"+xFilial('CN9')+"'"
	
	Local lRet       := .T.
	
	Local nCount     := 0
	Local nStart     := 1
	Local nReg       := 0
	Local nAux       := 0
	
	Local oJsonRev   := JsonObject():New() 
		
	Default self:searchKey := ''
	Default self:page := 1
	Default self:pageSize := 20 
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( Self:SearchKey )
		cWhere += " AND ( CN9.CN9_REVISA LIKE '%"	+ cSearch + "%' OR "
		cWhere	+= " CN0.CN0_DESCRI LIKE '%" + cSearch + "%' OR "
		cWhere	+= " CN0.CN0_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		cWhere	+= " CN0.CN0_TIPO LIKE '%" + cSearch + "%' ) " 
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar clientes
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasCN9
	
		SELECT CN9.CN9_REVISA,CN0.CN0_DESCRI, CN0.CN0_TIPO
		FROM 	%table:CN9% CN9
		LEFT JOIN %table:CN0% CN0 ON 	CN0.CN0_FILIAL = %xFilial:CN0% AND
											CN9.CN9_TIPREV = CN0.CN0_CODIGO AND
											CN0.%NotDel%
											
		
		WHERE 	CN9.%NotDel% AND
				CN9.CN9_NUMERO = %exp:self:contractID% AND
				%exp:cWhere%
		ORDER BY CN9_REVISA DESC
	
	ENDSQL
	
	If ( cAliasCN9 )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasCN9 )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonRev['hasNext'] := .T.
		Else
			oJsonRev['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonRev['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array com as revisões
	//-------------------------------------------------------------------
	While ( cAliasCN9 )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aListRev , JsonObject():New() )
			
			If Empty(( cAliasCN9 )->CN9_REVISA)			
				aListRev[nAux]['id']	:= "000"
				aListRev[nAux]['description']	:= ""
				aListRev[nAux]['type']	:= ""			
			Else			
				aListRev[nAux]['id']	:= ( cAliasCN9 )->CN9_REVISA
				aListRev[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasCN9 )->CN0_DESCRI ) )
				aListRev[nAux]['type']	:= ( cAliasCN9 )->CN0_TIPO			
			EndIf
				
			If Len(aListRev) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasCN9 )->( DBSkip() )
		
	End
	
	( cAliasCN9 )->( DBCloseArea() )
	
	oJsonRev['revisions'] := aListRev
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonRev:= FwJsonSerialize( oJsonRev )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonRev)
	
	Self:SetResponse( cJsonRev ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} PUT / contracts / {contractID} / {rev} / approvalRevision
Aprova uma revisão do contrato

@param	contractID	, json , numero do contrato
@param  rev			, json , revisao do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		14/01/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD PUT aprRev PATHPARAM contractID, rev WSREST WSCNTA300
	
	Local cJsonResp	:= ""

	Local lRet		:= .T.

	Local oJsonResp		:= JsonObject():New()

	dbSelectArea('CN9')
	dbSetOrder(1)
	
	If CN9->( dbSeek( xFilial('CN9') + Self:contractID + Self:rev) )
		
		A300SATpRv( Cn300RetSt( "TIPREV" , , , CN9->CN9_NUMERO , CN9->CN9_FILCTR , .F. ) )
		
		//-- inicializa o modelo do contrato
		If CN9->CN9_ESPCTR == '1'
			oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
		Else
			oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
		EndIf

		oModel:SetOperation( MODEL_OPERATION_UPDATE ) //-- Seta operacao de alteracao
	
		If oModel:Activate( )	//-- Ativa o modelo

			If oModel:VldData() .And. oModel:CommitData()				
	
				//-- aprovacao realizada com sucesso
				oJsonResp['code'] := 200
				oJsonResp['contract_number'] := oModel:GetValue( 'CN9MASTER' , 'CN9_NUMERO' )
				oJsonResp['message'] := EncodeUTF8( STR0049 )

			Else

				//-- Erro na aprovacao
				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )

			EndIf

		Else
			//-- Erro na ativacao do modelo
			lRet := .F.
			oJsonResp['code'] := 403
			oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
		EndIf

		//-------------------------------------------------------------------
		// Destroi o modelo
		//-------------------------------------------------------------------
		oModel:Destroy()

	Else

		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0036 )

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )

Return ( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / stoppages
Retorna a lista de motivos de paralizacao.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo a lista de produtos

@author		jose.delmondes
@since		16/01/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET stoppages WSRECEIVE searchKey, page, pageSize, byId WSREST WSCNTA300
	
	Local aListPar		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonPar		:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND CN2.CN2_FILIAL = '"+xFilial('CN2')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonPar	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId		:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		If self:byId
			cSearch := Upper( Self:SearchKey )
			cWhere  += " AND CN2.CN2_CODIGO = '" + cSearch + "'"
		Else
			cSearch := Upper( Self:SearchKey )
			cWhere  += " AND ( CN2.CN2_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CN2.CN2_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " CN2.CN2_DESCRI LIKE '%" + cSearch + "%' ) "
		EndIf
	EndIf
	
	dbSelectArea('CN2')
	If CN2->( Columnpos('CN2_MSBLQL') > 0 )
		cWhere += " AND CN2.CN2_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar produtos
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CN2.CN2_CODIGO, CN2.CN2_DESCRI
		FROM 	%table:CN2% CN2
		WHERE 	CN2.%NotDel%
		%exp:cWhere%
		ORDER BY CN2_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonPar['hasNext'] := .T.
		Else
			oJsonPar['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonPar['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aListPar , JsonObject():New() )
			
			aListPar[nAux]['id']	:= ( cAliasQry )->CN2_CODIGO
			aListPar[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CN2_DESCRI ) )
			
			If Len(aListPar) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonPar['stoppages'] := aListPar
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonPar:= FwJsonSerialize( oJsonPar )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonPar)
	
	Self:SetResponse( cJsonPar ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} POST / contracts / contractId / rev / readjustment
Aplica reajuste a uma lista de contratos.

@param	body		, json , campos do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		18/01/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD POST readj PATHPARAM contractID, rev WSREST WSCNTA300

	Local cBody		:= ""
	Local cJsonResp	:= ""
	Local cNovaRev 	:= ""
	Local cTipRev	:= SuperGetMV( 'MV_GCTRVRJ', .F., '' )

	Local lRet		:= .T.
	Local lReaj		:= .T.
	
	Local nValorRj	:= 0

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()
	Local oModel	:= Nil
	Local oModelCN9	:= Nil

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(Self:rev) == 0
		Self:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf

	cBody	:= Self:GetContent()

	//-- inicializa objeto json com o contrato 
	If !Empty( cBody )
		FWJsonDeserialize( cBody , @oJsonReqst ) 
	EndIf

	dbSelectArea('CN9')
	dbSetOrder(1)
	
	If Empty(cTipRev)
		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0055 )
	EndIf
	
	If lRet .And. CN9->( dbSeek( xFilial('CN9') + Self:contractID + Self:rev) )
		
		//-- Seta o tipo de revisao
		A300STpRev("2")
		
		//-- inicializa o modelo do contrato
		If CN9->CN9_ESPCTR == '1'
			oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
		Else
			oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
		EndIf

		oModel:SetOperation( MODEL_OPERATION_INSERT ) //-- Seta operacao de inclusao
	
		If oModel:Activate( .T. )	//-- Ativa o modelo

			//-- Carrega submodelos
			oModelCN9 := oModel:GetModel( 'CN9MASTER' )
		
			//--Cabecalho do contrato
			oModelCN9:LoadValue('CN9_TIPREV',cTipRev)
			oModelCN9:LoadValue('CN9_DREFRJ',STOD(oJsonReqst:reference_date))
			oModelCN9:LoadValue('CN9_DTREAJ',STOD(oJsonReqst:application_date))
			oModelCN9:LoadValue('CN9_JUSTIF',STR0052)
			
			lRet := CN300REAJU(oModel, @nValorRj) //Efetua reajuste
			
			If lRet .And. nValorRj == 0
				lRet := .F.
				lReaj := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( "Valor de reajuste calculado para o índice do contrato corresponde a 0%." )
			EndIf 

			If lRet .And. oModel:VldData() .And. oModel:CommitData()	
			
				//-- Aprovacao da revisao
				
				If Empty( oModelCN9:GetValue( 'CN9_APROV' ) ) .And. oJsonReqst:approval
					
					cNovaRev := oModelCN9:GetValue('CN9_REVISA')
					
					dbSelectArea('CN9')
					dbSetOrder(1)
					CN9->( dbSeek( xFilial('CN9') + Self:contractID + cNovaRev) )
					
					A300SATpRv( Cn300RetSt( "TIPREV" , , , CN9->CN9_NUMERO , CN9->CN9_FILCTR , .F. ) )
					
					//-- inicializa o modelo do contrato
					If CN9->CN9_ESPCTR == '1'
						oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
					Else
						oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
					EndIf

					oModel:SetOperation( MODEL_OPERATION_UPDATE ) //-- Seta operacao de alteracao
					
					oModel:Activate( )	//-- Ativa o modelo
					
					If !( oModel:VldData() .And. oModel:CommitData())
						//-- Erro na aprovacao
						lRet := .F.
						oJsonResp['code'] := 403
						oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
					EndIf					
					
				EndIf
				
				If lRet
					
					//-- Alteracao realizada com sucesso
					oJsonResp['code'] := 200
					oJsonResp['contract_number'] := oModelCN9:GetValue( 'CN9_NUMERO' )
					oJsonResp['revision'] := oModelCN9:GetValue( 'CN9_REVISA' )
					oJsonResp['current_value']	:= JsonObject():New() 
					oJsonResp['current_value']['symbol'] := SuperGetMv( "MV_SIMB" + cValToChar( oModelCN9:GetValue( 'CN9_MOEDA' ) ) , , "" )
					oJsonResp['current_value']['total']	:= oModelCN9:GetValue( 'CN9_VLATU' )
				
				EndIf 

			ElseIf lReaj

				//-- Erro na inclusao
				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )

			EndIf

		Else
			//-- Erro na ativacao do modelo
			lRet := .F.
			oJsonResp['code'] := 403
			oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
			
		EndIf

		//-------------------------------------------------------------------
		// Destroi o modelo
		//-------------------------------------------------------------------
		oModel:Destroy()

	ElseIf lRet

		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0036 )

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} POST / contracts / contractId / rev / restart
Reinicia um contrato paralisado

@param	body		, json , campos do contrato

@return cResponse	, json , informa erro ou sucesso na operacao

@author		jose.delmondes
@since		22/01/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD POST rein PATHPARAM contractID, rev WSREST WSCNTA300

	Local cBody		:= ""
	Local cJsonResp	:= ""
	Local cNovaRev 	:= ""
	Local cTipRev	:= SuperGetMV( 'MV_GCTRVRN', .F., '' )

	Local lRet		:= .T.

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()
	Local oModel	:= Nil
	Local oModelCN9	:= Nil

	//-------------------------------------------------------------------
	// Tratamento para quando o contrato nao possui revisao
	//-------------------------------------------------------------------
	If val(Self:rev) == 0
		Self:rev := space( TamSX3('CN9_REVISA')[1] ) 
	EndIf

	cBody	:= Self:GetContent()

	//-- inicializa objeto json com o contrato 
	If !Empty( cBody )
		FWJsonDeserialize( cBody , @oJsonReqst ) 
	EndIf

	dbSelectArea('CN9')
	dbSetOrder(1)
	
	If Empty(cTipRev)
		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0054 )
	EndIf
	
	If lRet .And. CN9->( dbSeek( xFilial('CN9') + Self:contractID + Self:rev) )
		
		//-- Seta o tipo de revisao
		A300STpRev("6")
		
		//-- inicializa o modelo do contrato
		If CN9->CN9_ESPCTR == '1'
			oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
		Else
			oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
		EndIf

		oModel:SetOperation( MODEL_OPERATION_INSERT ) //-- Seta operacao de inclusao
	
		If oModel:Activate( .T. )	//-- Ativa o modelo

			//-- Carrega submodelos
			oModelCN9 := oModel:GetModel( 'CN9MASTER' )
		
			//--Cabecalho do contrato
			oModelCN9:LoadValue('CN9_TIPREV',cTipRev)
			oModelCN9:LoadValue('CN9_JUSTIF',"Reinício do contrato.")
			
			If oModel:VldData() .And. oModel:CommitData()	
			
				//-- Aprovacao da revisao
				
				If Empty( oModelCN9:GetValue( 'CN9_APROV' ) ) .And. oJsonReqst:approval
					
					cNovaRev := oModelCN9:GetValue('CN9_REVISA')
					
					dbSelectArea('CN9')
					dbSetOrder(1)
					CN9->( dbSeek( xFilial('CN9') + Self:contractID + cNovaRev) )
					
					A300SATpRv( Cn300RetSt( "TIPREV" , , , CN9->CN9_NUMERO , CN9->CN9_FILCTR , .F. ) )
					
					//-- inicializa o modelo do contrato
					If CN9->CN9_ESPCTR == '1'
						oModel := FWLoadModel( 'CNTA300' )	//-- Contrato de compra
					Else
						oModel := FWLoadModel( 'CNTA301' )	//-- Contrato de venda
					EndIf

					oModel:SetOperation( MODEL_OPERATION_UPDATE ) //-- Seta operacao de alteracao
					
					oModel:Activate( )	//-- Ativa o modelo
					
					If !( oModel:VldData() .And. oModel:CommitData())
						//-- Erro na aprovacao
						lRet := .F.
						oJsonResp['code'] := 403
						oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
					EndIf					
					
				EndIf
				
				If lRet
					
					//-- Alteracao realizada com sucesso
					oJsonResp['code'] := 200
					oJsonResp['contract_number'] := oModelCN9:GetValue( 'CN9_NUMERO' )
					oJsonResp['revision'] := oModelCN9:GetValue( 'CN9_REVISA' )
					oJsonResp['restart_date']	:= DTOS( oModelCN9:GetValue( 'CN9_DTREIN' ) ) 
				
				EndIf 

			Else

				//-- Erro na inclusao
				lRet := .F.
				oJsonResp['code'] := 403
				oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )

			EndIf

		Else
			//-- Erro na ativacao do modelo
			lRet := .F.
			oJsonResp['code'] := 403
			oJsonResp['message']	:= EncodeUTF8( oModel:GetErrorMessage()[6] )
			
		EndIf

		//-------------------------------------------------------------------
		// Destroi o modelo
		//-------------------------------------------------------------------
		oModel:Destroy()

	ElseIf lRet

		lRet := .F.
		oJsonResp['code'] := 403
		oJsonResp['message']	:= EncodeUTF8( STR0036 )

	EndIf

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
	If lRet
   		Self:SetResponse( cJsonResp )
	Else
		SetRestFault( oJsonResp['code'] , oJsonResp['message'] , .T. )
	EndIf

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300Rev( cNumero )
Verifica se o contrato possui revisão em elaboracao

@param	cNumero		, caracter 	, numero do contrato

@return lRet		, logico 	, informa se o contrato possui revisao em aberto

@author		jose.delmondes
@since		31/01/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300Rev( cNumero )
	
	Local aArea := GetArea()
	Local lRet := .F.
	Local cAliasQry := GetNextAlias()
	
	BEGINSQL Alias cAliasQry
	
		SELECT 	CN9.CN9_REVISA
		FROM 	%table:CN9% CN9
		WHERE 	CN9.%NotDel% AND
				CN9.CN9_FILIAL = %xFilial:CN9% AND
				CN9.CN9_NUMERO = %exp:cNumero% AND
				CN9.CN9_SITUAC IN ('09','04','A')
	
	ENDSQL
	
	If  ( cAliasQry )->( ! Eof( ) )
		lRet := .T.
	EndIf
	
	( cAliasQry )->( DBCloseArea( ) )
	
	RestArea( aArea )
	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300AltPl( cTipo )
Verifica se a planilha pode ser editada

@param	cTipo		, caracter 	, tipo da planilha

@return lRet		, logico 	, informa se a planilha pode ser editada

@author		jose.delmondes
@since		01/02/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300AltPl( cTipo )
	
	Local aArea := GetArea()
	Local aAreaCNL := {}
	Local lRet := .F.
	
	dbSelectArea("CNL")
	aAreaCNL := CNL->( GetArea() )
	CNL->( dbSetOrder(1) )
	
	If CNL->( dbSeek( xFilial("CNL") + cTipo ) )
		
		If CNL->CNL_MEDEVE == '2' .And. CNL->CNL_CROFIS == '2' .And. CNL->CNL_CROCTB == '2' .Or.; //-- fixa com cronograma financeiro
		   CNL->CNL_CTRFIX == '1' .And. CNL->CNL_MEDEVE == '1' .Or.; //-- fixa sem cronograma financeiro
		   CNL->CNL_CTRFIX == '2' .And. CNL->CNL_VLRPRV == '1' .Or.; //-- flex com previsão financeira
		   CNL->CNL_CTRFIX == '2' //-- flex sem previsão financeira
			
		   lRet := .T.
		   
		EndIf
		
	EndIf

	RestArea( aAreaCNL )
	RestArea( aArea )
	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / natures
Retorna a lista de naturezas financeiras.

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		byId			, logico, indica se deve filtrar apenas pelo codigo

@return cResponse		, caracter, JSON contendo a lista de naturezas

@author		jose.delmondes
@since		11/02/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET classes WSRECEIVE searchKey, page, pageSize WSREST WSCNTA300

    Local aListNat		:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJsonNat		:= ''
	Local cSearch		:= ''
	Local cWhere		:= "AND SED.ED_FILIAL = '"+xFilial('SED')+"'"
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJsonNat	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId		:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		If self:byId
			cSearch := Upper( Self:SearchKey )
			cWhere  += " AND SED.ED_CODIGO = '"	+ cSearch + "'"
		Else
			cSearch := Upper( Self:SearchKey )
			cWhere  += " AND ( SED.ED_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere  += " SED.ED_DESCRIC LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " SED.ED_DESCRIC LIKE '%" + FwNoAccent( cSearch ) + "%')"
		EndIf
	EndIf
	
	dbSelectArea('SED')
	If SED->( Columnpos('ED_MSBLQL') > 0 )
		cWhere += " AND SED.ED_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar condições de pagamento
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	SED.ED_CODIGO, SED.ED_DESCRIC
		FROM 	%table:SED% SED
		WHERE 	SED.%NotDel%
		%exp:cWhere%
		ORDER BY ED_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJsonNat['hasNext'] := .T.
		Else
			oJsonNat['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonNat['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de condicoes de pagamento
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++
			aAdd( aListNat , JsonObject():New() )

			aListNat[nAux]['id']	:= ( cAliasQry )->ED_CODIGO
			aListNat[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->ED_DESCRIC ) )
			
			If Len(aListNat) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJsonNat['classes'] := aListNat
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonNat:= FwJsonSerialize( oJsonNat )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonNat)
	
	Self:SetResponse( cJsonNat ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} WS300Docs( cContra, cRev )
Retorna lista de documentos anexados ao contrato

@param	cContra		, caracter 	, numero do contrato
		cRev		, caracter  , numero da revisao

@return aList		, array 	, array com os documentos anexados ao contrato

@author		jose.delmondes
@since		12/02/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS300Docs( cContra )
	
	Local aList	:= {} 
	
	Local cAliasQry	:= GetNextAlias()
	
	Local nAux	:= 0

	//-------------------------------------------------------------------
	// Query para selecionar os documentos
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	ACB.ACB_CODOBJ, ACB.ACB_OBJETO, ACB.ACB_DESCRI
		
		FROM 	%table:ACB% ACB
		
		INNER JOIN %table:AC9% AC9 ON 	AC9.AC9_CODOBJ = ACB.ACB_CODOBJ AND
										AC9.AC9_FILIAL = ACB.ACB_FILIAL AND
										AC9.AC9_ENTIDA = 'CN9' AND
										AC9.AC9_CODENT = %exp:cContra% AND
										AC9.%NotDel%

		WHERE	ACB.ACB_FILIAL = %xFilial:ACB% AND	
				ACB.%NotDel%
					
	ENDSQL

	//-------------------------------------------------------------------
	// Alimenta array de documentos
	//-------------------------------------------------------------------
	While ( cAliasQry )->( !Eof() ) 
		
		nAux++		
		aAdd( aList , JsonObject():New() )
			
		aList[nAux]['id']	:= ( cAliasQry )->ACB_CODOBJ
		aList[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->ACB_OBJETO ) )
		
		( cAliasQry )->( DBSkip() )
		
	End
	
Return aList

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / accPlan 
Retorna lista com os codigos dos planos contabeis

@param	Nao possui

@return cResponse	, json , lista com os codigos dos planos contabeis

@author		jose.delmondes
@since		07/03/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET accPlan WSRECEIVE searchKey, page, pageSize WSREST WSCNTA300
	
	Local aListEnt	:= {}
	Local aEntidades := CTBEntArr()
	
	Local cJsonEnt	:= ''
	
	Local lRet	:= .T.
	
	Local nX
	
	Local oJsonEnt	:= JsonObject():New() 
		
	For nX := 1 to Len(aEntidades)
		aAdd( aListEnt , JsonObject():New() )			
		aListEnt[nX]['id']	:= aEntidades[nX]
	Next nX

	oJsonEnt['accountingPlans'] := aListEnt
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonEnt:= FwJsonSerialize( oJsonEnt )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonEnt)
	
	self:SetResponse( cJsonEnt ) //-- Seta resposta

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / accountingEntities / {plan}
Retorna as entidades contabeis de acordo com o plano de contas informado

@param	SearchKey		, caracter, chave de pesquisa utilizada em diversos campos
		Page			, numerico, numero da pagina 
		PageSize		, numerico, quantidade de registros por pagina
		plan			, caracter, plano de contas

@return cResponse		, caracter, JSON contendo a lista de entidades contabeis

@author		jose.delmondes
@since		01/10/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET accEnt WSRECEIVE searchKey, page, pageSize, byId PATHPARAM plan WSREST WSCNTA300
	
	Local aList			:= {}
	
	Local cAliasQry		:= GetNextAlias()
	Local cJson			:= ''
	Local cSearchKey	:= ''
	Local cSearch		:= ''
	lOCAL cCodVazio		:= Space(TAMSX3('CV0_CODIGO')[1])
	Local cWhere		:= "CV0.CV0_FILIAL = '"+xFilial('CV0')+"' AND CV0.CV0_BLOQUE <> '1' "
	
	Local lRet	:= .T.
	
	Local nCount		:= 0
	Local nStart 		:= 1
	Local nReg 			:= 0
	Local nAux			:= 0
	
	Local oJson	:= JsonObject():New() 
		
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 20 
	Default self:byId		:= .F.
	
	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := Upper( self:searchKey )
		If self:byId
			cWhere  += " AND CV0.CV0_CODIGO = '" + cSearch + "'"
		Else
			cWhere  += " AND ( CV0.CV0_CODIGO LIKE '%"	+ cSearch + "%' OR "
			cWhere	+= " CV0.CV0_DESC LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " CV0.CV0_DESC LIKE '%" + cSearch + "%' ) "
		EndIf
	EndIf
	
	dbSelectArea('CV0')
	If CV0->( Columnpos('CV0_MSBLQL') > 0 )
		cWhere += " AND CV0.CV0_MSBLQL <> '1'"
	EndIf
	
	cWhere := '%'+cWhere+'%'
	
	//-------------------------------------------------------------------
	// Query para selecionar indices de reajuste
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasQry
	
		SELECT 	CV0.CV0_CODIGO, CV0.CV0_DESC
		FROM 	%table:CV0% CV0
		WHERE 	CV0.%NotDel% AND
				CV0.CV0_PLANO = %exp:self:plan% AND
				CV0.CV0_CODIGO <> %exp:cCodVazio% AND
				%exp:cWhere%
		ORDER BY CV0_CODIGO
	
	ENDSQL
	
	If ( cAliasQry )->( ! Eof() )
		
		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord
		
		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf
		
		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAliasQry )->( DBGoTop() )
		
		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg  > self:pageSize
			oJson['hasNext'] := .T.
		Else
			oJson['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJson['hasNext'] := .F.
	EndIf
		
	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasQry )->( ! Eof() ) 
		
		nCount++
		
		If nCount >= nStart
			
			nAux++		
			aAdd( aList , JsonObject():New() )
			
			aList[nAux]['id']	:= ( cAliasQry )->CV0_CODIGO
			aList[nAux]['description']	:= Alltrim( EncodeUTF8( ( cAliasQry )->CV0_DESC ) )
			
			If Len(aList) >= self:pageSize
				Exit
			EndIf
			
		EndIf
		
		( cAliasQry )->( DBSkip() )
		
	End
	
	( cAliasQry )->( DBCloseArea() )
	
	oJson['accountingEntities'] := aList
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJson:= FwJsonSerialize( oJson )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJson)
	
	Self:SetResponse( cJson ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} POST /api/protheus/wscnta300/v1/coins/{coin}/rates
Retorna as taxas da moeda para as datas solicitadas

@param	body		, json , campos do contrato

@return cResponse	, json , taxas da moeda

@author		jose.delmondes
@since		22/01/2019
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD POST coinRate PATHPARAM coin WSREST WSCNTA300

	Local aRates	:= {}
	
	Local cBody		:= ""
	Local cJsonResp	:= ""

	Local lRet		:= .T.
	
	Local nX	:= 0

	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()
	Local oModel	:= Nil
	Local oModelCN9	:= Nil

	cBody	:= Self:GetContent()

	//-- inicializa objeto json com o contrato 
	If !Empty( cBody )
		FWJsonDeserialize( cBody , @oJsonReqst ) 
	EndIf
	
	For nX := 1 To Len( oJsonReqst:reference_dates )
		
		aAdd( aRates , JsonObject():New() )
		
		aRates[nX]['date'] := oJsonReqst:reference_dates[nX]:date
		aRates[nX]['rate'] := Posicione('SM2', 1, STOD(oJsonReqst:reference_dates[nX]:date), 'M2_MOEDA'+ self:coin )
		
	Next nX
	
	oJsonResp['coin_rates'] := aRates
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
   	Self:SetResponse( cJsonResp )

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )

Return lRet
