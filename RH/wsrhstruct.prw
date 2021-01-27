#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSRHSTRUC ³ Autor ³Emerson Grassi Rocha   ³ Data ³31/07/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estruturas utilizadas nos Web Services de RH                 ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Web Service                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ FNC  ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Allyson M.    |20/06/11|13746/|Inclusao dos campos referente primeiro e  ³±±
±±³              |        |	 2011|segundo nome e sobrenome do candidato.    ³±±
±±³Emerson Campos|10/09/12|REQ168|Inclusao dos campos referente gerenciamen-³±±
±±³              |        |	  /01|to da avaliação de pré-teste das vagas    ³±±
±±³Emerson Campos|18/10/12|REQ166|Inclusao dos campos referente gerenciamen-³±±
±±³              |        |	  /01|to do processo seletivo                   ³±±
±±³Fabio G.      ³27/11/13³THXFVH|Inclusao da Variavel VacancyFil p/ Identi-³±±
±±³              ³        ³      |ficar a Filial das Vagas Apresentadas.    ³±±
±±³Emerson Campos|18/10/12|  PROJ|Inclusao dos campos referente controle de-³±±
±±³              |        |297701|obrigatoriedade e visual do cad curriculo ³±±
±±³Emerson Campos|23/05/14|TQETRU|Inclusao do campo Tipo de currículo       ³±±
±±|M. Silveira   |08/06/17|DRHPON|Ajustes p/ incluir a descricao da filial  ³±±
±±|              |        |TP-812|da vaga no portal.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da estruturas utilizadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Selecao de Vaga para visualizacao.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT VacancyChoice
	WSDATA VacancyCode              AS String  						//Codigo da Vaga
	WSDATA VacancyFil				AS String  OPTIONAL             //Filial
	WSDATA VacancyDescriptionFil 	AS String  OPTIONAL        		//Descricao da Filial

	WSDATA OpenPositionDescription	AS String						//Descricao da Vaga
	WSDATA Profile			AS String						//Perfil do Usuario (Responsavel / Participanter)	
	WSDATA OpeningDate		AS Date OPTIONAL				//Data Abertura
	WSDATA VacancyType		AS String Optional				//Tipo [1=Int/Ext 2=Interna 3=Externa]
	WSDATA AvaiableVacancies	AS Integer OPTIONAL				//Vagas disponiveis
	WSDATA NumberClosedVacancies	AS Integer OPTIONAL				//Vagas fechadas
	WSDATA UserFields               AS Array Of UserField  OPTIONAL //Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao da Vaga selecionada.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WSSTRUCT VacancyView
	WSDATA VacancyCode                  AS String  							//Codigo da Vaga
	WSDATA VacancyFil			   		AS String OPTIONAL              	//Filial	
	WSDATA VacancyDescriptionFil        AS String OPTIONAL              	//Descricao da Filial
	WSDATA OpenPositionDescription		AS String					     	//Descricao da Vaga
	WSDATA AreaCode						AS String OPTIONAL 					//Codigo da Area
	WSDATA AreaDescription				AS String OPTIONAL 					//Descricao da Area
	WSDATA CostCenterCode				AS String OPTIONAL 					//Centro de Custos
	WSDATA CostCenterDescription		AS String OPTIONAL 					//Descricao C.Custos
	WSDATA FunctionCode					AS String OPTIONAL					//Codigo Funcao
	WSDATA FunctionDescription			AS String OPTIONAL					//Descricao Funcao
	WSDATA NumberVacancies				AS Integer OPTIONAL					//Numero de Vagas
	WSDATA NumberClosedVacancies		AS Integer OPTIONAL					//Vagas fechadas
	WSDATA AvaiableVacancies			AS Integer OPTIONAL					//Vagas disponiveis
	WSDATA Petitioner					AS String OPTIONAL					//Solicitante
	WSDATA TermVacancy					AS Integer OPTIONAL					//Prazo
	WSDATA OpeningDate					AS Date OPTIONAL					//Data Abertura
	WSDATA PositionCode                 AS String OPTIONAL  				//Codigo do Cargo
	WSDATA PositionDescription          AS String OPTIONAL  				//Descricao do Cargo
	WSDATA PositionDetailedDescription  AS String OPTIONAL					//Descricao Detalhada do Cargo
	WSDATA ProfileDetailedDescription 	AS String OPTIONAL					//Descricao Detalhada sobre o perfil da vaga
	WSDATA UserFields                   AS Array Of UserField   OPTIONAL 	//Campos usuario
	WSDATA Test							AS String Optional					//Cod da avaliação
	WSDATA TestDescription				AS String Optional					//Descrição da avaliação
	WSDATA Point						AS Integer OPTIONAL					//Pontos da Avaliação
	WSDATA AutoFailure					AS String Optional					//Reprovação automatica [1=Sim 2=Não]
	WSDATA ApprovalMessage				AS String Optional					//Cod. Mensagem de aprovação
	WSDATA ApprovalMessageDescription	AS String Optional					//Descrição da Mensagem de aprovação
	WSDATA DisapprovalMessage 			AS String Optional					//Cod. Mensagem de reprovação
	WSDATA DisapprovalMessageDescription AS String Optional					//Descrição da Mensagem de reprovação
	WSDATA Reinscription				AS String Optional					//Reinscrição [1=Sim 2=Não]
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao dos Fatores do Cargo.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT FactorsView
	WSDATA GroupCode 					AS String  						// Grupo
	WSDATA GroupDescription 			AS String						// Descricao do Grupo
	WSDATA PositionCode					AS String						// Cargo
	WSDATA PositionDescription			AS String						// Descricao do Cargo
	WSDATA FactorCode                  	AS String  						// Codigo do Fator
	WSDATA FactorDescription			AS String 						// Descricao do Fator
	WSDATA DegreeCode					AS String 						// Grau do Fator
	WSDATA DegreeDescription			AS String 						// Descricao da Graduacao do Fator
	WSDATA FactorScore					AS Float OPTIONAL				// Pontos
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Habilidades do Cargo.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT HabilityView
	WSDATA CompetenceCode 				AS String OPTIONAL				// Codigo da Competencia
	WSDATA CompetenceDescription		AS String OPTIONAL				// Descricao da Competencia
	WSDATA CompetenceItemCode			AS String OPTIONAL				// Item de Competencia
	WSDATA CompetenceItemDescription	AS String OPTIONAL				// Descricao Item Competencia
	WSDATA HabilityCode	  				AS String 						// Habilidade
	WSDATA HabilityDescription			AS String 						// Descricao de Habilidades
	WSDATA ScaleCode		  			AS String OPTIONAL				// Escala
	WSDATA ScaleDescription  			AS String OPTIONAL				// Descricao da Escala
	WSDATA ScaleItemCode				AS String OPTIONAL				// Item Escala
	WSDATA ScaleItemDescription			AS String OPTIONAL				// Descricao Item Escala
	WSDATA ScaleItemValue				AS Integer OPTIONAL				// Valor do Item Escala
	WSDATA ImportanceLevelCode			AS String OPTIONAL				// Grau Importancia
	WSDATA ImportanceLevelDescription	AS String OPTIONAL				// Descricao Grau Importancia
	WSDATA ImportLevelItemCode			AS String OPTIONAL				// Item Grau Importancia
	WSDATA ImportLevelItemDescription	AS String OPTIONAL				// Descricao Grau Importancia
	WSDATA ImportLevelItemValue			AS Integer OPTIONAL				// Valor do Grau Importancia
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao do Curriculo		                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Curriculum1
	WSDATA Branch	 					AS String OPTIONAL					//Filial
	WSDATA Curriculum 					AS String  							//Curriculo
	WSDATA AreaCode						AS String OPTIONAL					//Area
	WSDATA Name 						AS String							//Nome do Candidato
	WSDATA FirstName 					AS String OPTIONAL					//Primeiro nome do Candidato
	WSDATA SecondName					AS String OPTIONAL					//Segundo Nome do Candidato
	WSDATA FirstSurname 				AS String OPTIONAL					//Primeiro Sobrenome do Candidato
	WSDATA SecondSurname				AS String OPTIONAL					//Segundo Nome do Candidato			
	WSDATA Address						AS String 							//Endereco
	WSDATA AddressComplement			AS String OPTIONAL					//Complem
	WSDATA Zone							AS String OPTIONAL					//Bairro
	WSDATA District						AS String OPTIONAL					//Municip
	WSDATA State						AS String OPTIONAL					//Estado
	WSDATA ZipCode						AS String OPTIONAL					//Cep
	WSDATA Phone						AS String OPTIONAL					//Fone
	WSDATA Id							AS String OPTIONAL					//RG
	WSDATA Cpf							AS String OPTIONAL					//CPF
	WSDATA EmployBookNr					AS String OPTIONAL					//Num CP
	WSDATA EmployBookSr					AS String OPTIONAL					//Serie CP
	WSDATA EmployBookState				AS String OPTIONAL					//UF CP
	WSDATA DrivingLicense				AS String OPTIONAL 					//Habilitacao
	WSDATA ReservistCard				AS String OPTIONAL 					//Reservista
	WSDATA VotingCard					AS String OPTIONAL					//Titulo Eleitor
	WSDATA ElectoralDistrict			AS String OPTIONAL					//Zona Eleitoral
	WSDATA FathersName					AS String OPTIONAL					//Pai
	WSDATA MothersName					AS String OPTIONAL 					//Mae
	WSDATA Gender						AS String OPTIONAL					//Sexo
	WSDATA MaritalStatus				AS String OPTIONAL					//Estado Civil
	WSDATA Origin						AS String OPTIONAL 					//Naturalidade - UF
	WSDATA CodCityOri					AS String OPTIONAL 					//Naturalidade - Código Municipio
	WSDATA Nationality					AS String OPTIONAL					//Nacionalidade
	WSDATA ArrivalYear					AS String OPTIONAL					//Ano de Chegada
	WSDATA DateofBirth					AS Date   OPTIONAL					//Data de Nascimento
	WSDATA RegisterDate					AS Date   OPTIONAL					//Data de Cadastro
	WSDATA PositonAimed					AS String OPTIONAL					//Cargo pretendido
	WSDATA LastSalary					AS Float  OPTIONAL					//Ultimo Salario
	WSDATA ExpectedSalary				AS Float  OPTIONAL					//Pretensao Salarial
	WSDATA Analisys						AS String OPTIONAL 					//Analise
	WSDATA Pis							AS String OPTIONAL					//Pis
	WSDATA Experience					AS String OPTIONAL					//Experiencia
	WSDATA Designation					AS String OPTIONAL					//Indicacao
	WSDATA TestGrade					AS Float  OPTIONAL					//Nota
	WSDATA CurriculumStatus				AS String OPTIONAL					//Situac
	WSDATA CostCenterCode				AS String OPTIONAL					//Centro de Custos
	WSDATA MeansSent					AS String OPTIONAL 					//Meio Enviado
	WSDATA TestDate						AS Date   OPTIONAL					//Data de Teste
	WSDATA WorkedTime					AS Float  OPTIONAL					//Tempo de Trabalho
	WSDATA ExperienceTime				AS Float  OPTIONAL					//Tempo de Experiencia na Area
	WSDATA ApplicantGroup				AS String OPTIONAL					//Grupo do Cargo
	WSDATA EmployeeBranch				AS String OPTIONAL					//Filial (Quando funcionario)
	WSDATA EmployeeRegistration			AS String OPTIONAL					//Matricula (Quando funcionario)

	WSDATA Email						AS String OPTIONAL					//Email
	WSDATA MobilePhone					AS String OPTIONAL					//Celular
	WSDATA BusinessPhone	       		AS String OPTIONAL					//Fone Comercial
	WSDATA PassWord		       			AS String OPTIONAL					//Senha

	WSDATA JobAbroad		       		AS String OPTIONAL					//Trabalhar no Exterior
	WSDATA Partner		       			AS String OPTIONAL					//Trabalha em Cliente/Parceiro
	WSDATA TypeCurriculum	       		AS String OPTIONAL					//Tipo de Curriculo
	WSDATA HandCapped		       		AS String OPTIONAL					//Deficiente fisico
	WSDATA HandCappedDesc	       		AS String OPTIONAL					//Deficiente fisico
	WSDATA NumberOfChildren	       		AS Integer OPTIONAL					//Numero de filhos
	WSDATA Hierarchical	       			AS String OPTIONAL					//Nivel Hierarquico
	WSDATA Font	       					AS String OPTIONAL					//Fonte de Recrutamento

	WSDATA NumberChars					AS Integer OPTIONAL					//Indica se possui caracterisitcas para exibição
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  	//Campos usuario

	WSDATA ListOfHistory 				AS Array Of History OPTIONAL 		//Itens de Historico Profissional
	WSDATA ListOfCourses    			AS Array Of Courses OPTIONAL 		//Itens de Cursos do Candidato
	WSDATA ListOfQualification			AS Array Of Qualification OPTIONAL 	//Itens de Qualificacoes
	WSDATA ListOfEvaluation				AS Array Of Evaluation OPTIONAL 	//Itens de Avaliacoes
	WSDATA ListOfGraduation				AS Array of Graduation OPTIONAL		//Itens de Formacao
	WSDATA ListOfLanguages				AS Array of Languages OPTIONAL		//Itens de Idiomas
	WSDATA ListOfCertification			AS Array of Certification OPTIONAL	//Itens de Certificados
	WSDATA ListOfCharacters				AS Array of Characters OPTIONAL		//Itens de Caracteristicas do Candidato

	WSDATA UserFieldPers				AS Array of UserField OPTIONAL		//Campos usuario - Curriculo
	WSDATA UserFieldHist				AS Array of UserField OPTIONAL		//Campos usuario - Historico
	WSDATA UserFieldCour				AS Array of UserField OPTIONAL		//Campos usuario - Cursos
	WSDATA UserFieldGrad				AS Array of UserField OPTIONAL		//Campos usuario - Graduacao
	WSDATA UserFieldLang				AS Array of UserField OPTIONAL		//Campos usuario - Idiomas
	WSDATA UserFieldCert				AS Array of UserField OPTIONAL		//Campos usuario - Certificacao
    
	WSDATA AgendaCandidate				AS Array of StepsAgendaCandidate OPTIONAL	//Etapas da Agenda do Candidato
	
	WSDATA CargoCod	       			AS String OPTIONAL					//Codigo do Cargo
	WSDATA CargoDesc	       			AS String OPTIONAL					//Descricao do Cargo
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabelas auxiliares do Curriculo            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Curriculum2
	WSDATA ListOfArea   					AS Array of Area OPTIONAL						//Area
	WSDATA ListOfFederalUnit				As Array of FederalUnit OPTIONAL				//Uf
	WSDATA ListOfCity						As Array of City OPTIONAL						//Municipio (CC2)
	WSDATA ListOfMaritalStatus  			As Array of MaritalStatus OPTIONAL				//Estado civil
	WSDATA ListOfNationality				As Array of Nationality OPTIONAL				//Nacionalidade
	WSDATA ListOfGroup						As Array of Group OPTIONAL						//Grupo
	WSDATA ListOfCoursesCurriculum			As Array of CoursesCurriculum OPTIONAL			//Cursos do Curriculo (SQT)
	WSDATA ListOfGraduationCurriculum   	As Array of GraduationCurriculum OPTIONAL 		//Cursos de Graduacao
	WSDATA ListOfCertificationCurriculum   	As Array of CertificationCurriculum OPTIONAL 	//Cursos de Certificacao
	WSDATA ListOfLanguagesCurriculum   		As Array of LanguagesCurriculum OPTIONAL 		//Cursos de Idiomas
	WSDATA ListOfCoursesEmployee			As Array of CoursesEmployee OPTIONAL			//Cursos do Funcionario (RA1)
	WSDATA ListOfEntitity					As Array of Entitity OPTIONAL					//Entidade do Curso (Treinamento)
	WSDATA ListOfFactor						As Array of Factor OPTIONAL						//Fatores de Avaliacao
	WSDATA ListOfGender						As Array of Gender OPTIONAL						//Sexo
	WSDATA ListOfGrdGraduate				As Array of GrdGraduate OPTIONAL				//Nivel da Graduacao
	WSDATA ListOfGrdLanguage				As Array of GrdLanguage OPTIONAL				//Nivel do Idioma
	WSDATA ListOfJobAbroad					As Array of JobAbroad OPTIONAL					//Disponibilidade de Trabalho no Exterior
	WSDATA ListOfTypeCurriculum				As Array of TypeCurriculum OPTIONAL			//Tipo do currículo
	WSDATA ListOfHandCapped					As Array of HandCapped OPTIONAL					//Portador de Deficiencia fisica
	WSDATA ListOfPartner					As Array of Partner OPTIONAL					//Trabalha em parceiros/Clientes
	WSDATA ListOfHierarchical				As Array of Hierarchical OPTIONAL				//Nivel hierarquico
	WSDATA ListOfEntityCourses				As Array of Entity OPTIONAL						//Entidade de Ensino Cursos
	WSDATA ListOfEntityGraduation			As Array of Entity OPTIONAL						//Entidade de Ensino Graduacao
	WSDATA ListOfEntityCertification		As Array of Entity OPTIONAL						//Entidade de Ensino Certificacao
	WSDATA ListOfEntityLanguages			As Array of Entity OPTIONAL						//Entidade de Ensino Idiomas
	WSDATA ListOfFont						As Array of Font OPTIONAL						//Fontes de Recrutamento

