#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSAPD017.CH"

WSSTRUCT TEvaluateList
	WSDATA Cod					As String
	WSDATA Desc					As String
ENDWSSTRUCT

WSSTRUCT TEvaluateAllList
	WSDATA Nome					As String
	WSDATA Tipo					As String
	WSDATA Nivel				As String
	WSDATA Link					As String
	WSDATA Date 				As String
	WSDATA Project 				As String
	WSDATA CodType 				As String
	WSDATA CodAdo				As String
	WSDATA CodDor				As String
	WSDATA CodAva				As String
ENDWSSTRUCT

WSSTRUCT TEvaluateView
	WSDATA Itens				AS Array Of TEvaluateList	OPTIONAL
ENDWSSTRUCT

WSSTRUCT TEvaluatorView
	WSDATA Itens				AS Array Of TEvaluateList	OPTIONAL
ENDWSSTRUCT

WSSTRUCT TEvaluateAll
	WSDATA Itens				AS Array Of TEvaluateAllList	OPTIONAL
ENDWSSTRUCT

WSSERVICE RHEvaluate DESCRIPTION STR0001 //"Consulta Avaliações Finalizadas"
	WSDATA WsNull               AS String
	WSDATA Branch				AS String
	WSDATA Participant			AS String
	WSDATA Evaluator			AS String
	WSDATA Evaluation			AS String
	WSDATA EvaluateView   		As TEvaluateView
	WSDATA EvaluatorView   		As TEvaluatorView
	WSDATA EvaluateAll   		As TEvaluateAll
	
	WSMETHOD ViewEvaluate		DESCRIPTION STR0002 //"Método de consulta das avaliações"
	WSMETHOD ViewEvaluator		DESCRIPTION STR0003 //"Método de consulta dos avaliados"
	WSMETHOD AllEvaluate		DESCRIPTION STR0004 //"Método de consulta das avaliações"
ENDWSSERVICE 

WSMETHOD ViewEvaluate;
WSRECEIVE Branch, Participant,Evaluator;
WSSEND EvaluateView;
WSSERVICE RHEvaluate

Local aArea 	:= GetArea()
Local cAliasAux	:= GetNextAlias()
Local cFiltro	:= ""
Local cJoinRD6		:= "%" + FWJoinFilial("RDC", "RD6") + "%"
Local cJoinRDH		:= "%" + FWJoinFilial("RDC", "RDH") + "%"

cFiltro := " RDC.RDC_FILIAL = '" + xFilial("RDC",Self:Branch) + "' AND "

If Self:Evaluator == "S"
	cFiltro	+= " RDC.RDC_CODDOR = '" + Self:Participant + "' AND RDC.RDC_CODADO <> '" + Self:Participant + "' AND "
Else
	cFiltro	+= " RDC.RDC_CODADO = '" + Self:Participant + "' AND "
EndIf
cFiltro	+= " RDC.RDC_DATRET <> '' AND RDH.RDH_LIBRES <> '2' "
cFiltro := "% " + cFiltro + " %"

Self:EvaluateView:= WSClassNew("TEvaluateView")
::EvaluateView:Itens := {}

BEGINSQL alias cAliasAux
	SELECT DISTINCT(RDC_CODAVA), RD6_DESC, RDC_DATRET
	FROM %table:RDC% RDC
	INNER JOIN %table:RD6% RD6
	ON RD6.%NotDel% AND %exp:cJoinRD6% AND RDC.RDC_CODAVA = RD6.RD6_CODIGO
	INNER JOIN %table:RDH% RDH
	ON RDH.%NotDel% AND %exp:cJoinRDH% AND RDH.RDH_CODTIP = RDC.RDC_CODTIP AND RDH.RDH_CODNET = RDC.RDC_CODNET 
	WHERE %exp:cFiltro% 
	AND RDC.%notDel% 
	ORDER BY RDC_DATRET DESC
ENDSQL

If (cAliasAux)->( !Eof())
	While (cAliasAux)->( !Eof())
		oItem:= WSClassNew("TEvaluateList")
		oItem:Cod := (cAliasAux)->RDC_CODAVA
		oItem:Desc := (cAliasAux)->RD6_DESC
		aAdd(::EvaluateView:Itens, oItem)
		(cAliasAux)->( DbSkip())
	EndDo
