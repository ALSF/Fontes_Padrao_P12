#INCLUDE "WSAPD010.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSAPD015  ³ Autor ³Aline Correa do Vale   ³ Data ³19.02.2004  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pelas avaliacoes de desempenho       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ APD/RH/Portais                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rogerio R.    ³25/06/07³128213³ Visualizar as avaliações de desempenho   ³±±
±±³              ³        ³      ³ dos subordinados de uma equipe, atraves  ³±±
±±³              ³        ³      ³ da visão.                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service							                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHProjectEvaluate DESCRIPTION STR0001		//"Avaliação de Desempenho ( <b>Restrição de participante</b> )"
	WSDATA EvaluatorID			As STRING OPTIONAL 		//Tipo de Avaliacao para Pesquisa
	WSDATA EvaluationID			As STRING OPTIONAL 		//Tipo de Avaliacao para Pesquisa
	WSDATA EvaluatedID			As STRING OPTIONAL 		//Tipo de Avaliacao para Pesquisa
	WSDATA Type 				As STRING OPTIONAL
	WSDATA Status				As STRING OPTIONAL
	WSDATA ListOfEvaluation		AS ARRAY OF TEvaluation
	WSDATA ListOfEvaluated		AS ARRAY OF TParticipant
	WSDATA ListOfEvaluationItem	AS ARRAY OF TEvaluationItem
	                                                                                                 
	WSMETHOD GetEvaluations			DESCRIPTION "<Add a description here>"
	WSMETHOD GetEvaluated			DESCRIPTION "<Add a description here>"
	WSMETHOD GetEvaluationItems 	DESCRIPTION "<Add a description here>"
ENDWSSERVICE


WSMETHOD GetEvaluations WSRECEIVE EvaluatorID, Type, Status WSSEND ListOfEvaluation WSSERVICE RHProjectEvaluate
	Local cEvaluator	:= SubStr(::EvaluatorID, 1, Len(RDA->RDA_CODDOR))
	Local cTipo     	:= If( Empty(::Type), "12", ::Type ) //1=Avaliacao, 2=Pesquisa, 3=Projeto
	Local cStatus		:= If( Empty(::Status), "1", ::Status ) //1=pendencias, 2=ja confirmadas(consulta)
	Local aVisions		:= {}
	
	::ListOfEvaluation	:= {}
		
	If !cStatus $ "12"
		SetSoapFault("GetEvaluates", STR0025) //"Status da Avaliacao invalido"
		Return .F.
	EndIf
	
	If Empty(cEvaluator)
		SetSoapFault("GetEvaluates", STR0024) //"Avaliador invalido"
		Return .F.
	EndIf

	dbSelectArea("RD5")
	dbSetOrder(1)
	dbSelectArea("RD6")
	dbSetOrder(5)
	dbSelectArea("RDE")
	dbSetOrder(1)			//RDE_FILIAL+RDE_CODPAR+RDE_CODVIS+RDE_ITEVIS+DTOS(RDE_DATA)

	RDE->(DBSeek(xFilial("RDE") + cEvaluator))

	While	!RDE->(Eof()) .And.;
			RDE->RDE_FILIAL == xFilial("RDE") .And.;
			RDE->RDE_CODPAR == cEvaluator
		If	(AScan(aVisions, {|cVision| cVision == RDE->RDE_CODVIS }) > 0) .OR.;
			(RDE->RDE_STATUS != "1")		
			RDE->(DBSkip())
			Loop
		EndIf

		AAdd(aVisions, RDE->RDE_CODVIS)
		RD6->(DBSeek(xFilial("RD6") + RDE->RDE_CODVIS))

		While	!RD6->(Eof()) .And.;			
				RD6->RD6_FILIAL == xFilial("RD6") .And.;
				RD6->RD6_CODVIS == RDE->RDE_CODVIS
			RD5->(DBSeek(xFilial("RD5")+ RD6->RD6_CODTIP))

			If	(RD5->RD5_TIPO != cTipo) .OR.;
				(RD6->RD6_STATUS != cStatus)
				RD6->(DBSkip())
				Loop
			EndIf
			
			If !ValidEvtion(RD6->RD6_CODIGO, cEvaluator, RD6->RD6_CODVIS)
				RD6->(DBSkip())
				Loop
			EndIf
			
			oEvaluate:= WSClassNew("TEvaluation")		
			oEvaluate:ID			:= RD6->RD6_CODIGO
			oEvaluate:Description	:= RD6->RD6_DESC

			AAdd(::ListOfEvaluation, oEvaluate)
			RD6->(DBSkip())
		EndDo

		RDE->(DBSkip())
	EndDo
	
	dbSelectArea("RD6")
	dbSetOrder(1)
	dbSelectArea("RDA")
	dbSetOrder(3)
	
	DBSeek(xFilial("RDA")+cEvaluator)

	While	!RDA->(Eof()) .And.;
			RDA->RDA_FILIAL == xFilial("RDA") .And.;
			RDA->RDA_CODDOR == cEvaluator
		If (AScan(::ListOfEvaluation, {|oEval| oEval:ID == RDA->RDA_CODAVA }) > 0)
			RDA->(DBSkip())
			Loop
		EndIf
	
		RD6->(DBSeek(xFilial("RD6")+RDA->RDA_CODAVA))
		RD5->(DBSeek(xFilial("RD5")+RD6->RD6_CODTIP))

		If	(RD5->RD5_TIPO != cTipo) .OR.;
			(RD6->RD6_CODIGO != RDA->RDA_CODAVA) .OR.;
			(RD6->RD6_STATUS != cStatus)
			RDA->(DBSkip())
			Loop
		EndIf
			
		oEvaluate:= WSClassNew("TEvaluation")		
		oEvaluate:ID			:= RD6->RD6_CODIGO
		oEvaluate:Description	:= RD6->RD6_DESC

		AAdd(::ListOfEvaluation, oEvaluate)
		RDA->(DBSkip())
	EndDo	
