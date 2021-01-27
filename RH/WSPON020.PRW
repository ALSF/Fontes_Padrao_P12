#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSPON020.CH"
//ws http://172.16.31.46:82/ws/RHSCHEDULECHART.apw?WSDL
Function WSPON020()
Return

WSSTRUCT TScheduleChartList
	WSDATA Branch				AS String
	WSDATA Registration			AS String
	WSDATA DateEvent			AS String
	WSDATA DayWeek				AS String
	WSDATA Entry1				AS String	
	WSDATA Entry2				AS String
	WSDATA Entry3				AS String
	WSDATA Entry4				AS String
	WSDATA Output1				AS String	
	WSDATA Output2				AS String
	WSDATA Output3				AS String	
	WSDATA Output4 	   			AS String
	WSDATA DayType				AS String	
	WSDATA OvertimeTypeNight	AS String
	WSDATA OvertimeTypeRegular	AS String
	WSDATA Exception			AS String
	WSDATA Shift				AS String
	WSDATA Sequence				AS String
	WSDATA WorkHrs				AS String
	WSDATA IntHrs				AS String
	WSDATA MealCode				AS String
ENDWSSTRUCT

WSSTRUCT TScheduleChartFields 
	WSDATA Name		 			AS String
	WSDATA Department			AS String
	WSDATA CostCenter			AS String
	WSDATA Branch				AS String
	WSDATA Shift				AS String
	WSDATA PeriodFrom			AS String
	WSDATA PeriodTo				AS String	
ENDWSSTRUCT 

WSSTRUCT TScheduleChartBrowse
	WSDATA Itens		AS Array Of TScheduleChartList		OPTIONAL
	WSDATA Fields		AS Array Of TScheduleChartFields	OPTIONAL
ENDWSSTRUCT

WSSERVICE RHScheduleChart DESCRIPTION "Tabela de Horários"
	WSDATA Branch				AS String
	WSDATA Registration			AS String

	WSDATA ScheduleChartBrowse	As TScheduleChartBrowse
	
	WSMETHOD GetScheduleChart	DESCRIPTION "Método de consulta da tabela de horarios do funcionario"
ENDWSSERVICE                                  

