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

DECLARE
v_job_cnt		    NUMBER:=0;
v_chunks_count      NUMBER:=0;
v_success_count     NUMBER:=0;
v_gen_task		    VARCHAR2(100);
v_load_cnt		    NUMBER:=0;
v_err_cnt		    NUMBER:=0;
v_task_name		    VARCHAR2(30):='test_task3';
l_sql_stmt		    VARCHAR2(4000);
BEGIN
	select count(*) into v_job_cnt
	from user_parallel_execute_chunks
	where  task_name = v_task_name;
	
	if v_job_cnt>0 then
		DBMS_PARALLEL_EXECUTE.drop_task(v_task_name);
		DELETE FROM test_tab3;
		DELETE FROM err$_test_tab3;
		commit;
	end if;
	
	DBMS_PARALLEL_EXECUTE.create_task (task_name => v_task_name);
	dbms_output.put_line('Task Name :'||v_task_name);
	
	SELECT DBMS_PARALLEL_EXECUTE.generate_task_name INTO v_gen_task FROM DUAL;
	dbms_output.put_line('Task Name generated :'||v_gen_task);
	
	DBMS_PARALLEL_EXECUTE.create_chunks_by_number_col(task_name    => v_task_name,
                                                    table_owner  => USER,
                                                    table_name   => 'TEST_TAB1',
                                                    table_column => 'INVENTORY_ID',
                                                    chunk_size   => 10000);	
													
	SELECT count(*) into v_chunks_count
	FROM   user_parallel_execute_chunks
	WHERE  task_name = v_task_name
	AND status='UNASSIGNED';
	
	dbms_output.put_line('Task start time '||to_char(sysdate, 'MM/DD/YYYY hh:mi:ss am'));
	if v_chunks_count>0 then
	
	  l_sql_stmt := 'INSERT into  test_tab3 
					 select * from test_tab1
					 WHERE inventory_id BETWEEN :start_id AND :end_id
					 log errors into err$_test_tab3 ('||''''||'INSERT'||''''||') reject limit unlimited';

	  DBMS_PARALLEL_EXECUTE.run_task(task_name      => 'test_task3',
									 sql_stmt       => l_sql_stmt,
									 language_flag  => DBMS_SQL.NATIVE,
									 parallel_level => 4);
	end if;
	dbms_output.put_line('Task end time   '||to_char(sysdate, 'MM/DD/YYYY hh:mi:ss am'));
	commit;
	
	SELECT count(*) into v_success_count
	FROM   user_parallel_execute_chunks
	WHERE  task_name = v_task_name
	AND status='PROCESSED';	
	
	if v_success_count=v_chunks_count then
		dbms_output.put_line('Task completed successfully.');
	end if;
	
	SELECT count(*) into v_success_count
	FROM   user_parallel_execute_chunks
	WHERE  task_name = v_task_name
	AND status='PROCESSED';	
	
	select count(*) into v_load_cnt from test_tab3;
	dbms_output.put_line('Task load counts :'||v_load_cnt);	
	select count(*) into v_err_cnt from err$_test_tab3;
	dbms_output.put_line('Task errors counts :'||v_err_cnt);
		
END;
/


