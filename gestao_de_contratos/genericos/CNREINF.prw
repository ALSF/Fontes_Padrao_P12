#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "CNREINF.CH"

//--------------------------------------------------------------------
/*/{Protheus.doc} CNREINF()
Rotina para informar dados do REINF
@author jose.delmondes
@since 16/04/2018
@version 1.0
@return oView
/*/
//--------------------------------------------------------------------
Function CNREINF( oModel ) 

Local aButtons :=  {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

Private oModel121	:= oModel
Private lCompra		:= CN300RetSt( "COMPRA" , , , oModel:Getvalue( 'CNDMASTER' , 'CND_CONTRA' ) , oModel:Getvalue( 'CNDMASTER' , 'CND_FILCTR' ) , .F. )
Private lVisu	:= oModel:GetOperation() == MODEL_OPERATION_VIEW

If lVisu

	dbSelectArea('CXN')
	dbSetOrder(1)
	dbSeek( xFilial('CXN') + oModel:GetValue('CXNDETAIL','CXN_CONTRA') + oModel:GetValue('CXNDETAIL','CXN_REVISA') + oModel:GetValue('CXNDETAIL','CXN_NUMMED') + oModel:GetValue('CXNDETAIL','CXN_NUMPLA'))
	FWExecView( STR0001 , "CNREINF" , MODEL_OPERATION_VIEW , , {|| .T.} , , 60 )
	
Else

	If CNRNFPC() 
		Help( " " , 1 , "CNRNFPC" ) //-- Opcao nao disponivel para itens que geram pedidos de compra. Para Itens que geram de pedido de compra, os valores referentes a aposentadoria especial devem ser informados no Documento de Entrada.
	Elseif !oModel121:GetModel( 'CXNDETAIL' ):GetValue("CXN_CHECK") .Or.  CNRVLLINCNE()
	     Help('',1,'CNREINFPLAN')
	Else
		FWExecView( STR0001 , "CNREINF" , MODEL_OPERATION_INSERT , , {|| .T.} , , 60 , aButtons )
	EndIf

EndIf

Return
	
//--------------------------------------------------------------------
/*/{Protheus.doc} ViewDef()
Definicao da View
@author jose.delmondes
@since 16/04/2018
@version 1.0
@return oView
/*/
//--------------------------------------------------------------------
Static Function ViewDef()	

Local oModel	:= FwLoadModel('CNREINF')
Local oView		:= FWFormView():New()

Local cCampoCNE := "CNE_ITEM|CNE_PRODUT|CNE_DESCRI|CNE_VLTOT|CNE_15ANOS|CNE_20ANOS|CNE_25ANOS|CNE_TPSERV|"
Local cCampoCXN	:= "CXN_NUMPLA|CXN_DESCRI|" + If( lCompra , "CXN_FORNEC|CXN_LJFORN|" , "CXN_CLIENT|CXN_LJCLI|" )

Local oStruCNE	:= FWFormStruct( 2 , 'CNE' , { |cCampo| AllTrim(cCampo)+'|' $ cCampoCNE } )
Local oStruCXN	:= FWFormStruct( 2 , 'CXN' , { |cCampo| AllTrim(cCampo)+'|' $ cCampoCXN } )	

oView:SetModel(oModel)

oView:AddField( 'VIEW_CXN' , oStruCXN , 'CXNMASTER' )

oView:AddGRID( 'VIEW_CNE' , oStruCNE , 'CNEDETAIL' )	

oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
oView:CreateHorizontalBox( 'INFERIOR' , 80 )

oView:SetOwnerView( 'VIEW_CXN' , 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_CNE' , 'INFERIOR' )

oStruCXN:SetProperty( '*' , MVC_VIEW_CANCHANGE , .F. )
oStruCNE:SetProperty( 'CNE_PRODUT' , MVC_VIEW_CANCHANGE , .F. )
oStruCNE:SetProperty( 'CNE_VLTOT'  , MVC_VIEW_CANCHANGE , .F. )
	
return oView

//--------------------------------------------------------------------
/*/{Protheus.doc} ModelDef()
Definicao do Modelo
@author jose.delmondes
@since 16/04/2018
@version 1.0
@return oModel
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

Local oModel	:= Nil
Local oStruCNE	:= FWFormStruct( 1 , 'CNE' )
Local oStruCXN	:= FWFormStruct( 1 , 'CXN' )
					 
oModel:= MPFormModel():New( "CNREINF" , ,{|oModel|CNRTUDOOK(oModel)} , { || CNRNFGRV(oModel) } )

oModel:AddFields( 'CXNMASTER' , , oStruCXN )

oModel:AddGrid( 'CNEDETAIL' , 'CXNMASTER' , oStruCNE )

If lVisu
	oModel:SetRelation('CNEDETAIL', {{'CNE_FILIAL','xFilial("CNE")'},{'CNE_CONTRA','CXN_CONTRA'},{'CNE_REVISA','CXN_REVISA'},{'CNE_NUMERO','CXN_NUMPLA'},{'CNE_NUMMED','CXN_NUMMED'}},CNE->(IndexKey(1)))
EndIf

oModel:SetActivate( { |oModel| CNRNFACT(oModel) } )
Return oModel


//--------------------------------------------------------------------
/*/{Protheus.doc} CNRNFACT(oModel)
Ativacao do Modelo
@author jose.delmondes
@since 16/04/2018
@version 1.0
@return 
/*/
//-------------------------------------------------------------------
Function CNRNFACT(oModel)

Local aSave121	:= FwSaveRows( oModel121 )
Local aSaveRNF	:= FwSaveRows( oModel )

Local oModelCXN	:= oModel:GetModel( 'CXNMASTER' )
Local oModelCNE	:= oModel:GetModel( 'CNEDETAIL' )
Local oModelITEM := oModel121:GetModel( 'CNEDETAIL' )
Local oModelPLA	:= oModel121:GetModel( 'CXNDETAIL' )
Local lExedent  := IsInCallStack('CN121Exced') .Or. IsInCallStack('CN121ExceC') 

Local nX	:= 0

If lVisu
	Return
EndIf

oModelCXN:LoadValue( 'CXN_NUMPLA' , oModelPLA:GetValue( 'CXN_NUMPLA' ) )
oModelCXN:LoadValue( 'CXN_DESCRI' , oModelPLA:GetValue( 'CXN_DESCRI' ) )

If lCompra
	oModelCXN:LoadValue( 'CXN_FORNEC' , oModelPLA:GetValue( 'CXN_FORCLI' ) )
	oModelCXN:LoadValue( 'CXN_LJFORN' , oModelPLA:GetValue( 'CXN_LOJA' ) )
Else
	oModelCXN:LoadValue( 'CXN_CLIENT' , oModelPLA:GetValue( 'CXN_FORCLI' ) )
	oModelCXN:LoadValue( 'CXN_LJCLI' , oModelPLA:GetValue( 'CXN_LOJA' ) )
EndIf

For nX := 1 To oModelItem:Length()
	
	oModelITEM:GoLIne(nX)
	
	//-- pula itens deletados
	If oModelItem:IsDeleted()
		Loop
	EndIf
	
	If !( lCompra .And. oModelITEM:GetValue( 'CNE_PEDTIT' ) == '1' ) .and. !lExedent //-- Filtra itens que geram pedido de compra
		
		If !Empty( oModelCNE:GetValue('CNE_ITEM') )
			oModelCNE:AddLine()
		EndIf
		
		oModelCNE:LoadValue( 'CNE_ITEM'   , oModelITEM:GetValue( 'CNE_ITEM'   ) )
		oModelCNE:LoadValue( 'CNE_PRODUT' , oModelITEM:GetValue( 'CNE_PRODUT' ) )
		oModelCNE:LoadValue( 'CNE_DESCRI' , oModelITEM:GetValue( 'CNE_DESCRI' ) )
		oModelCNE:LoadValue( 'CNE_15ANOS' , oModelITEM:GetValue( 'CNE_15ANOS' ) )
		oModelCNE:LoadValue( 'CNE_20ANOS' , oModelITEM:GetValue( 'CNE_20ANOS' ) )
		oModelCNE:LoadValue( 'CNE_25ANOS' , oModelITEM:GetValue( 'CNE_25ANOS' ) )
		oModelCNE:LoadValue( 'CNE_VLTOT'  , oModelITEM:GetValue( 'CNE_VLTOT'  ) )
		oModelCNE:LoadValue( 'CNE_TPSERV' , oModelITEM:GetValue( 'CNE_TPSERV' ) )
		
	ElseIf  oModelITEM:GetValue( 'CNE_EXCEDE'  ) == '1' .And. oModelITEM:GetValue( 'CNE_VLLIQD'  ) == 0 .And. !Empty(oModelITEM:GetValue( 'CNE_PRODUT'  )) .And. lExedent
		
		If !Empty(oModelCNE:GetValue( 'CNE_ITEM'  ))
			oModelCNE:AddLine()
		EndIf
		
		oModelCNE:LoadValue( 'CNE_ITEM'   , oModelITEM:GetValue( 'CNE_ITEM'   ) )
		oModelCNE:LoadValue( 'CNE_PRODUT' , oModelITEM:GetValue( 'CNE_PRODUT' ) )
		oModelCNE:LoadValue( 'CNE_DESCRI' , oModelITEM:GetValue( 'CNE_DESCRI' ) )
		oModelCNE:LoadValue( 'CNE_15ANOS' , oModelITEM:GetValue( 'CNE_15ANOS' ) )
		oModelCNE:LoadValue( 'CNE_20ANOS' , oModelITEM:GetValue( 'CNE_20ANOS' ) )
		oModelCNE:LoadValue( 'CNE_25ANOS' , oModelITEM:GetValue( 'CNE_25ANOS' ) )
		oModelCNE:LoadValue( 'CNE_VLTOT'  , oModelITEM:GetValue( 'CNE_VLTOT'  ) )
		oModelCNE:LoadValue( 'CNE_TPSERV' , oModelITEM:GetValue( 'CNE_TPSERV' ) )
		
	EndIf

Next nX

CNTA300BlMd( oModelCNE , , .T. )

FWRestRows( aSave121 , oModel121 )
FWRestRows( aSaveRNF , oModel )

Return

//--------------------------------------------------------------------
/*/{Protheus.doc} CNRNFGRV(oModel)
Gravacao do modelo
@author jose.delmondes
@since 16/04/2018
@version 1.0
@return 
/*/
//-------------------------------------------------------------------
Function CNRNFGRV(oModel)

Local aSaveLines	:= FwSaveRows( oModel121 )

Local oModelCNE := oModel:GetModel('CNEDETAIL')
Local oModelITEM := oModel121:GetModel('CNEDETAIL')

Local nX := 0

For nX := 1 To oModelCNE:Length()
	
	oModelCNE:GoLine(nX)
	
	If oModelITEM:SeekLine( { { 'CNE_ITEM' , oModelCNE:GetValue( 'CNE_ITEM' ) } , { 'CNE_PRODUT' , oModelCNE:GetValue( 'CNE_PRODUT' ) } } )

		oModelITEM:LoadValue( 'CNE_15ANOS' , oModelCNE:GetValue( 'CNE_15ANOS' ) )
		oModelITEM:LoadValue( 'CNE_20ANOS' , oModelCNE:GetValue( 'CNE_20ANOS' ) )
		oModelITEM:LoadValue( 'CNE_25ANOS' , oModelCNE:GetValue( 'CNE_25ANOS' ) )
		oModelITEM:LoadValue( 'CNE_TPSERV' , oModelCNE:GetValue( 'CNE_TPSERV' ) )
	
	EndIf

Next nX

FWRestRows( aSaveLines , oModel121 )

Return .T.

//==============================================================================================================================
/*/{Protheus.doc} CnrTotApEs
REINF - Validação dos campos novos da CNE referente a aposentadoria especial
Total dos 3 campos (15,20 e 25 anos) não pode ser superior ao total do item 
@author antenor.silva
@since 	17/04/2018 
@return lRet
/*/
//==============================================================================================================================
Function CnrTotApEs()
Local oModel	:= FwModelActive()
Local nVlrTot	:= oModel:GetValue("CNEDETAIL","CNE_VLTOT")
Local nApEspe	:= 0
Local lRet		:= .T.

If ("CNE_15ANOS" $ AllTrim(ReadVar(())) .Or. ("CNE_20ANOS" $ AllTrim(ReadVar())) .Or. ("CNE_25ANOS" $ AllTrim(ReadVar())))
	nApEspe := (FwFldGet('CNE_15ANOS') + FwFldGet('CNE_20ANOS') + FwFldGet('CNE_25ANOS'))
	If nApEspe > nVlrTot
		lRet := .F.
		Help(" ",1,"CN121TOCNE") // -- Valor total para aposentadoria especial não pode ser maior do que o valor total do item.
	EndIf
EndIf

Return lRet

//==============================================================================================================================
/*/{Protheus.doc} CnrTotItem
REINF - Não permite que o valor do item da medição seja menor que o total da aposentadoria especial  
@author antenor.silva
@since 	17/04/2018 
@return lRet
/*/
//==============================================================================================================================
Function CnrTotItem(nValue)
Local oModel	:= FwModelActive()
Local lAposEsp	:= CNE->(Columnpos('CNE_15ANOS')) > 0 .OR. CNE->(Columnpos('CNE_20ANOS')) > 0  .OR. CNE->(Columnpos('CNE_25ANOS')) > 0
Local lRet		:= .T.

Default nValue	:= 0

If lAposEsp

	If nValue < (FwFldGet('CNE_15ANOS') + FwFldGet('CNE_20ANOS') + FwFldGet('CNE_25ANOS'))
	    lRet := .F.
	    Help(" ",1,"CN121TOITE") // -- Valor total do Item não pode ser menor do que os valores para a aposentadoria especial.
	EndIf
	
EndIf 

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CNRNFPC()
Valida se itens da medicao geram somente pedido de compra

@author jose.delmondes
@since 16/04/2018
@version 1.0
@return Logigo			true - somente sera gerado pedido de compra
						False - sera gerado outro documento
/*/
//-------------------------------------------------------------------
Function CNRNFPC()

Local aSaveLines	:= FwSaveRows( oModel121 )
Local oModelITEM	:= oModel121:GetModel('CNEDETAIL')
Local lRet	:= .F.
Local nX	:= 0

If lCompra
	
	lRet := .T.
	
	For nX := 1 To oModelITEM:Length() 
	
		oModelITEM:GoLine( nX )
		
		If oModelITEM:GetValue('CNE_PEDTIT') == '2'
			lRet := .F.
			Exit
		EndIf
		
	Next nX
	
EndIf

FWRestRows( aSaveLines , oModel121 )

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CNRVLLINCNE()
Valida se itens da medicão quando excedente estao preenchidos 

@author Ronaldo rRobes
@since 23/04/2018
@version 1.0
@return Logigo			true - somente sera gerado pedido de compra
						False - sera gerado outro documento
/*/
//-------------------------------------------------------------------
Function CNRVLLINCNE()

Local aSaveLines	:= FwSaveRows( oModel121 )
Local oModelITEM	:= oModel121:GetModel('CNEDETAIL')
Local lRet	:= .F.
Local nX	:= 0
	
For nX := 1 To oModelITEM:Length() 
	
	oModelITEM:GoLine( nX )
	
	If oModelITEM:GetValue( 'CNE_EXCEDE'  ) == '1' .And. oModelITEM:GetValue( 'CNE_VLLIQD'  ) == 0 .And. Empty(oModelITEM:GetValue( 'CNE_PRODUT'  ))
		lRet := .T.
		Exit
	EndIf
	
Next nX

FWRestRows( aSaveLines , oModel121 )

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CNRNFVldP()
Valida os parametros do REINF

@author jose.delmondes
@since 24/04/2018
@version 1.0
@return Logigo			true - parametrizacao ok
						False - sparametrizacao nao ok
/*/
//-------------------------------------------------------------------
Function CNRNFVldP( cFilialCND , cContra, cMed )

Local aArea	:= GetArea()
Local lRet	:= .T.
Local cAliasCNE	:= ''
Local cMDAP15	:= SuperGetMv( "MV_MDAP15" , , "" )	//-- Codigo do complemento de imposto de aposentadoria para faixa de 15 anos
Local cMDAP20	:= SuperGetMv( "MV_MDAP20" , , "" )	//-- Codigo do complemento de imposto de aposentadoria para faixa de 20 anos
Local cMDAP25	:= SuperGetMv( "MV_MDAP25" , , "" )	//-- Codigo do complemento de imposto de aposentadoria para faixa de 25 anos 

If Empty( cMDAP15 ) .Or. Empty( cMDAP20 ) .Or. Empty( cMDAP25 )

	cAliasCNE	:= GetNextAlias()

	BeginSQL Alias cAliasCNE
	
		SELECT SUM(CNE.CNE_15ANOS) AS TOT15, SUM(CNE.CNE_20ANOS) AS TOT20, SUM(CNE.CNE_25ANOS) AS TOT25
		
		FROM %table:CNE% CNE
		
		WHERE	CNE.CNE_FILIAL = %exp:cFilialCND% AND
				CNE.CNE_CONTRA = %exp:cContra% AND
				CNE.CNE_NUMMED = %exp:cMed% AND
				CNE.CNE_PEDTIT = '2' AND
				CNE.%NotDel%
				
	EndSQL
	
	If  ( (cAliasCNE)->(TOT15) > 0 .And. Empty( cMDAP15 ) )  .Or. ( (cAliasCNE)->(TOT20) > 0 .And.  Empty( cMDAP20 ) ) .Or. ( (cAliasCNE)->(TOT25) > 0 .And.  Empty( cMDAP25 ) )
		lRet := .F.
	EndIf
	
	(cAliasCNE)->(dbCloseArea())

EndIf

RestArea(aArea)

Return lRet

//-------------------------------------------------------------------
/*{Protheus.doc} CNRTUDOOK
Rotina para validacao antes da gravacao da aposentadoria especial

@param oModel Model da rotina

@author antenor.silva
@since 03/05/2018
@version P12
*/
//-------------------------------------------------------------------
Static Function CNRTUDOOK(oModel)
Local aSave121		:= FwSaveRows ( oModel121 )
Local aSaveRNF		:= FwSaveRows ( oModel )
Local oModelITEM	:= oModel121:GetModel('CNEDETAIL')
Local oModelREIN	:= oModel:GetModel('CNEDETAIL')
Local lRet			:= .T.
Local nX			:= 0
Local nY			:= 0

For nX := 1 To oModelITEM:Length()
	oModelITEM:GoLine( nX )
	
	For nY := 1 To oModelREIN:Length()	
		oModelREIN:GoLine(nY)
	
		If oModelREIN:GetValue("CNE_15ANOS") > 0 .Or. oModelREIN:GetValue("CNE_20ANOS") > 0 .Or. oModelREIN:GetValue("CNE_25ANOS") > 0
		
			If oModelITEM:GetValue('CNE_PEDTIT') == "2" .And. IsEmpty(oModelREIN:GetValue('CNE_TPSERV'))
				Help(" ",1,"CNRTPSERV") // -- Tipo de serviço obrigatório para geração de título. -- Informar o tipo de serviço
				lRet := .F.
				Exit
			EndIf
		
		EndIf
		
	Next nY	

Next nX

FwRestRows( aSave121, oModel121 )
FwRestRows( aSaveRNF, oModel)

Return lRet