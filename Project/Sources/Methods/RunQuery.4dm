//%attributes = {"shared":true}
#DECLARE($queryIn : Object)->$query : Object
$win:=Open form window:C675("QueryEditor")
//$entsel:=ds.Customer
//$query:=New object:C1471("tablename"; "Customer")
DIALOG:C40("QueryEditor"; $queryIn)
CLOSE WINDOW:C154($win)
If (OK=1)
	$query:=$queryIn.query
	$query.OK:=OK
Else 
	$query:=New object:C1471("OK"; OK)
End if 
/*
If (OK=1)
	$settings:=New object:C1471("parameters"; $query.query.para)
	$entsel:=ds:C1482.Customer.query($query.query.query_statement; $settings)
End if 
*/