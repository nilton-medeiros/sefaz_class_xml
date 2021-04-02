#include <hmg.ch>

Function STRING_MySQL_TO_HB(cStringSQL)
Return HMG_ANSI_TO_UNICODE(AllTrim(cStringSQL))
