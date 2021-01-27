#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#Include "TBICONN.CH"
#Include "RSPA010API.ch"

#DEFINE HELP_URL "http://tdn.totvs.com/x/rYZDHQ"
#DEFINE ERRORCODE_DEF	400
#DEFINE ERRORSRV_DEF	500
#DEFINE PAGESIZE_DEF	2000
#DEFINE TAB  			CHR ( 13 ) + CHR ( 10 )

Private oError		As Object 
Private bError      := { |e| oError := e, Break(e) }
Private bErrorBlock := ErrorBlock( bError )


//============================================
// REST DE CADASTRO DE CURRÍCULO DE CANDIDATOS 
//============================================
WSRESTFUL Candidates DESCRIPTION OemToAnsi(STR0001) FORMAT ("application/json") 
	WSDATA authorization As String
	WSDATA candidatesId As String
	WSDATA candidatesIds As String
	WSDATA page			 As Integer Optional
	WSDATA pageSize		 As Integer Optional

	WSMETHOD POST 	DESCRIPTION OemToAnsi(STR0002) WSSYNTAX "/rh/v2/candidates" PATH "/rh/v2/candidates" PRODUCES 'application/json;charset=utf-8' TTALK "v1"
	WSMETHOD GET  	DESCRIPTION OemToAnsi(STR0009) WSSYNTAX "/rh/v2/candidates" PATH "/rh/v2/candidates" PRODUCES 'application/json;charset=utf-8' TTALK "v1"
	WSMETHOD DELETE DESCRIPTION OemToAnsi(STR0010) WSSYNTAX "/rh/v2/candidates" PATH "/rh/v2/candidates" PRODUCES 'application/json;charset=utf-8' TTALK "v1"
	WSMETHOD PUT  	DESCRIPTION OemToAnsi(STR0011) WSSYNTAX "/rh/v2/candidates" PATH "/rh/v2/candidates" PRODUCES 'application/json;charset=utf-8' TTALK "v1"
END WSRESTFUL

// RETORNA CURRÍCULOS DENTRO DO MÓDULO SIGARSP
WSMETHOD GET QUERYPARAM page, pageSize, candidatesIds HEADERPARAM authorization WSREST Candidates
	Local cResponse 	:= ""
	Local cCand			:= ""
	Local cCompId 	 	:= ""
	Local cBranchId  	:= ""
	Local cProd 		:= ""
	Local aIdsCand		:= {}
	Local aEmpre        := {}
	Local oEmpData	    := JsonObject():New()
	Local nPage 	 	:= 0
	Local nPageSize  	:= 0
	Local nI			:= 0
	Local lRet 			:= .T.

	DEFAULT Self:authorization  := ""
	DEFAULT Self:page 			:= 1
	DEFAULT Self:pageSize 		:= PAGESIZE_DEF
	DEFAULT	Self:candidatesIds	:= ""
	
	BEGIN SEQUENCE
		nPage 	   	:= Self:page
		nPageSize  	:= Self:pageSize
		cCand		:= Self:candidatesIds
		aIdsCand:= StrTokArr(	Self:candidatesIds,",")
		
		For nI:= 1 to Len(aIdsCand)
			If lRet  
				lRet 	:= fIdValid(aIdsCand[nI], oEmpData)
			EndIf
		Next
		
		For nI:= 1 to Len(aIdsCand)
			aIdsCand[nI] := StrTokArr(aIdsCand[nI],"|")
			If Empty(cCompId) .And. Empty(cBranchId) 
				cCompId    	:=  aIdsCand[nI][1]
				cBranchId  	:=	aIdsCand[nI][2]
			EndIf 
		Next
		// Verify PreValidations
		IF !fPreValid(@oEmpData, cBranchId, cCompId, cCand)
			lRet := .F.
		Endif
		If lRet
			fSetErrorHandler(EncodeUTF8(STR0012)) // "ERRO AO PREPARAR O AMBIENTE COM A EMPRESA E FILIAL INFORMADOS!"

			// Set nPageSize
			IF (nPageSize < 1) .OR. (nPageSize > PAGESIZE_DEF)
				nPageSize := PAGESIZE_DEF
			EndIf

			// Set nPage
			If nPage < 1
				nPage := 1
			EndIf

			// Prepare Environment
			aEmpre := FWSM0Util():GetSM0Data( cCompId , cBranchId, { "M0_CODIGO", "M0_CODFIL" } )

			// companyId Validation
			If Empty(aEmpre)
				// STR0013: "DE-PARA DE EMPRESA E FILIAL NÃO ENCONTRADO NA BASE PARA O COMPANYID". STR0014: "E BRANCHID"
				SetRestFault(ERRORCODE_DEF, EncodeUTF8(STR0013) + " '" + cCompId + "' "+ EncodeUTF8(STR0014) + " '" + cBranchId + "' !", , , , HELP_URL, )
				lRet := .F.
			EndIf
		
			If lRet
				RESET ENVIRONMENT
				RPCSetType(3)
				PREPARE ENVIRONMENT EMPRESA aEmpre[1][2] FILIAL aEmpre[2][2] TABLES "SQG" MODULO "RSP"
				fResetErrorHandler()

				// Get SQG Data
				lRet := fGetData(@oEmpData, nPage, nPageSize, cBranchId,aIdsCand)
			EndIf
		EndIf

		// Compress String And Set Response
		cResponse := fCompress(@oEmpData)
		::SetResponse(cResponse)

	RECOVER
		lRet := .F.
		ErrorBlock(bErrorBlock)
		SetRestFault(ERRORSRV_DEF, EncodeUTF8(STR0015) + TAB + oError:Description, , , , HELP_URL, ) //"OCORREU UMA FALHA NO RETORNO DA INFORMAÇÃO."
	END SEQUENCE

Return lRet	


