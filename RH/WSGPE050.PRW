#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

//Client: WsClient_WsRHDependents.prx

Function WSGPE050()
Return

WSSTRUCT TDependent
	WSDATA Name			AS String
	WSDATA BirthDate		AS Date
	WSDATA Sex				AS String
	WSDATA KinshipDegree	AS String
	WSDATA DataBaixa		AS Date
	WSDATA TipSf			AS String OPTIONAL
	WSDATA TipIr			AS String OPTIONAL
	WSDATA LocNasc 			AS String OPTIONAL
	WSDATA Cartorio			AS String OPTIONAL
	WSDATA Cic				AS String OPTIONAL
	WSDATA TpDep			AS String OPTIONAL
	WSDATA CodDep			AS String OPTIONAL
	WSDATA PlanOdont		As String OPTIONAL
	WSDATA AssistMedic		As String OPTIONAL
ENDWSSTRUCT

WSSTRUCT TDependentEmployee
	WSDATA Branch					AS String 
	WSDATA Registration				AS String 
	WSDATA Name						As String
	WSDATA BirthDate				As Date
	WSDATA AdmissionDate			As Date
	WSDATA CostCenterCode			As String
	WSDATA CostCenterDescription	As String
	WSDATA PositionCode				As String
	WSDATA PositionDescription		As String
	WSDATA DepartmentCode			As String
	WSDATA DepartmentDescription	As String
ENDWSSTRUCT

WSSTRUCT TDependentData
	WSDATA Employee		As TDependentEmployee
	WSDATA Dependents		As Array Of TDependent OPTIONAL
ENDWSSTRUCT

WSSTRUCT FieldsDependents
	WSDATA cicAux 					AS String OPTIONAL		//CPF PARA USO AUXILIAR
	WSDATA tpDepAux					AS String OPTIONAL		//TIPO DO DEPENDETE PARA USO AUXILIAR
	WSDATA cicDep 					AS String OPTIONAL		//CPF DEPENDENTE
	WSDATA tpDep   					AS String OPTIONAL		//TIPO DEPENDENTE
	WSDATA dtNasc 					AS Date   OPTIONAL		//DATA DE NASCIMENTO
	WSDATA tipoDepIr				AS String OPTIONAL		//TIPO DE DEPENDENTE PARA IR
	WSDATA tipoDepSalF				As String OPTIONAL		//TIPO DE DEPENDENTE PARA SALÁRIO FAM.
	WSDATA nomeDep					AS String OPTIONAL		//NOME DO DEPENDENTE
ENDWSSTRUCT

WSSERVICE RHDependents DESCRIPTION "Dependentes"
	WSDATA Branch				AS String
	WSDATA Registration			AS String
	WSDATA codDependent			As String OPTIONAL
	WSDATA DependentData		AS TDependentData


	/***************************
	 - PROPIEDADES ESOCIAL.
	****************************/
	WSDATA DependentESoc As TDependentData
	WSDATA DadosDependent					AS FieldsDependents OPTIONAL
	WSDATA CodigoDep							AS String OPTIONAL
	WSDATA MsgRet								AS String OPTIONAL
	
	WSMETHOD BrowseDependents	DESCRIPTION "Método de consulta os dependentes do funcionario"
	WSMETHOD GetDepESoc				DESCRIPTION 'Método que retorna o dependente baseado em seu código.'
	WSMETHOD AddAlteracaoDependent 	DESCRIPTION 'Método que altera dependente do funcionário ( Alteração Cadastral eSocial).'
ENDWSSERVICE                                  

WSMETHOD BrowseDependents;
WSRECEIVE Branch, Registration;
WSSEND DependentData;
WSSERVICE RHDependents
	Self:DependentData:= WSClassNew("TDependentData")
	Self:DependentData:Employee:= GetEmployee(Self:Branch, Self:Registration)
	Self:DependentData:Dependents:= GetDependents(Self:Branch, Self:Registration)
