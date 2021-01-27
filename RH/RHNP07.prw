#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"

#INCLUDE "RHNP07.CH"

Function RHNP07()
Return .T.

WSRESTFUL Setting DESCRIPTION STR0001 //"Servi�os de Contexto"

WSDATA employeeId	As String Optional
WSDATA WsNull		As String Optional
WSDATA type		As String Optional

WSMETHOD GET getAllContexts ;
 DESCRIPTION STR0002 ; //"Retorna os contextos do usu�rio para sele��o."
 WSSYNTAX "/setting/contexts" ;
 PATH "/contexts" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET getContext ;
 DESCRIPTION STR0003 ; //"Retorna o contexto corrente do usu�rio."
 WSSYNTAX "/setting/context" ;
 PATH "/context" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD PUT setContext ;
 DESCRIPTION STR0004 ; //"Atualiza o contexto selecionado."
 WSSYNTAX "/setting/context" ;
 PATH "/context" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET getPermissions ;
 DESCRIPTION STR0011 ; //"Verifica libera��o de acesso as funcionalidades."
 WSSYNTAX "/setting/permissions/{employeeId}" ;
 PATH "/permissions/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET getFieldProperties ;
 DESCRIPTION STR0012 ; //"Verifica libera��o de acesso para atualiza��o de campos cadastrais."
 WSSYNTAX "/setting/fieldProperties/{pageFilter}" ;
 PATH "fieldProperties/{pageFilter}" ;
 PRODUCES 'application/json;charset=utf-8'

END WSRESTFUL


// -------------------------------------------------------------------
// - GET RESPONS�VEL POR RETORNAR OS CONTEXTOS DO USU�RIO LOGADO.
// -------------------------------------------------------------------
WSMETHOD GET getAllContexts  WSREST Setting

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local oMessages	  	:= &cJsonObj
Local oValida       := &cJsonObj
Local cBranchVld	:= ""
Local cMatSRA		:= ""
Local cLogin		:= ""
Local cToken        := ""
Local aItemCtx      := {}
Local aDadosCtx  	:= {}
Local aMessages		:= {}


::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken  := Self:GetHeader('Authorization')

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cLogin     := GetLoginHR(cToken)

If Empty(cBranchVld) .Or. Empty(cMatSRA) .Or. Empty(cLogin)
	oMessages["type"]   := "error"
	oMessages["code"]   := "401"
	oMessages["detail"] := EncodeUTF8(STR0005) //"Dados inv�lidos para valida��o do contexto."

	Aadd(aMessages,oMessages)
Else
	//Busca multiplus v�nculos
	getMultV(cBranchVld,cMatSRA,cLogin,cJsonObj,@aDadosCtx,@aItemCtx,.T.)
EndIf


// - Por por padr�o todo objeto tem
// - data: contendo a estrutura do JSON
// - messages: para determinados avisos
// - length: informativo sobre o tamanho.
oItem["data"]   := Iif(Empty(aDadosCtx),oValida,aDadosCtx)
oItem["length"] := Iif(Empty(aDadosCtx),1,Len(aDadosCtx))
If Len(aDadosCtx) < 1
    oMessages["type"]   := "info"
    oMessages["code"]   := ""
    oMessages["detail"] := EncodeUTF8(STR0008) //"Nenhuma matr�cula localizada no servi�o de contexto."

    Aadd(aMessages, oMessages)
EndIf
oItem["messages"] := aMessages

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cjson)


Return(.T.)


// -------------------------------------------------------------------
// - GET RESPONS�VEL POR RETORNAR O CONTEXTO ATUAL DO USU�RIO LOGADO.
// -------------------------------------------------------------------
WSMETHOD GET getContext  WSREST Setting

Local cJsonObj      := "JsonObject():New()"
Local oItem         := &cJsonObj
Local oMessages     := &cJsonObj
Local oValida       := &cJsonObj
Local cBranchVld    := ""
Local cMatSRA       := ""
Local cLogin        := ""
Local cToken        := ""
Local aItemCtx      := {}
Local aDadosCtx     := {}
Local aMessages     := {}


::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken  := Self:GetHeader('Authorization')


cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cLogin     := GetLoginHR(cToken)

