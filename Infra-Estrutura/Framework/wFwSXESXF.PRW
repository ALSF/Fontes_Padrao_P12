#include "error.ch"  
#include "fwadaptereai.ch" 
#include "protheus.ch"
#include "matxatu.ch"
#include "fwlibversion.ch"

static __aKeys as array
static __lSemServer as logical
static __lFirstXE as logical
static __SpecialKey as char
static __lCleaned := .F.
static __lFwGetSXENum := FindFunction("FwGetSXENum")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GetSXENum³Autor  ³ Ary Medeiros			  ³ Data ³	   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem numero sequencial do arquivo de semaforo			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³GetSXENum( ) 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GetSXENum(cAlias,cCpoSx8,cAliasSX8,nOrdem)
Local cSavAlias := Alias(), cRet, nSize, lFound, lNetErr := .t.
Local nTimes := 0, nHdl, aCampos, nTrys := 0
Local nSizeFil := 2

// Redireciona a chamada para uma função do framework para não ferir regras do sonar
If __lFwGetSXENum
	// Chamada da função interna do framework
	cRet := FwGetSXENum(cAlias,cCpoSx8,cAliasSX8,nOrdem)
Else
	LS_Em_Server()
	
	IF __lSemServer
		IF !__lCleaned
			FERASE("SXE.DBF")
			FERASE("SXF.DBF")
			__lCleaned := .t.
		Endif

		Return GetLSNum(cAlias,cCpoSx8,cAliasSX8,nOrdem)
	Endif

	//-- Atualiza o conteúdo da filial
	nSizeFil := FWSizeFilial()

	DEFAULT __lFirstXE := .t.    

	If __lFirstXE
		__lFirstXE := .f.
		If !File("SXE" + GetDBExtension()) .Or. ! File( "SXF" + GetDBExtension() )
			nTrys := 0
			While !LockByName("SOEUSXE")
				Inkey(5)
				nTrys++
				If nTrys > 20
					Final("Probs.Criacao SOEUSXE")
				EndIf
			End

			If ! File( 'SXE' + GetDBExtension() )
				aCampos := {}
				AADD(aCampos,{"XE_FILIAL","C",48+nSizeFil,0})
				AADD(aCampos,{"XE_ALIAS","C",3,0})
				AADD(aCampos,{"XE_TAMANHO","N",2,0})
				AADD(aCampos,{"XE_NUMERO","C",20,0})
				dbCreate("SXE",aCampos,__LocalDriver)
				If NetERR()
					Final("Probs.Criacao SXE")
				EndIf
			EndIf

			If ! File( 'SXF' + GetDBExtension() )
				aCampos := {}
				AADD(aCampos,{"XF_FILIAL","C",48+nSizeFil,0})
				AADD(aCampos,{"XF_ALIAS","C",3,0})
				AADD(aCampos,{"XF_TAMANHO","N",2,0})
				AADD(aCampos,{"XF_NUMERO","C",20,0})
				dbCreate("SXF",aCampos,__LocalDriver)
				If NetERR()
					Final("Probs.Criacao SXF")
				EndIf
			EndIf

			UnLockByName("SOEUSXE")
			DbCommitAll()
		EndIf
	EndIf
	If Select("SXE") <= 0
		USE SXE ALIAS SXE SHARED NEW VIA __LocalDriver
		If NetERR()
			Final("Probs.Abertura SXE")
		EndIf
		USE SXF ALIAS SXF SHARED NEW VIA __LocalDriver
		If NetERR()
			Final("Probs.Abertura SXF")
		EndIf
	EndIf

	nOrdem := Iif(nOrdem == Nil,1,nOrdem)

	If cAliasSX8 == Nil 
		//----------------------------------------------------------- 
		// Tratamento para numeração de TRB sem informação de filial. 
		//-----------------------------------------------------------
		If ( cAlias == "TRB" )      
			cAliasSx8	:= Padr("", Len(SXE->XE_FILIAL))		
		Else
			cAliasSx8	:= Padr(xFilial(cAlias)+x2path(cAlias),Len(SXE->XE_FILIAL))	
		EndIf
	Else  
		cAliasSx8 := Padr(cAliasSx8,Len(SXE->XE_FILIAL))
	EndIf

	DbSelectArea("SXF")     //Olhar as Sobras
	DbGoTop()
	lFound := .f.
	While !Eof()  //.and. (X8_FILIAL+X8_ALIAS+X8_STATUS) == (cAliasSx8+cAlias+"0")
		If XF_FILIAL+XF_ALIAS != cAliasSX8+cAlias
			DbSkip()
			Loop
		EndIf
		IF Ascan(aSx8,{|x| x[1]==SXF->(Recno())}) > 0
		dbSkip()
		Loop
		Endif
		If MSRLock(Recno())
		dbCommit()
		dbGoto(Recno())
			IF MsRLock(Recno())     //Nao Mexer WIlson
			dbGoto(Recno())       //Nao Mexer Wilson
			If !Deleted()
				lFound  := .T.
				cRet            := Substr(XF_NUMERO,1,XF_TAMANHO)
				Exit
			Else
				MSRUnlock(Recno())
			EndIf
			Else
			MsRUnlock(Recno())
			Endif
		EndIf
		DbSkip()
	End
	If !lFound
		DbSelectArea("SXE")    //Olhar o Proximo
		DbGoTop()
		While !Eof()
			If XE_FILIAL+XE_ALIAS == cAliasSX8+cAlias
				Exit
			EndIf
			DbSkip()
		End
		If Eof()
			CriaSXE(cAlias,cCpoSx8,cAliasSx8,nOrdem)
			DbSelectArea("SXE")
			dbCommit()
		EndIf
		nTrys := 0
		While .t.
			DbGoTo(Recno())
			If MSRLock(Recno())
				dbCommit()
				DbGoTo(Recno())
				If MsRLock(RecNo())   //Nao Mexer (Wilson)
					Exit
				EndIf
			EndIf
			nTrys++
			Sleep(15*nTrys)
			If nTrys > 50
				Final("Nao Consegui SXE")
			EndIf
		End
		cRet := Substr(XE_NUMERO,1,XE_TAMANHO)
		nSize := XE_TAMANHO
		If ( cAlias == 'CPR' ) .And. ( cRet == 'ZZZZ' )
			Replace XE_NUMERO WITH '0001'
		Else	
		Replace XE_NUMERO with SOMA1(Substr(XE_NUMERO,1,XE_TAMANHO))
		EndIf
		DbCommit()
		MsRUnLock(Recno())
		DbCommit()

		While lNetErr
			DbSelectArea("SXF")
			Set DELE OFF
			DbGoTop()
			While !Eof()
				If Deleted()
					Exit
				EndIf
				DbSkip()
			End
			If Eof()
				dbAppEnd(.f.)
				lNetErr := NetErr()
			Else
				If ( MsrLock(RecNo()) )
					dbCommit()
					dbGoto(Recno())
					IF MsRLock(Recno())
					If !Deleted()
						MsRUnlock(RecNo())
						Loop
					EndIf
					Else
					MsRUnLock(Recno())
					Loop
					Endif 
				Else
					Loop
				EndIf
				lNetErr := .f.
			EndIf
			Set DELE ON
			nTimes ++
			If nTimes > 20
				If NetCancel()
					Final( oemtoansi("PROBS.GRV.SXF") ) //"Problema de GRAVACAO NO SX8"
				Else
					nTimes := 0
				EndIf
			EndIf
			If ( lNetErr )
				Inkey( nTimes/24 )	
			EndIf
		End
		DbSelectArea("SXF")
		MSRLock(Recno())
		DbReCall()
		Replace XF_FILIAL with cAliasSx8
		Replace XF_ALIAS with cAlias
		Replace XF_TAMANHO with nSize
		Replace XF_NUMERO with cRet
		DbCommit()
	EndIf

	__lSX8 := .t.

	//If Ascan(aSx8,{|x| x[1]==SXF->(Recno())}) == 0
	AADD(aSx8,{SXF->(Recno()),"E",cCpoSX8,cAlias})
	//Endif

	If !Empty(cSavAlias)
		DbSelectArea(cSavAlias)
	EndIf
EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetlSemServerºAutor  ³ Vendas Cliente ºData ³ 05/Abr/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o conteudo da variavel estatica __lSemServer       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Logico -  .T. ou .F.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJA701                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function GetlSemServer()
Return __lSemServer <> Nil .And. __lSemServer

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³RollBackSX8³Autor	³ Ary Medeiros 		  ³ Data ³			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna numero no semafor como pEndente 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³RollBackSX8()															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												 				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function RollBackSX8()
Return RollBackSE()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ConfirmSX8 ³Autor	³ Ary Medeiros 		  ³ Data ³			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Confirma numero sugerido pelo semaforo					 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ConfirmSX8() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1 : Ativa a verificacao do numero gravado. Quando ligado³±±
±±³          ³a confirmacao do numero eh executada apenas se o usuario nao³±±
±±³          ³alterou o numero sugerido. Exemplo : O sistema sugeriu      ³±±
±±³          ³000015 para um Pedido, o usuario alterou para 000040 e      ³±±
±±³          ³gravou. No momento da ConfirmSX8, o numero gravado sera     ³±±
±±³          ³comparado com o sugerido, e o mesmo apenas sera confirmado  ³±±
±±³          ³caso nao tenha sido alterado.                               ³±±
±±³          ³ATENCAO : O PADRAO DESTE PARAMETRO E FALSO, E O MESMO SO    ³±±
±±³          ³          PODERA SER UTILIZADO CASO O REGISTRO GRAVADO PELO ³±±
±±³          ³          USUARIO ESTEJA POSICIONADO.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function ConfirmSX8(lPosConf)
Return ConFirmSXE(lPosConf)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GetSX8Num³Autor  ³ Ary Medeiros		     ³ Data ³			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem numero sequencial do arquivo de semaforo				  ³±±
±±³Descri‡…o ³Existe apenas para compatibilizar a Nova GetSxeNum()        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³GetSX8Num( ) 												 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GetSX8Num(cAlias,cCpoSx8,cAliasSX8,nOrdSX8)
Return GetSxeNum(cAlias,cCpoSx8,cAliasSX8,nOrdSX8)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ HasCTKSXE³Autor  ³ Protheus			  ³ Data ³	   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna .T. fixo...                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³HasCTKSXE( ) 												           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function HasCTKSXE()
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GetSX8Len³Autor  ³ Protheus			  ³ Data ³	   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o tamanho do SX8 ( Array )                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³GetSX8Len( ) 												           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GetSX8Len()
Local nMax as numeric

