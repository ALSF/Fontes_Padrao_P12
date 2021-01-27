#Include 'Protheus.ch'
#Include 'CFGX049B.CH'

//---------------------------------------------------------------------------------------
/*/ {Protheus.doc} CFGX049B99()
Função que irá tratar a leitura de arquivo de configuração e geração e gravação de fonte

@author	Francisco Oliveira
@since		13/12/2017
@version	P12
@Function  CFGX049B99()
@Return	Array com as informações para alteração
@param
@Obs
/*/
//---------------------------------------------------------------------------------------
Function CFGX049B99()
	
	Local oDlg
	
	Private _cNomArq	:= SPACE(10)
	
	DEFINE MsDialog oDlg TITLE OemToAnsi(STR0131) FROM 0,0 TO 160,352 OF oDlg PIXEL // "Lê arquivo validação CNAB"
	
	@ 030,020 SAY OemToAnsi(STR0132)	SIZE 150,08 PIXEL Of oDlg // "Informe o nome do arquivo"
	@ 030,090 MSGET _cNomArq  	 PICTURE "@!"  	SIZE 050,08 PIXEL OF oDlg Valid !Empty(_cNomArq)
	
	@ 053,055 BUTTON OemToAnsi(STR0119)	SIZE 36,16 PIXEL ACTION {||oDlg:End()} 				Message OemToAnsi(STR0121) of oDlg // "&Cancelar" + "Clique aqui para Cancelar"
	@ 053,105 BUTTON OemToAnsi(STR0120)	SIZE 36,16 PIXEL ACTION {||xLeArquivo(),oDlg:End()}	Message OemToAnsi(STR0122) of oDlg // "&Confirmar" + "Clique aqui para Ler Arquivo"
	
	ACTIVATE MSDIALOG oDlg CENTER
	
Return

//----------------------------------------------------------------------------------------------

Static Function xLeArquivo()
	
	Processa( {|| xImpArq() }, OemToAnsi(STR0080) )
	
Return


//----------------------------------------------------------------------------------------------

