#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "WSTRM010.CH"

#DEFINE PAGE_LENGTH 10


#DEFINE OPERATION_INSERT		1
#DEFINE OPERATION_UPDATE		2
#DEFINE OPERATION_APPROVE		3
#DEFINE OPERATION_REPROVE		4
#DEFINE OPERATION_DELETE		5

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WSTRM010 ³								         					 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Web Service responsavel pelas requisicoes de treinamento              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista	    ³ Data       ³ FNC            ³ 	Motivo da Alteracao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³ Marcelo Faria   ³ 22/06/2011 ³00000023596/2010|Preparacao dos servicos para      ³±±
±±³                 ³            ³Chamdo: SCYE93  |padronizacao das solicitacoes     ³±±
±±³                 ³            ³                |de treinamento do Portal Protheus ³±±
±±³Emerson Campos   |09/07/14    |	TPWQVJ		     |Interesse em treinamento          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

WSSTRUCT DataTrainings
	WSDATA Branch					AS String	
	WSDATA CalendarCode				AS String
	WSDATA CalendarDescription		AS String
	WSDATA CourseCode				AS String
	WSDATA CourseDescription		AS String
	WSDATA CourseClass				AS String
	WSDATA InitialDate				AS Date
	WSDATA EndingDate				AS Date
	WSDATA Time						AS String
	WSDATA Duration					AS String
	WSDATA TotalPlaces				AS Integer
	WSDATA ReservedPlaces			AS Integer
	WSDATA CodeInstructor			AS String  OPTIONAL
	WSDATA DescInstructor			AS String  OPTIONAL
	WSDATA HasRequest	        	AS Boolean OPTIONAL
	WSDATA QuantityInterested		AS Integer OPTIONAL
	WSDATA MinimumQuantity			AS String OPTIONAL
	WSDATA Requested				AS String OPTIONAL
	WSDATA ReserveType				AS String OPTIONAL
ENDWSSTRUCT

WSSTRUCT DataCategs
	WSDATA CategCode				AS String
	WSDATA CategDesc				AS String
ENDWSSTRUCT

WSSTRUCT TTrainingData
	WSDATA ListOfTrainings			AS Array 	Of DataTrainings	OPTIONAL
	WSDATA PagesTotal				AS Integer 						OPTIONAL	
	WSDATA ParameterMVINTTREI		AS Boolean 						OPTIONAL
	WSDATA ListOfCategs				AS Array 	Of DataCategs		OPTIONAL
ENDWSSTRUCT

WSSTRUCT DataDisciplines
	WSDATA DisCode					AS String
	WSDATA DisDescrip				AS String  OPTIONAL
	WSDATA DisSummary				AS String  OPTIONAL
	WSDATA DisWorkload  			AS Float   OPTIONAL
ENDWSSTRUCT

WSSTRUCT TDisciplineData
	WSDATA ListOfDisciplines 		AS Array 	OF DataDisciplines	OPTIONAL
ENDWSSTRUCT

WSSTRUCT TDataCoursesBrowse
	WSDATA Itens					AS Array 	OF DataCourses		OPTIONAL
ENDWSSTRUCT

WSSTRUCT DataCoursesEmployee
	WSDATA Branch					AS String  OPTIONAL	
	WSDATA Registration	   			AS String  OPTIONAL 
	WSDATA PositionId				AS String  OPTIONAL
	WSDATA CourseHeld				AS Boolean OPTIONAL
	WSDATA Indice					AS String  OPTIONAL
	WSDATA DescSituacao	   			AS String  OPTIONAL
	WSDATA AdmissionDate			AS String  OPTIONAL
	WSDATA DescrDepartment	   		AS String  OPTIONAL
	WSDATA Name						AS String  OPTIONAL
ENDWSSTRUCT

WSSTRUCT DataPosition
	WSDATA PositionId				AS String	
	WSDATA DescrPosition	   		AS String 
	WSDATA ListOfCourses			AS Array 	OF DataCourses 		OPTIONAL
ENDWSSTRUCT

WSSTRUCT TEmployeesData
	WSDATA ListOfEmployee			AS Array 	OF DataCoursesEmployee OPTIONAL
ENDWSSTRUCT

WSSTRUCT DataCourses
	WSDATA CourseCode				AS String  OPTIONAL
	WSDATA CourseDescription		AS String  OPTIONAL
	WSDATA CourseRequired			AS Boolean OPTIONAL
	WSDATA CourseHeld				AS Boolean OPTIONAL
	WSDATA ListOfEmployee			AS Array 	OF DataCoursesEmployee OPTIONAL
ENDWSSTRUCT

WSSERVICE RHTrainings DESCRIPTION STR0007 //"Treinamentos"
	WSDATA Branch					AS String 
	WSDATA CalendarCode				AS String 
	WSDATA CourseCode				AS String 
	WSDATA CourseClass				AS String	
	WSDATA Registration				AS String  OPTIONAL	//Codigo da Matricula
	WSDATA Page						AS Integer OPTIONAL	//Numero da Pagina, para paginacao
	WSDATA FilterField				AS String  OPTIONAL	//Campo para filtro
	WSDATA FilterValue				AS String  OPTIONAL	//Condicao de filtro das querys
	WSDATA PositionId				AS String  OPTIONAL		//Cargo do Funcionario
	WSDATA PositionIdDepto			AS String  OPTIONAL		//Cargo do Funcionario
	WSDATA FilterCateg				AS String  OPTIONAL		//Categoria do Cargo
	WSDATA FilterType				AS String  OPTIONAL		//Tipo de Inscrição		
	
	WSDATA TrainingData				AS TTrainingData	//Lista de Treinamentos
	WSDATA Training					AS DataTrainings    //Descricao do Treinamento
	WSDATA Discipline				AS TDisciplineData  //Disciplinas
	WSDATA MapTraining				AS TDataCoursesBrowse 	//Lista de Cursos
	WSDATA ListOfPosition			AS Array of DataPosition
	WSDATA EmployeesData			AS TEmployeesData		//Estrutura Organizacional 
	
	WSMETHOD BrowseTrainings		DESCRIPTION STR0001 //"Metodo de consulta os treinamentos disponiveis"
	WSMETHOD GetTraining			DESCRIPTION STR0002 //"Metodo de consulta os dados de um treinamento"	
	WSMETHOD GetDiscipline			DESCRIPTION STR0003 //"Metodo de consulta as disciplinas de um treinamento"
	WSMETHOD GetMapTrainings		DESCRIPTION STR0004 //"Retornar todos os cursos exigidos pelo cargo e todos os cursos realizados pelo funcionário"
	WSMETHOD GetDepartMapTrainings 	DESCRIPTION STR0005 //"Retornar todos os cursos exigidos pelos cargos dos subordinados e o percentual de funcionários que o realizou."
	WSMETHOD OtherTrainings			DESCRIPTION STR0006 //"Método de consulta de outros treinamentos não disponíveis"
	WSMETHOD GetOutherTraining		DESCRIPTION STR0008 //"Método que consulta informações de um determinado curso"
