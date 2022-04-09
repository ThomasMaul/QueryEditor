Form:C1466.counter+=1

$button1:=New object:C1471
$button1.type:="button"
$button1.text:="button_"+String:C10(Form:C1466.counter)
$button1.action:="Cancel"
$button1.left:=20
$button1.top:=20+(Form:C1466.counter*20)
$button1.width:=80
$button1.heigth:=20

Form:C1466.code.pages[1].objects["button"+String:C10(Form:C1466.counter)]:=$button1

C_OBJECT:C1216($code)
$code:=Form:C1466.code
OBJECT SET SUBFORM:C1138(*; "sub"; $code)