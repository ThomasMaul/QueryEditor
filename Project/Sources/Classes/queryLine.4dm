Class constructor($data : Object)  // $ID
	If ($data.id#Null:C1517)
		This:C1470.id:=String:C10($data.id)
	Else 
		This:C1470.id:=String:C10(Form:C1466.editor.getNextCounter())
	End if 
	
	This:C1470._cond_combo:=New object:C1471
	This:C1470._combo2:=New object:C1471
	This:C1470._operator:=New object:C1471
	
	This:C1470.listentry:=0
	This:C1470.popup2:=Num:C11($data.compare2)
	This:C1470.operator:=Num:C11($data.operator)
	This:C1470.comboid:=Num:C11($data.compare)
	This:C1470.height:=30
	
	// line content storage
	If (String:C10($data.field)#"")
		This:C1470.setValue($data.field)
		var $oPop:=New object:C1471
		$oPop.values:=Form:C1466.editor.operators.copy()
		$oPop.index:=This:C1470.operator
		This:C1470._operator:=$oPop
		This:C1470.buildConditionPopup($data.compare)
	Else 
		This:C1470._field:=""
		This:C1470.name:=This:C1470._field
		This:C1470.displayName:=This:C1470.name
		This:C1470.fieldtype:=1
		This:C1470.setValue(0)
	End if 
	This:C1470._value1:=$data.value1
	This:C1470._value2:=$data.value2
	
	
	
Function renderObjects($data : Object)->$objects : Object
	var $counter:=Num:C11($data.counter)
	
	$objects:=New object:C1471
	var $subcounter:=0
	
	This:C1470.listentry:=$counter
	
	var $x:=80
	var $y : Integer:=10+(($counter-1)*This:C1470.height)
	
	// static text or And/Or/Except popup
	If ($counter=1)  // first line
		var $object:=New object:C1471
		$object.type:="text"
		$object.fontSize:=10
		$object.text:=Get localized string:C991("label_Find")
		$object.left:=5
		$object.top:=$y+2
		$object.width:=65
		$object.height:=14
		$objects["ob_0_text1"]:=$object
	Else 
		$object:=New object:C1471
		$object.type:="dropdown"
		$object.fontSize:=10
		$object.dataSource:="Form:C1466.editor.querylines["+String:C10($counter-1)+"]._operator"
		$object.left:=5
		$object.top:=$y-1
		$object.width:=65
		$object.height:=19
		$subcounter+=1
		$objects["ob_"+String:C10($counter)+"_operator"]:=$object
		var $oPop:=New object:C1471
		$oPop.values:=Form:C1466.editor.operators.copy()
		$oPop.index:=This:C1470.operator
		This:C1470._operator:=$oPop
	End if 
	
	// ## entry field name
	$object:=New object:C1471
	$object.type:="input"  //_"+String($counter)
	$object.enterable:=False:C215
	$object.dataSource:="Form:C1466.editor.querylines["+String:C10($counter-1)+"].displayName"  //_field"
	$object.left:=$x
	$object.top:=$y
	$object.width:=230
	$object.height:=17
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_"+String:C10($subcounter)]:=$object
	
	$x+=235
	// ## popup field name
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.focusable:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.picture:="/RESOURCES/Query/miniDrop.png"
	$object.left:=$x
	$object.top:=$y-2
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_fieldlist"]:=$object
	
	// ## popup operation
	$x+=27
	$object:=New object:C1471
	$object.type:="dropdown"
	$object.fontSize:=10
	$object.dataSource:="Form:C1466.editor.querylines["+String:C10($counter-1)+"]._cond_combo"
	$object.left:=$x
	$object.top:=$y-1
	$object.width:=160
	$object.height:=19
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_condition"]:=$object
	
/* # "type" = how the line will be displayed
      0 = no box (example "[ is today ]")
      1 = one box (example " =  [ 20 ]")
      2 = two box (example "between [__] & [__]")
      3 = one box + one popup (example "[ 2 ] [Months]) 
      4 = only 1 popup
      5 = one box + button edit list
*/
	
	// 0, 1 ,2 - next 3
	
	Case of 
		: (This:C1470.combotype=0)
			var $width1:=0
		: (This:C1470.combotype=1)
			$width1:=270
		: (This:C1470.combotype=2)
			$width1:=110
		: (This:C1470.combotype=3)
			$width1:=110
		: (This:C1470.combotype=4)
			$width1:=0
		: (This:C1470.combotype=5)
			$width1:=230
	End case 
	
	$x+=170
	// ## first entry field
	If ($width1#0)
		$object:=New object:C1471
		$object.type:="input"
		var $fieldtype : Integer:=This:C1470.fieldtype
		var $valuetype:=Value type:C1509(This:C1470._value1)
		var $id:=Abs:C99(This:C1470.comboid)  // negative values for time
		Case of 
				// numeric fields but search in list: text entry!
			: (($fieldtype=Is alpha field:K8:1) | ($fieldtype=Is text:K8:3) | ($id=15))
				If (($valuetype#Is alpha field:K8:1) & ($valuetype#Is text:K8:3))
					This:C1470._value1:=""
				End if 
			: (($fieldtype=Is picture:K8:10) & (($id=14) | ($id=13)))
				If (($valuetype#Is alpha field:K8:1) & ($valuetype#Is text:K8:3))
					This:C1470._value1:=""
				End if 
			: ((($fieldtype=Is picture:K8:10) | ($fieldtype=Is BLOB:K8:12)) & (($id=3) | ($id=5)))
				If (($valuetype#Is real:K8:4) & ($valuetype#Is longint:K8:6) & ($valuetype#Is integer:K8:5) & ($valuetype#Is integer 64 bits:K8:25))
					This:C1470._value1:=0
				End if 
			: (($fieldtype=Is real:K8:4) | ($fieldtype=Is longint:K8:6) | ($fieldtype=Is integer:K8:5) | ($fieldtype=Is integer 64 bits:K8:25))
				If (($valuetype#Is real:K8:4) & ($valuetype#Is longint:K8:6) & ($valuetype#Is integer:K8:5) & ($valuetype#Is integer 64 bits:K8:25))
					This:C1470._value1:=0
				End if 
			: (($fieldtype=Is time:K8:8) && ($id<10) && (This:C1470.comboid>0))
				If ($valuetype#Is text:K8:3)
					This:C1470._value1:=String:C10(Current time:C178)
				Else 
					var $time:=Time:C179(This:C1470._value1)
					If (This:C1470._value1#Time string:C180($time))
						This:C1470._value1:=String:C10(Current time:C178)
					End if 
				End if 
			: ($fieldtype=Is time:K8:8)
				If ($valuetype#Is real:K8:4)
					This:C1470._value1:=1
				End if 
			: (($fieldtype=Is date:K8:7) && ($id<10))
				If ($valuetype#Is date:K8:7)
					This:C1470._value1:=Current date:C33
				End if 
			: ($fieldtype=Is date:K8:7)
				If ($valuetype#Is real:K8:4)
					This:C1470._value1:=1
				End if 
		End case 
		$object.dataSource:="Form:C1466.editor.querylines["+String:C10($counter-1)+"]._value1"
		var $filter:=This:C1470.getTextFilter()
		If ($filter#"")
			$object.entryFilter:=$filter
		End if 
		var $placeholder:=This:C1470.getPlaceholder()
		If ($placeholder#"")
			$object.placeholder:=$placeholder
		End if 
		$object.fontSize:=10
		$object.left:=$x
		$object.top:=$y+2
		$object.width:=$width1
		$object.height:=14
		$subcounter+=1
		$objects["ob_"+String:C10($counter)+"_value1"]:=$object
	End if 
	
	Case of 
		: (This:C1470.combotype=2)
			$object:=New object:C1471
			$object.type:="text"
			$object.fontSize:=10
			$object.text:=Get localized string:C991("operator_range")
			$object.left:=$x+$width1+5
			$object.top:=$y+2
			$object.width:=50
			$object.height:=14
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_text1"]:=$object
			
			var $width2:=120
			$x+=($width1+40)
			$object:=New object:C1471
			$object.type:="input"
			$object.fontSize:=10
			$fieldtype:=This:C1470.fieldtype
			$valuetype:=Value type:C1509(This:C1470._value2)
			$id:=Abs:C99(This:C1470.comboid)  // negative values for time
			Case of 
				: (($fieldtype=Is alpha field:K8:1) | ($fieldtype=Is text:K8:3) | ($id=15))
					If (($valuetype#Is alpha field:K8:1) & ($valuetype#Is text:K8:3))
						This:C1470._value2:=""
					End if 
				: (($fieldtype=Is real:K8:4) | ($fieldtype=Is longint:K8:6) | ($fieldtype=Is integer:K8:5) | ($fieldtype=Is integer 64 bits:K8:25))
					If (($valuetype#Is real:K8:4) & ($valuetype#Is longint:K8:6) & ($valuetype#Is integer:K8:5) & ($valuetype#Is integer 64 bits:K8:25))
						This:C1470._value2:=0
					End if 
				: ($fieldtype=Is time:K8:8)
					If ($valuetype#Is text:K8:3)
						This:C1470._value2:=String:C10(Current time:C178)
					Else 
						$time:=Time:C179(This:C1470._value2)
						If (This:C1470._value2#Time string:C180($time))
							This:C1470._value2:=String:C10(Current time:C178)
						End if 
					End if 
				: ($fieldtype=Is date:K8:7)
					If ($valuetype#Is date:K8:7)
						This:C1470._value2:=Current date:C33
					End if 
			End case 
			$object.dataSource:="Form:C1466.editor.querylines["+String:C10($counter-1)+"]._value2"
			$object.left:=$x
			$object.top:=$y+2
			$object.width:=$width2
			$object.height:=14
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_value2"]:=$object
			
		: (This:C1470.combotype=3)
			$object:=New object:C1471
			$object.type:="dropdown"
			$object.fontSize:=10
			$object.dataSource:="Form:C1466.editor.querylines["+String:C10($counter-1)+"]._combo2"
			$object.left:=$x+$width1+5
			$object.top:=$y-1
			$object.width:=150
			$object.height:=19
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_popup2"]:=$object
			$oPop:=New object:C1471
			Case of 
				: ((This:C1470.fieldtype=Is text:K8:3) | (This:C1470.fieldtype=Is alpha field:K8:1))
					$oPop.values:=Form:C1466.editor.lists.criteria_text
				: (This:C1470.fieldtype=Is date:K8:7)
					$oPop.values:=Form:C1466.editor.lists.criteria_date_a
				: (This:C1470.fieldtype=Is time:K8:8)
					$oPop.values:=Form:C1466.editor.lists.criteria_time_a
				: (This:C1470.fieldtype=Is picture:K8:10)
					If ((This:C1470.comboid=13) | (This:C1470.comboid=14))
						$oPop.values:=Form:C1466.editor.lists.criteria_pict_a
					Else 
						$oPop.values:=Form:C1466.editor.lists.criteria_pict_b
					End if 
				: (This:C1470.fieldtype=Is BLOB:K8:12)
					$oPop.values:=Form:C1466.editor.lists.criteria_blob_a
			End case 
			$oPop.index:=This:C1470.popup2
			This:C1470._combo2:=$oPop
			
		: (This:C1470.combotype=4)
			$object:=New object:C1471
			$object.type:="dropdown"
			$object.fontSize:=10
			$object.dataSource:="Form:C1466.editor.querylines["+String:C10($counter-1)+"]._combo2"
			$object.left:=$x+$width1
			$object.top:=$y-1
			$object.width:=130
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_popup2"]:=$object
			
			$oPop:=New object:C1471
			Case of 
				: (This:C1470.fieldtype=Is date:K8:7)
					$oPop.values:=Form:C1466.editor.lists.criteria_date_b
			End case 
			$oPop.index:=This:C1470.popup2
			This:C1470._combo2:=$oPop
			
			$object:=New object:C1471
			$object.type:="text"
			$object.fontSize:=9
			$object.text:=This:C1470._calculateDatePreview()
			$object.left:=$x+145
			$object.top:=$y+3
			$object.width:=100
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_text2"]:=$object
			
		: ((This:C1470.combotype=0) & (This:C1470.fieldtype=Is date:K8:7))  // date today/tomorrow
			$object:=New object:C1471
			$object.type:="text"
			$object.fontSize:=9
			$object.text:=This:C1470._calculateDatePreview()
			$object.left:=$x+145
			$object.top:=$y+3
			$object.width:=100
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_text2"]:=$object
			
		: (This:C1470.combotype=5)
			$width1:=240
			$object:=New object:C1471
			$object.type:="pictureButton"
			$object.columnCount:=1
			$object.rowCount:=4
			$object.focusable:=True:C214
			$object.switchBackWhenReleased:=True:C214
			$object.picture:="/RESOURCES/Query/miniDrop.png"
			$object.left:=$x+$width1
			$object.top:=$y-2
			$object.width:=20
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_clickbutton"]:=$object
	End case 
	
	// end entry area
	
	$x:=790
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.picture:="/RESOURCES/Query/miniMinus.png"
	$object.switchWhenRollover:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.useLastFrameAsDisabled:=True:C214
	$object.left:=$x
	$object.top:=$y-2
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_-"]:=$object
	
	$x+=20
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.picture:="/RESOURCES/Query/miniPlus.png"
	$object.switchWhenRollover:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.useLastFrameAsDisabled:=True:C214
	$object.left:=$x
	$object.top:=$y-2
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_+"]:=$object
	
Function getPlaceholder()->$Txt_placeholder : Text
	var $Lon_criteriaID:=Abs:C99(This:C1470.comboid)  // negative values for time
	Case of 
		: ($Lon_criteriaID=13) | ($Lon_criteriaID=14)
			$Txt_placeholder:=Get localized string:C991("Placeholder_valuesSeparatedBySpaces")
		: ($Lon_criteriaID=15)
			$Txt_placeholder:=Get localized string:C991("Placeholder_valuesSeparatedBySemicolons")
		Else 
			$Txt_placeholder:=""
	End case 
	
Function getTextFilter()->$Txt_filter : Text
	$Txt_filter:=""
	var $Txt_buffer : Text
	var $Lon_criteriaID : Integer:=This:C1470.comboid
	
	Case of 
		: (This:C1470.fieldtype=Is date:K8:7)
			If (($Lon_criteriaID=23) | ($Lon_criteriaID=33))
				$Txt_filter:="&\"0-9\""
			Else 
				GET SYSTEM FORMAT:C994(Date separator:K60:10; $Txt_buffer)
				$Txt_filter:=Replace string:C233("&\"0-9;%;-;/\""; "%"; $Txt_buffer)
			End if 
		: (This:C1470.fieldtype=Is time:K8:8)
			If ($Lon_criteriaID<0)
				$Txt_filter:="&\"0-9\""
			Else 
				//&"0-9;{user time separator}:"
				GET SYSTEM FORMAT:C994(Time separator:K60:11; $Txt_buffer)
				$Txt_filter:=Replace string:C233("&\"0-9;%;:\""; "%"; $Txt_buffer)
			End if 
		: (This:C1470.fieldtype=Is real:K8:4)
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $Txt_buffer)
			$Txt_filter:="&\"0-9;"+$Txt_buffer+";."+";-;+;:-<\""
		: ((This:C1470.fieldtype=Is longint:K8:6) | (This:C1470.fieldtype=Is integer:K8:5) | (This:C1470.fieldtype=Is integer 64 bits:K8:25))
			$Txt_filter:="&\"0-9;-;+"
	End case 
	
Function getRelationField($base : 4D:C1709.DataClass; $name : Text; $commingFromTable : Text)->$field : Object
	var $pos:=Position:C15("."; $name)
	If ($pos>0)
		var $relation:=Substring:C12($name; 1; $pos-1)
		var $fieldname:=Substring:C12($name; $pos+1)
		var $table : 4D:C1709.DataClass:=ds:C1482[$base[$relation].relatedDataClass]
		var $pos2:=Position:C15("."; $fieldname)
		If ($pos2>0)
			$field:=This:C1470.getRelationField($table; $fieldname; $relation+".")
			//$field.table:=$relation
		Else 
			$field:=$table[$fieldname]
			$field.table:=$commingFromTable+$relation
		End if 
	Else 
		ASSERT:C1129(True:C214; "internal error")
	End if 
	
Function findVirtualName($virtName : Text)->$displayName : Text
	var $virtnames : Collection:=Form:C1466.editor.virt_fieldllist.query("structure=:1"; $virtName)
	If ($virtnames.length>0)
		$displayName:=$virtnames[0].display
		var $pos:=This:C1470._lastPosition("."; $virtName)
		If ($pos>0)  // relation  
			$displayName:=This:C1470.findVirtualName(Substring:C12($virtName; 1; $pos-1))+"."+$displayName
		End if 
	Else 
		$displayName:=$virtName
	End if 
	
Function setValue($value : Variant)
	If (Value type:C1509($value)=Is text:K8:3)
		This:C1470._field:=$value
		var $pos:=Position:C15("."; $value)
		If ($pos>0)  // relation  
			var $field:=This:C1470.getRelationField(Form:C1466.editor.table; $value)
			//var $fieldname:=$field.name
			If (Form:C1466.editor.virt_fieldllist#Null:C1517)
				This:C1470.displayName:=This:C1470.findVirtualName($value)
				
				
				////#####
				//$virtnames:=Form.editor.virt_fieldllist.query("structure=:1"; $value)
				//If ($virtnames.length>0)
				//$virtTnames:=Form.editor.virt_fieldllist.query("structure=:1"; $field.table)
				//If ($virtTnames.length>0)
				//This.displayName:=$virtTnames[0].display+"."+$virtnames[0].display
				//Else 
				//This.displayName:=$field.table+"."+$virtnames[0].display
				//End if 
				////###### hier fehlt zweite Ebene, für mehrfache Verschachtelung!!!
				//// über Function geht virtuell name, die sich von vorne bis hinten durchkaspert?
				//// als Ersatz von virttnames, gleich über liste gehen
				//// $value ist customers.invoices.Feld3, das zerlegen und mit Display ersetzen
				//// customers.invoices.Feld3, customers.invoices, customers
				//// ergibt Customers.Invoices.Nr
				//Else 
				//This.displayName:=$value
				//End if 
			Else 
				This:C1470.displayName:=$value
			End if 
			This:C1470.fieldtype:=$field.fieldType
		Else 
			var $fields : Collection:=Form:C1466.editor.fieldlist.query("name=:1"; $value)
			If ($fields.length>0)
				$field:=$fields[0]
			Else 
				$field:=Form:C1466.editor.fieldlist[0]
			End if 
			//$field:=Form.editor.table[$value]
			This:C1470.fieldtype:=$field.type  //fieldType
			This:C1470.displayName:=$field.displayName
		End if 
	Else 
		$field:=Form:C1466.editor.fieldlist[0]
		This:C1470._field:=$field.name
		This:C1470.fieldtype:=$field.fieldType
		If ($field.displayName#Null:C1517)
			This:C1470.displayName:=$field.displayName
		Else 
			This:C1470.displayName:=$field.name
		End if 
	End if 
	This:C1470.name:=This:C1470._field
	
	Case of 
		: ((This:C1470.fieldtype=8) | (This:C1470.fieldtype=9) | (This:C1470.fieldtype=25))
			This:C1470.fieldtype:=1
		: ((This:C1470.fieldtype=24) | (This:C1470.fieldtype=0))
			This:C1470.fieldtype:=2
	End case 
	var $oPop:=New object:C1471
	$oPop.values:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)].extract("text")
	$oPop.index:=0
	This:C1470._cond_combo:=$oPop
	This:C1470.setCondition($oPop.index)
	
Function setCondition($value : Integer)
	This:C1470.combotype:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)][$value].type
	This:C1470.comboid:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)][$value].id
	
Function buildConditionPopup($value : Integer)
	var $oPop:=New object:C1471
	$oPop.values:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)].extract("text")
	var $indices : Collection:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)].indices("id=:1"; $value)
	$oPop.index:=($indices.length>0) ? $indices[0] : 1
	This:C1470._cond_combo:=$oPop
	This:C1470.setCondition($oPop.index)
	
Function setPopup2($value : Integer)
	This:C1470.popup2:=$value
	
Function setOperator($value : Integer)
	This:C1470.operator:=$value
	
Function getCondCombo()->$index : Integer
	$index:=This:C1470._cond_combo.index
	
Function getCombo2()->$index : Integer
	$index:=This:C1470._combo2.index
	
Function getOperatorIndex()->$index : Integer
	$index:=This:C1470._operator.index
	
Function _calculateDatePreview($data : Object)->$preview : Text
	var $dat_1; $dat_2; $dat_3 : Date
	
	var $Lon_popup_3 : Integer:=This:C1470.popup2
	var $Lon_criteriaID : Integer:=This:C1470.comboid
	var $Lon_value : Integer:=This:C1470._value1
	Case of 
		: ($Lon_criteriaID=11)  // today
			$Dat_1:=Current date:C33
		: ($Lon_criteriaID=21)  // yesterday
			$Dat_1:=Current date:C33-1
		: ($Lon_criteriaID=31)  // tomorrow
			$Dat_1:=Current date:C33+1
		: (($Lon_criteriaID=12) | ($Lon_criteriaID=22) | ($Lon_criteriaID=32))
			//"is within current" or "is within last" or "is within next"  + (week/month/quarter/year)"
			var $Lon_dayNumber:=Day number:C114(Current date:C33)-1  //1 to 7, 1 stands for sunday, so $daynumber = 0 = sunday
			var $Lon_day:=Day of:C23(Current date:C33)  //
			var $Lon_month:=Month of:C24(Current date:C33)
			var $Lon_year:=Year of:C25(Current date:C33)
			Case of 
				: ($Lon_popup_3<=2)  //"Week ( "sun-sat" or "mon-sat" or "mon-fri"
					Case of   // which part of the week
						: ($Lon_popup_3=0)  // Sunday to Saturday
							$Dat_2:=Add to date:C393(Current date:C33; 0; 0; (-1)*$Lon_dayNumber)  //find sunday
							$Dat_3:=$Dat_2+6  // add 6 to find saturday
						: ($Lon_popup_3=1)  // Monday to Sunday
							$Dat_2:=Add to date:C393(Current date:C33; 0; 0; ((-1)*$Lon_dayNumber)+1)  //find monday
							$Dat_3:=$Dat_2+6  // add 6 to find sunday
						: ($Lon_popup_3=2)
							$Dat_2:=Add to date:C393(Current date:C33; 0; 0; ((-1)*$Lon_dayNumber)+1)  //find monday
							$Dat_3:=$Dat_2+4  // add 4 to find friday
					End case 
					Case of   // this, previous, next week
						: ($Lon_criteriaID=12)  // current (week)
							// do nothing
						: ($Lon_criteriaID=22)  // previous (week)
							$Dat_2:=$Dat_2-7
							$Dat_3:=$Dat_3-7
						: ($Lon_criteriaID=32)  // next (week)
							$Dat_2:=$Dat_2+7
							$Dat_3:=$Dat_3+7
					End case 
					
				: ($Lon_popup_3=3)  //"Month"
					Case of 
						: ($Lon_criteriaID=12)  // current (week)
							// do nothing
						: ($Lon_criteriaID=22)  //previous (month)
							$Lon_month:=$Lon_month-1
							If ($Lon_month=0)
								$Lon_month:=12
								$Lon_year:=$Lon_year-1
							End if 
						: ($Lon_criteriaID=32)  //next (month)
							$Lon_month:=$Lon_month+1
							If ($Lon_month=12)
								$Lon_month:=0
								$Lon_year:=$Lon_year+1
							End if 
					End case 
					$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; $Lon_month; 1)
					$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; $Lon_month+1; 1)-1
				: ($Lon_popup_3=4)  //"Quarter")
					Case of 
						: ($Lon_criteriaID=22)  //previous (quarter)
							$Lon_month:=$Lon_month-3
							If ($Lon_month<=0)
								$Lon_month:=$Lon_month+12
								$Lon_year:=$Lon_year-1
							End if 
						: ($Lon_criteriaID=32)  //next  (quarter)
							$Lon_month:=$Lon_month+3
							If ($Lon_month>12)
								$Lon_month:=$Lon_month-12
								$Lon_year:=$Lon_year+1
							End if 
					End case 
					Case of 
						: ($Lon_month<=3)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 1; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; 4; 1)-1
						: ($Lon_month<=6)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 4; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; 7; 1)-1
						: ($Lon_month<=9)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 7; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; 10; 1)-1
						: ($Lon_month<=12)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 10; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year+1; 1; 1)-1
					End case 
				: ($Lon_popup_3=5)  //"Year"
					Case of 
						: ($Lon_criteriaID=22)  //previous (year)
							$Lon_year:=$Lon_year-1
						: ($Lon_criteriaID=32)  //next (year)
							$Lon_year:=$Lon_year+1
					End case 
					$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 1; 1)
					$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year+1; 1; 1)-1
			End case 
		: ($Lon_criteriaID=23)  //"Is within THE last")  (N days month years)
			$Dat_3:=Current date:C33
			Case of 
				: ($Lon_popup_3=0)  //"Days"
					$Dat_2:=Add to date:C393($Dat_3; 0; 0; (-1)*$Lon_value)
				: ($Lon_popup_3=1)  //"Weeks"
					$Dat_2:=Add to date:C393($Dat_3; 0; 0; (-7)*$Lon_value)
				: ($Lon_popup_3=2)  //Monthes"
					$Dat_2:=Add to date:C393($Dat_3; 0; (-1)*$Lon_value; 0)
				: ($Lon_popup_3=3)  //"Years"
					$Dat_2:=Add to date:C393($Dat_3; (-1)*$Lon_value; 0; 0)
			End case 
		: ($Lon_criteriaID=33)  //"Is within the next" (N days month years)
			$Dat_2:=Current date:C33
			Case of 
				: ($Lon_popup_3=0)  //"Days"
					$Dat_3:=Add to date:C393($Dat_2; 0; 0; $Lon_value)
				: ($Lon_popup_3=1)  //"Weeks"
				: ($Lon_popup_3=2)  //Monthes"
					$Dat_3:=Add to date:C393($Dat_2; 0; $Lon_value; 0)
				: ($Lon_popup_3=3)  //"Years"
					$Dat_3:=Add to date:C393($Dat_2; $Lon_value; 0; 0)
			End case 
	End case 
	If (($dat_1#!00-00-00!) & ($dat_2=!00-00-00!) & ($dat_3=!00-00-00!))
		$preview:="("+String:C10($dat_1)+")"
	Else 
		$preview:="("+String:C10($Dat_2)+" - "+String:C10($Dat_3)+")"
	End if 
	If ($data#Null:C1517)
		$data.dat1:=$dat_1
		$data.dat2:=$dat_2
		$data.dat3:=$dat_3
	End if 
	
Function createQueryStatement($para : Object; $clearText : Boolean)->$statement : Text
	var $value; $value2 : Variant
	
	If (Bool:C1537($clearText))
		$statement:=This:C1470.displayName+" "
	Else 
		$statement:=This:C1470.name+" "
	End if 
	var $comperator:=""
	var $id:=Abs:C99(This:C1470.comboid)  // negative values for time
	var $type : Integer:=This:C1470.fieldtype
	
	
	// exceptions first for empty/not empty
	Case of 
		: (($id=41) && (($type=Is picture:K8:10) | ($type=Is BLOB:K8:12) | ($type=Is object:K8:27)))
			$statement+="== null"
		: (($id=42) && (($type=Is picture:K8:10) | ($type=Is BLOB:K8:12) | ($type=Is object:K8:27)))
			$statement+="!= null"
			
		: ((($id=3) | ($id=5)) && (($type=Is picture:K8:10) | ($type=Is BLOB:K8:12)))  // size > or <
			// need to create formula, value * unit
			var $size:=Num:C11(This:C1470._value1)
			var $unit : Integer:=This:C1470.popup2
			Case of 
				: ($unit=1)
					$size*=1024
				: ($unit=2)
					$size*=1024*1024
				: ($unit=3)
					$size*=1024*1024*1024
			End case 
			Case of 
				: (($id=3) & ($type=Is picture:K8:10))
					$statement:="eval(picture size(this."+This:C1470.name+")>="+String:C10($size)+")"
				: (($id=5) & ($type=Is picture:K8:10))
					$statement:="eval(picture size(this."+This:C1470.name+")<="+String:C10($size)+")"
				: (($id=3) & ($type=Is BLOB:K8:12))
					$statement:="eval(blob size(this."+This:C1470.name+")>="+String:C10($size)+")"
				: (($id=5) & ($type=Is BLOB:K8:12))
					$statement:="eval(blob size(this."+This:C1470.name+")<="+String:C10($size)+")"
			End case 
			
		Else   // everything else
			
			Case of 
				: (($id=0) | ($id=1))
					$comperator:="=="
				: ($id=2)
					$comperator:="#"
				: (($id=3) | ($id=7) | ($id=12) | ($id=22) | ($id=32) | ($id=23) | ($id=33))
					$comperator:=">="
				: (($id=4) | ($id=8))
					$comperator:=">"
				: ($id=5)
					$comperator:="<="
				: ($id=6)
					$comperator:="<"
				: ($id=15)
					$comperator:="IN"
					
				: ((($id=11) | ($id=9) | ($id=10) | ($id=41)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3) | ($type=Is date:K8:7)))  // contains
					$comperator:="=="
				: ((($id=12) | ($id=42)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))
					$comperator:="#"
				: ((($id=13) | ($id=14)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3) | ($type=Is picture:K8:10)))
					$comperator:="%"
			End case 
			
			$statement+=($comperator+" :value_"+String:C10(This:C1470.id))
			If ($id=14)
				var $not:=Get localized string:C991("QueryNot")
				$statement:=$not+"("+$statement+")"
			End if 
			Case of 
				: ($id=15)
					$value:=New collection:C1472
					$value:=Split string:C1554(String:C10(This:C1470._value1); ";")  // list
				: (($id=13) | ($id=14))
					$value:=New collection:C1472
					$value:=Split string:C1554(This:C1470._value1; " ")  // words
				Else 
					$value:=This:C1470._value1
			End case 
			Case of 
				: (($id=0) && ($type=Is boolean:K8:9))
					$value:=False:C215
				: (($id=1) && ($type=Is boolean:K8:9))
					$value:=True:C214
					
				: ((($id=11) | ($id=12)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))  // contains
					$value:="@"+$value+"@"
				: (($id=9)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3))
					$value:=$value+"@"
				: (($id=10) | ($id=7)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3))
					$value:="@"+$value
				: ((($id=41) | ($id=42)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))  // contains
					$value:=""
				: ((($id=11) | ($id=21) | ($id=31)) && ($type=Is date:K8:7))  // contains
					var $data:=New object:C1471
					var $preview:=This:C1470._calculateDatePreview($data)
					$value:=$data.dat1
				: ((($id=12) | ($id=22) | ($id=32) | ($id=23) | ($id=33)) && ($type=Is date:K8:7))  // date in
					$data:=New object:C1471
					$preview:=This:C1470._calculateDatePreview($data)
					$value:=$data.dat2
					$value2:=$data.dat3
			End case 
			$para["value_"+String:C10(This:C1470.id)]:=$value
			
			Case of 
				: (($id=7) | ($id=8))
					$statement:="("+$statement+")&("+This:C1470.name+" <"
					If ($id=7)
						$statement+="="
					End if 
					$statement+=(" :value2_"+String:C10(This:C1470.id))+")"
					$value2:=This:C1470._value2
					If (($id=7) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))
						$value2:=String:C10($value2)+"@"
					End if 
					$para["value2_"+String:C10(This:C1470.id)]:=$value2
					
				: ((($id=12) | ($id=22) | ($id=32) | ($id=23) | ($id=33)) && ($type=Is date:K8:7))  // date
					$statement:="("+$statement+")&("+This:C1470.name+" <="
					$statement+=(" :value2_"+String:C10(This:C1470.id))+")"
					$para["value2_"+String:C10(This:C1470.id)]:=$value2
					
				: ((($id=23) | ($id=33)) && ($type=Is time:K8:8))
					$statement:="("+$statement+")&("+This:C1470.name+" <="
					$statement+=(" :value2_"+String:C10(This:C1470.id))+")"
					var $time:=Num:C11($value)
					Case of 
						: (This:C1470.popup2=0)  //  hour
							$time*=3600
						: (This:C1470.popup2=1)  // minute
							$time*=60
					End case 
					If ($id=23)
						$para["value_"+String:C10(This:C1470.id)]:=Time string:C180(Current time:C178-$time)
						$para["value2_"+String:C10(This:C1470.id)]:=String:C10(Current time:C178)
					Else 
						$para["value_"+String:C10(This:C1470.id)]:=String:C10(Current time:C178)
						$para["value2_"+String:C10(This:C1470.id)]:=Time string:C180(Current time:C178+$time)
					End if 
				: (This:C1470.comboid<0)
					$time:=Num:C11($value)
					Case of 
						: (This:C1470.popup2=0)  //  hour
							$time*=3600
						: (This:C1470.popup2=1)  // minute
							$time*=60
					End case 
					$para["value_"+String:C10(This:C1470.id)]:=String:C10($time)  // not exakt time, but duration
			End case 
	End case 
	
	If (($id=13) | ($id=14))  // exception keyword search, needs to be expanded
		var $or : Boolean:=(This:C1470._combo2.index=1)
		Case of 
			: ($value.length=0)
				$para["value_"+String:C10(This:C1470.id)]:=""
			: ($value.length=1)
				$para["value_"+String:C10(This:C1470.id)]:=$value[0]
			Else 
				// we need to add one statement per line
				var $orig_statement:=$statement
				$statement:="("
				var $subcounter:=0
				OB REMOVE:C1226($para; "value_"+String:C10(This:C1470.id))
				var $word : Text
				For each ($word; $value)
					$subcounter+=1
					If ($subcounter>1)
						If ($or)
							$statement+=" or "
						Else 
							$statement+=" and "
						End if 
					End if 
					var $newstatement : Text:="("+Replace string:C233($orig_statement; "value_"+String:C10(This:C1470.id); "value"+String:C10($subcounter)+"_"+String:C10(This:C1470.id))
					$para["value"+String:C10($subcounter)+"_"+String:C10(This:C1470.id)]:=$word
					$statement+=($newstatement+")")
				End for each 
				$statement+=")"
		End case 
	End if 
	
Function itemlist_entrywindow()
	// opens a popup window with text entry
	//  needs to execute in subform
	var $old:=Replace string:C233(This:C1470._value1; ";"; Char:C90(13))
	var $result : Text
	EXECUTE METHOD IN SUBFORM:C1085("sub"; Formula:C1597(QE_Subformmethod).source; $result; "popup"; "ob_"+String:C10(This:C1470.id)+"_value1"; $old)
	This:C1470._value1:=Replace string:C233($result; Char:C90(13); ";")
	
Function createSaveObject()->$object
	// builds an object to save the current query line
	$object:=New object:C1471
	$object._combo2:=New object:C1471
	$object._operator:=New object:C1471
	$object.field:=This:C1470._field
	$object.operator:=This:C1470.operator
	$object.compare:=This:C1470.comboid
	$object.value1:=This:C1470._value1
	$object.value2:=This:C1470._value2
	$object.compare2:=This:C1470.popup2
	
Function _lastPosition($whatChar : Text; $in : Text)->$where : Integer
	ASSERT:C1129(Length:C16($in)>0; "Internal Error: Search Text must not be empty")
	var $pos:=Length:C16($in)
	var $length:=Length:C16($whatChar)
	While ($pos>0)
		If (Substring:C12($in; $pos; $length)=$whatChar)
			return $pos
		End if 
		$pos-=1
	End while 
	$where:=-1
	