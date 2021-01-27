#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10


Function WSGPE120()
Return

WSSTRUCT TVacationNotice
	WSDATA CompanyName					As String
	WSDATA CompanyState					As String
	WSDATA CNPJ							As String
	WSDATA Branch						As String
	WSDATA EmployeeRegistration			As String
	WSDATA EmployeeName					As String
	WSDATA FunctionDescription			As String
	WSDATA AdmissionDate				As Date
	WSDATA LaborCardNumber				As String
	WSDATA LaborCardSeries				As String	
	WSDATA LaborCardState				As String		
	WSDATA CPF							As String
	WSDATA Identity						As String
	WSDATA NoticeType                   AS String
	WSDATA NoticeAcceptance				AS String

	WSDATA OverdueDate					As Date
	WSDATA EnjoymentStartDate			As Date	
	WSDATA EnjoymentEndDate				As Date
	WSDATA AcquisitiveStartDate			As Date
	WSDATA AcquisitiveEndDate			As Date
	WSDATA ReceiptDate					As Date
	WSDATA NoticeDate					As Date OPTIONAL
	
	WSDATA PecuniaryAllowance			as Integer
	WSDATA PaydLeave					as Integer
	WSDATA PaydLeaveFollow				as Integer

	WSDATA IRRFDependents				As Integer
	WSDATA BankName						As String
	WSDATA BankAgency					As String
	WSDATA BankAccount					As String

	WSDATA Logo							As String  Optional
	
	WSDATA Itens						As Array Of TVacationNoticeItem OPTIONAL
ENDWSSTRUCT

WSSTRUCT TVacationNoticeList
	WSDATA EnjoymentStartDate		AS Date
	WSDATA EnjoymentEndDate			AS Date	
	WSDATA AcquisitiveStartDate		AS Date
	WSDATA AcquisitiveEndDate		AS Date	
	WSDATA NoticeType				AS String	
	WSDATA PecuniaryAllowance		AS Integer
	WSDATA NoticeAcceptance			AS String
ENDWSSTRUCT

WSSTRUCT TVacationNoticeItem
	WSDATA Code					As String
	WSDATA Description			As String
	WSDATA Reference			As Float
	WSDATA Revenue				As Float
	WSDATA Discount				As Float
ENDWSSTRUCT

WSSTRUCT TVacationNoticeBrowse
	WSDATA Itens		AS Array Of TVacationNoticeList	OPTIONAL
	WSDATA PagesTotal	AS Integer 							OPTIONAL
ENDWSSTRUCT

WSSTRUCT AcceptNotice
	WSDATA Branch					AS String 	
	WSDATA Registration			AS String 	
	WSDATA EnjoymentStartDate	AS Date 	
ENDWSSTRUCT

	
WSSERVICE RHVacationNotice DESCRIPTION "Aviso de Férias"
	WSDATA Branch			AS String
	WSDATA Registration		AS String
	WSDATA Messages			As String

	WSDATA AcquisitiveStartDate		AS Date
	WSDATA AcquisitiveEndDate		AS Date	OPTIONAL
	WSDATA EnjoymentStartDate		AS Date
	WSDATA EnjoymentEndDate			AS Date	OPTIONAL
	
	WSDATA VacationNoticeBrowse		As TVacationNoticeBrowse
	WSDATA VacationNotice			AS TVacationNotice
	
	WSDATA CurrentPage				As Integer	OPTIONAL
	WSDATA FilterField  			As String	OPTIONAL
	WSDATA FilterValue				As String	OPTIONAL
	WSDATA PecuniaryAllowance		As Integer  OPTIONAL
	WSDATA NoticeType				As String   OPTIONAL
	WSDATA NoticeAcceptance		AS String OPTIONAL

	WSMETHOD BrowseVacationNotice	DESCRIPTION "Método de consulta ao aviso de férias calculadas ou programadas"
	WSMETHOD GetVacationNotice		DESCRIPTION "Método para consulta dos dados do aviso de férias"
	WSMETHOD AcceptNotice			DESCRIPTION "Método para realizar aceite do Aviso de Férias"
//	WSMETHOD GetMessage				DESCRIPTION "Criação de Mensagem Padrão"	
ENDWSSERVICE                                  


