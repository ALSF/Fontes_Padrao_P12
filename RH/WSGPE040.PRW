#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE PAGE_LENGTH 10
//WsClient_WsRHVacationReceipts.prx
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WSGPE040 ³ Autor ³ Equipe RH                      ³ Data ³ 01/12/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelas Recibos de pagtos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador     ³ Data       ³ FNC            ³ Motivo da Alteracao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson Campos   |30/04/14    |TPKFN9          |Replica das alterações realizadas ³±±
±±³                 |            |                |pela manutenção até a dt 25/09/13 ³±±
±±³                 |            |                |chamado THQFBA, changeset 180583  ³±±
±±³                 |            |                |na P11.80                         ³±±
±±³                 |            |                |                                  ³±±
±±³Emerson Campos   |31/01/14    |TQETRU          |Remoção do IFDEF TOP              ³±±
±±³                 |            |                |                                  ³±±
±±³Cícero Alves 	|08/06/15    |TSLXIV          |Alteração para validar o parametro³±±
±±³                 |            |                |MV_DIAANFE                        ³±±
±±³Cícero Alves 	|07/08/15    |TTAIJ2          |Alteração para enviar o nome compl³±±
±±³                 |            |                |eto quando estiver preenchido     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function WSGPE040()
Return

WSSTRUCT TVacationReceipts
	WSDATA CompanyName					As String
	WSDATA CNPJ							As String
	WSDATA Branch							As String
	WSDATA EmployeeRegistration			As String
	WSDATA EmployeeName					As String
	WSDATA FunctionDescription			As String
	WSDATA AdmissionDate					As Date
	WSDATA LaborCardNumber				As String
	WSDATA LaborCardSeries				As String
	WSDATA LaborCardState				As String
	WSDATA CPF								As String
	WSDATA Identity						As String	
	WSDATA OverdueDate					As Date
	WSDATA EnjoymentStartDate			As Date
	WSDATA ReceiptDate                 AS Date
	WSDATA EnjoymentEndDate				As Date
	WSDATA AcquisitiveStartDate			As Date
	WSDATA AcquisitiveEndDate			As Date	
	WSDATA PecuniaryAllowance			as Integer	
	WSDATA IRRFDependents				As Integer
	WSDATA FixedSalary					As Float
	WSDATA BankName						As String
	WSDATA BankAgency						As String
	WSDATA BankAccount					As String	
	WSDATA RevenueTotal					As Float
	WSDATA DiscountTotal					As Float
	WSDATA ReceivableNetValue 			As Float	
	WSDATA ExtendedReceivableNetValue	As String
	WSDATA CurrencySymbol				As String	
	WSDATA Logo							As String  Optional
	WSDATA Itens							As Array Of TVacationReceiptsItem OPTIONAL
ENDWSSTRUCT

WSSTRUCT TVacationReceiptsList
	WSDATA EnjoymentStartDate			AS Date
	WSDATA EnjoymentEndDate				AS Date
	WSDATA AcquisitiveStartDate			AS Date
	WSDATA AcquisitiveEndDate			AS Date
	WSDATA ReceiptDate					AS Date
	WSDATA PecuniaryAllowance			AS Integer
ENDWSSTRUCT

WSSTRUCT TVacationReceiptsItem
	WSDATA Code							As String
	WSDATA Description					As String
	WSDATA Reference						As Float
	WSDATA Revenue						As Float
	WSDATA Discount						As Float
ENDWSSTRUCT

WSSTRUCT TVacationReceiptsBrowse
	WSDATA Itens							AS Array Of TVacationReceiptsList	OPTIONAL
	WSDATA PagesTotal						AS Integer 							OPTIONAL
ENDWSSTRUCT



