#INCLUDE "WSAPD012.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSAPD012  ³ Autor ³Juliana B. Mariano     ³ Data ³24.11.2004  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pelo mapa de desenvolvimento         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Avaliacao de desempenho (Performance Evaluate)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CompetenceList
	WSDATA CompetenceID			AS String           //Codigo da Competencia
	WSDATA CompetenceDesc		AS String OPTIONAL  //Descricao da Competencia
	WSDATA CompetenceType		AS String OPTIONAL  //Se permite alteracao ou apenas visualizacao 2=alteracao / 3=visualizacao
	WSDATA CompetenceStatus		AS String OPTIONAL  //Status dos itens do mapa. 1=nao possui item; 2=possui item; 3=todos os itens estao aprovados
	WSDATA CompetenceAuthor		AS String OPTIONAL  //Responsavel atual pelas itens do mapa: 1=avaliado; 2=avaliador
	WSDATA SubItem				As Boolean  		//T ou F, se existe item abaixo do item selecionado
ENDWSSTRUCT


WSSTRUCT ItemList
	WSDATA CompetenceID			AS String           		 //CODIGO DA COMPETENCIA
	WSDATA CompetenceDesc		AS String OPTIONAL           //DESCRICAO DA COMPETENCIA
	WSDATA CompetenceItem		AS String OPTIONAL
	WSDATA CompetenceItemDesc	AS String OPTIONAL
	WSDATA CompetenceTree		AS String OPTIONAL
	WSDATA Author				AS String OPTIONAL  		//RESPONSAVEL PELO MAPA NO MOMENTO 1=AVALIADO; 2=AVALIADOR
	WSDATA ListOfSkills			AS Array Of SkillsList OPTIONAL	//HABILIDADES RELATIVAS AS COMPETENCIAS
	WSDATA ListOfItem			AS Array of ItemList OPTIONAL //ITENS DA COMPETENCIA
ENDWSSTRUCT


WSSTRUCT SkillsList
	WSDATA SkillId				AS String       //Codigo da Habilidade
	WSDATA SkillDescription		AS String OPTIONAL  //Descricao da Habilidade
	WSDATA SkillLevel			AS String OPTIONAL  //Escala da Habilidade
	WSDATA SkillLevelAnswer		AS String OPTIONAL  //Escala da Habilidade do participante
	WSDATA SkillDateAnswer		AS Date	  OPTIONAL  //Data da Habilidade do participante
	WSDATA SkillDateToAnswer	AS Date   OPTIONAL  //Data de Validade da Habilidade do participante
	WSDATA EvaluatedCom			AS String OPTIONAL  //Comentário do avaliado sobre habilidade
	WSDATA EvaluatorCom			AS String OPTIONAL  //Comentário do avaliador sobre habilidade
	WSDATA SkillAuthor			AS String OPTIONAL	//Se item do mapa esta com avaliador(2) ou avaliado(1)
	WSDATA SkillStatus			AS String OPTIONAL	//Se status do item do mapa esta: 1=em branco, 2=pendente, 3=aprovado
	WSDATA ListOfLevel			As Array Of LevelList OPTIONAL //ARRAY DE ESCALA
ENDWSSTRUCT


WSSTRUCT LevelList
	WSDATA LevelId				AS String       //Codigo da Escala
	WSDATA LevelDescription		AS String OPTIONAL  //Descricao da Escala
ENDWSSTRUCT


WSSTRUCT SkillLevel
	WSDATA CodMap				AS String       	//Codigo do mapa
	WSDATA EvaluatedId			AS String       	//Codigo do avaliado
	WSDATA EvaluatorId			AS String       	//Codigo do avaliador
	WSDATA MapAccess			AS String 		    //Acesso do avaliado ou avaliador / 1=avaliado; 2= avaliador
	WSDATA ItemVersion			AS String OPTIONAL	//Versao do item
	WSDATA CompetenceId			AS String       	//Codigo da competencia
	WSDATA CompetenceItemId 	AS String   	    //Codigo do item da competencia
	WSDATA SkillId				AS String			//Codigo da Habilidade
	WSDATA LevelId				AS String OPTIONAL  //Codigo da Escala
	WSDATA LevelItemId			AS String OPTIONAL  //Codigo do Item da Escala
	WSDATA EvaluatedCom			AS String OPTIONAL  //Codigo memo do comentario do avaliado
	WSDATA EvaluatorCom			AS String OPTIONAL  //Codigo memo do comentario do avaliado
ENDWSSTRUCT


WSSTRUCT HeaderParticipant
	WSDATA CodMap				As String			//Codigo do mapa
	WSDATA MapDesc				As String OPTIONAL	//descricao do mapa
	WSDATA CodPeriod			As String OPTIONAL	//codigo do periodo
	WSDATA PeriodDesc			As String OPTIONAL	//descricao do periodo
	WSDATA PartId				As String			//Codigo do participante
	WSDATA PartName				As String			//Nome do participante
	WSDATA PartFunction			As String OPTIONAL	//Cargo do participante
	WSDATA PartArea				As String OPTIONAL	//Area do participante
	WSDATA PartEvaluatorId		As String OPTIONAL	//Codigo do avalidor do participante
	WSDATA PartEvaluator		As String OPTIONAL	//Nome do avaliador/mentor do participante
	WSDATA LastUpdateMap		As Date	  OPTIONAL	//Ultima atualizacao do mapa
	WSDATA LastApproveMap		As Date   OPTIONAL	//Ultima aprovacao do mapa
	WSDATA Version				As String OPTIONAL	//Versao Atual
	WSDATA Author				As String OPTIONAL	//Responsavel atual do mapa 1=avaliado; 2=avaliador
	WSDATA PartLeaderId			As String OPTIONAL	//Codigo do Lider hierarquico do Participante
	WSDATA PartLeader			As String OPTIONAL	//Nome do Lider hierarquico do Participante
ENDWSSTRUCT


WSSTRUCT MapParticipant
	WSDATA CodMap				As String			//Codigo do mapa
	WSDATA MapDescription		As String OPTIONAL	//Descricao do mapa
	WSDATA MapVersion			As String OPTIONAL	//Versao Atual do mapa
	WSDATA EvaluatedId			As String OPTIONAL	//codigo do avaliado
	WSDATA EvaluatedName		As String OPTIONAL	//nome do avaliado
	WSDATA EvaluatorId			As String OPTIONAL	//codigo do avaliador
	WSDATA EvaluatorName		As String OPTIONAL	//nome do avaliador
	WSDATA Period				As String OPTIONAL	//Descricao do periodo do mapa
	WSDATA Author				As String OPTIONAL	//Autor atual do mapa 1=avaliado; 2=avaliador
	WSDATA StatusItem			As String OPTIONAL	//Status dos itens Pendente, Editado ou Aprovado
	WSDATA LastApprove			As Date	  OPTIONAL	//Data da ultima aprovacao
	WSDATA ExistItem			As Boolean OPTIONAL //Se existem itens preenchidos T = existe; F = nao existe
ENDWSSTRUCT


WSSTRUCT Skills
	WSDATA Skills				As Array Of SkillLevel OPTIONAL //ESCALA DE HABILIDADES DE ACORDO COM O PARTICIPANTE
ENDWSSTRUCT


WSSTRUCT HistoryMap
	WSDATA ParticipantId		As String OPTIONAL //Codigo do participante
	WSDATA ParticipantName		As String OPTIONAL //Nome do participante
	WSDATA ListOfPeriod			As Array Of PeriodList OPTIONAL //Periodos dos mapas finalizados
ENDWSSTRUCT


