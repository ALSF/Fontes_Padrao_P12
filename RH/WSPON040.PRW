#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSPON040.CH"
#INCLUDE "PONCALEN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WSPON040 ³ Autor ³ Leandro Drumond                  ³ Data ³ 09/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Espelho de Ponto                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista        ³ Data       ³ FNC ou REQ     ³ 	Motivo da Alteracao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³ Willian U.      ³20/07/17    ³DRHPONTP-213    ³Retirado função ChkFile, que      ³±±
±±³                 ³            ³                ³fazia a verificação para abrir a  ³±±
±±³                 ³            ³                ³tabela em modo exclusivo.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function WSPON040()
Return

WSSTRUCT TAttendControlList
	WSDATA Branch						AS String
	WSDATA Registration					AS String
	WSDATA DateEvent					AS String
	WSDATA DayWeek						AS String
	WSDATA Marks           				AS ARRAY OF TMarkList OPTIONAL
	WSDATA BonusReason					AS String
	WSDATA Observations					AS String
	WSDATA Update						AS String
ENDWSSTRUCT

WSSTRUCT TMarkList
	WSDATA MarksItens	 					AS String
	WSDATA MarksType	 					AS String
	WSDATA Observation						AS String
	WSDATA RequestRec						AS String
ENDWSSTRUCT

WSSTRUCT TPeriodList
	WSDATA Fielter	 					AS String	
	WSDATA ValueFielter	 				AS String
ENDWSSTRUCT

WSSTRUCT TAttendControlFields 
	WSDATA Name		 					AS String
	WSDATA Department						AS String
	WSDATA CostCenter						AS String
	WSDATA Branch							AS String
	WSDATA Registration					AS String	
ENDWSSTRUCT 

WSSTRUCT TAttendControlBrowse
	WSDATA Itens							AS Array Of TAttendControlList		OPTIONAL
	WSDATA Fields							AS Array Of TAttendControlFields	OPTIONAL
	WSDATA Periods						AS Array Of TPeriodList				OPTIONAL	
	WSDATA PeriodView						AS String	OPTIONAL
	WSDATA PeriodFielter					AS String
	WSDATA TotMarc						AS Integer OPTIONAL
ENDWSSTRUCT

WSSERVICE RHAttendControl DESCRIPTION STR0001 //"Tabela de Espelho de Ponto"
	WSDATA Branch							AS String
	WSDATA Registration					AS String
	WSDATA CurrentPage					AS Integer 	OPTIONAL
	WSDATA FilterField  				AS String 	OPTIONAL
	WSDATA FilterValue					AS String 	OPTIONAL
	WSDATA PerBloqMsg					AS String 	OPTIONAL
	WSDATA WsNull                	   	AS String	OPTIONAL
	
	WSDATA AttendControlBrowse			AS TAttendControlBrowse
	
	WSMETHOD GetAttendControl			DESCRIPTION STR0002 //"Método de consulta da tabela de espelho de ponto do funcionário."
	WSMETHOD GetPeriods             	DESCRIPTION STR0003 //"Método que capta os períodos cadastrados no SIGAPON"
	WSMETHOD GetPerBloq					DESCRIPTION STR0009 //"Método para verificar se o período de apontamento está disponível."
ENDWSSERVICE 

