#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSPON030.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WSPON030 ³ Autor ³ Emerson Campos                   ³ Data ³ 04/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Espelho de Ponto                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista        ³ Data       ³ FNC ou REQ     ³ 	Motivo da Alteracao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Emerson Campos   ³ 04/09/2012 ³ Req126-12      ³ Adaptar o fonte para apresentar o³±±
±±³                 ³            ³                ³ espelho de ponto para a fase 4.  ³±±
±±³                 ³            ³                ³                                  ³±±
±±³Allyson M        ³ 25/07/2014 ³ TQCPCK         ³ Ajuste p/ listar os periodos que ³±±
±±³                 ³            ³                ³ foram fechados. Esse processo e' ³±±
±±³                 ³            ³                ³ o mesmo do Rh Online.            ³±±
±±³Eduardo K        ³ 08/02/2018 ³ MPRIMESP-13747 ³ Ajuste p/ exibir a qtde de demons³±±
±±³                 ³            ³                ³ trativos de acordo com o param.  ³±±
±±³                 ³            ³                ³ MV_TCFMARC.    			         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function WSPON030()
Return

WSSTRUCT TAnotationsList
	WSDATA Branch				AS String
	WSDATA Registration			AS String
	WSDATA DateEvent			AS String
	WSDATA DayWeek				AS String
	WSDATA Marks           		AS ARRAY OF TMarksList OPTIONAL
	WSDATA BonusReason			AS String
	WSDATA HoursMarkType		AS String
	WSDATA Observations			AS String
ENDWSSTRUCT

WSSTRUCT TMarksList
	WSDATA MarksItens	 		AS String
ENDWSSTRUCT

WSSTRUCT TPeriodsList
	WSDATA Fielter	 			AS String	
	WSDATA ValueFielter	 		AS String
ENDWSSTRUCT

WSSTRUCT TAnotationsFields 
	WSDATA Name		 			AS String
	WSDATA Department			AS String
	WSDATA CostCenter			AS String
	WSDATA Branch				AS String
	WSDATA Registration			AS String	
ENDWSSTRUCT 

WSSTRUCT TAnotationsBrowse
	WSDATA Itens				AS Array Of TAnotationsList		OPTIONAL
	WSDATA Fields				AS Array Of TAnotationsFields	OPTIONAL
	WSDATA Periods				AS Array Of TPeriodsList		OPTIONAL	
	WSDATA PeriodView			AS String	OPTIONAL
	WSDATA PeriodFielter		AS String
ENDWSSTRUCT

WSSERVICE RHAnotations DESCRIPTION STR0001 //"Tabela de Espelho de Ponto"
	WSDATA Branch				AS String
	WSDATA Registration			AS String
	WSDATA CurrentPage			As Integer	OPTIONAL
	WSDATA FilterField  		As String	OPTIONAL
	WSDATA FilterValue			As String	OPTIONAL
	
	WSDATA AnotationsBrowse		As TAnotationsBrowse
	
	WSMETHOD GetAnotations			DESCRIPTION STR0002 //"Método de consulta da tabela de espelho de ponto do funcionario."
	WSMETHOD GetAnotationsFields	DESCRIPTION STR0003 //"Método de consulta dos dados pessoais do funcionário." 
	WSMETHOD GetPeriods             DESCRIPTION STR0004 //"Método que capta os períodos cadastrados no SIGAPON"
ENDWSSERVICE 

