//%attributes = {}
$queryIn:=New object:C1471("tablename"; "Customer")
$query:=RunQuery($queryIn)
If (OK=1)
	$settings:=New object:C1471("parameters"; $query.query.para)
	$entsel:=ds:C1482.Customer.query($query.query.query_statement; $settings)
End if 