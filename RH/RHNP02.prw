#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"

#INCLUDE "RHNP02.CH"

Function RHNP02()
Return .T.


WSRESTFUL Data DESCRIPTION STR0001 //"Serviço de dados referentes ao colaborador.

WSDATA WsNull	As String Optional

WSMETHOD GET DESCRIPTION "GET"  WSSYNTAX "data/profile/image/{employeeId} || data/profile/{employeeId} || data/profile/summary/{employeeId} || data/profile/isCoordinator/{employeeId}" 
 						 
END WSRESTFUL

WSMETHOD GET WSRECEIVE WsNull WSSERVICE Data

Local cJson		:= ''
Local nLenParms	:= Len(::aURLParms)
Local cJsonObj	:= "JsonObject():New()"
Local oItem		:= &cJsonObj
Local aMessages	:= {}
Local oMessages	:= &cJsonObj
Local cRD0Login	:= ''
Local cBranchVld	:= ""
Local lAuth		:= .T.
Local cToken		:= ""
Local cRD0Cod		:= ""
Local cMatSRA		:= ""
	
// --------------------------------------
// - Obtém o TOKEN no HEADER REQUEST
// - Em Formato Bearer + Token.
// --------------------------------------
cToken  := Self:GetHeader('Authorization')

// -----------------------------------------------------
// - Protheus server é CORS ( recursos compartilhados )
// - E desta forma necessita de allow credentials no
// - HEADER da requisição.
// -----------------------------------------------------
::SetHeader('Access-Control-Allow-Credentials' , "true")

cRD0Login  := GetLoginHR(cToken)
cBranchVld := GetBranch(cToken)
cRD0Cod    := GetCODHR(cToken)
cMatSRA	:= GetRegisterHR(cToken)

If Empty(cRD0Login) .Or. Empty(cBranchVld)

	oMessages["type"]   := "error"
	oMessages["code"]   := "401"
	oMessages["detail"] := EncodeUTF8(STR0002) //"Dados inválidos."
	
	Aadd(aMessages,oMessages)
	lAuth := .F.
	
EndIf

If lAuth
	If nLenParms == 3 .And. !Empty(::aURLParms[3]) .And. ::aURLParms[2] == "image"

		// - Obtem o LOGIN - CPF ou CODIGO.
		cRD0Login :=  Iif(Alltrim(::aURLParms[3]) == "{current}" .Or. Alltrim(::aURLParms[3]) == "%7Bcurrent%7D",cRD0Login, ::aURLParms[3])
		
		If ExistePessoa( "SRA" , xFilial("SRA" , cBranchVld) + cRD0Login , cEmpAnt , cBranchVld , .T. ) 
			cRD0Login	:= Iif(Vazio(RD0->RD0_LOGIN),RD0->RD0_CODIGO,Alltrim(RD0->RD0_LOGIN))
		EndIf
		
		DataImage(oItem, aMessages, cRD0Login, cBranchVld, ::aURLParms[3])
		
	ElseIf nLenParms == 3 .And. !Empty(::aURLParms[3]) .And. ::aURLParms[2] == "summary"
	
		DataProfile(oItem, aMessages, cRD0Login, .T.,cBranchVld,cRD0Cod,cMatSRA)

	ElseIf nLenParms == 3 .And. !Empty(::aURLParms[3]) .And. ::aURLParms[2] == "isCoordinator"
	
		ChkTeamManager( @oItem, cBranchVld, cMatSRA) //Verifica se a matricula logada e de um gestor
		
	ElseIf nLenParms == 2 .And. !Empty(::aURLParms[2]) .And. ::aURLParms[1] == "profile"
	
		// - Obtem o LOGIN - CPF ou CODIGO.
		DataProfile(oItem, aMessages, cRD0Login,,cBranchVld,cRD0Cod,cMatSRA)
		
	Else
		Aadd(aMessages,EncodeUTF8(STR0003)) //"O parâmetro employeeId é necessário para o serviço de dados do colaborador."
		oItem["data"] 		:= {}
		oItem["length"] 		:= ( Len(oItem["data"]) )
		oItem["messages"] 	:= aMessages
	EndIf
EndIf

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cjson)

Return(.T.)

// -------------------------------------------------------------------
// VERIFICA SE O USUARIO LOGADO E RESPONSAVEL POR UMA EQUIPE
// -------------------------------------------------------------------
Static Function ChkTeamManager( oItem, cBranchVld, cMatSRA)

Local cJsonObj		:= "JsonObject():New()"
Local lManager		:= .F.

Default oItem		:= &cJsonObj
Default cMatSRA		:= ""
Default cBranchVld	:= ""

If !Empty(cBranchVld) .And. !Empty(cBranchVld) 
	lManager := fGetTeamManager(cBranchVld, cMatSRA)
EndIf

