#include "WFCNTA300R.CH"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'GCTXDEF.CH'

Static aSCR 		:= {}
Static aWF1 		:= {}
Static aWF2 		:= {}
Static aWF3 		:= {}
Static aWF4 		:= {}
Static aWF5 		:= {}
Static aWF6		:= {}

Static aDif		:= {}
Static cRevAnt	:= ""
Static cRevAtu	:= ""
//------------------------------------------------------------------
/*/{Protheus.doc} WFCNTA300R()
Revisão do contrato
@author Augustos.raphael
@since 02/04/13
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
Function WFCNTA300R()
Local oBrowse := NIL

oBrowse := FWMBrowse():New()
oBrowse:setAlias("SCR")
oBrowse:SetDescription(STR0001) // "Revisão do contrato"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                //"Revisão do contrato"
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

ADD OPTION aRotina TITLE STR0002	ACTION 'VIEWDEF.WFCNTA300R' OPERATION 2 ACCESS 0 // 'Visualizar'
ADD OPTION aRotina TITLE STR0003	ACTION 'VIEWDEF.WFCNTA300R' OPERATION 3 ACCESS 0 // 'Incluir'
ADD OPTION aRotina TITLE STR0046	ACTION 'VIEWDEF.WFCNTA300R' OPERATION 4 ACCESS 0 // 'Alterar'
ADD OPTION aRotina TITLE STR0004	ACTION 'VIEWDEF.WFCNTA300R' OPERATION 5 ACCESS 0 // 'Excluir'

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados
@author augustos.raphael
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
Local oStru6 	:= FWFormModelStruct():New()

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
Local nTamGrApr	:= 0
Local nTamTpRev	:= 0
Local nTamInd		:= 0

oStru1:AddTable("   ",{" "}," ")
oStru2:AddTable("   ",{" "}," ")
oStru3:AddTable("   ",{" "}," ")
oStru4:AddTable("   ",{" "}," ")
oStru5:AddTable("   ",{" "}," ")
oStru6:AddTable("   ",{" "}," ")

//- Estrutura array de campos.
//  {cCampo, cTipo, nTam, cMasc, cDescri, cTitulo, aCombo, cConsulta, bWhen, bValid, bInit })

//-- Inclusão de campos com chave de usuarios FLUIG (aSCR)
If Empty(aSCR)
	aAdd( aSCR,{'CR_CODSOL'	,'C' , 50 , '@!'	,STR0005	,STR0005	,{}	  	, NIL, Nil, Nil, Nil, 0   } )//'Solicitante'
	aAdd( aSCR,{'CR_CODAPR'	,'C' , 50 , '@!'	,STR0006	,STR0006	,{}	  	, NIL, Nil, Nil, Nil, 0   } )//'Aprovador'
	aAdd( aSCR,{'CR_NUMDOCS'	,'M' , 254, '@!'	,STR0007	,STR0007	,{}	  	, NIL, Nil, Nil, Nil, 0   } )//'Documentos'
EndIf

//-- Inclusão de estrutura aWF1
If Empty(aWF1)
	aAdd( aWF1,{'WF1_PAREC'	,'M' , 50 , '@!'	,STR0008	,STR0008	,{}		, NIL, Nil, Nil, Nil, 0  } )//'Parecer'
EndIf

//-- Inclusão de estrutura aWF2
If Empty(aWF2)
	nTamFilial	:= TamSX3("CN9_FILCTR")[1]+43 // XX8_DESCRI + 3 (" - ")
	nTamGrApr	:= TamSX3("CN9_APROV")[1] +TamSX3("AL_DESC")[1]+3
	nTamTpRev	:= TamSX3("CN0_CODIGO")[1]+TamSX3("CN0_DESCRI")[1]+3
	nTamInd	:= TamSX3("CN6_CODIGO")[1]+TamSX3("CN6_DESCRI")[1]+3
	aAdd( aWF2,{'WF2_FILIAL'	,'C',nTamFilial				,'@!'							,STR0009	,STR0009 	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Filial'
	aAdd( aWF2,{'WF2_TIPREV'	,'C',nTamTpRev				,'@!'							,STR0048	,STR0048	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Tp.Revisão'
	aAdd( aWF2,{'WF2_DOC'	,'C',TamSX3("CR_NUM")[1]		,'@!'							,STR0010	,STR0010	,{}	,NIL ,NIL, NIL ,NIL, 0  		 					} )//'Documento'
	aAdd( aWF2,{'WF2_REV'	,'C',TamSX3("CN9_REVISA")[1],''								,STR0011	,STR0011	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Revisão'
	aAdd( aWF2,{'WF2_DTINI'	,'D',8 						,''								,STR0012	,STR0012	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Início da Vigência'
	aAdd( aWF2,{'WF2_DTFIM'	,'D',8 						,''								,STR0013	,STR0013	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Final da Vigência'
	aAdd( aWF2,{'WF2_MOEDA'	,'C',20						,''								,STR0014	,STR0014	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Moeda'
	aAdd( aWF2,{'WF2_VALOR'	,'N',TAMSX3("CN9_VLATU")[1]	,PesqPict("CN9","CN9_VLATU"),STR0015	,STR0015	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CN9_VLATU")[2]  	} )//'Valor do Contrato'
	aAdd( aWF2,{'WF2_TOTAPR'	,'N',TAMSX3("CR_TOTAL")[1]	,PesqPict("SCR","CR_TOTAL")	,STR0051	,STR0051	,{}	,NIL ,NIL ,NIL, NIL, TAMSX3("CR_TOTAL")[2]	}) // 'Valor Aprovação'
	aAdd( aWF2,{'WF2_INDICE'	,'C',nTamInd					,'@!'							,STR0016	,STR0016	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Índice'
	aAdd( aWF2,{'WF2_GRPAPR'	,'C',nTamGrApr				,'@!'							,STR0017	,STR0017	,{}	,NIL ,NIL, NIL ,NIL, 0  	 						} )//'Grupo de Aprovação'
	aAdd( aWF2,{'WF2_CODOBJ'	,'M',254						,'@!'							,STR0018	,STR0018 	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Objeto'
	aAdd( aWF2,{'WF2_CODCLA'	,'M',254						,'@!'							,STR0019	,STR0019	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Cláusulas'
	aAdd( aWF2,{'WF2_JUSTIF'	,'M',254						,'@!'							,STR0020	,STR0020 	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Justificativa'
	aAdd( aWF2,{'WF2_ALTERA'	,'M',254						,'@!'							,STR0047	,STR0047	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Alterações'
EndIf

//-- Inclusão de estrutura aWF3
If Empty(aWF3)
	nTamFor := TamSX3("CNA_FORNEC")[1]+TamSX3("CNA_LJFORN")[1]+TamSX3("A2_NOME")[1]+4
	nTamCli := TamSX3("CNA_CLIENT")[1]+TamSX3("CNA_LOJACL")[1]+TamSX3("A1_NOME")[1]+4
	nTamFor := Iif(nTamCli > nTamFor,nTamCli,nTamFor)
	aAdd( aWF3,{'WF3_NUM'	,'C',TAMSX3("CNA_NUMERO")[1],'@!'							,STR0021	,STR0021	,{}		,NIL ,NIL ,NIL ,NIL, 0   						} )//'Numero'
	aAdd( aWF3,{'WF3_FORCLI'	,'C',nTamFor					,'@!'							,STR0022	,STR0022	,{}		,NIL ,NIL ,NIL ,NIL, 0   						} )//'Fornecedor\Cliente'
	aAdd( aWF3,{'WF3_VLTOT'	,'N',TAMSX3("CNA_VLTOT")[1]	,PesqPict("CNA","CNA_VLTOT"),STR0023	,STR0023	,{}		,NIL ,NIL ,NIL ,NIL, TAMSX3("CNA_VLTOT")[2]  	} )//'Vl.Total'
	aAdd( aWF3,{'WF3_ALTERA'	,'M',254						,'@!'							,STR0024 	,STR0024 	,{}		,NIL ,NIL, NIL ,NIL, 0   						} )//'Alterações'
EndIf

//-- Inclusão de estrutura aWF4
If Empty(aWF4)
	nTamCC		:= TamSX3("CTT_CUSTO")[1]+TamSX3("CTT_DESC01")[1]+3
	nTamCCont	:= TamSX3("CT1_CONTA")[1]+TamSX3("CT1_DESC01")[1]+3
	nTamIC		:= TamSX3("CTD_ITEM")[1]+TamSX3("CTD_DESC01")[1]+3
	nTamCV		:= TamSX3("CTH_CLVL")[1]+TamSX3("CTH_DESC01")[1]+3
	nTamFor := TamSX3("CNA_FORNEC")[1]+TamSX3("CNA_LJFORN")[1]+TamSX3("A2_NOME")[1]+4
	nTamCli := TamSX3("CNA_CLIENT")[1]+TamSX3("CNA_LOJACL")[1]+TamSX3("A1_NOME")[1]+4
	nTamFor := Iif(nTamCli > nTamFor,nTamCli,nTamFor)

	aAdd( aWF4,{'WF4_NUM'	,'C',TAMSX3("CNB_NUMERO")[1],'@!'								,STR0025	,STR0025	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )	//'Planilha'
	aAdd( aWF4,{'WF4_FORCLI'	,'C',nTamFor					,'@!'								,STR0022	,STR0022	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )//'Fornecedor/Cliente'
	aAdd( aWF4,{'WF4_PRODUT'	,'C',TAMSX3("CNB_PRODUT")[1],'@!'								,STR0026	,STR0026	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )	//'Prod./Grupo'
	aAdd( aWF4,{'WF4_DESCRI'	,'C',TAMSX3("CNB_DESCRI")[1],'@!'								,STR0027	,STR0027	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )	//'Descricao'
	aAdd( aWF4,{'WF4_QUANT'	,'N',TAMSX3("CNB_QUANT")[1]	,PesqPict("CNB","CNB_QUANT")	,STR0028	,STR0028	,{}	,NIL ,NIL ,NIL ,NIL, TAMSX3("CNB_QUANT")[2] 	} )//'Quantidade'
	aAdd( aWF4,{'WF4_VLUNIT'	,'N',TAMSX3("CNB_VLUNIT")[1],PesqPict("CNB","CNB_VLUNIT")	,STR0029	,STR0029	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNB_VLUNIT")[2] 	} )//'Vl.Unit.'
	aAdd( aWF4,{'WF4_VLTOT'	,'N',TAMSX3("CNB_VLTOT")[1]	,PesqPict("CNB","CNB_VLTOT")	,STR0023	,STR0023	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CNB_VLTOT")[2]  	} )//'Vl.Total'
	aAdd( aWF4,{'WF4_CC'		,'C',nTamCC					,'@!'								,STR0030	,STR0030	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )	//'C. Custo'
	aAdd( aWF4,{'WF4_CCONT'	,'C',nTamCCont				,'@!'								,STR0031	,STR0031	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )	//'C.Contabil'
	aAdd( aWF4,{'WF4_IC'		,'C',nTamIC					,'@!'								,STR0032	,STR0032	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )//'It.Contab.'
	aAdd( aWF4,{'WF4_CV'		,'C',nTamCV					,'@!'								,STR0033	,STR0033	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )	//'C. Valor'
	aAdd( aWF4,{'WF4_ALTERA'	,'M',254						,'@!'								,STR0024 	,STR0024 	,{}	,NIL ,NIL, NIL ,NIL, 0   						} )//'Alterações'
EndIf

//-- Inclusão de estrutura aWF5
If Empty(aWF5)
	aAdd( aWF5,{'WF5_FORCLI'	,'C',TamSX3("CNC_CODIGO")[1]	,'@!'		,STR0034	,STR0034	,{}		,NIL ,{||.F.}	,NIL ,NIL, 0   } )	//'Cod. Forn.\Cliente'
	aAdd( aWF5,{'WF5_LOJA'	,'C',TamSX3("CNC_LOJA")[1]		,'@!'		,STR0035	,STR0035	,{}		,NIL ,{||.F.}	,NIL ,NIL, 0   } )	//'Loja Forn.\Cliente'
	aAdd( aWF5,{'WF5_NOME'	,'C',TamSX3("A2_NOME")[1]		,'@!'		,STR0022	,STR0022	,{}		,NIL ,{||.F.}	,NIL ,NIL, 0   } )	//'Fornecedor\Cliente'
	aAdd( aWF5,{'WF5_ALTERA'	,'M',254							,'@!'		,STR0024	,STR0024	,{}		,NIL ,{||.F.}	,NIL ,NIL, 0   } )	//'Alterações'
EndIf

//-- Inclusão de estrutura aWF5
If Empty(aWF6)
	aAdd( aWF6, {'WF6_GRUPO'		,TAMSX3('AL_DESC')[3]	,TAMSX3('AL_DESC')[1]	,PesqPict('SAL','AL_DESC')		,'Grupo',		'Grupo',		{},	NIL,NIL,NIL,NIL,0	})	//Grupo
	aAdd( aWF6, {'WF6_NIVEL'		,TAMSX3('CR_NIVEL')[3]	,TAMSX3('CR_NIVEL')[1]	,PesqPict('SCR','CR_NIVEL')		,'Nivel',		'Nivel',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF6, {'WF6_USER'		,'C'						,200						,'@!'								,'Aprovador',	'Aprovador',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF6, {'WF6_STATUS'	,'C'						,50							,'@!'								,'Situação',	'Situação',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF6, {'WF6_DATA'		,TAMSX3('CR_DATALIB')[3]	,TAMSX3('CR_DATALIB')[1]	,PesqPict('SCR','CR_DATALIB')	,'Data',		'Data',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF6, {'WF6_OBS'		,'M'						,254						,'@!'								,'Observações','Observações',{},	NIL,NIL,NIL,NIL,0	})	//Nivel
EndIf

//------------------------------------------------------------------------
// Construção das estruturas
//------------------------------------------------------------------------
//- P.E que permite alteração dos campos para customização
If ExistBlock("WFC300RMODEL")
	aModelFlg := ExecBlock("WFC300RMODEL",.F.,.F.,{"MODEL_ADD",{},"WF1"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF1,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF1,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300RMODEL",.F.,.F.,{"MODEL_ADD",{},"WF2"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF2,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF2,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300RMODEL",.F.,.F.,{"MODEL_ADD",{},"WF3"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF3,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF3,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300RMODEL",.F.,.F.,{"MODEL_ADD",{},"WF4"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF4,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF4,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300RMODEL",.F.,.F.,{"MODEL_ADD",{},"WF5"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF5,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF5,aModelFlg[nX])
		EndIf
	Next nX

	aModelFlg := ExecBlock("WFC300RMODEL",.F.,.F.,{"MODEL_ADD",{},"WF6"})
	For nX := 1 To Len(aModelFlg)
		If !aScan(aWF6,{|x| x[1]==aModelFlg[nX][1]})
			aAdd(aWF6,aModelFlg[nX])
		EndIf
	Next nX
EndIf

WF300RModel(aSCR,"STRUSCR_",oStruSCR)
WF300RModel(aWF1,"STRU1_",oStru1)
WF300RModel(aWF2,"STRU2_",oStru2)
WF300RModel(aWF3,"STRU3_",oStru3)
WF300RModel(aWF4,"STRU4_",oStru4)
WF300RModel(aWF5,"STRU5_",oStru5)
WF300RModel(aWF6,"STRU6_",oStru6)

//-- Construção do modelo
oModel := MPFormModel():New('WFCNTA300R', /*bPreValidacao*/, /*bPosValidacao*/, {|oModel| A300RLibDoc(oModel) }, /*bCancel*/ )

