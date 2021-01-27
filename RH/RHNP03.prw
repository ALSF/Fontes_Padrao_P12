#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"

#INCLUDE "RHNP03.CH"

Function RHNP03()
Return .T.


WSRESTFUL Payment DESCRIPTION EncodeUTF8(STR0001) //"Retorna o resumo do Demonstrativo de Pagamento"

WSDATA WsNull 		As String Optional
WSDATA initView		As String Optional
WSDATA endView		As String Optional
WSDATA typeChange	As String Optional
WSDATA page			As String Optional
WSDATA pageSize		As String Optional
WSDATA initDate		As String Optional
WSDATA endDate		As String Optional

//"Resumo do demonstrativo"
WSMETHOD GET DESCRIPTION EncodeUTF8(STR0002) WSSYNTAX "/payment/payments/{employeeId} | /payment/detail/{paymentId} | /payment/annualReceipts/{employeeId} | /payment/annualReceipt/report/{employeeId}/{calendarYear} | /payment/paymentReceipt/report/{employeeId}/{paymentId}"

//Retorna a disponibilidade da folha de pagamento do funcionario
WSMETHOD GET GetPayAvailable ; 
  DESCRIPTION EncodeUTF8(STR0014) ;	//"Retorna a disponibilidade da folha de pagamento do funcionario" 
  WSSYNTAX "/payment/available/{employeeId}" ;
  PATH "/available/{employeeId}" ;
  PRODUCES 'application/json;charset=utf-8'

//Retorna os tipos de alteracoes salariais
WSMETHOD GET gTypeSalaryChanges ; 
  DESCRIPTION EncodeUTF8(STR0015) ;	//"Retorna os tipos de alterações salariais" 
  WSSYNTAX "/payment/salaryHistory/type" ;
  PATH "/salaryHistory/type" ;
  PRODUCES 'application/json;charset=utf-8'

//Retorna o historico de alteracoes salariais do funcionário
WSMETHOD GET SalaryChanges ; 
  DESCRIPTION EncodeUTF8(STR0016) ;	//"Retorna o histórico de alterações salariais do funcionário" 
  WSSYNTAX "/payment/salaryHistory/{employeeId}" ;
  PATH "/salaryHistory/{employeeId}" ;
  PRODUCES 'application/json;charset=utf-8'

END	WSRESTFUL


WSMETHOD GET WSRECEIVE WsNull WSSERVICE Payment

Local cJson 	  	:= ''
Local cMatSRA	  	:= ''
Local cJsonObj      := "JsonObject():New()"
Local oItem         := &cJsonObj
Local oItemDetail	:= &cJsonObj
Local oMessages     := &cJsonObj
Local nLenParms     := Len(::aURLParms)
Local aAreaSRA      := {}
Local cAliasSRA		:= "SRA"
Local cModoSRA		:= FWModeAccess(cAliasSRA)
Local cAliasSRD		:= "SRD"
Local cModoSRD		:= FWModeAccess(cAliasSRD)
Local cSavFil       := cFilAnt
Local cSavEmp       := cEmpAnt
Local aMessages     := {}
Local aData         := {}
Local aPaymentId	:= {}
Local aTransfSeg    := {}
Local cBranchVld	:= ""
Local lAuth         := .T.
Local nSize         := 0
Local nTipo         := 0
Local nX            := 0
Local lPayment      := .T.
Local lAnnualRec    := .T.
Local lRecibo       := .F.
Local lVldAut       := .F.
Local lMatTransf    := .F.
Local cToken        := ""
Local cSyntax       := ""
Local cYear         := ""
Local cFile         := ""
Local cArqName      := ""
Local cArqLocal     := ""
Local cRD0Login     := ""

cToken  := Self:GetHeader('Authorization')

Private cKeyId	:= ""

// - Parâmetros enviados pela URL - QueryString
DEFAULT Self:initView := ""
DEFAULT Self:endView  := ""

::SetHeader('Access-Control-Allow-Credentials' , "true")

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cRD0Login  := GetLoginHR(cToken)

If Empty(cMatSRA) .Or. Empty(cBranchVld)
	oMessages["type"]   := "error"
	oMessages["code"]   := "401"
	oMessages["detail"] := EncodeUTF8(STR0003) //"Dados inválidos."
	
	Aadd(aMessages,oMessages)
	lAuth := .F.
EndIf

//Posiciona SRA
dbSelectArea("SRA")
SRA->( dbSetOrder(1) )
If !(SRA->( dbSeek( xFilial("SRA" , cBranchVld) + cMatSRA) ))
    lAuth := .F.
Else
    //avalia transferências para tratamento de segurança     
    fTransfAll(@aTransfSeg,,,.T.)
EndIf

