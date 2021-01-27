#INCLUDE "WSAPD018.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 20

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддддд©╠╠
╠╠ЁFuncao    ЁWSAPD018  Ё Autor ЁMarcelo Faria          Ё Data Ё05.04.2016  Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддддд╢╠╠
╠╠ЁDescricao Ё Web Service responsavel pela avaliaГЦo consolidada           Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё Portal GCH                                                   Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Atualizacoes sofridas desde a Construcao Inicial.                       Ё╠╠
╠╠цддддддддддддддбддддддддбддддддбдддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Responsavel  Ё Data   ЁTarefaЁ  Motivo da Alteracao                     Ё╠╠ 
╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/

Function WSAPD018()
Return .T.


//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDefinicao da Estrutura dos campos                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды

WSSTRUCT TPolicyData
    WSDATA ItemsTotal                   AS Integer                OPTIONAL
    WSDATA ItemsOfPolicy                AS Array Of   PolicyCabec   OPTIONAL
ENDWSSTRUCT

WSSTRUCT PolicyCabec
    WSDATA BranchPolicyID               As String     OPTIONAL     //Filial da Politica
    WSDATA PolicyID                     As String     OPTIONAL     //ID da Politica
    WSDATA PolicyDesc                   As String     OPTIONAL     //Descricao da Politica
    WSDATA PercCompetence               As Float      OPTIONAL     //Peso Percentual sobre competencias
    WSDATA PercGoal                     As Float      OPTIONAL     //Peso Percentual sobre metas
    WSDATA PercFormation                As Float      OPTIONAL     //Peso Percentual sobre formacao academica
    WSDATA RegID                        As Integer    OPTIONAL     //ID do Registro
    WSDATA ItemsTotalDetail             AS Integer    OPTIONAL
    WSDATA ItemsOfPolicyDetail          AS Array Of   PolicyDetail   OPTIONAL
ENDWSSTRUCT

WSSTRUCT PolicyDetail
    WSDATA PeriodID                     As String     OPTIONAL     //ID do Periodo
    WSDATA PeriodDesc                   As String     OPTIONAL     //Descricao da Licenca
    WSDATA PeriodType                   As String     OPTIONAL     //Tipo do Periodo
    WSDATA PeriodTypeDesc               As String     OPTIONAL     //DescriГЦo do Tipo do Periodo
    WSDATA PeriodInitialDate            As String     OPTIONAL		//Data inicial do perМodo
    WSDATA PeriodFinalDate              As String     OPTIONAL		//Data final do perМodo
ENDWSSTRUCT

WSSTRUCT TConsolidatedData 
    WSDATA Participant		            As String     OPTIONAL     //Codigo do Participante
    WSDATA Name                         As String				    //Nome do funcionario
    WSDATA PolicyID                     As String                  //ID da Politica Consolidada
    WSDATA PolicyDesc                   As String     OPTIONAL     //Descricao da Politica
    WSDATA ItemsTotalGoals              AS Integer                       OPTIONAL
    WSDATA ItemsTotalAssessments        AS Integer                       OPTIONAL
    WSDATA ItemsTotalOthers             AS Integer                       OPTIONAL
    WSDATA ItemsOfConsolidated          AS Array Of   ConsolidatedResult OPTIONAL
ENDWSSTRUCT

WSSTRUCT ConsolidatedResult
    WSDATA Group                        As String     OPTIONAL     //Grupo 
    WSDATA GroupDesc                    As String     OPTIONAL     //DescriГЦo do Grupo 
    WSDATA Key                          As String     OPTIONAL     //Chave do grupo
    WSDATA KeyDesc                      As String     OPTIONAL     //DescriГЦo da Chave do grupo
    WSDATA Weight                       As String     OPTIONAL     //Peso
    WSDATA ProfitFor                    As String     OPTIONAL     //Resultado Obtido
    WSDATA PartialAverage               As String     OPTIONAL     //MИdia Parcial
    WSDATA TotalAverage                 As String     OPTIONAL     //MИdia Final
    WSDATA ProcessDate                  As String     OPTIONAL		//Data de processamento
ENDWSSTRUCT


//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDefinicao do Web Service de Saldo de Dias de Folga   Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
WSSERVICE  RHAPDConsolidated            DESCRIPTION STR0001   //Resultados Consolidadas
   WSDATA WsNull                        As String   OPTIONAL  //NULL
   
   WSDATA EmployeeFil                   As String   OPTIONAL	//Filial do funcionario
   WSDATA Registration                  As String   OPTIONAL	//Codigo da matricula
   WSDATA ParticipantId                 As String   OPTIONAL	//Codigo do Participante
   WSDATA TypeOrg                       As String   OPTIONAL	//Verifica se a Arquitetura Organizacional И por Posto ou Departamento
   WSDATA Vision                        As String   OPTIONAL	//Visao
   WSDATA Page                          As Integer  OPTIONAL	//Numero da Pagina, para paginacao
   WSDATA PageLength                    As Integer  OPTIONAL	//Total de Registros por pАgina
   WSDATA FilterField                   As String   OPTIONAL	//Campo para filtro
   WSDATA FilterValue                   As String   OPTIONAL	//Condicao de filtro das querys
   WSDATA RankingOrder                  As String   OPTIONAL	//Tipo de solicitaГЦo

   WSDATA EmployeeData                  As TEmployeeData	   //Estrutura Organizacional

   WSDATA Policy                        AS String   OPTIONAL   //Politica Consolidada
   WSDATA PolicyData                    As TPolicyData         //InformaГУes das Politicas Consolidadas

   WSDATA ConsolidatedData              As TConsolidatedData   //InformaГУes de resultado do funcionАrio para a polМtica consolidada

   WSMETHOD GetStructRanking            DESCRIPTION STR0002    //Metodo para listar a estrutura organizacional e ranking consolidado
   WSMETHOD GetPolicies                 DESCRIPTION STR0003    //Metodo para buscar as politicas consolidadas
   WSMETHOD GetConsolidated             DESCRIPTION STR0004    //Metodo para buscar resultado consolidado do funcionario
ENDWSSERVICE


