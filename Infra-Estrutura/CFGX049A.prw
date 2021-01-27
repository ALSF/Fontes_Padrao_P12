#Include "Protheus.ch"
#Include "Colors.ch"
#Include "FwMVCdef.ch"
#Include "CFGX049A.ch" 
#include "Fileio.ch"

Static __cNomArt := "Wizard CNAB"
Static __cModelo := ""
Static __aDadLay := {}
Static __lMosAvi := .F.
Static __aTipBco := {}
Static __aCfgVld := {'0', '1', '2', '3', '4', '5', '9'}
Static __cArqBco := ""
Static __cCfgBco := ""
Static __lBancos := .F. 
Static __aDados := {}
Static __cArqAnt := ""
Static __lCfgUpd := .F.

//-------------------------------------------------------------------
/*/{Protheus.doc} CFGX049A
Wizard CNAB

@author Pedro Alencar
@since 06/12/13
@version P11.90
/*/
//-------------------------------------------------------------------
Function CFGX049A
	Local aSayFrm := {}
	Local aButFrm := {}
	Local aRetPar := {Space(50), Space(50)}
	Local lExeFun := .F.
	Local aCabLay := {}
	Local aColLay := {}
	Local aPosLay := {}
	Local aLstDad := {}
	Local aSegLay := {}
	Local aAviLay := {}
	Local cAuxRoot := ""
	Local cAuxStart := ""
	Local bBtn1
	
	//Pega o caminho do RoothPath e do StartPath
	cAuxRoot := AllTrim(GetSrvProfString ("RootPath", ""))
	cAuxStart := AllTrim(GetSrvProfString ("StartPath", ""))
	
	//Trata as barras no RoothPath e StartPath 
	cAuxRoot := Iif(Right(cAuxRoot, 1) == "\", cAuxRoot, cAuxRoot + "\")  
	cAuxStart := Iif(Left(cAuxStart,1) == "\", SubStr(cAuxStart,2) , cAuxStart) 
	cAuxStart := Iif(Right(cAuxStart, 1) == "\", cAuxStart, cAuxStart + "\")
	
	//Carrega os caminhos dos arquivos de configuração do banco 
	__cArqBco := cAuxRoot + cAuxStart + "eos_cnab.bco"    
	__cCfgBco := cAuxRoot + cAuxStart + "eos_cnab."
	
	Processa({|| FLoaCfg()}, OemToAnsi(STR0003)) //Pré-Carregando definições

	aAdd(aSayFrm, OemToAnsi(STR0004)) // Este programa permite ao usuário a visualização, simplificada dos arquivos
	aAdd(aSayFrm, OemToAnsi(STR0005))// gerados de CNAB utilizando os layouts como referência para identificação
	aAdd(aSayFrm, OemToAnsi(STR0006))// Favor referir a documentação técnica bancária para entendimento do Layout aceito.
	aAdd(aSayFrm, '')
	aAdd(aSayFrm, OemToAnsi(STR0007)) // Dica: Para abrir diretamente a tela de preferências, mantenha os parametros vazios.
	aAdd(aSayFrm, OemToAnsi(STR0101 + GetMV("MV_CNABTDN",.t.,"http://tdn.totvs.com/display/public/PROT/FIN0001_CNAB_Modelos_de_Layout")))  // 'Modelos em ' 
		
	aAdd(aButFrm, {5, .T., {|| FTelPar(@aRetPar)}})
	
	//Bloco que abre a tela de preferencias se os parametros estiverem vazio, ou abre a tela principal se os parametros foram preenchidos
	bBtn1 := {|| Iif(Empty(aRetPar[1]) .And. Empty(aRetPar[2]), lExeFun := .F., lExeFun := .T. ), Iif(lExeFun, FechaBatch(), FTelPrf()) }
	aAdd(aButFrm, {1, .T., bBtn1})
	
	FormBatch(__cNomArt, aSayFrm, aButFrm)

	If lExeFun
		//Carrega os valores do arquivo de layout (parametro 1)
		Processa({|| FCarLay(@aCabLay, @aColLay, @aPosLay, @aLstDad, @aSegLay, @aAviLay, aRetPar)}, OemToAnsi(STR0008) + aRetPar[1]) //Arquivo
		//Carrega os valores do arquivo gerado (parametro 2)
		Processa({|| FCarDad(@aLstDad, @aAviLay, aCabLay, aColLay, aPosLay, @aRetPar)}, OemToAnsi(STR0008) + aRetPar[2]) //Arquivo			

		FTelPri(aCabLay, aColLay, aPosLay, aLstDad, aAviLay, aRetPar)
	EndIf
	
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FTelPar
Função que abre uma parambox para inserção dos caminhos dos arquivos

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aRetPar, vetor com os caminhos dos arquivos de layout e gerado
/*/
//---------------------------------------------------------------------------------------
Static Function FTelPar(aRetPar)
	Local aParBox := {}

	aAdd(aParBox,{6, OemToAnsi(STR0009), aRetPar[1], '@!', '', '', 080, .T., OemToAnsi(STR0010)}) //'Layout configuração', 'Todos os arquivos (*.*)|*.* |Modelo I Receber Retorno (.ret)|*.ret |Modelo I Receber Envio (.rem)|*.rem |Modelo I Pagar Retorno (.cpr)|*.cpr |Modelo I Pagar Envio (.cpe)|*.cpe |Modelo II Receber Retorno (.2rr)|*.2rr |Modelo II Receber Envio (.2re)|*2re |Modelo II Pagar Retorno (.2pr)|*.2pr |Modelo II Pagar Envio (.2pe)|*2pe'
	aAdd(aParBox,{6, OemToAnsi(STR0011), aRetPar[2], '@!', '', '', 080, .F., OemToAnsi(STR0010)}) //'Arquivo CNAB gerado', 'Todos os arquivos (*.*)|*.* |Modelo I Receber Retorno (.ret)|*.ret |Modelo I Receber Envio (.rem)|*.rem |Modelo I Pagar Retorno (.cpr)|*.cpr |Modelo I Pagar Envio (.cpe)|*.cpe |Modelo II Receber Retorno (.2rr)|*.2rr |Modelo II Receber Envio (.2re)|*2re |Modelo II Pagar Retorno (.2pr)|*.2pr |Modelo II Pagar Envio (.2pe)|*2pe'

	If ParamBox(aParBox, OemToAnsi(STR0012), @aRetPar,,,,,,,, .F., .F.) //'Configurar Visualização'
		FVldArq(@aRetPar)
	EndIf
	
Return Nil

//----------------------------------------------------------------------------------------
/*/{Protheus.doc} VldGerado
Função que valida se o arquivo gerado poderá ser aberto (não deixa abrir caso seja modelo 1)

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param cLayArq, Arquivo de layout selecionado
@return lRet
/*/
//---------------------------------------------------------------------------------------
Function VldGerado(cLayArq)
	Local lRet := .T.
	Local cExten := ""
	Local cArquivo := Upper(AllTrim(cLayArq))    
	
	If !Empty(cArquivo)
		cExten := Right(cArquivo, 4)
		
		If cExten == ".RET" .OR. cExten == ".REM" .OR. cExten == ".CPR" .OR. cExten == ".CPE"
			lRet := .F.
		Endif
	Else 
		lRet := .F.
	Endif
	
Return lRet

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldArq
Validaçao dos arquivos de layout e arquivos gerados

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aRetPar, vetor com os caminhos dos arquivo
/*/
//---------------------------------------------------------------------------------------
Static Function FVldArq(aRetPar)
	Local cArqImp := ''
	Local nHdlTxt := 0
	Local nBytLid := 0
	Local cBufLid := ''
	
	//-----------------------------------
	//Validação do arquivo de LayOut
	//-----------------------------------
	cArqImp := AllTrim(Upper(aRetPar[1]))
	nHdlTxt := FOPEN(cArqImp,0+64)

	//Verifica a Existencia do arquivo.
	If nHdlTxt == -1
		Aviso(OemToAnsi(STR0001), OemToAnsi(STR0013) + cArqImp + OemToAnsi(STR0014), {'Ok'},2) //'Atenção', 'O arquivo layout ', 'nao pode ser aberto! Verifique os parametros.'
		aRetPar[1] := Space(50)
		aRetPar[2] := Space(50)
	Else
		//verifica se o arquivo de layout está vazio
		fSeek(nHdlTxt, 0)
		nBytLid := fRead(nHdlTxt, @cBufLid, 10)
		fClose(nHdlTxt)		
		If nBytLid == 0
			Aviso(OemToAnsi(STR0001), OemToAnsi(STR0013) + cArqImp + OemToAnsi(STR0015), {'Ok'},2) //'Atenção', 'O arquivo layout ', 'nao pode ser aberto! está vazio.'
			aRetPar[1] := Space(50)
			aRetPar[2] := Space(50)
		Else
			//Verifica se é um arquivo de layout válido com base nos valores iniciais do arquivo 
			If SubStr(cBufLid, 01, 01) != CHR(1) .AND. SubStr(cBufLid, 01, 02) != '10'
				Aviso(OemToAnsi(STR0001), OemToAnsi(STR0002) , {'Ok'},2) //'Atenção', 'Arquivo de layout inválido!'
				aRetPar[1] := Space(50)
				aRetPar[2] := Space(50)
			EndIf
		EndIf			
	EndIf
	
	//-----------------------------------
	//Validação do arquivo Gerado
	//-----------------------------------                          
	cArqImp := AllTrim(Upper(aRetPar[2]))
	
	//Verifica se foi definido o parâmetro com o caminho do arquivo gerado
	If !Empty(cArqImp)
		nHdlTxt := fOpen(cArqImp, 0)

		//Verifico a Existencia do arquivo.
		If nHdlTxt == -1
			Aviso(OemToAnsi(STR0001), OemToAnsi(STR0016) + cArqImp + OemToAnsi(STR0014), {'Ok'},2) //'Atenção', 'O arquivo gerado ', ' nao pode ser aberto! Verifique os parametros.'
			aRetPar[2] := Space(50)
		Else
			//Verifica se o arquivo está vazio
			fSeek(nHdlTxt, 0)
			nBytLid := fRead(nHdlTxt, @cBufLid, 10)
			fClose(nHdlTxt)
			If nBytLid == 0
				Aviso(OemToAnsi(STR0001), OemToAnsi(STR0016) + cArqImp + OemToAnsi(STR0015), {'Ok'},2) //'Atenção', 'O arquivo gerado ', ' está vazio'
				aRetPar[2] := Space(50)
			Else 
				//Verifica se o layout é modelo 1 e se for, avisa que arquivos gerados de modelo 1 não podem ser abertos
				If !VldGerado(aRetPar[1])
					Aviso(OemToAnsi(STR0001), OemToAnsi(STR0098), {'Ok'},2) //'Atenção', 'Não é possível abrir arquivos gerados de Modelo 1. Somente o arquivo de layout será gerenciado.'
					aRetPar[2] := Space(50)
				EndIf
			EndIf		
		EndIf
	EndIf
	
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FCarLay
Carrega as informações do arquivo de layout

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aCabLay, Cabeçalho do layout
@param aColLay, Colunas do layout
@param aPosLay, Alterações do layout
@param aLstDad, Dados do arquivo gerado
@param aSegLay, Segmentos do layout
@param aAviLay, Avisos
@param aRetPar, Caminho dos arquivos
/*/
//---------------------------------------------------------------------------------------
Static Function FCarLay(aCabLay, aColLay, aPosLay, aLstDad, aSegLay, aAviLay, aRetPar)
	Local cArqImp := AllTrim(aRetPar[1])
	Local cBitStr := ''
	Local nPosSeg := 0
	Local nPosBco := 0
	Local cDirLay := ''
	Local cBcoTmp := ''
	Local cTipSeg := ''
	Local aBcoLay := {}
	Local aFirOco := Array(4)
	Local nConLin := 1
	Local cExten := ""
	Local cTipo := ""
	Local cLinAtu := ""

	aFill(aFirOco, .T.)
	
	//Detecção do Tipo e Direção pela extensão do arquivo selecionado
	cExten := Upper(Right(cArqImp, 4))
	If cExten == ".RET" .OR. cExten == ".2RR"		
		cTipo := OemToAnsi(STR0067) //'Receber'
		cDirLay := OemToAnsi(STR0069) //'Retorno'
	ElseIf cExten == ".REM" .OR. cExten == ".2RE"
		cTipo := OemToAnsi(STR0067) //'Receber'
		cDirLay := OemToAnsi(STR0070) //'Envio'
	ElseIf cExten == ".CPR" .OR. cExten == ".2PR"	
		cTipo := OemToAnsi(STR0068) //'Pagar'
		cDirLay := OemToAnsi(STR0069) //'Retorno'
	ElseIf cExten == ".CPE" .OR. cExten == ".2PE"
		cTipo := OemToAnsi(STR0068) //'Pagar'
		cDirLay := OemToAnsi(STR0070) //'Envio'
	Endif	
	
	__aDadLay := Array(6)
	
	cArqImp := Upper(cArqImp)
	FT_fUse(cArqImp)
	FT_fGoTop()	
	cLinAtu := FT_fReadLn()

	//Detecção do Modelo pelos bytes iniciais do arquivo 
	If SubStr(cLinAtu, 01, 01) == CHR(1)
		__cModelo := "1"
	ElseIf SubStr(cLinAtu, 01, 02) == '10'
		__cModelo := "2"
	EndIf
			
	If __cModelo == "1" //Modelo I
		While ! FT_fEOF()
			cLinAtu := FT_fReadLn()
			nConLin ++

			If SubStr(cLinAtu, 01, 01) == CHR(1)
				If aFirOco[1]
					aAdd(aCabLay, {SubStr(cLinAtu, 001, 001), PadR('Header', 30), ''})
					aAdd(aColLay, {OemToAnsi(STR0017), ''}) //'Linha TXT'
					aAdd(aPosLay, {})
					aAdd(aLstDad, {})

					aFirOco[1] := .F.
				EndIf

				If SubStr(cLinAtu, 017, 006) == '077079'
					If At('"', cLinAtu) > 0 .Or. At("'", cLinAtu) > 0
						cBcoTmp := &(AllTrim(SubStr(cLinAtu, 24)))
					Else
						cBcoTmp := AllTrim(SubStr(cLinAtu, 24))
					EndIf

					nPosBco := aScan(__aTipBco,{|xAux| xAux[1] == cBcoTmp})
				EndIf

				nPosCab := aScan(aCabLay, {|xAux| xAux[1] == CHR(1)})

			Elseif SubStr(cLinAtu,1,1) == CHR(2)
				If aFirOco[2]
					aAdd(aCabLay, {SubStr(cLinAtu, 001, 001), PadR('Detail', 30), ''})
					aAdd(aColLay, {OemToAnsi(STR0017), ''}) //'Linha TXT'
					aAdd(aPosLay, {})
					aAdd(aLstDad, {})

					aFirOco[2] := .F.
				EndIf

				nPosCab := aScan(aCabLay, {|xAux| xAux[1] == CHR(2)})

			Elseif SubStr(cLinAtu,1,1) == CHR(3)
				If aFirOco[3]
					aAdd(aCabLay, {SubStr(cLinAtu, 001, 001), PadR('Trailer', 30), ''})
					aAdd(aColLay, {OemToAnsi(STR0017), ''})//'Linha TXT'
					aAdd(aPosLay, {})
					aAdd(aLstDad, {})

					aFirOco[3] := .F.
				EndIf

				nPosCab := aScan(aCabLay, {|xAux| xAux[1] == CHR(3)})

			Elseif SubStr(cLinAtu,1,1) == CHR(4)
				If aFirOco[4]
					aAdd(aCabLay, {SubStr(cLinAtu, 001, 001), PadR('Detail5', 30), ''})
					aAdd(aColLay, {OemToAnsi(STR0017), ''})//'Linha TXT'
					aAdd(aPosLay, {})
					aAdd(aLstDad, {})

					aFirOco[4] := .F.
				EndIf

				nPosCab := aScan(aCabLay, {|xAux| xAux[1] == CHR(4)})
			Endif

			If nPosCab > 0
				aAdd(aColLay[nPosCab], SubStr(cLinAtu, 002, 015))
				aAdd(aPosLay[nPosCab], {SubStr(cLinAtu, 001, 001),;
					SubStr(cLinAtu, 002, 015),;
					SubStr(cLinAtu, 017, 003),;
					SubStr(cLinAtu, 020, 003),;
					SubStr(cLinAtu, 023, 001),;
					SubStr(cLinAtu, 024, 060)})
			EndIf

			FT_fSkip()
		EndDo
	Else //Modelo II
		While ! FT_fEOF()
			cLinAtu := FT_fReadLn()
			nConLin ++

			If SubStr(cLinAtu, 01, 01) == '1'
				aAdd(aCabLay, {SubStr(cLinAtu, 02, 03), SubStr(cLinAtu, 05, 30), SubStr(cLinAtu, 35), ''})
				aAdd(aColLay, {OemToAnsi(STR0017), ''})//'Linha TXT'
				aAdd(aPosLay, {})
				aAdd(aLstDad, {})
			ElseIf SubStr(cLinAtu, 01, 01) == '2'
				nPosCab := aScan(aCabLay, {|xAux| xAux[1] == SubStr(cLinAtu, 02, 03)})

				If nPosCab > 0
					aAdd(aColLay[nPosCab], SubStr(cLinAtu, 005, 015))
					aAdd(aPosLay[nPosCab], {SubStr(cLinAtu, 002, 003),;
						SubStr(cLinAtu, 005, 015),;
						SubStr(cLinAtu, 020, 003),;
						SubStr(cLinAtu, 023, 003),;
						SubStr(cLinAtu, 026, 001),;
						SubStr(cLinAtu, 027, 255)})
				Else
				
					aAdd(aAviLay, {StrZero(nConLin, 4), OemToAnsi(STR0018) + SubStr(cLinAtu, 02, 03) + OemToAnsi(STR0019)})//'(LayOut) Detalhe da seçao ', ' não possui o Header'

					FT_fSkip()
					
					Loop
				EndIf

				//Verifico a existência do Header
				If SubStr(cLinAtu, 3, 1) == 'H' .And. SubStr(cLinAtu, 20, 06) == '143143'
					cBitStr := ''

					//Verificação para caracter ou numerico na macro-execuçao
					If At('"', cLinAtu) > 0 .Or. At("'", cLinAtu) > 0
						cBitStr := ''
					Else
						cBitStr := '"'
					EndIf

				//Verifico o banco
				ElseIf SubStr(cLinAtu, 3, 1) == 'H' .And. SubStr(cLinAtu, 20, 06) == '001003'
					If At('"', cLinAtu) > 0 .Or. At("'", cLinAtu) > 0
						cBcoTmp := &(AllTrim(SubStr(cLinAtu, 27)))
					Else
						cBcoTmp := AllTrim(SubStr(cLinAtu, 27))
					EndIf

					nPosBco := aScan(__aTipBco,{|xAux| xAux[1] == cBcoTmp})
					
				//Verifico se é a linha do Segmento
				ElseIf SubStr(cLinAtu, 3, 1) == 'D' .And. SubStr(cLinAtu, 20, 06) == '014014'					
					If At('"', cLinAtu) > 0 .Or. At("'", cLinAtu) > 0
						cTipSeg := &(AllTrim(SubStr(cLinAtu, 27)))	
					Else
						cTipSeg := AllTrim(SubStr(cLinAtu, 27))
					EndIf
					
					aCabLay[nPosCab, 4] := cTipSeg + 'D'
					
					nPosSeg := aScan(aSegLay, {|xAux| xAux == cTipSeg})

					//Adiciono os segmentos existentes do LayOut
					If nPosSeg == 0
						aAdd(aSegLay, cTipSeg)
					EndIf

					//Altero o cabeçalho e trailer do lote
					nPosCab := aScan(aCabLay, {|xAux| xAux[1] == SubStr(cLinAtu, 02, 01) + 'H' + SubStr(cLinAtu, 04, 01)})
					If nPosCab > 0
						 aCabLay[nPosCab, 4] := cTipSeg + 'H'
					EndIf

					//Altero o cabeçalho e trailer do lote
					nPosCab := aScan(aCabLay, {|xAux| xAux[1] == SubStr(cLinAtu, 02, 01) + 'T' + SubStr(cLinAtu, 04, 01)})
					If nPosCab > 0
						aCabLay[nPosCab, 4] := cTipSeg + 'T'
					EndIf
				EndIf
			EndIf

			FT_fSkip()
		EndDo
	EndIf

	If nPosBco > 0
		aBcoLay := {__aTipBco[nPosBco, 1], __aTipBco[nPosBco, 2]}
	Else
		If Empty(cBcoTmp)
			aBcoLay := {'XXX', OemToAnsi(STR0047)} //'Não informado'
		Else
			aBcoLay := {'XXX', OemToAnsi(STR0048)} //'Outros Bancos'
		EndIf
	EndIf
						
	__aDadLay[1] := aBcoLay[1]
	__aDadLay[2] := Left(aBcoLay[2], 16)
	__aDadLay[3] := __cModelo	
	__aDadLay[4] := cTipo	
	__aDadLay[5] := cDirLay

	FT_fUse()			
	
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FCarDad
Carrega as informações do arquivo gerado

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aLstDad, Dados do arquivo gerado
@param aAviLay, Avisos
@param aCabLay, Cabeçalho do layout
@param aColLay, Colunas do layout
@param aPosLay, Alterações do layout
@param aRetPar, Caminho dos arquivos
/*/
//---------------------------------------------------------------------------------------
Static Function FCarDad(aLstDad, aAviLay, aCabLay, aColLay, aPosLay, aRetPar)
	Local cArqImp := AllTrim(aRetPar[2])
	Local aArrCor := {LoadBitmap(GetResources(), 'BR_VERDE'), LoadBitmap(GetResources(), 'BR_VERMELHO'), LoadBitmap(GetResources(), 'BR_PRETO')}
	Local nPosCab := 0
	Local aLinTmp := {}
	Local nConTmp := 0
	Local cTipGer := ''
	Local cTipSeg := ''
	Local cLinLot := '' 
	Local lFirDet := .T.
	Local lSkpReg := .T.
	Local nConLin := 1
	Local aVldBco := {}
	Local aVldTmp := {}
	Local nTipVld := 0
	Local nErrVal := 0
	Local nPosVIn := 0
	Local nPosVFn := 0
	Local cLinAtu := ''
	Local cSekLay:= ''
	
	//Pré carrego as validaçoes existentes do banco
	If File(__cCfgBco + __aDadLay[1])
		For nConTmp := 1 To Len(__aCfgVld)
			aVldTmp := {}
			FLayApo(__cCfgBco + __aDadLay[1], @aVldTmp, Array(4), 6, 'typvld' + __aCfgVld[nConTmp])
			aAdd(aVldBco, aClone(aVldTmp))
		Next

		__aDadLay[6] := OemToAnsi(STR0063) //'Sim'
	Else
		__aDadLay[6] := OemToAnsi(STR0064) //'Não'
	EndIf
	
	If !Empty(cArqImp)
		cArqImp := Upper(cArqImp)
		FT_fUse(cArqImp)
		FT_fGoTop()
	
		cLinAtu := FT_fReadLn()
	
		If Len(cLinAtu) = 240
			cTipGer := '2'
		ElseIf Len(cLinAtu) = 400
			cTipGer := '1'
		Else 
			cTipGer := '3'
		EndIf
		
		If cTipGer == '3'
			Aviso(OemToAnsi(STR0001), OemToAnsi(STR0028), {'Ok'},2)//'Atenção', 'Somente são suportados arquivos gerados no padrão FEBRABAN de 240 ou 400 posições.'
			aRetPar[2] := Space(50)
		ElseIf cTipGer <> __cModelo
			Aviso(OemToAnsi(STR0001), OemToAnsi(STR0020), {'Ok'},2)//'Atenção' ,'Modelo do arquivo gerado incompatível com modelo do layout'
			aRetPar[2] := Space(50)
		Else
			While ! FT_fEOF()
				cLinAtu := FT_fReadLn()
		
				nPosCab := 0
				aLinTmp := {}
		
				If SubStr(cLinAtu, 008, 001) == '0' // Header Arquivo
					nPosCab := aScan(aCabLay, {|xAux| xAux[1] == '0H '})
		
				ElseIf SubStr(cLinAtu, 008, 001) == '1' // Header Lote
					cLinLot := cLinAtu
		
				ElseIf SubStr(cLinAtu, 008, 001) == '3' // Detalhe
					If lFirDet
						cTipSeg := SubStr(cLinAtu, 014, 001)
		
						//Voltar um registro e atualizar
						cLinAtu := cLinLot
						If Len(aCabLay) >= 4		
							// Direção do Arquivo (Envio/Retorno)
							If __aDadLay[5] == "Retorno"
								nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[3]) == cTipSeg })
								If nPosCab > 0
									cSekLay := Alltrim(aCabLay[nPosCab][1])
									nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[1]) == SubStr(cSekLay, 02, 01) + 'H' + SubStr(cSekLay, 04, 01) })
									If nPosCab == 0
										nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[1]) == '1H' })
									EndIf
								EndIf
							Else
								nPosCab := aScan(aCabLay, {|xAux| xAux[4] == cTipSeg + 'H'})
							EndIf
						Endif
		
						nConLin --
						lFirDet := .F.
						lSkpReg := .F.
					Else
						lSkpReg := .T.
						If Len(aCabLay) >= 4
							// Direção do Arquivo (Envio/Retorno)
							If __aDadLay[5] == "Retorno"
								nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[3]) == SubStr(cLinAtu, 014, 001) })
							Else
								nPosCab := aScan(aCabLay, {|xAux| xAux[4] == SubStr(cLinAtu, 014, 001) + 'D'})
							EndIf
						Endif
					EndIf
		
		
				ElseIf SubStr(cLinAtu, 008, 001) == '5' // Trailer Lote
					If Len(aCabLay) >= 4
						// Direção do Arquivo (Envio/Retorno)
						If __aDadLay[5] == "Retorno"
							nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[3]) == cTipSeg })
							If nPosCab > 0
								cSekLay := Alltrim(aCabLay[nPosCab][1])
								nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[1]) == SubStr(cSekLay, 02, 01) + 'T' + SubStr(cSekLay, 04, 01) })
								If nPosCab == 0
									nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[1]) == '1T' })
								EndIf
							EndIf	
						Else
							nPosCab := aScan(aCabLay, {|xAux| xAux[4] == cTipSeg + 'T'})
						EndIf
					Endif
					lFirDet := .T.
		
				ElseIf SubStr(cLinAtu, 008, 001) == '9' // Trailer Arquivo
					If Len(aCabLay) >= 4
						nPosCab := aScan(aCabLay, {|xAux| Alltrim(xAux[1]) == '0T'})
					EndIf
				EndIf
		
				If nPosCab > 0
		
					nErrVal := 3
					nTipVld := aScan(__aCfgVld, {|xAux| xAux == SubStr(cLinAtu, 008, 001)})
				   
				   //Só verifico o layout de validaçao se houver validação carregada.
					If Len(aVldBco) > 0
						nErrVal := 1
		
						For nConTmp := 1 To Len(aVldBco[nTipVld])
							nPosVIn := aVldBco[nTipVld, nConTmp, 2]
							nPosVFn := aVldBco[nTipVld, nConTmp, 3] - aVldBco[nTipVld, nConTmp, 2] + 1
					
							If nPosVIn > 0
								If ! SubStr(cLinAtu, nPosVIn, nPosVFn) $ aVldBco[nTipVld, nConTmp, 4]
									nErrVal := 2
									aAdd(aAviLay, {StrZero(nConLin, 4), OemToAnsi(STR0021) + aVldBco[nTipVld, nConTmp, 1] + OemToAnsi(STR0022) + aVldBco[nTipVld, nConTmp, 4] + ')'})//'(Dados) A seção referente a ', ' nao está entre os permitidos ('
								EndIf
							Else
								nErrVal := 3
							EndIf
						Next
					EndIf
		
					//Coluna 1 = Linha do arquivo
					//Coluna 2 = Bitmap de validaçao
					aAdd(aLinTmp, StrZero(nConLin, 4))
					aAdd(aLinTmp, aArrCor[nErrVal])
		
					For nConTmp := 1 To Len(aPosLay[nPosCab])
						aAdd(aLinTmp, SubStr(cLinAtu, Val(aPosLay[nPosCab, nConTmp, 3]), (Val(aPosLay[nPosCab, nConTmp, 4]) - Val(aPosLay[nPosCab, nConTmp, 3])) + 1))
					Next
		
					aAdd(aLstDad[nPosCab], aClone(aLinTmp))
				EndIf
		
				nConLin ++
		
				If lSkpReg
					FT_fSkip()
				EndIf
			EndDo
		EndIf
	
		FT_fUse()
	EndIf
	
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FTelPri
Monta a Tela Principal

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aCabLay, Cabeçalho do layout
@param aColLay, Colunas do layout
@param aPosLay, Alterações do layout
@param aLstDad, Dados do arquivo gerado
@param aAviLay, Avisos
@param aRetPar, Caminho dos arquivos
/*/
//---------------------------------------------------------------------------------------
Static Function FTelPri(aCabLay, aColLay, aPosLay, aLstDad, aAviLay, aRetPar)
	Local aCooTel := FWGetDialogSize(oMainWnd)
	Local oDlgTel
	Local oFldLay, oFldApr, oAviLst
	Local oLayTel := FWLayer():New()
	Local aObjGrp := Array(10)
	Local aObjSay := Array(20)
	Local aObjGet := Array(10)
	Local aObjBut := Array(10)
	Local aObjBmp := Array(10)
	Local aVlrGet := Array(10)
	Local aObjLst := Array(Len(aCabLay))
	Local aPanTel := Array(10)
	Local aPanInt := Array(10)
	Local aPagLay := {}
	Local nConEvl := 0
	Local nConTmp := 0
	Local aColAvi := {OemToAnsi(STR0071), OemToAnsi(STR0072)} //'Linha', 'Mensagem'
	Local bEvlLst := {|| nConEvl := 0, aEval(aObjLst, {|| nConEvl++, FAtuLst(@aObjLst[nConEvl], @aLstDad[nConEvl], aColLay[nConEvl], nConEvl)})}
	Local bMosAvi := {|| __lMosAvi := ! __lMosAvi, FMosAvi(@aPanInt)}

	aVlrGet[1] := aRetPar[1]
	aVlrGet[2] := aRetPar[2]

	//Atualizo o cabeçalho de Dados
	aEval(aCabLay, {|xAux| aAdd(aPagLay, xAux[1] + '-' + xAux[2])})

	//Limpo controle de resumo
	__lMosAvi := .F.

	oDlgTel := MsDialog():New(000, 000, 600, 800, __cNomArt,,,,, /*CLR_BLUE*/, /*CLR_WHITE*/,,, .T.)

	//Inicializa o objeto e nao apresenta botão de fechar
	oLayTel:Init(oDlgTel, .F.)

	//Adiciona Linhas
	oLayTel:addLine('L01', 20, .F.)
	oLayTel:addLine('L02', 65, .F.)
	oLayTel:addLine('L03', 15, .F.)

	//Adiciona Colunas nas Linhas
	oLayTel:addCollumn('C01_L01', 100, .F., 'L01')

	oLayTel:addCollumn('C01_L02', 75, .F., 'L02')
	oLayTel:addCollumn('C02_L02', 25, .F., 'L02')

	oLayTel:addCollumn('C01_L03', 35, .F., 'L03')
	oLayTel:addCollumn('C02_L03', 40, .F., 'L03')

	oLayTel:SetColSplit('C02_L02', CONTROL_ALIGN_LEFT, 'L02', /* bAction */)

	//Adiciona Janelas as linhas
	oLayTel:addWindow('C01_L01', 'C01_L01_W01', OemToAnsi(STR0023), 100, .F., .F., /* bAction */, 'L01', /* bFocus */)//'Origem dados'

	oLayTel:addWindow('C01_L02', 'C01_L02_W01', OemToAnsi(STR0024), 080, .T., .F., bMosAvi      , 'L02', /* bFocus */) //'Apresentação'
	oLayTel:addWindow('C01_L02', 'C01_L02_W02', OemToAnsi(STR0025), 020, .F., .F., /* bAction */, 'L02', /* bFocus */) //'Avisos'
	oLayTel:addWindow('C02_L02', 'C02_L02_W01', OemToAnsi(STR0026), 100, .F., .F., /* bAction */, 'L02', /* bFocus */) //'Inf. Adicionais'

	oLayTel:addWindow('C01_L03', 'C01_L03_W01', OemToAnsi(STR0027), 100, .F., .F., /* bAction */, 'L03', /* bFocus */) //'Layout'
	oLayTel:addWindow('C02_L03', 'C02_L03_W01', OemToAnsi(STR0029), 100, .F., .F., /* bAction */, 'L03', /* bFocus */) //'Painel de configuração'

	//Pego o objeto de tela
	aPanTel[1] := oLayTel:GetWinPanel('C01_L01', 'C01_L01_W01', 'L01')
	aPanTel[1]:FreeChildren()

	aObjSay[1] := tSay():New(007, 005, {|| OemToAnsi(STR0030)}, aPanTel[1],,,,,, .T., CLR_BLACK, CLR_WHITE, 030, 020) //'Layout:'
	aObjGet[1] := tGet():New(005, 030, {|xAux| IIf(pCount() > 0, aVlrGet[1] := xAux, aVlrGet[1])}, aPanTel[1], 200, 010, '@!', {|| .T.}, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F.,, 'aVlrGet[1]',,,, )
	
	aObjSay[2] := tSay():New(022, 005, {|| OemToAnsi(STR0031)}, aPanTel[1],,,,,, .T., CLR_BLACK, CLR_WHITE, 030, 020) //'Gerado:'
	aObjGet[2] := tGet():New(020, 030, {|xAux| IIf(pCount() > 0, aVlrGet[2] := xAux, aVlrGet[2])}, aPanTel[1], 200, 010, '@!', {|| .T.}, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F.,, 'aVlrGet[2]',,,, )

	aPanTel[2] := oLayTel:GetWinPanel('C01_L02', 'C01_L02_W01', 'L02')
	aPanTel[2]:FreeChildren()

	oFldLay := TFolder() :New(000, 000, aPagLay, {}, aPanTel[2],,,, .F., .F., 200, 200)
	oFldLay:Align := CONTROL_ALIGN_ALLCLIENT

	For nConEvl := 1 To Len(aObjLst)
		aObjLst[nConEvl] := TWBrowse():New(036, 008, 260, 132,, aColLay[nConEvl],, oFldLay:aDialogs[nConEvl],,,,,,,,,,,, .F.,, .T.,, .F.,,,)
		aObjLst[nConEvl]:Align := CONTROL_ALIGN_ALLCLIENT
	Next

	aPanTel[3] := oLayTel:GetWinPanel('C01_L02', 'C01_L02_W02', 'L02')
	aPanTel[3]:FreeChildren()

	aPanInt[2] := TPanel():New(000, 000, '', aPanTel[3],, .T., .F.,,, 000, 030, .T., .F.)
	aPanInt[2]:Align := CONTROL_ALIGN_TOP

	If Len(aAviLay) > 0
		aObjSay[3] := tSay():New(003, 005, {|| OemToAnsi(STR0032)}, aPanInt[2],,,,,, .T., CLR_RED, CLR_WHITE, 300, 020)//'Voce tem avisos para analisar. Minimize a seção acima (Apresentação)'
	Else
		aObjSay[3] := tSay():New(003, 005, {|| OemToAnsi(STR0033)}, aPanInt[2],,,,,, .T., CLR_BLUE, CLR_WHITE, 300, 020) //'Você não tem avisos para analisar'
	EndIf

	aPanInt[3] := TPanel():New(000, 000, '', aPanTel[3],, .T., .F.,,, 000, 030, .T., .F.)
	aPanInt[3]:Align := CONTROL_ALIGN_ALLCLIENT

	oAviLst := TWBrowse():New(060, 007, 070, 095,, aColAvi,, aPanInt[3],,,,,,,,,,,, .F.,, .T.,, .F.,,,)
	oAviLst:Align := CONTROL_ALIGN_ALLCLIENT

	aPanTel[4] := oLayTel:GetWinPanel('C02_L02', 'C02_L02_W01', 'L02')
	aPanTel[4]:FreeChildren()

	aObjGrp[1] := tGroup():New(003, 002, 046, 080, OemToAnsi(STR0027), aPanTel[4], CLR_HBLUE,, .T.)//'Layout'

	aObjSay[4] := tSay():New(010, 005, {|| OemToAnsi(STR0034)}, aPanTel[4],,,,,, .T., CLR_BLUE, CLR_WHITE, 050, 020)//'Banco:'
	aObjSay[5] := tSay():New(018, 005, {|| OemToAnsi(STR0035)}, aPanTel[4],,,,,, .T., CLR_BLUE, CLR_WHITE, 050, 020)//'Modelo:'
	aObjSay[6] := tSay():New(026, 005, {|| OemToAnsi(STR0036)}, aPanTel[4],,,,,, .T., CLR_BLUE, CLR_WHITE, 050, 020)//'Tipo:'
	aObjSay[7] := tSay():New(034, 005, {|| OemToAnsi(STR0037)}, aPanTel[4],,,,,, .T., CLR_BLUE, CLR_WHITE, 050, 020)//'Direção:'

	aObjSay[8]  := tSay():New(010, 028, {|| __aDadLay[2]}, aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 050, 020)
	aObjSay[9]  := tSay():New(018, 028, {|| __aDadLay[3]}, aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 050, 020)
	aObjSay[10] := tSay():New(026, 028, {|| __aDadLay[4]}, aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 050, 020)
	aObjSay[11] := tSay():New(034, 028, {|| __aDadLay[5]}, aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 050, 020)

	aObjGrp[2] := tGroup():New(050, 002, 100, 080, OemToAnsi(STR0038), aPanTel[4], CLR_HBLUE,, .T.)//'Validaçao'

	aObjSay[12] := tSay():New(057, 005, {|| OemToAnsi(STR0039)}  , aPanTel[4],,,,,, .T., CLR_BLUE, CLR_WHITE, 050, 020)//'Arquivo Validador:'
	aObjSay[13] := tSay():New(057, 053, {|| __aDadLay[6]}, aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 030, 020)

	aObjBmp[1]  := TBitmap():New(067, 005, 068, 010, 'BR_VERDE'   , , .T., aPanTel[4], {|| }, {|| }, .F., .F.,,, .F.,, .T.,, .F.)
	aObjSay[13] := tSay():New(067, 015, {|| OemToAnsi(STR0040)}  , aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 060, 020)//'Linha sem erro(s)'

	aObjBmp[2] := TBitmap():New(077, 005, 078, 010, 'BR_VERMELHO', , .T., aPanTel[4], {|| }, {|| }, .F., .F.,,, .F.,, .T.,, .F.)
	aObjSay[14] := tSay():New(077, 015, {|| OemToAnsi(STR0041)}  , aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 060, 020)//'Linha com erro(s)'

	aObjBmp[3] := TBitmap():New(087, 005, 088, 010, 'BR_PRETO'   , , .T., aPanTel[4], {|| }, {|| }, .F., .F.,,, .F.,, .T.,, .F.)
	aObjSay[15] := tSay():New(087, 015, {|| OemToAnsi(STR0042)}  , aPanTel[4],,,,,, .T., CLR_HBLUE, CLR_WHITE, 060, 020)//'Linha sem validador'

	aPanTel[5] := oLayTel:GetWinPanel('C01_L03', 'C01_L03_W01', 'L03')
	aPanTel[5]:FreeChildren()

	aObjBut[1] := tButton():Create(aPanTel[5], 005, 010, OemToAnsi(STR0043), {|| FEdtLay(aPosLay, oFldLay:nOption, aPagLay)}, 040, 010,,,, .T.,,,,,,)//'Editar Layout'
	aObjBut[2] := tButton():Create(aPanTel[5], 005, 055, OemToAnsi(STR0044)  , {|| FSavLay(aCabLay, aPosLay, aVlrGet[1])}, 040, 010,,,, .T.,,,,,,)//'Salvar Como'

	aPanTel[7] := oLayTel:GetWinPanel('C02_L03', 'C02_L03_W01', 'L03')
	aPanTel[7]:FreeChildren()

	aObjBut[5] := tButton():Create(aPanTel[7], 005, 010, OemToAnsi(STR0045), {|| FTelPrf()}    , 040, 010,,,, .T.,,,,,,) //'Configurações'

	Eval(bEvlLst)

	//Preparo a tela de Aviso
	If Len(aAviLay) == 0
		aAdd(aAviLay, {Space(3), Space(15)})
	EndIf

	oAviLst:SetArray(aAviLay)
	oAviLst:bLine := {|| {aAviLay[oAviLst:nAt, 1], aAviLay[oAviLst:nAt, 2]}}

	oAviLst:Refresh()

	aPanInt[3]:Hide()

	oDlgTel:lEscClose := .F.
	oDlgTel:lCentered := .T.
	oDlgTel:bInit := {|| }

	oDlgTel:Activate()
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FMosAvi
Mostra/Esconde painel de aviso 

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aPanTmp, Vetor de paineis 
/*/
//---------------------------------------------------------------------------------------
Static Function FMosAvi(aPanTmp)
	If __lMosAvi
		aPanTmp[2]:Hide()
		aPanTmp[3]:Show()
	Else
		aPanTmp[3]:Hide()
		aPanTmp[2]:Show()
	EndIf
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FAtuLst
Atualiza lista de CNAB

@author Pedro Alencar
@since 06/12/13
@version P11.90
@Param oLstTmp
@Param aLstTmp
@Param aColTmp
@Param nConLst
/*/
//---------------------------------------------------------------------------------------
Static Function FAtuLst(oLstTmp, aLstTmp, aColTmp, nConLst)
	Local aArrTmp := Array(Len(aColTmp))
	Local nConTmp := 0

	//Se estiver vazio o array, insiro linha default
	If Len(aLstTmp) == 0
		aFill(aArrTmp, Space(10))

		aAdd(aLstTmp, aClone(aArrTmp))
	EndIf

	oLstTmp:nAt := 1

	//Monto o bLine em tempo real
	oLstTmp:SetArray(aLstTmp)
	oLstTmp:bLine := &(FMntBln('aLstTmp', 'oLstTmp', Array(Len(aColTmp))))

	oLstTmp:Refresh()
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FMntBln
Monta o bLine do Browse

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param cArrLay
@param cObjLst
@param aArrLay
@Return bLinLst
/*/
//---------------------------------------------------------------------------------------
Static Function FMntBln(cArrLay, cObjLst, aArrLay)
	Local bLinLst := ''
	Local cLinLst := ''
	Local nConLay := 0
	Local nConTmp := 0

	aEval(aArrLay, {|| nConLay ++, cLinLst += cArrLay + '[' + cObjLst + ':nAt,' + AllTrim(Str(nConLay)) + '],'})

	cLinLst := Left(cLinLst, Len(cLinLst) - 1)
	bLinLst := '{|| {' + cLinLst + '}}'

Return (bLinLst)

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FEdtLay
Tela de edição do arquivo de Layout

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aPosLay, Layout em edição 
@param nPagRef, Aba ativa
@param aPagLay, Abas
/*/
//---------------------------------------------------------------------------------------
Static Function FEdtLay(aPosLay, nPagRef, aPagLay)
	Local oDlgTel
	Local oGetLay
	Local oPanTl1
	Local oLayTel := FWLayer():New()
	Local aArrHea := {}
	Local aArrCol := {}
	Local cTipApo := ''

	aAdd(aArrHea, {OemToAnsi(STR0073), 'CIDELAY','9!!'  ,  003, 000,'.F.',,'C',,}) //'Identificação'
	aAdd(aArrHea, {OemToAnsi(STR0074), 'CDESLAY','@!'   ,  015, 000,'.F.',,'C',,}) //'Descrição'
	aAdd(aArrHea, {OemToAnsi(STR0075), 'CINILAY','999'  ,  003, 000,'.F.',,'C',,}) //'Inicio'
	aAdd(aArrHea, {OemToAnsi(STR0076), 'CFIMLAY','999'  ,  003, 000,'.F.',,'C',,}) //'Fim'
	aAdd(aArrHea, {OemToAnsi(STR0077), 'CDECLAY','9'    ,  001, 000,'.F.',,'C',,}) //'Decimais'
	aAdd(aArrHea, {OemToAnsi(STR0078), 'CCNTLAY','@!S30',  255, 000,'VldContLay(M->CCNTLAY)',,'C',,}) //'Conteúdo'

	FBusLay(@aArrCol, aArrHea, aPosLay[nPagRef])

	oDlgTel := MsDialog():New(000, 000, 400, 600, __cNomArt,,,,, /*CLR_BLUE*/, /*CLR_WHITE*/,,, .T.)

	//Inicializa o objeto e nao apresenta botão de fechar
	oLayTel:Init(oDlgTel, .F.)

	//Adiciona Linhas
	oLayTel:addLine('L01', 95, .F.)

	//Adiciona Colunas nas Linhas
	oLayTel:addCollumn('C01_L01', 100, .T., 'L01')

	//Adiciona Janelas as linhas
	oLayTel:addWindow('C01_L01', 'C01_L01_W01', OemToAnsi(STR0030) + aPagLay[nPagRef] , 90, .F., .T., {|| }, 'L01', {|| })
	
	//Pego o objeto de tela
	oPanTl1 := oLayTel:GetWinPanel('C01_L01', 'C01_L01_W01', 'L01')
	oPanTl1:FreeChildren()

	oGetLay := MsNewGetDados():New(0,0,0,0, /* GD_INSERT+GD_UPDATE+GD_DELETE */ GD_UPDATE, /*cLinhaOk*/, /*cTudoOk*/, /*cCpoIncr*/, /*aCpoAlt*/, /*nFreeze*/, 999, /*cCampoOk*/, /*Superdel*/, /*cApagaOk*/, oPanTl1, aArrHea, aArrCol)
	oGetLay:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oDlgTel:lEscClose := .F.
	oDlgTel:lCentered := .T.
	oDlgTel:bInit := EnchoiceBar(oDlgTel, {|| IIf (FConLay(@aPosLay, oGetLay:aCols, nPagRef), oDlgTel:End(), )}, {|| oDlgTel:End()})
	
	oDlgTel:Activate()
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} VldContLay
Valida as aspas e apóstrofos na edição de conteúdo do layout CNAB