WSMETHOD GetAttendControl;
WSRECEIVE Branch, Registration, CurrentPage, FilterField, FilterValue;
WSSEND AttendControlBrowse;
WSSERVICE RHAttendControl
	Local lRet					:= .T.
	Local lTerminal				:= .T.
	Local lPortal				:= .T.	
	Local lReturn				:= .F. // .T. Retorno Logico Quando Validacao e .F. retorna os periodos
	Local cFilTerminal			:= Self:Branch
	Local cMatTerminal			:= Self:Registration
	Local cPerAponta
	Local cQueryAlias 			:= GetNextAlias()
	Local aRetPortal			:= {}
	Local nTam, nTam1, nX, nY, nI	  
	Local nAbHora				:= 0	
	Local nNumPerAnt			:= 1	// Numero de Periodos a Serem Listados ou somente a qtde desde admissao	
	Local cOcorr
	Local cAbHora
	Local cPeriodo
	Local cAliasMarc			:= "SP8"
	Local aInterval				:= {}
	Local aMarcAux				:= {}  
	Local aPonMes 				:= StrToKarr( SuperGetMv( "MV_PONMES" , NIL , DToS(Date()) + "/" + DToS(Date()), cFilTerminal ) , "/" )
	Local lGetMarcAuto			:= ( SuperGetMv( "MV_GETMAUT" , NIL , "S" , cFilTerminal ) == "S" )
	Local nTotMarc				:= SuperGetmv("MV_COLMARC") * 2
	Local nTotAux				:= 0 
	Local nTamM					:= 0
	Local nDAberto				:= SuperGetMv( "MV_DABERTO" , NIL , 0) 	//Dias apos fim do periodo onde permite-se manutenção
	Local nDFechado				:= SuperGetMv( "MV_DFECHAD" , NIL , 0)	//Dias após periodo de manutenção onde permite-se apenas visualização
	Local lAltera				:= .T.
	Local bCloseFiles:= {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }
	Local aFilesOpen :={"SP5", "SP8","SPB","RFF","SPC", "RFE"}
	
	Private aMarcacoes			:= {}
	Private aTabCalend  		:= {}
	Private aTabPadrao			:= {}
	Private aRecsMarcAutDele	:= {}
	Private dPerIni     		:= Ctod("//")
	Private dPerFim     		:= Ctod("//")
	
	aPeriods	:= GetPerAponta( nNumPerAnt , cFilTerminal , cMatTerminal, lReturn)
	dPerIni 	:= aPeriods[1,1]
	dPerFim     := aPeriods[1,2]
	
	//Quando periodo acabou e ainda não esta fechado, database será maior que fim do período
	If dDataBase > dPerFim
		If dDataBase <= dPerFim + nDAberto
			lAltera := .T. //Dentro do período de alteração
		Else
			lAltera := .F. //Mesmo que database seja maior que o período de visualização, se ponto ainda não foi fechado, permite visualização, pois não existe o próximo periodo aberto
		EndIf
	//Quando periodo foi fechado, mas database ainda esta dentro do período de visualização, retorna periodo anterior para montagem das marcações
	ElseIf dDataBase - (nDAberto + nDFechado) <= dPerIni
		//Obtem período anterior
		PerAponta(@dPerIni,@dPerFim, (dDataBase - (nDAberto + nDFechado)))
		aPeriods[1,1] := dPerIni
		aPeriods[1,2] := dPerFim
		aPonMes[1]	  := DtoS(dPerIni)
		aPonMes[2] 	  := Dtos(dPerFim)
	 	lAltera 	  := .F.
	 	cAliasMarc 	  := "SPG" //Busca informações do acumulados
	EndIf
	
	aInterval := DaysBetwDates( SToD(aPonMes[1]) , SToD(aPonMes[2]) , .T. )
			
	If Self:FilterValue == Nil		
   		cPerAponta	:= DtoS(aPeriods[1,1])+DtoS(aPeriods[1,2])
		cPeriodo	:= DtoC(aPeriods[1,1])+' - '+DtoC(aPeriods[1,2])
    Else
    	cPerAponta	:= Self:FilterValue
    	cPeriodo	:= DtoC(SToD(Left(Self:FilterValue, 8))) +" - "+ DtoC(SToD(Right(Self:FilterValue, 8)))
    EndIf
       	                                                    
	dbSelectArea("SRA")
	SRA->(dbSetOrder(1))
	If SRA->(dbSeek(cFilTerminal+cMatTerminal))
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega o Calendario de Marcacoes do Funcionario            ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		GetMarcacoes(	@aMarcacoes			,;	//01 -> Marcacoes do Funcionario
						@aTabCalend			,;	//02 -> Calendario de Marcacoes
						@aTabPadrao			,;	//03 -> Tabela Padrao
						NIL     			,;	//04 -> Turnos de Trabalho
						dPerIni				,;	//05 -> Periodo Inicial
						dPerFim				,;	//06 -> Periodo Final
						SRA->RA_FILIAL		,;	//07 -> Filial
						SRA->RA_MAT			,;	//08 -> Matricula
						SRA->RA_TNOTRAB		,;	//09 -> Turno
						SRA->RA_SEQTURN		,;	//10 -> Sequencia de Turno
						SRA->RA_CC			,;	//11 -> Centro de Custo
						cAliasMarc			,;	//12 -> Alias para Carga das Marcacoes
						.T.					,;	//13 -> Se carrega Recno em aMarcacoes
						.T.		 			,;	//14 -> Se considera Apenas Ordenadas
						NIL					,;  //15 -> Verifica as Folgas Automaticas
						NIL  				,;  //16 -> Se Grava Evento de Folga Mes Anterior
						lGetMarcAuto		,;	//17 -> Se Carrega as Marcacoes Automaticas
						@aRecsMarcAutDele	)	//18 -> Registros de Marcacoes Automaticas que deverao ser Deletados
					  
	EndIf

	BEGINSQL ALIAS cQueryAlias
		SELECT RS3_DATA, RS3_HORA, RS3_STATUS, RS3_JUSTIF, RS3_CODIGO 
		FROM %table:RS3% RS3
		WHERE RS3_FILIAL = %exp:SRA->RA_FILIAL% AND
		RS3_MAT = %exp:SRA->RA_MAT% AND
		RS3_DATA >= %exp:DtoS(dPerIni)% AND
		RS3_DATA <= %exp:DtoS(dPerFim)% AND
		RS3_STATUS <> '2' AND
		RS3.%notDel%
		ORDER BY RS3_FILIAL, RS3_MAT, RS3_DATA, RS3_HORA
	ENDSQL
	
	While (cQueryAlias)->(!Eof())
		(cQueryAlias)->(aAdd(aMarcAux,{StoD(RS3_DATA),StrTran(StrZero(RS3_HORA,5,2),".", ":"),If(RS3_STATUS=="0","P","A"),RS3_JUSTIF, RS3_CODIGO, StoD(RS3_DATA)}))
		(cQueryAlias)->(DbSkip())
	EndDo
	
	(cQueryAlias)->(DbCloseArea())
	
	nTamM	:= Len(aMarcacoes)
	
	For nY := 1 To nTamM
		If aMarcacoes[ nY , AMARC_TPMCREP ] <> "D" .and. aMarcacoes[ nY , AMARC_FLAG] <> "P" //Ignora marcacoes desconsideradas e incluidas pelo portal, esta última ja foi carregada da tabela RS3
			aAdd(aMarcAux,{aMarcacoes[nY,AMARC_DATA], StrTran(StrZero(aMarcacoes[ nY , AMARC_HORA ],5,2),".", ":"),iif(aMarcacoes[ nY , AMARC_TIPOREG ]=="P","I",aMarcacoes[ nY , AMARC_TIPOREG ]),"","0",aMarcacoes[ nY , AMARC_DATAAPO ] })
		EndIf		
	Next nY
	
	aSort(aMarcAux,,,{|x,y| DtoS(x[1])+x[2] < DtoS(y[1])+y[2]})			
	
	nTam	:= Len(aInterval)
	nTamM	:= Len(aMarcAux)
	                                    
	Self:AttendControlBrowse:Itens := {}
	For nX := 1 To nTam
			
		AAdd(Self:AttendControlBrowse:Itens, WSClassNew("TAttendControlList"))		
		Self:AttendControlBrowse:Itens[nX]:Branch				:= cFilTerminal
		Self:AttendControlBrowse:Itens[nX]:Registration        	:= cMatTerminal
		Self:AttendControlBrowse:Itens[nX]:DateEvent			:= DToC(aInterval[nX,1])
		Self:AttendControlBrowse:Itens[nX]:DayWeek				:= Upper(DiaSemana(aInterval[nX,1],3))		
		Self:AttendControlBrowse:Itens[nX]:Observations			:= "" 
		Self:AttendControlBrowse:Itens[nX]:Marks				:= {}
		Self:AttendControlBrowse:Itens[nX]:BonusReason        	:= ""
		Self:AttendControlBrowse:Itens[nX]:Update	        	:= If(!lAltera,"2",If(DtoS(aInterval[nX,1]) <= DtoS(dDataBase),"1","2"))
		
		nI := 0

		//Inseri o total de marcacoes que houver
		For nY := 1 To nTamM
			If aMarcAux[ nY , 6 ] == aInterval[nX,1]		
				nI++
				AAdd(Self:AttendControlBrowse:Itens[nX]:Marks, WSClassNew("TMarkList"))		
				Self:AttendControlBrowse:Itens[nX]:Marks[nI]:MarksItens := aMarcAux[ nY , 2 ]
				Self:AttendControlBrowse:Itens[nX]:Marks[nI]:MarksType	:= aMarcAux[ nY , 3 ]
				Self:AttendControlBrowse:Itens[nX]:Marks[nI]:Observation:= aMarcAux[ nY , 4 ]
				Self:AttendControlBrowse:Itens[nX]:Marks[nI]:RequestRec	:= aMarcAux[ nY , 5 ]
				
			EndIf
			If aMarcAux[nY,6] > aInterval[nX,1]
				Exit
			EndIf
		Next nY
		If nI > nTotMarc
			nTotMarc := nI
			If !(nTotMarc%2 == 0)
				nTotMarc += 1
			Endif
		EndIf			
	Next nX
	Self:AttendControlBrowse:TotMarc		:= nTotMarc
	Self:AttendControlBrowse:PeriodView		:= cPeriodo
	Self:AttendControlBrowse:PeriodFielter	:= cPerAponta
	Aeval(aFilesOpen, bCloseFiles) 