//-- Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'SCRMASTER', /*cOwner*/ , oStruSCR)
oModel:AddFields( 'WF1MASTER', 'SCRMASTER', oStru1, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF300RLWF(oModel,"WF1")} )
oModel:AddFields( 'WF2DETAIL', 'WF1MASTER', oStru2, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF300RLWF(oModel,"WF2")} )
oModel:AddGrid(   'WF3DETAIL', 'WF2DETAIL', oStru3, /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ , {|oModel|WF300RLWF(oModel,"WF3")} )
oModel:AddGrid(   'WF4DETAIL', 'WF3DETAIL', oStru4, /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ , {|oModel|WF300RLWF(oModel,"WF4")} )
oModel:AddGrid(   'WF5DETAIL', 'WF1MASTER', oStru5, /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ , {|oModel|WF300RLWF(oModel,"WF5")} )
oModel:AddGrid(   'WF6DETAIL', 'WF2DETAIL', oStru6, /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ , {|oModel|WF300RLWF(oModel,"WF6")} )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( STR0036 )//'Workflow da Revisão do Contrato'

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0037 )//'Alçada'
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0038 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0039 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0041 )//'Planilhas'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0042 )//'Itens'
oModel:GetModel( 'WF5DETAIL' ):SetDescription( STR0043 )//'Fornecedores/Clientes'
oModel:GetModel( 'WF6DETAIL' ):SetDescription( STR0050 )//'Histórico de Aprovações'

oModel:GetModel("WF1MASTER"):SetOnlyQuery(.T.)
oModel:GetModel("WF2DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF3DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF4DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF5DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF6DETAIL"):SetOnlyQuery(.T.)

oModel:GetModel("WF2DETAIL"):SetOptional(.T.)
oModel:GetModel("WF3DETAIL"):SetOptional(.T.)
oModel:GetModel("WF4DETAIL"):SetOptional(.T.)
oModel:GetModel("WF5DETAIL"):SetOptional(.T.)
oModel:GetModel("WF6DETAIL"):SetOptional(.T.)

oModel:SetPKIndexOrder(2)
oModel:SetPrimaryKey( {'CR_TIPO','CR_NUM','CR_USER'} )

//-- Realiza carga dos campos do mecanismo de atribuição
oModel:SetActivate( { |oModel| Wf300RMecAt( oModel ) } )

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} WF300RModel
Função para adicionar dinamicamente os campos na estrutura

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Function WF300RModel(aCampos,cStru,oStru)
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
Local oStru6	:= FWFormViewStruct():New()
Local oStruSCR:= FWFormStruct(2, 'SCR', {|cCampo| AllTrim(cCampo)  $ "CR_FILIAL|CR_NUM|CR_TIPO|CR_APROV|CR_USER|CR_USERORI|CR_GRUPO|CR_ITGRP|CR_OBS"},,,.T.)
Local nCampo  := 0

WFR300View(aSCR,'SCR_',oStruSCR)
WFR300View(aWF1,'WF1_',oStru1)
WFR300View(aWF2,'WF2_',oStru2)
WFR300View(aWF3,'WF3_',oStru3)
WFR300View(aWF4,'WF4_',oStru4)
WFR300View(aWF5,'WF5_',oStru5)
WFR300View(aWF6,'WF6_',oStru6)

// Monta o modelo da interface do formulario
oView := FWFormView():New()
oView:SetModel(oModel)

