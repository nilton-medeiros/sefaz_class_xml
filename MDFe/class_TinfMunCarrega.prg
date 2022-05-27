#include <hmg.ch>
#include "hbclass.ch"

#define SIGLA_UF "RO|AC|AL|AM|AP|BA|CE|DF|ES|EX|GO|MA|MG|MS|MT|PA|PB|PE|PI|PR|RJ|RN|RR|RS|SC|SE|SP|TO"


class TinfMunCarrega
   data documentation READONLY
	data value
   data cMunCarrega
   data xMunCarrega
   method new() constructor
end class

method new(p) class TinfMunCarrega
   // p := {'cMunCarrega' => q:getField('cMunCarrega'), 'xMunCarrega' => q:getField('xMunCarrega')}
   ::documentation := 'infMunCarrega | Informações dos Municípios de Carregamento'
	::value := 'TinfMunCarrega'
   ::cMunCarrega := Telement():new({'name' => 'cMunCarrega', 'value' => p['cMunCarrega'], 'documentation' => 'Código do Município de Carregamento', 'minLength' => 7})
   ::xMunCarrega := Telement():new({'name' => 'xMunCarrega', 'value' => p['xMunCarrega'], 'documentation' => 'Nome do Município de Carregamento', 'minLength' => 2, 'maxLength' => 60})
return self

class TinfPercurso
   data documentation READONLY
	data value
   data UFPer
   data dhIniViagem
   data indCanalVerde
   data indCarregaPosterior
   method new() constructor
end class

method new(p) class TinfPercurso
   p['dhIniViagem'] := hb_HGetDef(p, 'dhIniViagem', "")
   p['indCanalVerde'] := hb_HGetDef(p, 'indCanalVerde', "")
   p['indCarregaPosterior'] := hb_HGetDef(p, 'indCarregaPosterior', "")
   ::documentation := 'infPercurso | Informações dos Municípios de Carregamento'
	::value := 'TinfPercurso'
   ::UFPer := Telement():new({'name' => 'UFPer', 'documentation' => 'Sigla das Unidades da Federação do percurso do veículo.', 'value' => p['UFPer'], 'minLength' => 2, 'restriction' => SIGLA_UF})
   ::dhIniViagem := Telement():new({'name' => "dhIniViagem", 'documentation' => "Data e hora previstos de início da viagem [Formato:  AAAA-MM-DDTHH:MM:DD TZD]", 'minLength' => 25, 'value' => p['dhIniViagem'], 'type' => "TZD", 'required' => False})
   ::indCanalVerde := Telement():new({'name' => "indCanalVerde", 'documentation' => "Indicador de participação do Canal Verde", 'minLength' => 1, 'value' => p['indCanalVerde'], 'type' => "N", 'required' => False})
   ::indCarregaPosterior := Telement():new({'name' => "indCarregaPosterior", 'documentation' => "Indicador de MDF-e com inclusão da Carga posterior a emissão por evento de inclusão de DF-e", 'minLength' => 1, 'value' => p['indCarregaPosterior'], 'type' => "N", 'required' => False})
return self
