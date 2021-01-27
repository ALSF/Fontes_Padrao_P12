#INCLUDE "WSAPD011.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSAPD011  ³ Autor ³Rogerio Augusto		³ Data ³23.11.2004  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pela identificacao				    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista     ³ Data   ³Cham. ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³R.Berti       ³29/08/12³TFOG08³Correcao erro "array out of bounds... on  ³±±
±±³				 ³		  ³		 ³ H_PWSAHISTSALARIAL(PWSAHISTSALARIAL.APH)"³±±
±±³R.Berti       ³06/09/12³TFRUT4³Ajuste da chave SR3 com o TIPO da SR7 p/  ³±±
±±³				 ³		  ³		 ³trazer o reg. correto do Hist. Salarial.  ³±±
±±³Renan Borges  ³08/01/15³TRGLDS³Ajuste no tipo da variavel WDValue para   ³±±
±±³				 ³		  ³		 ³retornar valor correto do salário.        ³±±
±±³Cícero Alves  ³08/05/15³TSGJH2³adicionado o campo PcD - Pessoa com 		³±±
±±³				 ³		  ³		 ³deficiência						        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Identificacao								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WSSTRUCT UserInfo
	WSDATA UserID		   		As String			//Codigo do participante
	WSDATA UserName				As String OPTIONAL	//Nome do participante
	WSDATA UserType				As String OPTIONAL	//Tipo do participante 1=partlogado; 2=subordinado; 3=mentorado
	WSDATA UserCPF				As String OPTIONAL	//CPF do participante
	WSDATA UserAdress			As String OPTIONAL	//Endrececo do participante
	WSDATA UserCity				As String OPTIONAL	//Cidade do participante
	WSDATA ItemCode				As String OPTIONAL	//Codigo da visao
	WSDATA ItemDesc				As String OPTIONAL	//Descricao da Visao
	WSDATA Tree					As String OPTIONAL	//Grupo que esta acima
	WSDATA ParticipantCC		As String OPTIONAL	//Centro de Custo
	WSDATA ParticipantCCD		As String OPTIONAL	//Descricao do Centro de Custo
	WSDATA ParticipantPosit		As String OPTIONAL	//Cargo
	WSDATA LastUpdate			As Date	  OPTIONAL	//Data da ultima alteracao
ENDWSSTRUCT

WSSTRUCT VisionData
	WSDATA Vision					As String  //Visoes disponiveis ao avaliador
	WSDATA VisionDescription		As String  OPTIONAL	//Descricao da Visao
	WSDATA UserVision				As Array Of UserInfo OPTIONAL //Subordinados relacionados a visao
ENDWSSTRUCT

WSSTRUCT ListOfVisions
	WSDATA EvaluatorID				As String			//Codigo do avaliador
	WSDATA EvaluatorName			As String OPTIONAL	//Nome do Avaliador
	WSDATA VisionList				As Array of VisionData OPTIONAL //Descricao e codigos das visoes
ENDWSSTRUCT

WSSTRUCT PersonalData
	//--------{ dados pessoais
	WSDATA ParticipantID			As String			//Codigo do participante
	WSDATA ParticipantMatr			As String OPTIONAL	//Matricula do participante
	WSDATA ParticipantFilial		As String OPTIONAL	//Filial do participante
	WSDATA ParticipantName			As String OPTIONAL	//Nome do participante
	WSDATA ParticipantDataNasc		As Date OPTIONAL	//Data de nascimento
	WSDATA ParticipantCPF			As String OPTIONAL	//CPF do participante
	WSDATA ParticipantMail			As String OPTIONAL	//E-mail
	WSDATA ParticipantAdress		As String OPTIONAL	//Rua e numero do endereco
	WSDATA ParticipantCompl			As String OPTIONAL	//Complemento do endereco
	WSDATA ParticipantZone			As String OPTIONAL	//Bairro do participante
	WSDATA ParticipantCity			As String OPTIONAL	//Cidade do participante
	WSDATA ParticipantState			As String OPTIONAL	//Estado
	WSDATA ParticipantZIP			As String OPTIONAL	//CEP
	WSDATA ParticipantPhoCode		As String OPTIONAL	//Codigo DDD
	WSDATA ParticipantPhone			As String OPTIONAL	//Telefone residencial
	WSDATA ParticipantCel			As String OPTIONAL	//Celular
	WSDATA ParticipantTrvlCombo		As Array of TravelDispOptions OPTIONAL	//Combo disponibilidade para Viagens
	WSDATA ParticipantTrvlSelected	As String OPTIONAL	//Opcao selecionada sobre disponibilidade para viagens
	WSDATA ParticipantTrvlDescript	As String OPTIONAL	//Descricao da opcao selecionada
	
	WSDATA ParticipantDisbCombo		As Array of DisabledPeopOptions OPTIONAL	//Combo PCD
	WSDATA ParticipantDisbSelected	As String OPTIONAL	//Opcao selecionada sobre PCD
	WSDATA ParticipantDisbDescript	As String OPTIONAL	//Descricao da opcao selecionada
	
	WSDATA WageDate					As Date   OPTIONAL	//Data da ultima acao salarial
	WSDATA WageType					As String OPTIONAL	//tipo de acao salarial
	WSDATA TimeNoWage 				As String OPTIONAL	//tempo sem acao salarial
	WSDATA PromotionDate			As Date   OPTIONAL	//data da ultima promocao
	WSDATA TimeNoPromotion			As String OPTIONAL	//tempo sem promocao
	//--------}
	//--------{ dados organizacionais
	WSDATA ParticipantMat			As String OPTIONAL	//Matricula do participante
	WSDATA ParticipantRG			As String OPTIONAL	//RG do participante
	WSDATA ParticipantDate			As Date OPTIONAL	//Data de admissao
	WSDATA ParticipantEmpTime		As String OPTIONAL	//Tempo de casa em meses
	WSDATA ParticipantCC			As String OPTIONAL	//Centro de Custo
	WSDATA ParticipantCCD			As String OPTIONAL	//Descricao do Centro de Custo
	WSDATA ParticipantPosit			As String OPTIONAL	//funcao
	WSDATA ParticipantCargo			As String OPTIONAL	//Cargo
	WSDATA ParticipantDCargo		As String OPTIONAL	//Cargo
	WSDATA ParticipantDetalheCargo	As String OPTIONAL	//Cargo
	WSDATA ParticipantHLider		As String OPTIONAL	//Lider hierarquico
	WSDATA ParticipantEval			As String OPTIONAL	//Avaliador principal
	WSDATA ParticipantMen			As String OPTIONAL	//Mentor
	WSDATA ParticipantComAdress		As String OPTIONAL	//Rua e numero do endereco comercial
	WSDATA ParticipantComCompl		As String OPTIONAL	//Complemento do endereco comercial
	WSDATA ParticipantComZone		As String OPTIONAL	//Bairro comercial do participante
	WSDATA ParticipantComCity		As String OPTIONAL	//Cidade comercial do participante
	WSDATA ParticipantComState		As String OPTIONAL	//Estado comercial
	WSDATA ParticipantComZIP		As String OPTIONAL	//CEP comercial
	WSDATA ParticipantComPhoCode	As String OPTIONAL	//Codigo DDD comercial
	WSDATA ParticipantComPhone		As String OPTIONAL	//Telefone comercial
	WSDATA ParticipantComCel		As String OPTIONAL	//Celular comercial
	WSDATA ParticipantComMail		As String OPTIONAL	//E-mail comercial
	WSDATA LastUpdate				As Date   OPTIONAL	//Data da ultima alteracao
	//--------}
	WSDATA FindCPF					As String OPTIONAL	//Identifica se o participante faz parte da tabela de funcionarios
