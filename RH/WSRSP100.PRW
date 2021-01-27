#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSRSP100.CH"
//WsClient_WsRspRhVacancy.prw
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³WSRH010   ³ Autor ³Emerson Grassi Rocha   ³ Data ³21/07/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pela Consulta de Vagas.              ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson Campos|30/04/14|TPKFN9         |Replica das alterações realizadas³±±
±±³              |        |               |pela manutenção até dt 12/02/14 	³±±
±±³              |        |               |chamado TIGRT7, changeset 2063715³±±
±±³              |        |               |na P11.80                       	³±±
±±³              |        |               |                                	³±±
±±³Matheus M.    |15/12/15|TTYK42         |Ajuste para evitar que a vaga    ³±±
±±³              |        |               |seja fechada sem a admissão do   ³±±
±±³              |        |               |candidato.				     	³±±
±±³Gabriel A.    |22/08/16|TVMUS6         |Ajuste para buscar o cargo       ³±±
±±³              |        |               |corretamente independentemente do³±±
±±³              |        |               |compartilhamento das tabelas.    ³±±
±±³Marcelo F.    |22/02/17|MRH-3832       |Melhoria para tratar novo campo  ³±±
±±³              |        |               |de caracteristica/perfil vaga    ³±±
±±|M. Silveira   |08/06/17|DRHPONTP-812   |Ajustes p/ exibir a descricao da ³±±
±±|              |        |               |da filial da vaga.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RhVacancy	DESCRIPTION STR0004	//"Vagas disponíveis"
	WSDATA UserCode            		AS String
	WSDATA VacancyFil		   			AS String OPTIONAL
	WSDATA VacancyCode         		AS String
	WSDATA CurricCode          		AS String OPTIONAL				//Cod do Curriculo
	WSDATA TypeApproval        		AS String OPTIONAL				//Tipo de Aprovacao
	WSDATA Registration        		AS String OPTIONAL
	WSDATA EmployeeFil         		AS String OPTIONAL        		//Filial do funcionario
	WSDATA VacancyNumber       		AS Integer	OPTIONAL				//Retorna o numero de vagas restante
	WSDATA AlterDateTime	       	As BooLean	OPTIONAL        		//Se a Data ou hora foi alterada
	WSDATA AlterObsCand	        	As Boolean	OPTIONAL				//Se a obs ao candidato foi alterado
	WSDATA SendMailReprove     		AS Boolean	OPTIONAL				//Se o candidato for reprovado se deve ser enviado email informando
	WSDATA VacancyColletion    		AS Array Of VacancyChoice
	WSDATA VacancyShow	        	AS Array Of VacancyView
	WSDATA Curric1Show	        	AS Array Of Curriculum1
	WSDATA ListSelects	        	As Array Of Selects
	WSDATA SetAgendaCandidate	  	AS StepsAgendaCandidate OPTIONAL //Atualizacao da agenda do candidato
	WSDATA TypeVacancy         		AS STRING OPTIONAL
	WSDATA FilterValue         		AS STRING OPTIONAL
	WSDATA FilterField         		AS STRING OPTIONAL
	
	WSMETHOD GetVacancy 				DESCRIPTION STR0005 //"Seleção de vaga"
	WSMETHOD ShowVacancy				DESCRIPTION STR0006 //"Detalhes da vaga"
	
	WSMETHOD GetCandProcSel			DESCRIPTION STR0007 //"Estrutura com a relacao de pessoas que se candidataram para a vaga"
	WSMETHOD SetSchedule  			DESCRIPTION STR0008 //"Atualizar os dados da etapa do processo seletivo do candidato"
	WSMETHOD GetSelects	   			DESCRIPTION STR0009 //"Monta todos os selects que serão utlizados na tela"
	WSMETHOD SetApproveCandidate	DESCRIPTION STR0010 //"Método responsável por atualizar os dados sobre a vaga e a agenda, após a aprovação do candidato ou de uma etapa da agenda."