ENDWSSERVICE                                  

WSMETHOD BrowseTrainings;
WSRECEIVE Branch,Page,FilterField,FilterValue,FilterCateg,FilterType;
WSSEND TrainingData;
WSSERVICE RHTrainings
	Local oItem
	Local nRecCount
	Local cWhere    	 		:= ""
	Local dDataIni				:= dDataBase
	Local cQuery				:= GetNextAlias()
	Local cAuxAlias	 			:= GetNextAlias()
	Local cRA3Branch			:= xFilial("RA3", Self:Branch)	
	Local cRA2Branch			:= xFilial("RA2", Self:Branch)
	Local cRA1Branch			:= xFilial("RA1", Self:Branch)

	DEFAULT Self:Page 			:= 1
	DEFAULT Self:FilterField	:= ""
	DEFAULT Self:FilterValue	:= ""	
	DEFAULT Self:Registration	:= ""
	DEFAULT Self:PositionId		:= ""
	DEFAULT Self:FilterCateg	:= STR0011 //"Todos"
	DEFAULT Self:FilterType		:= "3"
	
	//Carrega categorias existentes
	Self:TrainingData:ListOfCategs := {}
	
	If TCCANOPEN(retsqlname("AIQ")) // AIQ->(ColumnPos( "AIQ_FILIAL" )) > 0 //Colocado TCCANOPEN devido ser uma tabela nova
	
		BEGINSQL ALIAS cAuxAlias
			SELECT * FROM 
				%Table:AIQ% AIQ
			WHERE
				AIQ.%NotDel%
			ORDER BY
				AIQ_DESCRI
		ENDSQL
	
		While (cAuxAlias)->(!Eof())
			oItem:= WSClassNew("DataCategs")
			oItem:CategCode := (cAuxAlias)->AIQ_CODIGO
			oItem:CategDesc := (cAuxAlias)->AIQ_DESCRI
			AAdd(Self:TrainingData:ListOfCategs, oItem)
			(cAuxAlias)->(DbSkip())
		EndDo	
	
		(cAuxAlias)->(DBCloseArea())
		
	EndIf

	cAuxAlias	 			:= GetNextAlias()
	
	//Verificar Filtro
	cCampo						:= Self:FilterField
	cFiltro						:= Self:FilterValue
	cWhere := "%"
	If !Empty(cFiltro) .AND. !Empty(cCampo)
	    If(cCampo == "RA1_DESC") 
	      //descricao curso
	      cWhere += " AND RA1.RA1_DESC LIKE '%" + Upper(Replace(cFiltro,"'","")) + "%'"
	    ElseIf(cCampo == "RA2_DATAIN")
	      //data inicial
		  If !Empty(cTod(cFiltro))
		     dDataIni := cTod(cFiltro)	          
		  EndIf   
	    Endif  
	EndIf
	
	If Self:FilterCateg <> 'Todos' .and. RA1->(ColumnPos("RA1_CATEG")) > 0   //"Todos"
		cWhere += " AND RA1.RA1_CATEG = '" + Self:FilterCateg + "' "
	EndIf
	
	//Diferente de todos
	If Self:FilterType == "1"
		cWhere += " AND RA3.RA3_RESERV = 'S' "
	ElseIf Self:FilterType == "2"
		cWhere += " AND RA3.RA3_RESERV <> 'S' "
	EndIf
	
	cWhere += "%"
	
	Self:TrainingData:ListOfTrainings := {}
	BEGINSQL ALIAS cQuery
		COLUMN RA2_DATAIN AS DATE
		COLUMN RA2_DATAFI AS DATE
		COLUMN RA2_VAGAS AS NUMERIC(4, 0) 
		COLUMN RA2_RESERV AS NUMERIC(4, 0)
		COLUMN RA3_QTDSOL AS NUMERIC(4, 0)		
		COLUMN RA2_DURACA AS NUMERIC(7, 2)

		SELECT 
			RA2.RA2_FILIAL,
			RA2.RA2_CALEND,
			RA2.RA2_DESC,
			RA2.RA2_CURSO,
			RA2.RA2_TURMA,		
			RA1.RA1_DESC,
			RA2.RA2_DATAIN,
			RA2.RA2_DATAFI,
			RA2.RA2_HORARI,
			RA2.RA2_DURACA,
			RA2.RA2_UNDURA,		
			RA2.RA2_VAGAS,
			RA2.RA2_RESERV,
			RA2.RA2_INSTRU,
			COUNT(RA3_MAT) AS RA3_QTDSOL
		FROM 
			%Table:RA2% RA2
		INNER JOIN %Table:RA1% RA1
		ON RA1.RA1_CURSO = RA2.RA2_CURSO 		AND
			RA1.RA1_FILIAL = %Exp:cRA1Branch% 	AND
			RA1.%NotDel%			
		LEFT OUTER JOIN %Table:RA3% RA3
		ON	RA2.RA2_CALEND	= RA3.RA3_CALEND 	AND
			RA2.RA2_CURSO	= RA3.RA3_CURSO 	AND
			RA2.RA2_TURMA	= RA3.RA3_TURMA 	AND
			RA3.RA3_RESERV	= 'S' 				AND
			RA3.RA3_FILIAL = %Exp:cRA3Branch% 	AND
			RA3.%NotDel% 			
		WHERE
			RA2.RA2_REALIZ != 'S' 				AND
			RA2.RA2_DATAIN >= %Exp:dDataIni% 	AND		
			RA2.RA2_FILIAL  = %Exp:cRA2Branch% 	AND 
			RA2.%NotDel%
            %exp:cWhere%			
		GROUP BY
			RA2.RA2_FILIAL,
			RA2.RA2_CALEND,
			RA2.RA2_DESC,
			RA2.RA2_CURSO,
			RA2.RA2_TURMA,		
			RA1.RA1_DESC,
			RA2.RA2_DATAIN,
			RA2.RA2_DATAFI,
			RA2.RA2_HORARI,
			RA2.RA2_DURACA,
			RA2.RA2_UNDURA,		
			RA2.RA2_VAGAS,
			RA2.RA2_INSTRU,
			RA2.RA2_RESERV
		HAVING
			RA2.RA2_VAGAS > (RA2.RA2_RESERV + COUNT(RA3_MAT))
		ORDER BY
			RA2_DATAIN
		
	ENDSQL

	
	COUNT TO nRecCount
	DBGoTop()

	::TrainingData:PagesTotal := Ceiling(nRecCount / PAGE_LENGTH)					  
	If Self:Page > 1
		DBSkip((Self:Page-1) * PAGE_LENGTH)
	EndIf

	While !(cQuery)->(Eof()) .AND. Len(Self:TrainingData:ListOfTrainings) < PAGE_LENGTH

		oItem:= WSClassNew("DataTrainings")
		oItem:Branch				:= (cQuery)->RA2_FILIAL
		oItem:CalendarCode			:= (cQuery)->RA2_CALEND
		oItem:CalendarDescription	:= AllTrim((cQuery)->RA2_DESC)
		oItem:CourseCode			:= (cQuery)->RA2_CURSO 
		oItem:CourseClass			:= (cQuery)->RA2_TURMA 
		oItem:CourseDescription		:= AllTrim((cQuery)->RA1_DESC)				
		oItem:InitialDate			:= (cQuery)->RA2_DATAIN
		oItem:EndingDate			:= (cQuery)->RA2_DATAFI
		oItem:Time					:= AllTrim((cQuery)->RA2_HORARI)
		oItem:Duration				:= AllTrim(AllTrim(Str((cQuery)->RA2_DURACA)) + " " + AllTrim(fDesc("SX5", "R5" + (cQuery)->RA2_UNDURA, "X5DESCRI()", NIL, Self:Branch, NIL, .F.)))
		oItem:TotalPlaces			:= (cQuery)->RA2_VAGAS
		oItem:ReservedPlaces		:= (cQuery)->RA2_RESERV + (cQuery)->RA3_QTDSOL
		oItem:HasRequest			:= .F.
		If ((cQuery)->RA2_INSTRU != '')
			oItem:CodeInstructor	:= (cQuery)->RA2_INSTRU	

			If select(cAuxAlias) > 0
				(cAuxAlias)->(DBCloseArea())
			EndIf
			BeginSql alias cAuxAlias
				SELECT RA7.RA7_NOME
				FROM  %table:RA7% RA7 
				WHERE 
			    	 RA7.RA7_INSTRU = %Exp:(cQuery)->RA2_INSTRU% AND
					 RA7.%notDel%
			EndSql
			If !(cAuxAlias)->(Eof())				
				oItem:DescInstructor := (cAuxAlias)->RA7_NOME
			Else
				oItem:DescInstructor := ''			
			EndIf
		Endif

		AAdd(Self:TrainingData:ListOfTrainings, oItem)

		(cQuery)->(DBSkip())
	EndDo

	(cQuery)->(DBCloseArea())		
