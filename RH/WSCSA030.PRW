#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSCSA030.CH"

Function WSCSA030()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WSSTRUCT PositionView
    WSDATA PositionCode        AS String OPTIONAL
    WSDATA PositionDescription  AS String OPTIONAL
ENDWSSTRUCT

WSSTRUCT X5TableView
    WSDATA X5Code        AS String OPTIONAL
    WSDATA X5Description  AS String OPTIONAL
ENDWSSTRUCT


WSSTRUCT TCompetenceData
	WSDATA skillDescription		  AS String
	WSDATA skillPosition			  AS Float
	WSDATA skillEmployee			  AS Float
ENDWSSTRUCT

WSSTRUCT TCompetenceBrowse
	WSDATA Itens					   AS Array Of TCompetenceData OPTIONAL
ENDWSSTRUCT

WSSTRUCT TCompetences
    WSDATA Itens                As Array of ListOfCompetences OPTIONAL 
ENDWSSTRUCT

WSSTRUCT ListOfCompetences
    WSDATA CompetenceID        As String                         
    WSDATA CompetenceDesc      As String                      
    WSDATA ListOfHabilities    As Array of HabilitieDetail OPTIONAL 
ENDWSSTRUCT

WSSTRUCT HabilitieDetail
    WSDATA HabilitieID         As String
    WSDATA HabilitieDesc       As String
ENDWSSTRUCT                            


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Competencia              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE RHCompetence DESCRIPTION STR0004 //Competencias
   WSDATA Header                AS Array Of BrwHeader
   WSDATA HeaderName            AS String
    
   WSDATA ListOfRHPosition      As Array Of PositionView
   WSDATA ListOfX5Table		   As Array Of X5TableView
   WSDATA Page                 AS Integer OPTIONAL
   WSDATA Search               AS String OPTIONAL                                                        
   WSDATA WsNull               AS String                           
   
   WSDATA Branch				  	  AS String 
   WSDATA Registration			  AS String	
   WSDATA PositionID           AS String   
   WSDATA X5ID           AS String   

   WSDATA CompetenceBrowse		  AS TCompetenceBrowse
   WSDATA HabilitiesCompetence  As TCompetences 

	
   WSMETHOD GetCompetence DESCRIPTION STR0001 //"Metodo responsável por gerar o grafico de comparacao das competencias requeridas pelo cargo, com as competencias apresentadas pelo funcionario."	
   WSMETHOD GetHabilities DESCRIPTION STR0005 //"Método responsável por carregar competencias e habilidades do cargo."
   WSMETHOD GetRHPosition DESCRIPTION STR0003 //"Método responsável por carregar cargos cadastrados."
   WSMETHOD GetX5Table DESCRIPTION STR0006 //"Método responsável por carregar tabela SX5."

ENDWSSERVICE                                  


