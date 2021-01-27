#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://172.16.102.186:8081/wshlcloud/WSPF04.apw?WSDL
Gerado em        12/06/17 16:17:21
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _VRLPNUM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSPF04
------------------------------------------------------------------------------- */

WSCLIENT WSWSPF04

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD PF4ATULIC
	WSMETHOD PF4ATUTOTVSID
	WSMETHOD PF4CHKCLI
	WSMETHOD PF4CHKCLINOVO
	WSMETHOD PF4CHKCLIVINC
	WSMETHOD PF4CHKCNPJ
	WSMETHOD PF4CHKCTRCLI
	WSMETHOD PF4CHKHD
	WSMETHOD PF4CLICACHE
	WSMETHOD PF4DELAGENDA
	WSMETHOD PF4EMEAGENDA
	WSMETHOD PF4GERCACHE
	WSMETHOD PF4GETIDMACRO
	WSMETHOD PF4GETMSG
	WSMETHOD PF4GETPARTNUMB
	WSMETHOD PF4GETTOTVSID
	WSMETHOD PF4IIGETCNPJS
	WSMETHOD PF4IIGETMODUL
	WSMETHOD PF4IIGETPARTN
	WSMETHOD PF4IIGETPRODU
	WSMETHOD PF4NEWINSTALL
	WSMETHOD PF4READMSG
	WSMETHOD PF4RETCNPJID
	WSMETHOD PF4RETCODINSTAL
	WSMETHOD PF4RETCONTRATO
	WSMETHOD PF4RETLICENCAS
	WSMETHOD PF4RETPROD
	WSMETHOD PF4RETSEGMENTO
	WSMETHOD PF4REVOGA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSPARAMATUDISTRIBUICAO   AS WSPF04_STRUPARAMATUDISTRIBUICAO
	WSDATA   cCUSUARIO                 AS string
	WSDATA   oWSPF4ATULICRESULT        AS WSPF04_STRURETATUDISTRIBUICAO
	WSDATA   cCCDCLI                   AS string
	WSDATA   cCLJCLI                   AS string
	WSDATA   cLS_UUID                  AS string
	WSDATA   cCCAMPOLS                 AS string
	WSDATA   cCCONTEUDO                AS string
	WSDATA   oWSPF4ATUTOTVSIDRESULT    AS WSPF04_STRURETATUTOTVSID
	WSDATA   cPF4CHKCLIRESULT          AS string
	WSDATA   lPF4CHKCLINOVORESULT      AS boolean
	WSDATA   oWSPF4CHKCLIVINCRESULT    AS WSPF04_STRURETMSGIDIOMA
	WSDATA   cCCNPJ                    AS string
	WSDATA   oWSPF4CHKCNPJRESULT       AS WSPF04_STRURETCHKCNPJ
	WSDATA   lPF4CHKCTRCLIRESULT       AS boolean
	WSDATA   oWSPF4CHKHDRESULT         AS WSPF04_STRURETMSGIDIOMA
	WSDATA   cPF4CLICACHERESULT        AS string
	WSDATA   cCANALISTA                AS string
	WSDATA   oWSPF4DELAGENDARESULT     AS WSPF04_STRURETTRUEFALSEMSG
	WSDATA   oWSDADOSAGENDA            AS WSPF04_STRUGETDADOSAGENDA
	WSDATA   oWSPF4EMEAGENDARESULT     AS WSPF04_STRURETTRUEFALSEMSG
	WSDATA   cPF4GERCACHERESULT        AS string
	WSDATA   oWSPF4GETIDMACRORESULT    AS WSPF04_ARRAYOFSTRURETGETIDMACRO
	WSDATA   cCTPMSG                   AS string
	WSDATA   cCFLAGMSG                 AS string
	WSDATA   cCDTINIMSG                AS string
	WSDATA   cCDTFIMMSG                AS string
	WSDATA   oWSPF4GETMSGRESULT        AS WSPF04_ARRAYOFSTRURETMENSAGEM
	WSDATA   cCPARTNUMBE               AS string
	WSDATA   oWSPF4GETPARTNUMBRESULT   AS WSPF04_ARRAYOFSTRUGETPARTNUMB
	WSDATA   oWSPF4GETTOTVSIDRESULT    AS WSPF04_ARRAYOFSTRURETGETTOTVSID
	WSDATA   cCANO                     AS string
	WSDATA   cCMES                     AS string
	WSDATA   oWSPF4IIGETCNPJSRESULT    AS WSPF04_STRUPF4IIGETCNPJS
	WSDATA   oWSPF4IIGETMODULRESULT    AS WSPF04_STRUPF4IIGETMODUL
	WSDATA   oWSPF4IIGETPARTNRESULT    AS WSPF04_STRUPF4IIGETPARTN
	WSDATA   oWSPF4IIGETPRODURESULT    AS WSPF04_STRUPF4IIGETPRODU
	WSDATA   cCEULA                    AS string
	WSDATA   cCCDTEC                   AS string
	WSDATA   cPF4NEWINSTALLRESULT      AS string
	WSDATA   cCCDMSG                   AS string
	WSDATA   cCUSERMSG                 AS string
	WSDATA   cPF4READMSGRESULT         AS string
	WSDATA   oWSPF4RETCNPJIDRESULT     AS WSPF04_ARRAYOFSTRURETCNPJID
	WSDATA   lLNEWINSTAL               AS boolean
	WSDATA   oWSPF4RETCODINSTALRESULT  AS WSPF04_STRURETPADRAO
	WSDATA   oWSPF4RETCONTRATORESULT   AS WSPF04_ARRAYOFSTRURETCONTRATO
	WSDATA   cCCDINST                  AS string
	WSDATA   oWSPF4RETLICENCASRESULT   AS WSPF04_ARRAYOFSTRURETLICENCAS
	WSDATA   cCCDPRDDE                 AS string
	WSDATA   cCCDPRDATE                AS string
	WSDATA   oWSPF4RETPRODRESULT       AS WSPF04_ARRAYOFSTRURETCODPRO
	WSDATA   oWSPF4RETSEGMENTORESULT   AS WSPF04_STRURETSEGMENTO
	WSDATA   cCCONTATO                 AS string
	WSDATA   lPF4REVOGARESULT          AS boolean

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSTRUPARAMATUDISTRIBUICAO AS WSPF04_STRUPARAMATUDISTRIBUICAO
	WSDATA   oWSSTRUGETDADOSAGENDA     AS WSPF04_STRUGETDADOSAGENDA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSPF04
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20171123 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSPF04
	::oWSPARAMATUDISTRIBUICAO := WSPF04_STRUPARAMATUDISTRIBUICAO():New()
	::oWSPF4ATULICRESULT := WSPF04_STRURETATUDISTRIBUICAO():New()
	::oWSPF4ATUTOTVSIDRESULT := WSPF04_STRURETATUTOTVSID():New()
	::oWSPF4CHKCLIVINCRESULT := WSPF04_STRURETMSGIDIOMA():New()
	::oWSPF4CHKCNPJRESULT := WSPF04_STRURETCHKCNPJ():New()
	::oWSPF4CHKHDRESULT  := WSPF04_STRURETMSGIDIOMA():New()
	::oWSPF4DELAGENDARESULT := WSPF04_STRURETTRUEFALSEMSG():New()
	::oWSDADOSAGENDA     := WSPF04_STRUGETDADOSAGENDA():New()
	::oWSPF4EMEAGENDARESULT := WSPF04_STRURETTRUEFALSEMSG():New()
	::oWSPF4GETIDMACRORESULT := WSPF04_ARRAYOFSTRURETGETIDMACRO():New()
	::oWSPF4GETMSGRESULT := WSPF04_ARRAYOFSTRURETMENSAGEM():New()
	::oWSPF4GETPARTNUMBRESULT := WSPF04_ARRAYOFSTRUGETPARTNUMB():New()
	::oWSPF4GETTOTVSIDRESULT := WSPF04_ARRAYOFSTRURETGETTOTVSID():New()
	::oWSPF4IIGETCNPJSRESULT := WSPF04_STRUPF4IIGETCNPJS():New()
	::oWSPF4IIGETMODULRESULT := WSPF04_STRUPF4IIGETMODUL():New()
	::oWSPF4IIGETPARTNRESULT := WSPF04_STRUPF4IIGETPARTN():New()
	::oWSPF4IIGETPRODURESULT := WSPF04_STRUPF4IIGETPRODU():New()
	::oWSPF4RETCNPJIDRESULT := WSPF04_ARRAYOFSTRURETCNPJID():New()
	::oWSPF4RETCODINSTALRESULT := WSPF04_STRURETPADRAO():New()
	::oWSPF4RETCONTRATORESULT := WSPF04_ARRAYOFSTRURETCONTRATO():New()
	::oWSPF4RETLICENCASRESULT := WSPF04_ARRAYOFSTRURETLICENCAS():New()
	::oWSPF4RETPRODRESULT := WSPF04_ARRAYOFSTRURETCODPRO():New()
	::oWSPF4RETSEGMENTORESULT := WSPF04_STRURETSEGMENTO():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSTRUPARAMATUDISTRIBUICAO := ::oWSPARAMATUDISTRIBUICAO
	::oWSSTRUGETDADOSAGENDA := ::oWSDADOSAGENDA
Return

