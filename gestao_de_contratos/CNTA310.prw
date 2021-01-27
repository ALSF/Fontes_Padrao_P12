#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "GCTXDEF.CH"
#INCLUDE "CNTA310.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} CNTA310()
Reajuste Automatico

@author Barbara Reis 
@since  07/08/2015
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
Function CNTA310()
Local oBrowse  := Nil

If !IsBlind()
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("CXK")                                          
	oBrowse:SetDescription(STR0001) 
	oBrowse:Activate()
Else
	CN310Perg()
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SchedDef()
Preparação para rotinas automaticas por Schedule

@author Israel.Escorizza
@since 01/02/2018
@version 1.0
@return 
/*/
//-------------------------------------------------------------------
Static Function SchedDef()
Local aReturn := { "P",;
					"CN310",;
					Nil,;
					Nil,;
					Nil ;
				}
					
Return aReturn

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Criacao do Menu

@author Bárbara Reis 
@since 07/08/2015
@version 1.0
@return aRotina (vetor com botoes da EnchoiceBar)
/*/
//-------------------------------------------------------------------
Static Function MenuDef()  
Local aRotina := {}

ADD OPTION aRotina Title STR0002 Action 'VIEWDEF.CNTA310' OPERATION 2 ACCESS 0	//- Visualizar
ADD OPTION aRotina Title STR0003 Action 'CN310Perg' OPERATION 3 ACCESS 0		//- Incluir

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef()
Criaca do modelo 

@author Barbara Reis 
@since  07/08/2015
@version 1.0
@return oModel
/*/
//-------------------------------------------------------------------
Static Function ModelDef()  

Local oStruCab	:= FWFormStruct(1,"CXK")  
Local oStruGrid	:= FWFormStruct(1,"CXL")
Local oModel   	:= Nil 

oModel:= MPFormModel():New("CNTA310", /*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

oModel:AddFields("CXKMASTER", /*cOwner*/, oStruCab)
oModel:AddGrid("CXLDETAIL", "CXKMASTER", oStruGrid)
oModel:SetPrimaryKey( {} ) 

oModel:SetRelation("CXLDETAIL",{{"CXL_FILIAL",'xFilial("CXL")'},{"CXL_NUMRJ","CXK_NUMERO"}},CXL->(IndexKey(1)))
oModel:GetModel("CXLDETAIL"):SetUniqueLine({"CXL_ITEM"})
	
Return oModel 

//--------------------------------------------------------------------
/*/{Protheus.doc} ViewDef()
Criacao da view

@author Barbara Reis 
@since  07/08/2015
@version 1.0
@return oView
/*/
//--------------------------------------------------------------------
Static Function ViewDef()  

Local oModel	:= FWLoadModel( "CNTA310" )
Local oStruCab	:= FWFormStruct(2,"CXK") 
Local oStruGrid	:= FWFormStruct(2,"CXL")
Local oView		:= FWFormView():New()

oView:SetModel(oModel)

oView:AddField("VIEW_CXK", oStruCab, "CXKMASTER")
oView:AddGrid("VIEW_CXL", oStruGrid, "CXLDETAIL") 

oView:CreateHorizontalBox("CABEC",25)
oView:CreateHorizontalBox("GRID",75)

oView:SetOwnerView("VIEW_CXK","CABEC")
oView:SetOwnerView("VIEW_CXL","GRID")

Return oView	 

//--------------------------------------------------------------------
/*/{Protheus.doc} CN310Perg()
Função que inicializa o Pergunte

@author miguel.santos
@since  13/08/2015
@version 1.0
@return .T.
/*/
//--------------------------------------------------------------------

Function CN310Perg()

Local dDataRef		:= dDataBase
Local dDataApl		:= dDataRef
Local cContrato     := ""
Local cTpContra   	:= ""	
Local cTpPlan   	:= ""	
Local cCliente     	:= ""	
Local cLjCliente   	:= ""	
Local cFornec  		:= ""	
Local cTpRevisao	:= ""
Local cLjFornec 	:= ""

If IsBlind() .Or. Pergunte("CN310",.T.)
	//Carregando a Função do MakeSQL
	MakeSQLEXPR("CN310")

	cContrato		:= (mv_par01)
	cTpContra   	:= (mv_par02)
	cTpPlan   		:= (mv_par03)
	cCliente     	:= (mv_par04)
	cLjCliente   	:= (mv_par05)
	cFornec  		:= (mv_par06)
	cLjFornec 		:= (mv_par07)
	dDataRef		:= (mv_par08)
	dDataApl		:= (mv_par09)
	cTpRevisao		:= (mv_par10)
	
	If CN310PVld() //Efetua validação dos campos obrigatórios
		If !IsBlind()
			MsgRun(STR0004,STR0001,{|| CN310Inc(cContrato, cTpContra, cTpPlan, cCliente, cLjCliente, cFornec, cLjFornec, dDataRef, dDataApl, cTpRevisao) })
		Else
			CN310Inc(cContrato, cTpContra, cTpPlan, cCliente, cLjCliente, cFornec, cLjFornec, dDataRef, dDataApl, cTpRevisao)
		EndIf
	EndIf
EndIf

Return Nil

//--------------------------------------------------------------------
/*/{Protheus.doc} CN310Inc()

Reajuste de Contratos  -  Inclusão manual e automática(JOB) 

@author Flavio Lopes Rasta / Marcelo Ferreira
@since  24/08/2015
@version 12.1.6
@return Nil
/*/
//--------------------------------------------------------------------

Function CN310Inc(cContrato, cTpContra, cTpPlan, cCliente, cLjCliente, cFornec, cLjFornec, dDataRef, dDataApl, cTpRevisao)

Local lContinua		:= .F.
Local lOracle		:= (UPPER(Alltrim(TcGetDb()))=="ORACLE")
Local lCN300QRY		:= ExistBlock('CN310QRY')

Local oModel		:= FWLoadModel("CNTA310")
Local oModelCXK 	:= Nil
Local oModelCXL		:= Nil

