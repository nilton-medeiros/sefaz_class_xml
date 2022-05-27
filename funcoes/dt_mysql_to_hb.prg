#include <hmg.ch>

Function dateTime_mysql_to_hb( dt, lShowWeek )
    LOCAL cDate

    DEFAULT lShowWeek := .F.

    IF !Empty( dt )
        cDate := HB_USUBSTR( dt, 9, 2 ) + HB_USUBSTR( dt, 5, 4 ) + HB_ULEFT( dt, 4 )   // Converte formato "9999-99-99 99:99:99:99999" p/ "99-99-9999"
        IF ( lShowWeek )    // Mostrar o dia da semana junto da data
            cDate := DateAndWeek( CToD(cDate) ) // Pega o dia da semana, Acrecenta o dia da semana antes da data em si no formato "Sem 99-99-9999"
        ENDIF
        dt := cDate + HB_USUBSTR( dt, 11, 6 )     // Acresenta a hora ao formato "99-99-9999" para !lShowWeek ou "Sem 99-99-9999" para lShowWeek
    ENDIF

Return dt // Devolve "99-99-9999 99:99" ou "Sem 99-99-9999 99:99"