If lAuth
	cKeyId 		:= Iif(Len(Self:aUrlParms) >= 2,Self:aUrlParms[2],"")
	cYear		:= Iif(Len(Self:aUrlParms) >= 4,Self:aUrlParms[4],"")
	aPaymentId	:= StrTokArr(cKeyId, "|" )
	nSize 		:= Len(aPaymentId)
		
    //valida permissionamento de segurança
    If Self:aUrlParms[1] == "detail"
       
       //tratamento para transferência entre empresas, com possibilidade de troca de filial/matrícula
       If len(aPaymentId) == 11 .and. !empty(aPaymentId[11])

          For nX:=1 to Len(aTransfSeg)
              //        filial/mat solicitado na requisição              e           filial/mat logado no app    
              If ( (aTransfSeg[nX][2] == aPaymentId[1]+aPaymentId[2])  .and.  (aTransfSeg[nX][5] == cBranchVld+cMatSRA) ) .or. ;
                 ( (aTransfSeg[nX][5] == aPaymentId[1]+aPaymentId[2])  .and.  (aTransfSeg[nX][5] == cBranchVld+cMatSRA) )
                 lVldAut    := .T.
                 lMatTransf := .T.
                 Exit
              EndIf
          Next

       Else
          lVldAut := fVldSolAut(cBranchVld, cMatSRA, aPaymentId[1], Iif(nSize >= 2,aPaymentId[2],"" ), @aMessages,,cRD0Login)
       EndIf    
    Else
       If aPaymentId[1] == "report"    
          aPaymentId := Iif(Len(Self:aUrlParms) >= 4,StrTokArr(Self:aUrlParms[4], "|" ),{})
          nSize      := Len(aPaymentId)

          If len(aPaymentId) > 10 .and. !empty(aPaymentId[11])
             //avalia permissão de acesso para tansferência de empresas
             For nX:=1 to Len(aTransfSeg)
                 //        filial/mat solicitado na requisição              e           filial/mat logado no app    
                 If ( (aTransfSeg[nX][2] == aPaymentId[1]+aPaymentId[2])  .and.  (aTransfSeg[nX][5] == cBranchVld+cMatSRA) ) .or. ;
                    ( (aTransfSeg[nX][5] == aPaymentId[1]+aPaymentId[2])  .and.  (aTransfSeg[nX][5] == cBranchVld+cMatSRA) )
                    lVldAut    := .T.
                    lMatTransf := .T.
                    Exit
                 EndIf
             Next
          Else
             lVldAut := fVldSolAut(cBranchVld, cMatSRA, aPaymentId[1], Iif(nSize >= 2,aPaymentId[2],"" ), @aMessages,,cRD0Login)
          EndIf    
       EndIf	   
	EndIf

	//Valida se o usuário autenticado tem acesso a essas informações
	//Download holerite e informe de rendimentos as informações de usuário/matricula são capturados do token e não de query param
	If nSize > 0 .And. ( (aPaymentId[1] == "{current}" .Or. aPaymentId[1] == "report" .Or. Self:aUrlParms[1] == "annualReceipt") .Or. lVldAut  )
		cSyntax	:= ::aURLParms[1]
	
		If nLenParms == 2 .And. !Empty(::aURLParms[2]) .And. ::aURLParms[1] == "payments"
			GetPayment(cMatSRA,cBranchVld,Self:initView,Self:endView,@aData,@aMessages,cJsonObj)
			lRecibo := .T.
		
		ElseIf nLenParms == 2 .And. !Empty(::aURLParms[2]) .And. ::aURLParms[1] == "detail"
            //Reposiciona SRA para o tratamento de transfências entre empresas 
            If lMatTransf
               SX2->(dbclosearea())
               OpenSxs(,,,,aPaymentId[11],"SX2","SX2",,.F.)
            
               EmpOpenFile(cAliasSRA, cAliasSRA, 1, .T., aPaymentId[11], cModoSRA)
               cFilAnt := aPaymentId[1]
               cEmpAnt := aPaymentId[11]

               //Posiciona SRA
               dbSelectArea("SRA")
               SRA->( dbSetOrder(1) )
               SRA->( dbSeek( xFilial("SRA" , aPaymentId[1]) + aPaymentId[2]) )
            EndIf
		
			GetResume(cMatSRA,cBranchVld,Self:initView,Self:endView,@aData,cJsonObj,@oItemDetail,aPaymentId)

			lPayment := .F.
			lRecibo := .T.

		ElseIf ( nLenParms == 2 .Or. nLenParms == 4 ).And. !Empty(::aURLParms[1]) .And. "annualReceipt" $ cSyntax 
			nTipo := If( cSyntax == "annualReceipt", 2, 1 )			
			GetAnnualRec( nTipo, cMatSRA, cBranchVld, cJsonObj, @aData, cYear, @cjson )
			lPayment := .F.
			
		ElseIf nLenParms == 4 .And. ::aURLParms[1] == "payments" .And. ::aURLParms[2] == "report"
            //Reposiciona tabelas para o tratamento de transfências entre empresas 
            If lMatTransf
               SX2->(dbclosearea())
               OpenSxs(,,,,aPaymentId[11],"SX2","SX2",,.F.)
            
               EmpOpenFile(cAliasSRA, cAliasSRA, 1, .T., aPaymentId[11], cModoSRA)
               cFilAnt := aPaymentId[1]
               cEmpAnt := aPaymentId[11]

               //Posiciona SRA
               dbSelectArea("SRA")
               SRA->( dbSetOrder(1) )
               SRA->( dbSeek( xFilial("SRA" , aPaymentId[1]) + aPaymentId[2]) )

               EmpOpenFile("RCH","RCH",1,.T.,cEmpAnt,FWModeAccess("RCH"))
               EmpOpenFile("SRC","SRC",1,.T.,cEmpAnt,FWModeAccess("SRC"))
               EmpOpenFile("SRD","SRD",1,.T.,cEmpAnt,FWModeAccess("SRD"))
               EmpOpenFile("SRV","SRV",1,.T.,cEmpAnt,FWModeAccess("SRV"))
               EmpOpenFile("SRQ","SRQ",1,.T.,cEmpAnt,FWModeAccess("SRQ"))
               EmpOpenFile("SRY","SRY",1,.T.,cEmpAnt,FWModeAccess("SRY"))
               EmpOpenFile("RCA","RCA",1,.T.,cEmpAnt,FWModeAccess("RCA"))
            Else
               cFilAnt := cBranchVld
            EndIf
 
			 GetPaymRec(aPaymentId, @cjson )
			 lPayment := .F.
		EndIf
	EndIf
EndIf

If lMatTransf
   SX2->(dbclosearea())
   OpenSxs(,,,,cSavEmp,"SX2","SX2",,.F.)
               
   EmpOpenFile("SRA","SRA",1,.T.,cSavEmp,FWModeAccess("SRA"))
   EmpOpenFile("RCH","RCH",1,.T.,cSavEmp,FWModeAccess("RCH"))
   EmpOpenFile("SRC","SRC",1,.T.,cSavEmp,FWModeAccess("SRC"))
   EmpOpenFile("SRD","SRD",1,.T.,cSavEmp,FWModeAccess("SRD"))
   EmpOpenFile("SRV","SRV",1,.T.,cSavEmp,FWModeAccess("SRV"))
   EmpOpenFile("SRQ","SRQ",1,.T.,cSavEmp,FWModeAccess("SRQ"))
   EmpOpenFile("SRY","SRY",1,.T.,cSavEmp,FWModeAccess("SRY"))

   cFilAnt := cSavFil
   cEmpAnt := cSavEmp
EndIf 

If lRecibo
	oItem["data"]	:= Iif(Empty(aData),oItemDetail,aData)
	oItem["length"]	:= Iif(Empty(aData),1,Len(aData))
	
	If Len(aData) < 1 .And. lPayment
		oMessages["type"]   := "info"
		oMessages["code"]   := ""
		oMessages["detail"] := EncodeUTF8(STR0004) //"Não há recibos disponíveis para visualização."
		
		Aadd(aMessages, oMessages)
	Elseif !lPayment .and. Len(oItemDetail["events"]) < 1 
	    oItem["data"]       := aData
	    
	    oMessages["type"]   := "info"
	    oMessages["code"]   := ""
	    oMessages["detail"] := EncodeUTF8(STR0005) //"o servidor não respondeu nossa requisição :("
	
	    Aadd(aMessages, oMessages)
	EndIf
	
	oItem["messages"]	:= aMessages
Else
	If nTipo == 1
		oItem["hasNext"] 	:= .F.
		oItem["items"] 		:= aData
	EndIf
EndIf

If lRecibo .Or. nTipo == 1 
	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	::SetResponse(cjson)
Else
	cArqName 	:= AllTrim(cBranchVld) + "_" + AllTrim(cMatSRA)
	cArqLocal 	:= GetSrvProfString ("STARTPATH","") + cArqName
	
	If Empty( cjson )
		fPDFMakeFileMessage( STR0018, cArqName, @cjson ) //"Durante o processamento ocorreram erros que impediram a gravação dos dados. Tente novamente mais tarde."
	EndIf
	
	::SetHeader("Content-Disposition", "attachment; filename="+ cArqName + ".PDF" )
	::SetResponse(cjson)    	    
EndIf

FreeObj(oItem)
FreeObj(oItemDetail)
FreeObj(oMessages)

Return(.T.)  

