#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWPRINTSETUP.CH" 
#INCLUDE "RPTDEF.CH"  

#INCLUDE "RHNPLIB.CH"

/*/{Protheus.doc}RHNPLIB

- Fonte agrupador de diversas Functions do Projeto MEU RH ( RH MOBILE );

@author:	Matheus Bizutti
@since:		24/08/2017

/*/

/*/{Protheus.doc} GetAccessEmployee
- Obtém o acesso a RD0 e alimenta o array aRET com as matrículas do usuário logado.

@author:	Matheus Bizutti
/*/
Function GetAccessEmployee(cRD0Login,aRet,lRetorno)

Local lRet		:= .F.

Default cRD0Login := ""
Default aRet      := {}
Default lRetorno  := .F.

// - Verifica se existe o arquivo de relacionamento
// - Efetua o posicionamento no funcionário (SRA)
If lRetorno 

	If MatParticipant(cRD0Login, aRet, .T.)
		lRet := .T.
	EndIf
	
EndIf

Return(lRet)

/*/{Protheus.doc} GetRegisterHR
- Lê a Matrícula do USUÁRIO GRAVADO NO TOKEN

@author:	Matheus Bizutti
/*/
Function GetRegisterHR(cToken)
	Local aHeader  := {}
	Default cToken := ''
	aHeader := GetClaims(cToken)
	
	If Len(aHeader) < 1
		Return ""
	EndIf
Return(aHeader[1])

/*/{Protheus.doc} GetLoginHR
- Lê o LOGIN ( RD0_LOGIN ) do USUÁRIO GRAVADO NO TOKEN

@author:	Matheus Bizutti
/*/
Function GetLoginHR(cToken)
	Local aHeader := {}
	Default cToken := ''
	aHeader := GetClaims(cToken)
	
	If Len(aHeader) < 2
		Return ""
	EndIf
Return(aHeader[2])

/*/{Protheus.doc} GetLoginHR
- Lê o código ( RD0_CODIGO ) do USUÁRIO GRAVADO NO TOKEN

@author:	Matheus Bizutti
/*/
Function GetCODHR(cToken)
	Local aHeader  := {}
	Default cToken := ''
	aHeader := GetClaims(cToken)
	
	If Len(aHeader) < 3
		Return ""
	EndIf
Return(aHeader[3])

/*/{Protheus.doc} GetLoginHR
- Lê a filial ( RDZ - RELACIONAMENTO ) do USUÁRIO GRAVADO NO TOKEN

@author:	Matheus Bizutti
/*/
Function GetBranch(cToken)
	Local aHeader  := {}
	Default cToken := ''
	aHeader := GetClaims(cToken)
	
	If Len(aHeader) < 5
		Return ""
	EndIf
Return(aHeader[5])


/*/{Protheus.doc} DecodeURL
- DECODE do corpo de requisições que vem no FORMDATA FORMAT.

@author:	Matheus Bizutti
/*/
Function DecodeURL(cBody)

Local cURLDecode := ""
Local cUser      := ""
Local cPw        := ""
Local cEmail     := ""
Local cKey       := ""
Local cHash      := ""
Local nX         := 0
Local aPars      := {}
Local aKeyValue  := {}
Local aReturn    := {}

Default cBody    := ""

aPars := StrTokArr(cBody, "&")
//varinfo("aPars: ",aPars)

For nX := 1 To Len(aPars)
	aKeyValue := StrTokArr(aPars[nX], "=")
	If aKeyValue[1] == "user"
		cUser := Iif(Len(aKeyValue) >= 2,aKeyValue[2],"")
		cUser := StrTran(cUser, "+", "")
	ElseIf	aKeyValue[1] == "password"
	 	cPw := Iif(Len(aKeyValue) >= 2,aKeyValue[2],"")
	ElseIf	aKeyValue[1] == "redirectUrl"
		cURLDecode := StrTran( Iif(Len(aKeyValue) >= 2,aKeyValue[2],""), "%3A", ":" )
		cURLDecode := StrTran( cURLDecode, "%2F", "/" )
    ElseIf aKeyValue[1] == "email"
       cEmail := Iif(Len(aKeyValue) >= 2,aKeyValue[2],"")
       cEmail := StrTran( cEmail, "%40", "@" )
    ElseIf  aKeyValue[1] == "hash"
       cHash  := Iif(Len(aKeyValue) >= 2,aKeyValue[2],"")
	EndIf