WSSERVICE RHVacationReceipts DESCRIPTION "Recibos de Pagamento"
	WSDATA Branch							AS String
	WSDATA Registration					AS String
	WSDATA Messages						As String
	
	WSDATA AcquisitiveStartDate			AS Date
	WSDATA EnjoymentStartDate			AS Date
	
	WSDATA VacationReceiptsBrowse		As TVacationReceiptsBrowse
	WSDATA VacationReceipt				AS TVacationReceipts
	
	WSDATA CurrentPage					As Integer	OPTIONAL
	WSDATA FilterField  					As String	OPTIONAL
	WSDATA FilterValue					As String	OPTIONAL
	
	WSMETHOD BrowseVacationReceipts		DESCRIPTION "Método de consulta os recibos de pagamentos disponibilizados"
	WSMETHOD GetVacationReceipt			DESCRIPTION "Método para consulta dos dados do recibo de pagamento"
	WSMETHOD GetMessage					DESCRIPTION "Criação de Mensagem Padrão"
ENDWSSERVICE


WSMETHOD BrowseVacationReceipts;
	WSRECEIVE Branch, Registration, CurrentPage, FilterField, FilterValue;
	WSSEND VacationReceiptsBrowse;
	WSSERVICE RHVacationReceipts
	Local cQuery:= GetNextAlias()
	Local cBranch := xFilial("SRH", Self:Branch)
	Local cRegistration:= Self:Registration
	Local lFiltro	:= !Empty(Self:FilterValue)
	Local nDiaAntesFerias := getmv("MV_DIAANFE", NIL, 365)
	Local dDiaAviso := cTod("  /  /    ")
	Local nI := 0
Local lExistPE	:= ExistBlock("LIBRECPAG")
Local lRetBlock	
Local lMostraRec	:= .T.

BEGINSQL ALIAS cQuery
	COLUMN RH_DTRECIB AS DATE
	COLUMN RH_DATABAS AS DATE
	COLUMN RH_DBASEAT AS DATE
	COLUMN RH_DATAINI AS DATE
	COLUMN RH_DATAFIM AS DATE
	
	SELECT
	SRH.RH_DTRECIB,
	SRH.RH_DATABAS,
	SRH.RH_DBASEAT,
	SRH.RH_DATAINI,
	SRH.RH_DATAFIM,
	SRH.RH_DABONPE,
	SRH.RH_PERIODO,
	SRH.RH_NPAGTO
	FROM
	%Table:SRH% SRH
	WHERE
	SRH.RH_FILIAL = %Exp:cBranch% AND
	SRH.RH_MAT = %Exp:cRegistration% AND
	SRH.%NotDel%
	ORDER BY
	SRH.RH_DATABAS DESC
ENDSQL

Self:VacationReceiptsBrowse:= WSClassNew("TVacationReceiptsBrowse")
Self:VacationReceiptsBrowse:Itens := {}
Self:VacationReceiptsBrowse:PagesTotal := 0

While !(Eof())
	oItem:= WSClassNew("TVacationReceiptsList")
	oItem:ReceiptDate          := (cQuery)->RH_DTRECIB
	oItem:AcquisitiveStartDate := (cQuery)->RH_DATABAS
	oItem:AcquisitiveEndDate   := (cQuery)->RH_DBASEAT
	oItem:EnjoymentStartDate   := (cQuery)->RH_DATAINI
	oItem:EnjoymentEndDate     := (cQuery)->RH_DATAFIM
	oItem:PecuniaryAllowance   := (cQuery)->RH_DABONPE
	
	//AAdd(Self:VacationReceiptsBrowse:Itens, oItem)
	
	
	dDiaAviso := DataValida((cQuery)->RH_DATAINI, .F. )
	lMostraRec	:= .T.
	
	If lExistPE
		lRetBlock := ExecBlock("LIBRECPAG",.F.,.F.,{(cQuery)->RH_DTRECIB,cBranch,cRegistration,0,val(Substr((cQuery)->RH_PERIODO,1,4)),val(Substr((cQuery)->RH_PERIODO,5,2))})
		lMostraRec := If( ValType(lRetBlock) == "L" , lRetBlock , .T. )		
		If !lMostraRec
			dDiaAviso :=  dDataBase + 10
		Else
			dDiaAviso :=  dDataBase - 10
		EndIf	
	Else
		for nI := 1 to nDiaAntesFerias
			dDiaAviso := DataValida(dDiaAviso -1, .F. )
		next
	EndIf
	if dTos(dDataBase) >=  dTOs(dDiaAviso)
			
		If !lFiltro .Or.;
				( lFiltro .And. Self:FilterField == "PERIODO_AQUIS" .AND. Self:FilterValue == substr(dtos((cQuery)->RH_DATABAS),1,6) ) .Or.;
				( lFiltro .And. Self:FilterField == "PERIODO_AQUIS" .AND. Self:FilterValue == substr(dtos((cQuery)->RH_DBASEAT),1,6) ) .Or.;
				( lFiltro .And. Self:FilterField == "PERIODO_GOZO"  .AND. Self:FilterValue == substr(dtos((cQuery)->RH_DATAINI),1,6) ) .Or.;
				( lFiltro .And. Self:FilterField == "PERIODO_GOZO"  .AND. Self:FilterValue == substr(dtos((cQuery)->RH_DATAFIM),1,6) )
			AAdd(Self:VacationReceiptsBrowse:Itens, oItem)
		EndIf
	
	EndIf
	
	(cQuery)->(DBSkip())
