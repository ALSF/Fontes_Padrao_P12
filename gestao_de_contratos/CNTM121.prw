#INCLUDE "PROTHEUS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE 'FWMVCDef.ch'
#INCLUDE "CNTM121.CH"
 
//------------------------------------------------------------------------------
/*/{Protheus.doc} WSCNTA121

Classe responsavel por retornar os dados das medicoes para o app do SIGAGCT

@author	jose.delmondes
@since		13/12/2017
@version	12.1.17
/*/
//------------------------------------------------------------------------------
WSRESTFUL WSCNTA121 DESCRIPTION STR0001
 	
 	WSDATA page					AS INTEGER	OPTIONAL
	WSDATA pageSize 			AS INTEGER	OPTIONAL
	WSDATA searchKey 			AS STRING	OPTIONAL
 	WSDATA userID				AS STRING
 	WSDATA key					AS STRING
 	WSDATA approval_status 	AS STRING
 	
	WSMETHOD GET measurements DESCRIPTION STR0002 WSSYNTAX "/measurements"  PATH 'measurements' PRODUCES APPLICATION_JSON //-- Retorna lista de medicoes disponiveis para aprovacao.
	WSMETHOD GET totPending	  DESCRIPTION STR0005 WSSYNTAX "/api/protheus/wscnta121/v1/measurements/pending/total" PATH "api/protheus/wscnta121/v1/measurements/pending/total" PRODUCES APPLICATION_JSON //-- Retorna o total de medições pendentes
	WSMETHOD GET listPending  DESCRIPTION STR0006 WSSYNTAX "/api/protheus/wscnta121/v1/measurements/pending" PATH "api/protheus/wscnta121/v1/measurements/pending" PRODUCES APPLICATION_JSON //-- Retorna lista de medições pendentes
	WSMETHOD PUT updateDoc    DESCRIPTION STR0004 WSSYNTAX "/measurements/{key}/approval_status" PATH "measurements/{key}/approval_status" PRODUCES APPLICATION_JSON //-- Aprovação ou rejeição de medição.
	
END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / measurements
Retorna a lista de medicoes disponiveis para aprovacao

@param		SearchKey	, caracter	, chave de pesquisa utilizada em diversos campos
@param		Page		, numerico	, numero da pagina 
@param		PageSize	, numerico	, quantidade de registros por pagina

@return 	cResponse	, caracter	, JSON contendo a lista de medicoes

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET measurements WSRECEIVE searchKey, page, pageSize WSREST WSCNTA121

	Local aListMed	:= {}
	
	Local cAliasSCR	:= GetNextAlias()
	Local cUserId	:= __cUserId 
	Local cMessage	:= "Internal Server Error"
	Local cJsonMed	:= ''
	
	Local lRet		:= .T.
	Local lHasNext	:= .F.
	
	Local oJsonMed	:= JsonObject():New() 
	
	Local nStatusCode	:= 500
	Local nStart		:= 1
	Local nReg			:= 0
	Local nCount		:= 0
	
	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 10 
	
	//-------------------------------------------------------------------
	// Seleciona documentos do tipo MD e IM pentendes para aprovacao
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasSCR
	
		SELECT	SCR.CR_NUM, SCR.CR_TIPO, SCR.CR_MOEDA, SCR.CR_TOTAL
		
		FROM 	%table:SCR% SCR
		
		WHERE	SCR.CR_USER = %exp:cUserId% AND
				SCR.CR_STATUS = '02' AND
				SCR.CR_TIPO IN ('MD','IM') AND
				SCR.CR_FILIAL = %xFilial:SCR% AND
				SCR.%NotDel%
	
	ENDSQL
	
	//-------------------------------------------------------------------
	// nStart -> primeiro registro da pagina
	//-------------------------------------------------------------------
	If self:page > 1
		nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
	EndIf

	//-------------------------------------------------------------------
	// Monta array com medicoes
	//-------------------------------------------------------------------
	While ( cAliasSCR )->( ! Eof() ) 
	
		If !Empty( self:searchKey ) .And. !WS121FilMd( ( cAliasSCR )->CR_NUM , self:searchKey )
			( cAliasSCR )->( DBSkip() )
			Loop
		EndIf
			
		nCount++
		
		If nCount >= nStart //-- Inicio de pagina
	
			aAdd( aListMed , WS121GetMd( ( cAliasSCR )->CR_NUM , ( cAliasSCR )->CR_TIPO , ( cAliasSCR )->CR_MOEDA , ( cAliasSCR )->CR_TOTAL ) )
			
		EndIf

		( cAliasSCR )->( DBSkip() )
		
		If Len(aListMed) >= self:pageSize	//-- Fim de pagina
			Exit
		EndIf
		
	End

	//-------------------------------------------------------------------
	// Valida a exitencia de mais paginas
	//-------------------------------------------------------------------
	If	!Empty( self:searchKey )
		
		//-------------------------------------------------------------------
		// Verifica existencia de medicoes compativeis com filtro
		//-------------------------------------------------------------------
		While ( cAliasSCR )->( ! Eof() ) 
			
			If WS121FilMd( ( cAliasSCR )->CR_NUM , self:searchKey )	
				oJsonMed['hasNext'] := .T.	
				lHasNext	:= .T.
				Exit			
			EndIf
			
			( cAliasSCR )->( DBSkip() )
		End
		
		If !lHasNext 	
			oJsonMed['hasNext'] := .F.
		EndIf
		
	Else
		
		If ( cAliasSCR )->( ! Eof() )
			oJsonMed['hasNext'] := .T.
		Else
			oJsonMed['hasNext'] := .F.
		EndIf
		
	EndIf 
	
	( cAliasSCR )->( DBCloseArea() )
	
	//-------------------------------------------------------------------
	// Alimenta JSON com lista de medicoes
	//-------------------------------------------------------------------
	oJsonMed['measurements']	:= aListMed
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonMed:= FwJsonSerialize( oJsonMed )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonMed )
	
	Self:SetResponse( cJsonMed ) //-- Seta resposta

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / measurements / pending 
Retorna lista total de medições pendentes

