#Include "Protheus.ch"
#Include "CFGX060.ch"

/*/{Protheus.doc} CFGX060
Wizard de conversão de Certificado Digital - SIAFI

@author Pedro Alencar	
@since 15/01/2015	
@version 12.1.3
/*/
Function CFGX060()
	WizCertif()
Return Nil

/*/{Protheus.doc} WizCertif
Função que monta as etapas do Wizard de conversão do arquivo .PFX, do 
certificado digital, em arquivos .PEM.

@author Pedro Alencar	
@since 15/01/2015	
@version 12.1.3
/*/
Static Function WizCertif()
	Local oWizard
	Local cArquivo := ""
	Local cPsw := ""
	Local cArqCA := "\certif_ca"
	Local cArqCERT := "\certif_cert"
	Local cArqKEY := "\certif_key"
	Local cRet := ""
	Local bNextPn3 := {|| Iif( VldPanel3( cArqCA, cArqCERT, cArqKEY ), ConvCertif( cArquivo, cPsw, cArqCA, cArqCERT, cArqKEY, @cRet ), .F. ) }
	
	//Painel 1 - Tela inicial do Wizard
	oWizard := APWizard():New( OemToAnsi(STR0001), "", OemToAnsi(STR0002), OemToAnsi(STR0003), {||.T.}, {||.T.}, .F. ) // "Conversão de arquivo .PFX em arquivos .PEM", "Assistente de Conversão de Certificado Digital", "Essa rotina irá converter o arquivo .PFX, do certificado digital, em arquivos .PEM com a extração do Certificado de Autorização, Certificado de Cliente e Chave Privada."
	
	//Painel 2 - Caminho e Senha do Certificado Digital
	oWizard:NewPanel( OemToAnsi(STR0004), OemToAnsi(STR0005), {||.T.}, {|| VldPanel2( cArquivo, cPsw ) }, {||.T.}, .T., {|| MontaTela1( oWizard, @cArquivo, @cPsw ) } ) //"Caminho do Certificado Digital", "Definição do caminho do arquivo .PFX, do certificado digital, para a conversão."
	
	//Painel 3 - Caminho dos arquivos de saída
	oWizard:NewPanel( OemToAnsi(STR0006), OemToAnsi(STR0007), {||.T.}, bNextPn3, {||.T.}, .T., {|| MontaTela2( oWizard, @cArqCA, @cArqCERT, @cArqKEY ) } ) //"Local de gravação dos arquivos de saída", "Definição do caminho dos arquivos .PEM que serão gerados."
	
	//Painel 4 - Término da Conversão
	oWizard:NewPanel( OemToAnsi(STR0008), OemToAnsi(STR0009), {||.F.}, {||.T.}, {||.T.}, .T., {|| MontaTela3( oWizard, cRet ) } ) //"Término da Conversão", "Resultado do processo de conversão do certificado digital."
	
	//Ativa a tela do wizard
	oWizard:Activate( .T., {||.T.}, {||.T.}, {||.T.} )
	
Return Nil

