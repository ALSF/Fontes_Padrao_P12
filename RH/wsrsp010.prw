#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSRSP010.CH"
#INCLUDE "SHELL.CH"  
#DEFINE PAGE_LENGTH 10

Static lRFC  := cPaisLoc == "MEX" .And. SQG->( FieldPos( "QG_PRINOME" ) # 0 )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSRSP010  ³ Autor ³Emerson Grassi Rocha   	      ³ Data ³20/04/2004  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pela manutencao de Curriculos.	   		  	  ³±±
±±³          ³                                                         			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH			                                    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS 		   ³  Motivo da Alteracao              		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson G.R.  ³08/08/05³085013	  	   ³Criacao de Parametros para envio de e-mail³±±
±±³				 ³		  ³		           ³MV_RHCONTA, MV_RHSENHA e MV_RHSERV.		  ³±±
±±³Emerson G.R.  ³17/07/06³103000          ³Alteracao dos nomes de pontos de entrada. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³ Data   ³ FNC        	   ³   Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson Campos|30/04/14|TPKFN9     |Replica das alterações realizadas pela    	  ³±±
±±³              |        |           |manutenção até a data de 28/04/14 chamado 	  ³±± 
±±³              |        |           |TPIKKB, changeset 223414 na P11.80        	  ³±±
±±³              |        |           |Remoção de alguns fieldpos e findfunctions  	  ³±±  
±±³Emerson Campos|23/05/14|TQETRU     |Inclusao do campo Tipo de currículo            ³±±
±±³Everson Sp jr |04/12/14|TRCXBV   	   |Criada nova chave no SXE e SXF para gerar ³±±
±±³              |        |      		   |a numeração sequencial da tabela de curri-³±±
±±³              |        |      		   |culos corretamente.                       ³±±
±±³Cícero Alves  |08/05/15|TSGJH2	  |Adionado o tipo de Curriculo "Aprendiz"        ³±±
±±³			     |		  |	   		  |Definido "não" como resposta padrão para o 	  ³±±
±±³			     |		  |	   		  |campo PcD - Pessoa com Deficiência 			  ³±±
±±³Henrique V.   |15/06/15|TSHMQG	  |Ajuste na query da tabela "SQL", mudado o alias³±±
±±³			     |		  |	   		  |da query pois em banco de dados INFORMIX, a pal³±±
±±³			     |		  |	   		  |avra SQL é de uso reservado, gerando erro 	  ³±±
±±³Tiago Malta   |24/08/15|PCREQ-4824 |Ajustes no controle de alterações e consultas  ³±±
±±³			     |		  |	   		  |de dicionarios para utilização na versão 12.   ³±±
±±³		         |		  |	          |Changeset 308512 Data 15/06/2015               ³±±
±±³Matheus M.    |01/02/16|TTWWGB     |Realizado ajuste para que o candidato possa    ³±±
±±³			     |		  |	   		  |efetuar a inscrição quando o teste possuir     ³±±
±±³			     |		  |	   		  |questões dissertativas.					      ³±±
±±³Oswaldo L.	 |15/05/17|DRHPONTP-524    |Ajuste localizao campos Memo no Portal Candidato    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service 						                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RhCurriculum DESCRIPTION STR0008 //"Cadastro de Candidatos <b>(Curriculo)</b>"

	WSDATA UserCode          		AS String
	WSDATA CurricCpf				AS String
	WSDATA CurricPass				AS String OPTIONAL
	WSDATA nTipo					AS Integer OPTIONAL
	WSDATA NewPass					AS String OPTIONAL

	WSDATA Header           		AS Array Of BrwHeader
	WSDATA HeaderName        		AS String

	WSDATA Curric		   			AS Curriculum OPTIONAL
	WSDATA Curric1					AS Curriculum1 OPTIONAL
	WSDATA CurricNum				AS String

	WSDATA Personal					As Pers OPTIONAL
	WSDATA Alias					As String
	WSDATA Field					As String
	WSDATA FieldObj          		As UserField
	
	WSDATA ListOfCoursesCurriculum	As Array of CoursesCurriculum OPTIONAL		//Cursos do Curriculo (SQT)
	WSDATA ListOfEntity				As Array of Entity OPTIONAL					//Entidade do Curso (Treinamento)
	WSDATA ListOfCity				As Array of City OPTIONAL
	
	WSDATA ListOfTestTypes 			As Array of TestTypes OPTIONAL      		//Tipo de testes	
	WSDATA EvaluationData			AS TEvaluationsData							//Estrutura Itens de Avaliacoes 	
    
	WSDATA ScheduleData				AS TScheduleData

	WSDATA Page				  		AS Integer OPTIONAL
	WSDATA Type				  		AS Integer OPTIONAL
	WSDATA Search            		AS String OPTIONAL                                                        
   
	WSDATA CodAval           		AS String OPTIONAL		//Codigo da avaliacao utilizado no GetAssessMent
	WSDATA FinalScore        		AS Integer OPTIONAL		//Total de Pontos da avaliacao 
	
	WSDATA CurricCode				AS String   OPTIONAL
	WSDATA CurrentPage				AS Integer 	OPTIONAL 	
	WSDATA FilterField  			AS String 	OPTIONAL
	WSDATA FilterValue				AS String 	OPTIONAL
	
	WSDATA VacancyCode				AS String   OPTIONAL	
	
	WSDATA NewNameFile				AS String   OPTIONAL
	
	WSDATA WsNull            		AS String
	
	WSDATA NmAlias            		AS String   OPTIONAL
	WSDATA NmField            		AS String   OPTIONAL
	WSDATA ExistField            	AS boolean   OPTIONAL
	
	WSDATA PatchObject				AS String   OPTIONAL
	WSDATA DescObject				AS String   OPTIONAL
	WSDATA Branch					As String   OPTIONAL
	WSDATA CodObj					As String   OPTIONAL
	WSDATA FilEnt					As String   OPTIONAL	
	WSDATA CodEnt					AS String 	OPTIONAL
	WSDATA Table					AS String   OPTIONAL
	
	WSDATA ObjectBrowse   			As TObjectBrowse
	WSDATA ObjectConfigField		As TObjectConfigField

    WSMETHOD GetCurriculum  		DESCRIPTION STR0009 //"Método de visualização do Curriculo"
    WSMETHOD SetCurriculum 			DESCRIPTION STR0010 //"Método de inclusão/alteração do Curriculo"
    WSMETHOD GetEmail		   		DESCRIPTION STR0011 //"Metodo para consulta de E-mail"
    WSMETHOD GetEmail2				DESCRIPTION STR0012 //"Metodo para envio de E-mail"
	WSMETHOD X3Fields				DESCRIPTION STR0029	//"Método para retorno de informações de campo"
	
	WSMETHOD BrwCourse				DESCRIPTION STR0030 //"Metodo para consulta de cursos"
	WSMETHOD BrwEntity				DESCRIPTION STR0031 //"Metodo para consulta de entidades"
	WSMETHOD BrwCity				DESCRIPTION STR0031 //"Metodo para consulta de entidades"
	WSMETHOD GetAssessMent	   		DESCRIPTION STR0033	//"Método responsável por retornar as questões e alternativas da avaliação."
	WSMETHOD SetAssessMent			DESCRIPTION STR0034	//"Método responsável por gravar as questões e alternativas da avaliação na tabela SQR."
	WSMETHOD GetSchedule			DESCRIPTION STR0035 //"Método responsável por retornar as vagas que consta na agenda do candidato." 
	WSMETHOD GetActivity			DESCRIPTION STR0036 //"Método responsável por retornar os detalhes da vaga que consta na agenda do candiato."
	WSMETHOD SetAnexo				DESCRIPTION STR0049 //"Método responsável por Incluir um novo anexo do candidato" 
	WSMETHOD GetInfoAnexo			DESCRIPTION STR0050	//"Método responsável por apresentar os dados dos anexos do candidato"
	WSMETHOD DelAnexo				DESCRIPTION STR0051 //"Método responsável por Excluir um anexo do candidato"
	WSMETHOD GetConfigField			DESCRIPTION STR0052 //"Método responsável por retornar as configurações salvas na tabela RS1"
	WSMETHOD ValidFieldPos			DESCRIPTION STR0057 //"Método responsável por retornar verdadeiro ou falso se um determinado campo existir na base ou não" 
ENDWSSERVICE
 
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetCurriculum ³Autor  ³ Emerson Grassi Rocha  ³ Data ³22/04/2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de Manutencao dos dados do Curriculo.		           	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     	   ³±±
±±³			 ³ExpC2: CPF	 			                                  	   ³±±
±±³			 ³ExpC3: Senha	 			                                  	   ³±±
±±³			 ³ExpN1: Tipo ( 1-Inclusao, 2-Atualizacao, 3-Visualizacao)     	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve a tabela de Curriculos conforme a estrutura  ³±±
±±³          ³da mesma                                                    	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                  	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetCurriculum WSRECEIVE UserCode,CurricCpf,CurricPass,nTipo,NewPass WSSEND Curric WSSERVICE RhCurriculum

Local aArea    	:= GetArea()
Local lRetorno	:= .T.
Local cChave	:= ""
Local cChave2	:= ""
Local cDescrCourse := ""
Local nx		:= 0
Local nY		:= 0
Local cTipo		:= ""
Local aCombo	:= {} 
Local aRetCampo := ExisteCampo("QM_DCURSO",.F.,.F.,.T.)

//Variaveis de Indice Temporario
Local cArqSQM
Local nIndSQM
Local cArqSQL
Local nIndSQL
Local cIndCond

Local cQuery 	:= ""
Local aSQLFields	:= {}
Local nSQLFields	:= 0
Local cQrySQLFields	:= ""
local cRS6Alias		:= GetNextAlias()

Local aSQMFields	:= {}
Local nSQMFields	:= 0
Local cQrySQMFields	:= ""
Local cQrySQG		:= ""
Local cSQGAlias		:= ""
Local aSQGCurric	:= {}
Local cCodCurric	:= ""
Local lBusCV		:= .F.
Local nC	

Local lWSRS10SEL 	:= ExistBlock("WSRS10SEL")

Local cBloqTpCur	:= SuperGetMv("MV_BLOQCPC",Nil,"")
Local lMunNasc 		:= SQG->(ColumnPos("QG_CODMUNN")) > 0 .and. SQG->(ColumnPos("QG_MUNNASC")) > 0
Local nAux			:= 0 

DEFAULT lRFC  := cPaisLoc == "MEX" .And. SQG->( FieldPos( "QG_PRINOME" ) # 0 )
DEFAULT NewPass := ""

// Utilizar Usuario "ADMINISTRADOR" para teste   // Retirar do programa
If ::UserCode=="ADMINISTRADOR" .Or. PrtChkUser(::UserCode,"RhCurriculum")
	::CurricCpf := fTrocaSql(::CurricCpf)
	::CurricPass := fTrocaSql(::CurricPass)
	If ::nTipo == 1 //Inclusao
	
		dbSelectArea("SQG")
		dbSetOrder(3)		//CPF
		If dbSeek(xFilial("SQG")+::CurricCpf)
			While SQG->( !Eof() .and. QG_FILIAL + QG_CIC == xFilial("SQG") + ::CurricCpf )
				If !Empty(cBloqTpCur) .and. SQG->QG_TPCURRI $ cBloqTpCur //Ignora tipos bloqueados
					SQG->(DbSkip())
					Loop
				EndIf
				//Força posicionamento em EOF para que não exiba dados do funcionário existente
				dbSeek(xFilial("SQG")+"00000000000")
				SetSoapFault(STR0032, STR0013) //"Erro" - "Candidato ja esta cadastrado, favor escolher opcao 'Atualização'"
				Return( .F. )								
			EndDo
			//Força posicionamento em EOF para que não exiba dados do funcionário existente
			dbSeek(xFilial("SQG")+"00000000000")
	    EndIf
	ElseIf ::nTipo == 2		//Atualizacao
		//Alterado para query em virtude da rotina de importação que possibilita a inclusão de mais de um curriculo por CPF - Projeto PRODAM
		cQrySQG := " SELECT * FROM "+RetSqlName("SQG")+" SQG "
		cQrySQG += " WHERE "
		cQrySQG += " QG_FILIAL = '" + xFilial("SQG")	+ "' AND "
		cQrySQG += " QG_CIC =    '" + ::CurricCpf 	 	+ "' AND "
		cQrySQG += " SQG.D_E_L_E_T_ = '' "
		
		cQrySQG   := ChangeQuery(cQrySQG)		
		cSQGAlias := GetNextAlias()
		
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySQG), cSQGAlias, .F., .T.)
		
		While (cSQGAlias)->(!Eof())
			If !Empty(cBloqTpCur) .and. (cSQGAlias)->QG_TPCURRI $ cBloqTpCur //Ignora tipos bloqueados
				(cSQGAlias)->(DbSkip())
				Loop
			EndIf			
			aAdd( aSQGCurric, { (cSQGAlias)->QG_FILIAL, (cSQGAlias)->QG_CURRIC, (cSQGAlias)->QG_TPCURRI } )
			(cSQGAlias)->(DbSkip())
		End
		(cSQGAlias)->(DbCloseArea())
		If Len(aSQGCurric) > 1
		
			If lWSRS10SEL
				cCodCurric := ExecBlock("WSRS10SEL", .F., .F., aSQGCurric )  
			EndIf
			
			For nC := 1 To Len(aSQGCurric)
				If aSQGCurric[nC][1]+aSQGCurric[nC][2] == cCodCurric
					lBusCV := .T.
				EndIf
			Next nC 
			If !Empty(cCodCurric) .And. lBusCV
			 
				DbSelectArea("SQG")
				DbSetOrder(1)	//CURRIC
				If dbSeek(cCodCurric)
					If 	( AllTrim(SQG->QG_SENHA) != AllTrim(::CurricPass) ) .Or.;
					( Len(AllTrim(SQG->QG_SENHA)) != Len(AllTrim(::CurricPass)) )
			
						SetSoapFault(STR0032,STR0004)//"Erro" - "Senha incorreta"
						Return( .F. )
						
			    	EndIf							
				EndIf
			Else 
			
				If lWSRS10SEL
					SetSoapFault(STR0032, STR0059) //"Erro" - "CPF não autorizado!"
					Return( .F. )
				Else				
					dbSelectArea("SQG")
					dbSetOrder(3)		//CPF
					If dbSeek(xFilial("SQG")+::CurricCpf)
						While SQG->( !Eof() .and. QG_FILIAL + QG_CIC == xFilial("SQG") + ::CurricCpf )
							If !Empty(cBloqTpCur) .and. SQG->QG_TPCURRI $ cBloqTpCur //Ignora tipos bloqueados
								SQG->(DbSkip())
								Loop
							EndIf
							If 	( AllTrim(SQG->QG_SENHA) != AllTrim(::CurricPass) ) .Or.;
							 	( Len(AllTrim(SQG->QG_SENHA)) != Len(AllTrim(::CurricPass)) )
				
								SetSoapFault(STR0032,STR0004)//"Erro" - "Senha incorreta"
								Return( .F. )
							Else
								Exit
							EndIf
						End
						If !(QG_FILIAL + QG_CIC == xFilial("SQG") + ::CurricCpf) //Se for diferente é porque não achou nenhum tipo de curriculo desbloqueado
							//Posiciona em EOF para não carregar dados incorretos
							dbSeek(xFilial("SQG")+"00000000000")
						EndIf
					Else
						SetSoapFault(STR0032, STR0014) //"Erro" - "Candidato nao esta cadastrado, favor escolher opcao 'Inclusão'"
						Return( .F. )
				    EndIf
				EndIf			
			EndIf
								
		Else
			dbSelectArea("SQG")
			dbSetOrder(3)		//CPF
			If dbSeek(xFilial("SQG")+::CurricCpf)
				While SQG->( !Eof() .and. QG_FILIAL + QG_CIC == xFilial("SQG") + ::CurricCpf )
					If !Empty(cBloqTpCur) .and. SQG->QG_TPCURRI $ cBloqTpCur //Ignora tipos bloqueados
						SQG->(DbSkip())
						Loop
					EndIf
					If 	( AllTrim(SQG->QG_SENHA) != AllTrim(::CurricPass) ) .Or.;
					 	( Len(AllTrim(SQG->QG_SENHA)) != Len(AllTrim(::CurricPass)) )
		
						SetSoapFault(STR0032,STR0004)//"Erro" - "Senha incorreta"
						Return( .F. )
					Else
						Exit
					EndIf
				End
				If !(QG_FILIAL + Alltrim(QG_CIC) == xFilial("SQG") + Alltrim(::CurricCpf)) //Se for diferente é porque não achou nenhum tipo de curriculo desbloqueado
						//Posiciona em EOF para não carregar dados incorretos
					dbSeek(xFilial("SQG")+"00000000000")
				EndIf
			Else
				SetSoapFault(STR0032, STR0014) //"Erro" - "Candidato nao esta cadastrado, favor escolher opcao 'Inclusão'"
				Return( .F. )
		    EndIf
		    		    
		EndIf
		
	ElseIf ::nTipo == 3		//Visualizacao
	
		//Mudar para query
      	dbSelectArea("SQG")
		dbSetOrder(3)		//CPF
		If ! dbSeek(xFilial("SQG")+::CurricCpf)
			SetSoapFault(STR0032, STR0014) //"Erro" - "Candidato nao esta cadastrado, favor escolher opcao 'Inclusão'"
			Return( .F. )
	    EndIf
	ElseIf ::nTipo == 4		//Confirmar Senha
      	dbSelectArea("SQG")
		dbSetOrder(3)		//CPF
		If ! dbSeek(xFilial("SQG")+::CurricCpf)
			SetSoapFault(STR0032, STR0014) //"Erro" - "Candidato nao esta cadastrado, favor escolher opcao 'Inclusão'"
			Return( .F. )
		Else
			If	( AllTrim(SQG->QG_SENHA) != AllTrim(::CurricPass) ) .Or.;
			 	( Len(AllTrim(SQG->QG_SENHA)) != Len(AllTrim(::CurricPass)) )

				SetSoapFault(STR0032,STR0004)//"Erro" - "Senha incorreta"
				Return( .F. )
			Else
				SQG->(Reclock("SQG",.F.))
					SQG->QG_SENHA := NewPass
				MsUnlock()
				Return( .T. )
			EndIf
	    EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados do Candidato													   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric1:Branch					:= SQG->QG_FILIAL			//Filial
	::Curric:Curric1:Curriculum 			:= SQG->QG_CURRIC			//Curriculo
	::Curric:Curric1:AreaCode				:= SQG->QG_AREA				//Area
	::Curric:Curric1:Name 					:= SQG->QG_NOME				//Nome do Candidato
	::Curric:Curric1:Address				:= SQG->QG_ENDEREC			//Endereco
	::Curric:Curric1:AddressComplement		:= SQG->QG_COMPLEM			//Complem
	::Curric:Curric1:Zone					:= SQG->QG_BAIRRO			//Bairro
	::Curric:Curric1:District				:= SQG->QG_MUNICIP			//Municip
	::Curric:Curric1:State					:= SQG->QG_ESTADO			//Estado
	::Curric:Curric1:ZipCode				:= SQG->QG_CEP				//Cep
	::Curric:Curric1:Phone					:= SQG->QG_FONE				//Fone
	::Curric:Curric1:Id						:= SQG->QG_RG				//RG
	::Curric:Curric1:Cpf					:= SQG->QG_CIC				//CPF
	::Curric:Curric1:EmployBookNr			:= SQG->QG_NUMCP			//Num CP
	::Curric:Curric1:EmployBookSr			:= SQG->QG_SERCP			//Serie CP
	::Curric:Curric1:EmployBookState		:= SQG->QG_UFCP				//UF CP
	::Curric:Curric1:DrivingLicense			:= SQG->QG_HABILIT			//Habilitacao
	::Curric:Curric1:ReservistCard			:= SQG->QG_RESERV			//Reservista
	::Curric:Curric1:VotingCard				:= SQG->QG_TITULOE			//Titulo Eleitor
	::Curric:Curric1:ElectoralDistrict		:= SQG->QG_ZONASEC			//Zona Eleitoral
	::Curric:Curric1:FathersName			:= SQG->QG_PAI				//Pai
	::Curric:Curric1:MothersName			:= SQG->QG_MAE	 			//Mae
	::Curric:Curric1:Gender					:= SQG->QG_SEXO				//Sexo
	::Curric:Curric1:MaritalStatus			:= SQG->QG_ESTCIV			//Estado Civil
	::Curric:Curric1:Origin					:= SQG->QG_NATURAL			//Naturalidade - UF
	If lMunNasc
		::Curric:Curric1:CodCityOri			:= SQG->QG_CODMUNN			//Naturalidade - Código Municipio
	EndIf
	::Curric:Curric1:Nationality			:= SQG->QG_NACIONA			//Nacionalidade
	::Curric:Curric1:ArrivalYear			:= SQG->QG_ANOCHEG			//Ano de Chegada
	::Curric:Curric1:DateofBirth			:= SQG->QG_DTNASC			//Data de Nascimento
	::Curric:Curric1:RegisterDate			:= SQG->QG_DTCAD			//Data de Cadastro
	::Curric:Curric1:PositonAimed			:= SQG->QG_DESCFUN			//Cargo pretendido
	::Curric:Curric1:LastSalary				:= SQG->QG_ULTSAL			//Ultimo Salario
	::Curric:Curric1:ExpectedSalary			:= SQG->QG_PRETSAL			//Pretensao Salarial
	::Curric:Curric1:Analisys				:= APDMSMM(SQG->QG_ANALISE)	//Analise
	::Curric:Curric1:Pis					:= SQG->QG_PIS				//Pis
	::Curric:Curric1:Experience				:= APDMSMM(SQG->QG_EXPER)		//Experiencia
	::Curric:Curric1:Designation			:= SQG->QG_INDICAD			//Indicacao
	::Curric:Curric1:TestGrade				:= SQG->QG_NOTA				//Nota
	::Curric:Curric1:CurriculumStatus		:= SQG->QG_SITUAC			//Situac
	::Curric:Curric1:CostCenterCode			:= SQG->QG_CC				//Centro de Custos
	::Curric:Curric1:MeansSent				:= SQG->QG_MEIO_EN			//Meio Enviado
	::Curric:Curric1:TestDate				:= SQG->QG_DTTESTE			//Data de Teste
	::Curric:Curric1:WorkedTime				:= SQG->QG_TPTRAB			//Tempo de Trabalho
	::Curric:Curric1:ExperienceTime			:= SQG->QG_TPEXPER			//Tempo de Experiencia na Area
	::Curric:Curric1:ApplicantGroup			:= SQG->QG_GRUPO			//Grupo do Cargo
   	::Curric:Curric1:EmployeeBranch			:= SQG->QG_FILMAT			//Filial	(Quando funcionario)
   	::Curric:Curric1:EmployeeRegistration	:= SQG->QG_MAT			//Matricula (Quando funcionario)
	::Curric:Curric1:Email					:= SQG->QG_EMAIL			//Email
	::Curric:Curric1:MobilePhone			:= SQG->QG_FONECEL			//Celular
	::Curric:Curric1:BusinessPhone	       	:= SQG->QG_FONECOM			//Fone Comercial
	::Curric:Curric1:PassWord		       	:= SQG->QG_SENHA			//Senha
	::Curric:Curric1:NumberChars			:= 0						//Indica se possui caracteristicas definidas

	::Curric:Curric1:JobAbroad		       	:= SQG->QG_EXTER			//Trabalhar no Exterior
	::Curric:Curric1:Partner		       	:= SQG->QG_PARCEIR			//Trabalha em Cliente/Parceiro
	::Curric:Curric1:HandCapped		       	:= SQG->QG_DFISICO			//Deficiente fisico
	If SQG->(FieldPos("QG_DESCDEF")) > 0
		::Curric:Curric1:HandCappedDesc	    := SQG->QG_DESCDEF			//Descricao da deficiencia fisica
	EndIf
	::Curric:Curric1:TypeCurriculum   		:= SQG->QG_TPCURRI			//Tipo de Currículo
	
	::Curric:Curric1:NumberOfChildren   := SQG->QG_QTDEFIL			//Quantidade de filhos
	::Curric:Curric1:Hierarchical	       	:= SQG->QG_NIVHIER			//Nivel Hierarquico
	::Curric:Curric1:Font			       	:= SQG->QG_FONTE			//Fonte de Recrutamento
	If lRFC
		::Curric:Curric1:FirstName 			:= SQG->QG_PRINOME			//Primeiro Nome do Candidato
		::Curric:Curric1:SecondName 		:= SQG->QG_SECNOME			//Segundo Nome do Candidato	
		::Curric:Curric1:FirstSurName 		:= SQG->QG_PRISOBR			//Primeiro Sobrenome do Candidato
		::Curric:Curric1:SecondSurName 		:= SQG->QG_SECSOBR			//Segundo Sobrenome do Candidato	
	EndIf
	
	::Curric:Curric1:CargoCod		       	:= SQG->QG_CODFUN			//Codigo do Cargo
	::Curric:Curric1:CargoDesc		       	:= SQG->QG_DESCFUN		//Descricao do Cargo

	UserFields("SQG",@::Curric:Curric1:UserFields)						//Campos usuario

	cChave := SQG->QG_CURRIC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega estrutura de campos de usuarios para todos os Alias.		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	UserFields("SQG",@::Curric:Curric1:UserFieldPers)	//Dados pessoais
	UserFields("SQL",@::Curric:Curric1:UserFieldHist)	//Historico Profissional
	UserFields("SQM",@::Curric:Curric1:UserFieldCour)	//Cursos
	UserFields("SQM",@::Curric:Curric1:UserFieldGrad)	//Formacao
	UserFields("SQM",@::Curric:Curric1:UserFieldLang)	//Idiomas
	UserFields("SQM",@::Curric:Curric1:UserFieldCert)	//Certificacoes

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Historico Profissional												   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ::nTipo <> 1
		// Criacao de indice temporario para o SQM (Cursos)
		DbSelectArea("SQM")
		DbSetOrder(1)
	
		aSQMFields := ( "SQM" )->( dbStruct() )
		nSQMFields := Len( aSQMFields )
	
		cQrySQMFields := ""
		For nX := 1 To nSQMFields
			cQrySQMFields += aSQMFields[ nX , 01 ] + If(nSQMFields != nx, ", ","")
		Next nX
	
		cQuery := "SELECT "
		cQuery += cQrySQMFields
		cQuery += " FROM "
		cQuery += InitSqlName( "SQM" )+" SQM "
		cQuery += " WHERE QM_FILIAL = '"+ xFilial("SQM")+ "' AND QM_CURRIC = '"+cChave+"' AND SQM.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY " + SqlOrder("QM_FILIAL+QM_CURRIC+QM_DATA") + " DESC"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Reorganiza query para reconhecimento em MSSQL          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := ChangeQuery(cQuery)
		dbSelectArea("SQM")
		dbCloseArea()  //Fecha o SQM para uso da Query
	
		IF ( lQueryOpened := MsOpenDbf(.T.,"TOPCONN",TcGenQry(,,cQuery),"SQM",.T.,.T.) )
			For nX := 1 To nSQMFields
				IF ( aSQMFields[nX,2] <> "C" )
				   	TcSetField("SQM",aSQMFields[nX,1],aSQMFields[nX,2],aSQMFields[nX,3],aSQMFields[nX,4])
				EndIF
			Next nX
		EndIf
	
		// Criacao de indice temporario para o SQL (Historico Profissional)
		DbSelectArea("SQL")
		DbSetOrder(1)
	
	
		aSQLFields := ( "SQL" )->( dbStruct() )
		nSQLFields := Len( aSQLFields )
	
		cQrySQLFields := ""
		For nX := 1 To nSQLFields
			cQrySQLFields += aSQLFields[ nX , 01 ] + If(nSQLFields != nx, ", ","")
		Next nX
	
		cQuery := "SELECT "
		cQuery += cQrySQLFields
		cQuery += " FROM "
		cQuery += InitSqlName( "SQL" )+" SQLQRY "
		cQuery += " WHERE QL_FILIAL = '"+ xFilial("SQL")+ "' AND QL_CURRIC = '"+cChave+"' AND SQLQRY.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY "+SqlOrder("QL_FILIAL+QL_CURRIC+QL_DTADMIS") + " DESC"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Reorganiza query para reconhecimento em MSSQL          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := ChangeQuery(cQuery)
	
		dbSelectArea("SQL")
		dbCloseArea()  //Fecha o SQL para uso da Query
	
		IF ( lQueryOpened := MsOpenDbf(.T.,"TOPCONN",TcGenQry(,,cQuery),"SQL",.T.,.T.) )
			For nX := 1 To nSQLFields
				IF ( aSQLFields[nX,2] <> "C" )
				   	TcSetField("SQL",aSQLFields[nX,1],aSQLFields[nX,2],aSQLFields[nX,3],aSQLFields[nX,4])
				EndIF
			Next nX
		EndIf
	
		cChave2 := "SQL->QL_CURRIC"
	
		::Curric:Curric1:ListofHistory 	:= {}
		nx 		:= 0
	
		dbSelectArea("SQL")
	
		While !SQL->(Eof()) .And. Alltrim(cChave) == Alltrim(&cChave2)
			aadd(::Curric:Curric1:ListofHistory,WSClassNew("History"))
			nx++
			::Curric:Curric1:ListofHistory[nx]:AdmissionDate 	:= SQL->QL_DTADMIS			//Dt Admissao
			::Curric:Curric1:ListofHistory[nx]:DismissalDate 	:= SQL->QL_DTDEMIS			//Dt Demissao
			::Curric:Curric1:ListofHistory[nx]:Activity			:= APDMSMM(SQL->QL_ATIVIDA)	//Atividades
			::Curric:Curric1:ListofHistory[nx]:AreaCode			:= SQL->QL_AREA				//Area
			::Curric:Curric1:ListofHistory[nx]:AreaDescription	:= FDesc("SX5","R1"+SQL->QL_AREA	,"X5DESCRI()")			//Area
			::Curric:Curric1:ListofHistory[nx]:Company			:= SQL->QL_EMPRESA			//Empresa
			::Curric:Curric1:ListofHistory[nx]:FunctionCode		:= SQL->QL_FUNCAO			//Funcao
	
			UserFields("SQL",@::Curric:Curric1:ListofHistory[nx]:UserFields)				// Campos usuario
	
			SQL->(dbSkip())
		EndDo
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Formacao do Candidato												   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cChave2 := "SQM->QM_CURRIC"
		::Curric:Curric1:ListofGraduation := {}		//Formacao do Candidato			
		::Curric:Curric1:ListofCertification := {} 	// Certificacoes do Candidato				
		::Curric:Curric1:ListofLanguages := {}		//Idiomas do Candidato
		::Curric:Curric1:ListofCourses := {}		//Cursos do Candidato			
		
		nx1	:= 0
		nx2	:= 0
		nx3	:= 0
		nx4	:= 0
	
		dbSelectArea("SQM")
		While !Eof() .And. Alltrim(cChave) == Alltrim(&cChave2)
			cTipo := FDesc("SQT", SQM->QM_CURSO,"QT_TIPO",,,1)
			
			If Val(cTipo) == 1
				aadd(::Curric:Curric1:ListofGraduation,WSClassNew("Graduation"))
				nx1++
				::Curric:Curric1:ListofGraduation[nx1]:EntityCode		:= SQM->QM_CDENTID							//Entidade
				::Curric:Curric1:ListofGraduation[nx1]:EntityDesc		:= SQM->QM_ENTIDAD
				::Curric:Curric1:ListofGraduation[nx1]:GraduationDate	:= SQM->QM_DATA								//Data conclusao
				::Curric:Curric1:ListofGraduation[nx1]:CourseCode 		:= SQM->QM_CURSO							//Codigo do Curso
				SQT->( dbGoTop() )
				cDescrCourse := Alltrim(FDesc("SQT",SQM->QM_CURSO,"QT_DESCRIC",,,1))
				
			   	If  STR0015 $ cDescrCourse .And. aRetCampo[2]== 0  //"OUTROS" 
			   		::Curric:Curric1:ListofGraduation[nx1]:CourseDesc		:= SQM->QM_DCURSO
				Else                                                                      
					::Curric:Curric1:ListofGraduation[nx1]:CourseDesc		:= cDescrCourse
				Endif
				
				::Curric:Curric1:ListofGraduation[nx1]:Education 		:= SQM->QM_ESCOLAR							//Escolaridade
				::Curric:Curric1:ListofGraduation[nx1]:Type		 		:= cTipo									//Tipo de Curso
				::Curric:Curric1:ListofGraduation[nx1]:Grade		 		:= SQM->QM_NIVEL							//Nivel da Graduacao
				::Curric:Curric1:ListofGraduation[nx1]:EmployCourse		:= SQM->QM_CDCURSO							//Curso Funcionario
				::Curric:Curric1:ListofGraduation[nx1]:EmployDescCourse	:= FDesc("RA1",SQM->QM_CDCURSO,"RA1_DESC")	//Desc. Curso Funcionario
				::Curric:Curric1:ListofGraduation[nx1]:EmployEntity		:= SQM->QM_CDENTID							//Entidade Funcionario
				::Curric:Curric1:ListofGraduation[nx1]:EmployDescEntity	:= FDesc("RA0",SQM->QM_CDENTID,"RA0_DESC")	//Desc. Entidade Funcionario
	
				UserFields("SQM",@::Curric:Curric1:ListofGraduation[nx1]:UserFields)									// Campos usuario
			
			ElseIf Val(cTipo) == 2
				aadd(::Curric:Curric1:ListofCertification,WSClassNew("Certification"))
				nx2++
				::Curric:Curric1:ListofCertification[nx2]:EntityCode			:= SQM->QM_CDENTID							//Entidade
				::Curric:Curric1:ListofCertification[nx2]:EntityDesc			:= SQM->QM_ENTIDAD
				::Curric:Curric1:ListofCertification[nx2]:GraduationDate		:= SQM->QM_DATA								//Data conclusao
				::Curric:Curric1:ListofCertification[nx2]:CourseCode 		:= SQM->QM_CURSO							//Codigo do Curso
				SQT->( dbGoTop() )
				cDescrCourse := Alltrim(FDesc("SQT",SQM->QM_CURSO,"QT_DESCRIC",,,1))
				aRetCampo:= ExisteCampo("QM_DCURSO",.F.,.F.,.T.)                
	
			   	If STR0015 $ cDescrCourse .And. aRetCampo[2]== 0  //"OUTROS"
					::Curric:Curric1:ListofCertification[nx2]:CourseDesc		:= SQM->QM_DCURSO
				Else
					::Curric:Curric1:ListofCertification[nx2]:CourseDesc		:= cDescrCourse	//Curriculo
				Endif
	
				::Curric:Curric1:ListofCertification[nx2]:Education 			:= SQM->QM_ESCOLAR							//Escolaridade
				::Curric:Curric1:ListofCertification[nx2]:Type		 		:= cTipo									//Tipo de Curso
				::Curric:Curric1:ListofCertification[nx2]:EmployCourse		:= SQM->QM_CDCURSO							//Curso Funcionario
				::Curric:Curric1:ListofCertification[nx2]:EmployDescCourse	:= FDesc("RA1",SQM->QM_CDCURSO,"RA1_DESC")	//Desc. Curso Funcionario
				::Curric:Curric1:ListofCertification[nx2]:EmployEntity		:= SQM->QM_CDENTID							//Entidade Funcionario
				::Curric:Curric1:ListofCertification[nx2]:EmployDescEntity	:= FDesc("RA0",SQM->QM_CDENTID,"RA0_DESC")	//Desc. Entidade Funcionario
	
				UserFields("SQM",@::Curric:Curric1:ListofCertification[nx2]:UserFields)									// Campos usuario
			ElseIf Val(cTipo) == 3
				aadd(::Curric:Curric1:ListofLanguages, WSClassNew("Languages"))
				nx3++
				::Curric:Curric1:ListofLanguages[nx3]:EntityCode		:= SQM->QM_CDENTID							//Entidade
				::Curric:Curric1:ListofLanguages[nx3]:EntityDesc		:= SQM->QM_ENTIDAD
				::Curric:Curric1:ListofLanguages[nx3]:GraduationDate	:= SQM->QM_DATA								//Data conclusao
				::Curric:Curric1:ListofLanguages[nx3]:CourseCode 	:= SQM->QM_CURSO							//Codigo do Curso
				SQT->( dbGoTop() )
				cDescrCourse := Alltrim(FDesc("SQT",SQM->QM_CURSO,"QT_DESCRIC",,,1))
				aRetCampo:= ExisteCampo("QM_DCURSO",.F.,.F.,.T.)                
	
				If  STR0015 $ cDescrCourse .And. aRetCampo[2]== 0  //"OUTROS"
					::Curric:Curric1:ListofLanguages[nx3]:CourseDesc		:= SQM->QM_DCURSO
				Else
					::Curric:Curric1:ListofLanguages[nx3]:CourseDesc		:= cDescrCourse 	//Curriculo
				Endif
	
				::Curric:Curric1:ListofLanguages[nx3]:Education 			:= SQM->QM_ESCOLAR							//Escolaridade
				::Curric:Curric1:ListofLanguages[nx3]:Type		 		:= cTipo									//Tipo de Curso
				::Curric:Curric1:ListofLanguages[nx3]:Grade		 		:= SQM->QM_NIVEL							//Nivel do Idioma
				::Curric:Curric1:ListofLanguages[nx3]:EmployCourse		:= SQM->QM_CDCURSO							//Curso Funcionario
				::Curric:Curric1:ListofLanguages[nx3]:EmployDescCourse	:= FDesc("RA1",SQM->QM_CDCURSO,"RA1_DESC")	//Desc. Curso Funcionario
				::Curric:Curric1:ListofLanguages[nx3]:EmployEntity		:= SQM->QM_CDENTID							//Entidade Funcionario
				::Curric:Curric1:ListofLanguages[nx3]:EmployDescEntity	:= FDesc("RA0",SQM->QM_CDENTID,"RA0_DESC")	//Desc. Entidade Funcionario
	
				UserFields("SQM",@::Curric:Curric1:ListofLanguages[nx3]:UserFields)									// Campos usuario
			ElseIf Val(cTipo) == 4
				aadd(::Curric:Curric1:ListofCourses,WSClassNew("Courses"))
				nx4++
				::Curric:Curric1:ListofCourses[nx4]:EntityCode		:= SQM->QM_CDENTID							//Entidade
				::Curric:Curric1:ListofCourses[nx4]:EntityDesc		:= SQM->QM_ENTIDAD
				::Curric:Curric1:ListofCourses[nx4]:GraduationDate	:= SQM->QM_DATA								//Data conclusao
				::Curric:Curric1:ListofCourses[nx4]:CourseCode 		:= SQM->QM_CURSO							//Codigo do Curso
				SQT->( dbGoTop() )
				cDescrCourse := Alltrim(FDesc("SQT",SQM->QM_CURSO,"QT_DESCRIC",,,1))
				aRetCampo:= ExisteCampo("QM_DCURSO",.F.,.F.,.T.)                
	
				If STR0015 $ cDescrCourse .And. aRetCampo[2]== 0 //"OUTROS"
					::Curric:Curric1:ListofCourses[nx4]:CourseDesc		:= SQM->QM_DCURSO
				Else
					::Curric:Curric1:ListofCourses[nx4]:CourseDesc		:= cDescrCourse   //Curriculo
				Endif
	
				::Curric:Curric1:ListofCourses[nx4]:Education 		:= SQM->QM_ESCOLAR							//Escolaridade
				::Curric:Curric1:ListofCourses[nx4]:Type		 		:= cTipo									//Tipo de Curso
				::Curric:Curric1:ListofCourses[nx4]:EmployCourse		:= SQM->QM_CDCURSO							//Curso Funcionario
				::Curric:Curric1:ListofCourses[nx4]:EmployDescCourse	:= FDesc("RA1",SQM->QM_CDCURSO,"RA1_DESC")	//Desc. Curso Funcionario
				::Curric:Curric1:ListofCourses[nx4]:EmployEntity		:= SQM->QM_CDENTID							//Entidade Funcionario
				::Curric:Curric1:ListofCourses[nx4]:EmployDescEntity	:= FDesc("RA0",SQM->QM_CDENTID,"RA0_DESC")	//Desc. Entidade Funcionario
	
				UserFields("SQM",@::Curric:Curric1:ListofCourses[nx4]:UserFields)									// Campos usuario
			
			EndIf
			SQM->(dbSkip())
		EndDo
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Qualificacoes do candidato 											   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChave2	:= "SQI->QI_CURRIC"
	::Curric:Curric1:ListofQualification := {}
	nx 		:= 0

	dbSelectArea("SQI")
	dbSetOrder(1)
	If !Empty(cChave) .And. dbSeek(xFilial("SQI")+cChave)
		While !Eof() .And. Alltrim(cChave) == Alltrim(&cChave2)
			aadd(::Curric:Curric1:ListofQualification,WSClassNew("Qualification"))
			nx++
			::Curric:Curric1:ListofQualification[nx]:Group 			:= SQI->QI_GRUPO							//Grupo
			::Curric:Curric1:ListofQualification[nx]:GroupDescr		:= FDesc("SQ0",SQI->QI_GRUPO,"Q0_DESCRIC")	//Descricao do Grupo
			::Curric:Curric1:ListofQualification[nx]:Factor			:= SQI->QI_FATOR							//Fator
			::Curric:Curric1:ListofQualification[nx]:FatorDescr		:= FDesc("SQ1",SQI->QI_GRUPO+SQI->QI_FATOR,"Q1_DESCSUM") //Descricao do Fator
			::Curric:Curric1:ListofQualification[nx]:Degree			:= SQI->QI_GRAU								//Grau
			::Curric:Curric1:ListofQualification[nx]:DegreeDescr	:= FDesc("SQ2",SQI->QI_GRUPO+SQI->QI_FATOR+SQI->QI_GRAU,"Q2_DESC") //Descricao do Grau
			::Curric:Curric1:ListofQualification[nx]:DateFactor		:= SQI->QI_DATA

			UserFields("SQI",@::Curric:Curric1:ListofQualification[nx]:UserFields)								// Campos usuario

			dbSkip()
		EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Avaliacoes do Candidato												   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChave2	:= "SQR->QR_CURRIC"
	::Curric:Curric1:ListofEvaluation := {}
	nx 		:= 0

	dbSelectArea("SQR")
	dbSetOrder(1)
	If !Empty(cChave) .And. dbSeek(xFilial("SQR")+cChave)
		While !SQR->(Eof()) .And. Alltrim(cChave) == Alltrim(&cChave2)
			aadd(::Curric:Curric1:ListofEvaluation,WSClassNew("Evaluation"))
			nx++
			::Curric:Curric1:ListofEvaluation[nx]:Registration		:= SQR->QR_MAT							//Matricula func.
			::Curric:Curric1:ListofEvaluation[nx]:Evaluation		:= SQR->QR_TESTE						//Avaliacao
			::Curric:Curric1:ListofEvaluation[nx]:DescEvaluation	:= FDesc("SQQ",SQR->QR_TESTE,"QQ_DESCRIC")	//Descricao do Teste
			::Curric:Curric1:ListofEvaluation[nx]:Subject			:= SQR->QR_TOPICO						//Topico
			::Curric:Curric1:ListofEvaluation[nx]:DescSubject		:= FDesc("SX5",SQR->QR_TOPICO,"X5_DESCRI")	//Descricao do Topico
			::Curric:Curric1:ListofEvaluation[nx]:Question			:= SQR->QR_QUESTAO							//Questao
			::Curric:Curric1:ListofEvaluation[nx]:DescQuestion		:= FDesc("SQO",SQR->QR_QUESTAO,"QO_QUEST",50) //Descricao da Questao
			::Curric:Curric1:ListofEvaluation[nx]:Alternative		:= SQR->QR_ALTERNA						//Alternativa
			::Curric:Curric1:ListofEvaluation[nx]:DescAlternative	:= FDesc("SQP",SQR->QR_QUESTAO+SQR->QR_ALTERNA,"QP_DESCRIC")	//Descricao do Teste
			::Curric:Curric1:ListofEvaluation[nx]:Adjustment		:= SQR->QR_RESULTA						//Resultado %
			::Curric:Curric1:ListofEvaluation[nx]:DescAnswer		:= APDMSMM(SQR->QR_MRESPOS)				//Avaliacao
			::Curric:Curric1:ListofEvaluation[nx]:Duration			:= SQR->QR_DURACAO						//Duracao

			UserFields("SQR",@::Curric:Curric1:ListofEvaluation[nx]:UserFields)							// Campos usuario

			SQR->(dbSkip())
		EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caracteristicas do Candidato										   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric1:ListofCharacters := {}
	nX 		:= 0

	DbSelectArea("RS7")
	dbSelectArea("SM6")
	
	BEGINSQL alias cRS6Alias
			SELECT RS6.RS6_CODIGO
				 , RS6.RS6_DESC
		         , RS6.RS6_RESP
		      FROM %table:RS6% RS6
		     WHERE RS6.RS6_EXTERN = '1' 
	           AND RS6.%notDel% 
		  ORDER BY RS6.RS6_RESP, RS6.RS6_CODIGO		
	ENDSQL   	
	
	While (cRS6Alias)->( !Eof())	
		
		aAdd(::Curric:Curric1:ListofCharacters,WSClassNew("Characters"))
		nX++
		::Curric:Curric1:NumberChars := nX
		::Curric:Curric1:ListofCharacters[nX]:Code					:= (cRS6Alias)->RS6_CODIGO						//Tipo de Caracteristica
		::Curric:Curric1:ListofCharacters[nX]:Question				:= (cRS6Alias)->RS6_DESC						//Caracteristica
		::Curric:Curric1:ListofCharacters[nX]:Type					:= (cRS6Alias)->RS6_RESP						//Tipo de Resposta
		
		If SM6->(DbSeek(xFilial("SM6")+cChave+(cRS6Alias)->RS6_CODIGO))
			::Curric:Curric1:ListofCharacters[nX]:AnSwer				:= SM6->M6_RESP								//Resposta dissertativa
			::Curric:Curric1:ListofCharacters[nX]:Choice				:= SM6->M6_ALTERNA							//Alternativas selecionadas
		Else
			::Curric:Curric1:ListofCharacters[nX]:AnSwer				:= ""										//Resposta dissertativa
			::Curric:Curric1:ListofCharacters[nX]:Choice				:= ""										//Alternativas selecionadas		
		EndIf
		
		If (cRS6Alias)->RS6_RESP <> '3'
			RS7->(DbSeek(xFilial("RS7")+(cRS6Alias)->RS6_CODIGO))
			nY := 0
			While RS7->(!Eof() .and. RS7_FILIAL + RS7_TIPO == xFilial("RS7") + (cRS6Alias)->RS6_CODIGO)
				If nY == 0
					::Curric:Curric1:ListofCharacters[nX]:ListOfCharOptions := {}
				EndIf
				aAdd(::Curric:Curric1:ListofCharacters[nX]:ListOfCharOptions,WSClassNew("CharOptions"))
				nY++
				::Curric:Curric1:ListofCharacters[nX]:ListOfCharOptions[nY]:Code := RS7->RS7_SEQ
				::Curric:Curric1:ListofCharacters[nX]:ListOfCharOptions[nY]:Desc := RS7->RS7_DESC
				RS7->(DbSkip())
			EndDo
		EndIf
		UserFields("SM6",@::Curric:Curric1:ListofCharacters[nx]:UserFields)									// Campos usuario

		(cRS6Alias)->(dbSkip())
	EndDo

	(cRS6Alias)->(dbCloseArea())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ 							Tabelas				   					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Areas							   					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfArea := {}
	nx 			:= 0
	cChave	:= "R1"

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+cChave)
		While !Eof() .And. SX5->X5_TABELA == cChave
			aadd(::Curric:Curric2:ListOfArea,WSClassNew("Area"))
			nx++

		 	::Curric:Curric2:ListOfArea[nx]:AreaCode			:= SX5->X5_CHAVE	//Codigo da Area
		 	::Curric:Curric2:ListOfArea[nx]:AreaDescription		:= SX5->X5_DESCRI	//Descricao da Area

		 	dbSkip()
		 EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de UF												   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfFederalUnit := {}
	nx 			:= 0
	cChave	:= "12"

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+cChave)
		While !Eof() .And. SX5->X5_TABELA == cChave
			aadd(::Curric:Curric2:ListOfFederalUnit,WSClassNew("FederalUnit"))
			nx++

			::Curric:Curric2:ListOfFederalUnit[nx]:FederalUnitCode			:= SX5->X5_CHAVE	//Codigo da UF
			::Curric:Curric2:ListOfFederalUnit[nx]:FederalUnitDescription 	:= SX5->X5_DESCRI	//Descricao UF

		 	dbSkip()
		 EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Municipio												   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfCity := {}
	nx 			:= 0
	

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Estado Civil					   					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfMaritalStatus := {}
	nx 			:= 0
	cChave	:= "33"

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+cChave)
		While !Eof() .And. SX5->X5_TABELA == cChave
			aadd(::Curric:Curric2:ListOfMaritalStatus,WSClassNew("MaritalStatus"))
			nx++

			::Curric:Curric2:ListOfMaritalStatus[nx]:MaritalStatusCode			  := SX5->X5_CHAVE	//Codigo do Estado Civil
			
			If cPaisLoc $ ("BRA/ANG/PTG")
				::Curric:Curric2:ListOfMaritalStatus[nx]:MaritalStatusDescription := SX5->X5_DESCRI	//Descricao do Estado Civil
			ElseIf cPaisLoc $ ("EUA")
				::Curric:Curric2:ListOfMaritalStatus[nx]:MaritalStatusDescription := SX5->X5_DESCENG
			Else
				::Curric:Curric2:ListOfMaritalStatus[nx]:MaritalStatusDescription := SX5->X5_DESCSPA
			EndIf

		 	dbSkip()
		 EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Nacionalidades				 					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfNationality := {}
	nx 			:= 0
	cChave	:= "34"

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+cChave)
		While !Eof() .And. SX5->X5_TABELA == cChave
			aadd(::Curric:Curric2:ListOfNationality,WSClassNew("Nationality"))
			nx++

			::Curric:Curric2:ListOfNationality[nx]:NationalityCode			:= SX5->X5_CHAVE	//Codigo da Nacionalidade
			::Curric:Curric2:ListOfNationality[nx]:NationalityDescription 	:= SX5->X5_DESCRI	//Descricao da Nacionalidade

		 	dbSkip()
		 EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Grupos					   						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfGroup := {}
	nx 	:= 0

	dbSelectArea("SQ0")
	dbSetOrder(1)
	dbGoTop()
	While !Eof()
		aadd(::Curric:Curric2:ListOfGroup,WSClassNew("Group"))
		nx++

		::Curric:Curric2:ListOfGroup[nx]:GroupCode			:= SQ0->Q0_GRUPO	//Codigo do Grupo
		::Curric:Curric2:ListOfGroup[nx]:GroupDescription 	:= SQ0->Q0_DESCRIC	//Descricao do Grupo

	 	dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Certificacoes.									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfCertificationCurriculum := {}	//Carrega Tabela de Certificacoes.	
	::Curric:Curric2:ListOfLanguagesCurriculum := {}	//Carrega Tabela de Idiomas ( Linguagens	)	
	nx1 	:= 0
	nx2 	:= 0
	dbSelectArea("SQT")
	SQT->(dbSetOrder(2))
	SQT->(dbGoTop())
	While !SQT->(Eof())
		If Val(SQT->QT_TIPO) == 2 //Curso
			aadd(::Curric:Curric2:ListOfCertificationCurriculum,WSClassNew("CertificationCurriculum"))
			nx1++

			::Curric:Curric2:ListOfCertificationCurriculum[nx1]:CertificationCurriculumCode			:= SQT->QT_CURSO	//Codigo do Curso do Curriculo
			::Curric:Curric2:ListOfCertificationCurriculum[nx1]:CertificationCurriculumDescription 	:= SQT->QT_DESCRIC	//Descricao do Curso do Curriculo
		ElseIf Val(SQT->QT_TIPO) == 3 //Idioma
			aadd(::Curric:Curric2:ListOfLanguagesCurriculum,WSClassNew("LanguagesCurriculum"))
			nx2++

			::Curric:Curric2:ListOfLanguagesCurriculum[nx2]:LanguagesCurriculumCode			:= SQT->QT_CURSO	//Codigo do Curso do Curriculo
			::Curric:Curric2:ListOfLanguagesCurriculum[nx2]:LanguagesCurriculumDescription 	:= SQT->QT_DESCRIC	//Descricao do Curso do Curriculo
		EndIf
	 	SQT->(dbSkip())
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Cursos de Funcionarios  							   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfCoursesEmployee := {}


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Fatores de Avaliacao			  					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfFactor := {}


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Sexo							  					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfGender := {}

   	aadd(::Curric:Curric2:ListOfGender,WSClassNew("Gender"))
	::Curric:Curric2:ListOfGender[1]:GenderCode			:= "M"
	::Curric:Curric2:ListOfGender[1]:GenderDescription	:= STR0005	//Masculino

	aadd(::Curric:Curric2:ListOfGender,WSClassNew("Gender"))
	::Curric:Curric2:ListOfGender[2]:GenderCode			:= "F"
	::Curric:Curric2:ListOfGender[2]:GenderDescription	:= STR0006	//Feminino

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Itens de Tipos de Cursos (Graduacao)				   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfGrdGraduate := {}

   	nx 		:= 0
   	cEscala := Fdesc("SQX", "001", "QX_NIVEL ") //001 - Formacao
   	dbSelectArea("RBL")
   	dbSetOrder(1)
   	dbSeek(xFilial("RBL")+cEscala)
   	While !Eof() .And. RBL->RBL_ESCALA == cEscala
   		nx++
		aadd(::Curric:Curric2:ListOfGrdGraduate,WSClassNew("GrdGraduate"))
		::Curric:Curric2:ListOfGrdGraduate[nx]:GradeCode			:= RBL->RBL_ITEM
		::Curric:Curric2:ListOfGrdGraduate[nx]:GradeDescription		:= RBL->RBL_DESCRI
   		dbSkip()
   	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Itens de Tipos de Cursos (Idomas)	   				   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfGrdLanguage := {}

	nx 		:= 0
   	cEscala := Fdesc("SQX", "003", "QX_NIVEL ") //003 - Idioma
   	dbSelectArea("RBL")
   	dbSetOrder(1)
   	dbSeek(xFilial("RBL")+cEscala)
   	While !Eof() .And. RBL->RBL_ESCALA == cEscala
		aadd(::Curric:Curric2:ListOfGrdLanguage,WSClassNew("GrdLanguage"))
		nx++
		::Curric:Curric2:ListOfGrdLanguage[nx]:GradeCode			:= RBL->RBL_ITEM
		::Curric:Curric2:ListOfGrdLanguage[nx]:GradeDescription		:= RBL->RBL_DESCRI
   		dbSkip()
   	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Disponibilidade de trabalho no Exterior			   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfJobAbroad := {}

    aCombo :=	{	{"1", STR0016}	,;	//"Sim"
    				{"2", STR0017}	;	//"Nao"
   				}

    For nx := 1 To Len(aCombo)
	   	aadd(::Curric:Curric2:ListOfJobAbroad,WSClassNew("JobAbroad"))
		::Curric:Curric2:ListOfJobAbroad[nx]:Code			:= aCombo[nx][1]
		::Curric:Curric2:ListOfJobAbroad[nx]:Description	:= aCombo[nx][2]		//
	Next nx


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Portador de deficiencia fisica					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfHandCapped := {}

    aCombo :=	{   {"2", STR0017}	,;	//"Nao"
    				{"1", STR0016}	;	//"Sim"
   				}

    For nx := 1 To Len(aCombo)
	   	aadd(::Curric:Curric2:ListOfHandCapped,WSClassNew("HandCapped"))
		::Curric:Curric2:ListOfHandCapped[nx]:Code			:= aCombo[nx][1]
		::Curric:Curric2:ListOfHandCapped[nx]:Description	:= aCombo[nx][2]		//
	Next nx

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Tipo de Currículo					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfTypeCurriculum := {}

    aCombo :=	{	{"1", STR0053}	,;	//"Estagiário"
    				{"2", STR0054}	,;	//"CLT"
    				{"3", STR0055}	,;	//"Concursado"
    				{"4", STR0056}	,;	//"PJ"
    				{"5", STR0058}   ;	//"Aprendiz"
   				}

   	nAux := 0
    For nx := 1 To Len(aCombo)
    	If !Empty(cBloqTpCur) .and. aCombo[nX,1] $ cBloqTpCur //Não carrega tipos de curriculo bloqueado
    		Loop
    	EndIf
    	nAux++
	   	aadd(::Curric:Curric2:ListOfTypeCurriculum,WSClassNew("TypeCurriculum"))
		::Curric:Curric2:ListOfTypeCurriculum[nAux]:Code		:= aCombo[nx][1]
		::Curric:Curric2:ListOfTypeCurriculum[nAux]:Description	:= aCombo[nx][2]		//
	Next nx
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Parceiros ou clientes 							   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfPartner := {}

    aCombo :=	{	{"1", STR0016}	,;	//"Sim"
    				{"2", STR0017}	;	//"Nao"
   				}

    For nx := 1 To Len(aCombo)
	   	aadd(::Curric:Curric2:ListOfPartner,WSClassNew("Partner"))
		::Curric:Curric2:ListOfPartner[nx]:Code			:= aCombo[nx][1]
		::Curric:Curric2:ListOfPartner[nx]:Description	:= aCombo[nx][2]		//
	Next nx


 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Nivel Hierarquico									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	::Curric:Curric2:ListOfHierarchical := {}

	nx 	:= 0

	dbSelectArea("RBF")
	dbSetOrder(1)
	dbGoTop()
	While !Eof()
	   	aadd(::Curric:Curric2:ListOfHierarchical,WSClassNew("Hierarchical"))
		nx++

		::Curric:Curric2:ListOfHierarchical[nx]:Code			:= RBF->RBF_CLASSE 	//Classe salarial (Nivel hierarquico)
		::Curric:Curric2:ListOfHierarchical[nx]:Description		:= RBF->RBF_DESC   	//Descricao

	 	dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Tabela de Fontes de Recrutamento							   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	::Curric:Curric2:ListOfFont := {}

    aCombo :=	{	{"1", STR0018 }	,;	//"Indicação de funcionário"
    				{"2", STR0019 }	,; 	//"Indicaçãao de ex-funcionário"
    				{"3", STR0020 }	,; 	//"É ex-funcionário"
    				{"4", STR0021 }	,; 	//"Indicação de cliente"
    				{"5", STR0022 }	,; 	//"Indicação de consultoria"
    				{"6", STR0023 }	,; 	//"Anúncio em jornal"
    				{"7", STR0024 }	,; 	//"Anúncio em revista especializada"
    				{"8", STR0025 }	,; 	//"Anúncio ou feira em Universidades"
    				{"9", STR0026 }	,; 	//"Sites de recrutamento"
    				{"A", STR0027 }	,; 	//"Espontâneo"
    				{"B", STR0028 }	; 	//"Outro"
   				}

    For nx := 1 To Len(aCombo)
	   	aadd(::Curric:Curric2:ListOfFont,WSClassNew("Font"))
		::Curric:Curric2:ListOfFont[nx]:Code			:= aCombo[nx][1]
		::Curric:Curric2:ListOfFont[nx]:Description		:= aCombo[nx][2]
	Next nx

