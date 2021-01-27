#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WSTRM040 ³ Autor ³Rogerio Ribeiro da Cruz³ Data ³ 13/04/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Avaliações dos Treinamentos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ WSTRM040()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	DATA	 ³ Programador  ³Chamado³Manutencao Efetuada		      	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³04/10/2013³Emerson Campos³THWREC ³Ao dar o DbSeek na tabela RA1 o campo³±±
±±³          ³        		³		³filial não era informado, e isso     ³±±
±±³          ³        		³		³gerava o erro pois não localizava o  ³±±
±±³          ³        		³		³treinamento solicitado.              ³±±
±±³05/12/2013³Allyson M     ³TICIJO ³Ajuste na logica do ajuste anterior  ³±±
±±³          ³        		³		³p/ informar a filial (branch) se nao ³±±
±±³          ³        		³		³for informada.						  ³±±
±±³16/01/2013³Gustavo M     ³TIFQU8 ³Ajuste na logica do ajuste anterior  ³±±
±±³          ³        		³		³p/ informar a filial (branch) se nao ³±±
±±³          ³        		³		³for informada.	PostTraining		  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//-------------------------------------------------------------------
Function WSTRM040()
Return

WSSTRUCT TEvaluationTraining
	WSDATA Company	     	AS String
	WSDATA Branch			AS String
	WSDATA Registration		AS String
	WSDATA Code				AS String
	WSDATA Duration			AS String
	WSDATA Type				AS String
	WSDATA Note        	    As Float  OPTIONAL
ENDWSSTRUCT

WSSTRUCT TEvaluationAnswers
	WSDATA QuestionCode		AS String
	WSDATA Answer			AS String
ENDWSSTRUCT 


WSSTRUCT TEvaluationAnswersList
	WSDATA Answers AS Array Of TEvaluationAnswers
ENDWSSTRUCT 


//-------------------------------------------------------------------
/*/{Protheus.doc}  RHTrainingReservations

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
WSSERVICE RHTrainingEvaluation DESCRIPTION "Avaliações dos Treinamentos"
	WSDATA Training 		AS TEPMTraining
	WSDATA Evaluation 		AS TEvaluationTraining
	WSDATA EvaluationResult AS Float
	WSDATA AnswersList 		AS TEvaluationAnswersList
	WSDATA WsNull			AS String
	
	WSMETHOD SetAnswers	  DESCRIPTION "Grava as respostas"      
	WSMETHOD PostTraining DESCRIPTION "Baixa treinamento"      
ENDWSSERVICE                                  


//-------------------------------------------------------------------
/*/{Protheus.doc}  SetReservation

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
WSMETHOD SetAnswers;
		WSRECEIVE Training, Evaluation, AnswersList;
		WSSEND EvaluationResult;
		WSSERVICE RHTrainingEvaluation
	Self:EvaluationResult := Grava(Self:Training, Self:Evaluation, Self:AnswersList:Answers)
Return .T.


