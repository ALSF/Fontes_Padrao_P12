#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "CNTA240.CH"

#DEFINE FLG_RORI "O" //Flag de controle dos registros originais
#DEFINE FLG_RDEL "D" //Flag de controle dos registros deletados
#DEFINE FLG_RADD "A" //Flag de controle dos registros adicionados

#DEFINE FLG_ARVU "U" //Chave identificacao da arvore de usuarios
#DEFINE FLG_ARVG "G" //Chave identificacao da arvore de grupos
#DEFINE FLG_ARVC "C" //Chave identificacao da arvore do contrato
#DEFINE FLG_ARVF "F" //Chave identificacao da arvore do contrato

#DEFINE DEF_TRAALT "039" //Atualizacao do contrato
#DEFINE DEF_CTRACS "041" //Controle de Acessos

#DEFINE DEF_TRANS "001" //Controle Total

#DEFINE TOTALTRAN 37 //Numero total de transacoes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                           ;
±±³Fun‡ao    ³CN240Acesso³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Configura o acesso dos usuario as transacoes de contrato    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240Acesso()
Local cCadastro:= STR0001//"Controle de Acesso"
Local lContinua:= .T.
Local cContra  := CN9->CN9_NUMERO//Contrato Atual
Local aUsrs    := Array(2)
Local aUsers   := {} //Usuarios
Local aGrps    := {} //Grupos
Local aTrans   := {} //Listagem

Local aInc		:= {} // Filiais inclusas no Tree
Local aExc		:= {} // Filiais retidas do Tree

Local lRet   :=.F.
Local cQuery := ""
Local cTpCto := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_DESCRI")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controles visuais                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg
Local aArea:= GetArea()
Local oTree//Objeto dbtree
Local oTreeFil//Objeto dbtree Filiais autorizadas
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula dimensao da dialog                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local aSize     := MsAdvSize( .F. )
Local aCoors		:= FWGetDialogSize( oMainWnd )
Local aObjects  := {}
Local aUsButtons:= {}
Local aPosObj1  := {}
Local oPnl1, oPnl2, oGroup1
Local nOpca     :=2
Local cTra			:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega relacionamentos UsrXTransacao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAlias    := GetNextAlias()
Local lCN240Exc := ExistBlock("CN240Exc")

aUsrs[1] := {}
aUsrs[2] := {}

//Atualiza o array com os usuarios
aUsers   := c240UsBusca(cContra,@aUsrs) //Usuarios
aGrps    := AllGroups()//Grupos

//Atualiza o array com os grupos
aUsrs[2] := c240GrBusca(cContra,aGrps)


