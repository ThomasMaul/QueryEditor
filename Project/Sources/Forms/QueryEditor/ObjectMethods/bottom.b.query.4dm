Form:C1466.query:=Form:C1466.editor.createQueryObject()
$text:=Form:C1466.editor.clearTextQueryLine()
$query:=Form:C1466.editor.createSaveObject()
If ((Storage:C1525.QueryEditor#Null:C1517) && (Storage:C1525.QueryEditor.history#Null:C1517))
	If (Storage:C1525.QueryEditor.history.indexOf($text)<0)
		Storage:C1525.QueryEditor.history.unshift($text)
		Storage:C1525.QueryEditor.historySave.unshift(OB Copy:C1225($query; ck shared:K85:29; Storage:C1525.QueryEditor.historySave))
		If (Storage:C1525.QueryEditor.history.length>10)
			Storage:C1525.QueryEditor.history.shift()
			Storage:C1525.QueryEditor.historySave.shift()
		End if 
	End if 
Else 
	Use (Storage:C1525)
		Storage:C1525.QueryEditor:=New shared object:C1526("history"; New shared collection:C1527($text); "historySave"; New shared collection:C1527())
		Storage:C1525.QueryEditor.historySave.push(OB Copy:C1225($query; ck shared:K85:29; Storage:C1525.QueryEditor))
	End use 
End if 

If (This:C1470.tableselection#Null:C1517)  // run the query here and return result in Form.query
	Case of 
		: ((This:C1470.queryTarget=1) | (This:C1470.queryTarget=0))  // in table
			Form:C1466.query.resultselection:=This:C1470.table.query($query.query_statement; $settings)
		: (This:C1470.queryTarget=2)  // in selection
			Form:C1466.query.resultselection:=This:C1470.tableselection.query($query.query_statement; $settings)
		: (This:C1470.queryTarget=3)  // add to selection
			$result:=This:C1470.table.query($query.query_statement; $settings)
			Form:C1466.query.resultselection:=This:C1470.tableselection.or($result)
		: (This:C1470.queryTarget=3)  // remove from selection
			$result:=This:C1470.table.query($query.query_statement; $settings)
			Form:C1466.query.resultselection:=This:C1470.tableselection.minus($result)
	End case 
End if 
ACCEPT:C269