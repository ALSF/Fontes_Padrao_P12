#INCLUDE "WSGPE100.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³WSGPE100  ³ Autor ³Marcelo Faria			³ Data ³06.05.2013  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel por transferencias                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Responsavel  ³ Data   ³Tarefa³  Motivo da Alteracao                     ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³ Allyson M    ³27/11/13³TIBOT0|Ajuste no conteudo padrao da variavel co- ³±±
±±³              ³        ³      |digo da empresa do metodo que busca as    ³±±
±±³              ³        ³      |transferencias da matricula               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSSTRUCT DataEmployeeTransf
    //Informacoes da matricula origem
    WSDATA Name											As String                  //Nome do funcionario
    WSDATA AdmissionDate								As String						  //Data de Admissao       
    WSDATA Department									As String		OPTIONAL       //Departamento do Funcionario
    WSDATA DescrDepartment								AS String		OPTIONAL       //Departamento
    WSDATA email											As String  	OPTIONAL       //email do funcionario
    WSDATA Situacao                 				As String  	OPTIONAL       //Codigo da Situacao do funcionario
    WSDATA DescSituacao             				As String		OPTIONAL       //Descricao da Situacao do funcionario
    WSDATA PositionId									As String  	OPTIONAL       //Codigo do cargo
    WSDATA Position                 				As String  	OPTIONAL       //descricao do cargo
    WSDATA CostId                   				As String  	OPTIONAL       //Codigo do Centro de Custo
    WSDATA Cost                     				As String		OPTIONAL       //Centro de Custo
    WSDATA FunctionId               				As String		OPTIONAL       //Codigo da funcao
    WSDATA FunctionDesc             				As String		OPTIONAL       //Funcao
    WSDATA Salary                   				As Float		OPTIONAL       //Salario
    WSDATA FilialDescr              				As String   OPTIONAL       //Descricao da Filial
    WSDATA CatFunc                  				As String   OPTIONAL       //categoria da funcao
    WSDATA CatFuncDesc              				As String   OPTIONAL       //descricao da categoria da funcao

    //Informacoes da transferencias
    WSDATA RecNumber                				As Integer  OPTIONAL       //descricao da categoria da funcao
    WSDATA TransfDate               				As STRING   OPTIONAL       //descricao da categoria da funcao
    WSDATA CompanyFrom              				As String   OPTIONAL       //descricao da categoria da funcao
    WSDATA FilTransfFrom            				As String   OPTIONAL       //descricao da categoria da funcao
    WSDATA RegTransfFrom          					As String   OPTIONAL       //descricao da categoria da funcao
    WSDATA CCTransfFrom             				As String   OPTIONAL       //descricao da categoria da funcao
    WSDATA CompanyTo               					As String   OPTIONAL       //descricao da categoria da funcao
    WSDATA FilTransfTo             					As String   OPTIONAL       //descricao da categoria da funcao
    WSDATA RegTransfTo             					As String   OPTIONAL       //descricao da categoria da funcao
    WSDATA CCTransfTo              					As String   OPTIONAL       //descricao da categoria da funcao
ENDWSSTRUCT                            

WSSTRUCT TEmployeeDataTransf
    WSDATA ListOfTransfers           				AS Array Of DataEmployeeTransf OPTIONAL
    WSDATA PagesTotal               				AS Integer                   OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Dados do Funcionario     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHEmployeeTransf DESCRIPTION STR0001 //Transferencias do Funcionario
	WSDATA Company                  				AS String OPTIONAL    //Empresa atual do funcionario
	WSDATA EmployeeFil 		 							AS String	 OPTIONAL    //Filial atual do funcionario
	WSDATA Registration		 							AS String	 OPTIONAL    //Matricula do funcionario
	WSDATA TypeTransf               					AS String OPTIONAL    //** Tipo de Transferencia ** 
                                                                    //0=todas; 1=Empresa; 2=todas Filiais; 
                                                                    //3=Filiais na mesma empresa; 4=C.Custo; 5=Maticula.
                                                                    //Para mais de um tipo, exemplo: 
                                                                    //Empresa + filial, informar "12"
    
   WSDATA EmployeeDataTransf        					AS TEmployeeDataTransf //Dados do funcionario
    	
	WSMETHOD GetEmployeeTransf DESCRIPTION STR0002 //Metodo que retorna as transferencias do funcionario
