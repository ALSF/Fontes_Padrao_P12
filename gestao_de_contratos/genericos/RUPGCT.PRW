#INCLUDE 'PROTHEUS.CH'

//====================================================================================================================
/*/{Protheus.doc} RUP_GCT
Função de compatibilização do release incremental. Esta função é relativa ao módulo Gestão de Contratos.
Serão chamadas todas as funções compiladas referentes aos módulos cadastrados do Protheus
Será sempre considerado prefixo "RUP_" acrescido do nome padrão do módulo sem o prefixo SIGA.
Ex: para o módulo SIGAGCT criar a função RUP_GCT

@param  cVersion   - Versão do Protheus
@param  cMode      - Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)
@param  cRelStart  - Release de partida  Ex: 002
@param  cRelFinish - Release de chegada Ex: 005
@param  cLocaliz   - Localização (país). Ex: BRA

@Author Leonardo Quintania
@since 07/05/2015
@version P12
/*/
//====================================================================================================================
Function RUP_GCT( cVersion, cMode, cRelStart, cRelFinish, cLocaliz )
	Local cRelLoop	:= ""
	Local nRelease	:= 0
	
	#IFDEF TOP //Proteção para não dar problema no loja, que ainda utiliza dbf na 12
		//-- Regra geral : só executar atualização quando release de partida diferente do release de chegada
		If cRelStart != cRelFinish
			Conout("[RUP_GCT] Início da EXECUCAO Release Inicial: "+cRelStart+ " Release Final: "+cRelFinish+ "." )
			For nRelease := Val( cRelStart ) + 1 to Val( cRelFinish )
				cRelLoop := StrZero( nRelease, 3 ) 	//- Release sendo processado
				DO 	CASE
					CASE cRelLoop == "005" //-- Processar apenas no Release 5
						GCT005Ajus( cMode )
					CASE cRelLoop == "007" //-- Processar apenas no Release 7
						GCT007Ajus( cMode )
					CASE cRelLoop == "016" //-- Processar apenas no Release 16
						GCT016Ajus( cMode )
					CASE cRelLoop == "017" //-- Processar apenas no Release 17
						GCT017Ajus( cMode )
					CASE cRelLoop == "023" //-- Processar apenas no Release 23
						GCT023Ajus( cMode )
					CASE cRelLoop == "025" //-- Processar apenas no Release 25
						GCT025Ajus( cMode )
				ENDCASE
			Next nRelease		
		Else
			//-------------------------------------------------------------
			// Força atualização no release 017 por conta do congelamento
			//-------------------------------------------------------------
			If cRelStart = "017" .And. cRelFinish = "017"
				Conout("[RUP_GCT] Início da EXECUCAO... Atualizacao release congelado 12117 " )
				GCT017Ajus( cMode )
			EndIf
		EndIf
	#ENDIF
Return NIL

//====================================================================================================================
/*/{Protheus.doc} GCT005Ajus()
Ajuste para release 12.5

@param cMode, Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)
@return NIL

@author Leonardo Quintania
@since 29/08/2015
@version P12
/*/
//====================================================================================================================
Static Function GCT005Ajus( cMode )
	Default cMode := ""
	
	If cMode == "2" //Por Filial
	
		//-- Processa os contratos e atualiza o codigo do grupo de aprovação
		//-- do tipo de contrato no cabeçalho do contrato.	
		BeginSQL Alias "CN9TMP"
			SELECT CN9.R_E_C_N_O_ CN9RECNO,
				CN1.CN1_GRPSIT,
				CN1.CN1_GRPAPR
		
			FROM %Table:CN9% CN9
		
			JOIN %Table:CN1% CN1 ON
				CN1.%NotDel% AND
				CN1.CN1_FILIAL = %xFilial:CN1% AND
				CN1.CN1_CODIGO = CN9.CN9_TPCTO
		
			WHERE 	CN9.%NotDel% AND
				CN9.CN9_FILIAL = %xFilial:CN9% AND
				(CN9.CN9_APROV = '' OR CN9.CN9_GRPAPR = '')		
		EndSQL
		
		While !CN9TMP->(EOF())
			CN9->(MsGoTo(CN9TMP->CN9RECNO))
			If RecLock("CN9",.F.)
				CN9->CN9_APROV 	:= CN9TMP->CN1_GRPSIT
				CN9->CN9_GRPAPR := CN9TMP->CN1_GRPAPR
				CN9->(MsUnLock())
			EndIf
			CN9TMP->(dbSkip())
		EndDo
		CN9TMP->(dbCloseArea())
	
	EndIf

Return NIL

//====================================================================================================================
/*/{Protheus.doc} GCT007Ajus()
Ajuste para release 12.7

@param cMode, Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)
@return NIL

@author Leonardo Quintania
@since 29/08/2015
@version P12
/*/
//====================================================================================================================
Function GCT007Ajus( cMode )	
	Local aAreaSX3:= SX3->(GetArea())
	Local nTamMed	:= TamSx3("CND_NUMMED")[2]
	Default cMode := ""
	
	If cMode == "2" //Por Filial
	
		//-- Atualizando o novo campo CNR_CODPLA com o valor referente a planilha medida
		BeginSQL Alias "CNRTMP"
			SELECT CNR.R_E_C_N_O_ CNRRECNO,
					CND.CND_NUMERO
		
			FROM %Table:CNR% CNR
		
			JOIN %Table:CND% CND ON
				CNR.CNR_FILIAL = %xFilial:CNR%
				AND CNR.CNR_NUMMED = CND.CND_NUMMED
		
			WHERE CNR.%NotDel% AND
				CND.CND_FILIAL = %xFilial:CND% AND
				CND.%NotDel%
		EndSQL
		
		While !CNRTMP->(EOF())
			CNR->(MsGoTo(CNRTMP->CNRRECNO))
			If RecLock("CNR",.F.)
				CNR_CODPLA := CNRTMP->CND_NUMERO
				CNR->(MsUnLock())
			EndIf
			CNRTMP->(dbSkip())
		End
		CNRTMP->(dbCloseArea())
	
		//-- Atualiza tabela DBM
		BeginSQL Alias "DBMTMP"
			SELECT DBM.R_E_C_N_O_ RECNODBM FROM
			%Table:DBM% DBM WHERE DBM.DBM_TIPO= 'IM'
			AND DBM.DBM_FILIAL = %xFilial:DBM%
			AND DBM.%NotDel%
		EndSQL
		
		While !DBMTMP->(EOF())
			DBM->(dbGoto(DBMTMP->RECNODBM))
			cNumero	:= Substr(DBM->DBM_NUM,1,nTamMed)
			cSequencia	:= Substr(DBM->DBM_NUM,nTamMed+1,3)
			CND->(MsSeek(DBM->DBM_FILIAL+cNumero))
			RecLock("DBM",.F.)
			DBM->DBM_NUM	:= cNumero+CND->CND_NUMERO+cSequencia	//-- Novo conjunto de chave da tabela DBM
			DBM->(MsUnlock())
			DBMTMP->(dbSkip())
		EndDo
		DBMTMP->(dbCloseArea())
		RestArea(aAreaSX3)
	
		MigraCNA()

	ElseIf cMode == "1" //Por grupo

		AjustaCPD()

	EndIF
	
