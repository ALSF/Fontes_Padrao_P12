#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FILEIO.CH"

#INCLUDE "RHNP09.CH"

Function RHNP09()
Return .T.


WSRESTFUL Health DESCRIPTION STR0001 //"Operações relacionadas ao segmento de segurança e medicina do trabalho" 

	WSDATA employeeId	As String Optional
	WSDATA WsNull		As String Optional
	WSDATA type			As String Optional
	WSDATA filter		As String Optional
	WSDATA page       	As String Optional
	WSDATA pageSize   	As String Optional	
	
	WSMETHOD GET fRetRegsMed ;
	 DESCRIPTION STR0005 ; //STR0005 "Retorna todos os tipos de atestado médico"
	 WSSYNTAX "/health/medicalcertificate/{employeeId}" ;
	 PATH "/medicalcertificate/{employeeId}" ; 
	 PRODUCES 'application/json;charset=utf-8'

	WSMETHOD GET fInfArqMed ;
	 DESCRIPTION STR0036 ; //"Retorna informações do arquivo de anexo da solicitação do atestado"
	 WSSYNTAX "/health/medicalcertificate/file/info/{medicalCertificateId}" ;
	 PATH "/medicalcertificate/file/info/{medicalCertificateId}" ;
	 PRODUCES 'application/json;charset=utf-8'

	WSMETHOD GET fDownArqMed ;
	 DESCRIPTION STR0037 ; //"Retorna o arquivo de anexo da solicitação do atestado"
	 WSSYNTAX "/health/medicalcertificate/file/download/{medicalCertificateId}/{fileExtension}" ;
	 PATH "/medicalcertificate/file/download/{medicalCertificateId}/{fileExtension}" ; 
	 PRODUCES 'image/jpeg;charset=utf-8'

	WSMETHOD GET fGtReasons ;
	 DESCRIPTION STR0019 ; //Retorna os possíveis motivos para o afastamento. 
	 WSSYNTAX "/health/medicalcertificate/reasons" ;
	 PATH "/medicalcertificate/reasons" ; 
	 PRODUCES 'application/json;charset=utf-8'
	
	WSMETHOD GET fGtTypes ;
	 DESCRIPTION STR0004 ; //"Retorna os tipos de atestado médico." 
	 WSSYNTAX "/health/medicalcertificate/type" ;
	 PATH "/medicalcertificate/type" ; 
	 PRODUCES 'application/json;charset=utf-8'
	
	WSMETHOD GET fGtCodCid ;
	 DESCRIPTION STR0011 ; //"Retorna todos os CIDs cadastrados"
	 WSSYNTAX "/health/cid" ;
	 PATH "/cid" ; 
	 PRODUCES 'application/json;charset=utf-8'

 	WSMETHOD GET fByIdMed ;
	 DESCRIPTION STR0009 ; //"Retorna as informações registro de atestado"
	 WSSYNTAX "/health/medicalcertificate/{employeeId}/{medicalCertificateId}" ;
	 PATH "/medicalcertificate/{employeeId}/{medicalCertificateId}" ; 
	 PRODUCES 'application/json;charset=utf-8'

 	WSMETHOD POST fSetMedCertificate ;
	 DESCRIPTION STR0008 ; //"Cria um registo de atestado"
	 WSSYNTAX "/health/medicalcertificate/{employeeId}/" ;
	 PATH "/medicalcertificate/{employeeId}/" ; 
	 PRODUCES 'application/json;charset=utf-8'	 

 	WSMETHOD PUT fPutMedCertificate ;
	 DESCRIPTION STR0007 ; //"Atualiza um registo de atestado"
	 WSSYNTAX "/health/medicalcertificate/{employeeId}" ;
	 PATH "/medicalcertificate/{employeeId}" ; 
	 PRODUCES 'application/json;charset=utf-8'

 	WSMETHOD DELETE fDelMedCertificate ;
	 DESCRIPTION STR0010 ; //"Exclui as informações registro de atestado"
	 WSSYNTAX "/health/medicalcertificate/{employeeId}/{medicalCertificateId}" ;
	 PATH "/medicalcertificate/{employeeId}/{medicalCertificateId}" ; 
	 PRODUCES 'application/json;charset=utf-8'

END WSRESTFUL


// -------------------------------------------------------------------
//"Retorna informacoes do arquivo para download
// -------------------------------------------------------------------
WSMETHOD GET fInfArqMed WSREST Health

Local cJsonObj  := "JsonObject():New()"
Local oItem     := &cJsonObj
Local aUrlParam	:= Self:aUrlParms
Local nLenParms	:= Len(aUrlParam)
Local cNameArq	:= ""
Local cType		:= ""
Local cMsg		:= ""
Local cFilRH3	:= ""
Local cCodRH3	:= ""
Local lRet		:= .T.

Self:SetHeader('Access-Control-Allow-Credentials', "true")
	
If nLenParms == 4 .And. !Empty(aUrlParam[4])
	cFilRH3	:= SubStr( aUrlParam[4], 1, TamSX3("RA_FILIAL")[1] )
	cCodRH3	:= SubStr( aUrlParam[4], Len(cFilRH3)+1 )
	cRet	:= fMedImg( 1, cFilRH3, cCodRH3, @cNameArq, @cType, @cMsg )
	lRet	:= Empty(cMsg)
EndIf

If lRet
	oItem["content"] := cRet
	oItem["type"]    := cType 	
	oItem["name"]    := cNameArq

	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	Self:SetResponse(cJson)
Else
	SetRestFault(500, cMsg)
EndIf

Return( lRet )


// -------------------------------------------------------------------
//"Retorna a imagem para download
// -------------------------------------------------------------------
WSMETHOD GET fDownArqMed WSREST Health

Local aUrlParam	:= Self:aUrlParms
Local nLenParms	:= Len(aUrlParam)
Local cNameArq	:= ""
Local cType		:= ""
Local cMsg		:= ""
Local cFilRH3	:= ""
Local cCodRH3	:= ""
Local lRet		:= .T.

Self:SetHeader('Access-Control-Allow-Credentials', "true")
	
If nLenParms == 5 .And. !Empty(aUrlParam[4])
	cFilRH3	:= SubStr( aUrlParam[4], 1, TamSX3("RA_FILIAL")[1] )
	cCodRH3	:= SubStr( aUrlParam[4], Len(cFilRH3)+1 )
	cRet	:= fMedImg( 2, cFilRH3, cCodRH3, @cNameArq, @cType, @cMsg )
	lRet	:= Empty(cMsg)
EndIf 

If lRet
	Self:SetHeader("Content-Disposition", "attachment; filename=" + cNameArq )
	Self:SetResponse(cRet)
Else
	SetRestFault(500, cMsg)
EndIf

Return( lRet )


// -------------------------------------------------------------------
//"Retorna os atestados com status diferente de pendente"
// -------------------------------------------------------------------
WSMETHOD GET fRetRegsMed WSREST Health

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local aData			:= {}
Local cJson			:= ""
Local cPage			:= ""
Local cPageSize		:= ""
Local cStatus		:= ""
Local nX			:= 0
Local nTipo			:= 3
Local lNext        	:= .F.
Local aQryParam		:= Self:aQueryString

