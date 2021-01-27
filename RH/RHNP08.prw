#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "RHNP08.CH"

#DEFINE  PAGE_LENGTH 10

#DEFINE OPERATION_INSERT  1
#DEFINE OPERATION_UPDATE  2
#DEFINE OPERATION_APPROVE 3
#DEFINE OPERATION_REPROVE 4
#DEFINE OPERATION_DELETE  5

Function RHNP08()
Return .T.


WSRESTFUL Vacation DESCRIPTION STR0001 //"Serviços de Vacation"

WSDATA page         As String Optional
WSDATA pageSize     As String Optional
WSDATA employeeId   As String Optional
WSDATA WsNull       As String Optional
WSDATA type         As String Optional

WSMETHOD GET getInfoVacation ;
 DESCRIPTION STR0002 ; //"Serviço GET que retorna os dados das solicitações de férias."
 WSSYNTAX "/vacation/info/{employeeId}" ;
 PATH "/info/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET getHistoryVacation ;
 DESCRIPTION STR0003 ; //"Serviço GET que retorna o histórico de movimentações de férias."
 WSSYNTAX "/vacation/history/{employeeId}" ;
 PATH "/history/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET NextDaysVacation ;
 DESCRIPTION STR0029; //Serviço GET que retorna dados de férias programadas do funcionário ;
 WSSYNTAX "/vacation/myVacation/{employeeId}" ;
 PATH "/myVacation/{employeeId}" ;
 PRODUCES 'application/json;charset=utf-8'

WSMETHOD POST postRequestVacation ;
  DESCRIPTION STR0010 ; //"Serviço POST responsável pela inclusão da solicitação de férias."
  WSSYNTAX "/vacation/request/{employeeId}" ;
  PATH "/vacation/request/{employeeId}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD PUT putRequestVacation ;
  DESCRIPTION STR0011 ; //"Serviço PUT responsável pela edição da solicitação de férias."
  WSSYNTAX "/vacation/request/{employeeId}" ;
  PATH "/request/{employeeId}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD DELETE delRequestVacation ;
  DESCRIPTION STR0012 ; //"Serviço DEL responsável pela exclusão da solicitação de férias."
  WSSYNTAX "/vacation/request/{employeedId}/{vacationId}" ;
  PATH "/request/{employeedId}/{vacationId}" ;
  PRODUCES 'application/json;charset=utf-8'

END WSRESTFUL


// -------------------------------------------------------------------
// GET - Retorna os dados de férias do período aquisitivo aberto
// SRF (Férias confirmadas do período em aberto)
// RH3 (Solicitação de Férias apenas em processo de aprovação)
//
// retorna estrutura "vacationInfoResponse"
// -- hasNext
// -- Array of vacationInfo
// -------------------------------------------------------------------
WSMETHOD GET getInfoVacation WSREST Vacation

Local nPorDFer     := val( SuperGetMv("MV_PORDFER",,30) )
Local cJsonObj     := "JsonObject():New()"
Local oItem        := &cJsonObj
Local oVac         := &cJsonObj
Local cQuery       := GetNextAlias()
Local cQuerySRH    := GetNextAlias()
Local aData        := {}
Local aPeriod      := {}
Local dDataIniPer  := cToD(" / / ")
Local dDataFimPer  := cToD(" / / ")
Local lCanAlter    := .T.
Local lAvalSolic   := .T.
Local lHabSolic    := .T.
Local lLibAlt      := .F.
Local lProgFer     := .F.
Local nDiasSRH     := 0
Local nBonus       := 0
Local nI           := 0
Local cJson        := ""
Local cToken       := ""
Local cMatSRA      := ""
Local cBranchVld   := ""
Local cDtaProg     := ""
Local nLenParms    := Len(::aURLParms)
Local aOcurances   := {}
Local aDateGMT     := {}
Local cDtConv      := ""


