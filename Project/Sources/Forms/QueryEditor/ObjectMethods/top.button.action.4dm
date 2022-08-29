$Mnu_main:=Create menu:C408
APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("bLoad"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "bload")
APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("bSave"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "bSave")
APPEND MENU ITEM:C411($Mnu_main; "-")
APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("bReset"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "bReset")
//APPEND MENU ITEM($Mnu_main; "-")
//APPEND MENU ITEM($Mnu_main; Get localized string("bCopy"))
//SET MENU ITEM PARAMETER($Mnu_main; -1; "bCopy")
$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

Case of 
	: ($Mnu_choice="bCopy")
		$object:=Form:C1466.editor.createQueryObject()
		SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($object; *))
		
	: ($Mnu_choice="bSave")
		$object:=Form:C1466.editor.createSaveObject()
		If (Form:C1466.editor.querySave#Null:C1517)
			Form:C1466.editor.querySave($object)
		Else 
			$text:=JSON Stringify:C1217($object; *)
			$doc:=Select document:C905(System folder:C487(Documents folder:K41:18)+"Query.4QE"; "4qe"; Get localized string:C991("QE_SaveMessage"); File name entry:K24:17+Use sheet window:K24:11)
			If (OK=1)
				TEXT TO DOCUMENT:C1237(document; $text)
			End if 
		End if 
		
		
	: ($Mnu_choice="bLoad")
		If (Form:C1466.editor.queryLoad#Null:C1517)
			$object:=Form:C1466.editor.queryLoad()
			Form:C1466.editor.useSaveObject($object)
		Else 
			$doc:=Select document:C905(System folder:C487(Documents folder:K41:18)+"Query.4QE"; "4qe;4df"; Get localized string:C991("QE_SaveMessage"); Use sheet window:K24:11)
			If (OK=1)
				$text:=Document to text:C1236(document)
				If ($text="{@}")
					$object:=JSON Parse:C1218($text)
					If ($object#Null:C1517)
						If (document="@.4qe")
							Form:C1466.editor.useSaveObject($object)
						Else 
							Form:C1466.editor.useOldSaveObject($object)
						End if 
					End if 
				Else 
					ALERT:C41(Get localized string:C991("Errors_anErrorOccurredWhileOpeningTheFile"))
				End if 
			End if 
		End if 
		
	: ($Mnu_choice="breset")
		Form:C1466.editor.reset()
		Form:C1466.editor.addQueryLine()
		Form:C1466.editor.renderForm(Form:C1466.editor.sub)
End case 