#INCLUDE "WSAPD010.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³WSAPD010  ³ Autor ³Aline Correa do Vale        ³ Data ³19.02.2004  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelas avaliacoes de desempenho            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ Requisito ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Allyson M     ³30/10/15³TTPURR	  ³Ajuste para permitir login de funcionários³±± 
±±³              ³        ³      	  ³demitidos quando parametro MV_TCFVREN esti³±± 
±±³              ³        ³     	  ³ver habilitado.                           ³±±
±±³Matheus M.    ³26/10/16³TVWEVJ	  ³Ajuste para exibir o nome do avaliado de  ³±± 
±±³              ³        ³      	  ³forma correta na pesquisa de clima.		 ³±±
±±³Eduardo K.    ³05/01/18³MPRIMESP   ³Ajuste para não exibir avaliação com o    ³±± 
±±³              ³        ³13145   	  ³status “Fechado”.		            	 ³±±
±±³Eduardo K.    ³23/01/18³MPRIMESP   ³Ajuste para exibir a resposta selecionada ³±± 
±±³              ³        ³13409   	  ³corretamente ao responder a questão nova- ³±±
±±³              ³        ³      	  ³mente.									 ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Avaliacao de desempenho (Performance Evaluate)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Competences
	WSDATA CompetenceItem						AS String						//Item de Competencia
	WSDATA CompetenceItemDescription			AS String OPTIONAL				//Descricao do Item Competencia
	WSDATA DescCompetenceItem					AS String OPTIONAL				//Explicacao do Item Competencia
	WSDATA Value								AS String OPTIONAL				//Relevancia da Competencia
	WSDATA ValueItem							AS String OPTIONAL				//Item de Relevancia da Competencia
	WSDATA ValueItemDescription					AS String OPTIONAL				//Descricao do Item de Relevancia da Competencia
	WSDATA ListOfQuestion						AS Array Of Questions OPTIONAL	//Questoes da avaliacao
	WSDATA TemResposta							AS Boolean OPTIONAL				//Tem respostas?
ENDWSSTRUCT

WSSTRUCT Questions
	WSDATA QuestionID							As String							//Codigo Questao
	WSDATA Question								As String OPTIONAL					//Enunciado da Questao
	WSDATA DescQuestion							AS String OPTIONAL					//Explicacao da questao
	WSDATA ListOfAlternative					As Array Of Alternatives OPTIONAL	//Alternativas
	WSDATA Points								As Float OPTIONAL					//Pontos da questao
	WSDATA ObjectType 							As String							//Tipo de Objeto
	// 1=Multipla Escolha, 2=Unica Escolha, 3=Dissertativa, 4=Pontuacao
	WSDATA Scale								AS String 							//Relevancia da questao
	WSDATA ScaleItem							AS String OPTIONAL					//Item de relevancia
	WSDATA ScaleItemDescription					AS String OPTIONAL					//Descricao do Item de relevancia
	WSDATA AnswerDescription					AS String OPTIONAL					//Resposta dissertativa
	WSDATA AlternativeChoice					As Array Of Respostas OPTIONAL		//Alternativa Escolhida
	WSDATA SelfAnswer							AS String OPTIONAL					//Resposta do Avaliador
	WSDATA SelfChoice							As Array Of Respostas OPTIONAL		//Alternativa Escolhida pelo Avaliador
	WSDATA EvaluatorAnswer						AS String OPTIONAL					//Resposta do Avaliador
	WSDATA EvaluatorChoice						As Array Of Respostas OPTIONAL		//Alternativa Escolhida pelo Avaliador
	WSDATA Edit									As String OPTIONAL					//Permissao de Edicao 1=AutoAvaliador 2=Avaliador 3=Ambos
	WSDATA RelevanceList						As Array Of Alternatives OPTIONAL	//Itens de Escala de Relevancia da questao	
	WSDATA justification						As String OPTIONAL					//Justificativa da questao
ENDWSSTRUCT

WSSTRUCT Alternatives
	WSDATA AlternativeID   						As String			//Numero da alternativa
	WSDATA Alternative							As String OPTIONAL	//Alternativa (descritivo)
	WSDATA Percentage							As Float  			//Percentual equivalente a alternativa
	WSDATA InfCombo								As String  			//Informacoes que alimentarao o combo, conforme parametro (MV_APDINCB)
ENDWSSTRUCT

WSSTRUCT Respostas
	WSDATA Alternativa							As String			//
ENDWSSTRUCT

WSSTRUCT Projects
	WSDATA ProjectID   							As String			//Codigo do projeto
	WSDATA ProjectDescription					As String OPTIONAL	//Descricao do projeto
	WSDATA DateFrom       						AS Date   OPTIONAL 	//Data inicial
	WSDATA DateTo   	  						AS Date   OPTIONAL 	//Data Final
	WSDATA MemoCode								As String OPTIONAL	//Codigo Memo (Obs)
	WSDATA ClientID								As String OPTIONAL	//Codigo do Cliente
	WSDATA PmsCode								As String OPTIONAL	//Codigo do Projeto PMS
	WSDATA ClientDescription					As String OPTIONAL	//Descricao do Cliente
ENDWSSTRUCT

WSSTRUCT Evaluators
	WSDATA EvaluatorID	 						As String			//Codigo do projeto
	WSDATA EvaluatorName						As String OPTIONAL	//Descricao do projeto
ENDWSSTRUCT

WSSTRUCT Periods
	WSDATA PeriodID		 						As String			//Codigo do periodo
	WSDATA PeriodDescription					As String OPTIONAL	//Descricao do projeto
	WSDATA DateFrom								As Date   OPTIONAL	//Data inicial do periodo
	WSDATA DateTo								As Date   OPTIONAL	//Data final do periodo
ENDWSSTRUCT

WSSTRUCT Objectives
	WSDATA EvaluatedId              As String OPTIONAL  				//Codigo do Avaliado
	WSDATA EvaluatedName            As String OPTIONAL  				//Nome do Avaliado
	WSDATA EvaluatorId              As String OPTIONAL  				//Codigo do Avaliador
	WSDATA EvaluatorName            As String OPTIONAL  				//Nome do Avaliador
	WSDATA ObjectiveID	 			As String							//Codigo do tipo de objetivo
	WSDATA Item         			As String OPTIONAL					//Item do tipo de objetivo
	WSDATA ItemDate     			As Date   OPTIONAL					//Data de inclusao do item
	WSDATA ObjectiveDescription		As String OPTIONAL					//Descricao do objetivo
	WSDATA ObjectiveDetail			As String OPTIONAL					//Detalhamento do objetivo
	WSDATA PeriodList				As Array of Periods OPTIONAL		//Array dos periodos cadastrados
	WSDATA Period					As String OPTIONAL					//Codigo do periodo
	WSDATA PeriodDescription		As String OPTIONAL					//Descricao do periodo
	WSDATA InitialDate				As Date   OPTIONAL					//Data inicial
	WSDATA FinalDate				As Date   OPTIONAL					//Data final
	WSDATA Relevance				As String OPTIONAL					//Escala de Relevancia
	WSDATA RelevanceItem			As String OPTIONAL					//Item da escala de relevancia
	WSDATA RelevanceDescription		As String OPTIONAL					//Descricao do Item da escala de relevancia
	WSDATA RelevanceList			As Array of Alternatives OPTIONAL 	//Array da escala dos itens de relevancia
	WSDATA AchieveScale				As String OPTIONAL					//Escala de Atingimento
	WSDATA AchieveScaleItem			As String OPTIONAL					//Item da escala de atingimento
	WSDATA AchieveScaleDescription	As String OPTIONAL					//Descricao do Item da escala de atingimento
	WSDATA AchieveList				As Array of Alternatives OPTIONAL 	//Array da escala dos itens de atingimento
	WSDATA SenseScaleItem			As String OPTIONAL					//It.da escala de atingimento consenso
	WSDATA SenseScaleDescription	As String OPTIONAL					//Descricao do Item da escala de atingimento
	WSDATA KnowledgeScale			As String OPTIONAL					//Escala de conhecimento
	WSDATA KnowledgeScaleDescription As String OPTIONAL					//Escala de conhecimento
	WSDATA KnowledgeList			As Array of Alternatives OPTIONAL 	//Array da escala dos itens de conhecimento
	WSDATA ActualItem				As String OPTIONAL					//Item atual da Escala de conhecimento
	WSDATA ActualItemDescription	As String OPTIONAL					//Item atual da Escala de conhecimento
	WSDATA ProposeItem				As String OPTIONAL					//Item pretendido da Escala de conhecimento
	WSDATA ProposeItemDescription	As String OPTIONAL					//Item pretendido da Escala de conhecimento
	WSDATA Observation				As String OPTIONAL					//Observacoes
	WSDATA Status					As String OPTIONAL					//Status
	WSDATA StatusNew				As String OPTIONAL					//Novo Status - Aprovado
	WSDATA StatusDescription		As String OPTIONAL					//Descricao do Status
	WSDATA Alterar					As String OPTIONAL					//Define se está alterando ou inserindo o registro na tabela. True alterando, False inserindo
	WSDATA Revisao					As String OPTIONAL					//Define se o item e revisao para o avaliador, ou meta comum acessivel para o usuario
	WSDATA EvalChoice				As String OPTIONAL					//Identifica se a alteracao do status foi enviada pelo avaliador
	WSDATA SeqItem					As String OPTIONAL					//Identifica o codigo de sequencia do item
	WSDATA StatusMeta				As String OPTIONAL					//Identifica se a meta esta liberada para o avaliador
ENDWSSTRUCT

WSSTRUCT EvaluateList
	WSDATA EvaluateId                As String           //Codigo do Modelo da Avaliacao
	WSDATA EvaluatedId               As String OPTIONAL  //Codigo do Avaliado
	WSDATA EvaluatedName             As String OPTIONAL  //Nome do Avaliado
	WSDATA EvaluatorId               As String OPTIONAL  //Codigo do Avaliador
	WSDATA EvaluatorName             As String OPTIONAL  //Nome do Avaliador
	WSDATA OtherEvaluatorName        As String OPTIONAL  //Nome do Avaliador das outras avaliacoes
	WSDATA InitialDate               As Date             //Data de Inicio da avaliacao
	WSDATA FinalDate                 As Date             //Data Final para a avaliacao
	WSDATA AnswerInitialDate         As Date   OPTIONAL  //Data de Inicio para responder
	WSDATA AnswerFinalDate           As Date   OPTIONAL  //Data Final para responder
	WSDATA Description               As String OPTIONAL  //Descricao
	WSDATA Project                   As String OPTIONAL  //Codigo do projeto
	WSDATA ProjectDescription        As String OPTIONAL  //Descricao do projeto
	WSDATA Net                       As String OPTIONAL  //Rede
	WSDATA NetDescription            As String OPTIONAL  //Descricao da Rede
	WSDATA EvaluateType              As String OPTIONAL  //Tipo de avaliacao
	WSDATA TypeDescription           As String OPTIONAL  //Descricao do Tipo de avaliacao
	WSDATA Vision                    As String OPTIONAL  //Visao
	WSDATA VisionDescription         As String OPTIONAL  //Descricao da Visao
	WSDATA Level                     As String OPTIONAL  //Nivel
	WSDATA Model                     As String OPTIONAL  //Modelo
	WSDATA ModelDescription          As String OPTIONAL  //Descricao do Modelo
	WSDATA Competence                As String OPTIONAL  //Competencia
	WSDATA CompetenceDescription     As String OPTIONAL  //Descricao da Competencia
	WSDATA EvaluateStatus            As String OPTIONAL  //Status 1=Aberto 2=Fechado
	WSDATA EvaluateStatusDescription As String OPTIONAL  //Status 1=Aberto 2=Fechado
	WSDATA SelfEvaluate              As String OPTIONAL  //AutoAvaliacao 1=Avaliador 2=Auto 3=Consenso
	WSDATA SelfEvaluateDescription   As String OPTIONAL  //AutoAvaliacao 1=Avaliador 2=Auto 3=Consenso
	WSDATA AutoEvaluated			 As String OPTIONAL  //Finalizada AutoAvaliacao Em branco = Nao finalizada / Preenchida = Finalizada
	WSDATA CostCenterDescription	 As String OPTIONAL  //Descrição do Centro de Custo
	WSDATA FunctionDescription		 As String OPTIONAL  //Descrição do Cargo
	WSDATA HierarqLevel				 As String OPTIONAL	 //Nivel Hierarquico (Classe salarial)
	WSDATA PartLeaderId				 As String OPTIONAL	 //Codigo do lider hierarquico.
	WSDATA PartLeader 	 			 As String OPTIONAL	 //Nome do lider hierarquico.
	WSDATA TypeEv		 	 		 As String OPTIONAL	 //Tipo de Avaliacao 1=Avaliacao 2=Pesquisa 3=Projeto
	WSDATA CoachName		 	 	 As String OPTIONAL	 //Nome do mentor
	WSDATA Reply			 	 	 As String OPTIONAL	 //Replicar Avaliacao

	WSDATA ListOfCompetence AS Array Of Competences OPTIONAL //Item de Competencia da Avaliacao
	WSDATA ListOfProject    AS Array Of Projects    OPTIONAL //Projetos disponiveis
	WSDATA ListOfEvaluator	AS Array Of Evaluators  OPTIONAL //Avaliadores da rede
ENDWSSTRUCT

WSSTRUCT EvaluatedEvaluate
	WSDATA EvaluateId                As String           //Codigo do Modelo da Avaliacao
	WSDATA EvaluateDescription		 As String OPTIONAL	 //Descricao da Avaliacao
	WSDATA EvaluatedId               As String           //Codigo do Avaliado
	WSDATA EvaluatedDescription		 As String OPTIONAL	 //Descricao do Avaliado
	WSDATA InitialDate               As Date             //Data de Inicio da avaliacao
	WSDATA FinalDate                 As Date             //Data Final para a avaliacao
	WSDATA Level                     As String OPTIONAL  //Nivel
	WSDATA Net                       As String           //Rede
	WSDATA SelfEvaluate 			 As String OPTIONAL  //1=Avaliador 2=Auto 3=Consenso
	WSDATA EvaluateType              As String OPTIONAL  //Tipo de avaliacao
ENDWSSTRUCT

WSSTRUCT Evaluates
	WSDATA EvaluateId                As String           		//Codigo do Modelo da Avaliacao
	WSDATA EvaluateDescription		 As String OPTIONAL	 		//Descricao da Avaliacao
	WSDATA EvaluatedId               As String           		//Codigo do Avaliado
	WSDATA EvaluatorId               As String OPTIONAL  		//Codigo do Avaliador
	WSDATA Project                   As String OPTIONAL  		//Codigo do projeto
	WSDATA InitialDate               As Date             		//Data de Inicio da avaliacao
	WSDATA FinalDate                 As Date             		//Data Final para a avaliacao
	WSDATA AnswerInitialDate         As Date   OPTIONAL  		//Data de Inicio para responder
	WSDATA AnswerFinalDate           As Date   OPTIONAL  		//Data Final para responder
	WSDATA Vision                    As String           		//Visao
	WSDATA Model                     As String           		//Modelo
	WSDATA Competence                As String           		//Competencia
	WSDATA EvaluateType              As String           		//Tipo de avaliacao
	WSDATA Level                     As String OPTIONAL  		//Nivel
	WSDATA Net                       As String           		//Rede
	WSDATA EvaluateStatus            As String OPTIONAL  		//1=Avaliador 2=Auto 3=Consenso
	WSDATA SelfEvaluate 			 As String OPTIONAL  		//1=Avaliador 2=Auto 3=Consenso
	WSDATA ListOfCompetence AS Array Of Competences OPTIONAL 	//Item de Competencia da Avaliacao
ENDWSSTRUCT

WSSTRUCT Participants
	WSDATA ParticipantID			As String			//Codigo do participante
	WSDATA ParticipantName			As String OPTIONAL	//Nome do participante
	WSDATA ParticipantCPF			As String OPTIONAL	//CPF do participante
	WSDATA ParticipantPass			As String OPTIONAL	//Senha do participante
	WSDATA ParticipantEmail			As String OPTIONAL	//Email do participante
	WSDATA ParticipantAdress		As String OPTIONAL	//Endrececo do participante
	WSDATA ParticipantCity			As String OPTIONAL	//Cidade do participante
ENDWSSTRUCT

WSSTRUCT EvaluateProject
	WSDATA ListOfEvaluate			AS Array Of EvaluateList
ENDWSSTRUCT

WSSTRUCT EvaluateGen
	WSDATA EvaluateId                As String           //Codigo do Modelo da Avaliacao
	WSDATA EvaluateDescription		 As String OPTIONAL	 //Descricao da Avaliacao
	WSDATA Status		             As String OPTIONAL  //Status da Avaliacao
	WSDATA EvaluateType              As String OPTIONAL  //Tipo de avaliacao
	WSDATA InitialDate               As Date OPTIONAL    //Data de Inicio da avaliacao
	WSDATA FinalDate                 As Date OPTIONAL    //Data Final para a avaliacao
	WSDATA Net     					 As String OPTIONAL	 //Codigo da Rede
	WSDATA Level					 As String OPTIONAL	 //Nivel da Rede
	WSDATA TypeEvaluate				 As String OPTIONAL	 //Codigo de Tipo de Avaliacao
ENDWSSTRUCT


WSSTRUCT ProjectPut
	WSDATA ListOfProject			AS Array Of Projects
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Controle do Usuario                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHPerformanceEvaluate DESCRIPTION STR0001		//"Avaliação de Desempenho ( <b>Restrição de participante</b> )"
	WSDATA Header                 AS Array OF BrwHeader
	WSDATA HeaderType             AS String
	WSDATA UserCode               AS String
	WSDATA ParticipantId          As String             //Codigo do Participante
	WSDATA PEvaluateID			  AS String   OPTIONAL
	WSDATA EvaluatorID			  AS String   OPTIONAL
	WSDATA EvaluatedID			  AS String   OPTIONAL
	WSDATA DateFrom               AS Date     OPTIONAL
	WSDATA DateTo                 AS Date     OPTIONAL
	WSDATA ListOfEvaluate		  AS Array Of EvaluateList

	
	WSDATA ProjectEvaluate        As EvaluateProject 				//AVALIACAO COM PROJETO INCLUSO
	WSDATA EvaluateEvaluated	  As Array Of EvaluatedEvaluate
	WSDATA QueryAddWhere          AS String OPTIONAL
	WSDATA IndexKey               AS String   OPTIONAL
	WSDATA PageLen                AS Integer  OPTIONAL
	WSDATA PageLoad               AS Integer  OPTIONAL
	WSDATA Questions              AS Boolean  OPTIONAL
	WSDATA Evaluate               AS Evaluates OPTIONAL 			//Item de Competencia da Avaliacao
	WSDATA ResultType             AS String OPTIONAL    			//Tipo 1=Avaliacao, 2=Pesquisa
	WSDATA ParticipantData        AS Participants OPTIONAL 			//Dados do Participante
	WSDATA ListOfObjective        AS Array Of Objectives OPTIONAL 	//Tipo de Objetivos
	WSDATA ObjectiveEnter         AS Objectives OPTIONAL 			//Tipo de Objetivos
	WSDATA ObjectiveType          AS String OPTIONAL  				//Tipo de Objetivo (1=Plano, 2=Meta)
	WSDATA WsNull                 AS String
	WSDATA StatusEvaluate		  AS String OPTIONAL 				//Status da Avaliação (1=Aberto, 2=Fechado)
	WSDATA NetLevel			  	  AS String OPTIONAL 				//Nivel do Avaliador em relacao ao avaliado (1=MESMO NIVEL, 2=NIVEL ACIMA, 3=NIVEL ABAIXO)
	WSDATA ListOfEvaluator		  AS Array OF Evaluators			//Lista de avaliadores que a consulta retorna no pop-up de avaliadores --- Rogerio
	WSDATA EvaluatorName		  AS String			 				//Nome ou parte do nome do avaliador, para consulta no pop-up de avaliadores --- Rogerio
	WSDATA ObjectiveID			  AS String			 				//Codigo do Objetivo para alterar o avaliador
	WSDATA PeriodID			  	  AS String			 				//Codigo do Periodo para alterar o avaliador
	WSDATA PortalAccess			  As String OPTIONAL 				//Tipo de acesso ao portal. 1=Acesso por e-mail; Qualquer outro, acesso por CPF.
	WSDATA ListOfProjects		  As Array Of Projects				//LISTA TODOS OS PROJETOS
	WSDATA ProjectDescription	  As String OPTIONAL 				//Descricao do projeto (Nome)
	WSDATA EvaluateType			  As String	OPTIONAL 				//tipo da pesquisa 1=identificada / 2 = nao identificada
	WSDATA Project				  As String OPTIONAL 				//Codigo do Projeto
	WSDATA ClientCode             As String OPTIONAL				//Codigo do Cliente
	WSDATA ClientUnit             As String OPTIONAL				//Loja do Cliente
	WSDATA EvaluatedMail		  As String OPTIONAL				//Email do avaliado   	
	WSDATA ExistFields            AS Boolean OPTIONAL				//Controla se os novos campos estão cadastrados no dicionários 
	
	WSDATA GenEvaluate			  As Array Of EvaluateGen 			//Pesquisa generica de Avaliacao
	WSDATA TypeEvaluate           As String OPTIONAL 				//Tipo de Avaliacao para Pesquisa
	WSDATA DescEvaluate           As String OPTIONAL 				//Descricao da Avaliacao para Pesquisa

	WSDATA PUTPROJECT 			  AS PROJECTPUT 	 				//Dados do Projeto
	WSDATA ProjectID 			  AS String OPTIONAL 				//Codigo do Novo Projeto
	WSDATA TypeEval 			  AS String OPTIONAL 				//Tipo de Avaliacao

	WSMETHOD GetHeader        DESCRIPTION STR0002 //"Método que descreve as estruturas de retorno do serviço"
	WSMETHOD BrwMyEvaluates   DESCRIPTION STR0003 //"Método de listagem de Minhas Avaliaçoes pendentes"
	WSMETHOD BrwMyEvaluated   DESCRIPTION STR0004 //"Método de listagem das Avaliaçoes pendentes de Meus Avaliados"
	WSMETHOD GetPEvaluate     DESCRIPTION STR0005 //"Método de consulta das informações da avaliacao de desempenho"
	WSMETHOD GetPEvaluator    DESCRIPTION STR0006 //"Método de consulta de avaliações pendentes para o avaliador com auto-avaliação respondida"
	WSMETHOD PutPEvaluate     DESCRIPTION STR0007 //"Método de inclusao de nova da avaliações por projeto"
	WSMETHOD SetConsensus     DESCRIPTION STR0008 //"Método de listagem das Avaliações com Consenso pendente"
	WSMETHOD BrwObjectives    DESCRIPTION STR0009 //"Método de listagem dos Tipo de Objetivos de avaliações quantitativas"
	WSMETHOD BrwMyObjectives  DESCRIPTION STR0010 //"Método de listagem da Metas / Objetivos / PDP do participante"
	WSMETHOD BrwTeamObjective DESCRIPTION STR0011 //"Método de listagem das Metas / Objetivos / PDP de Meus Avaliados"
	WSMETHOD SetObjective     DESCRIPTION STR0012 //"Inclui uma nova meta ou objetivo para o participante"
	WSMETHOD DelObjective     DESCRIPTION STR0013 //"Exclui uma meta ou objetivos do participante"
	WSMETHOD GetParticipant   DESCRIPTION STR0014 //"Retorna os dados do participante"
	WSMETHOD BrwEvaluator	  DESCRIPTION STR0015 //"Retorna a lista completa de participantes, para selecionar o avaliador"
	WSMETHOD SetEvaluator	  DESCRIPTION STR0016 //"Altera o avaliador do pariticipante"
	WSMETHOD SetStatus		  DESCRIPTION STR0017 //"Libera as metas para o avaliador"
	WSMETHOD BrwEvaluate	  DESCRIPTION STR0018 //"Consulta de todas as avaliacoes de um avaliado"
	WSMETHOD BrwProjects	  DESCRIPTION STR0019 //"Retorna todos os projetos"
	WSMETHOD PutEvaluate	  DESCRIPTION STR0020 //"Inclui um avaliador para um avaliado de uma avaliação já existente, incluindo um projeto"
	WSMETHOD EvaluateType	  DESCRIPTION STR0021 //"Consulta tipo de avaliacao da pesquisa. Pesquisa identificada ou nao."

	WSMETHOD BrwGenEvaluate	  DESCRIPTION STR0042 //"Lista generica de avaliacoes"
	WSMETHOD PutProjects	  DESCRIPTION STR0043 //"Inclusao de Projetos"
	WSMETHOD BrwPeriod	  	  DESCRIPTION STR0044 //"Lista de Periodos de Avaliacoes para o avaliado"	
ENDWSSERVICE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetHeader ³Autor  ³ Aline Correa do Vale  ³ Data ³25.02.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de recuperacao dos headers deste WS                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome da Estrutura                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve o header de uma estrutura                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ WEB SERVICES                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetHeader WSRECEIVE HeaderType WSSEND Header WSSERVICE RHPerformanceEvaluate

Local nX := 0

::Header := MtHeader(::HeaderType)
If Empty(::Header)
	Do Case
		Case ::HeaderType == "BRWMYEVALUATED"
			aadd(::Header,WSClassNew("BrwHeader"))
			nX++
			::Header[nX]:HeaderTitle := RetTitle("RD6_CODIGO")
			::Header[nX]:HeaderField := "ORDERID"
			::Header[nX]:HeaderPicture := SX3->X3_PICTURE
			::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
			::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
			::Header[nX]:HeaderType    := SX3->X3_TIPO
			::Header[nX]:HeaderComboBox:= X3CBox()
			::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)

			aadd(::Header,WSClassNew("BrwHeader"))
			nX++
			::Header[nX]:HeaderTitle := RetTitle("RD6_CODTIP")
			::Header[nX]:HeaderField := "TYPEID"
			::Header[nX]:HeaderPicture := SX3->X3_PICTURE
			::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
			::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
			::Header[nX]:HeaderType    := SX3->X3_TIPO
			::Header[nX]:HeaderComboBox:= X3CBox()
			::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)

			aadd(::Header,WSClassNew("BrwHeader"))
			nX++
			::Header[nX]:HeaderTitle := RetTitle("RDA_CODADO")
			::Header[nX]:HeaderField := "ORDERID"
			::Header[nX]:HeaderPicture := SX3->X3_PICTURE
			::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
			::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
			::Header[nX]:HeaderType    := SX3->X3_TIPO
			::Header[nX]:HeaderComboBox:= X3CBox()
			::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)
	Otherwise

		aadd(::Header,WSClassNew("BrwHeader"))
		nX++
		::Header[nX]:HeaderTitle := RetTitle("RD6_CODIGO")
		::Header[nX]:HeaderField := "ORDERID"
		::Header[nX]:HeaderPicture := SX3->X3_PICTURE
		::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
		::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
		::Header[nX]:HeaderType    := SX3->X3_TIPO
		::Header[nX]:HeaderComboBox:= X3CBox()
		::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)

	EndCase

	aadd(::Header,WSClassNew("BrwHeader"))
	nX++
	::Header[nX]:HeaderTitle := RetTitle("RD6_DTINI")
	::Header[nX]:HeaderField := "EVALUATEBEGIN"
	::Header[nX]:HeaderPicture := SX3->X3_PICTURE
	::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
	::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
	::Header[nX]:HeaderType    := SX3->X3_TIPO
	::Header[nX]:HeaderComboBox:= X3CBox()
	::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)

	aadd(::Header,WSClassNew("BrwHeader"))
	nX++
	::Header[nX]:HeaderTitle := RetTitle("RD6_DTFIM")
	::Header[nX]:HeaderField := "EVALUATEEND"
	::Header[nX]:HeaderPicture := SX3->X3_PICTURE
	::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
	::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
	::Header[nX]:HeaderType    := SX3->X3_TIPO
	::Header[nX]:HeaderComboBox:= X3CBox()
	::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)

	aadd(::Header,WSClassNew("BrwHeader"))
	nX++
	::Header[nX]:HeaderTitle := RetTitle("RD6_DESC")
	::Header[nX]:HeaderField := "EVALUATEDESCRIPTION"
	::Header[nX]:HeaderPicture := SX3->X3_PICTURE
	::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
	::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
	::Header[nX]:HeaderType    := SX3->X3_TIPO
	::Header[nX]:HeaderComboBox:= X3CBox()
	::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)

	aadd(::Header,WSClassNew("BrwHeader"))
	nX++
	::Header[nX]:HeaderTitle := RetTitle("RD6_CODVIS")
	::Header[nX]:HeaderField := "VISIONID"
	::Header[nX]:HeaderPicture := SX3->X3_PICTURE
	::Header[nX]:HeaderSize    := SX3->X3_TAMANHO
	::Header[nX]:HeaderDec     := SX3->X3_DECIMAL
	::Header[nX]:HeaderType    := SX3->X3_TIPO
	::Header[nX]:HeaderComboBox:= X3CBox()
	::Header[nX]:HeaderOblig   := X3OBRIGAT(SX3->X3_CAMPO)

EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetPEvaluate ³Autor  ³Aline Correa do Vale³Data  ³26.02.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo de recuperacao das avaliacoes de um participante      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Participante                                ³±±
±±³          ³ExpC3: Codigo da Avaliacao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao das avaliacoes de um participante      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetPEvaluate WSRECEIVE UserCode,ParticipantID,PEvaluateID,EvaluatorID, ResultType, QueryAddWhere,PageLen, PageLoad, Questions, DateFrom, Project WSSEND ListOfEvaluate WSSERVICE RHPerformanceEvaluate
Local aArea       	:= GetArea()
Local lRetorno    	:= .T.
Local lQuery      	:= .F.
Local nY          	:= 0
Local nZ          	:= 0
Local nx		  	:= 0
Local nPag        	:= 0
Local nRegs       	:= 1
Local cAliasRD6   	:= "RD6"
Local cParticipant	:= SubStr(::ParticipantID,1,Len(RD9->RD9_CODADO))
Local cEvaluator  	:= ""
Local cCodAvaliador	:= ""   
Local cEvaluateType	:= ""
Local cTipPesq		:= ""
Local cRecnoRda		:= ""
Local cEvaluateID 	:= SubStr(::PEvaluateID,1,Len(RD9->RD9_CODAVA))
Local cAvaliadores	:= ""
Local aAvaliadores	:= {}
Local aCarreira	  	:= {}
Local aLider 	  	:= {}
Local nAt         	:= 0
Local cWhile      	:= ""
Local cIteVis 		:= ""
Local cParamInfCb 	:= AllTrim(GetMV("MV_APDINCB"))
Local cConteudo 	:= ""
Local nPos 		 	:= 0
Local aAux          := {}
Local aParams       := {}
Local cCodCli		:= ""
Local cCodLoja		:= ""
Local cCodProj		:= ""
Local cQuestao		:= ""
Local lTemResp		:= .F.

DEFAULT ::PageLen   	:= 0
DEFAULT ::PageLoad  	:= 0
DEFAULT ::Questions 	:= .T.
DEFAULT ::EvaluatorID	:= ""
DEFAULT ::ResultType 	:= ""
DEFAULT ::Project		:= Space(Len(RDA->RDA_CODPRO))

cEvaluator := SubStr(::EvaluatorID,1,Len(RDA->RDA_CODDOR))

If Empty(::Project)
	::Project:= Criavar("RDA_CODPRO")
EndIf



If !Empty(cParticipant)
	dbSelectArea("RD6")
	(cAliasRD6)->( dbSetOrder(1) )
	If (cAliasRD6)->( dbSeek(xFilial("RD6")+cEvaluateID) )

		dbSelectArea("RD9")
		RD9->( dbSetOrder(1) )
		dbSeek(xFilial("RD6")+::PEvaluateID)
		RDB->(dbSetOrder(11))
		RD5->(dbSetOrder(1))
		RDK->(dbSetOrder(1))
		RD3->(dbSetOrder(1))
		RD2->(dbSetOrder(1))
		RDM->(dbSetOrder(1))
		RDO->(dbSetOrder(1))
		RD0->(dbSetOrder(1))
		RD7->(dbSetOrder(1))
		RD8->(dbSetOrder(2))
		SQP->(dbSetOrder(1))
		SQO->(dbSetOrder(1))
		RBL->(dbSetOrder(1))
		RDA->(dbSetOrder(8)) //RDA_FILIAL+RDA_CODDOR+RDA_CODADO+RDA_CODAVA+RDA_CODPRO+DTOS(RDA_DTIAVA)			
		RDC->(dbSetOrder(1))
		
		RD0->(dbSeek(xFilial("RD0")+cParticipant))
		RD5->(dbSeek(xFilial("RD5")+(cAliasRD6)->RD6_CODTIP))
		RDK->(dbSeek(xFilial("RDK")+(cAliasRD6)->RD6_CODVIS))
		RD3->(dbSeek(xFilial("RD3")+(cAliasRD6)->RD6_CODMOD))
		RDM->(dbSeek(xFilial("RDM")+(cAliasRD6)->RD6_CODCOM))      
					
		cEvaluateType := RD5->RD5_TIPO 		//Tipo de Avaliacao: 1 -Avaliacao, 2 - Pesquisa, 3 - Projeto 
		cTipPesq	  := RD5->RD5_IDENTI 	//'2' = Pesquisa nao identificada
		
		If Empty(cEvaluator)
			RDA->(dbSeek(xFilial("RDA")+cParticipant+cParticipant+(cAliasRD6)->RD6_CODIGO+::Project+DToS(::DateFrom)))
		Else
			RDA->(dbSeek(xFilial("RDA")+cEvaluator+cParticipant+(cAliasRD6)->RD6_CODIGO+::Project+DToS(::DateFrom)))
			
			While !RDA->(Eof()) .And.;
				  !Empty(::ResultType) .And.;
				  ::ResultType <> RDA->RDA_TIPOAV .And.;					  
				  RDA->RDA_FILIAL == xFilial("RDA") .And.;
				  RDA->RDA_CODDOR == cEvaluator .And.;
				  RDA->RDA_CODADO == cParticipant .And.;
				  RDA->RDA_CODAVA == (cAliasRD6)->RD6_CODIGO .And.;					  
				  RDA->RDA_CODPRO == ::Project .And.;
				  DToS(RDA->RDA_DTIAVA) == DToS(::DateFrom)
				RDA->(dbSkip())
			EndDo
		EndIf

		RDC->(dbSeek(xFilial("RDC")+RDA->RDA_CODAVA+cParticipant+RDA->RDA_CODPRO+RDA->RDA_CODDOR+dToS(RDA->RDA_DTIAVA)+RDA->RDA_CODNET+RDA->RDA_NIVEL+RDA->RDA_TIPOAV))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³CONSULTA PERIODO CORRETO NA AGENDA  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RDP->( dbSetOrder(1) )
		RDP->( dbSeek(xFilial("RDP")+RDA->RDA_CODAVA+dtoS(RDA->RDA_DTIAVA)) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Para estar disponivel a auto-avaliacao e' necessario que o avaliado e avaliador sejam iguais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasRD6)

		::ListOfEvaluate := {}
		aAdd(::ListOfEvaluate,WsClassNew('EvaluateList'))

		::ListOfEvaluate[1]:EvaluateId			:= (cAliasRD6)->RD6_CODIGO
		::ListOfEvaluate[1]:EvaluatedId			:= cParticipant
		::ListOfEvaluate[1]:EvaluatorId			:= RDA->RDA_CODDOR
		If ! Empty(Posicione('SRA',1,BuscaSRA(::ListOfEvaluate[1]:EvaluatedId),'RA_NOMECMP'))
			::ListOfEvaluate[1]:EvaluatedName	:= SRA->RA_NOMECMP
		Else
			::ListOfEvaluate[1]:EvaluatedName	:= RD0->RD0_NOME
		EndIf 
		::ListOfEvaluate[1]:InitialDate			:= RDA->RDA_DTIAVA
		::ListOfEvaluate[1]:FinalDate			:= RDA->RDA_DTFAVA
		::ListOfEvaluate[1]:AnswerFinalDate		:= IIf(RDA->RDA_TIPOAV=="2",RDP->RDP_RSPADO,IIF(RDA->RDA_TIPOAV=="1",RDP->RDP_RSPDOR,RDP->RDP_RSPCON))
		::ListOfEvaluate[1]:Description			:= (cAliasRD6)->RD6_DESC
		::ListOfEvaluate[1]:EvaluateType		:= (cAliasRD6)->RD6_CODTIP
		::ListOfEvaluate[1]:Net					:= RDA->RDA_CODNET
		::ListOfEvaluate[1]:Level				:= RDA->RDA_NIVEL
		::ListOfEvaluate[1]:Project				:= RDA->RDA_CODPRO
   		::ListOfEvaluate[1]:Reply				:= "1" 
   		
		If RD6->(ColumnPos("RD6_CONREP")) > 0
    		::ListOfEvaluate[1]:Reply			:= (cAliasRD6)->RD6_CONREP 
		EndIf

		If ExistBlock("MSGETPROJECT")
			::ListOfEvaluate[1]:ProjectDescription	:= ExecBlock("MSGETPROJECT", .F., .F., {RDA->RDA_CODPRO}):Description
		Else
			::ListOfEvaluate[1]:ProjectDescription	:= AllTrim(FDesc("RDN", RDA->RDA_CODPRO, "RDN_DESC",,,1))
		EndIf

		::ListOfEvaluate[1]:TypeDescription	:= RD5->RD5_DESC
		RD0->(dbSetOrder(1))
                      
		cCodAvaliador := RDA->RDA_CODDOR
	  	If RDA->RDA_TIPOAV == "2"   
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtem codigo do avaliador (avaliador <> avaliado) para auto avaliacao ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            cRecnoRda := RDA->(RECNO())    
			DbSelectArea("RDA")
			RDA->(dBSetOrder(2))
			If	RDA->(dbSeek(xFilial("RDA")+ParticipantID+PEvaluateID))	 
				While RDA->(!Eof()) .and. RDA->RDA_CODAVA == PEvaluateID	.and.	RDA->RDA_CODADO == ParticipantID 
					If RDA->RDA_TIPOAV == "2" 
				   		cCodAvaliador := RDA->RDA_CODDOR
				  		Exit
				  	EndIf	
					RDA->(DbSkip())
				End
			EndIf       

	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Retorna ao registro da auto avaliacao                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RDA->(DbGoTo(cRecnoRda))    
		EndIf	 
			
		If RD0->(dbSeek(xFilial("RD0")+cCodAvaliador))
			if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
				::ListOfEvaluate[1]:EvaluatorName		:= SRA->RA_NOMECMP
			Else
				::ListOfEvaluate[1]:EvaluatorName		:= RD0->RD0_NOME
			EndIf
		EndIf 		

		::ListOfEvaluate[1]:Vision					:= (cAliasRD6)->RD6_CODVIS
		::ListOfEvaluate[1]:VisionDescription		:= RDK->RDK_DESC
		::ListOfEvaluate[1]:Model					:= (cAliasRD6)->RD6_CODMOD
		::ListOfEvaluate[1]:ModelDescription		:= RD3->RD3_DESC
		::ListOfEvaluate[1]:Competence				:= (cAliasRD6)->RD6_CODCOM
		::ListOfEvaluate[1]:CompetenceDescription	:= RDM->RDM_DESC

		If RDC->RDC_TIPO $("456") //Microsiga
			::ListOfEvaluate[1]:EvaluateStatus	:= RDC->RDC_TIPO

			If RDC->RDC_TIPO == "4"
				::ListOfEvaluate[1]:EvaluateStatusDescription 	:= STR0039	//"Não finalizado pelo avaliador"

			ElseIf RDC->RDC_TIPO == "5"
				::ListOfEvaluate[1]:EvaluateStatusDescription 	:= STR0040	//"Não finalizado pelo avaliado"

			Else
				::ListOfEvaluate[1]:EvaluateStatusDescription 	:= STR0041	//"Não iniciado"
			EndIf

		Else
			::ListOfEvaluate[1]:EvaluateStatus		:= (cAliasRD6)->RD6_STATUS
			::ListOfEvaluate[1]:EvaluateStatusDescription := OpBxStatus( .F., .T., (cAliasRD6)->RD6_STATUS )
		EndIf

		::ListOfEvaluate[1]:SelfEvaluate  			:= RDA->RDA_TIPOAV
		::ListOfEvaluate[1]:SelfEvaluateDescription	:= OpBxTipoAv( .F., .T., RDA->RDA_TIPOAV )

		If ExistBlock("DADOSFUNC")
			aAdd(aParams, "")
			aAdd(aParams, "")
			aAdd(aParams, "")
			aAdd(aParams, RD0->RD0_CODIGO)

			aAux := U_DADOSFUNC( aParams )

			If len(aAux) > 0
				::ListOfEvaluate[1]:CostCenterDescription := aAux[1][7]
				::ListOfEvaluate[1]:FunctionDescription   := aAux[1][9]
				::ListOfEvaluate[1]:HierarqLevel          := aAux[1][11]
			Else
				::ListOfEvaluate[1]:CostCenterDescription := ""
				::ListOfEvaluate[1]:FunctionDescription   := ""
				::ListOfEvaluate[1]:HierarqLevel          := ""
			EndIf
		Else

			::ListOfEvaluate[1]:CostCenterDescription 	:= getFunCCDesc(ParticipantId)

			aCarreira := getNivelCarreira(ParticipantId)
			::ListOfEvaluate[1]:FunctionDescription  	:= aCarreira[2]//Cargo
			::ListOfEvaluate[1]:HierarqLevel 		  	:= IIf(!Empty(aCarreira[1]), aCarreira[1], aCarreira[2]) //Classe , Cargo
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adicionando o lider hierarquico.                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasRD6)->RD6_CODVIS)
	   	RDE->(dbSeek(xFilial("RDE")+ParticipantID+(cAliasRD6)->RD6_CODVIS ,.T.))
	   	While !RDE->( Eof() ) .And. ParticipantID+(cAliasRD6)->RD6_CODVIS == RDE->RDE_CODPAR+RDE->RDE_CODVIS
				If RDE->RDE_STATUS == "1" //SE STATUS ATUAL ESTA ATIVO
					cIteVis := RDE->RDE_ITEVIS
					Exit
				EndIf
				RDE->( dbSkip() )
		  	EndDo

			aLider := {}
			ApdaDorNivel( cIteVis , xFilial("RDE") ,(cAliasRD6)->RD6_CODVIS, "2" , 1, aLider )
			If Len(aLider) > 0
				::ListOfEvaluate[1]:PartLeaderId 	:= aLider[1][1]
				if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
					::ListOfEvaluate[1]:PartLeader 		:= SRA->RA_NOMECMP
				Else
					::ListOfEvaluate[1]:PartLeader 		:= FDesc("RD0", aLider[1][1], "RD0_NOME")
				EndIf
			EndIf
		EndIf

		nc := 0
		::ListOfEvaluate[1]:ListOfEvaluator := {}
		If !Empty(RD0->RD0_CODMEN)
			nc ++
			Aadd(aAvaliadores,RD0->RD0_CODMEN)
			aadd(::ListOfEvaluate[1]:ListOfEvaluator,WsClassNew('Evaluators'))
			::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorId := RD0->RD0_CODMEN
			RD0->(dbSetOrder(1))
			RD0->(dbSeek(xFilial("RD0")+::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorId))
			
			if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
				::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorName := SRA->RA_NOMECMP
			Else
				::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorName := RD0->RD0_NOME
			EndIf
		EndIf
		RDH->(dbSetOrder(1)) //RDH_FILIAL+RDH_CODTIP+RDH_CODNET+RDH_AUTOAV
		RDH->(dbSeek(xFilial("RDH")+RD6->RD6_CODTIP+RDA->RDA_CODNET))
		dbSelectArea("RDE")
		RDE->(dbSetOrder(3)) //RDE_FILIAL+RDE_CODPAR+RDE_CODVIS+RDE_ITEVIS
		RDE->(dbSeek(xFilial("RDE")+cParticipant+RD6->RD6_CODVIS))
		cAvaliadores := ApdaDorNivel( RDE_ITEVIS, xFilial("RDE"), RD6->RD6_CODVIS , RDH->RDH_NIVEL, RDH->RDH_NUMNIV )
		If !( cAvaliadores == "__NoExistItem__" ) .And. !Empty(cAvaliadores)
			While !Empty(cAvaliadores)
				If aScan(aAvaliadores,Subs(cAvaliadores,1,Len(RD0->RD0_CODIGO))) == 0
					Aadd(aAvaliadores,Subs(cAvaliadores,1,Len(RD0->RD0_CODIGO)))
					nc ++
					aadd(::ListOfEvaluate[1]:ListOfEvaluator,WsClassNew('Evaluators'))
					::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorId := Subs(cAvaliadores,1,Len(RD0->RD0_CODIGO))
					RD0->(dbSeek(xFilial("RD0")+::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorId))
					if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
						::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorName := SRA->RA_NOMECMP
					Else
						::ListOfEvaluate[1]:ListOfEvaluator[nc]:EvaluatorName := RD0->RD0_NOME
					EndIf
				EndIf
				nAt := At("/",cAvaliadores)
				cAvaliadores := Subs(cAvaliadores,nAt+1,Len(cAvaliadores)-Len(RD0->RD0_CODIGO))
			EndDo
		EndIf

		RD0->(dbSeek(xFilial("RD0")+cParticipant))

		If ExistBlock("MSBRWPROJECT")
			cCodCli	:= SubStr(::ListOfEvaluate[1]:Project, 1, GetSx3Cache("ZCT_CLIENT", "X3_TAMANHO"))
			cCodLoja:= SubStr(::ListOfEvaluate[1]:Project, 1+Len(cCodCli), GetSx3Cache("ZCT_LOJA", "X3_TAMANHO"))
			cCodProj:= SubStr(::ListOfEvaluate[1]:Project, 1+Len(cCodCli)+Len(cCodLoja), GetSx3Cache("ZCT_PROJET", "X3_TAMANHO"))
		
			::ListOfEvaluate[1]:ListOfProject:= ExecBlock("MSBRWPROJECT", .F., .F., {cCodProj, cCodCli, cCodLoja})			
		Else
			nc := 0
			::ListOfEvaluate[1]:ListOfProject := {}
			dbSelectArea("RDN")
			dbGoTop()
			While !Eof()
				nc ++
				aadd(::ListOfEvaluate[1]:ListOfProject,WsClassNew('Projects'))
				::ListOfEvaluate[1]:ListOfProject[nc]:ProjectId 			:= RDN->RDN_CODIGO
				::ListOfEvaluate[1]:ListOfProject[nc]:ProjectDescription 	:= RDN->RDN_DESC
				::ListOfEvaluate[1]:ListOfProject[nc]:DateFrom				:= RDN->RDN_DTIPRO
				::ListOfEvaluate[1]:ListOfProject[nc]:DateTo				:= RDN->RDN_DTFPRO
				::ListOfEvaluate[1]:ListOfProject[nc]:ClientID 			:= RDN->RDN_CODCLI
				::ListOfEvaluate[1]:ListOfProject[nc]:ClientDescription 	:= If(!Empty(RDN->RDN_CODCLI),FDesc("SA1", RDN->RDN_CODCLI, "A1_NOME"),"")
				dbSkip()
			EndDo
		EndIf

		dbSelectArea("RD8")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no RD7 para carregar as Definicoes da Avaliacao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RD7->(dbSeek(xFilial("RD7")+(cAliasRD6)->RD6_CODIGO))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no RD3 para Obter o Modelo de Avaliacao                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If RD3->(dbSeek(xFilial("RD3")+(cAliasRD6)->RD6_CODMOD))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no RD8 para Obter as Questoes a serem enviadas             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			RD8->(dbSeek(xFilial("RD8")+RD3->RD3_CODIGO))
		EndIf
		dbSelectArea("RD8")

		::ListOfEvaluate[1]:ListOfCompetence := {}
		nc := 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ordenar conforme estrutura de competencias                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		aTree := {}
		RhTreeRecursiv( (cAliasRD6)->RD6_CODCOM , , , @aTree )     //Pwsxapd.prw

            aListItem:={}
		For nX:=1 to Len(aTree)
			RhRetItem(aTree[nX],@aListItem)
		Next nX

		nPag := 1

  			For nx := 1 To Len(aListItem)

			cItem := aListItem[nx]

			dbSelectArea("RD8")
			If RD8->(dbSeek(xFilial("RD8") + RD3->RD3_CODIGO + (cAliasRD6)->RD6_CODCOM + cItem))

				If ::PageLoad==0 .Or. nPag == ::PageLoad
					nc ++
					aadd(::ListOfEvaluate[1]:ListOfCompetence,WsClassNew('Competences'))
					RDO->(dbSeek(xFilial("RDO")+RD8->(RD8_CODMOD+RD8_CODCOM+RD8_ITECOM)))
					RD2->(dbSeek(xFilial("RD2")+RD8->(RD8_CODCOM+RD8_ITECOM)))
					RBL->(dbSeek(xFilial("RBL")+RDO->(RDO_ESCALA+RDO_ITEESC)))
					::ListOfEvaluate[1]:ListOfCompetence[nc]:CompetenceItem := RD8->(RD8_ITECOM)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:CompetenceItemDescription := RD2->(RD2_DESC)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:DescCompetenceItem			:= If(Empty(RD2->(RD2_CODMEM)), "", ApdMsMm(RD2->(RD2_CODMEM), 80))
					::ListOfEvaluate[1]:ListOfCompetence[nc]:Value      := RDO->(RDO_ESCALA)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ValueItem  := RDO->(RDO_ITEESC)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ValueItemDescription  := RBL->(RBL_DESCRI)
					
					lTemResp := .F.
					
					If ::Questions //exibe questoes
						::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion := {}
					EndIf
					nY := 0
					cWhile := RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM
					While !RD8->(Eof()) .And. RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM ==	cWhile
						If ::Questions //exibe questoes
							nY ++
							aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion,WsClassNew('Questions'))
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:QuestionID := RD8->(RD8_CODQUE)

							If SQO->(dbSeek(xFilial("SQO")+RD8->RD8_CODQUE))

								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Question   := SQO->(QO_QUEST)
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Points     := SQO->(QO_PONTOS)
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ObjectType := SQO->(QO_TIPOOBJ)
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:DescQuestion	:= If(Empty(SQO->(QO_CODMEM)), "", APDMSMM(SQO->(QO_CODMEM), 80))
								
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Scale     	:= RD8->(RD8_ESCALA)
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem 	:= RD8->(RD8_ITEESC)
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Edit   	:= RD8->(RD8_EDITA)

								RBL->(dbSeek(xFilial("RBL") + RD8->(RD8_ESCALA+RD8_ITEESC)))
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItemDescription := RBL->(RBL_DESCRI)
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative := {}

								nZ := 1
								If Empty(SQO->QO_ESCALA)
									SQP->(dbSeek(xFilial("SQP") + RD8->RD8_CODQUE))

									While !(SQP->(Eof())) .And. SQP->QP_FILIAL+SQP->QP_QUESTAO==xFilial("SQP")+RD8->RD8_CODQUE
										If SQO->QO_TIPOOBJ != "3" //Dissertativa
											aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListofAlternative,WsClassNew('Alternatives'))

											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:AlternativeID:= SQP->QP_ALTERNA
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Alternative  := SQP->QP_DESCRIC
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Percentage   := SQP->QP_PERCENT

										cConteudo := ""

										For nPos := 1 to Len(cParamInfCb)
											If Substr(cParamInfCb, nPos, 1) == "1"
												cConteudo += SQP->QP_ALTERNA + " - "
											ElseIf Substr(cParamInfCb, nPos, 1) == "2"
												cConteudo += SQP->QP_DESCRIC + " - "
											ElseIf Substr(cParamInfCb, nPos, 1) == "3"
												cConteudo += AllTrim(Str(SQP->QP_PERCENT)) + " - "
											EndIf
										Next nPos
										
										If Empty(cConteudo)
											cConteudo := SQP->QP_ALTERNA
										Else
											cConteudo := Substr(cConteudo, 1, Len(cConteudo) - 3)
										EndIf
										
										::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:InfCombo   := cConteudo

											nZ ++
										EndIf

										SQP->(dbSkip())
									EndDo
								Else
									RBL->(dbSeek(xFilial("RBL") + SQO->QO_ESCALA))

									While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+SQO->QO_ESCALA
										aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative,WsClassNew('Alternatives'))
										::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:AlternativeID:= RBL->RBL_ITEM
										::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Alternative  := RBL->RBL_DESCRI
										::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Percentage   := RBL->RBL_VALOR

										cConteudo := ""
										For nPos := 1 to Len(cParamInfCb)
											If Substr(cParamInfCb, nPos, 1) == "1"
												cConteudo += RBL->RBL_ITEM + " - "
											ElseIf Substr(cParamInfCb, nPos, 1) == "2"
												cConteudo += RBL->RBL_DESCRI + " - "
											ElseIf Substr(cParamInfCb, nPos, 1) == "3"
												cConteudo += AllTrim(Str(RBL->RBL_VALOR)) + " - "
											EndIf
										Next nPos

										If Empty(cConteudo)
											cConteudo := RBL->RBL_ITEM
										Else
											cConteudo := Substr(cConteudo, 1, Len(cConteudo) - 3)
										EndIf

										::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:InfCombo   := cConteudo

										nZ ++
										RBL->(dbSkip())
									EndDo
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Lista de itens de escala de Relevancia                               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
								nZ := 1
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:RelevanceList := {}
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice := {}
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice := {}
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:SelfChoice := {}
								RBL->(dbSeek(xFilial("RBL") + RD8->RD8_ESCALA))
								While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+RD8->RD8_ESCALA
									aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:RelevanceList,WsClassNew('Alternatives'))
									::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:RelevanceList[nZ]:AlternativeID:= RBL->RBL_ITEM
									::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:RelevanceList[nZ]:Alternative  := RBL->RBL_DESCRI
									::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:RelevanceList[nZ]:Percentage   := RBL->RBL_VALOR
							   		::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:RelevanceList[nZ]:InfCombo	     := ""
									nZ ++
									RBL->(dbSkip())
								EndDo      

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ resposta do avaliado (auto-avaliacao)                                ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
								If !Empty(cEvaluator)

									If RDA->RDA_TIPOAV == '3' //Consenso
	
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ tipo 1=Avaliador                                                     ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
										If RDB->(dbSeek(xFilial("RDB")+RD6->RD6_CODIGO+cParticipant+RDA->RDA_CODPRO+cEvaluator+dToS(RDA->RDA_DTIAVA)+RD8->RD8_CODCOM+RD8->RD8_ITECOM+RD8->RD8_CODQUE+'1'))
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorAnswer := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
											If !Empty(RDB->RDB_ITEESC)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem   := RDB->RDB_ITEESC
											EndIf
											cQuestao := RDB->RDB_CODQUE
											While RDB->(RDB_FILIAL + RDB_CODAVA + RDB_CODADO + RDB_CODPRO + RDB_CODDOR + dtos(RDB_DTIAVA) + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_TIPOAV ) == xFilial("RDB")+RD6->RD6_CODIGO+cParticipant+RDA->RDA_CODPRO+cEvaluator+dToS(RDA->RDA_DTIAVA)+RD8->RD8_CODCOM+RD8->RD8_ITECOM+cQuestao+'1'
												Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice, WsClassNew('Respostas'))
												nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice[nPos]:Alternativa := RDB->RDB_CODALT
												RDB->(dbSkip())
												lTemResp := .T.
											EndDo
										EndIf

										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ tipo 2=Auto-Avaliacao                                                ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
										If RDB->(dbSeek(xFilial("RDB")+RD6->RD6_CODIGO+cParticipant+RDA->RDA_CODPRO+cParticipant+dToS(RDA->RDA_DTIAVA)+RD8->RD8_CODCOM+RD8->RD8_ITECOM+RD8->RD8_CODQUE+'2'))
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:SelfAnswer := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
											If !Empty(RDB->RDB_ITEESC)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem   := RDB->RDB_ITEESC
											EndIf
											cQuestao := RDB->RDB_CODQUE
											While RDB->(RDB_FILIAL + RDB_CODAVA + RDB_CODADO + RDB_CODPRO + RDB_CODDOR + dtos(RDB_DTIAVA) + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_TIPOAV ) == xFilial("RDB")+RD6->RD6_CODIGO+cParticipant+RDA->RDA_CODPRO+cParticipant+dToS(RDA->RDA_DTIAVA)+RD8->RD8_CODCOM+RD8->RD8_ITECOM+cQuestao+'2'
												Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:SelfChoice, WsClassNew('Respostas'))
												nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:SelfChoice)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:SelfChoice[nPos]:Alternativa := RDB->RDB_CODALT
												RDB->(dbSkip())
												lTemResp := .T.
											EndDo
										EndIf
									EndIf
									
									If cEvaluateType == "2"  // Pesquisa de clima
										If cTipPesq == "2"   // Pesquisa nao identificada
											cCoddorPesq := space(len(RDA->RDA_CODDOR))
										Else
											cCoddorPesq := cParticipant	
										EndIf
										
										If RDB->(dbSeek(xFilial("RDB") + RD6->RD6_CODIGO + RDA->RDA_CODADO + RDA->RDA_CODPRO + cCoddorPesq + dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RD8->RD8_CODQUE + RDA->RDA_TIPOAV))
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:justification 	   := Alltrim(ApdMsMm(RDB->RDB_CODJUS))
											If !Empty(RDB->RDB_ITEESC)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem   := RDB->RDB_ITEESC
											EndIf
											If !Empty(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription)
												lTemResp := .T.
											EndIf
											cQuestao := RDB->RDB_CODQUE
											While RDB->RDB_CODQUE == cQuestao .and. RDB->RDB_CODADO == cParticipant
												Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice, WsClassNew('Respostas'))
												nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice[nPos]:Alternativa := RDB->RDB_CODALT
												RDB->(dbSkip())
												lTemResp := .T.
											EndDo
										EndIf 
									Else
										If RDB->(dbSeek(xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cEvaluator + dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RD8->RD8_CODQUE + RDA->RDA_TIPOAV))
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:justification     := Alltrim(ApdMsMm(RDB->RDB_CODJUS))
											If !Empty(RDB->RDB_ITEESC)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem   := RDB->RDB_ITEESC
											EndIf
											If !Empty(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription)
												lTemResp := .T.
											EndIf
											cQuestao := RDB->RDB_CODQUE
											While RDB->(RDB_FILIAL + RDB_CODAVA + RDB_CODADO + RDB_CODPRO + RDB_CODDOR + dtos(RDB_DTIAVA) + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_TIPOAV ) == xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cEvaluator + dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RD8->RD8_CODQUE + RDA->RDA_TIPOAV
												Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice, WsClassNew('Respostas'))
												nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice)
												::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice[nPos]:Alternativa := RDB->RDB_CODALT
												RDB->(dbSkip())
												lTemResp := .T.
											EndDo
										EndIf 
									EndIf
									
								Else
									If RDB->(dbSeek(xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cParticipant+dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RD8->RD8_CODQUE + RDA->RDA_TIPOAV)) //auto-avaliacao
										::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
										::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:justification := Alltrim(ApdMsMm(RDB->RDB_CODJUS))
										If !Empty(RDB->RDB_ITEESC)
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem := RDB->RDB_ITEESC
										EndIf
										If !Empty(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription)
											lTemResp := .T.
										EndIf
										cQuestao := RDB->RDB_CODQUE
										While RDB->(RDB_FILIAL + RDB_CODAVA + RDB_CODADO + RDB_CODPRO + RDB_CODDOR + dtos(RDB_DTIAVA) + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_TIPOAV ) == xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cParticipant+dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RD8->RD8_CODQUE + RDA->RDA_TIPOAV
											Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice, WsClassNew('Respostas'))
											nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice)
											::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice[nPos]:Alternativa := RDB->RDB_CODALT
											RDB->(dbSkip())
											lTemResp := .T.
										EndDo
									EndIf
 								EndIf
							EndIf
						EndIf
						RD8->(dbSkip())
					EndDo
					::ListOfEvaluate[1]:ListOfCompetence[nc]:TemResposta  := lTemResp
					If nY == 0
						RD8->(dbSkip())
					EndIf
				Else
					cWhile := RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM
					While !RD8->(Eof()) .And. RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM ==;
							cWhile
						RD8->(dbSkip())
						If RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM <> cWhile
							nRegs ++
							If nRegs > ::PageLen
								nPag ++
								nRegs := 1
							EndIf
						EndIf
					EndDo
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ controle de envio com maximo de questoes por pagina                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(::ListOfEvaluate[1]:ListOfCompetence) >= ::PageLen
					nPag ++
				EndIf
			EndIf

		Next nx
		
		RD0->(dbSetOrder(1))
		If !Empty(RD0->RD0_CODMEN) .AND. RD0->(dbSeek(xFilial("RD0")+RD0->RD0_CODMEN))
			if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
				::ListOfEvaluate[1]:CoachName	:=	SRA->RA_NOMECMP
			Else
				::ListOfEvaluate[1]:CoachName	:=	RD0->RD0_NOME
			EndIf
		Else
			::ListOfEvaluate[1]:CoachName	:=	::ListOfEvaluate[1]:EvaluatorName
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CONSULTA AVALIADOR ACIMA DA MESMA AVALIACAO PARA PEGAR NOME            ³
		//³ COLOQUEI NO FINAL PARA NAO ATRAPALHAR CONSULTA PRINCIPAL NA TABELA RDA ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		RDA->(dbSetOrder(11))
		RDA->(dbSeek( xFilial("RDA")+::ListOfEvaluate[1]:EvaluateId+::ParticipantId+::ListOfEvaluate[1]:Project+dToS(::ListOfEvaluate[1]:InitialDate) ))
		While !RDA->(Eof()) .And. RDA->(RDA_FILIAL+RDA_CODAVA+RDA_CODADO+RDA_CODPRO+DTOS(RDA_DTIAVA)) == (xFilial("RDA")+::ListOfEvaluate[1]:EvaluateId+::ParticipantId+::ListOfEvaluate[1]:Project+dToS(::ListOfEvaluate[1]:InitialDate))
			If RDA->RDA_CODDOR != RDA->RDA_CODADO
				RD0->(dbSetOrder(1))
				If RD0->(dbSeek(xFilial("RD0")+RDA->RDA_CODDOR))
				
					if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
						::ListOfEvaluate[1]:OtherEvaluatorName	:= SRA->RA_NOMECMP
					Else
						::ListOfEvaluate[1]:OtherEvaluatorName	:= RD0->RD0_NOME
					EndIf
				EndIf
				Exit
			EndIf
			RDA->(DbSkip())
		EndDo

		If lQuery
			dbSelectArea(cAliasRD6)
			dbCloseArea()
			dbSelectArea("RD6")
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada criado para ordenar as alternativas                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If(ExistBlock("WS010PADR"))
			::ListOfEvaluate[1] := ExecBlock("WS010PADR",.F.,.F.,{::ListOfEvaluate[1]})
		EndIf

	Else
		lRetorno := .F.
		SetSoapFault("GETPEVALUATE",STR0022) //"Avaliação nao encontrado"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("GETPEVALUATE",STR0023) //"Participante invalido"