If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacao para a CNO.  			      		        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNO")

		cQuery := "SELECT COUNT(*) AS TOTAL FROM "+ RetSQLName("CNO") +" CNO WHERE "
		cQuery += "CNO.CNO_FILIAL = '"+ xFilial("CNO") +"' AND "
		cQuery += "CNO.D_E_L_E_T_ = ' '"

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

		If (cAlias)->TOTAL < TOTALTRAN
			CtaGerTra()
		EndIf

		(cAlias)->(dbCloseArea())


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacao para a CN9. Campo para controle de acesso. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		lContinua := (Empty(CN9->CN9_VLDCTR) .Or. CN9->CN9_VLDCTR == "1")

	If lContinua
		If FunName() == "CNTA300"
			cTra := DEF_CTRACS
		Else
			cTra := DEF_TRAALT
		EndIf
		If CN240VldUsr(cContra,cTra,.T.)
			aTrans := CN240ListAc(.F.)

			//- Coordenadas da area total da Dialog
			oSize := FWDefSize():New(.F.)
			oSize:AddObject('PNL1',100,45,.T.,.T.)
			oSize:AddObject('PNL2',100,45,.T.,.T.)
			oSize:AddObject('BUT',100,10,.T.,.F.)
			oSize:SetWindowSize(aCoors)
			oSize:lProp 	:= .T.
			oSize:aMargins := {3,3,3,3}
			oSize:Process()

			DEFINE MSDIALOG oDlg TITLE cCadastro From oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria painel para o Tree de acesso de usuario       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ oSize:aPosObj[1,1], oSize:aPosObj[1,2] MSPANEL oPnl1 PROMPT "" SIZE oSize:aPosObj[1,4],oSize:aPosObj[1,3] OF oDlg

			oSize1 := FWDefSize():New(.F.)
			oSize1:AddObject('CAB',100,10,.T.,.T.)
			oSize1:AddObject('TREE',100,90,.T.,.T.)
			oSize1:SetWindowSize({0,0,oPnl1:NHEIGHT,oPnl1:NWIDTH})
			oSize1:lProp 	:= .T.
			oSize1:aMargins := {3,3,3,3}
			oSize1:Process()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contrato                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ oSize1:aPosObj[1,1],oSize1:aPosObj[1,2] Say RetTitle("CN9_NUMERO") Of oPnl1 PIXEL
			@ oSize1:aPosObj[1,1],oSize1:aPosObj[1,2]+030 MsGet oGetCtr Var cContra When .F. PIXEL  Size 50,5 Of oPnl1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tipo do contrato                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ oSize1:aPosObj[1,1],oSize:aPosObj[1,2]+082 Say RetTitle("CN9_TPCTO") Of oPnl1 PIXEL
			@ oSize:aPosObj[1,1],oSize:aPosObj[1,2]+122 MsGet oGetTCto Var cTpCto When .F. PIXEL  Size 100,5 Of oPnl1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega DBTree                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DEFINE DBTREE oTree FROM oSize1:aPosObj[2,1], oSize1:aPosObj[2,2] TO oSize1:aPosObj[2,3],oSize1:aPosObj[2,4] OF oPnl1 CARGO

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta arvore principal                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DBADDTREE oTree PROMPT OemToAnsi(STR0015)+Space(30) OPEN OPENED CARGO FLG_ARVC+space(9)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega SubArvores                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			CN240ItTree(oTree,aTrans,aUsrs)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta menu de edicao/exclusao                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MENU oMenuTree POPUP
			MENUITEM OemToAnsi(STR0018) Resource "BMPUSER"  	Action CN240Inc(oTree,aTrans,FLG_ARVU,aUsrs[1],aUsers,aGrps,,1)//Incluir Usuario
			MENUITEM OemToAnsi(STR0024) Resource "BMPGROUP" 	Action CN240Inc(oTree,aTrans,FLG_ARVG,aUsrs[2],aUsers,aGrps,,2)//Incluir Grupo
			MENUITEM OemToAnsi(STR0025) Resource "note" 		Action CN240Edit(oTree,aTrans,aUsrs,aUsers,aGrps)//Edita
			MENUITEM OemToAnsi(STR0026) Resource "excluir" 		Action If(!lCN240Exc,CN240Del(oTree,aTrans,aUsrs),(lRet:=ExecBlock("CN240Exc",.F.,.F.),If((valtype(lRet)=="L" .And. lRet),CN240Del(oTree,aTrans,aUsrs),nOpca:=2))) //Exclui
			MENUITEM OemToAnsi(STR0048) Resource "bmpincluir" 	Action CN240Cop(oTree,aTrans,aUsrs,aUsers,aGrps,cContra)//Copiar Estrutura
			ENDMENU

			oTree:bRClicked   := { |oObject,nx,ny| Cn240HPOPUP( oObject, nx-80, ny-150, oMenuTree , "oMenuTree") }

			DBENDTREE oTree

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria painel para o Tree de Filiais autorizadas	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ oSize:aPosObj[2,1], oSize:aPosObj[2,2] MSPANEL oPnl2 PROMPT "" SIZE oSize:aPosObj[2,4],oSize:aPosObj[2,3] OF oDlg

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega DBTree Filiais autorizadas                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DEFINE DBTREE oTreeFil FROM 003, 003 TO oSize1:aPosObj[2,3],oSize1:aPosObj[2,4] OF oPnl2 CARGO

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta arvore principal                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DBADDTREE oTreeFil PROMPT STR0061 OPEN OPENED CARGO FLG_ARVF+space(40)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega SubArvores                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			CN240ItTree(oTreeFil,,,.T.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta menu de Inclusão/exclusao                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									
			MENU oMenuTreeFil POPUP
			MENUITEM OemToAnsi(STR0065) Resource "bmpincluir"  	Action CN240IncFil(oTreeFil, @aInc, @aExc, oPnl2 )	//Incluir Filial
			MENUITEM OemToAnsi(STR0066) Resource "Excluir" 		Action CN240DelFil(oTreeFil, @aInc, @aExc) 			//Excluir Filial
			ENDMENU

			oTreeFil:bRClicked   :=  { |oObject,nx,ny| Cn240HPOPUP( oObject, nx-60, ny-(oSize1:aPosObj[2,4]-270), oMenuTreeFil , "oMenuTreeFil") }

			DBENDTREE oTreeFil

			DEFINE SBUTTON FROM oSize:aPosObj[3,1], oSize:aPosObj[3,4]-55 TYPE 1 ACTION If(CNTA240Ok(aUsrs),(nOpca:=1,oDlg:End()),) ENABLE OF oDlg
			DEFINE SBUTTON FROM oSize:aPosObj[3,1], oSize:aPosObj[3,4]-25 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg

			ACTIVATE MSDIALOG oDlg CENTERED

			If nOpca==1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa gravacao da estrutura de acesso            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				CN240Grv(aUsrs,cContra)

				If !Empty(aInc) .Or. !Empty(aExc)
					CN240GrvCPD(aInc, aExc)
			EndIf
			EndIf
		EndIf
	Else
		Help("",1,"CNTA240_01")
	EndIf
Else
	Aviso("CNTA240",OemToAnsi(STR0055),{"Ok"})//"O dicionario de dados não se encontra atualizado, execute o compatibilizador GCTUPD02 atraves do remote Protheus"
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240Grv   ³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa gravação da estrutura de acesso do contrato         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240Grv(aExp01,cExp02)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 = Array contendo os relacionamentos dos usuariosXtran³±±
±±³          ³          sacoes                                             ³±±
±±³          ³ cExp02 = Codigo do contrato                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240Grv(aUsrs,cContra)
Local nx
Local cFilCod := xFilial("CNN")

dbSelectArea("CNN")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre estrutura de usuarios                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to len(aUsrs[1])
	If aUsrs[1,nx,4] == FLG_RADD//Item adicionado
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa gravacao do item                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("CNN",.T.)
		CNN->CNN_FILIAL := cFilCod
		CNN->CNN_CONTRA := cContra
		CNN->CNN_USRCOD := aUsrs[1,nx,1]
		CNN->CNN_TRACOD := aUsrs[1,nx,2]
		MsUnlock()
	ElseIf aUsrs[1,nx,4] == FLG_RDEL//Item excluido
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica item no banco e executa exclusao se necessario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dbSeek(xFilial("CNN")+aUsrs[1,nx,1]+cContra+aUsrs[1,nx,2])
			RecLock("CNN",.F.)
			dbDelete()
			MsUnlock()
		EndIf
	EndIf
Next

dbSetOrder(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre estrutura de grupos                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to len(aUsrs[2])
	If aUsrs[2,nx,4] == FLG_RADD//Item adicionado
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa gravacao do item                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("CNN",.T.)
		CNN->CNN_FILIAL := cFilCod
		CNN->CNN_CONTRA := cContra
		CNN->CNN_GRPCOD := aUsrs[2,nx,1]
		CNN->CNN_TRACOD := aUsrs[2,nx,2]
		MsUnlock()
	ElseIf aUsrs[2,nx,4] == FLG_RDEL//Item excluido
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica item no banco e executa exclusao se necessario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dbSeek(xFilial("CNN")+aUsrs[2,nx,1]+cContra+aUsrs[2,nx,2])
			RecLock("CNN",.F.)
			dbDelete()
			MsUnlock()
		EndIf
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada executado após a gravação da estrutura de acesso do contrato   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("CN240CGRV"))
	ExecBlock("CN240CGRV",.F.,.F.,{aUsrs,cContra})
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240ItTree³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera as arvores de usuario e grupo do dbTree                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240ItTree(oExp01,aExp02,aExp03)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree                                      ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±³          ³ aExp03 - Array contendo os relacionamentos UrsXTransacoes   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240ItTree(oTree,aTrans,aUsrs,lTreeFil)

Default lTreeFil := .F.

If lTreeFil
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera arvore de Filiais autorizadas  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CN240GerArv(oTree,{},"",STR0062,FLG_ARVF,"BMPUSER")
Else
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arvore de usuarios  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CN240GerArv(oTree,aTrans,aUsrs[1],STR0017,FLG_ARVU,"BMPUSER")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arvore de grupos    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CN240GerArv(oTree,aTrans,aUsrs[2],STR0016,FLG_ARVG,"BMPGROUP")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240GerArv³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera arvore do dbtree                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240GerArv(oExp01,aExp02,aExp03,cExp04,cExp05)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree                                      ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±³          ³ aExp03 - Array contendo os relacionamentos UrsXTransacoes   ³±±
±±³          ³ cExp04 - Titulo da arvore                                   ³±±
±±³          ³ cExp05 - Chave de pesquisa da arvore                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240GerArv(oTree,aTrans,aUsrs,cTit,cCargo,cRsr)
Local nx
Local lFirst := .T.
Local nPosTrans

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arvore              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCargo == FLG_ARVF
	DBADDTREE oTree PROMPT STR0064 RESOURCE "" CARGO FLG_ARVF
	ADDTREEPLAN(oTree, CN9->(CN9_FILIAL+CN9_NUMERO+CN9_REVISA))
Else
	DBADDTREE oTree PROMPT cTit RESOURCE cRsr CARGO cCargo

	For nx:=1 to len(aUsrs)
		If lFirst
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona arvore quando primeira execucao do usuario/grupo  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DBADDTREE oTree PROMPT aUsrs[nx,3] CARGO cCargo+aUsrs[nx,1]
		EndIf

		nPosTrans := aScan(aTrans,{|x| x[2] == aUsrs[nx,2]})

		if nPosTrans > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona transacao na arvore do usuario/grupo  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DBADDITEM oTree PROMPT aTrans[nPosTrans,3] CARGO cCargo+aUsrs[nx,1]+aUsrs[nx,2]
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica proximo usuario/grupo                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lFirst := ((len(aUsrs)>nx) .And. aUsrs[nx+1,1] != aUsrs[nx,1])
		If lFirst .OR. nx == len(aUsrs)
			DBENDTREE oTree
		EndIf
	Next
EndIf

DBENDTREE oTree

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240ArrUsr³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera array com os relacionamentos usuarios X transacoes do  ³±±
±±³          ³ contrato                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aExp01 := CN240ArrUsr(cExp02,aExp03,aExp04)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array com os relacionamentos usuariosXtransacao    ³±±
±±³          ³ Estrutura do aExp01:                                        ³±±
±±³          ³ -aExp01[1]-Usuarios                                         ³±±
±±³          ³  -aExp01[1,1]-Codigo do Usuario                             ³±±
±±³          ³  -aExp01[1,2]-Codigo da Transacao                           ³±±
±±³          ³  -aExp01[1,3]-Nome do Usuario                               ³±±
±±³          ³  -aExp01[1,4]-Situacao do registro: FLG_RORI - Original     ³±±
±±³          ³                                     FLG_RDEL - Excluido     ³±±
±±³          ³                                     FLG_RADD - Adicionado   ³±±
±±³          ³ -aExp01[2]-Grupos                                           ³±±
±±³          ³  -aExp01[2,x,1]-Codigo do Grupo de Usuario                  ³±±
±±³          ³  -aExp01[2,x,2]-Codigo da Transacao                         ³±±
±±³          ³  -aExp01[2,x,3]-Nome do Grupo                               ³±±
±±³          ³  -aExp01[2,x,4]-Situacao do registro: FLG_RORI - Original   ³±±
±±³          ³                                       FLG_RDEL - Excluido   ³±±
±±³          ³                                       FLG_RADD - Adicionado ³±±
±±³          ³ aExp02 - Array contendo os usuarios do sistema - AllUsers() ³±±
±±³          ³ aExp03 - Array contendo os grupos de usuario do sistema -   ³±±
±±³          ³          AllGroups()                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240ArrUsr(cContra,aUsers,aGrps)
Local aUsr      := Array(2)
Local cQuery    := {}
Local cAliasQry := GetNextAlias()
Local nPos

aUsr[1] := {}
aUsr[2] := {}

dbSelectArea("CNN")
cQuery := "SELECT CNN.* FROM " + RetSQLName("CNN") + " CNN WHERE "
cQuery += "CNN.CNN_FILIAL = '"+ xFilial("CNN") +"' AND "
cQuery += "CNN.CNN_CONTRA = '"+ cContra +"' AND "
cQuery += "CNN.D_E_L_E_T_ = '' "
cQuery += "ORDER BY CNN.CNN_USRCOD,CNN.CNN_GRPCOD,CNN.CNN_TRACOD"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

While !(cAliasQry)->(Eof())
	If Empty((cAliasQry)->CNN_GRPCOD)
	    PswOrder(1)
     	If (  PswSeek((cAliasQry)->CNN_USRCOD, .T.) )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inclui registro de usuario                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aUsr[1],{(cAliasQry)->CNN_USRCOD,(cAliasQry)->CNN_TRACOD,Pswret(1)[1][2],FLG_RORI})
		EndIf
	ElseIf (nPos:=ascan(aGrps,{|x| x[1,1] = (cAliasQry)->CNN_GRPCOD}))>0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui registro de grupo                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aUsr[2],{(cAliasQry)->CNN_GRPCOD,(cAliasQry)->CNN_TRACOD,aGrps[nPos,1,2],FLG_RORI})
	EndIf
	(cAliasQry)->(dbSkip())
