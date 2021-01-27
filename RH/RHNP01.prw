#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"

#INCLUDE "RHNP01.CH"

Function RHNP01()
Return .T.


WSRESTFUL Team	DESCRIPTION STR0001 //"Servico responsavel pelo tratamento de ausencias."

WSDATA employeeId    As String Optional
WSDATA WsNull        As String Optional
WSDATA initView      As String Optional
WSDATA endView       As String Optional
WSDATA team          As String Optional
WSDATA role          As String Optional
WSDATA status        As String Optional
WSDATA page          As String Optional
WSDATA pageSize      As String Optional
WSDATA id            As String Optional
WSDATA userName      As String Optional
WSDATA divisions     As Array  Optional
WSDATA name          As String Optional
WSDATA canApprove    As String Optional
WSDATA initDate      As String Optional
WSDATA coordinatorId As String Optional
WSDATA initPeriod    As String Optional
WSDATA endPeriod     As String Optional
WSDATA level         As String Optional

WSMETHOD GET DESCRIPTION "GET" ;
  WSSYNTAX "team/absence/all/{coordinatorId} || team/teams/{coordinatorId} || team/roles/{coordinatorId} || team/organizationalsubdivision/{coordinatorId} || team/substitute/eligible/{coordinatorId} || team/substitute/{coordinatorId}"

WSMETHOD GET getTeam ;
  DESCRIPTION EncodeUTF8(STR0023) ; //"Retorna a equipe de um coordenador"
  PATH "/team/employees/{coordinatorId}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET GetBalanceTeamSum ; 
  DESCRIPTION EncodeUTF8(STR0019) ; //"Retorna os saldos de horas do time para o período"
  WSSYNTAX "/team/timesheet/balanceSummary/{coordinatorId}" ;
  PATH "/timesheet/balanceSummary/{coordinatorId}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET EmployeeBirthDate ;
  DESCRIPTION EncodeUTF8(STR0020) ; //"Retorna os aniversariantes do mês da equipe do funcionário"
  PATH "/team/birthdates/{employeeID}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET FindEmployee ;
  DESCRIPTION EncodeUTF8(STR0024) ; //"Retorna uma relacao de funcionarios da empresa"
  WSSYNTAX "/team/employees/find/{employeeId}" ;
  PATH "/employees/find/{employeeId}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD GET TeamStructure ;
  DESCRIPTION EncodeUTF8(STR0025) ; //"Retorna uma lista com os dados da estrutura hierarquica do funcionario"
  WSSYNTAX "/team/hierarchicalData/{employeeId}" ;
  PATH "/hierarchicalData/{employeeId}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD PUT putAbsence ;
  DESCRIPTION EncodeUTF8(STR0021) ; //"Serviço responsável pela atualização da ausência."
  WSSYNTAX "/team/absence" ;
  PATH "/absence" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD PUT putSubstitute ;
  DESCRIPTION EncodeUTF8(STR0022) ; //"Serviço responsável pela atualização de substituição."
  WSSYNTAX "/team/substitute/{coordinatorId}" ;
  PATH "/substitute/{coordinatorId}" ;
  PRODUCES 'application/json;charset=utf-8'

WSMETHOD POST DESCRIPTION "POST" ;
  WSSYNTAX "team/substitute/{coordinatorId}"

WSMETHOD DELETE delSubstitute ;
  DESCRIPTION STR0013 ; //"Serviço responsável pela exclusão da substituição."
  WSSYNTAX "/team/substitute/{coordinatorId}/{substituteRequestId}" ;
  PATH "/substitute/{coordinatorId}/{substituteRequestId}" ;
  PRODUCES 'application/json;charset=utf-8'

END WSRESTFUL


WSMETHOD GET WSRECEIVE WsNull WSSERVICE Team

Local cJsonObj       := "JsonObject():New()"
Local oItemData      := &cJsonObj
Local oItem          := &cJsonObj
Local oEmployee      := &cJsonObj
Local oAbsences      := &cJsonObj
Local aAbsences      := {}
Local aMessages      := {}
Local aData          := {}
Local aDivision      := {}
Local nLenParms      := Len(::aURLParms)
Local aVision        := {}
Local cVision        := ""
Local cRoutine       := "W_PWSA210.APW" // Afastamentos - Utilizada para buscar a VISAO a partir da rotina; (AI8_VISAPV) na funCAO GetVisionAI8().

Local cToken         := ""
Local cRD0Login      := ""
Local cMatSRA        := ""
Local cCodRD0        := ""
Local cBranchVld     := ""
Local lRet           := .F.
Local lSubsEligible	 := .F.
Local lSubstitute	 := .F.

Private aCoordTeam   := {}
Private aOcurances   := {}
Private lMaisPaginas := .F.


// - Parammetros enviados pela URL - QueryString
DEFAULT Self:initView     := ""
DEFAULT Self:endView      := ""
DEFAULT Self:id           := ""
DEFAULT Self:name         := ""
DEFAULT Self:team         := ""
DEFAULT Self:role         := ""
DEFAULT Self:canApprove   := ""
DEFAULT Self:page         := ""
DEFAULT Self:pageSize     := ""
DEFAULT Self:userName     := ""
DEFAULT Self:initDate     := ""
DEFAULT Self:divisions    := {}

::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken  := Self:GetHeader('Authorization')

// --------------------------------------------
// - Efetua a leitura do HEADER AUTORIZATHION
// - Pega esse valor e recupera as informaÃ§Ãµes
// - NecessÃ¡rias, como matrÃ­cula, filial, etc.
// --------------------------------------------
cRD0Login	  := GetLoginHR(cToken)
cMatSRA	      := GetRegisterHR(cToken)
cCodRD0	      := GetCODHR(cToken)
cBranchVld	  := GetBranch(cToken)
lSubsEligible := (nLenParms == 3 .And. ::aURLParms[1] == "substitute" .And. ::aURLParms[2] == "eligible")
lSubstitute   := (nLenParms == 2 .And. ::aURLParms[1] == "substitute" .And. !Empty(::aURLParms[2]))

// ----------------------------------------------
// - A FunÃ§Ã£o GetVisionAI8() devolve por padrao
// - Um Array com a seguinte estrutura:
// - aVision[1][1] := "" - AI8_VISAPV
// - aVision[1][2] := 0  - AI8_INIAPV
// - aVision[1][3] := 0  - AI8_APRVLV
// - Por isso as posicoes podem ser acessadas
// - Sem problemas, ex: cVision := aVision[1][1]
// ----------------------------------------------
aVision := GetVisionAI8(cRoutine, cBranchVld)
cVision := aVision[1][1]

//*** aURLParms
//varinfo("aURLParms Get: ", ::aURLParms)


aCoordTeam := APIGetStructure(cCodRD0, "", cVision, cBranchVld, cMatSRA, , , , , cBranchVld, cMatSRA, ,)

If lSubstitute
	// - Obtem a lista de substituicoes agendadas para o gestor
	fGetSubstitute( cBranchVld, cMatSRA, aCoordTeam, Self:initDate, @aData, @lRet )
ElseIf lSubsEligible
	If !Empty(Self:divisions)
		aDivision := StrTokArr(Self:divisions, "," )
	EndIf

	//Obtem os funcionarios da hierarquia para substituicao
	fGetSubsEligible( cBranchVld, cMatSRA, aCoordTeam, @aData, Self:userName, aDivision, Self:page, Self:pageSize, @lRet )
// - Garante a URL: /team/absence/all/{coordinatorId}
ElseIf (nLenParms == 3 .And. !Empty(::aURLParms[3]))
	// - Obtem o LOGIN - CPF ou CODIGO.
	::aURLParms[3] := Iif(  ::aURLParms[3] == "%7Bcurrent%7D" .Or. ::aURLParms[3] == "{current}", cRD0Login, ::aURLParms[3] )

	// seta as ocorrÃƒÂªncias
	setOcurances(Self:page,Self:pageSize,Self:status,Self:initView,Self:endView,Self:team,Self:role,cJsonObj,@oAbsences,@aMessages,@oEmployee,@aData,@oItemData,aCoordTeam,Self:canApprove,cBranchVld,cMatSRA)
ElseIf nLenParms == 2 .And. !Empty(::aUrlParms[2])

	// - Obtem o LOGIN - CPF ou CODIGO.
	::aURLParms[2] := Iif(  ::aURLParms[2] == "%7Bcurrent%7D" .Or. ::aURLParms[2] == "{current}" .Or. ::aURLParms[2] == "{coordinatorId}", cRD0Login, ::aURLParms[2] )
	filterService(Self:id,Self:name,cJsonObj,@aData,aCoordTeam,Lower(::aUrlParms[1]))
EndIf


 If Lower(::aURLParms[1]) $ "absence##organizationalsubdivision" .Or. lSubsEligible .Or. lSubstitute
    If (!lSubsEligible .And. !lSubstitute) .Or. lRet
	    oItem["hasNext"]  := lMaisPaginas
	    oItem["items"]    := aData
    ElseIf (!lSubstitute)
		oItem["code"] := "500"
		oItem["message"] := EncodeUTF8(STR0009) //"Nao foi localizado nenhum funcionario para substituicao."
	EndIf
 Else
    oItem["data"]     := aData
    oItem["messages"] := aMessages
    oItem["length"]   := Len(aData)
 EndIf

 cJson := FWJsonSerialize(oItem, .F., .F., .T.)
 ::SetResponse(cJson)

Return (.T.)


WSMETHOD GET getTeam WSRECEIVE coordinatorId WSSERVICE Team

    Local cJsonObj   := "JsonObject():New()"
    Local oItem      := &cJsonObj
    Local aData      := {}
    Local aAllData   := {}
    Local aVision    := {}
    Local cVision    := ""
    Local cRoutine   := "W_PWSA210.APW" // Afastamentos - Utilizada para buscar a VISAO a partir da rotina; (AI8_VISAPV) na funCAO GetVisionAI8().
    Local oEmployee
    Local oData

    Local cToken     := ""
    Local cRD0Login  := ""
    Local cMatSRA    := ""
    Local cCodRD0    := ""
    Local cBranchVld := ""
    Local lContinua  := .T.
    Local nX		 := 0
    Local nY		 := 0
    Local nInicio
    Local nFim

    DEFAULT Self:page     := "1"
    DEFAULT Self:pageSize := "20"

    ::SetHeader('Access-Control-Allow-Credentials' , "true")

    cToken  := Self:GetHeader('Authorization')

    cRD0Login	:= GetLoginHR(cToken)
    cMatSRA	    := GetRegisterHR(cToken)
    cCodRD0	    := GetCODHR(cToken)
    cBranchVld	:= GetBranch(cToken)

    aVision := GetVisionAI8(cRoutine, cBranchVld)
    cVision := aVision[1][1]

    aCoordTeam := APIGetStructure(cCodRD0, "", cVision, cBranchVld, cMatSRA, , , , , cBranchVld, cMatSRA, ,)

    lContinua := Len(aCoordTeam) > 0 .And. !ValType( aCoordTeam[1] ) == "L" //Verifica se carregou dados da hierarquia.

    If lContinua 
	    For nX := 1 To Len(aCoordTeam)
	
	        For nY := 1 To Len(aCoordTeam[nX]:ListOfEmployee)
	
	            If !aCoordTeam[1]:ListOfEmployee[nY]:Registration == cMatSRA //Nao considera a propria matricula
	            
	            	oEmployee := aCoordTeam[nX]:ListOfEmployee[nY]
	
		            oData := &cJsonObj
		            oData["id"] := Alltrim(oEmployee:Registration)
		            oData["name"] := Upper( AllTrim(oEmployee:Name) )
		            oData["roleDescription"] := AllTrim(oEmployee:Position)
	
		            Aadd(aAllData, oData)                        
	            EndIf
	
	        Next nY
	
	    Next nX
    EndIf

    nInicio := ( (Val(::Page) - 1) * Val(::pageSize) ) + 1
    nFim  := Min( nInicio + Val(::pageSize) - 1, Len(aAllData))

    If Len(aAllData) >= nInicio

        ASort( aAllData,,, { |x, y| x["name"] < y["name"] })

        For nX := nInicio to nFim
            Aadd(aData, aAllData[nX])
        Next
    EndIf

    oItem["hasNext"] := Len(aAllData) > nFim
    oItem["items"]   := aData

    cJson := FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return (.T.)