Return .T.


WSMETHOD GetTraining;
WSRECEIVE Branch,Registration,CalendarCode,CourseCode,CourseClass;
WSSEND Training;
WSSERVICE RHTrainings
	Local cQuery		:= GetNextAlias()
	Local cAuxAlias	 	:= GetNextAlias()
	Local cAuxAlias2 	:= GetNextAlias()
	Local cAuxAlias3 	:= GetNextAlias()
	Local cRA3Branch	:= xFilial("RA3", Self:Branch)	
	Local cRA2Branch	:= xFilial("RA2", Self:Branch)
	Local cRA1Branch	:= xFilial("RA1", Self:Branch)
	Local cCalendarCode	:= Self:CalendarCode
	Local cCourseCode	:= Self:CourseCode
	Local cCourseClass	:= Self:CourseClass
	Local cMat	:= Self:Registration	
	
	DEFAULT Self:PositionId		:= ""
				
	BEGINSQL ALIAS cQuery
		COLUMN RA2_DATAIN AS DATE
		COLUMN RA2_DATAFI AS DATE
		COLUMN RA2_VAGAS AS NUMERIC(4, 0) 
		COLUMN RA2_RESERV AS NUMERIC(4, 0)
		COLUMN RA3_QTDSOL AS NUMERIC(4, 0)		
		COLUMN RA2_DURACA AS NUMERIC(7, 2)

		SELECT 
			RA2.RA2_FILIAL,
			RA2.RA2_CALEND,
			RA2.RA2_DESC,
			RA2.RA2_CURSO,
			RA2.RA2_TURMA,
			RA1.RA1_DESC,
			RA2.RA2_DATAIN,
			RA2.RA2_DATAFI,
			RA2.RA2_HORARI,
			RA2.RA2_DURACA,
			RA2.RA2_UNDURA,		
			RA2.RA2_VAGAS,
			RA2.RA2_INSTRU,
			RA2.RA2_RESERV,
			COUNT(RA3_MAT) AS RA3_QTDSOL
		FROM 
			%Table:RA2% RA2
		INNER JOIN %Table:RA1% RA1
		ON RA1.RA1_CURSO = RA2.RA2_CURSO AND
			RA1.RA1_FILIAL = %Exp:cRA1Branch% 		AND
			RA1.%NotDel%			
		LEFT OUTER JOIN %Table:RA3% RA3
		ON	RA2.RA2_CALEND	= RA3.RA3_CALEND 		AND
			RA2.RA2_CURSO	= RA3.RA3_CURSO 		AND
			RA2.RA2_TURMA	= RA3.RA3_TURMA 		AND
			RA3.RA3_RESERV	= 'S' 					AND
			RA3.RA3_FILIAL = %Exp:cRA3Branch% 		AND
			RA3.%NotDel% 			
		WHERE
			RA2.RA2_CALEND = %Exp:cCalendarCode% 	AND 
			RA2.RA2_CURSO = %Exp:cCourseCode% 		AND 
			RA2.RA2_TURMA = %Exp:cCourseClass% 		AND 
			RA2.RA2_FILIAL = %Exp:cRA2Branch% 		AND 
			RA1.RA1_FILIAL = %Exp:cRA1Branch% 		AND
			RA2.%NotDel% 							AND
			RA1.%NotDel%
		GROUP BY
			RA2.RA2_FILIAL,
			RA2.RA2_CALEND,
			RA2.RA2_DESC,
			RA2.RA2_CURSO,
			RA2.RA2_TURMA,		
			RA1.RA1_DESC,
			RA2.RA2_DATAIN,
			RA2.RA2_DATAFI,
			RA2.RA2_HORARI,
			RA2.RA2_DURACA,
			RA2.RA2_UNDURA,		
			RA2.RA2_VAGAS,
			RA2.RA2_INSTRU,
			RA2.RA2_RESERV,
			RA3.RA3_RESERV
	ENDSQL
						  
	If !Eof()
		Self:Training:= WSClassNew("DataTrainings")
		Self:Training:HasRequest:= .F.
		
		If Self:Registration != ''
			//Verifica se o funcionario ja possui uma solicitacao
			//de treinamento pendente para o curso.
			// Tipo   A - Treinamento
			// Status 1 - Aguardando aprovacao
			//		  2 - Aguardando efetivacao RH

			If select(cAuxAlias) > 0
				(cAuxAlias)->(DBCloseArea())
			EndIf
			BeginSql alias cAuxAlias
				SELECT RH3.RH3_FILIAL, RH3.RH3_CODIGO, RH4.RH4_CAMPO, RH4.RH4_VALNOV
				FROM  %table:RH3% RH3 
				INNER JOIN %table:RH4% RH4
					ON 	RH3.RH3_FILIAL = RH4.RH4_FILIAL AND 
						RH3.RH3_CODIGO = RH4.RH4_CODIGO
				WHERE 
			    	 RH4.RH4_CAMPO      = 'RA3_MAT'				 	AND
					 RH4.RH4_VALNOV     = %exp:Self:Registration% 	AND
					 RH3.RH3_STATUS     in ('1', '4')   			AND
					 RH3.RH3_TIPO       = 'A'						AND
					 RH4.%notDel%             				     	AND
					 RH3.%notDel%
			EndSql
			//Verifica qual o curso o funcionario possui solicitacao
			While !(cAuxAlias)->(Eof())

				If select(cAuxAlias2) > 0
					(cAuxAlias2)->(DBCloseArea())
				EndIf
				BeginSql alias cAuxAlias2
					SELECT RH4.RH4_CODIGO, RH4.RH4_CAMPO, RH4.RH4_VALNOV
					FROM  %table:RH4% RH4 
					WHERE 
				    	 RH4.RH4_CODIGO  = %exp:(cAuxAlias)->RH3_CODIGO%	AND
				    	 RH4.RH4_CAMPO   = 'RA3_CURSO'				 		AND
						 RH4.RH4_VALNOV  = %Exp:cCourseCode%				AND
						 RH4.%notDel%             				     	
				EndSql
				If !(cAuxAlias2)->(Eof())				
					Self:Training:HasRequest:= .T.
				EndIf	 
					 
				(cAuxAlias)->(DBSkip())
            Enddo
        Endif

		Self:Training:Branch				:= (cQuery)->RA2_FILIAL
		Self:Training:CalendarCode			:= (cQuery)->RA2_CALEND
		Self:Training:CalendarDescription	:= AllTrim((cQuery)->RA2_DESC)
		Self:Training:CourseCode			:= (cQuery)->RA2_CURSO 
		Self:Training:CourseClass			:= (cQuery)->RA2_TURMA 
		Self:Training:CourseDescription		:= AllTrim((cQuery)->RA1_DESC)						
		Self:Training:InitialDate			:= (cQuery)->RA2_DATAIN
		Self:Training:EndingDate			:= (cQuery)->RA2_DATAFI
		Self:Training:Time					:= AllTrim((cQuery)->RA2_HORARI)
		Self:Training:Duration				:= AllTrim(AllTrim(Str((cQuery)->RA2_DURACA)) + " " + AllTrim(fDesc("SX5", "R5" + (cQuery)->RA2_UNDURA, "X5DESCRI()", NIL, Self:Branch, NIL, .F.)))
		Self:Training:TotalPlaces			:= (cQuery)->RA2_VAGAS
		Self:Training:ReservedPlaces		:= (cQuery)->RA2_RESERV + (cQuery)->RA3_QTDSOL
		
		If ((cQuery)->RA2_INSTRU != '')
			Self:Training:CodeInstructor	:= (cQuery)->RA2_INSTRU
			
			If select(cAuxAlias2) > 0
				(cAuxAlias2)->(DBCloseArea())
			EndIf
			BeginSql alias cAuxAlias2
				SELECT RA7.RA7_NOME
				FROM  %table:RA7% RA7 
				WHERE 
			    	 RA7.RA7_INSTRU = %Exp:(cQuery)->RA2_INSTRU% AND
					 RA7.%notDel%
			EndSql
			If !(cAuxAlias2)->(Eof())				
				Self:Training:DescInstructor := (cAuxAlias2)->RA7_NOME
			Else
				Self:Training:DescInstructor := ''			
			EndIf
		Endif
					
		If Select(cAuxAlias3) > 0
			(cAuxAlias3)->(DBCloseArea())
		EndIf
			
		BeginSql alias cAuxAlias3
			SELECT RA3.RA3_RESERV
     		  FROM %table:RA3% RA3
     		 WHERE RA3.RA3_FILIAL = %Exp:cRA3Branch%
       	   AND RA3.RA3_MAT = %Exp:cMat%
       	   AND RA3.RA3_CALEND = %Exp:cCalendarCode%
       	   AND RA3.RA3_CURSO = %Exp:cCourseCode%
       	   AND RA3.RA3_TURMA = %Exp:cCourseClass%
       	   AND RA3.%notDel%       		   
		EndSql
		If !(cAuxAlias3)->(Eof())
			Self:Training:ReserveType	:= (cAuxAlias3)->RA3_RESERV
		Else
			Self:Training:ReserveType 	:= ''			
		EndIf
	EndIf
	
	If Select(cAuxAlias2) > 0
		(cAuxAlias2)->(DBCloseArea())
	EndIf
	If Select(cAuxAlias3) > 0
		(cAuxAlias3)->(DBCloseArea())
	EndIf
	(cQuery)->(DBCloseArea())		
