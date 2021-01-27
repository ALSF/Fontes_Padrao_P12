#include "MTECMLIB.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE "totvs.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWEVENTVIEWCONSTS.CH"

Static aModulo := Array(2)
/*-------------------------------------------------------------------
EXPERIÊNCIAS COM O FLUIG|ECM
--------------------------------------------------------------------*/

//-------------------------------------------------------------------
/*/{Protheus.doc} PutCard
Esta função coloca/atualiza um ficheiro no ECM

@author guilherme.pimentel
@param cView View que será colocada no formulário
@param cProcess Descrição do processo, se informado atualiza o formulário relacionado ao processo senão cria um novo
@param cDesc Descrição do ficheiro

@since 24/01/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function PutCard(cView,cProcess,cDesc,lMostraHelp,nNovoModulo) 

Local oView := nil
Local cProcessId := cProcess // se informado atualiza o formulário relacionado ao processo senão cria um novo
Local cDescription := cDesc
Local cCardDescription := ""
Local aEvents := Array(1,2) // eventos que serão customizados para o formulario
Local nFormId := 0
Local aFiles
Local nModuloAnt := 0

Default lMostraHelp := .T.
Default nNovoModulo := nModulo

nModuloAnt := nModulo
nModulo := Val(nNovoModulo)

oView := FWLoadView(cView)

If oView == NIL
	MsgStop(STR0006) //"Ocorreu um erro na criação do formulário, verifique se fonte da View existe no repositório"
Else
	oView:setOperation(MODEL_OPERATION_INSERT)
	
	aFiles := oView:GetFluigForm()
	aEvents[1][1] := "DisplayFields" // nome do evento
	aEvents[1][2] := "function displayFields(form, customHTML) {"+;
							"form.setValue('ecmvalidate', '1');"+;
							"form.setValue('WKDef',getValue('WKDef'));"+;						
							"form.setValue('WKVersDef',getValue('WKVersDef'));"+;						
							"form.setValue('WKNumProces',getValue('WKNumProces'));"+;						
							"form.setValue('WKNumState',getValue('WKNumState'));"+;
							"log.info('Teste de chamada de função - DisplayFields');"+;
						"}"
	
	nFormId := FWECMPutCard(cProcessId,cDescription,cCardDescription,aFiles,aEvents) // retorna o codigo do fichário no ECM
		
	If FWWFIsError()
		Help(" ",1,"PUTCARD",,FWWFGetError()[2],1,1)
	Else
		If lMostraHelp
			MsgInfo(STR0002+ AllTrim(Str(nFormId)) +STR0001)//" atualizado com sucesso"//"Fichário "
		EndIf
	EndIf
EndIf

nModulo := nModuloAnt

Return(nFormId)

//-------------------------------------------------------------------
/*/{Protheus.doc} StartProcess
Esta função inicializa uma solicitação no ECM

@author guilherme.pimentel

@param cProcess Código do processo
@param cUser usuário solicitante
@param aUserList Lista de usuários responsáveis ({'admin'})
@param nTaks Código da atividade inicial
@param lMessage Exibe mensagens de Aviso
@param lComplete Completa a Tarefa ao mudar a atividade
@param aAttach Array com anexos
@param aNextTask [1] Proxima Etapa
				   [2] Código do usuário solicitante	
				   [3] Lista de colaboradores que receberão a taref
@param lFlgSCR	 Atualiza campo CR_FLUIG da alçada

@return aRet[1] Código da Solicitação
@return aRet[2] Identificador do formulário daquela solicitação

@since 27/01/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function StartProcess(cProcess,cUser,aUserList,nTaks,lMessage,lComplete,aAttach,aNextTask,lFlgSCR)
Local nRet 	:= 0
Local nCardId := 0
Local lRet		:= .T.
Local cErrorMsg	:= ''
Local aDados 	:= {}
Local oModel 	:= Nil
Local oView 	:= NIl
Local xValue 	:= Nil
Local aRet 	:= {}
Local nRetM	:= 0

Default aNextTask	:= {}
Default aAttach	:= {}
Default nTaks		:= 0
Default lMessage	:= .T.
Default lComplete	:= .F.
Default lFlgSCR	:= .F.

dbSelectArea("CPF")
CPF->(dbSetOrder(1))
CPF->(dbGoTop())

// -----------------------------------------------------------------------
// Validações se será possivel executar o StartProcess
// -----------------------------------------------------------------------
If !CPF->(DbSeek(xFilial('CPF')+cProcess))
	lRet := .F.	
ElseIf CPF->CPF_STATUS == '4'
	lRet := .F.	
ElseIf !Empty(CPF->CPF_PREEXE)
// -----------------------------------------------------------------------
// Executa a função desejada, verificando seu retorno, se for um retorno logico
// ele será atribuido ao lRet, msgs de erro devão estar dentro da função chamada
// -----------------------------------------------------------------------	
	xValue := &(CPF->CPF_PREEXE)
	
	If ValType(xValue) <> 'L'
		cErrorMsg := MTSetMsg('H','CFG115Blq',STR0015,lMessage) //'A função informada não retorna um valor lógico'
		lRet := .T.
	Else
		lRet := xValue
	EndIf
EndIf

// -----------------------------------------------------------------------
// Execução do StartProcess
// -----------------------------------------------------------------------
If lRet   
	
	oModel := FWLoadModel(CPF->CPF_MODEL)
	oView := FWLoadView(CPF->CPF_VIEW)
			
	oModel:SetOperation(4)
	
	If oModel:Activate()
	   
	    oView:SetModel( oModel )	
		aDados := FWViewCardData(oView)
		
		aAdd(aDados,{'ecmvalidate','0'})
		
		nRet:= FWECMStartProcess(cProcess,;							  //cProcessId Código do processo no ECM
							 nTaks,;								  //nNextTask Número da atividade no ECM. Se informado 0 a solicitação inicia na primeira atividade
							 STR0008,;  		  						//cComments Comentários da tarefa //'Inicialização de solicitação'
							 aDados ,;								//cXMLData XML com os dados do formulário. Para usar certifique-se que o fluxo possua um fichário.
							 aAttach,;								//aAttach Documentos anexos da solicitação
							 cUser,;	  							  //cUserId Matricula do colaborador que irá iniciar a solicitação. Ver documentação do ECM sobre mecanismo de atribuição.
							 aUserList,;	  						  //aColleagueIds Lista de colaboradores que receberão a tarefa. Ver documentação do ECM sobre mecanismo de atribuição.
							 lComplete,;							  //lComplete Indica se deve ou completar a tarefa. Se a tarefa não for completa o fluxo não muda de atividade no ECM.
							 @nCardId)								 			  
			
		// -----------------------------------------------------------------------
		// StartProcess com movimentação automática
		// -----------------------------------------------------------------------
		If !Empty(aNextTask) .And. !FWWFIsError()
		
		nRetM:= FWECMMoveProcess(nRet,;						 // cProcessId Código do processo no ECM
								 aNextTask[1],;					 // nNextTask Número da atividade no ECM. Se informado 0 a solicitação inicia na primeira atividade
								 '',;  		 					 // cComments Comentários da tarefa
								 NIL ,;			 				 // cXMLData XML com os dados do formulário. Para usar certifique-se que o fluxo possua um fichário.
								 {},;								 // aAttach Documentos anexos da solicitação
								 aNextTask[2],;			  		 // cUserId Matricula do colaborador que irá iniciar a solicitação. Ver documentação do ECM sobre mecanismo de atribuição.
								 aNextTask[3],;					 // aColleagueIds Lista de colaboradores que receberão a tarefa. Ver documentação do ECM sobre mecanismo de atribuição.
								 .T.,;								 // lComplete Indica se deve ou completar a tarefa. Se a tarefa não for completa o fluxo não muda de atividade no ECM.
								 @nCardId)								 			  
		EndIf
		
		// Preenche código do processo Fluig
		If nRet > 0 .And. lFlgSCR 
			Reclock('SCR',.F.)
			SCR->CR_FLUIG := cValToChar(nRet)
			SCR->(MSUnlock())
		Endif
		
		// -----------------------------------------------------------------------
		// Tratamento de erro
		// -----------------------------------------------------------------------
		If FWWFIsError()
		   aError := FWWFGetError()
		   cErrorMsg := MTSetMsg('MS',,aError[2],lMessage)
		EndIf
	EndIf	