ENDWSSTRUCT

WSSTRUCT Curriculum
	WSDATA Curric1						AS Curriculum1 OPTIONAL //Dados do Curriculo
	WSDATA Curric2						AS Curriculum2 OPTIONAL	//Dados tabelas Auxiliares
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Historico Profissional do Curriculo		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT History
	WSDATA AdmissionDate				AS Date   OPTIONAL		//Data de Admissao
	WSDATA DismissalDate				AS Date   OPTIONAL		//Data de Demissao
	WSDATA AreaCode						AS String OPTIONAL		//Area
	WSDATA AreaDescription				AS String OPTIONAL		//Area
	WSDATA Activity						AS String OPTIONAL		//Atividades
	WSDATA Company						AS String OPTIONAL		//Empresa
	WSDATA FunctionCode					AS String OPTIONAL		//Funcao
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Cursos do Curriculo						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Courses
	WSDATA EntityCode					AS String OPTIONAL		//Entidade
	WSDATA EntityDesc					AS String OPTIONAL		//Entidade	
	WSDATA GraduationDate				AS Date   OPTIONAL		//Data conclusao
	WSDATA CourseCode					AS String OPTIONAL		//Codigo do Curso
	WSDATA CourseDesc					AS String OPTIONAL		//Descricao do Curso
	WSDATA Education					AS String OPTIONAL		//Escolaridade
	WSDATA Type							AS String OPTIONAL		//Tipo do Curso
	WSDATA EmployCourse					AS String OPTIONAL		//Curso Funcionario
	WSDATA EmployDescCourse				AS String OPTIONAL		//Desc. Curso Funcionario
	WSDATA EmployEntity					AS String OPTIONAL		//Entidade Funcionario
	WSDATA EmployDescEntity				AS String OPTIONAL		//Desc. Entidade Funcionario
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Certificacoes do Curriculo				   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Certification
	WSDATA EntityCode					AS String OPTIONAL		//Entidade
	WSDATA EntityDesc					AS String OPTIONAL		//Entidade	
	WSDATA GraduationDate				AS Date   OPTIONAL		//Data conclusao
	WSDATA CourseCode					AS String OPTIONAL		//Codigo do Curso
	WSDATA CourseDesc					AS String OPTIONAL		//Descricao do Curso
	WSDATA Education					AS String OPTIONAL		//Escolaridade
	WSDATA Type							AS String OPTIONAL		//Tipo do Curso
	WSDATA EmployCourse					AS String OPTIONAL		//Curso Funcionario
	WSDATA EmployDescCourse				AS String OPTIONAL		//Desc. Curso Funcionario
	WSDATA EmployEntity					AS String OPTIONAL		//Entidade Funcionario
	WSDATA EmployDescEntity				AS String OPTIONAL		//Desc. Entidade Funcionario
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de caracteristicas do candidato     		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Characters
	WSDATA Code							AS String OPTIONAL		//Tipo da Característica
	WSDATA Question						AS String OPTIONAL		//Descrição da Característica
	WSDATA Type							AS String OPTIONAL		//Tipo de Característica	
	WSDATA Answer						AS String OPTIONAL		//Resposta Dissertativa
	WSDATA Choice						AS String OPTIONAL		//Alternativa(s) Escolhida(s)
	WSDATA ListOfCharOptions			AS Array Of CharOptions OPTIONAL		//Alternativas possíveis
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