EndDo

Return aUsr

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240Del   ³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exclui usuario/grupo da estrutura                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240Del(oExp01,aExp02,aExp03)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree                                      ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±³          ³ aExp03 - Array contendo os relacionamentos UrsXTransacoes   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240Del(oTree,aTrans,aUsrs)
Local cCargo
Local nx
Local cCod
Local nTDelArr := 0
Local nInd
Local lUser    := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega chave do registro selecionado no dbTree³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCargo:=oTree:GetCargo()

nInd := If(SubStr(cCargo,1,1)==FLG_ARVU,1,2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se foi selecionado grupo ou usuario   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(AllTrim(cCargo))>1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona codigo                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCod := SubStr(cCargo,2,6)

	If Aviso("CNTA240",OemToAnsi(If(nInd==1,STR0044,STR0045))+If(nInd==1,UsrRetName(cCod),GrpRetName(cCod)),{OemToAnsi(STR0046),OemToAnsi(STR0047)})==1
		nx    :=len(aUsrs[nInd])


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui transacoes do usuario/grupo             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While nx > 0
			If aUsrs[nInd,nx,1] == cCod .And. lUser
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Altera estado do registro para ser usado na gravacao ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aUsrs[nInd,nx,4] == FLG_RORI
					aUsrs[nInd,nx,4] := FLG_RDEL
				ElseIf aUsrs[nInd,nx,4] == FLG_RADD
					aDel(aUsrs[nInd],nx)
					nTDelArr++
				EndIf
			EndIf
			nx--
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza dbTree              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lUser
			oTree:BeginUpdate()
			If oTree:TreeSeek(If(nInd==1,FLG_ARVU,FLG_ARVG)+cCod)
				oTree:DelItem()
			EndIf
			oTree:EndUpdate()
			oTree:Refresh()
			aSize(aUsrs[nInd],len(aUsrs[nInd])-nTDelArr)
		Else
			Aviso("CNTA240",OemToAnsi(STR0059),{"OK"})
		EndIf
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240Del   ³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exclui usuario/grupo da estrutura                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240Del(oExp01,aExp02,aExp03,aExp04,aExp05)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree                                      ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±³          ³ aExp03 - Array contendo os relacionamentos UrsXTransacoes   ³±±
±±³          ³ aExp04 - Array contendo os usuarios do sistema - AllUsers() ³±±
±±³          ³ aExp05 - Array contendo os grupos de usuario do sistema -   ³±±
±±³          ³          AllGroups()                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240Edit(oTree,aTrans,aUsrs,aUsers,aGrps)
Local cCargo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega chave do registro selecionado no dbTree³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCargo:=oTree:GetCargo()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se foi selecionado grupo ou usuario   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(AllTrim(cCargo))>1
	If SubStr(cCargo,1,1) == FLG_ARVU//Usuario
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Edita configuracao do usuario                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CN240Inc(oTree,aTrans,FLG_ARVU,aUsrs[1],aUsers,aGrps,SubStr(cCargo,2,6),3)
	Else//Grupo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Edita configuracao do grupo                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CN240Inc(oTree,aTrans,FLG_ARVG,aUsrs[2],aUsers,aGrps,SubStr(cCargo,2,6),4)
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240Inc   ³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Inclui/Edita grupo/usuario na estrutura de acesso           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240Inc(oExp01,aExp02,cExp03,aExp04,aExp05,aExp06,cExp07)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree                                      ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±³          ³ cExp03 - Chave da arvore onde sera incluso o item           ³±±
±±³          ³ aExp04 - Array contendo os relacionamentos UrsXTransacoes   ³±±
±±³          ³ aExp05 - Array contendo os usuarios do sistema - AllUsers() ³±±
±±³          ³ aExp06 - Array contendo os grupos de usuario do sistema -   ³±±
±±³          ³          AllGroups()                                        ³±±
±±³          ³ cExp07 - Codigo do usuario/grupo a ser editado - opcional - ³±±
±±³          ³          usado apenas na edicao                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240Inc(oTree,aTrans,cCargo,aUsrs,aUsers,aGrps,cCod,nOpc)
Local lEdit   :=(cCod!=Nil)//Edicao quando recebe codigo
Local oGetUsr
Local cCodGen := Space(6)
Local oGetGrp
Local oDlg
Local nPos
Local nPosPai
Local nOpca:=2
Local cNome
Local nX
Local oTreeT
Local lInc
Local lIncPai

If lEdit
	cCodGen := cCod
EndIf

If !lEdit
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configura todas as transacoes como falso       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEval(aTrans,{|x| x[1] := .F.})
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Varre todas as transacoes do sistema           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nx:=1 to len(aTrans)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a transacao esta configurada para o usuario/grupo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aTrans[nx,1] := (aScan(aUsrs,{|x| x[1]==cCodGen .And. x[2]==aTrans[nx,2] .And. x[4] != FLG_RDEL}) > 0)

		If !aTrans[nx,1] .And. !Empty(aTrans[nx,4])
			aTrans[nx,1] := aTrans[aTrans[nx,6],1]
		EndIf
	Next
EndIf

If cCargo == FLG_ARVU//Usuario
	If nOpc==1
   		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0018) From 165,115 TO 450,450 PIXEL
	Else
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0025) From 165,115 TO 450,450 PIXEL
	EndIf
	@ 07,10 Say STR0056 Of oDlg PIXEL//"Usuário"
	@ 05,50 MsGet oGetUsr Var cCodGen F3 "USR" WHEN !lEdit ON CHANGE (oDesc:Refresh()) Size 60,5 Of oDlg PIXEL VALID Cn240VldGr('USR',cCodGen)
	@ 18,10 Say STR0027 Of oDlg PIXEL//"Usuário"
	@ 16,50 MsGet oDesc Var UsrRetName(cCodGen) WHEN .F. Size 60,5 Of oDlg PIXEL
Else//Grupo
	If nOpc==2
   		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0024) From 165,115 TO 450,450 PIXEL
	Else
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0025) From 165,115 TO 450,450 PIXEL
	EndIf
	@ 07,10 Say STR0057 Of oDlg PIXEL//"Grupo"
	@ 05,50 MsGet oGetGrp Var cCodGen F3 "GRP" WHEN !lEdit ON CHANGE (oDesc:Refresh()) Size 60,5 Of oDlg PIXEL VALID Cn240VldGr('GRP',cCodGen)
	@ 18,10 Say STR0027 Of oDlg PIXEL//"Grupo"
	@ 16,50 MsGet oDesc Var Iif(Empty(cCodGen),"",GrpRetName(cCodGen)) WHEN .F. Size 60,5 Of oDlg PIXEL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega DBTree com as transacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE DBTREE oTreeT FROM 30,10 TO __DlgHeight(oDlg)-27,__DlgWidth(oDlg)-3 OF oDlg CARGO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Arvore de Transacao                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CN240LTreeT(oTreeT,aTrans)

