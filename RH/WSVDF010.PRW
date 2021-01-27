#INCLUDE "WSVDF010.CH"
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
±±³Funcao    ³WSVDF010  ³ Autor ³Marcelo Faria          ³ Data ³14.08.2013  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pela Alteracao de Jornada            ³±±
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
WSSTRUCT TVDFJourney
    WSDATA Journey                       As String                 //Jornada solicitada
ENDWSSTRUCT

WSSTRUCT TStageData
    WSDATA Workflow                      As String                 //Codigo do workflowFilial do funcionario
    WSDATA Stage                         As String                 //Codigo da etapa do workflow
    WSDATA Destination                  As String  
    WSDATA Department                   As String  OPTIONAL       //codigo do departamento
    WSDATA Responsible                  As String  OPTIONAL       //primeiro ou segundo responsavel pelo depto       
    WSDATA ResponsibleFil               As String OPTIONAL       //filial do esponsavel pelo depto       
    WSDATA ResponsibleReg               As String OPTIONAL       //primeiro ou segundo responsavel pelo depto       
    WSDATA ApproverLevel                As String OPTIONAL        //nivel de aprovacao       
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Alteracao de Jornada     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHVDFJourney                DESCRIPTION STR0001       //Controle de Jornada
    WSDATA WsNull                       As String  OPTIONAL       //NULL
    WSDATA EmployeeFil                 AS String OPTIONAL       //Filial do funcionario
    WSDATA Registration                AS String OPTIONAL       //Matricula do funcionario

    WSDATA CurrentWeekJourney         AS String OPTIONAL        //Jornada atual do funcionario
    WSDATA Workflow                     AS String OPTIONAL        //Codigo do workflow
    WSDATA Compensate                   AS Boolean OPTIONAL      //Indenizado
    WSDATA StarterBranch               AS String OPTIONAL        //Filial de quem está fazendo a solicitacao 
    WSDATA StarterRegistration        AS String OPTIONAL        //Matricula de quem está fazendo a solicitacao
    WSDATA Stage                        AS String  OPTIONAL       //Item da etapa do workflow
    WSDATA StageData                    As TStageData             //Dados da etapa do workflow

    WSDATA Request                      AS TRequest
    WSDATA VDFJourneyRequest           AS TVDFJourney OPTIONAL

    WSMETHOD AddVDFJourneyRequest     DESCRIPTION STR0002       //"Metodo que Inclui uma solicitacao de alteracao de jornada"
    WSMETHOD GetJourney                DESCRIPTION STR0005       //"Metodo que retorna jornada atual do participante"    
    WSMETHOD GetWorkflowStage         DESCRIPTION STR0004       //"Metodo que retorna dados da etapa do workflow"    
ENDWSSERVICE 


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³AddVDFJourneyRequest ³ Autor ³Marcelo Faria       ³Data ³14.08.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para gravacao da solicitacao de alteracao de jornada         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD AddVDFJourneyRequest WSRECEIVE Request, VDFJourneyRequest WSSEND WsNull WSSERVICE RHVDFJourney
    Local nReturnCode
    Local nSaveSX8 := GetSX8Len()

    Self:Request:RequestType        := WSClassNew("TRequestType")
    Self:Request:Status              := WSClassNew("TRequestStatus")
    
    Self:Request:Code                := GetSX8Num("RH3", "RH3_CODIGO") 
    Self:Request:RequestType:Code  := "N"  ///Alteracao de jornada
    Self:Request:ResponseDate      := CTod("")
    Self:Request:Status:Code       := "1"
    Self:Request:RequestDate       := dDataBase    
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
            SetSoapFault("AddVDFJourneyRequest", STR0003)
            Break
        EndIf

        nReturnCode:= fAddVDFJourneyRequest(Self:Request, Self:VDFJourneyRequest, Self:Request:Code, OPERATION_INSERT)
        If nReturnCode > 0
            SetSoapFault("AddVDFJourneyRequest", STR0003)
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


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetJourney           ³ Autor ³Marcelo Faria       ³Data ³16.09.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar a jornada atual do participante                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetJourney WSRECEIVE EmployeeFil, Registration WSSEND CurrentWeekJourney WSSERVICE RHVDFJourney
Local lRet      := .T.
Local cQuerySRA := GetNextAlias()

    BeginSql alias cQuerySRA
        SELECT SRA.RA_HRSEMAN
        FROM %table:SRA% SRA
        WHERE SRA.RA_FILIAL  = %exp:Self:EmployeeFil% AND
              SRA.RA_MAT    = %exp:Self:Registration% AND
              SRA.%notDel%     
    EndSql 

    If !(cQuerySRA)->(Eof())
        ::CurrentWeekJourney  := Str((cQuerySRA)->RA_HRSEMAN)
    Else
        ::CurrentWeekJourney  := ""
    EndIf        
    
    (cQuerySRA)->( DbCloseArea() )

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetWorkflowStage     ³ Autor ³Marcelo Faria       ³Data ³28.08.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para buscar a etapa do workflow                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Portal RH Vida Funcional                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetWorkflowStage WSRECEIVE EmployeeFil, Registration, Workflow, Stage, Compensate, StarterBranch, StarterRegistration WSSEND StageData WSSERVICE RHVDFJourney
Local aWorkMethod := {}
Local lRet         := .T.