WSSTRUCT CharOptions
	WSDATA Code	    	AS String OPTIONAL
	WSDATA Desc   		AS String OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Qualificacoes do Curriculo				   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Qualification
	WSDATA Group						AS String OPTIONAL		//Grupo
	WSDATA GroupDescr					AS String OPTIONAL		//Descricao do Grupo
	WSDATA Factor						AS String OPTIONAL		//Fator
	WSDATA FatorDescr					AS String OPTIONAL		//Descricao do Fator
	WSDATA Degree						AS String OPTIONAL		//Grau
	WSDATA DegreeDescr					AS String OPTIONAL		//Descricao do Grau
	WSDATA DateFactor					AS Date   OPTIONAL		//Data
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Avaliacoes do Curriculo					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Evaluation
	WSDATA Registration					AS String OPTIONAL		//Matricula func.
	WSDATA Evaluation					AS String OPTIONAL		//Avaliacao
	WSDATA DescEvaluation				AS String OPTIONAL		//Descricao do Teste
	WSDATA Subject						AS String OPTIONAL		//Topico
	WSDATA DescSubject					AS String OPTIONAL		//Descricao do Topico
	WSDATA Question						AS String OPTIONAL		//Questao
	WSDATA DescQuestion					AS String OPTIONAL		//Descricao da Questao
	WSDATA Alternative					AS String OPTIONAL		//Alternativa
	WSDATA DescAlternative				AS String OPTIONAL		//Descricao do Teste
	WSDATA Adjustment					AS Float  OPTIONAL		//Resultado %
	WSDATA DescAnswer					AS String OPTIONAL		//Resposta
	WSDATA Duration						AS String OPTIONAL		//Duracao
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Formacao do Curriculo					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Graduation
	WSDATA EntityCode					AS String OPTIONAL		//Entidade
	WSDATA EntityDesc					AS String OPTIONAL		//Entidade	
	WSDATA GraduationDate				AS Date   OPTIONAL				//Data conclusao
	WSDATA CourseCode					AS String OPTIONAL				//Codigo do Curso
	WSDATA CourseDesc					AS String OPTIONAL				//Descricao do Curso
	WSDATA Education					AS String OPTIONAL				//Escolaridade
	WSDATA Type							AS String OPTIONAL				//Tipo do Curso
	WSDATA Grade						AS String OPTIONAL				//Nivel da Formacao
	WSDATA EmployCourse					AS String OPTIONAL				//Curso Funcionario
	WSDATA EmployDescCourse				AS String OPTIONAL				//Desc. Curso Funcionario
	WSDATA EmployEntity					AS String OPTIONAL				//Entidade Funcionario
	WSDATA EmployDescEntity				AS String OPTIONAL				//Desc. Entidade Funcionario
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Idiomas do Curriculo					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Languages
	WSDATA EntityCode					AS String OPTIONAL		//Entidade
	WSDATA EntityDesc					AS String OPTIONAL		//Entidade	
	WSDATA GraduationDate				AS Date   OPTIONAL				//Data conclusao
	WSDATA CourseCode					AS String OPTIONAL				//Codigo do Curso
	WSDATA CourseDesc					AS String OPTIONAL				//Descricao do Curso
	WSDATA Education					AS String OPTIONAL				//Escolaridade
	WSDATA Type							AS String OPTIONAL				//Tipo do Curso
	WSDATA Grade						AS String OPTIONAL				//Nivel do Idioma
	WSDATA EmployCourse					AS String OPTIONAL				//Curso Funcionario
	WSDATA EmployDescCourse				AS String OPTIONAL				//Desc. Curso Funcionario
	WSDATA EmployEntity					AS String OPTIONAL				//Entidade Funcionario
	WSDATA EmployDescEntity				AS String OPTIONAL				//Desc. Entidade Funcionario
	WSDATA UserFields                   AS Array Of UserField OPTIONAL  // Campos usuario
