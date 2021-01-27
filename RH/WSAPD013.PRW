#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSAPD013.CH"

#DEFINE cCodUser 	"MSALPHA"
#DEFINE RGPERPAGE 	5
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSAPD013  ³ Autor ³    Thiago dos Reis    ³ Data ³08.12.2004  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pelos Planos de Desenvolv. Pessoal   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Claudinei S.  ³17/05/13³THBPKZ³F3 so retornara participantes ativos      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Avaliacao de desempenho (Performance Evaluate)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WSSTRUCT ObjectiviesTopics
	WSDATA DescrObjectivies			As String   		// Descricao do Objetivo (PDP)
	WSDATA Status					As String			// Status do Plano se esta com: 1=AVALIADO;2=AVALIADOR;3=FINALIZADO
	WSDATA PeriodDescr				As String			// Descricao do Periodo
	WSDATA PeriodDtIni				As Date				// Data Inicial do Periodo
	WSDATA PeriodDtFin				As Date				// Data Final do Periodo
	WSDATA PerIncIni				As Date	 OPTIONAL	// Data Início do período para inclusão e manutenção de metas
	WSDATA PerIncFim				As Date	 OPTIONAL	// Data Final do período para inclusão e manutenção de metas
	WSDATA PerMntResIni				As Date  OPTIONAL	// Data Início do período para manutenção do resultado (% de atingimento)
	WSDATA PerMntResFim				As Date	 OPTIONAL	// Data Início do período para manutenção do resultado (% de atingimento)
	WSDATA PerTipo					As String OPTIONAL  // Tipo de Periodo
	WSDATA PermissionFinal			As Boolean			// Indica se esta dentro do periodo de finalizacao Sim = .T. / Nao = .F.
	WSDATA NameAvaliado				As String			// Nome do Avaliado
	WSDATA NameAvaliador			As String			// Nome do Avaliador
	WSDATA IDAvaliador				As String			// Codigo do Avaliador
	WSDATA DescrParticipant			As String			// Descricao do papel do participante
	WSDATA SubPlan					As Array of SubPlans OPTIONAL	// Array dos topicos do Objetivo
	WSDATA PlanVersion				As String			// Versao que se encontra o Plano
	WSDATA PlanRevision				As Array of String	OPTIONAL	// Array que indica se cada Topico do plano pode ser enviado para o Revisor/Avaliador
	WSDATA LastApprove				As Date	OPTIONAL	// Data da ultima aprovacao
	WSDATA LastUpdate				As Date	OPTIONAL	// Data da ultima modificacao
	WSDATA PartLeaderId 			As String OPTIONAL	// Codigo do Lider Hierarquico
	WSDATA PartLeader 				As String OPTIONAL	// Nome do Lider Hierarquico
	WSDATA HierarqLevel				As String OPTIONAL	// Nivel de Carreira
	WSDATA Area						As String OPTIONAL	// Area-Centro de Custo  
	WSDATA ItenPerPend				As Boolean OPTIONAL	// Propriedade que valida se poderá ser finalizado para histórico 		
ENDWSSTRUCT

WSSTRUCT SubPlans
	WSDATA PanID					As String OPTIONAL	//Codigo do plano de desenvolvimento pessoal (Objetivo)
	WSDATA ItemID					As String 			//Codigo do item do Sub Plano (Topico)
	WSDATA DescrItem				As String 			//Descricao do item do Sub Plano (Topico)
	WSDATA TipoItem					As String 			//Tipo de Item (montagem de tela 1=Default,2=Capacitacao,3=Descritivo,4=Certificacao)
	WSDATA TpCurso					As String OPTIONAL	//Tipo do Curso (caso tenha que pesquisar cursos)
	WSDATA PanStatus				As String OPTIONAL	//Status do Sub Plano (se ja foi preenchido algum item, se foi recusado algum item ou se está em branco)
	WSDATA ItemList					As Array of Item OPTIONAL //Listagem dos Itens desse SubPlano(topico)
	WSDATA LimitMt					As Float OPTIONAL //Limite de quantidade de metas ativas que poderão ser inseridas via portal em cada item de objetivo
	WSDATA LimitPes					As Float OPTIONAL //Limite do somatório de pesos de metas ativas que serão inseridas via portal em cada item de objetivo, com base nos valores da escala de relevância.
ENDWSSTRUCT

WSSTRUCT ItemGroup
	WSDATA ItemList					As Array Of Item OPTIONAL	//Lista de Itens do Topico
	WSDATA RelevanceList			As Array Of Alternative		//Lista de Grau de Relevancia do Topico
	WSDATA PercentList				As Array Of Alternative		//Lista de Porcentagem atinginda (realizada)
	WSDATA CourseList				As Array Of Course OPTIONAL	//Lista de cursos SQT cadastrados pra este topico RDW
	WSDATA TypeCourseList			As Array Of Course OPTIONAL	//Lista de tipos cursos SQX cadastrados pra este topico RDW
ENDWSSTRUCT

WSSTRUCT Course
	WSDATA CourseId   				As String			//Codigo do curso SQT
	WSDATA CourseDescr				As String   		//Descricao do curso
	WSDATA CourseValue				As Float OPTIONAL   //Valor do Curso
	WSDATA CourseHours				As Float OPTIONAL	//Duracao do Curso (Horas)
ENDWSSTRUCT

WSSTRUCT Item
	WSDATA ItemID					As String			//Codigo do Item
	WSDATA TypeCourseId				As String OPTIONAL	//codigo do tipo de curso
	WSDATA Status					As String			//Status do Item (Pendente, Revisar, Aprovado, Rejeitado)
	WSDATA ItemDescr				As String 			//Descricao do Item
	WSDATA ItemPlanVersion			As String OPTIONAL	//Versao do Plano que o Item se encontra
	WSDATA ValidatorObs				As String OPTIONAL	//Observacao do Avaliador
	WSDATA FinishDate				As Date				//Data de conclusao
	WSDATA InitDate					As Date				//Data de Incio
	WSDATA ItemDate					As Date				//Data de cadastro do Item
	WSDATA Relevance  				As String			//Grau de relevancia
	WSDATA PercentDone				As String OPTIONAL	//Porcentagem atinginda (realizada)
	WSDATA PercentId				As String OPTIONAL	//codigo da porcentagem atingida
	WSDATA ResultDone				As Float  OPTIONAL	//Porcentagem atinginda (realizada)
	WSDATA CourseId   				As String OPTIONAL	//Codigo do curso SQT
	WSDATA CourseDescr				As String OPTIONAL	//Descricao do curso
	WSDATA TypeCourseDescr			As String OPTIONAL	//Descricao do tipo de curso
	WSDATA CourseValue				As string OPTIONAL	//Valor do Curso SQT escolhido
	WSDATA CourseDuration			As Float  OPTIONAL	//Duracao do Curso SQT escolhido
	WSDATA Author					As String 			//Autor do item (0=avaliado 1=avaliador)
	WSDATA CourseList				As Array Of Course OPTIONAL	//Lista dos cursos do mesmo tipo do cadastrado na base
	WSDATA Peso						As Float  OPTIONAL	//Percentual equivalente a alternativa
ENDWSSTRUCT

WSSTRUCT Alternative
	WSDATA EscaleID					As String			//Código da escala (código do pai)
	WSDATA AlternativeID   			As String			//Numero da alternativa
	WSDATA Alternative				As String OPTIONAL	//Alternativa (descritivo)
	WSDATA Percentage				As Float  			//Percentual equivalente a alternativa
ENDWSSTRUCT

WSSTRUCT Objective
	WSDATA ObjectiveID   			As String			//Codigo do Objetivo
	WSDATA ObjectiveDescr			As String			//Descricao do Objetivo
	WSDATA ObjectivePeriod			As Array of Period	//Array com os períodos do Objetivo
	WSDATA ObjectiveAvaliaterID		As String			//Codigo do Avaliador do Objetivo
	WSDATA ObjectiveAvaliaterName	As String OPTIONAL	//Nome do Avaliador do Objetivo
	WSDATA ObjectiveAvaliatedID		As String			//Codigo do Avaliado do Objetivo
	WSDATA ObjectiveAvaliatedName	As String			//Nome do Avaliado do Objetivo
	WSDATA ObjectiveStatus			As String			//Status do Objetivo (se a edicao do plano com: 1=AVALIADO;2=AVALIADOR;3=FINALIZADO
	WSDATA ObjectiveGoal			As Float  OPTIONAL 	//Metas Cadastradas
	WSDATA ObjectivePercent			As Float  OPTIONAL  //Com % Atingimento
	WSDATA ObjectiveResult			As Float  OPTIONAL  //Resultado do Objetivo
	WSDATA LastApprove				As Date OPTIONAL	//Data da ultima aprovacao
ENDWSSTRUCT

WSSTRUCT ItemPropreties
	WSDATA EvaluatedId              As String OPTIONAL	//Codigo do Avaliado
	WSDATA EvaluatorId              As String OPTIONAL	//Codigo do Avaliador
	WSDATA ObjectiveID	 			As String			//Codigo do tipo de objetivo
	WSDATA Item         			As String 			//Codigo do Item do tipo de objetivo
	WSDATA ItemPlanVersion			As String OPTIONAL  //Versao do Plano que o Item se encontra
	WSDATA SubPlanID				As String 			//Codigo do SubPlano (Topico RDW)
	WSDATA Period					As String 			//Codigo do periodo
	WSDATA CourseId					As String OPTIONAL	//Codigo do Curso SQT escolhido
	WSDATA TypeCourseId				As String OPTIONAL	//Codigo do tipo de Curso SQT escolhido
	WSDATA CourseValue				As string OPTIONAL	//Valor do Curso SQT escolhido
	WSDATA CourseDuration			As Float  OPTIONAL	//Duracao do Curso SQT escolhido
	WSDATA ValidatorObs				As String OPTIONAL	//Observacao do Avaliador
	WSDATA ItemDate     			As Date   OPTIONAL	//Data de inclusao do item
	WSDATA InitialDate				As Date   OPTIONAL	//Data inicial
	WSDATA FinalDate				As Date   OPTIONAL	//Data final
	WSDATA Relevance				As String OPTIONAL	//Escala de Relevancia
	WSDATA RelevanceItem			As String OPTIONAL	//Item da escala de relevancia
	WSDATA AchieveScale				As String OPTIONAL	//Escala de Atingimento
	WSDATA AchieveScaleItem			As String OPTIONAL	//Item da escala de atingimento
	WSDATA Observation				As String OPTIONAL	//Observacoes
	WSDATA Status					As String OPTIONAL	//Status Pendente, Revisar, Aprovado, Reprovado e etc...
	WSDATA Change					As String OPTIONAL	//Define se está alterando ou inserindo o registro na tabela. True alterando, False inserindo
	WSDATA Author					As String OPTIONAL	//Autor do Item (0=Avaliado 1=Avaliador)
ENDWSSTRUCT

WSSTRUCT Obj        
	WSDATA ObjID   			As String	//Codigo do Objetivo
	WSDATA ObjDescr			As String	//Descricao do Objetivo
ENDWSSTRUCT

WSSTRUCT Period
	WSDATA PeriodID   				As String				//Codigo do Periodo
	WSDATA PeriodDescr				As String				//Descricao do Periodo
	WSDATA Status					As String	OPTIONAL	//Status do Objetivo com esse periodo
	WSDATA PeriodObjVersion			As String	OPTIONAL	//Versao que se encontra o Plano e Periodo
	WSDATA PeriodDtIni				As Date		OPTIONAL	// Data Inicial do Periodo
	WSDATA PeriodDtFin				As Date		OPTIONAL	// Data Final do Periodo
	WSDATA PeriodDtAlt				As Date		OPTIONAL	// Data da primeira alteracao da nova versao
	WSDATA PeriodTimeIniAval		As Integer	OPTIONAL 	//Qtde de dias para iniciar o plano
	WSDATA PeriodTimeEditAval		As Integer	OPTIONAL 	//Qtde de dias para aprovar o plano apos a primeira edicao e aprovacao e uma nova edicao
	WSDATA PeriodTimeFinAval		As Integer	OPTIONAL 	//Qtde de dias para finalizar o plano
ENDWSSTRUCT

WSSTRUCT User
	WSDATA UserID   		As String	//Codigo do Usuario
	WSDATA UserName			As String	//Descricao do Usuario
	WSDATA UserMat   		As String	//Matricula do Participante
	WSDATA UserFuncao		As String	//Função do Participante
	WSDATA UserCC   		As String	//Centro de custo    
ENDWSSTRUCT

WSSTRUCT Historic
	WSDATA HistObjetivo		As Array of Obj 	  OPTIONAL	//Detalhes do Objetivo
	WSDATA HistPeriod		As Array of Period 	  OPTIONAL	//Detalhes do Periodo
	WSDATA HistParticipant	As Array of User 	  OPTIONAL	//Detalhes do Participant
	WSDATA HistAvaliator	As Array of User 	  OPTIONAL	//Detalhes do Avaliador
	WSDATA HistVersion		As Array of Float	  OPTIONAL	//Numero da Versao
	WSDATA HistSubPlans		As Array of SubPlans  OPTIONAL	//Detalhes dos Topicos com seus itens
	WSDATA ListOfObjective	As Array of Objective OPTIONAL	//Listagem dos Planos de Des. Pessoal com os Períodos e outros dados
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Controle de Plano de Desenvolvimento Pessoal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHPersonalDesenvPlan DESCRIPTION STR0001 //"Plano de Desenvolvimento Pessoal ( <b>Restrição de participante</b> )"
	WSDATA UserCode               AS String				//codigo de permissao de usuario para acessar o servico
	WSDATA ParticipantId          As String             //Codigo do Participante
	WSDATA AvaliatorId			  As String				//Codigo do avaliador
	WSDATA TypeId				  As String				//Tipo de Objetivo 1=Plano 2=Meta
	WSDATA ObjID 			  	  As String				//Codigo do Plano (Objetivo)
	WSDATA PeriodID				  As String 			//Codigo do Periodo
	WSDATA TopicID				  As String				//Codigo do Topico
	WSDATA ItemID				  As String				//Codigo do Item
	WSDATA Author				  As String				//Autor
	WSDATA PlanVersion			  As String				//Versao do Plano
	WSDATA WsNull				  As String				//variavel de retorno
	WSDATA Text					  As String				//variavel generica para passagem de textos
	WSDATA Status				  As String				//variavel generica para Status
	WSDATA ListOfObjective		  As Array of Objective //Listagem dos Planos de Des. Pessoal com os Períodos e outros dados
	WSDATA ListOfObjTopics		  As ObjectiviesTopics  //Listagem dos Topicos
	WSDATA ListOfTopicItens		  As ItemGroup			//Listagem dos Itens, Relevancia e Procentagem de um Topico, incluido pelo usuario
	WSDATA ListOfItemProp		  As ItemPropreties		//Detalhes do item para inclusao ou alteracao na RDJ
	WSDATA ListOfHistory		  As Historic  			//Descricao de propriedades para geracao de historico
	WSDATA ListOfObj			  As Array of Obj		//Listagem de Objetivos
	WSDATA ListOfUser			  As Array of User  	//Listagem de Participantes
	WSDATA ListOfPeriod			  As Array of Period	//Listagem de Periodos
	WSDATA MessageCode			  As String				//Codigo da Mensagem
	WSDATA Message				  As String				//Mensagem
	WSDATA Header				  AS Array Of BrwHeader				
	WSDATA HeaderType			  As String                   
	WSDATA Filtro				  As String	Optional			// Filtro da busca do participante
	WSDATA Page					  As Integer     
	WSDATA TipoPer				  As String     
	WSDATA RetPeriodo			  As Array of Period
	WSDATA TipOrdem				  As String OPTIONAL	//Tipo de Ordem da Consulta (1-Ascendente; 2-Descendente)
	WSDATA OrdenTipo			  As String	OPTIONAL	//Tipo de Ordenamento 1- Por código; 2-Por descrição; 3-Por data de início; 4-Por data de termino) 
	WSDATA Plano				  As String	OPTIONAL	//Qual Plano 1-Desenvolvimento ou 2-Metas 
	WSDATA Opc					  As String	OPTIONAL	//Qual opção selecionada Pendencias  ou Histórico
	WSDATA PeriodDtIni			  As Date	OPTIONAL	//Data Inicial do Periodo				
	WSDATA PeriodDtFin			  As Date	OPTIONAL	//Data Final do Periodo
	WSDATA FilterField			  As String	OPTIONAL
	WSDATA FilterValue			  As String	OPTIONAL
	
	WSMETHOD MyObjectives	 	DESCRIPTION STR0002 //"Método de listagem dos Meus Planos de Desenvolvimento Pessoal"
	WSMETHOD MyTeamObjectives   DESCRIPTION STR0003 //"Método de listagem dos Planos de Desenvolvimento Pessoal dos Meus Avaliados"
	WSMETHOD ObjectiveTopics 	DESCRIPTION STR0004	//"Método de listagem dos Topicos RDW dos Objetivos de Plano de Desenvolvimento Pessoal"
	WSMETHOD TopicItens 	 	DESCRIPTION STR0005	//"Método de listagem dos Itens cadastrados pelo participante para um Topicos RDW dos Objetivos de Plano de Desenvolvimento Pessoal"
	WSMETHOD InsertUpdateItem	DESCRIPTION STR0006 //"Método de Inclusao e Alteracao de Item RDJ"
	WSMETHOD DeleteItem			DESCRIPTION	STR0007 //"Método de Exclusao de Item RDJ"
	WSMETHOD CancelaItem		DESCRIPTION	STR0057 //"Método de Cancelamento de Item RDJ"
	WSMETHOD SetUserObjPaper	DESCRIPTION	STR0008 //"Método de gravaçao do papel do usuário no Ojetivo"
	WSMETHOD ApproveFailItem	DESCRIPTION STR0009	//"Método de Aprovacao ou Reprovacao de um Item RDJ"
	WSMETHOD SetStatus			DESCRIPTION STR0010 //"Método de Alteração do Status do Plano (Com o Avaliador ou com o Avaliado) e incremento de versão"
	WSMETHOD AproveObjetive		DESCRIPTION STR0011 //"Método de Aprovação de Objetivo e Exclusao de versões intermediárias"
	WSMETHOD ShowHistory		DESCRIPTION STR0012 //"Método de exibição de propriedades de Planos para montagem de histórico"
	WSMETHOD ShowAllPlans		DESCRIPTION STR0013 //"Método de exibição de todos os Planos cadastrados do tipo desejado"
	WSMETHOD ShowAllParticipant DESCRIPTION STR0014 //"Método de exibição de todos os Participantes cadastrados menos o participante que chamou o método"
	WSMETHOD ShowAllPeriod      DESCRIPTION STR0015	//"Método de exibição de todos os Períodos cadastrados"
	WSMETHOD InsertObjetive		DESCRIPTION STR0016 //"Método de inclusão de Objetivos orientado para o Avaliado"
	WSMETHOD ChkObjetive		DESCRIPTION STR0016 //"Método de inclusão de Objetivos orientado para o Avaliado"
	WSMETHOD GetMessage			DESCRIPTION STR0017 //"Metodo de consulta de mensagem" 
	WSMETHOD GetHeaderRh		DESCRIPTION STR0052 //"Metodo de recuperacao de header"
	WSMETHOD MyPlans			DESCRIPTION STR0055 //"Lista Periodos Disponiveis"
	WSMETHOD MyPairsObjective	DESCRIPTION STR0056 //"Lista Periodos Disponiveis"  
