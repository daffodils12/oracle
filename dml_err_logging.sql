-- Create error logging table. Default name.
begin
  dbms_errlog.create_error_log (dml_table_name => 'dest');
end;
/

-- Create error logging table. Custom name.
begin
  dbms_errlog.create_error_log (dml_table_name     => 'dest',
                                err_log_table_name => 'dest_err_log');
end;
/

SELECT table_name, tablespace_name
FROM   user_tables;

desc err$_dest

insert into dest
select *
from   source
log errors into err$_dest ('INSERT') reject limit unlimited;

select ora_err_number$, ora_err_mesg$
from   err$_dest
where  ora_err_tag$ = 'INSERT';

update dest
set    code = decode(id, 9, null, 10, null, code)
where  id between 1 and 10
log errors into err$_dest ('UPDATE') reject limit unlimited;


select ora_err_number$, ora_err_mesg$
from   err$_dest
where  ora_err_tag$ = 'UPDATE';

delete from dest
log errors into err$_dest ('DELETE') reject limit unlimited;

select ora_err_number$, ora_err_mesg$
from   err$_dest
where  ora_err_tag$ = 'DELETE';


merge into dest a
    using source b
    on (a.id = b.id)
  when matched then
    update set a.code        = b.code,
               a.description = b.description
  when not matched then
    insert (id, code, description)
    values (b.id, b.code, b.description)
  log errors into err$_dest ('MERGE') reject limit unlimited;
  
select ora_err_number$, ora_err_mesg$
from   err$_dest
where  ora_err_tag$ = 'MERGE';