Self:SetHeader('Access-Control-Allow-Credentials' , "true")
	
cToken		:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)
cMatSRA		:= GetRegisterHR(cToken)

If !Empty(cBranchVld) .And. !Empty(cMatSRA)

	For nX := 1 To Len( aQryParam )
		Do Case
			Case UPPER(aQryParam[nX,1]) == "PAGE"
				cPage		:= aQryParam[nX,2] 
			Case UPPER(aQryParam[nX,1]) == "PAGESIZE"
				cPageSize	:= aQryParam[nX,2]
			Case UPPER(aQryParam[nX,1]) == "STATUS"
				cStatus		:= aQryParam[nX,2]
		End Case
	Next

	//1 = Pendentes de aprovacao (status pending)
	//2 = Aprovados ou Reprovados (status notpending)
	//3 = Todos (status vazio)
	nTipo := If( Empty(cStatus), 3, If( cStatus == "notpending", 2, 1 ) )
	
	aData := fGetRegsMedical( nTipo, cBranchVld, cMatSRA, Nil, cPage, cPageSize, @lNext ) 
EndIf

oItem["hasNext"]  := lNext
oItem["items"]    := aData

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
Self:SetResponse(cJson)

Return(.T.)


// -------------------------------------------------------------------
//Retorna os possíveis motivos para o afastamento.
// -------------------------------------------------------------------
WSMETHOD GET fGtReasons WSREST Health

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oTipoAfas		:= &cJsonObj
Local cJson			:= ""
Local cBrchRCM		:= ""
Local cQuery		:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local aTipoAfas		:= {}

Self:SetHeader('Access-Control-Allow-Credentials' , "true")
	
cToken  	:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)

If !Empty( cBranchVld )

	cBrchRCM	:= xFilial("RCM", cBranchVld)
	cQuery 		:= GetNextAlias()
	
	//Apresenta os motivos considerando: dias corridos, tipo informado, e diferente de Ferias/Recesso
	BEGINSQL ALIAS cQuery
	
		SELECT RCM_FILIAL, RCM_TIPO, RCM_DESCRI
		FROM
			%Table:RCM% RCM
		WHERE
			RCM.RCM_FILIAL = %Exp:cBrchRCM% AND
			RCM.RCM_TIPOAF NOT IN ('', '4') AND
			RCM.RCM_TIPODI = '2' AND 
			RCM.%NotDel%
		ORDER BY 1, 2
	ENDSQL

	While !(cQuery)->(Eof()) 

		oTipoAfas 					:= &cJsonObj 
		oTipoAfas["id"]				:= (cQuery)->RCM_TIPO 
		oTipoAfas["description"]	:= EncodeUTF8( AllTrim((cQuery)->RCM_DESCRI) )
		aAdd(aTipoAfas, oTipoAfas)

		(cQuery)->(dbSkip()) 
	EndDo
	
	(cQuery)->( DBCloseArea() )

	oItem["items"] 	  := aTipoAfas
	oItem["hasNext"]  := .F.
	
	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	Self:SetResponse(cJson)

EndIf

Return(.T.)


// -------------------------------------------------------------------
//Retorna os tipos de atestado médico
// -------------------------------------------------------------------
WSMETHOD GET fGtTypes WSREST Health

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oTipoAfas		:= ""
Local cJson			:= ""
Local cBrchRCM		:= ""
Local cQuery		:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local nX			:= 0
Local aTipos		:= {}
Local aTipoAfas		:= {}


Self:SetHeader('Access-Control-Allow-Credentials' , "true")

aTipos := { ;
			EncodeUTF8(STR0020), ; 	//"Afastamento" 
			EncodeUTF8(STR0021), ;	//"Licença" 
			EncodeUTF8(STR0022) }	//"Outros"	

For nX := 1 To Len(aTipos) 
	oTipoAfas 			:= &cJsonObj 
	oTipoAfas["id"]		:= cValToChar(nX) 
	oTipoAfas["name"]	:= aTipos[nX]
	
	aAdd(aTipoAfas, oTipoAfas)
Next nX

oItem["items"] 	  := aTipoAfas
oItem["hasNext"]  := .F.

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
Self:SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
//"Retorna todos os CIDs cadastrados"
// -------------------------------------------------------------------
WSMETHOD GET fGtCodCid WSREST Health

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oCid			:= &cJsonObj
Local cBranchVld	:= ""
Local cBrchTMR		:= ""
Local cJson			:= ""
Local cQuery		:= ""
Local cToken		:= ""
Local cDesCID		:= ""
Local cFilter		:= "%%"
Local nX            := 0
Local nRegCount     := 0
Local nRegIniCount  := 0 
Local nRegFimCount  := 0 
Local nDesc  		:= 0
Local lMaisPaginas	:= .F.
Local aItens		:= {}
Local lContinua		:= AliasInDic("TMR")

DEFAULT Self:filter		:= ""
DEFAULT Self:page		:= ""
DEFAULT Self:pageSize	:= ""

Self:SetHeader('Access-Control-Allow-Credentials' , "true")
	
cToken  	:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)

If lContinua .And. !Empty( cBranchVld )

	dbSelectArea("TMR") //Alimentar a tabela CID - autocontida do TAF

	//Faz o controle de paginacao
	If Self:page == "1" .Or. Self:page == ""
	 	nRegIniCount := 1 
		nRegFimCount := If( Empty( Val(Self:pageSize) ), 20, Val(Self:pageSize) )
	Else
		nRegIniCount := ( Val(Self:pageSize) * ( Val(Self:page) - 1 ) ) + 1
		nRegFimCount := ( nRegIniCount + Val(Self:pageSize) ) - 1
	EndIf

	//Aplica filtro caso seja informado
	If !Empty(Self:filter)
		cFilter := "% TMR_CID LIKE '%" + Self:filter + "%' AND %"
	EndIf	
	
	cBrchTMR	:= xFilial("TMR", cBranchVld)
	cQuery 		:= GetNextAlias()
	
	BEGINSQL ALIAS cQuery
	
		SELECT TMR_FILIAL, TMR_CID, TMR_DOENCA
		FROM
			%Table:TMR% TMR
		WHERE
			TMR.TMR_FILIAL = %Exp:cBrchTMR% AND
			TMR.TMR_DOENCA <> '' AND
			%Exp:cFilter%
			TMR.%NotDel%
		ORDER BY 1, 2
	ENDSQL

	While !(cQuery)->(Eof()) 
		nRegCount ++
		
		nDesc	:= Len( AllTrim((cQuery)->TMR_DOENCA))
		cDesCID := SubStr((cQuery)->TMR_DOENCA, 1, 30) + If( nDesc > 30, "...", "")

		If ( nRegCount >= nRegIniCount .And. nRegCount <= nRegFimCount )
			oCid 			:= &cJsonObj 
			oCid["id"]		:= AllTrim( (cQuery)->TMR_CID )
			oCid["name"]	:= EncodeUTF8( cDesCID )
			aAdd(aItens, oCid)
		Else
			If nRegCount >= nRegFimCount
				lMaisPaginas := .T.
				Exit
			EndIf		
		EndIf

		(cQuery)->(dbSkip()) 
	EndDo
	
	(cQuery)->( DBCloseArea() )

	oItem["items"] 	  := aItens
	oItem["hasNext"]  := lMaisPaginas
	
	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	Self:SetResponse(cJson)