DBENDTREE oTreeT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotina de alteracao da situacao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTreeT:bLDblClick := {|| CN240AltSit(oTreeT,aTrans)}

DEFINE SBUTTON FROM __DlgHeight(oDlg)-25, __DlgWidth(oDlg)-60 TYPE 1 ACTION (If(Empty(cCodGen),Aviso("CNTA240",OemToAnsi(STR0028),{"Ok"}),(nOpca:=1,oDlg:End()))) ENABLE OF oDlg PIXEL
DEFINE SBUTTON FROM __DlgHeight(oDlg)-25, __DlgWidth(oDlg)-30 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1

	oTree:BeginUpdate()
	For nx:=1 to len(aTrans)
		lInc:=aTrans[nX,1]

		If lInc .And. !Empty(aTrans[nX,4])
			nPosPai := aTrans[nx,6]
			If nPosPai > 0
				lInc := !aTrans[nPosPai,1]
			EndIf
		EndIf

		If lInc
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa inclusao no dbTree ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If CN240IncIt(oTree,cCargo,cCodGen,aTrans[nx,3],aTrans[nx,2],aUsers,aGrps)
				If (nPos := aScan(aUsrs,{|x| x[1] == cCodGen .And. x[2] == aTrans[nx,2]})) > 0
					aUsrs[nPos,4] := FLG_RORI
				Else
					If cCargo==FLG_ARVU
						If (nPos:=ascan(aUsers,{|x| x[2] = cCodGen}))>0
							cNome:=aUsers[nPos,3]
						EndIf
					Else
						If (nPos:=ascan(aGrps,{|x| x[1,1] = cCodGen}))>0
							cNome:=aGrps[nPos,1,2]
						EndIf
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Executa inclusao no array de relacionamento UsrsXTransacoes ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aAdd(aUsrs,{cCodGen,aTrans[nx,2],cNome,FLG_RADD})
				EndIf
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se item foi excluido      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oTree:TreeSeek(cCargo+cCodGen+aTrans[nx,2])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui item do dbTree              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oTree:DelItem()
				nPos := aScan(aUsrs,{|x| x[1] == cCodGen .And. x[2] == aTrans[nx,2]})
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui item no array de controle   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nPos > 0
					If aUsrs[nPos,4] == FLG_RADD
						aDel(aUsrs,nPos)
						aSize(aUsrs,len(aUsrs)-1)
					Else
						aUsrs[nPos,4] := FLG_RDEL
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	oTree:EndUpdate()
	oTree:Refresh()
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240AltSit³ Autor ³ Marcelo Custodio      ³ Data ³20.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Altera selecao da transacao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240AltSit(oExp01,aExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree - Transacoes                         ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240AltSit(oTreeT,aTrans)
Local cCargo := oTreeT:GetCargo()
Local cOkRs := "LBTIK"
Local cNoRs := "LBNO"
Local nPos := aScan(aTrans,{|x| x[2]==cCargo})
Local nx

If nPos > 0
	oTreeT:BeginUpdate()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Altera situacao no array           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTrans[nPos,1] := !aTrans[nPos,1]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Altera imagem                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aTrans[nPos,1]
		oTreeT:ChangeBmp(cOkRs,cOkRs)
	Else
		oTreeT:ChangeBmp(cNoRs,cNoRs)
	EndIf

	If aTrans[nPos,5]
		SitAll(oTreeT,aTrans[nPos,2],aTrans,If(aTrans[nPos,1],cOkRs,cNoRs),nPos,aTrans[nPos,1])
	EndIf

	If !Empty(aTrans[nPos,4])
		SitUp(oTreeT,aTrans,nPos)
	EndIf

	oTreeT:TreeSeek(aTrans[nPos,2])
	oTreeT:EndUpdate()
	oTreeT:Refresh()
EndIf

Return

Function SitUp(oTreeT,aTrans,nPos)
Local nx
Local lSelec:=.T.
Local cOkRs := "LBTIK"
Local cNoRs := "LBNO"
Local nPosPai

If !Empty(aTrans[nPos,4])
	For nx:=1 to len(aTrans)
		If aTrans[nx,2] == aTrans[nPos,4]
			nPosPai := nx
		ElseIf aTrans[nx,4] == aTrans[nPos,4] .And. !aTrans[nx,1]
			lSelec:=.F.
			Exit
		EndIf
	Next

	If lSelec
		If oTreeT:TreeSeek(aTrans[nPos,4])
			oTreeT:ChangeBmp(cOkRs,cOkRs)
			aTrans[nPosPai,1]:=.T.
		EndIf
	Else
		If oTreeT:TreeSeek(aTrans[nPos,4])
			oTreeT:ChangeBmp(cNoRs,cNoRs)
			aTrans[nPosPai,1]:=.F.
		EndIf
	EndIf
	SitUp(oTreeT,aTrans,nPosPai)
EndIf
Return

Function SitAll(oTreeT,cTrans,aTrans,cRsc,nPos,lAdd)
Local nx

For nx:=nPos+1 to len(aTrans)
	If aTrans[nx,4] == cTrans
		If oTreeT:TreeSeek(aTrans[nx,2])
			oTreeT:ChangeBmp(cRsc,cRsc)
			aTrans[nx,1] := lAdd
			If aTrans[nx,5]
				SitAll(oTreeT,aTrans[nx,2],aTrans,cRsc,nx,lAdd)
			EndIf
		EndIf
	EndIf
Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240LTreeT³ Autor ³ Marcelo Custodio      ³ Data ³20.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Constroi arvore das transacoes do sistema                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240LTreeT(oExp01,aExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree - Transacoes                         ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240LTreeT(oTreeT,aTrans)
Local nx
Local cOkRs := "LBTIK"
Local cNoRs := "LBNO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arvore das transacoes         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTreeT:BeginUpdate()
For nx:=1 to len(aTrans)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a transacao possui pai ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(atrans[nx,4])
		oTreeT:AddItem(aTrans[nx,3]+Space(30),aTrans[nx,2],If(aTrans[nx,1],cOkRs,cNoRs),,,,2)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica transacao pai             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If oTreeT:TreeSeek(aTrans[nx,4])
			oTreeT:PTCollapse()
			oTreeT:AddItem(aTrans[nx,3],aTrans[nx,2],If(aTrans[nx,1],cOkRs,cNoRs),,,,2)
		EndIf
	EndIf
Next

oTreeT:EndUpdate()
oTreeT:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240IncIt ³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Inclui item na arvore do dbTree                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240IncIt(oExp01,cExp02,cExp03,cExp04,cExp05,aExp06,aExp07)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - Objeto DbTree                                      ³±±
±±³          ³ cExp02 - Chave da arvore onde sera incluso o item           ³±±
±±³          ³ cExp03 - Codigo do usuario/grupo                            ³±±
±±³          ³ cExp04 - Descricao da transacao                             ³±±
±±³          ³ cExp05 - Codigo da transacao                                ³±±
±±³          ³ aExp06 - Array contendo os usuarios do sistema - AllUsers() ³±±
±±³          ³ aExp07 - Array contendo os grupos de usuario do sistema -   ³±±
±±³          ³          AllGroups()                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240IncIt(oTree,cCargo,cCod,cTrans,cCodtra,aUsers,aGrps)
Local lRet      := .F.
Local lContinua := .T.
Local cNome     := ""
Local nPos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o item ja se encontra no dbTree  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if oTree:TreeSeek(cCargo+cCod)
	If !oTree:TreeSeek(cCargo+cCod+cCodtra)//Verifica se transacao ja existe
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui item no dbTree                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTree:AddItem(cTrans,cCargo+cCod+cCodtra,,,,,2)
		lRet := .T.
	EndIf
ElseIf oTree:TreeSeek(cCargo)//Posiciona na arvore
	If cCargo==FLG_ARVU
	    PswOrder(1)
     	If (  PswSeek(cCod, .T.) )
			cNome:=Pswret(1)[1][2]
		EndIf
	Else
		If (nPos:=ascan(aGrps,{|x| x[1,1] = cCod}))>0
			cNome:=aGrps[nPos,1,2]
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida usuário/grupo                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cNome)
		Aviso("CNTA240",OemToAnsi(STR0058),{"Ok"})//"Usuário/Grupo inexistente, selecione um usuário válido."
	    lContinua := .F.
	EndIf

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui item no dbTree                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTree:AddItem(cNome,cCargo+cCod,,,,,2)
		If oTree:TreeSeek(cCargo+cCod)
			oTree:AddItem(cTrans,cCargo+cCod+cCodtra,,,,,2)
			lRet := .T.
		EndIf
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240ListAc³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera lista sequencial das transacoes                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aExp01 := CN240ListAc(lExp02)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array preenchido pela rotina com a seguinte         ³±±
±±³          ³          estrutura:                                          ³±±
±±³          ³          -aExp02[x,1] = .F.                                  ³±±
±±³          ³          -aExp02[x,2] = Codigo da Transacao                  ³±±
±±³          ³          -aExp02[x,3] = Descricao da Transacao               ³±±
±±³          ³          -aExp02[x,4] = Listagem das transacoes pai, usado   ³±±
±±³          ³                         na query de pesquisa Ex: 'XXX','XXX' ³±±
±±³          ³                         quando lQuery==.T. OU apenas a       ³±±
±±³          ³                         identificacao da trancasao pai quando³±±
±±³          ³                         lQuery==.F.                          ³±±
±±³          ³          -aExp02[x,5] = Informa quando transacao possui      ³±±
±±³          ³                         filhas                               ³±±
±±³          ³          -aExp02[x,6] = Informa posicao da transacao pai     ³±±
±±³          ³                         quando possuir                       ³±±
±±³          ³ lExp02 - Monta estrutura pai para ser usada na query de      ³±±
±±³          ³          pesquisa, ou apenas carrega transacao superior      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240ListAc(lQuery)
Local nx        := 0
Local nPosPai   := 0
Local cInQry    := ""
Local aTrans    :={}
Local cDescT    :=""
Local cQuery    := {}
Local cAliasQry := GetNextAlias()

DEFAULT lQuery := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre tabela padrao de transacoes do SIGAGCT  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNO")
cQuery := "SELECT CNO.* FROM " + RetSQLName("CNO") + " CNO WHERE "
cQuery += "CNO.CNO_FILIAL = '"+ xFilial("CNO") +"' AND "
cQuery += "CNO.D_E_L_E_T_ = '' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

While !(cAliasQry)->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Identifica idioma e preenche descricao       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#ifdef SPANISH
		cDescT := (cAliasQry)->CNO_DSCSPA
	#else
		#ifdef ENGLISH
			cDescT := (cAliasQry)->CNO_DSCENG
		#else
			cDescT := (cAliasQry)->CNO_DESCRI
		#endif
	#endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a transacao possui pai           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty((cAliasQry)->CNO_CODPAI)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Encontra posicao da transacao pai            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPosPai := aScan(aTrans,{|x| x[2]==(cAliasQry)->CNO_CODPAI})) > 0
			aTrans[nPosPai,5] := .T.//Altera  marcacao informando que transacao possui filha
			If lQuery
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta query com a hierarquia das transacoes  ³
				//³ quando solicitado                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cInQry := aTrans[nPosPai,4]
				If Empty(cInQry)
					cInQry := "'"+(cAliasQry)->CNO_CODPAI+"'"
				Else
					cInQry += ",'"+(cAliasQry)->CNO_CODPAI+"'"
				EndIf

				aAdd(aTrans,{.F.,(cAliasQry)->CNO_CODTRA,cDescT,cInQry,.F.,nPosPai})
			Else
				aAdd(aTrans,{.F.,(cAliasQry)->CNO_CODTRA,cDescT,(cAliasQry)->CNO_CODPAI,.F.,nPosPai})
			EndIf
		EndIf
	Else
		aAdd(aTrans,{.F.,(cAliasQry)->CNO_CODTRA,cDescT,"",.F.,0})
	EndIf

	(cAliasQry)->(dbSkip())
EndDo

(cAliasQry)->(dbCloseArea())

Return aTrans

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240VldUsr³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o acesso do usuario a uma transacao especifica do    ³±±
±±³          ³ contrato                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240VldUsr(cExp01,cExp02,lExp03,lExp04)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAGCT                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Contrato                                           ³±±
±±³          ³ cExp02 - Codigo da Transacao                                ³±±
±±³          ³ lExp03 - Informa se exibe mensagem de erro                  ³±±
±±³          ³ lExp04 - Indica se o usuario podera VISUALIZAR o contrato   ³±±
±±³          ³ 			mesmo sem ter acesso ao mesmo. Esse parametro e	   ³±±
±±³          ³ 			enviado como .T. exclusivamente pela rotina de 	   ³±±
±±³          ³ 			liberacao (MATA097), e somente quando o documento  ³±±
±±³          ³ 			e do tipo CT (Contrato) e o Aprovador nao possui   ³±±
±±³          ³ 			acesso ao contrato.		   						   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240VldUsr(cContra,cTrans,lMens,lVisAprCt,cFilCTR)
Local cCod      := ""
Local cGrps     := ""
Local lRet      := .T.
Local aArea     := GetArea()
Local aAreaCN9  := CN9->( GetArea() )
Local cAliasQry := GetNextAlias()
Local aTrans    := {}
Local lPai
Local aGrp
Local nPos
Local nX
Local cQuery
Local lContinua := .T.

DEFAULT lMens 	  := .T.
DEFAULT lVisAprCt := .F.
DEFAULT cFilCTR 	:= cFilAnt

dbSelectArea("CN9")
dbSetOrder(1)
cCod := RetCodUsr()

dbSeek(xFilial("CN9",cFilCTR)+cContra)

	lContinua := (Empty(CN9->CN9_VLDCTR) .Or. CN9->CN9_VLDCTR == "1")


If lContinua
	dbSelectArea("SX2")
	dbSetOrder(1)
	lContinua := dbSeek("CNO") .And. !IsBlind()

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega transacoes e listagem com a estrutura³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aTrans := CN240ListAc(.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Encontra posicao da transacao                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aTrans,{|x| x[2] == AllTrim(cTrans)})) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a transacao possui pai           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lPai := !Empty(aTrans[nPos,4])

			dbSelectArea("CNN")
			dbSetOrder(1)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega Grupos do usuario                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aGrp := FWSFUsrGrps(cCod)

			For nX:=1 to len(aGrp)
				cGrps += "'"+aGrp[nX]+"',"
			Next
			cGrps := SubStr(cGrps,1,len(cGrps)-1)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra transacoes do usuario considerando pai³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "SELECT COUNT(*) AS QTD_TRA FROM " + RetSQLName("CNN") + " CNN WHERE "
			cQuery += "CNN.CNN_FILIAL = '"+ xFilial("CNN",cFilCTR) +"' AND "
			cQuery += "CNN.CNN_CONTRA = '"+ cContra +"' AND "
			If lPai
				cQuery += "CNN.CNN_TRACOD IN ('"+ cTrans +"',"+aTrans[nPos,4]+") AND "
			Else
				cQuery += "CNN.CNN_TRACOD = '"+ cTrans +"' AND "
			EndIf
			cQuery += "(CNN.CNN_USRCOD = '"+ cCod +"'"
			If len(aGrp) > 0
				cQuery += " OR CNN.CNN_GRPCOD IN ("+ cGrps +")"
			EndIf
			cQuery += ") AND CNN.D_E_L_E_T_ = ''"

			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se usuario possui acesso            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRet := ((cAliasQry)->QTD_TRA > 0)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acesso de VISUALIZACAO liberado quando o usuario e 	  ³
			//³ Aprovador do Contrato (MATA097) mas nao possui acesso ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lVisAprCt .AND. !lRet
				lRet := .T.
			EndIf

			(cAliasQry)->(dbCloseArea())

			If !lRet .And. lMens
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exibe mensagem de acesso negado              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If FunName() == "CNTA300"
					Help(" ",1,"CNNOTRANS")
				Else
				Aviso("CNTA240",OemToAnsi(STR0043),{"Ok"})//"Usuário não possui direito sobre a transação executada"
			EndIf
		EndIf
	EndIf
