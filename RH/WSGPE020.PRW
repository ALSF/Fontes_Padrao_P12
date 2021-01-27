#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSGPE020.CH"

#DEFINE  PAGE_LENGTH 10

#DEFINE OPERATION_INSERT  1
#DEFINE OPERATION_UPDATE  2
#DEFINE OPERATION_APPROVE 3
#DEFINE OPERATION_REPROVE 4
#DEFINE OPERATION_DELETE  5

//WsClient_WsRHRequest.prx

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WSGPE020 ³ Autor ³ Rogerio Ribeiro da Cruz        ³ Data ³ 01/12/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelas Solicitacoes                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador     ³ Data       ³ FNC            ³ Motivo da Alteracao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson Campos   |30/04/14    |TPKFN9          |Replica das alterações realizadas ³±±
±±³                 |            |                |pela manutenção até a dt 25/03/14 ³±±
±±³                 |            |                |chamado TPBAFB, changeset 215445  ³±±
±±³                 |            |                |na P11.80                         ³±±
±±³Flavio Correa    |11/08/14    |                |Integração Fluig                  ³±±
±±³Renan Borges     |16/03/2015  |TRAP10          |Criada função para posicionar no  ³±±
±±³                 |            |                |menu correto sempre que for reali-³±±
±±³                 |            |                |zar uma aprovação.                ³±±
±±³ Joao Balbino    | 05/11/2015 |TTSGZ4          |Alterada o metodo GetDescription  ³±±
±±³                 |            |                |para validar se o motivo é um pré ³±±
±±³                 |            |                |abono                             ³±±
±±³Matheus M.       |05/11/2015  |TTAQXT          |Criada opção de inclusão de       ³±±
±±³                 |            |                |alteração cadastral eSocial 2.1   ³±±
±±³Esther V.        |11/12/2015  |TTDITV          |Incluido tratamento ColumnPos()   ³±±
±±³                 |            |                |nos campos RH3_EMP, RH3_EMPINI,   ³±±
±±³                 |            |                |RH3_EMPAPR, RGK_EMP               ³±±
±±³Vitor Pires      |29/12/2015  |TTUREY          |Ajuste de exib.ordem decrescente  ³±±
±±³Matheus M.       |01/02/2016  |TUGXBB          |Realizado ajuste nas opções de fil³±±
±±³			        |01/02/2016  |TUGXBB          |tro, ajuste para tratar o valor da³±±
±±³			        |01/02/2016  |TUGXBB          |variável lQryResp para não gerar  ³±±
±±³ 		        |01/02/2016  |TUGXBB          |páginação quando o usuário não    ³±±
±±³			        |01/02/2016  |TUGXBB          |possuir direito de visualizar to- ³±±
±±³			        |01/02/2016  |TUGXBB          |das as solicitações.				 ³±±
±±³Matheus M.       |08/06/2016  |TVITKU          |Realizado criação do método       ³±±
±±³			        |            |	              |GETJUSTIFICATION para não permitir³±±
±±³			        |            |	              |incluir duas solicitações de abono³±±
±±³			        |            |	              |para a mesma hora e data.		 ³±±
±±³Eduardo K.	    |18/05/2016  |TVFKXG	      |Tratamento para o campo QB_KEYINI ³±±
±±³                 |            |                |  		                         ³±±
±±³Flavio Correa    |04/07/2016  |TVN902	      |Ajuste no filtro de busca de      ³±±
±±³                 |            |                |departamentos que o usuario é     ³±±
±±³                 |            |                |responsável considerando sua      ³±±
±±³                 |            |                |filial.                           ³±±
±±³João Balbino     |27/07/2016  |TVRGP5	      |Tratamento para o posicionamento  ³±±
±±³                 |            |                |correto na utilização do xFilial. ³±±
±±³Esther Viveiro   |30/08/2016  |     TVWNFA     |Tratamento para gravar a filial   ³±±
±±³                 |            |                |correta na tabela RDY que guarda o³±±
±±³                 |            |                |conteduo do campo OBSERVACAO da   ³±±
±±³                 |            |                |Solic. de Ferias.                 ³±±
±±³Renan Borges     |27/09/2016  |TVWVWI          |Ajuste ao utilizar Visão por      ³±±
±±³                 |            |                | Departamento e realizar a soli-  ³±±
±±³                 |            |                |tação para um membro da equipe,   ³±±
±±³                 |            |                |seja carregado o aprovador cor-   ³±±
±±³                 |            |                |retamente, quando o responsável   ³±±
±±³                 |            |                |pelo departamento estiver em um   ³±±
±±³                 |            |                |departamento diferente ao do so-  ³±±
±±³                 |            |                |licitante. Conceito utilizado     ³±±
±±³                 |            |                |também para aumento de quadro e   ³±±
±±³                 |            |                |novas contratações.               ³±±
±±³Eduardo K.       |23/08/2016  |TWKWR9          |Ajuste p/ permitir solicitar justi³±±
±±³                 |            |                |ficativa de abono para a mesma    ³±±
±±³                 |            |                |hora e data caso a anterior tenha ³±±
±±³                 |            |                |sido reprovada.                   ³±±
±±³Matheus M.       |16/11/2016  |	              |Realizado criação do método       ³±±
±±³                 |            |	              |GETDESC para buscar descrições    ³±±
±±³                 |            |	              |tanto de uma tabela genérica SX5  ³±±
±±³                 |            |	              |como para campos SX3.             ³±±
±±³Eduardo K.       |10/03/2017  |MPRIMESP-9307   |Ajuste p/ gravação do campo       ³±±
±±³                 |            |                | RA3_PORTAL                       ³±±
±±³Willian U.       |06/06/2017  |DRHPONTP-731    |Réplica DRHPONTP-704: Incluido    ³±±
±±³                 |            |	              |P.E. WSGPEINSC p/ deixar disponi  ³±±
±±³                 |            |	              |vel a Filial e o codigo da vaga   ³±±
±±³                 |            |	              |apos a inscricao.                 ³±±
±±³Willian U        |11/09/2017  |DRHPONTP-1593   |Ajuste para que na Justificativa  ³±±
±±³                 |            |                |de Pré-Abono não seja possível    ³±±
±±³                 |            |                |cadastrar mais de uma solicita-   ³±±
±±³                 |            |                |ção para um mesmo período de da-  ³±±
±±³                 |            |                |ta ou hora já solicitado.         ³±±
±±³Wesley Alves     |11/02/2019  |DRHGCH-8317     |Criação do P.E. WSGPEVALVAC       ³±±
±±³Pereira          |            |                |para que o usuario possa validar  ³±±
±±³(WAP)            |            |                |a data do inicio do período de    ³±±
±±³                 |            |                |gozo das férias                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSSTRUCT TRequest
	WSDATA Branch									As String					OPTIONAL	//Filial
	WSDATA Code	 									As String					OPTIONAL	//Codigo da Solicitacao
	WSDATA Registration								As String								//Codigo da matricula
	WSDATA RequestDate 								As Date				   		OPTIONAL	//Data da requisicao
	WSDATA ResponseDate								As Date				   		OPTIONAL	//Data do atendimento
	WSDATA Status    				   				As TRequestStatus			OPTIONAL	//Status da solicitacao	- 1=Solicitada;2=Atendida pelo RH;3=Reprovada;4=Aguardando Efetivacao do RH
	WSDATA RequestType								As TRequestType	 			OPTIONAL 	//Tipo da Solicitacao: 1=Documentos;2=Alt.Cadastral;3=Postos;4=Transferencia;5=Admissao;6=Demissao;7=Acao Salarial
	WSDATA StarterLevel								As Integer			    	OPTIONAL	//Nivel Inicial de Aprovacao
	WSDATA StarterBranch							As String					OPTIONAL	//Filial do Solicitante
	WSDATA StarterRegistration						As String					OPTIONAL	//Matricula do Solicitante
	WSDATA StarterKey				   				As String					OPTIONAL	//Chave de busca do solicitante
	WSDATA ApproverLevel							As Integer			    	OPTIONAL	//Nivel de aprovacao atual
	WSDATA ApproverBranch							As String					OPTIONAL	//Filial do Aprovador
	WSDATA ApproverRegistration						As String					OPTIONAL	//Matricula do Aprovador
	WSDATA ApproverName	   							As String					OPTIONAL	//Nome do Aprovador
	WSDATA ApproverSubBranch						As String					OPTIONAL	//Filial do Aprovador Substituto
	WSDATA ApproverSubRegistration					As String					OPTIONAL	//Matricula do Aprovador Substituto
	WSDATA Vision									As String					OPTIONAL	//Visao para aprovacao
	WSDATA Source									As String					OPTIONAL	//Origem - Se passou pelo RH ou não
	WSDATA WFID		        						As String					OPTIONAL	//Processo do workflow
	WSDATA Observation								As String								//Observacao
	WSDATA Items									As Array Of TRequestItem	OPTIONAL 	//Items
	WSDATA ParticipantRH        					As String					OPTIONAL
	WSDATA WFAprov                 					As String              		OPTIONAL  	//Gestao Publica - Workflow de aprovacao
	WSDATA WFStage                					As String              		OPTIONAL  	//Gestao Publica - Etapa Atual do Workflow de aprovacao
	WSDATA ORIGEM                 					As String              		OPTIONAL  	//1=Portal,2=FLUIG
	WSDATA NroFluig                					As integer              	OPTIONAL  	//numero Fluig
	WSDATA Empresa                					As String              		OPTIONAL  	//empresa solicitante
	WSDATA EmpresaIni                				As String              		OPTIONAL  	//empresa solicitado por
	WSDATA EmpresaAPR                				As String              		OPTIONAL  	//empresa aprovador
	WSDATA DepartAPR                				As String              		OPTIONAL  	//Departamento que o aprovador esta como responsável.
ENDWSSTRUCT

WSSTRUCT TRequestItem
	WSDATA Branch									As String					OPTIONAL
	WSDATA RequestCode								As String
	WSDATA Sequence									As Integer
	WSDATA FieldName				   				As String
	WSDATA FieldDescription							As String					OPTIONAL
	WSDATA PreviousValue							As String					OPTIONAL
	WSDATA NewValue									As String
ENDWSSTRUCT

WSSTRUCT TPostRequest
	WSDATA Branch									As String	OPTIONAL	//Filial
	WSDATA Code		    							As String	OPTIONAL	//Codigo da Solicitacao de Posto
	WSDATA DepartmentCode							As String				//Codigo do Departamento
	WSDATA CostCenterCode							As String	OPTIONAL	//Codigo do Centro de Custo
	WSDATA RoleCode									As String	OPTIONAL	//Codigo da Funcao
	WSDATA PositionCode								As String	OPTIONAL	//Codigo do Cargo
	WSDATA ProcessCode								As String	OPTIONAL	//Codigo do Processo da Folha
	WSDATA Salary									As Float	OPTIONAL	//Salario
	WSDATA PostType									As String				//Tipo de posto: 1=Individual;2=Generico
	WSDATA ContractType								As String	OPTIONAL	//Tipo de contrato: 1=Indeterminado;2=Determinado
	WSDATA Quantity									As Integer			    //Quantidade de vagas do posto
	WSDATA JustificationCode		   				As String				//Codigo da Justificativa
	WSDATA RequestType								As String	OPTIONAL	//Tipo da Solicitacao: 1=Criacao;2=Aumento
	WSDATA PostCode									As String	OPTIONAL	//Codigo do posto para solicitacao de aumento
	WSDATA NewContract								As String	OPTIONAL	//Gera Nova Contratação: 1=Sim;2=Nao
ENDWSSTRUCT

WSSTRUCT TDescription
	WSDATA Value									AS String Optional
	WSDATA Alias									AS String Optional
	WSDATA Registration								As String Optional
ENDWSSTRUCT

WSSTRUCT TSalaryChange
	WSDATA Branch					   				As String				//Filial
	WSDATA Registration								As String				//Codigo da matricula
	WSDATA Name     		  		   				As String				//Nome do funcionario
	WSDATA ChangeType				   				As String				//Tipo da alteração
	WSDATA NewRoleCode								As String	OPTIONAL	//Nova Função
	WSDATA NewPositionCode							As String	OPTIONAL	//Novo Cargo:
	WSDATA Percentage				   				As Float	OPTIONAL	//Percentual de Aumento:
	WSDATA NewSalary				   				As Float				//Novo Salário:
	WSDATA Category									As String	OPTIONAL	//Categoria:
ENDWSSTRUCT

WSSTRUCT TTermination
	WSDATA Type										As String				//Tipo de desligamento
	WSDATA NewHire									As String				//Gera Nova Contratação: 1=Sim;2=Nao
ENDWSSTRUCT

WSSTRUCT TNewContract
	WSDATA DepartmentCode							As String				//Codigo do Departamento
	WSDATA Post		 								As String				//Codigo do posto
	WSDATA Type										As String				//Tipo: 1=Nova contracao;2=Substituicao
	WSDATA ReplacedBranch							As String				//Filial do funcionario substituido
	WSDATA ReplacedRegistration						As String				//Matricula do funcionario substituido
ENDWSSTRUCT

WSSTRUCT TTransfer
	WSDATA Company									As String				//Empresa
	WSDATA Branch			   		   				As String				//Filial
	WSDATA Registration								As String				//Codigo da matricula
	WSDATA Name     		  		   				As String				//Nome do funcionario
	WSDATA CostCenter				   				As String				//Centro de Custo
	WSDATA Department				   				As String				//Departamento
	WSDATA Process									As String				//Processo
	WSDATA Post										As String				//Posto
ENDWSSTRUCT

WSSTRUCT TFieldsExibition
	WSDATA Pis										As String	     		//Data inicial da ocorrencia
	WSDATA Cpf	     		   						As String		      	//Data final da ocorrencia
	WSDATA NomMae									As String				//Hora de inicio
	WSDATA NomPai				    				As String				//Hora de termino
	WSDATA NomComp									As String				//Motivo
ENDWSSTRUCT

/*************************
 - ESTRUTURA DE GRAVAÇÃO
 - ALTERAÇÃO ESOCIAL 2.1
*************************/

WSSTRUCT TFieldsInput


	// -------------------------------

	// - ABA ENDEREÇO

	// -------------------------------
	WSDATA paisExt 									AS String OPTIONAL
	WSDATA tipoLogradouro							AS String OPTIONAL
	WSDATA descLogradouro							AS String OPTIONAL
	WSDATA logrDesc									AS String OPTIONAL
	WSDATA complemento								AS String OPTIONAL
	WSDATA bairro									AS String OPTIONAL

	WSDATA numLogradouro							AS String OPTIONAL
	WSDATA cep										AS String OPTIONAL
	WSDATA codMun									AS String OPTIONAL

	// -------------------------------

	// - ABA CADASTRAIS

	// -------------------------------
	WSDATA nacionalidade							AS String OPTIONAL
	WSDATA codMunCad								AS String OPTIONAL
	WSDATA email									AS String OPTIONAL
	WSDATA emailAlt									AS String OPTIONAL
	WSDATA portDef									AS String OPTIONAL
	WSDATA obsDef									AS String OPTIONAL
	WSDATA estCiv									AS String OPTIONAL
	WSDATA grauInst									AS String OPTIONAL
	WSDATA paisOrigem								AS String OPTIONAL
	WSDATA recAposen								AS String OPTIONAL
	WSDATA numProcMenor								AS String OPTIONAL
	WSDATA dddFone									AS String OPTIONAL
	WSDATA telefone									AS String OPTIONAL
	WSDATA dddCel									AS String OPTIONAL
	WSDATA celular									AS String OPTIONAL

	// -------------------------------

	// - ABA DOCUMENTOS

	// -------------------------------

	WSDATA habilit 									AS String OPTIONAL
	WSDATA cnhOrg									AS String OPTIONAL
	WSDATA categoriaCnh								AS String OPTIONAL
	WSDATA dtEmCnh									AS Date   OPTIONAL
	WSDATA dtVcCnh									AS Date   OPTIONAL
	WSDATA ufCnh									AS String OPTIONAL

	WSDATA codigoInsc								AS String OPTIONAL
	WSDATA oCEmis									AS String OPTIONAL
	WSDATA oCDtExp									AS Date   OPTIONAL
	WSDATA oCDtVal									AS Date   OPTIONAL

	WSDATA numCp									AS String OPTIONAL
	WSDATA serCp 									AS String OPTIONAL
	WSDATA ufCp										AS String OPTIONAL

	WSDATA numRic									AS String OPTIONAL
	WSDATA emisRic 									AS String OPTIONAL
	WSDATA ufRic									AS String OPTIONAL
	WSDATA cdMuRic									AS String OPTIONAL
	WSDATA dExPric									AS Date   OPTIONAL

	// -------------------------------

	// - ABA ESTRANGEIRO

	// -------------------------------

	WSDATA rne										AS String OPTIONAL
 	WSDATA rneOrg									AS String OPTIONAL
	WSDATA rneDexp									AS Date   OPTIONAL
	WSDATA casadBr									AS String OPTIONAL
	WSDATA filhoBr									AS String OPTIONAL
	WSDATA DatCheg									AS Date   OPTIONAL
	WSDATA claseEst									AS String OPTIONAL

	// -------------------------------

	// - ABA DEPENDENTES
	// - FUTURA IMPLEMENTAÇÃO.

	// -------------------------------

	WSDATA nome										AS String OPTIONAL
	WSDATA dtNasc									AS Date   OPTIONAL
	WSDATA sexo										AS String OPTIONAL
	WSDATA grauPar									AS String OPTIONAL
	WSDATA tpDep									AS String OPTIONAL
	WSDATA tipSf									AS String OPTIONAL
	WSDATA tipIr									AS String OPTIONAL
	WSDATA locNasc									AS String OPTIONAL
	WSDATA cartori									AS String OPTIONAL
	WSDATA nRegCar									AS String OPTIONAL
	WSDATA numLivr									AS String OPTIONAL
	WSDATA numFolh									AS String OPTIONAL
	WSDATA dtEntra									AS Date   OPTIONAL
	WSDATA dtBaixa									AS Date   OPTIONAL
	WSDATA nuMat									AS String OPTIONAL
	WSDATA cic										AS String OPTIONAL
	WSDATA Anexo									AS String OPTIONAL

ENDWSSTRUCT

WSSTRUCT TScheduleJustification
	WSDATA InitialDate								As Date	     		//Data inicial da ocorrencia
	WSDATA FinalDate				   				As Date		      	//Data final da ocorrencia
	WSDATA InitialTime								As Float			//Hora de inicio
	WSDATA FinalTime				   				As Float			//Hora de termino
	WSDATA Reason					   				As String			//Motivo
ENDWSSTRUCT

WSSTRUCT TTrainingReservation
	WSDATA Branch					  				AS String
	WSDATA Registration								AS String
	WSDATA CalendarCode								AS String
	WSDATA CourseCode				   				AS String
	WSDATA CourseClass								AS String
ENDWSSTRUCT

WSSTRUCT TRequestStatus
	WSDATA Code      				   				As String
	WSDATA Description								As String OPTIONAL
ENDWSSTRUCT

WSSTRUCT TRequestType
	WSDATA Code				  						As String
	WSDATA Description  			   				As String
	WSDATA Link										As String OPTIONAL
ENDWSSTRUCT

WSSTRUCT TRequestHistory
	WSDATA Code	 									As String 	OPTIONAL	//Codigo da Solicitacao
	WSDATA TypeCode									As String 	OPTIONAL	//Tipo da Solicitacao
	WSDATA DescriptionType							As String 	OPTIONAL	//Descricao Tipo da Solicitacao
	WSDATA StatusCode				   				As String 	OPTIONAL	//Status atual da Solicitacao
	WSDATA DescriptionStatus		   				As String 	OPTIONAL	//Descricao Atual da Solicitacao
	WSDATA PetitionerBranch							As String				//Filial de quem solicitou
	WSDATA PetitionerRegistration					As String				//matricula de quem solicitou
	WSDATA PetitionerName							As String				//nome de quem solicitou
	WSDATA Branch					   				As String		   		//Filial solicitado
	WSDATA Registration								As String			   	//Codigo da matricula solicitado
	WSDATA Name										As String				//nome do Funcionario solicitado
	WSDATA ListOfReqHistory     					As Array of DataReqHistory OPTIONAL	//Lista do histórico
ENDWSSTRUCT

WSSTRUCT DataReqHistory
	WSDATA Sequence     			   				As String	OPTIONAL	//Sequencia
	WSDATA ChangeDate   			   				As Date 	OPTIONAL	//Data da modificacao
	WSDATA ApproverBranch							As String	OPTIONAL	//Filial do Aprovador
	WSDATA ApproverRegistration						As String	OPTIONAL	//Matricula do Aprovador
	WSDATA ApproverName								As String	OPTIONAL	//Nome do Aprovador
	WSDATA ContentCode								As String	OPTIONAL	//codigo do conteudo
	WSDATA Content									As String	OPTIONAL	//conteudo
	WSDATA Operation				   				As String	OPTIONAL	//operacao
ENDWSSTRUCT

WSSTRUCT TRequestData
	WSDATA ListOfRequest			   				AS Array Of TRequest 	OPTIONAL
	WSDATA PagesTotal				   				AS Integer					OPTIONAL
ENDWSSTRUCT

WSSTRUCT TInscrSelectionProc
	WSDATA Branch		     						As String             //Filial da Vaga
	WSDATA BranchDescription		   				As String             //Descrição da Filial
	WSDATA Code		     							As String             //Código da Vaga
	WSDATA Description  			   				As String             //Descrição da Vaga
	WSDATA ParticipantID 							As String OPTIONAL

	//Exclusivo para candidatos externos
	WSDATA CPF 										As String OPTIONAL  	//Doc de CPF do candidato externo
	WSDATA Curriculum	 			   				As String OPTIONAL		//Cod. do Curriculo
	WSDATA Name			 							As String OPTIONAL		//Nome do candidato externo
	WSDATA Test			 							As String OPTIONAL		//Cod. do teste aplicado obs.: Se for o caso, poderá não haver teste.
	WSDATA Score		 			   				As String OPTIONAL		//Nota obtida no teste obs.: Se for o caso, poderá não haver teste.
	WSDATA Situation	 			   				As String OPTIONAL  	//Aprovado ou reprovado no teste obs.: Se for o caso, poderá não haver teste.
ENDWSSTRUCT

WSSTRUCT TVacation
	WSDATA Branch			    	   				As String			    //Filial
	WSDATA Registration								As String				//Codigo da matricula
	WSDATA Name      				   				As String				//Nome do funcionário
	WSDATA InitialDate 								As String	  			//Data de Inicio do Periodo
	WSDATA FinalDate 				   				As String	  			//Data de Termino do Periodo
	WSDATA Days 					   				As Integer				//Dias
	WSDATA PecuniaryAllowance   	   				As String				//Abono Pecuniário
	WSDATA ThirteenthSalary1stInstall				As String				//1a Parcela 13o Salario
	WSDATA PecuniaryDays				            As Integer				//Dias Abono Pecuniário
ENDWSSTRUCT

WSSTRUCT TAcademicGrant
	WSDATA Branch					    			As String				//Filial
	WSDATA Registration								As String				//Codigo da matricula
	WSDATA Name     		  		    			As String				//Nome do funcionario
	WSDATA benefitCode								AS String				//Código do beneficio (RIS_CODE - Char - 2)
	WSDATA descBenefitCode							AS String				//Descrição Código do beneficio
	WSDATA curseName								AS String				//Nome do Curso
	WSDATA instituteName							AS String				//Nome da instituição
	WSDATA contact									AS String				//Contato na intituição
	WSDATA phone									AS String				//Telefone do contato
	WSDATA startDate								AS String				//Data de inicio do curso
	WSDATA endDate									AS String				//Data do fim do curso
	WSDATA monthlyPayment							AS String				//Valor da mensalidade
	WSDATA installmentAmount						AS String				//Qtde. total de parcelas
	WSDATA observation								AS String				//Obesrvação
ENDWSSTRUCT