RETURN .T.


Static Function ValidEvtion(EvaluationID, EvaluatorID, cVisionID)
	dbSelectArea("RD9")
	dbSetOrder(1)

	RD9->(DBSeek(xFilial("RD9") + EvaluationID))

	While	!RD9->(Eof()) .And.;
			RD9->RD9_FILIAL == xFilial("RD9") .And.;
			RD9->RD9_CODAVA == EvaluationID
		If ValidEvaluated(EvaluationID, EvaluatorID, RD9->RD9_CODADO, cVisionID, GetItemVision(EvaluatorID, cVisionID))
			Return .T.
		EndIf   
		
		RD9->(DBSkip())		
	EndDo    
Return .F.


WSMETHOD GetEvaluated WSRECEIVE EvaluationID, EvaluatorID WSSEND ListOfEvaluated WSSERVICE RHProjectEvaluate
	Local oEvaluate	
	Local cVisionID
	Local cItemVision
	
	cVisionID		:= GetVision(EvaluationID)
	If cVisionID == Nil; Return .F.; EndIf
		
	cItemVision	:= GetItemVision(EvaluatorID, cVisionID)
	//If cItemVision == Nil; Return .F.; EndIf

	::ListOfEvaluated:= {}

	dbSelectArea("RD9")
	dbSetOrder(1)	

	RD9->(DBSeek(xFilial("RD9") + EvaluationID))

	While	!RD9->(Eof()) .And.;
			RD9->RD9_FILIAL == xFilial("RD9") .And.;
			RD9->RD9_CODAVA == EvaluationID
		If (AScan(::ListOfEvaluated, { |oTemp| oTemp:ID == RD9->RD9_CODADO} ) > 0)
			RD9->(DBSkip())
			Loop
		EndIf 
	
		If	!ValidEvaluated(EvaluationID, EvaluatorID, RD9->RD9_CODADO, cVisionID, cItemVision)
			RD9->(DBSkip())
			Loop
		EndIf 

		oEvaluate:= WSClassNew("TParticipant")
		       
		oEvaluate:ID	:= RD9->RD9_CODADO
		oEvaluate:Name	:= FDesc("RD0", RD9->RD9_CODADO, "RD0_NOME")	

		AAdd(::ListOfEvaluated, oEvaluate)				
		RD9->(DBSkip())
	EndDo
RETURN .T.

Static Function ValidEvaluated(EvaluationID, EvaluatorID, EvaluatedID, VisionID, VisionItem)
	If IsEvaluated(EvaluationID, EvaluatorID, EvaluatedID)
		Return .T.
	EndIf

	If IsSubordinate(EvaluatedID, VisionID, VisionItem)
		Return .T.
	EndIf
