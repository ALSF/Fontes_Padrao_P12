#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSGPE030.CH"
#DEFINE PAGE_LENGTH 10

//WsClient_WsRHPaymentReceipts.prx
Function WSGPE030()
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSGPE030  ³ Autor ³Equipe RH                   ³ Data ³12.02.2014  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demonstrativo de pagamento                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ Requisito ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Bruno Nunes   ³12/02/14³           ³ Unificacao da V12                        ³±±
±±³Emerson Campos|30/04/14|TPKFN9     |Replica das alterações realizadas pela    ³±±
±±³              |        |           |manutenção até dt 12/02/14 chamado TPI162,³±±
±±³              |        |           |changeset 223249 na P11.80                ³±±
±±³Flavio Correa |27/05/14|Req.196101 |Colocado %noparser na query               ³±±
±±³              |        |           |                                          ³±±
±±³Allyson M     |25/06/14|TPSEC2     |Ajuste p/ somar referencia de verba igual ³±±
±±³Allyson M     |22/10/14|TQUQES     |Ajuste p/ demonstrar valor total de pensao³±±
±±³Cícero Alves  |21/07/15|TSXPPB     |Alteração para que apareça mensagem de 	 ³±±
±±³              |        |           |felicitação no mês de aniversário         ³±±
±±³Allyson M     |31/07/15|TSPMBC     |Ajuste p/ demonstrar pagamento de PLR     ³±±
±±³Cícero Alves  |07/08/15|TTAIJ2     |enviar o nome completo do funcionario	 ³±±
±±³              |        |           |quando estiver preenchido 				 ³±±
±±³Allyson M     |27/11/15|TTYDJW     |Ajuste p/ validar a data de liberacao dos ³±±
±±³              |        |           |demonstrativos corretamente 				 ³±±
±±³Renan Borges  |09/12/15|TTSYXZ     |Ajuste para mostrar no campo endereço, o  ³±±
±±³              |        |           |número do seu endereço também.            ³±±
±±³Matheus M.    |28/01/16|TUEHSL     |Ajuste para considerar o parâmetro        ³±±
±±³              |        |           |MV_TCF013A para filtro dos demonstrativos.³±±
±±³Eduardo K.    |24/06/16|TVLPS4     |Ajuste para que o recibo de pagamento     ³±±
±±³				 |        |           |esteja disponível para autonomos.         ³±±
±±³Matheus M.    |19/07/16|TVQNRZ     |Ajuste para remover caracteres especiais  ³±±
±±³              |        |           |nos campos RA_BAIRRO e RA_ENDEREC.		 ³±±
±±³Matheus M.    |22/07/16|TVQYHJ     |Ajuste para exibir o demonstrativo correta³±±
±±³              |        |           |mente quando possuir transferencias entre ³±±
±±³              |        |           |empresas e troca de matrículas.           ³±±
±±³Marcelo Faria |19/08/16|TUUTMV     |Melhoria nos filtros para demonstrativos e³±±
±±³              |        |           |implementação da paginação                ³±±
±±³Matheus M.    |08/09/16|TVSNRC     |Ajuste para remover caracteres especiais  ³±±
±±³              |        |           |na descrição das verbas.				     ³±±
±±³Matheus M.    |14/09/16|TVQYHJ     |Ajuste para respeitar o período de transfe³±±
±±³              |        |           |rência na exibição do demonstrativo.      ³±±
±±³Raquel Hager  |18/11/16|97975      |Ajuste para não recebir o demonstrativo ao³±±
±±³              |        |           |trocar de matrícula na URL do link.       ³±±
±±³Flavio C.     |23/12/16|MRH-3354   |Impressao de Banco /agencia mesmo sem SA6 ³±±
±±³Gabriel A.    |06/01/17|           |Ajuste para limitar a quantidade de       ³±±
±±³              |        |           |recibos de pagamento demonstrados.        ³±±
±±³Isabel N.    |26/06/17|DRHPONTP-819|Ajuste p/ não mostrar recibo de outro fun_³±±
±±³             |        |(Réplica DRH|cionário caso deixe a matrícula em branco ³±±
±±³             |        |PONTP-775)  |na URL de consulta do recibo de pagamento.³±±
±±³João Balbino  |05/11/17|           |Ajuste para não duplicar os registros de  ³±±
±±³              |        |           |funcionários transferidos.                ³±±
±±³João Balbino  |16/01/18|MPRIMESP   |Ajuste para demosntrat corretamente os re-³±±
±±³              |        |13282      |cibos de pagamten para transferidos.      ³±±
±±³Eduardo K.    |19/01/18|MPRIMESP   |Ajuste no índice da tabela utilizado na   ³±±
±±³              |        |13371      |exibição do demonstrativo no portal.      ³±±
±±³Wesley Alves  |27/02/19|DRHGCH-8415|Correção da impressão do Holerite quando  ³±±
±±³              |        |           |ocorre variação salarial dentro do período³±±

±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSSTRUCT TPaymentReceipts
	WSDATA CompanyName					As String
	WSDATA CNPJ							As String
	WSDATA Branch						As String
	WSDATA EmployeeRegistration			As String
	WSDATA EmployeeName					As String
	WSDATA FunctionDescription			As String
	WSDATA AdmissionDate				As Date
	WSDATA Address						As String
	WSDATA District						As String
	WSDATA ZipCode						As String
	WSDATA City							As String
	WSDATA State						As String
	WSDATA PIS							As String
	WSDATA CPF							As String
	WSDATA Identity						As String
	WSDATA Competence					As String
	WSDATA MonthCompetence				AS Integer
	WSDATA FamilyAllowanceDependents	As Integer
	WSDATA IRRFDependents				As Integer
	WSDATA FixedSalary					As Float
	WSDATA PaymentDate					As Date
	WSDATA BankName						As String
	WSDATA BankAgency					As String
	WSDATA BankAccount					As String
	WSDATA FGTSBase						As Float
	WSDATA MontlyFGTS					As Float				// FGTS do mes
	WSDATA RevenueTotal					As Float				// Total de Proventos
	WSDATA IRRFCalculationBasis			As Float				// Base Cálc. IRRF
	WSDATA Alimony						As Float				// Pensão Alimentícia Judicial
	WSDATA DiscountTotal				As Float				// Total de Descontos
	WSDATA INSSSalaryContribution		As Float				// Sal. Contribuição. INSS
	WSDATA ReceivableNetValue 			As Float				// Líquido a Receber
	WSDATA Logo							As String  Optional
	WSDATA Itens						As Array Of TPaymentReceiptsItem OPTIONAL
	WSDATA BirthDate					As Date   				//Data de nascmineto do funcionario
ENDWSSTRUCT

WSSTRUCT TPaymentReceiptsList
	WSDATA Year							As Integer
	WSDATA Month						As Integer
	WSDATA Week							As String
	WSDATA Type	   						As Integer
	WSDATA Archived 					As Boolean
	WSDATA Branch						As String
	WSDATA Registration					As String
	WSDATA Emp							AS String
	WSDATA RHMat						As String OPTIONAL
	WSDATA DataPagamento				As Date
ENDWSSTRUCT

WSSTRUCT TPaymentReceiptsItem
	WSDATA Code							As String
	WSDATA Description					As String
	WSDATA Reference					As Float
	WSDATA Revenue						As Float
	WSDATA Discount						As Float
ENDWSSTRUCT

WSSTRUCT TPaymentReceiptsBrowse
	WSDATA Itens						AS Array Of TPaymentReceiptsList	OPTIONAL
	WSDATA PagesTotal	    			AS Integer 							OPTIONAL
ENDWSSTRUCT

WSSERVICE RHPaymentReceipts DESCRIPTION STR0001
	WSDATA WsNull   	   				As String	OPTIONAL
	WSDATA Branch						As String
	WSDATA Registration					As String
	WSDATA Month						As Integer
	WSDATA Year							As Integer
	WSDATA Week							As String	OPTIONAL
	WSDATA Type							As Integer
	WSDATA Archived						As Boolean	
	WSDATA RHBranch						As String	OPTIONAL
	WSDATA RHReg						As String	OPTIONAL
	WSDATA PaymentReceiptsBrowse		As TPaymentReceiptsBrowse
	WSDATA PaymentReceipt				AS TPaymentReceipts
	WSDATA CurrentPage					As Integer	OPTIONAL
	WSDATA FilterField  				As String	OPTIONAL
	WSDATA FilterValue					As String	OPTIONAL
	
	WSDATA RHMat						As String OPTIONAL
	WSDATA Company			    		As String OPTIONAL
	
	
	WSMETHOD BrowsePaymentReceipts		DESCRIPTION STR0002
	WSMETHOD GetPaymentReceipt			DESCRIPTION STR0003
ENDWSSERVICE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³BrowsePaymentReceipts                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrowsePaymentReceipts;
	WSRECEIVE Branch, Registration, CurrentPage, FilterField, FilterValue, RHMat;
	WSSEND PaymentReceiptsBrowse;
	WSSERVICE RHPaymentReceipts
Local cQuery:= GetNextAlias()
Local cSRCBranch := xFilial("SRC", Self:Branch)
Local cSRDBranch := xFilial("SRD", Self:Branch)
Local cRegistration:= Self:Registration
Local aCodFol := {}
Local aVerbas := {}
Local cVerbas := ''
Local aLibDemo := {	Val(getmv("MV_TCFDADT", NIL, "0")),;
						Val(getmv("MV_TCFDFOL", NIL, "0")),;
						Val(getmv("MV_TCFD131", NIL, "0")),;
						Val(getmv("MV_TCFD132", NIL, "0")),;
						Val(getmv("MV_TCFDEXT", NIL, "0")),;
						Val(getmv("MV_TCFDFOL", NIL, "0")),;
						Val(getmv("MV_TCFDFOL", NIL, "0"))	}
Local lMostraRec  := .F.
Local dDataLib    :=	CtoD('')
Local dDataPag    :=	CtoD('')
Local nDifData    := 0
Local nI          := 0
Local nIAux       := 0
Local nTamArray   := 0
Local aTransf     := {}
Local lFiltro     := !Empty(Self:FilterValue)
Local dPagto      := CtoD('//')
Local cOpReg      := SuperGetMv('MV_TCF013A',,'01.02.03.04.05')
Local cMat        := Self:RHMat
Local aTransAux   := {}
Local lTransfEmp  := .F.
Local lOK         := .F.
Local nRecCount   := 0
Local nRegIni     := 1
Local nRegFim     := 0
Local nReg        := 0
Local nTotHol     := SuperGetMv( "MV_TCFQHOL" , NIL , 0)
Local cMod		:= IIF(SRA->RA_REGIME=='2', 'GFP','GPE')
Local nQtdHol     := 0
Local lVldHol     := .T.
Local aLogErr	  := {}
Local nx		  := 0
Local cErro 	:= ""
Local nTrans 	:= 1
Local lExistPE	:= ExistBlock("LIBRECPAG")
Local lRetBlock	
Local dDataTrf 	:=	ctod("  /  /  ")