oItem	   				:= &cJsonObj 
oItem["isCoordinator"]	:= 	lManager
	
Return(.T.)

/*/{Protheus.doc} DataProfile

@author:	Matheus Bizutti
@since:		07/03/2017
@param:		oItem - Object class JsonObject. aMessages - Messages default. cRD0Login - CPF or RD0_LOGIN.
/*/
Function DataProfile(oItem, aMessages, cRD0Login,lSummary,cBranchVld,cRD0Cod,cMatSRA)

Local cJsonObj   		:= "JsonObject():New()"
Local oSummary 		:= &cJsonObj
Local oCoordinator	:= &cJsonObj
Local oItemData	 	:= &cJsonObj
Local oTeams			:= &cJsonObj
Local oAddresses		:= &cJsonObj
Local oAddreType		:= &cJsonObj
Local oNumberPhone	:= &cJsonObj
Local oNumberCel		:= &cJsonObj
Local oEmailWork		:= &cJsonObj
Local oEmailPersonal	:= &cJsonObj
Local oState			:= &cJsonObj
Local oCountry		:= &cJsonObj
Local oPersonalData	:= &cJsonObj
Local oBornCity		:= &cJsonObj
Local oContacts		:= &cJsonObj
Local aDateGMT		:= {}
Local aDocs			:= {}
Local aEmails			:= {}
Local aPhones			:= {}
Local aAddressBody	:= {}
Local aTeams			:= {}
Local aData			:= {}
Local aCoordinator  	:= {}
Local aStructREST		:= {}
Local cRoutine		:= "W_PWSA260.APW" // Dados Cadastrais - Utilizada para buscar a VISÃO a partir da rotina; (AI8_VISAPV) na função GetVisionAI8().
Local aVision			:= {}
Local cVision			:= ""
Local oFlProperties 	:= &cJsonObj
Local aFlProperties		:= {}
/*
// - Variáveis de WebReferences não serão implementados na primeira versão do projeto.
Local oWebReferences:= &cJsonObj
Local aWebReferences:= {}
*/

Default oItem			:= &cJsonObj
Default aMessages		:= {}
Default cRD0Login		:= ''
Default lSummary    	:= .F.
Default cBranchVld  	:= FwCodFil()
Default cRD0Cod		:= ""
Default cMatSRA		:= ""

// - Verifica se existe o arquivo de relacionamento
// - Efetua o posicionamento no funcionário (SRA)

