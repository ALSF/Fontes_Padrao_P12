#INCLUDE "WSVDF030.CH"
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
±±³Funcao    ³WSVDF030  ³ Autor ³Marcelo Faria          ³ Data ³14.08.2013  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelas Ferias                         ³±±
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
Function WSVDF030()
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT TVDFVacation
    WSDATA Description                 As String OPTIONAL     //Descricao da solicitacao
    WSDATA Table                        As String OPTIONAL     //Tabela de Programacao
    WSDATA Sequence                    As String OPTIONAL      //Sequencia da tabela
    WSDATA Programer                   As String OPTIONAL      //Tipo de programacao
    WSDATA Code                         As String OPTIONAL      //Codigo de programacao
    WSDATA AllowanceID                 As String OPTIONAL      //Codigo da Verba
    WSDATA InitialBaseDate            As String OPTIONAL      //Dias Base Inicial
    WSDATA FinalBaseDate              As String OPTIONAL      //Dias Base Inicial
    WSDATA OpportuneDays              As String OPTIONAL      //Dias Oportunos
    WSDATA BonusDays                   As String OPTIONAL      //Dias de abono
    WSDATA DaysofFirstPeriod          As String OPTIONAL     //Dias do primeiro periodo
    WSDATA DaysofSecondPeriod         As String OPTIONAL      //Dias do segundo periodo
    WSDATA FirstInitialDate           As String OPTIONAL      //Data Inicial
    WSDATA FirstFinalDate              As String OPTIONAL      //Data Final
    WSDATA FirstSubsEmployeeFil       As String OPTIONAL       //Filial do primeiro funcionario substituto
    WSDATA FirstSubsRegistration      As String OPTIONAL       //Codigo da primeira matricula substituta
    WSDATA FirstSubsName               As String OPTIONAL       //Nome do primeiro funcionario substituto
    WSDATA SecondInitialDate           As String OPTIONAL       //Data Inicial
    WSDATA SecondFinalDate             As String OPTIONAL      //Data Final
    WSDATA SecondSubsEmployeeFil      As String OPTIONAL       //Filial do segundo funcionario substituto
    WSDATA SecondSubsRegistration     As String OPTIONAL       //Codigo da segunda matricula substituta
    WSDATA SecondSubsName              As String OPTIONAL       //Nome do segundo funcionario substituto
    WSDATA TypeDescSolic               AS String OPTIONAL      //Descricao do tipo de solicitacao
    WSDATA IDPublication               As String OPTIONAL      //Codigo da publicacao
    WSDATA RI6Key                       As String OPTIONAL      //Chave RI6 Publicacao
    WSDATA RegID                        As Integer OPTIONAL     //Recno (identificador unico)
ENDWSSTRUCT

WSSTRUCT TVDFTable
    WSDATA ListOfS106                  AS Array Of TabS106  OPTIONAL
    WSDATA ListOfS107                  AS Array Of TabS107  OPTIONAL
ENDWSSTRUCT

WSSTRUCT TabS106
    WSDATA Table                        As String OPTIONAL       //Tabela
ENDWSSTRUCT