EndIf

AADD(aRet,nRet)
AADD(aRet,nCardId)
AADD(aRet,cErrorMsg) 

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} MTSetMsg
Função responsavel pelo controle das mensagens

@author guilherme.pimentel

@param cType Tipo da Mensagem
@param cId Identificador da mensagem
@param cError Mensagem de erro
@param lMessage Exibe mensagens de Aviso

@since 02/07/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function MTSetMsg(cType,cId,cError,lMessage)

If lMessage
	If cType == 'H'
		Help(" ",1,cId,,cError,4,1)
	ElseIf cType == 'MS'
		MsgStop(cError)
	ElseIf cType == 'MI'
		MsgInfo(cError)
	EndIf
EndIf

Return cError

//-------------------------------------------------------------------
/*/{Protheus.doc} UpdateCard
Esta função atualiza uma solicitação no ECM

@author paulo.henrique

@param cProcess Código do processo
@param nCardId Numero da solicitacao
@param lMessage Exibe mensagens de Aviso

@since 02/07/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function UpdateCard(cProcess,nCardId,lMessage)
Local lRet := .T.
Local aDados := {}
Local oModel := Nil
Local oView := NIl

Default cProcess := ""
Default nCardId := 0
Default lMessage := .T.

dbSelectArea("CPF")
CPF->(dbSetOrder(1))
CPF->(dbGoTop())

// -----------------------------------------------------------------------
// Validações se será possivel executar o StartProcess
// -----------------------------------------------------------------------
If !CPF->(DbSeek(xFilial('CPF')+cProcess))
	lRet := .F.
	If lMessage
		Help(" ",1,'UpdateCard',,STR0004+cProcess+STR0009,4,1) //'Processo ' //' não encontrado.'
	EndiF
ElseIf CPF->CPF_STATUS == '4'
	lRet := .F.
	If lMessage
		Help(" ",1,'UpdateCard',,STR0010,4,1) //'O processo está bloqueado, favor verificar.'
	EndIf
EndIf

// -----------------------------------------------------------------------
// Execução do FWECMUpdCard
// -----------------------------------------------------------------------
If lRet   
	oModel := FWLoadModel(CPF->CPF_MODEL)
	oView := FWLoadView(CPF->CPF_VIEW)
			
	oModel:SetOperation(MODEL_OPERATION_UPDATE)
	
	If oModel:Activate()
	   
	    oView:SetModel( oModel )	
					
		aDados := FWViewCardData(oView)
		
		aAdd(aDados,{'ecmvalidate','0'})
		
		FWECMUpdCard(nCardId, aDados)
		
		If FWWFIsError()
		   lRet := .F.
		   aError := FWWFGetError()
		   MsgStop(aError[2])
		ElseIf lMessage
		 //MsgInfo(STR0004+AllTrim(Str(nRet))+STR0003)//" iniciado com sucesso"//"Processo "
		EndIf
	EndIf	
EndIf
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} MoveProcess
Esta função move a etapa de uma solicitação no ECM

@author paulo.henrique

@param cProcess Código do processo
@param nInstanceId  Numero da solicitação no ECM
@param cUser usupario solicitante
@param aUserList Lista de usuários responsáveis ({'admin'})
@param nNextTask Código da Proxima atividade se 0 vai para a atividade seguinte
@param cComments Comentários da tarefa
@param lMessage Exibe mensagens de Aviso

@since 07/07/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function MoveProcess(cProcess,nInstanceId,cUser,aUserList,nNextTask,cComments,lMessage)
Local nRet := 0
Local aDados := {}
Local oModel := Nil
Local oView := NIl
Local lRet	:= .T.
Local nCardId := 0	
Local aRet := {}

Default cProcess := ""
Default nInstanceId := 0
Default cUser := 'admin'
Default aUserList := {'admin'}
Default nNextTask := 0
Default cComments := STR0011 //"Movimentação de solicitação"
Default lMessage := .T.

dbSelectArea("CPF")
dbSetOrder(1)
dbGoTop()

// -----------------------------------------------------------------------
// Validações se será possivel executar o StartProcess
// -----------------------------------------------------------------------
If !CPF->(DbSeek(xFilial('CPF')+cProcess))
	lRet := .F.
	If lMessage
		Help(" ",1,'MoveProcess',,STR0004+cProcess+STR0009,4,1) //'Processo '//' não encontrado.'
	EndiF
ElseIf CPF->CPF_STATUS == '4'
	lRet := .F.
	If lMessage
		Help(" ",1,'MoveProcess',,STR0010,4,1)//'O processo está bloqueado, favor verificar.'
	EndIf
EndIf

// -----------------------------------------------------------------------
// Execução do MoveProcess
// -----------------------------------------------------------------------
If lRet   
	oModel := FWLoadModel(CPF->CPF_MODEL)
	oView := FWLoadView(CPF->CPF_VIEW)
			
	oModel:SetOperation(MODEL_OPERATION_UPDATE)
	
	If oModel:Activate()
	   
	    oView:SetModel( oModel )	
					
		aDados := FWViewCardData(oView) // Verificar
		
		aAdd(aDados,{'ecmvalidate','0'})
		
		nRet:= FWECMMoveProcess(nInstanceId,;							 // cProcessId Código do processo no ECM
							 nNextTask,;								 // nNextTask Número da atividade no ECM. Se informado 0 a solicitação inicia na primeira atividade
							 cComments,;  		 						 // cComments Comentários da tarefa
							 NIL ,;			 							 // cXMLData XML com os dados do formulário. Para usar certifique-se que o fluxo possua um fichário.
							 {},;									     // aAttach Documentos anexos da solicitação
							 cUser,;							  		 // cUserId Matricula do colaborador que irá iniciar a solicitação. Ver documentação do ECM sobre mecanismo de atribuição.
							 aUserList,;								 // aColleagueIds Lista de colaboradores que receberão a tarefa. Ver documentação do ECM sobre mecanismo de atribuição.
							 .T.,;										 // lComplete Indica se deve ou completar a tarefa. Se a tarefa não for completa o fluxo não muda de atividade no ECM.
							 @nCardId)								 			  
		
		
		If FWWFIsError()
		   aError := FWWFGetError()
		   MsgStop(aError[2])
		ElseIf lMessage
		//  MsgInfo(STR0004+AllTrim(Str(nRet))+STR0003)//" iniciado com sucesso"//"Processo "
		EndIf
	EndIf	
EndIf

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CancelProcess
Rotina para cancelamento de Solicitações no Fluig

@author guilherme.pimentel
@return Nil
@since 14/03/2013
@version P11
/*/
//-------------------------------------------------------------------