Local aContratos	:= {}
Local cItem			:= Replicate("0", TamSx3("CXL_ITEM")[1])
Local cQuery    	:= ""   
Local cAliasCN9		:= GetNextAlias()
Local cContraAnt	:= ""
Local cNumReaj		:= ""
Local cAplCompet 	:= Substr(DtoS(dDataApl),1,6)
Local cCN300QRY		:= ""

Local nX			:= 0
Local nContTotal	:= 0
Local nIncIt		:= 0

// Tratamento de expressão SQL
If lOracle
	cSubStr:= "SUBSTR"
Else
	cSubStr:= "SUBSTRING"
EndIf
	
// Seleciona os contratos COM itens na planilha que serão reajustados (CONTRATOS FIXOS)
cQuery := " SELECT "
cQuery += " CN9.CN9_NUMERO,  "
cQuery += " CN9.CN9_REVISA,  "
cQuery += " CN9.CN9_INDICE,  "
cQuery += " CNA.CNA_NUMERO,  "
cQuery += " CNA.CNA_INDICE,  "
cQuery += " CNB.CNB_DTREAJ DTREAJ, " 
cQuery += " CNB.CNB_PROXRJ PROXRJ,	"
cQuery += " CNB.CNB_VLUNIT VLANT, " 
cQuery += " CNB.CNB_ITEM, "
cQuery += " CNB.CNB_INDICE " 

//-- Ponto de entrada para cusomização na query
//-- Param1: Query montada até o momento
//-- Param2: Indica qual query, sendo 1 ref. trecho de contratos com itens e 2 ref. trecho de contratos sem itens
//-- Param3: Indica trecho da query, sendo 1 para campos do select e 2 para condições do where
If lCN300QRY
	cCN300QRY := ExecBlock("CN310QRY",.F.,.F.,{cQuery,1,1})
	If ValType(cCN300QRY) == "C"
		cQuery += cCN300QRY
	EndIf
EndIf

cQuery += " FROM "
cQuery += RetSqlName("CN9")+" CN9, "
cQuery += RetSqlName("CNA")+" CNA, "
cQuery += RetSqlName("CNB")+" CNB  " 

cQuery += " WHERE 
cQuery += " CN9.CN9_FILIAL = '"+FWxFilial("CN9")+"' " 
    
If !Empty(cContrato)
      cQuery += "  AND " + cContrato  //CN9.CN9_NUMERO
EndIf 

cQuery += "	AND CN9.CN9_SITUAC = '"+DEF_SVIGE+"' "  // Contrato "Vigente" 
cQuery += " AND CN9.CN9_FLGREJ = '1' "  //Aceita Reajuste

If CN9->(Columnpos('CN9_PROXRJ')) > 0
	cQuery += " AND CN9.CN9_PROXRJ <= '" + DtoS(dDataApl) + "'"
EndIf

cQuery += " AND CN9.D_E_L_E_T_ = ' ' "   

If !Empty(cTpContra)
      cQuery += " AND " + cTpContra  //CN9.CN9_TIPCTO
EndIf 

//- Valida se contrato NÃO está "Em Revisão"
cQuery += "	AND NOT EXISTS ( SELECT 1 "
cQuery += " FROM " +RetSqlName("CN9")+ " CN9A " 
cQuery += " WHERE CN9A.CN9_FILIAL = CN9.CN9_FILIAL "  
cQuery += " AND CN9A.CN9_NUMERO = CN9.CN9_NUMERO " 
cQuery += " AND CN9A.CN9_REVISA = CN9.CN9_REVATU " 
cQuery += " AND CN9A.CN9_SITUAC = '"+DEF_SREVS+"' "  								// Contrato "Em Revisão"	 
cQuery += " AND CN9A.D_E_L_E_T_ = ' ') " 

//- Valida CNA
cQuery += " AND CNA.CNA_FILIAL = CN9.CN9_FILIAL " 
cQuery += " AND CNA.CNA_CONTRA = CN9.CN9_NUMERO " 
cQuery += " AND CNA.CNA_REVISA = CN9.CN9_REVISA " 
cQuery += " AND CNA.CNA_FLREAJ = '1' "   											// Aceita Reajuste
cQuery += "	AND (CNA.CNA_PROXRJ = '' OR CNA.CNA_PROXRJ <= '" + DtoS(dDataApl) +"')"   // Foi informada proximo reajuste ou utiliza CN9
cQuery += " AND CNA.D_E_L_E_T_ = ' ' " 

If !Empty(cCliente)          
      cQuery += " AND " + cCliente  //CNA.CNA_CLIENT
      If !Empty(cLjCliente)        
            cQuery += " AND " + cLjCliente  //CNA.CNA_LOJACL
      EndIf
      
ElseIf !Empty(cFornec)       
      cQuery += " AND " + cFornec  //CNA.CNA_FORNEC
      If !Empty(cLjFornec)         
            cQuery += " AND " + cLjFornec  //CNA.CNA_LJFOR
      EndIf
EndIf
If !Empty(cTpPlan)           
      cQuery += " AND " + cTpPlan  //CNA_TIPPLA