Next nX

cKey := cUser + "|" + cPw + "|" + cURLDecode + "|" + cEmail + "|" + cHash
aReturn := StrTokArr(cKey, "|")

Return(aReturn)


/*/{Protheus.doc}fVldSolAut
Retorna se o usuário autenticado tem acesso as informações solicitadas.
@author: Gabriel A.	
@since: 24/07/2017
/*/
Function fVldSolAut(cFilAut, cMatAut, cFilSol, cMatSol, aMsg, lMsg, cRD0Login)
	Local lTemAcesso := .T.
	Local lUserCfg	 := .F.
	Local nPos		 := 0
	Local aRet		 := {}
	
	Default lMsg 	:= .T.
	Default aMsg 	:= {}
	Default cFilAut := ""
	Default cMatAut := ""
	Default cMatSol := ""
	Default cFilSol := ""
	Default cRD0Login := ""
	
	lUserCfg := GetAccessEmployee(cRD0Login, @aRet, .T.)
	
	If lUserCfg .And. Len(aRet) >= 1
	
		nPos := Ascan(aRet,{|x| Alltrim(x[3]) + Alltrim(x[1]) == Alltrim(cFilSol) + Alltrim(cMatSol)})
		
		If nPos == 0
			
			lTemAcesso := .F.
			If lMsg
				Aadd(aMsg, EncodeUTF8(STR0001)) //"O usuário autenticado não possui acesso aos dados."
			EndIf
		EndIf
		
	EndIf
	
Return lTemAcesso

/*/{Protheus.doc}GetConfig()
- Função responsável por ler uma sessão do appserver.ini e uma chave, e retornar o valor.
@author:	Matheus Bizutti
@since:		09/08/2017
/*/
Function GetConfig(cSession, cProperty,cDefault)

Local cValue := ""

Default cSession  := ""
Default cProperty := ""
Default cDefault  := ""

cValue := GetPvProfString(cSession, cProperty, "", GetAdv97()) 

Return(Iif(Empty(cValue),cDefault,cValue))


/*/{Protheus.doc}GetClaims()
- Função responsável por obter o Token gerado no momento do Login, e retornar os dados de acesso do usuário logado.
@author:	Matheus Bizutti
@since:	09/08/2017
/*/
Function GetClaims(cToken)

Local nX        := 0
Local aClaims 	:= {}
Local aReturn	:= {}
Default cToken	:= ""

aClaims := JWTClaims(Substr(cToken,8,Len(cToken)))

For nX := 1 To Len(aClaims)
   If aClaims[nX][1] == "KEY"
      aReturn := StrTokArr(aClaims[nX][2], "|")
   EndIf
Next nX

Return(aReturn)


/*/{Protheus.doc}GetVisionAI8()
- Função responsável por ler a VISÃO de determinada rotina na tabela AI8
@author:	Matheus Bizutti
@since:	21/08/2017
@param:	cRoutine - nome da rotina que a função buscará ex: W_PWSA01.APW
			cBranchVld - Filial utilizada no acesso ao APP.
/*/
Function GetVisionAI8(cRoutine, cBranchVld)

Local aVision	:= {}
Local cQuery    := GetNextAlias()
Local cBranchAI8:= ""
Local cCodHR	:= "000006"

Default cRoutine   := ""
Default cBranchVld := FwCodFil()

cBranchAI8 := xFilial("AI8", cBranchVld)

If !Empty(cRoutine)
	BEGINSQL ALIAS cQuery
	
		SELECT AI8.AI8_VISAPV, AI8.AI8_INIAPV, AI8.AI8_APRVLV
		FROM %table:AI80% AI8
		WHERE AI8.AI8_FILIAL =  %Exp:cBranchAI8% AND
			  AI8.AI8_ROTINA =  %Exp:cRoutine%   AND
			  AI8.AI8_PORTAL =  %Exp:cCodHR%     AND
			  AI8.%notDel%
			
	ENDSQL
	
	While (cQuery)->(!Eof())
	
		Aadd(aVision, {(cQuery)->AI8_VISAPV,(cQuery)->AI8_INIAPV,(cQuery)->AI8_APRVLV})
	
		(cQuery)->(DbSkip())
	EndDo

