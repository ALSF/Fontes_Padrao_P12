#include "FIVEWIN.CH"
#include "CFGX031.CH"

#ifdef SPANISH
	#define COLDESC1 2
	#define COLDESC2 1
	#define COLDESC3 3
#else
	#ifdef ENGLISH
		#define COLDESC1 3
		#define COLDESC2 1
		#define COLDESC3 2
	#else
		#define COLDESC1 1
		#define COLDESC2 2
		#define COLDESC3 3
	#endif
#endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGx031  ³ Autor ³ Jorge Queiroz         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o Dicionario de campos disponiveis pelo usuario.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ void CFGx031(void)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡†o Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cheyenne    ³16/12/99³25544A³ VerIficacao de cDBMS antes do GET para   ³±±
±±³            ³16/12/99³25544A³alteracao do tamanho do campo. Compatibi- ³±±
±±³            ³16/12/99³25544A³zacao com ORACLE.                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CFGX031
Return APCFG10()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SayConPad³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna consulta padrao do campo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ExpC1 := SayConPad(ExpC2)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Retorna consulta do campo                         ³±±
±±³          ³ ExpC2 := Nome do Campo                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CFGx031.PRG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SayConPad(cCampo)
Local cSavAlias := Alias(), cRet := ""

If Empty(cCampo)
	Return Space(29)
EndIf
DbSelectArea("SXB")
nSavRec := Recno()
DbSeek(cCampo+"1")
If Found()
	cRet := cCampo + " - "+OemToAnsi(Substr(XBDESCRI(),1,25))
	DbGoTo(nSavRec)
Else
	DbGoTo(nSavRec)
	DbSelectArea("SX5")
	DbGoTop()
	While X5_TABELA == "00"
		If AllTrim(cCampo) == AllTrim(X5_CHAVE)
			cRet := cCampo +" - "+Substr(X5DESCRI(),1,25)
			Exit
		EndIf
		DbSkip()
	End
EndIf
If !Empty(cSavAlias)
	DbSelectArea(cSavAlias)
