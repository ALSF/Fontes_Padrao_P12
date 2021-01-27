#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'CNTA020.CH'
#INCLUDE "GCTXDEF.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} CNTA021()
Cadastro de Tipos de Contrato
@author Flavio Lopes Rasta
@since 15/12/2015
@version 12.1.7
@return NIL
/*/
//-------------------------------------------------------------------
Function CNTA021()
Local oBrowse

//Ajusta o campo de controle de alçadas, com base no antigo campo CN1_CTRAPR (somente em versões anteriores à 12.1.025, pois nessa o ajuste é chamado no RUP)
If Val( StrTran( GetRpoRelease(), ".", "" ) ) < 121025
	AjustaCN1()
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("CN1")
oBrowse:SetDescription (STR0001) //Tipos de Contrato
oBrowse:SetMenuDef( 'CNTA021' )
oBrowse:Activate()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Definição do Menu
@author Flavio Lopes Rasta
@since 15/12/2015
@version 12.1.7
/*/
//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0004 	ACTION "VIEWDEF.CNTA021" OPERATION 1 ACCESS 0//"Pesquisar"
ADD OPTION aRotina TITLE STR0005 	ACTION "VIEWDEF.CNTA021" OPERATION 2 ACCESS 0//"Visualizar"
ADD OPTION aRotina TITLE STR0003	ACTION "VIEWDEF.CNTA021" OPERATION 3 ACCESS 0//Incluir
ADD OPTION aRotina TITLE STR0006	ACTION "VIEWDEF.CNTA021" OPERATION 4 ACCESS 0//Alterar
ADD OPTION aRotina TITLE STR0007	ACTION "VIEWDEF.CNTA021" OPERATION 5 ACCESS 0//Excluir

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados
@author Flavio Lopes Rasta
@since 15/12/2015
@version 12.1.7
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel 	:= Nil
Local oStruCN1	:= FWFormStruct(1,"CN1")

oStruCN1:AddTrigger( "CN1_ALCCTR", "CN1_GRPSIT", {|| CN1_ALCCTR $ "2|3"}, {|| ""} )
oStruCN1:AddTrigger( "CN1_ALCCTR", "CN1_DGRSIT", {|| CN1_ALCCTR $ "2|3"}, {|| ""} )

oModel := MPFormModel():New('CNTA021',,{|oModel| CNTA021TOK(oModel)})

oModel:AddFields('CN1MASTER',,oStruCN1)
oModel:SetDescription(STR0001)
oModel:SetPrimaryKey( {"CN1_FILIAL","CN1_CODIGO"} )

oModel:SetActivate({|oModel| CN021Act(oModel)})

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição da view
@author Flavio Lopes Rasta
@since 15/12/2015
@version 12.1.7
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel 	:= FWLoadModel( "CNTA021" )
Local oStruCN1	:= FWFormStruct( 2, "CN1" )
Local oView 	:= FWFormView():New()
Local lIntegra	:= SuperGetMV('MV_CNXPIMS',.F.,.F.)

oView:SetModel(oModel)  //-- Define qual o modelo de dados será utilizado
oView:SetUseCursor(.F.) //-- Remove cursor de registros'

oStruCN1:SetProperty( "CN1_ALCCTR", MVC_VIEW_ORDEM, "22" )
oStruCN1:SetProperty( "CN1_GRPSIT", MVC_VIEW_ORDEM, "23" )
oStruCN1:SetProperty( "CN1_DGRSIT", MVC_VIEW_ORDEM, "24" )
oStruCN1:SetProperty( "CN1_GRPAPR", MVC_VIEW_ORDEM, "25" )
oStruCN1:SetProperty( "CN1_DESCAP", MVC_VIEW_ORDEM, "26" )

oView:AddField( "VIEW_CN1", oStruCN1, "CN1MASTER" )

If !lIntegra .And. CN1->(Columnpos('CN1_INTEGR')) > 0
	oStruCN1:RemoveField("CN1_INTEGR")
EndIf