(cQuery)->( DbCloseArea() )

EndIf

If Empty(aVision)
	// ------------------------------
	// INICIALIZANDO O ARRAY aVision |
	// ------------------------------
	aVision	:= Array(1,3)
	aVision[1][1] := ""
	aVision[1][2] := 0
	aVision[1][3] := 0	
EndIf

Return(aVision)

/*/{Protheus.doc}Format8601()
- Função responsável por receber um DATETIME e devolver a data ou a hora.
@author:	Matheus Bizutti
@since:	21/08/2017
@param:	lDate - Quando informada .T., a função devolve a data, caso contrário devolve a hora.
			cValue - Valor em DATETIME ISO 8601 que será utilizado para retorno de data ou hora.
/*/

Function Format8601(lDate,cValue)

Local cFormat	:= ""
Local cAuxFormat:= ""

Default lDate	:= .T.
Default cValue	:= ""

If !Empty(cValue)
	If lDate
		
		cAuxFormat := Substr(cValue,1,10)
		cFormat    := Substr(cAuxFormat,9,2) + "/" + Substr(cAuxFormat,6,2) + "/" + Substr(cAuxFormat,1,4) 
		
	Else
		cFormat    := Substr(cValue,12,5) 
		
	EndIf
EndIf

Return(cFormat)

/*/{Protheus.doc}SumDate
- Efetua SUM em datas;
@author: 	Matheus Bizutti	
@since:	12/04/2017

/*/
Function SumDate(dDate, nDays)

Default dDate := dDataBase
Default nDays := 0

Return DaySum( dDate , nDays )


/*/{Protheus.doc}PeriodConcessive
- Retorna o Periodo concessivo;
@author: 	Matheus Bizutti	
@since:	12/04/2017

/*/
Function PeriodConcessive(dInit, dEnd)

Local aDate		:= {}
Local dInitDate	:= CtoD(" / / ") 
Local dEndDate	:= CToD(" / / ")

Default dInit := CtoD(" / / ")
Default dEnd 	:= CtoD(" / / ")

dInitDate 	:= DaySum(STOD(dEnd),1)
dEndDate	:= YearSum(dInitDate,1)
dEndDate	:= DaySub(dEndDate,1)

Aadd(aDate,dInitDate)
Aadd(aDate,dEndDate)

Return(aDate)

/*/{Protheus.doc}StatusVacation
- Retorna o Status de Férias;
@author: 	Matheus Bizutti	
@since:	12/04/2017

/*/
Function StatusVacation(cSitFolh)

Local cStatus	 := ""

Default cSitFolh := " "

If cSitFolh == "F"
	cStatus := "approving"
Else
	cStatus := "closed"
EndIf

Return (cStatus)


/*/{Protheus.doc}GetDepSup
- Efetua a busca do Depto Superior
@author: 	Matheus Bizutti
@since: 	13/07/2017
@param:	cDepto - SRA->RA_DEPTO | cBranchVld - Variável da Filial da RDZ

/*/
Function GetDepSup(cDepto,cBranchVld)

Local cDepSup := ""
Local aArea   := GetArea()
Local aQBArea := SQB->(GetArea())

Default cDepto := ""

DbSelectArea("SQB")
If SQB->(DbSeek(xFilial("SQB", cBranchVld)+ cDepto))
	cDepSup := SQB->QB_DEPSUP
EndIf

RestArea(aArea)
RestArea(aQBArea)

Return(cDepSup)

Function GetENUMDecode(cCode)

Local cDesc := ""
Default cCode := ""

DO CASE
     CASE cCode == "B"
                cDesc := EncodeUTF8('vacation')
 
     CASE cCode == "8"
                cDesc := EncodeUTF8('allowance')
     
     CASE cCode == "Z"
                cDesc := EncodeUTF8('clocking') 
 
     OTHERWISE
                cDesc := ''
     ENDCASE

Return (EncodeUTF8(cDesc))

Function getSummary(cMat,cBranch)

Local aReturn := Array(03)
Local aArea	  := GetArea()
Local cAlias  := "SRA"

Default cMat := ""
Default cBranch := FwCodFil()

