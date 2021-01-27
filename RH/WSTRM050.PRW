#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSTRM050.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WSTRM050 ³ Autor ³Flavio COrrea			³ Data ³ 13/01/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Avaliações dos Treinamentos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ WSTRM050()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	DATA	 ³ Programador  ³Chamado³Manutencao Efetuada		      	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        		³		³                            		  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Function WSTRM050()
Return

WSSTRUCT TAgenda
	WSDATA Filial	     	AS String OPTIONAL
	WSDATA Matricula		AS String OPTIONAL
	WSDATA Nome				AS String OPTIONAL
	WSDATA Calendario		AS String OPTIONAL
	WSDATA Curso			AS String OPTIONAL
	WSDATA DescricaoCurso	AS String OPTIONAL
	WSDATA Turma			AS String OPTIONAL
	WSDATA CodAval	     	As String  OPTIONAL
	WSDATA DescricaoAval	AS String OPTIONAL
	WSDATA TipoAval			As String OPTIONAL
	WSDATA TipoProva		AS String OPTIONAL
	WSDATA DescrTipoProva	AS String OPTIONAL
	WSDATA DataAvaliacao	AS Date OPTIONAL
	WSDATA DataAvaliacao1	AS Date OPTIONAL
	WSDATA horaavaliacao	AS String OPTIONAL
	WSDATA realizado		AS boolean OPTIONAL
	WSDATA matriculaaval	AS String OPTIONAL
	WSDATA legenda			As String OPTIONAL
	WSDATA titulolegenda	As String OPTIONAL
	WSDATA editavel			As boolean OPTIONAL
	WSDATA RAJ_RECNO		As integer OPTIONAL
ENDWSSTRUCT

WSSTRUCT TAvaliacao
	WSDATA RAJ_RECNO		AS Integer OPTIONAL 
	WSDATA Duration			AS String
	WSDATA Answers 			AS Array Of TRespostas
ENDWSSTRUCT

WSSTRUCT TRespostas
	WSDATA QuestionCode		AS String
	WSDATA Answer			AS String
ENDWSSTRUCT 


//-------------------------------------------------------------------
/*/{Protheus.doc}  RHTrainingTest 

@author Flavio Correa
@since 12/01/2015
@version 12.0
/*/
//-------------------------------------------------------------------
WSSERVICE RHTrainingTest DESCRIPTION STR0001 //"Avaliações dos Treinamentos"
	WSDATA WsNull				AS String OPTIONAL 
	WSDATA FilialFunc			AS String OPTIONAL 
	WSDATA CodAval				AS String OPTIONAL 
	WSDATA Matricula			AS String OPTIONAL 
	WSDATA Tipo					AS String OPTIONAL 
	WSDATA RAJ_RECNO			As integer OPTIONAL
	WSDATA AgendaResult 		AS Array Of TAgenda OPTIONAL
	WSDATA RetTest		 		As TestTypes OPTIONAL    //Tipo de testes	- wsrhstruct.prw
	WSDATA Avaliacao 			AS TAvaliacao
	
	WSMETHOD BRWAGENDA	  DESCRIPTION STR0002 //"Agenda de Avaliações"      
	WSMETHOD GetAvaliacao DESCRIPTION STR0003//"Retorna avaliação"
	WSMETHOD PutAvaliacao DESCRIPTION STR0004//"Salva avaliação"
	
ENDWSSERVICE                                  


//-------------------------------------------------------------------
/*/{Protheus.doc}  BRWAGENDA

@author Flavio Correa
@since 12/01/2015
@version 12.0
/*/
//-------------------------------------------------------------------
WSMETHOD BRWAGENDA	WSRECEIVE FilialFunc, Matricula,Tipo	WSSEND AgendaResult WSSERVICE RHTrainingTest
Local aArea		:= GetArea()
Local cAliasTmp	:= ""
Local nI		:= 0
Local lRet		:= .T.
Local cWhere	:= "%%"
Local dDataF	
Local cHoraF

DEFAULT ::TIPO := "1" // 1=Tela de consulta;2=tela de avisos