EndDo

(cQuery)->(DBCloseArea())
Return .T.


WSMETHOD GetVacationReceipt;
	WSRECEIVE Branch, Registration, AcquisitiveStartDate, EnjoymentStartDate;
	WSSEND VacationReceipt;
	WSSERVICE RHVacationReceipts

Local aInfo
Local cBanco := ""
Local cAg	 := ""

If !fInfo(@aInfo, Self:Branch)
	Return .F.
Endif

DBSelectArea("SRA")
DBSetOrder(1)

If !DBSeek(xFilial("SRA", Self:Branch) + Self:Registration)
Return .F.
Endif

DBSelectArea("SRH")
DBSetOrder(1)	//RH_FILIAL,RH_MAT,RH_DATABAS,RH_DATAINI

If !SRH->(DBSeek(xFilial("SRH", Self:Branch) + Self:Registration + DTOS(Self:AcquisitiveStartDate) + DTOS(Self:EnjoymentStartDate)))
Return(.F.)
Endif

Self:VacationReceipt := WSClassNew("TVacationReceipts")
Self:VacationReceipt:CompanyName	:= AllTrim(aInfo[3])
Self:VacationReceipt:CNPJ			:= aInfo[8]
Self:VacationReceipt:Branch			:= Self:Branch
Self:VacationReceipt:Logo			:= RetLogoemp(.T.,cEmpAnt,Self:Branch)

Self:VacationReceipt:EmployeeRegistration	:= SRA->RA_MAT

If ! Empty(SRA->RA_NOMECMP)
	Self:VacationReceipt:EmployeeName		:= AllTrim(SRA->RA_NOMECMP)
Else
	Self:VacationReceipt:EmployeeName		:= AllTrim(SRA->RA_NOME)
EndIF

Self:VacationReceipt:FunctionDescription	:= fGetFunction(SRH->RH_DTRECIB)
Self:VacationReceipt:AdmissionDate			:= SRA->RA_ADMISSA

Self:VacationReceipt:LaborCardNumber		:= SRA->RA_NUMCP
Self:VacationReceipt:LaborCardSeries		:= SRA->RA_SERCP
Self:VacationReceipt:LaborCardState			:= SRA->RA_UFCP

Self:VacationReceipt:CPF					:= SRA->RA_CIC
Self:VacationReceipt:Identity				:= SRA->RA_RG
Self:VacationReceipt:IRRFDependents			:= Val(SRA->RA_DEPIR)

Self:VacationReceipt:OverdueDate			:= SRH->RH_DBASEAT
Self:VacationReceipt:EnjoymentStartDate		:= SRH->RH_DATAINI
Self:VacationReceipt:EnjoymentEndDate		:= SRH->RH_DATAFIM

Self:VacationReceipt:ReceiptDate			:= SRH->RH_DTRECIB
Self:VacationReceipt:AcquisitiveStartDate	:= SRH->RH_DATABAS
Self:VacationReceipt:AcquisitiveEndDate		:= SRH->RH_DBASEAT

Self:VacationReceipt:PecuniaryAllowance		:= SRH->RH_DABONPE

Self:VacationReceipt:FixedSalary			:= SRH->RH_SALMES

