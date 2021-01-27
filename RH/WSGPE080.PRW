#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PAGE_LENGTH 10

Function WSGPE080()
Return

WSSTRUCT TAnnualReceiptsList
	WSDATA Company		As String
	WSDATA Branch		As String
	WSDATA TaxYear		As String
	WSDATA DMRelease	As String
	WSDATA DMReport		As String
	WSDATA Responsible	As String
	WSDATA Mat			As String
	WSDATA InformeOK	As boolean
ENDWSSTRUCT

WSSTRUCT TAnnualReceiptsBrowse
	WSDATA Itens		AS Array Of TAnnualReceiptsList	OPTIONAL
	WSDATA PagesTotal	AS Integer 						OPTIONAL
ENDWSSTRUCT

WSSERVICE RHAnnualReceipts DESCRIPTION "Informe de Rendimento"
	WSDATA WsNull   	   		As String	OPTIONAL
	WSDATA Branch				As String
	WSDATA Registration			As String
	WSDATA Type					As Integer

	WSDATA CurrentPage			As Integer	OPTIONAL
	WSDATA FilterField  		As String	OPTIONAL
	WSDATA FilterValue			As String	OPTIONAL
	
	WSDATA TaxYear   	   		As String	OPTIONAL				
	WSDATA DMRelease   	   		As String	OPTIONAL
	WSDATA DMReport   	   		As String	OPTIONAL
	WSDATA Responsible   	   	As String	OPTIONAL
	WSDATA Company		   	   	As String	OPTIONAL
	WSDATA Mat			   	   	As String	OPTIONAL
	
	WSDATA ContHtml				AS String	OPTIONAL
	
	WSDATA AnnualReceiptsBrowse	As TAnnualReceiptsBrowse 
	
	
	WSMETHOD BrowseAnnualReceipts	DESCRIPTION "Método de consulta do informe de rendimento disponibilizados"
	WSMETHOD GetAnnualReceipt		DESCRIPTION "Método para consulta o informe de rendimento selecionado"	
ENDWSSERVICE                                  

