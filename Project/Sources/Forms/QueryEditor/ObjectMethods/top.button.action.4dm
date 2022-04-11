C_BOOLEAN:C305($Boo_save)
C_LONGINT:C283($Lon_i)
C_TEXT:C284($Dir_local;$Mnu_choice;$Mnu_main;$Mnu_sub;$Txt_buffer;$Txt_file)
C_OBJECT:C1216($Obj_buffer)

  //"Save" is only implemented for tests purposes in debug mode
$Boo_save:=Macintosh option down:C545 & Not:C34(Is compiled mode:C492)

$Mnu_main:=Create menu:C408

mnu_APPEND_ITEM ($Mnu_main;":xliff:bLoad...";"load")

mnu_APPEND_ITEM ($Mnu_main;":xliff:bSave...";"save")

mnu_APPEND_LINE ($Mnu_main)

mnu_APPEND_ITEM ($Mnu_main;":xliff:Action_copy";"copy")
SET MENU ITEM SHORTCUT:C423($Mnu_main;-1;"C";Command key mask:K16:1+Shift key mask:K16:3)

mnu_APPEND_LINE ($Mnu_main)

mnu_APPEND_ITEM ($Mnu_main;":xliff:bReset";"reset")

  // #11-3-2015 - append predefined queries if any
$Dir_local:=Get 4D folder:C485(Current resources folder:K5:16;*)\
+"Queries"+Folder separator:K24:12

If (Test path name:C476($Dir_local)=Is a folder:K24:2)
	
	ARRAY TEXT:C222($tFile_local;0x0000)
	DOCUMENT LIST:C474($Dir_local;$tFile_local)
	SORT ARRAY:C229($tFile_local)
	
	$Mnu_sub:=Create menu:C408
	
	For ($Lon_i;1;Size of array:C274($tFile_local);1)
		
		If ($tFile_local{$Lon_i}="@.4df")
			
			  //If (Length($tFile_local{0})=0)
			  //$tFile_local{0}:="-"
			  //mnu_APPEND_LINE ($Mnu_main)
			  //mnu_APPEND_ITEM ($Mnu_main;Uppercase(Replace string(Get localized string(Choose($Boo_save;"bSave...";"bLoad..."));"…";"")))
			  //mnu_SET_ACTIVATION ($Mnu_main;False)
			  //End if
			
			$Txt_buffer:=Document to text:C1236($Dir_local+$tFile_local{$Lon_i})
			
			If ($Txt_buffer="{@}")
				
				$Obj_buffer:=JSON Parse:C1218($Txt_buffer)
				
				If (OB Get:C1224($Obj_buffer;"mainTable";Is longint:K8:6)=C_tableID)
					
					mnu_APPEND_ITEM ($Mnu_sub;Replace string:C233($tFile_local{$Lon_i};".4df";"");$tFile_local{$Lon_i})
					
				End if 
				
				CLEAR VARIABLE:C89($Obj_buffer)
				
			End if 
		End if 
	End for 
	
	If (Count menu items:C405($Mnu_sub)>0)
		
		mnu_APPEND_LINE ($Mnu_main)
		
		mnu_APPEND_ITEM ($Mnu_main;Replace string:C233(Get localized string:C991(Choose:C955($Boo_save;"bSave...";"bLoad..."));"…";"");"";$Mnu_sub)
		RELEASE MENU:C978($Mnu_sub)
		
	End if 
End if 

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

Case of 
		
		  //………………………………………………………………………………………
	: (Length:C16($Mnu_choice)=0)
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="load")
		
		$Txt_file:=Select document:C905(<>query_saveRootPath;\
			".4df";\
			Get localized string:C991("Actions_selectTheQueryFileToLoad");\
			Use sheet window:K24:11)
		
		If (OK=1)
			
			  //ON ERR CALL("noERROR")
			  //$Dom_query:=DOM Parse XML source(DOCUMENT)
			  //ON ERR CALL("")
			  //If (OK=1)
			  //DOM CLOSE XML($Dom_query)
			  //query_LOAD_FROM_XML (DOCUMENT)
			  //Else
			  //query_LOAD_FROM_JSON (DOCUMENT)
			  //End if
			
			query_LOAD_FROM_JSON (DOCUMENT)
			
		End if 
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="save")
		
		$Txt_file:=Select document:C905(<>query_saveRootPath+"query.4df";\
			".4df";\
			"";\
			Use sheet window:K24:11+File name entry:K24:17)
		
		If (OK=1)
			
			$Txt_file:=Choose:C955($Txt_file#"@.4df";$Txt_file+".4df";$Txt_file)
			
			  //Keep the last folder location used
			<>query_saveRootPath:=doc_getFromPath ("parent";DOCUMENT)
			
			  //query_SAVE_AS_XML (<>query_saveRootPath+$Txt_file)
			query_SAVE_AS_JSON (<>query_saveRootPath+$Txt_file)
			
		End if 
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="reset")
		
		query_RESET 
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="copy")
		
		SET TEXT TO PASTEBOARD:C523(query_Build_formula )
		
		  //………………………………………………………………………………………
	Else 
		
		If (Test path name:C476($Dir_local+$Mnu_choice)=Is a document:K24:1)
			
			  //it's a database predefined query
			
			If ($Boo_save)
				
				  //save
				query_SAVE_AS_JSON ($Dir_local+$Mnu_choice)
				
			Else 
				
				  //load
				query_LOAD_FROM_JSON ($Dir_local+$Mnu_choice)
				
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
			
		End if 
		
		  //………………………………………………………………………………………
End case 