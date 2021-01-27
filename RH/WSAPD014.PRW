#INCLUDE "WSAPD014.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
//WsClient_WsRhEmployedCurriculum.prx
/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍ³±±
±±³Data Fonte Sustentação³ ChangeSet ³±±
±±³ÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ³±±  
±±³    07/08/2015        ³  321209   ³±± 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍ±±
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSAPD014  ³ Autor ³Rogerio Augusto	          ³ Data ³23.12.2004  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pelos itens do curriculo                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ Requisito  ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson Campos|30/04/14|TPKFN9      |Replica das alterações realizadas pela    ³±±
±±³              |        |            |manutenção até a data de 31/04/14 chamado ³±± 
±±³              |        |            |TPCW74, changeset 217161 na P11.80        ³±±
±±³              |        |            |Remoção de alguns fieldpos                ³±±
±±³Cícero Alves  |07/08/15|TTAIJ2      |Alteração para enviar o nome completo 	  ³±±
±±³              |        |            |quando estiver preenchido				  ³±±
±±³Allyson M     |30/10/15|TTPURR	   |Ajuste para permitir login de funcionários³±±
±±³              |        |      	   |demitidos quando parametro MV_TCFVREN esti³±±
±±³              |        |     	   |ver habilitado.                           ³±±
±±³Joao Balbino  |02/02/16|TUFBJD      |Ajuste para identificar corretamente ou   ³±±
±±³              |        |            |cadastrar corretamente o curso no         ³±±
±±³              |        |            |Curriculo Eletronico                      ³±±
±±³M. Silveira   |20/04/17|DRHPONTP-69 |Ajuste em MatParticipant() e Participant()³±±
±±³              |        |            |p/ retirar os espacos da query ao comparar³±±
±±³              |        |            |os campos RDZ_CODENT e Filial/Matricula.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT ItensMenu
	WSDATA UserName				As String OPTIONAL	//Nome do participante
	WSDATA ItemCod				As String OPTIONAL	//Codigo do Item
	WSDATA ItemDesc				As String OPTIONAL	//Descricao do Item
	WSDATA ItemLevel				As String OPTIONAL	//Nivel do item
	WSDATA ItemStatus				As String OPTIONAL	//Status do Item
	WSDATA ItemType				As String OPTIONAL	//Pagina para onde linkara a tela
	WSDATA Data					As Boolean OPTIONAL	//Se existe itens preenchidos
ENDWSSTRUCT

WSSTRUCT CourseList //Lista de cursos cadastrados pelo usuario na SQ9
	WSDATA CourseCod				As String 			//Codigo do Curso
	WSDATA CourseName				As String OPTIONAL	//Descricao do Curso
	WSDATA CourseMat				As String OPTIONAL	//Matricula do Participante
	WSDATA CourseEnt				As String OPTIONAL	//Codigo da Instituicao de Ensino
	WSDATA CourseEntDesc	    	As String OPTIONAL	//Descricao Instituicao de Ensino
	WSDATA CourseCDate		   	As Date	OPTIONAL	//Data de conclusao
	WSDATA CourseIDate		   	As Date	OPTIONAL	//Data de Inicio
	WSDATA CourseTypeLv		   	As String OPTIONAL	//Codigo do nivel de graduacao do curso
	WSDATA CourseType				As String OPTIONAL	//Nivel de graduacao do curso
	WSDATA CourseStatusLv	  	As String OPTIONAL	//Codigo do status de conclusao do curso
	WSDATA CourseStatus		   	As String OPTIONAL	//Status de conclusao do curso
	WSDATA CourseTime				As Float  OPTIONAL	//Carga horaria do curso
	WSDATA CourseDesc				As String OPTIONAL	//Descricao do conteudo do curso
	WSDATA OtherEnt			   	As String OPTIONAL	//Descricao de entidade nao cadastrada
	WSDATA OtherCert				As String OPTIONAL	//Descricao de certificacao nao cadastrada
	WSDATA CourseInclude	    	As Boolean OPTIONAL	//Inclusao de curso inclusao=.T. alteracao=.F.
	WSDATA RegRecno			   	As Integer OPTIONAL	//Recno (identificador unico)
ENDWSSTRUCT

WSSTRUCT CourseNames //Lista de cursos disponiveis para selecao no sistema
	WSDATA CourseCod				As String 			//Codigo do Curso
	WSDATA CourseName				As String OPTIONAL	//Descricao do Curso
ENDWSSTRUCT

WSSTRUCT CourseScaleList //Lista de niveis de graduacao para selecao no sistema
	WSDATA ScaleCod				As String 			//Codigo da escala - RBK_ESCALA
	WSDATA ScaleItem				As String OPTIONAL	//Codigo sequencial dos itens - RBL_ITEM
	WSDATA ScaleDescription		As String OPTIONAL	//Descricao da escala - RBL_DESCRI
ENDWSSTRUCT

WSSTRUCT CourseTypesList //Lista de niveis de graduacao para selecao no sistema
	WSDATA ScaleCod				As String 			//Codigo da escala - RBK_ESCALA
	WSDATA ScaleItem				As String OPTIONAL	//Codigo sequencial dos itens - RBL_ITEM
	WSDATA ScaleDescription		As String OPTIONAL	//Descricao da escala - RBL_DESCRI
ENDWSSTRUCT

WSSTRUCT GroupCombos //Agrupa as arrays de cursos cadastrados, cursos disponiveis e niveis de escala
	WSDATA UserName				As String
	WSDATA UserID					As String
	WSDATA LastUpdate				As Date		OPTIONAL 		//data da ultima alteracao
	WSDATA aCourseList			As Array of CourseList	OPTIONAL	//Array com a lista de cursos cadastrados
	WSDATA aCourseNames			As Array of CourseNames OPTIONAL	//Array de cursos disponiveis no sistema
	WSDATA aScaleList				As Array of CourseScaleList	OPTIONAL	//Array com a lista de escalas
	WSDATA aTypesList				As Array of CourseTypesList	OPTIONAL	//Array com as listas de escalas
	WSDATA aLearn					As Array of CourseNames	OPTIONAL	//Array com as listas instituicao de ensino
ENDWSSTRUCT

WSSTRUCT HistoryList
	WSDATA Registration			As String				//Codigo da matricula
	WSDATA AdmissionDate			As Date					//Data de Admissao
	WSDATA DemissionDate			As Date		OPTIONAL 	//Data de Demissao
	WSDATA CompanyName			As String				//Nome da Empresa
	WSDATA InitialPosition 		As String				//Cargo inicial ocupado na empresa
	WSDATA Position				As String				//Cargo ocupado na empresa
	WSDATA HistoryId				As Integer 	OPTIONAL 	//Recno usado como identificador
	WSDATA Description			As String	OPTIONAL	//Descricao das atividades executadas na empresa
	WSDATA LastUpdate				As Date 	OPTIONAL	//Data da ultima alteracao
ENDWSSTRUCT

WSSTRUCT Experiences //Lista de experiencias Microsiga
	WSDATA ExpCod					As Integer 	OPTIONAL	//Codigo do item (RECNO)
	WSDATA ExpMat					As String 				//Matricula do Participante
	WSDATA ExpDpt					As String 	OPTIONAL	//Departamento no periodo
	WSDATA ExpFunction			As String	OPTIONAL	//Funcao no periodo
	WSDATA ExpIDate				As Date	 	OPTIONAL	//Data de inicio
	WSDATA ExpFDate				As Date	 	OPTIONAL	//Data de conclusao
	WSDATA ExpDetails				As String	OPTIONAL	//Descricao das atividades exercidas
	WSDATA LastUpdate				As Date 	OPTIONAL	//Data da ultima alteracao
ENDWSSTRUCT

WSSTRUCT Participant
	WSDATA Registration			As String 				//Matricula do participante
	WSDATA Name					As String				//Nome do participante
	WSDATA EvaluatorName	   		As String	OPTIONAL	//Nome do avaliador
	WSDATA Filial					As String				//Filial do participante
	WSDATA LastUpdate				As Date		OPTIONAL	//Data da ultima alteracao
	WSDATA CodMentor				As String	OPTIONAL	//Codigo do mentor
	WSDATA MentorName				As String	OPTIONAL	//Nome do mentor
	WSDATA HierarqLevel			As String	OPTIONAL	//Nivel de Carreira
	WSDATA Area					As String	OPTIONAL	//Area-Centro de Custo
	WSDATA Empresa					As String	OPTIONAL	//Area-Centro de Custo
ENDWSSTRUCT

WSSTRUCT ComboClassList //Lista de classes de entidade, sera usada no combo para selecao
	WSDATA LabelID				As String 				//Identificador da sigla
	WSDATA LabelDescription		As String 	OPTIONAL	//Descricao do identificador
	WSDATA RegLabel				As String 	OPTIONAL	//Sigla do registro de classe
	WSDATA RegDescription		As String 	OPTIONAL	//Descricao do registro de classe
ENDWSSTRUCT

WSSTRUCT UserClassList //Lista de classes registradas pelo usuario na REU
	WSDATA RegLabel				As String 	OPTIONAL	//Sigla do registro de classe
	WSDATA RegDescription		As String 	OPTIONAL	//Descricao do registro de classe
	WSDATA OtherDescription		As String 	OPTIONAL	//Descricao do registro de classe quando for outros
	WSDATA RegNumber				As String 	OPTIONAL 	//Numero do registro de classe
	WSDATA EspecCode				As String 	OPTIONAL	//Codigo da especializacao
	WSDATA EspecDescr				As String 	OPTIONAL 	//Descricao da especializacao
	WSDATA RegRecno				As Integer 	OPTIONAL 	//Recno
ENDWSSTRUCT

WSSTRUCT ClassData //Agrupa as classes para selecao e classes cadastradas pelo usuario
	WSDATA UserID					As String 							//Codigo do Usuario
	WSDATA LastUpdate				As Date		OPTIONAL 				//Data da ultima alteracao
	WSDATA aUserClassList		As Array of UserClassList  OPTIONAL	//Array com a lista de classes do usuario
	WSDATA aComboClassList		As Array of ComboClassList OPTIONAL	//Array de classes disponiveis no sistema
ENDWSSTRUCT

WSSTRUCT Desc
	WSDATA Description			As String	OPTIONAL //Descricoes
	WSDATA LastUpdate				As Date		OPTIONAL //Data da ultima alteracao
ENDWSSTRUCT