If Empty(cBranchVld) .Or. Empty(cMatSRA) .Or. Empty(cLogin)
    cJson := resultSetContext(,.F.)
Else
    //Carrega contexto atual
    getMultV(cBranchVld,cMatSRA,cLogin,cJsonObj,@aDadosCtx,@aItemCtx,.F.)

    //prepara json retorno
    cJson := resultSetContext(aItemCtx,.F.)
EndIf

::SetResponse(cjson)

Return(.T.)


// -------------------------------------------------------------------
// - PUT RESPONS�VEL POR ATUALIZAR O CONTEXTO DO USU�RIO LOGADO.
// -------------------------------------------------------------------
WSMETHOD PUT setContext WSREST Setting

Local cJsonObj      := "JsonObject():New()"
Local oItem         := &cJsonObj
Local oMessages     := &cJsonObj
Local oValida       := &cJsonObj
Local cToken        := ""
Local cKey          := ""
Local cBranchVld    := ""
Local cMatSRA       := ""
Local cLogin        := ""
Local cBody         := ""

Local cRetorno      := ""
Local aRetData      := {}

Local aItemCtx      := {}
Local aParte01      := {}
Local aParte02      := {}
Local aParte03      := {}
Local aEmpID        := {}
Local aDadosCtx     := {}
Local aMessages     := {}


cToken      := Self:GetHeader('Authorization')

cMatSRA     := GetRegisterHR(cToken)
cBranchVld  := GetBranch(cToken)
cLogin      := GetLoginHR(cToken)

cBody       := ::GetContent()


If Empty(cBranchVld) .Or. Empty(cMatSRA) .Or. Empty(cLogin) .Or. Empty(cBody)
    cJson := resultSetContext(,.T.)
Else
    //******parse employeeID, exemplo:
    // "{"current":false,"branchName":"COORDENA��O RH MOBILE         ","status":"active","companyName":"Filial BELO HOR/Grupo TOTVS 1","employeeID":"D MG 01 |00502 |000207","employeeType":"internal"}"
    cBody       := substr(cBody,2,len(cbody)-1)             //retira {
    aParte01    := StrTokArr(cBody, ",")                    //cria ocorr�ncias, separa ','
    aParte02    := StrTokArr(aParte01[5], ":")              //cria ocorr�ncias para employeeID, separa ':'
    aParte02[2] := substr(aParte02[2],2,len(aParte02[2])-2) //retira aspas do conte�do importante
    aParte03    := StrTokArr(aParte02[2], "|")              //separa filial,matr�cula,login

    //Atualiza novo token
    cKey   := aParte03[2]+"|"+cLogin+"|"+aParte03[3]+"|"+DtoS(dDataBase)+"|"+aParte03[1]

	//cToken := FwJWT2Bear(GetConfig("RESTCONFIG","userId", ""),{"payments/","payment/","data/","team/", "request/", "timesheet/", "/team/", "setting/"},Date(),Seconds() + Val(GetConfig("RESTCONFIG","RefreshTokenTimeout", 300)),Nil,Nil,{ {"key",cKey} })
	//Retirada a passagem de data e segundos para a funcao FwJWT2Bear por orientacao do Framework - 01/2019
	cToken := FwJWT2Bear(cUserID,{"payments/","payment/","data/","team/", "request/", "timesheet/", "/team/", "setting/"},Nil,Nil,Nil,Nil,{ {"key",cKey} })

    //configura o header
    ::SetHeader('Access-Control-Allow-Credentials' , "true")
    ::SetHeader('Set-Authorization', 'Bearer ' + cToken)

    //prepara informa��es
    getMultV(aParte03[1],aParte03[2],cLogin,cJsonObj,@aDadosCtx,@aItemCtx,.F.)

    //prepara json retorno
    cJson := resultSetContext(aItemCtx,.T.)
EndIf

::SetResponse(cjson)

Return (.T.)


// -------------------------------------------------------------------
// - GET RESPONS�VEL PARA AVALIAR AS PERMISS�ES DE ACESSO.
// -------------------------------------------------------------------
WSMETHOD GET getPermissions  WSREST Setting

