#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

WSSTRUCT MenuVisao        
	WSDATA Visao		     As String  OPTIONAL
	WSDATA NivelIni		 As Integer OPTIONAL
	WSDATA NivelAprov  	 As Integer OPTIONAL
ENDWSSTRUCT                            

WSSTRUCT Topic
	WSDATA TitleHead      As String	OPTIONAL	//Título
	WSDATA Content        As String OPTIONAL	//Conteúdo
	WSDATA TypeField      As String OPTIONAL	//Tipo Campo
ENDWSSTRUCT
WSSTRUCT TInputHeader
	WSDATA ListOfInput	 AS Array Of Topic OPTIONAL
ENDWSSTRUCT


WSSERVICE Menu DESCRIPTION "Acesso Menus"
	WSDATA DadosMenu        As MenuVisao
	WSDATA Portal		 	   As String
	WSDATA CodMenu		   As String

    WSDATA UserAval        AS String
    WSDATA ParamAval       AS String
    WSDATA ParamResult     AS String

    WSDATA TypeReq         AS String Optional
    WSDATA Branch          AS String Optional
    WSDATA HeadUser        AS String Optional
    WSDATA InputHeader     AS TInputHeader

	WSDATA ListOfOutput	  AS Array Of Topic OPTIONAL
	                                                                                                 
    WSMETHOD GetDadosMenu  DESCRIPTION "GetDadosMenu"
    WSMETHOD GetRHParam    DESCRIPTION "GetRHParam"
    WSMETHOD UpdHeader     DESCRIPTION "UpdHeader"
ENDWSSERVICE

WSMETHOD GetDadosMenu WSRECEIVE Branch,Portal, CodMenu WSSEND DadosMenu WSSERVICE Menu
		dbSelectArea("AI8")
		dbSetOrder(1) //AI8_FILIAL+AI8_PORTAL+AI8_CODMNU
		::DadosMenu	:= WsClassNew('MenuVisao')
		If dbSeek( xFilial("AI8",::Branch) + ::Portal + ::CodMenu)
			::DadosMenu:Visao      := AI8->AI8_VISAPV
			::DadosMenu:NivelIni   := AI8->AI8_INIAPV
			::DadosMenu:NivelAprov := AI8->AI8_APRVLV
		Else
			::DadosMenu:Visao      := ""
			::DadosMenu:NivelIni   := 0
			::DadosMenu:NivelAprov := 99
		EndIf
RETURN .T.


WSMETHOD GetRHParam WSRECEIVE UserAval, ParamAval WSSEND ParamResult WSSERVICE Menu
Local aArea    := GetArea()
Local lRetorno := .T.
If PrtChkUser(::UserAval,"CFGDictionary","GetParam")
    //Se não existir retorna "#"
    ::ParamResult := SuperGetMv(::ParamAval,.F.,"#") 
Else
    lRetorno := .F.
EndIf

RestArea(aArea)
Return(lRetorno)


WSMETHOD UpdHeader WSRECEIVE TypeReq, Branch, HeadUser, InputHeader WSSEND ListOfOutput WSSERVICE Menu
Local aHeader           := {}
Local aRet              := {}
Local nX                := 0

DEFAULT Self:TypeReq    := ""
DEFAULT Self:Branch     := ""
DEFAULT Self:HeadUser   := ""

  //Realizar chamada ao ponto de entrada "pgchHeader" para validar a troca das informações 
  //do cabeçalho a ser liberado para o usuário logado no Portal Gestão do Capital Humano
  If ExistBlock("PGCHHEADER")

     aHeader := {}
     For nX := 1 To Len( Self:InputHeader:ListOfInput )
         aAdd( aHeader, { Self:InputHeader:ListOfInput[nX]:TITLEHEAD , Self:InputHeader:ListOfInput[nX]:CONTENT } )
     Next nX

     If ( ValType( aRet := ExecBlock("PGCHHEADER", .F. , .F. ,{ Self:TypeReq,;
                                                                Self:Branch,;	 
       		                                                  	Self:HeadUser,;
                                                                aHeader;
    		                                                    }) ) == "A" )

         For nX := 1 To Len( aRet )
            aAdd(::ListOfOutput, wsClassNew('TOPIC')) 
          	  self:ListOfOutput[nX]:TitleHead := aRet[nX][1]
	         self:ListOfOutput[nX]:Content   := aRet[nX][2]
         Next nX
     EndIF

  EndIf

RETURN .T.


Function WSMENU
RETURN