Function CancelProcess(nInstanceId,cUserId,cComments,lMessage)
Local lRet := .T.
Local aError := {}

Default lMessage := .T.

If Empty(nInstanceId)
	If lMessage
		Help("",1,"CancelProcess",,STR0012,1,1) //'É necessário informa o código da atividade.'
	EndIf
ElseIf Empty(cUserId)
	If lMessage
		Help("",1,"CancelProcess",,STR0013,1,1) //'Favor informar o código do usuário.'
	EndIf
ElseIf Empty(cComments)
	If lMessage
		Help("",1,"CancelProcess",,STR0014,1,1) //'É obrigatório informar o motivo do cancelamento.'
	EndIf
Else
	
	lRet := FWECMCancelProcess(nInstanceId,cUserId,cComments)
	
	If FWWFIsError()
		aError := FWWFGetError()
		MsgStop(aError[2])
	ElseIf lMessage
		MsgInfo(STR0004+AllTrim(Str(nInstanceId))+STR0005)//" cancelado com sucesso"//"Processo "
	EndIf

EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} MTaEvtDef
Default do array padrão de eventos dos processos do ECM

@author guilherme.pimentel

@since 11/02/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function MTaEvtDef()
Local aEvents := Array(3,2)
Local oModel := FWModelActive()

Private __ECMEVENT := 1, __ECMINC := oModel:GetValue('CPFMASTER','CPF_MODO') == '2'

// -----------------------------------------------------------------------
// Caso venha do configurador o beforeTaskSave sera definido por um campo
// O script do MTAtuIncWF.aph foi descontinuado, sendo tratado no MTAtuWF.aph
// -----------------------------------------------------------------------
aEvents[1][1] := "beforeTaskSave"
aEvents[1][2] := AllTrim(h_MTAtuWF())

aEvents[2][1] := "beforeStateEntry"
aEvents[2][2] := 'function beforeStateEntry(sequenceId) {'+;
 		'if (sequenceId  != "1") {'+;
       	'log.info("BSE - Troca do ecmvalidate");'+;
			'hAPI.setCardValue("ecmvalidate","1");'+;
			'log.info("BSE - Novo ecmvalidate = "+hAPI.getCardValue("ecmvalidate"));'+;
    	'}'+;		
'}' 

// -----------------------------------------------------------------------
// Tratamento de tarefa conjunta
// -----------------------------------------------------------------------
__ECMEVENT := 2
aEvents[3][1] := "calculateAgreement"
aEvents[3][2] := AllTrim(h_MTAtuWF())
Return aEvents

//-------------------------------------------------------------------
/*/{Protheus.doc} MTaPropDef
Default do array padrão de propriedades dos processos do ECM

@author guilherme.pimentel

@param oModel Modelo ativo
@param oView View ativa
@since 11/02/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function MTaPropDef(oModel,oView,cModel,cReturn,cUpdStates,cUpdSolic)
Local aProperties	:= Array(7,2)

Default cReturn	:= '2' //Não
Default cUpdStates := ''

//PROPRIEDADES
aProperties[1][1] := "FWMODEL" // RESPONSAVEL PELA VALIDAÇÃO DO MODELO
aProperties[1][2] := If(Empty(cModel),oModel:GetId(),cModel) // valor

aProperties[2][1] := "FWRETURN" // TRATAMENTO PARA WF QUE EXIGEM ATUALIZAÇÃO NO FORMULÁRIO APÓS COMMIT NO MODELO
aProperties[2][2] := cReturn // valor

aProperties[3][1] := "SPECIALKEY"
aProperties[3][2] := Upper(GetSrvProfString("SpecialKey", ""))

aProperties[4][1] := "FWUPDSTATES" // VERIFICA EM QUAIS ETAPAS FAZ ATUALIZAÇÃO NO PROTHEUS
aProperties[4][2] := cUpdStates

aProperties[5][1] := "FWUPDSOLIC" // VERIFICA SE SEMPRE EXECUTARÁ A DESCIDA DE DADOS DO FLUIG P/ O PROTHEUS NA MOVIMENTAÇÃO
aProperties[5][2] := cUpdSolic

aProperties[6][1] := "APPLICATIONID" // ID DO APLICATIVO DO PROTHEUS NO IDENTITY (USADO NAS AÇÕES RELACIONADAS DO FORMULÁRIO)
aProperties[6][2] := If(FindFunction('FluigAppId'),FluigAppId(),'')

aProperties[7][1] := "IDENTITYURL" // ENDEREÇO DO FLUIG IDENTITY (USADO NAS AÇÕES RELACIONADAS DO FORMULÁRIO)
aProperties[7][2] := If(FindFunction('FluigIdmUrl'),FluigIdmUrl(),'')

Return aProperties

//-------------------------------------------------------------------
/*/{Protheus.doc} GCPProcess
Esta função coloca/atualiza um processo do edital no ECM

@author guilherme.pimentel
@param oModel Modelo de dados
@param nFichaId Código do fichário

@since 27/01/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function GCPProcess(oModel,oView,nFichaId)
//FLUIG
Local cProcessId := "GCPA200"
Local cDescription := "Editais"
Local cInstruction := "Editais - Etapa - Modalidade"
Local nFormId := nFichaId // id do fichário adicionado no ECM no passo anterior
Local aStates := {} // atividades do processo em sequencia para criação automática dos fluxos
Local aEvents := {} // eventos que serão customizados para o processo
Local aProperties := {} // propriedades que serão utilizadas nos scripts dos eventos do processo
Local aSequence := {} //Array de definição do fluxo do processo