::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken     := Self:GetHeader('Authorization')

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cLogin     := GetLoginHR(cToken)


	//Busca férias programadas e confirmadas
	//Status do Periodo de Ferias (1=Ativo / 2=Prescrito / 3-Pago)
	BEGINSQL ALIAS cQuery
        COLUMN RF_DATABAS AS DATE
        COLUMN RF_DATAINI AS DATE
        COLUMN RF_DATINI2 AS DATE
        COLUMN RF_DATINI3 AS DATE
        COLUMN RF_DATAFIM AS DATE
        	      
		SELECT 
			SRF.RF_DATABAS,
			SRF.RF_DATAFIM,
			SRF.RF_DATAINI,
			SRF.RF_DATINI2,
			SRF.RF_DATINI3,
			SRF.RF_DFEPRO1,
			SRF.RF_DFEPRO2,
			SRF.RF_DFEPRO3,
			SRF.RF_DABPRO1,
			SRF.RF_DABPRO2,
			SRF.RF_DABPRO3,
			SRF.RF_PERC13S, 
			SRF.RF_DFERVAT, 
			SRF.RF_DFERAAT,
			SRF.RF_DFERANT, 
			SRF.R_E_C_N_O_
		FROM 
			%Table:SRF% SRF
		WHERE 
			SRF.RF_FILIAL = %Exp:cBranchVld% AND 
			SRF.RF_MAT    = %Exp:cMatSRA%    AND
			SRF.RF_STATUS = '1'              AND
			SRF.%NotDel%
        ORDER BY SRF.RF_DATABAS 			
	ENDSQL
	
    While (cQuery)->(!Eof())

        aPeriod := PeriodConcessive( dtos((cQuery)->RF_DATABAS) , dtos((cQuery)->RF_DATAFIM) )
        //varinfo("aPeriod: ",aPeriod)

        dDataIniPer := aPeriod[1]
        dDataFimPer := aPeriod[2] - nPorDFer
        
        //============================================= 
    	//Busca solicitações férias em andamento na RH3	
        //1=Em processo de aprovação;2=Atendida;3=Reprovada;4=Aguardando Efetivação do RH;5=Aguardando Aprovação do RH
        aOcurances := {}
        If lAvalSolic
           GetVacationWKF(@aOcurances, cMatSRA, cBranchVld, , "1/4")
           //varinfo("getInfo aOcurances: ",aOcurances)

           lAvalSolic := .F.
        EndIf   

        nDiasSolic := 0
        If Len(aOcurances) > 0 
           //Já existe solicitação em andamento necessita
           //finalizar para poder realizar um novo processo
           lHabSolic := .F.        

           //inclui registro no array principal
           For nI := 1  To Len(aOcurances)
               oVac                    := &cJsonObj 
               oVac["days"]            := aOcurances[nI][12]                           //Dias de férias
               oVac["status"]          := "approving"                                  //"approved" "approving" "reject" "empty" "closed"

               oVac["initVacation"]    := Substr(aOcurances[nI][5],7,4) + "-" + ;
                                          Substr(aOcurances[nI][5],4,2) + "-" + ;
                                          Substr(aOcurances[nI][5],1,2) + "T00:00:00Z" //Data de início das férias
               oVac["endVacation"]     := Substr(aOcurances[nI][6],7,4) + "-" + ;
                                          Substr(aOcurances[nI][6],4,2) + "-" + ;
                                          Substr(aOcurances[nI][6],1,2) + "T00:00:00Z"  //Data final das férias

               If !empty(aOcurances[nI][21]) .and. !empty(aOcurances[nI][22])
                  oVac["initPeriod"]   := Substr(aOcurances[nI][21],7,4) + "-" + ;
                                          Substr(aOcurances[nI][21],4,2) + "-" + ;
                                          Substr(aOcurances[nI][21],1,2) + "T00:00:00Z" //Data de início das férias
                  oVac["endPeriod"]    := Substr(aOcurances[nI][22],7,4) + "-" + ;
                                          Substr(aOcurances[nI][22],4,2) + "-" + ;
                                          Substr(aOcurances[nI][22],1,2) + "T00:00:00Z"  //Data final das férias
               EndIf

               If alltrim(aOcurances[nI][17]) == "4"
                  oVac["statusLabel"]  := EncodeUTF8(STR0005)                           //"Aguardando aprovação do RH"
               Else
                  oVac["statusLabel"]  := EncodeUTF8(STR0004)                           //"Em processo de aprovação"
               EndIf
               oVac["id"]              := "RH3"              +"," +;
                                          cBranchVld         +"," +;
                                          cMatSRA            +"," +;              
                                          aOcurances[nI][15] +"," +;              
                                          alltrim( str(aOcurances[nI][16]) )            //Identificador de solicitações
               oVac["vacationBonus"]   := 0                                             //Dias de abono 
               oVac["advance"]         := 0                                             //Adiantamento do 13
               oVac["hasAdvance"]      := aOcurances[nI][14]                            //Se foi solicitado Adiantamento do 13

               //Avalia possibilidade de alteração ou exclusão das solicitações
               oVac["canAlter"]        := .F.
               oVac["limitDate"]       := ""                                            //Data limite para solicitação de férias
               oVac["balance"]         := 0

               lLibAlt                 := .F.
               If aOcurances[nI][19] == aOcurances[nI][20]                              //verifica se já ocorreu alguma aprovação (RH3_NVLINI/RH3_NVLAPR) 
                  lLibAlt := .T.
               ElseIf aOcurances[nI][20] == 99
                  //Pendente de aprovação com o RH
                  //realiza avaliação da RGK para confirmar se a solicitação foi direto
                  //ouseja, sem nenhum aprovador ter realizado avaliações de workflow
                  //varinfo("RH3_CODIGO: ",aOcurances[nI][15])

                  //Valida movimentação do workflow
                  If fVldWkf("", aOcurances[nI][15], "I") == ""
                     lLibAlt := .T.
                  EndIf
               EndIf               

               If lLibAlt
                  oVac["canAlter"]     := .T.
                  oVac["balance"]      := aOcurances[nI][12]                            //Dias de férias da solicitação original

                  aDateGMT             := {}
                  aDateGMT             := LocalToUTC( dtos(dDataFimPer), "12:00:00"  )
                  cDtConv              := DTOS( dDataFimPer )
                  oVac["limitDate"]    := Substr(cDtConv,1,4) + "-" + ;
                                          Substr(cDtConv,5,2) + "-" + ;
                                          Substr(cDtConv,7,2) + "T" + ;
                                          aDateGMT[2] + "Z"                            //Data limite para solicitação de férias
               EndIf


               Aadd(aData,oVac)

               nDiasSolic += val(aOcurances[nI][12])
            Next nI
        EndIf


        //============================================= 
        //********************* Avalia programações SRF
        lProgFer := .F.

        //Carrega o primeiro período de férias confirmados
		If !Empty((cQuery)->RF_DATAINI) .and. (cQuery)->RF_DATAINI > dDataBase
           oVac                    := &cJsonObj
           oVac["balance"]         := 0
           oVac["days"]            := (cQuery)->RF_DFEPRO1                               //Dias de férias
           oVac["status"]          := "approved"                                         //"approved" "approving" "reject" "empty" "closed"

           cDtConv                 := dTos( (cQuery)->RF_DATAINI ) 
           oVac["initVacation"]    := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Data de início das férias

           cDtConv                 := dTos( (cQuery)->RF_DATAINI + ((cQuery)->RF_DFEPRO1 - 1) ) 
           oVac["endVacation"]     := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Data final das férias

           cDtConv                 := dTos( (cQuery)->RF_DATABAS ) 
           oVac["initPeriod"]      := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Inicio do período aquisitivo  "2018-02-01T00:00:00Z"

           cDtConv                 := dTos( (cQuery)->RF_DATAFIM ) 
           oVac["endPeriod"]       := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Final do período aquisitivo   "2019-01-31T00:00:00Z"

           oVac["statusLabel"]     := EncodeUTF8(STR0009)                                //"Confirmada"
           oVac["id"]              := "SRF"                         +"," +;
                                      cBranchVld                    +"," +;
                                      cMatSRA                       +"," +;              
                                      dtos((cQuery)->RF_DATABAS)    +"," +;              
                                      dtos((cQuery)->RF_DATAINI)    +"," +;              
                                      alltrim(str((cQuery)->R_E_C_N_O_))                 //Identificador de férias
           oVac["vacationBonus"]   := (cQuery)->RF_DABPRO1                               //Dias de abono
           oVac["advance"]         := (cQuery)->RF_PERC13S                               //optional - Adiantamento do 13
           If (cQuery)->RF_PERC13S > 0           
               oVac["hasAdvance"]  := .T.                                                //Se foi solicitado Adiantamento do 13
           Else
               oVac["hasAdvance"]  := .F.                                                //Se foi solicitado Adiantamento do 13
           EndIf    
           oVac["limitDate"]       := ""                                                 //Data limite para solicitação de férias
           oVac["canAlter"]        := .F.                                               //Verifica se a solicitação de férias pode ser editada e excluída de acordo com o status
           Aadd(aData,oVac)

           lProgFer := .T.
		EndIf
        nDiasSolic += (cQuery)->RF_DFEPRO1 + (cQuery)->RF_DABPRO1
		
        //Carrega o segundo período de férias confirmado
		If !Empty((cQuery)->RF_DATINI2) .and. (cQuery)->RF_DATINI2 > dDataBase
           oVac                    := &cJsonObj
           oVac["balance"]         := 0
           oVac["days"]            := (cQuery)->RF_DFEPRO2                               //Dias de férias
           oVac["status"]          := "approved"                                         //"approved" "approving" "reject" "empty" "closed"

           cDtConv                 := dTos( (cQuery)->RF_DATINI2 ) 
           oVac["initVacation"]    := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Data de início das férias

           cDtConv                 := dTos( (cQuery)->RF_DATINI2 + ((cQuery)->RF_DFEPRO2 - 1) ) 
           oVac["endVacation"]     := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Data final das férias

           cDtConv                 := dTos( (cQuery)->RF_DATABAS ) 
           oVac["initPeriod"]      := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Inicio do período aquisitivo  "2018-02-01T00:00:00Z"

           cDtConv                 := dTos( (cQuery)->RF_DATAFIM ) 
           oVac["endPeriod"]       := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Final do período aquisitivo   "2019-01-31T00:00:00Z"

           oVac["statusLabel"]     := EncodeUTF8(STR0009)                                //"Confirmada"
           oVac["id"]              := "SRF"                         +"," +;
                                      cBranchVld                    +"," +;
                                      cMatSRA                       +"," +;              
                                      dtos((cQuery)->RF_DATABAS)    +"," +;              
                                      dtos((cQuery)->RF_DATINI2)    +"," +;              
                                      alltrim(str((cQuery)->R_E_C_N_O_))                 //Identificador de férias
           oVac["vacationBonus"]   := (cQuery)->RF_DABPRO2                               //Dias de abono
           oVac["advance"]         := (cQuery)->RF_PERC13S                               //optional - Adiantamento do 13
           If (cQuery)->RF_PERC13S > 0           
               oVac["hasAdvance"]  := .T.                                                //Se foi solicitado Adiantamento do 13
           Else
               oVac["hasAdvance"]  := .F.                                                //Se foi solicitado Adiantamento do 13
           EndIf    
           oVac["limitDate"]       := ""                                                 //Data limite para solicitação de férias
           oVac["canAlter"]        := .F.                                                //Verifica se a solicitação de férias pode ser editada e excluída de acordo com o status
           Aadd(aData,oVac)

           lProgFer := .T.
		EndIf
        nDiasSolic += (cQuery)->RF_DFEPRO2 + (cQuery)->RF_DABPRO2
		
        //Carrega o terceiro período de férias confirmado
		If !Empty((cQuery)->RF_DATINI3)  .and. (cQuery)->RF_DATINI3 > dDataBase
           oVac                    := &cJsonObj
           oVac["balance"]         := 0
           oVac["days"]            := (cQuery)->RF_DFEPRO3                               //Dias de férias
           oVac["status"]          := "approved"                                         //"approved" "approving" "reject" "empty" "closed"

           cDtConv                 := dTos( (cQuery)->RF_DATINI3 ) 
           oVac["initVacation"]    := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Data de início das férias

           cDtConv                 := dTos( (cQuery)->RF_DATINI3 + ((cQuery)->RF_DFEPRO3 - 1) ) 
           oVac["endVacation"]     := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Data final das férias

           cDtConv                 := dTos( (cQuery)->RF_DATABAS ) 
           oVac["initPeriod"]      := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Inicio do período aquisitivo  "2018-02-01T00:00:00Z"

           cDtConv                 := dTos( (cQuery)->RF_DATAFIM ) 
           oVac["endPeriod"]       := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Final do período aquisitivo   "2019-01-31T00:00:00Z"

           oVac["statusLabel"]     := EncodeUTF8(STR0009)                                //"Confirmada"
           oVac["id"]              := "SRF"                         +"," +;
                                      cBranchVld                    +"," +;
                                      cMatSRA                       +"," +;              
                                      dtos((cQuery)->RF_DATABAS)    +"," +;              
                                      dtos((cQuery)->RF_DATINI3)    +"," +;              
                                      alltrim(str((cQuery)->R_E_C_N_O_))                 //Identificador de férias
           oVac["vacationBonus"]   := (cQuery)->RF_DABPRO3                               //Dias de abono
           oVac["advance"]         := (cQuery)->RF_PERC13S                               //optional - Adiantamento do 13
           If (cQuery)->RF_PERC13S > 0           
               oVac["hasAdvance"]  := .T.                                                //Se foi solicitado Adiantamento do 13
           Else
               oVac["hasAdvance"]  := .F.                                                //Se foi solicitado Adiantamento do 13
           EndIf    
           oVac["limitDate"]       := ""                                                 //Data limite para solicitação de férias
           oVac["canAlter"]        := .F.                                                //Verifica se a solicitação de férias pode ser editada e excluída de acordo com o status
           Aadd(aData,oVac)

           lProgFer := .T.
		EndIf
        nDiasSolic += (cQuery)->RF_DFEPRO3 + (cQuery)->RF_DABPRO3


        /*  avaliar registros na SRH calculados com data de inicio posterior a data do sistema, 
            para que possa ser criado um card, caso não existam programações na SRF...
            além disso ser utilizado para abater do saldo disponível de férias, prevendo que
            o fechamento ainda possa não ter sido realizado, atualizando os saldos na SRF  */
        BEGINSQL ALIAS cQuerySRH
           COLUMN RH_DATABAS AS DATE
           COLUMN RH_DBASEAT AS DATE
           COLUMN RH_DATAINI AS DATE
           COLUMN RH_DATAFIM AS DATE
	
           SELECT 
			   SRH.RH_DATABAS,
            SRH.RH_DBASEAT,
			   SRH.RH_DATAINI,
			   SRH.RH_DATAFIM,
			   SRH.RH_DABONPE,
			   SRH.RH_ACEITE,
			   SRH.RH_DFERIAS,
			   SRH.RH_DFERVEN,
			   SRH.RH_PERC13S,
			   SRH.R_E_C_N_O_,
			   SRH.RH_FILIAL,
			   SRH.RH_MAT
           FROM 
		       %Table:SRH% SRH
           WHERE 
			   SRH.RH_FILIAL   = %Exp:cBranchVld%            AND 
			   SRH.RH_MAT      = %Exp:cMatSRA %              AND
			   SRH.RH_DATABAS  = %Exp:(cQuery)->RF_DATABAS%  AND
			   SRH.RH_DBASEAT  = %Exp:(cQuery)->RF_DATAFIM%  AND
			   SRH.%NotDel%
        ENDSQL

        nDiasSRH := 0
        cDtaProg := If( Empty((cQuery)->RF_DATAINI), "", dtos((cQuery)->RF_DATAINI) ) + "|" 
        cDtaProg += If( Empty((cQuery)->RF_DATINI2), "", dtos((cQuery)->RF_DATINI2) ) + "|"
        cDtaProg += If( Empty((cQuery)->RF_DATINI3), "", dtos((cQuery)->RF_DATINI3) ) + "|"
        
	    While (cQuerySRH)->(!Eof())
           
           //Considera as Ferias se nao houver programacao, ou se houver ferias mas com data de inicio diferente da programacao 
           If (cQuerySRH)->RH_DATAINI >= dDataBase .And. (!lProgFer .Or. !dTos( (cQuerySRH)->RH_DATAINI) $ cDtaProg ) 
              oVac                    := &cJsonObj 
              oVac["balance"]         := 0                                             //Saldo disponível
              oVac["days"]            := (cQuerySRH)->RH_DFERIAS                       //Dias de férias
              oVac["status"]          := "approved"                                    //"approved" "approving" "reject" "empty" "closed"
              oVac["initVacation"]    := (cQuerySRH)->RH_DATAINI                       //Data inicial das férias
              oVac["endVacation"]     := (cQuerySRH)->RH_DATAFIM                       //Data final das férias
              oVac["initPeriod"]      := (cQuerySRH)->RH_DATABAS                       //Inicio do período aquisitivo  "2018-02-01T00:00:00Z"
              oVac["endPeriod"]       := (cQuerySRH)->RH_DBASEAT                       //Final do período aquisitivo   "2019-01-31T00:00:00Z"
              oVac["statusLabel"]     := EncodeUTF8(STR0027)                           //"Em processo de cálculo"
              oVac["id"]              := "SRH"                            +"," +;
                                         (cQuerySRH)->RH_FILIAL           +"," +;
                                         (cQuerySRH)->RH_MAT              +"," +;              
                                         dtos((cQuerySRH)->RH_DATABAS)    +"," +;              
                                         dtos((cQuerySRH)->RH_DATAINI)    +"," +;              
                                         alltrim(str((cQuerySRH)->R_E_C_N_O_))         //Identificador de férias
              oVac["vacationBonus"]   := (cQuerySRH)->RH_DABONPE                       //Dias de abono
              oVac["advance"]         := (cQuerySRH)->RH_PERC13S                       //optional - Adiantamento do 13
              If (cQuerySRH)->RH_PERC13S > 0           
                 oVac["hasAdvance"]  := .T.                                            //Se foi solicitado Adiantamento do 13
              Else
                 oVac["hasAdvance"]  := .F.                                            //Se foi solicitado Adiantamento do 13
              EndIf    
              oVac["limitDate"]       := ""                                            //Data limite para solicitação de férias
              oVac["canAlter"]        := .F.                                           //Verifica se a solicitação de férias pode ser editada e excluída de acordo com o status
              Aadd(aData,oVac)
           EndIf

           nDiasSRH := nDiasSRH + (cQuerySRH)->RH_DFERIAS
          (cQuerySRH)->(DBSkip())
        EndDo
	    (cQuerySRH)->(DBCloseArea())


        /* Carrega o card para "solicitar férias" em virtude de saldo pendente
           apenas para o primeiro período aquisitivo em aberto, para que as 
           solicitações dos saldos sejam feitos na sequencia
           
           exemplo:
           DATABAS   DATAFIM   DIASDIR(dias vencidos)  DFERVAT(dias vencidos)  DFERAAT(dias proporcionais)
           20180210  20190209     30                     30                       0
           20190210  20200209     30                     0                       10
        */
        If ( ((cQuery)->RF_DFERVAT - nDiasSolic - nDiasSRH) > 0    .or.  ;
             ((cQuery)->RF_DFERAAT - nDiasSolic - nDiasSRH) > 0 )  .and. ;
             lHabSolic

           lHabSolic := .F.        
           oVac                    := &cJsonObj
           
           If (cQuery)->RF_DFERVAT > 0
              oVac["balance"]      := (cQuery)->RF_DFERVAT - nDiasSolic - nDiasSRH
           Else
              oVac["balance"]      := (cQuery)->RF_DFERAAT - nDiasSolic - nDiasSRH
           EndIf
           
           oVac["status"]          := "empty"                                            //"approved" "approving" "reject" "empty" "closed"
           oVac["initVacation"]    := ""
           oVac["endVacation"]     := ""

           cDtConv                 := dTos( (cQuery)->RF_DATABAS ) 
           oVac["initPeriod"]      := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Inicio do período aquisitivo  "2018-02-01T00:00:00Z"

           cDtConv                 := dTos( (cQuery)->RF_DATAFIM ) 
           oVac["endPeriod"]       := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T00:00:00Z"                 //Final do período aquisitivo   "2019-01-31T00:00:00Z"

           oVac["id"]              := "SRF"                         +"," +;
                                      cBranchVld                    +"," +;
                                      cMatSRA                       +"," +;              
                                      dtos((cQuery)->RF_DATABAS)    +"," +;              
                                      dtos((cQuery)->RF_DATAFIM)    +"," +;              
                                      alltrim(str((cQuery)->R_E_C_N_O_))                 //Identificador de férias
           oVac["hasAdvance"]      := .F.                                                //Se foi solicitado Adiantamento do 13

           aDateGMT				   := {}
           aDateGMT  			   := LocalToUTC( dtos(dDataFimPer), "12:00:00"  )
           cDtConv                 := DTOS( dDataFimPer )
           oVac["limitDate"]       := Substr(cDtConv,1,4) + "-" + ;
                                      Substr(cDtConv,5,2) + "-" + ;
                                      Substr(cDtConv,7,2) + "T" + ;
                                      aDateGMT[2] + "Z"                                  //Data limite para solicitação de férias

           oVac["canAlter"]        := .F.                                               //Verifica se a solicitação de férias pode ser editada e excluída de acordo com o status

           If oVac["balance"] > 0
              Aadd(aData,oVac)
           EndIf
        EndIf 


        (cQuery)->( DbSkip() )
    EndDo
	
	(cQuery)->(DBCloseArea())		


    oItem["hasNext"] := .F.
    oItem["items"]   := aData

    cJson := FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return(.T.)