Return NIL

//====================================================================================================================
/*/{Protheus.doc} GCT016Ajus()
Ajuste para release 12.1.16

@param cMode, Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)
@return NIL

@author israel.escorizza
@since 10/01/2017
@version P12
/*/
//====================================================================================================================
Function GCT016Ajus( cMode )	
	Default cMode := ""

	If cMode == "2" //Por Filial
		
		//--- Atualizar o CND conforme as regras do CNTA120
		BeginSQL Alias "CNDTMP"
			SELECT CND.R_E_C_N_O_ CNDRECNO,
					CND.CND_DTFIM,
					CND.CND_ALCAPR,
					CND.CND_AUTFRN,
					CND.CND_SERVIC,
					CND.CND_PEDIDO
		
			FROM %Table:CND% CND
		
			WHERE CND.CND_FILIAL = %xFilial:CND% 	AND
				CND.%NotDel%
		EndSQL
		
		While !CNDTMP->(EOF())
			CND->(MsGoTo(CNDTMP->CNDRECNO))
			If Empty(CND->CND_SITUAC)
				Do Case
					Case !Empty(CND->CND_DTFIM) .AND. !Empty(CND->CND_PEDIDO) .AND. CND->CND_ALCAPR == 'T'
						If RecLock("CND",.F.)
							CND->CND_SITUAC := "DT"
							CND->CND_ALCAPR := "L"
							CND->(MsUnLock())
						EndIf
					Case !Empty(CND->CND_DTFIM) .AND. !Empty(CND->CND_PEDIDO) .AND. CND->CND_ALCAPR == 'P'
						If RecLock("CND",.F.)
							CND->CND_SITUAC := "DP"
							CND->CND_ALCAPR := "L"
							CND->(MsUnLock())
						EndIf
		
					Case Empty(CND->CND_DTFIM) .AND. CND->CND_ALCAPR == 'L'  .And. CND->CND_AUTFRN == '1' .And. CND->CND_SERVIC == '1'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="A"
							CND->(MsUnLock())
						EndIf
		
					Case Empty(CND->CND_DTFIM) .AND. CND->CND_ALCAPR == 'B'  .And. CND->CND_AUTFRN == '1'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="B"
							CND->(MsUnLock())
						EndIf
		
					Case !Empty(CND->CND_DTFIM).And. CND->CND_AUTFRN == '1' .And. CND->CND_SERVIC == '1'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="E"
							CND->(MsUnLock())
						EndIf
		
					Case Empty(CND->CND_DTFIM) .AND. Empty(CND->CND_PEDIDO) .And. CND->CND_AUTFRN == '2'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="F"
							CND->(MsUnLock())
						EndIf
		
					Case Empty(CND->CND_DTFIM) .AND. !Empty(CND->CND_PEDIDO).And. CND->CND_AUTFRN == '2'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="FA"
							CND->(MsUnLock())
						EndIf
		
					Case !Empty(CND->CND_DTFIM) .AND. !Empty(CND->CND_PEDIDO).And. CND->CND_AUTFRN == '2'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="FE"
							CND->(MsUnLock())
						EndIf
		
					Case Empty(CND->CND_DTFIM) .AND. CND->CND_SERVIC == '2'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="SA"
							CND->(MsUnLock())
						EndIf
		
					Case !Empty(CND->CND_DTFIM) .AND. CND->CND_SERVIC == '2'
						If RecLock("CND",.F.)
							CND->CND_SITUAC :="SE"
							CND->(MsUnLock())
						EndIf
				EndCase
			EndIf
			CNDTMP->(dbSkip())
		EndDo
		CNDTMP->(dbCloseArea())
	
	EndIf
	
Return

