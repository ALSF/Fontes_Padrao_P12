#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PWSA360.CH"

#DEFINE PAGE_LENGTH 10

Function WSAPD016()
Return

WSSTRUCT TMonitoringList
	WSDATA StartDate	As String
	WSDATA EndDate		As String
	WSDATA Code			As String
	WSDATA Description	As String
ENDWSSTRUCT

WSSTRUCT TMonitoringBrowse
	WSDATA Itens		AS Array Of TMonitoringList	OPTIONAL
ENDWSSTRUCT

WSSTRUCT TGraphicsList
	WSDATA TipoAV		As String
	WSDATA DatRet		As String
ENDWSSTRUCT

WSSTRUCT TGraphicsBrowse
	WSDATA Itens		AS Array Of TGraphicsList	OPTIONAL
	WSDATA DescripSelec	AS String
	WSDATA EndDateSelec	AS String
ENDWSSTRUCT

WSSERVICE RHMonitoring DESCRIPTION STR0001 //"Acompanhamneto Aval. Desempenho"
	WSDATA WsNull   	As String	OPTIONAL
	WSDATA Branch		As String	OPTIONAL
	WSDATA Registration	As String	OPTIONAL
	
	WSDATA FilterField  As String	OPTIONAL
	WSDATA FilterValue	As String	OPTIONAL
	

	WSDATA StartDate	As String	OPTIONAL
	WSDATA EndDate		As String	OPTIONAL
	WSDATA Code			As String	OPTIONAL
	WSDATA Description	As String	OPTIONAL
	
	WSDATA MonitoringBrowse	As TMonitoringBrowse 
	WSDATA GraphicsBrowse	As TGraphicsBrowse
	
	WSMETHOD BrowseMonitoring	DESCRIPTION STR0017 //"Método para listar as Avaliações de Desempenho disponibilizadas."
	WSMETHOD GetMonitoring	    DESCRIPTION STR0018 //"Método para gerar os resultados relativos a Avaliação de Desempenho selecionada."	
ENDWSSERVICE                                  

WSMETHOD BrowseMonitoring;
WSRECEIVE Branch, Registration, FilterField, FilterValue;
WSSEND MonitoringBrowse;
WSSERVICE RHMonitoring 
	Local aArea     := GetArea()
	Local cAlias
	Local cFiltro	:= ""
	
	If FilterField == "Code" .AND. Len(FilterValue) > 0
		cFiltro	+= " RD6.RD6_CODIGO = '" + FilterValue + "' AND"
	EndiF
			
	If FilterField == "StartDate" .AND. Len(FilterValue) > 0		
		cFiltro	+= " RD6.RD6_DTINI >= '" + Right(FilterValue, 4) + SUBSTR(FilterValue, 4, 2) + Left(FilterValue, 2) + "' AND"
	EndiF
	
	cFiltro := "% " + cFiltro + " %"

	cAlias:= GetNextAlias()  
	
	BeginSql alias cAlias
	
	    SELECT RD6_CODIGO
		     , RD6_DESC
		     , RD6_DTINI
		     , RD6_DTFIM 
		  FROM %table:RD6% RD6
         WHERE %exp:cFiltro% 
               RD6.%notDel%
	EndSql
	
	While (cAlias)->( !Eof())
	
		oItem:= WSClassNew("TMonitoringList")
		oItem:Code			:= (cAlias)->RD6_CODIGO
		oItem:Description	:= (cAlias)->RD6_DESC
		oItem:StartDate		:= (cAlias)->RD6_DTINI
		oItem:EndDate		:= (cAlias)->RD6_DTFIM
		
		AAdd(Self:MonitoringBrowse:Itens, oItem)
	
		(cAlias)->( dbSkip() )
	EndDo    
		
	RestArea(aArea)
	  		
Return .T. 

/********************************************************************
* GetMonitoring                                                     *
*                                                                   *
* Método para gerar os resultados relativos a Avaliação de          *
* Desempenho selecionada.                                           *
*                                                                   *
* Esta rotina gera o grafico para o portal, no caso do remote a		*
* funcao Apd240Gra() encontra-se no fonte APDA240.PRW               *
*********************************************************************/
WSMETHOD GetMonitoring;
WSRECEIVE Code;
WSSEND GraphicsBrowse;
WSSERVICE RHMonitoring 
	Local aArea     := GetArea()
	Local cAlias
	Local cFiltro	:= " RD6.RD6_CODIGO = '" + Code + "'"
	
	cFiltro := "% " + cFiltro + " %"
	
	cAlias:= GetNextAlias()  
	
	BeginSql alias cAlias
	
	    SELECT RD6_DESC
		     , RD6_DTFIM 
		  FROM %table:RD6% RD6
         WHERE %exp:cFiltro% 
           AND RD6.%notDel%
	EndSql
	
	While (cAlias)->( !Eof())
		Self:GraphicsBrowse:DescripSelec	:= (cAlias)->RD6_DESC
		Self:GraphicsBrowse:EndDateSelec	:= (cAlias)->RD6_DTFIM
		(cAlias)->( dbSkip() )
	EndDo
	
	cFiltro	:= "RDC_CODAVA = '" + Code + "'"
	
	cFiltro := "% " + cFiltro + " %"

	cAlias:= GetNextAlias()  
	
	BeginSql alias cAlias
	
		  SELECT RDC_TIPOAV
		       , RDC_DATRET 
		    FROM %table:RDC% RDC
		   WHERE %exp:cFiltro%    
    		 AND RDC.%notDel%
		ORDER BY RDC_TIPOAV, RDC_DATRET
	EndSql
	
	While (cAlias)->( !Eof())
	
		oItem:= WSClassNew("TGraphicsList")
		oItem:TipoAV	:= (cAlias)->RDC_TIPOAV
		oItem:DatRet	:= (cAlias)->RDC_DATRET
		
		AAdd(Self:GraphicsBrowse:Itens, oItem)
	
		(cAlias)->( dbSkip() )
	EndDo    
		
	RestArea(aArea)
	  		
Return .T. 