// -------------------------------------------------------------------
// RETORNA A DISPONIBILIDADE DA FOLHA DE PAGAMENTO DO FUNCIONÁRIO
// -------------------------------------------------------------------
WSMETHOD GET GetPayAvailable WSREST Payment

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local aPerAtual		:= {}
Local aDateGMT		:= {}
Local cJson			:= ""
Local cQuery		:= ""
Local cRotFOL		:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local cMatSRA		:= ""
Local cCodFol		:= ""
Local dDtPagto		:= ""
Local cDtPagto		:= ""
Local nQtdTotal		:= 0

	::SetHeader('Access-Control-Allow-Credentials' , "true")
	
	cToken		:= Self:GetHeader('Authorization')
	cBranchVld	:= GetBranch(cToken)
	cMatSRA     := GetRegisterHR(cToken)

	//----------------------------------------------------------
	//Obtem os dados do Funcionario e do periodo da folha
	//----------------------------------------------------------
	DbSelectArea("SRA")
	If SRA->( dbSeek( cBranchVld + cMatSRA ) )
	
		cRotFOL := fGetRotOrdinar() //Roteiro da folha
		fGetPerAtual( @aPerAtual, xFilial("RCH", cBranchVld), SRA->RA_PROCES, cRotFOL )
		
		If Len( aPerAtual ) > 0
			
			dDtPagto := aPerAtual[1,11]
			cDtPagto := dToS( dDtPagto )
			aDateGMT := LocalToUTC( cDtPagto, "12:00:00" )
		
		 	If dDataBase <= ( dDtPagto + 5 ) //Disponivel por 5 dias a partir do pagamento
		 	
		 		cCodFol	:= fGetCodFol("0318") //O saldo de salario sera a verba de referencia
		 		cQuery	:= GetNextAlias()

				BEGINSQL ALIAS cQuery
					SELECT RC_PD, COUNT(*) QTD
					FROM
						%Table:SRC% SRC
					WHERE
						SRC.RC_FILIAL = %Exp:cBranchVld% AND
						SRC.RC_MAT = %Exp:cMatSRA% AND
						SRC.RC_PD = %Exp:cCodFol% AND
						SRC.RC_ROTEIR = %Exp:cRotFOL% AND
						SRC.RC_PROCES = %Exp:SRA->RA_PROCES% AND
						SRC.RC_DATA = %Exp:cDtPagto% AND
						SRC.%NotDel%
					GROUP BY SRC.RC_PD
				ENDSQL

				While (cQuery)->(!Eof())
				    nQtdTotal += (cQuery)->QTD
				    (cQuery)->(DbSkip())
				EndDo
				
				(cQuery)->(dbCloseArea())
																																
			    oItem["paymentId"]   := cBranchVld +"|"+ cMatSRA +"|"+ aPerAtual[1,8] +"|"+ aPerAtual[1,3] +"|"+ aPerAtual[1,1] +"|"+ aPerAtual[1,2]	//Filial + Matricula + Processo + Roteiro + Periodo + Num.Pagto
			    oItem["paymentDate"] := Substr(cDtPagto,1,4) + "-" + Substr(cDtPagto,5,2) + "-" + Substr(cDtPagto,7,2) + "T" + aDateGMT[2] + "Z"
			    oItem["isAvailable"] := nQtdTotal > 0

			EndIf

		EndIf		

	EndIf

	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	::SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
//Retorna os tipos de alteracao salarial
// -------------------------------------------------------------------
WSMETHOD GET gTypeSalaryChanges WSREST Payment

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oTipos		:= &cJsonObj
Local cJson			:= ""
Local nX			:= 0
Local aGetTipos		:= {}
Local aTipos		:= {}

Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	aGetTipos := fRetTipos() 

	If Len(aGetTipos) > 0
		For nX := 1 To Len(aGetTipos)
			oTipos 			:= &cJsonObj 
			oTipos["id"]	:= aGetTipos[nX,1] +"|"+ AllTrim(aGetTipos[nX,2])
			oTipos["name"]	:= EncodeUTF8( aGetTipos[nX,3] )
			aAdd(aTipos, oTipos)		
		Next nX
	EndIf
	
	oItem["items"] 	  := aTipos
	oItem["hasNext"]  := .F.

	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	Self:SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
//Retorna o historico de alteracoes salariais
// -------------------------------------------------------------------
WSMETHOD GET SalaryChanges WSREST Payment

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oHistSal		:= &cJsonObj
Local oDados		:= &cJsonObj
Local oTpChange		:= &cJsonObj
Local oRegs			:= &cJsonObj
Local cFilter		:= ""
Local cAliasSR7		:= ""
Local cJson			:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local cMatSRA		:= ""
Local cPercent		:= ""
Local cLastYear		:= ""
Local cYear			:= ""
Local cDtIni		:= ""
Local cDtFim		:= ""
Local cType			:= ""
Local nX			:= 0
Local nUltSal		:= 0
Local nTotReg		:= 0
Local nCount		:= 0
Local nIniCount	  	:= 0 
Local nFimCount 	:= 0
Local nPos			:= 0
Local aHist			:= {}
Local aDados		:= {}
Local aRegs			:= {}
Local aGetTipos		:= {}
Local lMorePage		:= .F.

DEFAULT Self:typeChange	:= ""
DEFAULT Self:page		:= "1"
DEFAULT Self:pageSize	:= "6"
DEFAULT Self:initDate	:= ""
DEFAULT Self:endDate	:= ""

	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	cToken		:= Self:GetHeader('Authorization')
	cBranchVld	:= GetBranch(cToken)
	cMatSRA     := GetRegisterHR(cToken)

	//Posiciona a tabela SRA na matricula que esta sendo gerado o historico
	dbSelectArea("SRA")
	SRA->( dbSetOrder(1) )
	If SRA->( dbSeek( cBranchVld + cMatSRA ) )
	
		//Aplica os filtros caso sejam informados
		If !Empty(Self:typeChange)
			cType   := STRTOKARR( Self:typeChange, "|" )[2]
			cFilter += " R7_TIPO = '" + cType + "' AND "
		EndIf	
		If !Empty(Self:initDate)
			cDtIni 	:= StrTran( SubStr(Self:initDate, 1, 10), "-", "" )
			cFilter += " R7_DATA >= '" + cDtIni + "' AND "
		EndIf
		If !Empty(Self:endDate)
			cDtFim 	:= StrTran( SubStr(Self:endDate, 1, 10), "-", "" )
			cFilter += " R7_DATA <= '" + cDtFim + "' AND "
		EndIf

		//Faz o controle de paginacao
		If Self:page == "1" .Or. Empty(Self:page)
		 	nIniCount := 1 
			nFimCount := If( Empty(Self:pageSize), 6, Val(Self:pageSize) )
		Else
			nIniCount := ( Val(Self:pageSize) * ( Val(Self:page) - 1 ) ) + 1
			nFimCount := ( nIniCount + Val(Self:pageSize) ) - 1
		EndIf
	
		cAliasSR7 := GetNextAlias()
		cFilter	  := If( Empty(cFilter), "%%", "%" + cFilter + "%")

		BeginSQL Alias cAliasSR7
			SELECT
				R7_FILIAL, R7_MAT, R7_DATA, R7_TIPO, R3_DATA, R3_TIPO, R3_VALOR 
			 FROM
				%Table:SR7% SR7
				JOIN %Table:SR3% SR3 ON R3_FILIAL = R7_FILIAL AND R3_MAT = R7_MAT AND R3_DATA = R7_DATA AND R3_TIPO = R7_TIPO AND R3_SEQ = R7_SEQ
			WHERE
				SR7.R7_FILIAL = %Exp:cBranchVld% AND
				SR7.R7_MAT = %Exp:cMatSRA% AND
				%Exp:cFilter%
				SR7.%NotDel% AND
				SR3.%NotDel%
			ORDER BY 1,2,3
		EndSQL
		
		While ( (cAliasSR7)->(!Eof()) )		

			If nUltSal > 0
				cPercent := Round( (( (cAliasSR7)->R3_VALOR / nUltSal )-1) * 100, 2 )
				cPercent := cValToChar( cPercent )
			Else
				cPercent := "0"
			EndIf
	
			aAdd( aHist, { ;
							(cAliasSR7)->R7_FILIAL, ;									//1 - Filial
							(cAliasSR7)->R7_MAT, ;										//2 - Matricula
							(cAliasSR7)->R7_DATA, ;										//3 - Data da alteracao salarial
							FwTimeStamp(6, SToD((cAliasSR7)->R7_DATA), "12:00:00" ), ;	//4 - Data formato UTF (para retorno do JSON)
							AllTrim((cAliasSR7)->R7_TIPO), ;							//5 - Tipo da alteracao salarial
							(cAliasSR7)->R3_VALOR, ;									//6 - Valor do salario atualizado
							cPercent ;													//7 - Percentual de aumento
						 } )		
			
			nUltSal	:= (cAliasSR7)->R3_VALOR
			
			(cAliasSR7)->( dbSkip() )
		End
	
		(cAliasSR7)->(dbCloseArea())
	
	EndIf
	
	If ( nTotReg := Len(aHist) ) > 0 
	
		aGetTipos := fRetTipos()
	
		ASORT( aHist, , , { | x,y | x[1]+x[2]+x[3] > y[1]+y[2]+y[3] } )
		For nX := 1 To nTotReg
			
			nPos	:= aScan( aGetTipos, {|x| x[2] == aHist[nX,5]} )
			cYear	:= SubStr( aHist[nX,3], 1, 4 )
			lAdd	:= nX == nTotReg .Or. ( nX+1 <= nTotReg .And. !cYear == SubStr( aHist[nX+1,3], 1, 4 ) )
			nCount	+= If( nX == 1 .Or. lAdd, 1, 0)
			
			If ( nCount >= nIniCount .And. nCount <= nFimCount )
				
				//Guarda os registro de aumento de cada ano
				oTpChange			:= &cJsonObj
				oTpChange["id"]		:= cValToChar(aHist[nX,5])
				oTpChange["name"]	:= If( nPos > 0, aGetTipos[nPos,3], STR0017 ) //"Indefinido"
				
				oRegs				:= &cJsonObj 
				oRegs["id"]			:= aHist[nX,1] +"|"+ aHist[nX,2] +"|"+ aHist[nX,3] +"|"+ aHist[nX,5] //Filial + Matricula + Data + Tipo
				oRegs["data"]		:= aHist[nX,4]
				oRegs["reason"]		:= oTpChange 
				oRegs["percent"]	:= aHist[nX,7]
				oRegs["salary"]		:= aHist[nX,6]
				aAdd( aRegs, oRegs )
				
				//Envia o total de registros guardados quando ocorre a mudanca de ano ou quando processa o ultimo registro
				If lAdd 
					oHistSal := &cJsonObj
					oHistSal["year"]					:= Val(cYear)
					oHistSal["salaryHistoryChanges"]	:= aRegs
					aAdd( aDados, oHistSal )
	
					aRegs := {}
				EndIf
			Else
				If nCount > nFimCount
					lMorePage := .T.
					Exit
				EndIf				
			EndIf
			
		Next nX

		oItem["items"] 	  := aDados
		oItem["hasNext"]  := lMorePage
	
	EndIf

	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	Self:SetResponse(cJson)