ENDWSSTRUCT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Historico do Curriculo            						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricHistory
	WSDATA ListOfHistory   				AS Array of History OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Cursos do Curriculo	            						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricCourses
	WSDATA ListOfCourses   				AS Array of Courses OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Qualificacoes do Curriculo         						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricQualification
	WSDATA ListOfQualification			AS Array of Qualification OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Evaluation do Curriculo            						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricEvaluation
	WSDATA ListOfEvaluation   			AS Array of Evaluation OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Graduation do Curriculo            						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricGraduation
	WSDATA ListOfGraduation   			AS Array of Graduation OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Languages do Curriculo            						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricLanguages
	WSDATA ListOfLanguages   			AS Array of Languages OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Certification do Curriculo         						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricCertification
	WSDATA ListOfCertification   			AS Array of Certification OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Caracteristicas docandidato        						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CurricCharacters
	WSDATA ListOfCharacters   			AS Array of Characters OPTIONAL
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Areas							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Area
	WSDATA AreaCode						AS String OPTIONAL		//Codigo da Area
	WSDATA AreaDescription 				AS String OPTIONAL		//Descricao da Area
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de UF							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT FederalUnit
	WSDATA FederalUnitCode				AS String OPTIONAL		//Codigo da UF
	WSDATA FederalUnitDescription 		AS String OPTIONAL		//Descricao UF
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Municipio							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT City
	WSDATA CodCityOri				AS String OPTIONAL		//Codigo do Municipio
	WSDATA CityOri			 		AS String OPTIONAL		//Descricao do Municipio
	WSDATA UFOri			 		AS String OPTIONAL		//Descricao do Municipio
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Estado Civil					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT MaritalStatus
	WSDATA MaritalStatusCode			AS String OPTIONAL		//Codigo do Estado Civil
	WSDATA MaritalStatusDescription 	AS String OPTIONAL		//Descricao do Estado Civil
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Nacionalidades				   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Nationality
	WSDATA NationalityCode				AS String OPTIONAL		//Codigo da Nacionalidade
	WSDATA NationalityDescription 		AS String OPTIONAL		//Descricao da Nacionalidade
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Grupos						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Group
	WSDATA GroupCode					AS String OPTIONAL		//Codigo do Grupo
	WSDATA GroupDescription 			AS String OPTIONAL		//Descricao do Grupo
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Cursos de Curriculos			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CoursesCurriculum
	WSDATA CourseCurriculumCode			AS String OPTIONAL		//Codigo do Curso do Curriculo
	WSDATA CourseCurriculumDescription 	AS String OPTIONAL		//Descricao Curso do Curriculo
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Cursos de Formacao (Graduacao)   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT GraduationCurriculum
	WSDATA GraduationCurriculumCode			AS String OPTIONAL		//Codigo do Curso de Formacao
	WSDATA GraduationCurriculumDescription 	AS String OPTIONAL		//Descricao Curso de Formacao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Certificacoes					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CertificationCurriculum
	WSDATA CertificationCurriculumCode			AS String OPTIONAL		//Codigo do Curso de Certificacao
	WSDATA CertificationCurriculumDescription 	AS String OPTIONAL		//Descricao Curso de Certificacao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Certificacoes					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT LanguagesCurriculum
	WSDATA LanguagesCurriculumCode			AS String OPTIONAL		//Codigo do Curso de Idioma
	WSDATA LanguagesCurriculumDescription 	AS String OPTIONAL		//Descricao Curso de Idioma
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Cursos de Funcionarios		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT CoursesEmployee
	WSDATA CourseEmployeeCode			AS String OPTIONAL		//Codigo do Curso do Funcionario
	WSDATA CourseEmployeeDescription 	AS String OPTIONAL		//Descricao Curso do Funcionario
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Entidades	de Treinamento		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Entitity
	WSDATA EntitityCode					AS String OPTIONAL		//Codigo da Entidades de Treinamento
	WSDATA EntitityDescription 			AS String OPTIONAL		//Descricao da Entidades de Treinamento
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Fatores de Avaliacao			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Factor
	WSDATA FactorCode					AS String OPTIONAL		//Codigo do Fator de Avaliacao
	WSDATA FactorDescription 			AS String OPTIONAL		//Descricao do Fator de Avaliacao
	WSDATA DegreeCode					AS String OPTIONAL		//Codigo da Graduacao do Fator
	WSDATA DegreeDescription 			AS String OPTIONAL		//Descricao da Graduacao do Fator
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Sexo							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Gender
	WSDATA GenderCode					AS String OPTIONAL		//Codigo do Sexo
	WSDATA GenderDescription 			AS String OPTIONAL		//Descricao do Sexo
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Nivel de Graduacao			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT GrdGraduate
	WSDATA GradeCode					AS String OPTIONAL		//Codigo do Nivel da Graduacao
	WSDATA GradeDescription 			AS String OPTIONAL		//Descricao Nivel da Graduacao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Nivel de Idioma				   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT GrdLanguage
	WSDATA GradeCode					AS String OPTIONAL		//Codigo do Nivel do Idioma
	WSDATA GradeDescription 			AS String OPTIONAL		//Descricao Nivel do Idioma
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Dispon. de Trabalho no Exterior  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT JobAbroad
	WSDATA Code					AS String OPTIONAL		//Codigo
	WSDATA Description 			AS String OPTIONAL		//Descricao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Tipo de currículos               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT TypeCurriculum
	WSDATA Code					AS String OPTIONAL		//Codigo
	WSDATA Description 			AS String OPTIONAL		//Descricao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Portador de Deficiencia fisica   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT HandCapped
	WSDATA Code					AS String OPTIONAL		//Codigo
	WSDATA Description 			AS String OPTIONAL		//Descricao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Trabalha em parceiros/Clientes   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Partner
	WSDATA Code					AS String OPTIONAL		//Codigo
	WSDATA Description 			AS String OPTIONAL		//Descricao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Nivel hierarquico				   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Hierarchical
	WSDATA Code					AS String OPTIONAL		//Codigo
	WSDATA Description 			AS String OPTIONAL		//Descricao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Entidade de Ensino			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Entity
	WSDATA EntityCode		 			AS String OPTIONAL		//Codigo
	WSDATA EntityDescription 			AS String OPTIONAL		//Descricao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados para envio de senha por e-mail			  						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Pers
	WSDATA Email				As String 	//Email Candidato
	WSDATA Pass					As String	//Senha Candidato
	WSDATA EmailAccount			As String	//Conta de e-mail para envio
	WSDATA EmailPass			As String	//Senha de e-mail para envio
	WSDATA EmailServ			As String	//Servidor de e-mail para envio
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Fontes de Recrutamento		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT Font
	WSDATA Code					AS String OPTIONAL		//Codigo
	WSDATA Description 			AS String OPTIONAL		//Descricao
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Tipos de Testes SQQ   		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT TestTypes
	WSDATA Evaluation		  		AS String OPTIONAL		//QQ_TESTE	  		- Avaliacao
	WSDATA Description 		  		AS String OPTIONAL		//QQ_DESCRIC  		- Descricao
	WSDATA Item				  		AS String OPTIONAL		//QQ_ITEM	  		- Item
	WSDATA Question			  		AS String OPTIONAL		//QQ_QUESTAO  		- Questao
	WSDATA AreaCode			   		AS String OPTIONAL		//QQ_AREA	 		- Codigo da Area
 	WSDATA Subject			   		AS String OPTIONAL		//QQ_TOPICO	   		- Codigo do topico
  	WSDATA Duration					AS String OPTIONAL		//QQ_DURACAO   		- Duracao do teste
   	WSDATA EvalType			   		AS String OPTIONAL		//QQ_TIPO	  		- Tipo de Avaliacao
    WSDATA ContServ					AS String OPTIONAL		//QQ_SRVCNT	   		- Servidor de Conteudo    
	WSDATA ListOfQuestions          AS ARRAY of QuestionsTestTypes OPTIONAL     //Questoes
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Tabela de Questoes SQO   	        	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT QuestionsTestTypes
	WSDATA Question		   		AS String OPTIONAL		//QO_QUESTAO			- Cod. da questao
    WSDATA Description	   		AS String OPTIONAL		//QO_QUEST				- Descricao
    WSDATA AreaCode		   		AS String OPTIONAL		//QO_AREA				- Codigo da area
    WSDATA Subject		   		AS String OPTIONAL		//QO_TOPICO				- Codigo do topico
    WSDATA Points		   		AS String OPTIONAL		//QO_PONTOS				- Pontos da questao
    WSDATA Level				AS String OPTIONAL		//QO_NIVEL				- Nivel da questao
    WSDATA AnswerType 	   		AS String OPTIONAL		//QO_TIPOOBJ			- Tipo da resposta
    WSDATA Type					AS String OPTIONAL		//QO_TIPO  				- Tipo da utilizacao
    WSDATA QuestionDt	   		AS String OPTIONAL		//QO_DATA				- Data da questao
    WSDATA Active				AS String OPTIONAL		//QO_ATIVO 				- Questao ativa
    WSDATA Alternative			AS String OPTIONAL		//QO_ESCALA				- Alternativa escala
    WSDATA DetDescCd			AS String OPTIONAL		//QO_CODMEM				- Cod descricao detalhada
	WSDATA ListOfAlternative	AS ARRAY of AlternativeQuestions OPTIONAL		//Alternativas