// -------------------------------------------------------------------
// - EXIBE O BANCO DE HORAS DO TIME
// -------------------------------------------------------------------
WSMETHOD GET GetBalanceTeamSum PATHPARAM coordinatorId WSREST Team

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local aEventos		:= {}
Local aPeriods		:= {}
Local cJson			:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local cMatSRA		:= ""
Local cIniPer		:= ""
Local cFimPer		:= ""
Local lSexagenal	:= .T.
Local lInfoTime		:= .T.

	::SetHeader('Access-Control-Allow-Credentials' , "true")
	
	DEFAULT Self:initPeriod    := ""
	DEFAULT Self:endPeriod     := ""
	
	cToken		:= Self:GetHeader('Authorization')
	cBranchVld	:= GetBranch(cToken)
	cMatSRA     := GetRegisterHR(cToken)

	//Se nao vier o periodo na requisicao considera o que estiver aberto no ponto
	If Empty(Self:initPeriod) .Or. Empty(Self:endPeriod) 
		aPeriods := GetPerAponta( 1, cBranchVld , cMatSRA, .F.)
		If Len(aPeriods) > 0
			//Considera o periodo de um ano na pesquisa
			cIniPer := dToS( YearSub( aPeriods[1,1],1 ) )
			cFimPer := dToS( aPeriods[1,2] )
		EndIf
	Else
		cIniPer := Self:initPeriod
		cFimPer := Self:endPeriod		
	EndIf
	
	aEventos := fBalanceSumPer( cBranchVld, cMatSRA, cIniPer, cFimPer, lSexagenal, lInfoTime )
	
	If !Empty(aEventos)
		oItem["totalExtraHours"]    := HourToMs( cValToChar( Abs(aEventos[1]) ) ) * If( aEventos[1] > 0, 1, -1 )
		oItem["totalNegativeHours"] := HourToMs( cValToChar( Abs(aEventos[2]) ) ) * If( aEventos[2] > 0, 1, -1 )
	EndIf
	
	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	::SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
// - EXIBE ANIVERSARIANTES DO MÊS
// -------------------------------------------------------------------
WSMETHOD GET EmployeeBirthDate PATHPARAM employeeId WSREST Team

Local cJsonObj 	 	:= "JsonObject():New()"
Local oItem		 	:= &cJsonObj
Local aData			:= {}
Local aEventos		:= {}
Local cJson			:= ""
Local cToken		:= ""
Local cBranchVld	:= ""
Local cMatSRA		:= ""

::SetHeader('Access-Control-Allow-Credentials' , "true")

cToken		:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)
cMatSRA		:= GetRegisterHR(cToken)

aEventos := fEmployeeBirthDate( cBranchVld, cMatSRA )

If !Empty(aEventos)
	
	oItem["hasNext"] := .F.
	oItem["items"]   := aEventos
	
EndIf

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
// RETORNA DADOS DA ESTRUTURA HIERARQUICA DO FUNCIONARIO
// -------------------------------------------------------------------
WSMETHOD GET TeamStructure PATHPARAM employeeId WSREST Team

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oItemDetail	:= &cJsonObj
Local cRoutine		:= "W_PWSA100A.APW"
Local cOrgCFG		:= SUPERGETMV("MV_ORGCFG")
Local cToken		:= ""
Local cBranchVld	:= ""
Local cCodMat		:= ""
Local cFilSup		:= ""
Local cMatSup		:= ""
Local cNameSup		:= ""
Local cCargoSup		:= ""
Local cLevel		:= ""
Local cVision		:= ""
Local aVision		:= {}
Local aData			:= {}
Local aFunc			:= {}
Local aGetStruct	:= {}
Local aPairStruct	:= {}
Local aArrayData	:= {}
Local lMorePage		:= .F.
Local nX 	 	 	:= 0
Local nY 	 	 	:= 0
Local nCount  	 	:= 0
Local nPage  	 	:= 0
Local nPageSize	 	:= 0
Local nRegIni  	 	:= 0
Local nRegFim  	 	:= 0

DEFAULT Self:page		:= 1
DEFAULT Self:pageSize	:= 6
DEFAULT Self:level		:= "lead"

Self:SetHeader('Access-Control-Allow-Credentials' , "true")

cToken 		:= Self:GetHeader('Authorization')
cBranchVld	:= GetBranch(cToken)
cCodMat		:= GetRegisterHR(cToken)
cLevel		:= UPPER( SubStr( AllTrim(Self:level), 1, 1 ) ) //A partir da primeira letra identifica o nivel

If !Empty(cBranchVld) .And. !Empty(cCodMat)

	//busca visão para a solicitação de férias
	aVision := GetVisionAI8(cRoutine, cBranchVld, cCodMat )
	cVision := aVision[1][1]
	
	//Identifica o superior do funcionario
	aGetStruct	:= APIGetStructure("", cOrgCFG, cVision, cBranchVld, cCodMat, , , , , cBranchVld, cCodMat )
	
	If Len(aGetStruct) > 0 .And. !ValType( aGetStruct[1] ) == "L"
		cFilSup		:= aGetStruct[1]:ListOfEmployee[1]:SupFilial	//Filial do Superior
		cMatSup		:= aGetStruct[1]:ListOfEmployee[1]:SupRegistration	//Matricula do Superior
		cNameSup	:= AllTrim( aGetStruct[1]:ListOfEmployee[1]:NameSup ) //Nome do Superior
		cCargoSup	:= AllTrim( aGetStruct[1]:ListOfEmployee[1]:Position ) //Cargo do Superior
	EndIf
	
	If cLevel == "L" 
		//Superiores (Lead)
		aAdd( aFunc, { cFilSup, cMatSup, AllTrim( cNameSup ), AllTrim( cCargoSup ) } )
	
	ElseIf cLevel == "P" 
		//Pares (Pair)
		aPairStruct	:= APIGetStructure("", cOrgCFG, cVision, cFilSup, cMatSup, , , , , cFilSup, cMatSup ) //Carrega dados da estrutura do Superior
		aArrayData	:= aPairStruct
	Else 
		//Subordinados (Subordinate)
		aArrayData	:= aGetStruct	
	EndIf
	
	If cLevel $ "P|S" //Pares ou subordinados
	
		//Verifica se carregou dados da hierarquia.
	    If Len(aGetStruct) > 0 .And. !ValType( aGetStruct[1] ) == "L"
		    For nX := 1 To Len(aArrayData)
		        For nY := 1 To Len(aArrayData[nX]:ListOfEmployee)
		            If !(aArrayData[1]:ListOfEmployee[nY]:Registration $ (cCodMat +"|"+ cMatSup)) //Nao considera a propria matricula nem a do superior
		            
		            	oEmployee := aArrayData[nX]:ListOfEmployee[nY]
		
			            aAdd( aFunc,{ 	oEmployee:EmployeeFilial, ;		//Filial
			            				oEmployee:Registration, ;		//Matricula
			            				AllTrim( oEmployee:Name ), ;	//Nome
			            				AllTrim( oEmployee:Position ) ;	//Cargo
			            			} )     
		            EndIf
		        Next nY
		    Next nX
	    EndIf
	EndIf
	
	If Len( aFunc ) > 0
		//Faz o controle de paginacao
		nPage 		:= If( Self:page == "1" .Or. Self:page == "", 1, Val(Self:page) ) 
		nPageSize 	:= If( Empty(Self:pageSize), 6, Val(Self:pageSize) )
		If nPage == 1
		 	nRegIni := 1 
			nRegFim := nPageSize
		Else
			nRegIni := ( nPageSize * ( nPage - 1 ) ) + 1
			nRegFim := ( nRegIni + nPageSize ) - 1
		EndIf
		
		//Adiciona as matriculas compreendidas na pagina e tamanho solicitados
		For nX := 1 To Len( aFunc )
			nCount ++
		
			If ( nCount >= nRegIni .And. nCount <= nRegFim )
				oItemDetail	:= &cJsonObj
				oItemDetail["id"] 				:= aFunc[nX, 1] +"|"+ aFunc[nX, 2]
				oItemDetail["name"] 			:= EncodeUTF8( aFunc[nX, 3] )
				oItemDetail["roleDescription"]	:= EncodeUTF8( aFunc[nX, 4] )
				aAdd( aData, oItemDetail )
			Else
				If nCount >= nRegFim
					lMorePage := .T.
					Exit
				EndIf	
			EndIf
		Next nX
	EndIf

EndIf

oItem["hasNext"] := lMorePage
oItem["items"]   := aData

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
Self:SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
// RETORNA UMA RELACAO DE FUNCIONARIOS DA EMPRESA
// -------------------------------------------------------------------
WSMETHOD GET FindEmployee PATHPARAM employeeId WSREST Team

Local cJsonObj		:= "JsonObject():New()"
Local oItem			:= &cJsonObj
Local oItemDetail	:= &cJsonObj
Local cRoutine		:= "W_PWSA100A.APW"
Local cOrgCFG		:= SUPERGETMV("MV_ORGCFG")
Local cLastFil		:= "!!"
Local cCidade		:= ""
Local cFilter		:= ""
Local cAliasSRA		:= ""
Local cNameSup		:= ""
Local cVision		:= ""
Local cFone			:= ""
Local cNome			:= ""
Local aVision		:= {}
Local aFunc			:= {}
Local aInfo			:= {}
Local aData			:= {}
Local aDeptos		:= {}
Local aCargos		:= {}
Local aGetStruct	:= {}
Local lEstruct		:= .T.
Local lMorePage		:= .F.
Local nX 	 	 	:= 0
Local nPos  	 	:= 0
Local nCount  	 	:= 0
Local nPage  	 	:= 0
Local nPageSize	 	:= 0
Local nRegIni  	 	:= 0
Local nRegFim  	 	:= 0

//Posicao de cada elemento incluido na matriz aFunc
Local nPosFil  	 	:= 1
Local nPosMat   	:= 2
Local nPosDepto 	:= 3
Local nPosCargo 	:= 4
Local nPosName 		:= 5
Local nPosEmail 	:= 6
Local nPosDDD  		:= 7	
Local nPosFone		:= 8

DEFAULT Self:page		:= 1
DEFAULT Self:pageSize	:= 3
DEFAULT Self:name		:= ""
	
cAliasSRA	:= GetNextAlias()

