DECLARE
 h NUMBER;
 x xmltype;
 n pls_integer;
 v varchar2(32000);
 thall pls_integer;
 ddls sys.ku$_ddls;
 ddl sys.ku$_ddl;
 parsed_items sys.ku$_parsed_items;
 parsed_item sys.ku$_parsed_item;
 
BEGIN
  h := dbms_metadata.open('SCHEMA_EXPORT');
  DBMS_METADATA.SET_FILTER(h,'SCHEMA','DEF'); -- export only selected schema

  -- set items to parse. Available as elements of table returned by FETCH_DDL
  -- List of all available ITEMS in 'select * from DBMS_METADATA_PARSE_ITEMS'
  dbms_metadata.set_parse_item(h,'VERB');
  dbms_metadata.set_parse_item(h,'OBJECT_TYPE');  
  dbms_metadata.set_parse_item(h,'BASE_OBJECT_SCHEMA');  
  dbms_metadata.set_parse_item(h,'LONGNAME');  
  dbms_metadata.set_parse_item(h,'SCHEMA');  
  dbms_metadata.set_parse_item(h,'TABLESPACE');  
  dbms_metadata.set_parse_item(h,'BASE_OBJECT_TYPE');
  dbms_metadata.set_parse_item(h,'XPATH');


  thall := dbms_metadata.add_transform(h,'DDL'); -- transform to DDL so we can use FETCH_DDL. Applies to all objects (notice lack of object_type)
  -- some basic transformations
  dbms_metadata.set_transform_param(thall,'EMIT_SCHEMA', false);   
  dbms_metadata.set_transform_param(thall,'SQLTERMINATOR', true);
  dbms_metadata.set_transform_param(thall,'PRETTY', true);  

  loop
     ddls := dbms_metadata.fetch_ddl(h);
     exit when ddls is null;

     dbms_output.put_line('----======================');
     for i in 1 .. nvl(ddls.count,0) loop
       ddl := ddls(i);
       dbms_output.put_line(ddl.ddlText);
       parsed_items := ddl.parsedItems;
       for a in 1 .. nvl(parsed_items.count,0) loop
         dbms_output.put_line('PI:'||parsed_items(a).item||':'||parsed_items(a).value);
       end loop;
     end loop;
  end loop;
  dbms_metadata.close(h);
END;
/
