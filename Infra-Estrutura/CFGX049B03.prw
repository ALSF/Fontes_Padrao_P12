#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#Include 'CFGX049B.CH'

#Define cCposG1	"FOP_CODIGO|FOP_IDELIN|FOP_HEADET|FOP_CHALIN|FOP_IDESEG|FOP_DESSEG|FOP_CONARQ"
#Define cCposG2 "FOP_CODIGO|FOP_IDELIN|FOP_HEADET|FOP_CHALIN|FOP_IDESEG|FOP_DESMOV|FOP_POSINI|FOP_POSFIM|FOP_DECIMA|FOP_CONARQ|FOP_BANCO"

Static lPulaCom	:= .F.

/*/ {Protheus.doc} CFGX049B03()
Função que realiza a criação da tela de cadastro da tabela tela de cadastro da tabela FOP.
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  CFGX049B02
@Return
@param
*/

Function CFGX049B03()
	
	Local oBrowse	:= NIL
	
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'FOZ' )
	oBrowse:SetDescription(OemToAnsi(STR0060)) // "Configuração Arquivos CNAB"
	
	//Legenda
	oBrowse:AddLegend("FOZ_EDITAV = '1'", "RED"  , "Arquivo Editado"  ) //"Arquivo Editado"
	oBrowse:AddLegend("FOZ_EDITAV = '2'", "GREEN", "Arquivo Original" ) //"Arquivo Original"
	
	oBrowse:Activate()
	
Return Nil

/*/ {Protheus.doc} MenuDef()
Função que incluí as opções do menu na tela de cadastro da tabela FOP
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  MenuDef()
@Return	aRotina: Objeto com todas as opções inseridas no menu.
@param
*/

Static Function MenuDef()
	
	Local aRotina := {}
	
	lPulaCom := .F.
	
	ADD OPTION aRotina TITLE OemToAnsi(STR0043)	ACTION 'VIEWDEF.CFGX049B03'	OPERATION 2 ACCESS 0 // 'Visualizar'
	ADD OPTION aRotina TITLE OemToAnsi(STR0061)	ACTION 'VIEWDEF.CFGX049B03' OPERATION 3 ACCESS 0 // 'Incluir'
	ADD OPTION aRotina TITLE OemToAnsi(STR0062)	ACTION 'VIEWDEF.CFGX049B03' OPERATION 4 ACCESS 0 // 'Alterar'
	ADD OPTION aRotina TITLE OemToAnsi(STR0063)	ACTION 'VIEWDEF.CFGX049B03' OPERATION 5 ACCESS 0 // 'Excluir'
	
Return aRotina

/*/ {Protheus.doc} ModelDef()
Função que realiza o tratamento de toda a camada de negócio para inclusão/alteração e exclusão da tabela FOP.
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  ModelDef()
@Return	oModel: Objeto com todos os campos do modelo de dados.
@param
*/

