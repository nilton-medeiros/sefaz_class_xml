/*
   Projeto: CTeMonitor
   Executavel multiplataforma que faz o intercâmbio do TMS.CLOUD WEB com o ACBrMonitorPlus
   para criar uma interface de comunicação com a Sefaz através de comandos para o ACBrMonitorPlus.

   Direitos Autorais Reservados (c) 2020 Nilton Gonçalves Medeiros

   Colaboradores nesse arquivo:

   Você pode obter a última versão desse arquivo no GitHub
   Componentes localizado em https://github.com/nilton-medeiros/cte-monitor

    Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la
   sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela
   Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério)
   qualquer versão posterior.

    Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM
   NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU
   ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor
   do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)

    Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto
   com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,
   no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.
   Você também pode obter uma copia da licença em:
   http://www.opensource.org/licenses/gpl-license.php

   Nilton Gonçalves Medeiros - nilton@sistrom.com.br - www.sistrom.com.br
   Caieiras - SP
*/


#include <hmg.ch>
#include "hbclass.ch"

#define SIGLA_UF "RO|AC|AL|AM|AP|BA|CE|DF|ES|EX|GO|MA|MG|MS|MT|PA|PB|PE|PI|PR|RJ|RN|RR|RS|SC|SE|SP|TO"
#define CODIGO_UF "11|12|13|14|15|16|17|21|22|23|24|25|26|27|28|29|31|32|33|35|41|42|43|50|51|52|53"


class TideCTe
   data documentation READONLY
   data value
   data cte_id // Para controle de UPDATE no BD deste CTe
   data cUF
   data cCT
   data CFOP
   data natOp
   data mod
   data serie
   data nCT
   data dhEmi
   data tpImp
   data tpEmis
   data cDV
   data tpAmb
   data tpCTe
   data procEmi
   data verProc
   data indGlobalizado
   data cMunEnv
   data xMunEnv
   data UFEnv
   data modal
   data tpServ
   data cMunIni
   data xMunIni
   data UFIni
   data cMunFim
   data xMunFim
   data UFFim
   data retira
   data xDetRetira
   data indIEToma
   data toma3
   data toma4
   // dhCont e xJus: Informar apenas para tpEmis diferente de 1
   data dhCont
   data xJus
   method new() constructor

end class