// ---------------------------------------------------------
// GET - Retorna o histórico de solicitações de férias 
// SRH (Férias processadas)
// RH3 (Solicitações de Férias reprovadas)
//
// retorna estrutura "vacationInfoResponse"
// -- hasNext
// -- Array of vacationInfo
// ---------------------------------------------------------
WSMETHOD GET getHistoryVacation WSREST Vacation

Local cJsonObj      := "JsonObject():New()"
Local oItem         := &cJsonObj
Local oVac          := &cJsonObj
Local aData         := {}
Local aDataResult   := {}
Local cQuery        := GetNextAlias()
Local aPeriod       := {}
Local dDataIniPer   := cToD(" / / ")
Local dDataFimPer   := cToD(" / / ")
Local cJson         := ""
Local cToken        := ""
Local cMatSRA       := ""
Local cBranchVld    := ""
Local aOcurances    := {}
Local aPerFerias    := {}
Local lMaisPaginas  := .F.
Local nI, nX        := 0
Local nRegCount     := 0
Local nRegCountIni  := 0 
Local nRegCountFim  := 0
Local nLenParms     := Len(::aURLParms)

DEFAULT Self:page     := "1"
DEFAULT Self:pageSize := "10"


    ::SetHeader('Access-Control-Allow-Credentials' , "true")
    cToken     := Self:GetHeader('Authorization')
 
    cMatSRA    := GetRegisterHR(cToken)
    cBranchVld := GetBranch(cToken)
    cLogin     := GetLoginHR(cToken)

    //Prepara o controle de paginacao
    If Self:page == "1" .Or. Self:page == ""
 	   nRegCountIni := 1 
	   nRegCountFim := val(Self:pageSize)
    Else
	   nRegCountIni := ( val(Self:pageSize) * (val(Self:Page) - 1)  ) + 1
	   nRegCountFim := ( nRegCountIni + val(Self:pageSize) ) - 1
    EndIf   


    //================================== 
    //Avalia as férias calculadas na SRH
	BEGINSQL ALIAS cQuery
        COLUMN RH_DATABAS AS DATE
        COLUMN RH_DBASEAT AS DATE
        COLUMN RH_DATAINI AS DATE
        COLUMN RH_DATAFIM AS DATE
	
		SELECT 
			SRH.RH_DATABAS,
			SRH.RH_DBASEAT,
			SRH.RH_DATAINI,
			SRH.RH_DATAFIM,
			SRH.RH_DABONPE,
			SRH.RH_ACEITE,
			SRH.RH_DFERIAS,
			SRH.RH_DFERVEN,
			SRH.RH_PERC13S,
			SRH.R_E_C_N_O_,
			SRH.RH_FILIAL,
			SRH.RH_MAT
		FROM 
			%Table:SRH% SRH
		WHERE 
			SRH.RH_FILIAL   = %Exp:cBranchVld% AND 
			SRH.RH_MAT      = %Exp:cMatSRA %   AND
			SRH.%NotDel%
		ORDER BY
			SRH.RH_DATABAS DESC		 
	ENDSQL

	While (cQuery)->(!Eof())
	
          //Férias calculadas mais que a data de inicio ainda não ocorreu, serão 
          //disponibilizadas no card do serviço "/vacation/info" como confirmadas 
          If (cQuery)->RH_DATAINI < dDataBase           
	
             oVac                    := &cJsonObj 
             oVac["balance"]         := ((cQuery)->RH_DFERVEN - (cQuery)->RH_DFERIAS) //Saldo disponível
             oVac["days"]            := (cQuery)->RH_DFERIAS                          //Dias de férias
             oVac["status"]          := "closed"                                      //"approved" "approving" "reject" "empty" "closed"
             oVac["initVacation"]    := (cQuery)->RH_DATAINI                          //Data inicial das férias
             oVac["endVacation"]     := (cQuery)->RH_DATAFIM                          //Data final das férias
             oVac["initPeriod"]      := (cQuery)->RH_DATABAS                          //Inicio do período aquisitivo  "2018-02-01T00:00:00Z"
             oVac["endPeriod"]       := (cQuery)->RH_DBASEAT                          //Final do período aquisitivo   "2019-01-31T00:00:00Z"

             If (cQuery)->RH_DATAFIM < dDataBase           
                oVac["statusLabel"]  := EncodeUTF8(STR0006)                           //"Finalizadas"
             Else  
                oVac["statusLabel"]  := EncodeUTF8(STR0007)                           //"Em Andamento"
             EndIf

             oVac["id"]              := "SRH"                         +"," +;
                                        (cQuery)->RH_FILIAL           +"," +;
                                        (cQuery)->RH_MAT              +"," +;              
                                        dtos((cQuery)->RH_DATABAS)    +"," +;              
                                        dtos((cQuery)->RH_DATAINI)    +"," +;              
                                        alltrim(str((cQuery)->R_E_C_N_O_))            //Identificador de férias

             oVac["vacationBonus"]   := (cQuery)->RH_DABONPE                          //Dias de abono
             oVac["advance"]         := (cQuery)->RH_PERC13S                          //optional - Adiantamento do 13
             If (cQuery)->RH_PERC13S > 0           
                 oVac["hasAdvance"]  := .T.                                           //Se foi solicitado Adiantamento do 13
             Else
                 oVac["hasAdvance"]  := .F.                                           //Se foi solicitado Adiantamento do 13
             EndIf    
             oVac["limitDate"]       := ""                                            //Data limite para solicitação de férias
             oVac["canAlter"]        := .F.                                           //Verifica se a solicitação de férias pode ser editada e excluída de acordo com o status
             Aadd(aData,oVac)

          EndIf
          
         (cQuery)->(DBSkip())
	EndDo
	(cQuery)->(DBCloseArea())


    //==================================== 
    //Busca solicitações rejeitadas na RH3
    //1=Em processo de aprovação;2=Atendida;3=Reprovada;4=Aguardando Efetivação do RH;5=Aguardando Aprovação do RH
    aOcurances := {}
    GetVacationWKF(@aOcurances, cMatSRA, cBranchVld, , "3")
    //varinfo("getHistory aOcurances: ",aOcurances)

    If Len(aOcurances) > 0 
        //inclui registro no array principal
        For nI := 1  To Len(aOcurances)
            oVac                    := &cJsonObj 
            oVac["balance"]         := 0
            oVac["days"]            := aOcurances[nI][12]                           //Dias de férias
            oVac["status"]          := "reject"                                     //"approved" "approving" "reject" "empty" "closed"

            oVac["initVacation"]    := cTod(aOcurances[nI][5])                      //Data de início das férias
            oVac["endVacation"]     := cTod(aOcurances[nI][6])                      //Data final das férias
            If !empty(aOcurances[nI][21]) .and. !empty(aOcurances[nI][22])
               oVac["initPeriod"]      := cTod(aOcurances[nI][21])
               oVac["endPeriod"]       := cTod(aOcurances[nI][22])
            EndIf

            oVac["statusLabel"]     := EncodeUTF8(STR0008)                          //"Rejeitada"
            oVac["id"]              := "RH3"              +"," +;
                                       cBranchVld         +"," +;
                                       cMatSRA            +"," +;              
                                       aOcurances[nI][15] +"," +;              
                                       alltrim( str(aOcurances[nI][16]) )           //Identificador de solicitações
            oVac["vacationBonus"]   := aOcurances[nI][7]                            //Dias de abono 
            oVac["advance"]         := 0                                            //Adiantamento do 13
            oVac["hasAdvance"]      := aOcurances[nI][14]                           //Se foi solicitado Adiantamento do 13
            oVac["limitDate"]       := ""                                           //Data limite para solicitação de férias
            oVac["canAlter"]        := .F.
            Aadd(aData,oVac)
        Next nI
    EndIf


    //Ordenando resultado pela data de inicio das féras
    ASORT(aData, , , { | x,y | x["initVacation"] > y["initVacation"] } )

    //Avalia a paginação após a ordenação
    For nI := 1 To Len(aData)

		nRegCount ++
		If ( nRegCount >= nRegCountIni .And. nRegCount <= nRegCountFim )
            Aadd(aDataResult , aData[nI])
		Else
			If nRegCount > nRegCountFim
				lMaisPaginas := .T.
			EndIf   
		EndIf   

    Next nI


    oItem["hasNext"]  := lMaisPaginas
    oItem["items"]    := aDataResult
    oItem["length"]   := Len(aData)

    cJson := FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return(.T.)