WSMETHOD GetScheduleChart;
WSRECEIVE Branch, Registration;
WSSEND ScheduleChartBrowse;
WSSERVICE RHScheduleChart	
	Local lRet			:= .T.
	Local lTerminal		:= .T.
	Local lPortal		:= .T.
	Local cFilTerminal	:= Self:Branch
	Local cMatTerminal	:= Self:Registration
	Local aRetPortal	:= {}
	Local aTabCalend	:= {}
	Local nTam			:= 0
	Local nLen         	:= 0
	Local nX			:= 0
	Local nX2			:= 0
	
	Local cBrc			:= ""
	Local cDet			:= ""
	Local cOrd			:= ""
	Local cData			:= ""
	Local cDia			:= ""
	Local cTipoDia		:= ""
	Local cHora1		:= ""
	Local cHora2		:= ""
	Local cHora3		:= ""
	Local cHora4		:= ""
	Local cHora5		:= ""
	Local cHora6		:= ""
	Local cHora7		:= ""
	Local cHora8		:= ""
	Local cHrTrab		:= ""
	Local cHrInte		:= ""
	Local cHeNorm		:= ""
	Local cHeNotu		:= ""
	Local cExcecao  	:= ""
	Local cTurno		:= ""
	Local cSequenc		:= ""
	Local cCodRef		:= ""
	Local cDescRef		:= ""
	Local nHrTrab		:= 0.00
	Local nHrInte		:= 0.00
	Local nOrdIni		:= 0.00
	Local nOrdFim		:= 0.00
	Local nVezes		:= 0.00
	Local nTab			:= 0.00
	Local nPos			:= 0.00
	Local nTamCpoRef	:= Len( SP1->P1_DESC )
	Local bCloseFiles:= {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }
	Local aFilesOpen :={"SP5", "SP8","SPB","RFF","SPC", "RFE"}
	              
	dbSelectArea("SRA")
	SRA->(dbSetOrder(1))
	SRA->(dbSeek(cFilTerminal+cMatTerminal))
	
	u_PonQdHr( lTerminal , cFilTerminal , cMatTerminal, lPortal, @aRetPortal )
	nTam	:= Len(aRetPortal)
	If nTam > 0
		aTabCalend 	:= aClone(aRetPortal[1,1])
		nLen		:= Len(aTabCalend)
		
		nOrdIni := Val( aTabCalend[  01  , 02 ] )
		nOrdFim := Val( aTabCalend[ nLen , 02 ] )
		
		nVezes := ( ( nOrdFim - nOrdIni ) + 1 )
		
		For nX := nOrdIni To nVezes
			cOrd := StrZero( nX , 2 )
			nHrTrab 	:= 0.00
			nHrInte		:= 0.00
			lZebrado	:= ( nX%2 == 0.00 )		
			cHora1		:= ""
			cHora2		:= ""
			cHora3		:= ""
			cHora4		:= ""
	   		cHora5		:= ""
			cHora6		:= ""
	   		cHora7		:= ""
	   		cHora8		:= ""
			If ( nPos := aScan( aTabCalend , { |x| x[2] == cOrd .and. x[4] == "1E" } ) ) > 0.00
				aEval( aTabCalend , { |x| If( x[2] == cOrd , ( nHrTrab := SomaHoras( nHrTrab , x[7] ), nHrInte := SomaHoras( nHrInte , x[9] ) ) , NIL ) } )
				For nTab := nPos To nLen
					If aTabCalend[ nTab , 2 ] == cOrd
						If nTab == nPos
							cData	:= Dtoc( aTabCalend[ nTab , 1 ] )
							cDia	:= DiaSemana( aTabCalend[ nTab , 1 ] , 3 )
							If nHrTrab > 0.00
								cHora1	:= StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							EndIf
							IF !aTabCalend[ nTab , 19 ]	//Se Nao For Feriado
								IF aTabCalend[ nTab , 06 ]  == "S"
									cTipoDia := STR0001 //"Trabalhado"
								ElseIf aTabCalend[ nTab , 06 ]  == "N"
									cTipoDia := STR0002	//"Nao Trabalhado"
								ElseIf aTabCalend[ nTab , 06 ]  == "D"	
									cTipoDia := STR0003	//"D.S.R."
								ElseIf aTabCalend[ nTab , 06 ]  == "C"
									cTipoDia := STR0004	//"Compensado"
								EndIf
								fTipoExtra( aTabCalend[ nTab , 12 ] , @cHeNorm )
								fTipoExtra( aTabCalend[ nTab , 13 ] , @cHeNotu )
							Else
								If mv_par09 == 1.00 .or. ( mv_par09 == 2 .and. SPA->PA_FERIADO != "S" )
									cTipoDia	:= STR0005	//"Feriado"
									fTipoExtra( aTabCalend[ nTab , 20 ] , @cHeNorm )
									fTipoExtra( aTabCalend[ nTab , 21 ] , @cHeNotu )
								Else
									cTipoDia := STR0001 //"Trabalhado"
									fTipoExtra( aTabCalend[ nTab , 12 ] , @cHeNorm )
									fTipoExtra( aTabCalend[ nTab , 13 ] , @cHeNotu )
								EndIf
							EndIf
							
							cExcecao	:= If( aTabCalend[ nTab , 10 ] == "E" , "Sim" , "Nao" )
							cTurno		:= aTabCalend[ nTab , 14 ]
							cSequenc	:= aTabCalend[ nTab , 08 ]
							cCodRef		:= aTabCalend[ nTab , 18 ]
							If lTerminal
								cDescRef := AllTrim( fDesc("SP1",aTabCalend[ nTab , 18 ],"P1_DESC") )
								cDescRef := StrTran( cDescRef , "@" , "" )
								cDescRef := Capital( cDescRef )
								cDescRef := cDescRef + Space( nTamCpoRef - Len( cDescRef ) )
								cCodRef += " - " + cDescRef
							EndIf	
						Else
							If nHrTrab > 0.00 .AND. aTabCalend[nTab,4] == '1S'
								cHora2 := StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							ElseIf nHrTrab > 0.00  .AND. aTabCalend[nTab,4] == '2E'
								cHora3 := StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							ElseIf nHrTrab > 0.00  .AND. aTabCalend[nTab,4] == '2S'
								cHora4 := StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							ElseIf nHrTrab > 0.00  .AND. aTabCalend[nTab,4] == '3E'
								cHora5 := StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							ElseIf nHrTrab > 0.00  .AND. aTabCalend[nTab,4] == '3S'
								cHora6 := StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							ElseIf nHrTrab > 0.00  .AND. aTabCalend[nTab,4] == '4E'
								cHora7 := StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							ElseIf nHrTrab > 0.00  .AND. aTabCalend[nTab,4] == '4S'
								cHora8 := StrTran(StrZero(aTabCalend[nTab,3],5,2),".",":")
							EndIf
						EndIf	
					Else				   
						cHrTrab  := StrTran(StrZero(nHrTrab,5,2),".",":")
						cHrInte  := StrTran(StrZero(nHrInte,5,2),".",":")
										
						oItem	:= WSClassNew("TScheduleChartList")
				
						oItem:Branch				:= cFilTerminal
						oItem:Registration          := cMatTerminal
						oItem:DateEvent				:= cData
						oItem:DayWeek				:= cDia
						oItem:Entry1				:= cHora1
						oItem:Output1				:= cHora2					
						oItem:Entry2				:= cHora3
						oItem:Output2				:= cHora4
						oItem:Entry3				:= cHora5
						oItem:Output3				:= cHora6
						oItem:Entry4				:= cHora7
						oItem:Output4				:= cHora8
						oItem:DayType				:= cTipoDia
						oItem:OvertimeTypeNight		:= cHeNorm
						oItem:OvertimeTypeRegular	:= cHeNotu
						oItem:Exception				:= cExcecao
						oItem:Shift					:= cTurno
						oItem:Sequence				:= cSequenc
						oItem:WorkHrs				:= cHrTrab
						oItem:IntHrs				:= cHrInte
						oItem:MealCode				:= cCodRef
						
						AAdd(Self:ScheduleChartBrowse:Itens, oItem)
						Exit
					EndIf
				Next nTab
			EndIf
		Next nX
		
		//Imprime o Ultimo dia  	
		oItem	:= WSClassNew("TScheduleChartList")
				
		oItem:Branch				:= cFilTerminal
		oItem:Registration          := cMatTerminal
		oItem:DateEvent				:= cData
		oItem:DayWeek				:= cDia
		oItem:Entry1				:= cHora1
		oItem:Output1				:= cHora2					
		oItem:Entry2				:= cHora3
		oItem:Output2				:= cHora4
		oItem:Entry3				:= cHora5
		oItem:Output3				:= cHora6
		oItem:Entry4				:= cHora7
		oItem:Output4				:= cHora8
		oItem:DayType				:= cTipoDia
		oItem:OvertimeTypeNight		:= cHeNorm
		oItem:OvertimeTypeRegular	:= cHeNotu
		oItem:Exception				:= cExcecao
		oItem:Shift					:= cTurno
		oItem:Sequence				:= cSequenc
		oItem:WorkHrs				:= cHrTrab
		oItem:IntHrs				:= cHrInte
		oItem:MealCode				:= cCodRef
		
		AAdd(Self:ScheduleChartBrowse:Itens, oItem)
		
		//Imprime os dados do Funcionario
		oFields	:= WSClassNew("TScheduleChartFields")
		
		oFields:Name				:= SRA->RA_NOME
		oFields:Department			:= SRA->RA_DEPTO+" - "+fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC')
		oFields:CostCenter			:= SRA->RA_CC+" - "+fDesc("CTT",SRA->RA_CC,"CTT_DESC01",,SRA->RA_FILIAL)
		oFields:Branch				:= SRA->RA_FILIAL
		oFields:Shift				:= SRA->RA_TNOTRAB + "/" + SRA->RA_SEQTURN
		oFields:PeriodFrom			:= Dtoc(aRetPortal[1,2])
		oFields:PeriodTo			:= Dtoc(aRetPortal[1,3])
			
	    AAdd(Self:ScheduleChartBrowse:Fields, oFields)
	Else
		lRet := .F.
		If Empty(GetPaponta(cFilTerminal)) .Or. Empty(GetPonMes(cFilTerminal))
			SetSoapFault("GetScheduleChart", "Certifique-se de que existe período de apontamento configurado para a filial " + cFilTerminal +" . MV_PONMES / MV_PAPONTA.")
		Else
			SetSoapFault("GetScheduleChart", "Funcionário sem tabela de horário cadastrada.")
		EndIf
	EndIf
	Aeval(aFilesOpen, bCloseFiles) 
Return lRet