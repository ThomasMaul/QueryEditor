//%attributes = {}

$queryIn:=New object:C1471("tablename"; "Test")
//$queryIn:=New object("tablename"; "Customer"; "queryTarget"; 0)  // to disable search in selection
//$entsel:=ds.Customer.all  // to search in selection
//$queryIn:=New object("tableselection"; $entsel)
$fieldcol:=New collection:C1472
If (True:C214)
	$fieldcol.push(New object:C1471("structure"; "Feld_2"; "display"; "test name"))
	$fieldcol.push(New object:C1471("structure"; "customers"; "display"; "Customers"))
	$fieldcol.push(New object:C1471("structure"; "customers.feldalpha"; "display"; "First name"))
	$fieldcol.push(New object:C1471("structure"; "customers.feldlong"; "display"; "Age"))
	$fieldcol.push(New object:C1471("structure"; "customers.feldtext"; "display"; "Comment"))
	$fieldcol.push(New object:C1471("structure"; "customers.invoices"; "display"; "Invoices"))
	$fieldcol.push(New object:C1471("structure"; "customers.invoices.Feld_3"; "display"; "Nr"))
Else 
	$fieldcol.push(New object:C1471("structure"; "feldalpha"; "display"; "First name"))
	$fieldcol.push(New object:C1471("structure"; "feldlong"; "display"; "Age"))
	$fieldcol.push(New object:C1471("structure"; "feldtext"; "display"; "Comment"))
	$fieldcol.push(New object:C1471("structure"; "invoices"; "display"; "Invoices"))
	$fieldcol.push(New object:C1471("structure"; "invoices.Feld_3"; "display"; "Nr"))
End if 

//$queryIn.fieldlist:=$fieldcol
$queryIn.dialogType:=0

$query:=RunQuery($queryIn)
If (OK=1)
	$settings:=New object:C1471("parameters"; $query.para)
	// $queryIn.queryTarget contains
	// 1 = query in table, 2 = query in selection, 
	// 3 = add to selection, 4 = remove from selection
	$entsel:=ds:C1482.Customer.query($query.query_statement; $settings)
End if 