Return lRet

WSMETHOD GetPeriods;
WSRECEIVE Branch, Registration;
WSSEND AttendControlBrowse;
WSSERVICE RHAttendControl	
	Local lRet			:= .T.
	Local lReturn		:= .F. // .T. Retorno Logico Quando Validacao e .F. retorna os periodos
	Local nX			:= 0
	Local nI			:= 0
	Local nTam			:= 0        
	Local nIni			:= 1
	Local nNumPerAnt	:= 1	// Numero de Periodos a Serem Listados ou somente a qtde desde admissao	
	Local cFilTerminal	:= Self:Branch
	Local cMatTerminal	:= Self:Registration
	Local aPeriods		:= {}
	
	aPeriods	:= GetPerAponta( nNumPerAnt , cFilTerminal , cMatTerminal, lReturn, NIL, NIL, RetPerSPO( cFilTerminal ) )
	nTam		:= Len(aPeriods)
		
	For nI := nTam To nIni Step -1
		nX += 1
		AAdd(Self:AttendControlBrowse:Periods, WSClassNew("TPeriodList"))		
		Self:AttendControlBrowse:Periods[nX]:Fielter			:= DtoS(aPeriods[nI,1])+DtoS(aPeriods[nI,2])
		Self:AttendControlBrowse:Periods[nX]:ValueFielter		:= DtoC(aPeriods[nI,1])+' - '+DtoC(aPeriods[nI,2])	
	Next nI	
	   
Return lRet


WSMETHOD GetPerBloq WSRECEIVE WsNull WSSEND PerBloqMsg WSSERVICE RHAttendControl
	Local lRet := .T.
	
	Self:PerBloqMsg := PorEncode(STR0006)
	
	// --------------------------------------
	// - Informa que é chamado para o Portal
	// - .T.
	// --------------------------------------
	If BloqPer(.T.)
		lRet := .F.

		Self:PerBloqMsg := PorEncode(STR0007)
		SetSoapFault("GetPerBloq",PorEncode(STR0008))
	EndIf

Return lRet