dbSelectArea("SRA")
SRA->( dbSetOrder(1) )
If (SRA->( dbSeek( xFilial("SRA" , cBranchVld) + cMatSRA) ))

	If !lSummary
		
		// ----------------------------------------------
		// - A Função GetVisionAI8() devolve por padrão
		// - Um Array com a seguinte estrutura:
		// - aVision[1][1] := "" - AI8_VISAPV
		// - aVision[1][2] := 0  - AI8_INIAPV
		// - aVision[1][3] := 0  - AI8_APRVLV
		// - Por isso as posições podem ser acessadas 
		// - Sem problemas, ex: cVision := aVision[1][1] 
		// ----------------------------------------------
		aVision := GetVisionAI8(cRoutine, cBranchVld)
		cVision := aVision[1][1] 
		
		// --------------------------------------
		// - aStructREST - Estrutura Hierarquica
		// - Do Funcionário Logado.
		// --------------------------------------
		aStructREST := APIGetStructure(cRD0Cod, "", cVision, cBranchVld, SRA->RA_MAT, , , , , cBranchVld, SRA->RA_MAT, ,)
		
		aCoordinator := CoordInfos(aClone(aStructREST),SRA->RA_MAT,cBranchVld)
		
		// - Summary
		oSummary["id"] 						:= cRD0Login 
		oSummary["name"]						:= Alltrim( EncodeUTF8(SRA->RA_NOME) ) 
		oSummary["roleDescription"] 		:= Alltrim( EncodeUTF8( FDesc("SRJ", SRA->RA_CODFUNC, "RJ_DESC",,cBranchVld ) ) ) 
		
		oItemData["summary"] 				:= oSummary
		oItemData["positionLevel"]			:= Alltrim( EncodeUTF8(fDesc("SQ3",SRA->RA_CARGO,"SQ3->Q3_DESCSUM")) )
		oItemData["registry"]				:= SRA->RA_MAT
		
		aDateGMT								:= Iif(!Empty(SRA->RA_ADMISSA),LocalToUTC( DTOS(SRA->RA_ADMISSA), "12:00:00" ),{})
		oItemData["admissionDate"]			:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")		
		
       If !empty(SRA->RA_DEPTO) 
          oItemData["department"]         := Alltrim( EncodeUTF8( fDesc("SQB",SRA->RA_DEPTO,"QB_DESCRIC",, xFilial("SQB" , cBranchVld) ) ) )
   		   oTeams["name"]						:= Alltrim( EncodeUTF8( fDesc("SQB", GetDepSup(SRA->RA_DEPTO,cBranchVld),"QB_DESCRIC") ) )//Alltrim( EncodeUTF8( fDesc("SQB", SRA->RA_DEPTO,"QB_DESCRIC") ) ) // - Protheus não possui o conceito de times, portanto segue o valor do department, para adequar a API.
		   oTeams["default"]   				:= .T.
       Else
          oItemData["department"]         := ""
          oTeams["name"]                  := ""
          oTeams["default"]               := .F.
       EndIf
		
		Aadd(aTeams, oTeams)
		
		oItemData["teams"] 					:= aTeams
		
		// - Coordinator
		oCoordinator["id"] 					:= ""
		oCoordinator["name"]					:= EncodeUTF8(aCoordinator[1])
		oCoordinator["roleDescription"]		:= Iif(Len(aCoordinator) >= 2, EncodeUTF8(aCoordinator[2]), "")
		
		oItemData["coordinator"] 			:= oCoordinator
		oItemData["gender"]					:= Iif( SRA->RA_SEXO == "M", "Masculino", "Feminino") 
		oItemData["nickname"]				:= Alltrim( EncodeUTF8(SRA->RA_APELIDO) )
		
		// - Data de Nascimento no format UTC
		aDateGMT								:= {}
		aDateGMT 								:= Iif(!Empty(SRA->RA_NASC),LocalToUTC( DTOS(SRA->RA_NASC), "12:00:00" ),{})
		oItemData["bornDate"]				:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")		
		
		oItemData["bornCity"]				:= Alltrim( EncodeUTF8(SRA->RA_MUNNASC) )
		oItemData["nacionality"]				:= Alltrim( EncodeUTF8( Posicione("SX5",1,XFILIAL("SX5") + '34' + PADR( SRA->RA_NACIONA,TamSx3("X5_CHAVE")[1]," " ), "X5_DESCRI" ) ) )
		
		oPersonalData["nickname"]			:= Alltrim( EncodeUTF8(SRA->RA_APELIDO) )
		oPersonalData["gender"]				:= Iif( SRA->RA_SEXO == "M", "Masculino", "Feminino")
		
		// - Data de Nascimento no format UTC
		aDateGMT								:= {}
		aDateGMT 								:= Iif(!Empty(SRA->RA_NASC),LocalToUTC( DTOS(SRA->RA_NASC), "12:00:00" ),{}) 
		oPersonalData["bornDate"]			:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")		
				
		oBornCity["id"]						:= "0"
		oBornCity["name"]						:= Alltrim( EncodeUTF8(SRA->RA_MUNNASC) )
		oBornCity["abbr"]						:= Nil
		oBornCity["country"]					:= Nil
		
		oCountry["id"]						:= ""
		oCountry["name"]						:= Alltrim( EncodeUTF8( fDesc("CCH",SRA->RA_CPAISOR,"CCH_PAIS",,SRA->RA_FILIAL) ) )
		
		oState["id"]							:=""
		oState["abbr"]						:= Alltrim( EncodeUTF8(SRA->RA_ESTADO) )
		oState["name"]						:= Alltrim( EncodeUTF8(SRA->RA_MUNICIP) )
		oState["country"]						:= oCountry
		oBornCity["state"]					:= oState
		
		oPersonalData["bornCity"]			:= oBornCity	
		
		oItemData["personalData"]			:= oPersonalData 
		
		// - Adresses
		oAddresses["id"]						:= ""
		oAddresses["abbr"]					:= Alltrim( EncodeUTF8( SRA->RA_LOGRTP ) ) 
		oAddresses["name"]					:= Alltrim( EncodeUTF8( fDescRCC_("S054", SRA->RA_LOGRTP, 1, 4, 5, 20) ) )
				
		oAddreType["addressType"]			:= oAddresses
		oAddreType["name"]					:= Alltrim( EncodeUTF8(SRA->RA_ENDEREC) )
		oAddreType["default"]				:= .T.
		oAddreType["type"]					:= "home"
		oAddreType["id"]						:= "pessoal"
		oAddreType["zipcode"]				:= Alltrim( EncodeUTF8(SRA->RA_CEP) ) 
		oAddreType["number"]					:= Alltrim( EncodeUTF8(SRA->RA_NUMENDE) )
		oAddreType["complement"]				:= Alltrim( EncodeUTF8(SRA->RA_COMPLEM) )
		oAddreType["neighborhood"]			:= Alltrim( EncodeUTF8(SRA->RA_BAIRRO) )
		
		oAddresses								:= Nil
		oAddresses								:= &cJsonObj
		
		oAddresses["id"]						:= ""
		oAddresses["name"]					:= Alltrim( EncodeUTF8(SRA->RA_MUNICIP) )
		oAddresses["abbr"]					:= Alltrim( EncodeUTF8(SRA->RA_ESTADO) )
		oAddresses["country"]				:= Nil
		
		oCountry 								:= Nil
		oCountry								:= &cJsonObj
		
		oCountry["id"]						:= ""
		oCountry["abbr"]						:= ""
		oCountry["name"]						:= Alltrim( EncodeUTF8( fDesc("CCH",SRA->RA_CPAISOR,"CCH_PAIS",,SRA->RA_FILIAL) ) )
		
		oState 								:= Nil
		oState									:= &cJsonObj
		
		oState["id"]							:= ""
		oState["abbr"]						:= Alltrim( EncodeUTF8(SRA->RA_ESTADO) )
		oState["name"]						:= Alltrim( EncodeUTF8(SRA->RA_MUNICIP) )
		oState["country"]						:= oCountry
		oAddresses["state"]					:= oState
		
		oAddreType["city"]					:= oAddresses
				
		Aadd(aAddressBody, oAddreType)
		
		oItemData["addresses"] 				:= aAddressBody		
		
		// - Phone
		oNumberPhone["id"]					:= Iif( !Empty(SRA->RA_DDDFONE) .And. !Empty(SRA->RA_TELEFON), "casa", "" )
		oNumberPhone["region"]				:= Nil
		oNumberPhone["ddd"]					:= Val(Alltrim( SRA->RA_DDDFONE ))
		oNumberPhone["number"]				:= Alltrim( SRA->RA_TELEFON )
		oNumberPhone["default"]				:= .T.
		oNumberPhone["type"]					:= "home"
				
		Aadd(aPhones, oNumberPhone )
		
		// - Phone
		oNumberCel["id"]						:= Iif( !Empty(SRA->RA_DDDCELU) .And. !Empty(SRA->RA_NUMCELU), "celular", "" )
		oNumberCel["region"]					:= Nil
		oNumberCel["ddd"]						:= Val(Alltrim( SRA->RA_DDDCELU ))
		oNumberCel["number"]					:= Alltrim( SRA->RA_NUMCELU )
		oNumberCel["default"]				:= .F.
		oNumberCel["type"]					:= "mobile"
		
		Aadd(aPhones, oNumberCel )
				
		// - E-mails	
		oEmailWork["id"] 						:= Iif( !Empty(SRA->RA_EMAIL), "profissional", "" )
		oEmailWork["email"]					:= Alltrim( EncodeUTF8( SRA->RA_EMAIL ) ) 
		oEmailWork["default"]				:= .T.
		oEmailWork["type"]					:= EncodeUTF8("work")
		
		Aadd(aEmails, oEmailWork)
		
		// - E-mails	
		oEmailPersonal["id"]					:= Iif( !Empty(SRA->RA_EMAIL2), "pessoal", "" )
		oEmailPersonal["email"]				:= Alltrim( EncodeUTF8( SRA->RA_EMAIL2 ) ) 
		oEmailPersonal["default"]			:= .F.
		oEmailPersonal["type"]				:= EncodeUTF8("home")
		
		Aadd(aEmails, oEmailPersonal)
			
		oContacts["phones"]					:= aPhones
		oContacts["emails"]					:= aEmails
		oItemData["contacts"]				:= oContacts
		
		/*
		 * - No protheus não há webReferences
		 * - Portanto será enviado para a API 
		 * - Uma lista vazia.
		oWebReferences["url"] 				:= EncodeUTF8( "http://fluig.totvs.com/andre.pontes" ) 
		oWebReferences["default"]			:= .T.
		oWebReferences["type"]				:= "fluig" 
		
		Aadd(aWebReferences, oWebReferences)
		*/
		
		oItemData["webReferences"]			:= {}
		
		// - Obtém os Documentos necessários		
		GetDocuments(@aDocs)
		
		oItemData["documents"]				:= aDocs
		
		//-----------------------------------		
		//Adiciona tratamento para visualizacao e edicao de campos - FieldProperties
		//-----------------------------------
		
		//Nao exibir o campo Equipe porque nao e usado no Protheus
		oFlProperties := &cJsonObj
		oFlProperties["field"] 				:= "teams.name"
		oFlProperties["visible"]			:= .F.
		oFlProperties["editable"]			:= .F.
		oFlProperties["required"]			:= .F.
		
		Aadd(aFlProperties, oFlProperties)
		
		//Exibe o Apelido apenas de tiver sido informado no cadastro
		If Empty(SRA->RA_APELIDO)
			oFlProperties := &cJsonObj
			oFlProperties["field"] 			:= "personalData.nickname"
			oFlProperties["visible"]		:= .F.
			oFlProperties["editable"]		:= .F.
			oFlProperties["required"]		:= .F.	
		
			Aadd(aFlProperties, oFlProperties)
		EndIf
		
		oItemData["props"]		:= aFlProperties
					
	Else
		
		// - Summary
		oItemData["id"] 				:= SRA->RA_FILIAL+"|"+SRA->RA_MAT
		oItemData["name"]				:= Alltrim( EncodeUTF8(SRA->RA_NOME) ) 
		oItemData["roleDescription"] 	:= Alltrim( EncodeUTF8( FDesc("SRJ", SRA->RA_CODFUNC, "RJ_DESC",,cBranchVld ) ) )

		aDateGMT						:= Iif(!Empty(SRA->RA_ADMISSA),LocalToUTC( DTOS(SRA->RA_ADMISSA), "12:00:00" ),{})
		oItemData["admissionDate"]		:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")		

		// - Data de Nascimento no format UTC
		aDateGMT						:= {}
		aDateGMT						:= Iif(!Empty(SRA->RA_NASC),LocalToUTC( DTOS(SRA->RA_NASC), "12:00:00" ),{}) 
		oItemData["bornDate"]		    := Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")		
		
	EndIf
		
	Aadd(aData, oItemData)	
	oItem["data"] 		:= oItemData
	oItem["length"] 		:= Len(aData)
	oItem["messages"] 	:= Iif( Empty(aData), EncodeUTF8(STR0004) + cRD0Login , aMessages ) //"Não foi possível carregar os dados para colaborador: "
	