//Aplica filtro caso seja informado
If !Empty(Self:name)

	//Faz o controle de paginacao
	nPage 		:= If( Self:page == "1" .Or. Self:page == "", 1, Val(Self:page) ) 
	nPageSize 	:= If( Empty(Self:pageSize), 3, Val(Self:pageSize) )
	If nPage == 1
	 	nRegIni := 1 
		nRegFim := nPageSize
	Else
		nRegIni := ( nPageSize * ( nPage - 1 ) ) + 1
		nRegFim := ( nRegIni + nPageSize ) - 1
	EndIf

	cFilter := "% RA_NOME LIKE '%" + Self:name + "%' AND %"

	BeginSql ALIAS cAliasSRA
		SELECT RA_FILIAL, RA_MAT, RA_DEPTO, RA_CARGO, RA_NOME, RA_EMAIL, RA_DDDFONE, RA_TELEFON, RA_NOMECMP 
		FROM %table:SRA% SRA
		WHERE 	%Exp:cFilter%
				SRA.%notDel%
		ORDER BY 
			5, 1
	EndSql	

	While !(cAliasSRA)->(Eof()) 

		cNome := If( !Empty((cAliasSRA)->RA_NOMECMP),(cAliasSRA)->RA_NOMECMP, (cAliasSRA)->RA_NOME ) 
	
		aAdd( aFunc, { ;
						(cAliasSRA)->RA_FILIAL, 			;	//01 - Filial
						(cAliasSRA)->RA_MAT, 				;	//02 - Matricula
						(cAliasSRA)->RA_DEPTO, 				;	//03 - Codigo Departamento
						(cAliasSRA)->RA_CARGO, 				;	//04 - Codigo Cargo
						AllTrim( cNome ), 					;	//05 - Nome
						AllTrim( (cAliasSRA)->RA_EMAIL ),	;	//06 - E-mail				
						AllTrim( (cAliasSRA)->RA_DDDFONE ),	;	//07 - DDD
						AllTrim( (cAliasSRA)->RA_TELEFON )	;	//08 - Telefone
						} )
	
		(cAliasSRA)->(dbSkip()) 
	EndDo
	
	(cAliasSRA)->( DBCloseArea() )
	
	//Trata o resultado da consulta
	For nX := 1 To Len( aFunc )
	
		nCount		++
		cFone		:= ""
		cDeptoDesc	:= ""
		cCargoDesc	:= ""
		cNameSup	:= ""
	
		//Identifica a cidade da empresa
		If cLastFil <> aFunc[nX, 1]
			aInfo	 := {}
			cLastFil := aFunc[nX, 1]
			
			fInfo(@aInfo, cLastFil )
			If Len( aInfo ) > 0
				cCidade := AllTrim( aInfo[05] ) //Cidade
			EndIf
		EndIf
		
		//Identifica o departamento cidade da empresa
		If ( nPos := aScan( aDeptos, {|x| x[1]+x[2] == aFunc[nX, nPosFil] + aFunc[nX, nPosDepto] } ) ) == 0
			cDeptoDesc := AllTrim( fDesc( "SQB", aFunc[nX, nPosDepto], "QB_DESCRIC", , xFilial("SQB", aFunc[nX, nPosFil]) ) )
			aAdd( aDeptos, { aFunc[nX, nPosFil], aFunc[nX, nPosDepto], cDeptoDesc } )
		Else
			cDeptoDesc := aDeptos[nPos,3]
		EndIf
	
		//Identifica o cargo do funcionario
		If ( nPos := aScan( aCargos, {|x| x[1]+x[2] == aFunc[nX, nPosFil] + aFunc[nX, nPosCargo] } ) ) == 0
			cCargoDesc := AllTrim( fDesc("SQ3", aFunc[nX, nPosCargo], "Q3_DESCSUM", , xFilial("SQ3", aFunc[nX, nPosFil]) ) )
			aAdd( aCargos, { aFunc[nX, nPosFil], aFunc[nX, nPosCargo], cCargoDesc } )
		Else
			cCargoDesc := aCargos[nPos,3]
		EndIf
	
		//Ajusta os dados do telefone
		cFone := TRANSFORM( aFunc[nX, nPosFone], If( Len(aFunc[nX, nPosFone]) > 8, "@R 99999-9999", "@R 9999-9999" ) ) 
		If !Empty( aFunc[nX, nPosDDD] ) 
			cFone := aFunc[nX, nPosDDD] +" "+ cFone
		EndIf
		
		//busca visão para a solicitação de férias
	  	aVision := GetVisionAI8(cRoutine, aFunc[nX, nPosFil] )
	  	cVision := aVision[1][1]
	
		//Identifica o superior do funcionario
		aGetStruct	:= APIGetStructure("", cOrgCFG, cVision, aFunc[nX, nPosFil], aFunc[nX, nPosMat], , , , , aFunc[nX, nPosFil], aFunc[nX, nPosMat] )
		lEstruct	:= Len(aGetStruct) > 0 .And. !ValType( aGetStruct[1] ) == "L" //Verifica se carregou dados da hierarquia.
		
		If lEstruct
			cNameSup := AllTrim( aGetStruct[1]:ListOfEmployee[1]:NameSup )
		EndIf
	
		//Adiciona as matriculas compreendidas na pagina e tamanho solicitados
		If ( nCount >= nRegIni .And. nCount <= nRegFim )
			oItemDetail	:= &cJsonObj
			oItemDetail["id"] 				:= aFunc[nX, nPosFil] +"|"+ aFunc[nX, nPosMat]
			oItemDetail["name"] 			:= EncodeUTF8( aFunc[nX, nPosName] )
			oItemDetail["roleDescription"]	:= EncodeUTF8( cCargoDesc )
			oItemDetail["department"]		:= EncodeUTF8( cDeptoDesc )
			oItemDetail["city"]				:= EncodeUTF8( cCidade )
			oItemDetail["leadName"]			:= EncodeUTF8( cNameSup )
			oItemDetail["email"]			:= aFunc[nX, nPosEmail]
			oItemDetail["telefone"]			:= cFone
			aAdd( aData, oItemDetail )
		Else
			If nCount >= nRegFim
				lMorePage := .T.
				Exit
			EndIf	
		EndIf
	Next

EndIf

oItem["hasNext"] 	:= lMorePage
oItem["items"]		:= aData

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return(.T.)

// -------------------------------------------------------------------
// - ATUALIZAÇÃO DO SERVIÇO DE AUSENCIAS.
// -------------------------------------------------------------------
WSMETHOD PUT putAbsence WSREST Team
Local cBody 		:= ::GetContent()
Local aUrlParam	:= ::aUrlParms
Local cJsonObj	:= "JsonObject():New()"
Local oItem		:= &cJsonObj
Local oItemDetail	:= &cJsonObj
Local cJson		:= ""
Local cToken		:= ""

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken  := Self:GetHeader('Authorization')

EditRH3(aUrlParam,cBody,@cJsonObj,@oItem,@oItemDetail,cToken)

cJson := FWJsonSerialize(oItem, .F., .F., .T.)
::SetResponse(cJson)

Return (.T.)


// -------------------------------------------------------------------
// - ATUALIZAÇÃO DO SERVIÇO DE SUBSTITUTOS.
// -------------------------------------------------------------------
WSMETHOD PUT putSubstitute WSREST Team
Local cBody          := ::GetContent()
Local aUrlParam      := ::aUrlParms
Local cJsonObj       := "JsonObject():New()"
Local oItem          := &cJsonObj
Local oItemDetail    := &cJsonObj
Local oItemData      := &cJsonObj
Local oMsgReturn     := &cJsonObj
Local aMessages      := {}
Local lRet           := .T.
Local cJson          := ""
Local cToken         := ""

Local cSubstitute    := ""
Local cFilSubstitute := ""
Local cMatSubstitute := ""
Local cCodMat        := ""
Local cBranchVld     := ""
Local cKeyId         := ""
Local cRestFault     := ""
Local cStatus        := ""

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken := Self:GetHeader('Authorization')

cBranchVld  := GetBranch(cToken)
cCodMat     := GetRegisterHR(cToken)

    If !Empty(cBody) .And. AliasInDic("RJ2")
       oItemDetail:FromJson(cBody)
       cKeyId := Iif(oItemDetail:hasProperty("id"),oItemDetail["id"],"")

       BEGIN TRANSACTION
          //Localiza e elimina substituicao original
          //O id para a alteração não vai na URL como no delete
          //entao é necessário passar a informação recebida
          cRestFault := subsDelete(aUrlParam,cKeyId)

          //Realiza a gravação da nova substituição
          //caso a exclusão tenha sido realizada com sucesso
          If empty(cRestFault)
             SubsRequest(cBranchVld, cCodMat, cBody, @oItem, @cStatus, @lRet)
          EndIF
       END TRANSACTION
    Else
       cRestFault := EncodeUTF8(STR0016) //"requisição invalida ao serviço de exclusão de substituição"
    EndIf

    If empty(cRestFault) .And. lRet
       If !Empty(cStatus)
           ::SetHeader('Status', cStatus)
       EndIf

       oMsgReturn["type"]       := "success"
       oMsgReturn["code"]       := "200"
       oMsgReturn["detail"]     := EncodeUTF8(STR0018) //"Atualização realizada com sucesso"

       Aadd(aMessages, oMsgReturn)
    Else
       HttpSetStatus(500)

       oMsgReturn["type"]       := "error"
       oMsgReturn["code"]       := "500"
       oMsgReturn["detail"]     := cRestFault
       Aadd(aMessages, oMsgReturn)
    EndIf

    oItem["data"]     := oItemData
    oItem["messages"] := aMessages
    oItem["length"]   := 1

    cJson :=  FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return(.T.)


WSMETHOD POST WSRECEIVE WsNull WSSERVICE Team

Local cBody 		:= ::GetContent()
Local aUrlParam	:= ::aUrlParms
Local cJsonObj	:= "JsonObject():New()"
Local oItem		:= &cJsonObj
Local cJson		:= ""
Local cToken		:= ""
Local cCodMat	 	:= ""
Local cBranchVld 	:= ""
Local cStatus		:= ""
Local lRet			:= .T.

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken := Self:GetHeader('Authorization')

cBranchVld 	:= GetBranch(cToken)
cCodMat	 	:= GetRegisterHR(cToken)

SubsRequest(cBranchVld, cCodMat, cBody, @oItem, @cStatus, @lRet)

If lRet
	If !Empty(cStatus)
		::SetHeader('Status', cStatus)
	EndIf

	cJson := FWJsonSerialize(oItem, .F., .F., .T.)
	::SetResponse(cJson)
EndIf

FreeObj(oItem)

Return (lRet)


// -------------------------------------------------------------------
// - DELETE RESPONSÁVEL POR EXCLUIR AS SUBSTITUIÇÕES RECEBIDAS.
// -------------------------------------------------------------------
WSMETHOD DELETE delSubstitute WSREST Team
Local cJsonObj       := "JsonObject():New()"
Local cBody          := ::GetContent()
Local aUrlParam      := ::aUrlParms
Local oItem          := &cJsonObj
Local oItemData      := &cJsonObj
Local oMsgReturn     := &cJsonObj
Local aMessages      := {}

Local cRestFault     := ""
Local cBranchVld     := ""
Local cCodMat        := ""
Local cToken         := ""
Local cJson          := ""

::SetHeader('Access-Control-Allow-Credentials' , "true")
cToken := Self:GetHeader('Authorization')

cBranchVld  := GetBranch(cToken)
cCodMat     := GetRegisterHR(cToken)

    Begin Transaction
       //realiza a exclusão dos registros da substituicao
       cRestFault := subsDelete(aUrlParam)
    End Transaction

    If empty(cRestFault)
       HttpSetStatus(204)

       oMsgReturn["type"]       := "success"
       oMsgReturn["code"]       := "204"
       oMsgReturn["detail"]     := EncodeUTF8(STR0015) //"Exclusão realizada com sucesso"

       Aadd(aMessages, oMsgReturn)
    Else
       HttpSetStatus(500)

       oMsgReturn["type"]       := "error"
       oMsgReturn["code"]       := "500"
       oMsgReturn["detail"]     := cRestFault
       Aadd(aMessages, oMsgReturn)
    EndIf

    oItem["data"]     := oItemData
    oItem["messages"] := aMessages
    oItem["length"]   := 1

    cJson :=  FWJsonSerialize(oItem, .F., .F., .T.)
    ::SetResponse(cJson)

Return(.T.)


/*/{Protheus.doc} SubsRequest
- Responsavel por efetuar a gravacao do substituto

@author:	Marcelo Silveira
@since:	25/02/2018
@param:	cBranchVld - Filial do substituicao;
			cCodMat - Matricula do substituicao;
			cBody - Corpo da requisicao;
			oItem - Objeto da Classe JsonObjects ( return of service ) /*/
Function SubsRequest(cBranchVld, cCodMat, cBody, oItem, cStatus, lRet)

Local cJsonObj       := "JsonObject():New()"
Local cSubstitute    := ""
Local cFilSubstitute := ""
Local cMatSubstitute := ""
Local cPosition      := ""
Local aFuncs         := {}
Local aDeptos        := {}
Local oFuncs         := {}
Local aMessages      := {}
Local aAreaSRA       := {}
Local oItemDetail    := &cJsonObj
Local oMessages      := &cJsonObj
Local nX             := 0
Local lAdd           := .T.
Local nTamDepto      := TAMSX3("RA_DEPTO")[1]

Default cBody        := ""
Default oItem        := &cJsonObj
Default lRet         := .T.