Local cJsonObj	     := "JsonObject():New()"
Local cJson          := &cJsonObj
Local cToken         := ""
Local cMatSRA        := ""
Local cLogin         := ""
Local cPortal        := ""
Local cBranchVld     := ""
Local nLenParms      := Len(::aURLParms)
Local oPermissions   := &cJsonObj
Local lEmployManager := .F.
Local aServices		 := {}
Local nX			 := 0
Local cFilAI3		 := ""
Local aArea			 := {}

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken         := Self:GetHeader('Authorization')
cMatSRA        := GetRegisterHR(cToken)
cBranchVld     := GetBranch(cToken)
cLogin     	   := GetLoginHR(cToken)

//Indica se o funcionario e responsavel por algum departamento
lEmployManager := fGetTeamManager(cBranchVld, cMatSRA) 

//varinfo("URLParams     : ", ::aURLParms)
//varinfo("lEmployManager: ", lEmployManager)

If !Empty(::aURLParms[1]) .And. ::aURLParms[1] == "permissions"
	
	aArea := GetArea()
	
	dbSelectArea("RD0")
	RD0->(dbSetOrder(10))
	If RD0->(dbSeek( FWxFilial("RD0")+ Padr(UPPER(AllTrim(cLogin)),TamSx3("RD0_LOGIN")[1])))
		cPortal := RD0->RD0_PORTAL
	EndIf

	If AliasInDic("RJD") .And. !Empty( cPortal )
		cFilAI3 := Iif( FWModeAccess("AI3") == "C", FwxFilial("AI3"), cBranchVld )
		RJD->( DbGoTop() )
		RJD->(dbSetOrder(1))
		If RJD->(dbSeek(FWxFilial("RJD") + cPortal))
			While RJD->( !Eof() ) .And. RJD->RJD_FILIAL == cFilAI3;
			.And. RJD->RJD_CODUSU == cPortal
				Aadd(aServices,{ AllTrim(RJD->RJD_WS), RJD->RJD_HABIL })
				RJD->(DbSkip())
			EndDo
		EndIf
	EndIf
	If Empty( aServices )	
		aServices	:= TCFA006SRV( .T. )
	EndIf
	
	RestArea(aArea)
	
	For nX := 1 To Len( aServices )
		If aServices[nX,1] $ "clockingGeoView||clockingGeoDisconsider||substituteRequest||absenceManager"
			oPermissions[ aServices[nX,1] ] := aServices[nX,2] == "1" .And. lEmployManager
		Else
			oPermissions[ aServices[nX,1] ] := aServices[nX,2] == "1"
		EndIf
	Next nX

	cJson := FWJsonSerialize(oPermissions, .F., .F., .T.)

EndIf

//varinfo("cJson: ",cJson)
::SetResponse(cJson)

Return(.T.)


// -------------------------------------------------------------------
// - GET RESPONS�VEL PARA AVALIAR AS PERMISS�ES ATUALIZA��O DE CAMPOS.
// -------------------------------------------------------------------
WSMETHOD GET getFieldProperties  WSREST Setting

Local cJsonObj   := "JsonObject():New()"
Local oItem      := &cJsonObj
Local oProps     := &cJsonObj
Local aData      := {}

Local cJson      := ""
Local cToken     := ""
Local cMatSRA    := ""
Local cBranchVld := ""

Local nLenParms  := Len(::aURLParms)

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken       := Self:GetHeader('Authorization')
cMatSRA      := GetRegisterHR(cToken)
cBranchVld   := GetBranch(cToken)