EndIf

	RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GePEHeader³Autor  ³ Aline Correa do Vale  ³ Data ³15.08.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de recuperacao do header das cotacoes do sistema      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve o header de uma estrutura                ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GePEHeader WSRECEIVE HeaderType WSSEND Header WSSERVICE MtSupplierEvaluate

::Header := MPEHeader(::HeaderType)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwObjectives ³ Autor ³Aline Correa do Vale³Data ³23.03.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao dos tipos de objetivos disponiveis para³±±
±±³          ³avaliacoes quantitativas                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwObjectives WSRECEIVE UserCode,ParticipantId,ObjectiveType,PageLen,PageLoad,QueryAddWhere WSSEND ListOfObjective WSSERVICE RHPerformanceEvaluate
Local aArea     := GetArea()
Local lRetorno  := .T.
Local lQuery    := .F.
Local nX        := 0
Local nc		:= 1
Local nPag      := 1
Local nRegs     := 1
Local cAliasRDI := "RDI"
Local np := 0
DEFAULT ::PageLen := 0
DEFAULT ::PageLoad:= 0
DEFAULT ::ObjectiveType:= "*"
::ObjectiveType:= If(Empty(::ObjectiveType),"*",::ObjectiveType)

dbSelectArea("RDI")
dbSetOrder(1)
dbSelectArea("RBL")
dbSetOrder(1)
dbSelectArea("RDU")
dbSetOrder(1)
dbSelectArea("RBK")
dbSetOrder(1)
dbSelectArea(cAliasRDI)
dbSeek(xFilial("RDI"))
::ListOfObjective := {}
RDV->(dbSelectArea(1))

While !Eof()
	If  (::PageLoad == 0 .Or. nPag == ::PageLoad) .And.;
		(::ObjectiveType == "*" .Or. ::ObjectiveType == (cAliasRDI)->RDI_TIPO)
		If (RDV->(dbSeek(xFilial("RDI")+::ParticipantID+(cAliasRDI)->RDI_CODIGO)))
			aadd(::ListOfObjective,WsClassNew('Objectives'))
			nX++
			::ListOfObjective[nx]:ObjectiveID			:= (cAliasRDI)->RDI_CODIGO
			::ListOfObjective[nx]:ObjectiveDescription	:= (cAliasRDI)->RDI_DESC
			::ListOfObjective[nx]:ObjectiveDetail		:= Alltrim(ApdMsMm((cAliasRDI)->RDI_CODMEM))
			::ListOfObjective[nx]:Relevance				:= (cAliasRDI)->RDI_ESCREL
			If !Empty((cAliasRDI)->RDI_ESCREL)
				RBK->(dbSeek(xFilial("RBK")+(cAliasRDI)->RDI_ESCREL))
				::ListOfObjective[nx]:RelevanceDescription	:= RBK->RBK_DESCRI
			EndIf
			::ListOfObjective[nx]:AchieveScale			:= (cAliasRDI)->RDI_ESCATG
			If !Empty((cAliasRDI)->RDI_ESCATG)
				RBK->(dbSeek(xFilial("RBK")+(cAliasRDI)->RDI_ESCATG))
				::ListOfObjective[nx]:AchieveScaleDescription	:= RBK->RBK_DESCRI
			EndIf
			::ListOfObjective[nx]:KnowledgeScale		:= (cAliasRDI)->RDI_ESCCON
			If !Empty((cAliasRDI)->RDI_ESCCON)
				RBK->(dbSeek(xFilial("RBK")+(cAliasRDI)->RDI_ESCCON))
				::ListOfObjective[nx]:KnowledgeScaleDescription	:= RBK->RBK_DESCRI
			EndIf

			dbSelectArea("RBL")
	    	nc := 1
	    	::ListOfObjective[nx]:RelevanceList := {}
			RBL->(dbSeek(xFilial("RBL") + (cAliasRDI)->RDI_ESCREL))
			While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+(cAliasRDI)->RDI_ESCREL
				aadd(::ListOfObjective[nx]:RelevanceList,WsClassNew('Alternatives'))
				::ListOfObjective[nx]:RelevanceList[nc]:AlternativeID:= RBL->RBL_ITEM
				::ListOfObjective[nx]:RelevanceList[nc]:Alternative  := RBL->RBL_DESCRI
				::ListOfObjective[nx]:RelevanceList[nc]:Percentage   := RBL->RBL_VALOR
				::ListOfObjective[nx]:RelevanceList[nc]:InfCombo		:= ""
				nc ++
				RBL->(dbSkip())
			EndDo
	    	nc := 1
	    	::ListOfObjective[nx]:AchieveList := {}
			RBL->(dbSeek(xFilial("RBL") + (cAliasRDI)->RDI_ESCATG))
			While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+(cAliasRDI)->RDI_ESCATG
				aadd(::ListOfObjective[nx]:AchieveList,WsClassNew('Alternatives'))
				::ListOfObjective[nx]:AchieveList[nc]:AlternativeID:= RBL->RBL_ITEM
				::ListOfObjective[nx]:AchieveList[nc]:Alternative  := RBL->RBL_DESCRI
				::ListOfObjective[nx]:AchieveList[nc]:Percentage   := RBL->RBL_VALOR
				nc ++
				RBL->(dbSkip())
			EndDo
	    	nc := 1
	    	::ListOfObjective[nx]:KnowledgeList := {}
	    	If !Empty((cAliasRDI)->RDI_ESCCON)
				RBL->(dbSeek(xFilial("RBL") + (cAliasRDI)->RDI_ESCCON))
				While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+(cAliasRDI)->RDI_ESCCON
					aadd(::ListOfObjective[nx]:KnowledgeList,WsClassNew('Alternatives'))
					::ListOfObjective[nx]:KnowledgeList[nc]:AlternativeID:= RBL->RBL_ITEM
					::ListOfObjective[nx]:KnowledgeList[nc]:Alternative  := RBL->RBL_DESCRI
					::ListOfObjective[nx]:KnowledgeList[nc]:Percentage   := RBL->RBL_VALOR
					nc ++
					RBL->(dbSkip())
				EndDo
			EndIf
		EndIf
	EndIf
	nRegs ++
	If nRegs > ::PageLen .And. ::PageLen <> 0
		nPag ++
		nRegs := 0
	EndIf
	dbSelectArea(cAliasRDI)
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a lista de periodos cadastrados para o objetivo                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
For np := 1 To Len(::ListOfObjective)
	::ListOfObjective[np]:PeriodList := {}
	RDV->(dbSeek(xFilial("RDI")+::ParticipantID+::ListOfObjective[np]:ObjectiveID))
	nx := 1
	While RDV->(!EoF())
		if ::ListOfObjective[np]:ObjectiveID == RDV->RDV_CODOBJ
			RDU->(dbSeek(xFilial("RDI")+RDV->RDV_CODPER))
			nPos := aScan(::ListOfObjective[np]:PeriodList, {|x| x:PeriodId == RDU->RDU_CODIGO})
			If nPos == 0 // Verifico se o periodo ja nao foi adicionado ao objetivo
				aAdd(::ListOfObjective[np]:PeriodList,WsClassNew('Periods'))
				::ListOfObjective[np]:PeriodList[nx]:PeriodId	:= RDU->RDU_CODIGO
				::ListOfObjective[np]:PeriodList[nx]:PeriodDescription := RDU->RDU_DESC
				::ListOfObjective[np]:PeriodList[nx]:DateFrom	:= RDU->RDU_DATINI
				::ListOfObjective[np]:PeriodList[nx]:DateTo		:= RDU->RDU_DATFIM
			EndIf
			nx ++
		EndIf
		RDV->(dbSkip())
	EndDo
Next np

nc := 1
If lQuery
	dbSelectArea(cAliasRDI)
	dbCloseArea()
	dbSelectArea("RDI")
EndIf
RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwMyObjectives³ Autor ³Aline Correa do Vale³Data ³23.03.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao dos meus objetivos cadastrados nas     ³±±
±±³          ³avaliacoes quantitativas                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do participante                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwMyObjectives WSRECEIVE UserCode,ParticipantId, ObjectiveType, DateFrom,DateTo,PeriodID,PageLen,PageLoad,QueryAddWhere WSSEND ListOfObjective WSSERVICE RHPerformanceEvaluate
Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local nX        	:= 0
Local nPag      	:= 1
Local nRegs     	:= 1
Local cAliasRDJ 	:= "RDJ"
Local cAliasRDI 	:= "RDI"
Local cParticipant	:= Subs(::ParticipantID,1,Len(RD0->RD0_CODIGO))
Local cNome     	:= ""
Local cQuery    	:= ""
Local lExibe    	:= .T.
Local cObjetivo 	:= ::ObjectiveType //codigo do objetivo
Local cPeriodID 	:= ::PeriodID
Local cMentor   	:= ""
Local cAvaliador	:= ""
Local cNomeDor  	:= ""

DEFAULT ::PageLen 	:= 0
DEFAULT ::PageLoad	:= 0

If PrtChkUser(::UserCode,"RHPerformanceEvaluate","BrwMyObjectives")
	If !Empty(cParticipant) .And. !Empty(cObjetivo)
		dbSelectArea("RD0")
		dbSetOrder(1)
		dbSelectArea("RDI")
		dbSetOrder(1)
		dbSelectArea("RDJ")
		dbSetOrder(1)
		dbSelectArea("RDU")
		dbSetOrder(1)
		dbSelectArea("RDV")
		dbSetOrder(1)
		dbSelectArea("RBL")
		dbSetOrder(1)
		dbSelectArea(cAliasRDJ)
		If dbSeek(xFilial("RDJ")+cParticipant+cObjetivo+cPeriodID)
			::ListOfObjective := {}
		EndIf
		RD0->(dbSeek(xFilial("RD0")+(cAliasRDJ)->RDJ_CODPAR))
		if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP")) 
			cNome := SRA->RA_NOMECMP
		Else
			cNome := RD0->RD0_NOME
		EndIf
		cMentor:= RD0->RD0_CODMEN

		If !RDJ->(Eof()) .And. xFilial("RDJ")+cParticipant+cObjetivo == (cAliasRDJ)->(RDJ_FILIAL+RDJ_CODPAR+RDJ_CODOBJ)
			RDV->(dbSeek(xFilial("RDV")+cParticipant+cObjetivo+(cAliasRDJ)->RDJ_PERIOD))
		Else
			RDV->(dbSeek(xFilial("RDV")+cParticipant+cObjetivo))
		EndIf

		RD0->(dbSeek(xFilial("RD0")+RDV->RDV_CODDOR))
		cAvaliador:= RDV->RDV_CODDOR  // Pega o codigo do avaliador
		if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
			cNomeDor  := SRA->RA_NOMECMP  // Pega o nome do avaliador
		Else
			cNomeDor  := RD0->RD0_NOME  // Pega o nome do avaliador
		EndIf
		While !RDJ->(Eof()) .And. xFilial("RDJ")+cParticipant+cObjetivo+cPeriodID == (cAliasRDJ)->(RDJ_FILIAL+RDJ_CODPAR+RDJ_CODOBJ+cPeriodID)

			If !Empty(::DateFrom)
				lExibe := RDJ->RDJ_DTINI >= ::DateFrom
			EndIf
			If !Empty(::DateTo) .And. lExibe
				lExibe := RDJ->RDJ_DTFIM <= ::DateTo
			EndIf
			RDI->(dbSeek(xFilial("RDI")+RDJ->RDJ_CODOBJ))

			If lExibe
				If ::PageLoad == 0 .Or. nPag == ::PageLoad
					aadd(::ListOfObjective,WsClassNew('Objectives'))
					nX++
					::ListOfObjective[nx]:EvaluatedID			:= (cAliasRDJ)->RDJ_CODPAR
					::ListOfObjective[nx]:EvaluatedName			:= cNome
					RD0->(dbSeek(xFilial("RD0")+(cAliasRDJ)->RDJ_CODDOR))
					::ListOfObjective[nx]:EvaluatorID			:= cAvaliador
					::ListOfObjective[nx]:EvaluatorName			:= cNomeDor
					::ListOfObjective[nx]:ObjectiveID			:= (cAliasRDJ)->RDJ_CODOBJ
					::ListOfObjective[nx]:Item					:= (cAliasRDJ)->RDJ_ITEM
					::ListOfObjective[nx]:ItemDate				:= (cAliasRDJ)->RDJ_DATITM
					::ListOfObjective[nx]:ObjectiveDescription	:= (cAliasRDI)->RDI_DESC
					::ListOfObjective[nx]:Period				:= (cAliasRDJ)->RDJ_PERIOD
					RDU->(dbSeek(xFilial("RDU")+(cAliasRDJ)->RDJ_PERIOD))
					::ListOfObjective[nx]:PeriodDescription		:= RDU->RDU_DESC
					::ListOfObjective[nx]:InitialDate			:= (cAliasRDJ)->RDJ_DTINI
					::ListOfObjective[nx]:FinalDate				:= (cAliasRDJ)->RDJ_DTFIM
					::ListOfObjective[nx]:Relevance				:= (cAliasRDJ)->RDJ_ESCREA
					::ListOfObjective[nx]:RelevanceItem			:= (cAliasRDJ)->RDJ_ITESCR
					RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCREA+(cAliasRDJ)->RDJ_ITESCR))
					::ListOfObjective[nx]:RelevanceDescription	:= RBL->RBL_DESCRI
					::ListOfObjective[nx]:AchieveScale			:= (cAliasRDJ)->RDJ_ESCATG
					::ListOfObjective[nx]:AchieveScaleItem		:= (cAliasRDJ)->RDJ_ITESAT
					RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCATG+(cAliasRDJ)->RDJ_ITESAT))
					::ListOfObjective[nx]:AchieveScaleDescription := RBL->RBL_DESCRI
					RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCATG+(cAliasRDJ)->RDJ_ITATCN))
					::ListOfObjective[nx]:SenseScaleItem		:= (cAliasRDJ)->RDJ_ITATCN
					::ListOfObjective[nx]:SenseScaleDescription	:= RBL->RBL_DESCRI
					::ListOfObjective[nx]:Status				:= (cAliasRDJ)->RDJ_STATUS
					::ListOfObjective[nx]:SeqItem				:= (cAliasRDJ)->RDJ_SEQITM
					::ListOfObjective[nx]:StatusDescription		:= RDJStatusBox(,.T.,(cAliasRDJ)->RDJ_STATUS)

					If !Empty((cAliasRDJ)->RDJ_ESCCON)
						::ListOfObjective[nx]:KnowledgeScale	:= (cAliasRDJ)->RDJ_ESCCON
						::ListOfObjective[nx]:ActualItem		:= (cAliasRDJ)->RDJ_ITECOA
						If !Empty((cAliasRDJ)->RDJ_ITECOA)
							RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCCON+(cAliasRDJ)->RDJ_ITECOA))
							::ListOfObjective[nx]:ActualItemDescription	:= RBL->RBL_DESCRI
						EndIf
						::ListOfObjective[nx]:ProposeItem		:= (cAliasRDJ)->RDJ_ITECOP
						If !Empty((cAliasRDJ)->RDJ_ITECOP)
							RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCCON+(cAliasRDJ)->RDJ_ITECOP))
							::ListOfObjective[nx]:ProposeItemDescription := RBL->RBL_DESCRI
						EndIf
					EndIf
					::ListOfObjective[nx]:Observation			:= Alltrim(ApdMsMm((cAliasRDJ)->RDJ_CODMEM))
				EndIf

				nRegs ++

				If nRegs > ::PageLen .And. ::PageLen <> 0
					nPag ++
					nRegs := 0
				EndIf
			EndIf
			dbSkip()
		EndDo
		dbSelectArea("RDJ")
	Else
		lRetorno := .F.
		SetSoapFault("BRWMYOBJECTIVES",STR0023) //"Participante invalido"
	EndIf
EndIf

If !Empty(cQuery)
	dbSelectArea(cAliasRDJ)
	dbCloseArea()
	dbSelectArea("RDJ")
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwTeamObjective³Autor ³Aline Correa do Vale³Data ³10.05.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao do objetivos cadastrados para meus     ³±±
±±³          ³avaliados                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Avaliador                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwTeamObjective WSRECEIVE UserCode,ParticipantId,ObjectiveType,DateFrom,DateTo,PageLen,PageLoad,QueryAddWhere WSSEND ListOfObjective WSSERVICE RHPerformanceEvaluate
Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local nX        	:= 0
Local nC			:= 1
Local nPag      	:= 1
Local np 			:= 0
Local nRegs     	:= 1
Local cAliasRDJ 	:= "RDJ"
Local cAliasRDI 	:= "RDI"
Local cParticipant	:= Subs(::ParticipantID,1,Len(RD0->RD0_CODIGO))
Local cNome     	:= ""
Local cQuery    	:= ""
Local lExibe    	:= .T.
Local cTipo     	:= If(Empty(::ObjectiveType),"*",::ObjectiveType)
Local nPos			:= 0

DEFAULT ::PageLen 	:= 0
DEFAULT ::PageLoad	:= 0


If !Empty(cParticipant)
	dbSelectArea("RD0")
	dbSetOrder(1)
	dbSelectArea("RDI")
	dbSetOrder(1)
	dbSelectArea("RDJ")
	dbSetOrder(10)
	dbSelectArea("RDU")
	dbSetOrder(1)
	dbSelectArea("RBL")
	dbSetOrder(1)
	dbSelectArea(cAliasRDJ)
	dbSeek(xFilial("RDJ")+cParticipant)
	::ListOfObjective := {}
	RD0->(dbSeek(xFilial("RD0")+(cAliasRDJ)->RDJ_CODDOR))
	if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
		cNome := SRA->RA_NOMECMP
	Else
		cNome := RD0->RD0_NOME
	EndIf
	While !Eof() .And. (xFilial("RDJ")+cParticipant == (cAliasRDJ)->(RDJ_FILIAL+RDJ_CODDOR))
		If lExibe .And. (cTipo == "*" .Or. RDI->RDI_TIPO == cTipo)
			If ::PageLoad == 0 .Or. nPag == ::PageLoad
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ VERIFICA SE JA EXISTE UMA META PARA O PARTICIPANTE                     ³		
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
				nPos := aScan(::ListOfObjective, {|x| x:ObjectiveDescription == (cAliasRDI)->RDI_DESC})
			    If nPos == 0
					aAdd(::ListOfObjective,WsClassNew('Objectives'))
					nX++
					RD0->(dbSeek(xFilial("RD0")+(cAliasRDJ)->RDJ_CODPAR))
					::ListOfObjective[nx]:EvaluatedID			:= (cAliasRDJ)->RDJ_CODPAR
					
					if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
						::ListOfObjective[nx]:EvaluatedName			:= SRA->RA_NOMECMP
					Else
						::ListOfObjective[nx]:EvaluatedName			:= RD0->RD0_NOME
					EndIf
					::ListOfObjective[nx]:EvaluatorID			:= (cAliasRDJ)->RDJ_CODDOR
					::ListOfObjective[nx]:EvaluatorName			:= cNome
					::ListOfObjective[nx]:ObjectiveID			:= (cAliasRDJ)->RDJ_CODOBJ
					::ListOfObjective[nx]:ObjectiveDescription	:= (cAliasRDI)->RDI_DESC
					::ListOfObjective[nx]:Period				:= (cAliasRDJ)->RDJ_PERIOD
					RDU->(dbSeek(xFilial("RDU")+(cAliasRDJ)->RDJ_PERIOD))
					::ListOfObjective[nx]:PeriodDescription		:= RDU->RDU_DESC
					::ListOfObjective[nx]:Item					:= (cAliasRDJ)->RDJ_ITEM
					::ListOfObjective[nx]:ItemDate				:= (cAliasRDJ)->RDJ_DATITM
					::ListOfObjective[nx]:InitialDate			:= (cAliasRDJ)->RDJ_DTINI
					::ListOfObjective[nx]:FinalDate				:= (cAliasRDJ)->RDJ_DTFIM
					::ListOfObjective[nx]:Relevance				:= (cAliasRDJ)->RDJ_ESCREA
					::ListOfObjective[nx]:RelevanceItem			:= (cAliasRDJ)->RDJ_ITESCR
					RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCREA+(cAliasRDJ)->RDJ_ITESCR))
					::ListOfObjective[nx]:RelevanceDescription	:= RBL->RBL_DESCRI
					::ListOfObjective[nx]:AchieveScale			:= (cAliasRDJ)->RDJ_ESCATG
					::ListOfObjective[nx]:AchieveScaleItem		:= (cAliasRDJ)->RDJ_ITESAT
					RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCATG+(cAliasRDJ)->RDJ_ITESAT))
					::ListOfObjective[nx]:AchieveScaleDescription := RBL->RBL_DESCRI
					RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCATG+(cAliasRDJ)->RDJ_ITATCN))
					::ListOfObjective[nx]:SenseScaleItem		:= (cAliasRDJ)->RDJ_ITATCN
					::ListOfObjective[nx]:SenseScaleDescription	:= RBL->RBL_DESCRI
					::ListOfObjective[nx]:Status				:= (cAliasRDJ)->RDJ_STATUS
					::ListOfObjective[nx]:StatusDescription		:= RDJStatusBox(,.T.,(cAliasRDJ)->RDJ_STATUS)
					If !Empty((cAliasRDJ)->RDJ_ESCCON)
						::ListOfObjective[nx]:KnowledgeScale	:= (cAliasRDJ)->RDJ_ESCCON
						::ListOfObjective[nx]:ActualItem		:= (cAliasRDJ)->RDJ_ITECOA
						If !Empty((cAliasRDJ)->RDJ_ITECOA)
							RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCCON+(cAliasRDJ)->RDJ_ITECOA))
							::ListOfObjective[nx]:ActualItemDescription	:= RBL->RBL_DESCRI
						EndIf
						::ListOfObjective[nx]:ProposeItem		:= (cAliasRDJ)->RDJ_ITECOP
						If !Empty((cAliasRDJ)->RDJ_ITECOP)
							RBL->(dbSeek(xFilial("RBL")+(cAliasRDJ)->RDJ_ESCCON+(cAliasRDJ)->RDJ_ITECOP))
							::ListOfObjective[nx]:ProposeItemDescription := RBL->RBL_DESCRI
						EndIf
					EndIf
					::ListOfObjective[nx]:Observation			:= Alltrim(ApdMsMm((cAliasRDJ)->RDJ_CODMEM))
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pode haver meta cadastrada, porem so exibe se o status na RDV esta liberado (1 = liberado) ³		
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
				  	RDV->(dbSeek(xFilial("RDV")+(cAliasRDJ)->RDJ_CODPAR+::ListOfObjective[nx]:ObjectiveID))
					::ListOfObjective[nx]:StatusMeta := RDV->RDV_STATUS
				EndIf
			EndIf
			nRegs ++
			If nRegs > ::PageLen .And. ::PageLen <> 0
				nPag ++
				nRegs := 0
			EndIf
		EndIf
		dbSkip()
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a lista de periodos cadastrados para o objetivo   ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
	For np := 1 To Len(::ListOfObjective)
		RDV->(dbGoTop())
		::ListOfObjective[np]:PeriodList := {}
		RDV->(dbSeek(xFilial("RDI")+::ListOfObjective[np]:EvaluatedID+::ListOfObjective[np]:ObjectiveID))
		nx := 1
		While RDV->(!EoF())
			if ::ListOfObjective[np]:ObjectiveID == RDV->RDV_CODOBJ
				RDU->(dbSeek(xFilial("RDI")+RDV->RDV_CODPER))
				nPos := aScan(::ListOfObjective[np]:PeriodList, {|x| x:PeriodId == RDU->RDU_CODIGO})
				If nPos == 0 // Verifico se o periodo ja nao foi adicionado ao objetivo
					aAdd(::ListOfObjective[np]:PeriodList,WsClassNew('Periods'))
					::ListOfObjective[np]:PeriodList[nx]:PeriodId	:= RDU->RDU_CODIGO
					::ListOfObjective[np]:PeriodList[nx]:PeriodDescription := RDU->RDU_DESC
					::ListOfObjective[np]:PeriodList[nx]:DateFrom	:= RDU->RDU_DATINI
					::ListOfObjective[np]:PeriodList[nx]:DateTo		:= RDU->RDU_DATFIM
				EndIf
				nx ++
			EndIf
			RDV->(dbskip())
		EndDo
	Next np
	dbSelectArea("RDJ")