Static Function xImpArq()
	
	Local nHdlLe	As Numeric
	Local nHdlGrv	As Numeric
	Local nJ		As Numeric
	Local nLin		As Numeric
	Local lChk		As Logical
	Local lNivel1	As Logical
	Local lNivel2	As Logical
	Local nCount	As Numeric
	Local aDdsAlt	As Array
	Local cBuffer	As Character
	Local cFileOpen	As Character
	Local cFileGrv	As Character
	Local cLin		As Character
	Local cBanco	As Character
	Local cCart		As Character
	Local cTipo		As Character
	Local cTitulo1  As Character
	Local cTitulo2	As Character
	Local cPathLe	As Character
	Local cPathGrv	As Character
	Local cIdent	As Character
	Local cOldIdent	As Character
	Local cAux		As Character
	
	Private cExtens	As Character

	nHdlLe		:= 0
	nHdlGrv		:= 0
	nJ			:= 0
	nLin		:= 0
	lChk		:= .T.
	lNivel1		:= .T.
	lNivel2		:= .T.
	nCount		:= 1
	aDdsAlt		:= {}
	cBuffer		:= ""
	cFileGrv	:= ""
	cLin		:= ""
	cBanco		:= ""
	cCart		:= ""
	cTipo		:= ""
	cTitulo1	:= OemToAnsi(STR0133) // "Selecione o arquivo"
	cTitulo2	:= OemToAnsi(STR0134) // "Arquivo que será gravado"
	cPathLe		:= "C:\"
	cPathGrv	:= "C:\"
	cExtens		:= OemToAnsi(STR0135) + "| *.*"  // "Arquivo Texto | *.*"
	cFileOpen 	:= cGetFile(cExtens,cTitulo1,,cPathLe,.T.)
	cIdent		:= ""
	cOldIdent	:= ""
	cAux		:= ""
	
	If !File(cFileOpen)
		
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0135) + ": " + cFileOpen + OemToAnsi(STR0136), {"Ok"}, 3) //"Atenção, Arquivo texto: " + cFileOpen + " não localizado"
		Return
	Endif
	
	nHdlLe    := fOpen(cFileOpen)
	
	cFileGrv := cGetFile(cExtens,cTitulo2,,cPathGrv,.T.)
	nHdlGrv  := fCreate(Upper(cFileGrv))
	
	If nHdlGrv == -1
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0088) + cFileOpen + OemToAnsi(STR0089), {"Ok"}, 3) //"O arquivo de nome " + cFileGrv + " nao pode ser executado! Verifique os parametros."
		Return
	Endif
	
	cLin += "#Include 'Protheus.ch' " + CRLF
	cLin += CRLF
	
	cLin += "//------------------------------------------------------------------- " + CRLF
	cLin += "/*/{Protheus.doc} " + Alltrim(_cNomArq) + "()" + CRLF
	cLin += "Rotina para construção de codigo fonte para geração de arquivo CNAB " + CRLF
	cLin += CRLF
	cLin += "@author " + CRLF + " " + CRLF
	cLin += "@since " + DTOC(dDataBase) + "  " + CRLF
	cLin += "@version " + GetVersao() + "  " + CRLF
	cLin += "/*/ " + CRLF
	cLin += "//------------------------------------------------------------------- " + CRLF
	
	
	cLin += "Function " + Alltrim(_cNomArq) + "()" + CRLF
	cLin += CRLF
	cLin += "	Local aRetCNAB	:= {}" + CRLF
	cLin += CRLF
	
	cLin += "	//                  1       2       3       4       5       6       7       8        9" + CRLF
	cLin += "	//              	IDELIN, HEADET, CHALIN, IDESEG, DESMOV, POSINI, POSFIM, DECIMAL, CONARQ" + CRLF
	cLin += "	//	AADD(aRetCNAB, {''    , ''    , ''    , ''    , ''    , ''    , ''    , ''     , ''     } )" + CRLF
	cLin += CRLF
	
	
	If fWrite(nHdlGrv,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert(OemToAnsi(STR0035),OemToAnsi(STR0137)) //"Ocorreu um erro na gravacao do arquivo. Continua?"
			Return
		Endif
	Endif
	
	FT_FUSE(cFileOpen)
	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())
	
	cBanco		:= SubStr(_cNomArq,4,3)
	cTipo		:= SubStr(_cNomArq,8,3)
	cCart		:= Iif(SubStr(_cNomArq,7,1) == "P", "PAG", "REC")
	
	aDdsAlt	:= CFGX049B10(cBanco, cTipo, cCart)
	
	While !FT_FEOF()
		IncProc()
		
		cBuffer := FT_FREADLN()
		cLin := ""
		If SubStr(cBuffer,1,1) == "1"
			
			If lNivel1
				cLin += "    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" + CRLF
				cLin += "    //³ NIVEL 1                 ³" + CRLF
				cLin += "    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" + CRLF
				lNivel1 := .F.
			EndIf

			cLin += "	AADD(aRetCNAB, {"
			cLin += "'" + Alltrim(SubStr(cBuffer,01,001)) + "',"  // Identificação da Linha - '1'
			cLin += "'" + Alltrim(SubStr(cBuffer,02,001)) + "',"  // Header X Detalhe - '0'
			cLin += "'" + Alltrim(SubStr(cBuffer,03,001)) + "',"  // Chave da Linha - 'H'
			cAux := Alltrim(SubStr(cBuffer,04,001))
			cLin += "'" + IIF( Len(cAux) == 0 , cAux + "' ,", cAux + "'," )  // Identificação do Segmento - ' '
			cLin += "'" + Alltrim(SubStr(cBuffer,05,030)) + SPACE(30 - Len(Alltrim(SubStr(cBuffer,05,030)))) + "',"  // ,Descrição Cabeçalho
			cLin += "'" + Alltrim(StrTran(SubStr(cBuffer,35,100),'"','\"')) + "',"  // Descrição Dados executar
			cLin += "'',"
			cLin += "'',"
			cLin += "'" + SPACE(50) + "',"
			
			If Len(aDdsAlt) > 0
				For nJ := 1 To Len(aDdsAlt)
					If aDdsAlt[nJ,1] == Alltrim(SubStr(cBuffer,1,1)) .And. aDdsAlt[nJ,2] == Alltrim(SubStr(cBuffer,2,1)) .And. ;
							aDdsAlt[nJ,3] == Alltrim(SubStr(cBuffer,3,1)) .And. Alltrim(aDdsAlt[nJ,4]) == Alltrim(SubStr(cBuffer,4,1))
						cLin += "'.T.',"  // Editavel sim ou não
						cLin += "'" + Alltrim(StrZero(nCount++,3)) + "',"  // controlador sequencial de linha
						cLin += "'" + aDdsAlt[nJ,7] + "',"  // Valor que será substituido
						cLin += "'" + aDdsAlt[nJ,8] + "'})" // Valor que o cliente poderá escolher para substituir o valor anterior
						lChk	:= .F.
					Endif
				Next nJ
			Endif
			
			If lChk
				cLin += "'.F.',"  // Editavel sim ou não
				cLin += "'" + Alltrim(StrZero(nCount++,3)) + "',"  // controlador sequencial de linha
				cLin += "'',"  // Valor que será substituido
				cLin += "''})" // Valor que o cliente poderá escolher para substituir o valor anterior
			Endif
		ElseIf SubStr(cBuffer,1,1) == "2"

			If lNivel2
				cLin += "    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" + CRLF
				cLin += "    //³ NIVEL 2                 ³" + CRLF
				cLin += "    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" + CRLF
				lNivel2 := .F.
			EndIf

			cIdent	:= Alltrim(SubStr(cBuffer,01,004))
			If cOldIdent != cIdent
				cLin += "	// " + cIdent + " - " + CRLF
				cOldIdent := cIdent
			EndIf

			cLin += "		AADD(aRetCNAB, {"
			cLin += "'" + Alltrim(SubStr(cBuffer,01,001)) + "',"  // Identificação da Linha - '1'
			cLin += "'" + Alltrim(SubStr(cBuffer,02,001)) + "',"  // Header X Detalhe - '0'
			cLin += "'" + Alltrim(SubStr(cBuffer,03,001)) + "',"  // Chave da Linha - 'H'
			cAux := Alltrim(SubStr(cBuffer,04,001)) 
			cLin += "'" + IIF( Len(cAux) == 0 , cAux + "' ,", cAux + "'," )  // Identificação do Segmento - ' '
			cLin += "'" + Alltrim(SubStr(cBuffer,05,015)) + SPACE(15 - Len(Alltrim(SubStr(cBuffer,05,015)))) + "',"  // ,Descrição Cabeçalho
			cLin += "'" + Alltrim(SubStr(cBuffer,20,003)) + "',"  // Posição Inicial
			cLin += "'" + Alltrim(SubStr(cBuffer,23,003)) + "',"  // Posição Final
			cLin += "'" + Alltrim(SubStr(cBuffer,26,001)) + "',"  // Decimal
			cAux := Alltrim(StrTran(SubStr(cBuffer,27,135),'"','\"')) // Descrição Dados executar
			cLin += "'" +  IIF( (nLin := Len( cAux )) <= 46, cAux, cAux + SPACE(46-nLin) ) + "',"
			
			If Len(aDdsAlt) > 0
				For nJ := 1 To Len(aDdsAlt)
					If aDdsAlt[nJ,1] == Alltrim(SubStr(cBuffer,1,1)) .And. aDdsAlt[nJ,2] == Alltrim(SubStr(cBuffer,2,1)) .And. ;
							aDdsAlt[nJ,3] == Alltrim(SubStr(cBuffer,3,1)) .And. AllTrim(aDdsAlt[nJ,4]) == Alltrim(SubStr(cBuffer,4,1)) .And. ;
							aDdsAlt[nJ,5] == Alltrim(SubStr(cBuffer,20,3)) .And. aDdsAlt[nJ,6] == Alltrim(SubStr(cBuffer,23,3))
						cLin += "'.T.',"  // Editavel sim ou não
						cLin += "'" + Alltrim(StrZero(nCount++,3)) + "',"  // controlador sequencial de linha
						cLin += "'" + aDdsAlt[nJ,7] + "',"  // Valor que será substituido
						cLin += "'" + aDdsAlt[nJ,8] + "'})" // Valor que o cliente poderá escolher para substituir o valor anterior
						lChk	:= .F.
					Endif
				Next nJ
			Endif
			
			If lChk
				cLin += "'.F.',"  // Editavel sim ou não
				cLin += "'" + Alltrim(StrZero(nCount++,3)) + "',"  // controlador sequencial de linha
				cLin += "'',"  // Valor que será substituido
				cLin += "''})" // Valor que o cliente poderá escolher para substituir o valor anterior
			Endif
		Endif
		
		cLin += CRLF
		
		If fWrite(nHdlGrv,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert(OemToAnsi(STR0035),OemToAnsi(STR0137)) //"Ocorreu um erro na gravacao do arquivo. Continua?"
				Return
			Endif
		Endif
		lChk	:= .T.
		FT_FSKIP()
	EndDo
	
	cLin := ""
	cLin += CRLF
	cLin += CRLF
	cLin += "Return aRetCNAB "
	cLin += CRLF
	cLin += CRLF
	
	If fWrite(nHdlGrv,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert(OemToAnsi(STR0035),OemToAnsi(STR0137)) //"Ocorreu um erro na gravacao do arquivo. Continua?"
			Return
		Endif
	Endif
	
	fClose(nHdlLe)
	fClose(nHdlGrv)
	
	FT_FUSE()
	
	MsgInfo(OemToAnsi(STR0152)) //"Processo finalizado"
	
Return

