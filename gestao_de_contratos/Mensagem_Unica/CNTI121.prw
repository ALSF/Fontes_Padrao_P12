#Include 'FWADAPTEREAI.CH'	//Include para rotinas de integração com EAI
#Include 'FWMVCDEF.CH' 		//Include para rotinas com MVC
#Include 'PROTHEUS.CH'		
#Include "CNTI121.CH"

//==============================================================================================================================
/*/{Protheus.doc} CNTI121
Função para processamento de mensagem única de integrações das medições.
Uso: CNTA121

@sample 	CNTI121( cXML, nTypeTrans, cTypeMessage )

@param		cXML 			Variavel com conteudo xml para envio/recebimento.
			nTypeTrans 	Tipo de transacao. (Envio/Recebimento)
			cTypeMessage	Tipo de mensagem.  (Business Type, WhoIs, Request)
			
@return	aRet		Array contendo o resultado da execução e o xml de retorno.
			aRet[1] 	[Logico] 	Indica o resultado da execução da função. 
			aRet[2]	[Caracter] Mensagem Xml para envio.	
			
@author	janaina.jesus
@since		14/05/2018
@version	P12.1.20
/*/
//==============================================================================================================================
Function CNTI121( cXML, nTypeTrans, cTypeMessage , cVersion )
Local aArea      := GetArea()								//- Salva contexto do alias atual  
Local aSaveLine  := FWSaveRows()							//- Salva contexto do model ativo
Local cVersions  := '2.000'

DO	CASE
	CASE cTypeMessage == EAI_MESSAGE_WHOIS
		aRet := {.T., cVersions}

	CASE AllTrim(cVersion) == '2.000'
		aRet :=  CN121V2000(cXML, nTypeTrans, cTypeMessage)
	
	OTHERWISE
		aRet :=  {.F., STR0001} //- "Opção não disponivel nesta versão."
END DO

FWRestRows( aSaveLine )     
RestArea(aArea)
Return aRet

//==============================================================================================================================
/*/{Protheus.doc} CN121V2000D
Função para processamento de mensagem única de integrações das medições. Versão 2.000

@sample 	CN121V2000( cXML, nTypeTrans, cTypeMessage )

@param		cXML 			Variavel com conteudo xml para envio/recebimento.
			nTypeTrans 	Tipo de transacao. (Envio/Recebimento)
			cTypeMessage	Tipo de mensagem.  (Business Type, WhoIs, Request)
			
@return	aRet		Array contendo o resultado da execução e o xml de retorno.
			aRet[1] 	[Logico]	Indica o resultado da execução da função. 
			aRet[2]	[Caracter] Mensagem Xml para envio.	
			
@author	janaina.jesus
@since		14/05/2018
@version	P12.1.20
/*/
//==============================================================================================================================
Function CN121V2000( cXML, nTypeTrans, cTypeMessage)
Local aArea      := GetArea()								//- Salva contexto do alias atual  
Local aSaveLine  := FWSaveRows()							//- Salva contexto do model ativo

//-- Variaveis de controle do XML ---------------------------------------------------------------------------------------------
Local oXML       := Nil										//- Objeto com o conteúdo do arquivo Xml
Local oXMLContent:= Nil										//- Objeto com o conteúdo da BusinessContent apenas

Local cXmlRet    := ''										//- Xml que será enviado pela função
Local cXmlErro   := ''										//- Mensagem de erro do parse no xml recebido como parâmetro
Local cXmlWarn   := ''										//- Mensagem de alerta do parse no xml recebido como parâmetro
Local cMarca     := ''										//- Marca do produto
Local cEvento    := ''										//- Evento

Local nCount     := 1										//- Controle na montagem da mensagem

Local aRet       := {}										//- Retorno das rotinas de inclusão/deleção
Local lRet		 := .T.										//- Retorno da execução