method new() class TideCTe
   ::documentation := "ide | Identificação do CT-e"
   ::value := "TideCTe"
   ::cte_id := '0' // Para controle de UPDATE no BD deste CTe
   ::cUF := Telement():new({'name' => "cUF", 'documentation' => "Código da UF do emitente do CT-e", 'minLength' => 2, 'restriction' => CODIGO_UF, 'type' => "N"})
   ::cCT := Telement():new({'name' => "cCT", 'documentation' => "Código numérico que compõe a Chave de Acesso", 'minLength' => 8, 'type' => "N"})
   ::CFOP := Telement():new({'name' => "CFOP", 'documentation' => "Código Fiscal de Operações e Prestações", 'minLength' => 4, 'type' => "N"})
   ::natOp := Telement():new({'name' => "natOp", 'documentation' => "Natureza da Operação", 'maxLength' => 60, 'value' => "TRANSPORTE"})
   ::mod := Telement():new({'name' => "mod", 'documentation' => "Modelo do documento fiscal", 'minLength' => 2, 'value' => "57", 'type' => "N"})
   ::serie := Telement():new({'name' => "serie", 'documentation' => "Série do CT-e", 'minLength' => 3, 'value' => "001", 'type' => "N"})
   ::nCT := Telement():new({'name' => "nCT", 'documentation' => "Número do CT-e", 'minLength' => 9, 'type' => "N"})
   ::dhEmi := Telement():new({'name' => "dhEmi", 'documentation' => "Data e hora de emissão do CT-e [Formato:  AAAA-MM-DDTHH:MM:DD TZD]", 'minLength' => 25, 'value' => "AAAA-MM-DDTHH:MM:SS-03:00", 'type' => "TZD"})
   ::tpImp := Telement():new({'name' => "tpImp", 'documentation' => "Formato de impressão do DACTE"+CRLF+"Preencher com: 1 - Retrato; 2 - Paisagem.", 'minLength' => 1, 'value' => "1", 'restriction' => "12", 'type' => "N"})
   ::tpEmis := Telement():new(;
                     {'name' => "tpEmis", 'documentation' => "Forma de emissão do CT-e. Preencher com:"+CRLF+;
                               "1 - Normal;"+CRLF+;
                               "4 - EPEC pela SVC;"+CRLF+;
                               "5 - Contingência FSDA;"+CRLF+;
                               "7 - Autorização pela SVC-RS;"+CRLF+;
                               "8 - Autorização pela SVC-SP.",;
                      'minLength' => 1, 'value' => "1", 'restriction' => "1|4|5|7|8", 'type' => "N"})
   ::cDV := Telement():new({'name' => "cDV", ;
                  'documentation' => "Digito Verificador da chave de acesso do CT-e"+CRLF+;
                           "Informar o dígito  de controle da chave de acesso do CT-e, que deve ser calculado com a aplicação do algoritmo módulo 11 (base 2,9) da chave de acesso.",;
                  'minLength' => 1, 'value' => "0", 'restriction' => "0|1|2|3|4|5|6|7|8|9", 'type' => "N"})
   ::tpAmb := Telement():new({'name' => "tpAmb", ;
                     'documentation' => "Tipo do Ambiente"+CRLF+"Preencher com:1 - Produção; 2 - Homologação.",;
                      'value' => "2", 'minLength' => 1, 'restriction' => "1|2", 'type' => "N"})
   ::tpCTe := Telement():new({'name' => "tpCTe", ;
                     'documentation' => "Tipo do CT-e. Preencher com:"+CRLF+;
                              "0 - CT-e Normal;"+CRLF+;
                              "1 - CT-e de Complemento de Valores;"+CRLF+;
                              "2 - CT-e de Anulação;"+CRLF+;
                              "3 - CT-e de Substituição",;
                     'value' => "0", 'minLength' => 1, 'restriction' => "0|1|2|3", 'type' => "N"})
   ::procEmi := Telement():new({'name' => "procEmi", ;
                     'documentation' => "Identificador do processo de emissão do CT-e. Preencher com:"+CRLF+;
                              "0 - emissão de CT-e com aplicativo do contribuinte;"+CRLF+;
                              "3- emissão CT-e pelo contribuinte com aplicativo fornecido pelo SEBRAE.",;
                     'value' => "0", 'minLength' => 1, 'restriction' => "0|3", 'type' => "N"})
   ::verProc := Telement():new({'name' => "verProc", ;
                     'documentation' => "Versão do processo de emissão"+CRLF+;
                              "Informar a versão do aplicativo emissor de CT-e.",;
                     'value' => "1.0.0", 'minLength' => 1, 'maxLength' => 20})
   ::indGlobalizado := Telement():new({'name' => "indGlobalizado", ;
                     'documentation' => "Indicador de CT-e Globalizado"+CRLF+;
                              "Informar valor 1 quando for Globalizado e não informar a tag quando não tratar de CT-e Globalizado",;
                     'minLength' => 1, 'restriction' => "1", 'required' => False, 'type' => "N"})
   ::cMunEnv := Telement():new({'name' => "cMunEnv", ;
                     'documentation' => "Código do Município de envio do CT-e (de onde o documento foi transmitido)"+CRLF+;
                              "Utilizar a tabela do IBGE. Informar 9999999 para as operações com o exterior.",;
                     'minLength' => 7, 'type' => "N"})
   ::xMunEnv := Telement():new({'name' => "xMunEnv", ;
                     'documentation' => "Nome do Município de envio do CT-e (de onde o documento foi transmitido)"+CRLF+;
                              "Informar PAIS/Municipio para as operações com o exterior.",;
                     'minLength' => 2, 'maxLength' => 60})
   ::UFEnv := Telement():new({'name' => "UFEnv", ;
                     'documentation' => "Sigla da UF de envio do CT-e (de onde o documento foi transmitido)"+CRLF+;
                              "Informar 'EX' para operações com o exterior.",;
                      'minLength' => 2, 'restriction' => SIGLA_UF})
   ::modal := Telement():new({'name' => "modal", ;
                     'documentation' => "Modal"+CRLF+;
                              "Preencher com:"+CRLF+;
                              "01-Rodoviário;"+CRLF+;
                              "02-Aéreo;"+CRLF+;
                              "03-Aquaviário;"+CRLF+;
                              "04-Ferroviário;"+CRLF+;
                              "05-Dutoviário;"+CRLF+;
                              "06-Multimodal.",;
                     'value' => "01", 'minLength' => 2, 'restriction' => "01|02|03|04|05|06", 'type' => "N"})
   ::tpServ := Telement():new({'name' => "tpServ", ;
                     'documentation' => "Tipo do Serviço"+CRLF+;
                              "Preencher com:"+CRLF+;
                              "0 - Normal;"+CRLF+;
                              "1 - Subcontratação;"+CRLF+;
                              "2 - Redespacho;"+CRLF+;
                              "3 - Redespacho Intermediário;"+CRLF+;
                              "4 - Serviço Vinculado a Multimodal",;
                     'value' => "0", 'minLength' => 1, 'restriction' => "0|1|2|3|4", 'type' => "N"})
   ::cMunIni := Telement():new({'name' => "cMunIni", ;
                     'documentation' => "Código do Município de início da prestação"+CRLF+;
                              "Utilizar a tabela do IBGE. Informar 9999999 para as operações com o exterior.",;
                     'minLength' => 7, 'type' => "N"})
   ::xMunIni := Telement():new({'name' => "xMunIni", ;
                     'documentation' => "Nome do Município do início da prestação"+CRLF+;
                              "Informar 'EXTERIOR' para operações com o exterior.",;
                     'minLength' => 2, 'maxLength' => 60})
   ::UFIni := Telement():new({'name' => "UFIni", ;
                     'documentation' => "UF do início da prestação"+CRLF+"Informar 'EX' para operações com o exterior.",;
                     'minLength' => 2, 'restriction' => SIGLA_UF})
   ::cMunFim := Telement():new({'name' => "cMunFim", ;
                     'documentation' => "Código do Município de término da prestação"+CRLF+;
                              "Utilizar a tabela do IBGE. Informar 9999999 para as operações com o exterior.",;
                      'minLength' => 7, 'type' => "N"})
   ::xMunFim := Telement():new({'name' => "xMunFim", ;
                     'documentation' => "Nome do Município do término da prestação"+CRLF+;
                              "Informar 'EXTERIOR' para operações com o exterior.",;
                      'minLength' => 2, 'maxLength' => 60})
   ::UFFim := Telement():new({'name' => "UFFim", ;
                     'documentation' => "UF do término da prestação"+CRLF+"Informar 'EX' para operações com o exterior.",;
                      'minLength' => 2, 'restriction' => SIGLA_UF})
   ::retira := Telement():new({'name' => "retira", ;
                     'documentation' => "Indicador se o Recebedor retira no Aeroporto, Filial, Porto ou Estação de Destino?"+CRLF+;
                              "Preencher com: 0 - sim; 1 - não",;
                      'value' => "1", 'minLength' => 1, 'restriction' => "0|1", 'type' => "N"})
   ::xDetRetira := Telement():new({'name' => "xDetRetira", ;
                     'documentation' => "Detalhes do retira",;
                      'minLength' => 1, 'maxLength' => 160, 'required' => False})
   ::indIEToma := Telement():new({'name' => "indIEToma", ;
                     'documentation' => "Indicador do papel do tomador na prestação do serviço:"+CRLF+;
                              "1 – Contribuinte ICMS"+CRLF+;
                              "2 – Contribuinte isento de inscrição;"+CRLF+;
                              "9 – Não Contribuinte."+CRLF+;
                              "Aplica-se ao tomador que for indicado no toma3 ou toma4",;
                      'minLength' => 1, 'restriction' => "1|2|9", 'type' => "N"})
   ::toma3 := Ttoma3():new()
   ::toma4 := Ttoma4():new()
   // dhCont e xJus: Informar apenas para tpEmis diferente de 1
   ::dhCont := Telement():new({'name' => "dhCont", 'documentation' => "::e Hora da entrada em contingência"+CRLF+"Informar a ::e hora no formato AAAA-MM-DDTHH:MM:SS", 'minLength' => 19, 'required' => False, 'type' => "DT"})
   ::xJus := Telement():new({'name' => "xJus", 'documentation' => "Justificativa da entrada em contingência", 'minLength' => 15, 'maxLength' => 256, 'required' => False})
return self