ENDWSSERVICE

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MyObjectives    ³ Autor ³ Thiago dos Reis ³Data ³09.12.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao dos meus Planos de Desenvolvimento     ³±±
±±³          ³Pessoal                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Codigo do Participant e tipo 1=Plano 2=Meta, Status T=todos  ³±±
±±³			 |os planos F= planos nao Finalizados (correntes)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Struct com codigo, titulo, periodo e Status                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD MyObjectives WSRECEIVE UserCode,ParticipantId,TypeId,Status,PeriodID,PeriodDtIni,PeriodDtFin WSSEND ListOfObjective WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nX        := 0
Local nI        := 0
Local nPercent	:= 0
Local nQtdMetas	:= 0
Local nResultOj	:= 0
Local cPers		:= ""
Local cAvaliator:= ""
Local cPeriodo 	:= ""
Local cObjetivo := ""
Local dDataUltAlt := date()

dbSelectArea("RDI")
RDI->(dbSetorder(7))
dbSelectArea("RDV")
RDV->(dbSetOrder(1))
dbSelectArea("RDU")
RDU->(dbSetOrder(1))

//Tratamento para buscar os dados do Periodo FILTRANDO OS PLANOS DE META
PerMetas(::ParticipantId,::PeriodDtIni,::PeriodDtFin,::PeriodID,@cPers)

If RDV->(MsSeek(xFilial("RDV")+::ParticipantId))
	::ListOfObjective := {}
	WHILE !RDV->(EOF()) .and. RDV->RDV_CODPAR = ::ParticipantId 
		If RDV->RDV_CODPER $ cPers
			IF RDI->(MsSeek(xFilial("RDI")+alltrim(::TypeId)+RDV->RDV_CODOBJ)) //VERIFICA SE O OBJETIVO E DO TIPO ESPECIFICADO
				If RDV->RDV_STATUS <> "3" .or. Status == "T" //Se o status for T retorna todos os Planos se for F retorna somente os nao Finalizados (correntes)
					/***********************************************************************
					* VERIFICA PRIMEIRA DATA DE ALTERACAO DA ULTIMA VERSAO
					***********************************************************************/
					RDJ->(dbSetOrder(12))
					If RDJ->(MsSeek(xFilial("RDJ")+::ParticipantId+RDV->RDV_CODOBJ+RDV->RDV_CODPER+RDV->RDV_CODDOR+STR(RDV->RDV_VERATU,5,2)))
						//PEGA A PRIMEIRA DATA PQ ESTA ORDENADO POR DATA
						//E VEM A DATA MAIS ANTIGA NA CONSULTA
						dDataUltAlt := RDJ->RDJ_DATITM
					EndIf
					nQtdMetas	:= 0
					nPercent	:= 0
					nResultOj	:= 0
					
					// Busca de percentuais/totalizadores/Resultados
					While RDJ->(RDJ_FILIAL+RDJ_CODPAR+RDJ_CODOBJ+RDJ_PERIOD+RDJ_CODDOR+STR(RDJ_VERITM,5,2))==(xFilial("RDJ")+::ParticipantId+RDV->RDV_CODOBJ+RDV->RDV_CODPER+RDV->RDV_CODDOR+STR(RDV->RDV_VERATU,5,2))
						If !(RDJ->RDJ_STATUS $ '4/6')
							nQtdMetas	+=	1
							If !Empty(RDJ->RDJ_ITESAT)
								nPercent	+= 1
							EndIf
							If RDJ->(ColumnPos( 'RDJ_RESULT' )) > 0
								nResultOj	+= RDJ->RDJ_RESULT
							EndIF
						EndIF
						 RDJ->(dbSkip())
					EndDo
					
					nPercent:= Round((nPercent/nQtdMetas)*100,2)
					IF RDV->RDV_CODDOR <> cAvaliator .or. RDV->RDV_CODOBJ <> cObjetivo
						cAvaliator 	:= RDV->RDV_CODDOR
						cObjetivo 	:= RDV->RDV_CODOBJ
						cPeriodo 	:= RDV->RDV_CODPER
						
						nx++
						aadd(::ListOfObjective,WsClassNew('Objective'))
						::ListOfObjective[nx]:ObjectiveID 		   		:= RDI->RDI_CODIGO
						::ListOfObjective[nx]:ObjectiveDescr 			:= ALLTRIM(RDI->RDI_DESC)
						::ListOfObjective[nx]:ObjectiveAvaliaterID 		:= RDV->RDV_CODDOR
						::ListOfObjective[nx]:LastApprove		 		:= RDV->RDV_DTAPRO
						::ListOfObjective[nx]:ObjectiveGoal		 		:= nQtdMetas
						::ListOfObjective[nx]:ObjectivePercent	 		:= nPercent
						::ListOfObjective[nx]:ObjectiveResult	 		:= nResultOj
						
						dbSelectArea("RD0")
						RD0->(dbSetOrder(1))
						If RD0->(MsSeek(xFilial("RD0")+RDV->RDV_CODDOR))
						if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
							::ListOfObjective[nx]:ObjectiveAvaliaterName := ALLTRIM(SRA->RA_NOMECMP)
						Else
							::ListOfObjective[nx]:ObjectiveAvaliaterName := ALLTRIM(RD0->RD0_NOME)
						EndIf
						Else
							::ListOfObjective[nx]:ObjectiveAvaliaterName := ""
						EndIf
						
						::ListOfObjective[nx]:ObjectiveAvaliatedID		:= RDV->RDV_CODPAR
						::ListOfObjective[nx]:ObjectiveAvaliatedName	:= STR0018 //"Proprio participante logado"
						::ListOfObjective[nx]:ObjectiveStatus	 		:= RDV->RDV_STATUS
						::ListOfObjective[nx]:ObjectivePeriod 			:= {}
						
						nI := 0
						nI++
						aadd(::ListOfObjective[nx]:ObjectivePeriod,WsClassNew('Period'))
						::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodID			:= RDV->RDV_CODPER
						::ListOfObjective[nx]:ObjectivePeriod[nI]:Status			:= RDV->RDV_STATUS
						::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodObjVersion	:= STR(RDV->RDV_VERATU,5,2)
						::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtAlt		:= dDataUltAlt //DATA DA PRIMEIRA ALTERACAO DA VERSAO ATUAL
						
						If RDU->(MsSeek(xFilial("RDU")+RDV->RDV_CODPER))
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr			:= ALLTRIM(RDU->RDU_DESC)
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtIni			:= RDU->RDU_DATINI //Data Inicial do Plano
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtFin			:= RDU->RDU_DATFIM //Data Final do Plano
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeIniAval	:= RDU->RDU_INIPLA //Qtde de dias para iniciar o plano
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeEditAval	:= RDU->RDU_EDTPLA //Qtde de dias para aprovar o plano apos a primeira edicao e aprovacao e uma nova edicao
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeFinAval	:= RDU->RDU_FIMPLA //Qtde de dias para finalizar o plano
						Else
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr	:=  ""
							SetSoapFault("MyObjectives",STR0020)									 //"Codigo de Periodo nao encontrado na RDU"
						Endif
					ElseIf RDV->RDV_CODPER <> cPeriodo
						cPeriodo := RDV->RDV_CODPER
						nI++
						aadd(::ListOfObjective[nx]:ObjectivePeriod,WsClassNew('Period'))
						::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodID			:= RDV->RDV_CODPER
						::ListOfObjective[nx]:ObjectivePeriod[nI]:Status			:= RDV->RDV_STATUS
						::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodObjVersion	:= STR(RDV->RDV_VERATU,5,2)
						::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtAlt		:= dDataUltAlt //DATA DA PRIMEIRA ALTERACAO DA VERSAO ATUAL
						
						If RDU->(MsSeek(xFilial("RDU")+RDV->RDV_CODPER))
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr			:= ALLTRIM(RDU->RDU_DESC)
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtIni			:= RDU->RDU_DATINI //Data Inicial do Plano
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtFin			:= RDU->RDU_DATFIM //Data Final do Plano
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeIniAval	:= RDU->RDU_INIPLA //Qtde de dias para iniciar o plano
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeEditAval	:= RDU->RDU_EDTPLA //Qtde de dias para aprovar o plano apos a primeira edicao e aprovacao e uma nova edicao
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeFinAval	:= RDU->RDU_FIMPLA //Qtde de dias para finalizar o plano
						Else
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr	:=  ""
							SetSoapFault("MyObjectives",STR0020)														 //"Codigo de Periodo nao encontrado na RDU"
						EndIf
					EndIf
				EndIf
			Endif
		EndIf
		RDV->(dbSkip())
	EndDo
ELSE
	lRetorno := .F.
	SetSoapFault("MyObjectives",STR0021) //"Participante nao encontrado na RDV"
ENDIF


Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MyTeamObjectives ³ Autor ³ Thiago dos Reis ³Data ³10.12.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao dos Planos de Desenvolvimento          ³±±
±±³          ³Pessoal dos meus avaliados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Codigo do Participant (Avaliador) e tipo 1=Plano 2=Meta      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Struct com codigo, titulo, periodo e Status                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD MyTeamObjectives WSRECEIVE UserCode,AvaliatorId,TypeId,Status,PeriodID,PeriodDtIni,PeriodDtFin,FilterField,FilterValue WSSEND ListOfObjective WSSERVICE RHPersonalDesenvPlan

Local lRetorno  	:= .T.
Local nX        	:= 0
Local nI        	:= 0
Local nIdBusca		:= 2
Local nPercent		:= 0
Local nQtdMetas		:= 0
Local nResultOj		:= 0
Local cFiltro		:= ""
Local cPers			:= ""
Local cParts		:= ""
Local cParticipant	:= ""
Local cObjetivo	 	:= ""
Local cPeriodo	 	:= ""
Local dDataUltAlt 	:= date()

dbSelectArea("RDI")
RDI->(dbSetorder(7))
dbSelectArea("RDV")
RDV->(dbSetOrder(2))
dbSelectArea("RDU")
RDU->(dbSetOrder(1))


//Filtro quando feito pesquisa na pagina
if !Empty(::FilterField) .And. !Empty(::FilterValue)
	cFiltro:= ::FilterField+" Like " + "('%"+::FilterValue+"%')"
EndIf
//Tratamento para buscar os dados do Periodo FILTRANDO OS PLANOS DE META
PerMetas(::AvaliatorId,::PeriodDtIni,::PeriodDtFin,::PeriodID,@cPers,cFiltro,@cParts,nIdBusca)

