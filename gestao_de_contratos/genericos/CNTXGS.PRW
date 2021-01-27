/*******************************************************************************************************************************
* CNTXGS.PRX
* Arquivo fonte contendo funçõe de integração entre os módulos SIGAGCT e SIGATEC
*******************************************************************************************************************************/
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "GCTXDEF.CH"
#INCLUDE "CNTXGS.CH"

//==============================================================================================================================
/*/{Protheus.doc} CnDrVlGs()
Função responsável pelas validações do módulo SIGATEC para a opção "Desfazer Revisão" do módulo SIGAGCT. 

@author 
@since 19/03/2018
@version 12.1.21
@Return lRet
/*/
//==============================================================================================================================
Function CnDrVlGs()
Local  lRet	:= .T.
Return lRet

//==============================================================================================================================
/*/{Protheus.doc} CnDrPrGs()
Função responsável pelo processamento do módulo SIGATEC para a opção "Desfazer Revisão" do módulo SIGAGCT. 

@author 
@since 19/03/2018
@version 12.1.21
@Return lRet
/*/
//==============================================================================================================================
Function CnDrPrGs()
Local  lRet	:= .T.
Return lRet


//==============================================================================================================================
/*/{Protheus.doc} cn300AdtFS(oModel,oModelCN8)
Libera equipamentos dos itens do contrato que foram removidos:
 processo de troca ou substituicao.

@author aline.sebrian
@since 24/02/2014
@version 1.0
@return Nil
/*/
//==============================================================================================================================
Function cn300AdtFS(cContra,cRev,cPlanil,oModelCNB)
Local cMVATESTCL := SuperGetMV("MV_ATESTCL",.F.,"")
Local cMVATESTLJ := SuperGetMV("MV_ATESTLJ",.F.,"")

//-- Deleta localizacao fisica.
AGW->(dbSetOrder(2))
If AGW->(dbSeek(xFilial("AGW")+cContra	+cPlanil+oModelCNB:GetValue("CNB_ITEM")))
	//-- Caso MV_ATESTCL e MV_ATESTLJ estejam configurados, transfere base para cliente padrao.    ³
	If !Empty(cMVATESTCL) .And. !Empty(cMVATESTLJ) .And.;
		!AA3->(dbSeek(xFilial("AA3")+AGW->(cMVATESTCL+cMVATESTLJ+AGW_PRODUT+AGW_NUMSER))) .And.;
		AA3->(dbSeek(xFilial("AA3")+AGW->(AGW_CLIENT+AGW_LOJA+AGW_PRODUT+AGW_NUMSER)))

		//-- Atualiza o historico do equipamento para registrar a transferencia ³
		Reclock("AAF",.T.)
		AAF->AAF_FILIAL := xFilial("AAF")
		AAF->AAF_CODCLI := cMVATESTCL
		AAF->AAF_LOJA   := cMVATESTLJ
		AAF->AAF_CODPRO := AA3->AA3_CODPRO
		AAF->AAF_NUMSER := AA3->AA3_NUMSER
		AAF->AAF_PRODAC := AA3->AA3_CODPRO
		AAF->AAF_NSERAC := AA3->AA3_NUMSER
		AAF->AAF_DTINI  := dDataBase
		AAF->AAF_CODFAB := AA3->AA3_CODFAB
		AAF->AAF_LOJAFA := AA3->AA3_LOJAFA
		AAF->AAF_LOGINI := Left(STR0001 + AA3->AA3_CODCLI + "/" + ; 							//- "Remoção do equipamento do cliente/loja"
							AA3->AA3_LOJA +STR0002 +CN9->CN9_NUMERO +".", Len(AAF->AAF_LOGINI)) //- "em função da revisão do contrato"
		AAF->(MsUnlock())

		//-- Troca cliente dos acessorios da base ³
		AA4->(dbSeek(xFilial("AA4")+AA3->(AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER)))
		While AA4->(!Eof()) .And. AA4->(AA4_FILIAL+AA4_CODCLI+AA4_LOJA+AA4_CODPRO+AA4_NUMSER) == ;
									xFilial("AA4")+AA3->(AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER)
			dbSelectArea("AA4")
			RecLock("AA4",.F.)
			AA4->AA4_CODCLI := cMVATESTCL
			AA4->AA4_LOJA   := cMVATESTLJ
			AA4->(MsUnLock())

			AA4->(dbSkip())
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Troca o cliente da base instalada                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AA3")
		RecLock("AA3",.F.)
		AA3->AA3_CODCLI := cMVATESTCL
		AA3->AA3_LOJA   := cMVATESTLJ
		AA3->AA3_CONTRT := ""
		AA3->AA3_CTAPRE := ""
		AA3->AA3_DTCTAM := Ctod("")
		AA3->(MsUnLock())

		//-- Deleta localizacao fisica do equipamento ³
		RecLock("AGW")
		AGW->(dbDelete())
		AGW->(MsUnLock())

		//-- Atualiza flag para caso um dia o eqto volte ao  ³
		//-- cliente gerar novamente a base instalada.	    ³
		DbSelectArea("CNB")
		CNB->(DbSetOrder(1))
		If CNB->(DbSeek(xFilial("CNB")+cContra+cRev+cPlanil+oModelCNB:GetValue("CNB_ITEM")))
			Reclock( "CNB", .F.)
				CNB->CNB_GERBIN := "2"
			MsUnlock()
		EndIf

	EndIf