Else
	lRetorno := .F.
	SetSoapFault("BRWTEAMOBJECTIVES",STR0024) //"Avaliador invalido"
EndIf

If !Empty(cQuery)
	dbSelectArea(cAliasRDJ)
	dbCloseArea()
EndIf
dbSelectArea("RDJ")
dbSetOrder(1)
RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SetObjective  ³ Autor ³Aline Correa do Vale³Data ³25.03.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao dos objetivos cadastrados nas ³±±
±±³          ³avaliacoes quantitativas                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do participante                                ³±±
±±³          ³ExpO3: Objeto com o Objetivo/Meta que sera incluida          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD SetObjective WSRECEIVE UserCode,ObjectiveEnter WSSEND WsNull WSSERVICE RHPerformanceEvaluate
Local aArea     := GetArea()
Local lRetorno  := .T.
Local cItem		:= If(Empty(::ObjectiveEnter:Item),StrZero(1,Len(RDJ->RDJ_ITEM)),::ObjectiveEnter:Item)
Local cStatus	:= If(Empty(::ObjectiveEnter:Status),"",::ObjectiveEnter:Status)
Local lInclui	:= .F.
Local cDuplicar := ""
Local cSeqItem	:= ""

If !Empty(::ObjectiveEnter:ObjectiveId)
	dbSelectArea("RDJ")
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se veio da opcao modificar um registro, aponta para o que deve ser alterado ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
	If (::ObjectiveEnter:Alterar == "T") 
  	  	If dbSeek(xFilial("RDJ")+Subs(::ObjectiveEnter:EvaluatedId,1,Len(RDJ->RDJ_CODPAR))+Subs(::ObjectiveEnter:ObjectiveId,1,Len(RDJ->RDJ_CODOBJ))+::ObjectiveEnter:Period+cItem+::ObjectiveEnter:SeqItem+dtos(::ObjectiveEnter:ItemDate),.T.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicio da duplicacao do item, para conferencia do avaliador                 ³		
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
  	   		If !Empty(::ObjectiveEnter:EvalChoice) 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Alteracao de item feita pelo avaliador                                      ³		
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
  	   	  	   	dbSeek(xFilial("RDJ")+Subs(::ObjectiveEnter:EvaluatedId,1,Len(RDJ->RDJ_CODPAR))+Subs(::ObjectiveEnter:ObjectiveId,1,Len(RDJ->RDJ_CODOBJ))+::ObjectiveEnter:Period+cItem+::ObjectiveEnter:SeqItem+dtos(::ObjectiveEnter:ItemDate))
  	   	  		lInclui := .F.
  	  	   	Else 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Alteracao de item feita pelo usuario                                        ³		
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
  	  		   	While !Eof() .And. (RDJ->RDJ_FILIAL == xFilial("RDJ")) .And. (RDJ->RDJ_CODPAR == ::ObjectiveEnter:EvaluatedId) .And. (RDJ->RDJ_CODOBJ == ::ObjectiveEnter:ObjectiveId) .And. (RDJ->RDJ_ITEM == cItem)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ identifico o item normal para sobrepor com a modificacao                    ³		
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
		  	   	  	If (RDJ->RDJ_STATUS == "3") .Or. (RDJ->RDJ_STATUS == "1") 
		  	   	  	  	cDuplicar := "N"
		  	   	  	 	exit
  		   	  	 	EndIf
  		   	  	 	dbSkip()
  	   	  	   	EndDo
  	   	  	   	If cDuplicar == "N"
  	   	  	   		lInclui := .F.
  	   	  	   	Else
	  	   	  	   	dbSeek(xFilial("RDJ")+Subs(::ObjectiveEnter:EvaluatedId,1,Len(RDJ->RDJ_CODPAR))+Subs(::ObjectiveEnter:ObjectiveId,1,Len(RDJ->RDJ_CODOBJ))+::ObjectiveEnter:Period+cItem+::ObjectiveEnter:SeqItem+dtos(::ObjectiveEnter:ItemDate))
  	   	  	   		cSeqItem := Soma1(RDJ->RDJ_SEQITM) // Acrescento um ao valor de sequencia do item
	  	   	  	   	lInclui := .F.
					While !Eof() .And. (RDJ->RDJ_FILIAL == xFilial("RDJ")) .And. (RDJ->RDJ_CODPAR == ::ObjectiveEnter:EvaluatedId) .And. (RDJ->RDJ_CODOBJ == ::ObjectiveEnter:ObjectiveId) .And. (RDJ->RDJ_ITEM == cItem)
   		  	  			If cItem == RDJ->RDJ_ITEM
	   		  	  		   	If lInclui == .F.
	   		  	  		   		If (RDJ->RDJ_STATUS == "2")  
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ identifico o item normal para sobrepor com a modificacao                    ³		
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ											
	  	  				  	   	  	Reclock("RDJ",.F.)
									RDJ->RDJ_STATUS := "5" //Aprovado do historico
								  	RDJ->(MsUnlock())
								  	RDJ->(FkCommit())
			  	 			  	  	lInclui := .T.
				  	   	  	 	ElseIf (RDJ->RDJ_STATUS == "4")
				  	   	  	 		Reclock("RDJ",.F.)
									RDJ->RDJ_STATUS := "6" //Cancelado do historico
								  	RDJ->(MsUnlock())
								  	RDJ->(FkCommit())
			  	 			  	  	lInclui := .T.
		  		   	  	 		EndIf
	  		   	  	 		EndIf
	  		   	  	 	EndIf
	  		   	  	 	dbSkip()
	  	   	  	   	EndDo
  	   	  	   	EndIf
  	  		EndIf  	  		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Fim da duplicacao do item                                                   ³		
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ											
	  	EndIf	  	
  	ElseIf(::ObjectiveEnter:Alterar == "F")	// Continuacao do primeiro IF, para a opcao inserir o registro
		dbSeek(xFilial("RDJ")+Subs(::ObjectiveEnter:EvaluatedId,1,Len(RDJ->RDJ_CODPAR))+Subs(::ObjectiveEnter:ObjectiveId,1,Len(RDJ->RDJ_CODOBJ))+::ObjectiveEnter:Period,.T.)
		While !Eof() .And. (RDJ->RDJ_FILIAL == xFilial("RDJ")) .And. (RDJ->RDJ_CODPAR == ::ObjectiveEnter:EvaluatedId) .And. (RDJ->RDJ_CODOBJ == ::ObjectiveEnter:ObjectiveId)
			cItem := Soma1(RDJ->RDJ_ITEM)
			dbSkip()
	   	EndDo
		cSeqItem := "01"
		cStatus	:= If(Empty(cStatus),RdjStatusInit(),cStatus)
		lInclui := .T. 		// Abre a tabela RDJ permitindo inserir o registro
	EndIf
	If lInclui == .T.
		Reclock("RDJ",.T.)	// trava a tabela no modo inserir registro
		RDJ->RDJ_SEQITM := cSeqItem
	Else
		Reclock("RDJ",.F.)	// trava a tabela sobre o registro a ser modificado
		If (!Empty(::ObjectiveEnter:StatusNew)) // Aprovacao
			RDJ->RDJ_STATUS := ::ObjectiveEnter:StatusNew
		EndIf
	EndIf
	RDJ->RDJ_FILIAL := xFilial("RDJ")
	RDJ->RDJ_CODPAR := ::ObjectiveEnter:EvaluatedID
	RDJ->RDJ_CODOBJ := ::ObjectiveEnter:ObjectiveID
	RDJ->RDJ_CODDOR := ::ObjectiveEnter:EvaluatorID
	RDJ->RDJ_DTINI  := ::ObjectiveEnter:InitialDate
	RDJ->RDJ_DTFIM  := ::ObjectiveEnter:FinalDate
	RDJ->RDJ_DATITM := If(Empty(RDJ->RDJ_DATITM),dDataBase,RDJ->RDJ_DATITM)
	If (::ObjectiveEnter:Alterar == "T") .And. (RDJ->RDJ_STATUS == "1") // Se ainda nao foi enviado para avaliacao, mantem status 1
		RDJ->RDJ_STATUS := "1"
	ElseIf Empty(::ObjectiveEnter:EvalChoice) // Caso o status seja pendente e nao modificado pelo avaliador, continua pendente
		RDJ->RDJ_STATUS := cStatus
	EndIf
	RDJ->RDJ_ESCREA := ::ObjectiveEnter:Relevance
	RDJ->RDJ_ITESCR := ::ObjectiveEnter:RelevanceItem
	RDJ->RDJ_ESCATG := ::ObjectiveEnter:AchieveScale
	RDJ->RDJ_ITESAT := ::ObjectiveEnter:AchieveScaleItem
	RDJ->RDJ_ITATCN := ::ObjectiveEnter:SenseScaleItem //item de escala do consenso
	RDJ->RDJ_PERIOD := ::ObjectiveEnter:Period
	RDJ->RDJ_ITEM   := cItem
	If !Empty(::ObjectiveEnter:KnowledgeScale)
		RDJ->RDJ_ESCCON := ::ObjectiveEnter:KnowledgeScale
		RDJ->RDJ_ITECOA := ::ObjectiveEnter:ActualItem
		RDJ->RDJ_ITECOP := ::ObjectiveEnter:ProposeItem
	EndIf
	If !Empty(::ObjectiveEnter:Observation)
   		ApdMsMm(RDJ_CODMEM,,,::ObjectiveEnter:Observation,1,,,"RDJ","RDJ_CODMEM")
  	EndIf
	RDJ->(MSUnlock())
  	RDJ->(FkCommit())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ inicia o cadastro na RDV                                                    ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ											
  	RDV->(dbSetOrder(1))
   	If RDV->(dbSeek(xFilial("RDV") + ::ObjectiveEnter:EvaluatedID,.T.))   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ caso ja exista o participante na RDV apenas modifica                        ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ											
	   	While !RDV->(Eof())
			If (RDV->RDV_FILIAL == xFilial("RDV")) .And. (RDV->RDV_CODPAR == ::ObjectiveEnter:EvaluatedID)
	  	   		Reclock("RDV",.F.)
				RDV->RDV_CODDOR := ::ObjectiveEnter:EvaluatorID
				RDV->(MSUnlock())
				RDV->(FkCommit())
			EndIf
		  	RDV->(dbSkip())
	  	EndDo
	Else 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ caso o participante nao esteja na RDV, inclui agora                         ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ												
  		Reclock("RDV",.T.)
		RDV->RDV_FILIAL := xFilial("RDV")
		RDV->RDV_CODPAR := ::ObjectiveEnter:EvaluatedID
		RDV->RDV_CODOBJ := ::ObjectiveEnter:ObjectiveID
		RDU->(dbSeek(xFilial("RDU") + ::ObjectiveEnter:Period))
		RDV->RDV_CODPER	:= RDU->RDU_CODIGO
		RDV->RDV_CODDOR := ::ObjectiveEnter:EvaluatorID
		RDV->(MSUnlock())
		RDV->(FkCommit())
  	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ fim do cadastro na RDV                                                      ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ												
Else
	lRetorno := .F.
	SetSoapFault("SETOBJECTIVE",STR0032)	//"Objetivo invalido"
EndIf

dbSelectArea("RDJ")
RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DelObjective  ³ Autor ³Aline Correa do Vale³Data ³18.05.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de exclusao dos objetivos cadastrados nas avaliacoes  ³±±
±±³          ³quantitativas                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do participante                                ³±±
±±³          ³ExpO3: Objeto com o Objetivo/Meta que sera incluida          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD DelObjective WSRECEIVE UserCode,ObjectiveEnter WSSEND WsNull WSSERVICE RHPerformanceEvaluate
Local aArea     := GetArea()
Local lRetorno  := .T.

If !Empty(::ObjectiveEnter:ObjectiveId)
	dbSelectArea("RDJ")
	dbSetOrder(1)
	If dbSeek(xFilial("RDJ")+::ObjectiveEnter:EvaluatedId+::ObjectiveEnter:ObjectiveId+::ObjectiveEnter:Period+::ObjectiveEnter:Item+::ObjectiveEnter:SeqItem+dTos(::ObjectiveEnter:ItemDate)+::ObjectiveEnter:Status) .And. RDJ_STATUS == "1" // Verifica o status do registro; permite apagar apenas registros com status "Pendente"
		Reclock("RDJ",.F.)
		ApdMsMm(RDJ_CODMEM,,,,3)
		dbDelete()
		MsUnlock()
		FkCommit()
	Else
		lRetorno := .F.
		SetSoapFault("DELOBJECTIVE",STR0037)	//"Só é permitido apagar itens Pendentes. Para outros utilize a opção Modificar"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("DELOBJECTIVE",STR0038)	//"Objetivo, meta ou plano invalido"
EndIf

dbSelectArea("RDJ")
RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwMyEvaluates³ Autor ³Aline Correa do Vale³Data ³26.02.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao das avaliacoes pendente de um          ³±±
±±³          ³participante no Browse (Minhas Avaliacoes)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do participante                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwMyEvaluates WSRECEIVE UserCode,ParticipantID,ResultType,PageLen,PageLoad,QueryAddWhere, StatusEvaluate WSSEND ListOfEvaluate WSSERVICE RHPerformanceEvaluate
Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local lQuery    	:= .F.
Local nX        	:= 0
Local cAliasRD6 	:= "RD6"
Local cParticipant 	:= SubStr(::ParticipantID,1,Len(RD9->RD9_CODADO))
Local cTipo     	:= If(Empty(::ResultType),"12",::ResultType) //1=Avaliacao, 2=Pesquisa
Local cStatus		:= If(Empty(::StatusEvaluate),"1",::StatusEvaluate)
Local lPassa 		:= .T.
Local nPos			:= 0
Local aAval			:= {"","",""}
Local cAliasRD9 	:= "RD9"
Local cDescRede		:= ""
Local cLegend		:= "1"	
Local lVerDatas		:= SuperGetMV("MV_APDVDAT", Nil, .F., )
Local lMosAvResp	:= SuperGetMV("MV_APDMAVR", Nil, .F., ) // Mostra todas as Avaliações(respondidas) na Consulta do Histórico. (Abertas e Fechadas)

DEFAULT ::PageLen 	:= 0
DEFAULT ::PageLoad	:= 0

If !cStatus $ "12"
	lRetorno := .F.
	Return(SetSoapFault("BRWMYEVALUATES",STR0025)) //"Status da Avaliacao invalido"
EndIf

If !Empty(cParticipant)

	dbSelectArea("RD6")
	dbSetOrder(1)
	dbSelectArea("RD9")
	dbSetOrder(2)
	dbSelectArea("RD9")
	dbSetOrder(2)
	dbSeek(xFilial("RD9")+cParticipant)
	dbSelectArea(cAliasRD6)

	::ListOfEvaluate := {}
	While 	!Eof() .And.;
			xFilial("RD9") 	== (cAliasRD9)->RD9_FILIAL .And.;
			cParticipant 	== (cAliasRD9)->RD9_CODADO
		dbSelectArea("RD6")
		dbSetOrder(1)

		If dbSeek(xFilial("RD6")+(cAliasRD9)->RD9_CODAVA) .And. RD6->RD6_AUTOAV == "1" .And. (RD6->RD6_STATUS == cStatus .Or. (cStatus == "2" .And. lMosAvResp))
			RDA->(dbSetOrder(1)) //PERMITE CONSULTA DE CONSENSO
			If RDA->(dbSeek(xFilial("RDA")+RD9->(RD9_CODAVA+RD9_CODADO+RD9_CODPRO)))//+RD9_CODADO)+dTos(RD9->RD9_DTIAVA)))
				While	!RDA->(EOF()) .And.;
 						xFilial("RDA") 	== RDA->RDA_FILIAL .And.;
						RD9->RD9_CODAVA == RDA->RDA_CODAVA .And.;
						RD9->RD9_CODADO == RDA->RDA_CODADO .And.;
						RD9->RD9_CODPRO == RDA->RDA_CODPRO

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ NAO PODE SER AVALIACAO DO AVALIADOR                                         ³		
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ												
					If RDA->RDA_TIPOAV != "1" .And. RD9->RD9_DTIAVA == RDA->RDA_DTIAVA
						RD5->(dbSetOrder(1))
						RD5->(dbSeek(xFilial("RD5")+(cAliasRD6)->RD6_CODTIP))
						RDH->(dbSetOrder(1)) //RDH_FILIAL+RDH_CODTIP+RDH_CODNET+RDH_AUTOAV
						RDH->(dbSeek(xFilial("RDH")+(cAliasRD6)->RD6_CODTIP))
						RDK->(dbSetOrder(1))
						RDK->(dbSeek(xFilial("RDK")+(cAliasRD6)->RD6_CODVIS))
						RD3->(dbSetOrder(1))
						RD3->(dbSeek(xFilial("RD3")+(cAliasRD6)->RD6_CODMOD))
						RDM->(dbSetOrder(1))
						RDM->(dbSeek(xFilial("RDM")+(cAliasRD6)->RD6_CODCOM))
						RD0->(dbSetOrder(1))
						RD0->(dbSeek(xFilial("RD0")+(cAliasRD9)->RD9_CODADO))
						RDC->(dbSetOrder(1))
						RDC->(dbSeek(xFilial("RDC")+(cAliasRD9)->RD9_CODAVA+cParticipant+RDA->RDA_CODPRO+RDA->RDA_CODDOR+dToS(RDA->RDA_DTIAVA)+RDA->RDA_CODNET+RDA->RDA_NIVEL+RDA->RDA_TIPOAV))
						RDB->(dbSetOrder(6))
						RDB->(DBSeek(xFilial("RDB")+RDA->RDA_CODPRO+(cAliasRD9)->RD9_CODAVA+cParticipant+RDA->RDA_CODDOR+dToS(RDA->RDA_DTIAVA)+RDA->RDA_TIPOAV))
						RDP->(dbSetOrder(1))
						RDP->(dbSeek(xFilial("RDP")+RDA->RDA_CODAVA+dTos(RDA->RDA_DTIAVA)))
						RD1->(dbSeek(xFilial("RD1")+RDA->RDA_CODNET))
	
						If RDA->RDA_TIPOAV = "2" .And. RD9->RD9_DTIAVA == RDA->RDA_DTIAVA
							cDescRede	:=RD1->RD1_DESC
						EndIf
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ PRIMEIRO VERIFICA SE FOI ENCONTRADO REGISTRO NA TABELA RDA                                  ³		
						//³ DEPOIS VERIFICA SE AVALIADO E AVALIADOR SAO O MESMO                                         ³
						//³ Para estar disponivel a auto-avaliacao e' necessario que o avaliado e avaliador sejam iguais³
						//³ Tipo = '1' == Avaliacao                                                                     ³					
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ												
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ EMPTY(RDC_DATRET) = AVALIACAO NAO FINALIZADA (RDC_TIPO(3) FOI TROCADO PELO DATRET)   |
						//| !EMPTY(RDC_DATRET) = AVALIACAO FINALIZADA (RDC_TIPO(1 e 2) FOI TROCADO PELO DATRET)  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			  			IF RD5->RD5_TIPO == cTipo .And.;
				  			;//Se parametro ativo, verifica se a database eh maior que data inicial de respostas da avaliacao
			  				( ( !lVerDatas .Or. lVerDatas .And. Date() >= RDP->RDP_INIRSP ) .And. 	RDA->RDA_CODDOR == RDA->RDA_CODADO )
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ VERIFICA SE E CONSULTA                                                               |
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lPassa := .F.
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Pendencia                                                                            |
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If cStatus  == "1"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Se parametro inativo e nao respondido ou parametro ativo e data menor ou igual ao limite e nao respondido |
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
								If ( !lVerDatas .And. Empty( RDC->RDC_DATRET ) ) .Or. ( lVerDatas  .And. Date() <= RDP->RDP_RSPADO .And. Empty( RDC->RDC_DATRET ) )
							    	lPassa 	:= .T.
							    	cLegend	:= "1"
								EndIf
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Consulta; se parametro inativo e respondido ou parametro ativo e data maior ao limite ou respondido       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							ElseIf cStatus == "2" .And. ( !lVerDatas .And. !Empty( RDC->RDC_DATRET ) ) .Or. ( lVerDatas  .And. ( Date() > RDP->RDP_RSPADO .Or. !Empty( RDC->RDC_DATRET ) ) )
								lPassa 	:= .T.
								cLegend	:= "2"
	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ VERIFICA SE AVALIACAO ATUAL E DE CONSENSO                                                                 ³
								//³ SE FOR BUSCA POR AUTO AVALIACAO / SE ACHAR APAGA /                                                        ³							
								//³ SENAO NAO DEIXA GRAVAR NO ARRAY                                                                           ³							
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
								If RDA->RDA_TIPOAV == "3"
	
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ VERIFICA SE EXISTE AVALIACAO QUE NAO SEJA DE CONSENSO JA GRAVADA                                          ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ									
									nPos := ascan(::ListOfEvaluate, {|x| x:EvaluateId == (cAliasRD6)->RD6_CODIGO .And. x:EvaluatedName == AllTrim(RD0->RD0_NOME) .And. x:InitialDate == RDA->RDA_DTIAVA  })
									If nPos > 0
										aDel(::ListOfEvaluate, nPos) //APAGA REGISTRO DO ARRAY
										aSize(::ListOfEvaluate, len(::ListOfEvaluate)-1) //REDIMENSIONA
									Else
										aAval[1] := (cAliasRD6)->RD6_CODIGO
										aAval[2] := AllTrim(RD0->RD0_NOME)
										aAval[3] := RDA->RDA_DTIAVA
									EndIf
								ElseIf(cAliasRD6)->RD6_CODIGO == aAval[1] .And. AllTrim(RD0->RD0_NOME) == aAval[2] .And. RDA->RDA_DTIAVA == aAval[3]
									lPassa := .F.
								EndIf
							EndIf
	
							If lPassa == .T.
	
								aAdd(::ListOfEvaluate,WsClassNew('EvaluateList'))
								nX := Len(::ListOfEvaluate)
	
								::ListOfEvaluate[nX]:EvaluateId				:= (cAliasRD6)->RD6_CODIGO
								::ListOfEvaluate[nX]:EvaluatedName			:= AllTrim(RD0->RD0_NOME)
								::ListOfEvaluate[nX]:InitialDate			:= RDA->RDA_DTIAVA
								::ListOfEvaluate[nX]:FinalDate				:= RDA->RDA_DTFAVA
								::ListOfEvaluate[nX]:AnswerFinalDate		:= If(RDA->RDA_TIPOAV=="2",RDP->RDP_RSPADO,If(RDA->RDA_TIPOAV=="1",RDP->RDP_RSPDOR,RDP->RDP_RSPCON))
								::ListOfEvaluate[nX]:Description			:= (cAliasRD6)->RD6_DESC
								::ListOfEvaluate[nX]:EvaluateType			:= (cAliasRD6)->RD6_CODTIP
								::ListOfEvaluate[nX]:Net					:= RDA->RDA_CODNET
								::ListOfEvaluate[nX]:Project				:= RDA->RDA_CODPRO
								::ListOfEvaluate[nX]:ProjectDescription		:= AllTrim(FDesc("RDN", RDA->RDA_CODPRO, "RDN_DESC",,,1))
								::ListOfEvaluate[nX]:TypeDescription		:= RD5->RD5_DESC
								::ListOfEvaluate[nX]:Vision					:= (cAliasRD6)->RD6_CODVIS
								::ListOfEvaluate[nX]:VisionDescription		:= RDK->RDK_DESC
								::ListOfEvaluate[nX]:Model			 		:= (cAliasRD6)->RD6_CODMOD
								::ListOfEvaluate[nX]:ModelDescription		:= Alltrim(ApdMsMm( RD3->RD3_CODMEM,,,,,,,"RD3" ))
								::ListOfEvaluate[nX]:Competence				:= (cAliasRD6)->RD6_CODCOM
								::ListOfEvaluate[nX]:CompetenceDescription	:= RDM->RDM_DESC
								::ListOfEvaluate[nX]:NetDescription 		:= If(!Empty(cDescRede),cDescRede,RD1->RD1_DESC)
								::ListOfEvaluate[nX]:Reply					:= "1"
								
								If RD6->(ColumnPos("RD6_CONREP")) > 0
									::ListOfEvaluate[nX]:Reply				:= RD6->RD6_CONREP
								EndIf

								If RDC->RDC_TIPO $("456")
									::ListOfEvaluate[nX]:EvaluateStatus	:= RDC->RDC_TIPO
	
									If RDC->RDC_TIPO == "4"
										::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0039	//"Não finalizado pelo avaliador"
									ElseIf 	RDC->RDC_TIPO == "5"
										::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0040	//"Não finalizado pelo avaliado"
									Else
										::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0041	//"Não iniciado"
									EndIf
	
								Else
									::ListOfEvaluate[nX]:EvaluateStatus				:= cLegend
									::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= OpBxStatus( .F., .T., (cAliasRD6)->RD6_STATUS )
								EndIf
	
								::ListOfEvaluate[nX]:SelfEvaluate  					:= RDA->RDA_TIPOAV
								::ListOfEvaluate[nX]:SelfEvaluateDescription   		:= OpBxTipoAv( .F., .T., RDA->RDA_TIPOAV )
								::ListOfEvaluate[nX]:EvaluatorId					:= RDA->RDA_CODDOR
								::ListOfEvaluate[nX]:TypeEv							:= RD5->RD5_TIPO
							EndIf
						EndIf
	           		EndIf
	
	            	lPassa := .T.
	            	RDA->(dbSkip())
				EndDo
		    EndIf
		EndIf
	
		dbSelectArea(cAliasRD9)
		dbSkip()
	EndDo

	If lQuery
		dbSelectArea(cAliasRD6)
		dbCloseArea()
		dbSelectArea("RD6")
	EndIf
	
	nX := 0
Else
	lRetorno := .F.
	SetSoapFault("BRWMYEVALUATES",STR0023) //"Participante invalido"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwMyEvaluated³ Autor ³Aline Correa do Vale³Data ³26.02.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao das avaliacoes pendentes de meus       ³±±
±±³          ³avaliados no Browse (Meus Avaliados)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do avaliador                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwMyEvaluated WSRECEIVE UserCode,EvaluatorID,ResultType,QueryAddWhere, StatusEvaluate, NetLevel WSSEND ListOfEvaluate WSSERVICE RHPerformanceEvaluate
Local aArea     	:= GetArea()
Local aRDCArea	:= GetArea()
Local lRetorno  	:= .T.
Local lQuery    	:= .F.
Local lOk 			:= .F.
Local lFinaliza 	:= .F.
Local cAvaliado	:= ""
Local cAutoAvaliado := ""
Local cCodAvaliado 	:= ""
Local cAvaliacao	:= ""
Local cAliasRD6 	:= "RD6"
Local cEvaluator 	:= SubStr(::EvaluatorID,1,Len(RDA->RDA_CODDOR))
Local cTipo     	:= If( Empty(::ResultType),"12",::ResultType ) //1=Avaliacao, 2=Pesquisa, 3=Projeto
Local cStatus		:= If( Empty(::StatusEvaluate),"1",::StatusEvaluate ) //1=pendencias, 2=ja confirmadas(consulta)
Local cNivel		:= If( Empty(::NetLevel), "3", ::NetLevel ) //1=mesmo nivel, 2=nivel acima, 3=nivel abaixo
Local nPos 		:= 0
Local nPos1		:= 0
Local nJ 			:= 0
Local nX        	:= 0
Local aAval		:= {"","",""}
Local cAliasRDA 	:= "RDA"
Local cLegend		:= "1"
Local dRspAdo  	:= Ctod("")
Local dDatePend	:= Date()
Local dRspDor  	:= Date()   
Local lRSPDOR		:= .T.
Local lRSPADO		:= .T.
Local cConLib		:= "2"
Local lVerDatas	:= SuperGetMV("MV_APDVDAT", Nil, .F., )

If !cStatus $ "12"
	lRetorno := .F.
	Return(SetSoapFault("BRWMYEVALUATES",STR0025)) //"Status da Avaliacao invalido")
EndIf

If !Empty(cEvaluator)
	dbSelectArea("RD6")
	dbSetOrder(1)
	dbSelectArea("RDA")
	dbSetOrder(9)

	dbSeek(xFilial("RDA")+cEvaluator)

	RDB->(dbSetOrder(6))
	RDC->(dbSetOrder(1))
	RD5->(dbSetOrder(1))
	RDK->(dbSetOrder(1))
	RD3->(dbSetOrder(1))
	RDM->(dbSetOrder(1))
	RDP->(dbSetOrder(1))
	RD0->(dbSetOrder(1))

	dbSelectArea(cAliasRDA)

	::ListOfEvaluate := {}
	While	!Eof() .And.;
			xFilial("RDA") == (cAliasRDA)->RDA_FILIAL .And.;
			cEvaluator == (cAliasRDA)->RDA_CODDOR
		dbSelectArea("RD6")
		If dbSeek(xFilial("RD6")+(cAliasRDA)->RDA_CODAVA)
			RD5->(dbSeek(xFilial("RD5")+(cAliasRD6)->RD6_CODTIP))
			RDK->(dbSeek(xFilial("RDK")+(cAliasRD6)->RD6_CODVIS))
			RD3->(dbSeek(xFilial("RD3")+(cAliasRD6)->RD6_CODMOD))
			RDM->(dbSeek(xFilial("RDM")+(cAliasRD6)->RD6_CODCOM))
			RD0->(dbSeek(xFilial("RD0")+(cAliasRDA)->RDA_CODADO))
			RDP->(dbSeek(xFilial("RDP")+(cAliasRDA)->RDA_CODAVA+DTOS((cAliasRDA)->RDA_DTIAVA)))
			RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODDOR+dToS((cAliasRDA)->RDA_DTIAVA)+(cAliasRDA)->(RDA_CODNET+RDA_NIVEL+RDA_TIPOAV)))
			RDB->(dbSeek(xFilial("RDB")+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODDOR+dToS((cAliasRDA)->RDA_DTIAVA)+(cAliasRDA)->RDA_TIPOAV))
			RD1->(dbSeek(xFilial("RD1")+(cAliasRDA)->RDA_CODNET))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Obtem a data de resposta do avaliado                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dRspAdo := RDC->RDC_DATRET
			lRspADO := .T.

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CONSULTA DEPENDE DO STATUS, SE cSTATUS = 1 CONSULTA AVALIACOES PENDENTES 										³
			//³ SE cSTATUS = 2 CONSULTA AVALIACOES JA REALIZADAS																³
			//³ CONSULTA NIVEL APENAS QUANDO FOR AVALIACAO (CTIPO = 1)															³
			//³ .And. ( (cAliasRDA)->RDA_TIPOAV <> "3" .Or. (dDataBase > RDP->RDP_RSPADO .And. dDataBase > RDP->RDP_RSPDOR) )	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ EMPTY(RDC_DATRET) = AVALIACAO NAO FINALIZADA (RDC_TIPO(3) FOI TROCADO PELO DATRET)   ³
			//³ !EMPTY(RDC_DATRET) = AVALIACAO FINALIZADA (RDC_TIPO(1 e 2) FOI TROCADO PELO DATRET)  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ SE cTipo = 2 (PESQUISA), VERIFICAR STATUS DE FINALIZADA APENAS PELO RDC_DATRET,			 ³
			//³ PORQUE PESQUISA PODE SER NAO IDENTIFICADA, PORTANTO REGISTRO NAO SERA ENCONTRADO NA RDB  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If RD6->(ColumnPos("RD6_CONLIB")) > 0
				cConLib := (cAliasRD6)->RD6_CONLIB
			EndIf

			If RD5->RD5_TIPO $ cTipo .And.;
				;//Se parametro ativo, verifica se a database eh maior que data inicial de respostas da avaliacao
				( ( lVerDatas .And. Date() >= RDP->RDP_INIRSP ) .Or. !lVerDatas  .Or. ( cConLib =="1" .And. Date() >= RDP->RDP_INIRSP ) ) .And. ;
				IIF( cTipo $ "1-3",((cAliasRDA)->RDA_NIVEL == cNivel .And. (cAliasRDA)->RDA_CODADO != (cAliasRDA)->RDA_CODDOR),(cAliasRDA)->RDA_NIVEL $ "123" )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ PARA VERIFICAR SE SUBORDINADO JÁ SE AUTO-AVALIOU E JÁ FOI AVALIADO                       ³
				//³ ANTES DE MOSTRAR A AVALIACAO DO CONSENSO                                                 ³
				//³ SE FOR CONSULTA DE AVALIACAO, MOSTRAR CONSENSO DE QUALQUER MANEIRA                       ³			
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lOk := .F.
				nPos := 0

				If cStatus == "1" .And. (cAliasRD6)->RD6_STATUS == "1"//SE FOR PENDENCIA/INCLUSAO DE DADOS DA AVALIACAO
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Consenso; se parametro inativo e nao respondido ou parametro ativo e data menor ou igual ao limite e nao respondido ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If RD6->(ColumnPos("RD6_CONLIB")) > 0
						cConLib := (cAliasRD6)->RD6_CONLIB
					EndIf

					If (cAliasRDA)->RDA_TIPOAV == "3" .And.;
					 	( ( !lVerDatas .And. Empty( RDC->RDC_DATRET ) ) .Or.;
						( lVerDatas .And. Date() <= RDP->RDP_RSPCON .And. Empty( RDC->RDC_DATRET ) ) .Or.;
						( cConLib == "1" .And. Date() <= RDP->RDP_RSPCON .And. Empty( RDC->RDC_DATRET ) ))
						
						lOk 	:= .T.					
						cLegend	:= "1"	
						

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ VERIFICA SE SUBORDINADO SE AUTO-AVALIOU                                                                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODADO+dToS((cAliasRDA)->RDA_DTIAVA))) //+(cAliasRDA)->(RDA_CODNET)+(cAliasRDA)->(RDA_NIVEL)))
							cAutoAvaliado := RDC->RDC_DATRET //RDC->RDC_TIPO
						EndIf
						nPos := ascan(::ListOfEvaluate, {|x| x:EvaluateID == (cAliasRDA)->RDA_CODAVA .And. x:SelfEvaluate == "1" .And. x:EvaluatedId == (cAliasRDA)->RDA_CODADO .And. x:FinalDate == (cAliasRDA)->RDA_DTFAVA })
						
						//-- Procura pelo retorno da avaliacao do avaliador
						lRspDOR := .F.
						If RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODDOR+dToS((cAliasRDA)->RDA_DTIAVA)+(cAliasRDA)->(RDA_CODNET+RDA_NIVEL+"1"))) //--Tipo Avaliador
							lRspDOR:= !EMPTY(RDC->RDC_DATRET) //Se o avaliador respondeu a RDC->RDC_TIPO
						EndIf
						
						If (nPos > 0 .Or. Empty(cAutoAvaliado) ) //cAutoAvaliado != "3"
							lOk := .F.
						EndIf
						
						If lRspDOR .and. RD6->(ColumnPos("RD6_CONLIB")) > 0 .and. (cAliasRD6)->RD6_CONLIB == "1" 
						 	lOk := .T.
						EndIf
						

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Avaliador; se parametro inativo e nao respondido ou parametro ativo e data menor ou igual ao limite e nao respondido³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf (cAliasRDA)->RDA_TIPOAV == "1" .And. ( ( !lVerDatas .And. Empty( RDC->RDC_DATRET ) ) .Or. ( lVerDatas .And. Date() <= RDP->RDP_RSPDOR .And. Empty( RDC->RDC_DATRET ) ) )
						lOk := .T.

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ VERIFICA SE CONSENSO FOI GRAVADO ANTES DA AVALIACAO COMO AVALIADOR                                                  ³
						//³ PEGA A POSICAO DO MESMO E GRAVA AVALIACAO POR CIMA                                                                  ³					
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nPos := ascan(::ListOfEvaluate, {|x| x:EvaluateID == (cAliasRDA)->RDA_CODAVA .And. x:SelfEvaluate == "3" .And. x:EvaluatedId == (cAliasRDA)->RDA_CODADO .And. x:FinalDate == (cAliasRDA)->RDA_DTFAVA })
						If nPos > 0
							aDel(::ListOfEvaluate, nPos) //APAGA REGISTRO DO ARRAY
							aSize(::ListOfEvaluate, len(::ListOfEvaluate)-1) //REDIMENSIONA
						EndIf
					ElseIf (cAliasRDA)->RDA_TIPOAV == "2" .And. ( ( !lVerDatas .And. Empty( RDC->RDC_DATRET ) ) .Or. ( lVerDatas .And. Date() <= RDP->RDP_RSPDOR .And. Empty( RDC->RDC_DATRET ) ) )
                    	lOk := .T.
                    Endif	

				ElseIf cStatus == "2"	//CONSULTA
					cLegend	:= "2"

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ VERIFICA SE AVALIACAO ATUAL E DE CONSENSO                                                                           ³
					//³ SE FOR BUSCA POR AUTO AVALIACAO / SE ACHAR APAGA /                                                                  ³					
					//³ SENAO NAO DEIXA GRAVAR NO ARRAY                                                                                     ³
					//³ Consenso; se parametro inativo e respondido ou parametro ativo e data maior ao limite ou respondido                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If RD6->(ColumnPos("RD6_CONLIB")) > 0
						cConLib := RD6->RD6_CONLIB
					EndIf

					If RDA->RDA_TIPOAV == "3" .And. ( ( !lVerDatas .And. !Empty( RDC->RDC_DATRET ) ) .Or.;
					 	( lVerDatas .And. ( Date() > RDP->RDP_RSPCON .Or. !Empty( RDC->RDC_DATRET ) ) ) .Or.;
					 	(  Date() > RDP->RDP_RSPCON .And. cConLib == "1" ) )
						lOk := .T.
						//VERIFICA SE EXISTE AVALIACAO QUE NAO SEJA DE CONSENSO JA GRAVADA
						nPos1 := ascan(::ListOfEvaluate, {|x| x:EvaluateId == (cAliasRDA)->RDA_CODAVA .And. x:EvaluatedId == (cAliasRDA)->RDA_CODADO .And. x:FinalDate == (cAliasRDA)->RDA_DTFAVA })
						If !Empty(RDC->RDC_DATRET) .And. nPos1 > 0
							aDel(::ListOfEvaluate, nPos1) //APAGA REGISTRO DO ARRAY
							aSize(::ListOfEvaluate, len(::ListOfEvaluate)-1) //REDIMENSIONA
						Else
							aAval[1] := (cAliasRDA)->RDA_CODAVA
							aAval[2] := (cAliasRDA)->RDA_CODADO
							aAval[3] := (cAliasRDA)->RDA_DTIAVA
						EndIf
					//Avaliador; se parametro inativo e respondido ou parametro ativo e data maior ao limite ou respondido					
					ElseIf RDA->RDA_TIPOAV == "1" .And. ( ( !lVerDatas .And. !Empty( RDC->RDC_DATRET ) ) .Or. ( lVerDatas .And. ( Date() > RDP->RDP_RSPDOR .Or. !Empty( RDC->RDC_DATRET ) ) ) )
						lOk := .T.
					ElseIf (cAliasRDA)->RDA_CODAVA == aAval[1] .And. (cAliasRDA)->RDA_CODADO == aAval[2] .And. (cAliasRDA)->RDA_DTIAVA == aAval[3]
						lOk := .F.
					EndIf
				EndIf
                
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envio Simultaneo de Avaliacao: "2-Nao".                 ³ 
				//³ Envio ao Avaliador somente apos Avaliado ter respondido ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lOk .And. cTipo == "1" //Somente Avaliacao 
					If RD6->RD6_SIMULT == "2"  
										   
						//-- Solicitada Avaliacao Pendente
						If cStatus 	='1'
							//O tipo de avaliacao eh de avaliador						
							If ((cAliasRDA)->RDA_TIPOAV=="1") 
								//-- Procura pela Auto avaliacao se houver
								//lRspADO := .F.
								If RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODADO+dToS((cAliasRDA)->RDA_DTIAVA)))	
									lRspADO := !Empty(RDC->RDC_DATRET) //Se o avaliado respondeu a RDC->RDC_TIPO
								EndIf
								//disponibilizar a avaliacao de avaliador.
								lOk := lRspADO 	  
						   	//O tipo de avaliacao eh de consenso
						   	ElseIf ((cAliasRDA)->RDA_TIPOAV=="3") 
								//-- Procura pelo retorno da avaliacao do avaliador
								lRspDOR := .F.
								If RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODDOR+dToS((cAliasRDA)->RDA_DTIAVA)+(cAliasRDA)->(RDA_CODNET+RDA_NIVEL+"1"))) //--Tipo Avaliador
									lRspDOR:= !EMPTY(RDC->RDC_DATRET) //Se o avaliador respondeu a RDC->RDC_TIPO
								EndIf
								//-- Procura pela Auto avaliacao se houver
								lRspADO	:= .F.
								If RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODADO+dToS((cAliasRDA)->RDA_DTIAVA)))	
									lRspADO := !Empty(RDC->RDC_DATRET) //Se o avaliado respondeu a RDC->RDC_TIPO
								EndIf

								//disponibilizar a avaliacao de consenso.
								If RD6->(ColumnPos("RD6_CONLIB")) > 0 .and. (cAliasRD6)->RD6_CONLIB != "1" 
									lOk := (lRspDOR .And. lRspADO)
								Else
									lOk := (lRspDOR)
								EndIf	
							 Endif
						
						//-- Solicitado Historico de Avaliacao
						Else
							//-- Procura pelo retorno da avaliacao do avaliador
							lRspDOR := .F.
							If RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODDOR+dToS((cAliasRDA)->RDA_DTIAVA)+(cAliasRDA)->(RDA_CODNET+RDA_NIVEL+"1"))) //--Tipo Avaliador
								lRspDOR:= !EMPTY(RDC->RDC_DATRET) //Se o avaliador respondeu a RDC->RDC_TIPO
							EndIf
							lOk:= !Empty(dRspAdo)
						Endif
					EndIf
				EndIf
				/*
					Ponto de entrada para validação do usuário da avaliação posicionada.
				*/
				If lOk 
					If ExistBlock("WSAP10CONS")
						aRDCArea:= GetArea()
						lOk := ExecBlock("WSAP10CONS", .F., .F., {RDC->RDC_FILIAL, RDC->RDC_ID, RDC->RDC_CODAVA})
						RestArea(aRDCArea)
					EndIf
				EndIF                              

				If lOk
					//USADO PARA GRAVAR POR CIMA DO REGISTRO DE CONSENSO
				 	aAdd(::ListOfEvaluate,WsClassNew('EvaluateList'))
					nX := len(::ListOfEvaluate)

					//VERIFICA SE SUBORDINADO SE AUTO-AVALIOU
					If RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODADO+dToS((cAliasRDA)->RDA_DTIAVA))) //+(cAliasRDA)->(RDA_CODNET)+(cAliasRDA)->(RDA_NIVEL)))
					    ::ListOfEvaluate[nX]:AutoEvaluated := IIf(!Empty(RDC->RDC_DATRET),STR0045,STR0046) //"SIM"###"NAO"
			    	Else
						::ListOfEvaluate[nX]:AutoEvaluated := STR0046 //"NAO"
					EndIf
					//Re-posiciona no registro
					RDC->(dbSeek(xFilial("RDC")+(cAliasRDA)->RDA_CODAVA+(cAliasRDA)->RDA_CODADO+(cAliasRDA)->RDA_CODPRO+(cAliasRDA)->RDA_CODDOR+dToS((cAliasRDA)->RDA_DTIAVA)+(cAliasRDA)->(RDA_CODNET+RDA_NIVEL+RDA_TIPOAV)))

					::ListOfEvaluate[nX]:EvaluateId				:= (cAliasRDA)->RDA_CODAVA
					if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
						::ListOfEvaluate[nX]:EvaluatedName		:= AllTrim(SRA->RA_NOMECMP)
					Else
						::ListOfEvaluate[nX]:EvaluatedName		:= RD0->RD0_NOME
					EndIf
					::ListOfEvaluate[nX]:EvaluatorId			:= (cAliasRDA)->RDA_CODDOR
					::ListOfEvaluate[nX]:EvaluatorName			:= AllTrim(FDesc("RD0", (cAliasRDA)->RDA_CODDOR, "RD0_NOME",,,1))
					::ListOfEvaluate[nX]:InitialDate			:= (cAliasRDA)->RDA_DTIAVA//(cAliasRD6)->RD6_DTINI
					::ListOfEvaluate[nX]:FinalDate				:= (cAliasRDA)->RDA_DTFAVA//(cAliasRD6)->RD6_DTFIM
					::ListOfEvaluate[nX]:AnswerFinalDate		:= IIf((cAliasRDA)->RDA_TIPOAV=="2",RDP->RDP_RSPADO,IIf((cAliasRDA)->RDA_TIPOAV=="1",RDP->RDP_RSPDOR,RDP->RDP_RSPCON))
					::ListOfEvaluate[nX]:Description			:= (cAliasRD6)->RD6_DESC
					::ListOfEvaluate[nX]:Net					:= (cAliasRDA)->RDA_CODNET
					::ListOfEvaluate[nX]:Project				:= (cAliasRDA)->RDA_CODPRO
					::ListOfEvaluate[nX]:ProjectDescription		:= AllTrim(FDesc("RDN", (cAliasRDA)->RDA_CODPRO, "RDN_DESC",,,1))
					::ListOfEvaluate[nX]:EvaluateType			:= (cAliasRD6)->RD6_CODTIP
					::ListOfEvaluate[nX]:TypeDescription		:= RD5->RD5_DESC
					::ListOfEvaluate[nX]:EvaluatedId			:= (cAliasRDA)->RDA_CODADO
					::ListOfEvaluate[nX]:Vision					:= (cAliasRD6)->RD6_CODVIS
					::ListOfEvaluate[nX]:VisionDescription		:= RDK->RDK_DESC
					::ListOfEvaluate[nX]:Model					:= (cAliasRD6)->RD6_CODMOD
					::ListOfEvaluate[nX]:ModelDescription		:= Alltrim(ApdMsMm( RD3->RD3_CODMEM,,,,,,,"RD3" ))
					::ListOfEvaluate[nX]:Competence				:= (cAliasRD6)->RD6_CODCOM
					::ListOfEvaluate[nX]:CompetenceDescription	:= RDM->RDM_DESC
					::ListOfEvaluate[nX]:NetDescription			:= RD1->RD1_DESC
					::ListOfEvaluate[nX]:Reply					:= "1"
					
					If RD6->(ColumnPos("RD6_CONREP")) > 0
						::ListOfEvaluate[nX]:Reply				:= RD6->RD6_CONREP
					EndIf

		   			If RDC->RDC_TIPO $("456") //Microsiga
						::ListOfEvaluate[nX]:EvaluateStatus	:= RDC->RDC_TIPO

						If RDC->RDC_TIPO == "4"
							::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0039	//"Não finalizado pelo avaliador"

						ElseIf RDC->RDC_TIPO == "5"
							::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0040	//"Não finalizado pelo avaliado"

						Else
							::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0041	//"Não iniciado"
						EndIf

					Else
						::ListOfEvaluate[nX]:EvaluateStatus				:= cLegend
						::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= OpBxStatus( .F., .T., (cAliasRD6)->RD6_STATUS )
					EndIf

					::ListOfEvaluate[nX]:SelfEvaluate  				:= (cAliasRDA)->RDA_TIPOAV
					::ListOfEvaluate[nX]:SelfEvaluateDescription	:= OpBxTipoAv( .F., .T., (cAliasRDA)->RDA_TIPOAV )
					::ListOfEvaluate[nX]:TypeEv						:= RD5->RD5_TIPO
				EndIf
            EndIf
		EndIf

		dbSelectArea(cAliasRDA)
		dbSkip()
	EndDo


	If lQuery
		dbSelectArea(cAliasRD6)
		dbCloseArea()
		dbSelectArea("RD6")
	EndIf
	nX := 0

	If cTipo == "3"
    	Asort(::ListOfEvaluate,,, {|x,y| x:DESCRIPTION + x:Project + DTOS(x:InitialDate) + x:EvaluatedId < y:DESCRIPTION  + y:Project + DTOS(y:InitialDate) + y:EvaluatedId })
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("BRWMYEVALUATED",STR0024)	//"Avaliador invalido"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwEvaluate   ³ Autor ³Juliana B Mariano   ³Data ³04.10.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de Consulta de todas as avaliacoes de um avaliado     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do avaliado                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Dados das avaliacoes que o participante esta sendo    ³±±
±±³		     |       avaliado											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwEvaluate WSRECEIVE UserCode,EvaluatedID WSSEND EvaluateEvaluated WSSERVICE RHPerformanceEvaluate
Local aArea     := GetArea()
Local lRetorno  := .T.
Local lQuery    := .F.
Local nX        := 0
Local lEntrou	:= .F.
Local cNomeAvaliado := ""
Local nPos		:= 0

