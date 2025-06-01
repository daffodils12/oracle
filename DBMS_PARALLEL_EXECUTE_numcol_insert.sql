DROP TABLE test_tab3;

CREATE TABLE test_tab3 (
  inventory_id          NUMBER NOT NULL,
  product_id            NUMBER NOT NULL,
  description           VARCHAR2(100),
  CONSTRAINT test_tab_pk3 PRIMARY KEY (inventory_id)
);

select * from test_tab3;

--create error log table
begin
  dbms_errlog.create_error_log (dml_table_name => 'test_tab3');
end;
/

SELECT task_name,
       status
FROM   user_parallel_execute_tasks;

BEGIN
  DBMS_PARALLEL_EXECUTE.drop_task('test_task3');
END;
/
BEGIN
  DBMS_PARALLEL_EXECUTE.create_task (task_name => 'test_task3');
END;
/

SELECT DBMS_PARALLEL_EXECUTE.generate_task_name
FROM   dual;
BEGIN
  DBMS_PARALLEL_EXECUTE.create_chunks_by_number_col(task_name    => 'test_task3',
                                                    table_owner  => 'SCOTT',
                                                    table_name   => 'TEST_TAB1',
                                                    table_column => 'INVENTORY_ID',
                                                    chunk_size   => 10000);
END;
/

SELECT *
FROM   user_parallel_execute_chunks
WHERE  task_name = 'test_task3'
ORDER BY chunk_id;

select * from test_Tab1;
select * from test_Tab3;

DECLARE
  l_sql_stmt VARCHAR2(4000);
BEGIN
  l_sql_stmt := 'INSERT into  test_tab3 
                 select * from test_tab1
                 WHERE inventory_id BETWEEN :start_id AND :end_id
                 log errors into err$_test_tab3 ('||''''||'INSERT'||''''||') reject limit unlimited';

  DBMS_PARALLEL_EXECUTE.run_task(task_name      => 'test_task3',
                                 sql_stmt       => l_sql_stmt,
                                 language_flag  => DBMS_SQL.NATIVE,
                                 parallel_level => 4);
END;
/


commit;

EXEC DBMS_STATS.gather_table_stats(USER, 'TEST_TAB3', cascade => TRUE);


select * from test_tab3 order by inventory_id;

select * from err$_test_tab3 order by inventory_id;