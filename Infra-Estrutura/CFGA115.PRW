#include "CFGA115.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

Static aModulo := Array(2)
/*-------------------------------------------------------------------
{Protheus.doc} CFGA115
Configurador de Processos BPM

@author Alex Egydio
@since 21/02/2014
@version P12
-------------------------------------------------------------------*/
Function CFGA115() 
Local oBrowse  

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("CPF")                                          
oBrowse:SetDescription(STR0001)//"Processo"

oBrowse:AddLegend( "CPF_STATUS=='1'", "YELLOW" , STR0002)//'Em edição'
oBrowse:AddLegend( "CPF_STATUS=='2'", "GREEN"	 , STR0031)//'Liberado'
oBrowse:AddLegend( "CPF_STATUS=='4'", "RED"	 , STR0032)//'Bloqueado'
oBrowse:Activate()

Return
/*-------------------------------------------------------------------
{Protheus.doc} MenuDef
Menu do sistema

@author Alex Egydio
@since 21/02/2014
@version P12
@return aRotina
-------------------------------------------------------------------*/
Static Function MenuDef()  
Local aRotina := {}

ADD OPTION aRotina TITLE STR0003	ACTION "VIEWDEF.CFGA115"	OPERATION MODEL_OPERATION_VIEW		ACCESS 0  //"Visualizar"
ADD OPTION aRotina TITLE STR0004	ACTION "VIEWDEF.CFGA115"	OPERATION MODEL_OPERATION_INSERT	ACCESS 0  //"Incluir"
ADD OPTION aRotina TITLE STR0005	ACTION "VIEWDEF.CFGA115"	OPERATION MODEL_OPERATION_UPDATE	ACCESS 0  //"Alterar"
ADD OPTION aRotina TITLE STR0006	ACTION "VIEWDEF.CFGA115"	OPERATION MODEL_OPERATION_DELETE	ACCESS 3  //"Excluir"
ADD OPTION aRotina TITLE STR0007	ACTION "CFG115ALib()"	OPERATION MODEL_OPERATION_UPDATE	ACCESS 0  //"Liberar Processo"
ADD OPTION aRotina TITLE STR0008	ACTION "CFG115Copy" 	   	OPERATION OP_COPIA 					ACCESS 0  //"Copiar Processo"
ADD OPTION aRotina TITLE STR0033	ACTION "CFG115Blq('1')"	OPERATION MODEL_OPERATION_UPDATE	ACCESS 0  //"Bloquear"
ADD OPTION aRotina TITLE STR0034	ACTION "CFG115Blq('2')" 	OPERATION MODEL_OPERATION_UPDATE	ACCESS 0  //"Desbloquear"

Return aRotina
/*-------------------------------------------------------------------
{Protheus.doc} ModelDef
Definição do Modelo de Dados

@author Alex Egydio
@since 21/02/2014
@version P12
@return oModel
-------------------------------------------------------------------*/
Static Function ModelDef()
Local oModel
Local oStruCPF:= FWFormStruct(1,'CPF')
Local oStruCPG:= FWFormStruct(1,'CPG')
Local oStruCPS:= FWFormStruct(1,'CPS')
Local oStruCPU:= FWFormStruct(1,'CPU')

oModel := MPFormModel():New('CFGA115',/*bPreValid*/,{|oModel| CFGA115Pos(oModel) },/*bCommit*/,/*bCancel*/)
oModel:SetDescription(STR0009)//"Processo"

oModel:AddFields('CPFMASTER',,oStruCPF)

oModel:AddGrid('CPGDETAIL','CPFMASTER',oStruCPG)
oModel:AddGrid('CPUDETAIL','CPGDETAIL',oStruCPU)
oModel:AddGrid('CPSDETAIL','CPGDETAIL',oStruCPS)

oModel:GetModel('CPGDETAIL'):SetUniqueLine( { 'CPG_ITEM' } )

oModel:SetRelation('CPGDETAIL', { { 'CPG_FILIAL', 'xFilial("CPG")' }, { 'CPG_CODPRC', 'CPF_CODPRC' } }, CPG->(IndexKey(1)) )
oModel:SetRelation('CPUDETAIL', { { 'CPU_FILIAL', 'xFilial("CPU")' }, { 'CPU_CODPRC', 'CPF_CODPRC' }, { 'CPU_ITEM', 'CPG_ITEM' } }, CPU->(IndexKey(1)) )
oModel:SetRelation('CPSDETAIL', { { 'CPS_FILIAL', 'xFilial("CPS")' }, { 'CPS_CODPRC', 'CPF_CODPRC' }, { 'CPS_ITEM', 'CPG_ITEM' } }, CPS->(IndexKey(1)) )

oModel:GetModel('CPFMASTER'):SetDescription(STR0010)//'Processo'
oModel:GetModel('CPGDETAIL'):SetDescription(STR0011)//'Atividade do Processo'
oModel:GetModel('CPUDETAIL'):SetDescription(STR0012)//'Etapas Subsequentes'
oModel:GetModel('CPSDETAIL'):SetDescription(STR0035)//'Box'