Local cAliasRD9 := "RD9"

If !Empty(::EvaluatedID)

	dbSelectArea("RD9")
	dbSetOrder(2)

	dbSeek(xFilial("RD9")+::EvaluatedID)

	dbSelectArea(cAliasRD9)

	::EvaluateEvaluated := {}

	While !Eof() .And. xFilial("RD9") 	== (cAliasRD9)->RD9_FILIAL;
				 .And. ::EvaluatedID 	== (cAliasRD9)->RD9_CODADO

		RDP->(dbSetOrder(1))
		RDP->(dbSeek(xFilial("RDP")+(cAliasRD9)->RD9_CODAVA))

		//VERIFICA SE DATA DA AGENDA ESTA DENTRO DA DATA ATUAL
		While !RDP->( Eof() ) .And. (cAliasRD9)->RD9_CODAVA == RDP->RDP_CODAVA
			lEntrou := .F.

			If date() > RDP->RDP_DATINI .And. date() < RDP->RDP_DATFIM

			 	//FAZ CONSULTA PARA VERIFICAR SE PARTICIPANTE TEM ALGUM AVALIADOR NESTA AVALIACAO
			 	RDA->( dbSetOrder(1) ) //FILIAL+AVALIACAO+AVALIADO+ETC
			 	RDA->( dbSeek(xFilial("RDA")+RDP->RDP_CODAVA+::EvaluatedID) )

			    While !RDA->( Eof() ) .And. RDA->RDA_FILIAL == xFilial("RDA");
			    					  .And. RDA->RDA_CODAVA == RDP->RDP_CODAVA ;
			    					  .And. RDA->RDA_CODADO == ::EvaluatedID

					//VERIFICAR SE ESTE DADO JA FOI GRAVADO NO ARRAY
					nPos := 0
					If len(::EvaluateEvaluated) > 0
						nPos := ascan(::EvaluateEvaluated, {|x| x:EvaluateId == RDA->RDA_CODAVA .And. x:SelfEvaluate == RDA->RDA_TIPOAV })
					EndIf

			    	RD5->( dbSetOrder(1) )
			    	RD5->( dbSeek(xFilial("RD5")+RDA->RDA_CODTIP) )
			    	//RD5_TIPO = 1 AVALIACAO / 2 = PESQUISA / 3 = Projeto
			    	//SO PODE APARECER AVALIACAO NA PESQUISA
			    	If RD5->RD5_FILIAL == xFilial("RD5") .And. RD5->RD5_CODTIP == RDA->RDA_CODTIP ;
			    		.And. RD5->RD5_TIPO == "1" .And. nPos == 0

						//CONSULTA FEITA PARA PEGAR A DESCRICAO DA AVALIACAO
						RD6->( dbSetOrder(1) )
						RD6->( dbSeek(xFilial("RD6")+RDP->RDP_CODAVA) )

						//CONSULTA FEITA PARA O NOME DO AVALIADO
						RD0->( dbSetOrder(1) )
						If RD0->( dbSeek(xFilial("RD0")+::EvaluatedID,.T.) )
							cNomeAvaliado := RD0->RD0_NOME
						EndIf

				 		aadd(::EvaluateEvaluated,WsClassNew('EvaluatedEvaluate'))
						nX++

						::EvaluateEvaluated[nX]:EvaluateId			:= RDP->RDP_CODAVA
						::EvaluateEvaluated[nX]:EvaluateDescription	:= RD6->RD6_DESC
						::EvaluateEvaluated[nX]:EvaluatedId			:= ::EvaluatedID
						::EvaluateEvaluated[nX]:EvaluatedDescription:= cNomeAvaliado
						::EvaluateEvaluated[nX]:InitialDate			:= RDP->RDP_DATINI
						::EvaluateEvaluated[nX]:FinalDate			:= RDP->RDP_DATFIM
						::EvaluateEvaluated[nX]:Level				:= RDA->RDA_NIVEL
						::EvaluateEvaluated[nX]:Net					:= RDA->RDA_CODNET
						::EvaluateEvaluated[nX]:SelfEvaluate		:= RDA->RDA_TIPOAV
						::EvaluateEvaluated[nX]:EvaluateType		:= RDA->RDA_CODTIP

						lEntrou := .T.
					EndIf
					RDA->( dbSkip() )
				EndDo

			EndIf

			//SE JA FOI FEITA A CONSULTA PARA 1 DATA NAO PRECISA MAIS CONSULTAR AS DATAS
			If lEntrou == .T.
				Exit
			EndIf
			RDP->(DbSkip())
		EndDo


		dbSelectArea(cAliasRD9)
		dbSkip()
	EndDo

	If lQuery
		dbSelectArea(cAliasRD9)
		dbCloseArea()
		dbSelectArea("RD9")
	EndIf
	nX := 0
Else
	lRetorno := .F.
	SetSoapFault("BRWEVALUATE",STR0026) //"Avaliado invalido"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutPEvaluate ³Autor  ³Aline Correa do Vale³ Data ³12.03.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo inclusao de respostas da avaliacoes de 1 participante ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpO2: Objeto com a avaliacao respondida                     ³±±
