#include "protheus.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiCode.ch"
#include "CNTA290.ch"


#DEFINE DEF_SVIGE "05" //Vigente

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CNTA290  ³ Autor ³                       ³ Data ³24.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ JOB para apropriação do cronograma contábil                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA290(cExp01,cExp02,cExp03)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo da Empresa                                 ³±±
±±³          ³ cExp02 - Codigo da Filial                                  ³±±
±±³          ³ cExp03 - Horario da execicao HH:MM / Intervalo entre as    ³±±
±±³          ³          execucoes                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

// funcao apenas para SCHE() apenas para debugar o fonte SCHED010()
Function CNTA290(aParam)

Private lMsErroAuto := .F.
Private lFail       := .F.
Private cPerg       := "CNTA290"

ConOut("Executando")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a rotina e executada atraves de um JOB   ³
//³ ou pelo menu                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetRemoteType() == -1//Execucao por JOB
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a rotina e executada entre um intervalo  ³
	//³ ou em um horario estabelecido                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcSetType ( 3 )
	wfprepenv(aParam[1] , aParam[2] ,,{"SM0","CT2","CN9","CNW","CNV"})
	
	CHKFILE("SM0")
	DbGoTop()
	CN290Exc(.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
	RESET ENVIRONMENT
	
Else //Execucao por Menu

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//³MV_PAR01 - Periodo De?     										     ³
	//³MV_PAR02 - Periodo Ate?       							           ³
	//³MV_PAR03 - Tipo de Movimento?	                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Pergunte("CNT290")
		Processa( {|| CN290Exc(.F.) } )
	Endif
EndIf



Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN290Exc ³ Autor ³                       ³ Data ³24.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa JOB para apropriação do cronograma contábil        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN290Exc(lExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lExp01 - Executado pelo job                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function CN290Exc(lJob)

Local cArqCtb       := ""
Local cLoteCtb      := ""
Local cNumCron
Local lContinua     :=.T.
Local lDigita       := If(lJob,.F.,If(MV_PAR04=1,.T.,.F.))
Local lAglutina     := If(lJob,.F.,If(MV_PAR05=1,.T.,.F.))
Local nTotalLCtb    := 0
Local dDataini      :=(dDatabase-SuperGetMv("MV_CNTDTIN"))

Private lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do lote contabil                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
If MsSeek(xFilial()+"09GCT")
	cLoteCtb := AllTrim(X5Descri())
Else
	cLoteCtb := "GCT "
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera historico                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTxLog := STR0001+" - "+DTOC(dDataBase)+" - "+time()+CHR(13)+CHR(10)//"Log de execucao "
cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
DbselectArea("CNW")
DbSetOrder(1)

If lContinua
	nStack := GetSX8Len()
	If lJob
		cTxLog +=STR0001+" - " + time()+CHR(13)+CHR(10) //"Gerando apropriação do Cronograma Contabil"
		cTxLog += Replicate("-",128)+CHR(13)+CHR(10)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra parcelas de contratos automaticos ³
	//³ pendentes para a data atual              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cArqTrb	:= CriaTrab( nil, .F. )
	cQuery := "SELECT DISTINCT CNV.*,CNW.* FROM " + RetSQLName("CN9")+ " CN9, "  + RetSQLName("CNV") + " CNV, " + RetSQLName("CNW") + " CNW "
	cQuery += "WHERE "
	cQuery += "CNV.CNV_FILIAL = '"+ xFilial("CNV") +"' AND "
	cQuery += "CNW.CNW_FILIAL = '"+ xFilial("CNW") +"' AND "
	cQuery += "CN9.CN9_FILIAL = '"+ xFilial("CN9") +"' AND "
	
	cQuery += "CNV.CNV_NUMERO = CNW.CNW_NUMERO AND "
	cQuery += "CNV.CNV_REVISA = CNW.CNW_REVISA AND "
   cQuery += "CNV.CNV_CONTRA = CNW.CNW_CONTRA AND "
	cQuery += "CN9.CN9_NUMERO = CNW.CNW_CONTRA AND "
	If lJob
		cQuery += "CNW.CNW_DTPREV >= '"+ dtos(dDataini)  +"' AND "
		cQuery += "CNW.CNW_DTPREV <= '"+ dtos(dDataBase) +"' AND "
	Else
		cQuery += "CNW.CNW_DTPREV >= '"+ dtos(MV_PAR01)  +"' AND "
		cQuery += "CNW.CNW_DTPREV <= '"+ dtos(MV_PAR02)  +"' AND "
	Endif
	cQuery += "CN9.CN9_SITUAC = '"+ DEF_SVIGE +"' AND "
	cQuery += "CNV.CNV_REVISA = CN9.CN9_REVISA  AND "
	cQuery += "CNW.CNW_REVISA = CN9.CN9_REVISA  AND "

	If lJob
		cQuery += "CNW.CNW_FLGAPR in (' ','2') AND "
	Else
		If MV_PAR03=1
			cQuery += "CNW.CNW_FLGAPR in (' ','2') AND "
		ElseIf MV_PAR03=2
			cQuery += "CNW.CNW_FLGAPR = '1' AND "
		Endif
	Endif
	cQuery += "CN9.D_E_L_E_T_ = ' ' AND "
	cQuery += "CNV.D_E_L_E_T_ = ' ' AND "
	cQuery += "CNW.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY CNW.CNW_NUMERO,CNW.CNW_PARCEL"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabecalho da contabilizacao                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cArqTrb)->(Eof())
		If lJob
		  cTxLog += STR0009 + " - "+STR0002 + " - " + time()+CHR(13)+CHR(10)
		Else
			If Aviso(OemToAnsi(STR0009),OemToAnsi(STR0002),{OemToAnsi(STR0010)}) == 1
				lFail:=.F.
			Endif
		Endif
		Return lFail
	Endif
	nHdlPrv :=HeadProva(cLoteCtb,"CNTA290",Subs(cUsuario,7,6),@cArqCtb)
	
	While !(cArqTrb)->(Eof())
		CN9->(dbSetOrder(1))
		CN9->(dbSeek(xFilial("CN9")+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA))

		CNA->(dbSetOrder(1))
		CNA->(dbSeek(xFilial("CNA")+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA+(cArqTrb)->CNV_PLANIL))
	
		lContinua := .T.    
		DbselectArea("CNW")
		DbSetOrder(1)
		If MsSeek(xFilial()+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA+(cArqTrb)->CNW_NUMERO+(cArqTrb)->CNW_PARCEL)
			nTotalLCtb	:= DetProva(nHdlPrv,"693","CNTA290",cLoteCtb)
		Endif
		DbselectArea(cArqTrb)
		cNumCron:=(cArqTrb)->CNW_NUMERO
      if lJob
	      cTxLog += STR0012 +" - "+(cArqTrb)->CNW_CONTRA+" - "+(cArqTrb)->CNW_REVISA+" - "+(cArqTrb)->CNW_NUMERO+" - "+(cArqTrb)->CNW_PARCEL+CHR(13)+CHR(10)
	   Endif 
	   If lJob
	   Endif
		(cArqTrb)->(dbSkip())
		IF nHdlPrv <= 0
		   if !lJob
 			   HELP(" ",1,"SEM_LANC")
 			Endif   
			lCtbOnLine := .F.
		EndIf
		If nHdlPrv > 0
			DbselectArea("CT2")
			// Rodape do lancamento gerando os totais.
			Rodaprova(nHdlPrv,nTotallCtb)
			
			If nTotalLCtb > 0
				cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
			EndIf
			DbselectArea("CNW")
		EndIf
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravando os Flags e Data                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	DbselectArea("CNW") 
  	DbSetOrder(1)

	DbSelectArea(cArqTrb)
	DbGoTop()
	While !(cArqTrb)->(Eof())

  		DbselectArea("CNW") 
  		dbSetOrder(1)
		If MsSeek(xFilial()+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA+(cArqTrb)->CNW_NUMERO+(cArqTrb)->CNW_PARCEL)
			RecLock("CNW",.F.)
			CNW->CNW_FLGAPR := "1"
			CNW->CNW_DTLANC := DDatabase
			CNW->(MsUnLock())
		Endif
		DbSelectArea(cArqTrb)
		(cArqTrb)->(dbSkip())
	EndDo                

	(cArqTrb)->(dbCloseArea())

	If lJob
	  cTxLog += STR0005 +" - " + time()+CHR(13)+CHR(10)
	Else  
	   Aviso(OemToAnsi(STR0009),OemToAnsi(STR0005),{OemToAnsi(STR0010)})
	EndIf
	cTxLog += STR0005 + time()
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa gravacao do arquivo de historico          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MemoWrite(Criatrab(,.f.)+".LOG",cTxLog)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Emite alerta com o log do processamento           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MEnviaMail("041",{cTxLog})

Return lFail

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CN290ESTOR    ³Autor ³Andrews Egas          ³Data³ 25/08/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Estorna apropriação contabil por item da CNW    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/
Function CN290ESTOR(cContra)

Local cArqCtb       := ""
Local cLoteCtb      := ""
Local cNumCron
Local lContinua     :=.T.
Local nTotalLCtb    := 0
Local aArea		:= getArea()
//Local dDataini      :=(dDatabase-SuperGetMv("MV_CNTDTIN"))

Private lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do lote contabil                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
If MsSeek(xFilial()+"09GCT")
	cLoteCtb := AllTrim(X5Descri())
Else
	cLoteCtb := "GCT "
EndIf

DbselectArea("CNW")
DbSetOrder(1)

If lContinua
	nStack := GetSX8Len()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra parcelas de contratos automaticos ³
	//³ pendentes para a data atual              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cArqTrb	:= CriaTrab( nil, .F. )
	cQuery := "SELECT DISTINCT CNV.*,CNW.* FROM " + RetSQLName("CN9")+ " CN9, "  + RetSQLName("CNV") + " CNV, " + RetSQLName("CNW") + " CNW "
	cQuery += "WHERE "
	cQuery += "CNV.CNV_FILIAL = '"+ xFilial("CNV") +"' AND "
	cQuery += "CNW.CNW_FILIAL = '"+ xFilial("CNW") +"' AND "
	cQuery += "CN9.CN9_FILIAL = '"+ xFilial("CN9") +"' AND "
	
	cQuery += "CNV.CNV_NUMERO = CNW.CNW_NUMERO AND "
	cQuery += "CNV.CNV_REVISA = CNW.CNW_REVISA AND "
	cQuery += "CN9_NUMERO = '" + cContra + "'  AND " //Pega o contrato atual para desfazer as apropriações
   	cQuery += "CNV.CNV_CONTRA = CNW.CNW_CONTRA AND "
	cQuery += "CN9.CN9_NUMERO = CNW.CNW_CONTRA AND "

	cQuery += "CN9.CN9_SITUAC = '"+ DEF_SVIGE +"' AND "
	cQuery += "CNV.CNV_REVISA = CN9.CN9_REVISA  AND "
	cQuery += "CNW.CNW_REVISA = CN9.CN9_REVISA  AND "

	cQuery += "CNW.CNW_FLGAPR = '1' AND " // só os que ja foram contabilizados

	cQuery += "CN9.D_E_L_E_T_ = ' ' AND "
	cQuery += "CNV.D_E_L_E_T_ = ' ' AND "
	cQuery += "CNW.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY CNW.CNW_NUMERO,CNW.CNW_PARCEL"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cabecalho da contabilizacao                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(cArqTrb)->(Eof())

		nHdlPrv :=HeadProva(cLoteCtb,"CN290ESTOR",Subs(cUsuario,7,6),@cArqCtb)
		
		While !(cArqTrb)->(Eof())
			CN9->(dbSetOrder(1))
			CN9->(dbSeek(xFilial("CN9")+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA))
	
			CNA->(dbSetOrder(1))
			CNA->(dbSeek(xFilial("CNA")+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA+(cArqTrb)->CNV_PLANIL))
		
			lContinua := .T.    
			DbselectArea("CNW")
			DbSetOrder(1)
			If MsSeek(xFilial()+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA+(cArqTrb)->CNW_NUMERO+(cArqTrb)->CNW_PARCEL)
				nTotalLCtb	:= DetProva(nHdlPrv,"69J","CN290ESTOR",cLoteCtb)
			Endif
			DbselectArea(cArqTrb)
			cNumCron:=(cArqTrb)->CNW_NUMERO
	
			(cArqTrb)->(dbSkip())
			IF nHdlPrv <= 0
	 			   HELP(" ",1,"SEM_LANC")
				lCtbOnLine := .F.
			EndIf
			If nHdlPrv > 0
				DbselectArea("CT2")
				// Rodape do lancamento gerando os totais.
				Rodaprova(nHdlPrv,nTotallCtb)
				
				If nTotalLCtb > 0
					cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,.F.,.F.)
				EndIf
				DbselectArea("CNW")
			EndIf
		EndDo
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravando os Flags e Data                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		DbselectArea("CNW") 
	  	DbSetOrder(1)
	
		DbSelectArea(cArqTrb)
		DbGoTop()
		While !(cArqTrb)->(Eof())
	
	  		DbselectArea("CNW") 
	  		dbSetOrder(1)
			If MsSeek(xFilial()+(cArqTrb)->CNW_CONTRA+(cArqTrb)->CNW_REVISA+(cArqTrb)->CNW_NUMERO+(cArqTrb)->CNW_PARCEL)
				RecLock("CNW",.F.)
				CNW->CNW_FLGAPR := "2"
				CNW->CNW_DTLANC := CTOD("        ")
				CNW->(MsUnLock())
			Endif
			If MsSeek(xFilial()+(cArqTrb)->CNW_CONTRA+soma1((cArqTrb)->CNW_REVISA)+(cArqTrb)->CNW_NUMERO+(cArqTrb)->CNW_PARCEL)
				RecLock("CNW",.F.)
				CNW->CNW_FLGAPR := "2"
				CNW->CNW_DTLANC := CTOD("        ")
				CNW->(MsUnLock())
			Endif
			DbSelectArea(cArqTrb)
			(cArqTrb)->(dbSkip())
		EndDo                
	
		(cArqTrb)->(dbCloseArea())
	
	EndIf
EndIf

restArea(aArea)

Return
