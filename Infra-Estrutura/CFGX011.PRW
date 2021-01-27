#include "protheus.Ch"
#include "cfgx011.ch"

Static _oCx011TRB := NIL


//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Cfgx011

Tabela de IRRF 	

@param lWizard 			indica a execução através de Wizard
@param oWizard 			objeto de Wizard
@param aArray			array contendo a tabela de IRRF
@param lEdit			permite a edição
@param oBtnWiz			objeto botões do wizard
@param oSayWiz			objeto de mensagem do wizard

@Author	Mauricio Pequim Jr
@since	10/07/2018
/*/
//-----------------------------------------------------------------------------------------------------
FuncTion Cfgx011(lWizard, oWizard, aArray, lEdit, oBtnWiz, oSayWiz)

Local oDlg		:= NIL
Local oLbx		:= NIL
Local cVar		:=""
Local nOpc 		:= 0
Local aCampos	:= {}
Local cArqTmp	:= ""
Local nX 		:= 0
Local nY 		:= 0           
Local nDiffWiz	:= 0

DEFAULT lWizard := .F.
DEFAULT aArray	:= {}                            
DEFAULT lEdit	:= .F.                                                              

aCampos := IRFStruArq()

If _oCx011TRB <> Nil
	_oCx011TRB:Delete()
	_oCx011TRB := Nil
Endif
// Criação da Tabela Temporaria
_oCx011TRB := FWTemporaryTable():New( "cArqTmp" )
_oCx011TRB:SetFields(aCampos)
_oCx011TRB:AddIndex("1", {"LIMITE"})
_oCx011TRB:Create()

//-------------------------------------------------
// Importa" o arquivo TXT com a tabela do I.R.
//-------------------------------------------------
dbSelectArea( "cArqTmp" )
If File( "SIGAADV.IRF" )
	APPEND FROM SIGAADV.IRF SDF            
	nX := cArqTmp->(RecCount())
	If nX < 5
		For nY := nX+1 to 5
			RecLock( "cArqTmp" , .T. )
		Next
   Endif
Else        
	For nX := 1 to 5
		RecLock( "cArqTmp" , .T. )
		MsUnlock()
	Next
Endif        
cArqTmp->(dbGoTop())

If lWizard
	While !Eof()
		Aadd(aArray, {LIMITE, ALIQUOTA, DEDUZIR})
		DbSkip()
	End
	DbGoTop()
	nDiffWiz := 10
EndIf
                      
If !lWizard
	DEFINE MSDIALOG oDlg FROM  70,1 TO 231,400 TITLE STR0001 PIXEL  // "Tabela do Imposto de Renda"
	
	@ 5,5 LISTBOX oLbx  Var cVar FIELDS LIMITE, ALIQUOTA, DEDUZIR;
	HEADER STR0002, STR0003, STR0004 ;  // "Valor Limite"  ### "Al¡quota" ### "Valor a Deduzir"
	SIZE (oDlg:nClientWidth / 2)- 38 - nDiffWiz,(oDlg:nClientHeight / 2) - 20 OF oDlg PIXEL  ;
	ON DBLCLICK Edita( oLbx , lWizard )
	
	DEFINE SBUTTON FROM 3,(oDlg:nRight / 2) - 33 TYPE 1 ENABLE OF oDlg Action (nOpc:=1,oDlg:End())
	DEFINE SBUTTON FROM 18,(oDlg:nRight / 2) - 33 TYPE 2 ENABLE OF oDlg Action (nOpc:=0,oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 1
		Copy to SIGAADV.IRF SDF
	ENdif
	
Else
	@ 5,5 LISTBOX oLbx FIELDS HEADER STR0002, STR0003, STR0004 ;
		SIZE (oWizard:nClientWidth / 2)- 38 - nDiffWiz,(oWizard:nClientHeight / 2) - 10 PIXEL OF oWizard ;
		ON DBLCLICK Edita( oLbx , lWizard, aArray, @lEdit )
	oLbx:SetArray(aArray)
	oLbx:bLine := { || {aArray[oLbx:nAt,1], aArray[oLbx:nAt,2], aArray[oLbx:nAt,3] }}
EndIf

If _oCx011TRB <> Nil
	_oCx011TRB:Delete()
	_oCx011TRB := Nil
Endif

Return nil


//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} EDITA

Edição da linha da Tabela de IRRF 	

@param oLbx 			Objeto da Listbox (Wizard)
@param lWizard 			indica o uso de Wizard
@param oWizard 			objeto de Wizard
@param aArray			array contendo a tabela de IRRF
@param lEdit			permite a edição
@param oBtnWiz			objeto botões do wizard
@param oSayWiz			objeto de mensagem do wizard

@Author	Mauricio Pequim Jr
@since	10/07/2018
/*/
//-----------------------------------------------------------------------------------------------------

