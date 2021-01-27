#Include 'Protheus.ch'
#include 'FWMVCDEF.CH'
#Include 'TBICONN.CH'
#include 'AP5MAIL.CH'
#Include 'RwMake.CH'
#Include 'CFGX049B.CH'

Static __nCtrlFor	As Numeric
Static __lVldBco	As Logical
Static __lAuxBco	As Logical
Static __aDdsMrk	As Array
Static __oFwBrw		As Object
Static __oBrwCNAB	As Object
Static __oPnlAux	As Object
Static __oTmpSA6	As Object
Static __oTmpBCO 	As Object
Static __oTmpEDI 	As Object

//-------------------------------------------------------------------
/*/{Protheus.doc} CFGX49B()
Rotina para construção do wizard de importação arquivo CNAB

@author Francisco Oliveira
@since  10/07/2016
@version 12.1.019
/*/
//-------------------------------------------------------------------
Function CFGX049B()

	Private oStepWiz	As Object
	Private o1stPage	As Object
	Private o2ndPage	As Object
	Private o3rdPage	As Object
	Private o4rdPage	As Object
	Private o5rdPage	As Object
	Private o6rdPage	As Object
	Private cURLCNAB	As Character
	Private cVerTOT		As Character
	Private lSA6Mrk		As Logical
	Private lSA6Mrk2	As Logical
	Private lBcoMrk		As Logical
	Private lEdiMrk		As Logical
	Private lVldAces	As Logical
	Private lVldVer		As Logical
	Private lVldRep		As Logical
	Private nCtrPrev	As Numeric
	Private aEdiCNAB	As Array
	Private aDdsEdit	As Array
	Private oObjCNABAti As Object
	Private oFont1		As Object
	Private oFont2		As Object

	// Bloco de variáveis utilizado na página 3 / step 3
	Private oMrkLayout	As Object
	Private cTrabSA6	As Character

	// Bloco de variáveis utilizado na página 4 / step 4
	Private oMrkClient	As Object
	Private cTrabBco 	As Character

	// Bloco de variáveis utilizado na página 5 / step 5
	Private oMrkEdit	As Object
	Private cTrabEdi	As Character

	__nCtrlFor 	:= 1
	__lVldBco		:= .F.
	__lAuxBco		:= .T.
	__aDdsMrk		:= {}
	cURLCNAB	:= "http://cnab.totvs.com.br/rest"
	cVerTOT		:= "12.1.017"
	lSA6Mrk		:= .F.
	lSA6Mrk2	:= .F.
	lBcoMrk		:= .F.
	lEdiMrk		:= .F.
	lVldAces	:= .F.
	lVldVer		:= .F.
	lVldRep		:= .F.
	nCtrPrev	:= 0
	aEdiCNAB	:= {}
	aDdsEdit	:= {}
	oFont1		:= TFont():New("Arial",,-18,,.F.,,,,,)
	oFont2		:= TFont():New("Arial",,-15,,.F.,,,,,)
	cTrabSA6	:= GetNextAlias()
	cTrabBco 	:= GetNextAlias()
	cTrabEdi	:= GetNextAlias()

	oStepWiz := FWWizardControl():New(,{600,850})//Instancia a classe FWWizardControl

	oStepWiz:ActiveUISteps()

	//----------------------
	// Pagina 1
	//----------------------
	o1stPage := oStepWiz:AddStep("1STSTEP",{|Panel| cria_pn1(Panel)}) // Adiciona um Step
	o1stPage:SetStepDescription(OemToAnsi(STR0001)) // "Informações da baixa"
	o1stPage:SetNextTitle(OemToAnsi(STR0002)) // Define o título do botão de avanço -- "Avançar"
	o1stPage:SetNextAction({||.T.}) // Define o bloco ao clicar no botão Próximo
	o1stPage:SetCancelAction({|| .T.}) // Define o bloco ao clicar no botão Cancelar

	//----------------------
	// Pagina 2
	//----------------------
	o2ndPage := oStepWiz:AddStep("2NDSTEP", {|Panel|cria_pn2(Panel)})
	o2ndPage:SetStepDescription(OemToAnsi(STR0005)) // "Validação Acesso"
	o2ndPage:SetNextTitle(OemToAnsi(STR0002)) // -- "Avançar"
	o2ndPage:SetPrevTitle(OemToAnsi(STR0003)) // Define o título do botão para retorno -- "Retornar"
	o2ndPage:SetNextAction({|| Valid_PG2()})
	o2ndPage:SetPrevAction({|| .T.}) //Define o bloco ao clicar no botão Voltar
	o2ndPage:SetCancelAction({|| .T.}) // Define o bloco ao clicar no botão Cancelar

	//----------------------
	// Pagina 3
	//----------------------
	o3rdPage := oStepWiz:AddStep("3RDSTEP", {|Panel|cria_pn3(Panel)})
	o3rdPage:SetStepDescription(OemToAnsi(STR0004)) // "Definição Bancos"
	o3rdPage:SetNextTitle(OemToAnsi(STR0002)) // -- "Avançar"
	o3rdPage:SetPrevTitle(OemToAnsi(STR0003)) // -- "Retornar"
	o3rdPage:SetNextAction({|| Valid_PG1() })
	o3rdPage:SetPrevWhen({|| .F. })
	o3rdPage:SetCancelAction({|| .T. })

	//----------------------
	// Pagina 4
	//----------------------
	o4rdPage := oStepWiz:AddStep("4RDSTEP", {|Panel|cria_pn4(Panel)})
	o4rdPage:SetStepDescription(OemToAnsi(STR0006)) // "Definir Arquivos"
	o4rdPage:SetNextTitle(OemToAnsi(STR0002)) // -- "Avançar"
	o4rdPage:SetPrevTitle(OemToAnsi(STR0003)) // -- "Retornar"
	o4rdPage:SetNextAction({|| Valid_PG3() })
	o4rdPage:SetPrevAction({|| Prev_pn4() })
	o4rdPage:SetCancelAction({|| .T. })

	//----------------------
	// Pagina 5
	//----------------------
	o5rdPage := oStepWiz:AddStep("5RDSTEP", {|Panel|cria_pn5(Panel)})
	o5rdPage:SetStepDescription(OemToAnsi(STR0007)) // "Editar Arquivos"
	o5rdPage:SetNextTitle(OemToAnsi(STR0002)) // -- "Avançar"
	o5rdPage:SetPrevTitle(OemToAnsi(STR0003)) // -- "Retornar"
	o5rdPage:SetNextAction({|| .T. })
	o5rdPage:SetPrevWhen({|| .F. })
	o5rdPage:SetCancelTitle(OemToAnsi(STR0091)) // "Finalizar"
	o5rdPage:SetCancelAction({|| GerArqCFG(1) })

	//----------------------
	// Pagina 8
	//----------------------

	o8rdPage := oStepWiz:AddStep("8RDSTEP", {|Panel|cria_pn8(Panel)})
	o8rdPage:SetStepDescription(OemToAnsi(STR0054)) // "Escolha de arquivos CNAB para edição"
	o8rdPage:SetNextTitle(OemToAnsi(STR0002)) // -- "Avançar"
	o8rdPage:SetPrevTitle(OemToAnsi(STR0003)) // -- "Retornar"
	o8rdPage:SetNextAction({|| Valid_PG4() })
	o8rdPage:SetPrevWhen({|| .F. })
	o8rdPage:SetCancelAction({|| .T. })

	//----------------------
	// Pagina 6
	//----------------------

	o6rdPage := oStepWiz:AddStep("6RDSTEP", {|Panel|cria_pn6(Panel, __nCtrlFor)})
	o6rdPage:SetStepDescription(OemToAnsi(STR0045)) // "Edição dos Arquivos CNAB"
	o6rdPage:SetNextTitle(OemToAnsi(STR0002)) // -- "Avançar"
	o6rdPage:SetPrevTitle(OemToAnsi(STR0003)) // -- "Retornar"
	o6rdPage:SetNextAction({|| CFGX049B06(aDdsEdit, __nCtrlFor ) })
	o6rdPage:SetPrevWhen({|| .F. })
	o6rdPage:SetCancelAction({|| .T. })

	//----------------------
	// Pagina 7
	//----------------------

	o7rdPage := oStepWiz:AddStep("7RDSTEP", {|Panel|cria_pn7(Panel)})
	o7rdPage:SetStepDescription(OemToAnsi(STR0008)) // "Encerramento Processo"
	o7rdPage:SetNextTitle(OemToAnsi(STR0002)) // -- "Avançar"
	o7rdPage:SetPrevTitle(OemToAnsi(STR0003)) // -- "Retornar"
	o7rdPage:SetNextAction({|| .T. })
	o7rdPage:SetPrevAction({|| .T. })
	o7rdPage:SetCancelAction({|| .T. })

	oStepWiz:Activate()

	// Limpa Tabelas Temporarias
	ClearTMP()

	//Limpa Variaveis Staticas
	__nCtrlFor	:= Nil
	__lVldBco	:= Nil
	__lAuxBco	:= Nil
	__aDdsMrk	:= Nil
	__oFwBrw	:= Nil
	__oBrwCNAB	:= Nil
	__oPnlAux	:= Nil
	__oTmpSA6	:= Nil
	__oTmpBCO	:= Nil
	__oTmpEDI	:= Nil

