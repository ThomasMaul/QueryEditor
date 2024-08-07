Form:C1466.query:=Form:C1466.editor.createQueryObject()
var $text : Text:=Form:C1466.editor.clearTextQueryLine()
var $query : Object:=Form:C1466.editor.createSaveObject()
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

If (Form:C1466.tableselection#Null:C1517)  // run the query here and return result in Form.query
	var $settings:=New object:C1471("parameters"; Form:C1466.query.para)
	
	Case of 
		: ((Form:C1466.queryTarget=1) | (Form:C1466.queryTarget=0))  // in table
			Form:C1466.query.resultselection:=Form:C1466.editor.table.query(Form:C1466.query.query_statement; $settings)
		: (Form:C1466.queryTarget=2)  // in selection
			Form:C1466.query.resultselection:=Form:C1466.tableselection.query(Form:C1466.query.query_statement; $settings)
		: (Form:C1466.queryTarget=3)  // add to selection
			var $result : Collection:=Form:C1466.editor.table.query(Form:C1466.query.query_statement; $settings)
			Form:C1466.query.resultselection:=Form:C1466.tableselection.or($result)
		: (Form:C1466.queryTarget=3)  // remove from selection
			$result:=Form:C1466.editor.table.query(Form:C1466.query.query_statement; $settings)
			Form:C1466.query.resultselection:=Form:C1466.tableselection.minus($result)
	End case 
End if 
ACCEPT:C269