ENDWSSTRUCT

WSSTRUCT TravelDispOptions
	WSDATA TravelOptionID			As String			//Codigo da opcao de disponibilidade
	WSDATA TraveOptionDescription	As String OPTIONAL	//Descricao do tipo de opcao para disponibilidade
ENDWSSTRUCT

WSSTRUCT DisabledPeopOptions
	WSDATA DisabledPeopleID			As String			//Codigo da opcao de disponibilidade
	WSDATA DisabledPeopleDescription	As String OPTIONAL	//Descricao do tipo de opcao para disponibilidade
ENDWSSTRUCT

WSSTRUCT WageHistoryHeader
	WSDATA WHDate					As Date				//Data do aumento
	WSDATA WHTypeCod				As String OPTIONAL	//Codigo do tipo do aumento
	WSDATA WHTypeDes				As String OPTIONAL	//Descricao do tipo do aumento
	WSDATA WHFunctionCod			As String OPTIONAL	//Codigo da funcao
	WSDATA WHFunctionDes			As String OPTIONAL	//Descricao da funcao
	WSDATA WHPayType				As String OPTIONAL	//Tipo de pagamento
	WSDATA WHEmpType				As String OPTIONAL	//Categoria do funcionario
	WSDATA WHSequenc				As String OPTIONAL	//Sequencia
ENDWSSTRUCT

WSSTRUCT WageHistoryArray
	WSDATA WDItem					As Array of WageHistoryValues
ENDWSSTRUCT

WSSTRUCT WageHistoryValues
	WSDATA WDDate					As Date				//Data do aumento
	WSDATA WDTypeCod				As String OPTIONAL	//Codigo do tipo do aumento
	WSDATA WDTypeDes				As String OPTIONAL	//Descricao do tipo do aumento
	WSDATA WDValue					As Float OPTIONAL	//Valor
	WSDATA WDSequenc				As String OPTIONAL	//Sequencia
ENDWSSTRUCT

WSSTRUCT WageHistoryData
	WSDATA ParticipantID			As String			//Codigo do participante
	WSDATA ParticipantName			As String OPTIONAL	//Nome do participante
	WSDATA ParticipantMat			As String OPTIONAL	//Matricula do participante
	WSDATA FindCPF					As String OPTIONAL	//Identifica se o participante faz parte da tabela de funcionarios
    WSDATA WHHeader					As Array of WageHistoryHeader OPTIONAL //Array com o cabecalho do historico
    WSDATA WHData					As Array of WageHistoryArray OPTIONAL //Array com os valores do historico salaria
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Identificacao		                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHIdentify DESCRIPTION STR0001 //"Identificacao do usuario ( <b>Restrição de participante</b> )"
	WSDATA UserCode               AS String
	WSDATA ParticipantId          As String             //Codigo do Participante
	WSDATA EvaluatorID			  AS String   OPTIONAL
	WSDATA EvaluatedID			  AS String   OPTIONAL
	WSDATA CodVis				  As String	  OPTIONAL //codigo da visao
	WSDATA WsNull                 AS String
	WSDATA Visions				  As ListOfVisions  OPTIONAL //Lista de visoes e subordinados relativos
	WSDATA PersonalInfo			  As PersonalData OPTIONAL //Dados pessoais completos do participante
	WSDATA WageHistory			  As WageHistoryData OPTIONAL //Dados pessoais completos do participante
	WSDATA ListOfUsers			  As Array Of UserInfo OPTIONAL //Subordinados e Mentorados do participante logado

	WSMETHOD BrwSubortinates  DESCRIPTION STR0002 //"Retorna a lista de visoes e subordinados do avaliador"
	WSMETHOD BrwPersonalData  DESCRIPTION STR0003 //"Retorna os dados pessoais completos do participante"
	WSMETHOD PutPersonalData  DESCRIPTION STR0004 //"Atualiza os dados pessoais do participante"
	WSMETHOD BrwWageHistory	  DESCRIPTION STR0005 //"Retorna o historico de acoes salariais do participante"

