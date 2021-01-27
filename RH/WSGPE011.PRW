#INCLUDE "WSAPD010.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

WSSTRUCT CMENU
	WSDATA aRotinas As Array Of CAI8
ENDWSSTRUCT

WSSTRUCT CAI8
	WSDATA sRotinas AS String
ENDWSSTRUCT

// Web Service que contém os métodos de Consulta e Atualização dos dadso do Funcionário.
WSSERVICE WSSEARCHMENU DESCRIPTION STR0001	
	WSDATA OutName     As STRING
    WSDATA oOut        AS CMENU
    WSDATA sFilial     AS STRING
	WSDATA lGSP        AS BOOLEAN
    
	WSMETHOD SEARCHMENU DESCRIPTION "METHOD SEARCHMENU" // Chama a query no banco e retorna os dados do Func.
ENDWSSERVICE

// Chama a query no banco e retorna os dados do Func.
WSMETHOD SEARCHMENU WSRECEIVE sFilial, lGSP WSSEND oOut WSSERVICE WSSEARCHMENU
	fSearchMenu(xFilial("AI8", Self:sFilial), Self:lGSP, @SELF:oOut)
RETURN .T.

// Função que retorna todos os menus pai
Function fSearchMenu(sFilial, lGSP, oRet)
	Local cQuery    := ""
	Local sPortal	:= IIf(lGSP, "000011", "000006")
	Local nReg 		:= 1
	
	// Abre conexão com o banco
	cQuery := GetNextAlias()
	
	// Monta a Query
	BEGINSQL ALIAS cQuery
		SELECT  
			AI8_ROTINA 
		FROM
			%table:AI8% AI8 
		WHERE 
			AI8.AI8_FILIAL = %exp:sFilial% AND 
			AI8.AI8_PORTAL = %exp:sPortal% AND 
			AI8.AI8_ROTINA != ''
	ENDSQL
	
	oRet:aRotinas := {}
	
	// Enquanto encontrar registros alimenta o objeto de retorno 
	While (cQuery)->( !Eof())
		aadd(oRet:aRotinas,WsClassNew('CAI8'))
        oRet:aRotinas[nReg]:sRotinas := ALLTRIM((cQuery)->AI8_ROTINA)
        nReg++
		(cQuery)->(dbSkip())
	EndDo
	
	// Fecha a conexão
	(cQuery)->(DbCloseArea())
Return oRet