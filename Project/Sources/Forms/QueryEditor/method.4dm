$event:=FORM Event:C1606.code
Case of 
	: ($event=On Load:K2:1)
		If (Form:C1466.table=Null:C1517)
			$col:=OB Keys:C1719(ds:C1482)
			If ($col.length>0)
				Form:C1466.table:=ds:C1482[$col[0]]
			End if 
		End if 
		
		Form:C1466.height:=1
		Form:C1466.sub:=New object:C1471
		Form:C1466.editor:=cs:C1710.queryEditor.new(Form:C1466.table)
		$counter:=Form:C1466.editor.getNextCounter()
		$line:=cs:C1710.queryLine.new(New object:C1471("name"; "anfang"; "id"; $counter))
		Form:C1466.editor.addQueryLine(0; $line)
		Form:C1466.editor.renderForm("sub")
		If (Form:C1466.editor.querylines.length<=1)
			SET TIMER:C645(1)
		End if 
		
		// property popup aufbauen, load, save...
		
	: ($event=On Unload:K2:2)
		RELEASE MENU:C978(Form:C1466.editor.popupmenu)
		
		
	: ($event=On Timer:K2:25)
		SET TIMER:C645(0)
		If (Form:C1466.editor.querylines.length<=1)
			EXECUTE METHOD IN SUBFORM:C1085("sub"; Formula:C1597(QE_Subformmethod).source; *; "disable")
		End if 
		
	: ($event=On Clicked:K2:4)
		
		$name:=FORM Event:C1606.objectName
		If ($name="ob_@")
			$sub:=Substring:C12($Name; 4)
			$pos:=Position:C15("_"; $sub)
			$line:=Num:C11(Substring:C12($sub; 1; $pos-1))
			$item:=Substring:C12($sub; $pos+1)
			
			If (($line#0) & ($item#""))
				Case of 
					: ($item="+")
						$counter:=Form:C1466.editor.getNextCounter()
						Form:C1466.editor.addQueryLine($line; cs:C1710.queryLine.new(New object:C1471("id"; $counter; "name"; String:C10(Current time:C178))))
						Form:C1466.editor.renderForm("sub")
						
					: ($item="-")
						Form:C1466.editor.deleteQueryLine($line-1)
						Form:C1466.editor.renderForm("sub")
						If (Form:C1466.editor.querylines.length<=1)
							SET TIMER:C645(1)
						End if 
						
					: ($item="fieldlist")
						$paramRef:=Dynamic pop up menu:C1006(Form:C1466.editor.popupmenu)
						// finde queryline
						var $queryline : cs:C1710.queryLine
						$queryline:=Form:C1466.editor.findQueryLine($line)
						$queryline.setValue($paramRef)
						Form:C1466.editor.renderForm("sub")
						
					: ($item="condition")
						$index:=Form:C1466.sub["cond_combo_"+String:C10($line)].index
						$queryline:=Form:C1466.editor.findQueryLine($line)
						$queryline.setCondition($index)
						Form:C1466.editor.renderForm("sub")
						
					: ($item="popup2")
						$index:=Form:C1466.sub["combo2_"+String:C10($line)].index
						$queryline:=Form:C1466.editor.findQueryLine($line)
						$queryline.setPopup2($index)
						Form:C1466.editor.renderForm("sub")
						
					: ($item="operator")
						$index:=Form:C1466.sub["operator_"+String:C10($line)].index
						$queryline:=Form:C1466.editor.findQueryLine($line)
						$queryline.setOperator($index)
						
					: ($item="clickbutton")
						$index:=Form:C1466.sub["clickbutton_"+String:C10($line)].index
						$queryline:=Form:C1466.editor.findQueryLine($line)
						// now we need to open an entry window, on close set content into object...
						$queryline.itemlist_entrywindow()
				End case 
				
				// debug
				$object:=Form:C1466.editor.createQueryObject()
				Form:C1466.preview:=JSON Stringify:C1217($object; *)
				
			Else 
				TRACE:C157
			End if 
			
		Else 
			// not a line in the query editor...
		End if 
		
End case 