If Empty(::FilialFunc)
	SetSoapFault("BRWAGENDA",STR0005 /*"Filial do funcionário é obrigatório"*/)
	lRet :=  .F.
EndIf

If Empty(::Matricula)
	SetSoapFault("BRWAGENDA",STR0006)//"Matricula do funcionário é obrigatório"
	lRet :=  .F.
EndIf

If ::TIPO == "2"
	cWhere := "% AND (RAJ.RAJ_OK = 'N' OR RAJ.RAJ_OK = ' ') AND ( ( RAJ.RAJ_DATA < '"+dtos(date()) +"' ) OR ( RAJ.RAJ_DATA = '"+ dtos(date())+ "' AND RAJ.RAJ_HORA <= '"+ Substr(time(),1,5) + "') )  %"
EndIf
If lRet
	cAliasTmp := GetNextAlias()
	BEGINSQL ALIAS cAliasTmp
		SELECT RAJ.*,SRA.RA_NOME,RA1.*, RAJ.R_E_C_N_O_ AS RAJ_RECNO 
		FROM %table:RAJ% RAJ
		INNER JOIN %table:RA1% RA1 on RA1.RA1_FILIAL = %xFilial:RA1% AND RA1.RA1_CURSO = RAJ.RAJ_CURSO AND RA1.%notDel%
		LEFT JOIN %table:SRA% SRA on SRA.RA_FILIAL = RAJ.RAJ_FILIAL AND  SRA.%notDel% AND RAJ.RAJ_MAT = SRA.RA_MAT
		WHERE RAJ.%notDel%
		AND RAJ.RAJ_FILIAL = %exp:self:FilialFunc%
		AND ( ( RAJ.RAJ_MAT = %exp:self:Matricula% AND RAJ.RAJ_QUEM <> '2' )	
		OR ( RAJ.RAJ_MATAVA = %exp:self:Matricula% AND RAJ.RAJ_QUEM = '2'  ) )
		%exp:cWhere%
		ORDER BY RAJ.RAJ_DATA DESC
	ENDSQL
	
	::AgendaResult := {}
	
	While !(cAliasTmp)->(Eof())

		dDataF := (cAliasTmp)->RAJ_DATAF
		cHoraF := (cAliasTmp)->RAJ_HORAF

		nI++
		aadd(::AgendaResult,WsClassNew("TAGENDA"))
		::AgendaResult[nI]:RAJ_RECNO		:= (cAliasTmp)->RAJ_RECNO
		::AgendaResult[nI]:Filial			:= (cAliasTmp)->RAJ_FILIAL
		::AgendaResult[nI]:Matricula		:= (cAliasTmp)->RAJ_MAT
		::AgendaResult[nI]:Nome				:= Alltrim((cAliasTmp)->RA_NOME)
		::AgendaResult[nI]:Calendario		:= (cAliasTmp)->RAJ_CALEND
		::AgendaResult[nI]:Curso			:= (cAliasTmp)->RAJ_CURSO
		::AgendaResult[nI]:DescricaoCurso	:= Alltrim((cAliasTmp)->RA1_DESC)
		::AgendaResult[nI]:Turma			:= (cAliasTmp)->RAJ_TURMA
		
		::AgendaResult[nI]:DataAvaliacao	:= Stod((cAliasTmp)->RAJ_DATA) 
		::AgendaResult[nI]:DataAvaliacao1	:= Stod(dDataF)
	
		
		If !Empty((cAliasTmp)->RAJ_TESTE)
			::AgendaResult[nI]:TipoAval			:= "1" //1=avaliacao;2=modelo
			::AgendaResult[nI]:CodAval			:= (cAliasTmp)->RAJ_TESTE
			::AgendaResult[nI]:DescricaoAval	:= Alltrim(FDESC("SQQ",(cAliasTmp)->RAJ_TESTE,"QQ_DESCRIC"))
			::AgendaResult[nI]:TipoProva		:= Alltrim(FDESC("SQQ",(cAliasTmp)->RAJ_TESTE,"QQ_TIPO"))
			::AgendaResult[nI]:DescrTipoProva	:= Alltrim(POSICIONE("SX5",1,XFILIAL("SX5")+ "RJ"+::AgendaResult[nI]:TipoProva,"X5DESCRI()"))
		ElseIf !Empty((cAliasTmp)->RAJ_MODELO)
			::AgendaResult[nI]:TipoAval			:= "2" //1=avaliacao;2=modelo
			::AgendaResult[nI]:CodAval			:= (cAliasTmp)->RAJ_MODELO
			::AgendaResult[nI]:DescricaoAval	:= Alltrim(FDESC("SQW",(cAliasTmp)->RAJ_MODELO,"QW_DESCRIC") )  
			::AgendaResult[nI]:TipoProva		:= Alltrim(FDESC("SQW",(cAliasTmp)->RAJ_MODELO,"QW_TIPO"))
			::AgendaResult[nI]:DescrTipoProva	:= Alltrim(POSICIONE("SX5",1,XFILIAL("SX5")+ "RJ"+::AgendaResult[nI]:TipoProva,"X5DESCRI()"))
		EndIf
		::AgendaResult[nI]:DataAvaliacao	:= Stod((cAliasTmp)->RAJ_DATA)
		::AgendaResult[nI]:horaavaliacao	:= (cAliasTmp)->RAJ_HORA
		If Empty((cAliasTmp)->RAJ_OK) .Or. (cAliasTmp)->RAJ_OK == "N"
			::AgendaResult[nI]:realizado		:= .F.
		ElseIf (cAliasTmp)->RAJ_OK == "S"
			::AgendaResult[nI]:realizado		:= .T.
		EndIf
		::AgendaResult[nI]:editavel := .F.
		If (dtos(date())  >= (cAliasTmp)->RAJ_DATA .And.  dtos(date())  <= dDataF  .And. (cAliasTmp)->RAJ_OK != 'S' ) .Or. (((cAliasTmp)->RAJ_DATA == dtos(date()) .And. Substr(time(),1,5) >= (cAliasTmp)->RAJ_HORA ) .And. ((cAliasTmp)->RAJ_DATA == dtos(date()) .And. Substr(time(),1,5) <= cHoraF))  
						
			IF (cAliasTmp)->RAJ_OK != 'S'
				::AgendaResult[nI]:legenda := "br_verde_ocean.png"
				::AgendaResult[nI]:titulolegenda := STR0007//"Pronta para iniciar!"
			ELSE
				::AgendaResult[nI]:legenda := "br_pink_ocean.png"
				::AgendaResult[nI]:titulolegenda := "Editar Respostas"//"Editar respostas!"
			EndIf			
			::AgendaResult[nI]:editavel := .T.
		ElseIf (cAliasTmp)->RAJ_OK == 'S'
			::AgendaResult[nI]:legenda := "br_vermelho_ocean.png"
			::AgendaResult[nI]:titulolegenda := STR0008//"Avaliação já realizada!"
		ElseIf (cAliasTmp)->RAJ_DATA > dtos(date()) .Or. ( (cAliasTmp)->RAJ_DATA == dtos(date()) .ANd. (cAliasTmp)->RAJ_HORA >= Substr(time(),1,5)  )
			::AgendaResult[nI]:legenda := "br_amarelo_ocean.png"
			::AgendaResult[nI]:titulolegenda := STR0009//"Avaliação agendada!"
		ElseIf  dtos(date()) > dDataF   .Or. (dDataF = dtos(date()) .And. Substr(time(),1,5) >= cHoraF )
			::AgendaResult[nI]:legenda := "br_azul_ocean.png"
			::AgendaResult[nI]:titulolegenda := STR0010//"Prazo expirado!"
		EndIf

		
		::AgendaResult[nI]:matriculaaval	:= (cAliasTmp)->RAJ_MATAVA
	
		(cAliasTmp)->(dbSkip())
	EndDo
	(cAliasTmp)->(dbCloseArea())