Return .T.

WSMETHOD GetDiscipline;
WSRECEIVE Branch,CourseCode;
WSSEND Discipline;
WSSERVICE RHTrainings
	Local cQuery		:= GetNextAlias()
	Local cRAMBranch	:= xFilial("RAM", Self:Branch)	
	Local cCourseCode	:= Self:CourseCode
    
	DEFAULT Self:PositionId		:= ""

	BeginSql alias cQuery
		SELECT RAM.RAM_FILIAL, RAM.RAM_DISCIP
		FROM  %table:RAM% RAM 
		WHERE 
 			RAM.RAM_FILIAL  = %Exp:cRAMBranch% 	AND
			RAM.RAM_CURSO   = %Exp:cCourseCode%	AND 
  		    RAM.%notDel%   
	EndSql

	While !(cQuery)->(Eof())
		dbSelectArea("JAE")
		dbSetOrder(1)
		If dbSeek((cQuery)->RAM_FILIAL+(cQuery)->RAM_DISCIP)
			oItem:= WSClassNew("DataDisciplines")
			oItem:DisCode		:= JAE->JAE_CODIGO
			oItem:DisDescrip	:= AllTrim(JAE->JAE_DESC)
			oItem:DisSummary	:= APDMSMM(JAE->JAE_MEMO4,,,,3)
			oItem:DisWorkload	:= JAE->JAE_CARGA
			AAdd(Self:Discipline:ListOfDisciplines, oItem)
		Endif
	
		(cQuery)->(DBSkip())
    Enddo