ENDWSSTRUCT  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao das Tabelas SQP e RBL podendo ser utilizadao  ³
//³de acordo com a necessidade do WSSTRUCT Questions ou seja         	   ³
//³WSDATA Alternative em branco utuliza SQP, preenchido utiliza RBL	       ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT AlternativeQuestions
	WSDATA AreaCode		   		AS String OPTIONAL		//QP_AREA		   			- Cod da area
    WSDATA Subject		   		AS String OPTIONAL		//QP_TOPICO					- Codigo do topico
    WSDATA Code			   		AS String OPTIONAL		//RBL_ESCALA				- Codigo
    WSDATA Question		   		AS String OPTIONAL		//QP_QUESTAO 				- Questao
    WSDATA Alternative	   		AS String OPTIONAL		//QP_ALTERNA ou RBL_ITEM	- Cod alternativa / Item
    WSDATA Description	   		AS String OPTIONAL		//QP_DESCRIC ou RBL_DESCRI	- Descricao
    WSDATA Value		   		AS String OPTIONAL		//QP_PERCENT ou RBL_VALOR	- Percentual / Valor
    WSDATA resposta		   		AS String OPTIONAL		//
ENDWSSTRUCT
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura de Visualizacao de Avaliacoes                  			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT TEvaluationsData
	WSDATA ListOfEvaluation		AS Array Of EvaluationQuestions OPTIONAL 	//Itens de Avaliacoes
