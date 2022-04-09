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
	
Function renderObjects($data : Object)->$objects : Object
	$counter:=Num:C11($data.counter)
	
	$objects:=New object:C1471
	$subcounter:=0
	
	This:C1470.listentry:=$counter
	
	$x:=20
	
	$object:=New object:C1471
	$object.type:="input"  //_"+String($counter)
	$object.dataSource:="Form:C1466.field_"+String:C10(This:C1470.id)
	$object.left:=$x
	$object.top:=20+($counter*35)
	$object.width:=120
	$object.height:=17
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_"+String:C10($subcounter)]:=$object
	
	$x+=125
	
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.focusable:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.picture:="/RESOURCES/Query/miniDrop.png"
	$object.left:=$x
	$object.top:=20+($counter*35)
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_fieldlist"]:=$object
	
	$x+=35
	$object:=New object:C1471
	$object.type:="button"
	$object.text:=This:C1470.name || "button2_"+String:C10($counter)+"B"
	$object.action:="Cancel"
	$object.left:=$x
	$object.top:=20+($counter*35)
	$object.width:=100
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_"+String:C10($subcounter)]:=$object
	
	
	
	$x+=120
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.picture:="/RESOURCES/Query/miniPlus.png"
	$object.switchWhenRollover:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.useLastFrameAsDisabled:=True:C214
	$object.left:=$x
	$object.top:=20+($counter*35)
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_+"]:=$object
	
	$x+=25
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.picture:="/RESOURCES/Query/miniMinus.png"
	$object.switchWhenRollover:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.useLastFrameAsDisabled:=True:C214
	$object.left:=$x
	$object.top:=20+($counter*35)
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_-"]:=$object
	
	// popup2 with Condition, Content depending of field type
	
	
Function setValue($value : Text)
	Form:C1466.sub["field_"+String:C10(This:C1470.id)]:=$value
	