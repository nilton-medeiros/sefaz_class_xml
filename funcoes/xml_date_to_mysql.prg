/*
 * Função auxiliar das classes XML/Sefaz
 * CFe-SAT, CTe, NFCe, NFe e NFSe
 *
*/


function xmlDateToMySql(dateTimeUTC)
	// recebe: dateTimeUTC: '2020-03-30T10:57:20-03:00'
	dateTimeUTC := StrTran(dateTimeUTC, 'T', ' ')
	dateTimeUTC := Left(dateTimeUTC, 19)
return "'" + dateTimeUTC + "'"