//-- Inicio do Adapter  -------------------------------------------------------------------------------------------------------
DO 	CASE
	CASE nTypeTrans == TRANS_RECEIVE
		DO	CASE
			CASE cTypeMessage == EAI_MESSAGE_BUSINESS

				oXML := XmlParser( cXML, '_', @cXmlErro, @cXmlWarn )	
				
				If  oXML <> Nil .And. ( Empty(cXmlErro) .And. Empty(cXmlWarn) ) 
				
					cMarca  := oXML:_TotvsMessage:_MessageInformation:_Product:_Name:Text
					
					oXMLContent := oXML:_TOTVSMessage:_BusinessMessage
					
					cEvento := Upper( oXMLContent:_BusinessEvent:_Event:Text )
					
					DO CASE 
					
						CASE cEvento == "UPSERT" 
					
							aRet:= CnPimsIncA(oXMLContent, cMarca)
							
							For nCount := 1 To Len(aRet)
								If aRet[nCount][1]
									lRet	:= lRet .And. .T.
								Else
									lRet	:= .F.
									cXMLRet += aRet[nCount][2]+'|'+aRet[nCount][3]+';'+CRLF
									FWEAILOfMessages( {{aRet[nCount][2]+'|'+aRet[nCount][3]+';'+CRLF, 1, ""}})						
								EndIf
							Next nCount				
							
						CASE cEvento == "DELETE"
						
							aRet:= CnPimsVlEx(oXMLContent,cMarca)
							
							For nCount := 1 To Len(aRet)
								If aRet[nCount][1]
									lRet	:= lRet .And. .T.
								Else
									lRet	:= .F.
									cXMLRet += aRet[nCount][2]+'|'+aRet[nCount][3]+';'+CRLF
									FWEAILOfMessages( {{aRet[nCount][2]+'|'+aRet[nCount][3]+';'+CRLF, 1, ""}} ) 
								EndIf
							Next nCount
							
						OTHERWISE 
							lRet 	:= .F.
							cXmlRet	:= STR0001
							FWEAILOfMessages( {{cXmlRet, 1, ""}} )				
					END DO					
					
				Else
					lRet    := .F.
					cXmlRet := STR0002 + cXmlErro + '|' + cXmlWarn //- "Falha no XML:"
					FWEAILOfMessages( {{STR0002 + cXmlErro + '|' + cXmlWarn +';', 1, ""}} ) //- "Falha no XML:"
				EndIf
				
			CASE cTypeMessage == EAI_MESSAGE_RESPONSE
			
				lRet := .F.
				cXmlRet := STR0001
				FWEAILOfMessages( {{cXmlRet, 1, ""}} )	
		END DO		
END DO

cXMLRet := cXMLRet

FWRestRows(aSaveLine)     
RestArea(aArea)
Return {lRet,cXmlRet}
//==============================================================================================================================
/*/{Protheus.doc} CNi121ExcM
Função paraExclusao dos mediçoes passadas pela XML Pims . Versão 2.000

@sample 	CNi121ExcM( oXml, cMarca )

@param		oXml 			Objeto com as Tag's do XML
			cMarca 	Tag do Xml de Sistema Utilizado para integrçao 
			
			
@return	aRet		Array contendo o resultado da execução e o xml de retorno.
			aRet[1] 	[Logico]	Indica o resultado da execução da função. 
			aRet[2]	[Caracter] Mensagem Xml para envio.	
			
@author	Ronaldo.Robes
@since		17/05/2018
@version	P12.1.20
/*/
//==============================================================================================================================
Function CNi121ExcM( oXml, cMarca ,aValuePiMs)
Local oModel	:= FwLoadModel("CNTA121")

Local cQry		:= ""
Local cValInt	:= ""
Local cEmpId	:= ""
Local cFilId	:= ""
Local cChave	:= ""
Local cContra	:= ""
Local cNumMed	:= ""
local cRev 		:= ""
Local cMedErro	:= ""

Local aRet		:= {}

Local nU		:= 0
LOCAL nW        := 0
Local nTam 		:= 0
Local nTamFil 	:= TamSX3("CND_FILIAL")[1]
Local nTamCtr 	:= TamSX3("CND_CONTRA")[1]
Local nTamRev 	:= TamSX3("CND_REVISA")[1]
Local nTamMed 	:= TamSX3("CND_NUMMED")[1]

Local lEst 		:= .T.

Default oXml := ''
Default cMarca := ''
Default aValuePiMs := {}

cEmpId	:= oXml:_BUSINESSCONTENT:_COMPANYID:TEXT
cChave	:= oXml:_BUSINESSEVENT:_IDENTIFICATION:_KEY:TEXT

