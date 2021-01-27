#Include 'Protheus.ch'

Static lFKFCed := AliasInDic("FKF") .and. FKF->(ColumnPos("FKF_CEDENT") > 0)

//-------------------------------------------------------------------
/*/{Protheus.doc} CNABDVAG()
Digito verificador agência.

@author  Leonardo Castro
@since   15/06/2018
@version Protheus 12.1.20
/*/
//-------------------------------------------------------------------
Function CNABDVAG()
Return POSICIONE("SA6", 1, xFilial("SA6") + SEA->EA_PORTADO + SEA->EA_AGEDEP + SEA->EA_NUMCON, "A6_DVAGE")

//-------------------------------------------------------------------
/*/{Protheus.doc} CNABDVCC()
Digito verificador conta corrente.

@author  Leonardo Castro
@since   15/06/2018
@version Protheus 12.1.20
/*/
//-------------------------------------------------------------------
Function CNABDVCC()
Return POSICIONE("SA6", 1, xFilial("SA6") + SEA->EA_PORTADO + SEA->EA_AGEDEP + SEA->EA_NUMCON, "A6_DVCTA")


//-------------------------------------------------------------------
/*/{Protheus.doc} CNABCED()
Retorna o cedente/beneficiário do boleto bancário.

@param   cChaveSE2 (opicional) - Chave de pesquisa do IDDoc do título correspondente.

@return  aRet - Array contendo os dados do fornecedor cedente/beneficiário do boleto.
aRet[1] - (caractere) Tipo de inscrição (1-CPF / 2-CNPJ)
aRet[2] - (caractere) Número da inscrição (CPF ou CNPJ)
aRet[3] - (caractere) Nome do cedente/beneficiário
aRet[4] - (caractere) Os três campos acima concatenados

@author  Felipe Raposo
@since   26/08/2019
@version Protheus 12.1.25
/*/
//-------------------------------------------------------------------
Function CNABCED(cChaveSE2 as character)

Local aRet       as array
Local aArea      as array
Local aSA2Area   as array
Local cIdDoc     as character

// Chave de pesquisa para o ID do título.
If cChaveSE2 == nil
	cChaveSE2 := SE2->(E2_FILIAL + "|" + E2_PREFIXO + "|" + E2_NUM + "|" + E2_PARCELA + "|" + E2_TIPO + "|" + E2_FORNECE + "|" + E2_LOJA)
Endif

// Se estiver buscando a mesma chave, não efetuar as pesquisas no banco novamente.
Static aSE2ChvCed := {"", nil}
If aSE2ChvCed[1] == cChaveSE2
	aRet := aSE2ChvCed[2]
Else
	aArea    := GetArea()
	aSA2Area := SA2->(GetArea())
	aRet := {"", "", "", ""}

	// Localiza o complemento do título.
	If lFKFCed
		cIdDoc := FINBuscaFK7(cChaveSE2, "SE2")
		FKF->(dbSetOrder(1))  // FKF_FILIAL, FKF_IDDOC.
		If FKF->(msSeek(xFilial() + cIdDoc, .F.))
			SA2->(dbSetOrder(1))  // A2_FILIAL, A2_COD, A2_LOJA.
			If SA2->(msSeek(xFilial() + FKF->(FKF_CEDENT + FKF_LOJACE), .F.))
				aRet[1] := If(SA2->A2_TIPO == "F", "1", "2")
			Endif
		Endif
	Endif

	// Se não encontrou fornecedor na tabela de complementos (FKF), pesquisa no título (SE2).
	If empty(aRet[1])
		SA2->(dbSetOrder(1))  // A2_FILIAL, A2_COD, A2_LOJA.
		If SA2->(msSeek(xFilial() + SE2->(E2_FORNECE + E2_LOJA), .F.))
			aRet[1] := If(SA2->A2_TIPO == "F", "1", "2")
		Endif
	Endif

	// Se encontrou um fornecedor, preenche o restante dos campos.
	If !empty(aRet[1])
		aRet[2] := PadL(AllTrim(SA2->A2_CGC), 15, "0")
		aRet[3] := RTrim(SA2->A2_NOME)
		aRet[4] := aRet[1] + aRet[2] + aRet[3]
	Endif

	RestArea(aSA2Area)
	RestArea(aArea)
	FWFreeArray(aSA2Area)
	FWFreeArray(aArea)

	// Guarda o resultado em cache para não efetuar pesquisa novamente.
	aSE2ChvCed[1] := cChaveSE2
	aSE2ChvCed[2] := aRet
