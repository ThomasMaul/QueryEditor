Class constructor($data : Object)  // $ID
	If ($data.id#Null:C1517)
		This:C1470.id:=String:C10($data.id)
	Else 
		This:C1470.id:=Generate UUID:C1066
	End if 
	This:C1470.ds_class:=""
	This:C1470.name:=String:C10($data.name)
	This:C1470.displayName:=This:C1470.name
	This:C1470.fieldtype:=1
	This:C1470.operator:="="
	This:C1470.value:=""
	This:C1470.value2:=""
	This:C1470.listentry:=0
	This:C1470.setValue(0)
	
Function renderObjects($data : Object)->$objects : Object
	$counter:=Num:C11($data.counter)
	
	$objects:=New object:C1471
	$subcounter:=0
	
	This:C1470.listentry:=$counter
	
	$x:=20
	$heightdiff:=30
	
	$object:=New object:C1471
	$object.type:="input"  //_"+String($counter)
	$object.dataSource:="Form:C1466.field_"+String:C10(This:C1470.id)
	$object.left:=$x
	$object.top:=20+($counter*$heightdiff)
	$object.width:=150
	$object.height:=17
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_"+String:C10($subcounter)]:=$object
	
	$x+=155
	
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.focusable:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.picture:="/RESOURCES/Query/miniDrop.png"
	$object.left:=$x
	$object.top:=18+($counter*$heightdiff)
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_fieldlist"]:=$object
	
	$x+=27
	$object:=New object:C1471
	$object.type:="dropdown"
	$object.fontSize:=10
	$object.dataSource:="Form:C1466.cond_combo_"+String:C10(This:C1470.id)
	$object.left:=$x
	$object.top:=19+($counter*$heightdiff)
	$object.width:=150
	$object.height:=20
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
			$width1:=0
		: (This:C1470.combotype=1)
			$width1:=260
		: (This:C1470.combotype=2)
			$width1:=120
		: (This:C1470.combotype=3)
			$width1:=120
		: (This:C1470.combotype=4)
			$width1:=0
		: (This:C1470.combotype=5)
			$width1:=230
	End case 
	
	If ($width1#0)
		$x+=160
		$object:=New object:C1471
		$object.type:="input"
		$object.dataSource:="Form:C1466.value1_"+String:C10(This:C1470.id)
		$object.left:=$x
		$object.top:=19+($counter*$heightdiff)
		$object.width:=$width1
		$object.height:=20
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
			$object.top:=22+($counter*$heightdiff)
			$object.width:=50
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_text1"]:=$object
			
			$width2:=120
			$x+=($width1+40)
			$object:=New object:C1471
			$object.type:="input"
			$object.dataSource:="Form:C1466.value2_"+String:C10(This:C1470.id)
			$object.left:=$x
			$object.top:=19+($counter*$heightdiff)
			$object.width:=$width2
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_value2"]:=$object
			
		: (This:C1470.combotype=3)
			$object:=New object:C1471
			$object.type:="dropdown"
			$object.fontSize:=10
			$object.dataSource:="Form:C1466.combo2_"+String:C10(This:C1470.id)
			$object.left:=$x+$width1+5
			$object.top:=19+($counter*$heightdiff)
			$object.width:=150
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_popup2"]:=$object
			//popup fill depending of type
			// date, pict, time, blob
			$oPop:=New object:C1471
			STRING LIST TO ARRAY:C511("TimeCriteriaBis"; $strings)
			
			$oPop.values:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)].extract("text")
			$oPop.index:=0
			Form:C1466.sub["combo2_"+String:C10(This:C1470.id)]:=$oPop
			
			
		: (This:C1470.combotype=4)
			$width1:=0
		: (This:C1470.combotype=5)
			$width1:=210
	End case 
	
	// end entry area
	
	$x:=650
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.picture:="/RESOURCES/Query/miniMinus.png"
	$object.switchWhenRollover:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.useLastFrameAsDisabled:=True:C214
	$object.left:=$x
	$object.top:=18+($counter*$heightdiff)
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
	$object.top:=18+($counter*$heightdiff)
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_+"]:=$object
	
	
	
Function setValue($value : Variant)
	If (Value type:C1509($value)=Is text:K8:3)
		Form:C1466.sub["field_"+String:C10(This:C1470.id)]:=$value
		$field:=Form:C1466.editor.table[$value]
	Else 
		$fieldname:=Form:C1466.editor.fieldlist[0].name
		Form:C1466.sub["field_"+String:C10(This:C1470.id)]:=$fieldname
		$field:=Form:C1466.editor.table[$fieldname]
	End if 
	This:C1470.fieldtype:=$field.fieldType
	Case of 
		: ((This:C1470.fieldtype=8) | (This:C1470.fieldtype=9) | (This:C1470.fieldtype=25))
			This:C1470.fieldtype:=1
		: ((This:C1470.fieldtype=24) | (This:C1470.fieldtype=0))
			This:C1470.fieldtype:=2
	End case 
	$oPop:=New object:C1471
	$oPop.values:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)].extract("text")
	$oPop.index:=0
	Form:C1466.sub["cond_combo_"+String:C10(This:C1470.id)]:=$oPop
	This:C1470.combotype:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)][$oPop.index].type
	
Function setCondition($value : Integer)
	This:C1470.combotype:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)][$value].type
	
	