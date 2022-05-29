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


class TveicNovos
   data documentation readonly
   data value readonly
   data chassi
   data cCor
   data xCor
   data cMod
   data vUnit
   data vFrete
   method new() constructor
end class

method new() class TveicNovos
   ::documentation := "veicNovos | informações dos veículos transportados"
   ::value := "TveicNovos"
   ::chassi := Telement():new({'name' => "chassi", 'documentation' => "Chassi do veículo", 'minLength' => 17})
   ::cCor := Telement():new({'name' => "cCor", 'documentation' => "Cor do veículo", 'maxLength' => 4})
   ::xCor := Telement():new({'name' => "xCor", 'documentation' => "Descrição da cor", 'maxLength' => 40})
   ::cMod := Telement():new({'name' => "cMod", 'documentation' => "Código Marca Modelo", 'maxLength' => 6})
   ::vUnit := Telement():new({'name' => "vUnit", 'documentation' => "Valor Unitário do Veículo", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
   ::vFrete := Telement():new({'name' => "vFrete", 'documentation' => "Frete Unitário", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
return self