@author Pedro Alencar
@since 18/12/13
@version P11.90
@param cConteudo, Conteúdo do campo 
@return lRet
/*/
//---------------------------------------------------------------------------------------
Function VldContLay(cConteudo)
	Local lRet := .T.
	Local nCount := 0
	Local nTotal := 0
	Local cValor := ""
	
	cValor := AllTrim(cConteudo) 
	If !Empty(cValor) 
		//Conta quantas aspas e/ou apóstrofos há no conteúdo
		For nCount := 1 To Len(cValor)
			If SubStr(cValor, nCount, 1) == Chr(34) .OR. SubStr(cValor, nCount, 1) == Chr(39)
				nTotal += 1
			Endif
		Next Count
		
		If nTotal > 0 
			//se houver mais do que 2 aspas ou apostrofos, ou apenas 1, na string, não valida
			If nTotal = 2 
				//Verifica se começa e com Aspas ou com apostrofo
				If Left(cValor,1) != Chr(34) .OR. Left(cValor,1) != Chr(39)
				 	//Verifica se o primeiro caractere é igual ao último (aspas fechando aspas ou apostrofo fechando apostrofo)
					If Left(cValor,1) != Right(cValor,1)
						lRet := .F. 
					Endif
				Else
					lRet := .F.
				Endif
			Else
				lRet := .F.
			Endif
		Endif 
	Endif
Return lRet 

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FBusLay
Monta as colunas da tela de edição do layout

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param cArrCol, Colunas do layout
@param cArrHea, Cabeçalho do layout
@param aArrLay, Layout
/*/
//---------------------------------------------------------------------------------------
Static Function FBusLay(aArrCol, aArrHea, aArrLay)
	Local nConLin := 1
	Local nConLay := 1

	For nConLin := 1 To Len(aArrLay)
		aAdd(aArrCol, Array(Len(aArrHea) + 1))

		For nConLay := 1 To Len(aArrHea)
			aArrCol[Len(aArrCol), nConLay] := aArrLay[nConLin, nConLay]
		Next nConLay

		aArrCol[Len(aArrCol), Len(aArrHea) + 1] := .F.
	Next nConLin

	If Len(aArrCol) == 0
		aAdd(aArrCol, {Space(03), Space(15), '000', '000', '0', Space(255), .F.})
	EndIf

Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FConLay
Confirmação da ediçao do layout

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param cPosLay, Layout em edição
@param aArrCol, Colunas do layout
@param nPagRef, Aba ativa
@Return lRet
/*/
//---------------------------------------------------------------------------------------
Static Function FConLay(aPosLay, aArrCol, nPagRef)
	Local nConTmp := 0
	Local lRet := .F.
	
	If MsgYesNo(OemToAnsi(STR0051)) //'Atualiza os dados digitados?'		
		For nConTmp := 1 To Len(aArrCol)
			aPosLay[nPagRef, nConTmp, 1] := aArrCol[nConTmp, 1]
			aPosLay[nPagRef, nConTmp, 2] := aArrCol[nConTmp, 2]
			aPosLay[nPagRef, nConTmp, 3] := aArrCol[nConTmp, 3]
			aPosLay[nPagRef, nConTmp, 4] := aArrCol[nConTmp, 4]
			aPosLay[nPagRef, nConTmp, 5] := aArrCol[nConTmp, 5]
			aPosLay[nPagRef, nConTmp, 6] := aArrCol[nConTmp, 6]
		Next nConTmp
		
		lRet := .T.
	EndIf
	
Return lRet

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FSavLay
Salva novo arquivo de layout 

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param aCabLay, Cabeçalho do layout
@param aPosLay, Layout em edição
@param cLayout, Nome do arquivo de layout 
/*/
//---------------------------------------------------------------------------------------
Static Function FSavLay(aCabLay, aPosLay, cLayout)
	Local cMskFil := ''
	Local cDadNew := ''
	Local cPatNew := ''
	Local cDadTmp := CriaTrab(, .F.) + '.txt'
	Local nHdlDad := FCreate(cDadTmp)
	Local aNewLst := {}
	Local nConTmp := 0
	Local nConTm2 := 0	
	Local cLinBuf := ''
	Local cExtens := Right(AllTrim(cLayout), 3)

	cMskFil := OemToAnsi(STR0046) + '(*.' + cExtens + ') |*.' + cExtens + '|' //'Arquivo de Layout '
	cDadNew := Upper(cGetFile(cMskFil, OemToAnsi(STR0066),,,.F.,,.F.)) //'Salvar Layout Como'
	
	If !Empty(cDadNew)
		//se for modelo 2 trata antes o cabeçalho especifico
		If __aDadLay[3] == '2'
			aEval(aCabLay, {|xAux| aAdd(aNewLst, aClone(xAux))})
	
			//Gero o arquivo temporário
			For nConTmp := 1 To Len(aNewLst)		
				If !Empty(aNewLst[nConTmp, 1])
					cLinBuf := '1'
				
					//O '-1' do for é para nao pegar o ultimo item do array que é um teste de posicionamento
					For nConTm2 := 1 To Len(aNewLst[nConTmp]) - 1
						cLinBuf += aNewLst[nConTmp, nConTm2]
					Next
					
					//Se for Modelo 2, certifica-se de que cada linha contenha 500 caracteres, pois a leitura dos arquivos de layout
					//no módulo financeiro, ocorre de 500 em 500 caracteres, independente de linha
					If Len(cLinBuf) <> 500 
						cLinBuf := PadR(cLinBuf, 500)
					Endif				
					
					FWrite(nHdlDad, cLinBuf + CRLF)
				EndIf
			Next
		EndIf
	
		aNewLst := {}
	
		//Aglutino todos os arrays de folder em um só
		For nConTmp := 1 To Len(aPosLay)
			aEval(aPosLay[nConTmp], {|xAux| aAdd(aNewLst, aClone(xAux))})
		Next
	
		//Gero o arquivo temporário
		For nConTmp := 1 To Len(aNewLst)
			If !Empty(aNewLst[nConTmp, 1])
				cLinBuf := IIf(__aDadLay[3] == '2','2','')
				For nConTm2 := 1 To Len(aNewLst[nConTmp])
					//Se for modelo 2 adiciono o tipo de registro antes de cada linha		
					cLinBuf += aNewLst[nConTmp, nConTm2]
				Next
				
				//Se for Modelo 2, certifica-se de que cada linha contenha 500 caracteres, pois a leitura dos arquivos de layout
				//no módulo financeiro, ocorre de 500 em 500 caracteres, independente de linha
				If __aDadLay[3] == '2' 
					If Len(cLinBuf) <> 500 
						cLinBuf := PadR(cLinBuf, 500)
					Endif				
				Endif
				
				FWrite(nHdlDad, cLinBuf + CRLF)
			EndIf							
		Next
	
		FClose(nHdlDad)
	
		//Agora eu gravo o novo arquivo
		cPatNew := IIf(rAt('\', cDadNew) == 0,      '', SubStr(cDadNew, 1, rAt('\', cDadNew)))
		cDadNew := IIf(rAt('\', cDadNew) == 0, cDadNew, SubStr(cDadNew, rAt('\', cDadNew) + 1))
	
		cDadNew += '.' + cExtens
		FRename(cDadTmp, cDadNew)
		CpyS2T(cDadNew, cPatNew, .F.)
		FErase(cDadNew)
	
		Aviso(OemToAnsi(STR0001), OemToAnsi(STR0052) + cPatNew, {'Ok'},2) //'Atenção', 'O arquivo foi salvo em '
		
	EndIf

Return Nil
	
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FTelPrf
Tela de configuraçoes

@author Pedro Alencar
@since 06/12/13
@version P11.90
/*/
//---------------------------------------------------------------------------------------
Static Function FTelPrf()
	Local oDlgTel
	Local oLayTel := FWLayer():New()
	Local aObjGrp[10]
	Local aObjTel[10]
	Local aObjBut[10]
	Local aOpcCbo[10]
	Local aVlrCbo[10]
	Local nPosVld := 1
   
	aOpcCbo[1] := FGetBco()
	aOpcCbo[2] := {OemToAnsi(STR0083), ; //'Header Arquivo (Tipo 0)'
		OemToAnsi(STR0084), ; //'Header Lote (Tipo 1)'
		OemToAnsi(STR0085), ; //'Iniciais Lote (Tipo 2)(opcional)'
		OemToAnsi(STR0086), ; //'Detalhe (Tipo 3)'
		OemToAnsi(STR0087), ; //'Finais Lote (Tipo 4)(opcional)'
		OemToAnsi(STR0088), ; //'Trailer Lote (Tipo 5)'
		OemToAnsi(STR0089)} //'Trailer Arquivo (Tipo 9)'
	aVlrCbo[1] := ''
	aVlrCbo[2] := ''

	oDlgTel := MsDialog():New(000, 000, 240, 460, OemToAnsi(STR0029),,,,, /*CLR_BLUE*/, /*CLR_WHITE*/,,, .T.) //'Painel de configuração'

	//Inicializa o objeto e nao apresenta botão de fechar
	oLayTel:Init(oDlgTel, .F.)

	//Adiciona Linhas
	oLayTel:addLine('L01', 100, .F.)

	//Adiciona Colunas nas Linhas
	oLayTel:addCollumn('C01_L01', 100, .T., 'L01')

	//Adiciona Janelas as linhas
	oLayTel:addWindow('C01_L01', 'C01_L01_W01', OemToAnsi(STR0053), 100, .F., .T., {|| MsgStop(OemToAnsi(STR0049))}, 'L01', {|| MsgStop(OemToAnsi(STR0050))})//'Preferências (modelo 2)', 'Clicou no titulo Janela 01 L01', 'Recebeu foco a Janela 01 L01'

	//Pego o objeto de tela
	oPanTl1 := oLayTel:GetWinPanel('C01_L01', 'C01_L01_W01', 'L01')
	oPanTl1:FreeChildren()
	
	aObjGrp[1] := tGroup():New(003, 005, 030, 217, OemToAnsi(STR0056), oPanTl1, CLR_HBLUE,, .T.)//'Facilitador de Validação'

	aObjTel[1] := tComboBox():New(013, 010,{|xAux| IIf(pCount() > 0, aVlrCbo[1] := xAux, aVlrCbo[1])}, aOpcCbo[1], 030, 010, oPanTl1,, {|| },,,, .T.,,,,,,,,, 'aVlrCbo[1]')
	aObjTel[2] := tComboBox():New(013, 045,{|xAux| IIf(pCount() > 0, aVlrCbo[2] := xAux, aVlrCbo[2])}, aOpcCbo[2], 100, 010, oPanTl1,, {|| nPosVld := aScan(aOpcCbo[2], aVlrCbo[2])},,,, .T.,,,,,,,,, 'aVlrCbo[2]')

	aObjBut[1] := tButton():Create(oPanTl1, 013, 150, OemToAnsi(STR0055), {|| FTabApo(__cCfgBco + aVlrCbo[1], 6, 'typvld' + __aCfgVld[nPosVld])}, 040, 010,,,, .T.,,,,{||__lBancos},,)//'Editar'

	aObjGrp[2] := tGroup():New(035, 005, 062, 217, OemToAnsi(STR0057), oPanTl1, CLR_HBLUE,, .T.)//'Tabelas de Apoio'

	aObjBut[2] := tButton():Create(oPanTl1, 045, 010, OemToAnsi(STR0058), {|| FTabApo(__cArqBco, 5, 'resource')}, 040, 010,,,, .T.,,,,{||EnableBco()},,)//Bancos

	oDlgTel:lEscClose := .T.
	oDlgTel:lCentered := .T.

	oDlgTel:Activate()
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FGetBco
Ordena os bancos carregados no vetor estático

@author Pedro Alencar
@since 06/12/13
@version P11.90
@return aCodBco, Bancos ordenados
/*/
//---------------------------------------------------------------------------------------
Static Function FGetBco()
	Local aCodBco := {}
	
	aEval(__aTipBco, {|xAux| aAdd(aCodBco, xAux[1])})
	aSort(aCodBco,,, {|xAux, yAux| xAux < yAux})
Return aCodBco

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FLoaCfg
Carrega o arquivo de bancos

@author Pedro Alencar
@since 06/12/13
@version P11.90
/*/
//---------------------------------------------------------------------------------------
Static Function FLoaCfg()
	Local aArrLin := {}
	Local nConLay := 1
	Local cTxtLay := GetVlrIni('resource', StrZero(nConLay, 3), '', __cArqBco)
	Local cLinAtu := ''
	Local nConTmp := 0

	__aTipBco := {}
	
	While ! Empty(cTxtLay)
		cLinAtu := '{' + cTxtLay + ',}'
		aArrLin := &(cLinAtu)

		aAdd(__aTipBco, aClone(aArrLin))

		nConLay += 1
		cTxtLay := GetVlrIni('resource', StrZero(nConLay, 3), '', __cArqBco)
	EndDo

	If Len(__aTipBco) == 0
		__lBancos := .F.
		aAdd(__aTipBco, {'000', OemToAnsi(STR0065)}) //'Banco Default'
	Else
		__lBancos := .T.
	EndIf

Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FTabApo
Tela de edição dos arquivos de configuração (bancos e validações)

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param cArqCfg, Arquivo que será lido
@param nTipApo, Tipo de arquivo: 5=Banco, 6=Validação
@param cTagCfg, Tag a ser lida no arquivo
/*/
//---------------------------------------------------------------------------------------
Static Function FTabApo(cArqCfg, nTipApo, cTagCfg)
	Local oDlgTel
	Local oGetLay
	Local oLayTel := FWLayer():New()
	Local aArrHea := {}
	Local aArrCol := {}
	Local cTipApo := ''

	If nTipApo == 5
		cTipApo := OemToAnsi(STR0090) //'Banco'

		aAdd(aArrHea, {OemToAnsi(STR0093), 'CCODCMP', '@!', 003, 0, '! Empty(M->CCODCMP) .AND. At(Chr(34), M->CCODCMP) == 0',, 'C',,}) //'Codigo'
		aAdd(aArrHea, {OemToAnsi(STR0074), 'CDESCMP', '@!', 100, 0, '! Empty(M->CDESCMP) .AND. At(Chr(34), M->CDESCMP) == 0',, 'C',,}) //'Descriçao'

	ElseIf nTipApo == 6
		cTipApo := OemToAnsi(STR0092) //'Facilitador'

		aAdd(aArrHea, {OemToAnsi(STR0074), 'CDESCMP', '@!S20' , 030, 0, '! Empty(M->CDESCMP) .AND. At(Chr(34), M->CDESCMP) == 0',, 'C',,}) //'Descrição'
		aAdd(aArrHea, {OemToAnsi(STR0095), 'NPOSINI', '@E 999', 003, 0, 'M->NPOSINI > 0 .AND. (M->NPOSINI <= GdFieldGet("NPOSFIM") .OR. Empty(GdFieldGet("NPOSFIM")))',, 'N',,}) //'Posiçao Inicial'
		aAdd(aArrHea, {OemToAnsi(STR0096), 'NPOSFIM', '@E 999', 003, 0, 'M->NPOSFIM > 0 .AND. (M->NPOSFIM >= GdFieldGet("NPOSINI") .OR. Empty(GdFieldGet("NPOSINI")))',, 'N',,}) //'Posiçao Final'
		aAdd(aArrHea, {OemToAnsi(STR0097), 'CDEFCMP', '@!S20' , 050, 0, '!Empty(M->CDEFCMP) .AND. At(Chr(34), M->CDEFCMP) == 0',, 'C',,}) //'Valor(es) Permitido(s)'
	EndIf

	FLayApo(cArqCfg, @aArrCol, aArrHea, nTipApo, cTagCfg)

	oDlgTel := MsDialog():New(000, 000, 400, 600, __cNomArt,,,,, /*CLR_BLUE*/, /*CLR_WHITE*/,,, .T.)

	//Inicializa o objeto e nao apresenta botão de fechar
	oLayTel:Init(oDlgTel, .F.)

	//Adiciona Linhas
	oLayTel:addLine('L01', 95, .F.)

	//Adiciona Colunas nas Linhas
	oLayTel:addCollumn('C01_L01', 100, .T., 'L01')

	//Adiciona Janelas as linhas
	oLayTel:addWindow('C01_L01', 'C01_L01_W01', cTipApo, 90, .F., .T., {|| MsgStop(OemToAnsi(STR0049))}, 'L01', {|| MsgStop(OemToAnsi(STR0050))})//'Clicou no titulo Janela 01 L01','Recebeu foco a Janela 01 L01'

	//Pego o objeto de tela
	oPanTl1 := oLayTel:GetWinPanel('C01_L01', 'C01_L01_W01', 'L01')
	oPanTl1:FreeChildren()

	oGetLay := MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_UPDATE+GD_DELETE, /*cLinhaOk*/, /*cTudoOk*/, /*cCpoIncr*/, /*aCpoAlt*/, /*nFreeze*/, 999, /*cCampoOk*/, /*Superdel*/, /*cApagaOk*/, oPanTl1, aArrHea, aArrCol)
	oGetLay:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oDlgTel:lEscClose := .F.
	oDlgTel:lCentered := .T.
	oDlgTel:bInit := EnchoiceBar(oDlgTel, {|| IIf (FConApo(oGetLay, cArqCfg, aArrHea, nTipApo, cTagCfg), oDlgTel:End(), )}, {|| oDlgTel:End()})
	
	oDlgTel:Activate()

Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FLayApo
Função auxiliar para leitura das informações do arquivo informado

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param  cArqCfg, Arquivo a ser lido
@param  aArrTmp, Vetor com as informações lidas
@param  aArrHea, Vetor com os cabeçalhos lidos
@param  nTipApo, Tipo de arquivo
@param  cTagCfg, Tag a ser lida no arquivo
/*/
//---------------------------------------------------------------------------------------
Static Function FLayApo(cArqCfg, aArrTmp, aArrHea, nTipApo, cTagCfg)
	Local aArrLin := {}
	Local nConLay := 1
	Local cTxtLay := GetVlrIni(cTagCfg, StrZero(nConLay, 3), '', cArqCfg)
	Local cLinAtu := ''
	
	While ! Empty(cTxtLay)
		cLinAtu := '{' + cTxtLay + ',}'
		aArrLin := &(cLinAtu)
		
		aAdd(aArrTmp, aClone(aArrLin))
		
		aArrTmp[Len(aArrTmp), Len(aArrHea) + 1] := .F.

		nConLay += 1
		cTxtLay := GetVlrIni(cTagCfg, StrZero(nConLay, 3), '', cArqCfg)
	EndDo

	If Len(aArrTmp) == 0
		aAdd(aArrTmp, Array(Len(aArrHea) + 1))

		If nTipApo >= 1 .And. nTipApo <= 4
			aArrTmp[Len(aArrTmp), 1] := Space(01)
			aArrTmp[Len(aArrTmp), 2] := Space(01)
		ElseIf nTipApo == 5
			aArrTmp[Len(aArrTmp), 1] := Space(03)
			aArrTmp[Len(aArrTmp), 2] := Space(30)
		ElseIf nTipApo == 6
			aArrTmp[Len(aArrTmp), 1] := Space(30)
			aArrTmp[Len(aArrTmp), 2] := 0
			aArrTmp[Len(aArrTmp), 3] := 0
			aArrTmp[Len(aArrTmp), 4] := Space(50)
		EndIf
	
		aArrTmp[Len(aArrTmp), Len(aArrHea) + 1] := .F.
	EndIf

Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FConApo
Grava as alterações realizadas nos arquivos de configuração

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param oArrCol, Colunas do arquivo
@param cArqCfg, Caminho do arquivo
@param cArrHea, Cabeçalhos do arquivo
@param nTipApo, Tipo do arquivo
@param ctagCfg, Tag a ser lida no arquivo
@Return lRet
/*/
//---------------------------------------------------------------------------------------
Static Function FConApo(oArrCol, cArqCfg, aArrHea, nTipApo, cTagCfg)
	Local nConLin := 0
	Local nOpcAvi := 0
	Local nConCfg := 0
	Local aArrLin := {}
	Local lRet := .F. 
	Local cBufLin := ""
	Local nHdl := 0 
	Local cLinAux := ""
	
	nOpcAvi := Aviso(OemToAnsi(STR0001), OemToAnsi(STR0059), {OemToAnsi(STR0063), OemToAnsi(STR0064)}) //'Atenção', 'Confirma gravaçao de configuraçao?', 'Sim', 'Não'
	If nOpcAvi = 1
		//Apaga do arquivo ini a seção que está sendo editada, para reescrever com as alterações
		FDelIni(cArqCfg, cTagCfg)		
		
		If Len(oArrCol:aCols) > 0 
			If File(cArqCfg)
				nHdl := fOpen(cArqCfg, FO_READWRITE)
			Else
				nHdl := fCreate(cArqCfg)
			Endif
			
			If nHdl <> -1	
				//Posiciona no fim do arquivo			
				fSeek(nHdl,0,FS_END) 
				fWrite(nHdl, CHR(13)+CHR(10) + '[' + cTagCfg + ']', Len(cTagCfg) + 4)
			
				//Gravo cada um dos aCols preenchidos
				For nConLin := 1 To Len(oArrCol:aCols)
					aArrLin := aClone(oArrCol:aCols[nConLin])
			
					If ! aArrLin[Len(aArrHea) + 1]
						nConCfg ++
					
						If nTipApo >= 1 .And. nTipApo <= 5
							cBufLin := '"' + aArrLin[1] + '","' + aArrLin[2] + '"'
						ElseIf nTipApo == 6
							cBufLin := '"' + aArrLin[1] + '",' + Str(aArrLin[2]) + ',' + Str(aArrLin[3]) + ',"' + aArrLin[4] + '"'
						EndIf
						
						cLinAux := StrZero(nConCfg, 3) + " = " + cBufLin
						fWrite(nHdl, CHR(13)+CHR(10) + cLinAux, Len(cLinAux) + 2)										
					EndIf
				Next
												
				fClose(nHdl)								
			Endif
		EndIf
	
		lRet := .T.
		Aviso(OemToAnsi(STR0060), OemToAnsi(STR0061) + SubStr(AllTrim(cArqCfg), RAt("\", cArqCfg) + 1) + OemToAnsi(STR0062), {'Ok'},2) //'Informação', 'O arquivo de configuraçao ', ' foi atualizado com sucesso!'
		__lCfgUpd := .T.			
	EndIf

Return lRet

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FDelIni
Recria os arquivos de configuraçao para salvar novas informações

@author Pedro Alencar
@since 06/12/13
@version P11.90
@param cArqCfg, Caminho do arquivo
@param cTagCfg, Tag a ser lida no arquivo
/*/
//---------------------------------------------------------------------------------------
Static Function FDelIni(cArqCfg, cTagCfg)
	Local nHdlTxt := 0
	Local cLinTmp := ''
	Local cTxtIni := ''
	Local cTxtNew := ''
	Local nConLin := 0
	Local lDelIni := .F.
	
	If !Empty(cTagCfg) .AND. !Empty(cArqCfg)
		cTxtIni := MemoRead(cArqCfg)

		For nConLin := 1 To MlCount(cTxtIni)
			cLinTmp := MemoLine(cTxtIni, 250 , nConLin)
			
			If SubStr(cLinTmp, 1, 1) == '['
				If SubStr(cLinTmp, 2, 8) == cTagCfg .OR. SubStr(cLinTmp, 2, 7) == cTagCfg
					lDelIni := .T.
				Else
					lDelIni := .F.
				EndIf
			EndIf
	
			If !lDelIni .AND. !Empty(cLinTmp)
				cTxtNew += cLinTmp + CRLF
			EndIf
		Next	
		
		nHdlTxt := fCreate(cArqCfg)
	
		//Testo a Existencia do arquivo.
		If nHdlTxt != -1
			fWrite(nHdlTxt, cTxtNew)
			fClose(nHdlTxt)
		EndIf						

	EndIf
		
Return Nil

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GetVlrIni
Função para leitura de arquivo .INI, com base na seção e chave informada
(Função criada com o intuíto de suprir a necessidade de abrir um arquivo
 cujo caminho contenha a estrutura "\\<ip>\<pasta>")

@author Pedro Alencar
@since 16/12/13
@version P11.90
@param cSecao, Seção do arquivo INI a ser lida
@param cChave, Chave da Seção do arquivo INI que será lida
@param cPadrao, Valor padrão que será retornado caso a Seção ou Chave não sejam encontradas
@param cArquivo, Caminho do arquivo INI que será lido
@return cRet, Valor da chave informada
/*/
//---------------------------------------------------------------------------------------
Function GetVlrIni(cSecao, cChave, cPadrao, cArquivo)	
	Local cRet := ""
	Local nCount := 0
	Local nCount2 := 0
	Local nDiv := 0
	Local cAux := ""
	Default cPadrao := ""
	
	//Verifica se os parâmetros foram informados
	If !Empty(cSecao) .AND. !Empty(cChave) .AND. !Empty(cArquivo) 
		//Carrega a matriz com os dados do arquivo informado, caso a mesma já não tenha sido carregada e caso tenho sido alterada
		If cArquivo != __cArqAnt .OR. __lCfgUpd = .T.
			__aDados := DadosArq(cArquivo)
			__cArqAnt := cArquivo			
			__lCfgUpd := .F.
		Endif
		
		If Len(__aDados) > 0 
			//Faz um loop no primeiro indice da matriz de dados do arquivo, até encontrar a seção informada no parâmetro
			For nCount := 1 To Len(__aDados)				
				If Upper(__aDados[nCount][1]) == "[" + AllTrim(Upper(cSecao)) + "]"					
					
					//Faz um loop no segundo índice da matriz de dados do arquivo, até encontrar a chave informada no parâmetro 	
					For nCount2 := 2 To Len(__aDados[nCount])
						//Pega a posição do primeiro caractere "=" nas linha da seção informada, para separar a chave do valor  
						nDiv := At("=", __aDados[nCount][nCount2])  
						If nDiv > 0 
							//Pega somente a chave da linha da seção (o que está antes do primeiro "=") e compara com a chave informada
							cAux := AllTrim(SubStr(__aDados[nCount][nCount2], 1, nDiv-1)) 
							If Upper(cAux) == AllTrim(Upper(cChave))
								//Se as chaves forem iguais, retorna o valor da chave e sai do "For"
								cRet := AllTrim(SubStr(__aDados[nCount][nCount2], nDiv+1))								
								Exit
							Endif
						EndIf
					Next nCount2														
					
					//Se a seção foi encontrada, mas a a chave não, sai do "For"
					Exit
				Endif
			Next nCount
		EndIf 
	Endif
	
	//Se não foi encontrado um valor com base nos parâmetros informados, retorna o valor padrão informado	
	If Empty(cRet)
		cRet := cPadrao
	Endif
Return cRet

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} DadosArq
Função para leitura dos dados contido em um arquivo INI. separando as Seções em uma matriz

@author Pedro Alencar
@since 16/12/13
@version P11.90
@param cArquivo, Caminho do arquivo INI que será lido
@return aRet, Matriz com os dados do arquivo INI
/*/
//---------------------------------------------------------------------------------------
Static Function DadosArq (cArquivo)
	Local cBuffer := ""
	Local aRet := {}
	
	//Verifica se o arquivo existe
	If File(cArquivo)
	   	//Abre o Arquivo
	   	If FT_FUSE(cArquivo) != -1
			FT_FGOTOP()  
	   		
	   		//Lê todas as linhas do arquivo
	   		While !FT_FEOF()   			
	   			cBuffer := Alltrim(FT_FREADLN()) 
			
				//Se a linha não estiver vazia, salva na matriz
				If !Empty(cBuffer)
					
					//Se a linha começar com "[" e terminar com "]", adiciona uma nova seção na matriz (inclusão no primeiro índice)
					If Left(cBuffer, 1) == "[" .AND. Right(cBuffer,1) == "]"
						aAdd(aRet, {cBuffer})
					Else //Senão, adiciona uma linha da seção (inclusão no segundo índice da matriz)
						aAdd(aRet[Len(aRet)], cBuffer)
					EndIf						
				
				EndIf			
				
				FT_FSKIP() 
			EndDo
			
			FT_FUSE()
		Else 
   			Aviso(OemToAnsi(STR0001), OemToAnsi(STR0099) + cArquivo, {'Ok'},2) //'Atenção', 'Não foi possível abrir o arquivo: '
   		EndIf
	Endif
Return aRet  

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} EnableBco
Validação "When" para habilitar o botão de edição da lista de bancos

@author Pedro Alencar
@since 16/12/13
@version P11.90
@return lRet
/*/
//---------------------------------------------------------------------------------------
Static Function EnableBco ()
	Local lRet := .F.
	
	If __lBancos = .T.
		lRet := .T.
	Else
		Aviso(OemToAnsi(STR0001), OemToAnsi(STR0100) + CRLF + STR0102 + ' ' + __cArqBco, {'Ok'},3) //'Atenção', 'Não foi possível encontrar o arquivo de bancos ou o mesmo está vazio."###"Verifique a existência do arquivo: '
	Endif
Return lRet  