oView:AddField('VIEW_SCR', oStruSCR,'SCRMASTER')
oView:AddField('VIEW_WF1', oStru1	,'WF1MASTER')
oView:AddField('VIEW_WF2', oStru2	,'WF2DETAIL')
oView:AddGrid( 'VIEW_WF3', oStru3	,'WF3DETAIL')
oView:AddGrid( 'VIEW_WF4', oStru4	,'WF4DETAIL')
oView:AddGrid( 'VIEW_WF5', oStru5	,'WF5DETAIL')
oView:AddGrid( 'VIEW_WF6', oStru6	,'WF6DETAIL')

oView:CreateHorizontalBox( 'SCR' ,1 )
oView:CreateHorizontalBox( 'WF1' ,17 )
oView:CreateHorizontalBox( 'WF2' ,17 )
oView:CreateHorizontalBox( 'WF3' ,17 )
oView:CreateHorizontalBox( 'WF4' ,16 )
oView:CreateHorizontalBox( 'WF5' ,16 )
oView:CreateHorizontalBox( 'WF6' ,16 )

oView:SetOwnerView('VIEW_SCR','SCR')
oView:SetOwnerView('VIEW_WF1','WF1')
oView:SetOwnerView('VIEW_WF2','WF2')
oView:SetOwnerView('VIEW_WF3','WF3')
oView:SetOwnerView('VIEW_WF4','WF4')
oView:SetOwnerView('VIEW_WF5','WF5')
oView:SetOwnerView('VIEW_WF6','WF6')

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0037 )//'Alçada'
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0038 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0039 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0041 )//'Planilhas'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0042 )//'Itens'
oModel:GetModel( 'WF5DETAIL' ):SetDescription( STR0040 )//'Fornecedores/Clientes'
oModel:GetModel( 'WF6DETAIL' ):SetDescription( STR0050 )//'Histórico de Aprovações'

oView:EnableTitleView('VIEW_WF1' , STR0038 )//'Decisão'
oView:EnableTitleView('VIEW_WF2' , STR0039 )//'Informações do Documento'
oView:EnableTitleView('VIEW_WF3' , STR0041 )//'Planilhas'
oView:EnableTitleView('VIEW_WF4' , STR0042 )//'Itens'
oView:EnableTitleView('VIEW_WF5' , STR0040 )//'Fornecedores/Clientes'
oView:EnableTitleView('VIEW_WF6' , STR0050 )//'Histórico de Aprovações'

aSCR := {}
aWF1 := {}
aWF2 := {}
aWF3 := {}
aWF4 := {}
aWF5 := {}
aWF6 := {}

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} WFR300View
Função para adicionar dinamicamente os campos na view

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Function WFR300View(aCampos,cStru,oStru)
Local nCampo := 0
Local cCampo := ''
Local lAltCampo 	:= .T.
Local aModelFlg	:= {}

If ExistBlock("WFC300RMODEL")
	aModelFlg := ExecBlock("WFC300RMODEL",.F.,.F.,{"VIEW_HIDE",{},LEFT(cStru,3)})
EndIf