EndIf

Return( oItem )


// - Efetua busca da RD0->RD0_BITMAP do usuário logado.
Function DataImage(oItem, aMessages, cRD0Login, cBranchVld, cMatSRA)

Local cFoto 	 	:= ''
Local cQryRD0	 	:= GetNextAlias()

Local aMsg		 	:= {}
Local cJsonObj	:= "JsonObject():New()"
Local oItemRet	:= &cJsonObj
Local cMat		 	:= ""
Local cRD0Branch	:= ""

Local aRet			:= {}
Local nPos		   	:= 0
Local cFuncFoto	:= ""
Local cMatRD0		:= ""
Local cBranchRD0	:= ""

Default oItem    := &cJsonObj
Default aMessages:= {}
Default cRd0Login:= {}
Default cBranchVld:= FwCodFil()


oItemRet["content"]	:= ""
oItemRet["type"]		:= "" 


If Alltrim(cMatSRA) == "{current}" .Or. Alltrim(cMatSRA) == "%7Bcurrent%7D"

  cRD0Branch := xFilial("RD0", cBranchVld)
  BEGINSQL ALIAS cQryRD0
    SELECT RD0.RD0_NOME, RD0.RD0_CODIGO, RD0.RD0_CIC, RD0.RD0_LOGIN, RD0.RD0_BITMAP
    FROM %table:RD0% RD0
    WHERE RD0_FILIAL =  %Exp:cRD0Branch% AND
        RD0.RD0_LOGIN = %exp:cRD0Login%  OR
        RD0.RD0_CIC   = %exp:cRD0Login%  AND
        RD0.%notDel%
  ENDSQL

  If !(cQryRD0)->(Eof())
    cFuncFoto := (cQryRD0)->RD0_BITMAP

    //busca matriculas associada a pessoa, para capturar a foto do SRA
    If GetAccessEmployee(cRD0Login, @aRet, .T.)
        If Len(aRet) >= 1
            nPos := Ascan(aRet,{|x| !(x[10] $ "30/31")}) 
            If nPos > 0
                cMatRD0     := aRet[nPos][1]
                cBranchRD0  := aRet[nPos][3]
            Else
                cMatRD0     := aRet[1][1]
                cBranchRD0  := aRet[1][3]
            EndIf 
        EndIf

        dbSelectArea("SRA")
        SRA->( dbSetOrder(1) )
        If (SRA->( dbSeek( xFilial("SRA" , cBranchRD0) + cMatRD0) ))
           If !empty(SRA->RA_BITMAP)
               cFuncFoto := Alltrim(SRA->RA_BITMAP)
             EndIf    
        EndIf

        oItemRet["content"] := RetFoto_( cFuncFoto )
        oItemRet["type"]        := "jpg" 
    EndIf   
  EndIf

  (cQryRD0)->( DbCloseArea() )