// DELETA UM CURRÍCULO DENTRO DO MÓDULO SIGARSP
/*/{Protheus.doc} DELETE
//TODO Método responsável pela exclusão de registro passado na propriedade candidatesId
@author author
@since 08/08/2019
@version version
@return return, return_description
/*/
WSMETHOD DELETE QUERYPARAM candidatesId HEADERPARAM authorization WSREST Candidates
	Local cCandId 		:= ""
	Local cCIC 	 		:= ""
	Local cBranchId 	:= ""
	Local lRet 			:= .F.
	Local aEmpre        := {}
	Local oEmpData		:= JsonObject():New()
	
	DEFAULT Self:authorization  := ""
	DEFAULT Self:candidatesId   := ""

	BEGIN SEQUENCE
		cCandId 	:= Self:candidatesId
		lRet 		:= fIdValid(cCandId, oEmpData)		

		If lRet
			fSetErrorHandler(EncodeUTF8(STR0023)) // "ERRO NA EXECUÇAO DA OPERAÇÃO."

			cCompId 	:= SubStr(cCandId, 1,  2) 	// Grupo de Empresa
			cBranchId   := SubStr(cCandId, 4,  8)	// Empresa e Filial
			cCIC 		:= SubStr(cCandId, 13,  18)	// CPF

			// Prepare Environment
			aEmpre := FWSM0Util():GetSM0Data( cCompId , cBranchId, { "M0_CODIGO", "M0_CODFIL" } )

			// companyId Validation
			If Empty(aEmpre)
				// STR0013: "DE-PARA DE EMPRESA E FILIAL NÃO ENCONTRADO NA BASE PARA O COMPANYID". STR0014: "E BRANCHID"
				SetRestFault(ERRORCODE_DEF, EncodeUTF8(STR0013) + " '" + cCompId + "' "+ EncodeUTF8(STR0014) + " '" + cBranchId + "' !", , , , HELP_URL, )
				lRet := .F.
			EndIf

			If lRet
				RESET ENVIRONMENT
				RPCSetType(3)
				PREPARE ENVIRONMENT EMPRESA aEmpre[1][2] FILIAL aEmpre[2][2] TABLES "SQG" MODULO "RSP"
				fResetErrorHandler()

				lRet := fDelData(@oEmpData, cBranchId, cCIC)
			EndIf
		EndIf

		// Compress String And Set Response
		cResponse := fCompress(@oEmpData)
		::SetResponse(cResponse)

	RECOVER
		lRet := .F.
		ErrorBlock(bErrorBlock)
		SetRestFault(ERRORSRV_DEF, EncodeUTF8(STR0015) + TAB + oError:Description, , , , HELP_URL, ) //"OCORREU UMA FALHA NO RETORNO DA INFORMAÇÃO."
	END SEQUENCE

Return .T.


// ALTERA UM CURRÍCULO DENTRO DO MÓDULO SIGARSP
/*/{Protheus.doc} PUT
//TODO Método responsável pela alteração do currículo do candidato enviado na propriedade candidatesId
@author author
@since 08/08/2019
@version version
@return return, return_description
/*/
WSMETHOD PUT QUERYPARAM candidatesId HEADERPARAM authorization WSREST Candidates
	Local aCandId  		:= {}
	Local cCandId		:= ""
	Local cCIC 	 		:= ""
	Local cBranchId 	:= ""
	Local lRet 			:= .F.
	Local aEmpre        := {}
	Local oEmpData		:= JsonObject():New()
	Local cBody     	:= ::GetContent()
	Local aSM0			:= FWLoadSM0()
	DEFAULT Self:authorization  := ""
	DEFAULT Self:candidatesId   := ""

	BEGIN SEQUENCE
		aCandId 	:= StrToKArr(StrTran(StrTran(Self:candidatesId,'"',''),'"',''),"|")
		lRet 		:= fIdValid(Self:candidatesId, oEmpData)

		If lRet
			fSetErrorHandler(EncodeUTF8(STR0023)) // "ERRO NA EXECUÇAO DA OPERAÇÃO."
			If Len(aCandId)== 3 
				cCompId 	:= aCandId[1] 	// Grupo de Empresa
				cBranchId   := aCandId[2]	// Empresa e Filial
				cCIC 		:= aCandId[3]	// CPF
			EndIf


			// Prepare Environment
			aEmpre := FWSM0Util():GetSM0Data( cCompId , cBranchId, { "M0_CODIGO", "M0_CODFIL" } )

			// companyId Validation
			If Empty(aEmpre)
				// STR0013: "DE-PARA DE EMPRESA E FILIAL NÃO ENCONTRADO NA BASE PARA O COMPANYID". STR0014: "E BRANCHID"
				SetRestFault(ERRORCODE_DEF, EncodeUTF8(STR0013) + " '" + cCompId + "' "+ EncodeUTF8(STR0014) + " '" + cBranchId + "' !", , , , HELP_URL, )
				lRet := .F.
			EndIf

			If lRet
				RESET ENVIRONMENT
				RPCSetType(3)
				PREPARE ENVIRONMENT EMPRESA aEmpre[1][2] FILIAL aEmpre[2][2] TABLES "SQG" MODULO "RSP"
				fResetErrorHandler()

				lRet := fPutData(@oEmpData, cBranchId, cCIC, cBody)
			EndIf
		EndIf

		// Compress String And Set Response
		cResponse := fCompress(oEmpData)
		::SetResponse(cResponse)

	RECOVER
		lRet := .F.
		ErrorBlock(bErrorBlock)
		SetRestFault(ERRORSRV_DEF, EncodeUTF8(STR0015) + TAB + oError:Description, , , , HELP_URL, ) //"OCORREU UMA FALHA NO RETORNO DA INFORMAÇÃO."
	END SEQUENCE

Return .T.

/*/{Protheus.doc} POST
//MÉTODO DE RECEBIMENTO DE DADOS 
@author TOTVS
@since 07/08/2019
@version version
@param authorization, chave de autorização
/*/
WSMETHOD POST HEADERPARAM authorization WSREST Candidates 

Local jCandit		As Object	

Local cBody			As Character
Local cJson 		As Character
Local cAuth			As Character
Local cComp			As Character
Local cCompId		As Character
Local cBranchId		As Character 
Local cCatch		As Character

Local nLenComp		As Float
Local nSM0			As Integer

Local lRet			As Logical
Local lCompact		As Logical		

Local aSM0			As Array
Local aEmpre 		As Array


//===================================================
//PEGANDO INFORMAÇÕES DO CONTEÚDO RECEBIDO EM JSON
//===================================================
jCandit		:= JsonObject():New()
cBody		:= Self:GetContent()
aSM0		:= FWLoadSM0()
lRet		:= .F.
aEmpre		:= {}
lCompact	:= .F. 

BEGIN SEQUENCE
	cCatch   := jCandit:FromJSON(EncodeUTF8(NoAcento(cBody)))
	
	If cCatch != Nil  .Or. Len(jCandit:GetNames()) == 0  
		SetRestFault(400,EncodeUTF8(NoAcento(OemToAnsi(STR0008))),,,"",HELP_URL,{})
		lRet := .F.
	EndIf
	If (lRet := fTratDados(@jCandit))

		If (nSM0:=ascan(aSM0,{|X| Alltrim(X[1]) == jCandit["companyId"] .And. Alltrim(X[2])==jCandit["branchId"]})) > 0
			aAdd(aEmpre,{aSm0[nSM0][1],aSm0[nSM0][2]})	
		EndIf	
		
		If Empty(aEmpre)
			SetRestFault(400, EncodeUTF8(NoAcento( OemToAnsi(STR0006))),,,"",HELP_URL,{})
			lRet := .F.
		EndIf
		
		If lRet
			RESET ENVIRONMENT
			RPCSetType(3)
			PREPARE ENVIRONMENT EMPRESA aEmpre[1][1] FILIAL aEmpre[1][2] TABLES "SQG" MODULO "RSP"
		Endif

		If lRet
			//=================================================
			//ROTINA DE VALIDAÇÃO E GRAVAÇÃO DO NOVO CANDIDATO.
			//=================================================
			lRet	:= NewCandidate(cBody,@jCandit)
			If lRet 
				If Type("Self:GetHeader('Accept-Encoding')") != "U"  .and. 'GZIP' $ Upper(Self:GetHeader('Accept-Encoding') )        
					lCompact := .T.
				EndIf
				cBody 	:= jCandit:ToJSON()
				cBody	:= EncodeUTF8(NoAcento( cBody)) 
				If(lCompact)    	
					fCompress(oObj)
					Self:SetHeader('Content-Encoding','gzip')
					GzStrComp(cBody, @cComp, @nLenComp )	        
				Else
					cComp := cBody    	
				Endif
				//===================
				// RETORNA A STRING
				//===================
				Self:SetResponse(cComp)

			Endif
		EndIf
	EndIf
	RECOVER

	ErrorBlock(bErrorBlock)

	SetRestFault(400,  EncodeUTF8(NoAcento(OemToAnsi(oError:Description))),,,"",HELP_URL,{}) 
	lRet := .F.

	Return (lRet)
