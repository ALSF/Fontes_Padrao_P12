#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "CNTA230.CH"

Static __lC230ROT := ExistBlock("CN230ROT")

//-------------------------------------------------------------------
/*/{Protheus.doc} CNTA230()
Cadastro de tipos de planilha
@author Leonardo Quintania
@since 26/05/2015
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------	
Function CNTA230() 
Local oBrowse  

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("CNL")                                          
oBrowse:SetDescription(STR0001)  //"Tipos de Planilha"
oBrowse:Activate()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Definicao do Menu
@author Leonardo Quintania
@since 26/05/2015
@version 1.0
@return aRotina (vetor com botoes da EnchoiceBar)
/*/
//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {} //Array utilizado para controlar opcao selecionada
Local aRotPE := {}

ADD OPTION aRotina TITLE STR0002 ACTION "PesqBrw"			OPERATION 1 ACCESS 0 //"Pesquisar"
ADD OPTION aRotina TITLE STR0003 ACTION "VIEWDEF.CNTA230" 	OPERATION 2 ACCESS 0 //"Visualizar"
ADD OPTION aRotina TITLE STR0004 ACTION "VIEWDEF.CNTA230"	OPERATION 3 ACCESS 0 //"Incluir"
ADD OPTION aRotina TITLE STR0005 ACTION "CNT230ALT()"  		OPERATION 4 ACCESS 0 //"Alterar"
ADD OPTION aRotina TITLE STR0006 ACTION "CNT230EXC()"		OPERATION 5 ACCESS 0 //"Excluir"
ADD OPTION aRotina TITLE STR0007 ACTION "VIEWDEF.CNTA230"	OPERATION 8 ACCESS 0 //'Imprimir'
ADD OPTION aRotina TITLE STR0008 ACTION "VIEWDEF.CNTA230"	OPERATION 9 ACCESS 0 //'Copia'

If __lC230ROT
	aRotPE := ExecBlock( "CN230ROT", .F., .F. )
	If ValType( aRotPE ) == "A"
		AEval( aRotPE, { |x| AAdd( aRotina, x ) } )
	EndIf
EndIf

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef()
Definicao do Modelo
@author Leonardo Quintania
@since 26/05/2015
@version 1.0
@return oModel
/*/
//-------------------------------------------------------------------
Static Function ModelDef()
Local oStruCab := FWFormStruct(1,"CNL") //Tipos de Planilha
Local oModel   := Nil //Modelo de Dados MVC

oStruCab:SetProperty('CNL_TPSFIX',MODEL_FIELD_VALID,MTBlcVld("CNL","CNL_TPSFIX"	,"Cn230GtPlan('CNL_TPSFIX',FwFldGet('CNL_TPSFIX'))",.F.,.F. ) )

//------------------------------------------------------
//		Cria a estrutura basica
//------------------------------------------------------
oModel:= MPFormModel():New("CNTA230", /*Pre-Validacao*/,/*{|oModel|CNT230PVld(oModel)}*//*Pós-Validação*/,{|oModel|Cn230Grv(oModel)}/*Commit*/,/*Cancel*/)

//------------------------------------------------------
//		Adiciona o componente de formulario no model
//     Nao sera usado, mas eh obrigatorio ter
//------------------------------------------------------
oModel:AddFields("CNLMASTER",/*cOwner*/,oStruCab)

//--------------------------------------
//		Configura o model
//--------------------------------------
oModel:SetPrimaryKey( {"CNL_FILIAL","CNL_CODIGO"} ) //Obrigatorio setar a chave primaria (mesmo que vazia)
oModel:SetActivate({|oModel| CN230Act(oModel)})

Return oModel

//--------------------------------------------------------------------
/*/{Protheus.doc} ViewDef()
Definicao da View
@author Leonardo Quintania
@since 26/05/2015
@version 1.0
@return oView
/*/
//--------------------------------------------------------------------
Static Function ViewDef()  

Local oModel   	:= FWLoadModel( "CNTA230" )	 //Carrega model definido
Local oStruCab 	:= FWFormStruct(2,"CNL") //Estrutura Tipos de Planilha
Local oView	  	:= FWFormView():New()