Return .T.

WSMETHOD GetMapTrainings WSRECEIVE Branch,Registration,PositionId WSSEND MapTraining WSSERVICE RHTrainings
	Local cAlias, cAlias1
	Local cFilTerminal	:= Self:Branch
	Local cMatTerminal	:= Self:Registration
	Local cDepart  		:= ::PositionId
	Local lRet			:= .T.	
	Local aArea			:= GetArea()
	Local cFiltro		:= " RA5_CARGO = '"+ cDepart +"'"
	Local cFiltro1		:= " RA4.RA4_MAT = '" + cMatTerminal + "' AND RA4.RA4_FILIAL = '" + cFilTerminal + "'"
	Local nX			:= 0
	Local nTam			:= 0
	Local lOk			:= .F.
	Local cFilValue  	:= Iif( VerModAc('RA5') == "C" ,xFilial("RA5", Self:Branch), cFilTerminal)
	
	cFiltro 	:= "% " + cFiltro + " %"
	cFiltro1	:= "% " + cFiltro1 + " %"
	
	cAlias	:= GetNextAlias()
	//Apenas para caso nao haja a tabela fisicamente  
	DBSelectArea("RA1")  
	DBSelectArea("RA4")  
	DBSelectArea("RA5")	
		
	BeginSql alias cAlias
		  SELECT RA5.RA5_CURSO
               , RA1.RA1_DESC
            FROM %table:RA5% RA5
      INNER JOIN %table:RA1% RA1
              ON RA1.RA1_CURSO = RA5_CURSO
	       WHERE %exp:cFiltro% AND RA5.RA5_FILIAL  = %Exp:cFilValue%
	         AND RA5.%notDel% 
	         AND RA1.%notDel%	         
        ORDER BY RA5.RA5_CURSO  
	EndSql
	
	While (cAlias)->( !Eof())		 
		nX += 1
		AAdd(Self:MapTraining:Itens, WSClassNew("DataCourses"))		
		Self:MapTraining:Itens[nX]:CourseCode			:= (cAlias)->RA5_CURSO
		Self:MapTraining:Itens[nX]:CourseDescription	:= (cAlias)->RA1_DESC
		Self:MapTraining:Itens[nX]:CourseRequired		:= .T.
		Self:MapTraining:Itens[nX]:CourseHeld			:= .F.
		(cAlias)->( dbSkip() )
	EndDo
	
	cAlias1	:= GetNextAlias()
	nTam	:= Len(Self:MapTraining:Itens)
	
	BeginSql alias cAlias1
		  SELECT RA4.RA4_CURSO
               , RA1.RA1_DESC
            FROM %table:RA4% RA4
      INNER JOIN %table:RA1% RA1
              ON RA1.RA1_CURSO = RA4_CURSO
           WHERE %exp:cFiltro1%            
	         AND RA4.%notDel% 
	         AND RA1.%notDel%	         
        ORDER BY RA4.RA4_CURSO  
	EndSql 
	
	
	While (cAlias1)->( !Eof())
		lOk	:= .F.
		For nX := 1 To nTam
			If (cAlias1)->RA4_CURSO == Self:MapTraining:Itens[nX]:CourseCode				
				Self:MapTraining:Itens[nX]:CourseHeld			:= .T.
				lOk	:= .T.
			EndIf 
		Next nI
		If !lOk
			nTam1	:= Len(Self:MapTraining:Itens)
			AAdd(Self:MapTraining:Itens, WSClassNew("DataCourses"))		
			Self:MapTraining:Itens[nTam1+1]:CourseCode			:= (cAlias1)->RA4_CURSO
			Self:MapTraining:Itens[nTam1+1]:CourseDescription		:= (cAlias1)->RA1_DESC
			Self:MapTraining:Itens[nTam1+1]:CourseRequired		:= .F.
			Self:MapTraining:Itens[nTam1+1]:CourseHeld			:= .T.
		EndIf
		(cAlias1)->( dbSkip() )
	EndDo
		
	RestArea(aArea) 