For nCampo := 1 To Len(aCampos)
	lAltCampo := Iif(aCampos[nCampo,1] $ 'WF1_PAREC|WF5_NOTA',.T.,.F.)
	cOrdem := StrZero(nCampo,2)

	If !aScan(aModelFlg,aCampos[nCampo][01])
		//-- Adiciona campos header do filtro de busca de fornecedor
		oStru:AddField(aCampos[nCampo][01]		,;	// [01]  C   Nome do Campo
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
					NIL							,;	// [15]  C   Inicializador de adminBrowse
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
Static function WF300RLWF(oModel,cLoad)
Local aReturn := {}

DO 	CASE
	CASE cLoad == "WF1"
		aReturn := WF300RLWF1(oModel)
	CASE cLoad == "WF2"
		aReturn := WF300RLWF2(oModel)
	CASE cLoad == "WF3"
		aReturn := WF300RLWF3(oModel)
	CASE cLoad == "WF4"
		aReturn := WF300RLWF4(oModel)
	CASE cLoad == "WF5"
		aReturn := WF300RLWF5(oModel)
	CASE cLoad == "WF6"
		aReturn := WF300RLWF6(oModel)
ENDCASE

If ExistBlock("WFC300RMODEL")
	aReturn := ExecBlock("WFC300RMODEL",.F.,.F.,{"LOAD",aReturn,cLoad})
EndIf

Return aReturn

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300LWF1(oModel)
@author rafael.duram
@since 16/02/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300RLWF1(oModel)
Local aLoad	:= {}
Local aAux	:= {}

CN9->(DbSetOrder(1))
CN9->(DbSeek( xFilial("CN9") + SCR->CR_NUM ))

AADD(aAux, "")

aLoad := {aAux, 0}

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300RLWF2(oModel)
Bloco de carga da revisão Anterior do Contrato (CN9)
@author rafael.duram
@since 16/02/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300RLWF2(oModel)
Local aLoad		:= {}
Local oModelOri
Local oModelAlt
Local aAreaCN9	:= {}
Local aAux			:= {}
Local cDescTpC 	:= ""
Local cDescInd 	:= ""
Local cDescObj 	:= ""
Local cDescCla 	:= ""
Local cDescJus 	:= ""
Local cDescMoeda	:= ""
Local cDescGrApr	:= ""
Local cDescTpR 	:= ""
Local cFilName	:= ""
Local nTamCt		:= TamSX3("CN9_NUMERO")[1]
Local nTamRev		:= TamSX3("CN9_REVISA")[1]
Local cDoc			:= Alltrim(SCR->CR_NUM)
Local cNumCt		:= Substr(cDoc,1,nTamCt)
Local cCampo		:= ""
Local cAltera		:= ""
Local cValor		:= ""
Local nPosContr	:= 0
Local nY			:= 0
Private Inclui := .F. // Para carregar o modelo do contrato

// Codigo da revisao Atual
cRevAtu		:= Substr(cDoc,nTamCt+1,nTamRev)

// Carrega a variavel aDif que contem a diferenca entre todos os modelos
DbSelectArea("CN9")
CN9->(DbSetOrder(1))
If CN9->(DbSeek( xFilial("CN9") + cNumCt + cRevAtu ) )
	aAreaCN9	:= CN9->(GetArea()) // Revisao Atual
	CN9->(DbSetOrder(8))
	If CN9->(DbSeek( xFilial("CN9") + CN9->( CN9_NUMERO + CN9_REVISA) ))
		cRevAnt	:= CN9->CN9_REVISA // Codigo da revisao anterior
	EndIf
EndIf

oModelOri := FWLoadModel(Iif(CN9->CN9_ESPCTR == "1",'CNTA300','CNTA301'))
oModelOri:setOperation(MODEL_OPERATION_VIEW)
oModelOri:Activate()

If Len(aAreaCN9) > 0
	RestArea(aAreaCN9)
EndIf

oModelAlt := FWLoadModel(Iif(CN9->CN9_ESPCTR == "1",'CNTA300','CNTA301'))
oModelAlt:setOperation(MODEL_OPERATION_VIEW)
oModelAlt:Activate()
dbSelectArea('SX3')
SX3->( dbSetOrder(2) )

aDif := oModelAlt:Compare(oModelOri,.T.)
AglCompare(aDif) // Aglutina linhas que forem do mesmo modelo de Grid

// Carrega Justificativa, Clausulas, Tipo de Revisão e Revisão Atual
cDescJus := MSMM( CN9->CN9_CODJUS )
cDescJus := Iif(Valtype(cDescJus)<>'C',"",cDescJus)
cDescCla := MSMM( CN9->CN9_CODCLA )
cDescCla := Iif(Valtype(cDescCla)<>'C',"",cDescCla)
cRevisa  := CN9->CN9_REVISA
cDescTpR := CN9->CN9_TIPREV + " - "  + Posicione( "CN0", 1, xFilial("CN0") + CN9->CN9_TIPREV , "CN0_DESCRI" )

// Posiciona o registro na revisão anterior
DbSelectArea("CN9")
CN9->(DbSetOrder(1))
CN9->(DbSeek( xFilial("CN9") + cNumCt + cRevAnt ))


cDescInd := CN9->CN9_INDICE + IIf(!Empty(CN9->CN9_INDICE)," - ","") + Posicione( "CN6", 1, xFilial("CN6") + CN9->CN9_INDICE , "CN6_DESCRI" )
cDescInd := Iif(Valtype(cDescInd)<>'C',"",cDescInd)
cFilName := CN9->CN9_FILCTR + " - " + FWFilialName(,CN9->CN9_FILCTR)

cDescObj := MSMM( CN9->CN9_CODOBJ )
cDescObj := Iif(Valtype(cDescObj)<>'C',"",cDescObj)

cDescMoeda := SuperGetMv("MV_MOEDA"+AllTrim(Str(CN9->CN9_MOEDA,2)))
cDescGrApr := CN9->CN9_APROV + IIf(!Empty(CN9->CN9_APROV)," - ","") + Posicione( "SAL", 1, xFilial("SAL") + CN9->CN9_APROV , "AL_DESC" )
cDescGrApr := Iif(Valtype(cDescGrApr)<>'C',"",cDescGrApr)

nPosContr := Ascan(aDif,{|x| x[1] == "CN9MASTER"})

// Campo memo com as alteracoes realizadas na tabela CN9
If nPosContr > 0
	For nY := 1 To Len(aDif[nPosContr][3])
		SX3->(DbGoTop())

		If Valtype(aDif[nPosContr][3][nY][1]) == "C" .AND. SX3->( dbSeek( aDif[nPosContr][3][nY][1] ) )
	 		If Alltrim(aDif[nPosContr][3][nY][1]) $ "CN9_APROV|CN9_DTINIC|CN9_DTFIM|CN9_MOEDA|CN9_VLATU|CN9_INDICE|CN9_DTFIMP|CN9_MOTPAR|CN9_DTREIN"
		 		cCampo := AllTrim(X3Descric())
		 		cValor := AllTochar(aDif[nPosContr][3][nY][2])
		 		If TamSX3(Alltrim(aDif[nPosContr][3][nY][1]))[3] == 'N'
		 			cValor := Transform(Val(cValor),PesqPict('CN9',Alltrim(aDif[nPosContr][3][nY][1])))
		 		Elseif Alltrim(aDif[nPosContr][3][nY][1]) == 'CN9_MOTPAR'
		 			cValor := Alltrim(aDif[nPosContr][3][nY][2]) + " - " + Posicione('CN2',1,xFilial('CN2')+Alltrim(aDif[nPosContr][3][nY][2]),"CN2_DESCRI")
		 		Elseif Alltrim(aDif[nPosContr][3][nY][1]) == 'CN9_INDICE'
		 			cValor := Alltrim(aDif[nPosContr][3][nY][2]) + " - " + Posicione('CN6',1,xFilial('CN6')+Alltrim(aDif[nPosContr][3][nY][2]),"CN6_DESCRI")
		 		Elseif Alltrim(aDif[nPosContr][3][nY][1]) == 'CN9_APROV'
		 			cValor := Alltrim(aDif[nPosContr][3][nY][2]) + " - " + Posicione('SAL',1,xFilial('SAL')+Alltrim(aDif[nPosContr][3][nY][2]),"AL_DESC")
		 		Endif
				cAltera	+= 	cCampo + " : [ " + Alltrim(cValor) + " ] " + CRLF
				//Exibe lista de aprovadores quando o grupo for alterado
				If Alltrim(aDif[nPosContr][3][nY][1]) == 'CN9_APROV' .And. !Empty(aDif[nPosContr][3][nY][2])
					cAltera	+= STR0049 + CRLF //"Nova lista de aprovadores:"
					SAL->(DbSetOrder(1))
					If SAL->(MsSeek(xFilial("SAL")+aDif[nPosContr][3][nY][2]))
						While SAL->(!Eof()) .And. SAL->AL_FILIAL+SAL->AL_COD == xFilial("SAL")+aDif[nPosContr][3][nY][2]
							cAltera	+= SAL->AL_APROV + " - " + Alltrim(Posicione("SAK",2,xFilial("SAK")+SAL->AL_USER,"AK_NOME")) + CRLF
							SAL->(DbSkip())
						EndDo
					Endif
				Endif
			Endif
		EndIf
	Next nY
Endif

AADD(aAux, cFilName )     							//'WF2_FILIAL'
aAdd(aAux, cDescTpR )               				//'WF2_TIPREV'	,'C',50 ,''
AADD(aAux, SCR->CR_NUM )                      	//'WF2_DOC'
AADD(aAux, cRevisa )			                  	//'WF2_REV'
AADD(aAux, CN9->CN9_DTINIC  )        				//'WF2_DTINI'		,'D',8  ,''
AADD(aAux, CN9->CN9_DTFIM   )        				//'WF2_DTFIM'		,'D',8  ,''
AADD(aAux, cDescMoeda )					          	//'WF2_MOEDA'		,'C',20 ,''
AADD(aAux, CN9->CN9_VLATU )          				//'WF2_VALOR'		,'N',12 ,''
aAdd(aAux,	oModel:GetModel():GetValue('SCRMASTER','CR_TOTAL'))		//'WF2_TOTAPR'	,'N',12,''
AADD(aAux, cDescInd )                				//'WF2_INDICE'	,'C',10 ,''
AADD(aAux, cDescGrApr )              				//'WF2_GRPAPR'	,'C',10 ,''
AADD(aAux, cDescObj	) 								//'WF2_CODOBJ'	,'M',254,'@!'
AADD(aAux, cDescCla ) 								//'WF2_CODCLA'	,'M',254,'@!'
AADD(aAux, cDescJus )			              	//'WF2_JUSTIF'	,'M',254,'@!'
AADD(aAux, cAltera )									//'WF2_ALTERA'	,'M',254,'@!'

aLoad := {aAux, 0}

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300RLWF3(oModel)
Carga das planilhas do contrato da revisão anterior (CNA)
@author rafael.duram
@since 18/02/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300RLWF3(oModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cAliasTemp	:= GetNextAlias()
Local cCliFor		:= ""
Local cDCliFor	:= ""
Local cCliForL	:= ""
Local cCampos		:= ""
Local cSql			:= ""
Local cNumContr	:= Padr(SCR->CR_NUM,TamSX3("CN9_NUMERO")[1])
Local cNumPlan	:= ""
Local nPosPlan	:= 0
Local nI			:= 0
Local cRegPlan	:= ""
Local cCampo		:= ""
Local cAltera		:= ""
Local cValor		:= ""
Local nY			:= 0
Local nPlan		:= 0
Local lPlan		:= .F.
Local lAglFlg		:= SuperGetMV("MV_CNAGFLG",.F.,.F.)	//- Aglutinação de aprovações no Fluig
Local cNumDocs	:= GetScrAglu()
Local nTamRev		:= TamSX3("CNA_REVISA")[1]
Local nPos			:= 0
Local cDoc			:= ""
Local cAux			:= cNumDocs

nPosPlan := Ascan(aDif,{|x| x[1] == "CNADETAIL"})

If nPosPlan > 0
	For nI:=1 To Len(aDif[nPosPlan,3])
		lPlan := .F.

		// Verifica se foram alterados campos alem do CNA_REVISA/CNA_DTFIM
		For nY:=1 To Len(aDif[nPosPlan,3,nI,3])
			If !aDif[nPosPlan,3,nI,3,nY,1] $ "CNA_REVISA|CNA_DTFIM|CNA_USERGA"
				lPlan := .T.
				Exit
			Endif
		Next nY

		If !lPlan
			Loop
		Endif

		If Len(cRegPlan) > 0
			cRegPlan += ','
		Endif
		If aDif[nPosPlan,3,nI,4,2] <> 0
			cRegPlan += cValToChar(aDif[nPosPlan,3,nI,4,2])
		Else // Registro novo
			cRegPlan += cValToChar(aDif[nPosPlan,3,nI,4,1])
		Endif

	Next nI
	If Empty (cRegPlan)
		cRegPlan += "0"
	Endif
Endif

//CNA
cCampos := "CNA.CNA_NUMERO, CNA.CNA_FORNEC, CNA.CNA_TIPPLA,CNA.CNA_REVISA,"
cCampos += "CNA.CNA_LJFORN, CNA.CNA_CLIENT, CNA.CNA_LOJACL,"
cCampos += "CNA.CNA_VLTOT, CNA.CNA_DTINI, CNA.CNA_DTFIM, CN9.CN9_TPCTO, CNA.R_E_C_N_O_"

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
cSql += " AND CN9.D_E_L_E_T_= ' ' "

If SCR->CR_TIPO == "IR"
	If lAglFlg .And. !Empty(cAux)
		While !Empty(cAux)
			If nPos > 0
				nPos := At(",",cAux)
				cDoc := Substr(cAux,1,nPos-1)
				cAux := Substr(cAux,nPos+2)
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+nTamRev+1,TamSX3("CNA_NUMERO")[1])+"'"
				If !Empty(cAux)
					cNumPlan += ","
				Endif
			Else
				cDoc := cAux
				cAux := ""
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+nTamRev+1,TamSX3("CNA_NUMERO")[1])+"'"
			Endif
		EndDo
	Else
		cNumPlan += "'"+Substr(SCR->CR_NUM,Len(cNumContr)+nTamRev+1,TamSX3("CNA_NUMERO")[1])+"'"
	Endif
	cSql += " AND CNA_NUMERO IN ("+cNumPlan+")"
Endif

//Registros das planilhas da revisão anterior alterados e registros novos
cSql += " AND CNA.R_E_C_N_O_ IN ("+cRegPlan+")"

cSql += " ORDER BY CNA.CNA_CONTRA, CNA.CNA_REVISA, CNA.CNA_NUMERO "

cSql := ChangeQuery(cSql)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasTemp,.F.,.T.)

TcSetField(cAliasTemp,"CNA_VLTOT"	,GetSx3Cache("CNA_VLTOT","X3_TIPO"),TamSx3("CNA_VLTOT")[1],TamSx3("CNA_VLTOT")[2])
TcSetField(cAliasTemp,"CNA_DTINI"	,GetSx3Cache("CNA_DTINI","X3_TIPO"),TamSx3("CNA_DTINI")[1],TamSx3("CNA_DTINI")[2])
TcSetField(cAliasTemp,"CNA_DTFIM"	,GetSx3Cache("CNA_DTFIM","X3_TIPO"),TamSx3("CNA_DTFIM")[1],TamSx3("CNA_DTFIM")[2])


