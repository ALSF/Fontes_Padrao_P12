#INCLUDE "WSVDF060.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE OPERATION_INSERT        1
#DEFINE OPERATION_UPDATE        2
#DEFINE OPERATION_APPROVE       3
#DEFINE OPERATION_REPROVE       4
#DEFINE OPERATION_DELETE        5

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³WSVDF060  ³ Autor ³Marcelo Faria          ³ Data ³20.01.2014  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelas Certidoes Funcionais           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH Vida Funcional                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Responsavel  ³ Data   ³Tarefa³  Motivo da Alteracao                     ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT TVDFCertificate
    WSDATA DoctoID                     As String        //Codigo do Docto
    WSDATA DoctoDesc                   As String        //Descricao
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Certidoes Funcionais     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHVDFCertificate            DESCRIPTION STR0001    //Certidoes Funcionais
    WSDATA WsNull                        As String OPTIONAL     //NULL
    WSDATA EmployeeFil                  AS String               //Filial do funcionario
    WSDATA Registration                 AS String               //Matricula do funcionario

    WSDATA Request                       AS TRequest
    WSDATA VDFCertificateRequest       AS TVDFCertificate OPTIONAL

    WSMETHOD AddVDFCertificateRequest DESCRIPTION STR0002    //"Metodo que Inclui uma solicitacao de documento funcional"
ENDWSSERVICE                                                                                                     

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo  ³AddVDFCertificateRequest  ³ Autor ³Marcelo Faria    ³Data ³20.01.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para gravacao da solicitacao de documento funcional            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso     ³Portal RH Vida Funcional                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD AddVDFCertificateRequest WSRECEIVE Request, VDFCertificateRequest WSSEND WsNull WSSERVICE RHVDFCertificate

    Local nReturnCode
    Local nSaveSX8 := GetSX8Len()

    Self:Request:RequestType       := WSClassNew("TRequestType")
    Self:Request:Status             := WSClassNew("TRequestStatus")
    
    Self:Request:Code               := GetSX8Num("RH3", "RH3_CODIGO") 
    Self:Request:RequestType:Code := "S"  ///Certificado Funcional
    Self:Request:ResponseDate      := CTod("")
    Self:Request:Status:Code       := "1"
    Self:Request:RequestDate       := dDataBase    
    Self:Request:StarterKey        := fBuscaChaveFuncionario(  Self:Request:StarterBranch,;
                                                                     Self:Request:StarterRegistration,;
                                                                     Self:Request:Vision)

    If Empty(Self:Request:ApproverRegistration)
        If Self:Request:ApproverLevel == 98
           Self:Request:Status:Code    := "5"
        Else
           Self:Request:Status:Code    := "4"
        EndIf   
        Self:Request:StarterLevel      := 1
    Else
        Self:Request:StarterLevel      := Self:Request:ApproverLevel+1
    EndIf                                                               
                                       
    Begin Transaction

        nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT,"SIGAGFP")
        If nReturnCode > 0
            SetSoapFault("PutRequest-VDFCertificate", STR0003)
            Break
        EndIf

        nReturnCode:= fAddVDFCertificateRequest(Self:Request, Self:VDFCertificateRequest, Self:Request:Code, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddVDFCertificateRequest", STR0003)
            Break
        EndIf
        
        nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddPostRequest", STR0003)
            Break
        EndIf

        If Self:Request:Status:Code == "1"
            WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
        EndIf    

    End Transaction

    If nReturnCode == 0
        While (GetSx8Len() > nSaveSx8)
            ConfirmSX8()
        EndDo
    Else
        Return .F.
    EndIf 
          
Return .T.