WSMETHOD BrowseVacationNotice;
WSRECEIVE Branch, Registration, CurrentPage, FilterField, FilterValue;
WSSEND VacationNoticeBrowse;
WSSERVICE RHVacationNotice
	Local aDataAux	:= {}
	Local lAceite := (SRH->(ColumnPos("RH_ACEITE"))>0)
	Local cQuery:= GetNextAlias()
	Local cBranch := xFilial("SRH", Self:Branch)
	Local cRegistration:= Self:Registration
	Local nDiaAntFer	:= SuperGetMv("MV_DANTFER",,0) // Dias de Antecedencia que o Aviso de Férias será disponibilizado no Portal
	Local dDatDispo		:= SRA->RA_ADMISSA

	If lAceite
		BEGINSQL ALIAS cQuery
	        COLUMN RH_DATABAS AS DATE
	        COLUMN RH_DBASEAT AS DATE
	        COLUMN RH_DATAINI AS DATE
	        COLUMN RH_DATAFIM AS DATE
	
			SELECT 
				SRH.RH_DATABAS,
				SRH.RH_DBASEAT,
				SRH.RH_DATAINI,
				SRH.RH_DATAFIM,
				SRH.RH_DABONPE,
				SRH.RH_ACEITE
			FROM 
				%Table:SRH% SRH
			WHERE 
				SRH.RH_FILIAL = %Exp:cBranch% AND 
				SRH.RH_MAT = %Exp:cRegistration% AND
				SRH.RH_DATAFIM >= %Exp:dDataBase% AND
				SRH.%NotDel%
			ORDER BY
				SRH.RH_DATABAS DESC		 
		ENDSQL
	Else
		BEGINSQL ALIAS cQuery
	        COLUMN RH_DATABAS AS DATE
	        COLUMN RH_DBASEAT AS DATE
	        COLUMN RH_DATAINI AS DATE
	        COLUMN RH_DATAFIM AS DATE
	
			SELECT 
				SRH.RH_DATABAS,
				SRH.RH_DBASEAT,
				SRH.RH_DATAINI,
				SRH.RH_DATAFIM,
				SRH.RH_DABONPE
			FROM 
				%Table:SRH% SRH
			WHERE 
				SRH.RH_FILIAL = %Exp:cBranch% AND 
				SRH.RH_MAT = %Exp:cRegistration% AND
				SRH.RH_DATAFIM >= %Exp:dDataBase% AND
				SRH.%NotDel%
			ORDER BY
				SRH.RH_DATABAS DESC		 
		ENDSQL
	EndIf
	   
	Self:VacationNoticeBrowse:= WSClassNew("TVacationNoticeBrowse")
	Self:VacationNoticeBrowse:Itens := {}
	Self:VacationNoticeBrowse:PagesTotal := 0
	
	While !(Eof())
		aAdd(aDataAux,{DtoS((cQuery)->RH_DATABAS)+DtoS((cQuery)->RH_DBASEAT)})
	
		If !Empty(nDiaAntFer)
			dDatDispo :=  (cQuery)->RH_DATAINI - nDiaAntFer
		EndIf	
		
		If dDataBase >= dDatDispo
			oItem:= WSClassNew("TVacationNoticeList")
			oItem:AcquisitiveStartDate	:= (cQuery)->RH_DATABAS
			oItem:AcquisitiveEndDate	:= (cQuery)->RH_DBASEAT
			oItem:EnjoymentStartDate	:= (cQuery)->RH_DATAINI
			oItem:EnjoymentEndDate		:= (cQuery)->RH_DATAFIM
			oItem:PecuniaryAllowance	:= (cQuery)->RH_DABONPE
			oItem:NoticeType			:= "F"
			If lAceite
				oItem:NoticeAcceptance	:= If(Empty((cQuery)->RH_ACEITE),"",(cQuery)->RH_ACEITE)
			Else
				Self:VacationNotice:NoticeAcceptance := "FALSE"
			EndIf
		
			aAdd(Self:VacationNoticeBrowse:Itens, oItem)
		EndIf
		(cQuery)->(DBSkip())
	EndDo
	
	(cQuery)->(DBCloseArea())

	//Busca programação de férias	
	BEGINSQL ALIAS cQuery
        COLUMN RF_DATABAS AS DATE
        COLUMN RF_DATAINI AS DATE
        COLUMN RF_DATINI2 AS DATE
        COLUMN RF_DATINI3 AS DATE
        COLUMN RF_DATAFIM AS DATE
        	      
		SELECT 
			SRF.RF_DATABAS,
			SRF.RF_DATAFIM,
			SRF.RF_DATAINI,
			SRF.RF_DATINI2,
			SRF.RF_DATINI3,
			SRF.RF_DFEPRO1,
			SRF.RF_DFEPRO2,
			SRF.RF_DFEPRO3,
			SRF.RF_DABPRO1,
			SRF.RF_DABPRO2,
			SRF.RF_DABPRO3
		FROM 
			%Table:SRF% SRF
		WHERE 
			SRF.RF_FILIAL = %Exp:cBranch% AND 
			SRF.RF_MAT = %Exp:cRegistration% AND
			SRF.RF_STATUS = '1' AND
			SRF.%NotDel%
	ENDSQL
	
	While !(Eof())
		//Se já existir férias calculadas para o periodo, não exibe o aviso da programação.
		If Ascan(aDataAux,{ |x| x[1] = DtoS((cQuery)->RF_DATABAS) + DtoS((cQuery)->RF_DATAFIM) }) > 0
			(cQuery)->(DBSkip())
			Loop
		EndIf
	
		If !Empty((cQuery)->RF_DATAINI) 

			If !Empty(nDiaAntFer)
				dDatDispo :=  (cQuery)->RF_DATAINI - nDiaAntFer
			EndIf
			
			If dDataBase >= dDatDispo
				oItem:= WSClassNew("TVacationNoticeList")
				oItem:AcquisitiveStartDate	:= (cQuery)->RF_DATABAS
				oItem:AcquisitiveEndDate	:= (cQuery)->RF_DATAFIM
				oItem:EnjoymentStartDate	:= (cQuery)->RF_DATAINI
				oItem:EnjoymentEndDate		:= (cQuery)->RF_DATAINI + ((cQuery)->RF_DFEPRO1 - 1) 
				oItem:PecuniaryAllowance	:= (cQuery)->RF_DABPRO1
				oItem:NoticeType			:= "P"
				If lAceite
					oItem:NoticeAcceptance	:= ""
				Else
					oItem:NoticeAcceptance	:= "FALSE"
				EndIf
			
				aAdd(Self:VacationNoticeBrowse:Itens, oItem)
			EndIf	
		EndIf
		
		If !Empty((cQuery)->RF_DATINI2) 
			
			If !Empty(nDiaAntFer)
				dDatDispo :=  (cQuery)->RF_DATINI2 - nDiaAntFer
			EndIf
			
			If dDataBase >= dDatDispo
				oItem:= WSClassNew("TVacationNoticeList")
				oItem:AcquisitiveStartDate	:= (cQuery)->RF_DATABAS
				oItem:AcquisitiveEndDate	:= (cQuery)->RF_DATAFIM
				oItem:EnjoymentStartDate	:= (cQuery)->RF_DATINI2
				oItem:EnjoymentEndDate		:= (cQuery)->RF_DATINI2 + ((cQuery)->RF_DFEPRO2 - 1) 
				oItem:PecuniaryAllowance	:= (cQuery)->RF_DABPRO2
				oItem:NoticeType			:= "P"
				If lAceite
					oItem:NoticeAcceptance	:= ""
				Else
					oItem:NoticeAcceptance	:= "FALSE"
				EndIf
			
				aAdd(Self:VacationNoticeBrowse:Itens, oItem)
			EndIf	
		EndIf
		
		If !Empty((cQuery)->RF_DATINI3) 
			
			If !Empty(nDiaAntFer)
				dDatDispo :=  (cQuery)->RF_DATINI3 - nDiaAntFer
			EndIf
			
			If dDataBase >= dDatDispo
				oItem:= WSClassNew("TVacationNoticeList")
				oItem:AcquisitiveStartDate	:= (cQuery)->RF_DATABAS
				oItem:AcquisitiveEndDate	:= (cQuery)->RF_DATAFIM
				oItem:EnjoymentStartDate	:= (cQuery)->RF_DATINI3
				oItem:EnjoymentEndDate		:= (cQuery)->RF_DATINI3 + ((cQuery)->RF_DFEPRO3 - 1) 
				oItem:PecuniaryAllowance	:= (cQuery)->RF_DABPRO3
				oItem:NoticeType			:= "P"
				If lAceite
					oItem:NoticeAcceptance	:= ""
				Else
					oItem:NoticeAcceptance	:= "FALSE"
				EndIf
			
				aAdd(Self:VacationNoticeBrowse:Itens, oItem)
			EndIf
		EndIf		
		(cQuery)->(DBSkip())
	EndDo
	
	(cQuery)->(DBCloseArea())		
		