//-------------------------------------------------------------------
/*/{Protheus.doc}  Grava

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
Static Function Grava(oTraining, oEvaluation, aAnswersList)
	Local nCount
	Local nTipoQuest
	Local nResult	 := 0
	Local nTamAltern := TamSx3("RAI_ALTERN")[1]
	Local cTipo	     := ""
	Local cEscala    := ""
		
	If Empty(oTraining:Branch)
		oTraining:Branch	:= Space( TamSx3( "RA1_FILIAL")[1] )	
	EndIf 
	
	dbSelectArea("RA1")
	RA1->(dbSetOrder(1)) //RA1_FILIAL+RA1_CURSO
	If RA1->(!dbSeek(oTraining:Branch+oTraining:CourseCode))
		SetSoapFault("SetAnswers", "Treinamento nao encontrado!")
		Return .F.
	EndIf
                                                             
	dbSelectArea("SRA")
	dbSetOrder(1) //RA_FILIAL+RA_MAT
	If !dbSeek(oEvaluation:Registration)
		SetSoapFault("SetAnswers", "Usuario nao encontrado!")
		Return .F.
	EndIf

	dbSelectArea("SQQ")
	dbSetOrder(1) //QQ_FILIAL+QQ_TESTE+QQ_ITEM+QQ_QUESTAO
	If !dbSeek(oEvaluation:Code)
		SetSoapFault("SetAnswers", "Avaliacao nao encontrada!")
		Return .F.
	EndIf

	
	For nCount:= 1 To Len(aAnswersList)
		dbSelectArea("SQO")
		dbSetOrder(1) //QO_FILIAL+QO_QUESTAO
		If !dbSeek(aAnswersList[nCount]:QuestionCode)
			SetSoapFault("SetAnswers", "Questao nao encontrada: "+aAnswersList[nCount]:QuestionCode)
			Return .F.
		EndIf
	
		nTipoQuest := SQO->QO_TIPOOBJ
		cEscala    := SQO->QO_ESCALA
		cTipo      := SQO->QO_TIPO
        

		RecLock("RAI", .T.)
		RAI->RAI_FILIAL:= SRA->RA_FILIAL
		RAI->RAI_MAT   := SRA->RA_MAT
		RAI->RAI_CURSO := RA1->RA1_CURSO
		RAI->RAI_CALEND:= Space(GetSx3Cache("RAI_CALEND", "X3_TAMANHO"))
		RAI->RAI_TURMA := Space(GetSx3Cache("RAI_TURMA", "X3_TAMANHO"))
		RAI->RAI_TESTE := SQQ->QQ_TESTE
		RAI->RAI_QUESTA:= SQO->QO_QUESTAO	

		If nTipoQuest == "3"
			RAI->RAI_RESULT := 0.00    
		Else
			RAI->RAI_ALTERN := substr(aAnswersList[nCount]:Answer, Len(aAnswersList[nCount]:QuestionCode)+1, nTamAltern) 
			
			If Empty(cEscala)
				RAI->RAI_RESULT := Posicione("SQP", 1, aAnswersList[nCount]:Answer, "SQP->QP_PERCENT")
			Else
				RAI->RAI_RESULT := Posicione("RBL", 1, xFilial("RBL", oEvaluation:Branch)+cEscala+RAI->RAI_ALTERN, "RBL->RBL_VALOR")
			EndIf

			nResult += RAI->RAI_RESULT
		EndIf

		RAI->RAI_DURACA:= oEvaluation:Duration
		RAI->RAI_TIPO  := cTipo
		RAI->RAI_QUEM  := "1"	//1=Funcionario;2=Outros
		RAI->RAI_MATAVA:= ""
		RAI->(MsUnlock())

		If nTipoQuest == "3"
			APDMSMM(NIL, NIL, NIL, aAnswersList[nCount]:Answer, 1, NIL, NIL, "RAI", "RAI_MRESPO")
		EndIf
	Next    
	
	nResult := (nResult/Len(aAnswersList))                 

Return nResult

//-------------------------------------------------------------------
/*/{Protheus.doc}  PostTraining