Return(.T.)

/*/{Protheus.doc} GetAnnualRec
- Função responsável carregar a lista de informes de rendimentos e disponibilizar o informe para download
@author:	Marcelo Silveira
@since:		29/01/2019
/*/
Function GetAnnualRec( nTipo, cMatSRA, cBranchVld, cJsonObj, aEvents, cAnoBas, cFile )

	Local oItem		:= Nil
	Local aArea     := GetArea()
	Local cARAlias	:= ""
	Local cFiltro	:= ""
	Local cArqLocal	:= ""
	Local nCont		:= 0
	Local lContinua := .T.
	
	DEFAULT cJsonObj := "JsonObject():New()"
	DEFAULT aEvents  := {}
	DEFAULT cAnoBas	 := ""
	DEFAULT cFile	 := ""

	dbSelectArea("SRA")
	dbSetOrder(1)

	If !dbSeek( cBranchVld + cMatSRA )
		Return .F.
	Endif

	If nTipo == 1 //Relacao de informes
		cFiltro	+= " SR4.R4_FILIAL = '" + cBranchVld + "' AND SR4.R4_MAT = '" + cMatSRA + "'"
		cFiltro	+= " AND RHX.RHX_FILIAL = '" + xFilial("RHX", cBranchVld) + "'"
		cFiltro := "% " + cFiltro + " %"
			 
		cARAlias:= GetNextAlias()  
		
		BeginSql alias cARAlias
			SELECT DISTINCT(SR4.R4_ANO)
				 , RHX.RHX_FILIAL
				 , RHX.RHX_ANOBAS
			     , RHX.RHX_DMLIBE
			     , RHX.RHX_DMINFO
			     , RHX.RHX_RESPON
			  FROM %table:RHX% RHX
	        INNER JOIN %table:SR4% SR4
	            ON SR4.R4_ANO = RHX.RHX_ANOBAS
	         WHERE %exp:cFiltro% 
	           AND RHX.%notDel% 
	           AND SR4.%notDel%
	      ORDER BY RHX_ANOBAS DESC
		EndSql

		While (cARAlias)->( !Eof())
			
			If Date() >= SToD( Soma1((cARAlias)->RHX_ANOBAS) + Substr( (cARAlias)->RHX_DMLIBE, 3, 4) + Substr( (cARAlias)->RHX_DMLIBE, 1, 2) ) 
				oItem						:= JsonObject():New()
				oItem["id"]          		:= EncodeUTF8( cBranchVld + cMatSRA ) //D MG 01 |000001|2018		"D MG 01 |900001|00020|132|201712|1|2"
				oItem["calendarYear"] 		:= EncodeUTF8( (cARAlias)->RHX_ANOBAS )	//2018
				oItem["pdfDownloadVisible"] := .T.
				oItem["htmlViewVisible"]    := .F.
				Aadd(aEvents,oItem)
				FreeObj(oItem)
			EndIf
			
			(cARAlias)->( dbSkip() )
		EndDo
		 
		(cARAlias)->( dbCloseArea() )
		RestArea(aArea)
	
	Else //Arquivo para download
		
	    If !Empty( cAnoBas )

		    cFileName 	:= AllTrim(cBranchVld) + "_" + AllTrim(cMatSRA) + ".PDF"
		    cArqLocal 	:= GetSrvProfString ("STARTPATH","") + cFileName

		    //Exclui arquivos anteriores caso existam no servidor
		    fErase(cArqLocal)

		    GPEM580(.T., cBranchVld, cMatSRA, cAnoBas, .F., .T.)

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

			    //Em ambiente lento o sistema esta demorando para gerar o arquivo PDF
			    //Como alternativa pesquisaremos o arquivo durante 5 segundos no maximo
			    If ( lContinua := Empty(cFile) .And. nCont < 4 )
			    	nCont++
			    	Sleep(1000)
			    	conout( EncodeUTF8(">>>"+ STR0013 +"("+ cValToChar(nCont) +")") ) //"Aguardando a geração do arquivo PDF..."
			    EndIf
		    End
	    EndIf
	    
	EndIf	
	  		
Return(.T.)

/*/{Protheus.doc}GetPayment
- Função responsável por manipular e criar o JSON do RESUMO do demonstrativo de pagamento.
@author:	Matheus Bizutti
@since:		07/06/2017
/*/
Function GetPayment(cRegistration,cFilFun,initView,endView,aData,aMessages,cJsonObj)

Local oItem 	
Local aVerbas	 := {}
Local oPayments  := Nil
Local nType		 := 0
Local aDateGMT	 := {}
Local cSRCBranch := ""
Local cSRDBranch := ""
Local nTamArray	 := 0
Local aTransf	 := {}
Local nIAux		 := 0
Local lTransfEmp := .F.
Local nPosTransf := 0
Local aTransAux	 := {}
Local nTrans 	 := 1
Local dDataTrf 	 :=	ctod("  /  /  ")

Private cQuery       := GetNextAlias()
						
