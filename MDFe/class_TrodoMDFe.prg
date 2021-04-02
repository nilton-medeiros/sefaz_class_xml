#include <hmg.ch>
#include "hbclass.ch"

#define SIGLA_UF "RO|AC|AL|AM|AP|BA|CE|DF|ES|EX|GO|MA|MG|MS|MT|PA|PB|PE|PI|PR|RJ|RN|RR|RS|SC|SE|SP|TO"


class TrodoMDFe
   data documentation READONLY
   data submit
   data value
   data infANTT
   data veicTracao
   data veicReboque
   data codAgPorto
   data lacRodo
   method new() constructor
   method add_veicReboque()
   method add_lacRodo()
end class

method new() class TrodoMDFe
   ::documentation := 'rodo | Informações do modal Rodoviário'
   ::submit := False
   ::value := 'TrodoMDFe'
   ::infANTT := TinfANTT():new()
   ::veicTracao := TveicTracao():new()
   ::veicReboque := Telement():new({'name' => 'veicReboque', 'documentation' => 'Dados dos reboques', 'value' => {}, 'minLength' => 0, 'maxLength' => 3, 'type' => 'A'})
   ::codAgPorto := Telement():new({'name' => 'codAgPorto', 'documentation' => 'Código de Agendamento no porto', 'required' => False, 'minLength' => 0, 'maxLength' => 16})
   ::lacRodo := Telement():new({'name' => 'lacRodo', 'documentation' => 'Lacres', 'value' => {}, 'required' => False, 'minLength' => 0, 'maxLength' => 99999, 'type' => 'A'})
return self

method add_lacRodo(lacre) class TrodoMDFe
   local add_status := (hmg_len(::lacRodo:value) < ::lacRodo:maxLength)
   if add_status
      AAdd(::lacRodo:value, Telement():new({'name' => 'nLacre', 'documentation' => 'Número do Lacre', 'value' => lacre, 'maxLength' => 20}))
   endif
return add_status

method add_veicReboque(r)
   local add_status := (hmg_len(::veicReboque:value) < ::veicReboque:maxLength)
   if add_status
      AAdd(::veicReboque:value, TveicReboque():new(r))
   endif
return add_status


class TinfANTT
   data documentation
   data submit
   data RNTRC
   data infCIOT
   data valePed
   data infContratante
   method new() constructor
   method add_infCIOT()
   method add_infContratante()
end class

method new() class TinfANTT
   ::documentation := 'infANTT | Grupo de informações para Agência Reguladora'
   ::submit := False
   ::RNTRC := Telement():new({'name' => 'RNTRC', 'documentation' => 'Registro Nacional de Transportadores Rodoviários de Carga' + CRLF + 'Registro obrigatório do emitente do MDF-e junto à ANTT para exercer a atividade de transportador rodoviário de cargas por conta de terceiros e mediante remuneração.', 'required' => False, 'type' => 'N', 'minLength' => 8})
   ::infCIOT := Telement():new({'name' => 'infCIOT', 'documentation' => 'Dados do CIOT', 'value' => {}, 'minLength' => 0, 'maxLength' => 99999, 'required' => False, 'type' => 'A'})
   ::valePed := TvalePed():new()
   ::infContratante := Telement():new({'name' => 'infContratante', 'documentation' => 'Grupo de informações dos contratantes do serviço de transporte', 'value' => {}, 'minLength' => 0, 'maxLength' => 99999, 'required' => False, 'type' => 'A'})
return self

method add_infCIOT(infCiot) class TinfANTT
   local add_status := (hmg_len(::infCIOT:value) < ::infCIOT:maxLength)
   if add_status
      AAdd(::infCIOT:value, TinfCIOT():new(infCiot))
   endif
return add_status

method add_infContratante(infContr) class TinfANTT
   local add_status := (hmg_len(::infContratante:value) < ::infContratante:maxLength)
   if add_status
      AAdd(::infContratante:value, TinfContratante():new(infContr))
   endif
return add_status


class TinfContratante
   data CPF
   data CNPJ
   method new() constructor
end class