Else
	oItem:= WSClassNew("TEvaluateList")
	oItem:Cod := ""
	oItem:Desc := STR0005 //"Nenhuma Avaliação Encontrada"	
	aAdd(::EvaluateView:Itens, oItem)	
EndIf

(cAliasAux)->(DbCloseArea())

RestArea(aArea)

Return .T. 

WSMETHOD ViewEvaluator;
WSRECEIVE Branch, Participant,Evaluation;
WSSEND EvaluatorView;
WSSERVICE RHEvaluate
	
Local aArea 	:= GetArea()
Local cAliasAux	:= GetNextAlias()
Local cFiltro	:= ""
Local cJoinRD0		:= "%" + FWJoinFilial("RDC", "RD0") + "%"
Local cJoinRDH		:= "%" + FWJoinFilial("RDC", "RDH") + "%"

cFiltro := " RDC.RDC_FILIAL = '" + xFilial("RDC",Self:Branch) + "' AND "
cFiltro	+= " RDC.RDC_CODDOR = '" + Self:Participant + "' AND RDC.RDC_CODADO <> '" + Self:Participant + "' AND "
cFiltro	+= " RDC.RDC_CODAVA = '" + Self:Evaluation + "' AND "
cFiltro	+= " RDC.RDC_DATRET <> ''  AND RDH.RDH_LIBRES <> '2' "
cFiltro := "% " + cFiltro + " %"

Self:EvaluatorView:= WSClassNew("TEvaluateView")
::EvaluatorView:Itens := {}

BEGINSQL alias cAliasAux
	SELECT RDC_CODADO, RD0_NOME
	FROM %table:RDC% RDC
	INNER JOIN %table:RD0% RD0
	ON RD0.%NotDel% AND %exp:cJoinRD0% AND RDC.RDC_CODADO = RD0.RD0_CODIGO
	INNER JOIN %table:RDH% RDH
	ON RDH.%NotDel% AND %exp:cJoinRDH% AND RDH.RDH_CODTIP = RDC.RDC_CODTIP AND RDH.RDH_CODNET = RDC.RDC_CODNET
	WHERE %exp:cFiltro% 
	AND RDC.%notDel%
	GROUP BY RDC_CODADO, RD0_NOME 
ENDSQL

If (cAliasAux)->( !Eof())
	While (cAliasAux)->( !Eof())
		oItem:= WSClassNew("TEvaluateList")
		oItem:Cod := (cAliasAux)->RDC_CODADO
		oItem:Desc := (cAliasAux)->RD0_NOME
		aAdd(::EvaluatorView:Itens, oItem)
		(cAliasAux)->( DbSkip())
	EndDo
Else
	oItem:= WSClassNew("TEvaluateList")
	oItem:Cod := ""
	oItem:Desc := STR0006 //"Nenhum Avaliado Encontrado"	
	aAdd(::EvaluatorView:Itens, oItem)	
EndIf

(cAliasAux)->(DbCloseArea())

RestArea(aArea)

Return .T. 

WSMETHOD AllEvaluate;
WSRECEIVE Branch, Participant,Evaluator,Evaluation;
WSSEND EvaluateAll;
WSSERVICE RHEvaluate

Local aArea 	:= GetArea()
Local cAliasAux	:= GetNextAlias()
Local cFiltro	:= ""
Local cJoinRDH		:= "%" + FWJoinFilial("RDC", "RDH") + "%"
Local cJoinRD0		:= ""

cFiltro := " RDC.RDC_FILIAL = '" + xFilial("RDC",Self:Branch) + "' AND "

If Empty(Self:Evaluator)
	cFiltro	+= " RDC.RDC_CODADO = '" + Self:Participant + "' AND "
	cJoinRD0		:= "%" + FWJoinFilial("RDC", "RD0") + " AND RDC.RDC_CODDOR = RD0.RD0_CODIGO %"	