ENDWSSERVICE

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwSubortinates³ Autor ³Rogerio Augusto     ³Data ³09.11.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna as visoes e respectivos subordinados, referentes      ³±±
±±³          ³ao avaliador.                                                 ³±±
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
WSMETHOD BrwSubortinates WSRECEIVE UserCode, ParticipantId, CodVis WSSEND ListOfUsers WSSERVICE RHIdentify

Local aArea     := GetArea()
Local lRetorno  := .T.
Local nI		:= 0
Local nP		:= 0
Local nX		:= 0
Local aSub		:= {}
Local aVisao	:= {}


dbSelectArea("RDE")
RDE->( dbSetOrder(1) )

::ListOfUsers := {}

If !Empty(::CodVis)
   	RDE->(MsSeek(xFilial("RDE")+::ParticipantId+::CodVis ,.T.))
   	While !RDE->( Eof() ) .And. ::ParticipantId+::CodVis == RDE->RDE_CODPAR+RDE->RDE_CODVIS
		If RDE->RDE_STATUS == "1" //SE STATUS ATUAL ESTA ATIVO
			aadd( aVisao, {RDE->RDE_ITEVIS, RDE->RDE_CODVIS} )
		EndIf
		RDE->( dbSkip() )
   	EndDo
EndIf

For nX := 1 to len(aVisao)

	aSub := {}
	//---------{ monta uma array bidimensional, com os subordinados relativos a cada visao
	ApdaDorNivel( aVisao[nX][1] , xFilial("RDE") , aVisao[nX][2] , "3" , 0, aSub )
	/* RETORNO DO ARRAY aSub COM SUBORDINADOS POR NIVEL
	01 -> Codigo do Participante no RDE
	02 -> Codigo da Visao
	03 -> Item de Visao
	04 -> Nivel "1=Mesmo Nivel";"2=Superior";"3=Inferior"
	05 -> Niveis do Tree
	06 -> Ordem de Inclusao
	07 -> Recno() no RDE
	*/


	//CONSULTA SUBORDINADOS PELAS VISOES
	For nP := 1 to len(aSub)
		nI++
		RD0->( dbSetOrder(1) )
		If RD0->( MsSeek( xFilial("RD0")+aSub[nP][1] ) )
			aAdd(::ListOfUsers,WSClassNew('UserInfo'))
			::ListOfUsers[nI]:UserID	:= RD0->RD0_CODIGO
		   	::ListOfUsers[nI]:UserName	:= RD0->RD0_NOME
		   	::ListOfUsers[nI]:UserType	:= "2"
			::ListOfUsers[nI]:LastUpdate := GetLastUpdate( RD0->RD0_CODIGO ) //data ult alteracao
		EndIf
   	Next nP

Next nX
//---------}

//CONSULTA PARTICIPANTES QUE TEM COMO MENTOR O PART LOGADO
dbSelectArea("RD0")
RD0->( dbSetOrder(5) ) //Filial+Mentor
If RD0->( MsSeek( xFilial("RD0")+::ParticipantId ) )

	While !RD0->( Eof() ) .And. xFilial("RD0") == RD0->RD0_FILIAL .And. ::ParticipantId == RD0->RD0_CODMEN
		If ascan(::ListOfUsers, { |x| x:UserID == RD0->RD0_CODIGO } ) == 0
			aAdd(::ListOfUsers,WSClassNew('UserInfo'))
			nI := len(::ListOfUsers)
			::ListOfUsers[nI]:UserID	:= RD0->RD0_CODIGO
			::ListOfUsers[nI]:UserName	:= RD0->RD0_NOME
			::ListOfUsers[nI]:UserType	:= "3"
			::ListOfUsers[nI]:LastUpdate := GetLastUpdate( RD0->RD0_CODIGO ) //data ult alteracao
		EndIf
		RD0->( DbSkip() )
	EndDo
EndIf


RestArea(aArea)
Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwPersonalData³ Autor ³Rogerio Augusto     ³Data ³17.11.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³Juliana Barros Mariano 04.03.2005					            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna os dados pessoais completos do participante           ³±±
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
WSMETHOD BrwPersonalData WSRECEIVE UserCode, ParticipantID WSSEND PersonalInfo WSSERVICE RHIdentify

Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local cFilial 		:= xFilial( "RD0" )
Local cCodAval 		:= ""
//Local totalMeses 	:= 0
//Local mesesAno1 	:= 0
//Local anoInicio 	:= 0
//Local anoAtual 		:= 0
//Local totalAnos 	:= 0
//Local mesesAnoAtual := 0
//Local dData 		:= date()
Local aCombo 		:= {}
Local nI            := 0
Local aRet			:= {}
Local aParam 		:= {}
Local aAux        := {}
Local aAuxParams   := {}