DEFAULT __aKeys := {}
nMax := Max(Len(aSX8),Len(__aKeys))

Return(nMax)

// ------------------------------------------------------

Function GetLSKeys()
DEFAULT __aKeys := {}
Return __aKeys

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³RollBackSXE³Autor	³ Ary Medeiros 		  ³ Data ³			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna numero no semafor como pEndente 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³RollBackSXE()															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RollBackSE()
Local cAlias as character 
Local cDriver as character 

cAlias := Alias()

LS_Em_Server()

IF __lSemServer
   Return RollBackLS()
Endif


If Len(aSX8) < 1
	__lSx8 := .f.
EndIf

If !__lSx8
	Return Nil
EndIf
		If Select("SXE") <= 0
			If FindFunction('FwSxeInDb') .and. FwSxeInDb()
				cDriver := "TOPCONN"
			Else
				cDriver := __LocalDriver
			Endif 
			USE SXE ALIAS SXE SHARED NEW VIA cDriver
			If NetERR()
				Final("Probs.Abertura SXE")
			EndIf
			USE SXF ALIAS SXF SHARED NEW VIA cDriver
			If NetERR()
				Final("Probs.Abertura SXF")
			EndIf
			DbSelectArea("SXF")
			DbGoTo(aSx8[len(aSx8),1])
			aDel(aSX8,len(aSX8))
			aSize(aSX8,len(aSX8)-1)
			__lSx8 := Iif(Len(aSx8) == 0,.f.,.T.)

			MsRUnLock(Recno())
			dbCommit()
			If !Empty(cAlias)
				DbSelectArea(cAlias)
			EndIf
		Else
			DbSelectArea("SXF")
			DbGoTo(aSx8[len(aSx8),1])
			aDel(aSX8,len(aSX8))
			aSize(aSX8,len(aSX8)-1)
			__lSx8 := Iif(Len(aSx8) == 0,.f.,.T.)

			MsRUnLock(Recno())
			dbCommit()
			If !Empty(cAlias)
				DbSelectArea(cAlias)
			EndIf
		Endif
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ConfirmSXE ³Autor	³ Ary Medeiros 		  ³ Data ³			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Confirma numero sugerido pelo semaforo							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ConfirmSXE() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1 : Ativa a verificacao do numero gravado. Quando ligado³±±
±±³          ³a confirmacao do numero eh executada apenas se o usuario nao³±±
±±³          ³alterou o numero sugerido. Exemplo : O sistema sugeriu      ³±±
±±³          ³000015 para um Pedido, o usuario alterou para 000040 e      ³±±
±±³          ³gravou. No momento da ConfirmSX8, o numero gravado sera     ³±±
±±³          ³comparado com o sugerido, e o mesmo apenas sera confirmado  ³±±
±±³          ³caso nao tenha sido alterado.                               ³±±
±±³          ³ATENCAO : O PADRAO DESTE PARAMETRO E FALSO, E O MESMO SO    ³±±
±±³          ³          PODERA SER UTILIZADO CASO O REGISTRO GRAVADO PELO ³±±
±±³          ³          USUARIO ESTEJA POSICIONADO.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ConfirmSXE(lPosConf)
Local nReg as numeric
Local cAlias as char
Local aArea as array
Local nTimes as numeric
Local cAliasSXE as char
Local cSeqSXE as char

cAlias := Alias()
aArea  := GetArea()
nTimes := 0

DEFAULT lPosConf := .F.

lPosConf := If(ValType(lPosConf) == "L",lPosConf,.F.)

LS_Em_Server()

IF __lSemServer
   Return ConFirmLS(lPosConf)
Endif


If Len(aSX8) < 1
	__lSx8 := .f.
EndIf

If !__lSx8
	Return Nil
EndIf

nReg := aSx8[len(aSx8),1]
If lPosConf
	If aSX8[len(aSx8),4] <> Nil .And. aSX8[len(aSx8),3] <> Nil  .And. Select(cAlias) > 0
		cAliasSXE := cAlias
		cSeqSXE := (cAliasSXE)->(&(aSX8[len(aSx8),3]))
	Else
		lPosConf := .F.
	EndIf
EndIf