Static Function ModelDef()
	
	Local oStrCabFOZ	:= FWFormStruct( 1, 'FOZ')
	Local oStrGrdFOP 	:= FWFormStruct( 1, 'FOP', {|cCampo|Alltrim(cCampo) $ (cCposG1)} )
	Local oStrIteFOP 	:= FWFormStruct( 1, 'FOP', {|cCampo|Alltrim(cCampo) $ (cCposG2)} )
	
	Local aLoadGrd1	:= {{"FOP_IDELIN", "1", MVC_LOADFILTER_EQUAL }}
	Local aLoadGrd2	:= {{"FOP_IDELIN", "2", MVC_LOADFILTER_EQUAL }}
	
	Local bVldAlt	:= {|oGridModel, nLine, cAction, cCpoPos, cVlrCpo| fbPost(oGridModel, nLine, cAction, cCpoPos, cVlrCpo)}
	Local bVldTri	:= {|oMdlTrig, cCpoTrig, cVlrTrig| bfVldTri(oMdlTrig, cCpoTrig, cVlrTrig)}
	
	oStrGrdFOP:AddTrigger( "FOP_HEADET" , "FOP_HEADET" , , bVldTri )
	oStrGrdFOP:AddTrigger( "FOP_CHALIN" , "FOP_CHALIN" , , bVldTri )
	oStrGrdFOP:AddTrigger( "FOP_IDESEG" , "FOP_IDESEG" , , bVldTri )
	
	oStrCabFOZ:SetProperty("FOZ_CODIGO" , MODEL_FIELD_WHEN, {|| .F.    } )
	oStrCabFOZ:SetProperty("FOZ_MODULO" , MODEL_FIELD_WHEN, {|| Inclui } )
	oStrCabFOZ:SetProperty("FOZ_TIPO"   , MODEL_FIELD_WHEN, {|| Inclui } )
	oStrCabFOZ:SetProperty("FOZ_BANCO"  , MODEL_FIELD_WHEN, {|| Inclui } )
	
	oStrGrdFOP:SetProperty("*" , MODEL_FIELD_OBRIGAT, .F.  )
	oStrIteFOP:SetProperty("*" , MODEL_FIELD_OBRIGAT, .F.  )
	//oStrGrdFOP:SetProperty("FOP_CONARQ" , MODEL_FIELD_OBRIGAT, .F.  )
	
	oStrGrdFOP:SetProperty("FOP_IDELIN" , MODEL_FIELD_WHEN, {|| .F. } )
	
	oStrIteFOP:SetProperty("FOP_IDELIN" , MODEL_FIELD_WHEN, {|| .F. } )
	oStrIteFOP:SetProperty("FOP_HEADET" , MODEL_FIELD_WHEN, {|| .F. } )
	oStrIteFOP:SetProperty("FOP_CHALIN" , MODEL_FIELD_WHEN, {|| .F. } )
	oStrIteFOP:SetProperty("FOP_IDESEG" , MODEL_FIELD_WHEN, {|| .F. } )
	
	//oModel := MPFormModel():New( 'CFGX049B03')
	oModel := MPFormModel():New( 'CFGX049B03',/*<bPre >*/,/*<bPost >*/,{|oModel|CFGX049B3G(oModel)},/*<bCancel >*/)
	          	
	oModel:AddFields( 'FOZMASTER', /*cOwner*/, oStrCabFOZ )
	oModel:AddGrid(   'FOPGRD1'  ,'FOZMASTER', oStrGrdFOP )
	oModel:AddGrid(	  'FOPGRD2'  ,'FOPGRD1'  , oStrIteFOP,/*BLINEPRE*/, /*BLINEPOST*/, bVldAlt /*BPREVAL*/, /*BPOSVAL*/,/*bLoad*/)
	
	oModel:GetModel("FOPGRD1"):SetLoadFilter( aLoadGrd1, /*cLoadFilter*/ )
	oModel:GetModel("FOPGRD2"):SetLoadFilter( aLoadGrd2, /*cLoadFilter*/ )
	
	oModel:SetRelation( 'FOPGRD1', { { 'FOP_FILIAL', 'xFilial("FOP")'}, {'FOP_CODIGO', 'FOZ_CODIGO'} }, FOP->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'FOPGRD2', { { 'FOP_FILIAL', 'xFilial("FOP")'}, {'FOP_CODIGO', 'FOP_CODIGO'}, {'FOP_IDELIN', '2'}, {'FOP_HEADET', 'FOP_HEADET'}, {'FOP_CHALIN', 'FOP_CHALIN'}, {'FOP_IDESEG', 'FOP_IDESEG'}}, FOP->( 'FOP_FILIAL+FOP_CODIGO+FOP_IDELIN+FOP_HEADET+FOP_CHALIN+FOP_IDESEG' ) )
	
	oStrGrdFOP:SetProperty('FOP_IDELIN',MODEL_FIELD_INIT, {||"1"} )
	
	oStrIteFOP:SetProperty('FOP_IDELIN',MODEL_FIELD_INIT, {|oModel|fbInitPad(oModel, 1)} )
	oStrIteFOP:SetProperty('FOP_HEADET',MODEL_FIELD_INIT, {|oModel|fbInitPad(oModel, 2)} )
	oStrIteFOP:SetProperty('FOP_CHALIN',MODEL_FIELD_INIT, {|oModel|fbInitPad(oModel, 3)} )
	oStrIteFOP:SetProperty('FOP_IDESEG',MODEL_FIELD_INIT, {|oModel|fbInitPad(oModel, 4)} )
	
	oModel:SetPrimaryKey( { "FOZ_FILIAL", "FOZ_CODIGO" } )
	oModel:GetModel("FOZMASTER"):SetDescription(OemToAnsi(STR0064)) // "Cadastro Arquivos CNAB"
	oModel:GetModel("FOPGRD1"):SetDescription(OemToAnsi(STR0064)) // "Cadastro Arquivos CNAB"
	