WSMETHOD BrowseAnnualReceipts;
WSRECEIVE Branch, Registration, CurrentPage, FilterField, FilterValue;
WSSEND AnnualReceiptsBrowse;
WSSERVICE RHAnnualReceipts   
	Local aArea     := GetArea()
	Local aDados	:= {}
	Local aTransf	:= {}
	Local aEmps		:= {}	
	Local cARAlias
	Local cFiltro	:= ""
	Local cUnion	:= ""
	Local nCont		:= 0
	Local nTamTransf:= 0
	Local nX        := 0
	Local nPosDel	:= 0

	dbSelectArea("SRA")
	dbSetOrder(1)

	If !dbSeek( Self:Branch + Self:Registration)
		Return .F.
	Endif

	fTransfAll(@aTransf, Nil, Nil, .T.)
	nTamTransf	:= Len(aTransf)
	
 	If nTamTransf > 0
 	
		For nX:=1 To nTamTransf // Monto um array de empresas para gerar as querys de acordo com cada empresa
			If aTransf[nX][1] <> aTransf[nX][4] .And. aScan(aEmps,aTransf[nX][1]) == 0 // Só incluo empresas diferentes e que não estão no aEmps, para não gerar duplicidades
				aAdd(aEmps,aTransf[nX][1])
			EndIf
		Next
		
		If Len(aEmps) > 1 
			nPosDel := aScan(aEmps,cEmpAnt)
			If nPosDel > 0 // Verifico se preciso deletar o grupo de empresa atual, pois na query padrão o sistema irá utilizar as tabelas do grupo atual
				aDel(aEmps,nPosDel)
				aSize(aEmps,Len(aEmps)-1)
			EndIf
		EndIf
		
 		cFiltro += "("
		
		For nCont := 1 To nTamTransf
			If nCont > 1
				cFiltro += " OR "
			EndIf
			cFiltro += " (SR4.R4_FILIAL = '" +aTransf[nCont, 8]+ "'"
			cFiltro += " AND SR4.R4_MAT = '" +aTransf[nCont, 9]+ "') "
		Next nCont
		cFiltro += " OR "				 		
  	EndIf  	

	cFiltro	+= " SR4.R4_FILIAL = '" + Self:Branch + "' AND SR4.R4_MAT = '" + Self:Registration + "'"
	
	If nTamTransf > 0
		cFiltro += ")"
	EndIf

	cFiltro	+= " AND RHX.RHX_FILIAL = '" + xFilial("RHX", Self:Branch) + "'"
	
	If FilterField == "TaxYear" .AND. Len(FilterValue) > 0
		cFiltro	+= " AND RHX.RHX_ANOBAS = '" + FilterValue + "'"
	EndiF
	
	cFiltro := "% " + cFiltro + " %"
			 
	cARAlias:= GetNextAlias()

	If Len(aEmps) > 0 // Criação da query para outros grupos de empresas
		For nX := 1 To Len(aEmps)
			cUnion += "% UNION "
			cUnion += "SELECT DISTINCT(SR4.R4_ANO) "
			cUnion += ", SR4.R4_MAT" 
			cUnion += ", SR4.R4_FILIAL"
			cUnion += ", RHX.RHX_ANOBAS"
			cUnion += ", RHX.RHX_DMLIBE"
			cUnion += ", RHX.RHX_DMINFO"
			cUnion += ", RHX.RHX_RESPON"
			cUnion += ", '" + aEmps[nX] + "' AS RHX_EMP "
			cUnion += "FROM " + RetFullName("RHX",aEmps[nX]) + " RHX "
			cUnion += "INNER JOIN " + RetFullName("SR4",aEmps[nX]) + " SR4 "
			cUnion += "ON SR4.R4_ANO = RHX.RHX_ANOBAS "
			cUnion += "WHERE " + StrTran(cFiltro, "%", "")
			cUnion += "AND RHX.D_E_L_E_T_= ' ' "
			cUnion += "AND SR4.D_E_L_E_T_= ' ' %"
		Next
	Else
		cUnion := "%%"
	EndIf
	
	BeginSql alias cARAlias
	
		SELECT DISTINCT(SR4.R4_ANO)
			 , SR4.R4_MAT 
			 , SR4.R4_FILIAL
			 , RHX.RHX_ANOBAS
		     , RHX.RHX_DMLIBE
		     , RHX.RHX_DMINFO
		     , RHX.RHX_RESPON
		     , %exp:cEmpAnt% AS RHX_EMP
		  FROM %table:RHX% RHX
    INNER JOIN %table:SR4% SR4
            ON SR4.R4_ANO = RHX.RHX_ANOBAS
         WHERE %exp:cFiltro% 
           AND RHX.%notDel% 
           AND SR4.%notDel%
          %exp:cUnion%
      ORDER BY RHX_ANOBAS DESC
	EndSql
	
	While (cARAlias)->( !Eof())
		If Date() >= SToD( Soma1((cARAlias)->RHX_ANOBAS) + Substr( (cARAlias)->RHX_DMLIBE, 3, 4) + Substr( (cARAlias)->RHX_DMLIBE, 1, 2) ) 
	
			oItem:= WSClassNew("TAnnualReceiptsList")
			oItem:TaxYear		:= (cARAlias)->RHX_ANOBAS
			oItem:DMRelease		:= (cARAlias)->RHX_DMLIBE
			oItem:DMReport		:= (cARAlias)->RHX_DMINFO
			oItem:Responsible	:= (cARAlias)->RHX_RESPON
			oItem:Mat			:= (cARAlias)->R4_MAT				
			oItem:Branch		:= (cARAlias)->R4_FILIAL				
			oItem:Company		:= (cARAlias)->RHX_EMP
			oItem:InformeOK		:= Date() >= SToD( Soma1((cARAlias)->RHX_ANOBAS) + Substr( (cARAlias)->RHX_DMLIBE, 3, 4) + Substr( (cARAlias)->RHX_DMLIBE, 1, 2) )
			AAdd(Self:AnnualReceiptsBrowse:Itens, oItem)
		
		EndIf	

		(cARAlias)->( dbSkip() )
	EndDo 
	(cARAlias)->( dbCloseArea() )
	RestArea(aArea)
	  		
Return .T.

