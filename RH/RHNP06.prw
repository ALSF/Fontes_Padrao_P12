#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"

#INCLUDE "RHNP06.CH"

Function RHNP06()
Return .T.


WSRESTFUL Timesheet DESCRIPTION EncodeUTF8(STR0001) //"Serviço de Abonos"

WSDATA employeeId		As String Optional
WSDATA WsNull 			As String Optional
WSDATA initPeriod		As String Optional
WSDATA endPeriod		As String Optional
WSDATA referenceDate	As String Optional
WSDATA latitude     	As String Optional
WSDATA longitude    	As String Optional

//"Retorna os tipos de abonos cadastrados e disponíveis no ERP para uso no APP - MEU RH."
WSMETHOD GET GetAllowances DESCRIPTION EncodeUTF8(STR0002) ;
PATH "/allowancesTypes" PRODUCES 'application/json;charset=utf-8'

//"Retorna o espelho de ponto do colaborador."
WSMETHOD GET clockings DESCRIPTION EncodeUTF8(STR0004) ;
PATH "/clockings/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//Retorna os períodos de ponto disponíveis para o usuário.
WSMETHOD GET GetPeriods DESCRIPTION EncodeUTF8(STR0008) ;
PATH "/periods/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//Saldos - Retorna os saldos de horas do período do colaborador.
WSMETHOD GET GetBalanceSummary DESCRIPTION EncodeUTF8(STR0009) ;
PATH "/balanceSummary/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//Resumo do Periodo - Retorna o resumo do total das ocorrências do período do colaborador.
WSMETHOD GET GetTotSummPeriod DESCRIPTION EncodeUTF8(STR0010) ;
PATH "/occurrencesTotalSummaryPeriod/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//Resumo diario - Retorna as ocorrências de ponto do colaborador.
WSMETHOD GET GetOccurrences DESCRIPTION EncodeUTF8(STR0011) ;
PATH "/occurrences/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//Retorna os motivos da batida.
WSMETHOD GET GetClockTypes DESCRIPTION EncodeUTF8(STR0011) ;
PATH "/clockingsReasonTypes" PRODUCES 'application/json;charset=utf-8'

//Retorna arquivo PDF do espelho do ponto
WSMETHOD GET gFileClocking DESCRIPTION EncodeUTF8(STR0011) ;
PATH "/clockings/report/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Método que inclui uma solicitação de Abono."
WSMETHOD POST SetAllowanceRequest DESCRIPTION EncodeUTF8(STR0003) ;
PATH "/allowances/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Inclusão de batidas do espelho de ponto."
WSMETHOD POST SetClocking DESCRIPTION EncodeUTF8(STR0004) ;
PATH "/clocking/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Inclusão de batida 373 no ponto"
WSMETHOD POST geolocation DESCRIPTION EncodeUTF8(STR0017) ;
PATH "/clockingsGeolocation/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Atualiza as batidas de ponto por Geolocalização funcionário"
WSMETHOD PUT geolocation DESCRIPTION EncodeUTF8("") ;
PATH "/clockingsGeolocation/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Retorna as batidas de ponto por Geolocalização funcionário"
WSMETHOD GET geolocation DESCRIPTION EncodeUTF8(STR0017) ;
PATH "/clockingsGeolocation/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Retorna as batidas de ponto do dia atual"
WSMETHOD GET todayClockings DESCRIPTION EncodeUTF8(STR0019) ;
PATH "/todayClockings/{employeeId}/{latitude}/{longitude}" PRODUCES 'application/json;charset=utf-8'

//"Retorna a data e hora atuais do servidor com base no fuso horário do usuário"
WSMETHOD GET currentTime DESCRIPTION EncodeUTF8(STR0020) ;
PATH "/clockingsGeolocation/currentTime/{latitude}/{longitude}" PRODUCES 'application/json;charset=utf-8'

//"Retorna os motivos para desconsiderar batidas"
WSMETHOD GET disconsider DESCRIPTION EncodeUTF8(STR0022) ;
PATH "/disconsiderReasons/" PRODUCES 'application/json;charset=utf-8'

//"Atualiza varias batidas do espelho do ponto"
WSMETHOD PUT EditVariousClockings DESCRIPTION EncodeUTF8(STR0023) ;
PATH "/clockings/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Inclusão de batidas do espelho de ponto"
WSMETHOD POST SetVariousClockings DESCRIPTION EncodeUTF8(STR0016) ;
PATH "/clockings/{employeeId}" PRODUCES 'application/json;charset=utf-8'

//"Atualiza uma batida do espelho do ponto"
WSMETHOD PUT EditOneClockings DESCRIPTION EncodeUTF8(STR0028) ;
PATH "/clocking/{employeeId}/{id}" PRODUCES 'application/json;charset=utf-8'

//"Exclusão da batida do espelho do ponto"
WSMETHOD DELETE deleteClocking DESCRIPTION EncodeUTF8("Exclusão da batida do espelho do ponto") ;   //-- Include
PATH "/clocking/{employeeId}/{id}" PRODUCES 'application/json;charset=utf-8'


END WSRESTFUL


WSMETHOD GET GetClockTypes PATHPARAM employeeId WSREST Timesheet

Local cJsonObj 		:= "JsonObject():New()"
Local oItemData		:= &cJsonObj
Local oItem			:= &cJsonObj
Local oAllowType	:= &cJsonObj
Local aData			:= {}
Local cToken	 	:= ""
Local cMatSRA		:= ""
Local cBranchVld	:= ""
Local nLenParms	:= Len(::aURLParms)

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken  := Self:GetHeader('Authorization')

cMatSRA	 	 := GetRegisterHR(cToken)
cBranchVld 	 := GetBranch(cToken)

If Empty(cMatSRA) .Or. Empty(cBranchVld)

Else
	aData := fGetClockType(cBranchVld)
EndIf

oItem["items"] 	  := aData
oItem["hasNext"]  := .F.

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
// Retorna o arquivo PDF do espelho do ponto
// -------------------------------------------------------------------
WSMETHOD GET gFileClocking PATHPARAM employeeId WSREST Timesheet

Local oFile			:= Nil
Local cJsonObj 		:= "JsonObject():New()"
Local oItemData		:= &cJsonObj
Local oItem			:= &cJsonObj
Local cToken	 	:= ""
Local cMatSRA		:= ""
Local cBranchVld	:= ""
Local cPer			:= ""
Local cArqLocal		:= ""
Local cFileName		:= ""
Local cFile			:= ""
Local cMsg			:= ""
Local nCont			:= 0
Local lContinua		:= .T.
Local lRet			:= .T.

DEFAULT Self:initPeriod	:= ""
DEFAULT Self:endPeriod	:= ""

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken  := Self:GetHeader('Authorization')

cMatSRA	 	 := GetRegisterHR(cToken)
cBranchVld 	 := GetBranch(cToken)

If !Empty(cMatSRA) .And. !Empty(cBranchVld)

	//Posiciona a tabela SRA na matricula que esta sendo impressa
	dbSelectArea("SRA")
	dbSetOrder(1)
	If dbSeek( cBranchVld + cMatSRA )
	
	    cFileName 	:= AllTrim(cBranchVld) + "_" + AllTrim(cMatSRA)
	    cArqLocal 	:= GetSrvProfString ("STARTPATH","") + cFileName + ".PDF"
	
		//Se nao vier o periodo na requisicao considera o que estiver aberto no ponto
		If Empty(Self:initPeriod) .Or. Empty(Self:endPeriod) 
			aPeriods := GetPerAponta( 1, cBranchVld , cMatSRA, .F.)
			If Len(aPeriods) > 0
				cPer	:= dToS( aPeriods[1,1] ) + dToS( aPeriods[1,2] ) //Ex.: 2019070120190731 
			EndIf
		Else
			cPer := dToS( CtoD( Format8601( .T., Self:initPeriod) ) ) 
			cPer += dToS( CtoD( Format8601( .T., Self:endPeriod) ) )
		EndIf
	
		//Valida se a admissao eh inferior ao final do periodo do ponto que esta aberto
		If !Empty(cPer) .And. Len(cPer) >= 16
			lContinua := dToS( SRA->RA_ADMISSA ) < SubStr( cPer, 9, 8 )
			cMsg := STR0044 //"O funcionario foi admitido em data superior ao período aberto do Ponto Eletrônico" 
		EndIf

		If lContinua
	
			//Faz a geracao do arquivo PDF
			PONR010( .T., cBranchVld, cMatSRA, cPer, , {}, .T. )
		
		    //Avalia o arquivo gerado no servidor
		    While lContinua
			    
			    If File( cArqLocal )
		    		oFile := FwFileReader():New(cArqLocal)
		    		
		    		If (oFile:Open())
				    	cFile := oFile:FullRead()
				        oFile:Close()
				        fErase(cArqLocal)		    		
		    		EndIf
			    EndIf
		
			    //Em determinados ambientes pode ocorrer demora na geracao do arquivo, entao tentar localizar por 5 segundos no maximo.
			    If ( lContinua := Empty(cFile) .And. nCont <= 4 )
			    	nCont++
			    	Sleep(1000)
			    	conout( EncodeUTF8(">>>"+ STR0042 +"("+ cValToChar(nCont) +")") ) //"Aguardando a geracao do espelho do ponto..."
			    EndIf
		    End
	    
		    cMsg := If( Empty(cFile), STR0045, "" ) //"Durante o processamento ocorreram erros que impediram a gravação dos dados. Tente novamente mais tarde." 
	    
		EndIf    

    EndIf

	If Empty( cFile )
		fPDFMakeFileMessage( cMsg, cFileName, @cFile ) 
	EndIf  

	::SetHeader("Content-Disposition", "attachment; filename=" + cFileName + ".PDF")
	::SetResponse(cFile)
	
EndIf

Return( lRet )


WSMETHOD POST SetClocking PATHPARAM employeeId WSREST Timesheet
    Local aUrlParam     := ::aUrlParms
    Local cBody 			:= ::GetContent()
    Local cJsonObj		:= "JsonObject():New()"
    Local oItem			:= &cJsonObj
    Local oItemDetail		:= &cJsonObj
    Local cToken			:= ""
    Local cStatus		:= ""
    Local cMsgLog       := ""
    Local lRet          := .T.
    Local cJson         := ""

    ::SetHeader('Access-Control-Allow-Credentials' , "true")
    cToken := Self:GetHeader('Authorization')

    lRet := fSetClocking(aUrlParam,DecodeUTF8(cBody),@cJsonObj,@oItem,@oItemDetail,cToken,@cStatus,@cMsgLog)
    If lRet
        If !Empty(cStatus)
            ::SetHeader('Status', cStatus)
        EndIf
        cJson := FWJsonSerialize(oItem, .F., .F., .T.)
        ::SetResponse(cJson)
    Else
        SetRestFault(500, EncodeUTF8(cMsgLog))
    EndIf
Return lRet