END SEQUENCE


Return lRet

/*/{Protheus.doc} NewCandidate
//Método que irá gravar os dados do currículo 
//de um determinado candidato
@author Eduardo
@since 30/04/2019
@return lRet, Logical, definição se houve sucesso ou falha na geração do currículo
@param cBody, characters, corpo do pacote enviado na requisição do método
@param oJCandit, object, Json que será preenchido com o retorno
/*/
Static Function NewCandidate(cBody,oJCandit)
	
	Local lRet      As Logical

	Default oJCandit := JsonObject():New()
	Default cBody    := ""

	lRet      	:= .T.

	//========================================
	//SERIALIZE DO CORPO DA MENSAGEM RECEBIDA 
	//========================================
	lRet	:= SetCurriculum(@oJCandit,cBody)
	
Return lRet

/*/{Protheus.doc} SetCurriculum
//Função de encapsulamento da gravação do currículo
@author Eduardo
@since 02/05/2019
@version 1.0
@param oJson, object, descricao
@return return, return_description
/*/
Static Function SetCurriculum(oJson,cBody)
	Local aArea     	As String
	Local cSeek			As String
	Local cRetSqlName	As String

	Local nx			As Integer
	Local ny			As Integer
	Local nInc			As Integer
	Local lAlter		As Logical
	Local aCampos		As Array
	Local lRetorno  	As Logical
	Local nExpected		As Float
	Local nSaveSX8 		As Integer

	//===============================================
	//ANALISE DOS DADOS ENVIADOS ANTES DE COMEÇAR 	||
	// O PREENCHIMENTO DA TABELA COM OS MESMOS		||
	//=============================================== 
	lRetorno:= .T.
	lAlter	:= .F.
	nSaveSX8:= GetSX8Len()
	//======================================
	//CARREGAMENTO DO ACAMPOS EM UMA FUNÇÃO 
	//PARA FACILITAR A LEITURA DO FONTE.
	//======================================
	fCargArraySQG(@aCampos,oJson)
	Begin Transaction

		cRetSqlName := RetSqlName( "SQG" )+"\3"
		dbSelectArea("SQG")
		dbSetOrder(3)//QG_FILIAL+QG_CIC
		cSeek := xFilial("SQG")+oJson["cpf"]
		If SQG->(dbSeek(cSeek))
			If fPutData(@oJson, oJson["branchId"], oJson["cpf"], cBody)
				lAlter	 := .T.
			Else
				lRetorno:= .F.
			EndIf 
	
			
		Else			//Inclusao
			Reclock("SQG",.T.,.T.)
			SQG->QG_FILIAL		:=	xFilial("SQG")//Filial
			SQG->QG_CURRIC		:= 	GetSx8Num("SQG","QG_CURRIC",xFilial('SQG')+cRetSqlName)
			If __lSX8
				While (GetSX8Len() > nSaveSX8)
					ConfirmSX8()
				End
			Else
				RollBackSX8()
			Endif
		EndIf

		If lRetorno .And. !lAlter 
			//==============================================================
			// GRAVA TODOS OS CAMPOS PADROES (CARACTER) UTILIZANDO PICTURE
			//==============================================================
			For nx := 1 To Len(aCampos)		
				If aCampos[nx][1] == "QG_MEMO2"
					If nInc== 0 
						APDMSMM(,TamSX3("QG_EXPER")[1],,aCampos[nx][2],1,,,"SQG","QG_EXPER")
					Else
						APDMSMM(SQG->QG_EXPER  ,TamSX3("QG_EXPER")[1],,aCampos[nx][2],1,,,"SQG","QG_EXPER")
					EndIf 
				Else
					If !Empty(aCampos[nx][3]) .And.  Valtype(&(aCampos[nx][1])) == "C"
						SQG->( FieldPut(FieldPos(aCampos[nx][1]), Transform(aCampos[nx][2], aCampos[nx][3] ) ) )
					Else
						SQG->( FieldPut(FieldPos(aCampos[nx][1]), aCampos[nx][2]) )
					EndIf
				EndIf
			Next nx
			ConfirmSX8()
			SQG->( MsUnlock() )
			lRetorno:= .T.
	
		EndIf
		
	End Transaction

Return lRetorno 