//PROTHEUS
Local oModelCP5 := oModel:GetModel('CP5DETAIL') // Modalidade
Local oModelCP0 := oModel:GetModel('CP0DETAIL') // Fluxo
Local nX := 0
Local nY := 0
Local nPos := 0
Local aAux := {}
Local nEtapaV := 0
Local nEtapaF := 0
Local nMv_TimeFlg := SuperGetMv('MV_TIMEFLG',.F.,14400)

For nX := 1 to oModelCP5:Length(.T.)
	oModelCP5:GoLine(nX)
	aStates := {}
	aSequence := {}
	aAux := {}
	aEtpVld := {}
	nPos := 1
	
	//MONTAGEM DO ARRAY DE ETAPAS VALIDAS (DESCONSIDERA INICIAIS DUPLICADAS)
	For nY := 1 to oModelCP0:Length(.T.)
		oModelCP0:GoLine(nY)
		If nY == 1
			aAdd(aEtpVld,oModelCP0:GetValue('CP0_ETAPA'))
		EndIf
		If !Empty(oModelCP0:GetValue('CP0_PROXIV')) .And. aScan(aEtpVld,oModelCP0:GetValue('CP0_PROXIV')) == 0
			aAdd(aEtpVld,oModelCP0:GetValue('CP0_PROXIV'))
		EndIf
		If !Empty(oModelCP0:GetValue('CP0_PROXIF')) .And. aScan(aEtpVld,oModelCP0:GetValue('CP0_PROXIF')) == 0
			aAdd(aEtpVld,oModelCP0:GetValue('CP0_PROXIF'))
		EndIf
	Next nY 
	oModelCP0:GoLine(1)
	
	//DEFINIÇÃO DAS ETAPAS VALIDAS E SUAS POSIÇOES
	For nY := 1 to oModelCP0:Length(.T.)
		oModelCP0:GoLine(nY)
		If aScan(aEtpVld,{|x|x==oModelCP0:GetValue('CP0_ETAPA')}) > 0
			aAdd(aAux,{oModelCP0:GetValue('CP0_ETAPA'),nPos})
			nPos += 1
		EndIf
	Next nY
	
	//ELABORAÇÃO DO ARRAY DE POSIÇOES E FLUXOS
	For nY := 1 to oModelCP0:Length(.T.)
		oModelCP0:GoLine(nY)
		
		nPos := aScan(aAux,{|x|x[1]==oModelCP0:GetValue('CP0_ETAPA')})
		
		If nPos > 0
			aAdd(aStates,{Tabela("LE",oModelCP0:GetValue('CP0_ETAPA'),.F.),; // atividade
							Tabela("LE",oModelCP0:GetValue('CP0_ETAPA'),.F.),; // descrição
							"",; // instruções
							nMV_TimeFlg,; //prazo de conclusão em segundos
							0,; // mecanismo de atribuição (zero para nenhum, 1 para grupo ou 2 para usuário)
							""}) // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero
			
			nEtapaV := aScan(aAux,{|x|x[1]==oModelCP0:GetValue('CP0_PROXIV')})
			nEtapaF := aScan(aAux,{|x|x[1]==oModelCP0:GetValue('CP0_PROXIF')})
		
			//Etapas definidas para o fluxo
			If nEtapaV > 0
				If  !Empty(oModelCP0:GetValue('CP0_PROXIF'))
					aAdd(aSequence,{nPos,nEtapaV,nEtapaF})
				Else
					aAdd(aSequence,{nPos,nEtapaV})
				EndIf
			EndIf
		EndIf
		
	Next nY

	//EVENTOS
	aEvents := MTaEvtDef()
	
	//PROPRIEDADES
	//aProperties := MTaPropDef(oModel,oView,'GCPA200')
	aProperties := MTaPropDef(oModel,oView,'GCPA200_MVC')
	
	cProcessId := 'R'+oModelCP5:GetValue('CP5_REGRA')+'-'+oModelCP5:GetValue('CP5_MODALI')
	
	//PROCESSAMENTO
	Conout(STR0016+oModelCP5:GetValue('CP5_REGRA')+STR0017+oModelCP5:GetValue('CP5_MODALI')+;//'Importando regra '//' - Modalidade '
			' - cProcessId '+cProcessId)
	
	cDescription := cProcessId
	
	FWECMProcess(cProcessId, cDescription, cInstruction, nFormId, aStates, aEvents, aProperties, aSequence,.F.)

	If FWWFIsError()
   		Help(" ",1,"PUTCARD",,FWWFGetError()[2],1,1)
	Else
	   Conout(STR0018)//'Processo Importado com sucesso'
	EndIf

Next nX

MsgInfo(STR0007)//"Processo finalizado!"
oModelCP5:GoLine(1)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GCPSmartPr
Esta função coloca/atualiza um processo reduzido do GCP

@author guilherme.pimentel
@param oModel Modelo de dados
@param nFichaId Código do fichário

@Obs Essa função é utilizada para subir os processos do GCP até a 
etapa de publicação, diferente da GCPProcess, que sobe o processo
por completo. 

@since 18/02/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function GCPSmartPr(oModel,oView,nFichaId)
//FLUIG
Local cProcessId := "GCPA200"
Local cDescription := STR0019//"Editais"
Local cInstruction := STR0020//"Editais - Etapa - Modalidade"
Local nFormId := nFichaId // id do fichário adicionado no ECM no passo anterior
Local aStates := {} // atividades do processo em sequencia para criação automática dos fluxos
Local aEvents := {} // eventos que serão customizados para o processo
Local aProperties := {} // propriedades que serão utilizadas nos scripts dos eventos do processo
Local aSequence := {} //Array de definição do fluxo do processo
Local aError

//PROTHEUS
Local oModelCP5 := oModel:GetModel('CP5DETAIL') // Modalidade
Local oModelCP0 := oModel:GetModel('CP0DETAIL') // Fluxo
Local nX := 0
Local nY := 0
Local nPos := 0
Local aAux := {}
Local nEtapaV := 0
Local nEtapaF := 0
Local lFind := 0
Local nMv_TimeFlg := SuperGetMv('MV_TIMEFLG',.F.,14400)