WSSTRUCT Mentors
	WSDATA MentorID	 			As String OPTIONAL	//Codigo do mentor
	WSDATA MentorName				As String OPTIONAL	//Descricao do mentor
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Curriculo de Funcionarios                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHEmployedCurriculum DESCRIPTION STR0001 				//"Curriculum dos Funcionarios ( <b>Restrição de participante</b> )"
	WSDATA UserCode				As String
	WSDATA ParticipantId   	   	As String OPTIONAL				//Codigo do Participante
	WSDATA EnrolmentId     		As String OPTIONAL				//Matricula do Participante
	WSDATA WsNull         	   	AS String
	WSDATA ItemCod        	   	AS String
	WSDATA RegLabel				AS String
	WSDATA RegNumber				AS String
	WSDATA CodMentor				As String						//Codigo do mentor
	WSDATA CourseData      		AS CourseList OPTIONAL
	WSDATA ListOfItens			AS Array of ItensMenu
	WSDATA ListOfCourses			AS GroupCombos OPTIONAL
	WSDATA ListOfExperiences		AS Array of Experiences OPTIONAL
	WSDATA ExperienceItem		AS Experiences
	WSDATA UserClassItem			AS UserClassList
	WSDATA ListOfHistory			As Array of HistoryList OPTIONAL
	WSDATA ExternalHistory	   	As HistoryList OPTIONAL
	WSDATA HistoryId				As Integer						//Recno usado como identificador
	WSDATA Include				As Boolean						//Identifica se sera inclusao ou alteracao de dados
	WSDATA SkinParticipant	    As Participant
	WSDATA aClassData				As ClassData
	WSDATA ScaleCod				As String 						//Codigo da escala
	WSDATA ScaleItem				As String OPTIONAL				//Codigo do item da escala
	WSDATA RegRecno				As Integer						//Recno
	WSDATA Descriptions			As Desc							//Descricoes
	WSDATA QualifyDescription	As String 						//Qualificacoes
	WSDATA Comentaries			As String						//Comentarios adicionais
	WSDATA MenuTitle				As String						//Titulo do menu
	WSDATA FunctionName			As String						//Nome da funcao
	WSDATA Vision					As String OPTIONAL				//Codigo da visao(utilizada no momento) vinda de parametro
	WSDATA ListOfMentor	        AS Array OF Mentors 			//Lista de avaliadores que a consulta retorna no pop-up de mentores
	WSDATA MentorName				As String						//Nome do Mentor

	WSMETHOD BrwLearning   		DESCRIPTION STR0002	//"Retorna a de dados cadastrados da capacitacao interna"
	WSMETHOD BrwCertification	DESCRIPTION STR0003	//"Retorna a de dados cadastrados da certificacao de mercado"
	WSMETHOD BrwItemTypes  		DESCRIPTION STR0004 //"Retorna os tipos de cursos disponiveis para cadastro"
	WSMETHOD BrwItemData   		DESCRIPTION STR0005 //"Retorna a lista de cursos cadastrados pelo usuario"
	WSMETHOD DelItemData   		DESCRIPTION STR0006 //"Deleta o curso selecionado"
	WSMETHOD DelLearning   		DESCRIPTION STR0007	//"Deleta o curso interno selecionado"
	WSMETHOD PutCourse	   		DESCRIPTION STR0008 //"Acrescenta um curso na tabela de cursos do usuario"
	WSMETHOD PutLearning   		DESCRIPTION STR0009 //"Acrescenta um curso na tabela de cursos internos"
	WSMETHOD PutCertification	DESCRIPTION STR0010	//"Acrescenta um curso na tabela de certificacoes externas"
	WSMETHOD PutMentor			DESCRIPTION STR0029	//"Inclusao de mentor no cadastro de participantes"
	WSMETHOD SetItemData			DESCRIPTION STR0011 //"Altera um curso na tabela de cursos do usuario"
	WSMETHOD BrwExternalHistory	DESCRIPTION STR0012 //"Retorna Histórico de carreira do profissional"
	WSMETHOD PutExternalHistory	DESCRIPTION STR0013 //"Incluir / Alterar Histórico de carreira do profissional"
	WSMETHOD DelExternalHistory	DESCRIPTION STR0014	//"Excluir Histórico de carreira do profissional"
	WSMETHOD BrwInternalExp		DESCRIPTION STR0015 //"Retorna a lista de atividades exercidas na Microsiga"
	WSMETHOD PutInternalExp		DESCRIPTION STR0016 //"Inclui / Altear item de atividades exercidas na Microsiga"
	WSMETHOD GetParticipant		DESCRIPTION STR0017 //"Consulta dados de participante logado"
	WSMETHOD DelExpItem   		DESCRIPTION STR0018 //"Deleta o item de experiencia externa selecionado"
	WSMETHOD BrwEntData			DESCRIPTION STR0019 //"Retorna a lista de entidades de classe disponiveis"
	WSMETHOD DelEntItem			DESCRIPTION STR0020 //"Excui item de entidade filiada"
	WSMETHOD PutEntData			DESCRIPTION STR0021 //"Incluir / Alterar item de entidade filiada"
	WSMETHOD GetQualify			DESCRIPTION STR0022	//"Consultar qualificacoes"
	WSMETHOD PutQualify			DESCRIPTION STR0023	//"Incluir / Alterar qualificacoes"
	WSMETHOD GetComent			DESCRIPTION STR0024	//"Consultar comentarios adicionais"
	WSMETHOD PutComent			DESCRIPTION STR0025	//"Incluir / Alterar comentarios adicionais"
	WSMETHOD UserMenu	   			DESCRIPTION STR0032 //"Retorna nome da funcao para executar pagina de usuario"
	WSMETHOD BrwMentors		  	DESCRIPTION STR0037 //"Retorna a lista completa de participantes, para selecionar o Mentor"
ENDWSSERVICE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwItemTypes	 ³ Autor ³Rogerio Augusto     ³Data ³09.11.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna os tipos de itens referentes a cursos, disponiveis    ³±±
±±³          ³para cadastro no curriculo. Utilizado para montar o menu.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwItemTypes WSRECEIVE UserCode, ParticipantID WSSEND ListOfItens WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local aRet		:= {}
Local lRetorno  := .T.
Local nI 		:= 0
Local cAlias	:= ""
Local cFilSRA	:= ""
Local cMat		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Participant( ::ParticipantID, aRet )
	cMat	:= aRet[1] //SRA->RA_MAT
	cFilSRA := aRet[3] //SRA->RA_FILIAL	
Else	
	lRetorno := .F.
	SetSoapFault("BrwItemTypes",STR0026)	 //"Participante nao encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui os itens fixos do menu                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aMenu := {}
Aadd(aMenu,{"#AAA", "Dados Pessoais"						, "", "", "#A"})
Aadd(aMenu,{"#BBB", "Sumario Qualificacoes"					, "", "", "#B"})
Aadd(aMenu,{"#CCC", "Experiencias profissionais do Mercado"	, "", "", "#C"})
Aadd(aMenu,{"#DDD", "Experiencias profissionais Interna"	, "", "", "#D"})

For nI := 1 To 4
	aAdd( ::ListOfItens, WSClassNew('ItensMenu') )
	::ListOfItens[nI]:ItemCod 		:= aMenu[nI,1]
	::ListOfItens[nI]:ItemDesc 		:= aMenu[nI,2]
	::ListOfItens[nI]:ItemLevel 	:= aMenu[nI,3]
	::ListOfItens[nI]:ItemStatus 	:= aMenu[nI,4]
	::ListOfItens[nI]:ItemType 		:= aMenu[nI,5]
	::ListOfItens[nI]:Data 			:= .F.

	Do Case
		Case ::ListOfItens[nI]:ItemType == "#A"	//"Dados Pessoais"
			::ListOfItens[nI]:Data 	:= .T. //Existe Dados

		Case ::ListOfItens[nI]:ItemType == "#B"	//"Sumario Qualificacoes"

		dbSelectArea("RD0")
		dbSetOrder(1)	
		
		If dbseek(xFilial("RD0")+::ParticipantID)
			If !Empty(RD0->RD0_ALTQUA)
				::ListOfItens[nI]:Data 	:= .T. //Existe Dados
			EndIf
		EndIf

		Case ::ListOfItens[nI]:ItemType == "#C"	//"Experiencias profissionais do Mercado"

			dbSelectArea("SQC")
			dbSetOrder(1)		
			
			fVerFil(@cFilSRA , "SQC" , aRet)
			
			If dbSeek(cFilSRA+cMat)
				::ListOfItens[nI]:Data 	:= .T. //Existe Dados
			EndIf

		Case ::ListOfItens[nI]:ItemType == "#D"	//"Experiencias profissionais Interna"

			dbSelectArea("RBN")
			dbSetOrder(1)
			
			fVerFil(@cFilSRA , "RBN" , aRet)
			
			If dbSeek(cFilSRA+cMat)
				::ListOfItens[nI]:Data 	:= .T. //Existe Dados
			EndIf

    EndCase

Next nI

dbSelectArea("SQX")
dbSetOrder(1)
dbSeek(xFilial("SQX"))
while !SQX->(Eof())
	If !Empty(SQX->QX_TIPO)
	   	If SQX->QX_TIPO=="0".AND.!ExistBlock("WSAPUSR014")
	   		SQX->(dbSkip())
            Loop
        EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³monta a lista de itens para o menu                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( ::ListOfItens, WSClassNew('ItensMenu') )
		::ListOfItens[nI]:ItemCod 		:= SQX->QX_CODIGO
		::ListOfItens[nI]:ItemDesc 		:= SQX->QX_DESC
		::ListOfItens[nI]:ItemLevel 	:= SQX->QX_NIVEL
		::ListOfItens[nI]:ItemStatus 	:= SQX->QX_STATUS
		::ListOfItens[nI]:ItemType 		:= SQX->QX_TIPO

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se tem itens preenchidos                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case

			Case ::ListOfItens[nI]:ItemType == "1"	//Historico
				cAlias := "SQ9"

			Case ::ListOfItens[nI]:ItemType == "2"	//Capacitacao mercado
				cAlias := "SQ9"

			Case ::ListOfItens[nI]:ItemType == "3"	//Capacitacao interna
				cAlias := "RA4"

			Case ::ListOfItens[nI]:ItemType == "4"	//Certificacao mercado
				cAlias := "SQ9"

			Case ::ListOfItens[nI]:ItemType == "5"	//Filiacao
				cAlias := "REU"

			Case ::ListOfItens[nI]:ItemType == "6"	//Idiomas
				cAlias := "SQ9"

			Case ::ListOfItens[nI]:ItemType == "7"	//Comentarios
				cAlias := "SQ9"

		EndCase

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa como False                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		::ListOfItens[nI]:Data 	:= .F.

		If cAlias == "SQ9" .And. ::ListOfItens[nI]:ItemType != "7"
			dbSelectArea(cAlias)
			dbSetOrder(1)
			dbSeek(cFilSRA+cMat)
			While !Eof() .And. SQ9->Q9_MAT == cMat .And. !(::ListOfItens[nI]:Data) .And. ;
				SQ9->Q9_FILIAL == cFilSRA

				dbSelectArea("SQT")
				dbSetOrder(1)
				If dbSeek(xFilial("SQT") + SQ9->Q9_CURSO)

					If SQT->QT_TIPO == SQX->QX_CODIGO
						::ListOfItens[nI]:Data 	:= .T. //Existe Dados
					EndIf
				EndIf

				dbSelectArea("SQ9")
			 	dbSkip()
			EndDo

		ElseIf cAlias == "SQ9" .And. ::ListOfItens[nI]:ItemType == "7"

			dbSelectArea("RD0")
			dbSetOrder(1)
			dbSeek(xFilial("RD0")+::ParticipantID)
			If !Empty(RD0->RD0_ALTCOM)	
				::ListOfItens[nI]:Data 	:= .T. //Existe Dados
			EndIf


		ElseIf cAlias == "REU"

			dbSelectArea(cAlias)
			dbSetOrder(1)
			If dbSeek(xFilial(cAlias)+::ParticipantID)
				::ListOfItens[nI]:Data 	:= .T. //Existe Dados
			EndIf

		ElseIf cAlias == "RA4"

			dbSelectArea("RA4")
			dbSetOrder(1)
			If dbSeek(xFilial("RA4")+cMat)

				while !RA4->(Eof()) .And. RA4->(RA4_FILIAL+RA4_MAT) == (xFilial("RA4")+cMat)

					nOrdem := RetOrdem( "RA1" , "RA1_FILIAL+RA1_TIPOPP+RA1_CURSO" )
					RA1->( dbSetOrder(nOrdem) )
					If RA1->( dbSeek(xFilial("RA1")+SQX->QX_CODIGO+RA4->RA4_CURSO ) )
						::ListOfItens[nI]:Data 	:= .T. //Existe Dados
					EndIf

					RA4->( dbSkip() )
					dbSkip()
				EndDo
			EndIf

		Else
			If !Empty(cAlias)
				If ( cAlias $ "RBN|SQC" )
				
					fVerFil(@cFilSRA , cAlias , aRet)
					
				Else
				
					cFilSRA	:=	xFilial(cAlias)
				
				EndIf
				
				dbSelectArea(cAlias)
				dbSetOrder(1)
				If dbSeek(cFilSRA+cMat)
					::ListOfItens[nI]:Data 	:= .T. //Existe Dados
				EndIf
			EndIf
		EndIf
		nI++
	EndIf

	SQX->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³armazena o nome do usuario apenas uma vez                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("RD0")
dbSetOrder(1)
RD0->(dbSeek(xFilial("RD0")+::ParticipantID))
If len(::ListOfItens) == 0
	aAdd( ::ListOfItens, WSClassNew('ItensMenu') )
EndIf
::ListOfItens[1]:UserName := RD0->RD0_NOME

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwItemData	 ³ Autor ³Rogerio Augusto     ³Data ³05.01.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta a tela com o formulario para cadastro de cursos.  		³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwItemData WSRECEIVE UserCode, ItemCod, ParticipantID WSSEND ListOfCourses WSSERVICE RHEmployedCurriculum
Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local nI 			:= 0
Local escalaNivel 	:= ""
Local escalaStatus 	:= ""
Local aRet			:= {}
Local cFilSRA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Participant( ::ParticipantID, aRet )
	::ListOfCourses:UserID := aRet[1] //SRA->RA_MAT
	::ListOfCourses:UserName := aRet[2] //SRA->RA_NOME
	cFilSRA	:= aRet[3] //SRA->RA_FILIAL
Else
	lRetorno := .F.
	SetSoapFault("BrwItemData",STR0026)			 //"Participante nao encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE EXISTE O CURSO OUTROS CADASTRADA NO CADASTRO DE CURSOS, FUNCAO  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutOthers( ::ItemCod )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo as escalas na SQX a partir do codigo do item                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SQX->( dbSetOrder(1) )