method new(infContr) class TinfContratante
   ::CPF := Telement():new({'name' => 'CPF', 'documentation' => 'Número do CPF do contratente do serviço', 'value' => hb_HGetDef(infContr, 'CPF', ''), 'minLength' => 11, 'type' => 'N'})
   ::CNPJ := Telement():new({'name' => 'CNPJ', 'documentation' => 'Número do CNPJ do contratente do serviço', 'value' => hb_HGetDef(infContr, 'CNPJ', ''), 'minLength' => 14, 'type' => 'N'})
return self


class TinfCIOT
   data documentation
   data value
   data CIOT
   data CPF
   data CNPJ
   method new() constructor
end class

method new(infCiot) class TinfCIOT
   ::documentation := 'infCIOT | Dados do CIOT'
   ::value := 'TinfCIOT'
   ::CIOT := Telement():new({'name' => 'CIOT', 'documentation' => 'Código Identificador da Operação de Transporte; Também Conhecido como conta frete', 'value' => infCiot['CIOT'], 'minLength' => 12, 'type' => 'N'})
   ::CPF := Telement():new({'name' => 'CPF', 'documentation' => 'Número do CPF responsável pela geração do CIOT; Informar os zeros não significativos.', 'value' => hb_HGetDef(infCiot, 'CPF', ''), 'minLength' => 11, 'type' => 'N'})
   ::CNPJ := Telement():new({'name' => 'CNPJ', 'documentation' => 'Número do CNPJ responsável pela geração do CIOT; Informar os zeros não significativos.', 'value' => hb_HGetDef(infCiot, 'CNPJ', ''), 'minLength' => 14, 'type' => 'N'})
return self


class TvalePed
   data documentation
   data submit
   data value
   data disp
   method new() constructor
   method add_disp()
end class

method new() class TvalePed
   ::documentation := 'valePed | Informações de Vale Pedágio'
   ::submit := False
   ::value := 'TvalePed'
   ::disp := Telement():new({'name' => 'disp', 'documentation' => 'Informações dos dispositivos do Vale Pedágio', 'value' => {}, 'type' => 'A', 'maxLength' => 99999})
return self

method add_disp(infDisp) class TvalePed
   local add_status := (hmg_len(::disp:value) < ::disp:maxLength)
   if add_status
      AAdd(::disp:value, Tdisp():new(infDisp))
   endif
return add_status


class Tdisp
   data documentation
   data value
   data CNPJForn
   data CNPJPg
   data CPFPg
   data nCompra
   data vValePed
   method new() constructor
end class

method new(valePed) class Tdisp
   // {'CNPJForn' => q:getField('CNPJForn'), 'CNPJPg' => q:getField('CNPJPg'), 'nCompra' => q:getField('nCompra'), 'vValePed' => q:getField('vValePed')}
   ::documentation := 'disp | Informações dos dispositivos do Vale Pedágio'
   ::value := 'Tdisp'
   ::CNPJForn := Telement():new({'name' => 'CNPJForn', 'documentation' => 'CNPJ da empresa fornecedora do Vale-Pedágio', 'value' => valePed['CNPJForn'], 'minLength' => 14, 'type' => 'N'})
   ::CNPJPg := Telement():new({'name' => 'CNPJPg', 'documentation' => 'CNPJ do responsável pelo pagamento do Vale-Pedágio' + CRLF + 'Responsável pelo pagamento do Vale Pedágio. Informar somente quando o responsável não for o emitente do MDFe. - Informar os zeros não significativos.', 'value' => hb_HGetDef(valePed, 'CNPJPg', ''), 'minLength' => 14, 'type' => 'N'})
   ::CPFPg := Telement():new({'name' => 'CPFPg', 'documentation' => 'CPF do responsável pelo pagamento do Vale-Pedágio' + CRLF + 'Responsável pelo pagamento do Vale Pedágio. Informar somente quando o responsável não for o emitente do MDFe. - Informar os zeros não significativos.', 'value' => hb_HGetDef(valePed, 'CPFPg', ''), 'minLength' => 11, 'type' => 'N'})
   ::nCompra := Telement():new({'name' => 'nCompra', 'documentation' => 'Número do comprovante de compra' + CRLF + 'Número de ordem do comprovante de compra do Vale-Pedágio fornecido para cada veículo ou combinação veicular, por viagem', 'value' => valePed['nCompra'], 'maxLength' => 20, 'type' => 'N'})
   ::vValePed := Telement():new({'name' => 'vValePed', 'documentation' => 'Valor do Vale-Pedagio' + CRLF + 'Valor de ordem do comprovante de compra do Vale-Pedágio fornecido para cada veículo ou combinação veicular, por viagem', 'value' => valePed['vValePed'], 'minLength' => 4, 'maxLength' => 16, 'type' => 'N'})