Else
	cFiltro	+= " RDC.RDC_CODDOR = '" + Self:Participant + "' AND "
	cFiltro	+= " RDC.RDC_CODADO = '" + Self:Evaluator + "' AND "
	cJoinRD0		:= "%" + FWJoinFilial("RDC", "RD0") + " AND RDC.RDC_CODADO = RD0.RD0_CODIGO %"
EndIf
cFiltro	+= " RDC.RDC_CODAVA = '" + Self:Evaluation + "' AND "
cFiltro	+= " RDC.RDC_DATRET <> ''  AND RDH.RDH_LIBRES <> '2' "
cFiltro := "% " + cFiltro + " %"

Self:EvaluateAll:= WSClassNew("TEvaluateAll")
::EvaluateAll:Itens := {}

BEGINSQL alias cAliasAux
	COLUMN RDC_DTIAVA AS DATE
	SELECT RDC_CODAVA, RDC_TIPOAV, RDC_CODPRO, RDC_DTIAVA, RDC_CODADO,RDC_CODDOR, RD0_NOME, RDH_NIVEL, RDH_AUTOAV, RDH_LIBDOR
	FROM %table:RDC% RDC
	INNER JOIN %table:RD0% RD0
	ON RD0.%NotDel% AND %exp:cJoinRD0% 
	INNER JOIN %table:RDH% RDH
	ON RDH.%NotDel% AND %exp:cJoinRDH% AND RDH.RDH_CODTIP = RDC.RDC_CODTIP AND RDH.RDH_CODNET = RDC.RDC_CODNET
	WHERE %exp:cFiltro% 
	AND RDC.%notDel% 
ENDSQL

If (cAliasAux)->( !Eof())
	While (cAliasAux)->( !Eof())
		oItem:= WSClassNew("TEvaluateAllList")
		If (cAliasAux)->RDH_LIBDOR == "2" .AND. (cAliasAux)->RDC_CODDOR <> Self:Participant
			oItem:Nome := ""
		Else
			oItem:Nome := (cAliasAux)->RD0_NOME
		EndIf
		If (cAliasAux)->RDH_AUTOAV == "1"
			oItem:Tipo := STR0008 //"Auto-Avaliação"
			oItem:Nivel := ""
		ElseIf (cAliasAux)->RDH_NIVEL == "2"
			If (cAliasAux)->RDC_TIPOAV == "1"
				oItem:Tipo := STR0009 //"Avaliação"
			ElseIf (cAliasAux)->RDC_TIPOAV == "3"
				oItem:Tipo := STR0010 //"Consenso"
			EndIf
			oItem:Nivel := STR0011 //"Superior"
		ElseIf (cAliasAux)->RDH_NIVEL == "3"
			oItem:Tipo := STR0012 //"Avaliador"
			oItem:Nivel := "Inferior"
		ElseIf (cAliasAux)->RDH_NIVEL == "1"
			oItem:Tipo := STR0012 //"Avaliador"
			oItem:Nivel := STR0013 //"Par"
		EndIf
		oItem:Date 		:= DtoC((cAliasAux)->RDC_DTIAVA)
		oItem:Project 	:=  AllTrim((cAliasAux)->RDC_CODPRO)
		oItem:CodType 	:= (cAliasAux)->RDC_TIPOAV
		oItem:CodAdo	:= (cAliasAux)->RDC_CODADO
		oItem:CodDor	:= (cAliasAux)->RDC_CODDOR
		oItem:CodAva	:= (cAliasAux)->RDC_CODAVA
		If (cAliasAux)->RDC_CODADO == (cAliasAux)->RDC_CODDOR //AUTO-AVALIAÇÃO
			oItem:Link := "W_PIMP011.APW""
		Else
			oItem:Link := "W_PIMP012.APW?cEvaluatedID="+AllTrim((cAliasAux)->RDC_CODADO)+"&cPEvaluatedID=" + AllTrim(Self:Evaluation) + "&cTipoAv="+ (cAliasAux)->RDC_TIPOAV
		EndIf
		
		aAdd(::EvaluateAll:Itens, oItem)
		(cAliasAux)->( DbSkip())
	EndDo
EndIf

(cAliasAux)->(DbCloseArea())

RestArea(aArea)

Return .T.