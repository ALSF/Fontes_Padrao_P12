#Include 'Protheus.ch'
#Include 'FWMVCDEF.CH'
#Include 'CFGX049B.CH'

//------------------------------------------------------------------
/*/{Protheus.doc} CFGX049B08
Rotina de criação dos arquivos texto de configuração CNAB - *.2PE, *.2PR, *.2RE, *.2RR

@Project 	CNAB Cloud
@author	Francisco Oliveira
@since		09/10/2017

@return 	Nil
/*/
//------------------------------------------------------------------
Function CFGX049B08(cBanco As Character, cVersao As Character, cModulo As Character, cTipo As Character) As Logical
	
	Local nHdlGrv		As Numeric
	Local lRet			As Logical
	Local cLin			As Character
	Local cExtArq		As Character
	Local cEndGrv		As Character
	Local cMod			As Character
	Local cTip			As Character
	Local cEOL	    	As Character

	Default cBanco	:= ""
	Default cVersao	:= ""
	Default cModulo	:= ""
	Default cTipo	:= ""

	nHdlGrv		:= Nil
	lRet		:= .T.
	cLin		:= ""
	cExtArq		:= ""
	cEndGrv		:= GetSrvProfString("StartPath", "\undefined")
	cMod		:= Iif(cModulo == "PAG", "P", "R" )
	cTip		:= Iif(cTipo   == "REM", "ENV", "RET" )
	cEOL	   	:= "CHR(13)+CHR(10)"
	
	If cModulo == "PAG" .And. cTipo == "REM"
		cExtArq := "2PE"
	ElseIf cModulo == "PAG" .And. cTipo == "RET"
		cExtArq	:= "2PR"
	ElseIf cModulo == "REC" .And. cTipo == "REM"
		cExtArq	:= "2RE"
	ElseIf cModulo == "REC" .And. cTipo == "RET"
		cExtArq	:= "2RR"
	Endif
	
	cEndGrv	+= cBanco + cMod + cTip + "." + cExtArq
	
	nHdlGrv  := fCreate(Upper(cEndGrv))
	
	If nHdlGrv == -1
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0088) + cEndGrv + OemToAnsi(STR0089), {"Ok"}, 3) //"O arquivo de nome " -- " nao pode ser executado! Verifique os parametros."
		Return
	Endif
	
	DbSelectArea("FOP")
	FOP->(DbSetOrder(3))
	FOP->(DbGoTop())
	
	If FOP->(DbSeek(xFilial("FOP") + cBanco + cVersao + cModulo + cTipo ))
		
		cLin	:= ""
		
		While !FOP->(EOF()) .And. FOP->FOP_BANCO == cBanco .And. FOP->FOP_VERARQ == cVersao .And. FOP->FOP_PAGREC == cModulo .And. FOP->FOP_REMRET == cTipo
			
			cLin	:= ""
			
			If FOP->FOP_BLOQUE == "2"
				If FOP->FOP_IDELIN == "1"
					cLin	+= FOP->FOP_IDELIN
					cLin	+= FOP->FOP_HEADET
					cLin	+= FOP->FOP_CHALIN
					cLin	+= FOP->FOP_IDESEG
					cLin	+= PADR(FOP->FOP_DESMOV,030,"")
					cLin	+= PADR(FOP->FOP_CONARQ,205,"")
				ElseIf FOP->FOP_IDELIN == "2"
					cLin	+= FOP->FOP_IDELIN
					cLin	+= FOP->FOP_HEADET
					cLin	+= FOP->FOP_CHALIN
					cLin	+= FOP->FOP_IDESEG
					cLin	+= PADR(FOP->FOP_DESMOV,15,"")
					cLin	+= FOP->FOP_POSINI
					cLin	+= FOP->FOP_POSFIM
					cLin	+= FOP->FOP_DECIMA
					cLin	+= PADR(FOP->FOP_CONARQ,220,"")
				Endif
			Endif

			// Ajusta tamanho da linha para 500 bytes			
			cLin := Alltrim(cLin)
			cLin += Space(500-Len(cLin))

			// Pula Linha
			cLin += &cEOL
			
			If fWrite(nHdlGrv,cLin,Len(cLin)) != Len(cLin)
				If Aviso(OemToAnsi(STR0035), OemToAnsi(STR0090), {"Ok"}, 3) //"Ocorreu um erro na gravacao do arquivo. Favor Verificar?"
					lRet	:= .F.
					Return
				Endif
			Endif
			
			FOP->(DbSkip())
		Enddo
	Endif
	
	fClose(nHdlGrv)
	
Return lRet


