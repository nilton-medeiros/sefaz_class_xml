#include <hmg.ch>
#include "hbclass.ch"

#define SIGLA_UF "RO|AC|AL|AM|AP|BA|CE|DF|ES|EX|GO|MA|MG|MS|MT|PA|PB|PE|PI|PR|RJ|RN|RR|RS|SC|SE|SP|TO"
#define CODIGO_UF "11|12|13|14|15|16|17|21|22|23|24|25|26|27|28|29|31|32|33|35|41|42|43|50|51|52|53"


class TideMDFe
	data documentation READONLY
	data value
   data mdfe_id
   data cUF
   data tpAmb
   data tpEmit
   data tpTransp
   data mod
   data serie
   data nMDF
   data cMDF
   data cDV
   data modal
   data dhEmi
   data tpEmis
   data procEmi
   data verProc
   data UFIni
   data UFFim
   data infMunCarrega
   data infPercurso
   method new() constructor
   method add_infMunCarrega()
   method add_infPercurso()
end class

method new() class TideMDFe
   ::documentation := 'ide | Identificação do MDF-e'
   ::value := 'TideMDFe'
   ::mdfe_id := '0'
   ::cUF := Telement():new({'name' => "cUF", 'documentation' => "Código da UF do emitente do MDF-e", 'minLength' => 2, 'restriction' => CODIGO_UF, 'type' => "N"})
   ::tpAmb := Telement():new({'name' => "tpAmb", 'documentation' => "Tipo do Ambiente" + CRLF + "Preencher com: 1 - Produção; 2 - Homologação.", 'value' => "2", 'minLength' => 1, 'restriction' => "1|2", 'type' => "N"})
   ::tpEmit := Telement():new({'name' => 'tpEmit', 'documenttion' => 'Tipo do Emitente' + CRLF + '1 - Prestador de serviço de transporte; 2 - Transportador de Carga Própria; 3 - Prestador de serviço de transporte que emitirá CT-e Globalizado; OBS: Deve ser preenchido com 2 para emitentes de NF-e e pelas transportadoras quando estiverem fazendo transporte de carga própria. Deve ser preenchido com 3 para transportador de carga que emitirá à posteriori CT-e Globalizado relacionando as NF-e.', 'value' => '1', 'maxLength' => 1, 'restriction' => '1|2|3', 'type' => "N"})

   /* TAG tpTransp **
    * Devido as validações da NT 2021/002 do MDFe que entraram em vigor 02/08/2021, alguns passaram a receber a rejeição
    * "745 Rejeição: O tipo de transportador não ser informado quando não estiver informado proprietário do veículo de tração"
    * Como todo agente de carga e transportadora usam veículo próprio, essa tag deve ser omitida para evitar o erro 745
   */
   ::tpTransp := Telement():new({'name' => 'tpTransp', 'documenttion' => 'Tipo do Transportador' + CRLF + '1 - ETC; 2 - TAC; 3 - CTC', 'value' => '', 'maxLength' => 1, 'restriction' => '1|2|3', 'type' => "N", 'required' => False})
   ::mod := Telement():new({'name' => "mod", 'documentation' => "Modelo do Manifesto Eletrônico", 'minLength' => 2, 'value' => "58", 'type' => "N"})
   ::serie := Telement():new({'name' => "serie", 'documentation' => 'Série do Manifesto' + CRLF + 'Informar a série do documento fiscal (informar zero se inexistente). Série na faixa [920-969]: Reservada para emissão por contribuinte pessoa física com inscrição estadual.', 'minLength' => 3, 'value' => "1", 'type' => "N"})
   ::nMDF := Telement():new({'name' => "nMDF", 'documentation' => "Número do Manifesto", 'maxLength' => 9, 'type' => "N"})
   ::cMDF := Telement():new({'name' => "cMDF", 'documentation' => "Código numérico que compõe a Chave de Acesso", 'minLength' => 8, 'type' => "N"})
   ::cDV := Telement():new({'name' => "cDV", 'documentation' => "Digito Verificador da chave de acesso do Manifesto" + CRLF + "Informar o dígito  de controle da chave de acesso do Manifesto, que deve ser calculado com a aplicação do algoritmo módulo 11 (base 2,9) da chave de acesso.", 'minLength' => 1, 'value' => "0", 'restriction' => "0|1|2|3|4|5|6|7|8|9", 'type' => "N"})
   ::modal := Telement():new({'name' => "modal", 'documentation' => "Modalidade de transporte" + CRLF + "01-Rodoviário; 02-Aéreo; 03-Aquaviário; 04-Ferroviário;", 'value' => "1", 'minLength' => 1, 'restriction' => "1|2|3|4", 'type' => "N"})
   ::dhEmi := Telement():new({'name' => "dhEmi", 'documentation' => "Data e hora de emissão do Manifesto [Formato:  AAAA-MM-DDTHH:MM:DD TZD]", 'minLength' => 25, 'value' => "AAAA-MM-DDTHH:MM:SS-03:00", 'type' => "TZD"})
   ::tpEmis := Telement():new({'name' => "tpEmis", 'documentation' => "Forma de emissão do Manifesto. Preencher com: 1 - Normal; 2 - Contigência", 'minLength' => 1, 'value' => "1", 'restriction' => "1|2", 'type' => "N"})
   ::procEmi := Telement():new({'name' => "procEmi", 'documentation' => "Identificador do processo de emissão do Manifesto. 0 - Emissão de MDF-e com aplicativo do contribuinte", 'value' => "0", 'minLength' => 1, 'restriction' => "0", 'type' => "N"})
   ::verProc := Telement():new({'name' => "verProc", 'documentation' => "Versão do processo de emissão" + CRLF + "Informar a versão do aplicativo emissor de MDF-e.", 'value' => "1.0.0", 'minLength' => 1, 'maxLength' => 20})
   ::UFIni := Telement():new({'name' => "UFIni", 'documentation' => "Sigla da UF do Carregamento" + CRLF + "Informar 'EX' para operações com o exterior.", 'minLength' => 2, 'restriction' => SIGLA_UF})
   ::UFFim := Telement():new({'name' => "UFFim", 'documentation' => "Sigla da UF do Descarregamento" + CRLF + "Informar 'EX' para operações com o exterior.", 'minLength' => 2, 'restriction' => SIGLA_UF})
   ::infMunCarrega := Telement():new({'name' => 'infMunCarrega', 'documentation' => 'Informações dos Municípios de Carregamento', 'value' => {}, 'type' => 'A', 'minLength' => 1, 'maxLength' => 50})
   ::infPercurso := Telement():new({'name' => 'infPercurso', 'documentation' => 'Informações do Percurso do MDF-e', 'value' => {}, 'type' => 'A', 'minLength' => 0, 'maxLength' => 25, 'required' => False})
return self

method add_infMunCarrega(p) class TideMDFe
   local add_status := (hmg_len(::infMunCarrega:value) < ::infMunCarrega:maxLength)
   // p := {'cMunCarrega' => q:getField('cMunCarrega'), 'xMunCarrega' => q:getField('xMunCarrega')}
   if add_status
      AAdd(::infMunCarrega:value, TinfMunCarrega():new(p))
   endif
return add_status

method add_infPercurso(p) class TideMDFe
   local add_status := (hmg_len(::infPercurso:value) < ::infPercurso:maxLength)
   if add_status
      AAdd(::infPercurso:value, TinfPercurso():new(p))
   endif
return add_status