Function fSetClocking(aUrlParam,cBody,cJsonObj,oItem,oItemDetail,cToken,cStatus,cMsgLog)
    Local cApprover				:= ""
    Local cVision	 			:= ""
    Local cEmpApr				:= ""
    Local cFilApr				:= ""
    Local nSupLevel				:= 0
    Local aVision				:= {}
    Local aGetStruct			:= {}
    Local aMSToHour 			:= Array(02)
    Local cJson					:= ""
    Local cTypeReq				:= "Z"
    Local cRoutine				:= "W_PWSA400.APW" //Marcação de Ponto: Utilizada para buscar a VISÃO a partir da rotina; (AI8_VISAPV) na função GetVisionAI8().
    Local cMsgReturn 			:= EncodeUTF8(STR0029) //"Dados atualizados com sucesso."
    Local cBranchVld			:= FwCodFil()
    Local oRequest				:= Nil
    Local oAttendControlRequest	:= Nil
    Local lRet                  := .T.
    Local cEntSai               := ""
    Local cAllJustify           := ""
    Local cAllReason            := ""
    Local aTrab                 := {}
    Local nA                    := 0

    Default aUrlParam			:= {}
    Default cBody				:= ""
    Default cJsonObj			:= "JsonObject():New()"
    Default oItem 	 			:= &cJsonObj
    Default oItemDetail			:= &cJsonObj
    Default cToken				:= ""
    Default cStatus				:= ""
    Default cMsgLog             := ""

    oRequest					:= WSClassNew("TRequest")
    oRequest:RequestType		:= WSClassNew("TRequestType")
    oRequest:Status				:= WSClassNew("TRequestStatus")
    oAttendControlRequest		:= WSClassNew("TAttendControl")

    cMatSRA	 					:= GetRegisterHR(cToken)
    cBranchVld 					:= GetBranch(cToken)
    cRD0Cod    					:= GetCODHR(cToken)

    If !Empty(cBody)
        oItemDetail:FromJson(cBody)
        
        //Em a justificativa tiver sido informada para todas as batidas 
        cAllJustify := If(oItemDetail:hasProperty("justify"),oItemDetail["justify"],"")
        cAllReason  := If(oItemDetail:hasProperty("reason"),oItemDetail["reason"],"")
        
        If oItemDetail:hasProperty("clockings") .And. ValType(oItemDetail["clockings"]) == "A"
            For nA := 1 To len(oItemDetail["clockings"])
                AAdd(aTrab,{;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("hour"),oItemDetail["clockings"][nA]["hour"]," "),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("date"),oItemDetail["clockings"][nA]["date"]," "),;
                    Iif(!Empty(cAllJustify), cAllJustify, Iif(oItemDetail["clockings"][nA]:hasProperty("justify"),oItemDetail["clockings"][nA]["justify"]," ")),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("referenceDate"),oItemDetail["clockings"][nA]["referenceDate"]," "),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("direction"),oItemDetail["clockings"][nA]["direction"]," "),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("origin"),oItemDetail["clockings"][nA]["origin"]," "),;
                    Iif(!Empty(cAllReason), cAllReason, Iif(oItemDetail:hasProperty("reason"),oItemDetail["reason"]," "));                    
                })
            Next nA
        Else
            AAdd(aTrab,{;
                Iif(oItemDetail:hasProperty("hour"),oItemDetail["hour"]," "),;
                Iif(oItemDetail:hasProperty("date"),oItemDetail["date"]," "),;
                Iif(oItemDetail:hasProperty("justify"),oItemDetail["justify"]," "),;
                Iif(oItemDetail:hasProperty("referenceDate"),oItemDetail["referenceDate"]," "),;
                Iif(oItemDetail:hasProperty("direction"),oItemDetail["direction"]," "),;
                Iif(oItemDetail:hasProperty("origin"),oItemDetail["origin"]," "),;
                Iif(oItemDetail:hasProperty("reason"),oItemDetail["reason"]["id"]," ");
            })
        EndIf
        
        //-- Verifica se o campo motivo foi informado
        If !Empty(aTrab[1][7])
            // ----------------------------------------------
            // - A Função GetVisionAI8() devolve por padrão
            // - Um Array com a seguinte estrutura:
            // - aVision[1][1] := "" - AI8_VISAPV
            // - aVision[1][2] := 0  - AI8_INIAPV
            // - aVision[1][3] := 0  - AI8_APRVLV
            // - Por isso as posição podem ser acessadas
            // - Sem problemas, ex: cVision := aVision[1][1]
            // ----------------------------------------------
            aVision := GetVisionAI8(cRoutine, cBranchVld)
            cVision := aVision[1][1]

            // -------------------------------------------------------------------------------------------
            // - Efetua a busca dos dados referentes a Estrutura Oreganizacional dos dados da solicitação.
            //- -------------------------------------------------------------------------------------------
            aGetStruct := APIGetStructure(cRD0Cod, SUPERGETMV("MV_ORGCFG"), cVision, cBranchVld, cMatSRA, , , ,cTypeReq , cBranchVld, cMatSRA )

            If Len(aGetStruct) >= 1 .And. !(Len(aGetStruct) == 3 .And. !aGetStruct[1])
                cEmpApr   := aGetStruct[1]:ListOfEmployee[1]:SupEmpresa
                cFilApr   := aGetStruct[1]:ListOfEmployee[1]:SupFilial
                nSupLevel := aGetStruct[1]:ListOfEmployee[1]:LevelSup
                cApprover := aGetStruct[1]:ListOfEmployee[1]:SupRegistration
            EndIf

            If Len(aTrab) > 0
                For nA := 1 To Len(aTrab)
                    aMsToHour	:= milisSecondsToHour(aTrab[nA][1],aTrab[nA][1])
                    //-- Verifica se data da batida é menor/igual data atual
                    If cTod(Format8601(.T.,aTrab[nA][2])) <= dDataBase
                        oRequest:Branch						:= cBranchVld
                        oRequest:StarterBranch				:= cBranchVld
                        oRequest:StarterRegistration		:= cMatSRA
                        oRequest:Registration				:= cMatSRA
                        oRequest:ApproverBranch				:= cFilApr
                        oRequest:ApproverRegistration		:= cApprover
                        oRequest:EmpresaAPR					:= cEmpApr
                        oRequest:Empresa					:= cEmpAnt
                        oRequest:ApproverLevel				:= nSupLevel
                        oRequest:Vision						:= cVision

                        oAttendControlRequest:Branch  		:= cBranchVld
                        oAttendControlRequest:Registration	:= cMatSRA
                        oAttendControlRequest:Name			:= Alltrim(Posicione('SRA',1,cBranchVld+cMatSRA,'SRA->RA_NOME'))
                        oAttendControlRequest:EntryExit     := Iif(Alltrim(aTrab[nA][5])=="entry","Entrada","Saída")
                        oAttendControlRequest:Observation  	:= GetMotDesc(aTrab[nA][7])
                        oAttendControlRequest:Motive        := aTrab[nA][3]
                        oAttendControlRequest:Date			:= Format8601(.T.,aTrab[nA][2])
                        oAttendControlRequest:Hour			:= cValToChar(aMsToHour[1])

                        AddAttendControlRequest(oRequest, oAttendControlRequest, .T., @cMsgReturn, STR0038 ) //"MEURH"
                    Else
                        cMsgLog := STR0024
                        lRet    := .F.
                        Exit
                    EndIf
                Next nA
            EndIf
        Else
            cMsgLog := STR0030 //"O campo 'Motivo' deve ser informado!"
            lRet    := .F.
        EndIf
    EndIf

Return lRet


WSMETHOD GET GetOccurrences PATHPARAM employeeId WSREST Timesheet

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local oItemDetail	:= &cJsonObj
Local aData			:= {}
Local aDateGMT		:= ""
Local aEventos		:= {}
Local aArea			:= {}
Local cJson			:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local cMatSRA		:= ""
Local nX			:= 0
Local nSaldo		:= 0
Local lSexagenal	:= .T. //SuperGetMv("MV_HORASDE",, "N") == "S" //Desabilitado porque o App existe somente sexagenal

DEFAULT Self:referenceDate	:= Ctod("//")

Self:SetHeader('Access-Control-Allow-Credentials' , "true")

If !Empty(Self:referenceDate)
	
	cToken		:= Self:GetHeader('Authorization')
	cBranchVld	:= GetBranch(cToken)
	cMatSRA		:= GetRegisterHR(cToken)
	
	aEventos := fSumOccurPer( cBranchVld, cMatSRA, Self:referenceDate, Self:referenceDate, lSexagenal )
	
	If !Empty(aEventos)
		
		For nX := 1 To Len(aEventos)
			nSaldo := aEventos[nX,3]
			nSaldo := If( lSexagenal, nSaldo, fConvHr( nSaldo, "D", .T., 2 ) )
			oItemDetail	:= &cJsonObj
			oItemDetail["id"] 				:= cValToChar(nX)
			oItemDetail["date"] 			:= Self:referenceDate
			oItemDetail["referenceDate"]	:= Self:referenceDate
			oItemDetail["total"]			:= HourToMs( StrZero(nSaldo,4,2) ) 
			oItemDetail["description"] 		:= EncodeUTF8(aEventos[nX,2])
			aAdd( aData, oItemDetail )				
		Next nX

	EndIf
	
EndIf

oItem["hasNext"] 	:= CtoD( Format8601(.T.,Self:initPeriod) )
oItem["items"]		:= aData

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)


WSMETHOD GET GetTotSummPeriod PATHPARAM employeeId WSREST Timesheet

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local oItemDetail	:= &cJsonObj
Local aData			:= {}
Local aEventos		:= {}
Local cJson			:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local cMatSRA		:= ""
Local nX			:= 0
Local nSaldo		:= 0
Local lSexagenal	:= .T. //SuperGetMv("MV_HORASDE",, "N") == "S" //Desabilitado porque o App existe somente sexagenal

DEFAULT Self:initPeriod	:= ""
DEFAULT Self:endPeriod	:= ""

Self:SetHeader('Access-Control-Allow-Credentials' , "true")

If !Empty(Self:initPeriod) .And. !Empty(Self:endPeriod)
	
	cToken		:= Self:GetHeader('Authorization')
	cBranchVld	:= GetBranch(cToken)
	cMatSRA		:= GetRegisterHR(cToken)
	
	aEventos := fSumOccurPer( cBranchVld, cMatSRA, Self:initPeriod, Self:endPeriod, lSexagenal )
	
	If !Empty(aEventos)
		
		For nX := 1 To Len(aEventos)
			nSaldo := aEventos[nX,3]
			nSaldo := If( lSexagenal, nSaldo, fConvHr( nSaldo, "D", .T., 2 ) )
			oItemDetail	:= &cJsonObj
			oItemDetail["id"] 			:= cValToChar(nX)
			oItemDetail["description"] 	:= EncodeUTF8(aEventos[nX,2])
			oItemDetail["value"]		:= StrTran( StrZero(nSaldo,5,2), ".", ":" ) 
			aAdd( aData, oItemDetail )				
		Next nX

	EndIf
	
EndIf

oItem["initPeriod"] 				:= CtoD( Format8601(.T.,Self:initPeriod) )
oItem["endPeriod"]  				:= CtoD( Format8601(.T.,Self:endPeriod) )
oItem["occurrencesTotalSummary"]	:= aData

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
Self:SetResponse(cJson)

Return(.T.)


WSMETHOD GET GetBalanceSummary PATHPARAM employeeId WSREST Timesheet

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local aData			:= {}
Local aEventos		:= {}
Local aPeriods		:= {}
Local cJson			:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local cMatSRA		:= ""
Local cIniPer		:= ""
Local cFimPer		:= ""
Local nX			:= 0
Local nSaldo		:= 0

::SetHeader('Access-Control-Allow-Credentials' , "true")

DEFAULT Self:initPeriod	:= ""
DEFAULT Self:endPeriod	:= ""

cToken		:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)
cMatSRA		:= GetRegisterHR(cToken)

If !Empty(cBranchVld) .And. !Empty(cMatSRA)

	//Se nao vier o periodo na requisicao considera o que estiver aberto no ponto
	If Empty(Self:initPeriod) .Or. Empty(Self:endPeriod) 
		aPeriods := GetPerAponta( 1, cBranchVld , cMatSRA, .F.)
		If Len(aPeriods) > 0
			cIniPer := dToS( aPeriods[1,1] )
			cFimPer := dToS( aPeriods[1,2] )
		EndIf
	Else
		cIniPer := Self:initPeriod
		cFimPer := Self:endPeriod		
	EndIf
	
	aEventos := fBalanceSumPer( cBranchVld, cMatSRA, cIniPer, cFimPer, .T. )
	
	If !Empty(aEventos)
		oItem["previous"] := HourToMs( cValToChar( Abs(aEventos[1]) ) ) * If( aEventos[1] > 0, 1, -1 )
		oItem["current"]  := HourToMs( cValToChar( Abs(aEventos[3]) ) ) * If( aEventos[3] > 0, 1, -1 )
		oItem["next"] 	  := HourToMs( cValToChar( Abs(aEventos[2]) ) ) * If( aEventos[2] > 0, 1, -1 )
	EndIf
	
EndIf

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)


WSMETHOD GET GetPeriods PATHPARAM employeeId WSREST Timesheet

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local oItemDetail	:= &cJsonObj
Local oMessages	  	:= &cJsonObj
Local nLenParms	 	:= Len(::aURLParms)
Local cMatSRA		:= ""
Local cBranchVld	:= ""
Local cToken	  	:= ""
Local aDateGMT		:= ""
Local lAuth    		:= .T.
Local aData			:= {}
Local aPeriods		:= {}
Local aMessages		:= {}
Local initPeriod    := Ctod("//")
Local endPeriod     := Ctod("//")
Local nPer			:= 0
Local nX			:= 0