//pageFilter
// payment, vacation, clocking, allowance, profile, notification, occurrence, clockingGeoUpdate, clockingRegister, clockingUpdate
// varinfo("URLParams: ", ::aURLParms)
 
 If nLenParms > 1 .And. Lower(::aURLParms[2]) == "medicalcertificate"
	oProps              := &cJsonObj
	oProps["field"]     := "type"
	oProps["visible"]   := .F.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)
 
	oProps              := &cJsonObj
	oProps["field"]     := "reason"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps) 
 EndIf

 If nLenParms > 1 .And. Lower(::aURLParms[2]) == "clockingupdate"
    oProps              := &cJsonObj
	oProps["field"]     := "hour"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)

    oProps              := &cJsonObj
    oProps["field"]     := "justify"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)
    
    oProps              := &cJsonObj
    oProps["field"]     := "reason"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)
    
    oProps              := &cJsonObj
    oProps["field"]     := "direction"
	oProps["visible"]   := .F.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)
 EndIf

 If nLenParms > 1 .And. Lower(::aURLParms[2]) == "clocking"
	oProps              := &cJsonObj
	oProps["field"]     := "balanceSummary"
	oProps["visible"]   := .T.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)
 EndIf

 If nLenParms > 1 .And. Lower(::aURLParms[2]) == "payment"
 	oProps              := &cJsonObj
	oProps["field"]     := "download"
	oProps["visible"]   := .T.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)
 EndIf

 If nLenParms > 1 .And. Lower(::aURLParms[2]) == "clockingregister"
	oProps              := &cJsonObj
	oProps["field"]     := "hour"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)

	oProps              := &cJsonObj
	oProps["field"]     := "justify"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)

	oProps              := &cJsonObj
	oProps["field"]     := "reason"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)

	oProps              := &cJsonObj
	oProps["field"]     := "direction"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)
 EndIf

 If nLenParms > 1 .And. Lower(::aURLParms[2]) == "substituterequest"
	oProps              := &cJsonObj
	oProps["field"]     := "canViewSalary"
	oProps["visible"]   := .F.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)

	oProps              := &cJsonObj
	oProps["field"]     := "canManageTeam"
	oProps["visible"]   := .F.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)

	oProps              := &cJsonObj
	oProps["field"]     := "divisions"
	oProps["visible"]   := .T.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)
 EndIf

 If nLenParms > 1 .And. Lower(::aURLParms[2]) == "clockinggeoupdate"
	oProps              := &cJsonObj
	oProps["field"]     := "justify"
	oProps["visible"]   := .T.
	oProps["editable"]  := .T.
	oProps["required"]  := .T.
	Aadd(aData,oProps)

	oProps              := &cJsonObj
	oProps["field"]     := "reason"
	oProps["visible"]   := .F.
	oProps["editable"]  := .F.
	oProps["required"]  := .F.
	Aadd(aData,oProps)
 EndIf

 If !Empty(::aURLParms[1]) .And. ::aURLParms[2] == "vacation"
   oProps              := &cJsonObj
   oProps["field"]     := "justify"
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   oProps              := &cJsonObj
   oProps["field"]     := "indirectSubordinatesLevel"
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   oProps              := &cJsonObj
   oProps["field"]     := "hierarchicalLevel"
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)
 EndIf

 If !Empty(::aURLParms[1]) .And. ::aURLParms[2] == "profile"
   oProps              := &cJsonObj
   oProps["field"]     := "positionLevel"
   oProps["visible"]   := .T.
   oProps["editable"]  := .T.
   oProps["required"]  := .T.
   Aadd(aData,oProps)

   oProps              := &cJsonObj
   oProps["field"]     := "registry"
   oProps["visible"]   := .T.
   oProps["editable"]  := .T.
   oProps["required"]  := .T.
   Aadd(aData,oProps)

   oProps              := &cJsonObj
   oProps["field"]     := "department"
   oProps["visible"]   := .T.
   oProps["editable"]  := .T.
   oProps["required"]  := .T.
   Aadd(aData,oProps)

   oProps              := &cJsonObj
   oProps["field"]     := "admissionDate"
   oProps["visible"]   := .T.
   oProps["editable"]  := .T.
   oProps["required"]  := .T.
   Aadd(aData,oProps)

   //******* Summary
   oProps              := &cJsonObj
   oProps["field"]     := "summary. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   //******* teams
   oProps              := &cJsonObj
   oProps["field"]     := "teams. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   //******* coordinator
   oProps              := &cJsonObj
   oProps["field"]     := "coordinator. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   //******* personalData
   oProps              := &cJsonObj
   oProps["field"]     := "personalData. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   //******* addresses
   oProps              := &cJsonObj
   oProps["field"]     := "addresses. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   //******* contacts
   oProps              := &cJsonObj
   oProps["field"]     := "contacts. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   //******* webReferences
   oProps              := &cJsonObj
   oProps["field"]     := "webReferences. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)

   //******* documents
   oProps              := &cJsonObj
   oProps["field"]     := "documents. "
   oProps["visible"]   := .F.
   oProps["editable"]  := .F.
   oProps["required"]  := .F.
   Aadd(aData,oProps)
 EndIf


  oItem["hasNext"]  := .F.
  oItem["items"]    := aData

  cJson := FWJsonSerialize(oItem, .F., .F., .T.)
  ::SetResponse(cJson)