EndIf
EndIf
CN9->( RestArea(aAreaCN9) )
RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN240Cop   ³ Autor ³ Marcelo Custodio      ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Copia estrutura de acesso de outro contrato                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN240Cop(oExp01,aExp02,aExp03,aExp04,aExp05,cExp06)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 - DbTree                                             ³±±
±±³          ³ aExp02 - Array contendo as transacoes do sistema            ³±±
±±³          ³ aExp03 - Array contendo os relacionamentos UrsXTransacoes   ³±±
±±³          ³ aExp04 - Array contendo os usuarios do sistema - AllUsers() ³±±
±±³          ³ aExp05 - Array contendo os grupos de usuario do sistema -   ³±±
±±³          ³          AllGroups()                                        ³±±
±±³          ³ cExp06 - Codigo do contrato                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN240Cop(oTree,aTrans,aUsrs,aUsers,aGrps,cContra)
Local cContraN := Space(TamSX3("CN9_NUMERO")[1])
Local oGetContra
Local nOpca := 2
Local aUsrs2:={}
Local nx
Local nPos

DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0048) From 165,115 TO 245,430 PIXEL

@ 07,10 Say RetTitle("CN9_NUMERO") Of oDlg PIXEL
@ 05,40 MsGet oGetContra Var cContraN Valid (cContraN != cContra) F3 "CN9" Size 60,5 Of oDlg PIXEL