WSSTRUCT PeriodList
	WSDATA PeriodId				As String OPTIONAL //CODIGO DO PERIODO
	WSDATA PeriodDesc			As String OPTIONAL //DESCRICAO DO PERIODO
	WSDATA Version				As String OPTIONAL //VERSAO DO MAPA
	WSDATA CodMap				As String OPTIONAL //CODIGO DO MAPA
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Controle do Usuario                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHKnowledge DESCRIPTION STR0001 //"Mapa de Conhecimento ( <b>Restrição de participante</b> )"
	WSDATA UserCode				AS String				//Codigo do Usuario
	WSDATA WsNull           	AS String				//retorno em branco
	WSDATA ParticipantId        As String             	//Codigo do Participante
	WSDATA CodMap		        As String	OPTIONAL   	//Codigo do mapa
	WSDATA EvaluatorId	        As String             	//Codigo do avaliador
	WSDATA EvaluatedId	        As String            	//Codigo do avaliado
	WSDATA CompetenceId			As String
	WSDATA Type					As String				//Se participante e avaliado(1) ou avaliador(2)
	WSDATA Version				As String				//versao do mapa
	WSDATA ChangedItem			As Boolean				//confirma se teve alguma alteracao nos itens .T. ou .F.
	WSDATA Author				As String OPTIONAL		//responsavel pelo mapa no momento 1=avaliado, 2=avaliador
	WSDATA ItemCompetenceID		As String OPTIONAL 		//CODIGO DO ITEM
	WSDATA Sincron				As String OPTIONAL 		//Se grava dados da tabela RBQ na RBI - 0 = Nao Integra; 1 = Integra valores; 2 = Integra valores e cadastro
	WSDATA ListOfCompetenceItem	AS ItemList OPTIONAL 	//ITENS DA COMPETENCIA
	WSDATA LevelSkill			As Skills OPTIONAL 		//ESCALA DE HABILIDADES DE ACORDO COM O PARTICIPANTE
	WSDATA PartHeader			As HeaderParticipant OPTIONAL 		//DADOS DO PARTICIPANTE PARA MAPA DE CONHECIMENTO
	WSDATA ParticipantMap		As MapParticipant	OPTIONAL		//MAPA DE CONHECIMENTO POR PARTICIPANTE
	WSDATA MapHistory			As Array Of HistoryMap				//HISTORICO DO MAPA DE CONHECIMENTO DO PART LOGADO
	WSDATA ListOfCompetence		AS Array Of CompetenceList OPTIONAL
	WSDATA ListOfEvaluated		AS Array Of MapParticipant OPTIONAL	//LISTA DE AVALIADOS
	WSDATA ListOfSkills			AS Array Of SkillsList OPTIONAL		//HABILIDADES RELATIVAS AS COMPETENCIAS
	WSDATA ListOfMentor	    	AS Array OF Mentors //Lista de avaliadores que a consulta retorna no pop-up de mentores  (WSAPD014.PRW)
	WSDATA MentorName			As String			//Nome do Mentor
	WSDATA CodMentor			As String OPTIONAL	//Codigo do Mentor

	WSMETHOD BrwCompetence	  	DESCRIPTION STR0002 //"Retorna a lista de todos as competências que foram feitas para a web"
	WSMETHOD BrwItemCompetence	DESCRIPTION STR0003	 //"Retorna a lista de todos os itens da competência selecionada"
	WSMETHOD BrwSkill			DESCRIPTION STR0004		 //"Retorna a lista de habilidades ligadas as competencias"
	WSMETHOD BrwEvaluated		DESCRIPTION STR0005 //"Retorna lista de avaliados para o mapa de conhecimento"
	WSMETHOD BrwHistory			DESCRIPTION STR0006	 //"Retorna habilidades do historico"
	WSMETHOD GetHeaderPart	    DESCRIPTION STR0007 //"Retorna dados do participante relativo ao mapa de conhecimento"
	WSMETHOD GetMyMap		    DESCRIPTION STR0008	 //"Retorna meus dados se houver mapa disponivel"
	WSMETHOD GetMapHistory		DESCRIPTION STR0009 //"Retorna dados do mapa de conhecimento finalizados do participante logado"
	WSMETHOD PutLevelSkill		DESCRIPTION STR0010			 //"Inclusão de escalas de habilidades de acordo com o usuário"
	WSMETHOD PutEvaluatedMap	DESCRIPTION STR0011				 //"Inclusão de avaliador no mapa de conhecimento do avaliado"
	WSMETHOD SetToRevision		DESCRIPTION STR0012	 //"Envia mapa para revisao - avaliado para avaliador"
	WSMETHOD SetEvaluatorRevision DESCRIPTION STR0013 //"Envia mapa para revisao - avaliador para avaliado"
	WSMETHOD ApproveMap			DESCRIPTION STR0014 //"Aprovacao do mapa de conhecimento"
	WSMETHOD GetChangedItem		DESCRIPTION STR0025 //"Verifica se existem itens alterados"
	WSMETHOD PutMentor			DESCRIPTION STR0035	//"Inclusao de mentor no cadastro de participantes"
	WSMETHOD BrwMentors		  	DESCRIPTION STR0036 //"Retorna a lista completa de participantes, para selecionar o Mentor"
ENDWSSERVICE


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwCompetence ³ Autor ³Juliana B. Mariano  ³Data ³24.11.2004 ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD BrwCompetence WSRECEIVE UserCode, CodMap, ParticipantId, EvaluatorId WSSEND ListOfCompetence WSSERVICE RHKnowledge

Local nI		:= 0
Local lRetorno	:= .T.
Local aArea		:= GetArea()
Local aStatus	:= {}
Local cGrupo	:= ""

//--- Checagem de Competencias do Grupo
RBO->(dbSetOrder(1))
If RBO->( MsSeek(xFilial("RBO")+::CodMap) )
	cGrupo := RBO->RBO_GRUPO
EndIf

RDM->(dbSetOrder(1))	//Cabecalho de Competencias
RBM->(dbSetOrder(1))	//Competencias do Grupo
RBM->( MsSeek(xFilial("RBM")+cGrupo) )

::ListOfCompetence := {}

If !Empty(cGrupo)
While !RBM->(Eof()) .And. ( RBM->RBM_FILIAL+RBM->RBM_GRUPO == xFilial("RBM")+cGrupo )

	If RDM->( MsSeek(xFilial("RDM")+RBM->RBM_CODCOM) )

		If RDM->RDM_TIPO $ "23" //2=permite alteracao / 3= visualizacao
			aAdd(::ListOfCompetence, WsClassNew("CompetenceList"))
			nI ++

			::ListOfCompetence[nI]:CompetenceID 	:= RDM->RDM_CODIGO
			::ListOfCompetence[nI]:CompetenceDesc	:= RDM->RDM_DESC
			::ListOfCompetence[nI]:CompetenceType	:= RDM->RDM_TIPO


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PARA VERIFICAR STATUS DOS ITENS DO MAPA DE ACORDO COM A COMPETENCIA  |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aStatus := {}
			RBP->( dbSetOrder(1) ) //FILIAL+CODMAPA+AVALIADO+AVALIADOR+STATUS
			If RBP->( MsSeek(xFilial("RBP")+::CodMap+::ParticipantId+::EvaluatorId) )
				::ListOfCompetence[nI]:CompetenceAuthor			:= RBP->RBP_AUTOR
				RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
				//nao consultar pelo avaliador, pq podem ter 2 avaliadores em periodos diferentes do mesmo mapa.
				//mas o avaliador nao e relevante, o que importa sao os dados do mapa de conhecimento
				If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO+RDM->RDM_CODIGO)) )
					While !RBQ->(Eof()) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM) == (xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO+RDM->RDM_CODIGO))

						aAdd( aStatus, RBQ->RBQ_STATUS )

						RBQ->( DbSkip() )
					EndDo
		        EndIf
		   	EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ VERIFICAR PRIORIDADES DO STATUS E GRAVAR		  |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ascan( aStatus, "4" ) > 0
				::ListOfCompetence[nI]:CompetenceStatus := "4"
			ElseIf ascan( aStatus, "2" ) > 0
				::ListOfCompetence[nI]:CompetenceStatus := "2"
			ElseIf ascan( aStatus, "3" ) > 0
				::ListOfCompetence[nI]:CompetenceStatus := "3"
			ElseIf ascan( aStatus, "1" ) > 0
				::ListOfCompetence[nI]:CompetenceStatus := "1"
			Endif

			//VERIFICA SE HEADER TEM ITENS CADASTRADOS
			RD2->(dbSetOrder(1))
			If RD2->(MsSeek(xFilial("RD2")+RDM->RDM_CODIGO))
				::ListOfCompetence[nI]:SubItem 	:= .T.
			EndIf
		EndIf

	Else
		lRetorno := .F.
		SetSoapFault("BRWCOMPETENCE",STR0015) //"Nao existem competencias cadastradas"
	EndIf

	RBM->( dbSkip() )
EndDo
Else
	If RDM->( MsSeek(xFilial("RDM")) )
		//GRAVA DADOS DO CABECALHO DE COMPETENCIAS
		While !RDM->(Eof()) .And. (RDM->RDM_FILIAL == xFilial("RDM"))
			If RDM->RDM_TIPO $ "23" //2=permite alteracao / 3= visualizacao
				aAdd(::ListOfCompetence, WsClassNew("CompetenceList"))
				nI ++

				::ListOfCompetence[nI]:CompetenceID 	:= RDM->RDM_CODIGO
				::ListOfCompetence[nI]:CompetenceDesc	:= RDM->RDM_DESC
				::ListOfCompetence[nI]:CompetenceType	:= RDM->RDM_TIPO


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ PARA VERIFICAR STATUS DOS ITENS DO MAPA DE ACORDO COM A COMPETENCIA  |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aStatus := {}
				RBP->( dbSetOrder(1) ) //FILIAL+CODMAPA+AVALIADO+AVALIADOR+STATUS
				If RBP->( MsSeek(xFilial("RBP")+::CodMap+::ParticipantId+::EvaluatorId) )
					::ListOfCompetence[nI]:CompetenceAuthor			:= RBP->RBP_AUTOR
					RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
					//nao consultar pelo avaliador, pq podem ter 2 avaliadores em periodos diferentes do mesmo mapa.
					//mas o avaliador nao e relevante, o que importa sao os dados do mapa de conhecimento
					If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO+RDM->RDM_CODIGO)) )
						While !RBQ->(Eof()) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM) == (xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO+RDM->RDM_CODIGO))

							aAdd( aStatus, RBQ->RBQ_STATUS )

							RBQ->( DbSkip() )
						EndDo
			        EndIf
			   	EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ VERIFICAR PRIORIDADES DO STATUS E GRAVAR		  |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ascan( aStatus, "4" ) > 0
					::ListOfCompetence[nI]:CompetenceStatus := "4"
				ElseIf ascan( aStatus, "2" ) > 0
					::ListOfCompetence[nI]:CompetenceStatus := "2"
				ElseIf ascan( aStatus, "3" ) > 0
					::ListOfCompetence[nI]:CompetenceStatus := "3"
				ElseIf ascan( aStatus, "1" ) > 0
					::ListOfCompetence[nI]:CompetenceStatus := "1"
				Endif



				//VERIFICA SE HEADER TEM ITENS CADASTRADOS
				RD2->(dbSetOrder(1))
				If RD2->(MsSeek(xFilial("RD2")+RDM->RDM_CODIGO))
					::ListOfCompetence[nI]:SubItem 	:= .T.
				EndIf
			EndIf

			RDM->( dbSkip() )
		EndDo
	Else
		lRetorno := .F.
		SetSoapFault("BRWCOMPETENCE",STR0015) //"Nao existem competencias cadastradas"
	EndIf
EndIf



RestArea(aArea)
Return lRetorno



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwItemCompete³ Autor ³Juliana B. Mariano  ³Data ³24.11.2004 ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD BrwItemCompetence WSRECEIVE UserCode, CompetenceId, CodMap, EvaluatedId, EvaluatorId WSSEND ListOfCompetenceItem WSSERVICE RHKnowledge

Local lRetorno	:= .T.
Local aArea		:= GetArea()

	Recursivo( ::CompetenceId,,, ::ListOfCompetenceItem, ::CodMap, ::EvaluatedId, ::EvaluatorId )


RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwSkill		³ Autor ³Juliana B. Mariano  ³Data ³16.12.2004 ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD BrwSkill WSRECEIVE UserCode, CompetenceId, ItemCompetenceId, ParticipantId WSSEND ListOfSkills WSSERVICE RHKnowledge

