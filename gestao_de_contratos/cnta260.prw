#INCLUDE "CNTA260.ch"
#include "protheus.ch"
#include "tbiconn.ch"

//-- alteração para permitir carregar model
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#DEFINE DEF_SVIGE "05" //Vigente

Static xCompet	:= ""
Static lCN260OBRIG := ExistBlock("CN260OBRIG")

/*³Fun‡ao    ³ CNTA260  ³ Autor ³ Marcelo Custodio      ³ Data ³28.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina responsavel pela execucao das medicoes de contratos ³±±
±±³          ³ do tipo automatico                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA260(cExp01,cExp02,cExp03)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo da Empresa                                 ³±±
±±³          ³ cExp02 - Codigo da Filial                                  ³±±
±±³          ³ cExp03 - Horario da execicao HH:MM / Intervalo entre as    ³±±
±±³          ³          execucoes                                         ³*/
Main Function CNTA260(cCodEmp,cCodFil,cInterval)
	Local lRet 		:= .T.
	Local cEmpCod	:= ""
	Local cFilCod	:= ""	
	Default cCodEmp	:= IIF(Type('cEmpAnt') != 'U',cEmpAnt,"")
	Default cCodFil	:= IIF(Type('cFilAnt') != 'U',cFilAnt,"")
	Default cInterval	:= ""			//Mantido para compatibilidade com versões anteriores.
	
	PRIVATE lMsErroAuto := .F.
	
	//-- Verifica se a rotina e executada atraves de um JOB
	If GetRemoteType() == -1		  //-- Execucao por JOB
		If ValType(cCodEmp) == "A"
			cEmpCod := cCodEmp[1]
			cFilCod := cCodEmp[2]
		Else
			cEmpCod := cCodEmp
			cFilCod := cCodFil
		Endif
	
		If Empty(cEmpCod) .Or. Empty(cFilCod)
			lRet := .F.
			ConOut('CNTA260 ERROR - Param Error')
		Else
			RpcSetType(3)
			RpcSetEnv(cEmpCod,cFilCod,,,"GCT","CNTA260",{'CN9','CNA','CNB','CND','CNE'})
			lRet := !CN260Exc(.T.)
			RpcClearEnv()
		EndIf
	ElseIf( Aviso("CNTA260", STR0015,{STR0017, STR0016}) == 1 )//-- Execucao por Menu					
		Processa( {|| CN260Exc(.F.) } )
	EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN260Exc ³ Autor ³ Marcelo Custodio      ³ Data ³28.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa medicoes pendentes para os contratos automaticos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN260Exc(lExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lExp01 - Executado pelo job                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN260Exc(lJob)
	Local lMedPend := (GetNewPar("MV_MEDPEND","1") == "1")//Parametro que informa se a rotina busca por medicoes pendentes
	Local aCab     := {}//Cabecalho
	Local aItem    := {}//Itens
	Local cQuery   := ""
	Local cNum     := ""
	Local dData    := IIF(lJob,Date(),dDataBase)//Data Atual
	Local cTxLog   := ""//Texto do log
	Local cOldMed  := ""
	Local lContinua:= .T.
	Local lFail    := .F.
	Local lQuery   := .F.
	Local nStack
	Local cArqTrb
	Local cArqTrb2
	Local nX         := 0
	Local aParams    := {}
	Local aQuebraThr := {}
	Local aContratos := {}
	Local cJobFile   := ""
	Local cJobAux    := ""
	Local cStartPath := GetSrvProfString("Startpath","")
	Local nThreads   := SuperGetMv('MV_CT260TH',.F.,0) //parametro utilizado para informar o numero de threads para o processamento.
	Local lCnta121   := GetNewPar('MV_CT26021',	.F.) //Parametro diz se deve usar exclusivamente o CNTA121 ou nao	
	
	
	//³ Valida se o sistema foi atualizado    ³	
	If !lCnta121
		//³ Gera historico                        ³	
		cTxLog := STR0018+" - "+DTOC(dData)+" - "+time()+CHR(13)+CHR(10)//"Log de execucao das medicoes automaticas"
		cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
		nTotMed := nTotEnc := 0
		nStack := GetSX8Len()
	
		If lJob
			ConOut(STR0001)//"Verificando medições pendentes"
			ConOut(STR0002 + time())
		Else
			IncProc(STR0001 + " - " + DTOC(dData))
		EndIf
			
		cArqTrb := GetQryTrb(dData, .F., .T.)
		
		If nThreads > 0
			
			aQuebraThr := CN260QtdThr(cArqTrb,nThreads)
			aThreads   := aQuebraThr[1]
			aContratos := aQuebraThr[2]
			aJobAux    := {}
			
			If Len(aThreads) > 0 .And. Len(aThreads[1]) > 0
			
				For nX:= 1 To Len(aThreads)
				
					// Informacoes do semaforo
					cJobFile:= cStartPath + CriaTrab(Nil,.F.)+".job"
							
					// Inicializa variavel global de controle de thread
					cJobAux:="cGlb"+cEmpAnt+cFilAnt+StrZero(nX,2)
					PutGlbValue(cJobAux,"0")
					GlbUnLock()
					
					aParams:= { cEmpAnt		,;	//1 
								  cFilAnt		,;	//2
								  dDataBase	,;	//3
								  lMedPend		,;	//4
								  nStack		,;	//5
								  cTxLog		,;	//6
								  nTotMed		,;	//7
								  nTotEnc		,;	//8
								  lJob}			//9
				
					StartJob("CNTA260JOB",GetEnvServer(),.F.,aThreads[nX],aContratos,cJobFile,StrZero(nX,2),cArqTrb,aParams)
				
				Next nX
			EndIf
			
		Else
		
			While !(cArqTrb)->(Eof())
				DbSelectArea("CN9")
				DbSetOrder(1)
				CN9->(dbSeek(xFilial("CN9")+(cArqTrb)->CN9_NUMERO+CnGetRevVg((cArqTrb)->CN9_NUMERO),.T.))
				If AllTrim(CN9->CN9_SITUAC) == '09'
					(cArqTrb)->(DbSkip())
					Loop
				EndIf		
				
				If((cArqTrb)->(!VldMdGerada(CN9_NUMERO, CNA_NUMERO, CNF_PARCEL)))//Valida se mediçao já foi gerada
					(cArqTrb)->(dbSkip())
					Loop
				EndIf
						
				lContinua := .T.
				lQuery    := .T.
		
				aCab := {}
				cNum := CriaVar("CND_NUMMED")
				aAdd(aCab,{"CND_CONTRA",(cArqTrb)->CNF_CONTRA,NIL})
				aAdd(aCab,{"CND_REVISA",(cArqTrb)->CNF_REVISA,NIL})
				aAdd(aCab,{"CND_COMPET",(cArqTrb)->CNF_COMPET,NIL})
				aAdd(aCab,{"CND_NUMERO",(cArqTrb)->CNA_NUMERO,NIL})
				aAdd(aCab,{"CND_NUMMED",cNum,NIL})
				aAdd(aCab,{"CND_PARCEL",(cArqTrb)->CNF_PARCEL,NIL})
		
				If lJob
					ConOut(STR0003 + " - " + aCab[5,2])
					ConOut(STR0004 + " - " + (cArqTrb)->CNF_CONTRA)
					ConOut(STR0005 + " - " + (cArqTrb)->CNA_NUMERO)
					ConOut(STR0006 + " - " + aCab[3,2])
				Else
					IncProc(STR0003 + " - " + aCab[5,2])
				EndIf
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa rotina automatica para gerar as medicoes ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				CNTA120(aCab,aItem,3,.F.)
				If !lMsErroAuto
					cTxLog += STR0019+" - "+aCab[5,2]+CHR(13)+CHR(10)//"Medicao gerada com sucesso"
					cTxLog += STR0004+" - "+(cArqTrb)->CNF_CONTRA+CHR(13)+CHR(10)
					cTxLog += STR0022+" - "+(cArqTrb)->CN9_FILIAL+CHR(13)+CHR(10)
					cTxLog += STR0005+" - "+(cArqTrb)->CNA_NUMERO+CHR(13)+CHR(10)
					cTxLog += STR0006+" - "+aCab[3,2]+CHR(13)+CHR(10)
					If lJob
						ConOut(STR0007+aCab[5,2]+STR0008)
					EndIf
					nTotMed++
				Else
			  		cOldMed := aCab[5,2]
					If lMedPend
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Quando houver erro na inclusao pesquisa medicoes  ³
						//³ verificando se existe algum registro nao encerrado³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cArqTrb2	:= CriaTrab( nil, .F. )
						cQuery := "SELECT CND.CND_NUMMED,CND.CND_COMPET,CND.CND_NUMERO FROM "+ RetSQLName("CND") +" CND WHERE "
						cQuery += "CND.CND_FILIAL = '"+ xFilial("CND") +"' AND "
						cQuery += "CND.CND_CONTRA = '"+ (cArqTrb)->CNF_CONTRA +"' AND "
						cQuery += "CND.CND_REVISA = '"+ (cArqTrb)->CNF_REVISA +"' AND "
						cQuery += "CND.CND_COMPET = '"+ (cArqTrb)->CNF_COMPET +"' AND "
						cQuery += "CND.CND_DTFIM  = '        ' AND "
						cQuery += "CND.D_E_L_E_T_ = ' '"
		
						cQuery := ChangeQuery( cQuery )
		
						dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb2, .T., .T. )
		
						If !(cArqTrb2)->(Eof())
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Substitui medicao para encerramento               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aCab[3,2] := (cArqTrb2)->CND_COMPET
							aCab[4,2] := (cArqTrb2)->CND_NUMERO
							aCab[5,2] := (cArqTrb2)->CND_NUMMED
							lContinua := .T.
							lMsErroAuto:= .F.
						Else
							lContinua := .F.
						EndIf
		
						(cArqTrb2)->(dbCloseArea())
					Else
						lContinua := .F.
					EndIf
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gera log de execucao                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cTxLog += STR0009+" - "+cOldMed+CHR(13)+CHR(10)
					If lContinua
						cTxLog += STR0021+" - "+aCab[5,2]+CHR(13)+CHR(10)
					EndIf
					cTxLog += STR0004+" - "+(cArqTrb)->CNF_CONTRA+CHR(13)+CHR(10)
					cTxLog += STR0022+" - "+(cArqTrb)->CN9_FILIAL+CHR(13)+CHR(10)
					cTxLog += STR0005+" - "+(cArqTrb)->CNA_NUMERO+CHR(13)+CHR(10)
					cTxLog += STR0006+" - "+aCab[3,2]+CHR(13)+CHR(10)
					If !lContinua
						cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
					EndIf
		
					If lJob
						ConOut(STR0009 + aCab[5,2])
					EndIf
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Retorna controle de numeracao                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While GetSX8Len() > nStack
						RollBackSX8()
					EndDo
				EndIf
		
				If lContinua
					If lJob
						ConOut(STR0010 + aCab[5,2])
					Else
						IncProc(STR0010 + aCab[5,2])
					EndIf
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Executa rotina automatica para encerrar as medicoes ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					CNTA120(aCab,aItem,6,.F.)
					If !lMsErroAuto
						cTxLog += STR0020+CHR(13)+CHR(10)//"Medicao encerrada com sucesso"
						cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
						If lJob
							ConOut(STR0007+aCab[5,2]+STR0011)
						EndIf
						nTotEnc++
					Else
						cTxLog += STR0012+CHR(13)+CHR(10)
						cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
						If lJob
							ConOut(STR0012+aCab[5,2])
						EndIf
					EndIf
				EndIf
		
				(cArqTrb)->(dbSkip())
			EndDo
		EndIf
		
		(cArqTrb)->(dbCloseArea())
	
		If(lContinua)
			If lJob
				ConOut(STR0013 + time())
			EndIf
			cTxLog += STR0013 + time()
		Else
			If lJob
				ConOut(STR0014)
			Else
				Aviso("CNTA260",STR0014,{"Ok"})
			EndIf
			lFail := .T.
			cTxLog += STR0014		
		EndIf		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa ponto de entrada apos a gravacao da medição automática   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("CNT260GRV")
			ExecBlock("CNT260GRV",.F.,.F.)
		EndIf
		
		If lQuery		
			//³ Executa gravacao do arquivo de historico          ³		
			MemoWrite(Criatrab(,.f.)+".LOG",cTxLog)
			
			//Emite alerta com o log do processamento		
			MEnviaMail("041",{cTxLog})
		EndIf	
	EndIf
	
	//-- Incluir medição automatica de contratos recorrentes pela rotina CNTA121
	CN260Exc121(lJob, lCnta121)
