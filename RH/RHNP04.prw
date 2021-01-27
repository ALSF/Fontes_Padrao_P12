#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"

#INCLUDE "RHNP04.CH"

Function RHNP04()
Return .T.


WSRESTFUL Request DESCRIPTION STR0001 //"Notificações"

WSDATA employeeId	As String Optional
WSDATA WsNull		As String Optional
WSDATA type		As String Optional


WSMETHOD GET notifyCount ;
 DESCRIPTION STR0002 ; //"Retorna a quantidade de pendências - OLD SERVICE."
 WSSYNTAX "/notify/count/{employeeId}" ;
 PATH "/notify/count/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

//method getCount -> function countNotifications() -> não operacionais
WSMETHOD GET getCount ;
 DESCRIPTION STR0003 ; //"Retorna a quantidade de pendências."
 WSSYNTAX "/notifications/count/{employeeId}" ;
 PATH "/notifications/count/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET getNotifications ;
 DESCRIPTION STR0004 ; //"Retorna as pendências do usuário."
 WSSYNTAX "/notifications/{employeeId}" ;
 PATH "/notifications/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD PUT editNotifications ;
 DESCRIPTION STR0005 ; //"Aprova ou Reprova notificações."
 WSSYNTAX "/notifications/{employeeId}" ;
 PATH "/notifications/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

END WSRESTFUL


WSMETHOD GET getCount PATHPARAM employeeId WSREST Request

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItemData	 	:= &cJsonObj
Local oItem		 	:= &cJsonObj
Local oMessages	  	:= &cJsonObj
Local nLenParms	 	:= Len(::aURLParms)
Local cMatSRA		:= ""
Local cBranchVld	:= ""
Local cToken	  	:= ""
Local cSubMat		:= ""
Local cSubBranch	:= ""
Local cSubDepts		:= ""
Local nX			:= 0
Local aSubstitute	:= {}
Local aMessages		:= {}
Local lAuth    		:= .T.
Local lSubstitute	:= .F.

cToken  := Self:GetHeader('Authorization')

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)

If Empty(cMatSRA) .Or. Empty(cBranchVld)

   ::SetHeader('Status', "401")

	oMessages["type"]   := "error"
	oMessages["code"]   := "401"
	oMessages["detail"] := EncodeUTF8(STR0006) //"Dados inválidos."

	Aadd(aMessages,oMessages)
	lAuth := .F.

EndIf

If lAuth .And. nLenParms == 3 .And. !Empty(::aURLParms[3])

	//Verifica se o funcionario esta substituindo o seu superior
	aSubstitute := fGetSupNotify( cBranchVld, cMatSRA, .T. )

	If Len(aSubstitute) > 0
		For nX := 1 To Len(aSubstitute)
			cSubBranch += "'" + aSubstitute[nX, 1] + "',"
			cSubMat	+= "'" + aSubstitute[nX, 2] + "',"
			cSubDepts += aSubstitute[nX, 3]
		Next nX
		cSubMat		:= SubStr( cSubMat, 1, Len(cSubMat)-1 )
		cSubBranch	:= SubStr( cSubBranch, 1, Len(cSubBranch)-1 )
		cSubDepts	:= SubStr( cSubDepts, 1, Len(cSubDepts)-1 )
		lSubstitute	:= .T.
	Else
		cSubMat	:= "'" + cMatSRA + "'"
		cSubBranch := "'" + cBranchVld + "'"
	EndIf

	countNotifications(cSubMat,cJsonObj,@oItemData,cSubBranch,cSubDepts)
EndIf

// - Por por padrão todo objeto tem
// - data: contendo a estrutura do JSON
// - messages: para determinados avisos
// - length: informativo sobre o tamanho.
oItem["data"] 		  := oItemData
oItem["messages"] 	  := aMessages
oItem["length"]   	  := 1 //- TODO: verify

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)


WSMETHOD GET getNotifications PATHPARAM employeeId WSREST Request

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItemData	 	:= &cJsonObj
Local oItem		 	:= &cJsonObj
Local oMessages		:= &cJsonObj
Local nX			:= 0
Local aMessages		:= {}
Local aItems		:= {}
Local cMatSRA		:= ""
Local cMatLogin		:= ""
Local cBranchVld	:= ""
Local cSubMat		:= ""
Local cSubBranch	:= ""
Local cSubDepts		:= ""
Local cTypeFilter	:= ""
Local lAuth			:= .T.


