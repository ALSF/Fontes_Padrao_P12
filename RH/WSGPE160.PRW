#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSGPE160.CH"

#DEFINE PAGE_LENGTH 10

Function WSGPE160()
Return

WSSTRUCT TPostList
	WSDATA Cod				As String
	WSDATA Desc				As String
	WSDATA Esp				As String OPTIONAL
	WSDATA DescDet			As String
	WSDATA Resp				As String
	WSDATA Skills			As String
	WSDATA Relac			As String
ENDWSSTRUCT

WSSTRUCT TPostSIX
	WSDATA Chave			As String
	WSDATA Descricao		As String
ENDWSSTRUCT

WSSTRUCT TPostBrowse
	WSDATA Itens			AS Array Of TPostList	OPTIONAL
	WSDATA Head				AS Array Of String		OPTIONAL
	WSDATA PagesTotal		AS Integer 				OPTIONAL
	WSDATA FiltInd			AS Array Of TPostSIX	OPTIONAL //Variavel Genérica para preenchimento de filtro
ENDWSSTRUCT

WSSERVICE RHPost DESCRIPTION STR0001 //"Webservice de Cargos"
	WSDATA WsNull			As String	OPTIONAL

	WSDATA CurrentPage		As Integer
	WSDATA FilterField		As String
	WSDATA FilterValue		As String
	
	WSDATA ContHtml			AS String	OPTIONAL
	
	WSDATA PostBrowse		As TPostBrowse OPTIONAL
	
	WSMETHOD BrowsePost	DESCRIPTION STR0002 //"Método de consulta do Descritivo de Cargos"
ENDWSSERVICE 


WSMETHOD BrowsePost;
WSRECEIVE CurrentPage, FilterField, FilterValue;
WSSEND PostBrowse;
WSSERVICE RHPost
	Local cFiltro
	Local cSQ3CountAlias	:= GetNextAlias()
	Local cSQ3Alias			:= GetNextAlias()
	Local cFieldHead		:= ''
	Local cOpcCMBAll		:= ''
	Local cOpcDescll		:= ''
	Local cNameDB			:= Upper(TcGetDb())
	Local nRegIni			:= 1
	Local nRegFim			:= 0
	Local nReg				:= 0
	Local uRetBlock			:= ""
	Local nX				:= 0
	Local aQry				:= {}
	Local aFilterCMB		:= {{'Q3_CARGO' ,RetTitle('Q3_CARGO')},{'Q3_DESCSUM',RetTitle('Q3_DESCSUM')}}