Self:PaymentReceiptsBrowse            := WSClassNew("TPaymentReceiptsBrowse")
Self:PaymentReceiptsBrowse:Itens      := {}
Self:PaymentReceiptsBrowse:PagesTotal := 0

dbSelectArea("SRA")
dbSetOrder(1)

If Empty(Self:Registration) .or. !dbSeek(xFilial("SRA", Self:Branch) + Self:Registration)
	Return .T.
Endif

If !Fp_CodFol(@aCodFol, xFilial('SRV', Self:Branch),,,@aLogErr)
	//Monta string com todas as verbas não cadastradas
	For nx:=1 to len(aLogErr)
		cErro += aLogErr[nx]
		cErro += " - " 
	Next
	cErro:= Substr(cErro,1,Len(cErro)-2)
	
	If Len (aLogErr) == 1
		SetSoapFault(PorEncode(STR0004),PorEncode(cErro))
	Else
		SetSoapFault(PorEncode(STR0005),PorEncode(cErro))
	Endif
	Return(.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega Todas as Transferencias Anteriores do Funcionario     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fTransfAll(@aTransf,,,.T.)
nTamArray	:= Len(aTransf)

// - Verifica se houve transferência apenas entre empresas e com troca de matrículas.
aEval( aTransf , { |x| If( x[1] != x[4] , ( lTransfEmp := .T. ) , NIL ) } )	


// - Caso haja transferências entre empresas com troca de matrículas.	
If	lTransfEmp
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza transferencias de centro de custo                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/	
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
		
	// - Faz a impressão corretamente para as empresas do funcionário
	fImpTransfEmp(@Self:PaymentReceiptsBrowse,Self:Branch,Self:Registration,Self:FilterField,Self:FilterValue,aTransf,aTransAux,lTransfEmp,lMostraRec,aLibDemo,aVerbas)
	
Else
	
	DetailReceipts(@cQuery,nTamArray,aTransf,cSRCBranch,cRegistration,cSRDBranch,Self:Branch,,,,.T.)
	
	aAdd(aVerbas, fGetCalcRot('2',cMod)) // ADI
	aAdd(aVerbas, fGetCalcRot('1',cMod)) // FOL
	aAdd(aVerbas, fGetCalcRot('5',cMod)) // 131
	aAdd(aVerbas, fGetCalcRot('6',cMod)) // 132
	aAdd(aVerbas, fGetCalcRot('F',cMod)) // PLR
	aAdd(aVerbas, fGetCalcRot('9',cMod)) // AUT
	aAdd(aVerbas, fGetCalcRot('K',cMod)) // VEX	

	COUNT TO nRecCount
	(cQuery)->(DbGoTop())

	If nRecCount > 0
		Self:PaymentReceiptsBrowse:PagesTotal := Ceiling(nRecCount / PAGE_LENGTH) 
		
		// Define qual a página inicial e final de acordo com a paginacao corrente		
		nRegFim	:= CurrentPage * PAGE_LENGTH
		If CurrentPage > 1
			nRegIni:= (nRegFim - PAGE_LENGTH) + 1
		EndIf

		While (cQuery)->(!Eof() .And. lVldHol)
			oItem:= WSClassNew("TPaymentReceiptsList")
			oItem:Year			:= Val(SubStr((cQuery)->RC_PERIODO,1,4))
			oItem:Month			:= Val(SubStr((cQuery)->RC_PERIODO,5,2))
			oItem:Week			:= (cQuery)->RC_SEMANA
			oItem:Type			:= aScan(aVerbas, {|aItemVerba| aItemVerba == (cQuery)->RC_ROTEIR } )
			oItem:Archived		:= ((cQuery)->ARCHIVED == 1)
			oItem:Branch		:= (cQuery)->FILIAL
			oItem:Registration	:= (cQuery)->MATRICULA
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pega data de pagamento dentro do cadastro de periodo          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RCH->(dbSetOrder(1))
			If RCH->(dbSeek(xFilial('RCH', SRA->RA_FILIAL)+SRA->RA_PROCES+(cQuery)->(RC_PERIODO+RC_SEMANA+RC_ROTEIR))) //RCH_FILIAL, RCH_PER, RCH_NUMPAG, RCH_PROCES, RCH_ROTEIR, RCH_DTINI, RCH_DTFIM, RCH_MODULO, R_E_C_D_E_L
				If !Empty(RCH->RCH_DTPAGO)
					dPagto := RCH->RCH_DTPAGO
				Else
					dPagto := StoD((cQuery)->RC_PERIODO+'01')
				EndIf
			Else
				dPagto := StoD((cQuery)->RC_PERIODO+'01')
			EndIf
			oItem:DataPagamento := dPagto
			
			// - Empresa utilizada para processamento dos dados.
			oItem:Emp := cEmpAnt
			
			lMostraRec	:=	.F.
			
			If lExistPE
				lRetBlock := ExecBlock("LIBRECPAG",.F.,.F.,{dPagto,(cQuery)->FILIAL,(cQuery)->MATRICULA,oItem:Type,oItem:Year,oItem:Month	})
				lMostraRec := If( ValType(lRetBlock) == "L" , lRetBlock , .T. )			
			Else
				If ( oItem:Type == 2 )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Trata o parametro "MV_TCFDFOL" como excecao, pois este parametro indica a quantidade de dias para liberacao ³
					//³do demonstrativo. Os demais parametros, indicam a data inicial de liberacao.                                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( aLibDemo[oItem:Type] < 0 )
						lMostraRec	:=	dDataBase - dPagto >= aLibDemo[oItem:Type]
					Else
						lMostraRec	:=	dDataBase >= dPagto + aLibDemo[oItem:Type]
					EndIf
				Else
					If oItem:Type > 0
						dDataLib	:=	STOD( MesAno(dPagto ) + STRZERO(aLibDemo[oItem:Type] , 2) )
						lMostraRec	:= ( dDataBase  >= dDataLib )
					EndIf
				EndIf
			EndIf
			If ( lMostraRec )
            	lOK := .F.

				If !lFiltro .Or.;
						( lFiltro .And. Self:FilterField == "CODTIPO" .AND. Self:FilterValue == alltrim(str(oItem:Type))         ) .Or.;
						( lFiltro .And. Self:FilterField == "PERIODO" .AND. Self:FilterValue == (cQuery)->RC_PERIODO             ) .Or.;
						( lFiltro .And. Self:FilterField == "ANO"     .AND. Self:FilterValue == SubStr((cQuery)->RC_PERIODO,1,4) )
					If ( cValToChar(oItem:Type) $ cOpReg )
                       lOK := .T.
					ElseIF (oItem:Type == 6) 
                       lOK := .T.
					ElseIF (oItem:Type == 7)
                       lOK := .T.
					ElseIF Empty(cOpReg)
                       lOK := .T.
                    Else
                       (cQuery)->(DBSkip())
                       Loop
					EndIF

                  If lOK
                     nReg++

						nRegFim := Iif(nRegFim == 0, 1, nRegFim) // Atribui valor padrão caso a conta CurrentPage * PAGE_LENGTH retorne 0.
				    	If nRegIni <= nReg .AND. nRegFim >=  nReg 
							AAdd(Self:PaymentReceiptsBrowse:Itens, oItem)
						EndIf	
                  EndIf
				EndIf
			Else
				nQtdHol := nQtdHol - 1
			EndIf

			nQtdHol := nQtdHol+1	
			
			If nTotHol > 0//Controla quantidade de holerites a serem devolvidos como resposta do serviço
				If nQtdHol >= nTotHol
					lVldHol := .F.
				EndIf
			EndIf
			
			(cQuery)->(DBSkip())
		EndDo
	EndIf	

   If nReg != nRecCount
		Self:PaymentReceiptsBrowse:PagesTotal := Ceiling(nReg / PAGE_LENGTH)
   EndIf
	
   (cQuery)->(DBCloseArea())	
   
   aSort(self:PaymentReceiptsBrowse:Itens,,,{|x,y| strzero(x:Year,4)+strzero(x:Month,2)+dtos(x:datapagamento) > strzero(y:Year,4)+strzero(y:Month,2)+dtos(y:datapagamento) .And. x:datapagamento > y:datapagamento})
EndIf
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³GetPaymentReceipt                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetPaymentReceipt;
	WSRECEIVE Branch, Registration, Month, Year, Week, Type, Archived, RHBranch, RHReg, Company;
	WSSEND PaymentReceipt;
	WSSERVICE RHPaymentReceipts
Local aInfo
Local aTransf	:= {}
Local dDataRef	:= CToD("01/" + AllTrim(Str(Self:Month)) + "/" + AllTrim(Str(Self:Year)))
Local dLastData	:= CToD(AllTrim(Str(Last_Day( dDataRef )))+"/" + AllTrim(Str(Self:Month)) + "/" + AllTrim(Str(Self:Year)))
Local cCodFunc 	:= ""
Local cDescFunc := ""
Local lAchouMat := .T.
Local nCont		:= 0
Local cEnde		:= ""
Local lTransfemp:= .F.
Local cAlias 	:= "SRA"
Local cAliasSRJ  := "SRJ"
Local cAliasSA6  := "SA6"
Local cAliasSR3  := "SR3"
Local cAliasSR7  := "SR7"
Local cAliasSRC	 := "SRC"
Local cAliasSRD	 := "SRD"
Local cAliasSRI  := "SRI"
Local cAliasSRV	 := "SRV"
Local cAliasSR1	 := "SR1"
Local cAliasSRQ	 := "SRQ"
Local cBkpEmp	 := cEmpAnt
Local cModo		 := FWModeAccess(cAlias)
Local cModoSRC	 := FWModeAccess(cAliasSRC)
Local cModoSRD	 := FWModeAccess(cAliasSRD)
Local cModoSRI	 := FWModeAccess(cAliasSRI)
Local cModoSRV	 := FWModeAccess(cAliasSRV)
Local cModoSR1	 := FWModeAccess(cAliasSR1)
Local cModoSRQ	 := FWModeAccess(cAliasSRQ)
Local cModoSA6	 := FWModeAccess(cAliasSA6)
Local cModoSR3	 := FWModeAccess(cAliasSR3)
Local cModoSR7	 := FWModeAccess(cAliasSR7)
Local cModoSRJ	 := FWModeAccess(cAliasSRJ)
Local cBanco	 := ""
Local cAg		 := ""
Local cProcesso	 := ""
Local cPer		 := ""
Default Company := cEmpAnt
OpenSx2Temp(Self:Company)

	
MyOpenFilePortal(cAlias,cAlias,1,.T.,Self:Company,@cModo)
MyOpenFilePortal(cAliasSA6,cAliasSA6,1,.T.,Self:Company,@cModoSA6)
MyOpenFilePortal(cAliasSR3,cAliasSR3,1,.T.,Self:Company,@cModoSR3)
MyOpenFilePortal(cAliasSR7,cAliasSR7,1,.T.,Self:Company,@cModoSR7)
MyOpenFilePortal(cAliasSRJ,cAliasSRJ,1,.T.,Self:Company,@cModoSRJ)

dbSelectArea("SRA")
SRA->( dbSetOrder(1) )

If SRA->( DBSeek(xFilial("SRA", Self:Branch) + Self:Registration) )

	//Se a matricula requerida for diferente da matricula de login, verifica se a matricula
	//requerida e' uma matricula anterior do funcionario (ex: transferencias)
	If  !Empty( Self:RHBranch + Self:RHReg) .AND. !(Self:RHBranch + Self:RHReg == Self:Branch + Self:Registration)
		lAchouMat := .F.
		If cEmpAnt != Self:Company
			If !DBSeek(xFilial("SRA", Self:RHBranch) + Self:RHReg)
				SetSoapFault(PorEncode(STR0006),PorEncode(STR0007))
				Return .F.
			Endif
		EndIf
		
		fTransfAll(@aTransf,,,.T.)
		
		For nCont := 1 To Len(aTransf)
			If ( aScan(aTransf, { |aTransf| aTransf[1]+aTransf[8]+aTransf[9] == cBkpEmp+Self:RHBranch+Self:RHReg .Or. aTransf[4]+aTransf[10]+aTransf[11] == cBkpEmp+Self:RHBranch+Self:RHReg } ) ) > 0
				lAchouMat := .T.
			EndIf
		Next nCont
	Endif
	
	If !lAchouMat
		SetSoapFault(PorEncode(STR0006),PorEncode(STR0007))
		Return .F.
	EndIf
	
	If cEmpAnt != Self:Company
		If !dbSeek(xFilial("SRA", Self:Branch) + Self:Registration)
			SetSoapFault(PorEncode(STR0006),PorEncode(STR0007))
			Return(.F.)
		Endif
	EndIf
	
	If !fInfo(@aInfo, Self:Branch)
		SetSoapFault(PorEncode(STR0006),PorEncode(STR0007))
		Return(.F.)
	Endif
	
	aTransf := {}
	fTransfProc(@aTransf)
	cPer := strzero(Self:Year,4)+strzero(Self:Month,2)
	cProcesso := SRA->RA_PROCES
	For nCont := 1 To Len(aTransf)
		If cPer < aTransf[nCont][12]
			cProcesso := aTransf[nCont][14]
		EndIf
	Next nCont
	
	
	Self:PaymentReceipt := WSClassNew("TPaymentReceipts")
	Self:PaymentReceipt:CompanyName := aInfo[3]
	Self:PaymentReceipt:CNPJ		:= aInfo[8]
	Self:PaymentReceipt:Branch		:= Self:Branch
	Self:PaymentReceipt:Logo		:= RetLogoemp(.T.,cEmpAnt,Self:Branch)
	
	Self:PaymentReceipt:EmployeeRegistration:= SRA->RA_MAT
	
	If ! Empty(SRA->RA_NOMECMP)
		Self:PaymentReceipt:EmployeeName	:= SRA->RA_NOMECMP
	Else
		Self:PaymentReceipt:EmployeeName	:= SRA->RA_NOME
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fBuscaFunc(dLastData,@cCodFunc, @cDescFunc, TamSx3("RJ_DESC")[1] ) 
		
	If !Empty(SRA->RA_NUMENDE)
		cEnde := Alltrim(SRA->RA_ENDEREC) + " " +  SRA->RA_NUMENDE
	Else
		cEnde := SRA->RA_ENDEREC
	EndIf
	
	Self:PaymentReceipt:FunctionDescription			:= cDescFunc //Alltrim(Posicione("SRJ", 1, xFilial("SRJ", Self:Branch) + SRA->RA_CODFUNC, "SRJ->RJ_DESC"))
	Self:PaymentReceipt:AdmissionDate				:= SRA->RA_ADMISSA
	Self:PaymentReceipt:Address						:= FSubst(cEnde)
	Self:PaymentReceipt:District					:= FSubst(SRA->RA_BAIRRO)
	Self:PaymentReceipt:City						:= SRA->RA_MUNICIP
	Self:PaymentReceipt:State						:= SRA->RA_ESTADO
	Self:PaymentReceipt:ZipCode						:= SRA->RA_CEP
	Self:PaymentReceipt:PIS							:= SRA->RA_PIS
	Self:PaymentReceipt:CPF							:= SRA->RA_CIC
	Self:PaymentReceipt:Identity					:= SRA->RA_RG
	Self:PaymentReceipt:BirthDate					:= SRA->RA_NASC
	Self:PaymentReceipt:MonthCompetence				:= If(Self:Month == 13, 12, Self:Month) //Mes da competencia  
	Self:PaymentReceipt:Competence					:= AllTrim(MesExtenso(Self:Month)) + "/" + AllTrim(Str(Self:Year))
	Self:PaymentReceipt:FamilyAllowanceDependents	:= Val(SRA->RA_DEPSF)
	Self:PaymentReceipt:IRRFDependents				:= Val(SRA->RA_DEPIR)
	Self:PaymentReceipt:PaymentDate					:= fGetPayDate(Self:Branch, Self:Registration, Self:Month, Self:Year, Self:Week, Self:Type, Self:Archived)	
	Self:PaymentReceipt:FixedSalary					:= fGetSalary(dDataRef,Self:PaymentReceipt:PaymentDate,Self:Type)
	cBanco := Alltrim(Posicione("SA6", 1, xFilial("SA6", Self:Branch) +  substr(SRA->RA_BCDEPSA,1,3), "SA6->A6_NOME"))
	If Empty(cBanco)
		Self:PaymentReceipt:BankName					:= substr(SRA->RA_BCDEPSA,1,3)
	Else
		Self:PaymentReceipt:BankName					:= substr(SRA->RA_BCDEPSA,1,3) + " - " + cBanco
	EndIf
	cAg := Alltrim(Posicione("SA6", 1, xFilial("SA6", Self:Branch) + SRA->RA_BCDEPSA, "SA6->A6_AGENCIA"))
	If Empty(cAg)
		Self:PaymentReceipt:BankAgency					:= substr(SRA->RA_BCDEPSA,4)
	Else
		Self:PaymentReceipt:BankAgency					:= cAg
	EndIf
	Self:PaymentReceipt:BankAccount					:= SRA->RA_CTDEPSA
	Self:PaymentReceipt:FGTSBase					:= 0							//nBaseFgts
	Self:PaymentReceipt:MontlyFGTS					:= 0							//nFgts
	Self:PaymentReceipt:IRRFCalculationBasis		:= 0							//nBaseIr
	Self:PaymentReceipt:INSSSalaryContribution		:= 0
	Self:PaymentReceipt:Alimony						:= 0
	Self:PaymentReceipt:DiscountTotal				:= 0
	Self:PaymentReceipt:RevenueTotal				:= 0
	Self:PaymentReceipt:ReceivableNetValue			:= 0
	
	If ExistBlock("WSGP030")
		uRetBlock := ExecBlock( "WSGP030", .F., .F.,  Self:PaymentReceipt  )
	    IF ( ValType( uRetBlock ) == "O" )
			Self:PaymentReceipt := ( uRetBlock )
		EndIF
	EndIf
	
	Self:PaymentReceipt:Itens						:= {}
	
	fBuildItens(Self:PaymentReceipt, Self:Branch, Self:Registration, Self:Month, Self:Year, Self:Week, Self:Type, Self:Archived, dDataRef, Company,cProcesso)
	
	Self:PaymentReceipt:ReceivableNetValue:= Self:PaymentReceipt:RevenueTotal - Self:PaymentReceipt:DiscountTotal
	
	OpenSx2Temp(cBkpEmp)		
	
	MyOpenFilePortal(cAlias,cAlias,1,.T.,Self:Company,@cModo)
	MyOpenFilePortal(cAliasSA6,cAliasSA6,1,.T.,Self:Company,@cModoSA6)
	MyOpenFilePortal(cAliasSR3,cAliasSR3,1,.T.,Self:Company,@cModoSR3)
	MyOpenFilePortal(cAliasSR7,cAliasSR7,1,.T.,Self:Company,@cModoSR7)
	MyOpenFilePortal(cAliasSRJ,cAliasSRJ,1,.T.,Self:Company,@cModoSRJ)
	MyOpenFilePortal(cAliasSRC,cAliasSRC,1,.T.,Self:Company,@cModoSRC)
	MyOpenFilePortal(cAliasSRD,cAliasSRD,1,.T.,Self:Company,@cModoSRD)
	MyOpenFilePortal(cAliasSRI,cAliasSRI,1,.T.,Self:Company,@cModoSRI)
	MyOpenFilePortal(cAliasSRV,cAliasSRV,1,.T.,Self:Company,@cModoSRV)
	MyOpenFilePortal(cAliasSR1,cAliasSR1,1,.T.,Self:Company,@cModoSR1)
	MyOpenFilePortal(cAliasSRQ,cAliasSRQ,1,.T.,Self:Company,@cModoSRQ)
	
	cEmpAnt := cBkpEmp
	
Else
	SetSoapFault(PorEncode(STR0006),PorEncode(STR0007))
	Return .F.
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³fBuildItens                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function fBuildItens(oPaymentReceipt, cBranch, cRegistration, nMonth, nYear, cWeek, nTipoFolha, lArchived, dDataRef, Company, cProcesso)

	Local aCodFol 		:= {}
	Local nBInssPA		:= fGetINSSCeiling(dDataRef)
	Local cIRefSem		:= GetMv("MV_IREFSEM",,"S")
	Local lGestPub		:= GetMv("MV_SIGAGFP",,"1") >= "2" //Gestao Publica 1=Nao; 2=Sim
	Local nHoras      	:= 0
	Local cAlias		:= "SRC"
	Local cAliasSRD		:= "SRD"
	Local cAliasSRV		:= "SRV"
	Local cAliasSRQ		:= "SRQ"
    Local cAliasSRY     := "SRY"
	Local cModoSRC		:= FWModeAccess(cAlias)
	Local cModoSRD		:= FWModeAccess(cAliasSRD)
	Local cModoSRV		:= FWModeAccess(cAliasSRV)
	Local cModoSRQ		:= FWModeAccess(cAliasSRQ)
    Local cModoSRY      := FWModeAccess(cAliasSRY)
	Local cTblPrefix  	:= ''
	Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER030","SRA","2") + "}")
	Local cAcessaSRC  	:= &("{ || " + ChkRH("GPER030","SRC","2") + "}")
	Local cAcessaSRD  	:= &("{ || " + ChkRH("GPER030","SRD","2") + "}")
	Local cMesArqRef  	:= ""
	Local cNroHoras   	:= ''
	Local aCodBenef   	:= {}
	Local oItem		  	:= Nil
	Local nx		  	:= 0
	Local cMod		    := IIF(SRA->RA_REGIME=='2', 'GFP','GPE')
	Local cRotFolAdi	:= ""
	Local cRot131		:= ""
	Local cRot132		:= ""
	Local cChave		:= ''
	Local cIndKey		:= '' 
	Local cArqIND		:= ''
	Local nIndexAux		:= 0	
	
	DEFAULT cProcesso 	:= SRA->RA_PROCES
	Private aProve 		:= {}
	Private aDesco 		:= {}
	Private aBases 		:= {}
	Private aLanca 		:= {}
	Private aLancR 		:= {}
	Private dDataAte	:= CtoD('//')
	
	Default Company 	:= cEmpAnt

    MyOpenFilePortal(cAlias,cAlias,1,.T.,Company,@cModoSRC)
    MyOpenFilePortal(cAliasSRD,cAliasSRD,1,.T.,Company,@cModoSRD)
    MyOpenFilePortal(cAliasSRV,cAliasSRV,1,.T.,Company,@cModoSRV)
    MyOpenFilePortal(cAliasSRQ,cAliasSRQ,1,.T.,Company,@cModoSRQ)
    MyOpenFilePortal(cAliasSRY,cAliasSRY,1,.T.,Company,@cModoSRY)
		
	Do Case
		Case nTipoFolha == 1
			cRotFolAdi := fGetCalcRot('2',cMod)
		Case nTipoFolha == 2
			cRotFolAdi := fGetCalcRot('1',cMod)
		Case nTipoFolha == 6
			cRotFolAdi := fGetCalcRot('9',cMod)
		Case nTipoFolha == 7
			cRotFolAdi := fGetCalcRot('K',cMod)
		OtherWise
			cRotFolAdi := fGetCalcRot('F',cMod)
	EndCase
	
	cAlias := IIF(lArchived, "SRD", "SRC")
	
	cTblPrefix:= cAlias + "->" + PrefixoCpo(cAlias) + "_"
	cNroHoras   := &("{ || If(" + cTblPrefix + "QTDSEM > 0 .And. cIRefSem == 'S', " + cTblPrefix + "QTDSEM, " + cTblPrefix + "HORAS) }")

    //em alguns casos pode falhar a avaliação da CodFol pela filial do usuario logado
    //pq no caso de transferencia de empresasa a SRV pode possuir compartilhamento diferente
    //assim uma nova chamada a realizada para buscar as verbas
	If !Fp_CodFol(@aCodFol, xFilial('SRV', cBranch))
       If !Fp_CodFol(@aCodFol, xFilial('SRV'))
           Return()
      EndIf 
	EndIf
	
	If lArchived
		cIndKey		:= "RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA+RD_PD" 
		cArqIND		:= CriaTrab( Nil, .F. )
		IndRegua( "SRD", cArqIND, cIndKey, , ,'', .T. )
		nIndexAux	:= SRD->( RetIndex( ) ) + 1
		SRD->( DbSetOrder ( nIndexAux ) )	
	Else
		cIndKey		:= "RC_FILIAL+RC_MAT+RC_PROCES+RC_ROTEIR+RC_PERIODO+RC_SEMANA+RC_PD" 
		cArqIND		:= CriaTrab( Nil, .F. )
		IndRegua( "SRC", cArqIND, cIndKey, , ,'', .T. )
		nIndexAux	:= SRC->( RetIndex( ) ) + 1
		SRC->( DbSetOrder ( nIndexAux ) )
	EndIf

	
	If nTipoFolha == 1 .Or. nTipoFolha == 2 .Or. nTipoFolha == 5 .Or. nTipoFolha == 6 .Or. nTipoFolha == 7
		fBusCadBenef(@aCodBenef, "FOL")
		
		dbSelectArea(cAlias)
		cChave	:= SRA->(RA_FILIAL+RA_MAT) + cProcesso + cRotFolAdi + StrZero(nYear, 4) + StrZero(nMonth, 2) + cWeek

		//VarInfo("nTipoFolha: ", nTipoFolha)
		//VarInfo("CHAVE DE BUSCA: ", cChave)
		//VarInfo("SRA POSICIONADA: ", SRA->RA_FILIAL + SRA->RA_MAT)

		If (cAlias)->(dbSeek(cChave)) 

			While   !Eof() ;
					.And. (cAlias)->&(cTblPrefix + "FILIAL") 	== SRA->RA_FILIAL ;
					.And. (cAlias)->&(cTblPrefix + "MAT") 		== SRA->RA_MAT ;
					.And. (cAlias)->&(cTblPrefix + "PERIODO") 	== StrZero(nYear, 4) + StrZero(nMonth, 2) ;
					.And. (cAlias)->&(cTblPrefix + "ROTEIR")    $ cRotFolAdi ;
					.And. (cAlias)->&(cTblPrefix + "SEMANA") 	== cWeek
				
				If !Eval(IIF(lArchived, cAcessaSRD, cAcessaSRC))
					dbSkip()
					Loop
				EndIf
				
				If PosSrv( (cAlias)->&(cTblPrefix + "PD"), xFilial('SRV', SRA->RA_FILIAL), "RV_TIPOCOD" ) == "1"
					If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
						LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
					Else
						nHoras := Eval(cNroHoras)
					EndIf
					
					AddRevenue(oPaymentReceipt, (cAlias)->&(cTblPrefix + "PD"), nHoras, (cAlias)->&(cTblPrefix + "VALOR"))
				ElseIf SRV->RV_TIPOCOD == "2"
					If Ascan(aCodBenef, { |x| (cAlias)->&(cTblPrefix + "PD") $ x[1] + "/" + x[14] }) > 0
						AddDiscount(oPaymentReceipt, (cAlias)->&(cTblPrefix + "PD"), Eval(cNroHoras), (cAlias)->&(cTblPrefix + "VALOR"), .T.)						
					Else
						AddDiscount(oPaymentReceipt, (cAlias)->&(cTblPrefix + "PD"), Eval(cNroHoras), (cAlias)->&(cTblPrefix + "VALOR"))
					EndIf
				EndIf
				
				If nTipoFolha = 1
					If (cAlias)->&(cTblPrefix + "PD") == aCodFol[10,1]
						oPaymentReceipt:IRRFCalculationBasis := (cAlias)->&(cTblPrefix + "VALOR")
					EndIf
				ElseIf (cAlias)->&(cTblPrefix + "PD") == aCodFol[13,1]
					oPaymentReceipt:INSSSalaryContribution += (cAlias)->&(cTblPrefix + "VALOR")
				ElseIf (cAlias)->&(cTblPrefix + "PD") == aCodFol[221,1]
					oPaymentReceipt:INSSSalaryContribution += (cAlias)->&(cTblPrefix + "VALOR")
					oPaymentReceipt:INSSSalaryContribution := Min(oPaymentReceipt:INSSSalaryContribution, nBInssPA )
				Elseif (cAlias)->&(cTblPrefix + "PD") $ aCodFol[108,1]+'*'+aCodFol[17,1]+'*'+ aCodFol[337,1]+'*'+aCodFol[398,1]				// BASE FGTS SAL, 13.SAL E DIF DISSIDIO E DIF DISSIDIO 13
					oPaymentReceipt:FGTSBase 			 += (cAlias)->&(cTblPrefix + "VALOR")
				Elseif (cAlias)->&(cTblPrefix + "PD") $ aCodFol[109,1]+'*'+aCodFol[18,1]+'*'+aCodFol[339,1]+'*'+aCodFol[400,1]				// VALOR FGTS SAL, 13.SAL E DIF DISSIDIO E DIF.DISSIDIO 13
					oPaymentReceipt:MontlyFGTS 			 += (cAlias)->&(cTblPrefix + "VALOR")
				Elseif (cAlias)->&(cTblPrefix + "PD") == aCodFol[15,1]
					oPaymentReceipt:IRRFCalculationBasis += (cAlias)->&(cTblPrefix + "VALOR")
				Endif
				
				dbSelectArea(cAlias)
				dbSkip()
			EndDo
		Endif
	Elseif nTipoFolha == 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca os codigos de pensao definidos no cadastro beneficiario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})

	    cRot131	:= fGetCalcRot('5')
		
		dbSelectArea(cAlias)
		cChave	:= SRA->(RA_FILIAL+RA_MAT)+cProcesso + cRot131 + StrZero(nYear, 4) + StrZero(nMonth, 2) + cWeek 

		If (cAlias)->(dbSeek(cChave))
			While   !Eof() ;
					.And. (cAlias)->&(cTblPrefix + "FILIAL") 	== SRA->RA_FILIAL ;
					.And. (cAlias)->&(cTblPrefix + "MAT") 		== SRA->RA_MAT ;
					.And. (cAlias)->&(cTblPrefix + "PERIODO") 	== StrZero(nYear, 4) + StrZero(nMonth, 2) ;
					.And. (cAlias)->&(cTblPrefix + "ROTEIR")    == cRot131 ;
					.And. (cAlias)->&(cTblPrefix + "SEMANA") 	== cWeek

				If !Eval(IIF(lArchived, cAcessaSRD, cAcessaSRC))
					dbSkip()
					Loop
				EndIf
				
				If PosSrv( (cAlias)->&(cTblPrefix + "PD"), xFilial('SRV', SRA->RA_FILIAL), "RV_TIPOCOD" ) == "1"
					AddRevenue(oPaymentReceipt, (cAlias)->&(cTblPrefix + "PD"), Eval(cNroHoras), (cAlias)->&(cTblPrefix + "VALOR"))
				ElseIf Ascan(aCodBenef, { |x| x[1] == (cAlias)->&(cTblPrefix + "PD") }) > 0 .or. SRV->RV_TIPOCOD == "2"
					AddDiscount(oPaymentReceipt, (cAlias)->&(cTblPrefix + "PD"), Eval(cNroHoras), (cAlias)->&(cTblPrefix + "VALOR"), .T.)
				EndIf
				
				If (cAlias)->&(cTblPrefix + "PD") == aCodFol[108,1] .Or. (cAlias)->&(cTblPrefix + "PD") == aCodFol[398,1] // base fgts 13.sal e base fgts dif.dissidio 13.sal.
					oPaymentReceipt:FGTSBase := (cAlias)->&(cTblPrefix + "VALOR")
				ElseIf (cAlias)->&(cTblPrefix + "PD") == aCodFol[109,1] .Or. (cAlias)->&(cTblPrefix + "PD") == aCodFol[400,1] // vlr fgts 13.sal e vlr fgts dif. dissidio 13.sal.
					oPaymentReceipt:MontlyFGTS := (cAlias)->&(cTblPrefix + "VALOR")
				EndIf
				
				dbSelectArea(cAlias)
				(cAlias)->(dbSkip())
			Enddo
		EndIf
	ElseIf nTipoFolha == 4
		fBusCadBenef(@aCodBenef, "132")
		
        cRot132	:= fGetCalcRot('6')
		
		dbSelectArea(cAlias)
		cChave	:= SRA->(RA_FILIAL+RA_MAT)+cProcesso + cRot132 + StrZero(nYear, 4) + StrZero(nMonth, 2) + cWeek

		If (cAlias)->(dbSeek(cChave))
			While   !Eof() ;
					.And. (cAlias)->&(cTblPrefix + "FILIAL") 	== SRA->RA_FILIAL ;
					.And. (cAlias)->&(cTblPrefix + "MAT") 		== SRA->RA_MAT ;
					.And. (cAlias)->&(cTblPrefix + "PERIODO") 	== StrZero(nYear, 4) + StrZero(nMonth, 2) ;
					.And. (cAlias)->&(cTblPrefix + "ROTEIR")    == cRot132 ;
					.And. (cAlias)->&(cTblPrefix + "SEMANA") 	== cWeek
				
				If !Eval(IIF(lArchived, cAcessaSRD, cAcessaSRC))
					dbSkip()
					Loop
				EndIf
				
				If PosSrv( (cAlias)->&(cTblPrefix + "PD") , xFilial('SRV', SRA->RA_FILIAL) , "RV_TIPOCOD" ) == "1"
					AddRevenue(oPaymentReceipt, (cAlias)->(&(cTblPrefix + "PD")), (cAlias)->(&(cTblPrefix + "HORAS")), (cAlias)->(&(cTblPrefix + "VALOR")))
				ElseIf Ascan(aCodBenef, { |x| x[1] == SRI->RI_PD }) > 0
					AddDiscount(oPaymentReceipt, (cAlias)->(&(cTblPrefix + "PD")), (cAlias)->(&(cTblPrefix + "HORAS")), (cAlias)->(&(cTblPrefix + "VALOR")), .T.)				
				ElseIf SRV->RV_TIPOCOD == "2"
					AddDiscount(oPaymentReceipt, (cAlias)->(&(cTblPrefix + "PD")), (cAlias)->(&(cTblPrefix + "HORAS")), (cAlias)->(&(cTblPrefix + "VALOR")))
				EndIf
				
				If (cAlias)->(&(cTblPrefix + "PD")) == aCodFol[19,1]
					oPaymentReceipt:INSSSalaryContribution += (cAlias)->(&(cTblPrefix + "VALOR"))
				ElseIf (cAlias)->(&(cTblPrefix + "PD")) $ aCodFol[108,1] .Or. (cAlias)->(&(cTblPrefix + "PD")) $ aCodFol[398,1] // acrescido base fgts dif.dissidio 13.sal.
					oPaymentReceipt:FGTSBase += (cAlias)->(&(cTblPrefix + "VALOR"))
				ElseIf (cAlias)->(&(cTblPrefix + "PD")) $ aCodFol[109,1] .Or.  (cAlias)->(&(cTblPrefix + "PD")) $ aCodFol[400,1] // acrescido vlr fgts dif.dissidio 13.sal.
					oPaymentReceipt:MontlyFGTS += (cAlias)->(&(cTblPrefix + "VALOR"))
				ElseIf (cAlias)->(&(cTblPrefix + "PD")) == aCodFol[27,1]
					oPaymentReceipt:IRRFCalculationBasis += (cAlias)->(&(cTblPrefix + "VALOR"))
				EndIf
				
				dbSkip()
			Enddo
		EndIf
	EndIf

	For nX:=1 to Len(aLancR)
		oItem:= WSClassNew("TPaymentReceiptsItem")
		oItem:Code			:= aLancR[nx][1]
		oItem:Description	:= aLancR[nx][2]
		oItem:Reference		:= aLancR[nx][3]
		oItem:Revenue		:= aLancR[nx][4]
		oItem:Discount		:= aLancR[nx][5]
		AAdd(oPaymentReceipt:Itens, oItem)
	Next
	
	fErase(cArqIND + OrdBagExt())
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³fGetSalary                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGetSalary(dDataRef,dDataPagto,nType)
	Local nSalario := 0
	Local lPortal := .T.
	
	If nType == 1 .And. !Empty(dDataPagto)
		nSalario := fBuscaSal1(dDataPagto,,,,,.T. )		            
	Else
		nSalario := fBuscaSal(dDataRef, NIL, NIL, .F., lPortal)
	EndIf
	
	IF (nSalario == 0)
		nSalario := SRA->RA_SALARIO
	EndIf
