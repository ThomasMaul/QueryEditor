//%attributes = {}

$queryIn:=New object:C1471("tablename"; "Customer")
//$queryIn:=New object("tablename"; "Customer"; "queryTarget"; 0)  // to disable search in selection
$entsel:=ds:C1482.Customer.all  // to search in selection
$queryIn:=New object:C1471("tableselection"; $entsel)

$query:=RunQuery($queryIn)
If (OK=1)
	$settings:=New object:C1471("parameters"; $query.para)
	// $queryIn.queryTarget contains
	// 1 = query in table, 2 = query in selection, 
	// 3 = add to selection, 4 = remove from selection
	$entsel:=ds:C1482.Customer.query($query.query_statement; $settings)
End if 