If SQX->( dbSeek(xFilial("SQX")+::ItemCod ) )
	While !SQX->(EOF()) .And. SQX->QX_FILIAL == xFilial("SQX") .And. SQX->QX_CODIGO == ::ItemCod
		escalaNivel := SQX->QX_NIVEL
		escalaStatus := SQX->QX_STATUS
		SQX->( dbSkip() )
	EndDo
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de cursos cadastrados pelo usuario                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SQ9")
dbSetOrder(1)
SQT->(dbSetOrder(1)) //ANTIGO 3
RBL->(dbSetOrder(1))

If SQ9->(dbSeek(cFilSRA+::ListOfCourses:UserID))
	while !SQ9->(Eof()) .And. ( SQ9->Q9_MAT == ::ListOfCourses:UserID ) .And. ;
		SQ9->Q9_FILIAL == cFilSRA

		If SQT->(dbSeek(xFilial("SQT")+SQ9->Q9_CURSO+::ItemCod,.T.)) .and. SQT->QT_TIPO == ::ItemCod //
			nI++
			aAdd( ::ListOfCourses:aCourseList, WSClassNew('CourseList') )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³GRAVA DATA DA ULTIMA ALTERACAO                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(::ListOfCourses:LastUpdate) .Or. ::ListOfCourses:LastUpdate < SQ9->Q9_DTALTER
				::ListOfCourses:LastUpdate := SQ9->Q9_DTALTER
			EndIf
			::ListOfCourses:aCourseList[nI]:CourseCod	:= SQ9->Q9_CURSO
			::ListOfCourses:aCourseList[nI]:CourseMat	:= SQ9->Q9_MAT
			::ListOfCourses:aCourseList[nI]:CourseName	:= SQ9->Q9_DESCRIC
			::ListOfCourses:aCourseList[nI]:CourseEnt	:= SQ9->Q9_ENTIDAD
			::ListOfCourses:aCourseList[nI]:CourseCDate	:= SQ9->Q9_DATA
			::ListOfCourses:aCourseList[nI]:CourseIDate	:= SQ9->Q9_DTINI
			::ListOfCourses:aCourseList[nI]:CourseTime	:= SQ9->Q9_DURACAO
			::ListOfCourses:aCourseList[nI]:CourseDesc	:= AllTrim(ApdMsMm(SQ9->Q9_CODCONT))
			::ListOfCourses:aCourseList[nI]:RegRecno	:= SQ9->( Recno() )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Localiza a escala na RBL                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RBL->(dbSeek(xFilial("RBL")+escalaNivel+SQ9->Q9_NIVEL))
			::ListOfCourses:aCourseList[nI]:CourseTypeLv := SQ9->Q9_NIVEL
			::ListOfCourses:aCourseList[nI]:CourseType := RBL->RBL_DESCRI
			RBL->(dbSeek(xFilial("RBL")+escalaStatus+SQ9->Q9_STATUS))
			::ListOfCourses:aCourseList[nI]:CourseStatusLv := SQ9->Q9_STATUS
			::ListOfCourses:aCourseList[nI]:CourseStatus := RBL->RBL_DESCRI
		EndIf
		SQ9->(dbSkip())
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de cursos disponiveis no sistema                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SQT")
dbSetOrder(3) //ANTIGO 4
nI := 0
SQT->(dbSeek(xFilial("SQT")+::ItemCod))
while !SQT->(Eof()) .And. SQT->QT_TIPO == ::ItemCod
	If AllTrim(Upper(SQT->QT_DESCRIC)) != AllTrim(Upper(STR0028)) //"Outros"
		nI++
		aAdd( ::ListOfCourses:aCourseNames, WSClassNew('CourseNames') )
		::ListOfCourses:aCourseNames[nI]:CourseCod 	:= SQT->QT_CURSO
	   	::ListOfCourses:aCourseNames[nI]:CourseName	:= SQT->QT_DESCRIC
	EndIf
	SQT->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordenar por Descricao                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Asort( ::ListOfCourses:aCourseNames,,, {|x,y| x:CourseName < y:CourseName } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclusao do Curso "OUTROS" se houver na base                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SQT->(dbSetOrder(2))
If SQT->(dbSeek(xFilial("SQT")+AllTrim(Upper(STR0028))))
	While(!SQT->(Eof()) .And. AllTrim(Upper(STR0028)) == alltrim(Upper(SQT->QT_DESCRIC)) .And. SQT->QT_FILIAL == xFilial("SQT"))
                if(SQT->QT_TIPO == ::ItemCod)
			nI++
			aadd(::ListOfCourses:aCourseNames,WSCLASSNEW('CourseNames'))

		    ::ListOfCourses:aCourseNames[nI]:CourseCod	:= SQT->QT_CURSO
		    ::ListOfCourses:aCourseNames[nI]:CourseName	:= SQT->QT_DESCRIC

		    exit
                endif
		SQT->(dbSkip())
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de tipos de curso e status disponiveis no sistema         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("RBL")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tipos de curso                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nI := 0
RBL->(dbSeek(xFilial("RBL")+escalaNivel))
while !RBL->(Eof()) .And. RBL->RBL_ESCALA == escalaNivel
	nI++
	aAdd( ::ListOfCourses:aTypesList, WSClassNew('CourseTypesList') )
	::ListOfCourses:aTypesList[nI]:ScaleCod := RBL->RBL_ESCALA
   	::ListOfCourses:aTypesList[nI]:ScaleItem := RBL->RBL_ITEM
   	::ListOfCourses:aTypesList[nI]:ScaleDescription := RBL->RBL_DESCRI
	RBL->(dbSkip())
EndDo

RBL->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Status dos cursos                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nI := 0
RBL->(dbSeek(xFilial("RBL")+escalaStatus))
while !RBL->(Eof()) .And. RBL->RBL_ESCALA == escalaStatus
	nI++
	aAdd( ::ListOfCourses:aScaleList, WSClassNew('CourseScaleList') )
	::ListOfCourses:aScaleList[nI]:ScaleCod := RBL->RBL_ESCALA
   	::ListOfCourses:aScaleList[nI]:ScaleItem := RBL->RBL_ITEM
	::ListOfCourses:aScaleList[nI]:ScaleDescription := RBL->RBL_DESCRI
	RBL->(dbSkip())
EndDo

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutItem		 ³ Autor ³Rogerio Augusto     ³Data ³11.01.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cadastra um novo curso na tabela de cursos do usuario (SQ9).	³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutCourse WSRECEIVE UserCode, ParticipantID, CourseData WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
Local aRet		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Participant( ::ParticipantID, aRet )
	::CourseData:CourseMat := aRet[1] //SRA->RA_MAT
Else
	lRetorno := .F.
	SetSoapFault("PutCourse",STR0027) //"Participante não encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do cadastro do novo curso na SQ9                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SQ9")
dbSetOrder(1)

Reclock("SQ9",.T.)
	SQ9->Q9_FILIAL	:= aRet[3]
	SQ9->Q9_CURSO	:= ::CourseData:CourseCod
	SQ9->Q9_MAT		:= ::CourseData:CourseMat
	SQ9->Q9_DESCRIC	:= ::CourseData:CourseName
	SQ9->Q9_ENTIDAD	:= ::CourseData:CourseEnt
	SQ9->Q9_DATA	:= ::CourseData:CourseCDate
	SQ9->Q9_DTINI	:= ::CourseData:CourseIDate
	SQ9->Q9_NIVEL	:= ::CourseData:CourseType
	SQ9->Q9_STATUS	:= ::CourseData:CourseStatus
	SQ9->Q9_DURACAO	:= ::CourseData:CourseTime
	SQ9->Q9_DTALTER	:= date()
	If existBlock("DADOSFUNC")
		SQ9->Q9_MATRM	:= aRet[8]
	EndIf
	If !Empty(::CourseData:CourseDesc)
   		ApdMsMm(SQ9->Q9_CODCONT,,,::CourseData:CourseDesc,1,,,"SQ9","Q9_CODCONT")
   	EndIf
SQ9->(MsUnlock())

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DelItemData	 ³ Autor ³Rogerio Augusto     ³Data ³05.01.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Exclui um item da tabela de cursos cadastrados (SQ9).			³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD DelItemData WSRECEIVE UserCode, RegRecno WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

dbSelectArea("SQ9")
dbGoTo(::RegRecno)
RecLock("SQ9",.F.)
dbDelete()
msUnlock()

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetItemData	 ³ Autor ³Rogerio Augusto     ³Data ³13.01.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Altera um item da tabela de cursos cadastrados (SQ9).			³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD SetItemData WSRECEIVE UserCode, ParticipantID, CourseData WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
Local Matricula := ""
Local aRet		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Participant( ::ParticipantID, aRet )
	Matricula := aRet[1] 
Else
	lRetorno := .F.
	SetSoapFault("SetItemData",STR0027) //"Participante não encontrado no cadastro de funcionários."
EndIf

dbSelectArea("SQ9")
dbGoTo(::CourseData:RegRecno)
Reclock("SQ9",.F.)
SQ9->Q9_FILIAL 	:= aRet[3]
SQ9->Q9_CURSO 	:= ::CourseData:CourseCod
SQ9->Q9_MAT 	:= Matricula
SQ9->Q9_DESCRIC := ::CourseData:CourseName
SQ9->Q9_ENTIDAD := ::CourseData:CourseEnt
SQ9->Q9_DATA 	:= ::CourseData:CourseCDate
SQ9->Q9_DTINI	:= ::CourseData:CourseIDate
SQ9->Q9_NIVEL	:= ::CourseData:CourseType
SQ9->Q9_STATUS	:= ::CourseData:CourseStatus
SQ9->Q9_DTALTER	:= date()
SQ9->Q9_DURACAO	:= ::CourseData:CourseTime

If existblock("DADOSFUNC")
	SQ9->Q9_MATRM	:= aRet[8]
EndIf

If !Empty(::CourseData:CourseDesc)
	ApdMsMm(SQ9->Q9_CODCONT,,,::CourseData:CourseDesc,1,,,"SQ9","Q9_CODCONT")
EndIf
SQ9->(MsUnlock())

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwExternalHistory ³ Autor ³Juliana B.      ³Data ³12.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna os dados do historico externo do profissional		    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwExternalHistory WSRECEIVE UserCode, ParticipantID WSSEND ListOfHistory WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
Local nI 		:= 0
Local Matricula := ""
Local aRet		:= {}
Local cFilSRA	:=	""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Participant( ::ParticipantID, aRet )
	Matricula := aRet[1] //SRA->RA_MAT
Else
	lRetorno := .F.
	SetSoapFault("BrwExternalHistory",STR0027) //"Participante não encontrado no cadastro de funcionários."
EndIf

dbSelectArea("SQC")
dbSetOrder(1)

fVerFil(@cFilSRA , "SQC" , aRet)
If dbSeek(cFilSRA+Matricula)
	While !SQC->(Eof()) .And. SQC->QC_FILIAL == cFilSRA .And. SQC->QC_MAT == Matricula
   		nI++
   		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³monta a lista de dados das ultimas empresas trabalhadas                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( ::ListOfHistory, WSClassNew('HistoryList') )

		::ListOfHistory[nI]:Registration	:= SQC->QC_MAT
		::ListOfHistory[nI]:AdmissionDate	:= SQC->QC_ADMISSA
		::ListOfHistory[nI]:DemissionDate	:= SQC->QC_DEMISSA
		::ListOfHistory[nI]:CompanyName	:= SQC->QC_EMPRESA
		::ListOfHistory[nI]:Position		:= SQC->QC_CARGO
		::ListOfHistory[nI]:InitialPosition	:= SQC->QC_CARGOIN
		::ListOfHistory[nI]:HistoryId		:= SQC->( Recno() )
		::ListOfHistory[nI]:Description	:= Alltrim(APDMSMM(SQC->QC_ATIVIDA))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³DATA DA ULTIMA ALTERACAO, GRAVA APENAS NO PRIMEIRO REGISTRO             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(::ListOfHistory[1]:LastUpdate)
			::ListOfHistory[1]:LastUpdate	:= SQC->QC_DTALTER
		ElseIf ::ListOfHistory[1]:LastUpdate < SQC->QC_DTALTER
			::ListOfHistory[1]:LastUpdate	:= SQC->QC_DTALTER
		EndIf
		SQC->(dbSkip())
   	EndDo
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutExternalHistory	 ³ Autor ³Juliana B.  ³Data ³17.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Incluir / Alterar Historico de carreira						³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutExternalHistory WSRECEIVE UserCode, ParticipantID, Include, ExternalHistory WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local lRetorno  := .T.
Local cMatr		:= ""
Local aRet		:= {}
Local cFilSRA	:=	"" // Armazena a filial do funcionario

dbSelectArea("SQC")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Participant( ::ParticipantID, aRet )
	cMatr := aRet[1]  //SRA->RA_MAT		
Else		
	lRetorno := .F.
	SetSoapFault("PutExternalHistory",STR0027)	 //"Participante não encontrado no cadastro de funcionários."
EndIf

fVerFil(@cFilSRA , "SQC" , aRet)
If ::Include == .T. //SE FOR INCLUSAO
	Reclock("SQC",.T.)
	SQC->QC_MAT := cMatr
	SQC->QC_ADMISSA	:= ::ExternalHistory:AdmissionDate
Else		
	dbGoTo(::ExternalHistory:HistoryId)
	Reclock("SQC",.F.)
EndIf
SQC->QC_FILIAL 	:= cFilSRA
SQC->QC_DEMISSA	:= ::ExternalHistory:DemissionDate
SQC->QC_EMPRESA	:= ::ExternalHistory:CompanyName
SQC->QC_CARGOIN	:= ::ExternalHistory:InitialPosition
SQC->QC_CARGO	:= ::ExternalHistory:Position
SQC->QC_DTALTER	:= date()
If existblock("DADOSFUNC")
	SQC->QC_MATRM	:= aRet[8]
EndIf

If !Empty(::ExternalHistory:Description)
	APDMSMM(QC_ATIVIDA,,,::ExternalHistory:Description,1,,,"SQC","QC_ATIVIDA")
EndIf

MsUnlock()

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DelExternalHistory	 ³ Autor ³Juliana B.  ³Data ³18.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Excluir Historico de carreira									³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD DelExternalHistory WSRECEIVE UserCode, HistoryId WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

dbSelectArea("SQC")
dbGoTo(::HistoryId) //POSICIONA NO REGISTRO CORRETO

Reclock("SQC",.F.)
dbDelete()     //APAGA REGISTRO
MsUnlock()

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwInternalExp ³ Autor ³Rogerio Augusto     ³Data ³18.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta a tela com o formulario para cadastro de cursos.  		³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwInternalExp WSRECEIVE UserCode, ParticipantID WSSEND ListOfExperiences WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
Local nI 		:= 0
Local aRet 		:= {}
Local cFilSRA	:=	""

If	!Participant( ::ParticipantID, aRet )
	lRetorno := .F.
	SetSoapFault("BrwInternalExp",STR0027)	 //"Participante não encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de experiencias do usuario                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("RBN")
dbSetOrder(1)

fVerFil(@cFilSRA , "RBN" , aRet)

If dbSeek(cFilSRA+aRet[1])
	While !Eof() .And. (RBN->RBN_FILIAL+RBN->RBN_MAT == cFilSRA+aRet[1])
		nI++
		aAdd( ::ListOfExperiences, WSClassNew('Experiences') )
		::ListOfExperiences[nI]:ExpCod 		:= RBN->( RECNO() )
		::ListOfExperiences[nI]:ExpMat 		:= RBN->RBN_MAT
		::ListOfExperiences[nI]:ExpDpt 		:= RBN->RBN_DEPTO
		::ListOfExperiences[nI]:ExpFunction := RBN->RBN_FUNCAO
		::ListOfExperiences[nI]:ExpIDate 	:= RBN->RBN_DTINI
		::ListOfExperiences[nI]:ExpFDate 	:= RBN->RBN_DTFIM
		::ListOfExperiences[nI]:ExpDetails 	:= Alltrim(ApdMsMm(RBN->RBN_ATIVID))
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³DATA DA ULTIMA ALTERACAO, GRAVA APENAS NO PRIMEIRO REGISTRO             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(ListOfExperiences[1]:LastUpdate)
			ListOfExperiences[1]:LastUpdate	:= RBN->RBN_DTALT
		ElseIf ListOfExperiences[1]:LastUpdate < RBN->RBN_DTALT
			ListOfExperiences[1]:LastUpdate	:= RBN->RBN_DTALT
		EndIf
	
		RBN->(dbSkip())
	EndDo
Else
	nI++
	aAdd( ::ListOfExperiences, WSClassNew('Experiences') )
	::ListOfExperiences[1]:ExpMat := aRet[1]
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutInternalExp ³ Autor ³Rogerio Augusto     ³Data ³20.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Incluir / Alterar Historico de carreira						³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutInternalExp WSRECEIVE UserCode, Include, ExperienceItem, ParticipantID WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local lRetorno  := .T.
Local aRet      := {}
Local cFilSRA	:=	"" // Armazena a filial do funcionario

dbSelectArea("RBN")
dbSetOrder(1)

If ::Include == .T. //SE FOR INCLUSAO
	Reclock("RBN",.T.)
Else
	dbGoTo(::ExperienceItem:ExpCod)
	Reclock("RBN",.F.)
EndIf

If ( Participant( ::ParticipantID, aRet ) )	
	If existblock("DADOSFUNC")
		RBN->RBN_MATRM	:= aRet[8]		   
	EndIf
EndIf

fVerFil(@cFilSRA , "RBN" , aRet)

RBN->RBN_FILIAL := cFilSRA
RBN->RBN_MAT 	:= ::ExperienceItem:ExpMat
RBN->RBN_DEPTO 	:= ::ExperienceItem:ExpDpt
RBN->RBN_FUNCAO := ::ExperienceItem:ExpFunction
RBN->RBN_DTINI 	:= ::ExperienceItem:ExpIDate
RBN->RBN_DTFIM 	:= ::ExperienceItem:ExpFDate
RBN->RBN_DTALT 	:= date()

If !Empty(::ExperienceItem:ExpDetails)
	ApdMsMm(RBN_ATIVID,,,::ExperienceItem:ExpDetails,1,,,"RBN","RBN_ATIVID")
EndIf

MsUnlock()

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetParticipant ³ Autor ³Juliana Barros      ³Data ³20.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta dados do participante logado.				        ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetParticipant WSRECEIVE UserCode, ParticipantID, Vision, EnrolmentID WSSEND SkinParticipant WSSERVICE RHEmployedCurriculum
Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local aUser			:= {}
Local aSup			:= {}
Local cMsgErro		:= ""

If RD0->(FieldPos("RD0_DTALT")) == 0
	cMsgErro += STR0033 + ": RD0 - " + STR0034 + ": RD0_DTALT; "
EndIf

If Empty(cMsgErro)
	If Participant(::ParticipantID, aUser,,::EnrolmentID)
		RDE->( dbSetOrder(1) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A VISAO VEM DE PARAMETRO.                                                 ³
		//³SE EXISTE VISAO, VERIFICAR O AVALIADOR APENAS DAQUELA VISAO SELECIONADA   ³
		//³CASO CONTRARIO, NAO UTILIZAR NENHUMA VISAO                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(::Vision)
			If RDE->(dbSeek(xFilial("RDE")+::ParticipantID+::Vision ,.T.))
				While !RDE->(Eof()) .And. RDE->RDE_CODPAR == ::ParticipantID
		   			If RDE->RDE_STATUS == "1" //SE STATUS ATUAL ESTA ATIVO
						aSup := {}

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³monta uma array bidimensional, com os subordinados relativos a cada visao ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				   		ApdaDorNivel( RDE->RDE_ITEVIS , xFilial("RDE") , RDE->RDE_CODVIS , "2" , 1, aSup )
				   		Exit
		            EndIf
					RDE->( dbSkip() )
				EndDo
			EndIf
		EndIf

		::SkinParticipant:Registration	:= aUser[1]
		::SkinParticipant:Name			:= aUser[2]
		::SkinParticipant:Filial		:= aUser[3]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³SE ENCONTROU ALGUM AVALIADOR                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aSup) > 0
			RD0->( DbSetOrder(1) )
			If RD0->( dbSeek(xFilial("RD0")+aSup[1][1]) )
				::SkinParticipant:EvaluatorName	:= RD0->RD0_NOME
			EndIf
		EndIf

		::SkinParticipant:LastUpdate := GetLastUpdate( ::ParticipantID )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³CODIGO DO MENTOR                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RD0->( DbSetOrder(1) )
		If RD0->( dbSeek(xFilial("RD0")+::ParticipantID) )
			::SkinParticipant:CodMentor		:= RD0->RD0_CODMEN
			if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODMEN), "RA_NOMECMP"))
				::SkinParticipant:MentorName	:= SRA->RA_NOMECMP  // Pega o nome do Mentor
			Else
				::SkinParticipant:MentorName	:= Fdesc("RD0",RD0->RD0_CODMEN,"RD0_NOME")
			EndIf
		EndIf
		::SkinParticipant:HierarqLevel		:=  getNivelCarreira(ParticipantId)[2]
		::SkinParticipant:Area				:=	getFunCCDesc(ParticipantId)
		::SkinParticipant:Empresa				:= cEmpAnt
	Else
		lRetorno := .F.
		SetSoapFault("GETPARTICIPANT",STR0027+STR0038) //"Participante não encontrado no cadastro de funcionários.""/ Vinculado a funcionário com situação = Demitido."
	EndIf
