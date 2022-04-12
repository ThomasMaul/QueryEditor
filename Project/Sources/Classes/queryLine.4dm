Class constructor($data : Object)  // $ID
	If ($data.id#Null:C1517)
		This:C1470.id:=String:C10($data.id)
	Else 
		This:C1470.id:=Form:C1466.editor.getNextCounter()
	End if 
	This:C1470.ds_class:=""
	This:C1470.name:=String:C10($data.name)
	This:C1470.displayName:=This:C1470.name
	This:C1470.fieldtype:=1
	//This.value:=""
	//This.value2:=""
	This:C1470.listentry:=0
	This:C1470.setValue(0)
	This:C1470.popup2:=0
	This:C1470.height:=30
	
Function renderObjects($data : Object)->$objects : Object
	$counter:=Num:C11($data.counter)
	
	$objects:=New object:C1471
	$subcounter:=0
	
	This:C1470.listentry:=$counter
	
	$x:=80
	$y:=10+(($counter-1)*This:C1470.height)
	
	$object:=New object:C1471
	$object.type:="input"  //_"+String($counter)
	$object.dataSource:="Form:C1466.field_"+String:C10(This:C1470.id)
	$object.left:=$x
	$object.top:=$y
	$object.width:=230
	$object.height:=17
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_"+String:C10($subcounter)]:=$object
	
	$x+=235
	
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.focusable:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.picture:="/RESOURCES/Query/miniDrop.png"
	$object.left:=$x
	$object.top:=$y-2
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_fieldlist"]:=$object
	
	$x+=27
	$object:=New object:C1471
	$object.type:="dropdown"
	$object.fontSize:=10
	$object.dataSource:="Form:C1466.cond_combo_"+String:C10(This:C1470.id)
	$object.left:=$x
	$object.top:=$y-1
	$object.width:=160
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_condition"]:=$object
	
/* # "type" = how the line will be displayed
      0 = no box (example "[ is today ]")
      1 = one box (example " =  [ 20 ]")
      2 = two box (example "between [__] & [__]")
      3 = one box + one popup (example "[ 2 ] [Months]) 
      4 = only 1 popup
      5 = one box + button edit list
*/
	
	// 0, 1 ,2 - next 3
	
	Case of 
		: (This:C1470.combotype=0)
			$width1:=0
		: (This:C1470.combotype=1)
			$width1:=270
		: (This:C1470.combotype=2)
			$width1:=110
		: (This:C1470.combotype=3)
			$width1:=110
		: (This:C1470.combotype=4)
			$width1:=0
		: (This:C1470.combotype=5)
			$width1:=230
	End case 
	
	$x+=170
	
	If ($width1#0)
		$object:=New object:C1471
		$object.type:="input"
		$object.dataSource:="Form:C1466.value1_"+String:C10(This:C1470.id)
		$object.fontSize:=10
		$object.left:=$x
		$object.top:=$y+2
		$object.width:=$width1
		$object.height:=14
		$subcounter+=1
		$objects["ob_"+String:C10($counter)+"_value1"]:=$object
	End if 
	
	Case of 
		: (This:C1470.combotype=2)
			$object:=New object:C1471
			$object.type:="text"
			$object.fontSize:=10
			$object.text:=Get localized string:C991("operator_range")
			$object.left:=$x+$width1+5
			$object.top:=$y+2
			$object.width:=50
			$object.height:=14
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_text1"]:=$object
			
			$width2:=120
			$x+=($width1+40)
			$object:=New object:C1471
			$object.type:="input"
			$object.fontSize:=10
			$object.dataSource:="Form:C1466.value2_"+String:C10(This:C1470.id)
			$object.left:=$x
			$object.top:=$y+2
			$object.width:=$width2
			$object.height:=14
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_value2"]:=$object
			
		: (This:C1470.combotype=3)
			$object:=New object:C1471
			$object.type:="dropdown"
			$object.fontSize:=10
			$object.dataSource:="Form:C1466.combo2_"+String:C10(This:C1470.id)
			$object.left:=$x+$width1+5
			$object.top:=$y-1
			$object.width:=150
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_popup2"]:=$object
			
			$oPop:=New object:C1471
			Case of 
				: ((This:C1470.fieldtype=Is text:K8:3) | (This:C1470.fieldtype=Is alpha field:K8:1))
					$oPop.values:=Form:C1466.editor.lists.criteria_text
				: (This:C1470.fieldtype=Is date:K8:7)
					$oPop.values:=Form:C1466.editor.lists.criteria_date_a
				: (This:C1470.fieldtype=Is time:K8:8)
					$oPop.values:=Form:C1466.editor.lists.criteria_time_a
				: (This:C1470.fieldtype=Is picture:K8:10)
					If ((This:C1470.comboid=13) | (This:C1470.comboid=14))
						$oPop.values:=Form:C1466.editor.lists.criteria_pict_a
					Else 
						$oPop.values:=Form:C1466.editor.lists.criteria_pict_b
					End if 
				: (This:C1470.fieldtype=Is BLOB:K8:12)
					$oPop.values:=Form:C1466.editor.lists.criteria_blob_a
			End case 
			$oPop.index:=This:C1470.popup2
			Form:C1466.sub["combo2_"+String:C10(This:C1470.id)]:=$oPop
			
			
		: (This:C1470.combotype=4)
			$object:=New object:C1471
			$object.type:="dropdown"
			$object.fontSize:=10
			$object.dataSource:="Form:C1466.combo2_"+String:C10(This:C1470.id)
			$object.left:=$x+$width1
			$object.top:=$y-1
			$object.width:=130
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_popup2"]:=$object
			
			$oPop:=New object:C1471
			Case of 
				: (This:C1470.fieldtype=Is date:K8:7)
					$oPop.values:=Form:C1466.editor.lists.criteria_date_b
			End case 
			$oPop.index:=This:C1470.popup2
			Form:C1466.sub["combo2_"+String:C10(This:C1470.id)]:=$oPop
			
			$object:=New object:C1471
			$object.type:="text"
			$object.fontSize:=9
			$object.text:=This:C1470._calculateDatePreview()
			$object.left:=$x+145
			$object.top:=$y+3
			$object.width:=100
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_text2"]:=$object
			
		: (This:C1470.combotype=0)
			$object:=New object:C1471
			$object.type:="text"
			$object.fontSize:=9
			$object.text:=This:C1470._calculateDatePreview()
			$object.left:=$x+145
			$object.top:=$y+3
			$object.width:=100
			$object.height:=20
			$subcounter+=1
			$objects["ob_"+String:C10($counter)+"_text2"]:=$object
			
		: (This:C1470.combotype=5)
			$width1:=210
	End case 
	
	// end entry area
	
	$x:=790
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.picture:="/RESOURCES/Query/miniMinus.png"
	$object.switchWhenRollover:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.useLastFrameAsDisabled:=True:C214
	$object.left:=$x
	$object.top:=$y-2
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_-"]:=$object
	
	$x+=20
	$object:=New object:C1471
	$object.type:="pictureButton"
	$object.columnCount:=1
	$object.rowCount:=4
	$object.picture:="/RESOURCES/Query/miniPlus.png"
	$object.switchWhenRollover:=True:C214
	$object.switchBackWhenReleased:=True:C214
	$object.useLastFrameAsDisabled:=True:C214
	$object.left:=$x
	$object.top:=$y-2
	$object.width:=20
	$object.height:=20
	$subcounter+=1
	$objects["ob_"+String:C10($counter)+"_+"]:=$object
	
	
	
Function setValue($value : Variant)
	If (Value type:C1509($value)=Is text:K8:3)
		Form:C1466.sub["field_"+String:C10(This:C1470.id)]:=$value
		$field:=Form:C1466.editor.table[$value]
	Else 
		$fieldname:=Form:C1466.editor.fieldlist[0].name
		Form:C1466.sub["field_"+String:C10(This:C1470.id)]:=$fieldname
		$field:=Form:C1466.editor.table[$fieldname]
	End if 
	This:C1470.fieldtype:=$field.fieldType
	This:C1470.displayName:=$field.name
	This:C1470.name:=This:C1470.displayName
	
	Case of 
		: ((This:C1470.fieldtype=8) | (This:C1470.fieldtype=9) | (This:C1470.fieldtype=25))
			This:C1470.fieldtype:=1
		: ((This:C1470.fieldtype=24) | (This:C1470.fieldtype=0))
			This:C1470.fieldtype:=2
	End case 
	$oPop:=New object:C1471
	$oPop.values:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)].extract("text")
	$oPop.index:=0
	Form:C1466.sub["cond_combo_"+String:C10(This:C1470.id)]:=$oPop
	This:C1470.setCondition($oPop.index)
	