DbSelectArea("SXF")
DbGoTo(nReg)
aDel(aSX8,len(aSX8))
aSize(aSX8,len(aSX8)-1)
If !lPosConf .Or. ( XF_ALIAS == cAliasSXE .And. Substr(XF_NUMERO,1,XF_TAMANHO) == cSeqSXE)
	nTimes := 0
	While !MsRLock(RecNo())
		nTimes++
		If nTimes > 20
			If NetCancel()
				Final( "Probs.Lock SXF" ) //"Problemas de Lock no SX8"
			Else
				nTimes := 0
			EndIf
		EndIf
		Inkey( ntimes/24 )
	End
	dbDelete()
	dbCommit()
	MsRUnLock(nReg)
	DbCommit()
EndIf

RestArea(aArea)
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CriaSXE	 ³Autor	 ³ Ary Medeiros 	    ³ Data ³		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria registro no SX8 para alias nao Localizado			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³CriaSXE() 																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriaSXE(cAlias,cCpoSx8,cAliasSx8,nOrdSX8,lInServer)
Local cSavAlias := Alias(), nRecno, nOrdem, cNum, cFilCpo
Local lCampo := .t., cProva, aArquivos, nTamanho, lNetErr := .T., nTimes := 0
Local nHdl := -1, nTrys := 0, lFound, cCampo,cFilter, cSerie, nOrd, nNum, uRet
Local cMvUniao, cMvMunic, cMvRecEst
Local nSizeFil := 2   
Local cQuery 	:= ""
Local cAliasSE5 := ""
Local aAreaAux	:= {}
Local cAliasAux

DEFAULT lInServer := .f.

cNum := Nil

If ( ExistBlock("CRIASXE") )
	uRet := ExecBlock("CRIASXE",.f.,.f.,{cAlias,cCpoSx8,cAliasSx8,nOrdSX8})
	If ( ValType(uRet) == 'C' )
		cNum 	:= uRet
		nTamanho:=Len(cNum)
	EndIf
EndIf