ENDWSSERVICE

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetVacancy³Autor  ³ Emerson Grassi Rocha  ³ Data ³31/07/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de Selecao de Vagas                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve a tabela de Vagas conforme a estrutura   ³±±
±±³          ³da mesma                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetVacancy WSRECEIVE UserCode, VacancyFil, TypeVacancy, FilterValue, FilterField, Registration, EmployeeFil WSSEND VacancyColletion WSSERVICE RhVacancy
	Local aArea    	:= GetArea()
	Local cAlias		:= 'SQS'
	Local lApresenta	:= .T.
	Local lRetorno	:= .T.
	Local lRetbldGet	:= .T.
	Local lOk			:= .F.
	Local cProfile	:= '0'
	Local cLastFil	:= ''
	Local cDescFil	:= ''
	Local aInfo		:= {}
	Local lWSGETVAGA	:= ExistBlock("WSGETVAGA")
	Local nX       	:= 0
	Local nOrdSQD 	:= RetOrdem( "SQD" , "QD_FILIAL+QD_VAGA+QD_CURRIC+DTOS(QD_DATA)" )
	
	DEFAULT ::VacancyFil		:= ""
	DEFAULT ::TypeVacancy 	:= ""
	DEFAULT ::FilterValue	:= ''
	DEFAULT ::FilterField	:= ''
	//Registration so deve ser alimentado qdo a chamada for proveniente da 'Avaliacao do Processo Seletivo',
	//pois GetVacancy e utilizado por outras rotinas, e essas outras rotinas serao tratadas para manda-lo vazio.
	DEFAULT ::Registration	:= ''
	DEFAULT ::EmployeeFil	:= ''
	
	// Utilizar Usuario "ADMINISTRADOR" para teste   // Retirar do programa
	If ::UserCode=="ADMINISTRADOR" .Or. PrtChkUser(::UserCode,"RhVacancy")
		//If PrtChkUser(::UserCode,"RhVacancy")
		If Select("SQS") > 0
			SQS->(dbCloseArea())
		EndIf
		
		dbSelectArea("SQS")
		dbSetOrder(1)
		dbGoTop()
		If SQS->(!Eof())
			While SQS->(!Eof())
				
				// Executa ponto de entrada para filtro do cadastro de vagas
				If lWSGETVAGA
					lRetbldGet := ExecBlock("WSGETVAGA",.F.,.F.,{cAlias})
					IF ValType(lRetbldGet) <> 'L'
						lRetbldGet := .T.
					Endif
				EndIf
				
				If ( SQS->QS_NRVAGA - SQS->QS_VAGAFEC ) > 0  .and. lRetbldGet
					If ExistBlock("WSRSPVAG")
						lApresenta := ExecBlock('WSRSPVAG',.F.,.F.,{ (cAlias)->QS_VAGA, cAlias })
						IF ValType(lApresenta) <> 'L'
							lApresenta := .T.
						Endif
					EndIf
					If lApresenta
						If Empty(::TypeVacancy) .OR.;
								(!Empty(::TypeVacancy) .AND. (AllTrim(::TypeVacancy) == Alltrim(SQS->QS_TIPO).OR. Alltrim(SQS->QS_TIPO) == "1"))
							If (Empty(::FilterValue)) .OR. (At(Lower(::FilterValue), Lower(SQS->QS_DESCRIC)) > 0)
								//Utilizado na Rotina de PWSA370 - Avaliacao do Porcesso Seletivo
								cProfile	:= '0'
								
								If Empty( aInfo ) .Or. !(cLastFil == SQS->QS_FILIAL)
									fInfo(@aInfo,SQS->QS_FILIAL)
									cLastFil := SQS->QS_FILIAL
									cDescFil := aInfo[01]
								Else
									cDescFil := aInfo[01]								
								EndIf
								
								If !Empty(::Registration)
									lOk			:= .F.
									If ::Registration == SQS->QS_MATRESP .AND. ::EmployeeFil == SQS->QS_FILRESP
										lOk			:= .T.
										cProfile	:= '1'	//Responsavel
									Else
										dbSelectArea("SQD")
										SQD->(dbSetOrder(nOrdSQD))
										SQD->(dbGoTop())
										If SQD->(DbSeek(xFilial("SQD")+SQS->QS_VAGA))
											While SQD->(!Eof()) .AND. SQD->QD_VAGA == SQS->QS_VAGA
												If SQD->QD_MATPROC	== ::Registration .AND. SQD->QD_FILPROC == ::EmployeeFil
													lOk			:= .T.
													cProfile	:= '2'	//Participante
												EndIf
												SQD->(dbSkip())
											EndDo
										EndIf
									EndIf
									//So apresenta a vaga se o funcionario logado, for Responsavel ou participante no processo
									If lOk
										aadd(::VacancyColletion,WSClassNew("VacancyChoice"))
										nX++
										::VacancyColletion[nX]:VacancyCode 			  	:= SQS->QS_VAGA
										::VacancyColletion[nX]:VacancyFil	            := SQS->QS_FILIAL
										::VacancyColletion[nX]:VacancyDescriptionFil   := SQS->QS_FILIAL + " - " + AllTrim(cDescFil)

										::VacancyColletion[nX]:OpenPositionDescription 	:= SQS->QS_DESCRIC
										::VacancyColletion[nX]:AvaiableVacancies       	:= SQS->QS_NRVAGA - SQS->QS_VAGAFEC
										::VacancyColletion[nX]:Profile 					:= cProfile
										::VacancyColletion[nX]:OpeningDate				:= SQS->QS_DTABERT
										::VacancyColletion[nX]:VacancyType				:= SQS->QS_TIPO
										::VacancyColletion[nX]:NumberClosedVacancies	:= SQS->QS_VAGAFEC
									EndIf
									//Utilizado nas demais rotinas que retornam as vagas disponíveis (PC e GCH)
								Else
									aadd(::VacancyColletion,WSClassNew("VacancyChoice"))
									nX++
									::VacancyColletion[nX]:VacancyCode 			  	:= SQS->QS_VAGA
									::VacancyColletion[nX]:VacancyFil	            := SQS->QS_FILIAL
									::VacancyColletion[nX]:VacancyDescriptionFil   := SQS->QS_FILIAL + " - " + AllTrim(cDescFil)

									::VacancyColletion[nX]:OpenPositionDescription 	:= SQS->QS_DESCRIC
									::VacancyColletion[nX]:AvaiableVacancies       	:= SQS->QS_NRVAGA - SQS->QS_VAGAFEC
									::VacancyColletion[nX]:Profile 					:= cProfile
									::VacancyColletion[nX]:OpeningDate				:= SQS->QS_DTABERT
									::VacancyColletion[nX]:VacancyType				:= SQS->QS_TIPO
									::VacancyColletion[nX]:NumberClosedVacancies	:= SQS->QS_VAGAFEC
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				SQS->(dbSkip())
			EndDo
		Else
			lRetorno := .F.
			SetSoapFault("GETVACANCY01",STR0001)	//"Nao existe nenhuma vaga aberta."
		EndIf
		
	Else
		lRetorno := .F.
		SetSoapFault("GETVACANCY02",STR0002)	//"Usuario nao autorizado"
	EndIf
	
	RestArea(aArea)