// - Parâmetros enviados pela URL - QueryString
DEFAULT Self:type 	:= ""

cTypeFilter := Self:type

cToken  := Self:GetHeader('Authorization')

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cMatLogin  := cMatSRA

If Empty(cMatSRA) .Or. Empty(cBranchVld)

	oMessages["type"]   := "info"
	oMessages["code"]   := "401"
	oMessages["detail"] := EncodeUTF8(STR0007) //"As notificações não foram encontradas."

	Aadd(aMessages,oMessages)
	lAuth := .F.

EndIf

If lAuth

	//Verifica se o funcionario esta substituindo o seu superior
	aSubstitute := fGetSupNotify( cBranchVld, cMatSRA, .T. )

	If Len(aSubstitute) > 0
		For nX := 1 To Len(aSubstitute)
			cSubMat	+= "'" + aSubstitute[nX, 2] + "',"
			cSubBranch += "'" + aSubstitute[nX, 1] + "',"
			cSubDepts += aSubstitute[nX, 3]
		Next nX
		cSubMat		:= SubStr( cSubMat, 1, Len(cSubMat)-1 )
		cSubBranch	:= SubStr( cSubBranch, 1, Len(cSubBranch)-1 )
		cSubDepts	:= SubStr( cSubDepts, 1, Len(cSubDepts)-1 )
		cMatLogin	:= "" //Quando substitui seu gestor o funcionario pode ver suas proprias solicitacoes
	Else
		cSubMat	:= "'" + cMatSRA + "'"
		cSubBranch := "'" + cBranchVld + "'"
	EndIf

	getNotifications(cSubMat,cJsonObj,@oItemData,cSubBranch,@aItems,cTypeFilter,cMatLogin,cSubDepts)
EndIf

oItem["hasNext"] 	  := .T.
oItem["items"] 	  := aItems

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)

Function getNotifications(cMatSRA,cJsonObj,oItemData,cBranchVld,aItems,cTypeFilter,cMatAprov,cSubDepts)

Local nI			:= 0
Local cQuery		:= GetNextAlias()
Local cQuerySRF		:= GetNextAlias()
Local aArea			:= GetArea()
Local cBranch		:= xFilial("RH3")
Local cBranchSRA	:= xFilial("SRA")
Local cType 		:= "'B','8','Z'"
Local oFields		:= Nil
Local oEmployee		:= Nil
Local oProps		:= Nil
Local aFields		:= {}
Local aExtFields	:= {}
Local aEmployee		:= {}
Local aSeqClock		:= {}
Local cWhere		:= ""
Local cAux			:= ""
Local cAuxCode		:= ""
Local cJustify		:= ""

Default cJsonObj	:= "JsonObject():New()"
Default oItemData	:= &cJsonObj
Default cMatSRA		:= ""
Default cMatAprov	:= ""
Default cBranchVld	:= FwCodFil()
Default aItems		:= {}
Default cTypeFilter	:= ""
Default cSubDepts	:= ""

oFields   := &cJsonObj
oEmployee := &cJsonObj

//Retorna uma matriz com entrada/saida de cada dia para classificar as marcacoes do espelho
aSeqClock := fGetSeqClock(cBranch, cMatSRA, cMatAprov)

If ! Empty(cTypeFilter)
	If Lower(cTypeFilter) == "allowance"
		cType := "'8'"
	ElseIf Lower(cTypeFilter) == "clocking"
		cType := "'Z'"
	Elseif Lower(cTypeFilter) == "vacation"
		cType := "'B'"
	EndIf
EndIf

cWhere := "%"
cWhere += " RH3.RH3_FILAPR IN (" + cBranchVld + ") AND "
cWhere += " RH3.RH3_MATAPR IN (" + cMatSRA + ") AND "
cWhere += " RH3.RH3_TIPO IN (" + cType + ") "

