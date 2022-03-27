If (FORM Event:C1606.code=On Load:K2:1)
	Form:C1466.counter:=1
	
	Form:C1466.code:=New object:C1471
	$button1:=New object:C1471
	$button1.type:="button"
	$button1.text:="button_"+String:C10(Form:C1466.counter)
	$button1.action:="Cancel"
	$button1.left:=20
	$button1.top:=20+(Form:C1466.counter*20)
	$button1.width:=80
	$button1.heigth:=20
	$objects:=New object:C1471("button1"; $button1)
	$page1:=New object:C1471("objects"; $objects)
	Form:C1466.code.pages:=New collection:C1472(Null:C1517; $page1)
	
	OBJECT SET SUBFORM:C1138(*; "sub"; Form:C1466.code)
	
End if 