While (cAliasTemp)->(!Eof())

	cAltera  := ""
	// Campo memo com as alteracoes realizadas na tabela CNA
	If nPosPlan > 0
		nPlan := Ascan(aDif[nPosPlan,3],{|x| x[4,2] == (cAliasTemp)->R_E_C_N_O_})
		If nPlan > 0
			For nY := 1 To Len(aDif[nPosPlan,3,nPlan,3])
				SX3->(DbGoTop())

				If Valtype(aDif[nPosPlan,3,nPlan,3,nY,1]) == "C" .AND. SX3->( dbSeek( aDif[nPosPlan,3,nPlan,3,nY,1] ) )
			 		If Alltrim(aDif[nPosPlan][3][nPlan][3][nY][1]) $ "CNA_FORNEC|CNA_LJFORN|CNA_CLIENT|CNA_LOJACL|CNA_VLTOT"
				 		cCampo := AllTrim(X3Descric())
				 		cValor := AllTochar(aDif[nPosPlan][3][nPlan][3][nY][2])
		 				If TamSX3(Alltrim(aDif[nPosPlan][3][nPlan][3][nY][1]))[3] == 'N'
		 					cValor := Transform(Val(cValor),PesqPict('CNA',Alltrim(aDif[nPosPlan][3][nPlan][3][nY][1])))
		 				Endif
						cAltera	+= 	cCampo + " : [ " + cValor + " ] " + CRLF
					Endif
				EndIf
			Next nY
		Else
			nPlan := Ascan(aDif[nPosPlan,3],{|x| x[4,1] == (cAliasTemp)->R_E_C_N_O_})
			If nPlan > 0 // Registro novo
				cAltera := STR0043//"Inclusão de nova planilha."
			Endif
		Endif
	Endif

	If !Empty( AllTrim((cAliasTemp)->CNA_FORNEC) )
		cCliFor	:= (cAliasTemp)->CNA_FORNEC
		cCliForL	:= (cAliasTemp)->CNA_LJFORN
		cDCliFor	:= POSICIONE("SA2",1,XFILIAL("SA2")+cCliFor+cCliForL,"A2_NOME")
	Else
		cCliFor	:= (cAliasTemp)->CNA_CLIENT
		cCliForL	:= (cAliasTemp)->CNA_LOJACL
		cDCliFor	:= POSICIONE("SA1",1,XFILIAL("SA1")+cCliFor+cCliForL,"A1_NOME")
	EndIf

	AADD(aAux, (cAliasTemp)->CNA_NUMERO )      					//'WF3_NUM'	,'C',06 ,'@!'
	AADD(aAux, cCliFor + " " + cCliForL + " - " + cDCliFor ) 	//'WF3_FORCLI','C',45 ,'@!'
	AADD(aAux, (cAliasTemp)->CNA_VLTOT  )       					//'WF3_VLTOT'	,'N',16 ,'@!'
	AADD(aAux, cAltera  )					      					//'WF3_ALTERA','M',255,'@!'

	AADD(aLoad, {(cAliasTemp)->R_E_C_N_O_,aClone(aAux)})
	(cAliasTemp)->(DbSkip())
	aAux := {}
End

(cAliasTemp)->(dbClosearea())

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300RLWF4(oModel)
Carga dos itens do contrato da revisão anterior (CNB)
@author rafael.duram
@since 19/02/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300RLWF4(oModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cAliasTemp	:= GetNextAlias()
Local nTamContr	:= TamSX3("CNB_CONTRA")[1]
Local cNumContr	:= Padr(Substr(SCR->CR_NUM,1,nTamContr),nTamContr)
Local nPosIt		:= 0
Local nPosCXM		:= 0
Local nI			:= 0
Local cRegIt		:= ""
Local cRegCXM		:= ""
Local cAltera		:= ""
Local cCampo		:= ""
Local cValor		:= ""
Local nY			:= 0
Local nItem		:= 0
Local nCXM			:= 0
Local lRegNovo	:= .F.
Local lAglFlg		:= SuperGetMV("MV_CNAGFLG",.F.,.F.)	//- Aglutinação de aprovações no Fluig
Local nTamRev		:= TamSX3("CNA_REVISA")[1]
Local cNumPlan	:= ""
Local cNumDocs	:= GetScrAglu()
Local nPos			:= 0
Local cDoc			:= ""
Local cAux			:= cNumDocs
Local cQuery		:= ""
Local lItem		:= .F.
Local lCXM			:= .F.

nPosIt := Ascan(aDif,{|x| x[1] == "CNBDETAIL"})
nPosCXM:= Ascan(aDif,{|x| x[1] == "CXMDETAIL"})

cRegIt += "("
If nPosIt > 0
	For nI:=1 To Len(aDif[nPosIt,3])
		lItem := .F.

		// Verifica se foram alterados campos alem do CNB_REVISA/CNB_PRCORI/CNB_QTDORI/CNB_QTRDAC/CNB_QTRDRZ
		For nY:=1 To Len(aDif[nPosIt,3,nI,3])
			If !aDif[nPosIt,3,nI,3,nY,1] $ "CNB_REVISA|CNB_PRCORI|CNB_QTDORI|CNB_QTRDAC|CNB_QTRDRZ|CNB_USERGA"
				lItem := .T.
				Exit
			Endif
		Next nY

		If !lItem
			Loop
		Endif

		If Len(cRegIt) > 2
			cRegIt += ','
		Endif
		If aDif[nPosIt,3,nI,4,2] <> 0
			cRegIt += cValToChar(aDif[nPosIt,3,nI,4,2])
		Else // Registro novo
			cRegIt += cValToChar(aDif[nPosIt,3,nI,4,1])
		Endif

	Next nI
	If Empty (cRegIt)
		cRegIt += "0"
	Endif
Endif

If cRegIt == "("
	cRegIt += "0"
Endif
cRegIt += ")"

cRegCXM += "("
If nPosCXM > 0
	For nI:=1 To Len(aDif[nPosCXM,3])
		lCXM := .F.

		// Verifica se foram alterados campos alem do CXM_REVISA
		For nY:=1 To Len(aDif[nPosCXM,3,nI,3])
			If !aDif[nPosCXM,3,nI,3,nY,1] $ "CXM_REVISA"
				lCXM := .T.
				Exit
			Endif
		Next nY

		If !lCXM
			Loop
		Endif

		If Len(cRegCXM) > 2
			cRegCXM += ','
		Endif
		If aDif[nPosCXM,3,nI,4,2] <> 0
			cRegCXM += cValToChar(aDif[nPosCXM,3,nI,4,2])
		Else // Registro novo
			cRegCXM += cValToChar(aDif[nPosCXM,3,nI,4,1])
		Endif

	Next nI
	If Empty (cRegCXM)
		cRegCXM += "0"
	Endif
Endif

If cRegCXM == "("
	cRegCXM += "0"
Endif
cRegCXM += ")"

If Alltrim(SCR->CR_TIPO) == 'RV' // Aprovação Principal

	cQuery += " SELECT "
	cQuery += " CNB.CNB_NUMERO 	CNB_NUMERO, 	"
	cQuery += " CNB.CNB_PRODUT 	CNB_PRODUT,	"
	cQuery += " CNB.CNB_DESCRI 	CNB_DESCRI,	"
	cQuery += IIf(Cn300RetSt('VENDA')," SA1.A1_NOME	CNB_FORCLI, "," SA2.A2_NOME	CNB_FORCLI, ")
	cQuery += " '' 				CNB_AGRTIP,	"
	cQuery += " '' 				CNB_AGRGRP,	"
	cQuery += " '' 				CNB_AGRCAT,	"
	cQuery += " CNB.CNB_QUANT 	CNB_QUANT,		"
	cQuery += " CNB.CNB_VLUNIT 	CNB_VLUNIT,	"
	cQuery += " CNB.CNB_VLTOT 	CNB_VLTOT,		"
	cQuery += " CNB.CNB_CC 		CNB_CC,		"
	cQuery += " CNB.CNB_CONTA 	CNB_CONTA,		"
	cQuery += " CNB.CNB_ITEMCT 	CNB_ITEMCT,	"
	cQuery += " CNB.CNB_CLVL 	CNB_CLVL,		"
	cQuery += " CNB.R_E_C_N_O_ 	RECNO			"

	cQuery += " FROM 	"
	cQuery += RetSqlName("CNA")+" CNA,			"
	cQuery += RetSqlName("CNB")+" CNB,			"
	cQuery += IIf(Cn300RetSt('VENDA'),RetSqlName("SA1")+" SA1, ",RetSqlName("SA2")+" SA2 ")

	cQuery += " WHERE "
	cQuery += " CNB.D_E_L_E_T_= ' ' 						AND "
	cQuery += " CNB.CNB_FILIAL 	= 	'"+xFilial('CNB')+"'	AND "
	cQuery += " CNB.CNB_CONTRA 	= 	'"+cNumContr+"' 		AND "
	cQuery += " CNB.R_E_C_N_O_ 	IN 	"+cRegIt+" 			AND "

	cQuery += " CNA.D_E_L_E_T_= ' ' 						AND "
	cQuery += " CNA.CNA_CONTRA 	= 	CNB.CNB_CONTRA 		AND "
	cQuery += " CNA.CNA_REVISA 	= 	CNB.CNB_REVISA 		AND "
	cQuery += " CNA.CNA_NUMERO 	= 	CNB.CNB_NUMERO 		AND "

	If Cn300RetSt('VENDA')
		cQuery += " SA1.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA1.A1_COD 	= 	CNA.CNA_CLIENT 		AND "
		cQuery += " SA1.A1_LOJA 	= 	CNA.CNA_LOJACL 		    "
	Else
		cQuery += " SA2.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA2.A2_COD 	= 	CNA.CNA_FORNEC 		AND "
		cQuery += " SA2.A2_LOJA 	= 	CNA.CNA_LJFORN		    "
	EndIf

	cQuery += " UNION "
	cQuery += " SELECT "
	cQuery += " CXM.CXM_NUMERO 	CNB_NUMERO, 	"
	cQuery += " '' 				CNB_PRODUT, 	"
	cQuery += " '' 				CNB_DESCRI, 	"
	cQuery += IIf(Cn300RetSt('VENDA')," SA1.A1_NOME	CNB_FORCLI, "," SA2.A2_NOME	CNB_FORCLI, ")
	cQuery += " CXM.CXM_AGRTIP 	CNB_AGRTIP, 	"
	cQuery += " CXM.CXM_AGRGRP 	CNB_AGRGRP, 	"
	cQuery += " CXM.CXM_AGRCAT 	CNB_AGRCAT, 	"
	cQuery += " 0 				CNB_QUANT,  	"
	cQuery += " 0 				CNB_VLUNIT, 	"
	cQuery += " CXM.CXM_VLMAX 	CNB_VLTOT,  	"
	cQuery += " CXM.CXM_CC 		CNB_CC,		"
	cQuery += " '' 				CNB_CONTA,  	"
	cQuery += " '' 				CNB_ITEMCT, 	"
	cQuery += " '' 				CNB_CLVL, 		"
	cQuery += " CXM.R_E_C_N_O_ 	RECNO 			"

	cQuery += " FROM "
	cQuery += RetSqlName("CNA")+" CNA,	"
	cQuery += IIf(Cn300RetSt('VENDA'),RetSqlName("SA1")+" SA1, ",RetSqlName("SA2")+" SA2, ")
	cQuery += RetSqlName("CXM")+" CXM "

	cQuery += " WHERE "
	cQuery += " CXM.D_E_L_E_T_= ' ' 					 	AND "
	cQuery += " CXM.CXM_FILIAL = '"+xFilial('CXM')+"' 	AND "
	cQuery += " CXM.CXM_CONTRA = '"+cNumContr+"' 		 	AND "
	cQuery += " CXM.R_E_C_N_O_ IN "+cRegCXM+" 			AND "

	cQuery += " CNA.D_E_L_E_T_= ' ' 						AND "
	cQuery += " CNA.CNA_CONTRA 	= CXM.CXM_CONTRA 			AND "
	cQuery += " CNA.CNA_REVISA 	= CXM.CXM_REVISA 			AND "
	cQuery += " CNA.CNA_NUMERO 	= CXM.CXM_NUMERO 			AND "

	If Cn300RetSt('VENDA')
		cQuery += " SA1.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA1.A1_COD 	= 	CNA.CNA_CLIENT 		AND "
		cQuery += " SA1.A1_LOJA 	= 	CNA.CNA_LOJACL 		    "
	Else
		cQuery += " SA2.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA2.A2_COD 	= 	CNA.CNA_FORNEC 		AND "
		cQuery += " SA2.A2_LOJA 	= 	CNA.CNA_LJFORN		    "
	EndIf

	cQuery  := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAliasTemp,.T.,.T.)