If !Empty( cSubDepts )

	cWhere += " AND SRA.RA_DEPTO IN (" + cSubDepts + ") "
	cWhere += "%"

	BEGINSQL ALIAS cQuery

	    SELECT RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH3.RH3_MAT, RH3.RH3_DTSOLI,RH3.RH3_VISAO, RH3.RH3_FILINI, RH3.RH3_MATINI, RH3.RH3_FILAPR, RH3.RH3_MATAPR, RH3.RH3_STATUS, RH3.RH3_TIPO
		   	   FROM %table:RH3% RH3
	    INNER JOIN %table:SRA% SRA
	           ON RH3_FILIAL = RA_FILIAL AND RH3_MAT = RA_MAT
	    WHERE RH3.RH3_MAT <> %Exp:cMatAprov% AND
			   RH3.RH3_STATUS = '1' AND
	          %Exp:cWhere% AND
	          RH3.%NotDel%

	ENDSQL

Else

	cWhere += "%"

	BEGINSQL ALIAS cQuery

	    SELECT RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH3.RH3_MAT, RH3.RH3_DTSOLI,RH3.RH3_VISAO, RH3.RH3_FILINI, RH3.RH3_MATINI, RH3.RH3_FILAPR, RH3.RH3_MATAPR, RH3.RH3_STATUS, RH3.RH3_TIPO
		   	   FROM %table:RH3% RH3
	    WHERE RH3.RH3_MAT <> %Exp:cMatAprov% AND
			   RH3.RH3_STATUS = '1' AND
	          %Exp:cWhere% AND
	          RH3.%NotDel%

	ENDSQL

EndIf

While (cQuery)->(!Eof())

	oItemData	:= &cJsonObj

	oItemData["id"] 			 := (cQuery)->RH3_FILIAL + (cQuery)->RH3_MAT + (cQuery)->RH3_CODIGO + (cQuery)->RH3_MATAPR
	oItemData["type"]			 := GetENUMDecode((cQuery)->RH3_TIPO)
	oItemData["canApprove"] 	 := Iif((cQuery)->RH3_MATAPR $ cMatSRA, .T., .F.)

	oEmployee 					 := &cJsonObj
	aEmployee 					 := getSummary((cQuery)->RH3_MAT, (cQuery)->RH3_FILIAL)
	oEmployee["id"] 			 := cBranchSRA + aEmployee[1]
	oEmployee["name"]			 := aEmployee[2]
	oEmployee["roleDescription"] := aEmployee[3]

	oItemData["employeeSummary"] := oEmployee

	If RH4->(dbSeek(xFilial("RH4", (cQuery)->RH3_FILIAL) + (cQuery)->RH3_CODIGO ))
		While RH4->(!Eof())

			oFields := &cJsonObj
			If RH4->RH4_CODIGO == (cQuery)->RH3_CODIGO
			 	getFields(@oFields, (cQuery)->RH3_TIPO, (cQuery)->RH3_CODIGO, aSeqClock)
			 	If !empty(oFields['type'])
     			 	Aadd(aFields,oFields)
     			EndIf
			Else
				EXIT
			EndIf

			cAux     := (cQuery)->RH3_MAT
			cAuxCode := (cQuery)->RH3_CODIGO
 			RH4->(DbSkip())
		EndDo
	EndIf


    If (cQuery)->RH3_TIPO == "B"

       //Busca período aquisitivo atual em aberto
       BEGINSQL ALIAS cQuerySRF
          SELECT *
          FROM %Table:SRF% SRF
          WHERE
              SRF.RF_FILIAL = %Exp:(cQuery)->RH3_FILIAL% AND
              SRF.RF_MAT    = %Exp:(cQuery)->RH3_MAT%    AND
              SRF.RF_STATUS = '1'                        AND
              SRF.%NotDel%
       ENDSQL

       IF  (cQuerySRF)->(!Eof())
            oFields := &cJsonObj
            oFields["type"]  := "initVacationLimit"
            oFields["value"] := "2018-06-01T12:00:00Z"
            Aadd(aFields, oFields)

            oFields := &cJsonObj
            oFields["type"]  := "endVacationLimit"
            oFields["value"] := "2019-06-01T12:00:00Z"
            Aadd(aFields, oFields)
       EndIf

       (cQuerySRF)->( DBCloseArea() )

    EndIf

    //Busca justificativas (nao considera marcacoes que ja possui tratamento especifico)
    If !(cQuery)->RH3_TIPO == "Z"
	    cJustify := getRGKJustify((cQuery)->RH3_FILIAL,(cQuery)->RH3_CODIGO)
	    If !empty(cJustify)
	       oFields := &cJsonObj
	       oFields["type"]  := "justify"
	       oFields["value"] := cJustify

	       //Libera campo de justificativa
	       oProps := &cJsonObj
	       oProps["field"]     := "justify"
	       oProps["visible"]   := .T.
	       oProps["editable"]  := .F.
	       oProps["required"]  := .F.

	       oFields["props"]    := oProps
	       Aadd(aFields, oFields)
	    Else
	       oFields := &cJsonObj
	       oFields["type"]  := "justify"
	       oFields["value"] := ""
	       Aadd(aFields, oFields)
	    EndIf
    EndIf

    //Inicializa campos contrato
    aExtFields := getInitFields((cQuery)->RH3_TIPO)
    For nI := 1 To Len(aExtFields)
        oFields := &cJsonObj
        oFields["type"]  := aExtFields[nI][1]
        oFields["value"] := aExtFields[nI][2]

        //Inclui properties como atributo do campo caso o elemento 3 seja verdadeiro
        If aExtFields[nI][3]
        	oProps := &cJsonObj
        	oProps["field"]     := aExtFields[nI][1]
        	oProps["visible"]   := aExtFields[nI][4]
        	oProps["editable"]  := aExtFields[nI][5]
        	oProps["required"]  := aExtFields[nI][6]
        	oFields["props"]    := oProps
        EndIf

        Aadd(aFields, oFields)
    Next nI


    //Carrega Fields
    oItemData["fields"] := aFields
    aFields             := {}
    Aadd(aItems,oItemData)


	(cQuery)->(DbSkip())