/*/
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддддддддддддбдддддддбддддддддддддддддддддбдддддбддддддддддд©╠╠
╠╠ЁMetodo    ЁGetConsolidated     Ё Autor ЁMarcelo Faria        ЁData Ё05.04.2016 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддадддддддаддддддддддддддддддддадддддаддддддддддд╢╠╠
╠╠ЁDescricao ЁMetodo para buscar resultado consolidado do funcionario             Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       ЁPortal GCH                                                          Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
WSMETHOD GetConsolidated WSRECEIVE Policy, ParticipantID WSSEND ConsolidatedData WSSERVICE RHAPDConsolidated 
Local nP                  := 1
Local nI                  := 0
Local cWhere              := ""
Local cQueryRIZ           := GetNextAlias()

DEFAULT Self:Policy       := ""
DEFAULT Self:ParticipantID:= ""

    ::ConsolidatedData                       := WsClassNew('TConsolidatedData')
    ::ConsolidatedData:Participant           := ""
    ::ConsolidatedData:Name                  := ""
    ::ConsolidatedData:PolicyID              := ""
    ::ConsolidatedData:PolicyDesc            := ""
    ::ConsolidatedData:ItemsTotalGoals       := 0
    ::ConsolidatedData:ItemsTotalAssessments := 0
    ::ConsolidatedData:ItemsTotalOthers      := 0
    ::ConsolidatedData:ItemsOfConsolidated   := {}

    If Self:Policy == "" .or. Self:ParticipantID == ""
       return .T.
    EndIf    

    dbSelectArea("RD0")
    RD0->( dbSetOrder(1) )
    If RD0->( dbSeek(xFilial("RD0") + Self:ParticipantID ))
       ::ConsolidatedData:Participant        := RD0->RD0_CODIGO
       ::ConsolidatedData:Name               := RD0->RD0_NOME
    Else
		SetSoapFault("GetConsolidated",PorEncode(STR0008)) //"Participante nЦo encontrado"
       return .T.
    EndIf    

    dbSelectArea("RIX")
    RIX->( dbSetOrder(1) )
    If RIX->( dbSeek(xFilial("RIX") + Self:Policy ))
       ::ConsolidatedData:PolicyID           := RIX->RIX_CODIGO
       ::ConsolidatedData:PolicyDesc         := RIX->RIX_DESC
    Else
		SetSoapFault("GetConsolidated",PorEncode(STR0009)) //"Politica nЦo encontrada"
       return .T.
    EndIf    


    //Busca RIZ (Resultado Consolidado)
    //*********************************
    cWhere := "%"
    cWhere += " AND RIZ.RIZ_CODRD0  = '" + RD0->RD0_CODIGO + "'"
    cWhere += " AND RIZ.RIZ_IDCONS  = '" + RIX->RIX_CODIGO + "'"
    cWhere += "%"

    BeginSql alias cQueryRIZ
        SELECT *
        FROM %table:RIZ% RIZ
        WHERE RIZ.%notDel%               
              %exp:cWhere%
        Order by RIZ.RIZ_GRUPO, RIZ.RIZ_KEY        
    EndSql 
    //varinfo('LastQuery',GetLastQuery()[2])

    While !(cQueryRIZ)->(Eof())

         aadd(::ConsolidatedData:ItemsOfConsolidated,WsClassNew('ConsolidatedResult'))
         ::ConsolidatedData:ItemsOfConsolidated[nP]:Group          := (cQueryRIZ)->RIZ_GRUPO
         ::ConsolidatedData:ItemsOfConsolidated[nP]:Key            := (cQueryRIZ)->RIZ_KEY
         ::ConsolidatedData:ItemsOfConsolidated[nP]:Weight         := str((cQueryRIZ)->RIZ_PESO)
         ::ConsolidatedData:ItemsOfConsolidated[nP]:ProfitFor      := str((cQueryRIZ)->RIZ_RESOBT)
         ::ConsolidatedData:ItemsOfConsolidated[nP]:PartialAverage := str((cQueryRIZ)->RIZ_MEDPAR)
         ::ConsolidatedData:ItemsOfConsolidated[nP]:TotalAverage   := str((cQueryRIZ)->RIZ_MEDTOT)
         ::ConsolidatedData:ItemsOfConsolidated[nP]:ProcessDate    := (cQueryRIZ)->RIZ_DTCALC

         If (cQueryRIZ)->RIZ_GRUPO == "01" //Metas
            ::ConsolidatedData:ItemsTotalGoals                   += 1
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0010)

            dbSelectArea("RDU")
            RDU->( dbSetOrder(1) )
            If RDU->( dbSeek(xFilial("RDU") + (cQueryRIZ)->RIZ_KEY ))
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := RDU->RDU_DESC
            Else
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := ""
            EndIf    
            
         ElseIf (cQueryRIZ)->RIZ_GRUPO == "02" //Desempenho  
            ::ConsolidatedData:ItemsTotalAssessments             += 1
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0011)

            dbSelectArea("RD6")
            RD6->( dbSetOrder(1) )
            If RD6->( dbSeek(xFilial("RD6") + (cQueryRIZ)->RIZ_KEY ))
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := RD6->RD6_DESC
            Else
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := ""
            EndIf

         ElseIf (cQueryRIZ)->RIZ_GRUPO == "03" //Outras pontuaГУes  
            ::ConsolidatedData:ItemsTotalOthers += 1
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0012)

            If !Empty((cQueryRIZ)->RIZ_KEYDSC) 
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := (cQueryRIZ)->RIZ_KEYDSC
            Else
               ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc := ""
            EndIf
         
         ElseIf (cQueryRIZ)->RIZ_GRUPO == "99" //Consolidado  
            ::ConsolidatedData:ItemsOfConsolidated[nP]:GroupDesc := PorEncode(STR0013)
            ::ConsolidatedData:ItemsOfConsolidated[nP]:KeyDesc   := ""
         EndIf            
            
         nP++
         (cQueryRIZ)->(dbSkip())
    EndDo

   (cQueryRIZ)->(dbCloseArea())

Return .T.



/*/
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддддддддддддбдддддддбддддддддддддддддддддбдддддбддддддддддд©╠╠
╠╠ЁMetodo    ЁGetStructRanking    Ё Autor ЁMarcelo Faria        ЁData Ё05.04.2016 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддадддддддаддддддддддддддддддддадддддаддддддддддд╢╠╠
╠╠ЁDescricao ЁMetodo para listar a estrutura organizacional e ranking consolidado Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       ЁPortal GCH                                                          Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
WSMETHOD GetStructRanking WSRECEIVE Policy, ParticipantID, TypeOrg, Vision, EmployeeFil, Registration, Page, PageLength, FilterValue, FilterField, RankingOrder WSSEND EmployeeData WSSERVICE RHAPDConsolidated 
	Local lRetorno         	:= .T.
	Local lQryResp       	:= .F.
	Local lCont          	:= .T.
	Local nPos   	     		:= 0
	Local nPosItem   	   		:= 0
	Local nReg		     		:= 0
	Local nFunc		    	:= 0
	Local cItem  	     		:= ""
	Local cChave         	:= ""
	Local cLike          	:= ""
	Local cDeptos        	:= ""
	Local cRespDeptos    	:= ""
	Local cNome          	:= ""
	Local cParticipantId 	:= ""
	Local cRD4Alias      	:= "QRD4"
	Local cRIZAlias      	:= "QRIZ"
	Local cAuxAlias      	:= "QAUX"
	Local cVision
	Local cEmpSM0	     		:= SM0->M0_CODIGO
	Local aChvItem	   		:= {}
	Local aRet           	:= {}
	Local aDeptos	     		:= {}
	Local aSuperior      	:= {}
	Local PageLen  			:= 20
	Local nX 			 		:= 0
	Local nJ		     		:= 1
	Local nRecCount 	 		:= 0
	Local cWhere    	 		:= ""
	Local cWhereOrder	 		:= ""
	Local cAuxAlias1 	 		:= GetNextAlias()
	Local cAuxAlias2     	:= GetNextAlias()
	Local cChaveComp     	:= ""
	Local nTamEmpFil	 		:= TamSX3("RDZ_FILENT")[1]	//Tamanho do campo RDZ_FILENT
	Local nTamRegist	 		:= TamSX3("RDZ_CODENT")[1]	//Tamanho do campo RDZ_CODENT
	Local cCampoMat
	Local cEmpFil
	Local cRegist
	Local cCampo
	Local cChaveItem			:= ""
	Local cFiltro				:= ""
	Local cFilRD4				:= ""
	Local cFilSQB				:= ""
	Local cFilSRA				:= ""
	Local cMatSup		       := ""
	
	DEFAULT Self:Policy         := ""
	DEFAULT Self:ParticipantID  := ""
	DEFAULT Self:TypeOrg 		:= ""
	DEFAULT Self:Vision 	  		:= ""
	DEFAULT Self:EmployeeFil		:= ""
	DEFAULT Self:Registration	:= ""
	DEFAULT Self:Page 			:= 1
	DEFAULT Self:PageLength		:= PAGE_LENGTH
	DEFAULT Self:FilterField		:= ""
	DEFAULT Self:FilterValue		:= ""
	DEFAULT Self:RankingOrder	:= "desc"
	
	cVision  := Self:Vision
	cCampo	  := Self:FilterField
	cFiltro  := Self:FilterValue

	If Empty(self:Policy)
		SetSoapFault("GetStructRanking",PorEncode(STR0007))	 //"Politica nЦo informada"
		Return .T.
	EndIf	

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ёcheca o tipo de estrutura - Departamentos/Postos                             Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !TipoOrg(@::TypeOrg, cVision)
		SetSoapFault("GetStructRanking",PorEncode(STR0005))	 //"Visao nЦo encontrada"
		Return .T.
	EndIf


	If Empty(::ParticipantID)
		If !Empty(::EmployeeFil) .and. !Empty(::Registration)
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁPrepara corretamente tamanho campo para busca no RDZ                         Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cEmpFil := ::EmployeeFil  + Space(nTamEmpFil - Len(self:EmployeeFil))
			cRegist := ::Registration + Space(nTamRegist - (Len(self:Registration)+Len(cEmpFil)))
			
			dbSelectArea("RDZ")
			RDZ->( dbSetOrder(1) ) //RDZ_FILIAL+RDZ_EMPENT+RDZ_FILENT+RDZ_ENTIDA+RDZ_CODENT+RDZ_CODRD0
			If RDZ->( dbSeek(xFilial("RDZ") + cEmpSM0 + xFilial("SRA", cEmpFil) + "SRA" + cEmpFil + cRegist))
				dbSelectArea("RD0")
				RD0->( dbSetOrder(1) ) //RD0_FILIAL+RD0_CODIGO
				If RD0->( dbSeek(xFilial("RD0") + RDZ->RDZ_CODRD0) )
					cParticipantId := RD0->RD0_CODIGO
				EndIf
			EndIf
		EndIf
	Else
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁLocalizar o funcionАrio(SRA) a partir do ID logado (participante - RD0)      Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cParticipantId := ::ParticipantID
	EndIf


	If Participant(cParticipantId , aRet, , ::Registration)
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁDepartamento (sem visao)                                                     Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

		If ::TypeOrg == "0"
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁMonta a estrutura de departamentos                                           Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			aDeptos := fEstrutDepto( aRet[3] )
			
			cItem  := ""
			cLike  := ""
			cChave := ""
		EndIf
		
		dbSelectArea("SRA")
		SRA->( dbSetOrder(1) )
		SRA->( dbSeek(aRet[3] +aRet[1] ) )
		
		::EmployeeData:ListOfEmployee := {}
		aadd(::EmployeeData:ListOfEmployee,WsClassNew('DataEmployee'))
		nFunc++
		::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial 	    := aRet[3]
		::EmployeeData:ListOfEmployee[nFunc]:Registration  		:= aRet[1]
		::EmployeeData:ListOfEmployee[nFunc]:ParticipantID		:= cParticipantId
		::EmployeeData:ListOfEmployee[nFunc]:Name          		:= AllTrim(aRet[2])
		::EmployeeData:ListOfEmployee[nFunc]:AdmissionDate 		:= DTOC(aRet[5])
		::EmployeeData:ListOfEmployee[nFunc]:Department    		:= aRet[8]
		::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment	    := fDesc('SQB',aRet[8],'SQB->QB_DESCRIC',,,1)
		::EmployeeData:ListOfEmployee[nFunc]:Item          		:= cItem
		::EmployeeData:ListOfEmployee[nFunc]:KeyVision       	:= cChave
		::EmployeeData:ListOfEmployee[nFunc]:LevelHierar		   := (len(Alltrim(cChave))/3)-1
		::EmployeeData:ListOfEmployee[nFunc]:TypeEmployee		:= "1"
		::EmployeeData:ListOfEmployee[nFunc]:Situacao			   := SRA->RA_SITFOLH
		::EmployeeData:ListOfEmployee[nFunc]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + SRA->RA_SITFOLH, "X5DESCRI()", NIL, aRet[3]))
		::EmployeeData:ListOfEmployee[nFunc]:FunctionId      	:= SRA->RA_CODFUNC
		::EmployeeData:ListOfEmployee[nFunc]:FunctionDesc    	:= Alltrim(Posicione('SRJ',1,xFilial("SRJ", SRA->RA_FILIAL)+SRA->RA_CODFUNC,'SRJ->RJ_DESC'))
		::EmployeeData:ListOfEmployee[nFunc]:CostId           	:= SRA->RA_CC
		::EmployeeData:ListOfEmployee[nFunc]:Cost             	:= Alltrim(Posicione('CTT',1,xFilial("CTT",SRA->RA_FILIAL)+Alltrim(SRA->RA_CC),'CTT->CTT_DESC01'))
		::EmployeeData:ListOfEmployee[nFunc]:PositionId			:= SRA->RA_CARGO
		::EmployeeData:ListOfEmployee[nFunc]:Position           := Alltrim(Posicione('SQ3',1,xFilial("SQ3")+SRA->RA_CARGO,'SQ3->Q3_DESCSUM'))
		::EmployeeData:ListOfEmployee[nFunc]:FunctionSubst      := .F.
		::EmployeeData:ListOfEmployee[nFunc]:Salary			    := SRA->RA_SALARIO
		::EmployeeData:ListOfEmployee[nFunc]:FilialDescr	       := Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
		::EmployeeData:ListOfEmployee[nFunc]:CatFunc		       := SRA->RA_CATFUNC
		::EmployeeData:ListOfEmployee[nFunc]:CatFuncDesc	       := Alltrim(FDESC("SX5","28"+SRA->RA_CATFUNC,"X5DESCRI()"))
		::EmployeeData:ListOfEmployee[nFunc]:PossuiSolic        := .F.
    	::EmployeeData:ListOfEmployee[nFunc]:ResultConsolid		:= "0" 

       //Resultado do Ranking Consolidado
        cWhere := "%"
        cWhere += " AND RIZ_CODRD0 = '" + cParticipantId + "'" 
        cWhere += " AND RIZ_IDCONS = '" + Self:Policy    + "'"
        cWhere += " AND RIZ_GRUPO  = '" + "99"           + "'"
        cWhere += " AND RIZ_KEY    = '" + "000000"       + "'"
        cWhere += "%"

        BeginSql alias cRIZAlias
           SELECT *
              FROM %table:RIZ% RIZ
           WHERE RIZ.%notDel%               
           %exp:cWhere%
        EndSql 
        If !(cRIZAlias)->(Eof())
	    	 ::EmployeeData:ListOfEmployee[nFunc]:ResultConsolid	:= str((cRIZAlias)->RIZ_MEDTOT)
        EndIf 
       (cRIZAlias)->(dbCloseArea())

		If ::TypeOrg == "0"
			If (nPos := aScan(aDeptos, {|x| x[1] == aRet[8]})) > 0
				cChave := aDeptos[nPos][5]
				::EmployeeData:ListOfEmployee[nFunc]:KeyVision    := cChave
				::EmployeeData:ListOfEmployee[nFunc]:LevelHierar  := (len(Alltrim(cChave))/3)-1
			EndIf
		EndIf
		
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁBusca Informacoes do superior                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		aSuperior := fBuscaSuperior(aRet[3], aRet[1], aRet[8], aDeptos, ::TypeOrg, cVision)
		
		If Len(aSuperior) > 0
			::EmployeeData:ListOfEmployee[nFunc]:SupFilial      	    := aSuperior[1][1]
			::EmployeeData:ListOfEmployee[nFunc]:SupRegistration	   := aSuperior[1][2]
			::EmployeeData:ListOfEmployee[nFunc]:NameSup      		:= aSuperior[1][3]
			::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= aSuperior[1][4]
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncSup      	:= aSuperior[1][6]
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncDescSup  	:= Alltrim(FDESC("SX5","28"+aSuperior[1][6],"X5DESCRI()"))
		Else
			::EmployeeData:ListOfEmployee[nFunc]:SupFilial      	   := ""
			::EmployeeData:ListOfEmployee[nFunc]:SupRegistration	   := ""
			::EmployeeData:ListOfEmployee[nFunc]:NameSup      		:= ""
			::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= 99
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncSup      	:= ""
			::EmployeeData:ListOfEmployee[nFunc]:CatFuncDescSup 	   := ""
		EndIf
		
		cMatSup := EmployeeData:ListOfEmployee[nFunc]:Registration

		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁDados da Equipe                                                              Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁDepartamento (sem visao)                                                     Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If ::TypeOrg == "0"
			For nPos := 1 to Len(aDeptos)
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁVerifica quais departamentos o funcionario logado И responsАvel				Ё
				//ЁaDeptos[nPos][2] -> Filial        											Ё
				//ЁaDeptos[nPos][3] -> Matricula												Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If aDeptos[nPos][2] == aRet[3] .and. aDeptos[nPos][3] == aRet[1]
					cChave      := aDeptos[nPos][5]
					
					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁVerifica quais departamentos estЦo abaixo do departamento					Ё
					//Ёque o funcionario logado И responsАvel										Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					For nReg := 1 to Len(aDeptos)
						If aDeptos[nReg][5] == cChave
							cRespDeptos += "'" + aDeptos[nReg][1] + "',"
						ElseIf (substr(aDeptos[nReg][5],1,len(cChave)) == cChave .and. len(aDeptos[nReg][5]) == len(cChave) + 3)
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//ЁArmazena todos os departamentos que o funcionАrio logado tem acesso          Ё
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							cDeptos     += "'" + aDeptos[nReg][1] + "',"
						EndIf
					Next nReg
				EndIf
			Next nPos
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁVerifica se tem acesso a algum departamento e                                Ё
			//Ёseleciona todos os funcionАrios de todos os departamentos que o              Ё
			//ЁfuncionАrio loagado tem acesso                                               Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If !Empty(cDeptos) .or. !Empty(cRespDeptos)
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁSelecionar a equipe do funcionario logado                                    Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cWhere := "%"
				If !Empty(cFiltro) .AND. !Empty(cCampo)
					If(cCampo == "1")
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ёcodigo                                                                       Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cWhere += " AND SRA.RA_MAT LIKE '%" + Replace(cFiltro,"'","") + "%'"
					ElseIf(cCampo == "2")
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ёnome                                                                         Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cWhere += " AND SRA.RA_NOME LIKE '%" + Replace(cFiltro,"'","") + "%'"
					ElseIf(cCampo == "3")
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ёadmissao                                                                     Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cWhere += " AND SRA.RA_ADMISSA LIKE '%" + Replace(dToS(cToD(cFiltro)),"'","") + "%'"
					ElseIf(cCampo == "4")
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ёdepartamento                                                                 Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cWhere += " AND SRA.RA_DEPTO LIKE '%" + Replace(cFiltro,"'","") + "%'"
					ElseIf(cCampo == "5")
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ёsituacao                                                                     Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cWhere += " AND SRA.RA_SITFOLH LIKE '%" + Replace(cFiltro,"'","") + "%'"
					EndIf
				EndIf
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁFaz validacao do modo de acesso do Departamento                                             Ё
				//ЁCompartilhado: nao faz filtro da filial do SRA e traz funcionarios do departamento          Ё
				//ЁExclusivo: faz filtro da filial do SRA de acordo com a filial do responsavel do departamentoЁ
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If !Empty( xFilial("SQB") )
					cWhere += " AND SRA.RA_FILIAL = '" + aRet[3] + "'"
				EndIf
				
              cWhereOrder := cWhere + " order by RIZ.RIZ_MEDTOT " +Self:RankingOrder +", RD0.RD0_NOME%"
				cWhere += "%"
				
				cRespDeptos := "%(" + substr(cRespDeptos, 1, len(cRespDeptos)-1)+ ")%"
				If Empty(cDeptos)
					cDeptos := "%('')%"
				Else
					cDeptos := "%(" + substr(cDeptos, 1, len(cDeptos)-1)+ ")%"
				EndIf
				
				BeginSql alias cRD4Alias
					
					SELECT
					SRA.RA_SITFOLH,
					SRA.RA_FILIAL,
					SRA.RA_MAT,
					RD0.RD0_NOME,
					RD0.RD0_CODIGO,
					SRA.RA_NOMECMP,
					SRA.RA_NOME,
					SRA.RA_ADMISSA,
					SRA.RA_DEPTO,
					SRA.RA_SITFOLH,
					SRA.RA_CC,
					SRA.RA_CARGO,
					SRA.RA_CODFUNC,
					SRA.RA_SALARIO,
					SRA.RA_CATFUNC,
					SRA.RA_HRSMES,
					SRA.RA_REGIME,
					RIZ.RIZ_MEDTOT
					
					FROM %table:SRA% SRA
					LEFT JOIN %table:RDZ% RDZ
					ON RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
					RDZ.RDZ_FILIAL = %xfilial:RDZ%           AND
					RDZ.RDZ_EMPENT = %exp:cEmpSM0%           AND
					RDZ.%notdel%
					
					LEFT JOIN %table:RD0% RD0
					ON RD0.RD0_CODIGO = RDZ.RDZ_CODRD0       AND
					RD0.RD0_FILIAL = %xfilial:RD0%           AND
					RD0.%notdel%

					LEFT JOIN %table:RIZ% RIZ
					ON 	RIZ.RIZ_FILIAL = %xfilial:RIZ%        AND
					RIZ.RIZ_CODRD0 = RDZ.RDZ_CODRD0           AND
					RIZ.RIZ_IDCONS = %exp:self:Policy%        AND
					RIZ.RIZ_GRUPO = '99'                      AND
					RIZ.%notdel%

					WHERE SRA.RA_DEPTO in %exp:cRespDeptos%  AND
					SRA.RA_SITFOLH <> 'D'                    AND
					SRA.RA_MAT NOT IN (%exp: cMatSup%)       AND
					SRA.%notDel%
					
					%exp:cWhere%
					
					UNION
					SELECT SRA.RA_SITFOLH,SRA.RA_FILIAL, SRA.RA_MAT, RD0.RD0_NOME, RD0.RD0_CODIGO, SRA.RA_NOMECMP, SRA.RA_NOME, SRA.RA_ADMISSA,
					SRA.RA_DEPTO, SRA.RA_SITFOLH, SRA.RA_CC, SRA.RA_CARGO, SRA.RA_CODFUNC,SRA.RA_SALARIO,SRA.RA_CATFUNC,SRA.RA_HRSMES,RIZ.RIZ_MEDTOT

					FROM %table:SQB% SQB
					INNER JOIN %table:SRA% SRA
					ON SQB.QB_FILRESP = SRA.RA_FILIAL AND
					SQB.QB_MATRESP = SRA.RA_MAT
					LEFT JOIN %table:RDZ% RDZ

					ON RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
					RDZ.RDZ_FILIAL = %xfilial:RDZ%          AND
					RDZ.RDZ_EMPENT = %exp:cEmpSM0%          AND
					RDZ.%notdel%

					LEFT JOIN %table:RD0% RD0
					ON RD0.RD0_CODIGO = RDZ.RDZ_CODRD0       AND
					RD0.RD0_FILIAL = %xfilial:RD0%           AND
					RD0.%notdel%

					LEFT JOIN %table:RIZ% RIZ
					ON 	RIZ.RIZ_FILIAL = %xfilial:RIZ%        AND
					RIZ.RIZ_CODRD0 = RDZ.RDZ_CODRD0           AND
					RIZ.RIZ_IDCONS = %exp:self:Policy%        AND
					RIZ.RIZ_GRUPO = '99'                      AND
					RIZ.%notdel%

					WHERE SQB.QB_DEPTO IN  %exp:cDeptos%     AND
					SRA.RA_SITFOLH <> 'D'                    AND
					SQB.QB_FILIAL  = %xfilial:SQB%           AND
					SRA.RA_MAT NOT IN (%exp: cMatSup%)       AND
					SQB.%notDel%                             AND
					SRA.%notDel%

					%exp:cWhereOrder%
				EndSql
              //varinfo('LastQuery',GetLastQuery()[2])
				
				COUNT TO nRecCount
				(cRD4Alias)->(DbGoTop())
				
				::EmployeeData:PagesTotal := Ceiling(nRecCount / Self:PageLength)
				If ::Page > 1
					(cRD4Alias)->(DBSkip((::Page-1) * Self:PageLength))
				EndIf
				
				While (cRD4Alias)->( !Eof() ) ;
						.AND. Len(::EmployeeData:ListOfEmployee) <= Self:PageLength
					
					cNome := alltrim(If(! Empty((cRD4Alias)->RA_NOMECMP),(cRD4Alias)->RA_NOMECMP,If(! Empty((cRD4Alias)->RD0_NOME),(cRD4Alias)->RD0_NOME,(cRD4Alias)->RA_NOME)))
					
					If (cRD4Alias)->RA_FILIAL + (cRD4Alias)->RA_MAT <> aRet[3] + aRet[1] .and.;
							(cRD4Alias)->RA_SITFOLH <> 'D'
						nFunc++
						aAdd(::EmployeeData:ListOfEmployee,WsClassNew('DataEmployee'))
						::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial 	    := (cRD4Alias)->RA_FILIAL
						::EmployeeData:ListOfEmployee[nFunc]:Registration  		:= (cRD4Alias)->RA_MAT
						::EmployeeData:ListOfEmployee[nFunc]:ParticipantID  	   := (cRD4Alias)->RD0_CODIGO
						::EmployeeData:ListOfEmployee[nFunc]:Name          		:= AllTrim(cNome)
						::EmployeeData:ListOfEmployee[nFunc]:AdmissionDate 		:= If(valtype((cRD4Alias)->RA_ADMISSA)== "D",DTOC((cRD4Alias)->RA_ADMISSA),DTOC(STOD((cRD4Alias)->RA_ADMISSA)))
						::EmployeeData:ListOfEmployee[nFunc]:Department    		:= (cRD4Alias)->RA_DEPTO
						::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment	   := Alltrim(Posicione('SQB',1,xFilial("SQB")+(cRD4Alias)->RA_DEPTO,'SQB->QB_DESCRIC'))
						::EmployeeData:ListOfEmployee[nFunc]:Item          		:= ""
						::EmployeeData:ListOfEmployee[nFunc]:TypeEmployee		:= "2"
						::EmployeeData:ListOfEmployee[nFunc]:SupFilial        	:= ::EmployeeData:ListOfEmployee[1]:EmployeeFilial
						::EmployeeData:ListOfEmployee[nFunc]:SupRegistration	   := ::EmployeeData:ListOfEmployee[1]:Registration
						::EmployeeData:ListOfEmployee[nFunc]:NameSup    		    := aRet[2]
						::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= ::EmployeeData:ListOfEmployee[1]:LevelHierar
						::EmployeeData:ListOfEmployee[nFunc]:CatFuncSup     	   := ::EmployeeData:ListOfEmployee[1]:CatFunc
						::EmployeeData:ListOfEmployee[nFunc]:CatFuncDescSup 	   := ::EmployeeData:ListOfEmployee[1]:CatFuncDesc
						::EmployeeData:ListOfEmployee[nFunc]:Situacao			   := (cRD4Alias)->RA_SITFOLH
						::EmployeeData:ListOfEmployee[nFunc]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + (cRD4Alias)->RA_SITFOLH, "X5DESCRI()", NIL, (cRD4Alias)->RA_FILIAL))
						::EmployeeData:ListOfEmployee[nFunc]:CostId				:= (cRD4Alias)->RA_CC
						::EmployeeData:ListOfEmployee[nFunc]:Cost				   := Alltrim(Posicione('CTT',1,xFilial("CTT",(cRD4Alias)->RA_FILIAL)+(cRD4Alias)->RA_CC,'CTT->CTT_DESC01'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionId			:= (cRD4Alias)->RA_CODFUNC
						::EmployeeData:ListOfEmployee[nFunc]:FunctionDesc   	   := Alltrim(Posicione('SRJ',1,xFilial("SRJ", SRA->RA_FILIAL)+(cRD4Alias)->RA_CODFUNC,'SRJ->RJ_DESC'))
						::EmployeeData:ListOfEmployee[nFunc]:PositionId     	    := (cRD4Alias)->RA_CARGO
						::EmployeeData:ListOfEmployee[nFunc]:Position           := Alltrim(Posicione('SQ3',1,xFilial("SQ3")+(cRD4Alias)->RA_CARGO,'SQ3->Q3_DESCSUM'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionSubst      := .F.
						::EmployeeData:ListOfEmployee[nFunc]:Salary			   := (cRD4Alias)->RA_SALARIO
						::EmployeeData:ListOfEmployee[nFunc]:Total			   := 1
						::EmployeeData:ListOfEmployee[nFunc]:FilialDescr	       := Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
						::EmployeeData:ListOfEmployee[nFunc]:CatFunc		       := (cRD4Alias)->RA_CATFUNC
						::EmployeeData:ListOfEmployee[nFunc]:CatFuncDesc	       := Alltrim(FDESC("SX5","28"+(cRD4Alias)->RA_CATFUNC,"X5DESCRI()"))
						::EmployeeData:ListOfEmployee[nFunc]:PossuiSolic 		:= .F.
						::EmployeeData:ListOfEmployee[nFunc]:Polity   		:=  (cRD4Alias)->RA_REGIME
						::EmployeeData:ListOfEmployee[nFunc]:ResultConsolid	    := str((cRD4Alias)->RIZ_MEDTOT)

						
						If (nPos := aScan(aDeptos, {|x| x[1] == (cRD4Alias)->RA_DEPTO})) > 0
							cChave := aDeptos[nPos][5]
							::EmployeeData:ListOfEmployee[nFunc]:KeyVision   := cChave
							::EmployeeData:ListOfEmployee[nFunc]:LevelHierar	:= (len(Alltrim(cChave))/3)-1
						EndIf
						
						BEGINSQL alias cAuxAlias1
							SELECT
							SQB.QB_DEPTO
							FROM %table:SQB% SQB
							WHERE SQB.QB_FILRESP = %exp:(cRD4Alias)->RA_FILIAL% AND
							SQB.QB_MATRESP = %exp:(cRD4Alias)->RA_MAT%   AND
							SQB.%notDel%
						EndSql
						
						If !(cAuxAlias1)->(Eof())
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe := .T.
						Else
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe := .F.
						EndIf
						(cAuxAlias1)->(dbCloseArea())
						
					EndIf
					(cRD4Alias)->( DbSkip() )
				EndDo
				(cRD4Alias)->( DbCloseArea() )
			EndIf
			


		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁPosto                                                           Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		ElseIf ::TypeOrg == "1"
		
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁSelecionar a equipe do funcionario logado                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cWhere := "%"
			If !Empty(cFiltro) .AND. !Empty(cCampo)
				If(cCampo == "1")
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁCodigo                                                          Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_MAT LIKE '%" + Replace(cFiltro,"'","") + "%'"
				ElseIf(cCampo == "2")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁNome                                                            Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_NOME LIKE '%" + Replace(cFiltro,"'","") + "%'"
				ElseIf(cCampo == "3")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁAdmissa                                                         Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_ADMISSA LIKE '%" + Replace(dToS(cToD(cFiltro)),"'","") + "%'"
				ElseIf(cCampo == "4")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁDepartamento                                                    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_DEPTO LIKE '%" + Replace(cFiltro,"'","") + "%'"
				ElseIf(cCampo == "5")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁSituacao                                                        Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_SITFOLH LIKE '%" + Replace(cFiltro,"'","") + "%'"
				EndIf
			EndIf

          cWhereOrder := cWhere + " order by RIZ.RIZ_MEDTOT " +Self:RankingOrder +", RD0.RD0_NOME%"
			cWhere += "%"
			
			BEGINSQL ALIAS cRD4Alias
				SELECT
				SRA.RA_SITFOLH,
				SRA.RA_FILIAL,
				SRA.RA_MAT,
				RD0.RD0_NOME,
				RD0.RD0_CODIGO,
				SRA.RA_NOME,
				SRA.RA_NOMECMP,
				SRA.RA_ADMISSA,
				SRA.RA_DEPTO,
				RD4.RD4_ITEM,
				RD4.RD4_TREE,
				RD4.RD4_CHAVE,
				SRA.RA_CC,
				SRA.RA_CARGO,
				SRA.RA_CODFUNC,
				SRA.RA_SALARIO,
				SRA.RA_CATFUNC,
				SRA.RA_HRSMES,
                RIZ.RIZ_MEDTOT
              				
				FROM %table:RD4% RD4
				INNER JOIN %table:RCX% RCX ON RCX.RCX_POSTO = RD4.RD4_CODIDE
				
				INNER JOIN %table:SRA% SRA ON RCX.RCX_FILFUN = SRA.RA_FILIAL	AND
				RCX.RCX_MATFUN = SRA.RA_MAT
				
				LEFT JOIN %table:RDZ% RDZ  ON RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
				RDZ.RDZ_FILIAL = %xfilial:RDZ%    AND
				RDZ.RDZ_EMPENT = %exp:cEmpSM0%    AND
				RDZ.%notdel%
				
				LEFT JOIN %table:RD0% RD0  ON RD0.RD0_CODIGO = RDZ.RDZ_CODRD0   AND
				RD0.RD0_FILIAL = %xfilial:RD0%    AND
				RD0.%notdel%

				LEFT JOIN %table:RIZ% RIZ
				ON 	RIZ.RIZ_FILIAL = %xfilial:RD0%  AND
				RIZ.RIZ_CODRD0 = RDZ.RDZ_CODRD0    AND
				RIZ.RIZ_IDCONS = %exp:self:Policy% AND
				RIZ.RIZ_GRUPO = '99'               AND
				RIZ.%notdel%
				
				WHERE SRA.RA_SITFOLH <> 'D'        AND
				RCX.RCX_SUBST  = '2'				   AND
				RCX.RCX_TIPOCU = '1'               AND
				RCX.RCX_FILIAL = %xfilial:RCX%     AND
				RD4.RD4_TREE   = %exp:cItem%       AND
				RD4.RD4_CODIGO = %exp:cVision%     AND
				RD4.RD4_FILIAL = %xfilial:RD4%     AND
				RD4.%notDel%                       AND
				SRA.%notDel%                       AND
				RCX.%notDel%
				%exp:cWhere%
				
			EndSql
			
			COUNT TO nRecCount
			(cRD4Alias)->(DbGoTop())
			
			::EmployeeData:PagesTotal := Ceiling(nRecCount / Self:PageLength)
			If ::Page > 1
				(cRD4Alias)->(DBSkip((::Page-1) * Self:PageLength))
			EndIf
			
			While (cRD4Alias)->( !Eof() ) .AND.;
					Len(::EmployeeData:ListOfEmployee) <= Self:PageLength
				nFunc++
				nX++
				If ::Page == 0 .Or. nX >= ::Page
					aAdd(::EmployeeData:ListOfEmployee,WsClassNew('DataEmployee'))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:EmployeeFilial    := (cRD4Alias)->RA_FILIAL
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Registration  	    := (cRD4Alias)->RA_MAT
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:ParticipantID 	    := (cRD4Alias)->RD0_CODIGO
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Name          	    := AllTrim(if(! Empty((cRD4Alias)->RA_NOMECMP),(cRD4Alias)->RA_NOMECMP,If(!Empty((cRD4Alias)->RD0_NOME),(cRD4Alias)->RD0_NOME,(cRD4Alias)->RA_NOME)))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:AdmissionDate 	    := DTOC(STOD((cRD4Alias)->RA_ADMISSA))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Department    	    := (cRD4Alias)->RA_DEPTO
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:DescrDepartment    := Posicione('SQB',1,xFilial("SQB")+(cRD4Alias)->RA_DEPTO,'SQB->QB_DESCRIC')
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Item          	    := (cRD4Alias)->RD4_ITEM
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:SupFilial      	 := ::EmployeeData:ListOfEmployee[1]:EmployeeFilial
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:SupRegistration	 := ::EmployeeData:ListOfEmployee[1]:Registration
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:NameSup            := aRet[2]
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:KeyVision      	 := (cRD4Alias)->RD4_CHAVE
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:LevelHierar		 := (len(Alltrim((cRD4Alias)->RD4_CHAVE))/3)-1
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:TypeEmployee       := "2"
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:LevelSup      	     := ::EmployeeData:ListOfEmployee[1]:LevelHierar
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Situacao			 := (cRD4Alias)->RA_SITFOLH
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:DescSituacao		 := AllTrim(fDesc("SX5", "31" + (cRD4Alias)->RA_SITFOLH, "X5DESCRI()", NIL, (cRD4Alias)->RA_FILIAL))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:CostId			     := (cRD4Alias)->RA_CC
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Cost				 := Alltrim(Posicione('CTT',1,xFilial("CTT",(cRD4Alias)->RA_FILIAL)+(cRD4Alias)->RA_CC,'CTT->CTT_DESC01'))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:FunctionId     	 := (cRD4Alias)->RA_CODFUNC
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:FunctionDesc   	 := Alltrim(Posicione('SRJ',1,xFilial("SRJ")+(cRD4Alias)->RA_CODFUNC,'SRJ->RJ_DESC'))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:PositionId      	 := (cRD4Alias)->RA_CARGO
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Position           := Alltrim(Posicione('SQ3',1,xFilial("SQ3")+(cRD4Alias)->RA_CARGO,'SQ3->Q3_DESCSUM'))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:FunctionSubst      := .F.
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:Salary				 := (cRD4Alias)->RA_SALARIO
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:total       		 := nRecCount
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:FilialDescr		 := Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:CatFunc		    	 := (cRD4Alias)->RA_CATFUNC
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:CatFuncDesc		 := Alltrim(FDESC("SX5","28"+(cRD4Alias)->RA_CATFUNC,"X5DESCRI()"))
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:PossuiSolic 		 := .F.
					::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:ResultConsolid		 := str((cRD4Alias)->RIZ_MEDTOT)
					
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁVerificar se o funcionario listado no array possui equipe.      Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If len(alltrim((cRD4Alias)->RD4_CHAVE)) == 18
						cChaveComp := alltrim((cRD4Alias)->RD4_CHAVE) + '01'
					Else
						cChaveComp := alltrim((cRD4Alias)->RD4_CHAVE) + '001'
					Endif
					
					BEGINSQL alias cAuxAlias1
						SELECT
						RD4.RD4_ITEM,
						RD4.RD4_TREE,
						RD4.RD4_CHAVE
						FROM %table:RD4% RD4
						WHERE RD4_CODIGO  = %exp:cVision%     AND
						RD4.RD4_CHAVE     = %exp:cChaveComp%  AND
						RD4.%notDel%
					EndSql
					
					If !(cAuxAlias1)->(Eof())
						::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:PossuiEquipe := .T.
					Else
						::EmployeeData:ListOfEmployee[len(::EmployeeData:ListOfEmployee)]:PossuiEquipe := .F.
					EndIf
					(cAuxAlias1)->(dbCloseArea())
					
					If(valtype(PageLen)) == "C"
						PageLen = val(PageLen)
					EndIf
					
					If len(::EmployeeData:ListOfEmployee) >= PageLen .And. PageLen <> 0
						Exit
					EndIf
				EndIf
				(cRD4Alias)->( DbSkip() )
			EndDo
			(cRD4Alias)->( DbCloseArea() )


		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁDepartamento (com visao)                                        Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		ElseIf ::TypeOrg == "2"

			cWhere := "%"
			If !Empty(cFiltro) .AND. !Empty(cCampo)
				If(cCampo == "1")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁMatricula                                                       Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_MAT LIKE '%" + Replace(cFiltro,"'","") + "%'"
				ElseIf(cCampo == "2")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁNome                                                            Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_NOME LIKE '%" + Replace(cFiltro,"'","") + "%'"
				ElseIf(cCampo == "3")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁAdmissao                                                        Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_ADMISSA LIKE '%" + Replace(dToS(cToD(cFiltro)),"'","") + "%'"
				ElseIf(cCampo == "4")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁDepartamento                                                    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_DEPTO LIKE '%" + Replace(cFiltro,"'","") + "%'"
				ElseIf(cCampo == "5")
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁSituacao                                                        Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cWhere += " AND SRA.RA_SITFOLH LIKE '%" + Replace(cFiltro,"'","") + "%'"
				EndIf
			EndIf

           cWhereOrder := cWhere + " order by RIZ.RIZ_MEDTOT " +Self:RankingOrder +", RD0.RD0_NOME%"
			cWhere += "%"
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁFaz validacao do modo de acesso do Departamento                                             Ё
			//ЁCompartilhado: nao faz filtro da filial do SRA e traz funcionarios do departamento          Ё
			//ЁExclusivo: faz filtro da filial do SRA de acordo com a filial do responsavel do departamentoЁ
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If Empty( xFilial("SQB") )
				cFilRD4 := "%%"
				cFilSQB := "%'" + xFilial("SQB") + "'%"
				cFilSRA := "%%"
			Else
				cFilRD4 := "%RD4.RD4_FILIDE = '" + xFilial( 'SQB', aRet[3] ) + "' AND%"
				cFilSQB := "%'" + xFilial( 'SQB', aRet[3] ) + "'%"
				cFilSRA := "%SRA.RA_FILIAL  = '" + xFilial( "SRA", aRet[3] ) + "' AND%"
			EndIf
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁBusca as chaves dos departamentso que o funcionario e' responsavel para verificar           Ё
			//Ёtodos os departamentos abaixo do nivel hierarquico da chave                                 Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			BeginSQL ALIAS cRD4Alias
				SELECT RD4.RD4_CHAVE, RD4.RD4_ITEM
				FROM %table:SQB% SQB
				INNER JOIN %table:RD4% RD4 ON RD4.RD4_CODIDE = SQB.QB_DEPTO
				WHERE RD4.RD4_CODIGO = %exp:cVision% AND
				%exp:cFilRD4%
				RD4.RD4_FILIAL = %xfilial:RD4% AND
				SQB.QB_FILRESP = %exp:aRet[3]% 	AND
				SQB.QB_MATRESP = %exp:aRet[1]% 	AND
				SQB.QB_FILIAL  = %exp:cFilSQB% 	AND
				RD4.%notDel%                   AND
				SQB.%notDel%
			EndSQL
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁMonta o filtro da instrucao Like de todos os departamentos que o funcionario e' o responsavelЁ
			//ЁSe nao for responsavel por nenhum, nao ira trazer de nenhum departamento                     Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			While (cRD4Alias)->( !Eof() )
				If aScan( aChvItem, { |aChvItem| aChvItem[1] == AllTrim( (cRD4Alias)->RD4_ITEM ) } ) == 0
					aAdd( aChvItem, { AllTrim( (cRD4Alias)->RD4_ITEM ) } )
				EndIf
				lQryResp	:= .T.
				(cRD4Alias)->( dbSkip() )
			End While
			If lQryResp
				cChaveItem := "% RD4.RD4_ITEM IN ("
				For nPosItem := 1 To Len(aChvItem)
					cChaveItem += "'" + aChvItem[nPosItem, 1] + "' ,"
				Next nPosItem
				cChaveItem := SubStr( cChaveItem, 1, Len(cChaveItem) - 2 )
				cChaveItem += ") %"
			Else
				cChaveItem := "% RD4.RD4_ITEM = 'ZZZZZZ' %"
			EndIf
			(cRD4Alias)->( dbCloseArea() )
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁSelecionar todos os departamentos que o funcionario logado И responsАvelЁ
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			BEGINSQL ALIAS cRD4Alias
				SELECT
				SRA.RA_SITFOLH,
				SRA.RA_FILIAL,
				SRA.RA_MAT,
				RD0.RD0_NOME,
				RD0.RD0_CODIGO,
				SRA.RA_NOME,
				SRA.RA_NOMECMP,
				SRA.RA_ADMISSA,
				SRA.RA_DEPTO,
				RD4.RD4_ITEM,
				RD4.RD4_TREE,
				RD4.RD4_CHAVE,
				SRA.RA_CC,
				SRA.RA_CARGO,
				SRA.RA_CODFUNC,
				SRA.RA_SALARIO,
				SRA.RA_CATFUNC,
				SRA.RA_HRSMES,
				RIZ.RIZ_MEDTOT
				
				FROM %table:SQB% SQB
				INNER JOIN %table:RD4% RD4 ON RD4.RD4_CODIDE = SQB.QB_DEPTO

				INNER JOIN %table:SRA% SRA ON SRA.RA_FILIAL  = SQB.QB_FILRESP AND
				SRA.RA_MAT = SQB.QB_MATRESP

				LEFT JOIN %table:RDZ% RDZ  ON RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
				RDZ.RDZ_FILIAL = %xfilial:RDZ%    		  AND
				RDZ.RDZ_EMPENT = %exp:cEmpSM0%    		  AND
				RDZ.%notdel%

				LEFT JOIN %table:RD0% RD0  ON RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 AND
				RD0.RD0_FILIAL = %xfilial:RD0%    		  AND
				RD0.%notdel%

				LEFT JOIN %table:RIZ% RIZ  ON RIZ.RIZ_FILIAL = %xfilial:RD0%   AND
				RIZ.RIZ_CODRD0 = RDZ.RDZ_CODRD0           AND
				RIZ.RIZ_IDCONS = %exp:self:Policy%        AND
				RIZ.RIZ_GRUPO = '99'                      AND
     			RIZ.%notdel%
				
				WHERE RD4.RD4_CODIGO = %exp:cVision%  AND
				RD4.RD4_FILIAL = %xfilial:RD4%        AND
				SRA.RA_SITFOLH <> 'D'			       AND
				RD4.RD4_TREE IN (
				
				SELECT RD4SUP.RD4_ITEM
				FROM %table:SQB% SQB
				INNER JOIN %table:RD4% RD4SUP ON RD4SUP.RD4_CODIDE = SQB.QB_DEPTO
				WHERE RD4SUP.RD4_CODIGO = %exp:cVision% AND
				RD4SUP.RD4_FILIAL = %xfilial:RD4%       AND
				SQB.QB_FILRESP = %exp:aRet[3]% 	        AND
				SQB.QB_MATRESP = %exp:aRet[1]% 	        AND
				SQB.QB_FILIAL  = %exp:cFilSQB% 	        AND
				RD4SUP.%notDel%                        AND
				SQB.%notDel%)                          AND

				SQB.QB_FILIAL  = %exp:cFilSQB%         AND
				RD4.%notdel%                           AND
				SQB.%notdel%

				UNION
				SELECT
				SRA.RA_SITFOLH,
				SRA.RA_FILIAL,
				SRA.RA_MAT,
				RD0.RD0_NOME,
				RD0.RD0_CODIGO,
				SRA.RA_NOME,
				SRA.RA_NOMECMP,
				SRA.RA_ADMISSA,
				SRA.RA_DEPTO,
				RD4.RD4_ITEM,
				RD4.RD4_TREE,
				RD4.RD4_CHAVE,
				SRA.RA_CC,
				SRA.RA_CARGO,
				SRA.RA_CODFUNC,
				SRA.RA_SALARIO,
				SRA.RA_CATFUNC,
				SRA.RA_HRSMES,
                RIZ.RIZ_MEDTOT				
				
				FROM %table:RD4% RD4
				INNER JOIN %table:SRA% SRA ON %exp:cFilSRA%
				SRA.RA_DEPTO = RD4.RD4_CODIDE

				LEFT JOIN %table:RDZ% RDZ  ON RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT AND
				RDZ.RDZ_FILIAL = %xfilial:RDZ%    		  AND
				RDZ.RDZ_EMPENT = %exp:cEmpSM0%    		  AND
				RDZ.%notdel%

				LEFT JOIN %table:RD0% RD0  ON RD0.RD0_CODIGO = RDZ.RDZ_CODRD0   		  AND
				RD0.RD0_FILIAL = %xfilial:RD0%    		  AND
				RD0.%notdel%

				LEFT JOIN %table:RIZ% RIZ ON RIZ.RIZ_FILIAL = %xfilial:RD0% AND
				RIZ.RIZ_CODRD0 = RDZ.RDZ_CODRD0           AND
				RIZ.RIZ_IDCONS = %exp:self:Policy%        AND
				RIZ.RIZ_GRUPO = '99'                      AND
				RIZ.%notdel%

				WHERE RD4.RD4_CODIGO = %exp:cVision%    AND
				%exp:cFilRD4%
				RD4.RD4_FILIAL = %xfilial:RD4%  	     AND
				SRA.RA_SITFOLH <> 'D'			   	     AND
				%exp:cChaveItem%		  				     AND
				SRA.%notDel%                    	     AND
				RD4.%notDel%
				
				%exp:cWhere%
				
			EndSql
			
			While (cRD4Alias)->( !Eof() )
				If (cRD4Alias)->RA_FILIAL + (cRD4Alias)->RA_MAT <> aRet[3] + aRet[1]
					If aScan( EmployeeData:ListOfEmployee, {|x| AllTrim( x:EmployeeFilial ) == AllTrim( (cRD4Alias)->RA_FILIAL ) .And. AllTrim( x:Registration ) == AllTrim( (cRD4Alias)->RA_MAT ) } ) == 0
						nFunc++
						aadd(::EmployeeData:ListOfEmployee,WsClassNew('DataEmployee'))
						::EmployeeData:ListOfEmployee[nFunc]:EmployeeFilial  	:= (cRD4Alias)->RA_FILIAL
						::EmployeeData:ListOfEmployee[nFunc]:Registration  		:= (cRD4Alias)->RA_MAT
						::EmployeeData:ListOfEmployee[nFunc]:ParticipantID  	   := (cRD4Alias)->RD0_CODIGO
						::EmployeeData:ListOfEmployee[nFunc]:Name          		:= AllTrim(If(! Empty((cRD4Alias)->RA_NOMECMP),(cRD4Alias)->RA_NOMECMP,If(!Empty((cRD4Alias)->RD0_NOME),(cRD4Alias)->RD0_NOME,(cRD4Alias)->RA_NOME)))						
						::EmployeeData:ListOfEmployee[nFunc]:AdmissionDate 		:= DTOC(STOD((cRD4Alias)->RA_ADMISSA))
						::EmployeeData:ListOfEmployee[nFunc]:Department    		:= (cRD4Alias)->RA_DEPTO
						::EmployeeData:ListOfEmployee[nFunc]:DescrDepartment   	:= Alltrim(Posicione('SQB',1,xFilial("SQB")+(cRD4Alias)->RA_DEPTO,'SQB->QB_DESCRIC'))
						::EmployeeData:ListOfEmployee[nFunc]:Item          		:= (cRD4Alias)->RD4_ITEM
						::EmployeeData:ListOfEmployee[nFunc]:SupFilial      	   := ::EmployeeData:ListOfEmployee[1]:EmployeeFilial
						::EmployeeData:ListOfEmployee[nFunc]:SupRegistration	   := ::EmployeeData:ListOfEmployee[1]:Registration
						::EmployeeData:ListOfEmployee[nFunc]:NameSup      		:= aRet[2]
						::EmployeeData:ListOfEmployee[nFunc]:KeyVision       	:= (cRD4Alias)->RD4_CHAVE
						::EmployeeData:ListOfEmployee[nFunc]:LevelHierar		   := (len(Alltrim((cRD4Alias)->RD4_CHAVE))/3)-1
						::EmployeeData:ListOfEmployee[nFunc]:TypeEmployee		:= "2"
						::EmployeeData:ListOfEmployee[nFunc]:LevelSup      		:= ::EmployeeData:ListOfEmployee[1]:LevelHierar
						::EmployeeData:ListOfEmployee[nFunc]:Situacao			   := (cRD4Alias)->RA_SITFOLH
						::EmployeeData:ListOfEmployee[nFunc]:DescSituacao		:= AllTrim(fDesc("SX5", "31" + (cRD4Alias)->RA_SITFOLH, "X5DESCRI()", NIL, (cRD4Alias)->RA_FILIAL))
						::EmployeeData:ListOfEmployee[nFunc]:CostId				:= (cRD4Alias)->RA_CC
						::EmployeeData:ListOfEmployee[nFunc]:Cost				    := Alltrim(Posicione('CTT',1,xFilial("CTT",(cRD4Alias)->RA_FILIAL)+(cRD4Alias)->RA_CC,'CTT->CTT_DESC01'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionId       	:= (cRD4Alias)->RA_CODFUNC
						::EmployeeData:ListOfEmployee[nFunc]:FunctionDesc     	:= Alltrim(Posicione('SRJ',1,xFilial("SRJ", SRA->RA_FILIAL)+(cRD4Alias)->RA_CODFUNC,'SRJ->RJ_DESC'))
						::EmployeeData:ListOfEmployee[nFunc]:PositionId     	    := (cRD4Alias)->RA_CARGO
						::EmployeeData:ListOfEmployee[nFunc]:Position            := Alltrim(Posicione('SQ3',1,xFilial("SQ3")+(cRD4Alias)->RA_CARGO,'SQ3->Q3_DESCSUM'))
						::EmployeeData:ListOfEmployee[nFunc]:FunctionSubst       := .F.
						::EmployeeData:ListOfEmployee[nFunc]:Salary			    := (cRD4Alias)->RA_SALARIO
						::EmployeeData:ListOfEmployee[nFunc]:total               := 1
						::EmployeeData:ListOfEmployee[nFunc]:FilialDescr	        := Alltrim(Posicione("SM0",1,cnumemp,"M0_FILIAL"))
						::EmployeeData:ListOfEmployee[nFunc]:CatFunc		        := (cRD4Alias)->RA_CATFUNC
						::EmployeeData:ListOfEmployee[nFunc]:CatFuncDesc	        := Alltrim(FDESC("SX5","28"+(cRD4Alias)->RA_CATFUNC,"X5DESCRI()"))
						::EmployeeData:ListOfEmployee[nFunc]:PossuiSolic 	     := .F.
						::EmployeeData:ListOfEmployee[nFunc]:ResultConsolid		 := str((cRD4Alias)->RIZ_MEDTOT)
						
						//Busca as chaves dos departamentso que o funcionario e' responsavel para verificar
						//todos os departamentos abaixo do nivel hierarquico da chave
						BeginSQL ALIAS cAuxAlias1
							SELECT RD4.RD4_ITEM
							FROM %table:SQB% SQB
							INNER JOIN %table:RD4% RD4 ON RD4.RD4_CODIDE = SQB.QB_DEPTO
							WHERE RD4.RD4_CODIGO = %exp:cVision% AND
							RD4.RD4_FILIAL = %xfilial:RD4% AND
							%exp:cFilRD4%
							SQB.QB_FILRESP = %exp:(cRD4Alias)->RA_FILIAL% AND
							SQB.QB_MATRESP = %exp:(cRD4Alias)->RA_MAT% 	AND
							SQB.QB_FILIAL  = %exp:cFilSQB% 	              AND
							RD4.%notDel%                                  AND
							SQB.%notDel%
						EndSQL
						
						If !(cAuxAlias1)->(Eof())
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe := .T.
						Else
							::EmployeeData:ListOfEmployee[nFunc]:PossuiEquipe := .F.
						EndIf
						(cAuxAlias1)->(dbCloseArea())
						
					EndIf
				EndIf
				(cRD4Alias)->( DbSkip() )
			EndDo
			
			(cRD4Alias)->( DbCloseArea() )

       EndIf
	Else
		lRetorno := .F.
		SetSoapFault("GetStructure3",PorEncode(STR0006))	 //"Participante nao encontrado no cadastro de funcionАrios."
	EndIf
	
RETURN lRetorno



/*/
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддддддддддддбдддддддбддддддддддддддддддддбдддддбддддддддддд©╠╠
╠╠ЁMetodo    ЁGetPolicies         Ё Autor ЁMarcelo Faria        ЁData Ё05.04.2016 Ё╠╠
╠╠цддддддддддедддддддддддддддддддддадддддддаддддддддддддддддддддадддддаддддддддддд╢╠╠
╠╠ЁDescricao ЁMetodo para buscar politica de avaliacao consolidada                Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       ЁPortal GCH                                                          Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
WSMETHOD GetPolicies WSRECEIVE Policy WSSEND PolicyData WSSERVICE RHAPDConsolidated
Local nP         := 1
Local nI         := 0
Local cWhere     := ""
Local cQueryRIX  := GetNextAlias()
Local cQueryRIY  := GetNextAlias()
Local aBoxTipo   := RetSx3Box( Posicione("SX3", 2, "RDU_TIPO", "X3CBox()" ),,, 1 )

DEFAULT Self:Policy := ""

    //Busca RIX (CabeГalho da Politica)
    //*********************************
    cWhere := "%"
    cWhere += " AND RIX_STATUS <> '2'" //cancelado
    cWhere += " AND RIX_PORTAL = '1'"  //mostra no portal
    If !empty(Self:Policy)
       cWhere += " AND RIX_CODIGO = '" + Self:Policy  + "'"
    EndIf
    cWhere += "%"

    BeginSql alias cQueryRIX
        SELECT *
        FROM %table:RIX% RIX
        WHERE RIX.%notDel%               
              %exp:cWhere%
    EndSql 

    ::PolicyData               := WsClassNew('TPolicyData')
    ::PolicyData:ItemsTotal    := 0
    ::PolicyData:ItemsOfPolicy := {}

    While !(cQueryRIX)->(Eof())
         ::PolicyData:ItemsTotal  += 1

         aadd(::PolicyData:ItemsOfPolicy,WsClassNew('PolicyCabec'))
         ::PolicyData:ItemsOfPolicy[nP]:BranchPolicyID       := (cQueryRIX)->RIX_FILIAL
         ::PolicyData:ItemsOfPolicy[nP]:PolicyID             := (cQueryRIX)->RIX_CODIGO
         ::PolicyData:ItemsOfPolicy[nP]:PolicyDesc           := (cQueryRIX)->RIX_DESC
         ::PolicyData:ItemsOfPolicy[nP]:PercCompetence       := (cQueryRIX)->RIX_PERCOM
         ::PolicyData:ItemsOfPolicy[nP]:PercGoal             := (cQueryRIX)->RIX_PERMET
         ::PolicyData:ItemsOfPolicy[nP]:PercFormation        := (cQueryRIX)->RIX_PERFOR
         ::PolicyData:ItemsOfPolicy[nP]:RegID                := (cQueryRIX)->R_E_C_N_O_
         ::PolicyData:ItemsOfPolicy[nP]:ItemsTotalDetail     := 0
         ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail  := {}

         //Busca RIY (Detalhes da Politica)  
         //********************************
         cWhere := "%"
         cWhere += " AND RIY_FILIAL = '" + (cQueryRIX)->RIX_FILIAL  + "'"
         cWhere += " AND RIY_CODIGO = '" + (cQueryRIX)->RIX_CODIGO  + "'"
         cWhere += "%"

         BeginSql alias cQueryRIY
            SELECT *
            FROM %table:RIY% RIY
            WHERE RIY.%notDel%               
                 %exp:cWhere%
         EndSql 

         nI := 1
         While !(cQueryRIY)->(Eof())
            ::PolicyData:ItemsOfPolicy[nP]:ItemsTotalDetail += 1

            aadd(::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail,WsClassNew('PolicyDetail'))
            ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodID             := (cQueryRIY)->RIY_CODPER
  
            dbSelectArea("RDU")
            RDU->( dbSetOrder(1) )
            If RDU->( dbSeek(xFilial("RDU", (cQueryRIY)->RIY_FILIAL) + (cQueryRIY)->RIY_CODPER) )
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodDesc        := RDU->RDU_DESC
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodType        := RDU->RDU_TIPO
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodTypeDesc    := Alltrim(aBoxTipo[Ascan( aBoxTipo, { |aBox| aBox[2] = RDU->RDU_TIPO } )][3])
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodInitialDate := DToS(RDU->RDU_DATINI)
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodFinalDate   := DToS(RDU->RDU_DATFIM)
            Else 
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodDesc        := "PerМodo nЦo localizado!"
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodType        := ""
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodTypeDesc    := ""
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodInitialDate := ""
               ::PolicyData:ItemsOfPolicy[nP]:ItemsOfPolicyDetail[nI]:PeriodFinalDate   := ""
            EndIf
            RDU->( DbCloseArea() )

            nI++    
            (cQueryRIY)->(dbSkip())
         EndDo
        (cQueryRIY)->(dbCloseArea())
            
        nP++
        (cQueryRIX)->(dbSkip())
    EndDo


   (cQueryRIX)->(dbCloseArea())

Return .T.