Function setCondition($value : Integer)
	This:C1470.combotype:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)][$value].type
	This:C1470.comboid:=Form:C1466.conditionpopup[String:C10(This:C1470.fieldtype)][$value].id
	
Function setPopup2($value : Integer)
	This:C1470.popup2:=$value
	
Function _calculateDatePreview()->$preview : Text
	var $dat_1; $dat_2; $dat_3 : Date
	
	$Lon_popup_3:=This:C1470.popup2
	If ($Lon_popup_3=0)
		$Lon_popup_3:=1
	End if 
	$Lon_criteriaID:=This:C1470.comboid
	Case of 
		: ($Lon_criteriaID=11)  // today
			$Dat_1:=Current date:C33
		: ($Lon_criteriaID=21)  // yesterday
			$Dat_1:=Current date:C33-1
		: ($Lon_criteriaID=31)  // tomorrow
			$Dat_1:=Current date:C33+1
		: (($Lon_criteriaID=12) | ($Lon_criteriaID=22) | ($Lon_criteriaID=32))
			//"is within current" or "is within last" or "is within next"  + (week/month/quarter/year)"
			$Lon_dayNumber:=Day number:C114(Current date:C33)-1  //1 to 7, 1 stands for sunday, so $daynumber = 0 = sunday
			$Lon_day:=Day of:C23(Current date:C33)  //
			$Lon_month:=Month of:C24(Current date:C33)
			$Lon_year:=Year of:C25(Current date:C33)
			Case of 
				: ($Lon_popup_3<=3)  //"Week ( "sun-sat" or "mon-sat" or "mon-fri"
					Case of   // which part of the week
						: ($Lon_popup_3=1)  // Sunday to Saturday
							$Dat_2:=Add to date:C393(Current date:C33; 0; 0; (-1)*$Lon_dayNumber)  //find sunday
							$Dat_3:=$Dat_2+6  // add 6 to find saturday
						: ($Lon_popup_3=2)  // Monday to Sunday
							$Dat_2:=Add to date:C393(Current date:C33; 0; 0; ((-1)*$Lon_dayNumber)+1)  //find monday
							$Dat_3:=$Dat_2+6  // add 6 to find sunday
						: ($Lon_popup_3=3)
							$Dat_2:=Add to date:C393(Current date:C33; 0; 0; ((-1)*$Lon_dayNumber)+1)  //find monday
							$Dat_3:=$Dat_2+4  // add 4 to find friday
					End case 
					Case of   // this, previous, next week
						: ($Lon_criteriaID=12)  // current (week)
							// do nothing
						: ($Lon_criteriaID=22)  // previous (week)
							$Dat_2:=$Dat_2-7
							$Dat_3:=$Dat_3-7
						: ($Lon_criteriaID=32)  // next (week)
							$Dat_2:=$Dat_2+7
							$Dat_3:=$Dat_3+7
					End case 
					
				: ($Lon_popup_3=4)  //"Month"
					Case of 
						: ($Lon_criteriaID=12)  // current (week)
							// do nothing
						: ($Lon_criteriaID=22)  //previous (month)
							$Lon_month:=$Lon_month-1
							If ($Lon_month=0)
								$Lon_month:=12
								$Lon_year:=$Lon_year-1
							End if 
						: ($Lon_criteriaID=32)  //next (month)
							$Lon_month:=$Lon_month+1
							If ($Lon_month=12)
								$Lon_month:=0
								$Lon_year:=$Lon_year+1
							End if 
					End case 
					$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; $Lon_month; 1)
					$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; $Lon_month+1; 1)-1
				: ($Lon_popup_3=5)  //"Quarter")
					Case of 
						: ($Lon_criteriaID=22)  //previous (quarter)
							$Lon_month:=$Lon_month-3
							If ($Lon_month<=0)
								$Lon_month:=$Lon_month+12
								$Lon_year:=$Lon_year-1
							End if 
						: ($Lon_criteriaID=32)  //next  (quarter)
							$Lon_month:=$Lon_month+3
							If ($Lon_month>12)
								$Lon_month:=$Lon_month-12
								$Lon_year:=$Lon_year+1
							End if 
					End case 
					Case of 
						: ($Lon_month<=3)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 1; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; 4; 1)-1
						: ($Lon_month<=6)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 4; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; 7; 1)-1
						: ($Lon_month<=9)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 7; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year; 10; 1)-1
						: ($Lon_month<=12)
							$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 10; 1)
							$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year+1; 1; 1)-1
					End case 
				: ($Lon_popup_3=6)  //"Year"
					Case of 
						: ($Lon_criteriaID=22)  //previous (year)
							$Lon_year:=$Lon_year-1
						: ($Lon_criteriaID=32)  //next (year)
							$Lon_year:=$Lon_year+1
					End case 
					$Dat_2:=Add to date:C393(!00-00-00!; $Lon_year; 1; 1)
					$Dat_3:=Add to date:C393(!00-00-00!; $Lon_year+1; 1; 1)-1
			End case 
		: ($Lon_criteriaID=23)  //"Is within THE last")  (N days month years)
			$Dat_3:=Current date:C33
			Case of 
				: ($Lon_popup_2=1)  //"Days"
					$Dat_2:=Add to date:C393($Dat_3; 0; 0; (-1)*$Lon_value)
				: ($Lon_popup_2=2)  //"Weeks"
					$Dat_2:=Add to date:C393($Dat_3; 0; 0; (-7)*$Lon_value)
				: ($Lon_popup_2=3)  //Monthes"
					$Dat_2:=Add to date:C393($Dat_3; 0; (-1)*$Lon_value; 0)
				: ($Lon_popup_2=4)  //"Years"
					$Dat_2:=Add to date:C393($Dat_3; (-1)*$Lon_value; 0; 0)
			End case 
		: ($Lon_criteriaID=33)  //"Is within the next" (N days month years)
			$Dat_2:=Current date:C33
			Case of 
				: ($Lon_popup_2=1)  //"Days"
					$Dat_3:=Add to date:C393($Dat_2; 0; 0; $Lon_value)
				: ($Lon_popup_2=2)  //"Weeks"
				: ($Lon_popup_2=3)  //Monthes"
					$Dat_3:=Add to date:C393($Dat_2; 0; $Lon_value; 0)
				: ($Lon_popup_2=4)  //"Years"
					$Dat_3:=Add to date:C393($Dat_2; $Lon_value; 0; 0)
			End case 
	End case 
	$preview:="("+String:C10($Dat_2)+" - "+String:C10($Dat_3)+")"
	
