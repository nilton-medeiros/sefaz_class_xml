#include <hmg.ch>
#include <fileio.ch>

procedure saveLog(text)
   local path := Memvar->appData:systemPath + 'log\'
   local date_format := Set(_SET_DATEFORMAT, "yyyy.mm.dd")
   local logFile := 'cte_log' + hb_ULeft(DToS(Date()),6) + '.txt'
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
      processos := ProcName(3) + '(' + hb_ntos(ProcLine(3)) + ')->'
   endif
   if !Empty(ProcName(2))
      processos += ProcName(2) + '(' + hb_ntos(ProcLine(2)) + ')->'
   endif

   processos += ProcName(1) + '(' + hb_ntos(ProcLine(1)) + ')'

   msg := hb_eol() + DtoC(Date()) + ' ' + Time() + ' [' + processos + '] ' + msg

   SET(_SET_DATEFORMAT, date_format)

   FWrite(h, msg)
   FClose(h)

return
