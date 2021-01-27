#INCLUDE "WSVDF050.CH"
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
±±³Funcao    ³WSVDF050  ³ Autor ³Marcelo Faria          ³ Data ³14.08.2013  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelas Licencas e Afastamentos        ³±±
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
WSSTRUCT TVDFLicence
    WSDATA Licence                      As String OPTIONAL        //Codigo da Licenca
    WSDATA LicenceDesc                 As String OPTIONAL        //Descricao da Licenca
    WSDATA DaysRequest                 As String OPTIONAL        //Dias da licenca
    WSDATA DaysType                     As String OPTIONAL       //Tipo do Dia
    WSDATA DaysTypeDesc                As String OPTIONAL       //Tipo do Dia
    WSDATA InitialDate                 As String OPTIONAL        //Data Inicial
    WSDATA FinalDate                   As String OPTIONAL        //Data Final
    WSDATA SubsEmployeeFil            As String OPTIONAL        //Filial do funcionario substituto
    WSDATA SubsRegistration           As String OPTIONAL        //Codigo da matricula substituto
    WSDATA SubsName                    As String OPTIONAL        //Nome do funcionario substituto
ENDWSSTRUCT

WSSTRUCT DataLicence
    WSDATA Branch                        As String     OPTIONAL     //Filial da Licenca
    WSDATA Licence                       As String     OPTIONAL     //Licenca
    WSDATA Description                  As String     OPTIONAL     //Descricao da Licenca
    WSDATA IDBase                        As String     OPTIONAL     //Codigo da verba - RCM_PD
    WSDATA DaysType                      As String     OPTIONAL     //Tipo do Dia - RCM_TIPODI
    WSDATA DaysTypeDesc                 As String     OPTIONAL     //Tipo do Dia - Descricao
    WSDATA AbsenseDays                  As Integer    OPTIONAL     //Minimo de dias de afastamento
    WSDATA SubstType                     AS String    OPTIONAL     //Exige substituto
    WSDATA SubstTypeDesc                AS String    OPTIONAL     //Descricao tipo subst
    WSDATA SubstDays                     AS Integer   OPTIONAL     //Minimo de dias para substituicao
    WSDATA Portal                        AS String     OPTIONAL     //Mostra no Portal? (1=Sim)
    WSDATA RegID                         As Integer   OPTIONAL      //Recno (identificador unico)
    WSDATA DiasAfast					As Integer OPTIONAL
ENDWSSTRUCT                            

WSSTRUCT TLicenceData
    WSDATA ItemsOfLicence               AS Array Of DataLicence     OPTIONAL
    WSDATA ItemsTotal                   AS Integer                    OPTIONAL
ENDWSSTRUCT



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Licencas e Afastamentos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHVDFLicence                DESCRIPTION STR0001       //Licencas e Afastamentos
    WSDATA WsNull                       As String OPTIONAL        //NULL
    WSDATA EmployeeFil                 AS String                   //Filial do funcionario
    WSDATA Registration                AS String                   //Matricula do funcionario
    WSDATA PortalLicence               AS String                   //Licenca de Portal

    WSDATA Request                      AS TRequest
    WSDATA VDFLicenceRequest           AS TVDFLicence OPTIONAL

    WSDATA LicenceData                  As TLicenceData            //Licencas

    WSMETHOD AddVDFLicenceRequest     DESCRIPTION STR0002       //"Metodo que Inclui uma solicitacao de licenca"
    WSMETHOD GetLicences               DESCRIPTION STR0003       //"Metodo para listar as licencas disponiveis"