EndDo

(cQuery)->( DBCloseArea() )

RestArea(aArea)

Return(Nil)


/*/{Protheus.doc}countNotifications()
- Efetua a contagem das notificações do usuário logado.

@author:	Matheus Bizutti
/*/
Function countNotifications(cMatSRA,cJsonObj,oItemData,cBranchVld,cSubDepts)

Local nI            := 0
Local nQtdTotal     := 0
Local nQtdParcial   := 0
Local cType         := "'8','B','Z'"
Local aData         := {}
Local aRequests     := {}
Local aSubTotals    := {}
Local oSubTotals    := Nil
Local cTypeAux      := ""
Local cWhere		:= ""
Local cQuery        := GetNextAlias()

Default cJsonObj    := "JsonObject():New()"
Default oItemData   := &cJsonObj
Default cMatSRA     := ""
Default cBranchVld  := FwCodFil()
Default cSubDepts	:= ""

oSubTotals := &cJsonObj

cWhere := "%"
cWhere += " RH3.RH3_FILAPR IN (" + cBranchVld + ") AND "
cWhere += " RH3.RH3_MATAPR IN (" + cMatSRA + ") AND "
cWhere += " RH3.RH3_TIPO IN (" + cType + ") "

//Quando o funcionario esta substituindo seu gestor
If !Empty( cSubDepts )

	cWhere += " AND SRA.RA_DEPTO IN (" + cSubDepts + ") "
	cWhere += "%"

	BEGINSQL ALIAS cQuery

	    SELECT RH3.RH3_TIPO, COUNT(*) QTD
	           FROM %table:RH3% RH3
	    INNER JOIN %table:SRA% SRA
	           ON RH3_FILIAL = RA_FILIAL AND RH3_MAT = RA_MAT
	    WHERE  RH3.RH3_STATUS = '1' AND
	          %Exp:cWhere% AND
	          RH3.%NotDel% AND SRA.%NotDel%
	    GROUP BY RH3.RH3_TIPO

	ENDSQL