WSMETHOD GetAnotations;
WSRECEIVE Branch, Registration, CurrentPage, FilterField, FilterValue;
WSSEND AnotationsBrowse;
WSSERVICE RHAnotations
	Local lRet			:= .T.
	Local lTerminal		:= .T.
	Local lPortal		:= .T.	
	Local lReturn		:= .F. // .T. Retorno Logico Quando Validacao e .F. retorna os periodos
	Local cFilTerminal	:= Self:Branch
	Local cMatTerminal	:= Self:Registration
	Local cPerAponta
	Local aRetPortal	:= {}
	Local nTam, nTam1, nX, nY	  
	Local nAbHora		:= 0	
	Local nNumPerAnt	:= 1	// Numero de Periodos a Serem Listados ou somente a qtde desde admissao	
	Local cOcorr
	Local cAbHora
	Local cPeriodo	                                                    
	Local bCloseFiles:= {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }
	Local aFilesOpen :={"SP5", "SP8","SPB","RFF","SPC", "RFE"}
	
	If Self:FilterValue == Nil		
   		aPeriods	:= GetPerAponta( nNumPerAnt , cFilTerminal , cMatTerminal, lReturn) 
   		cPerAponta	:= DtoS(aPeriods[1,1])+DtoS(aPeriods[1,2])
		cPeriodo	:= DtoC(aPeriods[1,1])+' - '+DtoC(aPeriods[1,2])	
    Else
    	cPerAponta	:= Self:FilterValue
    	cPeriodo	:= DtoC(SToD(Left(Self:FilterValue, 8))) +" - "+ DtoC(SToD(Right(Self:FilterValue, 8)))
    EndIf
       	                                                    

	dbSelectArea("SRA")
	SRA->(dbSetOrder(1))
	If SRA->(dbSeek(cFilTerminal+cMatTerminal))
		Ponr010( lTerminal , cFilTerminal , cMatTerminal , cPerAponta, lPortal, @aRetPortal )
	EndIf
	
	nTam	:= Len(aRetPortal)
	                                    
	Self:AnotationsBrowse:Itens := {}
	For nX := 1 To nTam
		//-- Trata Abonos e Excecoes
		If ValType(aRetPortal[nX,3]) == "A"
			nAbHora:=  At( ":" , aRetPortal[nX,3,2] )
		Else
			nAbHora:=  At( ":" , aRetPortal[nX,3] )
		EndIf
		cOcorr	:= ""
		cAbHora	:= "" 
		 
		If nAbHora > 0 
			cOcorr :=	Capital( If (ValType(aRetPortal[nX,3]) == "A",aRetPortal[nX,3,1],SubStr( aRetPortal[nX,3] , 1 , nAbHora - 3 )) ) 
			cAbHora:= 	Capital( If (ValType(aRetPortal[nX,3]) == "A",aRetPortal[nX,3,2],SubStr( aRetPortal[nX,3] , nAbHora - 2 ) ) ) 
		Else                                                                      
			cOcorr :=	Capital( If (ValType(aRetPortal[nX,3]) == "A",aRetPortal[nX,3,1],AllTrim( aRetPortal[nX,3] ) ))
			cAbHora:= 	'&nbsp;'	
		EndIf 				
		
		AAdd(Self:AnotationsBrowse:Itens, WSClassNew("TAnotationsList"))		
		Self:AnotationsBrowse:Itens[nX]:Branch				:= cFilTerminal
		Self:AnotationsBrowse:Itens[nX]:Registration        := cMatTerminal
		Self:AnotationsBrowse:Itens[nX]:DateEvent			:= DtoC(aRetPortal[nX, 1])
		Self:AnotationsBrowse:Itens[nX]:DayWeek				:= DiaSemana(aRetPortal[nX,1],8)		
		Self:AnotationsBrowse:Itens[nX]:Observations		:= aRetPortal[nX, 2] 
		Self:AnotationsBrowse:Itens[nX]:Marks				:= {}
		Self:AnotationsBrowse:Itens[nX]:BonusReason        := cOcorr
		Self:AnotationsBrowse:Itens[nX]:HoursMarkType      := cAbHora
		
		nTam1	:=  Len(aRetPortal[nX])
		
		//Inseri o total de marcacoes que houver
		For nY := 4 To nTam1			
			AAdd(Self:AnotationsBrowse:Itens[nX]:Marks, WSClassNew("TMarksList"))		
			Self:AnotationsBrowse:Itens[nX]:Marks[nY-3]:MarksItens := aRetPortal[nX, nY]
		Next nY			
	Next nX
	Self:AnotationsBrowse:PeriodView	:= cPeriodo
	Self:AnotationsBrowse:PeriodFielter	:= cPerAponta
	
	Aeval(aFilesOpen, bCloseFiles) 
Return lRet


WSMETHOD GetAnotationsFields;
WSRECEIVE Branch, Registration;
WSSEND AnotationsBrowse;
WSSERVICE RHAnotations	
	Local lRet			:= .T.
	Local cFilTerminal	:= Self:Branch
	Local cMatTerminal	:= Self:Registration
	
	dbSelectArea("SRA")
	SRA->(dbSetOrder(1))
	SRA->(dbSeek(cFilTerminal+cMatTerminal))
	
	//Imprime os dados do Funcionario
	oFields	:= WSClassNew("TAnotationsFields")
	
	oFields:Name				:= SRA->RA_NOME
	oFields:Department			:= SRA->RA_DEPTO +" - "+ fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC')
	oFields:CostCenter			:= SRA->RA_CC    +" - "+ fDesc("CTT",SRA->RA_CC,"CTT_DESC01",,SRA->RA_FILIAL)
	oFields:Branch				:= cFilTerminal
	oFields:Registration		:= cMatTerminal
		
    AAdd(Self:AnotationsBrowse:Fields, oFields)
Return lRet

WSMETHOD GetPeriods;
WSRECEIVE Branch, Registration;
WSSEND AnotationsBrowse;
WSSERVICE RHAnotations	
	Local lRet			:= .T.
	Local lReturn		:= .F. // .T. Retorno Logico Quando Validacao e .F. retorna os periodos
	Local nX			:= 0
	Local nI			:= 0
	Local nTam			:= 0        ²
	Local nIni			:= 1
	Local nNumPerAnt	:= 12	// Numero de Periodos a Serem Listados ou somente a qtde desde admissao	
	Local cFilTerminal	:= Self:Branch
	Local cMatTerminal	:= Self:Registration
	Local aPeriods		:= {}
	Local bCloseFiles:= {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }
	Local aFilesOpen :={"SP5", "SP8","SPB","RFF","SPC", "RFE"}
	
	aPeriods	:= GetPerAponta( GetMv("MV_TCFMARC",,nNumPerAnt) , cFilTerminal , cMatTerminal, lReturn, NIL, NIL, RetPerSPO( cFilTerminal ) )
	nTam		:= Len(aPeriods)
		
	For nI := nTam To nIni Step -1
		nX += 1
		AAdd(Self:AnotationsBrowse:Periods, WSClassNew("TPeriodsList"))		
		Self:AnotationsBrowse:Periods[nX]:Fielter			:= DtoS(aPeriods[nI,1])+DtoS(aPeriods[nI,2])
		Self:AnotationsBrowse:Periods[nX]:ValueFielter		:= DtoC(aPeriods[nI,1])+' - '+DtoC(aPeriods[nI,2])	
	Next nI	
	
	Aeval(aFilesOpen, bCloseFiles) 
Return lRet