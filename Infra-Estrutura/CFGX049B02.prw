#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#Include 'CFGX049B.CH'

/*/ {Protheus.doc} CFGX049B02()
Função que realiza a criação da tela de cadastro da tabea tela de cadastro da tabela FOQ.
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  CFGX049B02
@Return
@param
*/
Function CFGX049B02()
	
	Local oBrowse	:= NIL
	
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'FOQ' )
	oBrowse:SetDescription(OemToAnsi(STR0042)) // "Cadastro de Versão de Arquivos CNAB"
	
	//Legenda
	oBrowse:AddLegend("FOQ_BLOQUE = '1'", "RED"  , OemToAnsi(STR0074) ) //"Arquivo Bloqueado"
	oBrowse:AddLegend("FOQ_BLOQUE = '2'", "GREEN", OemToAnsi(STR0048) ) //"Arquivo Disponivel"
	
	oBrowse:Activate()
	
Return Nil

/*/ {Protheus.doc} MenuDef()
Função que incluí as opções do menu na tela de cadastro da tabela FOQ
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  MenuDef()
@Return	aRotina: Objeto com todas as opções inseridas no menu.
@param
*/

Static Function MenuDef()
	
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE OemToAnsi(STR0043)	ACTION 'VIEWDEF.CFGX049B02'	OPERATION 2 ACCESS 0 // "Visualizar"
	ADD OPTION aRotina TITLE OemToAnsi(STR0061)	ACTION 'CFGX049B2F(3)'		OPERATION 3 ACCESS 0 // "Incluir"
	ADD OPTION aRotina TITLE OemToAnsi(STR0044)	ACTION 'CFGX049B2F(4)'		OPERATION 4 ACCESS 0 // "Editar Arquivo"
	ADD OPTION aRotina TITLE OemToAnsi(STR0063)	ACTION 'CFGX049B2F(5)'		OPERATION 5 ACCESS 0 // "Excluir"
	ADD OPTION aRotina TITLE OemToAnsi(STR0125)	ACTION 'CFGX049B2E()'       OPERATION 6 ACCESS 0 // "Editar Cpos Padrão"
	ADD OPTION aRotina TITLE OemToAnsi(STR0126)	ACTION 'CFGX049()' 			OPERATION 7 ACCESS 0 // "Editar Arquivo CFG"
	ADD OPTION aRotina TITLE OemToAnsi(STR0075)	ACTION 'CFGX049B2B()' 		OPERATION 8 ACCESS 0 // "Gerar Arq. CNAB"
	ADD OPTION aRotina TITLE OemToAnsi(STR0076)	ACTION 'CFGX049B2C()' 		OPERATION 9 ACCESS 0 // "Habilitar Arquivo"
	
Return aRotina

/*/ {Protheus.doc} ModelDef()
Função que realiza o tratamento de toda a camada de negócio para Visualização da tabela FOQ.
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  ModelDef()
@Return	oModel: Objeto com todos os campos do modelo de dados.
@param
*/

Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStruFOQ 	:= FWFormStruct( 1, 'FOQ')
	
	oModel := MPFormModel():New( 'CFGX049X02')
	oModel:AddFields( 'FOQMASTER', /*cOwner*/, oStruFOQ )
	oModel:SetPrimaryKey( { "FOQ_FILIAL", "FOQ_CODIGO" } )
	oModel:SetDescription(OemToAnsi(STR0042))
	oModel:GetModel("FOQMASTER"):SetDescription(OemToAnsi(STR0059)) //"Cadastro Versão de Arquivos"
	
Return oModel

/*/ {Protheus.doc} Viewdef()
Função que realiza o tratamento de toda a camada de visualização da tabela FOQ.
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  Viewdef()
@Return	oView: Objeto com todos os campos para a criação da tela
@param
*/

Static Function Viewdef()
	
	Local oModel   := FWLoadModel( 'CFGX049B02' )
	Local oStruFOQ := FWFormStruct( 2, 'FOQ')
	Local oView    := FWFormView():New()
	
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_FOQ',	oStruFOQ, 'FOQMASTER' )
	oView:CreateHorizontalBox('FOQFIELD', 100)
	oView:SetOwnerView('VIEW_FOQ','FOQFIELD')
	