@param		SearchKey	, caracter	, chave de pesquisa utilizada em diversos campos
@param		Page		, numerico	, numero da pagina 
@param		PageSize	, numerico	, quantidade de registros por pagina

@return 	cResponse	, caracter	, JSON contendo as medicoes pendentes

@author	jose.delmondes
@since		09/08/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET listPending WSRECEIVE searchKey, page, pageSize WSREST WSCNTA121

	Local lRet	:= .T.

	Local aGrupos	:= {}
	Local aListMed	:= {}

	Local cAliasQRY	:= GetNextAlias()
	Local cDataBase := DtoS( dDataBase )
	Local cJsonMed  := ''
	Local cCodUsr	:= __cUserId
	Local cGrupos	:= ''
	Local cQuery	:= ''
	Local cQuery1	:= ''
	Local cQuery2	:= ''
	Local cQuery3	:= ''
	Local cQuery4	:= ''
	Local cQuery5	:= ''
	Local cQuery6	:= ''
	Local cQuery7	:= ''

	Local nStart	:= 1
	Local nCount	:= 0
	Local nAux		:= 0
	Local nX 		:= 0

	Local oJsonMed	:= JsonObject():New() 

	Default self:searchKey 	:= ''
	Default self:page		:= 1
	Default self:pageSize	:= 10 

	aGrupos := UsrRetGrp( UsrRetName( cCodUsr ) )

	For nX := 1 to len( aGrupos )
		cGrupos += "'" + aGrupos[nX] + "',"
	Next
	
	cGrupos := SubStr( cGrupos , 1 , len( cGrupos ) -1 )
	
	cQuery1 += "SELECT CNF_CONTRA, CNF_NUMPLA, CNF_COMPET, CNF_PRUMED, CNF_SALDO, CNF_NUMERO, CNF_PARCEL, "
	cQuery1 += "CN9_TPCTO, CN9_MOEDA, CNA_TIPPLA, CNA_VLTOT, CN1_DESCRI, CNL_DESCRI "
	
	cQuery1 += "FROM " + RetSQLName("CNF") + " CNF "
	
	cQuery1 += "INNER JOIN " + RetSQLName("CNA") + " CNA ON "
	cQuery1 += "CNA.CNA_CONTRA = CNF.CNF_CONTRA AND "
	cQuery1 += "CNA.CNA_REVISA = CNF.CNF_REVISA AND "
	cQuery1 += "CNA.CNA_NUMERO = CNF.CNF_NUMPLA AND "
	cQuery1 += "CNA.CNA_CRONOG = CNF.CNF_NUMERO AND "
	cQuery1 += "CNA.CNA_FILIAL = CNF.CNF_FILIAL AND "
	cQuery1 += "CNA.D_E_L_E_T_ = ' ' "

	cQuery1 += "INNER JOIN " + RetSQLName("CN9") + " CN9 ON "
	cQuery1 += "CN9.CN9_NUMERO = CNF.CNF_CONTRA AND "
	cQuery1 += "CN9.CN9_REVISA = CNF.CNF_REVISA AND "
	cQuery1 += "CN9.CN9_FILIAL = CNF.CNF_FILIAL AND "
	cQuery1 += "CN9.CN9_SITUAC = '05' AND "
	cQuery1 += "CN9.D_E_L_E_T_ = ' ' "

	cQuery2 += " AND CN9.CN9_VLDCTR = '2' "		//-- Sem controle de permissao
	
	cQuery3 += " AND CN9.CN9_VLDCTR IN( ' ' , '1' ) "	//-- Com controle de permissao 

	cQuery4 += "INNER JOIN " + RetSQLName("CN1") + " CN1 ON "
	cQuery4 += "CN1.CN1_FILIAL = '" + xFilial("CN1") + "' AND "
	cQuery4 += "CN1.CN1_CODIGO = CN9.CN9_TPCTO AND "
	cQuery4 += "CN1.D_E_L_E_T_ = ' ' "

	cQuery4 += "INNER JOIN " + RetSQLName("CNL") + " CNL ON "
	cQuery4 += "CNL.CNL_FILIAL = '" + xFilial("CNL") + "' AND "
	cQuery4 += "CNL.CNL_CODIGO = CNA.CNA_TIPPLA AND "
	cQuery4 += "CNL.D_E_L_E_T_ = ' ' "

	//-- Filtra permissao ( Controle Total ou Visualizacao do Contrato)
	cQuery5 += "INNER JOIN " +RetSQLName("CNN") + " CNN ON "
	cQuery5 += "CNN.CNN_FILIAL = '" + xFilial("CNN") + "' AND "
	cQuery5 += "CNN.CNN_CONTRA = CN9.CN9_NUMERO AND "
	
	If Empty(cGrupos)
		cQuery5 += "CNN.CNN_USRCOD = '" + cCodUsr + "' AND "
	Else	
		cQuery5 += "( CNN.CNN_USRCOD = '" + cCodUsr + "' OR CNN.CNN_GRPCOD IN ("+ cGrupos +") ) AND "
	EndIf
	
	cQuery5 += "CNN.CNN_TRACOD IN ( '001' , '037' )  AND "
	cQuery5 += "CNN.D_E_L_E_T_ = ' ' "

	cQuery6 += "WHERE CNF.CNF_FILIAL = '" + xFilial("CNF") + "' AND "
	cQuery6 += "CNF_PRUMED < '"+cDataBase+"' AND "
	cQuery6 += "CNF_DTREAL = '"+Space(TAMSX3("CNF_DTREAL")[1])+"' AND "
	cQuery6 += "CNF.D_E_L_E_T_ = ' ' "

	If !Empty(self:searchKey)	//-- Chave de busca do usuario
		cSearch := AllTrim( Upper( Self:SearchKey ) ) //-- Busca com acentuacao
		cQuery6 += " AND ( CNF.CNF_CONTRA LIKE '%"	+ cSearch + "%' OR "
		cQuery6 += " CNF.CNF_NUMPLA LIKE '%" + cSearch + "%' OR "
		cQuery6 += " CN1.CN1_DESCRI LIKE '%" + cSearch + "%' OR "
		cQuery6 += " CN1.CN1_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		cQuery6 += " CNL.CNL_DESCRI LIKE '%" + cSearch + "%' OR "
		cQuery6 += " CNL.CNL_DESCRI LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		cQuery6 += " CNF.CNF_COMPET LIKE '%" + cSearch + "%' OR "
		cQuery6 += " CNF.CNF_PRUMED LIKE '%" + cSearch + "%' ) " 
	EndIf
	
	cQuery7 += "ORDER BY CNF.CNF_PRUMED, CNF.CNF_CONTRA, CNF.CNF_NUMERO, CNF.CNF_PARCEL"

	cQuery := cQuery1 + cQuery3 + cQuery4 + cQuery5 + cQuery6	//-- Contratos com controle de permissao 
	cQuery += " UNION "
	cQuery += cQuery1 + cQuery2 + cQuery4 + cQuery6	//-- Contratos sem controle de permissao
	cQuery += cQuery7 //-- Order By

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasQRY,.F.,.T.)

	//-------------------------------------------------------------------
	// nStart -> primeiro registro da pagina
	//-------------------------------------------------------------------
	If self:page > 1
		nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
	EndIf

	//-------------------------------------------------------------------
	// Monta array com medicoes
	//-------------------------------------------------------------------
	While ( cAliasQRY )->( ! Eof() ) 

		nCount++
		
		If nCount >= nStart //-- Inicio de pagina
	
			nAux++		
			aAdd( aListMed , JsonObject():New() )
			
			aListMed[nAux]['contract_number']	:= ( cAliasQRY )->CNF_CONTRA
			aListMed[nAux]['contract_description']	:= Alltrim( EncodeUTF8( ( cAliasQRY )->CN1_DESCRI ) )
			aListMed[nAux]['spreadsheet_number']	:= ( cAliasQRY )->CNF_NUMPLA
			aListMed[nAux]['spreadsheet_description'] := Alltrim( EncodeUTF8( ( cAliasQRY )->CNL_DESCRI ) )
			aListMed[nAux]['competence']	:= ( cAliasQRY )->CNF_COMPET
			aListMed[nAux]['expiring_date']	:= ( cAliasQRY )->CNF_PRUMED
			aListMed[nAux]['balance']	:= JsonObject():New() 
			aListMed[nAux]['balance']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasQRY )->CN9_MOEDA ) , , "" )
			aListMed[nAux]['balance']['total']	:= ( cAliasQRY )->CNF_SALDO 
			aListMed[nAux]['current_value']	:= JsonObject():New() 
			aListMed[nAux]['current_value']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( (cAliasQRY )->CN9_MOEDA ) , , "" )
			aListMed[nAux]['current_value']['total']	:= ( cAliasQRY )->CNA_VLTOT 

		EndIf

		( cAliasQRY )->( DBSkip() )
		
		If Len(aListMed) >= self:pageSize	//-- Fim de pagina
			Exit
		EndIf
		
	End

	//-------------------------------------------------------------------
	// Lista de medicoes pendentes
	//-------------------------------------------------------------------
	oJsonMed['measurements'] := aListMed

	//-------------------------------------------------------------------
	// Valida a exitencia de mais paginas
	//-------------------------------------------------------------------
	If ( cAliasQRY )->( ! Eof() )
		oJsonMed['hasNext'] := .T.
	Else
		oJsonMed['hasNext'] := .F.
	EndIf
	
	( cAliasQRY )->( dbCloseArea() )

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonMed:= FwJsonSerialize( oJsonMed )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonMed )
	
	//-------------------------------------------------------------------
	// Seta Resposta
	//-------------------------------------------------------------------
	Self:SetResponse( cJsonMed ) 

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} GET / measurements / pending / total
Retorna o total de medições pendentes