WSSTRUCT TabS107
    WSDATA Table                       As String OPTIONAL        //Tabela
    WSDATA Branch                      As String OPTIONAL        //Filial
    WSDATA Key                         As String OPTIONAL         //Chave
    WSDATA Sequence                   As String OPTIONAL         //Sequencia
    WSDATA TypeOfProgramer            As String OPTIONAL        //Tipo de programacao
    WSDATA OptionCode                 As String OPTIONAL         //Codigo da opcao
    WSDATA OptionDesc                 As String OPTIONAL         //Descricao da opcao    
    WSDATA Days01                      As Integer OPTIONAL       //Dias de Gozo 1    
    WSDATA Days02                      As Integer OPTIONAL       //Dias Indenizado-Abono    
    WSDATA Days03                      As Integer OPTIONAL        //Dias de Gozo oportuno    
    WSDATA Combination                As String OPTIONAL         //Combinacao ativa    
    WSDATA Days05                      As Integer OPTIONAL        //Dias de Gozo 2    
    WSDATA Days06                      As Integer OPTIONAL        //Dias Total    
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Ferias                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHVDFVacation                DESCRIPTION STR0001              //Ferias
    WSDATA WsNull                         As String OPTIONAL               //NULL
    WSDATA VacEmployeeFil                AS String OPTIONAL               //Filial do funcionario
    WSDATA VacRegistration               AS String OPTIONAL               //Matricula do funcionario
    WSDATA StartDate                     AS String  OPTIONAL              //Data inicial para verificar substituto
    WSDATA FinalDate                     AS String  OPTIONAL              //Data final para verificar substituto
    WSDATA EvalResult                    AS String  OPTIONAL              //Resultado da avaliacao do substituto
    WSDATA IDBase                        AS String  OPTIONAL              //Codigo da verba
    WSDATA DaysofSubst                  AS Integer OPTIONAL              //Dias para substituicao da ausencia

    WSDATA Request                        AS TRequest
    WSDATA VDFVacationRequest            AS TVDFVacation OPTIONAL

    WSDATA RetTable                       AS String    OPTIONAL            //Tabela
    WSDATA TypeProg                       AS String    OPTIONAL            //Tipo da programacao
    WSDATA CodeTable                      AS String    OPTIONAL            //Codigo da programacao
    WSDATA DatTable                       AS TVDFTable OPTIONAL           //Dados da tabela

    WSMETHOD AddVDFVacationRequest      DESCRIPTION STR0002             //"Metodo que Inclui uma solicitacao de ferias"
    WSMETHOD GetTable                     DESCRIPTION STR0003             //"Metodo para buscar tabela padrão"
    WSMETHOD EvalSubstitute              DESCRIPTION STR0004             //"Metodo para avaliar substituto"
    WSMETHOD GetSubstituteDays          DESCRIPTION STR0005             //"Metodo para buscar dias de substituto para a ausencia"