oModel:GetModel('CPSDETAIL'):SetNoDeleteLine(.T.)
oModel:GetModel('CPSDETAIL'):SetNoInsertLine(.T.)
oModel:GetModel('CPSDETAIL'):SetOptional(.T.)
oModel:GetModel('CPUDETAIL'):SetOptional(.T.)

oModel:SetActivate({|oModel| CFG115Act(oModel)})

oModel:AddRules( 'CPGDETAIL', 'CPG_DESATV', 'CPFMASTER', 'CPF_VIEW', 1 )
oModel:AddRules( 'CPFMASTER', 'CPF_MODEL', 'CPFMASTER', 'CPF_MODULO', 1 )
oModel:AddRules( 'CPFMASTER', 'CPF_VIEW' , 'CPFMASTER', 'CPF_MODULO', 1 )

Return oModel
/*-------------------------------------------------------------------
{Protheus.doc} ViewDef
Definição da Interface

@author Alex Egydio
@since 21/02/2014
@version P12
@return oView
-------------------------------------------------------------------*/
Static Function ViewDef()
Local oModel	:= ModelDef()
Local oStruCPF:= FWFormStruct(2,'CPF')
Local oStruCPG:= FWFormStruct(2,'CPG',{|cCampo| !AllTrim(cCampo)$'CPG_CODPRC' })
Local oStruCPS:= FWFormStruct(2,'CPS',{|cCampo| !AllTrim(cCampo)$'CPS_CODPRC|CPS_ITEM' })
Local oStruCPU:= FWFormStruct(2,'CPU',{|cCampo| !AllTrim(cCampo)$'CPU_CODPRC|CPU_ITEM' })

Local oView

oView := FWFormView():New()
oView:SetModel(oModel)

oView:AddField('VIEW_CPF'	, oStruCPF,'CPFMASTER')
oView:AddGrid('VIEW_CPG'		, oStruCPG,'CPGDETAIL')  
oView:AddGrid('VIEW_CPS'		, oStruCPS,'CPSDETAIL')
oView:AddGrid('VIEW_CPU'		, oStruCPU,'CPUDETAIL')  

oView:CreateHorizontalBox( 'CPF', 40)
oView:CreateHorizontalBox( 'CPG', 30)
oView:CreateHorizontalBox( 'BAIXO', 30)

oView:CreateFolder('FLDBAIXO','BAIXO')

oView:addSheet('FLDBAIXO','ABACPU',STR0013)//'Etapas Subsequentes'
oView:addSheet('FLDBAIXO','ABACPS',STR0035)//'Box'

oView:CreateHorizontalBox( 'FLDESQ', 100,,, 'FLDBAIXO', 'ABACPU' )
oView:CreateHorizontalBox( 'FLDDIR', 100,,, 'FLDBAIXO', 'ABACPS' )

oView:SetOwnerView('VIEW_CPF','CPF')
oView:SetOwnerView('VIEW_CPG','CPG')

oView:SetOwnerView('VIEW_CPU','FLDESQ')
oView:SetOwnerView('VIEW_CPS','FLDDIR')

oView:EnableTitleView('VIEW_CPF')
oView:EnableTitleView('VIEW_CPG')
oView:EnableTitleView('VIEW_CPS')
oView:EnableTitleView('VIEW_CPU')

oView:AddIncrementField('VIEW_CPG','CPG_ITEM')

oView:AddUserButton(STR0014, 'CLIPS', {|oModel|CFG115DS(oModel)})//'Criar Dataset'
oView:AddUserButton(STR0015, 'CLIPS', {||MTComPr()})//'Processo de Compras'

Return oView

/*-------------------------------------------------------------------
{Protheus.doc} CFGA115Pro
Cria fichario e Processo no ECM, acionado através de ações relacionadas

@author Alex Egydio
@since 21/02/2014
@version P12
-------------------------------------------------------------------*/
Function CFGA115Pro(oModel115)
Local oView115 := FWViewActive()
Local nFichaId := 0
Local lRet := .T.

If CPF->CPF_STATUS == '4'
	lRet := .F.
EndIf

