#include "WFCNTA300.CH"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static aSCR := {}
Static aWF1 := {}
Static aWF2 := {}
Static aWF3 := {}
Static aWF4 := {}
Static aWF5 := {}
//------------------------------------------------------------------
/*/{Protheus.doc} WFCNTA300()
Mudança da situação do contrato.
@author jose.eulalio
@since 02/04/13
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
Function WFCNTA300()
Local oBrowse := NIL

oBrowse := FWMBrowse():New()
oBrowse:setAlias("SCR")
oBrowse:SetDescription(STR0001) // "Contrato"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                //"Contrato"
oBrowse:Activate()

Return NIL

//------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Menu de opções do Browse
@author jose.eulalio
@since 02/04/13
@version 1.0
@return aRotina
/*/
//-------------------------------------------------------------------

STATIC Function MenuDef()
Local aRotina	:= {}

ADD OPTION aRotina TITLE STR0011	ACTION 'VIEWDEF.WFCNTA300' OPERATION 2 ACCESS 0 // 'Visualizar'
ADD OPTION aRotina TITLE STR0012	ACTION 'VIEWDEF.WFCNTA300' OPERATION 3 ACCESS 0 // 'Incluir'
ADD OPTION aRotina TITLE STR0013	ACTION 'VIEWDEF.WFCNTA300' OPERATION 4 ACCESS 0 // 'Alterar'
ADD OPTION aRotina TITLE STR0014	ACTION 'VIEWDEF.WFCNTA300' OPERATION 5 ACCESS 0 // 'Excluir'

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel 	:= Nil

Local oStru1 	:= FWFormModelStruct():New()
Local oStru2 	:= FWFormModelStruct():New()
Local oStru3 	:= FWFormModelStruct():New()
Local oStru4 	:= FWFormModelStruct():New()
Local oStru5 	:= FWFormModelStruct():New()
Local oStruSCR:= FWFormStruct(1,'SCR', {|cCampo| AllTrim(cCampo) $ "CR_FILIAL|CR_NUM|CR_TIPO|CR_TOTAL|CR_APROV|CR_USER|CR_USERORI|CR_GRUPO|CR_ITGRP|CR_OBS"})

Local aModelFlg	:= {}

Local nX			:= 0
Local nTamFilial	:= 0
Local nTamFor		:= 0
Local nTamCli		:= 0
Local nTamCC		:= 0
Local nTamCCont	:= 0
Local nTamIC		:= 0
Local nTamCV		:= 0

oStru1:AddTable("   ",{" "}," ")
oStru2:AddTable("   ",{" "}," ")
oStru3:AddTable("   ",{" "}," ")
oStru4:AddTable("   ",{" "}," ")
oStru5:AddTable("   ",{" "}," ")

//- Estrutura array de campos.
//  {cCampo, cTipo, nTam, cMasc, cDescri, cTitulo, aCombo, cConsulta, bWhen, bValid, bInit })

//-- Inclusão de campos com chave de usuarios FLUIG (aSCR)
If Empty(aSCR)
	aAdd( aSCR,{'CR_CODSOL'	,'C' , 50 , '@!'	,STR0015	,STR0015	,{}			, NIL, Nil, Nil, Nil, 0   } ) // 'Solicitante'
	aAdd( aSCR,{'CR_CODAPR'	,'C' , 50 , '@!'	,STR0002	,STR0002	,{}			, NIL, Nil, Nil, Nil, 0   } ) // 'Aprovador'
	aAdd( aSCR,{'CR_NUMDOCS'	,'M' , 254, '@!'	,STR0016	,STR0016	,{}			, NIL, Nil, Nil, Nil, 0   } ) // 'Documentos'
EndIf

//-- Inclusão de estrutura aWF1
If Empty(aWF1)
	aAdd( aWF1,{'WF1_PAREC' ,'M' , 50 , '@!'	,STR0017	,STR0017	,{}			, NIL, Nil, Nil, Nil, 0   } ) // 'Parecer'
EndIf