Return .T.

WSMETHOD GetDepESoc WSRECEIVE Branch, Registration, codDependent WSSEND DependentESoc WSSERVICE RHDependents
	Self:DependentESoc:= WSClassNew("TDependentData")
	Self:DependentESoc:Employee := GetEmployee(Self:Branch, Self:Registration)
	Self:DependentESoc:Dependents := GetDepESoc(Self:Branch, Self:Registration, Self:codDependent)
Return .T.

/*********************************************
- EFETUA ALTERAÇÃO NO DEPENDENTE BASEADO EM
- SEU CÓDIGO.
- PORTAL GCH - ESOCIAL.
*********************************************/
WSMETHOD AddAlteracaoDependent WSRECEIVE Registration ,CodigoDep, DadosDependent, Branch WSSEND MsgRet WSSERVICE RHDependents

	Local nInd := 1 // MATRÍCULA.
	Local lRet := .T.
	
	DEFAULT ::MsgRet := ''
	
	SRB->( DBSelectArea('SRB') )
	SRB->( DBSetOrder(nInd) )
	If SRB->( dbSeek(xFilial("SRB", ::Branch ) + ::Registration ) )
        While SRB->( ! EOF() )
        	If SRB->RB_COD == Alltrim(::CodigoDep) .and. SRB->RB_MAT == ::Registration .and. SRB->RB_FILIAL == ::Branch
        		Self:DadosDependent:cicAux		:= SRB->RB_CIC
        		Self:DadosDependent:tpDepAux	:= SRB->RB_TPDEP
        		RECLOCK('SRB',.F.)
					SRB->RB_CIC 	:= Self:DadosDependent:cicDep
					SRB->RB_TPDEP	:= Self:DadosDependent:tpDep
				MSUNLOCK()
				::MsgRet := 'Alterado'
			EndIF
		SRB->( DbSkip() )
		EndDo
	Else
		SetSoapFault('Erro', 'Não foi possível encontrar a Matrícula.')//"Erro" - "Usuario nao autorizado"
	 	lRet := .F.
	EndIF

Return( lRet )

