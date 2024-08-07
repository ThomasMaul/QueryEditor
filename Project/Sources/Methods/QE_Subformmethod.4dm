//%attributes = {}
// project method, as we cannot call formulas through execute method in subform

#DECLARE($job : Text; $name : Text; $data : Text)->$result : Text

Case of 
	: ($job="disable")
		OBJECT SET ENABLED:C1123(*; "@-"; False:C215)
		
	: ($job="popup")
		var $left; $top; $right; $bottom : Integer
		// wrong context..., needs to execute in subform
		OBJECT GET COORDINATES:C663(*; $name; $left; $top; $right; $bottom)
		CONVERT COORDINATES:C1365($left; $top; XY Current form:K27:5; XY Screen:K27:7)
		CONVERT COORDINATES:C1365($right; $bottom; XY Current form:K27:5; XY Screen:K27:7)
		var $win:=Open window:C153($left; $bottom+1; $right; $bottom+200; Pop up window:K34:14)
		// we create a minimized form, just with the text field
		var $form:=New object:C1471
		var $object:=New object:C1471
		$object.type:="input"  //_"+String($counter)
		$object.dataSource:="Form:C1466.entry"
		$object.left:=0
		$object.top:=0
		$object.width:=$right-$left-5
		$object.height:=199
		var $objects:=New object:C1471("entry"; $object)
		var $page1:=New object:C1471("objects"; $objects)
		$form.pages:=New collection:C1472(Null:C1517; $page1)
		var $formdata:=New object:C1471("entry"; $data)
		DIALOG:C40($form; $formdata)
		CLOSE WINDOW:C154($wiN)
		$result:=$formdata.entry
End case 