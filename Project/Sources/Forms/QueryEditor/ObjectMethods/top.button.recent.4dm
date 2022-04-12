C_BOOLEAN:C305($Boo_expanded)
C_LONGINT:C283($Lon_i;$Lon_ref;$Lst_back)
C_TEXT:C284($Mnu_choice;$Mnu_main;$Txt_label)

$Mnu_main:=Create menu:C408

For ($Lon_i;1;Count list items:C380(<>query_Lst_recentQueries);1)
	
	GET LIST ITEM:C378(<>query_Lst_recentQueries;$Lon_i;$Lon_ref;$Txt_label;$Lst_back;$Boo_expanded)
	
	If (Is a list:C621($Lst_back))  //ACI0099378
		
		APPEND MENU ITEM:C411($Mnu_main;$Txt_label;*)
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;String:C10($Lon_i))
		
	End if 
End for 

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

If (Length:C16($Mnu_choice)>0)
	
	GET LIST ITEM:C378(<>query_Lst_recentQueries;Num:C11($Mnu_choice);$Lon_ref;$Txt_label;$Lst_back;$Boo_expanded)
	
	GET LIST ITEM PARAMETER:C985(<>query_Lst_recentQueries;$Lst_back;"destination";C_QueryDestination)
	C_QueryDestination:=C_QueryDestination+Num:C11(C_QueryDestination<=0)
	
	OBJECT SET TITLE:C194(*;"top.button.destination";Get localized string:C991("queryDest_"+String:C10(C_QueryDestination)))
	
	GET LIST ITEM PARAMETER:C985(<>query_Lst_recentQueries;$Lst_back;"mainTable";C_tableID)
	
	query_RESTORE ($Lst_back)
	
End if 