Return lRet

WSMETHOD GetDepartMapTrainings WSRECEIVE EmployeesData WSSEND ListOfPosition WSSERVICE RHTrainings
	Local cAlias, cAlias1	
	Local cFiltro, cFiltro1
	Local nI, nX, nY
	Local lRet			:= .T.
	Local nTam			:= 0
	Local nTamCursos	:= 0
	Local nTamEmpleg	:= 0		
	Local aArea			:= GetArea()
	Local nTamParam		:= Len(EmployeesData:ListOfEmployee)
	
	For nI := 1 To nTamParam
		lOk		:= .T.
		If Empty(Self:ListOfPosition)
			AAdd(Self:ListOfPosition, WSClassNew("DataPosition"))
			Self:ListOfPosition[nI]:PositionId		:= EmployeesData:ListOfEmployee[nI]:PositionId
			Self:ListOfPosition[nI]:DescrPosition	:= fDesc('SQ3', EmployeesData:ListOfEmployee[nI]:PositionId, 'Q3_DESCSUM')				
			Self:ListOfPosition[nI]:ListOfCourses	:= {}
			
			cFiltro	:= " RA5_CARGO = '"+ EmployeesData:ListOfEmployee[nI]:PositionId +"'"
			cFiltro 	:= "% " + cFiltro + " %"
	
			cAlias	:= GetNextAlias()  
				
			BeginSql alias cAlias
				  SELECT RA5.RA5_CURSO
		               , RA1.RA1_DESC
		            FROM %table:RA5% RA5
		      INNER JOIN %table:RA1% RA1
		              ON RA1.RA1_CURSO = RA5_CURSO
			       WHERE %exp:cFiltro% 
			         AND RA5.%notDel% 
			         AND RA1.%notDel%	         
		        ORDER BY RA5.RA5_CURSO  
			EndSql 
			
			nX	:= 0
			
			While (cAlias)->( !Eof())		 
				nX += 1
				AAdd(Self:ListOfPosition[nI]:ListOfCourses, WSClassNew("DataCourses"))		
				Self:ListOfPosition[nI]:ListOfCourses[nX]:CourseCode			:= (cAlias)->RA5_CURSO
				Self:ListOfPosition[nI]:ListOfCourses[nX]:CourseDescription	:= (cAlias)->RA1_DESC
				Self:ListOfPosition[nI]:ListOfCourses[nX]:CourseRequired	:= .T.
				Self:ListOfPosition[nI]:ListOfCourses[nX]:CourseHeld			:= .F.
				Self:ListOfPosition[nI]:ListOfCourses[nX]:ListOfEmployee	:= {}
				(cAlias)->( dbSkip() )
			EndDo
		Else
			nTam	:= Len(Self:ListOfPosition)
			
			//Procura se o cargo ja foi cadastrado
			For nX := 1 To nTam
				If Self:ListOfPosition[nX]:PositionId == EmployeesData:ListOfEmployee[nI]:PositionId
					lOk	:= .F.
				EndIf
			Next nX
						
			If lOk	//Incluir novo cargo
		    	AAdd(Self:ListOfPosition, WSClassNew("DataPosition"))
				Self:ListOfPosition[nTam+1]:PositionId		:= EmployeesData:ListOfEmployee[nI]:PositionId
				Self:ListOfPosition[nTam+1]:DescrPosition	:= fDesc('SQ3', EmployeesData:ListOfEmployee[nI]:PositionId, 'Q3_DESCSUM')	
				Self:ListOfPosition[nTam+1]:ListOfCourses	:= {}
				
				cFiltro		:= " RA5_CARGO = '"+ EmployeesData:ListOfEmployee[nI]:PositionId +"'"
				cFiltro 	:= "% " + cFiltro + " %"
		
				cAlias	:= GetNextAlias()  
					
				BeginSql alias cAlias
					  SELECT RA5.RA5_CURSO
			               , RA1.RA1_DESC
			            FROM %table:RA5% RA5
			      INNER JOIN %table:RA1% RA1
			              ON RA1.RA1_CURSO = RA5_CURSO
				       WHERE %exp:cFiltro% 
				         AND RA5.%notDel% 
				         AND RA1.%notDel%	         
			        ORDER BY RA5.RA5_CURSO  
				EndSql
				
				nX	:= 0
				
				While (cAlias)->( !Eof())		 
					nX += 1
					AAdd(Self:ListOfPosition[nTam+1]:ListOfCourses, WSClassNew("DataCourses"))		
					Self:ListOfPosition[nTam+1]:ListOfCourses[nX]:CourseCode			:= (cAlias)->RA5_CURSO
					Self:ListOfPosition[nTam+1]:ListOfCourses[nX]:CourseDescription		:= (cAlias)->RA1_DESC
					Self:ListOfPosition[nTam+1]:ListOfCourses[nX]:CourseRequired		:= .T.
					Self:ListOfPosition[nTam+1]:ListOfCourses[nX]:CourseHeld			:= .F.
					Self:ListOfPosition[nTam+1]:ListOfCourses[nX]:ListOfEmployee		:= {}
					(cAlias)->( dbSkip() )
				EndDo				
			EndIf
		EndIf
		
		//Apenas permite novas inclusoes de funcionarios, quando e uma inclusao de um novo cargo 
		If lOk
			For nX := 1 To nTamParam
				
				If EmployeesData:ListOfEmployee[nX]:PositionId == Self:ListOfPosition[nTam+1]:PositionId 
				    nTamCursos	:= Len(Self:ListOfPosition[nTam+1]:ListOfCourses)
					
					For nY := 1 To nTamCursos
						
						nTamEmpleg	:= Len(Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee) + 1
						
						aAdd(Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee, WSClassNew("DataCoursesEmployee"))
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:Branch			:= EmployeesData:ListOfEmployee[nX]:Branch
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:CourseHeld		:= .F.
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:PositionId		:= EmployeesData:ListOfEmployee[nX]:PositionId 
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:Registration		:= EmployeesData:ListOfEmployee[nX]:Registration						
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:DescrDepartment	:= EmployeesData:ListOfEmployee[nX]:DescrDepartment
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:DescSituacao		:= EmployeesData:ListOfEmployee[nX]:DescSituacao
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:AdmissionDate		:= EmployeesData:ListOfEmployee[nX]:AdmissionDate
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:Indice			:= EmployeesData:ListOfEmployee[nX]:Indice
						Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:Name				:= EmployeesData:ListOfEmployee[nX]:Name
											
						cFiltro1	:= " RA4.RA4_MAT = '" + EmployeesData:ListOfEmployee[nX]:Registration 
						cFiltro1	+= "' AND RA4.RA4_CURSO = '" + AllTrim(Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:CourseCode) 
						cFiltro1	+= "' AND RA4.RA4_FILIAL = '" + EmployeesData:ListOfEmployee[nX]:Branch + "'" 
						
						cFiltro1	:= "% " + cFiltro1 + " %"					
						
						cAlias1	:= GetNextAlias()
		
						BeginSql alias cAlias1
							  SELECT RA4.RA4_CURSO
					               , RA1.RA1_DESC
					            FROM %table:RA4% RA4
					      INNER JOIN %table:RA1% RA1
					              ON RA1.RA1_CURSO = RA4_CURSO
					           WHERE %exp:cFiltro1%            
						         AND RA4.%notDel% 
						         AND RA1.%notDel%	         
					        ORDER BY RA4.RA4_CURSO  
						EndSql 
						
						
						While (cAlias1)->( !Eof())
							Self:ListOfPosition[nTam+1]:ListOfCourses[nY]:ListOfEmployee[nTamEmpleg]:CourseHeld	:= .T.
							(cAlias1)->( dbSkip() )
						EndDo														
						
					Next nY	
				EndIf 
				 
			Next nX
		EndIf		
	Next nI
				
	RestArea(aArea)  