If IsInCallStack('CFG115ALib') .And. lRet
	
	// --------------------------------------------------
	// Criação do serviço por usuário
	// --------------------------------------------------
	MsgRun(STR0041,,{|| lRet := FWWFServices(GetMV("MV_ECMDS",.F.,''))  }) // 'Gerando serviço Fluig'
	If !lRet
		Help(" ",1,"A115Serv",,STR0042 + ' : ' + FWWFGetError()[2],1,1) //'Erro ao gerar serviço.'
	EndIf
	
	// --------------------------------------------------
	// Cria ou Recupera um fichario no ECM e salva o código
	// --------------------------------------------------
	If lRet
		MsgRun(STR0016,,{||nFichaId := PutCard(AllTrim(CPF->CPF_VIEW),AllTrim(CPF->CPF_CODPRC),AllTrim(CPF->CPF_DESPRC),.F.,AllTrim(CPF->CPF_MODULO)) })
		
		lRet := (nFichaId > 0) 
		
		If lRet
			oModel115:LoadValue('CPFMASTER','CPF_FICHA',AllTrim(Str(nFichaId)))
		EndIf
	EndIf
	
	// --------------------------------------------------
	// Atualização de Status casa o processo seja importado com sucesso
	// --------------------------------------------------
	If lRet
		MsgRun(STR0017,,{||lRet := CFGSmartPr(oModel115,oView115,nFichaId)})//'Atualizando processo'
		If lRet
			oModel115:LoadValue('CPFMASTER','CPF_STATUS','2')
		EndIf
	EndIf
	
	// --------------------------------------------------
	// Cria ou atualiza o Dataset do processo
	// --------------------------------------------------
	If lRet
		MsgRun(STR0018,,{||CFG115DS(oModel115)})//'Atualizando dataset'
	EndIf
	
	If !lRet
		oModel115:LoadValue('CPFMASTER','CPF_STATUS',CPF->CPF_STATUS)
	EndIf
	
Else
	Help(" ",1,"CFGA115Pro",,STR0036,1,1)//'Não é possível liberar processos bloqueados'
EndIf

Return lRet
/*-------------------------------------------------------------------
{Protheus.doc} CFGA115VPr
Caso o evento no grid de atividades, for igual Atividade não permitir
acesso ao grid de sub-processo, caso contrario permite o acesso.
Acionado através do campo CPG_EVENTO

@author Alex Egydio
@since 21/02/2014
@version P12
-------------------------------------------------------------------*/
Function CFGA115VPr()
Local lEvento	:= FWFldGet('CPG_EVENTO')=='1' 
Local n1Cnt	:= 0
Local oModel	:= FwModelActive()

For n1Cnt := 1 To oModel:GetModel('CPLDETAIL'):Length()
	oModel:GetModel('CPLDETAIL'):GoLine(n1Cnt)
	If	lEvento
		If	!Empty(oModel:GetValue('CPLDETAIL','CPL_DESATV'))
			oModel:GetModel('CPLDETAIL'):DeleteLine()
		EndIf
	Else
		oModel:GetModel('CPLDETAIL'):UnDeleteLine()
	EndIf
Next
	
oModel:GetModel('CPLDETAIL'):SetNoInsertLine(lEvento)
oModel:GetModel('CPLDETAIL'):SetNoUpdateLine(lEvento)
oModel:GetModel('CPLDETAIL'):SetNoDeleteLine(lEvento)

Return .T.
/*-------------------------------------------------------------------
{Protheus.doc} CFGA115Chk
Os campos CPG_ITEM e CPL_ITEM representam o codigo das atividades e
atividades do sub-processo, estes codigos são digitados nas colunas
de decisões dos grids Atividade e Sub-processo, portanto a função
valida se os codigos digitados em (CPG_DECID1/CPG_DECID2/CPL_DECID1/CPL_DECID2)
existem nos grids.

@author Alex Egydio
@since 21/02/2014
@version P12
@return lRet
-------------------------------------------------------------------*/
Function CFGA115Chk(cAcao,cItem)
Local aSaveL	:= FWSaveRows()
Local oModel	:= FWModelActive()
Local oStruDet:= oModel:GetModel(Iif(cAcao=='1','CPGDETAIL','CPLDETAIL'))
Local n1Cnt	:= 0
Local lRet		:= .F.

If	Empty(cItem)
	lRet := .T.
Else
	For n1Cnt := 1 To oStruDet:Length()
		oStruDet:GoLine(n1Cnt)
		If	oStruDet:GetValue(Iif(cAcao=='1','CPG_ITEM','CPL_ITEM'))==cItem
			lRet := .T.
			Exit
		EndIf
	Next
EndIf
FWRestRows( aSaveL )
Return(lRet)

/*-------------------------------------------------------------------
{Protheus.doc} CFGA115Pos
Pós-validacao do modelo

@author Alex Egydio
@since 06/03/2014
@version P12
@return lRet
-------------------------------------------------------------------*/
Function CFGA115Pos(oModel)
Local aSubPro	:= {}
Local lRet		:= .T.
Local n1Cnt	:= 0
Local oModelCPG:= oModel:GetModel("CPGDETAIL")

// --------------------------------------------------
// Atualização de Status devido alteração no fluxo
// --------------------------------------------------
If oModel:GetOperation() == MODEL_OPERATION_UPDATE .And. oModel:Getvalue('CPFMASTER','CPF_STATUS') == '2'
	lRet := MSGYESNO(STR0020,STR0021) //'A alteração desse processo fará com que seja necessário outra liberação, deseja continuar?'//'Atenção'
	If lRet
		oModel:SetValue('CPFMASTER','CPF_STATUS','1')
	EndIf