dbSelectArea("RD0")
dbSetOrder(1)

	   	If RD0->(dbSeek(cFilial+::ParticipantID,.T.))
	   	//---------{ se localizou o participante, armazena no retorno os dados disponiveis na RD0
		    //---------{ dados pessoais
			::PersonalInfo:ParticipantID		:= RD0->RD0_CODIGO
			::PersonalInfo:ParticipantName		:= RD0->RD0_NOME
			::PersonalInfo:ParticipantDataNasc 	:= RD0->RD0_DTNASC
			::PersonalInfo:ParticipantCPF		:= RD0->RD0_CIC
			::PersonalInfo:ParticipantMail		:= RD0->RD0_EMAIL
			::PersonalInfo:ParticipantAdress 	:= RD0->RD0_END
			::PersonalInfo:ParticipantCompl		:= RD0->RD0_CMPEND
			::PersonalInfo:ParticipantZone		:= RD0->RD0_BAIRRO
			::PersonalInfo:ParticipantCity		:= RD0->RD0_MUN
			::PersonalInfo:ParticipantState		:= RD0->RD0_UF
			::PersonalInfo:ParticipantZIP		:= RD0->RD0_CEP
			::PersonalInfo:ParticipantPhoCode 	:= RD0->RD0_DDD
			::PersonalInfo:ParticipantPhone		:= RD0->RD0_FONE
			::PersonalInfo:ParticipantCel		:= RD0->RD0_NUMCEL
			::PersonalInfo:LastUpdate			:= RD0->RD0_DTALT		//Data da ultima alteracao
			//---------}

			//---------{ dados organizacionais

			//---------{ Estes campos criados na RD0 em novembro 2004
		   	::PersonalInfo:ParticipantComPhoCode 	:= RD0_DDDCOM		//Codigo DDD comercial
			::PersonalInfo:ParticipantComPhone 		:= RD0_TELCOM		//Telefone comercial
			::PersonalInfo:ParticipantComCel 		:= RD0_CELCOM		//Celular comercial
			::PersonalInfo:ParticipantComMail 		:= RD0_EMAILC		//E-mail comercial
			::PersonalInfo:ParticipantTrvlSelected 	:= RD0_DVIAGE		//Disponibilidade p/ viagens - fevereiro 2005
			//---------}
			
			If RD0->(FieldPos("RD0_TPDEFF")) > 0
			::PersonalInfo:ParticipantDisbSelected 	:= RD0_TPDEFF		//PCD - Maio 2015(cicero.pereira)
			EndIf

			::PersonalInfo:ParticipantCC 			:= RD0->RD0_CC		//busca a descricao do centro de custo
			CTT->(dbSeek(cFilial+RD0->RD0_CC))					 		// na tabela Centro de Custo (CTT)
			::PersonalInfo:ParticipantCCD 			:= CTT->CTT_DESC01	//______________________________________

			RD0->(dbSeek(cFilial+RD0->RD0_CODMEN))	           			//busca o nome do mentor
			::PersonalInfo:ParticipantMen 			:= RD0->RD0_NOME   //_______________________

																	 	//busca relacao entre o ID e o Codigo do funcionario
			If Participant( ::PersonalInfo:ParticipantID, aRet )		//!Empty(EntGetInfo("SRA","RA_MAT",::PersonalInfo:ParticipantID, ,xFilial("SRA")))	//na tabela de Funcionarios (SRA)
				::PersonalInfo:FindCPF := "S"							//____________________________________________________
				::PersonalInfo:ParticipantMat 		:= aRet[1] 			//SRA->RA_MAT
				::PersonalInfo:ParticipantRG 		:= aRet[4] 			//SRA->RA_RG
				::PersonalInfo:ParticipantDate 		:= aRet[5] 			//SRA->RA_ADMISSA

				//---------{ Calculando o total de meses de casa