WSMETHOD GET NextDaysVacation WSREST Vacation

Local cJsonObj      := "JsonObject():New()"
Local oItem         := &cJsonObj
Local oVac          := &cJsonObj
Local aData         := {}
Local aPeriod       := {}
Local aDateGMT      := {}
Local cQuery        := GetNextAlias()
Local cJson         := ""
Local cToken        := ""
Local cMatSRA       := ""
Local cID           := ""
Local cBranchVld    := ""
Local cStatus       := ""
Local cDtConv       := ""
local cDtBsIni      := ""
Local cDtBsFim      := ""
Local cDtFerIni     := ""
Local dDataIniPer   := cTod("")
Local dDataFimPer   := cTod("")
Local nDiasFer      := 0
Local nPorDFer      := Val(SuperGetMv("MV_PORDFER",,"30"))
Local lTem13        := .F.
Local lTemProg      := .F.

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken     := Self:GetHeader('Authorization')

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)

BEGINSQL ALIAS cQuery
      COLUMN RF_DATABAS AS DATE
      COLUMN RF_DATAINI AS DATE
      COLUMN RF_DATINI2 AS DATE
      COLUMN RF_DATINI3 AS DATE
      COLUMN RF_DATAFIM AS DATE
            
   SELECT 
      SRF.RF_DATABAS,
      SRF.RF_DATAFIM,
      SRF.RF_DATAINI,
      SRF.RF_DATINI2,
      SRF.RF_DATINI3,
      SRF.RF_DFEPRO1,
      SRF.RF_DFEPRO2,
      SRF.RF_DFEPRO3,
      SRF.RF_DABPRO1,
      SRF.RF_DABPRO2,
      SRF.RF_DABPRO3,
      SRF.RF_PERC13S, 
      SRF.RF_DFERVAT, 
      SRF.RF_DFERAAT,
      SRF.RF_DFERANT, 
      SRF.R_E_C_N_O_
   FROM 
      %Table:SRF% SRF
   WHERE 
      SRF.RF_FILIAL = %Exp:cBranchVld% AND 
      SRF.RF_MAT    = %Exp:cMatSRA%    AND
      SRF.RF_STATUS = '1'              AND
      SRF.%NotDel%
      ORDER BY SRF.RF_DATABAS		