EndIf

Return(.T.)


// -------------------------------------------------------------------
//"Retorna os registros de atestados com status pendentes"
// -------------------------------------------------------------------
WSMETHOD GET fByIdMed WSREST Health

Local cJsonObj	:= "JsonObject():New()"
Local oData		:= &cJsonObj
Local aUrlParam	:= Self:aUrlParms
Local nLenParms	:= Len(aUrlParam)
Local cJson		:= ""
Local cFilRH3	:= ""
Local cCodRH3	:= ""	

Self:SetHeader('Access-Control-Allow-Credentials' , "true")
	
cToken		:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)
cMatSRA		:= GetRegisterHR(cToken)

If nLenParms == 3 .And. !Empty(aUrlParam[3])
	cFilRH3		:= SubStr( aUrlParam[3], 1, TamSX3("RA_FILIAL")[1] )
	cCodRH3		:= SubStr( aUrlParam[3], Len(cFilRH3)+1 )	
EndIf

If !Empty(cBranchVld) .And. !Empty(cMatSRA)
	oData := fGetRegsMedical( 4, cBranchVld, cMatSRA, cCodRH3 ) 
EndIf

cJson := FWJsonSerialize(oData, .F., .F., .T.)
Self:SetResponse(cJson)

Return(.T.)


// -------------------------------------------------------------------
//"Cria um registo de atestado"
// -------------------------------------------------------------------
WSMETHOD POST fSetMedCertificate WSREST Health

Local cJsonObj		:= "JsonObject():New()"
Local oItem        	:= &cJsonObj
Local cBody			:= Self:GetContent()
Local cBranchVld 	:= ""
Local cMatSRA		:= ""
Local cToken    	:= ""
Local cErro			:= ""
Local cJson	    	:= ""
Local lRet			:= .F.

Self:SetHeader('Access-Control-Allow-Credentials' , "true")
	
cToken  	:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)
cMatSRA		:= GetRegisterHR(cToken)

If !Empty(cBody)
	
	lRet := fGrvMedCertificate( .T., cBranchVld, cMatSRA, cBody, @oItem, @cErro )
	
	If lRet
		cJson := FWJsonSerialize(oItem, .F., .F., .T.)
		Self:SetResponse(cJson)
	Else
		SetRestFault(500, cErro, .T.)		
	EndIf

EndIf

Return( lRet )


// -------------------------------------------------------------------
//"Atualiza um registo de atestado"
// -------------------------------------------------------------------
WSMETHOD PUT fPutMedCertificate WSREST Health

Local cJsonObj		:= "JsonObject():New()"
Local oItem        	:= &cJsonObj
Local cBody			:= Self:GetContent()
Local cBranchVld 	:= ""
Local cMatSRA		:= ""
Local cToken    	:= ""
Local cErro			:= ""
Local cJson	    	:= ""
Local lRet			:= .F.

Self:SetHeader('Access-Control-Allow-Credentials' , "true")
	
cToken  	:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)
cMatSRA		:= GetRegisterHR(cToken)

If !Empty(cBody)
	
	lRet := fGrvMedCertificate( .F., cBranchVld, cMatSRA, cBody, @oItem, @cErro )
	
	If lRet
		cJson := FWJsonSerialize(oItem, .F., .F., .T.)
		Self:SetResponse(cJson)
	Else
		SetRestFault(500, cErro, .T.)
	EndIf

EndIf

Return( lRet )


// -------------------------------------------------------------------
//"Exclui um registo de atestado"
// -------------------------------------------------------------------
WSMETHOD DELETE fDelMedCertificate WSREST Health

Local cJsonObj		:= "JsonObject():New()"
Local oRet      	:= &cJsonObj
Local aUrlParam		:= Self:aUrlParms
Local nLenParms		:= Len(aUrlParam)
Local cFilRH3    	:= ""
Local cCodRH3    	:= ""
Local cJson	    	:= ""
Local lRet			:= .F.

Self:SetHeader('Access-Control-Allow-Credentials' , "true")
	
If nLenParms == 3 .And. !Empty(aUrlParam[3])
	cFilRH3		:= SubStr( aUrlParam[3], 1, TamSX3("RA_FILIAL")[1] )
	cCodRH3		:= SubStr( aUrlParam[3], Len(cFilRH3)+1 )
	
	Begin Transaction
		DbSelectArea("RH3")
		If RH3->( dbSeek( cFilRH3 + cCodRH3 ) ) .And. RH3->RH3_STATUS == '4'
             RecLock( "RH3", .F. )
             RH3->( dbDelete() )
             RH3->( MsUnlock() )

             DbSelectArea("RH4")
             If RH4->( dbSeek( cFilRH3 + cCodRH3 ) )
	             While RH4->(!Eof())
	             	If RH4->RH4_CODIGO == cCodRH3
			            RecLock( "RH4", .F. )
			            RH4->( dbDelete() )
			            RH4->( MsUnlock() )	             
		            EndIf
		            RH4->( dbSkip() )
	             EndDo
             EndIf
             lRet := .T.
		EndIf
	End Transaction

EndIf

If lRet
	//Exclusao efetuada com sucesso
   	HttpSetStatus(204)
Else	
	HttpSetStatus(500)
   	oRet["code"]	:= "500"
   	oRet["message"]	:= EncodeUTF8(STR0039) //"A exclusão não pode ser efetuada."

	cJson :=  FWJsonSerialize( oRet, .F., .F., .T.)
	Self:SetResponse(cJson)   	
EndIf     

Return( lRet )


/*/{Protheus.doc} fSetFileImg()
- Responsável por gravar a imagem do atestado no Repositorio de Imagens
@author:	Marcelo Silveira
@since:		17/05/2019
@param:		cFileContent - Conteudo codificado da imagem
			cNameArq - Nome do arquivo para o repositorio de imagens
			cFileType - Extensao do arquivo
			cError - Erros durante a criacao do arquivo (referencia)			
@return:	lRet - Imagem criada no servidor ou atualizada no repositorio de imagens
/*/
Function fSetFileImg( cFileContent, cNameArq, cFileType, cError )

Local nHandle	 	
Local oObjImg
Local lRet		:= .F.
Local cNameFile	:= ""
Local cTextAux	:= ""
Local cArqTemp 	:= GetSrvProfString ("STARTPATH","")	

DEFAULT cFileContent	:= ""
DEFAULT cNameArq		:= ""
DEFAULT cFileType		:= ""
DEFAULT cError			:= ""

cArqTemp 	+= (cNameArq +"."+ cFileType)
cTextAux	:= Decode64( cFileContent )