cToken  := Self:GetHeader('Authorization')

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)

If Empty(cMatSRA) .Or. Empty(cBranchVld)

	oMessages["type"]   := "error"
	oMessages["code"]   := "401"
	oMessages["detail"] := EncodeUTF8(STR0006) //"Dados inválidos."

	Aadd(aMessages,oMessages)
	lAuth := .F.

EndIf

aPeriods	:= GetPeriodApont(cBranchVld,,6)//GetPerAponta( nNumPerAnt , cBranchVld , cMatSRA, lReturn)
nPer		:= Len(aPeriods)

For nX := 1 To nPer

	oItemDetail					:= &cJsonObj
	initPeriod 					:= aPeriods[nX,1]
	endPeriod   				:= aPeriods[nX,2]

	aDateGMT 			  		:= LocalToUTC( DTOS(initPeriod), "12:00:00" )
	oItemDetail["initDate"]		:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")
	aDateGMT 					:= {}

	aDateGMT 		  			:= LocalToUTC( DTOS(endPeriod), "12:00:00" )
	oItemDetail["endDate"]		:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")
	oItemDetail["actualPeriod"]	:= nX == nPer

	aAdd( aData, oItemDetail )

Next nX

oItem["items"] 	  := aData
oItem["hasNext"]  := .F.

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)


WSMETHOD GET GetAllowances WSREST Timesheet

Local cJsonObj 	:= "JsonObject():New()"
Local oItemData	:= &cJsonObj
Local oItem		:= &cJsonObj
Local oAllowType	:= &cJsonObj
Local aData		:= {}
Local cToken	 	:= ""
Local cMatSRA		:= ""
Local cBranchVld	:= ""
Local nLenParms	:= Len(::aURLParms)

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken  := Self:GetHeader('Authorization')

cMatSRA	 	 := GetRegisterHR(cToken)
cBranchVld 	 := GetBranch(cToken)

If !Empty(Self:aURLParms[1]) .And. Self:aURLParms[1] == "allowancesTypes"
	GetAllowances(cJsonObj,oItemData,oAllowType,@aData,cBranchVld,cMatSRA)
EndIf

oItem["items"] 	  := aData
oItem["hasNext"]  := .T.

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)

/*/{Protheus.doc}GetAllowances
@author:	Matheus Bizutti
@since:		18/08/2017
/*/
Function GetAllowances(cJsonObj,oItemData,oAllowType,aData,cBranchVld,cMatSRA)

Local cQuery   := GetNextAlias()
Local cBrchSP6 := ""
Local aProps   := {}
Local oProps   := Nil

Default cJsonObj	:= "JsonObject():New()"
Default oItemData	:= &cJsonObj
Default oAllowType	:= &cJsonObj
Default aData		:= {}
Default cBranchVld	:= FwCodFil()
Default cMatSRA		:= ""

cBrchSP6 := xFilial("SP6", cBranchVld)
oProps   := &cJsonObj

BEGINSQL ALIAS cQuery

	SELECT *
	FROM
		%Table:SP6% SP6
	WHERE
		SP6.P6_FILIAL = %Exp:cBrchSP6% AND
		SP6.%NotDel%
ENDSQL

If !Empty(cQuery)
	While !(cQuery)->(Eof())

	If (cQuery)->P6_PREABO == "S"
		oAllowType := &cJsonObj
		oProps     := &cJsonObj

		oAllowType["id"]  		  := EncodeUTF8((cQuery)->P6_CODIGO)
		oAllowType["description"] := EncodeUTF8((cQuery)->P6_DESC)
		oAllowType["type"]        := "hour"

		oProps["field"] 	:= "totalHour"
		oProps["visible"] 	:= .F.
		oProps["editable"] 	:= .F.
		oProps["required"] 	:= .F.

		Aadd(aProps,oProps)
		oProps     := &cJsonObj

		oProps["field"] 	:= "initHour"
		oProps["visible"] 	:= .T.
		oProps["editable"] 	:= .T.
		oProps["required"] 	:= .T.

		Aadd(aProps,oProps)
		oProps     := &cJsonObj

		oProps["field"] 	:= "endHour"
		oProps["visible"] 	:= .T.
		oProps["editable"] 	:= .T.
		oProps["required"] 	:= .T.

		Aadd(aProps,oProps)
		oProps     := &cJsonObj

		oProps["field"] 	:= "justify"
		oProps["visible"] 	:= .T.
		oProps["editable"] 	:= .T.
		oProps["required"] 	:= .T.

		Aadd(aProps,oProps)
		oProps     := &cJsonObj

		oAllowType["props"]		  := aProps

		aAdd(aData, oAllowType)
		oAllowType := Nil

	EndIf
	(cQuery)->(dbSkip())

	EndDo
EndIf

(cQuery)->(dbCloseArea())

Return(Nil)

WSMETHOD POST SetAllowanceRequest PATHPARAM employeeId WSREST Timesheet

Local cBody 			:= ::GetContent()
Local aUrlParam		:= ::aUrlParms
Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oItemDetail		:= &cJsonObj
Local cJson			:= ""
Local cToken			:= ""
Local cStatus		:= ""

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken := Self:GetHeader('Authorization')

AllowanceRequest(aUrlParam,DecodeUTF8(cBody),@cJsonObj,@oItem,@oItemDetail,cToken,@cStatus)

If !Empty(cStatus)
	::SetHeader('Status', cStatus)
EndIf

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return (.T.)

Function AllowanceRequest(aUrlParam,cBody,cJsonObj,oItem,oItemDetail,cToken,cStatus)

Local oMessages		:= Nil
Local oRequest		:= Nil
Local aMessages		:= {}
Local cApprover		:= ""
Local cVision	 	:= ""
Local cEmpApr		:= ""
Local cFilApr		:= ""
Local nSupLevel		:= 0
Local aGetStruct	:= {}
Local cTypeReq		:= "8"
Local aVision		:= {}
Local cRoutine		:= "W_PWSA160.APW" // Justifica de Abono: Utilizada para buscar a VISÃO a partir da rotina; (AI8_VISAPV) na função GetVisionAI8().
Local cReason	 	:= ""
Local cBranchVld	:= FwCodFil()
Local cInitDate		:= ""
Local cEndDate		:= ""
Local cMsgReturn 	:= EncodeUTF8(STR0029) //"Dados atualizados com sucesso."
Local aMSToHour 	:= Array(02)
Local cRD0Cod	 	:= ""
Local lIncAbono		:= .F.
Local oScheduleJustificationRequest := Nil

Default aUrlParam	:= {}
Default cBody		:= ""
Default cJsonObj	:= "JsonObject():New()"
Default oItem 	 	:= &cJsonObj
Default oItemDetail	:= &cJsonObj
Default cToken		:= ""

oMessages 						:= &cJsonObj
oRequest						:= WSClassNew("TRequest")
oRequest:RequestType			:= WSClassNew("TRequestType")
oRequest:Status					:= WSClassNew("TRequestStatus")
oScheduleJustificationRequest	:= WSClassNew("TScheduleJustification")

cMatSRA	 	:= GetRegisterHR(cToken)
cBranchVld 	:= GetBranch(cToken)
cRD0Cod    	:= GetCODHR(cToken)

If !Empty(cBody)

	oItemDetail:FromJson(cBody)

	// ----------------------------------------------
	// - A Função GetVisionAI8() devolve por padrão
	// - Um Array com a seguinte estrutura:
	// - aVision[1][1] := "" - AI8_VISAPV
	// - aVision[1][2] := 0  - AI8_INIAPV
	// - aVision[1][3] := 0  - AI8_APRVLV
	// - Por isso as posição podem ser acessadas
	// - Sem problemas, ex: cVision := aVision[1][1]
	// ----------------------------------------------
	aVision := GetVisionAI8(cRoutine, cBranchVld)
	cVision := aVision[1][1]

	// -------------------------------------------------------------------------------------------
	// - Efetua a busca dos dados referentes a Estrutura Oreganizacional dos dados da solicitação.
	//- -------------------------------------------------------------------------------------------
	 aGetStruct := APIGetStructure(cRD0Cod, SUPERGETMV("MV_ORGCFG"), cVision, cBranchVld, cMatSRA, , , ,cTypeReq , cBranchVld, cMatSRA, ,)

	 If Len(aGetStruct) >= 1 .And. !(Len(aGetStruct) == 3 .And. !aGetStruct[1])
	 	cEmpApr   := aGetStruct[1]:ListOfEmployee[1]:SupEmpresa
	 	cFilApr   := aGetStruct[1]:ListOfEmployee[1]:SupFilial
	 	nSupLevel := aGetStruct[1]:ListOfEmployee[1]:LevelSup
	 	cApprover := aGetStruct[1]:ListOfEmployee[1]:SupRegistration
	 EndIf

	oRequest:Branch 				:= cBranchVld
	oRequest:Registration			:= cMatSRA
	oRequest:Observation 			:= Alltrim(oItemDetail["justify"])
	oRequest:ApproverBranch			:= cFilApr
	oRequest:ApproverRegistration 	:= cApprover
	oRequest:EmpresaAPR				:= cEmpApr
	oRequest:Empresa				:= cEmpAnt
	oRequest:ApproverLevel		    := nSupLevel
	oRequest:Vision					:= cVision

	cReason 						:= Iif(oItemDetail:hasProperty("allowanceType"),oItemDetail["allowanceType"]["id"]," ")

	// --------------------------------
	// - CONVERTE O VALOR QUE VEM EM
	// - DATE TIME ISO 8601 DO CLIENT.
	// --------------------------------
	cInitDate := Iif(oItemDetail:hasProperty("initDate"),Format8601(.T.,oItemDetail["initDate"]),"")
	cEndDate  := Iif(oItemDetail:hasProperty("endDate"),Format8601(.T.,oItemDetail["endDate"]),"")

	aMsToHour := milisSecondsToHour(oItemDetail["initHour"],oItemDetail["endHour"])

	oScheduleJustificationRequest:Reason  		:= cReason
	oScheduleJustificationRequest:InitialDate	:= CToD(cInitDate)
	oScheduleJustificationRequest:FinalDate		:= CToD(cEndDate)
	oScheduleJustificationRequest:InitialTime	:= aMsToHour[1]
	oScheduleJustificationRequest:FinalTime		:= aMsToHour[2]

	//Verifica se não existe abono cadastrado para a mesma data e hora
	lIncAbono := GetJustification( cBranchVld, cMatSRA, CToD(cInitDate), CToD(cEndDate), aMsToHour[1], aMsToHour[2] )

	//Funcao que efetua a gravação da requisição no Protheus.
	If lIncAbono
		AddScheduleJustificationRequest(oRequest, oScheduleJustificationRequest, .T., @cMsgReturn, STR0038 ) //"MEURH"
	Else
		cStatus := "500"
		oItem["code"] 		:= cStatus
		oItem["message"]	:= EncodeUTF8(STR0007) //"Já existe abono cadastrado para essa data/hora"
	EndIf
EndIf

Return(Nil)


WSMETHOD GET clockings PATHPARAM employeeId WSREST Timesheet

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local oMessages	  	:= &cJsonObj
Local nLenParms	 	:= Len(::aURLParms)
Local cMatSRA		:= ""
Local aMessages		:= {}
Local cBranchVld	:= ""
Local lAuth    		:= .T.
Local cToken	  	:= ""
Local aData			:= {}
Local aPeriods		:= {}
Local initPeriod    := CtoD( Format8601(.T.,Self:initPeriod) )
Local endPeriod     := CtoD( Format8601(.T.,Self:endPeriod) )
Local aDateGMT		:= ""

cToken  := Self:GetHeader('Authorization')

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)

If Empty(cMatSRA) .Or. Empty(cBranchVld)

	oMessages["type"]   := "error"
	oMessages["code"]   := "401"
	oMessages["detail"] := EncodeUTF8(STR0006) //"Dados inválidos."

	Aadd(aMessages,oMessages)
	lAuth := .F.

EndIf

If( Empty(initPeriod) .And. Empty(endPeriod) )
	aPeriods	:= GetPeriodApont(cBranchVld,cMatSRA)
	If Len(aPeriods) > 0
		initPeriod 	:= aPeriods[1,1]
		endPeriod   := aPeriods[1,2]
	EndIf
EndIf