Else
	lRetorno := .F.
	SetSoapFault("GETPARTICIPANT",STR0035 + cMsgErro) //"Os seguintes campos nao foram encontrados: "
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DelExpItem	 ³ Autor ³Juliana B.  		  ³Data ³18.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Excluir Historico de carreira									³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD DelExpItem WSRECEIVE UserCode, HistoryId WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

dbSelectArea("RBN")
dbGoTo(::HistoryId) //POSICIONA NO REGISTRO CORRETO

Reclock("RBN",.F.)
dbDelete()     //APAGA REGISTRO
MsUnlock()

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwEntData	 ³ Autor ³Rogerio Augusto     ³Data ³05.01.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta a tela com o formulario para cadastro de entidades.		³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwEntData WSRECEIVE UserCode, ParticipantID WSSEND aClassData WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
Local nI 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
::aClassData:UserID := ::ParticipantID

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo os tipos de entidades disponiveis na RE8                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("RE8")
dbSetOrder(1)
If dbSeek(xFilial("RE8"))
	While !EOF()
		nI++
		aAdd( ::aClassData:aComboClassList, WSClassNew('ComboClassList') )
		::aClassData:aComboClassList[nI]:LabelID := RE8->RE8_IDENT
	   	::aClassData:aComboClassList[nI]:LabelDescription := RE8->RE8_IDESCR
	   	::aClassData:aComboClassList[nI]:RegLabel := RE8->RE8_SIGLA
	   	::aClassData:aComboClassList[nI]:RegDescription := RE8->RE8_DESCR
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de cursos cadastrados pelo usuario                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nI := 0
dbSelectArea("RE6")
dbSelectArea("REU")
REU->( dbSetOrder(1) )
If REU->( dbSeek(xFilial("REU") + ::ParticipantID) )
	While !REU->(EOF()) .AND. REU->REU_CODPES == ::ParticipantID
		nI++
		aAdd( ::aClassData:aUserClassList, WSClassNew('UserClassList') )
		::aClassData:aUserClassList[nI]:RegLabel			:= REU->REU_SIGLA
	   	::aClassData:aUserClassList[nI]:RegDescription		:= ApdMsMm(REU->REU_NUMREG)//FDESC("REU",REU->REU_NUMREG,"RE8_DESCR",,,2)
	   	::aClassData:aUserClassList[nI]:RegNumber			:= REU->REU_NUMREG
	   	::aClassData:aUserClassList[nI]:EspecCode			:= REU->REU_C_ESP
	   	::aClassData:aUserClassList[nI]:EspecDescr			:= ApdMsMm( REU->REU_C_ESP , , , , 3 , , , "REU" , "REU_ESPEC" , "RE6" )
	   	::aClassData:aUserClassList[nI]:OtherDescription	:= ApdMsMm( REU->REU_CODDES )
		::aClassData:aUserClassList[nI]:RegRecno			:= REU->( Recno() )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³DATA DA ULTIMA ALTERACAO                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(::aClassData:LastUpdate) .Or. ::aClassData:LastUpdate < REU->REU_DTALT
			::aClassData:LastUpdate := REU->REU_DTALT
		EndIf

		REU->( dbSkip() )
	EndDo
EndIf
RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DelEntItem	 ³ Autor ³Rogerio Augusto     ³Data ³31.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Excluir item de entidade filiada								³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD DelEntItem WSRECEIVE UserCode, RegRecno WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

dbSelectArea("REU")
dbGoto(::RegRecno)
Reclock("REU",.F.)
dbDelete()     //APAGA REGISTRO
MsUnlock()

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutEntData	 ³ Autor ³Rogerio Augusto     ³Data ³01.02.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Incluir / Alterar Filiacao a Entidade							³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutEntData WSRECEIVE UserCode, Include, ParticipantID, RegRecno, UserClassItem WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local lRetorno  := .T.