/*/{Protheus.doc} fCargArraySQG
//Montagem do Array para carregar dados a serem enviados para SQG
@author Eduardo
@since 03/05/2019
@return return, return_description
@param aCampos, array, descricao
@param jCandit, , descricao
/*/
Static Function fCargArraySQG(aCampos,jCandit)

	DEFAULT aCampos 	:= {}


	aCampos:= { 	{"QG_DTCAD"		, Stod(Left(StrTran(jCandit:GetJsonText("registryDate"),"-",""),8))	,X3Picture("QG_DTCAD") 	},;	//Matricula do Candidato
					{"QG_NOME"		, jCandit:GetJsonText("name")										,X3Picture("QG_NOME") 		},;	//Nome do Candidato
					{"QG_BAIRRO"	, jCandit:GetJsonText("district")									,X3Picture("QG_BAIRRO") 	},; //Bairro
					{"QG_MUNICIP"	, jCandit:GetJsonText("city")										,X3Picture("QG_MUNICIP") 	},;	//Municip
					{"QG_ESTADO"	, jCandit:GetJsonText("state")										,X3Picture("QG_ESTADO") 	},; //Estado
					{"QG_CEP"		, jCandit:GetJsonText("cep")										,X3Picture("QG_CEP") 		},; //Cep
					{"QG_FONE"		, jCandit:GetJsonText("phoneNumber1")								,X3Picture("QG_FONE") 		},; //Fone
					{"QG_FONECEL"	, jCandit:GetJsonText("phoneNumber2")								,X3Picture("QG_FONECEL") 	},; //Fone Celular
					{"QG_FONECOM"	, jCandit:GetJsonText("phoneNumber3")								,X3Picture("QG_FONECOM") 	},; //Fone Comercial
					{"QG_RG"		, jCandit:GetJsonText("identityNumber")								,X3Picture("QG_RG") 		},;  //RG
					{"QG_CIC"		, jCandit:GetJsonText("cpf")										,X3Picture("QG_CIC") 		},;  //CPF
					{"QG_NUMCP"		, jCandit:GetJsonText("workCard")									,X3Picture("QG_NUMCP") 		},; //Num CP
					{"QG_SERCP"		, jCandit:GetJsonText("workCardSerialNumber")						,X3Picture("QG_SERCP") 		},; //Serie CP
					{"QG_UFCP"		, jCandit:GetJsonText("workCardEmitterState")						,X3Picture("QG_UFCP") 		},; //UF CP
					{"QG_HABILIT"	, jCandit:GetJsonText("driversLicense")								,X3Picture("QG_HABILIT") 	},; //Habilitacao
					{"QG_RESERV"	, jCandit:GetJsonText("militaryDischargeCertificate")				,X3Picture("QG_RESERV") 	},; //Reservista
					{"QG_TITULOE"	, jCandit:GetJsonText("electoralCard")								,X3Picture("QG_TITULOE") 	},; //Titulo Eleitor
					{"QG_ENDEREC"	, jCandit:GetJsonText("street")+","+jCandit:GetJsonText("number")	,X3Picture("QG_ENDEREC") 	},;	//Endereco
					{"QG_ZONASEC"	, jCandit:GetJsonText("electoralWard")+ jCandit:GetJsonText("electoralSection")			,X3Picture("QG_ZONASEC") 	},; //Zona Eleitoral
					{"QG_ESTCIV"	, jCandit:GetJsonText("maritalState")								,X3Picture("QG_ESTCIV") 	},; //Estado Civil
					{"QG_NATURAL"	, jCandit:GetJsonText("homeState")									,X3Picture("QG_NATURAL") 	},; //Naturalidade - UF
					{"QG_NACIONA"	, jCandit:GetJsonText("nationality")								,X3Picture("QG_NACIONA") 	},; //Nacionalidade
					{"QG_DTNASC"	, Stod(Left(StrTran(jCandit:GetJsonText("birth"),"-",""),8))		,X3Picture("QG_DTNASC") 	},; //Data de Nascimento
					{"QG_SITUAC"	, "001"																,X3Picture("QG_SITUAC") 	},; //Situac 
					{"QG_EMAIL"		, jCandit:GetJsonText("email")										,X3Picture("QG_EMAIL") 		},; //Email
					{"QG_DFISICO"	, iif(jCandit:GetJsonText("disabled")=='.F.',"1","2")						,X3Picture("QG_DFISICO") 	},; //Deficiente fisico
					{"QG_MUNNASC"	, jCandit:GetJsonText("naturalness")								,X3Picture("QG_MUNNASC") 	},; //Naturalidade
					{"QG_AREA"		, StrZero(Val(jCandit:GetJsonText("areaOfInterestCode1")),TamSx3("QG_AREA")[1])				,X3Picture("QG_AREA") 	},; //Código da area de interesse 1
					{"QG_NIVHIER"	, jCandit:GetJsonText("hierarchyLevelCode")							,X3Picture("QG_NIVHIER")	},; //Código do nível hierárquico
					{"QG_TPEXPER"	, Val(StrTran(jCandit:GetJsonText("workExperienceTime"),",","."))	,X3Picture("QG_TPEXPER")} ,; //Tempo de experiência profissional
					{"QG_PRETSAL"	, Val(StrTran(jCandit:GetJsonText("wageExpectation"),",","."))		,X3Picture("QG_PRETSAL")}}//Pretenção Salarial
	
	//PROPRIEDADES QUE POSSUEM CONDICIONAIS PARA PREENCHIMENTO
	If UPPER(jCandit:GetJsonText("sex")) $ "F/M"
		aAdd(aCampos,{"QG_SEXO"		, jCandit:GetJsonText("sex")										,X3Picture("QG_SEXO") 		})//Sexo	
	EndIf
	//EM CASO DE EXTRANGEIROS 
	If jCandit:GetJsonText("nationality") != "10"
		aAdd(aCampos,{"QG_ANOCHEG"	, Substr(StrTran(jCandit:GetJsonText("arrivalDate"),"-",""),3,2)	,X3Picture("QG_ANOCHEG") 	}) //Ano de Chegada
	EndIf
	
	aAdd(aCampos,{"QG_MEMO2"		, jCandit:GetJsonText("professionalSkillsResumeDescription")		,X3Picture("QG_MEMO2") 		}) //Descrição do resumo de qualificações 
Return .T.


/*/{Protheus.doc} fTratDados
//Tratamento e validação de dados do Json
@author eduardo.vicente
@since 03/05/2019
@param jCandit,object, variável de objeto que contém os dados de json
@return lRet, logical, variável que verifica se ocorreu erro ou não
/*/
Static Function fTratDados(jCandit)
	Local aNames	As Array //array de nomes das propriedades
	Local aCpoObt	As Array
	Local aAlias	As String //Proteger a area atual
	Local cCpoObgt	As String //Campos obrigatórios
	Local cMsgRest	As String //Mensagem de erro
	lOCAL cTabSX5	As String //Tabela Dinâmica para busca no SX5
	Local nItem		As Integer //Posição do item para varredura
	
	Local lRet		As Logical //Retorno lógico de erro ou sucesso.

	Default jCandit := JsonObject():New()

	aAlias:= GetArea()
	//====================
	//CAMPOS OBRIGATÓRIOS 
	//====================

	cCpoObt	:= "/Name/Cpf/companyId/branchId/" //CAMPOS REQUIRIDOS
	lRet	:= .T. 

	//====================
	//PROPRIEDADES DO JSON
	//====================
	aNames		:= jCandit:GetNames()
	aCpoObt		:= StrToArray(cCpoObt,"/") 
	
	dbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	cMsgRest	:= ""
	
	//===========================================================================
	//VERIFICAÇÃO SE PROPRIEDADES DADAS COMO OBRIGATÓRIAS ESTÃO PRESENTES NO JSON
	//===========================================================================
	For nItem:= 1 to Len(aCpoObt)
		If aScan(aNames,{|x| UPPER(x) == UPPER(aCpoObt[nItem])})== 0
			cMsgRest+=  OemToAnsi(STR0003)+ aCpoObt[nItem] +OemToAnsi(STR0004) + CRLF
		EndIf
	Next nItem
	
	//=================================================================================================
	//LAÇO DE VERIFICAÇÃO DE PROPRIEDADES REQUIRIDAS E PROPRIEDADES QUE FAZEM PARTE DE CONSULTA PADRÃO.
	//=================================================================================================
	For nItem:= 1 to Len(aNames)

		If (jCandit[aNames[nItem]]== NIL .Or. Empty(jCandit[aNames[nItem]])) .And. "/"+UPPER(aNames[nItem])+"/" $ UPPER(cCpoObt)    
			cMsgRest+=  OemToAnsi(STR0003)+ aNames[nItem] +OemToAnsi(STR0004) + CRLF
		EndIf 

		If UPPER(aNames[nItem]+"/") $ "AREAOFINTERESTCODE1/WORKCARDEMITTERSTATE/HOMESTATE/STATE/MARITALSTATE/" 
			If !Empty(jCandit[aNames[nItem]])
                                                                                             
				If UPPER(aNames[nItem]+"/") !="MARITALSTATE" 
					cTabSX5:= IIf(UPPER(aNames[nItem]) == "AREAOFINTERESTCODE1","R1","12")
					cValor := IIf (UPPER(aNames[nItem]) == "AREAOFINTERESTCODE1",StrZero(Val(jCandit[aNames[nItem]]),TAMSX3("QG_AREA")[1] ),jCandit[aNames[nItem]]) 
				Else
					cTabSX5:= "33"
					cValor := Alltrim(jCandit[aNames[nItem]])
				EndIf
				If !SX5->(dbSeek(xFilial("SX5")+cTabSX5+cValor))
					cMsgRest+= OemToAnsi(STR0003) +aNames[nItem]+ OemToAnsi(STR0005) + CRLF
				Endif
			EndIf
		EndIf	
	Next nItem

	If !Empty(cMsgRest)
		lRet:= .F.
		SetRestFault(400,  EncodeUTF8(NoAcento(cMsgRest))	,,,"",HELP_URL,{})
	EndIf 	
	RestArea(aAlias)