IF !Empty(::UserCode) .and. !Empty(::AvaliatorId) .and. !Empty(::TypeId) //VERIFICA SE TODOS OS PARAMETROS DE ENTRADA FORAM ENVIADOS
	If RDV->(MsSeek(xFilial("RDV")+::AvaliatorId)) 
		::ListOfObjective := {}
		WHILE !RDV->(EOF()) .and. RDV->RDV_CODDOR = ::AvaliatorId
			If RDV->RDV_CODPAR $ cParts .And. RDV->RDV_CODPER $ cPers
				IF RDI->(MsSeek(xFilial("RDI")+alltrim(::TypeId)+RDV->RDV_CODOBJ)) //VERIFICA SE O OBJETIVO E DO TIPO ESPECIFICADO
					If (RDV->RDV_STATUS <> "3" .Or. (Status == "3" .And. RDV->RDV_STATUS == "3")) //SE NAO ESTIVER FINALIZADO OU SE STATUS VIR COMO FINALIZADO
						//IF RDV->RDV_STATUS == Status
						/***********************************************************************
						* VERIFICA PRIMEIRA DATA DE ALTERACAO DA ULTIMA VERSAO
						***********************************************************************/
						RDJ->(dbSetOrder(12))
						If RDJ->(MsSeek(xFilial("RDJ")+RDV->RDV_CODPAR+RDV->RDV_CODOBJ+RDV->RDV_CODPER+RDV->RDV_CODDOR+STR(RDV->RDV_VERATU,5,2)))
							//PEGA A PRIMEIRA DATA PQ ESTA ORDENADO POR DATA
							//E VEM A DATA MAIS ANTIGA NA CONSULTA
							dDataUltAlt := RDJ->RDJ_DATITM
						EndIf
						
						nQtdMetas	:= 0
						nPercent	:= 0
						nResultOj	:= 0
						
						// Busca de percentuais/totalizadores/Resultados
						While RDJ->(RDJ_FILIAL+RDJ_CODPAR+RDJ_CODOBJ+RDJ_PERIOD+RDJ_CODDOR+STR(RDJ_VERITM,5,2))==(xFilial("RDJ")+RDV->RDV_CODPAR+RDV->RDV_CODOBJ+RDV->RDV_CODPER+RDV->RDV_CODDOR+STR(RDV->RDV_VERATU,5,2))
							If !(RDJ->RDJ_STATUS $ '4/6')
								nQtdMetas	+=	1
								If !Empty(RDJ->RDJ_ITESAT)
									nPercent	+= 1
								EndIf
								If RDJ->(ColumnPos( "RDJ_RESULT" )) > 0
									nResultOj	+= RDJ->RDJ_RESULT
								EndIF
							EndIF
							RDJ->(dbSkip())
						EndDo
						nPercent:= Round((nPercent/nQtdMetas)*100,2)
						IF RDV->RDV_CODPAR <> cParticipant .or. RDV->RDV_CODOBJ <> cObjetivo  //VERIFICA SE O OBJETIVO OU O PARTICIPANTE E DIFERENTE DO ANTERIOR
							cParticipant := RDV->RDV_CODPAR
							cObjetivo := RDV->RDV_CODOBJ
							cPeriodo := RDV->RDV_CODPER
							
							nx++
							aadd(::ListOfObjective,WsClassNew('Objective'))
							::ListOfObjective[nx]:ObjectiveID 			:= RDV->RDV_CODOBJ
							::ListOfObjective[nx]:ObjectiveDescr 		:= ALLTRIM(RDI->RDI_DESC)
							::ListOfObjective[nx]:ObjectiveStatus		:= RDV->RDV_STATUS
							::ListOfObjective[nx]:ObjectiveAvaliaterID	:= RDV->RDV_CODDOR
							::ListOfObjective[nx]:ObjectiveAvaliatedID	:= RDV->RDV_CODPAR
							::ListOfObjective[nx]:LastApprove			:= RDV->RDV_DTAPRO
							::ListOfObjective[nx]:ObjectiveGoal		 	:= nQtdMetas
							::ListOfObjective[nx]:ObjectivePercent	 	:= nPercent
							::ListOfObjective[nx]:ObjectiveResult	 	:= nResultOj
							dbSelectArea("RD0")
							RD0->(dbSetOrder(1))
							If RD0->(MsSeek(xFilial("RD0")+RDV->RDV_CODPAR))
								::ListOfObjective[nx]:ObjectiveAvaliatedName := ALLTRIM(RD0->RD0_NOME)
							Else
								::ListOfObjective[nx]:ObjectiveAvaliatedName := ""
							EndIf
							::ListOfObjective[nx]:ObjectivePeriod 	:= {}
							
							nI := 0
							nI++
							aadd(::ListOfObjective[nx]:ObjectivePeriod,WsClassNew('Period'))
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodID			:= RDV->RDV_CODPER
							::ListOfObjective[nx]:ObjectivePeriod[nI]:Status			:= RDV->RDV_STATUS
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodObjVersion	:= STR(RDV->RDV_VERATU,5,2)
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtAlt		:= dDataUltAlt //DATA DA PRIMEIRA ALTERACAO DA VERSAO ATUAL
							
							If RDU->(MsSeek(xFilial("RDU")+RDV->RDV_CODPER))
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr			:= ALLTRIM(RDU->RDU_DESC)
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtIni			:= RDU->RDU_DATINI //Data Inicial do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtFin			:= RDU->RDU_DATFIM //Data Final do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeIniAval	:= RDU->RDU_INIPLA //Qtde de dias para iniciar o plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeEditAval	:= RDU->RDU_EDTPLA //Qtde de dias para aprovar o plano apos a primeira edicao e aprovacao e uma nova edicao
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeFinAval	:= RDU->RDU_FIMPLA //Qtde de dias para finalizar o plano
							Else
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr	:=  ""
							Endif
						ElseIf RDV->RDV_CODPER <> cPeriodo
							cPeriodo := RDV->RDV_CODPER
							nI++
							aadd(::ListOfObjective[nx]:ObjectivePeriod,WsClassNew('Period'))
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodID			:= RDV->RDV_CODPER
							::ListOfObjective[nx]:ObjectivePeriod[nI]:Status			:= RDV->RDV_STATUS
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodObjVersion	:= STR(RDV->RDV_VERATU,5,2)
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtAlt		:= dDataUltAlt //DATA DA PRIMEIRA ALTERACAO DA VERSAO ATUAL
							
							If RDU->(MsSeek(xFilial("RDU")+RDV->RDV_CODPER))
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr	:=  ALLTRIM(RDU->RDU_DESC)
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtIni			:= RDU->RDU_DATINI //Data Inicial do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtFin			:= RDU->RDU_DATFIM //Data Final do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeIniAval	:= RDU->RDU_INIPLA //Qtde de dias para iniciar o plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeEditAval	:= RDU->RDU_EDTPLA //Qtde de dias para aprovar o plano apos a primeira edicao e aprovacao e uma nova edicao
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeFinAval	:= RDU->RDU_FIMPLA //Qtde de dias para finalizar o plano
								
							Else
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr	:=  ""
							EndIf
						EndIf
					EndIf
				EndIf
			EndIF
			RDV->(dbSkip())
		EndDo
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("MyTeamObjectives",STR0022) //"Faltando parametros de entrada no metodo."
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ObjectiveTopics ³ Autor ³ Thiago dos Reis ³Data ³07.12.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao dos Topicos de Plano de Des. Pessoal   ³±±
±±³          ³disponiveis para cada Plano                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Plano, Participant, periodo e Avaliator					   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Struct com codigo, titulo e tipo de tela                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ObjectiveTopics WSRECEIVE UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId WSSEND ListOfObjTopics WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nX        := 0
Local nI		:= 0
Local aStatus	:= {}
Local nTamanho	:= 0
Local aLider	:= {}
Local cCodVis	:= ""
Local cIteVis	:= ""

If !Empty(::UserCode) .and. !Empty(::ObjID) .and. !Empty(::ParticipantId) .and. !Empty(::PeriodID) .and. !Empty(::AvaliatorId)
	
	dbSelectArea("RDI")
	RDI->(dbSetOrder(1))
	If RDI->(MsSeek(xFilial("RDI")+::ObjID))
		::ListOfObjTopics:DescrObjectivies	:= alltrim(RDI->RDI_DESC)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ RETORNAR O LIDER HIERARQUICO DO AVALIADO CONFORME VISAO |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If RDI->( FieldPos("RDI_VISAO") ) > 0
			cCodVis := RDI->RDI_VISAO
		Else
			::ListOfObjTopics:PartLeader 	:= "NOFIELD"
		EndIf
		
		If !Empty(cCodVis)
			RDE->(MsSeek(xFilial("RDE")+::ParticipantId+cCodVis ,.T.))
			cIteVis := ""
			While !RDE->( Eof() ) .And. ::ParticipantId+cCodVis == RDE->RDE_CODPAR+RDE->RDE_CODVIS
				If RDE->RDE_STATUS == "1" //SE STATUS ATUAL ESTA ATIVO
					cIteVis := RDE->RDE_ITEVIS
					Exit
				EndIf
				RDE->( dbSkip() )
			EndDo
			
			aLider := {}
			ApdaDorNivel( cIteVis , xFilial("RDE") ,cCodVis , "2" , 1, aLider )
			
			If Len(aLider) > 0
				::ListOfObjTopics:PartLeaderId 	:= aLider[1][1]
				::ListOfObjTopics:PartLeader 	:= FDesc("RD0", aLider[1][1], "RD0_NOME")
			Else
				::ListOfObjTopics:PartLeaderId 	:= ""
				::ListOfObjTopics:PartLeader 	:= ""
			EndIf
		EndIf
		//--------
	ELSE
		SetSoapFault("ObjectiveTopics",STR0023) //"Codigo de Plano nao encontrado na RDI"
		Return .F.
	ENDIF
	
	dbSelectArea("RDU")
	RDU->(dbSetOrder(1))
	
	If RDU->(MsSeek(xFilial("RDU")+::PeriodID))
		::ListOfObjTopics:PeriodDescr	:= AllTrim(RDU->RDU_DESC)
		::ListOfObjTopics:PeriodDtIni	:= RDU->RDU_DATINI
		::ListOfObjTopics:PeriodDtFin	:= RDU->RDU_DATFIM
		
		if RDU->(ColumnPos( 'RDU_INIINC' )) > 0  
			::ListOfObjTopics:PerIncIni		:= RDU->RDU_INIINC
			::ListOfObjTopics:PerIncFim		:= RDU->RDU_FIMINC
			::ListOfObjTopics:PerMntResIni	:= RDU->RDU_INIRES
			::ListOfObjTopics:PerMntResFim	:= RDU->RDU_FIMRES
		Else
			::ListOfObjTopics:PerIncIni		:= ctod("//")
			::ListOfObjTopics:PerIncFim		:= ctod("//")
			::ListOfObjTopics:PerMntResIni	:= ctod("//")
			::ListOfObjTopics:PerMntResFim	:= ctod("//")
		EndIf
		
		::ListOfObjTopics:PerTipo		:= RDU->RDU_TIPO
		
		// SE ESTIVER DENTRO DO PRAZO PARA FINALIZACAO
		If Date() > ( RDU->RDU_DATFIM - RDU->RDU_FIMPLA )
			::ListOfObjTopics:PermissionFinal	:= .T.
		Else
			::ListOfObjTopics:PermissionFinal	:= .F.
		EndIf
	ELSE
		SetSoapFault("ObjectiveTopics",STR0020) //"Codigo de periodo nao encontrado na RDU"
		Return .F.
	ENDIF
	
	dbSelectArea("RD0")
	RD0->(dbSetOrder(1))
	If RD0->(MsSeek(xFilial("RD0")+::ParticipantId))
			if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
				::ListOfObjTopics:NameAvaliado	:= alltrim(SRA->RA_NOMECMP)
			Else
				::ListOfObjTopics:NameAvaliado	:= alltrim(RD0->RD0_NOME)
			EndIf
	ELSE
		SetSoapFault("ObjectiveTopics",STR0024) //"Codigo de PARTICIPANTE nao encontrado na RD0"
		Return .F.
	ENDIF
	
	
	dbSelectArea("RDV")
	RDV->(dbSetOrder(1))
	
	if RDV->(MsSeek(xFilial("RDV")+::ParticipantId+::ObjID+::AvaliatorId+::PeriodID))
		::ListOfObjTopics:IDAvaliador		:= ::AvaliatorId
		::ListOfObjTopics:DescrParticipant	:= ApdMsMm(RDV->RDV_CODPAP)
		::ListOfObjTopics:Status			:= RDV->RDV_STATUS //SE O PLANO ESTA NA POSSE DO AVALIADO OU DO REVIDOR
		::ListOfObjTopics:PlanVersion		:= Str(RDV->RDV_VERATU,5,2)
		::ListOfObjTopics:LastApprove		:= RDV->RDV_DTAPRO
				
		If RD0->(MsSeek(xFilial("RD0")+::AvaliatorId))
			
			if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
				::ListOfObjTopics:NameAvaliador	:= SRA->RA_NOMECMP
			Else
				::ListOfObjTopics:NameAvaliador	:= RD0->RD0_NOME
			EndIf
		Else
			SetSoapFault("ObjectiveTopics",STR0025)	 //"Codigo do Avaliador nao encontrado na RD0"
			Return .F.
		Endif
	ELSE
		SetSoapFault("ObjectiveTopics",STR0026) //"Codigo de Participante, Objetivo, Avaliador e Periodo nao encontrado na RDV"
		Return .F.
	ENDIF
	
	
	dbSelectArea("RDW")
	RDW->(dbSetOrder(1))
	dbSelectArea("RDJ")
	RDJ->(dbSetOrder(11))
	
	::ListOfObjTopics:SubPlan	:= {}
	
	IF RDW->(MsSeek(xFilial("RDW")+::ObjID))
		aadd( ::ListOfObjTopics:PlanRevision , "1")	// 1=pode liberar / incluido aqui pois caso nao encontre
		// nenhum item com autor diferente do logado iria retornar
		// array vazio, entao coloca-se esse "1" para indicar que
		While !RDW->(Eof()) .AND. ALLTRIM(RDW->RDW_CODOBJ) == alltrim(::ObjID)
			nx++
			aadd(::ListOfObjTopics:SubPlan,WsClassNew('SubPlans'))
			
			::ListOfObjTopics:SubPlan[nx]:PanID			:= RDW->RDW_CODOBJ
			::ListOfObjTopics:SubPlan[nx]:ItemID		:= RDW->RDW_ITEM
			::ListOfObjTopics:SubPlan[nx]:DescrItem		:= alltrim(RDW->RDW_DESCIT)
			::ListOfObjTopics:SubPlan[nx]:TipoItem		:= RDW->RDW_TIPO
			::ListOfObjTopics:SubPlan[nx]:TpCurso		:= RDW->RDW_TPCURS
			if RDW->(ColumnPos( "RDW_LIMMET" )) > 0 .And. RDW->(ColumnPos( "RDW_LIMPES" ))>0
			    ::ListOfObjTopics:SubPlan[nx]:LimitMt   := RDW->RDW_LIMMET
			    ::ListOfObjTopics:SubPlan[nx]:LimitPes  := RDW->RDW_LIMPES
			Else
			    ::ListOfObjTopics:SubPlan[nx]:LimitMt   := 9999
			    ::ListOfObjTopics:SubPlan[nx]:LimitPes  := 9999
		    EndIf
			If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId+RDW->RDW_ITEM+::ListOfObjTopics:PlanVersion))
				aStatus := {}
				While !RDJ->(EOF()) .and. RDJ->RDJ_CODOBJ == ::ObjID .and. RDJ->RDJ_PERIOD == ::PeriodID .and. RDJ->RDJ_CODPAR == ::ParticipantId .and. RDJ->RDJ_ITOBJ == RDW->RDW_ITEM .and. STR(RDJ_VERITM,5,2) == ::ListOfObjTopics:PlanVersion
					aadd( aStatus, {RDJ->RDJ_STATUS, RDJ->RDJ_AUTOR})
					
					//CONSULTA QUAL A DATA PROXIMA DE MODIFICACAO
					If Empty(::ListOfObjTopics:LastUpdate) .Or. ::ListOfObjTopics:LastUpdate < RDJ->RDJ_DATITM
						::ListOfObjTopics:LastUpdate := RDJ->RDJ_DATITM
					EndIf
					::ListOfObjTopics:ItenPerPend:= .F.
					//CONSULTA PERCENTUAL DE ATINGIMENTO NÃO PREENCHIDO
					If Empty(RDJ->RDJ_ITESAT) .And. RDJ->RDJ_TIPO <> '3'
						::ListOfObjTopics:ItenPerPend := .T.
					EndIf
					RDJ->(dbSkip())
				EndDo
				
				If AScan(aStatus, {|x| x[1] == "3"}) > 0 //se encontrar o numero 3 no array
					::ListOfObjTopics:SubPlan[nx]:PanStatus	:= "3"
				ElseIf AScan(aStatus, {|x| x[1] == "1"}) > 0
					::ListOfObjTopics:SubPlan[nx]:PanStatus	:= "1"
				ElseIf AScan(aStatus, {|x| x[1] == "2"}) > 0
					::ListOfObjTopics:SubPlan[nx]:PanStatus	:= "2"
				ElseIf AScan(aStatus, {|x| x[1] == "4"}) > 0
					::ListOfObjTopics:SubPlan[nx]:PanStatus	:= "4"
				Else
					::ListOfObjTopics:SubPlan[nx]:PanStatus	:= "0"
				EndIf
				
				nTamanho := len(aStatus)
				If nTamanho > 0
					For nI := 1 to nTamanho
						If aStatus[nI][2] <> ::ListOfObjTopics:Status
							If aStatus[nI][1] == "3" .or. aStatus[nI][1] == "1"
								aadd( ::ListOfObjTopics:PlanRevision , "0") //nao pode Liberar
							Else
								aadd( ::ListOfObjTopics:PlanRevision , "1") //pode Liberar
							Endif
						Endif
					Next
				EndIf
			Else
				::ListOfObjTopics:SubPlan[nx]:PanStatus	:= "0"
			EndIf
			RDW->(dbSkip())
		EndDo
		lRetorno := .T.
	ENDIF
	
	::ListOfObjTopics:HierarqLevel 	  := getNivelCarreira(::ParticipantId)[2]
	::ListOfObjTopics:Area	 		  := getFunCCDesc(::ParticipantId)
	
Else
	lRetorno := .F.
	SetSoapFault("ObjectiveTopics", STR0027) //"Faltando parametros de entrada"
Endif

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    |   TopicItens    ³ Autor ³ Thiago dos Reis ³Data ³08.12.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao dos Itens do Topico de Plano de Desenv.³±±
±±³          ³Pessoal Cadastrados pelo participante                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Codigo do Plano, do Topico e do Participant                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Struct com os dados do Item                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD TopicItens WSRECEIVE UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion,TopicID,Status WSSEND ListOfTopicItens WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nX        := 0
Local nT		:= 0
Local cTipo		:= ""

dbSelectArea("RDJ")
RDJ->(dbSetOrder(11))

::ListOfTopicItens:ItemList := {}

If Empty(::TopicID)
	::TopicID := space(TamSX3("RDJ_ITOBJ")[1])
EndIf