EndIf
cQuery += " AND CNB.CNB_FILIAL = CNA.CNA_FILIAL " 
cQuery += " AND CNB.CNB_CONTRA = CNA.CNA_CONTRA " 
cQuery += " AND CNB.CNB_REVISA = CNA.CNA_REVISA " 
cQuery += " AND CNB.CNB_NUMERO = CNA.CNA_NUMERO " 
cQuery += " AND (CNB.CNB_FLREAJ = '' OR  CNB.CNB_FLREAJ = '1')"   //Aceita Reajuste
cQuery += " AND CNB.CNB_ITMDST = ' ' " 
cQuery += " AND CNB.D_E_L_E_T_ = ' ' "    
cQuery += " AND EXISTS ( SELECT 1  "   //Valida se existe pelo menos 1 item a ser reajustado no contrato para não gerar revisão sem necessidade
cQuery += "              FROM "+RetSqlName("CNB")+" CNB1 "   
cQuery += "              WHERE CNB1.CNB_FILIAL = CNA.CNA_FILIAL "   
cQuery += "              AND CNB1.CNB_CONTRA = CNA.CNA_CONTRA "   
cQuery += "              AND CNB1.CNB_REVISA = CNA.CNA_REVISA "   
cQuery += "              AND CNB1.CNB_NUMERO = CNA.CNA_NUMERO "   
cQuery += "              AND (CNB.CNB_FLREAJ = '' OR  CNB.CNB_FLREAJ = '1')"   //Aceita Reajuste
cQuery += "   			 AND CNB1.CNB_ITMDST = ' ' " 
cQuery += "              AND CNB1.D_E_L_E_T_ = ' ' "  
cQuery += "              ) "  
cQuery += "  AND EXISTS ( SELECT 1   "  //Valida se existe índice cadastrado no histórico de índices para a data de referência
cQuery += "               FROM "+RetSqlName("CN6")+" CN6, "+RetSqlName("CN7")+" CN7 " 
cQuery += "               WHERE CN6.CN6_FILIAL = '"+xFilial("CN6")+"' " 
cQuery += "               AND CN6.CN6_CODIGO = (  " 
cQuery += "                   CASE   " 
cQuery += "                   WHEN CNB.CNB_INDICE <> ' ' THEN CNB.CNB_INDICE " 
cQuery += "                   WHEN CNA.CNA_INDICE <> ' ' THEN CNA.CNA_INDICE " 
cQuery += "                   WHEN CN9.CN9_INDICE <> ' ' THEN CN9.CN9_INDICE " 
cQuery += "                   END  " 
cQuery += "                   ) " 
cQuery += "               AND CN6.D_E_L_E_T_ = ' ' " 
cQuery += "               AND CN7.CN7_FILIAL = '"+ xFilial("CN7") +"' "  
cQuery += "               AND CN7.CN7_CODIGO = CN6.CN6_CODIGO " 
cQuery += "               AND CN7.D_E_L_E_T_ = ' ' " 
cQuery += "               AND (  " 
cQuery += "                      CASE   " 
cQuery += "                      WHEN CN6.CN6_TIPO = '1' AND CN7.CN7_DATA = '"+DtoS(dDataRef)+"' THEN 'TRUE' "  
cQuery += "                      WHEN CN6.CN6_TIPO = '2' AND CN7.CN7_COMPET = '"+strzero(Month(dDataRef),2)+"/"+strzero(Year(dDataRef),4)+"' THEN 'TRUE'  " 
cQuery += "                      ELSE 'FALSE'  " 
cQuery += "                      END  " 
cQuery += "                    ) = 'TRUE' " 
cQuery += "               )  " 

//-- Ponto de entrada para cusomização na query
//-- Param1: Query montada até o momento
//-- Param2: Indica qual query, sendo 1 ref. trecho de contratos com itens e 2 ref. trecho de contratos sem itens
//-- Param3: Indica trecho da query, sendo 1 para campos do select e 2 para condições do where
If lCN300QRY
	cCN300QRY := Execblock("CN310QRY",.F.,.F.,{cQuery,1,2})
	If ValType(cCN300QRY) == "C"
		cQuery += cCN300QRY
	EndIf
EndIf

cQuery += " UNION ALL  " 

// Seleciona os contratos SEM itens na planilha que serão reajustados (CONTRATOS NÃO FIXOS)
cQuery += " SELECT   " 
cQuery += " CN9.CN9_NUMERO,  " 
cQuery += " CN9.CN9_REVISA, "  
cQuery += " CN9.CN9_INDICE, "  
cQuery += " CNA.CNA_NUMERO, "  
cQuery += " CNA.CNA_INDICE, "  
cQuery += " CNA.CNA_DTREAJ DTREAJ, "  
cQuery += " CNA.CNA_PROXRJ PROXRJ, "  
cQuery += " CNA.CNA_VLTOT VLANT, "  
cQuery += " cast(' ' as varchar("+Alltrim(Str(TamSX3("CNB_ITEM")[1]))+")) as CNB_ITEM, "  
cQuery += " cast(' ' as varchar("+Alltrim(Str(TamSX3("CNB_INDICE")[1]))+")) as CNB_INDICE " 

//-- Ponto de entrada para cusomização na query
//-- Param1: Query montada até o momento
//-- Param2: Indica qual query, sendo 1 ref. trecho de contratos com itens e 2 ref. trecho de contratos sem itens
//-- Param3: Indica trecho da query, sendo 1 para campos do select e 2 para condições do where
If lCN300QRY
	cCN300QRY := Execblock("CN310QRY",.F.,.F.,{cQuery,2,1})
	If ValType(cCN300QRY) == "C"
		cQuery += cCN300QRY
	EndIf
EndIf

cQuery += " FROM "
cQuery += RetSqlName("CN9")+" CN9,"
cQuery += RetSqlName("CNA")+" CNA " 

cQuery += " WHERE 
cQuery += " CN9.CN9_FILIAL = '"+FWxFilial("CN9")+"' "     

If !Empty(cContrato)
      cQuery += "  AND " + cContrato  //CN9.CN9_NUMERO
EndIf 

cQuery += " AND CN9.CN9_SITUAC = '"+DEF_SVIGE+"' "  // Contrato "Vigente" 
cQuery += " AND CN9.CN9_FLGREJ = '1' "  //Aceita Reajuste
If CN9->(Columnpos('CN9_PROXRJ')) > 0
	cQuery += " AND CN9.CN9_PROXRJ <= '" + DtoS(dDataApl) +"'"
EndIf
cQuery += " AND CN9.D_E_L_E_T_ = ' ' "   

If !Empty(cTpContra)
      cQuery += "   AND " + cTpContra  //CN9.CN9_TIPCTO
EndIf 

