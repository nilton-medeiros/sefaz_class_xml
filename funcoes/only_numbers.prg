 #include <hmg.ch>

Function onlyNumbers(string)
    LOCAL justNumbers := "", c
    if ValType(string) == "C" .and. !Empty(string)
       FOR EACH c IN string
            if c $ "0123456789"
               justNumbers += c
            end
       NEXT EACH
    end
Return justNumbers