DEFINE SBUTTON FROM __DlgHeight(oDlg)-23, __DlgWidth(oDlg)-60 TYPE 1 ACTION (If(Empty(cContraN),Aviso("CNTA240",OemToAnsi(STR0030),{"Ok"}),(nOpca:=1,oDlg:End()))) ENABLE OF oDlg PIXEL
DEFINE SBUTTON FROM __DlgHeight(oDlg)-23, __DlgWidth(oDlg)-30 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega relacionamentos do contrato original ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aUsrs2 := CN240ArrUsr(cContraN,aUsers,aGrps)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Varre transacoes de usuarios                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nx:=1 to len(aUsrs2[1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se item já existe                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos:=aScan(aUsrs[1],{|x| x[1]==aUsrs2[1,nx,1] .And. x[2]==aUsrs2[1,nx,2]}))>0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera situacao quando estiver sido excluido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aUsrs[1,nPos,4] == FLG_RDEL
				aUsrs[1,nPos,4] := FLG_RORI
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inclui item                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aUsrs[1],aUsrs2[1,nx])
			aUsrs[1,len(aUsrs[1]),4] := FLG_RADD
		EndIf
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Varre transacoes de grupos                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nx:=1 to len(aUsrs2[2])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se item já existe                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos:=aScan(aUsrs[2],{|x| x[1]==aUsrs2[2,nx,1] .And. x[2]==aUsrs2[2,nx,2]}))>0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera situacao quando estiver sido excluido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aUsrs[2,nPos,4] == FLG_RDEL
				aUsrs[2,nPos,4] := FLG_RORI
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inclui item                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aUsrs[2],aUsrs2[2,nx])
			aUsrs[2,len(aUsrs[2]),4] := FLG_RADD
		EndIf
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza dbTree               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTree:BeginUpdate()
	If oTree:TreeSeek(FLG_ARVC)
		oTree:DelItem()
	EndIf
	oTree:Reset()
	oTree:Refresh()

	DBADDTREE oTree PROMPT OemToAnsi(STR0015)+Space(30) OPENED CARGO FLG_ARVC+space(9)
	CN240ItTree(oTree,aTrans,aUsrs)
	DBENDTREE oTree

	oTree:EndUpdate()
	oTree:Refresh()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³A240TudoOk ³ Autor ³ Bruno Schmidt	     ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se todos os acessos estão corretos                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static Function CNTA240Ok(aUsrs)
Local lRet:=.T.
Local ni  := 0
Local ny  := 0
Local x   := 0
Local y   := 0
Local nO  := 0
Local lAcess   := .T.


For ni:=1 to len(aUsrs[1])
	If aUsrs[1,ni,4] <> FLG_RDEL
		x+=1
	EndIF
Next
For ny:=1 to len(aUsrs[2])
	If aUsrs[2,ny,4] <> FLG_RDEL
		y+=1
	EndIF
Next

If Empty(x).and. Empty(y)
	Aviso("CNTA240",OemToAnsi(STR0060),{"Ok"})
	lret:=.F.
EndIF

For nO:=1 to len(aUsrs[1])
	If aUsrs[1,nO,4] <> FLG_RDEL
		If aUsrs[1,nO,2] == '041' .or. aUsrs[1,nO,2] == '001'
		lAcess := .F.
		EndIF
	EndIF
Next
For nO:=1 to len(aUsrs[2])
	If aUsrs[2,nO,4] <> FLG_RDEL
		If aUsrs[2,nO,2] == '041' .or. aUsrs[2,nO,2] == '001'
		lAcess := .F.
		EndIF
	EndIF
Next

If lAcess	
 Help( "" ,1,"CNTA240_CA")
	lret:=.F.
EndIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³c240UsBusca³ Autor ³ Aline S Damasceno     ³ Data ³07.03.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera array com os relacionamentos usuarios X transacoes do  ³±±
±±³          ³ contrato                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array com os relacionamentos usuariosXtransacao    ³±±
±±³          ³ Estrutura do aExp01:                                        ³±±
±±³          ³ -aExp01[1]-Usuarios                                         ³±±
±±³          ³  -aExp01[1,1]-Codigo do Usuario                             ³±±
±±³          ³  -aExp01[1,2]-Codigo da Transacao                           ³±±
±±³          ³  -aExp01[1,3]-Nome do Usuario                               ³±±
±±³          ³  -aExp01[1,4]-Situacao do registro: FLG_RORI - Original     ³±±
±±³          ³                                     FLG_RDEL - Excluido     ³±±
±±³          ³                                     FLG_RADD - Adicionado   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Function c240UsBusca(cContra,aUsrs)
Local aUsr      := {}
Local cQuery    := {}
Local aArea		:= GetArea()
Local aAreaCNN	:= CNN->(GetArea())
Local cAliasQry := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena a estrutura dos usuarios e grupos		            ³
//³-aUsr[1]      - Usuario/Grupo                                ³
//³--aUsr[1,1]   - email do usuario			                    ³
//³--aUsr[1,2]   - Id da Tabela				                    ³
//³--aUsr[1,3]   - login						                ³
//³--aUsr[1,4]   - Nome Completo     				            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNN")
cQuery := "SELECT CNN.* FROM " + RetSQLName("CNN") + " CNN WHERE "
cQuery += "CNN.CNN_FILIAL = '"+ xFilial("CNN") +"' AND "
cQuery += "CNN.CNN_CONTRA = '"+ cContra +"' AND "
cQuery += "CNN.CNN_GRPCOD = '' AND "
cQuery += "CNN.D_E_L_E_T_ = '' "
cQuery += "ORDER BY CNN.CNN_USRCOD,CNN.CNN_TRACOD"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

While !(cAliasQry)->(Eof())
    PswOrder(1)

   	If (PswSeek((cAliasQry)->CNN_USRCOD, .T.))
          aAdd(aUsr,{Pswret(1)[1][14],Pswret(1)[1][1],Pswret(1)[1][2],Pswret(1)[1][4]})
          aAdd(aUsrs[1],{Pswret(1)[1][1],(cAliasQry)->CNN_TRACOD,Pswret(1)[1][2],FLG_RORI})
   	EndIf

	(cAliasQry)->(dbSkip())
EndDo