Static Function GetDepESoc(cBranch, cRegistration, cCodDependent)
	Local oItem
	Local aCbox			:= {}
	Local cQuery		:= GetNextAlias()
	Local aDependents	:= {}
	
	
	BEGINSQL ALIAS cQuery
		COLUMN RB_DTNASC  AS DATE
		COLUMN RB_DTBAIXA AS DATE
		
		SELECT
		SRB.RB_NOME,
		SRB.RB_DTNASC,
		SRB.RB_SEXO,
		SRB.RB_GRAUPAR,
		SRB.RB_DTBAIXA,
		SRB.RB_TIPSF,
		SRB.RB_TIPIR,
		SRB.RB_LOCNASC,
		SRB.RB_CARTORI,
		SRB.RB_TPDEP,
		SRB.RB_CIC,
		SRB.RB_COD
		FROM
		%Table:SRB% SRB
		WHERE
		SRB.RB_FILIAL = %Exp:cBranch% AND
		SRB.RB_MAT = %Exp:cRegistration% AND
		SRB.RB_COD = %Exp:cCodDependent% AND
		SRB.%NotDel%
	ENDSQL
	
	DbSelectArea("RHL")
	RHL->(DBSetOrder(2))//RHL_FILIAL+RHL_MAT+RHL_CODIGO+RHL_TPFORN+RHL_CODFOR
	While !(cQuery)->(Eof())
		oItem:= WSClassNew("TDependent")
		oItem:Name			:= (cQuery)->RB_NOME
		oItem:BirthDate		:= (cQuery)->RB_DTNASC
		oItem:Sex			:= GetBoxDescription("RB_SEXO", (cQuery)->RB_SEXO)
		oItem:KinshipDegree	:= GetBoxDescription("RB_GRAUPAR", (cQuery)->RB_GRAUPAR)
		oItem:DataBaixa 	:= (cQuery)->RB_DTBAIXA
		aCbox				:= RetSx3Box( Posicione("SX3", 2, "RB_TIPSF", "X3CBox()" ),,, 1 )
		oItem:TipSf 		:= IIF(!Empty((cQuery)->RB_TIPSF),aCbox[aScan(aCbox,{|x| x[2]==(cQuery)->RB_TIPSF})][1],"")//Descrição do Valor
		aCbox				:= RetSx3Box( Posicione("SX3", 2, "RB_TIPIR", "X3CBox()" ),,, 1 )
		oItem:TipIr 		:= IIF(!Empty((cQuery)->RB_TIPIR),aCbox[aScan(aCbox,{|x| x[2]==(cQuery)->RB_TIPIR})][1],"")//Descrição do Valor
		oItem:LocNasc 		:= (cQuery)->RB_LOCNASC
		oItem:Cartorio 		:= (cQuery)->RB_CARTORI
		oItem:TpDep 		:= (cQuery)->RB_TPDEP
		oItem:Cic	  		:= (cQuery)->RB_CIC
		oItem:CodDep 		:= (cQuery)->RB_COD
		oItem:AssistMedic	:= "Não"
		oItem:PlanOdont		:= "Não"
		If RHL->(dbSeek(xFilial("RHL")+cRegistration+(cQuery)->RB_COD+'1'))
			While !RHL->(Eof()) .And.;
				 (xFilial("RHL")+cRegistration+(cQuery)->RB_COD+'1')== (RHL_FILIAL+RHL_MAT+RHL_CODIGO+RHL_TPFORN) 
				If Left(Right(RHL->RHL_PERINI,4)+RHL->RHL_PERINI,6) <= MESANO(dDataBase) .And. (Left(Right(RHL->RHL_PERFIM,4)+RHL->RHL_PERFIM,6) >=MESANO(dDataBase) .Or. Empty(RHL->RHL_PERFIM))
					oItem:AssistMedic	:= "Sim"
				EndIF
				RHL->(dbSkip()) 
			EndDo
		EndIF
		If RHL->(dbSeek(xFilial("RHL")+cRegistration+(cQuery)->RB_COD+'2'))
			While !RHL->(Eof()) .And.;
				 (xFilial("RHL")+cRegistration+(cQuery)->RB_COD+'2')== (RHL_FILIAL+RHL_MAT+RHL_CODIGO+RHL_TPFORN) 
				If Left(Right(RHL->RHL_PERINI,4)+RHL->RHL_PERINI,6) <= MESANO(dDataBase) .And. (Left(Right(RHL->RHL_PERFIM,4)+RHL->RHL_PERFIM,6) >=MESANO(dDataBase) .Or. Empty(RHL->RHL_PERFIM))  
					oItem:PlanOdont		:= "Sim"					
				EndIF
				RHL->(dbSkip())
			EndDo
		EndIF
			AAdd(aDependents, oItem)
			
			(cQuery)->(DBSkip())
		EndDo
		
		(cQuery)->(DBCloseArea())
		Return aDependents