If !File( cArqTemp )

	//Cria o arquivo temporario da imagem recebida pela requisicao
	nHandle := FCREATE( cArqTemp )

	If nHandle == -1
		cError := EncodeUTF8(STR0025) + AllTrim(Str(Ferror())) //"Erro ao criar o arquivo temporário da imagem: "
	Else
	    FWrite(nHandle, cTextAux )
	    FClose(nHandle)
	
		//Instancia o objeto da imagem
		oObjImg := FwBmpRep():New() 
		
		//Exclui caso a imagem ja exista no repositorio
		If oObjImg:ExistBmp(cNameArq)  
			oObjImg:DeleteBmp(cNameArq) 
		EndIf
		
		//Adiciona a imagem no repositorio (sem a extensao)
		oObjImg:InsertBmp( cArqTemp, cNameArq, @lRet ) 
	
		If lRet
			Ferase(cArqTemp) //Elimina o arquivo temporario
		Else
			cError := EncodeUTF8(STR0029) //"Ocorreu um erro durante a gravação no repositório de imagens. Tente novamente e se o problema persistir contate o administrador do sistema"
		EndIf
	EndIf
	
EndIf

Return( lRet )


/*/{Protheus.doc} fGetImgMedical()
- Responsável por extrair a imagem do atestado no Repositorio de Imagens e salvar em disco local
@author:	Marcelo Silveira
@since:		17/05/2019
@param:		lTCFA040 - Indica a origem da chamada (Atender requisicao ou Afastamento) 
			cInfoFile - Se a origem for afastamento traz a view da GPEA240, caso contrario traz o nome do arquivo 
/*/
Function fGetImgMedical( lTCFA040, cInfoFile )

Local cImg			:= ""
Local cBmpPict		:= ""
Local cErro			:= ""
Local cCpoNumId		:= ""
Local cNomeFile		:= ""
Local cCodMat		:= ""
Local cPathPict		:= GetSrvProfString ("STARTPATH","")
Local lContinua		:= .T.
Local lExist		:= .F.
Local oObjImg 		
Local oBmp
Local oScroll
Local oButton1
Local oButton2
Local nHandle

DEFAULT lTCFA040	:= .T.
DEFAULT cInfoFile	:= ""	//Nome do arquivo no repositorio de imagens

If !lTCFA040
	//Quando a chamada ocorre na rotina Afastamentos no segundo parametro tera a View da SR8
	//Entao o nome do arquivo sera composto pela filial e os 5 ultimos numeros do campo R8_NUMID
 	cCpoNumId := AllTrim( cInfoFile:GetValue("GPEA240_SR8","R8_NUMID") )
 	cCodMat	  := cInfoFile:GetValue("GPEA240_SR8","R8_MAT")
 	
	If ( "_" $ cCpoNumId )
		cNomeFile := cInfoFile:GetValue("GPEA240_SR8","R8_FILIAL") +"_"+ SubStr( cCpoNumId, Len(cCpoNumId)-4, 5 )
	Else
		lContinua := .F.
		MsgInfo( STR0026 ) //"Este registro não possui a imagem do atestado médico."
	EndIf
Else
	If RH3->(ColumnPos("RH3_BITMAP")) .And. !Empty( RH3->RH3_BITMAP )
		cNomeFile := RH3->RH3_FILIAL +"_"+ RH3->RH3_CODIGO
		cCodMat	  := RH3->RH3_MAT
	Else
		lContinua := .F.
		MsgInfo( STR0026 ) //"Este registro não possui a imagem do atestado médico."
	EndIf
EndIf

If lContinua .And. !Empty( cBmpPict := Upper( AllTrim( cNomeFile ) ) )

	//Instancia o objeto da imagem	
	oObjImg := FwBmpRep():New()
	
	//Extrai o arquivo
	oObjImg:Extract( cBmpPict, cPathPict+cBmpPict )
	
	Do Case
		Case File( (cImg := cPathPict+cBmpPict) + ".jpg" )
			cImg 	+=  ".jpg"
			lExist 	:= .T.
		Case File( (cImg := cPathPict+cBmpPict) + ".bmp" )
			cImg 	+= ".bmp"
			lExist 	:= .T.
	End Case	
	
	If lExist
	
		DEFINE DIALOG oDlg TITLE STR0032 FROM 0,0 TO 600,800 PIXEL //"Atestado Médico"

			@ 0,0 MSPANEL oPanelMenu RAISED SIZE 90,1 OF oDlg
			oPanelMenu:align := CONTROL_ALIGN_RIGHT

			@ 0,0 SCROLLBOX oScroll HORIZONTAL VERTICAL SIZE 10, 10 OF oDlg
				oScroll:align := CONTROL_ALIGN_ALLCLIENT
	
			@ 10,320 BUTTON oButton1 PROMPT STR0033 ;	//"Salvar em disco"
			ACTION ( fImgDownload(cImg,cCodMat)) SIZE 70,15 OF oDlg  PIXEL	

			@ 30,320 BUTTON oButton2 PROMPT STR0034 ;	//"Fechar"
				ACTION (oDlg:End()) SIZE 70,15 OF oDlg  PIXEL
				
			// Carrega a imagem do atestado
			@ 0,0 BITMAP oBmp  File(cImg) SCROLL OF oScroll PIXEL
			
			oBmp:lAutoSize := .T.
		
		ACTIVATE DIALOG oDlg CENTER

		//Exclui a imagem temporaria do servidor
		If File(cImg)
			Ferase(cImg)
		EndIf
	Else
		MsgStop( STR0031, STR0030 ) //"A imagem não foi localizada no repositório de imagens. Contate o administrador do sistema."#"Imagem não localizada"
	EndIf

EndIf

Return()


/*/{Protheus.doc} fImgDownload()
- Responsável por transferir a imagem temporaria do server para o disco local
@author:	Marcelo Silveira
@since:		17/05/2019
@param:		cArqImg - arquivo da imagem
/*/
Static Function fImgDownload( cArqImg, cCodMat )

Local lPutOk	:= .F.
Local lContinua	:= .T.
Local cArqRep	:= ""
Local cOldFile	:= ""
Local cNewStr	:= ""
Local cNewFile	:= ""
Local cPathPict := ""

//Deve ser selecionada uma pasta da unidade local
While lContinua
	cPathPict := cGetFile( 'JPG|*.jpg|BMP|*.bmp' , STR0027, 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.F., .F. ) //"Selecione o destino do arquivo"
	If (lContinua := Len(cPathPict) > 0 .And. Len(cPathPict) <= 3)
		MsgStop( STR0035 ) //"Selecione uma pasta de sua unidade de disco local."
	EndIf
End

If !Empty( cPathPict ) 

	cNome := FDesc("SRA", cCodMat, "RA_NOME", ,xFilial("SRA"), 1)
	
	If CpyS2T( cArqImg, cPathPict )
		
		//Altera o nome do arquivo adicionando o nome do funcionario para facilitar a identificacao
		cOldFile := cPathPict + RetFileName(cArqImg) + SubStr(cArqImg, Len(cArqImg)-3, 4) 
		cNewStr  := RetFileName(cArqImg) + " - " + AllTrim(cNome)
		cNewFile := STRTRAN( cOldFile, RetFileName(cArqImg), cNewStr )

		//Exclui caso exista arquivo com o mesmo nome no destino
		If File(cNewFile)
			Ferase(cNewFile)
		EndIf		
		
		Frename( cOldFile, cNewFile )

		MsgInfo( STR0028 ) //"A imagem foi transferida com sucesso!"
			
	EndIf
	
