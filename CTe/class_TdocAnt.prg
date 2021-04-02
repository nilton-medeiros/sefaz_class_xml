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

#define SIGLA_UF "AC|AL|AM|AP|BA|CE|DF|ES|EX|GO|MA|MG|MS|MT|PA|PB|PE|PI|PR|RJ|RN|RO|RR|RS|SC|SE|SP|TO"


class TdocAnt
	data documentation READONLY
	data submit
	data value READONLY
	data emiDocAnt
	method new() constructor
	method addEmiDocAnt()
end class

method new() class TdocAnt
	::documentation := "docAnt | Documentos de Transporte Anterior"
	::submit := False
	::value := "TdocAnt"
	::emiDocAnt := Telement():new({'name' => "emiDocAnt", 'documentation' => "Emissor do documento anterior", 'value' => {}, 'maxLength' => 99999, 'type' => "A"})
return self

method addEmiDocAnt() class TdocAnt
	AAdd(::emiDocAnt:value, TemiDocAnt():new())
return ::emiDocAnt:value[hmg_len(::emiDocAnt:value)]


class TemiDocAnt
	data documentation READONLY
	data submit
	data value READONLY
	data CNPJ
	data CPF
	data IE
	data UF
	data xNome
	data idDocAnt
	method new() constructor
	method addIdDocAnt()
end class

method new() class TemiDocAnt
	::documentation := "emiDocAnt | Emissor do documento anterior"
	::submit := False
	::value := "TemiDocAnt"
	::CNPJ := Telement():new({'name' => "CNPJ", 'documentation' => "Número do CNPJ", 'minLength' => 14, 'type' => "N"})
	::CPF := Telement():new({'name' => "CPF", 'documentation' => "Número do CPF", 'minLength' => 11, 'type' => "N"})
	::IE := Telement():new({'name' => "IE", 'documentation' => "Inscrição Estadual", 'maxLength' => 14})
	::UF := Telement():new({'name' => "UF", 'documentation' => "Sigla da UF", 'minLength' => 2, 'restriction' => SIGLA_UF})
	::xNome := Telement():new({'name' => "xNome", 'documentation' => "Razão Social ou Nome do expedidor", 'maxLength' => 60})
	::idDocAnt := Telement():new({'name' => "idDocAnt", 'documentation' => "Informações de identificação dos documentos de Transporte Anterior", 'value' => {}, 'maxLength' => 2, 'type' => "A"})
return self

method addIdDocAnt() class TemiDocAnt
	if (hmg_len(::idDocAnt:value) < ::idDocAnt:maxLength)
		AAdd(::idDocAnt:value, TidDocAnt():new())
	endif
return ::idDocAnt:value[hmg_len(::idDocAnt:value)]


class TidDocAnt
	data documentation init "idDocAnt | Informações de identificação dos documentos de Transporte Anterior" READONLY
	data submit init False
	data value init "TidDocAnt" READONLY
	data idDocAntPap init Telement():new({'name' => "idDocAntPap", 'documentation' => "Documentos de transporte anterior em papel", 'value' => {}, 'maxLength' => 99999, 'type' => "A"})
	data idDocAntEle init Telement():new({'name' => "idDocAntEle", 'documentation' => "Documentos de transporte anterior eletrônicos", 'value' => {}, 'maxLength' => 99999, 'type' => "A"})

	method addIdDocAntPap()
	method addIdDocAntEle()

end class

method addIdDocAntPap() class TidDocAnt
	AAdd(::idDocAntPap:value, TidDocAntPap():new())
return ::idDocAntPap:value[hmg_len(::idDocAntPap:value)]

method addIdDocAntEle() class TidDocAnt
	AAdd(::idDocAntEle:value, TidDocAntEle():new())
return ::idDocAntEle:value[hmg_len(::idDocAntEle:value)]

class TidDocAntPap
	data documentation READONLY
	data submit
	data value READONLY
	data tpDoc
	data serie
	data subser
	data nDoc
	data dEmi
	method new() constructor
end class

method new() class TidDocAntPap
	::documentation := "idDocAntPap | Documentos de transporte anterior em papel"
	::submit := False
	::value := "TidDocAntPap"
	::tpDoc := Telement():new({'name' => "tpDoc", 'documentation' => "Tipo do Documento de Transporte Anterior", 'maxLength' => 2, 'restriction' => "07|08|09|10|11|12|13", 'type' => "N"})
	::serie := Telement():new({'name' => "serie", 'documentation' => "Série do Documento Fiscal", 'minLength' => 3})
	::subser := Telement():new({'name' => "subser", 'documentation' => "Sub-Série do Documento Fiscal", 'minLength' => 2, 'required' => False})
	::nDoc := Telement():new({'name' => "nDoc", 'documentation' => "Número do Documento Fiscal", 'maxLength' => 30})
	::dEmi := Telement():new({'name' => "dEmi", 'documentation' => "Data de emissão (AAAA-MMDD)", 'maxLength' => 10, 'type' => "D"})
return self