EndIf

If nI == 0
	SetSoapFault("BRWAGENDA",STR0011)//"Nenhuma avaliação disponível"
	lRet :=  .F.
EndIf

RestArea(aArea)
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc}  GetAvaliacao

@author Flavio Correa
@since 12/01/2015
@version 12.0
/*/
//-------------------------------------------------------------------
WSMETHOD GetAvaliacao WSRECEIVE CodAval,Tipo,RAJ_RECNO WSSEND RetTest WSSERVICE RHTrainingTest
//TestTypes  QuestionsTestTypes  AlternativeQuestions
//ListOfTestTypes  ListOfQuestions  ListOfAlternative
Local aArea    		:= GetArea()
Local oTestTypes
Local oQuestions
Local nI			:= 1
Local nX			:= 1
Local aQueAleat		:= {}
Local nAleat		:= ""
Local nQuest		:= 0
Local aQuest		:= {}
Local nOrdSQQ 		:= RetOrdem( "SQQ" , "QQ_FILIAL+QQ_TESTEP+QQ_ITEM+QQ_QUESTAO" )
Local nOrdSQO 		:= RetOrdem( "SQO" , "QO_FILIAL+QO_QUESTAO" )
Local lRet			:= .T.
Local cMsg			:= GetMV("MV_RSPMSG")

dbSelectArea("RAJ")
RAJ->(dbGoTo(::RAJ_RECNO))


If ::Tipo == "1" //avaliação	

	dbSelectArea("SQQ")
	SQQ->(dbSetOrder(nOrdSQQ))
	SQQ->(dbGoTop())
	
	If SQQ->(DbSeek(xFilial("SQQ")+::codAval))
		While SQQ->(!Eof()) .AND. SQQ->QQ_TESTE == ::codAval  
			If nI ==1
				oTestTypes	:= WSClassNew("TestTypes")
			    oTestTypes:Evaluation		:= SQQ->QQ_TESTE	  	//Avaliacao
				oTestTypes:Description 		:= Alltrim(SQQ->QQ_DESCRIC) 	//Descricao
				oTestTypes:Item				:= cMsg
	  			oTestTypes:Duration			:= SQQ->QQ_DURACAO   	//Duracao do teste
	   			oTestTypes:EvalType			:= SQQ->QQ_TIPO	  		//Tipo de Avaliacao
	    		oTestTypes:ContServ			:= SQQ->QQ_SRVCNT	   	//Servidor de Conteudo
	    		oTestTypes:ListOfQuestions	:= {}
	    	EndIf	 
    		
    		dbSelectArea("SQO")
    		SQO->(dbSetOrder(nOrdSQO))
    		SQO->(dbGoTop())
    		
    		If SQO->(DbSeek(xFilial("SQO")+SQQ->QQ_QUESTAO))    			    			
    			While SQO->(!Eof()) .AND. SQO->QO_QUESTAO == SQQ->QQ_QUESTAO .AND. SQO->QO_ATIVO == '1'    				
    				oQuestions := RetSQO()
    				AAdd(oTestTypes:ListOfQuestions, oQuestions)
    				SQO->(DBSkip())
				EndDo  
    		EndIf    
			nI++
			SQQ->(DBSkip())
		EndDo
		self:RetTest := oTestTypes
    Else
    	lRet := .F.
    EndIf
Else //modelo
	dbSelectArea("SQW")
	SQW->(dbSetOrder(1))
	If SQW->(dbSeek(xFilial("SQW")+::codAval))
		While !SQW->(Eof()) .And. SQW->(xFilial("SQW")+::codAval) == (xFilial("SQW")+SQW->QW_MODELO)
			nQuest 		:= 0
			aQuest 		:= {}
			aQueAleat 	:= {}
			If nI == 1
				oTestTypes	:= WSClassNew("TestTypes")
			    oTestTypes:Evaluation		:= SQW->QW_MODELO	  	//Avaliacao
				oTestTypes:Description 		:= Alltrim(SQW->QW_DESCRIC) 	//Descricao
				oTestTypes:Item				:= ""			 		//Item
	  			oTestTypes:Duration			:= SQW->QW_DURACAO   	//Duracao do teste
	   			oTestTypes:EvalType			:= SQW->QW_TIPO	  		//Tipo de Avaliacao
	    		oTestTypes:ContServ			:= ""				   	//Servidor de Conteudo
	    		oTestTypes:ListOfQuestions	:= {}
	    	EndIf	
			dbSelectArea("SQO")
			SQO->(dbSetOrder(2))
			SQO->(dbSeek(xFilial("SQO")+SQW->QW_TIPO+SQW->QW_AREA+SQW->QW_TOPICO ))
			While xFilial("SQO")+SQW->QW_TIPO+SQW->QW_AREA+SQW->QW_TOPICO  ==;
				xFilial("SQO")+SQO->QO_TIPO+SQO->QO_AREA+SQO->QO_TOPICO
				If SQO->QO_NIVEL >= SQW->QW_NIVELDE  .And. SQO->QO_NIVEL <= SQW->QW_NIVELAT
					Aadd(aQuest,Val(SQO->QO_QUESTAO))
					nQuest++
				EndIf
				SQO->(dbSkip())
			EndDo
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se no arquivo tiver mais questoes que o solicitado, busca aleatoriamente.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If nQuest > SQW->QW_FREQ
				aQueAleat 	:= {}
				For nx := 1 to SQW->QW_FREQ
					While .T.
						nAleat := Int(TrmAleat(nQuest))
						If nAleat > 0 .And. Ascan(aQueAleat,{|x| x == nAleat }) == 0
							Aadd(aQueAleat,nAleat)
							Exit
						EndIf
					EndDo
				Next nx
				
				For nX := 1 to Len(aQueAleat)
					dbSelectArea("SQO")
		    		SQO->(dbSetOrder(nOrdSQO))
		    		SQO->(dbGoTop())
		    		If SQO->(DbSeek(xFilial("SQO")+strzero(aQuest[aQueAleat[nx]],3)))    
						oQuestions := RetSQO()
	    				AAdd(oTestTypes:ListOfQuestions, oQuestions)
					EndIf
				Next nX
			Else
				For nX := 1 to Len(aQuest)
					dbSelectArea("SQO")
		    		SQO->(dbSetOrder(nOrdSQO))
		    		SQO->(dbGoTop())
		    		If SQO->(DbSeek(xFilial("SQO")+strzero(aQuest[nx],3)))    
						oQuestions := RetSQO()
	    				AAdd(oTestTypes:ListOfQuestions, oQuestions)
					EndIf
				Next nX
			EndIf
			SQW->(dbSkip())
			nI++
		EndDo
		self:RetTest := oTestTypes
    Else
    	lRet := .F.
	EndIf
EndIf

If lRet
	If Len(oTestTypes:ListOfQuestions) == 0
		lRet := .F.
		SetSoapFault("GetAvaliacao",STR0012)//"Montagem da avaliação indevida, não foram encontradas questões."
	EndIf
Else
	SetSoapFault("GetAvaliacao",STR0013)//"Avaliação não encontrada"
EndIf

RestArea(aArea)
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc}  RetSQO

@author Flavio Correa
@since 12/01/2015
@version 12.0
/*/
//-------------------------------------------------------------------
Static Function RetSQO
Local oAlternative
Local nOrdSQP 		:= RetOrdem( "SQP" , "QP_FILIAL+QP_QUESTAO+QP_ALTERNA" )
Local nOrdRBL 		:= RetOrdem( "RBL" , "RBL_FILIAL+RBL_ESCALAP+RBL_ITEM" )
Local oQuestions := WSClassNew("QuestionsTestTypes")	
Local cCodAval	:= If(Empty(RAJ->RAJ_TESTE), RAJ->RAJ_MODELO, RAJ->RAJ_TESTE)
oQuestions:Question		   		:= SQO->QO_QUESTAO				//Cod. da questao
oQuestions:Description	   		:= Alltrim(SQO->QO_QUEST)				//Descricao
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
 If RAJ->RAJ_OK == "S"
	dbSelectArea("RAI")
	RAI->(dbSetOrder(1))
	If RAI->(dbSeek(RAJ->RAJ_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA+RAJ->RAJ_MAT+Padr(cCodAval,4)+SQO->QO_QUESTAO))
		If  RAI->RAI_ALTERN == "00"
			oQuestions:DetDescCd			:= APDMSMM(RAI->RAI_MRESPO,,,,3)
		Else
			oQuestions:DetDescCd			:=  SQO->QO_CODMEM
		EndIf
	EndIf
