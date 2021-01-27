#INCLUDE "WSORG010.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10
//WsClient_WsOrgStructure.prx


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSORG010  ³ Autor ³Tatiane Vieira Matias  ³ Data ³07.03.2008  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Web Service responsavel pela Arquitetura Organizacional      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ Requisito      ³  Motivo da Alteracao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Bruno Nunes   |        |M_RH001         |Unificacao V12                  ³±±
±±³Emerson Campos|30/04/14|TPKFN9          |Replica das alterações realizadas±±
±±³              |        |                |pela manutenção até dt 13/03/14 ³±±
±±³              |        |                |chamado TILFZV, changeset 212565³±±
±±³              |        |                |na P11.80                       ³±±
±±³Allyson M.    |25/06/14|TPSEC2          |Ajuste em GetStructure() quando ³±±
±±³              |        |                |tabela SQB nao e' compartilhada ³±±
±±³              |        |                |(TypeOrg = 0)                   ³±±
±±³Flavio C .    |11/08/14|                |Alterada a query na fEstrutDepto³±±
±±³              |        |                |para nao trazer todos os campos ³±±
±±³              |        |                |da tabela SRA                   ³±±
±±³Joao Balbino  |12/06/15|TSM699          |Alterada a tratamento na listagem±±
±±³              |        |                |dos funcionários para não duplicar±
±±³Renan Borges  |19/10/15|TTIBVT          |Ajuste para filtra solicitações ³±±
±±³              |        |                |com a filial do funcionário.    ³±±
±±³Matheus M.    |05/11/15|TTQAXT          |Tratamento para alteração       ³±±
±±³              |        |                |cadastral eSocial.              ³±±
±±³Matheus M.    |05/02/16|TUGXBB          |Tratamento no espaçamento da emp³±±
±±³              |        |                |resa utilizada.                 ³±±
±±³Allyson M.    |01/08/16|TVNQAR          |Ajuste na estrutura dos dados do³±±
±±³              |        |                |funcionario p/ carregar a data  ³±±
±±³              |        |                |de nascimento do funcionario    ³±±
±±³Eduardo K.    |03/08/16|TVFKXG          |Ajuste para filtrar funcionários³±±
±±³              |        |                |corretos.                       ³±±
±±³Esther Viveiro|30/08/16|     TVWNFA     |Ajuste em fBuscaChaveFuncionario³±±
±±³              |        |                |para passar filial do funcionario³±±
±±³              |        |                |ao chamar fEstrutDepto().       ³±±
±±³Renan Borges  |07/10/16|TVWVWI          |Ajuste ao utilizar Visão por    ³±±
±±³              |        |                | Departamento e realizar a soli-³±±
±±³              |        |                |tação para um membro da equipe, ³±±
±±³              |        |                |seja carregado o aprovador cor- ³±± 
±±³              |        |                |retamente, quando o responsável ³±± 
±±³              |        |                |pelo departamento estiver em um ³±± 
±±³              |        |                |departamento diferente ao do so-³±± 
±±³              |        |                |licitante. Conceito utilizado   ³±± 
±±³              |        |                |também para aumento de quadro e ³±± 
±±³              |        |                |novas contratações.             ³±± 
±±³Eduardo K.    |24/03/17|MPRIMESP-9361   |Ajuste p/ carregar corretamente ³±±
±±³              |        |                |funcionarios que possuem mult.  ³±±
±±³ 			 |		  |				   |vinculos e mesmo numero de mat. ³±±
±±³Matheus M.    |30/03/17|NOVO PORTAL RH  |Criação de API - APIGetStructure³±±
±±³              |        |                |para centralizar o método 	    ³±±
±±³ 			 |		  |				   |GetStructure em uma function que³±±
±±³ 			 |		  |				   |será acessada via RestFull/WSDL ³±±
±±³M. Silveira   |20/06/17|DRHPONTP-843    |Ajuste na funcao fEstrutDepto().³±±
±±³ 			 |		  |				   |p/ nao gerar o codigo QB_KEYINI ³±±
±±³ 			 |		  |				   |em duplicidade.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Arquitetura Organizacional                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT DataEmployee
	WSDATA EmployeeEmp		As String	OPTIONAL	//Empresa do funcionario
	WSDATA EmployeeFilial	As String				//Filial do funcionario
	WSDATA Registration		As String				//Codigo da matricula
	WSDATA ParticipantID	As String 	OPTIONAL
	WSDATA Name				As String				//Nome do funcionario
	WSDATA AdmissionDate	As String			    //Data de Admissao
	WSDATA BirthdayDate		As String			    //Data de Nascimento
	WSDATA Department		As String 	   			//Departamento do Funcionario
	WSDATA DescrDepartment  AS String  	OPTIONAL 	//Departamento
	WSDATA Item				As String	OPTIONAL	//Item
	WSDATA SupEmpresa    	As String  	OPTIONAL    //Filial do superior
	WSDATA SupFilial    	As String  	OPTIONAL    //Filial do superior
	WSDATA SupRegistration	As String  	OPTIONAL    //Matricula do superior
	WSDATA NameSup			As String 	OPTIONAL	//Nome do superior
	WSDATA LevelSup 		As Integer	OPTIONAL	//Nivel hierarquico do superior
	WSDATA CatFuncSup       As String   OPTIONAL    //categoria da funcao do superior
	WSDATA CatFuncDescSup   As String   OPTIONAL    //descricao da categoria da funcao do superior
	WSDATA KeyVision		As String	OPTIONAL	//Chave
	WSDATA LevelHierar		As Integer	OPTIONAL	//Nivel na hierarquia
	WSDATA TypeEmployee		As String	OPTIONAL	//Se é o proprio funcionário ("1") ou é um funcionario da equipe ("2")
	WSDATA email			As String	OPTIONAL	//email do funcionario
	WSDATA StatusEmployee 	As String	OPTIONAL	//Status do funcionario
	WSDATA PositionId	 	As String	OPTIONAL	//Codigo do cargo
	WSDATA Position		 	As String	OPTIONAL	//descricao do cargo
	WSDATA CostId 		 	As String	OPTIONAL	//Codigo do Centro de Custo
	WSDATA Cost 		 	As String	OPTIONAL	//Centro de Custo
	WSDATA FunctionId 	 	As String	OPTIONAL	//Codigo da funcao
	WSDATA FunctionDesc		As String	OPTIONAL	//Descricao Funcao
	WSDATA FunctionSubst    As Boolean  OPTIONAL    //Substituiacao para a Funcao
	WSDATA Salary			As Float	OPTIONAL	//Salario
	WSDATA Total            As Integer 	OPTIONAL    //Total de registros para paginacao
	WSDATA Situacao         As String  	OPTIONAL    //Codigo da Situacao do funcionario
	WSDATA DescSituacao     As String  	OPTIONAL    //Descricao da Situacao do funcionario
	WSDATA FilialDescr      As String  	OPTIONAL    //Descricao da Filial
	WSDATA CatFunc		   	As String  	OPTIONAL    //categoria da funcao
	WSDATA CatFuncDesc      As String  	OPTIONAL    //descricao da categoria da funcao
	WSDATA ResultConsolid	AS String	OPTIONAL	//Resultado do ranking consolidado
	WSDATA HoursMonth	    As String  	OPTIONAL    //Horas mensais
	WSDATA PossuiSolic      As Boolean 	OPTIONAL    //Possui Solicitacao para este funcionario
	WSDATA PossuiEquipe     As Boolean 	OPTIONAL    //Esse funcionario possui equipe?
	WSDATA DepartAprovador  As String 	OPTIONAL    //Departamento que o Superior está como aprovador 
	WSDATA Polity  		As String 	OPTIONAL    //Regime de contratação do funcionário
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Departamentos								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT DataDepartment
	WSDATA DepartmentEmp		As String				//Empresa do departamento
	WSDATA DepartmentFilial 	As String				//Filial do departamento
	WSDATA Department			As String  				//Departamento do Funcionario
	WSDATA DescrDepartment  	AS String  	OPTIONAL	//Departamento
	WSDATA KeyVision	    	AS String  	OPTIONAL	//Visao
	WSDATA TotalRegistros   	As Integer 	OPTIONAL 	//Total de registros para paginacao
	WSDATA PostoVis		 		As String	OPTIONAL	//Postos da Visão
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Postos					 				       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT DataPostos
	WSDATA PostoEmp		 	As String						//Empresa do posto
	WSDATA PostFilial			As String						//Filial do posto
	WSDATA Posto				As String 	   				    //Posto
	WSDATA CodDepto			As String 	   				    //Departamento
	WSDATA DescrDepto			AS String 			 		    //Descricao do Departamento
	WSDATA Tipo				AS String  			 			//tipo do posto
	WSDATA DescrTipo			AS String						//Descricao do Tipo
	WSDATA Qtd					AS Integer 			 			//quantidade
	WSDATA Ocupado			AS Integer 			 			//Qtd ocupada
	WSDATA CodCargo			AS String 			 		    //Codigo do Cargo
	WSDATA DescrCargo			AS String 			 		    //Descricao do Cargo
	WSDATA CodFuncao			AS String 			 		    //Codigo da funcao
	WSDATA DescrFuncao		AS String 			 		    //Descricao da funcao
	WSDATA CC					AS String 			 		    //Centro de Custo
	WSDATA DescrCC			AS String 			 		    //Descricao do Centro de Custo
	WSDATA TipoContrato		AS String 			 		    //Tipo Contrato
	WSDATA Salario			AS Float 			 			//Salario
	WSDATA CodStatus			AS String	OPTIONAL	 		//Status
	WSDATA Status				AS String	OPTIONAL	 		//Descrição Status
	WSDATA Ocupantes			AS Array Of TOcupantes OPTIONAL //Lista de Ocupantes do Posto
	WSDATA NovaContr    		AS String	OPTIONAL	 		//Gera nova contratação?
	WSDATA PossuiSolic      	AS Boolean OPTIONAL	     	//Possui Solicitacao para este posto?
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Postos                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT TOcupantes
	WSDATA Filial		    	AS String	OPTIONAL
	WSDATA Matricula	    	AS String	OPTIONAL
	WSDATA Nome			   	AS String	OPTIONAL
ENDWSSTRUCT

WSSTRUCT TDepartmentData
	WSDATA ListOfDepartment	AS Array Of DataDepartment	OPTIONAL
	WSDATA PagesTotal			AS Integer 					OPTIONAL
ENDWSSTRUCT

WSSTRUCT TPostData
	WSDATA ListOfPosts		AS Array Of DataPostos 		OPTIONAL
	WSDATA PagesTotal			AS Integer 					OPTIONAL
ENDWSSTRUCT

WSSTRUCT TEmployeeData
	WSDATA ListOfEmployee	AS Array Of DataEmployee	OPTIONAL
	WSDATA PagesTotal			AS Integer 					OPTIONAL
ENDWSSTRUCT

