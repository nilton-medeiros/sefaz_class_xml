 #include <hmg.ch>

Function ExcluirRegistroMySQL( cTabela, cId, cMsg )
		LOCAL lExcluido := .F.
		LOCAL oSQLDelete

		DEFAULT cMsg := Capitalize( cTabela )

		IF cId == '0'
			MsgExclamation( 'Registro de sistema, exclusão não permitida.'+CRLF+'Para excluir este ID, entre em contato com o suporte!', 'Exclusão Não Permitida!' )
			Return .F.
		ENDIF

		cTabela := HMG_LOWER(cTabela)
		oSQLDelete := TSQLQuery():NEW( "DELETE FROM " + cTabela + " WHERE id=" + cId )

		MsgStatus('Excluindo ' + cMsg + '...')

		IF oSQLDelete:isExecuted()
			MsgStatus('Status: ' + cMsg + ' excluído com sucesso!')
			lExcluido := .T.
			oSQLDelete:Destroy()
		ENDIF

Return lExcluido
