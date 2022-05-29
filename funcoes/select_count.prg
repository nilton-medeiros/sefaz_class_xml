Function selectCount( table )
		LOCAL nCount := 0
		LOCAL oSQLCount := TSQLQuery():NEW( 'SELECT COUNT(*) FROM ' + table )

		if oSQLCount:isExecuted()
			nCount := oSQLCount:FieldGet(1)
			oSQLCount:Destroy()
			if !( ValType(nCount)=="N" )
				nCount := 0
			endif
		endif

RETURN nCount