DbSelectArea(cAlias)
If (cAlias)->(DbSeek(cBranch+cMat))
	//aReturn[1] := SRA->RA_FILIAL+"|"+SRA->RA_MAT
	aReturn[1] := SRA->RA_MAT
	aReturn[2] := Alltrim( EncodeUTF8(SRA->RA_NOME) ) 
	aReturn[3] := Alltrim( EncodeUTF8( FDesc("SRJ", SRA->RA_CODFUNC, "RJ_DESC",,cBranch ) ) ) 
Else 
	// ********************************************
	// - Inicializando o array com valores default.
	// ********************************************
	aReturn[1] := ""
	aReturn[2] := ""
	aReturn[3] := ""
EndIf

RestArea(aArea)

Return(aReturn)

Function milisSecondsToHour(nMSInit,nMSEnd)

Local aConvertHour	:= Array(2)

Local nMSInit	:= nMSInit
Local nMSEnd	:= nMSEnd
Local nHourInit	:= 0 
Local nHourEnd	:= 0 

nMsInit := (nMsInit / (1000*60))
nMSEnd  := (nMsEnd  / (1000*60))

nHourInit := Min2Hrs(nMsInit)
nHourEnd  := Min2Hrs(nMSEnd)

aConvertHour[1] := nHourInit
aConvertHour[2] := nHourEnd

Return(aConvertHour)

Function HourToMs(cTime)

Local nMSTime	:= 0
Local aTime		:= {}

Default cTime	:= ""

aTime := StrTokArr(cTime, ".") // = 9.05
If Len(aTime) > 1
	nMSTime := ((Val(aTime[1]) * 60) + Val(aTime[2])) * 60000
Else
	nMSTime := ((Val(aTime[1]) * 60)) * 60000
EndIf

Return(nMSTime)


/*/{Protheus.doc} fPDFMakeFileMessage
//Gera um arquivo PDF para retorno de uma requisicao REST para exibir LOG de ocorrencias
@author:	Marcelo Silveira
@since:		20/08/2019
@return:	Nil	
/*/
Function fPDFMakeFileMessage( cMsg, cNameFile, cFile )

Local oFile
Local oPrint	
Local cArqLocal		:= ""
Local nLin 			:= 0
Local nCont			:= 0
Local nTamMarg		:= 15
Local lContinua		:= .T.
Local cLocal		:= GetSrvProfString ("STARTPATH","")
Local oFont10n		:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)	//Normal negrito
Local oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)	//Normal s/ negrito

DEFAULT cMsg		:= OemToAnsi(STR0002) //"Ocorreram erros durante o processamento"
DEFAULT cNameFile	:= "LOG_MESSAGE"
DEFAULT cFile		:= ""

	oPrint 		:= FWMSPrinter():New(cNameFile+".rel", IMP_PDF, .F., cLocal, .T., , , , .T., , .F., )
	
	oPrint:SetLandscape()
	oPrint:SetMargin(nTamMarg,nTamMarg,nTamMarg,nTamMarg)
	oPrint:StartPage()

	nSizePage	:= oPrint:nPageWidth / oPrint:nFactorHor

	nLin += 30
	oPrint:Say(nLin,  15, OemToAnsi(STR0003), oFont10n) //"LOG DE OCORRÊNCIAS"
	nLin += 05		
	oPrint:Line(nLin, 15, nLin, nSizePage-(nTamMarg*3))
	
	nLin += 15
	oPrint:Say(nLin,  15, cMsg, oFont10)
		
	oPrint:EndPage()
		
	cArqLocal		:= cLocal+cNameFile+".PDF"		
	oPrint:cPathPDF := cLocal 
	oPrint:lViewPDF := .F.
	oPrint:Print()
	
	While lContinua
	    If File( cArqLocal )
			oFile := FwFileReader():New( cArqLocal )
			
			If (oFile:Open())
		    	cFile := oFile:FullRead()
		        oFile:Close()
		        fErase(cArqLocal)		    		
			EndIf
	    EndIf
	    //Em determinados ambientes pode ocorrer demora na geracao do arquivo, entao tenta localizar por 5 segundos no maximo.
	    If ( lContinua := Empty(cFile) .And. nCont < 4 )
	    	nCont++
	    	Sleep(1000)
	    EndIf
    End	
		
Return()