ENDWSSERVICE                                                                                                     

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetEmployeeTransf ³ Autor ³Marcelo Faria    ³Data ³28.03.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo que retorna transferencais do funcionario              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH 11.80                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetEmployeeTransf WSRECEIVE Company, EmployeeFil, Registration, TypeTransf WSSEND EmployeeDataTransf WSSERVICE RHEmployeeTransf
    Local lOK       := .T.
    Local lRet      := .T.
    Local nX        := 0
    Local aTransf   := {}
    Local aDados    := {}
    
    DEFAULT Self:Company        := cEmpAnt
    DEFAULT Self:EmployeeFil    := ""
    DEFAULT Self:Registration   := ""
    DEFAULT Self:TypeTransf     := ""

    ::EmployeeDataTransf:ListOfTransfers := {}

    If !Empty(Self:EmployeeFil) .AND. !Empty(Self:Registration) .AND. !Empty(Self:TypeTransf)
        If fGetFunc(Self:EmployeeFil, Self:Registration, @aDados)
            /*
            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            ³Verifica Transferencias do Funcionario ³
            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
            For nX := 1 To Len(Self:TypeTransf)
                DO CASE
                    CASE Substr( Self:TypeTransf, nX, 1 ) == "0"        //Todas
                            fTransfAll(@aTransf)
                    CASE Substr( Self:TypeTransf, nX, 1 ) == "1"        //Empresa
                            fTransfEmp(@aTransf)
                    CASE Substr( Self:TypeTransf, nX, 1 ) == "2" .Or.;  //Filial em todas as empresas 
                         Substr( Self:TypeTransf, nX, 1 ) == "3"        //Apenas Filial na mesma empresa 
                            fTransfFil(@aTransf)
                    CASE Substr( Self:TypeTransf, nX, 1 ) == "4"        //Centro de Custo
                            fTransfCC(@aTransf)
                    CASE Substr( Self:TypeTransf, nX, 1 ) == "5"        //Matricula 
                            fTransfMat(@aTransf)                       
                ENDCASE
            Next nX
           
				::EmployeeDataTransf:PagesTotal := Ceiling(Len(aTransf) / PAGE_LENGTH)

            If Len(aTransf) > 0
    
                For nX := 1 To Len(aTransf)
                   lOk := .T.  

	                //Trata retorno de transferencia apenas para mesma filial                 
	                If Self:TypeTransf == "3"

                        //Trata transferencias apenas para a mesma empresa
	                    If aTransf[nX][1] == Self:Company .And.; //Empresa De
	                       aTransf[nX][4] == Self:Company       //Empresa Para

								//Habilita registros apenas para matriculas diferentes da atual
    							If 	aTransf[nX][8] == Self:EmployeeFil .And.;	  //Filial De 
									aTransf[nX][9] == Self:Registration       //Matricula De
								   lOK := .F.	
								EndIF
                		 Else
                         lOK := .F.	
	                    EndIf                

	                EndIf


						If lOk
							DBSelectArea("SRA")
							SRA->( DBSetOrder(1) )
							If SRA->(dbSeek(aTransf[nX][8] + aTransf[nX][9]))
							   //If fGetFunc(aTransf[nX][8], aTransf[nX][9], @aDadosTransf)

								AAdd(::EmployeeDataTransf:ListOfTransfers, WsClassNew('DataEmployeeTransf'))
    							::EmployeeDataTransf:ListOfTransfers[nX]:Name						:= SRA->RA_NOME
								::EmployeeDataTransf:ListOfTransfers[nX]:email					:= SRA->RA_EMAIL
								::EmployeeDataTransf:ListOfTransfers[nX]:AdmissionDate			:= DTOC(SRA->RA_ADMISSA)
								::EmployeeDataTransf:ListOfTransfers[nX]:Department				:= SRA->RA_DEPTO
								::EmployeeDataTransf:ListOfTransfers[nX]:DescrDepartment		:= fDesc('SQB',SRA->RA_DEPTO,'SQB->QB_DESCRIC',,,1)

								::EmployeeDataTransf:ListOfTransfers[nX]:Situacao				:= SRA->RA_SITFOLH
								::EmployeeDataTransf:ListOfTransfers[nX]:DescSituacao   		:= AllTrim(fDesc("SX5", "31" + SRA->RA_SITFOLH, "X5DESCRI()", NIL, aTransf[nX][8]))

								::EmployeeDataTransf:ListOfTransfers[nX]:PositionId				:= SRA->RA_CARGO
								::EmployeeDataTransf:ListOfTransfers[nX]:Position				:= Alltrim(Posicione('SQ3',1,xFilial("SQ3")+SRA->RA_CARGO,'SQ3->Q3_DESCSUM'))
								::EmployeeDataTransf:ListOfTransfers[nX]:CostId					:= SRA->RA_CC
								::EmployeeDataTransf:ListOfTransfers[nX]:Cost						:= Alltrim(Posicione('CTT',1,xFilial("CTT",SRA->RA_FILIAL)+Alltrim(SRA->RA_CC),'CTT->CTT_DESC01'))

								::EmployeeDataTransf:ListOfTransfers[nX]:FunctionId				:= SRA->RA_CODFUNC
								::EmployeeDataTransf:ListOfTransfers[nX]:FunctionDesc			:= Alltrim(Posicione('SRJ',1,xFilial("SRJ")+SRA->RA_CODFUNC,'SRJ->RJ_DESC'))
								::EmployeeDataTransf:ListOfTransfers[nX]:Salary					:= SRA->RA_SALARIO

								::EmployeeDataTransf:ListOfTransfers[nX]:CatFunc			   		:= SRA->RA_CATFUNC
								::EmployeeDataTransf:ListOfTransfers[nX]:CatFuncDesc				:= Alltrim(FDESC("SX5","28"+SRA->RA_CATFUNC,"X5DESCRI()"))

								//Informacoes sobre a transferencia
								::EmployeeDataTransf:ListOfTransfers[nX]:RecNumber				:= aTransf[nX][13]
								::EmployeeDataTransf:ListOfTransfers[nX]:TransfDate				:= DTOS(aTransf[nX][7])
								::EmployeeDataTransf:ListOfTransfers[nX]:CompanyFrom   			:= aTransf[nX][1]
								::EmployeeDataTransf:ListOfTransfers[nX]:FilTransfFrom 			:= aTransf[nX][8]
								::EmployeeDataTransf:ListOfTransfers[nX]:FilialDescr				:= Alltrim(Posicione("SM0",1,aTransf[nX][8],"M0_FILIAL"))
								::EmployeeDataTransf:ListOfTransfers[nX]:RegTransfFrom 			:= aTransf[nX][9]
								::EmployeeDataTransf:ListOfTransfers[nX]:CCTransfFrom	 	 	:= aTransf[nX][3]

								::EmployeeDataTransf:ListOfTransfers[nX]:CompanyTo   	  		:= aTransf[nX][1]
								::EmployeeDataTransf:ListOfTransfers[nX]:FilTransfTo				:= aTransf[nX][8]
								::EmployeeDataTransf:ListOfTransfers[nX]:RegTransfTo				:= aTransf[nX][9]
								::EmployeeDataTransf:ListOfTransfers[nX]:CCTransfTo				:= aTransf[nX][3]
							EndIF
						EndIf

                Next nX
            EndIf
    
        EndIf    
    EndIf
    	
Return lRet
