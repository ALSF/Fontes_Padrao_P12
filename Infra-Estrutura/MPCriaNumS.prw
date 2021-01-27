#include 'totvs.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MPCriaNumS
Retornar o primeiro número de um determinado campo na criação

@author  framework
@since   20/03/2019
@version 1.0

@param cAlias Alias da tabela para a qual será criado o controle da numeração sequencial
@param cCpoSx8 Nome do campo para o qual será implementado o controle da numeração. 
@param É informado quando o nome do alias nos arquivos de controle de numeração não é o nome convencional do alias para o Protheus.
@param nOrdSX8 do índice que será utilizado para verificar qual o próximo número disponível.
@param lCampo informado via referência, se .T. irá verificar o ultimo valor do registro de acordo com indice
@param nTamanho informado via referência deverá retornar o tamanho da string

@obs Se existir o ponto de entrada CRIASXE a função de criação abaixo não será executada

@return cNum caracter com o primeiro número da sequência
/*/
//-------------------------------------------------------------------

//
Function MPCriaNumS( cAlias, cCpoSx8, cAliasSx8, nOrdSX8, lCampo, nTamanho )

    Local cNum 		as char   
    cNum := ''
    If cCpoSx8 == "C7_NUM"
    
    	cNum := MaxNumC7( cAlias, cCpoSx8, cAliasSx8, nOrdSX8, @lCampo, @nTamanho )
    ElseIf cCpoSx8 == "E6_NUMSOL"
			cNum := F620MaxNum(@lCampo, @nTamanho)
    EndIf

Return cNum

Static Function MaxNumC7( cAlias, cCpoSx8, cAliasSx8, nOrdSX8, lCampo, nTamanho )

    	If SuperGetMv("MV_PCFILEN",.F.,.F.)
	    	
			aAreaAux := GetArea()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A numeração deve ser unica por empresa.                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "SELECT MAX(C7_NUM) SEQUEN "
			cQuery += "  FROM " + RetSqlName( "SC7" ) + " SC7 "
			cQuery += " WHERE D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery( cQuery )
				
			cAliasAux := GetNextAlias()  
				
			dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasAux, .F., .T. )
				
			IF Select( cAliasAux ) > 0
					
				cNum := Soma1((cAliasAux)->SEQUEN)
	
				lCampo   := .F.
				nTamanho := 6
				DbSelectArea(cAliasAux)
				DbCloseArea()
			Endif
					
			RestArea(aAreaAux)    	
	    	
	    Else
	    	lCampo   := .T.
	    EndIf
	    
Return cNum

//------------------------------------------------------------------------------
/*/{Protheus.doc} F620MaxNum
	Cria Numeração para tranferencia, numeração unica para a tabela. 
	Chamada do GETSXENUM pelo FINA620 e FINA621

@since		05/06/2019
@version	P12
/*/
//------------------------------------------------------------------------------
Function F620MaxNum(lCampo as Logical, nTamanho as Numeric) As Character
Local aArea				as Array
Local cAliasSeq		as Character
Local cSequencia  as Character 

aArea			 := GetArea()
cAliasSeq  := GetNextAlias()
nTamanho 	 := TamSX3("E6_NUMSOL")[1]
cSequencia := STRZERO(1,nTamanho)
lCampo		 := .F.

Iif(Select(cAliasSeq)>0,(cAliasSeq)->(DbCloseArea()),)

BeginSql Alias cAliasSeq
	SELECT MAX(E6_NUMSOL) PROXIMO
	FROM %table:SE6% SE6
	WHERE SE6.%NotDel%
EndSql

IF !(cAliasSeq)->(Eof())
	cSequencia := Soma1((cAliasSeq)->PROXIMO)
	(cAliasSeq)->(DbCloseArea())
EndIf 

RestArea(aArea)

Return cSequencia