#INCLUDE "CNTA160.ch"                     
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA160  ³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de Projecao de indices                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA160()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CNTA160()         
Local nGrRad01 := "1"//Tipo de Projecao
Local cDesc    := ""   
Local aCols    := {}
Local aHeader  := {}
Local aAlter   := {}

Local oGet,oDlg, oGet01, oGet02, oGet03, oGet04, oSay01, oSay02, oGrRad01 := 1 //Componentes Visuais

Private cCodigo := "   "//Codigo do indice
Private nPerProj :=60//Periodo de Projecao
Private nRegProj :=1 //Periodo de Regressao
     
Private cCadastro := STR0001 //Projecao de Indices
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Configura colunas da MSGetDados                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aHeader,{STR0008,"MES","@!",10,0,".T.","û","C",,})      
AADD(aHeader,{,"VALOR","@E 99.99",10,2,".T.","û","N",,})                    

aAdd(aCols,{"________",0.0,.F.})//Linha Vazia
aAlter := aClone(aCols)

DEFINE MSDIALOG oDlg FROM  74,   7 TO 312,606 TITLE cCadastro PIXEL
        
oSay01:= tSay():New(04,04,{||OemToansi(STR0002)},oDlg,,,,,,.T.,,,73,8)// "No. de dias para projeção"
@ 0.3,12  MSGET oGet01 VAR nPerProj VALID (nPerProj > 0) ON CHANGE {If(nGrRad01 == 2 .And. nPerproj > 0,CN160MesProj(oGet),(oGet:aCols := aClone(aAlter),oGet:ForceRefresh()))} PICTURE "9999" SIZE 17,9  OF oDlg

oSay02:= tSay():New(04,140,{||OemToansi(STR0003)},oDlg,,,,,,.T.,,,85,8)// "No. de dias para regressão."  
@ 0.3,30  MSGET oGet02 VAR nRegProj VALID (nRegProj > 0) PICTURE "999" SIZE 17,9 OF oDlg        

@ 24,04  SAY OemToansi(STR0004) SIZE 73, 8 OF oDlg PIXEL // "Código"
@ 23,32  MSGET oGet03 VAR cCodigo PICTURE PesqPict("CN6","CN6_CODIGO") F3 "CN6" SIZE 25,9 VALID IF(ExistCpo("CN6", cCodigo ),{CN6->( dbsetorder(1) ),CN6->( dbseek(xFilial('CN6')+cCodigo) ),cDesc := CN6->CN6_DESCRI,if(CN6->CN6_TIPO="2",{oSay01:cCaption:=OemToansi(STR0021),oSay02:cCaption:=OemToansi(STR0022)},{oSay01:cCaption:=OemToansi(STR0002),oSay02:cCaption:=OemToansi(STR0003)})},.F.)  OF oDlg PIXEL

@ 40,04  SAY OemToAnsi(STR0005) SIZE 73, 8 OF oDlg PIXEL // "Descrição"
@ 39,32  MSGET oGet04 VAR cDesc SIZE 70,9 WHEN .F. OF oDlg PIXEL     

@ 59,04  RADIO oGrRad01 VAR nGrRad01 3D ;
			SIZE 70,10 ;
			ITEMS OemToansi(STR0006), OemToAnsi(STR0007) ; // "Regress„o Linear"###"Infla‡„o projetada"
			ON CLICK {If(nGrRad01 == 2,CN160MesProj(oGet),(oGet:aCols := aClone(aAlter),oGet:ForceRefresh())) };
			OF oDlg	PIXEL 
                     
oGet := MsNewGetDados():New(18,175,92,290,GD_UPDATE,,,,{"VALOR"},,,,,,oDlg,aHeader,aCols)