//====================================================================================================================
/*/{Protheus.doc} GCT017Ajus()
Ajuste para release 12.1.17

@param cMode, Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)
@return NIL

@author israel.escorizza
@since 10/01/2017
@version P12
/*/
//====================================================================================================================
Function GCT017Ajus( cMode )
	Local lInDB	:= MPDicInDB()	//- Verifica se dicionário é no banco (.T.) ou em arquivos(.F.).
	Default cMode := ""
	
	Conout("[RUP_GCT] Início da EXECUCAO Release 17...")	
	
	If cMode == "2" //Por Filial
		
		If CZY->( ColumnPos('CZY_NUMPLA')) > 0
			//--- Atualizar o novo campo CZY_NUMPLA conforme planilha da medição.
			BeginSQL Alias "CZYTMP"
				SELECT 	CZY.R_E_C_N_O_ CZYRECNO,
						CZY.CZY_CONTRA,
						CZY.CZY_NUMMED,
						CND.CND_NUMERO
		
				FROM 	%Table:CZY% CZY,
						%Table:CND% CND
		
				WHERE 	CZY.CZY_FILIAL = %Exp:xFilial('CZY')% 	AND
						CZY.CZY_NUMPLA = '' 					AND
						CZY.%NotDel%							AND
		
						CND.CND_FILIAL = %Exp:xFilial('CND')% 	AND
						CND.CND_CONTRA = CZY.CZY_CONTRA 		AND
						CND.CND_NUMMED = CZY.CZY_NUMMED 		AND
						CND.%NotDel%
			EndSQL
		
			While !CZYTMP->(EOF())
				CZY->(MsGoTo(CZYTMP->CZYRECNO))
		
				If !Empty(CZYTMP->CND_NUMERO) .And. RecLock("CZY",.F.)
					CZY->CZY_NUMPLA := CZYTMP->CND_NUMERO
					CZY->(MsUnLock())
				EndIf
				CZYTMP->(dbSkip())
			EndDo
		EndIf
		
	ElseIf cMode == "1" //Por grupo
		
		AjustaAC9() //--Corrige campo AC9_XXX retirando o número da revisão da chave.
	
		SX3->(DbSetOrder(2))
		If SX3->(DbSeek("CN0_TIPO")) .And. !Empty(SX3->X3_CBOX)
			Reclock("SX3",.F.)
			SX3->X3_CBOX 	:= ""
			SX3->X3_CBOXSPA := ""
			SX3->X3_CBOXENG := ""
			SX3->(MsUnlock())
		EndIf
	
		If SX3->(DbSeek("CND_DESCME")) .AND. SX3->X3_VISUAL == "A"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "V"
			SX3->(MsUnlock())
		Endif
	
		If SX3->(DbSeek("CND_NUMMED"))
			If SX3->X3_VISUAL == "A"
				Reclock("SX3",.F.)
				SX3->X3_VISUAL := "V"
				SX3->(MsUnlock())
			EndIf
		
			If Empty(SX3->X3_RELACAO)
				Reclock("SX3",.F.)
				SX3->X3_RELACAO := "CN130NumMd()"
				SX3->(MsUnlock())
			EndIf
		Endif
	
		If SX3->(DbSeek("CND_DESCCP"))
			Reclock("SX3",.F.)
			SX3->X3_RELACAO := 'IF(INCLUI,"",Posicione("SE4",1,xFilial("SE4")+CND->CND_CONDPG,"E4_DESCRI"))'
			SX3->(MsUnlock())
		Endif
	
		If SX3->(DbSeek("CN9_TPCTO")) .AND. SX3->X3_VISUAL == "V"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "A"
			SX3->(MsUnlock())
		Endif
	
		If SX3->(DbSeek("CN9_TIPREV")) .AND. SX3->X3_VISUAL == "V"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "A"
			SX3->(MsUnlock())
		Endif
		
		If SX3->(DbSeek("CN9_DESCRI")) .And. AllTrim(SX3->X3_TITULO) == 'Fora de Uso'
			Conout("[RUP_GCT] Alterando o X3_USADO e o X3_TITULO do campo CN9_DESCRI.")	
			RecLock("SX3",.F.)
			SX3->X3_TITULO	:= 'Descrição   '
			SX3->X3_DESCRIC	:= 'Descritivo do Contrato   '
			SX3->X3_TITSPA	:= 'Descripcion '
			SX3->X3_DESCSPA	:= 'Descrip del contrato     '
			SX3->X3_TITENG	:= 'Description '
			SX3->X3_DESCENG	:= 'Contract Description     '
			SX3->(MsUnlock())
		EndIf
	
		If SX3->(DbSeek("CNA_VLTOT")) .AND. SX3->X3_VISUAL == "V"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "A"
			SX3->(MsUnlock())
		Endif
	
		If SX3->(DbSeek("CNA_CLIENT")) .AND. SX3->X3_VISUAL == "V"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "A"
			SX3->(MsUnlock())
		Endif
	
		If SX3->(DbSeek("CNA_LOJACL")) .AND. SX3->X3_VISUAL == "V"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "A"
			SX3->(MsUnlock())
		Endif
	
		If SX3->(DbSeek("CNA_FORNEC")) .AND. SX3->X3_VISUAL == "V"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "A"
			SX3->(MsUnlock())
		Endif
	
		If SX3->(DbSeek("CNA_LJFORN")) .AND. SX3->X3_VISUAL == "V"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "A"
			SX3->(MsUnlock())
		Endif
		
		If SX3->(DbSeek("CNB_VLTOT")) .AND. SX3->X3_VISUAL == "A"
			Reclock("SX3",.F.)
			SX3->X3_VISUAL := "V"
			SX3->(MsUnlock())
		Endif
		
		If SX3->(DbSeek('CXI_QUANT'))
			Reclock("SX3",.F.)
			SX3->X3_USADO := Iif(lInDB,FWConvBin("€€€€€€€€€€€€€€ " ),"€€€€€€€€€€€€€€ ")
			SX3->(MsUnlock())
		EndIf
	
	EndIf
	
	//- Realiza correção dos campos CNB_PEDTIT e CNE_PEDTIT
	AjustaGCT( 'GCT017Ajus', cMode )
	
	Conout("[RUP_GCT] fim da EXECUCAO.")

Return

//====================================================================================================================
/*/{Protheus.doc} GCT023Ajus()
Ajuste para release 12.1.21

@param cMode, Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)
@return NIL

@author janaina.jesus
@since 04/05/2017
@version P12
/*/
//====================================================================================================================
Function GCT023Ajus( cMode )
	Local cRelCNCNom := "If(INCLUI,'',If(Type('CNC_CODIGO')=='U','',Posicione('SA1',1,xFilial('SA1')+CNC_CODIGO+CNC_LOJA,'A1_NOME')))"
	Default cMode := ""
	
	Conout("[RUP_GCT] Início da EXECUCAO Release 21...")	
	
	If cMode == "1" //Por grupo
		
		AjustaAC9() 	//--Corrige campo AC9_XXX retirando o número da revisão da chave.
		dbSelectArea('SE2')
		If SE2->(Columnpos('E2_MEDNUME')) > 0
			GctAjustE2() //- processa o ajuste do campo E2_MEDNUME
		EndIf
		
		SX3->(DbSetOrder(2))
	
		If SX3->(DbSeek("CNC_NOMECL")) .And. Alltrim(SX3->X3_RELACAO) == cRelCNCNom //--Altero apenas se não houver alteração do X3_RELACAO de acordo com o padrão.
			Reclock("SX3",.F.)
			SX3->X3_RELACAO := 'If(!INCLUI,Posicione("SA1",1,xFilial("SA1")+CNC->(CNC_CLIENT+CNC_LOJACL),"A1_NOME")," ")'
			SX3->(MsUnlock())
		Endif
		
		If SX3->(dbSeek("CN9_NUMERO")) .And. SX3->X3_RELACAO != 'CN300Num()'
			RecLock("SX3",.F.)
			SX3->X3_RELACAO := 'CN300Num()'
			SX3->(MsUnlock())
		EndIf
		
		If SX3->(dbSeek("CXN_PARCEL")) 
			Reclock("SX3",.F.)
			SX3->X3_VISUAL	:= 'A'
			SX3->(MsUnlock())
		Endif
		
		If CXN->( ColumnPos('CXN_ZERO')) > 0
			GctAjustCXN()//-processa o ajuste do campo CXN_ZERO
		EndIf
		
	EndIf
						
	Conout("[RUP_GCT] fim da EXECUCAO.")