Return .F.

Static Function IsEvaluated(EvaluationID, EvaluatorID, EvaluatedID)
	Local aSaveArea
	Local lReturn	:= .F.
	
	dbSelectArea("RDA")
	aSaveArea	:= RDA->(GetArea())	
	
	dbSetOrder(6)

	If RDA->(DBSeek( xFilial("RDA") + EvaluationID + EvaluatorID + EvaluatedID))
		lReturn:= .T.
	EndIf
	
	RDA->(RestArea(aSaveArea))
Return lReturn

Static Function IsSubordinate(EvaluatedID, VisionID, VisionItem)
	Local cSubItemVis
	Local aSaveArea
	Local lReturn	:= .F.

	dbSelectArea("RD4")
	aSaveArea	:= RD4->(GetArea())	
	
	dbSetOrder(1)	//RD4_FILIAL+RD4_CODIGO+RD4_ITEM+RD4_TREE+DTOS(RD4_DATA)
	
	cSubItemVis:= GetItemVision(EvaluatedID, VisionID)

	If cSubItemVis != NIL	      
		While RD4->(DBSeek(xFilial("RD4") + VisionID + cSubItemVis))
			If RD4->RD4_TREE == VisionItem
				lReturn:= .T.
				Exit
			EndIf
			
			cSubItemVis:= RD4->RD4_TREE
		EndDo
	EndIf		
	
	RD4->(RestArea(aSaveArea))		
Return lReturn

Static Function GetItemVision(PartipantID, VisionID)
	Local aSaveArea
	Local cReturn
	
	dbSelectArea("RDE")	
	aSaveArea	:= RDE->(GetArea())

	dbSetOrder(5)			//RDE_FILIAL+RDE_CODPAR+RDE_CODVIS+RDE_STATUS
	
	If RDE->(DBSeek(xFilial("RDE") + PartipantID + VisionID + "1"))
		cReturn	:= RDE->RDE_ITEVIS
	EndIf
	
	RDE->(RestArea(aSaveArea))
Return cReturn

Static Function GetVision(EvaluationID)
	Local aSaveArea
	Local cReturn

	dbSelectArea("RD6")
	aSaveArea	:= RD6->(GetArea())
	
	dbSetOrder(1)
	
	If RD6->(DBSeek(xFilial("RD6") + EvaluationID))
		cReturn	:= RD6->RD6_CODVIS
	EndIf
	
	RD6->(RestArea(aSaveArea))
Return cReturn

