#INCLUDE "WSVDF020.CH"
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
±±³Funcao    ³WSVDF020  ³ Autor ³Marcelo Faria          ³ Data ³14.08.2013  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelo Saldo de Dias de Ferias         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH Vida Funcional                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³   BOPS/FNC   ³  Motivo da Alteracao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos Perei³12/12/2014³00000442162014³Considerar dias de indenizacao em solicitacoes ³±±
±±³            ³          ³              ³do Tipo T para abater saldo e assim não        ³±±
±±³            ³          ³              ³permitir duplicidade.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function WSVDF020()
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT TVDFBalanceVac
    WSDATA EmployeeFil                    AS String                   //Filial do funcionario
    WSDATA Registration                   AS String                   //Matricula do funcionario
    WSDATA Sequence                       As String                   //Sequencia da programacao
    WSDATA PayrollCode                    As String     OPTIONAL     //Codigo da verba
    WSDATA InitialBaseDate               As String     OPTIONAL     //Dias Base Inicial
    WSDATA ProgInitialDate               As String     OPTIONAL     //Data Inicial
    WSDATA progFinalDate                 As String     OPTIONAL     //Data Final
    WSDATA ProgDays                       As Integer    OPTIONAL     //Dias programados
    WSDATA AllowDays                      AS Integer    OPTIONAL     //Dias abonados
    WSDATA RegID                           As Integer   OPTIONAL     //Recno (identificador unico)
    WSDATA SubstBranch                    AS String    OPTIONAL      //Filial do substituto
    WSDATA SubstRegistration             AS String    OPTIONAL      //Matricula do substituto
    WSDATA SubstName                      AS String    OPTIONAL      //Nome do substituto
    WSDATA TypeDescSolic                 AS String     OPTIONAL      //Descricao do tipo de solicitacao
    WSDATA IDPublication                 As String     OPTIONAL     //Codigo da publicacao
    WSDATA RI6Key                         As String     OPTIONAL     //Chave RI6
ENDWSSTRUCT

WSSTRUCT DataPlan
    WSDATA BaseDate                       As String     OPTIONAL     //Data Base do periodo
    WSDATA InitialDateProg               As String     OPTIONAL     //Data Inicial de programacao
    WSDATA FinalDateProg                 As String     OPTIONAL     //Data Final de programacao
    WSDATA ProgDays                       As Integer    OPTIONAL     //Dias programados
    WSDATA AllowDays                      AS Integer    OPTIONAL     //Dias abonados
    WSDATA StatusCode                     AS String     OPTIONAL     //Status da programacao
    WSDATA StatusDescrip                 AS String     OPTIONAL     //Descricao do status
    WSDATA SubstBranch                    As String    OPTIONAL     //Filial do substituto
    WSDATA SubstRegistration             As String    OPTIONAL     //Matricula do substituto
    WSDATA SubstName                      As String    OPTIONAL     //Nome do substituto
    WSDATA RegID                           As Integer   OPTIONAL     //Recno (identificador unico)
    WSDATA Sequence                       As String     OPTIONAL     //Sequencia da Progamacao
    WSDATA IDBase                         As String     OPTIONAL     //Codigo da verba
    WSDATA IDPublication                 As String     OPTIONAL     //Codigo da publicacao
    WSDATA RI6Key                         As String     OPTIONAL     //Chave RI6
ENDWSSTRUCT                            

WSSTRUCT TPlanData
    WSDATA ItemsOfPlan                    AS Array Of DataPlan         OPTIONAL
    WSDATA ItemsTotal                     AS Integer                    OPTIONAL
ENDWSSTRUCT


