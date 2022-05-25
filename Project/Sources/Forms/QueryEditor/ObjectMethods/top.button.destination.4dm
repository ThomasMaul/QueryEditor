C_LONGINT:C283($Lon_i)
C_TEXT:C284($Mnu_choice; $Mnu_main; $Txt_buffer; $Txt_i)

$Mnu_main:=Create menu:C408

For ($Lon_i; 1; 4)
	$Txt_i:=String:C10($Lon_i)
	$Txt_buffer:=Get localized string:C991("queryDest_"+$Txt_i)
	
	If (OK=1)
		APPEND MENU ITEM:C411($Mnu_main; $Txt_buffer)
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; $Txt_i)
	End if 
End for 

SET MENU ITEM MARK:C208($Mnu_main; Form:C1466.queryTarget; Char:C90(18))

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

If (Length:C16($Mnu_choice)>0)
	
	Form:C1466.queryTarget:=Num:C11($Mnu_choice)
	OBJECT SET TITLE:C194(*; OBJECT Get name:C1087(Object current:K67:2); Get localized string:C991("queryDest_"+$Mnu_choice))
End if 