Local nJ		:= 0
Local nI		:= 0
Local lRetorno	:= .T.
Local aArea		:= GetArea()
Local aAux       := {}
Local aParams    := {}
Local cMatricula := ""

	//GRAVA DADOS DOS ITENS DAS COMPETENCIAS
	DbSelectArea("RBJ")
	dbSetOrder(1)
	If MsSeek(xFilial("RBJ")+::CompetenceId+::ItemCompetenceId)
		nJ := 0
		::ListOfSkills := {}
		While !Eof() .And. RBJ->RBJ_FILIAL == xFilial("RBJ") .And.;
		 RBJ->RBJ_CODCOM == ::CompetenceId .And. RBJ->RBJ_ITECOM == ::ItemCompetenceId
			nJ++
			aAdd(::ListOfSkills, WsClassNew("SkillsList"))
			::ListOfSkills[nJ]:SkillId 				:= RBJ->RBJ_HABIL

			//CONSULTA DESCRICAO DA HABILIDADE
			RBG->( dbSetOrder(1) )
			If RBG->(MsSeek(xFilial("RBG")+RBJ->RBJ_HABIL))
				::ListOfSkills[nJ]:SkillDescription		:= RBG->RBG_DESC
				::ListOfSkills[nJ]:SkillLevel			:= RBG->RBG_ESCALA


				//CONSULTA MATRICULA DO PARTICIPANTE
				//CONSULTA CIC PELO CODIGO DO PARTICIPANTE
			    RD0->(DbSetOrder(1))
				If RD0->(MsSeek(xFilial("RD0")+::ParticipantId))
					cMatricula := ""

					if ExistBlock("DADOSFUNC")
						aAdd(aParams, "")
						aAdd(aParams, "")
						aAdd(aParams, "")
						aAdd(aParams, ::ParticipantId)

						aAux := U_DADOSFUNC( aParams )

						if len(aAux) > 0
							cMatricula := aAux[1][1] //1 - MATRICULA DO FUNCIONARIO
						endif
					else
						SRA->(DbSetOrder(5))
				
						If SRA->(MsSeek(xFilial("SRA")+RD0->RD0_CIC)) //CONSULTA MATRICULA PELO CIC DO PARTICIPANTE
							cMatricula := SRA->RA_MAT
						endif
					endif

					//CASO TENHA SIDO RESPONDIDO
					RBI->(DbSelectArea("RBI"))
					RBI->(dbSetOrder(1))
					
					If RBI->(MsSeek(xFilial("RBI")+cMatricula+RBJ->RBJ_HABIL))
						::ListOfSkills[nJ]:SkillLevelAnswer		:= RBI->RBI_ITESCAL
						::ListOfSkills[nJ]:SkillDateAnswer		:= RBI->RBI_DATA
						::ListOfSkills[nJ]:SkillDateToAnswer	:= RBI->RBI_DTVAL
					EndIf
			    EndIf

				//CONSULTA ITEM DE ESCALA DA HABILIDADE
				RBL->( dbSetOrder(1) )
				RBL->(MsSeek(xFilial("RBL")+RBG->RBG_ESCALA))
				nI := 0
				::ListOfSkills[nJ]:ListOfLevel := {}
				While !RBL->(Eof()) .And. xFilial("RBL") == RBL->RBL_FILIAL .And. RBL->RBL_ESCALA == RBG->RBG_ESCALA
					nI++
					aAdd(::ListOfSkills[nJ]:ListOfLevel, WsClassNew("LevelList"))

					::ListOfSkills[nJ]:ListOfLevel[nI]:LevelId          := RBL->RBL_ITEM
					::ListOfSkills[nJ]:ListOfLevel[nI]:LevelDescription := RBL->RBL_DESCRI

					RBL->(dbSkip())
				EndDo

			EndIf

		   dbSkip()
		EndDo

	Else
		lRetorno := .F.
		SetSoapFault("BRWSKILL",STR0016) //"Não existem habilidades para o item selecionado"
	EndIf

RestArea(aArea)
Return lRetorno



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutLevelSkill	³ Autor ³Juliana B. Mariano  ³Data ³16.12.2004 ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD PutLevelSkill WSRECEIVE UserCode, CodMap, ParticipantId, EvaluatorId, Author, LevelSkill WSSEND ChangedItem WSSERVICE RHKnowledge

Local nI			:= 0
Local nRec			:= 0
Local lRetorno		:= .T.
Local lAutoriza		:= .F.
Local cStatusMapa	:= ""
Local cVersaoAnt	:= ""
Local cVersao		:= ""
Local cMemoAdo		:= ""
Local cMemoAdor		:= ""
Local aDados		:= {}
Local aArea			:= GetArea()


BEGIN TRANSACTION

If Empty(::Author)
	::Author := "1"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ NAO EXISTEM ITENS ALTERADOS	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
::ChangedItem := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICAR SE MAPA ESTA APROVADO E GERAR UMA NOVA VERSAO	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(::LevelSkill:Skills) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ANTES DE DUPLICAR OS REGISTROS, VERIFICAR SE EXISTE MODIFICACAO	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 to len(::LevelSkill:Skills)
		RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
		If RBQ->( MsSeek(xFilial("RBQ")+::LevelSkill:Skills[nI]:CodMap+::LevelSkill:Skills[nI]:EvaluatedId+PadR(::LevelSkill:Skills[nI]:ItemVersion,5)+::LevelSkill:Skills[nI]:CompetenceId+::LevelSkill:Skills[nI]:CompetenceItemId+::LevelSkill:Skills[nI]:SkillId) )
			If ::Author == "1" .And. ( RBQ->RBQ_ITEESC != ::LevelSkill:Skills[nI]:LevelItemId .Or. AllTrim(::LevelSkill:Skills[nI]:EvaluatedCom) != AllTrim(ApdMsmm(RBQ->RBQ_CMADO)) )
				lAutoriza := .T.
				Exit
			ElseIf ::Author == "2" .And. ( RBQ->RBQ_ITEESC != ::LevelSkill:Skills[nI]:LevelItemId .Or. AllTrim(::LevelSkill:Skills[nI]:EvaluatorCom) != AllTrim(ApdMsmm(RBQ->RBQ_CMADOR)) )
				lAutoriza := .T.
				Exit
			EndIf
		Else
			lAutoriza := .T.
			Exit
		EndIf
	Next


	//CABECALHO
	RBP->( dbSetOrder(1) ) //AVALIADO+AVALIADOR+STATUS
	If RBP->( MsSeek(xFilial("RBP")+::CodMap+::ParticipantId+::EvaluatorId) )
		If Empty(RBP->RBP_AUTOR) .Or. Empty(RBP->RBP_VERSAO) .Or. Empty(RBP->RBP_STATUS)
			RecLock("RBP",.F.)
			If Empty(RBP->RBP_AUTOR)
				RBP->RBP_AUTOR := ::Author
			EndIf
			If Empty(RBP->RBP_VERSAO)
				RBP->RBP_VERSAO := "0"
			EndIf
			If Empty(RBP->RBP_STATUS)
				RBP->RBP_STATUS := "1" //PENDENTE
			EndIf
			RBP->(MsUnlock())
		EndIf
		cVersao := RBP->RBP_VERSAO
		If RBP->RBP_STATUS == "2" .And. lAutoriza == .T.

			cStatusMapa := RBP->RBP_STATUS
			cVersaoAnt 	:= RBP->RBP_VERSAO
			cVersao 	:= PadR(AllTrim(str(val(RBP->RBP_VERSAO) + 1)),5)
			RecLock("RBP",.F.)
			RBP->RBP_STATUS := "1"
			RBP->RBP_VERSAO := AllTrim(str(val(RBP->RBP_VERSAO) + 1))
			RBP->(MsUnlock())

			//DUPLICA
			RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
			If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+cVersaoAnt)) )
				While !RBQ->(Eof()) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO) == (xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+cVersaoAnt))
					aDados := {}
					nRec := RBQ->( Recno() )
					//PEGA DADOS DOS CAMPOS DE CADA LINHA
					For nI := 1 To RBQ->( FCount() )
						aAdd( aDados, RBQ->( FieldGet(nI) ) )
						//GRAVA A DESCRICAO QUE VEM DO CAMPO MEMO
						If RBQ->( FieldName(nI) ) == "RBQ_CMADO"
							cMemoAdo := AllTrim(ApdMsmm(aDados[nI]))
						ElseIf RBQ->( FieldName(nI) ) == "RBQ_CMADOR"
							cMemoDor := AllTrim(ApdMsmm(aDados[nI]))
						EndIf
					Next
					RecLock("RBQ",.T.)
					For nI := 1 To RBQ->( FCount() )
						cCampo := RBQ->( FieldName(nI) )
						If cCampo == "RBQ_VERSAO"
							RBQ->RBQ_VERSAO := cVersao
						ElseIf cCampo == "RBQ_CMADO" //GRAVA EM BRANCO PARA PODER ATUALIZAR ABAIXO
							RBQ->RBQ_CMADO := ""
						ElseIf cCampo == "RBQ_CMADOR" //GRAVA EM BRANCO PARA PODER ATUALIZAR ABAIXO
							RBQ->RBQ_CMADOR := ""
						Else
							FieldPut( nI, aDados[nI] )
						Endif
					Next
					RBQ->( MsUnLock() )

					//DEVE GRAVAR MSG COM NOVO CODIGO
					//CASO CONTRARIO, CADA ALTERACAO NA MSG, ALTERARA TODAS AS DO HISTORICO AUTOMATICAMENTE
					ApdMsMm(RBQ->RBQ_CMADO,,,cMemoAdo,1,,,"RBQ","RBQ_CMADO")     //AVALIADO
					ApdMsMm(RBQ->RBQ_CMADOR,,,cMemoAdor,1,,,"RBQ","RBQ_CMADOR") //AVALIADOR

					RBQ->(dbGoTo(nRec))

					RBQ->(dbSkip())
				EndDo
	        EndIf
		EndIf
	EndIf


	If lAutoriza == .T.
		//ITENS
		For nI := 1 to len(::LevelSkill:Skills)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ SE DER ALGUM PROBLEMA E NAO GRAVAR VERSAO ACIMA 	 |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(cVersao)
				cVersao := PadR(::LevelSkill:Skills[nI]:ItemVersion,5)
			EndIf

			RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
			If RBQ->( MsSeek(xFilial("RBQ")+::LevelSkill:Skills[nI]:CodMap+::LevelSkill:Skills[nI]:EvaluatedId+cVersao+::LevelSkill:Skills[nI]:CompetenceId+::LevelSkill:Skills[nI]:CompetenceItemId+::LevelSkill:Skills[nI]:SkillId) )
				RecLock("RBQ",.F.)

			Else
				RecLock("RBQ",.T.)
				RBQ->RBQ_FILIAL := xFilial("RBQ")
				RBQ->RBQ_CODMAP := ::LevelSkill:Skills[nI]:CodMap
				RBQ->RBQ_CODADO := ::LevelSkill:Skills[nI]:EvaluatedId
				RBQ->RBQ_CODDOR := ::LevelSkill:Skills[nI]:EvaluatorId
				RBQ->RBQ_VERSAO := cVersao
				RBQ->RBQ_CODCOM := ::LevelSkill:Skills[nI]:CompetenceId
				RBQ->RBQ_ITECOM := ::LevelSkill:Skills[nI]:CompetenceItemId
				RBQ->RBQ_HABIL  := ::LevelSkill:Skills[nI]:SkillId
				RBQ->RBQ_ESCALA := ::LevelSkill:Skills[nI]:LevelId
			EndIf


			If RBQ->RBQ_STATUS != "4" .And. ::Author == "1" .And. ( RBQ->RBQ_ITEESC != ::LevelSkill:Skills[nI]:LevelItemId .Or. AllTrim(::LevelSkill:Skills[nI]:EvaluatedCom) != AllTrim(ApdMsmm(RBQ->RBQ_CMADO)) )
				RBQ->RBQ_STATUS := "4" //STATUS INTERMEDIARIO PARA DEPOIS GRAVAR COMO ALTERADO (2)
				RBQ->RBQ_DATITM := date()
				::ChangedItem := .T. //HOUVE MUDANCA NO ITEM
			ElseIf RBQ->RBQ_STATUS != "4" .And. ::Author == "2" .And. ( RBQ->RBQ_ITEESC != ::LevelSkill:Skills[nI]:LevelItemId .Or. AllTrim(::LevelSkill:Skills[nI]:EvaluatorCom) != AllTrim(ApdMsmm(RBQ->RBQ_CMADOR)) )
				RBQ->RBQ_STATUS := "4" //STATUS INTERMEDIARIO PARA DEPOIS GRAVAR COMO ALTERADO (2)
				RBQ->RBQ_DATITM := date()
				::ChangedItem := .T. //HOUVE MUDANCA NO ITEM