WSSTRUCT DataSolic
    WSDATA RegID                          As Integer   OPTIONAL     //Recno RH3 (identificador unico)
    WSDATA Code                           As String     OPTIONAL     //Codigo da solicitacao
    WSDATA TypeSolic                     As String     OPTIONAL     //Tipo da Solicitacao
    WSDATA StatusSolic                   As String     OPTIONAL     //Status da Solicitacao
    WSDATA StatusDescrip                 AS String     OPTIONAL     //Descricao do status
    WSDATA DateSolic                     As String     OPTIONAL     //Data da solicitacao
    WSDATA AtendSolic                    As String     OPTIONAL     //Data do atendimento da solicitacao

    WSDATA IDBase                         As String     OPTIONAL     //Codigo da verba
    WSDATA InitialDateBase               As String     OPTIONAL     //Data Base inicial do periodo
    WSDATA FinalDateBase                 As String     OPTIONAL     //Data Base final do periodo
    
    WSDATA InitialDateProg               As String     OPTIONAL     //Data Inicial de programacao
    WSDATA FinalDateProg                 As String     OPTIONAL     //Data Final de programacao
    WSDATA SolicDays                      As Integer    OPTIONAL     //Dias solicitados
    WSDATA SubstBranch                    As String    OPTIONAL     //Filial do substituto
    WSDATA SubstRegistration             As String    OPTIONAL     //Matricula do substituto
    WSDATA SubstName                      As String    OPTIONAL     //Nome do substituto
ENDWSSTRUCT                            

WSSTRUCT TSolicData
    WSDATA ItemsOfSolic                   AS Array Of DataSolic        OPTIONAL
    WSDATA ItemsSolicTotal                AS Integer                    OPTIONAL
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Saldo de Ferias          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHVDFBalanceVacation         DESCRIPTION STR0001       //Controle de Saldo de Ferias e Licenca Premio
    WSDATA WsNull                          As String OPTIONAL       //NULL
    WSDATA EmployeeFil                    AS String                 //Filial do funcionario
    WSDATA Registration                   AS String                 //Matricula do funcionario
    WSDATA PD                              AS String                 //Codigo da verba
    WSDATA InitialDate                    AS String                 //Data Base do inicio periodo
    WSDATA FinalDate                      AS String                 //Data Base do final periodo
    WSDATA DaysAllow                       AS String                 //Dias de Indenizacao
    WSDATA TypeSolic                       AS String                 //Tipo da Solicitacao
    WSDATA StatusSolic                     AS String                 //Status das Solicitacoes

    WSDATA Request                        AS TRequest
    WSDATA VDFBalanceVacRequest         AS TVDFBalanceVac        OPTIONAL

    WSDATA PlanData                       As TPlanData              //Programacoes
    WSDATA SolicData                      As TSolicData             //Solicitacoes

    WSDATA AvalMessage                    AS String                 //Retorno da Mensagem de Avaliacao
    
    WSMETHOD AddVDFBalanceVacRequest    DESCRIPTION STR0002      //"Metodo que Inclui uma ajuste para saldo de ferias"
    WSMETHOD GetPerPlanned               DESCRIPTION STR0003      //"Metodo para buscar que programacoes do pediodo aquisitivo"
    WSMETHOD CheckAllow                  DESCRIPTION STR0004      //"Metodo para validar e permitir indenizacoes"
    WSMETHOD GetSolicPlanned            DESCRIPTION STR0006      //"Metodo para buscar solicitacoes do pediodo aquisitivo"