Return oView

/*/ {Protheus.doc} Viewdef()
Função que grava a tabela FOQ atraves de EXECAUTO MVC.
@author	Francisco Oliveira
@since		14/08/2017
@version	P12
@Function  Viewdef()
@Return	oView: Objeto com todos os campos para a gravação da tabela
@param
*/

Function CFGX049B2A(aArrayFOQ)
	
	Local oModel  	:= Nil
	Local nX		:= 0
	Local lRet		:= .F.
	Local cCodigo	:= ""
	
	DEFAULT aArrayFOQ	:= {}
	
	oModel := FWLoadModel("CFGX049B02")
	
	oModel:SetOperation(3)
	oModel:Activate()
	
	If Len(aArrayFOQ) > 0
		For nX := 1 To Len(aArrayFOQ)
			oModel:SetValue("FOQMASTER",aArrayFOQ[nX,1],aArrayFOQ[nX,2])
		Next nX
		
		If oModel:VldData()
			oModel:CommitData()
			lRet	:= .T.
		EndIf
		oModel:DeActivate(.T.)
	Endif
	
Return lRet

/*/ {Protheus.doc} CFGX049B2B()
Função que irá gerar novamente arquivos de configuração CNAB
@author	Francisco Oliveira
@since		10/10/2017
@version	P12
@Function  Viewdef()
@Return	.T.
@param
*/

Function CFGX049B2B()
	
	Local aAlias	:= GetArea()
	Local cCodigo	:= FOQ->FOQ_CODIGO
	
	If FOQ->FOQ_BLOQUE == "1"
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0077), {"Ok"}, 3 ) //"Este Arquivo esta Bloqueado para uso. Será necessario executar a rotina de 'Habilitar Arquivos'."
		Return()
	Endif
	
	If Aviso(OemToAnsi(STR0035), OemToAnsi(STR0078) + FOP->FOP_BANCO + OemToAnsi(STR0079), {"Sim", "Nao"}, 3 ) == 2 //"Esta Rotina Irá Gerar Novamente o Arquivo CNAB, Banco " -- ". Deseja Continuar?"
		Return()
	Endif
	
	DbSelectArea("FOP")
	FOP->(DbSetOrder(1))
	FOP->(DbGoTop())
	
	If FOP->(DbSeek(xFilial("FOP") + cCodigo ))
		Processa({|| lRet := CFGX049B08(FOP->FOP_BANCO, FOP->FOP_VERARQ, FOP->FOP_PAGREC, FOP->FOP_REMRET)}, OemToAnsi(STR0080) ) //"Processando Arquivos de Configuração"
	Endif
	
	RestArea(aAlias)
	
Return

/*/ {Protheus.doc} CFGX049B2C()
Função que irá habilitar arquivos de configuração CNAB
@author	Francisco Oliveira
@since		10/10/2017
@version	P12
@Function  Viewdef()
@Return	.T.
@param
*/

