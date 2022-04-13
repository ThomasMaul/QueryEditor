//%attributes = {}
ds:C1482.Tabelle_1.all().drop()

$ent:=ds:C1482.Tabelle_1.new()
C_PICTURE:C286($pict)
$ent.feldpict:=$pict
$ent.save()

$ent:=ds:C1482.Tabelle_1.new()
$ent.save()

$ent:=ds:C1482.Tabelle_1.new()
C_PICTURE:C286($pict)
READ PICTURE FILE:C678(""; $pict)
$ent.feldpict:=$pict
$ent.save()

$sel:=ds:C1482.Tabelle_1.query("feldpict == null")
