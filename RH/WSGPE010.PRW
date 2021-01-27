#INCLUDE "WSGPE010.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
////WsClient_WsRHVacation.prx
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³WSGPE010  ³ Autor ³Tatiane Vieira Matias  ³ Data ³07.03.2008  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pelas Ferias	                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ Requisito ³  Motivo da Alteracao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson Campos|30/04/14|TPKFN9     |Replica das alterações realizadas    ³±±
±±³              |        |           |pela manutenção até a data 25/03/14  ³±±
±±³              |        |           |chamado TPBAFB, changeset 215432     ³±±
±±³              |        |           |na P11.80                            ³±±
±±³              |        |           |                                     ³±±
±±³Flavio Correa |08/09/14|TQN451     |Ajuste na função que retorna o perio ³±±
±±³              |        |           |do aberto com os dias de ferias      ³±±
±±³Allyson M     |22/10/14|TQUQES     |Ajuste p/ apenas considerar a progra-³±±
±±³              |        |           |cao de ferias do ultimo periodo.     ³±±
±±³Renan Borges  |25/09/15|TTIQSM     |Ajuste p/ apenas considerar a progra-³±±
±±³              |        |           |cao de ferias do ultimo periodo.     ³±±
±±³Eduardo K.    |20/04/18|MPRIMESP   |Ajuste nos param. da função fVldDSR  ³±±
±±³              |        |14842      |para validar dias de DSR corretamente³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura de Avaliacao de desempenho (Performance Evaluate)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT DataWorkFlow
	WSDATA ListOfWorkFlow  	As Array Of FieldsWorkFlow	//Campos do workflow
ENDWSSTRUCT

WSSTRUCT FieldsWorkFlow
	WSDATA FieldWF     	 	As String			//Campo referente ao workflow
	WSDATA ValueField  		As String			//Valor do campo
ENDWSSTRUCT

WSSTRUCT VacationProg
	WSDATA ListOfPeriod 	As Array of PeriodVacationProg OPTIONAL //Lista dos periodos
ENDWSSTRUCT

WSSTRUCT PeriodVacationProg
	WSDATA EmployeeFilial	As String	 				//Filial do funcionario
	WSDATA Registration		As String	        		//Codigo da matricula
	WSDATA InitialDate 		As String	   				//Data de Inicio do Periodo
	WSDATA FinalDate 		As String	      			//Data de Termino do Periodo
	WSDATA Days 			As Integer OPTIONAL 		//Dias de Direito
	WSDATA ProportionalDays As Float   OPTIONAL 		//Dias Proporcionais
	WSDATA ResidualDays     As Float   OPTIONAL 		//Dias Remanescentes
	WSDATA ScheduleDays     As Float   OPTIONAL 		//Dias Programados
	WSDATA IdCode           As String  OPTIONAL 		//Codigo ID da verba
	WSDATA IDBase           As String  OPTIONAL 		//Codigo da verba
	WSDATA IDBaseDesc               As String  OPTIONAL               //Descricao da verba
    WSDATA BonusType                As String  OPTIONAL     //Permite Indenização
    WSDATA MinDaysSubst			    AS String  OPTIONAL		//Minimo dias para substituição de acordo com a verba  (RCM_DSUBST)
	WSDATA ScheduleDays2	As Float   OPTIONAL 		//Dias da segunda programação	
	WSDATA ThirteenthSalary	As Float   OPTIONAL 		//Primeira parcela decimo terceiro	
ENDWSSTRUCT

WSSTRUCT HistAprov
	WSDATA InitialDate 		As String	       	  		        	//Data de Inicio do Periodo
	WSDATA FinalDate 		As String	      		  	       		//Data de Termino do Periodo
	WSDATA ListOfHistAprov  As Array of DataHistAprov OPTIONAL		//Lista do histórico de aprovações
ENDWSSTRUCT

WSSTRUCT DataHistAprov
	WSDATA AprovDate 			As String			//Data da ação (aprovação ou reprovação)
	WSDATA AprovName 			As String			//Nome do aprovador
	WSDATA ContHist 			As String 			//Descrição da ação
ENDWSSTRUCT

WSSTRUCT VacProgEffect
	WSDATA ListOfVacProgEffect As Array of DataVacProgEffect OPTIONAL	//Lista de Programacao de ferias
ENDWSSTRUCT

WSSTRUCT DataVacProgEffect
	WSDATA InitialDate 		As String  OPTIONAL		//Data de Inicio do Periodo Aquisitivo
	WSDATA FinalDate 		As String  OPTIONAL 	//Data de Termino do Periodo Aquisitivo
	WSDATA CloseDays		As Integer OPTIONAL 	//Dias vencidos
	WSDATA OpenDays			As Integer OPTIONAL 	//Dias a vencer
	WSDATA StartVacDate 	As String  OPTIONAL		//Data de Inicio das ferias
	WSDATA VacationDays		As Integer OPTIONAL 	//Dias de ferias
	WSDATA AllowDays		As Integer OPTIONAL 	//Dias de abono
	WSDATA VacationType		As String  OPTIONAL 	//Tipo de lancto das ferias
	WSDATA RegisterType		As String  OPTIONAL 	//Tipo de Registro(Controle Interno)
ENDWSSTRUCT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Controle do Usuario                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHVacation DESCRIPTION STR0001								//"Ferias"
	WSDATA EmployeeFil 			AS String					        	//Filial do funcionario
	WSDATA Registration			AS String					        	//Matricula do funcionario
	WSDATA TypeApprov			AS String								//"1"-Aprovar programação; "2"-Reprovar programação; "3"-Sugestao de nova data
	WSDATA TypeOfProg           AS Integer       		OPTIONAL        //0-Default; 1-Saldo de dias de Folga
	WSDATA TypeOfSolic                AS String        OPTIONAL            //""-Default;
	WSDATA CodeVacationProg		AS String								//Codigo da programacao de ferias
	WSDATA WsNull               AS String								//NULL
	WSDATA StatusEmployee    	AS String								//Status do funcionario
	WSDATA DaysRight		 	As Integer				        	    //Dias de Direito do funcionario
	WSDATA DataVacationProg  	As VacationProg     					//Programacao de ferias ja gravadas
	WSDATA EnterVacationProg 	As PeriodVacationProg				    //Dados da programacao de ferias para gravacao
	WSDATA HistVacationProg  	AS Boolean  			OPTIONAL        //Informa se é historico da programacao de férias
	WSDATA WFID					As String 				OPTIONAL		//ID do workflow da programacao de ferias
	WSDATA WFData 		 		As DataWorkFlow 		OPTIONAL  		//Dados do workflow
	WSDATA ApprovalHistory   	As HistAprov						   	//Dados do Histórico de aprovações da programação de férias
	WSDATA TypeCalcDay       	AS String								//1-Uteis 2-Corridos (RCM_TIPODI)
	WSDATA VacationDays			As Integer					          	//Dias de ferias solicitados pelo funcionario
	WSDATA StartDateVacation 	AS String								//Data inicial de ferias, observando dias Uteis e feriados
	WSDATA FinalDateVacation 	AS String								//Data final de ferias, observando dias Uteis e feriados
	WSDATA VacationProgEffect	AS VacProgEffect						//Lista de ferias programadas efetivas
	WSDATA ValidMessage			AS String		        OPTIONAL		//Mensagem de validação da Data Inicial do Período de Férias solicitado
	
	WSMETHOD GetDaysRight	  	DESCRIPTION STR0002 		//"Método que calcula os dias de direito do funcionario"
	WSMETHOD GetPerAbert	  	DESCRIPTION STR0003 		//"Método que retorna os periodos em aberto do funcionario"
	WSMETHOD GetVacationProg    DESCRIPTION STR0004 		//"Método que retorna as programacoes de férias do funcionario"
	WSMETHOD PutVacationProg    DESCRIPTION STR0005 		//"Método que grava a programacao de ferias do funcionário"
	WSMETHOD PutIDWFVacProg  	DESCRIPTION STR0012 		//"Método que atualiza o ID do workflow da programacao de ferias"
	WSMETHOD GetStatus			DESCRIPTION STR0013 		//"Método que retorna o status do funcionario"
	WSMETHOD GetHistAprov    	DESCRIPTION STR0023 		//"Método que retorna o Historico de Aprovações de uma determinada programacao de Férias"
	WSMETHOD GetTypeCalcDay		DESCRIPTION STR0024 		//"Método que retorna o Tipo de cálculo para contagem dos dias(úteis ou corridos) de férias"
	WSMETHOD GetCalendDate		DESCRIPTION STR0025 		//"Método que retorna uma data final, verificando o calendário de dias uteis e feriados"
	WSMETHOD GetVacProgEffect	DESCRIPTION STR0026 		//"Método que retorna as programacoes de ferias efetivadas"
	WSMETHOD GetValidInitDtVac	DESCRIPTION STR0031			//"Método que retona validacao da data inicial do período de gozo"