//--------------------------------------
//		Associa o View ao Model
//--------------------------------------
oView:SetModel(oModel)  //-- Define qual o modelo de dados será utilizado
oView:SetUseCursor(.F.) //-- Remove cursor de registros'

//--------------------------------------
//		Insere os componentes na view
//--------------------------------------
oView:AddField("VIEW_CNL",oStruCab,"CNLMASTER")   //Cabecalho da matriz de abastecimento

//--------------------------------------
//		Cria os Box's
//--------------------------------------
oView:CreateHorizontalBox("CABEC",100)

//--------------------------------------
//		Associa os componentes
//--------------------------------------
oView:SetOwnerView("VIEW_CNL","CABEC")

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} CN230Act()
Pre-valid

@author jose.eulalio
@since 10/08/2015
@version P12
@return lRet
/*/
//--------------------------------------------------------------------
Function CN230Act(oModel)
Local lRet 		:= .T.
Local oModCNL		:= oModel:GetModel("CNLMASTER")
Local oStruCNL	:= oModCNL:GetStruct()
Local lWhen		:= !(Empty(oModCNL:GetValue('CNL_MEDEVE')))

//Medição Eventual Obrigatório
oStruCNL:SetProperty('CNL_MEDEVE'	,MODEL_FIELD_OBRIGAT,.T.)

//Inicializa campos bloqueados
oStruCNL:SetProperty('CNL_CROFIS',MODEL_FIELD_WHEN,{||lWhen})
oStruCNL:SetProperty('CNL_CROCTB',MODEL_FIELD_WHEN,{||lWhen})
oStruCNL:SetProperty('CNL_TPLMT' ,MODEL_FIELD_WHEN,{||lWhen})
oStruCNL:SetProperty('CNL_TPSFIX',MODEL_FIELD_WHEN,{||Cn230SFix("CNL_TPSFIX")})

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CNT230PVld()
Pós-Valid do modelo
@author Flavio Lopes Rasta
@since 22/06/2015
@version 12
@return lRet
/*/
//--------------------------------------------------------------------
Function CNT230PVld(oModel)
Local lRet	:= .T.
Local oModelCNL

Default oModel := FwModelActive()