Else

   dbSelectArea("SRA")
   SRA->( dbSetOrder(1) )

   If (SRA->( dbSeek( xFilial("SRA" , cBranchVld) + cMatSRA) )) //Busca fotos da equipe
       If  !empty(SRA->RA_BITMAP)
            cFuncFoto := Alltrim(SRA->RA_BITMAP)

            oItemRet["content"] := RetFoto_( cFuncFoto )
            oItemRet["type"]    := "jpg" 
        EndIf    
   ElseIf (SRA->( dbSeek(cMatSRA) ))  //busca foto notifications, já vem com filial no param
       If  !empty(SRA->RA_BITMAP)
            cFuncFoto := Alltrim(SRA->RA_BITMAP)

            oItemRet["content"] := RetFoto_( cFuncFoto )
            oItemRet["type"]    := "jpg" 
        EndIf    
    EndIf

EndIf



oItem["data"] 		:= oItemRet
oItem["length"]		:= 1

oItemRet				:= Nil
oItemRet				:= &cJsonObj
	
oItem["messages"] 	:= {}

	
Return( oItem )


/*/{Protheus.doc}RetFoto_(cFoto)
// - Retorna a foto cadastrada no repositório de imagens do Protheus.
@author: 	Matheus Bizutti
@since:	06/03/2017
@param:	cFoto - Contém o conteúdo do campo RD0->RD0_BITMAP.
/*/

