#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

//------------------------------------------------------------------
/*/{Protheus.doc} LeArqConfig()
Serviço web Lista de CNAB ativo pela Totvs
@author Francisco Oliveira
@since 22/08/2017
/*/

// dummy function para reconhecimento no repositório
Function LeArqConfig()
Return

// classe do restful
// realizará consulta dos CNAB´s
WSRESTFUL LeArqConfig DESCRIPTION "Recebe Arquivo Configuração CNAB´s"

WSDATA banco 		AS STRING
WSDATA funcao		AS STRING 	OPTIONAL

WSMETHOD GET DESCRIPTION "Receber Funcao CNAB" WSSYNTAX "/LeArqConfig/{funcao} }"

END WSRESTFUL

/*
Método GET para listagem dos atendentes
*/
WSMETHOD GET WSRECEIVE funcao WSSERVICE LeArqConfig
	
	Local nY, nX
	Local aArrCNAB			:= {}			// Array com os arquivos CNAB´s disponiveis
	Local aArrRest			:= {}
	Local aArrEdi			:= {}
	Local lChkFor			:= .T.
	Local cRetJsonPadrao	:= '{"Arquivo CNAB":"","versao":"","modulo":"","tipo":""}'
	
	// define o tipo de retorno do método
	self:SetContentType("application/json")
	
	aArrRest	:= StrToKarr(Self:aURLParms[1],";")
	
	If Len(aArrRest) > 0
		
		If ! Empty(aArrRest[1])
			aArrCNAB	:= &(aArrRest[1])
		Else
			self:SetResponse(cRetJsonPadrao)
			Return .T.
		Endif
		
		If Len(aArrCNAB) < 1
			self:SetResponse(cRetJsonPadrao)
		Endif
	Else
		self:SetResponse(cRetJsonPadrao)
		Return .T.
	Endif
	
	aArrEdi	:= CFGX049B10(aArrRest[2], aArrRest[4], aArrRest[3])
	
	For nY := 1 To Len(aArrCNAB)
		
		If nY == 1
			self:SetResponse('{')
			self:SetResponse('"Checkins":[')
		Endif
		
		If aArrCNAB[nY][1] == "1"
			self:SetResponse('{"idelin":"' 	+ Alltrim(aArrCNAB[nY][01])	+ '",')
			self:SetResponse('"headet":"'	+ Alltrim(aArrCNAB[nY][02])	+ '",')
			self:SetResponse('"chalin":"'	+ Alltrim(aArrCNAB[nY][03])	+ '",')
			self:SetResponse('"ideseg":"'	+ Alltrim(aArrCNAB[nY][04])	+ '",')
			self:SetResponse('"desseg":"'	+ Alltrim(aArrCNAB[nY][05])	+ '",')
			self:SetResponse('"desmov":"'	+ Alltrim(aArrCNAB[nY][06])	+ '",')
			self:SetResponse('"vazio1":"'	+ Alltrim(aArrCNAB[nY][07])	+ '",')
			self:SetResponse('"vazio2":"'	+ Alltrim(aArrCNAB[nY][08])	+ '",')
			self:SetResponse('"vazio3":"'	+ Alltrim(aArrCNAB[nY][09])	+ '",')
			self:SetResponse('"edita":"'	+ Alltrim(aArrCNAB[nY][10])	+ '",')
			self:SetResponse('"sequen":"' 	+ Alltrim(aArrCNAB[nY][11])	+ '",')
			self:SetResponse('"newvlr":"' 	+ Alltrim(aArrCNAB[nY][12])	+ '",') // NOVO VALOR ALTERAÇÃO
			self:SetResponse('"vlresc":"' 	+ Alltrim(aArrCNAB[nY][13])	+ '"}') // VALOR A SER ALTERADO
		ElseIf aArrCNAB[nY][1] == "2"
			self:SetResponse('{"idelin":"' 	+ Alltrim(aArrCNAB[nY][01])	+ '",')
			self:SetResponse('"headet":"'	+ Alltrim(aArrCNAB[nY][02])	+ '",')
			self:SetResponse('"chalin":"'	+ Alltrim(aArrCNAB[nY][03])	+ '",')
			self:SetResponse('"ideseg":"'	+ Alltrim(aArrCNAB[nY][04])	+ '",')
			self:SetResponse('"desseg":"'	+ Alltrim(aArrCNAB[nY][05])	+ '",')
			self:SetResponse('"posini":"'	+ Alltrim(aArrCNAB[nY][06])	+ '",')
			self:SetResponse('"posfim":"'	+ Alltrim(aArrCNAB[nY][07])	+ '",')
			self:SetResponse('"decima":"'	+ Alltrim(aArrCNAB[nY][08])	+ '",')
			self:SetResponse('"desmov":"'	+ Alltrim(aArrCNAB[nY][09])	+ '",')
			self:SetResponse('"sequen":"' 	+ Alltrim(aArrCNAB[nY][11])	+ '",')
			
			If Len(aArrEdi) > 0
				For nX := 1 To Len(aArrEdi)
					If 				Alltrim(aArrEdi[nX][1]) == Alltrim(aArrCNAB[nY][1]) .And. Alltrim(aArrEdi[nX][2]) == Alltrim(aArrCNAB[nY][2]);
							.And. 	Alltrim(aArrEdi[nX][3]) == Alltrim(aArrCNAB[nY][3]) .And. Alltrim(aArrEdi[nX][4]) == Alltrim(aArrCNAB[nY][4]);
							.And. 	Alltrim(aArrEdi[nX][5]) == Alltrim(aArrCNAB[nY][6]) .And. Alltrim(aArrEdi[nX][6]) == Alltrim(aArrCNAB[nY][7])
						
						self:SetResponse('"edita":"'	+ ".T."						+ '",')
						self:SetResponse('"newvlr":"' 	+ Alltrim(aArrEdi[nX][7])	+ '",') // NOVO VALOR ALTERAÇÃO
						self:SetResponse('"vlresc":"' 	+ Alltrim(aArrEdi[nX][8])	+ '"}') // VALOR A SER ALTERADO
						lChkFor	:= .F.
						Exit
					Endif
				Next nX
				If lChkFor
					self:SetResponse('"edita":"'	+ '.F.'						+ '",')
					self:SetResponse('"newvlr":"' 	+ Alltrim(aArrCNAB[nY][12])	+ '",') // NOVO VALOR ALTERAÇÃO
					self:SetResponse('"vlresc":"' 	+ Alltrim(aArrCNAB[nY][13])	+ '"}') // VALOR A SER ALTERADO
				Else
					lChkFor	:= .T.
				Endif
			Else
				self:SetResponse('"edita":"'	+ '.F.'						+ '",')
				self:SetResponse('"newvlr":"' 	+ Alltrim(aArrCNAB[nY][12])	+ '",') // NOVO VALOR ALTERAÇÃO
				self:SetResponse('"vlresc":"' 	+ Alltrim(aArrCNAB[nY][13])	+ '"}') // VALOR A SER ALTERADO
			Endif
		Endif
		
		If nY < Len(aArrCNAB)
			self:SetResponse(',')
		Endif
	Next nY
	self:SetResponse(']')
	self:SetResponse('}')
	
Return .T.
