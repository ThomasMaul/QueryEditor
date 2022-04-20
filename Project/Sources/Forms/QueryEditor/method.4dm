$event:=FORM Event:C1606.code
Case of 
	: ($event=On Load:K2:1)
		// use first table if unset
		If (Form:C1466.table=Null:C1517)
			$col:=OB Keys:C1719(ds:C1482)
			If ($col.length>0)
				Form:C1466.table:=ds:C1482[$col[0]]
			End if 
		End if 
		
		Form:C1466.height:=1
		Form:C1466.sub:=New object:C1471
		Form:C1466.editor:=cs:C1710.queryEditor.new(Form:C1466.table)
		Form:C1466.editor.addQueryLine()
		Form:C1466.editor.renderForm("sub")
		If (Form:C1466.editor.querylines.length<=1)
			SET TIMER:C645(1)
		End if 
		
		// property popup aufbauen, load, save...
		
	: ($event=On Unload:K2:2)
		Form:C1466.editor.close()
		
		
	: ($event=On Timer:K2:25)
		SET TIMER:C645(0)
		If (Form:C1466.editor.querylines.length<=1)
			EXECUTE METHOD IN SUBFORM:C1085("sub"; Formula:C1597(QE_Subformmethod).source; *; "disable")
		End if 
		
	: ($event=On Clicked:K2:4)
		Form:C1466.editor.handleFormEvent(FORM Event:C1606)
		
		$object:=Form:C1466.editor.createQueryObject()
		Form:C1466.preview:=JSON Stringify:C1217($object; *)
End case 