cQuery += " AND NOT EXISTS ( SELECT 1 "  // Valida se contrato NÃO está "Em Revisão"
cQuery += "                  FROM "+RetSqlName("CN9")+" CN9A " 
cQuery += "                  WHERE CN9A.CN9_FILIAL = CN9.CN9_FILIAL "  
cQuery += "                        AND CN9A.CN9_NUMERO = CN9.CN9_NUMERO " 
cQuery += "                        AND CN9A.CN9_REVISA = CN9.CN9_REVATU " 
cQuery += "                        AND CN9A.CN9_SITUAC = '"+DEF_SREVS+"' "  // Contrato "Em Revisão" 
cQuery += "                        AND CN9A.D_E_L_E_T_ = ' ') " 
cQuery += " AND CNA.CNA_FILIAL = CN9.CN9_FILIAL " 
cQuery += " AND CNA.CNA_CONTRA = CN9.CN9_NUMERO " 
cQuery += " AND CNA.CNA_REVISA = CN9.CN9_REVISA " 
cQuery += " AND CNA.CNA_FLREAJ = '1' "   //Aceita Reajuste
cQuery += "	AND (CNA.CNA_PROXRJ = '' OR CNA.CNA_PROXRJ <= '" + DtoS(dDataApl) +"')"   // Foi informada proximo reajuste ou utiliza CN9
cQuery += " AND CNA.D_E_L_E_T_ = ' ' " 

If !Empty(cCliente)          
      cQuery += " AND " + cCliente  //CNA.CNA_CLIENT
      If !Empty(cLjCliente)        
            cQuery += "   AND " + cLjCliente  //CNA.CNA_LOJACL
      EndIf
      
ElseIf !Empty(cFornec)       
      cQuery += " AND " + cFornec  //CNA.CNA_FORNEC
      If !Empty(cLjFornec)         
            cQuery += " AND " + cLjFornec  //CNA.CNA_LJFOR
      EndIf
EndIf

If !Empty(cTpPlan)           
      cQuery += " AND " + cTpPlan  //CNA_TIPPLA
EndIf

cQuery += " AND NOT EXISTS ( SELECT 1 "   //Valida se planilha não possui item vinculado
cQuery += "                  FROM "+RetSqlName("CNB")+" CNB " 
cQuery += "                  WHERE CNB.CNB_FILIAL = CNA.CNA_FILIAL "   
cQuery += "                  AND CNB.CNB_CONTRA = CNA.CNA_CONTRA  "  
cQuery += "                  AND CNB.CNB_REVISA = CNA.CNA_REVISA  "  
cQuery += "                  AND CNB.CNB_NUMERO = CNA.CNA_NUMERO "  
cQuery += "                  AND CNB.D_E_L_E_T_ = ' ' )

cQuery += " AND EXISTS ( SELECT 1   "  //Valida se existe índice cadastrado no histórico de índices para a data de referência
cQuery += "              FROM "+RetSqlName("CN6")+" CN6, "+RetSqlName("CN7")+" CN7 " 
cQuery += "              WHERE CN6.CN6_FILIAL = '"+xFilial("CN6")+"' " 
cQuery += "              AND CN6.CN6_CODIGO = (  " 
cQuery += "                                      CASE   " 
cQuery += "                                      WHEN CNA.CNA_INDICE <> ' ' THEN CNA.CNA_INDICE " 
cQuery += "                                      WHEN CN9.CN9_INDICE <> ' ' THEN CN9.CN9_INDICE " 
cQuery += "                                      END  " 
cQuery += "                                      ) " 
cQuery += "              AND CN6.D_E_L_E_T_ = ' ' " 
cQuery += "              AND CN7.CN7_FILIAL = '"+ xFilial("CN7") +"' "  
cQuery += "              AND CN7.CN7_CODIGO = CN6.CN6_CODIGO " 
cQuery += "              AND CN7.D_E_L_E_T_ = ' ' " 
cQuery += "              AND (" 
cQuery += "                   CASE   " 
cQuery += "                   WHEN CN6.CN6_TIPO = '1' AND CN7.CN7_DATA = '"+DtoS(dDataRef)+"' THEN 'TRUE' "  
cQuery += "                   WHEN CN6.CN6_TIPO = '2' AND CN7.CN7_COMPET = '"+strzero(Month(dDataRef),2)+"/"+strzero(Year(dDataRef),4)+"' THEN 'TRUE'  " 
cQuery += "                   ELSE 'FALSE'  " 
cQuery += "                   END  " 
cQuery += "                  ) = 'TRUE' " 
cQuery += "               ) " 

//-- Ponto de entrada para cusomização na query
//-- Param1: Query montada até o momento
//-- Param2: Indica qual query, sendo 1 ref. trecho de contratos com itens e 2 ref. trecho de contratos sem itens
//-- Param3: Indica trecho da query, sendo 1 para campos do select e 2 para condições do where
If lCN300QRY
	cCN300QRY := Execblock("CN310QRY",.F.,.F.,{cQuery,2,2})
	If ValType(cCN300QRY) == "C"
		cQuery += cCN300QRY
	EndIf
EndIf

cQuery += " ORDER BY CN9_NUMERO,CN9_REVISA "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCN9,.F.,.T.)

TcSetField(cAliasCN9,"DTREAJ",TamSX3("CNB_DTREAJ")[3],TamSX3("CNB_DTREAJ")[1],TamSX3("CNB_DTREAJ")[2])
TcSetField(cAliasCN9,"PROXRJ",TamSX3("CNB_PROXRJ")[3],TamSX3("CNB_PROXRJ")[1],TamSX3("CNB_PROXRJ")[2])

