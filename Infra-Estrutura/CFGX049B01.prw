#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "CFGX049B.CH"

Static __nVlrFor	:= 0
Static __nRetoLbx	:= 0
Static __oBrwCNAB	:= Nil
Static __oFwBrw		:= Nil
Static __oTPanel	:= Nil

//---------------------------------------------------------------------------------------
/*/ {Protheus.doc} CFGX049B01()
Consulta cliente Totvs ativo

@Project	CNAB - Padronizado
@author	Francisco Oliveira
@since		10/08/2017
@version	P12
@Return	Logico com o resultado da integração
@param
@Obs
/*/
//---------------------------------------------------------------------------------------
Function CFGX049B01(aDdsEdit, oPanel,nCtrlFor, nLenEdi)
	
	Local nX		As Numeric
	Local oPnlAux	As Object
	Local aStruct	As Array
	Local aColumns	As Array
	Local cBanco	As Character
	Local cModulo	As Character
	Local cTipo		As Character

	Private cEditCel	As Character
	
	Default aDdsEdit	:= {}
	Default nCtrlFor	:= 0

	nX			:= 1
	oPnlAux		:= Nil
	aStruct		:= {}
	aColumns	:= {}
	cBanco		:= ""
	cModulo		:= ""
	cTipo		:= ""
	cEditCel	:= ""
	
	If oPanel != Nil
		__oFwBrw	:= oPanel
		__oTPanel	:= oPanel
	Endif
	
	If Len(aDdsEdit) < __nVlrFor
		Return .T.
	Endif
	
	If Len(aDdsEdit) <= 0
		CFGX049B06(aDdsEdit, nCtrlFor, oPanel, nLenEdi)
		Return .F.
	ElseIf Len(aDdsEdit) <= 0 .And. nCtrlFor = nLenEdi
		CFGX049B06(aDdsEdit, nCtrlFor, oPanel, nLenEdi)
		Return .T.
	ElseIf Len(aDdsEdit) <= 0 .And. nCtrlFor > nLenEdi
		CFGX049B06(aDdsEdit, nCtrlFor, oPanel, nLenEdi)
		Return .T.
	Endif
	
	If nCtrlFor > 1
		__oBrwCNAB:DeActivate(.T.)
		__oBrwCNAB:Destroy()
		__oBrwCNAB	:= Nil
	Endif
	
	If nCtrlFor > nLenEdi
		Return .T.
	Endif
	
	cBanco	:= Posicione("SA6", 1, xFilial("SA6") + aDdsEdit[1,01], "A6_NREDUZ" )
	cModulo	:= Iif(aDdsEdit[1,09] == "PAG", "Contas a Pagar", "Contas a Receber")
	cTipo	:= Iif(aDdsEdit[1,10] == "REM", "Remessa", "Retorno")
	
	aColumns := {}
	
	aADD( aStruct, { "BANCO" , "C", 005, 0 } )
	aADD( aStruct, { "PAGREC", "C", 001, 0 } )
	aADD( aStruct, { "REMRET", "C", 001, 0 } )
	aADD( aStruct, { "DESMOV", "C", 015, 0 } )
	aADD( aStruct, { "POSINI", "C", 001, 0 } )
	aADD( aStruct, { "POSFIN", "C", 001, 0 } )
	aADD( aStruct, { "DESLIN", "C", 020, 0 } )
	aADD( aStruct, { "VLRNEW", "C", 020, 0 } )
	aADD( aStruct, { "CONLIN", "C", 050, 0 } )
	
	__oBrwCNAB := Nil
	
	__oBrwCNAB := FwBrowse():New(__oFwBrw)
	__oBrwCNAB:SetDataArray()
	__oBrwCNAB:SetDescription(OemToAnsi(STR0054)) // "Edição de Arquivos CNAB"
	__oBrwCNAB:SetArray(aDdsEdit)
	
	For nX := 1 To Len(aStruct)
		If	aStruct[nX][1] == "POSINI"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[__oBrwCNAB:nAt][2] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("POS. INICIAL")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "POSFIN"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[__oBrwCNAB:nAt][3] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("POS. FINAL")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "DESMOV"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[__oBrwCNAB:nAt][06] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("MOVIMENTO")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "DESLIN"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[__oBrwCNAB:nAt][13] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("DESC. LINHA")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "CONLIN"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[__oBrwCNAB:nAt][14] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("CONTEUDO PADRÃO")
			aColumns[Len(aColumns)]:SetPicture("@!")
		ElseIf	aStruct[nX][1] == "VLRNEW"
			cEditCel	:= "VLRNEW"
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( {|| aDdsEdit[__oBrwCNAB:nAt][05] } )
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetTitle("NOVO VALOR")
			aColumns[Len(aColumns)]:SetPicture("@!")
			aColumns[Len(aColumns)]:SetEdit(.T.)
			aColumns[Len(aColumns)]:SetReadVar( cEditCel )
			aColumns[Len(aColumns)]:SetF3( {|| VlrNew := ConNewVlr(aDdsEdit[__oBrwCNAB:nAt][12])} )
		EndIf
	Next nX
	
	__oBrwCNAB:SetColumns(aColumns)
	__oBrwCNAB:SetEditCell(.T., {|A,B,C,D,E| VALDIGIT(A,B,C,D,E)})
	
	__oBrwCNAB:DeActivate
	__oBrwCNAB:Activate()
	
	__oBrwCNAB:Refresh()
	__oFwBrw:Refresh()
	
	oPnlAux	:= TPanel():New(120,0,,__oTPanel,,.T.,,CLR_YELLOW,CLR_RED,400,30)
	oPnlAux:Align := CONTROL_ALIGN_BOTTOM
	
	@ 012,010 SAY "Banco"	SIZE 150,08 PIXEL Of oPnlAux
	@ 010,030 MSGET cBanco  PICTURE "@!" SIZE 070,08 WHEN .F. PIXEL OF oPnlAux
	
	@ 012,130 SAY "Modulo"	SIZE 150,08 PIXEL Of oPnlAux
	@ 010,155 MSGET cModulo PICTURE "@!" SIZE 060,08 WHEN .F. PIXEL OF oPnlAux
	
	@ 012,250 SAY "Tipo"	SIZE 150,08 PIXEL Of oPnlAux
	@ 010,265 MSGET cTipo   PICTURE "@!" SIZE 050,08 WHEN .F. PIXEL OF oPnlAux
	
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ConNewVlr
Função F3 para consulta de novo valor a ser preenchido em arquivo CNAB