DEFAULT ::Compensate           := .F.
DEFAULT ::StarterBranch        := ::EmployeeFil
DEFAULT ::StarterRegistration := ::Registration

  aWorkMethod      := fBuscaWorkflow(::StarterBranch, ::StarterRegistration, ::Workflow, ::Stage, ::Compensate)

  If Len(aWorkMethod) > 0
     ::StageData:Workflow            := aWorkMethod[1]
     ::StageData:Stage               := aWorkMethod[2]
     ::StageData:Destination        := aWorkMethod[3] 
     ::StageData:ApproverLevel      := aWorkMethod[4]
     ::StageData:Department         := aWorkMethod[5]
     ::StageData:Responsible        := aWorkMethod[6]       
     ::StageData:ResponsibleFil     := aWorkMethod[7]       
     ::StageData:ResponsibleReg     := aWorkMethod[8]       
  Else
     SetSoapFault("GETWorkflowStage",STR0005) // "Departamento nao localizado!" 
     lRet := .F.
  EndIf

Return lRet


Function fBuscaWorkflow(Branch, Register, Workflow, Stage, Compensate)
Local aWorkFunc  := {}
Local aRetSubst  := {}
Local cQueryRIB  := GetNextAlias()
Local cQueryRIC  := GetNextAlias()
Local cQuerySQB  := GetNextAlias()
Local cQuery2SQB := GetNextAlias()