ENDWSSERVICE

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetDaysRight	 ³ Autor ³Tatiane V. Matias   ³Data ³14.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que calcula os dias de direito do funcionario 	      ³±±
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
WSMETHOD GetDaysRight WSRECEIVE  EmployeeFil, Registration WSSEND DaysRight WSSERVICE RHVacation
	Local lRet     := .T.
	Local nDiasDir := 0
	Local cFilFun  := ::EmployeeFil
	Local cMatFun  := ::Registration
	
	cFerAlias := "QSRF"
	
	BeginSql alias cFerAlias
		SELECT SUM(SRF.RF_DFERVAT) - SUM(SRF.RF_DFERANT) DIAS
		FROM %table:SRF% SRF
		WHERE SRF.RF_FILIAL  = %exp:cFilFun%  AND
		SRF.RF_MAT     = %exp:cMatFun%  AND
		SRF.RF_DFERVAT > 0 			  AND
		SRF.RF_DFERVAT > SRF.RF_DFERANT AND
		SRF.%notDel%
	EndSql
	
	nDiasDir := (cFerAlias)->DIAS
	(cFerAlias)->( DbCloseArea() )
	
	BeginSql alias cFerAlias
		SELECT SUM(SR8.R8_SDPAGAR) DIAS
		FROM %table:SR8% SR8
		INNER JOIN %table:RCM% RCM ON SR8.R8_TIPOAFA = RCM.RCM_TIPO
		WHERE SR8.R8_FILIAL  = %exp:cFilFun% AND
		SR8.R8_MAT     = %exp:cMatFun% AND
		RCM.RCM_TIPOAF = '4' AND
		SR8.R8_SDPAGAR > 0 AND
		SR8.%notDel% AND
		RCM.%notDel%
	EndSql
	
	nDiasDir -= (cFerAlias)->DIAS
	(cFerAlias)->( DbCloseArea() )
	
	BeginSql alias cFerAlias
		SELECT SUM(RGJ_DIAS) DIAS
		FROM %table:RGJ% RGJ
		WHERE
		RGJ.RGJ_FILIAL = %exp:cFilFun%  AND
		RGJ.RGJ_MAT    = %exp:cMatFun%  AND
		RGJ.RGJ_STATUS NOT IN ('4','5') AND
		RGJ.%notDel%
	EndSql
	
	nDiasDir -= (cFerAlias)->DIAS
	(cFerAlias)->( DbCloseArea() )
	
	::DaysRight := nDiasDir
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetPerAbert	 ³ Autor ³Tatiane V. Matias   ³Data ³17.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna os periodos em aberto do funcionario    	³±±
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
WSMETHOD GetPerAbert WSRECEIVE  EmployeeFil, Registration, TypeOfProg, TypeOfSolic WSSEND DataVacationProg WSSERVICE RHVacation
	Local lRet      := .T.
	Local lOK       := .F.
	Local lOK2		:= .F.
	Local cFilFun   := ::EmployeeFil
	Local cMatFun   := ::Registration
	Local nTab		:= 0
	Local nPer 		:= 0
	Local nPer2	    := 0
	Local aTable		:= {}
	Local aVRBS106 	:= {}
	Local cNRep		:= ""
	Local lFase4		 := (Alltrim(GetMv("MV_PAISLOC")) $ "ANG|ARG|COL|PTG|VEN|MEX|COS|DOM|EQU")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³O parametro MV_SIGAGFP = "2" identifica que eh GSP-Caixa.                    ³
	//³Se existir o parametro MV_VDFLOGO, eh porque eh GSP-MP (novo modelo de GSP).³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cFerOrd   := ""
	Local cFerComp	:= ""
	
	Local cGSP      := SuperGetMv("MV_SIGAGFP",,"1")
	If cGSP >= "2"
		cGSP := "3"
	EndIf
	
	Private aGetPerFerias := {}
	Private aPerFerias    := {}
	
	DEFAULT ::TypeOfProg  := 0
	DEFAULT ::TypeOfSolic := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Buscando RECNO                                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cFerAlias := "QSRA"
	BeginSql alias cFerAlias
		SELECT SRA.R_E_C_N_O_
		FROM %table:SRA% SRA
		WHERE SRA.RA_FILIAL  = %exp:cFilFun% AND
		SRA.RA_MAT	 = %exp:cMatFun% AND
		SRA.%notDel%
	EndSql
	cRecNo := (cFerAlias)->R_E_C_N_O_
	(cFerAlias)->( DbCloseArea() )
	
	//Ponteirando registro SRA
	dbSelectArea("SRA")
	dbSetOrder(1)
	SRA->(dbseek(cFilFun+cMatFun))
	
	// Variaveis criadas no GPEM030 antes da chamada ao m030fer
	Private aGets 			:= {}
	Private c__Roteiro 	    := "FER"
	Private lItemClVl   	:= SuperGetMv( "MV_ITMCLVL", .F., "2" ) == "1"
	Private nDFalt			:= 0
	Private nDAnte			:= 0
	
	If lFase4 .or. cGSP == "2" .or. cGSP == "3"
		Private P_FERPAC  := "S"
		
		If cGSP == "3"//GSP-MP
			Do Case
			Case ::TypeOfProg == 1 //Saldo de dias
				aPerVerbas   := {}
			Case ::TypeOfProg == 2 //Licenca Premio
				aPerVerbas   := {fGetCodFol("1332")}
			Case ::TypeOfProg == 3 //Ferias
				cFerOrd       := fGetCodFol("0072") //(Ferias ordinarias servidor e membro)
				cFerComp      := fGetCodFol("1335") //(Ferias compensatorias membro)
				aPerVerbas    := {cFerOrd, cFerComp}
			EndCase
		   //Busca dados dos dias de direito na tabela S106
            fCarrTab( @aTable, "S106",,,,,cFilFun )
            Aeval( aTable , { |x| cNRep:= x[10] ,;
            		 		IF( !Empty(cNRep), If( ascan(aVRBS106, { |y| y == cNRep})<= 0 ,;
            		 		 					aAdd(aVRBS106,cNRep),), ) } )
		EndIf
	EndIf
	
	If CarPerFer(cFilFun, cMatFun + space(TamSx3('RA_MAT')[1] - len(cMatFun)), @aPerFerias,cValToChar(::TypeOfProg),aVRBS106 )
		Self:DataVacationProg:ListOfPeriod := {}
		For nPer := 1 to Len(aPerFerias)
			
			lOK := .F.
			If cGSP == "3"
				//GSP-MP
				If ::TypeOfProg == 1
					//avalia Saldo de dias de folga
					If aPerFerias[nPer][3] > 0 .or. aPerFerias[nPer][36] > 0
						lOK := .T.
					EndIf
				Else
					//avalia ferias e licenca premio
					If aPerFerias[nPer][3] > 0
						lOK := .T.
					Else
						If aPerFerias[nPer][36] > 0
							//Nos casos onde não existe dias vencidos(DFERVAT), os dias de direito serão utilizados.
							//Isso acontece quando o periodo aquisito não esta completo.
							aPerFerias[nPer][3] := aPerFerias[nPer][36]
							lOK := .T.
						EndIf
					EndIf
				EndIf
			Else
				//Padrao
				If aPerFerias[nPer][3] > 0 .or. aPerFerias[nPer][4] > 0
					lOK := .T.
				EndIf
				//Funcionário acabou de ser contratado e ainda não tem Dias de ferias vencidas ou a vencer mas já tem o período aquisitivo
				If Len(aPerFerias) == 1
					If !Empty(aPerFerias[nPer][1]) .OR. !Empty(aPerFerias[nPer][2])
						lOK := .T.
					EndIf
				EndIf
			EndIf
			
			If lOK
				If cGSP == "3" //GSP-MP
					If ::TypeOfProg == 1 //avalia Saldo de dias de folga
						lOK2 := .T.
						If alltrim(aPerFerias[nPer][38]) <> ''
                          For nTab := 1 to Len(aTable)
                              If aTable[nTab][10] == alltrim(aPerFerias[nPer][38]) //Busca ID Base
                                 // controla saldo de dias
                                 // utiliza apenas quando a verba controlar o saldo
                                 If aTable[nTab][6] == 0
                                    lOK2 := .F.
                                 EndIf
                              EndIf   
                          Next nTab
                       EndIf

                       If !lOK2
                          loop 
                       EndIf
					Else
						//lançamento sem código de verba para avaliação de ferias
						If alltrim(aPerFerias[nPer][38]) == ''
							loop
						EndIf
						
                       //Avalia se o período possui dias para programacao de ferias
                       If (TypeOfProg == 2 .or. TypeOfProg == 3) .and. (TypeOfSolic == "P")
                           If aPerFerias[nPer][37] == aPerFerias[nPer][36] //Dias programados == Dias de Direito
                               If aPerFerias[nPer][3] <= 0 //Não possui saldo remanescente
                                  loop 
                               EndIf 
                           EndIf
                       EndIf 
					EndIf
				EndIf
				
				nPer2++
				aadd(Self:DataVacationProg:ListOfPeriod,WsClassNew('PeriodVacationProg'))
				Self:DataVacationProg:ListOfPeriod[nPer2]:EmployeeFilial		:= cFilFun
				Self:DataVacationProg:ListOfPeriod[nPer2]:Registration			:= cMatFun
				Self:DataVacationProg:ListOfPeriod[nPer2]:InitialDate			:= DtoC(aPerFerias[nPer][1])
				Self:DataVacationProg:ListOfPeriod[nPer2]:FinalDate			:= DtoC(aPerFerias[nPer][2])
				
				If cGSP == "3" //GSP-MP
					If ::TypeOfProg == 1 .or. ::TypeOfProg == 2 //avalia (1-Saldo de dias de folga) (2-Licenca Premio)
						Self:DataVacationProg:ListOfPeriod[nPer2]:Days			:= Max(aPerFerias[nPer][36], 0)
					Else
						Self:DataVacationProg:ListOfPeriod[nPer2]:Days			:= Max(aPerFerias[nPer][3], 0)
					Endif
					Self:DataVacationProg:ListOfPeriod[nPer2]:ProportionalDays	:= Max(aPerFerias[nPer][4], 0)
					Self:DataVacationProg:ListOfPeriod[nPer2]:ResidualDays		:= Max(aPerFerias[nPer][40], 0)
					Self:DataVacationProg:ListOfPeriod[nPer2]:ScheduleDays		:= Max(aPerFerias[nPer][37], 0)
					Self:DataVacationProg:ListOfPeriod[nPer2]:ScheduleDays2	:= 0
					Self:DataVacationProg:ListOfPeriod[nPer2]:BonusType		:= ''
					For nTab := 1 to Len(aTable)
	                       If aTable[nTab][10] == alltrim(aPerFerias[nPer][38]) //Busca ID Base
	                          ::DataVacationProg:ListOfPeriod[nPer2]:BonusType:= aTable[nTab][8]
	                          exit
	                       EndIf   
	                   Next nTab
					Self:DataVacationProg:ListOfPeriod[nPer2]:ThirteenthSalary := Max(aPerFerias[nPer][35], 0)
				Else
					nDFalt := aPerFerias[nPer][15]
					TabFaltas(@nDFalt)
					nDFalt := nDFalt + aPerFerias[nPer][14]
					Self:DataVacationProg:ListOfPeriod[nPer2]:Days				:= Max(aPerFerias[nPer][3] - nDFalt, 0)
					Self:DataVacationProg:ListOfPeriod[nPer2]:ProportionalDays	:= Max(aPerFerias[nPer][4] - nDFalt, 0)
					Self:DataVacationProg:ListOfPeriod[nPer2]:ResidualDays		:= 0
					Self:DataVacationProg:ListOfPeriod[nPer2]:ScheduleDays		:= Max(aPerFerias[nPer][33], 0)
					Self:DataVacationProg:ListOfPeriod[nPer2]:ScheduleDays2	:= Max(aPerFerias[nPer][34], 0)
					Self:DataVacationProg:ListOfPeriod[nPer2]:ThirteenthSalary := Max(aPerFerias[nPer][35], 0)
				EndIf
				
				If cGSP == "3" //GSP-MP
					Self:DataVacationProg:ListOfPeriod[nPer2]:IdBase              := alltrim(aPerFerias[nPer][38])
					//Buscando descricao da verba
                    dbSelectArea("SRV")
                    dbSetOrder(1)
                    If SRV->(dbseek(xFilial("SRV")+self:DataVacationProg:ListOfPeriod[nPer2]:IdBase))
                       ::DataVacationProg:ListOfPeriod[nPer2]:IdBaseDesc      := alltrim(SRV->RV_DESC)
                    Else
                       ::DataVacationProg:ListOfPeriod[nPer2]:IdBaseDesc      := STR0027 //"Desc. nao localizada"
                    EndIf
					
					If alltrim(aPerFerias[nPer][38]) == cFerOrd
						Self:DataVacationProg:ListOfPeriod[nPer2]:IdCode          := "0072"
					ElseIf alltrim(aPerFerias[nPer][38]) == cFerComp
						Self:DataVacationProg:ListOfPeriod[nPer2]:IdCode          := "1335"
					Else
						Self:DataVacationProg:ListOfPeriod[nPer2]:IdCode          := ""
					EndIf
				Else
					Self:DataVacationProg:ListOfPeriod[nPer2]:IdCode              := ""
					Self:DataVacationProg:ListOfPeriod[nPer2]:IdBase              := ""
					Self:DataVacationProg:ListOfPeriod[nPer2]:IdBaseDesc          := ""
				EndIf
			EndIf
		Next nPer
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetVacationProg³ Autor ³Tatiane V. Matias   ³Data ³17.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna as programacoes de férias do funcionario  	³±±
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
WSMETHOD GetVacationProg WSRECEIVE  EmployeeFil, Registration, HistVacationProg WSSEND DataVacationProg WSSERVICE RHVacation
	SELF:DataVacationProg:= fGetVacationProg(Self:EmployeeFil, Self:Registration, Self:HistVacationProg)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetVacationProg³ Autor ³Tatiane V. Matias   ³Data ³17.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna as programacoes de férias do funcionario  	³±±
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
Function fGetVacationProg(cEmployeeFil, cRegistration, lHistVacationProg)
	Local cFerAlias  				:= ""
	Local oDataVacationProg
	Local oPeriod
	
	DEFAULT lHistVacationProg 		:= .F.
	
	oDataVacationProg 				:= WsClassNew('VacationProg')
	oDataVacationProg:ListOfPeriod 	:= {}
	
	cFerAlias := GetNextAlias()
	
	If lHistVacationProg
		BEGINSQL ALIAS cFerAlias
			SELECT
			RGJ.*
			FROM
			%table:RGJ% RGJ
			WHERE
			RGJ.RGJ_FILIAL = %exp:cEmployeeFil%  AND
			RGJ.RGJ_MAT    = %exp:cRegistration%  AND
			RGJ.RGJ_STATUS IN ('4', '5') AND
			RGJ.%notDel%
		ENDSQL
	Else
		BEGINSQL ALIAS cFerAlias
			SELECT
			RGJ.*
			FROM
			%table:RGJ% RGJ
			WHERE
			RGJ.RGJ_FILIAL  = %exp:cEmployeeFil%  AND
			RGJ.RGJ_MAT     = %exp:cRegistration%  AND
			RGJ.RGJ_STATUS NOT IN ('4','5') AND
			RGJ.%notDel%
		ENDSQL
	EndIf
	
	While (cFerAlias)->( !Eof())
		
		oPeriod:= WsClassNew('PeriodVacationProg')
		oPeriod:EmployeeFilial	:= (cFerAlias)->RGJ_FILIAL
		oPeriod:Registration		:= (cFerAlias)->RGJ_MAT
		oPeriod:CodVacationProg	:= (cFerAlias)->RGJ_CODIGO
		oPeriod:InitialDate		:= If(Valtype((cFerAlias)->RGJ_DTINI) == "D",DTOC((cFerAlias)->RGJ_DTINI),DTOC(STOD((cFerAlias)->RGJ_DTINI)))
		oPeriod:FinalDate			:= If(Valtype((cFerAlias)->RGJ_DTFIM) == "D",DTOC((cFerAlias)->RGJ_DTFIM),DTOC(STOD((cFerAlias)->RGJ_DTFIM)))
		oPeriod:Days				:= (cFerAlias)->RGJ_DIAS
		oPeriod:IDStatusProg		:= (cFerAlias)->RGJ_STATUS
		oPeriod:StatusProg		:= GetStatusProg((cFerAlias)->RGJ_STATUS)
		oPeriod:InitialLevel		:= (cFerAlias)->RGJ_NIVELI
		oPeriod:AprovLevel		:= (cFerAlias)->RGJ_NIVELA
		oPeriod:FilInitial		:= (cFerAlias)->RGJ_FILINI
		oPeriod:MatInitial		:= (cFerAlias)->RGJ_MATINI
		oPeriod:AprovFil			:= (cFerAlias)->RGJ_FILAPR
		oPeriod:AprovMat			:= (cFerAlias)->RGJ_MATAPR
		oPeriod:WFID 				:= RGJ->RGJ_WFID
		
		aAdd(oDataVacationProg:ListOfPeriod, oPeriod)
		
		(cFerAlias)->( dbSkip() )
	EndDo
	
	(cFerAlias)->( DbCloseArea() )
