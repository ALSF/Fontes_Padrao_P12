#Include 'Protheus.ch'

//---------------------------------------------------------------------------------------
/*/ {Protheus.doc} CFGX049B10()
Função que irá tratar as possiveis alterações pelo cliente no arquivo de configuração.

@author	Francisco Oliveira
@since		17/10/2017
@version	P12
@Function  CFGX049B10()
@Return	Array com as informações para alteração
@param
@Obs
/*/
//---------------------------------------------------------------------------------------

Function CFGX049B10(cBanco As Character, cTipo As Character, cCart As Character) As Array

	Local aRetDet	As Array
	Local cA2Nome	As Character
	Local cA1Nome	As Character
	Local cE1Datas	As Character
	Local cE2Datas	As Character
	Local cE1Valor	As Character
	Local cE2Valor	As Character
	Local cE1ValJr	As Character
	Local cE2ValJr	As Character
	Local cE1ValDc	As Character
	Local cE2ValDc	As Character
	Local cDataRem	As Character
	Local cSeqLote	As Character
	Local cSomVal	As Character
	Local cYesNo	As Character
	Local cTipMov	As Character
	Local cInsMov 	As Character
	Local cCodCmp	As Character
	Local cAvisoF	As Character
	Local cCodJur	As Character
	Local cCodDesc	As Character
	Local cTipServ	As Character
	Local cCodMov	As Character
	Local cCodProt	As Character
	Local cCodDev	As Character
	Local cFormLan	As Character
	Local cDataRet	As Character
	Local cValores	As Character
	Local cJuros	As Character
	Local cDescont	As Character
	Local cDespBco	As Character
	Local cOcorren	As Character
	Local cTitNosN	As Character
	Local cSegment	As Character
	Local cCGC		As Character
	Local cCodBar	As Character

	Default cBanco	:= ""
	Default cTipo	:= ""
	Default cCart	:= ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis para arquivos REMESSA:																							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cA2Nome		:= '{\"A2_NREDUZ\",\"A2_NOME\"}'
	cA1Nome		:= '{\"A1_NREDUZ\",\"A1_NOME\"}'
	cE1Datas	:= '{\"E1_VENCTO\",\"E1_EMISSAO\",\"E1_VENCREA\"}'
	cE2Datas	:= '{\"E2_VENCTO\",\"E2_EMISSAO\",\"E2_VENCREA\"}'
	cE1Valor	:= '{\"E1_SALDO\",\"E1_VALOR\",\"E1_VLCRUZ\"}'
	cE2Valor	:= '{\"E2_SALDO\",\"E2_VALOR\",\"E2_VLCRUZ\"}'
	cE1ValJr	:= '{\"E1_MULTA\",\"E1_SDDACRE\",\"E1_JUROS\"}'
	cE2ValJr	:= '{\"E2_MULTA\",\"E2_SDDACRE\",\"E2_JUROS\"}'
	cE1ValDc	:= '{\"E1_DESCONT\",\"E1_SDDECRE\"}'
	cE2ValDc	:= '{\"E2_DESCONT\",\"E2_SDDECRE\"}'
	cDataRem	:= '{\"DATE()\",\"DDATABASE\"}'
	cSeqLote	:= '{\"INCREMENTA()\",\"INCREMENTA()-1\",\"QTDTITLOTE()\",\"FNLINLOTE()\"}'
	cSomVal		:= '{\"SOMAVALOR()\",\"SOMAVLOT1()\"}'
	cYesNo		:= '{\"S\",\"N\"}
	cTipMov		:= ''
	cInsMov 	:= '{\"00\",\"09\",\"10\",\"11\",\"14\",\"33\"}'
	cCodCmp		:= '{\"000\",\"018\",\"810\",\"700\",\"888\"}'
	cAvisoF		:= '{\"0\",\"2\",\"5\",\"6\"}'
	cCodJur		:= '{\"1\",\"2\",\"3\",\"4\",\"5\",\"6\"}'
	cCodDesc	:= '{\"0\",\"1\",\"2\",\"3\",\"4\"}'
	cTipServ	:= '{\"03\",\"10\",\"14\",\"20\",\"22\",\"29\",\"50\",\"60\",\"70\",\"75\",\"80\",\"90\",\"98\"}'
	cCodMov		:= '{\"01\",\"02\",\"03\",\"04\",\"05\",\"06\",\"07\",\"08\",\"09\",\"10\",\"11\",\"18\",\"31\",\"98\"}'
	cCodProt	:= '{\"0\",\"1\",\"2\",\"3\",\"9\"}'
	cCodDev		:= '{\"1\",\"2\",\"3\"}'
	cFormLan	:= '{\"01\",\"03\",\"05\",\"10\",\"20\",\"30\",\"31\",\"35\",\"11\",\"16\",\"17\",\"18\",\"22\",\"23\",\"24\",\"25\",\"26\",\"27\"}'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis para arquivos RETORNO:																							³
	//³ TITULO      | ESPECIE     | OCORRENCIA  | DATA        | VALOR       | DESPESA      | DESCONTO    | ABATIMENTO  | JUROS      ³
	//³ MULTA       | IOF         | DATACREDITO | MOTIVO      | NOSSONUMERO | RESERVADO    | SEGMENTO    | AUTENTICACAO       		³																				³
	//³ CGC         | CGCH        | CODBAR      | SEGJ52      | OUTROSCREDITOS               										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDataRet	:= '{\"ZERAR POSICAO\",\"DATA\",\"DATACREDITO\"}'
	cValores	:= '{\"ZERAR POSICAO\",\"VALOR\"}'
	cJuros		:= '{\"ZERAR POSICAO\",\"JUROS\",\"MULTA\"}'
	cDescont	:= '{\"ZERAR POSICAO\",\"DESCONTO\",\"ABATIMENTO\"}'
	cDespBco	:= '{\"ZERAR POSICAO\",\"DESPESA\",\"IOF\",\"OUTROSCREDITOS\"}'
	cOcorren	:= '{\"ZERAR POSICAO\",\"OCORRENCIA\",\"RESERVADO\"}'
	cTitNosN	:= '{\"ZERAR POSICAO\",\"TITULO\",\"ESPECIE\",\"NOSSONUMERO\",\"AUTENTICACAO\",\"MOTIVO\"}'
	cSegment	:= '{\"ZERAR POSICAO\",\"SEGMENTO\",\"SEGJ52\"}'
	cCGC		:= '{\"ZERAR POSICAO\",\"CGC\",\"CGCH\"}'
	cCodBar		:= '{\"ZERAR POSICAO\",\"CODBAR\"}'

	aRetDet		:= {}

	Do Case
		//BRASIL
		Case cBanco == "001"
			If cCart == "PAG" .And. cTipo == "REM" //BRASIL - PAGAR - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','044','073',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','1','D','1','094','101',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','145','152',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','H',' ','103','142',' ',' '})
				aAdd(aRetDet,{'2','2','H',' ','103','142',' ',' '})

			ElseIf cCart == "PAG" .And. cTipo == "RET" //BRASIL - PAGAR - RETORNO
				AADD(aRetDet,{'2','1','D','1','094','101',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','120','134',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','135','154',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','155','162',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','163','177',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','231','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','128','135',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','136','150',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','151','165',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','166','180',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','181','195',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','196','210',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','211','225',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','2','233','240',cOcorren, cOcorren})

			ElseIf cCart == "REC" .And. cTipo == "REM" //BRASIL - RECEBER - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','078','085',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','1','110','117',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','2','034','073',cA1Nome , cA1Nome })
				aAdd(aRetDet,{'2','1','H',' ','192','199',cDataRem, cDataRem})

			ElseIf cCart == "REC" .And. cTipo == "RET" //BRASIL - RECEBER - RETORNO
				AADD(aRetDet,{'2','1','D','1','038','057',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','059','073',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','074','081',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','082','096',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','106','130',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','224','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','018','032',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','033','047',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','048','062',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','063','077',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','078','092',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','093','107',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','123','137',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','138','145',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','146','153',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','154','157',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','158','165',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','166','180',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','214','233',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','2','234','240',cOcorren, cOcorren})
			Endif

		//SANTANDER
		Case cBanco == "033"

			cTipMov := '{\"0\",\"3\",\"5\",\"8\",\"9\"}'

			If cCart == "PAG" .And. cTipo == "REM" //SANTANDER - PAGAR - REMESSA
				aAdd(aRetDet,{'2','1','D','1','009','013',cSeqLote, cSeqLote})
				aAdd(aRetDet,{'2','1','D','1','015','015',cTipMov , cTipMov })
				aAdd(aRetDet,{'2','1','D','1','016','017',cInsMov , cInsMov })
				aAdd(aRetDet,{'2','1','D','1','018','020',cCodCmp , cCodCmp })
				aAdd(aRetDet,{'2','1','D','1','044','073',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','1','D','1','094','101',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','1','120','134',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','1','D','1','163','177',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','1','D','1','230','230',cAvisoF , cAvisoF })
				aAdd(aRetDet,{'2','1','D','2','009','013',cSeqLote, cSeqLote})
				aAdd(aRetDet,{'2','1','D','2','128','135',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','2','136','150',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','1','D','2','151','165',cE2ValDc, cE2ValDc})
				aAdd(aRetDet,{'2','1','D','2','196','210',cE2ValJr, cE2ValJr})
				aAdd(aRetDet,{'2','1','D','2','232','232',cYesNo  , cYesNo  })
				aAdd(aRetDet,{'2','2','D','1','009','013',cSeqLote, cSeqLote})
				aAdd(aRetDet,{'2','2','D','1','015','015',cTipMov , cTipMov })
				aAdd(aRetDet,{'2','2','D','1','016','017',cInsMov , cInsMov })
				aAdd(aRetDet,{'2','2','D','1','062','091',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','2','D','1','092','099',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','100','114',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','2','D','1','115','129',cE2ValDc, cE2ValDc})
				aAdd(aRetDet,{'2','2','D','1','130','144',cE2ValJr, cE2ValJr})
				aAdd(aRetDet,{'2','2','D','1','145','152',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','153','167',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
			//aAdd(aRetDet,{'2','1','H',' ','000','000',VARIAVEL, VARIAVEL})
				aAdd(aRetDet,{'2','2','H',' ','010','011',cTipServ, cTipServ})
				aAdd(aRetDet,{'2','2','H',' ','012','013',cFormLan, cFormLan})
			//aAdd(aRetDet,{'2','0','T',' ','000','000',VARIAVEL, VARIAVEL})
				aAdd(aRetDet,{'2','1','T',' ','024','041',cSomVal , cSomVal })
				aAdd(aRetDet,{'2','2','T',' ','024','041',cSomVal , cSomVal })

			ElseIf cCart == "PAG" .And. cTipo == "RET" //SANTANDER - PAGAR - RETORNO
				AADD(aRetDet,{'2','1','D','1','094','101',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','120','134',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','135','154',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','155','162',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','163','177',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','231','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','128','135',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','136','150',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','151','165',cDescont, cDescont})
				AADD(aRetDet,{'2','1','D','2','166','180',cDescont, cDescont})
				AADD(aRetDet,{'2','1','D','2','181','195',cJuros  , cJuros  })
				AADD(aRetDet,{'2','1','D','2','196','210',cJuros  , cJuros  })
				AADD(aRetDet,{'2','2','D','1','092','099',cDataRet, cDataRet})
				AADD(aRetDet,{'2','2','D','1','100','114',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','115','129',cDescont, cDescont})
				AADD(aRetDet,{'2','2','D','1','130','144',cJuros  , cJuros  })
				AADD(aRetDet,{'2','2','D','1','145','152',cDataRet, cDataRet})
				AADD(aRetDet,{'2','2','D','1','153','167',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','183','202',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','2','D','1','203','222',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','2','D','1','231','240',cOcorren, cOcorren})

			ElseIf cCart == "REC" .And. cTipo == "REM" //SANTANDER - RECEBER - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','H',' ','192','199',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','078','085',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','1','086','100',cE1Valor, cE1Valor})
				aAdd(aRetDet,{'2','1','D','1','110','117',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','1','118','118',cCodJur , cCodJur })
				aAdd(aRetDet,{'2','1','D','1','142','142',cCodDesc, cCodDesc})
				aAdd(aRetDet,{'2','1','D','1','221','221',cCodProt, cCodProt})
				aAdd(aRetDet,{'2','1','D','1','224','224',cCodDev , cCodDev })
				aAdd(aRetDet,{'2','1','D','2','009','013',cSeqLote, cSeqLote})
				aAdd(aRetDet,{'2','1','D','2','016','017',cCodMov , cCodMov })
				aAdd(aRetDet,{'2','1','D','2','034','073',cA1Nome , cA1Nome })
				aAdd(aRetDet,{'2','1','D','2','170','209',cA1Nome , cA1Nome })
				aAdd(aRetDet,{'2','1','D','3','009','013',cSeqLote, cSeqLote})
				aAdd(aRetDet,{'2','1','D','3','016','017',cCodMov , cCodMov })
				aAdd(aRetDet,{'2','1','D','3','118','118',cCodJur , cCodJur })
				aAdd(aRetDet,{'2','1','D','3','066','066','{\"1\",\"2\"}', '{\"1\",\"2\"}'})
				aAdd(aRetDet,{'2','1','D','3','075','089',cE1ValJr, cE1ValJr})
			//aAdd(aRetDet,{'2','0','T',' ','000','000',VARIAVEL, VARIAVEL})

			ElseIf cCart == "REC" .And. cTipo == "RET" //SANTANDER - RECEBER - RETORNO
				AADD(aRetDet,{'2','1','D','1','041','053',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','055','069',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','070','077',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','078','092',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','209','218',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','1','219','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','018','032',cJuros  , cJuros  })
				AADD(aRetDet,{'2','1','D','2','033','047',cDescont, cDescont})
				AADD(aRetDet,{'2','1','D','2','048','062',cDescont, cDescont})
				AADD(aRetDet,{'2','1','D','2','063','077',cDespBco, cDespBco})
				AADD(aRetDet,{'2','1','D','2','078','092',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','093','107',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','108','122',cDespBco, cDespBco})
				AADD(aRetDet,{'2','1','D','2','123','137',cDespBco, cDespBco})
				AADD(aRetDet,{'2','1','D','2','138','145',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','146','153',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','214','240',cOcorren, cOcorren})
			Endif

		//CAIXA ECONOMICA
		Case cBanco == "104"
			If cCart == "PAG" .And. cTipo == "REM" //CAIXA - PAGAR - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','044','073',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','1','D','1','094','101',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','2','128','135',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','3','062','091',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','1','D','3','092','099',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','3','145','152',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','4','036','075',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','1','D','4','148','187',cA2Nome , cA2Nome })

			ElseIf cCart == "PAG" .And. cTipo == "RET" //CAIXA - PAGAR - RETORNO
				AADD(aRetDet,{'2','1','D','1','094','101',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','120','134',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','135','143',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','155','162',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','163','177',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','128','135',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','136','150',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','151','165',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','166','180',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','181','195',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','196','210',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','226','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','3','027','036',cValores, cValores})
				AADD(aRetDet,{'2','1','D','3','092','099',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','3','100','114',cValores, cValores})
				AADD(aRetDet,{'2','1','D','3','115','129',cValores, cValores})
				AADD(aRetDet,{'2','1','D','3','130','144',cValores, cValores})
				AADD(aRetDet,{'2','1','D','3','145','152',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','3','153','167',cValores, cValores})
				AADD(aRetDet,{'2','1','D','3','231','240',cOcorren, cOcorren})

			ElseIf cCart == "REC" .And. cTipo == "REM" //CAIXA - RECEBER - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','078','085',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','1','110','117',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','2','034','073',cA1Nome , cA1Nome })
				aAdd(aRetDet,{'2','1','D','3','034','073',cA1Nome , cA1Nome })
				aAdd(aRetDet,{'2','1','D','3','193','207',cE1Valor, cE1Valor})
				aAdd(aRetDet,{'2','1','H',' ','192','199',cDataRem, cDataRem})

			ElseIf cCart == "REC" .And. cTipo == "RET" //CAIXA - RECEBER - RETORNO
				AADD(aRetDet,{'2','1','D','1','042','056',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','059','069',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','074','081',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','082','096',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','224','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','018','032',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','033','047',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','048','062',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','063','077',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','078','092',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','093','107',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','123','137',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','138','145',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','146','153',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','158','165',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','234','240',cOcorren, cOcorren})
			Endif

		//BRADESCO
		Case cBanco == "237"

			cTipMov := '{\"0\",\"1\",\"3\",\"5\",\"7\",\"9\"}'

			If cCart == "PAG" .And. cTipo == "REM" //BRADESCO - PAGAR - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','009','013',cSeqLote, cSeqLote})
				aAdd(aRetDet,{'2','1','D','1','015','015',cTipMov , cTipMov })
				aAdd(aRetDet,{'2','1','D','1','044','073',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','1','D','1','094','101',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','2','009','013',cSeqLote, cSeqLote})
				aAdd(aRetDet,{'2','1','D','2','128','135',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','2','136','150',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','2','D','1','015','015',cTipMov , cTipMov })
				aAdd(aRetDet,{'2','2','D','1','062','091',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','2','D','1','092','099',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','100','114',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','2','D','1','115','129',cE2ValDc, cE2ValDc})
				aAdd(aRetDet,{'2','2','D','1','130','144',cE2ValJr, cE2ValJr})
				aAdd(aRetDet,{'2','2','D','1','145','152',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','153','167',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','2','D','2','092','131',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','2','D','2','148','187',cA2Nome , cA2Nome })

			ElseIf cCart == "PAG" .And. cTipo == "RET" //BRADESCO - PAGAR - RETORNO
				AADD(aRetDet,{'2','1','D','1','094','101',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','120','134',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','135','154',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','155','162',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','163','177',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','231','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','128','135',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','136','150',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','151','165',cDescont, cDescont})
				AADD(aRetDet,{'2','1','D','2','166','180',cDescont, cDescont})
				AADD(aRetDet,{'2','1','D','2','181','195',cJuros  , cJuros  })
				AADD(aRetDet,{'2','1','D','2','196','210',cJuros  , cJuros  })
				AADD(aRetDet,{'2','2','D','1','092','099',cDataRet, cDataRet})
				AADD(aRetDet,{'2','2','D','1','100','114',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','115','129',cDescont, cDescont})
				AADD(aRetDet,{'2','2','D','1','130','144',cJuros  , cJuros  })
				AADD(aRetDet,{'2','2','D','1','145','152',cDataRet, cDataRet})
				AADD(aRetDet,{'2','2','D','1','153','167',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','183','202',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','2','D','1','231','240',cOcorren, cOcorren})

			ElseIf cCart == "REC" .And. cTipo == "REM" //BRADESCO - RECEBER - REMESSA
				aAdd(aRetDet,{'2','1','H',' ','192','199',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','078','085',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','1','086','100',cE1Valor, cE1Valor})
				aAdd(aRetDet,{'2','1','D','1','110','117',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','2','034','073',cA1Nome , cA1Nome })
				aAdd(aRetDet,{'2','1','D','2','170','209',cA1Nome , cA1Nome })
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})

			ElseIf cCart == "REC" .And. cTipo == "RET" //BRADESCO - RECEBER - RETORNO
				AADD(aRetDet,{'2','1','D','1','074','081',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','082','096',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','018','032',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','033','047',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','048','062',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','063','077',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','078','092',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','093','107',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','123','137',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','138','145',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','146','153',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','158','165',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','166','180',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','214','233',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','2','234','240',cOcorren, cOcorren})
			Endif

		//ITAU
		Case cBanco == "341"
			If cCart == "PAG" .And. cTipo == "REM" //ITAU - PAGAR - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','D','1','044','073',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','1','D','1','094','101',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','1','D','1','120','134',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','1','D','1','155','162',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','062','091',cA2Nome , cA2Nome })
				aAdd(aRetDet,{'2','2','D','1','092','099',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','100','114',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','2','D','1','145','152',cE2Datas, cE2Datas})
				aAdd(aRetDet,{'2','2','D','1','153','167',cE2Valor, cE2Valor})
				aAdd(aRetDet,{'2','2','D','2','092','131',cA2Nome , cA2Nome })

			ElseIf cCart == "PAG" .And. cTipo == "RET" //ITAU - PAGAR  - RETRONO
				AADD(aRetDet,{'2','1','D','1','094','101',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','120','134',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','135','149',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','155','162',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','163','177',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','198','203',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','1','231','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','1','D','2','231','240',cOcorren, cOcorren})
				AADD(aRetDet,{'2','2','D','1','092','099',cDataRet, cDataRet})
				AADD(aRetDet,{'2','2','D','1','100','114',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','115','129',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','130','144',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','145','152',cDataRet, cDataRet})
				AADD(aRetDet,{'2','2','D','1','153','167',cValores, cValores})
				AADD(aRetDet,{'2','2','D','1','183','202',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','2','D','1','231','240',cOcorren, cOcorren})

			ElseIf cCart == "REC" .And. cTipo == "REM" //ITAU - RECEBER - REMESSA
				aAdd(aRetDet,{'2','0','H',' ','144','151',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','H',' ','192','199',cDataRem, cDataRem})
				aAdd(aRetDet,{'2','1','H',' ','200','207',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','1','078','085',cE1Datas, cE1Datas})
				aAdd(aRetDet,{'2','1','D','1','086','100',cE1Valor, cE1Valor})
				aAdd(aRetDet,{'2','1','D','1','110','117',cE1Datas, cE1Datas})

			ElseIf cCart == "REC" .And. cTipo == "RET" //ITAU - RECEBER - RETORNO
				AADD(aRetDet,{'2','1','D','1','074','081',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','1','082','096',cValores, cValores})
				AADD(aRetDet,{'2','1','D','1','106','130',cTitNosN, cTitNosN})
				AADD(aRetDet,{'2','1','D','2','018','032',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','033','047',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','048','062',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','063','077',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','078','092',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','093','107',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','123','137',cValores, cValores})
				AADD(aRetDet,{'2','1','D','2','146','153',cDataRet, cDataRet})
				AADD(aRetDet,{'2','1','D','2','234','240',cOcorren, cOcorren})
			Endif
	End Case

Return aRetDet