(cAliasQry)->(dbCloseArea())
RestArea(aAreaCNN)
RestArea(aArea)
Return aUsr

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³c240GrBusca³ Autor ³ Aline S Damasceno     ³ Data ³07.03.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera array com os relacionamentos grupos X transacoes do    ³±±
±±³          ³ contrato                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array com os relacionamentos usuariosXtransacao    ³±±
±±³          ³ -aExp01[2]-Grupos                                           ³±±
±±³          ³  -aExp01[2,x,1]-Codigo do Grupo de Usuario                  ³±±
±±³          ³  -aExp01[2,x,2]-Codigo da Transacao                         ³±±
±±³          ³  -aExp01[2,x,3]-Nome do Grupo                               ³±±
±±³          ³  -aExp01[2,x,4]-Situacao do registro: FLG_RORI - Original   ³±±
±±³          ³                                       FLG_RDEL - Excluido   ³±±
±±³          ³                                       FLG_RADD - Adicionado ³±±
±±³          ³ aExp02 - Array contendo os usuarios do sistema - AllUsers() ³±±
±±³          ³ aExp03 - Array contendo os grupos de usuario do sistema -   ³±±
±±³          ³          AllGroups()                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function c240GrBusca(cContra,aGrps)
Local aUsr      := {}
Local aArea		:= GetArea()
Local aAreaCNN	:= CNN->(GetArea())
Local cQuery    := {}
Local cAliasQry := GetNextAlias()
Local nPos      := 0

dbSelectArea("CNN")
cQuery := "SELECT CNN.* FROM " + RetSQLName("CNN") + " CNN WHERE "
cQuery += "CNN.CNN_FILIAL = '"+ xFilial("CNN") +"' AND "
cQuery += "CNN.CNN_CONTRA = '"+ cContra +"' AND "
cQuery += "CNN.CNN_USRCOD = '' AND "
cQuery += "CNN.D_E_L_E_T_ = '' "
cQuery += "ORDER BY CNN.CNN_GRPCOD,CNN.CNN_TRACOD"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

While !(cAliasQry)->(Eof())

	If (nPos:=ascan(aGrps,{|x| x[1,1] = (cAliasQry)->CNN_GRPCOD}))>0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui registro de grupo                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aUsr,{(cAliasQry)->CNN_GRPCOD,(cAliasQry)->CNN_TRACOD,aGrps[nPos,1,2],FLG_RORI})
   	EndIf

	(cAliasQry)->(dbSkip())
EndDo

(cAliasQry)->(dbCloseArea())
RestArea(aAreaCNN)
RestArea(aArea)
Return aUsr

//-------------------------------------------------------------------
/*{Protheus.doc} ADDTREEPLAN
Adiciona as planilhas no Tree

@param oTree  - Objeto Tree
		cChave - Chave de pesquisa do registro da planilha

@author Aécio Ferreira Gomes
@since 11/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function ADDTREEPLAN(oTree, cChave)
Local aArea 	:= GetArea()

dbSelectArea("CNA")
dbSetOrder(1)
If CNA->(dbSeek(cChave))
	While (!Eof() .And. cChave == CNA_FILIAL+CNA_CONTRA+CNA_REVISA)
		DBADDTREE oTree PROMPT CNA_NUMERO RESOURCE "" CARGO CNA_CONTRA+CNA_NUMERO
		ADDTREEFAUT(oTree, CNA_CONTRA+CNA_NUMERO)
		DBENDTREE oTree
		dbSkip()
	End
EndIf

CNA->(dbCloseArea())
RestArea(aArea)
Return

//-------------------------------------------------------------------
/*{Protheus.doc} ADDTREEFAUT
Faz a carga das filiais autorizadas e adiciona no item do tree ou
adiciona um item especifico no tree das filiais autorizadas

@param oTree  - Objeto Tree
		cCargo - Chave de pesquisa do registro
		lLoad 	- Indica que será feito a carga das filiais para o tree
		cPlan  - Informe a planilha ao qual a filial pertence
		cFilAut- Informe a filiais que será adicionado no Tree
		aInc - Array com as filiais inclusas
		aExc - Array com as filiais excluidas


@author Aécio Ferreira Gomes
@since 11/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function ADDTREEFAUT(oTree, cCargo, lLoad, cPlan, cFilAut, aInc, aExc)
Local aArea := GetArea()

Default  lLoad := .T.

dbSelectArea("CPD")
dbSetOrder(1)

If lLoad
	dbSeek(xFilial("CPD")+cCargo)
	While (!Eof() .And. cCargo == CPD_CONTRA+CPD_NUMPLA)
		DBADDITEM oTree PROMPT CPD_FILAUT+" - " +FWFilialName(cEmpAnt,CPD_FILAUT) CARGO cCargo+CPD_FILAUT
		dbSkip()
	End
Else
	If !oTree:TreeSeek(cCargo+cFilAut)
		oTree:BeginUpdate()
		oTree:AddItem(cFilAut+" - " +FWFilialName(cEmpAnt,cFilAut),cCargo+cFilAut,,,,,2)
		oTree:EndUpdate()
		oTree:Refresh()
		If oTree:TreeSeek(cCargo+cFilAut)
			AADD(aInc, cCargo+cFilAut)

			If (nPos := aScan(aExc,{|x| Alltrim(x) == Alltrim(cCargo+cFilAut)})) > 0
				aDel(aExc, nPos)
				aSize(aExc, Len(aExc)-1)
			EndIf
		EndIf
	Endif
EndIf

CPD->(dbCloseArea())
RestArea(aArea)
Return

//-------------------------------------------------------------------
/*{Protheus.doc} CN240DelFil
Exclui o item da arvore de filiais autorizadas

@param oTree - Objeto Tree
		aInc - Array com as filiais inclusas
		aExc - Array com as filiais excluidas

@author Aécio Ferreira Gomes
@since 11/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function CN240DelFil(oTree, aInc, aExc)
Local aArea		:= GetArea()
Local cCargo		:= ""
Local cNumPlan 	:= ""
Local cNumCTR 		:= ""
Local cNumFil		:= Space(FWGETTAMFILIAL)
Local lRet			:= .T.
Local nTamCTR		:= TamSX3("CPD_CONTRA")[1]
Local nTamPlan		:= TamSX3("CPD_NUMPLA")[1]

cNumPlan:= SubStr(cCargo,nTamCTR+1,nTamPlan)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega chave do registro selecionado no dbTree³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCargo		:= oTree:GetCargo()
cNumCTR	:= SubStr(cCargo,1,nTamCTR)
cNumPlan	:= SubStr(cCargo,nTamCTR+1,nTamPlan)
cNumFil 	:= SubStr(cCargo,nTamCTR+nTamPlan+1,FWGETTAMFILIAL)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se foi selecionado grupo ou usuario   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !oTree:IsEmpty() .And. !Empty(cNumFil) .And. MsgYesNo(STR0063) //-- Deseja realmente excluir este item das filiais autorizadas para medição do contrato?
	oTree:BeginUpdate()
	If oTree:TreeSeek(cCargo)
		aAdd(aExc, cCargo)

		// Remove item do array de itens inclusos no tree
		If (nPos := aScan(aInc,{|x| Alltrim(x) == Alltrim(cCargo)})) > 0
			aDel(aInc, nPos)
			aSize(aInc, Len(aInc)-1)
		EndIf

		oTree:DelItem()
	EndIf
	oTree:EndUpdate()
	oTree:Refresh()
EndIf

RestArea(aArea)

Return

//-------------------------------------------------------------------
/*{Protheus.doc} CN240IncFil
Inclui um item na arvore de filiais autorizadas

@param oTree - Objeto Tree
		aInc - Array com as filiais inclusas
		aExc - Array com as filiais excluidas
		aPanel - Container onde o Dialog será criada

@author Aécio Ferreira Gomes
@since 11/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function CN240IncFil(oTree, aInc, aExc, oPanel)
Local oDlg			:= Nil
Local oFil			:= Nil
Local oDesc		:= Nil
Local aArea 		:= GetArea()
Local cCargo		:= oTree:GetCargo()
Local cCTRFIX		:= "0"
Local cNumPlan 	:= Space(TamSX3("CPD_NUMPLA")[1])
Local cNumFil		:= Space(FWGETTAMFILIAL)
Local cNomeFil		:= Space(30)
Local nTamCTR		:= TamSX3("CPD_CONTRA")[1]
Local nTamPlan		:= TamSX3("CPD_NUMPLA")[1]
Local nOpcX		:= 0
Local oSize

cNumPlan:= SubStr(cCargo,nTamCTR+1,nTamPlan)

DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0067) From 000,000 TO 150,450 PIXEL OF oPanel //"Fliais Autorizadas - Incluir"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula dimensões                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSize := FwDefSize():New(.T.,,,oDlg)
oSize:AddObject( "CABECALHO",  100, 100, .T., .T. ) // Totalmente dimensionavel

oSize:lProp 	:= .T. // Proporcional
oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3

oSize:Process() 	   // Dispara os calculos

@ oSize:GetDimension("CABECALHO","LININI")+2 	,oSize:GetDimension("CABECALHO","COLINI") SAY STR0068 OF oDlg PIXEL//"Filial"
@ oSize:GetDimension("CABECALHO","LININI") 	,oSize:GetDimension("CABECALHO","COLINI")+30 MSGET cNumFil F3 "SM0EMP" Valid ExistCpo("SM0",cEmpAnt+cNumFil) Size 60,5 OF  oDlg PIXEL PICTURE "@!"
@ oSize:GetDimension("CABECALHO","LININI")+22	,oSize:GetDimension("CABECALHO","COLINI") SAY STR0069 OF oDlg PIXEL//"Descrição"
@ oSize:GetDimension("CABECALHO","LININI")+20	,oSize:GetDimension("CABECALHO","COLINI")+30 MSGET IIF( !Empty( AllTrim(cNumFil) ), FWFilialName(cEmpAnt,cNumFil), cNomeFil ) WHEN .F. Size 150,5 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar (oDlg, {|| nOpcX := 1, oDlg:End()},{|| nOpcX := 2, oDlg:End()}) CENTERED

If nOpcX == 1
	If cCTRFIX == '1'
		CNA->(dbSetOrder(1))
		If CNA->(dbSeek(xFilial("CNA")+CN9->CN9_NUMERO+CN9->CN9_REVISA+cNumPlan))
			If oTree:TreeSeek(CN9->CN9_NUMERO+cNumPlan)
				ADDTREEFAUT(oTree, CN9->CN9_NUMERO+cNumPlan, .F., CNA->CNA_NUMERO, cNumFil, @aInc, @aExc)
			EndIf
		EndIf
	Else
		If oTree:TreeSeek(FLG_ARVF)
			ADDTREEFAUT(oTree, CN9->CN9_NUMERO+cNumPlan, .F., CNA->CNA_NUMERO, cNumFil, @aInc, @aExc)
		Endif
	EndIf
EndIf

RestArea(aArea)

Return

//-------------------------------------------------------------------
/*{Protheus.doc} CN240DelFil
Grava alteração nas filiais autorizadas x contrato

@param aInc - Array com as filiais inclusas
		aExc - Array com as filiais excluidas

@author Aécio Ferreira Gomes
@since 14/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function CN240GrvCPD(aInc, aExc)
Local aArea	:= GetArea()
Local nX 		:= 0
Local nTamCTR	:= TamSX3("CPD_CONTRA")[1]
Local nTamPla	:= TamSX3("CPD_NUMPLA")[1]

dbSelectArea("CPD")
dbSetOrder(1)

Begin Transaction

// Inclui os novos registros na CPD( Filiais autorizadas x contrato)
For nX := 1 To Len(aInc)
	If !dbSeek(xFilial("CPD")+aInc[nX])
		Reclock("CPD", .T.)
		CPD_FILIAL := xFilial("CPD")
		CPD_CONTRA := SubStr(aInc[nX],1,nTamCTR)
		CPD_NUMPLA := SubStr(aInc[nX],nTamCTR+1,nTamPla)
		CPD_FILAUT := SubStr(aInc[nX],nTamCTR+nTamPla+1,FWGETTAMFILIAL)
		MsUnlock()
	EndIf
Next nX

// Exclui os registros da CPD( Filiais autorizadas x contrato)
For nX := 1 To Len(aExc)
	If dbSeek(xFilial("CPD")+aExc[nX])
		Reclock("CPD", .F.)
		dbDelete()
		MsUnlock()
	EndIf
Next nX

End Transaction

RestArea(aArea)
Return

//==============================================================================================================================
/*/{Protheus.doc} Cn240VldGr()
Função responsável por validar existência do grupo selecionado no controle de acesso
@author Israel.Escorizza 
@since 08/02/2017 / 
@return
/*/
//==============================================================================================================================
Function Cn240VldGr(cTipo, cCodGen)
Local lRet 		:= .F.

Default cTipo	:= ""
Default cCodGen := ""

If !Empty(cTipo) .And. !Empty(cCodGen)
	If cTipo == 'USR'
		lRet := !Empty(UsrRetName(cCodGen))
	Else
		lRet := !Empty(GrpRetName(cCodGen))
	EndIf
EndIf

If !lRet
	Aviso("CNTA240",OemToAnsi(STR0058),{"Ok"})//"Usuário/Grupo inexistente, selecione um usuário válido."
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Cn240HPOPUP
Habilita/desabilita opções dos MENUS POPUP

@param oTree, Objeto,  Objeto TREE
@param nX, Númerico,  Linha inicial
@param nY, Númerico,  Coluna inicial
@param oMenu, Objeto,  Objeto OMENU
@param cNomeMenu, Caracter, Nome do MENU posicionado
@return Nenhum
@author Eduardo Gomes Júnior
@since 14/03/2018
/*/
//-------------------------------------------------------------------
Function Cn240HPOPUP( oTree, nX, nY, oMenu, cNomeMenu )