±±³          ³ExpL3: Indica se finaliza a avaliacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: E-mail do avaliado							           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao das avaliacoes de um participante      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutPEvaluate WSRECEIVE UserCode,Evaluate,Questions,TypeEval WSSEND EvaluatedMail WSSERVICE RHPerformanceEvaluate
Local aArea		:= GetArea()
Local aAreaRD0	:= GetArea()
Local cCodTip   := ""
Local cKey		:= ""
Local cMailAuth	:= ""
Local cMailTo	:= ""
Local cMensagem := ""
Local cRdcId	:= "" //chave primaria do RDC
Local cTipoAv	:= ""
Local nRecno	:= 0
Local lMailAuth := SuperGetMv("MV_RELAUTH")
Local lAutentic	:= .T.
Local lRetorno  := .T.
Local lReplicar	:= .F.
Local lFeedBck	:= .F.
Local lAutoAvl	:= .F.
Local lSSL		:= SuperGetMv("MV_RELSSL")
Local lTLS		:= SuperGetMv("MV_RELTLS")
Local nAt		:= 0
Local nc		:= 0
Local nz		:= 0
Local nX		:= 0
Local nLoop		:= 0
Local cRespostas := ""
Local lFrist 	:= .F.
Local cJustificativa := ""

DEFAULT ::Questions := .F. //finalizar pois todas as questoes foram respondidas.
DEFAULT ::TypeEval := ""

If !Empty(::Evaluate:EvaluateID) .And. !Empty(::Evaluate:EvaluatedID) .And. Len(::Evaluate:ListofCompetence) > 0
	
	dbSelectArea("RDH")
	dbSetOrder(1)
	RDH->(dbSeek(xFilial("RDH")+::Evaluate:EvaluateType+::Evaluate:Net+::Evaluate:Level))
	dbSelectArea("RDP")
	dbSetOrder(1)
	dbSelectArea("RDB")
	dbSetOrder(1)
	dbSelectArea("RD6")
	dbSetOrder(1)
	RD6->(dbSeek(xFilial("RD6") + ::Evaluate:EvaluateID + ::Evaluate:EvaluateType + ::Evaluate:Model + ::Evaluate:Competence))
	dbSelectArea("RD5")
	dbSetOrder(1)
	RD5->(dbSeek(xFilial("RD5") + RD6->RD6_CODTIP))
	dbSelectArea("RDC")
	
	If RDH->RDH_AUTOAV == "2"
		lAutoAvl	:= .T.
	EndIf
	
	If RDH->RDH_FEEDBK == "1"
		lFeedBck	:= .T.
	EndIf
	
	If RD6->(ColumnPos("RD6_CONREP")) > 0 .and. Val(RD6->RD6_CONREP) > 1
		lReplicar	:= .T.
	EndIf

	//*****************************************************************
	//RETORNA O E-MAIL DO AVALIADO
	//*****************************************************************
	dbSelectArea("RD0")
	RD0->( dbSetOrder(1) )	//RD0_FILIAL+RD0_CODIGO
	If RD0->( dbSeek(xFilial("RD0") + ::Evaluate:EvaluatedID))
		::EvaluatedMail := RD0->RD0_EMAIL
	EndIf
	//*****************************************************************

	If RDP->(dbSeek(xFilial("RDP")+::Evaluate:EvaluateId+dTos(::Evaluate:InitialDate)))
		If RDP->RDP_STATUS < "5"
			RDP->(Reclock("RDP",.f.))
			RDP->RDP_STATUS := "5"
			RDP->(MsUnlock())
			RDP->(FkCommit())
		EndIf
	EndIf

	RDC->( dbSetOrder(1) )

	If RDC->( dbSeek(xFilial("RDC") + ::Evaluate:EvaluateId + ::Evaluate:EvaluatedId + ::Evaluate:Project + ::Evaluate:EvaluatorId + dTos(::Evaluate:InitialDate) + ::Evaluate:Net + ::Evaluate:Level + ::Evaluate:SelfEvaluate))
		RDC->(RecLock("RDC",.F.))
		cRdcId := RDC->RDC_ID

		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ RDC_DATRET PREENCHIDA INDICA QUE AVALIACAO FOI FINALIZADA   |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		If ::Questions
			RDC->RDC_DATRET := dDataBase
			//INCLUSAO DE PONTO DE ENTRADA NA FINALIZACAO DA AVALIACAO
			If ExistBlock("APDFINAVAL")
				ExecBlock("APDFINAVAL")  
			EndIf
		EndIf

		nRecno := RDC->( Recno() )
		cCodTip := RDC->RDC_CODTIP

		RDC->( MsUnLock() )
		RDC->(FkCommit())
	Else
		lRetorno := .F.
		SetSoapFault("PUTPEVALUATE",STR0027) //"Não encontrado arquivo na tabela de Envio de Avaliações!"
	EndIf

	dbSelectArea("RDB")
	dbSetOrder(15) // G = RDB_FILIAL + RDB_ID + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_CODALT

	For nc:=1 to Len(::Evaluate:ListofCompetence)
		For nz:=1 to Len(::Evaluate:ListofCompetence[nc]:ListOfQuestion)
		
			lFrist := .T.
			
			If ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:ObjectType == "1"
				nLoop := Len(::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:AlternativeChoice)
				For nX := 1 To nLoop
					cRespostas += ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:AlternativeChoice[nX]:Alternativa + "/"
				Next
				
				If RDB->(dbSeek(xFilial("RDB") + cRdcId + ::Evaluate:Competence + ::Evaluate:ListOfCompetence[nc]:CompetenceItem + ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:QuestionID))
					While RDB->(::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:QuestionID == RDB_CODQUE) .And. RDB->RDB_TIPOAV == ::Evaluate:SelfEvaluate
						If ! RDB->RDB_CODALT $ cRespostas
							RDB->( RecLock( "RDB", .F. ) )
								RDB->(dbDelete())
							RDB->(MsUnlock())
						EndIf
						RDB->(dbSkip())
					EndDo
				EndIf
			Else
				nLoop := 1
			EndIf
			
			For nX := 1 To nLoop
				//MUDAR CONSULTA NO RDB UTILIZANDO CHAVE NOVA cRdcId COM INDICE NOVO
				
				If ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:ObjectType == "1"
					If RDB->(dbSeek(xFilial("RDB") + cRdcId + ::Evaluate:Competence + ::Evaluate:ListOfCompetence[nc]:CompetenceItem + ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:QuestionID + ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:AlternativeChoice[nX]:Alternativa))
						RDB->( RecLock( "RDB", .F. ) )
					Else
						RDB->( RecLock( "RDB", .T. ) )
					EndIf
				Else
					If RDB->(dbSeek(xFilial("RDB") + cRdcId + ::Evaluate:Competence + ::Evaluate:ListOfCompetence[nc]:CompetenceItem + ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:QuestionID))
						RDB->( RecLock( "RDB", .F. ) )
					Else
						RDB->( RecLock( "RDB", .T. ) )
					EndIf
				EndIf
				
				RDB->RDB_FILIAL := xFilial("RDB")
				If !RDB->(Found())
					RDB->RDB_ID		:= cRdcId //CODIGO QUE VEM DO RDC CHAVE PRIMARIA
				EndIf
				RDB->RDB_CODAVA := ::Evaluate:EvaluateId   
				RDB->RDB_CODADO := ::Evaluate:EvaluatedID
				RDB->RDB_CODPRO := ::Evaluate:Project
				If RD5->RD5_TIPO == '2' .And. RD5->RD5_IDENTI == '2' //Pesquisa nao identificada
					RDB->RDB_CODDOR := ""
				Else
					RDB->RDB_CODDOR := ::Evaluate:EvaluatorID
				EndIf
				RDB->RDB_CODNET	:= ::Evaluate:Net				//Codigo da Rede
				RDB->RDB_DTIAVA := ::Evaluate:InitialDate
				RDB->RDB_DTFAVA := ::Evaluate:FinalDate
				RDB->RDB_CODMOD := ::Evaluate:Model
				RDB->RDB_CODCOM := ::Evaluate:Competence
				RDB->RDB_TIPOAV := ::Evaluate:SelfEvaluate //1=Avaliador 2=Auto 3=Consenso
				RDB->RDB_ITECOM := ::Evaluate:ListOfCompetence[nc]:CompetenceItem	//Item de Competencia
				RDB->RDB_ESCALA := ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:Scale //Relevancia da questao (escala)
				RDB->RDB_ITEESC := ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:ScaleItem //Relevancia da questao (item da escala)
				RDB->RDB_CODQUE := ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:QuestionID //Codigo da Questao
				RDB->RDB_CODTIP := cCodTip
				If ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:ObjectType == "3" //dissertativa
					ApdMsMm(RDB_CODMEM, , , ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:AnswerDescription, 1, , , "RDB", "RDB_CODMEM")
				Else
					RDB->RDB_CODALT := ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:AlternativeChoice[nX]:Alternativa //Resposta
					If ! Empty(self:Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:Justification)
						If lFrist
							ApdMsMm(RDB_CODJUS, , , ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:Justification, 1, , , "RDB", "RDB_CODJUS")	//Justificativa
							lFrist := .F.
							cJustificativa := RDB->RDB_CODJUS
						Else
							RDB->RDB_CODJUS := cJustificativa
						EndIf
					EndIf
				EndIf
				cTipoAv	:= ::Evaluate:SelfEvaluate
				RDB->( MsUnlock() )
				RDB->(FkCommit())
	
				If ::TypeEval == "3" .AND. (::Evaluate:EvaluatorID == ::Evaluate:EvaluatedID) .And. ::Questions .And. ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:Edit == "1" //Avaliado
	
					cChave := xFilial("RDB") + ::Evaluate:EvaluateId + ::Evaluate:EvaluatedID + ::Evaluate:Project
					RDB->( dbSetOrder(1) )
					If RDB->(dbSeek(cChave))
						While RDB->( ! Eof() ) .And. cChave == RDB->RDB_FILIAL + RDB->RDB_CODAVA + RDB->RDB_CODADO + RDB->RDB_CODPRO
	
							If 	::Evaluate:EvaluatedID != RDB->RDB_CODDOR .And.;
								::Evaluate:InitialDate 	== RDB->RDB_DTIAVA .And.;
								::Evaluate:Competence 	== RDB->RDB_CODCOM .And.;
								::Evaluate:ListOfCompetence[nc]:CompetenceItem == RDB->RDB_ITECOM .And.;
								::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:QuestionID == RDB->RDB_CODQUE .And.;
								"1" == RDB->RDB_TIPOAV
	
								RDB->( RecLock( "RDB", .F. ) )
	
								If ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:ObjectType == "3"		//dissertativa
									ApdMsMm(RDB_CODMEM,,,::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:AnswerDescription,1,,,"RDB","RDB_CODMEM")
								Else
									RDB->RDB_CODALT := ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:AlternativeChoice[nX]:Alternativa		//Resposta
									If ! Empty(self:Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:Justification)
										If lFrist
											ApdMsMm(RDB_CODJUS, , , ::Evaluate:ListOfCompetence[nc]:ListOfQuestion[nz]:Justification, 1, , , "RDB", "RDB_CODJUS")	//Justificativa
											lFrist := .F.
											cJustificativa := RDB->RDB_CODJUS
										Else
											RDB->RDB_CODJUS := cJustificativa
										EndIf
									EndIf
								EndIf
	
								RDB->(MsUnlock())
								RDB->(FkCommit())
	
								Exit	//Apos Gravar deve sair para buscar outra questao
							EndIf
							RDB->( dbSkip() )
						EndDo
					EndIf
				EndIf
				dbSelectArea("RDB")
				dbSetOrder(15) // G = RDB_FILIAL + RDB_ID + RDB_CODCOM + RDB_ITECOM + RDB_CODQUE + RDB_CODALT
			Next
		Next
	Next

	If ::TypeEval == "3".AND. (::Evaluate:EvaluatorID<>::Evaluate:EvaluatedID) .And. ::Questions
		//Setar registro do RDA
		dbselectArea("RDC")
		cKey := RDC_CODAVA + RDC_CODADO + RDC_CODPRO + RDC_CODDOR + DTOS(RDC_DTIAVA) + RDC_CODNET + RDC_NIVEL + RDC_TIPOAV

		dbselectArea("RDA")
		dbSetOrder(RetOrdem("RDA","RDA_FILIAL+RDA_CODAVA+RDA_CODADO+RDA_CODPRO+RDA_CODDOR+DTOS(RDA_DTIAVA)+RDA_CODNET+RDA_NIVEL+RDA_TIPOAV"))
		dbSeek(xFilial("RDA")+cKey)
		nRecno := RDA->( Recno() )
		CriaAvaliacao(nRecno)
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("PUTPEVALUATE",STR0028) //"Avaliacao invalida!"
EndIf
If lRetorno .And. (::Evaluate:EvaluatorID<>::Evaluate:EvaluatedID) .And. ::TypeEval == "1" .and.;
	lReplicar .And. lFeedBck .And. lAutoAvl .And. cTipoAv == "1" 
	CPYAVA(::Evaluate:EvaluateId,::Evaluate:EvaluatedID,::Evaluate:EvaluatorID)
Endif
If lRetorno
	If RD6->RD6_MENSAG == "S" .And. ::Questions

		//CONSULTA E-MAIL CADASTRADO
		If !Empty(AllTrim(GetMV("MV_RHCONTA"))) .And. !Empty(AllTrim(GetMV("MV_RHSENHA"))) .And. !Empty(AllTrim(GetMV("MV_RHSERV")))
		   cMailConta := AllTrim(GetMV("MV_RHCONTA"))
		   cMailSenha := AllTrim(GetMV("MV_RHSENHA"))
		   cMailServer:= AllTrim(GetMV("MV_RHSERV"))
		Else
		   cMailConta := AllTrim(GetMV("MV_EMCONTA"))
		   cMailSenha := AllTrim(GetMV("MV_EMSENHA"))
		   cMailServer:= AllTrim(GetMV("MV_RELSERV"))							
		EndIf

		If ( nAt := At(":", cMailServer) ) > 0
			cMailServer := Substr(cMailServer, 1, nAt - 1)
		Endif

		//-- Conecta no servidor
		If lSSL .And. lTLS	
			CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk TLS SSL
		ElseIf lSSL
			CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk SSL
		ElseIf lTLS
			CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk TLS
		Else
			CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
		EndIf
		
		//-- Faz autenticacao no servidor
		If lOk .And. lMailAuth
			lAutentic:= MailAuth(cMailConta, cMailSenha)
			If !lAutentic
				If ( nAt := At("@", cMailConta) ) > 0
					cMailAuth	:= Substr(cMailConta, 1, nAt - 1)
					lAutentic	:= MailAuth(cMailAuth, cMailSenha)
				Endif					
			EndIf
		EndIf

		//-- Envia email
		If lOk .and. lAutentic

			cBody := "<html><style type='text/css'><!-- .texto {font-family: Arial, Helvetica, sans-serif;font-size: 12px;"
			cBody += "color: #333333;text-decoration: none;font-weight: normal;}"
			cBody += ".titulo {	font-family: Arial, Helvetica, sans-serif;font-size: 16px;"
			cBody += "color: #19167D;text-decoration: none;font-weight: bold;} --> </style><body>"
			cBody += "<table width='550' border='0' cellpadding='0' cellspacing='0'><tr>"
			cBody += "<td height='263' align='left' valign='top' class='texto'><p class='titulo'><strong><font size='4'>"
			cBody += "Avaliação Disponível para Consulta"
			cBody += "</font></strong></p>"
			cBody += "<table  width='550' border='1' cellpadding='2' cellspacing='2' bordercolor='#D2DCDF'>"
	   		cBody += "<tr bordercolor='#D2DCDF' bgcolor='F2F3F5'>"
	        cBody += "<td><span class='texto'>"
	        
	        
			aAreaRD0 := GetArea()
			dbSelectArea("RD0")
			RD0->( dbSetOrder(1) )	//RD0_FILIAL+RD0_CODIGO
	        //-- Mensagem para avaliacao de avaliador
	        If ::Evaluate:SelfEvaluate == '1'
				If RD0->( dbSeek(xFilial("RD0")+::Evaluate:EvaluatorID) )
					cMailTo := RD0->RD0_EMAIL
				EndIf
				cMensagem  := ApdMsMm( Fdesc("RDG",RD6->RD6_MAVAL,"RDG_CODMEM") )
	        	cMensagem  := If( Empty(cMensagem), OemtoAnsi(STR0049), cMensagem )
	        	cBody += "<strong>" + cMensagem + "</strong><br>"
	        //-- Mensagem para auto-avaliacao
	        ElseIf ::Evaluate:SelfEvaluate == '2'
				If RD0->( dbSeek(xFilial("RD0")+::Evaluate:EvaluatedID) )
					cMailTo := RD0->RD0_EMAIL
				EndIf
	   			cMensagem  := ApdMsMm( Fdesc("RDG",RD6->RD6_MAUTO,"RDG_CODMEM") )
	        	cMensagem  := If( Empty(cMensagem), OemtoAnsi(STR0049), cMensagem )
	        	cBody += "<strong>" + cMensagem + "</strong><br>"        
	        //-- Mensagem para consenso
	        ElseIf ::Evaluate:SelfEvaluate == '3'
				If RD0->( dbSeek(xFilial("RD0")+::Evaluate:EvaluatorID) )
					cMailTo := RD0->RD0_EMAIL
				EndIf
				cMensagem  := ApdMsMm( Fdesc("RDG",RD6->RD6_MCONS,"RDG_CODMEM") )
	        	cMensagem  := If( Empty(cMensagem), OemtoAnsi(STR0049), cMensagem )
	        	cBody += "<strong>" + cMensagem + "</strong><br>"        
	        EndIf
              	RestArea(aAreaRD0)
			cBody += "</span></td>" 
	   		cBody += "</tr></table></td></tr></table></body></html>"
			
			If !Empty(AllTrim(GetMV("MV_APDASSM")))
				SEND MAIL FROM cMailConta; 
				TO cMailTo;
				SUBJECT AllTrim(GetMV("MV_APDASSM"));
				BODY  cBody;
				RESULT lOk   
			Else
				SEND MAIL FROM cMailConta; 
				TO cMailTo;
				SUBJECT "Avaliação de Performance";
				BODY  cBody;
				RESULT lOk   
			EndIf			
			If !lOk
				GET MAIL ERROR cErro
				cMsg := cErro
				conout('cMsg: ',cMsg)
			EndIf
			
			DISCONNECT SMTP SERVER RESULT lOK
			
			If !lOk
				GET MAIL ERROR cErro
				cMsg := cErro
				conout('cMsg: ',cMsg)
			EndIf
		Else
			GET MAIL ERROR cErro
			cMsg := cErro
			conout('cMsg: ',cMsg)
		EndIf
	EndIf
    EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetConsensus ³Autor  ³Aline Correa do Vale³Data  ³26.02.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo de inclusao de consenso de avaliado / avaliador       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Participante                                ³±±
±±³          ³ExpC3: Codigo do Avaliador                                   ³±±
±±³          ³ExpC4: Codigo da Avaliacao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao das avaliacoes de um participante      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD SetConsensus WSRECEIVE UserCode,ParticipantID,EvaluatorID,PEvaluateID,QueryAddWhere WSSEND ListOfEvaluate WSSERVICE RHPerformanceEvaluate
Local aArea       := GetArea()
Local lRetorno    := .T.
Local lQuery      := .F.
Local nY          := 0
Local nZ          := 0
Local cAliasRD6   := "RD6"
Local cParticipant:= SubStr(::ParticipantID,1,Len(RD9->RD9_CODADO))
Local cEvaluator  := SubStr(::EvaluatorID,1,Len(RDA->RDA_CODDOR))
Local cEvaluateID := SubStr(::PEvaluateID,1,Len(RD9->RD9_CODAVA))

If !Empty(cParticipant) .Or. Empty(cEvaluator)
	dbSelectArea("RD6")
	dbSetOrder(1)
	dbSeek(xFilial("RD6")+cEvaluateID)
	RD8->(dbSeek(xFilial("RD8")+RD6->RD6_CODMOD))
	dbSelectArea("RDA")
	dbSetOrder(3)
	dbSeek(xFilial("RDA")+cEvaluator+Dtos(RD6->RD6_DTINI)+cParticipant+RD6->RD6_CODIGO)

	dbSelectArea("RDC")
	dbSetOrder(1)
	//procurando resposta do avaliador
	If !dbSeek(xFilial("RDC")+cEvaluateId+cParticipant+RDA->RDA_CODPRO+cEvaluatorId+dTos(RD6->RD6_DTINI)+RDA->RDA_CODNET) .Or.;
		Empty(RDC->RDC_DATRET) //.Or. RDC->RDC_TIPO <> "3"
		lRetorno := .F.
	EndIf

	//procurando resposta do avaliado (auto-avaliacao)
	If	!dbSeek(xFilial("RDC")+cEvaluateId+cParticipant+RDA->RDA_CODPRO+cParticipant+dTos(RD6->RD6_DTINI)+RDA->RDA_CODNET)  .Or.;
		Empty(RDC->RDC_DATRET) //.Or. RDC->RDC_TIPO <> "3"
		lRetorno := .F.
	EndIf

	RDB->(dbSetOrder(1))
	If lRetorno .And. RDB->(dbSeek(xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cParticipant + dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RDA->RDA_CODNET)) ;
	.And. RDB->(dbSeek(xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cEvaluator + dToS(RD6->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RDA->RDA_CODNET))
		dbSelectArea("RD9")
		dbSetOrder(1)
		RDB->(dbSetOrder(1))
		RD5->(dbSetOrder(1))
		RDK->(dbSetOrder(1))
		RD3->(dbSetOrder(1))
		RD2->(dbSetOrder(1))
		RDM->(dbSetOrder(1))
		RDO->(dbSetOrder(1))
		RD0->(dbSetOrder(1))
		RD7->(dbSetOrder(1))
		RD8->(dbSetOrder(2))
		SQP->(dbSetOrder(1))
		SQO->(dbSetOrder(1))
		RBL->(dbSetOrder(1))
		RD0->(dbSeek(xFilial("RD0")+cParticipant))
		RD5->(dbSeek(xFilial("RD5")+(cAliasRD6)->RD6_CODTIP))
		RDK->(dbSeek(xFilial("RDK")+(cAliasRD6)->RD6_CODVIS))
		RD3->(dbSeek(xFilial("RD3")+(cAliasRD6)->RD6_CODMOD))
		RDM->(dbSeek(xFilial("RDM")+(cAliasRD6)->RD6_CODCOM))
		dbSelectArea(cAliasRD6)

		::ListOfEvaluate := {}
		aadd(::ListOfEvaluate,WsClassNew('EvaluateList'))

		::ListOfEvaluate[1]:EvaluateId		:= (cAliasRD6)->RD6_CODIGO
		if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
			::ListOfEvaluate[1]:EvaluatedName	:= AllTrim(SRA->RA_NOMECMP)
		Else
			::ListOfEvaluate[1]:EvaluatedName	:= RD0->RD0_NOME
		EndIf
		::ListOfEvaluate[1]:InitialDate					:= (cAliasRD6)->RD6_DTINI
		::ListOfEvaluate[1]:FinalDate					:= (cAliasRD6)->RD6_DTFIM
		::ListOfEvaluate[1]:Description					:= (cAliasRD6)->RD6_DESC
		::ListOfEvaluate[1]:EvaluateType				:= (cAliasRD6)->RD6_CODTIP
		::ListOfEvaluate[1]:TypeDescription				:= RD5->RD5_DESC
		::ListOfEvaluate[1]:EvaluatedId					:= cParticipant
		::ListOfEvaluate[1]:Vision						:= (cAliasRD6)->RD6_CODVIS
		::ListOfEvaluate[1]:VisionDescription			:= RDK->RDK_DESC
		::ListOfEvaluate[1]:Model						:= (cAliasRD6)->RD6_CODMOD
		::ListOfEvaluate[1]:ModelDescription			:= RD3->RD3_DESC
		::ListOfEvaluate[1]:Competence					:= (cAliasRD6)->RD6_CODCOM
		::ListOfEvaluate[1]:CompetenceDescription		:= RDM->RDM_DESC
		::ListOfEvaluate[1]:EvaluateStatus				:= (cAliasRD6)->RD6_STATUS
		::ListOfEvaluate[1]:EvaluateStatusDescription	:= OpBxStatus( .F., .T., (cAliasRD6)->RD6_STATUS )
		::ListOfEvaluate[1]:SelfEvaluate				:= (cAliasRD6)->RD6_AUTOAV
		::ListOfEvaluate[1]:SelfEvaluateDescription 	:= OpBxSimNao( .F., .T., (cAliasRD6)->RD6_AUTOAV )
		::ListOfEvaluate[1]:Reply						:= "1"
		
		If RD6->(ColumnPos("RD6_CONREP")) > 0
			::ListOfEvaluate[1]:Reply		:= RD6->RD6_CONREP
		EndIf

		// Posiciona no RD7 para carregar as Definicoes da Avaliacao
		RD7->(dbSeek(xFilial("RD7")+RD6->RD6_CODIGO))
		//Posiciona no RD3 para Obter o Modelo de Avaliacao
		If RD3->(dbSeek(xFilial("RD3")+RD6->RD6_CODMOD))
			//Posiciona no RD8 para Obter as Questoes a serem enviadas
			RD8->(dbSeek(xFilial("RD8")+RD3->RD3_CODIGO))
		EndIf
		dbSelectArea("RD8")

		::ListOfEvaluate[1]:ListOfCompetence := {}
		nc := 0

		While !RD8->(Eof()) .And. xFilial("RD8")  == RD8->RD8_FILIAL ;
							.And. RD6->RD6_CODMOD == RD8->RD8_CODMOD
			nc ++
			aadd(::ListOfEvaluate[1]:ListOfCompetence,WsClassNew('Competences'))
			RDO->(dbSeek(xFilial("RDO")+RD8->(RD8_CODMOD+RD8_CODCOM+RD8_ITECOM)))
			RD2->(dbSeek(xFilial("RD2")+RD8->(RD8_CODCOM+RD8_ITECOM)))
			RBL->(dbSeek(xFilial("RBL") + RDO->(RDO_ESCALA+RDO_ITEESC)))
			::ListOfEvaluate[1]:ListOfCompetence[nc]:CompetenceItem := RDO->(RDO_ITECOM)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:CompetenceItemDescription := RD2->(RD2_DESC)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:DescCompetenceItem			:= If(Empty(RD2->(RD2_CODMEM)), "", ApdMsMm(RD2->(RD2_CODMEM), 80))
			::ListOfEvaluate[1]:ListOfCompetence[nc]:Value      := RDO->(RDO_ESCALA)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:ValueItem  := RDO->(RDO_ITEESC)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:ValueItemDescription  := RBL->(RBL_DESCRI)

			::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion := {}
            nY := 0
			cWhile := RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM
			While !RD8->(Eof()) .And. RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM ==;
					cWhile
				nY ++

				aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion,WsClassNew('Questions'))
				::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:QuestionID := RD8->(RD8_CODQUE)

				If SQO->(dbSeek(xFilial("SQO")+RD8->RD8_CODQUE))

					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Question   := SQO->(QO_QUEST)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Points     := SQO->(QO_PONTOS)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ObjectType := SQO->(QO_TIPOOBJ)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:DescQuestion   := If(Empty(SQO->(QO_CODMEM)), "", APDMSMM(SQO->(QO_CODMEM), 80))

					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Scale    	:= RD8->(RD8_ESCALA)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem 	:= RD8->(RD8_ITEESC)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Edit   		:= RD8->(RD8_EDITA)

					RBL->(dbSeek(xFilial("RBL") + RD8->(RD8_ESCALA+RD8_ITEESC)))
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItemDescription := RBL->(RBL_DESCRI)
					// resposta do avaliado (auto-avaliacao)
					If RDB->(dbSeek(xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cParticipant + dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RDA->RDA_CODNET + RD8->RD8_CODQUE))
						::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
						::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Justification     := Alltrim(ApdMsMm(RDB->RDB_CODJUS))
						cQuestao := RD8->RD8_CODQUE
						While RD8->RD8_CODQUE == cQuestao
							Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice, WsClassNew('Respostas'))
							nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice)
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice[nPos]:Alternativa := RDB->RDB_CODALT
							Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice, RDB->RDB_CODALT)
							RD8->(dbSkip())
						EndDo
					EndIf

					// resposta do avaliador
					If RDB->(dbSeek(xFilial("RDB") + RD6->RD6_CODIGO + cParticipant + RDA->RDA_CODPRO + cEvaluator + dToS(RDA->RDA_DTIAVA) + RD8->RD8_CODCOM + RD8->RD8_ITECOM + RDA->RDA_CODNET + RD8->RD8_CODQUE))
						::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorAnswer := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
						cQuestao := RD8->RD8_CODQUE
						While RD8->RD8_CODQUE == cQuestao
							Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice, WsClassNew('Respostas'))
							nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice)
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice[nPos]:Alternativa := RDB->RDB_CODALT
							Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:EvaluatorChoice, RDB->RDB_CODALT)
							RD8->(dbSkip())
						EndDo
					EndIf

					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative := {}

					nZ := 1
					If Empty(SQO->QO_ESCALA)
						SQP->(dbSeek(xFilial("SQP") + RD8->RD8_CODQUE))
						While !(SQP->(Eof())) .And. SQP->QP_FILIAL+SQP->QP_QUESTAO==xFilial("SQP")+RD8->RD8_CODQUE
							If SQO->QO_TIPOOBJ != "3" //Dissertativa
								aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListofAlternative,WsClassNew('Alternatives'))

								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:AlternativeID:= SQP->QP_ALTERNA
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Alternative  := SQP->QP_DESCRIC
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Percentage   := SQP->QP_PERCENT
								nZ ++
							EndIf
							SQP->(dbSkip())
						EndDo
					Else
						RBL->(dbSeek(xFilial("RBL") + SQO->QO_ESCALA))
						While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+SQO->QO_ESCALA
							aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative,WsClassNew('Alternatives'))
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:AlternativeID:= RBL->RBL_ITEM
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Alternative  := RBL->RBL_DESCRI
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Percentage   := RBL->RBL_VALOR
							nZ ++
							RBL->(dbSkip())
						EndDo
					EndIf
				EndIf
				RD8->(dbSkip())
			EndDo
			If nY == 0
				RD8->(dbSkip())
			EndIf
		EndDo

		If lQuery
			dbSelectArea(cAliasRD6)
			dbCloseArea()
			dbSelectArea("RD6")
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("SETCONSENSUS",STR0029) //"Resposta do avaliado ou avaliador nao encontrada"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("SETCONSENSUS",STR0030) //"Avaliado ou Avaliador invalido"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetPEvaluator³Autor  ³Aline Correa do Vale³Data  ³26.02.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo de inclusao de resposta do avaliador vendo o avaliado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Participante                                ³±±
±±³          ³ExpC3: Codigo do Avaliador                                   ³±±
±±³          ³ExpC4: Codigo da Avaliacao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao das avaliacoes de um participante      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetPEvaluator WSRECEIVE UserCode,ParticipantID,EvaluatorID,PEvaluateID,QueryAddWhere WSSEND ListOfEvaluate WSSERVICE RHPerformanceEvaluate
Local aArea       := GetArea()
Local lRetorno    := .T.
Local lQuery      := .F.
Local nY          := 0
Local nZ          := 0
Local cAliasRD6   := "RD6"
Local cParticipant:= SubStr(::ParticipantID,1,Len(RD9->RD9_CODADO))
Local cEvaluator  := SubStr(::EvaluatorID,1,Len(RDA->RDA_CODDOR))
Local cEvaluateID := SubStr(::PEvaluateID,1,Len(RD9->RD9_CODAVA))

