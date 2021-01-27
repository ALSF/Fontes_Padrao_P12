#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

Function WSTCF010()
Return

WSSTRUCT TArtifactList
	WSDATA Company		As String
	WSDATA Branch		As String
	WSDATA Code			As String
	WSDATA Category		As String
	WSDATA TitleLink	As String
	WSDATA Message		As String
	WSDATA ActionLink	AS String
	WSDATA Alias		As String
	WSDATA CodeCriter	AS String
	WSDATA TypeArtef	AS String
	WSDATA Protocol  	AS String
ENDWSSTRUCT

WSSTRUCT TConfigArtifactList
	WSDATA Serv			As String
	WSDATA PortWeb		As string
	WSDATA FileTo       As String
	WSDATA InstaName	As String
	WSDATA KeyIni		AS String
ENDWSSTRUCT

WSSTRUCT TArtifactBrowse
	WSDATA Itens		AS Array Of TArtifactList	OPTIONAL
ENDWSSTRUCT

WSSTRUCT TConfigArtifact
	WSDATA Itens		AS Array Of TConfigArtifactList	OPTIONAL
ENDWSSTRUCT

WSSERVICE RHArtifact DESCRIPTION "Consulta de Artefatos"
	WSDATA WsNull   	   		As String	OPTIONAL
	WSDATA Branch				As String
	WSDATA Registration			As String
	
	WSDATA Code					As String	OPTIONAL
	WSDATA Category				As String	OPTIONAL
	WSDATA TitleLink   			As String	OPTIONAL
	WSDATA Message				As String	OPTIONAL
	WSDATA DateStart			AS Date		OPTIONAL
	WSDATA DateEnd				AS Date		OPTIONAL
	WSDATA ActionLink			AS String	OPTIONAL	
	WSDATA Alias				As String	OPTIONAL
	WSDATA CodeCriter			AS String	OPTIONAL
	WSDATA TdOK					AS BOOLEAN	OPTIONAL
	
	WSDATA ArtifactBrowse		As TArtifactBrowse
	
	WSDATA ConfigArtifact		As TConfigArtifact
	
	WSMETHOD BrowseArtifact		DESCRIPTION "Método de consulta de artefatos."
	WSMETHOD GetCriterArtifact	DESCRIPTION "Método para avaliar se o participante tem acesso ao artefato de acordo com o critério informado."	
	WSMETHOD GetConfigArtifact	DESCRIPTION "Método que lista as configurações para salvar os arquivos cadastrados nos artefatos."
ENDWSSERVICE                                  

//@author: Emerson Campos
//@date:   25/04/2012
//@method: Metodo de consulta de artefatos.
//@param:  Filial, Matricula
//@return: Array de Objetos
WSMETHOD BrowseArtifact;
WSRECEIVE Branch, Registration;
WSSEND ArtifactBrowse;
WSSERVICE RHArtifact   
	Local cFilial  	:= ::Branch
	//Local cMatFun  	:= ::Registration
	Local aArea     := GetArea()
	Local cAlias
	//Local lDB2 		:= AllTrim(Upper(GetSrvProfString("TopDatabase", ""))) == "DB2" .Or. AllTrim(Upper(GetSrvProfString("DbDataBase", ""))) == "DB2" .Or. AllTrim(Upper(GetProfString( "TotvsDbAccess", "DataBase", "" ))) == "DB2"
    Local cFiltro	:= "(RH2.RH2_DTINI <= '"+DtoS(Date())+"' AND (RH2.RH2_DTFIM >= '"+DtoS(Date())+"' OR RH2.RH2_DTFIM = ''))		       
    
    cFiltro := "% " + cFiltro + " %"
    
		cAlias:= GetNextAlias()
		
		BeginSql alias cAlias
		
			 SELECT RH2.RH2_FILIAL
		          , RH2.RH2_CODIGO
		          , RH2.RH2_DESC
		          , RH2.RH2_ACAO
		          , RH2.RH2_MSG
		          , RH2.RH2_DTINI
		          , RH2.RH2_DTFIM
		          , RH2.RH2_TIPO
          		  , RDT.RDT_ALIAS
          		  , RDT.RDT_CODIGO
		          , RHY.RHY_DESC
		       FROM %table:RH2% RH2
		  LEFT JOIN %table:RHY% RHY
		         ON RHY.RHY_CODIGO = RH2.RH2_CODCAT AND RHY.%notDel%
  		  LEFT JOIN %table:RDT% RDT
         		 ON RDT.RDT_CODIGO = RH2.RH2_CRITER AND RDT.%notDel%
		      WHERE %exp:cFiltro%
	       		AND RH2.%notDel%  
		   ORDER BY RHY.RHY_DESC
		
		EndSql
		
		While (cAlias)->( !Eof())
		
			oItem:= WSClassNew("TArtifactList")	
			
			oItem:Code			:= (cAlias)->RH2_CODIGO
			oItem:TitleLink		:= (cAlias)->RH2_DESC
			oItem:ActionLink	:= (cAlias)->RH2_ACAO
			oItem:Message		:= (cAlias)->RH2_MSG				
			oItem:Category		:= (cAlias)->RHY_DESC				
			oItem:Branch		:= (cAlias)->RH2_FILIAL				
			oItem:Company		:= (cAlias)->RH2_FILIAL				
			oItem:Alias			:= (cAlias)->RDT_ALIAS				
			oItem:CodeCriter	:= (cAlias)->RDT_CODIGO				
			oItem:TypeArtef		:= (cAlias)->RH2_TIPO
			oItem:Protocol		:= Iif("https" $ oItem:ActionLink, "https", "http") // - Monta o Protocolo de acordo com o item cadastrado (RH2_ACAO) para casos que usem protocolo de segurança - HTTPS.
						
			AAdd(Self:ArtifactBrowse:Itens, oItem)
				
	
			(cAlias)->( dbSkip() )
		EndDo    
        
	
	RestArea(aArea)
	  		