Else

	cWhere += "%"

	BEGINSQL ALIAS cQuery

	    SELECT RH3.RH3_TIPO, COUNT(*) QTD
	           FROM %table:RH3% RH3
	    WHERE  RH3.RH3_STATUS = '1' AND
	          %Exp:cWhere% AND
	          RH3.%NotDel%
	    GROUP BY RH3.RH3_TIPO

	ENDSQL

EndIf

cTypeAux := (cQuery)->RH3_TIPO

While (cQuery)->(!Eof())

    nQtdTotal   += (cQuery)->QTD

    oSubTotals := &cJsonObj
    oSubTotals["type"]  := GetENUMDecode( (cQuery)->RH3_TIPO )
    oSubTotals["total"] := (cQuery)->QTD
    Aadd(aData,oSubTotals)

    (cQuery)->(DbSkip())
EndDo

(cQuery)->( DBCloseArea() )

If nQtdTotal > 0
	oItemData["subtotals"] 	:= aData
	oItemData["total"] 		:= nQtdTotal
EndIf

Return(Nil)


Static Function typeNotifications(cType,aRequests,cMatSRA)

Local nI 				:= 0
Local nQtdSubTotals	:= 0
Local aReturn			:= {}

Default aRequests		:= {}
Default cType			:= ""
Default cMatSRA		:= ""

For nI := 1  To Len(aRequests)
	If Alltrim(aRequests[nI]:Registration) == Alltrim(cMatSRA) .Or. Alltrim(cMatSRA) != Alltrim(aRequests[nI]:ApproverRegistration)
		Loop
	Else
		If aRequests[nI]:RequestType:Code == cType .And. aRequests[nI]:Status:Code == "1"
			nQtdSubTotals += 1
		EndIf
	EndIf
Next nI

Aadd(aReturn,nQtdSubTotals)
Aadd(aReturn,GetENUMDecode(cType))

Return aReturn


Static Function getFields(oFields,cTypeRequest,cCodRH4,aSeqClock)

Local lNextValue	:= .T.
Local nPos			:= 0
Local cCpoRH4		:= AllTrim(RH4->RH4_CAMPO)
Local cJsonObj    	:= "JsonObject():New()"
Local oProps		:= Nil

Default cTypeRequest := ""
Default cCodRH4 := ""
Default aSeqClock := {}

DO CASE
	CASE cTypeRequest == "B" // VACATION
		If cCpoRH4 == "R8_DATAINI"
			oFields["type"]        := EncodeUTF8("initDate")
			oFields["value"]       := formatGMT(Alltrim(RH4->RH4_VALNOV))
		ElseIf cCpoRH4 == "R8_DATAFIM"
		  	oFields["type"]        := EncodeUTF8("endDate")
		  	oFields["value"]       := formatGMT(Alltrim(RH4->RH4_VALNOV))
		ElseIf cCpoRH4 == "R8_DURACAO"
			oFields["type"]        := EncodeUTF8("totalDays")
          oFields["value"]        := Alltrim(RH4->RH4_VALNOV)
		Elseif cCpoRH4 == "TMP_DABONO"
			oFields["type"]        := EncodeUTF8("vacationBonus")
          oFields["value"]        := Alltrim(RH4->RH4_VALNOV)
       Else
          oFields["type"]         := ""
          oFields["value"]        := ""
       EndIf

	CASE cTypeRequest == "Z" // CLOCKING
		If cCpoRH4 == "P8_DATA"
			oFields["type"] := EncodeUTF8("initDate")
			oFields["value"] := formatGMT(Alltrim(RH4->RH4_VALNOV))
		ElseIf cCpoRH4 == "P8_HORA"
			oFields["type"] := EncodeUTF8("initHour")
			oFields["value"] := HourToMs(strZero( Val(Alltrim(RH4->RH4_VALNOV)), 5, 2))
		ElseIf cCpoRH4 == "TMP_TEXT"
		  	oFields["type"] := EncodeUTF8("justify")
			oFields["value"] := EncodeUTF8(Alltrim(RH4->RH4_VALNOV))

			//Adiciona o properties
			oProps := &cJsonObj
			oProps["field"]     := "justify"
			oProps["visible"]   := .T.
			oProps["editable"]  := .F.
			oProps["required"]  := .F.

			oFields["props"]    := oProps

		ElseIf cCpoRH4 == "TMP_NOME"
			//Define o sentido - Entrada/Saida
			nPos := aScan(aSeqClock, {|x| x[4] == cCodRH4} )
			If nPos > 0
				oFields["type"] := EncodeUTF8("direction")
				oFields["value"] := aSeqClock[nPos,3]
			EndIf
		EndIf

	CASE cTypeRequest == "8"
		If cCpoRH4 == "RF0_DTPREI"
			oFields["type"] := EncodeUTF8("initDate")
			oFields["value"] := formatGMT(Alltrim(RH4->RH4_VALNOV))

		ElseIf cCpoRH4 == "RF0_DTPREF"
		  	oFields["type"] := EncodeUTF8("endDate")
			oFields["value"] := formatGMT(Alltrim(RH4->RH4_VALNOV))
		ElseIf cCpoRH4 == "RF0_HORINI"
			oFields["type"] := EncodeUTF8("initHour")
			oFields["value"] := HourToMs(Alltrim(RH4->RH4_VALNOV))
		ElseIf cCpoRH4 == "RF0_HORFIM"
			oFields["type"] := EncodeUTF8("endHour")
			oFields["value"] := HourToMs(Alltrim(RH4->RH4_VALNOV))
		ElseIf cCpoRH4 == "TMP_ABOND"
			oFields["type"] := EncodeUTF8("reason")
			oFields["value"] := EncodeUTF8(Alltrim(RH4->RH4_VALNOV))
		EndIf