Return lRet


/*/{Protheus.doc} fGetData
//TODO Descrição auto-gerada.
@author oliveira.hugo
@since 07/08/2019
@version undefined
@param oEmpData, object, descricao
@param page, , descricao
@param nPageSize, numeric, descricao
@param cBranchId, characters, descricao
@return return, return_description
/*/
Static Function fGetData(oEmpData, page, nPageSize, cBranchId,aIdsCand)
	Local oItemData
	Local cQuery  	 := ""
	Local cAliasSQG  := GetNextAlias()
	Local lRet 		 := .T.
	Local aItemQry   := {}
	Local cCpfWh	 := ""
	Local cBranchWh	 := ""
	Local nI		 := 0
	Local oHeadData	 := JsonObject():new()
	Local cDataBase  := AllTrim( Upper( TcGetDb() ) )

	DEFAULT oEmpData := JsonObject():New()
	DEFAULT aIdsCand := {}
	fSetErrorHandler(EncodeUTF8(STR0016)) // "ERRO AO BUSCAR DADOS DO CURRÍCULO. ERRO:"
	oHeadData["hasNext"] := .T.

	For nI:= 1 To len(aIdsCand)
		If Len(aIdsCand[nI]) == 3
			cCpfWh		+= "'"+StrTran(aIdsCand[nI][3],'"','') + "',"
			cBranchWh	+= "'"+StrTran(aIdsCand[nI][2],'"','') + " '," 
		EndIf
	Next
	cBranchWh	:= "QG_FILIAL IN (" + Substr(cBranchWh,1,len(cBranchWh)-1)+ ")"
	cCpfWh		:= " AND QG_CIC IN (" + Substr(cCpfWh,1,len(cCpfWh)-1)+ ")"
	
	// Create Paging Control
	cQuery := "SELECT * FROM ( "

	If cDataBase == "ORACLE"
		cQuery +=  "SELECT ROWNUM ITEMNUMBER, COUNT(1) OVER() AS TOTALNUMBER, "
	Else
		cQuery += "SELECT ROW_NUMBER() OVER(ORDER BY QG_CIC) ITEMNUMBER, COUNT (1) OVER() TOTALNUMBER, "
	EndIf

	cQuery += "QG_FILIAL,QG_CURRIC,QG_NOME,QG_DTNASC,QG_NATURAL,QG_MUNNASC,QG_SEXO,QG_NACIONA,"
	cQuery += "QG_ENDEREC,QG_BAIRRO,QG_ESTADO,QG_MUNICIP,QG_CEP,QG_CIC,QG_FONE,QG_FONECEL,
	cQuery += "QG_RG,QG_TITULOE,QG_ZONASEC,QG_NUMCP,QG_SERCP,QG_UFCP,QG_HABILIT,QG_RESERV,
	cQuery += "QG_EMAIL,QG_DFISICO,QG_FONECOM,QG_DTCAD,QG_PRETSAL,QG_AREA,QG_TPEXPER,QG_NIVHIER,QG_ESTCIV,QG_COMPLEM"

	// Verifiy opened conections
	If Select ("SQG") > 0
		SQG->( dbCloseArea() )
	Endif

	// Begin Get SQG Data
	cQuery += " FROM " + RetSqlName("SQG")
	cQuery += " WHERE "
	cQuery += RetSqlName("SQG") + ".D_E_L_E_T_ = ' ' "
	If !Empty(cBranchWh) .And. !Empty(cCpfWh)
		cQuery+= "AND "+ cBranchWh + cCPfWh 
	EndIf
	cQuery +=") FINAL "
	cQuery += "WHERE (FINAL.ITEMNUMBER BETWEEN " + Alltrim(Str((page - 1) * nPageSize + 1)) + " AND " + Alltrim(Str((page * nPageSize))) + ") "
	
	// Execute Query
	DBUseArea( .T., "TOPCONN", TcGenQry( , ,cQuery), cAliasSQG, .T., .T. )

	fResetErrorHandler()

	// Check SQG Query
	IF !fPosValid(@oEmpData, page, (cAliasSQG)->ITEMNUMBER, (cAliasSQG)->TOTALNUMBER)
		lRet := .F.
	Endif

	If lRet
		// Create items Array
		oHeadData["total"] 		:= (cAliasSQG)->TOTALNUMBER

		// Get items Properties
		While (cAliasSQG)->(!Eof())
			
			// Set hasNext propertie
			IF ((cAliasSQG)->TOTALNUMBER == (cAliasSQG)->ITEMNUMBER) .OR. ( nPageSize >= (cAliasSQG)->TOTALNUMBER )
				oHeadData["hasNext"] := .F.
			EndIf

			oItemData := JsonObject():new()
			
			// Get SQG Item
			oItemData["id"]  									:= SM0->M0_CODIGO + "|" + (cAliasSQG)->QG_FILIAL + "|" + (cAliasSQG)->QG_CIC
			oItemData["name"]            						:= RTRIM((cAliasSQG)->QG_NOME)
			oItemData["birth"]            						:= formatDate((cAliasSQG)->QG_DTNASC)
			oItemData["homeState"]            					:= RTRIM((cAliasSQG)->QG_NATURAL)
			oItemData["naturalness"]            				:= RTRIM((cAliasSQG)->QG_MUNNASC)
			oItemData["nickName"]            					:= ""
			oItemData["sex"]            						:= ALLTRIM((cAliasSQG)->QG_SEXO)
			oItemData["nationality"]            				:= RTRIM((cAliasSQG)->QG_NACIONA)
			oItemData["educationalLevel"]            			:= ""
			oItemData["street"]            						:= RTRIM((cAliasSQG)->QG_ENDEREC)
			oItemData["number"]            						:= RTRIM((cAliasSQG)->QG_COMPLEM)
			oItemData["district"]            					:= RTRIM((cAliasSQG)->QG_BAIRRO)
			oItemData["state"]            						:= RTRIM((cAliasSQG)->QG_ESTADO)
			oItemData["city"]            						:= RTRIM((cAliasSQG)->QG_MUNICIP)
			oItemData["cep"]            						:= RTRIM((cAliasSQG)->QG_CEP)
			oItemData["country"]            					:= ""
			oItemData["professionalRegistrationNumber"] 		:= ""
			oItemData["cpf"]            						:= RTRIM((cAliasSQG)->QG_CIC)
			oItemData["imageId"]            					:= ""
			oItemData["phoneNumber1"]      						:= RTRIM((cAliasSQG)->QG_FONE)
			oItemData["phoneNumber2"]      						:= RTRIM((cAliasSQG)->QG_FONECEL)
			oItemData["identityNumber"]      					:= RTRIM((cAliasSQG)->QG_RG)
			oItemData["identityNumberEmitterState"]    			:= ""
			oItemData["identityNumberEmitterAgency"]   			:= ""
			oItemData["identityNumberEmissionDate"]   			:= ""
			oItemData["electoralCard"]      					:= RTRIM((cAliasSQG)->QG_TITULOE)
			oItemData["electoralWard"]      					:= LEFT( RTRIM((cAliasSQG)->QG_ZONASEC),4 )
			oItemData["electoralSection"]      					:= RIGHT( RTRIM((cAliasSQG)->QG_ZONASEC),4)
			oItemData["workCard"]      							:= RTRIM((cAliasSQG)->QG_NUMCP)
			oItemData["workCardSerialNumber"]    				:= RTRIM((cAliasSQG)->QG_SERCP)
			oItemData["workCardEmitterState"]    				:= RTRIM((cAliasSQG)->QG_UFCP)
			oItemData["workCardEmissionDate"]   				:= ""
			oItemData["nit"]   									:= ""
			oItemData["driversLicense"]    						:= RTRIM((cAliasSQG)->QG_HABILIT)
			oItemData["driversLicenseType"]   					:= ""
			oItemData["driversLicenseExpirationDate"]   		:= ""
			oItemData["militaryDischargeCertificate"] 			:= RTRIM((cAliasSQG)->QG_RESERV)
			oItemData["militaryGrade"]   						:= ""
			oItemData["brazilConsort"]   						:= ""
			oItemData["naturalized"]   							:= ""
			oItemData["brazilianChildren"]   					:= ""
			oItemData["brazilianChildrenNumber"]   				:= ""
			oItemData["email"] 									:= RTRIM((cAliasSQG)->QG_EMAIL)
			oItemData["previousTrainingInvestment"]   			:= ""
			oItemData["shadeRace"]   							:= ""
			oItemData["disabled"] 								:= Iif((cAliasSQG)->QG_DFISICO == "1" ,.T.,.F.) 
			oItemData["userCode"]   							:= ""
			oItemData["phoneNumber3"] 							:= RTRIM((cAliasSQG)->QG_FONECOM)
			oItemData["company"]   								:= ""
			oItemData["occupationCode"]   						:= ""
			oItemData["rehabilitated"]   						:= ""
			oItemData["smoker"]   								:= ""
			oItemData["adjustsImageSize"]   					:= ""
			oItemData["deafPerson"]   							:= ""
			oItemData["mutePerson"]   							:= ""
			oItemData["blindPerson"]   							:= ""
			oItemData["mentallyImpairedPerson"]   				:= ""
			oItemData["curriculumApprovalDate"]   				:= ""
			oItemData["student"]   								:= ""
			oItemData["teacher"]   								:= ""
			oItemData["candidate"]   							:= ""
			oItemData["bibliosUser"]   							:= ""
			oItemData["formerEmployee"]   						:= ""
			oItemData["intellectualImpairedPerson"]   			:= ""
			oItemData["deceased"]   							:= ""
			oItemData["age"]   									:= ""
			oItemData["registryDate"] 							:= RTRIM((cAliasSQG)->QG_DTCAD)
			oItemData["wageExpectation"] 						:= ALLTRIM(Str((cAliasSQG)->QG_PRETSAL))
			oItemData["areaOfInterestCode1"] 					:= RTRIM((cAliasSQG)->QG_AREA)
			oItemData["areaOfInterestCode2"]   					:= ""
			oItemData["wageExpectationTradable"]   				:= ""
			oItemData["workExperienceTime"]   					:= ALLTRIM(Str((cAliasSQG)->QG_TPEXPER))
			oItemData["workExperienceTimeArea1"]   				:= ""
			oItemData["workExperienceTimeArea2"]   				:= ""
			oItemData["contraIndicated"]   						:= ""
			oItemData["contraindicationReason"]   				:= ""
			oItemData["available"]   							:= ""
			oItemData["formOfRecruitment"]   					:= ""
			oItemData["resumeSkillsId"]   						:= ""
			oItemData["hierarchyLevelCode"]   					:= RTRIM((cAliasSQG)->QG_NIVHIER)
			oItemData["professionalProfileDescription"]		 	:= ""
			oItemData["areaOfInterestDescription1"]				:= ""
			oItemData["areaOfInterestDescription2"]				:= ""
			oItemData["hierarchyLevelDescription"]				:= ""
			oItemData["professionalSkillsResumeDescription"]	:= APDMSMM(SQG->QG_EXPER  ,TamSX3("QG_EXPER")[1])
			oItemData["employee1"]								:= ""
			oItemData["personalEmail"]							:= ""
			oItemData["maritalState"]  							:= RTRIM((cAliasSQG)->QG_ESTCIV)
			oItemData["complement"]								:= ""
			oItemData["arrivalDate"]							:= ""
			oItemData["letterModel19"]							:= ""
			oItemData["rne"]									:= ""
			oItemData["immigrationDecree"]						:= ""
			oItemData["rneExpirationDate"]						:= ""
			oItemData["workCardExpirationDate"]					:= ""
			oItemData["visaType"]								:= ""
			oItemData["passportNumber"]							:= ""
			oItemData["nativeCountry"]							:= ""
			oItemData["passportExpirationDate"]					:= ""
			oItemData["accessibilityFeaturesForJobLocal"]		:= ""
			oItemData["militaryDivision"]						:= ""
			oItemData["militaryCertificateEmissionDate"] 		:= ""
			oItemData["militaryCertificateEmitterAgency"]		:= ""
			oItemData["militaryRegion"] 						:= ""
			oItemData["militarySituation"] 						:= ""
			oItemData["electoralCardEmitterState"] 				:= ""
			oItemData["bloodType"] 								:= ""
			oItemData["image"] 									:= ""
			oItemData["neighborhoodTypeCode"] 					:= ""
			oItemData["naturalnessCode"] 						:= ""
			oItemData["naturalisationDate"] 					:= ""
			oItemData["driversLicenseEmitterAgency"] 			:= ""
			oItemData["rneEmitterAgency"] 						:= ""
			oItemData["countryId"] 								:= ""
			oItemData["deceaseDate"] 							:= ""
			oItemData["deathCertificateNumber"] 				:= ""
			oItemData["naturalisationGatehouse"] 				:= ""
			oItemData["brazilConditionClassification"] 			:= ""
			oItemData["driversLicenseFirstEmissionDate"] 		:= ""
			oItemData["firstJobYear"] 							:= ""

			AAdd(aItemQry, oItemData)
			(cAliasSQG)->(DBSkip())
		EndDo

		oHeadData["items"]  := aItemQry
		oEmpData 			:= oHeadData
	EndIf

	fResetErrorHandler()
	(cAliasSQG)->(DbCloseArea())