WSSTRUCT TAttendControl
	WSDATA Branch				    				As String				//Filial
	WSDATA Registration								As String				//Codigo da matricula
	WSDATA Name     		  	    				As String				//Nome do funcionario
	WSDATA Date										AS String				//Data da Marcação
	WSDATA Hour										AS String				//Hora da Marcação
	WSDATA Observation								AS String				//Justificativa da Marcação
	WSDATA Motive									AS String OPTIONAL  	//Motivo da marcação
	WSDATA codeRequest								AS String				//Codigo da requisicao (update)
    WSDATA Latitude                    				As String OPTIONAL  	//Latitude
	WSDATA Longitude                				As String OPTIONAL  	//Longitude
    WSDATA EntryExit                                AS String OPTIONAL      //Identificar de entrada e saida
ENDWSSTRUCT

WSSERVICE RHRequest DESCRIPTION "Solicitacoes"
	WSDATA WsNull   	    		       			As String	           		OPTIONAL	//NULL
	WSDATA Operation				       			As Integer

	WSDATA ParticipantId			       			AS String        			OPTIONAL
	WSDATA EnrolmentId     	 						As String        			OPTIONAL	//Matricula do Participando logado
	WSDATA RequestID				       			AS String        			OPTIONAL
	WSDATA Branch					       			AS String        			OPTIONAL
	WSDATA Registration			      				AS String        			OPTIONAL
	WSDATA Observation			       				AS String        			OPTIONAL
	WSDATA ChaveFunc			         			AS String	            	OPTIONAL

	WSDATA RequestType			       				AS String        			OPTIONAL
	WSDATA MyRequest				       			As Integer					OPTIONAL
	WSDATA Ordem                       				As String        			OPTIONAL
	WSDATA Pendentes                   				As boolean        			OPTIONAL
	WSDATA Aprovadas                  		 		As boolean        			OPTIONAL
	WSDATA Reprovadas                   			As boolean        			OPTIONAL

	WSDATA Request									AS TRequest
	WSDATA FieldsParti								AS TFieldsExibition     	OPTIONAL
	WSDATA FieldsESoc								AS TFieldsInput				OPTIONAL
	WSDATA FieldsInputESoc							AS TFieldsInput				OPTIONAL
	WSDATA PostRequest					 			AS TPostRequest				OPTIONAL
	WSDATA SalaryChangeRequest						AS TSalaryChange			OPTIONAL
	WSDATA TerminationRequest		   				AS TTermination				OPTIONAL
	WSDATA NewContractRequest						AS TNewContract				OPTIONAL
	WSDATA TransferRequest							AS TTransfer				OPTIONAL
	WSDATA ScheduleJustificationRequest 			AS TScheduleJustification 	OPTIONAL
	WSDATA InscrSelectionProc   					AS TInscrSelectionProc		OPTIONAL
	WSDATA TrainingReservationRequest				AS TTrainingReservation		OPTIONAL
	WSDATA VacationRequest         		   			As TVacation				OPTIONAL
	WSDATA AcademicGrantRequest    		   			As TAcademicGrant			OPTIONAL
	WSDATA AttendControlRequest    		   			As TAttendControl			OPTIONAL

	WSDATA WFData 		 	    					As DataWorkFlow 			OPTIONAL
	WSDATA RequestData								AS TRequestData
	WSDATA RequestHistory							AS TRequestHistory

	WSDATA ObjectBrowse   							AS TObjectBrowse
	WSDATA CurrentPage								AS Integer 			    	OPTIONAL
	WSDATA FilterField  					   		AS String 				    OPTIONAL
	WSDATA FilterValue								AS String 				    OPTIONAL

	WSDATA TableSearch		    					As String					OPTIONAL
	WSDATA TableIndex						  		As String					OPTIONAL
	WSDATA KeyField									As String					OPTIONAL
	WSDATA FieldResponse					   		As String					OPTIONAL
	WSDATA FieldDescription							AS String					OPTIONAL

	WSDATA HasRequest								AS Boolean 					OPTIONAL

	WSDATA NewNameFile								AS String   				OPTIONAL
	WSDATA PatchObject								AS String  					OPTIONAL
	WSDATA DescObject								AS String   				OPTIONAL

	WSDATA Descriptions								As TDescription Optional
	WSDATA Value									AS String	 	Optional
	WSDATA Alias									AS String		Optional
	WSDATA Cpo										As String 		Optional
	WSDATA isX5										As Boolean 		Optional
	WSDATA IDMENU										As String 		Optional
	WSMETHOD AddPostRequest							DESCRIPTION STR0010 //"Método que Inclui uma solicitacao de aumento de postos ao RH"
	WSMETHOD AddSalaryChangeRequest			    	DESCRIPTION STR0011 //"Método que Inclui uma solicitacao de acao salarial"
	WSMETHOD AddTerminationRequest					DESCRIPTION STR0012 //"Método que Inclui uma solicitacao de desligamento"
	WSMETHOD AddNewContractRequest					DESCRIPTION STR0013 //"Método que Inclui uma solicitacao de nova contratacao ou substituicao"
	WSMETHOD AddTransferRequest				    	DESCRIPTION STR0014 //"Método que Inclui uma solicitacao de transferencia"
	WSMETHOD AddAlteracaoESocial					DESCRIPTION STR0041 //'Método que inclui uma solicitação de alteração eSocial.'
	WSMETHOD AddScheduleJustificationRequest		DESCRIPTION STR0015 //"Método que Inclui uma solicitacao de justificativa de horario"
	WSMETHOD GetJustification						DESCRIPTION STR0039 //"Método que verifica duplicidade na inclusão de justificativa de horario."
	WSMETHOD AddInscrSelectionProc					DESCRIPTION STR0016 //"Método que Inclui uma solicitacao de participação do processo seletivo (Inscrição à uma vaga disponível)"
	WSMETHOD AddInscrSelectionProcExt				DESCRIPTION STR0017 //"Método que Inclui uma solicitacao de um candidato externo ao processo seletivo (Inscrição à uma vaga disponível)"
	WSMETHOD AddTrainingReservationRequest	    	DESCRIPTION STR0018 //"Método que Inclui uma solicitacao de reserva para um treinamento."
	WSMETHOD AddVacationRequest				    	DESCRIPTION STR0019 //"Método que Inclui uma solicitacao de ferias"
	WSMETHOD AddAcademicGrantRequest		    	DESCRIPTION STR0030 //"Método que Inclui uma solicitacao de subsídio acadêmico"
	WSMETHOD AddAttendControlRequest				DESCRIPTION STR0034	//"Método que incluir uma marcação de ponto"
	WSMETHOD DelAttendControlRequest				DESCRIPTION STR0035	//"Método para excluir uma requisiçao de marcaçao de ponto"
	WSMETHOD ApproveRequest							DESCRIPTION STR0020 //"Método que aprova a solicitacao ao RH"
	WSMETHOD ReproveRequest							DESCRIPTION STR0021 //"Método que reprova a solicitacao ao RH"
	WSMETHOD PutIDWFRequest    				    	DESCRIPTION STR0022 //"Método que atualiza o ID do workflow das solicitacoes via portal"
	WSMETHOD GetRequest	 							DESCRIPTION STR0023 //"Método que busca solicitacoes"
	WSMETHOD GetRequestHistory						DESCRIPTION STR0024 //"Método que busca historico das solicitações"
	WSMETHOD GetDescription							DESCRIPTION STR0025 //"Método que busca descricao de objetos"
	WSMETHOD GetParticipanteSoc						DESCRIPTION STR0042 //'Método que busca os dados do participante, para cabeçalho do eSocial.'
	WSMETHOD GetRecExt								DESCRIPTION STR0043 //'Método que verifica o conteúdo do campo RA_RESEXT para habilitar ou não o campo RA_PAISEXT.'
	WSMETHOD GetForeign								DESCRIPTION STR0044 //'Método que verifica se o participante é Estrangeiro.
	WSMETHOD GetFieldsESoc							DESCRIPTION STR0045 //'Método que retorna os dados do funcionário para visualização no PORTAL GCH.'
	WSMETHOD GetMnemonic							DESCRIPTION STR0046 //'Método que verifica se a base possui o mnemonico do esocial ESOCIALVRS.'
	WSMETHOD GetXBAux 								DESCRIPTION STR0047 //'Método que verifica se a base possui as consultas padrões auxiliares do eSocial.'
	WSMETHOD SetAnexoESoc							DESCRIPTION STR0048 //'Método que inclui um anexo na base de conhecimento do funcionário.'
	WSMETHOD GetDesc								DESCRIPTION STR0049 //'Método que busca determinadas descrições.'

	WSMETHOD RequestTraining 						DESCRIPTION STR0031 //"Método para gravar o interesse por um treinamento sem novas turmas abertas."
	WSMETHOD ValidRequestTraining					DESCRIPTION STR0032 //"Método responsável por avaliar se já há solicitação para este treinamento."
	WSMETHOD DelRequestTraining						DESCRIPTION STR0033 //"Método para cancelar o interesse por um treinamento sem novas turmas abertas."
	WSMETHOD RetChaveFuncionario				DESCRIPTION STR0031 //"Retorna chave do funcionario"

ENDWSSERVICE