Return Nil

//====================================================================================================================
/*/{Protheus.doc} AjustaGCT(cFonte)
Função para realização do AjustaSX3 durante release.
Os ajustes realizados nesta função devem obrigatóriamente estar contido na função de migração (GCTXXXAjus) e ATUSX.
Os ajustes realizados nesta função serão removidos a cada release.

@param  cFonte	- Fonte no qual o ajusta será realizado.
@param cMode, Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)

@Author Israel Escorizza
@since 29/03/2016
@version P12
/*/
//====================================================================================================================
Function AjustaGCT( cFonte, cMode )
	Local lRet	:= .T.
	Local aArea	:= GetArea()
	Local aRows	:= FWSaveRows()
	
	Default cFonte := ""
	Default cMode := ""
	
	DO CASE
		CASE cFonte $ "LoadGCT|GCT017Ajus"
			
			If cMode == "2" //Por Filial
			
				GCTAjEsCtr()	//- processo o ajuste do campo CN9_ESPCTR
				GCTAjusCli()	//- processa o ajuste do campo CN9_CLIENT e CN9_LOJACL
				GCTAjuFCtr()	//- processa o ajuste dos campo CN9_FILCTR e CND_FILCTR
				GCTAjuRea()		//- processa o ajuste dos campos CN1_CREALM e CN1_CREAJM de acordo com os parametros MV_CNREALM e MV_CNREAJM descontinuados na v.12
				MigraCNA()		//- processa a compatibilização da tabela CNA na migração para contratos flexiveis sem planilha
				GCTAjNuPla()	//- processa o ajuste para preencher o número da planilha nas parcelas do cronograma	
			
			ElseIf cMode == "1" //Por grupo 
			
				AjustaCPD()		//- processa a compatibilização da tabela CPD na migração para a versão 12
				CriaCNDCNE()	//- processa a compatibilização das tabela CNE e CND dos contratos flexiveis migração para a versão 12
				MigPedTit()		//- processa o ajuste dos campos CNB_PEDTIT e CNE_PEDTIT na versão 12
				AjustaMnt()		//-- Funcao para realizar os ajustes de manutenção do release corrente
				
				dbSelectArea('SE2')
				If SE2->(Columnpos('E2_MEDNUME')) > 0
					GctAjustE2() //- processa o ajuste do campo E2_MEDNUME
				EndIf
			
				dbSelectArea('CXN')
				If CXN->( ColumnPos('CXN_ZERO')) > 0
					GctAjustCXN()//-processa o ajuste do campo CXN_ZERO
				EndIf
			
			EndIf
												
	ENDCASE
	
	FWRestRows(aRows)
	RestArea(aArea)
Return lRet

//====================================================================================================================
/*/{Protheus.doc} AjustaCPD
Função de compatibilização das tabela CPD, realizado os ajustes essenciais a migração correta dos contratos para a versão 12.

@Author Israel Escorizza
@since 12/04/2016
@version P12
/*/
//====================================================================================================================
Function AjustaCPD()
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local cAliasTmp	:= GetNextAlias()
Local cQuery	:= ""

Local cSM0Seek	:= ""
Local cContra 	:= ""
Local cPlan	 	:= ""
Local cFilCtr	:= ""
Local nTamFil	:= 0

Local lCN9Excl  := FwModeAccess('CN9') == 'E'

cQuery	+= " SELECT DISTINCT "
cQuery	+= " CN9.CN9_FILIAL, "
cQuery	+= " CN9.CN9_NUMERO, "
cQuery	+= " CNA.CNA_NUMERO  "
cQuery	+= " FROM "+ RetSqlName('CN9') +" CN9 "
cQuery	+= " LEFT JOIN "+ RetSqlName('CNA') +" CNA ON "
cQuery	+= " CNA.D_E_L_E_T_ = ' ' AND "
cQuery	+= " CNA.CNA_CONTRA = CN9.CN9_NUMERO AND "
cQuery	+= " CNA.CNA_REVISA = CN9.CN9_REVISA "
cQuery	+= " WHERE "
cQuery	+= " CN9.D_E_L_E_T_ = ' '"

cQuery	:= ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAliasTmp,.T.,.T.)

dbSelectArea('CPD')
CPD->(dbSetOrder(1)) //-CPD_FILIAL+CPD_CONTRA+CPD_NUMPLA+CPD_FILAUT

SM0->(dbSetOrder(1))
While !(cAliasTmp)->(EOF())
	cFilCtr  := (cAliasTmp)->CN9_FILIAL 
	nTamFil	 := Len(cFilCtr)
	
	cContra  := (cAliasTmp)->CN9_NUMERO
	cPlan	 := (cAliasTmp)->CNA_NUMERO
	cSM0Seek := cEmpAnt + IIf( lCN9Excl , cFilCtr , "" )

	If SM0->(MsSeek(cSM0Seek))
		While !SM0->(EOF()) .And. SM0->(M0_CODIGO + Substr(cFilCtr,1,nTamFil) ) == cEmpAnt + cFilCtr
			If !CPD->(MsSeek(cFilCtr + cContra + cPlan))
				RecLock("CPD",.T.)
				CPD->CPD_FILIAL := cFilCtr
				CPD->CPD_CONTRA := cContra
				If !Empty(cPlan)
					CPD->CPD_NUMPLA := cPlan
				EndIf
				CPD->CPD_FILAUT := IIf ( lCN9Excl , cFilCtr, FwCodFil() )
				CPD->(MsUnLock())
			EndIf
			SM0->(dbSkip())
		EndDo
	EndIf
	(cAliasTmp)->(dbSkip())
EndDo

(cAliasTmp)->(dbCloseArea())

FWRestRows(aRows)
RestArea(aArea)
Return

//====================================================================================================================
/*/{Protheus.doc} MigraCNA
Função de compatibilização das tabela CNA, realizado os ajustes essenciais a migração correta dos contratos flexiveis
para a versão 12.

@Author Israel Escorizza
@since 12/04/2016
@version P12
/*/
//====================================================================================================================
Function MigraCNA()
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local cPlanMig	:= GetPlanMg()
Local cQueryCN9	:= ""
Local cQueryCNA	:= ""
Local cAliasCN9	:= GetNextAlias()
Local cAliasCNA	:= GetNextAlias()
Local lCompra		:= .T.
Local lValor		:= .T.
Local lFixo		:= .T.
Local cFilCN9		:=""
Local cNumCN9		:=""
Local cRevCN9		:=""

