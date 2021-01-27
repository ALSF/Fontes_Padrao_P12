#include 'protheus.ch'
#include 'fwmvcdef.ch'
#include 'cnta091.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} CNTA091
Cadastro da Áreas do Contrato

@author janaina.jesus 
@since 12/11/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Function CNTA091()
Local oBrowser

oBrowser := FWMBrowse():New()
oBrowser:SetAlias('CXQ')
oBrowser:SetDescription(STR0001) //Áreas do Contrato

oBrowser:AddLegend( "CXQ_STATUS =='1'", "GREEN", STR0002 ) //Ativo
oBrowser:AddLegend( "CXQ_STATUS =='2'", "RED"  , STR0003 ) //Inativo

oBrowser:Activate()

Return

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0004	ACTION 'VIEWDEF.CNTA091'	OPERATION 2 ACCESS 0 //Visualizar
ADD OPTION aRotina TITLE STR0005 	ACTION 'VIEWDEF.CNTA091'	OPERATION 3 ACCESS 0 //Incluir
ADD OPTION aRotina TITLE STR0006 	ACTION 'VIEWDEF.CNTA091'	OPERATION 4 ACCESS 0 //Alterar
ADD OPTION aRotina TITLE STR0007	ACTION 'Cnt91Del()'		OPERATION 5 ACCESS 0 //Excluir
ADD OPTION aRotina TITLE STR0008 	ACTION "VIEWDEF.CNTA091"	OPERATION 8 ACCESS 0 //Imprimir

Return aRotina

//-------------------------------------------------------------------
Static Function Modeldef 
Local oStrucCXQ := FWFormStruct(1, "CXQ")
Local oModel

oModel := MPFormModel():New('CNTA091', /*bPreValidacao*/, /*bPosValidacao*/, /* 	*/, /*bCancel*/ )

oModel:AddFields( 'CXQMASTER', /*cOwner*/, oStrucCXQ, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( STR0001 ) //Áreas do Contrato

oModel:GetModel( 'CXQMASTER' ):SetDescription( STR0001 ) //Áreas do Contrato

oModel:SetPrimaryKey( {} )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel := ModelDef()
Local oStruCXQ := FWFormStruct( 2, 'CXQ' )
Local oView

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_CXQ', oStruCXQ, 'CXQMASTER' )

oView:CreateHorizontalBox( STR0001 , 100 ) //Áreas do Contrato

oView:SetOwnerView( 'VIEW_CXQ', STR0001 ) //Áreas do Contrato

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} Cnt91Del
Efetua a exclusão do contrato.

@author janaina.jesus
@since 12/11/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Function Cnt91Del()
Local aArea     := GetArea()
Local lRet      := .T.
Local cAliasCN9 := GetNextAlias()

BeginSQL Alias cAliasCN9

	SELECT COUNT(*) QTDREG
	FROM 	%table:CN9% CN9
	WHERE	CN9.CN9_FILIAL = %xFilial:CN9%			AND
			CN9.CN9_DEPART = %exp:CXQ->CXQ_CODIGO%	AND
			CN9.%NotDel%

EndSQL

If (cAliasCN9)->QTDREG > 0
	Help( " ", 1, "CNT091DEL" )
	lRet:= .F.
Else
	FWExecView (STR0001, "CNTA091", MODEL_OPERATION_DELETE,/*oDlg*/ , {||.T.},/*bOk*/ ,/*nPercReducao*/ ,/*aEnableButtons*/ ,{||.T.} /*bCancel*/ )
EndIf

(cAliasCN9)->(dbCloseArea())

RestArea(aArea)

Return lRet