cBanco := Alltrim(Posicione("SA6", 1, xFilial("SA6", Self:Branch) +  substr(SRA->RA_BCDEPSA,1,3), "SA6->A6_NOME"))
If Empty(cBanco)
	Self:VacationReceipt:BankName					:= substr(SRA->RA_BCDEPSA,1,3)
Else
	Self:VacationReceipt:BankName					:= substr(SRA->RA_BCDEPSA,1,3) + " - " + cBanco
EndIf
cAg := Alltrim(Posicione("SA6", 1, xFilial("SA6", Self:Branch) + SRA->RA_BCDEPSA, "SA6->A6_AGENCIA"))
If Empty(cAg)
	Self:VacationReceipt:BankAgency					:= substr(SRA->RA_BCDEPSA,4)
Else
	Self:VacationReceipt:BankAgency					:= cAg
EndIf
Self:VacationReceipt:BankAccount			:= SRA->RA_CTDEPSA

Self:VacationReceipt:DiscountTotal			:= 0
Self:VacationReceipt:RevenueTotal			:= 0
Self:VacationReceipt:ReceivableNetValue		:= 0

If ExistBlock("WSGP040")
	uRetBlock := ExecBlock( "WSGP040", .F., .F.,  Self:VacationReceipt  )
    IF ( ValType( uRetBlock ) == "O" )
		Self:VacationReceipt := ( uRetBlock )
	EndIF
EndIf


Self:VacationReceipt:Itens:= {}


BuildItens(Self:VacationReceipt, Self:Branch, Self:Registration, SRH->RH_DTRECIB,SRH->RH_DATAINI)

Self:VacationReceipt:ReceivableNetValue:= Self:VacationReceipt:RevenueTotal - Self:VacationReceipt:DiscountTotal
Self:VacationReceipt:ExtendedReceivableNetValue:= AllTrim(Extenso(Self:VacationReceipt:ReceivableNetValue))
Self:VacationReceipt:CurrencySymbol:= GetMV("MV_SIMB1")
Return .T.


Static Function BuildItens(oVacationReceipt, cBranch, cRegistration, dDataRef,dDataIni)
	Local cQuery:= GetNextAlias()
	Local cTipo
	Local aCodFol
	
	If !Fp_CodFol(@aCodFol, cBranch)
		Return
	EndIf
	
	BEGINSQL ALIAS cQuery
		COLUMN RR_HORAS AS NUMERIC(6,2)
		COLUMN RR_VALOR AS NUMERIC(12,2)
		
		SELECT
		SRR.RR_PD,
		SRR.RR_HORAS,
		SRR.RR_VALOR
		FROM
		%Table:SRR% SRR
		WHERE
		SRR.RR_FILIAL = %Exp:cBranch% AND
		SRR.RR_MAT = %Exp:cRegistration% AND
		(SRR.RR_DATAPAG = %Exp:dDataRef%  OR ( SRR.RR_DATAPAG = '' AND SRR.RR_DATA =  %Exp:dDataIni% ) ) AND
		SRR.%NotDel%
	ENDSQL
	
	While !Eof()
		If (cQuery)->RR_PD == aCodFol[102, 1] .OR.;
				(cQuery)->RR_PD == aCodFol[126, 1]
			(cQuery)->(DBSkip())
			Loop
		EndIf
		
		cTipo:= PosSrv((cQuery)->RR_PD, cBranch, "RV_TIPOCOD", 1)
		
		If cTipo == "1"
			AddRevenue(oVacationReceipt, (cQuery)->RR_PD, (cQuery)->RR_HORAS, (cQuery)->RR_VALOR)
		ElseIf cTipo == "2"
			AddDiscount(oVacationReceipt, (cQuery)->RR_PD, (cQuery)->RR_HORAS, (cQuery)->RR_VALOR)
		EndIf
		
		(cQuery)->(DBSkip())
	EndDo
	
	(cQuery)->(DBCloseArea())
Return

Static Function fGetSalary(dDataRef)
	Local nSalario:= fBuscaSal(dDataRef, NIL, NIL, .F.)
	
	IF (nSalario == 0)
		nSalario := SRA->RA_SALARIO
	EndIf
Return nSalario