ENDWSSTRUCT

WSSTRUCT EvaluationQuestions
	WSDATA Curriculum			AS String OPTIONAL		//QR_CURRIC		-	Curriculo
	WSDATA VacancyCode			As String Optional		//QR_VAGA		-	Vaga
	WSDATA Evaluation			AS String OPTIONAL		//QR_TESTE		- 	Avaliacao
	WSDATA Subject				AS String OPTIONAL		//QR_TOPICO		-	Topico
	WSDATA Question				AS String OPTIONAL		//QR_QUESTAO	-	Questao
	WSDATA Alternative			AS String OPTIONAL		//QR_ALTERNA	-	Alternativa
	WSDATA Adjustment			AS Float  OPTIONAL		//QR_RESULTA	-	Resultado %
	WSDATA DescAnswer			AS String OPTIONAL		//QR_MRESPOS	-	Resposta
	WSDATA Duration				AS String OPTIONAL		//QR_DURACAO	-	Duracao
ENDWSSTRUCT

WSSTRUCT TScheduleData
	WSDATA ListOfRequest		AS Array Of TScheduleRequest 	OPTIONAL
	WSDATA PagesTotal			AS Integer						OPTIONAL
ENDWSSTRUCT

WSSTRUCT TScheduleRequest
	WSDATA VacancyCode					As String				OPTIONAL	//Codigo da Vaga
	WSDATA DescVacancy					As String				OPTIONAL	//Descricao da Vaga
	WSDATA DescProcess					AS String				OPTIONAL	//Descricao do processo seletivo            
	WSDATA DateScheduled				As String				OPTIONAL	//Data Agendada
	WSDATA TimeScheduled				As String				OPTIONAL	//Hora Agendada
	WSDATA ObsCand						As String				OPTIONAL	//Observacao do Candidato
	WSDATA SitEtapa						AS String				Optional    //Situação da etapa 