Return(.T.)



// -------------------------------------------------------------------
// -------------------------------------------------------------------
// - FUNCIONALIDADES DIVERSAS DO SERVI�O.
// -------------------------------------------------------------------

/*/{Protheus.doc}getMultV()
- Prepara os dados para o caregamento de m�ltiplos v�nculos do usu�rio.
@author:	Marcelo Faria
/*/

Function getMultV(cBranchVld,cMatSRA,cLogin,cJsonObj,aDadosCtx,aItemCtx,lContext)

Local nI            := 0
Local aInfo         := {}
Local aRet          := {}
Local aDadosFunc    := {}
Local oItemData     := Nil

Default cBranchVld  := FwCodFil()
Default cMatSRA     := ""
Default cLogin      := ""
Default cJsonObj    := "JsonObject():New()"
DEFAULT aDadosCtx   := {}
DEFAULT aItemCtx    := {}


//Busca todas as matr�culas do usu�rio logado
If lContext .and. MatParticipant(cLogin, @aRet, .T.)

    For nI := 1 to len(aRet)

        //busca dados passando filial e matr�cula
        If fGetFunc(aRet[nI,3], aRet[nI,1], @aDadosFunc)

            oItemData                 :=  &cJsonObj
            oItemData["employeeType"] := "internal"

            //descri��o do departamento
            oItemData["branchName"]   := alltrim(EncodeUTF8(fDesc('SQB',aDadosFunc[1][2],'SQB->QB_DESCRIC',,,1)))

            //dados do funcion�rio para autentica��o (Filial+Mat+Codigo)
            oItemData["employeeID"]   := aRet[nI,3]+"|"+aRet[nI,1]+"|"+RD0->RD0_CODIGO

            //verifica situa��o atual
            If SRA->RA_SITFOLH == "D" .And. SRA->RA_RESCRAI $ '30/31'
               oItemData["status"]    := "inactive"
            Else
               oItemData["status"]    := "active"
            EndIf

            //identifica qual a matr�cula corrente do funcion�rio
            //If nI == 1
            If alltrim(aRet[nI,1]) == cMatSRA
                oItemData["current"]  := .T.
            Else
                oItemData["current"]  := .F.
            EndIf

            If !fInfo(@aInfo,cBranchVld)
                oItemData["companyName"] := ""
            Else
                //descri��o da filial/empresa
                oItemData["companyName"] := alltrim(aInfo[1]) +'/' +alltrim(aInfo[2])
            EndIf


            //carrega matr�cula localizada
            Aadd(aDadosCtx,oItemData)
            oItemData := Nil
        Endif

    Next

Else

    //Carrega apenas o contexto da matr�cula atual
    If fGetFunc(cBranchVld, cMatSRA, @aDadosFunc)

        oItemData                 :=  &cJsonObj
        oItemData["employeeType"] := "internal"

        //descri��o do departamento
        oItemData["branchName"]   := EncodeUTF8(fDesc('SQB',aDadosFunc[1][2],'SQB->QB_DESCRIC',,,1))

        //dados do funcion�rio para autentica��o (Filial+Mat+Codigo)
        oItemData["employeeID"]   := cBranchVld+"|"+cMatSRA+"|"+RD0->RD0_CODIGO

        //verifica situa��o atual
        If SRA->RA_SITFOLH == "D" .And. SRA->RA_RESCRAI $ '30/31'
           oItemData["status"]    := "inactive"
        Else
           oItemData["status"]    := "active"
        EndIf

        //identifica qual a matr�cula corrente do funcion�rio
        oItemData["current"]  := .T.

        If !fInfo(@aInfo,cBranchVld)
            oItemData["companyName"] := ""
        Else
           //descri��o da filial/empresa
           oItemData["companyName"] := alltrim(aInfo[1]) +'/' +alltrim(aInfo[2])
        EndIf

        //carrega matr�cula localizada
        Aadd(aItemCtx,oItemData["employeeID"])
        Aadd(aItemCtx,oItemData["branchName"])
        Aadd(aItemCtx,oItemData["companyName"])

        //carrega matr�cula localizada
        Aadd(aDadosCtx,oItemData)
        oItemData := Nil
    Endif