cQueryCN9	+= " SELECT "
cQueryCN9	+= " CN9.CN9_FILIAL, "
cQueryCN9	+= " CN9.CN9_NUMERO, "
cQueryCN9	+= " CN9.CN9_REVISA, "
cQueryCN9	+= " CN9.CN9_DTINIC, "
cQueryCN9	+= " CN9.CN9_DTFIM,  "
cQueryCN9	+= " CN9.CN9_VLATU,  "
cQueryCN9	+= " CN9.CN9_SALDO,  "
cQueryCN9	+= " CN9.CN9_FLGREJ, "
cQueryCN9	+= " CNC.CNC_CODIGO, "
cQueryCN9	+= " CNC.CNC_LOJA,	 "
cQueryCN9	+= " CNC.CNC_CLIENT, "
cQueryCN9	+= " CNC.CNC_LOJACL	 "

cQueryCN9	+= " FROM "+ RetSqlName('CN9') +" CN9, "+ RetSqlName('CNC') +" CNC "

cQueryCN9	+= " WHERE "
cQueryCN9	+= " CN9.CN9_FILIAL = CNC.CNC_FILIAL AND "
cQueryCN9	+= " CN9.CN9_NUMERO = CNC.CNC_NUMERO AND "
cQueryCN9	+= " CN9.CN9_REVISA = CNC.CNC_REVISA AND "
cQueryCN9	+= " CN9.CN9_SITUAC = '05' AND "
cQueryCN9	+= " CN9.CN9_FILIAL = '" + FWxFilial("CN9") + "' AND "
cQueryCN9	+= " CN9.D_E_L_E_T_ = ' '  AND "
cQueryCN9	+= " CNC.D_E_L_E_T_ = ' ' "

cQueryCN9	+= " ORDER BY "
cQueryCN9	+= " CN9.CN9_NUMERO ASC, CN9.CN9_REVISA "

cQueryCN9	:= ChangeQuery(cQueryCN9)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCN9), cAliasCN9,.T.,.T.)

dbSelectArea('CN9')
CN9->(dbSetOrder(1))

While !(cAliasCN9)->(EOF())
	cFilCN9	:=(cAliasCN9)->CN9_FILIAL
	cNumCN9	:=(cAliasCN9)->CN9_NUMERO
	cRevCN9	:=(cAliasCN9)->CN9_REVISA

	CN9->(MsSeek(cFilCN9+cNumCN9+cRevCN9))

	lCompra := Cn300RetSt("COMPRA")
	lValor	:= Cn300RetSt("PREVFINANC")
	lFixo	:= Cn300RetSt('FIXO')

	cQueryCNA	:= " SELECT * FROM " + RetSqlName('CNA') + " WHERE "
	cQueryCNA	+= " CNA_FILIAL = '" + cFilCN9 +"' AND"
	cQueryCNA	+= " CNA_CONTRA = '" + cNumCN9 +"' AND"
	cQueryCNA	+= " CNA_REVISA = '" + cRevCN9 +"' AND"
	cQueryCNA	+= " D_E_L_E_T_ = ' '"

	cQueryCNA	:= ChangeQuery(cQueryCNA)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCNA), cAliasCNA,.T.,.T.)

	If (cAliasCNA)->(EOF()) .And. !lFixo
		Reclock("CNA",.T.)
		CNA->CNA_FILIAL := cFilCN9
		CNA->CNA_CONTRA := cNumCN9
		CNA->CNA_REVISA	:= cRevCN9
		CNA->CNA_NUMERO	:= STRZero(1,TAMSX3('CNA_NUMERO')[1],0)
		CNA->CNA_TIPPLA	:= cPlanMig
		CNA->CNA_DTINI	:= sToD((cAliasCN9)->CN9_DTINIC)
		CNA->CNA_DTFIM	:= sToD((cAliasCN9)->CN9_DTFIM)
		CNA->CNA_VLTOT	:= IIf(lValor, (cAliasCN9)->CN9_VLATU, 0)
		CNA->CNA_SALDO	:= (cAliasCN9)->CN9_SALDO
		CNA->CNA_FLREAJ := (cAliasCN9)->CN9_FLGREJ
		CNA->CNA_FORNEC	:= (cAliasCN9)->CNC_CODIGO
		CNA->CNA_LJFORN	:= (cAliasCN9)->CNC_LOJA
		CNA->CNA_CLIENT	:= (cAliasCN9)->CNC_CLIENT
		CNA->CNA_LOJACL	:= (cAliasCN9)->CNC_LOJACL
		CNA->(MsUnLock())
	EndIf
	(cAliasCNA)->(dbCloseArea())
	(cAliasCN9)->(dbSkip())
EndDo

(cAliasCN9)->(dbCloseArea())
FWRestRows(aRows)
RestArea(aArea)
Return

//====================================================================================================================
/*/{Protheus.doc} CriaCNDCNE
Função de compatibilização das tabela CNE e CND, realizado os ajustes essenciais a migração correta dos contratos flexiveis
para a versão 12.

@Author Filipe Gonçalves
@since 29/09/2017
@version P12
/*/
//====================================================================================================================
Function CriaCNDCNE()
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local cQueryCNE	:= ""
Local cQueryCND	:= ""
Local cAliasCNE	:= GetNextAlias()
Local cAliasCND	:= GetNextAlias()

dbSelectArea('CNA')
CNA->(dbSetOrder(1))

cQueryCNE += " SELECT "
cQueryCNE += " CNE.CNE_FILIAL, "
cQueryCNE += " CNE.CNE_CONTRA, "
cQueryCNE += " CNE.CNE_REVISA, "
cQueryCNE += " CNE.CNE_NUMMED "
cQueryCNE += " FROM "+ RetSqlName('CNE') + " CNE "
cQueryCNE += " WHERE "
cQueryCNE += " CNE.CNE_NUMERO = '' AND "
cQueryCNE += " CNE.D_E_L_E_T_ = ' ' "

cQueryCNE	:= ChangeQuery(cQueryCNE)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCNE), cAliasCNE,.T.,.T.)

While !(cAliasCNE)->(EOF())
	If CNA->(DbSeek((cAliasCNE)->(CNE_FILIAL) + (cAliasCNE)->(CNE_CONTRA) + (cAliasCNE)->(CNE_REVISA)))
		dbSelectArea('CNE')
		CNE->(dbSetOrder(4))
		If CNE->(DbSeek((cAliasCNE)->(CNE_FILIAL) + (cAliasCNE)->(CNE_NUMMED)))
			Reclock("CNE",.F.)
			CNE->CNE_NUMERO	:= CNA->CNA_NUMERO
			CNE->(MsUnLock())
		EndIf
	EndIf
	(cAliasCNE)->(dbSkip())