Return lFail

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN260Exc_121 ³ Autor ³ Marcelo Custodio      ³ Data ³28.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa medicoes pendentes para os contratos automaticos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN260Exc_121(lExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lExp01 - Executado pelo job                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN260Exc121(lJob, lProcTdsMd)
Local aArea		:= GetArea()
Local aSaveLines	:= FwSaveRows()
Local oModel 		:= Nil
Local oModelCNA		:= Nil
Local oModelCND		:= Nil
Local oModelCNE		:= Nil
Local oModelCXN		:= Nil

Local aCab     		:= {}//Cabecalho
Local aItem    		:= {}//Itens

Local cQuery   		:= ""
Local cNum     		:= ""
Local cTxLog   		:= ""//Texto do log
Local cOldMed  		:= ""
Local cArqTrb
Local cArqTrb2
Local cCnt260Fil
Local cHelp			:= ""
Local cTxPlan		:= ""
Local cContrato 	:= ""
Local cCompet		:= ""
Local cQuebra		:= ""

Local lMedPend 	:= (GetNewPar("MV_MEDPEND","1") == "1")//Parametro que informa se a rotina busca por medicoes pendentes
Local lRecorre 	:= .F.
Local lEventual	:= .F.
Local lFind		:= .F.
Local lContinua	:= .T.
Local lFail    	:= .F.
Local lVldCtr	:= .T.
Local lQuery 	:= .F.

Local nDias    	:= GetNewPar( "MV_MEDDIAS", 0 )//Parametro que armazena a quantidade de dias de busca
Local nStack	:= 0
Local nX 		:= 0
Local nLinha	:= 0

Local dData    	:= If(lJob,date(),dDataBase)//Data Atual
Local dDataI   	:= dData-nDias//Data de inicio
Local dCompet  	:= Ctod("")
Local cFilCN9		:= xFilial("CN9",cFilAnt)
Default lProcTdsMd := SuperGetMv('MV_CT26021',.F., .F.) //Parametro diz se deve usar exclusivamente o CNTA121 ou nao


//-- Gera historico
cTxLog := STR0018+" - "+DTOC(dData)+" - "+time()+CHR(13)+CHR(10)//"Log de execucao das medicoes automaticas"
cTxLog += Replicate("-",128)+CHR(13)+CHR(10)

//-- Valida se o sistema foi atualizado
If lContinua
	nTotMed := nTotEnc := 0
	nStack 	:= GetSX8Len()

	If lJob
		ConOut(STR0001)//"Verificando medições pendentes"
		ConOut(STR0002 + time())
	Else
		IncProc(STR0001 + " - " + DTOC(dData))
	EndIf	

	cArqTrb := GetQryTrb( dData, .T., lProcTdsMd)//Filtra parcelas de contratos automaticos pendentes para a data atual
	
	oModel := FWLoadModel("CNTA121")
	While !(cArqTrb)->(Eof())
		lQuery := .T.
		If !lFind
			DbSelectArea("CN9")
			CN9->(dbSetOrder(1))
			If !(CN9->(MsSeek(cFilCN9+(cArqTrb)->CN9_NUMERO+CnGetRevVg((cArqTrb)->CN9_NUMERO),.T.))) .And. CnGetRevVg((cArqTrb)->CN9_NUMERO) == CnGetRevAt((cArqTrb)->CN9_NUMERO)
				(cArqTrb)->(DbSkip())
				Loop
			EndIf

			If AllTrim((cArqTrb)->CNF_CONTRA) == "RECORRENTE"
				//-- Quando possui recorrente não possui CNF, ela é obtida da data da próxima medição que esta na CNA.
				cContrato 	:= (cArqTrb)->CN9_NUMERO
				dCompet		:= Stod((cArqTrb)->CNF_COMPET) 							
				cCompet		:= StrZero( Month( dCompet ), 2 ) + "/" + CValToChar( Year( dCompet ) )
				cPlan		:= AllTrim((cArqTrb)->CNA_NUMERO)
			Else
				cContrato	:= (cArqTrb)->CNF_CONTRA
				cCompet		:= AllTrim((cArqTrb)->CNF_COMPET)
				cPlan		:= AllTrim((cArqTrb)->CNA_NUMERO)
			Endif

			A260SComp(cCompet)
			oModel:SetOperation(MODEL_OPERATION_INSERT)

			If oModel:Activate()
				oModelCND := oModel:GetModel("CNDMASTER")
				oModelCXN := oModel:GetModel("CXNDETAIL")
				oModelCNE := oModel:GetModel("CNEDETAIL")
				oModelCND:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})
				oModelCXN:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})
				oModelCNE:GetStruct():SetProperty('*',MODEL_FIELD_WHEN,{||.T.})

				If (lVldCtr := oModelCND:SetValue("CND_CONTRA",cContrato))
					oModelCND:SetValue("CND_REVISA"	,CnGetRevVg((cArqTrb)->CN9_NUMERO))
					oModelCND:SetValue("CND_COMPET"	,cCompet)
					CN121Carga((cArqTrb)->CNF_CONTRA,(cArqTrb)->CNF_REVISA)
				EndIf
			EndIf
		EndIf

		nLinha := MTFindMVC(oModelCXN,{{"CXN_NUMPLA",(cArqTrb)->CNA_NUMERO}})

		If nLinha > 0
			oModelCXN:GoLine(nLinha)
			lVldCtr := oModelCXN:SetValue("CXN_CHECK" , .T. )

			//- Ponto de Entrada para preenchimento de campos obrigatorios customizados
			If lCN260OBRIG
				ExecBlock("CN260OBRIG",.F.,.F.,{oModel})
			EndIf

			cQuebra:= (cArqTrb)->CN9_NUMERO+cCompet
			cTxPlan += STR0005+" - "+(cArqTrb)->CNA_NUMERO+CHR(13)+CHR(10)
		EndIf

		(cArqTrb)->(dbSkip())

		If cQuebra == (cArqTrb)->CN9_NUMERO+cCompet .And. !(cArqTrb)->(Eof())
			lFind:= .T.
		Else
			lFind:= .F.

			//-- Commit na medição
			If (lContinua := oModel:VldData())
				lContinua := oModel:CommitData()
			ElseIf lVldCtr
				cHelp+= cContrato+" - "+cPlan+": não foi possivel validar o modelo ("+oModel:AERRORMESSAGE[6]+")"+CRLF
			EndIf
			oModel:DeActivate()

			If lContinua
				While ( GetSX8Len() > nStack )
					ConfirmSX8() //-- Retorna controle de numeracao
				EndDo

				cTxLog += STR0019+" - "+CND->CND_NUMMED+CHR(13)+CHR(10)//"Medicao gerada com sucesso"
				cTxLog += STR0004+" - "+cContrato+CHR(13)+CHR(10)
				cTxLog += STR0022+" - "+(cArqTrb)->CN9_FILIAL+CHR(13)+CHR(10)
				cTxLog += 	cTxPlan
				cTxLog += STR0006+" - "+cCompet+CHR(13)+CHR(10)

				cTxPlan:= ""

				ConOut( Replicate("-",128) )
				ConOut( STR0019+" - " + CND->CND_NUMMED )
				ConOut( STR0004+" - " + cContrato )
				ConOut( STR0006+" - " + cCompet )
				ConOut( Replicate("-",128) )

				If lJob
					ConOut(STR0007+cCompet+STR0008)
				EndIf

				// Rotina de encerramento de medição
				lContinua := CN121Encerr()

				If lContinua
					ConOut( Replicate("-",128) )
					ConOut( "Medicao encerrada com sucesso"+" - " + CND->CND_NUMMED )
					ConOut( STR0004+" - " + cContrato )
					ConOut( Replicate("-",128) )
				Endif
			Else
				While GetSX8Len() > nStack
					RollBackSX8()
				EndDo
				cTxLog += STR0004+" - "+cContrato+CHR(13)+CHR(10)
				cTxLog += STR0022+" - "+(cArqTrb)->CN9_FILIAL+CHR(13)+CHR(10)
				cTxLog += STR0005+" - "+(cArqTrb)->CNA_NUMERO+CHR(13)+CHR(10)
				cTxLog += STR0006+" - "+cCompet+CHR(13)+CHR(10)
				cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
				If lJob
					ConOut(STR0009 + cCompet)
				EndIf
			Endif
		EndIf
	EndDo
	(cArqTrb)->(dbCloseArea())
