#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSGPE060.CH"

WSSTRUCT TAbsence
	WSDATA Branch		AS String
	WSDATA Registration	AS String
	WSDATA Sequence		AS String
	WSDATA Type			AS String
	WSDATA StartDate	AS Date
	WSDATA EndDate		AS Date
	WSDATA DayNumber	As Integer
	WSDATA LocaleValues	AS Array OF String
ENDWSSTRUCT

WSSTRUCT TLocaleValues
	WSDATA FieldName	AS String
	WSDATA Value		AS String
ENDWSSTRUCT
                    
WSSTRUCT TLocaleFields
	WSDATA FieldName	AS String
	WSDATA Title		AS String
	WSDATA Type			AS String
	WSDATA Length		AS Integer
	WSDATA Decimals		AS Integer		
	WSDATA ComboBox		AS String
ENDWSSTRUCT

WSSTRUCT TAbsenceBrowserData
	WSDATA Absences		AS Array of TAbsence
	WSDATA LocaleFields	AS Array Of TLocaleFields
ENDWSSTRUCT	

WSSTRUCT TAbsenceGetData
	WSDATA Absence		AS TAbsence
	WSDATA LocaleFields	AS Array Of TLocaleFields
ENDWSSTRUCT	


WSSERVICE RHAbsences DESCRIPTION "Afastamentos"
	WSDATA Branch		AS String
	WSDATA Registration	AS String
	WSDATA Sequence		AS String
	WSDATA BrowserData	AS TAbsenceBrowserData
	WSDATA GetData 		AS TAbsenceGetData
	
	WSMETHOD BrowseAbsences	DESCRIPTION "Método de consulta os afastamentos do funcionario"
	WSMETHOD GetAbsence	DESCRIPTION "Método de consulta os afastamentos do funcionario"
ENDWSSERVICE                                  


WSMETHOD BrowseAbsences;
WSRECEIVE Branch, Registration;
WSSEND BrowserData;
WSSERVICE RHAbsences
Local cQuery:= GetNextAlias()
Local cLocaleFields:= ""
Local nCount
Local cFieldType:= "% R8_TIPOAFA %"
Local cBranch:= Self:Branch
Local cRegistration:= Self:Registration
Local lRetorno	:= .T.

Self:BrowserData:= WSClassNew("TAbsenceBrowserData")
Self:BrowserData:LocaleFields:= GetLocaleFields(1)

For nCount:= 1 To Len(Self:BrowserData:LocaleFields)
	cLocaleFields+= ", SR8." + Self:BrowserData:LocaleFields[nCount]:FieldName 
Next
cLocaleFields:= "%" + cLocaleFields + "%"

BEGINSQL ALIAS cQuery
	COLUMN R8_DATAINI AS DATE
	COLUMN R8_DATAFIM AS DATE

	SELECT 
		SR8.R8_FILIAL,
		SR8.R8_MAT,
		SR8.R8_SEQ,
		SR8.%Exp:cFieldType%,
		SR8.R8_TIPOAFA,
		SR8.R8_DATAINI,
		SR8.R8_DATAFIM,
		SR8.R8_DURACAO
		%Exp:cLocaleFields%
	FROM 
		%Table:SR8% SR8
	WHERE 
		SR8.R8_FILIAL = %Exp:cBranch% AND 
		SR8.R8_MAT = %Exp:cRegistration% AND
		SR8.%NotDel%
	ORDER BY
		SR8.R8_DATAINI DESC		 
ENDSQL

For nCount:= 1 To Len(Self:BrowserData:LocaleFields)
	If Self:BrowserData:LocaleFields[nCount]:Type != "C"
		TcSetField(	cQuery,;
					Self:BrowserData:LocaleFields[nCount]:FieldName,;
					Self:BrowserData:LocaleFields[nCount]:Type,;
					Self:BrowserData:LocaleFields[nCount]:Length,;
					Self:BrowserData:LocaleFields[nCount]:Decimals)
	EndIf
Next
  
If Empty( Self:BrowserData:Absences:= BuildAbsence(cQuery, Self:BrowserData:LocaleFields) )
	SetSoapFault("RHAbsences", OemToAnsi(STR0001))	 //"Não há afastamentos para consulta."
	lRetorno := .F.