Function RetFoto_(cFoto)

Local cBmpPict
Local nHandle
Local nBytesRead
Local cErro			:= ""
Local cLine			:= ""
Local cRet				:= ""
Local cPathPict		:= GetSrvProfString("Startpath","")
Local cExtensao		:= ".JPG"

If !Empty( cBmpPict := Upper( AllTrim( cFoto ) ) )

	If RepExtract(cBmpPict,cPathPict+cBmpPict)
	
		If !File(cPathPict+cBmpPict+cExtensao)
			cExtensao := ".BMP"
		EndIf
		
		If File(cPathPict+cBmpPict+cExtensao)
			nHandle := fOpen(cPathPict+cBmpPict+cExtensao,0)
			// Se houver erro de abertura abandona processamento
			If nHandle = -1
				cErro := STR0005 //"problemas na abertura da foto"                                                                                                                                                                                                                                                                                                                                                                                                                                                           
				Return ""
			EndIf
			
			nBytesRead := fSeek(nHandle,0,2)
			fSeek(nHandle,0,0)	//Posiciona no inicio do arquivo
			cLine := Space(nBytesRead)
			fRead(nHandle,@cLine,nBytesRead) // Leitura da primeira linha do arquivo texto
			
			// Fecha o Arquivo
			fClose(nHandle)
			fErase(cPathPict+cBmpPict+cExtensao)
		EndIf
		
	Else
		cErro := STR0006 //"Falha ao extrair foto"
	EndIf	
	
EndIf

If !Empty(cLine)
	cRet := Encode64(cLine)
EndIf

Return cRet


/*/{Protheus.doc}GetDocuments(aDocs)
- Responsável por retornar o nódulo documents[{}] do json.
@author:	Matheus Bizutti
@since:		16/03/2017
@param:		aDocs - array da estrutura dos docs.

/*/
Function GetDocuments(aDocs)

Local cJsonObj		:= "JsonObject():New()"
Local oFieldsDoc	:= &cJsonObj
Local oDocuments	:= &cJsonObj
Local aFieldsDoc	:= {}
Local aDateGMT		:= {}
Local aAreaSX3		:= {}
Local cAux			:= ""

Default aDocs		:= {}

// -----------------------------------------------------------------------------------
// - Documents
oDocuments["type"] 					:= "brid"
oDocuments["label"]					:= Nil

// - BRID - RG
oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_RG )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= "99999999-99"

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

// - ESTADO EMISSOR 
oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "senderState"
oFieldsDoc["value"]					:= SRA->RA_RGUF
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= Nil

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

// - ESTADO EMISSOR
oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "sender"
oFieldsDoc["value"]					:= SRA->RA_RGORG
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= Nil

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

// - DATA DE EMISSÃO
oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "senderDate"

aDateGMT								:= Iif(!Empty(SRA->RA_DTRGEXP),LocalToUTC( DTOS(SRA->RA_DTRGEXP), "12:00:00" ),{}) 
oFieldsDoc["value"]					:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")			
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= "99/99/9999"

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

// -------------------------------------------------------------------------------------------------------------------------------------------------
// - DOCUMENTS - CPF
// - Nódulo responsável para o WIDGET DE CPF no UX.

oFieldsDoc := Nil
oDocuments := Nil
aFieldsDoc := {}
oFieldsDoc := &cJsonObj
oDocuments := &cJsonObj

// - CPF
oDocuments["type"] 					:= "cpf"
oDocuments["label"]					:= Nil

// CPF
oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_CIC )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= "999.999.999-99"

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

// -------------------------------------------------------------------------------------------------------------------------------------------------
// - DOCUMENTS - CARTEIRA DE TRABALHO - WORKCARD
// - Nódulo responsável para o WIDGET DE CARTEIRA DE TRABALHO no UX.

oFieldsDoc := Nil
oDocuments := Nil
aFieldsDoc := {}
oFieldsDoc := &cJsonObj
oDocuments := &cJsonObj

