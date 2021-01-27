#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

Function WSCSA020()
Return

WSSTRUCT TAbilitiesGAP
	WSDATA AbilityCode				As String
	WSDATA AbilityDescription		As String
	WSDATA EmployeeLevelCode		As String
	WSDATA EmployeeLevelDescription	As String
	WSDATA EmployeeScore			As Float
	WSDATA PositionLevelCode		As String
	WSDATA PositionLevelDescription	As String
	WSDATA PositionScore			As Float	
ENDWSSTRUCT

WSSTRUCT TAbilitiesEmployee
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

WSSTRUCT TAbilitiesData
	WSDATA Employee	As TAbilitiesEmployee
	WSDATA Gaps		As Array Of TAbilitiesGAP OPTIONAL
ENDWSSTRUCT


WSSERVICE RHAbilities DESCRIPTION "Habilidades"
	WSDATA Branch			AS String 
	WSDATA Registration		AS String 
	
	WSDATA AbilitiesGAP	AS TAbilitiesData

	WSMETHOD GetAbilitiesGAP DESCRIPTION "Método de consulta os GAPs de habilidades dos funcionários"	
ENDWSSERVICE                                  

WSMETHOD GetAbilitiesGAP;
WSRECEIVE Branch, Registration;
WSSEND AbilitiesGAP;
WSSERVICE RHAbilities
	SELF:AbilitiesGAP:= WSClassNew("TAbilitiesData")
	SELF:AbilitiesGAP:Employee	:= GetEmployee(SELF:Branch, SELF:Registration)
	SELF:AbilitiesGAP:GAPs 		:= GetGaps(SELF:Branch, SELF:Registration)
RETURN .T.


Static Function GetEmployee(cBranch, cRegistration)
	Local cQuery:= GetNextAlias()
	Local oEmployee:= WSClassNew("TAbilitiesEmployee")
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
	Local cRBHBranch:= xFilial("RBH", cBranch)
	Local cRBIBranch:= xFilial("RBI", cBranch)
	Local cRBGBranch:= xFilial("RBG", cBranch)
	Local cRBKBranch:= xFilial("RBK", cBranch)
	Local cRBLBranch:= xFilial("RBL", cBranch)
			
	BEGINSQL ALIAS cQuery
		COLUMN RBH_VALOR AS NUMERIC(5, 2)
		COLUMN RBI_VALOR AS NUMERIC(5, 2)

		SELECT DISTINCT
			RBH.RBH_HABIL,
			RBGC.RBG_DESC,	
			RBH.RBH_ITESCA,
			RBLC.RBL_DESCRI AS RBH_DESCRI,
			RBLC.RBL_VALOR	AS RBH_VALOR,
			RBI.RBI_ITESCA,			
			RBLF.RBL_DESCRI AS RBI_DESCRI,
			RBLF.RBL_VALOR	AS RBI_VALOR
		FROM 
			%Table:SRA% SRA
		INNER JOIN %Table:RBH% RBH
			 ON RBH.RBH_CARGO = SRA.RA_CARGO AND
			 	RBH.RBH_FILIAL = %Exp:cRBHBranch% AND
			 	RBH.%NotDel%
		LEFT OUTER JOIN %Table:RBI% RBI
			 ON RBI.RBI_HABIL = RBH.RBH_HABIL AND
			 	RBI.RBI_FILIAL = %Exp:cRBIBranch% AND
			 	RBI.%NotDel%
		LEFT OUTER JOIN %Table:RBG% RBGC
			 ON RBGC.RBG_HABIL = RBH.RBH_HABIL AND
			 	RBGC.RBG_FILIAL = %Exp:cRBGBranch% AND
			 	RBGC.%NotDel%
		LEFT OUTER JOIN %Table:RBK% RBKC
			 ON RBKC.RBK_ESCALA = RBH.RBH_ESCALA AND
			 	RBKC.RBK_FILIAL = %Exp:cRBKBranch% AND
			 	RBKC.%NotDel%
		LEFT OUTER JOIN %Table:RBL% RBLC
			 ON RBLC.RBL_ESCALA = RBH.RBH_ESCALA AND 
			 	RBLC.RBL_ITEM = RBH.RBH_ITESCA AND
			 	RBLC.RBL_FILIAL = %Exp:cRBLBranch% AND
			 	RBLC.%NotDel%
		LEFT OUTER JOIN %Table:RBG% RBGF
			 ON RBGF.RBG_HABIL = RBI.RBI_HABIL AND
			 	RBGF.RBG_FILIAL = %Exp:cRBGBranch% AND
			 	RBGF.%NotDel%
		LEFT OUTER JOIN %Table:RBK% RBKF
			 ON RBKF.RBK_ESCALA = RBI.RBI_ESCALA AND
			 	RBKF.RBK_FILIAL = %Exp:cRBKBranch% AND
			 	RBKF.%NotDel%
		LEFT OUTER JOIN %Table:RBL% RBLF
			 ON RBLF.RBL_ESCALA = RBI.RBI_ESCALA AND 
			 	RBLF.RBL_ITEM = RBI.RBI_ITESCA AND
			 	RBLF.RBL_FILIAL = %Exp:cRBLBranch% AND
			 	RBLF.%NotDel%
		WHERE 
			SRA.RA_MAT = %Exp:cRegistration% AND
			SRA.RA_FILIAL = %Exp:cSRABranch% AND
			SRA.%NotDel%
	ENDSQL	

	While !Eof()
		oItem:= WSClassNew("TAbilitiesGAP")
		oItem:AbilityCode				:= AllTrim((cQuery)->RBH_HABIL)
		oItem:AbilityDescription		:= AllTrim((cQuery)->RBG_DESC)
		oItem:PositionLevelCode			:= AllTrim((cQuery)->RBH_ITESCA)
		oItem:PositionLevelDescription	:= AllTrim((cQuery)->RBH_DESCRI)
		oItem:PositionScore				:= (cQuery)->RBH_VALOR
		oItem:EmployeeLevelCode			:= AllTrim((cQuery)->RBI_ITESCA)
		oItem:EmployeeLevelDescription	:= AllTrim((cQuery)->RBI_DESCRI)
		oItem:EmployeeScore				:= (cQuery)->RBI_VALOR

		AAdd(aGaps, oItem)

		(cQuery)->(DBSkip())
	EndDo

	(cQuery)->(DBCloseArea())	
Return aGaps

