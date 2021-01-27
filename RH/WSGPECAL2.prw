#Include "PROTHEUS.CH"
#Include "APWEBSRV.CH"
#Include "TBICONN.CH"
#Include "APWEBEX.CH"
#Include "FWADAPTEREAI.CH"

//------------------------------------------------------------------- 
/*/{Protheus.doc} WSGGPE
WebService responsável pelos métodos de retorno dos valores de verbas
        
@author		Fernando dos Santos Ferreira 
@since		25/04/2013
@version	P11
@obs  
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo 
/*/ 
//------------------------------------------------------------------      
User function ___rtyuiogh
Return Nil
WsService WSGGPE Description "WebService responsável pelos métodos de retorno dos valores de horas das verbas solicitadas" Namespace "http://www.totvs.com/"
	WsData	cXml			As String	
	WsData 	cXmlRet		As String
	
	// Retorna as informações dos títulos financeiros de acordo com os parâmetros.
	WsMethod GetParameters 	Description "Retorna o Valor de parâmentro na base Protheus"
EndWsService

WsMethod GetParameters WsReceive cXml WsSend cXmlRet WsService WSGGPE

FGetParVal( cXml, @Self:cXmlRet )

Return .T. 

//------------------------------------------------------------------- 
/*/{Protheus.doc} FGetParVal
Retorna o valor 
        
@author		Fernando dos Santos Ferreira 
@since		25/04/2013
@version	P11
@obs  
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo 

/*/ 
//------------------------------------------------------------------
Static Function FGetParVal( cXml, cXmlRet )
Local		aMvPesq		:= {}
Local		aMessages	:= {}
Local		cOldEmp		:= ""
Local		cOldFil		:= ""
Local		cError		:= ""
Local		cWarning	:= ""
Local		cErro		:= ""
Local		xValue		:= Nil
Local		nXi			:= 1

Default	cXml			:= ""

Private	oXml			:= Nil

oXml		:= XmlParser(cXml, "_", @cError, @cWarning)

If oXml != Nil .And. Empty(cError) .And. Empty(cWarning) 
	cOldEmp	:= cFilAnt
	cOldFil	:= cEmpAnt
		
	FValParXml( oXml, aMessages, cEmpAnt, cFilAnt, aMvPesq )
	
	If !Empty(aMessages) 	
		cErro := FWEAILOfMessages( aMessages )			
	EndIf
	
	cXmlRet := '<?xml version="1.0" encoding="utf-8"?>' 
	cXmlRet += '<ResponseMessage>'
 	cXmlRet += '	<ReceivedMessage>'
  	cXmlRet += '	<SentBy>PROTHEUS</SentBy>'  
 	cXmlRet += '</ReceivedMessage>'
 	cXmlRet += '<ProcessingInformation>'
  	cXmlRet += '<ProcessedOn>'+cValToChar(Year(Date()))+'-'+StrZero(Month(Date()), 2)+'-'+StrZero(Day(Date()), 2)+'T'+Time()+'</ProcessedOn>'	
	cXmlRet += '<Status>'+IIF(Empty(aMessages), "ok", "Faulted")+'</Status>'
	
	If Empty(aMessages)
		cXmlRet += '<ListOfMessages/>'
	Else
		cXmlRet += '<ListOfMessages>'
		cXmlRet += cErro
		cXmlRet += '</ListOfMessages>'
	EndIf
	
	cXmlRet += '</ProcessingInformation>'
	cXmlRet += '<ReturnContent>'
	cXmlRet += '<ReturnedParameters>'
	cXmlRet += '<ListOfParameters>'
	For nXi := 1 To Len(aMvPesq)
		cXmlRet += '<Parameter>'
		cXmlRet += '<ParameterInternalId>'+aMvPesq[nXi][01]+'</ParameterInternalId>'
		cXmlRet += '<ParameterValue>'+cValToChar(aMvPesq[nXi][02])+'</ParameterValue>'
		cXmlRet += '</Parameter>'
	Next
	cXmlRet += '</ListOfParameters>'
	cXmlRet += '</ReturnedParameters>'
	cXmlRet += '</ReturnContent>'
	cXmlRet += '</ResponseMessage>'	