If lAuth
	getClockings(cJsonObj,@aData,cBranchVld,cMatSRA,initPeriod,endPeriod)
EndIf

// - Por por padrão todo objeto tem
// - data: contendo a estrutura do JSON
// - messages: para determinados avisos
// - length: informativo sobre o tamanho.
aDateGMT 			  	:= LocalToUTC( DTOS(initPeriod), "12:00:00" )
oItem["initPeriod"]	:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")
aDateGMT := {}

aDateGMT 			  	:= LocalToUTC( DTOS(endPeriod), "12:00:00" )
oItem["endPeriod"]   := Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")
oItem["clockings"]   := aData

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)


Function getClockings(cJsonObj,aData,cBranchVld,cMatSRA,dPerIni,dPerFim)

Local oClockings	:= Nil

Local cAliasMarc		:= "SP8"
Local lGetMarcAuto		:= ( SuperGetMv( "MV_GETMAUT" , NIL , "S" , cFilAnt ) == "S" )
Local nI				:= 0
Local nY				:= 0
Local nA                := 0
Local nCount			:= 0
Local nTamM				:= 0
Local nPos              := 0
Local cJson				:= "JsonObject():New()"
Local cID 				:= ""
Local oStatus 			:= ""
Local cRetStatus		:= ""
Local cLabStatus		:= ""
Local aDateGMT			:= {}
Local aMarcAux			:= {}
Local aSaveMarc			:= {}
Local lRegRS3			:= .F.
Local lValidSeq			:= .T.
Local lPeriodo 			:= dPerIni != dPerFim
Local dLastDt			:= Ctod("//")
Local cQueryAlias 		:= Nil
Local cQuery            := ""
Local aSequen           := {}
Local dAuxIniPer   		:= Ctod("//")
Local dAuxFimPer   		:= Ctod("//")
Local aPeriods			:= {}
Local aMarcGet			:= {}

Private aMarcacoes		:= {}
Private aTabCalend  	:= {}
Private aTabPadrao		:= {}
Private aRecsMarcAutDele:= {}

Default cJsonObj		:= JsonObject():New()
Default aData			:= {}
Default cBranchVld		:= FwCodFil()
Default cMatSRA			:= ""
Default dPerIni     	:= Ctod("//")
Default dPerFim     	:= Ctod("//")

dbSelectArea("SRA")
SRA->(dbSetOrder(1))
If SRA->(dbSeek(cBranchVld+cMatSRA))

	//Verifica se esta sendo solicitado o periodo ou um data especifica
	If lPeriodo
		dAuxIniPer	:= dPerIni
		dAuxFimPer	:= dPerFim
	Else
		aPeriods := GetPerAponta( 1, cBranchVld , cMatSRA, .F.)
		If Len(aPeriods) > 0
			dAuxIniPer := aPeriods[1,1]
			dAuxFimPer := aPeriods[1,2]
		EndIf
	EndIf

	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carrega o Calendario de Marcacoes do Funcionario            ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
	GetMarcacoes(	@aMarcGet			,;	//01 -> Marcacoes do Funcionario
					@aTabCalend			,;	//02 -> Calendario de Marcacoes
					@aTabPadrao			,;	//03 -> Tabela Padrao
					NIL     			,;	//04 -> Turnos de Trabalho
					dAuxIniPer			,;	//05 -> Periodo Inicial
					dAuxFimPer			,;	//06 -> Periodo Final
					SRA->RA_FILIAL		,;	//07 -> Filial
					SRA->RA_MAT			,;	//08 -> Matricula
					SRA->RA_TNOTRAB		,;	//09 -> Turno
					SRA->RA_SEQTURN		,;	//10 -> Sequencia de Turno
					SRA->RA_CC			,;	//11 -> Centro de Custo
					cAliasMarc			,;	//12 -> Alias para Carga das Marcacoes
					.T.					,;	//13 -> Se carrega Recno em aMarcacoes
					.T.		 			,;	//14 -> Se considera Apenas Ordenadas
					NIL					,;  //15 -> Verifica as Folgas Automaticas
					NIL  				,;  //16 -> Se Grava Evento de Folga Mes Anterior
					lGetMarcAuto		,;	//17 -> Se Carrega as Marcacoes Automaticas
					@aRecsMarcAutDele	,;	//18 -> Registros de Marcacoes Automaticas que deverao ser Deletados
					NIL					,;	//19
					NIL					,;	//20
					NIL					,;	//21
					NIL					,;	//22
					.T.					,;	//23 -> Se carrega as marcacoes das duas tabelas SP8 e SPG
					)

	//Quando for uma data especifica considera somente as marcacoes dessa data
	If lPeriodo
		aMarcacoes := aClone( aMarcGet )
	ElseIf !Empty(aMarcGet)
		For nA := 1 To Len(aMarcGet)
			If aMarcGet[nA][1] == dPerIni
				Aadd(aMarcacoes, aMarcGet[nA])
			EndIf
		Next nA
	EndIf
	
	cQueryAlias := GetNextAlias()

	BEGINSQL ALIAS cQueryAlias
		SELECT RS3_DATA, RS3_HORA, RS3_STATUS, RS3_JUSTIF, RS3_CODIGO, RH3_STATUS, RS3_FILIAL
		FROM %table:RS3% RS3
		INNER JOIN %table:RH3% RH3 ON
			RS3_FILIAL = RH3_FILIAL AND
			RS3_CODIGO = RH3_CODIGO
		WHERE RS3_FILIAL = %exp:SRA->RA_FILIAL% AND
		RS3_MAT = %exp:SRA->RA_MAT% AND
		RS3_DATA >= %exp:DtoS(dPerIni)% AND
		RS3_DATA <= %exp:DtoS(dPerFim)% AND
		RS3.%notDel% AND RH3.%notDel%
		ORDER BY RS3_FILIAL, RS3_MAT, RS3_DATA, RS3_HORA
	ENDSQL

	While (cQueryAlias)->(!Eof())

		(cQueryAlias)->( aAdd( aMarcAux,{ ;
										StoD(RS3_DATA),;
										RS3_HORA,;
										If(RS3_STATUS=="0","P",If(RS3_STATUS=="2","R","A")),;
										RS3_JUSTIF,;
										RS3_CODIGO,;
										RH3_STATUS,;
                                        If(RH3_STATUS $ "2|1|4","01","99") }))
		(cQueryAlias)->(DbSkip())
	EndDo

	(cQueryAlias)->(DbCloseArea())

	nTamM	:= Len(aMarcacoes)

	For nY := 1 To nTamM
		//Ignora marcacoes desconsideradas e incluidas pelo portal, esta última ja foi carregada da tabela RS3
		If aMarcacoes[ nY, 27 ] <> "D" .and. !(aMarcacoes[ nY , 04] == "P")
			//Utiliza a posicao 7 (Funcao do Relogio) para controle de ordenacao porque esse dado nao eh usado no MeuRH
			aMarcacoes[ nY, 7 ] := "01"
			aAdd(aMarcAux, aMarcacoes[nY] )
		EndIf
	Next nY

	aSort(aMarcAux,,,{|x,y| DtoS(x[1])+ x[7]+ StrTran(StrZero(x[2],5,2),".", ":") < DtoS(y[1])+ y[7]+ StrTran(StrZero(y[2],5,2),".", ":") })
	aSaveMarc := aClone(aMarcacoes)
	aMarcacoes := aClone(aMarcAux)

EndIf

For nI := 1 To Len(aMarcacoes)

	lRegRS3 := aMarcacoes[nI, 03] $ "*P*A*R*"
	cID     := cValToChar(nI) + Iif(lRegRS3,"|"+aMarcacoes[nI, 05],"")

	oClockings := &cJson

	oClockings["id"]			:= cID

	aDateGMT 					:= LocalToUTC( DTOS(aMarcacoes[nI][1]), "12:00:00" )
	oClockings["date"]			:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")
	aDateGMT := {}

	oClockings["origin"] 		:= fRetTpFlag( aMarcacoes[nI][4], lRegRS3 )

	aDateGMT 					:= LocalToUTC( Iif(!lRegRS3 .And. !Empty(aMarcacoes[nI][25]),DTOS(aMarcacoes[nI][25]), DTOS(aMarcacoes[nI][1])), "12:00:00" )
	oClockings["referenceDate"] := Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")
	aDateGMT := {}

	oClockings["hour"]			:= HourToMs(strZero(aMarcacoes[nI][2], 5, 2))

	//Controle de direcao e sequencia da batida (sequencia por pares)
	//1E e 1S ==> sequencia 1,1 respectivamente (sequencia por pares)
	//2E e 2S ==> sequencia 2,2 respectivamente
	If !dLastDt == aMarcacoes[nI, 01]
		nCount  := 1
		aSequen := {}
		aAdd( aSequen, { "1", "" } )
	Else
		nCount ++
		nPos   := Len( aSequen )
		
	 	If Empty( aSequen[nPos,2] )
	 		aSequen[nPos,2] := "1"
	 	Else
	 		aAdd( aSequen, { "1", "" } )
	 	EndIf
	EndIf
	
	oClockings["direction"]	:= If( nCount % 2 == 0, "exit", "entry" )
	oClockings["sequence"]  := Len( aSequen )
	
    If lRegRS3
		//Solicitacao em processo de aprovacao
		If !(aMarcacoes[nI, 06] == "3")
			Do Case
				Case aMarcacoes[nI, 03] == "P"
					cRetStatus	:= "approving"
					cLabStatus	:= STR0013 //"Aguardando aprovação"
				Case aMarcacoes[nI, 03] == "A"
					cRetStatus	:= "approved"
					cLabStatus	:= STR0014 //"Aprovada"
			End Case
		Else
			//Somente as solicitacoes reprovadas pelo gestor ficam demonstradas no App
			cRetStatus	:= "reproved"
			cLabStatus	:= STR0015 //"Reprovada"
		EndIf
	Else
		//Incluido status para todas as demais marcacoes para desabilitar as opcoes de edicao
		cRetStatus	:= "approved"
		cLabStatus	:= STR0014 //"Aprovada"
	EndIf
	
	oStatus := &cJson
	oStatus["id"]        := cID
	oStatus["status"]    := EncodeUTF8(cRetStatus)
	oStatus["label"]     := EncodeUTF8(cLabStatus)
	oClockings["status"] := oStatus	

	dLastDt	:= aMarcacoes[nI, 01]

	Aadd(aData,oClockings)

Next nI

Return(Nil)

/*/{Protheus.doc} fRetTpFlag
Retorna a descrição do tipo da marcação conforme o Flag
@author:	Marcelo Silveira
@since:		04/04/2019
@param:		cFlag - Flag da marcacao;
			lRS3 - Verdadeiro se a marcacao foi incluida pelo App;
@return:	cRet - descricao do tipo da marcacao conforme o flag.
/*/
Static Function fRetTpFlag( cFlag, lRS3 )

Local cRet := "empty"

DEFAULT cFlag := ""
DEFAULT lRS3  := .F.

//Tipo da marcação conforme o Flag
If !Empty(cFlag)

	//Quando incluída via App o tipo sempre será manual
	If lRS3 .And. Len(cFlag) > 1
		cRet := "manual"
	Else
		Do Case
			Case cFlag $ "E"
				 cRet := "clock" 	//Lidas e gravadas através do relógio.
			Case cFlag $ "I"
				cRet := "manual" 	//Informadas (manual)
			Case cFlag $ "A|G"
				cRet := "automatic" //Automática ou Gerada.
			OtherWise
				cRet := "empty"
		End Case
	EndIf
EndIf

Return(cRet)

/*/{Protheus.doc} GetPeriodApont
Retorna os periodos de apontamento
@author:	Matheus Bizutti
@since:		12/04/2017
@param:		cBranchVld - Filial;
			cMatSRA - Matricula;
			nNumPer - Numero de períodos que serao retornados;
@return:	Array - periodos de apontamento.
/*/
Static Function GetPeriodApont(cBranchVld, cMatSRA, nNumPer)
	Default cBranchVld := FwCodFil()
	Default cMatSRA	   := Nil
	Default nNumPer	   := 1
Return GetPerAponta( nNumPer , cBranchVld , cMatSRA, .F.)