Return oModel

/*/ {Protheus.doc} Viewdef()
Função que realiza o tratamento de toda a camada de visualização da tabela FOP.
@author	Francisco Oliveira
@since		11/08/2017
@version	P12
@Function  Viewdef()
@Return	oView: Objeto com todos os campos para a criação da tela
@param
*/

Static Function Viewdef()
	
	Local oModel   		:= FWLoadModel( 'CFGX049B03' )
	Local oStrCabFOZ	:= FWFormStruct( 2, 'FOZ')
	Local oStrGrdFOP 	:= FWFormStruct( 2, 'FOP', {|cCampo|Alltrim(cCampo) $ (cCposG1)} )
	Local oStrIteFOP 	:= FWFormStruct( 2, 'FOP', {|cCampo|Alltrim(cCampo) $ (cCposG2)} )
	
	Local oView    	:= FWFormView():New()
	
	oView:SetModel( oModel )
	
	oStrGrdFOP:RemoveField("FOP_CODIGO")
	
	oStrIteFOP:RemoveField("FOP_CODIGO")
	oStrIteFOP:RemoveField("FOP_BANCO")
	
	oView:AddField( 'VIEW_CAB' , oStrCabFOZ, 'FOZMASTER' )
	oView:AddGrid ( 'VIEW_GRD1', oStrGrdFOP, 'FOPGRD1' )
	oView:AddGrid ( 'VIEW_GRD2', oStrIteFOP, 'FOPGRD2' )
	
	oView:CreateHorizontalBox( 'SUPERIOR', 10)
	oView:CreateHorizontalBox( 'MEIO'	 , 25)
	oView:CreateHorizontalBox( 'INFERIOR', 65)
	
	oView:SetOwnerView( 'VIEW_CAB'	, 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_GRD1'	, 'MEIO'     )
	oView:SetOwnerView( 'VIEW_GRD2'	, 'INFERIOR' )
	
Return oView



Static Function fbInitPad(oGridModel, nRefen, cAction )
	
	Local aAreaFOP	:= FOP->(GetArea('FOP'))
	Local lRet		:= .T.
	Local oView		:= FWViewActive()
	Local aSaveLines:= FWSaveRows()
	Local oMdlGrd1	:= oGridModel:GetModel():GetModel("FOPGRD1")
	Local oMdlGrd2	:= oGridModel:GetModel():GetModel("FOPGRD2")
	Local cRetInit	:= ""
	
	If nRefen == 1
		cRetInit := "2"
	ElseIf nRefen == 2
		cRetInit := oMdlGrd1:GetValue("FOP_HEADET")
	ElseIf nRefen == 3
		cRetInit := oMdlGrd1:GetValue("FOP_CHALIN")
	ElseIf nRefen == 4
		cRetInit := oMdlGrd1:GetValue("FOP_IDESEG")
	Endif
	
	FWRestRows( aSaveLines )
	RestArea(aAreaFOP)
	
Return cRetInit


Static Function fbPost(oGridModel, nLine, cAction, cCpoPos, cVlrCpo)
	
	Local lRet		:= .T.
	Local oMdlGrd1	:= oGridModel:GetModel():GetModel("FOPGRD1")
	Local oMdlGrd2	:= oGridModel:GetModel():GetModel("FOPGRD2")
	Local cPosIni	:= oMdlGrd2:GetValue("FOP_POSINI")
	Local nLinPos	:= oMdlGrd2:nLine
	Local oView		:= FWViewActive()
	Local oMdlAct	:= FwModelActive()
	
	If cAction == "ADDLINE"
		
		If oMdlGrd2:GetValue("FOP_POSFIM") < oMdlGrd2:GetValue("FOP_POSINI")
			oMdlAct:SetErrorMessage("oMdlGrd2", "FOP_POSFIM", "", "FOP_POSFIM", "oMdlGrd2", OemToAnsi(STR0140), OemToAnsi(STR0141)) //"O valor do campo Posição Final não pode ser menor do que o campo Posição Inicial." ---  "Digite um valor maior que o valor do campo Posição Inicial."
			lRet	:= .F.
		Else
			If ! Empty(oMdlGrd2:GetValue("FOP_DESMOV")) .Or. ! Empty(oMdlGrd2:GetValue("FOP_CONARQ")) .Or.;
					! Empty(oMdlGrd2:GetValue("FOP_POSINI")) .Or. ! Empty(oMdlGrd2:GetValue("FOP_POSINI")) .Or. ! Empty(oMdlGrd2:GetValue("FOP_DECIMA"))
				If nLinPos > 0
					If nLinPos == 1
						If cPosIni > oMdlGrd2:GetValue("FOP_POSFIM")
							oMdlAct:SetErrorMessage("oMdlGrd2", "FOP_POSINI", "", "FOP_POSINI", "oMdlGrd2", OemToAnsi(STR0142), OemToAnsi(STR0143)) // "O valor do campo Posição Inicial não pode ser maior do que o campo Posição Final." -- "Digite um valor menor que o valor do campo Posição Final."
							oMdlGrd2:GoLine(nLinPos )
							lRet	:= .F.
						Endif
					ElseIf nLinPos > 1
						oMdlGrd2:GoLine(nLinPos - 1)
						If oMdlGrd2:GetValue("FOP_POSFIM") > cPosIni
							oMdlAct:SetErrorMessage("oMdlGrd2", "FOP_POSINI", "", "FOP_POSINI", "oMdlGrd2", OemToAnsi(STR0144), OemToAnsi(STR0145)) //"O valor do campo Posição Inicial não pode ser menor do que o campo Posição Final da linha anterior."  ----- "Digite um valor maior que o valor do campo Posição Final."
							oMdlGrd2:GoLine(nLinPos )
							lRet	:= .F.
						Else
							oMdlGrd2:GoLine(nLinPos)
						Endif
					Endif
				Endif
			Else
				oMdlAct:SetErrorMessage("oMdlGrd2", "FOP_POSFIM", "", "FOP_POSFIM", "oMdlGrd2", OemToAnsi(STR0146), OemToAnsi(STR0147)) // "Existe campo de preenchimento obrigatório vazio." ----- "Favor rever os campos anteriores."
				lRet	:= .F.
			Endif
		Endif
	Endif
	
	If cAction == "SETVALUE"
		If cCpoPos == "FOP_POSINI"
			If nLinPos > 1
				oMdlGrd2:GoLine(nLinPos - 1)
				If Val(oMdlGrd2:GetValue("FOP_POSFIM")) + 1 == Val(cVlrCpo)
					oMdlGrd2:GoLine(nLinPos )
				Else
					oMdlAct:SetErrorMessage("oMdlGrd2", "FOP_POSINI", "", "FOP_POSINI", "oMdlGrd2", OemToAnsi(STR0148), OemToAnsi(STR0149)) //"O valor do campo Posição Inicial é diferente do valor necessario para validação."  ----- "Favor rever o valor digitado no campo Posição Inicial."
					oMdlGrd2:GoLine(nLinPos )
					lRet := .F.
				Endif
			ElseIf nLinPos == 1
				If cVlrCpo != "001"
					If Aviso(OemToAnsi(STR0035), OemToAnsi(STR0150) + CRLF + OemToAnsi(STR0079), {"Sim","Não"}, 3) == 2 // "O valor do campo Posição Inicial é diferente de 001."  ---- "Deseja continuar?."
						oMdlAct:SetErrorMessage("oMdlGrd2", "FOP_POSINI", "", "FOP_POSINI", "oMdlGrd2", OemToAnsi(STR0150), OemToAnsi(STR0151)) //"O valor do campo Posição Inicial é diferente de 001."   ----- "Para continuar preencha o campo Posição Inical com 001."
						lRet := .F.
						Return lRet
					Endif
				Endif
			Endif
		ElseIf cCpoPos == "FOP_POSFIM"
			If Val(cVlrCpo) < Val(oMdlGrd2:GetValue("FOP_POSINI"))
				oMdlAct:SetErrorMessage("oMdlGrd2", "FOP_POSFIM", "", "FOP_POSFIM", "oMdlGrd2", OemToAnsi(STR0140), OemToAnsi(STR0141)) // "O valor do campo Posição Final não pode ser menor do que o campo Posição Inicial." --- "Digite um valor maior que o valor do campo Posição Inicial"
				lRet := .F.
			Endif
		Endif
	Endif
	
Return lRet


Static Function bfVldTri(oMdlTrig, cCpoTrig, cVlrTrig)
	
	Local oMdlGrd1	:= oMdlTrig:GetModel():GetModel("FOPGRD1")
	Local oMdlGrd2	:= oMdlTrig:GetModel():GetModel("FOPGRD2")
	
	If oMdlGrd2:nLine == 1
		oMdlGrd2:LoadValue(cCpoTrig, cVlrTrig)
	Endif
	
Return cVlrTrig


Static Function CFGX049B3G(oModel)

	Local nGrd1, nGrd2
	Local oMdlGrv1	:= oModel:GetModel():GetModel("FOPGRD1")
	Local oMdlGrv2	:= oModel:GetModel():GetModel("FOPGRD2")
	Local lRet		:= .F.
	
	If !lPulaCom
		lPulaCom := .T.
		For nGrd1 := 1 To oModel:GetModel():GetModel("FOPGRD1"):Length()
		//For nGrd1 := 1 To oMdlGrv1:Length()
			oModel:GetModel():GetModel("FOPGRD1"):GoLine(nGrd1)
			oModel:GetModel():GetModel("FOPGRD1"):LoadValue("FOP_IDELIN", "1")
			//oMdlGrv1:GoLine(nGrd1)
			//oMdlGrv1:LoadValue("FOP_IDELIN", "1")
			//For nGrd2 := 1 To oMdlGrv2:Length()
			For nGrd2 := 1 To oModel:GetModel():GetModel("FOPGRD2"):Length()
				//oMdlGrv2:GoLine(nGrd2)
				//oMdlGrv2:LoadValue("FOP_IDELIN", "2")
				oModel:GetModel():GetModel("FOPGRD2"):GoLine(nGrd2)
				oModel:GetModel():GetModel("FOPGRD2"):LoadValue("FOP_IDELIN", "2")
			Next nGrd2
		Next nGrd1
		
		If oModel:VldData() //.And. oMdlGrv2:VldData()
			oModel:CommitData()
			//oMdlGrv1:CommitData()
			lRet	:= .T.
		EndIf
	Endif
	/*
	FOP->FOP_FILIAL
	FOP->FOP_CODIGO
	FOP->FOP_IDELIN
	FOP->FOP_HEADET
	FOP->FOP_CHALIN
	FOP->FOP_IDESEG
	FOP->FOP_BANCO
	FOP->FOP_DESSEG
	FOP->FOP_POSINI
	FOP->FOP_POSFIM
	FOP->FOP_DECIMA
	FOP->FOP_DESMOV
	FOP->FOP_CONARQ
	FOP->FOP_VERARQ
	FOP->FOP_BLOQUE
	FOP->FOP_EDITAD
	FOP->FOP_DTGRAV
	FOP->FOP_PAGREC
	FOP->FOP_REMRET
	FOP->FOP_SEQUEN
	FOP->FOP_CTREDI
	FOP->FOP_CTDEDI
	FOP->FOP_NEWVLR
	*/

Return lRet