oModelCNL := oModel:GetModel('CNLMASTER')

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} Cn2030GtPlan(cField,cValue)
Função para gatilho dos campos do modelo
@author José Eulálio
@since 04/07/2015
@version 12
@return .T.
/*/
//--------------------------------------------------------------------
Function Cn230GtPlan(cField,cValue)
Local lRet			:= .T.
Local oModel		:= FwModelActive()
Local oView			:= FwViewActive()
Local oModelCNL
Local oStructCNL

If oModel:GetId() <> "CNTA230"
	oModel:= FWLoadModel( "CNTA230" )
EndIf

oModelCNL  	:= oModel:GetModel('CNLMASTER')
oStructCNL 	:= oModelCNL:GetStruct()

Do Case
	
	//Medição Eventual
	Case cField == "CNL_MEDEVE"
		//Conforme o Contrato
		If cValue == "0"

			//Medição Automática
		 	oStructCNL:SetProperty("CNL_MEDAUT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_MEDAUT","0")
			oStructCNL:SetProperty("CNL_MEDAUT",MODEL_FIELD_WHEN,{||.F.})

		 	//Fixo
		 	oStructCNL:SetProperty("CNL_CTRFIX",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:LoadValue("CNL_CTRFIX","0")
			oStructCNL:SetProperty("CNL_CTRFIX",MODEL_FIELD_WHEN,{||.F.})

			//SemiFixo
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","0")
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

			//Físico
			oStructCNL:SetProperty("CNL_CROFIS",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CROFIS","0")
			oStructCNL:SetProperty("CNL_CROFIS",MODEL_FIELD_WHEN,{||.F.})

			//Contábil
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CROCTB","0")
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.F.})

			//Previsão Financeira
			oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_VLRPRV","0")
			oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.F.})

		 	//Limite da Medição
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_LMTMED",0)
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.F.})

		 	//Tipo de Limite
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPLMT","0")
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.F.})

			//Tipo de Multa
			oStructCNL:SetProperty("CNL_TPMULT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPMULT","0")
			oStructCNL:SetProperty("CNL_TPMULT",MODEL_FIELD_WHEN,{||.F.})

		ElseIf cValue == "1"
			//Medição Automática
			oStructCNL:SetProperty("CNL_MEDAUT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_MEDAUT","2")
			oStructCNL:SetProperty("CNL_MEDAUT",MODEL_FIELD_WHEN,{||.F.})

			//Fixo
			oStructCNL:SetProperty("CNL_CTRFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CTRFIX","0")

			//Semi Fixo
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","0")
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

			//Físico
			oStructCNL:SetProperty("CNL_CROFIS",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CROFIS","2")
			oStructCNL:SetProperty("CNL_CROFIS",MODEL_FIELD_WHEN,{||.F.})

			//Contábil
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CROCTB","0")
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.F.})

			//Limite da Medição
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_LMTMED",0)

			//Tipo de Limite
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPLMT","1")  // Financeiro
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.F.})

			//Tipo de Multa
			oStructCNL:SetProperty("CNL_TPMULT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPMULT","0")

		ElseIf cValue == "2"
		 	//Medição Automática
		 	oStructCNL:SetProperty("CNL_MEDAUT",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:LoadValue("CNL_MEDAUT","0")

		 	//Fixo
		 	oStructCNL:SetProperty("CNL_CTRFIX",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:LoadValue("CNL_CTRFIX","1")
		 	oStructCNL:SetProperty("CNL_CTRFIX",MODEL_FIELD_WHEN,{||.F.})

		 	//Semi Fixo
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","0")
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

		 	//Físico
		 	oStructCNL:SetProperty("CNL_CROFIS",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:LoadValue("CNL_CROFIS",'0')

		 	//Contábil
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CROCTB",'0')

			//Previsão financeira
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:LoadValue("CNL_VLRPRV","1")
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.F.})

		 	//Limite da Medição
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_LMTMED",0)

		 	//Tipo de Limite
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPLMT","0")
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.F.})

			//Tipo de Multa
			oStructCNL:SetProperty("CNL_TPMULT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPMULT","0")

		//Recorrente
		ElseIf cValue == "3"
		 	//Medição Automática
		 	oStructCNL:SetProperty("CNL_MEDAUT",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:SetValue("CNL_MEDAUT","1")
		 	oStructCNL:SetProperty("CNL_MEDAUT",MODEL_FIELD_WHEN,{||.F.})

		 	//Fixo
		 	oStructCNL:SetProperty("CNL_CTRFIX",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:SetValue("CNL_CTRFIX","1")
		 	oStructCNL:SetProperty("CNL_CTRFIX",MODEL_FIELD_WHEN,{||.F.})

		 	//Semi Fixo
		 	oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","0")
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

		 	//Físico
		 	oStructCNL:SetProperty("CNL_CROFIS",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:SetValue("CNL_CROFIS","2")
		 	oStructCNL:SetProperty("CNL_CROFIS",MODEL_FIELD_WHEN,{||.F.})

		 	//Contábil
		 	oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:SetValue("CNL_CROCTB","2")
		 	oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.F.})

			//Previsão financeira
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:SetValue("CNL_VLRPRV","1")
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.F.})

		 	//Limite da Medição
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_LMTMED",0)

		 	//Tipo de Limite
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_TPLMT",'1')
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.F.})

			//Tipo de Multa
			oStructCNL:SetProperty("CNL_TPMULT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPMULT","0")
		 EndIf

	// "Planilha" Fixa
	Case cField == "CNL_CTRFIX"
		If cValue == "0" // Conforme o Contrato
			// Previsão Financeira
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:LoadValue("CNL_VLRPRV","0")
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.F.})
			
			//Contábil
		   oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
		   oModelCNL:LoadValue("CNL_CROCTB","0")
		   oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.F.})
			   
		 	//Semi Fixo
		 	oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","0")
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

		ElseIf cValue == "1" // Sim
			// Previsão Financeira
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
		 	oModelCNL:LoadValue("CNL_VLRPRV","1")
		 	oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.F.})

		 	//Contábil
		 	oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})

			//Semi Fixo
		 	oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","0")
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

		ElseIf cValue == "2" // Não
			// Previsão Financeira
			oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_VLRPRV","0")
			
			//Contábil
		   oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
		   oModelCNL:LoadValue("CNL_CROCTB","2")
		   oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.F.})

			//Semi Fixo
		 	oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","0")
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.F.})

		ElseIf cValue == "3" // Semi Fixo

			//Semi Fixo
		 	oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			
			// Previsão Financeira
			oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_VLRPRV","1")
			oStructCNL:SetProperty("CNL_VLRPRV",MODEL_FIELD_WHEN,{||.F.})
			
			// Previsão Financeira
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_CROCTB","2")
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.F.})
			
			// Previsão Financeira
			oStructCNL:SetProperty("CNL_TPSFIX",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPSFIX","1")
			
		EndIf

	Case cField == "CNL_TPLMT"
		If !cValue $ "1|2"
			//Limite da Medição
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_LMTMED",0)
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.F.})
		Else
			//Limite da Medição
			oStructCNL:SetProperty("CNL_LMTMED",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_LMTMED",0)
		EndIf

	Case cField == "CNL_TPSFIX"
		If cValue == "2"
			oStructCNL:SetProperty("CNL_CODAGR",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CODAGR","")

			oStructCNL:SetProperty("CNL_NIVAGR",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_NIVAGR","")
		Else
			oStructCNL:SetProperty("CNL_CODAGR",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_CODAGR","")
			oStructCNL:SetProperty("CNL_CODAGR",MODEL_FIELD_WHEN,{||.F.})

			oStructCNL:SetProperty("CNL_NIVAGR",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:LoadValue("CNL_NIVAGR","")
			oStructCNL:SetProperty("CNL_NIVAGR",MODEL_FIELD_WHEN,{||.F.})
		EndIf
	Case cField == "CNL_PLSERV"
		If cValue == "1"
			oStructCNL:SetProperty("CNL_CROCTB",MODEL_FIELD_WHEN,{||.T.})
		EndIf
	Case cField == "CNL_CROFIS"
		If cValue == "0"
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPLMT","0")
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.F.})
		ElseIf cValue == "1"
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.T.})
		ElseIf cValue == "2"
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.T.})
			oModelCNL:SetValue("CNL_TPLMT","1")
			oStructCNL:SetProperty("CNL_TPLMT",MODEL_FIELD_WHEN,{||.F.})
		EndIf
EndCase

lRet := CN230VlCpo(cField,cValue)

If ValType(oView) == "O" .And. oView:IsActive().And. oView:GetModel():GetId() == "CNTA230"
	oView:Refresh()
EndIf

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CNT230EXC()
Validação na deleção do tipo de planilha.
@author Flavio Lopes Rasta
@since 06/07/2015
@version 12
@return .T.
/*/
//--------------------------------------------------------------------
Function CNT230EXC()
Local lRet	:= .T.