Else
	oQuestions:DetDescCd			:= SQO->QO_CODMEM				//Cod descricao detalhada
EndIf

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
			    oAlternative:Description	   		:= Alltrim(SQP->QP_DESCRIC)				//Descricao
			    oAlternative:Value					:= Alltrim(Str(SQP->QP_PERCENT)) 	//Valor
			    oAlternative:resposta := ""
			    If RAJ->RAJ_OK == "S"
					dbSelectArea("RAI")
					RAI->(dbSetOrder(1))
					If RAI->(dbSeek(RAJ->RAJ_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA+RAJ->RAJ_MAT+Padr(cCodAval,4)+SQO->QO_QUESTAO+SQP->QP_ALTERNA))
						If  RAI->RAI_ALTERN == "00"
							oAlternative:resposta			:= APDMSMM(RAI->RAI_MRESPO,,,,3)
						Else
							oAlternative:resposta			:= RAI->RAI_ALTERN
						EndIf
					EndIf
				EndIf
			    
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
			    oAlternative:Description	   		:= Alltrim(RBL->RBL_DESCRI)			//Descricao
			    oAlternative:Value					:= Alltrim(Str(RBL->RBL_VALOR))		//Valor
			    oAlternative:resposta := ""
			    If RAJ->RAJ_OK == "S"
					dbSelectArea("RAI")
					RAI->(dbSetOrder(1))
					If RAI->(dbSeek(RAJ->RAJ_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA+RAJ->RAJ_MAT+Padr(cCodAval,4)+SQO->QO_QUESTAO+RBL->RBL_ITEM ))
						If  RAI->RAI_ALTERN == "00"
							oAlternative:resposta			:= APDMSMM(RAI->RAI_MRESPO,,,,3)
						Else
							oAlternative:resposta			:= RAI->RAI_ALTERN
						EndIf
					EndIf
				EndIf
				AAdd(oQuestions:ListOfAlternative, oAlternative)
				RBL->(DBSkip())				    			
			EndDo  
		EndIf
	EndIf	 		