If !Empty(cParticipant) .Or. Empty(cEvaluator)
	dbSelectArea("RD6")
	dbSetOrder(1)
	dbSeek(xFilial("RD6")+cEvaluateID)
	RD8->(dbSeek(xFilial("RD8")+RD6->RD6_CODMOD))
	dbSelectArea("RDA")
	dbSetOrder(3)
	dbSeek(xFilial("RDA")+cEvaluator+Dtos(RD6->RD6_DTINI)+cParticipant+RD6->RD6_CODIGO)

	dbSelectArea("RDC")
	dbSetOrder(1)
	If !dbSeek(xFilial("RDC")+cEvaluateId+cParticipant+RDA->RDA_CODPRO+cParticipant+dTos(RD6->RD6_DTINI)+RDA->RDA_CODNET) .Or.;
		Empty(RDC->RDC_DATRET) //.Or. RDC->RDC_TIPO <> "3"
		lRetorno := .F.
	EndIf

	RDB->(dbSetOrder(1))   
	
	If lRetorno .And. (RD6->RD6_SIMULT == "1" .Or. RDB->(dbSeek(xFilial("RDB")+RD6->RD6_CODIGO+cParticipant+RDA->RDA_CODPRO+cParticipant+dToS(RDA->RDA_DTIAVA)+RD8->RD8_CODCOM+RD8->RD8_ITECOM+RDA->RDA_CODNET))) 
		dbSelectArea("RD9")
		dbSetOrder(1)
		dbSeek(xFilial("RD6")+::PEvaluateID)
		RDB->(dbSetOrder(1))
		RD5->(dbSetOrder(1))
		RDK->(dbSetOrder(1))
		RD3->(dbSetOrder(1))
		RD2->(dbSetOrder(1))
		RDM->(dbSetOrder(1))
		RDO->(dbSetOrder(1))
		RD0->(dbSetOrder(1))
		RD7->(dbSetOrder(1))
		RD8->(dbSetOrder(2))
		SQP->(dbSetOrder(1))
		SQO->(dbSetOrder(1))
		RBL->(dbSetOrder(1))
		RD0->(dbSeek(xFilial("RD0")+cParticipant))
		RD5->(dbSeek(xFilial("RD5")+(cAliasRD6)->RD6_CODTIP))
		RDK->(dbSeek(xFilial("RDK")+(cAliasRD6)->RD6_CODVIS))
		RD3->(dbSeek(xFilial("RD3")+(cAliasRD6)->RD6_CODMOD))
		RDM->(dbSeek(xFilial("RDM")+(cAliasRD6)->RD6_CODCOM))
		dbSelectArea(cAliasRD6)

		::ListOfEvaluate := {}
		aadd(::ListOfEvaluate,WsClassNew('EvaluateList'))

		::ListOfEvaluate[1]:EvaluateId		:= (cAliasRD6)->RD6_CODIGO
		if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
			::ListOfEvaluate[1]:EvaluatedName	:= AllTrim(SRA->RA_NOMECMP)
		Else
			::ListOfEvaluate[1]:EvaluatedName	:= RD0->RD0_NOME
		EndIf
		::ListOfEvaluate[1]:InitialDate		:= (cAliasRD6)->RD6_DTINI
		::ListOfEvaluate[1]:FinalDate		:= (cAliasRD6)->RD6_DTFIM
		::ListOfEvaluate[1]:Description		:= (cAliasRD6)->RD6_DESC
		::ListOfEvaluate[1]:EvaluateType	:= (cAliasRD6)->RD6_CODTIP
		::ListOfEvaluate[1]:TypeDescription:= RD5->RD5_DESC
		::ListOfEvaluate[1]:EvaluatedId		:= cParticipant
		::ListOfEvaluate[1]:Net				:= RDA->RDA_CODNET
		::ListOfEvaluate[1]:Level			:= RDA->RDA_NIVEL
		::ListOfEvaluate[1]:Project			:= RDA->RDA_CODPRO
		::ListOfEvaluate[1]:Vision			:= (cAliasRD6)->RD6_CODVIS
		::ListOfEvaluate[1]:VisionDescription:= RDK->RDK_DESC
		::ListOfEvaluate[1]:Model			:= (cAliasRD6)->RD6_CODMOD
		::ListOfEvaluate[1]:ModelDescription:= RD3->RD3_DESC
		::ListOfEvaluate[1]:Competence		:= (cAliasRD6)->RD6_CODCOM
		::ListOfEvaluate[1]:CompetenceDescription := RDM->RDM_DESC
		::ListOfEvaluate[nX]:EvaluateStatus:= (cAliasRD6)->RD6_STATUS
		::ListOfEvaluate[nX]:EvaluateStatusDescription := OpBxStatus( .F., .T., (cAliasRD6)->RD6_STATUS )
		::ListOfEvaluate[1]:SelfEvaluate  	:= RDA->RDA_TIPOAV
		::ListOfEvaluate[1]:SelfEvaluateDescription := OpBxTipoAv( .F., .T., RDA->RDA_TIPOAV )
		::ListOfEvaluate[1]:Reply			:= "1"

		If RD6->(ColumnPos("RD6_CONREP")) > 0
			::ListOfEvaluate[1]:Reply		:= RD6->RD6_CONREP
		EndIf

		// Posiciona no RD7 para carregar as Definicoes da Avaliacao
		RD7->(dbSeek(xFilial("RD7")+RD6->RD6_CODIGO))
		//Posiciona no RD3 para Obter o Modelo de Avaliacao
		If RD3->(dbSeek(xFilial("RD3")+RD6->RD6_CODMOD))
			//Posiciona no RD8 para Obter as Questoes a serem enviadas
			RD8->(dbSeek(xFilial("RD8")+RD3->RD3_CODIGO))
		EndIf
		dbSelectArea("RD8")

		::ListOfEvaluate[1]:ListOfCompetence := {}
		nc := 0

		While !RD8->(Eof()) .And. xFilial("RD8") == RD8->RD8_FILIAL .And.;
				RD6->RD6_CODMOD == RD8->RD8_CODMOD
			nc ++

			aadd(::ListOfEvaluate[1]:ListOfCompetence,WsClassNew('Competences'))
			RDO->(dbSeek(xFilial("RDO")+RD8->(RD8_CODMOD+RD8_CODCOM+RD8_ITECOM)))
			RD2->(dbSeek(xFilial("RD2")+RD8->(RD8_CODCOM+RD8_ITECOM)))
			RBL->(dbSeek(xFilial("RBL") + RDO->(RDO_ESCALA+RDO_ITEESC)))
			::ListOfEvaluate[1]:ListOfCompetence[nc]:CompetenceItem := RDO->(RDO_ITECOM)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:CompetenceItemDescription := RD2->(RD2_DESC)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:DescCompetenceItem			:= If(Empty(RD2->(RD2_CODMEM)), "", ApdMsMm(RD2->(RD2_CODMEM), 80))
			::ListOfEvaluate[1]:ListOfCompetence[nc]:Value      := RDO->(RDO_ESCALA)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:ValueItem  := RDO->(RDO_ITEESC)
			::ListOfEvaluate[1]:ListOfCompetence[nc]:ValueItemDescription  := RBL->(RBL_DESCRI)

			::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion := {}
            nY := 0
			cWhile := RD8->RD8_FILIAL+RD8->RD8_CODMOD+RD8->RD8_CODCOM+RD8->RD8_ITECOM
			While !RD8->(Eof()) .And. RD8->(RD8_FILIAL+RD8_CODMOD+RD8_CODCOM+RD8_ITECOM) == cWhile
				nY ++
				aAdd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion,WsClassNew('Questions'))
				::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:QuestionID := RD8->(RD8_CODQUE)

				If SQO->(dbSeek(xFilial("SQO")+RD8->RD8_CODQUE))

					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Question   := SQO->(QO_QUEST)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Points     := SQO->(QO_PONTOS)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ObjectType := SQO->(QO_TIPOOBJ)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:DescQuestion   := If(Empty(SQO->(QO_CODMEM)), "", APDMSMM(SQO->(QO_CODMEM), 80))

					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Scale     	:= RD8->(RD8_ESCALA)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItem	:= RD8->(RD8_ITEESC)
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Edit   		:= RD8->(RD8_EDIT)

					RBL->(dbSeek(xFilial("RBL") + RD8->(RD8_ESCALA+RD8_ITEESC)))
					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ScaleItemDescription := RBL->(RBL_DESCRI)

					If RD6->RD6_SIMULT == "1" .And. RDB->(dbSeek(xFilial("RDB")+RD6->RD6_CODIGO+RDA->RDA_CODADO+RDA->RDA_CODPRO+RDA->RDA_CODADO+dToS(RDA->RDA_DTIAVA)+RD8->RD8_CODCOM+RD8->RD8_ITECOM+RDA->RDA_CODNET+RD8->RD8_CODQUE))
						::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AnswerDescription := Alltrim(ApdMsMm(RDB->RDB_CODMEM)) //RDB->RDB_MEMO
						::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:Justification     := Alltrim(ApdMsMm(RDB->RDB_CODJUS))
						cQuestao := RD8->RD8_CODQUE
						While RD8->RD8_CODQUE == cQuestao
							Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice, WsClassNew('Respostas'))
							nPos := Len(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice)
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice[nPos]:Alternativa := RDB->RDB_CODALT
							Aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:AlternativeChoice, RDB->RDB_CODALT)
							RD8->(dbSkip())
						EndDo
					EndIf

					::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative := {}

					nZ := 1
					If Empty(SQO->QO_ESCALA)
						SQP->(dbSeek(xFilial("SQP") + RD8->RD8_CODQUE))
						While !(SQP->(Eof())) .And. SQP->QP_FILIAL+SQP->QP_QUESTAO==xFilial("SQP")+RD8->RD8_CODQUE
							If SQO->QO_TIPOOBJ != "3" //Dissertativa
								aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListofAlternative,WsClassNew('Alternatives'))

								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:AlternativeID:= SQP->QP_ALTERNA
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Alternative  := SQP->QP_DESCRIC
								::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Percentage   := SQP->QP_PERCENT
								nZ ++
							EndIf
							SQP->(dbSkip())
						EndDo
					Else
						RBL->(dbSeek(xFilial("RBL") + SQO->QO_ESCALA))
						While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+SQO->QO_ESCALA
							aadd(::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative,WsClassNew('Alternatives'))
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:AlternativeID:= RBL->RBL_ITEM
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Alternative  := RBL->RBL_DESCRI
							::ListOfEvaluate[1]:ListOfCompetence[nc]:ListOfQuestion[nY]:ListOfAlternative[nZ]:Percentage   := RBL->RBL_VALOR
							nZ ++
							RBL->(dbSkip())
						EndDo
					EndIf

				EndIf
				RD8->(dbSkip())
			EndDo
			If nY == 0
				RD8->(dbSkip())
			EndIf
		EndDo

		If lQuery
			dbSelectArea(cAliasRD6)
			dbCloseArea()
			dbSelectArea("RD6")
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("GETPEVALUATOR",STR0031) //"Resposta do avaliado nao encontrada"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("GETPEVALUATOR",STR0030) //"Avaliado ou Avaliador invalido"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetParticipant³Autor  ³Aline Correa do Vale³ Data ³16.06.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo de recuperacao dos dados do participante			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Login do Participante                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao dos dados do participante pelo CPF     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetParticipant WSRECEIVE UserCode, ParticipantID, PortalAccess  WSSEND ParticipantData WSSERVICE RHPerformanceEvaluate
Local cGCHSDoc	:= SuperGetMv( "MV_GCHSDOC" , .F. , "1" ) // '1' = RD0_CIC '2'= RD0_DOCID
Local aArea   	:= GetArea()
Local lRetAtivo	:= .F.
Local lRetorno  := .T.
Local lRetRD0	:= .F.

If !Empty(::ParticipantId)
	dbSelectArea("RD0")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica caso a tentativa de login seja feita pela login unificado(RD0_LOGIN) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 	dbSetOrder(10)           	
	If dbSeek( xFilial("RD0")+Upper(AllTrim(::ParticipantId)) )
 		lRetRD0 := .T.
	EndIf
	If !lRetRD0 .And. cPaisLoc # 'BRA' .And. cGCHSDoc == '2' 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica caso a tentativa de login seja feita pela DOCID(RD0_DOCID)          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSetOrder(11)           	
		If dbSeek( xFilial("RD0")+AllTrim(::ParticipantId) )
	 		lRetRD0 := .T.
		EndIf
	EndIf

	If !(lRetRD0)
		If ::PortalAccess == "1" 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ se acesso ao portal for feito por e-mail   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSetOrder(7)
		Else 									
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ se for feito por cpf                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSetOrder(6)
		EndIf

		If dbSeek( xFilial("RD0")+UPPER(AllTrim(::ParticipantId)) )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ No Portal RH, pode haver mais de um participante com o mesmo CPF.            ³
			//³ Incluido tratamento para procurar um participante ativo.                     ³		
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 		If !::PORTALACCESS == "1"
			 	While RD0->( !Eof() .and. RD0_FILIAL+UPPER(AllTrim(RD0_CIC)) == xFilial("RD0")+UPPER(AllTrim(::ParticipantId)) )
 			 		If RD0->RD0_MSBLQL == "2"
				 		lRetRD0 := .T.
 			 			lRetAtivo := .T.
 			 			EXIT
 			 		EndIf
	 			 	RD0->( dbSkip()	)
	 			End While
	 		Else	
			 	While RD0->( !Eof() .and. RD0_FILIAL+Upper(AllTrim(RD0->RD0_EMAIL)) == xFilial("RD0")+UPPER(AllTrim(::ParticipantId)) ) 
 			 		If RD0->RD0_MSBLQL == "2"
				 		lRetRD0 := .T.
 			 			lRetAtivo := .T.
 			 			EXIT
 			 		EndIf
	 			 	RD0->( dbSkip()	)
	 			End While
	 		EndIf
		EndIf	
	EndIf

	If lRetRD0
		If ( lRetAtivo .Or. RD0->RD0_MSBLQL == "2" ) .OR. (SuperGetMV("MV_TCFVREN",.F.,"N") <>  "N")	//Ativo
			::ParticipantData := WsClassNew('Participants')
			::ParticipantData:ParticipantId			:= RD0->RD0_CODIGO
			if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
				::ParticipantData:ParticipantName		:= SRA->RA_NOMECMP
			Else
				::ParticipantData:ParticipantName		:= RD0->RD0_NOME
			EndIf
			::ParticipantData:ParticipantPass		:= AllTrim( Embaralha(RD0->RD0_SENHA,1) )
			::ParticipantData:ParticipantEmail		:= RD0->RD0_EMAIL
			::ParticipantData:ParticipantCPF		:= RD0->RD0_CIC
		   	If !Empty(RD0->RD0_LOGIN) 
				::ParticipantData:ParticipantCPF	:= RD0->RD0_LOGIN
			Else						   
		   		If cGCHSDOC == "2"	.And. cPaisLoc # 'BRA'
			  		::ParticipantData:ParticipantCPF := RD0->RD0_DOCID
			   EndIf
			EndIf   
		Else
			lRetorno := .F.
			SetSoapFault("GETPARTICIPANT",STR0048) //"Usuario esta Inativo no cadastro de pessoas"			
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("GETPARTICIPANT",STR0032) //"Participante nao encontrado"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("GETPARTICIPANT",STR0033)  //"Login invalido"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwEvaluator  ³ Autor ³Rogerio Augusto     ³Data ³29.09.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao da lista de avaliadores	  			   ³±±
±±³          ³Executada quando chama o pop-up de selecao de avaliador      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwEvaluator WSRECEIVE UserCode, EvaluatorName WSSEND ListOfEvaluator WSSERVICE RHPerformanceEvaluate
Local nPos := 1
dbSelectArea("RD0")
dbSetOrder(2)
dbSeek(xFilial("RD0")+Upper(EvaluatorName))
::ListOfEvaluator := {}

While !Eof() .And. (RD0_FILIAL == xFilial("RD0")) .And. SubStr(RD0->RD0_NOME,1,Len(EvaluatorName)) == Upper(EvaluatorName)

	aAdd(::ListOfEvaluator, wsClassNew("Evaluators"))
	::ListOfEvaluator[nPos]:EvaluatorID := RD0->RD0_CODIGO
	::ListOfEvaluator[nPos]:EvaluatorName := RD0->RD0_NOME
	nPos ++

	dbSkip()
EndDo

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetEvaluator  ³ Autor ³Rogerio Augusto     ³Data ³30.09.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para alterar o avaliador do participante  			   ³±±
±±³          ³Alterado por: Thiago dos Reis em 27/01/05				       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³PEvaluateID = novo avaliador					               ³±±
±±³          |EvaluatorID = avaliador atual                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD SetEvaluator WSRECEIVE UserCode, EvaluatedID, PEvaluateID, EvaluatorID, ObjectiveID, PeriodID WSSEND WSNULL WSSERVICE RHPerformanceEvaluate
Local lRetorno  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SE FOR INCLUSAO DE AVALIADOR               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(::UserCode) .and. !Empty(::EvaluatedID) .and. !Empty(::PEvaluateID) .and. Empty(::EvaluatorID) .and. !Empty(::ObjectiveID) .and. !Empty(::PeriodID)

	RDV->(dbSetOrder(1))
	If RDV->( dbSeek(xFilial("RDV")+::EvaluatedID+::ObjectiveID) )
		While !RDV->(Eof()) .and. RDV->RDV_CODPAR == ::EvaluatedID .and. RDV->RDV_CODOBJ == ::ObjectiveID
  	   		If RDV->RDV_CODPER == ::PeriodID .And. Empty(RDV->RDV_CODDOR)
	  	   		Reclock("RDV",.F.)
				RDV->RDV_CODDOR := ::PEvaluateID
				RDV->(MSUnlock())
				RDV->(FkCommit())
				Exit
			EndIf

	  		RDV->(dbSkip())
	  	EndDo
	Else
		SetSoapFault("SetEvaluator","Gravacao nao realizada")
		Return(.F.)
  	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SE FOR ALTERACAO DE AVALIADOR              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Empty(::UserCode) .and. !Empty(::EvaluatedID) .and. !Empty(::PEvaluateID) .and. !Empty(::EvaluatorID) .and. !Empty(::ObjectiveID) .and. !Empty(::PeriodID)
	Begin Transaction
		RDJ->(dbSelectArea("RDJ"))
		RDJ->(dbSetOrder(11))
	   	If RDJ->(dbSeek(xFilial("RDJ")+::ObjectiveID+::PeriodID+::EvaluatedID+::EvaluatorID))
	  	   	While !RDJ->(Eof())
	  	   		If RDJ->RDJ_CODDOR == ::EvaluatorID .and. RDJ->RDJ_CODPAR == ::EvaluatedID .and. RDJ->RDJ_CODOBJ == ::ObjectiveID .And. RDJ->RDJ_PERIOD == ::PeriodID
		  	   		Reclock("RDJ",.F.)
					RDJ->RDJ_CODDOR := ::PEvaluateID //SETA O NOVO AVALIADOR
					RDJ->(MSUnlock())
					RDJ->(FkCommit())
				  	RDJ->(dbGoTop())
				Else
					RDJ->(DbSkip())
				EndIf
		  	EndDo
	  	EndIf

		RDV->(dbSelectArea("RDV"))
		RDV->(dbSetOrder(1))
		RDV->(dbGoTop())
		If RDV->(dbSeek(xFilial("RDV")+::EvaluatedID+::ObjectiveID+::EvaluatorID+::PeriodID))
			While !RDV->(Eof()) .and. RDV->RDV_CODDOR == ::EvaluatorID .and. RDV->RDV_CODPAR == ::EvaluatedID .and. RDV->RDV_CODOBJ == ::ObjectiveID .And. RDV->RDV_CODPER == ::PeriodID
	  	   		Reclock("RDV",.F.)
				RDV->RDV_CODDOR := ::PEvaluateID
				RDV->(MSUnlock())
				RDV->(FkCommit())
		  		RDV->(dbSkip())
		  	EndDo
		Else
			SetSoapFault("SetEvaluator",STR0034)		 //"Erro! Não foi encontrado esse Revisor com esse Participante na RDV!"
			Return(.F.)
	  	EndIf
	End Transaction
Else
	lRetorno := .F.
	SetSoapFault("SetEvaluator",STR0035)	 //"Faltando parametros de entrada no metodo!"
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetStatus		³ Autor ³Rogerio Augusto     ³Data ³08.10.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para liberar as metas para o avaliador   			   ³±±
±±³          ³														       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD SetStatus WSRECEIVE UserCode, EvaluatedID, EvaluatorID, ObjectiveID, PeriodID WSSEND ListOfEvaluator WSSERVICE RHPerformanceEvaluate
Local cEvaluatedID 	:= ::EvaluatedID
Local cObjectiveID 	:= ::ObjectiveID
Local cPeriodID 	:= ::PeriodID

dbSelectArea("RDV")
dbSetOrder(1)

cSeek:=xFilial("RDV") + cEvaluatedID + cObjectiveID + cPeriodID
If RDV->(dbSeek(cSeek,.T.))
	While !RDV->(Eof())
		If (RDV->RDV_FILIAL == xFilial("RDV")) .And. (RDV->RDV_CODPAR 	== cEvaluatedID) ;
			.And. RDV->(RDV_CODOBJ) == cObjectiveID ;
			.And. RDV->(RDV_CODPER) == cPeriodID
  	   		Reclock("RDV",.F.)
			RDV->RDV_STATUS := "1"
			RDV->(MSUnlock())
			RDV->(FkCommit())
			EndIf
  		RDV->(dbSkip())
  	EndDo
EndIf
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwProjects   ³ Autor ³Juliana B Mariano   ³Data ³06.10.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de consulta de todos os projetos				       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Array contendo dados do projeto			           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwProjects WSRECEIVE UserCode, ProjectDescription, ClientCode, ClientUnit WSSEND ListOfProjects WSSERVICE RHPerformanceEvaluate
Local aArea     	:= GetArea()
Local nX        	:= 0
Local cDescProjeto 	:= IIf(Empty(::ProjectDescription), "", UPPER(::ProjectDescription) )
Local cCodCli		:= IIf(Empty(::ClientCode), "", UPPER(::ClientCode) )
Local cCodLoja		:= IIf(Empty(::ClientUnit), "", UPPER(::ClientUnit) )

If ExistBlock("MSBRWPROJECT") 
	::ListOfProjects:= ExecBlock("MSBRWPROJECT", .F., .F., {cDescProjeto, cCodCli, cCodLoja})
	RestArea(aArea)
	Return .T.
Endif

dbSelectArea("RDN")
dbSetOrder(2)
dbSeek(xFilial("RDN") + cDescProjeto)
::ListOfProjects := {}

While !Eof() .And. xFilial("RDN") == RDN->RDN_FILIAL
	If Empty(cDescProjeto) .Or. AllTrim(cDescProjeto) == SubStr(RDN->RDN_DESC, 1, LEN( AllTrim(cDescProjeto) ))
		If Empty(cCodCli) .Or. cCodcli == RDN->RDN_CODCLI	//Filtrar projetos pelo cliente informado
		 	aadd(::ListOfProjects,WsClassNew('Projects'))
			nX++

			::ListOfProjects[nX]:ProjectID 			:= RDN->RDN_CODIGO
			::ListOfProjects[nX]:ProjectDescription	:= RDN->RDN_DESC
			::ListOfProjects[nX]:DateFrom			:= RDN->RDN_DTIPRO
			::ListOfProjects[nX]:DateTo				:= RDN->RDN_DTFPRO
		EndIf
	EndIf

	dbSkip()
EndDo

RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutEvaluate  ³Autor  ³Juliana B. Mariano  ³ Data ³18.10.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Metodo de inclusao de um avaliado e projeto para uma         ³±±
±±³          ³avaliacao de um avaliado ja existe				           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpO2: 									                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que a avaliacao foi incluida com sucesso       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutEvaluate WSRECEIVE UserCode,ProjectEvaluate WSSEND WsNull WSSERVICE RHPerformanceEvaluate
Local aArea     	:= GetArea()
Local lRetorno		:= .T.
Local nI 			:= 0
Local aAvaliacao 	:= {}
Local nGetSX8Len 	:= GetSX8Len()