If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId+::TopicID+::PlanVersion))
	WHILE !RDJ->(EOF()) .and. RDJ->RDJ_CODOBJ == ::ObjID .and. RDJ->RDJ_PERIOD == ::PeriodID .and. RDJ->RDJ_CODPAR == ::ParticipantId .and. RDJ->RDJ_CODDOR == ::AvaliatorId .and. RDJ->RDJ_ITOBJ == ::TopicID .and. STR(RDJ->RDJ_VERITM,5,2) == PlanVersion
		If RDJ->RDJ_STATUS <> "5" .AND. RDJ->RDJ_STATUS <> "6"
			nX++
			aadd(::ListOfTopicItens:ItemList,WsClassNew('Item'))

			::ListOfTopicItens:ItemList[nX]:ItemID 			:= RDJ->RDJ_ITEM
			::ListOfTopicItens:ItemList[nX]:Status			:= RDJ->RDJ_STATUS
			cTeste := StrTran( ApdMsMm( RDJ->RDJ_CODMEM ), Chr( 10 ), "<br>" )
			cTeste := StrTran(cTeste,"'","" ) 
			cTeste := StrTran(cTeste,'"',"" )
			::ListOfTopicItens:ItemList[nX]:ItemDescr		:= cTeste
			::ListOfTopicItens:ItemList[nX]:ValidatorObs	:= ApdMsMm( RDJ->RDJ_CODDER )
			::ListOfTopicItens:ItemList[nX]:FinishDate		:= RDJ->RDJ_DTFIM
			::ListOfTopicItens:ItemList[nX]:InitDate		:= RDJ->RDJ_DTINI
			::ListOfTopicItens:ItemList[nX]:ItemDate		:= RDJ->RDJ_DATITM
			::ListOfTopicItens:ItemList[nX]:Relevance		:= RDJ->RDJ_ITESCR
			::ListOfTopicItens:ItemList[nX]:PercentID		:= RDJ->RDJ_ITESAT
			::ListOfTopicItens:ItemList[nX]:ItemPlanVersion	:= STR(RDJ->RDJ_VERITM,5,2)
			::ListOfTopicItens:ItemList[nX]:Author			:= RDJ->RDJ_AUTOR //Autor (1=avaliado 2=avaliador)
			If RDJ->(ColumnPos( "RDJ_RESULT" )) > 0
				::ListOfTopicItens:ItemList[nX]:ResultDone		:= RDJ->RDJ_RESULT
			Else
				::ListOfTopicItens:ItemList[nX]:ResultDone		:= 0
			EndIf
			
			dbSelectArea("RBL")
			RBL->(dbSetOrder(1))
			If RBL->(MsSeek(xFilial("RBL")+RDJ->RDJ_ESCATG+RDJ->RDJ_ITESAT))
				::ListOfTopicItens:ItemList[nX]:PercentDone	:= ALLTRIM(RBL->RBL_DESCRI) //RBL->RBL_ITEM
			Else
				::ListOfTopicItens:ItemList[nX]:PercentDone		:= ""
			EndIf
			
			If RBL->(MsSeek(xFilial("RBL")+RDJ->RDJ_ESCREA+RDJ->RDJ_ITESCR))
				::ListOfTopicItens:ItemList[nX]:Peso		:= RBL->RBL_VALOR
			EndIf
			
			If (RDJ->RDJ_STATUS == '4'.Or. Empty(::ListOfTopicItens:ItemList[nX]:Peso))
				::ListOfTopicItens:ItemList[nX]:Peso			:= 0			
			EndIf
			
			If !Empty(RDJ->RDJ_CURSO)
				SQX->( dbSetOrder(1) )
				If SQX->( MsSeek(xFilial("SQX")+RDJ->RDJ_TPCURS) )
					::ListOfTopicItens:ItemList[nX]:TypeCourseDescr	:= SQX->QX_DESC
				EndIf
				::ListOfTopicItens:ItemList[nX]:CourseValue		:= alltrim(RDJ->RDJ_VALOR)
				::ListOfTopicItens:ItemList[nX]:CourseDuration	:= RDJ->RDJ_DURACA
				::ListOfTopicItens:ItemList[nX]:CourseId 		:= RDJ->RDJ_CURSO

				If RDJ->( FieldPos("RDJ_TIPO") ) > 0 .And. RDJ->RDJ_TIPO == "5"	//Capacitacao interna

					dbSelectArea("RA1")
					dbSetOrder(1)
					If MsSeek(xFilial("RA1")+AllTrim(RDJ->RDJ_CURSO))
						::ListOfTopicItens:ItemList[nX]:CourseDescr := ALLTRIM(RA1->RA1_DESC)
					EndIf

				Else
					dbSelectArea("SQT")
					SQT->(dbSetOrder(1))
					If SQT->(MsSeek(xFilial("SQT")+RDJ->RDJ_CURSO))
						::ListOfTopicItens:ItemList[nX]:CourseDescr 	:= ALLTRIM(SQT->QT_DESCRIC)
						::ListOfTopicItens:ItemList[nX]:TypeCourseId 	:= SQT->QT_TIPO

						//PEGA TODOS OS CURSOS COM O TIPO DE CURSO CORRESPONDENTE AO RDJ->RDJ_CURSO
						cTipo := SQT->QT_TIPO
						SQT->(dbSetOrder(3))
						If SQT->(MsSeek(xFilial("SQT")+cTipo))
							::ListOfTopicItens:ItemList[nX]:CourseList := {}
							nT := 0
							While !SQT->(EOF()) .And. xFilial("SQT") == SQT->QT_FILIAL .And. cTipo == SQT->QT_TIPO
								If AllTrim(Upper(SQT->QT_DESCRIC)) != AllTrim(Upper(STR0051)) //"OUTROS"
									nT++
								    aadd(::ListOfTopicItens:ItemList[nX]:CourseList,WSCLASSNEW("Course"))

								    ::ListOfTopicItens:ItemList[nX]:CourseList[nT]:CourseId 	:= SQT->QT_CURSO
								    ::ListOfTopicItens:ItemList[nX]:CourseList[nT]:CourseDescr := SQT->QT_DESCRIC
								EndIf
								SQT->(dbSkip())
							EndDo

							//Ordenar por Descricao
							Asort( ::ListOfTopicItens:ItemList[nX]:CourseList,,, {|x,y| x:CourseId < y:CourseId } )

							//Inclusao do Curso "OUTROS" se houver na base
							SQT->(dbSetOrder(2))
							If SQT->(MsSeek(xFilial("SQT")+AllTrim(Upper(STR0051))))
								nT++
								aadd(::ListOfTopicItens:ItemList[nX]:CourseList,WSCLASSNEW("Course"))

							    ::ListOfTopicItens:ItemList[nX]:CourseList[nT]:CourseId 	:= SQT->QT_CURSO
							    ::ListOfTopicItens:ItemList[nX]:CourseList[nT]:CourseDescr := SQT->QT_DESCRIC
							EndIf

						EndIf
					EndIf

				EndIf
			EndIf

   			Asort( ::ListOfTopicItens:ItemList,,, {|x,y| x:ItemID < y:ItemID } )

		EndIf

		RDJ->(dbSkip())
	ENDDO

ELSE
	aadd(::ListOfTopicItens:ItemList,WsClassNew('Item'))
	::ListOfTopicItens:ItemList[1]:ItemID 			:= ""
	::ListOfTopicItens:ItemList[1]:Status			:= ""
	::ListOfTopicItens:ItemList[1]:ItemDescr		:= ""
	::ListOfTopicItens:ItemList[1]:ValidatorObs		:= ""
	::ListOfTopicItens:ItemList[1]:FinishDate		:= date()
	::ListOfTopicItens:ItemList[1]:InitDate			:= date()
	::ListOfTopicItens:ItemList[1]:ItemDate			:= date()
	::ListOfTopicItens:ItemList[1]:Relevance		:= ""
	::ListOfTopicItens:ItemList[1]:PercentID		:= ""
	::ListOfTopicItens:ItemList[1]:PercentDone		:= ""
	::ListOfTopicItens:ItemList[1]:ItemPlanVersion	:= ""
	::ListOfTopicItens:ItemList[1]:Author			:= ""
	::ListOfTopicItens:ItemList[1]:TypeCourseId		:= ""
ENDIF


dbSelectArea("RDI")
RDI->(dbSetOrder(1))
If RDI->(MsSeek(xFilial("RDI")+alltrim(::ObjID)))

	nX := 1
	::ListOfTopicItens:RelevanceList := {}

	dbSelectArea("RBL")
	RBL->(dbSetOrder(1))

	If RBL->(MsSeek(xFilial("RBL") + RDI->RDI_ESCREL))
		While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+RDI->RDI_ESCREL
			aadd(::ListOfTopicItens:RelevanceList,WsClassNew('Alternative'))
			::ListOfTopicItens:RelevanceList[nX]:EscaleID	   := RDI->RDI_ESCREL
			::ListOfTopicItens:RelevanceList[nX]:AlternativeID:= RBL->RBL_ITEM
			::ListOfTopicItens:RelevanceList[nX]:Alternative  := alltrim(RBL->RBL_DESCRI)
			::ListOfTopicItens:RelevanceList[nX]:Percentage   := RBL->RBL_VALOR
			nX ++
			RBL->(dbSkip())
		EndDo
    
	    nX := 1
	    ::ListOfTopicItens:PercentList := {}
	
		If RBL->(MsSeek(xFilial("RBL") + RDI->RDI_ESCATG))
			While !(RBL->(Eof())) .And. RBL->RBL_FILIAL+RBL->RBL_ESCALA==xFilial("RBL")+RDI->RDI_ESCATG
				aadd(::ListOfTopicItens:PercentList,WsClassNew('Alternative'))
				::ListOfTopicItens:PercentList[nX]:EscaleID	     := RDI->RDI_ESCATG
				::ListOfTopicItens:PercentList[nX]:AlternativeID:= RBL->RBL_ITEM
				::ListOfTopicItens:PercentList[nX]:Alternative  := alltrim(RBL->RBL_DESCRI)
				::ListOfTopicItens:PercentList[nX]:Percentage   := RBL->RBL_VALOR
				nX ++
				RBL->(dbSkip())
			EndDo
	    Else
	    	lRetorno := .F.
			SetSoapFault("TopicItens",STR0053) //"Itens Escala/Importancia" # "Lista de Porcentagem atinginda (realizada) nao encontrada na RBL"
	    EndIf
	Else
    	lRetorno := .F.
		SetSoapFault("TopicItens",STR0054) //"Itens Escala/Importancia" # "Lista de Grau de Relevancia do Topico nao encontrada na RBL"
    EndIf
Else
	lRetorno := .F.
	SetSoapFault("TopicItens",STR0023) //"Codigo de Plano nao encontrado na RDI"
EndIf

If !Empty(::TopicID)
	dbSelectArea("RDW")
	RDW->(dbSetOrder(1))
	dbSelectArea("SQT")
	SQT->(dbSetOrder(3))

	If RDW->(MsSeek(xFilial("RDW")+::ObjID+::TopicID))
		If ( (RDW->RDW_TIPO == "2" .Or. RDW->RDW_TIPO == "4") .and. VAL(RDW->RDW_TPCURS) != 0) .or. !Empty(Status)   // se a RDW tiver um tipo de curso, traz os cursos
			If Empty(Status)
				Status := RDW->RDW_TPCURS
			EndIf
			If SQT->(MsSeek(xFilial("SQT")+Status))
			    nX := 1
			    //INCLUI APENAS O TIPO DE CURSO QUE ESTA CADASTRADO NA RDW
				SQX->( dbSetOrder(1) )
				If SQX->( MsSeek( xFilial("SQX")+Status ) )
					::ListOfTopicItens:TypeCourseList := {}
					AADD(::ListOfTopicItens:TypeCourseList,WsClassNew('Course'))
					::ListOfTopicItens:TypeCourseList[1]:CourseId		:= SQX->QX_CODIGO
					::ListOfTopicItens:TypeCourseList[1]:CourseDescr	:= ALLTRIM(SQX->QX_DESC)
				EndIf

				//INCLUI LISTA DE CURSOS REFERENTE AO TIPO DE CURSO PRE CADASTRADO
			    ::ListOfTopicItens:CourseList := {}

		   	    WHILE !SQT->(EOF()) .AND. AllTrim(SQT->QT_TIPO) == AllTrim(Status)
					If AllTrim(Upper(SQT->QT_DESCRIC)) != AllTrim(Upper(STR0051)) //"OUTROS"
		    			aadd(::ListOfTopicItens:CourseList,WsClassNew('Course'))
						::ListOfTopicItens:CourseList[nX]:CourseId		:= SQT->QT_CURSO
						::ListOfTopicItens:CourseList[nX]:CourseDescr	:= ALLTRIM(SQT->QT_DESCRIC)
						nX++
					EndIf
					SQT->(DbSkip())
				ENDDO

				//Ordenacao do array de cursos por Descricao
				Asort( ::ListOfTopicItens:CourseList,,, {|x,y| x:CourseDescr < y:CourseDescr } )

				//Inclusao do Curso "OUTROS" se houver na base
				SQT->(dbSetOrder(2))
				If SQT->(MsSeek(xFilial("SQT")+AllTrim(Upper(STR0051))))
	    			aadd(::ListOfTopicItens:CourseList,WsClassNew('Course'))
				    ::ListOfTopicItens:CourseList[nX]:CourseId 		:= SQT->QT_CURSO
				    ::ListOfTopicItens:CourseList[nX]:CourseDescr 	:= SQT->QT_DESCRIC
				EndIf

			Else
				lRetorno := .F.
				SetSoapFault("TopicItens",STR0028)					 //"No cadastro de Tipo de Objetivos há um Tipo de Curso sem Curso correspondente."
			Endif
		ElseIf (RDW->RDW_TIPO == "2" .Or. RDW->RDW_TIPO == "4") .and. VAL(RDW->RDW_TPCURS) == 0	//se a RDW nao tiver um tipo de curso, lista os tipos
	    	dbSelectArea("SQX")
			dbgotop()
			If !SQX->(EOF())
			    nX := 1
			    ::ListOfTopicItens:TypeCourseList := {}
				WHILE !SQX->(EOF())
					//VERIFICA PRIMEIRO SE EXISTE RELACIONAMENTO DE SQX COM A SQT
					//SE EXISTIR GRAVA DADOS, SENAO IGNORA
					SQT->( dbSetOrder(3) )
					If SQT->( MsSeek(xFilial("SQT")+SQX->QX_CODIGO) )
						aadd(::ListOfTopicItens:TypeCourseList,WsClassNew('Course'))
						::ListOfTopicItens:TypeCourseList[nX]:CourseId		:= SQX->QX_CODIGO
						::ListOfTopicItens:TypeCourseList[nX]:CourseDescr	:= ALLTRIM(SQX->QX_DESC)

						nX++
					EndIf

					SQX->(DbSkip())
				ENDDO

			EndIf

		ElseIf RDW->RDW_TIPO == "5" //Capacitacao interna

			dbSelectArea("RA1")
			dbSetOrder(2)
			dbGoTop()
			nX := 1
			While !Eof()
				If AllTrim(Upper(RA1->RA1_DESC)) != AllTrim(Upper(STR0051)) //"OUTROS"
					aadd(::ListOfTopicItens:CourseList,WsClassNew('Course'))
					::ListOfTopicItens:CourseList[nX]:CourseId		:= RA1->RA1_CURSO
					::ListOfTopicItens:CourseList[nX]:CourseDescr	:= ALLTRIM(RA1->RA1_DESC)
					::ListOfTopicItens:CourseList[nX]:CourseValue	:= RA1->RA1_VALOR
					::ListOfTopicItens:CourseList[nX]:CourseHours	:= RA1->RA1_HORAS

					nX++
				EndIf
				dbSkip()
			EndDo

			//Ordenacao do array de cursos por Descricao
			Asort( ::ListOfTopicItens:CourseList,,, {|x,y| x:CourseDescr < y:CourseDescr } )

			//Inclusao do Curso "OUTROS" se houver na base
			RA1->(dbSetOrder(2))
			If RA1->(MsSeek(xFilial("RA1")+AllTrim(Upper(STR0051))))
    			aadd(::ListOfTopicItens:CourseList,WsClassNew('Course'))
			    ::ListOfTopicItens:CourseList[nX]:CourseId 		:= RA1->RA1_CURSO
			    ::ListOfTopicItens:CourseList[nX]:CourseDescr 	:= ALLTRIM(RA1->RA1_DESC)
				::ListOfTopicItens:CourseList[nX]:CourseValue	:= RA1->RA1_VALOR
				::ListOfTopicItens:CourseList[nX]:CourseHours	:= RA1->RA1_HORAS
			EndIf

		Else
			aadd(::ListOfTopicItens:CourseList,WsClassNew('Course'))
			::ListOfTopicItens:CourseList[1]:CourseId		:= ""
			::ListOfTopicItens:CourseList[1]:CourseDescr	:= ""
			::ListOfTopicItens:CourseList[1]:CourseValue	:= 0
			::ListOfTopicItens:CourseList[1]:CourseHours	:= 0
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("TopicItens",STR0029) //"Codigo de Plano e Topico nao encontrado na RDW"
	EndIf
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³InsertUpdateItem³ Autor ³Thiago dos Reis    ³Data ³14.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao dos itens cadastrados em um   ³±±
±±³          ³Plano de Desenvolvimento Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Struct ItemPropreties          					           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Indica que o metodo foi executado com sucesso                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD InsertUpdateItem WSRECEIVE UserCode,ListOfItemProp WSSEND PlanVersion WSSERVICE RHPersonalDesenvPlan

Local nI 		:= 0
Local nCount	:= 0
Local lRetorno  := .T.
Local cItem		:= If(Empty(::ListOfItemProp:Item),StrZero(1,Len(RDJ->RDJ_ITEM)),::ListOfItemProp:Item)
Local cDescrMemo := ""
Local cDescAvlDor := ""

If !Empty(::ListOfItemProp:ObjectiveId)