ENDSQL

While (cQuery)->(!Eof())


   //Busca informações do período concessivo para saber a data limite de cada período.
   //Somente busca se existir programação
   If !Empty((cQuery)->RF_DATAINI) .Or. !Empty((cQuery)->RF_DATINI2) .Or. !Empty((cQuery)->RF_DATINI3)
      aPeriod     := PeriodConcessive( dtos((cQuery)->RF_DATABAS) , dtos((cQuery)->RF_DATAFIM) )
      dDataIniPer := aPeriod[1]
      dDataFimPer := aPeriod[2] - nPorDFer
   EndIf

   lTem13 := .F.
   //Verifica se existe programação e a data de inicio é menor que a database
   If !Empty((cQuery)->RF_DATAINI) .And. (cQuery)->RF_DATAINI > dDataBase
      nDiasFer  := (cQuery)->RF_DFEPRO1               // Qtde dias de férias
      cStatus   := "approved"                         // Status

      cDtFerIni := dToS((cQuery)->RF_DATAINI)         // Data início férias.
      cDtFerIni := Substr(cDtFerIni,1,4) + "-" + ;
                   SubStr(cDtFerIni,5,2) + "-" + ;
                   SubStr(cDtFerIni,7,2) + "-" + ;
                   "T00:00:00Z"

      cDtBsIni  := dToS((cQuery)->RF_DATABAS)         // Database início
      cDtBsIni  := Substr(cDtBsIni,1,4) + "-" + ;
                   SubStr(cDtBsIni,5,2) + "-" + ;
                   SubStr(cDtBsIni,7,2) + "-" + ;
                   "T00:00:00Z"

      cDtBsFim  := dToS((cQuery)->RF_DATAFIM)         // Database fim
      cDtBsFim  := Substr(cDtBsFim,1,4) + "-" + ;
                   SubStr(cDtBsFim,5,2) + "-" + ;
                   SubStr(cDtBsFim,7,2) + "-" + ;
                   "T00:00:00Z"                 

      cID       := cBranchVld + "|" + cMatSRA + "|" + dToS((cQuery)->RF_DATABAS) + "|" + dToS((cQuery)->RF_DATAINI)                   
      lTem13    := (cQuery)->RF_PERC13S > 0

      cDtConv   := dToS(dDataFimPer)                  //Data limite para gozo
      cDtConv   := Substr(cDtConv,1,4) + "-" + ;
                   SubStr(cDtConv,5,2) + "-" + ;
                   SubStr(cDtConv,7,2) + "-" + ;
                   "T00:00:00Z"
      
      //Se encontrar, sai do loop
      Exit

   ElseIf !Empty((cQuery)->RF_DATINI2) .And. (cQuery)->RF_DATINI2 > dDataBase
      nDiasFer  := (cQuery)->RF_DFEPRO2               // Qtde dias de férias
      cStatus   := "approved"                         // Status

      cDtFerIni := dToS((cQuery)->RF_DATINI2)         // Data início férias.   
      cDtFerIni := Substr(cDtFerIni,1,4) + "-" + ;
                   SubStr(cDtFerIni,5,2) + "-" + ;
                   SubStr(cDtFerIni,7,2) + "-" + ;
                   "T00:00:00Z"
 

      cDtBsIni  := dToS((cQuery)->RF_DATABAS)          // Database início
      cDtBsIni  := Substr(cDtBsIni,1,4) + "-" + ;
                   SubStr(cDtBsIni,5,2) + "-" + ;
                   SubStr(cDtBsIni,7,2) + "-" + ;
                   "T00:00:00Z"

      cDtBsFim  := dToS((cQuery)->RF_DATAFIM)           // Database fim
      cDtBsFim  := Substr(cDtBsFim,1,4) + "-" + ;
                   SubStr(cDtBsFim,5,2) + "-" + ;
                   SubStr(cDtBsFim,7,2) + "-" + ;
                   "T00:00:00Z" 
                   
      cID       := cBranchVld + "|" + cMatSRA + "|" + dToS((cQuery)->RF_DATABAS) + "|" + dToS((cQuery)->RF_DATINI2)
      lTem13    := (cQuery)->RF_PERC13S > 0

      cDtConv   := dToS(dDataFimPer)                    //Data limite para gozo
      cDtConv   := Substr(cDtConv,1,4) + "-" + ;
                   SubStr(cDtConv,5,2) + "-" + ;
                   SubStr(cDtConv,7,2) + "-" + ;
                   "T00:00:00Z"
      //Se encontrar, sai do loop
      Exit
      
   ElseIf !Empty((cQuery)->RF_DATINI3) .And. (cQuery)->RF_DATINI3 > dDataBase
      nDiasFer  := (cQuery)->RF_DFEPRO3                  // Qtde dias de férias
      cStatus   := "approved"                            // Status

      cDtFerIni := dToS((cQuery)->RF_DATINI3)            // Data início férias. 
      cDtFerIni := Substr(cDtFerIni,1,4) + "-" + ;
                   SubStr(cDtFerIni,5,2) + "-" + ;
                   SubStr(cDtFerIni,7,2) + "-" + ;
                   "T00:00:00Z"

      cDtBsIni  := dToS((cQuery)->RF_DATABAS)             // Database início
      cDtBsIni  := Substr(cDtBsIni,1,4) + "-" + ;
                   SubStr(cDtBsIni,5,2) + "-" + ;
                   SubStr(cDtBsIni,7,2) + "-" + ;
                   "T00:00:00Z"

      cDtBsFim  := dToS((cQuery)->RF_DATAFIM)            // Database fim
      cDtBsFim  := Substr(cDtBsFim,1,4) + "-" + ;
                   SubStr(cDtBsFim,5,2) + "-" + ;
                   SubStr(cDtBsFim,7,2) + "-" + ;
                   "T00:00:00Z" 

      cID       := cBranchVld + "|" + cMatSRA + "|" + dToS((cQuery)->RF_DATABAS) + "|" + dToS((cQuery)->RF_DATINI3)
      lTem13    := (cQuery)->RF_PERC13S > 0

      cDtConv   := dToS(dDataFimPer)                     //Data limite para gozo
      cDtConv   := Substr(cDtConv,1,4) + "-" + ;   
                   SubStr(cDtConv,5,2) + "-" + ;
                   SubStr(cDtConv,7,2) + "-" + ;
                   "T00:00:00Z" 
      
      //Se encontrar, sai do loop
      Exit

   Else
      //Se não existir programação, verifica se há férias calculada para o período aquisitivo em questão.
      SRH->(dbSetOrder(1))
      If SRH->(dbSeek(cBranchVld + cMatSRA + dToS((cQuery)->RF_DATABAS))) 

         //Busca o período concessivo de acordo com os dados da SRH.
         aPeriod     := PeriodConcessive( dtos(SRH->RH_DATABAS) , dtos(SRH->RH_DBASEAT) )
         dDataIniPer := aPeriod[1]
         dDataFimPer := aPeriod[2] - nPorDFer

         nDiasFer    := SRH->RH_DFERIAS                  //quantidade de dias de férias
         cStatus     := "approved"                       //status

         cDtFerIni := dToS(SRH->RH_DATAINI)              //Data início das férias.
         cDtFerIni := Substr(cDtFerIni,1,4) + "-" + ;
                      SubStr(cDtFerIni,5,2) + "-" + ;
                      SubStr(cDtFerIni,7,2) + "-" + ;
                      "T00:00:00Z"

         cDtBsIni    := dToS(SRH->RH_DATABAS)            
         cDtBsIni    := Substr(cDtBsIni,1,4) + "-" + ;   //database início
                        SubStr(cDtBsIni,5,2) + "-" + ;
                        SubStr(cDtBsIni,7,2) + "-" + ;
                        "T00:00:00Z"

         cDtBsFim    := dToS(SRH->RH_DBASEAT)  
         cDtBsFim    := Substr(cDtBsFim,1,4) + "-" + ;   //database fim
                        SubStr(cDtBsFim,5,2) + "-" + ;
                        SubStr(cDtBsFim,7,2) + "-" + ;
                        "T00:00:00Z" 

         cID         := cBranchVld + "|" + cMatSRA + "|" + dToS(SRH->RH_DATABAS) + "|" + dToS(SRH->RH_DATAINI)
         lTem13      := SRH->RH_PERC13S > 0              //solicitado 13?

         cDtConv     := dToS(dDataFimPer)
         cDtConv     := Substr(cDtConv,1,4) + "-" + ;    //data limite para gozo das férias;
                        SubStr(cDtConv,5,2) + "-" + ;
                        SubStr(cDtConv,7,2) + "-" + ;
                        "T00:00:00Z" 
         
         //Se encontrar, sai do loop
         Exit
      EndIf
   EndIf
   (cQuery)->(dbSkip())