Return nSalario

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³fGetPayDate                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGetPayDate(cBranch, cRegistration, nMonth, nYear, cWeek, nType, lArchived)
	Local aRotFol		:= {}
	Local dDataPagto	:= CToD("")
	Local cAliasQry	:= "QRCH"
	Local cJoin		:= ""
	Local cWhere	:= ""
	
	If SRA->RA_REGIME	=="2"
		aRotFol:= {"ADI", "FPB", "113", "213", "PLR","AUT","VEX"}
	Else
		aRotFol:= {"ADI", "FOL", "131", "132", "PLR","AUT","VEX"}
	EndIf
	cJoin := "% "
	cJoin += FWJoinFilial( "RCH", "SRA" ) + " AND "
	cJoin += " RCH.RCH_PROCES = SRA.RA_PROCES "
	cJoin += "%"
	
	cWhere := "%"
	cWhere += " SRA.RA_FILIAL	= '" + cBranch + 			"' AND "
	cWhere += " SRA.RA_MAT		= '" + cRegistration + 		"' AND "
	cWhere += " RCH.RCH_ANO 	= '" + cValToChar(nYear) +	"' AND "
	cWhere += " RCH.RCH_MES 	= '" + StrZero(nMonth,2) +	"' AND "
	cWhere += " RCH.RCH_NUMPAG 	= '" + cWeek + 				"' AND "
	cWhere += " RCH.RCH_ROTEIR 	= '" + aRotFol[nType] + 	"'"
	cWhere += "%"
	
	BeginSql alias cAliasQry
	
	column RCH_DTPAGO as Date
	
		SELECT 		RCH_DTPAGO 
		FROM 		%table:RCH% RCH
		INNER JOIN  %table:SRA% SRA
		ON 			%exp:cJoin%
		WHERE 		%exp:cWhere% AND
					RCH.%NotDel% AND
					SRA.%NotDel%
	EndSql

	dDataPagto := (cAliasQry)->RCH_DTPAGO
		
	(cAliasQry)->(DBCloseArea())
	