Else // Aprovação por Item da Entidade Contábil (IR)

	// Filtra planilhas a serem selecionadas
	cNumPlan += "("
	If lAglFlg .And. !Empty(cAux)
		While !Empty(cAux)
			nPos := At(",",cAux)
			If nPos > 0
				cDoc := Substr(cAux,1,nPos-1)
				cAux := Substr(cAux,nPos+2)
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+nTamRev+1,TamSX3("CNA_NUMERO")[1])+"'"
				If !Empty(cAux)
					cNumPlan += ","
				Endif
			Else
				cDoc := cAux
				cAux := ""
				cNumPlan += "'"+Substr(cDoc,Len(cNumContr)+nTamRev+1,TamSX3("CNA_NUMERO")[1])+"'"
			Endif
		EndDo
	Else
		cNumPlan += "'"+Substr(SCR->CR_NUM,nTamContr+nTamRev+1,TamSX3("CNA_NUMERO")[1])+"'"
	Endif
	cNumPlan += ")"

	cQuery += " SELECT "
	cQuery += " CNB.CNB_NUMERO 	CNB_NUMERO,	"
	cQuery += " CNB.CNB_PRODUT 	CNB_PRODUT,	"
	cQuery += " CNB.CNB_DESCRI 	CNB_DESCRI,	"
	cQuery += IIf(Cn300RetSt('VENDA')," SA1.A1_NOME	CNB_FORCLI, "," SA2.A2_NOME	CNB_FORCLI, ")
	cQuery += " '' 				CNB_AGRTIP,	"
	cQuery += " '' 				CNB_AGRGRP,	"
	cQuery += " '' 				CNB_AGRCAT,	"
	cQuery += " CNB.CNB_QUANT * (ISNULL(CNZ.CNZ_PERC,100) / 100)	CNB_QUANT,		"
	cQuery += " CNB.CNB_VLUNIT  	CNB_VLUNIT,	"
	cQuery += " CNB.CNB_VLTOT * (ISNULL(CNZ.CNZ_PERC,100) / 100)	CNB_VLTOT,		"
	cQuery += " ISNULL(CNZ.CNZ_CC,CNB.CNB_CC) CNB_CC,	"
	cQuery += " ISNULL(CNZ.CNZ_CONTA,CNB.CNB_CONTA) CNB_CONTA,	"
	cQuery += " ISNULL(CNZ.CNZ_ITEMCT,CNB.CNB_ITEMCT) CNB_ITEMCT,	"
	cQuery += " ISNULL(CNZ.CNZ_CLVL,CNB.CNB_CLVL) CNB_CLVL,	"
	cQuery += " CNB.R_E_C_N_O_ RECNO	"
	cQuery += " FROM "
	cQuery += RetSqlName("CNA")+" CNA,	"
	cQuery += IIf(Cn300RetSt('VENDA'),RetSqlName("SA1")+" SA1, ",RetSqlName("SA2")+" SA2, ")
	cQuery += RetSqlName("DBM")+" DBM

	cQuery += " JOIN "
	cQuery += RetSqlName("CNB")+" CNB ON "
	cQuery += " CNB.D_E_L_E_T_	= ' '  					AND "
	cQuery += " CNB.CNB_FILIAL 	= '"+xFilial('CNB')+"' 	AND "
	cQuery += " CNB.CNB_CONTRA 	= '"+cNumContr+"'			AND "
	cQuery += " CNB.CNB_ITEM 	= DBM.DBM_ITEM "

	cQuery += " LEFT JOIN "
	cQuery += RetSqlName("CNZ")+" CNZ ON "
	cQuery += " CNZ.D_E_L_E_T_= ' '							AND "
	cQuery += " CNZ.CNZ_FILIAL 	= '"+xFilial('CNZ')+"'	AND "
	cQuery += " CNZ.CNZ_CONTRA 	= CNB.CNB_CONTRA 			AND "
	cQuery += " CNZ.CNZ_REVISA 	= CNB.CNB_REVISA 			AND "
	cQuery += " CNZ.CNZ_CODPLA 	= CNB.CNB_NUMERO 			AND "
	cQuery += " CNZ.CNZ_ITCONT 	= CNB.CNB_ITEM 			AND "
	cQuery += " CNZ.CNZ_ITEM 	= DBM.DBM_ITEMRA "

	cQuery += " WHERE "
	cQuery += " DBM.D_E_L_E_T_	= ' '  					AND "
	cQuery += " DBM.DBM_FILIAL 	= '"+xFilial('DBM')+"' 	AND "
	cQuery += " DBM.DBM_TIPO 	= '"+SCR->CR_TIPO+"'		AND "
	cQuery += " DBM.DBM_NUM 		= '"+SCR->CR_NUM+"' 		AND "
	cQuery += " DBM.DBM_GRUPO 	= '"+SCR->CR_GRUPO+"' 	AND "
	cQuery += " DBM.DBM_ITGRP 	= '"+SCR->CR_ITGRP+"' 	AND "
	cQuery += " DBM.DBM_USER 	= '"+SCR->CR_USER+"' 	AND "
	cQuery += " DBM.DBM_USEROR 	= '"+SCR->CR_USERORI+"'	AND "
	cQuery += " CNB.R_E_C_N_O_ 	IN "+cRegIt+" 			AND "
	cQuery += " CNB.CNB_NUMERO 	IN "+cNumPlan+"			AND "

	cQuery += " CNA.D_E_L_E_T_	= ' '  					AND "
	cQuery += " CNA.CNA_CONTRA 	= CNB.CNB_CONTRA 			AND "
	cQuery += " CNA.CNA_REVISA 	= CNB.CNB_REVISA 			AND "
	cQuery += " CNA.CNA_NUMERO 	= CNB.CNB_NUMERO 			AND "

	If Cn300RetSt('VENDA')
		cQuery += " SA1.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA1.A1_COD 	= 	CNA.CNA_CLIENT 		AND "
		cQuery += " SA1.A1_LOJA 	= 	CNA.CNA_LOJACL 		    "
	Else
		cQuery += " SA2.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA2.A2_COD 	= 	CNA.CNA_FORNEC 		AND "
		cQuery += " SA2.A2_LOJA 	= 	CNA.CNA_LJFORN		    "
	EndIf

	cQuery+= " UNION "

	cQuery += " SELECT "
	cQuery += " CXM.CXM_NUMERO 	CNB_NUMERO, 	"
	cQuery += " '' 				CNB_PRODUT, 	"
	cQuery += " '' 				CNB_DESCRI, 	"
	cQuery += IIf(Cn300RetSt('VENDA')," SA1.A1_NOME	CNB_FORCLI, "," SA2.A2_NOME	CNB_FORCLI, ")
	cQuery += " CXM.CXM_AGRTIP 	CNB_AGRTIP, 	"
	cQuery += " CXM.CXM_AGRGRP 	CNB_AGRGRP, 	"
	cQuery += " CXM.CXM_AGRCAT 	CNB_AGRCAT, 	"
	cQuery += " 0 					CNB_QUANT, 	"
	cQuery += " 0 					CNB_VLUNIT, 	"
	cQuery += " CXM.CXM_VLMAX 	CNB_VLTOT, 	"
	cQuery += " CXM.CXM_CC 		CNB_CC, 		"
	cQuery += " '' 				CNB_CONTA, 	"
	cQuery += " '' 				CNB_ITEMCT, 	"
	cQuery += " '' 				CNB_CLVL, 		"
	cQuery += " CXM.R_E_C_N_O_ 	RECNO 			"

	cQuery += " FROM "
	cQuery += RetSqlName("CNA")+" CNA,	"
	cQuery += IIf(Cn300RetSt('VENDA'),RetSqlName("SA1")+" SA1, ",RetSqlName("SA2")+" SA2, ")
	cQuery += RetSqlName("CXM")+" CXM "

	cQuery += " WHERE "
	cQuery += " CXM.D_E_L_E_T_	= 	' ' 					AND "
	cQuery += " CXM.CXM_FILIAL 	= 	'"+xFilial('CXM')+"' AND "
	cQuery += " CXM.CXM_CONTRA 	= 	'"+cNumContr+"' 		AND "
	cQuery += " CXM.R_E_C_N_O_ 	IN 	"+cRegCXM+" 			AND "
	cQuery += " CXM.CXM_NUMERO 	IN 	"+cNumPlan+" 			AND "

	cQuery += " CNA.D_E_L_E_T_	= ' '  					AND "
	cQuery += " CNA.CNA_CONTRA 	= CXM.CXM_CONTRA 			AND "
	cQuery += " CNA.CNA_REVISA 	= CXM.CXM_REVISA 			AND "
	cQuery += " CNA.CNA_NUMERO 	= CXM.CXM_NUMERO 			AND "

	If Cn300RetSt('VENDA')
		cQuery += " SA1.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA1.A1_COD 	= 	CNA.CNA_CLIENT 		AND "
		cQuery += " SA1.A1_LOJA 	= 	CNA.CNA_LOJACL 		    "
	Else
		cQuery += " SA2.D_E_L_E_T_= ' ' 					AND "
		cQuery += " SA2.A2_COD 	= 	CNA.CNA_FORNEC 		AND "
		cQuery += " SA2.A2_LOJA 	= 	CNA.CNA_LJFORN		    "
	EndIf

	cQuery  := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAliasTemp,.T.,.T.)
