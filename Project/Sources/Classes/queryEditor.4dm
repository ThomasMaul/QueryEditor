Class constructor($form : Object)
	
	If (($form.ds#Null:C1517) && (OB Instance of:C1731($Form.ds; cs:C1710.DataStore)))
		This:C1470.ds:=$form.ds
	Else 
		This:C1470.ds:=ds:C1482
	End if 
	
	Case of 
		: (($Form.table#Null:C1517) && (OB Instance of:C1731($Form.table; 4D:C1709.DataClass)))
			This:C1470.table:=$Form.table
		: (String:C10($form.tablename)#"")
			This:C1470.table:=This:C1470.ds[$Form.tablename]
		: (($form.tableptr#Null:C1517) && (Value type:C1509($form.tableptr)=Is pointer:K8:14))
			This:C1470.table:=ds:C1482[Table name:C256($form.tableptr)]  // only works with local datastore, not with remote
		: (($form.tableselection#Null:C1517) && (OB Instance of:C1731($form.tableselection; 4D:C1709.EntitySelection)))
			This:C1470.table:=$form.tableselection.getDataClass()
			This:C1470.tableselection:=$form.tableselection
			
		Else 
			$col:=OB Keys:C1719(This:C1470.ds)
			If ($col.length>0)
				This:C1470.table:=This:C1470.ds[$col[0]]
			Else 
				ASSERT:C1129(False:C215; "Cannot work in structure without tables")
				return 
			End if 
	End case 
	
	If ($form.fieldlist#Null:C1517)
		This:C1470.virt_fieldllist:=$form.fieldlist
	End if 
	
	This:C1470.reset()
	This:C1470.popupsubmenu:=New collection:C1472
	This:C1470.popupmenu:=This:C1470._getTableMenu(This:C1470.fieldlist)
	This:C1470.conditionpopup:=This:C1470._getConditionMenu()
	Form:C1466.conditionpopup:=This:C1470.conditionpopup
	This:C1470.height:=30
	This:C1470._buildListContents()
	This:C1470.operators:=New collection:C1472(Get localized string:C991("operator_and"); \
		Get localized string:C991("operator_or"); \
		Get localized string:C991("operator_except"))
	
Function reset()
	This:C1470.querylines:=New collection:C1472
	This:C1470.counter:=0
	This:C1470.fieldlist:=This:C1470._getDSClassDetails(This:C1470.table)
	
Function close()
	For each ($sub; This:C1470.popupsubmenu)
		RELEASE MENU:C978($sub)
	End for each 
	RELEASE MENU:C978(This:C1470.popupmenu)
	
Function getNextCounter()->$counter : Integer
	This:C1470.counter+=1
	$counter:=This:C1470.counter
	
Function addQueryLine($pos : Integer; $lineobject : cs:C1710.queryLine)
	If ($lineobject#Null:C1517)
		This:C1470.querylines.insert($pos; $lineobject)
	Else 
		$counter:=This:C1470.getNextCounter()
		This:C1470.querylines.insert($counter; cs:C1710.queryLine.new(New object:C1471("id"; $counter)))
	End if 
	
Function deleteQueryLine($pos : Integer)
	This:C1470.querylines.remove($pos)
	
Function findQueryLine($line : Integer)->$queryline : cs:C1710.queryLine
	$col:=This:C1470.querylines.query("listentry=:1"; $line)
	$queryline:=$col.length=1 ? $col[0] : Null:C1517
	
Function renderForm($subformname : Text)
	This:C1470.sub:=$subformname
	$form:=New object:C1471
	$objects:=New object:C1471()
	$counter:=0
	$max_y:=0
	For each ($line; This:C1470.querylines)
		$counter+=1
		$lineobjects:=$line.renderObjects(New object:C1471("counter"; $counter))
		For each ($object; $lineobjects)
			$objects[$object]:=$lineobjects[$object]
			$y:=Num:C11($objects[$object].top)+Num:C11($objects[$object].height)
			If ($y>$max_y)
				$max_y:=$y
			End if 
		End for each 
		$objects[$line.id]:=$object
	End for each 
	$page1:=New object:C1471("objects"; $objects)
	$form.pages:=New collection:C1472(Null:C1517; $page1)
	//TODO: check 2nd screen height - where is the window?
	$maxlines:=(Screen height:C188-300)/This:C1470.height
	If (This:C1470.querylines.length<$maxlines)
		$newheight:=This:C1470.querylines.length-Form:C1466.height
		Form:C1466.height:=This:C1470.querylines.length
		RESIZE FORM WINDOW:C890(0; $newheight*This:C1470.height)
		OBJECT SET SCROLLBAR:C843(*; $subformname; False:C215; False:C215)
	Else 
		OBJECT SET SCROLLBAR:C843(*; $subformname; False:C215; True:C214)
	End if 
	Form:C1466.sub:=New object:C1471("editor"; Form:C1466.editor)
	OBJECT SET SUBFORM:C1138(*; $subformname; $form)
	
Function handleFormEvent($event : Object)
	$name:=$event.objectName
	If ($name="ob_@")
		$sub:=Substring:C12($Name; 4)
		$pos:=Position:C15("_"; $sub)
		$line:=Num:C11(Substring:C12($sub; 1; $pos-1))
		$item:=Substring:C12($sub; $pos+1)
		
		If (($line#0) & ($item#""))
			Case of 
				: ($item="+")
					$counter:=This:C1470.getNextCounter()
					This:C1470.addQueryLine($line; cs:C1710.queryLine.new(New object:C1471("id"; $counter; "name"; String:C10(Current time:C178))))
					This:C1470.renderForm(This:C1470.sub)
					
				: ($item="-")
					This:C1470.deleteQueryLine($line-1)
					This:C1470.renderForm(This:C1470.sub)
					If (This:C1470.querylines.length<=1)
						SET TIMER:C645(1)
					End if 
					
				: (($item="1") | ($item="fieldlist"))
					$paramRef:=Dynamic pop up menu:C1006(This:C1470.popupmenu)
					If ($paramRef#"")
						var $queryline : cs:C1710.queryLine
						$queryline:=This:C1470.findQueryLine($line)
						$queryline.setValue($paramRef)
						This:C1470.renderForm(This:C1470.sub)
					End if 
					
				: ($item="condition")
					$queryline:=This:C1470.findQueryLine($line)
					$index:=$queryline.getCondCombo()
					$queryline.setCondition($index)
					This:C1470.renderForm(This:C1470.sub)
					
				: ($item="popup2")
					$queryline:=This:C1470.findQueryLine($line)
					$index:=$queryline.getCombo2()
					$queryline.setPopup2($index)
					This:C1470.renderForm("sub")
					
				: ($item="operator")
					$queryline:=This:C1470.findQueryLine($line)
					$index:=$queryline.getOperatorIndex()
					$queryline.setOperator($index)
					
				: ($item="clickbutton")
					$queryline:=This:C1470.findQueryLine($line)
					$queryline.itemlist_entrywindow()
			End case 
			
		Else 
			TRACE:C157
		End if 
		
	Else 
		// not a line in the query editor...
	End if 
	
Function getQueryLine($pos : Integer)->$object : cs:C1710.queryLine
	If (($pos>=0) & ($pos<This:C1470.querylines.length))
		$object:=This:C1470.querylines[$pos]
	Else 
		$object:=Null:C1517
	End if 
	
Function _getDSClassDetails($class : 4D:C1709.DataClass; $relatedTableName : Text)->$fields : Collection
	$fieldnames:=OB Keys:C1719($class)
	$fields:=New collection:C1472
	For each ($field; $fieldnames)
		$f:=$class[$field]
		$data:=New object:C1471("name"; $field; \
			"kind"; $f.kind; \
			"type"; $f.fieldType; \
			"indexed"; $f.indexed; \
			"relatedDataClass"; This:C1470.ds[String:C10($f.relatedDataClass)])
		
		If (This:C1470.virt_fieldllist#Null:C1517)
			If ($relatedTableName#"")
				$searchforName:=$relatedTableName+"."+$field
			Else 
				$searchforName:=$field
			End if 
			$virt:=This:C1470.virt_fieldllist.query("structure=:1"; $searchforName)
			If ($virt.length>0)
				$data.displayName:=$virt[0].display
				$fields.push($data)
			End if 
		Else 
			$data.displayName:=$data.name
			$fields.push($data)
		End if 
	End for each 
	
Function _getTableMenu($fieldlist : Collection; $level : Integer; $tablename : Text; $structureTablename : Text)->$menuref : Text
	$txt_suffix:=Choose:C955((FORM Get color scheme:C1761="dark"); "_dark"; "")
	$menuref:=Create menu:C408
	For each ($field; $fieldlist)
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
			: (($field.type=Is object:K8:27) & ($field.kind="relatedEntity"))
				If ($level<3)
					$id:=13
				Else 
					$i:=-1
				End if 
			: ($field.type=Is object:K8:27)
				$id:=14
			: ($field.type=Is subtable:K8:11)
				$id:=-1
			: ($field.type=42)  // relation many
				If ($level<3)
					$id:=13
				End if 
			Else 
				$id:=-1
		End case 
		If ($id>=0)
			If ($id=13)  // relation many to one
				If (($field.relatedDataClass.getInfo().name#This:C1470.table.getInfo().name) && \
					($field.relatedDataClass.getInfo().name#$structureTablename))  // not going back to ourself...
					If ($tablename#"")
						$subfieldlist:=This:C1470._getDSClassDetails($field.relatedDataClass; $tablename+"."+$field.name)
					Else 
						$subfieldlist:=This:C1470._getDSClassDetails($field.relatedDataClass; $field.name)
					End if 
					$subname:=$field.name  //displayName
					If ($tablename#"")
						$subname:=$tablename+"."+$subname
					End if 
					$submenu:=This:C1470._getTableMenu($subfieldlist; $level+1; $subname; $field.relatedDataClass.getInfo().name)
					This:C1470.popupsubmenu.push($submenu)
					INSERT MENU ITEM:C412($menuref; -1; $field.displayName; $submenu)
				End if 
			Else 
				INSERT MENU ITEM:C412($menuref; -1; $field.displayName)
				If ($level>0)
					SET MENU ITEM PARAMETER:C1004($MenuRef; -1; $tablename+"."+$field.name)
				Else 
					SET MENU ITEM PARAMETER:C1004($MenuRef; -1; $field.name)
				End if 
			End if 
			SET MENU ITEM ICON:C984($MenuRef; -1; "Path:/RESOURCES/Query/Field_"+String:C10($id)+$txt_suffix+".png")
			If ($field.indexed)
				SET MENU ITEM STYLE:C425($menuref; -1; Bold:K14:2)
			End if 
		End if 
	End for each 
	
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
	
Function _buildListContents()
	$Lists:=New object:C1471
	
	$lists.operators:=New collection:C1472
	$lists.operators.push(Get localized string:C991("operator_and"))
	$lists.operators.push(Get localized string:C991("operator_or"))
	$lists.operators.push(Get localized string:C991("operator_except"))
	
	$lists.criteria_text:=New collection:C1472
	$lists.criteria_text.push(Get localized string:C991("criteria_Text2a_AllWords"))
	$lists.criteria_text.push(Get localized string:C991("criteria_Text2a_SomeWords"))
	
	$lists.criteria_date_a:=New collection:C1472
	$lists.criteria_date_a.push(Get localized string:C991("criteria_DateBis_Days"))
	$lists.criteria_date_a.push(Get localized string:C991("criteria_DateBis_Weeks"))
	$lists.criteria_date_a.push(Get localized string:C991("criteria_DateBis_Months"))
	$lists.criteria_date_a.push(Get localized string:C991("criteria_DateBis_Years"))
	
	$lists.criteria_date_b:=New collection:C1472
	$lists.criteria_date_b.push(Get localized string:C991("criteria_DateTer_W1"))
	$lists.criteria_date_b.push(Get localized string:C991("criteria_DateTer_W2"))
	$lists.criteria_date_b.push(Get localized string:C991("criteria_DateTer_W3"))
	$lists.criteria_date_b.push(Get localized string:C991("criteria_DateTer_Month"))
	$lists.criteria_date_b.push(Get localized string:C991("criteria_DateTer_Quarter"))
	$lists.criteria_date_b.push(Get localized string:C991("criteria_DateTer_Year"))
	
	$lists.criteria_time_a:=New collection:C1472
	$lists.criteria_time_a.push(Get localized string:C991("criteria_TimeBis_Hours"))
	$lists.criteria_time_a.push(Get localized string:C991("criteria_TimeBis_Minuts"))
	$lists.criteria_time_a.push(Get localized string:C991("criteria_TimeBis_Seconds"))
	
	$lists.criteria_duration_a:=New collection:C1472
	$lists.criteria_duration_a.push(Get localized string:C991("criteria_DurationHours"))
	$lists.criteria_duration_a.push(Get localized string:C991("criteria_DurationMinutes"))
	$lists.criteria_duration_a.push(Get localized string:C991("criteria_DurationSeconds"))
	
	$lists.criteria_pict_a:=New collection:C1472
	$lists.criteria_pict_a.push(Get localized string:C991("criteria_pict2a_AllWords"))
	$lists.criteria_pict_a.push(Get localized string:C991("criteria_Pict2a_SomeWords"))
	
	$lists.criteria_pict_b:=New collection:C1472
	$lists.criteria_pict_b.push(Get localized string:C991("criteria_pict2b_Bytes"))
	$lists.criteria_pict_b.push(Get localized string:C991("criteria_pict2b_KBytes"))
	$lists.criteria_pict_b.push(Get localized string:C991("criteria_pict2b_MBytes"))
	$lists.criteria_pict_b.push(Get localized string:C991("criteria_pict2b_GBytes"))
	
	$lists.criteria_blob_a:=New collection:C1472
	$lists.criteria_blob_a.push(Get localized string:C991("criteria_BlobBis_Byte"))
	$lists.criteria_blob_a.push(Get localized string:C991("criteria_BlobBis_KByte"))
	$lists.criteria_blob_a.push(Get localized string:C991("criteria_BlobBis_MByte"))
	$lists.criteria_blob_a.push(Get localized string:C991("criteria_BlobBis_GByte"))
	
	This:C1470.lists:=$Lists
	
Function createQueryObject($clearText : Boolean)->$object
	// builds the real query operation
	
	$object:=New object:C1471
	$statement:=""
	$para:=New object:C1471
	
	For each ($line; This:C1470.querylines)
		If ($line.listentry=1)
			// nothing
		Else 
			Case of 
				: ($line.operator=0)
					$operator:=" and "
				: ($line.operator=1)
					$operator:=" or "
				: ($line.operator=2)
					$operator:=" and not "
			End case 
			$statement+=$operator
		End if 
		$statement+="("+$line.createQueryStatement($para; $clearText)+")"
	End for each 
	
	$object.query_statement:=$statement
	$object.para:=$para
	
Function clearTextQueryLine()->$statement
	$query:=This:C1470.createQueryObject(True:C214)
	$statement:=$query.query_statement
	For each ($para; $query.para)
		$statement:=Replace string:C233($statement; ":"+$para; String:C10($query.para[$para]))
	End for each 
	
Function createSaveObject()->$object
	// builds an object to save the current query
	$object:=New object:C1471
	$object.table:=This:C1470.table.getInfo().name
	$object.version:=1
	$object.lines:=New collection:C1472
	For each ($line; This:C1470.querylines)
		$object.lines.push($line.createSaveObject())
	End for each 
	
Function useSaveObject($object)
	// clear existing query, start new one
	This:C1470.querylines:=New collection:C1472
	
	If (Num:C11($object.version)#1)
		ALERT:C41(Get localized string:C991("Errors_fileVersionUnhandled"))
		return 
	End if 
	
	// check if table and fields exists
	If (This:C1470.ds[$object.table]#Null:C1517)
		$class:=This:C1470.ds[$object.table]
	Else 
		ALERT:C41(Get localized string:C991("Alerts_theQueryContainsATableThatDoesNotExist"))
		return 
	End if 
	This:C1470.table:=$class
	This:C1470.counter:=0
	This:C1470.fieldlist:=This:C1470._getDSClassDetails(This:C1470.table)
	If (This:C1470.fieldlist.length=0)
		ALERT:C41(Get localized string:C991("Errors_anErrorOccurredWhileOpeningTheFile"))
		This:C1470.reset()
		return 
	End if 
	This:C1470.popupsubmenu:=New collection:C1472
	This:C1470.popupmenu:=This:C1470._getTableMenu(This:C1470.fieldlist)
	For each ($line; $object.lines)
		This:C1470.querylines.push(cs:C1710.queryLine.new($line))
	End for each 
	This:C1470.renderForm(This:C1470.sub)
	
Function useOldSaveObject($object)  // use original 4DF format, only available for local data store
	// clear existing query, start new one
	This:C1470.querylines:=New collection:C1472
	
	If (Num:C11($object.version)#3)
		ALERT:C41(Get localized string:C991("Errors_fileVersionUnhandled"))
		return 
	End if 
	
	// check all used table numbers
	$invalid:=False:C215
	$maxtable:=Get last table number:C254
	If ((Num:C11($object.mainTable)<1) || (Num:C11($object.mainTable)>$maxtable))
		$invalid:=True:C214
	End if 
	For each ($line; $object.lines)
		If ((Num:C11($line.tableNumber)<1) || (Num:C11($line.tableNumber)>$maxtable))
			$invalid:=True:C214
		End if 
	End for each 
	If ($invalid)
		ALERT:C41(Get localized string:C991("Alerts_theQueryContainsATableThatDoesNotExist"))
		return 
	End if 
	
	$class:=ds:C1482[Table name:C256(Num:C11($object.mainTable))]
	This:C1470.table:=$class
	This:C1470.counter:=0
	This:C1470.fieldlist:=This:C1470._getDSClassDetails(This:C1470.table)
	If (This:C1470.fieldlist.length=0)
		ALERT:C41(Get localized string:C991("Errors_anErrorOccurredWhileOpeningTheFile"))
		This:C1470.reset()
		return 
	End if 
	This:C1470.popupsubmenu:=New collection:C1472
	This:C1470.popupmenu:=This:C1470._getTableMenu(This:C1470.fieldlist)
	For each ($line; $object.lines)
		$line_translated:=New object:C1471
		If (Num:C11($line.tableNumber)=Num:C11($object.mainTable))
			$line_translated.field:=Field name:C257(Num:C11($line.tableNumber); Num:C11($line.fieldNumber))
		Else   // related table
			$relation:=This:C1470._ORDA_FindRelationPath(Table name:C256(Num:C11($object.mainTable)); Table name:C256(Num:C11($line.tableNumber)); 5)
			If ($relation#"")
				$line_translated.field:=Substring:C12($relation; 2)+"."+Field name:C257(Num:C11($line.tableNumber); Num:C11($line.fieldNumber))
			End if 
		End if 
		$line_translated.operator:=Num:C11($line.lineOperator)
		$line_translated.compare:=Num:C11($line.criterion)
		$line_translated.value1:=String:C10($line.oneBox)+String:C10($line.firstOfTwoBoxes)+String:C10($line.oneBoxWithUnits)
		$line_translated.value2:=String:C10($line.secondOfTwoBoxes)
		$line_translated.compare2:=Num:C11($line.units)-1
		If ($line_translated.compare2<0)
			$line_translated.compare2:=0
		End if 
		This:C1470.querylines.push(cs:C1710.queryLine.new($line_translated))
	End for each 
	This:C1470.renderForm(This:C1470.sub)
	
	//missing
	// querydestination
	// japanese
	
	
Function _ORDA_FindRelationPath($FromClassName : Text; $ToClassName : Text; $MaxDepth : Integer)->$pathout : Text
	// find path between two classes
	// $1 = classFrom, $2 = classTo, $3 = maxdepth
	// $0 := path
	// not public
	
	C_OBJECT:C1216($field)
	C_TEXT:C284($name)
	$pathout:=""
	
	ASSERT:C1129($FromClassName#""; "$1 must not be empty")
	ASSERT:C1129($ToClassName#""; "$2 must not be empty")
	ASSERT:C1129(($MaxDepth>=0) & ($MaxDepth<10); "$3 must be in range 0..9")
	ASSERT:C1129(ds:C1482[$FromClassName]#Null:C1517; "$1 must be the name of a data class")
	ASSERT:C1129(ds:C1482[$ToClassName]#Null:C1517; "$1 must be the name of a data class")
	
	For each ($name; ds:C1482[$FromClassName]) Until ($pathout#"")
		$field:=ds:C1482[$FromClassName][$name]
		If (($field.kind="relatedEntity") | ($field.kind="relatedEntities"))
			If ($field.relatedDataClass=$ToClassName)  // hit
				$pathout:="."+$field.name
			End if 
		End if 
	End for each 
	
	// if no, for all properties of kind = relatedEntity or relatedEntities run recursive to find To
	If ($pathout="")  // not found
		If ($MaxDepth>0)
			For each ($name; ds:C1482[$FromClassName]) While ($pathout="")
				$field:=ds:C1482[$FromClassName][$name]
				If (($field.kind="relatedEntity") | ($field.kind="relatedEntities"))
					$pathout:=This:C1470._ORDA_FindRelationPath($field.relatedDataClass; $ToClassName; $MaxDepth-1)
					If ($pathout#"")
						$pathout:="."+$field.name+$pathout
					End if 
				End if 
			End for each 
		End if 
	End if 