Return oDataVacationProg

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetStatusProg  ³ Autor ³Tatiane V. Matias   ³Data ³17.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna as programacoes de férias do funcionario  	³±±
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
Static Function GetStatusProg(cStatus)
	Local cRet := ""
	Local aBoxStatus := {}
	Local nPos
	
	Sx3Box2Arr("RGJ_STATUS", @aBoxStatus)
	
	If (nPos := aScan(aBoxStatus, {|x| x[2] ==  cStatus} )) > 0
		cRet:= aBoxStatus[nPos,3]
	EndIf
Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PutVacationProg³ Autor ³Tatiane V. Matias   ³Data ³17.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que grava a programacao de ferias do funcionário  	    ³±±
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
WSMETHOD PutVacationProg WSRECEIVE  EnterVacationProg, DataVacationProg, TypeApprov, EmployeeFil, Registration WSSEND WsNull WSSERVICE RHVacation
	Local lRet     	:= .T.
	Local cFilFun  	:= ::EnterVacationProg:EmployeeFilial
	Local cMatFun   	:= ::EnterVacationProg:Registration
	Local cCodigo   	:= ::EnterVacationProg:CodVacationProg
	Local cFerAlias 	:= ""
	Local dDataIni  	:= CTOD(::EnterVacationProg:InitialDate)
	Local dDataFim  	:= CTOD(::EnterVacationProg:FinalDate)
	Local aProg		:= {}
	Local nCount    	:= 0
	Local cSeq     	:= ""
	Local cDesc    	:= ""
	
	// TypeApprov (Inclusão ("0"), Aprovar ("1"), Reprovar e aguardar sugestão de nova data ("2"),
	//             Sugestão de Nova Data("3"), Excluir ("4"), Reprovar sem sugestão de nova data ("5"))
	If ::TypeApprov == "0" .or. ::TypeApprov == "3"
		dbSelectArea("SRA")
		dbSetOrder(1)
		dbSeek(cFilFun + cMatFun)
		
		GpeCalend(cFilFun, cMatFun, NIL, NIL, NIL, dDataIni, @dDataFim, ::EnterVacationProg:Days, "F", NIL, .F.)
		If Empty(dDataFim)
			lRet := .F.
			SetSoapFault("PutVacationProg",STR0006)	 //"Problema encontrado no calculo da data final das ferias"
		EndIf
		
		If lRet
			aProg := ::DataVacationProg:ListOfPeriod
			If Len(aProg) > 0
				If aScan(aProg, {|x| ((dDataIni >= CTOD(x:InitialDate) .and. dDataIni <= CTOD(x:FinalDate)) .or.;
						(dDataFim >= CTOD(x:InitialDate) .and. dDataFim <= CTOD(x:FinalDate)) .or.;
						(dDataIni <= CTOD(x:InitialDate) .and. dDataFim >= CTOD(x:FinalDate))) .and.;
						x:IDStatusProg <> "0"}) > 0
					lRet := .F.
					SetSoapFault("PutVacationProg",STR0007)	 //"Nao pode existir lancamento diferente para a mesma data ou mesmo intervalo de afastamento"
				EndIf
			EndIf
		EndIf
		SRA->( DbCloseArea() )
	EndIf
	
	If lRet
		dbSelectArea("RGJ")
		dbSetOrder(1)
		
		If ::TypeApprov == "0"
			cFerAlias := "QRGJ"
			
			BeginSql alias cFerAlias
				
				SELECT MAX(RGJ_CODIGO) CODIGO
				FROM %table:RGJ% RGJ
				WHERE RGJ_FILIAL = %exp:cFilFun% AND
				RGJ_MAT    = %exp:cMatFun%    AND
				RGJ.%notDel%
				
			EndSql
			
			cCodigo := StrZero(val((cFerAlias)->CODIGO) + 1, TamSx3("RGJ_CODIGO")[1])
			
			(cFerAlias)->( DbCloseArea() )
			
			Reclock("RGJ",.T.)
			RGJ->RGJ_FILIAL  := cFilFun
			RGJ->RGJ_MAT     := cMatFun
			RGJ->RGJ_CODIGO  := cCodigo
		Else
			If RGJ->( dbSeek(cFilFun + cMatFun + cCodigo ) )
				Reclock("RGJ",.F.)
			Else
				RGJ->( DbCloseArea() )
				SetSoapFault("PutVacationProg",STR0010)	 //"Registro nao encontrado"
				Return(.F.)
			EndIf
		EndIf
		
		RGJ->RGJ_DTINI   		:= CTOD(::EnterVacationProg:InitialDate)
		RGJ->RGJ_DTFIM   		:= dDataFim
		RGJ->RGJ_DIAS    		:= ::EnterVacationProg:Days
		RGJ->RGJ_STATUS  		:= ::EnterVacationProg:IDStatusProg
		RGJ->RGJ_NIVELI  		:= ::EnterVacationProg:InitialLevel
		RGJ->RGJ_NIVELA	 	:= ::EnterVacationProg:AprovLevel
		RGJ->RGJ_FILINI	 	:= ::EnterVacationProg:FilInitial
		RGJ->RGJ_MATINI	 	:= ::EnterVacationProg:MatInitial
		RGJ->RGJ_FILAPR	 	:= ::EnterVacationProg:AprovFil
		RGJ->RGJ_MATAPR	 	:= ::EnterVacationProg:AprovMat
		RGJ->( MsUnlock() )
		
		If ::TypeApprov == "1" .or. ::TypeApprov == "3"
			dbSelectArea("WFA")
			WFA->( dbSetOrder(2) ) //WFA_FILIAL+WFA_IDENT
			If WFA->( dbSeek(xFilial("WFA")+RGJ->RGJ_IDENT) )
				Reclock("WFA",.F.)
				WFA->WFA_TIPO = '4'
				WFA->( MsUnlock() )
			EndIf
			WFA->( DbCloseArea() )
		EndIf
		
		RGJ->( DbCloseArea() )
		
		If ::TypeApprov <> "2"
			dbSelectArea("RGK")
			
			//Gravacao do histórico de aprovações
			cFerAlias := "QRGK"
			
			BeginSql alias cFerAlias
				
				SELECT MAX(RGK_SEQUEN) SEQ
				FROM %table:RGK% RGK
				WHERE RGK_FILIAL = %exp:cFilFun% AND
				RGK_MAT    = %exp:cMatFun% AND
				RGK_CODIGO = %exp:cCodigo% AND
				RGK.%notDel%
				
			EndSql
			
			cSeq := StrZero(val((cFerAlias)->SEQ) + 1, TamSx3("RGK_SEQUEN")[1])
			(cFerAlias)->( DbCloseArea() )
			
			Reclock("RGK",.T.)
			RGK->RGK_FILIAL  		:= cFilFun
			RGK->RGK_MAT     		:= cMatFun
			RGK->RGK_CODIGO  		:= cCodigo
			RGK->RGK_DATA    		:= dDataBase
			RGK->RGK_SEQUEN  		:= cSeq
			RGK->RGK_FILAPR	 	:=	::EmployeeFil
			RGK->RGK_MATAPR	 	:=	::Registration
			
			//"0"=Inclusão;"1"=Aprovação;"2"=Reprovação e aguardando sugestão de nova data;
				//"3"=Gravação da nova data;"4"=Exclusão;"5"=Reprovação sem sugestão de data
			If ::TypeApprov == "0"
				cDesc := OemToAnsi(STR0016 + ::EnterVacationProg:InitialDate +; 				  //"Solicitada a programação de férias no período de "
				STR0017 + DTOC(dDataFim) +;								      //" a "
				" (" + AllTrim(Str(::EnterVacationProg:Days)) + STR0018 + ")") //" dias"
			ElseIf ::TypeApprov == "1"
				cDesc := OemToAnsi(STR0019) //"Aprovada a solicitação de férias"
			ElseIf ::TypeApprov == "3"
				cDesc := OemToAnsi(STR0021 + ::EnterVacationProg:InitialDate +;                   //"Reprovada a solicitação de férias com sugestão de nova data: de "
				STR0017 + DTOC(dDataFim) +;								      //" a "
				" (" + AllTrim(Str(::EnterVacationProg:Days)) + STR0018 + ")") //" dias"
			ElseIf ::TypeApprov == "4"
				cDesc := OemToAnsi(STR0022) //"Solicitação de férias excluída"
			ElseIf ::TypeApprov == "5"
				cDesc := OemToAnsi(STR0020) //"Reprovada a solicitação de férias sem sugestão de data"
			Endif
			
			ApdMsMm(RGK->RGK_CODCON,,,cDesc,1,,,"RGK","RGK_CODCON")
			RGK->( MsUnlock() )
		EndIf
		
		//WorkFlow
		If ::TypeApprov <> "4" .and. ::TypeApprov <> "5"
			WFProgFerias(Val(::TypeApprov),, cFilFun, cMatFun, cCodigo)
		EndIf
	EndIf
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    PutWorkflowVacProg ³ Autor ³Tatiane V. Matias³Data ³28.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que atualiza o ID do workflow da programacao de ferias ³±±
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
WSMETHOD PutIDWFVacProg WSRECEIVE EmployeeFil, Registration, CodeVacationProg, WFData WSSEND WsNull WSSERVICE RHVacation
	Local lRet:= fPutIDWFVacProg(Self:EmployeeFil, Self:Registration, Self:CodeVacationProg, Self:WFData)