Endif

While (cAliasTemp)->(!Eof())

	cAltera  := ""
	// Campo memo com as alteracoes realizadas na tabela CNB
	If nPosIt > 0
		nItem := Ascan(aDif[nPosIt,3],{|x| x[4,2] == (cAliasTemp)->RECNO})
		If nItem > 0
			For nY := 1 To Len(aDif[nPosIt,3,nItem,3])
				SX3->(DbGoTop())

				If Valtype(aDif[nPosIt,3,nItem,3,nY,1]) == "C" .AND. SX3->( dbSeek( aDif[nPosIt,3,nItem,3,nY,1] ) )
			 		If Alltrim(aDif[nPosIt][3][nItem][3][nY][1]) $ "CNB_PRODUT|CNB_DESCRI|CNB_QUANT|CNB_VLUNIT|CNB_VLTOT|CNB_CC|CNB_CONTA|CNB_ITEMCT|CNB_CLVL"
				 		cCampo := AllTrim(X3Descric())
				 		cValor := AllTochar(aDif[nPosIt][3][nItem][3][nY][2])
		 				If TamSX3(Alltrim(aDif[nPosIt][3][nItem][3][nY][1]))[3] == 'N'
		 					cValor := Transform(Val(cValor),PesqPict('CNB',Alltrim(aDif[nPosIt][3][nItem][3][nY][1])))
		 				Endif
						cAltera	+= 	cCampo + " : [ " + cValor + " ] " + CRLF
					Endif
				EndIf
			Next nY
		Else // Registro novo
			nItem := Ascan(aDif[nPosIt,3],{|x| x[4,1] == (cAliasTemp)->RECNO})
			If nItem > 0
				cAltera  := STR0044//"Inclusão de novo produto."
			Endif
		Endif
	Endif

	// Campo memo com as alteracoes realizadas na tabela CXM
	If nPosCXM > 0
		nCXM := Ascan(aDif[nPosCXM,3],{|x| x[4,2] == (cAliasTemp)->RECNO})
		If nCXM > 0
			For nY := 1 To Len(aDif[nPosCXM,3,nCXM,3])
				SX3->(DbGoTop())

				If Valtype(aDif[nPosCXM,3,nCXM,3,nY,1]) == "C" .AND. SX3->( dbSeek( aDif[nPosCXM,3,nCXM,3,nY,1] ) )
			 		If Alltrim(aDif[nPosCXM][3][nCXM][3][nY][1]) $ "CXM_AGRTIP|CXM_AGRGRP|CXM_AGRCAT|CXM_VLMAX|CXM_CC"
				 		cCampo := AllTrim(X3Descric())
						cValor := AllTochar(aDif[nPosCXM][3][nCXM][3][nY][2])
		 				If TamSX3(Alltrim(aDif[nPosCXM][3][nCXM][3][nY][1]))[3] == 'N'
		 					cValor := Transform(Val(cValor),PesqPict('CXM',Alltrim(aDif[nPosCXM][3][nCXM][3][nY][1])))
		 				Endif
						cAltera	+= 	cCampo + " : [ " + cValor + " ] " + CRLF
					Endif
				EndIf
			Next nY
		Else // Registro novo
			nCXM := Ascan(aDif[nPosCXM,3],{|x| x[4,1] == (cAliasTemp)->RECNO})
			If nCXM > 0
				cAltera  := STR0044//"Inclusão de novo produto."
			Endif
		Endif
	Endif

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
	AADD(aAux, (cAliasTemp)->CNB_FORCLI )
	AADD(aAux,  cProdut					 )
	AADD(aAux,  cDescri 					 )
	AADD(aAux, (cAliasTemp)->CNB_QUANT  )
	AADD(aAux, (cAliasTemp)->CNB_VLUNIT )
	AADD(aAux, (cAliasTemp)->CNB_VLTOT  )
	AADD(aAux, (cAliasTemp)->CNB_CC     + Wf300Descr("CNB_CC"    ,(cAliasTemp)->CNB_CC)	 	)
	AADD(aAux, (cAliasTemp)->CNB_CONTA  + Wf300Descr("CNB_CONTA" ,(cAliasTemp)->CNB_CONTA) 	)
	AADD(aAux, (cAliasTemp)->CNB_ITEMCT + Wf300Descr("CNB_ITEMCT",(cAliasTemp)->CNB_ITEMCT)	)
	AADD(aAux, (cAliasTemp)->CNB_CLVL   + Wf300Descr("CNB_CLVL"  ,(cAliasTemp)->CNB_CLVL)	)
	AADD(aAux, cAltera  					 )					      	//'WF4_ALTERA','M',255,'@!'

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
/*/{Protheus.doc} WF300RLWF5(oModel)
@author rafael.duram
@since 13/01/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300RLWF5(oModel)
Local aLoad		:= {}
Local aAux			:= {}
Local cAliasTemp	:= GetNextAlias()
Local nTamContr	:= TamSX3("CNC_NUMERO")[1]
Local nTamRevisa	:= TamSX3("CNC_REVISA")[1]
Local cNumContr	:= Padr(Substr(SCR->CR_NUM,1,nTamContr),nTamContr)
Local cNumRevisa	:= Padr(Substr(SCR->CR_NUM,nTamContr+1,nTamRevisa),nTamRevisa)
Local cRegForn	:= ""
Local cAltera		:= 0
Local nPosForn	:= 0
Local nForn		:= 0
Local nI			:= 0
Local nY			:= 0
Local lForn		:= .F.


nPosForn := Ascan(aDif,{|x| x[1] == "CNCDETAIL"})

cRegForn += "%("
If nPosForn > 0
	For nI:=1 To Len(aDif[nPosForn,3])
		lForn := .F.

		// Verifica se foram alterados campos alem do CNC_REVISA
		For nY:=1 To Len(aDif[nPosForn,3,nI,3])
			If !aDif[nPosForn,3,nI,3,nY,1] $ "CNC_REVISA"
				lForn := .T.
				Exit
			Endif
		Next nY

		If !lForn
			Loop
		Endif

		If Len(cRegForn) > 2
			cRegForn += ','
		Endif
		If aDif[nPosForn,3,nI,4,2] <> 0
			cRegForn += cValToChar(aDif[nPosForn,3,nI,4,2])
		Else // Registro novo
			cRegForn += cValToChar(aDif[nPosForn,3,nI,4,1])
		Endif

	Next nI
	If Empty (cRegForn)
		cRegForn += "0"
	Endif
Endif

If cRegForn == "%("
	cRegForn += "0"
Endif
cRegForn += ")%"

BeginSQL Alias cAliasTemp
SELECT CNC.CNC_CODIGO CNC_CODIGO,
		CNC.CNC_LOJA CNC_LOJA,
		CNC.CNC_CLIENT CNC_CLIENT,
		CNC.CNC_LOJACL CNC_LOJACL,
		CNC.R_E_C_N_O_ RECNO
FROM %Table:CNC% CNC
WHERE 	CNC.%NotDel% AND
   		CNC.CNC_FILIAL = %xFilial:CNC% AND
   		CNC.CNC_NUMERO = %Exp:cNumContr% AND
   		CNC.CNC_REVISA = %Exp:cNumRevisa% AND
   		CNC.R_E_C_N_O_ IN %Exp:cRegForn%
EndSQL



While (cAliasTemp)->(!Eof())

	cAltera  := ""
	// Campo memo com as alteracoes realizadas na tabela CNC
	If nPosForn > 0
		nForn := Ascan(aDif[nPosForn,3],{|x| x[4,2] == (cAliasTemp)->RECNO})
		If nForn > 0
			For nY := 1 To Len(aDif[nPosForn,3,nForn,3])
				SX3->(DbGoTop())

				If Valtype(aDif[nPosForn,3,nForn,3,nY,1]) == "C" .AND. SX3->( dbSeek( aDif[nPosForn,3,nForn,3,nY,1] ) )
			 		If Alltrim(aDif[nPosForn][3][nForn][3][nY][1]) $ "CNC_CODIGO|CNC_LOJA|CNC_CLIENT|CNC_LOJACL"
				 		cCampo := AllTrim(X3Descric())
				 		cAltera	+= 	cCampo + " : [ " + AllTochar(aDif[nPosForn][3][nForn][3][nY][2]) + " ] " + CRLF
					Endif
				EndIf
			Next nY
		Else // Registro novo
			nForn := Ascan(aDif[nPosForn,3],{|x| x[4,1] == (cAliasTemp)->RECNO})
			If nForn > 0
				cAltera  := STR0045//"Inclusão de novo fornecedor."
			Endif
		Endif
	Endif

	If !Empty((cAliasTemp)->CNC_CODIGO) // Fornecedores
		AADD(aAux, (cAliasTemp)->CNC_CODIGO)
		AADD(aAux, (cAliasTemp)->CNC_LOJA)
		AADD(aAux,	 Posicione("SA2",1,xFilial("SA2")+(cAliasTemp)->CNC_CODIGO+(cAliasTemp)->CNC_LOJA,"A2_NOME"))
	Else // Clientes
		AADD(aAux, (cAliasTemp)->CNC_CLIENT)
		AADD(aAux, (cAliasTemp)->CNC_LOJACL)
		AADD(aAux, Posicione("SA1",1,xFilial("SA1")+(cAliasTemp)->CNC_CLIENT+(cAliasTemp)->CNC_LOJACL,"A1_NOME"))
	Endif

	AADD(aAux, cAltera  					)					      	//'WF5_ALTERA','M',255,'@!'

	AADD(aLoad, {(cAliasTemp)->RECNO,aClone(aAux)})
	(cAliasTemp)->(DbSkip())
	aAux := {}

EndDo

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF300RLWF6(oModel)
Carga da grid de aprovação

@author Israel Escorizza
@since 16/08/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF300RLWF6(oModel)
Local aArea		:= GetArea()
Local aAreaSCR	:= SCR->(GetArea())
Local aSaveLines	:= FwSaveRows()
Local aLoad	:= {}
Local aAux		:= {}

Local cDoc 		:= Left(SCR->CR_NUM,TAMSX3('CN9_NUMERO')[1]+TAMSX3('CN9_REVISA')[1])+'%'
Local cSCRFil		:= CnFilCtr(cDoc)
Local cTmpAlias	:= GetNextAlias()

BeginSQL Alias cTmpAlias
	SELECT	SCR.CR_NUM			CR_NUM,
			SCR.CR_TIPO		CR_TIPO,
			SCR.CR_NIVEL		CR_NIVEL,
			SCR.CR_USER		CR_USER,
			SCR.CR_DATALIB	CR_DATALIB,
	   		SCR.CR_STATUS		CR_STATUS,
	   		SCR.CR_GRUPO		CR_GRUPO,
	   		SCR.R_E_C_N_O_

	FROM 	%Table:SCR% SCR

	WHERE	SCR.%NotDel% AND
			SCR.CR_FILIAL = 		%Exp:cSCRFil% AND
			SCR.CR_NUM 	LIKE 	%Exp:cDoc% 	AND
			SCR.CR_TIPO	IN		('RV','IR')
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
	aAdd(aAux,AllTrim(Posicione("SAL",1,xFilial("SAL")+(cTmpAlias)->CR_GRUPO,"AL_DESC"))) 	// WF6_GRUPO
	aAdd(aAux,(cTmpAlias)->CR_NIVEL)																// WF6_NIVEL
	aAdd(aAux,AllTrim(UsrFullName((cTmpAlias)->CR_USER))) 										// WF6_USER
	aAdd(aAux,AllTrim(x3CboxToArray("CR_STATUS")[1][Val((cTmpAlias)->CR_STATUS)])) 			// WF6_STATUS
	aAdd(aAux,(cTmpAlias)->CR_DATALIB)																// WF6_DATA

	//- Posiciona na tabela fisica para obter valor do Memo Observação
	SCR->(MsGoto((cTmpAlias)->R_E_C_N_O_))
	aAdd(aAux,AllTrim(SCR->CR_OBS))																	// WF6_OBS

	aAdd(aLoad, {(cTmpAlias)->R_E_C_N_O_,aClone(aAux)})
	(cTmpAlias)->(DbSkip())
End

(cTmpAlias)->(dbClosearea())
FWRestRows(aSaveLines)
RestArea(aAreaSCR)
RestArea(aArea)
Return aLoad

//-------------------------------------------------------------------
/*/{Protheus.doc} A300RLibDoc
Liberação do documento de entrada.
@author augustos.raphael
@since 04/04/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function A300RLibDoc(oModel)
Local cUser	:= oModel:GetValue('SCRMASTER','CR_USER')
Local cTipo	:= oModel:GetValue('SCRMASTER','CR_TIPO')
Local cNumDocs:= oModel:GetValue('SCRMASTER','CR_NUMDOCS')
Local cParecer:= oModel:GetValue('WF1MASTER','WF1_PAREC')
Local oModelWF5:= oModel:GetModel("WF5DETAIL")
Local cAprov	:= Iif(oModel:GetWKNextState()=='4','1','2')
Local cFluig	:= Alltrim(cValToChar(oModel:GetWKNumProces()))
Local cAux		:= cNumDocs
Local nPos		:= 0
Local nX		:= 0
Local cNum		:= ""
Local nTamDoc	:= TamSX3("CR_NUM")[1]
Local lRet		:= .F.
Local oModelCT:= Nil
Private Inclui:= .F. // Para carregar o modelo do contrato