dbSelectArea("REU")
dbSetOrder(1)

If ::Include == .F. //SE FOR ALTERACAO
	dbGoTo(::RegRecno)
EndIf

Reclock("REU",::Include)

REU->REU_FILIAL	:= xFilial("REU")
REU->REU_CODPES	:= ::ParticipantID
REU->REU_SIGLA	:= ::UserClassItem:EspecCode
REU->REU_NUMREG	:= ::UserClassItem:RegNumber
REU->REU_DTALT	:= date()
If !Empty(::UserClassItem:REGDESCRIPTION)
	ApdMsMm( REU_C_ESP , , , ::UserClassItem:RegDescription , 1 , , , "REU" , "REU_C_ESP" , "RE6" )
EndIf

If !Empty(::UserClassItem:OTHERDESCRIPTION)
	ApdMsMm( REU->REU_CODDES , , , ::UserClassItem:OtherDescription , 1 , , , "REU" , "REU_CODDES")
EndIf

REU->(MsUnlock())

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetQualify	 ³ Autor ³Juliana B. Mariano  ³Data ³25.02.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta Descricao com qualificacoes dos funcionarios			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetQualify WSRECEIVE UserCode, ParticipantID WSSEND Descriptions WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
  
dbSelectArea("RD0")
dbSetOrder(1)
If dbSeek(xFilial("RD0")+::ParticipantID)
  	::Descriptions:LastUpdate	:= RD0->RD0_ALTQUA
	::Descriptions:Description	:= Alltrim(ApdMsMm(RD0->RD0_CODQUA))
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutQualify	 ³ Autor ³Juliana B. Mariano  ³Data ³25.02.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inclusao Descricao com qualificacoes dos funcionarios			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutQualify WSRECEIVE UserCode, ParticipantID, QualifyDescription WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

If !Empty(::QualifyDescription)
	dbSelectArea("RD0")
	dbSetOrder(1)
	If dbSeek(xFilial("RD0")+::ParticipantID)
		Reclock("RD0",.F.)             
		RD0->RD0_ALTQUA		:= date()
		ApdMsMm(RD0->RD0_CODQUA,,,::QualifyDescription,1,,,"RD0","RD0_CODQUA")
		MsUnlock()
	EndIf
EndIf 

RestArea(aArea)  

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetParticipant ³ Autor ³Juliana Barros      ³Data ³20.01.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta dados do participante logado.                        ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function Participant(	cParticipantID,;	//CODIGO DO PARTICIPANTE
						aUser,;				//ARRAY COM NOME E MATRICULA DO PARTICIPANTE   
						lDemitido,;			//SE CONSIDERA FUNCIONARIO DEMITIDO
						cEnrolmentID,;		//IDENTIFICA MATRICULA ATIVA DO FUNCIONARIO
						cEmpComp)		//IDENTIFICA MATRICULA ATIVA DO FUNCIONARIO
Local aArea   			:= GetArea()
Local lRetorno			:= .T.
Local cWhere				:= ""
Local lOracle 			:= .F. 
Local lDB2    			:= .F.
Local lInformix 			:= .F. 
Local lPostGres 			:= .F.   
Local cQuery				:= GetNextAlias()
Local cVisMenu			:= GetMv("MV_TCFVREN", ,"N") // Define se usuário demitido pode acessar Portal para visualizar rendimento. 
Local cRd0, cRdz, cSra	:= ""

DEFAULT aUser 			:= {}
DEFAULT lDemitido			:= .F.
DEFAULT cEnrolmentID		:= ""
DEFAULT cEmpComp			:= ""

IF TCGetDB()		==	"DB2"
	lDB2 	  := .T.
ElseIf TCGetDB()	==	"ORACLE"
	lOracle	  := .T.   
ElseIF TCGetDB () 	== "POSTGRES"
	lPostGres := .T.
ElseIF TCGetDB () == "INFORMIX"
	lInformix	:= .T.
Endif

cWhere := "%"
If !Empty(cEnrolmentID)	
	cWhere += " AND SRA.RA_MAT = '" + cEnrolmentID + "'"
EndIf	
cWhere += "%"

If !Empty(cEmpComp)
	cRd0	:= "%RD0"+cEmpComp+"0%"
	cRdz	:= "%RDZ"+cEmpComp+"0%"
	cSra	:= "%SRA"+cEmpComp+"0%"
	
	If lDB2 .Or. lOracle .Or. lPostGres
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Funcao Concat() soh existe no DB2                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		BEGINSQL ALIAS cQuery
			COLUMN RA_ADMISSA AS DATE
			
			SELECT
				RA_MAT,
				RD0_NOME,
				RA_NOMECMP,
				RA_FILIAL,
				RA_RG,
				RA_ADMISSA,
				RA_CODFUNC,
				RA_CARGO,
				RA_DEPTO,
				RA_SITFOLH,
				RA_RESCRAI,
				RA_REGIME
			FROM %Exp:cRd0% RD0
			INNER JOIN %Exp:cRdz% RDZ
			ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
			INNER JOIN %Exp:cSra% SRA
			ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( Concat(SRA.RA_FILIAL,SRA.RA_MAT) )
			WHERE 
				RD0.RD0_FILIAL = %xFilial:RD0% AND
				RD0.RD0_CODIGO = %exp:cParticipantID% AND
				RD0.%notDel% AND
				RDZ.%notDel% AND
				SRA.%notDel%
				%exp:cWhere%
		ENDSQL
	ElseiF lInformix
	 	BEGINSQL ALIAS cQuery
			COLUMN RA_ADMISSA AS DATE
			
			SELECT
				RA_MAT,
				RD0_NOME,
				RA_NOMECMP,
				RA_FILIAL,
				RA_RG,
				RA_ADMISSA,
				RA_CODFUNC,
				RA_CARGO,
				RA_DEPTO,
				RA_SITFOLH,
				RA_RESCRAI,
				RA_REGIME
			FROM %Exp:cRd0% RD0
			INNER JOIN %Exp:cRdz% RDZ
			ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
			INNER JOIN %Exp:cSra% SRA
			ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( SRA.RA_FILIAL || SRA.RA_MAT )
			WHERE 
				RD0.RD0_FILIAL = %xFilial:RD0% AND
				RD0.RD0_CODIGO = %exp:cParticipantID% AND
				RD0.%notDel% AND
				RDZ.%notDel% AND
				SRA.%notDel%
				%exp:cWhere%
		ENDSQL
	Else 
		BEGINSQL ALIAS cQuery
			COLUMN RA_ADMISSA AS DATE
			
			SELECT
				RA_MAT,
				RD0_NOME,
				RA_NOMECMP,
				RA_FILIAL,
				RA_RG,
				RA_ADMISSA,
				RA_CODFUNC,
				RA_CARGO,
				RA_DEPTO,
				RA_SITFOLH,
				RA_RESCRAI,
				RA_REGIME
			FROM %Exp:cRd0% RD0
			INNER JOIN %Exp:cRdz% RDZ
			ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
			INNER JOIN %Exp:cSra% SRA
			ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( SRA.RA_FILIAL + SRA.RA_MAT )
			WHERE 
				RD0.RD0_FILIAL = %xFilial:RD0% AND
				RD0.RD0_CODIGO = %exp:cParticipantID% AND
				RD0.%notDel% AND
				RDZ.%notDel% AND
				SRA.%notDel%
				%exp:cWhere%
		ENDSQL	
	EndIf
Else
	If lDB2 .Or. lOracle .Or. lPostGres
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Funcao Concat() soh existe no DB2                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		BEGINSQL ALIAS cQuery
			COLUMN RA_ADMISSA AS DATE
			
			SELECT
				RA_MAT,
				RD0_NOME,
				RA_NOMECMP,
				RA_FILIAL,
				RA_RG,
				RA_ADMISSA,
				RA_CODFUNC,
				RA_CARGO,
				RA_DEPTO,
				RA_SITFOLH,
				RA_RESCRAI,
				RA_REGIME
			FROM %table:RD0% RD0
			INNER JOIN %table:RDZ% RDZ
			ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
			INNER JOIN %table:SRA% SRA
			ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( Concat(SRA.RA_FILIAL,SRA.RA_MAT) )
			WHERE 
				RD0.RD0_FILIAL = %xFilial:RD0% AND
				RD0.RD0_CODIGO = %exp:cParticipantID% AND
				RD0.%notDel% AND
				RDZ.%notDel% AND
				SRA.%notDel%
				%exp:cWhere%
		ENDSQL
	ElseiF lInformix
	 	BEGINSQL ALIAS cQuery
			COLUMN RA_ADMISSA AS DATE
			
			SELECT
				RA_MAT,
				RD0_NOME,
				RA_NOMECMP,
				RA_FILIAL,
				RA_RG,
				RA_ADMISSA,
				RA_CODFUNC,
				RA_CARGO,
				RA_DEPTO,
				RA_SITFOLH,
				RA_RESCRAI,
				RA_REGIME
			FROM %table:RD0% RD0
			INNER JOIN %table:RDZ% RDZ
			ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
			INNER JOIN %table:SRA% SRA
			ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( SRA.RA_FILIAL || SRA.RA_MAT )
			WHERE 
				RD0.RD0_FILIAL = %xFilial:RD0% AND
				RD0.RD0_CODIGO = %exp:cParticipantID% AND
				RD0.%notDel% AND
				RDZ.%notDel% AND
				SRA.%notDel%
				%exp:cWhere%
		ENDSQL
	Else 
		BEGINSQL ALIAS cQuery
			COLUMN RA_ADMISSA AS DATE
			
			SELECT
				RA_MAT,
				RD0_NOME,
				RA_NOMECMP,
				RA_FILIAL,
				RA_RG,
				RA_ADMISSA,
				RA_CODFUNC,
				RA_CARGO,
				RA_DEPTO,
				RA_SITFOLH,
				RA_RESCRAI,
				RA_REGIME
			FROM %table:RD0% RD0
			INNER JOIN %table:RDZ% RDZ
			ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
			INNER JOIN %table:SRA% SRA
			ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( SRA.RA_FILIAL + SRA.RA_MAT )
			WHERE 
				RD0.RD0_FILIAL = %xFilial:RD0% AND
				RD0.RD0_CODIGO = %exp:cParticipantID% AND
				RD0.%notDel% AND
				RDZ.%notDel% AND
				SRA.%notDel%
				%exp:cWhere%
		ENDSQL	
	EndIf  
EndIf   

(cQuery)->(dbGoTop())
While (cQuery)->(!EoF())
	If (cQuery)->RA_SITFOLH != "D" .OR. lDemitido 	//SE FUNCIONARIO NAO ESTIVER COMO DEMITIDO
		aAdd(aUser, (cQuery)->RA_MAT) 				//1 - MATRICULA DO FUNCIONARIO
		
		If ! Empty((cQuery)->RA_NOMECMP)
			aadd(aUser, (cQuery)->RA_NOMECMP) 	//2 - NOME COMPLETO
		Else
			aadd(aUser, (cQuery)->RD0_NOME) 	//2 - NOME
		EndIf
		aAdd(aUser, (cQuery)->RA_FILIAL) 			//3 - FILIAL
		aAdd(aUser, (cQuery)->RA_RG) 				//4 - RG
		aAdd(aUser, (cQuery)->RA_ADMISSA) 			//5 - DATA DE ADMISSAO
		aAdd(aUser, (cQuery)->RA_CODFUNC) 			//6 - CODIGO DO FUNCIONARIO PELO CAMPO ANTIGO
		aAdd(aUser, (cQuery)->RA_CARGO)				//7 - CODIGO DO FUNCIONARIO PELO CAMPO NOVO
		aAdd(aUser, (cQuery)->RA_DEPTO)				//8 - DEPARTAMENTO
        aAdd(aUser, (cQuery)->RA_SITFOLH) 	 		//9 - SITUACAO DO FUNCIONARIO
        aAdd(aUser, (cQuery)->RA_RESCRAI)  			//10 - MOTIVO DA RESCISAO
        aAdd(aUser, (cQuery)->RA_REGIME)  			//11 - Regime
		Exit
	EndIf   
	
	(cQuery)->(DBSkip())
EndDo