/*/{Protheus.doc}GetJustification
Verifica se ja existe abono cadastrado para o dia o funcionario no dia/hora informado
@author:	Marcelo Silveira
@since:		18/02/2019
@param:		cFilSra - Filial;
			cMatSra - Matrícula;
			cInitDate - Data inícial do Abono;
			cEndDate - Data final do Abono;
			cInitHour - Hora inicial do Abono
			cEndHour - Hora final do Abono;
@return:	lRet - Se não tiver abono cadastrado será verdadeiro.
/*/
Static Function GetJustification( cFilSra, cMatSra, cInitDate, cEndDate, cInitHour, cEndHour )

Local cAliasQry  := GetNextAlias()
Local cAliasAux1 := GetNextAlias()
Local lRet 	   	 := .T.
Local nHorIni	 := ''
Local nHorFim    := ''
Local dDataIni	 := ''
Local dDataFim	 := ''

BeginSql alias cAliasQry
	SELECT RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH3.RH3_STATUS
	FROM  %table:RH3% RH3
	WHERE
		RH3.RH3_FILIAL = %exp:cFilSra% AND
		RH3.RH3_MAT = %exp:cMatSra% AND
    	RH3.RH3_TIPO = '8' AND
		RH3.%notDel% AND
		RH3.RH3_STATUS != '3'
EndSql

While !(cAliasQry)->(Eof())

	BeginSql alias cAliasAux1
		SELECT *
		FROM  %table:RH4% RH4
		WHERE
			RH4.RH4_CODIGO = %exp:(cAliasQry)->RH3_CODIGO% AND
			(RH4.RH4_CAMPO = "RF0_DTPREI" OR
			 RH4.RH4_CAMPO = "RF0_DTPREF" OR
			 RH4.RH4_CAMPO = "RF0_HORINI" OR
			 RH4.RH4_CAMPO = "RF0_HORFIM") AND
			RH4.%notDel%
	EndSql

	dDataIni	:= ''
	dDataFim	:= ''
	nHorIni	    := ''
	nHorFim	    := ''
	While !(cAliasAux1)->(Eof())
		If (cAliasAux1)->RH4_CAMPO = "RF0_DTPREI"
			dDataIni := CTOD((cAliasAux1)->(RH4_VALNOV))
		EndIf
		If (cAliasAux1)->RH4_CAMPO = "RF0_DTPREF"
			dDataFim := CTOD((cAliasAux1)->(RH4_VALNOV))
		EndIf
		If (cAliasAux1)->RH4_CAMPO = "RF0_HORINI"
			nHorIni := Val((cAliasAux1)->(RH4_VALNOV))
		EndIf

		If (cAliasAux1)->RH4_CAMPO = "RF0_HORFIM"
			nHorFim := Val((cAliasAux1)->(RH4_VALNOV))
		EndIf

		(cAliasAux1)->(DBSkip())

	Enddo

	If (cInitDate >= dDataIni .AND. cEndDate <= dDataFim) .OR. ;
	   (cEndDate >= dDataIni .AND. cEndDate <= dDataFim)
		If (cInitHour >= nHorIni .AND. cInitHour <= nHorFim) .OR. ;
		   (cEndHour > nHorIni .AND. cEndHour <= nHorFim)
			lRet := .F.
			(cAliasAux1)->(DBCloseArea())
			Exit
		EndIf
	EndIf
	(cAliasAux1)->(DBCloseArea())

	(cAliasQry)->(DBSkip())
Enddo
(cAliasQry)->(DBCloseArea())

Return(lRet)


/*/{Protheus.doc} fGetClockType
Carrega os motivos para inclusao de marcacao manual
@author:	Marcelo Silveira
@since:		18/02/2019
@param:		cBranchVld - Filial;
			aData - Matriz de referencia para retorno dos dados;
@return:	Nulo
/*/
Function fGetClockType(cBranchVld, cType)

Local cAlias		:= GetNextAlias()
Local cJsonObj		:= "JsonObject():New()"
Local cBrchRFD		:= ""
Local oClockType	:= Nil
Local aData         := {}

Default cBranchVld	:= FwCodFil()
Default cType       := "1"

cBrchRFD := xFilial("RFD", cBranchVld)

//Somente marcacoes e para inclusao - Aplicacao/Tipo = 1
BEGINSQL ALIAS cAlias
	SELECT RFD_CODIGO, RFD_DESC
	    FROM %Table:RFD% RFD
	   WHERE RFD.RFD_FILIAL = %Exp:cBrchRFD%
         AND RFD.RFD_APLIC  = '1'
         AND RFD.RFD_TIPO   = %Exp:cType%
         AND RFD.%NotDel%
ENDSQL

If !Empty(cAlias)
	While !(cAlias)->(Eof())

        oClockType 					:= &cJsonObj
        oClockType["id"]			:= EncodeUTF8((cAlias)->RFD_CODIGO)
        oClockType["description"]	:= EncodeUTF8( AllTrim((cAlias)->RFD_DESC) )

        aAdd(aData, oClockType)
        oClockType := Nil

	(cAlias)->(dbSkip())

	EndDo
EndIf

(cAlias)->(dbCloseArea())

Return aData

WSMETHOD POST geolocation PATHPARAM employeeId WSREST Timesheet

    Local oClocking := &("JsonObject():New()")
    Local cBody := self:GetContent()
    Local oItem
    Local oItemDetail
    Local cToken
    Local cMsg  := ""
    Local lRet  := .F.

    ::SetHeader('Access-Control-Allow-Credentials' , "true")

    cToken := Self:GetHeader('Authorization')

    lRet := fSetGeoClocking( DecodeUTF8(cBody), @oItem, @oItemDetail, cToken, @cMsg )

    If lRet
        cJson := FWJsonSerialize(oItemDetail, .F., .F., .T.)
        ::SetResponse(cJson)
	Else
        SetRestFault(500, cMsg)
	EndIf

Return( lRet )


Function fSetGeoClocking(cBody,oItem,oItemDetail,cToken,cMsg)

Local cApprover				:= ""
Local cVision	 			:= ""
Local cEmpApr				:= ""
Local cFilApr				:= ""
Local cTitTurno				:= ""
Local cTitSeq				:= ""
Local cTitRegra				:= ""
Local nSupLevel				:= 0
Local nRet					:= 0
Local aVision				:= {}
Local aGetStruct			:= {}
Local aMSToHour 			:= Array(02)
Local cJson					:= ""
Local cTypeReq				:= "Z"
Local cRoutine				:= "W_PWSA400.APW" //Marcação de Ponto: Utilizada para buscar a VISÃO a partir da rotina; (AI8_VISAPV) na função GetVisionAI8().
Local cMsgReturn 			:= EncodeUTF8(STR0029) //"Dados atualizados com sucesso."
Local cBranchVld			:= FwCodFil()
Local oRequest				:= Nil
Local oAttendControlRequest	:= Nil
Local nHour                 := Seconds()*1000
Local cJsonObj	    		:= "JsonObject():New()"
Local lRet                  := .F.
Local lUpdRH3				:= .T.
Local lContinua				:= .T.
Local lAprov				:= FindFunction("FAPROVPON") //Funcao do TCFA040 - Essa verificacao deve ser retirada apos o release 12.1.26

Default cBody				:= ""
Default oItem 	 			:= &cJsonObj
Default oItemDetail			:= &cJsonObj
Default cToken				:= ""
Default cMsg				:= ""

oRequest					:= WSClassNew("TRequest")
oRequest:RequestType		:= WSClassNew("TRequestType")
oRequest:Status				:= WSClassNew("TRequestStatus")
oAttendControlRequest		:= WSClassNew("TAttendControl")

cMatSRA	 					:= GetRegisterHR(cToken)
cBranchVld 					:= GetBranch(cToken)
cRD0Cod    					:= GetCODHR(cToken)

If !Empty(cBody) .And. lAprov

	//Verifica se existem inconsistencias no cadastro do funcionario
	DbSelectArea("SRA")
	If ( lContinua := SRA->(dbSeek(cBranchVld + cMatSRA)) )
		cNome := AllTrim(SRA->RA_NOME)
		If Empty(SRA->RA_TNOTRAB) .Or. Empty(SRA->RA_SEQTURN) .Or. Empty(SRA->RA_REGRA)
			lContinua	:= .F.
			cTitTurno	:= GetSx3Cache("RA_TNOTRAB", "X3_TITULO")
			cTitSeq		:= GetSx3Cache("RA_SEQTURN", "X3_TITULO")
			cTitRegra	:= GetSx3Cache("RA_REGRA", "X3_TITULO")
			cMsg 		:= EncodeUTF8(STR0041) +" ("+ cTitTurno +"), ("+ cTitSeq +"), ("+ cTitRegra + ")" //"O cadastro do funcionario está incompleto. Verifique os campos:"
		EndIf
	EndIf

	If lContinua
		oItemDetail:FromJson(cBody)
	
	    // ----------------------------------------------
		// - A Função GetVisionAI8() devolve por padrão
		// - Um Array com a seguinte estrutura:
		// - aVision[1][1] := "" - AI8_VISAPV
		// - aVision[1][2] := 0  - AI8_INIAPV
		// - aVision[1][3] := 0  - AI8_APRVLV
		// - Por isso as posição podem ser acessadas
		// - Sem problemas, ex: cVision := aVision[1][1]
		// ----------------------------------------------
		aVision := GetVisionAI8(cRoutine, cBranchVld)
		cVision := aVision[1][1]
	
		// -------------------------------------------------------------------------------------------
		// - Efetua a busca dos dados referentes a Estrutura Oreganizacional dos dados da solicitação.
		//- -------------------------------------------------------------------------------------------
		 aGetStruct := APIGetStructure(cRD0Cod, SUPERGETMV("MV_ORGCFG"), cVision, cBranchVld, cMatSRA, , , ,cTypeReq , cBranchVld, cMatSRA, ,)
	
		 If Len(aGetStruct) >= 1 .And. !(Len(aGetStruct) == 3 .And. !aGetStruct[1])
		 	cEmpApr   := aGetStruct[1]:ListOfEmployee[1]:SupEmpresa
		 	cFilApr   := aGetStruct[1]:ListOfEmployee[1]:SupFilial
		 	nSupLevel := aGetStruct[1]:ListOfEmployee[1]:LevelSup
		 	cApprover := aGetStruct[1]:ListOfEmployee[1]:SupRegistration
		 EndIf
	
		cDate		:= FwTimeStamp(6, dDataBase, "12:00:00" )	//Data da inclusão
		cJustify	:= STR0035                     				//"Batida por GeoLocalização"
		aMsToHour	:= milisSecondsToHour(nHour,nHour)
	
		oRequest:Branch						:= cBranchVld
		oRequest:StarterBranch				:= cBranchVld
		oRequest:StarterRegistration		:= cMatSRA
		oRequest:Registration				:= cMatSRA
		oRequest:Empresa					:= cEmpAnt
		oRequest:Vision						:= cVision
	
		oAttendControlRequest:Branch  		:= cBranchVld
		oAttendControlRequest:Registration	:= cMatSRA
		oAttendControlRequest:Name			:= cNome
		oAttendControlRequest:Observation  	:= cJustify
		oAttendControlRequest:Date			:= Format8601(.T.,cDate)
		oAttendControlRequest:Hour			:= cValToChar(Round(aMsToHour[1], 2))
		oAttendControlRequest:Latitude		:= oItemDetail["latitude"]
		oAttendControlRequest:Longitude		:= oItemDetail["longitude"]
	
		BEGIN TRANSACTION
	
			lRet := AddAttendControlRequest(oRequest, oAttendControlRequest, .T., @cMsgReturn, STR0038 ) //"MEURH"
			
			If lRet
				nRet := fAprovPon( cBranchVld, cMatSRA, oRequest:Code, @cMsg, , lUpdRH3 )
				If nRet # 0
					cMsg := If( !Empty(cMsg), EncodeUTF8(cMsg), EncodeUTF8(STR0040) ) //"A batida está fora do período permitido para inclusão!" 
					lRet := .F.
					DisarmTransaction()
					Break
				EndIf
			Else
				cMsg := cMsgReturn
				DisarmTransaction()
				Break
			EndIf
			
		END TRANSACTION
	EndIf
Else
	cMsg := EncodeUTF8(STR0034) //"Falta recursos para se processar essa requisição. É necessário atualizar o sistema para a expedição mais recente."
EndIf

Return lRet