ENDWSSERVICE                                                                                                     

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³AddVDFLicenceRequest ³ Autor ³Marcelo Faria       ³Data ³09.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para gravacao da solicitacao de licencas                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD AddVDFLicenceRequest WSRECEIVE Request, VDFLicenceRequest WSSEND WsNull WSSERVICE RHVDFLicence
Local nReturnCode
Local nSaveSX8 := GetSX8Len()

    Self:Request:RequestType        := WSClassNew("TRequestType")
    Self:Request:Status              := WSClassNew("TRequestStatus")

    Self:Request:Code                := GetSX8Num("RH3", "RH3_CODIGO") 
    Self:Request:RequestType:Code  := "R"  ///Licencas e Afastamentos
    Self:Request:ResponseDate       := CTod("")
    Self:Request:Status:Code        := "1"
    Self:Request:RequestDate        := dDataBase    
    Self:Request:StarterKey         := fBuscaChaveFuncionario(  Self:Request:StarterBranch,;
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
            SetSoapFault("AddVDFVPutRequest", STR0002)
            Break
        EndIf

        nReturnCode:= fAddVDFLicenceRequest(Self:Request, Self:VDFLicenceRequest, Self:Request:Code, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddVDFLicenceRequest", STR0002)
            Break
        EndIf
        
        nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddVDFPostRequest", STR0002)
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

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo  ³GetLicences              ³ Autor ³Marcelo Faria     ³Data ³24.01.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar a relacao de licencas                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso     ³Portal RH Vida Funcional                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetLicences WSRECEIVE PortalLicence WSSEND LicenceData WSSERVICE RHVDFLicence
Local lRet        := .T.
Local nI          := 1
Local cWhere     := ""
Local cTipoDia   := ""
Local cQueryRCM  := GetNextAlias()
Local aBoxDia    := RetSx3Box( Posicione("SX3", 2, "RCM_TIPODI", "X3CBox()" ),,, 1 )

    DEFAULT Self:PortalLicence  := ""

    cWhere := "%"
    If !empty(Self:PortalLicence)
       cWhere += " AND RCM.RCM_PORTAL = '" + Self:PortalLicence  + "'"
    EndIf
    cWhere += "%"

    BeginSql alias cQueryRCM
        SELECT *
        FROM %table:RCM% RCM
        WHERE RCM.%notDel%               
              %exp:cWhere%
    EndSql 

    ::LicenceData                   := WsClassNew('TLicenceData')
    ::LicenceData:ItemsTotal      := 0
    ::LicenceData:ItemsOfLicence := {}

    While !(cQueryRCM)->(Eof())
           ::LicenceData:ItemsTotal  += 1

            aadd(::LicenceData:ItemsOfLicence,WsClassNew('DataLicence'))

            ::LicenceData:ItemsOfLicence[nI]:Branch         := (cQueryRCM)->RCM_FILIAL
            ::LicenceData:ItemsOfLicence[nI]:Licence        := (cQueryRCM)->RCM_TIPO
            ::LicenceData:ItemsOfLicence[nI]:Description   := (cQueryRCM)->RCM_DESCRI
            ::LicenceData:ItemsOfLicence[nI]:IDBase         := (cQueryRCM)->RCM_PD

            If empty((cQueryRCM)->RCM_TIPODI)
               cTipoDia                                          := "2" //corridos
            Else
               cTipoDia                                          := (cQueryRCM)->RCM_TIPODI
            EndIf
            ::LicenceData:ItemsOfLicence[nI]:DaysType       := cTipoDia
            ::LicenceData:ItemsOfLicence[nI]:DaysTypeDesc  := Alltrim(aBoxDia[Ascan( aBoxDia, { |aBox| aBox[2] = cTipoDia } )][3]) 

            If empty((cQueryRCM)->RCM_DSUBST) .or. (cQueryRCM)->RCM_DSUBST == 9999 
               ::LicenceData:ItemsOfLicence[nI]:SubstType      := "2" 
               ::LicenceData:ItemsOfLicence[nI]:SubstTypeDesc := "Nao"
            Else
               ::LicenceData:ItemsOfLicence[nI]:SubstType      := "1" 
               ::LicenceData:ItemsOfLicence[nI]:SubstTypeDesc := "Sim"
            EndIf

            ::LicenceData:ItemsOfLicence[nI]:SubstDays     := (cQueryRCM)->RCM_DSUBST
            ::LicenceData:ItemsOfLicence[nI]:AbsenseDays   := (cQueryRCM)->RCM_MDAFAS
            ::LicenceData:ItemsOfLicence[nI]:Portal         := (cQueryRCM)->RCM_PORTAL
            ::LicenceData:ItemsOfLicence[nI]:RegID          := (cQueryRCM)->R_E_C_N_O_
            ::LicenceData:ItemsOfLicence[nI]:DiasAfast      := (cQueryRCM)->RCM_DIALIC


            
        (cQueryRCM)->(dbSkip())
        nI++
    EndDo
   (cQueryRCM)->(dbCloseArea())

Return lRet