If !Empty(cBody) .And. AliasInDic("RJ2")
	oItemDetail:FromJson(cBody)

	cInitDate     := Iif(oItemDetail:hasProperty("initDate"),CTOD(Format8601(.T.,oItemDetail["initDate"])),"")
	cEndDate      := Iif(oItemDetail:hasProperty("endDate"),CTOD(Format8601(.T.,oItemDetail["endDate"])),"")
	cSubstitute   := Iif(oItemDetail:hasProperty("employeeSummary"),oItemDetail["employeeSummary"]["id"]," ")
	cName         := Iif(oItemDetail:hasProperty("employeeSummary"),oItemDetail["employeeSummary"]["name"]," ")
	cPosition     := Iif(oItemDetail:hasProperty("employeeSummary"),oItemDetail["employeeSummary"]["roleDescription"]," ")
    aDeptos       := Iif(oItemDetail:hasProperty("divisions"),oItemDetail["divisions"],{})

	cFilSubstitute:= Substr( cSubstitute, 1, Len(cBranchVld) )
	cMatSubstitute:= Substr( cSubstitute, Len(cBranchVld)+1, Len(cCodMat) )
	aAreaSRA      := SRA->( getArea() )

	DbSelectArea("SRA")
	SRA->( dbSetOrder(1) )
	If SRA->( dbSeek(cFilSubstitute + cMatSubstitute) )
		cCodDepto := SRA->RA_DEPTO
	EndIf
	RestArea(aAreaSRA)

	//Verifica se o registro pode ser gravado
	DbSelectArea("RJ2")
	RJ2->( dbSetOrder(1) )
	RJ2->( dbSeek( cBranchVld + cCodMat ) )
	While !Eof() .And. RJ2->(RJ2_FILIAL+RJ2_MAT) == cBranchVld+cCodMat

		//Se algum dos registros ja existir na base aborta a gravacao de todos.
		If RJ2->RJ2_DEPTO == cCodDepto .And. ;
			( (DTOS(cInitDate) <= DTOS(RJ2_DATADE) .And. DTOS(cEndDate) >= DTOS(RJ2_DATATE) ) .Or. ;
			  (DTOS(cInitDate) >= DTOS(RJ2_DATADE) .And. DTOS(cEndDate) <= DTOS(RJ2_DATATE) ) .Or. ;
			  (DTOS(cInitDate) <= DTOS(RJ2_DATATE) .And. DTOS(cEndDate) >= DTOS(RJ2_DATATE) ) .Or. ;
			  (DTOS(cInitDate) >= DTOS(RJ2_DATATE) .And. DTOS(cEndDate) <= DTOS(RJ2_DATATE) ) )
			lAdd := .F.
			Exit
		EndIf
		RJ2->( dBSkip() )
	EndDo

	//Faz a gravavao do substituto
	If lAdd
      For nX := 1 To Len( aDeptos )
		   Reclock("RJ2", .T.)
		   RJ2->RJ2_FILIAL   := cBranchVld
		   RJ2->RJ2_MAT      := cCodMat
		   RJ2->RJ2_DEPTO    := aDeptos[nX]
		   RJ2->RJ2_FILSUB   := cFilSubstitute
		   RJ2->RJ2_MATSUB   := cMatSubstitute
		   RJ2->RJ2_DATADE   := cInitDate
		   RJ2->RJ2_DATATE   := cEndDate
		   RJ2->(MsUnlock())
       Next nX

		If Empty(aFuncs)
			oFuncs                    := &cJsonObj
			oFuncs["Id"]              := cFilSubstitute + cMatSubstitute
			oFuncs["name"]            := cName
			oFuncs["roleDescription"] := cPosition
			aAdd( aFuncs, oFuncs )
		EndIf
	EndIf

	If !Empty(aFuncs)
		oItem["employeeSummary"] := aFuncs
	Else
		lRet := .F.
		//"Ja existe substituto cadastrado para esse funcionario no periodo informado."
		SetRestFault(500, EncodeUTF8(STR0007), .T.)
	EndIf

	FreeObj(oItemDetail)
	FreeObj(oMessages)

EndIf

Return (.T.)


/*/{Protheus.doc} SubsDelete
- Responsavel por efetuar a exclusão de substituicoes
@author:   Marcelo Faria
@since:    23/04/2019
@param:    aUrlParam - parametros da url
/*/
Function subsDelete(aUrlParam,idSubs)
Local cRestFault := ""
Local cKeyRJ2    := ""
Local aParam     := {}

default idSubs   := ""


    If !Empty(aUrlParam[1]) .And. aUrlParam[1] == "substitute"

       If Len(aUrlParam) == 3 .And. aUrlParam[3] != "undefined"
          //origem requisição DELETE
          aParam := StrTokArr(aUrlParam[3], "&")
       Else
          //origem requisição PUT
          aParam := StrTokArr(idSubs, "&")
       EndIf

       If len(aParam) == 6
          //valida matricula do solicitante
          DbSelectArea("SRA")
          SRA->( dbSetOrder(1) )
          If SRA->( dbSeek(aParam[1]+aParam[2]) )
             cRestFault := ""
          Else
             cRestFault := EncodeUTF8(STR0014) //"informações do solicitante para exclusão não conferem"
          EndIf
       Else
          cRestFault := EncodeUTF8(STR0017) //"dados incompletos para o serviço de exclusão de substituição"
       EndIf
    Else
       cRestFault    := EncodeUTF8(STR0016) //"requisição invalida ao serviço de exclusão de substituição"
    EndIf


    If empty(cRestFault) .And. AliasInDic("RJ2") .And. len(aParam) == 6
       cKeyRJ2 := aParam[1]+aParam[2]+aParam[3]+aParam[4]+aParam[5]+aParam[6]

       //realiza a exclusão do registro de substituição
       Begin Transaction
          DbSelectArea("RJ2")
          RJ2->( dbSetOrder(4) ) //RJ2_FILIAL+RJ2_MAT+DTOS(RJ2_DATADE)+DTOS(RJ2_DATATE)+RJ2_FILSUB+RJ2_MATSUB
          RJ2->( dbSeek(cKeyRJ2) )
          While !Eof()                                                                               .And.  ;
                RJ2->(RJ2_FILIAL+RJ2_MAT+DTOS(RJ2_DATADE)+DTOS(RJ2_DATATE)+RJ2_FILSUB+RJ2_MATSUB) == cKeyRJ2;

             RecLock("RJ2",.F.)
             RJ2->(dbDelete())
             RJ2->(MsUnlock())

             RJ2->( dBSkip() )
          EndDo
       End Transaction
    Else
       If empty(cRestFault)
          cRestFault := EncodeUTF8(STR0017) //"dados incompletos para o serviço de exclusão de substituição"
       EndIf
    EndIf

Return (cRestFault)


/*/{Protheus.doc} fGetSubstitute
- Responsavel por listar as substituicoes agendadas/correntes

@author:	Maycon Sacht
@since:		04/03/2019
@param:		cBranchVld - Filial da hierquia que esta sendo pesquisada;
			cMatSRA - MatrÃ­cula da hierquia que estÃ¡ sendo pesquisada;
			aGetStruct - Array com os dados da hierquia;
			initDate - Parametro da requisicao para filtrar registro pela data final
			oItem - Objeto da Classe JsonObjects ( return of service );
			lRet - Se verdadeiro indica que foram carregados dados de funcionarios ou departamentos
/*/
Function fGetSubstitute( cBranchVld, cMatSRA, aGetStruct, cInitDate, oItem, lRet)

Local cJsonObj       := "JsonObject():New()"
Local oSubstitute    := &cJsonObj
Local oFuncs         := &cJsonObj
Local aSubstitute    := {}
Local cQuery         := GetNextAlias()
Local cQuerySra      := GetNextAlias()
Local aArea          := GetArea() // current area
Local aAreaSRA       := SRA->(GetArea())
Local cBranch        := ""
Local cFiltro        := ""
Local dCurrentDate   := Date()
Local cNameFun       := ""
Local cMatStruct     := ""
Local cDepStruct     := ""
Local cMatSub        := ""
Local cDescCargo     := ""
Local cDataDe        := ""
Local cDataAte       := ""
Local aDeps          := {}
Local aFuncs         := {}

DEFAULT cBranchVld   := ""
DEFAULT cMatSRA      := ""
DEFAULT oItem        := {}
DEFAULT lRet         := .T.
DEFAULT cInitDate    := ""
DEFAULT aGetStruct   := {}

cBranch := xFilial("RJ2", cBranchVld)

If !Empty(cInitDate)
	cFiltro := " RJ2.RJ2_DATATE >= '" + cInitDate + "' "
Else
	cFiltro := " RJ2.RJ2_DATATE >= '" + DTOS(dCurrentDate) + "' "
EndIf
cFiltro := "% " + cFiltro + " %"

BEGINSQL ALIAS cQuery
	SELECT
       RJ2.RJ2_FILIAL,
       RJ2.RJ2_MAT,
		RJ2.RJ2_MATSUB,
		RJ2.RJ2_FILSUB,
		RJ2.RJ2_DEPTO,
		RJ2.RJ2_DATADE,
		RJ2.RJ2_DATATE
	 FROM %Table:RJ2% RJ2
	WHERE RJ2.RJ2_FILIAL = %Exp:cBranch%
	  AND RJ2.RJ2_MAT	    = %Exp:cMatSRA%
	  AND %exp:cFiltro%
	  AND RJ2.%NotDel%
	ORDER BY RJ2_MATSUB, RJ2_DATADE
ENDSQL

While (cQuery)->(!Eof())

	If cMatSub != (cQuery)->RJ2_MATSUB .Or. cDataDe != (cQuery)->RJ2_DATADE .Or. cDataAte != (cQuery)->RJ2_DATATE

		If (!Empty(cMatSub))
			oSubstitute["divisions"]     := aDeps
			oSubstitute["divisionsType"] := "departament"
			aDeps := {}
			aAdd(aSubstitute, oSubstitute)
			oSubstitute	:= &cJsonObj
		EndIf

		cMatSub  := (cQuery)->RJ2_MATSUB
		cDataDe  := (cQuery)->RJ2_DATADE
		cDataAte := (cQuery)->RJ2_DATATE

		BEGINSQL ALIAS cQuerySra
			SELECT
				SRA.RA_NOME,
				SRA.RA_CARGO
			 FROM %Table:SRA% SRA
			WHERE SRA.RA_FILIAL  = %Exp:(cQuery)->RJ2_FILSUB%
			  AND SRA.RA_MAT     = %Exp:(cQuery)->RJ2_MATSUB%
			  AND SRA.%NotDel%
		ENDSQL

		cDescCargo :=  Alltrim(Posicione('SQ3',1,xFilial("SQ3",(cQuery)->RJ2_FILSUB)+(cQuerySra)->RA_CARGO,'SQ3->Q3_DESCSUM'))

		oFuncs := &cJsonObj
		oFuncs["id"]                   := (cQuery)->RJ2_FILIAL +"|" +(cQuery)->RJ2_MAT
		oFuncs["name"]                 := (cQuerySra)->RA_NOME
		oFuncs["roleDescription"]      := cDescCargo

       oSubstitute["id"]              :=  (cQuery)->RJ2_FILIAL +"&" +(cQuery)->RJ2_MAT    +"&" ;
                                         +(cQuery)->RJ2_DATADE +"&" +(cQuery)->RJ2_DATATE +"&" ;
                                         +(cQuery)->RJ2_FILSUB +"&" +(cQuery)->RJ2_MATSUB +"&"
		oSubstitute["initDate"]        := Substr((cQuery)->RJ2_DATADE,1,4) + "-" + Substr((cQuery)->RJ2_DATADE,5,2) + "-" + Substr((cQuery)->RJ2_DATADE,7,2)
		oSubstitute["endDate"]		   := Substr((cQuery)->RJ2_DATATE,1,4) + "-" + Substr((cQuery)->RJ2_DATATE,5,2) + "-" + Substr((cQuery)->RJ2_DATATE,7,2)
		oSubstitute["employeeSummary"] := oFuncs

		aFuncs := {}
		(cQuerySra)->( DBCloseArea() )

		aAdd(aDeps, (cQuery)->RJ2_DEPTO)
	Else
		aAdd(aDeps, (cQuery)->RJ2_DEPTO)
	EndIf
	(cQuery)->( DbSkip())
EndDo

If (!Empty(cMatSub))
	oSubstitute["divisions"]     := aDeps
	oSubstitute["divisionsType"] := "departament"
	aDeps := {}
	aAdd(aSubstitute, oSubstitute)
EndIf

(cQuery)->( DBCloseArea() )

lRet := !Empty(aSubstitute)
oItem := aSubstitute

FreeObj(oSubstitute)

RestArea(aAreaSRA)
RestArea(aArea)

Return(Nil)