Return

//--------------------------------------------------------------------
// Início dos blocos de construção das páginas de cada step
//--------------------------------------------------------------------

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn1
Função para construção da primeira página do wizard

@param oPanel

@author Francisco Oliveira
@since  10/07/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn1(oPanel)

	If __lVldBco
		__lVldBco := .F.
	Endif

	If lVldRep
		lVldRep	:= .F.
	Endif

	TSay():New(010,20,{|| OemToAnsi(STR0009) },oPanel,,oFont1,,,,.T.,CLR_BLUE,) // "Baixar arquivos de configuração CNAB."
	TSay():New(025,15,{|| OemToAnsi(STR0010) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "Clique em 'Avançar' para:"
	TSay():New(045,15,{|| OemToAnsi(STR0011) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "- Validação de Acesso do Cliente e Versão Protheus."
	TSay():New(065,15,{|| OemToAnsi(STR0013) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "- Definir qual(is) banco(s) será(ão) baixado(s) arquivo(s) e qual(is) o(s) tipo(s)."
	TSay():New(085,15,{|| OemToAnsi(STR0015) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "- Opção de edição do(s) arquivo(s) de configuração."
	TSay():New(105,15,{|| OemToAnsi(STR0016) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "Ao final do processo, os arquivos serão baixados para o ambiente do cliente."
	TSay():New(125,20,{|| OemToAnsi(STR0017) },oPanel,,oFont1,,,,.T.,CLR_BLUE,) // "Importante:"
	TSay():New(145,15,{|| OemToAnsi(STR0018) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "Homologar os Arquivos de Configuração CNAB em Ambiente Teste."
	TSay():New(165,15,{|| OemToAnsi(STR0109) + cVerTOT + OemToAnsi(STR0110) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "Para acesso aos arquivos de configuração CNAB, a versão de seu sistema deverá ser + var + ou superior."

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn2
Função para construção da terceira página do wizard

@param oPanel

@author Francisco Oliveira
@since  24/07/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn2(oPanel)

	Local oWsChkCNPJ	As Object
	Local lRet			As Logical
	Local aAreaSM0		As Array
	Local cGetRPO		As Character
	Local cMsgWs		As Character
	Local cCNPJCli		As Character
	Local cNomeCli		As Character

	lRet 		:= .F.
	aAreaSM0	:= GetArea()
	cGetRPO		:= GetRpoRelease()
	cMsgWs		:= ""
	cCNPJCli	:= SM0->M0_CGC
	cNomeCli	:= rtrim(SM0->M0_NOME)

	If cGetRPO >= cVerTOT

		TSay():New(025,25,{|| OemToAnsi(STR0024) },oPanel,,oFont1,,,,.T.,CLR_BLUE,) // "Validação de Versão Protheus."
		TSay():New(038,30,{|| OemToAnsi(STR0028) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "A release de seu sistema é igual ou superior que a release dos arquivos de configuração CNAB em nossos servidores."
		TSay():New(051,30,{|| OemToAnsi(STR0111) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) // "Processo de validação de versão finalizado com êxito"
		TSay():New(070,25,{|| OemToAnsi(STR0021) },oPanel,,oFont1,,,,.T.,CLR_BLUE,) // "Validação de acesso ao servidor de arquivos TOTVS."

		lVldVer	:= .T.

		If cEmpAnt == "T1" .and. cNomeCli == "Grupo TOTVS 1"
			lVldAces := .T. // Não precisa validar se for base congelada da TOTVS.
			cMsgWs   := STR0155 // "Base congelada - não é necessária validação"
		Else
			MsgRun(STR0005, STR0114, {|| oWsChkCNPJ := WSWSPF04():New(), oWsChkCNPJ:cCCNPJ := cCNPJCli, oWsChkCNPJ:PF4CHKCNPJ()}) // "Validação acesso" + "Aguarde... Consultando nossos servidores."

			lVldAces := oWsChkCNPJ:oWsPF4CHKCNPJRESULT:lOk
			If lVldAces
				cMsgWs := oWsChkCNPJ:oWsPF4CHKCNPJRESULT:cMsg
			Else
				cMsgWs := STR0138 //"CNPJ não encontrado em nossos servidores."
			Endif
		Endif

		If lVldAces
			lRet := .T.
			TSay():New(083,30,{|| cMsgWs + OemToAnsi(STR0112) },oPanel,,oFont2,,,,.T.,CLR_BLUE,) //". Clique em avançar para a baixar os arquivos CNAB."
		Else
			TSay():New(083,30,{|| cMsgWs },oPanel,,oFont2,,,,.T.,CLR_RED,) //"CNPJ não é válido e/ou não tem acesso aos nossos serviços de hardlock. Favor verificar."
			TSay():New(096,30,{|| OemToAnsi(STR0113) },oPanel,,oFont2,,,,.T.,CLR_RED,) //"CNPJ não é válido ou não tem acesso aos nossos serviços de hardlock. Favor verificar."
		Endif
	Else
		TSay():New(025,25,{|| OemToAnsi(STR0024) },oPanel,,oFont1,,,,.T.,CLR_BLUE,) //"Validação de versão Protheus."
		TSay():New(038,30,{|| OemToAnsi(STR0025) + cVerTOT },oPanel,,oFont2,,,,.T.,CLR_RED,) // "- Baixa dos arquivos CNAB somente a Partir da Versão Protheus +  cVerTOT."
		TSay():New(051,30,{|| OemToAnsi(STR0026) + cGetRPO + OemToAnsi(STR0027) },oPanel,,oFont2,,,,.T.,CLR_RED,) //"- Sua Versão é " + cGetRPO + "", atualize seu sistema e retorne para baixar os arquivos CNAB."
	Endif

	RestArea(aAreaSM0)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn3

Função para construção da segunda página do wizard

@param oPanel

@author Francisco Oliveira
@since  24/07/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn3(oPanel)

	Local oRestClient	As Object
	Local aStruct		As Array
	Local cCampos		As Character
	Local cQuery		As Character
	Local cQuery2		As Character
	Local cIndex		As Character
	Local cArqInd		As Character
	Local cChave		As Character
	Local cRetRest		As Character
	Local cFuncao		As Character
	Local lJSonDes		As Logical
	Local lRet			As Logical
	Local nTcSql		As Numeric

	oRestClient	:= FWRest():New(cURLCNAB)
	aStruct		:= SA6->(DbStruct()) // Carrego a estrutura da tabela de bancos
	cQuery		:= ''
	cIndex		:= ''
	cArqInd		:= ''
	cChave		:= ''
	cRetRest	:= ''
	cFuncao		:= ''
	lJSonDes	:= .F.
	lRet		:= .T.
	nTcSql		:= 0

	oRestClient:SetPath("/valcnabati")

	If oRestClient:Get()
		cRetRest	:= oRestClient:GetResult()
	Else
		cRetRest	:= oRestClient:GetLastError()
	Endif

	lJSonDes := FWJSonDeserialize(NoACento(cRetRest),@oObjCNABAti)

	If !lJSonDes
		Aviso(OemToAnsi(STR0035), cRetRest, {"Ok"}, 3)
		lRet := .F.
	Else
		cIndex := SA6->(IndexKey())

		cCampos := TTGetStru(aStruct,"SA6")

		cQuery += " SELECT " + cCampos + "  FROM " + RetSqlName('SA6') + " SA6 "
		cQuery += " WHERE SA6.A6_FILIAL = '" + xFilial('SA6') + "' AND "
		cQuery += " SA6.A6_BLOCKED != '1' AND "

		If TCGetDB() $ "MSSQL|MSSQL7"
			cQuery += " SUBSTRING(SA6.A6_COD,1,1) IN ('0','1','2','3','4','5','6','7','8','9') AND "
		ElseIf TCGetDB() $ "ORACLE|DB2"
			cQuery += " SUBSTR(SA6.A6_COD,1,1) IN ('0','1','2','3','4','5','6','7','8','9') AND "
		Endif

		cQuery += " SA6.D_E_L_E_T_  = ' ' "
		cQuery += " ORDER BY "+ SqlOrder(cIndex)
		cQuery := ChangeQuery(cQuery)

		Aadd( aStruct, { "LEG   " , "C", 01, 0 } )
		Aadd( aStruct, { "FUNCAO" , "C", 10, 0 } )

		//Deleta a tabela tempor ria no banco de dados, caso j  exista
		If __oTmpSA6 <> Nil
			__oTmpSA6:Delete()
			__oTmpSA6 := Nil
		Endif

		// Cria‡?o da Tabela Temporária
		__oTmpSA6 := FWTemporaryTable():New( cTrabSA6 )
		__oTmpSA6:SetFields(aStruct)
		__oTmpSA6:AddIndex("1", {"A6_COD"})
		__oTmpSA6:AddIndex("2", TTFtIndex(StrToKarr(cIndex,"+"))) // Indice Ativo

		__oTmpSA6:Create()

		cQuery2 := " INSERT "
		If ALLTRIM(tcGetdb()) == "ORACLE"
			cQuery2 += " /*+ APPEND */ "
		Endif

		If AllTrim(TcGetDb()) == "DB2"
			cQuery := STRTRAN( cQuery, "FOR READ ONLY", "" )
		EndIf

		cQuery2 += " INTO "+__oTmpSA6:GetRealName()+" ("+cCampos+") " + cQuery

		Processa({|| nTcSql := TcSQLExec(cQuery2)})

		If nTcSql < 0
			Help(" ",1,"ERRO",, "Nao foi possivel montar a tabela temporaria, favor verificar o seu ambiente Protheus.",1,0) //"Nao foi possivel montar a tabela temporaria, favor verificar o seu ambiente Protheus."
		Else
			(cTrabSA6)->(DbGoTop())
			lRet := !(cTrabSA6)->(EOF())
			If !lRet
				Aviso(OemToAnsi(STR0035), OemToAnsi(STR0046), {"Ok"}, 3) //"Nao existe banco cadastrado na tabela de bancos. Favor verificar"
			EndIf
		Endif

	Endif

	If lRet
		MsgRun(OemToAnsi(STR0019),OemToAnsi(STR0020),{|| GerArrSA6(oPanel, aStruct) }) // Cria arquivo temporario -- "Cadastro de Bancos" e "Aguarde consulta a tabela de bancos..."
	Else
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0046), {"Ok"}, 3) //"Nao existe banco cadastrado na tabela de bancos. Favor verificar"
	EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn4
Função para construção da quarta página do wizard

@param oPanel

@author Francisco Oliveira
@since  24/07/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn4(oPanel)

	Local nX		As Numeric
	Local nY		As Numeric
	Local lRet		As Logical
	Local aStruct	As Array
	Local aColumns	As Array
	Local aSeek		As Array
	Local cArqInd	As Character
	Local cMarca	As Character
	Local cGetRPO	As Character

	lRet		:= .T.
	aStruct		:= {}
	aColumns	:= {}
	aSeek		:= {}
	cArqInd		:= ""
	cMarca		:= oMrkLayout:cMark
	cGetRPO		:= GetRpoRelease()

	If __oPnlAux == Nil
		__oPnlAux	:= oPanel
	Endif

	Aadd( aStruct, { "Ok"		, "C", 02, 0 } ) // OK
	Aadd( aStruct, { "CODBCO"	, "C", 03, 0 } ) // Codigo Banco
	Aadd( aStruct, { "FUNCAO"	, "C", 12, 0 } ) // Funcao Arquivo CNAB
	Aadd( aStruct, { "MODPR"	, "C", 12, 0 } ) // Funcao Arquivo CNAB
	Aadd( aStruct, { "TIPORR"	, "C", 12, 0 } ) // Funcao Arquivo CNAB
	Aadd( aStruct, { "BANCO"	, "C", 15, 0 } ) // "BANCO"
	Aadd( aStruct, { "MODULO"	, "C", 16, 0 } ) // "MODULO"
	Aadd( aStruct, { "TPOARQ"	, "C", 08, 0 } ) // "TIPO"
	Aadd( aStruct, { "VERCLI"	, "C", 08, 0 } ) // "VERSAO CLIENTE"
	Aadd( aStruct, { "VERTOT"	, "C", 08, 0 } ) // "VERSAO TOTVS"
	Aadd( aStruct, { "MARK"	 	, "C", 01, 0 } ) // "CONTROLA MARK VERSÃO"
	Aadd( aStruct, { "VERSAO"	, "C", 08, 0 } ) // "CONTROLA VERSÃO ARQUIVO"

	//Deleta a tabela tempor ria no banco de dados, caso j  exista
	If __oTmpBCO <> Nil
		__oTmpBCO:Delete()
		__oTmpBCO := Nil
	Endif

	// Cria‡?o da Tabela Temporária
	__oTmpBCO := FWTemporaryTable():New( cTrabBco )
	__oTmpBCO:SetFields(aStruct)
	__oTmpBCO:AddIndex("1", {"BANCO"})

	__oTmpBCO:Create()

	DbSelectArea("FOQ")
	FOQ->(DbSetOrder(2))
	FOQ->(DbGoTop())

	(cTrabSA6)->(DbGoTop())

	While !(cTrabSA6)->(EOF())
		If (cTrabSA6)->A6_OK == cMarca

			For nX := 1 To Len(oObjCNABAti:checkins)
				If oObjCNABAti:checkins[nX]:banco == (cTrabSA6)->(A6_COD)

					If FOQ->(DbSeek(FwxFilial("FOQ") + oObjCNABAti:Checkins[nX]:banco + PADR(oObjCNABAti:Checkins[nX]:versao,TamSX3("FOQ_VERTVS")[1],"") + oObjCNABAti:Checkins[nX]:modulo + oObjCNABAti:Checkins[nX]:tipo))
						Loop
					Else
						(cTrabBco)->(RecLock(cTrabBco, .T.))
						If cGetRPO >= oObjCNABAti:Checkins[nX]:release
							(cTrabBco)->MARK := "0"
						Else
							(cTrabBco)->MARK := "1"
						Endif

						(cTrabBco)->OK		:= (cTrabSA6)->A6_OK
						(cTrabBco)->BANCO	:= (cTrabSA6)->A6_NREDUZ
						(cTrabBco)->CODBCO	:= (cTrabSA6)->A6_COD
						(cTrabBco)->MODPR	:= oObjCNABAti:Checkins[nX]:modulo
						(cTrabBco)->MODULO	:= Iif(oObjCNABAti:Checkins[nX]:modulo = "PAG", "Contas a Pagar", "Contas a Receber")
						(cTrabBco)->TIPORR	:= oObjCNABAti:Checkins[nX]:tipo
						(cTrabBco)->TPOARQ	:= Iif(oObjCNABAti:Checkins[nX]:tipo = "REM", "Remessa","Retorno")
						(cTrabBco)->VERCLI	:= cGetRPO
						(cTrabBco)->FUNCAO	:= oObjCNABAti:Checkins[nX]:funcao
						(cTrabBco)->VERTOT	:= oObjCNABAti:Checkins[nX]:release
						(cTrabBco)->VERSAO	:= oObjCNABAti:Checkins[nX]:versao
						(cTrabBco)->(MsUnLock())
					Endif
				Endif
			Next nX
		Endif
		(cTrabSA6)->(DbSkip())
	Enddo

	For nX := 1 To Len(aStruct)
		If !aStruct[nX][1] $ "Ok|CODBCO|FUNCAO|MODPR|TIPORR|TPOARQ|VERCLI|VERTOT|MARK|VERSAO"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle(aStruct[nX][1])
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf aStruct[nX][1] $ "TPOARQ"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("TIPO ARQUIVO")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf aStruct[nX][1] $ "VERCLI"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("VERSÃO CLIENTE")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf aStruct[nX][1] $ "VERTOT"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("VERSÃO TOTVS")
			aColumns[Len(aColumns)]:SetPicture("@!")
		Endif
	Next nX

	If !__lVldBco
		__lVldBco	:= .T.
		oMrkClient:= FWMarkBrowse():New()
		oMrkClient:AddLegend("(cTrabBco)->MARK = '0'" , "GREEN"	, OemToAnsi(STR0048) ) //"Arquivo Disponivel"
		oMrkClient:AddLegend("(cTrabBco)->MARK = '1'" , "RED" 	, OemToAnsi(STR0115) ) //"Arquivo somente com atualização de Release"
		oMrkClient:oBrowse:SetEditCell(.T.)
		oMrkClient:SetFieldMark("OK")
		oMrkClient:SetOwner(oPanel)
		oMrkClient:SetAlias(cTrabBco)
		oMrkClient:SetAllMark({|| SetMrkAll(2) })
		oMrkClient:bAfterMark := {|| oMrkClient:Refresh()}
		oMrkClient:bMark	:= {|| MrkDblClk(2) }
		oMrkClient:SetDescription(OemToAnsi(STR0116)) // 'Escolha o(s) arquivo(s) de configuração CNAB'
		oMrkClient:SetColumns(aColumns)
		oMrkClient:SetSeek(.T.,aSeek)
		oMrkClient:Activate()
	Else
		If Len(__aDdsMrk) > 0
			(cTrabBco)->(DbGoTop())
			While !(cTrabBco)->(Eof())
				If (cTrabBco)->Ok == cMarca
					For nY := 1 To Len(__aDdsMrk)
						If __aDdsMrk[nY][1] == (cTrabBco)->CODBCO .And. __aDdsMrk[nY][2] = Alltrim((cTrabBco)->TIPORR) .And. __aDdsMrk[nY][3] == Alltrim((cTrabBco)->MODPR)
							(cTrabBco)->OK	:= oMrkClient:cMark
						Endif
					Next nY
				Endif
				(cTrabBco)->(DbSkip())
			Enddo
		Endif
		oMrkClient:SetAlias(cTrabBco)
	Endif

	oMrkClient:Refresh(.T.)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn5
Função para construção da quinta página do wizard

@param oPanel

@author Francisco Oliveira
@since  24/07/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn5(oPanel)

	Local lRet		As Logical
	Local cMarca	As Character

	lRet	:= .F.
	cMarca	:= oMrkClient:cMark

	(cTrabBco)->(DbGoTop())
	While !(cTrabBco)->(EOF())
		If (cTrabBco)->OK == cMarca
			Begin Transaction
				MsgRun(OemToAnsi(STR0096), OemToAnsi(STR0097), {|| lRet := CFGX049B05((cTrabBco)->CODBCO, (cTrabBco)->VERSAO, Alltrim((cTrabBco)->MODPR), Alltrim((cTrabBco)->TIPORR), Alltrim((cTrabBco)->FUNCAO) )}) //"Baixando os arquivos dos servidores Totvs"
				If !lRet
					DisarmTransaction()
					Break
				Endif
			End Transaction
		Endif
		(cTrabBco)->(DbSkip())
	Enddo

	If lRet
		aEdiCNAB	:= CFGX049B5A()

		TSay():New(020,20,{|| OemToAnsi(STR0051) },oPanel,,oFont2,,,,.T.,CLR_BLUE,  ) //"ARQUIVOS BAIXADOS COM SUCESSO"
		TSay():New(040,20,{|| OemToAnsi(STR0052) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) //"Os próximos passos serão para edição de campos específicos."
		TSay():New(060,20,{|| OemToAnsi(STR0093) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) //"Caso deseje editar os arquivos de configuração CNAB, clique em Avançar."   --
		TSay():New(080,20,{|| OemToAnsi(STR0094) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) //"Para encerrar o processo e gerar os arquivos de configuração CNAB na pasta system, clique em Finalizar."
		TSay():New(100,20,{|| OemToAnsi(STR0095) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) //"Se necessário, faça o backup dos seus arquivos de configuração CNAB em uso."
	Else
		TSay():New(020,20,{|| OemToAnsi(STR0153) },oPanel,,oFont2,,,,.T.,CLR_RED,  ) //"ARQUIVOS NÃO FORAM BAIXADOS COM SUCESSO"
		TSay():New(040,20,{|| OemToAnsi(STR0154) },oPanel,,oFont2,,,,.T.,CLR_RED,50) //"Houve falha ao gravar as tabelas de controle dos arquivos de configuração CNAB."
	Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn6
Função para construção da segunda sexta do wizard

@param oPanel

@author Francisco Oliveira
@since  31/08/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn6(oPanel, __nCtrlFor)

	Local nY		As Numeric
	Local nX		As Numeric
	Local aStruct	As Array
	Local aColumns	As Array
	Local aStrFOP	As Array
	Local cMarca	As Character
	Local cAlsFOP	As Character
	Local cAlsDes	As Character
	Local cDesMov	As Character
	Local cQryFOP	As Character
	Local cPagRec	As Character
	Local cRemRet	As Character

	Default __nCtrlFor	:= 1

	aStruct		:= {}
	aColumns	:= {}
	aStrFOP		:= {}
	cMarca		:= oMrkEdit:cMark
	cAlsFOP		:= ""
	cAlsDes		:= ""
	cDesMov		:= ""
	cQryFOP		:= ""
	cPagRec		:= ""
	cRemRet		:= ""

	(cTrabEdi)->(DbGoTop())
	While !(cTrabEdi)->(Eof())
		If (cTrabEdi)->OK == cMarca
			aadd(aStrFOP, {(cTrabEdi)->OK, Alltrim((cTrabEdi)->CODBCO), Alltrim((cTrabEdi)->PAGREC), Alltrim((cTrabEdi)->REMRET), (cTrabEdi)->VERSAO })
		Endif
		(cTrabEdi)->(DbSkip())
	EndDo

	nCtrPrev	:= Len(aStrFOP)

	For nY := __nCtrlFor To Len(aStrFOP)

		cAlsFOP	:= GetNextAlias()

		cPagRec	:= Iif(SubStr(aStrFOP[nY,3],1,3) == "PAG", "PAG", "REC")
		cRemRet	:= Iif(SubStr(aStrFOP[nY,4],1,3) == "REM", "REM", "RET")

		cQryFOP	:= " SELECT FOP_FILIAL, FOP_CODIGO, FOP_IDELIN, FOP_HEADET, FOP_CHALIN, FOP_IDESEG, FOP_BANCO, FOP_DESSEG, FOP_POSINI, FOP_POSFIM, FOP_DECIMA, "
		cQryFOP	+= " FOP_DESMOV, FOP_CONARQ, FOP_VERARQ, FOP_BLOQUE ,FOP_EDITAD ,FOP_DTGRAV ,FOP_PAGREC ,FOP_REMRET ,FOP_SEQUEN ,FOP_CTREDI ,FOP_CTDEDI ,FOP_NEWVLR "
		cQryFOP	+= " FROM " + RetSQLName("FOP") + " FOP "
		cQryFOP	+= " WHERE "
		cQryFOP	+= " FOP_BLOQUE  = '2' 							AND "
		cQryFOP	+= " FOP_CTREDI  = '1' 							AND "
		cQryFOP	+= " FOP_PAGREC  = '" + cPagRec 		+ "'	AND "
		cQryFOP	+= " FOP_REMRET  = '" + cRemRet 		+ "' 	AND "
		cQryFOP	+= " FOP_BANCO   = '" + aStrFOP[nY,2]	+ "' 	AND "
		cQryFOP	+= " FOP_VERARQ  = '" + aStrFOP[nY,5]	+ "' 	AND "
		cQryFOP	+= " FOP.D_E_L_E_T_ = ' ' "

		cQryFOP := ChangeQuery(cQryFOP)
		DbUseArea(.T., "TOPCONN", TcGenQry(,,cQryFOP), cAlsFOP)

		aDdsEdit := {}

		While !(cAlsFOP)->(Eof())

			cAlsDes	:= GetNextAlias()

			cQryFOP	:= ""

			cQryFOP	:= " SELECT FOP_DESMOV "
			cQryFOP	+= " FROM " + RetSQLName("FOP") + " FOP "
			cQryFOP	+= " WHERE "
			cQryFOP	+= " FOP_BLOQUE = '2' AND "
			cQryFOP	+= " FOP_IDELIN = '1' AND "
			cQryFOP	+= " FOP_BANCO  = '" + (cAlsFOP)->FOP_BANCO  + "' 	AND "
			cQryFOP	+= " FOP_HEADET = '" + (cAlsFOP)->FOP_HEADET + "' 	AND "
			cQryFOP	+= " FOP_CHALIN = '" + (cAlsFOP)->FOP_CHALIN + "' 	AND "
			cQryFOP	+= " FOP_IDESEG = '" + (cAlsFOP)->FOP_IDESEG + "' 	AND "
			cQryFOP	+= " FOP_PAGREC = '" + (cAlsFOP)->FOP_PAGREC + "' 	AND "
			cQryFOP	+= " FOP_REMRET = '" + (cAlsFOP)->FOP_REMRET + "' 	AND "
			cQryFOP	+= " FOP.D_E_L_E_T_ = ' ' "

			cQryFOP := ChangeQuery(cQryFOP)
			DbUseArea(.T., "TOPCONN", TcGenQry(,,cQryFOP), cAlsDes)

			cDesMov := (cAlsDes)->FOP_DESMOV

			(cAlsDes)->(DbCloseArea())

			aADD(aDdsEdit,{;
				(cAlsFOP)->FOP_BANCO			,;	// Banco - 01
			(cAlsFOP)->FOP_POSINI			,; 	// Posição Inical - 02
			(cAlsFOP)->FOP_POSFIM			,; 	// Posição Final - 03
			(cAlsFOP)->FOP_DESSEG			,; 	// Descrição do Segmento - 04
			SPACE(40)							,; 	// Campo Novo Valor - 05
			Alltrim((cAlsFOP)->FOP_DESMOV)	,; 	// Descrição do Movimento - 06
			(cAlsFOP)->FOP_SEQUEN			,; 	// Sequencia - 07
			(cAlsFOP)->FOP_VERARQ			,; 	// Versão - 08
			(cAlsFOP)->FOP_PAGREC			,; 	// Pagar ou Receber - 09
			(cAlsFOP)->FOP_REMRET			,; 	// Remessa ou Retorno - 10
			Alltrim((cAlsFOP)->FOP_NEWVLR)	,; 	// Valor A ser Alterado - 11
			Alltrim((cAlsFOP)->FOP_CTDEDI)	,;	// Valor a ser escolhido para alterar o campo anterior - 12
			Alltrim(cDesMov)     			,;	// Descrição do Movimento - 13
			AllTrim((cAlsFOP)->FOP_CONARQ)  }) // Descrição do conteudo do arquivo - 14

			(cAlsFOP)->(DbSkip())
		EndDo
		Exit
	Next nY

	CFGX049B01(aDdsEdit, oPanel,__nCtrlFor, nCtrPrev )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn7
Função para construção da setima página do wizard

@param oPanel

@author Francisco Oliveira
@since  31/08/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn7(oPanel)

	TSay():New(020,20,{|| OemToAnsi(STR0051) },oPanel,,oFont2,,,,.T.,CLR_BLUE,)   // //"ARQUIVOS BAIXADOS COM SUCESSO"
	TSay():New(040,20,{|| OemToAnsi(STR0098) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) // "É necessário que os Parâmetros de Bancos estejam configurados para cada banco."
	TSay():New(060,20,{|| OemToAnsi(STR0106) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) // "Recomendamos efetuar uma primeira homologação junto ao seu banco."
	TSay():New(160,20,{|| OemToAnsi(STR0107) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) // "Para maiores informações e consulta as documentações dos Arquivos CNAB, acesse:"
	TSay():New(170,20,{|| OemToAnsi(STR0108) },oPanel,,oFont2,,,,.T.,CLR_BLUE,50) // "http://www.tdn.totvs.com.br"

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} cria_pn8
Função para construção da oitava página do wizard

@param oPanel

@author Francisco Oliveira
@since  23/11/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function cria_pn8(oPanel)

	Local nX		As Numeric
	Local lRet		As Logical
	Local cMarca	As Character
	Local aStruct	As Array
	Local aColumns	As Array
	Local aSeek		As Array
	Local cAlsFOP	As Character
	Local cPagRec	As Character
	Local cRemRet	As Character
	Local cNomeBco	As Character

	lRet		:= .F.
	cMarca		:= oMrkClient:cMark
	aStruct		:= {}
	aColumns	:= {}
	aSeek		:= {}
	cAlsFOP		:= ""
	cPagRec		:= ""
	cRemRet		:= ""
	cNomeBco	:= ""

	GerArqCFG(2)

	aADD( aStruct, { "Ok"	  	, "C", 002, 0 } )
	aADD( aStruct, { "CODBCO"  	, "C", 003, 0 } )
	aADD( aStruct, { "BANCO"  	, "C", 020, 0 } )
	aADD( aStruct, { "PAGREC" 	, "C", 010, 0 } )
	aADD( aStruct, { "REMRET"	, "C", 010, 0 } )
	aADD( aStruct, { "VERSAO"	, "C", 010, 0 } )

	//Deleta a tabela tempor ria no banco de dados, caso j  exista
	If __oTmpEDI <> Nil
		__oTmpEDI:Delete()
		__oTmpEDI := Nil
	Endif

	// Cria‡?o da Tabela Temporária
	__oTmpEDI := FWTemporaryTable():New( cTrabEdi )
	__oTmpEDI:SetFields(aStruct)
	__oTmpEDI:AddIndex("1", {"BANCO"})

	__oTmpEDI:Create()

	(cTrabBco)->(DbGoTop())
	While !(cTrabBco)->(EOF())
		If (cTrabBco)->OK == cMarca

			cAlsFOP	:= GetNextAlias()

			cQryFOP	:= " SELECT  * "
			cQryFOP	+= " FROM " + RetSQLName("FOP") + " FOP "
			cQryFOP	+= " WHERE "
			cQryFOP	+= " FOP_BLOQUE  = '2' 										AND "
			cQryFOP	+= " FOP_CTREDI  = '1' 										AND "
			cQryFOP	+= " FOP_PAGREC  = '" + Alltrim((cTrabBco)->MODPR) 	+ "'	AND "
			cQryFOP	+= " FOP_REMRET  = '" + Alltrim((cTrabBco)->TIPORR) + "' 	AND "
			cQryFOP	+= " FOP_BANCO   = '" + (cTrabBco)->CODBCO			+ "' 	AND "
			cQryFOP	+= " FOP_VERARQ  = '" + (cTrabBco)->VERSAO			+ "' 	AND "
			cQryFOP	+= " FOP.D_E_L_E_T_ = ' ' "

			cQryFOP := ChangeQuery(cQryFOP)
			DbUseArea(.T., "TOPCONN", TcGenQry(,,cQryFOP), cAlsFOP)

			If !(cAlsFOP)->(Eof())

				cNomeBco	:= Posicione("SA6", 1, xFilial("SA6") + Alltrim((cTrabBco)->CODBCO), "A6_NREDUZ")

				(cTrabEdi)->(RecLock(cTrabEdi, .T.))
				(cTrabEdi)->OK		:= ""
				(cTrabEdi)->CODBCO	:= Alltrim((cTrabBco)->CODBCO)
				(cTrabEdi)->BANCO		:= cNomeBco
				(cTrabEdi)->PAGREC	:= Iif(Alltrim((cTrabBco)->MODPR)  == "PAG", "PAGAR", "RECEBER" )
				(cTrabEdi)->REMRET	:= Iif(Alltrim((cTrabBco)->TIPORR) == "REM", "REMESSA", "RETORNO" )
				(cTrabEdi)->VERSAO	:= Alltrim((cTrabBco)->VERSAO)
				(cTrabEdi)->(MsUnLock())

			Endif
		Endif
		(cTrabBco)->(DbSkip())
	Enddo

	For nX := 1 To Len(aStruct)
		If aStruct[nX][1] $ "BANCO"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle(OemToAnsi(STR0031)) // BANCO
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf aStruct[nX][1] $ "PAGREC"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle(OemToAnsi(STR0100)) //"PAGAR/RECEBER"
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf aStruct[nX][1] $ "REMRET"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle(OemToAnsi(STR0101)) //"REMESSA/RETORNO"
			aColumns[Len(aColumns)]:SetPicture("@!")
		Endif
	Next nX

	oMrkEdit:= FWMarkBrowse():New()

	oMrkEdit:oBrowse:SetEditCell(.T.)
	oMrkEdit:SetFieldMark("OK")
	oMrkEdit:SetOwner(oPanel)
	oMrkEdit:SetAlias(cTrabEdi)
	oMrkEdit:SetAllMark({|| SetMrkAll(3) })
	oMrkEdit:bAfterMark := {|| oMrkEdit:Refresh()}
	oMrkEdit:bMark	:= {|| .T. }
	oMrkEdit:SetDescription(OemToAnsi(STR0054)) // 'Escolha o(s) arquivo(s) CNAB para edição'
	oMrkEdit:SetColumns(aColumns)
	oMrkEdit:SetSeek(.T.,aSeek)
	oMrkEdit:Activate()

Return lRet

//-------------------------------------------------------------------

/*/{Protheus.doc} Valid_PG1()

Verifica se algum banco foi marcado para baixa de arquivo
@author Francisco Oliveira
@since  10/08/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function Valid_PG1()

	Local cMarca	As Character
	Local lRet		As Logical

	cMarca	:= oMrkLayout:cMark
	lRet	:= .F.

	If __lVldBco
		cria_pn4(__oPnlAux)
	Endif

	(cTrabSA6)->(DbGoTop())
	While !(cTrabSA6)->(EOF())
		If (cTrabSA6)->A6_OK == cMarca
			lRet := .T.
			Exit
		Endif
		(cTrabSA6)->(DbSkip())
	Enddo

	If !lRet
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0038), {"Ok"}, 3) // "Atenção" // "Nenhum Banco foi Marcado para Geração de Arquivo. Necessario escolher banco"
	Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Valid_PG2

Valida se cliente poderá continuar com o processo
@author Francisco Oliveira
@since  10/08/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function Valid_PG2()

	Local lRet	As Logical

	lRet	:= .T.

	If lVldVer
		If !lVldAces
			Aviso(OemToAnsi(STR0035), OemToAnsi(STR0117), {"Ok"},3) // "CNPJ não é Valido ou não tem acesso aos nossos serviços de hardlock."
			lRet	:= .F.
		Endif
	Else
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0118), {"Ok"},3) // "Necessario atualização de release do sistema."
		lRet	:= .F.
	Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Valid_PG3

Valida se cliente poderá continuar com o processo
@author Francisco Oliveira
@since  10/08/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function Valid_PG3()

	Local lRet		As Logical
	Local cMarca	As Character

	lRet	:= .F.
	cMarca	:= oMrkClient:cMark

	(cTrabBco)->(DbGoTop())

	While !(cTrabBco)->(EOF())
		If (cTrabBco)->OK == cMarca
			lRet	:= .T.
			Exit
		Endif
		(cTrabBco)->(DbSkip())
	Enddo

	If !lRet
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0038), {"Ok"}, 3) // "Atenção" // "Nenhum Banco foi Marcado para Geração de Arquivo. Necessario escolher banco"
	Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} SetMrkAll
Função para execução do MarkAll da MarkBrowse

@author Francisco Oliveira
@since  24/07/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function SetMrkAll(nTrab As Numeric)

	Local aArea 	As Array
	Local cMarca	As Character

	Default nTrab := 0

	aArea	:= GetArea()
	cMarca	:= ''

	If nTrab == 1
		aArea := (cTrabSA6)->(GetArea())
		(cTrabSA6)->(DbGoTop())
		If lSA6Mrk
			cMarca := ''
			lSA6Mrk := .F.
		Else
			cMarca := oMrkLayout:cMark
			lSA6Mrk := .T.
		EndIf

		While !(cTrabSA6)->(Eof())
			If (cTrabSA6)->LEG = "2" .Or. (cTrabSA6)->LEG = "3"
				(cTrabSA6)->A6_OK := cMarca
			Endif
			(cTrabSA6)->(DbSkip())
		EndDo
		RestArea(aArea)
		oMrkLayout:Refresh()
	ElseIf nTrab == 2
		aArea := (cTrabBco)->(GetArea())
		(cTrabBco)->(DbGoTop())
		If lBcoMrk
			cMarca := ''
			lBcoMrk := .F.
		Else
			cMarca := oMrkClient:cMark
			lBcoMrk := .T.
		EndIf

		While !(cTrabBco)->(Eof())
			If (cTrabBco)->MARK == "1"
				(cTrabBco)->OK := ""
			Else
				(cTrabBco)->OK := cMarca
			Endif
			(cTrabBco)->(DbSkip())
		EndDo
		RestArea(aArea)
		oMrkClient:Refresh()
	ElseIf nTrab == 3
		(cTrabEdi)->(DbGoTop())
		If lEdiMrk
			cMarca := ''
			lEdiMrk := .F.
		Else
			cMarca := oMrkEdit:cMark
			lEdiMrk := .T.
		EndIf

		While !(cTrabEdi)->(Eof())
			(cTrabEdi)->(RecLock(cTrabEdi, .F.))
			(cTrabEdi)->OK := cMarca
			(cTrabEdi)->(MsUnLock())
			(cTrabEdi)->(DbSkip())
		EndDo
		RestArea(aArea)
		oMrkEdit:Refresh()
	EndIf

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} MrkDblClk
Função para validação de Marca.

@author Francisco Oliveira
@since  14/08/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function MrkDblClk(nPos As Numeric) As Logical

	Local lRet		As Logical
	Local cMarca 	As Character
	Local cLegenda	As Character

	Default nPos := 0

	lRet		:= .T.
	cMarca 		:= ""
	cLegenda	:= ""

	If nPos == 1
		cLegenda	:= (cTrabSA6)->(LEG)
		If cLegenda == "1"
			Aviso(OemToAnsi(STR0035), OemToAnsi(STR0055), {"Ok"}, 3) //"Este arquivo ja esta atualizado"
			lRet	:= .F.
		ElseIf Empty(cLegenda)
			Aviso(OemToAnsi(STR0035), OemToAnsi(STR0056), {"Ok"}, 3) //"Este arquivo não esta Disponivel"
			lRet	:= .F.
		ElseIf cLegenda == "2" .Or. cLegenda == "3"
			If nPos == 1
				If lSA6Mrk
					cMarca := ''
					lSA6Mrk := .F.
				Else
					cMarca := oMrkLayout:cMark
					lSA6Mrk := .T.
				EndIf
			Endif
		Endif
		(cTrabSA6)->(RecLock(cTrabSA6, .F.))
		(cTrabSA6)->A6_OK := cMarca
		(cTrabSA6)->(MsUnLock())
		oMrkLayout:Refresh()
	ElseIf nPos == 2
		cMarca := oMrkClient:cMark
		cLegenda	:= (cTrabBco)->MARK
		If cLegenda == "1"
			Aviso(OemToAnsi(STR0035), OemToAnsi(STR0102) + (cTrabBco)->VERTOT , {"Ok"}, 3) //"Para baixar este arquivo é necessario atualizar sua release. Somente para a release: "
			lRet	:= .F.
			(cTrabBco)->(RecLock(cTrabBco, .F.))
			(cTrabBco)->OK := ""
			(cTrabBco)->(MsUnLock())
			oMrkClient:Refresh()
		Else
			If (cTrabBco)->OK == ""
				If lSA6Mrk2
					cMarca := ''
					lSA6Mrk2 := .F.
				Else
					cMarca := oMrkClient:cMark
					lSA6Mrk2 := .T.
				EndIf
			ElseIf (cTrabBco)->OK == cMarca
				If lSA6Mrk2
					cMarca := ''
					lSA6Mrk2 := .F.
				Else
					cMarca := oMrkClient:cMark
					lSA6Mrk2 := .T.
				EndIf
			ElseIf (cTrabBco)->OK != cMarca .And. (cTrabBco)->MARK = "0" .And. (cTrabBco)->OK != ""
				If lSA6Mrk2
					cMarca := ''
					lSA6Mrk2 := .F.
				Else
					cMarca := oMrkClient:cMark
					lSA6Mrk2 := .T.
				EndIf
			Endif
			(cTrabBco)->(RecLock(cTrabBco, .F.))
			(cTrabBco)->OK := cMarca
			(cTrabBco)->(MsUnLock())
			oMrkClient:Refresh()
		Endif
	Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GerArqCFG()
Função para gerar os arquivos de configuração CNAB na pasta system

@author Francisco Oliveira
@since  30/11/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function GerArqCFG(nOrig As Numeric) As Logical

	Local lRet 		As Logical
	Local cMarca 	As Object

	Default nOrig := 0

	lRet := .T.
	cMarca 	:= oMrkClient:cMark

	If nOrig == 1
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0103), {"Ok"}, 3) // "Todos os arquivos de configuração CNAB serão gerados na pasta System."
	Endif

	(cTrabBco)->(DbGoTop())

	Begin Transaction

		While !(cTrabBco)->(Eof())
			If (cTrabBco)->OK == cMarca
				MsgRun(OemToAnsi(STR0096),OemToAnsi(STR0104), {|| lRet := CFGX049B08((cTrabBco)->CODBCO, (cTrabBco)->VERSAO, Alltrim((cTrabBco)->MODPR), Alltrim((cTrabBco)->TIPORR) ) }) // "Gerando os arquivos de Configuração CNAB"
			Endif
			(cTrabBco)->(DbSkip())
		Enddo

	End Transaction

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Valid_PG4()
Rotina de validação de mark browse vazio

@author Francisco Oliveira
@since  12/12/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function Valid_PG4()

	Local lRet	As Logical

	lRet	:= .F.

	(cTrabEdi)->(DbGoTop())
	While !(cTrabEdi)->(Eof())
		If ! Empty((cTrabEdi)->OK)
			lRet := .T.
		Endif
		(cTrabEdi)->(DbSkip())
	EndDo

	If !lRet
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0105), {"Ok"}, 3) // "Nenhum arquivo foi selecionado. Favor escolher arquivo para edição ou clique em cancelar"
	Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Prev_pn4()
Rotina de validação do botão de retorno e controle dos mark marcados

@author Francisco Oliveira
@since  12/12/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function Prev_pn4()

	Local cMarca	As Character

	cMarca	:= oMrkClient:cMark

	oMrkLayout:Refresh(.T.)
	__aDdsMrk	:= {}
	(cTrabBco)->(DbGoTop())
	While !(cTrabBco)->(Eof())
		If (cTrabBco)->OK == cMarca
			aAdd(__aDdsMrk, {(cTrabBco)->CODBCO, Alltrim((cTrabBco)->TIPORR), Alltrim((cTrabBco)->MODPR), Alltrim(cMarca) })
		Endif
		(cTrabBco)->(DbSkip())
	Enddo

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} GerArrSA6()
Rotina de geração de array para os possiveis bancos de baixa de arquivo

@author Francisco Oliveira
@since  12/12/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function GerArrSA6(oPanel, aStruct)

	Local nX		As Numeric
	Local aAreaFOQ	As Array
	Local lVldSeek	As Logical
	Local lGrvTMP	As Logical
	Local lAchou	As Logical
	Local lNAchou	As Logical
	Local cSeekReg	As Character
	Local aSeek		As Array
	Local aColumns	As Array
	Local aBancos	As Array

	aAreaFOQ	:= FOQ->(GetArea())
	lVldSeek	:= .T.
	lGrvTMP		:= .T.
	lAchou		:= .T.
	lNAchou		:= .T.
	cSeekReg	:= ''
	aSeek		:= {}
	aColumns	:= {}
	aBancos		:= {}

	DbSelectArea("FOQ")
	FOQ->(DbSetOrder(2))
	FOQ->(DbGoTop())

	(cTrabSA6)->(DbGoTop())

	While !(cTrabSA6)->(Eof())

		lGrvTMP	:= .F.
		// Busca por Codigos de Bancos j  processados
		If aScan(aBancos,(cTrabSA6)->A6_COD) > 0
			(cTrabSA6)->(DbDelete())
			(cTrabSA6)->(DbSkip())
			Loop
		Else
			// Cache de bancos processados.
			aAdd(aBancos,(cTrabSA6)->A6_COD)
		EndIf

		For nX := 1 To Len(oObjCNABAti:checkins)

			If (cTrabSA6)->A6_COD != cSeekReg .And. lVldSeek
				cSeekReg	:= oObjCNABAti:Checkins[nX]:banco
				cFuncao		:= oObjCNABAti:checkins[nX]:funcao
				lVldSeek	:= .F.
				lAchou		:= .F.
				lNAchou		:= .F.
			Endif

			If oObjCNABAti:checkins[nX]:banco == (cTrabSA6)->(A6_COD)
				lGrvTMP	:= .T.

				If lGrvTMP
					If FOQ->(DbSeek(FwxFilial("FOQ") + oObjCNABAti:Checkins[nX]:banco + PADR(oObjCNABAti:Checkins[nX]:versao, TAMSX3("FOQ_VERTVS")[1],"") + oObjCNABAti:Checkins[nX]:modulo + oObjCNABAti:Checkins[nX]:tipo))
						lAchou		:= .T.
					Else
						lNAchou	:= .T.
					Endif
				Endif
			Endif
		Next nX

		(cTrabSA6)->(RecLock(cTrabSA6, .F.))

		If !lAchou .And. !lNAchou
			(cTrabSA6)->LEG	:= " " //"Arquivo Sem Atualização"
		Elseif !lAchou .And. lNAchou
			(cTrabSA6)->LEG	:= "2" //"Arquivo Disponivel"
		Elseif lAchou .And. lNAchou
			(cTrabSA6)->LEG	:= "3" //"Existe Novo Arquivo Disponivel"
		Elseif lAchou .And. !lNAchou
			(cTrabSA6)->LEG	:= "1" //"Arquivo Atualizado"
		Endif

		(cTrabSA6)->(MsUnLock())
		(cTrabSA6)->(DbSkip())

		lVldSeek	:= .T.
	Enddo

	For nX := 1 To Len(aStruct)
		If	aStruct[nX][1] $ 'A6_FILIAL|A6_COD|A6_NOME|A6_NREDUZ'
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &('{||'+aStruct[nX][1]+'}') )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle(RetTitle(aStruct[nX][1]))
			aColumns[Len(aColumns)]:SetPicture(PesqPict('SA6',aStruct[nX][1]))
		EndIf
	Next nX

	AAdd(aSeek,{"Bancos",{{"A6_NREDUZ","C",TamSX3("A6_NREDUZ")[1],0,"",""}},1})

	oMrkLayout:= FWMarkBrowse():New()

	oMrkLayout:AddLegend("LEG = '1'"                , "GREEN", OemToAnsi(STR0047) ) //"Arquivo Atualizado"
	oMrkLayout:AddLegend("LEG = '2' .Or. LEG = '3'" , "BLUE" , OemToAnsi(STR0048) ) //"Arquivo Disponivel"
	oMrkLayout:AddLegend("LEG = ' '"                , "RED"  , OemToAnsi(STR0049) ) //"Arquivo Sem Atualização"

	oMrkLayout:oBrowse:SetEditCell(.T.)
	oMrkLayout:SetFieldMark("A6_OK")
	oMrkLayout:SetOwner(oPanel)
	oMrkLayout:SetAlias(cTrabSA6)
	oMrkLayout:SetAllMark({|| SetMrkAll(1) })
	oMrkLayout:bAfterMark := {|| oMrkLayout:Refresh()}
	oMrkLayout:bMark	:= {|| MrkDblClk(1) }
	oMrkLayout:SetDescription(OemToAnsi(STR0092)) //'Escolha o(s) banco(s)'
	oMrkLayout:SetColumns(aColumns)
	oMrkLayout:SetSeek(.T.,aSeek)
	oMrkLayout:Activate()

	RestArea(aAreaFOQ)

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} ClearTMP()
//Limpa tabelas temporarias, caso existam

@author Leonardo Castro da Silva
@since  30/05/2018
@version 12.1.020
/*/
//-------------------------------------------------------------------
Static Function ClearTMP()

	If __oTmpSA6 <> Nil
		__oTmpSA6:Delete()
		__oTmpSA6 := Nil
	Endif

	If __oTmpBCO <> Nil
		__oTmpBCO:Delete()
		__oTmpBCO := Nil
	Endif

	If __oTmpEDI <> Nil
		__oTmpEDI:Delete()
		__oTmpEDI := Nil
	Endif

Return