ENDCASE

Return(Nil)


Static Function getInitFields(cTypeRequest)
Local aInitFields := {}

Default cTypeRequest := ""

//Inicializa o campo e tambem o properties a partir do terceiro elemento:
//Aadd( aInitFields, { /*Type*/, /*Value*/, /*lProperties*/, /*lvisible*/, /*leditable*/, /*lrequired*/ } )

If cTypeRequest $ "B/8" // VACATION/allowance
	Aadd( aInitFields, {"totalHours", "", .F., .F., .F., .F. } )
    Aadd( aInitFields, {"status"    , "", .F., .F., .F., .F. } )
    Aadd( aInitFields, {"direction" , "", .F., .F., .F., .F. } )
    Aadd( aInitFields, {"initHour"  , "", .F., .F., .F., .F. } )
    Aadd( aInitFields, {"endHour"   , "", .F., .F., .F., .F. } )
    Aadd( aInitFields, {"other"     , "", .F., .F., .F., .F. } )

    If cTypeRequest == "B"
    	Aadd( aInitFields, {"reason", "", .F., .F., .F., .F. } )
    EndIf
EndIf

If cTypeRequest == "Z"
	Aadd( aInitFields, {"reason"	, "", .T., .F., .F., .F. } )
EndIf

Return(aInitFields)



// -------------------------------------------------------------------
// - PUT RESPONSÁVEL POR APROVAR OU REPROVAR NOTIFICAÇÕES PENDENTES.
// -------------------------------------------------------------------

WSMETHOD PUT editNotifications PATHPARAM employeeId WSREST Request

Local cBody 		:= ::GetContent()
Local aUrlParam	:= ::aUrlParms
Local cJsonObj	:= "JsonObject():New()"
Local oJson       := &cJsonObj
Local oItem		:= &cJsonObj
Local oItemDetail	:= &cJsonObj
Local cJson		:= ""
Local cToken		:= ""

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken  := Self:GetHeader('Authorization')

EditRH3(aUrlParam,cBody,cJsonObj,oItem,oItemDetail,cToken,.T.)

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return (.T.)


Static Function formatGMT(cValue)

Local cDateFormat	:= ""
Local cReturn		:= ""
Local aDateFormat	:= {}

Default cValue	:= ""

cDateFormat := DTOS(CTOD(Alltrim(cValue)))
aDateFormat := LocalToUTC( cDateFormat, "12:00:00" )

cReturn := Iif(Empty(aDateFormat),"",Substr(aDateFormat[1],1,4) + "-" + Substr(aDateFormat[1],5,2) + "-" + Substr(aDateFormat[1],7,2) + "T" + "12:00:00" + "Z")

