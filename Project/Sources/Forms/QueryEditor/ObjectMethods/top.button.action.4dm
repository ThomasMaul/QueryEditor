$Mnu_main:=Create menu:C408
APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("bLoad"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "bload")
APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("bSave"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "bSave")
//APPEND MENU ITEM($Mnu_main; "-")
//APPEND MENU ITEM($Mnu_main; Get localized string("bCopy"))
//SET MENU ITEM PARAMETER($Mnu_main; -1; "bCopy")
$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

Case of 
	: ($Mnu_choice="bCopy")
		$object:=Form:C1466.editor.createQueryObject()
		SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($object; *))
End case 

//mnu_APPEND_ITEM($Mnu_main; ":xliff:bLoad..."; "load")

//mnu_APPEND_ITEM($Mnu_main; ":xliff:bSave..."; "save")

//mnu_APPEND_LINE($Mnu_main)

//mnu_APPEND_ITEM($Mnu_main; ":xliff:Action_copy"; "copy")
//SET MENU ITEM SHORTCUT($Mnu_main; -1; "C"; Command key mask+Shift key mask)

//mnu_APPEND_LINE($Mnu_main)

//mnu_APPEND_ITEM($Mnu_main; ":xliff:bReset"; "reset")

//// #11-3-2015 - append predefined queries if any
//$Dir_local:=Get 4D folder(Current resources folder; *)\
+"Queries"+Folder separator

//If (Test path name($Dir_local)=Is a folder)

//ARRAY TEXT($tFile_local; 0x0000)
//DOCUMENT LIST($Dir_local; $tFile_local)
//SORT ARRAY($tFile_local)

//$Mnu_sub:=Create menu

//For ($Lon_i; 1; Size of array($tFile_local); 1)

//If ($tFile_local{$Lon_i}="@.4df")

////If (Length($tFile_local{0})=0)
////$tFile_local{0}:="-"
////mnu_APPEND_LINE ($Mnu_main)
////mnu_APPEND_ITEM ($Mnu_main;Uppercase(Replace string(Get localized string(Choose($Boo_save;"bSave...";"bLoad..."));"…";"")))
////mnu_SET_ACTIVATION ($Mnu_main;False)
////End if

//$Txt_buffer:=Document to text($Dir_local+$tFile_local{$Lon_i})

//If ($Txt_buffer="{@}")

//$Obj_buffer:=JSON Parse($Txt_buffer)

//If (OB Get($Obj_buffer; "mainTable"; Is longint)=C_tableID)

//mnu_APPEND_ITEM($Mnu_sub; Replace string($tFile_local{$Lon_i}; ".4df"; ""); $tFile_local{$Lon_i})

//End if 

//CLEAR VARIABLE($Obj_buffer)

//End if 
//End if 
//End for 

//If (Count menu items($Mnu_sub)>0)

//mnu_APPEND_LINE($Mnu_main)

//mnu_APPEND_ITEM($Mnu_main; Replace string(Get localized string(Choose($Boo_save; "bSave..."; "bLoad...")); "…"; ""); ""; $Mnu_sub)
//RELEASE MENU($Mnu_sub)

//End if 
//End if 

//$Mnu_choice:=Dynamic pop up menu($Mnu_main)
//RELEASE MENU($Mnu_main)

//Case of 

////………………………………………………………………………………………
//: (Length($Mnu_choice)=0)

////………………………………………………………………………………………
//: ($Mnu_choice="load")

//$Txt_file:=Select document(<>query_saveRootPath; \
".4df"; \
Get localized string("Actions_selectTheQueryFileToLoad"); \
Use sheet window)

//If (OK=1)

////ON ERR CALL("noERROR")
////$Dom_query:=DOM Parse XML source(DOCUMENT)
////ON ERR CALL("")
////If (OK=1)
////DOM CLOSE XML($Dom_query)
////query_LOAD_FROM_XML (DOCUMENT)
////Else
////query_LOAD_FROM_JSON (DOCUMENT)
////End if

//query_LOAD_FROM_JSON(DOCUMENT)

//End if 

////………………………………………………………………………………………
//: ($Mnu_choice="save")

//$Txt_file:=Select document(<>query_saveRootPath+"query.4df"; \
".4df"; \
""; \
Use sheet window+File name entry)

//If (OK=1)

//$Txt_file:=Choose($Txt_file#"@.4df"; $Txt_file+".4df"; $Txt_file)

////Keep the last folder location used
//<>query_saveRootPath:=doc_getFromPath("parent"; DOCUMENT)

////query_SAVE_AS_XML (<>query_saveRootPath+$Txt_file)
//query_SAVE_AS_JSON(<>query_saveRootPath+$Txt_file)

//End if 

////………………………………………………………………………………………
//: ($Mnu_choice="reset")

//query_RESET

////………………………………………………………………………………………
//: ($Mnu_choice="copy")

//SET TEXT TO PASTEBOARD(query_Build_formula)

////………………………………………………………………………………………
//Else 

//If (Test path name($Dir_local+$Mnu_choice)=Is a document)

////it's a database predefined query

//If ($Boo_save)

////save
//query_SAVE_AS_JSON($Dir_local+$Mnu_choice)

//Else 

////load
//query_LOAD_FROM_JSON($Dir_local+$Mnu_choice)

//End if 

//Else 

//ASSERT(False; "Unknown menu action ("+$Mnu_choice+")")

//End if 

////………………………………………………………………………………………
//End case 