Return lRet

WSMETHOD OtherTrainings;
WSRECEIVE Branch,Page,Registration,FilterField,FilterValue,FilterCateg,FilterType;
WSSEND TrainingData;
WSSERVICE RHTrainings
	Local oItem
	Local nRecCount
	Local nCount
	Local cWhere    	 		:= ""
	Local dDataIni			:= dDataBase
	Local cQry	
	Local cQuery				:= GetNextAlias()
	Local cAuxAlias	 			:= GetNextAlias()	
	Local cRA2Branch			:= xFilial("RA2", Self:Branch)
	Local cRA1Branch			:= xFilial("RA1", Self:Branch)
	Local cRA3Branch			:= xFilial("RA3", Self:Branch)
	Local cFiltPE				:= ""

	DEFAULT Self:Page 			:= 1
	DEFAULT Self:FilterField	:= ""
	DEFAULT Self:FilterValue	:= ""	
	DEFAULT Self:Registration	:= ""
	DEFAULT Self:PositionId		:= ""
	DEFAULT Self:FilterCateg	:= STR0011 //"Todos"
	DEFAULT Self:FilterType		:= "3"
	
	//SuperGetMv("MV_ERPLOGI",,"2")
	If SuperGetMv( "MV_INTTREI", ,.F.)
		//Verificar Filtro
		cCampo	:= Self:FilterField
		cFiltro	:= Self:FilterValue
		cWhere 	:= "%"
		If !Empty(cFiltro) .AND. !Empty(cCampo)
		    If(cCampo == "RA1_DESC") 
		      //descricao curso
		      cWhere += " AND RA1.RA1_DESC LIKE '%" + Upper(Replace(cFiltro,"'","")) + "%'"
		    EndIf  
		EndIf
		
		If Self:FilterCateg <> STR0011 .and. RA1->(ColumnPos("RA1_CATEG")) > 0 //"Todos"
			cWhere += " AND RA1.RA1_CATEG = '" + Self:FilterCateg + "' "
		EndIf
		
		If ExistBlock("TR10FILT") 
			cFiltPE := ExecBlock( "TR10FILT", .F., .F.)
			If ValType(cFiltPE) == "C"
				cWhere += cFiltPE 
			EndIf
        EndIf
		
		cWhere += "%"
		
		Self:TrainingData:ListOfTrainings := {}
		BEGINSQL ALIAS cQuery
			SELECT RA1.RA1_FILIAL
			     , RA1.RA1_CURSO
			     , RA1.RA1_DESC
			     , RA1.RA1_DURACA
			     , RA1.RA1_UNDURA
			     , RA1.RA1_QTDMIN
    		  FROM %Table:RA1% RA1	
            WHERE RA1.RA1_CURSO NOT IN (SELECT RA2_CURSO 
                                      FROM %Table:RA2% RA2 
                                     WHERE RA2.RA2_FILIAL  = %Exp:cRA2Branch% 
                                       AND RA2_DATAIN >= %Exp:dDataIni%
                                       AND RA2.%NotDel%)                                       
            		%exp:cWhere%
				AND RA1.%NotDel%
	     ORDER BY  RA1.RA1_DESC			
		ENDSQL	
		
		COUNT TO nRecCount
		DBGoTop()
	
		::TrainingData:ParameterMVINTTREI	:= .T.  //Se o parametro estiver .T. ou seja deve ser apresentado a tela					  
		If Self:Page > 1
			DBSkip((Self:Page-1) * PAGE_LENGTH)
		EndIf
		nRecCount := 0
		While !(cQuery)->(Eof())
			oItem:= WSClassNew("DataTrainings")
			oItem:Branch					:= (cQuery)->RA1_FILIAL
			oItem:CalendarCode				:= ''
			oItem:CalendarDescription		:= AllTrim((cQuery)->RA1_DESC)
			oItem:CourseCode				:= (cQuery)->RA1_CURSO 
			oItem:CourseClass				:= '' 
			oItem:CourseDescription			:= AllTrim((cQuery)->RA1_DESC)				
			oItem:InitialDate				:= ddatabase
			oItem:EndingDate				:= ddatabase
			oItem:Time						:= ''
			oItem:Duration					:= AllTrim(AllTrim(Str((cQuery)->RA1_DURACA)) + " " + AllTrim(fDesc("SX5", "R5" + (cQuery)->RA1_UNDURA, "X5DESCRI()", NIL, Self:Branch, NIL, .F.)))
			oItem:TotalPlaces				:= 0//(cQuery)->RA2_VAGAS
			oItem:ReservedPlaces			:= 0
			oItem:HasRequest				:= .F.
			oItem:CodeInstructor			:= ''
			oItem:DescInstructor 		  	:= ''
			If !Empty((cQuery)->RA1_QTDMIN)
				oItem:MinimumQuantity		:= (cQuery)->RA1_QTDMIN
			Else
				oItem:MinimumQuantity		:= "0"
			EndIf	
			
			cQry	:= GetNextAlias()
			BEGINSQL ALIAS cQry
			
				SELECT COUNT(*) nCount
				FROM %Table:RA3% RA3 
				WHERE RA3.RA3_FILIAL = %Exp:cRA3Branch%
				   AND RA3.RA3_CURSO = %Exp:(cQuery)->RA1_CURSO%
				   AND RA3.RA3_TURMA = %Exp:''% 
				   AND RA3.RA3_CALEND = %Exp:''%
				   AND RA3.%NotDel%			
			ENDSQL	
			
			oItem:QuantityInterested		:= (cQry)->nCount
			(cQry)->(DBCloseArea())
			
			cQry	:= GetNextAlias()
			BEGINSQL ALIAS cQry
			
				SELECT RA3.RA3_CURSO
				  FROM %Table:RA3% RA3
				 WHERE RA3.RA3_FILIAL = %Exp:cRA3Branch%
				   AND RA3.RA3_CURSO = %Exp:(cQuery)->RA1_CURSO%
				   AND RA3.RA3_MAT = %Exp:Self:Registration%
				   AND RA3.RA3_TURMA = %Exp:''% 
				   AND RA3.RA3_CALEND = %Exp:''%
				   AND RA3.%NotDel%			
			ENDSQL	
			
			//"0 = Não", "1 = Sim (Sim e não será tratado na apresentação, pois preciso da informação padronizada para tratar o excluir.""
			oItem:Requested		:= If( Empty((cQry)->RA3_CURSO) , "0", "1")
			
			//Diferente de todos
			If Self:FilterType == "1" .and. oItem:Requested == "0"
				(cQry)->(DBCloseArea())
				(cQuery)->(DBSkip())
				Loop
			ElseIf Self:FilterType == "2" .and. oItem:Requested == "1"
				(cQry)->(DBCloseArea())
				(cQuery)->(DBSkip())
				Loop
			EndIf
			
			nRecCount++			
			
			(cQry)->(DBCloseArea())
			
			If Len(Self:TrainingData:ListOfTrainings) < PAGE_LENGTH
				AAdd(Self:TrainingData:ListOfTrainings, oItem)
			EndIf
			
			(cQuery)->(DBSkip())
		EndDo
		::TrainingData:PagesTotal := Ceiling(nRecCount / PAGE_LENGTH)
		(cQuery)->(DBCloseArea())
	Else
		::TrainingData:ParameterMVINTTREI	:= .F. //Se o parametro estiver .F. ou seja não deve ser apresentado a tela
	EndIf		