DbSelectArea("CND")
CND->(DbSetOrder(7))
Begin Transaction

For nU := 1 to Len(aValuePiMs)
   cfilAnt := aValuePiMs[nu][1] 
  
   For nW := 1 to Len(aValuePiMs[nu][2])
	cFilId	:= SUBSTRING(aValuePiMs[nU][2][nW][1],1,nTamFil)
	cContra	:= SUBSTRING(aValuePiMs[nU][2][nW][1],(nTamFil+1),nTamCtr)
	cNumMed := SUBSTRING(aValuePiMs[nU][2][nW][1],(nTamCtr+nTamFil+nTamRev+1),nTamMed)
	cRev    := CnGetRevVg(cContra)
	
	If CND->(DbSeek(PadR(cFilId,nTamFil)+cContra + cRev +cNumMed))
		If CN121Estorn(.T.,,@cMedErro)
			oModel:SetOperation(MODEL_OPERATION_DELETE)			
			IF oModel:Activate() 
			If oModel:CommitData()
				Aadd(aRet,{.T.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContra+"|"+cNumMed,"OK"})
				CFGA070Mnt(cMarca , "CND", "CND_NUMMED", cChave ,aValuePiMs[nU][2][nW][1], .T. )
			EndIf
			EndIf
			oModel:deActivate()
		Else
			Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContra,cMedErro})
			lEst := .F.
			oModel:deActivate()
		EndIf
	Else
		Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContra+"|"+aValuePiMs[nU][1],STR0003}) //- "Registro nao encontrado"
		lEst := .F.
	EndIf
  Next nW
Next nU

If !lEst
	DisarmTransaction()
EndIf

End Transaction

Return aRet

//==============================================================================================================================
/*/{Protheus.doc} CnPimsIncA()
Função responsável pela inclusão da medição

Return
aRet[1][1] - Lógico 
aRet[1][2] - Caracter - Contrato
aRet[1][3] - Caracter - Mensagem  
@author		antenor.silva
@since		16/02/2018
@version	P12.1.20
/*/
//==============================================================================================================================
Function CnPimsIncA( oXMLContent, cMarca )
Local cContrato	:= ""
Local cRev		:= ""
Local cPlan		:= ""
Local cItem		:= ""
Local cValExt	:= ""
Local cValInt	:= ""
Local cCC		:= ""
Local cCt		:= ""
Local cIT		:= ""
Local cCv		:= ""
Local cEmpId	:= ""
Local cFilId	:= ""
Local cChave	:= ""

Local nCtrt		:= 0
Local nPlan		:= 0
Local nItem		:= 0
Local nX		:= 0
Local nY		:= 0
Local nI		:= 0
Local nP		:= 0

Local lRet		:= .T.
Local lCtrt		:= .T.
Local lIntPIMS 	:= .F.

Local aRet		:= {}

Local oModel	:= Nil
Local oModelCND	:= Nil
Local oModelCNE := Nil
Local oModelCXN := Nil
Local oXmlCtrt	:= Nil
Local oXmlPlan	:= Nil
Local oXmlItem	:= Nil
Local aInternalId := {}
Local cChvCN9 := ""

Default oXMLContent	:= Nil
Default cMarca		:= ''

cEmpId	:= oXMLContent:_BUSINESSCONTENT:_COMPANYID:TEXT
cFilId	:= oXMLContent:_BUSINESSCONTENT:_BRANCHID:TEXT
cChave	:= oXMLContent:_BUSINESSEVENT:_IDENTIFICATION:_KEY:TEXT

If ValType(oXMLContent:_BusinessContent:_ListOfContract:_Contract) == "A"
	nCtrt := Len(oXMLContent:_BusinessContent:_ListOfContract:_Contract)
Else
	nCtrt := 1
EndIf

BeGin Transaction