Static Function GetDependents(cBranch, cRegistration)
	Local oItem
	Local cMesAno	:= StrZero(MONTH(dDatabase),2)+Alltrim(Str(Year(dDatabase)))
	Local aCbox	:= {}
	Local cQuery:= GetNextAlias()
	Local aDependents:= {}	
			
	BEGINSQL ALIAS cQuery
		COLUMN RB_DTNASC  AS DATE
		COLUMN RB_DTBAIXA AS DATE

		SELECT 
			SRB.RB_NOME,
			SRB.RB_DTNASC,
			SRB.RB_SEXO,
			SRB.RB_GRAUPAR,
			SRB.RB_DTBAIXA,
			SRB.RB_TIPSF,
			SRB.RB_TIPIR,
			SRB.RB_LOCNASC,
			SRB.RB_CARTORI,
			SRB.RB_TPDEP,
			SRB.RB_CIC,
			SRB.RB_COD
		FROM 
			%Table:SRB% SRB
		WHERE 
			SRB.RB_FILIAL = %Exp:cBranch% AND 
			SRB.RB_MAT = %Exp:cRegistration% AND
			SRB.%NotDel%
	ENDSQL
		  
	DbSelectArea("RHL")
	RHL->(DBSetOrder(2))//RHL_FILIAL+RHL_MAT+RHL_CODIGO+RHL_TPFORN+RHL_CODFOR
	
	While !(cQuery)->(Eof())
		oItem:= WSClassNew("TDependent")
		oItem:Name			:= (cQuery)->RB_NOME
		oItem:BirthDate		:= (cQuery)->RB_DTNASC
		oItem:Sex			:= GetBoxDescription("RB_SEXO", (cQuery)->RB_SEXO)
		oItem:KinshipDegree	:= GetBoxDescription("RB_GRAUPAR", (cQuery)->RB_GRAUPAR)
		oItem:DataBaixa 	:= (cQuery)->RB_DTBAIXA
		aCbox				:= RetSx3Box( Posicione("SX3", 2, "RB_TIPSF", "X3CBox()" ),,, 1 )
		oItem:TipSf 		:= IIF(!Empty((cQuery)->RB_TIPSF),aCbox[aScan(aCbox,{|x| x[2]==(cQuery)->RB_TIPSF})][1],"")//Descrição do Valor
		aCbox				:= RetSx3Box( Posicione("SX3", 2, "RB_TIPIR", "X3CBox()" ),,, 1 )
		oItem:TipIr 		:= IIF(!Empty((cQuery)->RB_TIPIR),aCbox[aScan(aCbox,{|x| x[2]==(cQuery)->RB_TIPIR})][1],"")//Descrição do Valor
		oItem:LocNasc 		:= (cQuery)->RB_LOCNASC
		oItem:Cartorio 		:= (cQuery)->RB_CARTORI
		oItem:TpDep 		:= (cQuery)->RB_TPDEP
		oItem:Cic	  		:= (cQuery)->RB_CIC
		oItem:CodDep 		:= (cQuery)->RB_COD
		oItem:AssistMedic	:= "Não"
		oItem:PlanOdont		:= "Não"

		If RHL->(dbSeek(xFilial("RHL",cBranch)+cRegistration+(cQuery)->RB_COD+'1'))
			While !RHL->(Eof()) .And.;
				 (xFilial("RHL",cBranch)+cRegistration+(cQuery)->RB_COD+'1')== (RHL_FILIAL+RHL_MAT+RHL_CODIGO+RHL_TPFORN) 
				If Left(Right(RHL->RHL_PERINI,4)+RHL->RHL_PERINI,6) <= MESANO(dDataBase) .And. (Left(Right(RHL->RHL_PERFIM,4)+RHL->RHL_PERFIM,6) >=MESANO(dDataBase) .Or. Empty(RHL->RHL_PERFIM))
					oItem:AssistMedic	:= "Sim"
				EndIF
				RHL->(dbSkip())
			EndDo
		EndIF
		If RHL->(dbSeek(xFilial("RHL",cBranch)+cRegistration+(cQuery)->RB_COD+'2'))
			While !RHL->(Eof()) .And.;
				 (xFilial("RHL",cBranch)+cRegistration+(cQuery)->RB_COD+'2')== (RHL_FILIAL+RHL_MAT+RHL_CODIGO+RHL_TPFORN) 
				If Left(Right(RHL->RHL_PERINI,4)+RHL->RHL_PERINI,6) <= MESANO(dDataBase) .And. (Left(Right(RHL->RHL_PERFIM,4)+RHL->RHL_PERFIM,6) >=MESANO(dDataBase) .Or. Empty(RHL->RHL_PERFIM))
					oItem:PlanOdont		:=	"Sim"
				EndIF
				RHL->(dbSkip())
			EndDo
		EndIF
		AAdd(aDependents, oItem)

		(cQuery)->(DBSkip())
	EndDo

	(cQuery)->(DBCloseArea())