/*			ElseIf RBQ->RBQ_STATUS != "4"
				RBQ->RBQ_STATUS := "4" //STATUS INTERMEDIARIO PARA DEPOIS GRAVAR COMO ALTERADO (2)
				RBQ->RBQ_DATITM := date()
				::ChangedItem := .T. //HOUVE MUDANCA NO ITEM*/
			EndIf
			RBQ->RBQ_ITEESC := ::LevelSkill:Skills[nI]:LevelItemId
			RBQ->RBQ_AUTOR  := ::Author					//::LevelSkill:Skills[nI]:MapAccess

			If (::Author == "1") //ACESSO DO AVALIADO
				//Rotina so grava comentario do avaliado
				ApdMsMm(RBQ->RBQ_CMADO,,,::LevelSkill:Skills[nI]:EvaluatedCom,1,,,"RBQ","RBQ_CMADO")
			Else //ACESSO DO AVALIADOR
				ApdMsMm(RBQ->RBQ_CMADOR,,,::LevelSkill:Skills[nI]:EvaluatorCom,1,,,"RBQ","RBQ_CMADOR")
			EndIf

		    RBQ->( MsUnlock() )
		Next nI
	EndIf
EndIf

END TRANSACTION

RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Recursivo		³ Autor ³Juliana B. Mariano  ³Data ³10.03.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo que consulta item de competencia para montar tree	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Array com retorno da tree					           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Recursivo( cCodigo, cTree, cItem, aTree, CodMap, EvaluatedId, EvaluatorId )

Local lRetorno	:= .T.
Local aArea 	:= RD2->( GetArea() )
Local cAliasRD2 := "RD2"
Local nLen 		:= 0
Local nJ 		:= 0
Local nI 		:= 0

DEFAULT cItem := "000000"


( cAliasRD2 )->( DbSetOrder( 2 ) )

If ( cAliasRD2 )->( MsSeek( xFilial( "RD2" ) + cCodigo + cItem ) )
	While !( cAliasRD2 )->( EOF() ) .AND. ;
		( cAliasRD2 )->RD2_FILIAL == xFilial( "RD2" ) .AND. ;
		( cAliasRD2 )->RD2_CODIGO == cCodigo .AND. ;
		( cAliasRD2 )->RD2_TREE == cItem

		If Empty( aTree:ListOfItem )
			aTree:ListOfItem := {}
		EndIf

		aAdd( aTree:ListOfItem, WsClassNew( "ItemList" ) )
		nLen := Len( aTree:ListOfItem )

		aTree:ListOfItem[nlen]:CompetenceId 		:= ( cAliasRD2 )->RD2_CODIGO
		RDM->(DbSetOrder(1))
		If RDM->( MsSeek(xFilial("RDM")+( cAliasRD2 )->RD2_CODIGO) )
			aTree:ListOfItem[nlen]:CompetenceDesc 	:= RDM->RDM_DESC
		EndIf
		aTree:ListOfItem[nlen]:CompetenceItem 		:= ( cAliasRD2 )->RD2_ITEM
		aTree:ListOfItem[nLen]:CompetenceItemDesc 	:= AllTrim( ( cAliasRD2 )->RD2_DESC )
		aTree:ListOfItem[nLen]:CompetenceTree	 	:= ( cAliasRD2 )->RD2_TREE

		//VERIFICA COM QUEM ESTA MAPA
		RBP->( dbSetOrder(1) ) //MAPA+AVALIADO+AVALIADOR+STATUS
		If RBP->( MsSeek(xFilial("RBP")+CodMap+EvaluatedId+EvaluatorId) )
			aTree:ListOfItem[nLen]:Author		 	:= RBP->RBP_AUTOR
		EndIf

		//CONSULTA HABILIDADES
		RBJ->( dbSetOrder(1) )
		If RBJ->( MsSeek(xFilial("RBJ")+( cAliasRD2 )->RD2_CODIGO+( cAliasRD2 )->RD2_ITEM) )
			nJ := 0
			aTree:ListOfItem[nLen]:ListOfSkills := {}
			While !RBJ->( Eof() ) .And. RBJ->(RBJ_FILIAL+RBJ_CODCOM+RBJ_ITECOM) == (xFilial("RBJ")+( cAliasRD2 )->RD2_CODIGO+( cAliasRD2 )->RD2_ITEM)

				nJ++
				aAdd(aTree:ListOfItem[nLen]:ListOfSkills, WsClassNew("SkillsList"))

				aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillId := RBJ->RBJ_HABIL
				//CONSULTA DESCRICAO DA HABILIDADE
				RBG->( dbSetOrder(1) )
				If RBG->(MsSeek(xFilial("RBG")+RBJ->RBJ_HABIL))
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillDescription	:= RBG->RBG_DESC
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillLevel			:= RBG->RBG_ESCALA



					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ CONSULTA PARA VERIFICAR RESPOSTA DA HABILIDADE  |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:EvaluatedCom	:= ""
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:EvaluatorCom	:= ""
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillAuthor		:= "1"
					RBP->( dbSetOrder(1) ) //MAPA+AVALIADO+AVALIADOR+STATUS
					If RBP->( MsSeek(xFilial("RBP")+CodMap+EvaluatedId+EvaluatorId) )
						RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
						If RBQ->( MsSeek(xFilial("RBQ")+RBP->RBP_CODMAP+EvaluatedId+PadR(RBP->RBP_VERSAO,5)+(cAliasRD2)->RD2_CODIGO+( cAliasRD2 )->RD2_ITEM+RBJ->RBJ_HABIL) )
							aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillLevelAnswer	:= RBQ->RBQ_ITEESC
							aTree:ListOfItem[nLen]:ListOfSkills[nJ]:EvaluatedCom		:= AllTrim(ApdMsmm(RBQ->RBQ_CMADO))
							aTree:ListOfItem[nLen]:ListOfSkills[nJ]:EvaluatorCom		:= AllTrim(ApdMsmm(RBQ->RBQ_CMADOR))
							aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillAuthor			:= RBP->RBP_AUTOR //1=AVALIADO; 2=AVALIADOR
							aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillStatus			:= RBQ->RBQ_STATUS //1(NADA),2(PENDENTE),3(APROVADO)
						EndIf
					EndIf

					//CONSULTA ITEM DE ESCALA DA HABILIDADE
					RBL->( dbSetOrder(1) )
					RBL->(MsSeek(xFilial("RBL")+RBG->RBG_ESCALA))
					nI := 0
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel := {}
					While !RBL->(Eof()) .And. xFilial("RBL") == RBL->RBL_FILIAL .And. RBL->RBL_ESCALA == RBG->RBG_ESCALA
						nI++
						aAdd(aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel, WsClassNew("LevelList"))

						aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel[nI]:LevelId          := RBL->RBL_ITEM
						aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel[nI]:LevelDescription := RBL->RBL_DESCRI

						RBL->(dbSkip())
					EndDo

				EndIf


				RBJ->( dbSkip() )
			EndDo
		EndIf


		Recursivo( cCodigo, ( cAliasRD2 )->RD2_TREE, ( cAliasRD2 )->RD2_ITEM, aTree:ListOfItem[nLen], CodMap, EvaluatedId, EvaluatorId )

		( cAliasRD2 )->( DbSkip() )
	EndDo