//"Retorna as batidas de ponto do dia atual"
WSMETHOD GET todayClockings PATHPARAM employeeId, latitude, longitude WSREST Timesheet
    Local oItem		 := &("JsonObject():New()")
    Local aData		 := {}

    Local cMatSRA	 := ""
    Local cBranchVld := ""
    Local cToken	 := ""

    cToken  := Self:GetHeader('Authorization')

    ::SetHeader('Access-Control-Allow-Credentials' , "true")

    cMatSRA    := GetRegisterHR(cToken)
    cBranchVld := GetBranch(cToken)

    If !Empty(cMatSRA) .And. !Empty(cBranchVld)
        aData := GetDayClocks(cBranchVld, cMatSRA)
    EndIf

    oItem["hasNext"] 	:= .F.
    oItem["items"]		:= aData

    cJson := FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return .T.

Static Function GetDayClocks(cBranchVld, cMatSRA )

    Local cAlias      := GetNextAlias()
    local aClockings  := {}
    Local oClocking   := Nil
    Local cDirection  := ""

    Default cBranchVld		:= FwCodFil()
    Default cMatSRA			:= ""
    Default dPerIni     	:= Ctod("//")
    Default dPerFim     	:= Ctod("//")

    dbSelectArea("SRA")
    SRA->(dbSetOrder(1))
    If SRA->( dbSeek( cBranchVld + cMatSRA ) )

        BEGINSQL ALIAS cAlias
            SELECT RH3_FILIAL,
                    RS3_DATA,
                    RS3_HORA,
                    RS3_STATUS,
                    RS3_JUSTIF,
                    RS3_CODIGO,
                    RS3_LATITU,
                    RS3_LONGIT
                  FROM %table:RS3% RS3
            INNER JOIN %table:RH3% RH3
                 ON RS3_FILIAL = RH3_FILIAL
                AND RS3_CODIGO = RH3_CODIGO
                AND RH3.%notDel%
              WHERE RS3_FILIAL = %exp:SRA->RA_FILIAL%
                AND RS3_MAT    = %exp:SRA->RA_MAT%
                AND RS3_DATA   = %exp:DtoS(dDataBase)%
                AND RS3_STATUS <> '2'
                AND RS3_LATITU <> ' '
                AND RS3_LONGIT <> ' '
                AND RS3.%notDel%
            ORDER BY RS3_FILIAL, RS3_MAT, RS3_DATA, RS3_HORA
        ENDSQL

        While (cAlias)->(!Eof())

            oClocking := &("JsonObject():New()")

            If cDirection != "entry"
                cDirection := "entry"
            Else
                cDirection := "exit"
            EndIf

            oClocking["date"]	   := FwTimeStamp(6, SToD((cAlias)->RS3_DATA), "12:00:00" )
            oClocking["hour"]	   := HourToMs(StrZero((cAlias)->RS3_HORA, 5, 2))
            oClocking["latitude"]  := (cAlias)->RS3_LATITU
            oClocking["longitude"] := (cAlias)->RS3_LONGIT
            oClocking["direction"] := cDirection

            Aadd( aClockings, oClocking )
            (cAlias)->(DbSkip())
        EndDo

        (cAlias)->(DbCloseArea())

    EndIf

Return aClockings

// Retorna a data e hora atuais do servidor com base no fuso horário do usuário
WSMETHOD GET currentTime PATHPARAM latitude, longitude WSREST Timesheet

    Local oItem := &("JsonObject():New()")

    ::SetHeader('Access-Control-Allow-Credentials' , "true")

    oItem["actualDate"] := FwTimeStamp(6, dDataBase, "12:00:00" )
    oItem["actualTime"] := Seconds()*1000 // O formato esperado é miliseconds.

    cJson := FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return .T.

WSMETHOD GET disconsider WSREST Timesheet

    Local oItem		 	:= &("JsonObject():New()")
    Local cToken        := ""
    Local cMatSRA       := ""
    Local cBranchVld    := ""
    Local cType         := "2" //-- Motivos de Rejeição
    Local aData         := {}

    ::SetContentType("application/json")
    ::SetHeader('Access-Control-Allow-Credentials' , "true")

    cToken  := Self:GetHeader('Authorization')

    cMatSRA	   := GetRegisterHR(cToken)
    cBranchVld := GetBranch(cToken)

    If !Empty(cMatSRA) .And. !Empty(cBranchVld)
        aData := fGetClockType(cBranchVld, cType)
    EndIf

    oItem["items"] 	 := aData
    oItem["hasNext"] := .F.

    cJson := FWJsonSerialize(oItem, .F., .F., .T.)

    ::SetResponse(cJson)

Return .T.


WSMETHOD GET geolocation PATHPARAM employeeId WSREST Timesheet

Local oItem		 	:= &("JsonObject():New()")
Local aData			:= {}

Local cMatSRA		:= ""
Local cBranchVld	:= ""
Local cToken	  	:= ""
Local aPeriods		:= {}
Local initPeriod    := CtoD( Format8601(.T.,Self:initPeriod) )
Local endPeriod     := CtoD( Format8601(.T.,Self:endPeriod) )

cToken  := Self:GetHeader('Authorization')

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := Self:employeeId
cBranchVld := GetBranch(cToken)

If !Empty(cMatSRA) .And. !Empty(cBranchVld)

    If( Empty(initPeriod) .And. Empty(endPeriod) )
        aPeriods	:= GetPeriodApont(cBranchVld,cMatSRA)
        If Len(aPeriods) > 0
            initPeriod 	:= aPeriods[1,1]
            endPeriod   := aPeriods[1,2]
        EndIf
    EndIf

	aData := getGeoClockings(cBranchVld,cMatSRA,initPeriod,endPeriod)
EndIf

oItem["hasNext"] 	:= .F.
oItem["items"]		:= aData

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return .T.

Function getGeoClockings(cBranchVld,cMatSRA,dPerIni,dPerFim)

    Local cAlias      := GetNextAlias()
    local aClockings  := {}
    Local oClocking   := Nil

    Default cBranchVld		:= FwCodFil()
    Default cMatSRA			:= ""
    Default dPerIni     	:= Ctod("//")
    Default dPerFim     	:= Ctod("//")

    dbSelectArea("SRA")
    SRA->(dbSetOrder(1))
    If SRA->( dbSeek( cBranchVld + cMatSRA ) )

        BEGINSQL ALIAS cAlias
            SELECT RH3_FILIAL,
                   RS3_DATA,
                   RS3_HORA,
                   RS3_STATUS,
                   RS3_JUSTIF,
                   RS3_CODIGO,
                   RH3_STATUS,
                   RS3_LATITU,
                   RS3_LONGIT
            FROM %table:RS3% RS3
            INNER JOIN %table:RH3% RH3
                 ON RS3_FILIAL = RH3_FILIAL
                AND RS3_CODIGO = RH3_CODIGO
                AND RH3.%notDel%
              WHERE RS3_FILIAL  = %exp:SRA->RA_FILIAL%
                AND RS3_MAT     = %exp:SRA->RA_MAT%
                AND RS3_DATA   >= %exp:DtoS(dPerIni)%
                AND RS3_DATA   <= %exp:DtoS(dPerFim)%
                AND RS3_LATITU <> ' '
                AND RS3_LONGIT <> ' '
                AND RS3.%notDel%
            ORDER BY RS3_FILIAL, RS3_MAT, RS3_DATA, RS3_HORA
        ENDSQL

        While (cAlias)->(!Eof())

            oClocking := &("JsonObject():New()")

            oClocking["id"]	          := (cAlias)->RS3_CODIGO
            oClocking["disconsider"]  := (cAlias)->RS3_STATUS == "2"
            oClocking["date"]	      := FwTimeStamp(6, SToD((cAlias)->RS3_DATA), "12:00:00" )
            oClocking["justify"]	  := EncodeUTF8((cAlias)->RS3_JUSTIF)
            oClocking["latitude"]	  := (cAlias)->RS3_LATITU
            oClocking["longitude"]	  := (cAlias)->RS3_LONGIT
            oClocking["hour"]	      := HourToMs(StrZero((cAlias)->RS3_HORA, 5, 2))

            If oClocking["disconsider"]
                oClocking["reason"]	      := &("JsonObject():New()")
                oClocking["reason"]["id"] := (cAlias)->RS3_CODIGO
                oClocking["reason"]["description"] := (cAlias)->(getRGKJustify(xFilial("RGK", RH3_FILIAL), RS3_CODIGO))
            EndIf

            Aadd( aClockings, oClocking )
            (cAlias)->(DbSkip())
        EndDo

        (cAlias)->(DbCloseArea())

    EndIf

Return aClockings

WSMETHOD PUT geolocation PATHPARAM employeeId WSREST Timesheet

Local oItem		 	:= &("JsonObject():New()")
Local aData			:= {}

Local cMatSRA		:= ""
Local cBranchVld	:= ""
Local cToken	  	:= ""
Local cMsg			:= ""
Local aPeriods		:= {}
Local initPeriod    := CtoD( Format8601(.T.,Self:initPeriod) )
Local endPeriod     := CtoD( Format8601(.T.,Self:endPeriod) )
Local cBody         := self:GetContent()
Local lRet          := .F.

cToken  := Self:GetHeader('Authorization')

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := Self:employeeId
cBranchVld := GetBranch(cToken)

If !Empty(cMatSRA) .And. !Empty(cBranchVld)
	If( lRet := UpdGeoClock(cBranchVld, cMatSRA, cBody, @oItem, @cMsg) )
		cJson := FWJsonSerialize(oItem, .F., .F., .T.)
		::SetResponse(cJson)
	Else
		SetRestFault(500, cMsg )
	EndIf
Else
	cMsg := EncodeUTF8(STR0036) //"Essa batida não foi desconsiderada porque não foram localizados os dados da requisição original."
	SetRestFault(500, cMsg )
EndIf

Return( lRet )


Static Function UpdGeoClock(cBranchVld, cMatSRA, cBody, oItem, cMsg )
    Local oClocking := &("JsonObject():New()")
    Local oReturn   := &("JsonObject():New()")
    Local cMotivo   := ""
    Local cCodRH3   := ""
    Local lRet      := .F.

    oClocking:FromJson( cBody )

    cMotivo := If( oClocking:hasProperty("justify"), oClocking["justify"], "" )
    cCodRH3 := If( oClocking:hasProperty("id"), oClocking["id"], "" )    

    If !Empty( cCodRH3 )
     	If !Empty( cMotivo )
	        If TCFA40Rej( cMotivo, cBranchVld, cCodRH3, cMatSRA )
	            oItem := oClocking
	            lRet  := .T.
	        EndIf
	    Else
	    	cMsg := EncodeUTF8(STR0039) //"O campo justificativa deve ser informado!"
	    EndIf
    Else
    	cMsg := EncodeUTF8(STR0036) //"Essa batida não foi desconsiderada porque não foram localizados os dados da requisição original."	
    EndIf

Return lRet

/*/{Protheus.doc} fSumOccurPer
Retorna o resumo das ocorrências do período/diario do colaborador.
@author:	Marcelo Silveira
@since:		10/06/2019
@param:		cBranchVld - Filial;
			cMatSRA - Matricula;
			cPerIni - Data inicio do periodo a ser pesquisado;
			cPerFim - Data Fim do periodo a ser pesquisado;
			lSexagenal - Se calcula em formato sexagesimal ou centensimal;
@return:	Array - eventos do banco de horas do periodo
/*/
Static Function fSumOccurPer( cBranchVld, cMatSRA, cPerIni, cPerFim, lSexagenal )

Local aArea			:= {}
Local aEventos		:= {}
Local cDtIni		:= ""
Local cDtFim		:= ""
Local cCod			:= ""
Local cAliasQry		:= ""
Local cWhere 		:= ""
Local cJoinFil 		:= ""
Local cAliasAux 	:= ""
Local cPrefixo		:= ""
Local dIniPonMes	:= cToD("//")
Local dFimPonMes	:= cToD("//")
Local nX			:= 0
Local nSaldo		:= 0
Local lImpAcum		:= .T.

DEFAULT lSexagenal	:= .T.

cDtIni 		:= StrTran( SubStr(cPerIni, 1, 10), "-", "" )
cDtFim 		:= StrTran( SubStr(cPerFim, 1, 10), "-", "" )

