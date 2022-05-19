If (Storage:C1525.QueryEditor.history#Null:C1517)
	$Mnu_main:=Create menu:C408
	$history:=Storage:C1525.QueryEditor.history
	$counter:=0
	For each ($entry; $history)
		APPEND MENU ITEM:C411($Mnu_main; $entry; *)
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; String:C10($counter))
		$counter+=1
	End for each 
	$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
	RELEASE MENU:C978($Mnu_main)
	If ($Mnu_choice#"")
		Form:C1466.editor.useSaveObject(Storage:C1525.QueryEditor.historySave[Num:C11($Mnu_choice)])
	End if 
End if 
