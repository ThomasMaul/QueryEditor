Class constructor($name : Text)
	This:C1470.id:=Generate UUID:C1066
	This:C1470.ds_class:=""
	This:C1470.name:=$name
	This:C1470.displayName:=This:C1470.name
	This:C1470.fieldtype:=1
	This:C1470.operator:="="
	This:C1470.value:=""
	This:C1470.value2:=""
	
Function renderObjects($data : Object)->$objects : Object
	$counter:=Num:C11($data.counter)
	
	$objects:=New object:C1471
	$subcounter:=0
	
	$object:=New object:C1471
	$object.type:="button"
	$object.text:=This:C1470.name || "button_"+String:C10($counter)
	$object.action:="Cancel"
	$object.left:=20
	$object.top:=20+($counter*35)
	$object.width:=120
	$object.heigth:=20
	
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_"+String:C10($subcounter)]:=$object
	
	$object:=New object:C1471
	$object.type:="button"
	$object.text:=This:C1470.name || "button2_"+String:C10($counter)+"B"
	$object.action:="Cancel"
	$object.left:=160
	$object.top:=20+($counter*35)
	$object.width:=120
	$object.heigth:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_"+String:C10($subcounter)]:=$object
	
	$object:=New object:C1471
	$object.type:="button"
	$object.text:="+"
	$object.left:=300
	$object.top:=20+($counter*35)
	$object.width:=35
	$object.heigth:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_+"]:=$object
	
	$object:=New object:C1471
	$object.type:="button"
	$object.text:="-"
	
	$object.left:=340
	$object.top:=20+($counter*35)
	$object.width:=35
	$object.heigth:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_-"]:=$object