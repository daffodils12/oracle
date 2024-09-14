select id,json_serialize(json_Data pretty) json_Data from json_type;

delete from json_type;
insert into json_type (id, json_data) values (1, json('{"fruit":"apple","quantity":10}'));
insert into json_type (id, json_data) values (2, json('{"produce":[{"fruit":"apple","quantity":10},{"fruit":"orange","quantity":15}]}'));
commit;

select id,json_transform(json_data, set '$.quantity'=20 returning clob pretty) as data
from json_type
where id=1;

select id,json_transform(json_data,set '$.updated_time'=systimestamp returning clob pretty) as data
from json_type
where id=1;

select id,json_transform(json_data,
                    insert '$.produce[last+1]'= JSON('{"fruit":"banana","quantity":16}')
                    returning clob pretty) 
from json_type
where id=2;


select id,json_transform(json_data,
                    append '$.produce'=JSON('{"fruit":"banana","quantity":16}')
                    returning clob pretty)
from json_type
where id=2;



select id,json_data,json_transform(json_data,
                    set '$.created_time'=systimestamp,
                    set '$.updated_time'=systimestamp,
                    rename '$.fruit'='fruit_type',
                    replace '$.quantity'=25
                    returning clob pretty) json_data
from json_type                    
where id=1;

update json_type set json_Data=json_transform(json_data,
                    set '$.created_time'=systimestamp,
                    set '$.updated_time'=systimestamp,
                    rename '$.fruit'='fruit_type',
                    replace '$.quantity'=25
                    returning json)
where id=1;

select id,json_transform(json_data,
                        keep '$.fruit_type','$.quantity' returning clob pretty) 
from json_type    
where id=1;

select id,json_data,json_transform(json_data,
                            append '$.produce'=JSON('{"fruit":"banana","quantity":20}')
                            returning clob pretty)
from json_type                            
where id=2;             

select json_transform(json_data,
                      insert '$.produce[last+1]' = JSON('{"fruit":"banana","quantity":20}')
                      returning clob pretty) as data
from   json_type
where  id = 2;


