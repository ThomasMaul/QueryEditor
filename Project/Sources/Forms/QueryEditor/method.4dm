$event:=FORM Event:C1606.code
Case of 
	: ($event=On Load:K2:1)
		// use first table if unset
		If (Form:C1466.ds=Null:C1517)  // pass another ds for remote datastore
			Form:C1466.ds:=ds:C1482
		End if 
		
		Case of 
			: ((Form:C1466.table=Null:C1517) & (String:C10(Form:C1466.tablename)#""))
				Form:C1466.table:=ds:C1482[Form:C1466.tablename]
			: (Form:C1466.table=Null:C1517)
				$col:=OB Keys:C1719(Form:C1466.ds)
				If ($col.length>0)
					Form:C1466.table:=Form:C1466.ds[$col[0]]
				End if 
		End case 
		
		If (Form:C1466.queryTarget=Null:C1517)
			Form:C1466.queryTarget:=1
		End if 
		If (Form:C1466.queryTarget>0)
			OBJECT SET TITLE:C194(*; "top.button.destination"; Get localized string:C991("queryDest_"+String:C10(Form:C1466.queryTarget)))
		Else 
			OBJECT SET VISIBLE:C603(*; "top.button.destination"; False:C215)
		End if 
		If (Storage:C1525.QueryEditor.history=Null:C1517)
			OBJECT SET VISIBLE:C603(*; "top.button.recent"; False:C215)
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
		
		//$object:=Form.editor.createQueryObject()
		//Form.preview:=JSON Stringify($object; *)
End case 