If !("'" $ FilterValue) .AND. ; //se o filtro possuir aspas em seu texto, nao é realizado processamento
	!( !Empty(FilterValue) .AND. Empty(FilterField) )
	//nao será processada busca caso preencher apenas o valor de busca e nao definir o campo de busca (cod./descricao)

	cFiltro := " Q3_FILIAL = '" + xFilial("SQ3") + "' AND "

	If Empty(FilterValue) .And. Empty(FilterField)
		cFiltro	+= " Q3_DESCSUM LIKE '%" + FilterValue + "%' "
		If !(cNameDB $ "ORACLE")
			cFiltro += " COLLATE LATIN1_GENERAL_CI_AI "
		EndIf
	Else
		aQry := StrTokArr(FilterField,'+')
		cFiltro += '('
		For nX:= 1 To Len(aQry)
			cFiltro	+= IIF(nX>1,"OR","")+" "+ aQry[nX] +" LIKE '%" + FilterValue + "%' " 
			If !(cNameDB $ "ORACLE")
				cFiltro += " COLLATE LATIN1_GENERAL_CI_AI "
			EndIf
		Next nX
		cFiltro+= ')'
	EndIf

	Self:PostBrowse:= WSClassNew("TPostBrowse")
	Self:PostBrowse:Itens	:= {}
	Self:PostBrowse:FiltInd	:= {}
	Self:PostBrowse:Head	:= {}

	//Ponto de Entrada que recebera como retorno um array de uma unica linha com 2 posicoes, sendo:
	//  uRetBlock[1][1] -> (opcional) Campo exclusivamente da SQ3 que deverá ser adicionado como coluna na consulta
	//  uRetBlock[1][2] -> (opcional) Filtro (em SQL) exclusivamente sobre campos da SQ3 que sera acrescentado na query
	//Exemplo:
	//	User Function WSGP160()
	//	Local aFiltro:= { { 'Q3_CC' , "Q3_CC != ''" } }
	//	Return(aFiltro)
	If ExistBlock("WSGP160")
		uRetBlock := ExecBlock( "WSGP160", .F., .F. )
	EndIf

	//CARREGA AS INFORMAÇÕES DA TAG TH DA TABELA 
	For nX:=1 To Len(aFilterCMB)
		aAdd(Self:PostBrowse:Head, aFilterCMB[nX][2])
	Next

	//Considera somente a primeira linha do array retornado pelo ponto de entrada, desprezando as demais.
	if ValType(uRetBlock)=="A" .and. len(uRetBlock) > 0
		If len(uRetBlock[1]) >= 2 .and. !Empty(uRetBlock[1][2])
			cFiltro += " AND " + uRetBlock[1][2]
		Endif
		If !Empty(uRetBlock[1][1])
			aAdd(aFilterCMB, {uRetBlock[1][1],RetTitle(uRetBlock[1][1])})
			cOpcCMBAll := cOpcCMBAll + uRetBlock[1][1]
			cOpcDescll := cOpcDescll + RetTitle(uRetBlock[1][1])
			cFieldHead := IIF(Empty(cFieldHead),uRetBlock[1][1],cFieldHead)
		Endif
	EndIf

	//CARREGANDO DADOS CUSTOMIZADOS PARA O COMBO
	If !Empty(cOpcCMBALL)
		aAdd(aFilterCMB, {aFilterCMB[2][1]+'+'+cOpcCMBAll,aFilterCMB[2][2]+'/'+cOpcDescll})
		aAdd(Self:PostBrowse:Head, RetTitle(cFieldHead))
		cFieldHead := "% " + cFieldHead + ", %"
	EndIf

	cFiltro := "% " + cFiltro + " %"

	BEGINSQL alias cSQ3CountAlias
			SELECT COUNT(*) AS REGISTROS
		      FROM %table:SQ3% SQ3
		     WHERE %exp:cFiltro% 
	           AND SQ3.%notDel%
	ENDSQL
	
	If (cSQ3CountAlias)->REGISTROS > 0
	    // SETA A QUANTIDADE DE PAGINAS
		Self:PostBrowse:PagesTotal := Ceiling((cSQ3CountAlias)->REGISTROS / PAGE_LENGTH) 
		
		// DEFINE QUAL A PÁGINA INICIAL E FINAL DE ACORDO COM A PAGINACAO CORRENTE
		nRegFim	:= CurrentPage * PAGE_LENGTH
		If CurrentPage > 1
			nRegIni	:= (nRegFim - PAGE_LENGTH) + 1
		EndIf
		

       If !Empty(cFieldHead) 
				BEGINSQL alias cSQ3Alias
						SELECT  Q3_CARGO, 
							    Q3_DESCSUM,
					           %exp:cFieldHead% 
					           Q3_DESCDET,
					           Q3_DRESP,
					           Q3_DRELINT,
					           Q3_DHABILI
					      FROM %table:SQ3% 
					     WHERE %exp:cFiltro% 
				           AND %notDel% 
					  ORDER BY Q3_DESCSUM
				ENDSQL
		Else		
				BEGINSQL alias cSQ3Alias
						SELECT  Q3_CARGO, 
							    Q3_DESCSUM,
					           Q3_DESCDET,
					           Q3_DRESP,
					           Q3_DRELINT,
					           Q3_DHABILI
					      FROM %table:SQ3% 
					      WHERE %exp:cFiltro% 
				           AND %notDel% 
					  ORDER BY Q3_DESCSUM
				ENDSQL
		EndIf

		While (cSQ3Alias)->( !Eof())
		    nReg++
		    
	    	If nRegIni <= nReg .AND. nRegFim >=  nReg 
				oItem:= WSClassNew("TPostList")
				oItem:Cod		:= (cSQ3Alias)->Q3_CARGO
				oItem:Desc		:= (cSQ3Alias)->Q3_DESCSUM
				if !Empty(cFieldHead)
					oItem:Esp		:= (cSQ3Alias)->&(Alltrim(StrTran(StrTran(cFieldHead,'%',''),',','')))
				EndIf

				oItem:DescDet	:= APDMSMM((cSQ3Alias)->Q3_DESCDET,,,,,,,"SQ3" )
				oItem:Resp		:= APDMSMM((cSQ3Alias)->Q3_DRESP  ,,,,,,,"SQ3" )
				oItem:Skills	:= APDMSMM((cSQ3Alias)->Q3_DHABILI,,,,,,,"SQ3" )
				oItem:Relac		:= APDMSMM((cSQ3Alias)->Q3_DRELINT,,,,,,,"SQ3" )
				
				aAdd(::PostBrowse:Itens, oItem)
			ElseIf nReg > nRegFim //se ja passou o ultimo registro da pagina, sai do laco.
				Exit
			EndIf
	
			(cSQ3Alias)->( dbSkip() )
		EndDo
	Else
		oItem:= WSClassNew("TPostList")
		oItem:Cod		:= ""
		oItem:Desc		:= ""
		oItem:Esp		:= ""
		oItem:DescDet	:= ""
		oItem:Resp		:= ""
		oItem:Skills	:= ""
		oItem:Relac		:= ""
		
		aAdd(Self:PostBrowse:Itens, oItem)
		Self:PostBrowse:PagesTotal	:= 0
	EndIf
EndIf
//PREENCHE OS DADOS PARA O FILTRO
For nX:= 1 To Len(aFilterCMB)
		oSIXFilt:= WSClassNew("TPostSIX")
		oSIXFilt:Chave		:= 	aFilterCMB[nX][1]
		oSIXFilt:Descricao	:=	aFilterCMB[nX][2]

		aAdd(Self:PostBrowse:FiltInd, oSIXFilt)
Next nX
Return .T.