For nX := 1 to oModelCP5:Length(.T.)
	oModelCP5:GoLine(nX)
	aStates := {}
	aSequence := {}
	aAux := {}
	nPos := 1
	lFind := .F.
	
	oModelCP0:GoLine(1)
	While !lFind
		If oModelCP0:GetValue('CP0_ETAPA') == 'PB'
			lFind := .T.
			aAdd(aAux,{oModelCP0:GetValue('CP0_ETAPA'),nPos})
		Else
			aAdd(aAux,{oModelCP0:GetValue('CP0_ETAPA'),nPos})
			nPos += 1
			cPrx := oModelCP0:GetValue('CP0_PROXIV')
			// Vai para a proxima etapa verdadeira
			For nY := 1 to oModelCP0:Length(.T.)
				oModelCP0:GoLine(nY)
				If 	oModelCP0:GetValue('CP0_ETAPA') == cPrx
					Exit
				EndIf
			Next nY
		EndIf
	End
			
	//ELABORAÇÃO DO ARRAY DE POSIÇOES E FLUXOS
	For nY := 1 to oModelCP0:Length(.T.)
		oModelCP0:GoLine(nY)
		
		nPos := aScan(aAux,{|x|x[1]==oModelCP0:GetValue('CP0_ETAPA')})
		
		If nPos > 0
			aAdd(aStates,{Tabela("LE",oModelCP0:GetValue('CP0_ETAPA'),.F.),; // atividade
							Tabela("LE",oModelCP0:GetValue('CP0_ETAPA'),.F.),; // descrição
							"",; // instruções
							nMv_TimeFlg,; //prazo de conclusão em segundos
							0,; // mecanismo de atribuição (zero para nenhum, 1 para grupo ou 2 para usuário)
							""}) // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero
			
			nEtapaV := aScan(aAux,{|x|x[1]==oModelCP0:GetValue('CP0_PROXIV')})
		
			//Etapas definidas para o fluxo
			If nEtapaV > 0
				aAdd(aSequence,{nPos,nEtapaV})
			EndIf
		EndIf
		
	Next nY
	
	//REVER
	aAdd(aStates,{STR0021,; // atividade //'Etapa final' 
					STR0021,; // descrição //'Etapa final'
					"",; // instruções
					nMV_TimeFlg,; //prazo de conclusão em segundos
					0,; // mecanismo de atribuição (zero para nenhum, 1 para grupo ou 2 para usuário)
					""}) // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero
							
	aAdd(aSequence,{3,4})
			
	
	//EVENTOS
	aEvents := MTaEvtDef()
	
	//PROPRIEDADES
	aProperties := MTaPropDef(oModel,oView,'GCPA200')
	
	cProcessId := 'R'+oModelCP5:GetValue('CP5_REGRA')+'-'+oModelCP5:GetValue('CP5_MODALI')
	
	//PROCESSAMENTO
	Conout(STR0016+oModelCP5:GetValue('CP5_REGRA')+STR0017+oModelCP5:GetValue('CP5_MODALI')+;//'Importando regra '//' - Modalidade '
			' - cProcessId '+cProcessId)
	
	cDescription := cProcessId
	
	FWECMProcess(cProcessId, cDescription, cInstruction, nFormId, aStates, aEvents, aProperties, aSequence,.F.)

	If FWWFIsError()
	   aError := FWWFGetError()
	   MsgStop(aError[2])
	Else
	   Conout(STR0018)//'Processo Importado com sucesso'
	EndIf

Next nX

MsgInfo(STR0007)//"Processo finalizado!"
oModelCP5:GoLine(1)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GCPFluigPr
Esta função cria/atualiza um processo reduzido do GCP no gerador

@author guilherme.pimentel
@param oModel Modelo de dados
@param nFichaId Código do fichário

@Obs Essa função é utilizada para subir os processos do GCP para o gerador
até a etapa de publicação, diferente da GCPProcess, que sobe o processo
por completo e da GCPSmartPr que envia diretamente para o Fluig. 

@since 18/02/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function GCPFluigPr(oModel)
Local aStates := {} // atividades do processo em sequencia para criação automática dos fluxos
Local aEvents := {} // eventos que serão customizados para o processo
Local aProperties := {} // propriedades que serão utilizadas nos scripts dos eventos do processo
Local aSequence := {} //Array de definição do fluxo do processo
Local aError

Local oModel115 := FWLoadModel('CFGA115')
Local oModelCP5 := oModel:GetModel('CP5DETAIL') // Modalidade
Local oModelCP0 := oModel:GetModel('CP0DETAIL') // Fluxo
Local nX := 0
Local nY := 0
Local nPos := 0
Local aAux := {}
Local nEtapaV := 0
Local nEtapaF := 0
Local lFind := 0

For nX := 1 to oModelCP5:Length(.T.)
	oModelCP5:GoLine(nX)
	aStates := {}
	aSequence := {}
	aAux := {}
	nPos := 1
	lFind := .F.
	
	oModelCP0:GoLine(1)
	While !lFind
		If oModelCP0:GetValue('CP0_ETAPA') == 'PB'
			lFind := .T.
			aAdd(aAux,{oModelCP0:GetValue('CP0_ETAPA'),nPos})
		Else
			aAdd(aAux,{oModelCP0:GetValue('CP0_ETAPA'),nPos})
			nPos += 1
			cPrx := oModelCP0:GetValue('CP0_PROXIV')
			// Vai para a proxima etapa verdadeira
			For nY := 1 to oModelCP0:Length(.T.)
				oModelCP0:GoLine(nY)
				If 	oModelCP0:GetValue('CP0_ETAPA') == cPrx
					Exit
				EndIf
			Next nY
		EndIf
	End
			
	//ELABORAÇÃO DO ARRAY DE POSIÇOES E FLUXOS
	For nY := 1 to oModelCP0:Length(.T.)
		oModelCP0:GoLine(nY)
		
		nPos := aScan(aAux,{|x|x[1]==oModelCP0:GetValue('CP0_ETAPA')})
		
		If nPos > 0
			aAdd(aStates,{oModelCP0:GetValue('CP0_ETAPA'),; // atividade
							Tabela("LE",oModelCP0:GetValue('CP0_ETAPA'),.F.),; // descrição
							"",; // instruções
							60,; //prazo de conclusão em segundos
							0,;  // mecanismo de atribuição (zero para nenhum, 1 para grupo ou 2 para usuário)
							"",;  // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero
							nPos,; //Identificação dele no array de sequencias
							0}) //identificador da etapa - Usado somente para gerar registros no gerador de processo.
			
			nEtapaV := aScan(aAux,{|x|x[1]==oModelCP0:GetValue('CP0_PROXIV')})
		
			//Etapas definidas para o fluxo
			If nEtapaV > 0
				aAdd(aSequence,{nPos,nEtapaV})
			EndIf
		EndIf
		
	Next nY
	
	//Função que cadastra o processo no gerador		
	oModel115 := MTFluig115('R'+oModelCP5:GetValue('CP5_REGRA')+'-'+oModelCP5:GetValue('CP5_MODALI'),;
								'R'+oModelCP5:GetValue('CP5_REGRA')+'-'+oModelCP5:GetValue('CP5_MODALI'),;
								'GCPA200',;
								'WFGCPA200',;
								'1',;
								STR0022,;//'Fluxo do Edital'
								87,;
								aStates,aSequence,aAux)
	
	Conout(STR0016+oModelCP5:GetValue('CP5_REGRA')+STR0017+oModelCP5:GetValue('CP5_MODALI')+;//'Importando regra '//' - Modalidade '
			' - cProcessId '+'R'+oModelCP5:GetValue('CP5_REGRA')+'-'+oModelCP5:GetValue('CP5_MODALI'))
	
Next nX

