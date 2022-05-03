//%attributes = {}
$win:=Open form window:C675("QueryEditor")
//$entsel:=ds.Customer
$query:=New object:C1471("tablename"; "Customer")
DIALOG:C40("QueryEditor"; $query)
CLOSE WINDOW:C154($win)
If (OK=1)
	$settings:=New object:C1471("parameters"; $query.query.para)
	$entsel:=ds:C1482.Customer.query($query.query.query_statement; $settings)
End if 