For nX := 1 To nCtrt // -- Percorre os contratos
	oModel		:= Nil
	oModelCND	:= Nil
	oModelCXN	:= Nil
	oModelCNE	:= Nil
	lIntPIMS	:= .F.

	oModel := FwLoadModel("CNTA121")
	oModel:SetOperation(MODEL_OPERATION_INSERT)
	oModel:Activate()
	
	If nCtrt > 1 
		oXmlCtrt := oXMLContent:_BusinessContent:_ListOfContract:_Contract[nX]
	Else
		oXmlCtrt := oXMLContent:_BusinessContent:_ListOfContract:_Contract
	EndIf
	
	If ValType("oXmlCtrt:_ContractInternalId:Text") == "C"
		cContrato := oXmlCtrt:_ContractInternalId:Text		
		cContrato := CFGA070Int( cMarca, "CN9", "CN9_NUMERO", cContrato )
		aInternalId := StrTokArr2(cContrato, '|')
		
		CN9->(DbSetOrder(1))//CN9_FILIAL+CN9_NUMERO+CN9_REVISA
		
		cChvCN9 := xFilial("CN9", aInternalId[2])
		cChvCN9 += PadR(aInternalId[3], GetSx3Cache("CN9_NUMERO","X3_TAMANHO"))
		cChvCN9 += PadR(aInternalId[4], GetSx3Cache("CN9_REVISA","X3_TAMANHO"))		
		if(CN9->(DbSeek(cChvCN9)))
			cContrato	:= CN9->CN9_NUMERO
			cRev 		:= CN9->CN9_REVISA
		Else
			aAdd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato,STR0004}) //- "Número de contrato não informado e/ou não possui integração"
			lCtrt	:= .F.
			lRet	:= .F.
		EndIf		
	ElseIf ValType("oXmlCtrt:_ContractNumber:Text") == "C"
		cContrato := oXmlCtrt:_ContractNumber:Text
	Else
		lRet := .F.
	EndIf
	
	lIntPIMS := CN300RetSt('INTPIMS',,,cContrato)
	
	If lRet .And. !Empty(cContrato) .And. lIntPIMS
	
		If Empty(cRev) .And. ValType("oXmlCtrt:_ContractReview:Text") == "C"
			cRev := oXmlCtrt:_ContractReview:Text
		EndIf
		
		If oModelCND == Nil		
			oModelCND := oModel:GetModel('CNDMASTER')
		EndIf
		
		If oModelCND:SetValue('CND_CONTRA', cContrato)		
		
			// -- Percorre as planilhas			
			If ValType(oXmlCtrt:_ListOfMeasurement:_Measurement) == "A"
				nPlan := Len(oXmlCtrt:_ListOfMeasurement:_Measurement)
			Else
				nPlan := 1
			EndIf
		
			For nY := 1 To nPlan
				
				If nPlan > 1 
					oXmlPlan := oXmlCtrt:_ListOfMeasurement:_Measurement[nY]
				Else
					oXmlPlan := oXmlCtrt:_ListOfMeasurement:_Measurement
				EndIf	
				
				If ValType(oXmlPlan:_SheetNumber:Text) == "C"
					cPlan := oXmlPlan:_SheetNumber:Text
				EndIf					
				
				If oModelCXN == Nil		
					oModelCXN := oModel:GetModel('CXNDETAIL')
				EndIf
				
				// -- Seta a planilha
				For nP := 1 To oModelCXN:Length()
					oModelCXN:Goline(nP)
					If AllTrim(cPlan) == AllTrim(oModelCXN:GetValue('CXN_NUMPLA'))
						oModelCXN:SetValue('CXN_CHECK', .T.)
						Exit
					EndIf
				Next nP			
				
				// -- Percorre os itens
				If ValType(oXmlPlan:_ListOfItem:_Item) == "A"
					nItem := Len(oXmlPlan:_ListOfItem:_Item)
				Else
					nItem := 1
				EndIf	
				
				For nI := 1 to nItem
					If nItem > 1 
						oXmlItem := oXmlPlan:_ListOfItem:_Item[nI]
					Else
						oXmlItem := oXmlPlan:_ListOfItem:_Item
					EndIf	
					
					If ValType(oXmlItem:_ItemCode:Text) == "C"
						cItem := oXmlItem:_ItemCode:Text
					EndIf		
							
					If oModelCNE == Nil		
						oModelCNE := oModel:GetModel('CNEDETAIL')
					EndIf
				
					// -- Verifica se entidades contabéis possuem msg única
					If oXmlItem:_CostCenterCode:Text # ''
						cCC := oXmlItem:_CostCenterCode:Text
					ElseIf oXmlItem:_CostCenterInternalId:Text # ''
						cCC := CFGA070INT( cMarca, 'CNE', 'CNE_CC', oXmlItem:_CostCenterInternalId:Text )
					EndIf
				
					If oXmlItem:_AccountantAcountCode:Text # ''
						cCt := oXmlItem:_AccountantAcountCode:Text
					ElseIf oXmlItem:_AccountantAcountInternalId:Text # ''
						cCt := CFGA070INT( cMarca, 'CNE', 'CNE_CONTA',oXmlItem:_AccountantAcountInternalId:Text )
					EndIf
				
					If oXmlItem:_AccountingItemCode:Text # ''
						cIt := oXmlItem:_AccountingItemCode:Text
					ElseIf oXmlItem:_AccountingItemInternalId:Text # ''
						cIt := CFGA070INT( cMarca, 'CNE', 'CNE_ITEMCT', oXmlItem:_AccountingItemInternalId:Text )
					EndIf
				
					If oXmlItem:_ClassValueCode:Text # ''
						cCv := oXmlItem:_ClassValueCode:Text
					ElseIf oXmlItem:_ClassValueInternalId:Text # ''
						cCv := CFGA070INT( cMarca, 'CNE', 'CNE_CLVL', oXmlItem:_ClassValueInternalId:Text )
					EndIf
					
					// -- Seta os itens
					For nP := 1 To oModelCNE:Length()
						oModelCNE:Goline(nP)
						If AllTrim(cItem) == AllTrim(oModelCNE:GetValue('CNE_PRODUT'))
							If !oModelCNE:SetValue('CNE_QUANT',	Val(oXmlItem:_Quantity:Text))
								lRet := .F.
								Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato+"|"+cPlan+"|"+cItem,oModel:GetErrorMessage()[6]})
							EndIf
							
							If !oModelCNE:SetValue('CNE_CC',cCC)
								lRet := .F.
								Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato+"|"+cPlan+"|"+cItem,oModel:GetErrorMessage()[6]})
							EndIf
							
							If !oModelCNE:SetValue('CNE_CONTA',cCt)
								lRet := .F.
								Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato+"|"+cPlan+"|"+cItem,oModel:GetErrorMessage()[6]})
							EndIf
							
							If !oModelCNE:SetValue('CNE_ITEMCT',cIt)
								lRet := .F.
								Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato+"|"+cPlan+"|"+cItem,oModel:GetErrorMessage()[6]})
							EndIf
							
							If !oModelCNE:SetValue('CNE_CLVL',cCv)
								lRet := .F.
								Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato+"|"+cPlan+"|"+cItem,oModel:GetErrorMessage()[6]})
							EndIf
							
							Exit
						EndIf
					Next nP
					
				Next nI			
							
			Next nY		
    	Else
			aAdd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato,STR0006}) //- "Não é possivel medir este contrato. Verifique a situação e datas de vigência do contrato."
			lCtrt := .F.
		EndIf
	Else
		aAdd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato,STR0004}) //- "Número de contrato não informado e/ou não possui integração"
		lCtrt := .F.
	EndIf
	
	If lRet .And. lCtrt
		If (lRet :=  (oModel:VldData() .And. oModel:CommitData()))
			cValExt := oXMLContent:_BUSINESSEVENT:_IDENTIFICATION:_KEY:TEXT
			cValInt := oModelCND:GetValue('CND_FILIAL')+oModelCND:GetValue('CND_CONTRA')+oModelCND:GetValue('CND_REVISA')+oModelCND:GetValue('CND_NUMMED')
			CFGA070Mnt(cMarca , "CND", "CND_NUMMED", cValExt , cValInt )
			
			aAdd(aRet,{.T.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato,STR0005}) //- "Medição inclusa com sucesso"
		EndIf
	EndIf
	
	If !lCtrt .Or. !lRet
		Aadd(aRet,{.F.,cEmpId+"|"+cFilId+"|"+cChave+"|"+cContrato+"|"+cPlan+"|"+cItem,oModel:GetErrorMessage()[6]})
		DisarmTransaction()
		Exit
	EndIf
	
	cRev := ""
	oModel:DeActivate()
Next nX

End Transaction

Return aRet