WSMETHOD GetCompetence;
WSRECEIVE Branch, Registration, PositionID;
WSSEND CompetenceBrowse;
WSSERVICE RHCompetence

 Local cQuery     := GetNextAlias()
 Local cPositionID := ::PositionID

 Local cRBHBranch  := xFilial("RBH", ::Branch)
 Local cRBGBranch  := xFilial("RBG", ::Branch)
 Local cRDMBranch  := xFilial("RDM", ::Branch)

 Local aCompet	  := {}
 Local aCargo		  := {}
 Local aFunc		  := {}

 Local aValHabCargo := {}
 Local nValHabFunc  := 0.0

 Local lRet       := .T.
 Local nI			  := 0
 Local nX         := 0 
 Local nCalc      := 0.0 
 Local cCodCom    := ""
 
    // Busca Competencias e habilidades do cargo
    BEGINSQL ALIAS cQuery
        SELECT
            RBH_FILIAL, 
            RBH_CARGO, 
            RBH_CODCOM,
            RDM_DESC,
            RBH_ITECOM, 
            RBH_ESCALA,
            RBH_ITESCA,
            RBH_IMPORT,  
            RBH_ITIMPO,
            RBH_HABIL, 
            RBG_DESC 
        FROM  %Table:RBH% RBH
        INNER JOIN %Table:RDM% RDM
             ON RDM.RDM_CODIGO = RBH.RBH_CODCOM   AND
                RDM.RDM_FILIAL = %Exp:cRDMBranch% AND
                RDM.%NotDel%
        INNER JOIN %Table:RBG% RBG
             ON RBG.RBG_HABIL  = RBH.RBH_HABIL    AND
                RBG.RBG_FILIAL = %Exp:cRBGBranch% AND
                RBG.%NotDel%
        WHERE RBH.RBH_CARGO    = %Exp:cPositionID%  AND
              RBH.RBH_FILIAL   = %Exp:cRBHBranch%   AND
              RBH.%NotDel%            
    ENDSQL

    
    cCodCom := ""
    While (cQuery)->(!Eof())

        //Adiciona competencia
        IF (cQuery)->RBH_CODCOM != cCodCom

           //Guarda valores calculados
           IF !Empty(cCodCom)
              
              //Calcula valor da competencia para o cargo
              nCalc := 0
              For nX := 1 To len(aValHabCargo)
                  nCalc += aValHabCargo[nX]
              Next nX
              aAdd(aCargo, (nCalc / len(aValHabCargo)) )            


              //Calcula valor da competencia para o funcionario
              //o somatorio das habilidades do funcionario e dividido pela qtde de habilidades do cargo
              aAdd(aFunc, nValHabFunc / len(aValHabCargo) )            

           EndIF


           aAdd(aCompet, (cQuery)->RDM_DESC)
           cCodCom := (cQuery)->RBH_CODCOM

           aValHabCargo := {}
           nValHabFunc  := 0.0
           
           nI++
        ENDIF           


        //*******************************
        //Calcula Habilidade para o cargo
        dbSelectArea("RBL")
        dbSetOrder(1)

        //Busca valor da escala
        nValorEscala := 0
        If dbSeek(xFilial("RBL")+(cQuery)->RBH_ESCALA+(cQuery)->RBH_ITESCA)
            nValorEscala := RBL->RBL_VALOR            
        EndIf

        //Busca valor do grau de importancia
        nValorImport := 0
        If dbSeek(xFilial("RBL")+(cQuery)->RBH_IMPORT+(cQuery)->RBH_ITIMPO)
            nValorImport := (RBL->RBL_VALOR / 100)            
        EndIf

        //Calcula e acumula habilidades
        aAdd( aValHabCargo, (nValorEscala * nValorImport) )



        //*****************************************************
        //Acumula Habilidades do funcionario para a competencia 

        //Verifica se o funcionario possui a habilide para o cargo (RBI)     
        dbSelectArea("RBI")
        dbSetOrder(1)
        If dbSeek(xFilial("RBI")+::Registration+(cQuery)->RBH_HABIL)

            //Busca valor da escala
            dbSelectArea("RBL")
            dbSetOrder(1)
    
            If dbSeek(xFilial("RBL")+RBI->RBI_ESCALA+RBI->RBI_ITESCA)
                nValHabFunc += (RBL->RBL_VALOR * nValorImport)           
            EndIf
        EndIf

         
        (cQuery)->( dbSkip() )
    EndDo

    //Guarda valores calculados, nao acumulados pela ultima quebra de competencia
    IF !Empty(cCodCom)
      //Calcula valor da competencia para o cargo
      nCalc := 0.0
      For nX := 1 To len(aValHabCargo)
          nCalc += aValHabCargo[nX]
      Next nX
      aAdd(aCargo, (nCalc / len(aValHabCargo)) )            


      //Calcula valor da competencia para o funcionario
      //o somatorio das habilidades do funcionario e dividido pela qtde de habilidades do cargo
      aAdd(aFunc, nValHabFunc / len(aValHabCargo) )            
    EndIF
    
    (cQuery)->(DBCloseArea())

  	
	//aCompet	:= {'Gerenciar Pessoas', 'Delegar Tarefa', 'Gerenciar Prazos', 'Apresentar Resultados'}
	//aCargo	   :=	{5.8,7.4,8.6,8.2}
	//aFunc	   := {3.6,4.5,2.3,7.9}

	
   // Prepara dados para retorno do metodo
	For nI := 1 To Len(aCompet)
		oItem:= WSClassNew("TCompetenceData")
		oItem:skillDescription		:= aCompet[nI]
		oItem:skillPosition			:= aCargo[nI]
		oItem:skillEmployee			:= aFunc[nI]
		
		AAdd(Self:CompetenceBrowse:Itens, oItem)
	Next nI

	
RETURN lRet


