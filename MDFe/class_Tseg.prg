#include <hmg.ch>
#include "hbclass.ch"


class Tseg
   data documentation
   data value
   data submit
   data infResp
   data infSeg
   data nApol
   data nAver
   method new() constructor
   method add_nAver()
end class

method new(p) class Tseg
   ::documentation := 'seg | Informações de Seguro da Carga'
   ::value := 'Tseg'
   ::submit := True
   // {'respSeg' => '1', 'xSeg' => emitente:getField('seguradora'), 'nApol' => emitente:getField('apolice'), 'CNPJ' => emitente:getField('CNPJ')}
   ::infResp := {'respSeg' => Telement():new({'name' => 'respSeg', 'value' => p['respSeg'], 'documentation' => 'Responsável pelo seguro' + CRLF + 'Preencher com: 1- Emitente do MDF-e; 2 - Responsável pela contratação do serviço de transporte (contratante) Dados obrigatórios apenas no modal Rodoviário, depois da lei 11.442/07. Para os demais modais esta informação é opcional.', 'maxLength' => 1, 'type' => 'N', 'restriction' => '1|2'}),;
                 'CNPJ' => Telement():new({'name' => 'CNPJ', 'documentation' => 'Número do CNPJ do responsável pelo seguro', 'value' => hb_HGetDef(p, 'CNPJ', ''), 'minLength' => 14, 'type' => 'N', 'required' => (p['respSeg'] == '2')}),;
                 'CPF' => Telement():new({'name' => 'CPF', 'documentation' => 'Número do CPF do responsável pelo seguro', 'value' => hb_HGetDef(p, 'CPF', ''), 'minLength' => 11, 'type' => 'N', 'required' => (p['respSeg'] == '2' .and. Empty(hb_HGetDef(p, 'CNPJ', '')))})}
   ::infSeg := Telement():new({'name' => 'infSeg', 'documentation' => 'Informações da seguradora', 'value' => {'xSeg' => hb_HGetDef(p, 'xSeg', ''), 'segCNPJ' => hb_HGetDef(p, 'segCNPJ', '')}, 'minLength' => 0, 'maxLength' => 1, 'required' => False, 'type' => 'H'})
   ::nApol := Telement():new({'name' => 'nApol', 'documentation' => 'Número da Apólice; Obrigatório pela lei 11.442/07 (RCTRC)', 'value' => hb_HGetDef(p, 'nApol', ''), 'required' => False, 'minLength' => 1, 'maxLength' => 20})
   ::nAver := Telement():new({'name' => 'nAver', 'documentation' => 'Número da Averbação; Informar as averbações do seguro', 'value' => {}, 'minLength' => 0, 'maxLength' => 99999, 'type' => 'A', 'required' => False})
return self

method add_nAver(nAver) class Tseg
   local add_status := (hmg_len(::nAver:value) < ::nAver:maxLength)
   if (add_status)
      AAdd(::nAver:value, Telement():new({'name' => 'nAver', 'documentation' => 'Número da Averbação', 'value' => nAver, 'maxLength' => 40, 'required' => False}))
   endif
return add_status
