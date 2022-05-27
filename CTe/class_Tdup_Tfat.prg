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


class Tdup
	data documentation init "dup | Dados das duplicatas"
	data value init "Tdup"
	data nDup
	data dVenc
	data vDup

	method new(dup) constructor

end class

method new(dup) class Tdup
	::nDup := Telement():new({'name' => "CNPJ", 'documentation' => "Número da duplicata", 'value' => dup['nDup'], 'required' => False, 'maxLength' => 60})
	::dVenc := Telement():new({'name' => "CNPJ", 'documentation' => "Data de vencimento da duplicata (AAAA-MM-DD)", 'value' => dup['dVenc'], 'required' => False, 'minLength' => 10, 'type' => "D"})
	::vDup := Telement():new({'name' => "CNPJ", 'documentation' => "Valor da duplicata", 'value' => dup['vDup'], 'required' => False, 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
return self


class Tfat
	data documentation
	data value
	data nFat
	data vOrig
	data vDesc
	data vLiq
	method new() constructor
end class

method new() class Tfat
	::documentation := "fat | Dados da fatura"
	::value := "Tfat"
	::nFat := Telement():new({'name' => "nFat", 'documentation' => "Número da fatura", 'required' => False, 'maxLength' => 60})
	::vOrig := Telement():new({'name' => "vOrig", 'documentation' => "Valor original da fatura", 'required' => False, 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vDesc := Telement():new({'name' => "vDesc", 'documentation' => "Valor do desconto da fatura", 'required' => False, 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vLiq := Telement():new({'name' => "vLiq", 'documentation' => "Valor líquido da fatura", 'required' => False, 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
return self
