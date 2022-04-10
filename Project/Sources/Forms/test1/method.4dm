Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		If (Form:C1466.table=Null:C1517)
			$col:=OB Keys:C1719(ds:C1482)
			If ($col.length>0)
				Form:C1466.table:=ds:C1482[$col[0]]
			End if 
		End if 
		
		Form:C1466.sub:=New object:C1471
		Form:C1466.editor:=cs:C1710.queryEditor.new(Form:C1466.table)
		$counter:=Form:C1466.editor.getNextCounter()
		$line:=cs:C1710.queryLine.new(New object:C1471("name"; "anfang"; "id"; $counter))
		Form:C1466.editor.addQueryLine(0; $line)
		
		
		Form:C1466.editor.renderForm("sub")
		If (Form:C1466.editor.querylines.length<=1)
			SET TIMER:C645(1)
		End if 
		
	: (FORM Event:C1606.code=On Timer:K2:25)
		SET TIMER:C645(0)
		If (Form:C1466.editor.querylines.length<=1)
			EXECUTE METHOD IN SUBFORM:C1085("sub"; "QE_Subformmethod")  //Formula(QE_Subformmethod).source)
		End if 
		
	: (FORM Event:C1606.code=On Clicked:K2:4)
		
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
						Form:C1466.editor.addQueryLine($line; cs:C1710.queryLine.new(New object:C1471("id"; $id; "name"; String:C10(Current time:C178))))
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
				End case 
				
				
				
			Else 
				TRACE:C157
			End if 
			
		Else 
			// not a line in the query editor...
		End if 
		
End case 