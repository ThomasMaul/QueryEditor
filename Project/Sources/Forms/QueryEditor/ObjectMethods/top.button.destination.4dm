C_LONGINT:C283($Lon_i)
C_TEXT:C284($Mnu_choice;$Mnu_main;$Txt_buffer;$Txt_i)

$Mnu_main:=Create menu:C408

  //#ACI0091212 {
  //Repeat
  //$Lon_i:=$Lon_i+1
  //$Txt_i:=String($Lon_i)
  //$Txt_buffer:=Get localized string("queryDest_"+$Txt_i)
  //If (OK=1)
  //APPEND MENU ITEM($Mnu_main;$Txt_buffer)
  //SET MENU ITEM PARAMETER($Mnu_main;-1;$Txt_i)
  //End if
  //Until (OK=0)
  //SET MENU ITEM MARK($Mnu_main;C_QueryDestination;Char(18))
If (C_RestrictToCurrentSelection)
	
	  //DELETE MENU ITEM($Mnu_main;1)  //Create new selection
	  //DELETE MENU ITEM($Mnu_main;3)  //Add to selection
	APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("queryDest_2"))
	SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"2")
	APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("queryDest_4"))
	SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"4")
	SET MENU ITEM MARK:C208($Mnu_main;Choose:C955(C_QueryDestination;2;1);Char:C90(18))
	
Else 
	
	Repeat 
		
		$Lon_i:=$Lon_i+1
		$Txt_i:=String:C10($Lon_i)
		$Txt_buffer:=Get localized string:C991("queryDest_"+$Txt_i)
		
		If (OK=1)
			
			APPEND MENU ITEM:C411($Mnu_main;$Txt_buffer)
			SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;$Txt_i)
			
		End if 
	Until (OK=0)
	
	SET MENU ITEM MARK:C208($Mnu_main;C_QueryDestination;Char:C90(18))
	
End if 
  //}

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

If (Length:C16($Mnu_choice)>0)
	
	C_QueryDestination:=Num:C11($Mnu_choice)
	OBJECT SET TITLE:C194(*;OBJECT Get name:C1087(Object current:K67:2);Get localized string:C991("queryDest_"+$Mnu_choice))
	
End if 