WSSTRUCT DataCargo
	WSDATA CargoId				As String				//Empresa do departamento
	WSDATA CargoDescr			As String				//Empresa do departamento
	WSDATA Salario 				As float				//Filial do departamento
	WSDATA CentroCustoId		As String  				//Departamento do Funcionario
	WSDATA CentroCusto			As String				//Empresa do departamento
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Arquitetura Organizacional                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE OrgStructure DESCRIPTION STR0001	   		//"Arquitetura Organizacional"
	
	WSDATA ParticipantId	as String OPTIONAL	//Codigo do Participante
	WSDATA TypeOrg			as String OPTIONAL	//Verifica se a Arquitetura Organizacional é por Posto ou Departamento
	WSDATA Vision			as String OPTIONAL	//Visao
	WSDATA EmployeeFil		as String OPTIONAL	//Filial do funcionario
	WSDATA Registration		as String OPTIONAL	//Codigo da matricula
	WSDATA EmployeeSolFil	as String OPTIONAL	//Filial do funcionario solicitante
	WSDATA RegistSolic		as String OPTIONAL	//Codigo da matricula do Solicitante
	WSDATA DepartmentID		as String OPTIONAL	//Codigo do Departamento
	WSDATA CompanyID		as String OPTIONAL	//Codigo do Departamento
	WSDATA PostID			as String OPTIONAL	//Codigo do Posto
	WSDATA Page				as Integer OPTIONAL	//Numero da Pagina, para paginacao
	WSDATA FilterField		as String OPTIONAL	//Campo para filtro
	WSDATA FilterValue		as String OPTIONAL	//Condicao de filtro das querys
	WSDATA EmployeeData		as TEmployeeData	//Estrutura Organizacional
	WSDATA DepartmentData	as TDepartmentData	//Departamentos
	WSDATA PostData			as TPostData		//Postos
	WSDATA RequestType      as String OPTIONAL	//Tipo de solicitação
	WSDATA PrtEmpFil		as String OPTIONAL	//Filial do funcionario
	WSDATA PrtOriLogin		as String 			//Login Original
	WSDATA PrtUnifLogin		as String 			//Novo login unificado RD0
	WSDATA PrtAcess			as String OPTIONAL	//Campo para acesso RD0
	WSDATA KeyVision	    as String OPTIONAL	//Visao
	WSDATA WsNull           as String			//NULL
	WSDATA FuncaoId         as String			//NULL
	WSDATA CargoData		as DataCargo
	WSDATA PostoVis	   		as String OPTIONAL	//Posto Visao
	WSDATA ControlPost 		as String OPTIONAL	//Controle de Ocupação de Posto na Visao
	WSDATA IDMENU			as String OPTIONAL // Propriedade para
	WSDATA SolEmployeeEmp	as String OPTIONAL // Empresa do Funcionario Solicitante 
	WSMETHOD GetStructure	DESCRIPTION STR0002 //"Metodo de listagem da estrutura organizacional"
	WSMETHOD GetEmployee	DESCRIPTION STR0006 //"Metodo que retorna informacoes sobre um funcionario"
	WSMETHOD GetDepartment	DESCRIPTION STR0009 //"Metodo que retorna os departamentos e seus postos"
	WSMETHOD GetPostos		DESCRIPTION STR0010 //"Metodo que retorna os os Postos de um departamento"
	WSMETHOD PutPrtULogin	DESCRIPTION STR0012 //"Metodo que atualiza o login unificado para o portal"
	WSMETHOD GetCargo		DESCRIPTION STR0018 //"Metodo que retorna o cargo de acordo com a funcao"
	
ENDWSSERVICE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetStructure	 ³ Autor ³Tatiane V. Matias   ³Data ³13.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem da estrutura organizacional                ³±±
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
WSMETHOD GetStructure WSRECEIVE ParticipantID, TypeOrg, Vision, EmployeeFil, Registration, Page, FilterValue, FilterField, RequestType, EmployeeSolFil, RegistSolic, DepartmentID, KeyVision,IDMENU,SolEmployeeEmp WSSEND EmployeeData WSSERVICE OrgStructure
	
	Local aEmployeeData			:= {}	
	Local aStructEmployee		:= {}
	Local lReturn 				:= .T.
	
	DEFAULT Self:ParticipantID  := ""
	DEFAULT Self:TypeOrg 		:= ""
	DEFAULT Self:Vision 	  	:= ""
	DEFAULT Self:EmployeeFil	:= ""
	DEFAULT Self:Registration	:= ""
	DEFAULT Self:Page 			:= 1
	DEFAULT Self:FilterField	:= ""
	DEFAULT Self:FilterValue	:= ""
	DEFAULT Self:RequestType 	:= ""
	DEFAULT Self:EmployeeSolFil := Self:EmployeeFil	
	DEFAULT Self:RegistSolic 	:= Self:Registration
	DEFAULT Self:DepartmentID	:= ""
	DEFAULT Self:KeyVision   	:= ""
	DEFAULT Self:IDMENU	   	:= ""
	DEFAULT Self:SolEmployeeEmp	:= cEmpAnt
	aEmployeeData := APIGetStructure(ParticipantID, TypeOrg, Vision, EmployeeFil, Registration, Page, FilterValue, FilterField, RequestType, EmployeeSolFil, RegistSolic, DepartmentID, KeyVision,IDMENU,SolEmployeeEmp)
	
	If Len(aEmployeeData) == 3 .And. aEmployeeData[1] == .F.
		SetSoapFault(aEmployeeData[2], aEmployeeData[3])
		lReturn	:= .F.
	Else
		::EmployeeData:ListOfEmployee := aClone(aEmployeeData[1]:ListOfEmployee)	
		::EmployeeData:PAGESTOTAL 	  := aEmployeeData[1]:Pagestotal
	EndIf