Return aDependents
Static Function GetEmployee(cBranch, cRegistration)
	Local cQuery:= GetNextAlias()
	Local oEmployee:= WSClassNew("TDependentEmployee")
	Local cSRABranch:= xFilial("SRA", cBranch)
	Local cCTTBranch:= xFilial("CTT", cBranch)
	Local cSQ3Branch:= xFilial("SQ3", cBranch)
	Local cSQBBranch:= xFilial("SQB", cBranch)
			
	BEGINSQL ALIAS cQuery
		COLUMN RA_NASC AS DATE
		COLUMN RA_ADMISSA AS DATE

		SELECT
			RA_FILIAL,
			RA_MAT,
			RA_NOME,
			RA_NASC,
			RA_ADMISSA,
			CTT_CUSTO,
			CTT_DESC01,
			Q3_CARGO,
			Q3_DESCSUM,
			QB_DEPTO,
			QB_DESCRIC
		FROM 
			%Table:SRA% SRA
		LEFT OUTER JOIN %Table:CTT% CTT
			 ON CTT.CTT_CUSTO = SRA.RA_CC AND
				CTT.CTT_FILIAL = %Exp:cCTTBranch% AND
				CTT.%NotDel%
		LEFT OUTER JOIN %Table:SQ3% SQ3
			 ON SQ3.Q3_CARGO = SRA.RA_CARGO AND
				SQ3.Q3_FILIAL = %Exp:cSQ3Branch% AND
				SQ3.%NotDel%			 
		LEFT OUTER JOIN %Table:SQB% SQB
			 ON SQB.QB_DEPTO = SRA.RA_DEPTO AND
				SQB.QB_FILIAL = %Exp:cSQBBranch% AND
				SQB.%NotDel%			 
		WHERE 
			SRA.RA_MAT = %Exp:cRegistration% AND
			SRA.RA_FILIAL = %Exp:cSRABranch% AND
			SRA.%NotDel%			
	ENDSQL
	
	If !Eof()
		oEmployee:Branch				:= AllTrim((cQuery)->RA_FILIAL)
		oEmployee:Registration			:= AllTrim((cQuery)->RA_MAT)
		oEmployee:Name			  		:= AllTrim((cQuery)->RA_NOME)
		oEmployee:AdmissionDate  		:= (cQuery)->RA_ADMISSA
		oEmployee:BirthDate	   	 		:= (cQuery)->RA_NASC
		oEmployee:CostCenterCode  		:= AllTrim((cQuery)->CTT_CUSTO)
		oEmployee:CostCenterDescription	:= AllTrim((cQuery)->CTT_DESC01)
		oEmployee:PositionCode			:= AllTrim((cQuery)->Q3_CARGO)
		oEmployee:PositionDescription	:= AllTrim((cQuery)->Q3_DESCSUM)
		oEmployee:DepartmentCode	 	:= AllTrim((cQuery)->QB_DEPTO)
		oEmployee:DepartmentDescription	:= AllTrim((cQuery)->QB_DESCRIC)
	EndIf

	(cQuery)->(DBCloseArea())
Return oEmployee



Function GetBoxDescription(cField, cValue)
	Local cReturn:= ""
	Local aBoxContent:= RetSx3Box(Posicione("SX3", 2, cField, "X3CBox()"), NIL, NIL, 1)
	Local nPos
	
	Default cValue:= &(cField)

	nPos:= Ascan(aBoxContent, { |aBox| aBox[2] = cValue} )
	
	If nPos > 0
		cReturn:= PorEncode(Alltrim(aBoxContent[nPos][3]))
	EndIf
Return cReturn