/*/{Protheus.doc} fGetSubsEligible
- Responsavel por listar os departamentos e os funcionarios que podem ser substituidos

@author:	Marcelo Silveira
@since:		25/02/2018
@param:		aGetStruct - Array com os dados da hierquia;
			cBranchVld - Filial da hierquia que esta sendo pesquisada;
			cMatSRA - Matricula da hierquia que esta sendo pesquisada;
			oItem - Objeto da Classe JsonObjects ( return of service );
			cFilter - Expressao para filtrar os funcionarios por nome (se vazio retorna todos);
			aDivision - Array para filtrar os funcionarios conforme os departamentos relacionados;
			cPage - Numero da pagina que esta sendo carregada;
			cPageSize - Quantidade de registros da pagina requisitada;
			lRet - Se verdadeiro indica que foram carregados dados de funcionarios ou departamentos
/*/
Function fGetSubsEligible( cBranchVld, cMatSRA, aGetStruct, oItem, cFilter, aDivision, cPage, cPageSize, lRet )

Local cJsonObj      := "JsonObject():New()"
Local oFuncs        := &cJsonObj
Local cNameFun      := ""
Local cMatStruct    := ""
Local cDepStruct    := ""
Local cDepFilter    := ""
Local lNameFilter   := .F.
Local lDeptFilter   := .F.
Local nX            := 0
Local nRegCount     := 0
Local nRegCountIni  := 0
Local nRegCountFim  := 0
Local aFuncs        := {}

DEFAULT cBranchVld  := ""
DEFAULT cMatSRA     := ""
DEFAULT aGetStruct  := {}
DEFAULT oItem       := {}
DEFAULT cFilter     := ""
DEFAULT aDivision   := {}
DEFAULT cPage       := "1"
DEFAULT cPageSize   := "20"
DEFAULT lRet        := .T.

//Verifica se foi passado filtro de nome e departamentos
lNameFilter := !Empty(cFilter)
For nX := 1 To Len( aDivision )
	cDepFilter += aDivision[nX] + "#"
	lDeptFilter := .T.
Next nX

//Faz o controle de paginacao
If cPage == "1" .Or. cPage == ""
 	nRegCountIni := 1
	nRegCountFim := If( Empty(val(cPageSize)), 20, val(cPageSize) )
Else
	nRegCountIni := ( val(cPageSize) * (val(cPage) - 1)  ) + 1
	nRegCountFim := ( nRegCountIni + val(cPageSize) ) - 1
EndIf

//Retorna os Funcionarios da hieraquia
For nX := 1 To Len( aGetStruct[1]:ListOfEmployee )

	cMatStruct 	:= aGetStruct[1]:ListOfEmployee[nX]:Registration
	cDepStruct	:= AllTrim(aGetStruct[1]:ListOfEmployee[nX]:Department)
	cNameFun 	:= UPPER( AllTrim(aGetStruct[1]:ListOfEmployee[nX]:Name) )

	If !cMatStruct == cMatSRA .And. If( lNameFilter, UPPER(cFilter) $ cNameFun, .T. ) .And. If( lDeptFilter, cDepStruct $ cDepFilter, .T. )
		nRegCount ++
		If ( nRegCount >= nRegCountIni .And. nRegCount <= nRegCountFim )
			oFuncs			:= &cJsonObj
			oFuncs["id"] 	:= cBranchVld + cMatStruct
			oFuncs["name"]	:= cNameFun
			oFuncs["roleDescription"] := AllTrim(aGetStruct[1]:ListOfEmployee[nX]:Position)
			aAdd( aFuncs, oFuncs )
		Else
			If nRegCount > nRegCountFim
				lMaisPaginas := .T.
			EndIf
		EndIf
	EndIf

Next

lRet := !Empty(aFuncs)
oItem := aFuncs

FreeObj(oFuncs)

Return(Nil)


/*/{Protheus.doc}EditRH3
- Responsavel por efetuar o PUT (Approve or Repprove das solicitacoes)

@author:	Matheus Bizutti
@since:		12/04/2017
@param:		aUrlParam - Parametros da URL;
			cBody - Corpo da requisicao;
			cJsonObj - Objeto da classe JsonObjects;
			oItem - Objeto da Classe JsonObjects ( return of service );
			oItemDetail - Objeto da Classe JsonObjects para ser utilizado como Array de Objetos no oItem.
/*/
Function EditRH3(aUrlParam,cBody,cJsonObj,oItem,oItemDetail,cToken,lApproverAll)

Local oMessages     := Nil
Local oRequest      := Nil
Local aMessages     := {}
Local cBranch       := ""
Local cMat          := ""
Local cFilToken     := ""
Local cMatToken     := ""
Local cRH3Cod       := ""
Local cLenFilial    := FWSizeFilial()
Local cLenMat       := TamSX3("RA_MAT")[1]
Local cLenRH3Cod    := TamSX3("RH3_CODIGO")[1]
Local cApprover     := ""
Local cVision       := ""
Local cTypeReq      := ""
Local cEmpApr       := ""
Local nSupLevel     := 0
Local nX     		:= 0
Local aAreaRH3      := {}
Local aGetStruct    := {}
Local aSubstitute	:= {}
Local cSubMat		:= ""
Local cSubBranch 	:= ""
Local cUsrCurrent   := ""
Local cFilApr       := ""
Local lSubstitute   := .F.

Default aUrlParam 	 := {}
Default cBody        := ""
Default cJsonObj     := "JsonObject():New()"
Default oItem 	 	 := &cJsonObj
Default oItemDetail	 := &cJsonObj
Default cToken		 := ""
Default lApproverAll := .F.

oMessages            := &cJsonObj
cUsrCurrent          := GetRegisterHR(cToken)

oRequest             := WSClassNew("TRequest")
oRequest:Status      := WSClassNew("TRequestStatus")


 cFilToken := GetBranch(cToken)
 cMatToken := GetRegisterHR(cToken)

 //varinfo("aUrlParam: ", aUrlParam)
 //varinfo("Fil/Mat token: ", cFilToken +"/" +cMatToken)

 oItemDetail:FromJson(cBody)

 If !empty( oItemDetail["id"] )
	cBranch 	:= Substr(oItemDetail["id"],1,cLenFilial)
	cMat 		:= Substr(oItemDetail["id"],cLenFilial+1,cLenMat)
	cRH3Cod 	:= Substr(oItemDetail["id"],cLenfilial+cLenMat+1,cLenRH3Cod)

	aAreaRH3 := RH3->(GetArea())

	DbSelectArea("RH3")
	RH3->( dbSetOrder(1) )

	If RH3->( dbSeek(xFilial("RH3", cBranch) + cRH3Cod ) )
		cVision  := RH3->RH3_VISAO
		cTypeReq := RH3->RH3_TIPO

		//Verifica se o funcionario esta substituindo o seu superior
		aSubstitute := fGetSupNotify( cFilToken, cMatToken, .F. )

		If Len(aSubstitute) > 0
			For nX := 1 To Len(aSubstitute)
				cSubMat	+= aSubstitute[nX, 2]
				cSubBranch += aSubstitute[nX, 1]
				lSubstitute := .T.
			Next nX
		Else
			cSubMat	:= cMatToken
			cSubBranch := cFilToken
		EndIf

		// -------------------------------------------------------------------------------------------
		// - Efetua a busca dos dados referentes a Estrutura Oreganizacional dos dados da solicitação.
		//- -------------------------------------------------------------------------------------------
       If  oItemDetail:hasProperty("approved") .and. oItemDetail["approved"]

    	   aGetStruct := APIGetStructure("", SUPERGETMV("MV_ORGCFG"), cVision, cSubBranch, cSubMat, , , ,cTypeReq , cSubBranch, cSubMat, ,)
	       //varinfo("aGetStruct: ",aGetStruct)

		   //If Len(aGetStruct) >= 1 .And. !(Len(aGetStruct) == 3 .And. !aGetStruct[1])
           If (valtype(aGetStruct[1]:ListOfEmployee[1]:LevelSup) == "N") .and. (aGetStruct[1]:ListOfEmployee[1]:LevelSup != 99)
		 	    cEmpApr   := aGetStruct[1]:ListOfEmployee[1]:SupEmpresa
		 	    cFilApr   := aGetStruct[1]:ListOfEmployee[1]:SupFilial
		 	    nSupLevel := aGetStruct[1]:ListOfEmployee[1]:LevelSup
		 	    cApprover := aGetStruct[1]:ListOfEmployee[1]:SupRegistration
           Else
               nSupLevel := aGetStruct[1]:ListOfEmployee[1]:LevelSup
           EndIf
       EndIf

		// *******************************************************************
		// - VERIFICAR SE APPROVERS  ==  CURRENT
		// - SE FOR , O CANPPOVER DEVERA RECEBER = ''
		// *******************************************************************
		If !(ValType(oItemDetail['approvers']) == "U")
			cApprover := Iif(oItemDetail["approvers"][1] == cUsrCurrent,"",cApprover)
		Else
			cApprover := Iif(cApprover == cUsrCurrent,"",cApprover)
		EndIf

		oRequest:Branch 				:= cBranch
		oRequest:Registration			:= cMat
		oRequest:Code 					:= cRH3Cod

		oRequest:ApproverBranch			:= cFilApr
		oRequest:ApproverRegistration 	:= cApprover
		oRequest:EmpresaAPR				:= cEmpApr
		oRequest:ApproverLevel			:= nSupLevel

		//Guarda os dados da aprovacao feita pelo substituto para geracao do historico
		If lSubstitute
			oRequest:ApproverSubBranch		:= cFilToken
			oRequest:ApproverSubRegistration:= cMatToken
		EndIf

		If	oItemDetail:hasProperty("approved")

			If oItemDetail["approved"]
               oRequest:Observation  := Alltrim(EncodeUTF8(STR0011 +Space(1) +dToC(date()) +Space(1) +Time())) //"Aprovado via App MeuRH em"
			   ApproveRequest(oRequest)
			Else
               oRequest:Observation  := Alltrim(EncodeUTF8(STR0012 +Space(1) +dToC(date()) +Space(1) +Time())) //"Reprovado via App MeuRH em"
			   ReproveRequest(oRequest)
			EndIf

		EndIf

		oMessages["code"]             := EncodeUTF8(STR0002)               //"Dados atualizados com sucesso."
		oMessages["message"]	      := EncodeUTF8(STR0003 +" 200")       //"Status:"
		oMessages["detailedMessage"]  := EncodeUTF8(STR0004 +" " +cRH3Cod) //"Solicitacao:"
	Else
		oMessages["code"]             := "401"
		oMessages["message"]          := EncodeUTF8(STR0005)               //"Solicitacao nao encontrada."
		oMessages["detailedMessage"]  := EncodeUTF8(STR0004 +" " +cRH3Cod) //"Numero:"
	EndIf

	RestArea(aAreaRH3)

	Aadd(aMessages, oMessages)
EndIf


If !lApproverAll
	oItem["data"] 	  := oItemDetail
	oItem["length"]   := 0
	oItem["messages"] := aMessages
Else
	oItem             := oItemDetail
EndIf

Return(Nil)

/*/{Protheus.doc}setOcurances()
- Set no array aAbsences para alimentar o Json com o mesmo.

@author:	Matheus Bizutti
@since:		12/04/2017
@param:
- initView: QueryString para filtro de data Inicial.
- endView:	QueryString para filtro de data final.
- cJsonObj:	VariÃ¡vel com a classe JsonObject em macro execuÃ§Ã£o.
- oAbsences: Objeto da classe JsonObject.
/*/

Function setOcurances(page, pageSize, status, initView, endView, team, role, cJsonObj, oAbsences, aMessages, oEmployee, aData, oItemData, aCoordTeam,canApprove,cBranchVld,cMatSRA)

Local nX		 		:= 0
Local nY				:= 0
Local aDateGMT		:= {}
Local aAbsences		:= {}
Local lApprove		:= .F.
Local lMostra        := .T.

Local nRegCount      := 1
Local nRegCountIni   := 1
Local nRegCountFim   := 6

Default page         := ""
Default pageSize     := ""
Default status       := ""
Default initView		:= ""
Default endView		:= ""
Default team			:= ""
Default role			:= ""
Default cJsonObj		:= "JsonObject():New()"
Default oAbsences		:= &cJsonObj
Default oEmployee		:= &cJsonObj
Default oItemData		:= &cJsonObj
Default aData			:= {}
Default aCoordTeam	:= {}
Default aMessages		:= {}
Default canApprove	:= ""
Default cBranchVld	:= FwCodFil()
Default cMatSRA		:= ""

