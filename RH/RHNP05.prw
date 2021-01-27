#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"

#INCLUDE "RHNP.CH"

STATIC   cMeurhLog := GetConfig("RESTCONFIG","meurhLog", "")

Function RHNP05()
Return .T.


WSRESTFUL Auth DESCRIPTION STR0041 //"Autenticações"

WSDATA userId		As String Optional
WSDATA password	As String Optional

WSMETHOD POST DESCRIPTION "POST"  WSSYNTAX  "/auth/login | /auth/logout'

WSMETHOD GET getLogged ;
 DESCRIPTION STR0049 ; //"Valida token JWT do login" 
 WSSYNTAX "/auth/isLogged" ;
 PATH     "/auth/isLogged" ;
 PRODUCES "application/json;charset=utf-8"

WSMETHOD POST getResetLink ;
 DESCRIPTION STR0050 ; //"Envia link por email para reset senha" 
 WSSYNTAX "/renewPassword" ;
 PATH     "/renewPassword" ;
 PRODUCES "application/json;charset=utf-8"

WSMETHOD PUT editPassword ;
 DESCRIPTION STR0051 ; //"Atualiza a senha do usuario." 
 WSSYNTAX "/resetPassword" ;
 PATH     "/resetPassword" ;
 PRODUCES "application/json;charset=utf-8"

END WSRESTFUL


//********************* Serviços
WSMETHOD POST WSSERVICE Auth

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItemData	 	:= &cJsonObj
Local oItem		 	:= &cJsonObj
Local aMessages		:= {}
Local cBody			:= ""
Local cJson			:= ""
Local lRet			:= .T.
Local oMsgReturn	:= &cJsonObj
Local lSetAccess	:= .F.
Local cRedirect		:= ""
Local aValueCookie  := {}
Local cUser			:= ""
Local cPassword		:= ""
Local nLenParms	 	:= Len(::aURLParms)
Local aRet			:= {}
Local aDataEnv      := {}
Local aDtHr         := {}
Local cMatValid		:= ""
Local cBranchVld	:= ""
Local cToken		:= ""
Local cKey			:= ""
Local cRestPort		:= ""
Local cUserID       := ""
Local cRestFault	:= ""
Local lIsWeb		:= .F.
Local nPos		    := 0
Local cString		:= ""

DEFAULT ::userId 		:= ""
DEFAULT ::password	:= ""

// - Por por padrão todo objeto tem
// - data: contendo a estrutura do JSON
// - messages: para determinados avisos
// - length: informativo sobre o tamanho.

::SetHeader('Access-Control-Allow-Credentials' , "true")