Return .T.


WSMETHOD GetVacationNotice;
WSRECEIVE Branch, Registration, AcquisitiveStartDate, AcquisitiveEndDate, EnjoymentStartDate, EnjoymentEndDate, PecuniaryAllowance, NoticeType, NoticeAcceptance;
WSSEND VacationNotice;
WSSERVICE RHVacationNotice
	Local aInfo
	Local lAceite := (SRH->(ColumnPos("RH_ACEITE"))>0)

	If !fInfo(@aInfo, Self:Branch)
		Return .F.
	Endif
	
	DBSelectArea("SRA")
	DBSetOrder(1)

	If !DBSeek(xFilial("SRA", Self:Branch) + Self:Registration)
		Return .F.
	Endif

	Self:VacationNotice := WSClassNew("TVacationNotice")

	Self:VacationNotice:CompanyName		:= AllTrim(aInfo[3])
	Self:VacationNotice:CompanyState	:= AllTrim(aInfo[5])
	Self:VacationNotice:CNPJ			:= aInfo[8]
	Self:VacationNotice:Branch			:= Self:Branch
	Self:VacationNotice:Logo			:= RetLogoemp(.T.,cEmpAnt,Self:Branch)

	Self:VacationNotice:EmployeeRegistration	:= SRA->RA_MAT
	If ! Empty(SRA->RA_NOMECMP)
		Self:VacationNotice:EmployeeName			:= AllTrim(SRA->RA_NOMECMP)
	Else 
		Self:VacationNotice:EmployeeName			:= AllTrim(SRA->RA_NOME)
	EndIf
	
	Self:VacationNotice:AdmissionDate			:= SRA->RA_ADMISSA

	Self:VacationNotice:LaborCardNumber			:= SRA->RA_NUMCP  
	Self:VacationNotice:LaborCardSeries			:= SRA->RA_SERCP  
	Self:VacationNotice:LaborCardState			:= SRA->RA_UFCP   

	Self:VacationNotice:CPF						:= SRA->RA_CIC
	Self:VacationNotice:Identity				:= SRA->RA_RG
	Self:VacationNotice:IRRFDependents			:= Val(SRA->RA_DEPIR)
	
	Self:VacationNotice:BankName				:= Alltrim(Posicione("SA6", 1, xFilial("SA6", Self:Branch) + SRA->RA_BCDEPSA, "SA6->A6_NOME"))
	Self:VacationNotice:BankAgency				:= Alltrim(Posicione("SA6", 1, xFilial("SA6", Self:Branch) + SRA->RA_BCDEPSA, "SA6->A6_AGENCIA"))
	Self:VacationNotice:BankAccount				:= SRA->RA_CTDEPSA
	
	Self:VacationNotice:NoticeType				:= Self:NoticeType


	DBSelectArea("SRH")
	DBSetOrder(1)	//RH_FILIAL,RH_MAT,RH_DATABAS,RH_DATAINI

	If Self:NoticeType == "F"
		If SRH->(DBSeek(xFilial("SRH", Self:Branch) + Self:Registration + DTOS(Self:AcquisitiveStartDate) + DTOS(Self:EnjoymentStartDate)))
		
			Self:VacationNotice:OverdueDate				:= SRH->RH_DBASEAT
			Self:VacationNotice:EnjoymentStartDate		:= SRH->RH_DATAINI
			Self:VacationNotice:EnjoymentEndDate		:= SRH->RH_DATAFIM
			
		   	Self:VacationNotice:ReceiptDate				:= SRH->RH_DTRECIB
		   	Self:VacationNotice:NoticeDate				:= SRH->RH_DTAVISO
			Self:VacationNotice:AcquisitiveStartDate	:= SRH->RH_DATABAS
			Self:VacationNotice:AcquisitiveEndDate		:= SRH->RH_DBASEAT  
			
			Self:VacationNotice:PecuniaryAllowance		:= SRH->RH_DABONPE
			Self:VacationNotice:PaydLeaveFollow			:= SRH->RH_DIALRE1
			Self:VacationNotice:PaydLeave				:= SRH->RH_DIALREM
		
			Self:VacationNotice:FunctionDescription		:= fGetFunction(SRH->RH_DTRECIB)
			If lAceite
				Self:VacationNotice:NoticeAcceptance		:= If(Empty(SRH->RH_ACEITE),"",SRH->RH_ACEITE)
			Else
				Self:VacationNotice:NoticeAcceptance := "FALSE"
			EndIf
			
			Self:VacationNotice:Itens:= {}
		
		EndIf
	Else
		Self:VacationNotice:OverdueDate				:= Self:AcquisitiveEndDate
		Self:VacationNotice:EnjoymentStartDate		:= Self:EnjoymentStartDate
		Self:VacationNotice:EnjoymentEndDate		:= Self:EnjoymentEndDate
		
		Self:VacationNotice:AcquisitiveStartDate	:= Self:AcquisitiveStartDate
		Self:VacationNotice:AcquisitiveEndDate		:= Self:AcquisitiveEndDate
		
		Self:VacationNotice:ReceiptDate				:= DataValida(DataValida(Self:EnjoymentStartDate-1,.F.)-1,.F.)
		Self:VacationNotice:NoticeDate				:= Self:EnjoymentStartDate - 30  
		
		Self:VacationNotice:PecuniaryAllowance		:= Self:PecuniaryAllowance
		
		Self:VacationNotice:PaydLeaveFollow			:= 0
		Self:VacationNotice:PaydLeave				:= 0		
	
		Self:VacationNotice:FunctionDescription		:= Alltrim(Posicione("SRJ", 1, xFilial("SRJ", SRA->RA_FILIAL) + SRA->RA_CODFUNC, "SRJ->RJ_DESC"))
		
		Self:VacationNotice:NoticeAcceptance := ""
		
		Self:VacationNotice:Itens:= {}
	
	EndIf