RETURN(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fEstrutDepto	 ³ Autor ³Tatiane V. Matias   ³Data ³11.04.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem da estrutura de departamentos qdo nao      ³±±
±±³          ³utilizado visao.                                              ³±±
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
Function fEstrutDepto( cFilMat, cNewDepto, lAltera, lFiltraFil )
	Local aArea      := GetArea()
	Local lNewReg    := .F.
	Local lCont      := .T.
	Local nChave     := 0
	Local nPos		 := 0
	Local cDeptos    := ""
	Local cAuxDeptos := ""
	Local cChave	 := ""
	Local cFilResp	 := "%'" + xFilial( "SQB", cFilMat ) + "'%"
	Local cNome      := ""
	Local cCatFunc   := ""
	Local cSQBAlias  := "SQB"
	Local cEmpSM0	 := SM0->M0_CODIGO
	Local aDeptos    := {}
	Local cSQB2		 := "QSQB2"
	Local cDeptoAnt	 := ""
	Local cWhere		:= "%%"
	DEFAULT cNewDepto	:= ""
	DEFAULT lAltera  	:= .F.
	DEFAULT lFiltraFil	:= .F.
	
	
	If lFiltraFil
		cWhere := "% AND SQB.QB_FILIAL = '"+xFilial("SQB")+"'  %"
	EndIf
	While lCont
		
		cSQBAlias := "QSQB"
		cDeptos   := if(Empty(cDeptos),"%(' ')%",cDeptos)
		
		BeginSql alias cSQBAlias
			SELECT SQB.*,RD0.*,RDZ.*,SRA.RA_NOMECMP, SRA.RA_NOME
			FROM %table:SQB% SQB
			INNER JOIN %table:SRA% SRA
			ON  SQB.QB_FILRESP  = SRA.RA_FILIAL  AND
			SQB.QB_MATRESP  = SRA.RA_MAT     AND
			SRA.%notDel%
			LEFT JOIN %table:RDZ% RDZ
			ON  RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
			RDZ.RDZ_FILIAL = %xfilial:RDZ%    AND
			RDZ.RDZ_EMPENT = %exp:cEmpSM0%    AND
			RDZ.%notdel%
			LEFT JOIN %table:RD0% RD0
			ON  RD0.RD0_CODIGO = RDZ.RDZ_CODRD0   AND
			RD0.RD0_FILIAL = %xfilial:RD0%    AND
			RD0.%notdel%
			WHERE SQB.QB_FILRESP <> ' '           AND
			SQB.QB_MATRESP <> ' '			  AND
			SQB.QB_DEPSUP IN %exp:cDeptos%  
			AND SQB.%notDel%
			%exp:cWhere% 
			ORDER BY SQB.R_E_C_N_O_
		EndSql
		
		cDeptos := ""
		nChave := 0
		
		While (cSQBAlias)->( !Eof() )
			cNome   := if(! Empty((cSQBAlias)->RA_NOMECMP),(cSQBAlias)->RA_NOMECMP,If(! Empty((cSQBAlias)->RD0_NOME),(cSQBAlias)->RD0_NOME, (cSQBAlias)->RA_NOME))
			cDeptoAnt := (cSQBAlias)->QB_DEPSUP
			// Verifica se o departamento tem departamentos abaixo
			BeginSQL alias cSQB2
				SELECT COUNT(SQB.QB_DEPTO) AS DEPTOS 
				FROM %table:SQB% SQB
				WHERE SQB.QB_DEPSUP = %exp:(cSQBAlias)->QB_DEPTO%
				AND SQB.%notdel%
				AND SQB.QB_FILIAL = %exp:(cSQBAlias)->QB_FILIAL%
			EndSQL
			
			If (cSQB2)->DEPTOS > 0
				cDeptos += "'" + Alltrim((cSQBAlias)->QB_DEPTO) + "',"
			EndIf
			
			(cSQB2)->(dbCloseArea())
			
			//Tratamento para nao gerar o campo QB_KEYINI em duplicidade ao adicionar um departamento na estrutura
			//Adiciona no array o departamento novo sem chave para garantir que ele pegara a ultima sequencia
			If( cNewDepto == (cSQBAlias)->QB_DEPTO .And. !Empty((cSQBAlias)->QB_DEPSUP) )
				lNewReg := .T.
			EndIf

			nChave++
			
			If (nPos := aScan(aDeptos,{|x| x[1] == (cSQBAlias)->QB_DEPSUP .And.  x[8] == (cSQBAlias)->QB_FILIAL})) > 0
				cChave := aDeptos[nPos][5]
			Else
				cChave := ""
			EndIf
				
			If (cSQBAlias)->(FieldPos("QB_KEYINI")) > 0
				If Empty((cSQBAlias)->QB_KEYINI) .OR. lAltera
					cChave := cChave + StrZero(nChave, 3)
				Else 
					cChave := Alltrim((cSQBAlias)->QB_KEYINI) 
				EndIf 
			Else
				cChave = cChave + StrZero(nChave, 3)	
			EndIf
				
			//Verifica se haverá duplicidade de keyini.
			While (nPos := aScan(aDeptos,{|x| x[5] == cChave + StrZero(nChave, 3) })) > 0 
				nChave++
				cChave := cChave + StrZero(nChave, 3)
			EndDo
				
			aAdd(aDeptos, {	(cSQBAlias)->QB_DEPTO,;
				(cSQBAlias)->QB_FILRESP,;
				(cSQBAlias)->QB_MATRESP,;
				cNome,;
				(cChave),;
				(cSQBAlias)->QB_DESCRIC,;
				cCatFunc,;
				(cSQBAlias)->QB_FILIAL} )
			(cSQBAlias)->( dbSkip() )
			If cDeptoAnt <> (cSQBAlias)->QB_DEPSUP
				nChave := 0
			EndIf
		EndDo
		If lNewReg
			If (nPos := aScan(aDeptos,{|x| x[1] == cNewDepto })) > 0
				cChave  := aDeptos[nPos][5]
				cChave  := SubStr( cChave, 1, Len(cChave)-3 ) + StrZero(nChave, 3)
				aDeptos[nPos][5] := cChave
			EndIf
			lNewReg := .F.
		EndIf		
		If !(Empty(cDeptos))
			cDeptos := "%(" + substr(cDeptos, 1, len(cDeptos)-1)+ ")%"
		Else
			lCont := .F.
		EndIf
		(cSQBAlias)->( dbCloseArea() )
	EndDo
	RestArea(aArea)
Return(aDeptos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fBuscaSuperior ³ Autor ³Tatiane V. Matias   ³Data ³11.04.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao que ira retornar as informacoes do superior conforme   ³±±
±±³          ³parametros passados.                                          ³±±
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
Function fBuscaSuperior(cFilFun, cMatFun, cDepto, aDeptos, cTipoOrg, cVisao, cEmpFun, cFilSol, cMatSol,cEmpResp)

	Local lCont        	:= .T.
	Local nSupLevel	   	:= 0
	Local nPos         	:= 0
	Local cSupFilial    := ""
	Local cSupMat		:= ""
	Local cSupNome     	:= ""
	Local cSupCateg    	:= ""
	Local cChave       	:= ""
	Local cTree        	:= ""
	LOcal cEmpIde		:= ""
	LOcal cSra			:= ""
	LOcal cSqb			:= ""
	LOcal cRd0			:= ""	
	LOcal cRdz			:= ""
	Local cSupAlias    	:= "QSUP"
	Local cAuxAlias    	:= "QAUX"	
	Local cAux1Alias    := "QAU1"
	Local cEmpAlias		:= "QEMP"
	Local cAliEmpSup	:= "QESUP"
	Local cEmpSM0	    := SM0->M0_CODIGO
	Local aSuperior    	:= {}
	Local aSupRD4		:= {}
	Local aArea1 		:= ""
	Local nPosSup		:= 0
	Local cDeptoApr	:= ""
	Local cEmpSQB	:= ""
	Local cEmpSRA	:= ""
	Local lQBEmpResp:= SQB->(ColumnPos("QB_EMPRESP")) > 0
	
	Local aArea 		:= getArea()
	DEFAULT cFilFun    	:= ""
	DEFAULT cMatFun    	:= ""
	DEFAULT cDepto     	:= ""
	DEFAULT cVisao     	:= ""
	DEFAULT cEmpFun		:= cEmpAnt
	DEFAULT cFilSol    	:= cFilFun
	DEFAULT cMatSol    	:= cMatFun	
	DEFAULT cEmpResp	:= ""
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Departamento (sem visao)                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipoOrg == "0"
		DEFAULT aDeptos := fEstrutDepto()
		
		cSupFilial 	:= ""
		cSupMat		:= ""
		cSupNome   	:= ""
		nSupLevel	:= 99
		cDeptoApr		:= ""
		If (nPos := aScan(aDeptos, {|x| x[1] == cDepto})) > 0
			cChave := aDeptos[nPos][5]
			
			lCont := .T.
			While lCont
				If (nPos := aScan(aDeptos, {|x| x[5] == cChave})) > 0	 
					If	!( aDeptos[nPos][2] == cFilSol .and. aDeptos[nPos][3] == cMatSol )				
						cSupFilial 	:= aDeptos[nPos][2]
						cSupMat		:= aDeptos[nPos][3]
						cSupNome	:= aDeptos[nPos][4]
						cSupCateg   := aDeptos[nPos][7]
						nSupLevel	:= (len(cChave)/3)-1
						cDeptoApr	:= aDeptos[nPos][1]
						lCont       := .F.
					Else
						cChave := substr(cChave,1,len(cChave)-3)
						cSupFilial 	:= "" 
						cSupMat		:= ""
						cSupNome	:= ""
	                    cSupCateg   := ""
						nSupLevel	:= 99
						cDeptoApr	:= ""
						//lCont       := .F.
					EndIf
				Else
  						lCont       := .F.
				EndIf
			EndDo
		EndIf
		
		aAdd( aSuperior, { cSupFilial,;
			cSupMat   ,;
			cSupNome  ,;
			nSupLevel ,;
			cChave    ,;
			cSupCateg,;
			cEmpFun,;
			cDeptoApr,;
			cEmpFun;
			})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posto                                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cTipoOrg == "1"
		cSqb	:= "%"+RetFullName("RCX",cEmpFun)+"%"
		BeginSql alias cSupAlias
			
			SELECT rd4.RD4_TREE
			FROM %EXP:cSqb% RCX
			INNER JOIN %table:RD4% RD4    ON RD4.RD4_CODIDE   = RCX.RCX_POSTO AND RCX.RCX_FILIAL = RD4.RD4_FILIDE
			WHERE
			RD4.RD4_FILIAL    = %xfilial:RD4%  AND
			RD4.RD4_CODIGO    = %exp:cVisao%   AND
			RCX.RCX_MATFUN    = %exp:cMatFun%  AND
			RCX.RCX_FILFUN    = %exp:cFilFun%  AND
			RCX.RCX_SUBST     = '2'            AND
			RCX.RCX_TIPOCU    = '1'            AND
			RD4.%notDel%                       AND
			RCX.%notDel%
			
		EndSql
		If !(cSupAlias)->(eof())
			cTree := (cSupAlias)->RD4_TREE
		EndIf
		(cSupAlias)->(dbCloseArea())
					
		dbselectarea("RD4")
		RD4->(dbsetorder(1))
		If RD4->(dbseek(xFilial("RD4")+cVisao+cTree))
			cEmpIde := RD4->RD4_EMPIDE				
		EndIf
		
		If !Empty(cEmpIde)			
			cSra	:= "%SRA"+cEmpIde+"0%"
			cSqb	:= "%RCX"+cEmpIde+"0%"
			cRdz	:= "%RDZ"+cEmpIde+"0%"
			cRd0	:= "%RD0"+cEmpIde+"0%"
		Else	
			cSra	:= "%"+RetFullName("SRA",cEmpFun)+"%"
			cSqb	:= "%"+RetFullName("RCX",cEmpFun)+"%"
			cRdz	:= "%"+RetFullName("RDZ",cEmpFun)+"%"
			cRd0	:= "%"+RetFullName("RD0",cEmpFun)+"%"
		EndIf
		
		
		BeginSql alias cSupAlias
			
			SELECT RD4_CHAVE,RD4_EMPIDE,RD4_CODIDE, RCX.RCX_FILFUN, RCX.RCX_MATFUN, SRA.RA_NOME, SRA.RA_NOMECMP, SRA.RA_CATFUNC, RD0.RD0_NOME
			FROM %Exp:cSqb% RCX
			INNER JOIN %table:RD4% RD4    ON RD4.RD4_CODIDE   = RCX.RCX_POSTO AND RCX.RCX_FILIAL = RD4.RD4_FILIDE
			INNER JOIN %Exp:cSRA% SRA    ON SRA.RA_FILIAL    = RCX.RCX_FILFUN AND
			SRA.RA_MAT       = RCX.RCX_MATFUN
			INNER JOIN %Exp:cRDZ% RDZ    ON RDZ.RDZ_CODENT   = SRA.RA_FILIAL || SRA.RA_MAT
			INNER JOIN %Exp:cRD0% RD0    ON RD0.RD0_CODIGO   = RDZ.RDZ_CODRD0
			WHERE RD0.RD0_FILIAL    = %xfilial:RD0%     AND
			RDZ.RDZ_EMPENT    = %exp:cEmpIde%     AND
			RDZ.RDZ_FILIAL    = %xfilial:RDZ%  AND
			SRA.RA_SITFOLH    <> 'D'           AND
			RD4.RD4_FILIAL    = %xfilial:RD4%  AND
			RD4.RD4_CODIGO    = %exp:cVisao%   AND
			RD4.RD4_ITEM      = %exp:cTree%   AND
			RCX.RCX_SUBST     = '2'            AND
			RCX.RCX_TIPOCU    = '1'            AND
			RD0.%notdel%						 AND
			RDZ.%notdel%						 AND
			SRA.%notdel%						 AND
			RD4.%notDel%                       AND
			RCX.%notDel%
			
		EndSql
		
		If (cSupAlias)->( !Eof() )
			aAdd( aSuperior, { (cSupAlias)->RCX_FILFUN,;
				(cSupAlias)->RCX_MATFUN   ,;
				if(! Empty((cSupAlias)->RA_NOMECMP),(cSupAlias)->RA_NOMECMP,If(! Empty((cSupAlias)->RD0_NOME),(cSupAlias)->RD0_NOME,(cSupAlias)->RA_NOME)),;
				(len(Alltrim((cSupAlias)->RD4_CHAVE))/3)-1,;
				(cSupAlias)->RD4_CHAVE,;
				If(!Empty((cSupAlias)->RA_NOME),(cSupAlias)->RA_CATFUNC,""),(cSupAlias)->RD4_EMPIDE,;
				(cSupAlias)->RD4_CODIDE,;
				(cSupAlias)->RD4_EMPIDE;
				})
		EndIf
		(cSupAlias)->( dbCloseArea() )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Departamento (com visao)                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cTipoOrg == "2"
		cEmpSQB := cEmpFun
		cSqb	:= "%"+RetFullName("SQB",cEmpSQB)+"%"

		If Empty(cEmpResp)
			If lQBEmpResp
				BeginSql alias cEmpAlias
					
					SELECT SQB.QB_EMPRESP, SQB.QB_FILRESP, SQB.QB_MATRESP
					FROM %Exp:cSqb% SQB
					WHERE SQB.QB_DEPTO   = %exp:cDepto%   AND
					SQB.QB_FILIAL  = %exp:xFilial("SQB", cFilFun)%  AND
					SQB.%notDel%
				EndSql
				
				If (cEmpAlias)->( !Eof() )
					cEmpResp := (cEmpAlias)->QB_EMPRESP
				EndIf
				(cEmpAlias)->( DbCloseArea() )
			EndIf
		EndIf
		
		If Empty(cEmpResp)
			cEmpResp := cEmpFun
		EndIf

		cSra	:= "%"+RetFullName("SRA",cEmpResp)+"%"
		cRdz	:= "%"+RetFullName("RDZ",cEmpResp)+"%"
		cRd0	:= "%"+RetFullName("RD0",cEmpResp)+"%"
		
		If lQBEmpResp
			BeginSql alias cSupAlias
				
				SELECT SQB.QB_EMPRESP, SQB.QB_FILRESP, SQB.QB_MATRESP, SRA.RA_NOME, SRA.RA_NOMECMP, SRA.RA_CATFUNC, RD0.RD0_NOME, RD4.RD4_TREE, RD4_CHAVE, RD4_EMPIDE, RD4_CODIDE
				FROM %Exp:cSqb% SQB
				INNER JOIN %Exp:cSra% SRA ON  SQB.QB_FILRESP  = SRA.RA_FILIAL  AND
				SQB.QB_MATRESP  = SRA.RA_MAT
				INNER JOIN %Exp:cRdz% RDZ ON  RDZ.RDZ_CODENT  = SRA.RA_FILIAL || SRA.RA_MAT
				INNER JOIN %Exp:cRd0% RD0 ON  RD0.RD0_CODIGO  = RDZ.RDZ_CODRD0
				INNER JOIN %table:RD4% RD4 ON RD4.RD4_CODIDE = SQB.QB_DEPTO and RD4_EMPIDE=%exp:cEmpFun%
				WHERE RD4.RD4_CODIGO = %exp:cVisao%   AND
				RD4.RD4_FILIAL = %xfilial:RD4%  AND
				RD0.RD0_FILIAL = %xfilial:RD0%  AND
				RDZ.RDZ_FILIAL = %xfilial:RDZ%  AND
				RDZ.RDZ_EMPENT = %exp:cEmpResp%  AND
				SQB.QB_DEPTO   = %exp:cDepto%   AND
				SQB.QB_FILIAL  = %exp:xFilial("SQB", cFilFun)%  AND
				RD4.%notDel%                 	  AND
				RD0.%notdel%					  AND
				RDZ.%notdel%  				  AND
				SRA.%notDel%					  AND
				SQB.%notDel%
			EndSql
		Else
			BeginSql alias cSupAlias
				
				SELECT SQB.QB_FILRESP, SQB.QB_MATRESP, SRA.RA_NOME, SRA.RA_NOMECMP, SRA.RA_CATFUNC, RD0.RD0_NOME, RD4.RD4_TREE, RD4_CHAVE, RD4_EMPIDE, RD4_CODIDE
				FROM %Exp:cSqb% SQB
				INNER JOIN %Exp:cSra% SRA ON  SQB.QB_FILRESP  = SRA.RA_FILIAL  AND
				SQB.QB_MATRESP  = SRA.RA_MAT
				INNER JOIN %Exp:cRdz% RDZ ON  RDZ.RDZ_CODENT  = SRA.RA_FILIAL || SRA.RA_MAT
				INNER JOIN %Exp:cRd0% RD0 ON  RD0.RD0_CODIGO  = RDZ.RDZ_CODRD0
				INNER JOIN %table:RD4% RD4 ON RD4.RD4_CODIDE = SQB.QB_DEPTO and RD4_EMPIDE=%exp:cEmpFun%
				WHERE RD4.RD4_CODIGO = %exp:cVisao%   AND
				RD4.RD4_FILIAL = %xfilial:RD4%  AND
				RD0.RD0_FILIAL = %xfilial:RD0%  AND
				RDZ.RDZ_FILIAL = %xfilial:RDZ%  AND
				RDZ.RDZ_EMPENT = %exp:cEmpResp%  AND
				SQB.QB_DEPTO   = %exp:cDepto%   AND
				SQB.QB_FILIAL  = %exp:xFilial("SQB", cFilFun)%  AND
				RD4.%notDel%                 	  AND
				RD0.%notdel%					  AND
				RDZ.%notdel%  				  AND
				SRA.%notDel%					  AND
				SQB.%notDel%
			EndSql
		EndIf
		
		If (cSupAlias)->( !Eof() )				
				aAdd( aSupRD4, { (cSupAlias)->QB_FILRESP,;
					(cSupAlias)->QB_MATRESP,;
					if(! Empty((cSupAlias)->RA_NOMECMP),(cSupAlias)->RA_NOMECMP,If(!Empty((cSupAlias)->RD0_NOME),(cSupAlias)->RD0_NOME,(cSupAlias)->RA_NOME)),;
					(len(Alltrim((cSupAlias)->RD4_CHAVE))/3)-1,;
					(cSupAlias)->RD4_CHAVE,;
					If(!Empty((cSupAlias)->RA_NOME),(cSupAlias)->RA_CATFUNC,""),cEmpResp,;
					cDepto,;
					IIf(lQBEmpResp,(cSupAlias)->QB_EMPRESP,(cSupAlias)->RD4_EMPIDE);
					})
				
				cTree := (cSupAlias)->RD4_TREE
				
				aArea1 := GetArea()
				dbselectarea("RD4")
				RD4->(dbsetorder(1))
				If RD4->(dbseek(xFilial("RD4")+cVisao+cTree))
					cEmpIde := RD4->RD4_EMPIDE				
				EndIf
				
				If !Empty(cEmpIde)			
					cSra	:= "%SRA"+cEmpIde+"0%"
					cSqb	:= "%SQB"+cEmpIde+"0%"
					cRdz	:= "%RDZ"+cEmpIde+"0%"
					cRd0	:= "%RD0"+cEmpIde+"0%"
				Else	
					cSra	:= "%"+RetFullName("SRA",cEmpFun)+"%"
					cSqb	:= "%"+RetFullName("SQB",cEmpFun)+"%"
					cRdz	:= "%"+RetFullName("RDZ",cEmpFun)+"%"
					cRd0	:= "%"+RetFullName("RD0",cEmpFun)+"%"
				EndIf
					
				RestArea(aArea1)
				lCont := .T.
				While lCont			
					cEmpSRA := ""					
					// Trabalha a hipotese do responsável pelo departamento pertencer a outro grupo de empresas
					If lQBEmpResp
						BeginSql alias cAliEmpSup
							SELECT RD4.RD4_CODIDE, RD4.RD4_EMPIDE, SQB.QB_EMPRESP
							FROM %table:RD4% RD4
							INNER JOIN %Exp:cSqb% SQB ON  SQB.QB_DEPTO = RD4.RD4_CODIDE AND
							SQB.QB_FILIAL  = RD4.RD4_FILIDE  AND
							SQB.%notDel%
							WHERE RD4.RD4_ITEM   = %exp:cTree%   AND
							RD4.RD4_CODIGO = %exp:cVisao% AND
							RD4.RD4_FILIAL = %xfilial:RD4% AND
							RD4.%notDel%
						EndSql
						
						If !(cAliEmpSup)->( Eof() )
							If !Empty((cAliEmpSup)->QB_EMPRESP) .And. (cAliEmpSup)->QB_EMPRESP <> (cAliEmpSup)->RD4_EMPIDE
								cEmpSRA	:= (cAliEmpSup)->QB_EMPRESP
								cSra	:= "%"+RetFullName("SRA",cEmpSRA)+"%"
								cRdz	:= "%"+RetFullName("RDZ",cEmpSRA)+"%"
								cRd0	:= "%"+RetFullName("RD0",cEmpSRA)+"%"
							EndIf
						EndIf
						
						(cAliEmpSup)->( DbCloseArea() )
					EndIf
					
					If Empty(cEmpSRA)
						cEmpSRA := cEmpIde
					EndIf
					
					If lQBEmpResp
						BeginSql alias cAuxAlias
							SELECT SRA.RA_FILIAL , SRA.RA_MAT, SRA.RA_NOME, SRA.RA_NOMECMP, SRA.RA_CATFUNC, RD0.RD0_NOME, RD4.RD4_CHAVE, RD4.RD4_TREE,RD4.RD4_EMPIDE, RD4.RD4_CODIDE, SQB.QB_EMPRESP
							FROM %table:RD4% RD4
							INNER JOIN %Exp:cSqb% SQB ON  SQB.QB_DEPTO   = RD4.RD4_CODIDE AND
							SQB.QB_FILIAL  = RD4.RD4_FILIDE  AND
							SQB.%notDel%
							INNER JOIN %Exp:cSra% SRA ON  SQB.QB_FILRESP = SRA.RA_FILIAL  AND
							SQB.QB_MATRESP = SRA.RA_MAT     AND
							SRA.%notDel%
							LEFT JOIN %Exp:cRdz% RDZ  ON  RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
							RDZ.RDZ_FILIAL = %xfilial:RDZ%  AND
							RDZ.RDZ_EMPENT = %exp:cEmpSRA%  AND
							RDZ.%notdel%
							LEFT JOIN %Exp:cRd0% RD0  ON  RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 AND
							RD0.RD0_FILIAL = %xfilial:RD0%  AND
							RD0.%notdel%
							WHERE RD4.RD4_ITEM   = %exp:cTree%   AND
							RD4.RD4_CODIGO = %exp:cVisao% AND
							RD4.RD4_FILIAL = %xfilial:RD4% AND
							RD4.%notDel%
						EndSql
					Else
						BeginSql alias cAuxAlias
							SELECT SRA.RA_FILIAL , SRA.RA_MAT, SRA.RA_NOME, SRA.RA_NOMECMP, SRA.RA_CATFUNC, RD0.RD0_NOME, RD4.RD4_CHAVE, RD4.RD4_TREE,RD4.RD4_EMPIDE, RD4.RD4_CODIDE
							FROM %table:RD4% RD4
							INNER JOIN %Exp:cSqb% SQB ON  SQB.QB_DEPTO   = RD4.RD4_CODIDE AND
							SQB.QB_FILIAL  = RD4.RD4_FILIDE  AND
							SQB.%notDel%
							INNER JOIN %Exp:cSra% SRA ON  SQB.QB_FILRESP = SRA.RA_FILIAL  AND
							SQB.QB_MATRESP = SRA.RA_MAT     AND
							SRA.%notDel%
							LEFT JOIN %Exp:cRdz% RDZ  ON  RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
							RDZ.RDZ_FILIAL = %xfilial:RDZ%  AND
							RDZ.RDZ_EMPENT = %exp:cEmpSRA%  AND
							RDZ.%notdel%
							LEFT JOIN %Exp:cRd0% RD0  ON  RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 AND
							RD0.RD0_FILIAL = %xfilial:RD0%  AND
							RD0.%notdel%
							WHERE RD4.RD4_ITEM   = %exp:cTree%   AND
							RD4.RD4_CODIGO = %exp:cVisao% AND
							RD4.RD4_FILIAL = %xfilial:RD4% AND
							RD4.%notDel%
						EndSql	
					EndIf

					If (cAuxAlias)->( Eof() )
						lCont := .F.
					Else
						aAdd( aSupRD4, { (cAuxAlias)->RA_FILIAL,;
							(cAuxAlias)->RA_MAT   ,;
							iIf(! Empty((cAuxAlias)->RA_NOMECMP),(cAuxAlias)->RA_NOMECMP,iIf(!Empty((cAuxAlias)->RD0_NOME),(cAuxAlias)->RD0_NOME,(cAuxAlias)->RA_NOME)),;
							(len(Alltrim((cAuxAlias)->RD4_CHAVE))/3)-1,;
							(cAuxAlias)->RD4_CHAVE,;
							iIf(!Empty((cAuxAlias)->RA_NOME),(cAuxAlias)->RA_CATFUNC,""),(cAuxAlias)->RD4_EMPIDE,;
							(cAuxAlias)->RD4_CODIDE,;
							IIf(lQBEmpResp,(cAuxAlias)->QB_EMPRESP,(cAuxAlias)->RD4_EMPIDE);
							})
						cTree := (cAuxAlias)->RD4_TREE
						(cAuxAlias)->( DbCloseArea() )
					EndIf
				EndDo
				(cAuxAlias)->( DbCloseArea() )
		EndIf
		(cSupAlias)->( dbCloseArea() )
		
		If Len(aSupRD4) > 0
			nPosSup := aScan(aSupRD4, {|x| x[1] == cFilSol .And. x[2] == cMatSol}) + 1
			While nPosSup <= Len(aSupRD4) .And. (aSupRD4[nPosSup][1] == cFilSol .AND. aSupRD4[nPosSup][2] == cMatSol)
				nPosSup++
			EndDo
			If nPosSup <= Len(aSupRD4)
				aadd(aSuperior,aSupRD4[nPosSup])
			EndIf
		EndIf
	EndIf
	RestArea(aArea)
Return(aSuperior)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fGetEmployee   ³ Autor ³Equipe RH           ³Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                              ³±±
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
Function fGetEmployee(cVisao, cChave)
	Local cHierarquia	:= Posicione("RDK", 1, xFilial("RDK")+cVisao, "RDK_HIERAR")
	Local cQuery		:= GetNextAlias()
	Local aReturn		:= {}
	Local aArea      	:= GetArea()
	Local lQuery		:= .F.
	
	If cHierarquia = "1"	//Deptos
		BEGINSQL ALIAS cQuery
			SELECT
			RCX.RCX_FILFUN,
			RCX.RCX_MATFUN
			FROM %table:RD4% RD4
			INNER JOIN %table:RCL% RCL
			ON RCL.RCL_DEPTO = RD4.RD4_CODIDE
			INNER JOIN %table:RCX% RCX
			ON RCL.RCL_POSTO = RCX.RCX_POSTO
			WHERE
			RD4.RD4_FILIAL = %xFilial:RD4% AND
			RD4.RD4_CODIGO = %exp:cVisao% AND
			RCX.RCX_FILIAL = %xFilial:RCX% AND
			RD4.RD4_CHAVE = %exp:cChave% AND
			RCX.RCX_SUBST  = '2' AND
			RCX.RCX_TIPOCU = '1' AND
			RCL.RCL_FILIAL = RD4.RD4_FILIDE AND
			RCX.%NotDel% AND
			RD4.%NotDel% AND
			RCL.%NotDel%
		ENDSQL
		lQuery := .T.
	ElseIf cHierarquia = "2"	//Postos
		BEGINSQL ALIAS cQuery
			SELECT
			RCX.RCX_FILFUN,
			RCX.RCX_MATFUN
			FROM %table:RD4% RD4
			INNER JOIN %table:RCX% RCX
			ON RD4.RD4_CODIDE = RCX.RCX_POSTO AND RCX.RCX_FILIAL = RD4.RD4_FILIDE
			WHERE
			RD4.RD4_CODIGO = %exp:cVisao% AND
			RD4.RD4_FILIAL = %xFilial:RD4% AND
			RD4.RD4_CHAVE = %exp:cChave% AND
			RCX.RCX_SUBST  = '2' AND
			RCX.RCX_TIPOCU = '1' AND
			RCX.%NotDel% AND
			RD4.%NotDel%
		ENDSQL
		lQuery := .T.
	EndIf
			
	If lQuery
		If !(cQuery)->(Eof())
			aReturn:= {(cQuery)->RCX_FILFUN, (cQuery)->RCX_MATFUN}
		EndIf
		
		(cQuery)->( dbCloseArea() )
		
		RestArea(aArea)
	Endif
Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    |fBuscaChaveFunc³ Autor ³Rogerio Ribeiro     ³Data ³11.04.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao que ira retornar a chave do funcionario em determinada ³±±
±±³          ³visao.                                                        ³±±
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
Function fBuscaChaveFuncionario(cFilFun, cMatFun, cVisao, cDepartment)
	Local aArea		:= GetArea()
	Local cRD4Alias	:= GetNextAlias()
	Local cChave	:= ""
	Local cFilRD4	:= ""
	Local cFilRDK	:= ""
	Local cFilSQB	:= ""
	Local cTypeOrg	:= ""
	Local aDeptos	:= {}
	Local cDepto	:= ""
	DEFAULT cDepartment := ""
	
	TipoOrg(@cTypeOrg, cVisao)
	
	If cTypeOrg == "0"
		//necessario passar a filial do Funcionario para correta carga da estrutura dos Deptos
		aDeptos	:= fEstrutDepto(cFilFun) 
		cDepto	:= FDesc("SRA", cMatFun, "SRA->RA_DEPTO", NIL, cFilFun, 1)
		
		If (nPos := aScan(aDeptos, {|x| x[1] == cDepto})) > 0
			cChave:= aDeptos[nPos][5]
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Postos                                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cTypeOrg == "1"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Selecionar dados do funcionario logado                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BeginSql alias cRD4Alias
			
			SELECT
			RD4.RD4_CHAVE
			FROM %table:RD4% RD4
			INNER JOIN %table:RCX% RCX
			ON RD4.RD4_CODIDE = RCX.RCX_POSTO AND RCX.RCX_FILIAL = RD4.RD4_FILIDE
			INNER JOIN %table:RDK% RDK
			ON RD4.RD4_FILIAL = RDK.RDK_FILIAL
			AND RD4.RD4_CODIGO = RDK.RDK_CODIGO 
			WHERE
			RDK.RDK_HIERAR = '2' AND
			RDK.RDK_TIPO   = '1' AND
			RD4.RD4_CODIGO = %exp:cVisao% AND
			RD4.RD4_FILIAL = %xfilial:RD4% AND
			RCX.RCX_FILFUN = %exp:cFilFun% AND
			RCX.RCX_MATFUN = %exp:cMatFun% AND
			RCX.RCX_SUBST  = '2' AND
			RCX.RCX_TIPOCU = '1' AND
			RDK.%notDel% AND
			RCX.%notDel% AND
			RD4.%notDel%
		EndSql
		
		
		If (cRD4Alias)->( !Eof() )
			cChave := (cRD4Alias)->RD4_CHAVE
		EndIf
		
		(cRD4Alias)->( DbCloseArea() )
	ElseIf cTypeOrg == "2"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Departamento (com visao)                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(cDepartment)
			cDepto	:= FDesc("SRA", cMatFun, "SRA->RA_DEPTO", NIL, cFilFun, 1)
		Else
			cDepto := cDepartment
		EndIf
		cFilRD4 :=  xFilial("RD4", cFilFun )
		cFilRDK :=  xFilial("RDK", cFilFun )
		cFilSQB :=  xFilial("SQB", cFilFun )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Selecionar dados do funcionario logado                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BeginSql alias cRD4Alias
			SELECT
			RD4.RD4_CHAVE
			FROM %Table:RD4% RD4
			INNER JOIN %Table:RDK% RDK
			ON RD4.RD4_CODIGO = RDK.RDK_CODIGO
			WHERE
			RD4.RD4_FILIAL = %exp:cFilRD4% AND
			RD4.RD4_FILIDE = %exp:cFilSQB% AND
			RD4.RD4_CODIDE = %exp:cDepto% AND
			RDK.RDK_FILIAL = %exp:cFilRDK% AND
			RDK.RDK_CODIGO = %exp:cVisao% AND
			RDK.RDK_HIERAR = '1' AND
			RDK.RDK_TIPO   = '1' AND
			RD4.%notDel% AND
			RDK.%notDel%
		EndSql
		
		If (cRD4Alias)->( !Eof() )
			cChave := (cRD4Alias)->RD4_CHAVE
		EndIf
		
		(cRD4Alias)->( DbCloseArea() )
	EndIf
	
	RestArea(aArea)
Return AllTrim(cChave)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetEmployee    ³ Autor ³Tatiane V. Matias   ³Data ³28.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo que retorna informacoes sobre determinado funcionario  ³±±
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
WSMETHOD GetEmployee WSRECEIVE ParticipantId, EmployeeFil, Registration, Vision WSSEND EmployeeData WSSERVICE OrgStructure
	Local nI		:= 0
	Local lRet		:= .T.
	Local aDados	:= {}
	Local aRet		:= {}
	Local aRetSup	:= {}
	
	DEFAULT Self:ParticipantId	:= ""
	DEFAULT Self:EmployeeFil	:= ""
	DEFAULT Self:Registration	:= ""
	DEFAULT Self:Vision		:= ""
	
	::EmployeeData:ListOfEmployee := {}
	
	If !Empty(Self:ParticipantID) .AND. Empty(Self:EmployeeFil) .AND. Empty(Self:Registration)
		If MatParticipant(SELF:ParticipantID, aRet, .T.)
			
			For nI := 1 to len(aRet)
				Self:EmployeeFil	:= aRet[nI,3]
				Self:Registration	:= aRet[nI,1]
				
				If fGetFunc(Self:EmployeeFil, Self:Registration, @aDados)
					AAdd(::EmployeeData:ListOfEmployee, WsClassNew('DataEmployee'))
					::EmployeeData:ListOfEmployee[nI]:EmployeeEmp		:= cEmpAnt
					::EmployeeData:ListOfEmployee[nI]:EmployeeFilial	:= Self:EmployeeFil
					::EmployeeData:ListOfEmployee[nI]:Registration		:= Self:Registration
					::EmployeeData:ListOfEmployee[nI]:ParticipantID		:= aDados[1][5]
					::EmployeeData:ListOfEmployee[nI]:Department		:= aDados[1][2]
					::EmployeeData:ListOfEmployee[nI]:AdmissionDate		:= aDados[1][1]
					::EmployeeData:ListOfEmployee[nI]:BirthdayDate		:= DTOC(SRA->RA_NASC)
					::EmployeeData:ListOfEmployee[nI]:DescrDepartment	:= fDesc('SQB',aDados[1][2],'SQB->QB_DESCRIC',,,1)
					::EmployeeData:ListOfEmployee[nI]:Name				:= AllTrim(aDados[1][3])
					::EmployeeData:ListOfEmployee[nI]:email				:= aDados[1][4]
					::EmployeeData:ListOfEmployee[nI]:Situacao			:= SRA->RA_SITFOLH
					::EmployeeData:ListOfEmployee[nI]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + SRA->RA_SITFOLH, "X5DESCRI()", NIL, SELF:EmployeeFil))
					::EmployeeData:ListOfEmployee[nI]:ResultConsolid		:= ''
					::EmployeeData:ListOfEmployee[nI]:Polity				:= SRA->RA_REGIME
												
					If !Empty(Self:Vision)
						aRetSup := fBuscaSuperior(Self:EmployeeFil, Self:Registration, SRA->RA_DEPTO, NIL, NIL, Self:Vision)
					Else
						aRetSup := {}
					EndIf
					
					If Len(aRetSup) > 0
						::EmployeeData:ListOfEmployee[nI]:SupFilial      	:= aRetSup[1][1]
						::EmployeeData:ListOfEmployee[nI]:SupRegistration	:= aRetSup[1][2]
						::EmployeeData:ListOfEmployee[nI]:NameSup      		:= aRetSup[1][3]
						::EmployeeData:ListOfEmployee[nI]:LevelSup      	:= aRetSup[1][4]
					Else
						::EmployeeData:ListOfEmployee[nI]:SupFilial      	:= ""
						::EmployeeData:ListOfEmployee[nI]:SupRegistration	:= ""
						::EmployeeData:ListOfEmployee[nI]:NameSup      		:= ""
						::EmployeeData:ListOfEmployee[nI]:LevelSup      	:= 99
					EndIf
				EndIf
			Next
		EndIf
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca Matricula selecionada pelo usuario                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If MatParticipant(SELF:ParticipantID, aRet, .T.)
			For nI := 1 to len(aRet)
				If ( Self:Registration == aRet[nI,1] .AND. Self:EmployeeFil == aRet[nI,3] )
					
					If fGetFunc(Self:EmployeeFil, Self:Registration, @aDados)
						AAdd(::EmployeeData:ListOfEmployee, WsClassNew('DataEmployee'))
						::EmployeeData:ListOfEmployee[1]:EmployeeEmp		:= cEmpAnt
						::EmployeeData:ListOfEmployee[1]:EmployeeFilial		:= Self:EmployeeFil
						::EmployeeData:ListOfEmployee[1]:Registration		:= Self:Registration
						::EmployeeData:ListOfEmployee[1]:ParticipantID		:= aDados[1][5]
						::EmployeeData:ListOfEmployee[1]:Department			:= aDados[1][2]
						::EmployeeData:ListOfEmployee[1]:AdmissionDate		:= aDados[1][1]
						::EmployeeData:ListOfEmployee[1]:BirthdayDate		:= DTOC(SRA->RA_NASC)
						::EmployeeData:ListOfEmployee[1]:DescrDepartment	:= fDesc('SQB',aDados[1][2],'SQB->QB_DESCRIC',,,1)
						::EmployeeData:ListOfEmployee[1]:Name				:= AllTrim(aDados[1][3])
						::EmployeeData:ListOfEmployee[1]:email				:= aDados[1][4]
						::EmployeeData:ListOfEmployee[1]:Situacao			:= SRA->RA_SITFOLH
						::EmployeeData:ListOfEmployee[1]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + SRA->RA_SITFOLH, "X5DESCRI()", NIL, SELF:EmployeeFil))
						::EmployeeData:ListOfEmployee[1]:ResultConsolid	:= ''
						::EmployeeData:ListOfEmployee[1]:Polity			:= SRA->RA_REGIME
						
						If !Empty(Self:Vision)
							aRetSup := fBuscaSuperior(Self:EmployeeFil, Self:Registration, SRA->RA_DEPTO, NIL, NIL, Self:Vision)
						Else
							aRetSup := {}
						EndIf
						
						If Len(aRetSup) > 0
							::EmployeeData:ListOfEmployee[1]:SupFilial      	:= aRetSup[1][1]
							::EmployeeData:ListOfEmployee[1]:SupRegistration	:= aRetSup[1][2]
							::EmployeeData:ListOfEmployee[1]:NameSup      		:= aRetSup[1][3]
							::EmployeeData:ListOfEmployee[1]:LevelSup      		:= aRetSup[1][4]
						Else
							::EmployeeData:ListOfEmployee[1]:SupFilial      	:= ""
							::EmployeeData:ListOfEmployee[1]:SupRegistration	:= ""
							::EmployeeData:ListOfEmployee[1]:NameSup      		:= ""
							::EmployeeData:ListOfEmployee[1]:LevelSup      		:= 99
						EndIf
					Else
						SetSoapFault("GetEmployee", PorEncode(STR0004))
						lRet := .F.
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	
	SRA->( DbCloseArea())
	RD0->( DbCloseArea())
	RDZ->( DbCloseArea())
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetDepartment  ³ Autor ³Flavio S. Correa    ³Data ³24.11.2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de listagem dos departamentos                          ³±±
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
WSMETHOD GetDepartment WSRECEIVE ParticipantID, Vision, FilterValue, Page, FilterField, ControlPost WSSEND DepartmentData WSSERVICE OrgStructure
	Local aArea			:= GetArea()
	Local aRet			:= {}
	Local lRet			:= .T.
	Local cItem			:= ""
	Local cChave		:= ""
	Local cLike			:= ""
	Local cTipoOrg		:= ""
	Local cTabela		:= ""
	Local cWhere		:= ""
	Local cAuxAlias 	:= "QRD4"
	Local cAuxAlias1 	:= "QSQB"
	Local cVision		:= ::Vision
	Local nI			:= 1
	Local nQtd			:= 0
	Local aDeptos		:= {}
	Local nPosIni   	:= 1
	Local cFiltroCod    := ""
	Local cFiltroDescr  := ""
	Local cFilResp		:= ""
	Local nX			:= 0
	Local cPostoVis		:= ""
	
	DEFAULT Self:Page		    := 1
	DEFAULT Self:FilterField := ""
	DEFAULT Self:FilterValue := ""
	DEFAULT Self:ControlPost := ""
	
	If Empty(::ParticipantID)
		SetSoapFault("GetStructure4",PorEncode(STR0004))	 //"Participante nao encontrado no cadastro de funcionários."
		Return(.F.)
	EndIf
	
	If Participant(::ParticipantID , aRet )
		If Len(aRet) > 0
			If TipoOrg(@cTipoOrg, cVision)
				If cTipoOrg != "0"
					If !ChaveRD4(cTipoOrg, aRet, cVision, @cItem, @cChave, @cLike)
						SetSoapFault("GetStructure5",PorEncode(STR0003))	 //"Visao não encontrada"
						Return(.F.)
					EndIf
				EndIf
			Else
				SetSoapFault("GetStructure6",PorEncode(STR0003))	 //"Visao não encontrada"
				Return(.F.)
			EndIf
		Else
			SetSoapFault("GetStructure7",PorEncode(STR0004))	 //"Participante nao encontrado no cadastro de funcionários."
			Return(.F.)
		EndIf
	Else
		SetSoapFault("GetStructure8",PorEncode(STR0004))	 //"Participante nao encontrado no cadastro de funcionários."
		Return(.F.)
	EndIf
	
	cWhere := "%"
	If !Empty(::FilterValue) .AND. !Empty(::FilterField)
		If(::FilterField == "1")
			cWhere += " AND SQB.QB_DEPTO LIKE '%" + Replace(::FilterValue,"'","") + "%'"
		Else
			cWhere += " AND SQB.QB_DESCRIC LIKE '%" + Replace(::FilterValue,"'","") + "%'"
		EndIf
	EndIf
	cWhere += "%"
	
	If cTipoOrg == "1" //postos
		IF Self:ControlPost == "N"
			BeginSql alias cAuxAlias
				SELECT RD4.RD4_EMPIDE,RD4.RD4_FILIDE,RCL.RCL_DEPTO,RCL.RCL_POSTO
				FROM %table:RD4% RD4
				INNER JOIN  %table:RCL% RCL ON RD4.RD4_FILIDE = RCL.RCL_FILIAL AND RD4.RD4_CODIDE = RCL.RCL_POSTO AND RCL.%notDel%
				INNER JOIN  %table:SQB% SQB ON SQB.QB_DEPTO = RCL.RCL_DEPTO AND SQB.%notDel%
				WHERE 
				RD4.RD4_CHAVE LIKE %exp:cLike%     AND
				RD4.RD4_CODIGO = %exp:cVision%     AND
				RD4.RD4_FILIAL = %xfilial:RD4%     AND
				SQB.QB_FILIAL  = %xfilial:SQB%     AND
				RD4.%notDel%                       
				%exp:cWhere%
				GROUP BY RD4.RD4_EMPIDE,RD4.RD4_FILIDE,RCL.RCL_DEPTO,RCL.RCL_POSTO
				ORDER BY RD4.RD4_EMPIDE,RD4.RD4_FILIDE,RCL.RCL_DEPTO,RCL.RCL_POSTO
			EndSql
		Else
			BeginSql alias cAuxAlias
				SELECT RD4.RD4_EMPIDE,RD4.RD4_FILIDE,RCL.RCL_DEPTO,RCL.RCL_POSTO
				FROM %table:RD4% RD4
				INNER JOIN %table:RCX% RCX ON RCX.RCX_POSTO = RD4.RD4_CODIDE AND RCX.RCX_FILIAL = RD4.RD4_FILIDE
				INNER JOIN %table:SRA% SRA ON RCX.RCX_FILFUN = SRA.RA_FILIAL	AND
				RCX.RCX_MATFUN = SRA.RA_MAT
				INNER JOIN  %table:RCL% RCL ON RD4.RD4_FILIDE = RCL.RCL_FILIAL AND RD4.RD4_CODIDE = RCL.RCL_POSTO AND RCL.%notDel%
				INNER JOIN  %table:SQB% SQB ON SQB.QB_DEPTO = RCL.RCL_DEPTO AND SQB.%notDel%
				WHERE SRA.RA_SITFOLH <> 'D'        AND
				RCX.RCX_SUBST  = '2'				 	AND
				RCX.RCX_TIPOCU = '1'               AND
				RD4.RD4_CHAVE LIKE %exp:cLike%     AND
				RD4.RD4_CODIGO = %exp:cVision%     AND
				RD4.RD4_FILIAL = %xfilial:RD4%     AND
				SQB.QB_FILIAL  = %xfilial:SQB%     AND
				RD4.%notDel%                       AND
				SRA.%notDel%                       AND
				RCX.%notDel%
				%exp:cWhere%
				GROUP BY RD4.RD4_EMPIDE,RD4.RD4_FILIDE,RCL.RCL_DEPTO,RCL.RCL_POSTO
				ORDER BY RD4.RD4_EMPIDE,RD4.RD4_FILIDE,RCL.RCL_DEPTO,RCL.RCL_POSTO
			EndSql
		EndIf

		While !(cAuxAlias)->(Eof())
			If (nx := aScan(aDeptos, {|x| x[3] == (cAuxAlias)->RCL_DEPTO})) > 0
				aadd(aDeptos[nx,5],(cAuxAlias)->RCL_POSTO)
			Else
				aadd(aDeptos,{(cAuxAlias)->RD4_EMPIDE,(cAuxAlias)->RD4_FILIDE,(cAuxAlias)->RCL_DEPTO,'',{(cAuxAlias)->RCL_POSTO}})
			EndIf
			(cAuxAlias)->(dbSkip())
		EndDo
		(cAuxAlias)->(dbCloseArea())
		
	ElseIf cTipoOrg == "2" //departamento com visao
		
		BeginSql alias cAuxAlias
			SELECT RD4.RD4_EMPIDE, RD4.RD4_FILIDE, RD4.RD4_CODIDE, RD4.RD4_CHAVE, RD4.RD4_CODIGO, RD4.RD4_ITEM
			FROM %table:RD4% RD4
			INNER JOIN %table:SQB% SQB ON SQB.QB_FILIAL = RD4.RD4_FILIDE AND RD4.RD4_CODIDE = SQB.QB_DEPTO and RD4_EMPIDE=%exp:cEmpAnt%
			WHERE RD4.RD4_CODIGO = %exp:cVision%   AND
			RD4.RD4_FILIAL = %xfilial:RD4%  AND
			((SQB.QB_FILRESP  = %exp:aRet[3]%   AND
			SQB.QB_MATRESP = %exp:aRet[1]%  AND
			SQB.QB_FILIAL  = %exp:xFilial("SQB", aRet[3])%) OR
			(RD4.RD4_CHAVE LIKE %exp:cLike%))  AND
			RD4.%notDel%                 	  AND
			SQB.%notDel%
			%exp:cWhere%
		EndSql

		While !(cAuxAlias)->(Eof())
			aadd(aDeptos,{	(cAuxAlias)->RD4_EMPIDE,;
				(cAuxAlias)->RD4_FILIDE,;
				(cAuxAlias)->RD4_CODIDE,;
				(cAuxAlias)->RD4_CHAVE,;
				{}})
			(cAuxAlias)->(dbSkip())
		EndDo
		(cAuxAlias)->(dbCloseArea())
		
	Else //departamento sem visao

		If !Empty(::FilterValue) .AND. !Empty(::FilterField)
			If(::FilterField == "1")
				cFiltroCod   := Replace(::FilterValue,"'","")
			Else
				cFiltroDescr := Replace(::FilterValue,"'","")
			EndIf
		EndIf
		
		aDeptos := GetDepto(aRet,cFiltroCod, cFiltroDescr)
	EndIf
	
	::DepartmentData 				  := WsClassNew('TDepartmentData')
	::DepartmentData:PagesTotal       := Ceiling(Len(aDeptos) / PAGE_LENGTH)
	::DepartmentData:ListOfDepartment := {}
	
	If ::Page > 1
		nPosIni := ((Self:Page-1) * PAGE_LENGTH) + 1
	EndIf
	
	For nI := nPosIni To Len(aDeptos)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³estrutura de departamentos                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTabela := "%SQB" + aDeptos[nI][1] + "0%"
		cFilResp	 := "%'" + xFilial( "SQB", aDeptos[nI][2] ) + "'%"
		cPostoVis := ""
		BeginSql alias cAuxAlias1
			SELECT SQB.*
			FROM %exp:cTabela% SQB
			WHERE SQB.QB_DEPTO = %exp:aDeptos[nI][3]%  AND
			SQB.QB_FILIAL =  %exp:cFilResp% AND
			SQB.%notDel%
			%exp:cWhere%
		EndSql
		
		If !(cAuxAlias1)->(Eof())
			aadd(::DepartmentData:ListOfDepartment,WsClassNew('DataDepartment'))
			::DepartmentData:ListOfDepartment[len(::DepartmentData:ListOfDepartment)]:DepartmentEmp		:= aDeptos[nI][1]
			::DepartmentData:ListOfDepartment[len(::DepartmentData:ListOfDepartment)]:DepartmentFilial	:= (cAuxAlias1)->QB_FILIAL
			::DepartmentData:ListOfDepartment[len(::DepartmentData:ListOfDepartment)]:Department		:= (cAuxAlias1)->QB_DEPTO
			::DepartmentData:ListOfDepartment[len(::DepartmentData:ListOfDepartment)]:DescrDepartment	:= (cAuxAlias1)->QB_DESCRIC
			::DepartmentData:ListOfDepartment[len(::DepartmentData:ListOfDepartment)]:KeyVision			:= aDeptos[nI][4]
			::DepartmentData:ListOfDepartment[len(::DepartmentData:ListOfDepartment)]:TotalRegistros	:= Len(aDeptos)
			If Len(aDeptos[nI][5]) > 0
				For nX := 1 To Len(aDeptos[nI][5])
					If nx <> Len(aDeptos[nI][5])
						cPostoVis += "'" + aDeptos[nI][5][nX] + "',"
					Else
						cPostoVis += "'" + aDeptos[nI][5][nX] + "'"
					EndIf
				Next nX
			EndIf
			::DepartmentData:ListOfDepartment[len(::DepartmentData:ListOfDepartment)]:PostoVis := 	cPostoVis
			nQtd++
		EndIf
		(cAuxAlias1)->(dbCloseArea())
		
		If len(::DepartmentData:ListOfDepartment) >= PAGE_LENGTH
			Exit
		EndIf
	Next nI
	
	If nQtd == 0
		SetSoapFault("GetDepartament",PorEncode(STR0011))
		Return .F.
	EndIf
	
	RestArea(aArea)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetPostos		 ³ Autor ³Flavio S. Correa    ³Data ³25.11.2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método de listagem dos Postos de um departamento     			³±±
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
WSMETHOD GetPostos WSRECEIVE CompanyID, DepartmentID, PostID, Page, FilterField, FilterValue, RequestType, EmployeeFil, Registration, PostoVis WSSEND PostData WSSERVICE OrgStructure
	Local aArea     := GetArea()
	Local lRet		:= .T.
	Local nI		:= 1
	Local nJ		:= 1
	Local cDepto	:= Self:DepartmentID
	Local cAuxAlias := "QRCL"
	Local cAuxAlias1:= "QRCX"
	Local cTabela 	:= ""//"%RCL" + ::CompanyId + "0%"
	Local aSx3Box   := RetSx3Box( Posicione("SX3", 2, "RCL_TPOSTO", "X3CBox()" ),,, 1 )
	Local aSx3Box1  := RetSx3Box( Posicione("SX3", 2, "RCL_STATUS", "X3CBox()" ),,, 1 )
	Local cWhere	:= ""
	Local cCompRCL  := FWModeAccess("RCL", 1) +FWModeAccess("RCH", 2) +FWModeAccess("RCH", 3)
   		
	DEFAULT Self:Page       := 1
	DEFAULT Self:CompanyId  := cEmpAnt
	DEFAULT Self:FilterField:= ""
	DEFAULT Self:FilterValue:= ""
	DEFAULT Self:RequestType:= ""
	DEFAULT Self:EmployeeFil:= ""
	DEFAULT Self:Registration:= ""
	DEFAULT Self:PostoVis	:= ""
	
	cTabela := "%" + GetTableName("RCL", Self:CompanyId) + "%"
	
	cWhere := "%"
	If !Empty(Self:PostID)
		cWhere += " AND RCL.RCL_POSTO = '" + Self:PostID + "'"
		
		If !Empty(Self:PostoVis)
				cWhere += " AND RCL.RCL_POSTO IN (" + Self:PostoVis + ")"
		EndIf
	Else
		cWhere += " AND RCL.RCL_DEPTO = '" + cDepto + "'"

		If cCompRCL == "EEE"
		   cWhere += " AND RCL.RCL_FILIAL = '" + ::EmployeeFil + "'"
		EndIf
		
		If !Empty(Self:PostoVis)
				cWhere += " AND RCL.RCL_POSTO IN (" + Self:PostoVis + ")"
		EndIf
		
		If !Empty(Self:FilterField) .AND. !Empty(Self:FilterValue)
			cWhere += " AND RCL." + Self:FilterField + " LIKE '%" + Self:FilterValue + "%'"
		EndIf
	EndIf
	cWhere += "%"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³checa se existe a tabela                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If tcSqlExec("SELECT RCL_FILIAL FROM RCL" + ::CompanyId + "0 WHERE RCL_FILIAL='*' ") >= 0
		Self:PostData:= WsClassNew('TPostData')
		Self:PostData:ListOfPosts:= {}
		
		BEGINSQL ALIAS cAuxAlias
			SELECT COUNT(*) AS REGISTROS
			FROM %exp:cTabela% RCL
			WHERE RCL.%notDel%
			%exp:cWhere%
			AND RCL.RCL_STATUS IN('1','2')
		ENDSQL
		
		Self:PostData:PagesTotal:=	Ceiling((cAuxAlias)->REGISTROS / PAGE_LENGTH)
		(cAuxAlias)->(dbCloseArea())
		
		BeginSql alias cAuxAlias
			SELECT RCL.*
			FROM %exp:cTabela% RCL
			WHERE RCL.%notDel%
			%exp:cWhere%
			AND RCL.RCL_STATUS IN('1','2')
			ORDER BY RCL.RCL_FILIAL,RCL.RCL_POSTO
		EndSql
		
		If Self:Page > 1
			dbSkip((Self:Page-1) * PAGE_LENGTH)
		EndIf
		
		While !(cAuxAlias)->(Eof())	 .AND.;
				Len(Self:PostData:ListOfPosts) < PAGE_LENGTH
			AAdd(Self:PostData:ListOfPosts, WsClassNew('DataPostos'))
			
			Self:PostData:ListOfPosts[nI]:PostoEmp		:= ::CompanyId
			Self:PostData:ListOfPosts[nI]:PostFilial	:= (cAuxAlias)->RCL_FILIAL
			Self:PostData:ListOfPosts[nI]:Posto			:= (cAuxAlias)->RCL_POSTO
			Self:PostData:ListOfPosts[nI]:CodDepto		:= (cAuxAlias)->RCL_DEPTO
			Self:PostData:ListOfPosts[nI]:DescrDepto	:= Alltrim(Posicione("SQB",1,xFilial("SQB",(cAuxAlias)->RCL_FILIAL)+(cAuxAlias)->RCL_DEPTO, "SQB->QB_DESCRIC"))
			Self:PostData:ListOfPosts[nI]:Tipo			:= (cAuxAlias)->RCL_TPOSTO
			Self:PostData:ListOfPosts[nI]:DescrTipo		:= 	Alltrim(aSx3Box[Ascan( aSx3Box, { |aBox| aBox[2] = (cAuxAlias)->RCL_TPOSTO  } )][3])
			Self:PostData:ListOfPosts[nI]:Qtd			:= (cAuxAlias)->RCL_NPOSTO
			Self:PostData:ListOfPosts[nI]:Ocupado		:= (cAuxAlias)->RCL_OPOSTO
			Self:PostData:ListOfPosts[nI]:CodCargo		:= (cAuxAlias)->RCL_CARGO
			Self:PostData:ListOfPosts[nI]:DescrCargo	:= Alltrim(Posicione("SQ3",1,xFilial("SQ3",(cAuxAlias)->RCL_FILIAL)+(cAuxAlias)->RCL_CARGO,"Q3_DESCSUM"))
			Self:PostData:ListOfPosts[nI]:CodFuncao		:= (cAuxAlias)->RCL_FUNCAO
			Self:PostData:ListOfPosts[nI]:DescrFuncao	:= Alltrim(Posicione("SRJ",1,xFilial("SRJ",(cAuxAlias)->RCL_FILIAL)+(cAuxAlias)->RCL_FUNCAO,"RJ_DESC"))
			Self:PostData:ListOfPosts[nI]:CC			:= Alltrim((cAuxAlias)->RCL_CC)
			Self:PostData:ListOfPosts[nI]:DescrCC      	:= Alltrim(Posicione("CTT",1,xFilial("CTT",(cAuxAlias)->RCL_FILIAL)+(cAuxAlias)->RCL_CC,"CTT_DESC01"))
			Self:PostData:ListOfPosts[nI]:TipoContrato	:= Alltrim((cAuxAlias)->RCL_TPCONT)
			Self:PostData:ListOfPosts[nI]:Salario		:= (cAuxAlias)->RCL_SALAR
			Self:PostData:ListOfPosts[nI]:CodStatus		:= (cAuxAlias)->RCL_STATUS
			Self:PostData:ListOfPosts[nI]:Status		:= 	Alltrim(aSx3Box1[Ascan( aSx3Box1, { |aBox| aBox[2] = (cAuxAlias)->RCL_STATUS  } )][3])
			
			BeginSql alias cAuxAlias1
				SELECT RCX.RCX_FILFUN,RCX.RCX_MATFUN
				FROM %table:RCX% RCX
				WHERE RCX.RCX_POSTO = %exp:(cAuxAlias)->RCL_POSTO%
				AND RCX.%notDel%
				AND RCX.RCX_FILIAL = %xfilial:RCX%
				ORDER BY RCX.RCX_FILFUN,RCX.RCX_MATFUN
			EndSql
			
			Self:PostData:ListOfPosts[nI]:Ocupantes := {}
			nJ := 1
			While !(cAuxAlias1)->(Eof())
				aadd(Self:PostData:ListOfPosts[nI]:Ocupantes,WsClassNew('TOcupantes'))
				Self:PostData:ListOfPosts[nI]:Ocupantes[nJ]:Filial		:= (cAuxAlias1)->RCX_FILFUN
				Self:PostData:ListOfPosts[nI]:Ocupantes[nJ]:Matricula	:= (cAuxAlias1)->RCX_MATFUN
				Self:PostData:ListOfPosts[nI]:Ocupantes[nJ]:Nome		:= Alltrim(Posicione('SRA',1,(cAuxAlias1)->RCX_FILFUN+(cAuxAlias1)->RCX_MATFUN,'SRA->RA_NOME'))
				
				nJ++
				(cAuxAlias1)->(dbSkip())
			EndDo
			(cAuxAlias1)->(dbCloseArea())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verificar se possui alguma solicitação de aumento de quadro para o departamento/posto.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Self:RequestType == "3" // Aumento de Quadro
				BeginSql alias cAuxAlias1
					SELECT
					RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH4.RH4_CAMPO, RH4.RH4_VALNOV, RH4A.RH4_CAMPO, RH4A.RH4_VALNOV
					FROM
					%table:RH3% RH3
					INNER JOIN %table:RH4% RH4
					ON 	RH3.RH3_FILIAL = RH4.RH4_FILIAL AND
					RH3.RH3_CODIGO = RH4.RH4_CODIGO
					INNER JOIN %table:RH4% RH4A
					ON 	RH4.RH4_FILIAL = RH4A.RH4_FILIAL AND
					RH4.RH4_CODIGO = RH4A.RH4_CODIGO
					WHERE
					RH4A.RH4_CAMPO = 'RBT_CODPOS'                   AND
					RH4A.RH4_VALNOV = %exp:(cAuxAlias)->RCL_POSTO%  AND
					RH4.RH4_CAMPO = 'RBT_DEPTO'                     AND
					RH4.RH4_VALNOV = %exp:(cAuxAlias)->RCL_DEPTO%   AND
					RH3.RH3_STATUS in ('1', '4')                    AND
					RH4.%notDel%                                    AND
					RH4A.%notDel%                                   AND
					RH3.%notDel%
				EndSql
				
				If !(cAuxAlias1)->(Eof())
					Self:PostData:ListOfPosts[nI]:PossuiSolic := .T.
				Else
					Self:PostData:ListOfPosts[nI]:PossuiSolic := .F.
				EndIf
				(cAuxAlias1)->(dbCloseArea())
			Else
				Self:PostData:ListOfPosts[nI]:PossuiSolic := .F.
			EndIf
			
			(cAuxAlias)->(dbSkip())
			nI++
		EndDo
		(cAuxAlias)->(dbCloseArea())
	Else
		lRet := .F.
		SetSoapFault("GetPostos",PorEncode(STR0008)) // "Departamento não possui postos"
	EndIf
	
	RestArea(aArea)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutPrtULogin	 ³ Autor ³Marcelo Faria       ³Data ³18.04.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza novo login unificado para o portal	 				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal Protheus                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD PutPrtULogin WSRECEIVE PrtEmpFil, PrtOriLogin, PrtUnifLogin, PrtAcess WSSEND WsNull WSSERVICE OrgStructure
	Local lRet                  := .T.
	Local lRetRD0               := .F.
	Local lRetAtivo             := .F.
	Local nCount            	:= 0
	Local cGCHSDoc				:= SuperGetMv( "MV_GCHSDOC" , .F. , "1" ) // '1' = RD0_CIC '2'= RD0_DOCID
	DEFAULT Self:PrtEmpFil  	:= ""
	DEFAULT Self:PrtOriLogin    := ""
	DEFAULT Self:PrtUnifLogin   := ""
	DEFAULT Self:PrtAcess       := ""
	
	dbSelectArea("RD0")
	dbSetOrder(10)
	
	If dbSeek( xFilial("RD0")+ Padr(UPPER(AllTrim(::PrtUnifLogin)),TamSx3("RD0_LOGIN")[1]) )
		SetSoapFault("PrtULogin",PorEncode(STR0013)) // "Esse usuario ja existe! utilize outro."
		lRet := .F.
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica caso a tentativa de login seja feita pela DOCID(RD0_DOCID)                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc # 'BRA' .And. cGCHSDoc == '2'
			dbSetOrder(11)
			If dbSeek( xFilial("RD0")+UPPER(AllTrim(::PrtOriLogin)) )
				lRetRD0 := .T.
				If RD0->RD0_MSBLQL == "2"
					lRetAtivo := .T.
				EndIf
			EndIf
		EndIf
		
		If !(lRetRD0)
			If ::PrtAcess == "1"
				dbSetOrder(7)
			Else
				dbSetOrder(6)
			EndIf
			
			If DbSeek( xFilial("RD0")+UPPER(AllTrim(::PrtOriLogin)) )
				lRetRD0 := .T.
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³No Portal RH, pode haver mais de um participante com o mesmo CPF.                     ³
				//³Incluido tratamento para procurar um participante ativo.                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !::PrtAcess == "1"
					While RD0->( !Eof() .and. RD0_FILIAL+RD0_CIC == xFilial("RD0")+UPPER(AllTrim(::PrtOriLogin)) )
						If RD0->RD0_MSBLQL == "2"
							lRetAtivo := .T.
							EXIT
						EndIf
						RD0->( dbSkip() )
					End While
				Else
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se existe emails iguais no cadastro de participantes                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While RD0->( !Eof() .and. RD0_FILIAL+Alltrim(RD0_EMAIL) == xFilial("RD0")+UPPER(AllTrim(::PrtOriLogin)) )
						nCount += 1
						RD0->( dbSkip() )
					End While
					
					If nCount == 1
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Posiciona registro original                                                           ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSeek( xFilial("RD0")+UPPER(AllTrim(::PrtOriLogin)) )
						
						If RD0->RD0_MSBLQL == "2"
							lRetAtivo := .T.
						EndIf
					Else
						SetSoapFault("PrtULogin-X",PorEncode(STR0014)) // "Nao localizado usuario de origem ativo!"
						lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf
		
		If lRetRD0
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Login unificado RD0                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRetAtivo
				Reclock("RD0",.F.)
				RD0->RD0_LOGIN :=   UPPER(AllTrim(::PrtUnifLogin))
				RD0->( MsUnlock() )
			Else
				SetSoapFault("PrtULogin",PorEncode(STR0014)) // "Nao localizado usuario de origem ativo!"
				lRet := .F.
			Endif
		Else
			SetSoapFault("PrtULogin",PorEncode(STR0015)) // "Usuario de origem nao localizado!"
			lRet := .F.
		EndIf
	EndIf
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TipoOrg		 ³ Autor ³Flavio S. Correa    ³Data ³24.11.2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Checa o Tipo de Estrutura - Departamentos/postos    		 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function TipoOrg(cTypeOrg, cVision)
	Local aArea := GetArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SE O PARAMETRO cTypeOrg ESTIVER VAZIO ENTAO OLHAMOS O TIPO DE ESTRUTURA PELA VISAO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cTypeOrg)
		If Empty(cVision)
			cTypeOrg := "0"
		Else
			dbSelectArea("RDK")
			If RDK->(dbSeek(xFilial("RDK")+cVision))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³RDK->RDK_HIERAR -> 1=Departamento;2=Postos                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If RDK->RDK_HIERAR == "1"
					cTypeOrg := "2" //departamento
				Else
					cTypeOrg := "1" //posto
				EndIf
			Else
				Return .F.
			EndIf
		EndIf
	EndIf
	
	RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ChaveRD4		 ³ Autor ³Flavio S. Correa    ³Data ³24.11.2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Busca a Chave na tabela RD4									³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function ChaveRD4(cTypeOrg,aRet,cVision,cItem,cChave,cLike)
	Local aArea		:= GetArea()
	Local cRD4Alias	:= "QRD4"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Postos                                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTypeOrg == "1"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Selecionar dados do funcionario logado                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BeginSql alias cRD4Alias
			
			SELECT RD4.RD4_ITEM, RD4.RD4_TREE, RD4.RD4_CHAVE
			FROM %table:RD4% RD4
			INNER JOIN %table:RCX% RCX   ON  RD4.RD4_CODIDE = RCX.RCX_POSTO  AND RCX_FILIAL = RD4_FILIDE
			INNER JOIN %table:RDK% RDK   ON  RD4.RD4_FILIAL = RDK.RDK_FILIAL   AND
			RD4.RD4_CODIGO = RDK.RDK_CODIGO
			WHERE
			RDK.RDK_HIERAR = '2'            AND
			RDK.RDK_TIPO   = '1'            AND
			RCX.RCX_FILFUN = %exp:aRet[3]%  AND
			RCX.RCX_MATFUN = %exp:aRet[1]%  AND
			RCX.RCX_SUBST  = '2'            AND
			RCX.RCX_TIPOCU = '1'            AND
			RD4.RD4_CODIGO = %exp:cVision%  AND
			RD4.RD4_FILIAL = %xfilial:RD4%  AND
			RDK.%notDel%                    AND
			RCX.%notDel%                    AND
			RD4.%notDel%
		EndSql
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Departamento (com visao)                                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cTypeOrg == "2"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Selecionar dados do funcionario logado                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BeginSql alias cRD4Alias
			
			SELECT RD4.RD4_ITEM, RD4.RD4_TREE, RD4.RD4_CHAVE
			FROM %table:RD4% RD4
			INNER JOIN %table:RDK% RDK ON RD4.RD4_FILIAL = RDK.RDK_FILIAL   AND
			RD4.RD4_CODIGO = RDK.RDK_CODIGO
			WHERE RD4.RD4_CODIGO = %exp:cVision% AND
			RD4.RD4_FILIAL = %xfilial:RD4% AND
			RD4.RD4_CODIDE = %exp:aRet[8]% AND
			RDK.RDK_HIERAR = '1'          AND
			RDK.RDK_TIPO   = '1'          AND
			RDK.%notDel%			      AND
			RD4.%notDel%
		EndSql
	EndIf
	
	If (cRD4Alias)->( Eof() )
		(cRD4Alias)->( DbCloseArea() )
		Return(.F.)
	EndIf
	
	cItem  := (cRD4Alias)->RD4_ITEM
	cChave := (cRD4Alias)->RD4_CHAVE
	If Empty((cRD4Alias)->RD4_CHAVE)
		cLike  := ''
	Else
		cLike  := Alltrim((cRD4Alias)->RD4_CHAVE) + '%'
	EndIf
	
	(cRD4Alias)->( DbCloseArea() )
	
	RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetDepto		 ³ Autor ³Equipe RH           ³Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                  			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetDepto(aRet, cFiltroCod, cFiltroDescr)
	Local nPOs	   		:= 1
	Local nReg	   		:= 1
	Local aDeptos		:= {}
	Local aTemp			:= {}
	Local cChave		:= ""
	Local cWhere		:= ""
	
	If !Empty(cFiltroCod)
		cWhere += "('" + cFiltroCod + "' $ cCodDepto) "
	EndIf
	
	If !Empty(cFiltroDescr)
		cWhere += "('" + cFiltroDescr + "' $ cDescrDepto) "
	EndIf
	
	If Empty(cWhere)
		cWhere := ".T."
	EndIf
	
	aDeptos := fEstrutDepto()
	For nPos := 1 to Len(aDeptos)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica quais departamentos o funcionario logado é responsável                       ³
		//³aDeptos[nPos][2] -> Filial                                                            ³
		//³aDeptos[nPos][3] -> Matricula                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aDeptos[nPos][2] == aRet[3] .and. aDeptos[nPos][3] == aRet[1]
			cChave      := aDeptos[nPos][5]
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica quais departamentos estão abaixo do departamento                             ³
			//³que o funcionario logado é responsável                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nReg := 1 to Len(aDeptos)
				cCodDepto   := aDeptos[nReg][1]
				cDescrDepto := aDeptos[nReg][6]
				If &cWhere
					If aDeptos[nReg][5] == cChave .or. ((substr(aDeptos[nReg][5],1,len(cChave)) == cChave .and. len(aDeptos[nReg][5]) == len(cChave) + 3))
						If aScan(aTemp, {|x| x[3] == aDeptos[nReg][1]}) <= 0
							aadd(aTemp,{SM0->M0_CODIGO,aDeptos[nReg][2],aDeptos[nReg][1],aDeptos[nReg][5],''})
						EndIf
					EndIf
				EndIf
			Next nReg
		EndIf
	Next nPos
	