oView:CreateHorizontalBox( "CABEC" , 100)
oView:SetOwnerView("VIEW_CN1","CABEC")

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} CN021Act()
Activate do modelo
@author Flávio Lopes Rasta
@since 16/12/2015
@version 12.1.7
@return lRet
/*/
//--------------------------------------------------------------------
Function CN021Act(oModel)
Local lRet 		:= .T.
Local oModCN1	:= oModel:GetModel("CN1MASTER")
Local oStruCN1	:= oModCN1:GetStruct()
Local lWhen		:= !(Empty(oModCN1:GetValue('CN1_MEDEVE')))
Local lInclui	:= oModel:GetOperation() == MODEL_OPERATION_INSERT

//Medição Eventual Obrigatório
oStruCN1:SetProperty('CN1_MEDEVE'	,MODEL_FIELD_OBRIGAT,.T.)

//Inicializa campos bloqueados
oStruCN1:SetProperty('CN1_MEDAUT'	,MODEL_FIELD_WHEN,{||.T.})
oStruCN1:SetProperty('CN1_CTRFIX'	,MODEL_FIELD_WHEN,{||.T.})
oStruCN1:SetProperty("CN1_VLRPRV"	,MODEL_FIELD_WHEN,{||.T.})
oStruCN1:SetProperty("CN1_TPSFIX"	,MODEL_FIELD_WHEN,{||.F.})
oStruCN1:SetProperty('CN1_CROFIS'	,MODEL_FIELD_WHEN,{||lWhen})
oStruCN1:SetProperty('CN1_CROCTB'	,MODEL_FIELD_WHEN,{||lWhen})
oStruCN1:SetProperty('CN1_TPLMT'	,MODEL_FIELD_WHEN,{||lWhen})

If !lInclui
	oStruCN1:SetProperty('CN1_CTRFIX'	,MODEL_FIELD_WHEN,{||.F.})
	oStruCN1:SetProperty('CN1_CROFIS'	,MODEL_FIELD_WHEN,{||.F.})
	oStruCN1:SetProperty('CN1_VLRPRV'	,MODEL_FIELD_WHEN,{||.F.})
	oStruCN1:SetProperty('CN1_CROCTB'	,MODEL_FIELD_WHEN,{||.F.})
Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc}CN300TOK
Pré-Valid do tipo de contrato

@author Flavio Lopes Rasta
@since 05/01/2016
@version 12.1.7
@return lRet
/*/
//--------------------------------------------------------------------
Function CNTA021TOK(oModel)
Local lRet 		 := .T.
Local oModelCN1  := oModel:GetModel('CN1MASTER')
Local lInclui 	 := oModel:GetOperation() == MODEL_OPERATION_INSERT
Local lAltera 	 := oModel:GetOperation() == MODEL_OPERATION_UPDATE
Local lExclui 	 := oModel:GetOperation() == MODEL_OPERATION_DELETE
Local lAlcDocCtr := .F.
Local cAlcCtr    := ""

If lExclui
	dbSelectArea("CN9")
	dbSetOrder(5)//Tipo de Contrato

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida a existencia do registro no cadastro de contratos                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MsSeek(xFilial('CN9')+oModelCN1:GetValue('CN1_CODIGO'), .F.)
		lRet := .F.
		Help( " ", 1, "CNTA021_01" )
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida a existencia do registro no cadastro de amarracao de documentos   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNJ")
	dbSetOrder(2)//Tipo de Contrato

	If MsSeek(xFilial('CNJ')+oModelCN1:GetValue('CN1_CODIGO'), .F.)
		lRet := .F.
		Help( " ", 1, "CNTA021_01" )
	Endif
ElseIf lInclui .Or. lAltera
	cAlcCtr := oModelCN1:GetValue("CN1_ALCCTR")
	lAlcDocCtr :=  ( cAlcCtr $ "0|1" )

	If lAlcDocCtr .And. Empty( oModelCN1:GetValue('CN1_GRPSIT') )
		lRet := .F.
		Help( " ", 1, "CNTA021_09" ) //o controle de alcada requer um grupo de aprovador para este tipo de contrato
	EndIf
	
	If !CnPimsTpCt(oModel)
		lRet := .F.
	EndIf
	