Endif

Return aRet


//-------------------------------------------------------------------
/*/{Protheus.doc} FNLINCNAB()
Retorna o número de linhas gravadas no arquivo envio do CNAB Modelo 2
para ser informado no trailer do arquivo.

@author  Leonardo Castro
@since   15/06/2018
@version Protheus 12.1.20
/*/
//-------------------------------------------------------------------
Function FNLINCNAB() As Numeric

	Local nRet As Numeric

	// Variáveis PRIVATE dos fontes FINA150/FINA430
	nTotLinArq	:= IIF(Type("nTotLinArq") == "U", 0, nTotLinArq)
	nLotCnab2	:= IIF(Type("nLotCnab2")  == "U", 0, nLotCnab2)

	nRet := nTotLinArq       // Soma o número de linhas de detalhes gravados no arquivo.
	nRet += (nLotCnab2 * 2)  // Multiplico o número de lotes para saber a quantidade de Headers e Trailers de lote.
	nRet += 2                // Soma 2 para linhas de Header e Trailer de arquivo.

Return nRet

//----------------------------------------------------------------------
/*/{Protheus.doc} FNLOTECNAB()
Retorna o número de lotes gravados no arquivo envio do CNAB Modelo 2
para ser informado no trailer do arquivo e no segundo campo de cada linha do lote.

@author  Leonardo Castro
@since   15/06/2018
@version Protheus 12.1.20
/*/
//----------------------------------------------------------------------
Function FNLOTECNAB() As Numeric

	Local nRet As Numeric

	// Variável PRIVATE dos fontes FINA150/FINA420
	nRet := IIF(Type("nLotCnab2") == "U", 0, nLotCnab2) // Quantidade de lotes do CNAB2

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} FNTITLOTE()
Retorna a número de titulos gravados no lote do arquivo de envio
CNAB Modelo 2.

@author  Leonardo Castro
@since   15/06/2018
@version Protheus 12.1.20
/*/
//-------------------------------------------------------------------
Function FNTITLOTE() As Numeric

	Local nRet As Numeric

	// Variável PRIVATE dos fontes FINA150/FINA420
	nRet := IIF(Type("nQtdTitLote") == "U", 0, nQtdTitLote) // Número de títulos do lote CNAB2

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} FNTITARQ()
Retorna a quantidade de titulos gravados no arquivo de envio CNAB Modelo 2.

@author  Leonardo Castro
@since   15/06/2018
@version Protheus 12.1.20
/*/
//-------------------------------------------------------------------
Function FNTITARQ() As Numeric

	Local nRet As Numeric

	// Variável PRIVATE dos fontes FINA150/FINA420
	nRet := IIF(Type("nQtdTotTit") == "U", 0, nQtdTotTit) // Número de títulos do arquivo do CNAB2

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} FNLINLOTE()
Retorna a linha corrente do lote arquivo de envio CNAB Modelo 2.

@author  Leonardo Castro
@since   15/06/2018
@version Protheus 12.1.20
/*/
//-------------------------------------------------------------------
Function FNLINLOTE() As Numeric

	Local nRet As Numeric

	// Variável PRIVATE dos fontes FINA150/FINA420
	nRet := IIF(Type("nQtdLinLote") == "U", 0, nQtdLinLote) // Número de linhas do lote CNAB2
	nRet += 1                                               // Somo 1 pois contador inicia do zero

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} FNREGLOTE()
Retorna a quantidade de registros (linhas) gravadas no lote arquivo de envio
CNAB Modelo 2.

@author  Felipe Raposo
@since   19/07/2019
@version Protheus 12.1.23
/*/
//-------------------------------------------------------------------
Function FNREGLOTE() As Numeric

	Local nRet As Numeric

	nRet := FNLINLOTE()	// Número de linhas do lote CNAB2
	nRet += 1			// Somo 1 para linha de trailer de Lote

Return nRet