If CNFlgVldSt(oModel,@oModelCT)
	While !Empty(cAux)
		nPos := At(",",cAux)
		If nPos > 0
			cNum := Substr(cAux,1,nPos-1)
			cAux := Substr(cAux,nPos+2)
		Else // Sem aglutinação
			cNum := cAux
			cAux := ""
		Endif
		lRet := MTFlgLbDoc(Padr(cNum,nTamDoc),cUser,cAprov,cTipo,cFluig,cParecer,oModelCT)
	EndDo
Endif

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} Wf300RMecAt()
Realiza carga dos campos do mecanismo de atribuição
@author Rafael Duram
@since 07/03/2016
@version 1.0
@return .T.
/*/
//--------------------------------------------------------------------
Static Function Wf300RMecAt(oModel)
Local oFieldSCR 	:= oModel:GetModel("SCRMASTER")
Local cUserSolic	:= MtUsrSolic(oFieldSCR:GetValue("CR_TIPO"),oFieldSCR:GetValue("CR_NUM"))
Local cAprov		:= A097UsuApr(oFieldSCR:GetValue("CR_APROV"))
Local cDocs		:= GetScrAglu()

If Empty(cDocs)
	cDocs := oFieldSCR:GetValue("CR_NUM")
Endif

oFieldSCR:LoadValue("CR_CODSOL"  , FWWFColleagueId(cUserSolic)  )
oFieldSCR:LoadValue("CR_CODAPR"  , FWWFColleagueId(cAprov)   	 )
oFieldSCR:LoadValue("CR_NUMDOCS" , cDocs						   	 )

Return

//--------------------------------------------------------------------
/*/{Protheus.doc} AglCompare()
Função genérica para aglutinar os modelos de dados iguais no retorno do método Compare do MVC

@param aDif	Array contendo as diferenças do retorno do método Compare

@author rafael.duram
@since 04/04/2016
@version 1.0
@return .T.
/*/
//--------------------------------------------------------------------
Function AglCompare(aDif)

Local nI		:= 0
Local nY		:= 0
Local nJ		:= 0
Local nDel		:= 0
Local nTam		:= 0

Default aDif := {}

If Valtype(aDif)=='A' .And. Len(aDif) > 0
	nTam := Len(aDif)
	For nI:=1 To nTam
		If nI+nDel > nTam
			Exit
		Endif
		For nY:=nI+1 To nTam
			If nY+nDel > nTam
				Exit
			Endif
			// Procura o mesmo modelo em outra linha
			If aDif[nI,1] == aDif[nY,1]
				 // Repassa os dados para o primeiro modelo encontrado
				 For nJ:=1 To Len(aDif[nY,3])
				 	Aadd(aDif[nI,3],aClone(aDif[nY,3,nJ]))
				 Next nJ
				 // Deleta linha com modelo igual
				 aDel(aDif,nY)
				 aSize(aDif,Len(aDif)-1)
				 nY--
				 nDel++
			Endif
		Next nY
	Next nI
Endif

Return aDif