EndIf

// --------------------------------------------------
// Liberação do processo
// --------------------------------------------------
If	(IsInCallStack('CFG115ALib')) .And. lRet
	// --------------------------------------------------
	// Sobe o processo para o Fluig
	// --------------------------------------------------
	If lRet 
		lRet := CFGA115Pro(oModel)
	EndIf 
EndIf

Return lRet

/*-------------------------------------------------------------------
{Protheus.doc} CFGA115Fx
Validacao do fluxo definido nos grids CPG e CPL

A rotina GCPA017F deverá ser compilada para uso da funcao GCPGrafo()

@author Alex Egydio
@since 06/03/2014
@version P12
@return lRet
-------------------------------------------------------------------*/
Function CFGA115VFx(cAcao,oModel,aSubPro,cAtivd)
Local aTemp		:= {}
Local cArqGrd		:= Iif(cAcao=="1","CPG","CPL")
Local lRet			:= .T.
Local n1Cnt		:= 0
Local nConjunto	:= 0
Local nMedia		:= 0
Local nTotal		:= 1
Local oGrafo
Local oDetails	:= oModel:GetModel(Iif(cAcao=="1","CPGDETAIL","CPLDETAIL"))

aTemp	:= AClone(oDetails:aCols)
oGrafo	:= GCPGrafo():New(aTemp)
//-- Valida o fluxo de atividades
oGrafo:nAtual	:= GDFieldPos(cArqGrd+"_ITEM"  ,oDetails:aHeader)		//-- coluna das atividades
oGrafo:nNext	:= GDFieldPos(cArqGrd+"_DECID1",oDetails:aHeader)		//-- coluna da decisao afirmativa
oGrafo:nBack	:= GDFieldPos(cArqGrd+"_DECID2",oDetails:aHeader)		//-- coluna da decisao negativa

nConjunto := oDetails:Length()
For n1Cnt := 1 To oDetails:Length()
	oDetails:GoLine(n1Cnt)
	If	n1Cnt==1
		oGrafo:cInicio := oDetails:GetValue(cArqGrd+"_ITEM")			//-- inicial
	ElseIf "FIM"$Upper(oDetails:GetValue(cArqGrd+"_DESATV"))
		oGrafo:cFim := oDetails:GetValue(cArqGrd+"_ITEM")				//-- final
	EndIf
	//-- Guarda a posicao onde foi indicado sub-processo
	If	cAcao=='1' .And. oDetails:GetValue("CPG_EVENTO")=="2"
		AAdd(aSubPro,n1Cnt)
	EndIf
	nTotal *= Val(oDetails:GetValue(cArqGrd+"_ITEM"))
Next

If	Empty(oGrafo:cFim)
	oGrafo:cFim := "Fim"
EndIf

nMedia := Int(nTotal^(1/nConjunto))
oDetails:GoLine(nMedia)
oGrafo:cMeio	:= oDetails:GetValue(cArqGrd+"_ITEM")					//-- atividade do meio

oGrafo:DelLine() // Deleta fisicamente as linhas deletadas  
oGrafo:GeraGrafo(,,,cAcao=="1")		//-- para atividades obriga q tenha predecessoras, para sub-processo nao obriga.

If Len(oGrafo:aErro) > 0
	lRet := .F.
	//-- Exibe tela com os erros do fluxo de etapas
	oGrafo:LogGrafo(oGrafo:aErro ,STR0023+Iif(cAcao=="1",STR0022,STR0024+cAtivd))//"Atividade"//"Erro no Fluxo - Grid "//"Sub-processo "
EndIf	

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115ALib
Chamada da liberação do processo

@author guilherme.pimentel
@return Nil
@since 10/03/2013
@version P11
/*/
//-------------------------------------------------------------------

Function CFG115ALib()
FWExecView (STR0025, "CFGA115", MODEL_OPERATION_UPDATE ,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ ,  /*bCancel*/ )//'Liberação de Processo'
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115Act
Activate do modelo de dados

@param oModel Modelo de dados da Rotina 