ENDWSSERVICE                                                                                                     


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³AddVDFVacationRequest³ Autor ³Marcelo Faria       ³Data ³30.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para gravacao da solicitacao de ferias                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD AddVDFVacationRequest WSRECEIVE Request, VDFVacationRequest WSSEND WsNull WSSERVICE RHVDFVacation
Local nReturnCode
Local nSaveSX8 := GetSX8Len()

    Self:Request:RequestType        := WSClassNew("TRequestType")
    Self:Request:Status              := WSClassNew("TRequestStatus")

    Self:Request:Code                := GetSX8Num("RH3", "RH3_CODIGO") 
    Self:Request:RequestType:Code  := "P"  ///Programacao de Ferias GSP
    Self:Request:ResponseDate      := CTod("")
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
            SetSoapFault("AddVDFVPutRequest", STR0003)
            Break
        EndIf

        nReturnCode:= fAddVDFVacationRequest(Self:Request, Self:VDFVacationRequest, Self:Request:Code, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddVDFVacationRequest", STR0003)
            Break
        EndIf
        
        nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddVDFPostRequest", STR0003)
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
±±³Metodo  ³ GetTable              ³ Autor ³Marcelo Faria       ³Data ³10.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar tabelas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetTable WSRECEIVE RetTable, TypeProg, CodeTable WSSEND DatTable WSSERVICE RHVDFVacation
Local nI                 := 1
Local nPos               := 0
Local aTable            := {}
Local lOK                := .T.

DEFAULT Self:RetTable  := ""
DEFAULT Self:TypeProg  := ""
DEFAULT Self:CodeTable := ""

  If self:RetTable != ""  
      fCarrTab( @aTable, self:RetTable )
  EndIf

  If len(aTable) > 0
    Self:DatTable              := WsClassNew('TVDFTable')
    Self:DatTable:ListOfS106 := {}
    Self:DatTable:ListOfS107 := {}

    If self:RetTable == 'S107'
       For nPos := 1 to Len(aTable)

           lOK := .T.
           If self:TypeProg != ""
               If self:TypeProg != aTable[nPos][5]
                  lOk := .F.
               Else
                   If self:CodeTable != ""
                      If !(val(alltrim(self:CodeTable)) == val(alltrim(aTable[nPos][6])))
                         lOk := .F.
                      EndIf
                   EndIf   
               EndIf 
           EndIf              

           If lOk 
               aadd(::DatTable:ListOfS107,WsClassNew('TabS107'))
               ::DatTable:ListOfS107[nI]:Table              := aTable[nPos][1]
               ::DatTable:ListOfS107[nI]:Branch             := aTable[nPos][2]
               ::DatTable:ListOfS107[nI]:Key                := aTable[nPos][3]
               ::DatTable:ListOfS107[nI]:Sequence           := alltrim(aTable[nPos][4])
    
               ::DatTable:ListOfS107[nI]:TypeOfProgramer   := alltrim(aTable[nPos][5])
               ::DatTable:ListOfS107[nI]:OptionCode         := alltrim(aTable[nPos][6])
               ::DatTable:ListOfS107[nI]:OptionDesc         := aTable[nPos][7]
               
               ::DatTable:ListOfS107[nI]:Days01             := aTable[nPos][8]  //Dias de Gozo 1
               ::DatTable:ListOfS107[nI]:Days02             := aTable[nPos][9]  //Dias Indenizado-Abono
               ::DatTable:ListOfS107[nI]:Days03             := aTable[nPos][10] //Dias de Gozo oportuno
    
               ::DatTable:ListOfS107[nI]:Combination       := aTable[nPos][11]  //Combinacao ativa
               ::DatTable:ListOfS107[nI]:Days05             := aTable[nPos][12] //Dias de Gozo 2
               ::DatTable:ListOfS107[nI]:Days06             := aTable[nPos][13] //Dias Total
               nI++
           EndIf
       Next nPos
    EndIf

  EndIf   

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo  ³ EvalSubstitute        ³ Autor ³Marcelo Faria       ³Data ³30.10.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para avaliar substituto                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD EvalSubstitute WSRECEIVE VacEmployeeFil, VacRegistration, StartDate, FinalDate WSSEND EvalResult WSSERVICE RHVDFVacation
Local nTamEmpFil           := TamSX3("RA_FILIAL")[1]   
Local cEmpFil              := ""
Local dDataInicial
Local dDataFinal

DEFAULT Self:VacEmployeeFil  := ""
DEFAULT Self:VacRegistration := ""
DEFAULT Self:StartDate        := ""
DEFAULT Self:FinalDate        := ""

     If ::StartDate <> "" .and. ::FinalDate <> ""
         cEmpFil       := ::VacEmployeeFil + Space(nTamEmpFil - Len(::VacEmployeeFil))
         ::EvalResult := Alltrim(Posicione('SRA',1,cEmpFil+::VacRegistration,'SRA->RA_NOME'))

         If ::EvalResult == ""
            //Funcionario não localizado - Matricula invalida
            ::EvalResult := "*2"
         Else
            //Avalia substituto
            dDataInicial := stod(Substr(::StartDate,7,4)+Substr(::StartDate,4,2)+Substr(::StartDate,1,2))
            dDataFinal   := stod(Substr(::FinalDate,7,4)+Substr(::FinalDate,4,2)+Substr(::FinalDate,1,2))

            If !fVerRI8(cEmpFil, ::VacRegistration, dDataInicial, dDataFinal, .T., .F., .F., .F., .F.)
                //Substituto nao disponivel
                ::EvalResult := "*3"
             EndIf
         EndIf
     EndIf       

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo  ³ GetSubstituteDays     ³ Autor ³Marcelo Faria       ³Data ³20.11.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar dias para substituto no afastamento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso     ³Portal RH Vida Funcional                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetSubstituteDays WSRECEIVE IDBase WSSEND DaysofSubst WSSERVICE RHVDFVacation
Local cRCMAlias      := GetNextAlias()
Local cIDBase        := ::IDBase    

DEFAULT Self:IDBase  := ""

     If Self:IDBase <> ""
                    
         BEGINSQL ALIAS cRCMAlias        
            SELECT
                RCM.RCM_PD, RCM.RCM_DSUBST DIAS
            FROM
                %table:RCM% RCM 
            WHERE
                RCM.RCM_FILIAL  = %xFilial:RCM%  AND
                RCM.RCM_PD       = %exp:cIDBase%  AND
                RCM.%notDel%                  
        ENDSQL                           

        If (cRCMAlias)->( !Eof() ) 
           ::DaysofSubst := (cRCMAlias)->DIAS
        Else           
           ::DaysofSubst := 9999
        EndIf   
       (cRCMAlias)->( DbCloseArea() )       

     else
        Self:DaysofSubst := 9999        
     EndIf       

Return .T.