If !(cAliasCN9)->(Eof())

	oModel:SetOperation(MODEL_OPERATION_INSERT)
	oModel:Activate()
	
	oModelCXK		:= oModel:GetModel('CXKMASTER')
	oModelCXL		:= oModel:GetModel('CXLDETAIL')
	
	//-- Cabeçalho CXK
	oModelCXK:SetValue('CXK_DATINI',dDataBase)
	oModelCXK:SetValue('CXK_HORINI',Time())
	oModelCXK:SetValue('CXK_DATFIM',dDatabase)
	oModelCXK:SetValue('CXK_HORFIM',Time())
	oModelCXK:SetValue('CXK_SITUAC',"CF")
	
	cNumReaj	:= oModelCXK:GetValue("CXK_NUMERO")
	
	//-- Itens CXL
	While !(cAliasCN9)->(Eof())
		oModelCXL:AddLine()
		nIncIt++
		If cContraAnt <> (cAliasCN9)->CN9_NUMERO
			cContraAnt := (cAliasCN9)->CN9_NUMERO
			aAdd(aContratos,{(cAliasCN9)->CN9_NUMERO, (cAliasCN9)->CN9_REVISA}) 		
			nContTotal++	
		EndIf
		cItem := Soma1(cItem)
		
		oModelCXL:SetValue('CXL_NUMRJ',oModelCXK:GetValue("CXK_NUMERO"))
		oModelCXL:SetValue('CXL_ITEM',cItem)
		oModelCXL:SetValue('CXL_CONTRA',(cAliasCN9)->CN9_NUMERO)
		oModelCXL:SetValue('CXL_REVISA',(cAliasCN9)->CN9_REVISA)
		oModelCXL:SetValue('CXL_PLAN',(cAliasCN9)->CNA_NUMERO)
		oModelCXL:SetValue('CXL_ITEMPL',(cAliasCN9)->CNB_ITEM)
		oModelCXL:SetValue('CXL_VLANT',(cAliasCN9)->VLANT)
		oModelCXL:SetValue('CXL_DTANT',(cAliasCN9)->DTREAJ)
		oModelCXL:SetValue('CXL_DTPREV',(cAliasCN9)->PROXRJ)
		oModelCXL:SetValue('CXL_DTREAJ',CToD(" "))
		oModelCXL:SetValue('CXL_DTPROX',CToD(" "))	
		oModelCXL:SetValue('CXL_VLATU',0)
		
		If !Empty( (cAliasCN9)->CNB_INDICE )
			oModelCXL:SetValue('CXL_INDICE',(cAliasCN9)->CNB_INDICE)
		Else
			If !Empty ((cAliasCN9)->CNA_INDICE)
				oModelCXL:SetValue('CXL_INDICE',(cAliasCN9)->CNA_INDICE)
			Else
				oModelCXL:SetValue('CXL_INDICE',(cAliasCN9)->CN9_INDICE)
			Endif
		EndIf
		oModelCXL:SetValue('CXL_VLIND',((A300VlrInd(oModelCXL:GetValue('CXL_INDICE'),dDataRef)-1)*100))
		
		oModelCXL:SetValue('CXL_VLAPL',0)
		oModelCXL:SetValue('CXL_SITUAC',"F")
		
		(cAliasCN9)->( DbSkip() )
	EndDo
	
	oModelCXK:SetValue('CXK_QTDCT', nContTotal)	
	oModelCXK:SetValue('CXK_QTDIT', nIncIt)	
	
	If !IsBlind()
		lContinua := MSGYESNO( STR0005+STR(nContTotal)+STR0006 +STR0007,STR0007 )	
	Else
		lContinua := .T.
	EndIf
	
	If lContinua
		Begin Transaction
		If ( oModel:VldData() )
			oModel:CommitData()
			oModel:DeActivate()
			
			nX := 1
			While lContinua .And. nX <= Len(aContratos)
				lContinua := CN310Reaj(aContratos[nX], cNumReaj, dDataRef, dDataApl, cTpRevisao)
				If !lContinua
					DisarmTransaction()
					If !IsBlind()
						MostraErro()
					EndIf
				EndIf
			    nX++
			EndDo
		Endif			
		End Transaction		
	EndIf
Else
	Help(,,"CNTA310CTR",, STR0008 , 1, 0 )
Endif

Return Nil

//--------------------------------------------------------------------
/*/{Protheus.doc} CN310Reaj()
Função responsável pelo controle do reajuste

@author Flavio Lopes Rasta / Marcelo Ferreira
@since  07/08/2015
@version 1.0
@return oView
/*/
//--------------------------------------------------------------------
Function CN310Reaj(aContratos, cNumReaj, dDataRef, dDataApl, cTpRevisao)
Local oModel300 := Nil
Local oModel310 := Nil	
Local oModelCN9	:= Nil
Local oModelCNA	:= Nil
Local oModelCNB	:= Nil
Local oModelCXK := Nil
Local oModelCXL	:= Nil

Local aArea		:= GetArea()
Local aErro		:= {}
Local aFilCXL 	:= {}

Local cContra	:= ""
Local cRevisa	:= ""
Local cNovaRev	:= ""
Local cItemOri	:= ""
Local cItemDest	:= ""
Local cTipoCtr 	:= ""
Local cTipPla	:= ""

Local nX 		:= 0
Local nY		:= 0
Local nLineCXL	:= 0

Local lCNRJREV	:= SuperGetMv("MV_CNRJREV",.F.,.F.) // Habilita geração de revisão de contratos para reajuste automático
Local lRet		:= .F.
Local lFixo		:= .F.
Local lPrevF	:= .F.

cContra := aContratos[1]
cRevisa := aContratos[2]