dbSelectArea("CNA") 
dbSetOrder(4)//Tipo de planilha

If MsSeek(xFilial('CNA')+CNL->CNL_CODIGO, .F.)
	lRet := .F.
	Help(" ", 1, "CNTA230NOTEXC" )
Else
	FWExecView (STR0006, "CNTA230", MODEL_OPERATION_DELETE,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ ,{||.T.} /*bCancel*/ )
Endif  

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CNT230ALT()
Validação na deleção do tipo de planilha.
@author Flavio Lopes Rasta
@since 06/07/2015
@version 12
@return .T.
/*/
//--------------------------------------------------------------------
Function CNT230ALT()
Local lRet	:= .T.

dbSelectArea("CNA") 
dbSetOrder(4)//Tipo de planilha

If MsSeek(xFilial('CNA')+CNL->CNL_CODIGO, .F.)
	lRet := .F.
	Help(" ", 1, "CNTA230NOTALT" )
Else
	FWExecView (STR0005, "CNTA230", MODEL_OPERATION_UPDATE,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ ,{||.T.} /*bCancel*/ )
Endif

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CN230INC()
ExecView para Inclusão
@author José Eulálio
@since 01/08/2015
@version 12
@return
/*/
//--------------------------------------------------------------------
Function CN230INC()

FWExecView (STR0004, "CNTA230", MODEL_OPERATION_INSERT,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ ,{||.T.} /*bCancel*/ )