EndIf
Return

//==============================================================================================================================
/*/{Protheus.doc} CN100BIns(cNumeCtrt,cNumeRevi,dDataAssi)
Gera Base Instalada e Ordem de Serviço para ítens da Planilha

@author Joao Goncalves de Oliveira
@since 16/02/11
@version 1.0
@return Nil
/*/
//==============================================================================================================================
Function CN100BIns(cNumeCtrt,cNumeRevi,dDataAssi)
Local lRet 		  := .T.
Local lC100GRBI	  := ExistBlock("C100GRBI")
Local lC100GROS	  := ExistBlock("C100GROS")

Local aCabeBIns   := {}
Local aItenBIns   := {}
Local aCabeOSer   := {}
Local aItemOSer   := {}
Local aItenOSer   := {}
Local aRecAA4     := {}
Local aDadoBIns   := {}
Local aDadoOSer   := {}

Local cCodiOcor   := SuperGetMv("MV_OCORROS",.F.,.F.) // Ocorrencia Padrao para Ordem de Serviço
Local cCodCliAnt  := ""
Local cLojaCliAnt := ""

Local nCntFor	  := 0
Local nRegAA3	  := 0

AAG->(dbSetOrder(1))
If Empty(cCodiOcor) .Or. !AAG->(dbSeek(xFilial("AAG")+cCodiOcor))
	Help("  ",1,"CNTEC_03")
	lRet := .F.
