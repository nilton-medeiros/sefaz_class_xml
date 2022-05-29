#include <hmg.ch>

function getProcessId(runName)
	local process := EnumProcessesID() // Retorna um Array com todos os processos Ativos ou Suspensos na memória
   local id, returnId := 0
   local processName

	for each id in process
		processName := getProcessName(id)
		if valtype(processName) == 'C'
			processName := hmg_upper(AllTrim(processName))
			if (processName == runName)
				returnId := id
				exit
			endif
		endif
	next
return returnId
