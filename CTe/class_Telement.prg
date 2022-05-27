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


class Telement
	data documentation READONLY
	data name READONLY
	data raw
	data value
	data minLength READONLY
	data maxLength READONLY
	data restriction READONLY
	data required READONLY
	data eType READONLY
	method new(p) constructor
	method setRequired(isRequired)
end class

method new(p) class Telement
	::documentation := hb_HGetDef(p, 'documentation', "Elemento padrão")
	::name := hb_HGetDef(p, 'name', "tagNaoDefinida")
   ::value := hb_HGetDef(p, 'value', "")
   if !(ValType(::value) $ 'C|A|H')
      saveLog('Value de elemento não é String ou Array; Type: ' + ValType(::value) + ' | Chamado de: ' + AllTrim(ProcName(1)) + '(' + hb_ntos(ProcLine(1)) + ')')
   endif
	::raw := ''
	::minLength := hb_HGetDef(p, 'minLength', 1)
	::maxLength := hb_HGetDef(p, 'maxLength', ::minLength)
	::restriction := hb_HGetDef(p, 'restriction', "")
	::required := hb_HGetDef(p, 'required', True)
	::eType := hb_HGetDef(p, 'type', hb_HGetDef(p, 'eType', "C"))
   if (::eType == 'C') .and. (Len(::value) > ::maxLength)
      ::value := Left(AllTrim(::value), ::maxLength)
   endif
return self

method setRequired(isRequired) class Telement
	::required := isRequired
return Nil