Static Function EDITA( oLbx, lWizard, aArray, lEdit, oBtnWiz, oSayWiz )

Local oDlg		:= NIL
Local nLimIRF	:= 0
Local nAliquota	:= 0
Local nDeduzir	:= 0
Local nOpc		:= 0

If !lWizard
	nLimIRF		:= Val( Field->Limite )
	nAliquota	:= Val( Field->Aliquota )
	nDeduzir	:= Val( Field->deduzir )
Else
	nLimIRF		:= Val( aArray[oLbx:nAt][1] )
	nAliquota	:= Val( aArray[oLbx:nAt][2] )
	nDeduzir	:= Val( aArray[oLbx:nAt][3] )
EndIf	
                                               	
DEFINE MSDIALOG oDlg FROM  86,1 TO 260,315 TITLE STR0005 PIXEL  // "Edição da Faixa de Imposto"

@ 07, 04 TO 62, 154 LABEL STR0006 OF oDlg  PIXEL  // "Faixa de Imposto"
@ 16, 08 SAY STR0007		SIZE 53, 07 OF oDlg PIXEL  // "Valor Limite"
@ 29, 08 SAY STR0008		SIZE 53, 07 OF oDlg PIXEL  // "Alíquota"
@ 42, 08 SAY STR0009  		SIZE 53, 07 OF oDlg PIXEL  // "Valor a Deduzir"
@ 14, 68 MSGET nLimIRF		SIZE 71, 10 OF oDlg PIXEL Picture "@E 999,999,999.99" 	HASBUTTON
@ 27, 68 MSGET nAliquota	SIZE 71, 10 OF oDlg PIXEL Picture "@R 999.99%"			HASBUTTON
@ 40, 68 MSGET nDeduzir		SIZE 71, 10 OF oDlg PIXEL Picture "@E 999,999,999.99"	HASBUTTON

DEFINE SBUTTON FROM 70, (oDlg:nRight / 2) - 63 TYPE 1 ENABLE OF oDlg Action (nOpc:=1,oDlg:End())
DEFINE SBUTTON FROM 70, (oDlg:nRight / 2) - 33 TYPE 2 ENABLE OF oDlg Action (nOpc:=0,oDlg:End())

IF !lWizard
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf 
                                                                                                         
If nOpc == 1
	IF !lWizard
	   RecLock( "cArqTmp" )
	   Field->LIMITE   := Spac( 15 - Len( Alltrim(Str( nLimIRF,15,2) ) )) + Alltrim(Str(nLimIRF,15,2))
	   Field->ALIQUOTA := Spac(  7 - Len( Alltrim(Str( nAliquota,5,2) ))) + Alltrim(Str(nAliquota,5,2)) 
	   Field->DEDUZIR  := Spac( 16 - Len( Alltrim( Str( nDeduzir,16,2)))) + Alltrim(Str(nDeduzir,16,2))
	   oLbx:Refresh()
	Else                                           
		lEdit := .T.                             
		                                    
		aArray[oLbx:nAt] := {Spac( 15 - Len( Alltrim(Str( nLimIRF,15,2) ) )) + Alltrim(Str(nLimIRF,15,2)),;
							Spac(  7 - Len( Alltrim(Str( nAliquota,5,2) ))) + Alltrim(Str(nAliquota,5,2)),;		
							Spac( 16 - Len( Alltrim( Str( nDeduzir,16,2)))) + Alltrim(Str(nDeduzir,16,2))}
		
		oLbx:SetArray(aArray)									                     
		oLbx:bLine := { || {aArray[oLbx:nAt,1], aArray[oLbx:nAt,2], aArray[oLbx:nAt,3] }}

		oLbx:Refresh()
		
		If oWiz3Btn12:cResName != "SALVAR"
			oWiz3Btn12:SetEmpty()
			oWiz3Btn12:SetBMP("SALVAR")
			oWiz3Say12:SetText("Salvar")               
		EndIf

	EndIF
Endif

Return Nil


//-----------------------------------------------------------------------------------------------------
/*/{Protheus.doc} EDITA

Estrutura do TRB utilizado para edição da Tabela de IRRF 	


@Author	Mauricio Pequim Jr
@since	10/07/2018
/*/
//-----------------------------------------------------------------------------------------------------

Function IRFStruArq()

Local aRet
           
aRet := { {"LIMITE"     , "C" , 15,0},;
          {"ALIQUOTA"   , "C" , 07,0},;
          {"DEDUZIR"    , "C" , 16,0} }

Return aRet