DEFAULT Compensate := .F.

    // Avalia tabela RIB(Workflow) para verificar apenas indenizados
    If Compensate
        BEGINSQL ALIAS cQueryRIB
            SELECT *
            FROM %table:RIB% RIB
            WHERE  RIB_CODIGO = %exp:Workflow%   AND
                    RIB.%notDel%
        ENDSQL            

        If !(cQueryRIB)->(Eof())
           If  (cQueryRIB)->RIB_ETPIND == 0
               Stage := "000"
           Else
               Stage := STRZERO((cQueryRIB)->RIB_ETPIND, 3)
           EndIf
        EndIf
    EndIF
        
                            
    BEGINSQL ALIAS cQueryRIC
        SELECT *
        FROM %table:RIC% RIC
        WHERE  RIC_CODIGO = %exp:Workflow%   AND
                RIC_ETAPA  = %exp:Stage%      AND
                RIC.%notDel%
    ENDSQL            

    If !(cQueryRIC)->(Eof())
       aAdd( aWorkFunc, (cQueryRIC)->RIC_CODIGO )
       aAdd( aWorkFunc, (cQueryRIC)->RIC_ETAPA )
       aAdd( aWorkFunc, (cQueryRIC)->RIC_DEST )

       If (cQueryRIC)->RIC_DEST == "1" //1=Departamento;

          //Busca responsavel do Departamento 
          BEGINSQL alias cQuerySQB
              SELECT * 
                  FROM %table:SQB% SQB
                  WHERE SQB.QB_FILIAL = %xfilial:SQB%                  AND
                         SQB.QB_DEPTO  = %exp:(cQueryRIC)->RIC_DEPTO% AND
                         SQB.%notDel%                   
          EndSql
                    
          If !(cQuerySQB)->(Eof())
              aAdd( aWorkFunc, "0" )                                   // pos[4]
              aAdd( aWorkFunc, (cQueryRIC)->RIC_DEPTO )             // pos[5] 
              
              If (cQueryRIC)->RIC_RESP == "2" //Segundo responsavel
                  If !empty((cQuerySQB)->QB_MATRSP2)
                      //Avalia substituicao  
                      aRetSubst := fVerRI8((cQuerySQB)->QB_FILRSP2, (cQuerySQB)->QB_MATRSP2, dDataBase, dDataBase, .T., .F., .F., .T., .F., .T.)
                      If ValType( aRetSubst ) != "A"
                         aRetSubst  := {}
                      EndIf

                      aAdd( aWorkFunc, "2" )                              // pos[6]
                      If Len(aRetSubst) > 0
                          aAdd( aWorkFunc, aRetSubst[1][7] )            // pos[7]  
                          aAdd( aWorkFunc, aRetSubst[1][8] )            // pos[8]
                      Else  
                          aAdd( aWorkFunc, (cQuerySQB)->QB_FILRSP2 )   // pos[7]  
                          aAdd( aWorkFunc, (cQuerySQB)->QB_MATRSP2 )   // pos[8]
                      EndIf    
                  Else
                      //Avalia substituicao  
                      aRetSubst := fVerRI8((cQuerySQB)->QB_FILRESP, (cQuerySQB)->QB_MATRESP, dDataBase, dDataBase, .T., .F., .F., .T., .F., .T.)
                      If ValType( aRetSubst ) != "A"
                         aRetSubst  := {}
                      EndIf

                      aAdd( aWorkFunc, "1" )                             // pos[6]
                      If Len(aRetSubst) > 0
                          aAdd( aWorkFunc, aRetSubst[1][7] )            // pos[7]  
                          aAdd( aWorkFunc, aRetSubst[1][8] )            // pos[8]
                      Else  
                          aAdd( aWorkFunc, (cQuerySQB)->QB_FILRESP )   // pos[7]  
                          aAdd( aWorkFunc, (cQuerySQB)->QB_MATRESP )   // pos[8]
                      EndIf    
                  EndIf    
              Else  
                  //Avalia substituicao  
                  aRetSubst := fVerRI8((cQuerySQB)->QB_FILRESP, (cQuerySQB)->QB_MATRESP, dDataBase, dDataBase, .T., .F., .F., .T., .F., .T.)
                  If ValType( aRetSubst ) != "A"
                     aRetSubst  := {}
                  EndIf

                  aAdd( aWorkFunc, "1" )                                  // pos[6]
                  If Len(aRetSubst) > 0
                      aAdd( aWorkFunc, aRetSubst[1][7] )                // pos[7]  
                      aAdd( aWorkFunc, aRetSubst[1][8] )                // pos[8]
                  Else  
                      aAdd( aWorkFunc, (cQuerySQB)->QB_FILRESP )       // pos[7]  
                      aAdd( aWorkFunc, (cQuerySQB)->QB_MATRESP )       // pos[8]
                  EndIf    
              EndIF
          Else
            aWorkFunc  := {}
          EndIf

          (cQuerySQB)->(dbCloseArea())
          //******************************************************* 
          
       Else
          If (cQueryRIC)->RIC_DEST == "2" //2=Monitor(Remote); - Etapa do workflow direcionada para o monitor(remote)
              aAdd( aWorkFunc, "98" ) // pos[4] - Direcionamento para o remote (RH) => RH3_STATUS=5 (aguardando aprovacao do RH)
              aAdd( aWorkFunc, ""   ) // pos[5]  
              aAdd( aWorkFunc, ""   ) // pos[6]  
              aAdd( aWorkFunc, ""   ) // pos[7]  
              aAdd( aWorkFunc, ""   ) // pos[8]
          Else
          
              If (cQueryRIC)->RIC_DEST == "3" //3=Superior Imediato;

                  //Busca Superior Imediato
                  //Branch-Register: Filial e Matricula de quem fez a solicitacao
                  BEGINSQL alias cQuerySQB
                          SELECT SRA.RA_FILIAL,SRA.RA_MAT ,SRA.RA_DEPTO, SQB.QB_DEPTO, SQB.QB_FILRESP, SQB.QB_MATRESP, SQB.QB_DEPSUP
                          FROM %table:SRA% SRA  
                          INNER JOIN %table:SQB% SQB
                               ON SRA.RA_DEPTO = SQB.QB_DEPTO 
                          WHERE SRA.RA_FILIAL = %exp:Branch%   AND
                                 SRA.RA_MAT    = %exp:Register% AND
                                 SRA.%notDel%                     AND
                                 SQB.%notDel%                   
                  EndSql
 
                            
                  If !(cQuerySQB)->(Eof())

                      //verifica se o solicitante é o proprio responsavel pelo departamento
                      //caso positivo busca superior imediato lendo novamente a SQB com o departamento superior.
                      If (cQuerySQB)->QB_MATRESP == Register

                          //Busca responsavel do Departamento 
                          BEGINSQL alias cQuery2SQB
                              SELECT * 
                                  FROM %table:SQB% SQB
                                  WHERE SQB.QB_FILIAL = %xfilial:SQB%                  AND
                                         SQB.QB_DEPTO  = %exp:(cQuerySQB)->QB_DEPSUP% AND
                                         SQB.%notDel%                   
                          EndSql
                          
                          If !(cQuery2SQB)->(Eof())
                              aAdd( aWorkFunc, "0" )                         // pos[4]
                              aAdd( aWorkFunc, (cQuery2SQB)->QB_DEPTO )   // pos[5] 
                              aAdd( aWorkFunc, "1" )                         // pos[6]

                              //Avalia substituicao  
                              aRetSubst := fVerRI8((cQuery2SQB)->QB_FILRESP, (cQuery2SQB)->QB_MATRESP, dDataBase, dDataBase, .T., .F., .F., .T., .F., .T.)
                              If ValType( aRetSubst ) != "A"
                                 aRetSubst  := {}
                              EndIf

                              If Len(aRetSubst) > 0
                                  aAdd( aWorkFunc, aRetSubst[1][7] )            // pos[7]  
                                  aAdd( aWorkFunc, aRetSubst[1][8] )            // pos[8]
                              Else  
                                  aAdd( aWorkFunc, (cQuery2SQB)->QB_FILRESP )  // pos[7]  
                                  aAdd( aWorkFunc, (cQuery2SQB)->QB_MATRESP )  // pos[8]
                              EndIf
                          Else
                             aWorkFunc  := {}
                          EndIf

                      Else
                          aAdd( aWorkFunc, "0" )                             // pos[4]
                          aAdd( aWorkFunc, (cQuerySQB)->QB_DEPTO )        // pos[5] 
                          aAdd( aWorkFunc, "1" )                             // pos[6]

                          //Avalia substituicao  
                          aRetSubst := fVerRI8((cQuerySQB)->QB_FILRESP, (cQuerySQB)->QB_MATRESP, dDataBase, dDataBase, .T., .F., .F., .T., .F., .T.)
                          If ValType( aRetSubst ) != "A"
                             aRetSubst  := {}
                          EndIf

                          If Len(aRetSubst) > 0
                              aAdd( aWorkFunc, aRetSubst[1][7] )            // pos[7]  
                              aAdd( aWorkFunc, aRetSubst[1][8] )            // pos[8]
                          Else  
                              aAdd( aWorkFunc, (cQuerySQB)->QB_FILRESP )   // pos[7]  
                              aAdd( aWorkFunc, (cQuerySQB)->QB_MATRESP )   // pos[8]
                          EndIf
                      EndIf        
                  Else
                    aWorkFunc  := {}
                  EndIf
              
              EndIf
                      
          EndIf  
       EndIf 
    Else
        // Nao existem essa nova etapa do processo de aprovacao
        // O processo esta finalizado, e sera direcionado ao RH para finalizar a solicitacao        

        aAdd( aWorkFunc, ""   ) // pos[1]
        aAdd( aWorkFunc, ""   ) // pos[2]
        aAdd( aWorkFunc, ""   ) // pos[3]                
        aAdd( aWorkFunc, "99" ) // pos[4] - Direcionamento para o remote (RH) => RH3_STATUS=4 (aguardando efetivacao do RH)       
        aAdd( aWorkFunc, ""   ) // pos[5]  
        aAdd( aWorkFunc, ""   ) // pos[6]  
        aAdd( aWorkFunc, ""   ) // pos[7]  
        aAdd( aWorkFunc, ""   ) // pos[8]  
    EndIf
    
    (cQueryRIC)->(dbCloseArea())

Return aWorkFunc