EndIf
Return If(Empty(cRet),Space(29),cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GetHelp  ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Help do campo                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ExpA1 := GetHelp(ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Array com Help do Campo                           ³±±
±±³          ³ ExpC2 := Nome do Campo                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CFGx031.PRG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function GetHelp(cCampo)
Local nHlpHdl, xNumEnt,nRegLid,nLerInd,cIndice,nPosHlp:=0, cHelp,cRet
Local cArqHlp := RetHlpFile()

If Empty(cCampo)
	Return Space(200)
EndIf
If File(cArqHlp)
	nHlpHdl := fOpen(cArqHlp,2 + 64) //FO_READWRITE+FO_SHARED
Else
	Return Space(200)
EndIf

xNumEnt := "  "
FSEEK(nHlpHdl,-2,2)
FREAD(nHlpHdl,@xNumEnt,2)
xNumEnt := Bin2I(xNumEnt)
FSEEK(nHlpHdl,(-10*xNumEnt)-2,2)
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Procura a Entrada no Indice                              ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRegLid := 0
While nRegLid < xNumEnt
	nLerInd := Iif((xNumEnt-nRegLid)>100,100,xNumEnt-nRegLid)
	cIndice := Space(nLerInd*10)
	FREAD(nHlpHdl,@cIndice,nLerInd*10)
	nPosHlp := AT(cCampo,cIndice)
	If nPosHlp > 0
		nPosHlp+=(nRegLid*10)
		Exit
	EndIf
	nRegLid+=nLerInd
End
If nPosHlp == 0
	cRet := Space(200)
Else
	FSEEK(nHlpHdl,((nPosHlp-1)/10)*200,0)
	cHelp := Space(200)
	FREAD(nHlpHdl,@cHelp,200)
	cRet := cHelp
EndIf
FClose(nHlpHdl)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  SeleF3  ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Combo Box para selecao da consulta padrao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void SeleF3(Void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Parametros                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CFGx031.PRG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SeleF3()
Local nOpc
Local aOpc := {}
Local cSavAlias := Alias()
Local nSavRec

DbSelectArea("SXB")
nSavRec := Recno()
DbGoTop()
AADD(aOpc,Space(31))
While !Eof()
	If XB_TIPO == "1" .and. XB_ALIAS != "SX5"
		AADD(aOpc,XB_ALIAS+" - "+OemToAnsi(Substr(XBDESCRI(),1,25)))
	EndIf
	DbSkip()
End
DbGoTo(nSavRec)
DbSelectArea("SX5")
DbGoTop()
While X5_TABELA == "00"
	AADD(aOpc,SubStr(X5_CHAVE,1,3)+" - "+Capital(OemToAnsi(Substr(X5DESCRI(),1,25))))
	DbSkip()
End


DbSelectArea(cSavAlias)

Return aOpc

Function SeleFolder(cAlias)
Local nOpc
Local aOpc := {}
Local cSavAlias := Alias()

DEFAULT cAlias := ""

DbSelectArea("SXA")
DbSetOrder(1)
DbSeek(cAlias)
Aadd(aOpc,Space(34))
While !Eof() .And. XA_ALIAS == cAlias
	Aadd(aOpc,XA_ORDEM+" - "+OemToAnsi(XADESCRIC()))
	DbSkip()
End
DbSelectArea(cSavAlias)
Return aOpc

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EditHlp  ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz a edicao do texto do help do campo                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void EditHlp(ExpC1)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do campo                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CFGx031.PRG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function EditHlp(cCampoH,cHelp)
Local GetList := {},nArea,lCriaHelp:=.F.,nTamInd
Local nSeek,nPosAnt,nPosUlt,nRegLid,nRegs:=0,xBuffer,aBut,nPosHlp := 0
Local lGrava:=.F.
Local cArqHlp := RetHlpFile()

If FILE(cArqHlp)
	nHlpHdl := FOPEN(cArqHlp,2+64) //FO_READWRITE + FO_SHARED
Else
	nHlpHdl := MSFCREATE(cArqHlp)
	FWRITE(nHlpHdl,(CHR(0)+CHR(0)),2)
	Commit
EndIf
If nHlpHdl <= 0
	Tone(3500,1)
	help := .F.
	Return .T.
EndIf
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Recupera o indice                                        ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xNumEnt := "  "
FSEEK(nHlpHdl,-2,2)
FREAD(nHlpHdl,@xNumEnt,2)
xNumEnt := Bin2I(xNumEnt)
FSEEK(nHlpHdl,(-10*xNumEnt)-2,2)
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Procura a Entrada no Indice                              ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRegLid := 0
While nRegLid < xNumEnt
	nLerInd := Iif((xNumEnt-nRegLid)>100,100,xNumEnt-nRegLid)
	cIndice := Space(nLerInd*10)
	FREAD(nHlpHdl,@cIndice,nLerInd*10)
	nPosHlp := AT(cCampoH,cIndice)
	If nPosHlp > 0
		nPosHlp+=(nRegLid*10)
		Exit
	EndIf
	nRegLid+=nLerInd
End
If nPosHlp = 0
	cHelp := Padr(cHelp,200)
	lCriaHelp:=.T.
Else
	lGrava := .T.
EndIf

If lCriaHelp
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Adiciona 200 brancos ao arquivo atual           ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	nPosAnt:=FSEEK(nHlpHdl,0,2)-2
	FWRITE(nHlpHdl,Space(200),200)
	FSEEK(nHlpHdl,-2,2) /// Mudei de 0 para -2
	xNumEnt++
	cIndice := cCampoH + I2BIN(xNumEnt)
	FWRITE(nHlpHdl,cIndice,12)
	nPosUlt:=FSEEK(nHlpHdl,0,2)-12
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Regrava o indice deslocando 210 posicoes adiante³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	xNumEnt--
	nRegLid:=0
	While nRegLid < (xNumEnt)
		nRegs := Iif((xNumEnt-nRegLid)>100,100,xNumEnt-nRegLid)
		nRegLid+=nRegs
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³ Le a Posicao original do Indice     ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		xBuffer:=Space(nRegs*10)
		nPosAnt-=nRegs*10
		FSEEK(nHlpHdl,nPosAnt,0)
		FREAD(nHlpHdl,@xBuffer,(nRegs*10))
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³ Grava na nova posicao do indice     ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		nPosUlt-=nRegs*10
		FSEEK(nHlpHdl,nPosUlt,0)
		FWRITE(nHlpHdl,@xBuffer,(nRegs*10))
	End
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Posiciona o ponteiro no fim do arquivo.         ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	  nSeek := FSEEK(nHlpHdl,(xNumEnt)*200,0)
	  If nSeek < 0;FSEEK(nHlpHdl,-2,2);EndIf
	  FWRITE(nHlpHdl,cHelp,200)
	  Commit
Else
	  FSEEK(nHlpHdl,0,0)
	  FSEEK(nHlpHdl,(((nPosHlp-1)/10)*200),0)
	  FWRITE(nHlpHdl,cHelp,200)
	  Commit
EndIf
// Acertar Variaveis Globais do Protheus

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Recupera o indice                                        ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xNumEnt := "  "
FSEEK(nHlpHdl,-2,2)
FREAD(nHlpHdl,@xNumEnt,2)
xNumEnt := Bin2I(xNumEnt)
FSEEK(nHlpHdl,(-10*xNumEnt)-2,2)
cIndice := Space(xNumEnt*10)
FREAD(nHlpHdl,@cIndice,xNumEnt*10)
PutGlbValue("HLPIDXSTR"+cArqHlp+GetEnvServer(),cIndice)
PutGlbValue(cCampoH+cArqHlp+GetEnvServer(),cHelp)
FClose(nHlpHdl)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ X031BrOk ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de validacao para a alteracao do Browse             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CFGx031.PRG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function X031BrOk(aArray,nEl)
Local i

For i:= 1 to Len(aArray)
	If aArray[i,1] .and. i <> nEl
		Return .t.
	EndIf
Next
Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³X031LOG     ³Autor ³ Cristiane Maeda      ³ Data ³ 24/10/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava Log de Altera‡oes p/ campos Numericos                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CFGx031.PRG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function X031LOG(cCpo,nRecno,cValAnt)
Local nHdl,cNome,nTam,xBuffer:= Space(30)
Local CR := Chr(13)+Chr(10)

cNome:=__RELDIR+"X031LOG.##R"
If !File(cNome)
	nHdl:= MSFCREATE(cNome,0)
	xBuffer := OemToAnsi(STR0053) +DTOC(dDataBase)+ CR+CR   // "       Atualiza‡†o da Base de Dados  "
	FWrite(nHdl,xBuffer,Len(xBuffer))
	xBuffer := OemToAnsi(STR0054) + CR  // "Os campos apresentados abaixo tiveram seus valores  truncados ou"
	FWrite(nHdl,xBuffer,Len(xBuffer))
	xBuffer := OemToAnsi(STR0055)+CR  // "zerados, pois os digitos contidos no campo original  excederam o"
	FWrite(nHdl,xBuffer,Len(xBuffer))
	xBuffer := OemToAnsi(STR0056)+CR+CR  // "tamanho do novo campo."
	FWrite(nHdl,xBuffer,Len(xBuffer))
	FClose(nHdl)
EndIf

nHdl:= FOpen(cNome,2+64)
nTam := FSeek(nHdl,0,2)
Fseek(nHdl,nTam,0)
xBuffer := OemToAnsi(STR0057)+ Str(nRecno,4)+CR  // "Registro : "
FWrite(nHdl,xBuffer,Len(xBuffer))
xBuffer :=	OemToAnsi(STR0045)+" : " + cCpo + CR  // "Campo"
FWrite(nHdl,xBuffer,Len(xBuffer))
xBuffer :=	OemToAnsi(STR0092) + cValAnt + CR +CR  // "Valor Anterior : "
FWrite(nHdl,xBuffer,Len(xBuffer))

FClose(nHdl)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o  ³OpenSx2Exc³ Descr ³ Abre Sx2 Exclusivo 	³ Data ³28.11.95	³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function OpenSx2Excl(cArqSx2,cIndSx2,cSX2Alias)

DEFAULT cSX2Alias := "SX2"

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Aguarda Liberacao de Arquivos por outras estacoes para abrir SX2 Exclusivo  ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SX2")
	dBCloseArea()
	cIndSx2 += "1"
	MsOpEndbf(.t. ,__LocalDriver,cArqSX2,cSX2Alias,.f.,.f.)
	While !Used()
			If !NaoExcl()
				 MsOpEndbf(.t. ,__LocalDriver,cArqSX2,cSX2Alias,.t.,.f.)
				 MsOpenIdx( cIndSx2,"X2_CHAVE",.f.,,,cArqSX2 )
				 Return .F.
			EndIf
			MsOpEndbf(.t. ,__LocalDriver,cArqSX2,cSX2Alias,.f.,.f.)
	End
   MsOpenIdx( cIndSx2,"X2_CHAVE",.f.,,,cArqSX2 )
	Return .T.

// ------------------------------------------------------

Function NaoExcl()
Local lRet := .F.,oDlg,oBtn

DEFINE MSDIALOG oDlg FROM	96,72 TO 341,540 TITLE OemToAnsi(STR0105) PIXEL  OF oMainWnd  // "Atualiza‡„o de Vers„o"

	@ 8, 20 TO 102, 212 OF oDlg  PIXEL
	@ 24, 34 SAY OemToAnsi(STR0100) SIZE 166, 7 OF oDlg PIXEL  // "Para  Atualizar a  Base de Dados , o Sistema n„o poder  estar em "
	@ 38, 34 SAY OemToAnsi(STR0101) SIZE 166, 7 OF oDlg PIXEL  // "uso por outras esta‡”es. Neste momento est  sEndo aguardada a "
	@ 52, 34 SAY OemToAnsi(STR0102) SIZE 166, 7 OF oDlg PIXEL  // "libera‡„o dos arquivos.  Tecle o bot„o  <Confirma>  quando todas "
	@ 66, 34 SAY OemToAnsi(STR0103) SIZE 166, 7 OF oDlg PIXEL  // "as  esta‡„es  j   estiverem  fora  do sistema para prosseguir com a"
	@ 78, 34 SAY OemToAnsi(STR0104)	SIZE 165, 7 OF oDlg PIXEL // "atualiza‡„o.                                                  "

	DEFINE SBUTTON oBtn FROM 107,158 TYPE 1 ACTION (lRet := .T.,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON oBtn FROM 107,186 TYPE 2 ACTION (lRet := .F.,oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg
Return lRet

***************************************
FUNCTION x031Str(cCampo,cCposDef)

Local nPos := 1

While nPos != 0
	If cCampo == SubStr(cCposDef,2,Len(cCampo))
		Return(.t.)
	EndIf
	nPos     := At( "/",cCposDef )
	cCposDef := SubStr(cCposDef,nPos+1,Len(cCposDef))
End

Return(.f.)