DEFINE SBUTTON FROM 105, 240 TYPE 1 ACTION (CursorWait(),if(nGrRad01 = 1,CN160CLinear(cDesc),CN160CInfla(oGet,cDesc)),oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 105, 270 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED     

CursorArrow()
Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN160MesProj ³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exibe os meses para serem usados na projeçao por inflacao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN160MesProj(<getdados>)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN160MesProj(oGet)
Local dDataIni, dDataFim, nMes, nAno
Local lComp := (CN6->CN6_TIPO = "2")
Local i := 0
oGet:aCols := {}//Limpa as linhas do GetDados

dDataIni:=dDataBase+1
if !lComp
	dDataFim:=dDataBase+nPerProj                      
Else      
	dDataIni:=dDataIni+(day(lastday(dDataIni))-day(dDataIni))+1
	dDataFim:=dDataBase-day(dDataBase)+1
	                                 
	For i:=1 to nPerProj
		nAvanco:=1+(Day(LastDay(dDataFim))-Day(dDataFim))
		dDataFim := dDataFim+nAvanco	
	Next i
	//dDataFim:=dDataFim-1//Retorna ao mes anterior
EndIf

nAno    :=Year(dDataIni)
nMes    :=Month(dDataIni)           

While (nMes <= Month(dDataFim) .And. nAno <= Year(dDataFim)) .Or. (nMes > Month(dDataFim) .And. nAno < Year(dDataFim))
	AADD(oGet:aCols,array(3))
	oGet:aCols[Len(oGet:aCols)][1] := AllTrim(str(Year(dDataIni))) + " - " + Substr(MesExtenso(Month(dDataIni)),1,9)
	oGet:aCols[Len(oGet:aCols)][2] := 0
	oGet:aCols[Len(oGet:aCols)][3] := .f.
	nAvanco:=1+(Day(LastDay(dDataIni))-Day(dDataIni))//Calcula dias para o proximo mes
	dDataIni:=dDataIni+nAvanco
	nMes:=Month(dDataIni) 
	nAno:=Year(dDataIni)
EndDO             
oGet:ForceRefresh()
Return       
                                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN160CLinear ³ Autor ³ Marcelo Custodio      ³ Data ³25.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza o calculo de projecao linear                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN160CLinear(cExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Descricao do indice                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN160CLinear(cDescri)
LOCAL ay:={}//Array com os valores de regressao
LOCAL dAtual:=dDataBase,nValant:=0
LOCAL dPass :=""
LOCAL aRet,Xi,Yi,j
Local lComp := (CN6->CN6_TIPO = "2")//Verifica se o indice varia por competencia ou data
Local cComp := ""//Competencia

DbSelectArea("CN7")
IF RecCount() < 2
	Help(" ",1,"NORECD")
	Return .F.
ENDIF    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a projecao sera feita por data ou competencia                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !lComp   
	dPass :=dAtual-nRegProj
	dbGoTop( )
	Set Softseek on
	dbsetorder(1)
	dbSeek(xFilial('CN7')+cCodigo+dtos(dPass))
	Set Softseek off
	
	While dPass < dAtual//Realiza a regressao
		dbSeek(xFilial('CN7')+cCodigo+dtos(dPass))
		IF Found()
			nValAnt:=CN7_VLREAL
		Endif
		AADD(ay,nValAnt)
		dPass++
	EndDo           
	
	aRet := RLinear(ay)//MATA090, responsavel pelos parametros da projecao de Moedas
	K1:=aRet[1]
	K2:=aRet[2]
	Xm:=aRet[3]
	Ym:=aRet[4]
	nx:=Len(ay)     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Percorre os dias ate a data de projecao                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For j:=1 To nPerProj
		
		Xi:=dPass+j
		nD:=(Xi-dAtual)+nx
		Yi := (K2*nD)+(Ym-(K2*Xm))
		
		dbSeek(xFilial('CN7')+cCodigo+dtos(dPass+j))
		IF Found()//Verifica se ja existe historico para a data
			Reclock("CN7")
		Else
			Reclock("CN7",.T.)
		EndIF           
		Replace CN7_FILIAL     With xFilial('CN7')
		Replace CN7_CODIGO     With cCodigo
		Replace CN7_DATA       With dPass+j
		Replace CN7_DESCRI     With cDescri
		Replace CN7_VLPROJ     With Yi                  
		Replace CN7_TPPROJ     With "2"//Regressao Linear
		MsUnlock()
	Next j
else      
	dPass := dAtual:= dAtual-day(dAtual)+1//Altera a data atual para o primeiro dia do mes

	nAno  :=Year(dAtual)
	nMes  :=Month(dAtual)-nRegProj
	               
	//Verifica o mes e o ano correto da regressao
	while nMes <= 0
	  nMes := 12 + nMes
	  nAno--
	EndDo
                                         
	//Retorna até a data de regressao
	While nMes != Month(dPass) .Or. nAno != Year(dPass)
		nRegres:=Day(dPass)
		dPass:=dPass-nRegres
	EndDo
	
	dbGoTop( )       
	cComp := strzero(month(dPass),2)+"/"+str(year(dPass),4)//Converte a data para competencia
	
	Set Softseek on
	dbsetorder(2) 
	dbSeek(xFilial('CN7')+cCodigo+cComp)
	Set Softseek off  
	
	While dPass < dAtual//Realiza a regressao
		dbSeek(xFilial('CN7')+cCodigo+cComp)
		IF Found()
			nValAnt:=CN7_VLREAL
		Endif       
		nAvanco:=1+(Day(LastDay(dPass))-Day(dPass))
		AADD(ay,nValAnt)
		dPass := dpass+nAvanco     
		cComp := strzero(month(dPass),2)+"/"+str(year(dPass),4)
	EndDo
	
	aRet := RLinear(ay)//MATA090, responsavel pelos parametros da projecao de Moedas
	K1:=aRet[1]
	K2:=aRet[2]
	Xm:=aRet[3]
	Ym:=aRet[4]
	nx:=Len(ay)

	Xi:=dPass
	Yi:=0	      
	             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Percorre os dias ate a data de projecao                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For j:=1 To nPerProj
		nAvanco:=1+(Day(LastDay(Xi))-Day(Xi))
		Xi:=Xi+nAvanco//Avanca ao proximo mes
		
		cComp := strzero(month(Xi),2)+"/"+str(year(Xi),4)//Converte para competencia
		nD:=j+nx
		Yi := (K2*nD)+(Ym-(K2*Xm))
		dbSeek(xFilial('CN7')+cCodigo+cComp)
		
		IF Found()//Verifica se ja existe historico para a competencia
	  		Reclock("CN7")
		Else
	  		Reclock("CN7",.T.)
		EndIF           
		Replace CN7_FILIAL     With xFilial('CN7')
		Replace CN7_CODIGO     With cCodigo
		Replace CN7_COMPET     With cComp
		Replace CN7_DESCRI     With cDescri
		Replace CN7_VLPROJ     With Yi               
		Replace CN7_TPPROJ     With "2"//Regressao Linear
		MsUnlock()
	Next j
EndIf	
Return                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN160CInfla  ³ Autor ³ Marcelo Custodio      ³ Data ³25.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza o calculo da inflação projetada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN160CInfla(<oGetDados>,cExp01)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Descricao do indice projetado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN160CInfla(oGet,cDescri)
LOCAL k,dData:=dDataBase,nUltVal,ay:={},nPriVal:=0,nFirst:=0,nDia:=0,nMes:=0
Local lComp := (CN6->CN6_TIPO = "2")//Verifica se o indice varia por competencia ou data
Local cComp := ""//Competencia

For k:=1 To Len(oGet:aCols)
	AADD(ay,oGet:aCols[k][2])//Armazena percentuais mensais
Next k

nIndiceMes := 0
nUltVal := 0

if !lComp
	dbSelectArea("CN7")  
	dbsetorder(1)
	dbSeek(xFilial('CN7')+cCodigo+dtos(dData))       
	nPriVal:= CN7_VLREAL//Valor inicial
	
	For k:=1 To nPerProj
		dData:=dData+1
		
		IF nFirst == 0//Primeiro dia do mes
			nFirst := 1
			nMes   := Month(dData)
			nDia   := 0
			nIndiceMes++
		EndiF
		
		IF Month(dData)!= nMes//Primeiro dia do proximo mes
			nFirst := 0
			k--
			dData:=dData-1
			dbSeek(xFilial('CN7')+cCodigo+dtos(dData))
			nPriVal:= CN7_VLPROJ//Valor inicial
			LOOP
		EndIF    
		
		nDia++	
		If nIndiceMes > 0 .and. nIndiceMes <= Len(ay)
			If ay[nIndiceMes] = 0
				CN7->(dbSeek(xFilial('CN7')+cCodigo+dtos(dData-1)))
				If CN7->CN7_VLREAL!=0.000
					nUltVal:= CN7->CN7_VLREAL
				Endif
			Else
				nUltVal:=RInflac(ay,dData,nPriVal,nDia)//MATA090, calcula projecao mensal sobre o percentual informado
			EndIf
			CN7->(dbSeek(xFilial('CN7')+cCodigo+dtos(dData)))
			IF Found()
				Reclock("CN7")
			Else
				Reclock("CN7",.T.)
			EndIF                                            
			
			Replace CN7_FILIAL     With xFilial('CN7')
			Replace CN7_CODIGO     With cCodigo
			Replace CN7_DATA       With dData
			Replace CN7_DESCRI     With cDescri
			Replace CN7_VLPROJ     With nUltVal               
			Replace CN7_TPPROJ     With "3"//Inflacao Projetada
			MsUnlock()
		EndIf
	NEXT k
Else           
	cComp := strzero(month(dData),2)+"/"+str(year(dData),4)//Competencia
	
	dbSelectArea("CN7")  
	dbsetorder(2)
	dbSeek(xFilial('CN7')+cCodigo+cComp)       
	nUltVal:= CN7_VLREAL

	dData := dData+(day(lastday(dData))-day(dData))+1//Altera a data atual para o primeiro dia do proximo mes
	cComp := strzero(month(dData),2)+"/"+str(year(dData),4)//Competencia
	
	nMes := Month(dData)
	nAno := Year(dData)
	                   
	For k:=1 To len(ay)
			If ay[k] = 0
				CN7->(dbSeek(xFilial('CN7')+cCodigo+cComp))
				If CN7->CN7_VLREAL!=0.000
					nUltVal:= nVlrCampo
				Endif
			Else
				nUltVal := nUltVal*(1+(ay[k]/100))
				//nUltVal:=RInflac(ay,dData,nPriVal,nAvanco)
			EndIf
			CN7->(dbSeek(xFilial('CN7')+cCodigo+cComp))
			IF Found()
				Reclock("CN7")
			Else    
				Reclock("CN7",.T.)
			EndIF                                            
			
			Replace CN7_FILIAL     With xFilial('CN7')
			Replace CN7_CODIGO     With cCodigo
			Replace CN7_COMPET     With cComp
			Replace CN7_DESCRI     With cDescri
			Replace CN7_VLPROJ     With nUltVal               
			Replace CN7_TPPROJ     With "3"//Inflacao Projetada
			MsUnlock()    
			
			nAvanco:=1+(Day(LastDay(dData))-Day(dData))
			dData:=dData+nAvanco//Avanca ao proximo mes		   
			cComp := strzero(month(dData),2)+"/"+str(year(dData),4)
	NEXT k
EndIF
Return .T.