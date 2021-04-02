
Function DelItemArray(list_delete, nPos)
         Local nLen := HMG_LEN(list_delete)

         if (nPos > nLen)
            Return AClone(list_delete)
         end

         if (nLen <= 1)
            Return AClone({})
         end

         ADEL(list_delete, nPos)

         nLen--

         if (nLen < 1)
            Return AClone({})
         end

         ASIZE(list_delete, nLen)

Return AClone(list_delete)
