#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10

Function WSGPE090()
Return

WSSTRUCT TExtractList
	WSDATA Branch				As String
	WSDATA Year					As String
	WSDATA Month				As String
	WSDATA PrevBalance			As Float
	WSDATA Interest				As Float
	WSDATA IntAmount			As Float
	WSDATA DepAmount			As Float
	WSDATA WithAmount			As Float
	WSDATA CurrBalance			As Float
	WSDATA ActBalance			As Float
ENDWSSTRUCT

WSSTRUCT TExtractBrowse
	WSDATA Itens				AS Array Of TExtractList	OPTIONAL
	WSDATA PagesTotal			AS Integer 					OPTIONAL
ENDWSSTRUCT

WSSERVICE RHExtract DESCRIPTION "Consulta de Extrato de FGTS"
	WSDATA WsNull   	   		As String	OPTIONAL
	WSDATA Branch				As String
	WSDATA Registration			As String

	WSDATA CurrentPage			As Integer
	WSDATA FilterField  		As String
	WSDATA FilterValue			As String
	
	WSDATA Year					As String
	WSDATA Month				As String
	WSDATA PrevBalance			As Float
	WSDATA Interest				As Float
	WSDATA IntAmount			As Float
	WSDATA DepAmount			As Float
	WSDATA WithAmount			As Float
	WSDATA CurrBalance			As Float
	WSDATA ActBalance			As Float
	
	WSDATA ContHtml				AS String	OPTIONAL
	
	WSDATA ExtractBrowse   		As TExtractBrowse
	
	WSMETHOD BrowseExtract		DESCRIPTION "Método de consulta do Extrato de FGTS disponibilizados"
ENDWSSERVICE 


WSMETHOD BrowseExtract;
WSRECEIVE Branch, Registration, CurrentPage, FilterField, FilterValue;
WSSEND ExtractBrowse;
WSSERVICE RHExtract
	Local cAno		
	Local cMes
	Local cFiltro
	Local cSRSCountAlias	:= GetNextAlias()
	Local cSRSAlias			:= GetNextAlias()
	Local nRegIni           := 1
	Local nRegFim			:= 0
	Local nReg				:= 0
	
	cFiltro	:= " RS.RS_FILIAL = '" + Branch + "'"
	cFiltro	+= " AND RS.RS_MAT = '" + Registration + "'"
	
	If FilterField == "YearMonth" .AND. Len(FilterValue) > 0
		cAno		:= Substr(FilterValue, 1, 4)		
   		cMes		:= Substr(FilterValue, 5, 2)	 		
		cFiltro	+= " AND RS.RS_ANO = '" + cAno + "'"				
		cFiltro	+= " AND RS.RS_MES = '" + cMes + "'"
	EndiF
	
	cFiltro := "% " + cFiltro + " %"
		
	Self:ExtractBrowse:= WSClassNew("TExtractBrowse")	   
	::ExtractBrowse:Itens := {}
	
	 
	BEGINSQL alias cSRSCountAlias
			SELECT COUNT(*) AS REGISTROS
		      FROM %table:SRS% RS
		     WHERE %exp:cFiltro% 
	           AND RS.%notDel%		
	ENDSQL
	
	If (cSRSCountAlias)->REGISTROS > 0
	    // Seta a quantidade de paginas
		Self:ExtractBrowse:PagesTotal := Ceiling((cSRSCountAlias)->REGISTROS / PAGE_LENGTH) 
		
		// Define qual a página inicial e final de acordo com a paginacao corrente		
		nRegFim	:= CurrentPage * PAGE_LENGTH
		If CurrentPage > 1
			nRegIni	:= (nRegFim - PAGE_LENGTH) + 1			
		EndIf
		
		BEGINSQL alias cSRSAlias
				SELECT RS.RS_FILIAL
					 , RS.RS_ANO
			         , RS.RS_MES
			         , RS.RS_SALANT
			         , RS.RS_PERJUR
			         , RS.RS_VALJUR
			         , RS.RS_VALDEP
			         , RS.RS_VALSAQ
			         , RS.RS_SALATU
			         , RS.RS_SALREAL
			      FROM %table:SRS% RS
			     WHERE %exp:cFiltro% 
		           AND RS.%notDel% 
			  ORDER BY RS_ANO DESC		
		ENDSQL   	
		
		While (cSRSAlias)->( !Eof())
		    nReg++
		    
	    	If nRegIni <= nReg .AND. nRegFim >=  nReg 
				oItem:= WSClassNew("TExtractList")
				oItem:Branch		:= (cSRSAlias)->RS_FILIAL
				oItem:Year			:= (cSRSAlias)->RS_ANO
				oItem:Month			:= (cSRSAlias)->RS_MES
				oItem:PrevBalance	:= (cSRSAlias)->RS_SALANT				
				oItem:Interest		:= (cSRSAlias)->RS_PERJUR				
				oItem:IntAmount		:= (cSRSAlias)->RS_VALJUR
				oItem:DepAmount		:= (cSRSAlias)->RS_VALDEP				
				oItem:WithAmount	:= (cSRSAlias)->RS_VALSAQ				
				oItem:CurrBalance	:= (cSRSAlias)->RS_SALATU
				oItem:ActBalance	:= (cSRSAlias)->RS_SALREAL
				
				AAdd(::ExtractBrowse:Itens, oItem)
			EndIf
	
			(cSRSAlias)->( dbSkip() )
		EndDo
	Else
		oItem:= WSClassNew("TExtractList")
		oItem:Branch		:= ''
		oItem:Year			:= '-'
		oItem:Month			:= '-'
		oItem:PrevBalance	:= 0				
		oItem:Interest		:= 0				
		oItem:IntAmount		:= 0
		oItem:DepAmount		:= 0				
		oItem:WithAmount	:= 0				
		oItem:CurrBalance	:= 0
		oItem:ActBalance	:= 0
		
		AAdd(::ExtractBrowse:Itens, oItem)
		Self:ExtractBrowse:PagesTotal	:= 0	
	EndIf
Return .T. 