If len(::ProjectEvaluate:ListOfEvaluate) > 0
	aAvaliacao := ::ProjectEvaluate:ListOfEvaluate

	dbSelectArea("RD9")
	dbSetOrder(1)

	If dbSeek(xFilial("RD9")+ aAvaliacao[1]:EvaluateId + aAvaliacao[1]:EvaluatedId + aAvaliacao[1]:Project + DTOS(aAvaliacao[1]:InitialDate))
		lRetorno := .F.
		SetSoapFault("PUTEVALUATE",STR0047) //"Avaliação duplicada para o mesmo avaliado"
	Else
		BEGIN TRANSACTION
			RecLock("RD9",.T.)

			RD9->RD9_FILIAL := xFilial("RD9")
			RD9->RD9_CODAVA := aAvaliacao[1]:EvaluateId
			RD9->RD9_CODADO := aAvaliacao[1]:EvaluatedId
			RD9->RD9_CODPRO := aAvaliacao[1]:Project
			RD9->RD9_DTIAVA := aAvaliacao[1]:InitialDate
			RD9->RD9_DTFAVA := aAvaliacao[1]:FinalDate

			RD9->(MsUnlock())
			RD9->(FkCommit())

			For nI := 1 to len(aAvaliacao)
				RecLock("RDA",.T.)

				RDA->RDA_FILIAL := xFilial("RDA")
				RDA->RDA_CODAVA := aAvaliacao[nI]:EvaluateId
				RDA->RDA_CODADO := aAvaliacao[nI]:EvaluatedId
				RDA->RDA_CODPRO := aAvaliacao[nI]:Project
				RDA->RDA_DTIAVA := aAvaliacao[nI]:InitialDate
				RDA->RDA_DTFAVA := aAvaliacao[nI]:FinalDate
				RDA->RDA_CODDOR := aAvaliacao[nI]:EvaluatorId
				RDA->RDA_TIPOAV := aAvaliacao[nI]:SelfEvaluate
				RDA->RDA_CODTIP := aAvaliacao[nI]:EvaluateType
				RDA->RDA_CODNET := aAvaliacao[nI]:Net
				RDA->RDA_NIVEL  := aAvaliacao[nI]:Level

				RDA->(MsUnlock())
				RDA->(FkCommit())

				RecLock("RDC",.T.)

				//PARA USAR A FUNCAO RDCIDINIT() DEVE ESTAR POSICIONADO NO REGISTRO DA TABELA RDA
				RDA->( dbSetOrder(1) )
				RDA->( dbSeek(xFilial("RDA")+aAvaliacao[nI]:EvaluateId+aAvaliacao[nI]:EvaluatedId+aAvaliacao[nI]:Project+aAvaliacao[nI]:EvaluatorId+dTos(aAvaliacao[nI]:InitialDate)+aAvaliacao[nI]:Net+aAvaliacao[nI]:Level+aAvaliacao[nI]:SelfEvaluate) )

				RDC->RDC_FILIAL := xFilial("RDC")
				RDC->RDC_ID		:= RDCIDINIT() //PARA UTILIZAR ESTA FUNCAO DEVE SER FEITA UMA CONSULTA NA TABELA RDA POSICIONANDO NO REGISTRO CORRETO
				RDC->RDC_CODAVA := aAvaliacao[nI]:EvaluateId
				RDC->RDC_CODADO := aAvaliacao[nI]:EvaluatedId
				RDC->RDC_CODPRO := aAvaliacao[nI]:Project
				RDC->RDC_CODDOR := aAvaliacao[nI]:EvaluatorId
				RDC->RDC_TIPOAV := aAvaliacao[nI]:SelfEvaluate
				RDC->RDC_DTIAVA := aAvaliacao[nI]:InitialDate
				RDC->RDC_DTFAVA := aAvaliacao[nI]:FinalDate
				RDC->RDC_CODTIP := aAvaliacao[nI]:EvaluateType
				RDC->RDC_CODNET := aAvaliacao[nI]:Net
				RDC->RDC_NIVEL  := aAvaliacao[nI]:Level
				RDC->RDC_DTLIMR := aAvaliacao[nI]:FinalDate
				RDC->RDC_CHKENV := "2"
				RDC->RDC_ATIVO  := "1"

				RDC->(MsUnlock())
				RDC->(FkCommit())

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Confirmando a Numeracao Automatica          				 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While ( GetSX8Len() > nGetSX8Len )
					ConfirmSX8()
				End While
			Next nI
		END TRANSACTION
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("PUTEVALUATE",STR0028) //"Avaliacao invalida!"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³EvaluateType ³Autor  ³Juliana B. Mariano  ³ Data ³10.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo para consulta de tipo de pesquisa					   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpO2: Codigo da avaliacao			                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Codigo do tipo de avaliacao 				           ³±±
±±³			 ³1= pesquisa identificada / 2 = nao identificada              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³														       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD EvaluateType WSRECEIVE UserCode, PEvaluateId WSSEND EvaluateType WSSERVICE RHPerformanceEvaluate
Local lRetorno    := .T.

If !Empty(::PEvaluateId)
	dbSelectArea("RD6")
	dbSetOrder(1)
	If dbSeek(xFilial("RD6")+::PEvaluateId)
		RD5->(dbSetOrder(1))
		If RD5->(dbSeek(xFilial("RD5")+RD6->RD6_CODTIP))
			::EvaluateType := RD5->RD5_IDENTI
		Else
			lRetorno := .F.
		EndIf
	Else
		lRetorno := .F.
	EndIf
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwGenEvaluate³ Autor ³Emerson Grassi Rocha³Data ³29/03/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de Consulta de todas as avaliacoes cadastradas.	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Tipo:  0-Todas, 1-Avaliacao, 2-Pesquisa, 3-Projeto    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Dados das avaliacoes cadastradas.					   ³±±
±±³		     |      													   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwGenEvaluate WSRECEIVE UserCode,TypeEvaluate,DescEvaluate WSSEND GenEvaluate WSSERVICE RHPerformanceEvaluate
Local aArea     := GetArea()
Local lRetorno  := .T.
Local nPos		:= 0

Default ::TypeEvaluate	:= "0"
Default ::DescEvaluate	:= ""

dbSelectArea("RD6")
dbSetOrder(2)

If dbSeek(xFilial("RD6")+Upper(::DescEvaluate))

	::GenEvaluate := {}
	While !RD6->( Eof() ) .And. (RD6->RD6_FILIAL == xFilial("RD6")) .And.;
		SubStr(RD6->RD6_DESC,1,len(::DescEvaluate)) == Upper(::DescEvaluate)

		// Tipo da Avaliacao
		RD5->(dbSetOrder(1))
		If RD5->(dbSeek(xFilial("RD5")+RD6->RD6_CODTIP))
			If ( ::TypeEvaluate == "0" .Or. ::TypeEvaluate == RD5->RD5_TIPO )

				//Item de Tipo de Modelo
				RDH->(dbSetOrder(1))
				If RDH->(dbSeek(xFilial("RDH")+RD5->RD5_CODTIP))

					While RDH->(!Eof()).And.xFilial("RDH")+RD5->RD5_CODTIP==RDH->RDH_FILIAL+RDH->RDH_CODTIP
						If RDH->RDH_NIVEL=="2"     //2=Nivel Acima	- Posteriormente Buscar da Visao
							Exit
						EndIf
						RDH->(dbSkip())
					End

					aAdd(::GenEvaluate, wsClassNew('EvaluateGen'))
					nPos ++
					::GenEvaluate[nPos]:EvaluateID 			:= RD6->RD6_CODIGO
					::GenEvaluate[nPos]:EvaluateDescription	:= RD6->RD6_DESC
					::GenEvaluate[nPos]:Status				:= RD6->RD6_STATUS
					::GenEvaluate[nPos]:InitialDate			:= RD6->RD6_DTINI
					::GenEvaluate[nPos]:FinalDate			:= RD6->RD6_DTFIM
					::GenEvaluate[nPos]:TypeEvaluate 		:= RD6->RD6_CODTIP
					::GenEvaluate[nPos]:EvaluateType 		:= RD5->RD5_TIPO
					::GenEvaluate[nPos]:Net			 		:= RDH->RDH_CODNET
					::GenEvaluate[nPos]:Level		 		:= RDH->RDH_NIVEL
				EndIf
			EndIf
		Else
			lRetorno := .F.
			SetSoapFault("BRWGENEVALUATE",STR0028) //"Avaliacao invalida!"
		EndIf

		RD6->( dbSkip() )
	endDo
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutProjects   ³ Autor ³Emerson Grassi Rocha³Data ³31/03/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de Inclusao de projetos				    		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Array contendo dados do projeto			           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutProjects WSRECEIVE UserCode, PutProject WSSEND ProjectId WSSERVICE RHPerformanceEvaluate
Local aArea     := GetArea()
Local lRetorno  := .T.
Local cCod		:= ""
Local nSvSX8RDN	:= GetSX8Len()

::ProjectId := ""

If len(::PutProject:ListOfProject) > 0

	BEGIN TRANSACTION

		dbSelectArea("RDN")
		dbSetOrder(1)

		cCod :=	GetSx8Num("RDN","RDN_CODIGO")

		If __lSX8
			While (GetSX8Len() > nSvSX8RDN)
				ConfirmSX8()
			End
		Else
			RollBackSX8()
		Endif

		RecLock("RDN",.T.)

		RDN->RDN_FILIAL := xFilial("RDN")
		RDN->RDN_CODIGO	:= cCod
		RDN->RDN_DESC 	:= Upper(::PutProject:ListOfProject[1]:ProjectDescription)
		RDN->RDN_DTIPRO	:= ::PutProject:ListOfProject[1]:DateFrom
		RDN->RDN_DTFPRO	:= ::PutProject:ListOfProject[1]:DateTo
		RDN->RDN_CODCLI := ::PutProject:ListOfProject[1]:ClientID
		RDN->RDN_CODPMS	:= ::PutProject:ListOfProject[1]:PmsCode

		ApdMsMm(RDN->RDN_CODMEM,,,::PutProject:ListOfProject[1]:MemoCode	,1,,,"RDN","RDN_CODMEM")

		RDN->( MsUnlock() )
		RDN->(FkCommit())
	END TRANSACTION
	::ProjectId := cCod

EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwPeriod	    ³ Autor ³Emerson Grassi Rocha³Data ³31/03/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de Consulta de Periodos das avaliacoes de um avaliado.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do avaliado                                    ³±±
±±³          ³ExpC3: Codigo da avaliacao     		                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Dados das avaliacoes que o participante esta sendo    ³±±
±±³		     |       avaliado											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwPeriod WSRECEIVE UserCode,EvaluatedID,PEvaluateID,EvaluatorID,ResultType,QueryAddWhere, StatusEvaluate, NetLevel WSSEND ListOfEvaluate WSSERVICE RHPerformanceEvaluate
Local aArea     		:= GetArea()
Local lRetorno  		:= .T.
Local lQuery    		:= .F.
Local lOk 				:= .T.
Local cAvaliado			:= ""
Local cAutoAvaliado 	:= ""
Local cCodAvaliado 		:= ""
Local cAvaliacao		:= ""
Local cEvaluator 		:= SubStr(::EvaluatorID,1,Len(RDA->RDA_CODDOR))
Local cStatus			:= If( Empty(::StatusEvaluate),"1",::StatusEvaluate ) //1=pendencias, 2=ja confirmadas(consulta)
Local cNivel			:= If( Empty(::NetLevel), "3", ::NetLevel ) //1=mesmo nivel, 2=nivel acima, 3=nivel abaixo
Local nPos 				:= 0
Local nPos1				:= 0
Local nJ 				:= 0
Local nX        		:= 0
Local aAval				:= {"","",""}

If !cStatus $ "12"
	lRetorno := .F.
	Return(SetSoapFault("BRWMYEVALUATES",STR0025)) //"Status da Avaliacao invalido"
EndIf

If !Empty(cEvaluator) .And. !Empty(::PEvaluateID) .And. !Empty(::EvaluatedID)

	dbSelectArea("RD6")
	dbSetOrder(1)
	dbSelectArea("RDA")
	dbSetOrder(1)

	dbSeek(xFilial("RDA")+ ::PEvaluateID + ::EvaluatedID)

	RDC->(dbSetOrder(1))
	RD5->(dbSetOrder(1))
	RDK->(dbSetOrder(1))
	RD3->(dbSetOrder(1))
	RDM->(dbSetOrder(1))
	RDP->(dbSetOrder(1))
	RD0->(dbSetOrder(1))

	dbSelectArea("RDA")

	::ListOfEvaluate := {}
	While !Eof() .And. xFilial("RDA") == RDA->RDA_FILIAL;
				 .And. ::PEvaluateID  == RDA->RDA_CODAVA;
				 .And. ::EvaluatedID  == RDA->RDA_CODADO

		dbSelectArea("RD6")
		If dbSeek(xFilial("RD6")+RDA->RDA_CODAVA)
	
			RD5->(dbSeek(xFilial("RD5")+RD6->RD6_CODTIP))
			RDK->(dbSeek(xFilial("RDK")+RD6->RD6_CODVIS))
			RD3->(dbSeek(xFilial("RD3")+RD6->RD6_CODMOD))
			RDM->(dbSeek(xFilial("RDM")+RD6->RD6_CODCOM))
			RD0->(dbSeek(xFilial("RD0")+RDA->RDA_CODADO))
			RDP->(dbSeek(xFilial("RDP")+RDA->RDA_CODAVA+dToS(RDA->RDA_DTIAVA)))
			RDC->(dbSeek(xFilial("RDC")+RDA->RDA_CODAVA+RDA->RDA_CODADO+RDA->RDA_CODPRO+RDA->RDA_CODDOR+dToS(RDA->RDA_DTIAVA)+RDA->(RDA_CODNET+RDA_NIVEL+RDA_TIPOAV)))
	
			// Apenas Avaliacao de Projeto
			If RD5->RD5_TIPO == "3"
	
				//PARA VERIFICAR SE SUBORDINADO JÁ SE AUTO-AVALIOU E JÁ FOI AVALIADO
				//ANTES DE MOSTRAR A AVALIACAO DO CONSENSO
				//SE FOR CONSULTA DE AVALIACAO, MOSTRAR CONSENSO DE QUALQUER MANEIRA
				lOk := .T.
				nPos := 0
				If cStatus == "1" //SE FOR PENDENCIA/INCLUSAO DE DADOS DA AVALIACAO
					If RDA->RDA_TIPOAV == "3"
						//VERIFICA SE SUBORDINADO SE AUTO-AVALIOU
						If RDC->(dbSeek(xFilial("RDC")+RDA->RDA_CODAVA+RDA->RDA_CODADO+RDA->RDA_CODPRO+RDA->RDA_CODADO+dToS(RDA->RDA_DTIAVA))) //+RDA->(RDA_CODNET)+RDA->(RDA_NIVEL)))
							cAutoAvaliado := RDC->RDC_DATRET //RDC->RDC_TIPO
						EndIf
						nPos := ascan(::ListOfEvaluate, {|x| x:EvaluateID == RDA->RDA_CODAVA .And. x:SelfEvaluate == "1" .And. x:EvaluatedId == RDA->RDA_CODADO .And. x:FinalDate == RDA->RDA_DTFAVA })
						If nPos > 0 .Or. Empty(cAutoAvaliado) //cAutoAvaliado != "3"
							lOk := .F.
						EndIf
					ElseIf RDA->RDA_TIPOAV == "1"
						//VERIFICA SE CONSENSO FOI GRAVADO ANTES DA AVALIACAO COMO AVALIADOR
						//PEGA A POSICAO DO MESMO E GRAVA AVALIACAO POR CIMA
						nPos := ascan(::ListOfEvaluate, {|x| x:EvaluateID == RDA->RDA_CODAVA .And. x:SelfEvaluate == "3" .And. x:EvaluatedId == RDA->RDA_CODADO .And. x:FinalDate == RDA->RDA_DTFAVA })
						If nPos > 0
							//nJ := nX
							//nX := nPos
							aDel(::ListOfEvaluate, nPos) //APAGA REGISTRO DO ARRAY
							aSize(::ListOfEvaluate, len(::ListOfEvaluate)-1) //REDIMENSIONA
						EndIf
					EndIf
	
				ElseIf cStatus == "2"	//CONSULTA
					//VERIFICA SE AVALIACAO ATUAL E DE CONSENSO
					//SE FOR BUSCA POR AUTO AVALIACAO / SE ACHAR APAGA /
					//SENAO NAO DEIXA GRAVAR NO ARRAY
					If RDA->RDA_TIPOAV == "3"
						//VERIFICA SE EXISTE AVALIACAO QUE NAO SEJA DE CONSENSO JA GRAVADA
						nPos1 := ascan(::ListOfEvaluate, {|x| x:EvaluateId == RDA->RDA_CODAVA .And. x:EvaluatedId == RDA->RDA_CODADO .And. x:FinalDate == RDA->RDA_DTFAVA })
						If nPos1 > 0
							aDel(::ListOfEvaluate, nPos1) //APAGA REGISTRO DO ARRAY
							aSize(::ListOfEvaluate, len(::ListOfEvaluate)-1) //REDIMENSIONA
						Else
							aAval[1] := RDA->RDA_CODAVA
							aAval[2] := RDA->RDA_CODADO
							aAval[3] := RDA->RDA_DTIAVA
						EndIf
					ElseIf RDA->RDA_CODAVA == aAval[1] .And. RDA->RDA_CODADO == aAval[2] .And. RDA->RDA_DTIAVA == aAval[3]
						lOk := .F.
					EndIf
				EndIf
	
				If lOk == .T.
					//USADO PARA GRAVAR POR CIMA DO REGISTRO DE CONSENSO
				 	aadd(::ListOfEvaluate,WsClassNew('EvaluateList'))
					nX := len(::ListOfEvaluate)
	
					//VERIFICA SE SUBORDINADO SE AUTO-AVALIOU
					If RDC->(dbSeek(xFilial("RDC")+RDA->RDA_CODAVA+RDA->RDA_CODADO+RDA->RDA_CODPRO+RDA->RDA_CODADO+dToS(RDA->RDA_DTIAVA))) //+RDA->(RDA_CODNET)+RDA->(RDA_NIVEL)))
					    ::ListOfEvaluate[nX]:AutoEvaluated := IIf(!Empty(RDC->RDC_DATRET),STR0045,STR0046) //"SIM"###"NAO"
					Else
						::ListOfEvaluate[nX]:AutoEvaluated := STR0046 //"NAO"
					EndIf
					//Re-posiciona no registro
					RDC->(dbSeek(xFilial("RDC")+RDA->RDA_CODAVA+RDA->RDA_CODADO+RDA->RDA_CODPRO+RDA->RDA_CODDOR+dToS(RDA->RDA_DTIAVA)+RDA->(RDA_CODNET+RDA_NIVEL+RDA_TIPOAV)))
	
					::ListOfEvaluate[nX]:EvaluateId				:= RDA->RDA_CODAVA
					if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
						::ListOfEvaluate[nX]:EvaluatedName		:= AllTrim(SRA->RA_NOMECMP)
					Else
						::ListOfEvaluate[nX]:EvaluatedName		:= RD0->RD0_NOME
					EndIf
					::ListOfEvaluate[nX]:InitialDate			:= RDA->RDA_DTIAVA//RD6->RD6_DTINI
					::ListOfEvaluate[nX]:FinalDate				:= RDA->RDA_DTFAVA//RD6->RD6_DTFIM
					::ListOfEvaluate[nX]:AnswerFinalDate		:= IIf(RDA->RDA_TIPOAV=="2",RDP->RDP_RSPADO,IIf(RDA->RDA_TIPOAV=="1",RDP->RDP_RSPDOR,RDP->RDP_RSPCON))
					::ListOfEvaluate[nX]:Description			:= RD6->RD6_DESC
					::ListOfEvaluate[nX]:Net					:= RDA->RDA_CODNET
					::ListOfEvaluate[nX]:Project				:= RDA->RDA_CODPRO
					::ListOfEvaluate[nX]:ProjectDescription 	:= AllTrim(FDesc("RDN", RDA->RDA_CODPRO, "RDN_DESC",,,1))
					::ListOfEvaluate[nX]:EvaluateType			:= RD6->RD6_CODTIP
					::ListOfEvaluate[nX]:TypeDescription		:= RD5->RD5_DESC
					::ListOfEvaluate[nX]:EvaluatedId			:= RDA->RDA_CODADO
					::ListOfEvaluate[nX]:Vision					:= RD6->RD6_CODVIS
					::ListOfEvaluate[nX]:VisionDescription		:= RDK->RDK_DESC
					::ListOfEvaluate[nX]:Model					:= RD6->RD6_CODMOD
					::ListOfEvaluate[nX]:ModelDescription		:= Alltrim(ApdMsMm( RD3->RD3_CODMEM,,,,,,,"RD3" ))
					::ListOfEvaluate[nX]:Competence				:= RD6->RD6_CODCOM
					::ListOfEvaluate[nX]:CompetenceDescription	:= RDM->RDM_DESC
					::ListOfEvaluate[nX]:Reply					:= "1"

					If RD6->(ColumnPos("RD6_CONREP")) > 0
						::ListOfEvaluate[nX]:Reply			:= RD6->RD6_CONREP
					EndIf

		   			If RDC->RDC_TIPO $("456") //Microsiga
						::ListOfEvaluate[nX]:EvaluateStatus	:= RDC->RDC_TIPO
						If RDC->RDC_TIPO == "4"
							::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0039	//"Não finalizado pelo avaliador"
						ElseIf RDC->RDC_TIPO == "5"
							::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0040	//"Não finalizado pelo avaliado"
						Else
							::ListOfEvaluate[nX]:EvaluateStatusDescription 	:= STR0041	//"Não iniciado"
						EndIf
					Else
						::ListOfEvaluate[nX]:EvaluateStatus				:= RD6->RD6_STATUS
						::ListOfEvaluate[nX]:EvaluateStatusDescription	:= OpBxStatus( .F., .T., RD6->RD6_STATUS )
					EndIf
					::ListOfEvaluate[nX]:SelfEvaluate  				:= RDA->RDA_TIPOAV
					::ListOfEvaluate[nX]:SelfEvaluateDescription	:= OpBxTipoAv( .F., .T., RDA->RDA_TIPOAV )
				EndIf
			EndIf
		EndIf
		dbSelectArea("RDA")
		dbSkip()
	EndDo
	nX := 0
Else
	lRetorno := .F.
	SetSoapFault("BRWMYEVALUATED",STR0024)	//"Avaliador invalido"
EndIf

RestArea(aArea)
Return(lRetorno)

Static Function CPYAVA(cCodAva,cCodAdo,cCodDor)

Local cTabRDB	:= ""
Local cTabRDC	:= ""
Local cQry		:= ""            
Local cIDAval	:= ""
Local cIDCons	:= ""                
Local aRDB		:= RDB->(getarea())

//Busca o ID da Avaliacao
cTabRDC := GetNextAlias()
cQry := " SELECT RDC_ID " + CRLF
cQry += " FROM " + RETSQLNAME("RDC") + " RDC" + CRLF
cQry += " WHERE RDC_FILIAL = '" + xFilial("RDC") + "'" + CRLF
cQry += " AND RDC_CODAVA = '" + cCodAva + "'" + CRLF
cQry += " AND RDC_CODADO = '" + cCodAdo + "'" + CRLF
cQry += " AND RDC_CODDOR = '" + cCodDor + "'" + CRLF
cQry += " AND RDC_TIPOAV = '1'"+CRLF
cQry += " AND RDC.D_E_L_E_T_ = '' " + CRLF
cQry := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), cTabRDC, .F., .T.)
       
If (cTabRDC)->(!eof())
	cIDAval := (cTabRDC)->RDC_ID
EndIf
(cTabRDC)->(dbclosearea())

//Busca o ID do Consenso
cTabRDC := GetNextAlias()
cQry := " SELECT RDC_ID " + CRLF
cQry += " FROM " + RETSQLNAME("RDC") + " RDC" + CRLF
cQry += " WHERE RDC_FILIAL = '" + xFilial("RDC") + "'" + CRLF
cQry += " AND RDC_CODAVA = '" + cCodAva + "'" + CRLF
cQry += " AND RDC_CODADO = '" + cCodAdo + "'" + CRLF
cQry += " AND RDC_CODDOR = '" + cCodDor + "'" + CRLF
cQry += " AND RDC_TIPOAV = '3'" + CRLF
cQry += " AND RDC.D_E_L_E_T_ = '' " + CRLF
cQry := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), cTabRDC, .F., .T.)
If (cTabRDC)->(!eof())
	cIDCons := (cTabRDC)->RDC_ID
EndIf
(cTabRDC)->(dbclosearea())

//Se encontrou consenso configurado
If !empty(cIDCons)

	//Deleta os itens do consenso na RDB, se já existirem
	cChave := xFilial("RDB")+cCodAva+cCodAdo 
	RDB->(DbSetOrder(1))
	RDB->(DbSeek(cChave))
	While RDB->(!Eof()) .and. RDB->(RDB_FILIAL+RDB_CODAVA+RDB_CODADO) == cChave
	    IF RDB->RDB_ID == cIDCons	
			RDB->(Reclock("RDB",.F.))
				RDB->(DBDELETE())
			RDB->( msUnlock() )	
		EndIf
		RDB->( DbSkip() )
	EndDo    
	
	//Busca os itens da avaliacao na RDB que serao replicados
	cTabRDB := GetNextAlias()
	cQry:= " SELECT * "
	cQry+= "    FROM " + RetSqlName("RDB") + " "
	cQry+= " WHERE RDB_ID = '"+ cIDAval+"' "
	cQry+= "    AND D_E_L_E_T_ = '' " 
	cQry:= ChangeQuery(cQry)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cTabRDB, .F., .T.)	 
	
	(cTabRDB)->(dbGoTop())
	While (cTabRDB)->(!eof())
		RDB->(Reclock("RDB",.T.))			
			RDB->RDB_FILIAL 		:= (cTabRDB)->RDB_FILIAL
			RDB->RDB_CODAVA 		:= (cTabRDB)->RDB_CODAVA
			RDB->RDB_CODADO 		:= (cTabRDB)->RDB_CODADO
			RDB->RDB_CODPRO 		:= (cTabRDB)->RDB_CODPRO
			RDB->RDB_CODDOR 		:= (cTabRDB)->RDB_CODDOR
			RDB->RDB_TIPOAV	   		:= '3'
			RDB->RDB_DTIAVA 		:= STOD((cTabRDB)->RDB_DTIAVA)
			RDB->RDB_DTFAVA	  		:= STOD((cTabRDB)->RDB_DTFAVA)
			RDB->RDB_CODMOD 		:= (cTabRDB)->RDB_CODMOD
			RDB->RDB_CODCOM 		:= (cTabRDB)->RDB_CODCOM
			RDB->RDB_ITECOM  		:= (cTabRDB)->RDB_ITECOM
			RDB->RDB_CODTIP	  		:= (cTabRDB)->RDB_CODTIP
			RDB->RDB_CODNET 		:= (cTabRDB)->RDB_CODNET
			RDB->RDB_CODQUE 		:= (cTabRDB)->RDB_CODQUE
			RDB->RDB_CODALT 		:= (cTabRDB)->RDB_CODALT
			RDB->RDB_ESCALA 		:= (cTabRDB)->RDB_ESCALA
			RDB->RDB_ITEESC 		:= (cTabRDB)->RDB_ITEESC
			RDB->RDB_RESOBT	  		:= (cTabRDB)->RDB_RESOBT
			RDB->RDB_ID 			:= cIDCons			
		 ApdMsMm(RDB->RDB_CODMEM,,,Alltrim(ApdMsMm((cTabRDB)->RDB_CODMEM)),1,,,"RDB","RDB_MEMO")//RDB->RDB_CODJUS
		 ApdMsMm(RDB->RDB_CODJUS,,,Alltrim(ApdMsMm((cTabRDB)->RDB_CODJUS)),1,,,"RDB","RDB_CODJUS")//RDB->RDB_CODJUS  

		RDB->( msUnlock() )
		(cTabRDB)->(dbskip())
	EndDo	 
	(cTabRDB)->(dbCloseArea())

EndIf

RestArea(aRDB)

RETURN
/*/{Protheus.doc}buscaSRA
função que retorna a chave da entidade SRA (Filial + matricula) de acordo com o codigo da RD0
@Author Cícero Alves 
@since 19/08/2015
@version P118
@Param cCodRD0, caractere, codigo do participante na RD0
@Return cRet, caractere, filial + matricula do funcionario relacionado ao codigo informado
/*/
Function buscaSRA(cCodRD0)
	Local cRet := ""

	BeginSql alias 'RDZCOD'    
	
	SELECT RDZ.RDZ_CODENT
	
	FROM %table:RDZ% RDZ           
	
	WHERE RDZ.RDZ_CODRD0 = %exp:cCodRD0% 
	AND RDZ.RDZ_ENTIDA = 'SRA'
    AND RDZ.%notDel%
   EndSql 
   
   cRet := RDZCOD->RDZ_CODENT
   
   RDZCOD->(dbCloseArea())

Return cRet