WSMETHOD AddPostRequest WSRECEIVE Request, PostRequest WSSEND RequestID WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code            := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "3"	//Postos
	Self:Request:Status:Code		:= "1"
	Self:Request:RequestDate      := dDataBase
	Self:Request:StarterKey	      := fBuscaChaveFuncionario(	Self:Request:Branch,;
		Self:Request:Registration,;
		Self:Request:Vision,;
		Self:PostRequest:DepartmentCode )

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code			:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code			:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddPostRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddPostRequest(Self:PostRequest, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddPostRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddPostRequest", STR0003)
			Break
		EndIf

	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		fFluig(Self:Request,OPERATION_INSERT,"SOLRH3")
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
		::RequestID := Self:Request:Code
	Else
		Return .F.
	EndIf
Return .T.

WSMETHOD AddSalaryChangeRequest	WSRECEIVE Request, SalaryChangeRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "7"	//Acao Salarial
	Self:Request:Status:Code		:= "1"
	Self:Request:RequestDate        := dDataBase
	Self:Request:StarterKey	        := fBuscaChaveFuncionario(	Self:Request:Branch,;
		Self:Request:Registration,;
		Self:Request:Vision)


	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code			:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code			:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddSalaryChangeRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddSalaryChangeRequest(Self:SalaryChangeRequest, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddSalaryChangeRequest", STR0003)
			Break
		EndIf


		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddSalaryChangeRequest", STR0003)
			Break
		EndIf

	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		fFluig(Self:Request,OPERATION_INSERT,"SOLRH7")
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	Else
		Return .F.
	EndIf
Return .T.

WSMETHOD AddTerminationRequest	WSRECEIVE Request, TerminationRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "6"	//Desligamento
	Self:Request:Status:Code		:= "1"
	Self:Request:RequestDate        := dDataBase
	Self:Request:StarterKey	        := fBuscaChaveFuncionario(	Self:Request:Branch,;
		Self:Request:Registration,;
		Self:Request:Vision)

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code			:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code			:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTerminationRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddTerminationRequest(Self:Request, Self:TerminationRequest, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTerminationRequest", STR0003)
			Break
		EndIf


		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTerminationRequest", STR0003)
			Break
		EndIf

	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		fFluig(Self:Request,OPERATION_INSERT,"SOLRH6")
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	Else
		Return .F.
	EndIf
Return .T.

WSMETHOD AddNewContractRequest	WSRECEIVE Request, NewContractRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code               := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "5"	//Admissao
	Self:Request:Status:Code		:= "1"
	Self:Request:RequestDate        := dDataBase
	Self:Request:StarterKey	        := fBuscaChaveFuncionario(	Self:Request:Branch,;
		Self:Request:Registration,;
		Self:Request:Vision,;
		Self:NewContractRequest:DepartmentCode)

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code			:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code			:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddNewContractRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddNewContractRequest(Self:NewContractRequest, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddNewContractRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddNewContractRequest", STR0003)
			Break
		EndIf

	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		fFluig(Self:Request,OPERATION_INSERT,"SOLRH5")
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	Else
		Return .F.
	EndIf
Return .T.

WSMETHOD AddTransferRequest	WSRECEIVE Request, TransferRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "4"	///Transferncia
	Self:Request:Status:Code		:= "1"
	Self:Request:RequestDate        := dDataBase
	Self:Request:StarterKey	        := fBuscaChaveFuncionario(	Self:Request:Branch,;
		Self:Request:Registration,;
		Self:Request:Vision)

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code			:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code			:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTransferRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddTransferRequest(Self:Request, Self:TransferRequest, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTransferRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddPostRequest", STR0003)
			Break
		EndIf

	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		fFluig(Self:Request,OPERATION_INSERT,"SOLRH4")
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	Else
		Return .F.
	EndIf
Return .T.

/******************************************************
 - SETANEXOESOC MANTIDO PARA
 - AJUSTE NA BASE DE CONHECIMENTO DO FUNCIONÁRIO.
*******************************************************/

WSMETHOD SetAnexoESoc WSRECEIVE Branch,EnrolmentId,PatchObject,DescObject WSSEND NewNameFile WSSERVICE RHRequest
Local lRet		:= .T.
Local aAreaACB	 := ACB->(GetArea())  		//Salva a area atual
Local aAreaAC9   := AC9->(GetArea()) 		//Salva a area atual
Local cDirDocs	:= ""
Local cNameServ	:= ""
Local cFile     := ""
Local cExten   	:= ""
Local cCodObj	:= ""
Local cMsg		:= ""
Local lMultDir  := .T.  //Ativa a gravacao em varios niveis de diretorio quando o parametro MV_MULTDIR for .T. e o campo ACB->ACB_PATH for criado.
Self:NewNameFile	:= ''

If !uFileExecut(PatchObject)
	SplitPath( PatchObject, , , @cFile, @cExten )

	cNameServ	:= Alltrim(DescObject)
	cNameServ	+= Alltrim(EnrolmentId)
	cNameServ	+= dToS(date())
	cNameServ	+= substr(Time(), 1, 2)+substr(Time(), 4, 2)+substr(Time(), 7, 2)
	cNameServ	+= cExten

	If MsMultDir()
		cDirDocs := MsRetPath( cNameServ )
	Else
		cDirDocs := MsDocPath()
	EndIf

	__CopyFile( PatchObject, cDirDocs + "\" + cNameServ )

		cCodObj := GetSXENum("ACB","ACB_CODOBJ")

		dbSelectArea( "ACB" )
		dbSetOrder(1)

		RecLock("ACB",.T.)
		ACB->ACB_FILIAL  := xFilial( "ACB" ,::Branch)
		ACB->ACB_CODOBJ  := cCodObj
		ACB->ACB_OBJETO	 := Upper(cNameServ)
		ACB->ACB_DESCRI	 :=	Upper(DescObject)
		If MsMultDir()
			ACB->ACB_PATH	:= MsDocPath(lMultDir)
		EndIf

		ACB->(MsUnLock())
		ACB->(ConfirmSX8())

		dbSelectArea('AC9')

		RECLOCK('AC9', .T.)

		AC9->AC9_FILIAL     := xFilial('AC9',::Branch)   // Retorna a filial de acordo com as configurações do ERP Protheus
		AC9->AC9_FILENT     := xFilial('SRA',::Branch)
		AC9->AC9_ENTIDA     := 'SRA'
		AC9->AC9_CODENT     := xFilial('SRA',::Branch)+AllTrim(EnrolmentId)
		AC9->AC9_CODOBJ 	:= cCodObj
		AC9->(MsUnLock())

		Self:NewNameFile	:= cNameServ

Else
	lRet	:= .F.
	//STR0046 - "Envio de arquivo incompat&iacute;vel!"
	//STR0047 - "Não &eacute; permitido enviar arquivos do tipo execut&aacute;vel, exemplo .exe"
	//STR0048 - Solu&ccedil;&atilde;o : Envie apenas arquivos dos tipos permitidos.
	SetSoapFault('Envio de arquivo incompativel!', 'Não permitido enviar arquivos do tipo executável, exemplo .exe' + "<br><br>" + ' Envie apenas arquivos dos tipos permitidos' + cMsg) //"Participante invalido"
EndIf

RestArea(aAreaACB)
RestArea(aAreaAC9)
Return lRet

/******************************************************
 - Verifica se o funcionário reside no Exterior.
*******************************************************/
WSMETHOD GetRecExt WSRECEIVE EnrolmentId, Branch    WSSEND WsNull WSSERVICE RHRequest

	Local nInd := 1 		// FILIAL + MATRICULA
	Local lRet := .T.

	SRA->( DBSelectArea('SRA') )
	SRA->( DBSetOrder(nInd) )
	IF SRA->( dbSeek(xFilial("SRA", ,::Branch) + ::EnrolmentId ) )
		IF SRA->RA_RESEXT == "1"
			lRet := .F.
		EndIF
	Else
		SetSoapFault('Registro não encontrado.')
	 	lRet := .F.
	EndIf

Return( lRet )

WSMETHOD GetForeign WSRECEIVE EnrolmentId WSSEND WsNull WSSERVICE RHRequest

	Local nInd := 1 		// FILIAL + MATRICULA
	Local lRet := .T.

	SRA->( DBSelectArea('SRA') )
	SRA->( DBSetOrder(nInd) )
	IF SRA->( dbSeek(xFilial("SRA") + ::EnrolmentId ) )
		If !Empty( SRA->RA_CPAISOR ) .AND.( SRA->RA_CPAISOR != "01058" .AND. SRA->RA_NATURAL == "EX" )
			lRet := .F. // É Funcionário Estrangeiro.
		Elseif Empty( SRA->RA_CPAISOR ) .AND.( SRA->RA_NATURAL == "EX" )
			lRet := .F.
		Elseif Empty( SRA->RA_CPAISOR )
			RecLock('SRA',.F.)
				SRA->RA_CPAISOR := '01058'
			MsUnlock()
		EndIF
	Else
		SetSoapFault('Registro não encontrado.')
	 	lRet := .F.
	EndIf

Return( lRet )

/*********************************************
 - RETORNA TODOS OS CAMPOS PARA VISUALIZAÇÃO.
*********************************************/
WSMETHOD GetFieldsESoc WSRECEIVE EnrolmentId,  Branch  WSSEND FieldsESoc WSSERVICE RHRequest

	Local nInd := 1 // MATRÍCULA.
	Local lRet := .T.

	SRA->( DBSelectArea('SRA') )
	SRA->( DBSetOrder(nInd) )
	IF SRA->( dbSeek(xFilial("SRA", ::Branch) + ::EnrolmentId) )

			FieldsESoc:paisExt := Alltrim(SRA->RA_PAISEXT)
			FieldsESoc:tipoLogradouro := Alltrim(SRA->RA_LOGRTP)
			FieldsESoc:numLogradouro := Alltrim(SRA->RA_LOGRNUM)
			FieldsESoc:logrDesc := Alltrim(SRA->RA_LOGRDSC)
			FieldsESoc:cep := Alltrim(SRA->RA_CEP)
			FieldsESoc:bairro := Alltrim(SRA->RA_BAIRRO)
			FieldsESoc:complemento := Alltrim(SRA->RA_COMPLEM)
			FieldsESoc:codMun := Alltrim(SRA->RA_CODMUN)
			FieldsESoc:nacionalidade := Alltrim(SRA->RA_NACIONC)
			FieldsESoc:codMunCad := Alltrim(SRA->RA_CODMUNN)
			FieldsESoc:email := Alltrim(SRA->RA_EMAIL)
			FieldsESoc:emailAlt := Alltrim(SRA->RA_EMAIL2)
			FieldsESoc:portDef := Alltrim(SRA->RA_PORTDEF)
			FieldsESoc:obsDef := Alltrim(SRA->RA_OBSDEFI)
			FieldsESoc:estCiv := Alltrim(SRA->RA_ESTCIVI)
			FieldsESoc:grauInst := Alltrim(SRA->RA_GRINRAI)
			FieldsESoc:paisOrigem := Alltrim(SRA->RA_CPAISOR)
			FieldsESoc:recAposen := Alltrim(SRA->RA_EAPOSEN)
			FieldsESoc:numProcMenor := Alltrim(SRA->RA_NJUD14)
			FieldsESoc:dddFone := Alltrim(SRA->RA_DDDFONE)
			FieldsESoc:telefone := Alltrim(SRA->RA_TELEFON)
			FieldsESoc:dddCel := Alltrim(SRA->RA_DDDCELU)
			FieldsESoc:celular := Alltrim(SRA->RA_NUMCELU)
			FieldsESoc:habilit := Alltrim(SRA->RA_HABILIT)
			FieldsESoc:cnhOrg := Alltrim(SRA->RA_CNHORG)
			FieldsESoc:categoriaCnh := Alltrim(SRA->RA_CATCNH)
			FieldsESoc:dtEmCnh := SRA->RA_DTEMCNH
			FieldsESoc:dtVcCnh := SRA->RA_DTVCCNH
			FieldsESoc:ufCnh := Alltrim(SRA->RA_UFCNH)
			FieldsESoc:codigoInsc := Alltrim(SRA->RA_CODIGO)
			FieldsESoc:oCEmis := Alltrim(SRA->RA_OCEMIS)
			FieldsESoc:oCDtExp := SRA->RA_OCDTEXP
			FieldsESoc:oCDtVal := SRA->RA_OCDTVAL
			FieldsESoc:numCp := Alltrim(SRA->RA_NUMCP)
			FieldsESoc:serCp := Alltrim(SRA->RA_SERCP)
			FieldsESoc:ufCp := Alltrim(SRA->RA_UFCP)
			FieldsESoc:numRic:= Alltrim(SRA->RA_NUMRIC)
			FieldsESoc:emisRic := Alltrim(SRA->RA_EMISRIC)
			FieldsESoc:ufRic := Alltrim(SRA->RA_UFRIC)
			FieldsESoc:cdMuRic := Alltrim(SRA->RA_CDMURIC)
			FieldsESoc:dExPric := SRA->RA_DEXPRIC
			FieldsESoc:rne := Alltrim(SRA->RA_RNE)
			FieldsESoc:rneOrg := Alltrim(SRA->RA_RNEORG)
			FieldsESoc:rneDexp := SRA->RA_RNEDEXP
			FieldsESoc:casadBr := Alltrim(SRA->RA_CASADBR)
			FieldsESoc:filhoBr := Alltrim(SRA->RA_FILHOBR)
			FieldsESoc:DatCheg := SRA->RA_DATCHEG
			FieldsESoc:claseEst := Alltrim(SRA->RA_CLASEST)
	Else
		SetSoapFault('Erro', 'Não foi possível encontrar a Matrícula.')//"Erro" - "Usuario nao autorizado"
	 	lRet := .F.
	EndIf

Return( lRet )

/*********************************************
 - VERIFICA SE POSSUI O MNEMONICO ESOCIALVRS
 - QUE POSSUI OS CAMPOS DO LEIAUTE 2.1
*********************************************/
WSMETHOD GetMnemonic WSRECEIVE NULLPARAM WSSEND WSNULL WSSERVICE RHRequest

	Local lRet := .T.
	Local nInd := 1

	RCA->( DbSelectArea('RCA') )
	RCA->( dbSetOrder( nInd ) )
	IF !RCA->( dbSeek(xFilial('RCA') + 'ESOCIALVRS'  ) )
		lRet := .F.
	EndIF
Return ( lRet )

/*********************************************
 - VERIFICA SE POSSUI AS CONSULTAS PADRÕES
 - AUXILIARES UTILIZADAS NO PORTAL GCH
*********************************************/
WSMETHOD GetXBAux WSRECEIVE NULLPARAM WSSEND WSNULL WSSERVICE RHRequest

	Local lRet := .T.
	Local nInd := 1

	SXB->( DbSelectArea('SXB') )
	SXB->( dbSetOrder( nInd ) )
	IF ( SXB->(MsSeek("CC2RES" + "1" + "01" + "DB")) ) .AND. ( SXB->(MsSeek("CC2ESC" + "1" + "01" + "DB")) );
		.AND. ( SXB->(MsSeek("CC2ES2" + "1" + "01" + "DB")) )
	Else
		lRet := .F.
	EndIf

Return ( lRet )

/*********************************************
- RETORNA OS DADOS PARA O PORTAL GCH
- NA OPÇÃO DE ALTERAÇÃO CADASTRAL ESOCIAL.
*********************************************/
WSMETHOD GetParticipanteSoc WSRECEIVE EnrolmentId, Branch WSSEND FieldsParti WSSERVICE RHRequest

	Local nInd := 1 // MATRÍCULA.
	Local lRet := .T.

	SRA->( DBSelectArea('SRA') )
	SRA->( DBSetOrder(nInd) )
	IF SRA->( dbSeek(xFilial("SRA", ::Branch) + ::EnrolmentId) )
		FieldsParti:Pis 			:= SRA->RA_PIS
		FieldsParti:Cpf 			:= SRA->RA_CIC
		FieldsParti:NomMae 		:= SRA->RA_MAE
		FieldsParti:NomPai 		:= SRA->RA_PAI
		FieldsParti:NomComp		:= SRA->RA_NOMECMP
	Else
		SetSoapFault('Erro', 'Não foi possível encontrar a Matrícula.')//"Erro" - "Usuario nao autorizado"
	 	lRet := .F.
	EndIf

Return( lRet )

/******************************
- NOVA SOLICITAÇÃO -
- ALTERAÇÃO ESOCIAL-
******************************/
WSMETHOD AddAlteracaoESocial WSRECEIVE Request, FieldsInputESoc WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "2"	///Alteração Cadastral
	Self:Request:Status:Code			:= "1"
	Self:Request:RequestDate        := dDataBase
	Self:Request:StarterKey	        := fBuscaChaveFuncionario(	Self:Request:Branch,;
														        Self:Request:Registration,;
														        Self:Request:Vision)

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code				:= "4" // Inclusão
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code				:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddAlteracaoESocial", 'Erro na transmissão da requisição')
			Break
		EndIf

		nReturnCode:= fAddAlteracaoESocial(Self:Request, Self:FieldsInputESoc, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddAlteracaoESocial", 'Erro na transmissão da requisição')
			Break
		EndIf

		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddAlteracaoESocial", 'Erro na transmissão da requisição')
			Break
		EndIf
												//Código					Filial
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
	Else
		Return .F.
	EndIf
Return .T.

WSMETHOD AddScheduleJustificationRequest WSRECEIVE Request, ScheduleJustificationRequest, IDMENU WSSEND WsNull WSSERVICE RHRequest

	// --------------------------------------------------------------------
	// - Regra de negócio encapsulada para FUNCTION.
	// - E desta forma poderá ser utilizada tanto pelo Portal Protheus,
	// - Quanto pelo novo RH - RestFull.
	// --------------------------------------------------------------------
	AddScheduleJustificationRequest(Self:Request, Self:ScheduleJustificationRequest,Self:IDMENU)

Return .T.


WSMETHOD AddInscrSelectionProc WSRECEIVE InscrSelectionProc WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()
	Local aRet     := {}
    Local cNewCode := ""
	Local lWsPeInsc:= Existblock("WSGPEIDINSC")
	Local oRequest

	If Participant(::InscrSelectionProc:ParticipantId , aRet )
		oRequest 				:= WsClassNew('TRequest')
		oRequest:RequestType	:= WSClassNew("TRequestType")
		oRequest:Status		:= WSClassNew("TRequestStatus")

		oRequest:Branch					:= aRet[3]
		oRequest:Code	 				:= GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
		oRequest:Registration			:= aRet[1]
		oRequest:RequestDate        	:= dDataBase
		oRequest:StarterLevel			:= 0
		oRequest:StarterBranch			:= aRet[3]
		oRequest:StarterRegistration	:= aRet[1]
		oRequest:StarterKey				:= ""
		oRequest:ApproverLevel			:= 99
		oRequest:ApproverBranch			:= ""
		oRequest:ApproverRegistration	:= ""
		oRequest:Observation			:= STR0002 + ::InscrSelectionProc:Code + " - " + ::InscrSelectionProc:Description //"Inscrição para o processo seletivo para a vaga "
		oRequest:RequestType:Code		:= "9"	//Incrição para Processo seletivo
		oRequest:Status:Code			:= "4"

		If lWsPeInsc
			cNewCode := ExecBlock( "WSGPEIDINSC", .F.,.F.,{oRequest:Branch,oRequest:Code,oRequest:RequestType:Code})
           IF !empty(cNewCode) .and. ValType(cNewCode) == "C"
              oRequest:Code	:= cNewCode
		    EndIf
		EndIf

		Begin Transaction
			nReturnCode:= fPutRequest(oRequest, OPERATION_INSERT)
			If nReturnCode > 0
				SetSoapFault("AddInscrSelectionProc", STR0003)//"Registro nao encontrado"
				Break
			EndIf

			nReturnCode:= fAddInscrSelProc(Self:InscrSelectionProc, oRequest:Code, OPERATION_INSERT,oRequest:Branch)
			If nReturnCode > 0
				SetSoapFault("AddInscrSelectionProc", STR0003)
				Break
			EndIf

			nReturnCode:= fPutHistory(oRequest, OPERATION_INSERT)
			If nReturnCode > 0
				SetSoapFault("AddInscrSelectionProc", STR0003)
				Break
			EndIf

		End Transaction

		If nReturnCode == 0
			While (GetSx8Len() > nSaveSx8)
				ConfirmSX8()
			EndDo
			fFluig(oRequest,OPERATION_INSERT,"SOLRH9")
			::RequestID := oRequest:Code
		Else
			Return .F.
		EndIf
	Else
		SetSoapFault("AddInscrSelectionProc", STR0001) //Participante não encontrado no cadastro de funcionário
		Return .F.
	EndIf
Return .T.

WSMETHOD AddInscrSelectionProcExt WSRECEIVE InscrSelectionProc WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()
	Local lWsPeInsc:= Existblock("WSGPEIDINSC")
	Local oRequest

	If !Empty(::InscrSelectionProc:CPF )
		oRequest 				:= WsClassNew('TRequest')
		oRequest:RequestType	:= WSClassNew("TRequestType")
		oRequest:Status			:= WSClassNew("TRequestStatus")

		oRequest:Branch					:= xfilial("RH3")
		oRequest:Code	 				:= GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
		oRequest:Registration			:= ""
		oRequest:RequestDate        	:= dDataBase
		oRequest:StarterLevel			:= 0
		oRequest:StarterBranch			:= xfilial("RH3")
		oRequest:StarterRegistration	:= ""
		oRequest:StarterKey				:= ""
		oRequest:ApproverLevel			:= 99
		oRequest:ApproverBranch			:= ""
		oRequest:ApproverRegistration	:= ""
		oRequest:Observation			:= STR0002 + ::InscrSelectionProc:Code + " - " + ::InscrSelectionProc:Description //"Inscrição para o processo seletivo para a vaga "
		oRequest:RequestType:Code		:= "H"	//Incrição para Processo seletivo
		oRequest:Status:Code			:= ::InscrSelectionProc:Situation  //3=Rejeitado; 4=Aguardando efetivação do RH

		If lWsPeInsc
			cNewCode := ExecBlock( "WSGPEIDINSC", .F.,.F.,{oRequest:Branch,oRequest:Code,oRequest:RequestType:Code})
           IF !empty(cNewCode) .and. ValType(cNewCode) == "C"
              oRequest:Code	:= cNewCode
		    EndIf
		EndIf

		Begin Transaction
			nReturnCode:= fPutRequest(oRequest, OPERATION_INSERT)
			If nReturnCode > 0
				SetSoapFault("AddInscrSelectionProc", STR0003)//"Registro nao encontrado"
				Break
			EndIf

			nReturnCode:= fAddInscSelProcExt(Self:InscrSelectionProc, oRequest:Code, OPERATION_INSERT,oRequest:Branch)
			If nReturnCode > 0
				SetSoapFault("AddInscrSelectionProc", STR0003)
				Break
			EndIf
			/*
			nReturnCode:= fPutHistory(oRequest, OPERATION_INSERT)
			If nReturnCode > 0
				SetSoapFault("AddInscrSelectionProc", STR0003)
				Break
			EndIf
			*/
		End Transaction

		If nReturnCode == 0
			While (GetSx8Len() > nSaveSx8)
				ConfirmSX8()
			EndDo
			fFluig(oRequest,OPERATION_INSERT,"SOLRHH")
			::RequestID := oRequest:Code
		Else
			Return .F.
		EndIf
	Else
		SetSoapFault("AddInscrSelectionProc", STR0001) //Participante não encontrado no cadastro de funcionário
		Return .F.
	EndIf
Return .T.

WSMETHOD AddTrainingReservationRequest	WSRECEIVE Request, TrainingReservationRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "A"	//Reserva Treinamento
	Self:Request:RequestDate        := dDataBase
	Self:Request:StarterKey	        := fBuscaChaveFuncionario(	Self:Request:Branch,;
		Self:Request:Registration,;
		Self:Request:Vision)

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code			:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code			:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTrainingReservationRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddTrainingReservationRequest(Self:TrainingReservationRequest, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTrainingReservationRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddTrainingReservationRequest", STR0003)
			Break
		EndIf

		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		fFluig(Self:Request,OPERATION_INSERT,"SOLRHA")
	Else
		Return .F.
	EndIf
Return .T.



WSMETHOD ApproveRequest WSRECEIVE Request WSSEND WsNull WSSERVICE RHRequest

	// --------------------------------------------------------------------
	// - Regra de negócio encapsulada para FUNCTION.
	// - E desta forma poderá ser utilizada tanto pelo Portal Protheus,
	// - Quanto pelo novo RH - RestFull.
	// --------------------------------------------------------------------
	ApproveRequest(Self:Request)

Return .T.


WSMETHOD ReproveRequest WSRECEIVE Request WSSEND WsNull WSSERVICE RHRequest

	// --------------------------------------------------------------------
	// - Regra de negócio encapsulada para FUNCTION.
	// - E desta forma poderá ser utilizada tanto pelo Portal Protheus,
	// - Quanto pelo novo RH - RestFull.
	// --------------------------------------------------------------------
	 ReproveRequest(Self:Request)

Return .T.

/*/{Protheus.doc}ApproveRequest()
- Contém toda a regra de negócio e validações referentes a Aprovação.

@author:		Matheus Bizutti
@since:			31/05/2017
@param:			oRequest - Objeto da classe TRequest com os dados da solicitação
/*/
Function ApproveRequest(oRequest)

Local oTempRequest
Local nReturnCode
//O parametro MV_SIGAGFP = "2" identifica que eh GSP-Caixa.
Local cGSP 			:= SuperGetMv("MV_SIGAGFP",,"1")
Local cUserIni 		:= ""
Local cSaveFilApr	:= ""
Local cSaveMatApr	:= ""

DEFAULT oRequest:ORIGEM := "1" //1=Portal,2=FLUIG

If cGSP >= "2"
	cGSP := "3"
EndIf

oTempRequest            := fGetRequest(oRequest:Branch, oRequest:Code)
oTempRequest:Observation := oRequest:Observation

oRequest:Status	:= WSClassNew("TRequestStatus")

If Empty(oRequest:ApproverRegistration)
	If cGSP == "3" // Gestao Publica - MP
		DO CASE
		CASE oRequest:ApproverLevel == 98 //Direcionado remote (RH) - aprovacao parcial
			oRequest:Status:Code    := "5"
		CASE oRequest:ApproverLevel == 99 //Direcionado remote (RH) - aprovacao final
			oRequest:Status:Code    := "4"
		ENDCASE
	Else
		oRequest:Status:Code          := "4"
	EndIf

	oRequest:ResponseDate 		   := dDataBase
Else
	oRequest:Status:Code		       := "1"
EndIf

Begin Transaction
	nReturnCode:= fPutRequest(oRequest, OPERATION_APPROVE)
	If nReturnCode > 0
		SetSoapFault("ApproveRequest", STR0003)
		Break
	EndIf

	//Grava no historico os dados do aprovador substituto quando houver (uso MeuRH)
	If !Empty(oRequest:ApproverSubBranch)
		cSaveFilApr	:= oTempRequest:ApproverBranch
		cSaveMatApr	:= oTempRequest:ApproverRegistration
		oTempRequest:ApproverBranch			:= oRequest:ApproverSubBranch
		oTempRequest:ApproverRegistration 	:= oRequest:ApproverSubRegistration
	EndIf

	nReturnCode:= fPutHistory(oTempRequest, OPERATION_APPROVE)
	If nReturnCode > 0
		SetSoapFault("ApproveRequest", STR0003)
		Break
	EndIf

	//Restaura na requisicao os dados do aprovador original
	If !Empty(oRequest:ApproverSubBranch)
		oTempRequest:ApproverBranch			:= cSaveFilApr
		oTempRequest:ApproverRegistration 	:= cSaveMatApr
	EndIf

End Transaction

If nReturnCode == 0
	If cGSP == "3" // Gestao Publica - MP
		If !empty(oRequest:ApproverRegistration)
			WFSolicPortal(OPERATION_APPROVE, oRequest:Code, Nil, oRequest:Branch)
		EndIf
	Else
		WFSolicPortal(OPERATION_APPROVE, oRequest:Code, Nil, oRequest:Branch)
	EndIf
	If oRequest:ORIGEM == "1" //1=Portal;2=Fluig
		//Envia Cancelamento do processo para o FLUIG ja que a solicitação foi aprovada pelo Portal
		If FWHasBPM() //verifica se cliente tem Fluig configurado
			cUserIni := fUserFluig(oRequest:Branch,oRequest:Registration)
			If oTempRequest:NroFluig > 0
				CancelProcess(oTempRequest:NroFluig,cUserIni,"Aprovado via Portal Protheus : " + oRequest:Observation)
			EndIf
		Endif
	EndIf
	//Caso tenha outro nivel de aprovação envia para o fluig
	//fFluig(oRequest,OPERATION_INSERT,"SOLRH"+Alltrim(oTempRequest:oRequestType:Code))
Else
	Return .F.
EndIf

Return(Nil)

/*/{Protheus.doc}ReproveRequest()
- Contém toda a regra de negócio e validações referentes a Aprovação.

@author:		Matheus Bizutti
@since:			31/05/2017
@param:			oRequest - Objeto da classe TRequest com os dados da solicitação
/*/
Function ReproveRequest(oRequest)

Local nReturnCode
Local cRepTipo		:= GetMV("MV_SOLICRP", NIL, "0")
Local oTempRequest
Local cUserIni 		:= "000000"
Local cSaveFilApr	:= ""
Local cSaveMatApr	:= ""

DEFAULT oRequest:ORIGEM := "1" //1=Portal,2=FLUIG

oTempRequest             := fGetRequest(oRequest:Branch, oRequest:Code)
oTempRequest:Observation := oRequest:Observation

If cRepTipo == "0"
	oRequest:ApproverLevel				:= oTempRequest:StarterLevel
	oRequest:ApproverBranch			:= oTempRequest:StarterBranch
	oRequest:ApproverRegistration		:= oTempRequest:StarterRegistration
EndIf

oRequest:Status	:= WSClassNew("TRequestStatus")
oRequest:Status:Code:= "3"

Begin Transaction
	nReturnCode:= fPutRequest(oRequest, OPERATION_REPROVE)
	If nReturnCode > 0
		SetSoapFault("ReproveRequest", STR0003)
		Break
	EndIf

	//Grava no historico os dados do reprovador substituto quando houver (uso MeuRH)
	If !Empty(oRequest:ApproverSubBranch)
		cSaveFilApr	:= oTempRequest:ApproverBranch
		cSaveMatApr	:= oTempRequest:ApproverRegistration
		oTempRequest:ApproverBranch			:= oRequest:ApproverSubBranch
		oTempRequest:ApproverRegistration 	:= oRequest:ApproverSubRegistration
	EndIf

	nReturnCode:= fPutHistory(oTempRequest, OPERATION_REPROVE)
	If nReturnCode > 0
		SetSoapFault("ReproveRequest", STR0003)
		Break
	EndIf

	//Restaura na requisicao os dados do aprovador original
	If !Empty(oRequest:ApproverSubBranch)
		oTempRequest:ApproverBranch			:= cSaveFilApr
		oTempRequest:ApproverRegistration 	:= cSaveMatApr
	EndIf

End Transaction

If nReturnCode == 0
	WFSolicPortal(OPERATION_REPROVE, oRequest:Code, Nil, oRequest:Branch)
	//If Request:ORIGEM == "1"
		If FWHasBPM() //verifica se cliente tem Fluig configurado
			//Envia Cancelamento do processo para o FLUIG ja que a solicitação foi aprovada pelo Portal
			If oTempRequest:NroFluig > 0
				If oRequest:ORIGEM == "1"
					cUserIni := fUserFluig(oRequest:Branch,oRequest:Registration)
					CancelProcess(oTempRequest:NroFluig,cUserIni,"Cancelado via Portal Protheus : " + oRequest:Observation)
				Else
					cUserIni := fUserFluig(oRequest:Branch,oRequest:StarterRegistration)
					CancelProcess(oTempRequest:NroFluig,cUserIni,"Solicitação rejeitada.")
				EndIf
			EndIf
		Endif
	//EndIf
Else
	Return .F.
EndIf

Return(Nil)

WSMETHOD GetDesc WSRECEIVE Value, Alias, Cpo, Registration, isX5 WSSEND Descriptions WSSERVICE RHRequest

Default Value		 	:= ""
Default Alias	   		:= ""
Default Cpo		   		:= ""
Default Registration 	:= ""
Default isX5			:= .F.

If isX5
	Descriptions:Value := Iif(!Empty(Alltrim(Value)),POSICIONE("SX5",1,XFILIAL("SX5")+Alias+Value,"X5_DESCRI"),"")
Else
	Descriptions:Value := Iif(!Empty(Alltrim(Value)),FDesc(Alias, Alltrim(Value) ,Cpo),"")
EndIf

Return ( .T. )

Function fGetRequest(cBranch, cRequestCode)
	Local oRequest
	Local aArea	:= GetArea()

	DBSelectArea("RH3")
	DBSetOrder(1)	//RH3_FILIAL, RH3_CODIGO

	If DBSeek(cBranch + cRequestCode)
		oRequest:= WSClassNew("TRequest")
		oRequest:Code:= RH3->RH3_CODIGO
		oRequest:Branch:= RH3->RH3_FILIAL
		oRequest:Registration:= RH3->RH3_MAT
		oRequest:Status:= WSClassNew("TRequestStatus")
		oRequest:Status:Code:= RH3->RH3_STATUS
		oRequest:RequestType:= WSClassNew("TRequestType")
		oRequest:RequestType:Code:= RH3->RH3_TIPO
		oRequest:RequestType:Description:= Porencode(AllTrim(fDesc("SX5", "JQ" + RH3->RH3_TIPO, "X5DESCRI()")))
		oRequest:RequestDate:= RH3->RH3_DTSOLI
		oRequest:ResponseDate:= RH3->RH3_DTATEN
		oRequest:StarterLevel:= RH3->RH3_NVLINI
		oRequest:StarterBranch	:= RH3->RH3_FILINI
		oRequest:StarterRegistration:= RH3->RH3_MATINI
		oRequest:Vision	:= RH3->RH3_VISAO
		oRequest:ApproverLevel:= RH3->RH3_NVLAPR
		oRequest:ApproverBranch:= RH3->RH3_FILAPR
		oRequest:ApproverRegistration:= RH3->RH3_MATAPR
		oRequest:WFID:=	RH3->RH3_WFID
		oRequest:Source:=	RH3->RH3_ORIGEM
		oRequest:NroFluig:=	RH3->RH3_FLUIG

		If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
			oRequest:Empresa:=	RH3->RH3_EMP
			oRequest:EmpresaINI	:=	RH3->RH3_EMPINI
			oRequest:EmpresaAPR	:=	RH3->RH3_EMPAPR
		Else
			oRequest:Empresa :=	cEmpAnt
			oRequest:EmpresaINI	:=	cEmpAnt
			oRequest:EmpresaAPR	:=	cEmpAnt
		EndIf
	EndIf

	RestArea(aArea)
Return oRequest

Function fPutRequest(oRequest, nOperation,cIDMENU)
	Local nReturnCode := 0
	Local aSuperior		:= {}
	Local lWsPe	:= Existblock("WSGPESOL")
	//O parametro MV_SIGAGFP = "2" identifica que eh GSP-Caixa.
	Local cGSP := SuperGetMv("MV_SIGAGFP",,"1")
	Default cIDMENU:= ""
	If cGSP >= "2"
		cGSP := "3"
	EndIf

	If nOperation == 3
    	fPosAI8(oRequest)
    EndIf

	DBSelectArea("RH3")
	DBSetOrder(1)	//RH3_FILIAL+RH3_CODIGO

	Begin Sequence
		If nOperation == 1	//1 = Insert
			Reclock("RH3", .T.)
			RH3->RH3_CODIGO	:= oRequest:Code
			RH3->RH3_FILIAL	:= oRequest:Branch
			RH3->RH3_MAT		:= oRequest:Registration
			RH3->RH3_TIPO		:= oRequest:RequestType:Code
			RH3->RH3_ORIGEM	:= IIF(Empty(cIDMENU), STR0009,cIDMENU)
			RH3->RH3_DTSOLI	:= oRequest:RequestDate
			RH3->RH3_NVLINI	:= oRequest:StarterLevel
			RH3->RH3_FILINI	:= oRequest:StarterBranch
			RH3->RH3_MATINI	:= oRequest:StarterRegistration
			RH3->RH3_KEYINI	:= oRequest:StarterKey
			RH3->RH3_VISAO	:= oRequest:Vision

			If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
				If Empty(oRequest:Empresa)
					oRequest:Empresa := cEmpAnt
				EndIf

				If Empty(oRequest:EmpresaAPR)
					oRequest:EmpresaAPR := cEmpAnt
				EndIf

				RH3->RH3_EMP	:= oRequest:Empresa
				RH3->RH3_EMPINI	:= cEmpAnt
				RH3->RH3_EMPAPR	:= oRequest:EmpresaAPR
			EndIf
			If cGSP == '3' .And. cIDMENU=="GFP"// Gestao Publica - MP
				RH3->RH3_WKFAPV := oRequest:WFAprov
				IF oRequest:WFAprov != ""
					RH3->RH3_WKFETP := oRequest:WFStage
				Else
					RH3->RH3_WKFETP := ""
				EndIf
			EndIf
		Else
			If RH3->(DBSeek(oRequest:Branch + oRequest:Code) )
				Reclock("RH3", .F.)
			Else
				nReturnCode:= 1
				Break
			EndIf
		EndIf

		// Gestao Publica MP - Atualizando etapa do workflow
		IF cGSP == '3' .And. cIDMENU == "GFP" .and. oRequest:Status:Code != "3"
			IF oRequest:WFAprov != ""
				RH3->RH3_WKFETP := oRequest:WFStage
			EndIf
		EndIf

		If nOperation == 3 .And. AI8->AI8_APRVLV <> 0 .And. ( RH3->RH3_NVLINI - oRequest:ApproverLevel ) > AI8->AI8_APRVLV
			RH3->RH3_STATUS := "4"
			RH3->RH3_NVLAPR := 99
			RH3->RH3_FILAPR := ""
			RH3->RH3_MATAPR := ""
			If RH3->(ColumnPos("RH3_EMPAPR")) > 0
				RH3->RH3_EMPAPR	:= ""
			EndIf
		Else
			RH3->RH3_STATUS := oRequest:Status:Code
			RH3->RH3_NVLAPR := oRequest:ApproverLevel
			RH3->RH3_FILAPR := oRequest:ApproverBranch
			RH3->RH3_MATAPR := oRequest:ApproverRegistration
			If RH3->(ColumnPos("RH3_EMPAPR")) > 0
				RH3->RH3_EMPAPR	:= oRequest:EmpresaAPR
			EndIf
			If cGSP == '3' // Gestao Publica - MP
               //Avaliacao de substitutos
               IF oRequest:ApproverRegistration != ""
                  aRetSubst := fVerRI8(oRequest:ApproverBranch, oRequest:ApproverRegistration, dDataBase, dDataBase, .T., .F., .F., .T., .F., .T.)
                  If ValType( aRetSubst ) != "A"
                     aRetSubst  := {}
		EndIf

                  If Len(aRetSubst) > 0
                     RH3->RH3_FILAPR := aRetSubst[1][7] //Filial
                     RH3->RH3_MATAPR := aRetSubst[1][8] //Matricula
                  EndIf
               EndIf
            EndIf
		EndIf
		//Data de aprovacao da solicitacao, preenchida apenas no momento da
		//aprovacao final realizada pelo RH no remote
		//RH3->RH3_DTATEN	:= oRequest:ResponseDate

		RH3->(MsUnlock())
		If lWsPe
			ExecBlock( "WSGPESOL", .F.,.F.,{RH3->RH3_FILAPR,RH3->RH3_MATAPR,oRequest:DepartApr})
		EndIf
	End Sequence
Return nReturnCode

Function fPutHistory(oRequest, nOperation)
	Local nReturnCode := 0
	Local cFilOld		:= ""

	Reclock("RGK",.T.)
	RGK->RGK_FILIAL	:= oRequest:Branch
	RGK->RGK_MAT	:= oRequest:Registration
	RGK->RGK_CODIGO	:= oRequest:Code
	RGK->RGK_DATA	:= dDataBase
	RGK->RGK_SEQUEN	:= GetRGKSeq(oRequest:Code)

	If (nOperation == OPERATION_INSERT)
		RGK->RGK_FILAPR	:= oRequest:StarterBranch
		RGK->RGK_MATAPR	:= oRequest:StarterRegistration
		If RGK->(ColumnPos("RGK_EMP")) > 0
			RGK->RGK_EMP	:= cEmpAnt
		EndIf
	Else
		RGK->RGK_FILAPR	:= oRequest:ApproverBranch
		RGK->RGK_MATAPR	:= oRequest:ApproverRegistration
		If RGK->(ColumnPos("RGK_EMP")) > 0
			RGK->RGK_EMP	:= oRequest:EmpresaAPR
		EndIf
	EndIf

	RGK->RGK_OPERAC	:= AllTrim(Str(nOperation))
	cFilOld := cFilAnt
	//necessario modificar o valor da cFilAnt a fim de gravar corretamente a filial da solicitacao na RDY
	cFilAnt := RGK->RGK_FILIAL
	ApdMsMm(RGK->RGK_CODCON, NIL, NIL, oRequest:Observation, 1, NIL, NIL, "RGK", "RGK_CODCON")
	cFilAnt := cFilOld
	RGK->( MsUnlock() )
Return nReturnCode

Function GetRGKSeq(cCode,lProx)
	Local aAreaAtu	 := GetArea()
	Local cQueryAlias := GetNextAlias()
	Local cSeq
	DEFAULT lProx		:= .T.

	BEGINSQL ALIAS cQueryAlias
		SELECT MAX(RGK_SEQUEN) SEQ
		FROM %table:RGK% RGK
		WHERE RGK_CODIGO = %exp:cCode% AND
		RGK.%notDel%
	ENDSQL

	cSeq := If(lProx,StrZero(val((cQueryAlias)->SEQ) + 1, TamSx3("RGK_SEQUEN")[1]),StrZero(val((cQueryAlias)->SEQ), TamSx3("RGK_SEQUEN")[1]))
	
	(cQueryAlias)->(DBCloseArea())

	RestArea(aAreaAtu)
	
Return cSeq


Function fAddPostRequest(oPostRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oPostRequest:Branch)
	Local aRegs		:={	{"RBT_FILIAL",	oPostRequest:Branch},;
		{"RBT_CODMOV",	oPostRequest:Code},;
		{"RBT_DEPTO" ,	oPostRequest:DepartmentCode},;
		{"TMP_DDEPTO",	Iif(Empty(oPostRequest:DepartmentCode), "", Alltrim(Posicione('SQB',1,xFilial("SQB")+oPostRequest:DepartmentCode,'SQB->QB_DESCRIC')))},;
		{"RBT_CC"    ,  oPostRequest:CostCenterCode},;
		{"TMP_DCC"   ,  Iif(Empty(oPostRequest:CostCenterCode), "", Alltrim(Posicione('CTT',1,xFilial("CTT")+oPostRequest:CostCenterCode,'CTT->CTT_DESC01')))},;
		{"RBT_FUNCAO",	oPostRequest:RoleCode},;
		{"TMP_DFUNCA",	Iif(Empty(oPostRequest:RoleCode), "", Alltrim(Posicione('SRJ',1,xFilial("SRJ")+oPostRequest:RoleCode,'SRJ->RJ_DESC')))},;
		{"RBT_CARGO" ,	oPostRequest:PositionCode},;
		{"TMP_DCARGO",	Iif(Empty(oPostRequest:PositionCode), "", Alltrim(Posicione('SQ3',1,xFilial("SQ3")+oPostRequest:PositionCode,'SQ3->Q3_DESCSUM')))},;
		{"RBT_PROCES",	oPostRequest:ProcessCode},;
		{"RBT_REMUNE",	AllTrim(Str(oPostRequest:Salary, TamSX3("RBT_REMUNE")[1], TamSX3("RBT_REMUNE")[2]))},;
		{"RBT_TPOSTO",	oPostRequest:PostType},;
		{"RBT_TPCONT",	oPostRequest:ContractType},;
		{"RBT_QTDMOV",	AllTrim(Str(oPostRequest:Quantity))},;
		{"RBT_JUSTIF",	oPostRequest:JustificationCode},;
		{"RBT_TIPOR" ,	oPostRequest:RequestType},;
		{"RBT_CODPOS",	oPostRequest:PostCode},;
		{"TMP_NOVACO",  oPostRequest:NewContract}  }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode


Function fAddTerminationRequest(oRequest, oTerminationRequest, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oRequest:Branch)
	Local aRegs		:={	{"RA_FILIAL",	oRequest:Branch},;
		{"RA_MAT",		oRequest:Registration},;
		{"RA_NOME",     Iif(Empty(oTerminationRequest:TYPE), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"RX_COD",	    oTerminationRequest:Type},;
		{"RX_TXT",      Iif(Empty(oTerminationRequest:TYPE), "", Alltrim(Posicione('SRX',1,xFilial("SRX")+'32'+oTerminationRequest:TYPE,'SubStr(SRX->RX_TXT,1,30)')))},;
		{"TMP_NOVAC",	oTerminationRequest:NewHire}  }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= oRequest:Code
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode


Function fAddNewContractRequest(oNewContractRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oNewContractRequest:ReplacedBranch)
	Local aRegs		:={	{"RBT_DEPTO",   oNewContractRequest:DepartmentCode},;
		{"RBT_CODPOS",	oNewContractRequest:Post},;
		{"TMP_TIPO",	oNewContractRequest:Type},;
		{"TMP_FILIAL",	oNewContractRequest:ReplacedBranch},;
		{"TMP_MAT",		oNewContractRequest:ReplacedRegistration}	}

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode


Function fAddSalaryChangeRequest(oSalaryChangeRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oSalaryChangeRequest:Branch)

	Local aRegs		:={ {"RB7_FILIAL",	  	oSalaryChangeRequest:Branch},;
		{"RB7_MAT",  	  	oSalaryChangeRequest:Registration},;
		{"TMP_NOME",  	  	oSalaryChangeRequest:Name},;
		{"RB7_TPALT",		oSalaryChangeRequest:ChangeType},;
		{"RB7_FUNCAO",		oSalaryChangeRequest:NewRoleCode},;
		{"RB7_CARGO",		oSalaryChangeRequest:NewPositionCode},;
		{"RB7_PERCEN",		AllTrim(Str(oSalaryChangeRequest:Percentage))},;
		{"RB7_SALARI",		AllTrim(Str(oSalaryChangeRequest:NewSalary))},;
		{"RB7_CATEG",		oSalaryChangeRequest:Category}		}

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode


Function fAddTransferRequest(oRequest, oTransferRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oRequest:Branch)
	Local aRegs		:={ {"RE_FILIALD",	  oRequest:Branch},;
		{"RE_MATD",  	  oRequest:Registration},;
		{"RE_EMPP",		  oTransferRequest:Company},;
		{"RE_FILIALP",	  oTransferRequest:Branch},;
		{"RE_MATP",  	  oTransferRequest:Registration},;
		{"TMP_NOME",  	  oTransferRequest:Name},;
		{"RE_CCP",		  oTransferRequest:CostCenter},;
		{"TMP_DCCP",      Iif(Empty(oTransferRequest:CostCenter), "", Alltrim(Posicione('CTT',1,xFilial("CTT")+oTransferRequest:CostCenter,'CTT->CTT_DESC01')))},;
		{"RE_DEPTOP",	  oTransferRequest:Department},;
		{"TMP_DDEPTOP",	  Iif(Empty(oTransferRequest:Department), "", Alltrim(Posicione('SQB',1,xFilial("SQB")+oTransferRequest:Department,'SQB->QB_DESCRIC')))},;
		{"RE_PROCESSOP",  oTransferRequest:Process},;
		{"TMP_DPROCP",	  Iif(Empty(oTransferRequest:Process), "", Alltrim(Posicione('RCJ',1,xFilial("RCJ")+oTransferRequest:Process,'RCJ->RCJ_DESCRI')))},;
		{"RE_POSTOP",	  oTransferRequest:Post}	}

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

/********************************************
 FUNCAO QUE ADICIONA UMA
 REQUISIÇÃO DE ALTERAÇÃO CADASTRAL ESOCIAL.
********************************************/
Function fAddAlteracaoESocial(oRequest, oFieldsInputESoc, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oRequest:Branch) // Filial

	/************************************
	- MATRIZ COM OS CAMPOS DA REQUISIÇÃO
	- MANTIDO CAMPOS DA SRB (DEPENDENTES)
	- PARA FUTURA IMPLEMENTAÇÃO.
	*************************************/

	Local aRegs		:={	{"RA_FILIAL",	oRequest:Branch},;
						{"RA_MAT",  	oRequest:Registration},;
						{"RA_PAISEXT",  	oFieldsInputESoc:paisExt},;
						{"RA_LOGRTP",		oFieldsInputESoc:tipoLogradouro},;
						{"RA_LOGRDSC",	oFieldsInputESoc:logrDesc},;
						{"RA_COMPLEM",	oFieldsInputESoc:complemento},;
						{"RA_LOGRNUM",	oFieldsInputESoc:numLogradouro},;
						{"RA_CEP",			oFieldsInputESoc:cep},;
						{"RA_BAIRRO",   oFieldsInputESoc:bairro},;
						{"RA_CODMUN",	oFieldsInputESoc:codMun},;
						{"RA_MUNICIP",	FDESC('CC2', SRA->RA_ESTADO + oFieldsInputESoc:codMun, 'CC2_MUN',, SRA->RA_FILIAL) },;
						{"RA_NACIONC",	oFieldsInputESoc:nacionalidade},;
						{"RA_CODMUNN",	oFieldsInputESoc:codMunCad},;
						{"RA_EMAIL",		oFieldsInputESoc:email},;
						{"RA_EMAIL2",		oFieldsInputESoc:emailAlt},;
						{"RA_PORTDEF",	oFieldsInputESoc:portDef},;
						{"RA_OBSDEFI",	oFieldsInputESoc:obsDef},;
						{"RA_ESTCIVI",	oFieldsInputESoc:estCiv},;
						{"RA_GRINRAI",	oFieldsInputESoc:grauInst},;
						{"RA_CPAISOR",	oFieldsInputESoc:paisOrigem},;
						{"RA_EAPOSEN",	oFieldsInputESoc:recAposen},;
						{"RA_NJUD14",		oFieldsInputESoc:numProcMenor},;
						{"RA_DDDFONE",	oFieldsInputESoc:dddFone},;
						{"RA_TELEFON",	oFieldsInputESoc:telefone},;
						{"RA_DDDCELU",	oFieldsInputESoc:dddCel},;
						{"RA_NUMCELU",	oFieldsInputESoc:celular},;
						{"RA_HABILIT",	oFieldsInputESoc:habilit},;
						{"RA_CNHORG",		oFieldsInputESoc:cnhOrg},;
						{"RA_CATCNH",		oFieldsInputESoc:categoriaCnh},;
						{"RA_DTEMCNH",	(IIF(EMPTY(oFieldsInputESoc:dtEmCnh),DTOC(oFieldsInputESoc:dtEmCnh),DTOC(oFieldsInputESoc:dtEmCnh)))},;
						{"RA_DTVCCNH",	(IIF(EMPTY(oFieldsInputESoc:dtVcCnh),,DTOC(oFieldsInputESoc:dtVcCnh)))},;
						{"RA_UFCNH",		oFieldsInputESoc:ufCnh},;
						{"RA_CODIGO",		oFieldsInputESoc:codigoInsc},;
						{"RA_OCEMIS",		oFieldsInputESoc:oCEmis},;
						{"RA_OCDTEXP",	(IIF(EMPTY(oFieldsInputESoc:oCDtExp),,DTOC(oFieldsInputESoc:oCDtExp)))},;
						{"RA_OCDTVAL",	(IIF(EMPTY(oFieldsInputESoc:oCDtVal),,DTOC(oFieldsInputESoc:oCDtVal)))},;
						{"RA_NUMCP",		oFieldsInputESoc:numCp},;
						{"RA_SERCP",		oFieldsInputESoc:serCp},;
						{"RA_UFCP",		oFieldsInputESoc:ufCp},;
						{"RA_NUMRIC",		oFieldsInputESoc:numRic},;
						{"RA_EMISRIC",	oFieldsInputESoc:emisRic},;
						{"RA_UFRIC",		oFieldsInputESoc:ufRic},;
						{"RA_CDMURIC",	oFieldsInputESoc:cdMuRic},;
						{"RA_DEXPRIC",	(IIF(EMPTY(oFieldsInputESoc:dExPric),,DTOC(oFieldsInputESoc:dExPric)))},;
						{"RA_RNE",			oFieldsInputESoc:rne},;
						{"RA_RNEORG",		oFieldsInputESoc:rneOrg},;
						{"RA_RNEDEXP",	(IIF(EMPTY(oFieldsInputESoc:rneDexp),,DTOC(oFieldsInputESoc:rneDexp)))},;
						{"RA_CASADBR",	oFieldsInputESoc:casadBr},;
						{"RA_FILHOBR",	oFieldsInputESoc:filhoBr},;
						{"RA_DATCHEG",	(IIF(EMPTY(oFieldsInputESoc:DatCheg),,DTOC(oFieldsInputESoc:DatCheg)))},;
						{"RA_CLASEST",	oFieldsInputESoc:claseEst},;
						{"RB_NOME",		oFieldsInputESoc:nome},;
						{"RB_DTNASC",		(IIF(EMPTY(oFieldsInputESoc:dtNasc),,DTOC(oFieldsInputESoc:dtNasc)))},;
						{"RB_SEXO",		oFieldsInputESoc:sexo},;
						{"RB_GRAUPAR",	oFieldsInputESoc:grauPar},;
						{"RB_TPDEP",		oFieldsInputESoc:tpDep},;
						{"RB_TIPSF",		oFieldsInputESoc:tipSf},;
						{"RB_TIPIR",		oFieldsInputESoc:tipIr},;
						{"RB_LOCNASC",	oFieldsInputESoc:locNasc},;
						{"RB_CARTORI",	oFieldsInputESoc:cartori},;
						{"RB_NREGCAR",	oFieldsInputESoc:nRegCar},;
						{"RB_NUMLIVR",	oFieldsInputESoc:numLivr},;
						{"RB_NUMFOLH",	oFieldsInputESoc:numFolh},;
						{"RB_DTENTRA",	(IIF(EMPTY(oFieldsInputESoc:dtEntra),,DTOC(oFieldsInputESoc:dtEntra)))},;
						{"RB_DTBAIXA",	(IIF(EMPTY(oFieldsInputESoc:dtBaixa),,DTOC(oFieldsInputESoc:dtBaixa)))},;
						{"RB_NUMAT",		oFieldsInputESoc:nuMat},;
						{"RB_CIC",			oFieldsInputESoc:cic},;
						{"TMP_ANEXO",		oFieldsInputESoc:Anexo}}

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM		:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

Function AddScheduleJustificationRequest(oRequest, oScheduleJustificationRequest, lRest, cMsgReturn,cIDMENU)
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()

	Default cIDMENU	   := ""
	Default lRest 	   := .F.
	Default cMsgReturn := ""

	oRequest:RequestType		:= WSClassNew("TRequestType")
	oRequest:Status				:= WSClassNew("TRequestStatus")

	oRequest:Code := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	oRequest:RequestType:Code	:= "8"	///Justificativa de horario
	oRequest:Status:Code		:= "1"
	oRequest:RequestDate        := dDataBase
	oRequest:StarterKey	        := fBuscaChaveFuncionario(	oRequest:Branch,;
		oRequest:Registration,;
		oRequest:Vision)

	If Empty(oRequest:ApproverRegistration)
		oRequest:StarterLevel			:= 0
		oRequest:Status:Code			:= "4"
		oRequest:ResponseDate 			:= dDataBase
	Else
		oRequest:StarterLevel			:= oRequest:ApproverLevel+1
		oRequest:Status:Code			:= "1"
		oRequest:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(oRequest, OPERATION_INSERT,cIDMENU)
		If nReturnCode > 0
			If !lRest
				SetSoapFault("AddScheduleJustificationRequest", STR0003)
			Else
				cMsgReturn := EncodeUTF8(STR0003)
			EndIf
			Break
		EndIf

		nReturnCode:= fAddScheduleJustificationRequest(oRequest, oScheduleJustificationRequest, oRequest:Code, OPERATION_INSERT)
		If nReturnCode > 0
			If !lRest
				SetSoapFault("AddScheduleJustificationRequest", STR0003)
			Else
				cMsgReturn := EncodeUTF8(STR0003)
			EndIf
			Break
		EndIf

		nReturnCode:= fPutHistory(oRequest, OPERATION_INSERT)
		If nReturnCode > 0
			If !lRest
				SetSoapFault("AddPostRequest", STR0003)
			Else
				cMsgReturn := EncodeUTF8(STR0003)
			EndIf
			Break
		EndIf

		WFSolicPortal(OPERATION_INSERT, oRequest:Code, Nil, oRequest:Branch)
	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		fFluig(oRequest,OPERATION_INSERT,"SOLRH8")
	Else
		Return .F.
	EndIf
Return (.T.)

Function fAddScheduleJustificationRequest(oRequest, oScheduleJustificationRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oRequest:Branch)

	Local aRegs		:={	{"RF0_FILIAL",	oRequest:Branch},;
		{"RF0_MAT",  	oRequest:Registration},;
		{"TMP_NOME",  	Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"RF0_DTPREI",	DTOC(oScheduleJustificationRequest:InitialDate)},;
		{"RF0_DTPREF",	DTOC(oScheduleJustificationRequest:FinalDate)},;
		{"RF0_HORINI",	AllTrim(Str(oScheduleJustificationRequest:InitialTime, TamSX3("PK_HORINI")[1], TamSX3("PK_HORINI")[2]))},;
		{"RF0_HORFIM",	AllTrim(Str(oScheduleJustificationRequest:FinalTime, TamSX3("PK_HORFIM")[1], TamSX3("PK_HORFIM")[2]))},;
		{"RF0_CODABO",	oScheduleJustificationRequest:Reason},;
		{"RF0_HORTAB",	Iif(Empty(oScheduleJustificationRequest:InitialTime), "S", "N") },;
		{"TMP_ABOND",	Iif(Empty(oScheduleJustificationRequest:Reason), "", Alltrim(Posicione('SP6',1,xFilial("SP6")+oScheduleJustificationRequest:Reason,'SP6->P6_DESC')))} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

Function fAddInscrSelProc(oRequest, cRequestCode, nOperation, FilialReq)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4",FilialReq)
	Local aRegs		:={	                                              ;
		                  {"TMP_FILIAL", oRequest:Branch             },;
		                  {"TMP_DSCFIL", oRequest:BranchDescription  },;
		                  {"TMP_VAGA"  , oRequest:Code}               ,;
		                  {"TMP_DESC"  , oRequest:Description}         ;
		                 }
	Local lWsPe		:= Existblock("WSGPEINSC")

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
	If lWsPe
		ExecBlock( "WSGPEINSC", .F.,.F.,{cFilRH4,cRequestCode})
	EndIf
Return nReturnCode

Function fAddInscSelProcExt(oRequest, cRequestCode, nOperation,FilialReq)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local lWsPe		:= Existblock("WSGPEINSC")
	Local cFilRH4	:=  xFilial("RH4",FilialReq)
	Local aRegs		:={	{"QG_CIC"    , oRequest:CPF        },;
		{"QG_CURRIC" , oRequest:Curriculum },;
		{"QG_NOME"   , oRequest:Name       },;
		{"TMP_FILIAL", oRequest:Branch},;
		{"TMP_DSCFIL", oRequest:BranchDescription },;
		{"TMP_VAGA"  , oRequest:Code       },;
		{"TMP_DESC"  , oRequest:Description},;
		{"TMP_TEST"  , oRequest:Test       },;
		{"TMP_NOTA"  , oRequest:Score      },;
		{"TMP_SITUAC", oRequest:Situation  } }

	DBSelectArea("RH4")

	If nOperation == 1 //1 = INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
	If lWsPe
		ExecBlock( "WSGPEINSC", .F.,.F.,{cFilRH4,cRequestCode})
	EndIf
Return nReturnCode

Function fAddTrainingReservationRequest(oRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oRequest:Branch)

	Local aRegs		:={	{"RA3_FILIAL",	oRequest:Branch},;
		{"RA3_MAT",  	oRequest:Registration},;
		{"TMP_NOME",  	Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"RA3_CALEND",	oRequest:CalendarCode},;
		{"RA3_CURSO",	oRequest:CourseCode},;
		{"RA3_TURMA",	oRequest:CourseClass},;
		{"RA3_DATA",	DTOC(dDataBase)},;
		{"RA3_PORTAL",	If(Request:StarterRegistration <> Request:Registration, "G","F")} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf



Return nReturnCode


Function fAddVDFJourneyRequest(oRequest, oVDFJourneyRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem     := 0
	Local cFilRH4   := xFilial("RH4", oRequest:Branch)

	Local aRegs     :={ {"PF_FILIAL",  oRequest:Branch},;
		{"PF_MAT",     oRequest:Registration},;
		{"TMP_NOME",    Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"PF_JORNAPA", oVDFJourneyRequest:Journey} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL := cFilRH4
				RH4->RH4_CODIGO := cRequestCode
				RH4->RH4_ITEM   := ++nItem
				RH4->RH4_CAMPO  := aRegs[nCount, 1]
				RH4->RH4_VALNOV := aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

Function fAddVDFDailyRequest(oRequest, oVDFDailyRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem     := 0
	Local cFilRH4   := xFilial("RH4", oRequest:Branch)

	Local aRegs     :={ {"RA_FILIAL", oRequest:Branch},;
		{"RA_MAT",    oRequest:Registration},;
		{"TMP_NOME",  Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"TMP_DTINI", oVDFDailyRequest:InitialDate},;
		{"TMP_DTFIM", oVDFDailyRequest:FinalDate} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL := cFilRH4
				RH4->RH4_CODIGO := cRequestCode
				RH4->RH4_ITEM   := ++nItem
				RH4->RH4_CAMPO  := aRegs[nCount, 1]
				RH4->RH4_VALNOV := aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

Function fAddVDFVacationRequest(oRequest, oVDFVacationRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem     := 0
	Local cFilRH4   := xFilial("RH4", oRequest:Branch)

	Local aRegs     :={ {"RA_FILIAL",   oRequest:Branch},;
		{"RA_MAT",      oRequest:Registration},;
		{"TMP_NOME",    Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"TMP_DESC",    oVDFVacationRequest:Description},;
		{"TMP_TABELA",  oVDFVacationRequest:Table},;
		{"TMP_TIPO",    oVDFVacationRequest:Programer},;
		{"TMP_COD",     oVDFVacationRequest:Code},;
		{"TMP_SEQ",     oVDFVacationRequest:Sequence},;
		{"TMP_PD",      oVDFVacationRequest:AllowanceID},;
		{"TMP_PDDESC",  oVDFVacationRequest:AllowanceID + " - " + fDesc( 'SRV', oVDFVacationRequest:AllowanceID, 'SRV->RV_DESC')},;
		{"TMP_DTBINI",  oVDFVacationRequest:InitialBaseDate},;
		{"TMP_DTBFIM",  oVDFVacationRequest:FinalBaseDate},;
		{"TMP_DPER1",   oVDFVacationRequest:DaysofFirstPeriod},;
		{"TMP_DPER2",   oVDFVacationRequest:DaysofSecondPeriod},;
		{"TMP_DABONO",  oVDFVacationRequest:BonusDays},;
		{"TMP_DOPORT",  oVDFVacationRequest:OpportuneDays},;
		{"TMP_DTINI1",  oVDFVacationRequest:FirstInitialDate},;
		{"TMP_DTFIM1",  oVDFVacationRequest:FirstFinalDate},;
		{"TMP_FSUB1",   oVDFVacationRequest:FirstSubsEmployeeFil},;
		{"TMP_MSUB1",   oVDFVacationRequest:FirstSubsRegistration},;
		{"TMP_NSUB1",   oVDFVacationRequest:FirstSubsName},;
		{"TMP_DTINI2",  oVDFVacationRequest:SecondInitialDate},;
		{"TMP_DTFIM2",  oVDFVacationRequest:SecondFinalDate},;
		{"TMP_FSUB2",   oVDFVacationRequest:SecondSubsEmployeeFil},;
		{"TMP_MSUB2",   oVDFVacationRequest:SecondSubsRegistration},;
		{"TMP_NSUB2",   oVDFVacationRequest:SecondSubsName} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL := cFilRH4
				RH4->RH4_CODIGO := cRequestCode
				RH4->RH4_ITEM   := ++nItem
				RH4->RH4_CAMPO  := aRegs[nCount, 1]
				RH4->RH4_VALNOV := aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

Function fAddVDFBalanceVacRequest(oRequest, oVDFBalanceVacRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem     := 0
	Local cFilRH4   := xFilial("RH4", oRequest:Branch)

	Local aRegs     :={ {"RA_FILIAL",   oRequest:Branch},;
		{"RA_MAT",      oRequest:Registration},;
		{"TMP_NOME",    Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"RIA_SEQPRG",  oVDFBalanceVacRequest:Sequence},;
		{"RIA_PD",       oVDFBalanceVacRequest:PayrollCode},;
		{"TMP_TIPO",    oVDFBalanceVacRequest:TypeDescSolic},;
		{"RIA_FILSUB",  oVDFBalanceVacRequest:SubstBranch},;
		{"RIA_MATSUB",  oVDFBalanceVacRequest:SubstRegistration},;
		{"RIA_NMSUBS",  oVDFBalanceVacRequest:SubstName},;
		{"RIA_DTINPA",  oVDFBalanceVacRequest:InitialBaseDate},;
		{"RIA_DATINI",  oVDFBalanceVacRequest:ProgInitialDate},;
		{"RIA_DATFIM",  oVDFBalanceVacRequest:ProgFinalDate},;
		{"RIA_NRDGOZ",  AllTrim(Str(oVDFBalanceVacRequest:ProgDays))},;
		{"RIA_NRDIND",  AllTrim(Str(oVDFBalanceVacRequest:AllowDays))},;
		{"RIA_SEQPRG",  oVDFBalanceVacRequest:Sequence},;
		{"RIA_PD",       oVDFBalanceVacRequest:PayrollCode},;
		{"RI6_NUMDOC",  oVDFBalanceVacRequest:IDPublication},;
		{"RI6_CHAVE",   oVDFBalanceVacRequest:RI6Key},;
		{"TMP_REGID",   AllTrim(Str(oVDFBalanceVacRequest:RegID))} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL := cFilRH4
				RH4->RH4_CODIGO := cRequestCode
				RH4->RH4_ITEM   := ++nItem
				RH4->RH4_CAMPO  := aRegs[nCount, 1]
				RH4->RH4_VALNOV := aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf

Return nReturnCode

Function fAddVDFLicenceRequest(oRequest, oVDFLicenceRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem     := 0
	Local cFilRH4   := xFilial("RH4", oRequest:Branch)

	Local aRegs     :={ {"RA_FILIAL", oRequest:Branch},;
		{"RA_MAT",    oRequest:Registration},;
		{"TMP_NOME",  Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"RCM_TIPO",   oVDFLicenceRequest:Licence},;
		{"RCM_DESCRI", oVDFLicenceRequest:LicenceDesc},;
		{"RCM_TIPODI", oVDFLicenceRequest:DaysType},;
		{"TMP_TPDESC", oVDFLicenceRequest:DaysTypeDesc},;
		{"TMP_DIAREQ", oVDFLicenceRequest:DaysRequest},;
		{"TMP_DTINI",  oVDFLicenceRequest:InitialDate},;
		{"TMP_DTFIM",  oVDFLicenceRequest:FinalDate},;
		{"TMP_FSUBST", oVDFLicenceRequest:SubsEmployeeFil},;
		{"TMP_MSUBST", oVDFLicenceRequest:SubsRegistration},;
		{"TMP_NSUBST", oVDFLicenceRequest:SubsName} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL := cFilRH4
				RH4->RH4_CODIGO := cRequestCode
				RH4->RH4_ITEM   := ++nItem
				RH4->RH4_CAMPO  := aRegs[nCount, 1]
				RH4->RH4_VALNOV := aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

Function fAddVDFCertificateRequest(oRequest, oVDFCertificateRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem     := 0
	Local cFilRH4   := xFilial("RH4", oRequest:Branch)

	Local aRegs     :={ {"RA_FILIAL", oRequest:Branch},;
		{"RA_MAT",    oRequest:Registration},;
		{"TMP_NOME",  Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"TMP_DOCTO", oVDFCertificateRequest:DoctoID},;
		{"TMP_DESC",  oVDFCertificateRequest:DoctoDesc} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL := cFilRH4
				RH4->RH4_CODIGO := cRequestCode
				RH4->RH4_ITEM   := ++nItem
				RH4->RH4_CAMPO  := aRegs[nCount, 1]
				RH4->RH4_VALNOV := aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode


Function fAddVDFDaysOffRequest(oRequest, oVDFVacationRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem     := 0
	Local cFilRH4   := xFilial("RH4", oRequest:Branch)

	Local aRegs     :={ {"RA_FILIAL", oRequest:Branch},;
		{"RA_MAT",    oRequest:Registration},;
		{"TMP_NOME",  Iif(Empty(oRequest:Registration), "", Alltrim(Posicione('SRA',1,oRequest:Branch+oRequest:Registration,'SRA->RA_NOME')))},;
		{"TMP_DESC",    oVDFVacationRequest:TypeDescSolic},;
		{"TMP_COD",     oVDFVacationRequest:Code},;
		{"TMP_PD",      oVDFVacationRequest:AllowanceID},;
		{"TMP_PDDESC",  oVDFVacationRequest:AllowanceID + " - " + fDesc( 'SRV', oVDFVacationRequest:AllowanceID, 'SRV->RV_DESC')},;
		{"TMP_DABONO",  oVDFVacationRequest:BonusDays},;
		{"TMP_DTBINI",  oVDFVacationRequest:InitialBaseDate},;
		{"TMP_DTBFIM",  oVDFVacationRequest:FinalBaseDate},;
		{"TMP_DPER1",   oVDFVacationRequest:DaysofFirstPeriod},;
		{"TMP_DTINI1",  oVDFVacationRequest:FirstInitialDate},;
		{"TMP_DTFIM1",  oVDFVacationRequest:FirstFinalDate},;
		{"TMP_FSUB1",   oVDFVacationRequest:FirstSubsEmployeeFil},;
		{"TMP_MSUB1",   oVDFVacationRequest:FirstSubsRegistration},;
		{"TMP_NSUB1",   oVDFVacationRequest:FirstSubsName},;
		{"RI6_NUMDOC",  oVDFVacationRequest:IDPublication},;
		{"RI6_CHAVE",   oVDFVacationRequest:RI6Key},;
		{"TMP_REGID",   AllTrim(Str(oVDFVacationRequest:RegID))} }
	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL := cFilRH4
				RH4->RH4_CODIGO := cRequestCode
				RH4->RH4_ITEM   := ++nItem
				RH4->RH4_CAMPO  := aRegs[nCount, 1]
				RH4->RH4_VALNOV := aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetRequest	    ³ Autor ³Flavio S. Correa    ³Data ³01.12.2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem das Solicitacoes                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetRequest WSRECEIVE ParticipantId, EnrolmentId, RequestType, MyRequest, CurrentPage, FilterField, FilterValue, Ordem, Pendentes, Aprovadas, Reprovadas,ChaveFunc,IDMENU WSSEND RequestData WSSERVICE RHRequest
	Local lRet	     := .T.
	Local aRet      := {}
	Local cCpfCExt := ''
	Local cCodMat
	Local cCodFil
	Local lGetPage := Iif(CurrentPage == Nil, .T., .F.)
	Local cRegime	:= ""
	//O parametro MV_SIGAGFP = "2" identifica que eh GSP-Caixa.
	Local cGSP := SuperGetMv("MV_SIGAGFP",,"1")

	DEFAULT Self:MyRequest   := 1
	DEFAULT Self:CurrentPage := 1
	DEFAULT Self:FilterField := ""
	DEFAULT Self:FilterValue := ""

	DEFAULT Self:Ordem      := "crescente"
	DEFAULT Self:Pendentes  := .T.
	DEFAULT Self:Aprovadas  := .T.
	DEFAULT Self:reprovadas := .T.
	DEFAULT Self:RequestType:= ""
	DEFAULT ::ChaveFunc 	:= ""
	DEFAULT Self:IDMENU	:= ""
	If cGSP >= "2"
		cGSP := "3"
	EndIf
	If Self:CurrentPage == 1
		IF GetGlbValue('nPageAnt') != ""
			If GetGlbValue('selfordem') <> ""
				Self:Ordem := GetGlbValue('selfordem')
			EndIf
		EndIf
	Else
		If GetGlbValue('selfordem') <> ""
			Self:Ordem := GetGlbValue('selfordem')
		EndIf
		PutGlbValue('nPageAnt',Alltrim(Str(Self:CurrentPage)))
	EndIf

	If Self:RequestType == 'H'	//Vagas Externas
		cCodFil		:= ''
		cCodMat		:= '' // Candidato Externo é identificado pelo CPF
		cCpfCExt	   := Self:ParticipantId
	Else
		If !Empty(Self:ParticipantId)
			If Participant(Self:ParticipantId,aRet,,Self:EnrolmentID)
				cCodMat:= aRet[1]
				cCodFil:= aRet[3]
				If Len(aRet) > 10
					cRegime:= aRet[11]
				EndIf
			Else
				SetSoapFault("GetRequest", STR0005)
				Return .F.
			EndIf
		EndIf
	EndIf

	Self:FilterValue := IIF(Self:FilterField == "RH3_DTSOLI", DTOS(CTOD(Self:FilterValue)), Self:FilterValue)

	If Self:MyRequest == 1
		If Self:RequestType == 'H'	//Vagas Externas
			Self:RequestData:ListOfRequest := fGetMyReqExt(cCpfCExt, Self:RequestType, Self:CurrentPage,	Self:FilterField, Self:FilterValue,,Self:IDMENU)
			Self:RequestData:PagesTotal 	:= Ceiling(fGetMyReqExt(cCpfCExt, Self:RequestType, NIL, 		Self:FilterField, Self:FilterValue, .T.,Self:IDMENU) / PAGE_LENGTH)
		Else
			Self:RequestData:ListOfRequest := fGetMyReq(cCodFil, cCodMat, Self:RequestType, Iif(lGetPage,0,Self:CurrentPage), Self:FilterField, Self:FilterValue, .F., Self:Ordem, Self:Pendentes, Self:Aprovadas, Self:Reprovadas,Self:IDMENU)
			Self:RequestData:PagesTotal 	:= Ceiling(fGetMyReq(cCodFil, cCodMat, Self:RequestType, NIL, 	  Self:FilterField, Self:FilterValue, .T., Self:Ordem, Self:Pendentes, Self:Aprovadas, Self:Reprovadas,Self:IDMENU) / PAGE_LENGTH)
		EndIf
	Else
		If Self:MyRequest == 4 // Gestao Publica - solicitacoes no workflow
			Self:RequestData:ListOfRequest := fGetGSPReqWKF(cCodFil, cCodMat, Self:RequestType, Self:CurrentPage, Self:FilterField, Self:FilterValue,,::ChaveFunc)
			Self:RequestData:PagesTotal    := Ceiling(fGetGSPReqWKF(cCodFil, cCodMat, Self:RequestType, NIL, Self:FilterField, Self:FilterValue, .T.,::ChaveFunc) / PAGE_LENGTH)
		Else
			If cGSP == '3' .And. Self:IDMENU =="GFP" // Gestao Publica - MP
				If Empty(::ChaveFunc)
					::ChaveFunc := fBuscaChaveFuncionario(cCodFil, cCodMat, '')
				EndIf
				Self:RequestData:ListOfRequest := fGetGSPAllReq(cCodFil, cCodMat, Self:RequestType, Self:CurrentPage, Self:FilterField, Self:FilterValue, .F., Self:Ordem, Self:Pendentes, Self:Aprovadas, Self:Reprovadas,::ChaveFunc,Self:IDMENU)
				Self:RequestData:PagesTotal    := Ceiling(fGetGSPAllReq(cCodFil, cCodMat, Self:RequestType, NIL, Self:FilterField, Self:FilterValue, .T., Self:Ordem, Self:Pendentes, Self:Aprovadas, Self:Reprovadas,::ChaveFunc,Self:IDMENU) / PAGE_LENGTH)
			Else
				Self:RequestData:ListOfRequest := fGetAllReq(cCodFil, cCodMat, Self:RequestType, Iif(lGetPage,0,Self:CurrentPage), Self:FilterField, Self:FilterValue, .F., Self:Ordem, Self:Pendentes, Self:Aprovadas, Self:Reprovadas,,Self:IDMENU)
				Self:RequestData:PagesTotal    := Ceiling(fGetAllReq(cCodFil, cCodMat, Self:RequestType, NIL, Self:FilterField, Self:FilterValue, .T., Self:Ordem, Self:Pendentes, Self:Aprovadas, Self:Reprovadas,,Self:IDMENU) / PAGE_LENGTH)
			EndIf
		EndIf
	EndIf

	PutGlbValue('selfordem',Self:Ordem)
	If Self:CurrentPage == 1
		IF GetGlbValue('nPageAnt') != ""
			ClearGlbValue('nPageAnt')
		EndIf
	EndIf

Return lRet

WSMETHOD GetJustification WSRECEIVE Request, ScheduleJustificationRequest, IDMENU WSSEND WsNull WSSERVICE RHRequest
Local cAliasQry  := GetNextAlias()
Local cAliasAux1 := GetNextAlias()
Local cFiltro01  := ''
Local lRet 	   	 := .T.
Local nCount 	 := 0
Local cBranch    := Self:Request:Branch
Local cMat		 := Self:Request:Registration
Local cHorIni	 := ''
Local cHorFim    := ''
Local dDataIni	 := ''
Local dDataFim	 := ''

Default Request							:= Self:Request
Default ScheduleJustificationRequest	:= Self:ScheduleJustificationRequest
Default Self:IDMENU := ""

	If IDMENU == "GCH"
		cWhere+= " AND RH3.RH3_ORIGEM <> 'SIGAGFP'"
	ElseIf IDMENU == "GFP"
		cWhere+= " AND RH3.RH3_ORIGEM =  'SIGAGFP'"
	EndIf
BeginSql alias cAliasQry
	SELECT RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH3.RH3_STATUS
	FROM  %table:RH3% RH3
	WHERE
		RH3.RH3_FILIAL = %exp:cBranch% AND
		RH3.RH3_MAT = %exp:cMat% AND
    	RH3.RH3_TIPO = '8' AND
		RH3.%notDel% AND
		RH3.RH3_STATUS != '3'
EndSql

While !(cAliasQry)->(Eof())

	BeginSql alias cAliasAux1
		SELECT *
		FROM  %table:RH4% RH4
		WHERE
			RH4.RH4_CODIGO = %exp:(cAliasQry)->RH3_CODIGO% AND
			(RH4.RH4_CAMPO = "RF0_DTPREI" OR
			 RH4.RH4_CAMPO = "RF0_DTPREF" OR
			 RH4.RH4_CAMPO = "RF0_HORINI" OR
			 RH4.RH4_CAMPO = "RF0_HORFIM") AND
			RH4.%notDel%
	EndSql

	dDataIni	:= ''
	dDataFim	:= ''
	nHorIni	    := ''
	nHorFim	    := ''
	While !(cAliasAux1)->(Eof())
		If (cAliasAux1)->RH4_CAMPO = "RF0_DTPREI"
			dDataIni := CTOD((cAliasAux1)->(RH4_VALNOV))
		EndIf
		If (cAliasAux1)->RH4_CAMPO = "RF0_DTPREF"
			dDataFim := CTOD((cAliasAux1)->(RH4_VALNOV))
		EndIf
		If (cAliasAux1)->RH4_CAMPO = "RF0_HORINI"
			nHorIni := Val((cAliasAux1)->(RH4_VALNOV))
		EndIf

		If (cAliasAux1)->RH4_CAMPO = "RF0_HORFIM"
			nHorFim := Val((cAliasAux1)->(RH4_VALNOV))
		EndIf

		(cAliasAux1)->(DBSkip())

	Enddo
	If (Self:ScheduleJustificationRequest:InitialDate >= dDataIni .AND. Self:ScheduleJustificationRequest:FinalDate <= dDataFim) .OR. ;
	   (Self:ScheduleJustificationRequest:FinalDate >= dDataIni .AND. Self:ScheduleJustificationRequest:FinalDate <= dDataFim)
		If (Self:ScheduleJustificationRequest:InitialTime >= nHorIni .AND. Self:ScheduleJustificationRequest:InitialTime <= nHorFim) .OR. ;
		   (Self:ScheduleJustificationRequest:FinalTime > nHorIni .AND. Self:ScheduleJustificationRequest:FinalTime <= nHorFim)
			lRet := .F.
			(cAliasAux1)->(DBCloseArea())
			Exit
		EndIf
	EndIf
	(cAliasAux1)->(DBCloseArea())

	(cAliasQry)->(DBSkip())
Enddo
(cAliasQry)->(DBCloseArea())

Return(lRet)

Static Function fGetGSPAllReq(cBranch, cRegistration, cRequestType, nPage, cFilterField, cFilterValue, lCount, cOrdem, lPendentes, lAprovadas, lReprovadas,cKey,cIDMENU)
	Local aArea     := GetArea()
	Local cQuery    := GetNextAlias()
	Local cWhere    := "%%"
	Local nSkips    := 0
	Local cStatus   := ""
	Local xReturn
	Local cFields

	Default lCount  	:= .F.
	DEFAULT cKey 		:= ""
	Default cIDMENU	:= ""
	If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM, RH3_WKFAPV, RH3_WKFETP,RH3_EMP,RH3_EMPINI,RH3_EMPAPR") + "%"
	Else
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM, RH3_WKFAPV, RH3_WKFETP") + "%"
	EndIf
	If lPendentes
		cStatus := "'1','4','5'"
	EndIf
	If lAprovadas
		If !empty(cStatus)
			cStatus += ","
		EndIf
		cStatus += "'2'"
	EndIf
	If lReprovadas
		If !empty(cStatus)
			cStatus += ","
		EndIf
		cStatus += "'3'"
	EndIf

	If lCount
		xReturn:= 0
	Else
		xReturn:= {}
	EndIf


	//Verifica se o usuario e o primeiro ou segundo responsavel em algum departamento
	BEGINSQL ALIAS cQuery
		SELECT
		COUNT(*) AS REGISTROS
		FROM
		%Table:SQB% SQB
		WHERE SQB.%notDel%                         AND
		(SQB.QB_FILRESP = %exp:cBranch%        AND
		SQB.QB_MATRESP = %exp:cRegistration% ) OR
		(SQB.QB_FILRSP2 = %exp:cBranch%        AND
		SQB.QB_MATRSP2 = %exp:cRegistration% )
	ENDSQL

	If (cQuery)->REGISTROS > 0
		(cQuery)->(dbCloseArea())

		//Busca solicitacoes da equipe
		If empty(cKey)
	        cWhere := "% AND RH3.RH3_MAT = '" +cRegistration + "'"
	    Else
	    	cWhere := "% AND RH3.RH3_KEYINI LIKE '" + cKey + "%'"
	    EndIf

		If !Empty(cFilterField) .AND. !Empty(cFilterValue)
			If !(Substr(cFilterField,1,1) == "@")
				cWhere += " AND RH3." + cFilterField + " LIKE '%" + cFilterValue + "%'"
			EndIf
		EndIf

		If !empty(cStatus)
			cWhere += " AND RH3.RH3_STATUS IN (" + cStatus + ") "
		Endif
		If Empty(cIDMENU) .Or. cIDMENU != "GFP"
			cWhere+= " AND RH3.RH3_ORIGEM <> 'SIGAGFP' "
		Else
			cWhere+= " AND RH3.RH3_ORIGEM =  'SIGAGFP' "
		EndIf
		If !lCount
			If cOrdem == "decrescente"
				cWhere += " ORDER BY RH3.RH3_DTSOLI DESC, RH3.RH3_CODIGO DESC "
			Else
				cWhere += " ORDER BY RH3.RH3_DTSOLI, RH3.RH3_CODIGO "
			EndIf
		EndIf

		cWhere += "%"


		BEGINSQL ALIAS cQuery
			SELECT
			%Exp:cFields%
			FROM
			%Table:RH3% RH3
			WHERE
			NOT (RH3_FILINI = %exp:cBranch%        AND
			RH3_MATINI = %exp:cRegistration% ) AND
			RH3.%notDel%
			%Exp:cWhere%
		ENDSQL

		If lCount
			xReturn+= (cQuery)->REGISTROS
		Else
			While !(cQuery)->(Eof()) .AND.;
					Len(xReturn) < PAGE_LENGTH

				If nSkips < ((nPage-1) * PAGE_LENGTH)
					nSkips++
				Else
					If aScan( xReturn, {|x| AllTrim( x:Code ) == AllTrim( (cQuery)->RH3_CODIGO ) } ) == 0
						aAdd(xReturn, fBuildRequest(cQuery))
					EndIf
				EndIf

				(cQuery)->(dbSkip())
			EndDo
		EndIf

		(cQuery)->(dbCloseArea())
	EndIf

	RestArea(aArea)

Return xReturn


Static Function fGetGSPReqWKF(cBranch, cRegistration, cRequestType, nPage, cFilterField, cFilterValue, lCount,cKey)
	Local aArea     := GetArea()
	Local cQuery    := GetNextAlias()
	Local cWhere    := "%%"
	Local nSkips    := 0
	Local xReturn
	Local cFields
	Default lCount  := .F.
	Default  cKey	:= ""

	If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM, RH3_WKFAPV, RH3_WKFETP,RH3_EMP,RH3_EMPINI,RH3_EMPAPR") + "%"
	Else
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM, RH3_WKFAPV, RH3_WKFETP") + "%"
	EndIf

	If lCount
		xReturn:= 0
	Else
		xReturn:= {}
	EndIf

	cWhere := "% AND RH3.RH3_MATAPR = '" + cRegistration + "' AND RH3.RH3_FILAPR = '" + cBranch + "'"
	If !Empty(cFilterField) .AND. !Empty(cFilterValue)
		If !(Substr(cFilterField,1,1) == "@")
			cWhere += " AND RH3." + cFilterField + " LIKE '%" + cFilterValue + "%'"
		EndIf
	EndIf
	cWhere += "%"


	BEGINSQL ALIAS cQuery
		SELECT
		%Exp:cFields%
		FROM
		%Table:RH3% RH3
		WHERE
		NOT (RH3_FILINI = %exp:cBranch%        AND
		RH3_MATINI = %exp:cRegistration% ) AND
		RH3.%notDel%
		%Exp:cWhere%
	ENDSQL

	If lCount
		xReturn+= (cQuery)->REGISTROS
	Else
		While !(cQuery)->(Eof()) .AND.;
				Len(xReturn) < PAGE_LENGTH

			If nSkips < ((nPage-1) * PAGE_LENGTH)
				nSkips++
			Else
				If aScan( xReturn, {|x| AllTrim( x:Code ) == AllTrim( (cQuery)->RH3_CODIGO ) } ) == 0
					aAdd(xReturn, fBuildRequest(cQuery))
				EndIf
			EndIf

			(cQuery)->(dbSkip())
		EndDo
	EndIf

	(cQuery)->(dbCloseArea())

	RestArea(aArea)

Return xReturn


/*/{Protheus.doc} fGetAllReq
@history 22/01/2019, Cícero Alves, Incluido parâmetro MV_TIPSOLI
@see http://tdn.totvs.com/x/qpT7Gg
/*/
Function fGetAllReq(cBranch, cRegistration, cRequestType, nPage, cFilterField, cFilterValue, lCount, cOrdem, lPendentes, lAprovadas, lReprovadas, lRest)

	Local aArea	   	 := GetArea()
	Local aDeptos	 := {}
	Local aVisChav	 := {}
	Local cChaveLike := ""
	Local cChvLike   := ""
	Local cFields
	Local cFilSQB	 := ""
	Local cQuery	 := GetNextAlias()
	Local cRD4Alias  := "QRD4"
	Local cSQBAlias  := "QSQB"
	Local cStatus    := ""
	Local cTipoOrg   := ""
	Local cVisao	 := ""
	Local cWhere	 := "%"
	Local lQryResp	 := .F.
	Local nCount
	Local nPos	 	 := 0
	Local nPosVis 	 := 0
	Local nSkips 	 := 0
	Local xReturn
	Local aRet,cItem,cChave,cLike
	Local cFldSQB := '% SQB.QB_DEPTO %'
	Local cTipSolita := SuperGetMv("MV_TIPSOLI", , "")
	Local cFilTipos  := "%%"
	Local nI := 0
	Local aListEmp := {}
	Local cQry	:= ""

	Default lCount	 := .F.
	Default lRest	 := .F.

	If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM,RH3_EMP,RH3_EMPINI,RH3_EMPAPR") + "%"
	Else
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM") + "%"
	EndIf
	If lPendentes .And. !lRest
		cStatus := "'1','4','5'"
	Elseif lRest
		cStatus := "'1'" // apenas solicitações para o funcionário logado.
	EndIf
	If lAprovadas
		If !empty(cStatus)
			cStatus += ","
		EndIf
		cStatus += "'2'"
	EndIf
	If lReprovadas
		If !empty(cStatus)
			cStatus += ","
		EndIf
		cStatus += "'3'"
	EndIf

	If lCount
		xReturn:= 0
	Else
		xReturn:= {}
	EndIf

	cWhere := "%"
	If (!Empty(cRequestType)) .And. !lRest
		cWhere += " AND RH3.RH3_TIPO = '" + cRequestType + "'"
	Elseif lRest
		cWhere += " AND RH3.RH3_TIPO IN (" + cRequestType + ") "
	EndIf
	If !empty(cStatus)
		cWhere += " AND RH3.RH3_STATUS IN (" + cStatus + ") "
	Endif

	If !Empty(cFilterField) .AND. !Empty(cFilterValue)
		If !(Substr(cFilterField,1,1) == "@")
			cWhere += " AND RH3." + cFilterField + " LIKE '%" + cFilterValue + "%'"
		EndIf
	EndIf

	If !lCount
		If cOrdem == "decrescente"
           cWhere += " ORDER BY  " +  "RH3." + IIF(EMPTY(cFilterField),"RH3_CODIGO",cFilterField)  + " DESC"
       Else
           cWhere += " ORDER BY  " +  "RH3." + IIF(EMPTY(cFilterField),"RH3_CODIGO",cFilterField)
		EndIf
	EndIf
	cWhere += "%"

	BEGINSQL ALIAS cQuery
		SELECT
		DISTINCT RH3_VISAO,RH3_DTSOLI, RH3_CODIGO
		FROM
		%table:RH3% RH3
		WHERE
		RH3.%notDel%
		%exp:cWhere%
	ENDSQL

	While !(cQuery)->(Eof())
		lQryResp := .F.
		//Verifica se ja foi efetuado busca para a visao para nao refazer o processo a cada solicitacao na tabela
		If ( ( nPosVis := aScan( aVisChav, { |aVisChav| aVisChav[1] == (cQuery)->RH3_VISAO } ) ) == 0 )
			//Faz validacao do modo de acesso do Departamento
			//Compartilhado: nao faz filtro da filial do SRA e traz funcionarios do departamento
			//Exclusivo: faz filtro da filial do SRA de acordo com a filial do responsavel do departamento
			If Empty( xFilial("SQB") )
				cFilSQB := "%'" + xFilial("SQB") + "'%"
			Else
				cFilSQB := "%'" + xFilial( 'SQB', cBranch ) + "'%"
			EndIf
			cTipoOrg := ""
			TipoOrg(@cTipoOrg, (cQuery)->RH3_VISAO)

			If cTipoOrg == "0"
				//Carrega a estrutura de departamentos
				aDeptos	:= fEstrutDepto(cBranch)

				If SQB->(ColumnPos('QB_KEYINI'))>0
					cFldSQB := '% SQB.QB_DEPTO, SQB.QB_KEYINI, SQB.QB_FILIAL %'
				EndIf

				//Busca as chaves dos departamentso que o funcionario e' responsavel para verificar
				//todos os departamentos abaixo do nivel hierarquico da chave
				BeginSQL ALIAS cSQBAlias
					SELECT %Exp:cFldSQB%
					FROM %table:SQB% SQB
					WHERE SQB.QB_FILRESP = %exp:cBranch% 	AND
					SQB.QB_MATRESP = %exp:cRegistration% 	AND
					SQB.%notDel%
				EndSQL

				//Monta o filtro da instrucao Like de todos os departamentos que o funcionario e' o responsavel
				//Se nao for responsavel por nenhum, nao ira trazer de nenhum departamento

				While (cSQBAlias)->( !Eof() )
					If ( nPos := aScan( aDeptos, { |aDeptos| aDeptos[1] == (cSQBAlias)->QB_DEPTO .And. aDeptos[8] == (cSQBAlias)->QB_FILIAL} ) ) > 0
						If SQB->(ColumnPos('QB_KEYINI'))>0
							cChvLike 	+= " RH3_KEYINI LIKE '" + ALLTRIM((cSQBAlias)->QB_KEYINI) + "%' OR"
							lQryResp	:= .T.
						Else
							cChvLike 	+= " RH3_KEYINI LIKE '" + AllTrim( aDeptos[nPos][5] ) + "%' OR"
							lQryResp	:= .T.
						Endif
					EndIf
					(cSQBAlias)->( dbSkip() )
				End While
				If lQryResp
					cChaveLike := "% ("
					cChaveLike += SubStr( cChvLike, 1, Len(cChvLike)-3 )
					cChaveLike += ") %"
				Else
					cChaveLike := "% RH3_KEYINI = 'ZZZZZ' AND RH3_FILIAL = '"+xFilial("RH3",cBranch )+"'%"
				EndIf

				aAdd(aVisChav, { (cQuery)->RH3_VISAO, cChaveLike } )
				(cSQBAlias)->(dbCloseArea())

			ElseIf cTipoOrg == "1"
				cVisao := "%'" + (cQuery)->RH3_VISAO + "'%"
				aRet :={cRegistration,,cBranch}
				If ChaveRD4(cTipoOrg,@aRet,cVisao,@cItem,@cChave,@cLike)
					//Busca as chaves dos departamentso que o funcionario e' responsavel para verificar
					//todos os departamentos abaixo do nivel hierarquico da chave
					BeginSQL ALIAS cRD4Alias
						SELECT RD4.RD4_CHAVE
						FROM %table:RD4% RD4
						WHERE RD4.RD4_CODIGO = %exp:cVisao% AND
						RD4.RD4_FILIAL = %xFilial:RD4% AND
						SUBSTRING(RD4.RD4_CHAVE, 1,  %exp: Len(AllTrim(cChave))% ) = %exp:cChave% 	AND
						RD4.%notDel%
					EndSQL

					While !(cRD4Alias)->(Eof())
						cChvLike 	+= " RH3_KEYINI LIKE '" + AllTrim( (cRD4Alias)->RD4_CHAVE ) + "%' OR"
						lQryResp	:= .T.
						(cRD4Alias)->( dbSkip() )
					End While
					If lQryResp
						cChaveLike := "% ("
						cChaveLike += SubStr( cChvLike, 1, Len(cChvLike)-3 )
						cChaveLike += ") %"
					Else
						cChaveLike := "% RH3_KEYINI = 'ZZZZZ' %"
					EndIf

					aAdd(aVisChav, { (cQuery)->RH3_VISAO, cChaveLike } )
					(cRD4Alias)->(dbCloseArea())
				EndIf
			ElseIf cTipoOrg == "2"

				//Busca as chaves dos departamentso que o funcionario e' responsavel para verificar
				//todos os departamentos abaixo do nivel hierarquico da chave

				aListEmp := FWAllGrpCompany()
				cQry := ""
				For nI:=1 To Len(aListEmp)
					
					If !Empty(cQry)
						cQry += " UNION SELECT"
					EndIf
					
					cQry += " RD4SUP.RD4_CHAVE "
					cQry += " FROM " + RetFullName("SQB",aListEmp[nI]) + " SQB"
					cQry += " INNER JOIN " + RetFullName("RD4",aListEmp[nI]) + " RD4SUP ON RD4SUP.RD4_CODIDE = SQB.QB_DEPTO AND QB_FILIAL=RD4_FILIDE "
					cQry += " WHERE RD4SUP.RD4_CODIGO = '" + (cQuery)->RH3_VISAO + "' AND "
					cQry += " RD4SUP.RD4_FILIAL = '" + xFilial("RD4") + "' AND "
					cQry += " SQB.QB_FILRESP = '" + cBranch + "' 	AND "
					cQry += " SQB.QB_MATRESP = '" + cRegistration + "' 	AND "
					cQry += " RD4SUP.D_E_L_E_T_ = ' ' AND"
					cQry += " SQB.D_E_L_E_T_ = ' ' "
				Next nI
				
				cQry := "%" + cQry + "%"
				
				BeginSQL ALIAS cRD4Alias
					SELECT %exp:cQry%
				EndSQL

				//Monta o filtro da instrucao Like de todos os departamentos que o funcionario e' o responsavel
				//Se nao for responsavel por nenhum, nao ira trazer de nenhum departamento
				While (cRD4Alias)->( !Eof() )
					cChvLike 	+= " RH3_KEYINI LIKE '" + AllTrim( (cRD4Alias)->RD4_CHAVE ) + "%' OR"
					lQryResp	:= .T.
					(cRD4Alias)->( dbSkip() )
				End While
				If lQryResp
					cChaveLike := "% ("
					cChaveLike += SubStr( cChvLike, 1, Len(cChvLike)-3 )
					cChaveLike += ") %"
				Else
					cChaveLike := "% RH3_KEYINI = 'ZZZZZ' %"
				EndIf

				aAdd(aVisChav, { (cQuery)->RH3_VISAO, cChaveLike } )

				(cRD4Alias)->(dbCloseArea())
			EndIf
		EndIf
		(cQuery)->(DBSkip())
	EndDo

	(cQuery)->(dbCloseArea())

	// Filtra os tipo das solicitações definidos no parâmetro MV_TIPSOLI
	If ! Empty(cTipSolita )
		cTipSolita := fSQLin(cTipSolita, 1)
		cFilTipos := "% NOT (RH3_FILIAL = '" + cBranch + "' AND RH3_MAT = '" + cRegistration + "' AND RH3_EMP = '" + cEmpAnt + "' AND RH3_TIPO NOT IN (" + cTipSolita + ")) AND %"
	EndIf

	For nCount:= 1 To Len(aVisChav)
		If	RH3->(ColumnPos("RH3_EMPINI")) > 0
			BEGINSQL ALIAS cQuery
				SELECT
				%Exp:cFields%
				FROM
				%Table:RH3% RH3
				WHERE
				RH3_VISAO = %exp:aVisChav[nCount, 1]% AND
				%exp:aVisChav[nCount, 2]% AND
				NOT (RH3_FILINI = %exp:cBranch% AND
				RH3_MATINI = %exp:cRegistration% AND RH3_EMPINI=%exp:cEmpAnt%) AND
				%Exp: cFilTipos%
				RH3.%notDel%
				%Exp:cWhere%
			ENDSQL
		Else
			BEGINSQL ALIAS cQuery
				SELECT
				%Exp:cFields%
				FROM
				%Table:RH3% RH3
				WHERE
				RH3_VISAO = %exp:aVisChav[nCount, 1]% AND
				%exp:aVisChav[nCount, 2]% AND
				NOT (RH3_FILINI = %exp:cBranch% AND
				RH3_MATINI = %exp:cRegistration% ) AND
				%Exp: cFilTipos%
				RH3.%notDel%
				%Exp:cWhere%
			ENDSQL
		EndIf
		If lCount
			xReturn+= (cQuery)->REGISTROS
		Else
			If !(nPage == 0)
				While !(cQuery)->(Eof()) .AND.;
					Len(xReturn) < PAGE_LENGTH

					If nSkips <	((nPage-1) * PAGE_LENGTH)
						nSkips++
					Else
						If aScan( xReturn, {|x| AllTrim( x:Code ) == AllTrim( (cQuery)->RH3_CODIGO ) } ) == 0
							aAdd(xReturn, fBuildRequest(cQuery))
						EndIf
					EndIf

					(cQuery)->(dbSkip())
				EndDo
			Else
				While !(cQuery)->(Eof())
					aAdd(xReturn, fBuildRequest(cQuery))
					(cQuery)->(dbSkip())
				EndDo
			EndIF
		EndIf

		(cQuery)->(dbCloseArea())
	Next

	RestArea(aArea)
Return xReturn

Static Function fGetReqItems(cBranch, cCode)
	Local aArea:= GetArea()
	Local aItems:= {}
	Local cQuery:= GetNextAlias()

	cBranch:= xFilial("RH4", cBranch)

	BEGINSQL ALIAS cQuery
		SELECT
		RH4.RH4_FILIAL,
		RH4.RH4_CODIGO,
		RH4.RH4_ITEM,
		RH4.RH4_CAMPO,
		RH4.RH4_VALANT,
		RH4.RH4_VALNOV
		FROM
		%table:RH4% RH4
		WHERE
		RH4.RH4_FILIAL = %exp:cBranch% AND
		RH4.RH4_CODIGO = %exp:cCode% AND
		RH4.%notDel%
	ENDSQL

	While !(cQuery)->(Eof())
		oItem:=	WsClassNew("TRequestItem")
		oItem:Branch			:= (cQuery)->RH4_FILIAL
		oItem:RequestCode		:= Alltrim((cQuery)->RH4_CODIGO)
		oItem:FieldName			:= Alltrim((cQuery)->RH4_CAMPO)
		oItem:FieldDescription	:= Alltrim(RetTitle((cQuery)->RH4_CAMPO))
		oItem:PreviousValue		:= Alltrim((cQuery)->RH4_VALANT)
		oItem:NewValue			:= Alltrim((cQuery)->RH4_VALNOV)
		oItem:Sequence			:= (cQuery)->RH4_ITEM

		If Empty(oItem:FieldDescription)
			If oItem:FieldName == "TMP_NOME"
				oItem:FieldDescription := STR0008 //"Nome"
			EndIf
			If oItem:FieldName == "TMP_VAGA"
				oItem:FieldDescription := STR0053 //"Cod. Vaga"
			EndIf
			If oItem:FieldName == "TMP_DESC"
				oItem:FieldDescription := STR0054 //"Descricao"
			EndIf
		EndIf

		Aadd(aItems, oItem)

		(cQuery)->(dbSkip())
	EndDo

	(cQuery)->(dbCloseArea())

	RestArea(aArea)
Return aItems


Static Function fBuildRequest(cQueryAlias,cIDMENU)
	Local cAliasRGK	  := ""
	Local cFilApr	  := ""
	Local cMatApr	  := ""
	Local nPos
	Local oRequest    := WSClassNew("TRequest")
	Local aBoxStatus  := RetSx3Box( Posicione("SX3", 2, "RH3_STATUS", "X3CBox()" ),,, 1 )
	Local aPages      := {	{"2", "W_PWES01.APW"},;
							{"3", "W_PWSA112.APW"},;
							{"4", "W_PWSA141.APW"},;
							{"5", "W_PWSA112.APW"},;
							{"6", "W_PWSA131.APW"},;
							{"7", "W_PWSA121.APW"},;
							{"8", "W_PWSA161.APW"},;
							{"9", ""             },;
							{"A", "W_PWSA223.APW"},;
							{"B", "W_PWSA102.APW"},;
							{"H", ""             },;
							{"N", "W_PWSA511.APW"},;
							{"O", "W_PWSA521.APW"},;
							{"P", "W_PWSA531.APW"},;
							{"Q", "W_PWSA541.APW"},;
							{"R", "W_PWSA551.APW"},;
							{"S", "W_PWSA561.APW"},;
							{"T", "W_PWSA571.APW"},;
							{"V", "W_PWSA381.APW"},;
							{"Z", "W_PWSA401.APW"};
						}

	//O parametro MV_SIGAGFP = "2" identifica que eh GSP-Caixa.
	Local cGSP := SuperGetMv("MV_SIGAGFP",,"1")
	Default cIDMENU:= ""
	If cGSP >= "2"
		cGSP := "3"
	EndIf


	oRequest:Branch				   := (cQueryAlias)->RH3_FILIAL
	oRequest:Code				   := (cQueryAlias)->RH3_CODIGO
	oRequest:Registration		   := (cQueryAlias)->RH3_MAT
	oRequest:RequestDate		   := StoD((cQueryAlias)->RH3_DTSOLI)
	oRequest:ResponseDate		   := StoD((cQueryAlias)->RH3_DTATEN)

	oRequest:Status                 := WsClassNew("TRequestStatus")
	oRequest:Status:Code			:= (cQueryAlias)->RH3_STATUS
	oRequest:Status:Description	   	:= PorEncode(Alltrim(aBoxStatus[Ascan( aBoxStatus, { |aBox| aBox[2] = (cQueryAlias)->RH3_STATUS  } )][3]))

	oRequest:RequestType              := WsClassNew("TRequestType")
	oRequest:RequestType:Code		  := (cQueryAlias)->RH3_TIPO
	oRequest:RequestType:Description  := PorEncode(AllTrim(fDesc("SX5", "JQ" + (cQueryAlias)->RH3_TIPO, "X5DESCRI()")))

	If ((nPos:= Ascan(aPages, { |aLink| aLink[1] == (cQueryAlias)->RH3_TIPO } )) > 0)
		oRequest:RequestType:Link:= aPages[nPos, 2]
	Else
		oRequest:RequestType:Link:= ""
	EndIf

	oRequest:StarterLevel			:= (cQueryAlias)->RH3_NVLINI
	oRequest:StarterBranch			:= (cQueryAlias)->RH3_FILINI
	oRequest:StarterRegistration	:= (cQueryAlias)->RH3_MATINI
	oRequest:ApproverLevel			:= (cQueryAlias)->RH3_NVLAPR
	oRequest:ApproverBranch			:= (cQueryAlias)->RH3_FILAPR
	oRequest:ApproverRegistration	:= (cQueryAlias)->RH3_MATAPR
	If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
		oRequest:EMPRESA				:= (cQueryAlias)->RH3_EMP
		oRequest:EMPRESAINI				:= (cQueryAlias)->RH3_EMPINI
		oRequest:EMPRESAAPR				:= (cQueryAlias)->RH3_EMPAPR
	Else
		oRequest:EMPRESA				:= cEmpAnt
		oRequest:EMPRESAINI				:= cEmpAnt
		oRequest:EMPRESAAPR				:= cEmpAnt
	EndIf
	If (cQueryAlias)->RH3_STATUS == "1"//Pendente para superior
		If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
			oRequest:ApproverName	:= GetAnyDesc((cQueryAlias)->RH3_EMPAPR, (cQueryAlias)->RH3_FILAPR, "SRA", (cQueryAlias)->RH3_MATAPR )
		Else
			oRequest:ApproverName	:= Alltrim(Posicione('SRA',1,(cQueryAlias)->RH3_FILAPR+(cQueryAlias)->RH3_MATAPR,'SRA->RA_NOME'))
		EndIf
	ElseIf (cQueryAlias)->RH3_STATUS == "2"//Aprovada pelo RH
		oRequest:ApproverName	:= STR0028//RH
	ElseIf (cQueryAlias)->RH3_STATUS == "3"//Reprovada superior/RH
		If Empty( (cQueryAlias)->RH3_DTATEN )//Reprovada pelo superior
			cAliasRGK := GetNextAlias()
			BeginSql Alias cAliasRGK
				SELECT RGK.*
				FROM %table:RGK% RGK
				WHERE RGK.RGK_CODIGO = %exp:(cQueryAlias)->RH3_CODIGO% AND
				RGK.RGK_OPERAC = '4' AND
				RGK.%notDel%
			EndSql

			While !(cAliasRGK)->(Eof())
				cFilApr	  := (cAliasRGK)->RGK_FILAPR
				cMatApr	  := (cAliasRGK)->RGK_MATAPR
				(cAliasRGK)->(dbSkip())
			EndDo
			(cAliasRGK)->(dbCloseArea())
			oRequest:ApproverName	:= If(! Empty(Alltrim(Posicione('SRA',1,cFilApr+cMatApr,'RA_NOMECMP'))),SRA->RA_NOMECMP, SRA->RA_NOME )
		Else//Reprovada pelo RH
			oRequest:ApproverName	:= STR0028//RH
		EndIf
	ElseIf (cQueryAlias)->RH3_STATUS == "4"//Pendente RH
		oRequest:ApproverName	:= PorEncode(STR0029)//Aguardando Efetivacao do RH
	EndIf
	oRequest:Vision					:= (cQueryAlias)->RH3_VISAO
	oRequest:WFID					:= (cQueryAlias)->RH3_WFID
	oRequest:Source					:= (cQueryAlias)->RH3_ORIGEM
	oRequest:Observation			:= ""

	If cGSP == '3' .And. cIDMENU=="GFP"// Gestao Publica - MP
		oRequest:WFAprov           := (cQueryAlias)->RH3_WKFAPV
		oRequest:WFStage           := (cQueryAlias)->RH3_WKFETP
	Else
		oRequest:WFAprov           := ""
		oRequest:WFStage           := ""
	EndIf

	oRequest:Items 					:= fGetReqItems((cQueryAlias)->RH3_FILIAL, (cQueryAlias)->RH3_CODIGO)
Return oRequest


Static Function fGetMyReq(cBranch, cRegistration, cType, nPage, cFilterField, cFilterValue, lCount, cOrdem, lPendentes, lAprovadas, lReprovadas,cIDMENU)
	Local aArea		:= GetArea()
	Local cRH3Alias	:= GetNextAlias()
	Local cWhere    	:= "%"
	Local cStatus   	:= ""
	Local xReturn
	Local cFields
	//O parametro MV_SIGAGFP = "2" identifica que eh GSP-Caixa.
	Local cGSP 	:= SuperGetMv("MV_SIGAGFP",,"1")
	Default cIDMENU	:= ""

	If cGSP >= "2"
		cGSP := "3"
	EndIf

	Default lCount := .F.

	If cGSP == '3' // Gestao Publica - RH
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR,RH3_EMP,RH3_EMPINI,RH3_EMPAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM, RH3_WKFAPV, RH3_WKFETP") + "%"
	Else
		If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
			cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR,RH3_EMP,RH3_EMPINI,RH3_EMPAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM, RH3_EMP,RH3_EMPAPR,RH3_EMPINI") + "%"
		Else
			cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR,RH3_EMP,RH3_EMPINI,RH3_EMPAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM") + "%"
		EndIf
	EndIf

	If lPendentes
		cStatus := "'1','4','5'"
	EndIf
	If lAprovadas
		If !empty(cStatus)
			cStatus += ","
		EndIf
		cStatus += "'2'"
	EndIf
	If lReprovadas
		If !empty(cStatus)
			cStatus += ","
		EndIf
		cStatus += "'3'"
	EndIf

	cWhere += "RH3.RH3_FILINI =  '" + xFilial("RH3", cBranch) + "'"

	//filtro por tipo de requisicao
	If !Empty(cType)
		cWhere += " AND RH3.RH3_TIPO =  '" + cType + "'"
	EndIf

	//filtro por matricula
	If !Empty(cRegistration)
		cWhere += " AND RH3.RH3_MATINI =  '" + cRegistration + "'"
	EndIf

	If !Empty(cFilterField) .AND. !Empty(cFilterValue)
		If !(Substr(cFilterField,1,1) == "@")
			cWhere += " AND RH3." + cFilterField + " LIKE '%" + cFilterValue + "%'"
		EndIf
	EndIf

	//filtro por status
	If !empty(cStatus)
		cWhere += " AND RH3.RH3_STATUS IN (" + cStatus + ") "
	Endif
/*	If Empty(cIDMENU) .Or. cIDMENU != "GFP"
		cWhere+= " AND RH3.RH3_ORIGEM <> 'SIGAGFP' "
	Else
		cWhere+= " AND RH3.RH3_ORIGEM =  'SIGAGFP' "
	EndIf	*/
	//ordenamento
	If !lCount
		If cOrdem == "decrescente"
           cWhere += " ORDER BY  " +  "RH3." + IIF(EMPTY(cFilterField),"RH3_CODIGO",cFilterField)  + " DESC"
		Else
			cWhere += " ORDER BY RH3.RH3_DTSOLI, RH3.RH3_CODIGO "
		EndIf
	EndIf

	cWhere += "%"

	BEGINSQL ALIAS cRH3Alias
		SELECT %exp:cFields%
		FROM %table:RH3% RH3
		WHERE RH3.%notDel% AND
		%exp:cWhere%
	ENDSQL

	If lCount
		xReturn:= (cRH3Alias)->REGISTROS
	Else
		xReturn:= {}

		If nPage > 1
			DBSkip((nPage-1) * PAGE_LENGTH)
		EndIf

		If !(nPage == 0)
			While !(cRH3Alias)->(Eof()) .AND.;
				  Len(xReturn) < PAGE_LENGTH
				AAdd(xReturn, fBuildRequest(cRH3Alias,cIDMENU))

				(cRH3Alias)->(dbSkip())
			EndDo
		Else
			While !(cRH3Alias)->(Eof())
				AAdd(xReturn, fBuildRequest(cRH3Alias,cIDMENU))

				(cRH3Alias)->(dbSkip())
			EndDo
		EndIf
	EndIf

	(cRH3Alias)->(dbCloseArea())

	RestArea(aArea)
Return xReturn

/*
Candidatos Externos
*/
Static Function fGetMyReqExt(cCpfCExt, cType, nPage, cFilterField, cFilterValue, lCount,cIDMENU)
	Local aArea			:= GetArea()
	Local cRH3Alias		:= GetNextAlias()
	Local xReturn
	Local cWhere		:= "%"
	Local cFields

	Default cIDMENU	 	:= ""
	Default lCount		:= .F.

	If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM, RH3_EMP,RH3_EMPAPR,RH3_EMPINI") + "%"
	Else
		cFields:= "%" + IIF(lCount, "COUNT(*) AS REGISTROS", "RH3_FILIAL, RH3_CODIGO, RH3_MAT, RH3_DTSOLI, RH3_DTATEN, RH3_STATUS, RH3_TIPO, RH3_NVLINI, RH3_FILINI, RH3_MATINI, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO, RH3_WFID, RH3_ORIGEM") + "%"
	EndIf

	cWhere += " RH4.RH4_CAMPO = 'QG_CIC'"
	cWhere += " AND RH4.RH4_VALNOV = '" + cCpfCExt + "'"

	//filtro por tipo de requisicao
	If !Empty(cType)
		cWhere += " AND RH3.RH3_TIPO =  '" + cType + "'"
	EndIf

	If !Empty(cFilterField) .AND. !Empty(cFilterValue)
		If !(Substr(cFilterField,1,1) == "@")
			cWhere += " AND RH3." + cFilterField + " LIKE '%" + cFilterValue + "%'"
		EndIf
	EndIf

	If cIDMENU != "GCH"
		cWhere+= " AND RH3.RH3_ORIGEM <> 'SIGAGFP'"
	ElseIf cIDMENU != "GFP"
		cWhere+= " AND RH3.RH3_ORIGEM =  'SIGAGFP'"
	EndIf
	cWhere += "%"

	BEGINSQL ALIAS cRH3Alias
		SELECT %exp:cFields%
		FROM %table:RH3% RH3
		INNER JOIN %table:RH4% RH4
		ON RH4.RH4_FILIAL = RH3.RH3_FILIAL
		AND RH4.RH4_CODIGO = RH3.RH3_CODIGO
		WHERE RH3.%notDel% AND
		RH4.%notDel% AND
		%exp:cWhere%
	ENDSQL

	If lCount
		xReturn:= (cRH3Alias)->REGISTROS
	Else
		xReturn:= {}

		If nPage > 1
			DBSkip((nPage-1) * PAGE_LENGTH)
		EndIf

		While !(cRH3Alias)->(Eof()) .AND.;
				Len(xReturn) < PAGE_LENGTH
			AAdd(xReturn, fBuildRequest(cRH3Alias,cIDMENU))

			(cRH3Alias)->(dbSkip())
		EndDo
	EndIf

	(cRH3Alias)->(dbCloseArea())

	RestArea(aArea)
Return xReturn


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetRequestHistory³ Autor ³Flavio S. Correa  ³Data ³01.12.2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem das Solicitacoes                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetRequestHistory WSRECEIVE RequestId,ParticipantId,Branch,IDMENU WSSEND RequestHistory WSSERVICE RHRequest
	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local cAlias		:= "QRGK"
	Local cCodigo		:= ::RequestId
	Local nI			:= 1
	Local aOperacoes
	Local aStatus
	Local nNivel
	Local cVisao
	Local cFilApr
	Local cMatApr
	Local cEmpApr
	Local cTree		:= ""
	Local cItem		:= ""
	Local cAliasQry	:= ""
	Local cTabela		:= ""
	Local cWhere		:= ""
	Local aSup		:= {}
	Local cFilRDY	:= ""
	Local cAliasRh4 := "QRH4"

	Default Self:IDMENU	:= ""
	If Empty(cCodigo)
		SetSoapFault("GetRequestHistory",STR0006)
		Return .F.
	EndIf

	::RequestHistory 					 		:= WsClassNew('TRequestHistory')
	::RequestHistory:ListOfReqHistory 			:= {}
	::RequestHistory:Code						:= cCodigo
	cWhere:= "%"
	If Empty(::IDMENU ) .Or. ::IDMENU != "GFP"
		cWhere+= " AND RH3.RH3_ORIGEM <> 'SIGAGFP' "
	Else
		cWhere+= " AND RH3.RH3_ORIGEM =  'SIGAGFP' "
	EndIf
	cWhere+= "%"
// Busca Solicitante
If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
	BeginSql alias cAlias
		SELECT 	RH3.RH3_FILIAL, RH3.RH3_MAT, RH3.RH3_FILINI, RH3.RH3_MATINI, RH3_TIPO, RH3_STATUS, RH3_NVLAPR, RH3_FILAPR, RH3_MATAPR, RH3_VISAO,RH3_EMP,RH3_EMPINI,RH3_EMPAPR
		FROM %table:RH3% RH3
		WHERE RH3.RH3_CODIGO = %exp:cCodigo% AND
		RH3.%notDel%
	EndSql
Else
	BeginSql alias cAlias
		SELECT 	RH3.RH3_FILIAL, RH3.RH3_MAT, RH3.RH3_FILINI, RH3.RH3_MATINI, RH3.RH3_TIPO, RH3.RH3_STATUS, RH3.RH3_NVLAPR, RH3.RH3_FILAPR, RH3.RH3_MATAPR, RH3.RH3_VISAO
		FROM %table:RH3% RH3
		WHERE RH3.RH3_CODIGO = %exp:cCodigo% AND
			RH3.%notDel% %exp:cWhere%
	EndSql
EndIf
	If !(cAlias)->(Eof())
		//somente o solicitante ou um dos aprovadores pode ver o historico
		If !Empty(::ParticipantId)
			If ::Branch+::ParticipantId != (cAlias)->RH3_FILIAL+(cAlias)->RH3_MAT .and. ::Branch+::ParticipantId != (cAlias)->RH3_FILAPR+(cAlias)->RH3_MATAPR
				If (cAlias)->RH3_TIPO $ "3|5"
					BeginSql alias cAliasRh4
						SELECT 	RH4.RH4_FILIAL, RH4.RH4_CODIGO, RH4.RH4_VALNOV
						FROM %table:RH4% RH4
						WHERE RH4.RH4_FILIAL = %exp:(cAlias)->RH3_FILIAL% AND
						RH4.RH4_CODIGO = %exp:cCodigo% AND
						RH4.RH4_CAMPO  = "RBT_DEPTO" AND
						RH4.%notDel%
					EndSql
					fAllSuperior((cAlias)->RH3_VISAO,(cAlias)->RH3_FILIAL,(cAlias)->RH3_MAT,@aSup,,,,Alltrim((cAliasRh4)->RH4_VALNOV))
					(cAliasRh4)->(dbCloseArea())
				Else
					fAllSuperior((cAlias)->RH3_VISAO,(cAlias)->RH3_FILIAL,(cAlias)->RH3_MAT,@aSup)
				EndIf
				If Len(aSup) > 0
					If Ascan(aSup,{|x| x[1][1] == ::Branch .And. x[1][2] == ::ParticipantId}) <= 0
						SetSoapFault("GetRequestHistory",STR0038)//"Solicitação não encontrada para este usuário"
						(cAlias)->(dbCloseArea())
						Return .F.
					EndIf
				Else
					SetSoapFault("GetRequestHistory",STR0038)//"Solicitação não encontrada para este usuário"
					(cAlias)->(dbCloseArea())
					Return .F.
				EndIf
			EndIf
		EndIf
		aOperacoes:= RetSx3Box(Posicione("SX3", 2, "RH3_STATUS", "X3CBox()" ), NIL, NIL, 1)

		::RequestHistory:Branch					:= (cAlias)->RH3_FILIAL
		::RequestHistory:Registration			:= (cAlias)->RH3_MAT
		If RH3->(ColumnPos("RH3_EMP")) > 0
			::RequestHistory:Name				  	:= GetAnyDesc((cAlias)->RH3_EMP, (cAlias)->RH3_FILIAL, "SRA", (cAlias)->RH3_MAT )
		Else
			::RequestHistory:Name				  	:= Alltrim(Posicione('SRA',1,(cAlias)->RH3_FILIAL+(cAlias)->RH3_MAT,'SRA->RA_NOME'))
		EndIf
		::RequestHistory:PetitionerBranch 		:= (cAlias)->RH3_FILINI
		::RequestHistory:PetitionerRegistration := (cAlias)->RH3_MATINI
		If RH3->(ColumnPos("RH3_EMPINI")) > 0
			::RequestHistory:PetitionerName			:= GetAnyDesc((cAlias)->RH3_EMPINI, (cAlias)->RH3_FILINI, "SRA", (cAlias)->RH3_MATINI )
		Else
			::RequestHistory:PetitionerName			:= Alltrim(Posicione('SRA',1,(cAlias)->RH3_FILINI+(cAlias)->RH3_MATINI,'SRA->RA_NOME'))
		EndIf
		::RequestHistory:TypeCode	  			:= (cAlias)->RH3_TIPO
		::RequestHistory:DescriptionType		:= PorEncode(AllTrim(fDesc("SX5", "JQ" + (cAlias)->RH3_TIPO, "X5DESCRI()")))
		::RequestHistory:StatusCode		 		:= (cAlias)->RH3_STATUS
		::RequestHistory:DescriptionStatus		:= PorEncode(Alltrim(aOperacoes[Ascan( aOperacoes, { |aBox| aBox[2] = (cAlias)->RH3_STATUS} )][3]))

		nNivel                             := (cAlias)->RH3_NVLAPR
		cFilApr                            := (cAlias)->RH3_FILAPR
		cMATApr                            := (cAlias)->RH3_MATAPR
		cVisao                             := (cAlias)->RH3_VISAO
		If RH3->(ColumnPos("RH3_EMPAPR")) > 0
			cEmpApr							   := (cAlias)->RH3_EMPAPR
		EndIf
	EndIf
	(cAlias)->(dbCloseArea())

	// Busca Historico
	aOperacoes:= RetSx3Box(Posicione("SX3", 2, "RGK_OPERAC", "X3CBox()" ), NIL, NIL, 1)
	aStatus   := RetSx3Box(Posicione("SX3", 2, "RH3_STATUS", "X3CBox()" ), NIL, NIL, 1)

	BeginSql alias cAlias
		SELECT RGK.*
		FROM %table:RGK% RGK
		WHERE RGK.RGK_CODIGO = %exp:cCodigo% AND
		RGK.%notDel%
		ORDER BY RGK.RGK_CODIGO,RGK.RGK_SEQUEN
	EndSql

	While !(cAlias)->(Eof())
		aadd(::RequestHistory:ListOfReqHistory,wsClassNew("DataReqHistory"))

		::RequestHistory:ListOfReqHistory[nI]:Sequence	 		   := (cAlias)->RGK_SEQUEN
		::RequestHistory:ListOfReqHistory[nI]:ChangeDate   		   := StoD((cAlias)->RGK_DATA)
		::RequestHistory:ListOfReqHistory[nI]:ApproverBranch	   := (cAlias)->RGK_FILAPR
		::RequestHistory:ListOfReqHistory[nI]:ApproverRegistration := (cAlias)->RGK_MATAPR
		If RGK->(ColumnPos("RGK_EMP")) > 0
			::RequestHistory:ListOfReqHistory[nI]:ApproverName     := GetAnyDesc((cAlias)->RGK_EMP, (cAlias)->RGK_FILAPR, "SRA", (cAlias)->RGK_MATAPR )
		Else
			::RequestHistory:ListOfReqHistory[nI]:ApproverName	   := Alltrim(Posicione('SRA',1,(cAlias)->RGK_FILAPR+(cAlias)->RGK_MATAPR,'SRA->RA_NOME'))
		EndIf
		::RequestHistory:ListOfReqHistory[nI]:ContentCode			:= (cAlias)->RGK_CODCON
		::RequestHistory:ListOfReqHistory[nI]:Content					:= ""
		//Para nao gravar chaves iguais para filiais diferentes
		//Caso da RDY estar compartilhada entre empresas e a pesquisa partir de um empresa diferente da que esta gravada
		If !Empty((cAlias)->RGK_CODCON)	 .AND. !Empty((cAlias)->RGK_CODCON)
			cAliasQry	:= GetNextAlias()
			cFilRDY := "%'" + xFilial( 'RDY', (cAlias)->RGK_FILAPR ) + "'%"
			BeginSQL alias cAliasQry
				SELECT RDY.RDY_TEXTO
				FROM %table:RDY% RDY
				WHERE RDY.RDY_FILIAL = %exp:cFilRDY% 	AND
				      RDY.RDY_CHAVE = %exp:(cAlias)->RGK_CODCON% AND
				      RDY.%notDel%
			EndSQL

			While !(cAliasQry)->(Eof())
				::RequestHistory:ListOfReqHistory[nI]:Content    += (cAliasQry)->RDY_TEXTO
				(cAliasQry)->(dbSkip())
			EndDo
			(cAliasQry)->(dbCloseArea())

		EndIf

		::RequestHistory:ListOfReqHistory[nI]:Operation				:= PorEncode(Alltrim(aOperacoes[Ascan( aOperacoes, { |aBox| aBox[2] = (cAlias)->RGK_OPERAC} )][3]))

		nI++
		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())


	If Len(::RequestHistory:ListOfReqHistory) == 0
		SetSoapFault("GetRequestHistory",STR0007)
		Return .F.
	Else
		//Mostra no historico onde a solicitacao esta pendente
		If ::RequestHistory:StatusCode $ "1|4|5"
			aadd(::RequestHistory:ListOfReqHistory,wsClassNew("DataReqHistory"))

			::RequestHistory:ListOfReqHistory[nI]:Sequence            := str((val(::RequestHistory:ListOfReqHistory[nI - 1]:Sequence) + 1))
			::RequestHistory:ListOfReqHistory[nI]:ChangeDate           := SToD("")
			::RequestHistory:ListOfReqHistory[nI]:ApproverBranch       := ""
			::RequestHistory:ListOfReqHistory[nI]:ApproverRegistration  := ""
			::RequestHistory:ListOfReqHistory[nI]:ContentCode          := ""
			::RequestHistory:ListOfReqHistory[nI]:Content              := ""
			::RequestHistory:ListOfReqHistory[nI]:Operation            := STR0027 //"Pendente"

			If nNivel == 99
				::RequestHistory:ListOfReqHistory[nI]:ApproverName            := Alltrim(aStatus[Ascan( aOperacoes, { |aBox| aBox[2] = "4"} )][3]) //"Aguardando efetivacao do RH"
			Else
				If nNivel == 98
					::RequestHistory:ListOfReqHistory[nI]:ApproverName        := Alltrim(aStatus[Ascan( aOperacoes, { |aBox| aBox[2] = "5"} )][3]) //"Aguardando aprovacao do RH"
				Else
					::RequestHistory:ListOfReqHistory[nI]:ApproverBranch      := cFILAPR
					::RequestHistory:ListOfReqHistory[nI]:ApproverRegistration := cMATAPR

					::RequestHistory:ListOfReqHistory[nI]:ApproverName        := GetAnyDesc(cEMPAPR, cFILAPR, "SRA", cMATAPR )
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(aArea)
Return lRet



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    PutWorkflowVacProg ³ Autor ³Tatiane V. Matias³Data ³28.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que atualiza o ID do workflow da programacao de ferias ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD PutIDWFRequest WSRECEIVE RequestId, WFData WSSEND WsNull WSSERVICE RHRequest
	Local lRet   := .T.
	Local nField := 0

	dbSelectArea("RH3")
	RH3->( dbSetOrder(1) )

	If RH3->( dbSeek(xFilial("RH3") + ::RequestId ) )
		For nField := 1 to Len(::WFData:ListOfWorkFlow)
			If RH3->(FieldPos(::WFData:ListOfWorkFlow[nField]:FieldWF)) > 0
				If RecLock("RH3",.F.)
					&(::WFData:ListOfWorkFlow[nField]:FieldWF) := ::WFData:ListOfWorkFlow[nField]:ValueField
					MsUnLock()
				EndIf
			EndIf
		Next nField
	Else
		SetSoapFault("PutIDWFRequest", STR0003)
		lRet := .F.
	EndIf

	RH3->( DbCloseArea() )
Return lRet

Function GetSuperior(cFilFun, cMatFun, cVisao)
	Local cChave:= fBuscaChaveFuncionario(cFilFun, cMatFun, cVisao)
	Local aSuper

	cChave:= Left(cChave, Len(cChave)-3)

	While (aSuper == NIL) .AND. Len(cChave) > 0
		aSuper:= fGetEmployee(cVisao, cChave)

		If aSuper == NIL
			cChave:= Left(cChave, Len(cChave)-3)
		Else
			AAdd(aSuper, cChave)
			AAdd(aSuper, (len(cChave)/3)-1)
		EndIf
	EndDo
Return aSuper

WSMETHOD AddVacationRequest	WSRECEIVE Request, VacationRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()
	Local lWsPeFerVal := Existblock("WSGPEVALVAC") //P.E. para validar os dados da solicitação de ferias
	Local lRetPeData  := .T.

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code            := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "B"	//Ferias
	Self:Request:Status:Code		:= "1"
	Self:Request:RequestDate      := dDataBase
	Self:Request:StarterKey	      := fBuscaChaveFuncionario(	Self:Request:Branch,;
		Self:Request:Registration,;
		Self:Request:Vision)

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code			:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code			:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	//wap.sn
	If lWsPeFerVal

		lRetPeData := ExecBlock( "WSGPEVALVAC", .F.,.F.,{Self:VacationRequest:InitialDate,Self:VacationRequest:FinalDate,Self:VacationRequest:Days})

		If ValType(lRetPeData) == "L" .AND. lRetPeData == .F.

           SetSoapFault("AddVacationRequest", STR0051)

           Return (lRetPeData)

        EndIf

	EndIf
	//wap.en

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddVacationRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddVacationRequest(Self:VacationRequest, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddVacationRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddVacationRequest", STR0003)
			Break
		EndIf

	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	Else
		Return .F.
	EndIf
Return .T.

Function fAddVacationRequest(oVacationRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", oVacationRequest:Branch)
	Local aRegs		:={	{"R8_FILIAL",		oVacationRequest:Branch},;
		{"R8_MAT",  		oVacationRequest:Registration},;
		{"TMP_NOME",  		oVacationRequest:Name},;
		{"R8_DATAINI",		oVacationRequest:InitialDate},;
		{"R8_DATAFIM",		oVacationRequest:FinalDate},;
		{"R8_DURACAO",		AllTrim(Str(oVacationRequest:Days))},;
		{"TMP_ABONO",		oVacationRequest:PecuniaryAllowance},;
		{"TMP_1P13SL",		oVacationRequest:ThirteenthSalary1stInstall},;
		{"TMP_DABONO",		AllTrim(Str(oVacationRequest:PecuniaryDays))} }

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM	:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf
Return nReturnCode

WSMETHOD GetDescription WSRECEIVE TableSearch, TableIndex, KeyField, FieldResponse WSSEND FieldDescription WSSERVICE RHRequest
	Local lRet	:= .T.
	Local cChave:= KeyField
	Local cDesc := ""
	Local cFilF	:= ""
	Local nTamC	:= 0
	Local nTamF	:= FWGETTAMFILIAL
	Local aTabS043 := {}
	Local lSP6 := .F.

	//Efetua o tratamento de xFilial para a tabela SP6
	If TableSearch == "SP6"
		nTamC	:= TamSx3("P6_CODIGO")[1]
		cFilF	:= SubStr( KeyField, 1, nTamF )
		cChave  := xFilial( TableSearch, cFilF ) + SubStr( KeyField, nTamF + 1, nTamC )
		lSP6 := .T.
	EndIf

	If TableSearch == "RCC"
	//Chama fCarrTab para carregar tabela auxiliar S033
		fCarrTab( @aTabS043, substr(::KeyField,1,4), date() ,.T.)

		nPos := ascan(aTabS043,{|x| x[5]==substr(::KeyField,5,2)})
		If nPos > 0
			::FieldDescription := aTabS043[nPos][06]
		EndIf
	Else
		cDesc := Alltrim(Posicione(TableSearch,val(TableIndex),cChave,FieldResponse))
		If lSP6
			If SP6->P6_PREABO == "N"
				cDesc := ""
				SetSoapFault("GetDescription", STR0050)//"Motivo não permite pré abono"
				lRet := .F.
			EndIF
		EndIF
		If cDesc == ""
			::FieldDescription := ""
		Else
			::FieldDescription := cDesc
		Endif
	EndIf
Return lRet

WSMETHOD AddAcademicGrantRequest	WSRECEIVE Request, AcademicGrantRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local nSaveSX8 := GetSX8Len()
	Local aArea	:= GetArea()


	RestArea(aArea)

	Self:Request:RequestType		:= WSClassNew("TRequestType")
	Self:Request:Status				:= WSClassNew("TRequestStatus")

	Self:Request:Code            	:= GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
	Self:Request:RequestType:Code	:= "V"	//Subsídio Acadêmico
	Self:Request:Status:Code		:= "1"
	Self:Request:RequestDate      	:= dDataBase
	Self:Request:StarterKey	      	:= fBuscaChaveFuncionario(	Self:Request:Branch,;
										      				        Self:Request:Registration,;
												    		        Self:Request:Vision)

	If Empty(Self:Request:ApproverRegistration)
		Self:Request:StarterLevel			:= 0
		Self:Request:Status:Code				:= "4"
		Self:Request:ResponseDate 			:= dDataBase
	Else
		Self:Request:StarterLevel			:= Self:Request:ApproverLevel+1
		Self:Request:Status:Code				:= "1"
		Self:Request:ResponseDate 	   		:= CTod("")
	EndIf

	Begin Transaction
		nReturnCode:= fPutRequest(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddAcademicGrantRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fAddAcademicGrantRequest(Self:AcademicGrantRequest, Self:Request:Code, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddAcademicGrantRequest", STR0003)
			Break
		EndIf

		nReturnCode:= fPutHistory(Self:Request, OPERATION_INSERT)
		If nReturnCode > 0
			SetSoapFault("AddAcademicGrantRequest", STR0003)
			Break
		Else
			fFluig(Self:Request,OPERATION_INSERT,"SOLRHV")
		EndIf

	End Transaction

	If nReturnCode == 0
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		WFSolicPortal(OPERATION_INSERT, Self:Request:Code, Nil, Self:Request:Branch)
	Else
		Return .F.
	EndIf
Return .T.

Function fAddAcademicGrantRequest(oAcademicGranRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", 		oAcademicGranRequest:Branch)
	Local aRegs	:={	{"RI1_FILIAL",		oAcademicGranRequest:Branch},;
						{"RI1_MAT",  			oAcademicGranRequest:Registration},;
						{"TMP_NOME",  		oAcademicGranRequest:Name},;
						{"RI1_TABELA",  		oAcademicGranRequest:benefitCode +  " - " + oAcademicGranRequest:descBenefitCode},;		//Cod Benef + Desc
						{"TMP_NMCURS",  		oAcademicGranRequest:curseName},;			//Nome do curso
						{"TMP_NMINST",  		oAcademicGranRequest:instituteName},;		//Nome da instituição
						{"TMP_CONTAT",  		oAcademicGranRequest:contact},;				//Nome do contato
						{"TMP_TELEFO",  		oAcademicGranRequest:phone},;				//Telefone do contato
						{"RI1_DINIPG",		oAcademicGranRequest:startDate},;			//Data Inicial Pgto
						{"RI1_DFIMPG",		oAcademicGranRequest:endDate},;				//Data Final Pgto
						{"TMP_VLRMEN",  		oAcademicGranRequest:monthlyPayment},;		//Valor mensal
						{"TMP_QTDEPA",  		oAcademicGranRequest:installmentAmount}}	//Quantidade de parcelas

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				Reclock("RH4", .T.)
				RH4->RH4_FILIAL	:= cFilRH4
				RH4->RH4_CODIGO	:= cRequestCode
				RH4->RH4_ITEM		:= ++nItem
				RH4->RH4_CAMPO	:= aRegs[nCount, 1]
				RH4->RH4_VALNOV	:= aRegs[nCount, 2]
				RH4->(MsUnlock())
			EndIf
		Next
	EndIf

Return nReturnCode

WSMETHOD AddAttendControlRequest	WSRECEIVE Request, AttendControlRequest WSSEND WsNull WSSERVICE RHRequest

		// --------------------------------------------------------------------
	// - Regra de negócio encapsulada para FUNCTION.
	// - E desta forma poderá ser utilizada tanto pelo Portal Protheus,
	// - Quanto pelo novo RH - RestFull.
	// --------------------------------------------------------------------
	AddAttendControlRequest(Self:Request, Self:AttendControlRequest, Self:IDMENU)

Return .T.

WSMETHOD DelAttendControlRequest	WSRECEIVE Request, AttendControlRequest WSSEND WsNull WSSERVICE RHRequest
	Local nReturnCode
	Local aArea		:= GetArea()
	Local cRequest	:= Self:AttendControlRequest:codeRequest
	Local lRet		:= .T.

	RestArea(aArea)

	Self:Request := fGetRequest(Self:Request:Branch, cRequest)

	DbSelectArea("RH3")
	DbSetOrder(1)
	If DbSeek(Self:Request:Branch + Self:Request:Code)
		If RH3->RH3_STATUS <> '2'
			Begin Transaction
				RecLock("RH3",.F.)
				RH3->(dbDelete())
				RH3->(MsUnlock())

				DbSelectArea("RH4")
				DbSetOrder(1)
				If DbSeek(Self:Request:Branch + Self:Request:Code)
					While RH4->(!Eof() .and. RH4_FILIAL + RH4_CODIGO == Self:Request:Branch + Self:Request:Code )
						RecLock("RH4",.F.)
						RH4->(DbDelete())
						RH4->(MsUnLock())
						RH4->(DbSkip())
					EndDo
				EndIf

				DbSelectArea("RS3")
				DbSetOrder(1)
				If DbSeek(Self:Request:Branch + Self:Request:Code)
					RecLock("RS3",.F.)
					RS3->(DbDelete())
					RS3->(MsUnLock())
					RS3->(DbSkip())
				EndIf
			End Transaction
		Else
			SetSoapFault("DelAttendControlRequest", STR0036) //"Solicitação já foi aprovada. Não poderá ser excluída."
			lRet := .F.
		EndIf
	EndIf

Return lRet


Function AddAttendControlRequest(oRequest, oAttendControlRequest, lRest, cMsgReturn, cIDMENU)

	Local nReturnCode
	Local nSaveSX8 	:= GetSX8Len()
	Local aArea		:= GetArea()
	Local cRequest	:= oAttendControlRequest:codeRequest
	Local nOperation:= OPERATION_INSERT

	Default cIDMENU	   := ""
	Default lRest 	   := .F.
	Default cMsgReturn := ""

	RestArea(aArea)

	If Empty(cRequest)

		If !fValidMarc(oRequest:StarterBranch,oRequest:StarterRegistration,oAttendControlRequest:Date)
			If !lRest
				SetSoapFault("AddAttendControlRequest", STR0037) //"Existem afastamentos registrados no sistema nesta data. Solicitação não foi incluída."
			Else
				cMsgReturn := EncodeUTF8(STR0037)
			EndIf
			Return .F.
		EndIf

		oRequest:RequestType		:= WSClassNew("TRequestType")
		oRequest:Status				:= WSClassNew("TRequestStatus")

		oRequest:Code            	:= GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
		oRequest:RequestType:Code	:= "Z"	//Marcação de Ponto
		oRequest:Status:Code		:= "1"
		oRequest:RequestDate      	:= dDataBase
		oRequest:StarterKey	      	:= fBuscaChaveFuncionario(	oRequest:Branch,;
											      				    oRequest:Registration,;
													    		    oRequest:Vision)

		If Empty(oRequest:ApproverRegistration)
			oRequest:StarterLevel			:= 0
			oRequest:Status:Code			:= "4"
			oRequest:ResponseDate 			:= dDataBase
		Else
			oRequest:StarterLevel			:= oRequest:ApproverLevel+1
			oRequest:Status:Code			:= "1"
			oRequest:ResponseDate 	   		:= CTod("")
		EndIf
	Else
		nOperation := OPERATION_UPDATE
		oRequest := fGetRequest(oRequest:Branch, cRequest)
	EndIf

	Begin Transaction
		If nOperation == OPERATION_INSERT
			nReturnCode:= fPutRequest(oRequest, OPERATION_INSERT, cIDMENU)
			If nReturnCode > 0
				If !lRest
					SetSoapFault("AddAttendControlRequest", STR0003)
				Else
					cMsgReturn := EncodeUTF8(STR0003)
				EndIf
				Break
			EndIf
		EndIf

		nReturnCode:= fAddAttendControlRequest(oAttendControlRequest, oRequest:Code, nOperation)
		If nReturnCode > 0
			If !lRest
				SetSoapFault("AddAttendControlRequest", STR0003)
			Else
				cMsgReturn := EncodeUTF8(STR0003)
			EndIf
			Break
		EndIf

		nReturnCode:= fPutHistory(oRequest, OPERATION_INSERT)
		If nReturnCode > 0
			If !lRest
				SetSoapFault("AddAttendControlRequest", STR0003)
			Else
				cMsgReturn := EncodeUTF8(STR0003)
			EndIf
			Break
		EndIf

	End Transaction

	If nReturnCode == 0
		//Grava a solicitação na tabela auxiliar
		DbSelectArea("RS3")
		DbSetOrder(1)
		If nOperation == OPERATION_INSERT
			RecLock("RS3",.T.)
			RS3_FILIAL	:= oAttendControlRequest:Branch
			RS3_CODIGO	:= oRequest:Code
			RS3_MAT		:= oAttendControlRequest:Registration
			RS3_DATA	:= CtoD(oAttendControlRequest:Date)
			RS3_HORA	:= Val(StrTran(oAttendControlRequest:Hour,":","."))
			RS3_JUSTIF	:= oAttendControlRequest:Observation
			RS3_STATUS	:= "0"
            If !Empty(oAttendControlRequest:Latitude)
                RS3_LATITU	:= oAttendControlRequest:Latitude
                RS3_LONGIT	:= oAttendControlRequest:Longitude
            EndIf
			MsUnLock()
		Else //Altera apenas hora e/ou justificativa
			If DbSeek(oAttendControlRequest:Branch + oRequest:Code + oAttendControlRequest:Registration)
				RecLock("RS3",.F.)
				RS3_HORA	:= Val(StrTran(oAttendControlRequest:Hour,":","."))
				RS3_JUSTIF	:= oAttendControlRequest:Observation
				RS3_STATUS	:= "0"
				MsUnLock()
			EndIf
		EndIf

		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		EndDo
		WFSolicPortal(OPERATION_INSERT, oRequest:Code, Nil, oRequest:Branch)
	Else
		Return .F.
	EndIf
Return .T.


Function fAddAttendControlRequest(oAttendControlRequest, cRequestCode, nOperation)
	Local nReturnCode := 0
	Local nCount
	Local nItem:= 0
	Local cFilRH4	:= xFilial("RH4", 		oAttendControlRequest:Branch)
	Local aRegs		:={	{"P8_FILIAL",		oAttendControlRequest:Branch},;
						{"P8_MAT",  		oAttendControlRequest:Registration},;
						{"TMP_NOME",  		oAttendControlRequest:Name},;
						{"P8_DATA",  		oAttendControlRequest:Date},;			//-- Data da Marcação
						{"P8_HORA",  		oAttendControlRequest:Hour},;			//-- Hora da Marcação
						{"P8_MOTIVRG", 		oAttendControlRequest:Observation},;    //-- Motivo
						{"P8_LATITU", 		oAttendControlRequest:Latitude},;       //-- Latitude
						{"P8_LONGIT", 		oAttendControlRequest:Longitude},;      //-- Longitude
						{"TMP_TEXT", 		oAttendControlRequest:Motive}}    		//-- Motivo (texto digitado pelo usuario)

	DBSelectArea("RH4")

	If nOperation == OPERATION_INSERT .or. nOperation == OPERATION_UPDATE
		For nCount:= 1 To Len(aRegs)
			If !Empty(aRegs[nCount, 2])
				If nOperation == OPERATION_INSERT
                    lRec := .T.
				Else
					If RH4->(DbSeek(cFilRH4+cRequestCode+AllTrim(STR(nItem+1))))
                        lRec := .F.
                    Else
                        lRec := .T.
                    EndIf
				EndIf
                
                RecLock( "RH4", lRec )
                RH4->RH4_FILIAL	:= cFilRH4
                RH4->RH4_CODIGO	:= cRequestCode
                RH4->RH4_ITEM	:= ++nItem
                RH4->RH4_CAMPO	:= aRegs[nCount, 1]
                RH4->RH4_VALNOV	:= aRegs[nCount, 2]
                RH4->(MsUnlock())
			EndIf
		Next
	EndIf

Return nReturnCode

WSMETHOD RequestTraining	 WSRECEIVE Request, TrainingReservationRequest WSSEND WsNull WSSERVICE RHRequest
Local lRet		:= .T.
BEGIN TRANSACTION
	dbSelectArea("RA3")

	RecLock("RA3",.T.)
	RA3->RA3_FILIAL := TrainingReservationRequest:Branch
	RA3->RA3_MAT    := TrainingReservationRequest:Registration
	RA3->RA3_CURSO  := TrainingReservationRequest:CourseCode
	RA3->RA3_RESERV := "S"
	RA3->RA3_DATA   := dDataBase
	RA3->RA3_MEMINT := Request:Observation
	RA3->RA3_PORTAL := If(Request:StarterRegistration <> Request:Registration, "G","F") //Se quem esta incluindo a solicitação não é o próprio funcionário, indica que foi solicitado pelo gestor.

	//ApdMsMm(RA3->RA3_CODMEM,,,TrainingReservationRequest:Branch+TrainingReservationRequest:Registration+TrainingReservationRequest:CourseCode	,1,,,"RA#","RA3_CODMEM")

	RA3->(MsUnlock())
	RA3->(FkCommit())
END TRANSACTION

Return lRet

WSMETHOD ValidRequestTraining	 WSRECEIVE TrainingReservationRequest WSSEND HasRequest WSSERVICE RHRequest
Local lRet		:= .T.
Self:HasRequest:= .T.

dbSelectArea("RA3")
RA3->(dbSetOrder(1))

If RA3->(dbSeek(TrainingReservationRequest:Branch+TrainingReservationRequest:Registration+TrainingReservationRequest:CourseCode))
	While ! RA3->(Eof()) .AND. RA3->RA3_FILIAL+RA3->RA3_MAT+RA3->RA3_CURSO == TrainingReservationRequest:Branch+TrainingReservationRequest:Registration+TrainingReservationRequest:CourseCode
		If Empty(RA3->RA3_TURMA) .AND. Empty(RA3->RA3_CALEND)
			Self:HasRequest:= .F.
		EndIf
		RA3->(dbSkip())
	Enddo
EndIf

Return lRet

WSMETHOD DelRequestTraining	 WSRECEIVE TrainingReservationRequest WSSEND HasRequest WSSERVICE RHRequest
Local lRet		:= .T.
Self:HasRequest:= .F.

DbSelectArea("RA3")
RA3->( DbSetOrder(1) )

If RA3->(DbSeek(TrainingReservationRequest:Branch+TrainingReservationRequest:Registration+TrainingReservationRequest:CourseCode))
	While ! RA3->(Eof()) .AND. RA3->RA3_FILIAL+RA3->RA3_MAT+RA3->RA3_CURSO == TrainingReservationRequest:Branch+TrainingReservationRequest:Registration+TrainingReservationRequest:CourseCode
		If Empty(RA3->RA3_TURMA) .AND. Empty(RA3->RA3_CALEND)
			RecLock("RA3",.F.)
				RA3->(dbDelete())
			RA3->(MsUnlock())
			Self:HasRequest:= .T.
		EndIf
		RA3->(dbSkip())
	Enddo
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} fFluig()
Inicia um processo no Fluig
@author Flavio S. Correa
@since 07/08/2014
@version 1.0
/*/
//-------------------------------------------------------------------

Function fFluig(oRequest,nOperation,cProcess)
Local aSuperior		:= {}
Local cUserApr		:= "000000"
Local nFluig		:= 0
Local aRet			:= {}
Local aApr			:= {}
Local nI			:= 1
Local lFluig		:= FWHasBPM() //função que diz se cliente tem FLUIG configurado

If nOperation == 1 .And. lFluig
//ENVIA INFORMACOES DE APROVACAO PARA O FLUIG
//SOMENTE SE FOR INCLUSAO E TIVER APROVACAO, SE O NIVEL FOR 99 SIGNIFICA
//QUE VAI DIRETO PARA O RH EFETIVAR, SENDO ASSIM NAO PRECISA DE WF APROVACAO
	If oRequest:ApproverLevel <> 99

		//busca superiores dessa solicitacao - aguardando liberação do Fluig para implementar essa melhoria
		fAllSuperior(oRequest:Vision,oRequest:StarterBranch,oRequest:StarterRegistration,@aSuperior)
	    For nI := 1 To Len(aSuperior)
	    	aadd(aAPr,fUserFluig(aSuperior[nI][1][1],aSuperior[nI][1][2]))
		Next nI

	    //Busca usuario protheus do solicitante para enviar ao FLUIG
	    cUserIni := fUserFluig(oRequest:StarterBranch,oRequest:StarterRegistration)

		//Busca usuario protheus do aprovador para enviar ao FLUIG
	    //cUserApr := fUserFluig(oRequest:ApproverBranch,oRequest:ApproverRegistration)

         /* Parametros Start Process
		@paramcProcessCódigodoprocesso
		@paramcUserusuáriosolicitante
		@paramaUserListListadeusuáriosresponsáveis({'admin'})
		@paramnTaksCódigodaatividadeinicial
		@paramlMessageExibemensagensdeAviso
		@paramlCompleteCompletaaTarefaaomudaraatividade

		@returnaRet[1]CódigodaSolicitação
		@returnaRet[2]Identificadordoformuláriodaquelasolicitação
		@returnaRet[3]mensagem de erro
		*/
		RH3->(DBSeek(oRequest:Branch + oRequest:Code) )
		If !Empty(cUserApr)
			//aRet := StartProcess(cProcess,cUserApr,,,.F.) // start process direto
		 	aRet := StartProcess(cProcess,cUserIni,aAPr,,.F.,.T.)//start process com concenso

			If Len(aRet) > 1
				nFluig := aRet[1]
			EndIf

			If nFluig > 0
				If RH3->(DBSeek(oRequest:Branch + oRequest:Code) )
					Reclock("RH3", .F.)
					RH3->RH3_FLUIG := nFluig
					RH3->(msUnlock())
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} fUserFluig()
Função que retorna o usuario Fluig a partir da Filial+Matricula do Funcionario
@author Flavio S. Correa
@since 07/08/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Function fUserFluig(cFil,cMat)
Local cUserIni := "000000"

IF EntExisteRel( "SRA" , cFil+cMat , cEmpAnt ,cFil , .T. )
	dbSelectArea("AI3")
	AI3->(dbSetOrder(1))
	If AI3->(dbSeek(cFil+RD0->RD0_PORTAL))
		cUserIni :=  AI3->AI3_USRSIS
	EndIf
EndIF
//retorna id do Fluig a partir do usuario protheus
cUserIni := FWWFColleagueId(cUserIni)
If Empty(cUserIni)
	cUserIni := FWWFColleagueId("000000")
EndIf
Return cUserIni

//-------------------------------------------------------------------
/*/{Protheus.doc} fValidMarc()
Função que retorna se existem afastamentos na data solicitada
@author Leandro Drumond
@since 26/02/2015
@version 1.0
/*/
Static Function fValidMarc(cFil,cMat,cData)
Local aArea			:= GetArea()
Local lRet 			:= .T.
Local cAliasQuery 	:= GetNextAlias()
Local dData			:= CtoD(cData)

BEGINSQL ALIAS cAliasQuery
	SELECT COUNT(*) QTDAFAST
	FROM %table:SR8% SR8
	WHERE R8_FILIAL = %exp:cFil% AND
	R8_MAT = %exp:cMat% AND (
	( R8_DATAINI <= %exp:DtoS(dData)% AND R8_DATAFIM >= %exp:DtoS(dData)% ) OR
	( R8_DATAINI <= %exp:DtoS(dData)% AND R8_DATAFIM = %exp:DtoS(CtoD(''))% )
	) AND
	SR8.%notDel%
ENDSQL

If (cAliasQuery)->(QTDAFAST) > 0
	lRet := .F.
EndIf

(cAliasQuery)->(DbCloseArea())

RestArea(aArea)

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fPosAI8³ Autor ³Renan Borges       ³ Data ³10/11/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua o posicionamento na tabela AI8.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Portal                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function fPosAI8(oRequest)
	Local aArea := GetArea()
	Local cPortal := "000006"
	dbSelectArea("AI8")
	dbSetOrder(4)

	If (RH3->RH3_TIPO == "B") 	// Ferias
		DbSeek(xFilial("AI8") + cPortal + "W_PWSA100A.APW")
	ElseIf (RH3->RH3_TIPO == "A") 	// Treinamento
		DbSeek(xFilial("AI8") + cPortal + "W_PWSA220.APW") 		//Retorno HttpSession->aInfRotina
	ElseIf (RH3->RH3_TIPO == "B") 	// Ferias
		DbSeek(xFilial("AI8") + cPortal + "W_PWSA100A.APW") 		//Retorno HttpSession->aInfRotina
	ElseIf (RH3->RH3_TIPO == "4") 	// Transferencia
		DbSeek(xFilial("AI8") + cPortal + "W_PWSA140.APW") 		//Retorno HttpSession->aInfRotina
	ElseIf (RH3->RH3_TIPO == "6") 	// Desligamento
		DbSeek(xFilial("AI8") + cPortal + "W_PWSA130.APW") 		//Retorno HttpSession->aInfRotina
	ElseIf (RH3->RH3_TIPO == "7") 	// Acao Salarial
		DbSeek(xFilial("AI8") + cPortal + "W_PWSA120.APW") 		//Retorno HttpSession->aInfRotina)
	ElseIf (RH3->RH3_TIPO == "8") 	// Justificativa
		DbSeek(xFilial("AI8") + cPortal + "W_PWSA160.APW") 		//Retorno HttpSession->aInfRotina
	ElseIf (RH3->RH3_TIPO == "N")   // Gestao Publica - Alteracao de Jornada
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA510.APW")      //Retorno HttpSession->aInfRotina
   ElseIf (RH3->RH3_TIPO == "O")   // Gestao Publica - Saldo de Ferias
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA520.APW")      //Retorno HttpSession->aInfRotina
   ElseIf (RH3->RH3_TIPO == "P")   // Gestao Publica - Programacao de Ferias
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA530.APW")      //Retorno HttpSession->aInfRotina
   ElseIf	(RH3->RH3_TIPO == "Q")   // Gestao Publica - Diaria
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA540.APW")      //Retorno HttpSession->aInfRotina
   ElseIf (RH3->RH3_TIPO == "R")   // Gestao Publica - Licenca e Afastamento
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA550.APW")      //Retorno HttpSession->aInfRotina
   ElseIf (RH3->RH3_TIPO == "S")   // Gestao Publica - Certidao Funcional
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA560.APW")      //Retorno HttpSession->aInfRotina
   ElseIf (RH3->RH3_TIPO == "T")   // Gestao Publica - Saldos de Dias de Folga
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA570.APW")      //Retorno HttpSession->aInfRotina
   ElseIf (RH3->RH3_TIPO == "Z")   // Espelho de Ponto
       DbSeek(xFilial("AI8") + cPortal + "W_PWSA400.APW")      //Retorno HttpSession->aInfRotina
   EndIf

	RestArea(aArea)
Return

Function fGetNmFunc(cFilApr, cMatApr, cVisao, cTree, cCodEmp)
Local cName 		:= ""
Local aArea1 		:= GetArea()
Local cAliasQry	:= GetNextAlias()
Local cSra			:= ""

If !Empty(cCodEmp)
	cSra	:= "%SRA"+cCodEmp+"0%"
Else
	dbselectarea("RD4")
	RD4->(dbsetorder(1))
	If RD4->(dbseek(xFilial("RD4")+cVisao+cTree))
		cSra	:= "%SRA"+RD4->RD4_EMPIDE+"0%"
	EndIf
EndIf


BeginSQL alias cAliasQry
	SELECT SRA.RA_NOME
	FROM %Exp:cSra% SRA
	WHERE SRA.RA_FILIAL = %exp:cFilApr% AND
	      SRA.RA_MAT = %exp:cMatApr% AND
	      SRA.%notDel%
EndSQL

If !(cAliasQry)->( Eof() )
	cName    :=(cAliasQry)->RA_NOME
EndIf
(cAliasQry)->(dbCloseArea())
RestArea(aArea1)
Return cName

WSMETHOD RetChaveFuncionario WSRECEIVE EnrolmentID,ParticipantId  WSSEND ChaveFunc WSSERVICE RHRequest
Local lRet	    := .T.
Local cCodMat	:= ""
Local cCodFil	:= ""
Local aRet		:= {}

::ChaveFunc := ""

If Participant(Self:ParticipantId,aRet,,Self:EnrolmentID)
	cCodMat:= aRet[1]
	cCodFil:= aRet[3]
	::ChaveFunc := fBuscaChaveFuncionario(cCodFil, cCodMat, '')
EndIf


Return lRet