If !Empty(cDtIni) .And. !Empty(cDtFim)

	aArea		:= GetArea()
	cAliasQry	:= GetNextAlias()

	GetPonMesDat( @dIniPonMes , @dFimPonMes , cBranchVld )
	lImpAcum 	:= ( sTod(cDtFim) < dIniPonMes )
	cAliasAux 	:= If( lImpAcum, "SPH", "SPC")
	cPrefixo	:= If( lImpAcum, "PH_", "PC_")		

	cWhere += "%"
	cWhere += cPrefixo + "FILIAL = '" + cBranchVld + "' AND "
	cWhere += cPrefixo + "MAT = '" + cMatSRA + "' AND "
	cWhere += cPrefixo + "DATA >= '" + cDtIni + "' AND "
	cWhere += cPrefixo + "DATA <= '" + cDtFim + "' "
	cWhere += "%"

	If lImpAcum
	
		cJoinFil:= "%" + FWJoinFilial("SPH", "SP9") + "%"
	
		BeginSql Alias cAliasQry
		
		 	SELECT             
				SPH.PH_DATA, SPH.PH_PD, SPH.PH_PDI , SPH.PH_QUANTC, SPH.PH_QUANTI, SP9.P9_CODIGO, SP9.P9_DESC
			FROM 
				%Table:SPH% SPH
			INNER JOIN %Table:SP9% SP9
			ON %exp:cJoinFil% AND SP9.%NotDel% AND SPH.PH_PD = SP9.P9_CODIGO		
			WHERE
				%Exp:cWhere% AND SPH.%NotDel%
			ORDER BY SPH.PH_DATA, SPH.PH_PD
		
		EndSql 	
	Else
		cJoinFil:= "%" + FWJoinFilial("SPC", "SP9") + "%"
		
		BeginSql Alias cAliasQry
		
		 	SELECT             
				SPC.PC_DATA, SPC.PC_PD, SPC.PC_PDI ,SPC.PC_QUANTC, SPC.PC_QUANTI, SP9.P9_CODIGO, SP9.P9_DESC
			FROM 
				%Table:SPC% SPC
			INNER JOIN %Table:SP9% SP9
			ON %exp:cJoinFil% AND SP9.%NotDel% AND SPC.PC_PD = SP9.P9_CODIGO			
			WHERE
				%Exp:cWhere%  AND SPC.%NotDel%
			ORDER BY SPC.PC_DATA, SPC.PC_PD	
		EndSql 	
	EndIf
	
	//Considera todos os eventos: Autorizados/Nao Autorizados
	While !(cAliasQry)->(Eof())
	
		cCod	:= (cAliasQry)->P9_CODIGO
		nSaldo  := (cAliasQry)->(If(&(cPrefixo+"QUANTI")>0,&(cPrefixo+"QUANTI"),&(cPrefixo+"QUANTC")))
	
		If ( nPos := aScan( aEventos, {|x| x[1] == cCod} ) ) == 0
			aAdd( aEventos, { (cAliasQry)->P9_CODIGO, (cAliasQry)->P9_DESC, nSaldo } )
		Else
			If lSexagenal
				aEventos[nPos,3] := __TimeSum( aEventos[nPos,3], nSaldo )
			Else
				aEventos[nPos,3] := aEventos[nPos,3] + fConvhR(nSaldo,"D",,5)				
			EndIf 		
		EndIf
	
		(cAliasQry)->(DbSkip())
	EndDo
	
	(cAliasQry)->(DbCloseArea())

	RestArea( aArea )

EndIf

Return( aEventos )

/*/{Protheus.doc} fBalanceSumPer
Retorna o banco de horas do funcionario conforme o periodo que esta sendo pesquisado.
@author:	Marcelo Silveira
@since:		10/06/2019
@param:		cBranchVld - Filial;
			cMatSRA - Matricula;
			cPerIni - Data inicio do periodo a ser pesquisado;
			cPerFim - Data Fim do periodo a ser pesquisado;
			lSexagenal - Se calcula em formato sexagesimal ou centensimal;
			lTeam - Se verdadeiro ira pesquisar dos funcionarios do time conforme a matricula;
@return:	Array - banco de horas do periodo
/*/
Function fBalanceSumPer( cBranchVld, cMatSRA, cPerIni, cPerFim, lSexagenal, lTeam )

Local aRetSaldo
Local aArea			:= {}
Local cDtIni		:= ""
Local cDtFim		:= ""
Local cCod			:= ""
Local cTpCod		:= ""
Local cMatTeam		:= ""
Local cAliasSPI		:= ""
Local cWhereSPI		:= "%%"
Local cRoutine		:= "W_PWSA400.APW" 	//Marcação de Ponto
Local nX			:= 0
Local nValor		:= 0
Local nCurrent		:= 0
Local nCredito		:= 0
Local nDebito		:= 0
Local nSaldoAtu		:= 0
Local nSaldoAnt		:= 0

DEFAULT lSexagenal	:= .T.
DEFAULT lTeam		:= .F.
DEFAULT cCodRD0		:= ""

cDtIni 	:= StrTran( SubStr(cPerIni, 1, 10), "-", "" )
cDtFim 	:= StrTran( SubStr(cPerFim, 1, 10), "-", "" )

//Busca os dados da equipe caso a requisicao seja do saldo do time
If lTeam
	aRetSaldo  := {0,0}
    aVision    := GetVisionAI8(cRoutine, cBranchVld)
    cVision    := aVision[1][1]
    aCoordTeam := APIGetStructure("", "", cVision, cBranchVld, cMatSRA, , , , , cBranchVld, cMatSRA)

	For nX := 1 To Len( aCoordTeam[1]:ListOfEmployee )
		If !aCoordTeam[1]:ListOfEmployee[nX]:Registration == cMatSRA //Nao considera a matricula do lider/gestor
			cMatTeam += "'" + aCoordTeam[1]:ListOfEmployee[nX]:Registration + "',"
		EndIf
	Next
    
    cMatTeam  := SubStr(cMatTeam, 2, Len(cMatTeam)-3 )
    cWhereSPI := cMatTeam
Else
	aRetSaldo := {0,0,0}
	cWhereSPI := cMatSRA
EndIf

If !Empty(cWhereSPI) .And. !Empty(cDtIni) .And. !Empty(cDtFim)
	
	aArea		:= GetArea()
	cAliasSPI	:= GetNextAlias()
	
	BeginSql alias cAliasSPI
		SELECT PI_FILIAL, PI_MAT, PI_PD, PI_QUANT, PI_QUANTV, PI_CC, PI_DATA, PI_STATUS, PI_DTBAIX
		FROM %table:SPI% SPI
		WHERE 	SPI.PI_FILIAL = %exp:cBranchVld% AND 
				SPI.PI_MAT IN ( %exp:cWhereSPI% ) AND
				SPI.%notDel%
		ORDER BY 
			SPI.PI_FILIAL, SPI.PI_MAT, SPI.PI_DATA	
	EndSql	

	While (cAliasSPI)->( !Eof() )

		PosSP9((cAliasSPI)->PI_PD, cBranchVld)
		cCod   := SP9->P9_CODIGO
		cTpCod := SP9->P9_TIPOCOD 

		// Totaliza Saldo Anterior
		If !lTeam .And. (cAliasSPI)->PI_DATA < cDtIni
			If !((cAliasSPI)->PI_STATUS == 'B' .AND. (cAliasSPI)->PI_DTBAIX < cDtIni)
				If ((cAliasSPI)->PI_STATUS == 'B' .AND. (cAliasSPI)->PI_DTBAIX <= cDtFim)
					If SP9->P9_TIPOCOD $  "1*3"
						nValor := (cAliasSPI)->PI_QUANT
						If lSexagenal
							nSaldoAnt := __TimeSum(nSaldoAnt,nValor)  
							nSaldoAtu := __TimeSub(nSaldoAtu,nValor)
						Else
							nSaldoAnt := nSaldoAnt + fConvhR(nValor,"D",,5) 
							nSaldoAtu := nSaldoAtu - fConvhR(nValor,"D",,5) 
						EndIf 
					Else
						nValor := (cAliasSPI)->PI_QUANT
						If lSexagenal
							nSaldoAnt := __TimeSub(nSaldoAnt,nValor)
							nSaldoAtu := __TimeSum(nSaldoAtu,nValor)    
						Else
							nSaldoAnt := nSaldoAnt - fConvhR(nValor,"D",,5)
							nSaldoAtu := nSaldoAtu + fConvhR(nValor,"D",,5)  
						EndIf
					EndIf
				Else
					If SP9->P9_TIPOCOD $  "1*3"
						nValor := (cAliasSPI)->PI_QUANT
						If lSexagenal
							nSaldoAnt := __TimeSum(nSaldoAnt,nValor)  
						Else
							nSaldoAnt := nSaldoAnt + fConvhR(nValor,"D",,5) 
						EndIf 
					Else
						nValor := (cAliasSPI)->PI_QUANT
						If lSexagenal
							nSaldoAnt := __TimeSub(nSaldoAnt,nValor)  
						Else
							nSaldoAnt := nSaldoAnt - fConvhR(nValor,"D",,5) 
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf (cAliasSPI)->PI_DATA <= cDtFim
			If !((cAliasSPI)->PI_STATUS == 'B' .AND. (cAliasSPI)->PI_DTBAIX <= cDtFim)
				If SP9->P9_TIPOCOD $  "1*3"
					nValor := (cAliasSPI)->PI_QUANT
					If lSexagenal
						nCredito := __TimeSum(nCredito,nValor)  
					Else
						nCredito := nCredito + fConvhR(nValor,"D",,5) 
					EndIf 
				Else
					nValor := (cAliasSPI)->PI_QUANT
					If lSexagenal
						nDebito := __TimeSum(nDebito,nValor)  
					Else
						nDebito := nDebito + fConvhR(nValor,"D",,5) 
					EndIf
				EndIf
			EndIf	
		Else
			Exit
		Endif

		(cAliasSPI)->(DbSkip())
	End
	
	(cAliasSPI)->( DBCloseArea() )

	If nSaldoAnt <> 0 .or. nCredito > 0 .or. nDebito > 0
		If lTeam
			aRetSaldo := { nCredito, nDebito }
		Else 
			If lSexagenal
				nSaldoAtu := __TimeSum(nSaldoAtu, __TimeSub( __TimeSum( nSaldoAnt , nCredito ) , nDebito ))
				nCurrent  := __TimeSub( nCredito, nDebito )
			Else
				nSaldoAtu := ( nSaldoAtu + nSaldoAnt + nCredito ) - nDebito
				nCurrent  := nCredito - nDebito
			EndIf
			aRetSaldo := { nSaldoAnt, nSaldoAtu, nCurrent }
		EndIf
	EndIf
	
	RestArea( aArea )

EndIf

Return( aRetSaldo )

WSMETHOD PUT EditVariousClockings PATHPARAM employeeId WSREST Timesheet
    Local aUrlParam     := ::aUrlParms
    Local cBody         := ::GetContent()
    Local cJsonObj      := "JsonObject():New()"
    Local oItem         := &cJsonObj
    Local oItemDetail   := &cJsonObj
    Local cToken        := ""
    Local cMsgLog       := ""
    Local lRet          := .T.
    Local oResponse     := &cJsonObj
    Local cJson         := ""

    ::SetHeader('Access-Control-Allow-Credentials' , "true")

    cToken := Self:GetHeader('Authorization')

    lRet := fEditClocking(aUrlParam,DecodeUTF8(cBody),@cJsonObj,@oItem,@oItemDetail,cToken,@cMsgLog)
    If lRet
        oResponse["date"]               := oItemDetail["date"]
        oResponse["clockings"]          := aClone(oItemDetail["clockings"])
        
        cJson := FWJsonSerialize(oResponse, .F., .F., .T.)
        ::SetResponse(cJson)
    Else
        SetRestFault(500, EncodeUTF8(cMsgLog))
    EndIf

Return lRet

