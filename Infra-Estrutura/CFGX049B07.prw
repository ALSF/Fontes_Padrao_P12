#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

//------------------------------------------------------------------
/*/{Protheus.doc} ValCNABAti()
Serviço web Lista de CNAB ativo pela Totvs
@author Francisco Oliveira
@since 22/08/2017
/*/
//------------------------------------------------------------------

// dummy function para reconhecimento no repositório
Function ValCNABAti()
Return

// classe do restful
// realizará consulta dos CNAB´s
WSRESTFUL ValCNABAti DESCRIPTION "Recebe Lista de CNAB´s Ativo"

WSDATA banco 	AS STRING
WSDATA versao 	AS STRING
WSDATA modulo 	AS STRING	OPTIONAL
WSDATA tipo		AS STRING	OPTIONAL
WSDATA ativosn	AS STRING 	OPTIONAL

WSMETHOD GET DESCRIPTION "Receber Checkins" WSSYNTAX "/ValCNABAti /{codigo} }"

END WSRESTFUL

/*
Método GET para listagem dos atendentes
*/
WSMETHOD GET WSRECEIVE banco, versao, modulo, tipo, ativosn WSSERVICE ValCNABAti
	
	Local nX, nY
	Local oObjCNABAti
	Local nCntRes0			:= 0
	Local nCntRes1			:= 0
	Local lBcoAtiv			:= .T.
	Local lJSonDes			:= .F.
	Local aArrCNAB			:= {}			// Array com os arquivos CNAB´s disponiveis
	Local cRetJsonPadrao	:= '{"banco":"","versao":"","modulo":"","tipo":"","ativosn":""}'
	Local aCnabAti			:= ''
	Local cVerArq1			:= '1.01' // Versão Arquivo Disponivel
	Local cVerArq2			:= '1.02' // Versão Arquivo Disponivel
	Local cVerRel1			:= '12.1.017' // Versão Release Disponivel
	Local cVerRel2			:= '12.1.018' // Versão Release Disponivel
	Local cModPAG			:= 'PAG'		// Modulo Financeiro PAGAR ou RECEBER
	Local cModREC			:= 'REC'		// Modulo Financeiro PAGAR ou RECEBER
	Local cTipREM			:= 'REM'		// Tipo do Arquivo REMESSA ou RETORNO
	Local cTipRET			:= 'RET'		// Tipo do Arquivo REMESSA ou RETORNO
	
	              //Cod.   Versão    Modulo    Tipo       Nome        Val.  Release
	              //Banco  Arquivo   PAG/REC  REM/RET     Fonte       Uso   Protheus
//	AADD(aArrCNAB, {'001', cVerArq1, cModPAG, cTipREM, "FIN001PREM()",.T., cVerRel1} ) // Banco do Brasil
//	AADD(aArrCNAB, {'001', cVerArq1, cModPAG, cTipRET, "FIN001PRET()",.T., cVerRel1} ) // Banco do Brasil
//	AADD(aArrCNAB, {'001', cVerArq1, cModREC, cTipREM, "FIN001RREM()",.T., cVerRel1} ) // Banco do Brasil
//	AADD(aArrCNAB, {'001', cVerArq1, cModREC, cTipRET, "FIN001RRET()",.T., cVerRel1} ) // Banco do Brasil
//	AADD(aArrCNAB, {'033', cVerArq1, cModPAG, cTipREM, "FIN033PREM()",.T., cVerRel1} ) // Santander
//	AADD(aArrCNAB, {'033', cVerArq1, cModPAG, cTipRET, "FIN033PRET()",.T., cVerRel1} ) // Santander
//	AADD(aArrCNAB, {'033', cVerArq1, cModREC, cTipREM, "FIN033RREM()",.T., cVerRel1} ) // Santander
//	AADD(aArrCNAB, {'033', cVerArq1, cModREC, cTipRET, "FIN033RRET()",.T., cVerRel1} ) // Santander
//	AADD(aArrCNAB, {'104', cVerArq1, cModPAG, cTipREM, "FIN104PREM()",.T., cVerRel1} ) // Caixa Economica Federal
//	AADD(aArrCNAB, {'104', cVerArq1, cModPAG, cTipRET, "FIN104PRET()",.T., cVerRel1} ) // Caixa Economica Federal
//	AADD(aArrCNAB, {'104', cVerArq1, cModREC, cTipREM, "FIN104RREM()",.T., cVerRel1} ) // Caixa Economica Federal
//	AADD(aArrCNAB, {'104', cVerArq1, cModREC, cTipRET, "FIN104RRET()",.T., cVerRel1} ) // Caixa Economica Federal
	AADD(aArrCNAB, {'237', cVerArq1, cModPAG, cTipREM, "FIN237PREM()",.T., cVerRel1} ) // Bradesco
	AADD(aArrCNAB, {'237', cVerArq1, cModPAG, cTipRET, "FIN237PRET()",.T., cVerRel1} ) // Bradesco
