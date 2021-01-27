#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'WFCNTA121.ch'

Static aSCR 		:= {}
Static aWF1 		:= {}
Static aWF2 		:= {}
Static aWF3 		:= {}
Static aWF4 		:= {}
Static aWF5			:= {}
Static oModelCT 	:= NIL
//------------------------------------------------------------------
/*/{Protheus.doc} WFCNTA121()
Medição do Edital
@author augustos.raphael
@since 02/04/13
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
Function WFCNTA121()
Local oBrowse := NIL

oBrowse := FWMBrowse():New()
oBrowse:setAlias("SCR")
oBrowse:SetDescription(STR0001) // "Aprovação Medição de Contrato"
oBrowse:Activate()

Return NIL

//------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Menu de opções do Browse
@author augustos.raphael
@since 02/04/13
@version 1.0
@return aRotina
/*/
//-------------------------------------------------------------------

STATIC Function MenuDef()
Local aRotina	:= {}

ADD OPTION aRotina TITLE STR0002	ACTION 'VIEWDEF.WFCNTA121' OPERATION 2 ACCESS 0 // 'Visualizar'
ADD OPTION aRotina TITLE STR0003	ACTION 'VIEWDEF.WFCNTA121' OPERATION 3 ACCESS 0 // 'Incluir'
ADD OPTION aRotina TITLE STR0004	ACTION 'VIEWDEF.WFCNTA121' OPERATION 4 ACCESS 0 // 'Alterar'
ADD OPTION aRotina TITLE STR0005	ACTION 'VIEWDEF.WFCNTA121' OPERATION 5 ACCESS 0 // 'Excluir'

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
Local oStru5	:= FWFormModelStruct():New()
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
	aAdd( aSCR,{'CR_CODSOL'	,'C' , 50 , '@!'	,STR0010	,STR0010	,{}		, NIL, Nil, Nil, Nil, 0   } ) // 'Solicitante'
	aAdd( aSCR,{'CR_CODAPR'	,'C' , 50 , '@!'	,STR0011	,STR0011	,{}		, NIL, Nil, Nil, Nil, 0   } ) // 'Aprovador'
EndIf

//-- Inclusão de estrutura aWF1
If Empty(aWF1)
	aAdd( aWF1,{'WF1_PAREC'	,'M' , 50 , '@!'	,STR0012	,STR0012	,{}	 	, NIL, Nil, Nil, Nil, 0   } ) // 'Parecer'
EndIf