DbSelectArea("CN9")
DbSetOrder(1)
If CN9->( DbSeek(xFilial('CN9')+cContra+cRevisa) )

	//Abre o modelo conforme parametro "MV_CNRJREV"
	oModel300 := FWLoadModel( IIf(CN9->CN9_ESPCTR == "1",'CNTA300','CNTA301') )
	A300STpRev(DEF_REV_REAJU)
	oModel300:SetOperation(MODEL_OPERATION_INSERT)
	lRet := oModel300:Activate(.T.) //Habilita a cópia de revisão
	
	//Este trecho permitia a revisão sem gerar novo registro (//discutir posteriormente a utilização)
	/*If lCNRJREV
		A300STpRev(DEF_REV_REAJU)
		oModel300:SetOperation(MODEL_OPERATION_INSERT)
		lRet := oModel300:Activate(.T.) //Habilita a cópia de revisão
	Else
		oModel300:SetOperation(MODEL_OPERATION_UPDATE)
		If ( lRet := oModel300:Activate() )
			A300STpRev(DEF_REV_REAJU)
			// Libera campos para edicao		
			oModel300:GetModel('CN9MASTER'):GetStruct():SetProperty("CN9_JUSTIF",MODEL_FIELD_WHEN,{||.T.})
			oModel300:GetModel('CN9MASTER'):GetStruct():SetProperty("CN9_TIPREV",MODEL_FIELD_WHEN,{||.T.})
		EndIf
	EndIf*/

	//Efetua o reajuste do contrato	
	If lRet
		oModel300:GetModel('CXLDETAIL'):SetOnlyQuery(.T.)
		oModelCN9 := oModel300:GetModel('CN9MASTER')
		oModelCN9:LoadValue('CN9_TIPREV',cTpRevisao)
		oModelCN9:LoadValue('CN9_DREFRJ',dDataRef)
		oModelCN9:LoadValue('CN9_DTREAJ',dDataApl)
		oModelCN9:LoadValue('CN9_JUSTIF',STR0009)
		cNovaRev := oModelCN9:GetValue('CN9_REVISA')
		cTipoCtr := oModelCN9:GetValue("CN9_TPCTO")
		lRet := CN300REAJU(oModel300) //Efetua reajuste do modelo
		If lRet
			CN310Retro(oModel300, dDataApl, dDataRef) // Valida se efeturá "Reajuste Retroativo"
			If ( lRet := oModel300:VldData() )
				oModelCNA := oModel300:GetModel("CNADETAIL")
				oModelCNB := oModel300:GetModel("CNBDETAIL")
				oModel300:CommitData()
			Endif
		Endif	
	EndIf

	//Efetua a aprovação da nova revisão
	If lRet .And. lCNRJREV
		CN9->( DbSetOrder(1) )
		If CN9->( DbSeek(xFilial('CN9')+cContra+cNovaRev) )
			If Alltrim(CN9->CN9_SITUAC) == DEF_SREVS .And. Empty(Alltrim(CN9->CN9_APROV)) //Aprovação automativa para contratos "Em Revisão" e "Sem alçada de aprovação"
				A300SATpRv(Cn300RetSt("TIPREV"))
				oModel300 := FWLoadModel( IIf(CN9->CN9_ESPCTR == "1",'CNTA300','CNTA301') )
				oModel300:SetOperation(MODEL_OPERATION_UPDATE)
				lRet := oModel300:Activate()
				If lRet
					If ( oModel300:VldData() )
						oModel300:CommitData()
					EndIf
				EndIf	
			Endif
		EndIf
	EndIf

	// Atualiza as tabelas de Logs de Reajustes (CXK e CXL)
	If lRet
		CXK->( dBSetOrder(1) )
		If CXK->( MsSeek(xFilial('CXK')+cNumReaj) )
			oModel310 := FWLoadModel('CNTA310')
			oModel310:SetOperation(MODEL_OPERATION_UPDATE)
			lRet := oModel310:Activate()
			
			If lRet
				
				oModelCXK := oModel310:GetModel("CXKMASTER")
				oModelCXL := oModel310:GetModel("CXLDETAIL")
				For nX := 1 To oModelCNA:Length()
					oModelCNA:GoLine(nX)
					If oModelCNA:GetValue('CNA_FLREAJ') == '1'  //Verifica se planilha aceita reajuste
						cTipPla		:= oModelCNA:GetValue("CNA_TIPPLA")
						lFixo		:= CN300PlaSt("FIXO",cTipoCtr,cTipPla)
						lPrevF		:= CN300PlaSt("PREVFINANC",cTipoCtr,cTipPla)
						// Se for contrato Não FIXO atualizará apenas as  planilhas, pois  esta não possuem itens
						If !lFixo .And. lPrevF
							aFilCXL := {}						
							aAdd(aFilCXL,{'CXL_CONTRA',cContra})
							aAdd(aFilCXL,{'CXL_REVISA',cRevisa})
							aAdd(aFilCXL,{'CXL_PLAN',oModelCNA:GetValue('CNA_NUMERO')})
							If (nLineCXL := MTFindMVC(oModelCXL,aFilCXL)) > 0
								oModelCXL:GoLine(nLineCXL)
								oModelCXL:SetValue('CXL_DTREAJ',oModelCNA:GetValue('CNA_DTREAJ'))	
								oModelCXL:SetValue('CXL_DTPROX',oModelCNA:GetValue('CNA_PROXRJ'))	
								oModelCXL:SetValue('CXL_VLATU',oModelCNA:GetValue('CNA_VLTOT'))
								oModelCXL:SetValue('CXL_VLAPL',Round((((oModelCNA:GetValue('CNA_VLTOT')/oModelCXL:GetValue('CXL_VLANT'))-1)*100), TamSx3("CXL_VLAPL")[2]) )
								oModelCXL:SetValue('CXL_SITUAC','C') //Processo Concluído para o item
							EndIf
						
						Else //-- Do Contrário, atualizará os itens da planilha
						
							For nY := 1 to oModelCNB:Length()
								oModelCNB:GoLine(nY)
								If oModelCNB:GetValue('CNB_FLREAJ') <> "2" //Verifica se item da planilha aceita reajuste
									cItemOri	:= oModelCNB:GetValue('CNB_ITEM')
									cItemDest	:= oModelCNB:GetValue('CNB_ITMDST')
									aFilCXL := {}						
									aAdd(aFilCXL,{'CXL_CONTRA',cContra})
									aAdd(aFilCXL,{'CXL_REVISA',cRevisa})
									aAdd(aFilCXL,{'CXL_PLAN',oModelCNB:GetValue('CNB_NUMERO')})
									aAdd(aFilCXL,{'CXL_ITEMPL',cItemOri})
									If (nLineCXL := MTFindMVC(oModelCXL,aFilCXL)) > 0
										oModelCXL:GoLine(nLineCXL)
										If Empty(cItemDest)
											oModelCXL:SetValue('CXL_DTREAJ',oModelCNB:GetValue('CNB_DTREAJ'))	
											oModelCXL:SetValue('CXL_DTPROX',oModelCNB:GetValue('CNB_PROXRJ'))	
											oModelCXL:SetValue('CXL_VLATU',oModelCNB:GetValue('CNB_VLUNIT'))
											oModelCXL:SetValue('CXL_VLAPL',Round((((oModelCNB:GetValue('CNB_VLUNIT')/oModelCXL:GetValue('CXL_VLANT'))-1)*100), TamSx3("CXL_VLAPL")[2]) )
											oModelCXL:SetValue('CXL_SITUAC','C') //Processo Concluído para o item
										Else
											oModelCXL:SetValue('CXL_ITEMPL', cItemDest) //Se o reajuste criou novo item, atualiza o log para código de item novo
										EndIf
									EndIf
								EndIf
							Next nY
							
						EndIf
					EndIf
				Next nX			
				oModelCXK:SetValue('CXK_DATFIM',dDatabase)
				oModelCXK:SetValue('CXK_HORFIM',Time())
				oModelCXK:SetValue('CXK_SITUAC','C') //Processo Concluído						
				If ( oModel310:VldData() )
					oModel310:CommitData()
				EndIf
			EndIf

		EndIf
	EndIf
	
	If !lRet				
		aErro := oModel300:GetErrorMessage()
		If !Empty(aErro[6] )
			If(IsBlind())
				AutoGrLog( "------------------------------------------------------------" )
				AutoGrLog( STR0010 + cContra )
				AutoGrLog( STR0011 + ' [' + AllToChar( aErro[1] ) + ']' )	//"Id do formulário de origem:"
				AutoGrLog( STR0012 + ' [' + AllToChar( aErro[2] ) + ']' )	//"Id do campo de origem: "
				AutoGrLog( STR0013 + ' [' + AllToChar( aErro[3] ) + ']' )	//"Id do formulário de erro: "
				AutoGrLog( STR0014 + ' [' + AllToChar( aErro[4] ) + ']' )	//"Id do campo de erro: "
				AutoGrLog( STR0015 + ' [' + AllToChar( aErro[5] ) + ']' )	//"Id do erro: "
				AutoGrLog( STR0016 + ' [' + AllToChar( aErro[6] ) + ']' )	//"Mensagem do erro: "
				AutoGrLog( STR0017 + ' [' + AllToChar( aErro[7] ) + ']' )	//"Mensagem da solução: "
				AutoGrLog( STR0018 + ' [' + AllToChar( aErro[8] ) + ']' )	//"Valor atribuído: "
				AutoGrLog( STR0019 + ' [' + AllToChar( aErro[9] ) + ']' )	//"Valor anterior: "
				AutoGrLog( "------------------------------------------------------------" )				
			Else
				MostraErro()			
			EndIf	
		EndIf
	Endif

	oModel300:DeActivate()