Return

//--------------------------------------------------------------------
/*/{Protheus.doc} CN230VISU()
ExecView para Visualização
@author José Eulálio
@since 01/08/2015
@version 12
@return
/*/
//--------------------------------------------------------------------
Function CN230VIS()

FWExecView (STR0003, "CNTA230", MODEL_OPERATION_VIEW,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ ,{||.T.} /*bCancel*/ )

Return 

//-------------------------------------------------------------------
/*/{Protheus.doc} CN230First()
Verifica se o campo Medição Eventual foi preenchido

@author jose.eulalio
@since 10/08/2015
@version P12
@return lRet
/*/
//--------------------------------------------------------------------
Function CN230First()
Local oModCNL	:= oModel:GetModel("CNLMASTER") 
Local lRet	:= !(Empty(oModCNL:GetValue('CNL_MEDEVE')))

If !lRet
	Help("",1,"CN230MEDVAZIA",,"Preencha o valor do campo Medição Eventual",4,1)
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CN230VlCpo()
Valid dos campos

@author jose.eulalio
@since 10/08/2015
@version P12
@return lRet
/*/
//--------------------------------------------------------------------
Function CN230VlCpo(cCampo,cValor)
Local lRet := .T.
Local oModel		:= FwModelActive()
Local oModCNL  	:= oModel:GetModel('CNLMASTER')

//Validação da Medição Eventual
If lRet .And. cCampo == "CNL_MEDEVE"
	If cValor == "1" .And. oModCNL:GetValue("CNL_MEDAUT") == "1"
		lRet := .F.
		Help( " ", 1, "CNTA020_02" )
	EndIf 
	If lRet .And. cValor == "1" .And. oModCNL:GetValue("CNL_CROFIS") == "1"
		lRet := .F.
		Help( " ", 1, "CNTA020_03" )
	EndIf
	If lRet .And. cValor == "2" .And. oModCNL:GetValue("CNL_CTRFIX") == "2"
		lRet := .F.
		Help( " ", 1, "CNTA020_06" )
	EndIf
EndIf

//Validação da Medição Automática
If lRet .And. cCampo == "CNL_MEDAUT"
	If cValor == "1" .And. oModCNL:GetValue("CNL_MEDEVE") == "1"
		lRet := .F.
		Help( " ", 1, "CNTA020_02" )
	EndIf 
EndIf

//Validação do Cronograma Físico
If lRet .And. cCampo == "CNL_CROFIS"
	If cValor == "1" .And. oModCNL:GetValue("CNL_MEDEVE") == "1"
		lRet := .F.
		Help( " ", 1, "CNTA020_03" )
	EndIf
	If lRet .And. cValor == "2" .And. oModCNL:GetValue("CNL_TPLMT") == "2"
		lRet := .F.
		Help( " ", 1, "CNTA020_04" )
	EndIf  
EndIf

//Validação do Tipo de Limite
If lRet .And. cCampo == "CNL_TPLMT"
	If cValor == "2" .And. oModCNL:GetValue("CNL_CROFIS") == "2"
		lRet := .F.
		Help( " ", 1, "CNTA020_04" )
	EndIf
EndIf

//Validação da Planilha Fixa
If lRet .And. cCampo == "CNL_CTRFIX"
	If cValor == "2" .And. oModCNL:GetValue("CNL_MEDEVE") == "2"
		lRet := .F.
		Help( " ", 1, "CNTA020_06" )
	EndIf
EndIf

//Validação do Cronograma Contábil
If lRet .And. cCampo == "CNL_CROCTB"
	If cValor == "1" .And. oModCNL:GetValue("CNL_CTRFIX") == "2"
		lRet := .F.
		Help( " ", 1, "CNTA020_07" )
	EndIf
	If lRet .And. cValor $ "01" .And. oModCNL:GetValue("CNL_MEDEVE") == "1"
		lRet := .F.
		Help("",1,"CNTA020_EVE",,"Contratos com Medição Eventual não possuem cronogramas.",4,1) //"Contratos com Medição Eventual não possuem cronogramas."
	EndIf
EndIf

//Validação do campo Semi-fixo
If lRet .And. cCampo == "CNL_TPSFIX"
	If cValor == "0" .And. oModCNL:GetValue("CNL_CTRFIX") == "3"
		lRet := .F.
		Help("",1,"CNTA230SF",,"Ajuste o campo de Semi-fixo para uma opção diferente de Conforme o contrato!",4,1) 
	EndIf
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CN230Grv()
Gravação do Tipo de Planilha

@author jose.eulalio
@since 10/08/2015
@version P12
@return lRet
/*/
//--------------------------------------------------------------------
Function Cn230Grv(oModel)
Local lRet		:= .T.
Local nX		:= 0
Local oModCNL	:= 	oModel:GetModel('CNLMASTER')
Local aCampos := oModCNL:GetStruct():GetFields()