If !Empty(canApprove)
	lApprove := Iif(Lower(canApprove) == "true", .T., .F.)
EndIf

//query params filtro - EX:teams=00000010&roles=000001
/*
varinfo("page    : ",page)
varinfo("pageSize: ",pageSize)
varinfo("status  : ",status)
varinfo("initView: ",initView)
varinfo("endView : ",endView)
varinfo("team    : ",team)
varinfo("role    : ",role)
*/

//controle de paginação
If !empty(page)
   If page == "1"
      nRegCountIni := 1
      nRegCountFim := val(pageSize)
   Else
      nRegCountIni := ( val(pageSize) * (val(page) - 1)  ) + 1
      nRegCountFim := nRegCountIni + val(pageSize)
   EndIf
EndIF


// - Captura todas as OcorrÃªncias.
// - ObtÃ©m o perÃ­odo aquisito em aberto.
If Len(aCoordTeam) >= 1 .And. !(Len(aCoordTeam) == 3 .And. !aCoordTeam[1])
	For nY := 1 To Len(aCoordTeam[1]:ListOfEmployee)

		If aCoordTeam[1]:ListOfEmployee[nY]:Registration != cMatSRA // - Despreza caso o coordinatorId esteja incluso na estrutura.

			oItemData 			  := &cJsonObj
			oEmployee 			  := &cJsonObj

			oEmployee["id"] 					:= Alltrim(aCoordTeam[1]:ListOfEmployee[nY]:Registration) //aCoordTeam[1]:ListOfEmployee[nY]:EmployeeFilial + ";" + aCoordTeam[1]:ListOfEmployee[nY]:Registration
			oEmployee["name"] 				:= EncodeUTF8(Alltrim(aCoordTeam[1]:ListOfEmployee[nY]:Name))
			oEmployee["roleDescription"] 	:= EncodeUTF8(getDescs(aCoordTeam[1]:ListOfEmployee[nY]:FunctionID, .T.,cBranchVld))


           //valida filtro de equipe
           lMostra := .T.
           If !empty(team)
              lMostra  := ( aCoordTeam[1]:ListOfEmployee[nY]:Department == team )
           EndIf
           If lMostra .And. !empty(role)
              lMostra  := ( aCoordTeam[1]:ListOfEmployee[nY]:FunctionId == role )
           EndIf

           //busca ocorrÃªncias do colaborador
           aOcurances := {}
           If lMostra
    			GetAbsences(@aOcurances, 	  aCoordTeam[1]:ListOfEmployee[nY]:Registration,cBranchVld,cMatSRA)
	    		GetLimitVacation(@aOcurances, aCoordTeam[1]:ListOfEmployee[nY]:Registration,cBranchVld,cMatSRA)
		    	GetVacationWKF(@aOcurances,   aCoordTeam[1]:ListOfEmployee[nY]:Registration,cBranchVld,cMatSRA)
           EndIf
           //varinfo("aOcurances: ",aOcurances)


			For nX := 1 To Len(aOcurances)

             //valida outros filtros
             lMostra := .T.
             If !Empty(initView) .And. !Empty(endView)
                lMostra := validDate(initView, aOcurances[nx][5], endView, aOcurances[nx][6])
             EndIf
             If lMostra .And. !Empty(status)
                lMostra := ( aOcurances[nx][4] $ status )
             EndIf

             //Atualiza registro das movimentaÃ§Ãµes de fÃ©rias do colaborador
             If lMostra

                If ( nRegCount >= nRegCountIni .And. nRegCount <= nRegCountFim )
                   SetJson(@oAbsences,@aAbsences,cJsonObj,@aOcurances,@nX)
                Else
                   If nRegCount > nRegCountFim
                      lMaisPaginas := .T.
                   EndIf
                EndIf

                nRegCount++
             EndIf

			Next nX


			oItemData["employee"] := oEmployee
			oItemData["absences"] := aAbsences

			// - aData - Array que irÃ¡ ser responsÃ¡vel por todo o corpo do JSON
			aAdd(aData, oItemData)

			aAbsences 	:= {}

		EndIf

	Next nY
EndIf

Return(Nil)


/*/{Protheus.doc}GetAbsences
- Retorna as ausencias do funcionario;

@author:	Matheus Bizutti
@since:	12/04/2017
@param:	- aOcurances - Array passado por referÃªncia para obter as ausÃªncias;
			- cMat - Matricula que sera utilizada como filtro - No while dos funcionarios, a chamada essa função passando a matricula que está lendo;
			- cBranchVld - Filial utilizada ao logar ( GetCookie() )
			- cMatSRA - Matricula do usuario Logado ( Necessario para futura implementacao)

/*/
Function GetAbsences(aOcurances, cMat,cBranchVld,cMatSRA)

Local cQuery 		:= GetNextAlias()
Local cBranch		:= ""
Local aArea			:= GetArea() // current area
Local aAreaSRA		:= SRA->(GetArea())

Default aOcurances 	:= {}
Default cMat 		:= ""
Default cBranchVld	:= FwCodFil()
Default cMatSRA		:= ""

cBranch := xFilial("SR8", cBranchVld)

BEGINSQL ALIAS cQuery
	COLUMN R8_DATAINI AS DATE
	COLUMN R8_DATAFIM AS DATE

	SELECT
		SR8.R8_FILIAL,
		SR8.R8_MAT,
		SR8.R8_SEQ,
		SR8.R8_TIPOAFA,
		SR8.R8_DATAINI,
		SR8.R8_DATAFIM,
		SR8.R8_DURACAO,
		SR8.R8_STATUS
	FROM
		%Table:SR8% SR8
	WHERE
		SR8.R8_FILIAL = %Exp:cBranch%  AND
		SR8.R8_MAT 	= %Exp:cMat%     AND
		SR8.R8_TIPOAFA = '001'         AND // - @FIXME - ESTA VALIDACAO A APENAS E UNICAMENTE PARA O PRIMEIRO MVP QUE CONTEMPLARAO FERIAS, APOS ELE, TODAS AS AUSENCIAS SERAO COMPUTADAS.
		SR8.%NotDel%
	ORDER BY
		SR8.R8_DATAINI DESC
ENDSQL

DbSelectArea("SRA")
DbSetOrder(1)

While (cQuery)->(!Eof())

	If SRA->( DbSeek(xFilial("SRA") + (cQuery)->R8_MAT) ) .And. SRA->RA_SITFOLH != 'D' .And. SRA->RA_FILIAL + SRA->RA_MAT == (cQuery)->R8_FILIAL + (cQuery)->R8_MAT

		aAdd(aOcurances, {(cQuery)->R8_MAT,(cQuery)->R8_FILIAL+(cQuery)->R8_MAT, Iif((cQuery)->R8_TIPOAFA == "001","vacation","absence"),StatusVacation(SRA->RA_SITFOLH),;
			(cQuery)->R8_DATAINI,(cQuery)->R8_DATAFIM,0,.F.,{},getDescs((cQuery)->R8_TIPOAFA,.F.,(cQuery)->R8_FILIAL),.F.,(cQuery)->R8_DURACAO})

	EndIf

	(cQuery)->( DbSkip() )

EndDo

(cQuery)->( DBCloseArea() )

RestArea(aAreaSRA)
RestArea(aArea)

Return(Nil)


/*/{Protheus.doc}GetLimitVacation
- Retorna o periodo concessivo do funcionario.

@author:	Matheus Bizutti
@since:	12/04/2017
@param:	- aOcurances - Array passado por referencia para obter as ausencias;
		- cMat - Matricula que sera utilizada como filtro - No while dos funcionarios, As chamadas essa funcao passando a matricula que estao lendo;
		- cBranchVld - Filial utilizada ao logar ( GetCookie() )
		- cMatSRA - Matricula do usuario Logado ( Necessario para futura implementacao)

/*/
Function GetLimitVacation(aOcurances, cMat, cBranchVld,cMatSRA,aFields,oFields,lConvivence,cJsonObj)

Local aAbsences 	:= {}
Local cQuery 		:= GetNextAlias()
Local cBranch		:= ""
Local aArea		    := GetArea() // current area
Local aAreaSRA	    := SRA->(GetArea())
Local aPeriod		:= {}
Local lVac          := .F.
Local nVacAbs       := 0
Local dIniVacDate   := CToD(" / / ")
Local dEndVacDate   := CToD(" / / ")

Default aOcurances	:= {}
Default cMat		:= ""
Default cBranchVld	:= FwCodFil()
Default cMatSRA		:= ""
Default aFields		:= {}
Default cJsonObj	:= "JsonObject():New()"
Default oFields		:= &cJsonObj
Default lConvivence	:= .F.

cBranch := xFilial("SRF", cBranchVld)

BEGINSQL ALIAS cQuery

	SELECT *
	FROM %Table:SRF% SRF
	WHERE
		SRF.RF_FILIAL = %Exp:cBranch% AND
		SRF.RF_MAT    = %Exp:cMat%    AND
		SRF.RF_STATUS = '1'           AND
		SRF.%NotDel%

ENDSQL

DbSelectArea("SRA")
DbSetOrder(1)

While (cQuery)->(!Eof())

	If SRA->( DbSeek(xFilial("SRA") + (cQuery)->RF_MAT) ) .And. SRA->RA_SITFOLH = ' ' .And. SRA->RA_FILIAL + SRA->RA_MAT == (cQuery)->RF_FILIAL + (cQuery)->RF_MAT

		aPeriod := PeriodConcessive((cQuery)->RF_DATABAS,(cQuery)->RF_DATAFIM)

		If lConvivence
			oFields := &cJsonObj
			oFields["type"] := 'initVacationLimit'
			oFields["value"]:= aPeriod[1]

			Aadd(aFields, oFields)
			oFields := Nil
			oFields := &cJsonObj
			oFields["type"] := 'endVacationLimit'
			oFields["value"]:= aPeriod[2]
			Aadd(aFields, oFields)
			oFields := &cJsonObj

			oFields["type"] := 'vacationBonus'
			oFields["value"]:= getBonus((cQuery)->RF_MAT,aPeriod[1],aPeriod[2])
			Aadd(aFields, oFields)
			oFields := &cJsonObj
		EndIf


       lVac        := .F.
       nVacAbs     := 0
       dIniVacDate := CToD(" / / ")
       dEndVacDate := CToD(" / / ")

       If !empty((cQuery)->RF_DATAINI)
          dIniVacDate := cToD( Substr((cQuery)->RF_DATAINI,8,2) + "/" + Substr((cQuery)->RF_DATAINI,5,2) + "/" + Substr((cQuery)->RF_DATAINI,1,4) )

          If dIniVacDate >= date()
             lVac := .T.
             dEndVacDate := (dIniVacDate + (cQuery)->RF_DFEPRO1) - 1
             nVacAbs     := (cQuery)->RF_DABPRO1
          EndIf
       EndIf

       If !lVac .And. !empty((cQuery)->RF_DATINI2)
          dIniVacDate := cToD( Substr((cQuery)->RF_DATINI2,8,2) + "/" + Substr((cQuery)->RF_DATINI2,5,2) + "/" + Substr((cQuery)->RF_DATINI2,1,4) )

          If dIniVacDate >= date()
             lVac := .T.
             dEndVacDate := (dIniVacDate + (cQuery)->RF_DFEPRO2) - 1
             nVacAbs     := (cQuery)->RF_DABPRO2
          EndIf
       EndIf

       If !lVac .And. !empty((cQuery)->RF_DATINI3)
          dIniVacDate := cToD( Substr((cQuery)->RF_DATINI3,8,2) + "/" + Substr((cQuery)->RF_DATINI3,5,2) + "/" + Substr((cQuery)->RF_DATINI3,1,4) )

          If dIniVacDate >= date()
             lVac := .T.
             dEndVacDate := (dIniVacDate + (cQuery)->RF_DFEPRO3) - 1
             nVacAbs     := (cQuery)->RF_DABPRO3
          EndIf
       EndIf


       If lVac

    		aAdd(aOcurances, {(cQuery)->RF_MAT,;
			              (cQuery)->RF_FILIAL+(cQuery)->RF_MAT,;
			               "vacation",;
			               "approved",;
			               dIniVacDate,;
			               dEndVacDate,;
                          nVacAbs,;
			               .F.,;
			               {},;
			               Nil,;
			               .F.,;
			               Nil})
		Else

            aAdd(aOcurances, {(cQuery)->RF_MAT,;
                          (cQuery)->RF_FILIAL+(cQuery)->RF_MAT,;
                           "vacationLimit",;
                           "empty",;
                           aPeriod[1],;
                           aPeriod[2],;
                           nVacAbs,;
                           .F.,;
                           {},;
                           Nil,;
                           .F.,;
                           Nil})
		EndIf

	EndIf

	(cQuery)->( DbSkip() )