EndIf

(cQuery)->(DBCloseArea())

Return(lRetorno)

WSMETHOD GetAbsence;
WSRECEIVE Branch, Registration, Sequence;
WSSEND GetData;
WSSERVICE RHAbsences
Local cQuery:= GetNextAlias()
Local cLocaleFields:= ""
Local nCount
Local cFieldType:= "% R8_TIPOAFA %"
Local cBranch:= Self:Branch
Local cRegistration:= Self:Registration
Local cSequence:= Self:Sequence
Local lRetorno	:= .T.

Self:GetData:= WSClassNew("TAbsenceGetData")
Self:GetData:LocaleFields:= GetLocaleFields(2)

For nCount:= 1 To Len(Self:GetData:LocaleFields)
	cLocaleFields+= ", SR8." + Self:GetData:LocaleFields[nCount]:FieldName 
Next
cLocaleFields:= "%" + cLocaleFields + "%"

BEGINSQL ALIAS cQuery
	COLUMN R8_DATAINI AS DATE
	COLUMN R8_DATAFIM AS DATE

	SELECT 
		SR8.R8_FILIAL,
		SR8.R8_MAT,
		SR8.R8_SEQ,
		SR8.%Exp:cFieldType%,
		SR8.R8_TIPOAFA,
		SR8.R8_DATAINI,
		SR8.R8_DATAFIM,
		SR8.R8_DURACAO
		%Exp:cLocaleFields%
	FROM 
		%Table:SR8% SR8
	WHERE 
		SR8.R8_FILIAL = %Exp:cBranch% AND 
		SR8.R8_MAT = %Exp:cRegistration% AND
		SR8.R8_SEQ = %Exp:cSequence% AND
		SR8.%NotDel%
	ORDER BY
		SR8.R8_DATAINI DESC		 
ENDSQL

For nCount:= 1 To Len(Self:GetData:LocaleFields)
	If Self:GetData:LocaleFields[nCount]:Type != "C"
		TcSetField(	cQuery,;
					Self:GetData:LocaleFields[nCount]:FieldName,;
					Self:GetData:LocaleFields[nCount]:Type,;
					Self:GetData:LocaleFields[nCount]:Length,;
					Self:GetData:LocaleFields[nCount]:Decimals)
	EndIf
Next

	  
If Empty( Self:GetData:Absence:= BuildAbsence(cQuery, Self:GetData:LocaleFields)[1] )
	SetSoapFault("RHAbsences",OemToAnsi(STR0001))	 //"Não há afastamentos para consulta."
	lRetorno := .F.
EndIf

(cQuery)->(DBCloseArea())
Return(lRetorno)

Static Function BuildAbsence(cQuery, aLocaleFields)
Local oItem
Local xValue
Local aReturn:= {}
Local nCount
If !Eof()
	While !Eof()
		oItem:= WSClassNew("TAbsence")
		oItem:LocaleValues	:= {}
		oItem:Sequence		:= (cQuery)->R8_SEQ
		oItem:Branch		:= (cQuery)->R8_FILIAL
		oItem:Registration	:= (cQuery)->R8_MAT
		oItem:Type 			:= AllTrim(fDesc("RCM", (cQuery)->R8_TIPOAFA, "RCM_DESCRI", NIL, (cQuery)->R8_FILIAL))
		oItem:StartDate		:= (cQuery)->R8_DATAINI
		oItem:EndDate		:= (cQuery)->R8_DATAFIM
		oItem:DayNumber		:= (cQuery)->R8_DURACAO
		For nCount:= 1 To Len(aLocaleFields)
			xValue:= (cQuery)->(&(aLocaleFields[nCount]:FieldName))
			
			If aLocaleFields[nCount]:Type == "N"
				AAdd(oItem:LocaleValues, AllTrim(Str(xValue)))
			ElseIf aLocaleFields[nCount]:Type == "D"
				AAdd(oItem:LocaleValues, DTOC(xValue))
			ElseIf aLocaleFields[nCount]:Type == "C"
				If !Empty(aLocaleFields[nCount]:ComboBox)				
					AAdd(oItem:LocaleValues, GetBoxDescription(aLocaleFields[nCount]:FieldName, xValue))
				Else
					AAdd(oItem:LocaleValues, AllTrim(xValue))
				EndIf
			EndIf			
		Next
	
		AAdd(aReturn, oItem)

		(cQuery)->(DBSkip())
	EndDo