EndDo
(cAliasCNE)->(dbCloseArea())

cQueryCND += " SELECT "
cQueryCND += " CND.CND_FILIAL, "
cQueryCND += " CND.CND_CONTRA, "
cQueryCND += " CND.CND_REVISA, "
cQueryCND += " CND.CND_NUMMED "
cQueryCND += " FROM "+ RetSqlName('CND') + " CND "
cQueryCND += " WHERE "
cQueryCND += " CND.CND_NUMERO = '' AND "
cQueryCND += " CND.D_E_L_E_T_ = ' ' "

cQueryCND	:= ChangeQuery(cQueryCND)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCND), cAliasCND,.T.,.T.)

While !(cAliasCND)->(EOF())
	If CNA->(DbSeek((cAliasCND)->(CND_FILIAL) + (cAliasCND)->(CND_CONTRA) + (cAliasCND)->(CND_REVISA)))
		dbSelectArea('CND')
		CND->(dbSetOrder(4))
		If CND->(DbSeek((cAliasCND)->(CND_FILIAL) + (cAliasCND)->(CND_NUMMED)))
			Reclock("CND",.F.)
			CND->CND_NUMERO	:= CNA->CNA_NUMERO
			CND->(MsUnLock())
		EndIf
	EndIf
	(cAliasCND)->(dbSkip())
EndDo
(cAliasCND)->(dbCloseArea())

FWRestRows(aRows)
RestArea(aArea)
Return

//====================================================================================================================
/*/{Protheus.doc} GetPlanMg()
Função que retorna Planilha de migração (totalmente conforme o contrato), caso não exista, cria a planilha retornando
seu código.

@Author Israel Escorizza
@since 13/04/2016
@version P12
/*/
//====================================================================================================================
Function GetPlanMg()
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local cRet			:= ""
Local cQueryCNL	:= ""
Local cAliasCNL	:= GetNextAlias()

cQueryCNL 	+= " SELECT "
cQueryCNL	+= " CNL_CODIGO "
cQueryCNL	+= " FROM "+ RetSqlName('CNL')
cQueryCNL	+= " WHERE "
cQueryCNL 	+= " CNL_FILIAL = '"+ xFilial('CNL') +"' AND "
cQueryCNL	+= " CNL_DESCRI = '__MIGRAÇAO_V12' AND "
cQueryCNL	+= " D_E_L_E_T_ = ' ' "
cQueryCNL 	+= " ORDER BY CNL_CODIGO DESC "

cQueryCNL	:= ChangeQuery(cQueryCNL)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCNL), cAliasCNL,.T.,.T.)

If !Empty((cAliasCNL)->CNL_CODIGO)
	cRet := (cAliasCNL)->CNL_CODIGO
Else
	(cAliasCNL)->(dbCloseArea())
	cQueryCNL	:= " SELECT MAX(CNL_CODIGO) CNL_MAX  FROM "+ RetSqlName('CNL')
	cQueryCNL	:= ChangeQuery(cQueryCNL)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCNL), cAliasCNL,.T.,.T.)

	cRet:= StrZero(999,TAMSX3('CNL_CODIGO')[1])
	While cRet <= (cAliasCNL)->CNL_MAX
		cRet := Soma1((cAliasCNL)->CNL_MAX)
	EndDo

	Reclock("CNL",.T.)
		CNL->CNL_FILIAL	:= 	xFilial('CNL')
		CNL->CNL_CODIGO	:= 	cRet
		CNL->CNL_DESCRI	:= 	'__MIGRAÇAO_V12'
		CNL->CNL_LMTAVS	:= 0
		CNL->CNL_MEDEVE	:= '0'
		CNL->CNL_MEDAUT	:= '0'
		CNL->CNL_CTRFIX	:= '0'
		CNL->CNL_VLRPRV	:= '0'
		CNL->CNL_CROCTB	:= '0'
		CNL->CNL_CROFIS	:= '0'
		CNL->CNL_TPLMT	:= '0'
		CNL->CNL_TPMULT	:= '0'
		CNL->CNL_MULMAN	:= '0'
		CNL->CNL_LMTMED	:= 0
		CNL->CNL_CRALM	:= '0'
		CNL->CNL_CREAJM	:= '0'
	CNL->(MsUnLock())
EndIf

(cAliasCNL)->(dbCloseArea())
FWRestRows(aRows)
RestArea(aArea)
Return cRet

//====================================================================================================================
/*/{Protheus.doc} MigPedTit
Ajustes para preenchimento dos campos PEDTIT na versão 12.

@author israel.escorizza
@since 29/09/2017
@version V12.1.17
/*/
//====================================================================================================================
Function MigPedTit()
Local aArea		:= GetArea()
Local aAreaCN1	:= CN1->(GetArea())
Local aAreaCNB	:= CNB->(GetArea())
Local aAreaCNE  := CNE->(GetArea())
Local lCtrMed	:= .F.
Local lNaoVaz	:= .F.

Local cQuery	:= ""
Local cAliasCNB	:= ""
Local cAliasCNE	:= ""
Local cModoCN1	:=	FWModeAccess("CN1",3)

dbSelectArea("CN1")
lCtrMed := CN1->(FieldPos("CN1_CTRMED")) > 0

//- Realiza Ajustes para tabela CNB -------------------------------------
cQuery := "	SELECT	"
cQuery += "	CNB.R_E_C_N_O_ As CNBRECNO	"

If lCtrMed
	cQuery += "	,CN1.CN1_CTRMED			"
EndIf

cQuery += "	FROM " + RetSqlName('CNB') + " CNB	"

If lCtrMed
	cQuery += "	JOIN " + RetSqlName('CN9') + " CN9 ON "
	cQuery += "	CN9.CN9_FILIAL = CNB.CNB_FILIAL AND	"
	cQuery += "	CN9.CN9_NUMERO = CNB.CNB_CONTRA AND	"
	cQuery += "	CN9.CN9_REVISA = CNB.CNB_REVISA AND	"
	cQuery += "	CN9.D_E_L_E_T_ = ' '"
	cQuery += "	JOIN " + RetSqlName('CN1') + " CN1 ON "
	If cModoCN1 == "E"
		cQuery += "	CN1.CN1_FILIAL = CN9.CN9_FILIAL AND	"
		cQuery += "	CN1.CN1_CODIGO = CN9.CN9_TPCTO 	AND	"
		cQuery += "	CN1.D_E_L_E_T_ = ' '"
	Else
		cQuery += "	CN1.CN1_CODIGO = CN9.CN9_TPCTO 	AND	"
		cQuery += "	CN1.D_E_L_E_T_ = ' '"
	EndIf
