select * from json_type;

update json_type
set json_data= json_transform(json_data,replace '$.quantity' = 20);

update json_type
set json_data= json_transform(json_data,insert '$.updated_date' = systimestamp);
update json_type
set json_data= json_transform(json_data,replace '$.updated_date' = systimestamp);
update json_type
set json_data= json_transform(json_data,rename '$.fruit' = 'fruit_type')
where id=1;
update json_type
set json_data= json_transform(json_data,remove '$.updated_date');

update json_type
set json_data= json_transform(json_data,replace '$.updated_date' = systimestamp);

update json_type
set json_data=json_transform(json_Data,insert '$.produce[1]' = JSON('{"fruit":"banana","quantity":20}'))
where id=2;

update json_type
set json_data=json_transform(json_Data,append '$.produce' = JSON('{"fruit":"guava","quantity":25}'))
where id=2;