EndIf

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CN021GatPl(cField,cValue)
Função para gatilho dos campos do modelo
@author Flávio Lopes Rasta
@since 16/12/2015
@version 12.1.7
@return lRet
/*/
//--------------------------------------------------------------------
Function CN021GatPl(cField,cValue)
Local lRet			:= .T.
Local oModel		:= FwModelActive()
Local oModelCN1		:= Nil
Local oStruCN1		:= Nil

oModelCN1  	:= oModel:GetModel('CN1MASTER')
oStruCN1 	:= oModelCN1:GetStruct()

Do Case
	
	//Especie do contrato
	Case cField == "CN1_ESPCTR"
		If cValue == "2"
			oStruCN1:SetProperty("CN1_TPMULT",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_TPMULT","2")
			oStruCN1:SetProperty("CN1_TPMULT",MODEL_FIELD_WHEN,{||.F.})
		Else
			oStruCN1:SetProperty("CN1_TPMULT",MODEL_FIELD_WHEN,{||.T.})
		EndIf

	//Medição Eventual
	Case cField == "CN1_MEDEVE"
		//Sim
		If cValue == "1"
			//Medição Automática
			oStruCN1:SetProperty("CN1_MEDAUT",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_MEDAUT","2")
			oStruCN1:SetProperty("CN1_MEDAUT",MODEL_FIELD_WHEN,{||.F.})

			//Fixo
			oStruCN1:SetProperty("CN1_CTRFIX",MODEL_FIELD_WHEN,{||.T.})

			//Físico
			oStruCN1:SetProperty("CN1_CROFIS",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_CROFIS","2")
			oStruCN1:SetProperty("CN1_CROFIS",MODEL_FIELD_WHEN,{||.F.})

			//Contábil
			oStruCN1:SetProperty("CN1_CROCTB",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_CROCTB","2")

			//Tipo de Limite
			oStruCN1:SetProperty("CN1_TPLMT",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_TPLMT","1")  // Financeiro
			oStruCN1:SetProperty("CN1_TPLMT",MODEL_FIELD_WHEN,{||.F.})

		//Não
		ElseIf cValue == "2"
			//Medição Automática
		 	oStruCN1:SetProperty("CN1_MEDAUT",MODEL_FIELD_WHEN,{||.T.})

		 	//Fixo
		 	oStruCN1:SetProperty("CN1_CTRFIX",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCN1:SetValue("CN1_CTRFIX","1")
		 	oStruCN1:SetProperty("CN1_CTRFIX",MODEL_FIELD_WHEN,{||.F.})

		 	//Físico
		 	oStruCN1:SetProperty("CN1_CROFIS",MODEL_FIELD_WHEN,{||.T.})

		 	//Contábil
			oStruCN1:SetProperty("CN1_CROCTB",MODEL_FIELD_WHEN,{||.T.})

			//Previsão financeira
		 	oStruCN1:SetProperty("CN1_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCN1:LoadValue("CN1_VLRPRV","1")
		 	oStruCN1:SetProperty("CN1_VLRPRV",MODEL_FIELD_WHEN,{||.F.})

		 	//Tipo de Limite
		 	oStruCN1:SetProperty("CN1_TPLMT",MODEL_FIELD_WHEN,{||.T.})
		 EndIf
	//Fixo
	Case cField == "CN1_CTRFIX"
		If cValue == "1"
			// Previsão Financeira
		 	oStruCN1:SetProperty("CN1_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCN1:LoadValue("CN1_VLRPRV","1")
		 	oStruCN1:SetProperty("CN1_VLRPRV",MODEL_FIELD_WHEN,{||.F.})
			
			//Contabil
		 	oStruCN1:SetProperty("CN1_CROCTB",MODEL_FIELD_WHEN,{||.T.})

			//Semi-Fixo
			oStruCN1:SetProperty("CN1_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_TPSFIX",SPACE(Len(oModelCN1:GetValue('CN1_TPSFIX'))))
			oStruCN1:SetProperty("CN1_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

		// Não
		ElseIf cValue == "2"
			// Previsão Financeira
			oStruCN1:SetProperty("CN1_VLRPRV",MODEL_FIELD_WHEN,{||.T.})

			//Contábil
			oStruCN1:SetProperty("CN1_CROCTB",MODEL_FIELD_WHEN,{||.T.})
	 		oModelCN1:LoadValue("CN1_CROCTB","2")
	 		oStruCN1:SetProperty("CN1_CROCTB",MODEL_FIELD_WHEN,{||.F.})

			//Semi-Fixo
			oStruCN1:SetProperty("CN1_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_TPSFIX",SPACE(Len(oModelCN1:GetValue('CN1_TPSFIX'))))
			oStruCN1:SetProperty("CN1_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

		ElseIf cValue == "3"
			//- Tipo Semifixo
			oStruCN1:SetProperty("CN1_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCN1:LoadValue("CN1_TPSFIX","1")

			//Contábil
	 		oStruCN1:SetProperty("CN1_CROCTB",MODEL_FIELD_WHEN,{||.T.})
	 		oModelCN1:LoadValue("CN1_CROCTB","2")
	 		oStruCN1:SetProperty("CN1_CROCTB",MODEL_FIELD_WHEN,{||.F.})

			// Previsão Financeira
		 	oStruCN1:SetProperty("CN1_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCN1:LoadValue("CN1_VLRPRV","1")
		 	oStruCN1:SetProperty("CN1_VLRPRV",MODEL_FIELD_WHEN,{||.F.})
		EndIf

EndCase

lRet := CN021VlCpo(cField,cValue)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CN021VlCpo()
Valid dos campos
@author Flávio Lopes Rasta
@since 16/12/2015
@version 12.1.7
@return lRet
/*/
//--------------------------------------------------------------------
Function CN021VlCpo(cField,cValue)
Local lRet 		:= .T.
Local oModel	:= FwModelActive()
Local oModelCN1	:= oModel:GetModel("CN1MASTER")