Local cCargo
Local nTamCTR		:= TamSX3("CPD_CONTRA")[1]
Local nTamPlan		:= TamSX3("CPD_NUMPLA")[1]
Local cNumFil		:= Space(FWGETTAMFILIAL)

cCargo		:= oTree:GetCargo()
cNumCTR		:= SubStr(cCargo,1,nTamCTR)
cNumPlan	:= SubStr(cCargo,nTamCTR+1,nTamPlan)
cNumFil 	:= SubStr(cCargo,nTamCTR+nTamPlan+1,FWGETTAMFILIAL)

//Tratamento para MENU de Acessos
If	cNomeMenu == "oMenuTree"

	AEval( oMenu:aItems, { |x| x:disable() } )
	
	If	SubStr(cCargo,1,1) == FLG_ARVC 
		oMenu:aItems[5]:enable()	//Copiar Estrutura
	Endif

	//Usuário
	If	SubStr(cCargo,1,1) == FLG_ARVU	.AND. Len(Alltrim(cCargo)) <= 1  
		oMenu:aItems[1]:enable()	//Incluir Usuario
	Endif
	
	If	SubStr(cCargo,1,1) == FLG_ARVU	.AND. Len(Alltrim(cCargo)) > 2  
		oMenu:aItems[3]:enable()	//Edita	
		oMenu:aItems[4]:enable()	//Exclui
	Endif

	//Grupos
	If	SubStr(cCargo,1,1) == FLG_ARVG	.AND. Len(Alltrim(cCargo)) <= 1
		oMenu:aItems[2]:enable()	//Incluir Grupo
	Endif
	
	If	SubStr(cCargo,1,1) == FLG_ARVG	.AND. Len(Alltrim(cCargo)) > 2  
		oMenu:aItems[3]:enable()	//Edita	
		oMenu:aItems[4]:enable()	//Exclui	
	Endif

Endif 

//Tratamento para MENU de Filiais Autorizadas para Medição
If	cNomeMenu == "oMenuTreeFil"

	If	SubStr(cCargo,1,1) == FLG_ARVF 
		oMenu:aItems[1]:disable()	//Incluir Filial
		oMenu:aItems[2]:disable()	//Excluir Filial
	Else
	
		If	Empty(cNumFil) 
			oMenu:aItems[1]:enable()	//Incluir Filial
			oMenu:aItems[2]:disable()	//Excluir Filial
		Else
			oMenu:aItems[1]:disable()	//Incluir Filial
			oMenu:aItems[2]:enable()	//Excluir Filial
		Endif 		
		 		
	Endif

Endif 	
	 	 
//Ativa o Menu PopUp
oMenu:Activate( nX, nY, oTree )
                                   
Return 