/**************************************************************************************
* PRIMEIRO VERIFICA SE VERSAO ATUAL JA ESTA FECHADA.
* CASO POSITIVO GERAR NOVA VERSAO PARA COMECAR ALTERACAO
***************************************************************************************/
//INICIO DE DUPLICACAO DE DADOS
	RDV->(dbSetOrder(1)) //AVALIADO+OBJETIVO+AVALIADOR+PERIODO
  	If RDV->(MsSeek(xFilial("RDV")+::ListOfItemProp:EvaluatedId+::ListOfItemProp:ObjectiveID+::ListOfItemProp:EvaluatorId+::ListOfItemProp:Period))
		//VERIFICA SE VERSAO ESTA FECHADA
		If Int(RDV->RDV_VERATU) == RDV->RDV_VERATU .And. RDV->RDV_VERATU > 0
			BEGIN TRANSACTION
			Reclock("RDV",.F.)// trava a tabela sobre o registro a ser atualizado
			//RDV->RDV_STATUS := ::ListOfItemProp:Author
			If RDV->RDV_VERATU == val(::ListOfItemProp:ItemPlanVersion)
				RDV->RDV_VERATU	:= val(::ListOfItemProp:ItemPlanVersion)+0.01
			Else
				Return(.F.)
				SetSoapFault("SetStatus",STR0030) //"Versao Informada nao compativel com a Versao Atual do Plano!"
			EndIf
			RDV->(MSUnlock())

			DbSelectArea("RDJ")
			RDJ->(DbSetOrder(11))
			If RDJ->(MsSeek(xFilial("RDJ")+::ListOfItemProp:ObjectiveID+::ListOfItemProp:Period+::ListOfItemProp:EvaluatedId+::ListOfItemProp:EvaluatorId))
				While !EOF() .And. RDJ->RDJ_FILIAL == xFilial("RDJ") .And. RDJ->RDJ_CODOBJ == ::ListOfItemProp:ObjectiveID .And. RDJ->RDJ_PERIOD == ::ListOfItemProp:Period .And. RDJ->RDJ_CODDOR == ::ListOfItemProp:EvaluatorId .And. RDJ->RDJ_CODPAR == ::ListOfItemProp:EvaluatedId
					If str(RDJ->RDJ_VERITM,5,2) == ::ListOfItemProp:ItemPlanVersion
						nCount++
						aDados:={}
						nRec:=Recno()
						For nI:=1 To FCount()
							aAdd(aDados,FieldGet(nI))
							//GRAVA A DESCRICAO QUE VEM DO CAMPO MEMO
							If FieldName(nI) == "RDJ_CODMEM"
								cDescrMemo := AllTrim(ApdMsmm(aDados[nI]))
							EndIf
							//GRAVA A DESCRICAO QUE VEM DO CAMPO MEMO
							If FieldName(nI) == "RDJ_CODDER"
								cDescAvlDor := AllTrim(ApdMsmm(aDados[nI]))
							EndIf
						Next
						RecLock("RDJ",.T.)
						For nI:=1 To FCount()
							cCampo:=FieldName(nI)
							If cCampo=="RDJ_VERITM"
								RDJ->RDJ_VERITM:= val(::ListOfItemProp:ItemPlanVersion)+0.01
							//GRAVA EM BRANCO PARA PODER ATUALIZAR ABAIXO
							ElseIf cCampo == "RDJ_CODMEM"
								RDJ->RDJ_CODMEM := ""
							ElseIf cCampo == "RDJ_CODDER"
								RDJ->RDJ_CODDER := ""
							Else
								FieldPut(nI,aDados[nI])
							Endif
						Next
						RDJ->(MsUnLock())

						//DEVE GRAVAR MSG COM NOVO CODIGO
						//CASO CONTRARIO, CADA ALTERACAO NA MSG, ALTERARA TODAS AS DO HISTORICO AUTOMATICAMENTE
						ApdMsMm(RDJ->RDJ_CODMEM,,,cDescrMemo,1,,,"RDJ","RDJ_CODMEM")
						ApdMsMm(RDJ->RDJ_CODDER,,,cDescAvlDor,1,,,"RDJ","RDJ_CODDER")
						RDJ->(dbGoTo(nRec))

					EndIf
					RDJ->(dbSkip())
				EndDo
			::ListOfItemProp:ItemPlanVersion := AllTrim(str(val(::ListOfItemProp:ItemPlanVersion)+0.01))
			EndIf
			END TRANSACTION
		EndIf
	EndIf
//FIM DE DUPLICACAO DE DADOS


	//GRAVA VERSAO ATUAL DO PLANO
	::PlanVersion := STR(VAL(::ListOfItemProp:ItemPlanVersion),5,2)


	dbSelectArea("RDJ")
	RDJ->(dbSetOrder(11))

	If Empty(::ListOfItemProp:SubPlanID)
		::ListOfItemProp:SubPlanID := space(TamSX3("RDJ_ITOBJ")[1])
	EndIf

	If (::ListOfItemProp:Change == "T") // .T. = altera / .F. = inclui
	  	If RDJ->(MsSeek(xFilial("RDJ")+::ListOfItemProp:ObjectiveId+::ListOfItemProp:Period+::ListOfItemProp:EvaluatedId+::ListOfItemProp:EvaluatorId+::ListOfItemProp:SubPlanID+Str(VAL(::ListOfItemProp:ItemPlanVersion),5,2)+cItem))

			RDJ->(Reclock("RDJ",.F.)) // trava a tabela sobre o registro a ser modificado
			If RDJ->RDJ_AUTOR == ::ListOfItemProp:Author .and. RDJ->RDJ_STATUS == "1" // se for a pessoa que incluiu ela pode alterar e o status continua pendente
				RDJ->RDJ_STATUS := "1"
			Else // senao qq pessoa que alterar um item que nao foi ela que incluiu sera revisar
				RDJ->RDJ_STATUS := "3"
			Endif

		Else
			lRetorno := .F.
			SetSoapFault("InsertUpdateItem",STR0031) //"Item nao encontrado na RDJ"
		EndIf
	Else
		If RDJ->(MsSeek(xFilial("RDJ")+::ListOfItemProp:ObjectiveId+::ListOfItemProp:Period+::ListOfItemProp:EvaluatedId+::ListOfItemProp:EvaluatorId+::ListOfItemProp:SubPlanID))
	   		While !Eof() .And. (RDJ->RDJ_FILIAL == xFilial("RDJ")) .And. (RDJ->RDJ_CODOBJ == ::ListOfItemProp:ObjectiveId) .And. (RDJ->RDJ_PERIOD == ::ListOfItemProp:Period) .And. (RDJ->RDJ_CODDOR == ::ListOfItemProp:EvaluatorId) .And. (RDJ->RDJ_CODPAR == ::ListOfItemProp:EvaluatedId) .And. (RDJ->RDJ_ITOBJ == ::ListOfItemProp:SubPlanID)
				If cItem < RDJ->RDJ_ITEM
					cItem := RDJ->RDJ_ITEM
				Endif
				RDJ->(dbSkip())
		   	EndDo
		   	cItem := Soma1(cItem)
		EndIF

		RDJ->(Reclock("RDJ",.T.))	// trava a tabela no modo inserir registro
		RDJ->RDJ_STATUS := "1"
		DbSelectArea("RDV")
		RDV->(DbSetorder(2))
		If RDV->(MsSeek(xFilial("RDV")+::ListOfItemProp:EVALUATORID+::ListOfItemProp:ObjectiveId+::ListOfItemProp:EvaluatedId+::ListOfItemProp:Period))
			RDJ->RDJ_VERITM := RDV->RDV_VERATU
		Else
			lRetorno := .F.
			SetSoapFault("InsertUpdateItem",STR0032)			 //"Versao nao encontrada na RDV"
		EndIf
	EndIf

	If RDJ->( FieldPos("RDJ_TIPO") ) > 0
		If RDW->(MsSeek(xFilial("RDW")+::ListOfItemProp:ObjectiveID+::ListOfItemProp:SubPlanID))
			RDJ->RDJ_TIPO := RDW->RDW_TIPO
		EndIf
	EndIf

	RDJ->RDJ_FILIAL := xFilial("RDJ")
	RDJ->RDJ_CODPAR := ::ListOfItemProp:EvaluatedID
	RDJ->RDJ_CODOBJ := ::ListOfItemProp:ObjectiveID
	RDJ->RDJ_CODDOR := ::ListOfItemProp:EvaluatorID
	RDJ->RDJ_ITOBJ  := ::ListOfItemProp:SubPlanID
	RDJ->RDJ_DTINI  := ::ListOfItemProp:InitialDate
	RDJ->RDJ_DTFIM  := ::ListOfItemProp:FinalDate
	RDJ->RDJ_DATITM := If(Empty(RDJ->RDJ_DATITM),dDataBase,RDJ->RDJ_DATITM)
	If !empty(::ListOfItemProp:CourseId)
		RDJ->RDJ_TPCURS	:= ::ListOfItemProp:TypeCourseId
		RDJ->RDJ_CURSO	:= ::ListOfItemProp:CourseId
	EndIf
	If !Empty(::ListOfItemProp:CourseValue)
		RDJ->RDJ_VALOR	:= ::ListOfItemProp:CourseValue
	EndIf
	If !Empty(::ListOfItemProp:CourseDuration)
		RDJ->RDJ_DURACA	:= ::ListOfItemProp:CourseDuration
	EndIf
	RDJ->RDJ_ESCREA := ::ListOfItemProp:Relevance
	RDJ->RDJ_ITESCR := ::ListOfItemProp:RelevanceItem
	RDJ->RDJ_ESCATG := ::ListOfItemProp:AchieveScale
	RDJ->RDJ_ITESAT := ::ListOfItemProp:AchieveScaleItem
	RDJ->RDJ_PERIOD := ::ListOfItemProp:Period
	RDJ->RDJ_ITEM   := cItem
	RDJ->RDJ_AUTOR	:= ::ListOfItemProp:Author
  	//CAMPO SOLICITADO PELO PROTHEUS
  	RDJ->RDJ_SEQITM := "01"
	//CONSULTA TABELA RDI PARA PEGAR ESCALA DE CONHECIMENTO
	//ITEM OBRIGATORIO NO PROTHEUS
	RDI->(dbSetOrder(1))
	If RDI->(MsSeek(xFilial("RDI")+::ListOfItemProp:ObjectiveID))
		RDJ->RDJ_ESCCON := RDI->RDI_ESCCON
	EndIf

	cTeste := StrTran(::ListOfItemProp:Observation,'"',"" )
	cTeste := StrTran(cTeste,"'","" )
	
	If !Empty(cTeste)
		ApdMsMm(RDJ->RDJ_CODMEM,,,cTeste,1,,,"RDJ","RDJ_CODMEM")
	EndIf
	if !Empty(::ListOfItemProp:ValidatorObs)
		cTeste := StrTran(::ListOfItemProp:ValidatorObs,'"',"" )
		cTeste := StrTran(cTeste,"'","" )
		If !Empty(cTeste)
			ApdMsMm(RDJ->RDJ_CODDER,,,cTeste,1,,,"RDJ","RDJ_CODDER")
		EndIf
	EndIf
	RDJ->(MSUnlock())
Else
	lRetorno := .F.
	SetSoapFault("InsertUpdateItem",STR0033) //"Array de entrada inválido!"
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DeleteItem    ³ Autor ³Thiago dos Reis     ³Data ³20.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de exclusao dos itens cadastrados em um   			   ³±±
±±³          ³Plano de Desenvolvimento Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Struct ItemPropreties                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Indica que o metodo foi executado com sucesso                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD DeleteItem WSRECEIVE UserCode,ListOfItemProp WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.

If !Empty(::ListOfItemProp:ObjectiveId)
	dbSelectArea("RDJ")
	RDJ->(dbSetOrder(11))

	If Empty(::ListOfItemProp:SubPlanID)
		::ListOfItemProp:SubPlanID := space(TamSX3("RDJ_ITOBJ")[1])
	EndIf

// Verifica o status do registro; permite apagar registros com status "Pendente" ou rejeitado
	If RDJ->(MsSeek(xFilial("RDJ")+::ListOfItemProp:ObjectiveId+::ListOfItemProp:Period+::ListOfItemProp:EvaluatedId+::ListOfItemProp:EvaluatorId+::ListOfItemProp:SubPlanID+Str(VAL(::ListOfItemProp:ItemPlanVersion),5,2)+::ListOfItemProp:Item)) .And. ( AllTrim(::ListOfItemProp:Status) == "1" .Or. AllTrim(::ListOfItemProp:Status) == "4" )
		RDJ->(Reclock("RDJ",.F.))
		ApdMsMm(RDJ_CODMEM,,,,3)
		RDJ->(dbDelete())
		RDJ->(MsUnlock())
	Else
		lRetorno := .F.
		SetSoapFault("DeleteItem",STR0034) //"Só é permitido apagar itens Pendentes. Para outros utilize a opção Modificar!"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("DeleteItem",STR0033) //"Array de entrada inválido!"
EndIf

Return(lRetorno)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CancelaItem    ³ Autor ³Eduardo Ferreira   ³Data ³22.06.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de cancelamento dos itens cadastrados em um   		   ³±±
±±³          ³Plano de Desenvolvimento Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Struct ItemPropreties                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Indica que o metodo foi executado com sucesso                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD CancelaItem WSRECEIVE UserCode,ListOfItemProp WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.

If !Empty(::ListOfItemProp:ObjectiveId)
	dbSelectArea("RDJ")
	RDJ->(dbSetOrder(11))

	If Empty(::ListOfItemProp:SubPlanID)
		::ListOfItemProp:SubPlanID := space(TamSX3("RDJ_ITOBJ")[1])
	EndIf

// Verifica o status do registro; permite apagar registros com status "Pendente" ou rejeitado
	If RDJ->(MsSeek(xFilial("RDJ")+::ListOfItemProp:ObjectiveId+::ListOfItemProp:Period+::ListOfItemProp:EvaluatedId+::ListOfItemProp:EvaluatorId+::ListOfItemProp:SubPlanID+Str(VAL(::ListOfItemProp:ItemPlanVersion),5,2)+::ListOfItemProp:Item)) .And. ( AllTrim(::ListOfItemProp:Status) == "1" .Or. AllTrim(::ListOfItemProp:Status) == "4" )
		RDJ->(Reclock("RDJ",.F.))
		RDJ->RDJ_STATUS = '4'		
		RDJ->(MsUnlock())
	Else
		lRetorno := .F.
		SetSoapFault("CancelaItem",STR0058) 
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("DeleteItem",STR0033) //"Array de entrada inválido!"
EndIf

Return(lRetorno)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetUserObjPaper³ Autor ³Thiago dos Reis     ³Data ³21.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de gravacao do papel do participante no 			   ³±±
±±³          ³Plano de Desenvolvimento Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Código do Objetivo, Periodo, Partticipante e texto           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Indica que o metodo foi executado com sucesso                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD SetUserObjPaper WSRECEIVE UserCode,ObjID,PeriodID,AvaliatorId,ParticipantId,Text WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.

If !Empty(::UserCode) .and. !Empty(::ObjID) .and. !Empty(::PeriodID) .and. !Empty(::AvaliatorId) .and. !Empty(::ParticipantId) .and. !Empty(::Text)
	dbSelectArea("RDV")
	RDV->(dbSetOrder(1))
	If RDV->(MsSeek(xFilial("RDV")+::ParticipantId+::ObjID+::AvaliatorId+::PeriodID))
		RDV->(Reclock("RDV",.F.))	// trava a tabela no modo alterar
		ApdMsMm(RDV_CODPAP,,,::Text,1,,,"RDV","RDV_CODPAP")// INCLUI
		RDV->(MsUnlock())
	Else
		lRetorno := .F.
		SetSoapFault("SetUserObjPaper",STR0035) //"Nao foi encontrado nenhum registro com os parametros informados!"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("SetUserObjPaper",STR0036) //"Faltando parametros de entrada!"
EndIf

Return(lRetorno)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ApproveFailItem ³ Autor ³Thiago dos Reis    ³Data ³11.01.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de aprovacao / reprovacao dos itens cadastrados em um ³±±
±±³          ³Plano de Desenvolvimento Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion³±±
±±³			 |TopicID, ItemId, Author e NovoStatus         				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³WsNull - Indica que o metodo foi executado com sucesso       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³PDP/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ApproveFailItem WSRECEIVE UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion,TopicID,ItemId,Author,Status WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.