EndIf

Return oQuestions

//-------------------------------------------------------------------
/*/{Protheus.doc}  PutAvaliacao

@author Flavio Correa
@since 12/01/2015
@version 12.0
/*/
//-------------------------------------------------------------------
WSMETHOD PutAvaliacao WSRECEIVE Avaliacao WSSEND AgendaResult WSSERVICE RHTrainingTest
Local aArea		:= GetArea()
Local lRet		:= .T.
Local cCalend	:= ""
Local cCurso	:= ""
Local cTurma 	:= ""
Local cFilRAJ	:= ""
Local lModelo	:= .F.
Local lOk		:= .F.

If !Empty(::Avaliacao:RAJ_RECNO)
	dbSelectArea("RAJ")
	RAJ->(dbGoto(::Avaliacao:RAJ_RECNO))
	If !RAJ->(Eof())
		BeginTran()
			cCalend	:= RAJ->RAJ_CALEND
			cCurso	:= RAJ->RAJ_CURSO
			cTurma 	:= RAJ->RAJ_TURMA
			cFilRAJ := RAJ->RAJ_FILIAL
			lModelo	:= If(Empty(RAJ->RAJ_TESTE), .T., .F.)
			
			cTipo := SaveAval(::Avaliacao)
		
			//atualiza curso em relação a eficacia
			If cTipo == "EFI"
	         
				dbSelectArea("RAJ") 
				RAJ->(dbSetOrder(1))
				RAJ->(dbSeek(cFilRAJ+cCalend+cCurso+cTurma))
				While !RAJ->(Eof()) .And. cFilRAJ+cCalend+cCurso+cTurma == RAJ->RAJ_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA
			
				  	If !lModelo
				  		If TrmDesc("SQQ",RAJ->RAJ_TESTE,"QQ_TIPO") != "EFI"
					  		RAJ->(dbSkip())
					  		Loop
					  	EndIf
				  	Else
						If TrmDesc("SQW",RAJ->RAJ_MODELO,"QW_TIPO") != "EFI"
					  		RAJ->(dbSkip())
					  		Loop
					  	EndIf	  	
				  	EndIf
				  	        
					If RAJ->RAJ_OK == "S"
						lOk := .T.
					Else
						lOk := .F.
						Exit			
					EndIf
				
					RAJ->(dbSkip())
				EndDo    
				If lOk 
					dbSelectArea("RA2")
					RA2->(dbSetOrder(1))
					If RA2->(dbSeek(xFilial("RA2")+cCalend+cCurso+cTurma))
						RecLock("RA2",.F.)
							RA2->RA2_EFICAC	:= "A" 	//Avaliado
						RA2->(MsUnlock())
					EndIf
				EndIf
			EndIf
		EndTran()
	Else
		lRet := .F.
		SetSoapFault("PutAvaliacao",STR0014)//"Agenda não encontrada!"
	EndIf
