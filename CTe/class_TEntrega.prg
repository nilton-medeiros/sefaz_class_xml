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


class TEntrega
	data value READONLY
	data submit
	data tpPer READONLY
	data dProg
	data dIni
	data dFim
	data tpHor READONLY
	data hIni
	data hProg
	data hFim
	method new() constructor
	method setTpPer(tpPer) SETGET
	method setTpHor(tpHor) SETGET
end class

method new() class TEntrega
	::value := "TEntrega"
	::submit := False
	::tpPer := Telement():new({'name' => "tpPer", 'required' => True, 'minLength' => 1, 'restriction' => "0|1|2|3|4", 'type' => "N", 'documentation' => "Tipo de data/Período programado para entrega"+CRLF+;
													"Preencher com:"+CRLF+;
													"0-Sem ::definida;"+CRLF+;
													"1-Na data;"+CRLF+;
													"2-Até a data;"+CRLF+;
													"3-A partir da data;"+CRLF+;
													"4-No período"})
	::dProg := Telement():new({'name' => "dProg", 'required' => False, 'minLength' => 10, 'type' => "D", 'documentation' => "Data Programada - Formato AAAA-MM-DD"})
	::dIni := Telement():new({'name' => "dIni", 'required' => False, 'minLength' => 10, 'type' => "D", 'documentation' => "Data inicial - Formato AAAA-MM-DD"})
	::dFim := Telement():new({'name' => "dFim", 'required' => False, 'minLength' => 10, 'type' => "D", 'documentation' => "Data final - Formato AAAA-MM-DD"})
	::tpHor := Telement():new({'name' => "tpHor", 'required' => True, 'minLength' => 1, 'restriction' => "0|1|2|3|4", 'type' => "N", 'documentation' => "Tipo de horário programado para entrega"+CRLF+;
													"Preencher com:"+CRLF+;
													"0-Sem hora definida;"+CRLF+;
													"1-No horário;"+CRLF+;
													"2-Até o horário;"+CRLF+;
													"3-A partir do horário;"+CRLF+;
													"4-No intervalo de tempo"})
	::hIni := Telement():new({'name' => "hIni", 'required' => False, 'minLength' => 8, 'type' => "T", 'documentation' => "Hora inicial"})
	::hProg := Telement():new({'name' => "hProg", 'required' => False, 'minLength' => 8, 'type' => "T", 'documentation' => "Hora Programada"})
	::hFim := Telement():new({'name' => "hFim", 'required' => False, 'minLength' => 8, 'type' => "T", 'documentation' => "Hora final"})
return self

method setTpPer(tpPer) class TEntrega
	default tpPer := ""

	if Len(tpPer) > 1
		tpPer := hb_ULeft(AllTrim(tpPer),1)
	endif

	if (tpPer $ "01234")
		::submit := True
		::tpPer:value := tpPer
		if (tpPer == "4")
			// No Período
			::dProg:value := ""
			::dProg:setRequired(False)
			::dIni:setRequired(True)
			::dFim:setRequired(True)
		elseif !(tpPer == "0")
			::dProg:setRequired(True)
			::dIni:setRequired(False)
			::dFim:setRequired(False)
			::dIni:value := ""
			::dFim:value := ""
		endif
	else
		::tpPer:value := ""
		::dProg:value := ""
		::dIni:value := ""
		::dFim:value := ""
	endif

return nil

method setTpHor(tpHor) class TEntrega
	default tpHor := ""

	if Len(tpHor) > 1
		tpHor := hb_ULeft(AllTrim(tpHor),1)
	endif

	if (tpHor $ "01234")
		::tpHor:value := tpHor
		if (tpHor == "4")
			// No Intervalo de Tempo
			::hProg:value := ""
		else
			::hIni:value := ""
			::hFim:value := ""
		endif
	else
		::tpHor:value := ""
		::hProg:value := ""
		::hIni:value := ""
		::hFim:value := ""
	endif

return nil