Return(dDataPagto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³fGetINSSCeiling                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGetINSSCeiling(dDataRef)
	Local aTInss:= {}
	Local nRet:= 0
	
	Car_inss(@aTInss, MesAno(dDataRef))	//Carrega tabela de INSS para utilizacao nos pro-labores/autonomos
	
	If aTinss != NIL .AND. Len(aTinss) > 0
		nRet := aTinss[Len(aTinss),1]
	EndIf
Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³AddRevenue                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AddRevenue(oPaymentReceipt, cAllowance, nReference, nValue)
	Local nPos	:= 0
	
	If (nPos:=aScan(aLancR,{|x| x[1] == cAllowance })) > 0
		aLancR[nPos][3]+= nReference
		aLancR[nPos][4]+= nValue
	Else
		AAdd(aLancR,{cAllowance,FSubst(PosSrv(cAllowance, oPaymentReceipt:Branch, "RV_DESC", 1)),nReference,nValue,0})
	Endif
	
	oPaymentReceipt:RevenueTotal += nValue
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³          ³             ³Autor  ³Equipe RH           ³Data  ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³AddDiscount                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AddDiscount(oPaymentReceipt, cAllowance, nReference, nValue, lAlimony)
	Local nPos	:= 0
	
	Default lAlimony := .F.
	
	If (nPos:=aScan(aLancR,{|x| x[1] == cAllowance })) > 0
		aLancR[nPos][3]+= nReference
		aLancR[nPos][5]+= nValue
	Else
		AAdd(aLancR,{cAllowance,FSubst(PosSrv(cAllowance, oPaymentReceipt:Branch, "RV_DESC", 1)),nReference,0,nValue})
	Endif
	
	oPaymentReceipt:DiscountTotal += nValue

	If lAlimony
		oPaymentReceipt:Alimony += nValue
	EndIf 
	
Return()

/*/{Protheus.doc} FSubst(cTexto)
- Função Migrada para o Portal, para remover não apenas acentos mais também caracteres especiais.
@author: Microsiga RH.
@param: cTexto - Conteúdo para verificação.
/*/
Function FSubst(cTexto)

Local aAcentos:={}
Local aAcSubst:={}
Local cImpCar := Space(01)
Local cImpLin :=""
Local cAux 	  :=""
Local cAux1	  :=""   
Local nTamTxt := Len(cTexto)	
Local j
Local nPos
  
// Para alteracao/inclusao de caracteres, utilizar a fonte TERMINAL no IDE com o tamanho
// maximo possivel para visualizacao dos mesmos.
// Utilizar como referencia a tabela ASCII anexa a evidencia de teste (FNC 807/2009).

aAcentos :=	{;
			Chr(199),Chr(231),Chr(196),Chr(197),Chr(224),Chr(229),Chr(225),Chr(228),Chr(170),;
			Chr(201),Chr(234),Chr(233),Chr(237),Chr(244),Chr(246),Chr(242),Chr(243),Chr(186),;
			Chr(250),Chr(097),Chr(098),Chr(099),Chr(100),Chr(101),Chr(102),Chr(103),Chr(104),;
			Chr(105),Chr(106),Chr(107),Chr(108),Chr(109),Chr(110),Chr(111),Chr(112),Chr(113),;
			Chr(114),Chr(115),Chr(116),Chr(117),Chr(118),Chr(120),Chr(122),Chr(119),Chr(121),;
			Chr(065),Chr(066),Chr(067),Chr(068),Chr(069),Chr(070),Chr(071),Chr(072),Chr(073),;
			Chr(074),Chr(075),Chr(076),Chr(077),Chr(078),Chr(079),Chr(080),Chr(081),Chr(082),;
			Chr(083),Chr(084),Chr(085),Chr(086),Chr(088),Chr(090),Chr(087),Chr(089),Chr(048),;
			Chr(049),Chr(050),Chr(051),Chr(052),Chr(053),Chr(054),Chr(055),Chr(056),Chr(057),;
			Chr(038),Chr(195),Chr(212),Chr(211),Chr(205),Chr(193),Chr(192),Chr(218),Chr(220),;
			Chr(213),Chr(245),Chr(227),Chr(252);
			}
			
aAcSubst :=	{;
			"C","c","A","A","a","a","a","a","a",;
			"E","e","e","i","o","o","o","o","o",;
			"u","a","b","c","d","e","f","g","h",;
			"i","j","k","l","m","n","o","p","q",;
			"r","s","t","u","v","x","z","w","y",;
			"A","B","C","D","E","F","G","H","I",;
			"J","K","L","M","N","O","P","Q","R",;
			"S","T","U","V","X","Z","W","Y","0",;
			"1","2","3","4","5","6","7","8","9",;
			"E","A","O","O","I","A","A","U","U",;
			"O","o","a","u";
			}

For j := 1 TO Len(AllTrim(cTexto))
	cImpCar	:= SubStr(cTexto, j, 1)
	//-- Nao pode sair com 2 espacos em branco.
	cAux := Space(01)  
  
	If( nPos := Ascan(aAcentos, cImpCar)) > 0 
		cAux := aAcSubst[nPos]
	Else
		cAux := cImpCar
		if (cAux1 == Space(1) .And. cAux == space(1)) .Or. Len(cAux1) == 0 
			cAux :=	""
		EndIf	
	EndIf
	
	cAux1 := cAux
	cImpCar	:= cAux
	cImpLin	:= cImpLin + cImpCar

Next j

//--Volta o texto no tamanho original
cImpLin := Left(cImpLin + Space(nTamTxt), nTamTxt)

Return cImpLin

/*/{Protheus.doc} fImpTransfEmp()
- Faz a impressão dos registros quando houver transferências de empresas com troca de matrículas.
@author: Matheus Bizutti
@since:  13/06/2016
/*/
Static Function fImpTransfEmp(PaymentReceiptsBrowse,Branch,Registration,FilterField,FilterValue,aTransf,aTransAux,lTransfEmp,lMostraRec,aLibDemo,aVerbas)

Local cQuery:= GetNextAlias()
Local cSRCBranch := xFilial("SRC", Branch)
Local cSRDBranch := xFilial("SRD", Branch)
Local cRegistration:= Registration
Local aCodFol 	:= {}
Local cSRCEmp 	:= ""
Local cSRDEmp 	:= ""
Local cSRVEmp	:= ""
Local cWhrSRD 	:= ""
Local cWhrSRC 	:= ""
Local dDataLib	:=	CtoD('')
Local dDataPag	:=	CtoD('')
Local nDifData	:= 0
Local nI		:= 0
Local nCount	:= 0
Local lFiltro	:= !Empty(FilterValue)
Local dPagto	:= CtoD('//')
Local cOpReg 	:= SuperGetMv('MV_TCF013A',,'01.02.03.04.05')
Local cMat 		:= RHMat
Local cMatOrig  := ""
Local cMatQry   := ""
Local cFilQry	:= ""
Local nTamFil   := FWGETTAMFILIAL
Local cPer		:= ""
Local cRot		:= ""
Local lCPer		:= .F.
Local nTotHol     	:= SuperGetMv( "MV_TCFQHOL", NIL, 0)

Default lTransfEmp 	:= .T.
Default lMostraRec := .T.
Default aLibDemo := {	Val(getmv("MV_TCFDADT", NIL, "0")),;
						Val(getmv("MV_TCFDFOL", NIL, "0")),;
						Val(getmv("MV_TCFD131", NIL, "0")),;
						Val(getmv("MV_TCFD132", NIL, "0")),;
						Val(getmv("MV_TCFDEXT", NIL, "0")),;
						Val(getmv("MV_TCFDFOL", NIL, "0"))	}

// - Percorre todas as empresas do funcionário 
// - Exibe os registros e pula para a próxima empresa
// - Corrigindo o bug de que ao haver transferências entre empresas e troca de matrícula
// - Não sejam exibidos os dados na nova empresa, de funcionários com a matrícula igual a matrícula origem.

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
	cSRCEmp := "%"+ RetFullName("SRC",aTransAux[nCount][1]) +"%"
	cSRDEmp := "%"+ RetFullName("SRD",aTransAux[nCount][1]) +"%"
	cSRVEmp := "%"+ RetFullName("SRV",aTransAux[nCount][1]) +"%"
	
	TransferDetails(@aTransAux,nCount,cSRCEmp,cSRDEmp,cSRVEmp,@cQuery)
	
	aAdd(aVerbas, fGetCalcRot('2')) // ADI
	aAdd(aVerbas, fGetCalcRot('1')) // FOL
	aAdd(aVerbas, fGetCalcRot('5')) // 131
	aAdd(aVerbas, fGetCalcRot('6')) // 132
	aAdd(aVerbas, fGetCalcRot('F')) // PLR
	aAdd(aVerbas, fGetCalcRot('9')) // AUT
	lCper := .F.
	While (cQuery)->(!Eof()) 
		// Tratamento para o período.
		If lCper .and. (cQuery)->RC_PERIODO == cPer .And. (cQuery)->RC_ROTEIR == cRot
			(cQuery)->(DBSkip())
			loop
		EndIf 
		oItem:= WSClassNew("TPaymentReceiptsList")
		oItem:Year			:= Val(SubStr((cQuery)->RC_PERIODO,1,4))
		oItem:Month			:= Val(SubStr((cQuery)->RC_PERIODO,5,2))
		oItem:Week			:= (cQuery)->RC_SEMANA
		oItem:Type			:= aScan(aVerbas, {|aItemVerba| aItemVerba == (cQuery)->RC_ROTEIR } )
		oItem:Archived		:= ((cQuery)->ARCHIVED == 1)
		oItem:Branch		:= (cQuery)->FILIAL
		oItem:Registration	:= (cQuery)->MATRICULA
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pega data de pagamento dentro do cadastro de periodo          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RCH->(dbSetOrder(1))
		If RCH->(dbSeek(xFilial('RCH', SRA->RA_FILIAL)+SRA->RA_PROCES+(cQuery)->(RC_PERIODO+RC_SEMANA+RC_ROTEIR))) //RCH_FILIAL, RCH_PER, RCH_NUMPAG, RCH_PROCES, RCH_ROTEIR, RCH_DTINI, RCH_DTFIM, RCH_MODULO, R_E_C_D_E_L
			If !Empty(RCH->RCH_DTPAGO)
				dPagto := RCH->RCH_DTPAGO
			Else
				dPagto := StoD((cQuery)->RC_PERIODO+'01')
			EndIf
		Else
			dPagto := StoD((cQuery)->RC_PERIODO+'01')
		EndIf
		oItem:DataPagamento := dPagto
		
		// - Empresa utilizada para processamento.
	    oItem:Emp := aTransAux[nCount][1]
		
		lMostraRec	:=	.F.
		If ( oItem:Type == 2 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Trata o parametro "MV_TCFDFOL" como excecao, pois este parametro indica a quantidade de dias para liberacao ³
			//³do demonstrativo. Os demais parametros, indicam a data inicial de liberacao.                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( aLibDemo[oItem:Type] < 0 )
				lMostraRec	:=	dDataBase - dPagto >= aLibDemo[oItem:Type]
			Else
				lMostraRec	:=	dDataBase >= dPagto + aLibDemo[oItem:Type]
			EndIf
		Else
			If oItem:Type > 0
				dDataLib	:=	STOD( MesAno(dPagto ) + STRZERO(aLibDemo[oItem:Type] , 2) )
				lMostraRec	:= ( dDataBase  >= dDataLib )
			EndIf
		EndIf
		
		If ( lMostraRec )
			If !lFiltro .Or.;
					( lFiltro .And. FilterField == "FILIAL" .AND. FilterValue == (cQuery)->FILIAL ) .Or.;
					( lFiltro .And. FilterField == "MATRIC" .AND. FilterValue == (cQuery)->MATRICULA )
				If ( cValToChar(oItem:Type) $ cOpReg )
					  AAdd(PaymentReceiptsBrowse:Itens, oItem)
					ElseIF (oItem:Type == 6) 
					  AAdd(PaymentReceiptsBrowse:Itens, oItem)
					ElseIF (oItem:Type == 7)
					  AAdd(PaymentReceiptsBrowse:Itens, oItem)
					ElseIF Empty(cOpReg)
					  AAdd(PaymentReceiptsBrowse:Itens, oItem)
				 EndIF
			EndIf
		EndIf
		cPer := (cQuery)->RC_ROTEIR
		cPer := (cQuery)->RC_PERIODO
		lCper := .T.
		(cQuery)->(DBSkip())
	EndDo
	(cQuery)->(DBCloseArea())	
Next nCount

// - Ordena o PaymentReceiptsBrowse:Itens por Ano e Mês
   aSort(PaymentReceiptsBrowse:Itens,,,{|x,y| strzero(x:Year,4)+strzero(x:Month,2)+dtos(x:datapagamento) > strzero(y:Year,4)+strzero(y:Month,2)+dtos(y:datapagamento)})

	If nTotHol > 0//Controla quantidade de holerites a serem devolvidos como resposta do serviço
		If Len(PaymentReceiptsBrowse:Itens) > nTotHol
			aSize(PaymentReceiptsBrowse:Itens, nTotHol)
		EndIf
	EndIf

Return( Nil )

/*/{Protheus.doc} MyOpenFilePortal()
- Abertura de arquivo para a empresa especificada.
@param: x1 - Alias - Tabela utilizada
@param: x2 - Alias - Tabela utilizada
@param: x3 - Padrão - .T.
@param: x4 - Company - Código da empresa utilizada.
@param: x5 - Modo de compartilhamento da tabela.
/*/
Static Function MyOpenFilePortal(x1,x2,x3,x4,x5,x6)
Local cSavE := cEmpAnt, cSavF := cFilAnt, xRet

xRet	:= EmpOpenFile(@x1,@x2,@x3,@x4,@x5,@x6)

cEmpAnt := x5

Return( xRet )

Static Function OpenSx2Temp(cEmp)

	SX2->(dbclosearea())
	OpenSxs(,,,,cEmp,"SX2","SX2",,.F.)
	
Return

/*/{Protheus.doc}DetailReceipts()

- Efetua a query para ser usada no WebService SOAP e no novo padrão RESTFUL, encapsulando a regra de negócio existente.
@author:	Matheus Bizutti
@since:		26/05/2017	
/*/
Function DetailReceipts(cQuery,nTamArray,aTransf,cSRCBranch,cRegistration,cSRDBranch,Branch,lRest,initView,endView,lDetail,bRhnp03)

Local nI        	:= 0
Local cPeriodo  	:= ""
Local cSemana   	:= ""
Local cAnoMes   	:= ""
Local cWhrSRC   	:= ''
Local cWhrSRD   	:= ''
Local cDateLast 	:= ""
Local cMod		:= IIF(SRA->RA_REGIME=='2', 'GFP','GPE') 
Default cTabSRC		:= "RC_DATA" 
Default cTabSRD 	:= "RD_DATPGT"
Default lRest       := .F.
Default lDetail     := .F.
Default nTamArray   := 0
Default aTransf     := {}
Default cSRCBranch  := ""
Default cSRDBranch  := ""
Default Branch      := ""
Default cQuery      := GetNextAlias()

	If bRhnp03 == .T.
		cTabSRC := "RC_PERIODO"
		cTabSRD := "RD_PERIODO"
		If !Empty(endView)
			endView := DtoS(DaySub(StoD(substr(endView,1,4)+substr(endView,6,2)+substr(endView,9,2)), 1) ) 
		Endif
	Endif

	cWhrSRC := "%"
	cWhrSRD := "%"
	
	If nTamArray > 0
		cWhrSRC += "("
		cWhrSRD += "("
		
			cWhrSRC += "("
			cWhrSRD += "("
		For nI := 1 To nTamArray
			If nI > 1
				cWhrSRC += " OR "
				cWhrSRD += " OR "
			EndIf
			
			cWhrSRC += " (SRC.RC_FILIAL = '" +aTransf[nI,8]+ "'"
			cWhrSRC += " AND SRC.RC_MAT = '" +aTransf[nI,9]+ "') "

			cWhrSRD += " (SRD.RD_FILIAL = '"+aTransf[nI,8]+"'"
			cWhrSRD += " AND SRD.RD_MAT = '"+aTransf[nI,9]+"') "	
		Next nI
		
			cWhrSRC += " OR "
			cWhrSRC += " (SRC.RC_FILIAL = '"+cSRCBranch+"'"
			cWhrSRC += " AND SRC.RC_MAT = '"+cRegistration+"') "
			
			cWhrSRD += " OR "
			cWhrSRD += " (SRD.RD_FILIAL = '"+cSRDBranch+"'"
			cWhrSRD += " AND SRD.RD_MAT = '"+cRegistration+"') "
		
			cWhrSRC += ")"
			cWhrSRD += ")"
	EndIf
	
	// --------------------------------------------------------------------
	
	getOpenPer(cRegistration,Branch,@cPeriodo,@cSemana,@cAnoMes)

	If !(nTamArray > 0)
		cWhrSRC += " (SRC.RC_FILIAL = '"+cSRDBranch+"'"
		cWhrSRC += " AND SRC.RC_MAT = '"+cRegistration+"') "
	EndIf
	cWhrSRC += " AND SRC.RC_ROTEIR IN ("
	cWhrSRC += " '"+fGetCalcRot('1',cMod)+"', " // FOL
	cWhrSRC += " '"+fGetCalcRot('2',cMod)+"', " // ADI
	cWhrSRC += " '"+fGetCalcRot('5',cMod)+"', " // 131
	cWhrSRC += " '"+fGetCalcRot('6',cMod)+"', " // 132
	cWhrSRC += " '"+fGetCalcRot('F',cMod)+"', " // PLR
	cWhrSRC += " '"+fGetCalcRot('K',cMod)+"', " // VEX
	cWhrSRC += " '"+fGetCalcRot('9',cMod)+"'"   // AUT
	cWhrSRC += " )"
	
	If lRest
	
		If !Empty(initView) .And. !Empty(endView)

			If bRhnp03 == .F.
				cWhrSRC += " AND ("+cTabSRC+" between '"+substr(initView,1,4)+substr(initView,6,2)+substr(initView,9,2)+"' AND '"+substr(endView,1,4)+substr(endView,6,2)+substr(endView,9,2)+"')"
			Else
				cWhrSRC += " AND ("+cTabSRC+" between '"+substr(initView,1,4)+substr(initView,5,2)+"' AND '"+substr(endView,1,4)+substr(endView,5,2)+"')"
			EndIf
		ElseIf Empty(initView) .And. Empty(endView)
			If bRhnp03 == .F.
				cDateLast := Dtos(MonthSub( STOD(cPeriodo+"01") , 5 ))
			Else
				cDateLast := SubStr(Dtos(MonthSub( STOD(cPeriodo+"01") , 5 )), 1, 6)
			EndIf

			cWhrSRC   += " AND "+cTabSRC+" > '" +cDateLast +"' "
			cDateLast := ""
		ElseIf !Empty(initView) .And. Empty(endView)
		
			// Retorna os demonstrativos que compreendem o período informado no initView até a data atual*.
			If bRhnp03 == .F.
				cWhrSRC += " AND ("+cTabSRC+" between '"+substr(initView,1,4)+substr(initView,6,2)+substr(initView,9,2)+"' AND '"+cPeriodo+Substr(DTOS(LastDate(STOD(cPeriodo+"01"))),7,2)+"')"
			Else
				cWhrSRC += " AND ("+cTabSRC+" between '"+substr(initView,1,4)+substr(initView,5,2)+"' AND '"+cPeriodo+"')"
			EndIf
		ElseIf !Empty(endView) .And. Empty(initView)
		
			cAuxEndView 	:= endView
		
			If bRhnp03 == .F.
				cDateLast 		:= Substr(cAuxEndView,1,4) + Substr(cAuxEndView,6,2) + Substr(cAuxEndView,9,2) 
				cDateLast 		:= Dtos(MonthSub(Stod(cDateLast),5))
				cAuxEndView   	:= Substr(cAuxEndView,1,4) + Substr(cAuxEndView,6,2) + Substr(cAuxEndView,9,2) 
			Else
				cDateLast 		:= Substr(cAuxEndView,1,4) + Substr(cAuxEndView,5,2) + Substr(cAuxEndView,7,2)
				cDateLast 		:= SubStr( Dtos(MonthSub( Stod (cDateLast), 5)), 1, 6)
				cDateLast 		:= Substr(cAuxEndView,1,4) + Substr(cAuxEndView,5,2)
				cAuxEndView   	:= Substr(cAuxEndView,1,4) + Substr(cAuxEndView,5,2)
			EndIf

			cWhrSRC  	  += " AND ("+cTabSRC+" between '"+cDateLast+"' AND '"+cAuxEndView+"')"	
		EndIf
	EndIf
	
	If !(nTamArray > 0)
		cWhrSRD += " (SRD.RD_FILIAL = '"+cSRDBranch+"'"
		cWhrSRD += " AND SRD.RD_MAT = '"+cRegistration+"') "
	EndIf
	cWhrSRD += " AND SRD.RD_ROTEIR IN ("
	cWhrSRD += " '"+fGetCalcRot('1',cMod)+"', " // FOL
	cWhrSRD += " '"+fGetCalcRot('2',cMod)+"', " // ADI
	cWhrSRD += " '"+fGetCalcRot('5',cMod)+"', " // 131
	cWhrSRD += " '"+fGetCalcRot('6',cMod)+"', " // 132
	cWhrSRD += " '"+fGetCalcRot('F',cMod)+"', " // PLR
	cWhrSRD += " '"+fGetCalcRot('K',cMod)+"', " // VEX
	cWhrSRD += " '"+fGetCalcRot('9',cMod)+"'"   // AUT
	cWhrSRD += " )"
	
	If lRest
				
		If !Empty(initView) .And. !Empty(endView)

			If bRhnp03 == .F.
				cWhrSRD += " AND ("+cTabSRD+" between '"+substr(initView,1,4)+substr(initView,6,2)+substr(initView,9,2)+"' AND '"+substr(endView,1,4)+substr(endView,6,2)+substr(endView,9,2)+"')"
			Else
				cWhrSRD += " AND ("+cTabSRD+" between '"+substr(initView,1,4)+substr(initView,5,2)+"' AND '"+substr(endView,1,4)+substr(endView,5,2)+"')"
			EndIf
		ElseIf Empty(initView) .And. Empty(endView)
			
			If bRhnp03 == .F.
				cDateLast := Dtos(MonthSub( STOD(cPeriodo+"01") , 5 ))
				cWhrSRD   += " AND ("+cTabSRD+" between '"+cDateLast+"' AND '"+cPeriodo+Substr(DTOS(LastDate(STOD(cPeriodo+"01"))),7,2)+"')"
			Else
				cDateLast := SubStr(Dtos(MonthSub( STOD(cPeriodo+"01") , 5 )), 1, 6)
				cWhrSRD   += " AND ("+cTabSRD+" between '"+cDateLast+"' AND '"+cPeriodo+"')"
			Endif
			
			cDateLast := ""
		ElseIf !Empty(initView) .And. Empty(endView)
		
			// Retorna os demonstrativos que compreendem o período informado no initView até a data atual*.
			If bRhnp03 == .F.
				cWhrSRD += " AND ("+cTabSRD+" between '"+substr(initView,1,4)+substr(initView,6,2)+substr(initView,9,2)+"' AND '"+cPeriodo+Substr(DTOS(LastDate(STOD(cPeriodo+"01"))),7,2)+"')"
			Else
				cWhrSRD += " AND ("+cTabSRD+" between '"+substr(initView,1,4)+substr(initView,5,2)+"' AND '"+cPeriodo+"')"
			EndIf

		ElseIf !Empty(endView) .And. Empty(initView)
		
			cAuxEndView   := endView

			If bRhnp03 == .F.
				cDateLast	  := Substr(cAuxEndView,1,4) + Substr(cAuxEndView,6,2) + Substr(cAuxEndView,9,2) 
				cDateLast 	  := Dtos(MonthSub(Stod(cDateLast),5))
				cAuxEndView   := Substr(cAuxEndView,1,4) + Substr(cAuxEndView,6,2) + Substr(cAuxEndView,9,2) 
			Else
				
				cDateLast	  := Substr(cAuxEndView,1,4) + Substr(cAuxEndView,5,2) + Substr(cAuxEndView,7,2) 
				cDateLast 	  := SubStr( Dtos(MonthSub( Stod (cDateLast), 5)), 1, 6)
				cDateLast     := Substr(cAuxEndView,1,4) + Substr(cAuxEndView,5,2)
				cAuxEndView   := Substr(cAuxEndView,1,4) + Substr(cAuxEndView,5,2)
			EndIf
	
			cWhrSRD   	  += " AND ("+cTabSRD+" between '"+cDateLast+"' AND '"+cAuxEndView+"')"		
		EndIf
	EndIf
	
	If nTamArray > 0
		cWhrSRC += ")"
		cWhrSRD += ")"
	EndIf
	
	cWhrSRC += " AND SRC.D_E_L_E_T_ = ' '"
	cWhrSRC += " %"
	
	cWhrSRD += " AND SRD.D_E_L_E_T_ = ' '"
	cWhrSRD += " %"	

	// -------------------------------------------------
	
	If lRest
		BEGINSQL ALIAS cQuery
			COLUMN RC_DATA as Date
			%noparser%
		
			SELECT DISTINCT
			RC_PERIODO,
			RC_SEMANA,
			0 AS ARCHIVED,
			RC_ROTEIR,
			RC_FILIAL AS FILIAL,
			RC_MAT AS MATRICULA,
			RC_VALOR,
			RC_DATA AS DATAPAGTO,
			RC_PROCES AS PROCESSO,
			RC_PD AS VERBA
			FROM
			%Table:SRC% SRC
			WHERE
			%exp:cWhrSRC%
			UNION
			
			SELECT DISTINCT
			RD_PERIODO,
			RD_SEMANA,
			1 AS ARCHIVED,
			RD_ROTEIR,
			RD_FILIAL AS FILIAL,
			RD_MAT AS MATRICULA,
			RD_VALOR,
			RD_DATPGT AS DATAPAGTO,
			RD_PROCES AS PROCESSO,
			RD_PD AS VERBA
			FROM
			%Table:SRD% SRD
			WHERE
			%exp:cWhrSRD%
			ORDER BY 1 desc, 2 desc, 4 
		ENDSQL
	Else
		BEGINSQL ALIAS cQuery
			COLUMN RC_DATA as Date
			%noparser%
		
			SELECT DISTINCT
			RC_PERIODO,
			RC_SEMANA,
			0 AS ARCHIVED,
			RC_ROTEIR,
			RC_FILIAL AS FILIAL,
			RC_MAT AS MATRICULA
			FROM
			%Table:SRC% SRC
			WHERE
			%exp:cWhrSRC%
			UNION
			
			SELECT DISTINCT
			RD_PERIODO,
			RD_SEMANA,
			1 AS ARCHIVED,
			RD_ROTEIR,
			RD_FILIAL AS FILIAL,
			RD_MAT AS MATRICULA
			FROM
			%Table:SRD% SRD
			WHERE
			%exp:cWhrSRD%
			ORDER BY 1 desc, 2 desc, 4 
		ENDSQL
	EndIf

Return(cQuery)

/*/{Protheus.doc}TransferDetails()

- Efetua a query para transferência entre empresas de forma a ser usada no WebService SOAP e no novo padrão RESTFUL, encapsulando a regra de negócio existente.
@author:	Matheus Bizutti
@since:		26/05/2017	
/*/

Function TransferDetails(aTransAux,nCount,cSRCEmp,cSRDEmp,cSRVEmp,cQuery,lRest)

Local cFilQry		:= ""
Local cMatQry		:= ""
Local cWhrSRC		:= ""
Local cWhrSRD		:= ""
Local nI			:= 0
Local nTamEmp		:= TamSx3("RD_EMPRESA")[1]
Local cMod		:= IIF(SRA->RA_REGIME=='2', 'GFP','GPE')

DEFAULT aTransAux	:= {}
DEFAULT nCount		:= 0
DEFAULT cSRCEmp		:= ""
DEFAULT cSRDEmp		:= ""
DEFAULT cSRVEmp		:= ""
DEFAULT cQuery		:= GetNextAlias()
DEFAULT lRest		:= .F.

	cWhrSRC := "%"
	cWhrSRD := "%"
	
	cWhrSRC += "("
	cWhrSRD += "("
		
	For nI := 2 To Len(aTransAux[nCount])
	
		If nI > 2 
			cWhrSRC += " OR "
			cWhrSRD += " OR "
		EndIf
		
		If cFilQry != aTransAux[nCount][nI][1] .Or. cMatQry != aTransAux[nCount][nI][2] 		
			cWhrSRC += " (SRC.RC_FILIAL = '" +aTransAux[nCount][nI][1]+ "'"
			cWhrSRD += " (SRD.RD_FILIAL = '" +aTransAux[nCount][nI][1]+ "'"
						
			// -  Validação para exibir os recibos de cada empresa no período correto.
			// - Por exemplo:
			// - Ao possuir recibo na empresa 01 com o período 03/2016 e efetuar a transferência em 01/04/2016 p empresa 02
			// - os valores irão para a SRD ou SRC da empresa destino, e iriam ser exibidos no Portal como empresa 02
			// - porém o recibo foi da Empresa 01.
			// - Com essa validação é respeitado o período de cálculo e exibido na empresa correta.
			
			If !Empty(aTransAux[nCount][nI][4])
				cWhrSRC += " AND SRC.RC_MAT = '" +aTransAux[nCount][nI][2]+ "'"
				cWhrSRD += " AND SRD.RD_MAT = '" +aTransAux[nCount][nI][2]+ "'"
				If Empty(aTransAux[nCount][nI][5])
					cWhrSRC += " AND SRC.RC_PERIODO <= '" +aTransAux[nCount][nI][3]+ "') "
					cWhrSRD += " AND SRD.RD_PERIODO <= '" +aTransAux[nCount][nI][3]+ "'"
				ElseIf Empty(aTransAux[nCount][nI][3])
					cWhrSRC += " AND SRC.RC_PERIODO >= '" +aTransAux[nCount][nI][5]+ "') "
					cWhrSRD += " AND SRD.RD_PERIODO >= '" +aTransAux[nCount][nI][5]+ "'"
				Else
					cWhrSRC += " AND SRC.RC_PERIODO BETWEEN '" +aTransAux[nCount][nI][5]+ "' AND '" +aTransAux[nCount][nI][3]+ "') "
					cWhrSRD += " AND SRD.RD_PERIODO BETWEEN '" +aTransAux[nCount][nI][5]+ "' AND '" +aTransAux[nCount][nI][3]+ "' "
				EndIf
				
				If aTransAux[nCount][1] != aTransAux[nCount][nI][4]
					cWhrSRD += " AND SRD.RD_EMPRESA = '"+space(nTamEmp)+"') "
				Else
					cWhrSRD += ")"
				EndIf
			Else
				cWhrSRC += " AND SRC.RC_MAT = '" +aTransAux[nCount][nI][2]+ "') "
				cWhrSRD += " AND SRD.RD_MAT = '" +aTransAux[nCount][nI][2]+ "') "
			EndIf
		Else
			cWhrSRC += " (SRC.RC_FILIAL = '" +aTransAux[nCount][nI][1]+ "'"
			cWhrSRC += " AND SRC.RC_MAT = '" +aTransAux[nCount][nI][2]+ "'"
			cWhrSRC += " AND SRC.RC_PERIODO >= '" +aTransAux[nCount][nI][5]+ "') "
			
			cWhrSRD += " (SRD.RD_FILIAL = '" +aTransAux[nCount][nI][1]+ "'"
			cWhrSRD += " AND SRD.RD_MAT = '" +aTransAux[nCount][nI][2]+ "'"
			cWhrSRD += " AND SRD.RD_PERIODO >= '" +aTransAux[nCount][nI][5]+ "') "
		EndIf
		
		cFilQry := aTransAux[nCount][nI][1]	
		cMatQry := aTransAux[nCount][nI][2]
		
	Next nI

	cWhrSRC += " AND SRC.RC_ROTEIR IN ("
	cWhrSRC += " '"+fGetCalcRot('1',cMod)+"', " // FOL
	cWhrSRC += " '"+fGetCalcRot('2',cMod)+"', " // ADI
	cWhrSRC += " '"+fGetCalcRot('5',cMod)+"', " // 131
	cWhrSRC += " '"+fGetCalcRot('6',cMod)+"', " // 132
	cWhrSRC += " '"+fGetCalcRot('F',cMod)+"', " // PLR
	cWhrSRC += " '"+fGetCalcRot('9',cMod)+"'"   // AUT
	cWhrSRC += " )"
	
	cWhrSRD += " AND SRD.RD_ROTEIR IN ("
	cWhrSRD += " '"+fGetCalcRot('1',cMod)+"', " // FOL
	cWhrSRD += " '"+fGetCalcRot('2',cMod)+"', " // ADI
	cWhrSRD += " '"+fGetCalcRot('5',cMod)+"', " // 131
	cWhrSRD += " '"+fGetCalcRot('6',cMod)+"', " // 132
	cWhrSRD += " '"+fGetCalcRot('F',cMod)+"', " // PLR
	cWhrSRD += " '"+fGetCalcRot('9',cMod)+"'"   // AUT
	cWhrSRD += " )"
		
	cWhrSRC += ")"
	cWhrSRD += ")"
	
	cWhrSRC += " AND SRC.D_E_L_E_T_ = ' '"
	cWhrSRC += " %"
	
	cWhrSRD += " AND SRD.D_E_L_E_T_ = ' '"
	cWhrSRD += " %"

	If lRest
		BEGINSQL ALIAS cQuery
			COLUMN RC_DATA as Date
			%noparser%
		
			SELECT DISTINCT
			RC_PERIODO,
			RC_SEMANA,
			0 AS ARCHIVED,
			RC_ROTEIR,
			RC_FILIAL AS FILIAL,
			RC_MAT AS MATRICULA,
			RC_VALOR,
			RC_DATA AS DATAPAGTO,
			RC_PROCES AS PROCESSO,
			RC_PD AS VERBA
			FROM
			%exp:cSRCEmp% SRC
			WHERE
			%exp:cWhrSRC%
			UNION
			
			SELECT DISTINCT
			RD_PERIODO,
			RD_SEMANA,
			1 AS ARCHIVED,
			RD_ROTEIR,
			RD_FILIAL AS FILIAL,
			RD_MAT AS MATRICULA,
			RD_VALOR,
			RD_DATPGT AS DATAPAGTO,
			RD_PROCES AS PROCESSO,
			RD_PD AS VERBA
			FROM
			%exp:cSRDEmp% SRD
			WHERE
			%exp:cWhrSRD%
			ORDER BY 1 desc, 2 desc, 4 
		ENDSQL
	Else
		BEGINSQL ALIAS cQuery
			COLUMN RC_DATA as Date
			%noparser%
		
			SELECT DISTINCT
			RC_PERIODO,
			RC_SEMANA,
			0 AS ARCHIVED,
			RC_ROTEIR,
			RC_FILIAL AS FILIAL,
			RC_MAT AS MATRICULA
			FROM
			%exp:cSRCEmp% SRC
			WHERE
			%exp:cWhrSRC%
			UNION
			
			SELECT DISTINCT
			RD_PERIODO,
			RD_SEMANA,
			1 AS ARCHIVED,
			RD_ROTEIR,
			RD_FILIAL AS FILIAL,
			RD_MAT AS MATRICULA
			FROM
			%exp:cSRDEmp% SRD
			WHERE
			%exp:cWhrSRD%
			ORDER BY 1 desc, 2 desc, 4 
		ENDSQL
	EndIf

Return(cQuery)

/*/{Protheus.doc}getOpnPer()

- Retorna o último período aberto. (Data Base vigente)
@author:	Matheus Bizutti
@since:		26/05/2017
/*/
Function getOpenPer(cRegistration,cFilFun,cPeriodo,cSemana,cAnoMes)

Local cProcesso := ""
Local cTpRot    := "1"
Local cRot      := "FOL"
Local getArea   := GetArea()

DEFAULT cRegistration   := ""
DEFAULT cPeriodo        := ""
DEFAULT cSemana         := ""
DEFAULT cAnoMes         := ""
DEFAULT cFilFun         := FwCodFil()

DbSelectArea("SRA")
SRA->(DbSetOrder(1))

If SRA->(DbSeek(cFilFun+cRegistration))
    cProcesso := SRA->RA_PROCES

    If SRA->RA_CATFUNC $ "A/P"
       cTpRot := "9"
    EndIf
    cRot := fGetCalcRot(cTpRot)
EndIf

fGetLastPer( @cPeriodo,@cSemana , cProcesso, cRot , .T., .F., @cAnoMes, xFilial("RCH",cFilFun) ) 

RestArea(getArea)

Return(Nil)