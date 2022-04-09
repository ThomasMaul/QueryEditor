Class constructor($class : 4D:C1709.DataClass)
	This:C1470.table:=$class
	This:C1470.querylines:=New collection:C1472
	This:C1470.counter:=0
	This:C1470.fieldlist:=This:C1470._getDSClassDetails(This:C1470.table)
	This:C1470.popupmenu:=This:C1470._getTableMenu()
	This:C1470.conditionpopup:=This:C1470._getConditionMenu()
	
	
Function getNextCounter()->$counter : Integer
	This:C1470.counter+=1
	$counter:=This:C1470.counter
	
Function addQueryLine($pos : Integer; $lineobject : cs:C1710._queryLine)
	If ($lineobject#Null:C1517)
		This:C1470.querylines.insert($pos; $lineobject)
	Else 
		$counter:=This:C1470.getNextCounter()
		This:C1470.querylines.insert($pos; cs:C1710.queryLine.new(New object:C1471("id"; $counter)))
	End if 
	
Function deleteQueryLine($pos : Integer)
	This:C1470.querylines.remove($pos)
	
Function renderForm($subformname : Text)
	$form:=New object:C1471
	$objects:=New object:C1471()
	$counter:=0
	For each ($line; This:C1470.querylines)
		$counter+=1
		$lineobjects:=$line.renderObjects(New object:C1471("counter"; $counter))
		For each ($object; $lineobjects)
			$objects[$object]:=$lineobjects[$object]
		End for each 
		$objects[$line.id]:=$object
	End for each 
	$page1:=New object:C1471("objects"; $objects)
	$form.pages:=New collection:C1472(Null:C1517; $page1)
	OBJECT SET SUBFORM:C1138(*; $subformname; $form)
	
	
Function getQueryLine($pos : Integer)->$object : cs:C1710.queryLine
	If (($pos>=0) & ($pos<This:C1470.querylines.length))
		$object:=This:C1470.querylines[$pos]
	Else 
		$object:=Null:C1517
	End if 
	
Function _getDSClassDetails($class : 4D:C1709.DataClass)->$fields : Collection
	$fieldnames:=OB Keys:C1719($class)
	$fields:=New collection:C1472
	For each ($field; $fieldnames)
		$f:=$class[$field]
		$fields.push(New object:C1471("name"; $field; \
			"kind"; $f.kind; \
			"type"; $f.fieldType))
	End for each 
	
Function _getTableMenu->$menuref : Text
	$txt_suffix:=Choose:C955((FORM Get color scheme:C1761="dark"); "_dark"; "")
	$menuref:=Create menu:C408
	For each ($field; This:C1470.fieldlist)
		INSERT MENU ITEM:C412($menuref; -1; $field.name)
		$id:=0
		Case of 
			: ($field.type=Is alpha field:K8:1)
				$id:=1
			: ($field.type=Is text:K8:3)
				$id:=2
			: ($field.type=Is date:K8:7)
				$id:=3
			: ($field.type=Is time:K8:8)
				$id:=4
			: ($field.type=Is boolean:K8:9)
				$id:=5
			: ($field.type=Is integer:K8:5)
				$id:=6
			: ($field.type=Is longint:K8:6)
				$id:=7
			: ($field.type=Is integer 64 bits:K8:25)
				$id:=8
			: ($field.type=Is real:K8:4)
				$id:=9
			: ($field.type=Is BLOB:K8:12)
				$id:=11
			: ($field.type=Is picture:K8:10)
				$id:=12
			: ($field.type=Is object:K8:27)
				$id:=14
			Else 
				
		End case 
		SET MENU ITEM ICON:C984($MenuRef; -1; "Path:/RESOURCES/Query/Field_"+String:C10($id)+$txt_suffix+".png")
		SET MENU ITEM PARAMETER:C1004($MenuRef; -1; $field.name)
	End for each 
	
Function findQueryLine($line : Integer)->$queryline : cs:C1710.queryLine
	$col:=This:C1470.querylines.query("listentry=:1"; $line)
	$queryline:=$col.length=1 ? $col[0] : Null:C1517
	
Function _getConditionMenu()->$object
	// creates object für Query editions, as used in popup
	// reads file query.xml, delivered in 4D for standard query editor
	C_TEXT:C284($childName; $childValue; $name; $childName2; $id2; $type; $label)
	$path:=Get 4D folder:C485(Current resources folder:K5:16)+"query"+Folder separator:K24:12+"query.xml"
	$object:=New object:C1471
	
	$xml:=DOM Parse XML source:C719($path)
	
	$criteria:=DOM Find XML element:C864($xml; "/rsrc/criteria")
	
	If (OK=1)
		$xml_Child_Ref:=DOM Get first child XML element:C723($criteria; $childName)
		If ($childName="type")
			
			Repeat 
				DOM GET XML ATTRIBUTE BY NAME:C728($xml_Child_Ref; "id"; $id)
				$object[$id]:=New collection:C1472
				
				$xml_Child2_Ref:=DOM Get first child XML element:C723($xml_Child_Ref; $childName2)
				If (OK=1)
					Repeat 
						$subobject:=New object:C1471
						DOM GET XML ATTRIBUTE BY NAME:C728($xml_Child2_Ref; "type"; $type)
						If ($type="-1")
							$object[$id].push(New object:C1471("type"; Num:C11($type); "text"; "-"))
						Else 
							DOM GET XML ATTRIBUTE BY NAME:C728($xml_Child2_Ref; "label"; $label)
							DOM GET XML ATTRIBUTE BY NAME:C728($xml_Child2_Ref; "id"; $id2)
							$string:=Get localized string:C991($label)
							$object[$id].push(New object:C1471("type"; Num:C11($type); "label"; $label; "id"; Num:C11($id2); "text"; $string))
						End if 
						
						$xml_Child2_Ref:=DOM Get next sibling XML element:C724($xml_Child2_Ref)
					Until (OK=0)
				End if 
				
				$xml_Child_Ref:=DOM Get next sibling XML element:C724($xml_Child_Ref)
			Until (OK=0)
			
		End if 
		
	End if 
	DOM CLOSE XML:C722($xml)
	
	