cDateFormat := ""
aDateFormat := {}

Return(cReturn)


// ------------------------------------------------------------------
/*
- UTILIZADO PARA CONVIVÊNCIA
- PORTAL 12.1.17 sem convivência
- e PORTAL 12.1.20 - Com migração do angular 4 e novos serviços.
*/
// -------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

WSMETHOD GET notifyCount PATHPARAM employeeId WSREST Request

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItemData	 	:= &cJsonObj
Local oItem		 	:= &cJsonObj
Local oMessages	  	:= &cJsonObj
Local nLenParms	 	:= Len(::aURLParms)
Local cMatSRA			:= ""
Local aMessages		:= {}
Local cBranchVld		:= ""
Local lAuth    		:= .T.
Local cToken	  		:= ""

cToken  := Self:GetHeader('Authorization')

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)

If Empty(cMatSRA) .Or. Empty(cBranchVld)

	oMessages["code"] 	:= "401"
	oMessages["message"]	:= "info"
	oMessages["detailedMessage"] := EncodeUTF8(STR0006) //"Dados inválidos."

	Aadd(aMessages,oMessages)
	lAuth := .F.

EndIf

If lAuth .And. nLenParms == 3 .And. !Empty(::aURLParms[3])
	GetNotifys(cMatSRA,cJsonObj,@oItemData,cBranchVld)
EndIf

// - Por por padrão todo objeto tem
// - data: contendo a estrutura do JSON
// - messages: para determinados avisos
// - length: informativo sobre o tamanho.
oItem["data"] 		  := oItemData
oItem["messages"] 	  := aMessages
oItem["length"]   	  := 1 //- TODO: verify

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)

/*/{Protheus.doc}GetNotifys()
- Efetua a contagem das notificações do usuário logado.

@author:	Matheus Bizutti
/*/
Function GetNotifys(cMatSRA,cJsonObj,oItemData,cBranchVld)

Local nI			:= 0
Local nQtd			:= 0
Local cType 		:= "'B','8'" //"'8','B'"
Local aData		:= {}
Local aEnum		:= {}
Local aRequests	:= {}
Local oSubTotals	:= Nil

Default cJsonObj	:= "JsonObject():New()"
Default oItemData	:= &cJsonObj
Default cMatSRA 	:= ""
Default cBranchVld	:= FwCodFil()

oSubTotals := &cJsonObj
Aadd(aEnum,"vacation")
Aadd(aEnum,"allowance")
Aadd(aEnum,"clocking")

aRequests := fGetAllReq(cBranchVld, cMatSRA, cType, 0, "", "", .F., "", .T., .F., .F., .T.)
//varinfo("Filial/Mat: ",cBranchVld +"/" +cMatSRA)
//varinfo("aRequests: ",aRequests)

For nI := 1 To Len(aRequests)

	If Alltrim(aRequests[nI]:Registration) == Alltrim(cMatSRA) .Or. Alltrim(cMatSRA) != Alltrim(aRequests[nI]:ApproverRegistration)
		Loop
	EndIf

	If aRequests[nI]:Status:Code == "1"
		nQtd += 1
	EndIf

Next nI

oSubTotals["type"]  := aEnum[1] // @FIXME
oSubTotals["total"] := nQtd

Aadd(aData,oSubTotals)

oItemData["subtotals"] 	:= aData
oItemData["total"] 		:= nQtd

Return(Nil)


Function getRGKJustify(cFil,cCode)
Local cQueryRGK := GetNextAlias()
Local cQueryRDY := GetNextAlias()
Local cFilRDY	  := ""
Local cJustify  := ""

DEFAULT cFil   := ''
DEFAULT cCode  := ''