MsgInfo(STR0007)//"Processo finalizado!"
oModelCP5:GoLine(1)

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} MTFluig115
Esta função cria/atualiza qualquer processo no gerador

@author guilherme.pimentel

@since 22/04/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function MTFluig115(cCodPrc,cDesPrc,cModel,cView,cModo,cInst,nModulo,aStates,aSequence,aAux)
Local oModel 		:= FWLoadModel('CFGA115')
Local oModelCPF 	:= oModel:GetModel('CPFMASTER')
Local oModelCPG	:= oModel:GetModel('CPGDETAIL')
Local oModelCPU	:= oModel:GetModel('CPUDETAIL')
Local nLineCPG	:= 0
Local nStates		:= 0
Local nX := 0
Local nY := 0
Local lRet			:= .T.

If CPF->(DbSeek(xFilial('CPF')+cCodPrc))
	oModel:SetOperation(MODEL_OPERATION_UPDATE)
Else
	oModel:SetOperation(MODEL_OPERATION_INSERT)
EndIf

If oModel:Activate()
	
	// --------------------------------------------------
	// Processo
	// --------------------------------------------------
	oModelCPF:SetValue('CPF_CODPRC',cCodPrc)
	oModelCPF:SetValue('CPF_DESPRC',cDesPrc)
	oModelCPF:SetValue('CPF_PROPRI','1')
	oModelCPF:SetValue('CPF_MODEL',cModel)
	oModelCPF:SetValue('CPF_VIEW',cView) //Verificar
	oModelCPF:SetValue('CPF_STATUS','1')
	oModelCPF:SetValue('CPF_MODO','1')
	oModelCPF:SetValue('CPF_ATUFOR',.T.)
	oModelCPF:SetValue('CPF_INSTRU',cInst)
	oModelCPF:SetValue('CPF_MODULO',Alltrim(Str(nModulo)))
	
	// --------------------------------------------------
	// Atividades
	// --------------------------------------------------
	For nX:=1 to len(aStates)
		If nX<>1
			oModelCPG:AddLine()
		EndIf
		oModelCPG:SetValue('CPG_ITEM',STRZERO(nX,TamSX3("CPG_ITEM")[1]))
		oModelCPG:SetValue('CPG_DESATV',aStates[nX][2])
		oModelCPG:SetValue('CPG_MECAT',Alltrim(Str(aStates[nX][5])))
		If Str(aStates[nX][5]) == '1'
			oModelCPG:SetValue('CPG_MAGRP',aStates[nX][6])
		ElseIf Str(aStates[nX][5]) == '2'
			oModelCPG:SetValue('CPG_MAUSER',aStates[nX][6])
		EndIf
		
		aStates[nX][8] := oModelCPG:getLine()
		
	Next nX
	
	// --------------------------------------------------
	// Sequencia
	// --------------------------------------------------
	For nX:=1 to len(aSequence)
		//Pegar o item que vai receber a sequencia e posicionar
		nLineCPG := aStates[aScan(aStates,{|x|x[7] == aSequence[nX][1]})][8]  
		oModelCPG:GoLine( nLineCPG )
		
		//Pegar o item que é a proxima sequencia e colocar no CPU dentro de um for
		For nY := 2 to Len(aSequence[nX])
			If nY <> 2
				oModelCPU:AddLine()
			EndIf
			nStates := aScan(aStates,{|x|x[7] == aSequence[nX][nY]})
			oModelCPU:SetValue('CPU_SEQ',oModelCPG:GetValue('CPG_ITEM',aStates[nStates][8]))
		Next nY			
	Next nX
	
EndIf

If oModel:VldData()
	lRet := oModel:CommitData()
EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} SCProcess
Esta função coloca/atualiza um processo de solicitação de compras no ECM

@author guilherme.pimentel
@param oModel Modelo de dados
@param nFichaId Código do fichário

@since 06/02/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function SCProcess(oModel,oView,nFichaId)
//FLUIG
Local cProcessId := "MATA110_MVC"
Local cDescription := STR0023//"Solicitacoes"
Local cInstruction := STR0023//"Solicitacoes"
Local nFormId := nFichaId // id do fichário adicionado no ECM no passo anterior
Local aStates := {} // atividades do processo em sequencia para criação automática dos fluxos
Local aEvents := {} // eventos que serão customizados para o processo
Local aProperties := {} // propriedades que serão utilizadas nos scripts dos eventos do processo
Local aSequence := {} //Array de definição do fluxo do processo
Local aError
Local nMv_TimeFlg := SuperGetMv('MV_TIMEFLG',.F.,14400)

aAdd(aStates,{STR0024,; // atividade //'Início'
              STR0024,; // descrição //'Início'
              "",; // instruções
              60,; //prazo de conclusão em segundos
              0,; // mecanismo de atribuição (zeoro para nenhum, 1 para grupo ou 2 para usuário)
              ""}) // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero
                  
aAdd(aStates,{STR0025,; // atividade //'Aprovação'
              STR0025,; // descrição //'Aprovação'
              "",; // instruções
              60,; //prazo de conclusão em segundos
              0,; // mecanismo de atribuição (zeoro para nenhum, 1 para grupo ou 2 para usuário)
              ""}) // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero

aAdd(aStates,{STR0026,; // atividade //'Fim'
              STR0026,; // descrição //'Fim'
              "",; // instruções
              nMV_TimeFlg,; //prazo de conclusão em segundos
              0,; // mecanismo de atribuição (zeoro para nenhum, 1 para grupo ou 2 para usuário)
              ""}) // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero

aAdd(aSequence,{1,2})
aAdd(aSequence,{2,3})

//EVENTOS
aEvents := MTaEvtDef()
      
//PROPRIEDADES
aProperties := MTaPropDef(oModel,oView)
        
FWECMProcess(cProcessId, cDescription, cInstruction, nFormId, aStates, aEvents, aProperties, aSequence,.F.)

If FWWFIsError()
	aError := FWWFGetError()
    MsgStop(aError[2])
Else
	Conout(STR0018) //'Processo Importado com sucesso'
EndIf


MsgInfo(STR0007)//"Processo finalizado!"


Return