Return lRet


/*/{Protheus.doc} fPreValid
//TODO Check Pre-Validations
@author oliveira.hugo
@since 02/08/2019
@return return, return_description
@param oObj, object, descricao
@param cBranchId, characters, descricao
@param cCompId, characters, descricao
@param cProd, characters, descricao
/*/
Static Function fPreValid(oObj, cBranchId, cCompId)
	Local lRet 	   := .T.
	Local cMessage := ""
	
	Local nSM0	As Integer
	Local aSM0	As Array

	aSM0 := FWLoadSM0()
	
	// Check cCompId
	If Empty(cCompId)
		cMessage := STR0018 // "O PARÂMETRO 'companyId' É OBRIGATÓRIO."
		lRet 	 := .F.

	// Check cBranchId
	ElseIf Empty(cBranchId)
		cMessage := STR0019 // "O PARÂMETRO 'branchId' É OBRIGATÓRIO."
		lRet 	 := .F.

	// cBranchId Validation
	ElseIf (nSM0:=ascan(aSM0,{|X| Alltrim(X[1]) == Alltrim(cCompId) .AND. Alltrim(cBranchId)  $ Alltrim(X[2])})) == 0
		cMessage := STR0020 + cCompId + " " + cBranchId // "FILIAL NÃO ENCONTRADA PARA OS VALORES INFORMADOS DE EMPRESA E FILIAL: "
		lRet 	 := .F.
	EndIf

	If !lRet
		SetRestFault(ERRORCODE_DEF, EncodeUTF8(cMessage), , , , HELP_URL, )
	EndIf

