#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "ERROR.CH"
#INCLUDE "CFGX049B.CH"

Static __aHdrRest	:= {}

//---------------------------------------------------------------------------------------
/*/ {Protheus.doc} CFGX049B05()
Le arquivo TXT para gravar tabelas FOZ / FOP

@Project	CNAB - Padronizado
@author	Francisco Oliveira
@since		18/08/2017
@version	P12
@Return	Logico com o resultado da gravação
@param
@Obs
/*/
//---------------------------------------------------------------------------------------
Function CFGX049B05(cBanco As Character, cVersao As Character, cModulo As Character, cTipo As Character, cFuncao As Character) As Logical
	
	Local lRet	As Logical

	Default cBanco := ""
	Default cVersao := ""
	Default cModulo := ""
	Default cTipo := ""
	Default cFuncao := ""
	
	lRet := CFGX049Exe(cBanco, cVersao, cModulo, cTipo, cFuncao)
	
Return lRet

//----------------------------------------------------------------------------------------------
/*/ {Protheus.doc} CFGX049Exe()
Le arquivo TXT para gravar tabelas FOZ / FOP

@Project	CNAB - Padronizado
@author	Francisco Oliveira
@since		18/08/2017
@version	P12
@Return	Logico com o resultado da gravação
@param
@Obs
/*/
//---------------------------------------------------------------------------------------

Static Function CFGX049Exe(cBanco, cVersao, cModulo, cTipo, cFuncao) As Logical
	
	Local lRet	As Logical
	
	Processa( {|| lRet := CFGX049Imp(cBanco, cVersao, cModulo, cTipo, cFuncao) }, OemToAnsi(STR0066) + cBanco + "." ) // "Processando Banco "
	
Return lRet

//----------------------------------------------------------------------------------------------
/*/ {Protheus.doc} CFGX049Imp()
Le arquivo TXT para gravar tabelas FOZ / FOP

@Project	CNAB - Padronizado
@author	Francisco Oliveira
@since		18/08/2017
@version	P12
@Return	Logico com o resultado da gravação
@param
@Obs
/*/
//---------------------------------------------------------------------------------------

