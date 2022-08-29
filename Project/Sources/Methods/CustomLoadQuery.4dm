//%attributes = {}
#DECLARE()->$load : Object
// this method can overwrite the load code, by example to store a query as record in a table.
// this is called when the user selects the load function.
// it is your job to open a window, display a list of stored queries (by example personal or "for all")
// and return the object - as created by overwriting the SaveQuery functionality...

// to keep this example simple, we will open a file on disk, exactly as the build in load would do.
// return your stored query as object...


$doc:=Select document:C905(System folder:C487(Documents folder:K41:18)+"Query.4QE"; "4qe"; "Select a query document"; Use sheet window:K24:11)
If (OK=1)
	$text:=Document to text:C1236(document)
	If ($text="{@}")
		$load:=JSON Parse:C1218($text)
	Else 
		ALERT:C41(Get localized string:C991("Errors_anErrorOccurredWhileOpeningTheFile"))
	End if 
End if 