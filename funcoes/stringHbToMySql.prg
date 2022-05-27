#include <hmg.ch>


function STRING_HB_TO_MySQL(cStringSQL)
Return HMG_UNICODE_TO_ANSI(mysql_escape_string(cStringSQL))