Else
	oItem:= WSClassNew("TAbsence")
	oItem:LocaleValues	:= {}
	oItem:Sequence		:= (cQuery)->R8_SEQ
	oItem:Branch		:= (cQuery)->R8_FILIAL
	oItem:Registration	:= (cQuery)->R8_MAT
	oItem:Type 			:= STR0001
	oItem:StartDate		:= (cQuery)->R8_DATAINI
	oItem:EndDate		:= (cQuery)->R8_DATAFIM
	oItem:DayNumber		:= (cQuery)->R8_DURACAO
	For nCount:= 1 To Len(aLocaleFields)
		xValue:= (cQuery)->(&(aLocaleFields[nCount]:FieldName))
		
		If aLocaleFields[nCount]:Type == "N"
			AAdd(oItem:LocaleValues, AllTrim(Str(xValue)))
		ElseIf aLocaleFields[nCount]:Type == "D"
			AAdd(oItem:LocaleValues, DTOC(xValue))
		ElseIf aLocaleFields[nCount]:Type == "C"
			If !Empty(aLocaleFields[nCount]:ComboBox)				
				AAdd(oItem:LocaleValues, GetBoxDescription(aLocaleFields[nCount]:FieldName, xValue))
			Else
				AAdd(oItem:LocaleValues, AllTrim(xValue))
			EndIf
		EndIf			
	Next

	AAdd(aReturn, oItem)

	(cQuery)->(DBSkip())
EndIf
	
Return(aReturn)

Static Function GetLocaleFields(nTipo)
	Local aFields:= {}

	If nTipo == 1 //BROWSE
		AddLocaleField(aFields, "R8_DPAGOS")
		AddLocaleField(aFields, "R8_STATUS")
	Else	//DETALHES
		AddLocaleField(aFields, "R8_CONTINU")
		AddLocaleField(aFields, "R8_PER")
		AddLocaleField(aFields, "R8_NUMPAGO")
		AddLocaleField(aFields, "R8_DNAPLIC")
		AddLocaleField(aFields, "R8_CONTAFA")
		AddLocaleField(aFields, "R8_DIASEMP")
		AddLocaleField(aFields, "R8_DPAGAR")
		AddLocaleField(aFields, "R8_SDPAGAR")
		AddLocaleField(aFields, "R8_CID")
		AddLocaleField(aFields, "R8_DPAGOS")
		AddLocaleField(aFields, "R8_NUMID")
		AddLocaleField(aFields, "R8_NCERINC")
		AddLocaleField(aFields, "R8_PRORSC")
		AddLocaleField(aFields, "R8_TIPORSC")
		AddLocaleField(aFields, "R8_RESINC")
		AddLocaleField(aFields, "R8_TPFOL1")
		AddLocaleField(aFields, "R8_FOLST1")
		AddLocaleField(aFields, "R8_TPFOL2")
		AddLocaleField(aFields, "R8_FOLST2")
		AddLocaleField(aFields, "R8_CODRPAT")
		AddLocaleField(aFields, "R8_STATUS")
		AddLocaleField(aFields, "R8_DTBLEG")
		AddLocaleField(aFields, "R8_DIASREV")
		AddLocaleField(aFields, "R8_PROCES")
		AddLocaleField(aFields, "R8_ENVSUA")				
	EndIf		
Return aFields

Static Function AddLocaleField(aFields, cFieldName)
	Local oItem

	DBSelectArea("SX3")
	DBSetOrder(2)

	IF DBSeek(PadR(cFieldName, 10))
		oItem:= WSClassNew("TLocaleFields")
		oItem:FieldName:= cFieldName
		oItem:Title:= PorEncode(AllTrim(X3Descric()))
		oItem:Type:= SX3->X3_TIPO
		oItem:Length:= SX3->X3_TAMANHO
		oItem:Decimals:= SX3->X3_DECIMAL
		oItem:ComboBox:= AllTrim(X3CBox())
		
		AAdd(aFields, oItem)
	EndIf
Return 