WSMETHOD RESET WSCLIENT WSWSPF04
	::oWSPARAMATUDISTRIBUICAO := NIL 
	::cCUSUARIO          := NIL 
	::oWSPF4ATULICRESULT := NIL 
	::cCCDCLI            := NIL 
	::cCLJCLI            := NIL 
	::cLS_UUID           := NIL 
	::cCCAMPOLS          := NIL 
	::cCCONTEUDO         := NIL 
	::oWSPF4ATUTOTVSIDRESULT := NIL 
	::cPF4CHKCLIRESULT   := NIL 
	::lPF4CHKCLINOVORESULT := NIL 
	::oWSPF4CHKCLIVINCRESULT := NIL 
	::cCCNPJ             := NIL 
	::oWSPF4CHKCNPJRESULT := NIL 
	::lPF4CHKCTRCLIRESULT := NIL 
	::oWSPF4CHKHDRESULT  := NIL 
	::cPF4CLICACHERESULT := NIL 
	::cCANALISTA         := NIL 
	::oWSPF4DELAGENDARESULT := NIL 
	::oWSDADOSAGENDA     := NIL 
	::oWSPF4EMEAGENDARESULT := NIL 
	::cPF4GERCACHERESULT := NIL 
	::oWSPF4GETIDMACRORESULT := NIL 
	::cCTPMSG            := NIL 
	::cCFLAGMSG          := NIL 
	::cCDTINIMSG         := NIL 
	::cCDTFIMMSG         := NIL 
	::oWSPF4GETMSGRESULT := NIL 
	::cCPARTNUMBE        := NIL 
	::oWSPF4GETPARTNUMBRESULT := NIL 
	::oWSPF4GETTOTVSIDRESULT := NIL 
	::cCANO              := NIL 
	::cCMES              := NIL 
	::oWSPF4IIGETCNPJSRESULT := NIL 
	::oWSPF4IIGETMODULRESULT := NIL 
	::oWSPF4IIGETPARTNRESULT := NIL 
	::oWSPF4IIGETPRODURESULT := NIL 
	::cCEULA             := NIL 
	::cCCDTEC            := NIL 
	::cPF4NEWINSTALLRESULT := NIL 
	::cCCDMSG            := NIL 
	::cCUSERMSG          := NIL 
	::cPF4READMSGRESULT  := NIL 
	::oWSPF4RETCNPJIDRESULT := NIL 
	::lLNEWINSTAL        := NIL 
	::oWSPF4RETCODINSTALRESULT := NIL 
	::oWSPF4RETCONTRATORESULT := NIL 
	::cCCDINST           := NIL 
	::oWSPF4RETLICENCASRESULT := NIL 
	::cCCDPRDDE          := NIL 
	::cCCDPRDATE         := NIL 
	::oWSPF4RETPRODRESULT := NIL 
	::oWSPF4RETSEGMENTORESULT := NIL 
	::cCCONTATO          := NIL 
	::lPF4REVOGARESULT   := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSTRUPARAMATUDISTRIBUICAO := NIL
	::oWSSTRUGETDADOSAGENDA := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSPF04
Local oClone := WSWSPF04():New()
	oClone:_URL          := ::_URL 
	oClone:oWSPARAMATUDISTRIBUICAO :=  IIF(::oWSPARAMATUDISTRIBUICAO = NIL , NIL ,::oWSPARAMATUDISTRIBUICAO:Clone() )
	oClone:cCUSUARIO     := ::cCUSUARIO
	oClone:oWSPF4ATULICRESULT :=  IIF(::oWSPF4ATULICRESULT = NIL , NIL ,::oWSPF4ATULICRESULT:Clone() )
	oClone:cCCDCLI       := ::cCCDCLI
	oClone:cCLJCLI       := ::cCLJCLI
	oClone:cLS_UUID      := ::cLS_UUID
	oClone:cCCAMPOLS     := ::cCCAMPOLS
	oClone:cCCONTEUDO    := ::cCCONTEUDO
	oClone:oWSPF4ATUTOTVSIDRESULT :=  IIF(::oWSPF4ATUTOTVSIDRESULT = NIL , NIL ,::oWSPF4ATUTOTVSIDRESULT:Clone() )
	oClone:cPF4CHKCLIRESULT := ::cPF4CHKCLIRESULT
	oClone:lPF4CHKCLINOVORESULT := ::lPF4CHKCLINOVORESULT
	oClone:oWSPF4CHKCLIVINCRESULT :=  IIF(::oWSPF4CHKCLIVINCRESULT = NIL , NIL ,::oWSPF4CHKCLIVINCRESULT:Clone() )
	oClone:cCCNPJ        := ::cCCNPJ
	oClone:oWSPF4CHKCNPJRESULT :=  IIF(::oWSPF4CHKCNPJRESULT = NIL , NIL ,::oWSPF4CHKCNPJRESULT:Clone() )
	oClone:lPF4CHKCTRCLIRESULT := ::lPF4CHKCTRCLIRESULT
	oClone:oWSPF4CHKHDRESULT :=  IIF(::oWSPF4CHKHDRESULT = NIL , NIL ,::oWSPF4CHKHDRESULT:Clone() )
	oClone:cPF4CLICACHERESULT := ::cPF4CLICACHERESULT
	oClone:cCANALISTA    := ::cCANALISTA
	oClone:oWSPF4DELAGENDARESULT :=  IIF(::oWSPF4DELAGENDARESULT = NIL , NIL ,::oWSPF4DELAGENDARESULT:Clone() )
	oClone:oWSDADOSAGENDA :=  IIF(::oWSDADOSAGENDA = NIL , NIL ,::oWSDADOSAGENDA:Clone() )
	oClone:oWSPF4EMEAGENDARESULT :=  IIF(::oWSPF4EMEAGENDARESULT = NIL , NIL ,::oWSPF4EMEAGENDARESULT:Clone() )
	oClone:cPF4GERCACHERESULT := ::cPF4GERCACHERESULT
	oClone:oWSPF4GETIDMACRORESULT :=  IIF(::oWSPF4GETIDMACRORESULT = NIL , NIL ,::oWSPF4GETIDMACRORESULT:Clone() )
	oClone:cCTPMSG       := ::cCTPMSG
	oClone:cCFLAGMSG     := ::cCFLAGMSG
	oClone:cCDTINIMSG    := ::cCDTINIMSG
	oClone:cCDTFIMMSG    := ::cCDTFIMMSG
	oClone:oWSPF4GETMSGRESULT :=  IIF(::oWSPF4GETMSGRESULT = NIL , NIL ,::oWSPF4GETMSGRESULT:Clone() )
	oClone:cCPARTNUMBE   := ::cCPARTNUMBE
	oClone:oWSPF4GETPARTNUMBRESULT :=  IIF(::oWSPF4GETPARTNUMBRESULT = NIL , NIL ,::oWSPF4GETPARTNUMBRESULT:Clone() )
	oClone:oWSPF4GETTOTVSIDRESULT :=  IIF(::oWSPF4GETTOTVSIDRESULT = NIL , NIL ,::oWSPF4GETTOTVSIDRESULT:Clone() )
	oClone:cCANO         := ::cCANO
	oClone:cCMES         := ::cCMES
	oClone:oWSPF4IIGETCNPJSRESULT :=  IIF(::oWSPF4IIGETCNPJSRESULT = NIL , NIL ,::oWSPF4IIGETCNPJSRESULT:Clone() )
	oClone:oWSPF4IIGETMODULRESULT :=  IIF(::oWSPF4IIGETMODULRESULT = NIL , NIL ,::oWSPF4IIGETMODULRESULT:Clone() )
	oClone:oWSPF4IIGETPARTNRESULT :=  IIF(::oWSPF4IIGETPARTNRESULT = NIL , NIL ,::oWSPF4IIGETPARTNRESULT:Clone() )
	oClone:oWSPF4IIGETPRODURESULT :=  IIF(::oWSPF4IIGETPRODURESULT = NIL , NIL ,::oWSPF4IIGETPRODURESULT:Clone() )
	oClone:cCEULA        := ::cCEULA
	oClone:cCCDTEC       := ::cCCDTEC
	oClone:cPF4NEWINSTALLRESULT := ::cPF4NEWINSTALLRESULT
	oClone:cCCDMSG       := ::cCCDMSG
	oClone:cCUSERMSG     := ::cCUSERMSG
	oClone:cPF4READMSGRESULT := ::cPF4READMSGRESULT
	oClone:oWSPF4RETCNPJIDRESULT :=  IIF(::oWSPF4RETCNPJIDRESULT = NIL , NIL ,::oWSPF4RETCNPJIDRESULT:Clone() )
	oClone:lLNEWINSTAL   := ::lLNEWINSTAL
	oClone:oWSPF4RETCODINSTALRESULT :=  IIF(::oWSPF4RETCODINSTALRESULT = NIL , NIL ,::oWSPF4RETCODINSTALRESULT:Clone() )
	oClone:oWSPF4RETCONTRATORESULT :=  IIF(::oWSPF4RETCONTRATORESULT = NIL , NIL ,::oWSPF4RETCONTRATORESULT:Clone() )
	oClone:cCCDINST      := ::cCCDINST
	oClone:oWSPF4RETLICENCASRESULT :=  IIF(::oWSPF4RETLICENCASRESULT = NIL , NIL ,::oWSPF4RETLICENCASRESULT:Clone() )
	oClone:cCCDPRDDE     := ::cCCDPRDDE
	oClone:cCCDPRDATE    := ::cCCDPRDATE
	oClone:oWSPF4RETPRODRESULT :=  IIF(::oWSPF4RETPRODRESULT = NIL , NIL ,::oWSPF4RETPRODRESULT:Clone() )
	oClone:oWSPF4RETSEGMENTORESULT :=  IIF(::oWSPF4RETSEGMENTORESULT = NIL , NIL ,::oWSPF4RETSEGMENTORESULT:Clone() )
	oClone:cCCONTATO     := ::cCCONTATO
	oClone:lPF4REVOGARESULT := ::lPF4REVOGARESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSTRUPARAMATUDISTRIBUICAO := oClone:oWSPARAMATUDISTRIBUICAO
	oClone:oWSSTRUGETDADOSAGENDA := oClone:oWSDADOSAGENDA
Return oClone

// WSDL Method PF4ATULIC of Service WSWSPF04