/*/{Protheus.doc} MontaTela1
Função que monta, no Wizard, a tela com o campo de seleção do arquivo 
.PFX, do certificado digital, e a senha para ser convertido.

@param oWizard, Objeto da classe APWizard
@param cArquivo, Caminho do arquivo de certificado (por referência)
@param cPsw, Senha de autorização do certificado (por referência) 

@author Pedro Alencar	
@since 15/01/2015
@version 12.1.3
/*/
Static Function MontaTela1( oWizard, cArquivo, cPsw )
	Local oPanel := oWizard:oMPanel[oWizard:nPanel]   
	Local oGet1
	Local cArqAnt := ""
	Local cFiltro := OemToAnsi(STR0010) + " (*.pfx)|*.pfx" //"Arquivo de Certificado"
	Local bAction := {|| cArqAnt := cArquivo, cArquivo := AllTrim( cGetFile( cFiltro, OemToAnsi(STR0011), 0, "", .T., GETF_ONLYSERVER, .T. ) ) , Iif( Empty( cArquivo ), cArquivo := cArqAnt, ) } //"Seleção de certificado"
	Default cArquivo := ""
	Default cPsw := ""
	
	//Caminho do arquivo de certificado
	TSay():New( 010, 018, {|| OemToAnsi(STR0012) }, oPanel, , , , , , .T. ) //"Caminho do Certificado Digital: "
	oGet1 := TGet():New( 008, 095, {|u| Iif( PCount() > 0, cArquivo := u, cArquivo + Space( 250 - Len( cArquivo ) ) ) }, oPanel, 150,,,,,,,,,.T.,,,,,,,,.F.,,"cArquivo" )
	oGet1:bHelp := {|| Help( , , "CERTIFILE", , OemToAnsi(STR0013), 1, 0 ) } //"Caminho do arquivo .PFX, do certificado digital, que será convertido nos arquivos .PEM."
	TButton():New( 0.6, 62, OemToAnsi(STR0014), oPanel, bAction, 40 ) //"Procurar..."   
	
	//Senha de autorização do certificado
	TSay():New( 030, 018, {|| OemToAnsi(STR0015) }, oPanel, , , , , , .T. ) //"Senha de autorização: "
	oGet1 := TGet():New( 028, 095, {|u| Iif( PCount() > 0, cPsw := u, cPsw + Space( 250 - Len( cPsw ) ) ) }, oPanel, 150,,,,,,,,,.T.,,,,,,,,.F.,,"cPsw" )
	oGet1:bHelp := {|| Help( , , "CERTIFPASS", , OemToAnsi(STR0016), 1, 0 ) } //"Senha de autorização definida na instalação do certificado digital."
	
Return Nil