@param oPanel

@author Francisco Oliveira
@since  31/08/2017
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function ConNewVlr(A,B,C,D,E)
	
	Local nY 		As Numeric
	Local cMsgArq	As Character
	Local aDdsF3	As Array
	Local nPosIni	As Numeric
	Local nPosFim	As Numeric
	Local aDdsTl	As Array
	Local aArea		As Array
	Local cRetF3	As Character
	Local lRet		As Logical
	Local lOk		As Logical
	
	Private oDlg 	As Object
	Private oLbx 	As Object

	nY		:= 0
	cMsgArq	:= ""
	aDdsF3	:= {}
	nPosIni	:= 0
	nPosFim	:= 0
	aDdsTl	:= {}
	aArea	:= GetArea()
	cRetF3	:= ""
	lRet	:= .T.
	lOk		:= .F.
	
	If IsInCallStack("CFGX049B02")
		aDdsF3	:= &(A)
		nPosIni	:= &(B)
		nPosFim	:= &(C)
	Else
		aDdsF3	:= &(aDdsEdit[__oBrwCNAB:nAt][12])
		nPosIni	:= &(aDdsEdit[__oBrwCNAB:nAt][2])
		nPosFim	:= &(aDdsEdit[__oBrwCNAB:nAt][3])
	Endif
	
	cMsgArq	:= Space( (nPosIni - nPosFim) + 1 )
	
	If aDdsF3 != Nil
		If Len(aDdsF3) > 0
			
			If Valtype(aDdsF3) == "A"
				For nY := 1 To Len(aDdsF3)
					aADD(aDdsTl, {StrZero(nY, 3), aDdsF3[nY]})
				Next nY
			ElseIf Valtype(aDdsF3) == "C"
				aADD(aDdsTl, {StrZero(1, 3), aDdsF3})
			Endif
			
			DEFINE FONT oFont NAME "Arial" SIZE 6, -13 BOLD
			DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0057) FROM 0,0 TO 400,600 PIXEL //"Selecione a Nova Informação"
			
			nLinha1 := (oDlg:nHeight - 100) / 2
			nColum1 := (oDlg:nWidth - 10) / 2
			
			@ 030,002 LISTBOX oLbx VAR cVar FIELDS HEADER "Item", "Valor" SIZE nColum1, nLinha1 OF oDlg PIXEL ColSizes 30, 40
			
			oLbx:SetArray(aDdsTl)
			oLbx:align := CONTROL_ALIGN_ALLCLIENT
			
			oLbx:bLine := {|| {aDdsTl[oLbx:nAt][1], aDdsTl[oLbx:nAt][2]}}
			oLbx:Refresh()
			
			ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg, {||(cRetF3 := GetLine(aDdsTl, oLbx), oDlg:End())}, {||oDlg:End()})
		Endif
	Else
		
		DEFINE MsDialog oDlg TITLE OemToAnsi(STR0123) FROM 0,0 TO 180,440 OF oDlg PIXEL // "Informe a Mensagem para CNAB"
		
		@ 032,020 SAY OemToAnsi(STR0124)		SIZE 150,08 PIXEL Of oDlg // "Informe mensagem para arquivo CNAB:"
		@ 030,122 MSGET cMsgArq	PICTURE "@!"	SIZE 080,08 PIXEL OF oDlg
		
		@ 060,120 BUTTON OemToAnsi(STR0119)	SIZE 036,16 PIXEL ACTION {||oDlg:End()} 			Message OemToAnsi(STR0121) of oDlg // "&Cancelar" + "Clique aqui para Cancelar"
		@ 060,165 BUTTON OemToAnsi(STR0120)	SIZE 036,16 PIXEL ACTION {||lOk := .T. ,oDlg:End()}	Message OemToAnsi(STR0122) of oDlg // "&Confirmar" + "Clique aqui para Confirmar"
		
		ACTIVATE MSDIALOG oDlg CENTER
		
		If lOk
			cRetF3	:= Alltrim(cMsgArq)
		Endif
		
	Endif
	
	RestArea(aArea)
	
