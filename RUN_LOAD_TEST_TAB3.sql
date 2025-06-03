DROP TABLE test_tab3;

CREATE TABLE test_tab3 (
  inventory_id          NUMBER NOT NULL,
  product_id            NUMBER NOT NULL,
  description           VARCHAR2(100),
  CONSTRAINT test_tab_pk3 PRIMARY KEY (inventory_id)
);

DROP TABLE err$_test_tab3;

--create error log table
begin
  dbms_errlog.create_error_log (dml_table_name => 'test_tab3');
end;
/

update test_tab1 set product_id=null
where inventory_id between 101 and 200;
commit;


BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name            => 'immediate_job',
    job_type            => 'Stored Procedure',
    job_action          => 'BEGIN RUN_TEST_TAB3('||job_min_inv_id||','||job_max_inv_id'); END;',
    start_date          => SYSTIMESTAMP,
    repeat_interval     => NULL,
    enabled             => TRUE
  );
END;
/

BEGIN
  DBMS_SCHEDULER.RUN_JOB('immediate_job');
END;
/


CREATE OR REPLACE PROCEDURE RUN_LOAD_TEST_TAB3 as

l_sql_stmt		    VARCHAR2(32767);

min_inv_id			NUMBER:=0;
max_inv_id			NUMBER:=0;
rec_cnt				NUMBER:=0;
split_4jobs			NUMBER:=0;

job_min_inv_id		NUMBER:=0;
job_max_inv_id		NUMBER:=0;		
BEGIN

	select min(inventory_id),max(inventory_id),count(*) 
		into min_inv_id,max_inv_id,rec_cnt
	from test_tab1;
	
	dbms_output.put_line('min_inv_id :'||min_inv_id);
	dbms_output.put_line('max_inv_id :'||max_inv_id);
	dbms_output.put_line('rec_cnt :'||rec_cnt);	
	
	split_4jobs:=round(rec_cnt/4);
	dbms_output.put_line('split_4jobs :'||split_4jobs);
	dbms_output.put_line('--------------------');
	
	for i in 1..4 loop
		if i=1 then
			job_min_inv_id:=min_inv_id;
			job_max_inv_id:=min_inv_id+split_4jobs;
		else
			job_min_inv_id:=job_max_inv_id+1;
			job_max_inv_id:=job_max_inv_id+split_4jobs;
		end if;
		dbms_output.put_line('job_min_inv_id :'||job_min_inv_id);
		dbms_output.put_line('job_max_inv_id :'||job_max_inv_id);

		dbms_output.put_line('job :'||i);
		RUN_TEST_TAB3(job_min_inv_id,job_max_inv_id);
	
	end loop;

END;
/

CREATE OR REPLACE PROCEDURE RUN_TEST_TAB3(job_min_inv_id in NUMBER,job_max_inv_id in NUMBER) as

l_sql_stmt	VARCHAR2(4000);
BEGIN
			l_sql_stmt := 'INSERT into  test_tab3 
					 select * from test_tab1
					 WHERE inventory_id BETWEEN '||job_min_inv_id ||' AND '||job_max_inv_id;
			EXECUTE IMMEDIATE l_sql_stmt;
			COMMIT;
	
END;
/