EndIf

RestArea( aArea )
Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} CN310Retro()
Reajuste Retroativo - Cálculo de valores devidos a serem cobrados de medições encerradas no preço antigo com data posterior a de aplicação do reajuste atual

@author Marcelo Ferreira
@since  29/08/2015
@version 1.0
@return Nil
/*/
//--------------------------------------------------------------------
Function CN310Retro(oModRetro, dDataApl, dDataRef)
Local aArea		:= GetArea()
Local oModCN9 	:= oModRetro:GetModel('CN9MASTER')
Local oModCNA 	:= NIL
Local oModCNB 	:= NIL
Local cTipRev 	:= oModCN9:GetValue('CN9_TIPREV')
Local cTipoCtr 	:= oModCN9:GetValue("CN9_TPCTO")
Local cAliasCNE	:= GetNextAlias()
Local nLinCNA	:= 0
Local nLineCNB	:= 0
Local nVlTotCNB	:= 0
Local nVlUnitCNB := 0
Local nDifMed 	 := 0
Local nVlrReaj	 := 0
Local nVlTotOri	 := 0
Local cQuery 	 := ""  
Local cContra 	 := ""
Local cRevisa 	 := ""
Local cTipPla	 := ""
Local lFixo		 := .F.
Local lPrevF	 := .F.

CN0->( dbSetOrder(1) )
If CN0->( dbSeek(xFilial("CN0")+cTipRev) )
	If CN0->CN0_RETRO = "1" // Apenas Tipo de Revisão que aceita reajuste retroativo
	
		// Seleciona medições que devem ser reajustadas retroativamente para que o saldo seja dispobilizado na planilha 	
		oModCNA := oModRetro:GetModel('CNADETAIL')
		cContra := oModCNA:GetValue('CNA_CONTRA')
		cRevisa := oModCNA:GetValue('CNA_REVISA')		
		cQuery := " SELECT CNE_NUMERO, CNE_ITEM, CNE.CNE_QUANT, CNE.CNE_VLUNIT, CNE.CNE_VLTOT "  
		cQuery += " FROM "+RetSqlName("CND")+" CND " 
		
		cQuery += " 	INNER JOIN "+RetSqlName("CXN")+" CXN " 
		cQuery += " 	ON  CXN.CXN_FILIAL = CND.CND_FILIAL " 
		cQuery += " 	AND CXN.CXN_CONTRA = CND.CND_CONTRA "  
		cQuery += " 	AND CXN.CXN_REVISA = CND.CND_REVISA " 
		cQuery += " 	AND CXN.CXN_NUMMED = CND.CND_NUMMED " 
		cQuery += " 	AND CXN.CXN_CHECK  = 'T' " 
		cQuery += " 	AND CXN.D_E_L_E_T_ = ' ' " 
		 
		cQuery += " 	INNER JOIN "+RetSqlName("CNE")+" CNE "  
		cQuery += " 	ON  CNE.CNE_FILIAL = CXN.CXN_FILIAL " 
		cQuery += " 	AND CNE.CNE_CONTRA = CXN.CXN_CONTRA " 
		cQuery += " 	AND CNE.CNE_REVISA = CXN.CXN_REVISA " 
		cQuery += " 	AND CNE.CNE_NUMERO = CXN.CXN_NUMPLA " 
		cQuery += " 	AND CNE.CNE_NUMMED = CXN.CXN_NUMMED " 
		cQuery += " 	AND CNE.D_E_L_E_T_ = ' ' " 
		cQuery += " 	AND CNE.CNE_VLTOT > 0 " 

		cQuery += " WHERE CND.CND_FILIAL = '"+xFilial("CND")+"' " 
		cQuery += "   AND CND.CND_CONTRA = '"+cContra+"' " 
		cQuery += "   AND CND.CND_REVISA = '"+cRevisa+"' " 
		cQuery += "   AND CND.D_E_L_E_T_ = ' ' " 
		cQuery += "   AND CND.CND_SITUAC = 'E' " 
		cQuery += "   AND CND.CND_DTINIC >= '"+DtoS(dDataApl)+"' "   
		cQuery += "   AND CND.CND_DTFIM <> ' ' "  // Medições encerradas
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCNE,.F.,.T.)
		
		If !(cAliasCNE)->(Eof())
			//-- Abre o Modelo
			A300OpenMd({||},.F.)
			oModCNB := oModRetro:GetModel('CNBDETAIL')
			While !(cAliasCNE)->(Eof())
				//Posiciona planilha
				If (nLinCNA := MTFindMVC(oModCNA,{{'CNA_NUMERO',(cAliasCNE)->CNE_NUMERO}})) > 0
					oModCNA:GoLine(nLinCNA)
					If oModCNA:GetValue('CNA_FLREAJ') == '1'  //Verifica se planilha aceita reajuste
						nVlrReaj	:= 0
						nVlTotOri	:= oModCNA:GetValue("CNA_VLTOT") // Guarda valor inicial da CNA para usar no cronograma
						cTipPla		:= oModCNA:GetValue("CNA_TIPPLA")
						lFixo		:= CN300PlaSt("FIXO",cTipoCtr,cTipPla)
						lPrevF		:= CN300PlaSt("PREVFINANC",cTipoCtr,cTipPla) 
						
						// Se for contrato Não FIXO atualizará apenas as  planilhas, pois  esta não possuem itens
						If !lFixo .And. lPrevF
						
							cIndice	:= If(Empty(oModCNA:GetValue("CNA_INDICE")), oModCN9:GetValue("CN9_INDICE"), oModCNA:GetValue("CNA_INDICE"))
							nVlrReaj := Round( (cAliasCNE)->CNE_VLTOT * (A300VlrInd(cIndice, dDataRef)-1),TamSx3("CNE_VLTOT")[2])
							oModCNA:SetValue("CNA_VLTOT",oModCNA:GetValue("CNA_VLTOT")+nVlrReaj)
						
						Else //Do Contrário, atualizará os itens da planilha
							
							//Busca Item
							If (nLineCNB := MTFindMVC(oModCNB,{{'CNB_ITEM',(cAliasCNE)->CNE_ITEM}}) ) > 0
								oModCNB:GoLine(nLineCNB)
								If oModCNB:GetValue('CNB_FLREAJ') <> '2'  //Verifica se item da planilha aceita reajuste
									cItemDest	:= oModCNB:GetValue('CNB_ITMDST')
						
									// Verifica se nao existe item destino de reajuste criado a partir do saldo para medição 
									If !Empty(cItemDest)
										If (nLineCNB := MTFindMVC(oModCNB,{{'CNB_ITEM',cItemDest}}) ) > 0
											oModCNB:GoLine(nLineCNB)
										EndIf
									EndIf
			
									// Atualiza item com valor devido a ser medido retroativamente por causa do reajuste
									nVlTotCNB	:= oModCNB:GetValue('CNB_VLTOT')
									nVlUnitCNB	:= oModCNB:GetValue('CNB_VLUNIT')
									nDifMed 	:= nVlUnitCNB - (cAliasCNE)->CNE_VLUNIT
									If nDifMed > 0 
										nVlTotCNB	:= nVlTotCNB + (nDifMed * (cAliasCNE)->CNE_QUANT)
										nVlUnitCNB	:= nVlTotCNB / oModCNB:GetValue('CNB_QUANT')
										oModCNB:SetValue('CNB_VLUNIT', nVlUnitCNB)	
									EndIf
								EndIf
							EndIf
						EndIf
					
						//Função para alocar valor retroativo de reajuste no cronograma financeiro
						nVlrReaj := oModCNA:GetValue("CNA_VLTOT") - nVlTotOri
						If nVlrReaj > 0
							A310CroRetro(oModRetro, nVlrReaj) 
						EndIf
					EndIf
				EndIf
				(cAliasCNE)->( dbSkip() )
			EndDo
			//-- Fecha o Modelo
			A300Revisa(oModRetro,A300GTpRev())
		EndIf
	EndIf 
EndIf

RestArea( aArea )

Return Nil

//------------------------------------------------------------------
/*/{Protheus.doc} A310CroRetro()
Função para alocar valor retroativo de reajuste no cronograma financeiro