IF cNum == Nil
	nOrdSX8 := Iif(nOrdSX8 == Nil,1,nOrdSX8)
	Do Case
		Case cAlias == "SA1"
			cCampo := "A1_COD"
		Case cAlias == "SA2"
			cCampo := "A2_COD"
		Case cAlias == "SB1"
			cCampo := "B1_COD"
		Case cAlias == "SC1"
			cCampo := "C1_NUM"
		Case cAlias == "SC2"
			cCampo := "C2_NUM"
		Case cAlias == "SC5"
			cCampo := "C5_NUM"
		Case cAlias == "SC7"
			cCampo := "C7_NUM"
		Case cAlias == "SC8"
			cCampo := "C8_NUM"
		Case cAlias == "SI2"
			cCampo := "I2_NUM"
		Case cAlias == "SL1"
			cCampo := "L1_NUM"
		Case cAlias == "NFF"
		   	IF cAliasSX8 == Nil
			   UserException("Invalid Use OF GetSXENum With NFF Alias")
			Endif
		   	lCampo := .f.
		   	cSerie := Subs(cAliasSX8,1,3)
			nTamanho := Len(SF2->F2_DOC)
			nOrd := SF2->(IndexOrd())
			SF2->(dbSetOrder(4))
			SF2->(DbGoTop())	// Nao tirar -> Ramalho
			SF2->(dbSeek(xFilial("SF2")+cSerie+"zzzzzz",.t.))
			SF2->(dbSkip(-1))
			IF SF2->(Bof()) .Or. SF2->F2_FILIAL+SF2->F2_SERIE != xFilial("SF2")+cSerie
			   nNum := 1 
			Else
			   nNum := Val(SF2->F2_DOC) + 1
			Endif
			cNum := StrZero(nNum,nTamanho,0)
			SF2->(dbSetOrder(nOrd))
		Case cAlias == "PLS"
		
		   	If cAliasSX8 == Nil
			   UserException("Invalid Use OF GetSXENum With PLS Alias")
			EndIf     
			
			lCampo 	 := .f.
		   	cSerie 	 := Subs(cAliasSX8,1,3)
			nTamanho := Len(SE1->E1_NUM)
			nOrd 	 := SE1->( IndexOrd() )

			SE1->( DbSetorder(01) )//E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
			SE1->( DbGoTop() )
			SE1->( MsSeek( xFilial("SE1") + cSerie + Replicate( "z",nTamanho ),.T. ) )
			SE1->( DbSkip(-1) )
			
			If SE1->( Bof() ) .Or. SE1->E1_FILIAL+SE1->E1_PREFIXO != xFilial("SE1")+cSerie
			   nNum := 1
			Else
			   nNum := Val(SE1->E1_NUM) + 1
			EndIf
			
			cNum := StrZero(nNum,nTamanho,0)
			
			SE1->( DbSetOrder(nOrd) )
			
		Case cAlias == "CPR"
			lCampo := .f.
			cProva	 := GetMv("MV_PROVA")
			aArquivos := DIRECTORY(cProva+"SP*.*")
			If Len(aArquivos) == 0
				cNum := "0001"
			Else
				aArquivos:=ASORT(aArquivos,,, { | x ,y| x[1] < y[1] } )
				cNum := StrZero(Val(Substr(aArquivos[Len(aArquivos)][1],5,4))+1,4)
			EndIf
			nTamanho := 4
		Case cAlias == "_CT"    //Numeador do CTK

			aAreaAux := GetArea()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A numeração deve ser unica por empresa.                            ³
			//³Não adicionar a expressão: CTK_FILIAL = '" + xFilial( "CTK" ) + "'"³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "SELECT MAX(CTK_SEQUEN) SEQUEN "
			cQuery += "  FROM " + RetSqlName( "CTK" ) + " CTK "
			cQuery += " WHERE D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery( cQuery )
			
			cAliasAux := GetNextAlias()  
			
			dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasAux, .F., .T. )
			
			IF Select( cAliasAux ) > 0
				If !Empty(  (cAliasAux)->SEQUEN )
					cNum := Soma1((cAliasAux)->SEQUEN)
				Else
					cNum := "0000000001"
				Endif
				nTamanho := 10
				lCampo   := .F.
				
				DbSelectArea(cAliasAux)
				DbCloseArea()
			Endif
				
			RestArea(aAreaAux)
					
		Case cAlias == "TRB"
			lCampo := .f.
			cNum := "00001"
			nTamanho := 5 
		Case cAlias == "SSC"
			cCampo := "SC_VIAGEM"
		Case cAlias == "SS2"
			cCampo := "S2_CODIGO"
		Case cAlias == "ACF"
			cCampo := "ACF_CODIGO"
		Case cAlias == "SUA"
			cCampo := "UA_NUM"
		Case cAlias == "SUC"
			cCampo := "UC_CODIGO"
		Case cAlias == "SY6"
			cCampo := "Y6_CODLEIT"
		Case cAlias == "SY4"
			cCampo := "Y4_CODEMP"
		Case cAlias == "SY8"
			cCampo := "Y8_CODREV"
		Case cAlias == "SYA"
			cCampo := "YA_CODPECA"
		Case cAlias == "SYE"
			cCampo := "YE_CODPEnd"
		Case cAlias == "SYR"
			cCampo := "YR_CODHIST"
		Case cAlias == "SYI"
			cCampo := "YI_CODAL"
		Case cAlias == "SYC"
			cCampo := "YC_CODPLAN"
		Case cAlias == "SGJ"         //GUTEMBERG
			cCampo := "GJ_FICHA"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Arquivos do modulo de Administracao de Oficina e Veiculos	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case cAlias == "SO8"
			cCampo := "O8_NUM"
		Case cAlias == "SO1"
			cCampo := "O1_CODIGO"
		Case cAlias == "SO2"
			cCampo := "O2_CODIGO"
		Case cAlias == "SO3"
			cCampo := "O3_CODIGO"
		Case cAlias == "SO5"
			cCampo := "O5_CODIGO"
		Case cAlias == "SV1"
			cCampo := "V1_CODIGO"
		Case cAlias == "CE5"
			cCampo := "CE5_CODIGO"
		Case cAlias == "CF8"
			cCampo := "CF8_CODIGO"
		Case cAlias == "CCE"
			cCampo := "CCE_COD"	 
		Case cAlias == "SE5"     
			//------------------------------------------------------------
		    // E5_PROCTRA será sempre incrementado independente de filial.
	   		//------------------------------------------------------------
			If ( cCpoSX8 == "E5_PROCTRA" ) 
				lCampo 	 	:= .F. 
				nTamanho	:= Len( SE5->E5_PROCTRA )
				aAreaAux := GetArea()
		    	cAliasSE5 	:= GetNextAlias()  
     			
				//--------------------------------------------
			    // Recupera o MAX do campo. 
		   		//--------------------------------------------
			    cQuery := " SELECT MAX(E5_PROCTRA) E5_PROCTRA "
			    cQuery += " FROM " 
			    cQuery += RetSqlName("SE5") 
			    cQuery += " WHERE " 
			    cQuery += " D_E_L_E_T_ = '' "
            
			    DBUseArea( .T., "TOPCONN", TcGenQry(,, ChangeQuery( cQuery ) ), cAliasSE5, .T., .T. )
                 
				//--------------------------------------------
		    	// Incrementa 1 ao valor do campo. 
	   			//--------------------------------------------
				cNum := (cAliasSE5)->E5_PROCTRA
				cNum := Soma1( cNum )

				(cAliasSE5)->( DBCloseArea() )
				RestArea(aAreaAux)
			EndIf		
		Case cAlias == "SE1" .And. Alltrim( cCpoSx8 ) == 'E1_IDCNAB'    //Numerador do IDCNAB

			
			aAreaAux := GetArea()

			cQuery := "SELECT MAX(SE1.E1_IDCNAB) CNAB "
			cQuery += "  FROM " + RetSqlName( "SE1" ) + " SE1 "
			cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial( 'SE1' ) + "'"
			cQuery += "   AND SE1.D_E_L_E_T_ = ' '"

			cQuery := ChangeQuery( cQuery )
			
			cAliasAux := GetNextAlias()  
			
			dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasAux, .F., .T. )
			
			IF Select( cAliasAux ) > 0
				If !Empty( (cAliasAux)->CNAB )
					cNum := Soma1( (cAliasAux)->CNAB )
				Else
					cNum := "0000000001"
				Endif
				nTamanho := 10
				lCampo   := .F.
				
				DbSelectArea(cAliasAux)
				DbCloseArea()
			Endif
			
			RestArea(aAreaAux)
			
		 Case cAlias == "SE2" .And. Alltrim( cCpoSx8 ) == 'E2_IDCNAB'    //Numerador do IDCNAB

			
			aAreaAux := GetArea()

			cQuery := "SELECT MAX(SE2.E2_IDCNAB) CNAB "
			cQuery += "  FROM " + RetSqlName( "SE2" ) + " SE2 "
			cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial( 'SE2' ) + "'"
			cQuery += "   AND SE2.D_E_L_E_T_ = ' '"

			cQuery := ChangeQuery( cQuery )
			
			cAliasAux := GetNextAlias()  
			
			dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasAux, .F., .T. )
			
			IF Select( cAliasAux ) > 0
				If !Empty( (cAliasAux)->CNAB )
					cNum := Soma1( (cAliasAux)->CNAB )
				Else
					cNum := "0000000001"
				Endif
				nTamanho := 10
				lCampo   := .F.
				
				DbSelectArea(cAliasAux)
				DbCloseArea()
			Endif
			
			RestArea(aAreaAux)

		Case cAlias == "NXA" //Numeração de Faturas SIGAPFS
			lCampo   := .F.
			cNum     := J203CriaSXE({cAlias,cCpoSx8,cAliasSx8,nOrdSX8})
			nTamanho := TamSX3(cCpoSx8)[1]
			
		Case cAlias $ "G3P|G3Q" //Numeração de Registros de Venda SIGATUR
			lCampo   := .F.
			cNum     := T034CriaSXE(cAlias,cCpoSx8,cAliasSx8,nOrdSX8)
			nTamanho := TamSX3(cCpoSx8)[1]	
		
				
	EndCase
	If cCpoSX8 != Nil
		cCampo := cCpoSX8
	EndIf
	
	If lCampo
		cFilCpo := PrefixoCpo(cAlias)+"_FILIAL"
		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek(cCampo)
		DbSetOrder(1)
		DbSelectArea(cAlias)
		nRecno := Recno()
		nOrdem := IndexOrd()
		DbSetOrder(nOrdSX8)
		cFilter := dbFilter()
		IF cAlias == "SA1"
		   cMvUniao := Padr(GetMV("MV_UNIAO"),Len(SA1->A1_COD))
		   cMvMunic := Padr(GetMV("MV_MUNIC"),Len(SA1->A1_COD))
		   cMvRecEst:=	Padr(GetNewPar("MV_RECEST",""),Len(SA1->A1_COD))
	       DbSelectArea(cAlias)
		   Set Filter to ( A1_COD != cMvUniao .and. A1_COD != cMvMunic .And. A1_COD != cMvRecEst) 
		ElseIf ( cAlias == 'SA2' )
		   cMvUniao := Padr(GetMV("MV_UNIAO"),Len(SA2->A2_COD))
		   cMvMunic := Padr(GetMV("MV_MUNIC"),Len(SA2->A2_COD))
		   cMvRecEst:=	Padr(GetNewPar("MV_RECEST",""),Len(SA2->A2_COD))
	       DbSelectArea(cAlias)
		   SET FILTER TO ( A2_COD != cMvUniao .And. A2_COD != cMvMunic .And. A2_COD != cMvRecEst) 
		ElseIF cAlias == "SB1"
		   Set Filter to Subs(B1_COD,1,3) != "MOD"
		Else
		   DbClearFilter()
		Endif
		DbGoTop()		// Nao tirar !!!!!!!! - Eh usado para resolver problema quando o SXE eh chamado apos o SetDummy
		DbSeek(xFilial(cAlias)+'z',.t.)
		DbSkip(-1)
		DbSetOrder(nOrdem)
		//-- Atualiza o conteúdo da filial
		nSizeFil := FWSizeFilial()

		If (Substr(&(cFilCpo),1,nSizeFil) != xFilial(cAlias)) .or. (LastRec()==0)
			cNum := Replicate("0",SX3->X3_TAMANHO)
		Else
			cNum := &(cCampo)
		EndIf
		DbGoTo(nRecno)
		If !Empty(cFilter)
			Set Filter to &cFilter
		Else
			DbClearFilter()
		EndIf
		cNum := Soma1(cNum)
		nTamanho := SX3->X3_TAMANHO
		
	EndIf

