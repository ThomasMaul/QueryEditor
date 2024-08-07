//%attributes = {}
#DECLARE($store : Object)
// this method can overwrite the save code, by example to store a query as record in a table.
// this is called when the user selects the save function.
// it is your job to open a window, ask for a name and store that as record (usually with additional info such
// as table, user name, date, time, etc.

// to keep this example simple, we will save a file on disk, exactly as the build in load would do.

var $text:=JSON Stringify:C1217($store; *)
var $doc:=Select document:C905(System folder:C487(Documents folder:K41:18)+"Query.4QE"; "4qe"; "save your query"; File name entry:K24:17+Use sheet window:K24:11)
If (OK=1)
	TEXT TO DOCUMENT:C1237(document; $text)
End if 