WSMETHOD GetEvaluationItems WSRECEIVE EvaluationID, EvaluatorID, EvaluatedID WSSEND ListOfEvaluationItem WSSERVICE RHProjectEvaluate
	Local oItem
	Local oEvaluated
	Local aEvaluationItem:= {}
	
	dbSelectArea("RD0")
	dbSelectArea("RD5")	
	dbSelectArea("RD6")
	dbSelectArea("RDC")
	dbSelectArea("RDA")

	RD5->(dbSetOrder(1))
	RD6->(dbSetOrder(1))
	RDA->(dbSetOrder(1))
	RDC->(dbSetOrder(1))
	                
	oEvaluated		:= WSClassNew("TParticipant")
	oEvaluated:ID	:= EvaluatedID
	oEvaluated:Name	:= AllTrim(FDesc("RD0", EvaluatedID, "RD0_NOME",,,1))
	
	RDA->(DBSeek(xFilial("RDA") + EvaluationID + EvaluatedID))

	While	!RDA->(Eof()) .And.;
			RDA->RDA_FILIAL == xFilial("RDA") .And.;
			RDA->RDA_CODAVA == EvaluationID .And.;
			RDA->RDA_CODADO == EvaluatedID
		If RDA->RDA_TIPOAV == "2"
			RDA->(DBSkip())
			Loop
		EndIf
			
		RDC->(DBSeek(xFilial("RDC") + EvaluationID + EvaluatedID + RDA->RDA_CODPRO + RDA->RDA_CODDOR + DTOS(RDA->RDA_DTIAVA) + RDA->RDA_CODNET + RDA->RDA_NIVEL + RDA->RDA_TIPOAV))
		RD6->(DBSeek(xFilial("RD6") + EvaluationID))
		RD5->(DBSeek(xFilial("RD5") + RD6->RD6_CODTIP))
		
		oItem:= WSClassNew("TEvaluationItem")
		
		if ExistBlock("MSGETPROJECT")
			oItem:Project:= ExecBlock("MSGETPROJECT", .F., .F., {RDA->RDA_CODPRO})
		Else
			oItem:Project				:= WSClassNew("TProject")
			oItem:Project:ID			:= RDA->RDA_CODPRO
			oItem:Project:Description	:= AllTrim(FDesc("RDN", RDA->RDA_CODPRO, "RDN_DESC",,,1))
			
			oItem:Project:Client				:= WSClassNew("TClient")
			oItem:Project:Client:ID				:= RDN->RDN_CODCLI
			oItem:Project:Client:Description	:= AllTrim(FDesc("SA1", RDN->RDN_CODCLI, "A1_NOME",,,1))
			oItem:Project:Client:UnitID			:= SA1->A1_LOJA
		EndIf
		

		oItem:Period				:= WSClassNew("TCalendar")
		oItem:Period:InitialDate	:= RDA->RDA_DTIAVA
		oItem:Period:FinalDate		:= RDA->RDA_DTFAVA
	
		oItem:Evaluation				:= WSClassNew("TEvaluation")
		oItem:Evaluation:ID				:= RD6->RD6_CODIGO
		oItem:Evaluation:Description	:= AllTrim(RD6->RD6_DESC)
		
		oItem:Evaluation:EvaluationType				:= WSClassNew("TEvaluationType")
		oItem:Evaluation:EvaluationType:ID			:= RD5->RD5_CODTIP
		oItem:Evaluation:EvaluationType:Description	:= AllTrim(RD5->RD5_DESC)
		oItem:Evaluation:EvaluationType:Type		:= RD5->RD5_TIPO

		oItem:Evaluator			:= WSClassNew("TParticipant")
		oItem:Evaluator:ID		:= RDA->RDA_CODDOR
		oItem:Evaluator:Name	:= FDesc("RD0", RDA->RDA_CODDOR, "RD0_NOME")

		oItem:Evaluated			:= oEvaluated

		oItem:Status			:= IIF(RDC->(Found()) .AND. !Empty(RDC->RDC_DATRET), "FINALIZADA", "EM ABERTO")
		oItem:EvaluatorType		:= RDA->RDA_TIPOAV
	
		AAdd(aEvaluationItem, oItem)				
		RDA->(DBSkip())
	EndDo
	
	::ListOfEvaluationItem:= aEvaluationItem
RETURN .T.

WSSTRUCT TEvaluation
	WSDATA ID 					AS STRING
	WSDATA Description			AS STRING	
	WSDATA EvaluationType		AS TEvaluationType OPTIONAL
	
ENDWSSTRUCT

WSSTRUCT TParticipant
	WSDATA ID					AS STRING
	WSDATA Name					AS STRING
ENDWSSTRUCT

WSSTRUCT TCalendar
	WSDATA InitialDate			AS DATE
	WSDATA FinalDate			AS DATE
ENDWSSTRUCT

WSSTRUCT TEvaluationItem
	WSDATA Evaluation			AS TEvaluation OPTIONAL
	WSDATA Evaluator			AS TParticipant OPTIONAL
	WSDATA Evaluated			AS TParticipant	OPTIONAL
	WSDATA Project				AS TProject
	WSDATA Period 				AS TCalendar
	WSDATA Status				AS STRING
	WSDATA EvaluatorType		AS STRING
ENDWSSTRUCT

WSSTRUCT TProject
	WSDATA ID 					AS STRING
	WSDATA Description			AS STRING	
	WSDATA Client				AS TClient
ENDWSSTRUCT
                
WSSTRUCT TClient
	WSDATA ID 					AS STRING
	WSDATA UnitID				AS STRING
	WSDATA Description			AS STRING	
ENDWSSTRUCT

WSSTRUCT TEvaluationType
	WSDATA ID 					AS STRING
	WSDATA Description			AS STRING
	WSDATA Type					AS STRING
ENDWSSTRUCT

Function WSAPD015
RETURN