Function CFGX049B2C()
	
	Local aAlias	:= GetArea()
	Local cCodigo	:= FOQ->FOQ_CODIGO
	Local cBanco	:= FOQ->FOQ_BANCO
	Local cPgRec	:= FOQ->FOQ_PGRECT
	Local cEnRet	:= FOQ->FOQ_ENRETT
	Local cVersao	:= FOQ->FOQ_VERTVS
	Local cAlsQry	:= GetNextAlias()
	Local cQuery	:= ""
	Local cCodFOP	:= ""
	
	DbSelectArea("FOQ"); FOQ->(DbSetOrder(1))
	
	If FOQ->FOQ_BLOQUE == "2"
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0127), {"Ok"}, 3) // "Este arquivo não esta bloqueado. Esta rotina deve ser executada somente quando arquivo bloqueado."
		Return
	Endif
	
	If Aviso(OemToAnsi(STR0035), OemToAnsi(STR0081) + cBanco + OemToAnsi(STR0082) + cVersao + OemToAnsi(STR0083) + cPgRec + OemToAnsi(STR0084) + cEnRet + OemToAnsi(STR0085), {"Sim", "Nao"}, 3 ) == 2 //"O Arquivo CNAB Banco " -- ", Versão " -- ", Modulo a " -- " e Tipo " -- " Será Bloqueado. Deseja Continuar?"
		Return()
	Endif
	
	If FOQ->FOQ_BLOQUE == "1"
		
		Begin Transaction
			
			cQuery	:= " SELECT FOP_CODIGO, R_E_C_N_O_ AS _nRECNO "
			cQuery	+= " FROM " + RETSQLNAME("FOP") + " FOP "
			cQuery	+= " WHERE "
			cQuery	+= " FOP_FILIAL  = '" + xFilial("FOP") + "' AND "
			cQuery	+= " FOP_BLOQUE  = '2' AND "
			cQuery	+= " FOP_BANCO   = '" + cBanco  + "' AND "
			cQuery	+= " FOP_PAGREC  = '" + cPgRec  + "' AND "
			cQuery	+= " FOP_REMRET  = '" + cEnRet  + "' AND "
			cQuery	+= " FOP_CODIGO != '" + cCodigo + "' AND "
			cQuery	+= " FOP.D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlsQry)
			
			If !(cAlsQry)->(EOF())
				DbSelectArea("FOP")
				FOP->(DbSetOrder(1))
				(cAlsQry)->(DbGoTop())
				cCodFOP	:= (cAlsQry)->FOP_CODIGO
				While !(cAlsQry)->(EOF())
					FOP->(DbGoTo((cAlsQry)->_nRECNO))
					FOP->(RecLock("FOP", .F.))
					FOP->FOP_BLOQUE := "1"
					FOP->(MsUnLock())
					(cAlsQry)->(DbSkip())
				Enddo
				
				FOQ->(DbSetOrder(1))
				
				If FOQ->(DbSeek(xFilial("FOQ") + cCodFOP))
					FOQ->(RecLock("FOQ", .F. ))
					FOQ->FOQ_BLOQUE := "1"
					FOQ->(MsUnLock())
				Endif
				
				DbSelectArea("FOZ")
				FOZ->(DbSetOrder(1))
				
				If FOZ->(DbSeek(xFilial("FOZ") + cCodFOP))
					FOZ->(RecLock("FOZ", .F. ))
					FOZ->FOZ_BLOQUE := "1"
					FOZ->(MsUnLock())
				Endif
			Else
				Aviso(OemToAnsi(STR0035), OemToAnsi(STR0086),{"Ok"}, 3) //"Existe Erro na Base de dados. Favor Rodar novamente a Rotina de 'Geração de Arquivo CNAB'."
				DisarmTransaction()
				Return()
			Endif
			
			FOP->(DbSetOrder(1))
			FOP->(DbGoTop())
			
			If FOP->(DbSeek(xFilial("FOP") + cCodigo ))
				
				While !FOP->(EOF()) .And. FOP->FOP_FILIAL == xFilial("FOP") .And. FOP->FOP_CODIGO == cCodigo
					FOP->(RecLock("FOP", .F.))
					FOP->FOP_BLOQUE	:= "2"
					FOP->(MsUnLock())
					FOP->(DbSkip())
				Enddo
				
				FOQ->(DbSetOrder(1))
				
				If FOQ->(DbSeek(xFilial("FOQ") + cCodigo))
					FOQ->(RecLock("FOQ", .F. ))
					FOQ->FOQ_BLOQUE	:= "2"
					FOQ->(MsUnLock())
				Endif
				
				FOZ->(DbSetOrder(1))
				
				If FOZ->(DbSeek(xFilial("FOZ") + cCodigo))
					FOZ->(RecLock("FOZ", .F. ))
					FOZ->FOZ_BLOQUE	:= "2"
					FOZ->(MsUnLock())
				Endif
			Else
				DisarmTransaction()
				Return()
			Endif
			
			If FOP->(DbSeek(xFilial("FOP") + cCodigo ))
				Processa({|| lRet := CFGX049B08(FOP->FOP_BANCO, FOP->FOP_VERARQ, FOP->FOP_PAGREC, FOP->FOP_REMRET)}, OemToAnsi(STR0080) ) //"Processando Arquivos de Configuração"
			Endif
			
			Aviso(OemToAnsi(STR0035), OemToAnsi(STR0087), {"Ok"}, 3 ) //"Arquivo Marcado foi Habilitado para uso. Novo Arquivo de Configuração CNAB da versão desejada foi gerado."
		End Transaction
		
	Endif
	
	RestArea(aAlias)