@return 	cResponse	, caracter	, JSON contendo O total de medicoes pendentes

@author	jose.delmondes
@since		09/08/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD GET totPending WSREST WSCNTA121

	Local aGrupos	:= {}
	
	Local lRet	:= .T.

	Local cAliasQRY	:= GetNextAlias()
	Local cDataBase := DtoS( dDataBase )
	Local cJsonMed  := ''
	Local cCodUsr	:= __cUserId
	Local cGrupos	:= ''
	Local cQuery	:= ''
	Local cQuery1	:= ''
	Local cQuery2	:= ''
	Local cQuery3	:= ''
	Local cQuery4	:= ''
	Local cQuery5	:= ''
	Local cQuery6	:= ''
	
	Local nX 		:= 0
	Local nTotal	:= 0

	Local oJsonMed	:= JsonObject():New() 
	
	aGrupos := UsrRetGrp( UsrRetName( cCodUsr ) )

	For nX := 1 to len( aGrupos )
		cGrupos += "'" + aGrupos[nX] + "',"
	Next
	
	cGrupos := SubStr( cGrupos , 1 , len( cGrupos ) -1 )
	
	cQuery1 += "SELECT COUNT( CNF_NUMERO ) TOTAL "
	
	cQuery1 += "FROM " + RetSQLName("CNF") + " CNF "
	
	cQuery1 += "INNER JOIN " + RetSQLName("CNA") + " CNA ON "
	cQuery1 += "CNA.CNA_CONTRA = CNF.CNF_CONTRA AND "
	cQuery1 += "CNA.CNA_REVISA = CNF.CNF_REVISA AND "
	cQuery1 += "CNA.CNA_NUMERO = CNF.CNF_NUMPLA AND "
	cQuery1 += "CNA.CNA_CRONOG = CNF.CNF_NUMERO AND "
	cQuery1 += "CNA.CNA_FILIAL = CNF.CNF_FILIAL AND "
	cQuery1 += "CNA.D_E_L_E_T_ = ' ' "

	cQuery1 += "INNER JOIN " + RetSQLName("CN9") + " CN9 ON "
	cQuery1 += "CN9.CN9_NUMERO = CNF.CNF_CONTRA AND "
	cQuery1 += "CN9.CN9_REVISA = CNF.CNF_REVISA AND "
	cQuery1 += "CN9.CN9_FILIAL = CNF.CNF_FILIAL AND "
	cQuery1 += "CN9.CN9_SITUAC = '05' AND "
	cQuery1 += "CN9.D_E_L_E_T_ = ' ' "

	cQuery2 += " AND CN9.CN9_VLDCTR = '2' "		//-- Sem controle de permissao
	
	cQuery3 += " AND CN9.CN9_VLDCTR IN( ' ' , '1' ) "	//-- Com controle de permissao 

	cQuery4 += "INNER JOIN " + RetSQLName("CN1") + " CN1 ON "
	cQuery4 += "CN1.CN1_FILIAL = '" + xFilial("CN1") + "' AND "
	cQuery4 += "CN1.CN1_CODIGO = CN9.CN9_TPCTO AND "
	cQuery4 += "CN1.D_E_L_E_T_ = ' ' "

	cQuery4 += "INNER JOIN " + RetSQLName("CNL") + " CNL ON "
	cQuery4 += "CNL.CNL_FILIAL = '" + xFilial("CNL") + "' AND "
	cQuery4 += "CNL.CNL_CODIGO = CNA.CNA_TIPPLA AND "
	cQuery4 += "CNL.D_E_L_E_T_ = ' ' "

	//-- Filtra permissao ( Controle Total ou Visualizacao do Contrato)
	cQuery5 += "INNER JOIN " +RetSQLName("CNN") + " CNN ON "
	cQuery5 += "CNN.CNN_FILIAL = '" + xFilial("CNN") + "' AND "
	cQuery5 += "CNN.CNN_CONTRA = CN9.CN9_NUMERO AND "
	
	If Empty(cGrupos)
		cQuery5 += "CNN.CNN_USRCOD = '" + cCodUsr + "' AND "
	Else	
		cQuery5 += "( CNN.CNN_USRCOD = '" + cCodUsr + "' OR CNN.CNN_GRPCOD IN ("+ cGrupos +") ) AND "
	EndIf
	
	cQuery5 += "CNN.CNN_TRACOD IN ( '001' , '037' )  AND "
	cQuery5 += "CNN.D_E_L_E_T_ = ' ' "

	cQuery6 += "WHERE CNF.CNF_FILIAL = '" + xFilial("CNF") + "' AND "
	cQuery6 += "CNF_PRUMED < '"+cDataBase+"' AND "
	cQuery6 += "CNF_DTREAL = '"+Space(TAMSX3("CNF_DTREAL")[1])+"' AND "
	cQuery6 += "CNF.D_E_L_E_T_ = ' ' "

	cQuery := cQuery1 + cQuery3 + cQuery4 + cQuery5 + cQuery6	//-- Contratos com controle de permissao 
	cQuery += " UNION "
	cQuery += cQuery1 + cQuery2 + cQuery4 + cQuery6	//-- Contratos sem controle de permissao

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry( ,, cQuery ),cAliasQRY,.F.,.T.)
	
	While ( cAliasQRY )->( !Eof() )  
			
		nTotal += (cAliasQRY)->TOTAL
		( cAliasQRY )->( DBSkip() )
	
	End

	(cAliasQRY)->(dbCloseArea())

	//-------------------------------------------------------------------
	// Quantidade total de medicoes pendentes
	//-------------------------------------------------------------------
	oJsonMed['total'] := nTotal

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonMed:= FwJsonSerialize( oJsonMed )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonMed )
	
	//-------------------------------------------------------------------
	// Seta Resposta
	//-------------------------------------------------------------------
	Self:SetResponse( cJsonMed ) 

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} PUT / measurements
Aprovacao e rejeicao de medicoes

