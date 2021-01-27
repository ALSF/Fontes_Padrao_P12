#Include 'Protheus.ch'
#Include 'CFGX049B.CH'

Static nCtrlFor	:= 0

//-------------------------------------------------------------------
/*/{Protheus.doc} CFGX049B06()
Função que verifica e valida se existe mais do que uma tela do wizard para manutenção e edição do CNAB

@author Francisco Oliveira
@since  10/07/2016
@version 12.1.019
/*/
//-------------------------------------------------------------------
Function CFGX049B06(aDdsEdit, nVlrFor, oPanel, nLenEdi) As Logical
	
	Local lRet	As Logical
	
	lRet	:= .F.
	
	If !lVldRep
		nCtrlFor := 0
	Endif
	
	If nCtrlFor == 0 .And. nVlrFor == 1 .And. !lVldRep
		lVldRep	:= .T.
		nCtrlFor := nCtrlFor + 1
	Endif
	
	If Len(aDdsEdit) == 0 .And. nCtrlFor <= nLenEdi
		StaticCall(CFGX049B, cria_pn6,oPanel, nCtrlFor := nCtrlFor + 1)
		Return .F.
	ElseIf Len(aDdsEdit) == 0 .And. nCtrlFor > nLenEdi
		Return .T.
	Endif
	
	If Len(aDdsEdit) < 1
		Return(.T.)
	Endif
	
	If nCtrlFor == 1
		If nCtrPrev == 1
			lRet := .T.
			nCtrlFor	:= nCtrlFor + 1
			lRet := CFGX049B6A(aDdsEdit)
		ElseIf nCtrPrev > 1
			nCtrlFor	:= nCtrlFor + 1
			lRet := CFGX049B6A(aDdsEdit)
			If lRet
				cria_pn6(oPanel, nCtrlFor)
			Endif
		Endif
	ElseIf nCtrlFor > 1
		If nCtrlFor < nCtrPrev
			nCtrlFor	:= nCtrlFor + 1
			lRet := CFGX049B6A(aDdsEdit)
			If lRet
				cria_pn6(oPanel, nCtrlFor)
			Endif
		Else
			nCtrlFor	:= nCtrlFor + 1
			lRet := CFGX049B6A(aDdsEdit)
			lRet := .T.
		Endif
	Endif
	
	If lRet
		If nCtrPrev >= nCtrlFor
			lRet	:= .F.
		ElseIf  nCtrPrev < nCtrlFor
			lRet	:= .T.
		Endif
	Endif
	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CFGX049B6A()
Função que verifica e valida se existe mais do que uma tela do wizard para manutenção e edição do CNAB

@author Francisco Oliveira
@since  10/07/2016
@version 12.1.019
/*/
//-------------------------------------------------------------------
Function CFGX049B6A(aDdsEdit) As Logical
	
	Local nY		As Numeric
	Local lRet		As Logical
	Local cBanco	As Character
	Local cVersao	As Character
	Local cModulo	As Character
	Local cTipo		As Character

	nY		:= 0
	lRet	:= .F.
	cBanco	:= aDdsEdit[1][1]
	cVersao	:= aDdsEdit[1][8]
	cModulo	:= ""
	cTipo	:= ""
	
	cModulo	:= Iif(UPPER(SubStr(aDdsEdit[1][09],1,3)) = "PAG", "PAG", "REC" )
	cTipo	:= Iif(UPPER(SubStr(aDdsEdit[1][10],1,3)) = "REM", "REM", "RET" )
	
	DbSelectArea("FOP")
	FOP->(DbSetOrder(3))
	FOP->(DbGoTop())
	
	For nY := 1 To Len(aDdsEdit)
		If FOP->(DbSeek(FwxFilial("FOP") + cBanco + cVersao + cModulo + cTipo + aDdsEdit[nY][7] ))
			FOP->(RecLock("FOP", .F.))
			FOP->FOP_CONARQ	:= Alltrim(aDdsEdit[nY][14])
			FOP->(MsUnLock())
		Endif
		lRet	:= .T.
	Next nY
	
	Processa({|| lRet := CFGX049B08(cBanco, cVersao, cModulo, cTipo)}, OemToAnsi(STR0080)) // "Processando Arquivos de Configuração"
	
Return lRet