@author guilherme.pimentel
@return Nil
@since 10/03/2013
@version P11
/*/
//-------------------------------------------------------------------

Function CFG115Act(oModel)
Local oStruCPF := oModel:GetModel('CPFMASTER'):GetStruct() 

// --------------------------------------------------
// Bloqueio dos modelos na Liberação e Ajustes iniciais na Cópia
// --------------------------------------------------
If (IsInCallStack('CFG115ALib'))
	// --------------------------------------------------
	// Alteração de Status para que seja efetuado o Commit
	// --------------------------------------------------
	oModel:SetValue('CPFMASTER','CPF_STATUS','3')
	
	// --------------------------------------------------
	// Bloqueio de todos os campos
	// --------------------------------------------------
	oStruCPF:SetProperty('*',MODEL_FIELD_WHEN,{||.F.})
	oModel:GetModel('CPGDETAIL'):SetOnlyView(.T.)
	
	// --------------------------------------------------
	// Definição dos campo obrigatórios
	// --------------------------------------------------
	oStruCPF:SetProperty("CPF_CODPRC",MODEL_FIELD_OBRIGAT,.T.)
	oStruCPF:SetProperty("CPF_DESPRC",MODEL_FIELD_OBRIGAT,.T.)
	oStruCPF:SetProperty("CPF_MODEL",MODEL_FIELD_OBRIGAT,.T.)
	oStruCPF:SetProperty("CPF_VIEW",MODEL_FIELD_OBRIGAT,.T.)

ElseIf (IsInCallStack('CFG115Copy'))
	// --------------------------------------------------
	// Inicialização dos campos para a cópia
	// --------------------------------------------------
	oModel:GetModel('CPFMASTER'):SetValue('CPF_CODPRC','' )
	oModel:GetModel('CPFMASTER'):SetValue('CPF_DESPRC','' )
	oModel:GetModel('CPFMASTER'):SetValue('CPF_PROPRI','2')
	oModel:GetModel('CPFMASTER'):SetValue('CPF_FICHA' ,'' )
	oModel:GetModel('CPFMASTER'):SetValue('CPF_STATUS','1')

EndIf
// --------------------------------------------------
// Bloqueio dos campos caso seja propriedade TOTVS
// --------------------------------------------------
If oModel:GetValue('CPFMASTER','CPF_PROPRI') == '1' .And. oModel:GetOperation() == MODEL_OPERATION_UPDATE
	oModel:GetModel('CPFMASTER'):GetStruct():SetProperty("*",MODEL_FIELD_WHEN,{||.F.})
	oModel:GetModel('CPGDETAIL'):SetNoInsertLine(.T.)
	oModel:GetModel('CPGDETAIL'):SetNoUpdateLine(.T.)
	oModel:GetModel('CPGDETAIL'):SetNoDeleteLine(.T.)
	oModel:GetModel('CPUDETAIL'):SetNoInsertLine(.T.)
	oModel:GetModel('CPUDETAIL'):SetNoUpdateLine(.T.)
	oModel:GetModel('CPUDETAIL'):SetNoDeleteLine(.T.)
EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115VldF
validação do Workflow

@param oModel Modelo de dados da Rotina 

@author guilherme.pimentel
@return Nil
@since 10/03/2013
@version P11
/*/
//-------------------------------------------------------------------

Function CFG115VldF(oModel)
Local aSubPro	:= {}
Local lRet		:= .T.
Local n1Cnt	:= 0
Local oModelCPG:= oModel:GetModel("CPGDETAIL")

lRet := CFGA115VFx('1',oModel,aSubPro)
// --------------------------------------------------
// Valida o fluxo definido no grid CPL
// --------------------------------------------------
If	lRet .And. !Empty(aSubPro)
	For n1Cnt := 1 To Len(aSubPro)
		oModelCPG:GoLine(aSubPro[n1Cnt])
		lRet := CFGA115VFx('2',oModel,,oModelCPG:GetValue("CPG_ITEM"))
		If	!lRet
			Exit
		EndIf
	Next
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115Copy
Chamada da copia do processo

@author guilherme.pimentel
@return Nil
@since 14/03/2013
@version P11
/*/
//-------------------------------------------------------------------

Function CFG115Copy()
FWExecView(STR0026, 'CFGA115', OP_COPIA, /*oDlg*/, { || .T. } )//"Copiar"//'Copia de Processo'
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115AltF
Alteração do fichário do processo

@author guilherme.pimentel
@return Nil
@since 14/03/2013
@version P11
/*/
//-------------------------------------------------------------------

Function CFG115AltF()
FWExecView(STR0027, 'CFGA115', MODEL_OPERATION_UPDATE, /*oDlg*/, { || .T. } )//"Copiar"//'Alteração de Fichário'
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} LookUpMod
F3 dos módulos

@author guilherme.pimentel

@since 25/03/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function LookUpMod()

Local aModules := RetModName(.T.) //aArray(2)
Local cAmb := ""
Local lRet := .F.

PARAM_IXB := Array(2)

cAmb  := FWPesqAmb(aModules)

If ValType(cAmb) == "C"
	If ( nAscan := aScan( aModules, {|x| x[1] == Val(cAmb) } ) ) == 0
		cDesAmb := ""
	Else
		cDesAmb := aModules[nAscan][3]
		
		PARAM_IXB[1] := cAmb
		PARAM_IXB[2] := cDesAmb
		
		aModulo := PARAM_IXB
		
		lRet := .T.
	EndIf
EndIf
	
Return  lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GetAmb
Preenchimento dos campos de código do módulo e descrição

@author guilherme.pimentel

@param cTipo Caracter informativo de qual campo será preenchido
@since 25/03/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function GetAmb(cTipo)
Local cAmb := aModulo[1]
Local cDesAmb := aModulo[2]
Default cTipo := '1'