Static Function AddRevenue(oVacationReceipt, cAllowance, nReference, nValue)
	Local oItem:= WSClassNew("TVacationReceiptsItem")
	oItem:Code			:= cAllowance
	oItem:Description	:= PosSrv(cAllowance, oVacationReceipt:Branch, "RV_DESC", 1)
	oItem:Reference		:= nReference
	oItem:Revenue		:= nValue
	oItem:Discount		:= 0
	AAdd(oVacationReceipt:Itens, oItem)
	
	oVacationReceipt:RevenueTotal += nValue
Return

Static Function AddDiscount(oVacationReceipt, cAllowance, nReference, nValue)
	Local oItem:= WSClassNew("TVacationReceiptsItem")
	oItem:Code			:= cAllowance
	oItem:Description	:= PosSrv(cAllowance, oVacationReceipt:Branch, "RV_DESC", 1)
	oItem:Reference		:= nReference
	oItem:Revenue		:= 0
	oItem:Discount		:= nValue
	
	AAdd(oVacationReceipt:Itens, oItem)
	
	oVacationReceipt:DiscountTotal += nValue
Return

WSMETHOD GetMessage WSRECEIVE Branch WSSEND Messages WSSERVICE RHVacationReceipts
	
	Local lRet    	  := .T.
	Local lValid  	  := .F.
	Local cMsg 		  := ""
	Local cCodTab	  := "S045"
	Local cBranch	  := xFilial("RCC", Self:Branch)
	//Local cTeste		:= Substr(Branch, 1, 4)
	
	DbSelectArea("RCC")
	DbSetOrder(1)
	If DbSeek(cBranch + cCodTab)
		If Empty(RCC->RCC_CONTEU)
			::Messages:= ""
		Else
			::Messages:= Alltrim(RCC->RCC_CONTEU)
		EndIf
	EndIf
	
Return lRet

Static Function fGetFunction(dDataRef)
	
	Local aArea		:= GetArea()
	Local aAreaSR7	:= SR7->( GetArea() )
	Local aStruSR7	:= {}
	Local cAliasSR7 := "SR7"
	Local cDesc 	:= ""
	Local cQuery    := ""
	Local cTipo     := ""
	Local nX		:= 0
		
	aStruSR7  	:= SR7->(dbStruct())
	cAliasSR7 	:= "QSR7"
	cQuery 		:= "SELECT * "
	cQuery 		+= "FROM " + RetSqlName("SR7") + " SR7 "
	cQuery 		+= "WHERE SR7.R7_FILIAL='" + SRA->RA_FILIAL + "' AND "
	cQuery 		+= "SR7.R7_MAT='" + SRA->RA_MAT + "' AND "
	cQuery 		+= "SR7.D_E_L_E_T_ = ' ' "
	cQuery 		+= "ORDER BY " + SqlOrder(SR7->(IndexKey()))
	cQuery 		:= ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TcGenQry(Nil, Nil, cQuery), cAliasSR7, .T., .T.)
	
	For nX := 1 To Len(aStruSR7)
		If ( aStruSR7[nX][2] != "C" )
			TcSetField(cAliasSR7, aStruSR7[nX][1], aStruSR7[nX][2], aStruSR7[nX][3], aStruSR7[nX][4])
		EndIf
	Next nX
	
	While !Eof() .And. (cAliasSR7)->R7_FILIAL + (cAliasSR7)->R7_MAT == SRA->RA_FILIAL + SRA->RA_MAT .And. (cAliasSR7)->R7_DATA <= dDataRef
		cDesc := Alltrim(Posicione("SRJ", 1, xFilial("SRJ", (cAliasSR7)->R7_FILIAL) + (cAliasSR7)->R7_FUNCAO, "SRJ->RJ_DESC"))
		dbSkip()
	Enddo
	
	dbSelectArea(cAliasSR7)
	dbCloseArea()
	dbSelectArea("SR7")
		
	RestArea( aAreaSR7 )
	RestArea( aArea )
	
	IF Empty(cDesc)
		cDesc := Alltrim(Posicione("SRJ", 1, xFilial("SRJ", SRA->RA_FILIAL) + SRA->RA_CODFUNC, "SRJ->RJ_DESC"))
	EndIf
	
Return(cDesc)
