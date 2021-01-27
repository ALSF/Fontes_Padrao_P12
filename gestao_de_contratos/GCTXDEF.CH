//------------------------------------------------------------------
/*/OBSERVAÇÃO
Não esquecer de atualizar o ambiente de compilação(Robo) via chamado 
para o GCAD, sempre que alterar este arquivo.
/*/
//-------------------------------------------------------------------

//------------------------------------------------------------------
/*/{Protheus.doc} GCTXDEF
Defines utilizadas no modulo Gestão de Contatos (GCT)

@author alexandre.gimenez
@since 18/03/2014
@version 1.0
/*/
//-------------------------------------------------------------------

//-- Situacoes de contrato
#DEFINE DEF_SCANC 	"01" //Cancelado
#DEFINE DEF_SELAB 	"02" //Em Elaboracao
#DEFINE DEF_SEMIT 	"03" //Emitido
#DEFINE DEF_SAPRO 	"04" //Em Aprovacao
#DEFINE DEF_SVIGE 	"05" //Vigente
#DEFINE DEF_SPARA 	"06" //Paralisado
#DEFINE DEF_SSPAR 	"07" //Sol Fina.
#DEFINE DEF_SFINA 	"08" //Finalizado
#DEFINE DEF_SREVS 	"09" //Revisao
#DEFINE DEF_SREVD 	"10" //Revisado
#DEFINE DEF_SREJE 	"11" //Rejeitado
#DEFINE DEF_SREVA	"A"  //Revisão por Alçadas.

//-- Transações
#DEFINE DEF_TRANS 	"001" //Transacao de controle total do contrato
#DEFINE DEF_TRAINC 	"007"//Inclusao de Planilhas
#DEFINE DEF_TRAEXC 	"009"//Exclusao de Planilhas
#DEFINE DEF_TRASIT 	"018"//Transacao de controle de situacoes
#DEFINE DEF_TRAINC 	"027"//Inclusao de Revisoes
#DEFINE DEF_TRAEXC 	"029"//Exclusao de Revisoes
#DEFINE DEF_TRAAPR 	"030"//Aprovação de revisoes
#DEFINE DEF_TRAVIS 	"037"//Transacao de visualizacao do contrato
#DEFINE DEF_TRABCO 	"038"//Transacao de controle sobre o banco de conhecimento
#DEFINE DEF_TRAEDT 	"039"//Transacao de controle sobre a edicao do contrato
#DEFINE DEF_TRARET 	"040"//Transacao de controle sobre a baixa da retencao
#DEFINE DEF_TRAAVA 	"042"//Transacao de Avaliações .
#DEFINE DEF_TRAAVV 	"046"//Transacao de Avaliações de Visualização.

//-- Revisoes do contrato
#DEFINE DEF_REV_ADITI 	"1" //Aditivo
#DEFINE DEF_REV_REAJU	"2" //Reajuste
#DEFINE DEF_REV_REALI 	"3" //Realinhamento
#DEFINE DEF_REV_READE 	"4" //Readequação
#DEFINE DEF_REV_PARAL 	"5" //Paralisação
#DEFINE DEF_REV_REINI 	"6" //Reinicio
#DEFINE DEF_REV_CLAUS 	"7" //Clausulas
#DEFINE DEF_REV_CONTA 	"8" //Contabil
#DEFINE DEF_REV_INDIC 	"9" //Indice
#DEFINE DEF_REV_FORCL 	"A" //Fornecedor/Cliente
#DEFINE DEF_REV_GRAPR 	"B" //Grupo de Aprovação
#DEFINE DEF_REV_RENOV	"C" //Renovação
#DEFINE DEF_REV_MULBON	"D" //Multa/Bonificação
#DEFINE DEF_REV_CAUCA	"E" //Caução
#DEFINE DEF_REV_ORCGS	"F" //Orçamento de Serviços GS
#DEFINE DEF_REV_ABERT	"G" //Aberta
#DEFINE DEF_ADIANT		"AD"//Adiantamento
#DEFINE DEF_APROV			"AP"//Aprovação

//-- Transações no Caução
#DEFINE DEF_CAU_VIS "031" //Visualiza
#DEFINE DEF_CAU_TRA "002" //Controle total
#DEFINE DEF_CAU_INC "003" //Inclusão
#DEFINE DEF_CAU_EDT "004" //Edição
#DEFINE DEF_CAU_EXC "005" //Exclusão

//-- Transações no Planilha
#DEFINE DEF_PLA_VIS "032" //Visualiza
#DEFINE DEF_PLA_TRA "006" //Controle total
#DEFINE DEF_PLA_INC "007" //Inclusão
#DEFINE DEF_PLA_EDT "008" //Edição
#DEFINE DEF_PLA_EXC "009" //Exclusão

//-- Transações no Documento
#DEFINE DEF_DOC_VIS "034" //Visualiza
#DEFINE DEF_DOC_TRA "014" //Controle total
#DEFINE DEF_DOC_INC "015" //Inclusão
#DEFINE DEF_DOC_EDT "016" //Edição
#DEFINE DEF_DOC_EXC "017" //Exclusão

//-- Baixar Retenção
#DEFINE DEF_BXRET "040"

//Medicoes
#DEFINE DEF_TRAINC_MED "021"//Inclusao de Medicoes
#DEFINE DEF_TRAEDT_MED "022"//Edicao de Medicoes
#DEFINE DEF_TRAEXC_MED "023"//Exclusao de Medicoes
#DEFINE DEF_TRAENC_MED "024"//Encerramento de Medicoes
#DEFINE DEF_TRAEST_MED "025"//Estorno de Medicoes

