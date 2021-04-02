Function fetch_object(query)
         Local fetch_obj := {}
         Local n

         FOR n := 1 TO query:LastRec()
             AAdd(fetch_obj, query:GetRow(n))
         NEXT n

Return AClone(fetch_obj)