Else
	lRetorno := .F.
	SetSoapFault(STR0032,STR0002)//"Erro" - "Usuario nao autorizado"
EndIf

SQL->(dbCloseArea())
SQM->(dbCloseArea())
RestArea(aArea)
Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SetCurriculum ³ Autor ³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao dos objetivos cadastrados no  ³±±
±±³          ³Curriculo.                          					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Dados do Curriculo		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		 1479
                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD SetCurriculum WSRECEIVE UserCode,Curric1 WSSEND WsNull WSSERVICE RhCurriculum
	Local aArea     	:= GetArea()
	Local aUserFields	:= {}

	Local lRetorno  	:= .T.
	Local cSeek			:= ""
	Local nx			:= 0
	Local ny			:= 0
	Local nSaveSX8SQG	:= GetSX8Len()
	Local cRetSqlName	:= ""
	//Local cDriver		:= __cRDD
	Local cCodSQG   := ""
	Local cPathSQG  := ""
	Local nCodSQG   := 0
	Local lMunNasc 	:= SQG->(ColumnPos("QG_CODMUNN")) > 0 .and. SQG->(ColumnPos("QG_MUNNASC")) > 0
	
	//Campos Caracter
	Local aCampos:= { 	{"QG_NOME"		, ::Curric1:Name,					X3Picture("QG_NOME") },;		//Nome do Candidato
						{"QG_ENDEREC"	, ::Curric1:Address,				X3Picture("QG_ENDEREC") },;		//Endereco
						{"QG_COMPLEM"	, ::Curric1:AddressComplement,		X3Picture("QG_COMPLEM") },;		//Complem
						{"QG_BAIRRO"	, ::Curric1:Zone,					X3Picture("QG_BAIRRO") },; 		//Bairro
						{"QG_MUNICIP"	, ::Curric1:District,				X3Picture("QG_MUNICIP") },;		//Municip
						{"QG_ESTADO"	, ::Curric1:State,					X3Picture("QG_ESTADO") },; 		//Estado
						{"QG_CEP"		, ::Curric1:ZipCode,				X3Picture("QG_CEP") },;  		//Cep
						{"QG_FONE"		, ::Curric1:Phone,					X3Picture("QG_FONE") },;  		//Fone
						{"QG_RG"		, ::Curric1:Id,						X3Picture("QG_RG") },;  		//RG
						{"QG_CIC"		, ::Curric1:Cpf,					X3Picture("QG_CIC") },;  		//CPF
						{"QG_NUMCP"		, ::Curric1:EmployBookNr,			X3Picture("QG_NUMCP") },;  		//Num CP
						{"QG_SERCP"		, ::Curric1:EmployBookSr,			X3Picture("QG_SERCP") },;  		//Serie CP
						{"QG_UFCP"		, ::Curric1:EmployBookState,		X3Picture("QG_UFCP") },; 		//UF CP
						{"QG_HABILIT"	, ::Curric1:DrivingLicense,			X3Picture("QG_HABILIT") },;  	//Habilitacao
						{"QG_RESERV"	, ::Curric1:ReservistCard,			X3Picture("QG_RESERV") },;  	//Reservista
						{"QG_TITULOE"	, ::Curric1:VotingCard,				X3Picture("QG_TITULOE") },;  	//Titulo Eleitor
						{"QG_ZONASEC"	, ::Curric1:ElectoralDistrict,		X3Picture("QG_ZONASEC") },;  	//Zona Eleitoral
						{"QG_PAI"		, ::Curric1:FathersName,			X3Picture("QG_PAI") },;  		//Pai
						{"QG_MAE"		, ::Curric1:MothersName,			X3Picture("QG_MAE") },;  		//Mae
						{"QG_SEXO"		, ::Curric1:Gender,					X3Picture("QG_SEXO") },;  		//Sexo
						{"QG_ESTCIV"	, ::Curric1:MaritalStatus,			X3Picture("QG_ESTCIV") },; 		//Estado Civil
						{"QG_NATURAL"	, ::Curric1:Origin,					X3Picture("QG_NATURAL") },;  	//Naturalidade - UF
						{"QG_NACIONA"	, ::Curric1:Nationality,			X3Picture("QG_NACIONA") },;  	//Nacionalidade
						{"QG_ANOCHEG"	, ::Curric1:ArrivalYear,			X3Picture("QG_ANOCHEG") },;  	//Ano de Chegada
						{"QG_DTNASC"	, ::Curric1:DateofBirth,			X3Picture("QG_DTNASC") },;  	//Data de Nascimento
						{"QG_DESCFUN"	, ::Curric1:PositonAimed,			X3Picture("QG_DESCFUN") },;  	//Cargo pretendido
						{"QG_PIS"		, ::Curric1:Pis,					X3Picture("QG_PIS") },;  		//Pis
						{"QG_INDICAD"	, ::Curric1:Designation,			X3Picture("QG_INDICAD") },;  	//Indicacao
						{"QG_SITUAC"	, ::Curric1:CurriculumStatus,		X3Picture("QG_SITUAC") },;  	//Situac
						{"QG_CC"		, ::Curric1:CostCenterCode,			X3Picture("QG_CC") },;  		//Centro de Custos
						{"QG_AREA"		, ::Curric1:AreaCode,				X3Picture("QG_AREA") },;  		//Area
						{"QG_MEIO_EN"	, ::Curric1:MeansSent,				X3Picture("QG_MEIO_EN") },;  	//Meio Enviado
						{"QG_DTTESTE"	, ::Curric1:TestDate,				X3Picture("QG_DTTESTE") },;  	//Data de Teste
						{"QG_GRUPO"		, ::Curric1:ApplicantGroup,			X3Picture("QG_GRUPO") },;  		//Grupo do Cargo
						{"QG_MAT"		, ::Curric1:EmployeeRegistration,	X3Picture("QG_MAT") },;			//Matricula (Quando funcionario)
						{"QG_EMAIL"		, ::Curric1:Email,					X3Picture("QG_EMAIL") },;  		//Email
						{"QG_FONECEL"	, ::Curric1:MobilePhone,			X3Picture("QG_FONECEL") },;  	//Fone Celular
						{"QG_FONECOM"	, ::Curric1:BusinessPhone,			X3Picture("QG_FONECOM") },;  	//Fone Comercial
						{"QG_SENHA"		, ::Curric1:PassWord,				X3Picture("QG_SENHA") },;  		//Senha
						{"QG_EXTER"		, ::Curric1:JobAbroad,				X3Picture("QG_EXTER") },;  		//Trabalhar no Exterior
						{"QG_PARCEIR"	, ::Curric1:Partner,				X3Picture("QG_PARCEIR") },;  	//Trabalha em Cliente/Parceiro
						{"QG_DFISICO"	, ::Curric1:HandCapped,				X3Picture("QG_DFISICO") },;  	//Deficiente fisico 
						{"QG_TPCURRI"	, ::Curric1:TypeCurriculum,				X3Picture("QG_TPCURRI") },;  	//Tipo de Currículo
						{"QG_NIVHIER"	, ::Curric1:Hierarchical,			X3Picture("QG_NIVHIER") },;  	//Nivel Hierarquico
						{"QG_FONTE"		, ::Curric1:Font,					X3Picture("QG_FONTE") },;  		//Fonte de Recrutamento
						{"QG_CODFUN"		, ::Curric1:CargoCod,			X3Picture("QG_CODFUN") },;  		//Codigo do Cargo
						{"QG_DESCFUN"		, ::Curric1:CargoDesc,			X3Picture("QG_DESCFUN") };  		//Descricao do Cargo
	               }
	Local cBloqTpCur	:= SuperGetMv("MV_BLOQCPC",NIl,"")
	
	DEFAULT lRFC  := cPaisLoc == "MEX" .And. SQG->( ColumnPos( "QG_PRINOME" ) # 0 )		

	If lRFC
		aAdd( aCampos, {"QG_PRINOME"		, ::Curric1:FirstName,					X3Picture("QG_PRINOME") }  )//Primeiro Nome do Candidato
		aAdd( aCampos, {"QG_SECNOME"		, ::Curric1:SecondName,					X3Picture("QG_SECNOME") }  )//Segundo Nome do Candidato
		aAdd( aCampos, {"QG_PRISOBR"		, ::Curric1:FirstSurname,				X3Picture("QG_PRISOBR") }  )//Primeiro Sobrenome do Candidato		
		aAdd( aCampos, {"QG_SECSOBR"		, ::Curric1:SecondSurname,				X3Picture("QG_SECSOBR") }  )//Segundo Sobrenome do Candidato
	EndIf
	
	If lMunNasc
		aAdd( aCampos, {"QG_MUNNASC"		, If(!Empty(::Curric1:CodCityOri),FDesc("CC2",AllTrim(::Curric1:Origin) + ::Curric1:CodCityOri,"CC2_MUN",,,1),""),			X3Picture("QG_MUNNASC") } )	//Naturalidade - Municipio
		aAdd( aCampos, {"QG_CODMUNN"		, ::Curric1:CodCityOri,			X3Picture("QG_CODMUNN") } )	//Naturalidade - Código Municipio
	EndIf	

	PutUserFields("SQG",::Curric1:UserFields,@aUserFields)		// Campos usuario
	For ny := 1 To Len(aUserFields)  
		Aadd(aUserFields[ny], X3Picture(aUserFields[ny][1]) )
	Next
	
	cRetSqlName := RetSqlName( "SQG" )+"\3"
	
	// Utilizar Usuario "ADMINISTRADOR" para teste   // Retirar do programa
	If ::UserCode=="ADMINISTRADOR" .Or. PrtChkUser(::UserCode,"RhCurriculum")
	
		dbSelectArea("SQG")
		dbSetOrder(3)			//CPF
	
		cSeek := xFilial("SQG")+::Curric1:Cpf
	
		If !Empty(::Curric1:Curriculum) .or. dbSeek(cSeek)
			If !Empty(cBloqTpCur) //Ignoras tipos bloqueados
				While SQG->( !Eof() .and. QG_FILIAL + QG_CIC == cSeek )
					If SQG->QG_TPCURRI $ cBloqTpCur
						SQG->(DbSkip())
						Loop
					EndIf
					Exit
				EndDo
			EndIf
	
			Reclock("SQG",.F.)
	
			If Empty(SQG->QG_CURRIC)	//Corrigir base, caso esteja sem codigo de curriculo
	
				::Curric1:Curriculum	:=	GetSx8Num("SQG","QG_CURRIC",xFilial('SQG')+cRetSqlName)		//Curriculo
	
				If __lSX8
					While (GetSX8Len() > nSaveSX8SQG)
						ConfirmSX8()
					End
				Else
					RollBackSX8()
				Endif
	
				SQG->QG_CURRIC		:=	::Curric1:Curriculum					//Curriculo
	
			EndIf
	
		Else			//Inclusao
			nCodSQG:= (Val(GetSXENum("SQG","QG_CURRIC",xFilial('SQG')+cRetSqlName)))
			cCodSQG:= STRZero(nCodSQG,6)  
			::Curric1:Curriculum	:=	cCodSQG		//Curriculo
	
			If __lSX8
				While (GetSX8Len() > nSaveSX8SQG)
					ConfirmSX8()
				End
			Else
				RollBackSX8()
			Endif
	
			Reclock("SQG",.T.)
			SQG->QG_FILIAL		:=	xFilial("SQG")							//Filial
			SQG->QG_CURRIC		:=	::Curric1:Curriculum					//Curriculo
			SQG->QG_SITUAC		:=  '001'
		EndIf
	
		::Curric1:AreaCode 		:= If(Empty(::Curric1:AreaCode),"001",::Curric1:AreaCode)
		::Curric1:MeansSent 	:= If(Empty(::Curric1:MeansSent),"001", ::Curric1:MeansSent)  //Internet
	
		SQG->QG_DTCAD		:=	dDatabase									//Data de Cadastro
	
		//Campos Numericos
		SQG->QG_ULTSAL		:= 	::Curric1:LastSalary						//Ultimo Salario
		SQG->QG_PRETSAL		:=	::Curric1:ExpectedSalary 				 	//Pretensao Salarial
		SQG->QG_NOTA		:= 	::Curric1:TestGrade 						//Nota
		SQG->QG_TPTRAB		:= 	::Curric1:WorkedTime						//Tempo de Trabalho
		SQG->QG_TPEXPER		:= 	::Curric1:ExperienceTime 				  	//Tempo de Experiencia na Area
		SQG->QG_QTDEFIL := 	::Curric1:NumberOfChildren  				//Quantidade de filhos
		
		If SQG->(FieldPos("QG_DESCDEF")) > 0
			If AllTrim(::Curric1:HandCapped) == "1"
				SQG->QG_DESCDEF		:= 	::Curric1:HandCappedDesc      		//Descricao da deficiencia fisica
			Else
				SQG->QG_DESCDEF		:= 	""						      		//Descricao da deficiencia fisica
			EndIf
		EndIf
	
		// Grava todos os campos padroes (Caracter) utilizando Picture
		For nx := 1 To Len(aCampos)		
			If ( aCampos[Nx][1] != "QG_SITUAC" )
				If !Empty(aCampos[nx][3])
					SQG->( FieldPut(FieldPos(aCampos[nx][1]), Transform(aCampos[nx][2], aCampos[nx][3])) )
				Else
					SQG->( FieldPut(FieldPos(aCampos[nx][1]), aCampos[nx][2]) )
				EndIf
			EndIf	
		Next nx
	
		// Grava todos os campos de usuario utilizando Picture
		For ny := 1 To Len(aUserFields)
			If !Empty(aUserFields[ny][3]) .And. ValType(aUserFields[ny][2]) == "C"
				SQG->( FieldPut(FieldPos(aUserFields[ny][1]), Transform(aUserFields[ny][2], aUserFields[ny][3])) )
			Else
				SQG->( FieldPut(FieldPos(aUserFields[ny][1]), aUserFields[ny][2]) )
			EndIf
		Next ny
	
		SQG->( MsUnlock() )
		
		If !Empty(::Curric1:Analisys)
			APDMSMM(SQG->QG_ANALISE, NIL, NIL, ::Curric1:Analisys, 1, NIL, NIL, "SQG", "QG_ANALISE")	//Analise
		EndIf
	
		If !Empty(::Curric1:Experience)
			APDMSMM(SQG->QG_EXPER, NIL, NIL, ::Curric1:Experience, 1, NIL, NIL, "SQG", "QG_EXPER")		//Experiencia
		EndIf
		
	
		SetHistory(::UserCode, SQG->QG_CURRIC, ::Curric1)
		SetCourses(::UserCode, SQG->QG_CURRIC, ::Curric1)
		SetQualification(::UserCode, SQG->QG_CURRIC, ::Curric1)
		SetEvaluation(::UserCode, SQG->QG_CURRIC, ::Curric1)
		SetGraduation(::UserCode, SQG->QG_CURRIC, ::Curric1)
		SetLanguages(::UserCode, SQG->QG_CURRIC, ::Curric1)
		SetCertification(::UserCode, SQG->QG_CURRIC, ::Curric1)
		SetCharacters(::UserCode, SQG->QG_CURRIC, ::Curric1)
	
		If ExistBlock("WSRS10Curric")
			ExecBlock("WSRS10Curric",.F.,.F.,{Curric1}) //Rdmake recebe ParamIxb
		EndIf
	
	Else
		lRetorno := .F.
		SetSoapFault(STR0032, STR0002)//"Erro" - "Usuario nao autorizado"
	EndIf
	
	RestArea(aArea)
Return lRetorno 


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SetHistory	 ³ Autor ³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Historico de candidato no  ³±±
±±³          ³Curriculo.                          					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Historico		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetHistory(UserCode,CurricNum,Curric1)


Local aArea     	:= GetArea()
Local aUserFields	:= {}
Local aCampos		:= {}
Local lRetorno  	:= .T.
Local cSeek			:= ""
Local cArea			:= ""
Local cPict			:= ""
Local nx			:= 0
Local ny			:= 0
Local lWSRS10H   	:= ExistBlock("WSRS10Hist")
//Historico Profissional
dbSelectArea("SQL")
dbSetOrder(1)

cSeek := xFilial("SQL")+CurricNum
dbSeek(cSeek)
While !Eof() .And. SQL->QL_CURRIC == CurricNum
	Reclock("SQL",.F.)
		dbDelete()
	MsUnlock()
	dbSkip()
EndDo

For nx := 1 To Len( Curric1:ListOfHistory )

	cArea := If(Empty(Curric1:ListOfHistory[nx]:AreaCode),"",Curric1:ListOfHistory[nx]:AreaCode)

	Reclock("SQL",.T.)
		SQL->QL_FILIAL		:= xFilial("SQL")								//Filial
		SQL->QL_CURRIC		:= CurricNum									//Curriculo
		SQL->QL_DTADMIS		:= Curric1:ListOfHistory[nx]:AdmissionDate		//Dt Admissao
		SQL->QL_DTDEMIS		:= Curric1:ListOfHistory[nx]:DismissalDate		//Dt Demissao
		SQL->QL_AREA		:= cArea							  			//Area
		SQL->QL_EMPRESA		:= Curric1:ListOfHistory[nx]:Company   			//Empresa
		SQL->QL_FUNCAO		:= Curric1:ListOfHistory[nx]:FunctionCode		//Funcao

		If !Empty(Curric1:ListOfHistory[nx]:Activity)
			APDMSMM(QL_ATIVIDA,,,Curric1:ListOfHistory[nx]:Activity,1,,,"SQL","QL_ATIVIDA")	//Atividades
		EndIf

	SQL->( MsUnlock() )

	Reclock("SQL",.F.)
		//Campos Caracter
		aCampos := { 	{"QL_EMPRESA"	, Curric1:ListOfHistory[nx]:Company },;		//Empresa
						{"QL_FUNCAO"	, Curric1:ListOfHistory[nx]:FunctionCode };		//Funcao
					}

		// Grava todos os campos padroes (Caracter) utilizando Picture
		For ny := 1 To Len(aCampos)
			cPict := X3Picture(aCampos[ny][1])
			If !Empty(cPict)
				SQL->( &(aCampos[ny][1]) ) := Transform(aCampos[ny][2], X3Picture(aCampos[ny][1]))
			Else
				SQL->( &(aCampos[ny][1]) ) := aCampos[ny][2]
			EndIf
		Next ny

		aUserFields	:= {}
		PutUserFields("SQL",Curric1:ListOfHistory[nx]:UserFields,@aUserFields) // Campos usuario

		// Grava todos os campos de usuario utilizando Picture
		For ny := 1 To Len(aUserFields)
			cPict := X3Picture(aUserFields[ny][1])
			If !Empty(cPict) .And. ValType(aUserFields[ny][2]) == "C"
				SQL->( &(aUserFields[ny][1]) ) := Transform(aUserFields[ny][2], X3Picture(aUserFields[ny][1]))
			Else
				SQL->( &(aUserFields[ny][1]) ) := aUserFields[ny][2]
			EndIf
		Next ny
	SQL->( MsUnlock() )

	If lWSRS10H
		ExecBlock("WSRS10Hist",.F.,.F.,{Curric1:ListOfHistory[nx]}) //Rdmake recebe ParamIxb
	EndIf

Next nx

RestArea(aArea)
Return( lRetorno )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SetCourses	 ³ Autor ³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Cursos do candidato no     ³±±
±±³          ³Curriculo.                          					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Cursos		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetCourses(UserCode,CurricNum,Curric1)

Local aArea     	:= GetArea()
Local aCampos		:= {}
Local aUserFields	:= {}
Local lRetorno  	:= .T.
Local cSeek			:= ""
Local cPict			:= ""
Local nx			:= 0
Local ny			:= 0
Local aRetCampo		:= {}
Local lWSRS10Cou	:= ExistBlock("WSRS10Cour")

//Cursos do Candidato
dbSelectArea("SQM")
dbSetOrder(1)

cSeek := xFilial("SQM")+CurricNum
dbSeek(cSeek)
While !Eof() .And. SQM->QM_CURRIC == CurricNum
	If Val( FDesc("SQT",SQM->QM_CURSO,"QT_TIPO",,,1) ) == 4
		Reclock("SQM",.F.)
			dbDelete()
		MsUnlock()
	EndIf
	dbSkip()
EndDo

For nx := 1 To Len( Curric1:ListOfCourses )

	Reclock("SQM",.T.)
		SQM->QM_FILIAL		:= xFilial("SQM")							//Filial
		SQM->QM_CURRIC		:= CurricNum								//Curriculo
		SQM->QM_ENTIDAD		:= Curric1:ListofCourses[nx]:EntityDesc		//Entidade
		SQM->QM_DATA		:= Curric1:ListOfCourses[nx]:GraduationDate	//Data conclusao
		SQM->QM_CURSO		:= Curric1:ListOfCourses[nx]:CourseCode   	//Codigo do Curso
		SQM->QM_ESCOLAR		:= Curric1:ListOfCourses[nx]:Education		//Escolaridade
//		SQM->QM_NIVEL		:= Curric1:ListOfCourses[nx]:Grade			//Nivel de Curso
		SQM->QM_CDCURSO		:= Curric1:ListOfCourses[nx]:EmployCourse	//Curso Funcionario
		SQM->QM_CDENTID		:= Curric1:ListOfCourses[nx]:EntityCode 	//Entidade Funcionario
		aRetCampo:= ExisteCampo("QM_DCURSO",.F.,.F.,.T.)
		If aRetCampo[2]== 0
			SQM->QM_DCURSO		:= Curric1:ListOfCourses[nx]:CourseDesc
		Endif
		
		//Campos Caracter
		aCampos := { 	{"QM_ENTIDAD"	, Curric1:ListofCourses[nx]:EntityDesc		 };		//Entidade
					}

		// Grava todos os campos padroes (Caracter) utilizando Picture
		For ny := 1 To Len(aCampos)
			cPict := X3Picture(aCampos[ny][1])
			If !Empty(cPict)
				SQM->( &(aCampos[ny][1]) ) := Transform(aCampos[ny][2], X3Picture(aCampos[ny][1]))
			Else
				SQM->( &(aCampos[ny][1]) ) := aCampos[ny][2]
			EndIf
		Next ny

		aUserFields := {}
		PutUserFields("SQM",Curric1:ListOfCourses[nx]:UserFields,@aUserFields) // Campos usuario
		For ny := 1 To Len(aUserFields)
			cPict := X3Picture(aUserFields[ny][1])
			If !Empty(cPict) .And. ValType(aUserFields[ny][2]) == "C"
				SQM->( &(aUserFields[ny][1]) ) := Transform(aUserFields[ny][2], X3Picture(aUserFields[ny][1]))
			Else
				SQM->( &(aUserFields[ny][1]) ) := aUserFields[ny][2]
			EndIf
		Next ny
	SQM->( MsUnlock() )

	If lWSRS10Cou
		ExecBlock("WSRS10Cour",.F.,.F.,{Curric1:ListOfCourses[nx]}) //Rdmake recebe ParamIxb
	EndIf

Next nx

RestArea(aArea)
Return( lRetorno )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetQualification³ Autor³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Qualificacoes de candidato ³±±
±±³          ³no Curriculo.                        					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Qualificacoes	                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetQualification(UserCode,CurricNum,Curric1)

Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local cSeek			:= ""
Local nx			:= 0
Local ny			:= 0
Local aUserFields	:= {}
Local lWSRS10Qua	:= ExistBlock("WSRS10Qual")

// Qualificacoes do Candidato
dbSelectArea("SQI")
dbSetOrder(1)

cSeek := xFilial("SQI")+CurricNum
dbSeek(cSeek)
While !Eof() .And. SQI->QI_CURRIC == CurricNum
	Reclock("SQI",.F.)
		dbDelete()
	MsUnlock()
	dbSkip()
EndDo

For nx := 1 To Len( Curric1:ListOfQualification )

	Reclock("SQI",.T.)
		SQI->QI_FILIAL		:= xFilial("SQI")								//Filial
		SQI->QI_CURRIC		:= CurricNum									//Curriculo
		SQI->QI_GRUPO		:= Curric1:ListOfQualification[nx]:Group   		//Grupo
		SQI->QI_FATOR		:= Curric1:ListOfQualification[nx]:Factor		//Fator
		SQI->QI_GRAU		:= Curric1:ListOfQualification[nx]:Degree	   	//Grau
		SQI->QI_DATA		:= Curric1:ListOfQualification[nx]:DateFactor	//Data

		aUserFields	:= {}
		PutUserFields("SQI",Curric1:ListOfQualification[nx]:UserFields,@aUserFields)// Campos usuario
		For ny := 1 To Len(aUserFields)
			SQI->( &(aUserFields[ny][1]) ) := aUserFields[ny][2]
		Next ny
	SQI->( MsUnlock() )

	If lWSRS10Qua
		ExecBlock("WSRS10Qual",.F.,.F.,{Curric1:ListOfQualification[nx]}) //Rdmake recebe ParamIxb
	EndIf

Next nx


RestArea(aArea)
Return( lRetorno )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetEvaluation   ³ Autor³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Qualificacoes de candidato ³±±
±±³          ³no Curriculo.                        					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Avaliacoes	                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetEvaluation(UserCode,CurricNum,Curric1)

Local aArea     	:= GetArea()
Local lRetorno  	:= .T.
Local cSeek			:= ""
Local nx			:= 0
Local ny			:= 0
Local aUserFields	:= {}
Local lWSRS10Eva	:= ExistBlock("WSRS10Eval")

// Avaliacoes do Candidato
dbSelectArea("SQR")
dbSetOrder(1)

cSeek := xFilial("SQR")+CurricNum
dbSeek(cSeek)
While !Eof() .And. SQR->QR_CURRIC == CurricNum
	Reclock("SQR",.F.)
		dbDelete()
	MsUnlock()
	dbSkip()
EndDo

For nx := 1 To Len( Curric1:ListOfEvaluation )

	Reclock("SQR",.T.)
		SQR->QR_FILIAL		:= xFilial("SQR")								 	//Filial
		SQR->QR_CURRIC		:= CurricNum										//Curriculo
		SQR->QR_MAT			:= Curric1:ListOfEvaluation[nx]:Registration		//Matricula func.
		SQR->QR_TESTE		:= Curric1:ListOfEvaluation[nx]:Evaluation      	//Teste
		SQR->QR_TOPICO		:= Curric1:ListOfEvaluation[nx]:Subject 			//Topico
		SQR->QR_QUESTAO		:= Curric1:ListOfEvaluation[nx]:Question  	  		//Questao
		SQR->QR_ALTERNA		:= Curric1:ListOfEvaluation[nx]:Alternative			//Alternativa
		SQR->QR_RESULTA		:= Curric1:ListOfEvaluation[nx]:Adjustment   		//Resultado %
		SQR->QR_DURACAO		:= Curric1:ListOfEvaluation[nx]:Duration			//Duracao

		If !Empty(Curric1:ListOfEvaluation[nx]:DescAnswer)
			APDMSMM(QR_MRESPOS,,,Curric1:ListOfEvaluation[nx]:DescAnswer,1,,,"SQR","QR_MRESPOS")	//Resposta
		EndIf

		aUserFields := {}
		PutUserFields("SQR",Curric1:ListOfEvaluation[nx]:UserFields,@aUserFields)	// Campos usuario
		For ny := 1 To Len(aUserFields)
			SQR->( &(aUserFields[ny][1]) ) := aUserFields[ny][2]
		Next ny
	SQR->( MsUnlock() )

	If lWSRS10Eva
		ExecBlock("WSRS10Eval",.F.,.F.,{Curric1:ListOfEvaluation[nx]}) //Rdmake recebe ParamIxb
	EndIf

Next nx

RestArea(aArea)
Return( lRetorno )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SetGraduation ³ Autor ³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Formacao do candidato no   ³±±
±±³          ³Curriculo.                          					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Graduacoes	                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetGraduation(UserCode,CurricNum,Curric1)

Local aArea     	:= GetArea()
Local aUserFields	:= {}
Local aCampos		:= {}
Local lRetorno  	:= .T.
Local cSeek			:= ""
Local cPict			:= ""
Local nx			:= 0
Local ny			:= 0
Local aRetCampo	:= {}  
Local lWSRS10Gra	:= ExistBlock("WSRS10Grad")
//Cursos do Candidato
dbSelectArea("SQM")
dbSetOrder(1)

cSeek := xFilial("SQM")+CurricNum
dbSeek(cSeek)
While !Eof() .And. SQM->QM_CURRIC == CurricNum
	If Val( FDesc("SQT",SQM->QM_CURSO,"QT_TIPO",,,1) ) == 1
		Reclock("SQM",.F.)
			dbDelete()
		MsUnlock()
	EndIf
	dbSkip()
EndDo

For nx := 1 To Len( Curric1:ListOfGraduation )

	Reclock("SQM",.T.)
		SQM->QM_FILIAL		:= xFilial("SQM")									//Filial
		SQM->QM_CURRIC		:= CurricNum										//Curriculo
		SQM->QM_ENTIDAD		:= Curric1:ListOfGraduation[nx]:EntityDesc			//Entidade
		SQM->QM_DATA		:= Curric1:ListOfGraduation[nx]:GraduationDate		//Data conclusao
		SQM->QM_CURSO		:= Curric1:ListOfGraduation[nx]:CourseCode   		//Codigo do Curso
		SQM->QM_ESCOLAR		:= Curric1:ListOfGraduation[nx]:Education			//Escolaridade
		SQM->QM_NIVEL		:= Curric1:ListOfGraduation[nx]:Grade				//Nivel do Curso
		SQM->QM_CDCURSO		:= Curric1:ListOfGraduation[nx]:EmployCourse		//Curso Funcionario
		SQM->QM_CDENTID		:= Curric1:ListOfGraduation[nx]:EntityCode	 		//Entidade Funcionario
		aRetCampo:= ExisteCampo("QM_DCURSO",.F.,.F.,.T.)
		If aRetCampo[2]== 0
			SQM->QM_DCURSO		:= Curric1:ListOfGraduation[nx]:CourseDesc        
        Endif
		//Campos Caracter
		aCampos := { 	{"QM_ENTIDAD"	, Curric1:ListOfGraduation[nx]:EntityDesc	 };		//Entidade
					}

		// Grava todos os campos padroes (Caracter) utilizando Picture
		For ny := 1 To Len(aCampos)
			cPict := X3Picture(aCampos[ny][1])
			If !Empty(cPict)
				SQM->( &(aCampos[ny][1]) ) := Transform(aCampos[ny][2], X3Picture(aCampos[ny][1]))
			Else
				SQM->( &(aCampos[ny][1]) ) := aCampos[ny][2]
			EndIf
		Next ny

		aUserFields := {}
		PutUserFields("SQM",Curric1:ListOfGraduation[nx]:UserFields,@aUserFields) // Campos usuario
		For ny := 1 To Len(aUserFields)
			cPict := X3Picture(aUserFields[ny][1])
			If !Empty(cPict) .And. ValType(aUserFields[ny][2]) == "C"
				SQM->( &(aUserFields[ny][1]) ) := Transform(aUserFields[ny][2], X3Picture(aUserFields[ny][1]))
			Else
				SQM->( &(aUserFields[ny][1]) ) := aUserFields[ny][2]
			EndIF
		Next ny
	SQM->( MsUnlock() )

	If lWSRS10Gra
		ExecBlock("WSRS10Grad",.F.,.F.,{Curric1:ListOfGraduation[nx]}) //Rdmake recebe ParamIxb
	EndIf

Next nx

RestArea(aArea)
Return( lRetorno )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SetLanguages  ³ Autor ³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Idiomas do candidato no    ³±±
±±³          ³Curriculo.                          					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Idiomas		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetLanguages(UserCode,CurricNum,Curric1)

Local aArea     	:= GetArea()
Local aUserFields	:= {}
Local aCampos		:= {}
Local lRetorno  	:= .T.
Local cSeek			:= ""
Local cPict			:= ""
Local nx			:= 0
Local ny			:= 0
Local aRetCampo		:= {}
Local lWSRS10Lan	:= ExistBlock("WSRS10Lang")
// Qualificacoes do Candidato
dbSelectArea("SQM")
dbSetOrder(1)

cSeek := xFilial("SQM")+CurricNum
dbSeek(cSeek)
While !Eof() .And. SQM->QM_CURRIC == CurricNum
	If Val( FDesc("SQT",SQM->QM_CURSO,"QT_TIPO",,,1) ) == 3
		Reclock("SQM",.F.)
			dbDelete()
		MsUnlock()
	EndIf
	dbSkip()
EndDo

For nx := 1 To Len( Curric1:ListOfLanguages )

	Reclock("SQM",.T.)

		SQM->QM_FILIAL		:= xFilial("SQM")									//Filial
		SQM->QM_CURRIC		:= CurricNum										//Curriculo
		SQM->QM_ENTIDAD		:= Curric1:ListOfLanguages[nx]:EntityDesc			//Entidade
		SQM->QM_DATA		:= Curric1:ListOfLanguages[nx]:GraduationDate		//Data conclusao
		SQM->QM_CURSO		:= Curric1:ListOfLanguages[nx]:CourseCode   		//Codigo do Curso
		SQM->QM_ESCOLAR		:= Curric1:ListOfLanguages[nx]:Education			//Escolaridade
		SQM->QM_NIVEL		:= Curric1:ListOfLanguages[nx]:Grade				//Nivel do Curso
		SQM->QM_CDCURSO		:= Curric1:ListOfLanguages[nx]:EmployCourse			//Curso Funcionario
		SQM->QM_CDENTID		:= Curric1:ListOfLanguages[nx]:EntityCode	 		//Entidade Funcionario
		aRetCampo:= ExisteCampo("QM_DCURSO",.F.,.F.,.T.)
		If aRetCampo[2]== 0
			SQM->QM_DCURSO		:= Curric1:ListOfLanguages[nx]:CourseDesc        
        Endif
        
		//Campos Caracter
		aCampos := { 	{"QM_ENTIDAD"	, Curric1:ListOfLanguages[nx]:EntityDesc	 };		//Entidade
					}

		// Grava todos os campos padroes (Caracter) utilizando Picture
		For ny := 1 To Len(aCampos)
			cPict := X3Picture(aCampos[ny][1])
			If !Empty(cPict)
				SQM->( &(aCampos[ny][1]) ) := Transform(aCampos[ny][2], X3Picture(aCampos[ny][1]))
			Else
				SQM->( &(aCampos[ny][1]) ) := aCampos[ny][2]
			EndIf
		Next ny

		aUserFields	:= {}
		PutUserFields("SQM",Curric1:ListOfLanguages[nx]:UserFields,@aUserFields)// Campos usuario
		For ny := 1 To Len(aUserFields)
			cPict := X3Picture(aUserFields[ny][1])
			If !Empty(cPict) .And. ValType(aUserFields[ny][2]) == "C"
				SQM->( &(aUserFields[ny][1]) ) := Transform(aUserFields[ny][2], X3Picture(aUserFields[ny][1]))
			Else
				SQM->( &(aUserFields[ny][1]) ) := aUserFields[ny][2]
			EndIf
		Next ny
	SQM->( MsUnlock() )

	If lWSRS10Lan
		ExecBlock("WSRS10Lang",.F.,.F.,{Curric1:ListOfLanguages[nx]}) //Rdmake recebe ParamIxb
	EndIf

Next nx


RestArea(aArea)
Return( lRetorno )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetCertificatio³ Autor ³Emerson Grassi Rocha³Data ³23/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Certificac. do candidato no³±±
±±³          ³Curriculo.                          					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Cursos		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetCertification(UserCode,CurricNum,Curric1)

Local aArea     	:= GetArea()
Local aUserFields	:= {}
Local aCampos		:= {}
Local lRetorno  	:= .T.
Local cSeek			:= ""
Local cPict			:= ""
Local nx			:= 0
Local ny			:= 0 
Local aRetCampo		:= {}
Local lWSRS10Cer	:= ExistBlock("WSRS10Cert")
//Cursos do Candidato
dbSelectArea("SQM")
dbSetOrder(1)

cSeek := xFilial("SQM")+CurricNum
dbSeek(cSeek)
While !Eof() .And. SQM->QM_CURRIC == CurricNum
	If Val( FDesc("SQT",SQM->QM_CURSO,"QT_TIPO",,,1) ) == 2
		Reclock("SQM",.F.)
			dbDelete()
		MsUnlock()
	EndIf
	dbSkip()
EndDo

For nx := 1 To Len( Curric1:ListOfCertification )

	Reclock("SQM",.T.)
		SQM->QM_FILIAL		:= xFilial("SQM")							   		//Filial
		SQM->QM_CURRIC		:= CurricNum										//Curriculo
		SQM->QM_ENTIDAD		:= Curric1:ListOfCertification[nx]:EntityDesc		//Entidade
		SQM->QM_DATA		:= Curric1:ListOfCertification[nx]:GraduationDate	//Data conclusao
		SQM->QM_CURSO		:= Curric1:ListOfCertification[nx]:CourseCode   	//Codigo do Curso
		SQM->QM_ESCOLAR		:= Curric1:ListOfCertification[nx]:Education		//Escolaridade
//		SQM->QM_NIVEL		:= Curric1:ListOfCertification[nx]:Grade			//Nivel de Curso
		SQM->QM_CDCURSO		:= Curric1:ListOfCertification[nx]:EmployCourse		//Curso Funcionario
		SQM->QM_CDENTID		:= Curric1:ListOfCertification[nx]:EntityCode	 	//Entidade Funcionario
		aRetCampo:= ExisteCampo("QM_DCURSO",.F.,.F.,.T.)
		If aRetCampo[2]== 0
			SQM->QM_DCURSO		:= Curric1:ListOfCertification[nx]:CourseDesc
		Endif
		
		//Campos Caracter
		aCampos := { 	{"QM_ENTIDAD"	, Curric1:ListOfCertification[nx]:EntityDesc	 };		//Entidade
					}

		// Grava todos os campos padroes (Caracter) utilizando Picture
		For ny := 1 To Len(aCampos)
			cPict := X3Picture(aCampos[ny][1])
			If !Empty(cPict)
				SQM->( &(aCampos[ny][1]) ) := Transform(aCampos[ny][2], X3Picture(aCampos[ny][1]))
			Else
				SQM->( &(aCampos[ny][1]) ) := aCampos[ny][2]
			EndIf
		Next ny

		aUserFields := {}
		PutUserFields("SQM",Curric1:ListOfCertification[nx]:UserFields,@aUserFields) // Campos usuario
		For ny := 1 To Len(aUserFields)
			cPict := X3Picture(aUserFields[ny][1])
			If !Empty(cPict) .And. ValType(aUserFields[ny][2]) == "C"
				SQM->( &(aUserFields[ny][1]) ) := Transform(aUserFields[ny][2], X3Picture(aUserFields[ny][1]))
			Else
				SQM->( &(aUserFields[ny][1]) ) := aUserFields[ny][2]
			EndIf
		Next ny
	SQM->( MsUnlock() )

	If lWSRS10Cer
		ExecBlock("WSRS10Cert",.F.,.F.,{Curric1:ListOfCertification[nx]}) //Rdmake recebe ParamIxb
	EndIf

Next nx

RestArea(aArea)
Return( lRetorno )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetCharacters³ Autor ³Leandro Drumond       ³Data ³06/06/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo de inclusao / alteracao de Caracteristicasdo candidato³±±
±±³          ³no Curriculo.                        					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo do Curriculo	                               ³±±
±±³          ³ExpC3: Lista de Cursos		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH		                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SetCharacters(UserCode,CurricNum,Curric1)

Local aArea     	:= GetArea()
Local aUserFields	:= {}
Local cPict			:= ""
Local nX			:= 0
Local nY			:= 0 

//Cursos do Candidato
dbSelectArea("SM6")
dbSetOrder(1)

For nX := 1 To Len( Curric1:ListOfCharacters )
	If SM6->(DbSeek(xFilial("SM6")+CurricNum+Curric1:ListOfCharacters[nX]:Code))
		Reclock("SM6",.F.)
	Else
		Reclock("SM6",.T.)
		SM6->M6_FILIAL		:= xFilial("SM6")							   		//Filial
		SM6->M6_CURRIC		:= CurricNum										//Curriculo
		SM6->M6_TIPO		:= Curric1:ListOfCharacters[nX]:Code				//Tipo de Caracteristica
	EndIf

	SM6->M6_RESP		:= Curric1:ListOfCharacters[nX]:Answer		//Resposta dissertativa
	SM6->M6_ALTERNA		:= Curric1:ListOfCharacters[nX]:Choice   	//Alternativa(s) selecionada(s)

	aUserFields := {}
	PutUserFields("SM6",Curric1:ListOfCharacters[nX]:UserFields,@aUserFields) // Campos usuario
	For nY := 1 To Len(aUserFields)
		cPict := X3Picture(aUserFields[nY][1])
		If !Empty(cPict) .And. ValType(aUserFields[nY][2]) == "C"
			SM6->( &(aUserFields[nY][1]) ) := Transform(aUserFields[nY][2], X3Picture(aUserFields[nY][1]))
		Else
			SM6->( &(aUserFields[nY][1]) ) := aUserFields[nY][2]
		EndIf
	Next nY
	SM6->( MsUnlock() )

Next nX

RestArea(aArea)

Return(Nil)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetEmail	    ³Autor  ³ Juliana Barros		³ Data ³28/01/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina para consulta de e-mail pelo cpf			           	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     	   ³±±
±±³			 ³ExpC2: CPF	 			                                  	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: E-mail do usuario							          	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                  	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetEmail WSRECEIVE UserCode,CurricCpf WSSEND Personal WSSERVICE RhCurriculum

Local aArea    	:= GetArea()
Local lRetorno	:= .T.

If ::UserCode=="ADMINISTRADOR" .Or. PrtChkUser(::UserCode,"RhCurriculum")

	DbSelectArea("SQG")
	dbSetOrder(3)

	If dbSeek(xFilial("SQG")+::CurricCpf)
		::Personal:Email		:= SQG->QG_EMAIL
		::Personal:Pass			:= SQG->QG_SENHA

        If 	!Empty(AllTrim(GetNewPar("MV_RHCONTA",""))) .And.;
        	!Empty(AllTrim(GetNewPar("MV_RHSENHA",""))) .And.;
        	!Empty(AllTrim(GetNewPar("MV_RHSERV","")))

			::Personal:EmailAccount	:= AllTrim(GetMV("MV_RHCONTA"))
			::Personal:EmailPass	:= AllTrim(GetMV("MV_RHSENHA"))
			::Personal:EmailServ	:= AllTrim(GetMV("MV_RHSERV"))
		Else
			::Personal:EmailAccount	:= AllTrim(GetMV("MV_EMCONTA"))
			::Personal:EmailPass	:= AllTrim(GetMV("MV_EMSENHA"))
			::Personal:EmailServ	:= AllTrim(GetMV("MV_RELSERV"))
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault(STR0032,STR0007)//"Erro" - "Cpf nao encontrado"
	EndIf

Else
	lRetorno := .F.
	SetSoapFault(STR0032,STR0002)//"Erro" - "Usuario nao autorizado"
EndIf

RestArea(aArea)
Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetEmail2	    ³Autor  ³ Emerson Grassi Rocha	³ Data ³24/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina para configuracao de e-mail 				           	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     	   ³±±
±±³			 ³							                                  	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Servidor / Conta / Senha							          	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                  	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetEmail2 WSRECEIVE UserCode WSSEND Personal WSSERVICE RhCurriculum

Local lRetorno	:= .T.

If ::UserCode=="ADMINISTRADOR" .Or. PrtChkUser(::UserCode,"RhCurriculum")

	If 	!Empty(AllTrim(GetNewPar("MV_RHCONTA",""))) .And.;
       	!Empty(AllTrim(GetNewPar("MV_RHSENHA",""))) .And.;
       	!Empty(AllTrim(GetNewPar("MV_RHSERV","")))

		::Personal:Email		:= AllTrim(GetMV("MV_RHFALE"))
		::Personal:EmailAccount	:= AllTrim(GetMV("MV_RHCONTA"))
		::Personal:EmailPass	:= AllTrim(GetMV("MV_RHSENHA"))
		::Personal:EmailServ	:= AllTrim(GetMV("MV_RHSERV"))
	Else
		::Personal:Email		:= AllTrim(GetMV("MV_RHFALE"))
		::Personal:EmailAccount	:= AllTrim(GetMV("MV_EMCONTA"))
		::Personal:EmailPass	:= AllTrim(GetMV("MV_EMSENHA"))
		::Personal:EmailServ	:= AllTrim(GetMV("MV_RELSERV"))
	EndIf
Else
	lRetorno := .F.
	SetSoapFault(STR0032,STR0002)//"Erro" - "Usuario nao autorizado"
EndIf

Return(lRetorno)


function wsrsp010_xxx()
return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ X3Fields ³Autor  ³ Emerson Grassi Rocha  ³ Data ³04/09/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina para trazer caracteristicas de Campo	               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome do Campo	                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Objeto                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina retorna objeto com as caracteristicas do campo   ³±±
±±³          ³atraves do dicionario de dados (SX3).		                   ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portais     				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD X3Fields WSRECEIVE Alias, Field WSSEND FieldObj WSSERVICE RhCurriculum

Local aArea    	:= GetArea()
Local aAreaSX3 	:= SX3->(GetArea())
Local lRet		:= .F.

AcertSX3() //Retirar na proxima versao
dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek(::Field)
	::FieldObj:UserTitle   := X3Titulo()
	::FieldObj:UserName    := SX3->X3_CAMPO
	::FieldObj:UserType    := SX3->X3_TIPO
	::FieldObj:UserSize    := SX3->X3_TAMANHO
	::FieldObj:UserDec     := SX3->X3_DECIMAL
	::FieldObj:UserOblig   := X3Obrigat(SX3->X3_CAMPO)
	::FieldObj:UserPicture := SX3->X3_PICTURE
	::FieldObj:UserF3      := SX3->X3_F3
	::FieldObj:UserComboBox:= X3CBox()
	Do Case
		Case SX3->X3_TIPO == "N"
			::FieldObj:UserTag     := Str((::Alias)->(FieldGet(FieldPos(SX3->X3_CAMPO))),SX3->X3_TAMANHO,SX3->X3_DECIMAL)

		Case SX3->X3_TIPO == "D"
			::FieldObj:UserTag     := DTOS((::Alias)->(FieldGet(FieldPos(SX3->X3_CAMPO))))

		OtherWise
				::FieldObj:UserTag     := (::Alias)->(FieldGet(FieldPos(SX3->X3_CAMPO)))
	EndCase
	::FieldObj:UserTag := IIf(FieldObj:UserTag==Nil,"",FieldObj:UserTag)

	lRet := .T.

EndIf

RestArea(aAreaSX3)
RestArea(aArea)
Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AcertSx3 ³Autor  ³ Emerson Grassi Rocha  ³ Data ³04/09/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome do Campo	                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Objeto                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Correcao Dicionario de Dados (SX3).						   ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portais     				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AcertSx3()

Local aDados := {}
dbSelectArea("SX3")
dbSetOrder(2)

If dbSeek("QG_CIC")

	aAdd( aDados, { { 'QG_CIC'}, { { 'X3_TITULO', 'CPF'  }, { 'X3_DESCRIC', 'CPF' }, { 'X3_TITSPA', 'RFC',  }, { 'X3_DESCSPA', 'RFC' } } } )
	EngSX3117( aDados )

EndIf

Return Nil


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwCourse			³Autor ³ Rogerio Ribeiro ³Data ³10/12/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³															   ³±±
±±³          ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD BrwCourse WSRECEIVE Type, Page, Search WSSEND ListOfCoursesCurriculum WSSERVICE RhCurriculum
	Local oCourse
	Local nSkips	:= 0
	
	SELF:ListOfCoursesCurriculum := {}
	
	dbSelectArea("SQT")
	dbSetOrder(1)
	dbGoTop()	
	
	IF DBSeek(xFilial("SQT"))			
		While !Eof() .AND.;
				xFilial("SQT") == QT_FILIAL .AND.;
				Len(SELF:ListOfCoursesCurriculum) < 10				

	   	    If (!Empty(SELF:Search) .AND. !(Upper(SELF:Search) $ Upper(QT_DESCRIC)))
	   			DBSkip()
				Loop                    
			EndIf   	    
				
			If !(Val(QT_TIPO) == SELF:Type)
				DBSkip()
				Loop                    
			EndIf   	    
			
			If nSkips < (SELF:Page * 10)
				DBSkip()
				nSkips++
				Loop
			EndIf
			
			oCourse:= WSClassNew("CoursesCurriculum")

			oCourse:CourseCurriculumCode			:= QT_CURSO	//Codigo do Curso do Curriculo
			oCourse:CourseCurriculumDescription 	:= QT_DESCRIC	//Descricao do Curso do Curriculo
			
			aadd(SELF:ListOfCoursesCurriculum, oCourse)
			
			
			                   
		 	DBSkip()
		EndDo	   		
	ENDIF
Return .T.



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwEntity			³Autor ³ Rogerio Ribeiro ³Data ³10/12/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³															   ³±±
±±³          ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD BrwEntity WSRECEIVE Type, Page, Search WSSEND ListOfEntity WSSERVICE RhCurriculum
	Local oEntity
	Local nSkips	:= 0
	Local lExistPE	:= ExistBlock("WSRS10FL")
		
	SELF:ListOfEntity := {}
	
	dbSelectArea("RA0")
	dbSetOrder(2)
	dbGoTop()
	
	IF DBSeek(xFilial("RA0"))			
		While !Eof() .AND.;
				xFilial("RA0") == RA0_FILIAL .AND.;
				Len(SELF:ListOfEntity) < 10
				
	   	    If (!Empty(SELF:Search) .AND. !(Upper(SELF:Search) $ Upper(RA0_DESC)))
				DBSkip()
				Loop
			EndIf
			
			If !( Val(RA0_TIPO) == 0 .Or. Val(RA0_TIPO) == SELF:Type)
				DBSkip()
				Loop
			EndIf
							
			If nSkips < (SELF:Page * 10)
				DBSkip()
				nSkips++
				Loop
			EndIf
			
			If !lExistPE .Or. ExecBlock("WSRS10FL")
			
				oEntity:= WSClassNew("Entity")

				oEntity:EntityCode			:= RA0_ENTIDA	//Codigo da Entidades de Treinamento
				oEntity:EntityDescription	:= RA0_DESC		//Descricao da Entidades de Treinamento
			
				AAdd(SELF:ListOfEntity, oEntity)
			
			EndIf
			                   
		 	RA0->(DBSkip())
		EndDo	   		
	ENDIF
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetAssessMent		³Autor ³ Emerson Campos  ³Data ³17/09/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo responsavel por retornar as questoes e alternativas   ³±±
±±³          ³da avaliacao.												   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetAssessMent WSRECEIVE codAval WSSEND ListOfTestTypes WSSERVICE RhCurriculum
//TestTypes  QuestionsTestTypes  AlternativeQuestions
//ListOfTestTypes  ListOfQuestions  ListOfAlternative
Local aArea    	:= GetArea()
Local oTestTypes
Local oQuestions
Local oAlternative
Local nOrdSQQ := RetOrdem( "SQQ" , "QQ_FILIAL+QQ_TESTEP+QQ_ITEM+QQ_QUESTAO" )
Local nOrdSQO := RetOrdem( "SQO" , "QO_FILIAL+QO_QUESTAO" )
Local nOrdSQP := RetOrdem( "SQP" , "QP_FILIAL+QP_QUESTAO+QP_ALTERNA" )
Local nOrdRBL := RetOrdem( "RBL" , "RBL_FILIAL+RBL_ESCALAP+RBL_ITEM" )

	self:ListOfTestTypes := {}
	
	dbSelectArea("SQQ")
	SQQ->(dbSetOrder(nOrdSQQ))
	SQQ->(dbGoTop())
	
	If SQQ->(DbSeek(xFilial("SQQ")+::codAval))
		While SQQ->(!Eof()) .AND. SQQ->QQ_TESTE == ::codAval  
			oTestTypes	:= WSClassNew("TestTypes")
		    oTestTypes:Evaluation		:= SQQ->QQ_TESTE	  	//Avaliacao
			oTestTypes:Description 		:= SQQ->QQ_DESCRIC  	//Descricao
			oTestTypes:Item				:= SQQ->QQ_ITEM	  		//Item
			oTestTypes:Question			:= SQQ->QQ_QUESTAO 		//Questao
			oTestTypes:AreaCode			:= SQQ->QQ_AREA	 		//Codigo da Area
 			oTestTypes:Subject			:= SQQ->QQ_TOPICO	   	//Codigo do topico
  			oTestTypes:Duration			:= SQQ->QQ_DURACAO   	//Duracao do teste
   			oTestTypes:EvalType			:= SQQ->QQ_TIPO	  		//Tipo de Avaliacao
    		oTestTypes:ContServ			:= SQQ->QQ_SRVCNT	   	//Servidor de Conteudo
    		oTestTypes:ListOfQuestions	:= {}
    		 
    		dbSelectArea("SQO")
    		SQO->(dbSetOrder(nOrdSQO))
    		SQO->(dbGoTop())
    		
    		If SQO->(DbSeek(xFilial("SQO")+SQQ->QQ_QUESTAO))
    			While SQO->(!Eof()) .AND. SQO->QO_QUESTAO == SQQ->QQ_QUESTAO .AND. SQO->QO_ATIVO == '1'
    				oQuestions := WSClassNew("QuestionsTestTypes")	
	    			oQuestions:Question		   		:= SQO->QO_QUESTAO				//Cod. da questao
				    oQuestions:Description	   		:= SQO->QO_QUEST				//Descricao
				    oQuestions:AreaCode		   		:= SQO->QO_AREA					//Codigo da area
				    oQuestions:Subject		   		:= SQO->QO_TOPICO				//Codigo do topico
				    oQuestions:Points		   		:= Alltrim(Str(SQO->QO_PONTOS))	//Pontos da questao
				    oQuestions:Level				:= SQO->QO_NIVEL				// Nivel da questao
				    //QO_TIPOOBJ   1=Multipla escolha;2=Unica escolha;3=Dissertativa;4=Pontuacao
				    oQuestions:AnswerType 	   		:= SQO->QO_TIPOOBJ				//Tipo da resposta
				    oQuestions:Type					:= SQO->QO_TIPO  				//Tipo da utilizacao
				    oQuestions:QuestionDt	   		:= DtoC(SQO->QO_DATA)			//Data da questao
				    //1 = Sim; 2=Nao
				    oQuestions:Active				:= SQO->QO_ATIVO 				//Questao ativa
				    oQuestions:Alternative			:= SQO->QO_ESCALA				//Alternativa escala
				    oQuestions:DetDescCd			:= SQO->QO_CODMEM				//Cod descricao detalhada
					oQuestions:ListOfAlternative	:= {}
										
					If SQO->QO_TIPOOBJ <> '3'
						 
						If Empty(SQO->QO_ESCALA) 
							dbSelectArea("SQP")
				    		SQP->(dbSetOrder(nOrdSQP))
				    		SQP->(dbGoTop())
				    		
				    		If SQP->(DbSeek(xFilial("SQP")+SQO->QO_QUESTAO))    			    			
				    			While SQP->(!Eof()) .AND. SQP->QP_QUESTAO == SQO->QO_QUESTAO
				    				oAlternative := WSClassNew("AlternativeQuestions")
				    				oAlternative:AreaCode		   		:= SQP->QP_AREA		   				//Cod da area
								    oAlternative:Subject		   		:= SQP->QP_TOPICO	   				//Codigo do topico
								    oAlternative:Code			   		:= ''				   				//Codigo
								    oAlternative:Question		   		:= SQP->QP_QUESTAO 	   				//Questao
								    oAlternative:Alternative	   		:= SQP->QP_ALTERNA  				//Cod alternativa
								    oAlternative:Description	   		:= SQP->QP_DESCRIC 					//Descricao
								    oAlternative:Value					:= Alltrim(Str(SQP->QP_PERCENT)) 	//Valor
								    AAdd(oQuestions:ListOfAlternative, oAlternative)
								    
				    				SQP->(DBSkip())				    			
								EndDo  
				    		EndIf
				    	Else //!Empty(SQO->QO_ESCALA) 
				    		dbSelectArea("RBL")
				    		RBL->(dbSetOrder(nOrdRBL))
				    		RBL->(dbGoTop())
				    		
				    		If RBL->(DbSeek(xFilial("RBL")+SQO->QO_ESCALA))    			    			
				    			While RBL->(!Eof()) .AND. RBL->RBL_ESCALA == SQO->QO_ESCALA
				    				oAlternative := WSClassNew("AlternativeQuestions")
				    				oAlternative:AreaCode		   		:= ''				   				//Cod da area
								    oAlternative:Subject		   		:= ''	   							//Codigo do topico
								    oAlternative:Code			   		:= RBL->RBL_ESCALA	   				//Codigo
								    oAlternative:Question		   		:= '' 	   							//Questao
								    oAlternative:Alternative	   		:= RBL->RBL_ITEM 					//Item
								    oAlternative:Description	   		:= RBL->RBL_DESCRI 					//Descricao
								    oAlternative:Value					:= Alltrim(Str(RBL->RBL_VALOR))		//Valor
				    				AAdd(oQuestions:ListOfAlternative, oAlternative)
				    				RBL->(DBSkip())				    			
								EndDo  
				    		EndIf
				    	EndIf	 		
					EndIf
					AAdd(oTestTypes:ListOfQuestions, oQuestions)
    				SQO->(DBSkip())
				EndDo  
    		EndIf    
			
			AAdd(self:ListOfTestTypes, oTestTypes)
			SQQ->(DBSkip())
		EndDo
    EndIf
	RestArea(aArea)
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetAssessMent		³Autor ³ Emerson Campos  ³Data ³19/09/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo responsavel por gravar as questoes e alternativas da  ³±±
±±³          ³avaliacao na tabela SQR									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD SetAssessMent WSRECEIVE EvaluationData WSSEND FinalScore WSSERVICE RhCurriculum
Local lRet	:= .T. 
Local nTam	:= Len(EvaluationData:LISTOFEVALUATION)
Local nI
Local nOrdSQG := RetOrdem( "SQG" , "QG_FILIAL+QG_CURRIC" )

Self:FinalScore	:= 0

For nI := 1 To nTam
	If !Empty(EvaluationData:ListOfEvaluation[nI]:Evaluation) .AND.;
		!Empty(EvaluationData:ListOfEvaluation[nI]:Question) .AND.;
		 !Empty(EvaluationData:ListOfEvaluation[nI]:Alternative)
				
		DbSelectArea("SQR") 
		
		SQR->(RecLock("SQR", .T.))
			SQR->QR_FILIAL     	:= xFilial("SQR")
			SQR->QR_CURRIC		:= EvaluationData:ListOfEvaluation[nI]:Curriculum
			SQR->QR_MAT			:= ''
			SQR->QR_TESTE		:= EvaluationData:ListOfEvaluation[nI]:Evaluation
			SQR->QR_TOPICO		:= EvaluationData:ListOfEvaluation[nI]:Subject
			SQR->QR_QUESTAO		:= EvaluationData:ListOfEvaluation[nI]:Question
			SQR->QR_ALTERNA		:= EvaluationData:ListOfEvaluation[nI]:Alternative
			SQR->QR_RESULTA		:= EvaluationData:ListOfEvaluation[nI]:AdJustment
			SQR->QR_DURACAO		:= EvaluationData:ListOfEvaluation[nI]:Duration
			SQR->QR_VAGA		:= EvaluationData:ListOfEvaluation[nI]:VacancyCode
			SQR->QR_DATA		:= dDataBase
			If !Empty(EvaluationData:ListOfEvaluation[1]:DescAnswer)
				APDMSMM(SQR->QR_MRESPOS,,,EvaluationData:ListOfEvaluation[nI]:DescAnswer,1,,,"SQR","QR_MRESPOS")
			EndIf
		
		SQR->(MsUnLock())     // Destrava o registro
		
		Self:FinalScore	+= EvaluationData:ListOfEvaluation[nI]:AdJustment
	EndIf
Next nI

If nI > 0 .AND. !Empty(Self:FinalScore) 
	dbSelectArea("SQG")
	SQG->(dbSetOrder(nOrdSQG))	//Filial+Curric
	
	cSeek := xFilial("SQG")+EvaluationData:ListOfEvaluation[1]:Curriculum
	
	If SQG->(dbSeek(cSeek))	//Alteracao
	
		SQG->(Reclock("SQG",.F.))
			SQG->QG_NOTA	:= Self:FinalScore
			SQG->QG_ULTVAGA	:= EvaluationData:ListOfEvaluation[1]:VacancyCode
			SQG->QG_ULTDATA	:= dDataBase
		SQG->(MsUnLock())
		
    EndIf
EndIf
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GetSchedule  	³Autor ³ Emerson Campos  ³Data ³03/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método responsável por retornar as vagas que consta na agenda³±±
±±³          ³do candidato.          									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetSchedule WSRECEIVE CurricCode, CurrentPage, FilterField, FilterValue WSSEND ScheduleData WSSERVICE RhCurriculum
Local lRet	:= .T.
DEFAULT Self:CurrentPage:= 1
DEFAULT Self:FilterField:= ""
DEFAULT Self:FilterValue:= ""

Self:ScheduleData:ListOfRequest :=         fGetMySchedule(Self:CurricCode, NIL, Self:FilterField, Self:FilterValue, .F., .T.)
Self:ScheduleData:PagesTotal 	:= Ceiling(fGetMySchedule(Self:CurricCode, NIL, Self:FilterField, Self:FilterValue, .T., .F.) / PAGE_LENGTH)

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GetActivity		³Autor ³ Emerson Campos  ³Data ³03/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método responsável por retornar os detalhes da vaga que      ³±±
±±³          ³consta na agenda do candiato.  							   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetActivity WSRECEIVE CurricCode, VacancyCode WSSEND ScheduleData WSSERVICE RhCurriculum
Local lRet	:= .T.
	Self:ScheduleData:ListOfRequest 	:=  fGetMySchedule(Self:CurricCode, self:VacancyCode, Nil, Nil, .F., .F.) 
Return lRet

Static Function fGetMySchedule(cCurric, cVacancyCode, cFilterField, cFilterValue, lCount, lDistinct)
	Local aArea			:= GetArea()
	Local aAreaSQD		:= SQD->(GetArea())
	Local cSQDAlias		:= GetNextAlias()
	Local xReturn
	Local cWhere		:= "%"
	Local cFields
	Local cJoin			:= "%" + FWJoinFilial("SQS", "SQD") + "%"
	
	Default lCount		:= .F.
	
	cFields:= "%" + IIF(lCount, "COUNT(Distinct(SQD.QD_VAGA)) AS VAGAS", IIF(lDistinct, "Distinct(SQD.QD_VAGA), SQS.QS_DESCRIC" ,"SQS.QS_DESCRIC, SQD.QD_VAGA, SQD.QD_TPPROCE, SQD.QD_HORA, SQD.QD_DATA, SQD.QD_CODOBSC, SQD.QD_SITPROC")) + "%"
    
    cWhere += "SQD.QD_FILIAL =  '" + xFilial("SQD") + "'" 
    If !Empty(cCurric)
		cWhere += " AND SQD.QD_CURRIC = '" + cCurric + "'"
	EndIf
	
	If !Empty(cVacancyCode)
		cWhere += " AND SQD.QD_VAGA = '" + cVacancyCode + "'"
	EndIf
	
	//filtro da vaga		
	If !Empty(cFilterField) .AND. !Empty(cFilterValue)
		If !(Substr(cFilterField,1,1) == "@")
			cWhere += " AND " + cFilterField + " LIKE '%" + cFilterValue + "%'"
		EndIf
	EndIf

	cWhere += "%"
	
	BEGINSQL ALIAS cSQDAlias
			SELECT %exp:cFields%
			FROM %table:SQD% SQD
	  INNER JOIN %table:SQS% SQS
			  ON %exp:cJoin%
			 AND SQS.QS_VAGA = SQD.QD_VAGA 
			WHERE SQD.%notDel% AND
			      SQS.%notDel% AND
			      %exp:cWhere%
	ENDSQL

	If lCount
		xReturn:= (cSQDAlias)->VAGAS
	ElseIf lDistinct
		xReturn:= {}
				
		While !(cSQDAlias)->(Eof()) 
			oRequest	:= WSClassNew("TScheduleRequest")
			oRequest:VacancyCode	:= (cSQDAlias)->QD_VAGA		//Codigo da Vaga
			oRequest:DescVacancy	:= (cSQDAlias)->QS_DESCRIC	//Descricao da Vagaa
			oRequest:DescProcess    := '' 	//Descr Processo seletivo      
			oRequest:DateScheduled	:= ''	//Data Agendada
			oRequest:TimeScheduled  := ''	//Hora Agendada			
			oRequest:ObsCand		:= ''	//Obs Candidato
		
			AAdd(xReturn, oRequest)
	
			(cSQDAlias)->(dbSkip())
		EndDo
	Else
		xReturn:= {}
		
		SQD->(dbSetOrder(3))
		While !(cSQDAlias)->(Eof())
			oRequest	:= WSClassNew("TScheduleRequest")
			oRequest:VacancyCode	:= (cSQDAlias)->QD_VAGA		//Codigo da Vaga
			oRequest:DescVacancy	:= (cSQDAlias)->QS_DESCRIC	//Descricao da Vagaa
			oRequest:DescProcess    := FDESC("XR9","R9"+(cSQDAlias)->QD_TPPROCE,"X5_DESCRI") //Descr Processo seletivo      
			oRequest:DateScheduled	:= (cSQDAlias)->QD_DATA		//Data Agendada
			oRequest:TimeScheduled  := (cSQDAlias)->QD_HORA		//Hora Agendada			
			If SQD->( DbSeek( xFilial("SQD") + cVacancyCode + cCurric ) )
				oRequest:ObsCand		:= AllTrim(If(Empty((cSQDAlias)->QD_CODOBSC),"",APDMSMM((cSQDAlias)->QD_CODOBSC,,,,3,,,"SQD",,"RDY")))	//Obs Candidato
			EndIf	
			If (cSQDAlias)->QD_SITPROC == '1'
				oRequest:SitEtapa		:= STR0037
			ElseIf (cSQDAlias)->QD_SITPROC == '2'
				oRequest:SitEtapa		:= STR0038
			Else
				oRequest:SitEtapa		:= STR0039 
			EndIf 
			AAdd(xReturn, oRequest)
			
			(cSQDAlias)->(dbSkip())
		EndDo
	EndIf
	
    (cSQDAlias)->(dbCloseArea())
	RestArea(aAreaSQD)
	RestArea(aArea)
Return xReturn

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SetAnexo      	³Autor ³ Emerson Campos  ³Data ³04/01/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método responsável por salvar anexos do candidato no ambiente³±±
±±³          ³do banco de conhecimento do Protheus.  					   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³	NewNameFile = Novo nome do arquivo       				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD SetAnexo WSRECEIVE CurricCode,PatchObject,DescObject WSSEND NewNameFile WSSERVICE RhCurriculum
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
	cNameServ	+= Alltrim(CurricCode)
	cNameServ	+= dToS(date())
	cNameServ	+= substr(Time(), 1, 2)+substr(Time(), 4, 2)+substr(Time(), 7, 2)
	cNameServ	+= cExten
	
	If MsMultDir()
		cDirDocs := MsRetPath( cNameServ )
	Else
		cDirDocs := MsDocPath()
	EndIf
	
	__CopyFile( PatchObject, cDirDocs + "\" + cNameServ )
	
	If !File( cDirDocs + "\" + cNameServ )
		lRet	:= .F.
		//STR0040 - "Falha ao localizar o arquivo!"
		//STR0041 - "Arquivo não pode ser localizado fisicamente no servidor: "
		//STR0042 - "Solu&ccedil;&atilde;o : Entre em contato com o suporte t&eacute;cnico da Totvs."
		SetSoapFault(STR0040,STR0041+PatchObject+"<br><br>"+STR0042)
	Else
		cCodObj := GetSXENum("ACB","ACB_CODOBJ")
		
		dbSelectArea( "ACB" )
		dbSetOrder(1)
		
		RecLock("ACB",.T.)
		ACB->ACB_FILIAL  := xFilial( "ACB" )
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
	
		AC9->AC9_FILIAL     := xFilial('AC9')   // Retorna a filial de acordo com as configurações do ERP Protheus	
		AC9->AC9_FILENT     := xFilial('SQG')	
		AC9->AC9_ENTIDA     := 'SQG'	
		AC9->AC9_CODENT     := xFilial('SQG')+AllTrim(CurricCode)
		AC9->AC9_CODOBJ 	:= cCodObj
		AC9->(MsUnLock())
		
		Self:NewNameFile	:= cNameServ	
	EndIf
	
	IF FErase(PatchObject) == -1
		lRet := .F.
		//STR0043 - "Falha ao excluir o arquivo!"
		//STR0044 - "Arquivo não pode ser deletado fisicamente no servidor: "
		//STR0045 - "Solu&ccedil;&atilde;o : Delete o arquivo manualmente no endere&ccedil;o informado acima."
		SetSoapFault(STR0043,STR0044+PatchObject+"<br><br>"+STR0045)
	EndIf
Else
	IF FErase(PatchObject) == -1
		//STR0043 - "Falha ao excluir o arquivo!"
		//STR0044 - "Arquivo não pode ser deletado fisicamente no servidor: "
		//STR0045 - "Solu&ccedil;&atilde;o : Delete o arquivo manualmente no endere&ccedil;o informado acima."
		cMsg := "<br><br><br>" + STR0043 + " : "+ STR0044 + PatchObject + "<br><br>" + STR0045
	EndIf
	lRet	:= .F.
	//STR0046 - "Envio de arquivo incompat&iacute;vel!"
	//STR0047 - "Não &eacute; permitido enviar arquivos do tipo execut&aacute;vel, exemplo .exe"
	//STR0048 - Solu&ccedil;&atilde;o : Envie apenas arquivos dos tipos permitidos.
	SetSoapFault(STR0046, STR0047 + "<br><br>" + STR0048 + cMsg) //"Participante invalido"
EndIf
		
RestArea(aAreaACB)
RestArea(aAreaAC9)
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GetInfoAnexo    	³Autor ³ Emerson Campos  ³Data ³04/01/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método responsável por buscar as informações de anexos do    ³±±
±±³          ³candidato no ambiente do banco de conhecimento do Protheus.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetInfoAnexo WSRECEIVE Branch, CurricCode, CurrentPage, FilterField, FilterValue WSSEND ObjectBrowse WSSERVICE RhCurriculum
	Local lRet	:= .T.	
	Local cFiltro
	Local cAC9CountAlias	:= GetNextAlias()
	Local cAC9Alias			:= GetNextAlias()
	Local nRegIni           := 1
	Local nRegFim			:= 0
	Local nReg				:= 0
		
	cFiltro	:= " AC9.AC9_ENTIDA = 'SQG'"
	cFiltro	+= " AND AC9.AC9_CODENT = '" + Branch+CurricCode + "'"
	
	If FilterField == "Objeto" .AND. Len(FilterValue) > 0
		cFiltro	+= " AND ACB.ACB_OBJETO LIKE '%" + AllTrim(FilterValue) + "%'"
	EndIf
	
	If FilterField == "Descricao" .AND. Len(FilterValue) > 0
		cFiltro	+= " AND ACB.ACB_DESCRI LIKE '%" + AllTrim(FilterValue) + "%'"
	EndIf
	
	cFiltro := "% " + cFiltro + " %"
   	 		
	Self:ObjectBrowse:= WSClassNew("TObjectBrowse")	   
	::ObjectBrowse:Itens := {}
	
	 
	BEGINSQL alias cAC9CountAlias
			SELECT COUNT(*) AS REGISTROS
		      FROM %table:AC9% AC9
	    INNER JOIN %table:ACB% ACB
		        ON ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
		     WHERE %exp:cFiltro% 
	           AND AC9.%notDel%		
	ENDSQL
	
	If (cAC9CountAlias)->REGISTROS > 0
	    // Seta a quantidade de paginas
		Self:ObjectBrowse:PagesTotal := Ceiling((cAC9CountAlias)->REGISTROS / PAGE_LENGTH) 
		
		// Define qual a página inicial e final de acordo com a paginacao corrente		
		nRegFim	:= CurrentPage * PAGE_LENGTH
		If CurrentPage > 1
			nRegIni	:= (nRegFim - PAGE_LENGTH) + 1			
		EndIf
		Self:ObjectBrowse:ExtPer		:= SuperGetMv( "MV_EXTPER", NIL,  '".png", ".gif", ".jpg", ".jpeg", ".odt", ".doc", ".docx", ".ods", ".xls", ".xlsx", ".pdf"')
		
		BEGINSQL alias cAC9Alias
				SELECT AC9.AC9_FILENT
					 , AC9.AC9_CODENT
			         , ACB.ACB_FILIAL
					 , ACB.ACB_CODOBJ
			         , ACB.ACB_OBJETO
			         , ACB.ACB_DESCRI
			      FROM %table:AC9% AC9
		    INNER JOIN %table:ACB% ACB
		            ON ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
			     WHERE %exp:cFiltro% 
		           AND ACB.%notDel% 
			  ORDER BY AC9.AC9_CODOBJ		
		ENDSQL   	
		
		While (cAC9Alias)->( !Eof())
		    nReg++
		    
	    	If nRegIni <= nReg .AND. nRegFim >=  nReg 
				oItem:= WSClassNew("TObjectList")
				oItem:Branch		:= (cAC9Alias)->ACB_FILIAL
				oItem:CodObj		:= (cAC9Alias)->ACB_CODOBJ
				oItem:Object		:= (cAC9Alias)->ACB_OBJETO
				oItem:Description	:= (cAC9Alias)->ACB_DESCRI
				oItem:FilEnt		:= (cAC9Alias)->AC9_FILENT				
				oItem:CodEnt		:= (cAC9Alias)->AC9_CODENT				
					
				AAdd(::ObjectBrowse:Itens, oItem)
			EndIf
	
			(cAC9Alias)->( dbSkip() )
		EndDo
	Else
		oItem:= WSClassNew("TObjectList")
		oItem:Branch		:= ''
		oItem:CodObj		:= ''
		oItem:Object		:= ''
		oItem:Description	:= ''		
		oItem:FilEnt		:= ''				
		oItem:CodEnt		:= ''
		
		AAdd(::ObjectBrowse:Itens, oItem)
		Self:ObjectBrowse:PagesTotal	:= 0	
	EndIf
	
	If MsMultDir()
		Self:ObjectBrowse:PathAnexo := MsRetPath( cNameServ )
	Else
		Self:ObjectBrowse:PathAnexo := MsDocPath()
	EndIf	

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GetInfoAnexo    	³Autor ³ Emerson Campos  ³Data ³04/01/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método responsável por excluir anexos do candidato salvos no ³±±
±±³          ³ambiente do banco de conhecimento do Protheus.  			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD DelAnexo WSRECEIVE Branch, CodObj, FilEnt, CodEnt WSSEND WsNull WSSERVICE RhCurriculum  
Local lRet	:= .T.
Local aAreaACB	 := ACB->(GetArea())  		//Salva a area atual
Local aAreaAC9   := AC9->(GetArea()) 		//Salva a area atual
Local cObjeto	 := ""
Local cDirDocs	 := ""

Private aExclui	 := {}
	
	//Deleta a ligação entre o candidato e o arquivo
  	DbSelectArea("AC9")
	AC9->( DbSetOrder(1) )
	AC9->( DbSeek(Branch + CodObj + "SQG" + FilEnt + CodEnt) )
	AC9->( RecLock("AC9",.F.) )
	AC9->( dbDelete() )
	AC9->( MsUnlock() )
	
	//Analisa a integridade para avaliar se o arquivo esta disponível a outro candidato 
	DbSelectArea("AC9")
	AC9->( DbSetOrder(1) )
	AC9->( DbSeek(Branch + CodObj + "SQG") )
	
	If AC9->( EOF() )
		//Se nao houver relacionamento deleta o arquivo na ACB e fisicamente
		DbSelectArea("ACB")
		ACB->( DbSetOrder(1) )
		ACB->( DbSeek(Branch + CodObj) )
		cObjeto	:= ACB->ACB_OBJETO		
		ACB->( RecLock("ACB",.F.) )
		ACB->( dbDelete() )
		ACB->( MsUnlock() )
	
		If MsMultDir()
			cDirDocs := MsRetPath( cObjeto )
		Else
			cDirDocs := MsDocPath()
		EndIf

		If File( cDirDocs + "\" + cObjeto )			
			IF FErase(cDirDocs + "\" + cObjeto) == -1
				lRet := .F.
				//STR0043 - "Falha ao excluir o arquivo!"
				//STR0044 - "Arquivo não pode ser deletado fisicamente no servidor: "
				//STR0045 - "Solu&ccedil;&atilde;o : Delete o arquivo manualmente no endere&ccedil;o informado acima."
				SetSoapFault(STR0043,STR0044+cDirDocs + "\" + cObjeto+"<br><br>"+STR0045)
   			EndIf
		EndIf
		
	EndIf	

RestArea(aAreaACB)
RestArea(aAreaAC9)
Return lRet 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GetConfigField 	³Autor ³ Emerson Campos  ³Data ³11/01/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Método responsável por buscar as configurações dos campos   ³±±
±±³          ³ salvos na tabela RS1.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD GetConfigField WSRECEIVE Table WSSEND ObjectConfigField WSSERVICE RhCurriculum
	Local lRet	:= .T. 
	Local cFiltro 
	Local aArea		   		:= GetArea()
	Local cRS1Alias			:= GetNextAlias()
	Self:ObjectConfigField 	:= WSClassNew("TObjectConfigField")
	
	//Ao inserir um novo item aqui, nao esqueca de ajustar a alimentacaão no fonte PWSR010.APH para evitar falha
	Self:ObjectConfigField:ConfigName 						:= "SS"			//Nome do Candidato
	Self:ObjectConfigField:ConfigFirstName 					:= "SS"			//Primeiro nome do Candidato
	Self:ObjectConfigField:ConfigSecondName					:= "SS"			//Segundo Nome do Candidato
	Self:ObjectConfigField:ConfigFirstSurname 				:= "SS"			//Primeiro Sobrenome do Candidato
	Self:ObjectConfigField:ConfigSecondSurname				:= "SS"			//Segundo Nome do Candidato			
	Self:ObjectConfigField:ConfigAddress					:= "NS"			//Endereco
	Self:ObjectConfigField:ConfigAddressComplement			:= "NS"			//Complem
	Self:ObjectConfigField:ConfigZone						:= "SS"			//Bairro
	Self:ObjectConfigField:ConfigDistrict					:= "SS"			//Municip
	Self:ObjectConfigField:ConfigState						:= "SS"			//Estado
	Self:ObjectConfigField:ConfigZipCode					:= "SS"			//Cep
	Self:ObjectConfigField:ConfigPhone						:= "SS"			//Fone
	Self:ObjectConfigField:ConfigId							:= "SS"			//RG
	Self:ObjectConfigField:ConfigCpf						:= "SS"			//CPF
	Self:ObjectConfigField:ConfigEmployBookNr				:= "NS"			//Num CP
	Self:ObjectConfigField:ConfigEmployBookSr				:= "NS"			//Serie CP
	Self:ObjectConfigField:ConfigGender						:= "SS"			//Sexo
	Self:ObjectConfigField:ConfigMaritalStatus				:= "NS"			//Estado Civil
	Self:ObjectConfigField:ConfigOrigin						:= "NS" 		//Naturalidade - UF
	Self:ObjectConfigField:ConfigCodCityOri					:= "NS"			//Naturalidade - Código Municipio
	Self:ObjectConfigField:ConfigNationality				:= "NS"			//Nacionalidade
	Self:ObjectConfigField:ConfigDateofBirth				:= "SS"			//Data de Nascimento
	Self:ObjectConfigField:ConfigLastSalary					:= "NS"			//Ultimo Salario
	Self:ObjectConfigField:ConfigEmail						:= "SS"			//Email
	Self:ObjectConfigField:ConfigMobilePhone				:= "SS"			//Celular
	Self:ObjectConfigField:ConfigPassWord		   			:= "SS"			//Senha
	Self:ObjectConfigField:ConfigHandCapped		       		:= "NS"			//Deficiente fisico
	Self:ObjectConfigField:ConfigNumberOfChildren   		:= "NS"			//Quantidade de filhos	
	Self:ObjectConfigField:ConfigTypeCurriculum   			:= "NS"			//Tipo de currículo
	Self:ObjectConfigField:ConfigPlaceCode					:= "NS"			//Código do Cargo  
    
	cFiltro	:= " RS1.RS1_FILIAL = '" + xFilial('RS1')+"'"
	cFiltro	+= " AND RS1.RS1_TABELA = '" + Table+"'"
	cFiltro := "% " + cFiltro + " %"
	
	BEGINSQL alias cRS1Alias
			SELECT RS1.RS1_CAMPO
				 , RS1.RS1_OBRIGA
		         , RS1.RS1_VISUAL
		      FROM %table:RS1% RS1
		     WHERE %exp:cFiltro% 
	           AND RS1.%notDel% 
		  ORDER BY RS1.RS1_CAMPO		
	ENDSQL 	

	While (cRS1Alias)->( !Eof())
		If Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_NOME"			//Nome do Candidato
			Self:ObjectConfigField:ConfigName 			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_PRINOME"	//Primeiro nome do Candidato
			Self:ObjectConfigField:ConfigFirstName 		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_SECNOME"	//Segundo Nome do Candidato		
			Self:ObjectConfigField:ConfigSecondName		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_PRISOBR"	//Primeiro Sobrenome do Candidato
			Self:ObjectConfigField:ConfigFirstSurname 	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_SECSOBR"	//Segundo Nome do Candidato
			Self:ObjectConfigField:ConfigSecondSurname	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_RG"		//RG
			Self:ObjectConfigField:ConfigId				:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_CIC"		//CPF
			Self:ObjectConfigField:ConfigCpf			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_NUMCP"	//Num CP
			Self:ObjectConfigField:ConfigEmployBookNr	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_SERCP"	//Serie CP
			Self:ObjectConfigField:ConfigEmployBookSr	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_DTNASC"	//Data de Nascimento
			Self:ObjectConfigField:ConfigDateofBirth	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_ENDEREC"	//Endereco			
			Self:ObjectConfigField:ConfigAddress		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_COMPLEM"	//Complem
			Self:ObjectConfigField:ConfigAddressComplement := (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_BAIRRO"	//Bairro
			Self:ObjectConfigField:ConfigZone			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_MUNICIP" 	//Municipio
			Self:ObjectConfigField:ConfigDistrict		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_ESTADO" 	//Estado
			Self:ObjectConfigField:ConfigState			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_CEP"		//Cep
			Self:ObjectConfigField:ConfigZipCode		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_FONE"		//Fone
			Self:ObjectConfigField:ConfigPhone			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_FONECEL"	//Celular
			Self:ObjectConfigField:ConfigMobilePhone	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_EMAIL"	//Email
			Self:ObjectConfigField:ConfigEmail			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_SEXO" 	//Sexo
			Self:ObjectConfigField:ConfigGender			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_ESTCIV"	//Estado Civil
			Self:ObjectConfigField:ConfigMaritalStatus	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_NATURAL"	//Naturalidade - UF
			Self:ObjectConfigField:ConfigOrigin			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_MUNNASC"	//Naturalidade - Municipio
			Self:ObjectConfigField:ConfigCodCityOri			:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_NACIONA" 	//Nacionalidade
			Self:ObjectConfigField:ConfigNationality	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_DFISICO"	//Deficiente fisico
			Self:ObjectConfigField:ConfigHandCapped		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_QTDEFIL"	//Quantidade de filhos
			Self:ObjectConfigField:ConfigNumberOfChildren	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_TPCURRI"	//Tipo de curriculo
			Self:ObjectConfigField:ConfigTypeCurriculum	:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_ULTSAL"	//Ultimo Salario
			Self:ObjectConfigField:ConfigLastSalary		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_SENHA"	//Senha
			Self:ObjectConfigField:ConfigPassWord		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		ElseIf Alltrim((cRS1Alias)->RS1_CAMPO) == "QG_CODFUN"	//Código doCargo
			Self:ObjectConfigField:ConfigPlaceCode		:= (cRS1Alias)->RS1_OBRIGA+(cRS1Alias)->RS1_VISUAL
		EndIf		
		(cRS1Alias)->( dbSkip() )		
	EndDo
	(cRS1Alias)->( dbCloseArea() )
RestArea(aArea)
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ValidFieldPos 	³Autor ³ Emerson Campos  ³Data ³19/06/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Método responsável por verificar se um determinado campo    ³±±
±±³          ³ existe na base de dados                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD ValidFieldPos WSRECEIVE NmAlias, NmField WSSEND ExistField WSSERVICE RhCurriculum
Local lRet := .T.
::ExistField := .F.
	
	dbSelectArea(::NmAlias)
	dbSetOrder(1)
	
	If (FieldPos(::NmField)>0)
		::ExistField	:= .T.
	EndIf
	
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fTrocaSql			³Autor ³ Rogerio Ribeiro ³Data ³10/12/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³															   ³±±
±±³          ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function fTrocaSql(cText)

cText := StrTran(cText,'"','')
cText := StrTran(cText,"'","")
cText := StrTran(cText,"SELECT","")
cText := StrTran(cText,"DROP","")
cText := StrTran(cText,"-","")
cText := StrTran(cText,"WHERE","")

Return cText

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³BrwCity			³Autor ³ Rogerio Ribeiro ³Data ³10/12/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³															   ³±±
±±³          ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³															   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
WSMETHOD BrwCity WSRECEIVE Search WSSEND ListOfCity WSSERVICE RhCurriculum
	Local oEntity
	Local nSkips	:= 0
	
	SELF:ListOfEntity := {}
	
	dbSelectArea("CC2")
	dbSetOrder(1)
	
	IF CC2->(DBSeek(xFilial("CC2")+::Search))			
		While !CC2->(Eof()) .AND. xFilial("CC2") == CC2->CC2_FILIAL .AND. CC2->CC2_EST == ::Search
				
	   	    oEntity:= WSClassNew("City")
	   	    oEntity:CodCityOri			:= CC2->CC2_CODMUN	//Codigo do Municipio
			oEntity:CityOri			 	:= CC2->CC2_MUN		//Nome do Municipio
			oEntity:UFOri			 	:= CC2->CC2_EST		//Nome do Municipio
			
			AAdd(SELF:ListOfCity, oEntity)
			                   
		 	CC2->(DBSkip())
		EndDo	   		
	ENDIF
Return .T.