Else
	lRet := .F.
	SetSoapFault("PutAvaliacao",STR0015)//"Código agenda obrigatório."
EndIf

RestArea(aArea)
Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc}  SaveAval
Salva a avaliação na tabela RAI
@author Flavio Correa
@since 13/01/2015
@version 12.0
/*/
//-------------------------------------------------------------------
Static Function SaveAval(oAvaliacao)

Local aSaveArea := GetArea()
Local cChave	:= ""
Local cTipo		:= ""
Local nPontos	:= 0 
Local nEficac	:= 0
Local cFil		:= ""  
Local cCargo	:= ""
Local cCC		:= Space(9)
Local lModelo	:= If(Empty(RAJ->RAJ_TESTE), .T., .F.)
Local cCodAval	:= If(Empty(RAJ->RAJ_TESTE), RAJ->RAJ_MODELO, RAJ->RAJ_TESTE)
Local nI		:= 1
Local nResult	:= 0
// Atualiza a Agenda como Avaliacao Realizada
RecLock("RAJ",.F.)
	RAJ->RAJ_OK	:= "S"
RAJ->(MsUnlock())
 
// Grava status de Avaliacao Eficacia no Calendario
If !lModelo
	dbSelectArea("SQQ")
	SQQ->(dbSetOrder(1))
	SQQ->(dbSeek(xFilial("SQQ")+cCodAval) )
	cTipo := SQQ->QQ_TIPO
Else	
	dbSelectArea("SQW")
	SQW->(dbSetOrder(1))
	SQW->(dbSeek(xFilial("SQW")+cCodAval))
	cTipo := SQW->QW_TIPO
Endif
	
// Apagar todos os dados das Avaliacoes
dbSelectArea("RAI")
RAI->(dbSetOrder(1))
If RAI->(dbSeek(RAJ->RAJ_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA+RAJ->RAJ_MAT+Padr(cCodAval,4)))
	While !RAI->(Eof()) .And. RAJ->RAJ_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA+RAJ->RAJ_MAT+Padr(cCodAval,4) ==;
				 RAI->RAI_FILIAL+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT+RAI->RAI_TESTE
							 
		RecLock("RAI",.F.,.T.)
			RAI->(DbDelete())									 
		RAI->(MsUnlock())
		APDMSMM(RAI_MRESPOS,,,,2)	
		RAI->(dbSkip())				 
	EndDo						 	
EndIf

//posicionar SRA
dbSelectArea("SRA")
SRA->(dbSetOrder(1))
SRA->(dbSeek(RAJ->RAJ_FILIAL+RAJ->RAJ_MAT))

// Atualiza os dados da Avaliacao Realizada.
For nI := 1 To Len(oAvaliacao:Answers)
	dbSelectArea("SQO")
	SQO->(dbSetOrder(1)) //QO_FILIAL+QO_QUESTAO
	If !SQO->(dbSeek(xFilial("SQO")+oAvaliacao:Answers[nI]:QuestionCode))
		lRet := .F.
		exit
	EndIf
	
	nTipoQuest := SQO->QO_TIPOOBJ
	cEscala    := SQO->QO_ESCALA
   
	RecLock("RAI", .T.)
		RAI->RAI_FILIAL:= SRA->RA_FILIAL
		RAI->RAI_MAT   := SRA->RA_MAT
		RAI->RAI_CURSO := RAJ->RAJ_CURSO
		RAI->RAI_CALEND:= RAJ->RAJ_CALEND
		RAI->RAI_TURMA := RAJ->RAJ_TURMA
		RAI->RAI_TESTE := cCodAval
		RAI->RAI_QUESTA:= SQO->QO_QUESTAO	
		If nTipoQuest == "3" //memo
			RAI->RAI_ALTERN := "00"
		Else
			RAI->RAI_ALTERN := oAvaliacao:Answers[nI]:Answer
			If Empty(cEscala)
				
				RAI->RAI_RESULT := Posicione("SQP", 1, xFilial("SQP")+SQO->QO_QUESTAO+oAvaliacao:Answers[nI]:Answer, "SQP->QP_PERCENT")
								
			Else
				RAI->RAI_RESULT := Posicione("RBL", 1, xFilial("RBL", SRA->RA_FILIAL)+cEscala+RAI->RAI_ALTERN, "RBL->RBL_VALOR")
			EndIf
		EndIf
			
		If nTipoQuest == "3" .And. RAJ->RAJ_QUEM == "1"
			RAI->RAI_RESULT	:= 0.00    
		EndIf
		
		RAI->RAI_DURACA:= oAvaliacao:Duration
		RAI->RAI_TIPO  := cTipo
		RAI->RAI_QUEM  := RAJ->RAJ_QUEM	//1=Funcionario;2=Outros
		RAI->RAI_MATAVA:= RAJ->RAJ_MATAVA
	RAI->(MsUnlock())

	If nTipoQuest == "3"
		APDMSMM(NIL, NIL, NIL, oAvaliacao:Answers[nI]:Answer, 1, NIL, NIL, "RAI", "RAI_MRESPO")
	EndIf
	
	// Soma Pontos do Teste
	If cTipo == "EFI" .And. RAI->RAI_RESULT > 0
		nPontos += ((SQO->QO_PONTOS * RAI->RAI_RESULT) / 100)
	EndIf
	
Next nI
         
// Grava Pontuacao de Eficacia no Curso do Funcionario   
If nPontos > 0
    
    cCargo 	:= fGetCargo(SRA->RA_MAT)	
	cCC		:= SRA->RA_CC
		              
	dbSelectArea("SQ3")
	SQ3->(dbSetOrder(1))
	cFil := xFilial("SQ3", SRA->RA_FILIAL)	
	If SQ3->(dbSeek(cFil+cCargo+cCC))
		cChave 	:= cCargo+cCC 
	Else
		cChave	:= cCargo+Space(TamSX3("RA_CC")[1])
	EndIf
		              
	dbSelectArea("RA5")
	RA5->(dbSetOrder(2))  
	cFil 	:= xFilial("RA5", SRA->RA_FILIAL)	
	nEficac	:= 0
	
	If RA5->(dbSeek(cFil+cChave))
		nEficac := RA5->RA5_EFICAC
	EndIf

	cEficac	:= Iif(nPontos >= nEficac, "1", "2")	// Sim/Nao
			
	dbSelectArea("RA4")
	RA4->(dbSetOrder(3))
	If RA4->(dbSeek(SRA->RA_FILIAL+RAJ->RAJ_CALEND+RAJ->RAJ_CURSO+RAJ->RAJ_TURMA+SRA->RA_MAT))
		RecLock("RA4",.F.)
			RA4->RA4_EFICAC	:= nPontos 
			RA4->RA4_EFICSN	:= cEficac
		 RA4->(MsUnlock())
	EndIf   
	     
	dbSelectArea("RA4")
	RA4->(dbSetOrder(1))
EndIf

RestArea(aSaveArea)

Return cTipo