Return(lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ShowVacanc³Autor  ³ Emerson Grassi Rocha  ³ Data ³01/08/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de Visualizacao dos dados da Vaga.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³          ³ExpC2: Codigo da Vaga                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve a tabela de Vagas conforme a estrutura   ³±±
±±³          ³da mesma                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD ShowVacancy WSRECEIVE UserCode,VacancyCode, VacancyFil WSSEND VacancyShow WSSERVICE RhVacancy
	Local aArea    	:= GetArea()
	Local nX       := 0
	Local lRetorno  := .T.
	Local cCargo    := ""
	Local cDescFil  := ""
	Local aInfo     := {}
	Local lWSShowDC := ExistBlock("WSShowDC")
	Local lWSShowDD := ExistBlock("WSShowDD")

	//Verifica se os fatores e habilidades devem ser carregados
	//0-Normal (carrega apenas descrição detalhada do cargo)
	//1-Carrega apenas os dados da caracteristica/perfil da vaga
	//2-Carrega a descrição detalhada do cargo e a caracteritica da vaga
	//3-Não carrega nada  
	Local cPerfVag  := GetMv("MV_PERFVAG", NIL, "0")
	
	Private cAlias  := "SQ3"
	Private cCampoQ3:= "Q3_DESCSUM"
	Private cCampoDD:= "Q3_DESCDET"
	
	DEFAULT ::VacancyFil := xFilial("SQS")

   If !cPerfVag $ ("0123")
		cPerfVag := "0"
   EndIf

	// Utilizar Usuario "ADMINISTRADOR" para teste   // Retirar do programa
	If ::UserCode=="ADMINISTRADOR" .Or. PrtChkUser(::UserCode,"RhVacancy")
		
		dbSelectArea("SQS")
		dbSetOrder(1)
		If dbSeek(xFilial("SQS", ::VacancyFil) + ::VacancyCode)
			aadd(::VacancyShow,WSClassNew("VacancyView"))
			nX++
			
			fInfo(@aInfo,SQS->QS_FILIAL)
			If !Empty( aInfo )
				cDescFil := aInfo[01]								
			EndIf
			
			cCargo := POSICIONE("SRJ", 1, xFilial("SRJ", ::VacancyFil) + SQS->QS_FUNCAO, "RJ_CARGO")
			
			::VacancyShow[nX]:VacancyCode 			  		:= ::VacancyCode
			::VacancyShow[nX]:VacancyFil					:= SQS->QS_FILIAL
			::VacancyShow[nX]:VacancyDescriptionFil		:= cDescFil
			::VacancyShow[nX]:OpenPositionDescription 	:= SQS->QS_DESCRIC
			::VacancyShow[nX]:AreaCode						:= SQS->QS_AREA
			::VacancyShow[nX]:AreaDescription				:= Fdesc("SX5","R1"+SQS->QS_AREA,"X5_DESCRI")
			::VacancyShow[nX]:CostCenterCode				:= SQS->QS_CC
			::VacancyShow[nX]:CostCenterDescription		:= Fdesc("CTT",SQS->QS_CC,"CTT_DESC01")
			::VacancyShow[nX]:FunctionCode					:= SQS->QS_FUNCAO
			::VacancyShow[nX]:FunctionDescription			:= POSICIONE("SRJ", 1, xFilial("SRJ", ::VacancyFil) + SQS->QS_FUNCAO, "RJ_DESC")
			::VacancyShow[nX]:NumberVacancies    			:= SQS->QS_NRVAGA
			::VacancyShow[nX]:NumberClosedVacancies		:= SQS->QS_VAGAFEC
			::VacancyShow[nX]:Petitioner					:= SQS->QS_SOLICIT
			::VacancyShow[nX]:TermVacancy					:= SQS->QS_PRAZO
			::VacancyShow[nX]:OpeningDate					:= SQS->QS_DTABERT
			::VacancyShow[nX]:AvaiableVacancies        	:= SQS->QS_NRVAGA - SQS->QS_VAGAFEC
			::VacancyShow[nX]:PositionCode					:= cCargo
			
			//Descricao do Cargo
			If !lWSShowDC
				::VacancyShow[nX]:PositionDescription          := POSICIONE("SQ3", 1, xFilial("SQ3", ::VacancyFil) + cCargo + SQS->QS_CC, "Q3_DESCSUM")
				If Empty(::VacancyShow[nX]:PositionDescription)
					::VacancyShow[nX]:PositionDescription       := POSICIONE("SQ3", 1, xFilial("SQ3", ::VacancyFil) + cCargo , "Q3_DESCSUM")
				EndIf
			Else
				ExecBlock("WSShowDC",.F.,.F.,{cCargo})
				::VacancyShow[nX]:PositionDescription          := POSICIONE(cAlias, 1, xFilial(cAlias, ::VacancyFil) + cCargo + SQS->QS_CC,cCampoQ3)
				If Empty(::VacancyShow[nX]:PositionDescription)
					::VacancyShow[nX]:PositionDescription       := POSICIONE(cAlias, 1, xFilial(cAlias, ::VacancyFil) + cCargo,cCampoQ3)
				EndIf
			Endif
		
			//Inicializa e trata descrição para a vaga
			::VacancyShow[nX]:PositionDetailedDescription	:= ""

			//Descricao da Vaga
			If !lWSShowDD
				//Carrega descricao detalhada do cargo
				If cPerfVag == "0" .Or. cPerfVag =="2" 
					::VacancyShow[nX]:PositionDetailedDescription	:= APDMSMM(SQ3->Q3_DESCDET)

                 //Ajuste realizado pois algumas funcionalidades na release 12.1.7
                 //ainda utilizam o cadastramento de texto memo no SYP 
                 IF empty(::VacancyShow[nX]:PositionDetailedDescription)
                    ::VacancyShow[nX]:PositionDetailedDescription	:= MSMM(SQ3->Q3_DESCDET)              
                 EndIf
				EndIf	
			Else
				ExecBlock("WSShowDD",.F.,.F.,{cCargo})
				::VacancyShow[nX]:PositionDetailedDescription    	:= POSICIONE(cAlias, 1, xFilial(cAlias, ::VacancyFil) + cCargo + SQS->QS_CC,cCampoDD)
				If Empty(::VacancyShow[nX]:PositionDetailedDescription)
					::VacancyShow[nX]:PositionDetailedDescription	:= POSICIONE(cAlias, 1, xFilial(cAlias, ::VacancyFil) + cCargo,cCampoDD)
				EndIf
			Endif

			//Carrega característica/perfil da vaga (SPY)
			::VacancyShow[nX]:ProfileDetailedDescription	:= ""
			If cPerfVag == "1" .Or. cPerfVag =="2" 
				If SQS->(ColumnPos("QS_CODPERF")) > 0
					::VacancyShow[nX]:ProfileDetailedDescription	:= AllTrim(APDMSMM(SQS->QS_CODPERF))

                 //Ajuste realizado pois algumas funcionalidades na release 12.1.7
                 //ainda utilizam o cadastramento de texto memo no SYP 
                 IF empty(::VacancyShow[nX]:ProfileDetailedDescription)
	                ::VacancyShow[nX]:ProfileDetailedDescription	:= AllTrim(MSMM(SQS->QS_CODPERF))
                 EndIf
				EndIf
			EndIf
			
			::VacancyShow[nX]:Test							:= SQS->QS_TESTE
			::VacancyShow[nX]:TestDescription				:= FDesc("SQQ",SQS->QS_TESTE,"QQ_DESCRIC")
			::VacancyShow[nX]:Point							:= SQS->QS_PONTOS
			::VacancyShow[nX]:AutoFailure					:= SQS->QS_AUTOM
			::VacancyShow[nX]:ApprovalMessage				:= SQS->QS_MSGAPV
			::VacancyShow[nX]:ApprovalMessageDescription	:= AllTrim(RHMSMM( Fdesc("RDG",SQS->QS_MSGAPV,"RDG_CODMEM"),,,,,,,,,,,"RDG" ))
			::VacancyShow[nX]:DisapprovalMessage 			:= SQS->QS_MSGREP
			::VacancyShow[nX]:DisapprovalMessageDescription	:= AllTrim(RHMSMM( Fdesc("RDG",SQS->QS_MSGREP,"RDG_CODMEM"),,,,,,,,,,,"RDG" ))
			::VacancyShow[nX]:Reinscription					:= SQS->QS_REINSC
			
			UserFields("SQS",@::VacancyShow[nX]:UserFields)
		Else
			lRetorno := .F.
			SetSoapFault("SHOWVACANCY01", STR0003)	//"Vaga nao localizada na Tabela."
		EndIf
	Else
		lRetorno := .F.
		SetSoapFault("SHOWVACANCY02", STR0002)	//"Usuario nao autorizado"
	EndIf
	
	RestArea(aArea)
Return (lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetCandProcSel³Autor  ³ Emerson Campos    ³ Data ³22/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de Visualizacao dos dados da Vaga.			           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³			 ³ExpC2: Codigo da Vaga		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve a tabela de Vagas conforme a estrutura   ³±±
±±³          ³da mesma                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetCandProcSel WSRECEIVE VacancyCode, Registration, EmployeeFil, FilterValue, FilterField, VacancyFil WSSEND Curric1Show WSSERVICE RhVacancy
	Local aArea    		:= GetArea()
	Local aCurricPart	:= {}
	Local lRetorno		:= .T.
	Local lOk			:= .T.
	Local lOkResp		:= .F.
	Local cCodCurric	:= ''
	Local nX			:= 0
	Local nY			:= 0
	Local nOrdSQD 		:= RetOrdem("SQD", "QD_FILIAL+QD_VAGA+QD_CURRIC+DTOS(QD_DATA)" )
	Local nOrdSQG 		:= RetOrdem("SQG", "QG_FILIAL+QG_CURRIC")
	Local nOrd1SQS  	:= RetOrdem( "SQS" , "QS_FILIAL+QS_VAGA" )
	
	
	DEFAULT ::FilterValue	:= ''
	DEFAULT ::FilterField	:= ''
	DEFAULT ::VacancyFil		:= cFilAnt 
	
	DbSelectArea("SQS")
	SQS->(DbSetOrder(nOrd1SQS))
	SQS->(dbSeek(xFilial("SQS",::VacancyFil)+self:VacancyCode))
	
	If ::EmployeeFil == SQS->QS_FILRESP .AND. ::Registration == SQS->QS_MATRESP
		lOkResp		:= .T.
	EndIf
	
	If !lOkResp
		dbSelectArea("SQD")
		SQD->(dbSetOrder(nOrdSQD))
		SQD->(dbGoTop())
		If SQD->(DbSeek(xFilial("SQD",::VacancyFil)+self:VacancyCode))
			While SQD->(!Eof()) .AND. SQD->QD_VAGA == self:VacancyCode
				If SQD->QD_FILPROC == ::EmployeeFil .AND. SQD->QD_MATPROC == ::Registration
					aadd(aCurricPart, SQD->QD_CURRIC)
				EndIf
				SQD->(dbSkip())
			EndDo
		EndIf
	EndIf
	
	dbSelectArea("SQD")
	SQD->(dbSetOrder(nOrdSQD))
	SQD->(dbGoTop())
	If SQD->(DbSeek(xFilial("SQD",::VacancyFil)+self:VacancyCode))
		While SQD->(!Eof()) .AND. SQD->QD_FILIAL+SQD->QD_VAGA == self:VacancyFil + self:VacancyCode 
			
			If lOkResp .OR. (Ascan(aCurricPart,{|x| x == SQD->QD_CURRIC}) > 0)
				If SQD->QD_CURRIC <> cCodCurric
					lOk	:= .T.
					cCodCurric	:= SQD->QD_CURRIC
					
					dbSelectArea("SQG")
					SQG->(dbSetOrder(nOrdSQG))
					SQG->(dbGoTop())
					
					If SQG->(DbSeek(xFilial("SQG")+SQD->QD_CURRIC))
						If (Empty(::FilterValue)) .OR. (At(Lower(::FilterValue), Lower(SQG->QG_NOME)) > 0)
							aadd(self:Curric1Show,WSClassNew("Curriculum1"))
							
							nX++
							nY	:= 0
							self:Curric1Show[nX]:Name                   :=	SQG->QG_NOME
							self:Curric1Show[nX]:CPF                    :=	SQG->QG_CIC
							self:Curric1Show[nX]:Curriculum             :=	SQG->QG_CURRIC
							self:Curric1Show[nX]:EmployeeBranch         :=	SQG->QG_FILMAT
							self:Curric1Show[nX]:EmployeeRegistration   :=	SQG->QG_MAT
							self:Curric1Show[nX]:HandCapped				:=	SQG->QG_DFISICO
							self:Curric1Show[nX]:Address				:=  SQG->QG_ENDEREC
							self:Curric1Show[nX]:DateofBirth			:=  SQG->QG_DTNASC
							self:Curric1Show[nX]:CurriculumStatus		:=  ''
						Else
							lOk	:= .F.
							Loop
						EndIf
					EndIf
					
					self:Curric1Show[nX]:AgendaCandidate	:= {}
					aadd(self:Curric1Show[nX]:AgendaCandidate,WSClassNew("StepsAgendaCandidate"))
					nY++
					self:Curric1Show[nX]:AgendaCandidate[nY]:CodeStep						:= SQD->QD_TPPROCE
					self:Curric1Show[nX]:AgendaCandidate[nY]:DescStep						:= GetSX5Conteudo("R9", SQD->QD_TPPROCE)
					self:Curric1Show[nX]:AgendaCandidate[nY]:Date							:= LEFT(DtoC(SQD->QD_DATA), 2)+"/"+SUBSTR(DtoC(SQD->QD_DATA), 4,2)+"/"+strzero(Year(SQD->QD_DATA),4)
					self:Curric1Show[nX]:AgendaCandidate[nY]:Time							:= SQD->QD_HORA
					self:Curric1Show[nX]:AgendaCandidate[nY]:CodeEvaluationFinal			:= SQD->QD_RESULTA
					self:Curric1Show[nX]:AgendaCandidate[nY]:DescEvaluationFinal			:= GetSX5Conteudo("RA", SQD->QD_RESULTA)
					self:Curric1Show[nX]:AgendaCandidate[nY]:EmployeeRegistration			:= SQD->QD_MATPROC
					self:Curric1Show[nX]:AgendaCandidate[nY]:NameEmployeeRegistration		:= GetSRAConteudo(SQD->QD_MATPROC)
					self:Curric1Show[nX]:AgendaCandidate[nY]:StepSituation					:= SQD->QD_SITPROC
					self:Curric1Show[nX]:AgendaCandidate[nY]:ObservationCandidate			:= AllTrim(If(Empty(SQD->QD_CODOBSC),"",APDMSMM(SQD->QD_CODOBSC)))
					self:Curric1Show[nX]:AgendaCandidate[nY]:ObservationEvaluator			:= AllTrim(If(Empty(SQD->QD_CODOBSA),"",APDMSMM(SQD->QD_CODOBSA)))
					self:Curric1Show[nX]:AgendaCandidate[nY]:CodeTest						:= SQD->QD_TESTE
					self:Curric1Show[nX]:AgendaCandidate[nY]:DescCodeTest					:= GetSQQConteudo(SQD->QD_TESTE)
					self:Curric1Show[nX]:AgendaCandidate[nY]:EvaluationFinal				:= SQD->QD_RESULTA
					self:Curric1Show[nX]:AgendaCandidate[nY]:EvaluationOk			   		:= SQD->QD_OK
					
				Else
					If lOk
						aadd(self:Curric1Show[nX]:AgendaCandidate,WSClassNew("StepsAgendaCandidate"))
						nY++
						self:Curric1Show[nX]:AgendaCandidate[nY]:CodeStep						:= SQD->QD_TPPROCE
						self:Curric1Show[nX]:AgendaCandidate[nY]:DescStep						:= GetSX5Conteudo("R9", SQD->QD_TPPROCE)
						self:Curric1Show[nX]:AgendaCandidate[nY]:Date							:= LEFT(DtoC(SQD->QD_DATA), 2)+"/"+SUBSTR(DtoC(SQD->QD_DATA), 4,2)+"/"+strzero(Year(SQD->QD_DATA),4)
						self:Curric1Show[nX]:AgendaCandidate[nY]:Time							:= SQD->QD_HORA
						self:Curric1Show[nX]:AgendaCandidate[nY]:CodeEvaluationFinal			:= SQD->QD_RESULTA
						self:Curric1Show[nX]:AgendaCandidate[nY]:DescEvaluationFinal			:= GetSX5Conteudo("RA", SQD->QD_RESULTA)
						self:Curric1Show[nX]:AgendaCandidate[nY]:EmployeeRegistration			:= SQD->QD_MATPROC
						self:Curric1Show[nX]:AgendaCandidate[nY]:NameEmployeeRegistration		:= GetSRAConteudo(SQD->QD_MATPROC)
						self:Curric1Show[nX]:AgendaCandidate[nY]:StepSituation					:= SQD->QD_SITPROC
						self:Curric1Show[nX]:AgendaCandidate[nY]:ObservationCandidate			:= AllTrim(If(Empty(SQD->QD_CODOBSC),"",APDMSMM(SQD->QD_CODOBSC)))
						self:Curric1Show[nX]:AgendaCandidate[nY]:ObservationEvaluator			:= AllTRim(If(Empty(SQD->QD_CODOBSA),"",APDMSMM(SQD->QD_CODOBSA)))
						self:Curric1Show[nX]:AgendaCandidate[nY]:CodeTest						:= SQD->QD_TESTE
						self:Curric1Show[nX]:AgendaCandidate[nY]:DescCodeTest					:= GetSQQConteudo(SQD->QD_TESTE)
						self:Curric1Show[nX]:AgendaCandidate[nY]:EvaluationFinal				:= SQD->QD_RESULTA
						self:Curric1Show[nX]:AgendaCandidate[nY]:EvaluationOk			   		:= SQD->QD_OK
					EndIf
				EndIf
				
				If lOk
					If SQD->QD_SITPROC == "2" .OR. self:Curric1Show[nX]:CurriculumStatus == "2"
						self:Curric1Show[nX]:CurriculumStatus 	:= "2"
					ElseIf SQD->QD_SITPROC == "0"
						self:Curric1Show[nX]:CurriculumStatus	:= "0"
					ElseIf SQD->QD_SITPROC == "1" .AND. self:Curric1Show[nX]:CurriculumStatus <> "0"
						self:Curric1Show[nX]:CurriculumStatus	:= "1"
					EndIf
				EndIf
			EndIf
			
			SQD->(dbSkip())
		EndDo
	EndIf
	
	RestArea(aArea)
Return (lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetSX5Conteudo³Autor  ³ Emerson Campos    ³ Data ³22/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina para buscar o campo descrição do SX5 de acordo com o  ³±±
±±³          ³idioma utilizado.              					           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cTabela: Codigo da tabela para utilizar na chave de busca    ³±±
±±³			 ³cChave:  Codigo da chave da tabela p/ util. na chave de busca³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cContRet: Retorno no nome do campo de acordo com o idioma    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetSX5Conteudo(cTabela, cChave)
	Local nOrdSX5	:= RetOrdem("SX5", "X5_FILIAL+X5_TABELA+X5_CHAVE")
	Local cContRet	:= ''
	Local aAreaAux 	:= GetArea()
	
	If !Empty(cChave)
		dbSelectArea("SX5")
		SX5->(dbSetOrder(nOrdSX5))
		SX5->(dbGoTop())
		
		If SX5->(DbSeek(xFilial("SX5")+cTabela+cChave))
			cContRet	:= Posicione( "SX5", nOrdSX5, xFilial("SX5")+cTabela+cChave, fDescSx5(2))
		EndIf
	EndIf
	
	RestArea(aAreaAux)
Return cContRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetSQQConteudo³Autor  ³ Emerson Campos    ³ Data ³22/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina para buscar o nome na descrição da tabela SQQ - Teste ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cTeste: Codigo do teste para utilizar na chave de busca      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cContRet: Retorna o nome do teste                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetSQQConteudo(cTeste)
	Local nOrdSQQ	:= RetOrdem("SQQ", "QQ_FILIAL+QQ_TESTE+QQ_ITEM+QQ_QUESTAO")
	Local cContRet	:= ''
	Local aAreaAux 	:= GetArea()
	
	If !Empty(cTeste)
		dbSelectArea("SQQ")
		SQQ->(dbSetOrder(nOrdSQQ))
		SQQ->(dbGoTop())
		
		If SQQ->(DbSeek(xFilial("SQQ")+cTeste))
			cContRet	:= SQQ->QQ_DESCRIC
		EndIf
	EndIf
	
	RestArea(aAreaAux)
Return cContRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetSRAConteudo³Autor  ³ Emerson Campos    ³ Data ³22/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina para buscar o nomer do funcionário de acordo com a    ³±±
±±³          ³matricula informada.            					           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cMate: Matricula do funcionario                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cContRet: Retorna o nome do funcionario                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetSRAConteudo(cMat)
	Local nOrdSRA	:= RetOrdem("SRA", "RA_FILIAL+RA_MAT")
	Local cContRet	:= ''
	Local aAreaAux 	:= GetArea()
	
	If !Empty(cMat)
		dbSelectArea("SRA")
		SRA->(dbSetOrder(nOrdSRA))
		SRA->(dbGoTop())
		
		If SRA->(DbSeek(xFilial("SRA")+cMat))
			cContRet	:= SRA->RA_NOME
		EndIf
	EndIf
	
	RestArea(aAreaAux)
Return cContRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GetSelects   ³Autor  ³ Emerson Campos    ³ Data ³26/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Retorna dados para alimentar os selects da tela.	           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³			 ³ExpC2: Codigo da Vaga		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetSelects WSRECEIVE VacancyCode WSSEND ListSelects WSSERVICE RhVacancy
	Local aArea    	:= GetArea()
	Local lRetorno	:= .T.
	Local cTabela
	Local nOrdSX5	:= RetOrdem("SX5", "X5_FILIAL+X5_TABELA+X5_CHAVE")
	Local nOrdSQQ	:= RetOrdem("SQQ", "QQ_FILIAL+QQ_TESTE+QQ_ITEM+QQ_QUESTAO")
	Local nX		:= 0
	Local nY		:= 0
	Local cCodTeste	:= ''
	
	aadd(self:ListSelects,WSClassNew("Selects"))
	nY++
	dbSelectArea("SX5")
	SX5->(dbSetOrder(nOrdSX5))
	SX5->(dbGoTop())
	
	cTabela	:= "RA"
	If SX5->(DbSeek(xFilial("SX5")+cTabela))
		self:ListSelects[nY]:SelectItens	:= {}
		While SX5->(!Eof())	  .AND. SX5->X5_TABELA == cTabela
			aadd(self:ListSelects[nY]:SelectItens,WSClassNew("OptionSelect"))
			nX++
			self:ListSelects[nY]:SelectItens[nX]:KeySelect		:= SX5->X5_CHAVE
			self:ListSelects[nY]:SelectItens[nX]:DescSelect		:= Posicione( "SX5", nOrdSX5, xFilial("SX5")+cTabela+SX5->X5_CHAVE, fDescSx5(2))
			SX5->(dbSkip())
		EndDo
	EndIf
	
	aadd(self:ListSelects,WSClassNew("Selects"))
	nY++
	nX	:= 0
	dbSelectArea("SQQ")
	SQQ->(dbSetOrder(nOrdSQQ))
	SQQ->(dbGoTop())
	
	If SQQ->(DbSeek(xFilial("SQQ")))
		self:ListSelects[nY]:SelectItens	:= {}
		While SQQ->(!Eof())
			If SQQ->QQ_TESTE <> cCodTeste
				cCodTeste	:=  SQQ->QQ_TESTE
				aadd(self:ListSelects[nY]:SelectItens,WSClassNew("OptionSelect"))
				nX++
				self:ListSelects[nY]:SelectItens[nX]:KeySelect		:= SQQ->QQ_TESTE
				self:ListSelects[nY]:SelectItens[nX]:DescSelect		:= SQQ->QQ_DESCRIC
			EndIf
			SQQ->(dbSkip())
		EndDo
	EndIf
	
	RestArea(aArea)
Return (lRetorno)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetSchedule   ³Autor  ³ Emerson Campos    ³ Data ³22/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de Visualizacao dos dados da Vaga.			           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do usuario                                     ³±±
±±³			 ³ExpC2: Codigo da Vaga		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Este metodo devolve a tabela de Vagas conforme a estrutura   ³±±
±±³          ³da mesma                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD SetSchedule WSRECEIVE SetAgendaCandidate, CurricCode, VacancyCode, TypeApproval, AlterDateTime, AlterObsCand, SendMailReprove WSSEND VacancyNumber WSSERVICE RhVacancy
	Local aArea    			:= GetArea()
	Local lRetorno			:= .F.
	Local nOrdSQD			:= RetOrdem("SQD", "QD_FILIAL+QD_VAGA+QD_CURRIC+DTOS(QD_DATA)")
	Local nOrdSQS			:= RetOrdem("SQS", "QS_FILIAL+QS_VAGA")
	Local nOrdSQG			:= RetOrdem("SQG", "QG_FILIAL+QG_CURRIC")
	Local nOrdSRA			:= RetOrdem("SRA", "RA_FILIAL+RA_MAT")
	Local cKeySQD 			:= ::VacancyCode+::CurricCode
	Local cKeySQS			:= ::VacancyCode
	Local cKeySQG			:= ::CurricCode
	Local lEtapaPendente	:= .F.
	Local cTitEmail			:= ''
	Local nX				:= 0
	Local nTamEE			:= 0
	Local aEndEmail			:= {}
	Local lProxEtapa		:= .F.
	Local cFilProc          := ''
	Local cMatProc			:= ''
	Local cFilMatNextStep	:= ''
	
	Self:VacancyNumber	:= 0
	
	If ::TypeApproval == 'N' // Aprovar apenas etapa
		// Atualiza a Agenda como teste feito
		dbSelectArea("SQD")
		SQD->(dbSetOrder(nOrdSQD))
		
		BEGIN TRANSACTION
			If SQD->(dbSeek(xFilial("SQD")+cKeySQD))
				While SQD->(!Eof()) .And. xFilial("SQD")+cKeySQD == SQD->QD_FILIAL+SQD->QD_VAGA+SQD->QD_CURRIC
					If self:SetAgendaCandidate:CodeStep == SQD->QD_TPPROCE
						SQD->(RecLock("SQD",.F.))
						SQD->QD_HORA 	:= self:SetAgendaCandidate:Time
						SQD->QD_DATA 	:= CtoD(self:SetAgendaCandidate:Date)
						SQD->QD_TESTE	:= self:SetAgendaCandidate:CodeTest
						SQD->QD_OK		:= self:SetAgendaCandidate:EvaluationOk
						SQD->QD_RESULTA	:= self:SetAgendaCandidate:EvaluationFinal
						SQD->QD_SITPROC	:= self:SetAgendaCandidate:StepSituation
						SQD->(MsUnlock())
						
						If !Empty(AllTrim(self:SetAgendaCandidate:ObservationCandidate))
							If Empty(SQD->QD_CODOBSC) .OR. (APDMSMM(SQD->QD_CODOBSC) <> self:SetAgendaCandidate:ObservationCandidate)
								APDMSMM(SQD->QD_CODOBSC,NIL,NIL,AllTrim(self:SetAgendaCandidate:ObservationCandidate),1,NIL,NIL,"SQD","QD_CODOBSC")
							EndIf
						EndIf
						If !Empty(self:SetAgendaCandidate:ObservationEvaluator)
							If Empty(SQD->QD_CODOBSA) .OR. (APDMSMM(SQD->QD_CODOBSA) <> self:SetAgendaCandidate:ObservationEvaluator)
								APDMSMM(SQD->QD_CODOBSA,NIL,NIL,AllTrim(self:SetAgendaCandidate:ObservationEvaluator),1,NIL,NIL,"SQD","QD_CODOBSA")
							EndIf
						EndIf
						lProxEtapa		:= .T.
						cFilProc        := SQD->QD_FILPROC
						cMatProc		:= SQD->QD_MATPROC
					ElseIf lProxEtapa
						If SQD->QD_SITPROC == '0'
							If  (!empty(SQD->QD_FILPROC+SQD->QD_MATPROC)) .AND. cFilProc+cMatProc <> SQD->QD_FILPROC+SQD->QD_MATPROC
								lProxEtapa		:= .F.
								cFilMatNextStep	:= SQD->QD_FILPROC+SQD->QD_MATPROC
							EndIf
						EndIf
					EndIf
					
					SQD->(dbSkip())
				EndDo
			EndIf
			
			SQD->(MsUnlock())
			SQD->(FkCommit())
			
			//Verifica se ainda tem alguma etapa pendente
			dbSelectArea("SQD")
			SQD->(dbSetOrder(nOrdSQD))
			
			If SQD->(dbSeek(xFilial("SQD")+cKeySQD))
				While SQD->(!Eof()) .And. xFilial("SQD")+cKeySQD == SQD->QD_FILIAL+SQD->QD_VAGA+SQD->QD_CURRIC
					If SQD->QD_SITPROC	<> '1'
						lEtapaPendente	:= .T.
					EndIf
					SQD->(dbSkip())
				EndDo
			EndIf
			
			//Cadastro de Vagas
			dbSelectArea("SQS")
			SQS->(dbSetOrder(nOrdSQS))
			If SQS->(dbSeek(xFilial("SQS")+cKeySQS))
				
				//Se na proxima etapa nao houver um responsavel, o responsavel pela vaga sera o responsavel pela etapa.
				If Empty(cFilMatNextStep)
					//Verifica se o reponsavel pela vaga e diferente do responsavel da etapa atual
					If SQS->QS_FILRESP+SQS->QS_MATRESP <> cFilProc+cMatProc
						cFilMatNextStep	:= SQS->QS_FILRESP+SQS->QS_MATRESP
					EndIf
				EndIf
				
				self:VacancyNumber	:= (SQS->QS_NRVAGA - SQS->QS_VAGAFEC)
				
			EndIf
			
			// Atualiza o Curriculo do candidato
			dbSelectArea("SQG")
			SQG->(dbSetOrder(nOrdSQG))
			
			If SQG->(dbSeek(xFilial("SQG")+cKeySQG))
				SQG->(RecLock("SQG",.F.))
				SQG->QG_ULTVAGA	:= ::VacancyCode
				SQG->QG_ULTETAP	:= self:SetAgendaCandidate:CodeStep
				SQG->QG_ULTDATA	:= dDataBase
				SQG->(MsUnlock())
			EndIf
			SQG->(FkCommit())
			
		END TRANSACTION
		
		
		//Envia E-mail de alteração de Data e Hora e/ou Observacao ao Candidato se o mesmo tiver email cadastrado
		If !Empty(SQG->QG_EMAIL) .AND. ( self:AlterDateTime .OR. self:AlterObsCand ) .AND. self:SetAgendaCandidate:StepSituation <> '2'
			
			//Atribui o email do candidato no array de emails
			aAdd(aEndEmail,	 Alltrim(Lower(SQG->QG_EMAIL)))
			
			//Atribui o email do dono da vaga e de todos os participantes nas etapas
			If self:AlterDateTime
				dbSelectArea("SRA")
				SRA->(dbSetOrder(nOrdSRA))
				SRA->(dbGoTop())
				
				If SRA->(DbSeek(SQS->QS_FILRESP+SQS->QS_MATRESP))
					aAdd(aEndEmail,	 Alltrim(Lower(SRA->RA_EMAIL)))
				EndIf
				
				dbSelectArea("SQD")
				SQD->(dbSetOrder(nOrdSQD))
				
				If SQD->(dbSeek(xFilial("SQD")+cKeySQD))
					While SQD->(!Eof()) .And. xFilial("SQD")+cKeySQD == SQD->QD_FILIAL+SQD->QD_VAGA+SQD->QD_CURRIC
						SRA->(dbGoTop())
						
						If SRA->(DbSeek(SQD->QD_FILPROC+SQD->QD_MATPROC))
							If Ascan(aEndEmail,{|x| x == Alltrim(SRA->RA_EMAIL)}) == 0
								aAdd(aEndEmail,	 Alltrim(Lower(SRA->RA_EMAIL)))
							EndIf
						EndIf
						SQD->(dbSkip())
					EndDo
				EndIf
			EndIf
			
			If self:AlterDateTime .AND. self:AlterObsCand
				cTitEmail	:= STR0020	//Alteração na 'Data/Hora' e 'Observação ao Candidato' nesta etapa do processo seletivo
			ElseIf self:AlterDateTime
				cTitEmail	:= STR0011 //Alteração na 'Data/Hora' nesta etapa do Processo Seletivo
			ElseIf self:AlterObsCand
				cTitEmail := STR0012 //Alteração na 'Observação ao Candidato' nesta etapa do Processo Seletivo
			EndIf
			
			//Funcao padrão para envio de emails nao contempla copia de email oculto, sendo assim,
			//os emails sao enviados independentes para que o candidato nao tenha acesso aos mesmos.
			nTamEE := Len(aEndEmail)
			For nX := 1 To nTamEE
				cMsgEmail := '<html>'
				cMsgEmail += '<head>'
				cMsgEmail += '<title>'+cTitEmail+'</title>'
				cMsgEmail += '</head>'
				cMsgEmail += '<body>'
				cMsgEmail += '<table borderColor="#0099cc" height="29" cellSpacing="1" width="750" borderColorLight="#0099cc" border=1>'
				cMsgEmail += '<tr>'
				cMsgEmail += '<td borderColor="#0099cc" borderColorLight="#0099cc" align="left" width="606" borderColorDark=v bgColor="#0099cc" height="1">'
				cMsgEmail += '<p align="center"><font face="Arial" color="#ffffff" size="3"><b>'+OemToAnsi(cTitEmail)+'</b></font></p></td>'//Alteração na Data/Hora em uma das etapas do Processo Seletivo
				cMsgEmail += '</tr>'
				cMsgEmail += '<tr>'
				cMsgEmail += '<td align="left" width="606" height="32">'
				cMsgEmail += '<br>'
				cMsgEmail += '<p align="left">'
				cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0013+' </b></font>' //Processo seletivo do candidato(a):
				cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+SQG->QG_NOME+'</font>'
				cMsgEmail += '<br>'
				cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0014+' </b></font>' //Candidatou-se a vaga:
				cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+SQS->QS_VAGA+' - '+SQS->QS_DESCRIC+'</font><br>'
				cMsgEmail += '<br>'
				cMsgEmail += '<font face="Arial" color="#0099cc" size="3"><b>'+STR0015+' </b></font>' //Dados sobre a etapa
				cMsgEmail += '<br>'
				cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0016+' </b></font>' //Etapa:
				cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+GetSX5Conteudo("R9", self:SetAgendaCandidate:CodeStep)+'</font>'
				cMsgEmail += '<br>'
				cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0017+' </b></font>' //Data:
				cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+self:SetAgendaCandidate:Date+'</font>'
				cMsgEmail += '<br>'
				cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0018+' </b></font>' //Hora:
				cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+self:SetAgendaCandidate:Time+'</font>'
				cMsgEmail += '<br>'
				cMsgEmail += '<br>'
				If !Empty(AllTrim(self:SetAgendaCandidate:ObservationCandidate))
					cMsgEmail += '<font face="Arial" color="#0099cc" size="3"><b>'+STR0019+' </b></font><br>' //Observação
					cMsgEmail += '<font face="Arial" color="#666666" size="2">'+AllTrim(self:SetAgendaCandidate:ObservationCandidate)+'</font>'
				EndIf
				cMsgEmail += '<br>'
				cMsgEmail += '</p>'
				cMsgEmail += '</td>'
				cMsgEmail += '</tr>'
				cMsgEmail += '</body>'
				cMsgEmail += '</html>'
				
				//Funcao padrao para envio de email's
				RH_Email(Lower(Alltrim(aEndEmail[nX])),'',cTitEmail,cMsgEmail,'','')
			Next nX
			
		EndIf
		
		//Envia Email de reprovacao no processo seletivo
		If self:SendMailReprove .AND. !Empty(SQS->QS_MSGREP) .AND. !Empty(SQG->QG_EMAIL) .AND. self:SetAgendaCandidate:StepSituation == '2'
			cTitEmail	:= STR0026 + ": " + SQS->QS_DESCRIC
			cMsgEmail	:= RHMSMM( Fdesc("RDG",SQS->QS_MSGREP,"RDG_CODMEM"),,,,,,,,,,,"RDG" )
			//Funcao padrao para envio de email's
			RH_Email(Lower(Alltrim(SQG->QG_EMAIL)),'',cTitEmail,cMsgEmail,'','')
		EndIf
		
		//Envia email ao proximo resposnsável pela etapa caso ele seja diferente da etapa atual
		If !Empty(cFilMatNextStep) .AND. self:SetAgendaCandidate:StepSituation == '1'
			dbSelectArea("SRA")
			SRA->(dbSetOrder(nOrdSRA))
			SRA->(dbGoTop())
			
			
			If SRA->(DbSeek(cFilMatNextStep))
				If !Empty(SRA->RA_EMAIL)
					cTitEmail	:= STR0022
					
					cMsgEmail := '<html>'
					cMsgEmail += '<head>'
					cMsgEmail += '<title>'+cTitEmail+'</title>'
					cMsgEmail += '</head>'
					cMsgEmail += '<body>'
					cMsgEmail += '<table borderColor="#0099cc" height="29" cellSpacing="1" width="750" borderColorLight="#0099cc" border=1>'
					cMsgEmail += '<tr>'
					cMsgEmail += '<td borderColor="#0099cc" borderColorLight="#0099cc" align="left" width="606" borderColorDark=v bgColor="#0099cc" height="1">'
					cMsgEmail += '<p align="center"><font face="Arial" color="#ffffff" size="3"><b>'+OemToAnsi(cTitEmail)+'</b></font></p></td>'//Alteração na Data/Hora em uma das etapas do Processo Seletivo
					cMsgEmail += '</tr>'
					cMsgEmail += '<tr>'
					cMsgEmail += '<td align="left" width="606" height="32">'
					cMsgEmail += '<br>'
					cMsgEmail += '<p align="left">'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0013+' </b></font>' //Processo seletivo do candidato(a):
					cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+SQG->QG_NOME+'</font>'
					cMsgEmail += '<br>'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0014+' </b></font>' //Candidatou-se a vaga:
					cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+SQS->QS_VAGA+' - '+SQS->QS_DESCRIC+'</font><br>'
					cMsgEmail += '<br>'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="3"><b>'+STR0015+' </b></font>' //Dados sobre a etapa
					cMsgEmail += '<br>'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0016+' </b></font>' //Etapa:
					cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+GetSX5Conteudo("R9", self:SetAgendaCandidate:CodeStep)+'</font>'
					cMsgEmail += '<br>'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0017+' </b></font>' //Data:
					cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+self:SetAgendaCandidate:Date+'</font>'
					cMsgEmail += '<br>'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0018+' </b></font>' //Hora:
					cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+self:SetAgendaCandidate:Time+'</font>'
					cMsgEmail += '<br>'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="2"><b>'+STR0023+' </b></font>' //Situação da Etapa:
					cMsgEmail += '<font face="Arial" color="#666666" size="2"> '+self:SetAgendaCandidate:Time+'</font>'
					cMsgEmail += '<br>'
					cMsgEmail += '<br>'
					cMsgEmail += '<font face="Arial" color="#0099cc" size="3"><b>'+STR0024+' </b></font><br>' //Observação
					cMsgEmail += '<font face="Arial" color="#666666" size="2">'+STR0025+'</font>' //"O candidato foi aprovado nesta etapa e está apto a prosseguir no processo seletivo."
					cMsgEmail += '<br>'
					cMsgEmail += '</p>'
					cMsgEmail += '</td>'
					cMsgEmail += '</tr>'
					cMsgEmail += '</body>'
					cMsgEmail += '</html>'
					//Funcao padrao para envio de email's
					RH_Email(Lower(Alltrim(SRA->RA_EMAIL)),'',cTitEmail,cMsgEmail,'','')
				EndIf
			EndIf
		EndIf
		lRetorno	:= .T.
	EndIf
	RestArea(aArea)
Return lRetorno

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SetApproveCandidate³Autor  ³Emerson Campos³ Data ³22/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³"Metodo responsavel por atualizar os dados sobre a vaga e a  ³±±
±±³          ³agenda, apos a aprovacao do cand. ou de uma etapa da agenda."³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do Curriculo                                   ³±±
±±³			 ³ExpC2: Codigo da Vaga		                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica que o metodo foi avaliado com sucesso          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Portal RH				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD SetApproveCandidate WSRECEIVE CurricCode, VacancyCode, TypeApproval WSSEND VacancyNumber WSSERVICE RhVacancy
	Local aArea    	:= GetArea()
	Local nOrdSQD	:= RetOrdem("SQD", "QD_FILIAL+QD_VAGA+QD_CURRIC+DTOS(QD_DATA)")
	Local nOrdSQS	:= RetOrdem("SQS", "QS_FILIAL+QS_VAGA")
	Local nOrdSQG	:= RetOrdem("SQG", "QG_FILIAL+QG_CURRIC")
	Local cKeySQD 	:= ::VacancyCode+::CurricCode
	Local cKeySQS	:= ::VacancyCode
	Local cKeySQG	:= ::CurricCode
	Local lRet		:= .F.
	
	Self:VacancyNumber	:= 0
	
	If ::TypeApproval == 'S' // Aprovar total
		// Atualiza a Agenda como teste feito
		dbSelectArea("SQD")
		SQD->(dbSetOrder(nOrdSQD))
		
		BEGIN TRANSACTION
			If SQD->(dbSeek(xFilial("SQD")+cKeySQD))
				While SQD->(!Eof()) .And. xFilial("SQD")+cKeySQD == SQD->QD_FILIAL+SQD->QD_VAGA+SQD->QD_CURRIC
					If SQD->QD_SITPROC # "1"
						SQD->(RecLock("SQD",.F.))
						SQD->QD_SITPROC	:= "1"
						cUltEtapa	:= SQD->QD_TPPROCE
						SQD->(MsUnlock())
					EndIf
					SQD->(dbSkip())
				EndDo
			EndIf
			
			SQD->(MsUnlock())
			SQD->(FkCommit())
			
			// Atualiza a Agenda como teste feito
			dbSelectArea("SQS")
			SQS->(dbSetOrder(nOrdSQS))
			
			If SQS->(dbSeek(xFilial("SQS")+cKeySQS))
				Self:VacancyNumber	:= ( SQS->QS_NRVAGA - (SQS->QS_VAGAFEC) )
			EndIf
						
			// Atualiza o Curriculo do candidato
			dbSelectArea("SQG")
			SQG->(dbSetOrder(nOrdSQG))
			
			If SQG->(dbSeek(xFilial("SQG")+cKeySQG))
				SQG->(RecLock("SQG",.F.))
				SQG->QG_ULTVAGA	:= ::VacancyCode
				SQG->QG_ULTETAP	:= cUltEtapa
				SQG->QG_ULTDATA	:= dDataBase
				SQG->(MsUnlock())
			EndIf
			SQG->(FkCommit())
			
		END TRANSACTION
		lRet	:= .T.
	EndIf
	
	RestArea(aArea)
Return lRet

Function wsrsp100()
Return