return self


class TveicTracao
   data documentation
   data value
   data cInt
   data placa
   data RENAVAM
   data tara
   data capKG
   data capM3
   data prop
   data condutor
   data tpRod
   data tpCar
   data UF
   method new() constructor
   method add_condutor()
end class

method new() class TveicTracao
   ::documentation := 'veicTracao | Dados do Veículo com a Tração'
   ::value := 'TveicTracao'
   ::cInt := Telement():new({'name' => 'cInt', 'documentation' => 'Código interno do veículo', 'minLength' => 1, 'maxLength' => 10, 'required' => False})
   ::placa := Telement():new({'name' => 'placa', 'documentation' => 'Placa do veículo', 'minLength' => 4})
   ::RENAVAM := Telement():new({'name' => 'RENAVAM', 'documentation' => 'RENAVAM do veículo', 'minLength' => 9, 'maxLength' => 11, 'required' => False})
   ::tara := Telement():new({'name' => 'tara', 'documentation' => 'Tara em KG', 'minLength' => 1, 'maxLength' => 6, 'type' => 'N'})
   ::capKG := Telement():new({'name' => 'capKG', 'documentation' => 'Capacidade em KG', 'minLength' => 1, 'maxLength' => 6, 'required' => False, 'type' => 'N'})
   ::capM3 := Telement():new({'name' => 'capM3', 'documentation' => 'Capacidade em M3', 'minLength' => 1, 'maxLength' => 3, 'required' => False, 'type' => 'N'})
   ::prop := Tprop():new()
   ::condutor := Telement():new({'name' => 'condutor', 'documentation' => 'Informações do(s) Condutor(es) do veículo', 'value' => {}, 'maxLength' => 10, 'type' => 'A'})
   ::tpRod := Telement():new({'name' => 'tpRod', 'documentation' => 'Tipo de Rodado' + CRLF + 'Preencher com: 01 - Truck; 02 - Toco; 03 - Cavalo Mecânico; 04 - VAN; 05 - Utilitário; 06 - Outros.', 'minLength' => 2, 'restriction' => '01|02|03|04|05|06', 'type' => 'N'})
   ::tpCar := Telement():new({'name' => 'tpCar', 'documentation' => 'Tipo de Carroceria' + CRLF + 'Preencher com: 00 - não aplicável; 01 - Aberta; 02 - Fechada/Baú; 03 - Granelera; 04 - Porta Container; 05 - Sider', 'minLength' => 2, 'restriction' => '00|01|02|03|04|05', 'type' => 'N'})
   ::UF := Telement():new({'name' => 'UF', 'documentation' => 'UF em que veículo está licenciado', 'minLength' => 2, 'restriction' => SIGLA_UF})
return self

method add_condutor(infCond) class TveicTracao
   local add_status := (hmg_len(::condutor:value) < ::condutor:maxLength)
   if add_status
      AAdd(::condutor:value, Tcondutor():new(infCond))
   endif
return add_status


class Tprop
   data documentation
   data submit
   data value
   data CPF
   data CNPJ
   data RNTRC
   data xNome
   data IE
   data UF
   data tpProp
   method new() constructor
end class

