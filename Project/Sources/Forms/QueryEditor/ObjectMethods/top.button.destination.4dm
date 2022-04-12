//C_LONGINT($Lon_i)
//C_TEXT($Mnu_choice; $Mnu_main; $Txt_buffer; $Txt_i)

//$Mnu_main:=Create menu

////#ACI0091212 {
////Repeat
////$Lon_i:=$Lon_i+1
////$Txt_i:=String($Lon_i)
////$Txt_buffer:=Get localized string("queryDest_"+$Txt_i)
////If (OK=1)
////APPEND MENU ITEM($Mnu_main;$Txt_buffer)
////SET MENU ITEM PARAMETER($Mnu_main;-1;$Txt_i)
////End if
////Until (OK=0)
////SET MENU ITEM MARK($Mnu_main;C_QueryDestination;Char(18))
//If (C_RestrictToCurrentSelection)

////DELETE MENU ITEM($Mnu_main;1)  //Create new selection
////DELETE MENU ITEM($Mnu_main;3)  //Add to selection
//APPEND MENU ITEM($Mnu_main; Get localized string("queryDest_2"))
//SET MENU ITEM PARAMETER($Mnu_main; -1; "2")
//APPEND MENU ITEM($Mnu_main; Get localized string("queryDest_4"))
//SET MENU ITEM PARAMETER($Mnu_main; -1; "4")
//SET MENU ITEM MARK($Mnu_main; Choose(C_QueryDestination; 2; 1); Char(18))

//Else 

//Repeat 

//$Lon_i:=$Lon_i+1
//$Txt_i:=String($Lon_i)
//$Txt_buffer:=Get localized string("queryDest_"+$Txt_i)

//If (OK=1)

//APPEND MENU ITEM($Mnu_main; $Txt_buffer)
//SET MENU ITEM PARAMETER($Mnu_main; -1; $Txt_i)

//End if 
//Until (OK=0)

//SET MENU ITEM MARK($Mnu_main; C_QueryDestination; Char(18))

//End if 
////}

//$Mnu_choice:=Dynamic pop up menu($Mnu_main)
//RELEASE MENU($Mnu_main)

//If (Length($Mnu_choice)>0)

//C_QueryDestination:=Num($Mnu_choice)
//OBJECT SET TITLE(*; OBJECT Get name(Object current); Get localized string("queryDest_"+$Mnu_choice))

//End if 