/*
				mesesAno1 		:= iif((12 - val(substr(dtoc(::PersonalInfo:ParticipantDate),4,2))) == 0, mesesAno1 := 1, 12 - val(substr(dtoc(::PersonalInfo:ParticipantDate),4,2)) )
				mesesAnoAtual 	:= val(substr(dtoc(dData),4,2))
				anoInicio 		:= year(::PersonalInfo:ParticipantDate)
				anoAtual 		:= year(dData)
				If (anoInicio == anoAtual)
					totalMeses := mesesAno1 - MesesAnoAtual
				Else
					totalAnos 	:= anoAtual - anoInicio
					totalMeses 	:= (mesesAno1 + mesesAnoAtual) + ((totalAnos - 1) * 12)
				EndIf
				::PersonalInfo:ParticipantEmpTime := str(totalMeses)
*/
				::PersonalInfo:ParticipantEmpTime := AllTrim(STR(Int((DATE() - aRet[5])/30))) //AllTrim(STR(Int((DATE() - SRA->RA_ADMISSA)/30))) //CONSULTA APENAS A QUANTIDADE DE MESES
				::PersonalInfo:ParticipantCargo := ""
				::PersonalInfo:ParticipantDCargo := ""
				::PersonalInfo:ParticipantDetalheCargo :=""

				//---------}
				If ExistBlock("DADOSFUNC")

					aAdd(aAuxParams, "")
					aAdd(aAuxParams, "")
					aAdd(aAuxParams, "")
					aAdd(aAuxParams, ::PersonalInfo:ParticipantID)

					aAux := U_DADOSFUNC( aAuxParams )

					if len(aAux) > 0
						::PersonalInfo:ParticipantPosit := aAux[1][5]
					else
						::PersonalInfo:ParticipantPosit := ""
					endif
				Else
					::PersonalInfo:ParticipantPosit := FDesc("SRJ",aRet[6],"SRJ->RJ_DESC",30) //aRet[6]=SRA->RA_CODFUNC
					::PersonalInfo:ParticipantCargo := aRet[7] //cargo
					::PersonalInfo:ParticipantDCargo := FDesc("SQ3",aRet[7],"SQ3->Q3_DESCSUM",30) 
					::PersonalInfo:ParticipantDetalheCargo := APDMSMM(FDesc("SQ3",aRet[7],"SQ3->Q3_DESCDET",30),,,,3)
				
				EndIf

				RDV->(dbSetOrder(1))		 						  //busca o codigo do avaliador na RDV
				RDV->(dbSeek(cFilial+ParticipantID))				 // e armazena o nome
				cCodAval := RDV->RDV_CODDOR						    //
				RD0->(dbSeek(cFilial+cCodAval))	                   //
				::PersonalInfo:ParticipantEval := RD0->RD0_NOME  //______________________________________


				// Abrir tabelas SR3 e SR7 de outro local
				If ExistBlock("WSHISTSAL")
					ExecBlock("WSHISTSAL",.F.,.F.)
				EndIf

				//PARA PEGAR DADOS DA ACAO SALARIAL E PROMOCOES
				SX6->( dbSetOrder(1) )
				If SX6->( dbSeek(xFilial("SX6")+"MV_ACAOSAL") )
					aParam := Separa(SX6->X6_CONTEUD,",")
					SR7->( dbSetOrder(1) )
					If SR7->( dbSeek(aRet[3]+aRet[1]) ) //Filial+matricula
						//FAZ LACO PARA PEGAR ULTIMA DATA DE ACAO SALARIAL
						While !SR7->(EOF()) .And. aRet[3] == SR7->R7_FILIAL .And. aRet[1] == SR7->R7_MAT
							//verifica se tipo esta na lista dos tipos relacionados no parametro de acoes salariais
							If ascan(aParam, SR7->R7_TIPO) > 0
								If ::PersonalInfo:WageDate < SR7->R7_DATA .Or. Empty(::PersonalInfo:WageDate)
									::PersonalInfo:WageDate			:= SR7->R7_DATA
									::PersonalInfo:TimeNoWage		:= AllTrim(STR(Int((DATE() - SR7->R7_DATA)/30))) //CONSULTA APENAS A QUANTIDADE DE MESES
									SX5->( dbSetOrder(1) )
									If SX5->( dbSeek( xFilial("SX5")+"41"+SR7->R7_TIPO ) )
										::PersonalInfo:WageType			:= SX5->X5_DESCRI
									EndIf
								EndIf
							EndIf
						SR7->( dbSkip() )
						EndDo
					EndIf
				EndIf

				//Se nao tiver nenhuma acao salarial pega dados da admissao
				If empty(::PersonalInfo:WageDate)
					::PersonalInfo:WageDate			:= aRet[5] //SRA->RA_ADMISSA
					::PersonalInfo:TimeNoWage		:= AllTrim(STR(Int((DATE() - aRet[5])/30))) //AllTrim(STR(Int((DATE() - SRA->RA_ADMISSA)/30))) //CONSULTA APENAS A QUANTIDADE DE MESES
					SX5->( dbSetOrder(1) )
					If SX5->( dbSeek( xFilial("SX5")+"41"+"001" ) ) //Salario Inicial
						::PersonalInfo:WageType		:= SX5->X5_DESCRI
					EndIf
				EndIf

				aParam := {}
				SX6->( dbSetOrder(1) )
				If SX6->( dbSeek(xFilial("SX6")+"MV_PROMSAL") )
					aParam := Separa(SX6->X6_CONTEUD,",")
					SR7->( dbSetOrder(1) )
					If SR7->( dbSeek(aRet[3]+aRet[1]) ) //Filial+matricula
						//FAZ LACO PARA PEGAR ULTIMA DATA DE ACAO SALARIAL
						While !SR7->(EOF()) .And. aRet[3] == SR7->R7_FILIAL .And. aRet[1] == SR7->R7_MAT
							//verifica se tipo esta na lista dos tipos relacionados no parametro de acoes salariais
							If ascan(aParam, SR7->R7_TIPO) > 0
								If ::PersonalInfo:PromotionDate < SR7->R7_DATA .Or. Empty(::PersonalInfo:PromotionDate)
									::PersonalInfo:PromotionDate	:= SR7->R7_DATA
									::PersonalInfo:TimeNoPromotion	:= AllTrim(STR(Int((DATE() - SR7->R7_DATA)/30))) //CONSULTA APENAS A QUANTIDADE DE MESES
								EndIf
							EndIf
					 		SR7->( dbSkip() )
						EndDo
					EndIf
				EndIf

				//Se nao tiver nenhuma promocao salarial pega dados da admissao
				If empty(::PersonalInfo:PromotionDate)
					::PersonalInfo:PromotionDate		:= aRet[5] //SRA->RA_ADMISSA
					::PersonalInfo:TimeNoPromotion	:= AllTrim(STR(Int((DATE() - aRet[5])/30))) //AllTrim(STR(Int((DATE() - SRA->RA_ADMISSA)/30))) //CONSULTA APENAS A QUANTIDADE DE MESES
				EndIf
				//--------------------------------------------------------

			Else
				::PersonalInfo:FindCPF := "N"
			EndIf
			//---------}

			aCombo := MontaCombo("RD0_DVIAGE", STR0006) //"Disponibilidade"

		   	for nI = 1 to len(aCombo)
				aAdd(::PersonalInfo:ParticipantTrvlCombo,WSClassNew('TravelDispOptions'))
				::PersonalInfo:ParticipantTrvlCombo[nI]:TravelOptionID := aCombo[nI][3]
				if ::PersonalInfo:ParticipantTrvlCombo[nI]:TravelOptionID == ::PersonalInfo:ParticipantTrvlSelected
					::PersonalInfo:ParticipantTrvlDescript := ::PersonalInfo:ParticipantTrvlCombo[nI]:TraveOptionDescription := aCombo[nI][4]
				endIf
				::PersonalInfo:ParticipantTrvlCombo[nI]:TraveOptionDescription := aCombo[nI][4]
			next
			
			If RD0->(FieldPos("RD0_TPDEFF")) > 0
				aCombo := {}
				aCombo := MontaCombo("RD0_TPDEFF", STR0006)
				
			   	for nI = 1 to len(aCombo)
					aAdd(::PersonalInfo:ParticipantDisbCombo,WSClassNew('DisabledPeopOptions'))
					::PersonalInfo:ParticipantDisbCombo[nI]:DisabledPeopleID := aCombo[nI][3]
					
					if ::PersonalInfo:ParticipantDisbCombo[nI]:DisabledPeopleID == ::PersonalInfo:ParticipantDisbSelected
						::PersonalInfo:ParticipantDisbDescript := ::PersonalInfo:ParticipantDisbCombo[nI]:DisabledPeopleDescription := aCombo[nI][4]
					endIf				
					::PersonalInfo:ParticipantDisbCombo[nI]:DisabledPeopleDescription := aCombo[nI][4]
				next nI
			EndIf

		//---------}
	   	Else
			lRetorno := .F.
			SetSoapFault("BrwPersonalData",STR0007) //"Participante não encontrado"
	  	EndIf