ENDWSSTRUCT

WSSTRUCT StepsAgendaCandidate
	WSDATA CodeStep						As String				OPTIONAL	//Codigo da etapa
	WSDATA DescStep						As String				OPTIONAL	//Descricao da etapa
	WSDATA Date							As String				OPTIONAL	//Data
	WSDATA Time							As String				OPTIONAL	//Hora
	WSDATA CodeEvaluationFinal			As String				OPTIONAL	//Cod resultado da avaliacao
	WSDATA DescEvaluationFinal			As String				OPTIONAL	//Descricao do resultado da avaliacao
	WSDATA EmployeeRegistration         AS String				OPTIONAL	//Matricula do Funcionario
	WSDATA NameEmployeeRegistration		AS String				OPTIONAL	//Nome do funcionario
	WSDATA StepSituation				AS String				OPTIONAL	//Situacao da etapa
	WSDATA ObservationCandidate			AS String				OPTIONAL	//Observacao para o candidato
	WSDATA ObservationEvaluator			AS String				OPTIONAL	//Observacao para o avaliador
	WSDATA CodeTest						AS String				OPTIONAL	//Codigo do teste
	WSDATA DescCodeTest					AS String				OPTIONAL	//Descricao do teste
	WSDATA EvaluationFinal				AS String				OPTIONAL	//Resultado do teste
	WSDATA EvaluationOk					AS String				OPTIONAL	//Se o teste foi realizado