DEFAULT initView 	 := ""
DEFAULT endView  	 := ""	
DEFAULT cRegistration:= ""	
DEFAULT aData		 := {}
DEFAULT aMessages	 := {}		
DEFAULT cFilFun		 := FwCodFil()	
DEFAULT cJsonObj	 := "JsonObject():New()"

aAdd(aVerbas, fGetCalcRot('2')) // ADI
aAdd(aVerbas, fGetCalcRot('1')) // FOL
aAdd(aVerbas, fGetCalcRot('5')) // 131
aAdd(aVerbas, fGetCalcRot('6')) // 132
aAdd(aVerbas, fGetCalcRot('F')) // PLR
aAdd(aVerbas, fGetCalcRot('9')) // AUT

cSRCBranch := cSRDBranch := cFilFun
oPayments  := &cJsonObj 


dbSelectArea("SRA")
SRA->( dbSetOrder(1) )

If SRA->( DBSeek(xFilial("SRA", cFilFun) + cRegistration) )
    fTransfAll(@aTransf,,,.T.)
    nTamArray	:= Len(aTransf)

    // - Verifica se houve transferência apenas entre empresas e com troca de matrículas.
    aEval( aTransf , { |x| If( x[1] != x[4] , ( lTransfEmp := .T. ) , NIL ) } )	
EndIf


If lTransfEmp
	//Despreza transferencias de centro de custo
	While nTrans > 0
		If ( nTrans := aScan( aTransf, { |x| x[1] + x[2] == x[4] + x[5] .And. x[3] <> x[6] } ) ) > 0
			aDel( aTransf, nTrans )
			aSize( aTransf, Len(aTransf) - 1 )
		EndIf
	EndDo

	
	For nIAux := 1 To Len(aTransf)
		
		nPosTransf := aScan(aTransAux, {|x| x[1] == aTransf[nIAux][1]} )
		
		If ( nPosTransf > 0 )
			aAdd(aTransAux[nPosTransf],{aTransf[nIAux][8],aTransf[nIAux][9],aTransf[nIAux][12],aTransf[nIAux][4],dDataTrf})
		Else
			aAdd(aTransAux,{aTransf[nIAux][1],{aTransf[nIAux][8],aTransf[nIAux][9],aTransf[nIAux][12],aTransf[nIAux][4],dDataTrf}})
		EndIf
		 
		If nIAux == Len(aTransf)
			nPosTransf := 0
			nPosTransf := aScan(aTransAux, {|x| x[1] == aTransf[nIAux][4]} )
			
			If ( nPosTransf > 0 )
				aAdd(aTransAux[nPosTransf],{aTransf[nIAux][10],aTransf[nIAux][11],,aTransf[nIAux][4],aTransf[nIAux][12]})
			Else
				aAdd(aTransAux,{aTransf[nIAux][4],{aTransf[nIAux][10],aTransf[nIAux][11],,aTransf[nIAux][4],aTransf[nIAux][12]}})
			EndIf
		EndIf
		
		dDataTrf := aTransf[nIAux][12]
	Next nIAux

	TransfEmp(aTransAux,aVerbas,oPayments,cJsonObj,aData)

Else
	// - Obtém a Query
	DetailReceipts(@cQuery,nTamArray,aTransf,cSRCBranch,cRegistration,cSRDBranch,cFilFun,.T.,initView,endView,.T.,.T.)
		
	// - Setar o JSON.
	SetReceipts(cQuery,oPayments,cJsonObj,aData,aVerbas)
EndIf

(cQuery)->(dbCloseArea())

Return(Nil)

/*/{Protheus.doc}TransfEmp
- Função responsável por criar o corpo do JSON do resumo do demonstrativo de pagamento para funcionários com transferência entre empresas.
@author:	Matheus Bizutti
@since:		07/06/2017
/*/
Function TransfEmp(aTransAux,aVerbas,oPayments,cJsonObj,aData)

Local nCount        := 0
Local cSRCEmp       := ""
Local cSRDEmp       := ""
Local cSRVEmp	    := ""

Private aPerTransf  := {}     

DEFAULT aTransAux	:= {}
DEFAULT aVerbas 	:= {}
DEFAULT cJsonObj	:= "JsonObject():New()"
DEFAULT oPayments	:= &cJsonObj
DEFAULT aData		:= {}

// - Percorrer as transfêrencias do funcionário.
For nCount := 1 To Len(aTransAux)
	
	/*******************************************************
	 - Efetua a montagem da query com os dados corretos.	
	********************************************************/
	If nCount > 1
		cQuery := ""
		cQuery := GetNextAlias()
	EndIf
	
	// - Empresa utilizada para a busca dos resultados.
	cSRCEmp := "%SRC"+aTransAux[nCount][1]+"0%"
	cSRDEmp := "%SRD"+aTransAux[nCount][1]+"0%"
	cSRVEmp := "%SRV"+aTransAux[nCount][1]+"0%"
	
	// Obtém a Query
	TransferDetails(@aTransAux, nCount, cSRCEmp, cSRDEmp, cSRVEmp, @cQuery, .T.)

	// - Monta o Json
	SetReceipts(@cQuery, oPayments, cJsonObj, @aData, aVerbas, aTransAux[nCount][1])
	
Next nCount

  //ordena os períodos por (Data de Referencia + Data de Pagamento + Roteiro)
  ASORT(aPerTransf, , , { | x,y | x[14]+x[9]+x[5] > y[14]+y[9]+y[5] } )

  MountPayments(aPerTransf,oPayments,cJsonObj,aData,aVerbas) 

Return(Nil)

/*/{Protheus.doc}SetReceipts
- Função responsável por criar o corpo do JSON do resumo do demonstrativo de pagamento (data de pagamento, tipo e valor líquido)
@author:	Matheus Bizutti
@since:	07/06/2017
/*/
Function SetReceipts(cQuery,oPayments,cJsonObj,aData,aVerbas,cEmp)

Local nType       := 0
Local cKey        := ""
Local nPos        := 0
Local nX, nTam    := 0
Local aPeriodo    := {}
Local lExistPE    := ExistBlock("LIBRECPAG")
Local lMostraRec  := .F.
Local cOpReg      := GetMv('MV_TCF013A',,'01.02.03.04.05')
Local aLibDemo    := { Val(getmv("MV_TCFDADT", NIL, "0")),;
                       Val(getmv("MV_TCFDFOL", NIL, "0")),;
                       Val(getmv("MV_TCFD131", NIL, "0")),;
                       Val(getmv("MV_TCFD132", NIL, "0")),;
                       Val(getmv("MV_TCFDEXT", NIL, "0")),;
                       Val(getmv("MV_TCFDFOL", NIL, "0"))  }

DEFAULT cJsonObj  := "JsonObject():New()"
DEFAULT oPayments := &cJsonObj
DEFAULT aData	  := {}
DEFAULT cQuery	  := GetNextAlias()
DEFAULT aVerbas	  := {}
DEFAULT cEmp	  := ""