EndIf

IF lInServer
   Return cNum
Endif

nTrys := 0
While !LockByName("SOSXE"+cAlias)
	Inkey(3)
	nTrys++
	If nTrys > 20
		FINAL("PROBS.CRIASXE")
	EndIf
End

DbSelectArea("SXE")   //Garantir que nao existe o Registro
DbGoTop()
lFound := .f.

While !Eof()
	If XE_FILIAL+XE_ALIAS == cAliasSX8+cAlias
		lFound := .t.
		Exit
	EndIf
	DbSkip()
End

If !lFound
	While lNetErr
		dbAppEnd(.f.)
		lNetErr := NetErr()
		nTimes ++
		If nTimes > 20
			If NetCancel()
				Final( oemtoansi(STR0021) ) //"Problema de GRAVACAO NO SX8"
			Else
				nTimes := 0
			EndIf
		EndIf
		If ( lNetErr )
			Inkey( nTimes/24 )	
		EndIf
	End
	MSRLock(Recno())
	Replace XE_ALIAS with cAlias, XE_TAMANHO with nTamanho,XE_FILIAL with cAliasSx8
	Replace XE_NUMERO with cNum
	dbCommit()
	MsRUnLock(Recno())
EndIf
UnLockByName("SOSXE"+cAlias)
Return cNum

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GetLSNum³Autor  ³ Protheus			  ³ Data ³	   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                      			     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³GetLSNum( ) 												           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetLSNum(cAlias,cCpoSx8,cAliasSX8,nOrdem)
Local cRet as char
local nRet as numeric
Local nSizeFil as numeric