WSMETHOD PF4ATULIC WSSEND oWSPARAMATUDISTRIBUICAO,cCUSUARIO WSRECEIVE oWSPF4ATULICRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4ATULIC xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("PARAMATUDISTRIBUICAO", ::oWSPARAMATUDISTRIBUICAO, oWSPARAMATUDISTRIBUICAO , "STRUPARAMATUDISTRIBUICAO", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CUSUARIO", ::cCUSUARIO, cCUSUARIO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4ATULIC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4ATULIC",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4ATULICRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4ATULICRESPONSE:_PF4ATULICRESULT","STRURETATUDISTRIBUICAO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4ATUTOTVSID of Service WSWSPF04

WSMETHOD PF4ATUTOTVSID WSSEND cCCDCLI,cCLJCLI,cLS_UUID,cCCAMPOLS,cCCONTEUDO,cCUSUARIO WSRECEIVE oWSPF4ATUTOTVSIDRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4ATUTOTVSID xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LS_UUID", ::cLS_UUID, cLS_UUID , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCAMPOLS", ::cCCAMPOLS, cCCAMPOLS , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCONTEUDO", ::cCCONTEUDO, cCCONTEUDO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CUSUARIO", ::cCUSUARIO, cCUSUARIO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4ATUTOTVSID>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4ATUTOTVSID",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4ATUTOTVSIDRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4ATUTOTVSIDRESPONSE:_PF4ATUTOTVSIDRESULT","STRURETATUTOTVSID",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4CHKCLI of Service WSWSPF04

WSMETHOD PF4CHKCLI WSSEND cCCDCLI,cCLJCLI WSRECEIVE cPF4CHKCLIRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4CHKCLI xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4CHKCLI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4CHKCLI",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::cPF4CHKCLIRESULT   :=  WSAdvValue( oXmlRet,"_PF4CHKCLIRESPONSE:_PF4CHKCLIRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4CHKCLINOVO of Service WSWSPF04

WSMETHOD PF4CHKCLINOVO WSSEND cCCDCLI,cCLJCLI WSRECEIVE lPF4CHKCLINOVORESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4CHKCLINOVO xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4CHKCLINOVO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4CHKCLINOVO",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::lPF4CHKCLINOVORESULT :=  WSAdvValue( oXmlRet,"_PF4CHKCLINOVORESPONSE:_PF4CHKCLINOVORESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4CHKCLIVINC of Service WSWSPF04

WSMETHOD PF4CHKCLIVINC WSSEND cCCDCLI,cCLJCLI WSRECEIVE oWSPF4CHKCLIVINCRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4CHKCLIVINC xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4CHKCLIVINC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4CHKCLIVINC",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4CHKCLIVINCRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4CHKCLIVINCRESPONSE:_PF4CHKCLIVINCRESULT","STRURETMSGIDIOMA",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4CHKCNPJ of Service WSWSPF04

WSMETHOD PF4CHKCNPJ WSSEND cCCNPJ WSRECEIVE oWSPF4CHKCNPJRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4CHKCNPJ xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCNPJ", ::cCCNPJ, cCCNPJ , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4CHKCNPJ>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4CHKCNPJ",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4CHKCNPJRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4CHKCNPJRESPONSE:_PF4CHKCNPJRESULT","STRURETCHKCNPJ",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4CHKCTRCLI of Service WSWSPF04

WSMETHOD PF4CHKCTRCLI WSSEND cCCDCLI,cCLJCLI WSRECEIVE lPF4CHKCTRCLIRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4CHKCTRCLI xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4CHKCTRCLI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4CHKCTRCLI",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::lPF4CHKCTRCLIRESULT :=  WSAdvValue( oXmlRet,"_PF4CHKCTRCLIRESPONSE:_PF4CHKCTRCLIRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4CHKHD of Service WSWSPF04

WSMETHOD PF4CHKHD WSSEND cCCDCLI,cCLJCLI WSRECEIVE oWSPF4CHKHDRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4CHKHD xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4CHKHD>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4CHKHD",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4CHKHDRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4CHKHDRESPONSE:_PF4CHKHDRESULT","STRURETMSGIDIOMA",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4CLICACHE of Service WSWSPF04

WSMETHOD PF4CLICACHE WSSEND cCCDCLI,cCLJCLI WSRECEIVE cPF4CLICACHERESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4CLICACHE xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4CLICACHE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4CLICACHE",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::cPF4CLICACHERESULT :=  WSAdvValue( oXmlRet,"_PF4CLICACHERESPONSE:_PF4CLICACHERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4DELAGENDA of Service WSWSPF04

WSMETHOD PF4DELAGENDA WSSEND cCCDCLI,cCLJCLI,cCANALISTA WSRECEIVE oWSPF4DELAGENDARESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4DELAGENDA xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CANALISTA", ::cCANALISTA, cCANALISTA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4DELAGENDA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4DELAGENDA",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4DELAGENDARESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4DELAGENDARESPONSE:_PF4DELAGENDARESULT","STRURETTRUEFALSEMSG",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4EMEAGENDA of Service WSWSPF04

WSMETHOD PF4EMEAGENDA WSSEND oWSDADOSAGENDA WSRECEIVE oWSPF4EMEAGENDARESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4EMEAGENDA xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("DADOSAGENDA", ::oWSDADOSAGENDA, oWSDADOSAGENDA , "STRUGETDADOSAGENDA", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4EMEAGENDA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4EMEAGENDA",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4EMEAGENDARESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4EMEAGENDARESPONSE:_PF4EMEAGENDARESULT","STRURETTRUEFALSEMSG",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4GERCACHE of Service WSWSPF04

WSMETHOD PF4GERCACHE WSSEND cCCDCLI,cCLJCLI WSRECEIVE cPF4GERCACHERESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4GERCACHE xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4GERCACHE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4GERCACHE",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::cPF4GERCACHERESULT :=  WSAdvValue( oXmlRet,"_PF4GERCACHERESPONSE:_PF4GERCACHERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4GETIDMACRO of Service WSWSPF04

WSMETHOD PF4GETIDMACRO WSSEND cCCDCLI,cCLJCLI WSRECEIVE oWSPF4GETIDMACRORESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4GETIDMACRO xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4GETIDMACRO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4GETIDMACRO",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4GETIDMACRORESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4GETIDMACRORESPONSE:_PF4GETIDMACRORESULT","ARRAYOFSTRURETGETIDMACRO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4GETMSG of Service WSWSPF04

WSMETHOD PF4GETMSG WSSEND cCCDCLI,cCLJCLI,cCTPMSG,cCFLAGMSG,cCDTINIMSG,cCDTFIMMSG WSRECEIVE oWSPF4GETMSGRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4GETMSG xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CTPMSG", ::cCTPMSG, cCTPMSG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CFLAGMSG", ::cCFLAGMSG, cCFLAGMSG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CDTINIMSG", ::cCDTINIMSG, cCDTINIMSG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CDTFIMMSG", ::cCDTFIMMSG, cCDTFIMMSG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4GETMSG>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4GETMSG",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4GETMSGRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4GETMSGRESPONSE:_PF4GETMSGRESULT","ARRAYOFSTRURETMENSAGEM",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4GETPARTNUMB of Service WSWSPF04

WSMETHOD PF4GETPARTNUMB WSSEND cCPARTNUMBE WSRECEIVE oWSPF4GETPARTNUMBRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4GETPARTNUMB xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CPARTNUMBE", ::cCPARTNUMBE, cCPARTNUMBE , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4GETPARTNUMB>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4GETPARTNUMB",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4GETPARTNUMBRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4GETPARTNUMBRESPONSE:_PF4GETPARTNUMBRESULT","ARRAYOFSTRUGETPARTNUMB",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4GETTOTVSID of Service WSWSPF04

WSMETHOD PF4GETTOTVSID WSSEND cCCDCLI,cCLJCLI WSRECEIVE oWSPF4GETTOTVSIDRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4GETTOTVSID xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4GETTOTVSID>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4GETTOTVSID",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4GETTOTVSIDRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4GETTOTVSIDRESPONSE:_PF4GETTOTVSIDRESULT","ARRAYOFSTRURETGETTOTVSID",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4IIGETCNPJS of Service WSWSPF04

WSMETHOD PF4IIGETCNPJS WSSEND cCCDCLI,cCLJCLI,cCANO,cCMES WSRECEIVE oWSPF4IIGETCNPJSRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4IIGETCNPJS xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CANO", ::cCANO, cCANO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CMES", ::cCMES, cCMES , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4IIGETCNPJS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4IIGETCNPJS",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4IIGETCNPJSRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4IIGETCNPJSRESPONSE:_PF4IIGETCNPJSRESULT","STRUPF4IIGETCNPJS",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4IIGETMODUL of Service WSWSPF04

WSMETHOD PF4IIGETMODUL WSSEND cCCDCLI,cCLJCLI,cCANO,cCMES WSRECEIVE oWSPF4IIGETMODULRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4IIGETMODUL xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CANO", ::cCANO, cCANO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CMES", ::cCMES, cCMES , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4IIGETMODUL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4IIGETMODUL",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4IIGETMODULRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4IIGETMODULRESPONSE:_PF4IIGETMODULRESULT","STRUPF4IIGETMODUL",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4IIGETPARTN of Service WSWSPF04

WSMETHOD PF4IIGETPARTN WSSEND cCCDCLI,cCLJCLI,cCANO,cCMES WSRECEIVE oWSPF4IIGETPARTNRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4IIGETPARTN xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CANO", ::cCANO, cCANO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CMES", ::cCMES, cCMES , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4IIGETPARTN>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4IIGETPARTN",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4IIGETPARTNRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4IIGETPARTNRESPONSE:_PF4IIGETPARTNRESULT","STRUPF4IIGETPARTN",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4IIGETPRODU of Service WSWSPF04

WSMETHOD PF4IIGETPRODU WSSEND cCCDCLI,cCLJCLI,cCANO,cCMES WSRECEIVE oWSPF4IIGETPRODURESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4IIGETPRODU xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CANO", ::cCANO, cCANO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CMES", ::cCMES, cCMES , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4IIGETPRODU>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4IIGETPRODU",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4IIGETPRODURESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4IIGETPRODURESPONSE:_PF4IIGETPRODURESULT","STRUPF4IIGETPRODU",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4NEWINSTALL of Service WSWSPF04

WSMETHOD PF4NEWINSTALL WSSEND cCCDCLI,cCLJCLI,cCEULA,cCCDTEC,cCUSUARIO WSRECEIVE cPF4NEWINSTALLRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4NEWINSTALL xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CEULA", ::cCEULA, cCEULA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCDTEC", ::cCCDTEC, cCCDTEC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CUSUARIO", ::cCUSUARIO, cCUSUARIO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4NEWINSTALL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4NEWINSTALL",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::cPF4NEWINSTALLRESULT :=  WSAdvValue( oXmlRet,"_PF4NEWINSTALLRESPONSE:_PF4NEWINSTALLRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4READMSG of Service WSWSPF04

WSMETHOD PF4READMSG WSSEND cCCDMSG,cCUSERMSG WSRECEIVE cPF4READMSGRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4READMSG xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDMSG", ::cCCDMSG, cCCDMSG , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CUSERMSG", ::cCUSERMSG, cCUSERMSG , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4READMSG>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4READMSG",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::cPF4READMSGRESULT  :=  WSAdvValue( oXmlRet,"_PF4READMSGRESPONSE:_PF4READMSGRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4RETCNPJID of Service WSWSPF04

WSMETHOD PF4RETCNPJID WSSEND cCCDCLI,cCLJCLI WSRECEIVE oWSPF4RETCNPJIDRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4RETCNPJID xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4RETCNPJID>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4RETCNPJID",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4RETCNPJIDRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4RETCNPJIDRESPONSE:_PF4RETCNPJIDRESULT","ARRAYOFSTRURETCNPJID",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4RETCODINSTAL of Service WSWSPF04

WSMETHOD PF4RETCODINSTAL WSSEND cCCDCLI,cCLJCLI,lLNEWINSTAL,cCCDTEC,cCUSUARIO WSRECEIVE oWSPF4RETCODINSTALRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4RETCODINSTAL xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LNEWINSTAL", ::lLNEWINSTAL, lLNEWINSTAL , "boolean", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCDTEC", ::cCCDTEC, cCCDTEC , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CUSUARIO", ::cCUSUARIO, cCUSUARIO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4RETCODINSTAL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4RETCODINSTAL",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4RETCODINSTALRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4RETCODINSTALRESPONSE:_PF4RETCODINSTALRESULT","STRURETPADRAO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4RETCONTRATO of Service WSWSPF04

WSMETHOD PF4RETCONTRATO WSSEND cCCDCLI,cCLJCLI WSRECEIVE oWSPF4RETCONTRATORESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4RETCONTRATO xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4RETCONTRATO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4RETCONTRATO",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4RETCONTRATORESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4RETCONTRATORESPONSE:_PF4RETCONTRATORESULT","ARRAYOFSTRURETCONTRATO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4RETLICENCAS of Service WSWSPF04

WSMETHOD PF4RETLICENCAS WSSEND cCCDCLI,cCLJCLI,cCCDINST,cCUSUARIO WSRECEIVE oWSPF4RETLICENCASRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4RETLICENCAS xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCDINST", ::cCCDINST, cCCDINST , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CUSUARIO", ::cCUSUARIO, cCUSUARIO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4RETLICENCAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4RETLICENCAS",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4RETLICENCASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4RETLICENCASRESPONSE:_PF4RETLICENCASRESULT","ARRAYOFSTRURETLICENCAS",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4RETPROD of Service WSWSPF04

WSMETHOD PF4RETPROD WSSEND cCCDPRDDE,cCCDPRDATE WSRECEIVE oWSPF4RETPRODRESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4RETPROD xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDPRDDE", ::cCCDPRDDE, cCCDPRDDE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCDPRDATE", ::cCCDPRDATE, cCCDPRDATE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4RETPROD>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4RETPROD",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4RETPRODRESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4RETPRODRESPONSE:_PF4RETPRODRESULT","ARRAYOFSTRURETCODPRO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4RETSEGMENTO of Service WSWSPF04

WSMETHOD PF4RETSEGMENTO WSSEND cCCDCLI,cCLJCLI WSRECEIVE oWSPF4RETSEGMENTORESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4RETSEGMENTO xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4RETSEGMENTO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4RETSEGMENTO",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::oWSPF4RETSEGMENTORESULT:SoapRecv( WSAdvValue( oXmlRet,"_PF4RETSEGMENTORESPONSE:_PF4RETSEGMENTORESULT","STRURETSEGMENTO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method PF4REVOGA of Service WSWSPF04

WSMETHOD PF4REVOGA WSSEND cCCDCLI,cCLJCLI,cCEULA,cCCONTATO WSRECEIVE lPF4REVOGARESULT WSCLIENT WSWSPF04
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PF4REVOGA xmlns="http://www.totvs.com">'
cSoap += WSSoapValue("CCDCLI", ::cCCDCLI, cCCDCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CLJCLI", ::cCLJCLI, cCLJCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CEULA", ::cCEULA, cCEULA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CCONTATO", ::cCCONTATO, cCCONTATO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</PF4REVOGA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://www.totvs.com/PF4REVOGA",; 
	"DOCUMENT","http://www.totvs.com",,"1.031217",; 
	"http://wshlcloud.totvs.com.br:8081/wshlcloud/WSPF04.apw")

::Init()
::lPF4REVOGARESULT   :=  WSAdvValue( oXmlRet,"_PF4REVOGARESPONSE:_PF4REVOGARESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure STRUPARAMATUDISTRIBUICAO

WSSTRUCT WSPF04_STRUPARAMATUDISTRIBUICAO
	WSDATA   cCLIENTE                  AS string
	WSDATA   oWSINSTALACOES            AS WSPF04_ARRAYOFSTRURETLICENCAS OPTIONAL
	WSDATA   cLOJA                     AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUPARAMATUDISTRIBUICAO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUPARAMATUDISTRIBUICAO
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUPARAMATUDISTRIBUICAO
	Local oClone := WSPF04_STRUPARAMATUDISTRIBUICAO():NEW()
	oClone:cCLIENTE             := ::cCLIENTE
	oClone:oWSINSTALACOES       := IIF(::oWSINSTALACOES = NIL , NIL , ::oWSINSTALACOES:Clone() )
	oClone:cLOJA                := ::cLOJA
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPF04_STRUPARAMATUDISTRIBUICAO
	Local cSoap := ""
	cSoap += WSSoapValue("CLIENTE", ::cCLIENTE, ::cCLIENTE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("INSTALACOES", ::oWSINSTALACOES, ::oWSINSTALACOES , "ARRAYOFSTRURETLICENCAS", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("LOJA", ::cLOJA, ::cLOJA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure STRURETATUDISTRIBUICAO

WSSTRUCT WSPF04_STRURETATUDISTRIBUICAO
	WSDATA   cERRO                     AS string OPTIONAL
	WSDATA   lOK                       AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETATUDISTRIBUICAO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETATUDISTRIBUICAO
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETATUDISTRIBUICAO
	Local oClone := WSPF04_STRURETATUDISTRIBUICAO():NEW()
	oClone:cERRO                := ::cERRO
	oClone:lOK                  := ::lOK
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETATUDISTRIBUICAO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cERRO              :=  WSAdvValue( oResponse,"_ERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lOK                :=  WSAdvValue( oResponse,"_OK","boolean",NIL,"Property lOK as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRURETATUTOTVSID

WSSTRUCT WSPF04_STRURETATUTOTVSID
	WSDATA   cERRO                     AS string OPTIONAL
	WSDATA   lOK                       AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETATUTOTVSID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETATUTOTVSID
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETATUTOTVSID
	Local oClone := WSPF04_STRURETATUTOTVSID():NEW()
	oClone:cERRO                := ::cERRO
	oClone:lOK                  := ::lOK
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETATUTOTVSID
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cERRO              :=  WSAdvValue( oResponse,"_ERRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lOK                :=  WSAdvValue( oResponse,"_OK","boolean",NIL,"Property lOK as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRURETMSGIDIOMA

WSSTRUCT WSPF04_STRURETMSGIDIOMA
	WSDATA   cEN                       AS string OPTIONAL
	WSDATA   cES                       AS string OPTIONAL
	WSDATA   cPT                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETMSGIDIOMA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETMSGIDIOMA
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETMSGIDIOMA
	Local oClone := WSPF04_STRURETMSGIDIOMA():NEW()
	oClone:cEN                  := ::cEN
	oClone:cES                  := ::cES
	oClone:cPT                  := ::cPT
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETMSGIDIOMA
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cEN                :=  WSAdvValue( oResponse,"_EN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cES                :=  WSAdvValue( oResponse,"_ES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPT                :=  WSAdvValue( oResponse,"_PT","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure STRURETCHKCNPJ

WSSTRUCT WSPF04_STRURETCHKCNPJ
	WSDATA   cCLIENTE                  AS string OPTIONAL
	WSDATA   cLOJA                     AS string OPTIONAL
	WSDATA   cMSG                      AS string OPTIONAL
	WSDATA   lOK                       AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETCHKCNPJ
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETCHKCNPJ
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETCHKCNPJ
	Local oClone := WSPF04_STRURETCHKCNPJ():NEW()
	oClone:cCLIENTE             := ::cCLIENTE
	oClone:cLOJA                := ::cLOJA
	oClone:cMSG                 := ::cMSG
	oClone:lOK                  := ::lOK
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETCHKCNPJ
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCLIENTE           :=  WSAdvValue( oResponse,"_CLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLOJA              :=  WSAdvValue( oResponse,"_LOJA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMSG               :=  WSAdvValue( oResponse,"_MSG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lOK                :=  WSAdvValue( oResponse,"_OK","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRURETTRUEFALSEMSG

WSSTRUCT WSPF04_STRURETTRUEFALSEMSG
	WSDATA   c_CMESSAGE                AS string OPTIONAL
	WSDATA   l_LOGICAL                 AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETTRUEFALSEMSG
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETTRUEFALSEMSG
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETTRUEFALSEMSG
	Local oClone := WSPF04_STRURETTRUEFALSEMSG():NEW()
	oClone:c_CMESSAGE           := ::c_CMESSAGE
	oClone:l_LOGICAL            := ::l_LOGICAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETTRUEFALSEMSG
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::c_CMESSAGE         :=  WSAdvValue( oResponse,"__CMESSAGE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::l_LOGICAL          :=  WSAdvValue( oResponse,"__LOGICAL","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRUGETDADOSAGENDA

WSSTRUCT WSPF04_STRUGETDADOSAGENDA
	WSDATA   oWS_ADADOS                AS WSPF04_ARRAYOFSTRUDADOSINST
	WSDATA   cCCLIENTE                 AS string
	WSDATA   cCLOJA                    AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUGETDADOSAGENDA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUGETDADOSAGENDA
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUGETDADOSAGENDA
	Local oClone := WSPF04_STRUGETDADOSAGENDA():NEW()
	oClone:oWS_ADADOS           := IIF(::oWS_ADADOS = NIL , NIL , ::oWS_ADADOS:Clone() )
	oClone:cCCLIENTE            := ::cCCLIENTE
	oClone:cCLOJA               := ::cCLOJA
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPF04_STRUGETDADOSAGENDA
	Local cSoap := ""
	cSoap += WSSoapValue("_ADADOS", ::oWS_ADADOS, ::oWS_ADADOS , "ARRAYOFSTRUDADOSINST", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CCLIENTE", ::cCCLIENTE, ::cCCLIENTE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CLOJA", ::cCLOJA, ::cCLOJA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ARRAYOFSTRURETGETIDMACRO

WSSTRUCT WSPF04_ARRAYOFSTRURETGETIDMACRO
	WSDATA   oWSSTRURETGETIDMACRO      AS WSPF04_STRURETGETIDMACRO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRURETGETIDMACRO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRURETGETIDMACRO
	::oWSSTRURETGETIDMACRO := {} // Array Of  WSPF04_STRURETGETIDMACRO():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRURETGETIDMACRO
	Local oClone := WSPF04_ARRAYOFSTRURETGETIDMACRO():NEW()
	oClone:oWSSTRURETGETIDMACRO := NIL
	If ::oWSSTRURETGETIDMACRO <> NIL 
		oClone:oWSSTRURETGETIDMACRO := {}
		aEval( ::oWSSTRURETGETIDMACRO , { |x| aadd( oClone:oWSSTRURETGETIDMACRO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRURETGETIDMACRO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRURETGETIDMACRO","STRURETGETIDMACRO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRURETGETIDMACRO , WSPF04_STRURETGETIDMACRO():New() )
			::oWSSTRURETGETIDMACRO[len(::oWSSTRURETGETIDMACRO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSTRURETMENSAGEM

WSSTRUCT WSPF04_ARRAYOFSTRURETMENSAGEM
	WSDATA   oWSSTRURETMENSAGEM        AS WSPF04_STRURETMENSAGEM OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRURETMENSAGEM
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRURETMENSAGEM
	::oWSSTRURETMENSAGEM   := {} // Array Of  WSPF04_STRURETMENSAGEM():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRURETMENSAGEM
	Local oClone := WSPF04_ARRAYOFSTRURETMENSAGEM():NEW()
	oClone:oWSSTRURETMENSAGEM := NIL
	If ::oWSSTRURETMENSAGEM <> NIL 
		oClone:oWSSTRURETMENSAGEM := {}
		aEval( ::oWSSTRURETMENSAGEM , { |x| aadd( oClone:oWSSTRURETMENSAGEM , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRURETMENSAGEM
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRURETMENSAGEM","STRURETMENSAGEM",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRURETMENSAGEM , WSPF04_STRURETMENSAGEM():New() )
			::oWSSTRURETMENSAGEM[len(::oWSSTRURETMENSAGEM)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSTRUGETPARTNUMB

WSSTRUCT WSPF04_ARRAYOFSTRUGETPARTNUMB
	WSDATA   oWSSTRUGETPARTNUMB        AS WSPF04_STRUGETPARTNUMB OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRUGETPARTNUMB
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRUGETPARTNUMB
	::oWSSTRUGETPARTNUMB   := {} // Array Of  WSPF04_STRUGETPARTNUMB():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRUGETPARTNUMB
	Local oClone := WSPF04_ARRAYOFSTRUGETPARTNUMB():NEW()
	oClone:oWSSTRUGETPARTNUMB := NIL
	If ::oWSSTRUGETPARTNUMB <> NIL 
		oClone:oWSSTRUGETPARTNUMB := {}
		aEval( ::oWSSTRUGETPARTNUMB , { |x| aadd( oClone:oWSSTRUGETPARTNUMB , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRUGETPARTNUMB
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRUGETPARTNUMB","STRUGETPARTNUMB",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRUGETPARTNUMB , WSPF04_STRUGETPARTNUMB():New() )
			::oWSSTRUGETPARTNUMB[len(::oWSSTRUGETPARTNUMB)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSTRURETGETTOTVSID

WSSTRUCT WSPF04_ARRAYOFSTRURETGETTOTVSID
	WSDATA   oWSSTRURETGETTOTVSID      AS WSPF04_STRURETGETTOTVSID OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRURETGETTOTVSID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRURETGETTOTVSID
	::oWSSTRURETGETTOTVSID := {} // Array Of  WSPF04_STRURETGETTOTVSID():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRURETGETTOTVSID
	Local oClone := WSPF04_ARRAYOFSTRURETGETTOTVSID():NEW()
	oClone:oWSSTRURETGETTOTVSID := NIL
	If ::oWSSTRURETGETTOTVSID <> NIL 
		oClone:oWSSTRURETGETTOTVSID := {}
		aEval( ::oWSSTRURETGETTOTVSID , { |x| aadd( oClone:oWSSTRURETGETTOTVSID , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRURETGETTOTVSID
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRURETGETTOTVSID","STRURETGETTOTVSID",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRURETGETTOTVSID , WSPF04_STRURETGETTOTVSID():New() )
			::oWSSTRURETGETTOTVSID[len(::oWSSTRURETGETTOTVSID)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure STRUPF4IIGETCNPJS

WSSTRUCT WSPF04_STRUPF4IIGETCNPJS
	WSDATA   oWSADADOS                 AS WSPF04_ARRAYOFSDADPF4IIGETCNPJS
	WSDATA   cCMSG                     AS string
	WSDATA   lLRET                     AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUPF4IIGETCNPJS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUPF4IIGETCNPJS
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUPF4IIGETCNPJS
	Local oClone := WSPF04_STRUPF4IIGETCNPJS():NEW()
	oClone:oWSADADOS            := IIF(::oWSADADOS = NIL , NIL , ::oWSADADOS:Clone() )
	oClone:cCMSG                := ::cCMSG
	oClone:lLRET                := ::lLRET
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRUPF4IIGETCNPJS
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ADADOS","ARRAYOFSDADPF4IIGETCNPJS",NIL,"Property oWSADADOS as s0:ARRAYOFSDADPF4IIGETCNPJS on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSADADOS := WSPF04_ARRAYOFSDADPF4IIGETCNPJS():New()
		::oWSADADOS:SoapRecv(oNode1)
	EndIf
	::cCMSG              :=  WSAdvValue( oResponse,"_CMSG","string",NIL,"Property cCMSG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::lLRET              :=  WSAdvValue( oResponse,"_LRET","boolean",NIL,"Property lLRET as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRUPF4IIGETMODUL

WSSTRUCT WSPF04_STRUPF4IIGETMODUL
	WSDATA   oWSADADOS                 AS WSPF04_ARRAYOFSDADPF4IIGETMODUL
	WSDATA   cCMSG                     AS string
	WSDATA   lLRET                     AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUPF4IIGETMODUL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUPF4IIGETMODUL
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUPF4IIGETMODUL
	Local oClone := WSPF04_STRUPF4IIGETMODUL():NEW()
	oClone:oWSADADOS            := IIF(::oWSADADOS = NIL , NIL , ::oWSADADOS:Clone() )
	oClone:cCMSG                := ::cCMSG
	oClone:lLRET                := ::lLRET
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRUPF4IIGETMODUL
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ADADOS","ARRAYOFSDADPF4IIGETMODUL",NIL,"Property oWSADADOS as s0:ARRAYOFSDADPF4IIGETMODUL on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSADADOS := WSPF04_ARRAYOFSDADPF4IIGETMODUL():New()
		::oWSADADOS:SoapRecv(oNode1)
	EndIf
	::cCMSG              :=  WSAdvValue( oResponse,"_CMSG","string",NIL,"Property cCMSG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::lLRET              :=  WSAdvValue( oResponse,"_LRET","boolean",NIL,"Property lLRET as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRUPF4IIGETPARTN

WSSTRUCT WSPF04_STRUPF4IIGETPARTN
	WSDATA   oWSADADOS                 AS WSPF04_ARRAYOFSDADPF4IIGETPARTN
	WSDATA   cCMSG                     AS string
	WSDATA   lLRET                     AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUPF4IIGETPARTN
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUPF4IIGETPARTN
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUPF4IIGETPARTN
	Local oClone := WSPF04_STRUPF4IIGETPARTN():NEW()
	oClone:oWSADADOS            := IIF(::oWSADADOS = NIL , NIL , ::oWSADADOS:Clone() )
	oClone:cCMSG                := ::cCMSG
	oClone:lLRET                := ::lLRET
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRUPF4IIGETPARTN
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ADADOS","ARRAYOFSDADPF4IIGETPARTN",NIL,"Property oWSADADOS as s0:ARRAYOFSDADPF4IIGETPARTN on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSADADOS := WSPF04_ARRAYOFSDADPF4IIGETPARTN():New()
		::oWSADADOS:SoapRecv(oNode1)
	EndIf
	::cCMSG              :=  WSAdvValue( oResponse,"_CMSG","string",NIL,"Property cCMSG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::lLRET              :=  WSAdvValue( oResponse,"_LRET","boolean",NIL,"Property lLRET as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure STRUPF4IIGETPRODU

WSSTRUCT WSPF04_STRUPF4IIGETPRODU
	WSDATA   oWSADADOS                 AS WSPF04_ARRAYOFSDADPF4IIGETPRODU
	WSDATA   cCMSG                     AS string
	WSDATA   lLRET                     AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUPF4IIGETPRODU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUPF4IIGETPRODU
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUPF4IIGETPRODU
	Local oClone := WSPF04_STRUPF4IIGETPRODU():NEW()
	oClone:oWSADADOS            := IIF(::oWSADADOS = NIL , NIL , ::oWSADADOS:Clone() )
	oClone:cCMSG                := ::cCMSG
	oClone:lLRET                := ::lLRET
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRUPF4IIGETPRODU
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ADADOS","ARRAYOFSDADPF4IIGETPRODU",NIL,"Property oWSADADOS as s0:ARRAYOFSDADPF4IIGETPRODU on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSADADOS := WSPF04_ARRAYOFSDADPF4IIGETPRODU():New()
		::oWSADADOS:SoapRecv(oNode1)
	EndIf
	::cCMSG              :=  WSAdvValue( oResponse,"_CMSG","string",NIL,"Property cCMSG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::lLRET              :=  WSAdvValue( oResponse,"_LRET","boolean",NIL,"Property lLRET as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFSTRURETCNPJID

WSSTRUCT WSPF04_ARRAYOFSTRURETCNPJID
	WSDATA   oWSSTRURETCNPJID          AS WSPF04_STRURETCNPJID OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRURETCNPJID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRURETCNPJID
	::oWSSTRURETCNPJID     := {} // Array Of  WSPF04_STRURETCNPJID():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRURETCNPJID
	Local oClone := WSPF04_ARRAYOFSTRURETCNPJID():NEW()
	oClone:oWSSTRURETCNPJID := NIL
	If ::oWSSTRURETCNPJID <> NIL 
		oClone:oWSSTRURETCNPJID := {}
		aEval( ::oWSSTRURETCNPJID , { |x| aadd( oClone:oWSSTRURETCNPJID , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRURETCNPJID
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRURETCNPJID","STRURETCNPJID",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRURETCNPJID , WSPF04_STRURETCNPJID():New() )
			::oWSSTRURETCNPJID[len(::oWSSTRURETCNPJID)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure STRURETPADRAO

WSSTRUCT WSPF04_STRURETPADRAO
	WSDATA   cMSG                      AS string OPTIONAL
	WSDATA   lOK                       AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETPADRAO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETPADRAO
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETPADRAO
	Local oClone := WSPF04_STRURETPADRAO():NEW()
	oClone:cMSG                 := ::cMSG
	oClone:lOK                  := ::lOK
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETPADRAO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cMSG               :=  WSAdvValue( oResponse,"_MSG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lOK                :=  WSAdvValue( oResponse,"_OK","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFSTRURETCONTRATO

WSSTRUCT WSPF04_ARRAYOFSTRURETCONTRATO
	WSDATA   oWSSTRURETCONTRATO        AS WSPF04_STRURETCONTRATO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRURETCONTRATO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRURETCONTRATO
	::oWSSTRURETCONTRATO   := {} // Array Of  WSPF04_STRURETCONTRATO():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRURETCONTRATO
	Local oClone := WSPF04_ARRAYOFSTRURETCONTRATO():NEW()
	oClone:oWSSTRURETCONTRATO := NIL
	If ::oWSSTRURETCONTRATO <> NIL 
		oClone:oWSSTRURETCONTRATO := {}
		aEval( ::oWSSTRURETCONTRATO , { |x| aadd( oClone:oWSSTRURETCONTRATO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRURETCONTRATO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRURETCONTRATO","STRURETCONTRATO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRURETCONTRATO , WSPF04_STRURETCONTRATO():New() )
			::oWSSTRURETCONTRATO[len(::oWSSTRURETCONTRATO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSTRURETLICENCAS

WSSTRUCT WSPF04_ARRAYOFSTRURETLICENCAS
	WSDATA   oWSSTRURETLICENCAS        AS WSPF04_STRURETLICENCAS OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRURETLICENCAS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRURETLICENCAS
	::oWSSTRURETLICENCAS   := {} // Array Of  WSPF04_STRURETLICENCAS():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRURETLICENCAS
	Local oClone := WSPF04_ARRAYOFSTRURETLICENCAS():NEW()
	oClone:oWSSTRURETLICENCAS := NIL
	If ::oWSSTRURETLICENCAS <> NIL 
		oClone:oWSSTRURETLICENCAS := {}
		aEval( ::oWSSTRURETLICENCAS , { |x| aadd( oClone:oWSSTRURETLICENCAS , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPF04_ARRAYOFSTRURETLICENCAS
	Local cSoap := ""
	aEval( ::oWSSTRURETLICENCAS , {|x| cSoap := cSoap  +  WSSoapValue("STRURETLICENCAS", x , x , "STRURETLICENCAS", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRURETLICENCAS
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRURETLICENCAS","STRURETLICENCAS",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRURETLICENCAS , WSPF04_STRURETLICENCAS():New() )
			::oWSSTRURETLICENCAS[len(::oWSSTRURETLICENCAS)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSTRURETCODPRO

WSSTRUCT WSPF04_ARRAYOFSTRURETCODPRO
	WSDATA   oWSSTRURETCODPRO          AS WSPF04_STRURETCODPRO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRURETCODPRO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRURETCODPRO
	::oWSSTRURETCODPRO     := {} // Array Of  WSPF04_STRURETCODPRO():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRURETCODPRO
	Local oClone := WSPF04_ARRAYOFSTRURETCODPRO():NEW()
	oClone:oWSSTRURETCODPRO := NIL
	If ::oWSSTRURETCODPRO <> NIL 
		oClone:oWSSTRURETCODPRO := {}
		aEval( ::oWSSTRURETCODPRO , { |x| aadd( oClone:oWSSTRURETCODPRO , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSTRURETCODPRO
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRURETCODPRO","STRURETCODPRO",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRURETCODPRO , WSPF04_STRURETCODPRO():New() )
			::oWSSTRURETCODPRO[len(::oWSSTRURETCODPRO)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure STRURETSEGMENTO

WSSTRUCT WSPF04_STRURETSEGMENTO
	WSDATA   cCCDSEGMENTO              AS string
	WSDATA   cCCDSUBSEGMENTO           AS string
	WSDATA   cCNMSEGMENTO              AS string
	WSDATA   cCNMSUBSEGMENTO           AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETSEGMENTO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETSEGMENTO
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETSEGMENTO
	Local oClone := WSPF04_STRURETSEGMENTO():NEW()
	oClone:cCCDSEGMENTO         := ::cCCDSEGMENTO
	oClone:cCCDSUBSEGMENTO      := ::cCCDSUBSEGMENTO
	oClone:cCNMSEGMENTO         := ::cCNMSEGMENTO
	oClone:cCNMSUBSEGMENTO      := ::cCNMSUBSEGMENTO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETSEGMENTO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCDSEGMENTO       :=  WSAdvValue( oResponse,"_CCDSEGMENTO","string",NIL,"Property cCCDSEGMENTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCDSUBSEGMENTO    :=  WSAdvValue( oResponse,"_CCDSUBSEGMENTO","string",NIL,"Property cCCDSUBSEGMENTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNMSEGMENTO       :=  WSAdvValue( oResponse,"_CNMSEGMENTO","string",NIL,"Property cCNMSEGMENTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNMSUBSEGMENTO    :=  WSAdvValue( oResponse,"_CNMSUBSEGMENTO","string",NIL,"Property cCNMSUBSEGMENTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFSTRUDADOSINST

WSSTRUCT WSPF04_ARRAYOFSTRUDADOSINST
	WSDATA   oWSSTRUDADOSINST          AS WSPF04_STRUDADOSINST OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSTRUDADOSINST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSTRUDADOSINST
	::oWSSTRUDADOSINST     := {} // Array Of  WSPF04_STRUDADOSINST():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSTRUDADOSINST
	Local oClone := WSPF04_ARRAYOFSTRUDADOSINST():NEW()
	oClone:oWSSTRUDADOSINST := NIL
	If ::oWSSTRUDADOSINST <> NIL 
		oClone:oWSSTRUDADOSINST := {}
		aEval( ::oWSSTRUDADOSINST , { |x| aadd( oClone:oWSSTRUDADOSINST , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPF04_ARRAYOFSTRUDADOSINST
	Local cSoap := ""
	aEval( ::oWSSTRUDADOSINST , {|x| cSoap := cSoap  +  WSSoapValue("STRUDADOSINST", x , x , "STRUDADOSINST", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure STRURETGETIDMACRO

WSSTRUCT WSPF04_STRURETGETIDMACRO
	WSDATA   cLS_UUID                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETGETIDMACRO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETGETIDMACRO
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETGETIDMACRO
	Local oClone := WSPF04_STRURETGETIDMACRO():NEW()
	oClone:cLS_UUID             := ::cLS_UUID
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETGETIDMACRO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cLS_UUID           :=  WSAdvValue( oResponse,"_LS_UUID","string",NIL,"Property cLS_UUID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure STRURETMENSAGEM

WSSTRUCT WSPF04_STRURETMENSAGEM
	WSDATA   cCCODIGO                  AS string
	WSDATA   cCDTLEITURA               AS string
	WSDATA   cCDTMENSAGEM              AS string
	WSDATA   cCFLAG                    AS string
	WSDATA   cCHRLEITURA               AS string
	WSDATA   cCHRMENSAGEM              AS string
	WSDATA   cCTEXTO                   AS string
	WSDATA   cCTIPO                    AS string
	WSDATA   cCUSERLEITURA             AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETMENSAGEM
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETMENSAGEM
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETMENSAGEM
	Local oClone := WSPF04_STRURETMENSAGEM():NEW()
	oClone:cCCODIGO             := ::cCCODIGO
	oClone:cCDTLEITURA          := ::cCDTLEITURA
	oClone:cCDTMENSAGEM         := ::cCDTMENSAGEM
	oClone:cCFLAG               := ::cCFLAG
	oClone:cCHRLEITURA          := ::cCHRLEITURA
	oClone:cCHRMENSAGEM         := ::cCHRMENSAGEM
	oClone:cCTEXTO              := ::cCTEXTO
	oClone:cCTIPO               := ::cCTIPO
	oClone:cCUSERLEITURA        := ::cCUSERLEITURA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETMENSAGEM
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCODIGO           :=  WSAdvValue( oResponse,"_CCODIGO","string",NIL,"Property cCCODIGO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTLEITURA        :=  WSAdvValue( oResponse,"_CDTLEITURA","string",NIL,"Property cCDTLEITURA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTMENSAGEM       :=  WSAdvValue( oResponse,"_CDTMENSAGEM","string",NIL,"Property cCDTMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFLAG             :=  WSAdvValue( oResponse,"_CFLAG","string",NIL,"Property cCFLAG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCHRLEITURA        :=  WSAdvValue( oResponse,"_CHRLEITURA","string",NIL,"Property cCHRLEITURA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCHRMENSAGEM       :=  WSAdvValue( oResponse,"_CHRMENSAGEM","string",NIL,"Property cCHRMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCTEXTO            :=  WSAdvValue( oResponse,"_CTEXTO","string",NIL,"Property cCTEXTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCTIPO             :=  WSAdvValue( oResponse,"_CTIPO","string",NIL,"Property cCTIPO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCUSERLEITURA      :=  WSAdvValue( oResponse,"_CUSERLEITURA","string",NIL,"Property cCUSERLEITURA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure STRUGETPARTNUMB

WSSTRUCT WSPF04_STRUGETPARTNUMB
	WSDATA   cCODPROD                  AS string
	WSDATA   cCORPORA                  AS string
	WSDATA   cONDMAN                   AS string
	WSDATA   cSLOTID                   AS string
	WSDATA   cTYPECLIC                 AS string
	WSDATA   cTYPEOND                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUGETPARTNUMB
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUGETPARTNUMB
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUGETPARTNUMB
	Local oClone := WSPF04_STRUGETPARTNUMB():NEW()
	oClone:cCODPROD             := ::cCODPROD
	oClone:cCORPORA             := ::cCORPORA
	oClone:cONDMAN              := ::cONDMAN
	oClone:cSLOTID              := ::cSLOTID
	oClone:cTYPECLIC            := ::cTYPECLIC
	oClone:cTYPEOND             := ::cTYPEOND
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRUGETPARTNUMB
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCODPROD           :=  WSAdvValue( oResponse,"_CODPROD","string",NIL,"Property cCODPROD as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCORPORA           :=  WSAdvValue( oResponse,"_CORPORA","string",NIL,"Property cCORPORA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cONDMAN            :=  WSAdvValue( oResponse,"_ONDMAN","string",NIL,"Property cONDMAN as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSLOTID            :=  WSAdvValue( oResponse,"_SLOTID","string",NIL,"Property cSLOTID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cTYPECLIC          :=  WSAdvValue( oResponse,"_TYPECLIC","string",NIL,"Property cTYPECLIC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cTYPEOND           :=  WSAdvValue( oResponse,"_TYPEOND","string",NIL,"Property cTYPEOND as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure STRURETGETTOTVSID

WSSTRUCT WSPF04_STRURETGETTOTVSID
	WSDATA   cLS_ALIAS                 AS string
	WSDATA   cLS_ENVOPER               AS string
	WSDATA   cLS_IPCONN                AS string
	WSDATA   cLS_MSBLQL                AS string
	WSDATA   cLS_UUID                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETGETTOTVSID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETGETTOTVSID
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETGETTOTVSID
	Local oClone := WSPF04_STRURETGETTOTVSID():NEW()
	oClone:cLS_ALIAS            := ::cLS_ALIAS
	oClone:cLS_ENVOPER          := ::cLS_ENVOPER
	oClone:cLS_IPCONN           := ::cLS_IPCONN
	oClone:cLS_MSBLQL           := ::cLS_MSBLQL
	oClone:cLS_UUID             := ::cLS_UUID
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETGETTOTVSID
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cLS_ALIAS          :=  WSAdvValue( oResponse,"_LS_ALIAS","string",NIL,"Property cLS_ALIAS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cLS_ENVOPER        :=  WSAdvValue( oResponse,"_LS_ENVOPER","string",NIL,"Property cLS_ENVOPER as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cLS_IPCONN         :=  WSAdvValue( oResponse,"_LS_IPCONN","string",NIL,"Property cLS_IPCONN as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cLS_MSBLQL         :=  WSAdvValue( oResponse,"_LS_MSBLQL","string",NIL,"Property cLS_MSBLQL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cLS_UUID           :=  WSAdvValue( oResponse,"_LS_UUID","string",NIL,"Property cLS_UUID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFSDADPF4IIGETCNPJS

WSSTRUCT WSPF04_ARRAYOFSDADPF4IIGETCNPJS
	WSDATA   oWSSDADPF4IIGETCNPJS      AS WSPF04_SDADPF4IIGETCNPJS OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETCNPJS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETCNPJS
	::oWSSDADPF4IIGETCNPJS := {} // Array Of  WSPF04_SDADPF4IIGETCNPJS():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETCNPJS
	Local oClone := WSPF04_ARRAYOFSDADPF4IIGETCNPJS():NEW()
	oClone:oWSSDADPF4IIGETCNPJS := NIL
	If ::oWSSDADPF4IIGETCNPJS <> NIL 
		oClone:oWSSDADPF4IIGETCNPJS := {}
		aEval( ::oWSSDADPF4IIGETCNPJS , { |x| aadd( oClone:oWSSDADPF4IIGETCNPJS , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETCNPJS
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_SDADPF4IIGETCNPJS","SDADPF4IIGETCNPJS",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSDADPF4IIGETCNPJS , WSPF04_SDADPF4IIGETCNPJS():New() )
			::oWSSDADPF4IIGETCNPJS[len(::oWSSDADPF4IIGETCNPJS)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSDADPF4IIGETMODUL

WSSTRUCT WSPF04_ARRAYOFSDADPF4IIGETMODUL
	WSDATA   oWSSDADPF4IIGETMODUL      AS WSPF04_SDADPF4IIGETMODUL OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETMODUL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETMODUL
	::oWSSDADPF4IIGETMODUL := {} // Array Of  WSPF04_SDADPF4IIGETMODUL():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETMODUL
	Local oClone := WSPF04_ARRAYOFSDADPF4IIGETMODUL():NEW()
	oClone:oWSSDADPF4IIGETMODUL := NIL
	If ::oWSSDADPF4IIGETMODUL <> NIL 
		oClone:oWSSDADPF4IIGETMODUL := {}
		aEval( ::oWSSDADPF4IIGETMODUL , { |x| aadd( oClone:oWSSDADPF4IIGETMODUL , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETMODUL
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_SDADPF4IIGETMODUL","SDADPF4IIGETMODUL",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSDADPF4IIGETMODUL , WSPF04_SDADPF4IIGETMODUL():New() )
			::oWSSDADPF4IIGETMODUL[len(::oWSSDADPF4IIGETMODUL)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSDADPF4IIGETPARTN

WSSTRUCT WSPF04_ARRAYOFSDADPF4IIGETPARTN
	WSDATA   oWSSDADPF4IIGETPARTN      AS WSPF04_SDADPF4IIGETPARTN OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPARTN
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPARTN
	::oWSSDADPF4IIGETPARTN := {} // Array Of  WSPF04_SDADPF4IIGETPARTN():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPARTN
	Local oClone := WSPF04_ARRAYOFSDADPF4IIGETPARTN():NEW()
	oClone:oWSSDADPF4IIGETPARTN := NIL
	If ::oWSSDADPF4IIGETPARTN <> NIL 
		oClone:oWSSDADPF4IIGETPARTN := {}
		aEval( ::oWSSDADPF4IIGETPARTN , { |x| aadd( oClone:oWSSDADPF4IIGETPARTN , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPARTN
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_SDADPF4IIGETPARTN","SDADPF4IIGETPARTN",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSDADPF4IIGETPARTN , WSPF04_SDADPF4IIGETPARTN():New() )
			::oWSSDADPF4IIGETPARTN[len(::oWSSDADPF4IIGETPARTN)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFSDADPF4IIGETPRODU

WSSTRUCT WSPF04_ARRAYOFSDADPF4IIGETPRODU
	WSDATA   oWSSDADPF4IIGETPRODU      AS WSPF04_SDADPF4IIGETPRODU OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPRODU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPRODU
	::oWSSDADPF4IIGETPRODU := {} // Array Of  WSPF04_SDADPF4IIGETPRODU():New()
Return

WSMETHOD CLONE WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPRODU
	Local oClone := WSPF04_ARRAYOFSDADPF4IIGETPRODU():NEW()
	oClone:oWSSDADPF4IIGETPRODU := NIL
	If ::oWSSDADPF4IIGETPRODU <> NIL 
		oClone:oWSSDADPF4IIGETPRODU := {}
		aEval( ::oWSSDADPF4IIGETPRODU , { |x| aadd( oClone:oWSSDADPF4IIGETPRODU , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_ARRAYOFSDADPF4IIGETPRODU
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_SDADPF4IIGETPRODU","SDADPF4IIGETPRODU",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSDADPF4IIGETPRODU , WSPF04_SDADPF4IIGETPRODU():New() )
			::oWSSDADPF4IIGETPRODU[len(::oWSSDADPF4IIGETPRODU)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure STRURETCNPJID

WSSTRUCT WSPF04_STRURETCNPJID
	WSDATA   cCCNPJID                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETCNPJID
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETCNPJID
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETCNPJID
	Local oClone := WSPF04_STRURETCNPJID():NEW()
	oClone:cCCNPJID             := ::cCCNPJID
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETCNPJID
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCNPJID           :=  WSAdvValue( oResponse,"_CCNPJID","string",NIL,"Property cCCNPJID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure STRURETCONTRATO

WSSTRUCT WSPF04_STRURETCONTRATO
	WSDATA   cCDTEXP                   AS string
	WSDATA   cCLIBERA                  AS string
	WSDATA   cCMENSAGEM                AS string
	WSDATA   cCPRODUTO                 AS string
	WSDATA   nNQTDE                    AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETCONTRATO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETCONTRATO
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETCONTRATO
	Local oClone := WSPF04_STRURETCONTRATO():NEW()
	oClone:cCDTEXP              := ::cCDTEXP
	oClone:cCLIBERA             := ::cCLIBERA
	oClone:cCMENSAGEM           := ::cCMENSAGEM
	oClone:cCPRODUTO            := ::cCPRODUTO
	oClone:nNQTDE               := ::nNQTDE
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETCONTRATO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCDTEXP            :=  WSAdvValue( oResponse,"_CDTEXP","string",NIL,"Property cCDTEXP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCLIBERA           :=  WSAdvValue( oResponse,"_CLIBERA","string",NIL,"Property cCLIBERA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCMENSAGEM         :=  WSAdvValue( oResponse,"_CMENSAGEM","string",NIL,"Property cCMENSAGEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCPRODUTO          :=  WSAdvValue( oResponse,"_CPRODUTO","string",NIL,"Property cCPRODUTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNQTDE             :=  WSAdvValue( oResponse,"_NQTDE","float",NIL,"Property nNQTDE as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure STRURETLICENCAS

WSSTRUCT WSPF04_STRURETLICENCAS
	WSDATA   cCCDINST                  AS string
	WSDATA   cCDISTRIBUIVEL            AS string OPTIONAL
	WSDATA   cCNOMELS                  AS string OPTIONAL
	WSDATA   cCSLOTCODE                AS string
	WSDATA   cCSLOTNAME                AS string OPTIONAL
	WSDATA   cCTPAMB                   AS string OPTIONAL
	WSDATA   nNQTDCONTR                AS float OPTIONAL
	WSDATA   nNQTDE                    AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETLICENCAS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETLICENCAS
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETLICENCAS
	Local oClone := WSPF04_STRURETLICENCAS():NEW()
	oClone:cCCDINST             := ::cCCDINST
	oClone:cCDISTRIBUIVEL       := ::cCDISTRIBUIVEL
	oClone:cCNOMELS             := ::cCNOMELS
	oClone:cCSLOTCODE           := ::cCSLOTCODE
	oClone:cCSLOTNAME           := ::cCSLOTNAME
	oClone:cCTPAMB              := ::cCTPAMB
	oClone:nNQTDCONTR           := ::nNQTDCONTR
	oClone:nNQTDE               := ::nNQTDE
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPF04_STRURETLICENCAS
	Local cSoap := ""
	cSoap += WSSoapValue("CCDINST", ::cCCDINST, ::cCCDINST , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CDISTRIBUIVEL", ::cCDISTRIBUIVEL, ::cCDISTRIBUIVEL , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CNOMELS", ::cCNOMELS, ::cCNOMELS , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CSLOTCODE", ::cCSLOTCODE, ::cCSLOTCODE , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CSLOTNAME", ::cCSLOTNAME, ::cCSLOTNAME , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CTPAMB", ::cCTPAMB, ::cCTPAMB , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NQTDCONTR", ::nNQTDCONTR, ::nNQTDCONTR , "float", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NQTDE", ::nNQTDE, ::nNQTDE , "float", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETLICENCAS
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCDINST           :=  WSAdvValue( oResponse,"_CCDINST","string",NIL,"Property cCCDINST as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDISTRIBUIVEL     :=  WSAdvValue( oResponse,"_CDISTRIBUIVEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNOMELS           :=  WSAdvValue( oResponse,"_CNOMELS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCSLOTCODE         :=  WSAdvValue( oResponse,"_CSLOTCODE","string",NIL,"Property cCSLOTCODE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCSLOTNAME         :=  WSAdvValue( oResponse,"_CSLOTNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCTPAMB            :=  WSAdvValue( oResponse,"_CTPAMB","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNQTDCONTR         :=  WSAdvValue( oResponse,"_NQTDCONTR","float",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNQTDE             :=  WSAdvValue( oResponse,"_NQTDE","float",NIL,"Property nNQTDE as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure STRURETCODPRO

WSSTRUCT WSPF04_STRURETCODPRO
	WSDATA   cCPRODUTO                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRURETCODPRO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRURETCODPRO
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRURETCODPRO
	Local oClone := WSPF04_STRURETCODPRO():NEW()
	oClone:cCPRODUTO            := ::cCPRODUTO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_STRURETCODPRO
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCPRODUTO          :=  WSAdvValue( oResponse,"_CPRODUTO","string",NIL,"Property cCPRODUTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure STRUDADOSINST

WSSTRUCT WSPF04_STRUDADOSINST
	WSDATA   cCANALISTA                AS string
	WSDATA   cCINSTALACAO              AS string
	WSDATA   dDTFIM                    AS date
	WSDATA   dDTINI                    AS date
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_STRUDADOSINST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_STRUDADOSINST
Return

WSMETHOD CLONE WSCLIENT WSPF04_STRUDADOSINST
	Local oClone := WSPF04_STRUDADOSINST():NEW()
	oClone:cCANALISTA           := ::cCANALISTA
	oClone:cCINSTALACAO         := ::cCINSTALACAO
	oClone:dDTFIM               := ::dDTFIM
	oClone:dDTINI               := ::dDTINI
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSPF04_STRUDADOSINST
	Local cSoap := ""
	cSoap += WSSoapValue("CANALISTA", ::cCANALISTA, ::cCANALISTA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CINSTALACAO", ::cCINSTALACAO, ::cCINSTALACAO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DTFIM", ::dDTFIM, ::dDTFIM , "date", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DTINI", ::dDTINI, ::dDTINI , "date", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure SDADPF4IIGETCNPJS

WSSTRUCT WSPF04_SDADPF4IIGETCNPJS
	WSDATA   cCCNPJPRI                 AS string
	WSDATA   cCCNPJVIN                 AS string
	WSDATA   cCCODCLI                  AS string
	WSDATA   cCLOJCLI                  AS string
	WSDATA   cCTOTVSID                 AS string
	WSDATA   cCULTDATA                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_SDADPF4IIGETCNPJS
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_SDADPF4IIGETCNPJS
Return

WSMETHOD CLONE WSCLIENT WSPF04_SDADPF4IIGETCNPJS
	Local oClone := WSPF04_SDADPF4IIGETCNPJS():NEW()
	oClone:cCCNPJPRI            := ::cCCNPJPRI
	oClone:cCCNPJVIN            := ::cCCNPJVIN
	oClone:cCCODCLI             := ::cCCODCLI
	oClone:cCLOJCLI             := ::cCLOJCLI
	oClone:cCTOTVSID            := ::cCTOTVSID
	oClone:cCULTDATA            := ::cCULTDATA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_SDADPF4IIGETCNPJS
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCNPJPRI          :=  WSAdvValue( oResponse,"_CCNPJPRI","string",NIL,"Property cCCNPJPRI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCNPJVIN          :=  WSAdvValue( oResponse,"_CCNPJVIN","string",NIL,"Property cCCNPJVIN as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCODCLI           :=  WSAdvValue( oResponse,"_CCODCLI","string",NIL,"Property cCCODCLI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCLOJCLI           :=  WSAdvValue( oResponse,"_CLOJCLI","string",NIL,"Property cCLOJCLI as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCTOTVSID          :=  WSAdvValue( oResponse,"_CTOTVSID","string",NIL,"Property cCTOTVSID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCULTDATA          :=  WSAdvValue( oResponse,"_CULTDATA","string",NIL,"Property cCULTDATA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure SDADPF4IIGETMODUL

WSSTRUCT WSPF04_SDADPF4IIGETMODUL
	WSDATA   cCMODULDE                 AS string
	WSDATA   cCMODULID                 AS string
	WSDATA   cCTOTVSID                 AS string
	WSDATA   cCULTDATA                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_SDADPF4IIGETMODUL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_SDADPF4IIGETMODUL
Return

WSMETHOD CLONE WSCLIENT WSPF04_SDADPF4IIGETMODUL
	Local oClone := WSPF04_SDADPF4IIGETMODUL():NEW()
	oClone:cCMODULDE            := ::cCMODULDE
	oClone:cCMODULID            := ::cCMODULID
	oClone:cCTOTVSID            := ::cCTOTVSID
	oClone:cCULTDATA            := ::cCULTDATA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_SDADPF4IIGETMODUL
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCMODULDE          :=  WSAdvValue( oResponse,"_CMODULDE","string",NIL,"Property cCMODULDE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCMODULID          :=  WSAdvValue( oResponse,"_CMODULID","string",NIL,"Property cCMODULID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCTOTVSID          :=  WSAdvValue( oResponse,"_CTOTVSID","string",NIL,"Property cCTOTVSID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCULTDATA          :=  WSAdvValue( oResponse,"_CULTDATA","string",NIL,"Property cCULTDATA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure SDADPF4IIGETPARTN

WSSTRUCT WSPF04_SDADPF4IIGETPARTN
	WSDATA   cCPARTNUMBER              AS string
	WSDATA   cCULTDATA                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_SDADPF4IIGETPARTN
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_SDADPF4IIGETPARTN
Return

WSMETHOD CLONE WSCLIENT WSPF04_SDADPF4IIGETPARTN
	Local oClone := WSPF04_SDADPF4IIGETPARTN():NEW()
	oClone:cCPARTNUMBER         := ::cCPARTNUMBER
	oClone:cCULTDATA            := ::cCULTDATA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_SDADPF4IIGETPARTN
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCPARTNUMBER       :=  WSAdvValue( oResponse,"_CPARTNUMBER","string",NIL,"Property cCPARTNUMBER as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCULTDATA          :=  WSAdvValue( oResponse,"_CULTDATA","string",NIL,"Property cCULTDATA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure SDADPF4IIGETPRODU

WSSTRUCT WSPF04_SDADPF4IIGETPRODU
	WSDATA   cCERPDESC                 AS string
	WSDATA   cCERPID                   AS string
	WSDATA   cCTOTVSID                 AS string
	WSDATA   cCULTDATA                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSPF04_SDADPF4IIGETPRODU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSPF04_SDADPF4IIGETPRODU
Return

WSMETHOD CLONE WSCLIENT WSPF04_SDADPF4IIGETPRODU
	Local oClone := WSPF04_SDADPF4IIGETPRODU():NEW()
	oClone:cCERPDESC            := ::cCERPDESC
	oClone:cCERPID              := ::cCERPID
	oClone:cCTOTVSID            := ::cCTOTVSID
	oClone:cCULTDATA            := ::cCULTDATA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSPF04_SDADPF4IIGETPRODU
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCERPDESC          :=  WSAdvValue( oResponse,"_CERPDESC","string",NIL,"Property cCERPDESC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCERPID            :=  WSAdvValue( oResponse,"_CERPID","string",NIL,"Property cCERPID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCTOTVSID          :=  WSAdvValue( oResponse,"_CTOTVSID","string",NIL,"Property cCTOTVSID as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCULTDATA          :=  WSAdvValue( oResponse,"_CULTDATA","string",NIL,"Property cCULTDATA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