Return lRet


/*/{Protheus.doc} fPosValid
//TODO Check data validation after SQG Query
@author oliveira.hugo
@since 07/08/2019
@version undefined
@return return, return_description
@param oObj, object, descricao
@param nPage, numeric, descricao
@param nReg, numeric, descricao
@param nTotalReg, numeric, descricao
/*/
Static Function fPosValid(oObj, nPage, nReg, nTotalReg)
	Local lRet		:= .T.
	Local cMessage	:= ""

	DEFAULT  nPage		:= 0
	DEFAULT  nReg		:= 0
	DEFAULT  nTotalReg	:= 0

	If nReg == 0 .OR. nTotalReg == 0
		cMessage	:= STR0021 // "NENHUM REGISTRO LOCALIZADO."
		lRet		:= .F.
	EndIf

	If !lRet
		SetRestFault(ERRORCODE_DEF, EncodeUTF8(cMessage), , , , HELP_URL, )
	EndIf
Return lRet



/*/{Protheus.doc} fIdValid
//TODO Clean especial character from Date Input. Input Format: 2012-04-23T18:25:43.511Z
@author oliveira.hugo
@since 07/08/2019
@version undefined
@return return, return_description
@param cId, characters, descricao
@param oEmpData, object, descricao
@example
(examples)
@see (links_or_references)
/*/
Static Function fIdValid(cId, oEmpData)
	Local lRet 		:= .T.
	Local cCompId 	:= SubStr(cId, 1,  2) 	// Grupo de Empresa
	Local cBranchId := SubStr(cId, 4,  8)	// Empresa e Filial
	Local cCIC 		:= SubStr(cId, 13,  18)	// CPF

	If cId == "" .OR. ALLTRIM(cCompId) == "" .OR. ALLTRIM(cBranchId) == "" .OR. ALLTRIM(cCIC) == ""
		lRet := .F.
		SetRestFault(ERRORCODE_DEF, EncodeUTF8(STR0025), , , , HELP_URL, ) //"O PARÂMETRO 'candidatesId' deve estar no formatado 'GRUPO DE EMPRESA|EMPRESA+FILIAL|CPF'.EXEMPLO: 'T1|D RJ    |21996647679'. "
	EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function ClearDate
Clean especial character from Date Input. Input Format: 2012-04-23T18:25:43.511Z
@author  oliveira.hugo
@since   26/04/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
Static Function fDelData(oEmpData, cBranchId, cCIC)
	Local lRet 	:= .F.
	
	// Se não houver erros executa a alteração no banco
	Begin Transaction
		DBSelectArea("SQG")
		DBSetOrder(3) // Filial + CPF
		
		// Recebe novos valores dos campos
		If SQG->(DbSeek(SQG->(xFilial("SQG", cBranchId) + cCIC)))
			RecLock("SQG", .F.)
			SQG->( dbDelete() )
			SQG->( MsUnLock() )
			lRet := .T.
		EndIF
	End Transaction
	
	If lRet
		oEmpData["code"] 		:= "200"
		oEmpData["description"] := STR0024 // "OPERAÇÃO EXECUTADA COM SUCESSO."
	Else
		oEmpData["code"]	:= "400"
		oEmpData["message"]	:= STR0023 // "ERRO NA EXECUÇÃO DA OPERAÇÃO."
	EndIf

Return lRet

