#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

Function WSPON010()
Return

WSSTRUCT THoursBankList
	WSDATA Branch		AS String
	WSDATA Registration	AS String
	WSDATA DateEvent	AS Date
	WSDATA Event		AS String
	WSDATA Debit		AS String
	WSDATA Credit		AS String
	WSDATA Balance		AS String	
	WSDATA StatusEvent	AS String
ENDWSSTRUCT 

WSSTRUCT THoursBankBrowse
	WSDATA Itens		AS Array Of THoursBankList	OPTIONAL
ENDWSSTRUCT

WSSERVICE RHHoursBank DESCRIPTION "Banco de Horas"
	WSDATA Branch			AS String
	WSDATA Registration		AS String	
	WSDATA ContHtml			AS String	OPTIONAL

	WSDATA HoursBankBrowse	As THoursBankBrowse
	
	WSMETHOD GetHoursBank	DESCRIPTION "Método de consulta do Banco de Horas do funcionario"
ENDWSSERVICE                                  

WSMETHOD GetHoursBank;
WSRECEIVE Branch, Registration;
WSSEND ContHtml;
WSSERVICE RHHoursBank
	Local lRet			:= .T.
	Local lTerminal		:= .T.
	Local lPortal		:= .T.
	Local cFilTerminal	:= Self:Branch
	Local cMatTerminal	:= Self:Registration
	Local bCloseFiles:= {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }
	Local aFilesOpen :={"SP5", "SP8","SPB","RFF","SPC", "RFE"}
	                                                    
		                                                    
	dbSelectArea("SRA")
	SRA->(dbSetOrder(1))
	SRA->(dbSeek(cFilTerminal+cMatTerminal))
	
	Self:ContHtml := u_Extrabh( lTerminal , cFilTerminal , cMatTerminal, lPortal  )
	Aeval(aFilesOpen, bCloseFiles) 
Return lRet