/*/{Protheus.doc} MontaTela2
Função que monta, no Wizard, a tela com os campos de definição de nome e
localde gravação dos novos arquivos .PEM.

@param oWizard, Objeto da classe APWizard
@param cArqCA, Caminho do arquivo CA que será criado (por referência)
@param cArqCERT, Caminho do arquivo CERT que será criado (por referência)
@param cArqKEY, Caminho do arquivo KEY que será criado (por referência) 

@author Pedro Alencar	
@since 15/01/2015
@version 12.1.3
/*/
Static Function MontaTela2( oWizard, cArqCA, cArqCERT, cArqKEY )
	Local oPanel := oWizard:oMPanel[oWizard:nPanel]   
	Local oGet1
	Local cArqAnt := ""
	Local cFiltro := OemToAnsi(STR0010) + " (*.pem)|*.pem" //"Arquivo de Certificado"
	Local bActCA := {|| cArqAnt := cArqCA, cArqCA := AllTrim( cGetFile( cFiltro, OemToAnsi(STR0017), 0, "", .F., GETF_ONLYSERVER, .T. ) ) , Iif( Empty( cArqCA ), cArqCA := cArqAnt, ) } //"Seleção da pasta de gravação"
	Local bActCERT := {|| cArqAnt := cArqCERT, cArqCERT := AllTrim( cGetFile( cFiltro, OemToAnsi(STR0017), 0, "", .F., GETF_ONLYSERVER, .T. ) ) , Iif( Empty( cArqCERT ), cArqCERT := cArqAnt, ) } //"Seleção da pasta de gravação"
	Local bActKEY := {|| cArqAnt := cArqKEY, cArqKEY := AllTrim( cGetFile( cFiltro, OemToAnsi(STR0017), 0, "", .F., GETF_ONLYSERVER, .T. ) ) , Iif( Empty( cArqKEY ), cArqKEY := cArqAnt, ) } //"Seleção da pasta de gravação"
	Default cArqCA := ""
	Default cArqCERT := ""
	Default cArqKEY := ""
	
	//Caminho do Certificado de Autorização 
	TSay():New( 010, 018, {|| OemToAnsi(STR0018) }, oPanel, , , , , , .T. ) //"Certificado de Autorização (CA):"
	oGet1 := TGet():New( 008, 100, {|u| Iif( PCount() > 0, cArqCA := u, cArqCA + Space( 250 - Len( cArqCA ) ) ) }, oPanel, 150,,,,,,,,,.T.,,,,,,,,.F.,,"cArqCA" )
	oGet1:bHelp := {|| Help( , , "OUTFILE1", , OemToAnsi(STR0019), 1, 0 ) } //"Defina o nome do arquivo (sem extensão) e a pasta no qual o mesmo será gravado ao término da conversão."
	TButton():New( 0.6, 63, OemToAnsi(STR0014), oPanel, bActCA, 40 ) //"Procurar..."
	
	//Caminho do Certificado de Cliente
	TSay():New( 030, 018, {|| OemToAnsi(STR0020) }, oPanel, , , , , , .T. ) //"Certificado de Cliente (CERT):"
	oGet1 := TGet():New( 028, 100, {|u| Iif( PCount() > 0, cArqCERT := u, cArqCERT + Space( 250 - Len( cArqCERT ) ) ) }, oPanel, 150,,,,,,,,,.T.,,,,,,,,.F.,,"cArqCERT" )
	oGet1:bHelp := {|| Help( , , "OUTFILE2", , OemToAnsi(STR0019), 1, 0 ) } //"Defina o nome do arquivo (sem extensão) e a pasta no qual o mesmo será gravado ao término da conversão."
	TButton():New( 2.6, 63, OemToAnsi(STR0014), oPanel, bActCERT, 40 ) //"Procurar..."
	
	//Caminho da Chave Privada
	TSay():New( 050, 018, {|| OemToAnsi(STR0021) }, oPanel, , , , , , .T. ) //"Chave Privada (KEY):"
	oGet1 := TGet():New( 048, 100, {|u| Iif( PCount() > 0, cArqKEY := u, cArqKEY + Space( 250 - Len( cArqKEY ) ) ) }, oPanel, 150,,,,,,,,,.T.,,,,,,,,.F.,,"cArqKEY" )
	oGet1:bHelp := {|| Help( , , "OUTFILE3", , OemToAnsi(STR0019), 1, 0 ) } //"Defina o nome do arquivo (sem extensão) e a pasta no qual o mesmo será gravado ao término da conversão."
	TButton():New( 4.6, 63, OemToAnsi(STR0014), oPanel, bActKEY, 40 ) //"Procurar..."
	
Return Nil

/*/{Protheus.doc} MontaTela3
Função que monta, no Wizard, a tela de conclusão da conversão

@param oWizard, Objeto da classe APWizard
@param cRet, Mensagem de erro, se a conversão falhou 

@author Pedro Alencar	
@since 15/01/2015
@version 12.1.3
/*/
Static Function MontaTela3( oWizard, cRet )
	Local oPanel := oWizard:oMPanel[oWizard:nPanel]   
	Default cRet := ""
	
	If AllTrim( cRet ) == ""
		TSay():New( 010, 018, {|| OemToAnsi(STR0022) }, oPanel, , , , , , .T. ) //"Conversão concluída com sucesso!:"
	Else
		TSay():New( 010, 018, {|| OemToAnsi(STR0023) }, oPanel, , , , , , .T. ) //"Não foi possível gerar os arquivos corretamente."		
		//Exibe a mensagem de erro do processamento da funções de conversão
		TSay():New( 030, 018, {|| cRet }, oPanel, , , , , , .T. )
	Endif
	
Return Nil