EndIf

Return()


/*/{Protheus.doc} GetMedCertification
Verifica se ja existe abono cadastrado para o dia o funcionario no dia/hora informado
@author:	Marcelo Silveira
@since:		21/05/2019
@param:		cFilSra - Filial;
			cMatSra - Matrícula;
			cDtSolic - Data da solicitacao (considera a partir da data inicial da competencia da folha);
			cAfas - Codigo do afastamento
			cInitDate - Data inicial do atestado;
			cEndDate - Data final do atestado;
@return:	lRet - Se não localizar nenhum registro retorna verdadeiro			
/*/
Static Function GetMedCertification( cFilSra, cMatSra, cDtSolic, cAfas, cInitDate, cEndDate )

Local cQryRH3  	:= GetNextAlias()
Local cQryRH4 	:= GetNextAlias()
Local lRet 	   	:= .T.
Local cCodAfas	:= ""
Local cCpoRH4	:= ""
Local cValRH4	:= ""
Local dDataIni	:= cTod("//")
Local dDataFim	:= cTod("//")

cDtSolic := "% '" + cDtSolic + "' %"

BeginSql alias cQryRH3
	SELECT RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH3.RH3_STATUS
	FROM  %table:RH3% RH3 
	WHERE
		RH3.RH3_FILIAL = %exp:cFilSra% AND
		RH3.RH3_MAT = %exp:cMatSra% AND
		RH3.RH3_DTSOLI >= %Exp:cDtSolic% AND
    	RH3.RH3_TIPO = 'R' AND
		RH3.%notDel% 
EndSql

While !(cQryRH3)->(Eof())

	BeginSql alias cQryRH4
		SELECT *
		FROM  %table:RH4% RH4
		WHERE 	
			RH4.RH4_CODIGO = %exp:(cQryRH3)->RH3_CODIGO% AND
			(RH4.RH4_CAMPO = "R8_TIPOAFA" OR
			 RH4.RH4_CAMPO = "R8_DATAINI" OR
			 RH4.RH4_CAMPO = "R8_DATAFIM" ) AND
			 RH4.%notDel%
	EndSql

	cCodAfas := ""
	dDataIni := cTod("//")
	dDataFim := cTod("//")

	While !(cQryRH4)->(Eof())
		cCpoRH4 := AllTrim( (cQryRH4)->RH4_CAMPO )
		cValRH4 := AllTrim( (cQryRH4)->RH4_VALNOV )

		If cCpoRH4 == "R8_TIPOAFA"
			cCodAfas := cValRH4
		EndIf
		If cCpoRH4 == "R8_DATAINI"
			dDataIni := CTOD( cValRH4 )
		EndIf
		If cCpoRH4 == "R8_DATAFIM"
			dDataFim := CTOD( cValRH4 )
		EndIf

		(cQryRH4)->(DBSkip())
	Enddo
	
	If cAfas == cCodAfas .And. ( ; 
		( cInitDate == dDataIni .Or. cInitDate == dDataFim ) .Or. ;
		( cEndDate == dDataIni .Or. cEndDate == dDataFim ) .Or. ;
		( cInitDate >= dDataIni .And. cInitDate <= dDataFim ) .Or. ;
		( cEndDate >= dDataIni .And. cEndDate <= dDataFim ) )
		lRet := .F.
		(cQryRH4)->(DBCloseArea())
		Exit
	EndIf
	(cQryRH4)->(DBCloseArea())
		 
	(cQryRH3)->(DBSkip())
Enddo

(cQryRH3)->(DBCloseArea())

Return(lRet)


/*/{Protheus.doc} fGetRegsMedical
Carrega as solicitacoes de atestado do funcionario conforme os parametros
@author:	Marcelo Silveira
@since:		22/05/2019
@param:		nType - 1=Solicitacoes com status pendentes, 2=demais status diferente de pendente, 3=Todos;
			cFilSra - Filial;
			cMatSra - Matrícula;
			cCodReq - Codigo da requisicao;
			cPage - Numero da pagina;
			cPageSize - Numero de registros;
			lNextPage - Indica se existe ou nao mais registros;
@return:	aFields - array com o json das solicitacoes			
/*/
Static Function fGetRegsMedical( nType, cBranchVld, cMatSRA, cCodReq, cPage, cPageSize, lNextPage  )

Local cJsonObj     	:= "JsonObject():New()"
Local oItem        	:= &cJsonObj
Local oFields      	:= &cJsonObj
Local oType      	:= &cJsonObj
Local oFile      	:= &cJsonObj
Local aArea        	:= {}
Local aPerAtual		:= {}
Local aFields      	:= {}
Local aType      	:= {}
Local nRegCount     := 0
Local nRegIniCount  := 0 
Local nRegFimCount  := 0
Local cDataIni		:= ""
Local cBegin		:= ""
Local cEnd			:= ""
Local cCid			:= ""
Local cType			:= ""
Local cDescType		:= ""
Local cQryRH3		:= ""
Local cQryRH4		:= ""
Local cFilRH3		:= ""
Local cCodRH3		:= ""
Local cStatus		:= ""
Local cRejec		:= ""
Local cNameArq		:= ""
Local cFileType		:= ""
Local cMsg			:= ""
Local cRet			:= ""
Local cRotFOL		:= ""
Local cJustify		:= ""
Local cMotivo		:= ""
Local cWhere 		:= "%"
Local cCpoRH3		:= If( RH3->(ColumnPos("RH3_BITMAP")) > 0, "%, RH3_BITMAP %", "%%" )
Local lContinua		:= .T.
Local lCount		:= .F.

DEFAULT	cCodReq		:= ""
DEFAULT cPage		:= ""
DEFAULT cPageSize	:= ""
DEFAULT lNextPage	:= .F.

//----------------------------------------------------------
//Deve existir calendario para a folha de pagamento e apresentar 
//somente os atestados solicitados a partir dessa competencia
//----------------------------------------------------------
aArea := GetArea()
DbSelectArea("SRA")
If SRA->( dbSeek( cBranchVld + cMatSRA ) )
	
	cRotFOL := fGetRotOrdinar() //Roteiro da folha
	
	fGetPerAtual( @aPerAtual, xFilial("RCH", cBranchVld), SRA->RA_PROCES, cRotFOL )
	
	If Len( aPerAtual ) > 0 
		cDataIni := "% '" + dToS(aPerAtual[1,6]) + "' %"
	Else
		lContinua := .F. 
	EndIf		
EndIf
RestArea( aArea )