Else
	Begin Transaction

	CNB->(dbSetOrder(1))
	CNB->(dbSeek(xfilial("CNB")+cNumeCtrt+cNumeRevi))
	While CNB->(CNB_FILIAL+CNB_CONTRA+CNB_REVISA) == xfilial("CNB")+cNumeCtrt+cNumeRevi
		aCabeBIns := {}
		aItenBIns := {}
		aCabeOSer := {}
		aItemOSer := {}
		aItenOSer := {}

		If CNB->CNB_BASINS == "1" .And. CNB->CNB_GERBIN <> "1" .And. CNB->CNB_SLDMED > 0
			CNA->(dbSetOrder(1))
			CNA->(dbSeek(xfilial("CNA")+cNumeCtrt+cNumeRevi+CNB->CNB_NUMERO))

			CN9->(dbSetOrder(1))
			CN9->(dbSeek(xfilial("CN9")+cNumeCtrt+cNumeRevi))

			AGW->(dbSetOrder(2))
			If AGW->(dbSeek(xfilial("AGW")+CNB->(CNB_CONTRA+CNB_NUMERO+CNB_ITEM)))
				cNumeSeri := AGW->AGW_NUMSER
				cCodiProd := AGW->AGW_PRODUT
				cCodiFabr := AGW->AGW_CODFAB
				cLojaFabr := AGW->AGW_LOJAFA
				aRecAA4   := {}

				//-- Se o equipamento ja estiver instalado
				AA3->(dbSetOrder(4))
				If AA3->(dbSeek(xfilial("AA3")+cCodiFabr+cLojaFabr+cCodiProd+cNumeSeri))
					nRegAA3 := AA3->(Recno())
					//-- E em outro cliente
					If AA3->AA3_CODCLI <> CNA->CNA_CLIENT .Or. AA3->AA3_LOJA <> CNA->CNA_LOJACL
						AA4->(dbSetOrder(3))
						If AA4->(dbSeek(xfilial("AA4")+cCodiFabr+cLojaFabr+cCodiProd+cNumeSeri))
							While AA4->(AA4_CODFAB+AA4_LOJAFA+AA4_CODPRO+AA4_NUMSER) == cCodiFabr+cLojaFabr+cCodiProd+cNumeSeri
								aAdd(aRecAA4,AA4->(Recno()))
								AA4->(dbSkip())
							End
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Efetua transferência de cliente quando o número de série já ³
						//³houver sido instalado e o cliente for diferente do atual    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SA1->(dbSetOrder(1))
						If SA1->(MsSeek(xFilial("SA1")+ CNA->CNA_CLIENT + CNA->CNA_LOJACL))
							AA3->(dbSetOrder(1))
							If !AA3->(MsSeek(xFilial("AA3")+CNA->(CNA_CLIENT+CNA_LOJACL)+AA3->(AA3_CODPRO+AA3_NUMSER)))
								AA3->(MsGoto(nRegAA3))

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Armazena codigo do cliente e loja antes de gravar o AA3³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cCodCliAnt	:= AA3->AA3_CODCLI
								cLojaCliAnt	:= AA3->AA3_LOJA

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza a base instalada                                         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RecLock("AA3",.F.)
								AA3->AA3_CODCLI := CNA->CNA_CLIENT
								AA3->AA3_LOJA   := CNA->CNA_LOJACL
								AA3->AA3_CONTRT := ""
								AA3->AA3_CTAPRE := ""
								AA3->AA3_DTCTAM := CTOD("")
								AA3->(MsUnlock())

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Bloco de Transferencia                                                  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								For nCntFor := 1 To Len(aRecAA4)
									AA4->(MsGoto(aRecAA4[nCntFor]))
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Atualiza historico dos acessorios                                  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RecLock("AA4",.F.)
									AA4->AA4_CODCLI := CNA->CNA_CLIENT
									AA4->AA4_LOJA   := CNA->CNA_LOJACL
									AA4->(MsUnlock())
								Next nCntFor

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza o historico do equipamento                               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								Reclock("AAF",.T.)
								AAF->AAF_FILIAL := xFilial("AAF")
								AAF->AAF_CODCLI := CNA->CNA_CLIENT
								AAF->AAF_LOJA   := CNA->CNA_LOJACL
								AAF->AAF_CODPRO := AA3->AA3_CODPRO
								AAF->AAF_NUMSER := AA3->AA3_NUMSER
								AAF->AAF_PRODAC := AA3->AA3_CODPRO
								AAF->AAF_NSERAC := AA3->AA3_NUMSER
								AAF->AAF_DTINI  := dDataBase
								AAF->AAF_LOGINI := Left(STR0003 +cCodCliAnt +"/" +cLojaCliAnt +STR0004 +CNA->CNA_CLIENT +"/" +;
													CNA->CNA_LOJACL,Len(AAF->AAF_LOGINI)) // # ""Transferência do cliente ## para o cliente ##"
								AAF->(MsUnlock())
							EndIf
						EndIf
					EndIf
				Else
					aAdd(aCabeBIns,{"AA3_CODCLI",CNA->CNA_CLIENT,NIL})
					aAdd(aCabeBIns,{"AA3_LOJA"  ,CNA->CNA_LOJACL,NIL})
					aAdd(aCabeBIns,{"AA3_CODPRO",CNB->CNB_PRODUT,NIL})
					aAdd(aCabeBIns,{"AA3_NUMSER",AGW->AGW_NUMSER,NIL})
					aAdd(aCabeBIns,{"AA3_DTVEND",dDataBase,NIL})
					aAdd(aCabeBIns,{"AA3_STATUS",'02',NIL})

					If lC100GRBI
						aDadoBIns := ExecBlock("C100GRBI",.F.,.F.,{aCabeBIns,aItenBIns})
						aCabeBIns := aClone(aDadoBIns[1])
						aItenBIns := aClone(aDadoBIns[2])
					EndIf

					If !Empty(aCabeBIns)
						lMsErroAuto := .F.
						MSExecAuto( {|w,x,y,z| TECA040(w,x,y,z)}, NIL, aCabeBIns, aItenBIns, 3)
						If lMsErroAuto
							MostraErro()
							lRet := .F.
						Else
							aAdd(aCabeOSer,{"AB6_CODCLI",CNA->CNA_CLIENT,NIL})
							aAdd(aCabeOSer,{"AB6_LOJA"  ,CNA->CNA_LOJACL,NIL})
							aAdd(aCabeOSer,{"AB6_EMISSA",dDataBase,NIL})
							aAdd(aCabeOSer,{"AB6_CONPAG",CN9->CN9_CONDPG,NIL})
							aAdd(aCabeOSer,{"AB6_MSG",STR0005 +AllTrim(CN9->CN9_NUMERO) +".",NIL}) //- "OS gerada pelo início de vigência do contrato nº "

							aAdd(aItemOSer,{"AB7_ITEM",StrZero(1,TamSX3("AB7_ITEM")[1]),NIL})
							aAdd(aItemOSer,{"AB7_CODPRO",CNB->CNB_PRODUT,NIL})
							aAdd(aItemOSer,{"AB7_NUMSER",AGW->AGW_NUMSER,NIL})
							aAdd(aItemOSer,{"AB7_CODPRB",cCodiOcor,NIL})
							aAdd(aItenOSer,aItemOSer)

							If lC100GROS
								aDadoOSer := ExecBlock("C100GROS",.F.,.F.,{aCabeOSer,aItenOSer})
								aCabeOSer := aClone(aDadoOSer[1])
								aItenOSer := aClone(aDadoOSer[2])
							EndIf

							If !Empty(aCabeOSer)
								lMsErroAuto := .F.
								MSExecAuto({|w,x,y,z| TECA450(w,x,y,z)},NIL,aCabeOSer,aItenOSer,NIL,3)

								If lMsErroAuto
									MostraErro()
									lRet := .F.
									Exit
								Endif
							EndIf
						Endif
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza campo de controle de geração da base instalada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRet
					Reclock("CNB",.F.)
					CNB->CNB_GERBIN := "1"
					CNB->(MsUnlock())
				EndIf
			Else
				Help(" ",1,"CNTEC_01",,STR0006 +CNB->CNB_ITEM + STR0007 +CNB->CNB_NUMERO + STR0008,1) //O item ## da planilha ## não possui localização física informada.
				lRet := .F.
				Exit
			EndIf
		EndIf
		CNB->(dbSkip())
	End

	If !lRet
		DisarmTransaction()
	EndIf

	End Transaction
EndIf
Return lRet