/*/{Protheus.doc} fPutData
//TODO Descrição auto-gerada.
@author oliveira.hugo
@since 07/08/2019
@return return, return_description
@param oEmpData, object, descricao
@param cBranchId, characters, descricao
@param cCIC, characters, descricao
@param cBody, characters, descricao
/*/
Static Function fPutData(oItemDetail , cBranchId, cCIC, cBody)
	
	Local lRet 			:= .F.

	Default oItemDetail 	:= JsonObject():New()
	
	// Pega o conteudo do Body
	If !Empty(cBody)

		// Se não houver erros executa a alteração no banco
		Begin Transaction
			DBSelectArea("SQG")
			DBSetOrder(3) // Filial + CPF
			
			cBranchId := cBranchId + Space(Len(cFilAnt) - Len(RTRIM(cBranchId)))
			oItemDetail:FromJson(cBody)

			// Recebe novos valores dos campos
			If SQG->(DbSeek(xFilial("SQG", cBranchId) + cCIC))
				
				RecLock("SQG", .F.)
					SQG->QG_NOME 		:= Iif(oItemDetail:hasProperty("name"), oItemDetail["name"], "")
					SQG->QG_NATURAL		:= Iif(oItemDetail:hasProperty("homeState"), oItemDetail["homeState"], "")
					SQG->QG_MUNNASC		:= Iif(oItemDetail:hasProperty("naturalness"), oItemDetail["naturalness"], "")
					SQG->QG_SEXO		:= Iif(oItemDetail:hasProperty("sex"), oItemDetail["sex"], "")
					SQG->QG_NACIONA		:= Iif(oItemDetail:hasProperty("nationality"), oItemDetail["nationality"], "")
					SQG->QG_ENDEREC		:= Iif(oItemDetail:hasProperty("street"), oItemDetail["street"], "")
					SQG->QG_COMPLEM		:= Iif(oItemDetail:hasProperty("number"), oItemDetail["number"], "") 
					SQG->QG_ESTADO		:= Iif(oItemDetail:hasProperty("state"), oItemDetail["state"], "")
					SQG->QG_MUNICIP		:= Iif(oItemDetail:hasProperty("city"), oItemDetail["city"], "")
					SQG->QG_CEP			:= Iif(oItemDetail:hasProperty("cep"), oItemDetail["cep"], "")
					SQG->QG_CIC			:= Iif(oItemDetail:hasProperty("cpf"), oItemDetail["cpf"], "")
					SQG->QG_FONECEL		:= Iif(oItemDetail:hasProperty("phoneNumber2"), oItemDetail["phoneNumber2"], "")
					SQG->QG_RG			:= Iif(oItemDetail:hasProperty("identityNumber"), oItemDetail["identityNumber"], "")
					SQG->QG_NUMCP		:= Iif(oItemDetail:hasProperty("workCard"), oItemDetail["workCard"], "")
					SQG->QG_SERCP		:= Iif(oItemDetail:hasProperty("workCardSerialNumber"), oItemDetail["workCardSerialNumber"], "")
					SQG->QG_EMAIL		:= Iif(oItemDetail:hasProperty("email"), oItemDetail["email"], "")
					SQG->QG_BAIRRO		:= Iif(oItemDetail:hasProperty("district"), oItemDetail["district"], "")
					SQG->QG_TITULOE		:= Iif(oItemDetail:hasProperty("electoralCard"), oItemDetail["electoralCard"], "")
					SQG->QG_ZONASEC		:= Iif(oItemDetail:hasProperty("electoralSection"), oItemDetail["electoralWard"] + oItemDetail["electoralSection"], "")
					SQG->QG_UFCP		:= Iif(oItemDetail:hasProperty("workCardEmitterState"), oItemDetail["workCardEmitterState"], "")
					SQG->QG_HABILIT		:= Iif(oItemDetail:hasProperty("driversLicense"), oItemDetail["driversLicense"], "")
					SQG->QG_RESERV		:= Iif(oItemDetail:hasProperty("militaryDischargeCertificate"), oItemDetail["militaryDischargeCertificate"], "")
					SQG->QG_FONECOM		:= Iif(oItemDetail:hasProperty("phoneNumber3"), oItemDetail["phoneNumber3"], "")
					SQG->QG_PRETSAL		:= Iif(oItemDetail:hasProperty("wageExpectation"), VAL(oItemDetail["wageExpectation"]), 0)
					SQG->QG_AREA		:= Iif(oItemDetail:hasProperty("areaOfInterestCode1"), oItemDetail["areaOfInterestCode1"], "")
					SQG->QG_TPEXPER		:= Iif(oItemDetail:hasProperty("workExperienceTime"), VAL(oItemDetail["workExperienceTime"]), 0)
					SQG->QG_NIVHIER		:= Iif(oItemDetail:hasProperty("hierarchyLevelCode"), oItemDetail["hierarchyLevelCode"], "")
					APDMSMM(SQG->QG_EXPER  ,TamSX3("QG_EXPER")[1],,Iif(oItemDetail:hasProperty("professionalSkillsResumeDescription"), oItemDetail["professionalSkillsResumeDescription"], ""),1,,,"SQG","QG_EXPER")
					SQG->QG_ESTCIV		:= Iif(oItemDetail:hasProperty("maritalState"), oItemDetail["maritalState"], "")
					SQG->QG_FONE 		:= Iif(oItemDetail:hasProperty("phoneNumber1"), oItemDetail["PhoneNumber1"], "")
					If oItemDetail:hasProperty("disabled")
						SQG->QG_DFISICO		:=	Iif(oItemDetail["disabled"],"1","2")
					EndIf
					IF oItemDetail:hasProperty("birth") .AND. oItemDetail["birth"] != ""
						SQG->QG_DTNASC := Stod(Left(StrTran(oItemDetail:GetJsonText("birth"),"-",""),8))
					EndIf
					
					If oItemDetail:hasProperty("registryDate") .AND. oItemDetail["registryDate"] != ""
						SQG->QG_DTCAD := Stod(Left(StrTran(oItemDetail:GetJsonText("registryDate"),"-",""),8))
					EndIf

				SQG->( MsUnLock() )
				
				lRet := .T.
			EndIF
		End Transaction
	EndIf

	If !lRet
		SetRestFault(400,  EncodeUTF8(NoAcento(OemToAnsi(STR0023))),,,"",HELP_URL,{})
	EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} function formatDate

@author  
@since   26/04/2019
@version 12.1.23
/*/
//-------------------------------------------------------------------
/*/{Protheus.doc} formatDate
//TODO Return JSON Date Format 
@author oliveira.hugo
@since 07/08/2019
@return cNewDate, characters, data formatada
@param cDate, characters, data sem formatação do json
/*/
Static Function formatDate(cDate)
	Local cNewDate := ""
	
	DEFAULT cDate := ""

	IF !Empty(cDate)
		cNewDate := SubStr(cDate,1,4)+"-"+SubStr(cDate,5,2)+"-"+SubStr(cDate,7,2)+"T"+"00:00:00"
	EndIf

Return cNewDate


/*
{Protheus.doc} fSetErrorHandler
Function fSetErro
@Uso    Seta código e mensagem de erro 
@param  Objeto de erro
@return	Nenhum
@Autor  Lucas Peixoto Sepe - TOTVS
*/
Static Function fSetErrorHandler(cTitle)
	bError  := { |e| oError := e , oError:Description := cTitle + TAB + oError:Description, Break(e) }
	bErrorBlock    := ErrorBlock( bError )
Return(.T.)


/*/{Protheus.doc} fResetErrorHandler
//TODO fSetErro Seta código e mensagem de erro
@author oliveira.hugo
@return return, boolean, valor fixo .T.
@param cTitle, characters, título do erro
/*/
Static Function fResetErrorHandler(cTitle)
	bError  := { |e| oError := e , Break(e) }
	bErrorBlock    := ErrorBlock( bError )
Return(.T.)



/*/{Protheus.doc} fCompress
//TODO Descrição auto-gerada.
@author oliveira.hugo
@since 07/08/2019
@return return, return_description
@param oObj, object, descricao
/*/
Static Function fCompress(oObj)
	Local cJson    := ""
	Local cComp    := ""
	Local lCompact := .F.
	
	// Set gzip format to Json Object
	cJson := oObj:toJSON()
	
	cJson := EncodeUTF8(cJson)

	If Type("::GetHeader('Accept-Encoding')") != "U"  .and. 'GZIP' $ Upper(::GetHeader('Accept-Encoding') )
		lCompact := .T.
	EndIf
	
	If(lCompact)
		::SetHeader('Content-Encoding','gzip')
		GzStrComp(cJson, @cComp, @nLenComp )
	Else
		cComp := cJson
	Endif

Return cComp