ENDWSSERVICE

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³AddVDFBalanceVacRequest³ Autor ³Marcelo Faria     ³Data ³11.11.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para gravacao da solicitacao de saldo de ferias                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD AddVDFBalanceVacRequest WSRECEIVE Request, VDFBalanceVacRequest WSSEND WsNull WSSERVICE RHVDFBalanceVacation
Local nReturnCode
Local nSaveSX8 := GetSX8Len()

    Self:Request:RequestType        := WSClassNew("TRequestType")
    Self:Request:Status              := WSClassNew("TRequestStatus")

    Self:Request:Code                := GetSX8Num("RH3", "RH3_CODIGO") 
    Self:Request:RequestType:Code  := "O"  ///Cancelamento de Programacao de Ferias GSP
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

        nReturnCode:= fAddVDFBalanceVacRequest(Self:Request, Self:VDFBalanceVacRequest, Self:Request:Code, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddVDFBalanceVacRequest", STR0002)
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
±±³Metodo  ³GetPerPlanned            ³ Autor ³Marcelo Faria     ³Data ³04.12.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar programacao do periodo aquisitivo                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso     ³Portal RH Vida Funcional                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetPerPlanned WSRECEIVE EmployeeFil, Registration, PD, InitialDate, TypeSolic WSSEND PlanData WSSERVICE RHVDFBalanceVacation

Local lRet         := .T.
Local nI           := 1
Local cWhere      := ""
Local cChave      := ""
Local cPublica    := ""
Local cStatus     := ""
Local cStatusDesc := ""

Local cFil         := ""
Local cMat         := ""
Local cSeq         := ""
Local cPD          := ""
Local cDTInpa      := ""
Local cDTIni       := ""
Local cDTFim       := ""

Local cQueryRIA   := GetNextAlias()
Local cQueryRI6   := GetNextAlias()
Local cQueryRH3   := GetNextAlias()
Local cQueryRH4   := GetNextAlias()

Local aBoxStatus  := RetSx3Box( Posicione("SX3", 2, "RIA_STATUS", "X3CBox()" ),,, 1 )   

DEFAULT Self:EmployeeFil  := ""
DEFAULT Self:Registration := ""
DEFAULT Self:PD             := ""
DEFAULT Self:InitialDate  := ""
DEFAULT Self:TypeSolic    := ""

cWhere := "%"
cWhere += " AND RIA.RIA_FILIAL = '" + Self:EmployeeFil  + "'"
cWhere += " AND RIA.RIA_MAT    = '" + Self:Registration + "'"
cWhere += " AND RIA.RIA_PD     = '" + Self:PD            + "'"
cWhere += " AND RIA.RIA_DTINPA = '" + Self:InitialDate  + "'"
cWhere += "%"

    BeginSql alias cQueryRIA
        SELECT *
        FROM %table:RIA% RIA
        WHERE RIA.%notDel%               
              %exp:cWhere%
        Order by RIA.RIA_STATUS      
    EndSql 

    ::PlanData               := WsClassNew('TPlanData')
    ::PlanData:ItemsTotal  := 0
    ::planData:ItemsOfPlan := {}

    While !(cQueryRIA)->(Eof())
    
           //Avalia publicação
           cPublica := ""
           cChave   := (cQueryRIA)->RIA_PD + (cQueryRIA)->RIA_DTINPA + (cQueryRIA)->RIA_DATINI + (cQueryRIA)->RIA_SEQPRG 

           cWhere := "%"
           cWhere += " AND RI6.RI6_FILIAL = '" + xFilial("RI6")  + "'"
           cWhere += " AND RI6.RI6_FILMAT = '" + (cQueryRIA)->RIA_FILIAL + "'"
           cWhere += " AND RI6.RI6_MAT    = '" + (cQueryRIA)->RIA_MAT + "'"
           cWhere += " AND RI6.RI6_TABORI = 'RIA'"
           cWhere += " AND RI6.RI6_CHAVE  = '" + cChave  + "'"
           cWhere += "%"

           BeginSql alias cQueryRI6
              SELECT RI6_CHAVE, RI6_TIPDOC, RI6_ANO, RI6_NUMDOC
              FROM %table:RI6% RI6
              WHERE RI6.%notDel%               
                    %exp:cWhere%
           EndSql 

           cChave   := ""
           cPublica := ""
           If !(cQueryRI6)->(Eof())
               If !Empty((cQueryRI6)->RI6_NUMDOC)
                  cPublica := (cQueryRI6)->RI6_TIPDOC +(cQueryRI6)->RI6_NUMDOC +(cQueryRI6)->RI6_ANO
                  cChave   := (cQueryRI6)->RI6_CHAVE
               EndIf
           EndIf    


           //Verifica status "Programado" da RIA, para localizar se já existe solicitacao
           cStatus      := (cQueryRIA)->RIA_STATUS
           cStatusDesc := Alltrim(aBoxStatus[Ascan( aBoxStatus, { |aBox| aBox[2] = (cQueryRIA)->RIA_STATUS  } )][3])
           
           If (cQueryRIA)->RIA_STATUS == "0" .and. self:TypeSolic == "O"

               //Busca RH3 (Solicitações) 
               cWhere := "%"
               cWhere += " AND RH3.RH3_FILIAL = '" + xFilial("RH3")  + "'"
               cWhere += " AND RH3.RH3_MAT    = '" + (cQueryRIA)->RIA_MAT + "'"
               cWhere += " AND RH3.RH3_TIPO   = 'O'"
               cWhere += "%"

               BeginSql alias cQueryRH3
                  SELECT RH3_FILIAL, RH3_MAT, RH3_CODIGO, RH3_TIPO, RH3_STATUS
                  FROM %table:RH3% RH3
                  WHERE RH3.%notDel%               
                        %exp:cWhere%
               EndSql 
               While !(cQueryRH3)->(eof())

                    IF (cQueryRH3)->RH3_STATUS $ "145"
                       //Busca RH4 (detalhes de solicitações) 

                       cWhere := "%"
                       cWhere += " AND RH4.RH4_CODIGO = '" + (cQueryRH3)->RH3_CODIGO  + "'"
                       cWhere += "%"

                       BeginSql alias cQueryRH4
                          SELECT *
                              FROM %table:RH4% RH4
                              WHERE RH4.%notDel%               
                              %exp:cWhere%
                       EndSql 

                       While !(cQueryRH4)->(eof())
                            Do Case
                    
                            //LINHA DA RIA
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RA_FILIAL"
                                cFil        := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RA_MAT"
                                cMat        := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RIA_SEQPRG"
                                cSeq        := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RIA_PD"
                                cPD         := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RIA_DTINPA"
                                cDtINPA     := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RIA_DATINI"
                                cDtIni      := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RIA_DATFIM"
                                cDtFim      := alltrim((cQueryRH4)->RH4_VALNOV)
                    
                            EndCase

                           (cQueryRH4)->(dbskip())
                       Enddo
                       (cQueryRH4)->(dbCloseArea())

                       //Confirma se localizou a solicitacao
                       IF cMat    == (cQueryRIA)->RIA_MAT     .and.;
                          cSeq    == (cQueryRIA)->RIA_SEQPRG  .and.;
                          cPD     == (cQueryRIA)->RIA_PD       .and.;
                          cDTInpa == (cQueryRIA)->RIA_DTINPA  .and.;
                          cDTIni  == (cQueryRIA)->RIA_DATINI  .and.;
                          cDTFim  == (cQueryRIA)->RIA_DATFIM

                            cStatus      := "9"
                            cStatusDesc := STR0005 //Solicitado
                       EndIf 

                    EndIf

                   (cQueryRH3)->(dbskip())
               Enddo

               (cQueryRH3)->(dbCloseArea())
           EndIf 

           //Grava registro da programacao
           ::PlanData:ItemsTotal  += 1

            aadd(::PlanData:ItemsOfPlan,WsClassNew('DataPlan'))
            ::PlanData:ItemsOfPlan[nI]:BaseDate            := (cQueryRIA)->RIA_DTINPA
            ::PlanData:ItemsOfPlan[nI]:InitialDateProg    := (cQueryRIA)->RIA_DATINI
            ::PlanData:ItemsOfPlan[nI]:FinalDateProg      := (cQueryRIA)->RIA_DATFIM

            ::PlanData:ItemsOfPlan[nI]:ProgDays            := (cQueryRIA)->RIA_NRDGOZ
            ::PlanData:ItemsOfPlan[nI]:AllowDays           := (cQueryRIA)->RIA_NRDIND

            ::PlanData:ItemsOfPlan[nI]:StatusCode          := cSTATUS
            ::PlanData:ItemsOfPlan[nI]:StatusDescrip      := cStatusDesc

            ::PlanData:ItemsOfPlan[nI]:SubstBranch        := (cQueryRIA)->RIA_FILSUB
            ::PlanData:ItemsOfPlan[nI]:SubstRegistration := (cQueryRIA)->RIA_MATSUB
            ::PlanData:ItemsOfPlan[nI]:SubstName          := Alltrim(Posicione('SRA',1,(cQueryRIA)->RIA_FILSUB+(cQueryRIA)->RIA_MATSUB,'SRA->RA_NOME'))

            ::PlanData:ItemsOfPlan[nI]:RegID               := (cQueryRIA)->R_E_C_N_O_

            ::PlanData:ItemsOfPlan[nI]:Sequence           := (cQueryRIA)->RIA_SEQPRG
            ::PlanData:ItemsOfPlan[nI]:IDBase             := (cQueryRIA)->RIA_PD
            
            ::PlanData:ItemsOfPlan[nI]:IDPublication     := cPublica
            ::PlanData:ItemsOfPlan[nI]:RI6Key             := cChave
            
        (cQueryRI6)->(DBCloseArea())
        (cQueryRIA)->(dbSkip())
        nI++
    EndDo
   (cQueryRIA)->(dbCloseArea())

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo  ³GetSolicPlanned          ³ Autor ³Marcelo Faria     ³Data ³05.06.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar solicitacoes do periodo aquisitivo                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso     ³Portal RH Vida Funcional                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetSolicPlanned WSRECEIVE EmployeeFil, Registration, PD, InitialDate, FinalDate, TypeSolic, StatusSolic WSSEND SolicData WSSERVICE RHVDFBalanceVacation
Local lRet         := .T.
Local lAchou       := .F.
Local nI           := 1
Local cWhere      := ""

Local cFil         := ""
Local cMat         := ""
Local cPD          := ""
Local cDtIniPer   := ""
Local cDtFimPer   := ""
Local cDtIni       := ""
Local cDtFim       := ""
Local cFilSub      := ""
Local cMatSub      := ""
Local cNomeSub     := ""
Local nDiasSolic  := 0

Local cQueryRH3   := GetNextAlias()
Local cQueryRH4   := GetNextAlias()

Local aBoxStatus  := RetSx3Box( Posicione("SX3", 2, "RH3_STATUS", "X3CBox()" ),,, 1 )

DEFAULT Self:EmployeeFil  := ""
DEFAULT Self:Registration := ""
DEFAULT Self:PD             := ""
DEFAULT Self:InitialDate  := ""
DEFAULT Self:FinalDate    := ""
DEFAULT Self:TypeSolic    := ""
DEFAULT Self:StatusSolic  := ""

cWhere := "%"
cWhere += " AND RH3.RH3_FILIAL =  '" + Self:EmployeeFil  + "'"
cWhere += " AND RH3.RH3_MAT    =  '" + Self:Registration + "'"
cWhere += " AND RH3.RH3_TIPO   =  '" + Self:TypeSolic    + "'"
cWhere += "%"

    BeginSql alias cQueryRH3
        SELECT *
        FROM %table:RH3% RH3
        WHERE RH3.%notDel%               
              %exp:cWhere%
    EndSql 

    ::SolicData                   := WsClassNew('TSolicData')
    ::SolicData:ItemsSolicTotal := 0
    ::SolicData:ItemsOfSolic    := {}

    //Busca solicitacoes para o periodo aquisito
    While !(cQueryRH3)->(Eof())
        IF (cQueryRH3)->RH3_STATUS $ Self:StatusSolic

            //Busca RH4 (detalhes de solicitações) 
            cWhere := "%"
            cWhere += " AND RH4.RH4_CODIGO = '" + (cQueryRH3)->RH3_CODIGO  + "'"
            cWhere += "%"
            BeginSql alias cQueryRH4
                SELECT *
                FROM %table:RH4% RH4
                WHERE RH4.%notDel%               
                %exp:cWhere%
            EndSql 

            lAchou      := .F.
            cFil        := ""
            cMat        := ""
            cPD         := ""
            cDtIniPer  := ""
            cDtFimPer  := ""
            cDtIni      := ""
            cDtFim      := ""
            cFilSub     := ""
            cMatSub     := ""
            cNomeSub    := ""
            nDiasSolic := 0
            
            While !(cQueryRH4)->(eof())
                  If (cQueryRH3)->RH3_TIPO == "T" //Dias de Folga
                       Do Case
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RA_FILIAL"
                                cFil        := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "RA_MAT"
                                cMat        := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_PD"
                                cPD         := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_DTBINI"
                                cDtIniPer  := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_DTBFIM"
                                cDtFimPer  := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_DPER1"
                                nDiasSolic  := val((cQueryRH4)->RH4_VALNOV)
							Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_DABONO"
                                nDiasSolic  := val((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_DTINI1"
                                cDtIni      := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_DTFIM1"
                                cDtFim      := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_FSUB1"
                                cFilSub     := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_MSUB1"
                                cMatSub     := alltrim((cQueryRH4)->RH4_VALNOV)
                            Case alltrim((cQueryRH4)->RH4_CAMPO) == "TMP_NSUB1"
                                cNomeSub    := alltrim((cQueryRH4)->RH4_VALNOV)
                       EndCase
                  EndIf

               (cQueryRH4)->(dbskip())
            Enddo

            If (cQueryRH3)->RH3_TIPO == "T" //Dias de Folga
                  //Confirma se localizou a solicitacao
                  IF cMat        == Self:Registration  .and.;
                     cPD         == Self:PD              .and.;
                     cDtIniPer  == Self:InitialDate   .and.;
                     cDtFimPer  == Self:FinalDate

                     lAchou        := .T.  
                  EndIf 
            EndIf
            (cQueryRH4)->(dbCloseArea())


            If lAchou 
               //Grava dados da solicitação 
               ::SolicData:ItemsSolicTotal  += 1

                aadd(::SolicData:ItemsOfSolic,WsClassNew('DataSolic'))
                ::SolicData:ItemsOfSolic[nI]:RegID              := (cQueryRH3)->R_E_C_N_O_
                ::SolicData:ItemsOfSolic[nI]:Code               := (cQueryRH3)->RH3_CODIGO
                ::SolicData:ItemsOfSolic[nI]:TypeSolic         := (cQueryRH3)->RH3_TIPO
                ::SolicData:ItemsOfSolic[nI]:StatusSolic       := (cQueryRH3)->RH3_STATUS
                ::SolicData:ItemsOfSolic[nI]:StatusDescrip     :=  Alltrim(aBoxStatus[Ascan( aBoxStatus, { |aBox| aBox[2] = (cQueryRH3)->RH3_STATUS  } )][3]) 
                ::SolicData:ItemsOfSolic[nI]:DateSolic          := (cQueryRH3)->RH3_DTSOLI
                ::SolicData:ItemsOfSolic[nI]:AtendSolic         := (cQueryRH3)->RH3_DTATEN
    
                ::SolicData:ItemsOfSolic[nI]:IDBase             := cPD
                ::SolicData:ItemsOfSolic[nI]:InitialDateBase   := cDtIniPer
                ::SolicData:ItemsOfSolic[nI]:FinalDateBase     := cDtFimPer

                ::SolicData:ItemsOfSolic[nI]:InitialDateProg   := cDtIni
                ::SolicData:ItemsOfSolic[nI]:FinalDateProg      := cDtFim
                ::SolicData:ItemsOfSolic[nI]:SolicDays          := nDiasSolic

                ::SolicData:ItemsOfSolic[nI]:SubstBranch        := cFilSub
                ::SolicData:ItemsOfSolic[nI]:SubstRegistration := cMatSub
                ::SolicData:ItemsOfSolic[nI]:SubstName          := cNomeSub
                nI++
            EndIf
        EndIf
        
        (cQueryRH3)->(dbSkip())
    EndDo
   (cQueryRH3)->(dbCloseArea())

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo  ³CheckAllow               ³ Autor ³Marcelo Faria     ³Data ³27.05.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar programacao do periodo aquisitivo                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso     ³Portal RH Vida Funcional                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD CheckAllow WSRECEIVE EmployeeFil, Registration, PD, DaysAllow, InitialDate, TypeSolic WSSEND AvalMessage WSSERVICE RHVDFBalanceVacation
Local lRet        := .T.
Local dDataInicio:= STod("")

DEFAULT Self:EmployeeFil  := ""
DEFAULT Self:Registration := ""
DEFAULT Self:PD             := ""
DEFAULT Self:DaysAllow    := ""
DEFAULT Self:InitialDate  := ""
DEFAULT Self:TypeSolic    := ""

   If !empty(Self:DaysAllow) .and. !empty(::InitialDate)  
      dDataInicio := stod(Substr(::InitialDate,7,4) +Substr(::InitialDate,4,2) +Substr(::InitialDate,1,2))
      
      ::AvalMessage := fValIndeni(val(Self:DaysAllow), Self:EmployeeFil, Self:Registration, dDataInicio, Self:PD)
      ::AvalMessage :=  fTAcento(::AvalMessage)
   EndIf   

Return lRet
