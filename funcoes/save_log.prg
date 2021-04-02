#include <hmg.ch>
#include <fileio.ch>

procedure saveLog(text)
   local path := Memvar->appData:systemPath + 'log\'
   local meses := {'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'}
   local curDate := DToC(Date())
   local logFile := 'log' + hb_ULeft(DToS(Date()),6) + '.txt'
   local h
   local t, msg := "", processos := ''

   if hb_FileExists(path + logFile)
      h := FOpen(path + logFile, FO_WRITE)
      FSeek(h, 0, FS_END)
   else
      h := hb_FCreate(path + logFile, FC_NORMAL)
      FWrite(h, 'Log de Sistema ' + Memvar->appData:displayName + hb_eol())
   endif
   if ValType(text) == 'A'
      for each t in text
         if !(ValType(t) == 'C')
            if (ValType(t) == 'N')
               t := hb_ntos(t)
            elseif (ValType(t) == 'D')
               t := hb_DToC(t)
            elseif (ValType(t) == 'L')
               t := iif(t, 'True', 'False')
            endif
         endif
         msg += t
      next
   else
      msg := text
   endif
   if !Empty(ProcName(3))
      processos := ProcName(3) + '(' + hb_ntos(ProcLine(3)) + ')/'
   endif
   if !Empty(ProcName(2))
      processos += ProcName(2) + '(' + hb_ntos(ProcLine(2)) + ')/'
   endif

   processos += ProcName(1) + '(' + hb_ntos(ProcLine(1)) + ')'
   curDate := Left(curDate, 2) + '-' + meses[Month(Date())] + '-' + Right(curDate, 4)
   msg := hb_eol() + curDate + ' ' + Time() + ' [' + processos + '] ' + msg

   FWrite(h, msg)
   FClose(h)

return
