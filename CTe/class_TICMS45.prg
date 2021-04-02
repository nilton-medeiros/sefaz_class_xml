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


class TICMS45
	data documentation
	data submit
	data value READONLY
	data CST
	method new() constructor
	method clear()
end class

method new() class TICMS45
	::documentation := "ICMS45 | ICMS Isento, não Tributado ou diferido"
	::submit := False
	::value := "TICMS45"
	::CST := Telement():new({'name' => "CST", 'documentation' => "Classificação Tributária do Serviço"+CRLF+"Preencher com:"+CRLF+;
															"40 - ICMS isenção;"+CRLF+;
															"41 - ICMS não tributada;"+CRLF+;
															"51 - ICMS diferido",;
									'minLength' => 2, 'restriction' => "40|41|51", 'type' => "N"})
return self

method clear() class TICMS45
	::submit := False
	::CST:value := ""
return nil