nSizeFil := 2

DEFAULT __SpecialKey := Upper(GetSrvProfString("SpecialKey", ""))
DEFAULT __aKeys := {}
nOrdem := Iif(nOrdem == Nil,1,nOrdem)

//-- Atualiza o conteúdo da filial
nSizeFil := FWSizeFilial()

If cAliasSX8 == Nil
	cAliasSx8  :=   PADR(xFilial(cAlias)+Upper(x2path(cAlias)),48+nSizeFil)
Else
	cAliasSx8  :=   Upper(Padr(cAliasSx8,48+nSizeFil))
EndIf

cRet := LS_GetNum(__SpecialKey+cAliasSX8+cAlias)

If ( Empty(cRet) )
   cRet := CriaSXE(cAlias, cCpoSX8,cAliasSx8,nOrdem,.t.)
   nRet := LS_CreateNum(__SpecialKey+cAliasSx8+cAlias, cRet)
   IF nRet < 0 .and. nRet != -12    // Chave Duplicada eh -12
      UserException(" Error On LS_CreateNum : "+Str(nRet,4,0))
   Endif
   cRet := LS_GetNum(__SpecialKey+cAliasSX8+cAlias)
   IF Empty(cRet)
      UserException(" Error On GetLSNUM : Empty")
   Endif
EndIf

Aadd(__aKeys,{ __SpecialKey+cAliasSX8+cAlias,cret, cAlias,cCpoSX8})
__lSX8 := .t.

If cAlias $ "AD1|ADY"
	ConOut("################ CRM GetLSNum ########## ThreadID:"+cValToChar(ThreadID()) +" Tabela: " + cAlias +" Num: " + cRet)
EndIf


Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ RollbackLS³Autor  ³ Protheus			  ³ Data ³	   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cancela a numeração do License			     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³RollbackLS( ) 												           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RollbackLS()  
Local nLen as numeric
Local nRet as numeric

DEFAULT __aKeys := {}
DEFAULT nLen 	:= Len(__aKeys)

IF nLen > 0
   nRet := LS_RollBackNum(__aKeys[nLen,1], __aKeys[nLen,2]) 
   //    -11: cChave+ cValue não encontrada. 
   //    0: OK
   //   -1: No Connection (é melhor abortar ou vc trata no programa?)
   //   -6: Erro inesperado (é melhor abortar ou vc trata no programa?)
   //   (os 3 últimos códigos são iguais aos retornos do License Server)
   IF nRet < 0
      UserException(" Error On RollBackLS : "+Str(nRet,4,0))
   Else
	   If __aKeys[nLen,3] $ "AD1|ADY" 
			ConOut("################ CRM RollBackLS ########## ThreadID:"+cValToChar(ThreadID()) +" Tabela: " +__aKeys[nLen,3] +" Num: " +__aKeys[nLen,2] )
		EndIf
   Endif
   __aKeys := aDel(__aKeys,nLen)
   __aKeys := aSize(__aKeys,nLen-1)
   __lSX8 := (Len(__aKeys) > 0)
Endif
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ ConFirmLS³Autor  ³ Protheus			  ³ Data ³	   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Confirma a numeração do License			     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ConFirmLS( ) 												           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ConFirmLS(lPosConf)
Local cAlias as char
Local nLen as numeric
Local nRet as numeric
Local cAliasSXE as char
Local cSeqSXE as char

cAlias := Alias()

DEFAULT lPosConf := .F.
DEFAULT __aKeys := {}

nLen 	:= Len(__aKeys)