// - CARTEIRA DE TRABALHO
oDocuments["type"] 					:= "workCard"
oDocuments["label"]					:= Nil

// NÚMERO
oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_NUMCP )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

// SÉRIE
oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "series"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_SERCP )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

// ESTADO EMISSOR
oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "senderState"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_UFCP )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

// DATA DE EMISSÃO
oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "senderDate"

aDateGMT								:= Iif(!Empty(SRA->RA_DTCPEXP),LocalToUTC( DTOS(SRA->RA_DTCPEXP), "00:00:00" ),{})
oFieldsDoc["value"]					:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "00:00:00")				 

oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

// -------------------------------------------------------------------------------------------------------------------------------------------------
// - DOCUMENTS - PIS - WORKCARD
// - Nódulo responsável para o WIDGET DE PIS no UX.

oFieldsDoc := Nil
oDocuments := Nil
aFieldsDoc := {}
oFieldsDoc := &cJsonObj
oDocuments := &cJsonObj

oDocuments["type"] 					:= "pis"
oDocuments["label"]					:= Nil

oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_PIS)
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= "999.99999.99-9"

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

// -------------------------------------------------------------------------------------------------------------------------------------------------
// - DOCUMENTS - TITULO DE ELEITOR 
// - Nódulo responsável para o WIDGET DE TITULO DE ELEITOR no UX.

oFieldsDoc := Nil
oDocuments := Nil
aFieldsDoc := {}
oFieldsDoc := &cJsonObj
oDocuments := &cJsonObj

oDocuments["type"] 					:= "elector"
oDocuments["label"]					:= Nil

oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_TITULOE)
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= "9999999999-99"

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "zone"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_ZONASEC)
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "section"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_SECAO)
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

// -------------------------------------------------------------------------------------------------------------------------------------------------
// - DOCUMENTS - RESERVISTA 
// - Nódulo responsável para o WIDGET DE RESERVISTA no UX.

oFieldsDoc := Nil
oDocuments := Nil
aFieldsDoc := {}
oFieldsDoc := &cJsonObj
oDocuments := &cJsonObj

oDocuments["type"] 					:= "war"
oDocuments["label"]					:= Nil

oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_RESERVI )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

// -------------------------------------------------------------------------------------------------------------------------------------------------
// - DOCUMENTS - CNH 
// - Nódulo responsável para o WIDGET DE CNH no UX.

oFieldsDoc := Nil
oDocuments := Nil
aFieldsDoc := {}
aDateGMT   := {}
oFieldsDoc := &cJsonObj
oDocuments := &cJsonObj

oDocuments["type"] 					:= "driverLicense"
oDocuments["label"]					:= "Carteira de motorista"

oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_HABILIT )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

//Exibe o código da categoria da CNH
If !Empty( SRA->RA_CATCNH )
	aAreaSX3	:= SX3->(GetArea())
	cAux		:= AllTrim(posicione("SX3", 2, "RA_CATCNH"	, "X3CBox()"))
	cAux 		:= SubStr(cAux, AT(SRA->RA_CATCNH + "=",cAux))
	If At(";",cAux) > 0
		cAux := SubStr(cAux,3,At(";",cAux)-3)
	Else
		cAux := Alltrim(SubStr(cAux,3))
	EndIf	
	cAux 		:= SubStr( cAux, Len(cAux), 1)
	RestArea( aAreaSX3 )
EndIf

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "other"
oFieldsDoc["value"]					:= cAux
oFieldsDoc["label"]					:= EncodeUTF8(STR0007) //"Categoria"
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "sender"
oFieldsDoc["value"]					:= Alltrim( EncodeUTF8(SRA->RA_CNHORG))
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "senderDate"

aDateGMT								:= Iif(!Empty(SRA->RA_DTEMCNH),LocalToUTC( DTOS(SRA->RA_DTEMCNH), "12:00:00" ),{})  
oFieldsDoc["value"]					:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")				 

oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "dueDate"

aDateGMT   := {}
aDateGMT								:= Iif(!Empty(SRA->RA_DTVCCNH),LocalToUTC( DTOS(SRA->RA_DTVCCNH), "12:00:00" ),{})  
oFieldsDoc["value"]					:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")			

oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

// -------------------------------------------------------------------------------------------------------------------------------------------------
// - DOCUMENTS - PASSAPORTE 
// - Nódulo responsável ppara o WIDGET DE PASSAPORTE no UX.

oFieldsDoc := Nil
oDocuments := Nil
aFieldsDoc := {}
aDateGMT   := {}
oFieldsDoc := &cJsonObj
oDocuments := &cJsonObj

oDocuments["type"] 					:= "passport"
oDocuments["label"]					:= Nil