@param		key					, caracter	, chave do documento
			approval_status 	, caracter	, JSON contendo o status da aprovacao e a justificativa

@return 	cResponse			, caracter	, JSON contendo mensagem de sucesso ou de erro

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
WSMETHOD PUT updateDoc PATHPARAM key, approval_status WSREST WSCNTA121

	Local lRet		:= .T.
	Local lAprov	:= .F.
	
	Local cJustif	:= ""
	Local cJsonResp	:= ""
	Local cBody		:= ""
	Local cTipo		:= ""
	Local cNumSCR	:= ""		
	
	Local oJsonReqst	:= NIl
	Local oJsonResp		:= JsonObject():New()
	Local oModel094		:= NIl
	
	cBody	:= Self:GetContent()
	
	If !Empty(cBody)
		
		FWJsonDeserialize( cBody , @oJsonReqst ) 
		lAprov		:= oJsonReqst:approval_status 
		cJustif	:= DecodeUTF8( oJsonReqst:Justification )
		
		cTipo := Left( self:key , TamSX3('CR_TIPO')[1] )
		cNumSCR	:= PadR( SubStr( self:key , TamSX3('CR_TIPO')[1] + 1 , TamSX3('CR_NUM')[1] ) , TamSX3('CR_NUM')[1] )
	
	Else
		lRet := .F.
	EndIf
	
	DBSelectArea( 'SCR' )
	SCR->( DBSetOrder( 2 ) )
	
	If lRet .And. SCR->( DBSeek( xFilial('SCR') + cTipo + cNumSCR + __cUserId ) )
	
		If lAprov
			
			A094SetOp( '001' ) //-- Seta operacao de aprovacao de documentos
			
			oModel094 := FWLoadModel('MATA094')
			oModel094:SetOperation(MODEL_OPERATION_UPDATE)
			
			If oModel094:Activate()
				If !Empty( cJustif )
					oModel094:GetModel("FieldSCR"):SetValue( 'CR_OBS' , cJustif )
				EndIf
				
				If oModel094:VldData() 
					oModel094:CommitData()
					oJsonResp['code'] := 200
				Else
					oJsonResp['code'] := 500
					oJsonResp['error']	:= EncodeUTF8( oModel094:GetErrorMessage()[6] )
					oJsonResp['solution']	:= EncodeUTF8( oModel094:GetErrorMessage()[7] )
				EndIf
			Else
				oJsonResp['code'] := 500
				oJsonResp['error']	:= EncodeUTF8( oModel094:GetErrorMessage()[6] )
				oJsonResp['solution']	:= EncodeUTF8( oModel094:GetErrorMessage()[7] )
			EndIf
				
		Else
		
			A094SetOp( '005' ) //-- Seta operacao de aprovacao de documentos
			
			oModel094 := FWLoadModel('MATA094')
			oModel094:SetOperation(MODEL_OPERATION_UPDATE)
			
			If oModel094:Activate()
				
				oModel094:GetModel("FieldSCR"):SetValue( 'CR_OBS' , cJustif )
				
				If oModel094:VldData() 
					oModel094:CommitData()
					oJsonResp['code'] := 200
				Else
					oJsonResp['code'] := 500
					oJsonResp['error']	:= EncodeUTF8( oModel094:GetErrorMessage()[6] )
					oJsonResp['solution']	:= EncodeUTF8( oModel094:GetErrorMessage()[7] )
				EndIf
			Else
				oJsonResp['code'] := 500
				oJsonResp['error']	:= EncodeUTF8( oModel094:GetErrorMessage()[6] )
				oJsonResp['solution']	:= EncodeUTF8( oModel094:GetErrorMessage()[7] )
			EndIf
		EndIf
	EndIf
	
	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonResp := FwJsonSerialize( oJsonResp )
	
	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj( oJsonResp )
	FreeObj( oJsonReqst )
	
	//-------------------------------------------------------------------
	// Seta resposta
	//-------------------------------------------------------------------
   	Self:SetResponse( cJsonResp )
	
Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} WS121GetMd( cChave , nMoeda, nTotal )
Retorna objeto JSON com os detalhes da medicao