//-- Inclusão de estrutura aWF2
If Empty(aWF2)
	nTamFilial := TamSX3("CN9_FILCTR")[1]+43
	aAdd( aWF2,{'WF2_FILIAL'	,'C',nTamFilial				,'@!'							,STR0018 	,STR0018	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Filial'
	aAdd( aWF2,{'WF2_DOC'	,'C',TAMSX3("CN9_NUMERO")[1],'@!'							,STR0019 	,STR0019	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Documento'
	aAdd( aWF2,{'WF2_TPCONT'	,'C',TAMSX3("CN1_DESCRI")[1],'@!'							,STR0020	,STR0020	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Tp.Contrato'
	aAdd( aWF2,{'WF2_INDICE'	,'C',TAMSX3("CN6_DESCRI")[1],'@!'							,STR0025 	,STR0025	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Indice'
	aAdd( aWF2,{'WF2_DTINI'	,'D',8 						,''								,STR0021	,STR0021	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Dt. Inicio'
	aAdd( aWF2,{'WF2_DTFIM'	,'D',8 						,''								,STR0022	,STR0022	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Dt. Final'
	aAdd( aWF2,{'WF2_MOEDA'	,'C',20						,''								,STR0023	,STR0023	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Moeda'
	aAdd( aWF2,{'WF2_VALOR'	,'N',TAMSX3("CN9_VLINI")[1]	,PesqPict("CN9","CN9_VLINI"),STR0024	,STR0024 	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CN9_VLINI")[2]	}) // 'Valor Inicial'
	aAdd( aWF2,{'WF2_TOTAPR'	,'N',TAMSX3("CR_TOTAL")[1]	,PesqPict("SCR","CR_TOTAL")	,STR0041	,STR0041	,{}	,NIL ,NIL ,NIL, NIL, TAMSX3("CR_TOTAL")[2]	}) // 'Valor Aprovação'
	aAdd( aWF2,{'WF2_CODOBJ'	,'M',254						,'@!'							,STR0026	,STR0026	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Objeto'
	aAdd( aWF2,{'WF2_CODCLA'	,'M',254						,'@!'							,STR0027	,STR0027  	,{}	,NIL ,NIL, NIL ,NIL, 0   } ) // 'Clausulas'
EndIf

//-- Inclusão de estrutura aWF3
If Empty(aWF3)
	nTamFor := TamSX3("CNA_FORNEC")[1]+TamSX3("CNA_LJFORN")[1]+TamSX3("A2_NOME")[1]+4
	nTamCli := TamSX3("CNA_CLIENT")[1]+TamSX3("CNA_LOJACL")[1]+TamSX3("A1_NOME")[1]+4
	nTamFor := Iif(nTamCli > nTamFor,nTamCli,nTamFor)
	aAdd( aWF3,{'WF3_NUM'	,'C',TAMSX3("CNA_NUMERO")[1],'@!'							,STR0028	,STR0028	,{}	,NIL ,NIL ,NIL ,NIL, 0   } )	//	'Numero'
	aAdd( aWF3,{'WF3_FORCLI'	,'C',nTamFor					,'@!'							,STR0029	,STR0029	,{}	,NIL ,NIL ,NIL ,NIL, 0   } )	//	'Fornecedor\Cliente'
	aAdd( aWF3,{'WF3_VLTOT'	,'N',TAMSX3("CNA_VLTOT")[1]	,PesqPict("CNA","CNA_VLTOT"),STR0030	,STR0030	,{}	,NIL ,NIL ,NIL ,NIL, 2   } )	//	'Vl.Total'
EndIf

//-- Inclusão de estrutura aWF4
If Empty(aWF4)
	nTamCC		:= TamSX3("CTT_CUSTO")[1]+TamSX3("CTT_DESC01")[1]+3
	nTamCCont	:= TamSX3("CT1_CONTA")[1]+TamSX3("CT1_DESC01")[1]+3
	nTamIC		:= TamSX3("CTD_ITEM")[1]+TamSX3("CTD_DESC01")[1]+3
	nTamCV		:= TamSX3("CTH_CLVL")[1]+TamSX3("CTH_DESC01")[1]+3
	aAdd( aWF4,{'WF4_NUM'	,'C',TAMSX3("CNB_NUMERO")[1],'@!'								,STR0031	,STR0031	,{}	,NIL ,NIL	,NIL ,NIL, 0  } )	// 'Planilha'
	aAdd( aWF4,{'WF4_PRODUT'	,'C',TAMSX3("CNB_PRODUT")[1],'@!'								,STR0032	,STR0032	,{}	,NIL ,NIL	,NIL ,NIL, 0  } )	// 'Prod./Grupo'
	aAdd( aWF4,{'WF4_DESCRI'	,'C',TAMSX3("CNB_DESCRI")[1],'@!'								,STR0033	,STR0033	,{}	,NIL ,NIL	,NIL ,NIL, 0  } )	// 'Descricao'
	aAdd( aWF4,{'WF4_QUANT'	,'N',TAMSX3("CNB_QUANT")[1]	,''									,STR0034	,STR0034	,{}	,NIL ,NIL	,NIL ,NIL, 0  } )	// 'Quantidade'
	aAdd( aWF4,{'WF4_VLUNIT'	,'N',TAMSX3("CNB_VLUNIT")[1],PesqPict("CNB","CNB_VLUNIT")	,STR0035	,STR0035	,{}	,NIL ,NIL	,NIL ,NIL, 2  } )	// 'Vl.Unit.'
	aAdd( aWF4,{'WF4_VLTOT'	,'N',TAMSX3("CNB_VLTOT")[1]	,PesqPict("CNB","CNB_VLTOT")	,STR0030	,STR0030	,{}	,NIL ,NIL	,NIL ,NIL, 2  } )	// 'Vl.Total'
	aAdd( aWF4,{'WF4_CC'		,'C',nTamCC					,'@!'								,STR0003	,STR0003	,{}	,NIL ,NIL	,NIL ,NIL, 0  } )	// 'C. Custo'
	aAdd( aWF4,{'WF4_CCONT'	,'C',nTamCCont				,'@!'								,STR0036	,STR0036	,{}	,NIL ,NIL 	,NIL ,NIL, 0  } )	// 'C.Contabil'
	aAdd( aWF4,{'WF4_IC'		,'C',nTamIC					,'@!'								,STR0037	,STR0037	,{}	,NIL ,NIL 	,NIL ,NIL, 0  } )	// 'It.Contab.'
	aAdd( aWF4,{'WF4_CV'		,'C',nTamCV					,'@!'								,STR0004	,STR0004	,{}	,NIL ,NIL 	,NIL ,NIL, 0  } )	// 'C. Valor'
EndIf

//-- Inclusão de estrutura aWF5
If Empty(aWF5)
	aAdd( aWF5, {'WF5_GRUPO'		,TAMSX3('AL_DESC')[3]	,TAMSX3('AL_DESC')[1]	,PesqPict('SAL','AL_DESC')		,'Grupo',		'Grupo',		{},	NIL,NIL,NIL,NIL,0	})	//Grupo
	aAdd( aWF5, {'WF5_NIVEL'		,TAMSX3('CR_NIVEL')[3]	,TAMSX3('CR_NIVEL')[1]	,PesqPict('SCR','CR_NIVEL')		,'Nivel',		'Nivel',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF5, {'WF5_USER'		,'C'						,200						,'@!'								,'Aprovador',	'Aprovador',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF5, {'WF5_STATUS'	,'C'						,50							,'@!'								,'Situação',	'Situação',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF5, {'WF5_DATA'		,TAMSX3('CR_DATALIB')[3]	,TAMSX3('CR_DATALIB')[1]	,PesqPict('SCR','CR_DATALIB')	,'Data',		'Data',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF5, {'WF5_OBS'		,'M'						,254						,'@!'								,'Observações','Observações',{},	NIL,NIL,NIL,NIL,0	})	//Nivel
EndIf

//------------------------------------------------------------------------
// Construção das estruturas
//------------------------------------------------------------------------
//- P.E que permite alteração dos campos para customização
If ExistBlock("WFC300MODEL")
	aModelFlg := ExecBlock("WFC300MODEL",.F.,.F.,{"MODEL_ADD",{},"WF1"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF1,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF1,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300MODEL",.F.,.F.,{"MODEL_ADD",{},"WF2"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF2,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF2,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300MODEL",.F.,.F.,{"MODEL_ADD",{},"WF3"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF3,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF3,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300MODEL",.F.,.F.,{"MODEL_ADD",{},"WF4"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF4,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF4,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300MODEL",.F.,.F.,{"MODEL_ADD",{},"WF5"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF5,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF5,aModelFlg[nX])
		EndIf
	Next nX
EndIf

WF300Model(aSCR,"STRUSCR_",oStruSCR)
WF300Model(aWF1,"STRU1_",oStru1)
WF300Model(aWF2,"STRU2_",oStru2)
WF300Model(aWF3,"STRU3_",oStru3)
WF300Model(aWF4,"STRU4_",oStru4)
WF300Model(aWF5,"STRU5_",oStru5)

//-- Construção do modelo
oModel := MPFormModel():New('WFCNTA300', /*bPreValidacao*/, /*bPosValidacao*/, {|oModel|A300LibDoc(oModel)}/*bCommit*/, /*bCancel*/ )

//-- Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'SCRMASTER', /*cOwner*/ , oStruSCR)
oModel:AddFields( 'WF1MASTER', 'SCRMASTER', oStru1, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF300LWF(oModel,"WF1")} )
oModel:AddFields( 'WF2DETAIL', 'WF1MASTER', oStru2, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF300LWF(oModel,"WF2")} )
oModel:AddGrid(   'WF3DETAIL', 'WF2DETAIL', oStru3, /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ ,{|oModel|WF300LWF(oModel,"WF3")} )
oModel:AddGrid(   'WF4DETAIL', 'WF3DETAIL', oStru4, /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ ,{|oModel|WF300LWF(oModel,"WF4")} )
oModel:AddGrid(   'WF5DETAIL', 'WF2DETAIL', oStru5, /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ ,{|oModel|WF300LWF(oModel,"WF5")} )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( STR0005 )//'Workflow de Contrato'

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0006 )//'Alçada'
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0008 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0009 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0007 )//'Planilhas'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0038 )//'Itens/Agrupadores'
oModel:GetModel( 'WF5DETAIL' ):SetDescription( STR0040 )//'Histórico de Aprovações'

oModel:GetModel("WF1MASTER"):SetOnlyQuery(.T.)
oModel:GetModel("WF2DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF3DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF4DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF5DETAIL"):SetOnlyQuery(.T.)

oModel:GetModel("WF2DETAIL"):SetOptional(.T.)
oModel:GetModel("WF3DETAIL"):SetOptional(.T.)
oModel:GetModel("WF4DETAIL"):SetOptional(.T.)
oModel:GetModel("WF5DETAIL"):SetOptional(.T.)

oModel:GetModel("WF3DETAIL"):SetNoDeleteLine(.T.)
oModel:GetModel("WF4DETAIL"):SetNoDeleteLine(.T.)
oModel:GetModel("WF5DETAIL"):SetNoDeleteLine(.T.)

oModel:SetRelation("WF4DETAIL",{{'WF4_NUM','WF3_NUM'}})

oModel:SetPKIndexOrder(2)
oModel:SetPrimaryKey( {'CR_TIPO','CR_NUM','CR_USER'} )

//-- Realiza carga dos campos do mecanismo de atribuição
oModel:SetActivate( { |oModel| Wf300MecAt( oModel ) } )

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} WF300Model
Função para adicionar dinamicamente os campos na estrutura

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Function WF300Model(aCampos,cStru,oStru)
Local nCampo := 1
Local cCampo := ''

For nCampo := 1 To Len(aCampos)
	//cCampo := cStru + aCampos[nCampo][01]
	//-- Adiciona campos header do filtro de busca de fornecedor
	oStru:AddField(aCampos[nCampo][05]		,;	// 	[01]  C   Titulo do campo
				 	aCampos[nCampo][06]		,;	// 	[02]  C   ToolTip do campo
				 	aCampos[nCampo][01]		,;	// 	[03]  C   Id do Field
				 	aCampos[nCampo][02]		,;	// 	[04]  C   Tipo do campo
				 	aCampos[nCampo][03]		,;	// 	[05]  N   Tamanho do campo
				 	aCampos[nCampo][12]		,;	// 	[06]  N   Decimal do campo
				 	aCampos[nCampo][10]		,;	// 	[07]  B   Code-block de validação do campo
				 	aCampos[nCampo][09]		,;	// 	[08]  B   Code-block de validação When do campo
				 	aCampos[nCampo][07]		,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.						,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
				 	aCampos[nCampo][11]		,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL						,;	//	[12]  L   Indica se trata-se de um campo chave
				 	.F.						,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.						)	// 	[14]  L   Indica se o campo é virtual
Next nCampo

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author jose.eulalio

@since 01/04/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel	:= ModelDef()

// Cria a estrutura a ser usada na View
Local oStru1	:= FWFormViewStruct():New()
Local oStru2	:= FWFormViewStruct():New()
Local oStru3	:= FWFormViewStruct():New()
Local oStru4	:= FWFormViewStruct():New()
Local oStru5	:= FWFormViewStruct():New()
Local oStruSCR:= FWFormStruct(2, 'SCR', {|cCampo| AllTrim(cCampo)  $ "CR_FILIAL|CR_NUM|CR_TIPO|CR_APROV|CR_USER|CR_USERORI|CR_GRUPO|CR_ITGRP|CR_OBS"},,,.T.)
Local nCampo  := 0

WF300View(aSCR,'SCR_',oStruSCR)
WF300View(aWF1,'WF1_',oStru1)
WF300View(aWF2,'WF2_',oStru2)
WF300View(aWF3,'WF3_',oStru3)
WF300View(aWF4,'WF4_',oStru4)
WF300View(aWF5,'WF5_',oStru5)

// Monta o modelo da interface do formulario
oView := FWFormView():New()
oView:SetModel(oModel)

oView:AddField('VIEW_SCR', oStruSCR,'SCRMASTER')
oView:AddField('VIEW_WF1', oStru1,'WF1MASTER')
oView:AddField('VIEW_WF2', oStru2,'WF2DETAIL')
oView:AddGrid( 'VIEW_WF3', oStru3,'WF3DETAIL')
oView:AddGrid( 'VIEW_WF4', oStru4,'WF4DETAIL')
oView:AddGrid( 'VIEW_WF5', oStru5,'WF5DETAIL')

oView:CreateHorizontalBox( 'SCR' ,1 )
oView:CreateHorizontalBox( 'WF1' ,19 )
oView:CreateHorizontalBox( 'WF2' ,20 )
oView:CreateHorizontalBox( 'WF3' ,20 )
oView:CreateHorizontalBox( 'WF4' ,20 )
oView:CreateHorizontalBox( 'WF5' ,20 )

oView:SetOwnerView('VIEW_SCR','SCR')
oView:SetOwnerView('VIEW_WF1','WF1')
oView:SetOwnerView('VIEW_WF2','WF2')
oView:SetOwnerView('VIEW_WF3','WF3')
oView:SetOwnerView('VIEW_WF4','WF4')
oView:SetOwnerView('VIEW_WF5','WF5' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0006 )//'Alçada'
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0008 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0009 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0007 )//'Planilhas'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0039 )//'Itens'
oModel:GetModel( 'WF5DETAIL' ):SetDescription( STR0040 )//'Histórico de Aprovações'

oView:EnableTitleView('VIEW_WF1' , STR0008 ) // 'Decisão'
oView:EnableTitleView('VIEW_WF2' , STR0009 ) // 'Informações do Documento'
oView:EnableTitleView('VIEW_WF3' , STR0007 ) // 'Planilhas'
oView:EnableTitleView('VIEW_WF4' , STR0039 ) // 'Itens'
oView:EnableTitleView('VIEW_WF5' , STR0040 ) // 'Histórico de Aprovações'

aSCR := {}
aWF1 := {}
aWF2 := {}
aWF3 := {}
aWF4 := {}
aWF5 := {}

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} WF300View
Função para adicionar dinamicamente os campos na view

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Function WF300View(aCampos,cStru,oStru)
Local nCampo := Iif(cStru=='SCR_',22,0)
Local cCampo := ''
Local lAltCampo 	:= .T.
Local aModelFlg	:= {}

If ExistBlock("WFC300MODEL")
	aModelFlg := ExecBlock("WFC300MODEL",.F.,.F.,{"VIEW_HIDE",{},LEFT(cStru,3)})
EndIf

For nCampo := 1 To Len(aCampos)
	lAltCampo := Iif(aCampos[nCampo,1] $ 'WF1_PAREC',.T.,.F.)
	cOrdem := StrZero(nCampo,2)

	If !aScan(aModelFlg,aCampos[nCampo][01])
		//-- Adiciona campos header do filtro de busca de fornecedor
		oStru:AddField(aCampos[nCampo][01]		,;	// [01]  C   Nome do Campo
						cOrdem						,;	// [02]  C   Ordem
						aCampos[nCampo][05] 		,;	// [03]  C   Titulo do campo
						aCampos[nCampo][06] 		,;	// [04]  C   Descricao do campo
						{}							,;	// [05]  A   Array com Help
						aCampos[nCampo][02]			,;	// [06]  C   Tipo do campo
						aCampos[nCampo][04]			,;	// [07]  C   Picture
						NIL							,;	// [08]  B   Bloco de Picture Var
						aCampos[nCampo][08]			,;	// [09]  C   Consulta F3
						lAltCampo							,;	// [10]  L   Indica se o campo é alteravel
						NIL							,;	// [11]  C   Pasta do campo
						NIL							,;	// [12]  C   Agrupamento do campo
						aCampos[nCampo][07]			,;	// [13]  A   Lista de valores permitido do campo (Combo)
						2							,;	// [14]  N   Tamanho maximo da maior opção do combo
						NIL							,;	// [15]  C   Inicializador de Browse
						.F.							,;	// [16]  L   Indica se o campo é virtual
						NIL							,;	// [17]  C   Picture Variavel
						.F.							)	// [18]  L   Indica pulo de linha após o campo
	EndIf
Next nCampo

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} WF300LWF(oModel,cLoad)
Função que retorna a carga de dados do cabeçalho da aprovação

@author Israel.Escorizza
@since 25/05/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF300LWF(oModel,cLoad)
Local aReturn := {}

DO 	CASE
	CASE cLoad == "WF1"
		aReturn := WF300LWF1(oModel)
	CASE cLoad == "WF2"
		aReturn := WF300LWF2(oModel)
	CASE cLoad == "WF3"
		aReturn := WF300LWF3(oModel)
	CASE cLoad == "WF4"
		aReturn := WF300LWF4(oModel)
	CASE cLoad == "WF5"
		aReturn := WF300LWF5(oModel)
ENDCASE

If ExistBlock("WFC300MODEL")
	aReturn := ExecBlock("WFC300MODEL",.F.,.F.,{"LOAD",aReturn,cLoad})
EndIf

Return aReturn

//-------------------------------------------------------------------
/*/{Protheus.doc} WF300LWF1
Função que retorna a carga de dados do cabeçalho da aprovação da
Solicitação de Compras

@author Augustos.Raphael
@since 30/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF300LWF1(oModel)
Local aLoad	:= {}
Local aAux		:= {}

aAdd(aAux, "")	//'WF1_PAREC'	,'M' , 10 , '@!'
aLoad := {aAux, 0}

Return aLoad


//-------------------------------------------------------------------
/*/{Protheus.doc} WF300LWF2
Função que retorna a carga de dados do corpo da aprovação da
Solicitação de Compras

@author Augustos.Raphael
@since 30/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF300LWF2(oModel)
Local aLoad	 := {}
Local aAux		 := {}
Local cFilNome := ''
Local cDescTpC := ""
Local cDescInd := ""
Local cDescObj := ""
Local cDescCla := ""
Local cNumContr:= Padr(SCR->CR_NUM,TamSX3("CN9_NUMERO")[1])
Local aAreaAnt := GetArea()

// Posiciona o Contrato para quando a chamada for via WebService
DbSelectArea("CN9")
CN9->(DbSetOrder(1))
CN9->(DbSeek(xFilial("CN9")+cNumContr))

cDescTpC := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO ,"CN1_DESCRI")
cDescInd := Posicione("CN6",1,xFilial("CN6")+CN9->CN9_INDICE,"CN6_DESCRI")
cDescInd := Iif(Valtype(cDescInd)<>'C',"",cDescInd)
cFilNome := CN9->CN9_FILCTR+" - "+FWFilialName(,CN9->CN9_FILCTR)

cDescObj := MSMM( CN9->CN9_CODOBJ )
cDescObj := Iif(Valtype(cDescObj)<>'C',"",cDescObj)
cDescCla := MSMM( CN9->CN9_CODCLA )
cDescCla := Iif(Valtype(cDescCla)<>'C',"",cDescCla)

aAdd(aAux, cFilNome) 				  									//'WF2_FILIAL'	,'C',20,'@!'
aAdd(aAux, CN9->CN9_NUMERO )         									//'WF2_DOC'		,'C',10,'@!'
aAdd(aAux, cDescTpC )               									//'WF2_TPCONT'	,'C',15 ,''
aAdd(aAux, cDescInd )                									//'WF2_INDICE'	,'C',10 ,''
aAdd(aAux, CN9->CN9_DTINIC  )        									//'WF2_DTINI'		,'D',8 ,''
aAdd(aAux, CN9->CN9_DTFIM   )        									//'WF2_DTFIM'		,'D',8 ,''
aAdd(aAux, SuperGetMv("MV_MOEDA"+AllTrim(Str(CN9->CN9_MOEDA,2))) )	//'WF2_MOEDA'		,'C',20 ,''
aAdd(aAux, CN9->CN9_VLINI )          									//'WF2_VALOR'		,'N',12 ,''
aAdd(aAux,	oModel:GetModel():GetValue('SCRMASTER','CR_TOTAL'))		//'WF2_TOTAPR'	,'N',12,''
aAdd(aAux, cDescObj ) 													//'WF2_CODOBJ'	,'M',254,'@!'
aAdd(aAux, cDescCla ) 													//'WF2_CODCLA'	,'M',254,'@!'
aLoad := {aAux, 0}

RestArea(aAreaAnt)

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300LWF3(oModel)
Carga das planilhas do contrato
@author Augustos.Raphael
@since 01/10/2015
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300LWF3(oModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cAliasTemp	:= GetNextAlias()
Local cCliFor		:= ""
Local cDesTpPla	:= ""
Local cDCliFor	:= ""
Local cCliForL	:= ""
Local cCampos		:= ""
Local cSql			:= ""
Local cNumContr	:= Padr(SCR->CR_NUM,TamSX3("CN9_NUMERO")[1])
Local cNumPlan	:= ""
Local lAglFlg		:= SuperGetMV("MV_CNAGFLG",.F.,.F.)	//- Aglutinação de aprovações no Fluig
Local cNumDocs	:= GetScrAglu()
Local nPos			:= 0
Local cDoc			:= ""
Local cAux			:= cNumDocs

//CNA
cCampos := "CNA.CNA_NUMERO, CNA.CNA_TIPPLA, CNA.CNA_CONTRA, CNA.CNA_REVISA, "
cCampos += "CNA.CNA_FORNEC, CNA.CNA_LJFORN, CNA.CNA_CLIENT, CNA.CNA_LOJACL, "
cCampos += "CNA.CNA_VLTOT, CNA.CNA_DTINI, CNA.CNA_DTFIM, CNA.CNA_FLREAJ, CN9.CN9_TPCTO, CNA.R_E_C_N_O_"

cSql := " SELECT "
cSql += cCampos
cSql += " FROM "+RetSqlName("CN9")+" CN9 "

cSql += " JOIN  "+RetSqlName("CNA")+" CNA "
cSql += " ON CNA_FILIAL = CN9_FILIAL "
cSql += " AND CNA_CONTRA =  CN9_NUMERO ""
cSql += " AND CNA_REVISA =  CN9_REVISA "
cSql += " AND CNA_NUMERO  > ' ' "
cSql += " AND CNA.D_E_L_E_T_= ' ' "

cSql += " WHERE CN9_FILIAL = '"+xFilial("CN9")+"' "
cSql += " AND CN9_NUMERO = '" + cNumContr +"' "
cSql += " AND CN9_REVATU = '' "
cSql += " AND CN9.D_E_L_E_T_= ' ' "

If SCR->CR_TIPO == "IC"
	If lAglFlg .And. !Empty(cAux)
		While !Empty(cAux)
			nPos := At(",",cAux)
			If nPos > 0
				cDoc := Substr(cAux,1,nPos-1)
				cAux := Substr(cAux,nPos+2)
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+1,TamSX3("CNA_NUMERO")[1])+"'"
				If !Empty(cAux)
					cNumPlan += ","
				Endif
			Else
				cDoc := cAux
				cAux := ""
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+1,TamSX3("CNA_NUMERO")[1])+"'"
			Endif
		EndDo
	Else
		cNumPlan += "'"+Substr(SCR->CR_NUM,Len(cNumContr)+1,TamSX3("CNA_NUMERO")[1])+"'"
	Endif
	cSql += " AND CNA_NUMERO IN ("+cNumPlan+")"
Endif

cSql += " ORDER BY CNA.CNA_CONTRA, CNA.CNA_REVISA, CNA.CNA_NUMERO "

cSql := ChangeQuery(cSql)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasTemp,.F.,.T.)

TcSetField(cAliasTemp,"CNA_VLTOT"	,GetSx3Cache("CNA_VLTOT","X3_TIPO"),TamSx3("CNA_VLTOT")[1],TamSx3("CNA_VLTOT")[2])
TcSetField(cAliasTemp,"CNA_DTINI"	,GetSx3Cache("CNA_DTINI","X3_TIPO"),TamSx3("CNA_DTINI")[1],TamSx3("CNA_DTINI")[2])
TcSetField(cAliasTemp,"CNA_DTFIM"	,GetSx3Cache("CNA_DTFIM","X3_TIPO"),TamSx3("CNA_DTFIM")[1],TamSx3("CNA_DTFIM")[2])


While (cAliasTemp)->(!Eof())

	If !Empty( AllTrim((cAliasTemp)->CNA_FORNEC) )
		cCliFor	:= (cAliasTemp)->CNA_FORNEC
		cCliForL	:= (cAliasTemp)->CNA_LJFORN
		cDCliFor	:= POSICIONE("SA2",1,XFILIAL("SA2")+cCliFor+cCliForL,"A2_NOME")
	Else
		cCliFor	:= (cAliasTemp)->CNA_CLIENT
		cCliForL	:= (cAliasTemp)->CNA_LOJACL
		cDCliFor	:= POSICIONE("SA1",1,XFILIAL("SA1")+cCliFor+cCliForL,"A1_NOME")
	EndIf

	cDesTpPla := POSICIONE("CNL",1,XFILIAL("CNL")+(cAliasTemp)->CNA_TIPPLA,"CNL_DESCRI")

	AADD(aAux, (cAliasTemp)->CNA_NUMERO )      					//'WF3_NUM'	,'C',06,'@!'
	AADD(aAux, cCliFor + " " + cCliForL + " - " + cDCliFor ) 	//'WF3_FORCLI','C',45,'@!'
	AADD(aAux, (cAliasTemp)->CNA_VLTOT  )       					//'WF3_VLTOT'	,'N',16,'@!'

	AADD(aLoad, {(cAliasTemp)->R_E_C_N_O_,aClone(aAux)})
	(cAliasTemp)->(DbSkip())
	aAux := {}
End

(cAliasTemp)->(dbClosearea())

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300LWF4(oCNBModel)
Carga dos itens do contrato

@author guilherme.pimentel
@since 13/10/2015
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300LWF4(oCNBModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cAliasTemp	:= GetNextAlias()
Local cCliFor		:= ""
Local cDesTpPla	:= ""
Local cDCliFor	:= ""
Local cCliForL	:= ""
Local cCampos		:= ""
Local cSql			:= ""
Local nTamContr	:= TamSX3("CNB_CONTRA")[1]
Local cNumContr	:= Padr(Substr(SCR->CR_NUM,1,nTamContr),nTamContr)
Local lAglFlg		:= SuperGetMV("MV_CNAGFLG",.F.,.F.)	//- Aglutinação de aprovações no Fluig
Local cNumPlan	:= ""
Local cNumDocs	:= GetScrAglu()
Local nPos			:= 0
Local cDoc			:= ""
Local cAux			:= cNumDocs
Local cProdut		:= ""
Local cDescri		:= ""

If Alltrim(SCR->CR_TIPO) == 'CT' // Aprovação Principal

	BeginSQL Alias cAliasTemp

	SELECT
		CNB.CNB_NUMERO CNB_NUMERO,
		CNB.CNB_PRODUT CNB_PRODUT,
	   	CNB.CNB_DESCRI CNB_DESCRI,
	   	'' CNB_AGRTIP,
	   	'' CNB_AGRGRP,
	   	'' CNB_AGRCAT,
	   	CNB.CNB_QUANT CNB_QUANT,
	   	CNB.CNB_VLUNIT CNB_VLUNIT,
	   	CNB.CNB_VLTOT CNB_VLTOT,
	   	CNB.CNB_CC CNB_CC,
	   	CNB.CNB_CONTA CNB_CONTA,
	   	CNB.CNB_ITEMCT CNB_ITEMCT,
	   	CNB.CNB_CLVL CNB_CLVL,
	   	CNB.R_E_C_N_O_ RECNO
	FROM
		%Table:CNB% CNB
	WHERE
		CNB.%NotDel% AND
	   	CNB.CNB_FILIAL = %xFilial:CNB% AND
	   	CNB.CNB_CONTRA = %Exp:cNumContr%

	UNION

	SELECT
		CXM.CXM_NUMERO CNB_NUMERO,
		'' CNB_PRODUT,
	   	'' CNB_DESCRI,
	   	CXM.CXM_AGRTIP CNB_AGRTIP,
	   	CXM.CXM_AGRGRP CNB_AGRGRP,
	   	CXM.CXM_AGRCAT CNB_AGRCAT,
	   	0 CNB_QUANT,
	   	0 CNB_VLUNIT,
	   	CXM.CXM_VLMAX CNB_VLTOT,
	   	CXM.CXM_CC CNB_CC,
	   	'' CNB_CONTA,
	   	'' CNB_ITEMCT,
	   	'' CNB_CLVL,
	   	CXM.R_E_C_N_O_ RECNO
	FROM
		%Table:CXM% CXM
	WHERE
		CXM.%NotDel% AND
	   	CXM.CXM_FILIAL = %xFilial:CXM% AND
	   	CXM.CXM_CONTRA = %Exp:cNumContr%
	EndSQL

Else // Aprovação por Item da Entidade Contábil (IC)

	// Filtra planilhas a serem selecionadas
	cNumPlan += "%("
	If lAglFlg .And. !Empty(cAux)
		While !Empty(cAux)
			nPos := At(",",cAux)
			If nPos > 0
				cDoc := Substr(cAux,1,nPos-1)
				cAux := Substr(cAux,nPos+2)
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+1,TamSX3("CNA_NUMERO")[1])+"'"
				If !Empty(cAux)
					cNumPlan += ","
				Endif
			Else
				cDoc := cAux
				cAux := ""
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+1,TamSX3("CNA_NUMERO")[1])+"'"
			Endif
		EndDo
	Else
		cNumPlan += "'"+Substr(SCR->CR_NUM,nTamContr+1,TamSX3("CNA_NUMERO")[1])+"'"
	Endif
	cNumPlan += ")%"

	BeginSQL Alias cAliasTemp
	SELECT
		CNB.CNB_NUMERO CNB_NUMERO,
		CNB.CNB_PRODUT CNB_PRODUT,
	   	CNB.CNB_DESCRI CNB_DESCRI,
	   	'' CNB_AGRTIP,
	   	'' CNB_AGRGRP,
	   	'' CNB_AGRCAT,
	   	CNB.CNB_QUANT  * (ISNULL(CNZ.CNZ_PERC,100) / 100) 	CNB_QUANT,
	   	CNB.CNB_VLUNIT  											CNB_VLUNIT,
	   	CNB.CNB_VLTOT  * (ISNULL(CNZ.CNZ_PERC,100) / 100) 	CNB_VLTOT,
	   	ISNULL(CNZ.CNZ_CC,CNB.CNB_CC) CNB_CC,
	   	ISNULL(CNZ.CNZ_CONTA,CNB.CNB_CONTA) CNB_CONTA,
	   	ISNULL(CNZ.CNZ_ITEMCT,CNB.CNB_ITEMCT) CNB_ITEMCT,
	   	ISNULL(CNZ.CNZ_CLVL,CNB.CNB_CLVL) CNB_CLVL,
	   	CNB.R_E_C_N_O_ RECNO
	FROM
		%Table:DBM% DBM
	JOIN
		%Table:CNB% CNB
	ON
	   	CNB.%NotDel% AND
	   	CNB.CNB_FILIAL = %xFilial:CNB% AND
	   	CNB.CNB_CONTRA = %Exp:cNumContr% AND
		CNB.CNB_ITEM = DBM.DBM_ITEM
	LEFT JOIN
		%Table:CNZ% CNZ
	ON
	    CNZ.%NotDel% AND
	    CNZ.CNZ_FILIAL = %xFilial:CNZ% AND
	    CNZ.CNZ_CONTRA = CNB.CNB_CONTRA AND
	    CNZ.CNZ_REVISA = CNB.CNB_REVISA AND
	    CNZ.CNZ_CODPLA = CNB.CNB_NUMERO AND
	    CNZ.CNZ_ITCONT = CNB.CNB_ITEM AND
	    CNZ.CNZ_ITEM = DBM.DBM_ITEMRA
	WHERE
		DBM.%NotDel% AND
	   	DBM.DBM_FILIAL = %xFilial:DBM% AND
	   	DBM.DBM_TIPO = %Exp:SCR->CR_TIPO% AND
	   	DBM.DBM_NUM = %Exp:SCR->CR_NUM% AND
	   	DBM.DBM_GRUPO = %Exp:SCR->CR_GRUPO% AND
	   	DBM.DBM_ITGRP = %Exp:SCR->CR_ITGRP% AND
	   	DBM.DBM_USER = %Exp:SCR->CR_USER% AND
	   	DBM.DBM_USEROR = %Exp:SCR->CR_USERORI% AND
	   	CNB.CNB_NUMERO IN %Exp:cNumPlan%
	UNION

	SELECT
		CXM.CXM_NUMERO CNB_NUMERO,
		'' CNB_PRODUT,
	   	'' CNB_DESCRI,
	   	CXM.CXM_AGRTIP CNB_AGRTIP,
	   	CXM.CXM_AGRGRP CNB_AGRGRP,
	   	CXM.CXM_AGRCAT CNB_AGRCAT,
	   	0 CNB_QUANT,
	   	0 CNB_VLUNIT,
	   	CXM.CXM_VLMAX CNB_VLTOT,
	   	CXM.CXM_CC CNB_CC,
	   	'' CNB_CONTA,
	   	'' CNB_ITEMCT,
	   	'' CNB_CLVL,
	   	CXM.R_E_C_N_O_ RECNO
	FROM
		%Table:CXM% CXM
	WHERE
		CXM.%NotDel% AND
	   	CXM.CXM_FILIAL = %xFilial:CXM% AND
	   	CXM.CXM_CONTRA = %Exp:cNumContr% AND
	   	CXM.CXM_NUMERO IN %Exp:cNumPlan%

	EndSQL

Endif

While (cAliasTemp)->(!Eof())
	cProdut := ""
	cDescri := ""

	If !Empty((cAliasTemp)->CNB_PRODUT)
		cProdut	:= 	AllTrim((cAliasTemp)->CNB_PRODUT)
		cDescri	:=	AllTrim((cAliasTemp)->CNB_DESCRI)
	Else
		If!Empty((cAliasTemp)->CNB_AGRTIP) //- Possui Agrupador por tipo
			cProdut +=	AllTrim((cAliasTemp)->CNB_AGRTIP)
			cDescri +=	AllTrim(Posicione("SX5",1,xFilial("SX5")+'02'+(cAliasTemp)->CNB_AGRTIP,"X5_DESCRI"))
		EndIf

		If!Empty((cAliasTemp)->CNB_AGRGRP) //- Possui Agrupador por grupo
			cProdut += Iif(!Empty(cProdut),"|","")
			cProdut += AllTrim((cAliasTemp)->CNB_AGRGRP)
			cDescri += Iif(!Empty(cDescri),"|","")
			cDescri += AllTrim(Posicione("SBM",1,xFilial("SBM")+(cAliasTemp)->CNB_AGRGRP,"BM_DESC"))
		EndIf

		If!Empty((cAliasTemp)->CNB_AGRCAT) //- Possui Agrupador por categoria
			cProdut += Iif(!Empty(cProdut),"|","")
			cProdut += AllTrim((cAliasTemp)->CNB_AGRCAT)
			cDescri += Iif(!Empty(cDescri),"|","")
			cDescri += AllTrim(Posicione("ACU",1,xFilial("ACU")+(cAliasTemp)->CNB_AGRTIP,"ACU_DESC"))
		EndIf
	EndIf

	AADD(aAux, (cAliasTemp)->CNB_NUMERO )
	AADD(aAux,  cProdut 					 )
	AADD(aAux,  cDescri 					 )
	AADD(aAux, (cAliasTemp)->CNB_QUANT  )
	AADD(aAux, (cAliasTemp)->CNB_VLUNIT )
	AADD(aAux, (cAliasTemp)->CNB_VLTOT  )
	AADD(aAux, (cAliasTemp)->CNB_CC     + Wf300Descr("CNB_CC"    ,(cAliasTemp)->CNB_CC)	 	)
	AADD(aAux, (cAliasTemp)->CNB_CONTA  + Wf300Descr("CNB_CONTA" ,(cAliasTemp)->CNB_CONTA) 	)
	AADD(aAux, (cAliasTemp)->CNB_ITEMCT + Wf300Descr("CNB_ITEMCT",(cAliasTemp)->CNB_ITEMCT)	)
	AADD(aAux, (cAliasTemp)->CNB_CLVL   + Wf300Descr("CNB_CLVL"  ,(cAliasTemp)->CNB_CLVL)	)

	AADD(aLoad, {(cAliasTemp)->RECNO,aClone(aAux)})
	(cAliasTemp)->(DbSkip())
	aAux := {}
End

// Ordena os itens da planilha
If Len(aLoad) > 0
	aSort(aLoad,,,{ | x,y | x[2,1] < y[2,1] } )
Endif

(cAliasTemp)->(dbClosearea())

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300LWF5(oModel)
Carga da grid de aprovação

@author Israel Escorizza
@since 16/08/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300LWF5(oModel)
Local aArea		:= GetArea()
Local aAreaSCR	:= SCR->(GetArea())
Local aSaveLines	:= FwSaveRows()
Local aLoad	:= {}
Local aAux		:= {}

Local cDoc 		:= Left(SCR->CR_NUM,TAMSX3('CN9_NUMERO')[1])+'%'
Local cSCRFil		:= CnFilCtr(cDoc)
Local cTmpAlias	:= GetNextAlias()

BeginSQL Alias cTmpAlias
	SELECT	SCR.CR_NUM,
			SCR.CR_TIPO,
			SCR.CR_NIVEL,
			SCR.CR_USER,
			SCR.CR_DATALIB,
	   		SCR.CR_STATUS,
	   		SCR.CR_GRUPO,
	   		SCR.R_E_C_N_O_

	FROM 	%Table:SCR% SCR

	WHERE	SCR.%NotDel% AND
			SCR.CR_FILIAL = 		%Exp:cSCRFil% AND
			SCR.CR_NUM 	LIKE 	%Exp:cDoc% 	AND
			SCR.CR_TIPO	IN		('CT','IC')
			AND NOT (
				SCR.CR_TIPO 	= 	%Exp:SCR->CR_TIPO% 	AND
				SCR.CR_GRUPO 	= 	%Exp:SCR->CR_GRUPO%  AND
				SCR.CR_NIVEL 	>= 	%Exp:SCR->CR_NIVEL%
			)

			AND NOT (
				SCR.CR_TIPO 	= 	%Exp:SCR->CR_TIPO% 	AND
				SCR.CR_GRUPO 	!= 	%Exp:SCR->CR_GRUPO%
			)

	ORDER BY SCR.CR_TIPO, SCR.CR_NUM, SCR.CR_NIVEL, SCR.CR_DATALIB
EndSQL
TCSetField(cTmpAlias,"CR_DATALIB","D",8,0)

While !(cTmpAlias)->(EOF())
	aAux := {}
	aAdd(aAux,AllTrim(Posicione("SAL",1,xFilial("SAL")+(cTmpAlias)->CR_GRUPO,"AL_DESC"))) 	// WF5_GRUPO
	aAdd(aAux,(cTmpAlias)->CR_NIVEL)																// WF5_NIVEL
	aAdd(aAux,AllTrim(UsrFullName((cTmpAlias)->CR_USER))) 										// WF5_USER
	aAdd(aAux,AllTrim(x3CboxToArray("CR_STATUS")[1][Val((cTmpAlias)->CR_STATUS)])) 			// WF5_STATUS
	aAdd(aAux,(cTmpAlias)->CR_DATALIB)																// WF5_DATA

	//- Posiciona na tabela fisica para obter valor do Memo Observação
	SCR->(MsGoto((cTmpAlias)->R_E_C_N_O_))
	aAdd(aAux,AllTrim(SCR->CR_OBS))																	// WF5_OBS

	aAdd(aLoad, {(cTmpAlias)->R_E_C_N_O_,aClone(aAux)})
	(cTmpAlias)->(DbSkip())
End

(cTmpAlias)->(dbClosearea())
FWRestRows(aSaveLines)
RestArea(aAreaSCR)
RestArea(aArea)
Return aLoad
//-------------------------------------------------------------------
/*/{Protheus.doc} A300LibDoc
Liberação do documento

@author guilherme.pimentel
@since 13/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Function A300LibDoc(oModel)
Local cUser		:= oModel:GetValue('SCRMASTER','CR_USER')
Local cTipo		:= oModel:GetValue('SCRMASTER','CR_TIPO')
Local cNumDocs	:= oModel:GetValue('SCRMASTER','CR_NUMDOCS')
Local cParecer	:= oModel:GetValue('WF1MASTER','WF1_PAREC')
Local cAprov		:= Iif(oModel:GetWKNextState()=='4','1','2')//oModel:GetValue('WF1MASTER','WF1_SITUAC')
Local cFluig		:= Alltrim(cValToChar(oModel:GetWKNumProces()))
Local cAux			:= cNumDocs
Local nPos			:= 0
Local lRet			:= .F.
Local cNum			:= ""
Local nTamDoc		:= TamSX3("CR_NUM")[1]
Local oModelCT	:= Nil
Private Inclui 	:= .F. // Para carregar o modelo do contrato

If CNFlgVldSt(oModel,@oModelCT)
	While !Empty(cAux)
		nPos := At(",",cAux)
		If nPos > 0
			cNum := Substr(cAux,1,nPos-1)
			cAux := Substr(cAux,nPos+2)
		Else // Sem Aglutinação
			cNum := cAux
			cAux := ""
		Endif
		lRet := MTFlgLbDoc(Padr(cNum,nTamDoc),cUser,cAprov,cTipo,cFluig,cParecer,oModelCT)
	EndDo
Else
	Help(" ",1,'A300LibDoc',,STR0010,4,1)//'Não encontrou o documento a ser liberado'
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WF300Descr
Função que retorna a descrição dos campos de conta contabil

@author Rafael Duram Santos
@since 13/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Function WF300Descr(cCampo,cChave)
Local aArea	:= GetArea()
Local cDescr	:= ""

If !Empty(cChave)
	cDescr += " - "
	If cCampo == "CNB_CC" //CTT
		DbSelectArea("CTT")
		CTT->(DbSetOrder(1))
		If CTT->(DbSeek(xFilial("CTT")+cChave)) //CTT_CUSTO
			cDescr += CTT->CTT_DESC01
		Endif
	Elseif cCampo == "CNB_CONTA" //CT1
		DbSelectArea("CT1")
		CT1->(DbSetOrder(1))
		If CT1->(DbSeek(xFilial("CT1")+cChave)) //CT1_CONTA
			cDescr += CT1->CT1_DESC01
		Endif
	Elseif cCampo == "CNB_ITEMCT" //CTD
		DbSelectArea("CTD")
		CTD->(DbSetOrder(1))
		If CTD->(DbSeek(xFilial("CTD")+cChave)) //CTD_ITEM
			cDescr += CTD->CTD_DESC01
		Endif
	Elseif cCampo == "CNB_CLVL" //CTH
		DbSelectArea("CTH")
		CTH->(DbSetOrder(1))
		If CTH->(DbSeek(xFilial("CTH")+cChave)) //CTH_CLVL
			cDescr += CTH->CTH_DESC01
		Endif
	Endif
Endif

RestArea(aArea)

Return Rtrim(cDescr)

//--------------------------------------------------------------------
/*/{Protheus.doc} Wf300MecAt()
Realiza carga dos campos do mecanismo de atribuição
@author Rafael Duram
@since 04/03/2016
@version 1.0
@return .T.
/*/
//--------------------------------------------------------------------
Static Function Wf300MecAt(oModel)
Local oFieldSCR 	:= oModel:GetModel("SCRMASTER")
Local cUserSolic	:= MtUsrSolic(oFieldSCR:GetValue("CR_TIPO"),oFieldSCR:GetValue("CR_NUM"))
Local cAprov		:= A097UsuApr(oFieldSCR:GetValue("CR_APROV"))
Local cDocs		:= GetScrAglu()

If Empty(cDocs)
	cDocs := oFieldSCR:GetValue("CR_NUM")
Endif

oFieldSCR:LoadValue("CR_CODSOL"  , FWWFColleagueId(cUserSolic) )
oFieldSCR:LoadValue("CR_CODAPR"  , FWWFColleagueId(cAprov)   	)
oFieldSCR:LoadValue("CR_NUMDOCS" , cDocs						   	)

Return