//C_BOOLEAN($Boo_expanded)
//C_LONGINT($Lon_i; $Lon_ref; $Lst_back)
//C_TEXT($Mnu_choice; $Mnu_main; $Txt_label)

//$Mnu_main:=Create menu

//For ($Lon_i; 1; Count list items(<>query_Lst_recentQueries); 1)

//GET LIST ITEM(<>query_Lst_recentQueries; $Lon_i; $Lon_ref; $Txt_label; $Lst_back; $Boo_expanded)

//If (Is a list($Lst_back))  //ACI0099378

//APPEND MENU ITEM($Mnu_main; $Txt_label; *)
//SET MENU ITEM PARAMETER($Mnu_main; -1; String($Lon_i))

//End if 
//End for 

//$Mnu_choice:=Dynamic pop up menu($Mnu_main)
//RELEASE MENU($Mnu_main)

//If (Length($Mnu_choice)>0)

//GET LIST ITEM(<>query_Lst_recentQueries; Num($Mnu_choice); $Lon_ref; $Txt_label; $Lst_back; $Boo_expanded)

//GET LIST ITEM PARAMETER(<>query_Lst_recentQueries; $Lst_back; "destination"; C_QueryDestination)
//C_QueryDestination:=C_QueryDestination+Num(C_QueryDestination<=0)

//OBJECT SET TITLE(*; "top.button.destination"; Get localized string("queryDest_"+String(C_QueryDestination)))

//GET LIST ITEM PARAMETER(<>query_Lst_recentQueries; $Lst_back; "mainTable"; C_tableID)

//query_RESTORE($Lst_back)

//End if 