@author Marcelo Ferreira
@since 02/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function A310CroRetro(oModel, nVlrReaj)
Local aSaveLines	:= FWSaveRows()
Local oModCNF		:= oModel:GetModel("CNFDETAIL")
Local nF			:= 0

//- Aloca valor reajustado na primeira parcela com saldo do cronograma financeiro
oModCNF:SetNoUpdateLine(.F.)
For nF:= 1 To oModCNF:Length()
	oModCNF:GoLine(nF)
	If oModCNF:GetValue("CNF_SALDO") > 0 // Ainda não foi totalmente medido
		oModCNF:SetValue("CNF_VLPREV",oModCNF:GetValue("CNF_VLPREV")+nVlrReaj)
		Exit
	EndIf
Next nF
oModCNF:SetNoUpdateLine(.T.)

FWRestRows(aSaveLines)

Return Nil

//------------------------------------------------------------------
/*/{Protheus.doc} CN310PVld()
Efetua a validação dos perguntes obrigatórios

@author Marcelo Ferreira
@since 04/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function CN310PVld()
Local lRet 		:= .T.
Local dDataRef	:= (mv_par08)
Local cTipRev	:= (mv_par10)

If Empty(dDataRef)
	Help(,,"CNTA310DRE",, STR0020 , 1, 0 )
	lRet := .F.
ElseIf Empty(cTipRev)
	Help(,,"CNTA310RJ",,  STR0021 , 1, 0 )
	lRet := .F.
EndIf

Return lRet

//------------------------------------------------------------------
/*/{Protheus.doc} A310TpRevRj()
Validação do Tipo de Revisão de Reajuste

@author Marcelo Ferreira
@since 04/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Function A310TpRevRj(cTipRev)
Local lRet := .F.

CN0->( dbSetOrder(1) )
If CN0->( dbSeek(xFilial("CN0")+cTipRev) )
	If CN0->CN0_TIPO == '2'
		lRet := .T.
	Else
		Help(,,"CNTA310TPR",, "Selecione um tipo de revisão de reajuste." , 1, 0 )
	EndIf
EndIf

Return lRet