EndIf

RestArea( aArea )

Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ BrwEvaluated ³ Autor ³Juliana B. Mariano  ³Data ³16.05.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta todos os avaliados de acordo com mapa  			   ³±±
±±³          ³de conhecimento										       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Lista de avaliados							           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD BrwEvaluated WSRECEIVE UserCode, ParticipantId WSSEND ListOfEvaluated WSSERVICE RHKnowledge

Local nI		:= 0
Local lRetorno	:= .T.
Local aArea		:= GetArea()
Local lLibera	:= .F.

::ListOfEvaluated := {}
RBP->( dbSetOrder(3) ) //FILIAL+AVALIADOR
If RBP->( MsSeek(xFilial("RBP")+::ParticipantId) )
	While !RBP->( Eof() ) .And. RBP->(RBP_FILIAL+RBP_CODDOR) == (xFilial("RBP")+::ParticipantId)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICAR SE PERIODO ESTA DENTRO DA DATA ATUAL(PENDENTE)  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RBO->( dbSetOrder(1) ) //FILIAL+CODIGO+PERIODO
		If RBO->( MsSeek(xFilial("RBO")+RBP->RBP_CODMAP) )
			RDU->( dbSetOrder(1) ) //FILIAL+CODIGO
			If RDU->( MsSeek(xFilial("RDU")+RBO->RBO_PERIOD) )
				If RDU->RDU_DATFIM > date() //SE ESTIVER DENTRO DO PRAZO
					lLibera := .T.
				EndIf
			EndIf
    	EndIf

		//NAO PODE REPETIR NOME
    	If ascan(::ListOfEvaluated, { |x| x:EvaluatedId == RBP->RBP_CODADO }) == 0 .And. lLibera == .T.
			nI++
			aAdd(::ListOfEvaluated, WsClassNew("MapParticipant"))
			::ListOfEvaluated[nI]:EvaluatedId	:= RBP->RBP_CODADO
			::ListOfEvaluated[nI]:CodMap		:= RBP->RBP_CODMAP
			::ListOfEvaluated[nI]:Period		:= RDU->RDU_DESC
			::ListOfEvaluated[nI]:Author		:= IIf(RBP->RBP_AUTOR == "2", STR0027, STR0026)
			::ListOfEvaluated[nI]:LastApprove	:= RBP->RBP_DTAPRO
			::ListOfEvaluated[nI]:MapVersion	:= RBP->RBP_VERSAO
			//Pendente - Quando houver itens no mapa à ser revisado
			//Aprovado - Quando todos os itens todos os itens do mapa estão aprovados.
			//Editado - Quando um Mapa aprovado, foi editado e ainda não foi enviado para revisão.
			If RBP->RBP_STATUS == "1" .And. AllTrim(RBP->RBP_VERSAO) == "0"
				::ListOfEvaluated[nI]:StatusItem	:= STR0028
			ElseIf RBP->RBP_STATUS == "1" .And. AllTrim(RBP->RBP_VERSAO) != "0" .And. !Empty(RBP->RBP_VERSAO)
				::ListOfEvaluated[nI]:StatusItem	:= STR0029
			ElseIf RBP->RBP_STATUS == "2"
				::ListOfEvaluated[nI]:StatusItem	:= STR0030
			EndIf

			//VERIFICA SE EXISTE ALGUM ITEM PREENCHIDO
			RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
			If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO)) )
				::ListOfEvaluated[nI]:ExistItem := .T.
			Else
				::ListOfEvaluated[nI]:ExistItem := .F.
			EndIf

			if ! Empty(Posicione("SRA",1,buscaSRA(RBP->RBP_CODADO), "RA_NOMECMP"))
				::ListOfEvaluated[nI]:EvaluatedName	:= SRA->RA_NOMECMP
			Else
				RD0->( dbSetOrder(1) )
				If RD0->( MsSeek(xFilial("RD0")+RBP->RBP_CODADO) )
					::ListOfEvaluated[nI]:EvaluatedName	:= RD0->RD0_NOME
				EndIf
			EndIf

		EndIf
		RBP->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetMyMap	    ³ Autor ³Juliana B. Mariano  ³Data ³09.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta meu mapa								  			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Retorno ok									           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetMyMap WSRECEIVE UserCode, ParticipantId WSSEND ParticipantMap WSSERVICE RHKnowledge


Local lRetorno	:= .T.
Local aArea		:= GetArea()


If RBO->(FieldPos("RBO_FILIAL")) > 0
	If RBP->(FieldPos("RBP_FILIAL")) > 0
		If RBQ->(FieldPos("RBQ_FILIAL")) > 0

			RBP->( dbSetOrder(2) ) //FILIAL+AVALIADO
			If RBP->( MsSeek(xFilial("RBP")+::ParticipantId) )
				While !RBP->( Eof() ) .And. RBP->(RBP_FILIAL+RBP_CODADO) == (xFilial("RBP")+::ParticipantId)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ VERIFICAR SE PERIODO ESTA DENTRO DA DATA ATUAL(PENDENTE)  |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RBO->( dbSetOrder(1) ) //FILIAL+CODIGO+PERIODO
					If RBO->( MsSeek(xFilial("RBO")+RBP->RBP_CODMAP) )
						RDU->( dbSetOrder(1) ) //FILIAL+CODIGO
						If RDU->( MsSeek(xFilial("RDU")+RBO->RBO_PERIOD) )
							If RDU->RDU_DATFIM > date() //SE ESTIVER DENTRO DO PRAZO
								::ParticipantMap:CodMap			:= RBO->RBO_CODIGO
								::ParticipantMap:MapDescription	:= RBO->RBO_DESC
								::ParticipantMap:EvaluatorId	:= RBP->RBP_CODDOR
								::ParticipantMap:Period			:= RDU->RDU_DESC
								::ParticipantMap:Author			:= IIf(RBP->RBP_AUTOR == "2", STR0027, STR0026)
								::ParticipantMap:LastApprove	:= RBP->RBP_DTAPRO
								::ParticipantMap:MapVersion		:= RBP->RBP_VERSAO
								//Pendente - Quando houver itens no mapa à ser revisado
								//Aprovado - Quando todos os itens todos os itens do mapa estão aprovados.
								//Editado - Quando um Mapa aprovado, foi editado e ainda não foi enviado para revisão.
								If RBP->RBP_STATUS == "1" .And. AllTrim(RBP->RBP_VERSAO) == "0"
									::ParticipantMap:StatusItem	:= STR0028
								ElseIf RBP->RBP_STATUS == "1" .And. AllTrim(RBP->RBP_VERSAO) != "0" .And. !Empty(RBP->RBP_VERSAO)
									::ParticipantMap:StatusItem	:= STR0029
								ElseIf RBP->RBP_STATUS == "2"
									::ParticipantMap:StatusItem	:= STR0030
								EndIf

								//NOME DO AVALIADOR
								If ! Empty(Posicione("SRA",1,buscaSRA(RBP->RBP_CODDOR), "RA_NOMECMP"))
									::ParticipantMap:EvaluatorName	:= SRA->RA_NOMECMP
								Else
									RD0->( dbSetOrder(1) )
									If RD0->( msSeek(xFilial("RD0")+RBP->RBP_CODDOR) )
										::ParticipantMap:EvaluatorName	:= RD0->RD0_NOME
									EndIf
								EndIf

								//VERIFICA SE EXISTE ALGUM ITEM PREENCHIDO
								RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
								If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO)) )
			    					::ParticipantMap:ExistItem := .T.
								Else
			    					::ParticipantMap:ExistItem := .F.
								EndIf

								Exit
							EndIf
						EndIf
			    	EndIf

			     	RBP->( DbSkip() )
				EndDo
			Else
				lRetorno := .F.
				SetSoapFault("GETMYMAP",STR0017) //"Mapa nao encontrado"
			EndIf
		Else
			lRetorno := .F.
			SetSoapFault("GETMYMAP",STR0032)	//"Campos nao encontrados na tabela RBQ. Verficar se tabela existe e cadastrar campos."
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("GETMYMAP",STR0033)	//"Campos nao encontrados na tabela RBP. Verficar se tabela existe e cadastrar campos."
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("GETMYMAP",STR0034)	//"Campos nao encontrados na tabela RBO. Verficar se tabela existe e cadastrar campos."
EndIf

RestArea(aArea)
Return lRetorno



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetHeaderPart ³Autor  ³Juliana B. Mariano  ³ Data ³17.05.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo de consulta de dados do participante, relativo ao mapa³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Participante                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de consulta de dados do participante, relativo ao mapa³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetHeaderPart WSRECEIVE UserCode,ParticipantId, Type, CodMap WSSEND PartHeader WSSERVICE RHKnowledge

Local aArea     := GetArea()
Local lRetorno	:= .T.
Local lLibera 	:= .F.
Local dUltData	:= ""
Local cCodVis 	:= ""
Local cIteVis 	:= ""
Local aParams	:= {}

DEFAULT ::Type := "1"

