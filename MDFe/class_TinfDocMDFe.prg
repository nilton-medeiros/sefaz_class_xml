#include <hmg.ch>
#include "hbclass.ch"


class TinfDocMDFe
   data documentation READONLY
   data value READONLY
   data infMunDescarga
   method new() constructor
   method add_infMunDescarga()
end class

method new() class TinfDocMDFe
   ::documentation := 'infDoc-MDFe | Informações dos Documentos fiscais vinculados ao manifesto'
   ::value := 'TinfDocMDFe'
   ::infMunDescarga := Telement():new({'name' => 'infMunDescarga', 'documentation' => 'Informações dos Municípios de descarregamento', 'value' => {}, 'minLength' => 1, 'maxLength' => 100, 'type' => 'A'})
return self

method add_infMunDescarga(p) class TinfDocMDFe
   local add_status := (hmg_len(::infMunDescarga:value) < ::infMunDescarga:maxLength)
   if add_status
      AAdd(::infMunDescarga:value, TinfMunDescarga():new(p))
   endif
return add_status


class TinfMunDescarga
   data documentation
   data value
   data cMunDescarga
   data xMunDescarga
   data infCTe
   data infNFe
   method new() constructor
   method add_infCTe()
   method add_infNFe()
end class

method new(p) class TinfMunDescarga
   // p = {'cMunDescarga' => q:getField('cMunDescarga'), 'xMunDescarga' => q:getField('xMunDescarga')}
   ::documentation := 'infMunDescarga | Informações dos Municípios de descarregamento'
   ::value := 'TinfMunDescarga'
   ::cMunDescarga := Telement():new({'name' => 'cMunDescarga', 'documentation' => 'Código do Município de Descarregamento', 'value' => p['cMunDescarga'], 'minLength' => 7, 'type' => 'N'})
   ::xMunDescarga := Telement():new({'name' => 'xMunDescarga', 'documentation' => 'Nome do Município de Descarregamento', 'value' => p['xMunDescarga'], 'minLength' => 2, 'maxLength' => 60})
   ::infCTe := Telement():new({'name' => 'infCTe', 'documentation' => 'Conhecimentos de Transporte - usar este grupo quando for prestador de serviço de transporte', 'value' => {}, 'minLength' => 0, 'maxLength' => 10000, 'type' => 'A', 'required' => False})
   ::infNFe := Telement():new({'name' => 'infNFe', 'documentation' => 'Nota Fiscal Eletronica', 'value' => {}, 'minLength' => 0, 'maxLength' => 10000, 'type' => 'A', 'required' => False})
return self

method add_infCTe(chCTe) class TinfMunDescarga
   local add_status := (hmg_len(::infCTe:value) < ::infCTe:maxLength)
   if add_status
      AAdd(::infCTe:value, Telement():new({'name' => 'chCTe', 'documentation' => 'Conhecimento Eletrônico - Chave de Acesso', 'value' => chCTe, 'minLength' => 44, 'type' => 'N'}))
   endif
return add_status

method add_infNFe(chNFe) class TinfMunDescarga
   local add_status := (hmg_len(::infNFe:value) < ::infNFe:maxLength)
   if add_status
      AAdd(::infNFe:value, Telement():new({'name' => 'chNFe', 'documentation' => 'Nota Fiscal Eletrônica - Chave de Acesso', 'value' => chNFe, 'minLength' => 44, 'type' => 'N'}))
   endif
return add_status