//	AADD(aArrCNAB, {'237', cVerArq1, cModREC, cTipREM, "FIN237RREM()",.T., cVerRel1} ) // Bradesco
//	AADD(aArrCNAB, {'237', cVerArq1, cModREC, cTipRET, "FIN237RRET()",.T., cVerRel1} ) // Bradesco
//	AADD(aArrCNAB, {'341', cVerArq1, cModPAG, cTipREM, "FIN341PREM()",.T., cVerRel1} ) // Itau
//	AADD(aArrCNAB, {'341', cVerArq1, cModPAG, cTipRET, "FIN341PRET()",.T., cVerRel1} ) // Itau
//	AADD(aArrCNAB, {'341', cVerArq1, cModREC, cTipREM, "FIN341RREM()",.T., cVerRel1} ) // Itau
//	AADD(aArrCNAB, {'341', cVerArq1, cModREC, cTipRET, "FIN341RRET()",.T., cVerRel1} ) // Itau
	
	aCnabAti := ''
	
	aArrCNAB	:= aSort(aArrCNAB,,, { |x,y| x[1] + x[2] + x[3] + x[4] < y[1] + y[2] + y[3] + y[4] })
	
	// define o tipo de retorno do método
	self:SetContentType("application/json")
	
	For nX := 1 To Len(aArrCNAB)
		If aArrCNAB[nX, 6]
			lBcoAtiv	:= .F.
			nCntRes0++
		Endif
	Next nX
	
	If lBcoAtiv
		self:SetResponse(cRetJsonPadrao)
		Return .T.
	Else
		aCnabAti	+= '{' + CRLF
		aCnabAti	+= '"Checkins":[' + CRLF
		
		For nX := 1 To Len(aArrCNAB)
			If aArrCNAB[nX, 6]
				lBcoAtiv	:= .F.
				nCntRes1++
				aCnabAti	+= '{"banco":"' + aArrCNAB[nX][1] + '","versao":"' + aArrCNAB[nX][2] + '","modulo":"' + aArrCNAB[nX][3] + ;
				'","tipo":"' + aArrCNAB[nX][4] + '","funcao":"' + aArrCNAB[nX][5] + '","release":"' + aArrCNAB[nX][7] + '" }' + CRLF
				If nCntRes0 > nCntRes1
					aCnabAti += ','
				Endif
			Endif
		Next nX
		aCnabAti	+= ']}'
	Endif
	
	lJSonDes := FWJSonDeserialize(NoACento(aCnabAti),@oObjCNABAti)
	
	If lJSonDes
		
		If !Len(oObjCNABAti:Checkins) > 0
			self:SetResponse(cRetJsonPadrao)
			Return .T.
		Endif
		
		For nY := 1 To Len(oObjCNABAti:Checkins)
			
			If nY == 1
				self:SetResponse('{')
				self:SetResponse('"Checkins":[')
			Endif
			
			self:SetResponse('{"banco":"' 	+ oObjCNABAti:Checkins[nY]:banco	+ '",')
			self:SetResponse('"versao":"'	+ oObjCNABAti:Checkins[nY]:versao	+ '",')
			self:SetResponse('"modulo":"'	+ oObjCNABAti:Checkins[nY]:modulo	+ '",')
			self:SetResponse('"tipo":"' 	+ oObjCNABAti:Checkins[nY]:tipo 	+ '",')
			self:SetResponse('"funcao":"' 	+ oObjCNABAti:Checkins[nY]:funcao 	+ '",')
			self:SetResponse('"release":"' 	+ oObjCNABAti:Checkins[nY]:release	+ '"}')
			
			If nY < Len(oObjCNABAti:Checkins)
				self:SetResponse(',')
			Endif
		Next nY
		self:SetResponse(']')
		self:SetResponse('}')
	Else
		self:SetResponse(cRetJsonPadrao)
	Endif
	
Return .T.