/*-------------------------------------------------------------------
{Protheus.doc} CFGSmartPr
Atualiza o processo definido no configurador de processos CFGA115

@author Alex Egydio
@since 21/02/2014
@version P12
-------------------------------------------------------------------*/
Function CFGSmartPr(oModel,oView,nFichaId)
Local aAux			:= {}
Local aStates		:= {} // Atividades do processo em sequencia para criação automática dos fluxos
Local aEvents		:= {} // Eventos que serão customizados para o processo
Local aSequence	:= {} // Array de definição do fluxo do processo
Local aSeqRet		:= {} // Array de definição da Sequencia de Retorno
Local aProperties	:= {} // Propriedades que serão utilizadas nos scripts dos eventos do processo
Local aErro		:= {}
Local aSeqAux		:= {}
Local aSeqRetAux	:= {}
Local cProcessId	:= ""
Local cDescription:= ""
Local cInstruction:= ""
Local cProx		:= ""
Local cMecAt		:= ""
Local cUpdStates	:= ""
Local lFind		:= .F.
Local n1Cnt		:= 0
Local n2Cnt		:= 0
Local nPos			:= 1
Local oModelCPF	:= oModel:GetModel("CPFMASTER")
Local oModelCPG	:= oModel:GetModel("CPGDETAIL")
Local oModelCPU	:= oModel:GetModel("CPUDETAIL")
Local lRet			:= .T.
Local nModuloAnt	:= nModulo
Local aStateColumns	:= {'sequence','version','agreementPercentage'}
Local aStateValues	:= {}
Local nSequence	:= 0
Local cUpdSolic	:= ""
Local lUpdStates := oModelCPG:GetStruct():HasField('CPG_ATUPRT')
Local lUpdSolic := oModelCPG:GetStruct():HasField('CPG_DSCATV')
Local nMv_TimeFlg := SuperGetMv('MV_TIMEFLG',.F.,14400)

nModulo := Val(oModelCPF:GetValue('CPF_MODULO'))

oModelCPG:GoLine(1)

For n1Cnt := 1 To oModelCPG:Length(.T.)
	oModelCPG:GoLine(n1Cnt)
	AAdd(aAux,{oModelCPG:GetValue('CPG_ITEM'),nPos})
	nPos += 1
Next
// --------------------------------------------------
// Elaboracao do array de posicoes e fluxos
// --------------------------------------------------
For n1Cnt := 1 To oModelCPG:Length(.T.)
	oModelCPG:GoLine(n1Cnt)
	nPos := AScan(aAux,{|x|x[1]==oModelCPG:GetValue('CPG_ITEM')})
	If	nPos > 0
		// --------------------------------------------------
		// Define mecanismo de atribuição
		// --------------------------------------------------
		If oModelCPG:GetValue('CPG_MECAT') = '1'
			cMecAt := oModelCPG:GetValue('CPG_MAGRP')
		ElseIf oModelCPG:GetValue('CPG_MECAT') = '2'
			cMecAt := FWWFColleagueId(oModelCPG:GetValue('CPG_MAUSER'))
			If Empty(cMecAt)
				cMecAt := "000000"
			EndIf	
		ElseIf oModelCPG:GetValue('CPG_MECAT') = '3'
			cMecAt := Alltrim(oModelCPG:GetValue('CPG_MCPO'))
		Else
			cMecAt := ''
		EndIf
		// --------------------------------------------------
		// Insere etapas do processo
		// --------------------------------------------------
		nSequence++
		AAdd(aStates,{oModelCPG:GetValue('CPG_DESATV'),; // atividade
						oModelCPG:GetValue('CPG_DESATV'),; // descrição
						"",; // instruções
						nMV_TimeFlg,; //prazo de conclusão em segundos
						Val(oModelCPG:GetValue('CPG_MECAT')),; // mecanismo de atribuição (zero para nenhum, 1 para grupo ou 2 para usuário)
						cMecAt,; // código do grupo ou usuário no ECM caso o mecanismo de atribuição seja diferente de zero
						nSequence,;
						oModelCPG:GetValue('CPG_ATVCOM'),;
						Max(oModelCPG:GetValue('CPG_CONSEN'),1)})
		
		If oModelCPG:GetValue('CPG_ATVCOM')
			Aadd(aStateValues, {nSequence,'1',oModelCPG:GetValue('CPG_CONSEN')})
		EndIf
		
		// --------------------------------------------------
		// Etapas definidas para o fluxo
		// --------------------------------------------------
		aSeqAux := {}
		aSeqRetAux := {}
		oModelCPU:GoLine(1)
		If AScan(aAux,{|x|x[1]==oModelCPU:GetValue('CPU_SEQ')}) > 0
			AAdd(aSeqAux,nPos)
			For n2Cnt := 1 to oModelCPU:Length()
				oModelCPU:GoLine(n2Cnt)
				AAdd(aSeqAux,AScan(aAux,{|x|x[1]==oModelCPU:GetValue('CPU_SEQ')}))
				AAdd(aSeqRetAux,oModelCPU:GetValue('CPU_PERRET'))
			Next n2Cnt
			AAdd(aSequence,aSeqAux)
			AAdd(aSeqRet,aSeqRetAux)
		EndIf
		// --------------------------------------------------
		// Verificação se atualiza Protheus
		// --------------------------------------------------
		If lUpdStates .and. oModelCPG:GetValue('CPG_ATUPRT')
			If Empty(cUpdStates)
				cUpdStates += '|'
			EndIf
			cUpdStates += AllTrim(Str(nSequence)) + '|'
		EndIf
		
		// --------------------------------------------------
		// Verificação se a etapa sempre terá descida do Fluig para o Protheus
		// --------------------------------------------------
		If lUpdSolic .and. oModelCPG:GetValue('CPG_DSCATV') == '1'
			If Empty(cUpdSolic)
				cUpdSolic += '|'
			EndIf
			cUpdSolic += AllTrim(Str(nSequence)) + '|'
		EndIf
	EndIf
Next
// --------------------------------------------------
// Eventos
// --------------------------------------------------
aEvents := MTaEvtDef()
// --------------------------------------------------
// Propriedades
// --------------------------------------------------
aProperties := MTaPropDef(oModel,;
							  FWLoadView(oModel:GetValue('CPFMASTER','CPF_VIEW')),;
							  AllTrim(oModel:GetValue('CPFMASTER','CPF_MODEL')),;
							  If(oModel:GetValue('CPFMASTER','CPF_ATUFOR'),'1','2'),;
							  cUpdStates,cUpdSolic)
// --------------------------------------------------
// Definição dos variaveis de controle atraves do modelo
// --------------------------------------------------
cProcessId		:= AllTrim(oModelCPF:GetValue('CPF_CODPRC'))
cDescription	:= AllTrim(oModelCPF:GetValue('CPF_DESPRC'))
cInstruction	:= AllTrim(oModelCPF:GetValue('CPF_INSTRU'))
// --------------------------------------------------
// Processamento
// --------------------------------------------------
FWECMProcess(cProcessId, cDescription, cInstruction, nFichaId, aStates, aEvents, aProperties, aSequence,.F., aSeqRet)

If FWWFIsError()
   aError := FWWFGetError()
   MsgStop(aError[2])
   lRet := .F.
Else
	FWECMDataSet(cProcessId + '_STATE', aStateColumns, aStateValues)
   Conout(STR0018) //'Processo importado com sucesso!'
   MsgInfo(STR0018)//'Processo importado com sucesso!'
EndIf

nModulo := nModuloAnt

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} MTComPr
Geração do processo geral de compras

@author guilherme.pimentel
@param oModel Modelo de dados

@since 31/03/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------