EndDo

	(cQuery)->( DBCloseArea() )

	RestArea(aAreaSRA)
	RestArea(aArea)

Return(Nil)


/*/{Protheus.doc}GetVacationWKF
- Retorna a RH3 referentes a Férias.

@author:	Matheus Bizutti
@since:	12/04/2017
@param:	- aOcurances - Array passado por referencia para obter as ausencias;
			- cMat - Matricula que serÃ¡ utilizada como filtro - No while dos funcionarios, As chamadas essa funcao passando a matricula que estao lendo;
			- cBranchVld - Filial utilizada ao logar ( GetCookie() )
			- cMatSRA - Matricula do usuario Logado ( NecessÃ¡rio para futura implementacao)

/*/
Function GetVacationWKF(aOcurances, cMat, cBranchVld, cMatSRA, cStatus)

Local nTamFilial	:= FWGETTAMFILIAL
Local cQuery 		:= GetNextAlias()
Local cBranch		:= ""
Local aArea			:= GetArea() // current area
Local aAreaSRA		:= SRA->(GetArea())
Local dDataIni		:= cToD(" / / ")
Local dDataFim		:= cToD(" / / ")
Local dDataBaseIni  := cToD(" / / ")
Local dDataBaseFim  := cToD(" / / ")
Local nVacDays		:= 0
Local nAbsDays      := 0
Local lSolicAbono   := .F.
Local lSolic13      := .F.
Local cFilRH4       := ""

Default aOcurances	:= {}
Default cMat 		:= ""
Default cBranchVld  := FwCodFil()
Default cMatSRA		:= ""
Default cStatus		:= "1/3/4/5" //dispensa atendidas (status=2), pois sao carregadas pelo SRF

cBranch := xFilial("RH3", cBranchVld)

   BEGINSQL ALIAS cQuery
       SELECT RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH3.RH3_MAT,
              RH3.RH3_DTSOLI, RH3.RH3_VISAO,  RH3.RH3_FILINI,
              RH3.RH3_MATINI, RH3.RH3_FILAPR, RH3.RH3_MATAPR,
              RH3.RH3_STATUS, RH3.RH3_TIPO,   RH3.RH3_NVLINI,
              RH3.RH3_NVLAPR, RH3.R_E_C_N_O_
              FROM %table:RH3% RH3
       WHERE  RH3.RH3_FILIAL    = %Exp:cBranch%  AND
              RH3.RH3_MAT       = %Exp:cMat%     AND
              RH3.RH3_TIPO      = 'B'            AND
              RH3.%NotDel%
   ENDSQL

DbSelectArea("SRA")
DbSetOrder(1)

DbSelectArea("RH4")

While (cQuery)->(!Eof())

	If SRA->( DbSeek(xFilial("SRA") + (cQuery)->RH3_MAT) ) .And. ;
	   SRA->RA_FILIAL + SRA->RA_MAT == (cQuery)->RH3_FILIAL + (cQuery)->RH3_MAT .And. ;
	   (cQuery)->RH3_STATUS $ cStatus

       dDataIni		:= cToD(" / / ")
       dDataFim		:= cToD(" / / ")
       dDataBaseIni	:= cToD(" / / ")
       dDataBaseFim	:= cToD(" / / ")
       nVacDays		:= 0
       nAbsDays     := 0
       lSolicAbono  := .F.
       lSolic13     := .F.
       cFilRH4      := ""

		If RH4->(dbSeek(xFilial("RH4") + (cQuery)->RH3_CODIGO ))

			While RH4->(!Eof()) .And. RH4->RH4_CODIGO == (cQuery)->RH3_CODIGO

				If alltrim(RH4->RH4_CAMPO)     == "R8_DATAINI"
					dDataIni    := alltrim(RH4->RH4_VALNOV)
				ElseIf alltrim(RH4->RH4_CAMPO) == "R8_DATAFIM"
					dDataFim    := alltrim(RH4->RH4_VALNOV)
				ElseIf alltrim(RH4->RH4_CAMPO) == "R8_DURACAO"
					nVacDays    := alltrim(RH4->RH4_VALNOV)
                ElseIf alltrim(RH4->RH4_CAMPO) == "TMP_ABONO"
                    lSolicAbono := alltrim(RH4->RH4_VALNOV)
                ElseIf alltrim(RH4->RH4_CAMPO) == "TMP_DABONO"
                    nAbsDays    := alltrim(RH4->RH4_VALNOV)
                ElseIf alltrim(RH4->RH4_CAMPO) == "TMP_1P13SL"
                    lSolic13    := alltrim(RH4->RH4_VALNOV)
                ElseIf alltrim(RH4->RH4_CAMPO) == "R8_FILIAL"
                    cFilRH4      := SubStr( RH4->RH4_VALNOV, 1, nTamFilial )
                ElseIf alltrim(RH4->RH4_CAMPO) == "RF_DATABAS"
                    dDataBaseIni := alltrim(RH4->RH4_VALNOV)
                ElseIf alltrim(RH4->RH4_CAMPO) == "RF_DATAFIM"
                    dDataBaseFim := alltrim(RH4->RH4_VALNOV)
				EndIf

				RH4->(DbSkip())
			EndDo

		EndIf

		aAdd(aOcurances, { (cQuery)->RH3_MAT,																				;
			               (cQuery)->RH3_FILIAL+(cQuery)->RH3_MAT+(cQuery)->RH3_CODIGO,									    ;
			               "vacation",																					    ;
			               getStatusWKF((cQuery)->RH3_STATUS),															    ;
			               Iif(!Empty(dDataIni),dDataIni,Nil),															    ;
			               Iif(!Empty(dDataFim),dDataFim,Nil),															    ;
			               nAbsDays,																						;
			               .F.,																								;
			               {(cQuery)->RH3_MATAPR},																			;
			               Nil,																								;
			               Iif((cQuery)->RH3_STATUS $ "1" .And. Alltrim((cQuery)->RH3_MATAPR) == Alltrim(cMatSRA),.T.,.F.),	;
			               nVacDays,                                                                                        ;
			               lSolicAbono,                                                                                     ;
			               lSolic13,                                                                                        ;
			               (cQuery)->RH3_CODIGO,                                                                            ;
			               (cQuery)->R_E_C_N_O_,                                                                            ;
			               (cQuery)->RH3_STATUS,                                                                            ;
			               cFilRH4,                                                                                         ;
			               (cQuery)->RH3_NVLINI,                                                                            ;
			               (cQuery)->RH3_NVLAPR,                                                                            ;
			               Iif(!Empty(dDataBaseIni),dDataBaseIni,Nil),													    ;
			               Iif(!Empty(dDataBaseFim),dDataBaseFim,Nil)													    ;
			                })

	EndIf

	(cQuery)->( DbSkip() )

EndDo

(cQuery)->( DBCloseArea() )


RestArea(aAreaSRA)
RestArea(aArea)

Return(Nil)


/*/{Protheus.doc}getBonus
- Retorna dias de Abono.
@author: 	Matheus Bizutti
@since:		12/04/2017

/*/
Function getBonus(cMat,dDtBase,dDtAte)

Local cQuery 	:= GetNextAlias()
Local aArea		:= GetArea() // current area
Local aAreaSRA	:= SRA->(GetArea())
Local nQtdAbono	:= 0

Default cMat 		:= ""
Default dDtBase	:= CtoD(" / / ")
Default dDtAte	:= CtoD(" / / ")

BEGINSQL ALIAS cQuery

	SELECT *
	   	   FROM %table:SRH% SRH
	WHERE SRH.RH_MAT = %Exp:cMat% AND
	      SRH.RH_ROTEIR = 'FER' AND
	      SRH.RH_DABONPE > 0 AND
	   	  SRH.%NotDel%

ENDSQL

While (cQuery)->(!Eof())

	nQtdAbono += (cQuery)->RH_DABONPE

	(cQuery)->( DbSkip() )
EndDo

(cQuery)->( DBCloseArea() )

RestArea(aAreaSRA)
RestArea(aArea)

Return(nQtdAbono)


/*/{Protheus.doc}filterService
- Alimenta o Json de Retorno baseado no filtro utilizado ( TEAMS OR ROLES ) por query param.
@author: 	Matheus Bizutti
@since:		12/04/2017

/*/
Function filterService(id,name,cJsonObj,aData,aCoordTeam,cType)

Local nX			:= 0
Local nY			:= 0
Local oService	:= Nil
Local cOldId		:= ""

Default id 			:= ""
Default name			:= ""
Default cType			:= ""
Default aData			:= {}
Default aCoordTeam	:= {}
Default cJsonObj		:= "JsonObject():New()"

If Len(aCoordTeam) > 0

	// - Ordena por departamento.
	ASORT(aCoordTeam[1]:ListOfEmployee,,, { |x, y| x:Department > y:Department } )
	For nX := 1 To Len(aCoordTeam)

		For nY := 1 To Len(aCoordTeam[nX]:ListOfEmployee)

			 oService	:= &cJsonObj

            If cType $ "teams##organizationalsubdivision"

                If  EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:Department)) != cOldId
                    oService["id"]   := EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:Department))
                    oService["name"] := EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:DescrDepartment))

                    cOldId  := EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:Department))
                    Aadd(aData,oService)
                EndIf

            ElseIf cType == "roles"

                If  EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:FunctionId)) != cOldId
                    oService["id"]   := EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:FunctionId))
                    oService["name"] := EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:FunctionDesc))

                    cOldId  := EncodeUTF8(Alltrim(aCoordTeam[nX]:ListOfEmployee[nY]:FunctionId))
                    Aadd(aData,oService)
                EndIf
            EndIf

		Next nY

	Next nX

EndIf

Return(Nil)

/*/{Protheus.doc}validDate
- Valida as datas de exibicao das ocorrencias.
@author: 	Matheus Bizutti
@since:		12/04/2017

/*/
Static Function validDate(qryStringInit , dtAfastInit ,qryStringEnd, dtAfastEnd )

Local lRet			:= .T.
Local cDtInit		:= ""
Local cDtFinish 	:= ""

Default qryStringInit 	:= ""
Default dtAfastInit	  	:= dDataBase
Default qryStringEnd  	:= ""
Default dtAfastEnd 	  	:= dDataBase

If !Empty(qryStringInit) .And. !Empty(qryStringEnd)

	cDtInit 	:= Ctod(Substr(qryStringInit,9,2) + "/" + Substr(qryStringInit,6,2) + "/" + Substr(qryStringInit,1,4))
	cDtFinish	:= Ctod(Substr(qryStringEnd,9,2)  + "/" + Substr(qryStringEnd,6,2)  + "/" + Substr(qryStringEnd,1,4))

	// - A SRF e a SR8 nÃ£o tem o mesmo padrÃ£o para os CAMPOS DATA
	// - Por isso transformamos tudo em DATE para tratamento.
	If ValType(dtAfastInit) == "C" .Or. ValType(dtAfastEnd) == "C"
		dtAfastInit := CTOD(Alltrim(dtAfastInit))
		dtAfastEnd  := CTOD(Alltrim(dtAfastEnd))
	EndIf

	If !(dtAfastInit >= cDtInit .And. dtAfastEnd <= cDtFinish)
		lRet := .F.
	EndIf

EndIf

Return(lRet)

/*/{Protheus.doc}getDescs
- Retorna a descricao dos arquivos: SRJ e RCM.
@author: 	Matheus Bizutti
@since:		12/04/2017

/*/
Static Function getDescs(cCod,lIsRoleDescription,cBranchVld)

Local cDesc		:= ""

Default cCod	:= ""
Default lIsRoleDescription := .F.
Default cBranchVld := FwCodFil()