EndIf

cQuery += "	WHERE "
cQuery += "	CNB.CNB_PEDTIT = ' ' AND"
cQuery += "	CNB.D_E_L_E_T_ = ' ' "

cAliasCNB := GetNextAlias()
cQuery 	  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAliasCNB,.T.,.T.)

While !(cAliasCNB)->(EOF())
	lNaoVaz := lCtrMed .And. !Empty((cAliasCNB)->CN1_CTRMED)

	CNB->(dbGoTo((cAliasCNB)->CNBRECNO))
	RecLock("CNB",.F.)
	CNB->CNB_PEDTIT := Iif(lNaoVaz,(cAliasCNB)->CN1_CTRMED,'1')
	CNB->(MsUnLock())
	(cAliasCNB)->(dbSkip())
End
(cAliasCNB)->(dbCloseArea())

//- Realiza Ajustes para tabela CNE -------------------------------------
cQuery := "	SELECT	"
cQuery += "	CNE.R_E_C_N_O_ As CNERECNO	"

If lCtrMed
	cQuery += "	,CN1.CN1_CTRMED			"
EndIf

cQuery += "	FROM " + RetSqlName('CNE') + " CNE	"

If lCtrMed
	cQuery += "	JOIN " + RetSqlName('CND') + " CND ON "
	cQuery += " CND.CND_NUMMED = CNE.CNE_NUMMED AND "
	cQuery += "	CND.CND_FILIAL = CNE.CNE_FILIAL AND	"
	cQuery += "	CND.CND_CONTRA = CNE.CNE_CONTRA AND	"
	cQuery += "	CND.CND_REVISA = CNE.CNE_REVISA AND	"
	cQuery += "	CND.D_E_L_E_T_ = ' '"

	cQuery += "	JOIN " + RetSqlName('CN9') + " CN9 ON "
	cQuery += "	(CN9.CN9_FILIAL = CND.CND_FILCTR OR CN9.CN9_FILIAL = CND.CND_FILIAL) AND"
	cQuery += "	CN9.CN9_NUMERO = CND.CND_CONTRA AND	"
	cQuery += "	CN9.CN9_REVISA = CND.CND_REVISA AND	"
	cQuery += "	CN9.D_E_L_E_T_ = ' '"

	cQuery += "	JOIN " + RetSqlName('CN1') + " CN1 ON "
	If cModoCN1 == "E"
		cQuery += "	CN1.CN1_FILIAL = CN9.CN9_FILIAL AND	"
		cQuery += "	CN1.CN1_CODIGO = CN9.CN9_TPCTO 	AND	"
		cQuery += "	CN1.D_E_L_E_T_ = ' '"
	Else
		cQuery += "	CN1.CN1_CODIGO = CN9.CN9_TPCTO 	AND	"
		cQuery += "	CN1.D_E_L_E_T_ = ' '"
	EndIf
EndIf

cQuery += "	WHERE "
cQuery += "	CNE.CNE_PEDTIT = ' ' AND"
cQuery += "	CNE.D_E_L_E_T_ = ' ' "

cAliasCNE := GetNextAlias()
cQuery 	  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cAliasCNE,.T.,.T.)

While !(cAliasCNE)->(EOF())
	lNaoVaz := lCtrMed .And. !Empty((cAliasCNE)->CN1_CTRMED)

	CNE->(dbGoTo((cAliasCNE)->CNERECNO))
	RecLock("CNE",.F.)
	CNE->CNE_PEDTIT := Iif(lNaoVaz,(cAliasCNE)->CN1_CTRMED,'1')
	CNE->(MsUnLock())
	(cAliasCNE)->(dbSkip())
End
(cAliasCNE)->(dbCloseArea())


PutMV("MV_CNENCME","1")
RestArea(aAreaCNE)
RestArea(aAreaCNB)
RestArea(aAreaCN1)
RestArea(aArea)
Return

//====================================================================================================================
/*/{Protheus.doc} GCTAjuRea
Processa o ajuste dos campos CN1_CREALM e CN1_CREAJM de acordo com os parametros MV_CNREALM e MV_CNREAJM descontinuados

@author israel.escorizza
@since 25/10/2017
@version V12.1.17
/*/
//====================================================================================================================
Function GCTAjuRea()
Local aArea		:= GetArea()
Local aAreaCN1	:= CN1->(GetArea())
Local aAreaCNL	:= CNL->(GetArea())

Local cValReal	:= IIf(SuperGetMv("MV_CNREALM",.F.,"S") == "S",'1','2')
Local cValReaj	:= IIf(SuperGetMv("MV_CNREAJM",.F.,"S") == "S",'1','2')
Local cAliasCN1	:= GetNextAlias()
Local cAliasCNL	:= GetNextAlias()

//- Tratativa para tabela CN1 - Tipos de Contratos
BeginSQL Alias cAliasCN1
SELECT 	CN1.R_E_C_N_O_ CN1RECNO

FROM 	%Table:CN1% CN1

WHERE 	CN1.CN1_FILIAL = %xFilial:CN1% AND
		(CN1.CN1_CREALM = '' OR  CN1.CN1_CREAJM = '') AND
		CN1.%NotDel%
EndSQL

While !(cAliasCN1)->(EOF())
	CN1->(MsGoTo((cAliasCN1)->CN1RECNO))
	If RecLock("CN1",.F.)
		CN1->CN1_CREALM := cValReal
		CN1->CN1_CREAJM := cValReaj
		CN1->(MsUnLock())
	EndIf
	(cAliasCN1)->(dbSkip())
End
(cAliasCN1)->(dbCloseArea())

//- Tratativa para tabela CNL - Tipos de Planilha
BeginSQL Alias cAliasCNL
SELECT 	CNL.R_E_C_N_O_ CNLRECNO

FROM 	%Table:CNL% CNL

WHERE 	CNL.CNL_FILIAL = %xFilial:CNL% AND
		(CNL.CNL_CRALM = '' OR  CNL.CNL_CREAJM = '') AND
		CNL.%NotDel%