method new() class Tprop
   ::documentation := 'prop | Proprietários do Veículo. Só preenchido quando o veículo não pertencer à empresa emitente do MDF-e'
   ::submit := False
   ::value := 'Tprop'
   ::CPF := Telement():new({'name' => 'CPF', 'documentation' => 'Número do CPF; Informar os zeros não significativos.', 'minLength' => 11, 'type' => 'N'})
   ::CNPJ := Telement():new({'name' => 'CNPJ', 'documentation' => 'Número do CNPJ; Informar os zeros não significativos.', 'minLength' => 14, 'type' => 'N'})
   ::RNTRC := Telement():new({'name' => 'RNTRC', 'documentation' => 'Registro Nacional dos Transportadores Rodoviários de Carga' + CRLF + 'Registro obrigatório do proprietário, coproprietário ou arrendatário do veículo junto à ANTT para exercer a atividade de transportador rodoviário de cargas por conta de terceiros e mediante remuneração.', 'minLength' => 8, 'type' => 'N'})
   ::xNome := Telement():new({'name' => 'xNome', 'documentation' => 'Razão Social ou Nome do proprietário', 'minLength' => 2, 'maxLength' => 60})
   ::IE := Telement():new({'name' => 'IE', 'documentation' => 'Inscrição Estadual', 'minLength' => 0, 'maxLength' => 14, 'required' => False})
   ::UF := Telement():new({'name' => 'UF', 'documentation' => 'UF', 'minLength' => 2, 'restriction' => SIGLA_UF})
   ::tpProp := Telement():new({'name' => 'tpProp', 'documentation' => 'Tipo Proprietário; Preencher com: 0-TAC – Agregado; 1-TAC Independente; ou 2 – Outros.', 'minLength' => 1, 'restriction' => '0|1|2'})
return self


class TveicReboque
   data documentation
   data submit
   data value
   data cInt
   data placa
   data RENAVAM
   data tara
   data capKG
   data capM3
   data prop
   data tpCar
   data UF
   method new() constructor
end class

method new(reboque) class TveicReboque
   ::documentation := 'veicReboque | Dados dos reboques'
   ::submit := False
   ::value := 'TveicReboque'
   ::cInt := Telement():new({'name' => 'cInt', 'documentation' => 'Código interno do veículo', 'value' => reboque['cInt'], 'minLength' => 1, 'maxLength' => 10, 'required' => False})
   ::placa := Telement():new({'name' => 'placa', 'documentation' => 'Placa do veículo', 'value' => reboque['placa'], 'minLength' => 4})
   ::RENAVAM := Telement():new({'name' => 'RENAVAM', 'documentation' => 'RENAVAM do veículo', 'value' => reboque['RENAVAM'], 'minLength' => 9, 'maxLength' => 11, 'required' => False})
   ::tara := Telement():new({'name' => 'tara', 'documentation' => 'Tara em KG', 'value' => reboque['tara'], 'minLength' => 1, 'maxLength' => 6, 'type' => 'N'})
   ::capKG := Telement():new({'name' => 'capKG', 'documentation' => 'Capacidade em KG', 'value' => reboque['capKG'], 'minLength' => 1, 'maxLength' => 6, 'required' => False, 'type' => 'N'})
   ::capM3 := Telement():new({'name' => 'capM3', 'documentation' => 'Capacidade em M3', 'value' => reboque['capM3'], 'minLength' => 1, 'maxLength' => 3, 'required' => False, 'type' => 'N'})
   ::prop := Tprop():new()
   ::tpCar := Telement():new({'name' => 'tpCar', 'documentation' => 'Tipo de Carroceria' + CRLF + 'Preencher com: 00 - não aplicável; 01 - Aberta; 02 - Fechada/Baú; 03 - Granelera; 04 - Porta Container; 05 - Sider', 'value' => reboque['tpCar'], 'minLength' => 2, 'restriction' => '00|01|02|03|04|05', 'type' => 'N'})
   ::UF := Telement():new({'name' => 'UF', 'documentation' => 'UF em que veículo está licenciado', 'value' => reboque['UF'], 'minLength' => 2, 'restriction' => SIGLA_UF})
return self


class Tcondutor
   data documentation
   data value
   data xNome
   data CPF
   method new() constructor
end class

method new(infCond) class Tcondutor
   ::documentation := 'condutor | Informações do(s) Condutor(es) do veículo'
   ::value := 'Tcondutor'
   ::xNome := Telement():new({'name' => 'xNome', 'documentation' => 'Nome do Condutor', 'value' => infCond['xNome'], 'minLength' => 2, 'maxLength' => 60})
   ::CPF := Telement():new({'name' => 'CPF', 'documentation' => 'CPF do Condutor', 'value' => infCond['CPF'], 'minLength' => 11, 'type' => 'N'})
return self