(cQuery)->( dbGoTop() )    
While (cQuery)->(!EoF())
	If (cQuery)->RA_SITFOLH == "D" .AND. ( (cQuery)->RA_RESCRAI $ '30/31' .OR. cVisMenu == "S" )  //Transferencia ou Visualizar menu quando demitido
		Varinfo("Adicionou 02 - ",(cQuery)->RA_MAT)    
            aAdd(aUser, (cQuery)->RA_MAT)       //1 - MATRICULA DO FUNCIONARIO
            aAdd(aUser, (cQuery)->RD0_NOME)     //2 - NOME
            aAdd(aUser, (cQuery)->RA_FILIAL)    //3 - FILIAL
            aAdd(aUser, (cQuery)->RA_RG)        //4 - RG
            aAdd(aUser, (cQuery)->RA_ADMISSA)   //5 - DATA DE ADMISSAO
            aAdd(aUser, (cQuery)->RA_CODFUNC)   //6 - CODIGO DO FUNCIONARIO PELO CAMPO ANTIGO
            aAdd(aUser, (cQuery)->RA_CARGO)     //7 - CODIGO DO FUNCIONARIO PELO CAMPO NOVO
            aAdd(aUser, (cQuery)->RA_DEPTO)     //8 - DEPARTAMENTO
            aAdd(aUser, (cQuery)->RA_SITFOLH)   //9 - SITUACAO DO FUNCIONARIO
            aAdd(aUser, (cQuery)->RA_RESCRAI)   //10 - MOTIVO DA RESCISAO
            aAdd(aUser, (cQuery)->RA_REGIME)    //11 - Regime
		Exit
	EndIf   
	(cQuery)->(DBSkip())
EndDo

lRetorno := (Len(aUser) > 0)
(cQuery)->(DBCloseArea())

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MatParticipant ³ Autor ³Marcelo Faria       ³Data ³08.05.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna dados de todas as matriculas do participante logado.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function MatParticipant( cParticipantID,;
						 aUser,;     
						 lDemitido)
Local aArea     := GetArea()
Local cBusca    := ""
Local lRetorno  := .T.
Local lOracle 	:= .F. 
Local lDB2    	:= .F.
Local lInformix	:= .F.
Local lPostGres	:= .F.  
Local cQuery	:= GetNextAlias()
Local cTpLogin	:= GetMv("MV_GCHSDOC", NIL, "1")
Local cVisMenu	:= GetMv("MV_TCFVREN", ,"N")
Local cNome		:= ''

DEFAULT aUser 		:= {}
DEFAULT lDemitido	:= .F.

IF TCGetDB()     == "DB2"
	lDB2 	  := .T.
ElseIf TCGetDB() == "ORACLE"
	lOracle	  := .T.  
ElseIf TCGetDB() == "POSTGRES"
	lPostGres := .T.   
ElseIf TCGetDB()== "INFORMIX"
	lInformix:= .T.  
Endif

If cTpLogin == "1" 
	cBusca	:= "% RD0.RD0_LOGIN = '" +(UPPER(ALLTRIM(cParticipantID)))+ "' %"
ElseIf cTpLogin == "2"
	cBusca	:= "% RD0.RD0_DOCID = '" +(UPPER(ALLTRIM(cParticipantID)))+ "' %"
Else
	Return(.F.)
EndIf

If lDB2 .Or. lOracle .Or. lPostGres
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao Concat() soh existe no DB2                                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	BEGINSQL ALIAS cQuery
		COLUMN RA_ADMISSA AS DATE
		
		SELECT
			RA_MAT,
			RA_NOMECMP,
			RD0_NOME,
			RA_FILIAL,
			RA_RG,
			RA_ADMISSA,
			RA_CODFUNC,
			RA_CARGO,
			RA_DEPTO,
			RA_SITFOLH,
			RA_RESCRAI
		FROM %table:RD0% RD0
		INNER JOIN %table:RDZ% RDZ
		ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
		INNER JOIN %table:SRA% SRA
		ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( Concat(SRA.RA_FILIAL,SRA.RA_MAT) )
		WHERE
			RD0.RD0_FILIAL = %xFilial:RD0% AND
			RDZ.RDZ_ENTIDA = 'SRA' AND
			%exp:cBusca% AND
			RD0.%notDel% AND
			RDZ.%notDel% AND
			SRA.%notDel%
	ENDSQL
ElseIf lInformix
	BEGINSQL ALIAS cQuery
		COLUMN RA_ADMISSA AS DATE
		
		SELECT
			RA_MAT,
			RA_NOMECMP,
			RD0_NOME,
			RA_FILIAL,
			RA_RG,
			RA_ADMISSA,
			RA_CODFUNC,
			RA_CARGO,
			RA_DEPTO,
			RA_SITFOLH,
			RA_RESCRAI
		FROM %table:RD0% RD0
		INNER JOIN %table:RDZ% RDZ
		ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
		INNER JOIN %table:SRA% SRA
		ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( SRA.RA_FILIAL || SRA.RA_MAT )
		WHERE
			RD0.RD0_FILIAL = %xFilial:RD0% AND
			RDZ.RDZ_ENTIDA = 'SRA' AND
			%exp:cBusca% AND
			RD0.%notDel% AND
			RDZ.%notDel% AND
			SRA.%notDel%
	ENDSQL
Else
	BEGINSQL ALIAS cQuery
		COLUMN RA_ADMISSA AS DATE
		
		SELECT
			RA_MAT,
			RA_NOMECMP,
			RD0_NOME,
			RA_FILIAL,
			RA_RG,
			RA_ADMISSA,
			RA_CODFUNC,
			RA_CARGO,
			RA_DEPTO,
			RA_SITFOLH,
			RA_RESCRAI
		FROM %table:RD0% RD0
		INNER JOIN %table:RDZ% RDZ
		ON RDZ.RDZ_CODRD0 = RD0.RD0_CODIGO
		INNER JOIN %table:SRA% SRA
		ON RTRIM(RDZ.RDZ_CODENT) = RTRIM( SRA.RA_FILIAL + SRA.RA_MAT )
		WHERE
			RD0.RD0_FILIAL = %xFilial:RD0% AND
			RDZ.RDZ_ENTIDA = 'SRA' AND
			%exp:cBusca% AND
			RD0.%notDel% AND
			RDZ.%notDel% AND
			SRA.%notDel%
	ENDSQL	
EndIf 	