//If PrtChkUser(::UserCode,"RHPerformanceEvaluate","GetParticipant","RD0",::ParticipantId)
	If !Empty(::ParticipantId)
		RBP->( dbSetOrder(2) ) //FILIAL+CODMAPA+AVALIADO+AVALIADOR+STATUS
		If RBP->( MsSeek(xFilial("RBP")+::ParticipantId) )
			While !RBP->(Eof()) .And. RBP->(RBP_FILIAL+RBP_CODADO) == (xFilial("RBP")+::ParticipantId)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SE BUSCAR HISTORICO, CODMAP DEVE VIR PREENCHIDO			  |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (::Type == "2" .And. ::CodMap == RBP->RBP_CODMAP) .Or. ::Type == "1"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ VERIFICAR SE PERIODO ESTA DENTRO DA DATA ATUAL(PENDENTE)  |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RBO->( dbSetOrder(1) ) //FILIAL+CODIGO+PERIODO
					If RBO->( MsSeek(xFilial("RBO")+RBP->RBP_CODMAP) )
						RDU->( dbSetOrder(1) ) //FILIAL+CODIGO
						If RDU->( MsSeek(xFilial("RDU")+RBO->RBO_PERIOD) )
							If RDU->RDU_DATFIM > date() .And. ::Type == "1" //SE ESTIVER DENTRO DO PRAZO
								lLibera := .T.
							ElseIf RDU->RDU_DATFIM < date() .And. ::Type == "2" //SE ESTIVER FINALIZADO
								lLibera := .T.
							EndIf
						EndIf
			    	EndIf

			    	If lLibera == .T.
						::PartHeader := WsClassNew('HeaderParticipant')
						::PartHeader:LastApproveMap	:= RBP->RBP_DTAPRO
						::PartHeader:CodMap			:= RBP->RBP_CODMAP
						::PartHeader:MapDesc		:= RBO->RBO_DESC
						::PartHeader:CodPeriod		:= RBO->RBO_PERIOD
						::PartHeader:PeriodDesc		:= RDU->RDU_DESC
						::PartHeader:Version		:= RBP->RBP_VERSAO
						::PartHeader:Author			:= RBP->RBP_AUTOR

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ CONSULTA DADOS DO AVALIADO  |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RD0->( dbSetOrder(1) )
						If RD0->( MsSeek(xFilial("RD0") + ::ParticipantId) )
							::PartHeader:PartId			:= RD0->RD0_CODIGO
							If ! Empty(Posicione("SRA",1,buscaSRA(::PartHeader:PartId), "RA_NOMECMP"))
								::PartHeader:PartName		:= SRA->RA_NOMECMP
							Else 
								::PartHeader:PartName		:= RD0->RD0_NOME
							EndIf

							if ExistBlock("DADOSFUNC")
								aAdd(aParams, "")
								aAdd(aParams, "")
								aAdd(aParams, "")							
								aAdd(aParams, ::ParticipantId)

								aAux := U_DADOSFUNC( aParams )

								if len(aAux) > 0
									::PartHeader:PartArea     := aAux[1][7]
									::PartHeader:PartFunction := aAux[1][9]
								else
									::PartHeader:PartArea     := ""
									::PartHeader:PartFunction := ""
								endif
							else						
								::PartHeader:PartArea		:= GetFunCCDesc(::ParticipantId)
								::PartHeader:PartFunction	:= GetNivelCarreira(::ParticipantId)[2]
							Endif
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ CONSULTA DADOS DO AVALIADOR  |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RD0->( dbSetOrder(1) )
						If RD0->( MsSeek(xFilial("RD0")+RBP->RBP_CODDOR) )
							::PartHeader:PartEvaluatorId	:= RD0->RD0_CODIGO
							If ! Empty(Posicione("SRA",1,buscaSRA(::PartHeader:PartEvaluatorId), "RA_NOMECMP"))
								::PartHeader:PartEvaluator		:= SRA->RA_NOMECMP
							Else
								::PartHeader:PartEvaluator		:= RD0->RD0_NOME
							EndIf
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ RETORNAR O LIDER HIERARQUICO DO AVALIADO CONFORME VISAO |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cCodVis := ""
						If RBO->( FieldPos("RBO_VISAO") ) > 0
							cCodVis := RBO->RBO_VISAO
						Else
							::PartHeader:PartLeader 	:= "NOFIELD"
						EndIf

						cIteVis	:= ""
						If !Empty(cCodVis)
						   	RDE->(MsSeek(xFilial("RDE")+::ParticipantId+cCodVis ,.T.))
						   	While !RDE->( Eof() ) .And. ::ParticipantId+cCodVis == RDE->RDE_CODPAR+RDE->RDE_CODVIS
								If RDE->RDE_STATUS == "1" //SE STATUS ATUAL ESTA ATIVO
									cIteVis := RDE->RDE_ITEVIS
									Exit
								EndIf
								RDE->( dbSkip() )
						   	EndDo

							aSub := {}
							ApdaDorNivel( cIteVis , xFilial("RDE") ,cCodVis , "2" , 1, aSub )
							If Len(aSub) > 0
								::PartHeader:PartLeaderId 	:= aSub[1][1]
								::PartHeader:PartLeader	 	:= FDesc("RD0", aSub[1][1], "RD0_NOME")
							Else
								::PartHeader:PartLeaderId 	:= ""
								::PartHeader:PartLeader	 	:= ""
							EndIf
						EndIf


						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ PARA GRAVAR DATA DA ULTIMA ATUALIZACAO  |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
						If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO)) )
							dUltData := RBQ->RBQ_DATITM
							While !RBQ->(Eof()) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO) == (xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO))
								If dUltData < RBQ->RBQ_DATITM
									dUltData := RBQ->RBQ_DATITM
								EndIf

								RBQ->( DbSkip() )
							EndDo

							::PartHeader:LastUpdateMap	:= dUltData
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ GRAVA APENAS OS DADOS DO PRIMEIRO MAPA  |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Exit
					EndIf
				EndIf
				RBP->( DbSkip() )
			EndDo
		Else
			lRetorno := .F.
			SetSoapFault("GETHEADERPART",STR0018) //"Participante nao encontrado no cadastro de itens do mapa"
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("GETHEADERPART",STR0019) //"Codigo do participante invalido"
	EndIf
//Else
//	lRetorno := .F.
//EndIf

RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutEvaluatedMa³Autor  ³Juliana B. Mariano  ³ Data ³17.05.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo de consulta de dados do participante, relativo ao mapa³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Participante                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de consulta de dados do participante, relativo ao mapa³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD PutEvaluatedMap WSRECEIVE UserCode,ParticipantId, CodMap, EvaluatorId WSSEND WsNull WSSERVICE RHKnowledge

Local aArea       := GetArea()
Local lRetorno    := .T.

//If PrtChkUser(::UserCode,"RHPerformanceEvaluate","GetParticipant","RD0",::ParticipantId)
	If !Empty(::ParticipantId) .And. !Empty(::CodMap) .And. !Empty(::EvaluatorId)

		//CONSULTA MAPA POR PARTICIPANTE
		RBP->( dbSetOrder(1) ) //FILIAL+CODMAPA+AVALIADO+AVALIADOR+STATUS
		If RBP->( MsSeek(xFilial("RBP")+::CodMap+::ParticipantId) )
			Reclock("RBP",.F.)

			RBP->RBP_CODDOR := ::EvaluatorId
			//se versao estiver em branco, cadastrar 0(default)
			If Empty(RBP->RBP_VERSAO)
				RBP->RBP_VERSAO := "0"
			EndIf

			RBP->( MsUnlock() )

			//Consulta itens do mapa, se existirem itens importados da tabela RBI, cadastrar avaliador
			RBQ->( dbSetOrder(1) )
			If RBQ->( MsSeek( xFilial("RBQ")+::CodMap+::ParticipantId ) )
				While !RBQ->( Eof()	 ) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO) == ( xFilial("RBQ")+::CodMap+::ParticipantId )
					If Empty(RBQ->RBQ_CODDOR)
						RecLock("RBQ", .F.)
							RBQ->RBQ_CODDOR := ::EvaluatorId
							If Empty(RBQ->RBQ_STATUS) //CADASTRAR STATUS = 4 (EDITADO)
								RBQ->RBQ_STATUS := "4"
							EndIf
							If Empty(RBQ->RBQ_VERSAO) //CADASTRAR VERSAO = 0 (VERSAO INICIAL)
								RBQ->RBQ_VERSAO := "0"
							EndIf
							If Empty(RBQ->RBQ_AUTOR) //CADASTRAR AUTOR = 1 (AVALIADO)
								RBQ->RBQ_VERSAO := "1"
							EndIf
						RBQ->( MsUnlock() )
					EndIf

					RBQ->( dbSkip() )
				EndDo
			EndIf
		Else
			lRetorno := .F.
			SetSoapFault("PutEvaluatedMap",STR0020) //"Participante nao possui mapa cadastrado"
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("PutEvaluatedMap",STR0021) //"Faltando parametro de entrada obrigatorio"
	EndIf
//Else
//	lRetorno := .F.
//EndIf

RestArea(aArea)
Return lRetorno



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetToRevision ³ Autor ³Juliana B. Mariano  ³Data ³06.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de para setar status de mapa com avaliador ou		   ³±±
±±³          ³avaliado												       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD SetToRevision WSRECEIVE UserCode, CodMap, ParticipantId, EvaluatorId, Author WSSEND WsNull WSSERVICE RHKnowledge

Local lRetorno	:= .T.
Local aArea		:= GetArea()

If Empty(::Author)
	::Author := "1"
EndIf

	RBP->( dbSetOrder(1) ) //RBP_FILIAL+RBP_CODMAP+RBP_CODADO+RBP_CODDOR+RBP_STATUS
	If RBP->( MsSeek(xFilial("RBP")+::CodMap+::ParticipantId+::EvaluatorId) )
		//ESTA MANDANDO PARA AVALIACAO DO CORRESPONDENTE
		//SE ESTIVER COM O AVALIADO, MANDA PARA REVISAO DO AVALIADOR E VICE-VERSA
		RecLock("RBP",.F.)
		If ::Author == "1"
			RBP->RBP_AUTOR := "2"
		Else
			RBP->RBP_AUTOR := "1"
		EndIf
		RBP->( MsUnlock() )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE ITEM JA ESTA GRAVADO PARA QUE POSSA SER ALTERADO OU INCLUIDO  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
		If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO)) )
			While !RBQ->(Eof()) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO) == xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO)

				//If RBQ->RBQ_AUTOR == "1" //MODIFICA SE ITEM ESTIVER COM AVALIADO
					RecLock("RBQ")

					//RBQ->RBQ_AUTOR  := "2" //AVALIADOR
					If RBQ->RBQ_STATUS == "4" //GAMBI PARA QUE GRAVE APENAS AS HABILIDADES ALTERADAS COM STATUS 2
						RBQ->RBQ_STATUS := "2" //NECESSITA REVISAO
					/*Else
						RBQ->RBQ_STATUS := "1" //EM BRANCO*/
					EndIf

					RBQ->( MsUnlock() )
				//EndIf

				RBQ->( DbSkip() )
			EndDo
		Else
			lRetorno := .F.
			SetSoapFault("SetToRevision",STR0022)		 //"Itens do mapa de conhecimento nao encontrados"
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("SetToRevision",STR0023) //"Mapa de conhecimento nao encontrado"
	EndIf

RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetEvaluatorRe³ Autor ³Juliana B.   		 ³Data ³06.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de para setar status de mapa com avaliado			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD SetEvaluatorRevision WSRECEIVE UserCode, LevelSkill WSSEND WsNull WSSERVICE RHKnowledge

Local lRetorno	:= .T.
Local nI		:= 0
Local aArea		:= GetArea()



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVA CODIGO DO RESPONSAVEL DO ITEM PARA 1 = AVALIADO	E COMENTARIO  	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 to len(::LevelSkill:Skills)
		RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
		If RBQ->( MsSeek(xFilial("RBQ")+::LevelSkill:Skills[nI]:CodMap+::LevelSkill:Skills[nI]:EvaluatedId+::LevelSkill:Skills[nI]:ItemVersion+::LevelSkill:Skills[nI]:CompetenceId+::LevelSkill:Skills[nI]:CompetenceItemId+::LevelSkill:Skills[nI]:SkillId) )
			RecLock("RBQ",.F.)

			RBQ->RBQ_AUTOR  := "1"
			RBQ->RBQ_STATUS := "2"
 			If !Empty(::LevelSkill:Skills[nI]:EvaluatorCom)
				ApdMsmm(RBQ->RBQ_CMADOR,,, ::LevelSkill:Skills[nI]:EvaluatorCom,1,,,"RBQ","RBQ_CMADOR")
			EndIf

			RBQ->( MsUnlock() )
		EndIf
	Next nI

/*	Else
		lRetorno := .F.
		SetSoapFault("SetToRevision","Mapa de conhecimento nao encontrado")
	EndIf		*/

RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ApproveMap    ³ Autor ³Juliana B. Mariano  ³Data ³07.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para aprovar os itens do mapa de conhecimento		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ApproveMap WSRECEIVE UserCode, CodMap, ParticipantId, EvaluatorId, Sincron WSSEND WsNull WSSERVICE RHKnowledge

Local lRetorno	:= .T.
Local aArea		:= GetArea()
Local aRet		:= {}


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE PARTICIPANTE E FUNCIONARIO E PEGA COD MATRICULA	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Participant( ::ParticipantId, aRet )


	RBP->( dbSetOrder(1) ) //RBP_FILIAL+RBP_CODADO+RBP_CODDOR+RBP_STATUS
	If RBP->( MsSeek(xFilial("RBP")+::CodMap+::ParticipantId+::EvaluatorId) )

		BEGIN TRANSACTION

			RecLock("RBP",.F.)
			RBP->RBP_DTAPROV	:= date()
			RBP->RBP_STATUS		:= "2" //1=PENDENTE; 2=APROVADO; 3=FINALIZADO
			RBP->RBP_AUTOR		:= "1" //1=AVALIADO; 2=AVALIADOR
			RBP->(MsUnlock())


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ALTERA TODOS OS ITENS PARA STATUS DE APROVADO			|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
			If RBQ->( MsSeek(xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO)) )
				While !RBQ->(Eof()) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO) == xFilial("RBQ")+RBP->(RBP_CODMAP+RBP_CODADO+RBP_VERSAO)

					RecLock("RBQ")
					RBQ->RBQ_STATUS := "3" //APROVADO
					RBQ->( MsUnlock() )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ VERIFICA STATUS DO SINCRON E GRAVAR DADOS												|
					//³ SINCRON PODE RETORNAR EM BRANCO, 0, 1 OU 2												|
					//³ QUALQUER RETORNO DIFERENTE DE 1 OU 2, NAO GRAVAR NADA									|
					//³ SE SINCRON = 1: GRAVAR AS RESPOSTAS DA RBQ APENAS NAS HABILIDADES QUE JA EXISTEM NA RBI	|
					//³ SE SINCRON = 2: GRAVAR AS RESPOSTAS DA RBQ NAS HABILIDADES QUE JA EXISTEM NA RBI E 		|
					//³ GRAVAR AS HABILIDADES QUE NAO EXISTEM E AS RESPECTIVAS RESPOSTAS						|
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If len(aRet) > 0 .And. ( ::Sincron == "1" .Or. ::Sincron == "2" )
						RBI->( dbSetOrder(1) )
						If RBI->( MsSeek(xFilial("RBI")+aRet[1]+RBQ->RBQ_HABIL) )
                        	RecLock("RBI", .F.)
                        		RBI->RBI_ITESCA := RBQ->RBQ_ITEESC
                        		RBI->RBI_TIPGRV := "P" //Indica que registro veio da web (portal rh)
                        	RBI->( MsUnlock() )
						ElseIf ::Sincron == "2"
                        	RecLock("RBI", .T.)
								RBI->RBI_FILIAL	:= xFilial("RBI")
								RBI->RBI_MAT	:= aRet[1]
								RBI->RBI_HABIL	:= RBQ->RBQ_HABIL
								RBI->RBI_ESCALA	:= RBQ->RBQ_ESCALA
								RBI->RBI_ITESCA := RBQ->RBQ_ITEESC
                        		RBI->RBI_TIPGRV := "P" //Indica que registro veio da web (portal rh)
                        	RBI->( MsUnlock() )
						EndIf
					EndIf


					RBQ->( DbSkip() )
				EndDo
			Else
				lRetorno := .F.
				SetSoapFault("SetToRevision",STR0022)		 //"Itens do mapa de conhecimento nao encontrados"
			EndIf

		END TRANSACTION

	Else
		lRetorno := .F.
		SetSoapFault("SetToRevision",STR0023) //"Mapa de conhecimento nao encontrado"
	EndIf

RestArea(aArea)
Return lRetorno



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetMapHistory ³ Autor ³Juliana B. Mariano  ³Data ³08.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta se avaliado tem algum mapa finalizado			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetMapHistory WSRECEIVE UserCode, ParticipantId, Type WSSEND MapHistory WSSERVICE RHKnowledge

Local lRetorno	:= .T.
Local nI		:= 0
Local nY		:= 0
Local aArea		:= GetArea()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MAPAS FINALIZADOS SAO AQUELES QUE A DATA FINAL E MENOR QUE A DATA ATUAL   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If ::Type == "1" //SE ACESSO DO AVALIADO
		RBP->( dbSetOrder(2) ) //RBP_FILIAL+RBP_CODADO+RBP_CODDOR+RBP_STATUS
	Else //SE ACESSO DO AVALIADOR
		RBP->( dbSetOrder(3) ) //RBP_FILIAL+RBP_CODDOR+RBP_CODADO+RBP_STATUS
	EndIf
	If RBP->( MsSeek(xFilial("RBP")+::ParticipantId) )
		While !RBP->(Eof()) .And. IIf(::Type == "1", RBP->(RBP_FILIAL+RBP_CODADO) == xFilial("RBP")+::ParticipantId, RBP->(RBP_FILIAL+RBP_CODDOR) == xFilial("RBP")+::ParticipantId)
		    RBO->( dbSetOrder(1) ) //BUSCA MAPA
            If RBO->(MsSeek(xFilial("RBO")+RBP->RBP_CODMAP))
	            RDU->( dbSetOrder(1) ) //BUSCA PERIODO
    	        If RDU->(MsSeek(xFilial("RDU")+RBO->RBO_PERIOD))
					If RDU->RDU_DATFIM < date() //SIGNIFICA QUE ESTA FINALIZADO
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ SO GRAVA SE NAO FOR AVALIADO REPETIDO   |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ascan( ::MapHistory, {|x| x:ParticipantId == RBP->RBP_CODADO} ) == 0
							nY++
							aadd( ::MapHistory, WsClassNew("HistoryMap") )
							::MapHistory[nY]:ParticipantId := RBP->RBP_CODADO
							RD0->( dbSetOrder(1) )
							If RD0->( MsSeek(xFilial("RD0")+RBP->RBP_CODADO) )
								::MapHistory[nY]:ParticipantName := RD0->RD0_NOME
							EndIf
							::MapHistory[nY]:ListOfPeriod := {}
							nI := 0
						EndIf


						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ GRAVA PERIODOS FINALIZADOS   |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nI++
						aAdd(::MapHistory[nY]:ListOfPeriod, WsClassNew("PeriodList"))
						::MapHistory[nY]:ListOfPeriod[nI]:PeriodId		:= RDU->RDU_CODIGO
						::MapHistory[nY]:ListOfPeriod[nI]:PeriodDesc	:= RDU->RDU_DESC
						::MapHistory[nY]:ListOfPeriod[nI]:Version		:= RBP->RBP_VERSAO //NAO DEVERIA ESTAR AQUI, MAS A BASE NAO PERMITE OUTRO TIPO DE CONSULTA
						::MapHistory[nY]:ListOfPeriod[nI]:CodMap		:= RBP->RBP_CODMAP

					EndIf
				EndIf
			EndIf


			RBP->(DbSkip())
		EndDo
	EndIf

RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BRWHISTORY    ³ Autor ³Juliana B. Mariano  ³Data ³13.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para consultar habilidades do historico por versao	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD BrwHistory WSRECEIVE UserCode, ParticipantId, EvaluatorId, CodMap, Version WSSEND ListOfCompetenceItem WSSERVICE RHKnowledge


Local lRetorno	:= .T.
Local aArea		:= GetArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CONSULTA TODAS AS COMPETENCIAS QUE PERMITEM ENTRADA DE DADOS	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RDM->( DbSetOrder(1) )
	If RDM->( MsSeek(xFilial("RDM")) )
		While !RDM->( Eof() ) .And. RDM->RDM_FILIAL == xFilial("RDM")
			If RDM->RDM_TIPO == "2"
				HistoricoRec( RDM->RDM_CODIGO, , , ::ListOfCompetenceItem, ::ParticipantId, ::EvaluatorId, ::CodMap, ::Version )
			EndIf
			RDM->( DbSkip() )
		EndDo
	Else
		lRetorno := .F.
		SetSoapFault("BrwHistory",STR0024) //"Nao ha competencias cadastradas"
  	EndIf