EndDo

(cQuery)->(dbCloseArea())

oVac                    := &cJsonObj
oVac["days"]            := nDiasFer
oVac["status"]          := cStatus
oVac["initVacation"]   := cDtFerIni
oVac["initPeriod"]      := cDtBsIni
oVac["endPeriod"]       := cDtBsFim
oVac["id"]              := cID
oVac["hasAdvance"]      := lTem13
oVac["limitDate"]       := cDtConv

cJson := FWJsonSerialize(oVac, .F., .F., .T.)
::SetResponse(cJson)

Return (.T.)


// -------------------------------------------------------------------
// - Atualização da inclusão de solicitação de férias.
// -------------------------------------------------------------------
WSMETHOD POST postRequestVacation WSREST Vacation
Local cJsonObj              := "JsonObject():New()"
Local oItemDetail           := &cJsonObj
Local oItemData             := &cJsonObj
Local oItem                 := &cJsonObj
Local oMsgReturn            := &cJsonObj

Local lRet                  := .T.
Local cRestFault            := ""
Local nReturnCode           := 0 
Local cRoutine				:= "W_PWSA100A.APW" 
Local cBody 		        := ::GetContent()
Local cAliasRH4             := GetNextAlias()

Local cApprover				:= ""
Local cEmpApr				:= ""
Local cFilApr				:= ""
Local cVision	 			:= ""
Local aVision				:= {}
Local aGetStruct			:= {}
Local aEmployee             := {}
Local aMessages             := {}
Local nSupLevel				:= 0
Local nDias                 := 0
Local nDiasAbn              := 0
Local lSolic13              := .F.
Local cIniVac               := ""
Local cEndVac               := ""
Local cIniPer               := ""
Local cEndPer               := ""

Local cBranchVld			:= FwCodFil()
Local oRequest				:= Nil
Local oVacationRequest   	:= Nil


    ::SetHeader('Access-Control-Allow-Credentials' , "true")
    cToken     := Self:GetHeader('Authorization')
 
    cMatSRA    := GetRegisterHR(cToken)
    cBranchVld := GetBranch(cToken)
    cLogin     := GetLoginHR(cToken)
    cRD0Cod    := GetCODHR(cToken)


    If !Empty(cBody)

	   oItemDetail:FromJson(cBody)
       nDias   := Iif(oItemDetail:hasProperty("days"),oItemDetail["days"], 0)
       nDiasAbn:= Iif(oItemDetail:hasProperty("vacationBonus"),oItemDetail["vacationBonus"], 0)
       cIniVac := Iif(oItemDetail:hasProperty("initVacation"), Format8601(.T.,oItemDetail["initVacation"]), "")
       cEndVac := Iif(oItemDetail:hasProperty("endVacation"), Format8601(.T.,oItemDetail["endVacation"]), "")
       lSolic13:= Iif(oItemDetail:hasProperty("hasAdvance"),oItemDetail["hasAdvance"], .F.)       
       cIniPer := Iif(oItemDetail:hasProperty("initPeriod"), Format8601(.T.,oItemDetail["initPeriod"]), "")
       cEndPer := Iif(oItemDetail:hasProperty("endPeriod"), Format8601(.T.,oItemDetail["endPeriod"]), "")


       //validações diversas para férias
       cRestFault := fVldSolicFer(cBranchVld,cMatSRA,cIniVac)


       If empty(cRestFault)
          //busca dados do solicitante
          aEmployee := getSummary( cMatSRA, cBranchVld)

          //busca visão para a solicitação de férias
	      aVision := GetVisionAI8(cRoutine, cBranchVld)
	      cVision := aVision[1][1]

          //busca estrutura organizacional do workflow
          aGetStruct := APIGetStructure(cRD0Cod, SUPERGETMV("MV_ORGCFG"), cVision, cBranchVld, cMatSRA, , , , "B", cBranchVld, cMatSRA, ,)
          //varinfo("aGetStruct: ",aGetStruct)

          If valtype(aGetStruct[1]) == "L" .and. !aGetStruct[1] 
             cRestFault := alltrim( EncodeUTF8(aGetStruct[2]) +" - " +EncodeUTF8(aGetStruct[3]) ) 
          Else
             If Len(aGetStruct) >= 1 .And. !(Len(aGetStruct) == 3 .And. !aGetStruct[1])
                cEmpApr   := aGetStruct[1]:ListOfEmployee[1]:SupEmpresa
                cFilApr   := aGetStruct[1]:ListOfEmployee[1]:SupFilial
                nSupLevel := aGetStruct[1]:ListOfEmployee[1]:LevelSup
                cApprover := aGetStruct[1]:ListOfEmployee[1]:SupRegistration
             EndIf
          EndIf   
       EndIf


       If empty(cRestFault)

         //Prepara objeto RH3 Request
         oRequest              := WSClassNew("TRequest")
         oRequest:RequestType  := WSClassNew("TRequestType")
         oRequest:Status       := WSClassNew("TRequestStatus")

         oRequest:Code                               := GetSX8Num("RH3", "RH3_CODIGO",RetSqlName("RH3"))
         oRequest:RequestType:Code                   := "B"	                //Ferias
         oRequest:Status:Code                        := "1"
         oRequest:Origem                             := EncodeUTF8(STR0013) //MEURH
         oRequest:RequestDate                        := dDataBase
         oRequest:ResponseDate                       := CTod("")
         oRequest:Branch				             := cBranchVld
         oRequest:Registration		                 := cMatSRA
         oRequest:StarterKey                         := fBuscaChaveFuncionario(cBranchVld, cMatSRA, cVision)
         oRequest:StarterBranch		                 := cBranchVld           //pedido feito pelo próprio usuário do app
         oRequest:StarterRegistration	             := cMatSRA              //pedido feito pelo próprio usuário do app
         oRequest:Vision				             := cVision
         oRequest:Observation                        := Alltrim(STR0014 +" - " +aEmployee[2] +" - " +dToC(date()) +Space(1) +Time())
         oRequest:ApproverBranch                     := cFilApr
         oRequest:ApproverRegistration               := cApprover
         oRequest:ApproverLevel                      := nSupLevel

         //Utilizada tratativa do portal. Caso não exista aprovador, solicitação entrará como aprovada automaticamente.
         If Empty(cApprover)
            oRequest:ApproverLevel                   := 0
            oRequest:Status:Code                     := "4"
            oRequest:ResponseDate                    := dDataBase
         EndIf
         
         oRequest:EmpresaAPR                         := cEmpApr
         oRequest:Empresa                            := cEmpAnt

         //Prepara objeto RH4 Vacation
         oVacationRequest                            := WSClassNew("TVacation")
         oVacationRequest:Branch                     := cBranchVld
         oVacationRequest:Registration               := cMatSRA
         oVacationRequest:Name                       := aEmployee[2]
         oVacationRequest:InitialDate                := cIniVac
         oVacationRequest:FinalDate                  := cEndVac
         oVacationRequest:Days                       := nDias
         oVacationRequest:PecuniaryDays              := nDiasAbn
         oVacationRequest:PecuniaryAllowance         := Iif( nDiasAbn>0, ".T.", ".F.") 
         oVacationRequest:ThirteenthSalary1stInstall := Iif( lSolic13  , ".T.", ".F.")  


         Begin Transaction

             //Atualiza requisição diretamente em virtude da origem 
             DBSelectArea("RH3")
	         DBSetOrder(1)	//RH3_FILIAL+RH3_CODIGO

             Reclock("RH3", .T.)
             RH3->RH3_CODIGO	:= oRequest:Code
             RH3->RH3_FILIAL	:= oRequest:Branch
             RH3->RH3_MAT		:= oRequest:Registration
             RH3->RH3_TIPO		:= oRequest:RequestType:Code
             RH3->RH3_ORIGEM	:= "MEURH"
             RH3->RH3_DTSOLI	:= oRequest:RequestDate
             RH3->RH3_NVLINI	:= oRequest:StarterLevel
             RH3->RH3_FILINI	:= oRequest:StarterBranch
             RH3->RH3_MATINI	:= oRequest:StarterRegistration
             RH3->RH3_KEYINI	:= oRequest:StarterKey
             RH3->RH3_VISAO     := oRequest:Vision
             RH3->RH3_STATUS    := oRequest:Status:Code
             RH3->RH3_NVLAPR    := oRequest:ApproverLevel
             RH3->RH3_FILAPR    := oRequest:ApproverBranch
             RH3->RH3_MATAPR    := oRequest:ApproverRegistration

			 If RH3->(ColumnPos("RH3_EMP")) > 0 .AND. RH3->(ColumnPos("RH3_EMPINI")) > 0 .AND. RH3->(ColumnPos("RH3_EMPAPR")) > 0
				If Empty(oRequest:Empresa)
					oRequest:Empresa := cEmpAnt
				EndIf
			
				If Empty(oRequest:EmpresaAPR)
					oRequest:EmpresaAPR := cEmpAnt
				EndIf
			
				RH3->RH3_EMP	:= oRequest:Empresa
				RH3->RH3_EMPINI	:= cEmpAnt
				RH3->RH3_EMPAPR	:= oRequest:EmpresaAPR
			 ElseIf RH3->(ColumnPos("RH3_EMPAPR")) > 0
				RH3->RH3_EMPAPR	:= oRequest:EmpresaAPR
			 EndIf

             RH3->(MsUnlock())


             //Atualiza detalhes e histórico
             nReturnCode:= fAddVacationRequest(oVacationRequest, oRequest:Code, OPERATION_INSERT)
             If nReturnCode > 0
                cRestFault := EncodeUTF8(STR0028) //"Erro na inclusão da solicitação de férias"
                Break
             Else
                //complementa RH4 com os dados do período aquisito relacionado 
                BeginSQL ALIAS cAliasRH4
                   SELECT COUNT(*) QTD  FROM %table:RH4% RH4
                		  WHERE RH4.RH4_CODIGO = %exp:oRequest:Code%
                            AND RH4.RH4_FILIAL = %exp:oVacationRequest:Branch%
                            AND RH4.%NotDel%
                EndSQL

                If (cAliasRH4)->(!Eof()) .and. (cAliasRH4)->QTD > 0   
                   DBSelectArea("RH4")

                   Reclock("RH4", .T.)
                   RH4->RH4_FILIAL	:= oVacationRequest:Branch 
                   RH4->RH4_CODIGO	:= oRequest:Code
                   RH4->RH4_ITEM	:= (cAliasRH4)->QTD + 1
                   RH4->RH4_CAMPO	:= "RF_DATABAS"
                   RH4->RH4_VALNOV	:= cIniPer
                   RH4->(MsUnlock())

                   Reclock("RH4", .T.)
                   RH4->RH4_FILIAL	:= oVacationRequest:Branch 
                   RH4->RH4_CODIGO	:= oRequest:Code
                   RH4->RH4_ITEM	:= (cAliasRH4)->QTD + 2
                   RH4->RH4_CAMPO	:= "RF_DATAFIM"
                   RH4->RH4_VALNOV	:= cEndPer
                   RH4->(MsUnlock())
                EndIf
               (cAliasRH4)->( dbCloseArea() )

               
                //Atualiza histórico
                nReturnCode:= fPutHistory(oRequest, OPERATION_INSERT) //RGK - RDY
                If nReturnCode > 0
                   cRestFault := EncodeUTF8(STR0028) //"Erro na inclusão da solicitação de férias"
                   Break
                EndIf
             EndIf

         End Transaction

       EndIf
    EndIf 


    If empty(cRestFault) .And. lRet
       oMsgReturn["type"]      := "success"
       oMsgReturn["code"]      := "200"
       oMsgReturn["detail"]    := EncodeUTF8(STR0015) //"Atualização realizada com sucesso"
       Aadd(aMessages, oMsgReturn)

       //atualiza dados para o retorno
       oItemData["days"]          := nDias
       oItemData["vacationBonus"] := nDiasAbn
       oItemData["initVacation"]  := cIniVac
       oItemData["endVacation"]   := cEndVac
       oItemData["hasAdvance"]    := Iif(lSolic13, "true", "false")
       oItemData["initPeriod"]    := cIniPer
       oItemData["endPeriod"]     := cEndPer

       oItem["data"]              := oItemData
       oItem["messages"]          := aMessages
       oItem["length"]            := 1

       cJson :=  FWJsonSerialize(oItem, .F., .F., .T.)
       ::SetResponse(cJson)
    Else
       lRet := .F.
       SetRestFault(500, EncodeUTF8(cRestFault), .T.)
    EndIf