Function CFGX049Imp(cBanco As Character, cVersao As Character, cModulo As Character, cTipo As Character, cFuncao As Character) As Logical
	
	Local nY			As Numeric
	Local cCodigo		As Character
	Local cCtrEdi		As Character
	Local cVlrEdi		As Character
	Local cNewVlr		As Character
	Local cAliasFOP    	As Character
	Local cVersaoArq	As Character
	Local cPagRecT		As Character
	Local cDescPRT		As Character
	Local cEnvRetT		As Character
	Local cDescERT		As Character
	Local aArrayFOQ		As Array
	Local aRetEdi		As Array
	Local aDdsCNAB		As Array
	Local lRet			As Logical
	Local cTime			As Character
	Local cCodSeq		As Character
	Local cURLCNAB		As Character
	Local oRestClient	As Object
	Local cParam		As Character

	Default cBanco	:= ""
	Default cVersao := ""
	Default cModulo := ""
	Default cTipo	:= ""
	Default cFuncao	:= ""

	nY			:= 0
	cCodigo		:= ""
	cCtrEdi		:= ""
	cVlrEdi		:= ""
	cNewVlr		:= ""
	cAliasFOP   := "FOP"
	cVersaoArq	:= cVersao
	cPagRecT	:= cModulo
	cDescPRT	:= Iif(cPagRecT == "PAG", "PAGAR", "RECEBER")
	cEnvRetT	:= cTipo
	cDescERT	:= Iif(cEnvRetT == "REM", "REMESSA", "RETORNO")
	aArrayFOQ	:= {}
	aRetEdi		:= {}
	aDdsCNAB	:= {cBanco, cVersao, cModulo, cTipo}
	lRet		:= .F.
	cTime		:= Time()
	cCodSeq		:= ""
	cURLCNAB	:= "http://cnab.totvs.com.br/rest"
	oRestClient	:= FWRest():New(cURLCNAB)
	cParam		:= cFuncao + ";" + cBanco + ";" + cModulo + ";" + cTipo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ INICIO - Leitura do Arquivo de Configuracao                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oRestClient:SetPath("/LeArqConfig/" + cParam) //CFGX049B09
	
	If oRestClient:Get()
		cRetRest	:= oRestClient:GetResult()
	Else
		cRetRest	:= oRestClient:GetLastError()
		Return .F.
	Endif
	
	oObjCNABAti	:= {}
	
	lJSonDes := FWJSonDeserialize(NoACento(cRetRest),@oObjCNABAti)
	
	If lJSonDes
		DbSelectArea("FOQ")
		FOQ->(DbSetOrder(2))
		FOQ->(DbGoTop())
		
		ProcRegua(Len(oObjCNABAti:checkins))
		
		If FOQ->(DbSeek(FwxFilial("FOQ") + cBanco + cVersaoArq + cPagRecT + cEnvRetT))
			Aviso(OemToAnsi(STR0035), OemToAnsi(STR0067) + cBanco + ", " + OemToAnsi(STR0034) + " " + cVersaoArq + ", " + OemToAnsi(STR0034) + cDescPRT + ", Tipo " + cDescERT + ". " + OemToAnsi(STR0034), {"Ok"}, 3) //  "Atenção", "Para o Banco Versão "Modulo A""
			Return
		Endif
		
		DbSelectArea(cAliasFOP)
		(cAliasFOP)->(DbSetOrder(2))
		(cAliasFOP)->(DbGoTop())
		
		If (cAliasFOP)->(DbSeek(FwxFilial(cAliasFOP) + cBanco + cPagRecT + cEnvRetT ))
			cCodigo	:= FOP->FOP_CODIGO
			While !(cAliasFOP)->(Eof()) .And. (cAliasFOP)->FOP_BANCO == cBanco .And. (cAliasFOP)->FOP_PAGREC == cPagRecT .And. (cAliasFOP)->FOP_REMRET == cEnvRetT
				If	(cAliasFOP)->FOP_BLOQUE == "2"
					(cAliasFOP)->(RecLock(cAliasFOP, .F.))
					(cAliasFOP)->FOP_BLOQUE := "1"
					(cAliasFOP)->(MsUnLock())
				Endif
				(cAliasFOP)->(DbSkip())
			Enddo
			
			FOQ->(DbSetOrder(1))
			If FOQ->(DbSeek(xFilial("FOQ") + cCodigo ))
				FOQ->(RecLock("FOQ", .F.))
				FOQ->FOQ_BLOQUE := "1"
				FOQ->(MsUnLock())
			Endif
			
			DbSelectArea("FOZ")
			FOZ->(DbSetOrder(1))
			
			If FOZ->(DbSeek(xFilial("FOZ") + cCodigo ))
				FOZ->(RecLock("FOZ", .F.))
				FOZ->FOZ_BLOQUE	:= "1"
				FOZ->(MsUnLock())
			Endif
		Endif

		cCodSeq := GetSXENum("FOZ", "FOZ_CODIGO")
		
		FOZ->(RecLock("FOZ", .T.))
		FOZ->FOZ_FILIAL	:= FwxFilial("FOZ")
		FOZ->FOZ_CODIGO	:= cCodSeq
		FOZ->FOZ_BANCO	:= cBanco
		FOZ->FOZ_MODULO	:= cPagRecT
		FOZ->FOZ_TIPO	:= cEnvRetT
		FOZ->FOZ_EDITAV	:= "2"
		FOZ->FOZ_DTGRV	:= DDATABASE
		FOZ->FOZ_USER	:= RETCODUSR()
		FOZ->FOZ_BLOQUE	:= "2"
		FOZ->(MsUnLock())
		
		For nY := 1 To Len(oObjCNABAti:checkins)
			
			cCtrEdi	:= "2"
			cVlrEdi	:= ""
			cNewVlr	:= ""
			
			If &(oObjCNABAti:CHECKINS[nY]:EDITA)
				aADD(aRetEdi,oObjCNABAti:CHECKINS[nY])
				cCtrEdi := "1"
				cVlrEdi	:= oObjCNABAti:CHECKINS[nY]:VLRESC
				cNewVlr	:= oObjCNABAti:CHECKINS[nY]:NEWVLR
			Endif
			
			IncProc(OemToAnsi(STR0069) + Alltrim(Str(nY)) + " de " + Alltrim(Str(Len(oObjCNABAti:checkins))) + OemToAnsi(STR0070)  ) // "Gravando o Registro numero " " Resgistros."
			
			(cAliasFOP)->(RecLock(cAliasFOP, .T. ))
			
			If oObjCNABAti:CHECKINS[nY]:IDELIN == "1"
				FOP->FOP_FILIAL	:= FwxFilial("FOP")
				FOP->FOP_CODIGO	:= cCodSeq
				FOP->FOP_IDELIN	:= oObjCNABAti:CHECKINS[nY]:IDELIN
				FOP->FOP_HEADET	:= oObjCNABAti:CHECKINS[nY]:HEADET
				FOP->FOP_CHALIN	:= oObjCNABAti:CHECKINS[nY]:CHALIN
				FOP->FOP_IDESEG	:= oObjCNABAti:CHECKINS[nY]:IDESEG
				FOP->FOP_BANCO	:= cBanco
				FOP->FOP_DESSEG	:= Iif(SubStr(oObjCNABAti:CHECKINS[nY]:DESSEG,1,3) == "DET",SubStr(oObjCNABAti:CHECKINS[nY]:DESSEG,9,20), "")
				FOP->FOP_POSINI	:= oObjCNABAti:CHECKINS[nY]:VAZIO1
				FOP->FOP_POSFIM	:= oObjCNABAti:CHECKINS[nY]:VAZIO2
				FOP->FOP_DECIMA	:= oObjCNABAti:CHECKINS[nY]:VAZIO3
				FOP->FOP_DESMOV	:= oObjCNABAti:CHECKINS[nY]:DESSEG
				FOP->FOP_CONARQ	:= oObjCNABAti:CHECKINS[nY]:DESMOV
				FOP->FOP_VERARQ	:= cVersaoArq
				FOP->FOP_BLOQUE	:= "2"
				FOP->FOP_EDITAD	:= "2"
				FOP->FOP_DTGRAV	:= DDATABASE
				FOP->FOP_PAGREC	:= cPagRecT
				FOP->FOP_REMRET	:= cEnvRetT
				FOP->FOP_SEQUEN	:= oObjCNABAti:CHECKINS[nY]:SEQUEN
				FOP->FOP_CTREDI	:= cCtrEdi
				FOP->FOP_CTDEDI	:= cVlrEdi
				FOP->FOP_NEWVLR	:= cNewVlr
			ElseIf oObjCNABAti:CHECKINS[nY]:IDELIN == "2"
				FOP->FOP_FILIAL	:= FwxFilial("FOP")
				FOP->FOP_CODIGO	:= cCodSeq
				FOP->FOP_IDELIN	:= oObjCNABAti:CHECKINS[nY]:IDELIN
				FOP->FOP_HEADET	:= oObjCNABAti:CHECKINS[nY]:HEADET
				FOP->FOP_CHALIN	:= oObjCNABAti:CHECKINS[nY]:CHALIN
				FOP->FOP_IDESEG	:= oObjCNABAti:CHECKINS[nY]:IDESEG
				FOP->FOP_BANCO	:= cBanco
				FOP->FOP_DESSEG	:= Iif(SubStr(oObjCNABAti:CHECKINS[nY]:DESSEG,1,3) == "DET",SubStr(oObjCNABAti:CHECKINS[nY]:DESSEG,9,20), "")
				FOP->FOP_POSINI	:= oObjCNABAti:CHECKINS[nY]:POSINI
				FOP->FOP_POSFIM	:= oObjCNABAti:CHECKINS[nY]:POSFIM
				FOP->FOP_DECIMA	:= oObjCNABAti:CHECKINS[nY]:DECIMA
				FOP->FOP_DESMOV	:= oObjCNABAti:CHECKINS[nY]:DESSEG
				FOP->FOP_CONARQ	:= oObjCNABAti:CHECKINS[nY]:DESMOV
				FOP->FOP_VERARQ	:= cVersaoArq
				FOP->FOP_BLOQUE	:= "2"
				FOP->FOP_EDITAD	:= "2"
				FOP->FOP_DTGRAV	:= DDATABASE
				FOP->FOP_PAGREC	:= cPagRecT
				FOP->FOP_REMRET	:= cEnvRetT
				FOP->FOP_SEQUEN	:= oObjCNABAti:CHECKINS[nY]:SEQUEN
				FOP->FOP_CTREDI	:= cCtrEdi
				FOP->FOP_CTDEDI	:= cVlrEdi
				FOP->FOP_NEWVLR	:= cNewVlr
			Endif
			(cAliasFOP)->(MsunLock())
			
		Next nY
		
		aADD(__aHdrRest,{aDdsCNAB,{aRetEdi}})
		
		AADD(aArrayFOQ, {"FOQ_FILIAL", FWxFilial("FOQ")})
		AADD(aArrayFOQ, {"FOQ_CODIGO", cCodSeq } )
		AADD(aArrayFOQ, {"FOQ_DATA"  , DDataBase}) // Não SX3
		AADD(aArrayFOQ, {"FOQ_HORA"  , cTime} )
		AADD(aArrayFOQ, {"FOQ_CHVCTR", cBanco + STRTRAN(cVersaoArq, ".","") + cPagRecT + cEnvRetT})
		AADD(aArrayFOQ, {"FOQ_VERTVS", cVersaoArq})
		AADD(aArrayFOQ, {"FOQ_BANCO" , cBanco})
		AADD(aArrayFOQ, {"FOQ_PGRECT", cPagRecT})
		AADD(aArrayFOQ, {"FOQ_ENRETT", cEnvRetT})
		AADD(aArrayFOQ, {"FOQ_CTRVAL", "1"})
		AADD(aArrayFOQ, {"FOQ_CTRVER", "1"})
		AADD(aArrayFOQ, {"FOQ_VERCLI", cVersaoArq})
		AADD(aArrayFOQ, {"FOQ_NOMARQ", cBanco + StrTran(cVersaoArq,".","") + cPagRecT + cEnvRetT })
		AADD(aArrayFOQ, {"FOQ_PGRECC", ""})
		AADD(aArrayFOQ, {"FOQ_ENRETC", ""})
		AADD(aArrayFOQ, {"FOQ_BLOQUE", "2" })
		
		lRet	:= CFGX049B2A(aArrayFOQ)
		
		If lRet
			ConfirmSX8()
		Else
			RollBackSxe()
		Endif
	Else
		Aviso(OemToAnsi(STR0035), OemToAnsi(STR0071), {"Ok"}, 3 ) // "Atenção", "Não foi possivel gerar os arquivos CNAB. Favor verificar."
		lRet := .F.
	Endif
	
Return lRet

//----------------------------------------------------------------------------------------------
/*/ {Protheus.doc} CFGX049B5A()
Função que devolve o arrays alimentado com os registros que poderão ser editados

@Project	CNAB - Padronizado
@author	Francisco Oliveira
@since		18/08/2017
@version	P12
@Return	Logico com o resultado da gravação
@param
@Obs
/*/
//---------------------------------------------------------------------------------------
Function CFGX049B5A() As Array
Return __aHdrRest