RestArea(aArea)
Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutPersonalData³ Autor ³Rogerio Augusto     ³Data ³09.11.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza as informacoes corrigidas pelo usuario			    ³±±
±±³          ³				                                                ³±±
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
WSMETHOD PutPersonalData WSRECEIVE UserCode, PersonalInfo WSSEND Visions WSSERVICE RHIdentify

Local aArea     := GetArea()
Local lRetorno  := .T.
Local cFilial 	:= xFilial( "RD0" )
Local aAuxParams := {}

dbSelectArea("RD0")
dbSetOrder(1)

	   	If RD0->(dbSeek(xFilial("RD0")+::PersonalInfo:ParticipantID,.T.))

			Reclock("RD0",.F.)
				RD0->RD0_FONE	:= ::PersonalInfo:ParticipantPhone
				RD0->RD0_DDD	:= ::PersonalInfo:ParticipantPhoCode
				RD0->RD0_NUMCEL	:= ::PersonalInfo:ParticipantCel
				RD0->RD0_EMAIL	:= ::PersonalInfo:ParticipantMail
				RD0->RD0_TELCOM	:= ::PersonalInfo:ParticipantComPhone
				RD0->RD0_CELCOM	:= ::PersonalInfo:ParticipantComCel
				RD0->RD0_DDDCOM	:= ::PersonalInfo:ParticipantComPhoCode
				RD0->RD0_DVIAGE	:= ::PersonalInfo:ParticipantTrvlSelected
				RD0->RD0_DTALT	:= date()
				
				If RD0->(FieldPos("RD0_TPDEFF")) > 0
					RD0->RD0_TPDEFF := ::PersonalInfo:ParticipantDisbSelected
				EndIf
				
			RD0->(MsUnlock())

				if ExistBlock("ATUDADOSFUNC")

					aAdd(aAuxParams, ::PersonalInfo:ParticipantID)
					aAdd(aAuxParams, ::PersonalInfo:ParticipantPhone)
					aAdd(aAuxParams, ::PersonalInfo:ParticipantCel)
					aAdd(aAuxParams, ::PersonalInfo:ParticipantMail)
					aAdd(aAuxParams, ::PersonalInfo:ParticipantTrvlSelected)
					aAdd(aAuxParams, ::PersonalInfo:ParticipantComPhone)
					aAdd(aAuxParams, ::PersonalInfo:ParticipantComCel)

					If RD0->(FieldPos("RD0_TPDEFF")) > 0
						aAdd(aAuxParams, ::PersonalInfo:ParticipantDisbSelected)
					EndIf

					if !U_ATUDADOSFUNC( aAuxParams )
						lRetorno := .F.
						SetSoapFault("PutPersonalData",STR0008) //"Participante não encontrado no cadastro de funcionários."
					endif
				else
			SRA->( dbSetOrder(1) )
			If SRA->(dbSeek( ::PersonalInfo:ParticipantFilial+::PersonalInfo:ParticipantMatr ))
				Reclock("SRA",.F.)
				SRA->(RA_TELEFON) := RD0->RD0_DDD + "" + RD0->RD0_FONE
				SRA->(MsUnlock())
			Else
				lRetorno := .F.
				SetSoapFault("PutPersonalData",STR0008) //"Participante não encontrado no cadastro de funcionários."
			EndIf
				endif
	   	Else
			lRetorno := .F.
			SetSoapFault("PutPersonalData",STR0009) //"Não foi possível atualizar os dados"
	  	EndIf

RestArea(aArea)
Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwWageHistory ³ Autor ³Rogerio Augusto     ³Data ³29.11.2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna o historico de acoes salariais do participante        ³±±
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
WSMETHOD BrwWageHistory WSRECEIVE UserCode, ParticipantID WSSEND WageHistory WSSERVICE RHIdentify

Local aArea     := GetArea()
Local lRetorno  := .T.
Local cFilial 	:= xFilial( "RD0" )
Local aColsSR7 	:= {}
Local aColsSR3 	:= {}
Local aSR7Header:= {}
Local aSR3Header:= {}
Local cChave 	:= ""
Local cChaveSR3 := ""
Local cCodigo 	:= ""
Local nI 		:= 1
Local nP 		:= 1
Local aRet 		:= {} //retorno da consulta de funcionario
Local aParams  := {}
Local oHistSal
Local nQtdHsal := 0
Local nElem    := 0
Local aTmp 		:= {}

Local nPosDataSr3 := 0
Local nPosTipoSr3 := 0
Local nPosDescSr3 := 0
Local nPosValrSr3 := 0
Local nPosSeqSr3  := 0

Local nPosDataSr7 := 0
Local nPosTipoSr7 := 0
Local nPosFuncSr7 := 0
Local nPosTPgtSr7 := 0
Local nPosCateSr7 := 0
Local nPosSeqSr7  := 0