EndIf

cFilAnt := cOldFil
cEmpAnt := cOldEmp

Return Nil

//------------------------------------------------------------------- 
/*/{Protheus.doc} FValParXml
Valida o xml do xml GetParameters
        
@author		Fernando dos Santos Ferreira 
@since		25/04/2013
@version	P11
@obs  
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo 

/*/ 
//------------------------------------------------------------------
Static Function FValParXml( oXml, aMessages, cEmp, cFil, aMvPesq )
Local		lContinua   := .T.
Local		nXi			:= 0
Local		cMvPesq		:= ""

If Type( "oXml:_TOTVSMESSAGE:_MESSAGEINFORMATION:_COMPANYID:TEXT" ) == "U" .Or. Empty( oXml:_TOTVSMESSAGE:_MESSAGEINFORMATION:_COMPANYID:TEXT )
	lContinua := .F.
	AAdd( aMessages, { "E necessario informar a Empresa.", 1, "001" } )
Else
	cEmp := StrZero(Val(oXml:_TOTVSMESSAGE:_MESSAGEINFORMATION:_COMPANYID:TEXT), 2)
EndIf

If Type( "oXml:_TOTVSMESSAGE:_MESSAGEINFORMATION:_BRANCHID:TEXT" ) == "U" .Or. Empty( oXml:_TOTVSMESSAGE:_MESSAGEINFORMATION:_BRANCHID:TEXT )
	lContinua := .F.
	AAdd( aMessages, { "E necessario informar a Filial.", 1, "002" } )
Else
	cFil := oXml:_TOTVSMESSAGE:_MESSAGEINFORMATION:_BRANCHID:TEXT
EndIf

If Type( "oXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_REQUESTEDPARAMETERS:_LISTOFPARAMETERS:_PARAMETERINTERNALID" ) == "U"
	lContinua := .F.
	AAdd( aMessages, { "Voce tem que informar o nome do parametro.", 1, "003" } )
ElseIf Type("oXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_REQUESTEDPARAMETERS:_LISTOFPARAMETERS:_PARAMETERINTERNALID") == "A"
	For nXi := 1 To Len(oXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_REQUESTEDPARAMETERS:_LISTOFPARAMETERS:_PARAMETERINTERNALID)
		If Empty(AllTrim(oXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_REQUESTEDPARAMETERS:_LISTOFPARAMETERS:_PARAMETERINTERNALID[nXi]:TEXT))
			AAdd( aMessages, { "Voce tem que informar o nome do parametro.", 1, "003" } )
		Else
			cMvPesq := AllTrim(oXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_REQUESTEDPARAMETERS:_LISTOFPARAMETERS:_PARAMETERINTERNALID[nXi]:TEXT)
			AAdd(aMvPesq, {cMvPesq, SuperGetMv(cMvPesq, .F., "", cFilAnt)})
			If Empty(aMvPesq[Len(aMvPesq)][02])
				AAdd( aMessages, { "Parametro " + aMvPesq[Len(aMvPesq)][01]+ " nao existe ou esta vazio", 1, "005" } )
			EndIf
		EndIf
	Next
ElseIf Type("oXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_REQUESTEDPARAMETERS:_LISTOFPARAMETERS:_PARAMETERINTERNALID:TEXT") == "C"
	cMvPesq := AllTrim(oXml:_TOTVSMESSAGE:_BUSINESSMESSAGE:_BUSINESSCONTENT:_REQUESTEDPARAMETERS:_LISTOFPARAMETERS:_PARAMETERINTERNALID:TEXT)
	AAdd(aMvPesq, {cMvPesq, SuperGetMv(cMvPesq, .F., "", cFilAnt)})		
	If Empty(aMvPesq[Len(aMvPesq)][02])
		AAdd( aMessages, { "Parametro " + aMvPesq[Len(aMvPesq)][01]+ " nao existe ou esta vazio", 1, "005" } )
	EndIf	
EndIf

Return lContinua


