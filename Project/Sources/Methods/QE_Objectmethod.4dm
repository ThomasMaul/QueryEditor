//%attributes = {}
$name:=FORM Event:C1606.objectName
//ALERT($name)
// $name = "ob_" + linenumber + "_" + subcounter number or + or -

If ($name="ob_@")
	$sub:=Substring:C12($Name; 4)
	$pos:=Position:C15("_"; $sub)
	$line:=Num:C11(Substring:C12($sub; 1; $pos-1))
	$item:=Substring:C12($sub; $pos+1)
	
	If (($line#0) & ($item#""))
		
		//$queryline:=
		
	Else 
		TRACE:C157
	End if 
	
Else 
	TRACE:C157
End if 