dbSelectArea("RD0")
dbSetOrder(1)

	   	If RD0->(dbSeek(cFilial+::ParticipantID,.T.))
	   	cCodigo := RD0->RD0_CODIGO
	   	::WageHistory:ParticipantName := RD0->RD0_NOME
	   	//---------{ se localizou o participante, armazena no retorno os dados disponiveis na RD0
	   																	     //busca relacao entre o ID e o Codigo do funcionario
			If Participant( ::ParticipantID, aRet )//!Empty(EntGetInfo("SRA","RA_MAT",cCodigo, ,xFilial("SRA")))	//na tabela de Funcionarios (SRA)
				::WageHistory:FindCPF := "S"							   //____________________________________________________
				::WageHistory:ParticipantMat := aRet[1]//SRA->RA_MAT
				::WageHistory:ParticipantID := ::ParticipantID

				if ExistBlock("DADOSFUNC")

					aAdd(aParams, "")
					aAdd(aParams, "")
					aAdd(aParams, "")
					aAdd(aParams, ::ParticipantID)

					aAux := U_DADOSFUNC( aParams )

					if len(aAux) > 0
						oHistSal := aAux[1][10]

		           	if valtype(oHistSal) == "A"
							nQtdHsal := len(oHistSal)
						else
							nQtdHsal := XmlChildCount( oHistSal )
						endif

						if nQtdHsal > 0
							for nElem := 1 to nQtdHsal
								cAuxData	:= substr(oHistSal[nElem]:_DTMUDANCA:TEXT,9,2) + "/" +;
												substr(oHistSal[nElem]:_DTMUDANCA:TEXT,6,2) + "/" +;
												substr(oHistSal[nElem]:_DTMUDANCA:TEXT,1,4)

			   				aAdd(::WageHistory:WHHeader,WSClassNew('WageHistoryHeader'))
								::WageHistory:WHHeader[nElem]:WHDate        := CTOD(cAuxData)
								::WageHistory:WHHeader[nElem]:WHTypeCod     := oHistSal[nElem]:_MOTIVO:TEXT
								::WageHistory:WHHeader[nElem]:WHTypeDes     := ""
								::WageHistory:WHHeader[nElem]:WHFunctionCod := ""
								::WageHistory:WHHeader[nElem]:WHPayType     := ""
								::WageHistory:WHHeader[nElem]:WHFunctionDes := ""
								::WageHistory:WHHeader[nElem]:WHEmpType     := ""
								::WageHistory:WHHeader[nElem]:WHSequenc     := ""

								aAdd(::WageHistory:WHData,WSClassNew('WageHistoryArray'))
								::WageHistory:WHData[nElem]:WDItem := {}
								aAdd(::WageHistory:WHData[nElem]:WDItem,WSClassNew('WageHistoryValues'))
								::WageHistory:WHData[nElem]:WDItem[1]:WDDate 	   := CTOD(cAuxData) //Data
								::WageHistory:WHData[nElem]:WDItem[1]:WDTypeCod 	:= oHistSal[nElem]:_MOTIVO:TEXT //Codigo do tipo do aumento
								::WageHistory:WHData[nElem]:WDItem[1]:WDTypeDes 	:= "" //Descricao do tipo do aumento - procurar
								::WageHistory:WHData[nElem]:WDItem[1]:WDValue 	   := val(oHistSal[nElem]:_NROSALARIO:TEXT) //Valor do aumento
								::WageHistory:WHData[nElem]:WDItem[1]:WDSequenc 	:= "" //Sequencia

							next nElem
						endif
					endif

				else
				// Abrir tabelas SR3 e SR7 de outro local
				If ExistBlock("WSHISTSAL")
					ExecBlock("WSHISTSAL",.F.,.F.)
				EndIf

				SR7->(DbSetOrder(2))
				cChave := ( aRet[3] + aRet[1] )//(SRA->RA_FILIAL+SRA->RA_MAT)
				aColsSR7 := GdMontaCols(@aSR7Header		,;	//01 -> Array com os Campos do Cabecalho da GetDados
										NIL				,;	//02 -> Numero de Campos em Uso
										NIL				,;	//03 -> [@]Array com os Campos Virtuais
										NIL				,;	//04 -> [@]Array com os Campos Visuais
										"SR7"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
										NIL				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
										NIL				,;	//07 -> [@]Array unidimensional contendo os Recnos
										"SR7"			,;	//08 -> Alias do Arquivo Pai
										cChave			,;	//09 -> Chave para o Posicionamento no Alias Filho
										NIL				,;	//10 -> Bloco para condicao de Loop While
										NIL				,;	//11 -> Bloco para Skip no Loop While
										.F.				,;	//12 -> Se Havera o Elemento de Delecao no aCols
										.F.				,;	//13 -> Se cria variaveis Publicas
										.F.				,;	//14 -> Se Sera considerado o Inicializador Padrao
										NIL				,;	//15 -> Lado para o inicializador padrao
										.T.				,;	//16 -> Se carregara todos os campos no aHeader
										.T.				,;	//17 -> Nao Carregar os Campos Virtuais
										NIL				,;	//18 -> Opcional, Utilizacao de Query para Selecao de Dados
										.T.				,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
										.T.				,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
										.F.				,;	//21 -> Carregar Coluna Fantasma
										.F.				,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
										.F.				,;	//23 -> Verifica se Deve verificar se o campo eh usado
										.F.				,;	//24 -> Verifica se Deve verificar o nivel do usuario
										.F.				,;	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
										NIL				,;	//26 -> [@]Array que contera as chaves conforme recnos
										.F.				,;	//27 -> [@]Se devera efetuar o Lock dos Registros
										.F.				,;	//28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
										NIL				,;	//29 -> Numero maximo de Locks a ser efetuado
										.F.				 ;	//30 -> Utiliza Numeracao na GhostCol
									   )

				nPosDataSr7 := GdFieldPos("R7_DATA", aSR7Header) 	//3
				nPosTipoSr7	:= GdFieldPos("R7_TIPO", aSR7Header) 	//5
				nPosFuncSr7	:= GdFieldPos("R7_FUNCAO", aSR7Header)	//6
				nPosTPgtSr7	:= GdFieldPos("R7_TIPOPGT", aSR7Header)	//8
				nPosCateSr7	:= GdFieldPos("R7_CATFUNC", aSR7Header)	//9
				nPosSeqSr7	:= GdFieldPos("R7_SEQ", aSR7Header)			

				for nI := 1 to len(aColsSR7)
	   				aAdd(::WageHistory:WHHeader,WSClassNew('WageHistoryHeader'))
					::WageHistory:WHHeader[nI]:WHDate := aColsSR7[nI][nPosDataSr7] //Data
					::WageHistory:WHHeader[nI]:WHTypeCod := aColsSR7[nI][nPosTipoSr7] //Codigo do tipo do aumento
					::WageHistory:WHHeader[nI]:WHSequenc := aColsSR7[nI][nPosSeqSr7] //Sequencia					
					If SX5->(dbSeek(cFilial+"41"+aColsSR7[nI][nPosTipoSr7],.T.))
						::WageHistory:WHHeader[nI]:WHTypeDes := SX5->(X5_DESCRI) //Descricao do tipo do aumento
					EndIf
					::WageHistory:WHHeader[nI]:WHFunctionCod := aColsSR7[nI][nPosFuncSr7] //Codigo da funcao
					If SX5->(dbSeek(cFilial+"40"+aColsSR7[nI][nPosTPgtSr7],.T.))
						::WageHistory:WHHeader[nI]:WHPayType := SX5->(X5_DESCRI) //Tipo de pagamento
					EndIf
					::WageHistory:WHHeader[nI]:WHFunctionDes := FDesc("SRJ",aColsSR7[nI][nPosFuncSr7],"SRJ->RJ_DESC",30) //Descricao da funcao
					If SX5->(dbSeek(cFilial+"28"+aColsSR7[nI][nPosCateSr7],.T.))
						::WageHistory:WHHeader[nI]:WHEmpType := SX5->(X5_DESCRI) //Categoria do funcionario
					EndIf
				next nI
				dbSelectArea("SR3")
				dbSetOrder(1)
				for nI := 1 to len(aColsSR7)
					cChaveSR3 := ( (aRet[3]+aRet[1]+DTOS(aColsSR7[nI][nPosDataSr7])+aColsSR7[nI][nPosTipoSr7] ))//(SRA->RA_FILIAL+SRA->RA_MAT+DTOS(aColsSR7[nI][3])) //DTOS(SR7->R7_DATA)
					aTmp := GdMontaCols(	@aSR3Header		,;	//01 -> Array com os Campos do Cabecalho da GetDados
												NIL				,;	//02 -> Numero de Campos em Uso
												NIL				,;	//03 -> [@]Array com os Campos Virtuais
												NIL				,;	//04 -> [@]Array com os Campos Visuais
												"SR3"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
												NIL				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
												NIL				,;	//07 -> [@]Array unidimensional contendo os Recnos
												"SR3"			,;	//08 -> Alias do Arquivo Pai
												cChaveSR3		,;	//09 -> Chave para o Posicionamento no Alias Filho
												NIL				,;	//10 -> Bloco para condicao de Loop While
												NIL				,;	//11 -> Bloco para Skip no Loop While
												.F.				,;	//12 -> Se Havera o Elemento de Delecao no aCols
												.F.				,;	//13 -> Se cria variaveis Publicas
												.F.				,;	//14 -> Se Sera considerado o Inicializador Padrao
												NIL				,;	//15 -> Lado para o inicializador padrao
												.T.				,;	//16 -> Se carregara todos os campos no aHeader
												.T.				,;	//17 -> Nao Carregar os Campos Virtuais
												NIL				,;	//18 -> Opcional, Utilizacao de Query para Selecao de Dados
												.T.				,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
												.T.				,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
												.F.				,;	//21 -> Carregar Coluna Fantasma
												.F.				,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
												.F.				,;	//23 -> Verifica se Deve verificar se o campo eh usado
												.F.				,;	//24 -> Verifica se Deve verificar o nivel do usuario
												.F.				,;	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
												NIL				,;	//26 -> [@]Array que contera as chaves conforme recnos
												.F.				,;	//27 -> [@]Se devera efetuar o Lock dos Registros
												.F.				,;	//28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
												NIL				,;	//29 -> Numero maximo de Locks a ser efetuado
												.F.				;	//30 -> Utiliza Numeracao na GhostCol
											   )	
					If !Empty(aTmp)
						aAdd (aColsSR3,	aTmp)
					Else
						lRetorno := .F.
						SetSoapFault("PUTEVALUATE","Inconsistencia na base de dados nas tabelas SR7/SR3")
						exit 
					EndIf
					aTmp := {}
				next nI
				::WageHistory:WHData := {}

				nPosDataSr3 := GdFieldPos("R3_DATA", aSR3Header) 	//3
				nPosTipoSr3 := GdFieldPos("R3_TIPO", aSR3Header)  	//5
				nPosDescSr3 := GdFieldPos("R3_DESCPD", aSR3Header) 	//7
				nPosValrSr3 := GdFieldPos("R3_VALOR", aSR3Header)  	//8
				nPosSeqSr3  := GdFieldPos("R3_SEQ", aSR3Header)  	

				for nI := 1 to len(aColsSR3)
					If !empty(aColsSR3[nI][1][nPosDataSr3]) //Data
						aAdd(::WageHistory:WHData,WSClassNew('WageHistoryArray'))
						::WageHistory:WHData[nI]:WDItem := {}
						for nP := 1 to len(aColsSR3[nI])
							aAdd(::WageHistory:WHData[nI]:WDItem,WSClassNew('WageHistoryValues'))
							::WageHistory:WHData[nI]:WDItem[nP]:WDDate 		:= aColsSR3[nI][nP][nPosDataSr3] //Data
							::WageHistory:WHData[nI]:WDItem[nP]:WDTypeCod 	:= aColsSR3[nI][nP][nPosTipoSr3] //Codigo do tipo do aumento
							::WageHistory:WHData[nI]:WDItem[nP]:WDTypeDes 	:= aColsSR3[nI][nP][nPosDescSr3] //Descricao do tipo do aumento - procurar
							::WageHistory:WHData[nI]:WDItem[nP]:WDValue 	:= aColsSR3[nI][nP][nPosValrSr3] //Valor do aumento
							::WageHistory:WHData[nI]:WDItem[nP]:WDSequenc 	:= aColsSR3[nI][nP][nPosSeqSr3]  //Sequencia
						next nP
					Endif
				next nI
				endif
			Else
				::WageHistory:FindCPF := "N"
			EndIf
		//---------}
	   	Else
			lRetorno := .F.
			SetSoapFault("PUTEVALUATE","Teste")
	  	EndIf

RestArea(aArea)
Return(lRetorno)


function wsapd011_xxx()
return
