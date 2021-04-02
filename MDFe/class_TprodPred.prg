#include <hmg.ch>
#include "hbclass.ch"


class TprodPred
   /*
   class: TprodPred
   Projeto: Manifesto Eleletrônico de Documentos Fiscal
   Versão: 1.04 - Março 2020 - Nota Técnica 2020.001 MDF-e Integrado
   Sefaz: https://dfe-portal.svrs.rs.gov.br/Mdfe/Documentos
   */

   data documentation readonly
   data value
   data tpCarga
   data xProd
   data cEAN
   data NCM
   data infLocalCarrega
   data infLocalDescarrega

   method new() constructor

end class

method new() class TprodPred
   ::documentation := 'prodPred | Grupo de informações do Produto predominante da carga do MDF-e'
   ::value := 'prodPred'
   ::tpCarga := Telement():new({'name' => "tpCarga", 'documentation' => "Tipo da Carga", 'minLength' => 2, 'type' => "N", 'restriction' => "01|02|03|04|05|06|07|08|09|10|11"})
   ::xProd := Telement():new({'name' => "xProd", 'documentation' => "Descrição do produto predominante", 'minLength' => 2, 'maxLength' => 120})
   ::cEAN := Telement():new({'name' => "cEAN", 'documentation' => "GTIN (Global Trade Item Number)", 'minLength' => 8, 'minLength' => 14, 'required' => False})
   ::NCM := Telement():new({'name' => "NCM", 'documentation' => "Código NCM", 'minLength' => 8, 'required' => False})
   ::infLocalCarrega := Telement():new({'name' => "CEP", 'documentation' => "CEP onde foi carregado o MDF-e", 'minLength' => 8})
   ::infLocalDescarrega := Telement():new({'name' => "CEP", 'documentation' => "CEP onde foi descarregado o MDF-e", 'minLength' => 8})
return self