Return

/*/ {Protheus.doc} CFGX049B2D()
Função que valida o uso do botão incluir
@author	Francisco Oliveira
@since		12/12/2017
@version	P12
@Function  CFGX049B02
@Return
@param
*/

Function CFGX049B2D(_nOpc)
	
	Aviso(OemToAnsi(STR0035), OemToAnsi(STR0128), {"Ok"}, 3) // "Inclusão somente atraves da importação de arquivos de configuração CNAB."
	
Return .F.

/*/ {Protheus.doc} CFGX049B2E()
Função que monta a tela de alteração de dados CNAB.
@author	Francisco Oliveira
@since		12/12/2017
@version	P12
@Function  CFGX049B02
@Return
@param
*/

Function CFGX049B2E()
	
	Local nX, oDlg, oBrwEDIC, oPnlAux, cRetF3
	Local aArea		:= GetArea()
	Local aAreaFOQ	:= FOQ->(GetArea())
	Local aAreaFOP	:= FOP->(GetArea())
	Local cAlsFOP	:= GetNextAlias()
	Local cAuxFOP	:= GetNextAlias()
	Local cCodigo	:= FOQ->FOQ_CODIGO
	Local cBanco	:= FOQ->FOQ_BANCO
	Local cTipo		:= FOQ->FOQ_ENRETT
	Local ccart		:= FOQ->FOQ_PGRECT
	Local cTpRodap	:= ""
	Local cModulo	:= ""
	Local cQuery	:= ""
	Local cQryFOP	:= ""
	Local cDesMov	:= ""
	Local aDdsEdit	:= {}
	Local aStruct	:= {}
	Local aColumns	:= {}
	
	cQryFOP	:= " SELECT  *, R_E_C_N_O_ AS nRecno " 	+ CRLF
	cQryFOP	+= " FROM " + RetSQLName("FOP") + " FOP "		+ CRLF
	cQryFOP	+= " WHERE "									+ CRLF
	cQryFOP	+= " FOP_BLOQUE = '2' AND "						+ CRLF
	cQryFOP	+= " FOP_CTREDI = '1' AND "						+ CRLF
	cQryFOP	+= " FOP_BANCO  = '" + cBanco	+ "' AND "		+ CRLF
	cQryFOP	+= " FOP_PAGREC = '" + cCart 	+ "' AND "		+ CRLF
	cQryFOP	+= " FOP_REMRET = '" + cTipo 	+ "' AND "		+ CRLF
	cQryFOP	+= " FOP.D_E_L_E_T_ = ' ' " 					+ CRLF
	
	cQryFOP := ChangeQuery(cQryFOP)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQryFOP), cAlsFOP)
	
	(cAlsFOP)->(DbGoTop())
	
	If (cAlsFOP)->(EOF())
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0129), {"Ok"}, 3) // "Não existe dados a serem alterados."
		Return
	Else
		While !(cAlsFOP)->(EOF())
			
			cQuery	:= " SELECT FOP_DESMOV "                                + CRLF
			cQuery	+= " FROM " + RetSqlName("FOP") + " FOP "               + CRLF
			cQuery	+= " WHERE "                                            + CRLF
			cQuery	+= " FOP_BANCO  = '" + cBanco                + "' AND " + CRLF
			cQuery	+= " FOP_REMRET = '" + cTipo                 + "' AND " + CRLF
			cQuery	+= " FOP_PAGREC = '" + cCart                 + "' AND " + CRLF
			cQuery	+= " FOP_BLOQUE = '2'                             AND " + CRLF
			cQuery	+= " FOP_IDELIN = '1'                             AND " + CRLF
			cQuery	+= " FOP_HEADET = '" + (cAlsFOP)->FOP_HEADET + "' AND " + CRLF
			cQuery	+= " FOP_CHALIN = '" + (cAlsFOP)->FOP_CHALIN + "' AND " + CRLF
			cQuery	+= " FOP_IDESEG = '" + (cAlsFOP)->FOP_IDESEG + "' AND " + CRLF
			cQuery	+= " FOP.D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery(cQuery)
			
			DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAuxFOP)
			
			If (cAuxFOP)->(EOF())
				cDesMov := ""
			Else
				cDesMov := (cAuxFOP)->FOP_DESMOV
			Endif
			
			(cAuxFOP)->(DbCloseArea())
			
			aADD(aDdsEdit,{;
				cBanco            	,; 										// Banco - 01
			(cAlsFOP)->FOP_POSINI 	,;										// Posição Inical - 02
			(cAlsFOP)->FOP_POSFIM 	,;										// Posição Final - 03
			cDesMov				 	,;										// Descrição do Segmento - 04
			SPACE(40)             	,; 										// Campo Novo Valor - 05
			(cAlsFOP)->FOP_CONARQ 	,; 										// Descrição do Movimento - 06
			(cAlsFOP)->FOP_SEQUEN	,; 										// Sequencia - 07
			(cAlsFOP)->FOP_VERARQ	,; 										// Versão - 08
			Iif((cAlsFOP)->FOP_PAGREC == "PAG", "Pagar", "Recebr")   ,;	// Pagar ou Receber - 09
			Iif((cAlsFOP)->FOP_REMRET == "REM", "Remessa", "Retorno"),;	// Remessa ou Retorno - 10
			(cAlsFOP)->FOP_NEWVLR 	,; 										// Valor A ser Alterado - 11
			(cAlsFOP)->FOP_CTDEDI 	,; 										// Valor a ser escolhido para alterar o campo anterior - 12
			(cAlsFOP)->FOP_DESMOV 	,; 										// Descrição do Movimento - 13
			(cAlsFOP)->FOP_CONARQ 	} )										// Descrição do conteudo do arquivo - 14
			
			(cAlsFOP)->(DbSkip())
		Enddo
	Endif
	
	aADD( aStruct, { "BANCO" , "C", 005, 0 } )
	aADD( aStruct, { "PAGREC", "C", 001, 0 } )
	aADD( aStruct, { "REMRET", "C", 001, 0 } )
	aADD( aStruct, { "DESMOV", "C", 015, 0 } )
	aADD( aStruct, { "POSINI", "C", 001, 0 } )
	aADD( aStruct, { "POSFIN", "C", 001, 0 } )
	aADD( aStruct, { "DESLIN", "C", 020, 0 } )
	aADD( aStruct, { "VLRNEW", "C", 020, 0 } )
	aADD( aStruct, { "CONLIN", "C", 050, 0 } )
	
	oBrwEDIC := Nil
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0057) FROM 0,0 TO 600,1200 PIXEL //"Selecione a Nova Informação"
	
	oBrwEDIC := FwBrowse():New(oDlg)
	oBrwEDIC:SetDataArray()
	oBrwEDIC:SetDescription(OemToAnsi(STR0054)) // "Edição de Arquivos CNAB"
	oBrwEDIC:SetArray(aDdsEdit)
	oBrwEDIC:DisableReport()
	
	For nX := 1 To Len(aStruct)
		If	aStruct[nX][1] == "POSINI"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[oBrwEDIC:nAt][2] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("POS. INICIAL")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "POSFIN"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[oBrwEDIC:nAt][3] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("POS. FINAL")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "DESMOV"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[oBrwEDIC:nAt][13] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("MOVIMENTO")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "DESLIN"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[oBrwEDIC:nAt][4] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("DESC. LINHA")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "CONLIN"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[oBrwEDIC:nAt][14] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("CONTEUDO PADRÃO")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "VLRNEW"
			cEditCel	:= "VLRNEW"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[oBrwEDIC:nAt][05] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("NOVO VALOR")
			aColumns[Len(aColumns)]:SetPicture("@!")
			aColumns[Len(aColumns)]:SetEdit(.T.)
			aColumns[Len(aColumns)]:SetReadVar( cEditCel )
			aColumns[Len(aColumns)]:SetF3( {|| VlrNew := StaticCall(CFGX049B01, ConNewVlr, aDdsEdit[oBrwEDIC:nAt][12], aDdsEdit[oBrwEDIC:nAt][2], aDdsEdit[oBrwEDIC:nAt][3])} ) //StaticCall(PCOA530, A530SelCTs,cTxtBlq)
		EndIf
	Next nX
	
	oBrwEDIC:SetColumns(aColumns)
	oBrwEDIC:SetEditCell(.T., {|A,B,C,D,E| StaticCall(CFGX049B01, VALDIGIT, aDdsEdit[oBrwEDIC:nAt][12],B,C,D,E)})
	
	oBrwEDIC:Activate()
	
	cTpRodap	:= Iif(cTipo == "REM", "Remessa", "Retorno" )
	cModulo	:= Iif(ccart == "PAG", "Contas a Pagar", "Contas a Receber")
	
	oPnlAux	:= TPanel():New(120,0,,oDlg,,.T.,,,,400,30)
	oPnlAux:Align := CONTROL_ALIGN_BOTTOM
	
	@ 012,010 SAY "Banco"	SIZE 150,08 PIXEL Of oPnlAux
	@ 010,030 MSGET Posicione("SA6", 1, xFilial("SA6") + cBanco, "A6_NREDUZ")  PICTURE "@!" SIZE 050,08 WHEN .F. PIXEL OF oPnlAux
	
	@ 012,130 SAY "Modulo"	SIZE 150,08 PIXEL Of oPnlAux
	@ 010,155 MSGET cModulo PICTURE "@!" SIZE 060,08 WHEN .F. PIXEL OF oPnlAux
	
	@ 012,250 SAY "Tipo"	SIZE 150,08 PIXEL Of oPnlAux
	@ 010,265 MSGET cTpRodap PICTURE "@!" SIZE 050,08 WHEN .F. PIXEL OF oPnlAux
	
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg, {||(cRetF3 := CFGX049B6A(aDdsEdit), oDlg:End())}, {||oDlg:End()})
	
	RestArea(aArea)
	RestArea(aAreaFOQ)
	RestArea(aAreaFOP)
	