ENDWSSTRUCT

WSSTRUCT Selects
	WSDATA SelectItens					As Array Of OptionSelect OPTIONAL	//Selects da tela do portal
ENDWSSTRUCT
	
WSSTRUCT OptionSelect
	WSDATA KeySelect					As String				OPTIONAL	//Chave do Select
	WSDATA DescSelect					As String				OPTIONAL	//Descricao do Select
ENDWSSTRUCT

WSSTRUCT TObjectList
	WSDATA Branch				As String
	WSDATA CodObj				As String
	WSDATA Object				As String
	WSDATA Description			As String
	WSDATA CodEnt				As String	
	WSDATA FilEnt				As String
ENDWSSTRUCT

WSSTRUCT TObjectBrowse
	WSDATA Itens				AS Array Of TObjectList	OPTIONAL
	WSDATA PagesTotal			AS Integer 				OPTIONAL
	WSDATA ExtPer				AS String				OPTIONAL
	WSDATA PathAnexo			As String				OPTIONAL
ENDWSSTRUCT

WSSTRUCT TObjectConfigField    

	WSDATA ConfigName 						AS String OPTIONAL			//Nome do Candidato
	WSDATA ConfigFirstName 					AS String OPTIONAL			//Primeiro nome do Candidato
	WSDATA ConfigSecondName					AS String OPTIONAL			//Segundo Nome do Candidato
	WSDATA ConfigFirstSurname 				AS String OPTIONAL			//Primeiro Sobrenome do Candidato
	WSDATA ConfigSecondSurname				AS String OPTIONAL			//Segundo Nome do Candidato			
	WSDATA ConfigAddress					AS String OPTIONAL			//Endereco
	WSDATA ConfigAddressComplement			AS String OPTIONAL			//Complem
	WSDATA ConfigZone						AS String OPTIONAL			//Bairro
	WSDATA ConfigDistrict					AS String OPTIONAL			//Municip
	WSDATA ConfigState						AS String OPTIONAL			//Estado
	WSDATA ConfigZipCode					AS String OPTIONAL			//Cep
	WSDATA ConfigPhone						AS String OPTIONAL			//Fone
	WSDATA ConfigId							AS String OPTIONAL			//RG
	WSDATA ConfigCpf						AS String OPTIONAL			//CPF
	WSDATA ConfigEmployBookNr				AS String OPTIONAL			//Num CP
	WSDATA ConfigEmployBookSr				AS String OPTIONAL			//Serie CP
	WSDATA ConfigGender						AS String OPTIONAL			//Sexo
	WSDATA ConfigMaritalStatus				AS String OPTIONAL			//Estado Civil
	WSDATA ConfigOrigin						AS String OPTIONAL 			//Naturalidade - UF
	WSDATA ConfigCodCityOri					AS String OPTIONAL 			//Naturalidade - Código Municipio
	WSDATA ConfigNationality				AS String OPTIONAL			//Nacionalidade
	WSDATA ConfigDateofBirth				AS String OPTIONAL			//Data de Nascimento
	WSDATA ConfigLastSalary					AS String OPTIONAL			//Ultimo Salario
	WSDATA ConfigEmail						AS String OPTIONAL			//Email
	WSDATA ConfigMobilePhone				AS String OPTIONAL			//Celular
	WSDATA ConfigPassWord		   			AS String OPTIONAL			//Senha
	WSDATA ConfigTypeCurriculum       		AS String OPTIONAL			//Tipo de Curriculo
	WSDATA ConfigHandCapped		       		AS String OPTIONAL			//Deficiente fisico 
	WSDATA ConfigNumberOfChildren			AS String OPTIONAL			//Numero de filhos 
	WSDATA ConfigPlaceCode					AS String OPTIONAL			//Código da Cargo
 
ENDWSSTRUCT

Function wsrhstruct()
Return