If !Empty(::UserCode) .and. !Empty(::ObjID) .and. !Empty(::PeriodID) .and. !Empty(::ParticipantId) .and. !Empty(::AvaliatorId) .and. !Empty(::PlanVersion) .and. !Empty(::ItemId) .and. !Empty(::Author) .and. !Empty(::Status)
	dbSelectArea("RDJ")
	RDJ->(dbSetOrder(11))

	If Empty(::TopicID)
		::TopicID := space(TamSX3("RDJ_ITOBJ")[1])
	EndIf
  	If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId+::TopicID+Str(VAL(::PlanVersion),5,2)+ItemId))
		RDJ->(Reclock("RDJ",.F.))// trava a tabela sobre o registro a ser atualizado
		RDJ->RDJ_STATUS := ::Status
		RDJ->RDJ_AUTOR	:= ::Author
		RDJ->(MSUnlock())
	Else
		lRetorno := .F.
		SetSoapFault("ApproveFailItem",STR0037) //"Busca na RDJ nao encontrada!"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("ApproveFailItem",STR0038) //"Parametros de entrada faltando!"
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ApproveFailItem ³ Autor ³Thiago dos Reis    ³Data ³11.01.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de aprovacao / reprovacao dos itens cadastrados em um ³±±
±±³          ³Plano de Desenvolvimento Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion³±±
±±³			 |TopicID, ItemId, Author e NovoStatus         				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³WsNull - Indica que o metodo foi executado com sucesso       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD SetStatus WSRECEIVE UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion,Status WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nI 	 := 0
Local nCount := 0
Local aDados := {}
Local nRec	 := 0
Local cCampo := ""
Local cDescrMemo := ""

If !Empty(::UserCode) .and. !Empty(::ObjID) .and. !Empty(::PeriodID) .and. !Empty(::ParticipantId) .and. !Empty(::AvaliatorId) .and. !Empty(::PlanVersion) .and. !Empty(::Status)
	dbSelectArea("RDV")
	RDV->(dbSetOrder(1))
  	If RDV->(MsSeek(xFilial("RDV")+::ParticipantId+::ObjID+::AvaliatorId+::PeriodID))
		Reclock("RDV",.F.)// trava a tabela sobre o registro a ser atualizado
		RDV->RDV_STATUS := ::Status
		If RDV->RDV_VERATU == val(::PlanVersion)
			RDV->RDV_VERATU	:= val(::PlanVersion)+0.01
		Else
			Return(.F.)
			SetSoapFault("SetStatus",STR0030) //"Versao Informada nao compativel com a Versao Atual do Plano!"
		EndIf
		RDV->(MSUnlock())

		DbSelectArea("RDJ")
		RDJ->(DbSetOrder(11))
		If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId))
			While !EOF() .And. RDJ->RDJ_FILIAL == xFilial("RDJ") .And. RDJ->RDJ_CODOBJ == ::ObjID .And. RDJ->RDJ_PERIOD == ::PeriodID .And. RDJ->RDJ_CODDOR == ::AvaliatorId .And. RDJ->RDJ_CODPAR == ::ParticipantId
				If str(RDJ->RDJ_VERITM,5,2) == ::PlanVersion
					nCount++
					aDados:={}
					nRec:=Recno()
					For nI:=1 To FCount()
						aAdd(aDados,FieldGet(nI))
						//GRAVA A DESCRICAO QUE VEM DO CAMPO MEMO
						If FieldName(nI) == "RDJ_CODMEM"
							cDescrMemo := AllTrim(ApdMsmm(aDados[nI]))
						EndIf
					Next
					RecLock("RDJ",.T.)
					For nI:=1 To FCount()
						cCampo:=FieldName(nI)
						If cCampo=="RDJ_VERITM"
							RDJ->RDJ_VERITM:= val(::PlanVersion)+0.01
						//GRAVA EM BRANCO PARA PODER ATUALIZAR ABAIXO
						ElseIf cCampo == "RDJ_CODMEM"
							RDJ->RDJ_CODMEM := ""
						Else
							FieldPut(nI,aDados[nI])
						Endif
					Next
					RDJ->(MsUnLock())

					//DEVE GRAVAR MSG COM NOVO CODIGO
					//CASO CONTRARIO, CADA ALTERACAO NA MSG, ALTERARA TODAS AS DO HISTORICO AUTOMATICAMENTE
					ApdMsMm(RDJ->RDJ_CODMEM,,,cDescrMemo,1,,,"RDJ","RDJ_CODMEM")

					RDJ->(dbGoTo(nRec))
				EndIf
				RDJ->(dbSkip())
			EndDo
		Else
			lRetorno := .F.
			SetSoapFault("SetStatus",STR0037)					 //"Busca na RDJ nao encontrada!"
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("SetStatus",STR0039) //"Busca na RDV nao encontrada!"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("SetStatus",STR0038) //"Parametros de entrada faltando!"
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AproveObjetive³ Autor ³Thiago dos Reis     ³Data ³18.01.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de exclusao dos itens cadastrados em um   			   ³±±
±±³          ³Plano de Desenvolvimento Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³WsNull = Indica que o metodo foi executado com sucesso       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD AproveObjetive WSRECEIVE UserCode,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion,Status WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nNewVersao := 00.00
Local nOldVersao := 00.00
Local nPos := 0
Local aVersao := {}
Local nI := 0

If !Empty(::UserCode) .and. !Empty(::ObjID) .and. !Empty(::PeriodID) .and. !Empty(::ParticipantId) .and. !Empty(::AvaliatorId) .and. !Empty(::PlanVersion)
	nPos := at(".",::PlanVersion)
	nOldVersao := val(substr(::PlanVersion,1,nPos-1))
	nNewVersao := nOldVersao+1.00

	Begin Transaction
		RDJ->(dbSetOrder(11))
		RDV->(DbSetOrder(2))

		If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId)) .and. RDV->(MsSeek(xFilial("RDV")+::AvaliatorId+::ObjID+::ParticipantId+::PeriodID))
			//enquanto a versao for maior que a ultima aprovada
			While !RDJ->(EOF()) .and.;
			       RDJ->RDJ_CODOBJ == ::ObjID .and.;
			       RDJ->RDJ_PERIOD == ::PeriodID .and. ;
			       RDJ->RDJ_CODPAR == ::ParticipantId .and.;
			       RDJ->RDJ_CODDOR == ::AvaliatorId

				If RDJ->RDJ_VERITM > nOldVersao .and. RDJ->RDJ_VERITM < nNewVersao
					Reclock( "RDJ", .F. )		//MODIFICAR

					//se for a versao autal e estiver aprovado substitui pela nova
					If Str( RDJ->RDJ_VERITM, 5, 2 ) == ::PlanVersion .and. RDJ->RDJ_STATUS == "2"
						aAdd( aVersao, { RDJ->( RECNO() ), nNewVersao } )
					Else //senao apaga
						RDJ->( DbDelete() )
					EndIf
				EndIf

				RDJ->(DbSkip())
			EndDo

			For nI := 1 To Len( aVersao )
				RDJ->( DbGoTo( aVersao[nI][1] ) )

				If RecLock( "RDJ", .F. )
					RDJ->RDJ_VERITM := aVersao[nI][2]
				EndIf
			Next nI

			DbSelectArea("RDV")
			If Reclock("RDV",.F.)
				If Empty(::Status)
					RDV->RDV_STATUS := "1" //AVALIADO
				Else
					RDV->RDV_STATUS := ::Status
				EndIf
				RDV->RDV_DTAPRO := date()

				//SE PLANO AINDA NAO FOI APROVADO
				If right(::PlanVersion, 2) != "00"
					RDV->RDV_VERATU := nNewVersao
				EndIf
				RDV->(MsUnlock())
			EndIf
		Else
			lRetorno := .F.
			SetSoapFault("AproveObjetive",STR0040) //"Nao encontrado Seek com os parametros na RDJ e na RDV!"
		EndIf
	End Transaction
Else
	lRetorno := .F.
	SetSoapFault("AproveObjetive",STR0041) //"Faltando parametros de entrada."
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ShowVersions  ³ Autor ³Thiago dos Reis     ³Data ³19.01.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de exibicao de versoes de um Plano para a mntagem do  ³±±
±±³          ³Historico do Plano de Desenvolvimento Pessoal                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Struct ItemPropreties                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   |ListOfHistory 											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Observacao: Este método ainda nao está finalizado... esperando aprovavacao do sistema para poder ser otimizado
//senao a logica será perdida
WSMETHOD ShowHistory WSRECEIVE UserCode,TypeId,ObjID,PeriodID,ParticipantId,AvaliatorId,PlanVersion WSSEND ListOfHistory WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local aAux		:= {}
Local nI		:= 0
Local nX		:= 0
Local aMyObjetiv := {}

If !Empty(::UserCode)
	If !Empty(::ParticipantId)
		If !Empty(::ObjID)
			If !Empty(::AvaliatorId)
				If !Empty(::PeriodID)
   					DbSelectArea("RDJ")
					RDJ->(DbSetOrder(11))
					If !Empty(::PlanVersion)
                        //retorna array com todos os topicos e itens
						DbSelectArea("RDW")
						RDW->(DbSetOrder(1))
						nI := 0
						If RDW->(MsSeek(xFilial("RDW")+::ObjID))
							While !RDW->(EOF()) .and. RDW->RDW_CODOBJ == ::ObjID
								If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId+RDW->RDW_ITEM+::PlanVersion))
									nI++
									aadd(::ListOfHistory:HistSubPlans,WsClassNew('SubPlans'))
									::ListOfHistory:HistSubPlans[nI]:ItemID		:= RDW->RDW_ITEM
									::ListOfHistory:HistSubPlans[nI]:DescrItem	:= RDW->RDW_DESCIT
									::ListOfHistory:HistSubPlans[nI]:TipoItem	:= RDW->RDW_TIPO

									::ListOfHistory:HistSubPlans[nI]:ItemList := {}
									nX := 0
									While !RDJ->(EOF()) .and. RDJ->RDJ_CODOBJ == ::ObjID .and. RDJ->RDJ_PERIOD == ::PeriodID .and. RDJ->RDJ_CODPAR == ::ParticipantId .and. RDJ->RDJ_CODDOR == ::AvaliatorId .and. RDJ->RDJ_ITOBJ == ::ListOfHistory:HistSubPlans[nI]:ItemID .and. Str(RDJ->RDJ_VERITM,5,2) == ::PlanVersion
										nX++
										aadd(::ListOfHistory:HistSubPlans[nI]:ItemList,WsClassNew('Item'))
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ItemID		:= RDJ->RDJ_ITEM
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:Status		:= RDJ->RDJ_STATUS
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ItemDescr	:= ApdMsMm( RDJ->RDJ_CODMEM )
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:FinishDate	:= RDJ->RDJ_DTFIM
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:InitDate		:= RDJ->RDJ_DTINI
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ItemDate		:= RDJ->RDJ_DATITM
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:Relevance	:= RDJ->RDJ_ITESCR
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:PercentId	:= RDJ->RDJ_ITESAT
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:Author		:= RDJ->RDJ_AUTOR //Autor (0=avaliado 1=avaliador)
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ValidatorObs	:= ApdMsMm( RDJ->RDJ_CODDER )
										dbSelectArea("RBL")
										RBL->(DbSetOrder(1))
										If RBL->(MsSeek(xFilial("RBL")+RDJ->RDJ_ESCATG+RDJ->RDJ_ITESAT))
											::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:PercentDone		:= ALLTRIM(RBL->RBL_DESCRI)
										Else
											::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:PercentDone		:= ""
										EndIf

										If !Empty(RDJ->RDJ_CURSO)
											::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseId 			:= RDJ->RDJ_CURSO

											If RDJ->( FieldPos("RDJ_TIPO") ) > 0 .And. RDJ->RDJ_TIPO == "5"	//Capacitacao interna

												dbSelectArea("RA1")
												dbSetOrder(1)
												If MsSeek(xFilial("RA1")+AllTrim(RDJ->RDJ_CURSO))
													::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseDescr := ALLTRIM(RA1->RA1_DESC)
												EndIf
											Else

												dbSelectArea("SQT")
												SQT->(dbSetOrder(1))
												If SQT->(MsSeek(xFilial("SQT")+RDJ->RDJ_CURSO))
													::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseDescr	:= ALLTRIM(SQT->QT_DESCRIC)
												EndIf
											EndIf
											::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseValue		:= alltrim(RDJ->RDJ_VALOR)
											::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseDuration	:= RDJ->RDJ_DURACA
										EndIf

										RDJ->(DbSkip())
									EndDo
								ElseIf nI == 0
									conout("ShowHistory - Busca1 na RDJ Falhou ****************************")
								EndIf
							    RDW->(DbSkip())
							    //varinfo("::ListOfHistory:HistSubPlans",::ListOfHistory:HistSubPlans)
							EndDo
						Else
							If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId+space(TamSX3("RDJ_ITOBJ")[1])+::PlanVersion))
								nI++
								aadd(::ListOfHistory:HistSubPlans,WsClassNew('SubPlans'))
								::ListOfHistory:HistSubPlans[nI]:ItemID		:= space(TamSX3("RDJ_ITOBJ")[1])
								::ListOfHistory:HistSubPlans[nI]:DescrItem	:= ""
								::ListOfHistory:HistSubPlans[nI]:TipoItem	:= ""

								::ListOfHistory:HistSubPlans[nI]:ItemList := {}
								nX := 0
								While !RDJ->(EOF()) .and. RDJ->RDJ_CODOBJ == ::ObjID .and. RDJ->RDJ_PERIOD == ::PeriodID .and. RDJ->RDJ_CODPAR == ::ParticipantId .and. RDJ->RDJ_CODDOR == ::AvaliatorId .and. RDJ->RDJ_ITOBJ == ::ListOfHistory:HistSubPlans[nI]:ItemID .and. Str(RDJ->RDJ_VERITM,5,2) == ::PlanVersion
									nX++
									aadd(::ListOfHistory:HistSubPlans[nI]:ItemList,WsClassNew('Item'))
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ItemID		:= RDJ->RDJ_ITEM
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:Status		:= RDJ->RDJ_STATUS
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ItemDescr		:= ApdMsMm( RDJ->RDJ_CODMEM )
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:FinishDate	:= RDJ->RDJ_DTFIM
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:InitDate		:= RDJ->RDJ_DTINI
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ItemDate		:= RDJ->RDJ_DATITM
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:Relevance		:= RDJ->RDJ_ITESCR
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:PercentId		:= RDJ->RDJ_ITESAT
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:Author		:= RDJ->RDJ_AUTOR //Autor (1=avaliado 2=avaliador)
									::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:ValidatorObs	:= ApdMsMm( RDJ->RDJ_CODDER )
									dbSelectArea("RBL")
									RBL->(DbSetOrder(1))
									If RBL->(MsSeek(xFilial("RBL")+RDJ->RDJ_ESCATG+RDJ->RDJ_ITESAT))
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:PercentDone		:= ALLTRIM(RBL->RBL_DESCRI)
									Else
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:PercentDone		:= ""
									EndIf

									If !Empty(RDJ->RDJ_CURSO)
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseId 			:= RDJ->RDJ_CURSO

										If RDJ->( FieldPos("RDJ_TIPO") ) > 0 .And. RDJ->RDJ_TIPO == "5"	//Capacitacao interna

											dbSelectArea("RA1")
											dbSetOrder(1)
											If MsSeek(xFilial("RA1")+AllTrim(RDJ->RDJ_CURSO))
												::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseDescr := ALLTRIM(RA1->RA1_DESC)
											EndIf

										Else

											dbSelectArea("SQT")
											SQT->(dbSetOrder(1))
											If SQT->(MsSeek(xFilial("SQT")+RDJ->RDJ_CURSO))
												::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseDescr	:= ALLTRIM(SQT->QT_DESCRIC)
											EndIf
										EndIf

										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseValue		:= alltrim(RDJ->RDJ_VALOR)
										::ListOfHistory:HistSubPlans[nI]:ItemList[nX]:CourseDuration	:= RDJ->RDJ_DURACA
									EndIf

									RDJ->(DbSkip())
								EndDo
							ElseIf nI == 0
								conout("ShowHistory - Busca na RDJ Falhou ****************************")
							EndIf
						EndiF
					Else
						//retorna as VERSOES para este Participant, Objetivo, Avaliador e Periodo
						If RDJ->(MsSeek(xFilial("RDJ")+::ObjID+::PeriodID+::ParticipantId+::AvaliatorId))
							::ListOfHistory:HistVersion := {}
							While !RDJ->(EOF()) .and. RDJ->RDJ_CODOBJ == ::ObjID .and. RDJ->RDJ_PERIOD == ::PeriodID .and. RDJ->RDJ_CODPAR == ::ParticipantId .and. RDJ->RDJ_CODDOR == ::AvaliatorId
								aadd( aAux, RDJ->RDJ_VERITM)
								RDJ->(DbSkip())
							EndDo
							ASORT( aAux,,, {|x,y| x < y } )

							aadd(::ListOfHistory:HistVersion, aAux[1])
							nX := 1
							For nI := 2 to len(aAux)
								If aAux[nI] > ::ListOfHistory:HistVersion[nX]
									nX++
									aadd(::ListOfHistory:HistVersion, aAux[nI])
								EndIf
							Next
						EndIF
					EndIf
				//Else
					//retorno os periodos para este Tipo, Participant, Objetivo e Avaliador
				EndIf
			//Else
				//retona os avaliadores para este tipo, participant e objetivo
			Endif
		ElseIf !Empty(::TypeId)
			//retorna Objetivos Finalizados para este Tipo e Participant       //Array de Objetivos -
			If ::MyObjectives(::UserCode,::ParticipantId,::TypeId,"T") //T=retorna todos os Objetivo - F=retorna somente os nao Finalizados (correntes)
				::ListOfHistory:ListOfObjective := ::ListOfObjective
			Else
				lRetorno := .F.
			EndIf
		Else
			lRetorno := .F.
			SetSoapFault("ShowHistory",STR0043) //"Faltando parametros de entrada TypeId."
		EndIf
	ElseIf !Empty(::AvaliatorId)
		If !Empty(::ObjID)
			//retona os participants para este tipo, AvaliatorId e objetivo
		ElseIf !Empty(::TypeId)
			//retorna Objetivos Finalizados para este Tipo e Avaliador       //Array de Objetivos -
			If ::MyTeamObjectives(::UserCode,::AvaliatorId,::TypeId,"3") //status 1=AVALIADO;2=AVALIADOR;3=FINALIZADO
				::ListOfHistory:ListOfObjective := ::ListOfObjective
			Else
				lRetorno := .F.
			EndIf
		Else
			lRetorno := .F.
			SetSoapFault("ShowHistory",STR0043) //"Faltando parametros de entrada TypeId."
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("ShowHistory",STR0044) //"ERRO! Faltando parametros obrigatorios (ParticipantId ou AvaliatorId)."
	Endif