Return .T.

WSMETHOD GetOutherTraining;
WSRECEIVE Branch,Registration,CourseCode;
WSSEND Training;
WSSERVICE RHTrainings
	Local cQuery			:= GetNextAlias()
	Local cRA1Branch		:= xFilial("RA1", Self:Branch)
	Local cCourseCode		:= Self:CourseCode	
	
	DEFAULT Self:PositionId		:= ""
	
	BEGINSQL ALIAS cQuery
			SELECT RA1.RA1_FILIAL
			     , RA1.RA1_CURSO
			     , RA1.RA1_DESC
			     , RA1.RA1_DURACA
			     , RA1.RA1_UNDURA
			     , RA1.RA1_QTDMIN
    		  FROM %Table:RA1% RA1	
             WHERE RA1.RA1_CURSO = %Exp:cCourseCode%                                       
               AND RA1.RA1_FILIAL = %Exp:cRA1Branch%
			   AND RA1.%NotDel%
	     ORDER BY  RA1.RA1_DESC			
	ENDSQL
					
						  
	If !Eof()
		Self:Training:= WSClassNew("DataTrainings")
		Self:Training:HasRequest:= .F.
		
		Self:Training:Branch				:= (cQuery)->RA1_FILIAL
		Self:Training:CalendarCode			:= ''
		Self:Training:CalendarDescription	:= AllTrim((cQuery)->RA1_DESC)
		Self:Training:CourseCode			:= (cQuery)->RA1_CURSO 
		Self:Training:CourseClass			:= '' 
		Self:Training:CourseDescription		:= AllTrim((cQuery)->RA1_DESC)						
		Self:Training:InitialDate			:= ddatabase
		Self:Training:EndingDate			:= ddatabase
		Self:Training:Time					:= ''
		Self:Training:Duration				:= AllTrim(AllTrim(Str((cQuery)->RA1_DURACA)) + " " + AllTrim(fDesc("SX5", "R5" + (cQuery)->RA1_UNDURA, "X5DESCRI()", NIL, Self:Branch, NIL, .F.)))
		Self:Training:TotalPlaces			:= 0
		Self:Training:ReservedPlaces		:= 0
		Self:Training:CodeInstructor		:= ''
		Self:Training:DescInstructor 		:= ''
		If !Empty((cQuery)->RA1_QTDMIN)			
			Self:Training:MinimumQuantity	:= (cQuery)->RA1_QTDMIN
		Else			
			Self:Training:MinimumQuantity	:= "0"
		EndIf	
		
	EndIf

	(cQuery)->(DBCloseArea())		
Return .T.

Static Function VerModAc(cTable)
Return ( FwModeAccess(cTable) )