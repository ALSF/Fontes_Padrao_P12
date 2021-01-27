#INCLUDE "WSGPE110.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WSGPE110  ³ Autor ³ Emerson Campos		³ Data ³ 23/04/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Web Service responsavel pela Solic Subsídio acadêmico        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RH/Portais                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Responsavel  ³ Data   ³Tarefa³  Motivo da Alteracao                     ³±± 
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da Estrutura dos campos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSTRUCT AcademicGrantFields
	WSDATA benefitCode						AS String				      			//Código do beneficio (RIS_CODE - Char - 2)
	WSDATA benefitName						AS String	      						//Nome do Benfício (RIS_DESC - Char - 20)
	WSDATA salaryTo							AS Float								//Salário até	
ENDWSSTRUCT                            

WSSTRUCT AcademicGrantList
	WSDATA itens								AS Array Of AcademicGrantFields		//Lista dos subsídios acadêmicos
	WSDATA curseName							AS String								//Nome do Curso
	WSDATA instituteName						AS String								//Nome da instituição
	WSDATA contact							AS String								//Contato na intituição
	WSDATA phone								AS String								//Telefone do contato
	WSDATA startDate							AS String								//Data de inicio do curso
	WSDATA endDate							AS String								//Data do fim do curso
	WSDATA monthlyPayment					AS String								//Valor da mensalidade
	WSDATA installmentAmount					AS String								//Qtde. total de parcelas
	WSDATA observation						AS String								//Obesrvação
ENDWSSTRUCT                            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Web Service de Subsidio Academico       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSSERVICE  RHAcademicGrant	DESCRIPTION STR0001				 					//Subsidio Academico
	WSDATA EmployeeFil 		 				AS String			        			//Filial do funcionario
	WSDATA Registration		 				AS String			        			//Matricula do funcionario

	WSDATA AcademicGrant	 					AS AcademicGrantList					//Lista de subsídios acadêmicos
	
	WSMETHOD GetListAcademicGrant			DESCRIPTION STR0002 					//Metodo que retorna a lista de subsídios acadêmicos disponíveis para serem solicitados	
ENDWSSERVICE                                                                                                     

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Metodo    ³GetRegEmployee ³ Autor ³Marcelo Faria	      ³Data ³28.03.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Metodo que retorna os campos do SRA, baseado na tabela RHW  	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGATCF/Portal RH                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
WSMETHOD GetListAcademicGrant WSRECEIVE EmployeeFil WSSEND AcademicGrant WSSERVICE RHAcademicGrant
Local cFilFun		:= ::EmployeeFil
Local lRet 		:= .T.
Local oItem
Local cQuery			:= GetNextAlias()

BeginSql alias cQuery
        SELECT R.RIS_COD
                  , R.RIS_DESC 
                  , R.RIS_SALATE
          FROM %table:RIS% R 
     WHERE (R.RIS_FILIAL = %exp:''% OR R.RIS_FILIAL = %exp:cFilFun%) 
       AND R.RIS_TPBENE = %exp:'83'%
       AND R.%notDel%    


EndSql 
                                          
If (cQuery)->(Eof())
	SetSoapFault(STR0001, STR0003)//"Subsidio Academico"   #   "Não há subsídios acadêmicos cadastrado ou disponíveis."
	lRet :=  .F.
Else
	Self:AcademicGrant						:= WSClassNew("AcademicGrantList")
	Self:AcademicGrant:itens 				:= {}
	Self:AcademicGrant:curseName 			:= ''
	Self:AcademicGrant:instituteName 		:= ''
	Self:AcademicGrant:contact 				:= ''
	Self:AcademicGrant:phone 				:= ''
	Self:AcademicGrant:startDate 			:= ''
	Self:AcademicGrant:endDate 				:= ''
	Self:AcademicGrant:monthlyPayment 		:= ''
	Self:AcademicGrant:installmentAmount 	:= ''
	Self:AcademicGrant:observation 			:= ''
	
	While (cQuery)->(!Eof())	
		oItem:= WSClassNew("AcademicGrantFields")
		oItem:benefitCode			:= (cQuery)->RIS_COD
		oItem:benefitName			:= (cQuery)->RIS_DESC		
		oItem:salaryTo			:= (cQuery)->RIS_SALATE
		AAdd(Self:AcademicGrant:itens, oItem)
		(cQuery)->( dbSkip() )
	EndDo
EndIf	
Return lRet