EndSQL

While !(cAliasCNL)->(EOF())
	CNL->(MsGoTo((cAliasCNL)->CNLRECNO))
	If RecLock("CNL",.F.)
		CNL->CNL_CRALM  := '0'
		CNL->CNL_CREAJM := '0'
		CNL->(MsUnLock())
	EndIf
	(cAliasCNL)->(dbSkip())
End
(cAliasCNL)->(dbCloseArea())

RestArea(aAreaCNL)
RestArea(aAreaCN1)
RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc}AjustaAC9
Corrige campo AC9_XXX retirando o numero da revisão da chave.

@author janaina.jesus
@since 12/04/2018
@version 12.1.021
/*/
//-------------------------------------------------------------------
Function AjustaAC9()
Local nAntes 	   := TamSX3("CND_FILIAL")[1] + TamSX3("CND_CONTRA")[1]
Local nDepois	   := nAntes + TamSX3("CND_REVISA")[1] + 1 
Local cAliasQry  := GetNextAlias()	
Local aArea	   := GetArea()
Local cChave

BeginSQL Alias cAliasQry
	SELECT	AC9.R_E_C_N_O_ AC9_RECNO
	FROM 	%Table:AC9% AC9
	WHERE 	AC9.AC9_ENTIDA = 'CND' AND
			AC9.%NotDel%
EndSQL

dbSelectArea("AC9")
While !(cAliasQry)->(Eof())
	dbGoTo((cAliasQry)->AC9_RECNO)
		
	cChave     := Alltrim(AC9_CODENT)
				
	If Len(cChave) == 32		
		RecLock("AC9",.F.)
		AC9_CODENT := SubStr(AC9_CODENT,1,nAntes) + SubStr(AC9_CODENT,nDepois,Len(AC9_CODENT)) 
		MsUnlock()
	EndIf
		
	(cAliasQry)->(dbSkip())
EndDo
	
RestArea(aArea)

Return Nil

//====================================================================================================================
/*/{Protheus.doc} GctAjustE2()
Processa o ajuste do campo E2_MEDNUME com o numero da medição geradora do titulo 

@author israel.escorizza
@since 17/05/2018
@version V12.1.21
/*/
//====================================================================================================================
Function GctAjustE2()
Local aArea		:= GetArea()
Local aAreaSE2	:= SE2->(GetArea())
Local cAliasQry := GetNextAlias()	

BeginSQL Alias cAliasQry
	SELECT 
	SE2.R_E_C_N_O_ AS E2_RECNO,
	CXJ.CXJ_NUMMED

	FROM 
	%Table:CXJ% CXJ JOIN 
	%Table:SE2% SE2 
	
	ON
	SE2.E2_FILIAL	= CXJ.CXJ_FILIAL	AND
	SE2.E2_NUM		= CXJ.CXJ_NUMTIT	AND	
	SE2.E2_MDPLANI	= CXJ.CXJ_NUMPLA	AND
	SE2.E2_MEDNUME	= ''				AND
	SE2.%NotDel%

	WHERE 
	CXJ.CXJ_NUMTIT != ''	AND
	CXJ.%NotDel%	
EndSQL

dbSelectArea("SE2")
While !(cAliasQry)->(Eof())
	dbGoTo((cAliasQry)->E2_RECNO)
	
	RecLock("SE2",.F.)
	SE2->E2_MEDNUME := (cAliasQry)->CXJ_NUMMED
	MsUnlock()
		
	(cAliasQry)->(dbSkip())
EndDo
(cAliasQry)->(dbCloseArea())

RestArea(aAreaSE2)
RestArea(aArea)
Return

//====================================================================================================================
/*/{Protheus.doc} AjustaMnt()
Funcao para realizar os ajustes de manutenção do release corrente 

@author jose.delmondes
@since 22/05/2018
@version 1.0
/*/
//====================================================================================================================
Function AjustaMnt()

SX3->(DbSetOrder(2))

If SX3->(DbSeek("CXN_PARCEL")) 
	Reclock("SX3",.F.)
	SX3->X3_VISUAL	:= 'A'
	SX3->X3_VALID	:= 'CN121VParc()'                                                                                                               
	SX3->(MsUnlock())
Endif

return

//====================================================================================================================
/*/{Protheus.doc} GctAjustCXN()
Funcao para ajustar o campo CXN_ZERO com o inicializador padrão

@author janaina.jesus
@since 17/07/2018
@version 1.0
/*/
//====================================================================================================================
Function GctAjustCXN()
	Local aArea		:= GetArea()
	Local aAreaCXN	:= CXN->(GetArea())
	
	dbSelectArea('CXN')
	CXN->(dbSetOrder(1)) //CXN_FILIAL+CXN_CONTRA+CXN_REVISA+CXN_NUMMED+CXN_NUMPLA
	
	While !CXN->(EOF())
		If Empty(CXN->CXN_ZERO) .And. RecLock("CXN",.F.)
			CXN->CXN_ZERO := "0"
			CXN->(MsUnLock())
		EndIf
		CXN->(dbSkip())
	EndDo
	
	RestArea(aAreaCXN)
	RestArea(aArea)
Return Nil

/*/{Protheus.doc} GCT025Ajus()
Ajuste para release 12.1.25

@param cMode, Modo de execução. 1=Por grupo de empresas / 2=Por grupo de empresas + filial (filial completa)
@return NIL

@author pedro.alencar
@since 14/03/2019
@version 12.1.25
/*/
Function GCT025Ajus( cMode )
	Default cMode := ""
	
	Conout("[RUP_GCT] Início da EXECUCAO Release 25...")	
	
	If cMode == "1" //Por grupo
		
		//Ajusta o campo de controle de alçadas, com base no antigo campo CN1_CTRAPR
		AjustaCN1()
		
		//Ajusta o inicializador padrão e o modo de edição do campo CN1_ALCCTR
		SX3->( dbSetOrder( 2 ) ) //X3_CAMPO	
		If SX3->( dbSeek("CN1_ALCCTR") )
			If AllTrim(SX3->X3_RELACAO) <> "3" .Or. AllTrim(SX3->X3_WHEN) <> "" 
				Reclock( "SX3", .F. )
				SX3->X3_RELACAO := "3"
				SX3->X3_WHEN := ""
				SX3->( MsUnlock() )
			EndIf
		Endif
				
	EndIf
	
	Conout("[RUP_GCT] fim da EXECUCAO.")
	
Return Nil