Return If(cTipo == '1',cAmb,cDesAmb)                                                                      
                                                                  
//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115Load
Carregamento das view do formulário

@author guilherme.pimentel

@obs Esta função é utilizada tanto pelo cabeçalho quanto pelo detail
por isso temos o parametro cModel. Ele controla se alteração será para
todos os registros ou somente para o registro posicionado.

@since 25/03/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function CFG115Load(cModel)
Local lRet	:= .T.
Local nX	:= 0
Local nY	:= 0
Local nModuloAnt	:= 0
Local oModel		:= FWModelActive()
Local oView		:= nil
Local oModelCPF	:= oModel:GetModel('CPFMASTER')
Local oModelCPG	:= oModel:GetModel('CPGDETAIL')
Local oModelCPS	:= oModel:GetModel('CPSDETAIL')

Default cModel := 'CPG'

// --------------------------------------------------
// Troca de módulo devido campos proprietários
// --------------------------------------------------
nModuloAnt	:= nModulo
nModulo	:= Val(oModelCPF:GetValue('CPF_MODULO'))

oView	:= FWLoadView(AllTrim(oModel:GetValue('CPFMASTER','CPF_VIEW')))

// --------------------------------------------------
// Liberação do Modelo
// --------------------------------------------------
oModelCPS:SetNoUpdateLine(.F.)
oModelCPS:SetNoInsertLine(.F.)
oModelCPS:SetNoDeleteLine(.F.)
// --------------------------------------------------
// Limpa o modelo caso tenha valores antigos
// --------------------------------------------------
For nY := 1 to oModelCPG:Length() 
	If cModel == 'CPF'
		oModelCPG:GoLine(nY)
	EndIf
	If oModelCPG:IsInserted()
		For nX := oModelCPS:Length() To 1 STEP -1
			oModelCPS:GoLine(nX)
			oModelCPS:DeleteLine(.T.,.T.)	
		Next nX
	EndIf
	If cModel <> 'CPF'
		Exit
	EndIf
	oModelCPS:UnDeleteLine()
Next nY
oModelCPS:UnDeleteLine()
// --------------------------------------------------
// Carregamento dos novos valores
// --------------------------------------------------
For nY := 1 to oModelCPG:Length() 
	If cModel == 'CPF'
		oModelCPG:GoLine(nY)
	EndIf
	If oModelCPG:IsInserted()
		For nX := 1 to Len(oView:aViews)	
			If nX <> 1
				oModelCPS:AddLine()
			EndIf
			oModelCPS:SetValue('CPS_IDBOX',oView:aViews[nX][1])
			oModelCPS:SetValue('CPS_NOME',IF(Empty(oView:aViews[nX][7]),oView:aViews[nX][1],oView:aViews[nX][7]))
			oModelCPS:SetValue('CPS_VISUAL','1')
		Next nX
	EndIf
	If cModel <> 'CPF'
		Exit
	EndIf
Next nY
oModelCPS:GoLine(1)
	
// --------------------------------------------------
// Trava do modelo
// --------------------------------------------------
oModelCPS:SetNoInsertLine(.T.)
oModelCPS:SetNoDeleteLine(.T.)

// --------------------------------------------------
// Restauração do módulo
// --------------------------------------------------
nModulo := nModuloAnt 

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFGVldMod
Valida o mudulo selecionado ou digitado pelo usuário. 

@author taniel.silva
@since 26/03/2014
@version P12
@return lRet
/*/
//-------------------------------------------------------------------
Function CFGVldMod()
Local aModules := RetModName(.T.) //aArray(2)
Local cCodMod := ""
Local cDesMod := ""
Local lRet := .F.

PARAM_IXB := Array(2)

cCodMod := FWFldGet('CPF_MODULO')

If ( nAscan := aScan( aModules, {|x| x[1] == Val(cCodMod) } ) ) == 0
	cDesMod := ""		
	Help("",1,STR0028,,STR0029,4,1)//"Atenção"//"Este módulo não existe. Favor selecionar um módulo existente."
Else
	cDesMod := aModules[nAscan][3]
	
	PARAM_IXB[1] := cCodMod
	PARAM_IXB[2] := cDesMod
	
	aModulo := PARAM_IXB
	
	lRet := .T.
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFGIniMod
Função para preencher a descrição do modulo na alteração. 

@author taniel.silva
@since 26/03/2014
@version P12
@return cDesMod
/*/
//-------------------------------------------------------------------

Function CFGIniMod()

Local aModules := RetModName(.T.) //aArray(2)
Local cCodMod := ""
Local cDesMod := ""

CPF->(dbSetOrder(1))
cCodMod := CPF->CPF_MODULO

If ( nAscan := aScan( aModules, {|x| x[1] == Val(cCodMod) } ) ) == 0
	cDesMod := ""		
Else
	cDesMod := aModules[nAscan][3]
	
EndIf
Return cDesMod