oFieldsDoc["type"] 					:= "number"
oFieldsDoc["value"]					:= Alltrim( SRA->RA_NUMEPAS )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "originCountry"
oFieldsDoc["value"]					:= Alltrim( EncodeUTF8(FDESC("CCH",SRA->RA_CODPAIS,"CCH_PAIS",,SRA->RA_FILIAL) ) )
oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "senderDate"

aDateGMT								:= Iif(!Empty(SRA->RA_DEMIPAS),LocalToUTC( DTOS(SRA->RA_DEMIPAS), "12:00:00" ),{}) 
oFieldsDoc["value"]					:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")			

oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oFieldsDoc 							:= &cJsonObj
oFieldsDoc["type"] 					:= "dueDate"

aDateGMT   := {}
aDateGMT								:= Iif(!Empty(SRA->RA_DVALPAS),LocalToUTC( DTOS(SRA->RA_DVALPAS), "12:00:00" ),{}) 
oFieldsDoc["value"]					:= Iif(Empty(aDateGMT),"",Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + "12:00:00" + "Z")		

oFieldsDoc["label"]					:= Nil
oFieldsDoc["mask"]					:= ""

Aadd(aFieldsDoc, oFieldsDoc)

oDocuments["fields"]					:= aFieldsDoc

Aadd(aDocs, oDocuments)

Return(Nil)

// - Até o ajuste da fDescRCC padrão
// - utilizaremos está function ponteirando corretamente,
// - Pois o fonte original busca o campo RCC_CONTEUDO presente no dicionário fase4 apenas.
Function fDescRCC_(cCodigo,cConteudo,nPos1,nPos2,nPos3,nPos4,lValidFil)
Local cRet := ""

DEFAULT lValidFil := .F.

_aArea := GetArea()

If nPos1 = Nil
	nPos1 := 0
EndIf
If nPos2 = Nil
	nPos2 := 0
EndIf

If cCodigo <> Nil .AND. cConteudo <> Nil
	dbSelectArea( "RCC" )
	dbSetOrder(1)
	dbSeek(xFilial("RCC")+ cCodigo)
	While !Eof() .AND. RCC->RCC_FILIAL+RCC_CODIGO == xFilial("RCC")+cCodigo
		If RCC->RCC_FILIAL+RCC_CODIGO == xFilial("RCC")+cCodigo .AND. Alltrim(Substr(RCC->RCC_CONTEU,nPos1,nPos2)) == Alltrim(cConteudo)
			If !lValidFil .or. RCC->RCC_FIL == xFilial("RCC") .or. RCC->RCC_FIL == SRA->RA_FILIAL 
				cRet := Substr(RCC->RCC_CONTEU,nPos3,nPos4)
				Exit
			EndIf
		EndIf
		dBSkip()	
	EndDo
	//Não encontrou registro com a filial, busca sem filial
	If lValidFil .and. Empty(cRet)
		dbSeek(xFilial("RCC")+ cCodigo)
		While !Eof() .AND. RCC->RCC_FILIAL+RCC_CODIGO == xFilial("RCC")+cCodigo
			If RCC->RCC_FILIAL+RCC_CODIGO == xFilial("RCC")+cCodigo .AND. Alltrim(Substr(RCC->RCC_CONTEU,nPos1,nPos2)) == Alltrim(cConteudo)
				If Empty(RCC->RCC_FIL) 
					cRet := Substr(RCC->RCC_CONTEU,nPos3,nPos4)
					Exit
				EndIf
			EndIf
			dBSkip()
		EndDo
	EndIf
EndIf

RestArea(_aArea)

Return(cRet)

/*/{Protheus.doc}CoordInfos()

@author:	Matheus Bizutti
@since:		16/03/2017
/*/
Function CoordInfos(aStructREST,cMat,cBranchVld)

Local aRet			:= {}
Local nX			:= 0
Local nI			:= 0
Local aGetAreaSRA	:= SRA->(GetArea())
Local aGetArea	:= GetArea()

Default aStructREST := {}
Default cMat		:= ""
Default cBranchVld  := FwCodFil()

For nX := 1 To Len(aStructREST)

	For nI := 1 To Len(aStructRest[nX]:ListOfEmployee)
	
		If aStructRest[nX]:ListOfEmployee[nI]:Registration == cMat
		
			Aadd(aRet,Alltrim(aStructRest[nX]:ListOfEmployee[nI]:NameSup))
			
			If SRA->(DbSeek(xFilial("SRA")+aStructRest[nX]:ListOfEmployee[nI]:SupRegistration))
				Aadd(aRet,Alltrim( FDesc("SRJ", SRA->RA_CODFUNC, "RJ_DESC",,xFilial("SRJ", cBranchVld) ) ))
			EndIf 
			
		EndIf
		
	Next nI

Next nX

RestArea(aGetAreaSRA)
RestArea(aGetArea)

Return( aRet )