Return aClone(aTemp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fGetFunc		 ³ Autor ³                    ³Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                               				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function fGetFunc(cFilFunc, cMatFunc, aDadosFunc)
	Local lRet := .F.
	Local lRD0 := .T.
	Local lSRA := .T.
	
	aDadosFunc := {}
	
	DbSelectArea("RDZ")
	RDZ->( dbSetOrder(1) ) //RDZ_FILIAL+RDZ_EMPENT+RDZ_FILENT+RDZ_ENTIDA+RDZ_CODENT+RDZ_CODRD0
	If RDZ->( dbSeek(xFilial("RDZ")+ SM0->M0_CODIGO + cFilFunc + "SRA" + cFilFunc + cMatFunc) )
		DbSelectArea("RD0")
		RD0->( dbSetOrder(1) )
		If RD0->( dbSeek(xFilial("RD0")+RDZ->RDZ_CODRD0) )
			lRD0 := .T.
		EndIf
	EndIf
	
	DbSelectArea("SRA")
	SRA->( dbSetOrder(1) )
	If SRA->( dbSeek(cFilFunc + cMatFunc) )
		lSRA := .T.
	EndIf
	
	If lSRA .or. lRD0
		aAdd(aDadosFunc, {DTOC(SRA->RA_ADMISSA),;
			SRA->RA_DEPTO        ,;
			If(! Empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,If(! Empty(RD0->RD0_NOME), RD0->RD0_NOME, SRA->RA_NOME)),;
			Iif(!Empty(RD0->RD0_EMAIL),RD0->RD0_EMAIL,SRA->RA_EMAIL),;
			IIf(lRD0, RD0->RD0_CODIGO, "")})
		lRet := .T.
	EndIf
	
Return(lRet)

WSMETHOD GetCargo WSRECEIVE  EmployeeFil, FuncaoId WSSEND CargoData WSSERVICE OrgStructure
Local lRet := .T.
Local aArea := GetArea()

DEFAULT ::EmployeeFil := xFilial("SRA")
DEFAULT ::FuncaoId := ""

dbselectarea("SRJ")
SRJ->(dbsetorder(1))
If SRJ->(dbseek(xFilial("SRJ",::EmployeeFil)+::FuncaoId))
	CargoData:salario	:= SRJ->RJ_SALARIO
	CargoData:CargoId	:= SRJ->RJ_CARGO
	dbselectarea("SQ3")
	SQ3->(dbsetorder(1))
	If SQ3->(dbseek(xFilial("SQ3",::EmployeeFil)+SRJ->RJ_CARGO))
		CargoData:CargoDescr 	:= SQ3->Q3_DESCSUM
		CargoData:CentroCustoId 	:= SQ3->Q3_CC
		If !Empty(SQ3->Q3_CC)
			CargoData:CentroCusto := Posicione("CTT",1,xFilial("CTT",::EmployeeFil)+SQ3->Q3_CC,"CTT_DESC01")
		EndIf
	Endif
Else
	SetSoapFault("GetCargo",PorEncode(STR0019))
	lRet := .F.
Endif
RestArea(aArea)
Return lRet


Function GetAnyDesc(cEmp, cFil, cTab, cChv)
Local aArea 		:= GetArea()
Local cAliasQry		:= GetNextAlias()
Local cDescr		:= ""
Local cTabela		:= ""
Local nPos			:= 0

Default cEmp := cEmpAnt 
IIF(Empty(cEmp),cEmp := cEmpAnt,cEmp := cEmp) 

cTabela	:= "%"+RetFullName(cTab,cEmp)+"%"

If cTab == "SQ3"
	BeginSQL alias cAliasQry
		SELECT SQ3.Q3_DESCSUM
		  FROM %exp:cTabela% SQ3
		 WHERE SQ3.Q3_FILIAL = %exp:xFilial("SQ3", cFil)% AND
		       SQ3.Q3_CARGO = %exp:cChv% AND
		       SQ3.%notDel%
	EndSQL
		
	If !(cAliasQry)->( Eof() )
		cDescr    :=(cAliasQry)->Q3_DESCSUM
	EndIf
ElseIf cTab == "SRJ"
	BeginSQL alias cAliasQry
		SELECT SRJ.RJ_DESC
		FROM %exp:cTabela% SRJ
		WHERE SRJ.RJ_FILIAL = %exp:xFilial("SRJ", cFil)% AND
		      SRJ.RJ_FUNCAO = %exp:cChv% AND
		      SRJ.%notDel%
	EndSQL
	
	If !(cAliasQry)->( Eof() )
		cDescr    :=(cAliasQry)->RJ_DESC
	EndIf
ElseIf cTab == "SQB"
	BeginSQL alias cAliasQry
		SELECT SQB.QB_DESCRIC
		FROM %exp:cTabela% SQB
		WHERE SQB.QB_FILIAL = %exp:xFilial("SQB", cFil)% AND
		      SQB.QB_DEPTO = %exp:cChv% AND
		      SQB.%notDel%
	EndSQL
	
	If !(cAliasQry)->( Eof() )
		cDescr    :=(cAliasQry)->QB_DESCRIC
	EndIf
ElseIf cTab == "SRA"
	BeginSQL alias cAliasQry
		SELECT SRA.RA_NOME,RA_NOMECMP
		FROM %Exp:cTabela% SRA
		WHERE SRA.RA_FILIAL = %exp:cFil% AND
	      SRA.RA_MAT = %exp:cChv% AND
	      SRA.%notDel%
	EndSQL
	
	If !(cAliasQry)->( Eof() )
		cDescr    :=Iif(!Empty((cAliasQry)->RA_NOMECMP),(cAliasQry)->RA_NOMECMP,Alltrim((cAliasQry)->RA_NOME))
	EndIf
		
EndIf

(cAliasQry)->(dbCloseArea())
RestArea(aArea)
Return cDescr
