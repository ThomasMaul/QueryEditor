Class constructor
	This:C1470.querylines:=New collection:C1472
	
Function addQueryLine($pos : Integer; $lineobject : cs:C1710._queryLine)
	If ($lineobject#Null:C1517)
		This:C1470.querylines.insert($pos; $lineobject)
	Else 
		This:C1470.querylines.insert($pos; cs:C1710.queryLine.new())
	End if 
	
Function deleteQueryLine($pos : Integer)
	This:C1470.querylines.remove($pos)
	
Function renderForm($subformname : Text)
	$form:=New object:C1471
	$objects:=New object:C1471()
	$counter:=0
	For each ($line; This:C1470.querylines)
		$counter+=1
		$lineobjects:=$line.renderObjects(New object:C1471("counter"; $counter))
		For each ($object; $lineobjects)
			$objects[$object]:=$lineobjects[$object]
		End for each 
		$objects[$line.id]:=$object
	End for each 
	$page1:=New object:C1471("objects"; $objects)
	$form.pages:=New collection:C1472(Null:C1517; $page1)
	OBJECT SET SUBFORM:C1138(*; $subformname; $form)
	
	
Function getQueryLine($pos : Integer)->$object : cs:C1710._queryLine
	If (($pos>=0) & ($pos<This:C1470.querylines.length))
		$object:=This:C1470.querylines[$pos]
	Else 
		$object:=Null:C1517
	End if 
	
Function getDSClassDetails($class : 4D:C1709.DataClass)->$fields : Collection
	$fieldnames:=OB Keys:C1719($class)
	$fields:=New collection:C1472
	For each ($field; $fieldnames)
		$f:=$class[$field]
		$fields.push(New object:C1471("name"; $field; \
			"kind"; $f.kind; \
			"type"; $f.fieldType))
	End for each 
	
	
	