If lContinua .Or. (nType == 4)

	//Faz o controle de paginacao
	If !Empty(cPage) .And. !Empty(cPageSize)
		If cPage == "1" .Or. cPage == ""
		 	nRegIniCount := 1 
			nRegFimCount := If( Empty( Val(cPageSize) ), 20, Val(cPageSize) )
		Else
			nRegIniCount := ( Val(cPageSize) * ( Val(cPage) - 1 ) ) + 1
			nRegFimCount := ( nRegIniCount + Val(cPageSize) ) - 1
		EndIf
		lCount := .T.
	EndIf
	
	cQryRH3 := GetNextAlias()

	//--------------------------------------------
	//1 = Atestados Pendentes de aprovacao (GET)
	//2 = Atestados Aprovados ou Reprovados (GET)
	//3 = Todos os Atestados (GET)
	//4 = O registro de um codigo especifico (PUT - Atualizacao) 
	//--------------------------------------------
	If nType == 1 
		cWhere += " RH3.RH3_STATUS = '4' AND "	
	ElseIf nType == 2
		cWhere += " RH3.RH3_STATUS NOT IN ('4') AND "
	ElseIf nType == 4
		cWhere += " RH3.RH3_CODIGO = '" + cCodReq + "' AND " 
	EndIf
	cWhere += "%"

	BEGINSQL ALIAS cQryRH3
	
		SELECT RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_STATUS, RH3_DTSOLI, RH3_DTATEN, RA_PROCES %Exp:cCpoRH3% 
		FROM %Table:RH3% RH3
		INNER JOIN %Table:SRA% SRA ON
			RH3_FILIAL = RA_FILIAL AND
			RH3_MAT = RA_MAT		
		WHERE
			RH3.RH3_TIPO='R' AND
			RH3.RH3_FILIAL=%Exp:cBranchVld% AND RH3.RH3_MAT=%Exp:cMatSRA% AND
			RH3.RH3_DTSOLI >= %Exp:cDataIni% AND
			%Exp:cWhere% 
			RH3.%NotDel%
	ENDSQL

	While !(cQryRH3)->(Eof()) 

		cFilRH3		:= (cQryRH3)->RH3_FILIAL 
		cCodRH3 	:= (cQryRH3)->RH3_CODIGO
		cStatus		:= If( (cQryRH3)->RH3_STATUS=='2', "approved", If((cQryRH3)->RH3_STATUS=='3', 'rejected', 'pending') )
		aType		:= {}

		cQryRH4 := GetNextAlias()
		
		BEGINSQL ALIAS cQryRH4
		
			SELECT RH4_FILIAL, RH4_CODIGO, RH4_CAMPO, RH4_VALNOV
			FROM %Table:RH4% RH4
			WHERE
				RH4.RH4_FILIAL = %Exp:cFilRH3% AND RH4.RH4_CODIGO=%Exp:cCodRH3% AND 
				RH4.%NotDel%
	
		ENDSQL

		While (cQryRH4)->(!Eof()) 
		
			cCpoRH4 := AllTrim((cQryRH4)->RH4_CAMPO)		
			
			DO CASE
				CASE cCpoRH4 == "R8_DATAINI"
					cBegin		:= formatGMT(Alltrim((cQryRH4)->RH4_VALNOV))			
				CASE cCpoRH4 == "R8_DATAFIM"
					If Alltrim((cQryRH4)->RH4_VALNOV) == "/  /"
						cEnd := cTod("//")
					Else
						cEnd := formatGMT(Alltrim((cQryRH4)->RH4_VALNOV))
					EndIf
				CASE cCpoRH4 == "R8_CID"
					cCid		:= Alltrim((cQryRH4)->RH4_VALNOV)
				CASE cCpoRH4 == "R8_TIPOAFA"
					cMotivo		:= Alltrim((cQryRH4)->RH4_VALNOV)
				CASE cCpoRH4 == "TMP_MOTIVO"
					cType		:= Alltrim((cQryRH4)->RH4_VALNOV)
				CASE cCpoRH4 == "TMP_OBS"					
					cJustify	:= Alltrim((cQryRH4)->RH4_VALNOV)
			ENDCASE			
		 	
 			(cQryRH4)->(DbSkip())
		EndDo

		(cQryRH4)->( DBCloseArea() )

		If nType == 4
			//-------------------------
			//Obtem os dados da imagem
			cRet := fMedImg( 1, cFilRH3, cCodRH3, @cNameArq, @cFileType, @cMsg )
			oFile      			:= &cJsonObj
			oFile["content"] 	:= cRet
			oFile["type"]    	:= cFileType 	
			oFile["name"]    	:= cNameArq
			//-------------------------
			
			oFields 			:= &cJsonObj 
			oFields["id"]		:= cFilRH3 + cCodRH3
			oFields["type"]		:= cType
			oFields["begin"]	:= cBegin			
			oFields["end"]		:= cEnd		
			oFields["cid"]		:= cCid	
			oFields["justify"]	:= EncodeUTF8(cJustify)
			oFields["reason"]	:= EncodeUTF8(cMotivo)		
			oFields["file"]		:= oFile
			
			aFields := oFields

		Else
			nRegCount ++
			
			If !lCount .Or. ( nRegCount >= nRegIniCount .And. nRegCount <= nRegFimCount )
				oType				:= &cJsonObj 
				oType["id"] 		:= cMotivo 
				oType["name"] 		:= EncodeUTF8( cType )			
			
				oFields 			:= &cJsonObj 
				oFields["id"]		:= cFilRH3 + cCodRH3
				oFields["status"]	:= cStatus
				oFields["type"]		:= oType
				oFields["begin"]	:= cBegin			
				oFields["end"]		:= cEnd		
				oFields["sent"]		:= formatGMT( cValToChar( StoD((cQryRH3)->RH3_DTSOLI) ) )	
				oFields["cid"]		:= cCid	
				If (cQryRH3)->RH3_STATUS == '3'
					cRejec	:= getRGKJustify( cFilRH3, cCodRH3  ) 
					oFields["rejectionJustify"]	:= AllTrim(cRejec)
				EndIf
				oFields["canEdit"]	:= (cQryRH3)->RH3_STATUS $ '3/4'
				oFields["canDelete"]:= (cQryRH3)->RH3_STATUS == '4'
	
				Aadd(aFields,oFields)
			Else
				If nRegCount >= nRegFimCount
					lNextPage := .T.
					Exit
				EndIf				
			EndIf

		EndIf		

		aType := {}		

		(cQryRH3)->(dbSkip()) 
	EndDo
	
	(cQryRH3)->( DBCloseArea() )

EndIf

Return( aFields )


/*/{Protheus.doc} fMedImg
Carrega as informacoes e/ou faz o download do imagem do atestado medico
@author:	Marcelo Silveira
@since:		23/05/2019
@param:		nType - 1=Dados do arquivo, 2=arquivo para download;
			cFilRH3 - Filial da requisicao;
			cCodRH3 - Codigo da requisicao;
			cNameArq - Nome do arquivo gerado;
			cType - Extensao do arquivo;
			cMsg - Erros ocorridos na extracao da imagem;
@return:	cReturn - Conteudo do arquivo			
/*/
Static Function fMedImg( nType, cFilRH3, cCodRH3, cNameArq, cType, cMsg )

Local oFile
Local aArea			:= {}
Local cArqTemp		:= ""
Local cImg			:= ""
Local cPathPict		:= ""
Local cRet			:= ""
Local lContinua		:= .T.

DEFAULT cFilRH3		:= ""
DEFAULT cCodRH3		:= ""
DEFAULT cNameArq	:= ""
DEFAULT cType		:= ""
DEFAULT cMsg		:= ""