//-------------------------------------------------------------------
/*/{Protheus.doc}  CFGLimCamp()
Função para limpar campo de acordo com a opção: Nenhum, Usuario e Grupo

@author taniel.silva
@since 27/03/2014
@version P12
@return lRet
/*/
//-------------------------------------------------------------------
Function CFGLimCamp()
Local oModel	:= FWModelActive()
Local lRet := .T.

If (FWFldGet('CPG_MECAT') == '2')  
	oModel:GetModel('CPGDETAIL'):LoadValue('CPG_MAGRP', CriaVar('CPG_MAGRP'))	
	oModel:GetModel('CPGDETAIL'):LoadValue('CPG_DESGRP', CriaVar('CPG_DESGRP'))	                                                                                                                                    
ElseIf	(FWFldGet('CPG_MECAT') == '1')  
	oModel:GetModel('CPGDETAIL'):LoadValue('CPG_MAUSER',CriaVar('CPG_MAUSER'))
	oModel:GetModel('CPGDETAIL'):LoadValue('CPG_DESUSR',CriaVar('CPG_DESUSR'))
else
	oModel:GetModel('CPGDETAIL'):LoadValue('CPG_MAGRP', CriaVar('CPG_MAGRP'))	
	oModel:GetModel('CPGDETAIL'):LoadValue('CPG_DESGRP', CriaVar('CPG_DESGRP'))	
    oModel:GetModel('CPGDETAIL'):LoadValue('CPG_MAUSER',CriaVar('CPG_MAUSER'))
	oModel:GetModel('CPGDETAIL'):LoadValue('CPG_DESUSR',CriaVar('CPG_DESUSR'))
EndIf
		
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115DS
Geração ou atualiza Datasets

@author guilherme.pimentel
@param oModel modelo de dados ativo
@since 25/03/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function CFG115DS(oModel)
Local nX := 0
Local nY := 0
Local cName := ''
Local aColumns := {}
Local aRows := {}
Local lRet := .T.

Local nSequence := 0
Local cIdBox := ''
Local cOption := ''

Local oModelCPG := oModel:GetModel('CPGDETAIL')
Local oModelCPS := oModel:GetModel('CPSDETAIL')

// --------------------------------------------------
// Nome do Dataset
// --------------------------------------------------
cName := AllTrim(oModel:GetValue('CPFMASTER','CPF_CODPRC'))+'_VIEWSTATE'
// --------------------------------------------------
// Definição das colunas do Dataset padrão
// --------------------------------------------------
aAdd(aColumns,'version')
aAdd(aColumns,'sequence')
aAdd(aColumns,'id')
aAdd(aColumns,'option')
// --------------------------------------------------
// Dados do Dataset padrão
// --------------------------------------------------
For nX := 1 To oModelCPG:Length() 
	oModelCPG:GoLine(nX)
	For nY := 1 To oModelCPS:Length() 
		oModelCPS:GoLine(nY)
		nSequence := val(oModelCPG:GetValue('CPG_ITEM'))
		cIdBox := AllTrim(oModelCPS:GetValue('CPS_IDBOX'))
		cOption := AllTrim(oModelCPS:GetValue('CPS_VISUAL'))
		
		aAdd(aRows,{'1',nSequence,cIdBox,cOption} )
	next nY
Next nX
// --------------------------------------------------
// Chamada da função de criação/alteração do dataset
// --------------------------------------------------
lRet := FWECMDataSet(cName,aColumns,aRows)

If !lRet .And. FWWFIsError()
	aError := FWWFGetError()
	MsgStop(aError[2])
EndIf
// --------------------------------------------------
// Reposicionamento das linhas
// --------------------------------------------------
For nX := 1 To oModelCPG:Length() 
	oModelCPG:GoLine(nX)
	oModelCPS:GoLine(1)
Next nX
oModelCPG:GoLine(1)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} A115VldEtp

