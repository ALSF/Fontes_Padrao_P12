/*******************************************************************************************************************************
* CNTXMATA.PRX
* Arquivo fonte contendo funções integradas nos fontes MATAXXX para funcionalidades de contratos.
*******************************************************************************************************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "GCTXDEF.CH"

//==============================================================================================================================
/*/{Protheus.doc} CnA097Apr()
Função responsável realizar a integração entre a aprovação de documentos MATA097 e a alteração de situação do contrato CNTA100
@param		cScrNum			Numero da SCR aprovada	(SCR->CR_NUM)
			cScrTip			Tipo da SCR aprovada	(SCR->CR_TIPO)
  					
@author		Israel.Escorizza
@since		16/02/2018
@version	P12.1.20
/*/
//==============================================================================================================================
Function CnA097Apr(cScrNum,cScrTip,oModel)
Local aArea		:= GetArea() 
Local aSaveLine	:= FWSaveRows()
Local lRet		:= .T.

Default cScrNum	:= ""
Default cScrTip	:= ""
Default oModel	:= Nil

If ( !Empty(cScrNum) .And. !Empty(cScrTip) )
	DO	CASE 
		CASE cScrTip $ "CT|IC"
			 dbSelectArea("CN9")
			 CN9->(dbSetOrder(1))
			 
			 If CN9->(MsSeek( xFilial("CN9") + Left( SCR->CR_NUM , TAMSX3('CN9_NUMERO')[1] ) ) )
			 	CN100SitCh(CN9->CN9_NUMERO,CN9->CN9_REVISA,DEF_SVIGE,,.F.)
			 EndIf		 
			
		CASE cScrTip $ "RV|IR" .And. oModel != Nil
			 //-- Inicializa lançamento do PCO
			 PcoIniLan("000354")
			 PcoIniLan("000357")
			
			//- Verifica qual tipo de revisão está sendo aprovada.
			If A300GATpRv() ==  "5" //DEF_REV_PARAL - Paralisação
				oModel:LoadValue('CN9MASTER','CN9_SITUAC',DEF_SPARA) //DEF_SPARA - Paralisado
			Else
				oModel:LoadValue('CN9MASTER','CN9_SITUAC',DEF_SVIGE) //DEF_SVIGE - Vigente
			EndIf

			If oModel:VldData()
				CnPimsChgS(oModel,oModel:CommitData())
			Else
				Ret := .F.		
			EndIf
			oModel:DeActivate()

			//-- Finaliza lancamentos do PCO
			PcoFinLan("000357")
			PcoFreeBlq("000357")

			PcoFinLan("000354")
			PcoFreeBlq("000354")
		
		CASE cScrTip $ "MD|IM"
			dbSelectArea("CND")
				dbSetOrder(4)
				If CND->(dbSeek(xFilial("CND")+Left(SCR->CR_NUM,Len(CND->CND_NUMMED))))
					Reclock("CND",.F.)
					CND->CND_ALCAPR := "L"
					CND->CND_SITUAC := "A"
					MsUnlock()
					If ExistBlock("MT097APR")
						ExecBlock("MT097APR",.F.,.F.)
					EndIf
			EndIf
	END DO	

EndIf

FWRestRows( aSaveLine )     
RestArea(aArea)
Return lRet