If lRet .And. (oModelCN1:GetValue('CN1_TPLMT') == "2" .And. oModelCN1:GetValue('CN1_CROFIS') == "2")
	lRet := .F.
	Help( " ", 1, "CNTA021_04" )
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CN021VldDt()
Valida o periodo de aviso configurado para o tipo do contrato

@author Marcelo Custodio
@since 22/11/2005
@return lRet
/*/
//--------------------------------------------------------------------

Function CN021VldDt()

Local lRet   	:= .T.
Local oModel 	:= FwModelActive()
Local nX     	:= 0
Local cDias  	:= oModel:GetModel("CN1MASTER"):GetValue("CN1_PRDALT")
Local cDigit 	:= ""

If !Empty( cDias := AllTrim( cDias ) )

	For nX := 1 To Len( cDias )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o usuario preencheu numero ou ',' ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDigit := SubStr( cDias,nX,1 )
		If !IsDigit(cDigit) .AND. cDigit != ","
			lRet := .F.
			Exit
		EndIf
	Next
EnDif

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} Cn021CReal()
Valida campo CN1_CREALM
@author aline.sebrian
@since 06/03/2014
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
Function Cn021CReal()
Local lRet		:= .T.
Local oModel	:= FWModelActive()
Local cExpCod	:= oModel:GetModel("CN1MASTER"):GetValue("CN1_CODIGO")
Local cCREALM	:= oModel:GetModel('CN1MASTER'):GetValue('CN1_CREALM')
Local lAltera	:= oModel:GetOperation() == MODEL_OPERATION_UPDATE

dbSelectArea("CN9")
dbSetOrder(5)//Tipo de Contrato

If lAltera

	BeginSQL Alias "TRBCN9"
		SELECT CN9.R_E_C_N_O_ CN9RECNO
		FROM %Table:CN9% CN9, %Table:CN0% CN0
		WHERE CN9.%NotDel% AND CN0.%NotDel% AND
			CN9_FILIAL	= %xFilial:CN9% AND
			CN0_FILIAL	= %xFilial:CN0% AND
			CN9_TIPREV = CN0_CODIGO AND
			CN0_TIPO   = '3' AND
			CN9_TPCTO	= %Exp:cExpCod%
	EndSQL

	While !TRBCN9->(Eof())
		CN9->(dbGoTo(TRBCN9->CN9RECNO))
		If CN1->CN1_CREALM <> cCREALM .And. CN9->CN9_SITUAC == DEF_SREVS
			lRet :=.F.
			Exit
		EndIf
		TRBCN9->(dbSkip())
	EndDo

	TRBCN9->(dbCloseArea())

	If !lRet
		Help( " ", 1, "CNTA020REAL" ) //--Edição não permitida! Existem contratos para o tipo Realinhamento de Preço na situação em Revisão.
	EndIf

EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Cn021CReaj()
Valida campo CN1_CREAJM
@author aline.sebrian
@since 06/03/2014
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
Function Cn021CReaj()
Local lRet		:= .T.
Local oModel	:= FWModelActive()
Local lAltera	:= oModel:GetOperation() == MODEL_OPERATION_UPDATE
Local cExpCod	:= oModel:GetModel("CN1MASTER"):GetValue("CN1_CODIGO")
Local cCREAJM 	:= oModel:GetModel('CN1MASTER'):GetValue('CN1_CREAJM')

dbSelectArea("CN9")
dbSetOrder(5)//Tipo de Contrato

If lAltera

	BeginSQL Alias "TRBCN9"
		SELECT CN9.R_E_C_N_O_ CN9RECNO
		FROM %Table:CN9% CN9, %Table:CN0% CN0
		WHERE CN9.%NotDel% AND CN0.%NotDel% AND
			CN9_FILIAL	= %xFilial:CN9% AND
			CN0_FILIAL	= %xFilial:CN0% AND
			CN9_TIPREV = CN0_CODIGO AND
			CN0_TIPO   = '2' AND
			CN9_TPCTO	= %Exp:cExpCod%
	EndSQL

	While !TRBCN9->(Eof())
		CN9->(dbGoTo(TRBCN9->CN9RECNO))
		If CN1->CN1_CREAJM <> cCREAJM .And. CN9->CN9_SITUAC == DEF_SREVS
			lRet :=.F.
			Exit
		EndIf
		TRBCN9->(dbSkip())
	EndDo

	TRBCN9->(dbCloseArea())

	If !lRet
		Help( " ", 1, "CNTA020REAJ" ) //--Edição não permitida! Existem contratos para o tipo Reajuste de Preço na situação em Revisão.
	EndIf
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Cn021F3()
Função auxiliar, utilizada na consulta padrão CN1
@author jose.delmondes
@since 20/06/2017
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
Function Cn021F3(nOperation)

Local aArea := GetArea()

SaveInter()

FWExecView(,'CNTA021', nOperation)

RestInter()

RestArea(aArea)

Return

/*/{Protheus.doc} AjustaCN1
Função para ajustar os registros da CN1, após remoção do uso do campo CN1_CTRAPR, corrigindo a configuração 
do campo CN1_ALCCTR, com base nas seguintes regras:

1. Se o campo CN1_ALCCTR estiver vazio (base migrada da 11) e o campo CN1_CTRAPR estiver com o valor "1" (Sim),
   o campo CN1_ALCCTR será atualizado para o valor "1" (alçada de documento).

2. Se o campo CN1_ALCCTR estiver vazio (base migrada da 11) e o campo CN1_CTRAPR estiver com o valor "2" (Não),
   o campo CN1_ALCCTR será atualizado para o valor "3" (nenhuma alçada).

3. Se o campo CN1_ALCCTR estiver com valor "0" (Todos)(antigo valor padrão inicial) e o campo CN1_CTRAPR estiver 
   com o valor "2" (Não), o campo CN1_ALCCTR será atualizado para o valor "2" (alçada contábil).

@Return lRet, Indica se foi realizado o ajuste em algum registro da CN1

@author pedro.alencar
@since 13/03/2019
/*/
Function AjustaCN1() As Logical
	Local aAreaCN1 As Array
	Local lRet As Logical
	Local cQuery As Char
	Local cAlcCtr As Char
	Local cCtrApr As Char
	Local cNovoValor As Char
	Local cAliasCN1 As Char
	
	lRet := .F.	
	cAliasCN1 := GetNextAlias()
	
	cQuery := "SELECT R_E_C_N_O_ AS RECNO" + CRLF
	cQuery += "FROM " + RetSqlName("CN1") + CRLF
	cQuery += "WHERE D_E_L_E_T_ = ' '" + CRLF
	cQuery += "  AND (CN1_ALCCTR = ' '" + CRLF
	cQuery += "       OR (CN1_ALCCTR = '0'" + CRLF
	cQuery += "           AND CN1_CTRAPR = '2'))"
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasCN1, .T., .T. )
	
	If ( cAliasCN1 )->( ! EOF() )
		aAreaCN1 := CN1->( GetArea() )		
		
		While ( cAliasCN1 )->( ! EOF() )
			CN1->( dbGoTo( ( cAliasCN1 )->( RECNO ) ) )
			cNovoValor := ""
			
			cAlcCtr := CN1->CN1_ALCCTR
			cCtrApr := CN1->CN1_CTRAPR
			
			If Empty( cAlcCtr )
				If cCtrApr == "1"
					cNovoValor := "1" //Alçada de documento
				ElseIf cCtrApr == "2"
					cNovoValor := "3" //Nenhuma Alçada
				EndIf
			ElseIf cAlcCtr == "0" .And. cCtrApr == "2"
				cNovoValor := "2" //Alçada Contábil
			EndIf
			
			If ! Empty( cNovoValor )				
				RecLock( "CN1", .F. )
				CN1->CN1_ALCCTR := cNovoValor
				CN1->( MsUnlock() )
				lRet := .T.
			EndIf
			
			( cAliasCN1 )->( dbSkip() )
		EndDo
		
		RestArea( aAreaCN1 )
	Endif
	
	If Select(cAliasCN1) > 0
		( cAliasCN1 )->( dbCloseArea() )
		FErase( ( cAliasCN1 ) + GetDBExtension() )
	EndIf
Return lRet