Function fEditClocking(aUrlParam,cBody,cJsonObj,oItem,oItemDetail,cToken,cMsgLog)
    Local aMSToHour             := Array(02)
    Local cMsgReturn            := ""
    Local cBranchVld            := FwCodFil()
    Local oRequest              := Nil
    Local oAttendControlRequest := Nil
    Local nA                    := 0
    Local cCodeReq              := ""
    Local cAllJustify           := ""
    Local lRet                  := .T.
    Local aStatus               := {"","",""}
    Local aTrab                 := {}
    Local lEmployManager 		:= .F.

    Default aUrlParam           := {}
    Default cBody               := ""
    Default cJsonObj            := "JsonObject():New()"
    Default oItem               := &cJsonObj
    Default oItemDetail         := &cJsonObj
    Default cToken              := ""
    Default cMsgLog             := ""

    oRequest                    := WSClassNew("TRequest")
    oRequest:RequestType        := WSClassNew("TRequestType")
    oRequest:Status             := WSClassNew("TRequestStatus")
    oAttendControlRequest       := WSClassNew("TAttendControl")

    cMatSRA                     := GetRegisterHR(cToken)
    cBranchVld                  := GetBranch(cToken)

    If !Empty(cBody)
        oItemDetail:FromJson(cBody)

        //Em a justificativa tiver sido informada para todas as batidas 
        cAllJustify := If(oItemDetail:hasProperty("justify"),oItemDetail["justify"],"")

        If oItemDetail:hasProperty("clockings") .And. ValType(oItemDetail["clockings"]) == "A"
            For nA := 1 To len(oItemDetail["clockings"])
                aStatus := {"","",""}
                If oItemDetail["clockings"][nA]:hasProperty("status")
                    aStatus[1] := oItemDetail["clockings"][nA]["status"]["status"]
                    aStatus[2] := oItemDetail["clockings"][nA]["status"]["id"]
                    aStatus[3] := oItemDetail["clockings"][nA]["status"]["label"]
                EndIf
                AADD(aTrab,{;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("hour"),oItemDetail["clockings"][nA]["hour"]," "),;
                    aStatus,;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("date"),oItemDetail["clockings"][nA]["date"]," "),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("sequence"),oItemDetail["clockings"][nA]["sequence"]," "),;
                    Iif(!Empty(cAllJustify), cAllJustify, Iif(oItemDetail["clockings"][nA]:hasProperty("justify"),oItemDetail["clockings"][nA]["justify"]," ")),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("id"),oItemDetail["clockings"][nA]["id"]," "),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("referenceDate"),oItemDetail["clockings"][nA]["referenceDate"]," "),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("direction"),oItemDetail["clockings"][nA]["direction"]," "),;
                    Iif(oItemDetail["clockings"][nA]:hasProperty("origin"),oItemDetail["clockings"][nA]["origin"]," "),;
                    Iif(oItemDetail:hasProperty("reason"),oItemDetail["reason"]," ");
                })
            Next nA
        Else
            aStatus := {"","",""}
            If oItemDetail:hasProperty("status")
                aStatus[1] := oItemDetail["status"]["status"]
                aStatus[2] := oItemDetail["status"]["id"]
                aStatus[3] := oItemDetail["status"]["label"]
            EndIf
            AADD(aTrab,{;
                Iif(oItemDetail:hasProperty("hour"),oItemDetail["hour"]," "),;
                aStatus,;
                Iif(oItemDetail:hasProperty("date"),oItemDetail["date"]," "),;
                Iif(oItemDetail:hasProperty("sequence"),oItemDetail["sequence"]," "),;
                Iif(!Empty(cAllJustify), cAllJustify, Iif(oItemDetail:hasProperty("justify"),oItemDetail["justify"]," ")),;
                Iif(oItemDetail:hasProperty("id"),oItemDetail["id"]," "),;
                Iif(oItemDetail:hasProperty("referenceDate"),oItemDetail["referenceDate"]," "),;
                Iif(oItemDetail:hasProperty("direction"),oItemDetail["direction"]," "),;
                Iif(oItemDetail:hasProperty("origin"),oItemDetail["origin"]," "),;
                ""; //-- No request do metodo "Atualiza UMA batida do espelho do ponto" não é enviado o parametro "reason" pois isso é inicializado com ""
            })
        EndIf

        If Len(aTrab) > 0
        	lEmployManager := fGetTeamManager(cBranchVld, cMatSRA)
        	
            DbSelectArea("RH3")
            For nA := 1 To len(aTrab)
                cCodeReq    := aTrab[nA][6]
                aMsToHour   := milisSecondsToHour(aTrab[nA][1],aTrab[nA][1])
                If "|" $ cCodeReq
                    cCodeReq := STRTOKARR( cCodeReq , "|" )[2]

                    RH3->(DbSetOrder(1))
                    If RH3->(DbSeek( cBranchVld + cCodeReq ))
                        //Altera somente status 1 (Em processo de aprovação) ou 4 (Aguardando aprovacao RH) para quem tem equipe
                        If RH3->RH3_STATUS == "1" .Or. (lEmployManager .And. RH3->RH3_STATUS == "4")
                           oRequest:Branch                     := cBranchVld
                           oAttendControlRequest:Branch        := cBranchVld
                           oAttendControlRequest:Registration  := cMatSRA
                           oAttendControlRequest:Name          := Alltrim(Posicione('SRA',1,cBranchVld+cMatSRA,'SRA->RA_NOME'))
                           oAttendControlRequest:EntryExit     := Iif(Alltrim(aTrab[nA][8])=="entry","Entrada","Saída")
                           oAttendControlRequest:Date          := Format8601(.T.,aTrab[nA][3])
                           oAttendControlRequest:Hour          := cValToChar(aMsToHour[1])
                           oAttendControlRequest:Observation   := GetMotDesc( aTrab[nA][10], cCodeReq )
                           oAttendControlRequest:Motive        := aTrab[nA][5]
                           oAttendControlRequest:codeRequest   := cCodeReq

                            AddAttendControlRequest(oRequest, oAttendControlRequest, .T., @cMsgReturn, STR0038 ) //"MEURH")
                        Else //-- Qualquer outro status nao permite alteracao
                            cMsgLog := STR0037 //"Essa batida não pode ser alterada. O seu Tipo ou Status atual não permite alteração."
                            lRet := .F.
                            Exit
                        EndIf
                    EndIf
                Else
                    cMsgLog := STR0026 //"Só é possível editar batidas que foram incluídas manualmente!"
                    lRet := .F.
                    Exit
                EndIf
            Next nA
        EndIf
    EndIf

Return lRet

WSMETHOD POST SetVariousClockings PATHPARAM employeeId WSREST Timesheet
    Local aUrlParam     := ::aUrlParms
    Local cBody         := ::GetContent()
    Local cJsonObj      := "JsonObject():New()"
    Local oItem         := &cJsonObj
    Local oItemDetail   := &cJsonObj
    Local cToken        := ""
    Local cStatus       := ""
    Local cMsgLog       := ""
    Local lRet          := .T.
    Local cJson         := ""

    ::SetHeader('Access-Control-Allow-Credentials' , "true")
    cToken := Self:GetHeader('Authorization')

    lRet := fSetClocking(aUrlParam,DecodeUTF8(cBody),@cJsonObj,@oItem,@oItemDetail,cToken,@cStatus,@cMsgLog)
    If lRet
        If !Empty(cStatus)
            ::SetHeader('Status', cStatus)
        EndIf
        cJson := FWJsonSerialize(oItem, .F., .F., .T.)
        ::SetResponse(cJson)
    Else
        SetRestFault(500, EncodeUTF8(cMsgLog))
    EndIf
Return lRet

WSMETHOD PUT EditOneClockings PATHPARAM employeeId WSREST Timesheet
    Local aUrlParam     := ::aUrlParms
    Local cBody         := ::GetContent()
    Local cJsonObj      := "JsonObject():New()"
    Local oItem         := &cJsonObj
    Local oItemDetail   := &cJsonObj
    Local cToken        := ""
    Local cMsgLog       := ""
    Local lRet          := .T.
    Local cJson         := ""

    ::SetHeader('Access-Control-Allow-Credentials' , "true")

    cToken := Self:GetHeader('Authorization')

    lRet := fEditClocking(aUrlParam,DecodeUTF8(cBody),@cJsonObj,@oItem,@oItemDetail,cToken,@cMsgLog)
    If lRet
        cJson := FWJsonSerialize(oItemDetail, .F., .F., .T.)
        ::SetResponse(cJson)
    Else
        SetRestFault(500, EncodeUTF8(cMsgLog))
    EndIf

Return lRet

Static Function GetMotDesc(cCodigo, cCodRH3)
    Local cMotDesc := ""
    Local aArea	:= GetArea()

    If !Empty(cCodigo)
	    dbSelectArea("RFD")
	    RFD->(dbSetOrder(1))
	    If RFD->(dbSeek(FWxFilial("RFD") + cCodigo))	
	        cMotDesc := RFD->RFD_DESC
	    EndIf
	Else
	    dbSelectArea("RH4")
	    RH4->(dbSetOrder(1))
	    If RH4->(dbSeek(FWxFilial("RH4") + cCodRH3))	
			While !RH4->(Eof())
			    If Alltrim(RH4->RH4_CAMPO) == "P8_MOTIVRG"
					cMotDesc  := AllTrim( RH4->RH4_VALNOV )
					Exit
				EndIf
				RH4->(dbskip())
			Enddo
	    EndIf
    EndIf
	
	RestArea(aArea)

Return cMotDesc

WSMETHOD DELETE deleteClocking WSREST Timesheet

	Local lRet			:= .T.
	Local cToken		:= ""
	Local cBranchVld	:= ""
	Local aUrlParam		:= Self:aUrlParms
	Local cCodigo		:= ""
	Local aRet			:= { .F., ""}
		
	::SetContentType("application/json")
	::SetHeader('Access-Control-Allow-Credentials' , "true")

	If AT("|", aUrlParam[3]) > 0
		cCodigo := STRTOKARR( aUrlParam[3] , "|" )[2]
		cToken		:= Self:GetHeader('Authorization')
		cBranchVld	:= GetBranch(cToken)
		cMatSRA		:= GetRegisterHR(cToken)
		
		aRet := DelBatida(cBranchVld, cMatSRA, cCodigo)
	Else
		aRet[2] := EncodeUTF8(STR0033) //"Essa batida não pode ser excluída. O seu Tipo ou Status atual não permite a exclusão."
	EndIf
	
	If aRet[1]
	   	HttpSetStatus(204)
   	Else	
	   	lRet := .F.
		SetRestFault(500, aRet[2])
	EndIf  
Return lRet

Static Function DelBatida(cFilialPar, cMatSRA, cCodigo)
	Local lRet		:= .T.
	Local cFilRH3	:= Iif( FWModeAccess("RH3") == "C", FwxFilial("RH3"), cFilialPar )
	Local cFilRH4	:= Iif( FWModeAccess("RH4") == "C", FwxFilial("RH4"), cFilialPar )
	Local cFilRS3	:= Iif( FWModeAccess("RS3") == "C", FwxFilial("RS3"), cFilialPar )
	Local cMessage	:= ""
	Local lEmployManager := .F.
	
	dbSelectArea("RH3")
	RH3->(dbSetOrder(1))
	If RH3->(dbSeek(cFilRH3 + cCodigo))
	
		lEmployManager := fGetTeamManager(cFilialPar, cMatSRA)
		
		//Exclui somente status 1 (Em processo de aprovação) ou 4 (Aguardando aprovacao RH) para quem tem equipe
		If RH3->RH3_STATUS == '1' .Or. (lEmployManager .And. RH3->RH3_STATUS == "4")
			Begin Transaction
				RecLock("RH3",.F.)
				RH3->(dbDelete())
				RH3->(MsUnlock())

				DbSelectArea("RH4")
				RH4->(DbSetOrder(1))
				If RH4->(DbSeek(cFilRH4 + cCodigo))
					While RH4->(!Eof() .and. RH4_FILIAL + RH4_CODIGO == cFilRH4 + cCodigo)
						RecLock("RH4",.F.)
						RH4->(DbDelete())
						RH4->(MsUnLock())
						RH4->(DbSkip())
					EndDo
				EndIf

				DbSelectArea("RS3")
				RS3->(DbSetOrder(1))
				If RS3->(DbSeek(cFilRS3 + cCodigo))
					RecLock("RS3",.F.)
					RS3->(DbDelete())
					RS3->(MsUnLock())
					RS3->(DbSkip())
				EndIf
			End Transaction
		Else
			cMessage := EncodeUTF8(STR0032) //"Esta batida não poderá ser excluída porque o processo de aprovação já foi iniciado."
			lRet := .F.
		EndIf
	EndIf	

Return {lRet, cMessage}
