#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "CNTA180.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA180J ³ Autor ³ TOTVS                 ³ Data ³16/08/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina responsavel por enviar notificacoes aos usuarios re-³±±
±±³          ³ lacionados aos contratos com pendencia de avaliacoes       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA180J()                             					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ W. Pires   ³23/12/10³      ³ Desmembramento da funcao em um fonte a   ³±±
±±³ 		   ³		³      ³ parte para execução via schedule	      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNTA180J(aParam)

Default aParam := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a rotina e executada atraves de um JOB   ³
//³ ou pelo menu                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetRemoteType() == -1//Execucao por JOB
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa Notificacoes das Avaliacoes dos Contratos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	RpcSetType ( 3 )
	RPCSetEnv(aParam[1],aParam[2],,,"GCT")
	CN180EXC(.T.)
	RPCClearEnv()
Else//Execucao por Menu

	If Aviso("CNTA180J",OemToAnsi(STR0051),{OemToAnsi(STR0036),OemToAnsi(STR0037)}) == 1 //"Confirma processamento das notificações de pendência das avaliações de contratos?" ## "Sim" ## "Nao"
		Processa( {|| CN180EXC(.F.) } )
	EndIf
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN180EXC ³ Autor ³ TOTVS                 ³ Data ³16/08/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa notificacoes das avaliacoes dos contratos          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN180EXC(lExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lExp01 - Executado pelo job                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN180EXC(lJob)
Local cQuery    := ""
Local cAlias    := ""
Local dData
Local aUsuario  := {}
Local aNotifCtr := {}
Local nPos
Local nX

Local lOk       := .F.
Local lProc     := .F.
Local cMsg      := ''    // Mensagem do e-mail
Local cServer   := Trim( GetMV( 'MV_RELSERV',, '' ) )  // Nome do servidor de e-mail
Local cConta    := Trim( GetMV( 'MV_RELACNT',, '' ) )  // Nome da conta a ser usada no e-mail
Local cPaswd    := Trim( GetMV( 'MV_RELPSW' ,, '' ) )  // Senha
Local cEmRem    := Trim( GetMV( 'MV_RELFROM',, '' ) )  // E-mail do remetente
Local lAuth     :=       GetMV( 'MV_RELAUTH',, .F.  )  // Tem Autenticacao ?
Local cEmDest   := "" 		// e-mail do destinatario
Local cAssun    := STR0052	//"Aviso de Pendencia de Avaliacao de Contratos"
Local nTotNotif := 0

DEFAULT lJob := .F.

dData := If(lJob,date(),dDataBase)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa Pendencias por Contrato      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery	:= "  SELECT CN9_FILIAL, CN9_NUMERO, CN9_REVISA, CN9_USUAVA, CN9_PROXAV, CN9_ULTAVA, CNN_USRCOD, CNN_TRACOD FROM " + RetSqlName('CN9') + " CN9"
cQuery	+= "  INNER JOIN " + RetSqlName('CNN') + " CNN"
cQuery += "  ON CN9.CN9_FILIAL = CNN.CNN_FILIAL AND CN9.CN9_NUMERO = CNN.CNN_CONTRA"
cQuery	+= "  WHERE CN9.CN9_FILIAL  = '" + xFilial('CN9') + "'"
cQuery	+= "    AND CN9.CN9_PROXAV <> ''"
cQuery	+= "    AND CN9.CN9_PROXAV < '" + DTOS(dData) + "'"
cQuery	+= "    AND CN9.CN9_SITUAC = '05'"  //Apenas contratos vigentes
cQuery	+= "    AND CN9.D_E_L_E_T_ = ' '"
cQuery	+= "  ORDER BY CNN_USRCOD, CN9_NUMERO, CN9_REVISA"
cQuery := ChangeQuery(cQuery)
dbUseArea ( .T., "TOPCONN", TCGENQRY(,,cQuery), "CN9TMP", .F., .T.)
TCSetField( "CN9TMP", "CN9_PROXAV", "D", TamSX3("CN9_PROXAV")[1], TamSX3("CN9_PROXAV")[2] )
TCSetField( "CN9TMP", "CN9_ULTAVA", "D", TamSX3("CN9_ULTAVA")[1], TamSX3("CN9_ULTAVA")[2] )

While CN9TMP->(!Eof())
	nPos := Ascan(aNotifCtr,{|x| x[01] == CN9TMP->CNN_USRCOD})
	If nPos == 0
		aadd(aNotifCtr,{CN9TMP->CNN_USRCOD,{{CN9TMP->CN9_FILIAL,CN9TMP->CN9_NUMERO,CN9TMP->CN9_REVISA,"","",CN9TMP->CN9_PROXAV,CN9TMP->CN9_ULTAVA}}})
	Else
		aadd(aNotifCtr[nPos,2],{CN9TMP->CN9_FILIAL,CN9TMP->CN9_NUMERO,CN9TMP->CN9_REVISA,"","",CN9TMP->CN9_PROXAV,CN9TMP->CN9_ULTAVA})
	Endif
	CN9TMP->(DbSkip())
Enddo
CN9TMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa pendencias por itens de Contrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery	:= "  SELECT CNB_FILIAL, CNB_CONTRA, CNB_REVISA, CNB_PROXAV, CNB_ULTAVA, CNB_PRODUT, CNB_DESCRI, CN9_FILIAL, CN9_NUMERO, CN9_REVISA, CN9_USUAVA, CNN_USRCOD, CNN_TRACOD"
cQuery	+= "  FROM " + RetSqlName('CNB') + " CNB, " + RetSqlName('CN9') + " CN9"
cQuery += "  INNER JOIN " + RetSqlName('CNN') + " CNN"
cQuery += "  ON CN9.CN9_FILIAL = CNN.CNN_FILIAL AND CN9.CN9_NUMERO = CNN.CNN_CONTRA"
cQuery	+= "  WHERE CNB.CNB_FILIAL  = '" + xFilial('CNB') + "'"
cQuery	+= "    AND CNB.CNB_PROXAV <> ''"
cQuery	+= "    AND CNB.CNB_PROXAV < '" + DTOS(dData) + "'"
cQuery	+= "    AND CNB.D_E_L_E_T_ = ' '"
cQuery	+= "    AND CN9.CN9_FILIAL  = '" + xFilial('CN9') + "'"
cQuery	+= "    AND CN9.CN9_SITUAC = '05'"  //Apenas contratos vigentes
cQuery	+= "    AND CN9.D_E_L_E_T_ = ' '"
cQuery	+= "    AND CNB.CNB_CONTRA = CN9.CN9_NUMERO"
cQuery	+= "    AND CNB.CNB_REVISA = CN9.CN9_REVISA
cQuery	+= "  ORDER BY CNN_USRCOD, CNB_CONTRA, CNB_REVISA"
cQuery := ChangeQuery(cQuery)
dbUseArea ( .T., "TOPCONN", TCGENQRY(,,cQuery), "CNBTMP", .F., .T.)
TCSetField( "CNBTMP", "CNB_PROXAV", "D", TamSX3("CNB_PROXAV")[1], TamSX3("CNB_PROXAV")[2] )
TCSetField( "CNBTMP", "CNB_ULTAVA", "D", TamSX3("CNB_ULTAVA")[1], TamSX3("CNB_ULTAVA")[2] )

While CNBTMP->(!Eof())
	nPos := Ascan(aNotifCtr,{|x| x[01] == CNBTMP->CNN_USRCOD})
	If nPos == 0
		aadd(aNotifCtr,{CNBTMP->CNN_USRCOD,{{CNBTMP->CNB_FILIAL,CNBTMP->CNB_CONTRA,CNBTMP->CNB_REVISA,CNBTMP->CNB_PRODUT,CNBTMP->CNB_DESCRI,CNBTMP->CNB_PROXAV,CNBTMP->CNB_ULTAVA}}})
	Else
		aadd(aNotifCtr[nPos,2],{CNBTMP->CNB_FILIAL,CNBTMP->CNB_CONTRA,CNBTMP->CNB_REVISA,CNBTMP->CNB_PRODUT,CNBTMP->CNB_DESCRI,CNBTMP->CNB_PROXAV,CNBTMP->CNB_ULTAVA})
	Endif
	CNBTMP->(DbSkip())
Enddo
CNBTMP->(dbCloseArea())

PswOrder(1)
For nX:=1 to Len(aNotifCtr)
	If PswSeek( aNotifCtr[nX,01], .T. )

		aUsuario := PswRet()
		If Empty(aUsuario[1,14])
			ConOut(STR0060 + aNotifCtr[nX,01] + STR0061)	//"Atencao! Usuario " ## " sem email cadastrado (CNTA180J)"
			Loop
		Else
			nTotNotif++
		Endif

		//----------------------------
		//Monta html do email de aviso
		//----------------------------
		cMsg := ""
		MontaHtml(aNotifCtr[nX,02],@cMsg,dData)
		cEmDest := aUsuario[1,14]

		//----------------------------
		//Envia email de aviso
		//----------------------------
		If !Empty(cServer) .And. !Empty(cConta) .And. !Empty(cPaswd) .And. !Empty(cEmDest) .And. !Empty(cMsg)
			CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPaswd RESULT lOk
			If lOk
				If lAuth
					MailAuth( cConta, cPaswd ) //realiza a autenticacao no servidor de e-mail.
				EndIf
				SEND MAIL FROM cEmRem to cEmDest SUBJECT cAssun BODY cMsg RESULT lSendOk FORMAT TEXT
				If !lSendOk
					GET MAIL ERROR cError
					If lJob
						ConOut(STR0053)						//"Erro no envio do e-Mail de Pendencias de Avaliacao de Contratos"
					Else
 						Aviso(STR0054,cError,{STR0055},2)	//"Erro no envio do e-Mail" ## "Fechar"
					Endif
				EndIf
			Else
				GET MAIL ERROR cError
				If lJob
					ConOut(STR0053)							//"Erro no envio do e-Mail de Pendencias de Avaliacao de Contratos"
				Else
					Aviso(STR0054,cError,{STR0055},2)		//"Erro no envio do e-Mail" ## "Fechar"
				Endif
			EndIf
			If lOk
				DISCONNECT SMTP SERVER
			EndIf
		EndIf

	Endif
Next

If !lJob
	If nTotNotif > 0
		Aviso("CNTA180J",STR0089 + CVALTOCHAR(nTotNotif),{"OK"}) //"Quantidade de notificações processadas: "
	Else
		Aviso("CNTA180J",STR0090,{"OK"})	//"Não existem notificações a serem processadas nesta data."
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ MontaHtmlº Autor ³ TOTVS              º Data ³  18/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta html do email de aviso de pendencia de avaliacao     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaHtml(aNotifCtr,cMsg,dData)
Local nI := 0

cMsg := ''
cMsg += '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
cMsg += '	<html>'
cMsg += '		<head>'
cMsg += '			<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">'
cMsg += '			<title>'+ STR0077 +'</title>'	//"Pendencia de Avaliacao de Contratos"
cMsg += '		</head>'
cMsg += '		<body>'
cMsg += '			<table style="text-align: center; width: 100%;" border="0" cellpadding="0" cellspacing="0">'
cMsg += '				<tbody>'
cMsg += '				<tr>'
cMsg += '					<td style="background-color: rgb(255, 204, 153);"><big><span style="font-weight: bold; font-family: Tahoma">'+ STR0077 +'</span></big></td>'	//"Pendencia de Avaliacao de Contratos"
cMsg += '				</tr>'
cMsg += '				</tbody>'
cMsg += '			</table>'
cMsg += '			<table style="text-align: left; width: 100%;" border="0" cellpadding="0" cellspacing="0">'
cMsg += '				<tbody>'
cMsg += '				<tr>'
cMsg += '					<td><big style="font-weight: bold; font-family: Arial;">'+ STR0078 + DTOC(dData) + '</big></td>'	//"Data de Processamento: "
cMsg += '				</tr>'
cMsg += '				</tbody>'
cMsg += '			</table>'
cMsg += '			<br>'
cMsg += '				<table border="0" cellpadding="0" cellspacing="0" width="100%">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td bgcolor="#074b85"><img src="pic_invis.gif" height="1" width="1"></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table style="text-align: left; width: 100%;" border="0" cellpadding="0" cellspacing="2">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td style="background-color: rgb(255, 204, 153);"><big style="font-weight: bold; font-family: Arial;">'+ STR0079 +'</big></td>' //"Avaliacoes por Contrato"
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table border="0" cellpadding="0" cellspacing="0" width="100%">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td bgcolor="#074b85"><img src="pic_invis.gif" height="1" width="1"></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table style="text-align: left; width: 100%;" border="0" cellpadding="0" cellspacing="2">'
cMsg += '				</table>'
cMsg += '				<table border="0" cellpadding="0" cellspacing="0" width="100%">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td bgcolor="#074b85"><img src="pic_invis.gif" height="1" width="1"></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table style="text-align: left; width: 100%; height: 24px;" border="0" cellpadding="0" cellspacing="2">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td style="text-align: left; font-weight: bold; width: 10%; background-color: rgb(255, 204, 153);"	><small>'+ STR0080 +'</small></td>' //Filial
cMsg += '						<td style="text-align: left; font-weight: bold; width: 10%; background-color: rgb(255, 204, 153);"	><small>'+ STR0020 +'</small></td>'	//"Contrato"
cMsg += '						<td style="text-align: left; font-weight: bold; background-color: rgb(255, 204, 153); width: 10%;"><small>'+ STR0081 +'</small></td>'	//"Revisao"
cMsg += '						<td style="text-align: center; font-weight: bold; width: 10%; background-color: rgb(255, 204, 153);"	><small>'+ STR0082 +'</small></td>'//"Dt. Ultima Avaliacao"
cMsg += '						<td style="text-align: center; font-weight: bold; background-color: rgb(255, 204, 153); width: 10%;"	><small>'+ STR0083 +'</small></td>'	//"Dt. Proxima Avaliacao"
cMsg += '					</tr>'

For nI:=1 to Len(aNotifCtr)
	If Empty(aNotifCtr[nI,04])
		cMsg += '      				<tr>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,01]+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,02]+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,03]+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11; text-align: center;">'+DTOC(aNotifCtr[nI,07])+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11; text-align: center;">'+DTOC(aNotifCtr[nI,06])+'</td>'
		cMsg += '      				</tr>'
	Endif
Next

cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<br>'
cMsg += '				<br>'
cMsg += '				<table border="0" cellpadding="0" cellspacing="0" width="100%">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td bgcolor="#074b85"><img src="pic_invis.gif" height="1" width="1"></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table style="text-align: left; width: 100%; height: 24px;" border="0" cellpadding="0" cellspacing="2">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td style="font-weight: bold; width: 10%; text-align: left; background-color: rgb(255, 204, 153);"><big style="font-weight: bold; font-family: Arial;">'+ STR0084 +'</big></td>'	//"Avaliacoes por Itens de Contrato"
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table border="0" cellpadding="0" cellspacing="0" width="100%">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td bgcolor="#074b85"><img src="pic_invis.gif" height="1" width="1"></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table border="0" cellpadding="0" cellspacing="0" width="100%">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td bgcolor="#074b85"><img src="pic_invis.gif" height="1" width="1"></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table style="text-align: left; width: 100%; height: 24px;" border="0" cellpadding="0" cellspacing="2">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td style="text-align: left; font-weight: bold; width: 5%; background-color: rgb(255, 204, 153);"><small>'+ STR0080 +'</small></td>'  //Filial
cMsg += '						<td style="text-align: left; font-weight: bold; width: 10%; background-color: rgb(255, 204, 153);"><small>'+ STR0020 +'</small></td>' //Contrato
cMsg += '						<td style="text-align: left; font-weight: bold; width: 5%; background-color: rgb(255, 204, 153);"><small>'+ STR0081 +'</small></td>'  //Revisao
cMsg += '						<td style="text-align: left; font-weight: bold; width: 10%; background-color: rgb(255, 204, 153);"><small>'+ STR0087 +'</small></td>' //Produto
cMsg += '						<td style="text-align: left; font-weight: bold; width: 20%; background-color: rgb(255, 204, 153);"><small>'+ STR0088 +'</small></td>' //Descrição
cMsg += '						<td style="text-align: center; font-weight: bold; width: 10%; background-color: rgb(255, 204, 153);"><small>'+ STR0082 +'</small></td>'//Dta. Ultima Avaliação
cMsg += '						<td style="text-align: center; font-weight: bold; width: 10%; background-color: rgb(255, 204, 153);"><small>'+ STR0083 +'</small></td>'//Dta. Prx. Avaliacao
cMsg += '					</tr>'

For nI:=1 to Len(aNotifCtr)
	If !Empty(aNotifCtr[nI,04])
		cMsg += '      				<tr>'
		cMsg += '						<td style="width: 5%;  font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,01]+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,02]+'</td>'
		cMsg += '						<td style="width: 5%;  font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,03]+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,04]+'</td>'
		cMsg += '						<td style="width: 20%; font-family: Verdana; font-size: 11;">'+aNotifCtr[nI,05]+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11; text-align: center;">'+DTOC(aNotifCtr[nI,07])+'</td>'
		cMsg += '						<td style="width: 10%; font-family: Verdana; font-size: 11; text-align: center;">'+DTOC(aNotifCtr[nI,06])+'</td>'
		cMsg += '      				</tr>'
	Endif
Next

cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<br>'
cMsg += '				<br>'
cMsg += '				<table border="0" cellpadding="0" cellspacing="0" width="100%">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td bgcolor="#074b85"><img src="pic_invis.gif" height="1" width="1"></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '				<table style="width: 100%;" border="0" cellpadding="0" cellspacing="0">'
cMsg += '					<tbody>'
cMsg += '					<tr>'
cMsg += '						<td class="Mini" style="vertical-align: baseline; font-family: Arial;"><small><small><strong>TOTVS WorkFlow</strong></small></small></td>'
cMsg += '					</tr>'
cMsg += '					</tbody>'
cMsg += '				</table>'
cMsg += '		</body>'
cMsg += '	</html>'

Return cMsg