Return .T. 

//@author: Emerson Campos
//@date:   25/04/2012
//@method: Metodo para avaliar se o participante tem acesso ao artefato de acordo com o criterio informado.
//@param:  Filial, Matricula, Codigo Criterio, Alias do Criterio
//@return: Boolean (.T. ou .F.)	
WSMETHOD GetCriterArtifact;
WSRECEIVE Branch, Registration, CodeCriter, Alias;
WSSEND TdOK;
WSSERVICE RHArtifact

	Local aSaveArea	:= GetArea()
	Local cEmpSM0   := SM0->M0_CODIGO

	Self:TdOK	:= .T.
	
	// Seleciona o Criterio a ser testado no SRA ou RD0
	dbSelectArea("RDT")
	RDT->(dbSetOrder(1))
	If 	RDT->(dbSeek(xFilial("RDT")+CodeCriter+Alias))		
		If RDT->RDT_ALIAS == "SRA"
			dbSelectArea("SRA")
			SRA->(dbSetOrder(1))
			If 	SRA->(dbSeek(xFilial("SRA")+Registration))
				If ! &(RDT->RDT_CRITER)
					//Seta falso se o Funcionário nao se enquadra no criterio selecionado
					Self:TdOK	:= .F.		
				EndIf
			EndIf
			SRA->(dbCloseArea())
		ElseIf RDT->RDT_ALIAS == "RD0"
			dbSelectArea("RDZ")
			RDZ->( dbSetOrder(1) ) //RDZ_FILIAL+RDZ_EMPENT+RDZ_FILENT+RDZ_ENTIDA+RDZ_CODENT+RDZ_CODRD0           
			If RDZ->( dbSeek(xFilial("RDZ") + cEmpSM0 + xFilial("SRA") + "SRA" + Branch + Registration))
				dbSelectArea("RD0")
				RD0->( dbSetOrder(1) ) //RD0_FILIAL+RD0_CODIGO
				If RD0->( dbSeek(xFilial("RD0") + RDZ->RDZ_CODRD0) )
					If ! &(RDT->RDT_CRITER)
						//Seta falso se o Participante nao se enquadra no criterio selecionado
						Self:TdOK	:= .F.		
					EndIf	
				EndIf
			EndIf    
   			RDZ->(dbCloseArea())	
			RD0->(dbCloseArea())	 
		EndIf
	EndIf 
	RDT->(dbCloseArea())					
	RestArea(aSaveArea)
Return .T.

//@author: Emerson Campos
//@date:   08/05/2012
//@method: Método que lista as configurações para salvar os arquivos cadastrados nos artefatos.
//@param:  nao ha
//@return: Array de Objetos
WSMETHOD GetConfigArtifact;
WSRECEIVE Branch, Registration;
WSSEND ConfigArtifact;
WSSERVICE RHArtifact
	Local cAlias := GetNextAlias()
    
	BeginSql alias cAlias
		
		 SELECT RHZ_SERVID
		      , RHZ_PORWEB
		      , RHZ_ENDERE
		      , RHZ_INSTAN
		      , RHZ_CHAVE
		   FROM %table:RHZ% RHZ
		   WHERE RHZ.%notDel%
		   
		   	
	EndSql
		
		While (cAlias)->( !Eof())
		
			oItemRHZ := WSClassNew("TConfigArtifactList")	
			
			oItemRHZ:Serv			:= AllTrim((cAlias)->RHZ_SERVID)
			oItemRHZ:PortWeb		:= AllTrim((cAlias)->RHZ_PORWEB)
			oItemRHZ:FileTo			:= AllTrim((cAlias)->RHZ_ENDERE)
			oItemRHZ:InstaName		:= AllTrim((cAlias)->RHZ_INSTAN	)
			oItemRHZ:KeyIni			:= AllTrim((cAlias)->RHZ_CHAVE	)			
									
			AAdd(Self:ConfigArtifact:Itens, oItemRHZ)
	
			(cAlias)->( dbSkip() )
		EndDo

Return .T.