(cQuery)->(dbGoTop())
While (cQuery)->(!EoF())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca Multiplos Vinculos                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If (cQuery)->RA_SITFOLH != "D" .OR. (cQuery)->RA_RESCRAI $ '30/31' .OR. cVisMenu=="S"	//Transferencia ou Visualizar menu quando demitido
		If ! Empty((cQuery)->RA_NOMECMP)
			cNome := (cQuery)->RA_NOMECMP
		Else
			cNome := (cQuery)->RD0_NOME
		EndIf
		aAdd(aUser, {(cQuery)->RA_MAT,		;	// 1 - MATRICULA DO FUNCIONARIO
					cNome,					;	// 2 - NOME
					(cQuery)->RA_FILIAL,	;	// 3 - FILIAL
					(cQuery)->RA_RG,		;	// 4 - RG
					(cQuery)->RA_ADMISSA,	;	// 5 - DATA DE ADMISSAO
					(cQuery)->RA_CODFUNC,	;	// 6 - CODIGO DO FUNCIONARIO PELO CAMPO ANTIGO
					(cQuery)->RA_CARGO,		;	// 7 - CODIGO DO FUNCIONARIO PELO CAMPO NOVO
					(cQuery)->RA_DEPTO,		;	// 8 - DEPARTAMENTO
					(cQuery)->RA_SITFOLH,	;	// 9 - SITUACAO DO FUNCIONARIO
					(cQuery)->RA_RESCRAI }	)	//10 - MOTIVO DA RESCISAO
	EndIf
	(cQuery)->(DBSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordena o array por Filial+Matricula                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
aUser := aSort( aUser,,, { |x, y| x[3]+x[1] < y[3]+y[1]  } )
lRetorno := (Len(aUser) > 0)
(cQuery)->(DBCloseArea())

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwLearning	 ³ Autor ³Juliana Barros      ³Data ³12.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta de capacitacao interna.                              ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwLearning WSRECEIVE UserCode, ItemCod, ParticipantID WSSEND ListOfCourses WSSERVICE RHEmployedCurriculum
Local aArea     	:= GetArea()
Local aRet			:= {}
Local aEntidade		:= {}
Local lRetorno  	:= .T.
Local nI 			:= 0  
Local nEnt			:= 0
Local nOrdem		:= 0
Local escalaNivel	:= ""
Local escalaStatus	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If Participant( ::ParticipantID, aRet )
	::ListOfCourses:UserID 	 := aRet[1] //SRA->RA_MAT
	::ListOfCourses:UserName := aRet[2] //SRA->RA_NOME
Else
	lRetorno := .F.
	SetSoapFault("BrwItemData",STR0026)			 //"Participante nao encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BUSCA CODIGO DO TIPO DE CURSO DENTRO DOS CURSOS INTERNOS³
//³Localizo as escalas na SQX a partir do codigo do item   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
SQX->( dbSetOrder(1) )
If SQX->( dbSeek(xFilial("SQX")+::ItemCod ) )
	escalaNivel := SQX->QX_NIVEL
	escalaStatus := SQX->QX_STATUS
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de cursos cadastrados pelo usuario        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
RA4->( dbSetOrder(1) )
If RA4->( dbSeek(xFilial("RA4")+::ListOfCourses:UserID) )
	While !RA4->(Eof()) .And. RA4->(RA4_FILIAL+RA4_MAT) == (xFilial("RA4")+::ListOfCourses:UserID)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PEGA INDICE DO RA1                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		nOrdem := RetOrdem( "RA1" , "RA1_FILIAL+RA1_TIPOPP+RA1_CURSO" )

		RA1->( dbSetOrder(nOrdem) ) //RA1_FILIAL+RA1_TIPOPP+RA1_CURSO
		If RA1->( dbSeek(xFilial("RA1")+::ItemCod+RA4->RA4_CURSO ) )
			nI++
			aAdd( ::ListOfCourses:aCourseList, WSClassNew('CourseList') )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³GRAVA DATA DA ULTIMA ALTERACAO                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			If Empty(::ListOfCourses:LastUpdate) .Or. ::ListOfCourses:LastUpdate < RA4->RA4_DTALT
				::ListOfCourses:LastUpdate := RA4->RA4_DTALT
			EndIf
			::ListOfCourses:aCourseList[nI]:CourseCod	:= RA4->RA4_CURSO
			::ListOfCourses:aCourseList[nI]:CourseMat	:= RA4->RA4_MAT
			RA1->( dbSetOrder(1) ) //FILIAL+TIPOPP
			If RA1->( dbSeek(xFilial("RA1")+RA4->RA4_CURSO ) )
				::ListOfCourses:aCourseList[nI]:CourseName	:= AllTrim(RA1->RA1_DESC)
			EndIf

			RA0->( dbSetOrder(1) )
			If RA0->( dbSeek(xFilial("RA0")+RA4->RA4_ENTIDA) )
				::ListOfCourses:aCourseList[nI]:CourseEntDesc	:= RA0->RA0_DESC
			EndIf
			::ListOfCourses:aCourseList[nI]:CourseEnt	:= RA4->RA4_ENTIDA
			::ListOfCourses:aCourseList[nI]:CourseCDate	:= RA4->RA4_DATAFI
			::ListOfCourses:aCourseList[nI]:CourseIDate	:= RA4->RA4_DATAIN
			::ListOfCourses:aCourseList[nI]:CourseTime	:= RA4->RA4_DURACA
			::ListOfCourses:aCourseList[nI]:CourseDesc	:= AllTrim(ApdMsMm(RA4->RA4_CODCOM))
			::ListOfCourses:aCourseList[nI]:RegRecno	:= RA4->( Recno() )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Localiza a escala na RBL                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			RBL->(dbSetOrder(1))
			If RBL->(dbSeek(xFilial("RBL")+escalaNivel+RA4->RA4_NIVEL))
				::ListOfCourses:aCourseList[nI]:CourseTypeLv := RA4->RA4_NIVEL
				::ListOfCourses:aCourseList[nI]:CourseType := RBL->RBL_DESCRI
			EndIf
			If RBL->(dbSeek(xFilial("RBL")+escalaStatus+RA4->RA4_STATUS))
				::ListOfCourses:aCourseList[nI]:CourseStatusLv := RA4->RA4_STATUS
				::ListOfCourses:aCourseList[nI]:CourseStatus := RBL->RBL_DESCRI
			EndIf
		EndIf
		RA4->( dbSkip() )
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de cursos disponiveis no sistema          ³
//³BUSCA CURSOS INTERNOS                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
::ListOfCourses:aCourseNames := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PEGA INDICE DO RA1                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
nOrdem := RetOrdem( "RA1" , "RA1_FILIAL+RA1_TIPOPP+RA1_CURSO" )

RA1->( dbSetOrder(nOrdem) ) //RA1_FILIAL+RA1_TIPOPP+RA1_CURSO
If RA1->( dbSeek(xFilial("RA1")+::ItemCod ) )
	nI := 0
	While !RA1->( Eof() ) .And. RA1->RA1_FILIAL == xFilial("RA1") .And. RA1->RA1_TIPOPP == ::ItemCod
		If AllTrim(Upper(RA1->RA1_DESC)) != AllTrim(Upper(STR0028)) //"Outros"
			nI++
			aAdd( ::ListOfCourses:aCourseNames, WSClassNew('CourseNames') )
			::ListOfCourses:aCourseNames[nI]:CourseCod	:= RA1->RA1_CURSO
		   	::ListOfCourses:aCourseNames[nI]:CourseName	:= RA1->RA1_DESC

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³VERIFICAR LISTA DE ENTIDADES DE ACORDO COM O CURSO      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		   	RA6->( dbSetOrder(2) )
		   	If RA6->( dbSeek(xFilial("RA6")+RA1->RA1_CURSO) )
		   		While !RA6->(EOF()) .and. xFilial("RA6")+RA1->RA1_CURSO == RA6->RA6_FILIAL+RA6->RA6_CURSO
			   		If aScan( aEntidade, RA6->RA6_ENTIDA ) == 0
						aAdd( aEntidade, RA6->RA6_ENTIDA )
					EndIf  
					RA6->( dbSkip() )			
			   EndDo          
			EndIf
		EndIf
		RA1->( dbSkip() )
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordenar por Descricao                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	Asort( ::ListOfCourses:aCourseNames,,, {|x,y| x:CourseName < y:CourseName } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inclusao do Curso "OUTROS" se houver na base            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	RA1->(dbSetOrder(2))
	If RA1->(dbSeek(xFilial("RA1")+AllTrim(Upper(STR0028))))
		nI++
		aAdd( ::ListOfCourses:aCourseNames, WSClassNew('CourseNames') )

	    ::ListOfCourses:aCourseNames[nI]:CourseCod	:= RA1->RA1_CURSO
	    ::ListOfCourses:aCourseNames[nI]:CourseName	:= RA1->RA1_DESC
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de instituicoes de ensino                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
::ListOfCourses:aLearn := {}
For nI := 1 to len(aEntidade)
	RA0->( dbSetOrder(1) ) //FILIAL+ENTIDA
	If RA0->( dbSeek(xFilial("RA0")+aEntidade[nI] ) )
		aAdd( ::ListOfCourses:aLearn, WSClassNew('CourseNames') ) 
		nEnt++
		::ListOfCourses:aLearn[nEnt]:CourseCod	:= RA0->RA0_ENTIDA
	   	::ListOfCourses:aLearn[nEnt]:CourseName	:= RA0->RA0_DESC 
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de tipos de curso e status disponiveis no sistema ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
dbSelectArea("RBL")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tipos de curso                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
nI := 0
RBL->(dbSeek(xFilial("RBL")+escalaNivel))
while !RBL->(Eof()) .And. RBL->RBL_ESCALA == escalaNivel
	nI++
	aAdd( ::ListOfCourses:aTypesList, WSClassNew('CourseTypesList') )
	::ListOfCourses:aTypesList[nI]:ScaleCod := RBL->RBL_ESCALA
   	::ListOfCourses:aTypesList[nI]:ScaleItem := RBL->RBL_ITEM
   	::ListOfCourses:aTypesList[nI]:ScaleDescription := RBL->RBL_DESCRI
	RBL->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Status dos cursos                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
RBL->(dbGoTop())
nI := 0
RBL->(dbSeek(xFilial("RBL")+escalaStatus))
while !RBL->(Eof()) .And. RBL->RBL_ESCALA == escalaStatus
	nI++
	aAdd( ::ListOfCourses:aScaleList, WSClassNew('CourseScaleList') )
	::ListOfCourses:aScaleList[nI]:ScaleCod := RBL->RBL_ESCALA
   	::ListOfCourses:aScaleList[nI]:ScaleItem := RBL->RBL_ITEM
   	::ListOfCourses:aScaleList[nI]:ScaleDescription := RBL->RBL_DESCRI
	RBL->(dbSkip())
EndDo

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutLearning	 ³ Autor ³Juliana Barros      ³Data ³12.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cadastra um novo curso na tabela de cursos internos (RA4).	³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutLearning WSRECEIVE UserCode, ParticipantID, CourseData WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
Local aRet		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If Participant( ::ParticipantID, aRet )
	::CourseData:CourseMat := aRet[1] //SRA->RA_MAT
Else
	lRetorno := .F.
	SetSoapFault("PutCourse",STR0027) //"Participante não encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do cadastro do novo curso na SQ9                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
dbSelectArea("RA4")
dbSetOrder(1)

If ::CourseData:CourseInclude
	Reclock("RA4",.T.)
	RA4->RA4_FILIAL	:= xFilial("RA4")
	RA4->RA4_CURSO	:= ::CourseData:CourseCod
	RA4->RA4_MAT	:= ::CourseData:CourseMat
	RA4->RA4_NIVEL	:= ::CourseData:CourseType
Else
	dbGoTo(::CourseData:RegRecno)
	Reclock("RA4",.F.)
EndIf

RA4->RA4_ENTIDA	:= ::CourseData:CourseEnt
RA4->RA4_STATUS	:= ::CourseData:CourseStatus
RA4->RA4_DATAFI	:= ::CourseData:CourseCDate
RA4->RA4_DATAIN	:= ::CourseData:CourseIDate
RA4->RA4_DURACA	:= ::CourseData:CourseTime
RA4->RA4_DTALT	:= date()
If ExistBlock("DADOSFUNC")
	RA4->RA4_MATRM	:= aRet[8]
EndIf
If !Empty(::CourseData:CourseDesc)
	ApdMsMm(RA4->RA4_CODCOM,,,::CourseData:CourseDesc,1,,,"RA4","RA4_CODCOM")
EndIf
RA4->( MsUnlock() )

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DelLearning	 ³ Autor ³Juliana Barros      ³Data ³12.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Exclui um item da tabela de cursos internos (RA4).			³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD DelLearning WSRECEIVE UserCode, RegRecno WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³APAGA REGISTRO                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
dbSelectArea("RA4")
dbGoTo(::RegRecno)
RecLock("RA4",.F.)
dbDelete()
msUnlock()

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetComent	     ³ Autor ³Juliana B. Mariano  ³Data ³25.02.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta Descricao com qualificacoes dos funcionarios			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetComent WSRECEIVE UserCode, ParticipantID WSSEND Descriptions WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

dbSelectArea("RD0")
dbSetOrder(1)
If dbSeek(xFilial("RD0")+::ParticipantID)
	::Descriptions:LastUpdate	:= RD0->RD0_DTALT
	::Descriptions:Description	:= Alltrim(ApdMsMm(RD0->RD0_CODCOM))
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutComent	 	 ³ Autor ³Juliana B. Mariano  ³Data ³13.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inclusao Descricao com qualificacoes dos funcionarios			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutComent WSRECEIVE UserCode, ParticipantID, Comentaries WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

If !Empty(::Comentaries)
 	dbSelectArea("RD0")
	dbSetOrder(1)
	If dbSeek(xFilial("RD0")+::ParticipantID)
		Reclock("RD0",.F.)
		RD0->RD0_ALTCOM		:= date()
   		ApdMsMm(RD0->RD0_CODCOM,,,::Comentaries,1,,,"RD0","RD0_CODCOM")
   		MsUnlock()
	EndIf
EndIf 

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetLastUpdate  ³ Autor ³Juliana Barros      ³Data ³13.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta data da ultima atualizacao					  		³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function GetLastUpdate( cParticipantID )
Local aArea     := GetArea()
Local aUser		:= {}
Local dRetorno  := SToD("")
Local cFilSRA	:=	""

If Participant( cParticipantID, aUser )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³INICIO                                                          ³
	//³PARA GRAVAR DATA DA ULTIMA ALTERACAO INCLUINDO TODAS AS BASES   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
	RA0->( dbSetOrder(1) )
	If RA0->( dbSeek(xFilial("RD0")+cParticipantId) )
		dRetorno	:= RD0->RD0_DTALT
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CURSOS EXTERNOS                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	SQ9->( dbSetOrder(1) )
	If SQ9->( dbSeek(aUser[3]+aUser[1]) )
		While !SQ9->( Eof() ) .And. SQ9->(Q9_FILIAL+Q9_MAT) == (aUser[3]+aUser[1])
			If Empty(dRetorno) .Or. dRetorno < SQ9->Q9_DTALTER
				dRetorno := SQ9->Q9_DTALTER
			EndIf
			SQ9->( dbSkip() )
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³HISTORICO DE CARREIRA                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	SQC->( dbSetOrder(1) )
	fVerFil(@cFilSRA , "SQC" , aUser)		
	If SQC->( dbSeek(cFilSRA+aUser[1]) )
		While !SQC->( Eof() ) .And. SQC->(QC_FILIAL+QC_MAT) == (cFilSRA+aUser[1])
			If Empty(dRetorno) .Or. dRetorno < SQC->QC_DTALTER
				dRetorno := SQC->QC_DTALTER
			EndIf
			SQC->( dbSkip() )
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ATIVIDADES DO FUNCIONARIO                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	RBN->( dbSetOrder(1) )
	fVerFil(@cFilSRA , "RBN" , aUser)
	If RBN->( dbSeek(cFilSRA+aUser[1]) )
		While !RBN->( Eof() ) .And. RBN->(RBN_FILIAL+RBN_MAT) == (cFilSRA+aUser[1])
			If Empty(dRetorno) .Or. dRetorno < RBN->RBN_DTALT
				dRetorno := RBN->RBN_DTALT
			EndIf
			RBN->( dbSkip() )
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CADASTRO DE REG. DE CLASSE                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	REU->( dbSetOrder(1) )
	If REU->( dbSeek(xFilial("REU")+cParticipantId) )
		While !REU->( Eof() ) .And. REU->(REU_FILIAL+REU_CODPES) == (xFilial("REU")+cParticipantId)
			If Empty(dRetorno) .Or. dRetorno < REU->REU_DTALT
				dRetorno := REU->REU_DTALT
			EndIf
			REU->( dbSkip() )
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CURSOS DO FUNCIONARIO                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	RA4->( dbSetOrder(1) )
	If RA4->( dbSeek(xFilial("RA4")+aUser[1]) )
		While !RA4->( Eof() ) .And. RA4->(RA4_FILIAL+RA4_MAT) == (xFilial("RA4")+aUser[1])
			If Empty(dRetorno) .Or. dRetorno < RA4->RA4_DTALT
				dRetorno := RA4->RA4_DTALT
			EndIf
			RA4->( dbSkip() )
		EndDo
	EndIf
EndIf

RestArea(aArea)
Return(dRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwCertification	 ³ Autor ³Juliana Barros  ³Data ³13.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta de certificacao de mercado					  		³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwCertification WSRECEIVE UserCode, ItemCod, ParticipantID WSSEND ListOfCourses WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local aRet		:= {}
Local aEntidade	:= {}
Local cFilSRA	:= ''
Local lRetorno  := .T.
Local nI 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If Participant( ::ParticipantID, aRet )
	::ListOfCourses:UserID 		:= aRet[1] //SRA->RA_MAT
	::ListOfCourses:UserName 	:= aRet[2] //SRA->RA_NOME
	cFilSRA 					:= aRet[3] //SRA->RA_FILIAL
Else
	lRetorno := .F.
	SetSoapFault("BrwItemData",STR0026)			 //"Participante nao encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE EXISTE O CURSO OUTROS CADASTRADA NO CADASTRO DE CURSOS, FUNCAO  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutOthers( ::ItemCod )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de cursos cadastrados pelo usuario                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
SQ9->( dbSetOrder(1) )
If SQ9->(dbSeek(cFilSRA+::ListOfCourses:UserID))
	While !SQ9->(Eof()) .And. ( SQ9->Q9_MAT == ::ListOfCourses:UserID )  .And. ;
		SQ9->Q9_FILIAL == cFilSRA
		SQT->(dbSetOrder(1))
		If SQT->(dbSeek(xFilial("SQT")+SQ9->Q9_CURSO+::ItemCod,.T.))
			nI++
			aAdd( ::ListOfCourses:aCourseList, WSClassNew('CourseList') )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³GRAVA DATA DA ULTIMA ALTERACAO                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			If Empty(::ListOfCourses:LastUpdate) .Or. ::ListOfCourses:LastUpdate < SQ9->Q9_DTALTER
				::ListOfCourses:LastUpdate := SQ9->Q9_DTALTER
			EndIf
			::ListOfCourses:aCourseList[nI]:CourseCod	:= SQ9->Q9_CURSO
			::ListOfCourses:aCourseList[nI]:CourseMat	:= SQ9->Q9_MAT
			::ListOfCourses:aCourseList[nI]:CourseName	:= SQ9->Q9_DESCRIC
			::ListOfCourses:aCourseList[nI]:CourseEnt	:= AllTrim(SQ9->Q9_ENTIDAD)
			::ListOfCourses:aCourseList[nI]:CourseType	:= AllTrim(SQ9->Q9_VERSAO)
			::ListOfCourses:aCourseList[nI]:CourseCDate	:= SQ9->Q9_DATVENC
			::ListOfCourses:aCourseList[nI]:CourseIDate	:= SQ9->Q9_DTINI
			::ListOfCourses:aCourseList[nI]:RegRecno	:= SQ9->( Recno() )
			::ListOfCourses:aCourseList[nI]:OtherCert	:= ApdMsmm( SQ9->Q9_CODCERT )
		EndIf
		SQ9->(dbSkip())
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de cursos disponiveis no sistema                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
dbSelectArea("SQT")
dbSetOrder(3) //ANTIGO 4
nI := 0
SQT->(dbSeek(xFilial("SQT")+::ItemCod))
While !SQT->(Eof()) .And. SQT->QT_TIPO == ::ItemCod
	If AllTrim(Upper(SQT->QT_DESCRIC)) != AllTrim(Upper(STR0028)) //"Outros"
		nI++
		aAdd( ::ListOfCourses:aCourseNames, WSClassNew('CourseNames') )
		::ListOfCourses:aCourseNames[nI]:CourseCod	:= SQT->QT_CURSO
	   	::ListOfCourses:aCourseNames[nI]:CourseName	:= SQT->QT_DESCRIC
	EndIf
	SQT->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordenar por Descricao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
Asort( ::ListOfCourses:aCourseNames,,, {|x,y| x:CourseName < y:CourseName } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclusao do Curso "OUTROS" se houver na base                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
SQT->(dbSetOrder(2))
If SQT->(dbSeek(xFilial("SQT")+AllTrim(Upper(STR0028))))
	nI++
	aadd(::ListOfCourses:aCourseNames,WSCLASSNEW('CourseNames'))

    ::ListOfCourses:aCourseNames[nI]:CourseCod	:= SQT->QT_CURSO
    ::ListOfCourses:aCourseNames[nI]:CourseName	:= SQT->QT_DESCRIC
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BUSCA ENTIDADES RELATIVAS                                       ³
//³PEGA INDICE DO RA1                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
nOrdem := RetOrdem( "RA1" , "RA1_FILIAL+RA1_TIPOPP+RA1_CURSO" )
RA1->( dbSetOrder(nOrdem) ) //RA1_FILIAL+RA1_TIPOPP+RA1_CURSO

If RA1->( dbSeek(xFilial("RA1")+::ItemCod ) )
	While !RA1->( Eof() ) .And. RA1->RA1_FILIAL == xFilial("RA1") .And. RA1->RA1_TIPOPP == ::ItemCod
		nI++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VERIFICAR LISTA DE ENTIDADES DE ACORDO COM O CURSO              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	   	RA6->( dbSetOrder(2) )
	   	If RA6->( dbSeek(xFilial("RA6")+RA1->RA1_CURSO) )
			While !RA6->( Eof() ) .And. RA6->RA6_FILIAL == xFilial("RA6") .And. RA6->RA6_CURSO == RA1->RA1_CURSO
			   	If aScan( aEntidade, RA6->RA6_ENTIDA ) == 0
					aAdd( aEntidade, RA6->RA6_ENTIDA )
				EndIf
				RA6->( DbSkip() )
			EndDo
		EndIf

		RA1->( dbSkip() )
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³monta a lista de instituicoes de ensino                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
::ListOfCourses:aLearn := {}
For nI := 1 to len(aEntidade)
	RA0->( dbSetOrder(1) ) //FILIAL+ENTIDA
	If RA0->( dbSeek(xFilial("RA0")+aEntidade[nI] ) )
		aAdd( ::ListOfCourses:aLearn, WSClassNew('CourseNames') )
		::ListOfCourses:aLearn[nI]:CourseCod	:= RA0->RA0_ENTIDA
	   	::ListOfCourses:aLearn[nI]:CourseName	:= RA0->RA0_DESC
	EndIf
Next

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutCertification	 ³ Autor ³Juliana Barros  ³Data ³13.07.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cadastra um novo curso na tabela de cursos internos (RA4).	³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutCertification WSRECEIVE UserCode, ParticipantID, CourseData WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.
Local aRet		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localizo a matricula a partir do ID logado                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If Participant( ::ParticipantID, aRet )
	::CourseData:CourseMat := aRet[1] //SRA->RA_MAT
Else
	lRetorno := .F.
	SetSoapFault("PutCourse",STR0027) //"Participante não encontrado no cadastro de funcionários."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do cadastro do novo curso na SQ9                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
dbSelectArea("SQ9")
dbSetOrder(1)

If ::CourseData:CourseInclude
	Reclock("SQ9",.T.)
	SQ9->Q9_FILIAL	:= aRet[3]
	SQ9->Q9_CURSO	:= ::CourseData:CourseCod
	SQ9->Q9_MAT		:= ::CourseData:CourseMat
	SQ9->Q9_DESCRIC	:= ::CourseData:CourseName
Else
	dbGoTo(::CourseData:RegRecno)
	Reclock("SQ9",.F.)
EndIf
                                                      
SQ9->Q9_ENTIDAD	:= ::CourseData:CourseEnt
SQ9->Q9_DATA	:= ::CourseData:CourseIDate
SQ9->Q9_DATVENC	:= ::CourseData:CourseCDate
SQ9->Q9_DTINI	:= ::CourseData:CourseIDate
SQ9->Q9_VERSAO	:= ::CourseData:CourseType
SQ9->Q9_DTALTER	:= date()

If ExistBlock("DADOSFUNC")
	SQ9->Q9_MATRM	:= aRet[8]
EndIf

If !Empty(::CourseData:OtherCert)
	ApdMsMm(SQ9->Q9_CODCERT,,,::CourseData:OtherCert,1,,,"SQ9","Q9_CODCERT")
EndIf

SQ9->( MsUnlock() )

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutOthers		 ³ Autor ³Juliana Barros      ³Data ³10.08.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inclui a palavra outros no cadastro de cursos externos  		³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function PutOthers( CodTypeCourse )   //CODIGO DO TIPO DE CURSO

Local aArea     := GetArea()
Local lRetorno  := .T.
Local lPossui	:= .F.
Local cCod		:= ""
Local cOutros	:= ALLTRIM(UPPER(STR0028)) //"Outros"

dbSelectArea("SQT") //OU SQX, VER DEPOIS
dbSetOrder(3) //QT_FILIAL+QT_TIPO+QT_CURSO
If dbSeek( xFilial("SQT")+CodTypeCourse )
	While !Eof() .And. SQT->(QT_FILIAL+QT_TIPO) == (xFilial("SQT")+CodTypeCourse)
		If Alltrim(UPPER(SQT->QT_DESCRIC)) == cOutros
			lPossui := .T. //INDICA QUE JA POSSUI O CURSO OUTROS CADASTRADO
			Exit
		EndIf
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SE NAO ACHOU O CURSO OUTROS CADASTRADA, GRAVA  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPossui == .F.
	cCod := GetSx8Num("SQT","QT_CURSO")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PARA VERIFICAR SE GETSX8NUM FUNCIONOU E CONFIRMAR               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If __lSX8
		ConfirmSX8()
	EndIf

	RecLock("SQT",.T.)

	SQT->QT_FILIAL	:= xFilial("SQT")
	SQT->QT_CURSO	:= cCod
	SQT->QT_DESCRIC	:= cOutros //"Outros"
	SQT->QT_TIPO	:= CodTypeCourse

	MsUnlock()
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutMentor	 	 ³ Autor ³Juliana B. Mariano  ³Data ³16.08.2005 ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutMentor WSRECEIVE UserCode, ParticipantID, CodMentor WSSEND WsNull WSSERVICE RHEmployedCurriculum
Local aArea     := GetArea()
Local lRetorno  := .T.

If !Empty(::ParticipantId) .And. !Empty(::CodMentor)
	dbSelectArea("RD0")
	dbSetOrder(1)
	If dbSeek( xFilial("RD0")+::ParticipantId )
		Reclock("RD0",.F.)
		RD0->RD0_CODMEN	:= ::CodMentor
		MsUnlock()
	Else
		lRetorno := .F.
		SetSoapFault("PutCourse",STR0027) //"Participante não encontrado no cadastro de funcionários."
	EndIf
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutOtherClass	 ³ Autor ³Juliana Barros      ³Data ³22.08.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inclui a palavra outros no cadastro de entidades		  		³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function PutOtherClass( CodTypeCourse )   //CODIGO DO TIPO DE CURSO
Local aArea     := GetArea()
Local lRetorno  := .T.
Local lPossui	:= .F.
Local cCod		:= ""

dbSelectArea("SQT") //OU SQX, VER DEPOIS
dbSetOrder(3) //QT_FILIAL+QT_TIPO+QT_CURSO
If dbSeek( xFilial("SQT")+CodTypeCourse )
	While !Eof() .And. SQT->(QT_FILIAL+QT_TIPO) == (xFilial("SQT")+CodTypeCourse)
		If AllTrim(UPPER(SQT->QT_DESCRIC)) == UPPER(STR0028)  //"OUTROS"
			lPossui := .T. //INDICA QUE JA POSSUI O CURSO OUTROS CADASTRADO
			Exit
		EndIf
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SE NAO ACHOU O CURSO OUTROS CADASTRADA, GRAVA  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPossui == .F.
	cCod := GetSx8Num("SQT","QT_CURSO")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PARA VERIFICAR SE GETSX8NUM FUNCIONOU E CONFIRMAR               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If __lSX8
		ConfirmSX8()
	EndIf

	RecLock("SQT",.T.)

	SQT->QT_FILIAL	:= xFilial("SQT")
	SQT->QT_CURSO	:= cCod
	SQT->QT_DESCRIC	:= STR0028 //"Outros"
	SQT->QT_TIPO	:= CodTypeCourse

	MsUnlock()
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UserMenu	    ³ Autor ³Juliana B. Mariano  ³Data ³19.09.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de visualizacao de tela de usuario		  			   ³±±
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
WSMETHOD UserMenu WSRECEIVE UserCode, MenuTitle WSSEND FunctionName WSSERVICE RHEmployedCurriculum
Local lRetorno	:= .T.
Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ITENS DE MENU CUSTOMIZADOS           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("WSAPUSR014")
	::FunctionName := ExecBlock("WSAPUSR014",.F.,.F.,{::MenuTitle})
Else
	lRetorno := .F.
	SetSoapFault("UserMenu",STR0036)	//"Funcao padrao nao encontrada"
EndIf

RestArea(aArea)
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD BrwMentors WSRECEIVE UserCode, MentorName WSSEND ListOfMentor WSSERVICE RHEmployedCurriculum
Local nPos := 1

dbSelectArea("RD0")
dbSetOrder(2)

If MentorName != ""
	dbSeek(xFilial("RD0")+Upper(MentorName))
	::ListOfMentor := {}

	While !Eof() .And. (RD0_FILIAL == xFilial("RD0")) .And. Subs(RD0->RD0_NOME,1,len(MentorName)) == Upper(MentorName)

		aAdd(::ListOfMentor, wsClassNew("Mentors"))
		::ListOfMentor[nPos]:MentorID 	:= RD0->RD0_CODIGO
		if ! Empty(Posicione("SRA",1,buscaSRA(RD0->RD0_CODIGO), "RA_NOMECMP"))
			::ListOfMentor[nPos]:MentorName := SRA->RA_NOMECMP  
		Else
			::ListOfMentor[nPos]:MentorName	:= RD0->RD0_NOME
		EndIf
		nPos ++

		RD0->(dbSkip())
	EndDo
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVerFil   ºAutor  ³Luis Artuso         º Data ³  14/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica qual filial sera utilizada para busca nas tabelas:º±±
±±º          ³ RBN e SQC.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVerFil(cFilFunc , cAlias , aRet)
Local lFilSRA	:= .F. 
DEFAULT	aRet	:=	{}

lFilSRA	:= !EMPTY(aRet[3])

IF (lFilSRA)
	cFilFunc	:=  aRet[3]//SRA->RA_FILIAL
Else
	cFilFunc	:=	xFilial(cAlias)
EndIf

Return(cFilFunc)
