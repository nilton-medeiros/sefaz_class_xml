#include <hmg.ch>
#include "hbclass.ch"


class TinfMDFe
   data documentation READONLY
   data value READONLY
   data versao
   data Id
   data ide
   data emit
   data infModal
   data infDoc
   data seg
   data prodPred
   data tot
   data lacres
   data autXML
   data infAdic
   data infRespTec
   method new() constructor
   method add_seg()
   method add_lacres()
   method add_autXML()
end class

method new() class TinfMDFe
   ::documentation := "infMDFe | Informações do MDF-e"
   ::value := "TinfMDFe"
   ::versao := Telement():new({'name' => "versao", 'documentation' => "Versão do leiaute", 'minLength' => 4, 'maxLength' => 5, 'type' => "N"})
   ::Id := Telement():new({'name' => "Id", 'documentation' => 'Identificador da tag a ser assinada' + CRLF + 'Informar a chave de acesso do MDF-e e precedida do literal "MDFe"', 'minLength' => 47})
   ::ide := TideMDFe():new()
   ::emit := Temit():new(False)
   ::infModal := TinfModalMDFe():new()
   ::infDoc := TinfDocMDFe():new()
   ::seg := Telement():new({'name' => 'seg', 'documentation' => 'Informações de Seguro da Carga', 'value' => {}, 'minLength' => 0, 'maxLength' => 99999, 'type' => 'A', 'required' => False})
   ::prodPred := TprodPred():new()
   ::tot := Ttot():new()
   ::lacres := Telement():new({'name' => 'lacres', 'documentation' => 'Lacres do MDF-e', 'value' => {}, 'minLength' => 0, 'maxLength' => 99999, 'type' => 'A', 'required' => False})
   ::autXML := Telement():new({'name' => "autXML", 'documentation' => "Autorizados para download do XML do DF-e", 'value' => {}, 'minLength' => 0, 'maxLength' => 10, 'type' => "A", 'required' => False})
   ::infAdic := TinfAdic():new()
   ::infRespTec := TinfRespTec():new()
return self

method add_seg(p) class TinfMDFe
   local add_status := (hmg_len(::seg:value) < ::seg:maxLength)
   if (add_status)
      AAdd(::seg:value, Tseg():new(p))
   endif
return add_status

method add_lacres(nLacre) class TinfMDFe
   local add_status := (hmg_len(::lacres:value) < ::lacres:maxLength)
   if (add_status)
      AAdd(::lacres:value, Telement():new({'name' => 'nLacre', 'documentation' => 'número do lacre', 'value' => nLacre, 'maxLength' => 60}))
   endif
return add_status

method add_autXML(p) class TinfMDFe
   local add_status := (hmg_len(::autXML:value) < ::autXML:maxLength)
   if (add_status)
      AAdd(::autXML:value, TautXML():new(p))
   endif
return add_status


class Ttot
   data documentation
   data value
   data qCTe
   data vCarga
   data cUnid
   data qCarga
   method new() constructor
end class

method new() class Ttot
   ::documentation := 'tot | Totalizadores da carga transportada e seus documentos fiscais'
   ::value := 'Ttot'
   ::qCTe := Telement():new({'name' => 'qCTe', 'documentation' => 'Quantidade total de CT-e relacionados no Manifesto', 'required' => False, 'maxLength' => 6, 'type' => 'N'})
   ::vCarga := Telement():new({'name' => 'vCarga', 'documentation' => 'Valor total da carga / mercadorias transportadas', 'minLength' => 4, 'maxLength' => 16, 'type' => 'N'})
   ::cUnid := Telement():new({'name' => 'cUnid', 'documentation' => 'Código da unidade de medida do Peso Bruto da Carga / Mercadorias transportadas' + CRLF + 'Preencher com: 01 - KG/ 02 - TON', 'minLength' => 2, 'restriction' => '01|02', 'type' => 'N'})
   ::qCarga := Telement():new({'name' => 'qCarga', 'documentation' => 'Peso Bruto Total da Carga / Mercadorias transportadas', 'minLength' => 6, 'maxLength' => 16, 'type' => 'N'})
return self


class TinfAdic
   data documentation
   data value
   data infAdFisco
   data infCpl
   method new() constructor
end class

method new() class TinfAdic
   ::documentation := 'Informações Adicionais'
   ::value := 'infAdic'
   ::infAdFisco := Telement():new({'name' => 'infAdFisco', 'documentation' => 'Informações adicionais de interesse do Fisco', 'maxLength' => 2000, 'required' => False})
   ::infCpl := Telement():new({'name' => 'infCpl', 'documentation' => 'Informações complementares de interesse do Contribuinte', 'maxLength' => 5000, 'required' => False})
return self