Return

/*/ {Protheus.doc} CFGX049B2F()
Função que monta a tela MVC para edição de arquivo CNAB
@author	Francisco Oliveira
@since		12/12/2017
@version	P12
@Function  CFGX049B02
@Return
@param
*/

Function CFGX049B2F(_nOpc)
	
	Local aAreaFOP	:= FOP->(GetArea())
	Local aAreaFOQ	:= FOQ->(GetArea())
	Local aAreaFOZ	:= FOZ->(GetArea())
	Local cCodFOQ	:= FOQ->FOQ_CODIGO
	Local cBloque	:= FOQ->FOQ_BLOQUE
	
	DbSelectArea("FOZ"); FOZ->(DbSetOrder(1)); FOZ->(DbGoTop())
	DbSelectArea("FOP"); FOP->(DbSetOrder(1)); FOP->(DbGoTop())
	DbSelectArea("FOQ"); FOQ->(DbSetOrder(1)); FOQ->(DbGoTop())
			
	If FOQ->FOQ_BLOQUE == '1' .And. _nOpc != 5
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0139), {"Ok"}, 3) //"Registro bloqueado para edição. Favor verificar"
	Else
		If _nOpc == 4
			If FOZ->(DbSeek(xFilial("FOZ") + cCodFOQ ))
				FWExecView(OemToAnsi(STR0130),"CFGX049B03",4,,{||.T.},{||.T.},0) // "Alterar arquivo CNAB"
			Endif
		ElseIf _nOpc == 3
			If FOZ->(DbSeek(xFilial("FOZ") + cCodFOQ ))
				FWExecView(OemToAnsi(STR0130),"CFGX049B03",3,,{||.T.},{||.T.},0) // "Incluir arquivo CNAB"
			Endif
		ElseIf _nOpc == 5
			If FOZ->(DbSeek(xFilial("FOZ") + cCodFOQ))
				FWExecView(OemToAnsi(STR0130),"CFGX049B03",5,,{||.T.},{||.T.},0) // "Excluir arquivo CNAB"
				If FOQ->(DbSeek(xFilial("FOQ") + cCodFOQ))
					FOQ->(RecLock("FOQ", .F.))
					FOQ->(DbDelete())
					FOQ->(MsUnLock())
				Endif
			Endif
		Endif
	Endif
	
	RestArea(aAreaFOZ)
	RestArea(aAreaFOQ)
	RestArea(aAreaFOP)
	
Return