If nLenParms >= 1 .And. Lower(::aURLParms[1]) == "login"

   If cMeurhLog != "0"
      aDtHr := FwTimeUF("SP",,.T.)

      conout("")
      conout(EncodeUTF8(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"    ))
      conout(EncodeUTF8(">>> " +GetVersao()                                    ))
      conout(EncodeUTF8(">>> " +GetBuild()                                     ))
      conout(EncodeUTF8(">>> build dba: " +TCGetBuild() +" - " +TCSrvType()    ))
      
      aDataEnv := GetAPOInfo("aplib050.prw")
      conout(EncodeUTF8(">>> build lib: " +DTos(aDataEnv[4])                   ))

      aDataEnv := GetAPOInfo("rhnp05.prw")
      conout(EncodeUTF8(">>> build mrh: " +DTos(aDataEnv[4])                   ))

      conout(EncodeUTF8(">>> ENV/RPO: " +GetEnvServer() +"/" +GetRPORelease()  ))
      
      conout(EncodeUTF8(">>> "                                                 ))
      conout(EncodeUTF8(">>> MeuRH Autentication"                              ))
   EndIf   

	cBody := Encode64(::GetContent())

	If !Empty(cBody)
	
		// ----------------------------------------------------------------------------------------------
		// - O Front-End envia o corpo da requisição em
		// - FORMDATA, EX: "user=user&password=password&redirectUrl=http://localhost:8084/T1/rest"
		// - E assim decodificamos essa URL para devolver os valores separados;
		// - USER=USER; PASSWORD=PASSWORD; REDIRECTURL=http://localhost:8084/T1/?restPort=9103
		// ----------------------------------------------------------------------------------------------
		aValueCookie := DecodeURL(Decode64(cBody))

		If Len(aValueCookie) >= 3
			cUser 	  := aValueCookie[1]
			cPassword := aValueCookie[2]
			cRedirect := aValueCookie[3]

           // -----------------------------------------------------
           // - Persiste o acesso do usuário - PRTLOGIN WSPORTAL01|
           // -----------------------------------------------------
           UnifiedLoginRH(@lRet,cUser,cPassword,"2","",.T.,,,@cRestFault)
        Else
           lRet       := .F.
           cRestFault := EncodeUTF8(STR0042) //"user/password/redirect não localizados na requisição" 
		EndIf

		
		If lRet
			// ---------------------------------------
			// - Após validar o usuário e senha;
			// - Posiciona na RD0, captura as 
			// - Matrículas que o usuário tem acesso;
			// - E provisóriamente loga com a Primeira
			// ---------------------------------------
			lSetAccess := GetAccessEmployee(cUser, @aRet, lRet)
			
			If lSetAccess
				If Len(aRet) >= 1
					nPos := Ascan(aRet,{|x| !(x[10] $ "30/31")}) 
					If nPos > 0
						cMatValid  := aRet[nPos][1]
						cBranchVld := aRet[nPos][3]
					Else
						cMatValid  := aRet[1][1]
						cBranchVld := aRet[1][3]
					EndIf 
				EndIf

				cKey   := cMatValid+"|"+cUser+"|"+RD0->RD0_CODIGO+"|"+DtoS(dDataBase)+"|"+cBranchVld
				cUserID := GetConfig("RESTCONFIG","userId", "")
				
				If Empty(cUserID) //nova pesquisa em virtude da atualização do appWebWizard
					cUserID := GetConfig("HTTPREST","userId", "")
				EndIf

				//Busca usuario do portal
				If Empty(cUserID)  
					dbSelectArea("AI3")
					AI3->(dbSetOrder(1))
					If AI3->(dbSeek(xFilial("AI3")+RD0->RD0_PORTAL))
						cUserID := UsrRetName(AI3->AI3_USRSIS)
					EndIf
				EndIf

				//Gera token
				If !Empty(cUserID)
					//cToken := FwJWT2Bear(cUserID,{"payments/","payment/","data/","team/", "request/", "timesheet/", "/team/", "setting/"},Date(),Seconds() + Val(GetConfig("RESTCONFIG","RefreshTokenTimeout", 600)),Nil,Nil,{ {"key",cKey} })

					//Retirada a passagem de data e segundos para a funcao FwJWT2Bear por orientacao do Framework - 01/2019
					cToken := FwJWT2Bear(cUserID,{"payments/","payment/","data/","team/", "request/", "timesheet/", "/team/", "setting/"},Nil,Nil,Nil,Nil,{ {"key",cKey} })
				Else
					If cMeurhLog != "0"
						conout(EncodeUTF8(STR0046 + cUser +' - ' + STR0068 )) //">>> usuario nao autenticado: "##"Este usuario nao esta vinculado a um usuario interno do Protheus."
					EndIF

					cRedirect += "auth-error.html"
					oMsgReturn["type"]   := "error"
					oMsgReturn["code"]   := "500"
					oMsgReturn["detail"] := EncodeUTF8(STR0046 + cUser + ' - ' + STR0068) //"Nenhuma matricula localizada para o usuario: "##"Este usuario nao esta vinculado a um usuario interno do Protheus."
				EndIf
				
				cRestPort := GetConfig("RESTCONFIG","restPort", "")
              
				If Empty(cRestPort) //nova pesquisa em virtude da atualização do appWebWizard
					cRestPort := GetConfig("HTTPREST","Port", "")
				EndIf  
				
				If 'restPort' $ cRedirect 
					cRedirect := StrTran( cRedirect, "?restPort", "" )
				Else
					lIsWeb	:= .T.
				EndIf
								
				::SetHeader('Set-Authorization', 'Bearer ' + cToken)
				
				If !Empty(cToken)

					oMsgReturn["type"]   := "success"
					oMsgReturn["code"]   := "200"
					oMsgReturn["detail"] := EncodeUTF8(STR0001) //"Usuário autenticado"

					If cMeurhLog != "0"
						conout(EncodeUTF8(STR0043 +cUser +' - ' +cBranchVld +cMatValid)) //">>> usuario autenticado: "
					EndIf
				Else
					cRedirect += "auth-error.html"
					oMsgReturn["detail"] := EncodeUTF8(STR0047) //"Usuário autenticado, mas token não gerado"
					
					If cMeurhLog != "0"
						conout(EncodeUTF8(STR0048 +cUser +' - ' +cBranchVld +cMatValid)) //">>> token nao gerado: "
					EndIF
				EndIf				

			Else
				cRestFault := EncodeUTF8(STR0044) //"login realizado, mas matricula não localizada!"

				If cMeurhLog != "0"
					conout(EncodeUTF8(STR0044 +cUser))
				EndIF

				cRedirect += "auth-error.html"
				oMsgReturn["type"]   := "error"
				oMsgReturn["code"]   := "500"
				oMsgReturn["detail"] := EncodeUTF8(STR0045 +cUser) //"Nenhuma matricula localizada para o usuario: "
			EndIf
		Else
            If cMeurhLog != "0"
			    conout(EncodeUTF8(STR0046 +cUser +' - ' +cRestFault)) //">>> usuario nao autenticado: "
			EndIF   
	       		
			cRedirect += "auth-error.html"
			oMsgReturn["type"]   := "error"
			oMsgReturn["code"]   := "500"
			oMsgReturn["detail"] := EncodeUTF8(cRestFault)
		EndIf
				
		Aadd(aMessages, oMsgReturn)

		oItem["data"] 		  := oItemData
		oItem["messages"] 	  := aMessages
		oItem["length"]   	  := 1 
	
		If !lIsWeb
			cString   := Right(cRedirect, 1)
			cRedirect := Iif(cString != "/", cRedirect + "/",cRedirect)
		EndIf

   		If lIsWeb
           If "auth-error.html" $ cRedirect
              cJson := '<html><head><title>Moved</title></head><body><script type="text/javascript">window.location="' +cRedirect +'";</script></body></html>'
           Else
              cJson := '<html><head><title>Moved</title></head><body><script type="text/javascript">window.location="'+cRedirect+'?token=' + cToken + '&restPort=' + Alltrim(cRestPort) + '";</script></body></html>'
           EndIf   
	    Else
           If "auth-error.html" $ cRedirect
              cJson := cRedirect
           Else
     			cJson := cRedirect+'?token=' + cToken + '&restPort=' + Alltrim(cRestPort)
     		EndIf	
       EndIf

		::SetResponse(cJson)

       If cMeurhLog != "0"
          	conout(EncodeUTF8(">>> Data/Hora: " +dToC(date()) +Space(1) +Time() ))
          	conout(EncodeUTF8(">>> Dt/Hr tmz: " +aDtHr[1] +"/" +aDtHr[2] ))
          	conout(EncodeUTF8(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"  ))
          	conout("")
		EndIF   	
	EndIf
ElseIf nLenParms >= 1 .And. ::aURLParms[1] == "logout"

	// ---------------------------------
	// - Elimina o Bearer authorization
	// ---------------------------------
	oItemData["redirect"] := "logout.html"
	::SetHeader('Set-Authorization', '=')
	
	oMsgReturn["type"]   := "success"
	oMsgReturn["code"]   := "200"
	oMsgReturn["detail"] := EncodeUTF8(STR0002) //"Usuário deslogado"
	oItem["data"] 		:= oItemData
	Aadd(aMessages, oMsgReturn)
	
	oItem["messages"] 	:= aMessages
	oItem["length"]   	:= 1
	
	cJson :=  FWJsonSerialize(oItem, .F., .F., .T.)
	::SetResponse(cJson)
EndIf

Return(.T.) 


// -------------------------------------------------------------------
// - GET RESPONSÁVEL POR VERIFICAR SE O TOKEN ESTÁ VALIDO.
// -------------------------------------------------------------------
WSMETHOD GET getLogged WSREST Auth

Local cJson      := ""
Local cToken     := ""
Local cMatSRA    := ""
Local cBranchVld := ""
Local cLogin     := ""
Local nLenParms  := Len(::aURLParms)

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken     := Self:GetHeader('Authorization')
cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cLogin     := GetLoginHR(cToken)

If Empty(cBranchVld) .Or. Empty(cMatSRA) .Or. Empty(cLogin)
   cJson   := '{ '               ;
            + '"isLogged":false' ;
            + ' }'
Else
   cJson   := '{ '               ;
            + '"isLogged":true'  ;
            + ' }'
EndIf

::SetResponse(cJson)

Return(.T.)


// -------------------------------------------------------------------
// - POST RESPONSÁVEL POR ENVIAR EMAIL PARA O RESET DA SENHA.
// -------------------------------------------------------------------
WSMETHOD POST getResetLink WSREST Auth

Local cQryRD0       := GetNextAlias()
Local cJsonObj      := "JsonObject():New()"
Local oItemDetail   := &cJsonObj
Local oItemData     := &cJsonObj
Local oItem         := &cJsonObj
Local oMsgReturn    := &cJsonObj
Local cBody         := ::GetContent()
Local cRestFault    := ""
Local cJson         := ""
Local aValueBody    := {}
Local aMessages     := {}
Local cUrl          := ""
Local cTitEmail     := ""
Local cMsgEmail     := ""
Local lRet          := .T.
local cRetCrypto    := ""
local cKey          := ""

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

    If !Empty(cBody)
        aValueBody := DecodeURL(cBody)
        //varinfo("aValueBody: ",aValueBody)

        If Len(aValueBody) == 3 .And. !empty(aValueBody[3]) 
           //varinfo("URL base recebido: ",aValueBody[2])
           //varinfo("User recebido    : ",aValueBody[1])
           //varinfo("Email recebido   : ",aValueBody[3])
           
           //valida RD0
           BEGINSQL ALIAS cQryRD0
              SELECT RD0.RD0_FILIAL, RD0.RD0_CODIGO, RD0.RD0_CIC, RD0.RD0_LOGIN, RD0.RD0_EMAIL
              FROM %table:RD0% RD0
              WHERE RD0.RD0_LOGIN = %Exp:Upper(aValueBody[1])%  AND
                    RD0.RD0_EMAIL = %exp:aValueBody[3]%  AND
                    RD0.%notDel%
           ENDSQL

           If !(cQryRD0)->(Eof())

              cRetCrypto = rc4crypt( (cQryRD0)->RD0_CODIGO +";" +aValueBody[1] +";" +aValueBody[3] +";" +dToC(date()) +";" +Time() +";" +alltrim(str(Randomize(100000,999000))) +";" ,"MeuRH#P12%Dutchman", .T.) 
              // processo crypto - retorno será em código ASCII hexadecimal
              //varinfo("Hash RC4 gerada: ",cRetCrypto)

              //atualiza hash no banco no novo campo a ser criado
              If RD0->(ColumnPos("RD0_RSTPWD")) > 0
                 dbSelectArea("RD0")
                 dbSetOrder(1)
                 If dbSeek(xFilial("RD0")+(cQryRD0)->RD0_CODIGO)
                    Reclock("RD0",.F.)
                    RD0->RD0_RSTPWD := cRetCrypto
                    RD0->( MsUnlock() )

                    //Funcao padrao para envio de email's
                    cUrl := aValueBody[2] +"#/resetPassword?hash=" + cRetCrypto //"http://spon4718.sp01.local:8081/T1/#/resetPassword?hash=" 
                    //varinfo("cUrl: ",cUrl)

                    //Monta HTML
                    cTitEmail := EncodeUTF8("Renovação de senha app MeuRH")  //"Renovação de senha app MeuRH"
              
                    cMsgEmail := '<html>'
                    cMsgEmail += '<head>'
                    cMsgEmail += '<title>'+cTitEmail+'</title>'
                    cMsgEmail += '</head>'
                    cMsgEmail += '<body>'
                    cMsgEmail += '<table borderColor="#0099cc" height="29" cellSpacing="1" width="750" borderColorLight="#0099cc" border=1>'
                    cMsgEmail += '<tr>'
                    cMsgEmail += '<td borderColor="#0099cc" borderColorLight="#0099cc" align="left" width="606" borderColorDark=v bgColor="#0099cc" height="1">'
                    cMsgEmail += '<p align="center"><font face="Arial" color="#ffffff" size="3"><b>' +"Link para gerar nova senha" +'</b></font></p></td>'
                    cMsgEmail += '</tr>'
                    cMsgEmail += '<tr>'
                    cMsgEmail += '<td align="left" width="606" height="32">'
                    cMsgEmail += '<br>'
                    cMsgEmail += '<p align="left">'
                    cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>' +"Clique no link:" +' </b></font>' //Clique no link:
                    cMsgEmail += '<a href="' +cUrl +'"> ' +cUrl +'</a>'
                    cMsgEmail += '<br>'
                    cMsgEmail += '<br>'
                    cMsgEmail += '</p>'
                    cMsgEmail += '</td>'
                    cMsgEmail += '</tr>'
                    cMsgEmail += '</body>'
                    cMsgEmail += '</html>'

                    //Dispara e-mail
                    RH_Email( Lower(Alltrim((cQryRD0)->RD0_EMAIL)) ,'' ,cTitEmail ,cMsgEmail ,'' ,'') 
              
                    lRet       := .T.
                 Else
                    lRet       := .F.
                    cRestFault := EncodeUTF8(STR0062) //"Participante não localizado na RD0" 
                 EndIf
              Else
                 lRet       := .F.
                 cRestFault := EncodeUTF8(STR0063) //"Campo RSTPWD não localizado na tabela RD0" 

                 If cMeurhLog != "0"
                    conout(EncodeUTF8(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"     ))
                    conout(EncodeUTF8(">>> MeuRH Reset Password"                                 ))
                    conout(EncodeUTF8(">>> " +FwCutOff(STR0065,.T.) +": " +FwCutOff(STR0063,.T.) )) //"aviso"
                    conout(EncodeUTF8(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"     ))
                 EndIf
              EndIf

           Else   
              lRet       := .F.
              cRestFault := EncodeUTF8(STR0052) //"usario/email não localizado na base de dados" 
           EndIf   

           (cQryRD0)->( DbCloseArea() )
       Else
           lRet       := .F.
           cRestFault := EncodeUTF8(STR0053) //"user/email não localizados na requisição" 
       EndIf
    Else
       lRet       := .F.
       cRestFault := EncodeUTF8(STR0054) //"body não localizado na requisição" 
    EndIf


    If lRet
       oItemData["user"]        := aValueBody[1]
       oItemData["redirectUrl"] := aValueBody[2]
       oItemData["email"]       := aValueBody[3]

       oMsgReturn["type"]       := "success"
       oMsgReturn["code"]       := "200"
       oMsgReturn["detail"]     := EncodeUTF8(STR0055) //"link para reset da senha enviado por e-mail"
       Aadd(aMessages, oMsgReturn)
    Else
       oMsgReturn["type"]       := "error"
       oMsgReturn["code"]       := "500"
       oMsgReturn["detail"]     := cRestFault
       Aadd(aMessages, oMsgReturn)
    EndIf

    oItem["data"]     := oItemData
    oItem["messages"] := aMessages
    oItem["length"]   := 1

    cJson :=  FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return(.T.)



// -------------------------------------------------------------------
// - PUT RESPONSÁVEL POR ATUALIZAR A SENHA DO USUÀRIO.
// -------------------------------------------------------------------
WSMETHOD PUT editPassword WSREST Auth

Local cJsonObj      := "JsonObject():New()"
Local oItemDetail   := &cJsonObj
Local oItemData     := &cJsonObj
Local oItem         := &cJsonObj
Local oMsgReturn    := &cJsonObj
Local cBody         := ::GetContent()
Local nLenParms     := Len(::aURLParms)
Local nHashVld      := (SuperGetMv("MV_HASHVLD",,60) == 0, 60)
Local cQuery        := GetNextAlias()
Local lRet          := .T.
Local lRC4          := .T.
Local aValueBody    := {}
Local aMessages     := {}
local aKey          := {}
Local cWhere        := ""
Local cRestFault    := ""
Local cJson         := ""
local cNewPwd       := ""
local cKey          := ""
local cValidTime    := ""

::SetContentType("application/json")
::SetHeader('Access-Control-Allow-Credentials' , "true")

	If !Empty(cBody) 
		oItemDetail:FromJson(cBody)
	EndIf
    
    If nLenParms >= 1 .And. ::aURLParms[1] == "resetPassword"
       //a hash foi retirada da URL e passada para o body
       //varinfo("hash recebida     : ", ::aURLParms[2] )

       If !Empty(cBody) .and. lRet
       	  
          If !Empty(oItemDetail["password"]) .And. !Empty(oItemDetail["hash"]) .And. len(alltrim(oItemDetail["password"])) <= 6 
             //varinfo("nova pwd: ", aValueBody[1] )
             //varinfo("hash    : ", aValueBody[2] )
             
             // processo descriptografia
             BEGIN SEQUENCE             
                cKey := rc4crypt( oItemDetail["hash"], "MeuRH#P12%Dutchman", .F., .T. )

                // verifica validade do hash
                aKey := STRTOKARR(cKey, ";")
                //varinfo("aKey: ", aKey)

                //Valida data e hora recebida no hash
                aDiffDatas := DateDiffYMD( aKey[4] , date() )
                //varinfo("Data Max: ", aKey[4] )
                //varinfo("Data Atu: ", Date() )
             RECOVER
                lRC4 := .F.
             END SEQUENCE

             If aDiffDatas[3] > 0 .or. !lRC4 
                //hash: data fora da validade! solicite novamente. 
                lRet       := .F.
                cRestFault := EncodeUTF8(STR0067) //"Link incorreto ou expirado. Solicite novamente outro link!"
                
                //limpa hash na RD0
                dbSelectArea("RD0")
                dbSetOrder(1)
                If dbSeek(xFilial("RD0") + alltrim(aKey[1]))
                   If alltrim(RD0->RD0_RSTPWD) == alltrim(oItemDetail["hash"])
                      Reclock("RD0",.F.)
                      RD0->RD0_RSTPWD := ""
                      RD0->( MsUnlock() )
                   EndIF
                EndIf 

             Else
                //nSegundos := ELAPTIME( "10:00:00", TIME() )
                //varinfo("Dif segundos : ", nSegundos )
                //IncTime([<cTime>],<nIncHours>,<nIncMinuts>,<nIncSeconds> ) -> Somar 
                //DecTime([<cTime>],<nDecHours>,<nDecMinuts>,<nDecSeconds> ) -> Subtrair
                
                cValidTime := IncTime( aKey[5] , 0 , nHashVld , 0 )
                //varinfo("Hora Max: ", cValidTime )
                //varinfo("Hora Atu: ", Time() )

                If Time() > cValidTime
                   //"hash: hora fora da validade! solicite novamente."
                   lRet       := .F.
                   cRestFault := EncodeUTF8(STR0067) //"Link incorreto ou expirado. Solicite novamente outro link!"
                   
                   //limpa hash na RD0
                   dbSelectArea("RD0")
                   dbSetOrder(1)
                   If dbSeek(xFilial("RD0") + alltrim(aKey[1]))
                      If alltrim(RD0->RD0_RSTPWD) == alltrim(oItemDetail["hash"])
                         Reclock("RD0",.F.)
                         RD0->RD0_RSTPWD := ""
                         RD0->( MsUnlock() )
                      EndIF
                   EndIf 
                Else
                   //pesquisa hash na tabela RD0 e atualiza nova senha
                   
                   If RD0->(ColumnPos("RD0_RSTPWD")) > 0
                      dbSelectArea("RD0")
                      dbSetOrder(1)
                      If dbSeek(xFilial("RD0")+ aKey[1])

                         If RD0->RD0_RSTPWD != oItemDetail["hash"]
                             //HASH recebida invalida/não confere 
                            lRet       := .F.
                            cRestFault := EncodeUTF8(STR0067) //"Link incorreto ou expirado. Solicite novamente outro link!" 
                         Else
                            //Atualiza password
             	         	cNewPwd := Upper(AllTrim(oItemDetail["password"]))
                            cNewPwd := Padr(cNewPwd,6)
                            cNewPwd := Embaralha(cNewPwd, 0)
                            
                            Begin Transaction
                               //atualizando senha RD0
                               Reclock("RD0",.F.)
                               RD0->RD0_SENHA  := cNewPwd
                               RD0->RD0_RSTPWD := ""
                               RD0->( MsUnlock() )

                               //atualizando senha SRA
                               cWhere := "%AND RDZ.RDZ_ENTIDA='SRA' AND RDZ.RDZ_CODRD0='" +RD0->(RD0_CODIGO) +"'%"
                               BEGINSQL ALIAS cQuery
                                   SELECT RDZ.RDZ_CODRD0, RDZ.RDZ_CODENT
                                   FROM %table:RDZ% RDZ
                                   WHERE RDZ.%notDel%
                                         %exp:cWhere%
                               ENDSQL
                               While !(cQuery)->(Eof()) .And. ((cQuery)->RDZ_CODRD0==RD0->(RD0_CODIGO))

                                   DbSelectArea("SRA")
                                   DbSetOrder(1)
                                   If DbSeek( (cQuery)->RDZ_CODENT ) 
                                      Reclock("SRA",.F.)
                                      SRA->RA_SENHA := cNewPwd
                                      SRA->( Msunlock() )
                                   EndIf

                                   (cQuery)->(dbSkip())
                               EndDo
                              (cQuery)->(dbCloseArea())
                            
                               lRet       := .T.
                            End Transaction
                               
                         EndIf   
                      Else
                         lRet       := .F.
                         cRestFault := EncodeUTF8(STR0062) //"Participante não localizado na RD0" 
                      EndIf
                   Else
                      lRet       := .F.
                      cRestFault := EncodeUTF8(STR0063) //"Campo RSTPWD não localizado na tabela RD0" 

                      If cMeurhLog != "0"
                         conout(EncodeUTF8(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"     ))
                         conout(EncodeUTF8(">>> MeuRH Reset Password"                                 ))
                         conout(EncodeUTF8(">>> " +FwCutOff(STR0065,.T.) +": " +FwCutOff(STR0063,.T.) )) //"aviso"
                         conout(EncodeUTF8(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"     ))
                      EndIf

                   EndIf

                EndIf
             EndIf

          Else
             lRet       := .F.
             cRestFault := EncodeUTF8(STR0066) //"a senha deve ter no máximo 6 posições." 
          EndIf
       Else
          lRet       := .F.
          cRestFault := EncodeUTF8(STR0059) //"body não localizado na requisição" 
       EndIf

    Else
       lRet       := .F.
       cRestFault := EncodeUTF8(STR0060) //"servico pwd invalido" 
    EndIf
    

    If lRet
       oItemData["password"] := oItemDetail["password"]
       oItemData["hash"]     := oItemDetail["hash"]

       oMsgReturn["type"]    := "success"
       oMsgReturn["code"]    := "200"
       oMsgReturn["detail"]  := EncodeUTF8(STR0061) //"senha atualizada com sucesso"
       Aadd(aMessages, oMsgReturn)

	   oItem["data"]          := oItemData
	   oItem["messages"]      := aMessages
	   oItem["length"]        := 1
	   cJson                  :=  FWJsonSerialize(oItem, .F., .F., .T.)
	   ::SetResponse(cJson)
    Else
		SetRestFault(500, cRestFault, .T.)
    EndIf

Return(lRet)