@param		cChave		, caracter	, chave do documento
			cTipo		, caracter	, Tipo de Alcada ( MD , IM )
			nMoeda		, numerico	, moeda do documento ( SCR )
			nTotal		, numerico	, total do documento ( SCR )

@return 	oJsonMed	, objeto	, JSON contendo os detalhes da medicao

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS121GetMd( cChave , cTipo , nMoeda, nTotal )

	Local aArea		:= GetArea( )
	Local aAreaCND	:= {}
	
	Local cNumMed	:= Left( cChave , TamSX3('CND_NUMMED')[1] )
	Local cPlan		:= ''
	Local cAliasCND	:= GetNextAlias()
	
	Local lNewMed	:= .F.
	
	Local oJsonMed	:= JsonObject():New() 
	
	//-------------------------------------------------------------------
	// Define tabela de medicoes como area de trabalho
	//-------------------------------------------------------------------
	DBSelectArea('CND')
	
	aAreaCND := CND->( GetArea( ) )
	
	CND->( DBSetOrder( 4 ) )
	
	//-------------------------------------------------------------------
	// Alimenta objeto Json com os detalhes da medicao
	//-------------------------------------------------------------------
	If CND->( DBSeek( xFilial('CND') + cNumMed ) )
		
		lNewMed	:= IsNewMed( CND->CND_CONTRA , CND->CND_REVISA , cNumMed ) //-- Verifica origem da medicao ( CNTA120 ou CNTA121 )
		
		If cTipo == 'MD'
			cPlan := CND->CND_NUMERO
		Else
			cPlan := substr( cChave , TamSX3('CND_NUMMED')[1] + 1 , TamSX3('CND_NUMERO')[1] )
		EndIf
	
		oJsonMed['number']	:= CND->CND_NUMMED
		oJsonMed['contract']	:= JsonObject():New() 
		oJsonMed['contract']['number']	:= CND->CND_CONTRA
		oJsonMed['contract']['rev']	:= CND->CND_REVISA
		oJsonMed['value']	:= JsonObject():New() 
		oJsonMed['value']['symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( nMoeda ) , , "" )
		oJsonMed['value']['total']	:= nTotal
		oJsonMed['spreadsheet']	:= WS121Plan( CND->CND_NUMMED , CND->CND_CONTRA , CND->CND_REVISA , cPlan , CND->CND_MOEDA , lNewMed , cTipo , cChave )
		oJsonMed['competence']	:= CND->CND_COMPET
		oJsonMed['history']	:= WS121Hist( cChave )
		oJsonMed['key']	:= cTipo + cChave
		
	EndIf
	
	RestArea( aAreaCND )
	RestArea( aArea )
	
Return oJsonMed 

//-------------------------------------------------------------------
/*/{Protheus.doc} WS121Plan( cNumMed , cContra, cRev, lNewMed )
Retorna lista com os itens da medicao

@param		cNumMed		, caracter	, numero da medicao
			cContra		, caracter	, numero do contrato
			cRev		, caracter	, numero da revisao
			nMoeda		, numerico	, moeda da medicao
			cTipo		, caracter	, Tipo de Alcada ( MD , IM )
			cChave		, caracter	, chave do documento

@return 	aListItem	, array		, itens da medicao

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS121Plan( cNumMed , cContra, cRev, cPlan, nMoeda, lNewMed, cTipo , cChave )
	
	Local aListPlan	:= {}
	Local aArea		:= GetArea()
	Local aAreaCNA	:= {}
	
	Local cAliasCXN	:= GetNextAlias()
	Local cFilCNL	:= xFilial( 'CNL' )
  	
  	Local nAux	:= 0
  	
  	If lNewMed	.And. cTipo == 'MD'	//-- Medicao com origem na rotina CNTA121, tipo MD
  		
  		//-------------------------------------------------------------------
		// Seleciona as planilhas da medicao
		//-------------------------------------------------------------------
  		BEGINSQL Alias cAliasCXN
	
		SELECT	CXN.CXN_NUMPLA, CXN.CXN_TIPPLA
				
		FROM 	%table:CXN% CXN
		
		WHERE	CXN.CXN_NUMMED = %exp:cNumMed% AND
				CXN.CXN_CONTRA = %exp:cContra% AND
				CXN.CXN_REVISA = %exp:cRev% AND
				CXN.CXN_FILIAL = %xFilial:CXN% AND
				CXN.%NotDel%
	
		ENDSQL
		
		While ( cAliasCXN )->( ! Eof() ) 
			
			//-------------------------------------------------------------------
			// Preenche lista com as planilhas da medicao
			//-------------------------------------------------------------------
			nAux++		
			
			aAdd( aListPlan , JsonObject():New() )
			
			aListPlan[nAux]['number']	:= ( cAliasCXN )->CXN_NUMPLA
  			aListPlan[nAux]['description']	:= Alltrim( Posicione( 'CNL' , 1 , cFilCNL + ( cAliasCXN )->CXN_TIPPLA , 'CNL_DESCRI' ) )
  			aListPlan[nAux]['items']	:= WS121Item( cNumMed , cContra , cRev , ( cAliasCXN )->CXN_NUMPLA , nMoeda , cTipo , cChave )
	
			( cAliasCXN )->( DBSkip() )
			
		End
		
		( cAliasCXN )->( DBCloseArea() )
  	
  	Else //-- Medicao com origem na rotina CNTA120 ou aprovvacao de itens da medicao ( IM )
  		
  		DBSelectArea( 'CNA' )
  		
  		aAreaCNA := CNA->( GetArea( ) )
  		
  		CNA->( DBSetOrder(1) )
  		
  		//-------------------------------------------------------------------
		// Posiciona na planilha da medicao e preenche lista de planilhas
		//-------------------------------------------------------------------
  		If DBSeek( xFilial('CNA') + cContra + cRev + cPlan )
  			
  			aAdd( aListPlan , JsonObject():New() )
  			
  			aListPlan[1]['number']	:= CNA->CNA_NUMERO
  			aListPlan[1]['description']	:= Alltrim( EncodeUTF8( Posicione( 'CNL' , 1 , cFilCNL + CNA->CNA_TIPPLA , 'CNL_DESCRI' ) ) )
  			aListPlan[1]['items']	:= WS121Item( cNumMed , cContra , cRev , cPlan , nMoeda , cTipo , cChave )
  			
  		EndIf
  		
  		RestArea( aAreaCNA )
   		
  	EndIf
	
	RestArea( aArea )
	
Return aListPlan

//-------------------------------------------------------------------
/*/{Protheus.doc} WS121Item( cNumMed , cContra, cRev, nMoeda)
Retorna lista com os itens da medicao

@param		cNumMed		, caracter	, numero da medicao
			cContra		, caracter	, numero do contrato
			cRev		, caracter	, numero da revisao
			nMoeda		, numerico	, moeda da medicao
			cTipo		, caracter	, Tipo de Alcada ( MD , IM )

@return 	aListItem	, array		, itens da medicao

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS121Item( cNumMed , cContra, cRev, cPlan, nMoeda, cTipo , cChave )
	
	Local aListItem	:= {}
	Local aArea	:= GetArea()
	
	Local cAliasCNE	:= GetNextAlias()
	Local cQuery	:= ''
  	
  	Local nAux	:= 0
	
	//-------------------------------------------------------------------
	// Query para encontrar itens da medicao de uma determinada planilha.
	//-------------------------------------------------------------------
	cQuery := "SELECT DISTINCT CNE.CNE_PRODUT, CNE.CNE_QUANT, CNE.CNE_PDESC, "
	cQuery += "CNE.CNE_VLUNIT, CNE.CNE_VLTOT, CNE.CNE_DTENT "
	
	cQuery	+= "FROM " + RetSQLName("CNE") + " CNE "
	
	If cTipo == 'IM'
		
		cQuery += "INNER JOIN " + RetSQLName("DBM") + " DBM ON "
		cQuery += "DBM.DBM_FILIAL = '" + xFilial("DBM") + "' AND "
		cQuery	+= "DBM.DBM_NUM = '" + cChave + "' AND "
		cQuery	+= "DBM.DBM_USER = '" + __cUserId + "' AND "
		cQuery	+= "DBM.DBM_ITEM = CNE.CNE_ITEM AND 
		cQuery += "DBM.D_E_L_E_T_ = ' ' "
	
	EndIf
	
	cQuery += "WHERE CNE.CNE_FILIAL = '" + xFilial("CNE") + "' AND "
	cQuery += "CNE.CNE_NUMMED = '" + cNumMed + "' AND "
	cQuery += "CNE.CNE_CONTRA = '" + cContra + "' AND "
	cQuery += "CNE.CNE_REVISA = '" + cRev + "' AND "
	cQuery += "CNE.CNE_NUMERO = '" + cPlan + "' AND "
	cQuery += "CNE.D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T. , "TOPCONN" , TcGenQry( , , cQuery ) , cAliasCNE , .F. , .T. )
		
	While ( cAliasCNE )->( ! Eof() ) 
		
		//-------------------------------------------------------------------
		// Preenche lista de itens da medicao
		//-------------------------------------------------------------------
		nAux++		
		
		aAdd( aListItem , JsonObject():New() )
		
		aListItem[nAux]['product_code']	:= Alltrim( ( cAliasCNE )->CNE_PRODUT )
		aListItem[nAux]['product_description']	:= Alltrim( EncodeUTF8( Posicione( 'SB1' , 1 , xFilial('SB1') + ( cAliasCNE )->CNE_PRODUT , 'B1_DESC' ) ) )
		aListItem[nAux]['quantity'] := ( cAliasCNE )->CNE_QUANT
		aListItem[nAux]['discount'] := cValToChar( ( cAliasCNE )->CNE_PDESC ) + "%"
		aListItem[nAux]['unitary_value']	:= ( cAliasCNE )->CNE_VLUNIT
		aListItem[nAux]['total_value']	:= ( cAliasCNE )->CNE_VLTOT
		aListItem[nAux]['value_symbol']	:= SuperGetMv( "MV_SIMB" + cValToChar( nMoeda ) , , "" )
		aListItem[nAux]['delivery_date']	:= ( cAliasCNE )->CNE_DTENT

		( cAliasCNE )->( DBSkip() )
		
	End
	
	( cAliasCNE )->( DBCloseArea() )
	
	RestArea(aArea)
	
Return aListItem

//-------------------------------------------------------------------
/*/{Protheus.doc} WS121Hist( cChave )
Retorna array com historico de aprovacoes

@param		cChave		, caracter	, chave do documento ( CR_NUM )

@return 	aListAprov	, array		, istorico de aprovacoes

@author	jose.delmondes
@since		08/12/2017
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS121Hist( cChave )
	
	Local aListAprov	:= {}
	Local aArea			:= GetArea()
	Local aAreaSCR		:= {}
	
	Local cAliasSCR	:= GetNextAlias()
  	
  	Local nAux	:= 0
	
	//-------------------------------------------------------------------
	// Busca por historico de aprovacoes da medicao
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasSCR
				
		SELECT	SCR.CR_USER, SCR.CR_TIPO
			
		FROM 	%table:SCR% SCR
		
		WHERE	SCR.CR_NUM = %exp:cChave% AND
				SCR.CR_STATUS = '03' AND
				SCR.CR_FILIAL = %xFilial:SCR% AND
				SCR.%NotDel%
	
	ENDSQL
	
	DBSelectArea( 'SCR' )
	
	aAreaSCR := SCR->( GetArea( ) )
	
	SCR->( DBSetOrder( 2 ) )
	
	While ( cAliasSCR )->( ! Eof() ) 
		
		//-------------------------------------------------------------------
		// Alimenta lista de historico de aprovacoes da medicao
		//-------------------------------------------------------------------
		If DBSeek( xFilial('SCR') + ( cAliasSCR )->CR_TIPO + cChave + ( cAliasSCR )->CR_USER )
			
			nAux++		
		
			aAdd( aListAprov , JsonObject():New() )
			
			aListAprov[nAux]['name']	:= Upper( UsrRetName( SCR->CR_USER ) )
			aListAprov[nAux]['date']	:= DTOS( SCR->CR_DATALIB )
			aListAprov[nAux]['justification']	:= Alltrim( EncodeUTF8( SCR->CR_OBS ) )
			
		EndIf

		( cAliasSCR )->( DBSkip() )
		
	End
	
	( cAliasSCR )->( DBCloseArea() )
	
	RestArea( aAreaSCR )
	RestArea( aArea )
	
Return aListAprov

//-------------------------------------------------------------------
/*/{Protheus.doc} WS121FilMd( cChave , cSearchKey )
Verifica se chave de busca se aplica a medicao

@param		cChave			, caracter , chave do documento ( CR_NUM )
			cSearchKey		, caracter , Chave de pesquisa

@return 	lRet 			, Logico	, Verifica se a chave de pesquisa pertence a medicao

@author	jose.delmondes
@since		11/01/2018
@version	12.1.17 
/*/
//-------------------------------------------------------------------
Static Function WS121FilMd( cChave , cSearchKey )

	Local lRet		:= .T.
	Local cNumMed	:= Left( cChave , TamSX3('CND_NUMMED')[1] )
	Local cAliasCND	:= GetNextAlias()
	Local cQuery	:= ""
	
	//-------------------------------------------------------------------
	// Busca por historico de aprovacoes da medicao
	//-------------------------------------------------------------------
	
	cQuery := "SELECT	CND.CND_NUMMED "
	cQuery += "FROM " + RetSQLName("CND") + " CND "
	cQuery += "WHERE CND.CND_NUMMED = '" + cNumMed + "' AND "
	cQuery += "CND.CND_FILIAL = '" + xFilial("CND") + "' AND "
	cQuery += "( CND.CND_NUMMED LIKE '%" + cSearchKey + "%' OR "
	cQuery += "CND.CND_CONTRA LIKE '%" + cSearchKey + "%' ) AND "
	cQuery += "CND.D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T. , "TOPCONN" , TcGenQry( , , cQuery ) , cAliasCND , .F. , .T. )

	If ( cAliasCND )->( Eof() ) 
		lRet := .F.
	EndIf
	
	( cAliasCND )->( DBCloseArea() )

Return lRet