Else
	If lJob
		ConOut(STR0014)
	Else
		Aviso("CNTA260",STR0014,{"Ok"})
	EndIf
	lFail := .T.
	cTxLog += STR0014
EndIf

If !Empty(cHelp)
	//- Mostra Help contendo os cotratros com falha
	Help(" ",1,"A260VLDDATA",,cHelp + "Medição não será gerada para estes contratos.",1,1)
EndIf

//-- Executa ponto de entrada apos a gravacao da medição automática
If ExistBlock("CNT260GRV")
	ExecBlock("CNT260GRV",.F.,.F.)
EndIf

If lQuery
	//--  Executa gravacao do arquivo de historico
	MemoWrite(Criatrab(,.f.)+".LOG",cTxLog)
	
	//-- Emite alerta com o log do processamento
	MEnviaMail("041",{cTxLog})
EndIf

FWRestRows(aSaveLines)
RestArea(aArea)
Return lFail

//-------------------------------------------------------------------
/*/{Protheus.doc} A260GComp()
Função para recuperar a variavel estatica xCompet
@author rogerio.melonio
@since 01/09/2015
/*/
//-------------------------------------------------------------------
Function A260GComp()
Return xCompet

//-------------------------------------------------------------------
/*/{Protheus.doc} A260SComp()
Função para Atribuir na variavel estatica xCompet
@author rogerio.melonio
@since 01/09/2015
/*/
//-------------------------------------------------------------------
Function A260SComp(cValue)
xCompet := cValue
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CN260QtdThr()
Funcao utilizada para calcular a quantidade de threads a serem 
executadas em paralelo.
@author janaina.jesus
@since 21/06/2018
@version 1.0
@return aThreads
/*/
//-------------------------------------------------------------------
Static Function CN260QtdThr(cArqTrb,nThreads)
Local aAreaAnt   := GetArea()
Local aContratos := {}
Local aThreads   := {}
Local nX         := 0
Local nInicio    := 0
Local nRegProc   := 0

If Select(cArqTrb) > 0
	//-- Carrega Array com os contratos
	Do While (cArqTrb)->(!Eof())

		aAdd(aContratos,{	(cArqTrb)->CNF_COMPET, ;		//1
						  	(cArqTrb)->CNF_CONTRA, ;		//2
						  	(cArqTrb)->CNF_REVISA, ;		//3
						  	(cArqTrb)->CNA_NUMERO, ;		//4
						  	(cArqTrb)->CNF_PARCEL, ;		//5
						  	(cArqTrb)->CN9_FILIAL, ;		//6
						  	(cArqTrb)->CN9_NUMERO, ;		//7
						  	(cArqTrb)->MEDAUT	})			//8
		
		(cArqTrb)->(dbSkip())	
			
	EndDo
EndIf
	
//-- Verifica Limite Maximo de 40 Threads
If nThreads > 40
	nThreads := 40
EndIf

//-- Analisa a quantidade de Threads X nRegistros
If Len(aContratos) == 0
	aThreads := {}
ElseIf Len(aContratos) < nThreads
	aThreads := ARRAY(1)			// Processa somente em uma thread
Else
	aThreads := ARRAY(nThreads)		// Processa com o numero de threads informada
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o registro original de cada thread e     ³
//³ aciona thread gerando arquivo de fila.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX:=1 to Len(aThreads)

	aThreads[nX]:={"","",1}
    
	// Registro inicial para processamento
	nInicio  := IIf( nX == 1 , 1 , aThreads[nX-1,3]+1 )

	// Quantidade de registros a processar
	nRegProc += IIf( nX == Len(aThreads) , Len(aContratos) - nRegProc, Int(Len(aContratos)/Len(aThreads)) )
	
	aThreads[nX,1] := nInicio
	aThreads[nX,2] := nRegProc
	aThreads[nX,3] := nRegProc

Next nX

RestArea(aAreaAnt)
Return {aThreads,aContratos}

//-------------------------------------------------------------------
/*/{Protheus.doc} CNTA260JOB()
Funcao utilizada realizar gerar/encerrar medições por JOB (PERFORMANCE)
@author Janaina.Jesus
@since 21/06/2018
@version 1.0
@return Nil
/*/
//-------------------------------------------------------------------
Function CNTA260JOB(aThread,aContratos,cJobFile,cThread,cArqTrb, aParams)
Local nI         := 0
Local aItem      := {}
Local cOldMed    := ""
Local cNum       := ""
Local cEmp       := aParams[1]
Local cFil       := aParams[2]
Local xData      := aParams[3]
Local lMedPend   := aParams[4]
Local nStack     := aParams[5]
Local cTxLog     := aParams[6]
Local nTotMed    := aParams[7]
Local nTotEnc    := aParams[8]
Local lJob       := aParams[9]

PRIVATE lMsErroAuto := .F.

// Apaga arquivo ja existente
If File(cJobFile)
	fErase(cJobFile)
EndIf

// Criacao do arquivo de controle de jobs
nHd1 := MSFCreate(cJobFile)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("cGlb"+cEmp+cFil+cThread, "1" )
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3) 

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'GCT')

//Restaura a DataBase
dDatabase:= xData

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("cGlb"+cEmp+cFil+cThread, "2" )
GlbUnLock()

ConOut(dtoc(Date()) + " " + Time()+" Inicio do job de geração de medições CNTA260 " + cJobFile) //

For nI := aThread[1] to aThread[2]

	DbSelectArea("CN9")
	DbSetOrder(1)
	CN9->(dbSeek(xFilial("CN9")+aContratos[nI][7]+CnGetRevVg(aContratos[nI][7]),.T.))
	If AllTrim(CN9->CN9_SITUAC) == '09'
		Loop
	EndIf
	
	If(!VldMdGerada(aContratos[nI][7],aContratos[nI][4],Contratos[nI][5]))//Valida se mediçao já foi gerada
		Loop		
	EndIf

	lContinua := .T.
	lQuery    := .T.

	aCab := {}
	cNum := CriaVar("CND_NUMMED")
	aAdd(aCab,{"CND_CONTRA",aContratos[nI][2],NIL})
	aAdd(aCab,{"CND_REVISA",aContratos[nI][3],NIL})
	aAdd(aCab,{"CND_COMPET",aContratos[nI][1],NIL})
	aAdd(aCab,{"CND_NUMERO",aContratos[nI][4],NIL})
	aAdd(aCab,{"CND_NUMMED",cNum,NIL})
	aAdd(aCab,{"CND_PARCEL",aContratos[nI][5],NIL})

	ConOut(STR0003 + " - " + aCab[5,2])
	ConOut(STR0004 + " - " + aContratos[nI][2])
	ConOut(STR0005 + " - " + aContratos[nI][4])
	ConOut(STR0006 + " - " + aCab[3,2])

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa rotina automatica para gerar as medicoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CNTA120(aCab,aItem,3,.F.)
	If !lMsErroAuto
		cTxLog += STR0019+" - "+aCab[5,2]+CHR(13)+CHR(10)//"Medicao gerada com sucesso"
		cTxLog += STR0004+" - "+aContratos[nI][2]+CHR(13)+CHR(10)
		cTxLog += STR0022+" - "+aContratos[nI][6]+CHR(13)+CHR(10)
		cTxLog += STR0005+" - "+aContratos[nI][4]+CHR(13)+CHR(10)
		cTxLog += STR0006+" - "+aCab[3,2]+CHR(13)+CHR(10)

		ConOut(STR0007+aCab[5,2]+STR0008)

		nTotMed++
	Else
  		cOldMed := aCab[5,2]
		If lMedPend
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Quando houver erro na inclusao pesquisa medicoes  ³
			//³ verificando se existe algum registro nao encerrado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cArqTrb2	:= CriaTrab( nil, .F. )
			cQuery := "SELECT CND.CND_NUMMED,CND.CND_COMPET,CND.CND_NUMERO FROM "+ RetSQLName("CND") +" CND WHERE "
			cQuery += "CND.CND_FILIAL = '"+ xFilial("CND") +"' AND "
			cQuery += "CND.CND_CONTRA = '"+ aContratos[nI][2] +"' AND "
			cQuery += "CND.CND_REVISA = '"+ aContratos[nI][3] +"' AND "
			cQuery += "CND.CND_COMPET = '"+ aContratos[nI][1] +"' AND "
			cQuery += "CND.CND_DTFIM  = '        ' AND "
			cQuery += "CND.D_E_L_E_T_ = ' '"

			cQuery := ChangeQuery( cQuery )

			dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb2, .T., .T. )

			If !(cArqTrb2)->(Eof())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Substitui medicao para encerramento               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCab[3,2] := (cArqTrb2)->CND_COMPET
				aCab[4,2] := (cArqTrb2)->CND_NUMERO
				aCab[5,2] := (cArqTrb2)->CND_NUMMED
				lContinua := .T.
				lMsErroAuto:= .F.
			Else
				lContinua := .F.
			EndIf

			(cArqTrb2)->(dbCloseArea())
		Else
			lContinua := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera log de execucao                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTxLog += STR0009+" - "+cOldMed+CHR(13)+CHR(10)
		If lContinua
			cTxLog += STR0021+" - "+aCab[5,2]+CHR(13)+CHR(10)
		EndIf
		cTxLog += STR0004+" - "+aContratos[nI][2]+CHR(13)+CHR(10)
		cTxLog += STR0022+" - "+aContratos[nI][6]+CHR(13)+CHR(10)
		cTxLog += STR0005+" - "+aContratos[nI][4]+CHR(13)+CHR(10)
		cTxLog += STR0006+" - "+aCab[3,2]+CHR(13)+CHR(10)
		If !lContinua
			cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
		EndIf

		ConOut(STR0009 + aCab[5,2])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Retorna controle de numeracao                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While GetSX8Len() > nStack
			RollBackSX8()
		EndDo
	EndIf

	If lContinua

		ConOut(STR0010 + aCab[5,2])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa rotina automatica para encerrar as medicoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CNTA120(aCab,aItem,6,.F.)
		If !lMsErroAuto
			cTxLog += STR0020+CHR(13)+CHR(10)//"Medicao encerrada com sucesso"
			cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
			
			ConOut(STR0007+aCab[5,2]+STR0011)
			
			nTotEnc++
		Else
			cTxLog += STR0012+CHR(13)+CHR(10)
			cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
			
			ConOut(STR0012+aCab[5,2])

		EndIf
	EndIf
Next nI

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("cGlb"+cEmp+cFil+cThread,"3")
GlbUnLock()

// Fecha arquivo de controle do MATA179
fClose(nHd1)

ConOut(STR0013 + time())

cTxLog += STR0013 + time()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada apos a gravacao da medição automática   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CNT260GRV")
	ExecBlock("CNT260GRV",.F.,.F.)
EndIf

If lQuery
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa gravacao do arquivo de historico          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MemoWrite(Criatrab(,.f.)+".LOG",cTxLog)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Emite alerta com o log do processamento           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MEnviaMail("041",{cTxLog})
EndIf

//-- Incluir medição automatica de contratos recorrentes pela rotina CNTA121
CN260Exc121(lJob)

Return

/*/{Protheus.doc} GetQryTrb
 Gera uma consulta com as medicoes pendentes, executa e retorna um alias com o resultado.