If !Empty(cFilRH3) .And. !Empty(cCodRH3)

	cArqTemp	:= cFilRH3 +"_"+ cCodRH3
	cPathPict	:= GetSrvProfString ("STARTPATH","")
	
	aArea := GetArea()
	DbSelectArea("RH3")
	DbSetOrder(1)
	If RH3->(ColumnPos("RH3_BITMAP")) > 0 .And. RH3->( dbSeek( cFilRH3 + cCodRH3 ) )
		lContinua := !Empty( RH3->RH3_BITMAP )
	Else
		lContinua := .F.
	EndIf
	RestArea( aArea )	
	
	If lContinua
	
		//Cria o objeto da imagem	
		oObjImg := FwBmpRep():New()
		
		//Extrai a imagem para a pasta system
		oObjImg:Extract( cArqTemp, cPathPict+cArqTemp )
		
		If File( (cImg := cPathPict+cArqTemp) + ".jpg" )
	
			cType := "jpg"
			cImg  +=  "." + cType
			oFile := FwFileReader():New(cImg)
	
    		If (oFile:Open())
		    	cRet := oFile:FullRead()
		        oFile:Close()		    		

		        If nType == 1
					//Retorna informacoes do arquivo
		        	cNameArq := cArqTemp
		        	cRet     := Encode64(cRet)
		        Else
					//Retorna o arquivo para download
		        	cNameArq := cImg
		        EndIf    		
    		EndIf
	        
	        Ferase(cImg)
	    Else
	    	cMsg := EncodeUTF8( STR0031 ) //"A imagem não foi localizada no repositório de imagens. Contate o administrador do sistema."
		EndIf
	Else
		cMsg := EncodeUTF8( STR0026 ) //"Este registro não possui a imagem do atestado médico."
	EndIf

EndIf 

Return( cRet )


/*/{Protheus.doc} formatGMT
Formata a hora para o formato json
@author:	Marcelo Silveira
@since:		23/05/2019
@param:		cValue - Data em formato caractere para conversao;
@return:	cReturn - data no formato GMT			
/*/
Static Function formatGMT(cValue)

Local cDateFormat	:= ""
Local cReturn		:= ""
Local aDateFormat	:= {}

Default cValue	:= ""

cDateFormat := DTOS(CTOD(Alltrim(cValue)))
aDateFormat := LocalToUTC( cDateFormat, "12:00:00" )

cReturn := Iif(Empty(aDateFormat),"",Substr(aDateFormat[1],1,4) + "-" + Substr(aDateFormat[1],5,2) + "-" + Substr(aDateFormat[1],7,2) + "T" + "12:00:00" + "Z")

Return( cReturn )


/*/{Protheus.doc} fGrvMedCertificate
Efetua a inclusao ou a alteracao de uma solicitacao de atestado medico
@author:	Marcelo Silveira
@since:		27/05/2019
@param:		lNewReg - Indica se e inclusao (.T.) ou alteracao (.F.)
			cBranchVld - Filial;
			cMatSRA - Matrícula;
			cBody - Json com o corpo da requisicao;
			oItemDetail - Objeto Json com o corpo da requisicao;
			cError - Erros durante a criacao do arquivo (referencia)
@return:	lRet - Verdadeiro se o registro foi incluido ou alterado com sucesso			
/*/
Static Function fGrvMedCertificate( lNewReg, cBranchVld, cMatSRA, cBody, oItemDetail, cErro )

Local cJsonObj		:= "JsonObject():New()"
Local cFilRH3		:= ""
Local cCid			:= ""
Local cCodAfas		:= ""
Local cDtIniSolic	:= ""
Local cDataIni		:= ""
Local cDataFim		:= ""
Local cDescAfas		:= ""
Local cJson	    	:= ""
Local cAnoMes		:= ""
Local cMotEsoc		:= ""
Local cJustify		:= ""
Local cNomeFun		:= ""
Local cVerba		:= ""
Local cId    		:= ""
Local cToken    	:= ""
Local cQuery		:= ""
Local cNameArq		:= ""
Local cRotFOL		:= ""
Local cCodRH3		:= 0
Local nCount		:= 0
Local nDays			:= 0
Local nItem			:= 0
Local nSaveSX8		:= GetSX8Len()
Local aArea 	    := {}
Local aCpos 	    := {}
Local aPerAtual	    := {}
Local lContinua		:= .T.
Local lExistImg		:= .F.
Local lRet			:= .T.
Local lRec			:= .F.

Default cBody		:= ""
Default lNewReg		:= .T.
Default oItemDetail	:= &cJsonObj