If !Empty(cQuery)
	
	While !(cQuery)->(Eof()) 

      cKey := (cQuery)->FILIAL + (cQuery)->MATRICULA + (cQuery)->PROCESSO + (cQuery)->RC_ROTEIR + (cQuery)->RC_PERIODO + (cQuery)->RC_SEMANA +'-' +cEmp
        
      nType := aScan(aVerbas, {|aItemVerba| aItemVerba == (cQuery)->RC_ROTEIR } )
      nPos := Ascan(aPeriodo,{|x| x[1] == cKey})
      cTipVerba := Posicione("SRV",1,xFilial('SRV', SRA->RA_FILIAL)+(cQuery)->VERBA,"RV_TIPOCOD") 

      //validação de carregamento de recibo na lista
      lMostraRec  := .F.

      If lExistPE
         lRetBlock := ExecBlock("LIBRECPAG",.F.,.F.,{(cQuery)->DATAPAGTO,(cQuery)->FILIAL,(cQuery)->MATRICULA, nType, Val(SubStr((cQuery)->RC_PERIODO,1,4)), Val(SubStr((cQuery)->RC_PERIODO,5,2)) })
         lMostraRec := If( ValType(lRetBlock) == "L" , lRetBlock , .T. )         
      Else
         If ( nType == 2 )
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Trata o parametro "MV_TCFDFOL" como excecao, pois este parametro indica a quantidade de dias para liberacao ³
            //³do demonstrativo. Os demais parametros, indicam a data inicial de liberacao.                                ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If ( aLibDemo[nType] < 0 )
                 lMostraRec  :=  dDataBase - STOD((cQuery)->DATAPAGTO) >= aLibDemo[nType]
            Else
                 lMostraRec  :=  dDataBase >= STOD((cQuery)->DATAPAGTO) + aLibDemo[nType]
            EndIf
         Else
            If nType > 0
               dDataLib    :=  STOD( MesAno((cQuery)->DATAPAGTO) + STRZERO(aLibDemo[nType] , 2) )
               lMostraRec  := ( dDataBase  >= dDataLib )
            EndIf
         EndIf

         //valida se o tipo de holerite deve ser mostrado, para que aconteça os itens deverão ser lanctos no Param
         //01-Adiantamento, 02-Folha, 03-1ª parcela do 13º, 04-2ª parcela do 13º e 05-Valores Extras
         If lMostraRec .and. !Empty(cOpReg) .and. !( cValToChar(nType) $ cOpReg )
            lMostraRec := .F.
         EndIF
      EndIf
             
      If ( lMostraRec )
		  If nPos == 0
			  If cTipVerba == "1"
				  aadd(aPeriodo,{ cKey, (cQuery)->FILIAL , (cQuery)->MATRICULA , (cQuery)->PROCESSO , (cQuery)->RC_ROTEIR , (cQuery)->RC_PERIODO , (cQuery)->RC_SEMANA, (cQuery)->ARCHIVED, (cQuery)->DATAPAGTO, nType, (cQuery)->RC_VALOR, .T., cEmp})
			  Elseif cTipVerba == "2"
				  aadd(aPeriodo,{ cKey, (cQuery)->FILIAL , (cQuery)->MATRICULA , (cQuery)->PROCESSO , (cQuery)->RC_ROTEIR , (cQuery)->RC_PERIODO , (cQuery)->RC_SEMANA, (cQuery)->ARCHIVED, (cQuery)->DATAPAGTO, nType, (cQuery)->RC_VALOR * -1, .T., cEmp})
			  EndIf
          Else
			  If cTipVerba == "1"
				  aPeriodo[nPos][11] := aPeriodo[nPos][11] + (cQuery)->RC_VALOR
              Elseif cTipVerba == "2"
			      aPeriodo[nPos][11] := aPeriodo[nPos][11] + ((cQuery)->RC_VALOR * -1)
              EndIf
		  EndIf
     EndIf
     
     //Se alguma verba não puder ser exibida no recibo, todo o envelope nao será apresentado para não mostrar valores incorretos
     If !lMostraRec .And. nPos > 0
      	 aPeriodo[nPos, 12] := .F.
     EndIf
		
     (cQuery)->(dbSkip()) 
	EndDo
	

    //Registra data de referencia nas ocorrências antes do ordenamento
    aPeriodo := SaveDtReference(aPeriodo)

    If Len(aPeriodo) > 0 .and. empty(cEmp)
       //ordena os períodos por (Data de Referencia + Data de Pagamento + Roteiro)
       ASORT(aPeriodo, , , { | x,y | x[14]+x[9]+x[5] > y[14]+y[9]+y[5] } )

	   MountPayments(aPeriodo,oPayments,cJsonObj,aData,aVerbas) 

    ElseIf Len(aPeriodo) > 0
      //acumula array para tratar transferências
      If len(aPerTransf) > 0
         nTam := len(aPerTransf) + 1
         For nX := 1 To Len(aPeriodo)
             aAdd(aPerTransf)
         Next nX

         aCopy(aPeriodo, aPerTransf, , , nTam) 
      Else
         aPerTransf := aPeriodo      
      EndIf 

	EndIf
EndIf

Return(Nil)


/*/{Protheus.doc}SaveDtReference
- Prepara data de referência para ordenação
/*/
Function SaveDtReference(aPeriodo)
Local nI            := 1
Local aDatePg       := {}
Local aPerReference := {}
Local cEmpRCH       := ""
Local cFilRCH       := ""
Local cKeyPg        := ""
Local cDtRef        := ""
Local cDtPagto      := ""
Local cQryRCH       := GetNextAlias()

     For nI := 1 To Len(aPeriodo)
        
         If aPeriodo[nI, 12]

            //Apresenta a data de pagamento conforme a data de pagamento do periodo (RCH)
            cKeyPg := aPeriodo[nI,2] + aPeriodo[nI,4] + aPeriodo[nI,6] + aPeriodo[nI,7] + aPeriodo[nI,5]
            
            If ( nPos := aScan( aDatePg, {|x| x[1] == cKeyPg }) ) > 0
                 cDtPagto := aDatePg[nPos,2]
            Else
                    
                If empty(aPeriodo[nI, 13]) //Empresa transf
                   If fPosPeriodo( xFilial("RCH", aPeriodo[nI,2]), aPeriodo[nI,4], aPeriodo[nI,6], aPeriodo[nI,7], aPeriodo[nI,5] )
                      aAdd( aDatePg, { aPeriodo[nI,2] + RCH->RCH_PROCES + RCH->RCH_NUMPAG + RCH->RCH_ROTEIR, DTOS(RCH->RCH_DTPAGO) } )
                      cDtPagto := DTOS( RCH->RCH_DTPAGO )
                      cDtRef   := DTOS( RCH->RCH_DTFIM )
                   Else
                      cDtPagto := LocalToUTC( aPeriodo[nI][9], "12:00:00" )[1]
                      cDtRef   := LocalToUTC( aPeriodo[nI][9], "12:00:00" )[1]
                   EndIf
                Else
                   //Busca RCH da empresa de origem para carregar as informações do holerite 
                   cEmpRCH := "%RCH" + aPeriodo[nI, 13] + "0%"
                   cFilRCH := xFilial('RCH',aPeriodo[nI,2])

                   BeginSql alias cQryRCH
                      SELECT *
                      FROM  %exp:cEmpRCH%  RCH
                      WHERE RCH_FILIAL       = %exp:cFilRCH%                                   AND
                            RCH.RCH_PER      = %exp:aPeriodo[nI,6]%                            AND
                            RCH.RCH_NUMPAG  >= %exp:aPeriodo[nI,7]%                            AND
                            (RCH.RCH_ROTEIR  = '   ' OR RCH.RCH_ROTEIR = %exp:aPeriodo[nI,5]%) AND
                            RCH.RCH_PROCES   = %exp:aPeriodo[nI,4]%                            AND
                            RCH.%notDel%
                   EndSql
                
                   If (cQryRCH)->( !Eof() )
                       aAdd( aDatePg, { aPeriodo[nI,2] + (cQryRCH)->RCH_PROCES + (cQryRCH)->RCH_NUMPAG + (cQryRCH)->RCH_ROTEIR, (cQryRCH)->RCH_DTPAGO } )
                       cDtPagto := (cQryRCH)->RCH_DTPAGO
                       cDtRef   := (cQryRCH)->RCH_DTFIM
                   Else
                       cDtPagto := LocalToUTC( aPeriodo[nI][9], "12:00:00" )[1]
                       cDtRef   := LocalToUTC( aPeriodo[nI][9], "12:00:00" )[1]
                   EndIf

                   (cQryRCH)->( dbCloseArea() )
                EndIf
                    
            EndIf       

            aadd(aPerReference     , ; 
                 { aPeriodo[nI,1]  , ; 
                   aPeriodo[nI,2]  , ;
                   aPeriodo[nI,3]  , ;
                   aPeriodo[nI,4]  , ;
                   aPeriodo[nI,5]  , ;
                   aPeriodo[nI,6]  , ;
                   aPeriodo[nI,7]  , ;
                   aPeriodo[nI,8]  , ;
                   cDtPagto        , ;
                   aPeriodo[nI,10] , ;
                   aPeriodo[nI,11] , ;
                   aPeriodo[nI,12] , ;
                   aPeriodo[nI,13] , ;
                   cDtRef           })

         EndIf  

     Next nI