Return(lRet)


// -------------------------------------------------------------------
// - Atualização da edição de solicitação de férias.
// -------------------------------------------------------------------
WSMETHOD PUT putRequestVacation WSREST Vacation
Local cJsonObj       := "JsonObject():New()"
Local oItem          := &cJsonObj
Local oItemData      := &cJsonObj
Local oItemDetail    := &cJsonObj
Local oMsgReturn     := &cJsonObj
Local cBody          := ::GetContent()
Local aUrlParam      := ::aUrlParms
Local lRet           := .T.
Local aMessages      := {}
Local aParam         := {}

Local cRestFault     := ""
Local cBranchVld     := ""
Local cMatSRA        := ""
Local cToken         := ""
Local cJson          := ""
Local cKey           := ""

Local nDias          := 0
Local nDiasAbn       := 0
Local lSolic13       := .F.
Local cIniVac        := ""
Local cEndVac        := ""
Local cIniPer        := ""
Local cEndPer        := ""
Local cID            := ""

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken     := Self:GetHeader('Authorization')

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cLogin     := GetLoginHR(cToken)


    If !Empty(cBody)
	   oItemDetail:FromJson(cBody)
       cID     := Iif(oItemDetail:hasProperty("id"),oItemDetail["id"], "")

       nDias   := Iif(oItemDetail:hasProperty("days"),oItemDetail["days"], 0)
       nDiasAbn:= Iif(oItemDetail:hasProperty("vacationBonus"),oItemDetail["vacationBonus"], 0)
       cIniVac := Iif(oItemDetail:hasProperty("initVacation"), Format8601(.T.,oItemDetail["initVacation"]), "")
       cEndVac := Iif(oItemDetail:hasProperty("endVacation"), Format8601(.T.,oItemDetail["endVacation"]), "")
       cIniPer := Iif(oItemDetail:hasProperty("initPeriod"), Format8601(.T.,oItemDetail["initPeriod"]), "")
       cEndPer := Iif(oItemDetail:hasProperty("endPeriod"), Format8601(.T.,oItemDetail["endPeriod"]), "")

       If oItemDetail:hasProperty("hasAdvance") 
          //chegando com tipo caracter no PUT
          If (Valtype(oItemDetail["hasAdvance"]) == "L" .And. oItemDetail["hasAdvance"]) .Or. ;
             (Valtype(oItemDetail["hasAdvance"]) == "C" .And. oItemDetail["hasAdvance"] == ".T.")
             lSolic13 := .T.
          Else  
             lSolic13 := .F.
          EndIf       
       Else
          lSolic13 := .F.
       EndIf


       aParam := StrTokArr(cID , ",")
       cKey := aParam[2] + aParam[4]

       //Valida movimentação do workflow
       cRestFault := fVldWkf(cKey, aParam[4], "U")
    
       If empty(cRestFault)
          //validações diversas para férias
          cRestFault := fVldSolicFer(cBranchVld,cMatSRA,cIniVac)
       EndIf
    Else
       cRestFault := STR0026 //"Informações da requisição não recebida"
    EndIf

    
    If empty(cRestFault)
       //atualiza RH4
       Begin Transaction
           DBSelectArea("RH4")
           DBSetOrder(1)
           RH4->(DbSeek(RH3->(RH3_FILIAL + RH3_CODIGO)))

           While RH4->(RH4_FILIAL + RH4_CODIGO) == RH3->(RH3_FILIAL + RH3_CODIGO) .And. !RH4->(Eof())

              RecLock("RH4", .F.)
                 If AllTrim(RH4->RH4_CAMPO) == "R8_DATAINI"
                    RH4->RH4_VALANT := RH4->RH4_VALNOV
                    RH4->RH4_VALNOV := cIniVac
                 ElseIf AllTrim(RH4->RH4_CAMPO) == "R8_DATAFIM"
                    RH4->RH4_VALANT := RH4->RH4_VALNOV
                    RH4->RH4_VALNOV := cEndVac
                 ElseIf AllTrim(RH4->RH4_CAMPO) == "R8_DURACAO"
                    RH4->RH4_VALANT := RH4->RH4_VALNOV
                    RH4->RH4_VALNOV := AllTrim(Str(nDias))   
                 ElseIf AllTrim(RH4->RH4_CAMPO) == "TMP_ABONO"
                    RH4->RH4_VALANT := RH4->RH4_VALNOV
                    If nDiasAbn > 0  
                       RH4->RH4_VALNOV := ".T."
                    Else
                       RH4->RH4_VALNOV := ".F."
                    EndIf
                 ElseIf AllTrim(RH4->RH4_CAMPO) == "TMP_DABONO"
                    RH4->RH4_VALANT := RH4->RH4_VALNOV
                    RH4->RH4_VALNOV := AllTrim(Str(nDiasAbn))       
                 ElseIf AllTrim(RH4->RH4_CAMPO) == "TMP_1P13SL"
                    RH4->RH4_VALANT := RH4->RH4_VALNOV
                    If lSolic13  
                       RH4->RH4_VALNOV := ".T."
                    Else
                       RH4->RH4_VALNOV := ".F."
                    EndIf
                 EndIf
              MsUnLock()

              RH4->(DbSkip())
           EndDo
       End Transaction
    EndIf


    If empty(cRestFault)
       oMsgReturn["type"]      := "success"
       oMsgReturn["code"]      := "200"
       oMsgReturn["detail"]    := EncodeUTF8(STR0022) //"Alteração realizada com sucesso"

       Aadd(aMessages, oMsgReturn)

       If !Empty(cBody)
          //atualiza dados para o retorno
          oItemData["days"]          := nDias
          oItemData["vacationBonus"] := nDiasAbn
          oItemData["initVacation"]  := cIniVac
          oItemData["endVacation"]   := cEndVac
          oItemData["hasAdvance"]    := Iif(lSolic13, .T. , .F. )
          oItemData["initPeriod"]    := cIniPer
          oItemData["endPeriod"]     := cEndPer
       EndIf

       oItem["data"]                 := oItemData
       oItem["messages"]             := aMessages
       oItem["length"]               := 1

       cJson :=  FWJsonSerialize(oItem, .F., .F., .T.)
       ::SetResponse(cJson)

    Else
       lRet := .F.
       SetRestFault(500, EncodeUTF8(cRestFault), .T.)
    EndIf

