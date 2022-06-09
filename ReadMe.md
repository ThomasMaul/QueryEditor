# QueryEditor component

Work in process - unfinished...

## Replacement of build in Query Editor

Rewritten as class, created for usage with ORDA

### Additional features compared with build in

- direkt useable with ORDA
- support of ORDA relations (using names, parallel relations, etc)
- support for calculated attributes and alias
- limited support for object field (empty, not empty)
- support for scrollbar (many query lines on small screen)


### Missing features compared with build in

- translate field list (virtual structure)
- support picture keywords
- support loading saved queries from build in editor
- Query with formula
- enterable field names with type ahead, check for wrong field names when entered
- allow to select fields with up/down cursor key
- localisation in languages other than English/German (based on build in)
- support for Japanese (language and different form object order)


### Missing new features (not in build in)
- overwrite Load/Save, to get object to store in record instead of file
- enhanced object field support, query in attribute
- support grouping (field = 5 or field = 6) and (otherfield=4 or otherfield=7)