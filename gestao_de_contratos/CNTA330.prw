#include "totvs.ch"  
#INCLUDE "CNTA330.CH"                                            

//------------------------------------------------------------------
/*/{Protheus.doc} CNTA330

Executa app Angular Dashboard de Contratos

@author  jose.delmondes
@since   13/08/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Function CNTA330()

FwCallApp("CNTA330")

Return

//------------------------------------------------------------------
/*/{Protheus.doc} JsToAdvpl

Bloco de codigo que recebera as chamadas JavaScript

@author  jose.delmondes
@since   13/08/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function JsToAdvpl(oWebChannel,cType,cContent)

Local cMascara  := "||Imagens|*.jpg|PDFs|*.pdf" //"Todos os arquivos|."
Local cTitulo   := STR0001
Local cDirini   := "\"
Local cDirDocs	:= MsDocPath()

Local lSalvar   := .T.
Local lArvore   := .F.

Local nMascpad  := 0
Local nOpcoes   := nOR( GETF_LOCALHARD, GETF_RETDIRECTORY)

Do Case

    Case cType == "preLoad"
        cJsonCompany := '{"Code":"'+cEmpAnt+'","InternalId":"'+cEmpAnt+'","CorporateName":"'+FWGrpName(cEmpAnt)+'"}'
        cJsonBranch := '{"CompanyCode":"'+cEmpAnt+'","EnterpriseGroup":"'+cEmpAnt+'","ParentCode":"'+cFilAnt+'","Code":"'+cFilAnt+'","Description":"'+FWFilialName()+'"}'
        oWebChannel:AdvPLToJS('setCompany', cJsonCompany)
        oWebChannel:AdvPLToJS('setBranch', cJsonBranch)
        
    Case cType == "download"
    	If (GetRemoteType() == REMOTE_HTML)
    		CpyS2TW(cDirDocs+'\'+cContent, .T.) 
    	Else
    		targetDir := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)
    		CpyS2T(cDirDocs+'\'+cContent, targetDir)
    	EndIf
    	
EndCase

Return