Function MTComPr()
Local lRet := .T.
Local oModel:= FWModelActive()
Local oModelCPF 	:= oModel:GetModel('CPFMASTER')
Local oModelCPG	:= oModel:GetModel('CPGDETAIL')
Local oModelCPS	:= oModel:GetModel('CPSDETAIL')
Local nX := 0

// --------------------------------------------------
// Processo
// --------------------------------------------------
oModelCPF:SetValue('CPF_CODPRC','PCOM')
oModelCPF:SetValue('CPF_DESPRC',STR0027)//'Processo de Compras'
oModelCPF:SetValue('CPF_PROPRI','1')
oModelCPF:SetValue('CPF_MODEL','MTComprasWF')
oModelCPF:SetValue('CPF_VIEW','MTComprasWF')
oModelCPF:SetValue('CPF_STATUS','1')
oModelCPF:SetValue('CPF_MODO','1')
oModelCPF:SetValue('CPF_INSTRU',STR0028)//'Processo Geral de compras'
oModelCPF:SetValue('CPF_MODULO','02')

// --------------------------------------------------
// Solicitação de compra
// --------------------------------------------------
oModelCPG:LoadValue('CPG_ITEM','001')
oModelCPG:SetValue('CPG_DESATV',STR0029)//'Solicitação de Compras'
oModelCPG:SetValue('CPG_DECID1','002')
For nX := 1 to oModelCPS:Length()
	oModelCPS:GoLine(nX)
	If nX > 2  
		oModelCPS:SetValue('CPS_VISUAL','3')
	EndIf
Next nX
oModelCPS:GoLine(1)
// --------------------------------------------------
// Aprovação da SC
// --------------------------------------------------
oModelCPG:AddLine()
oModelCPG:LoadValue('CPG_ITEM','002')
oModelCPG:SetValue('CPG_DESATV',STR0030)//'Aprovação da SC'
oModelCPG:SetValue('CPG_DECID1','003')
oModelCPG:SetValue('CPG_DECID2','007')
For nX := 1 to oModelCPS:Length()
	oModelCPS:GoLine(nX)
	If nX <= 3  
		oModelCPS:SetValue('CPS_VISUAL','2')
	ElseIf nX > 3
		oModelCPS:SetValue('CPS_VISUAL','3')
	EndIf
Next nX
oModelCPS:GoLine(1)
// --------------------------------------------------
// Cotação
// --------------------------------------------------
oModelCPG:AddLine()
oModelCPG:LoadValue('CPG_ITEM','003')
oModelCPG:SetValue('CPG_DESATV',STR0031)//'Cotação - Propostas'
oModelCPG:SetValue('CPG_DECID1','004')
For nX := 1 to oModelCPS:Length()
	oModelCPS:GoLine(nX)
	If nX <= 4  
		oModelCPS:SetValue('CPS_VISUAL','2')
	ElseIf nX > 5
		oModelCPS:SetValue('CPS_VISUAL','3')
	EndIf
Next nX
oModelCPS:GoLine(1)
// --------------------------------------------------
// Seleção dos fornecedores
// --------------------------------------------------
oModelCPG:AddLine()
oModelCPG:LoadValue('CPG_ITEM','004')
oModelCPG:SetValue('CPG_DESATV',STR0032)//'Cotação - Escolha'
oModelCPG:SetValue('CPG_DECID1','005')
For nX := 1 to oModelCPS:Length()
	oModelCPS:GoLine(nX)
	If nX <= 6  
		oModelCPS:SetValue('CPS_VISUAL','2')
	ElseIf nX > 7
		oModelCPS:SetValue('CPS_VISUAL','3')
	EndIf
Next nX
oModelCPS:GoLine(1)
// --------------------------------------------------
// Pedido de compra
// --------------------------------------------------
oModelCPG:AddLine()
oModelCPG:LoadValue('CPG_ITEM','005')
oModelCPG:SetValue('CPG_DESATV',STR0033)//'Pedido de compra'
oModelCPG:SetValue('CPG_DECID1','006')
For nX := 1 to oModelCPS:Length()
	oModelCPS:GoLine(nX)
	If nX < 8  
		oModelCPS:SetValue('CPS_VISUAL','2')
	ElseIf nX > 9
		oModelCPS:SetValue('CPS_VISUAL','3')
	EndIf
Next nX
oModelCPS:GoLine(1)

// --------------------------------------------------
// Nota de entrada
// --------------------------------------------------
oModelCPG:AddLine()
oModelCPG:LoadValue('CPG_ITEM','006')
oModelCPG:SetValue('CPG_DESATV',STR0034)//'Nota de entrada'
oModelCPG:SetValue('CPG_DECID1','007')
For nX := 1 to oModelCPS:Length()
	oModelCPS:GoLine(nX)
	If nX < 11  
		oModelCPS:SetValue('CPS_VISUAL','2')
	EndIf
Next nX
oModelCPS:GoLine(1)
// --------------------------------------------------
// FIM
// --------------------------------------------------
oModelCPG:AddLine()
oModelCPG:LoadValue('CPG_ITEM','007')
oModelCPG:SetValue('CPG_DESATV','Fim')
For nX := 1 to oModelCPS:Length()
	oModelCPS:GoLine(nX)
	oModelCPS:SetValue('CPS_VISUAL','2')
Next nX
oModelCPS:GoLine(1)

Return lRet


/*/{Protheus.doc} MTFluigAtv()
Função para verificar se um determinado processo do fluig

@param cRotinaWF	Identificação da rotina que será utilizada para gerar as solicitações no Fluig. Ex. WFFINA677
@param cCodProc	Identificação do processo de WF gerado no Fluig

@return lRet		Retorna se o processo do WF no Fluig está cadastro e liberado para o ambiente Fluig.    

@author	Marylly Araújo Silva
@since	26/11/2015
@version	P12.1.8
@sample	Local lFluig	:= MTFluigAtv("WFFINA785","SOLAPR")
		If lFluig
			WFFINA785( oFWJMdl:GetValue("FWJ_USUCRI"), oFWJMdl:GetValue("FWJ_CODIGO"), MODEL_OPERATION_INSERT, aUser, .F.)
		EndIf	
/*/
Function MTFluigAtv(cRotinaWF,cCodProc)
Local aAreaCPF	:= {}
Local lRet		:= .F.

DEFAULT cRotinaWF	:= ""
DEFAULT cCodProc	:= ""

cRotinaWF := PADR(cRotinaWF, TamSX3("CPF_VIEW")[1]," ")

DbSelectArea("CPF") // Configurador de Processos
aAreaCPF := CPF->(GetArea())
CPF->(DbSetOrder(2)) // Filial + Rotina + Processo

If CPF->(DbSeek(FWxFilial("CPF") + cRotinaWF + cCodProc ))
	If CPF->CPF_STATUS == '2' // Liberado
		lRet := .T.
	EndIf
EndIf

RestArea(aAreaCPF)
Return lRet

