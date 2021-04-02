
Function  DateAndWeek( dDate )
    LOCAL cDate, aWeek := {'Dom','Seg','Ter','Qua','Qui','Sex','Sab'}
    cDate := aWeek[Dow(dDate)] + ' ' + DToC(dDate)
Return cDate