@author philipe.pompeu
@since 22/07/2019
@return cArqTrb, retorna um alias com o resultado da consulta
@param dEndDate, date, descricao
@param lRecorre, logical, descricao
@param lNaoRecorr, logical, descricao
/*/
Static Function GetQryTrb(dEndDate,lRecorre, lNaoRecorr)
	Local cQuery   := ""
	Local cArqTrb := ""
	Local nDias    := GetNewPar( "MV_MEDDIAS", 0 )//Parametro que armazena a quantidade de dias de busca
	Local dDataI   := dEndDate-nDias//Data de inicio
	Local cCnt260Fil := 0
	Local cRetCNA		:= RetSQLName("CNA")
	Local cRetCN9		:= RetSQLName("CN9")
	Local cRetCN1		:= RetSQLName("CN1")
	Local cRetCNL		:= RetSQLName("CNL")
	Local cFilCN1		:= xFilial("CN1",cFilAnt	)
	Local cFilCN9		:= xFilial("CN9",cFilAnt)
	Local cFilCNA		:= xFilial("CNA",cFilAnt)

	Local cFilCNL		:= xFilial("CNL",cFilAnt)
	
	Default lRecorre := .F.	
	Default lNaoRecorr := .T.
	Default dEndDate := IIF(IsBlind(),Date(),dDataBase)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra parcelas de contratos automaticos ³
	//³ pendentes para a data atual              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTrb	:= CriaTrab( nil, .F. )
	cQuery := "SELECT * FROM ("
	If(lNaoRecorr)		
		cQuery += " SELECT DISTINCT CNF.CNF_COMPET,CNF.CNF_CONTRA,CNF.CNF_REVISA,CNA.CNA_NUMERO,CNF.CNF_PARCEL,CN9.CN9_FILIAL,CN9.CN9_NUMERO, "
		cQuery += "(CASE WHEN CNL.CNL_MEDAUT = '0' THEN CN1.CN1_MEDAUT ELSE CNL.CNL_MEDAUT END)  MEDAUT "
		cQuery += "FROM " + RetSQLName("CNF") + " CNF, " + RetSQLName("CNA") + " CNA, "+ RetSQLName("CN9") +" CN9, "+ RetSQLName("CN1") +" CN1, "+ RetSQLName("CNL") +" CNL WHERE "
		cQuery += "CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
		cQuery += "CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND "
		cQuery += "CN9.CN9_FILIAL = '"+ xFilial("CN9") +"' AND "
		cQuery += "CN1.CN1_FILIAL = '"+ xFilial("CN1") +"' AND "
		cQuery += "CNF.CNF_NUMERO = CNA.CNA_CRONOG AND "
		cQuery += "CNF.CNF_CONTRA = CNA.CNA_CONTRA AND "
		cQuery += "CNF.CNF_REVISA = CNA.CNA_REVISA AND "
		cQuery += "CNF.CNF_CONTRA = CN9.CN9_NUMERO AND "
		cQuery += "CNF.CNF_REVISA = CN9.CN9_REVISA AND "
		cQuery += "CN9.CN9_TPCTO  = CN1.CN1_CODIGO AND "
		cQuery += "CN9.CN9_SITUAC = '"+ DEF_SVIGE +"' AND "
		cQuery += "CNF.CNF_PRUMED >= '"+ DTOS(dDataI) +"' AND "
		cQuery += "CNF.CNF_PRUMED <= '"+ DTOS(dEndDate) +"' AND "
		cQuery += "CNF.CNF_SALDO  > 0 AND "
		cQuery += "CNA.CNA_SALDO  > 0 AND "
		cQuery += "CNF.D_E_L_E_T_ = ' ' AND "
		cQuery += "CNA.D_E_L_E_T_ = ' ' AND "
		cQuery += "CN1.D_E_L_E_T_ = ' '"
		//Ponto de Entrada para utilização de Filtros específicos
		If ExistBlock("CNT260FIL")
			cCnt260Fil := ExecBlock("CNT260FIL",.F.,.F.)
			If ValType(cCnt260Fil) == "C" .And. !Empty(cCnt260Fil)
				cQuery += " AND "+ cCnt260Fil
			EndIf
		EndIf
	EndIf
	
	If(lRecorre .And. lNaoRecorr)
		cQuery += " UNION "
	EndIf
	
	If(lRecorre)
		cQuery += " SELECT CNA.CNA_PROMED AS CNF_COMPET,'RECORRENTE' AS CNF_CONTRA,CN9.CN9_REVISA AS CNF_REVISA,CNA.CNA_NUMERO,CNA.CNA_PROPAR AS CNF_PARCEL,CN9.CN9_FILIAL,CN9.CN9_NUMERO, "
		cQuery += " ( CASE WHEN CNL.CNL_MEDAUT = '0' THEN CN1.CN1_MEDAUT ELSE CNL.CNL_MEDAUT END)  MEDAUT "
		cQuery += " FROM " + cRetCNA + " CNA, "+ cRetCN9+" CN9, "+ cRetCN1 + " CN1, " + cRetCNL + " CNL "
		cQuery += " WHERE "
		cQuery += " CNA.CNA_FILIAL = '" + cFilCNA +"' AND "
		cQuery += " CNA.CNA_CONTRA = CN9.CN9_NUMERO AND "
		cQuery += " CNA.CNA_REVISA = CN9.CN9_REVISA AND "
		cQuery += " CNA.CNA_PERIOD <> ' ' AND " + CRLF
		cQuery += " CNA.CNA_PROMED >= '" + DTOS(dDataI)+ "' AND "
		cQuery += " CNA.CNA_PROMED <= '" + DTOS(dEndDate) + "' AND "
		cQuery += " CNA.D_E_L_E_T_ = ' ' AND "
	
		cQuery += " CN9.CN9_FILIAL = '"+ cFilCN9 +"' AND "
		cQuery += " CN9.CN9_SITUAC = '"+ DEF_SVIGE +"' AND "
		cQuery += " CN9.D_E_L_E_T_ = ' ' AND "
	
		cQuery += " CN1.CN1_FILIAL = '"+ cFilCN1 +"' AND "
		cQuery += " CN1.CN1_CODIGO = CN9.CN9_TPCTO AND "
		cQuery += " CN1.D_E_L_E_T_ = ' ' AND "
	
		cQuery += " CNL.CNL_FILIAL = '"+ cFilCNL +"' AND "
		cQuery += " CNL.CNL_CODIGO = CNA.CNA_TIPPLA AND "
		cQuery += " CNL.D_E_L_E_T_ = ' ' "
	EndIf

	cQuery += ") CN9 "
	cQuery += "WHERE MEDAUT = '1' "

	cQuery := ChangeQuery( cQuery )

	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )
		
Return cArqTrb

/*/{Protheus.doc} VldMdGerada
	Valida se a medicao da <cParcel> ja foi realizada.
@author philipe.pompeu
@since 22/07/2019
@return lReturn, se <cParcel> nao foi gerada retorna .T.
@param cContra, caractere, numero do contrato
@param cPlan, caractere, planilha do contrato
@param cParcel, caractere, parcela da planilha
/*/
Static Function VldMdGerada(cContra, cPlan, cParcel)
	Local lReturn := .F.
	Local cUmAlias:= GetNextAlias()
	
	BeginSQL Alias cUmAlias
		SELECT CND.CND_NUMMED
		FROM 	%Table:CND% CND
		WHERE	CND.CND_FILIAL = %xFilial:CND% AND CND.CND_CONTRA = %Exp:cContra% AND CND.CND_NUMERO = %Exp:cPlan% AND
				CND.CND_PARCEL = %Exp:cParcel% AND CND.%NotDel%
	EndSQL
		
	lReturn := (cUmAlias)->(EOF())
	(cUmAlias)->(dbCloseArea())
Return lReturn