Function createQueryStatement($para : Object)->$statement : Text
	var $value : Variant
	
	$statement:=This:C1470.name+" "
	$comperator:=""
	$id:=This:C1470.comboid
	$type:=This:C1470.fieldtype
	Case of 
		: ($id=1)
			$comperator:="=="
		: ($id=2)
			$comperator:="#"
		: (($id=3) | ($id=7))
			$comperator:=">="
		: (($id=4) | ($id=8))
			$comperator:=">"
		: ($id=5)
			$comperator:="<="
		: ($id=6)
			$comperator:="<"
		: ($id=15)
			$comperator:="IN"
			
		: ((($id=11) | ($id=9) | ($id=10) | ($id=41)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))  // contains
			$comperator:="=="
		: ((($id=12) | ($id=42)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))
			$comperator:="#"
		: ((($id=13) | ($id=14)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))
			$comperator:="%"
	End case 
	
	$statement+=($comperator+" :value_"+String:C10(This:C1470.id))
	If ($id=14)
		$not:=Get localized string:C991("QueryNot")
		$statement:=$not+"("+$statement+")"
	End if 
	If (($id=15) | ($id=13))
		$value:=New collection:C1472
		$value:=Split string:C1554(Form:C1466.sub["value1_"+String:C10(This:C1470.id)]; ";")
	Else 
		$value:=Form:C1466.sub["value1_"+String:C10(This:C1470.id)]
	End if 
	Case of 
		: ((($id=11) | ($id=12)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))  // contains
			$value:="@"+$value+"@"
		: (($id=9)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3))
			$value:="@"+$value
		: (($id=10) | ($id=7)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3))
			$value+="@"
		: ((($id=41) | ($id=42)) && (($type=Is alpha field:K8:1) | ($type=Is text:K8:3)))  // contains
			$value:=""
	End case 
	$para["value_"+String:C10(This:C1470.id)]:=$value
	
	If (($id=7) | ($id=8))
		$statement:="("+$statement+")&("+This:C1470.name+" <"
		If ($id=7)
			$statement+="="
		End if 
		$statement+=(" :value2_"+String:C10(This:C1470.id))+")"
		$value2:=Form:C1466.sub["value2_"+String:C10(This:C1470.id)]
		If ($id=7)
			$value2+="@"
		End if 
		$para["value2_"+String:C10(This:C1470.id)]:=$value2
	End if 
	
	
	