/*/{Protheus.doc} VldPanel2
Função que valida os dados informados no painel de definição
do caminho do arquivo .PFX e senha de autorização

@param cArquivo, Caminho do arquivo .PFX do certificado
@param cPsw, Senha de autorização do certificado

@author Pedro Alencar	
@since 15/01/2015
@version 12.1.3
/*/
Static Function VldPanel2( cArquivo, cPsw )
	Local lRet := .T.
	
	If AllTrim( cArquivo ) == "" .OR. AllTrim( cPsw ) == ""
		Help( "", 1, "VldPanel2", , OemToAnsi(STR0024), 2, 0 ) //"É necessário informar o caminho do arquivo .PFX do certificado e a senha de autorização configurada."
		lRet := .F.		
	Endif
	
Return lRet

/*/{Protheus.doc} VldPanel3
Função que valida os dados informados no painel de definição
do caminho do arquivo .PFX e senha de autorização

@param cArqCA, Caminho do arquivo CA que será criado
@param cArqCERT, Caminho do arquivo CERT que será criado
@param cArqKEY, Caminho do arquivo KEY que será criado 

@author Pedro Alencar	
@since 15/01/2015
@version 12.1.3
/*/
Static Function VldPanel3( cArqCA, cArqCERT, cArqKEY )
	Local lRet := .T.
	
	If AllTrim( cArqCA ) == "" .OR. AllTrim( cArqCERT ) == "" .OR. AllTrim( cArqKEY ) == ""
		Help( "", 1, "VldPanel3", , OemToAnsi(STR0025), 2, 0 ) //"É necessário informar o caminho e o nome dos três arquivos .PEM que serão gerados na conversão."
		lRet := .F.		
	Endif
	
Return lRet

/*/{Protheus.doc} ConvCertif
Função que converte o certificado em 3 arquivos .PEM, sendo eles:
Certificado de Autorização, Certificado de Cliente e Chave Privada.

@param cArquivo, Caminho do arquivo .PFX do certificado
@param cPsw, Senha de autorização do certificado
@param cArqCA, Caminho do arquivo CA que será criado
@param cArqCERT, Caminho do arquivo CERT que será criado
@param cArqKEY, Caminho do arquivo KEY que será criado 
@param cRet, Mensagem de retorno, em caso de erro

@author Pedro Alencar	
@since 15/01/2015
@version 12.1.3
/*/
Static Function ConvCertif( cArquivo, cPsw, cArqCA, cArqCERT, cArqKEY, cRet )	
	Local cError := ""
	Default cArquivo := ""
	Default cPsw := ""
	Default cArqCA := ""
	Default cArqCERT := ""
	Default cArqKEY := ""
	Default cRet := ""
	
	cArquivo := AllTrim( cArquivo )
	cPsw := AllTrim( cPsw )
	cArqCA := AllTrim( cArqCA )
	cArqCERT := AllTrim( cArqCERT )
	cArqKEY := AllTrim( cArqKEY )
	
	//Garante que os arquivos serão gerados com a extensão correta
	If Right( Upper( cArqCA ), 4 ) != ".PEM"
		cArqCA += ".pem"
	Endif
	If Right( Upper( cArqCERT ), 4 ) != ".PEM"
		cArqCERT += ".pem"
	Endif
	If Right( Upper( cArqKEY ), 4 ) != ".PEM"
		cArqKEY += ".pem"
	Endif
	
	//Gera o arquivo de Certificado de Autorização
	If PFXCA2PEM( cArquivo, cArqCA, @cError, cPsw )
		//Gera o arquivo de Certificado de Cliente
		If PFXCert2PEM( cArquivo, cArqCERT, @cError, cPsw )
			//Gera o arquivo de Chave Privada
			If ! PFXKey2PEM( cArquivo, cArqKEY, @cError, cPsw )
				cRet := OemToAnsi(STR0026) + cError //"Erro ao extrair a chave privada. "
			Endif
		Else
			cRet := OemToAnsi(STR0027) + cError //"Erro ao extrair o Certificado de Cliente. "
		Endif
	Else
		cRet := OemToAnsi(STR0028) + cError //"Erro ao extrair o Certificado de Autorização. "
	Endif	
	
Return .T.