If !Empty(cBody)

	oItemDetail:FromJson(cBody)
	
	cId			:= Iif(oItemDetail:hasProperty("id"),oItemDetail["id"]," ")
	cCodAfas	:= Iif(oItemDetail:hasProperty("reason"),oItemDetail["reason"]," ")
	cDataIni	:= Iif(oItemDetail:hasProperty("begin"),CTOD(Format8601(.T.,oItemDetail["begin"])), CTOD("//"))
	cDataFim	:= Iif(oItemDetail:hasProperty("end"),CTOD(Format8601(.T.,oItemDetail["end"])), CTOD("//"))
	cCid   		:= Iif(oItemDetail:hasProperty("cid"),oItemDetail["cid"]," ")
	cJustify	:= Iif(oItemDetail:hasProperty("justify"),oItemDetail["justify"]," ")
	cFileTipe	:= Iif(oItemDetail:hasProperty("file"),oItemDetail["file"]["type"]," ")
	cFileContent:= Iif(oItemDetail:hasProperty("file"),oItemDetail["file"]["content"]," ")
	nDays		:= Iif( !Empty(cDataFim), (cDataFim - cDataIni + 1), 999)
	aArea 		:= GetArea()

	//----------------------------------------------------------
	//Aceita somente arquivos de imagem validos
	//----------------------------------------------------------
	If (lExistImg := !Empty(cFileTipe)) .And. !(cFileTipe $ ("jpg||bmp"))
		cErro := EncodeUTF8( STR0024 ) //"Anexo inválido. Selecione um arquivo de imagem do tipo JPG ou BMP"
		lContinua := .F.
	EndIf
	
	//----------------------------------------------------------
	//Obtem os dados do Funcionario e do periodo da folha
	//----------------------------------------------------------
	If lContinua
		DbSelectArea("SRA")
		If SRA->( dbSeek( cBranchVld + cMatSRA ) )
			cProc 		:= SRA->RA_PROCES	
			cNomeFun	:= AllTrim(SRA->RA_NOME)
			cRotFOL 	:= fGetRotOrdinar() //Roteiro da folha
			
			fGetPerAtual( @aPerAtual, xFilial("RCH", cBranchVld), SRA->RA_PROCES, cRotFOL )
			
			//----------------------------------------------------------
			//Deve existir calendario para a folha de pagamento e o
			//atestado deve ser cadastrado dentro dessa competencia
			//----------------------------------------------------------
			If Len( aPerAtual ) > 0 
				lContinua := (cDataIni >= aPerAtual[1,6] .And. cDataIni <= aPerAtual[1,7])
				cDtIniSolic := dToS(aPerAtual[1,6])
				cAnoMes	:= aPerAtual[1,5] +"/"+ aPerAtual[1,4]
				cErro := If( lContinua, "", EncodeUTF8(STR0015 + cAnoMes) ) //"O atestado só pode ser incluído na mesma competência da Folha de Pagamento: "
			Else
				cErro := EncodeUTF8(STR0016) //"Ocorreu um erro durante a validação dos dados. Verifique se existe período selecionado para a Folha de Pagamento."
				lContinua := .F. 
			EndIf		
			
		EndIf
	EndIf	
	
	If lContinua

		//Obtem os dados do Tipo de Afastamento
		DbSelectArea("RCM")
		If RCM->( dbSeek( xFilial("RCM", cBranchVld) + cCodAfas ) )
			cVerba := RCM->RCM_PD		//Verba
			cDescAfas := AllTrim(RCM->RCM_DESCRI) 	//Descricao do afastamento
			cMotEsoc := RCM->RCM_TPEFD	//Motivo afastamento eSocial
		Else
			cErro := EncodeUTF8(STR0017 +"("+ cCodAfas +") " + STR0018) //"Ocorreu um erro durante a validação dos dados. Verifique o código: "#"no cadastro Tipos de Afastamento (tabela RCM)."
			lContinua := .F. 
		EndIf
		
	EndIf

	//Verifica se o atestado esta sendo cadastrado em duplicidade
	If lNewReg .And. !GetMedCertification( cBranchVld, cMatSRA, cDtIniSolic, cCodAfas, cDataIni, cDataFim )
		cErro := EncodeUTF8( STR0023 ) //"Ja existe uma solicitacao cadastrada para esse motivo nesta data!"
		lContinua := .F. 
	EndIf	

	If lContinua

		DbSelectArea("RH3")
		If lNewReg
			cFilRH3		:= xFilial("RH3", cBranchVld)
			cCodRH3		:= GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3")) //Reserva o codigo na RH3.
		Else
			cFilRH3 	:= SubStr( cId, 1, TamSX3("RA_FILIAL")[1] )
			cCodRH3 	:= SubStr( cId, TamSX3("RA_FILIAL")[1]+1 )
			If !RH3->(dbSeek( cFilRH3 + cCodRH3 ))
				cErro := EncodeUTF8( "Não foi localizada a solicitacao original: (" + cCodRH3 + "). " + "Contate o administrador do sistema." )
				lContinua := .F.
			EndIf 
		EndIf

		//----------------------------------------------------------
		//Adiciona a imagem no Repositorio de Imagens
		//----------------------------------------------------------
		If lExistImg .And. lContinua 
			cNameArq  := cBranchVld +"_"+ cCodRH3			
			lContinua := fSetFileImg( cFileContent, cNameArq, cFileTipe, @cErro )
		EndIf

		//----------------------------------------------------------
		//Grava a requisicao do Atestado - (RH3)
		//----------------------------------------------------------
		If lContinua

			If !Empty(cCodRH3)

				//Adiciona os campos necessarios para a inclusao do Afastamento
				aAdd( aCpos, { "R8_FILIAL"	, cBranchVld } )
				aAdd( aCpos, { "R8_MAT"		, cMatSRA } )
				aAdd( aCpos, { "TMP_NOME"	, cNomeFun } )
				aAdd( aCpos, { "R8_TIPOAFA"	, cCodAfas } )
				aAdd( aCpos, { "TMP_MOTIVO"	, cDescAfas } )
				aAdd( aCpos, { "R8_PD" 		, cVerba } )
				aAdd( aCpos, { "R8_DATAINI"	, cValToChar(cDataIni) } )
				aAdd( aCpos, { "R8_DATAFIM"	, cValToChar(cDataFim) } )
				aAdd( aCpos, { "R8_DURACAO"	, cValToChar(nDays) } )
				aAdd( aCpos, { "R8_TPEFD"	, cMotEsoc } )
				aAdd( aCpos, { "R8_CID"		, cCid } )		
				aAdd( aCpos, { "R8_NUMID"	, "SR8" + cMatSRA + cVerba + DtoS(cDataIni) +"_"+ cCodRH3 } )
				aAdd( aCpos, { "TMP_OBS"	, DecodeUTF8(cJustify) } )
				
				Begin Transaction
	 
					Reclock("RH3", lNewReg)
					If lNewReg
						RH3->RH3_CODIGO	:= cCodRH3
						RH3->RH3_FILIAL	:= cFilRH3
						RH3->RH3_MAT	:= cMatSRA
						RH3->RH3_TIPO	:= "R"	//Licencas e Afastamentos                                
						RH3->RH3_ORIGEM	:= STR0013 	//"MEURH"
						RH3->RH3_DTSOLI	:= dDataBase
						RH3->RH3_FILINI	:= cBranchVld
						RH3->RH3_MATINI	:= cMatSRA
						RH3->RH3_NVLAPR	:= 99
						RH3->RH3_NVLINI := 1
					EndIf
					RH3->RH3_STATUS	:= "4"	//Aguardando aprovacao do RH
					
					If lExistImg .And. RH3->(ColumnPos("RH3_BITMAP")) > 0
						RH3->RH3_BITMAP := cNameArq 
					EndIf
					
					If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
						RH3->RH3_EMP	:= cEmpAnt
						RH3->RH3_EMPINI	:= cEmpAnt
						RH3->RH3_EMPAPR	:= cEmpAnt
					EndIf
					RH3->(MsUnlock())
			
					//----------------------------------------------------------
					//Grava na inclusao/alteracao o detalhe da requisicao do Atestado - (RH4)
					//----------------------------------------------------------
					DbSelectArea("RH4")					
					For nCount:= 1 To Len(aCpos)
						If !Empty(aCpos[nCount, 2])
							If lNewReg
			                    lRec := .T.
							Else
								lRec := !RH4->( DbSeek(cFilRH3+cCodRH3+AllTrim(STR(nItem+1))) )
							EndIf
			                RecLock( "RH4", lRec )
							RH4->RH4_FILIAL	:= cFilRH3
							RH4->RH4_CODIGO	:= cCodRH3
							RH4->RH4_ITEM	:= ++nItem
							RH4->RH4_CAMPO	:= aCpos[nCount, 1]
							RH4->RH4_VALNOV	:= aCpos[nCount, 2]
			                RH4->(MsUnlock())
						EndIf
					Next
				
				End Transaction
				
			EndIf
			
			//Efetiva a gravação do registro reservado.
			If lNewReg
				If ( GetSx8Len() > nSaveSx8 )
					ConfirmSX8()
				Else
					RollBackSx8()
					cErro := EncodeUTF8(STR0014) //"Ocorreu um erro durante a gravação dos dados. Faça o cadastro novamente e se o problema persistir contate o administrador do sistema"
					lRet := .F.
				EndIf			
			EndIf
		Else
			If lNewReg
				RollBackSx8()
			EndIf
			lRet := .F.
		EndIf

	Else
		lRet := .F.
	EndIf

	FreeObj(oItemDetail)

EndIf

Return( lRet )