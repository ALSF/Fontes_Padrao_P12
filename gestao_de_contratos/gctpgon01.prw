#INCLUDE "GCTPgOn01.ch"
#INCLUDE "protheus.ch"
#INCLUDE "msgraphi.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GCTPgOn01³ Autor ³ Marcos V. Ferreira    ³ Data ³ 14/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta array para Painel de Gestao On-line Tipo 2           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GCTPgOn01()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³{{cCombo1,{cText1, cValor, nColorValor, bClick},{...},},    ³±±
±±³          ³{cCombo2, {cText2, cValor, nColorValor, bClick},...}}       ³±±
±±³          ³                                                            ³±±
±±³          ³cCombo1 = Item da Selecao                                   ³±±
±±³          ³cText1 = Texto da Coluna                                    ³±±
±±³          ³cValor = Valor a ser exibido (string) ja com a picture aplic³±±
±±³          ³nColorValor = Cor do Valor no Formato RGB (Opcional)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAGCT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function  GCTPgOn01()

Local aRet       := {}
Local cAtivos    := GetNextAlias()	
Local cInativos  := GetNextAlias()	
Local cEncerrado := GetNextAlias()	
Local cTexto01   := STR0001 //"Ativos"
Local cTexto02   := STR0002 //"Inativos"
Local cTexto03   := STR0003 //"Encerrados"
Local cPerg      := 'GCTPGON01'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Contrato de                           ³
//³ mv_par02            // Contrato ate                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Converte os parametros do tipo range, para um range cheio,  ³
//³caso o conteudo do parametro esteja vazio                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FullRange(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ATIVOS                                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSql Alias cAtivos

	SELECT COUNT(*) ATIVOS
	
	FROM %table:CN9% CN9
	
	WHERE CN9.CN9_FILIAL = %xFilial:CN9% AND 
		  CN9_SITUAC = '05' AND
		  CN9_NUMERO >= %Exp:mv_par01%	AND
		  CN9_NUMERO <= %Exp:mv_par02%	AND
   		  CN9.%NotDel%

EndSql

// Preenche array do Painel de Gestao tipo 2 - Padrao 1
Aadd( aRet, { cTexto01 , { 	{STR0004, AllTrim(StrZero((cAtivos)->ATIVOS,8)),CLR_BLUE	, /*{ || bClick }*/ } } }  )
(cAtivos)->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³INATIVOS												                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

BeginSql Alias cInativos

	SELECT COUNT(*) INATIVOS
	
	FROM %table:CN9% CN9
	
	WHERE CN9.CN9_FILIAL = %xFilial:CN9% AND 
		  CN9_SITUAC IN ('02','03','04','06','07') AND
		  CN9_NUMERO >= %Exp:mv_par01%	AND
		  CN9_NUMERO <= %Exp:mv_par02%	AND
   		  CN9.%NotDel%

EndSql

// Preenche array do Painel de Gestao tipo 2 - Padrao 1
Aadd( aRet, { cTexto02 , { 	{STR0004, AllTrim(StrZero((cInativos)->INATIVOS,8)),CLR_BLUE	, /*{ || bClick }*/ } } }  )
(cInativos)->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ENCERRADOS                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSql Alias cEncerrado

	SELECT COUNT(*) ENCERRADOS
	
	FROM %table:CN9% CN9
	
	WHERE CN9.CN9_FILIAL = %xFilial:CN9% AND 
		  CN9_SITUAC = '08' AND
		  CN9_NUMERO >= %Exp:mv_par01%	AND
		  CN9_NUMERO <= %Exp:mv_par02%	AND
   		  CN9.%NotDel%

EndSql

// Preenche array do Painel de Gestao tipo 2 - Padrao 1
Aadd( aRet, { cTexto03 , { 	{STR0004, AllTrim(StrZero((cEncerrado)->ENCERRADOS,8)),CLR_BLUE	, /*{ || bClick }*/ } } }  )
(cEncerrado)->(DbCloseArea())

Return aRet
