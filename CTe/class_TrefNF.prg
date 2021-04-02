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


class TrefNF
	data documentation
	data value
	data CNPJ
	data CPF
	data mod
	data serie
	data subserie
	data nro
	data valor
	data dEmi
	method new() constructor
end class

method new() class TrefNF
	::documentation := "refNF | Informação da NF ou CT emitido pelo Tomador"
	::value := "TrefNF"
	::CNPJ := Telement():new({'name' => "CNPJ", 'documentation' => "CNPJ do Emitente", 'maxLength' => 14, 'type' => "N"})
	::CPF := Telement():new({'name' => "CPF", 'documentation' => "CPF do Emitente", 'maxLength' => 11, 'type' => "N"})
	::mod := Telement():new({'name' => "mod", 'documentation' => "Modelo do Documento Fiscal", 'minLength' => 2, 'maxLength' => 2})
	::serie := Telement():new({'name' => "serie", 'documentation' => "Serie do documento fiscal", 'maxLength' => 3, 'type' => "N"})
	::subserie := Telement():new({'name' => "subserie", 'documentation' => "Subserie do documento fiscal", 'required' => False, 'maxLength' => 3, 'type' => "N"})
	::nro := Telement():new({'name' => "nro", 'documentation' => "Número do documento fiscal", 'maxLength' => 6, 'type' => "N"})
	::valor := Telement():new({'name' => "valor", 'documentation' => "Valor do documento fiscal", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::dEmi := Telement():new({'name' => "dEmi", 'documentation' => "Data de emissão do documento fiscal", 'minLength' => 10, 'type' => "D"})
return self