EndIf

Return(Nil)


/*/{Protheus.doc}resultSetContext()
- Prepara o json para retorno de atualzia��o do contextocontext

@author:    Marcelo Faria
/*/

Function resultSetContext(aItemCtx,lSet)
Local cRet := ""
Local cMsg := ""

DEFAULT aItemCtx := {}
DEFAULT lSet     := .F.

/*
cRetorno :=   '{  "data": {  "data": {"branchName": "COORDENACAO RH MOBILE",';
            + '"companyName":"Filial BELO HOR/Grupo TOTVS 1",'  ;
            + '"current":true,'                                 ;
            + '"employeeID":"D MG 01 |00502 |000206",'          ;
            + '"employeeType":"internal",'                      ;
            + '"status":"active" }, '                           ;
            + '"length": 1 ,'                                   ;
            + '"messages": {"code": null, "type": "success", "detail": "result ok"} } }'
*/

If len(aItemCtx) > 0

   cRet  :=   '{  "data": { '                                               ;
            + '"employeeType":"internal",'                                  ;
            + '"status":"active",'                                          ;
            + '"employeeID":"' +aItemCtx[1]                           +'",' ; //"D MG 01 |00502 |000206
            + '"branchName":"' +EncodeUTF8(aItemCtx[2])               +'",' ; //COORDENACAO RH MOBILE
            + '"companyName":"'+EncodeUTF8(aItemCtx[3])               +'",' ; //Filial BELO HOR/Grupo TOTVS 1
            + '"current":true'                                              ;
            + '},'                                                          ;
            + '"messages": [{'                                              ;
            + '"code": null,'                                               ;
            + '"type": "success",'                                          ;
            + '"detail": "'   +'Contexto alterado com sucesso!'       +'"'  ; //Contexto alterado com sucesso!
            + '}],'                                                         ;
            + '"length": 1 ,'                                               ;
            + '"HttpStatusCode": 200'                                       ;
            + '}'

Else

   If lSet
      //PUT Context
      cMsg := EncodeUTF8(STR0009) //"N�o foi poss�vel atualizar o contexto!"
   Else
      //Get Context
      cMsg := EncodeUTF8(STR0010) //"N�o foi poss�vel buscar o contexto!"
   Endif

   cRet  :=   '{  "data": { '                                   ;
            + '"employeeType":"",'                              ;
            + '"status":"",'                                    ;
            + '"employeeID":"",'                                ;
            + '"branchName": "",'                               ;
            + '"companyName":"",'                               ;
            + '"current":false'                                 ;
            + '},'                                              ;
            + '"messages": [{'                                  ;
            + '"code": 204,'                                    ;
            + '"type": "error",'                                ;
            + '"detail": ' +'"' +cMsg +'"'                      ;
            + '}],'                                             ;
            + '"length": 1 ,'                                   ;
            + '"HttpStatusCode": 204'                           ;
            + '}'
Endif

Return(cRet)

/*/{Protheus.doc} fGetTeamManager
- Respons�vel por indicar se uma determinada matricula � respons�vel por algum departamento

@author:	Marcelo Silveira
@since:		28/02/2018
@param:		Filial que sera pesquisada;
			Matricula que sera pesquisada;
@Return:	lLeadTeam - Verdadeiro se o funcionario � respons�vel por algum departamento
/*/
Function fGetTeamManager(cFilTeam, cMatTeam)

Local aAreaSQB	:= SQB->( GetArea() )
Local cQuery 	:= GetNextAlias()
Local lLeadTeam	:= .F.

DEFAULT cFilTeam := ""
DEFAULT cMatTeam := ""

BEGINSQL ALIAS cQuery

	SELECT COUNT(*) NQTD
		FROM %table:SQB% SQB
	WHERE QB_FILRESP = %Exp:cFilTeam% AND
	      QB_MATRESP = %Exp:cMatTeam% AND
	   	  SQB.%NotDel%

ENDSQL

If (cQuery)->(!Eof())
	lLeadTeam := (cQuery)->NQTD > 0
EndIf

(cQuery)->( DBCloseArea() )
RestArea(aAreaSQB)

Return( lLeadTeam )