Else
	lRetorno := .F.
	SetSoapFault("ShowHistory",STR0045) //"Faltando parametros de entrada UserCode."
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ShowAllPlans    ³ Autor ³ Thiago dos Reis ³Data ³26.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem de todos os planos cadastrados para o tipo³±±
±±³          ³especificado                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Tipo 1=Plano 2=Meta										   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Struct com codigo e descricao do Plano                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ShowAllPlans WSRECEIVE UserCode,TypeId WSSEND ListOfObj WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nX        := 0

dbSelectArea("RDI")
RDI->(dbSetorder(7))

If RDI->(MsSeek(xFilial("RDI")+::TypeId))
	::ListOfObj := {}
	WHILE !RDI->(EOF()) .And. RDI->(RDI_FILIAL+RDI_TIPO) = (xFilial("RDI")+::TypeId)
		nx++
		aadd(::ListOfObj,WsClassNew('Obj'))
		::ListOfObj[nx]:ObjID		:= RDI->RDI_CODIGO
		::ListOfObj[nx]:ObjDescr 	:= AllTrim(RDI->RDI_DESC)
		RDI->(dbSkip())
	EndDo
ELSE
	lRetorno := .F.
	SetSoapFault("ShowAllPlans",STR0046) //"Nenhum Tipo de Objetivo cadastrado na RDI com a especificação enviada!"
ENDIF

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ShowAllParticipant| Autor³ Thiago dos Reis ³Data ³26.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem de todos os participantes cadastrados 	   ³±±
±±³          |menos o participante que faz a requisiçao do servico		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UserCode, ParticipantId									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Struct com codigo e Nome do participante                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD ShowAllParticipant WSRECEIVE UserCode, ParticipantId, Filtro, Page WSSEND ListOfUser WSSERVICE RHPersonalDesenvPlan
	Local lRetorno  := .T.
	Local nX        := 0     
	Local nSkips	:= 0
	//Local aRet		:= {}
	
	::ListOfUser := {}
	
	dbSelectArea("RD0")                
	RD0->(dbSetorder(2))
	
	If RD0->(MsSeek(xFilial("RD0")))
		WHILE !RD0->(EOF()) .And. xFilial("RD0") == RD0->RD0_FILIAL .AND. nX < 10
	   	    If (!Empty(::Filtro) .AND. !(Upper(::Filtro) $ Upper(RD0->RD0_NOME))) .OR.;
	   	       (RD0->RD0_CODIGO == ::ParticipantId) .OR. (RD0->RD0_MSBLQL == "1")
				RD0->(DBSkip())		        
				Loop
			EndIf
	   	    
			If nSkips < (::Page * 10)
				RD0->(DBSkip())
				nSkips++
				Loop
			EndIf
		
			nx++
			aadd(::ListOfUser,WsClassNew('USER'))
			::ListOfUser[nx]:UserID		:= RD0->RD0_CODIGO
			::ListOfUser[nx]:UserName 	:= alltrim(RD0->RD0_NOME)  
			::ListOfUser[nx]:UserMat	:= ""   
			::ListOfUser[nx]:UserFuncao	:= ""
			::ListOfUser[nx]:UserCC 	:= ""	 
			
			::ListOfUser[nx]:UserCC 	:= GetFunCCDesc(RD0->RD0_CODIGO,.T.)
			::ListOfUser[nx]:UserFuncao	:= GetNivelCarreira(RD0->RD0_CODIGO,.T.)[2] //Cargo
	
			RD0->(dbSkip())
		EndDo
	ELSE
		lRetorno := .F.
		SetSoapFault("ShowAllParticipant", STR0047) //"Dados nao encontrados no cadastro de participantes!"
	ENDIF
Return(lRetorno)
 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ShowAllPeriod		| Autor³ Thiago dos Reis ³Data ³26.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem de todos os periodo cadastrados 	   	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UserCode													   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Struct com codigo e descricao do periodo                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ShowAllPeriod WSRECEIVE UserCode, TipoPer WSSEND ListOfPeriod WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nX        := 0

dbSelectArea("RDU")
RDU->(dbSetorder(2))

If RDU->(MsSeek(xFilial("RDU")))
	::ListOfPeriod := {}
	WHILE !RDU->(EOF()) .And. xFilial("RDU") == RDU->RDU_FILIAL
		If RDU->RDU_TIPO == TipoPer
			nx++
			aadd(::ListOfPeriod,WsClassNew('Period'))
			::ListOfPeriod[nx]:PeriodID		:= RDU->RDU_CODIGO
			::ListOfPeriod[nx]:PeriodDescr 	:= AllTrim(RDU->RDU_DESC)  
			::ListOfPeriod[nx]:PeriodDtFin	:= RDU->RDU_DATFIM
		EndIf
		RDU->(dbSkip())
	EndDo
ELSE
	lRetorno := .F.
	SetSoapFault("ShowAllPeriod",STR0048) //"Nao ha registro no cadastro de período!"
ENDIF

Return(lRetorno)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³InsertObjetive	| Autor³ Thiago dos Reis ³Data ³26.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao de Objetivo					 	   	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UserCode,ParticipantId,AvaliatorId,ObjID,PeriodID			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Variavel logica indicando True ou False                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD InsertObjetive WSRECEIVE UserCode,ParticipantId,AvaliatorId,ObjID,PeriodID WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local cParamIncl 	:= AllTrim(GetMV("MV_APDCPDP"))

If !Empty(::UserCode) .and. !Empty(::ParticipantId) .and. !Empty(::AvaliatorId) .and. !Empty(::ObjID) .and. !Empty(::PeriodID)
	dbSelectArea("RDV")
    dbSetorder(1)
	If !MsSeek(xFilial("RDV")+::ParticipantId+::ObjID+::AvaliatorId+::PeriodID)
		RDV->(Reclock("RDV",.T.))	// trava a tabela no modo inserir registro

		RDV->RDV_FILIAL	:= xFilial("RDV")
		RDV->RDV_CODPAR	:= ::ParticipantId
		RDV->RDV_CODOBJ	:= ::ObjID
		RDV->RDV_CODPER	:= ::PeriodID
		RDV->RDV_VERATU	:= 0

		If cParamIncl == "1"
			RDV->RDV_CODPAR	:= ::ParticipantId
			RDV->RDV_CODDOR	:= ::AvaliatorId
			RDV->RDV_STATUS	:= "1" //1=AVALIADO;2=AVALIADOR;3=FINALIZADO
		Else
			RDV->RDV_CODPAR	:= ::AvaliatorId
			RDV->RDV_CODDOR	:= ::ParticipantId
			RDV->RDV_STATUS	:= "2" //1=AVALIADO;2=AVALIADOR;3=FINALIZADO
		EndIf

		RDV->(MSUnlock())
	Else
		lRetorno := .F.
		SetSoapFault("InsertObjetive",STR0049) //"Já existe um plano finalizado ou aberto com esses parâmetros!"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("InsertObjetive",STR0036) //"Faltando parametros de entrada!"
EndIf

Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ChkObjetive		| Autor³ Thiago dos Reis ³Data ³26.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de checagem de duplicidade de Objetivo		 	   	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UserCode,ParticipantId,AvaliatorId,ObjID,PeriodID			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Variavel logica indicando True ou False                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PDP/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ChkObjetive WSRECEIVE UserCode,ParticipantId,AvaliatorId,ObjID,PeriodID WSSEND WsNull WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.

If !Empty(::UserCode) .and. !Empty(::ParticipantId) .and. !Empty(::AvaliatorId) .and. !Empty(::ObjID) .and. !Empty(::PeriodID)
	dbSelectArea("RDV")
    dbSetorder(1)
	If MsSeek(xFilial("RDV")+::ParticipantId+::ObjID+::AvaliatorId+::PeriodID)
		lRetorno := .F.
		SetSoapFault("ChkObjetive",STR0049) //"Já existe um plano finalizado ou aberto com esses parâmetros!"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("ChkObjetive",STR0036) //"Faltando parametros de entrada!"
EndIf

Return(lRetorno)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetMessage	 ³ Autor ³Juliana Barros      ³Data ³11.04.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta mensagem										  		³±±
±±³          ³                                                              ³±±
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
WSMETHOD GetMessage WSRECEIVE UserCode, MessageCode WSSEND Message WSSERVICE RHPersonalDesenvPlan
	Local aArea     := GetArea()
	Local lRetorno  := .T.

	DbSelectArea("RDG")
	DbSetOrder(1)
	
	If MsSeek(xFilial("RDG")+::MessageCode)
		::Message := APDMSMM(RDG->RDG_CODMEM,,,,,,,,,"RDY")
	Else
		lRetorno := .F.
		SetSoapFault("GETMESSAGE",STR0050) //"Codigo nao encontrado no cadastro de mensagens."
	EndIf


RestArea(aArea)
Return(lRetorno)


function wsapd013_xxx()
return
           

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetHeader ³Autor  ³ Joeudo Santana        ³ Data ³27.06.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de recuperacao do header "USER"	                   ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetHeaderRh WSRECEIVE HeaderType WSSEND Header WSSERVICE RHPersonalDesenvPlan
		           
	Local aHeader := {}   
	
	If HeaderType == "USER"  
	  	WsPutHead(aHeader,"RD0_CODIGO"		,"UserID")
	   	WsPutHead(aHeader,"RD0_NOME"		,"UserName")
		WsPutHead(aHeader,"RA_DESCFUN"		,"UserFuncao")  	
	 	WsPutHead(aHeader,"RA_DESCCC"		,"UserCC") 
	Elseif HeaderType == "COURSE"  
	  	WsPutHead(aHeader,"QT_CURSO"		,"CourseCurriculumCode")
	   	WsPutHead(aHeader,"QT_DESCRIC"		,"CourseCurriculumDescription")
	Elseif HeaderType == "ENTITY"	   	
	  	WsPutHead(aHeader,"RA0_ENTIDA"		,"EntityCode")
	   	WsPutHead(aHeader,"RA0_DESC"		,"EntityDescription")   	
    Elseif HeaderType == "RHPOSITION"       
        WsPutHead(aHeader,"Q3_CARGO"      ,"PositionCode")
        WsPutHead(aHeader,"Q3_DESCSUM"    ,"PositionDescription")     
    Elseif HeaderType == "SX5TABLE"       
        WsPutHead(aHeader,"Q3_CARGO"      ,"X5Code")
        WsPutHead(aHeader,"X5_DESCRI"    ,"X5Description")       
	EndIf
	
	::Header := aHeader	
Return(.T.)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MyPlans ³Autor  ³ Eduardo Ferreira        ³ Data ³07.06.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de busca de periodos disponiveis.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome da Estrutura                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve os periodos do participante              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ WEB SERVICES                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD MyPlans WSRECEIVE UserCode,ParticipantId,OrdenTipo,TipOrdem,Plano,Opc WSSEND RetPeriodo WSSERVICE RHPersonalDesenvPlan
Local lRetorno  := .T.
Local nX        := 0
Local cWhere	:= "%"
Local cQuery	:= GetNextAlias()
Local cOrdem	:= "" 
Local cOrdenam	:= " ORDER BY" + CRLF
//Valida o Tipo de Plano a ser pesquisado
if ::Plano == "1"
	cWhere+= "AND RDU.RDU_TIPO = '2' " + CRLF
Else
	cWhere+= "AND RDU.RDU_TIPO = '3' " + CRLF
EndIf

If ::Opc == "1"
	cWhere+=	"AND RDV.RDV_STATUS <> '3'"  + CRLF
Else
	cWhere+=	"AND RDV.RDV_STATUS = '3'" + CRLF
EndIf


If ::TipOrdem == "1"
	cOrdem	:= "ASC" 
Else
	cOrdem	:= "DESC" 
EndIf

Do Case
Case ::OrdenTipo=="1" //Por Código
	cOrdenam += "RDV_CODPER "
Case ::OrdenTipo=="2" //Por Descrição
	cOrdenam += "RDU_DESC "
Case ::OrdenTipo=="3" //Por Data de Inicio
	cOrdenam += "RDU_DATINI "
OtherWise                 //Por Data de Final
	cOrdenam += "RDU_DATFIM "
EndCase

cOrdenam	+= cOrdem

cWhere	+= cOrdenam	
cWhere	+= "%"
::RetPeriodo:= {}

dbSelectArea("RDV")
RDV->(dbSetOrder(1))
dbSelectArea("RDU")
RDU->(dbSetOrder(1))
If !Empty(::UserCode) .And. !Empty(::ParticipantId)
	
	BEGINSQL ALIAS cQuery
		SELECT
		distinct RDV_CODPER,
		RDU_DESC,
		RDU_DATINI,
		RDU_DATFIM
		FROM %table:RDV% RDV
		INNER JOIN %table:RDU% RDU
		ON RDV.RDV_CODPER = RDU.RDU_CODIGO
		WHERE
		RDV.RDV_FILIAL = %xFilial:RDV% AND
		RDU.RDU_FILIAL = %xFilial:RDU% AND
		(RDV.RDV_CODPAR = %exp:ParticipantId% OR RDV.RDV_CODDOR = %exp:ParticipantId%) AND
		RDV.%notDel% AND
		RDU.%notDel%
		%exp:cWhere%

	ENDSQL
	
	if !(cQuery)->(EoF())
		(cQuery)->(dbGoTop())
		While (cQuery)->(!EoF())
			nX++
			aadd(::RetPeriodo,WsClassNew('Period'))
			::RetPeriodo[nx]:PeriodID		:= (cQuery)->RDV_CODPER
			::RetPeriodo[nx]:PeriodDescr 	:= AllTrim((cQuery)->RDU_DESC)
			::RetPeriodo[nx]:PeriodDtIni	:= Stod((cQuery)->RDU_DATINI)
			::RetPeriodo[nx]:PeriodDtFin	:= Stod((cQuery)->RDU_DATFIM)
			
			(cQuery)->(DBSkip())
		EndDo
	Else
			nX++
			aadd(::RetPeriodo,WsClassNew('Period'))
			::RetPeriodo[nx]:PeriodID		:= ""
			::RetPeriodo[nx]:PeriodDescr 	:= ""
			::RetPeriodo[nx]:PeriodDtIni	:= Stod("")
			::RetPeriodo[nx]:PeriodDtFin	:= Stod("")
		lRetorno := .F.
		SetSoapFault("MyPlans",STR0048) //"Nao ha registro no cadastro de período!"
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("MyPlans",'Usuário ou Participante não encontrado.') //"Nao ha registro no cadastro de período!"
EndIf

Return(lRetorno)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MyPairsObjective ³Autor  ³ Eduardo Ferreira ³ Data ³07.06.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de busca de periodos disponiveis.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome da Estrutura                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve os periodos do participante              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ WEB SERVICES                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD MyPairsObjective WSRECEIVE UserCode,ParticipantId,TypeId,Status,PeriodID,PeriodDtIni,PeriodDtFin,FilterField,FilterValue WSSEND ListOfObjective WSSERVICE RHPersonalDesenvPlan

Local lRetorno  	:= .T.
Local nX        	:= 0
Local nI        	:= 0
Local nPercent		:= 0
Local nQtdMetas		:= 0
Local nResultOj		:= 0
Local nCont			:= 0
Local cFiltro		:= ""
Local cPers			:= ""
Local cParts		:= ""
Local cParticipant	:= ""
Local cObjetivo	 	:= ""
Local cPeriodo	 	:= ""
Local aPares		:= {}
Local dDataUltAlt 	:= date()

