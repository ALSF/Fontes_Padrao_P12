#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

Function WSCSA010()
Return

WSSTRUCT TEvaluationFactorsGAP
	WSDATA FactorCode				As String
	WSDATA FactorDescription		As String
	WSDATA EmployeeLevelCode		As String
	WSDATA EmployeeLevelDescription	As String
	WSDATA EmployeeScore			As Float
	WSDATA PositionLevelCode		As String
	WSDATA PositionLevelDescription	As String
	WSDATA PositionScore			As Float	
ENDWSSTRUCT

WSSTRUCT TEvaluationFactorsEmployee
	WSDATA Branch					AS String 
	WSDATA Registration				AS String 
	WSDATA Name						As String
	WSDATA BirthDate				As Date
	WSDATA AdmissionDate			As Date
	WSDATA CostCenterCode			As String
	WSDATA CostCenterDescription	As String
	WSDATA PositionCode				As String
	WSDATA PositionDescription		As String
	WSDATA GroupCode				As String
	WSDATA GroupDescription			As String
ENDWSSTRUCT

WSSTRUCT TEvaluationFactorsData
	WSDATA Employee	As TEvaluationFactorsEmployee
	WSDATA Gaps		As Array Of TEvaluationFactorsGAP OPTIONAL
ENDWSSTRUCT




WSSERVICE RHEvaluationFactors DESCRIPTION "Fatores de Avaliação"
	WSDATA Branch			AS String 
	WSDATA Registration		AS String 
	
	WSDATA EvaluationFactorsGAP	AS TEvaluationFactorsData

	WSMETHOD GetEvaluationFactorsGAP DESCRIPTION "Método de consulta os GAPs de fatores de avaliacao dos funcionarios"	
ENDWSSERVICE                                  

WSMETHOD GetEvaluationFactorsGAP;
WSRECEIVE Branch, Registration;
WSSEND EvaluationFactorsGAP;
WSSERVICE RHEvaluationFactors
	SELF:EvaluationFactorsGAP:= WSClassNew("TEvaluationFactorsData")
	SELF:EvaluationFactorsGAP:Employee	:= GetEmployee(SELF:Branch, SELF:Registration)
	SELF:EvaluationFactorsGAP:GAPs 		:= GetGaps(SELF:Branch, SELF:Registration)
RETURN .T.


Static Function GetEmployee(cBranch, cRegistration)
	Local cQuery:= GetNextAlias()
	Local oEmployee:= WSClassNew("TEvaluationFactorsEmployee")
	Local cSRABranch:= xFilial("SRA", cBranch)
	Local cCTTBranch:= xFilial("CTT", cBranch)
	Local cSQ3Branch:= xFilial("SQ3", cBranch)
	Local cSQ0Branch:= xFilial("SQ0", cBranch)
			
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
			Q0_GRUPO,
			Q0_DESCRIC
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
		LEFT OUTER JOIN %Table:SQ0% SQ0
			 ON SQ0.Q0_GRUPO = SQ3.Q3_GRUPO AND
				SQ0.Q0_FILIAL = %Exp:cSQ0Branch% AND
				SQ0.%NotDel%			 
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
		oEmployee:GroupCode		 		:= AllTrim((cQuery)->Q0_GRUPO)
		oEmployee:GroupDescription		:= AllTrim((cQuery)->Q0_DESCRIC)
	EndIf

	(cQuery)->(DBCloseArea())
Return oEmployee

Static Function GetGaps(cBranch, cRegistration)
	Local oItem
	Local aGaps:= {}
	Local cQuery:= GetNextAlias()
	Local cSRABranch:= xFilial("SRA", cBranch)
	Local cSQ4Branch:= xFilial("SQ4", cBranch)
	Local cSQ8Branch:= xFilial("SQ8", cBranch)
	Local cSQVBranch:= xFilial("SQV", cBranch)
			
	BEGINSQL ALIAS cQuery
		COLUMN Q8_PONTOS AS NUMERIC(7, 3)
		COLUMN Q4_PONTOS AS NUMERIC(7, 3)

		SELECT 
			SQVC.QV_FATOR,
			SQVC.QV_DESCFAT,
			SQVC.QV_GRAU 	AS Q4_GRAU,
			SQVC.QV_DESCGRA AS Q4_DESCGRA,
			SQ8.Q8_PONTOS,
			SQVF.QV_GRAU 	AS Q8_GRAU,
			SQVF.QV_DESCGRA AS Q8_DESCGRA,	
			SQ4.Q4_PONTOS
		FROM 
			%Table:SRA% SRA
		INNER JOIN %Table:SQ4% SQ4
			 ON SQ4.Q4_CARGO = SRA.RA_CARGO AND
			 	SQ4.Q4_FILIAL = %Exp:cSQ4Branch% AND
			 	SQ4.%NotDel%
		LEFT OUTER JOIN %Table:SQ8% SQ8
			 ON SQ8.Q8_FATOR = SQ4.Q4_FATOR AND
			 	SQ8.Q8_MAT = SRA.RA_MAT AND
			 	SQ8.Q8_FILIAL = %Exp:cSQ8Branch% AND
			 	SQ8.%NotDel%		
		INNER JOIN %Table:SQV% SQVC
			 ON SQVC.QV_FATOR = SQ4.Q4_FATOR AND
				SQVC.QV_GRAU = SQ4.Q4_GRAU AND
			 	SQVC.QV_FILIAL = %Exp:cSQVBranch% AND
			 	SQVC.%NotDel%		
		LEFT OUTER JOIN %Table:SQV% SQVF
			 ON SQVF.QV_FATOR = SQ8.Q8_FATOR AND 
				SQVF.QV_GRAU = SQ8.Q8_GRAU AND
			 	SQVC.QV_FILIAL = %Exp:cSQVBranch% AND
			 	SQVC.%NotDel%
		WHERE 
			SRA.RA_MAT = %Exp:cRegistration% AND
			SRA.RA_FILIAL = %Exp:cSRABranch% AND
			SRA.%NotDel%
	ENDSQL	

	While !Eof()
		oItem:= WSClassNew("TEvaluationFactorsGAP")
		oItem:FactorCode				:= AllTrim((cQuery)->QV_FATOR)
		oItem:FactorDescription			:= AllTrim((cQuery)->QV_DESCFAT)
		oItem:EmployeeLevelCode			:= AllTrim((cQuery)->Q8_GRAU)
		oItem:EmployeeLevelDescription	:= AllTrim((cQuery)->Q8_DESCGRA)
		oItem:EmployeeScore				:= (cQuery)->Q8_PONTOS
		oItem:PositionLevelCode			:= AllTrim((cQuery)->Q4_GRAU)
		oItem:PositionLevelDescription	:= AllTrim((cQuery)->Q4_DESCGRA)
		oItem:PositionScore				:= (cQuery)->Q4_PONTOS

		AAdd(aGaps, oItem)

		(cQuery)->(DBSkip())
	EndDo

	(cQuery)->(DBCloseArea())	
Return aGaps