WSMETHOD GetHabilities;
WSRECEIVE Branch, PositionID;
WSSEND HabilitiesCompetence;
WSSERVICE RHCompetence

 Local cQuery     := GetNextAlias()
 Local cPositionID := ::PositionID

 Local nReg       := 0
 Local lRet       := .T.
 Local cCodCom    := ""

 Local oItem

 Local cRBHBranch  := xFilial("RBH", ::Branch)
 Local cRBGBranch  := xFilial("RBG", ::Branch)
 Local cRDMBranch  := xFilial("RDM", ::Branch)


    // Busca Competencias e habilidades do cargo
    BEGINSQL ALIAS cQuery
        SELECT
            RBH_FILIAL, 
            RBH_CARGO, 
            RBH_CODCOM,
            RDM_DESC,
            RBH_HABIL, 
            RBG_DESC 
        FROM  %Table:RBH% RBH
        INNER JOIN %Table:RDM% RDM
             ON RDM.RDM_CODIGO = RBH.RBH_CODCOM   AND
                RDM.RDM_FILIAL = %Exp:cRDMBranch% AND
                RDM.%NotDel%
        INNER JOIN %Table:RBG% RBG
             ON RBG.RBG_HABIL  = RBH.RBH_HABIL    AND
                RBG.RBG_FILIAL = %Exp:cRBGBranch% AND
                RBG.%NotDel%
        WHERE RBH.RBH_CARGO    = %Exp:cPositionID%  AND
              RBH.RBH_FILIAL   = %Exp:cRBHBranch%   AND
              RBH.%NotDel%            
    ENDSQL


    ::HabilitiesCompetence:= WSClassNew("TCompetences")
    ::HabilitiesCompetence:Itens := {}
    
    cCodCom := ""
    While (cQuery)->(!Eof())

        //Adiciona competencia
        IF (cQuery)->RBH_CODCOM != cCodCom
           IF !Empty(cCodCom)
                AAdd(::HabilitiesCompetence:Itens, oItem)
           ENDIF

           oItem := WSClassNew("ListOfCompetences")
           oItem:ListOfHabilities := {} 

           oItem:CompetenceID   := (cQuery)->RBH_CODCOM
           oItem:CompetenceDesc := (cQuery)->RDM_DESC

           cCodCom := (cQuery)->RBH_CODCOM
           nReg    := 0
        ENDIF

        nReg++ 
        aadd(oItem:ListOfHabilities,WsClassNew('HabilitieDetail'))
        oItem:ListOfHabilities[nReg]:HabilitieID   := (cQuery)->RBH_HABIL
        oItem:ListOfHabilities[nReg]:HabilitieDesc := (cQuery)->RBG_DESC
         
        (cQuery)->( dbSkip() )
    EndDo

    //Adiciona competencia
    IF !Empty(cCodCom)
       AAdd(::HabilitiesCompetence:Itens, oItem)
    ENDIF

    (cQuery)->(DBCloseArea())

Return lRet



WSMETHOD GetRHPosition; 
WSRECEIVE Page, Search; 
WSSEND ListOfRHPosition;
WSSERVICE RHCompetence
    Local oPosition
    Local nSkips := 0
    
    SELF:ListOfRHPosition := {}
    
    dbSelectArea("SQ3")
    dbSetOrder(1)
    dbGoTop()   
    
    IF DBSeek(xFilial("SQ3"))           
        While !Eof() .AND.;
                xFilial("SQ3") == Q3_FILIAL .AND.;
                Len(SELF:ListOfRHPosition) < 10              

            If (!Empty(SELF:Search) .AND. !(Upper(SELF:Search) $ Upper(Q3_DESCSUM)))
                DBSkip()
                Loop                    
            EndIf           
                
            If nSkips < (SELF:Page * 10)
                DBSkip()
                nSkips++
                Loop
            EndIf
            
            oPosition := WSClassNew("PositionView")

            oPosition:PositionCode       := Q3_CARGO   //Codigo do Cargo
            oPosition:PositionDescription := Q3_DESCSUM //Descricao resumida do Cargo
            
            aadd(SELF:ListOfRHPosition, oPosition)
                               
            DBSkip()
        EndDo           
    ENDIF
Return .T.

WSMETHOD GetX5Table; 
WSRECEIVE Page, Search, X5Id;
WSSEND ListOfX5Table;
WSSERVICE RHCompetence
    Local oObjX5
    Local nSkips := 0
    
    SELF:ListOfX5Table := {}
    
    dbSelectArea("SX5")
    dbSetOrder(1)
    
    IF DBSeek(xFilial("SX5")+::X5ID)           
        While !Eof() .AND. xFilial("SX5") == X5_FILIAL .AND. X5_TABELA == ::X5ID .And. ;
                Len(SELF:ListOfX5Table) < 10              

            If (!Empty(SELF:Search) .AND. !(Upper(SELF:Search) $ Upper(X5Descri())))
                DBSkip()
                Loop                    
            EndIf           
                
            If nSkips < (SELF:Page * 10)
                DBSkip()
                nSkips++
                Loop
            EndIf
            
            oObjX5 := WSClassNew("X5TableView")

            oObjX5:X5Code       := X5_CHAVE   //Codigo do Cargo
            oObjX5:X5Description := X5Descri() //Descricao resumida do Cargo
            
            aadd(SELF:ListOfX5Table, oObjX5)
                               
            DBSkip()
        EndDo           
    ENDIF
Return .T.
