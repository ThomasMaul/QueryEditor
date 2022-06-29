//%attributes = {"shared":true}
#DECLARE($queryIn : Object)->$query : Object
If ($queryIn.dialogType=Null:C1517)
	$queryIn.dialogType:=Sheet form window:K39:12
End if 
$win:=Open form window:C675("QueryEditor"; $queryIn.dialogType)
DIALOG:C40("QueryEditor"; $queryIn)
CLOSE WINDOW:C154($win)
If (OK=1)
	$query:=$queryIn.query
	$query.OK:=OK
Else 
	$query:=New object:C1471("OK"; OK)
End if 