If !empty(cCode)

	BEGINSQL ALIAS cQueryRGK
		SELECT RGK.RGK_CODCON,RGK.RGK_FILIAL
		FROM %table:RGK% RGK
			WHERE RGK.RGK_FILIAL  = %exp:cFil%  AND
			      RGK.RGK_CODIGO  = %exp:cCode% AND
                  RGK.RGK_CODCON != ' ' AND
                RGK.%notDel%
	ENDSQL

	cFilRDY := "%'" + xFilial( 'RDY', (cQueryRGK)->RGK_FILIAL) + "'%"

	BEGINSQL ALIAS cQueryRDY
		SELECT RDY.RDY_TEXTO
		FROM %table:RDY% RDY
			WHERE RDY.RDY_FILIAL = %exp:cFilRDY% 	            AND
		         RDY.RDY_CHAVE  = %exp:(cQueryRGK)->RGK_CODCON% AND
		         RDY.%notDel%
	ENDSQL

	cJustify := (cQueryRDY)->RDY_TEXTO

	(cQueryRDY)->(DbCloseArea())
	(cQueryRGK)->(DbCloseArea())

EndIf

Return(EncodeUTF8(cJustify))

/*/{Protheus.doc} fGetSeqclock
Retorna uma matriz com sentido (entrada/saida) das marcacoes incluidas pelo espelho de acordo com a data/hora
@author:	Marcelo Silveira
@since:		16/04/2019
@param:		cFilSRA - Filial do aprovador;
			cMatSRA - Matricula do aprovador;
@return:	aSentido - Array com as datas/horas classificadas como entrada/saida
/*/
Function fGetSeqclock(cFilSRA, cMatSRA, cMatAprov)

Local cQuery	:= GetNextAlias()
Local nX  		:= 0
Local nPos  	:= 0
Local nCount	:= 0
Local cCod		:= ""
Local cLastDt	:= ""
Local cWhere	:= ""
Local cExit		:= EncodeUTF8(STR0008) //"Saída"
Local cEntry	:= EncodeUTF8(STR0009) //"Entrada"
Local aSentido 	:= {}

cWhere := "%"
cWhere += " RH3.RH3_FILAPR IN ('" + cFilSRA + "') AND "
cWhere += " RH3.RH3_MATAPR IN (" + cMatSRA + ") "
cWhere += "%"

BEGINSQL ALIAS cQuery
	SELECT RH3_CODIGO, RH4.RH4_CAMPO, RH4_VALNOV
	FROM %table:RH3% RH3
	INNER JOIN %table:RH4% RH4 ON
		RH4_FILIAL = RH3_FILIAL AND
		RH4_CODIGO = RH3_CODIGO
	WHERE
		RH3.RH3_MAT <> %Exp:cMatAprov%  AND
		RH3.RH3_STATUS ='1' AND RH3.RH3_TIPO ='Z' AND
		RH4_CAMPO IN ('P8_DATA','P8_HORA')   AND
		%Exp:cWhere% AND
        RH3.%notDel% AND RH4.%notDel%
    ORDER BY RH3_CODIGO, RH3_FILIAL, RH3_MAT
ENDSQL

//Inclui na matriz os marcacoes incluidas para aprovacao
While (cQuery)->(!Eof())

	nPos := If( AllTrim((cQuery)->RH4_CAMPO) == 'P8_DATA', 1, 2)

	If !(cCod == (cQuery)->RH3_CODIGO)
		aAdd( aSentido, {Ctod("//"), "", "", (cQuery)->RH3_CODIGO} )
		cCod := (cQuery)->RH3_CODIGO
	EndIf

	aSentido[Len(aSentido),nPos] := AllTrim(RH4_VALNOV)

	(cQuery)->(DbSkip())

Enddo

If Len(aSentido) > 0
	//Ordena as marcacoes incluidas por data e hora
	aSort(aSentido,,,{|x,y| DtoS(cTod(x[1]))+StrTran(StrZero( Val(x[2]),5,2),".", ":") < DtoS(cToD(y[1]))+StrTran(StrZero( Val(y[2]),5,2),".", ":") })

	//Classifica cada registro como entrada/saida de acordo com a ordem dos horarios
	For nX := 1 to Len(aSentido)
		nCount		:= If( cLastDt == aSentido[nX, 01], nCount, 0 )
		nCount++

		aSentido[nX,3] 	:= Iif(nCount % 2 == 0 , cExit, cEntry)
		cLastDt 	:= aSentido[nX, 01]
	Next nX
EndIf

(cQuery)->(DbCloseArea())

Return(aSentido)