Return(lRet)


// -------------------------------------------------------------------
// - Atualização da deleção de solicitação de férias.
// -------------------------------------------------------------------
WSMETHOD DELETE delRequestVacation WSREST Vacation
Local lRet           := .T.
Local cJsonObj       := "JsonObject():New()"
Local cBody          := ::GetContent()
Local aUrlParam      := ::aUrlParms
Local oItem          := &cJsonObj
Local oItemData      := &cJsonObj
Local oMsgReturn     := &cJsonObj
Local aMessages      := {}
Local aParam         := {}

Local cRestFault     := ""
Local cBranchVld     := ""
Local cMatSRA        := ""
Local cToken         := ""
Local cJson          := ""
Local cKey           := ""

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken     := Self:GetHeader('Authorization')

cMatSRA    := GetRegisterHR(cToken)
cBranchVld := GetBranch(cToken)
cLogin     := GetLoginHR(cToken)


    If !Empty(aUrlParam[1]) .And. aUrlParam[1] == "request"

       If Len(aUrlParam) == 3 .And. aUrlParam[3] != "undefined"
          //origem requisição DELETE
          aParam := StrTokArr(aUrlParam[3], ",")
       EndIf

       // "RH3" , Filial , Matricula , RH3_CODIGO , R_E_C_N_O_
       If len(aParam) != 5
          cRestFault := STR0023 //"Erro na requisição, parâmetros invalidos"
       EndIf
    EndIf
    
    cKey := aParam[2] + aParam[4]
 
    //Valida movimentação do workflow
    cRestFault := fVldWkf(cKey, aParam[4], "D")
    
    If empty(cRestFault)

       Begin Transaction
          RecLock("RH3",.F.)
          RH3->(dbDelete())
          RH3->(MsUnlock())

          DbSelectArea("RH4")
          RH4->( dbSetOrder(1) )
          RH4->( dbSeek(cKey) )
          While !Eof() .And. RH4->(RH4_FILIAL+RH4_CODIGO) == cKey;

             RecLock("RH4",.F.)
             RH4->(dbDelete())
             RH4->(MsUnlock())

             RH4->( dBSkip() )
          EndDo
       End Transaction

    EndIf

    If empty(cRestFault)
       HttpSetStatus(204)

       oMsgReturn["type"]      := "success"
       oMsgReturn["code"]      := "204"
       oMsgReturn["detail"]    := EncodeUTF8(STR0022) //"Exclusão realizada com sucesso"
       Aadd(aMessages, oMsgReturn)

       oItem["data"]           := oItemData
       oItem["messages"]       := aMessages
       oItem["length"]         := 1

       cJson :=  FWJsonSerialize(oItem, .F., .F., .T.)
       ::SetResponse(cJson)

    Else
       lRet := .F.
       SetRestFault(500, EncodeUTF8(cRestFault), .T.)
    EndIf

Return(lRet)


/*/{Protheus.doc} fVldSolicFer
   Validações genericas relacionadas as férias  
/*/
Function fVldSolicFer(cFil, cMat, cDataIni)
Local cMsgValid := ""
Local dHj30     := Date()+30

Local lRefTrab	:= FindFunction("fRefTrab") .And. fRefTrab("F")

Local cFilFun   := cFil
Local cMatFun   := cMat
Local dDataIni  := CTOD(cDataIni)
Local dDSR		:= CTOD("//")

  If lRefTrab
     If fFeriado( cFilFun, dDataIni ) //se data inicial for Feriado
		//retorna que dia é feriado
		cMsgValid := OemToAnsi(STR0018) + " (" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) + ")"  + OemToAnsi(STR0019) + "(" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) +  ")" + "."

     ElseIf fFeriado( cFilFun, dDataIni + 1 ) //se dia seguinte à data inicial for feriado
		//retorna que antecede feriado
		cMsgValid := OemToAnsi(STR0018) + " (" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) + ")"  + OemToAnsi(STR0019) + "(" + cValToChar(Day(dDataIni+1))+"/"+ cValToChar(Month(dDataIni+1)) + "/" + cValToChar(Year(dDataIni+1)) +  ")" + "."

     Else //verifica DSR
		dDSR := fVldDSR(cFilFun, cMatFun, dDataIni, 2, "D") //data do DSR
		If !Empty(dDSR) //retorna que antecede DSR
			cMsgValid := OemToAnsi(STR0018) + " (" + cValToChar(Day(dDataIni))+"/"+ cValToChar(Month(dDataIni)) + "/" + cValToChar(Year(dDataIni)) + ")"  + OemToAnsi(STR0020) + "(" + cValToChar(Day(dDSR))+"/"+ cValToChar(Month(dDSR)) + "/" + cValToChar(Year(dDSR)) +  ")" + "."
		EndIf
     EndIf
  EndIf


  If Empty(cMsgValid)
     //valida finais de semana
     nDOW := DOW(dDataIni)
     If nDow == 7
        cMsgValid := OemToAnsi(STR0016) //"O início das férias não poderá ocorrer em um sábado"
     ElseIf nDow == 1
        cMsgValid := OemToAnsi(STR0017) //"O início das férias não poderá ocorrer em um domingo"
     EndIf

  EndIf

  If Empty(cMsgValid)
     If dDataIni < dHj30
		cMsgValid := OemToAnsi(STR0021) //"As férias devem ser solicitadas com pelo menos 30 dias de antecedência."
     EndIf
  EndIf

Return( cMsgValid )


/*/{Protheus.doc} fVldWkf
   Validações para movimentação do workflow  
/*/
Function fVldWkf(cKey, cReq, cOper)
local cMsgFault := ""

default cKey  := ""
default cReq  := ""
default cOper := ""

    If cOper == "U" .or. cOper == "D"
    
       DBSelectArea("RH3")
       DBSetOrder(1)	//RH3_FILIAL+RH3_CODIGO
       If RH3->( dbSeek(cKey) )
          If RH3_NVLAPR != RH3_NVLINI   

             If Val( GetRGKSeq( cReq , .T.) ) == 2
                cMsgFault := ""
             Else
                cMsgFault := STR0024 //"Não será possível executar a requisição, pois o workflow foi movimentado"    
             EndIf
          EndIf
       Else   
          cMsgFault := STR0025 //"Identificador da solicitação não localizado"
       EndIf

    ElseIf cOper == "I"
       
        If Val( GetRGKSeq( cReq , .T.) ) == 2
           cMsgFault := ""
        Else
           cMsgFault := STR0024 //"Não será possível executar a requisição, pois o workflow foi movimentado"    
        EndIf
    EndIf

Return( cMsgFault )