Return lRet

Function fPutIDWFVacProg(cEmployeeFil, cRegistration, cCodeVacationProg, oWFData)
	Local lRet   := .T.
	Local nField := 0
	
	dbSelectArea("RGJ")
	RGJ->( dbSetOrder(1) )
	
	If RGJ->( dbSeek(cEmployeeFil + cRegistration + cCodeVacationProg ) )
		For nField := 1 to Len(oWFData:ListOfWorkFlow)
			If RGJ->(FieldPos(oWFData:ListOfWorkFlow[nField]:FieldWF)) > 0
				If RecLock("RGJ", .F.)
					&(oWFData:ListOfWorkFlow[nField]:FieldWF) := oWFData:ListOfWorkFlow[nField]:ValueField
					MsUnLock()
				EndIf
			EndIf
		Next nField
	Else
		SetSoapFault("PutIDWFVacProg", STR0010)	 //"Registro nao encontrado"
		lRet := .F.
	EndIf
	
	RGJ->( DbCloseArea() )
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetStatus         ³ Autor ³Tatiane V. Matias³Data ³23.04.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna o status do funcionario					  ³±±
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
WSMETHOD GetStatus WSRECEIVE EmployeeFil, Registration WSSEND StatusEmployee WSSERVICE RHVacation
	Local lRet   := .T.
	
	dbSelectArea("RGJ")
	RGJ->( dbSetOrder(1) )
	
	If RGJ->( dbSeek(::EmployeeFil + ::Registration ) )
		While RGJ->( !Eof() ) .and. (RGJ->RGJ_FILIAL + RGJ->RGJ_MAT == ::EmployeeFil + ::Registration)
			If RGJ->RGJ_STATUS <> "4" .and. RGJ->RGJ_STATUS <> "5"
				::StatusEmployee := OemToAnsi(STR0014) //"01-Ferias Prog."
				exit
			Else
				::StatusEmployee := OemToAnsi(STR0015) //"02-Sem Prog."
			EndIf
			RGJ->( dbSkip() )
		EndDo
	Else
		::StatusEmployee := OemToAnsi(STR0015) //"02-Sem Prog."
	EndIf
	
	RGJ->( DbCloseArea() )
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetHistAprov   ³ Autor ³Tatiane V. Matias   ³Data ³17.03.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna as programacoes de férias do funcionario   ³±±
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
WSMETHOD GetHistAprov WSRECEIVE  EmployeeFil, Registration, CodeVacationProg WSSEND ApprovalHistory WSSERVICE RHVacation
	Local lRet      	:= .T.
	Local cFilFun    	:= ::EmployeeFil
	Local cMatFun    	:= ::Registration
	Local cCodigo    	:= ::CodeVacationProg
	Local cHistAlias 	:= ""
	Local nReg			:= 0
	Local cEmpSM0		:= SM0->M0_CODIGO
	
	DEFAULT ::HistVacationProg := .F.
	
	::ApprovalHistory := WsClassNew('HistAprov')
	::ApprovalHistory:ListOfHistAprov := {}
	
	cHistAlias := "QRGJ"
	
	BeginSql alias cHistAlias
		
		SELECT RGJ.RGJ_DTINI, RGJ.RGJ_DTFIM
		FROM %table:RGJ% RGJ
		WHERE RGJ.RGJ_FILIAL = %exp:cFilFun%  AND
		RGJ.RGJ_MAT    = %exp:cMatFun%  AND
		RGJ.RGJ_CODIGO = %exp:cCodigo%  AND
		RGJ.%notDel%
		
	EndSql
	
	If (cHistAlias)->( Eof())
		Return(.F.)
	EndIf
	
	::ApprovalHistory:InitialDate := If(Valtype((cHistAlias)->RGJ_DTINI) == "D",DTOC((cHistAlias)->RGJ_DTINI),DTOC(STOD((cHistAlias)->RGJ_DTINI)))
	::ApprovalHistory:FinalDate   := If(Valtype((cHistAlias)->RGJ_DTFIM) == "D",DTOC((cHistAlias)->RGJ_DTFIM),DTOC(STOD((cHistAlias)->RGJ_DTFIM)))
	(cHistAlias)->( DbCloseArea() )
	
	cHistAlias := "QRGK"
	
	BeginSql alias cHistAlias
		
		SELECT RGK.RGK_DATA, RGK_CODCON, SRA.RA_NOME, RD0.RD0_NOME
		FROM %table:RGK% RGK
		LEFT JOIN %table:SRA% SRA
		ON RGK.RGK_FILAPR  = SRA.RA_FILIAL  AND
		RGK.RGK_MATAPR  = SRA.RA_MAT     AND
		SRA.%notDel%
		LEFT JOIN %table:RDZ% RDZ
		ON RDZ.RDZ_CODENT = RGK.RGK_FILAPR + RGK.RGK_MATAPR AND
		RDZ.RDZ_FILIAL = %xfilial:RDZ%    AND
		RDZ.RDZ_EMPENT = %exp:cEmpSM0%    AND
		RDZ.%notdel%
		LEFT JOIN %table:RD0% RD0
		ON RD0.RD0_CODIGO = RDZ.RDZ_CODRD0   AND
		RD0.RD0_FILIAL = %xfilial:RD0%    AND
		RD0.%notdel%
		WHERE RGK.RGK_FILIAL = %exp:cFilFun%  AND
		RGK.RGK_MAT    = %exp:cMatFun%  AND
		RGK.RGK_CODIGO = %exp:cCodigo%  AND
		RGK.%notDel%
		ORDER BY RGK_FILIAL, RGK_MAT, RGK_CODIGO, RGK_SEQUEN
		
	EndSql
	
	While (cHistAlias)->(!Eof())
		nReg++
		aadd(::ApprovalHistory:ListOfHistAprov,WsClassNew('DataHistAprov'))
		::ApprovalHistory:ListOfHistAprov[nReg]:AprovDate  := If(Valtype((cHistAlias)->RGK_DATA) == "D",DTOC((cHistAlias)->RGK_DATA),DTOC(STOD((cHistAlias)->RGK_DATA)))
		::ApprovalHistory:ListOfHistAprov[nReg]:AprovName  := substr(if(!Empty((cHistAlias)->RD0_NOME),(cHistAlias)->RD0_NOME,If(!Empty((cHistAlias)->RA_NOME),(cHistAlias)->RA_NOME,"")),1,28)
		::ApprovalHistory:ListOfHistAprov[nReg]:ContHist   := Alltrim(ApdMsMm((cHistAlias)->RGK_CODCON))
		(cHistAlias)->( dbSkip() )
	EndDo
	
	(cHistAlias)->( DbCloseArea() )
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetTypeCalcDay ³ Autor ³Marcelo M Faria	  ³Data ³01.02.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna tipo de calculo dias de ferias			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetTypeCalcDay WSRECEIVE  EmployeeFil WSSEND TypeCalcDay WSSERVICE RHVacation
	Local lRet     := .T.
	Local cCodFol  := 0
	Local cFilFun  := ::EmployeeFil
	
	::TypeCalcDay := "2"
	
	// Verifica se o pais e Angola ou Portugal para identificar se o
	// calculo da data final sera considerado dias uteis ou corridos
	If (cPaisLoc == "ANG")
		cCodFol := FGetCodFol("786")
	Else
		cCodFol := FGetCodFol("072")
	EndIF
	
	cFerAlias := "QRCM"
	BeginSql alias cFerAlias
		SELECT RCM_TIPODI
		FROM %table:RCM% RCM
		WHERE RCM.RCM_FILIAL = %exp:cFilFun% AND
		RCM.RCM_PD		 = %exp:cCodFol% AND
		RCM.%notDel%
	EndSql
	If (cFerAlias)->( !Eof())
		::TypeCalcDay := (cFerAlias)->RCM_TIPODI
	Endif
	(cFerAlias)->( DbCloseArea() )
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetCalendDate	 ³ Autor ³Marcelo M Faria	  ³Data ³01.02.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Método que retorna data final de ferias			 			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetCalendDate WSRECEIVE  StartDateVacation, VacationDays WSSEND FinalDateVacation WSSERVICE RHVacation
	Local lRet     := .T.
	
	Local nQtdeDias := ::VacationDays
	Local dDataIni  := CTOD(::StartDateVacation)
	Local dDataFim
	
	GpeCalend(,,,,,dDataIni, @dDataFim, nQtdeDias,"F",,.F.,,.F.)
	::FinalDateVacation := DToc(dDataFim)
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetVacProgEffect ³ Autor ³Marcelo Faria	  ³Data ³21.05.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo que retorna as ferias prog. efetivadas do funcionario.	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
WSMETHOD GetVacProgEffect WSRECEIVE  EmployeeFil, Registration WSSEND VacationProgEffect WSSERVICE RHVacation
	Local cQryAlias		:= ""
	Local cQry2Alias	:= ""
	Local lRet      	:= .T.
	Local nReg			:= 0
	Local aPD			:= {}
	Local aTmp			:= {}
	Local cFilFun   	:= ::EmployeeFil
	Local cMatFun   	:= ::Registration
	Local lNovo			:= .T.
	Local cTmpRCM		:= GetNextAlias()
	Local cTipoAfa		:= "001"
	
	::VacationProgEffect := WsClassNew('VacProgEffect')
	::VacationProgEffect:ListOfVacProgEffect := {}
	
	BeginSql alias cTmpRCM
		SELECT RCM_TIPO
		FROM %table:RCM% RCM
		WHERE RCM.RCM_FILIAL  = %exp:xFilial("RCM",cFilFun)% AND
		RCM.RCM_TIPOAF = '4' AND
		RCM.%notDel%
	EndSql
	If !(cTmpRCM)->(Eof())
		cTipoAfa := (cTmpRCM)->RCM_TIPO
	EndIf
	(cTmpRCM)->(dbCloseArea())
	
	//Verifica se existe lanctos em SRF(Programacao de ferias)
	If TcCanOpen( RetSqlName("SRF") )
		If SRF->(FieldPos("RF_DATABAS")) > 0
			cQryAlias := "QSRF"
			BeginSql alias cQryAlias
				SELECT *
				FROM %table:SRF% SRF
				WHERE	SRF.RF_FILIAL	= %exp:cFilFun% AND
				SRF.RF_MAT 		= %exp:cMatFun% AND
				SRF.%notDel%
			EndSql
			
			While (cQryAlias)->( !Eof() ) .and. ((cQryAlias)->(RF_FILIAL+RF_MAT) == cFilFun+cMatFun)
				If (cQryAlias)->RF_STATUS != '1' .and. !Empty((cQryAlias)->RF_STATUS)
					(cQryAlias)->( dbSkip() )
					loop
				EndIf
				
				If !Empty((cQryAlias)->RF_DATAINI)
					lNovo := .F.
					nReg++
					aadd(::VacationProgEffect:ListOfVacProgEffect,WsClassNew('DataVacProgEffect'))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate 		:= If(Valtype((cQryAlias)->RF_DATABAS) == "D",DTOC((cQryAlias)->RF_DATABAS),DTOC(STOD((cQryAlias)->RF_DATABAS)))
					If SRF->(FieldPos("RF_DATAFIM")) > 0
						::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate	:= If(Valtype((cQryAlias)->RF_DATAFIM) == "D",DTOC((cQryAlias)->RF_DATAFIM),DTOC(STOD((cQryAlias)->RF_DATAFIM)))
						::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType	:= "SRF01"
					Else
						::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate	:= ""
						::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType	:= "SRF02"
					EndIf
					::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 	:= (cQryAlias)->RF_DFERVAT
					::VacationProgEffect:ListOfVacProgEffect[nReg]:OpenDays			:= 0
					::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate		:= If(Valtype((cQryAlias)->RF_DATAINI) == "D",DTOC((cQryAlias)->RF_DATAINI),DTOC(STOD((cQryAlias)->RF_DATAINI)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationDays		:= If((cQryAlias)->RF_DFEPRO1 ==(cQryAlias)->RF_DFERANT,0,(cQryAlias)->RF_DFEPRO1)
					::VacationProgEffect:ListOfVacProgEffect[nReg]:AllowDays		:= (cQryAlias)->RF_DABPRO1
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= ""
					
					dbSelectArea("SR8")
					SR8->(dbSetOrder(6))//	R8_FILIAL, R8_MAT, R8_DATAINI, R8_TIPOAFA,
					If SR8->(dbSeek(cFilFun+cMatFun+(If(Valtype((cQryAlias)->RF_DATAINI) == "D",DTOs((cQryAlias)->RF_DATAINI),(cQryAlias)->RF_DATAINI))+cTipoAfa))
						If SR8->R8_DURACAO == (cQryAlias)->RF_DFEPRO1
							::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= "PAGO"
						EndIf
					EndIf
				EndIf
				
				If !Empty((cQryAlias)->RF_DATINI2)
					nReg++
					aadd(::VacationProgEffect:ListOfVacProgEffect,WsClassNew('DataVacProgEffect'))
					If lNovo
						::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate		:= If(Valtype((cQryAlias)->RF_DATABAS) == "D",DTOC((cQryAlias)->RF_DATABAS),DTOC(STOD((cQryAlias)->RF_DATABAS)))
						::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate		:= If(Valtype((cQryAlias)->RF_DATAFIM) == "D",DTOC((cQryAlias)->RF_DATAFIM),DTOC(STOD((cQryAlias)->RF_DATAFIM)))
						::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 	:= (cQryAlias)->RF_DFERVAT
					Else
						::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate		:= ""
						::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate		:= ""
						::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 	:= 0
					EndIf
					::VacationProgEffect:ListOfVacProgEffect[nReg]:OpenDays			:= 0
					::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate		:= If(Valtype((cQryAlias)->RF_DATINI2) == "D",DTOC((cQryAlias)->RF_DATINI2),DTOC(STOD((cQryAlias)->RF_DATINI2)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationDays		:= (cQryAlias)->RF_DFEPRO2
					::VacationProgEffect:ListOfVacProgEffect[nReg]:AllowDays		:= (cQryAlias)->RF_DABPRO2
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= ""
					::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType		:= "SRF03"
					lNovo := .F.
					dbSelectArea("SR8")
					SR8->(dbSetOrder(6))//	R8_FILIAL, R8_MAT, R8_DATAINI, R8_TIPOAFA,
					If SR8->(dbSeek(cFilFun+cMatFun+(If(Valtype((cQryAlias)->RF_DATINI2) == "D",DTOs((cQryAlias)->RF_DATINI2),(cQryAlias)->RF_DATINI2))+cTipoAfa))
						If SR8->R8_DURACAO == (cQryAlias)->RF_DFEPRO2
							::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= "PAGO"
						EndIf
					EndIf
				EndIf
				
				If !Empty((cQryAlias)->RF_DATINI3)
					nReg++
					aadd(::VacationProgEffect:ListOfVacProgEffect,WsClassNew('DataVacProgEffect'))
					If lNovo
						::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate		:= If(Valtype((cQryAlias)->RF_DATABAS) == "D",DTOC((cQryAlias)->RF_DATABAS),DTOC(STOD((cQryAlias)->RF_DATABAS)))
						::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate		:= If(Valtype((cQryAlias)->RF_DATAFIM) == "D",DTOC((cQryAlias)->RF_DATAFIM),DTOC(STOD((cQryAlias)->RF_DATAFIM)))
						::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 	:= (cQryAlias)->RF_DFERVAT
					Else
						::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate		:= ""
						::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate 		:= ""
						::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays 		:= 0
					EndIf
					::VacationProgEffect:ListOfVacProgEffect[nReg]:OpenDays			:= 0
					::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate		:= If(Valtype((cQryAlias)->RF_DATINI3) == "D",DTOC((cQryAlias)->RF_DATINI3),DTOC(STOD((cQryAlias)->RF_DATINI3)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationDays		:= (cQryAlias)->RF_DFEPRO3
					::VacationProgEffect:ListOfVacProgEffect[nReg]:AllowDays		:= (cQryAlias)->RF_DABPRO3
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= ""
					::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType		:= "SRF03"
					dbSelectArea("SR8")
					SR8->(dbSetOrder(6))//	R8_FILIAL, R8_MAT, R8_DATAINI, R8_TIPOAFA,
					If SR8->(dbSeek(cFilFun+cMatFun+(If(Valtype((cQryAlias)->RF_DATINI3) == "D",DTOs((cQryAlias)->RF_DATINI3),(cQryAlias)->RF_DATINI3))+cTipoAfa))
						If SR8->R8_DURACAO == (cQryAlias)->RF_DFEPRO3
							::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= "PAGO"
						EndIf
					EndIf
				EndIf
				
				lNovo := .T.
				(cQryAlias)->( dbSkip() )
			EndDo
			
			(cQryAlias)->( DbCloseArea() )
		EndIf
	EndIf
	
	//Verifica se existe lanctos em SRH(Ferias), caso ainda nao existam lanctos.
	If len(::VacationProgEffect:ListOfVacProgEffect) == 0 .and. TcCanOpen( RetSqlName("SRH") )
		If SRH->(FieldPos("RH_DATAINI")) > 0
			cQryAlias := "QSRH"
			cQry2Alias:= "QRCH"
			
			BeginSql alias cQryAlias
				SELECT *
				FROM  %table:SRH% SRH
				WHERE	SRH.RH_FILIAL	= %exp:cFilFun% AND
				SRH.RH_MAT 		= %exp:cMatFun% AND
				SRH.%notDel%
			EndSql
			
			While (cQryAlias)->( !Eof() )
				If SRH->(FieldPos("RH_STATUS")) > 0
					If (cQryAlias)->RH_STATUS != '1' .and. !Empty((cQryAlias)->RH_STATUS)
						(cQryAlias)->( dbSkip() )
						loop
					EndIf
				EndIf
				
				//Verifica Periodo em aberto RCH
				BeginSql alias cQry2Alias
					SELECT *
					FROM  %table:RCH% RCH
					WHERE RCH_FILIAL 	 = %xfilial:RCH% AND
					RCH.RCH_PER 	 = %exp:(cQryAlias)->RH_PERIODO% AND
					RCH.RCH_NUMPAG  >= %exp:(cQryAlias)->RH_NPAGTO% AND
					(RCH.RCH_ROTEIR  = '   ' OR RCH.RCH_ROTEIR = %exp:(cQryAlias)->RH_ROTEIR%) AND
					RCH.RCH_PROCES  = %exp:(cQryAlias)->RH_PROCES% AND
					RCH.%notDel%
				EndSql
				
				If (cQry2Alias)->( !Eof() ) .and. Empty((cQry2Alias)->RCH_DTFECH)
					nReg++
					aadd(::VacationProgEffect:ListOfVacProgEffect,WsClassNew('DataVacProgEffect'))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate 		:= If(Valtype((cQryAlias)->RH_DATABAS) == "D",DTOC((cQryAlias)->RH_DATABAS),DTOC(STOD((cQryAlias)->RH_DATABAS)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate 		:= If(Valtype((cQryAlias)->RH_DBASEAT) == "D",DTOC((cQryAlias)->RH_DBASEAT),DTOC(STOD((cQryAlias)->RH_DBASEAT)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 	:= (cQryAlias)->RH_DFERVEN
					::VacationProgEffect:ListOfVacProgEffect[nReg]:OpenDays			:= 0
					::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate		:= If(Valtype((cQryAlias)->RH_DATAINI) == "D",DTOC((cQryAlias)->RH_DATAINI),DTOC(STOD((cQryAlias)->RH_DATAINI)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationDays		:= (cQryAlias)->RH_DFERIAS
					::VacationProgEffect:ListOfVacProgEffect[nReg]:AllowDays		:= (cQryAlias)->RH_DABONPE
					::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType		:= "SRH"
					If SRH->(FieldPos("RH_TIPO")) > 0
						::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType	:= (cQryAlias)->RH_TIPO
					Else
						::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType	:= ""
					EndIf
				EndIf
				(cQry2Alias)->( DbCloseArea() )
				(cQryAlias)->( dbSkip() )
			EndDo
			(cQryAlias)->( DbCloseArea() )
		EndIf
	EndIf
	
	//Verifica se existe lanctos em RHI/RHJ(Ferias), caso ainda nao existam lanctos.
	If Len(::VacationProgEffect:ListOfVacProgEffect) == 0 .and. TcCanOpen( RetSqlName("RHI") )
		If RHI->(FieldPos("RHI_DTINI")) > 0
			cQryAlias := "QRHI"
			cQry2Alias:= "QRHJ"
			
			//Cabecalho de ferias
			BeginSql alias cQryAlias
				SELECT *
				FROM  %table:RHI% RHI
				WHERE	RHI.RHI_FILIAL	= %exp:cFilFun% 					AND
				RHI.RHI_MAT		= %exp:cMatFun% 					AND
				(RHI.RHI_STATUS	= '1' OR RHI.RHI_STATUS = '2')	AND
				RHI.%notDel%
			EndSql
			
			While (cQryAlias)->( !Eof() )
				//Verifica Lanctos em RHJ
				BeginSql alias cQry2Alias
					SELECT *
					FROM  %table:RHJ% RHJ
					WHERE RHJ.RHJ_FILIAL	= %exp:(cQryAlias)->RHI_FILIAL%		AND
					RHJ.RHJ_MAT 		= %exp:(cQryAlias)->RHI_MAT% 		AND
					RHJ.RHJ_DTINI	= %exp:(cQryAlias)->RHI_DTINI%		AND
					RHJ.%notDel%
				EndSql
				
				While (cQry2Alias)->( !Eof() )
					nReg++
					aadd(::VacationProgEffect:ListOfVacProgEffect,WsClassNew('DataVacProgEffect'))
					If nReg == 1
						::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate	:= If(Valtype((cQryAlias)->RHI_DTINI) == "D",DTOC((cQryAlias)->RHI_DTINI),DTOC(STOD((cQryAlias)->RHI_DTINI)))
					Else
						::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate	:= ""
					EndIf
					::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate 		:= If(Valtype((cQry2Alias)->RHJ_DTBASE) == "D",DTOC((cQry2Alias)->RHJ_DTBASE),DTOC(STOD((cQry2Alias)->RHJ_DTBASE)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate	 		:= If(Valtype((cQry2Alias)->RHJ_DTFIM)  == "D",DTOC((cQry2Alias)->RHJ_DTFIM),DTOC(STOD((cQry2Alias)->RHJ_DTFIM)))
					::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 		:= (cQry2Alias)->RHJ_DFERVA
					::VacationProgEffect:ListOfVacProgEffect[nReg]:OpenDays			:= (cQry2Alias)->RHJ_DFERAA
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationDays		:= (cQry2Alias)->RHJ_DIASPG
					::VacationProgEffect:ListOfVacProgEffect[nReg]:AllowDays			:= 0
					::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType		:= "RHI"
					::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= ""
					(cQry2Alias)->( dbSkip() )
				EndDo
				(cQry2Alias)->( DbCloseArea() )
				(cQryAlias)->( dbSkip() )
			EndDo
			(cQryAlias)->( DbCloseArea() )
		EndIf
	EndIf
	
	//Verifica se existe lanctos em SR8(Afastametnos), caso ainda nao existam lanctos.
	If len(::VacationProgEffect:ListOfVacProgEffect) == 0 .and. TcCanOpen( RetSqlName("SR8") )
		cQryAlias := "QSR8"
		cQry2Alias:= "QSRF"
		
		//Busca Afastamentos
		If SR8->(FieldPos("R8_TIPOAFA")) > 0
			BeginSql alias cQryAlias
				SELECT *
				FROM  %table:SR8% SR8
				INNER JOIN %table:RCM% RCM ON SR8.R8_TIPOAFA = RCM.RCM_TIPO
				WHERE	SR8.R8_FILIAL		= %exp:cFilFun%	AND
				SR8.R8_MAT			= %exp:cMatFun%	AND
				RCM.RCM_TIPOAF	= '4'				AND
				SR8.R8_SDPAGAR 	> 0					AND
				SR8.%notDel%						AND
				RCM.%notDel%
			EndSql
			
			While (cQryAlias)->( !Eof() )
				nReg++
				aadd(::VacationProgEffect:ListOfVacProgEffect,WsClassNew('DataVacProgEffect'))
				::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate		:= If(Valtype((cQryAlias)->R8_DATAINI) == "D",DTOC((cQryAlias)->R8_DATAINI),DTOC(STOD((cQryAlias)->R8_DATAINI)))
				::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate 		:= ""
				::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate	 	:= ""
				::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 	:= 0
				::VacationProgEffect:ListOfVacProgEffect[nReg]:OpenDays			:= 0
				::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationDays		:= (cQryAlias)->R8_DURACAO
				::VacationProgEffect:ListOfVacProgEffect[nReg]:AllowDays		:= 0
				::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType		:= "SR8"
				::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= ""
				
				If aScan(aPD, {|x|x==(cQryAlias)->R8_PD})==0
					aAdd(aPD, (cQryAlias)->R8_PD)
				EndIf
				
				(cQryAlias)->( dbSkip() )
			EndDo
			
			(cQryAlias)->( DbCloseArea() )
		EndIf
		
		//Busca Periodos aquisitivos
		BeginSql alias cQry2Alias
			SELECT *
			FROM  %table:SRF% SRF
			WHERE SRF.RF_FILIAL	= %exp:cFilFun%	 	AND
			SRF.RF_MAT 	= %exp:cMatFun% 	AND
			SRF.RF_DFERVAT 	> 0				AND
			SRF.%notDel%
			ORDER BY SRF.RF_DATABAS
		EndSql
		
		While (cQry2Alias)->( !Eof() )
			If SRF->(FieldPos("RF_STATUS")) > 0
				If (cQry2Alias)->RF_STATUS <> '2' // Desconsidera periodos vencidos
					(cQry2Alias)->( dbSkip() )
					loop
				EndIf
			EndIf
			
			If SRF->(FieldPos("RF_DFERANT")) > 0 .and. SRF->(FieldPos("RF_DIASDIR")) > 0
				If (cQry2Alias)->RF_DFERANT	>= (cQry2Alias)->RF_DIASDIR // Foi pago todos os dias
					(cQry2Alias)->( dbSkip() )
					loop
				EndIf
			EndIf
			
			If aScan(aPD, {|x|x==(cQry2Alias)->RF_PD})>0
				nReg++
				aadd(::VacationProgEffect:ListOfVacProgEffect,WsClassNew('DataVacProgEffect'))
				::VacationProgEffect:ListOfVacProgEffect[nReg]:StartVacDate		:= ""
				::VacationProgEffect:ListOfVacProgEffect[nReg]:InitialDate 		:= If(Valtype((cQry2Alias)->RF_DATABAS) == "D",DTOC((cQry2Alias)->RF_DATABAS),DTOC(STOD((cQry2Alias)->RF_DATABAS)))
				::VacationProgEffect:ListOfVacProgEffect[nReg]:FinalDate	 	:= If(Valtype((cQry2Alias)->RF_DATAFIM) == "D",DTOC((cQry2Alias)->RF_DATAFIM),DTOC(STOD((cQry2Alias)->RF_DATAFIM)))
				::VacationProgEffect:ListOfVacProgEffect[nReg]:CloseDays	 	:= (cQry2Alias)->RF_DFERVAT
				::VacationProgEffect:ListOfVacProgEffect[nReg]:OpenDays			:= 0
				::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationDays		:= 0
				::VacationProgEffect:ListOfVacProgEffect[nReg]:AllowDays		:= 0
				::VacationProgEffect:ListOfVacProgEffect[nReg]:RegisterType		:= "RF/R8"
				::VacationProgEffect:ListOfVacProgEffect[nReg]:VacationType		:= ""
			EndIf
			(cQry2Alias)->( dbSkip() )
		EndDo
		(cQry2Alias)->( DbCloseArea() )
	EndIf
	
Return(lRet)

Function fCarPerFer(cFilFer, cMatFer, aPerFerias)
Return CarPerFer(cFilFer, cMatFer, aPerFerias)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CarPerFer        ³ Autor ³Equipe RH         ³Data ³12.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Carrega periodos da tabela de programacao de ferias.         	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CarPerFer(cFilFer, cMatFer, aPerFerias, cTpPrg,aVRBS106)
	Local lRetorno := .F.
	Local nContPD	:= 1
	Local aTmp	:= {}
	Local aVerba	:= {}
	
	
	Default cTpPrg:= ""
	Default aVRBS106:= {}
	
	If cTpPrg == '1'
		aVerba:= aClone(aVRBS106)
	ElseIf !Empty(cTpPrg) .AND. cTpPrg == '2' 
		aAdd(aVerba,fGetCodFol("1332"))
	Else
		aAdd(aVerba,fGetCodFol("0072"))
	EndIf
	
	dbSelectArea("SRF")
	SRF->(dbSetOrder(2))
	For nContPD:= 1 to Len(aVerba)
		cSeekSRF 	:= cFilFer + cMatFer + aVerba[nContPD]
		SRF->(DBGOTOP())
		If SRF->(dbSeek(cSeekSRF))
			While SRF->(!Eof() .And. SRF->(RF_FILIAL+RF_MAT+RF_PD) == cSeekSRF )
				If Empty(SRF->RF_STATUS) .Or. SRF->RF_STATUS == "1"
					aAdd(aTmp,{	SRF->RF_DATABAS	,;															// 01 - Inicio Database de Ferias
								If(Empty(SRF->RF_DATAFIM),fCalcFimAq(SRF->RF_DATABAS),SRF->RF_DATAFIM),;	// 02 - Final Database de Ferias
								SRF->RF_DFERVAT	,;															// 03 - Dias de ferias vencidas
								SRF->RF_DFERAAT	,;															// 04 - Dias de ferias a vencer
								0.00			,;															// 05 - Dias totais de afastamento por periodo
								SRF->RF_OBSERVA	,;															// 06 - Descricao do tipo de afastamento do periodo
								CtoD("")		,;															// 07 - Data de original de termino do p.aquisitivo quando houver prorrogacao do mesmo RWX
								If(Empty(SRF->RF_STATUS),"1",SRF->RF_STATUS),;								// 08 - Status do periodo de ferias:  1-Ativo (Vencidos/A vencer)/2-Prescrito (Perdido)/3-Pago
								CtoD("")		,;															// 09 - Data de Inicio do Proximo periodo caso seja um periodo perdido.
								0				,;															// 10 - Quantidade dias de deducao para o direito apurado no periodo
								SRF->RF_DVENPEN ,;     														// 11 - Dias Vencidos Pendentes
								SRF->RF_IVENPEN ,;     														// 12 - Data Inicia Vencido Pendente
								SRF->RF_FVENPEN ,;															// 13 - Data Inicia Vencido Pendente
								SRF->RF_DFERANT ,;     														// 14 - Dias de Ferias Antecipadas
								SRF->RF_DFALVAT ,;     														// 15 - Dias de Faltas Vencidas
								SRF->RF_DFALAAT ,; 				    										// 16 - Dias de Faltas a Vencer
								If(cPaisLoc$"VEN|EQU",SRF->RF_DBONVAT,NIL),;				 				// 17 - Dias de bono vencido
								If(cPaisLoc$"VEN|EQU",SRF->RF_DBONAAT,NIL),; 								// 18 - Dias de bono a Vencer
								0				,;															// 19 - Total de dias de ferias
								0				,;															// 20 - Total de dias de bonificacao
								0				,;															// 21 - Dias de Faltas vencidas bonificacao
								0				,;															// 22 - Dias de ¦Faltas a Vencer bonificacao
								0				,;															// 23 - Dias de ausencia convertidos em ferias
								0				,;      													// 24 - Total de Dias de Ferias do Periodo
								SRF->RF_DIASANT ,;					      									// 25 - Dias Gozados Vencidos
								SRF->RF_DIASANT	,;	    													// 26 - Dias Gozados a Vencer
								0               ,;      													// 27 - Dias Subsid. Vencidos
								0               ,;   														// 28 - Dias Subsid. a Vencer
								0				,; 															// 29 - Dias de Pagto. Minimo na Adm/Dem (cpo. RF_PAGOFER desabilitado 08/2012)
								SRF->( RECNO() ),;															// 30 - Recno do aquivo
								Iif(Type("SRF->RF_FERPAGA")<>"U",  SRF->RF_FERPAGA, 0) ,;					// 31 - Dias pagos em R$ na folha
								IIF(Empty(SRF->RF_DATAATU),0,SRF->RF_DATAATU)	,;															// 32
								IIF(Empty(SRF->RF_DFEPRO1),0,SRF->RF_DFEPRO1)  ,;															// 33 - Dias da 1a programacao de ferias
								IIF(Empty(SRF->RF_DFEPRO2),0,SRF->RF_DFEPRO2) ,;															// 34 - Dias da 2a programacao de ferias
								IIF(Empty(SRF->RF_PAR13AT),0,SRF->RF_PAR13AT) ,;															// 35 - Primeira parcela do decimo terceiro salario	
								IIF(Empty(SRF->RF_DIASDIR),0,SRF->RF_DIASDIR),;														// 36 - Dias de Direito
								Iif(Type("SRF->RF_DIASPRG")<>"U",  SRF->RF_DIASPRG, 0),;												// 37 - Dias Programados
								Iif(Type("SRF->RF_PD")<>"U",  SRF->RF_PD, 0),;												// 38 - CODIGO DA VERBA
								PosSrv(SRF->RF_PD,SRA->RA_FILIAL,"RV_CODFOL"),; //39 CODIGO DA VERBA
								Iif(Type("SRF->RF_DIREMAN")<>"U",  SRF->RF_DIREMAN, 0),;//40 DIAS REMANESCENTE  
								})
					If SRF->RF_DATAINI >= dDataBase
						dDtIniProg := SRF->RF_DATAINI
						nDiasProg  := SRF->RF_DFEPRO1
					ElseIf SRF->RF_DATINI2 >= dDataBase
						dDtIniProg := SRF->RF_DATINI2
						nDiasProg  := SRF->RF_DFEPRO2
					ElseIf SRF->RF_DATINI3 >= dDataBase
						dDtIniProg := SRF->RF_DATINI3
						nDiasProg  := SRF->RF_DFEPRO3
					EndIf
					Exit
				Endif
				SRF->(DbSkip())
			EndDo
		EndIf
	Next
	If Len(aTmp) > 0 .And. cTpPrg <> '1'
		lRetorno := .T.
		aadd(aPerFerias ,aTmp[Len(aTmp)])
	Else
		lRetorno := .T.
		aPerFerias := aClone(aTmp)
	EndIf
	
	Return(lRetorno)

/*------------------------------------------------------*/
/*/{Protheus.doc} GetVacProgEffect
Método para validar Data Inicial do período de gozo das férias sugerida na solicitação de férias do Portal. 
Validação de acordo com a Reforma Trabalhista:
- Férias deve possuir mínimo de 2 dias de antecedências de Feriados e DSR.
Caso encontre inconsistências, retorna mensagem de aviso.
@author esther.viveiro
@since 06/11/2017
@version P12
/*/
WSMETHOD GetValidInitDtVac WSRECEIVE  EmployeeFil, Registration, StartDateVacation WSSEND ValidMessage WSSERVICE RHVacation
Local lRet      := .T.
Local lRefTrab	:= FindFunction("fRefTrab") .And. fRefTrab("F")
Local cFilFun   := ::EmployeeFil
Local cMatFun   := ::Registration
Local dDataIni  := CTOD(::StartDateVacation)
Local dDataFim  := CTOD("//")
Local dDSR		:= CTOD("//")

If lRefTrab
	If fFeriado( cFilFun, dDataIni ) //se data inicial for Feriado
		//retorna que dia é feriado
		::ValidMessage := OemToAnsi(STR0028) + "(" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) + ")"  + OemToAnsi(STR0029) + "(" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) +  ")" + "."
	ElseIf fFeriado( cFilFun, dDataIni + 1 ) //se dia seguinte à data inicial for feriado
		//retorna que antecede feriado
		::ValidMessage := OemToAnsi(STR0028) + "(" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) + ")"  + OemToAnsi(STR0029) + "(" + cValToChar(Day(dDataIni+1))+"/"+ cValToChar(Month(dDataIni+1)) + "/" + cValToChar(Year(dDataIni+1)) +  ")" + "."
	Else //verifica DSR
		dDSR	 := fVldDSR(cFilFun, cMatFun, dDataIni, 2, "D") //data do DSR
		If !Empty(dDSR) //retorna que antecede DSR
			::ValidMessage := OemToAnsi(STR0028) + "(" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) + ")"  + OemToAnsi(STR0030) + "(" + cValToChar(Day(dDSR))+"/"+ cValToChar(Month(dDSR)) + "/" + cValToChar(Year(dDSR)) +  ")" + "."
		EndIf
	EndIf
EndIf

Return lRet
