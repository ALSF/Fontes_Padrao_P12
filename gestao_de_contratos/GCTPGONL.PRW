#INCLUDE "GCTPGONL.ch"
#INCLUDE "protheus.ch"
#INCLUDE "PanelOnLine.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GCTPGONL ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 14/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Painel de Gestao On-line (GCT)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GCTPGOnl(ExpO1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = obj do proces.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                              		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAGCT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function GCTPGOnl(oPGOnline)

PANELONLINE oPGOnline ADDPANEL ;
	TITLE STR0001 ; //'Contratos ativos, inativos e encerrados'
	DESCR STR0001 ; //'Contratos ativos, inativos e encerrados'
	TYPE 2 ;
	PARAMETERS 'GCTPGON01' ;
	ONLOAD 'GCTPgOn01' ;
	REFRESH 100 ;
	DEFAULT 1 ;
	NAME '1' ;
	TITLECOMBO STR0003 ; //"Situacao"
	
PANELONLINE oPGOnline ADDPANEL ;
	TITLE STR0002 ; //"Contratos a encerrar (Proximos 30 dias)"
	DESCR STR0002 ; //"Contratos a encerrar (Proximos 30 dias)"
	TYPE 1 ;
	ONLOAD 'GCTPGON02' ;
	REFRESH 100 ;
	NAME '2' ;

PANELONLINE oPGOnline ADDPANEL ;
	TITLE STR0004 ; //"Valor de contratos a pagar/receber"
	DESCR STR0004 ; //"Valor de contratos a pagar/receber"
	TYPE 5 ;
	PARAMETERS 'GCTPGON03';
	ONLOAD 'GCTPGON03' ;
	REFRESH 100 ;
	NAME '3' 

Return