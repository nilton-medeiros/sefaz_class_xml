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


class TinfDoc
   data documentation
	data value READONLY
	data infNF
	data infNFe
	data infOutros
	method new() constructor
	method addInfNF()
	method addInfNFe()
	method addInfOutros()
	method infNFClear() INLINE ::infNF:value := {}
	method infNFeClear() INLINE ::infNFe:value := {}
	method infOutrosClear() INLINE ::infOutros:value := {}

end class

method new() class TinfDoc
	::documentation := "infDoc | Informações dos documentos transportados pelo CT-e Opcional para Redespacho Intermediario e Serviço vinculado a multimodal."
	::value := "TinfDoc"
	::infNF := Telement():new({'name' => "infNF", 'documentation' => "Informações das NF"+CRLF+"Este grupo deve ser informado quando o documento originário for NF", 'value' => {}, 'required' => False, 'maxLength' => 99999, 'type' => "A"})
	::infNFe := Telement():new({'name' => "infNFe", 'documentation' => "Informações das NF-e", 'value' => {}, 'required' => False, 'maxLength' => 99999, 'type' => "A"})
	::infOutros := Telement():new({'name' => "infOutros", 'documentation' => "Informações dos demais documentos", 'value' => {}, 'required' => False, 'maxLength' => 99999, 'type' => "A"})
return self

method addInfNF(p) class TinfDoc
	AAdd(::infNF:value, TinfNF():new(p))
return Nil

method addInfNFe(p) class TinfDoc
	AAdd(::infNFe:value, TinfNFe():new(p))
return Nil

method addInfOutros(p) class TinfDoc
	AAdd(::infOutros:value, TinfOutros():new(p))
return Nil