dbSelectArea("RDI")
RDI->(dbSetorder(7))
dbSelectArea("RDV")
RDV->(dbSetOrder(1))
dbSelectArea("RDU")
RDU->(dbSetOrder(1))

//Filtro quando feito pesquisa na pagina
if !Empty(::FilterField) .And. !Empty(::FilterValue)
	cFiltro:= ::FilterField+" Like " + "('%"+::FilterValue+"%')"
EndIf


IF !Empty(::UserCode) .and. !Empty(::ParticipantId)
	//Tratamento para buscar os dados do Periodo FILTRANDO OS PLANOS DE META
	BuscPares(::ParticipantId,cFiltro,@aPares,::PeriodID)
	::ListOfObjective := {}
	ASORT( aPares,,, {|x,y| x[2]+x[1] < y[2]+[y] } )
	For nCont:=1 to Len(aPares)
		PerMetas(aPares[nCont,1],::PeriodDtIni,::PeriodDtFin,::PeriodID,@cPers)
		If RDV->(MsSeek(xFilial("RDV")+aPares[nCont,1]+aPares[nCont,2]))
			WHILE !RDV->(EOF()) .and. RDV->(RDV_FILIAL+RDV_CODPAR+RDV_CODOBJ) == (xFilial("RDV")+aPares[nCont,1]+aPares[nCont,2]) 
				IF RDV->RDV_CODPER $ cPers .and. RDI->(MsSeek(xFilial("RDI")+alltrim(::TypeId)+RDV->RDV_CODOBJ)) //VERIFICA SE O OBJETIVO E DO TIPO ESPECIFICADO
					If (RDV->RDV_STATUS <> "3" .Or. (Status == "3" .And. RDV->RDV_STATUS == "3")) //SE NAO ESTIVER FINALIZADO OU SE STATUS VIR COMO FINALIZADO
						/***********************************************************************
						* VERIFICA PRIMEIRA DATA DE ALTERACAO DA ULTIMA VERSAO
						***********************************************************************/
						RDJ->(dbSetOrder(12))
						If RDJ->(MsSeek(xFilial("RDJ")+RDV->RDV_CODPAR+RDV->RDV_CODOBJ+RDV->RDV_CODPER+RDV->RDV_CODDOR+STR(RDV->RDV_VERATU,5,2)))
							//PEGA A PRIMEIRA DATA PQ ESTA ORDENADO POR DATA
							//E VEM A DATA MAIS ANTIGA NA CONSULTA
							dDataUltAlt := RDJ->RDJ_DATITM
						EndIf
						
						nQtdMetas	:= 0
						nPercent	:= 0
						nResultOj	:= 0
						
						// Busca de percentuais/totalizadores/Resultados
						While RDJ->(RDJ_FILIAL+RDJ_CODPAR+RDJ_CODOBJ+RDJ_PERIOD+RDJ_CODDOR+STR(RDJ_VERITM,5,2))==(xFilial("RDJ")+RDV->RDV_CODPAR+RDV->RDV_CODOBJ+RDV->RDV_CODPER+RDV->RDV_CODDOR+STR(RDV->RDV_VERATU,5,2))
							If !(RDJ->RDJ_STATUS $ '4/6')
								nQtdMetas	+=	1
								If !Empty(RDJ->RDJ_ITESAT)
									nPercent	+= 1
								EndIf
								If RDJ->(ColumnPos( "RDJ_RESULT" )) > 0
									nResultOj	+= RDJ->RDJ_RESULT
								EndIF
							EndIF
							RDJ->(dbSkip())
						EndDo
						nPercent:= Round((nPercent/nQtdMetas)*100,2)
						cObjetivo := aPares[nCont,2]
						IF RDV->RDV_CODPAR <> cParticipant .or. RDV->RDV_CODOBJ <> cObjetivo  //VERIFICA SE O OBJETIVO OU O PARTICIPANTE E DIFERENTE DO ANTERIOR
							cParticipant := RDV->RDV_CODPAR
							cObjetivo := RDV->RDV_CODOBJ
							cPeriodo := RDV->RDV_CODPER
							
							nx++
							aadd(::ListOfObjective,WsClassNew('Objective'))
							::ListOfObjective[nx]:ObjectiveID 			:= RDV->RDV_CODOBJ
							::ListOfObjective[nx]:ObjectiveDescr 		:= ALLTRIM(RDI->RDI_DESC)
							::ListOfObjective[nx]:ObjectiveStatus		:= RDV->RDV_STATUS
							::ListOfObjective[nx]:ObjectiveAvaliaterID	:= RDV->RDV_CODDOR
							::ListOfObjective[nx]:ObjectiveAvaliatedID	:= RDV->RDV_CODPAR
							::ListOfObjective[nx]:LastApprove			:= RDV->RDV_DTAPRO
							::ListOfObjective[nx]:ObjectiveGoal		 	:= nQtdMetas
							::ListOfObjective[nx]:ObjectivePercent	 	:= nPercent
							::ListOfObjective[nx]:ObjectiveResult	 	:= nResultOj
							dbSelectArea("RD0")
							RD0->(dbSetOrder(1))
							If RD0->(MsSeek(xFilial("RD0")+RDV->RDV_CODPAR))
								::ListOfObjective[nx]:ObjectiveAvaliatedName := ALLTRIM(RD0->RD0_NOME)
							Else
								::ListOfObjective[nx]:ObjectiveAvaliatedName := ""
							EndIf
							::ListOfObjective[nx]:ObjectivePeriod 	:= {}
							
							nI := 0
							nI++
							aadd(::ListOfObjective[nx]:ObjectivePeriod,WsClassNew('Period'))
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodID			:= RDV->RDV_CODPER
							::ListOfObjective[nx]:ObjectivePeriod[nI]:Status			:= RDV->RDV_STATUS
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodObjVersion	:= STR(RDV->RDV_VERATU,5,2)
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtAlt		:= dDataUltAlt //DATA DA PRIMEIRA ALTERACAO DA VERSAO ATUAL
							
							If RDU->(MsSeek(xFilial("RDU")+RDV->RDV_CODPER))
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr			:= ALLTRIM(RDU->RDU_DESC)
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtIni			:= RDU->RDU_DATINI //Data Inicial do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtFin			:= RDU->RDU_DATFIM //Data Final do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeIniAval	:= RDU->RDU_INIPLA //Qtde de dias para iniciar o plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeEditAval	:= RDU->RDU_EDTPLA //Qtde de dias para aprovar o plano apos a primeira edicao e aprovacao e uma nova edicao
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeFinAval	:= RDU->RDU_FIMPLA //Qtde de dias para finalizar o plano
							Else
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr	:=  ""
							Endif
						ElseIf RDV->RDV_CODPER <> cPeriodo
							cPeriodo := RDV->RDV_CODPER
							nI++
							aadd(::ListOfObjective[nx]:ObjectivePeriod,WsClassNew('Period'))
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodID			:= RDV->RDV_CODPER
							::ListOfObjective[nx]:ObjectivePeriod[nI]:Status			:= RDV->RDV_STATUS
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodObjVersion	:= STR(RDV->RDV_VERATU,5,2)
							::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtAlt		:= dDataUltAlt //DATA DA PRIMEIRA ALTERACAO DA VERSAO ATUAL
							
							If RDU->(MsSeek(xFilial("RDU")+RDV->RDV_CODPER))
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr			:=  ALLTRIM(RDU->RDU_DESC)
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtIni			:= RDU->RDU_DATINI //Data Inicial do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDtFin			:= RDU->RDU_DATFIM //Data Final do Plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeIniAval		:= RDU->RDU_INIPLA //Qtde de dias para iniciar o plano
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeEditAval	:= RDU->RDU_EDTPLA //Qtde de dias para aprovar o plano apos a primeira edicao e aprovacao e uma nova edicao
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodTimeFinAval		:= RDU->RDU_FIMPLA //Qtde de dias para finalizar o plano
								
							Else
								::ListOfObjective[nx]:ObjectivePeriod[nI]:PeriodDescr	:=  ""
							EndIf
						EndIf
					EndIf
				EndIf
				
				RDV->(dbSkip())
			EndDo
		EndIf
	Next
Else
	lRetorno := .F.
	SetSoapFault("MyPairsObjective",STR0022) //"Faltando parametros de entrada no metodo."
EndIf


Return(lRetorno)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PerMetas ³Autor  ³ Eduardo Ferreira        ³ Data ³09.06.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina que busca as metas\Periodo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome da Estrutura                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve os periodos do participante              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ WEB SERVICES                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function PerMetas(cParticipant,dPerIni,dPerFim,cPeriod,cCabMts,cFiltro,cCabPart,nIdBusca)
Local cWhere	:= "%"
Local cQuery	:= GetNextAlias()
Local aArea		:= GetArea()
Default cParticipant:= ''
Default cPartic 	:= ''
Default cFiltro		:= ''
Default cCabPart	:= ''
Default nIdBusca	:= 0

//Valida o Tipo de Busca Avaliado ou Avaliador
if nIdBusca == 0
	cWhere+= "AND RDV.RDV_CODPAR = '"+ cParticipant + "' "
ElseIf nIdBusca == 2
	cWhere+= "AND RDV.RDV_CODDOR = '"+ cParticipant + "' "
EndIf

//Valida Range de Periodo
If !Empty(dPerIni) .And. !Empty(dPerFim)
	cWhere+= " AND RDU.RDU_DATINI = '" + DtoS(dPerIni) + "' And RDU.RDU_DATFIM = '" + DtoS(dPerFim) + "' " + CRLF
EndIf

If !Empty(cPeriod)
	cWhere	+= " AND RDU.RDU_CODIGO = '" + cPeriod + "'" + CRLF 	 
EndIf
//Verifica filtro de busca 
If !Empty(cFiltro)
	cWhere+= "AND " + UPPER(cFiltro)
EndIf

cWhere+= "%"
BEGINSQL ALIAS cQuery
	SELECT
	RDV_CODPER,
	RDV_CODPAR
	FROM %table:RDV% RDV
	INNER JOIN %table:RDU% RDU
	ON RDV.RDV_CODPER = RDU.RDU_CODIGO
	INNER JOIN %table:RD0% RD0
	ON RDV.RDV_CODPAR  = RD0.RD0_CODIGO
	WHERE
	RDV.RDV_FILIAL = %xFilial:RDV% AND
	RDU.RDU_FILIAL = %xFilial:RDU% AND
	RDV.%notDel% AND
	RDU.%notDel% AND
	RD0.%notDel%
	%exp:cWhere%
ENDSQL

(cQuery)->(dbGoTop())
While (cQuery)->(!EoF())
	IF !((cQuery)->RDV_CODPER $ cCabMts) 
		cCabMts	+= (cQuery)->RDV_CODPER +	"/"
	EndIf
	IF !((cQuery)->RDV_CODPAR $ cCabPart)
	cCabPart+= (cQuery)->RDV_CODPAR +	"/"
	EndIf
	(cQuery)->(DBSkip())
EndDo
(cQuery)->(dbCloseArea())
RestArea(aArea)
Return .T.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BuscPares ³Autor  ³ Eduardo Ferreira      ³ Data ³16.06.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Retorna dados dos pares do usuário logado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome da Estrutura                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Retorna dados dos pares do usuário logado             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna dados dos pares do usuário logado   		            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ WEB SERVICES                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function BuscPares(cParticipant,cFiltro,aPares,cPeriod)
	
Local cWhere		:= "%"
Local cQuery		:= GetNextAlias()
Local cRdvAlias		:= GetNextAlias()
Local cVisAtv		:= ""
Local cItemVis		:= ""
Local cInFormt		:= ""
Local dDataUlt		:= dDataBase
Local lVisao		:= .F.
Local aAreaRDI		:= RDI->(GetArea())
Local aAreaRDE		:= RDE->(GetArea())
Local aAreaRDZ		:= RDZ->(GetArea())
Local aAreaSQB		:= SQB->(GetArea())
Local aAreaSRA		:= SRA->(GetArea())
Local aArea			:= GetArea()

Default cParticipant:= ''
Default cFiltro		:= ''
Default aPares		:= {}


dbSelectArea("RDI")
dbSelectArea("RDE")
dbSelectArea("RDZ")
dbSelectArea("SQB")
dbSelectArea("SRA")
RDI->(dbSetorder(1))
SQB->(dbSetOrder(1))//QB_FILIAL+QB_DEPTO
SRA->(dbSetOrder(1))//RA_FILIAL+RA_MAT
RDZ->(dbSetOrder(2))//RDZ_FILIAL+RDZ_CODRD0+RDZ_EMPENT+RDZ_FILENT+RDZ_ENTIDA
//Busca todos os objetivos
BEGINSQL ALIAS cRdvAlias
	SELECT *
	FROM %table:RDV% RDV
	WHERE
	RDV.RDV_CODPAR	=  %exp:cParticipant% AND
	RDV.RDV_CODPER	=  %exp:cPeriod% AND
	RDV.%notDel%
	ORDER BY
	RDV.RDV_CODPER
ENDSQL

If !(cRdvAlias)->(eof())
	(cRdvAlias)->(dbGotop())
	While !((cRdvAlias)->(Eof()))
		lVisao:= .F.
		if RDI->(dbSeek((cRdvAlias)->RDV_FILIAL+(cRdvAlias)->RDV_CODOBJ)) 
			If !Empty(RDI->RDI_VISAO) 
				lVisao	:= .T.
			EndIF
		EndIf
		If lVisao
			RDE->(dbSetOrder(1))
			if RDE->(dbSeek(xFilial("RDE")+(cRdvAlias)->RDV_CODPAR+RDI->RDI_VISAO))
				cItemVis:= RDE->RDE_ITEVIS
				RDE->(dbSetOrder(4))
				if RDE->(dbSeek(xFilial("RDE")+RDI->RDI_VISAO+cItemVis))
					While RDE->(!EoF()) .And. RDE->(RDE_FILIAL+RDE_CODVIS+RDE_ITEVIS) == (xFilial("RDE")+RDI->RDI_VISAO+cItemVis)
						If   RDE->RDE_STATUS = '1'
							If cParticipant != RDE->RDE_CODPAR .And. ( AScan(aPares, {|x| x[1] == RDE->RDE_CODPAR .and. x[2] == (cRdvAlias)->RDV_CODOBJ }) <= 0 )
								aAdd(aPares, {RDE->RDE_CODPAR,(cRdvAlias)->RDV_CODOBJ })
							EndIf
						EndIf
						RDE->(DBSkip())
					EndDo
				EndIf
			EndIf
		Else
			if RDZ->(dbSeek(xFilial("RDZ")+(cRdvAlias)->RDV_CODPAR+cEmpAnt+cFilAnt+"SRA"))
				if SRA->(dbSeek(alltrim(RDZ->RDZ_CODENT)))
					If SQB->(DbSeek(xFilial("SQB")+SRA->RA_DEPTO))
						cInFormt:= ""
						SRA->(dbSetOrder(21))//RA_FILIAL+RA_DEPTO+RA_MAT
						If SRA->(DbSeek(xFilial("SRA",cFilAnt)+SQB->QB_DEPTO))
							While SRA->(!(Eof())) .And. SRA->(RA_FILIAL+RA_DEPTO)==(cFilAnt+SQB->QB_DEPTO)
								If (SQB->(QB_FILRESP+QB_MATRESP) != SRA->(RA_FILIAL+RA_MAT)) .and. SRA->(RA_FILIAL+RA_MAT) != alltrim(RDZ->RDZ_CODENT)
									cInFormt	+= RA_MAT+	"/"
								EndIf
								SRA->(DbSkip())
							EndDo
							cWhere := "%AND SRA.RA_MAT IN " + FormatIn(cInFormt,"/")+"%"
							BEGINSQL ALIAS cQuery
								SELECT RDZ.RDZ_CODRD0
								FROM %table:SRA% SRA
								INNER JOIN %table:RDZ%	RDZ
								ON	((SRA.RA_FILIAL+SRA.RA_MAT)= RDZ.RDZ_CODENT AND RDZ.RDZ_ENTIDA='SRA')
								WHERE
								SRA.%notDel%	AND
								RDZ.%notDel%
								%exp:cWhere%
							ENDSQL
							While !(cQuery)->(Eof())
								if Ascan(aPares, (cQuery)->RDZ_CODRD0) == 0
									aAdd(aPares, {(cQuery)->RDZ_CODRD0, (cRdvAlias)->RDV_CODOBJ })
								EndIf
								(cQuery)->(dbSkip())
							EndDo
						EndIf
						(cQuery)->(dbCloseArea())
					EndIf
				EndIF
			EndIf
		EndIF
		(cRdvAlias)->(dbSkip())
	EndDo
EndIf
	
	(cRdvAlias)->(dbCloseArea())
	
RestArea(aAreaSRA)
RestArea(aAreaSQB)
RestArea(aAreaRDZ)
RestArea(aAreaRDE)
RestArea(aAreaRDI)
RestArea(aArea)
Return .T.
