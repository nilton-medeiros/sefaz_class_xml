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


class TnatCarga
   data documentation readonly
   data value readonly
   data xDime
   data cInfManu
   method new() constructor
   method addcInfManu(infManu)
end class

method new() class TnatCarga
   ::documentation := "natCarga | Natureza da carga"
   ::value := "TnatCarga"
   ::xDime := Telement():new({'name' => "xDime", 'documentation' => "Dimensão", 'required' => False, 'minLength' => 4, 'maxLength' => 14})
   ::cInfManu := {}
return self

method addcInfManu(infManu) class TnatCarga
   local add_status := (infManu $ "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|99")
   local oInfManu
   if (add_status)
      oInfManu := Telement():new({'name' => "cInfManu", 'documentation' => "Informações de manuseio", 'required' => False,;
         'value' => infManu, 'minLength' => 2, 'restriction' => "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|99", 'eType' => "C"})
      AAdd(::cInfManu, oInfManu)
   endif
return add_status