Return(aPerReference)


/*/{Protheus.doc}montaPayments
- Função responsável por montar o objeto de payuments
/*/
Function MountPayments(aPeriodo,oPayments,cJsonObj,aData,aVerbas)
Local nI          := 1
Local cEmpSRY     := ""
Local cFilSRY     := ""
Local cTipVerba   := ""
Local cDtRef      := ""
Local cDtPagto    := ""
Local cQryRCH     := GetNextAlias()
Local cQrySRY     := GetNextAlias()
Local dDataLib    := CtoD('')

DEFAULT aPeriodo  := {}
DEFAULT oPayments := &cJsonObj
DEFAULT cJsonObj  := "JsonObject():New()"
DEFAULT aData     := {}
DEFAULT aVerbas   := {}

     For nI := 1 To Len(aPeriodo)
        
            If aPeriodo[nI, 12]
                oPayments               :=  &cJsonObj                               
                
                oPayments["id"]         :=  aPeriodo[nI][2]              +"|" ;
                                           +aPeriodo[nI][3]              +"|" ;
                                           +aPeriodo[nI][4]              +"|" ;
                                           +aPeriodo[nI][5]              +"|" ;
                                           +aPeriodo[nI][6]              +"|" ;
                                           +aPeriodo[nI][7]              +"|" ;
                                           +cValToChar(aPeriodo[nI][8])  +"|" ;
                                           +aPeriodo[nI][9]              +"|" ;
                                           +cValToChar(aPeriodo[nI][10]) +"|" ;
                                           +aPeriodo[nI][6]              +"|" ;
                                           +aPeriodo[nI, 13]
                
                aDateGMT                := {}
                aDateGMT                := LocalToUTC( aPeriodo[nI][9], "12:00:00" )
                
                oPayments["paymentDate"]:= Substr(aPeriodo[nI][9],1,4) + "-" + ;
                                           Substr(aPeriodo[nI][9],5,2) + "-" + ;
                                           Substr(aPeriodo[nI][9],7,2) + "T" + aDateGMT[2] + "Z"
                
                aDateGMT                := {}
                aDateGMT                := LocalToUTC( aPeriodo[nI][6]+"15", "12:00:00"  )

                oPayments["referenceDate"] := Substr(aPeriodo[nI][14],1,4) + "-" + ;
                                              Substr(aPeriodo[nI][14],5,2) + "-" + ;
                                              Substr(aPeriodo[nI][14],7,2) + "T" + aDateGMT[2] + "Z"
                
                oPayments["value"]      := aPeriodo[nI][11]

                If empty(aPeriodo[nI, 13])
                    oPayments["type"]   := Alltrim(EncodeUTF8(PosAlias("SRY", aPeriodo[nI][5], aPeriodo[nI][2], "RY_DESC")))
                Else
                   //busca descrição do roteiro na empresa de origem 
                   cEmpSRY := "%SRY" + aPeriodo[nI, 13] + "0%"
                   cFilSRY := xFilial('SRY',aPeriodo[nI,2])

                   BeginSql Alias cQrySRY
                      SELECT RY_DESC
                      FROM   %exp:cEmpSRY% SRY
                      WHERE  SRY.RY_FILIAL  = %exp:cFilSRY%         And
                             SRY.RY_CALCULO = %exp:aPeriodo[nI][5]% And
                             SRY.%notDel%
                   EndSql

                   If (cQrySRY)->( !Eof() )
                      oPayments["type"] := (cQrySRY)->RY_DESC
                   ELSE
                      oPayments["type"] := ""
                   EndIf
                   
                   (cQrySRY)->( dbCloseArea() )
                EndIf
                
                Aadd(aData,oPayments)
                oPayments := Nil
                
            EndIf
                
     Next nI

Return(Nil)


/*/{Protheus.doc}GetResume
- Função responsável por criar o corpo do JSON de resumo do demonstrativo de pagamento
@author:	Matheus Bizutti
@since:		07/06/2017
/*/
Function GetResume(cRegistration,cFilFun,initView,endView,aData,cJsonObj,oItemDetail,aPaymentId)

Local PaymentReceipt    :=  WSClassNew("TPaymentReceipts")
Local aEvents           := {}
Local aSubTotals        := {}
Local cCompany          := ""

DEFAULT cRegistration   := ""
DEFAULT cFilFun         := FwCodFil()	
DEFAULT initView        := ""
DEFAULT endView         := ""	
DEFAULT aData           := {}
DEFAULT cJsonObj        := "JsonObject():New()"
DEFAULT oItemDetail     := &cJsonObj
DEFAULT aPaymentId      := {}

PaymentReceipt:FGTSBase					:= 0	//nBaseFgts
PaymentReceipt:MontlyFGTS				:= 0	//nFgts
PaymentReceipt:IRRFCalculationBasis     := 0	//nBaseIr
PaymentReceipt:INSSSalaryContribution	:= 0
PaymentReceipt:Alimony					:= 0
PaymentReceipt:DiscountTotal			:= 0
PaymentReceipt:RevenueTotal				:= 0
PaymentReceipt:ReceivableNetValue		:= 0 
PaymentReceipt:Itens                    := {}

If len(aPaymentId) < 11 .or. empty(aPaymentId[11])
   cCompany := cEmpAnt
Else   
   cCompany := aPaymentId[11] 
EndIf

If Len(aPaymentId) > 0
	fBuildItens(@PaymentReceipt, aPaymentId[1], aPaymentId[2], Val(Substr(aPaymentId[5],5,2)), Val(Substr(aPaymentId[5],1,4)), aPaymentId[6], Val(aPaymentId[9]), Iif(aPaymentId[7] == "1" ,.T.,.F.), Stod(aPaymentId[8]), cCompany)
EndIf

PaymentReceipt:ReceivableNetValue := PaymentReceipt:RevenueTotal - PaymentReceipt:DiscountTotal

GetEvents(PaymentReceipt,@aEvents,cJsonObj)
GetSubTotals(PaymentReceipt,@aSubTotals,cJsonObj)

FreeObj(PaymentReceipt)
    
oItemDetail["id"]         := cKeyId //"D MG 01 |900001|00020|132|201712|1|2|T1"
oItemDetail["events"]     := aEvents
oItemDetail["subtotals"]  := aSubTotals

Return (Nil)


/*/{Protheus.doc}GetEvents
- Função responsável por criar o corpo do JSON dos eventos do demonstrativo de pagamento
@author:	Matheus Bizutti
@since:		07/06/2017
/*/
Static Function GetEvents(PaymentReceipt,aEvents,cJsonObj)

