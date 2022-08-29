# QueryEditor component

Work in process - unfinished...

## Replacement of build in Query Editor

Rewritten as class, created for usage with ORDA

### Additional features compared with build in
- direct useable with ORDA
- support of ORDA relations (using names, parallel relations, etc)
- support for calculated attributes and alias
- limited support for object field (empty, not empty)
- support for scrollbar (many query lines on small screen)
- support for Remote Datastore
- overwrite Load/Save, to get object to store in record instead of file

### Missing features compared with build in
- support picture keywords (waiting ACI0103009)

- Query with formula (does this make sense? require a formula editor, allow to select syntax as this.name or this.invoice.items.name and how to pass parameters? Security?)
- enterable field names with type ahead, check for wrong field names when entered
-- does that make sense for syntax such as invoice.items.article.supplier at all? Will people type or is the popup better?
- allow to select fields with up/down cursor key (in combination with above)
- localisation in languages other than English/German (based on build in)
- support for Japanese (language and different form object order)


### Missing new features (planned, but not coded yet)

- enhanced object field support, query in attribute
- support grouping aka (field = 5 or field = 6) and (otherfield=4 or otherfield=7)


## Usage
```
$table:=ds.Customer
$tablename:=$table.getInfo().name
$queryIn:=New object("tablename"; $tablename)  // pass table name
$query:=RunQuery($queryIn)
If ($query.OK=1)  // user clicked OK, else Cancel
	$settings:=New object("parameters"; $query.para)  // contains all needed parameters
	
	// $queryIn.queryTarget contains
	// 1 = query in table, 2 = query in selection, 
	// 3 = add to selection, 4 = remove from selection
	
	Form.listbox:=$table.query($query.query_statement; $settings)
	// run the query - here to use in listbox
	// query_statement contains the ready to use text based query statement
End if 
``

### Parameter object
tablename	name of start table
or
tableclass  ds object for start table
or
tableptr    pointer to start table (not for remote datastore)
or
tableselection	current selection to define start table and 
	allow automatic usage of operation (and/or/contains)
	then $query.resultselection contains ready useable result


fieldlist = collection
structure name	localized name 

"structure";"invoicedate";"display";"invoice date"
"structure";"invoices";"display";"Invoices"  // allow relation   
"structure";"client.name";"display";"Kundenname"  // limit field list for relation 

not specified fields/relations are not displayed/hidden
when unpassed/not used, all fields of all related tables, up to 3 level



dialogType, form/dialog type from Open Form Window, default sheet form window

ds		remote ds, host ds if unused/not passed

queryTarget preset target popup
	// 1 = query in table, 2 = query in selection, 
	// 3 = add to selection, 4 = remove from selection
	// 0 = disable popup, don't allow user to choose
	