//-- Inclusão de estrutura aWF2
If Empty(aWF2)
	nTamFilial := TamSX3("CND_FILIAL")[1]+43 // XX8_DESCRI + 3 (" - ")
	aAdd( aWF2,{'WF2_FILIAL'	,'C',nTamFilial				,'@!'								,STR0013 	,STR0013	,NIL	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Filial'
	aAdd( aWF2,{'WF2_DOC'	,'C',TAMSX3("CND_NUMMED")[1],PesqPict("CND","CND_NUMMED")	,STR0014	,STR0014  	,NIL	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Documento'
	aAdd( aWF2,{'WF2_CONT'	,'C',TAMSX3("CND_CONTRA")[1],PesqPict("CND","CND_CONTRA")	,STR0015 	,STR0015  	,NIL	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Contrato'
	aAdd( aWF2,{'WF2_TOTPRE'	,'N',TAMSX3("CND_VLPREV")[1],PesqPict("CND","CND_VLPREV")	,STR0016	,STR0016	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CND_VLPREV")[2]	} ) // 'Total Previsto'
	aAdd( aWF2,{'WF2_TOTMED'	,'N',TAMSX3("CND_VLTOT")[1]	,PesqPict("CND","CND_VLTOT")	,STR0018	,STR0018	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CND_VLTOT")[2]  	} ) // 'Total Medição'
	aAdd( aWF2,{'WF2_TOTAPR'	,'N',TAMSX3("CR_TOTAL")[1]	,PesqPict("SCR","CR_TOTAL")		,STR0017	,STR0017	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CR_TOTAL")[2]})
	aAdd( aWF2,{'WF2_OBS'	,'M',50						,'@!'								,STR0019	,STR0019	,NIL	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Observações'
	aAdd( aWF2,{'WF2_OBJ'	,'M',50						,'@!'								,STR0020	,STR0020	,NIL	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Obj.Contrato'
EndIf

//-- Inclusão de estrutura aWF3
If Empty(aWF3)
	nTamFor := TamSX3("CNA_FORNEC")[1]+TamSX3("CNA_LJFORN")[1]+TamSX3("A2_NOME")[1]+4
	nTamCli := TamSX3("CNA_CLIENT")[1]+TamSX3("CNA_LOJACL")[1]+TamSX3("A1_NOME")[1]+4
	nTamFor := Iif(nTamCli > nTamFor,nTamCli,nTamFor)
	aAdd( aWF3,{'WF3_NUM'		,'C'						,TAMSX3("CNE_NUMERO")[1]	,'@!'								,STR0021	,STR0021	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} ) // 'Planilha'
	aAdd( aWF3,{'WF3_FORCLI'		,'C'						,nTamFor					,'@!'								,STR0022	,STR0022	,NIL  	,NIL ,NIL ,NIL ,NIL, 0  	 						} ) // 'Fornecedor\Cliente'
	aAdd( aWF3,{'WF3_TPCONT'		,'C'						,TAMSX3("CND_COMPET")[1]	,'@!'								,STR0023	,STR0023	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} ) // 'Competência'
	aAdd( aWF3,{'WF3_TOTMED'		,TAMSX3("CXN_VLLIQD")[3]	,TAMSX3("CXN_VLLIQD")[1]	,PesqPict("CXN","CXN_VLLIQD")	,STR0024	,STR0024	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLTOT")[2] 	} ) // 'Valor Medição'
	aAdd( aWF3,{'WF3_TOTREA'		,TAMSX3("CXN_VLTOT")[3]	,TAMSX3("CXN_VLTOT")[1]	,PesqPict("CXN","CXN_VLTOT")	,STR0025	,STR0025	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLTOT")[2] 	} ) // 'Valor Realizado' (Abater e somar valores de multas, bonificações, descontos, adiantamentos)
	aAdd( aWF3,{'WF3_MULTA'		,TAMSX3("CXN_VLMULT")[3]	,TAMSX3("CXN_VLMULT")[1]	,PesqPict("CXN","CXN_VLMULT")	,STR0026	,STR0026	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_MULTA")[2]  	} ) // 'Multas'
	aAdd( aWF3,{'WF3_BONIFI'		,TAMSX3("CXN_VLBONI")[3]	,TAMSX3("CXN_VLBONI")[1]	,PesqPict("CXN","CXN_VLBONI")	,STR0027	,STR0027	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_BONIF")[2]  	} ) // 'Bonificações'
	aAdd( aWF3,{'WF3_DESCON'		,TAMSX3("CXN_VLDESC")[3]	,TAMSX3("CXN_VLDESC")[1]	,PesqPict("CXN","CXN_VLDESC")	,STR0028	,STR0028	,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLDESC")[2] 	} ) // 'Descontos'
	aAdd( aWF3,{'WF3_ADIANT'		,'N'						,15 						,PesqPict("CXN","CXN_VLDESC")	,STR0029	,STR0029	,NIL	,NIL ,NIL, NIL ,NIL, 2   						} ) // 'Adiantamentos'
EndIf

//-- Inclusão de estrutura aWF4
If Empty(aWF4)
	nTamCC		:= TamSX3("CTT_CUSTO")[1]+TamSX3("CTT_DESC01")[1]+3
	nTamCCont	:= TamSX3("CT1_CONTA")[1]+TamSX3("CT1_DESC01")[1]+3
	nTamIC		:= TamSX3("CTD_ITEM")[1]+TamSX3("CTD_DESC01")[1]+3
	nTamCV		:= TamSX3("CTH_CLVL")[1]+TamSX3("CTH_DESC01")[1]+3
	aAdd( aWF4,{'WF4_NUM'	,'C',TAMSX3("CNE_NUMERO")[1],'@!'								,STR0021	,STR0021	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} ) // 'Planilha'
	aAdd( aWF4,{'WF4_PRODUT'	,'C',TAMSX3("CNE_PRODUT")[1],'@!'								,STR0030	,STR0030	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} ) // 'Produto'
	aAdd( aWF4,{'WF4_DESCRI'	,'C',TAMSX3("CNE_DESCRI")[1],'@!'								,STR0031	,STR0031	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} ) // 'Descrição'
	aAdd( aWF4,{'WF4_QUANT'	,'N',TAMSX3("CNE_QUANT")[1]	,PesqPict("CNE","CNE_QUANT")	,STR0032	,STR0032	,{}	,NIL ,NIL ,NIL ,NIL, TAMSX3("CNE_QUANT")[2]  	} ) // 'Quantidade'
	aAdd( aWF4,{'WF4_VLUNIT'	,'N',TAMSX3("CNE_VLUNIT")[1],PesqPict("CNE","CNE_VLUNIT")	,STR0033	,STR0033	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLUNIT")[2] 	} ) // 'Vl.Unit.'
	aAdd( aWF4,{'WF4_VLTOT'	,'N',TAMSX3("CNE_VLTOT")[1]	,PesqPict("CNE","CNE_VLTOT")	,STR0034	,STR0034	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLTOT")[2]  	} ) // 'Vl.Total'
	aAdd( aWF4,{'WF4_PERC'	,'N',TAMSX3("CNE_PERC")[1]	,PesqPict("CNE","CNE_PERC")		,STR0047	,STR0047	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLTOT")[2]  	} ) // '% Rateio'
	aAdd( aWF4,{'WF4_VLCALC'	,'N',TAMSX3("CNE_VLTOT")[1]	,PesqPict("CNE","CNE_VLTOT")	,STR0048	,STR0048	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLTOT")[2]  	} ) // 'Vl.Rateado'
	aAdd( aWF4,{'WF4_MULTA'	,'N',TAMSX3("CNE_MULTA")[1]	,PesqPict("CNE","CNE_MULTA")	,STR0035	,STR0035  	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_MULTA")[2]  	} ) // 'Multa'
	aAdd( aWF4,{'WF4_BONIFI'	,'N',TAMSX3("CNE_BONIF")[1]	,PesqPict("CNE","CNE_BONIF")	,STR0036	,STR0036	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_BONIF")[2]  	} ) // 'Bonificação'
	aAdd( aWF4,{'WF4_DESCON'	,'N',TAMSX3("CNE_VLDESC")[1],PesqPict("CNE","CNE_VLDESC")	,STR0037	,STR0037	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNE_VLDESC")[2] 	} ) // 'Desconto'
	aAdd( aWF4,{'WF4_CC'		,'C',nTamCC					,'@!'								,STR0038	,STR0038	,{}	,NIL ,NIL ,NIL ,NIL, 0							} ) // 'C. Custo'
	aAdd( aWF4,{'WF4_CCONT'	,'C',nTamCCont				,'@!'								,STR0039	,STR0039	,{}	,NIL ,NIL ,NIL ,NIL, 0							} )	 // 'C.Contabil'
	aAdd( aWF4,{'WF4_IC'		,'C',nTamIC					,'@!'								,STR0040	,STR0040	,{}	,NIL ,NIL ,NIL ,NIL, 0  							} )	 // 'It.Contab.'
	aAdd( aWF4,{'WF4_CV'		,'C',nTamCV					,'@!'								,STR0041	,STR0041	,{}	,NIL ,NIL ,NIL ,NIL, 0							} )	 // 'C. Valor'
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
If ExistBlock("WFC121MODEL")
	aModelFlg := ExecBlock("WFC121MODEL",.F.,.F.,{"MODEL_ADD",{},"WF1"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF1,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF1,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC121MODEL",.F.,.F.,{"MODEL_ADD",{},"WF2"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF2,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF2,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC121MODEL",.F.,.F.,{"MODEL_ADD",{},"WF3"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF3,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF3,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC121MODEL",.F.,.F.,{"MODEL_ADD",{},"WF4"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF4,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF4,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC121MODEL",.F.,.F.,{"MODEL_ADD",{},"WF5"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF5,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF5,aModelFlg[nX])
		EndIf
	Next nX
EndIf

WF121Model(aSCR,"STRUSCR_",oStruSCR)
WF121Model(aWF1,"STRU1_",oStru1)
WF121Model(aWF2,"STRU2_",oStru2)
WF121Model(aWF3,"STRU3_",oStru3)
WF121Model(aWF4,"STRU4_",oStru4)
WF121Model(aWF5,"STRU5_",oStru5)

//-- Construção do modelo
oModel := MPFormModel():New('WFCNTA121', /*bPreValidacao*/, {|oModel,oModelCT|CNFlgVldSt(oModel,oModelCT)}/*bPosValidacao*/, {|oModel|A121LibDoc(oModel)}, /*bCancel*/ )

//-- Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'SCRMASTER', /*cOwner*/ , oStruSCR)
oModel:AddFields( 'WF1MASTER', 'SCRMASTER', oStru1, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF121LWF(oModel,"WF1")} )
oModel:AddFields( 'WF2DETAIL', 'WF1MASTER', oStru2, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF121LWF(oModel,"WF2")} )
oModel:AddGrid(   'WF3DETAIL', 'WF2DETAIL', oStru3, /*bLinePre*/ 		, /*bLinePost */		, /*bPre*/	, /* bLinePost */ ,{|oModel|WF121LWF(oModel,"WF3")} )
oModel:AddGrid(   'WF4DETAIL', 'WF3DETAIL', oStru4, /*bLinePre*/ 		, /*bLinePost */		, /*bPre*/	, /* bLinePost */ ,{|oModel|WF121LWF(oModel,"WF4")} )
oModel:AddGrid(   'WF5DETAIL', 'WF2DETAIL', oStru5, /*bLinePre*/ 		, /*bLinePost */		, /*bPre*/	, /* bLinePost */ ,{|oModel|WF121LWF(oModel,"WF5")} )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( STR0051 )//'Workflow da Medição'
//oModel:SetDescription( 'Workflow da Medição' )//'Workflow da Medição'

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0042 ) // 'Alçada'
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0043 ) // 'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0044 ) // 'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0045 ) // 'Planilhas'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0046 ) // 'Itens'
oModel:GetModel( 'WF5DETAIL' ):SetDescription( STR0050 ) // 'Histórico de Aprovações'

oModel:GetModel( 'WF1MASTER' ):SetOnlyQuery(.T.)
oModel:GetModel( 'WF2DETAIL' ):SetOnlyQuery(.T.)
oModel:GetModel( 'WF3DETAIL' ):SetOnlyQuery(.T.)
oModel:GetModel( 'WF4DETAIL' ):SetOnlyQuery(.T.)
oModel:GetModel( 'WF5DETAIL' ):SetOnlyQuery(.T.)

oModel:GetModel("WF2DETAIL"):SetOptional(.T.)
oModel:GetModel("WF3DETAIL"):SetOptional(.T.)
oModel:GetModel("WF4DETAIL"):SetOptional(.T.)
oModel:GetModel("WF5DETAIL"):SetOptional(.T.)

oModel:GetModel("WF3DETAIL"):SetNoDeleteLine(.T.)
oModel:GetModel("WF4DETAIL"):SetNoDeleteLine(.T.)
oModel:GetModel("WF5DETAIL"):SetNoDeleteLine(.T.)

oModel:SetPKIndexOrder(2)
oModel:SetPrimaryKey( {'CR_TIPO','CR_NUM','CR_USER'} )

//-- Realiza carga dos campos do mecanismo de atribuição
oModel:SetActivate( { |oModel| Wf121MecAt( oModel ) } )

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} WF121Model
Função para adicionar dinamicamente os campos na estrutura

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Function WF121Model(aCampos,cStru,oStru)
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

@author augustos.raphael

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

WF121View(aSCR,'SCR_',oStruSCR)
WF121View(aWF1,'WF1_',oStru1)
WF121View(aWF2,'WF2_',oStru2)
WF121View(aWF3,'WF3_',oStru3)
WF121View(aWF4,'WF4_',oStru4)
WF121View(aWF5,'WF5_',oStru5)

// Monta o modelo da interface do formulario
oView := FWFormView():New()

oView:SetModel(oModel)

oView:AddField('VIEW_SCR', oStruSCR,'SCRMASTER')
oView:AddField('VIEW_WF1', oStru1	,'WF1MASTER')
oView:AddField('VIEW_WF2', oStru2	,'WF2DETAIL')
oView:AddGrid( 'VIEW_WF3', oStru3	,'WF3DETAIL')
oView:AddGrid( 'VIEW_WF4', oStru4	,'WF4DETAIL')
oView:AddGrid( 'VIEW_WF5', oStru5	,'WF5DETAIL')

oView:CreateHorizontalBox( 'SCR' ,1  )
oView:CreateHorizontalBox( 'WF1' ,19 )
oView:CreateHorizontalBox( 'WF2' ,20 )
oView:CreateHorizontalBox( 'WF3' ,20 )
oView:CreateHorizontalBox( 'WF4' ,20 )
oView:CreateHorizontalBox( 'WF5' ,20 )

oView:SetOwnerView('VIEW_SCR','SCR' )
oView:SetOwnerView('VIEW_WF1','WF1' )
oView:SetOwnerView('VIEW_WF2','WF2' )
oView:SetOwnerView('VIEW_WF3','WF3' )
oView:SetOwnerView('VIEW_WF4','WF4' )
oView:SetOwnerView('VIEW_WF5','WF5' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0042  ) // 'Alçada'
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0043  ) // 'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0044  ) // 'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0045  ) // 'Planilhas'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0046  ) // 'Itens'
oModel:GetModel( 'WF5DETAIL' ):SetDescription( STR0050  ) // 'Histórico de Aprovações'

oView:EnableTitleView('VIEW_WF1' , STR0043 ) // 'Decisão'
oView:EnableTitleView('VIEW_WF2' , STR0044 ) // 'Informações do Documento'
oView:EnableTitleView('VIEW_WF3' , STR0045 ) // 'Planilhas'
oView:EnableTitleView('VIEW_WF4' , STR0046 ) // 'Itens'
oView:EnableTitleView('VIEW_WF5' , STR0050 ) // 'Histórico de Aprovações'

aWF1 := {}
aWF2 := {}
aWF3 := {}
aWF4 := {}
aWF5 := {}

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} WF121View
Função para adicionar dinamicamente os campos na view

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Function WF121View(aCampos,cStru,oStru)
Local nCampo 		:= 0
Local cCampo 		:= ''
Local lAltCampo 	:= .T.
Local aModelFlg	:= {}

If ExistBlock("WFC121MODEL")
	aModelFlg := ExecBlock("WFC121MODEL",.F.,.F.,{"VIEW_HIDE",{},LEFT(cStru,3)})
EndIf

For nCampo := 1 To Len(aCampos)
	lAltCampo := Iif(aCampos[nCampo,1] $ 'WF1_PAREC|WF1_SITUAC',.T.,.F.)
	cOrdem := StrZero(nCampo,2)

	If !aScan(aModelFlg,aCampos[nCampo][01])
		//-- Adiciona campos header do filtro de busca de fornecedor
		oStru:AddField(aCampos[nCampo][01]	,;	// [01]  C   Nome do Campo
					cOrdem						,;	// [02]  C   Ordem
					aCampos[nCampo][05] 		,;	// [03]  C   Titulo do campo
					aCampos[nCampo][06] 		,;	// [04]  C   Descricao do campo
					{}							,;	// [05]  A   Array com Help
					aCampos[nCampo][02]		,;	// [06]  C   Tipo do campo
					aCampos[nCampo][04]		,;	// [07]  C   Picture
					NIL							,;	// [08]  B   Bloco de Picture Var
					aCampos[nCampo][08]		,;	// [09]  C   Consulta F3
					lAltCampo					,;	// [10]  L   Indica se o campo é alteravel
					NIL							,;	// [11]  C   Pasta do campo
					NIL							,;	// [12]  C   Agrupamento do campo
					aCampos[nCampo][07]		,;	// [13]  A   Lista de valores permitido do campo (Combo)
					2							,;	// [14]  N   Tamanho maximo da maior opção do combo
					NIL							,;	// [15]  C   Inicializador de Browse
					.F.							,;	// [16]  L   Indica se o campo é virtual
					NIL							,;	// [17]  C   Picture Variavel
					.F.							)	// [18]  L   Indica pulo de linha após o campo
	EndIf
Next nCampo

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} WF121LWF(oModel,cLoad)
Função que retorna a carga de dados do cabeçalho da aprovação

@author Israel.Escorizza
@since 25/05/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF121LWF(oModel,cLoad)
Local aReturn := {}

DO 	CASE
	CASE cLoad == "WF1"
		aReturn := WF121LWF1(oModel)
	CASE cLoad == "WF2"
		aReturn := WF121LWF2(oModel)
	CASE cLoad == "WF3"
		aReturn := WF121LWF3(oModel)
	CASE cLoad == "WF4"
		aReturn := WF121LWF4(oModel)
	CASE cLoad == "WF5"
		aReturn := WF121LWF5(oModel)
ENDCASE

If ExistBlock("WFC121MODEL")
	aReturn := ExecBlock("WFC121MODEL",.F.,.F.,{"LOAD",aReturn,cLoad})
EndIf

Return aReturn

//-------------------------------------------------------------------
/*/{Protheus.doc} WF121LWF1
Função que retorna a carga de dados do cabeçalho da aprovação da
Solicitação de Compras

@author Augustos.Raphael
@since 30/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF121LWF1(oModel)
Local aLoad	:= {}
Local aAux		:= {}

aAdd(aAux, ""  ) //'WF1_PAREC'	,'M' , 10 , '@!'
aLoad := {aAux,0}

Return aLoad

//-------------------------------------------------------------------
/*/{Protheus.doc} WF121LWF2
Função que retorna a carga de dados do corpo da aprovação da
Solicitação de Compras

@author Augustos.Raphael
@since 30/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF121LWF2(oModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cFilName	:= ""
Local cDescObj	:= ""

// Posiciona a medicao atraves da alçada
CND->(DbSetOrder(4))
CND->(DbSeek(  xFilial("CND") + Padr(SCR->CR_NUM,TamSX3("CND_NUMMED")[1]) ))

// Posiciona o Contrato para carregar o Objeto do mesmo
DbSelectArea("CN9")
CN9->(DbSetOrder(1))
CN9->(DbSeek(xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA))

cFilName	:= CND->CND_FILIAL+Iif(FWModeAccess("CND")=="C",""," - "+FWFilialName(,CND->CND_FILIAL))

cDescObj := MSMM( CN9->CN9_CODOBJ )
cDescObj := Iif(Valtype(cDescObj)<>'C',"",cDescObj)

aAdd(aAux,	cFilName			)							//'WF2_FILIAL'	,'C'	,20		,'@!'
aAdd(aAux,	CND->CND_NUMMED 	)							//'WF2_DOC'		,'C'	,10		,'@!'
aAdd(aAux,	CND->CND_CONTRA 	)							//'WF2_CONT'		,'C'	,10		,'@!'
aAdd(aAux,	CND->CND_VLPREV 	)							//'WF2_TOTPRE'	,'N'	,12 	,''
aAdd(aAux,	CND->CND_VLTOT  	)							//'WF2_TOTMED'	,'N'	,12 	,''
aAdd(aAux,	oModel:GetModel():GetValue('SCRMASTER','CR_TOTAL'))	//'WF2_TOTAPR'	,'N'	,12		,''
aAdd(aAux,	CND->CND_OBS		)							//'WF2_OBS'		,'M'	,254	,''
aAdd(aAux,	cDescObj			)  							//'WF2_OBJ'		,'M'	,254	,''

aLoad := {aAux,0}

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF121LWF3(oCXNModel)
Carrega os itens da solicitação de compras para aprovação
@author Augustos.Raphael
@since 01/10/2015
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF121LWF3(oCXNModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cCampos		:= ""
Local cSql			:= ""
Local cCliFor		:= ""
Local cCliForL	:= ""
Local cDCliFor	:= ""
Local cAliasTemp	:= GetNextAlias()
Local nAdtPlan	:= 0
Local nTamMed		:= TamSX3("CXN_NUMMED")[1]
Local nTamPlan	:= TamSX3("CXN_NUMPLA")[1]
Local nTamRev		:= TamSX3("CXN_REVISA")[1]

If Alltrim(SCR->CR_TIPO) == 'MD' // Aprovação Principal

	BeginSQL Alias cAliasTemp
	SELECT CXN.CXN_CONTRA CXN_CONTRA,
		CXN.CXN_REVISA CXN_REVISA,
		CXN.CXN_NUMPLA CXN_NUMPLA,
		CXN.CXN_VLMULT CXN_VLMULT,
		CXN.CXN_VLBONI CXN_VLBONI,
		CXN.CXN_VLDESC CXN_VLDESC,
		CXN.CXN_VLLIQD CXN_VLLIQD, // Realizado
	   	CXN.CXN_VLTOT  CXN_VLTOT,  // Total Medicao
	   	CXN.R_E_C_N_O_ RECNO,
	   	CND.CND_VLTOT  CND_VLTOT,
	   	CND.CND_TOTADT CND_TOTADT,
	   	CND.CND_COMPET CND_COMPET
	FROM %Table:CXN% CXN
	JOIN %Table:CND% CND ON
		CND.%NotDel% AND
		CND.CND_FILIAL = CXN.CXN_FILIAL AND
		CND.CND_CONTRA = CXN.CXN_CONTRA AND
		CND.CND_REVISA = CXN.CXN_REVISA AND
		CND.CND_NUMMED = CXN.CXN_NUMMED
	WHERE CXN.%NotDel% AND
	   	CXN.CXN_FILIAL = %xFilial:CXN% AND
	   	CXN.CXN_NUMMED = %Exp:SUBSTR(SCR->CR_NUM,1,nTamMed)% AND
	   	CXN.CXN_CHECK  = %Exp:'T'%
	ORDER BY CXN.CXN_CONTRA,
		CXN.CXN_REVISA,
		CXN.CXN_NUMPLA
	EndSQL

Else // Aprovação por Item da Entidade Contábil (IM)

	BeginSQL Alias cAliasTemp
	SELECT CXN.CXN_CONTRA CXN_CONTRA,
		CXN.CXN_REVISA CXN_REVISA,
		CXN.CXN_NUMPLA CXN_NUMPLA,
		CXN.CXN_VLMULT CXN_VLMULT,
		CXN.CXN_VLBONI CXN_VLBONI,
		CXN.CXN_VLDESC CXN_VLDESC,
		CXN.CXN_VLLIQD CXN_VLLIQD, 	// Realizado
	   	CXN.CXN_VLTOT  CXN_VLTOT,	// Total Medicao
	   	CXN.R_E_C_N_O_ RECNO,
	   	CND.CND_VLTOT CND_VLTOT,
	   	CND.CND_TOTADT CND_TOTADT,
	   	CND.CND_COMPET CND_COMPET
	FROM %Table:CXN% CXN
	JOIN %Table:CND% CND ON
		CND.%NotDel% AND
		CND.CND_FILIAL = CXN.CXN_FILIAL AND
		CND.CND_CONTRA = CXN.CXN_CONTRA AND
		CND.CND_REVISA = CXN.CXN_REVISA AND
		CND.CND_NUMMED = CXN.CXN_NUMMED
	WHERE CXN.%NotDel% AND
	   	CXN.CXN_FILIAL = %xFilial:CXN% AND
	   	CXN.CXN_NUMMED = %Exp:SUBSTR(SCR->CR_NUM,1,nTamMed)% AND
		CXN.CXN_NUMPLA = %Exp:SUBSTR(SCR->CR_NUM,nTamMed+1,nTamPlan)% AND
		CXN.CXN_CHECK  = %Exp:'T'%
	ORDER BY CXN.CXN_CONTRA,
		CXN.CXN_REVISA,
		CXN.CXN_NUMPLA
	EndSQL

Endif

DbSelectArea("CNA")
CNA->(DbSetOrder(1))

While (cAliasTemp)->(!Eof())

	CNA->(DbSeek( xFilial("CNA") + (cAliasTemp)->CXN_CONTRA + (cAliasTemp)->CXN_REVISA + (cAliasTemp)->CXN_NUMPLA  ))
	If !Empty( AllTrim(CNA->CNA_FORNEC) ) //Fornecedor
		cCliFor	:= AllTrim(CNA->CNA_FORNEC)
		cCliForL	:= AllTrim(CNA->CNA_LJFORN)
		cDCliFor	:= POSICIONE("SA2",1,XFILIAL("SA2")+cCliFor+cCliForL,"A2_NOME")
	Else // Cliente
		cCliFor	:= AllTrim(CNA->CNA_CLIENT)
		cCliForL	:= Alltrim(CNA->CNA_LOJACL)
		cDCliFor	:= POSICIONE("SA1",1,XFILIAL("SA1")+cCliFor+ cCliForL,"A1_NOME")
	EndIf
	cCliFor := Rtrim(cCliFor) + " " + Rtrim(cCliForL) + " - " + Rtrim(cDCliFor)
	nAdtPlan	:= (cAliasTemp)->CXN_VLTOT/(cAliasTemp)->CND_VLTOT * (cAliasTemp)->CND_TOTADT

	AADD( aAux ,  (cAliasTemp)->CXN_NUMPLA	)  	//'WF3_NUM'		,'C',06,'@!'
	AADD( aAux ,  cCliFor					)  	//'WF3_FORCLI'	,'C',6 ,'@!'
	AADD( aAux ,  (cAliasTemp)->CND_COMPET	)  	//'WF3_TPCONT'	,'C',10,'@!'
	AADD( aAux ,  (cAliasTemp)->CXN_VLLIQD	)  	//'WF3_TOTREA'	,'N',15 ,''
	AADD( aAux ,  (cAliasTemp)->CXN_VLTOT	)  	//'WF3_TOTMED'	,'N',12 ,''
	AADD( aAux ,  (cAliasTemp)->CXN_VLMULT	)  	//'WF3_MULTA'		,'N',15 ,''
	AADD( aAux ,  (cAliasTemp)->CXN_VLBONI	)  	//'WF3_BONIFI'	,'N',15 ,''
	AADD( aAux ,  (cAliasTemp)->CXN_VLDESC	)  	//'WF3_DESCON'	,'N',15 ,''
	AADD( aAux ,  nAdtPlan					)	//'WF3_ADIANT'	,'N',15 ,''

	AADD(aLoad, {0,aAux})
	aAux	:= {}
	(cAliasTemp)->(DbSkip())

End

(cAliasTemp)->(dbClosearea())

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF121LWF4(oCNEModel)
Carga dos itens da medição

@author rafael.duram
@since 07/03/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF121LWF4(oCNEModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cAliasTemp	:= GetNextAlias()
Local cCliFor		:= ""
Local cDesTpPla	:= ""
Local cDCliFor	:= ""
Local cCliForL	:= ""
Local cCampos		:= ""
Local cSql			:= ""
Local nTamMed		:= TamSX3("CND_NUMMED")[1]
Local nTamPla		:= TamSX3("CXN_NUMPLA")[1]
Local cNumMed		:= Substr(SCR->CR_NUM,1,nTamMed)
Local cNumPla		:= SubStr(SCR->CR_NUM,nTamMed+1,nTamPla)
Local cDescProd	:= ""


If Alltrim(SCR->CR_TIPO) == 'MD' // Aprovação Principal

	BeginSQL Alias cAliasTemp

	SELECT CNE.CNE_NUMERO CNE_NUMERO,
		CNE.CNE_PRODUT CNE_PRODUT,
	    CNE.CNE_QUANT CNE_QUANT,
	    CNE.CNE_VLUNIT CNE_VLUNIT,
	    CNE.CNE_VLTOT CNE_VLTOT,
	    0 CNZ_PERC,
	    0 CNE_VLCALC,
	    CNE.CNE_MULTA CNE_MULTA,
	    CNE.CNE_BONIF CNE_BONIF,
	    CNE.CNE_VLDESC CNE_VLDESC,
	    CNE.CNE_CC CNE_CC,
	    CNE.CNE_CONTA CNE_CONTA,
	    CNE.CNE_ITEMCT CNE_ITEMCT,
	    CNE.CNE_CLVL CNE_CLVL,
	   	CNE.R_E_C_N_O_ RECNO
	FROM %Table:CNE% CNE
	WHERE CNE.%NotDel% AND
	   	CNE.CNE_FILIAL = %xFilial:CNE% AND
	   	CNE.CNE_NUMMED = %Exp:cNumMed%
	ORDER BY CNE.CNE_NUMERO
	EndSQL

Else // Aprovação por Item da Entidade Contábil (IM)

	BeginSQL Alias cAliasTemp
	SELECT CNE.CNE_NUMERO 									CNE_NUMERO,
		CNE.CNE_PRODUT 										CNE_PRODUT,
	    CNE.CNE_QUANT  										CNE_QUANT,
	    CNE.CNE_VLUNIT 										CNE_VLUNIT,
	    CNE.CNE_VLTOT  										CNE_VLTOT,
	    CNZ.CNZ_PERC										CNZ_PERC,
	    CNE.CNE_VLTOT  * (ISNULL(CNZ.CNZ_PERC,100) / 100) 	CNE_VLCALC,
	    CNE.CNE_MULTA  * (ISNULL(CNZ.CNZ_PERC,100) / 100) 	CNE_MULTA,
	    CNE.CNE_BONIF  * (ISNULL(CNZ.CNZ_PERC,100) / 100) 	CNE_BONIF,
	    CNE.CNE_VLDESC * (ISNULL(CNZ.CNZ_PERC,100) / 100) 	CNE_VLDESC,
	    ISNULL(CNZ.CNZ_CC,CNE.CNE_CC) 						CNE_CC,
	    ISNULL(CNZ.CNZ_CONTA,CNE.CNE_CONTA) 				CNE_CONTA,
	    ISNULL(CNZ.CNZ_ITEMCT,CNE.CNE_ITEMCT) 				CNE_ITEMCT,
	    ISNULL(CNZ.CNZ_CLVL,CNE.CNE_CLVL) 					CNE_CLVL,
	    CNE.R_E_C_N_O_ RECNO
	FROM %Table:DBM% DBM
	JOIN %Table:CNE% CNE ON
	   	CNE.%NotDel% AND
	   	CNE.CNE_FILIAL = DBM.DBM_FILIAL AND
	   	CNE.CNE_NUMMED = %Exp:cNumMed% AND
	   	CNE.CNE_NUMERO = %EXP:cNumPla% AND
		CNE.CNE_ITEM   = DBM.DBM_ITEM
	LEFT JOIN %Table:CNZ% CNZ ON
	    CNZ.%NotDel% AND
	    CNZ.CNZ_FILIAL = %xFilial:CNE% AND
	    CNZ.CNZ_CONTRA = CNE.CNE_CONTRA AND
	    CNZ.CNZ_REVISA = CNE.CNE_REVISA AND
	    CNZ.CNZ_CODPLA = CNE.CNE_NUMERO AND
	    CNZ.CNZ_NUMMED = CNE.CNE_NUMMED AND
	    CNZ.CNZ_ITCONT = CNE.CNE_ITEM AND
	    CNZ.CNZ_ITEM   = DBM.DBM_ITEMRA
	WHERE DBM.%NotDel% AND
	    DBM.DBM_FILIAL = %xFilial:DBM% AND
	    DBM.DBM_TIPO   = %Exp:SCR->CR_TIPO% AND
	    DBM.DBM_NUM    = %Exp:SCR->CR_NUM% AND
	    DBM.DBM_GRUPO  = %Exp:SCR->CR_GRUPO% AND
	    DBM.DBM_ITGRP  = %Exp:SCR->CR_ITGRP% AND
	    DBM.DBM_USER   = %Exp:SCR->CR_USER% AND
	    DBM.DBM_USEROR = %Exp:SCR->CR_USERORI%
	ORDER BY CNE.CNE_NUMERO
	EndSQL

Endif

While (cAliasTemp)->(!Eof())

	cDescProd := Posicione("SB1",1,xFilial("SB1")+(cAliasTemp)->CNE_PRODUT,"B1_DESC")

	AADD(aAux, (cAliasTemp)->CNE_NUMERO )
	AADD(aAux, (cAliasTemp)->CNE_PRODUT )
	AADD(aAux, cDescProd					 )
	AADD(aAux, (cAliasTemp)->CNE_QUANT  )
	AADD(aAux, (cAliasTemp)->CNE_VLUNIT )
	AADD(aAux, (cAliasTemp)->CNE_VLTOT  )
	AADD(aAux, (cAliasTemp)->CNZ_PERC	 )
	AADD(aAux, (cAliasTemp)->CNE_VLCALC )
	AADD(aAux, (cAliasTemp)->CNE_MULTA  )
	AADD(aAux, (cAliasTemp)->CNE_BONIF  )
	AADD(aAux, (cAliasTemp)->CNE_VLDESC )
	AADD(aAux, (cAliasTemp)->CNE_CC     + Wf300Descr("CNB_CC"    ,(cAliasTemp)->CNE_CC)	 	)
	AADD(aAux, (cAliasTemp)->CNE_CONTA  + Wf300Descr("CNB_CONTA" ,(cAliasTemp)->CNE_CONTA) 	)
	AADD(aAux, (cAliasTemp)->CNE_ITEMCT + Wf300Descr("CNB_ITEMCT",(cAliasTemp)->CNE_ITEMCT)	)
	AADD(aAux, (cAliasTemp)->CNE_CLVL   + Wf300Descr("CNB_CLVL"  ,(cAliasTemp)->CNE_CLVL)	)

	AADD(aLoad, {(cAliasTemp)->RECNO,aClone(aAux)})
	(cAliasTemp)->(DbSkip())
	aAux := {}
End

(cAliasTemp)->(dbClosearea())

Return aLoad
//--------------------------------------------------------------------
/*/{Protheus.doc} WF121LWF5(oModel)
Carga da grid de aprovação

@author Israel Escorizza
@since 16/08/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF121LWF5(oModel)
Local aArea		:= GetArea()
Local aAreaSCR	:= SCR->(GetArea())
Local aSaveLines	:= FwSaveRows()
Local aLoad	:= {}
Local aAux		:= {}

Local cDoc 		:= Left(SCR->CR_NUM,TAMSX3('CND_NUMMED')[1])+'%'
Local cTmpAlias	:= GetNextAlias()

BeginSQL Alias cTmpAlias
	SELECT	SCR.CR_NUM		CR_NUM,
			SCR.CR_TIPO		CR_TIPO,
			SCR.CR_NIVEL	CR_NIVEL,
			SCR.CR_USER		CR_USER,
			SCR.CR_DATALIB	CR_DATALIB,
	   		SCR.CR_STATUS	CR_STATUS,
	   		SCR.CR_GRUPO	CR_GRUPO,
	   		SCR.R_E_C_N_O_

	FROM 	%Table:SCR% SCR

	WHERE	SCR.%NotDel% AND
			SCR.CR_FILIAL = 	%xFilial:SCR% AND
			SCR.CR_NUM 	LIKE 	%Exp:cDoc% 	AND
			SCR.CR_TIPO	IN		('MD','IM')
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
/*/{Protheus.doc} A121LibDoc
Função liberar documento
@author augustos.raphael
@since 04/04/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Function A121LibDoc(oModel)
Local cNum			:= oModel:GetValue('SCRMASTER','CR_NUM')
Local cUser		:= oModel:GetValue('SCRMASTER','CR_USER')
Local cTipo		:= oModel:GetValue('SCRMASTER','CR_TIPO')
Local cParecer	:= oModel:GetValue('WF1MASTER','WF1_PAREC')
Local cAprov		:= Iif(oModel:GetWKNextState()=='4','1','2')
Local cFluig		:= Alltrim(cValToChar(oModel:GetWKNumProces()))
Local lRet			:= .F.
Local oModelCT	:= Nil
Private Inclui 	:= .F. // Para carregar o modelo do contrato

lRet := MTFlgLbDoc(cNum,cUser,cAprov,cTipo,cFluig,cParecer,oModelCT)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WF121Descr
Função que retorna a descrição dos campos de conta contabil

@author Rafael Duram Santos
@since 13/01/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF121Descr(cCampo,cChave)
Local aArea	:= GetArea()
Local cDescr	:= ""

If !Empty(cChave)
	cDescr += " - "
	If cCampo == "CNZ_CC" //CTT
		DbSelectArea("CTT")
		CTT->(DbSetOrder(1))
		If CTT->(DbSeek(xFilial("CTT")+cChave)) //CTT_CUSTO
			cDescr += CTT->CTT_DESC01
		Endif
	Elseif cCampo == "CNZ_CONTA" //CT1
		DbSelectArea("CT1")
		CT1->(DbSetOrder(1))
		If CT1->(DbSeek(xFilial("CT1")+cChave)) //CT1_CONTA
			cDescr += CT1->CT1_DESC01
		Endif
	Elseif cCampo == "CNZ_ITEMCT" //CTD
		DbSelectArea("CTD")
		CTD->(DbSetOrder(1))
		If CTD->(DbSeek(xFilial("CTD")+cChave)) //CTD_ITEM
			cDescr += CTD->CTD_DESC01
		Endif
	Elseif cCampo == "CNZ_CLVL" //CTH
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
/*/{Protheus.doc} Wf121MecAt()
Realiza carga dos campos do mecanismo de atribuição
@author Rafael Duram
@since 07/03/2016
@version 1.0
@return .T.
/*/
//--------------------------------------------------------------------
Static Function Wf121MecAt(oModel)
Local oFieldSCR 	:= oModel:GetModel("SCRMASTER")
Local cUserSolic	:= MtUsrSolic(oFieldSCR:GetValue("CR_TIPO"),oFieldSCR:GetValue("CR_NUM"))
Local cAprov		:= A097UsuApr(oFieldSCR:GetValue("CR_APROV"))

oFieldSCR:LoadValue("CR_CODSOL"  , FWWFColleagueId(cUserSolic)  )
oFieldSCR:LoadValue("CR_CODAPR"  , FWWFColleagueId(cAprov)   	 )

Return