Return cRetF3

//-------------------------------------------------------------------
/*/{Protheus.doc} VALDIGIT()
Função que altera campo com novo valor escolhido pelo usuario

@author Francisco Oliveira
@since  10/07/2016
@version 12.1.019
/*/
//-------------------------------------------------------------------
Static Function VALDIGIT(A,B,C,D,E)
	
	Local nX		As Numeric
	Local aOpcao	As Array
	Local cDdsAlt	As Character
	Local lRet		As Logical
	Local aDdsAlt	As Array

	nX		:= 0
	aOpcao	:= {}
	cDdsAlt	:= ""
	lRet	:= .T.
	aDdsAlt	:= {}
	
	If IsInCallStack("CFGX049B02")
		aOpcao	:= &(A)
	ElseIf IsInCallStack("CFGX049B")
		aOpcao	:= &(aDdsEdit[__oBrwCNAB:nAt][12])
	Endif
	
	If Valtype(aOpcao) == "A"
		If ! Empty(VlrNew)
			If aScan(aOpcao,{|X| UPPER(X) == UPPER(VlrNew) }) > 0
				
				If ValType(&(B:ODATA:AARRAY[B:AT()][11])) == "A"
					aDdsAlt	:= &(B:ODATA:AARRAY[B:AT()][11])
					
					For nX	:= 1 To Len(aDdsAlt)
						If aDdsAlt[nX] $ B:ODATA:AARRAY[B:AT()][14]
							cDdsAlt	:= aDdsAlt[nX]
						Else
							If Empty(B:ODATA:AARRAY[B:AT()][14])
								If aDdsAlt[nX] != "ZERAR POSICAO" .And. aDdsAlt[nX] == VlrNew
									cDdsAlt	:= "" //VlrNew
								Endif
							Endif
						Endif
					Next nX
				Else
					cDdsAlt	:= B:ODATA:AARRAY[B:AT()][11]
				Endif
				
				If UPPER(SUBSTR(B:ODATA:AARRAY[B:AT()][10],1,3)) == "RET"
					If &(B:ODATA:AARRAY[B:AT()][11])[1] == VlrNew
						B:ODATA:AARRAY[B:AT()][14] := ""
						B:ODATA:AARRAY[B:AT()][05] := ""
					Else
						If Empty(B:ODATA:AARRAY[B:AT()][14]) .And. Empty(cDdsAlt)
							B:ODATA:AARRAY[B:AT()][14] := AllTrim(VlrNew)
							B:ODATA:AARRAY[B:AT()][05] := AllTrim(VlrNew)
						Else
							B:ODATA:AARRAY[B:AT()][14] := StrTran(B:ODATA:AARRAY[B:AT()][14], Alltrim(cDdsAlt), AllTrim(VlrNew))
							B:ODATA:AARRAY[B:AT()][05] := AllTrim(VlrNew)
						Endif
					Endif
				Else
					B:ODATA:AARRAY[B:AT()][14] := StrTran(B:ODATA:AARRAY[B:AT()][14], Alltrim(cDdsAlt), AllTrim(VlrNew))
					B:ODATA:AARRAY[B:AT()][05] := AllTrim(VlrNew)
				Endif
				
				If IsInCallStack("CFGX049B")
					__oBrwCNAB:Refresh()
					__oFwBrw:Refresh()
				Endif
			Else
				Aviso(OemToAnsi(STR0035), OemToAnsi(STR0058), {"Ok"}, 3) // "Valor digitado não confere com valores padrão. Use a tecla 'F3'."
				lRet	:= .F.
			Endif
		Endif
	ElseIf Valtype(aOpcao) == "C"
		If ! Empty(VlrNew)
			If Alltrim(aOpcao) = AllTrim(VlrNew)
				B:ODATA:AARRAY[B:AT()][05] := AllTrim(VlrNew)
				B:ODATA:AARRAY[B:AT()][14] := StrTran(B:ODATA:AARRAY[B:AT()][14], Alltrim(B:ODATA:AARRAY[B:AT()][11]), AllTrim(VlrNew))
				If IsInCallStack("CFGX049B")
					__oBrwCNAB:Refresh()
					__oFwBrw:Refresh()
				Endif
			Else
				Aviso(OemToAnsi(STR0035), OemToAnsi(STR0058), {"Ok"}, 3) // "Valor digitado não confere com valores padrão. Use a tecla 'F3'."
				lRet	:= .F.
			Endif
		Endif
	ElseIf Valtype(aOpcao) == "U"
		If ! Empty(VlrNew)
			B:ODATA:AARRAY[B:AT()][05] := '"' + UPPER(Alltrim(VlrNew)) + '"'
			B:ODATA:AARRAY[B:AT()][14] := '"' + UPPER(Alltrim(VlrNew)) + '"'
			If IsInCallStack("CFGX049B")
				__oBrwCNAB:Refresh()
				__oFwBrw:Refresh()
			Endif
		Endif
	Endif
	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GetLine()
Função que define valor escolhido pelo usuario

@author Francisco Oliveira
@since  10/07/2016
@version 12.1.019
/*/
//-------------------------------------------------------------------

Static Function GetLine(aDdsTl As Array, oLbx As Object) As Character
	
	Local cRet	As Character
	Local lRet	As Logical

	Default aDdsTl	:= {}
	Default oLbx	:= Nil

	cRet	:= ""
	lRet	:= .T.
	
	If Len(aDdsTl) > 0 .AND. oLbx <> Nil
		cRet := aDdsTl[oLbx:nAt][2]
	EndIf
	
	__nRetoLbx := oLbx:nAt
	
Return cRet