WSMETHOD GetAnnualReceipt;
WSRECEIVE Branch, Registration, TaxYear, DMRelease, DMReport, Responsible, Company;
WSSEND ContHtml;
WSSERVICE RHAnnualReceipts
	Local lTerminal	:= .T.
	Local lPortal	:= .T.
	Local lRet		:= .F.
	Local cARAlias
	Local aArea		:= GetArea()
	Local cBkpEmp	 := cEmpAnt
	Local cBckFil	 := cFilAnt
	Local cAliasSRA  := "SRA"
	Local cAliasRHX  := "RHX"
	Local cAliasSRL  := "SRL"
	Local cAliasSR4  := "SR4"
	Local cAliasRCS  := "RCS"
	Local cModoSRA	 := FWModeAccess(cAliasSRA)
	Local cModoRHX	 := FWModeAccess(cAliasRHX)
	Local cModoSRL	 := FWModeAccess(cAliasSRL)
	Local cModoSR4	 := FWModeAccess(cAliasSR4)
	Local cModoRCS	 := FWModeAccess(cAliasRCS)
	
	Private cNomeResp := Responsible
	
	Default ::Company := cEmpAnt
	
	If Self:Company <> cEmpAnt // Abertura das novas tabelas de outros grupos de empresa
		OpenSx2Temp(Self:Company,Self:Branch)
		
		MyOpenFilePortal(cAliasSRA,cAliasSRA,1,.T.,Self:Company,@cModoSRA)
		MyOpenFilePortal(cAliasRHX,cAliasRHX,1,.T.,Self:Company,@cModoRHX)
		MyOpenFilePortal(cAliasSRL,cAliasSRL,1,.T.,Self:Company,@cModoSRL)
		MyOpenFilePortal(cAliasSR4,cAliasSR4,1,.T.,Self:Company,@cModoSR4)
		MyOpenFilePortal(cAliasRCS,cAliasRCS,1,.T.,Self:Company,@cModoRCS)
	EndIf
	
	cARAlias:= GetNextAlias()  
	
	BeginSql alias cARAlias
	
		SELECT  RHX.RHX_FILIAL
			 , RHX.RHX_ANOBAS
		     , RHX.RHX_DMLIBE
		     , RHX.RHX_DMINFO
		     , RHX.RHX_RESPON
		  FROM %table:RHX% RHX
         WHERE RHX.RHX_FILIAL = %exp:xFilial("RHX", Self:Branch) %
         	AND RHX.RHX_ANOBAS =%exp:self:TaxYear%
           AND RHX.%notDel% 
      ORDER BY RHX_ANOBAS DESC
	EndSql
	
	If !(cARAlias)->(Eof())
		If Date() >= SToD( Soma1((cARAlias)->RHX_ANOBAS) + Substr( (cARAlias)->RHX_DMINFO, 3, 4) + Substr( (cARAlias)->RHX_DMINFO, 1, 2) )
			Self:ContHtml := GPEM580(lTerminal, Padr(Self:Branch,FWGETTAMFILIAL), Self:Registration, Self:TaxYear, lPortal)
			lRet := .T.
		EndIf
	EndIf
	(cARAlias)->( dbCloseArea() )
	
	If !lRet
		SetSoapFault("GetAnnualReceipt","Informe de rendimento não liberado ainda.")
	EndIf
	
	If Self:Company <> cBkpEmp // Volto para o que estava antes de abrir as novas tabelas.
		OpenSx2Temp(cBkpEmp,Self:Branch)
		
		MyOpenFilePortal(cAliasSRA,cAliasSRA,1,.T.,cBkpEmp,@cModoSRA)
		MyOpenFilePortal(cAliasRHX,cAliasRHX,1,.T.,cBkpEmp,@cModoRHX)
		MyOpenFilePortal(cAliasSRL,cAliasSRL,1,.T.,cBkpEmp,@cModoSRL)
		MyOpenFilePortal(cAliasSR4,cAliasSR4,1,.T.,cBkpEmp,@cModoSR4)
		MyOpenFilePortal(cAliasRCS,cAliasRCS,1,.T.,cBkpEmp,@cModoRCS)
		
		cEmpAnt := cBkpEmp
		cFilAnt := cBckFil		
	EndIf
	
	RestArea(aArea)
	
Return lRet

/*/{Protheus.doc} MyOpenFilePortal()
- Abertura de arquivo para a empresa especificada.
@param: x1 - Alias - Tabela utilizada
@param: x2 - Alias - Tabela utilizada
@param: x3 - Padrão - .T.
@param: x4 - Company - Cóigo da empresa utilizada.
@param: x5 - Modo de compartilhamento da tabela.
/*/
Static Function MyOpenFilePortal(x1,x2,x3,x4,x5,x6)
Local cSavE := cEmpAnt, cSavF := cFilAnt, xRet

xRet	:= EmpOpenFile(@x1,@x2,@x3,@x4,@x5,@x6)

cEmpAnt := x5

Return( xRet )

Static Function OpenSx2Temp(cEmp,cBckFil)

	cEmpAnt := cEmp
	cFilAnt := cBckFil	
	SX6->(dbclosearea())
	OpenSxs(,,,,cEmp,"SX6","SX6",,.F.)
	SX2->(dbclosearea())
	OpenSxs(,,,,cEmp,"SX2","SX2",,.F.)
	
Return