cDesc := Iif( lIsRoleDescription, FDesc("SRJ", cCod, "RJ_DESC",,cBranchVld ) , Alltrim(FDesc("RCM", cCod, "RCM_DESCRI",,cBranchVld ) ) )

Return( Alltrim(cDesc) )

/*/{Protheus.doc}getStatusWKF
- De/Para dos Status enviados pelo Front-End ao Rest;
@author: 	Matheus Bizutti
@since:		12/04/2017

/*/
Static Function getStatusWKF(cStatus)

Local cDesc 	:= ""
Default cStatus := ""

/*
- DE/PARA
- STATUS PROTHEUS -> STATUS FRONTEND

"empty": vazio utilizado por perÃ­odo aquisitivo
"approving": em aprovacao (primeiro nivel gestor/coordenador, solicitada, etc)
"approved": em aprovacao DP/RH, aprovado pelo gestor
"rejected": rejeitado
"closed": aprovada pelo RH/DP, marcada, pagas, finalizadas

*/

DO CASE
	CASE cStatus == "1" .or. cStatus == "4" // Solicitada (em processo de aprovacao) ou Aguardando Efetivacao do RH
		cDesc := "approving"
	CASE cStatus == "2" // Atendida pelo RH
		cDesc := "closed"
	CASE cStatus == "3" // Reprovada
		cDesc := "rejected"
	OTHERWISE
		cDesc := "empty"
ENDCASE

Return(cDesc)

/*/{Protheus.doc}SetJson
- Funcao IMPORTANTISSIMA* responsavel por efetuar a criacao do JSON baseada nas ocorrencias (Array aOcurances).
@author: 	Matheus Bizutti
@since:		12/04/2017

/*/
Function SetJson(oAbsences,aAbsences,cJsonObj,aOcurances,nX)

Local aDateGMT		:= {}

Default aAbsences		:= {}
Default cJsonObj		:= "JsonObject():New()"
Default oAbsences		:= &cJsonObj
Default aOcurances	:= {}
Default nX				:= 0

oAbsences  			:= &cJsonObj

If !Empty(aOcurances)
	// - Adiciona as ausencias
	// - definidas pelos seus tipos (enum) do FrontEnd
	oAbsences["id"] 					:= aOcurances[nX][2]
	oAbsences["type"] 				:= aOcurances[nX][3]
	oAbsences["status"]				:= aOcurances[nX][4]

    If aOcurances[nX][3] == "vacation" .and. aOcurances[nX][4] == "approved"
       oAbsences["statusLabel"]    := Alltrim( EncodeUTF8(STR0010) ) //Marcadas
    else
       oAbsences["statusLabel"]    := Nil
    EndIf


	// - A SRF e a SR8 nÃ£o tem o mesmo padrÃ£o para os CAMPOS DATAINI
	// - Por isso transformamos tudo em DATE para tratamento em FORMATO GTM.
	If !(Valtype(aOcurances[nX][5]) == "U" .And. ValType(aOcurances[nX][6]) == "U")

		aDateGMT := {}
		If ValType(aOcurances[nX][5]) == "C" .Or. ValType(aOcurances[nX][6]) == "C"

			If "/" $ aOcurances[nX][5] .And. "/" $ aOcurances[nX][6]
				aOcurances[nX][5] := Substr(aOcurances[nX][5],7,4) + Substr(aOcurances[nX][5],4,2) + Substr(aOcurances[nX][5],1,2)
				aOcurances[nX][6] := Substr(aOcurances[nX][6],7,4) + Substr(aOcurances[nX][6],4,2) + Substr(aOcurances[nX][6],1,2)
			EndIf

			aOcurances[nX][5] := STOD(aOcurances[nX][5])
			aOcurances[nX][6] := STOD(aOcurances[nX][6])

		EndIf

		aDateGMT := LocalToUTC( DTOS(aOcurances[nX][5]), "12:00:00" )
		oAbsences["initDate"] 				:= Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + aDateGMT[2] + "Z"

		aDateGMT := {}
		aDateGMT := LocalToUTC( DTOS(aOcurances[nX][6]), "12:00:00" )
		oAbsences["endDate"]				:= Substr(aDateGMT[1],1,4) + "-" + Substr(aDateGMT[1],5,2) + "-" + Substr(aDateGMT[1],7,2) + "T" + aDateGMT[2] + "Z"
	EndIf

	oAbsences["vacationBonus"] 			:= aOcurances[nX][7]
	oAbsences["approved"] 				:= aOcurances[nX][8]
	oAbsences["approvers"]				:= aOcurances[nX][9]
	oAbsences["justify"]					:= Iif(aOcurances[nX][10] != Nil, EncodeUTF8(aOcurances[nX][10]), aOcurances[nX][10])
	oAbsences["statusAbbr"]				:= Nil
	oAbsences["canApprove"]				:= aOcurances[nX][11]
	If aOcurances[nX][12] != Nil
		oAbsences["absenceDays"]			:= aOcurances[nX][12]
	EndIf

	aAdd(aAbsences, oAbsences)
Else
	// - Lista Vazia
	aAbsences := {}
EndIf

Return(Nil)


/*/{Protheus.doc} fGetSupNotify
Verifica se o funcionario esta substituindo o seu gestor e retorna uma matriz com seus dados
@author:	Marcelo Silveira
@since:		02/05/2019
@param:		cBranchVld - Filial do funcionario para localizacao de seu gestor;
			cMatSRA - Matricula do funcionario para localizacao de seu gestor;
			lIncMat - Inclui no array dados do subordinado;
@return:	aSubstitute - Array com as dados do gestor e departamentos para buscar as notificaoes
/*/
Function fGetSupNotify(cBranchVld, cMatSRA, lIncMat )

Local cJsonObj      := "JsonObject():New()"
Local cQuery        := ""
Local cBranch       := ""
Local cWhere 		:= ""
Local nX	 		:= 0
Local aSubstitute	:= {}
Local lContinua		:= AliasInDic("RJ2")
Local dCurrentDate  := DtoS( Date() )

DEFAULT cBranchVld	:= ""
DEFAULT cMatSRA     := ""
DEFAULT lIncMat		:= .F. //Considera a matricula substituta

If lContinua

	cBranch := xFilial("RJ2", cBranchVld)
	cQuery  := GetNextAlias()

	BEGINSQL ALIAS cQuery

		SELECT RJ2.RJ2_FILIAL, RJ2.RJ2_MAT, RJ2.RJ2_MATSUB, RJ2.RJ2_FILSUB, RJ2.RJ2_DEPTO, RJ2.RJ2_DATADE, RJ2.RJ2_DATATE
		FROM %Table:RJ2% RJ2
		WHERE RJ2.RJ2_FILSUB = %Exp:cBranch%
		  AND RJ2.RJ2_MATSUB = %Exp:cMatSRA%
		  AND RJ2.%NotDel%
		ORDER BY RJ2_MATSUB, RJ2_DATADE

	ENDSQL

	//Retornar um array com dados do gestor que esta sendo substituido com seguinte estrutura
	//aSubstitute[1,1] = FILIAL1
	//aSubstitute[1,2] = MATRICULA1
	//aSubstitute[1,3] = 'DEPARTAMENTO1','DEPARTAMENTO2','DEPARTAMENTO3' (Formatado para uso em query)
	While (cQuery)->(!Eof())

		If  ;
			( (dCurrentDate <= (cQuery)->RJ2_DATADE .And. dCurrentDate >= (cQuery)->RJ2_DATATE ) .Or. ;
			  (dCurrentDate >= (cQuery)->RJ2_DATADE .And. dCurrentDate <= (cQuery)->RJ2_DATATE ) .Or. ;
			  (dCurrentDate <= (cQuery)->RJ2_DATATE .And. dCurrentDate >= (cQuery)->RJ2_DATATE ) .Or. ;
			  (dCurrentDate >= (cQuery)->RJ2_DATATE .And. dCurrentDate <= (cQuery)->RJ2_DATATE ) )

			  If (nPos := aScan(aSubstitute, {|x| x[1]+x[2] == (cQuery)->RJ2_FILIAL + (cQuery)->RJ2_MAT}) ) == 0
			  	aAdd( aSubstitute, { (cQuery)->RJ2_FILIAL, (cQuery)->RJ2_MAT, "'" + (cQuery)->RJ2_DEPTO + "',"} )
			  Else
			  	aSubstitute[nPos,3] += "'" + (cQuery)->RJ2_DEPTO + "',"
			  EndIf
		EndIf

		(cQuery)->( DbSkip())
	EndDo

	(cQuery)->( DBCloseArea() )

	//Adiciona no array os dados do substituido, para que as notificacoes possam
	//exibir os dados tanto do gestor como do subordinado que esta sendo seu substituto
	If !Empty(aSubstitute) .And. lIncMat
		If (nPos := aScan(aSubstitute, {|x| x[1]+x[2] == cBranchVld + cMatSRA}) ) == 0
			aAdd( aSubstitute, { cBranchVld, cMatSRA, "'" + Posicione('SRA',1,cBranchVld + cMatSRA,'SRA->RA_DEPTO') + "'," } )
		Else
			aSubstitute[nPos,3] += "'" + Posicione('SRA',1,cBranchVld + cMatSRA,'SRA->RA_DEPTO') + "',"
		EndIf
	EndIf

EndIf

Return( aSubstitute )

/*/{Protheus.doc} fEmployeeBirthDate
Retorna os funcionários que fazem aniversário no mês vigente.
@author:	Fernando Quinteiro
@since:		16/07/2019
@param:		cBranchVld - Filial;
			cMatSRA - Matricula;
@return:	aListEmpl - Array com funcionários do time que fazem aniversários
/*/
Function fEmployeeBirthDate( cBranchVld, cMatSRA )

Local cJsonObj 	 	:= "JsonObject():New()"
Local oEmployee		:= &cJsonObj
Local aListEmpl		:= {}
Local aArea			:= {}
Local cDtIni		:= SubString(DToS(FirstDate(dDataBase)), 5, 4)
Local cDtFim		:= Substring(DToS(LastDate(dDataBase)), 5, 4)
Local cMatTeam		:= ""
Local cAliasSRA		:= ""
Local cWhereSRA		:= "%%"
Local nX 			:= 1

aCoordTeam := APIGetStructure("", "", , cBranchVld, cMatSRA, , , , , cBranchVld, cMatSRA)

For nX := 1 To Len( aCoordTeam[1]:ListOfEmployee )
	If !aCoordTeam[1]:ListOfEmployee[nX]:Registration == cMatSRA //Nao considera a matricula do lider/gestor
		cMatTeam += "'" + aCoordTeam[1]:ListOfEmployee[nX]:Registration + "',"
	EndIf
Next

cMatTeam  := SubStr(cMatTeam, 2, Len(cMatTeam)-3 )
cWhereSRA := cMatTeam

If !Empty(cWhereSRA)
	
	aArea		:= GetArea()
	cAliasSRA	:= GetNextAlias()
	
	BeginSql alias cAliasSRA
		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NASC, RA_NOME
		FROM %table:SRA% SRA
		WHERE 	SRA.RA_FILIAL = %exp:cBranchVld% AND 
				SRA.RA_MAT IN ( %exp:cWhereSRA% ) AND
				SUBSTRING(RA_NASC, 5, 4 ) BETWEEN ( %exp:cDtIni% ) AND ( %exp:cDtFim% ) AND
				SRA.%notDel%
		ORDER BY 
			RA_NASC
	EndSql	

	While (cAliasSRA)->( !Eof() )

		oEmployee["employeeId"] 	:= (cAliasSRA)->RA_FILIAL + "|" + (cAliasSRA)->RA_MAT
		oEmployee["birthDate"] 		:= Substr((cAliasSRA)->RA_NASC,1,4) + "-" + Substr((cAliasSRA)->RA_NASC,5,2) + "-" + Substr((cAliasSRA)->RA_NASC,7,2) + "T" + "12:00:00" + "Z"
		oEmployee["employeeName"]	:= AllTrim((cAliasSRA)->RA_NOME)

		aAdd(aListEmpl, oEmployee)

		oEmployee := Nil
		oEmployee := &cJsonObj

		DbSkip()
		
	EndDo

	RestArea( aArea )

EndIf

Return( aListEmpl )