RestArea(aArea)
Return lRetorno




/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³HistoricoRec	³ Autor ³Juliana B. Mariano  ³Data ³13.06.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo que consulta item de competencia para montar tree	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Array com retorno da tree					           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function HistoricoRec( cCodigo, cTree, cItem, aTree, EvaluatedId, EvaluatorId, CodMap, Versao )

Local lRetorno	:= .T.
Local aArea 	:= RD2->( GetArea() )
Local cAliasRD2 := "RD2"
Local nLen 		:= 0
Local nJ 		:= 0
Local nI 		:= 0

DEFAULT cItem := "000000"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA NA ARVORE APENAS OS ITENS QUE POSSUEM HABILIDADES PREENCHIDAS		|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

( cAliasRD2 )->( DbSetOrder( 2 ) )

If ( cAliasRD2 )->( MsSeek( xFilial( "RD2" ) + cCodigo + cItem ) )
	While !( cAliasRD2 )->( EOF() ) .AND. ;
		( cAliasRD2 )->RD2_FILIAL == xFilial( "RD2" ) .AND. ;
		( cAliasRD2 )->RD2_CODIGO == cCodigo .AND. ;
		( cAliasRD2 )->RD2_TREE == cItem



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVA OS DADOS DO CABECALHO		|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( aTree:ListOfItem )
			aTree:ListOfItem := {}
		EndIf

		aAdd( aTree:ListOfItem, WsClassNew( "ItemList" ) )
		nLen := Len( aTree:ListOfItem )

		aTree:ListOfItem[nlen]:CompetenceId 		:= ( cAliasRD2 )->RD2_CODIGO
		RDM->(DbSetOrder(1))
		If RDM->( MsSeek(xFilial("RDM")+( cAliasRD2 )->RD2_CODIGO) )
			aTree:ListOfItem[nlen]:CompetenceDesc 	:= RDM->RDM_DESC
		EndIf
		aTree:ListOfItem[nlen]:CompetenceItem 		:= ( cAliasRD2 )->RD2_ITEM
		aTree:ListOfItem[nLen]:CompetenceItemDesc 	:= AllTrim( ( cAliasRD2 )->RD2_DESC )
		aTree:ListOfItem[nLen]:CompetenceTree	 	:= ( cAliasRD2 )->RD2_TREE


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PRIMEIRO VERIFICA SE EXISTEM DADOS GRAVADOS PARA ESTES ITENS DE COMP.	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
		If RBQ->( MsSeek(xFilial("RBQ")+CodMap+EvaluatedId+PadR(Versao,5)+(cAliasRD2)->RD2_CODIGO+( cAliasRD2 )->RD2_ITEM) )

			nJ := 0
			aTree:ListOfItem[nLen]:ListOfSkills := {}

			While !RBQ->( Eof() ) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM) == (xFilial("RBQ")+CodMap+EvaluatedId+PadR(Versao,5)+(cAliasRD2)->RD2_CODIGO+( cAliasRD2 )->RD2_ITEM)

				aAdd(aTree:ListOfItem[nLen]:ListOfSkills, WsClassNew("SkillsList"))
				nJ++

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ CONSULTA DADOS DA HABILIDADE	|
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				//CONSULTA DESCRICAO DA HABILIDADE
				RBG->( dbSetOrder(1) )
				If RBG->(MsSeek(xFilial("RBG")+RBQ->RBQ_HABIL))
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillDescription	:= RBG->RBG_DESC
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillLevel			:= RBG->RBG_ESCALA
				EndIf
				aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillId 			:= RBQ->RBQ_HABIL
				aTree:ListOfItem[nLen]:ListOfSkills[nJ]:SkillLevelAnswer	:= RBQ->RBQ_ITEESC
				aTree:ListOfItem[nLen]:ListOfSkills[nJ]:EvaluatedCom		:= AllTrim(ApdMsmm(RBQ->RBQ_CMADO))
				aTree:ListOfItem[nLen]:ListOfSkills[nJ]:EvaluatorCom		:= AllTrim(ApdMsmm(RBQ->RBQ_CMADOR))

				//CONSULTA ITEM DE ESCALA DA HABILIDADE
				RBL->( dbSetOrder(1) )
				RBL->(MsSeek(xFilial("RBL")+RBG->RBG_ESCALA))
				nI := 0
				aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel := {}
				While !RBL->(Eof()) .And. xFilial("RBL") == RBL->RBL_FILIAL .And. RBL->RBL_ESCALA == RBG->RBG_ESCALA
					nI++
					aAdd(aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel, WsClassNew("LevelList"))

					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel[nI]:LevelId          := RBL->RBL_ITEM
					aTree:ListOfItem[nLen]:ListOfSkills[nJ]:ListOfLevel[nI]:LevelDescription := RBL->RBL_DESCRI

					RBL->(dbSkip())
				EndDo

				RBQ->( dbSkip() )
			EndDo
		EndIf

		HistoricoRec( cCodigo, ( cAliasRD2 )->RD2_TREE, ( cAliasRD2 )->RD2_ITEM, aTree:ListOfItem[nLen], EvaluatedId, EvaluatorId, CodMap, Versao )

		( cAliasRD2 )->( DbSkip() )
	EndDo
EndIf

RestArea( aArea )

Return lRetorno



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetChangedItem³Autor  ³Juliana Barros	 	 ³ Data ³01.07.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Metodo para verificar se existe item alterado na versao	   ³±±
±±³          ³atual do mapa de conhecimento								   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Participante                                ³±±
±±³          ³ExpC2: Codigo do avaliador	                               ³±±
±±³          ³ExpC2: Codigo do mapa			                               ³±±
±±³          ³ExpC2: Codigo da versao atual	                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que existe ou nao itens alterados	           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo para verificar se existe item alterado na versao	   ³±±
±±³          ³atual do mapa de conhecimento								   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetChangedItem WSRECEIVE UserCode,ParticipantId, EvaluatorId, CodMap, Version WSSEND ChangedItem WSSERVICE RHKnowledge

Local aArea     := GetArea()
Local lRetorno	:= .T.


//If PrtChkUser(::UserCode,"RHPerformanceEvaluate","GetParticipant","RD0",::ParticipantId)

	::ChangedItem := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PARA VERIFICAR SE EXISTE ALGUM ITEM ALTERADO  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RBQ->( dbSetOrder(1) ) //RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO+RBQ_CODCOM+RBQ_ITECOM+RBQ_HABIL+RBQ_CODDOR
	If RBQ->( MsSeek(xFilial("RBQ")+::CodMap+::ParticipantId+::Version) )
		While !RBQ->(Eof()) .And. RBQ->(RBQ_FILIAL+RBQ_CODMAP+RBQ_CODADO+RBQ_VERSAO) == (xFilial("RBQ")+::CodMap+::ParticipantId+::Version)
			If RBQ->RBQ_STATUS == "4"
				::ChangedItem := .T.
    			Exit
			EndIf

			RBQ->( DbSkip() )
		EndDo
	Else
		lRetorno := .F.
		SetSoapFault("GetChangedItem",STR0031) //"Nao existem itens preenchidos no mapa de conhecimento"
	EndIf
//Else
//	lRetorno := .F.
//EndIf

RestArea(aArea)
Return lRetorno


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutMentor	 	 ³ Autor ³Emerson Grassi      ³Data ³19/01/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inclusao do mentor											³±±
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
WSMETHOD PutMentor WSRECEIVE UserCode, ParticipantID, CodMentor, CodMap, Version WSSEND WsNull WSSERVICE RHKnowledge

Local aArea     := GetArea()
Local lRetorno  := .T.

	// Altera o Mentor no cadastro de Participantes (RD0)
	If !Empty(::ParticipantId) .And. !Empty(::CodMentor)

		dbSelectArea("RD0")
		dbSetOrder(1)
		If MsSeek( xFilial("RD0")+::ParticipantId )
			Reclock("RD0",.F.)

			RD0->RD0_CODMEN	:= ::CodMentor

			MsUnlock()
		Else
			lRetorno := .F.
			SetSoapFault("PutCourse",STR0019) //"Codigo do participante invalido"
		EndIf
	EndIf


	// Altera o Mentor no Mapa (RBP)
	If !Empty(::ParticipantId) .And. !Empty(::CodMentor)

		dbSelectArea("RBP")
		dbSetOrder(4)
		If MsSeek( xFilial("RBP")+::ParticipantId+::CodMap+::Version )
			Reclock("RBP",.F.)

			RBP->RBP_CODDOR	:= ::CodMentor

			MsUnlock()
		Else
			lRetorno := .F.
			SetSoapFault("PutCourse",STR0019) //"Codigo do participante invalido"
		EndIf
	EndIf


RestArea(aArea)
Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwMentors    ³ Autor ³Emerson Grassi Rocha³Data ³16.01.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de recuperacao da lista de Mentores	  			   ³±±
±±³          ³Executada quando chama o pop-up de selecao de Mentor	       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³												               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD BrwMentors WSRECEIVE UserCode, MentorName WSSEND ListOfMentor WSSERVICE RHKnowledge

local nPos := 1

dbSelectArea("RD0")
dbSetOrder(2)

	if MentorName != ""
		dbSeek(xFilial("RD0")+Upper(MentorName))
		::ListOfMentor := {}

		While !Eof() .And. (RD0_FILIAL == xFilial("RD0")) .And. Subs(RD0->RD0_NOME,1,len(MentorName)) == Upper(MentorName)

			aAdd(::ListOfMentor, wsClassNew("Mentors"))
			::ListOfMentor[nPos]:MentorID 	:= RD0->RD0_CODIGO
			::ListOfMentor[nPos]:MentorName	:= RD0->RD0_NOME
			nPos ++

			dbSkip()
		endDo
    endif


Return .T.


function wsapd012_xxx()
return