Local oItemEvents		:= Nil
Local nX				:= 0

Default aEvents         := {}
Default PaymentReceipt  := WSClassNew("TPaymentReceipts")
Default cJsonObj        := "JsonObject():New()" 

/****************************************************************
- Percorre os Itens do recibo de pagamento;
- e alimenta o Array aEvents utilizado na função GetResume para 
- gerar o JSON com a seguinte estrutura:
- @EXAMPLE:
	"events": [{
            "id": "112",
            "quantity": 30,
            "description": "SALARIO MENSALISTA  ",
            "value": 5000,
            "type": "proceeds"
        }
*****************************************************************/

For nX := 1 To Len(PaymentReceipt:Itens)
	
	oItemEvents					:= &cJsonObj
	
	oItemEvents["id"]          := PaymentReceipt:Itens[nX]:Code
	oItemEvents["description"] := Alltrim(EncodeUTF8(PaymentReceipt:Itens[nX]:Description))
	oItemEvents["quantity"]    := PaymentReceipt:Itens[nX]:Reference
	oItemEvents["type"]        := Iif(PaymentReceipt:Itens[nX]:Revenue > 0, "proceeds", "deduction")
	oItemEvents["value"]       := Iif(PaymentReceipt:Itens[nX]:Revenue > 0, PaymentReceipt:Itens[nX]:Revenue, PaymentReceipt:Itens[nX]:Discount) 
	
	Aadd(aEvents,oItemEvents)
	
Next nX

Return(Nil)

/*/{Protheus.doc}GetSubTotals
- Função responsável por criar o corpo do JSON dos subtotais (subtotals) do demonstrativo de pagamento.
@author:	Matheus Bizutti
@since:		07/06/2017
/*/
Static Function GetSubTotals(PaymentReceipt,aSubTotals,cJsonObj)

Default aSubTotals      := ""
Default PaymentReceipt  := WSClassNew("TPaymentReceipts")
Default cJsonObj        := "JsonObject():New()"

/*********************************************************
- Cria os objetos JSON de subtotals:[{}]
- alimenta o Array aSubTotals passado por Referência
- e este array é utilizado na função GetResume
**********************************************************/
CreateTotal(PaymentReceipt:RevenueTotal,STR0006,"proceeds",@aSubTotals,cJsonObj) //"Proventos" - Proventos Totais
CreateTotal(PaymentReceipt:DiscountTotal,STR0007,"deductions",@aSubTotals,cJsonObj) //"Descontos" - Descontos Totais
CreateTotal(PaymentReceipt:ReceivableNetValue,EncodeUTF8(STR0008),"net-value",@aSubTotals,cJsonObj) //"Líquido" - Total líquido a receber
CreateTotal(PaymentReceipt:FGTSBase,STR0009,"tax-base",@aSubTotals,cJsonObj) //"Base de FGTS" - Base FGTS
CreateTotal(PaymentReceipt:MontlyFGTS,EncodeUTF8(STR0010),"starred",@aSubTotals,cJsonObj) //"FGTS do mês" - FGTS do mês
CreateTotal(PaymentReceipt:INSSSalaryContribution,STR0011,"tax-base",@aSubTotals,cJsonObj) //"Base de INSS" - Base de INSS
CreateTotal(PaymentReceipt:IRRFCalculationBasis,STR0012,"tax-base",@aSubTotals,cJsonObj) //"Base de IRRF" -Base de IRRF

Return(Nil)

/*/{Protheus.doc}CreateTotal
- Função responsável por alimentar o array aSubTotals, que contém a estrutura dos subtotais (subtotals) do demonstrativo de pagamento
@author:	Matheus Bizutti
@since:		07/06/2017
/*/
Static Function CreateTotal(nValue,cDescription,cType,aSubTotals,cJsonObj)

Local oItemSubTotals := Nil

Default nValue          := 0
Default cDescription    := ""
Default cType           := ""
Default cJsonObj        := "JsonObject():New()"
Default aSubTotals      := {}

oItemSubTotals := &cJsonObj

/*******************************************************************************************
- Cria o objeto JSON com a estrutura:
- @EXAMPLE:
	"subtotals": [
		{
			"description": "total de proventos",
			"value": 1200,
			"type": proceeds // - proceeds deductions net-value others tax-base starred
		}
	]
********************************************************************************************/
oItemSubTotals["description"]   := cDescription
oItemSubtotals["value"]         := nValue
oItemSubTotals["type"]          := cType

Aadd(aSubTotals, oItemSubTotals)

Return(Nil)


/*/{Protheus.doc} GetPaymRec
//Gera o recibo de pagamento e retorna para o parametro cFile
@author carlos.augusto
@since 28/05/2019
@version 1.0
@return ${return}, ${return_description}
@param aPaymentId, array, Array com os parametros de entrada
@param cFile, characters, Arquivo que sera retornado para impressao
@type function
/*/
Static Function GetPaymRec(aPaymentId, cFile)
	Local cFileName 			:= ""
	Local cArqLocal 			:= ""
	Local lContinua 			:= .T.
	Local oFile
	Local nCont					:= 0
	
    cFileName 	:= AllTrim(aPaymentId[1]) + "_" + AllTrim(aPaymentId[2]) + ".PDF"
    cArqLocal 	:= GetSrvProfString ("STARTPATH","") + cFileName
    
    //Exclui arquivos anteriores caso existam no servidor
    fErase(cArqLocal)

    GPER030( .T. ,aPaymentId[1],aPaymentId[2],aPaymentId[3],aPaymentId[4],aPaymentId[5],aPaymentId[6], .T. )

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

	    //Em ambiente lento o sistema esta demorando para gerar o arquivo PDF
	    //Como alternativa pesquisaremos o arquivo durante 5 segundos no maximo
	    If ( lContinua := Empty(cFile) .And. nCont < 4 )
	    	nCont++
	    	Sleep(1000)
	    	conout( EncodeUTF8(">>>"+ STR0013 +"("+ cValToChar(nCont) +")") ) //"Aguardando a geração do arquivo PDF..."
	    EndIf
    End

Return .T.

/*/{Protheus.doc} fRetTipos
//Retorna os tipos de altaracoes salariais cadastrados no sistema
@author:	Marcelo Silveira
@since:		08/08/2019
@return:	aTipos - Matriz com os tipos de alteracoes salariais	
/*/
Static Function fRetTipos()

Local cAliasSX5		:= GetNextAlias()
Local cCpoDesc		:= ""
Local aTipos		:= {}

	//Considera a descricao correta conforme o idioma
	IF __LANGUAGE == "SPANISH"
		cCpoDesc := "% X5_DESCSPA DESCRICAO %"
	ELSEIF __LANGUAGE == "ENGLISH"
		cCpoDesc := "% X5_DESCENG DESCRICAO %"
	ELSE
		cCpoDesc := "% X5_DESCRI  DESCRICAO %"
	ENDIF

	BeginSql Alias cAliasSX5
		SELECT X5_FILIAL, X5_CHAVE, %exp:cCpoDesc%
		FROM %table:SX5% SX5
		WHERE X5_FILIAL = %xFilial:SX5% AND X5_TABELA = %exp:'41'% AND %notDel%		  
	EndSql
	
	While ( (cAliasSX5)->(!Eof()) )		
		aAdd( aTipos, { (cAliasSX5)->X5_FILIAL, AllTrim((cAliasSX5)->X5_CHAVE), AllTrim((cAliasSX5)->DESCRICAO) } )		
		(cAliasSX5)->( dbSkip() )
	End
	
	(cAliasSX5)->(dbCloseArea())

Return( aTipos )