@author Tatiane Vieira Matias
@since 16/11/2010
@version 11.0
/*/
//-------------------------------------------------------------------
WSMETHOD PostTraining WSRECEIVE Training, Evaluation WSSEND WsNull WSSERVICE RHTrainingEvaluation

	Local cCalend := Space(GetSx3Cache("RA4_CALEND", "X3_TAMANHO"))
	Local cTurma  := Space(GetSx3Cache("RA4_TURMA", "X3_TAMANHO"))
    
	If Empty(Self:Training:Branch)
		Self:Training:Branch	:= Space( TamSx3( "RA1_FILIAL")[1] )	
	EndIf 

	dbSelectArea("RA1")
	dbSetOrder(1) //RA1_FILIAL+RA1_CURSO
	If !dbSeek(Self:Training:Branch+Self:Training:CourseCode)
		SetSoapFault("PostTraining", "Treinamento nao encontrado!")
		Return .F.
	EndIf

	dbSelectArea("SRA")
	dbSetOrder(1) //RA_FILIAL+RA_MAT
	If !dbSeek(Self:Evaluation:Registration)
		SetSoapFault("PostTraining", "Usuario nao encontrado!")
		Return .F.
	EndIf

	dbSelectArea("RA2")
	dbSetOrder(1) //RA2_FILIAL+RA2_CALEND+RA2_CURSO+RA2_TURMA
	If !dbSeek(xFilial("RA2")+cCalend+RA1->RA1_CURSO+cTurma)
		SetSoapFault("PostTraining", "Calendario nao encontrado!")
		Return .F.
	EndIf

	dbSelectArea("RA4")
	dbSetOrder(3) //RA4_FILIAL+RA4_CALEND+RA4_CURSO+RA4_TURMA+RA4_MAT

	If RA4->( dbSeek(xFilial("RA4")+cCalend+RA1->RA1_CURSO+cTurma+SRA->RA_MAT) )
		RecLock("RA4",.F.,.F.)
			Replace RA4_NOTA   WITH Self:Evaluation:Note
			Replace RA4_PRESEN WITH 100
		MsUnlock()	
	Else
		RecLock("RA4",.T.,.T.)
			Replace RA4->RA4_FILIAL	 WITH xFilial("RA4")
			Replace RA4->RA4_MAT     WITH SRA->RA_MAT
			Replace RA4->RA4_CURSO	 WITH RA1->RA1_CURSO        
			Replace RA4->RA4_SINONI  WITH RA2->RA2_SINON
			Replace RA4->RA4_ENTIDA  WITH RA2->RA2_ENTIDA
			Replace RA4->RA4_NOTA    WITH Self:Evaluation:Note
			Replace RA4->RA4_DURACA  WITH RA2->RA2_DURACA
			Replace RA4->RA4_UNDURA  WITH RA2->RA2_UNDURA
			Replace RA4->RA4_PRESEN  WITH 100
			Replace RA4->RA4_DATAIN  WITH RA2->RA2_DATAIN
			If empty(RA2->RA2_DATAFI)
				Replace RA4->RA4_DATAFI  WITH dDataBase
			Else	
				Replace RA4->RA4_DATAFI  WITH RA2->RA2_DATAFI
			EndIf	
			Replace RA4->RA4_VALOR   WITH Trm070ValIni()
			Replace RA4->RA4_HORAS   WITH RA2->RA2_HORAS
			Replace RA4->RA4_CALEND  WITH RA2->RA2_CALEND
			Replace RA4->RA4_TURMA   WITH RA2->RA2_TURMA
			Replace RA4->RA4_EFICSN	 WITH "2"
			Replace RA4->RA4_VALIDA  WITH &(GetSx3Cache("RA4_VALIDA", "X3_RELACAO"))
			Replace RA4->RA4_TIPO	 WITH &(GetSx3Cache("RA4_TIPO", "X3_RELACAO"))
			Replace RA4->RA4_NIVEL	 WITH &(GetSx3Cache("RA4_NIVEL", "X3_RELACAO"))
			Replace RA4->RA4_STATUS	 WITH &(GetSx3Cache("RA4_STATUS", "X3_RELACAO"))
			Replace RA4->RA4_DTALT	 WITH &(GetSx3Cache("RA4_DTALT", "X3_RELACAO"))
			Replace RA4->RA4_CODCOM	 WITH &(GetSx3Cache("RA4_CODCOM", "X3_RELACAO"))
			Replace RA4->RA4_CONTEU	 WITH &(GetSx3Cache("RA4_CONTEU", "X3_RELACAO"))
		MsUnlock()	
	EndIf

	// Deletar do RA3 o Funcionario Baixado
	// Solicitacao de treinamento
	dbSelectArea("RA3")
	dbSetOrder(1)  
	If RA3->( dbSeek(xFilial("RA3", SRA->RA_FILIAL) + SRA->RA_MAT + RA1->RA1_CURSO) )
		RecLock("RA3",.F.)
		dbDelete()					 
		MsUnlock()					 
	EndIf

	// Inicializa Treinamento(RA2) como realizado, apenas quando nao for e-learning
	dbSelectArea("RA1")
	dbSetOrder(1)  
	If RA1->( dbSeek(xFilial("RA1", Self:Evaluation:Branch) + Self:Training:CourseCode) )
	    If RA1->RA1_TIPO != "L"

			dbSelectArea("RA2")
			dbSetOrder(1)
		
			While RA2->( !Eof() .And.;
			             xFilial("RA2")+cCalend+Self:Training:CourseCode+cTurma == RA2->RA2_FILIAL+RA2->RA2_CALEND+RA2->RA2_CURSO+RA2->RA2_TURMA )
				RecLock("RA2",.F.,.F.)
					Replace RA2->RA2_REALIZADO WITH "S"		// Altera o Status para Realizado
				MsUnlock()
				dbSkip()
			EndDo	

        EndIf
    EndIf    

Return .T.