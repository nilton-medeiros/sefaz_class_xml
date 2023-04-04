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

 // Classe será removida na versão 4.00 do CT-e
class TinfCteSub
	data documentation
	data value
	data chCte
	data refCteAnu
	data tomaICMS
	data indAlteraToma
	method new() constructor
end class

method new() class TinfCteSub
	::documentation := "infCteSub | Informações do CT-e de substituição"
	::value := "TinfCteSub"
	::chCte := Telement():new({'name' => "chCte", 'documentation' => "Chave de acesso do CT-e a ser substituído (original)", 'minLength' => 44, 'type' => "N"})
	::refCteAnu := Telement():new({'name' => "refCteAnu", 'documentation' => "Chave de acesso do CT-e de Anulação", 'minLength' => 44, 'type' => "N"})
	::tomaICMS := TtomaICMS():new()
	::indAlteraToma := Telement():new({'name' => "indAlteraToma", 'documentation' => "Indicador de CT-e Alteração de Tomador", 'required' => False, 'maxLength' => 1, 'restriction' => "1", 'type' => "N"})
return self