//Preenche como "0=Conforme Contrato" os campos que estão em branco
If oModel:GetOperation() != MODEL_OPERATION_DELETE
For nX := 1 To Len(aCampos)
	If !(aCampos[nX][MODEL_FIELD_VIRTUAL]) .And. (aCampos[nX][MODEL_FIELD_TIPO]) == "C" .And. (aCampos[nX][MODEL_FIELD_TAMANHO]) == 1 // Desconsidera campos virtuais
		If Empty(oModCNL:GetValue(aCampos[nX,MODEL_FIELD_IDFIELD]))
			oModCNL:LoadValue(aCampos[nX,MODEL_FIELD_IDFIELD],"0")
		EndIf
	EndIf
Next nX
EndIf

lRet := FWFormCommit(oModel)

Return lRet

//=============================================================================
/*/{Protheus.doc} Cn230VlServ(oModelCNL)
Função responsável pelo WHEN do campo CNL_PLSERV
@author israel.escorizza
@since 10/05/2016
@return
/*/
//=============================================================================
Function Cn230VlServ(oModelCNL)
Local lRet			:= .F.
Local oView	:= FwViewActive()
Local oModel:= Nil

Default oModelCNL	:= Nil

If oModelCNL == Nil
	oModel	:= FwModelActive()
	oModelCNL := oModel:GetModel('CNLMASTER')
Endif

If 	oModelCNL:GetValue('CNL_CTRFIX') == '1' .And. oModelCNL:GetValue('CNL_VLRPRV') == '1' .And. oModelCNL:GetValue('CNL_TPLMT') == '1' .And.;
	oModelCNL:GetValue('CNL_MEDEVE') == '2' .And. oModelCNL:GetValue('CNL_CROFIS') == '2' 

	lRet := .T.
ElseIf oModelCNL:GetValue('CNL_PLSERV') == '1'
	oModelCNL:LoadValue('CNL_PLSERV','2')
	If ValType(oView) == "O" .And. oView:isActive() .And. oView:GetModel():GetId()=="CNTA230"
		oView:Refresh()
	EndIf
EndIf

Return lRet

//=============================================================================
/*/{Protheus.doc} Cn230SFix(cCampo)
Função responsável pelo WHEN do campo CNL_TPSFIX
@author israel.escorizza
@since 10/05/2016
@return
/*/
//=============================================================================
Function Cn230SFix(cCampo)
Local oModel		:= FWModelActive()
Local lRet			:= .F.

If cCampo == "CNL_TPSFIX" .And. oModel:GetValue('CNLMASTER','CNL_CTRFIX') == '3'
	lRet := .T.
EndIf

Return lRet