@author 
@param 
@since 
@version 
@return 
/*/
//-------------------------------------------------------------------

Function A115VldEtp(oModel,cField,cValue,cOldValue)
Local lRet := .F.
Local aSaveLines	:= FWSaveRows()
Local oModel115 := FWModelActive()
Local oModelCPG := oModel115:GetModel('CPGDETAIL')
Local oModelCPU := oModel115:GetModel('CPUDETAIL')
Local nX := 0
Local nY := 0
Local nCPG := 0
Local nLineCPG := oModelCPG:getLine()
Local nLineCPU := oModelCPU:getLine()
Local cItemCPG := oModelCPG:GetValue('CPG_ITEM')
Local cDesAtv := ''

If oModel:GetId() == 'CPUDETAIL'
	If cValue == cItemCPG
		lRet := .F.
		Help(" ",1,"A115VldEtp",,STR0030,1,1)//'Um etapa não deve referenciar ela mesmas'
	EndIf
	For nX := 1 to oModelCPG:Length()
		oModelCPG:GoLine(nX)
		If oModelCPG:GetValue('CPG_ITEM') <> cValue
			Loop
		Else
			cDesAtv := Trim(oModelCPG:GetValue('CPG_DESATV'))
			lRet := .T.
			Exit
		EndIf
	Next nX
	
	If lRet
		oModelCPG:GoLine(nLineCPG)
		oModelCPU:GoLine(nLineCPU)
		oModelCPU:SetValue('CPU_DESATV',cDesAtv)
	EndIf
Else
	For nX := 1 to oModelCPG:Length()
		oModelCPG:GoLine(nX)
		For nY := 1 to oModelCPU:Length()
			oModelCPU:GoLine(nY)
			If cItemCPG == oModelCPU:GetValue('CPU_SEQ')
				oModelCPU:SetValue('CPU_DESATV',cValue)
			EndIf
		Next nY
		oModelCPU:GoLine(1)
	Next nX
	lRet := .T.	
EndIf

FWRestRows( aSaveLines )
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115Blq
Função de bloqueio e liberação de processos

@author guilherme.pimentel
@param cTipo tipo da execução que foi realizada
@since 01/07/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function CFG115Blq(cTipo)
Default cTipo := '1'

If cTipo = '1' 
	If CPF->CPF_STATUS <> '4' .And. MSGYESNO(STR0037,STR0021)//'Deseja realmente bloquear esse processo?' //'Atenção'
		RecLock("CPF",.F.)
		CPF->CPF_STATUS := '4'
		MsUnLock()
	ElseIf CPF->CPF_STATUS == '4'
		Help(" ",1,"CFG115Blq",,STR0039,1,1) //'O processo já está bloqueado.'
	EndIf
ElseIf cTipo = '2' 
	If CPF->CPF_STATUS == '4' .And. MSGYESNO(STR0038,STR0021)//'Deseja realmente desbloquear esse processo?' //'Atenção'
		RecLock("CPF",.F.)
		CPF->CPF_STATUS := '1'
		MsUnLock()
	ElseIf CPF->CPF_STATUS <> '4'
		Help(" ",1,"CFG115Blq",,STR0040,1,1) //'O processo já está desbloqueado.'
	EndIf
EndIf

Return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115AtvC
Validação da marcação do consenso

@author guilherme.pimentel
@param oModel parte do modelo de dados
@param cField Campo que chamou o valid
@param cValue Valor atual
@param cOldValue Valor anterior
@since 26/08/2014
@version P12
@return lRet
/*/
//-------------------------------------------------------------------
Function CFG115AtvC(oModel,cField,cValue,cOldValue)
Local lRet := .T.

If !cValue
	oModel:LoadValue('CPG_CONSEN',0)
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115Cons
Validação do valor do consenso

@author guilherme.pimentel
@param oModel parte do modelo de dados
@param cField Campo que chamou o valid
@param cValue Valor atual
@param cOldValue Valor anterior
@since 26/08/2014
@version P12
@return lRet
/*/
//-------------------------------------------------------------------
Function CFG115Cons(oModel,cField,cValue,cOldValue)
Local lRet := .T.

If !oModel:GetValue('CPG_ATVCOM')
	lRet := .F.
	Help(" ",1,"CFG115Cons",, STR0044,1,1) //'Favor marcar a opção atividade compartilhada'
ElseIf (cValue < 0) .Or. (cValue > 100)
	lRet := .F.
	Help(" ",1,"CFG115Cons",,STR0045,1,1) //'O valor tem que estar entre 0 e 100.'
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFG115Cons
Validação do valor do consenso

@author guilherme.pimentel
@param cTipo Tipo da verificação a ser efetuada
@since 26/08/2014
@version P12
@return lRet
/*/
//-------------------------------------------------------------------
Function CFG115Modl(cTipo)
Local lRet := .T.
Local nModuloAnt := 0
Local oModel := FWModelActive()

Default cTipo := 'M'

// --------------------------------------------------
// Troca de módulo devido campos proprietários
// --------------------------------------------------
nModuloAnt	:= nModulo
nModulo	:= Val(oModel:GetValue('CPFMASTER','CPF_MODULO'))

// --------------------------------------------------
// Verificação de existencia do modelo ou view
// --------------------------------------------------
bError := ErrorBlock( {|| lRet := .F., Help(" ",1,"CFG115Modl",,STR0043,1,1) } ) //'Não foi possível carregar o modelo/view informado'
Begin Sequence

	If cTipo == 'M'
		lRet := ValType(FWLoadModel(FWFldGet('CPF_MODEL')))=='O'
	Else
		lRet := ValType(FWLoadView(FWFldGet('CPF_VIEW')))=='O'
	EndIf

End Sequence

// --------------------------------------------------
// Restauração do módulo
// --------------------------------------------------
nModulo := nModuloAnt

If !lRet
	Help(" ",1,"CFG115Modl",,STR0043,1,1) //'Não foi possível carregar o modelo/view informado'
EndIf

Return lRet