Return .T.

//---------------------------------------------------------------
WSMETHOD AcceptNotice;
WSRECEIVE Branch, Registration, EnjoymentStartDate;
WSSEND VacationNotice;
WSSERVICE RHVacationNotice
	Local cBranch := xFilial("SRH", Self:Branch)
	Local cRegistration:= Self:Registration
	Local cEnjoymentStartDate:=DtoS(Self:EnjoymentStartDate)
	Local cCIC := ""
	Local cName := ""

	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(cBranch+cRegistration)
	cCIC := SRA->RA_CIC
	cName:= SRA->RA_NOME
	
	//Posiciona no registro do calculo de ferias
	dbSelectArea("SRH")
	dbSetOrder(2)		//RH_FILIAL+RH_MAT+RH_DATAINI
	dbSeek(cBranch+cRegistration+cEnjoymentStartDate) //PEGAR DADOS DO OBJETO
	Begin Transaction
		SRH->( Reclock("SRH",.F.) )
			RH_ACEITE := DtoS(Date())+"|"+Time()+"|"+cCIC+"|"+cName //Data|Hora|CPF|Nome
		SRH->( MsUnlock() )
		SRH->( FkCommit() )
	End Transaction
Return .T.

//---------------------------------------------------------------
Static Function fGetFunction(dDataRef)

Local aArea		:= GetArea()
Local aAreaSR7	:= SR7->( GetArea() )
Local aStruSR7	:= {}
Local cAliasSR7 := "SR7"
Local cDesc 	:= ""
Local cQuery    := "" 
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