IF nLen > 0
	If lPosConf
		If __aKeys[nLen,3]<> Nil .And. __aKeys[nLen,4] <> Nil .And. Select(cAlias) > 0 
			cAliasSXE := cAlias
			cSeqSXE := (cAliasSXE)->(&(__aKeys[nLen,4]))
		Else
			lPosConf := .F.
		EndIf 
	EndIf
	If !lPosConf .Or. ( __aKeys[nLen,3] == cAliasSXE .And. __aKeys[nLen,2] == cSeqSXE )
	   nRet := LS_ConfirmNum(__aKeys[nLen,1], __aKeys[nLen,2])
	   //    -11: cChave+ cValue não encontrada. 
	   //    0: OK
	   //   -1: No Connection (é melhor abortar ou vc trata no programa?)
	   //   -6: Erro inesperado (é melhor abortar ou vc trata no programa?)
	   //   (os 3 últimos códigos são iguais aos retornos do License Server)
	   IF nRet < 0
	      UserException(" Error On ConfirmLS : "+Str(nRet,4,0))
	   Else
	   		If __aKeys[nLen,3] $ "AD1|ADY"
				ConOut("################ CRM LS_ConfirmNum ########## ThreadID:"+cValToChar(ThreadID()) +" Tabela: " +__aKeys[nLen,3]+" Num: " +__aKeys[nLen,2] )
			EndIf 		
	   Endif
	Else
	   nRet := LS_RollBackNum(__aKeys[nLen,1], __aKeys[nLen,2]) 
	   //    -11: cChave+ cValue não encontrada. 
	   //    0: OK
	   //   -1: No Connection (é melhor abortar ou vc trata no programa?)
	   //   -6: Erro inesperado (é melhor abortar ou vc trata no programa?)
	   //   (os 3 últimos códigos são iguais aos retornos do License Server)
	   IF nRet < 0
	      UserException(" Error On RollBackLS : "+Str(nRet,4,0))
	   Else
	   		If __aKeys[nLen,3] $ "AD1|ADY"
				ConOut("################ CRM LS_RollBackNum dentro LS_ConfirmNum ########## ThreadID:"+cValToChar(ThreadID()) +" Tabela: " +cAlias +" Num: " +__aKeys[nLen,2] )
			EndIf 	
	   Endif
	EndIf
   __aKeys := aDel(__aKeys,nLen)
   __aKeys := aSize(__aKeys,nLen-1)
   __lSX8 := (Len(__aKeys) > 0)
Endif
If ! Empty( cAlias )
	DbSelectArea(cAlias)
EndIf
Return Nil

/*/{Protheus.doc} SetX8Key
	Devolve o conteúdo do array __aKeys / usado pela lib
@return __aKeys
@author josimar.assuncao
@since 23.07.2018
/*/
Function SetX8Key(__SpecialKey, cAliasSX8, cAlias, cRet, cAlias, cCpoSX8)
	Default __aKeys := {}
	aAdd(__aKeys,{ __SpecialKey+cAliasSX8+cAlias, cRet, cAlias, cCpoSX8})
Return

/*/{Protheus.doc} GetX8Keys
	Devolve o conteúdo do array __aKeys / usado pela lib
@return __aKeys
@author josimar.assuncao
@since 23.07.2018
/*/
Function GetX8Keys()
	Default __aKeys := {}
Return __aKeys


//-------------------------------------------------------------------
/*/{Protheus.doc} FwSetLsEmServer
Função que força a varíavel lsEmServer. Somente pode ser utilizada pelo teste unitário
@return lOld Retorna o valor antigo da varíavel
@author  jandir.silva
@since   05/02/2018
@version P12
@protected
/*/
//-------------------------------------------------------------------
Static Function FwSetLsEmServer(lSet)

	Local lOld as logical 
	
	If !ProcSource(1) == "FWGETSXENUMTESTCASE.PRW"
		UserException(STR0050)//"Uso inválido da função FwSetLsEmServer"
	Else
		lOld := __lSemServer
		__lSemServer := lSet
	Endif 
	
Return lOld

//-------------------------------------------------------------------
/*/{Protheus.doc} LS_Em_Server
Verifica e faz o set em relação ao LS em Server

@author  Daniel Mendes
@since   16/05/2019
@version 1.0
@protected
/*/
//-------------------------------------------------------------------
static function LS_Em_Server()

if __lSemServer == nil
	//--------------------------------------------------------------------------------
	// Ajuste para que a lib execute o mesmo tratamento para o controle de numeração
	//--------------------------------------------------------------------------------
	if FWLibVersion() >= "20181101"
		if LS_GetLicense(10000) >= 0 //GetCountLicense() .or. nModulo == 99
			__lSemServer := .T.
		else
			__lSemServer := .F.
		endIf
	else
		if GetCountLicense() .or. nModulo == 99
			__lSemServer := ( LS_GetLicense(10000) >= 0 )
		else
			__lSemServer := .F.
		endIf
	endIf
endif

return nil