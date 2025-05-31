BEGIN
  DBMS_PARALLEL_EXECUTE.create_task (task_name => 'test_task1');
END;
/
SELECT DBMS_PARALLEL_EXECUTE.generate_task_name
FROM   dual;
BEGIN
  DBMS_PARALLEL_EXECUTE.create_chunks_by_number_col(task_name    => 'test_task1',
                                                    table_owner  => 'SCOTT',
                                                    table_name   => 'TEST_TAB1',
                                                    table_column => 'INVENTORY_ID',
                                                    chunk_size   => 10000);
END;
/

SELECT *
FROM   user_parallel_execute_chunks
WHERE  task_name = 'test_task1'
ORDER BY chunk_id;


select * from test_Tab1


DECLARE
  l_sql_stmt VARCHAR2(32767);
BEGIN
  l_sql_stmt := 'UPDATE test_tab1 t 
                 SET    t.description = substr(t.description,1,17) || (t.inventory_id+10)
                 WHERE inventory_id BETWEEN :start_id AND :end_id';

  DBMS_PARALLEL_EXECUTE.run_task(task_name      => 'test_task1',
                                 sql_stmt       => l_sql_stmt,
                                 language_flag  => DBMS_SQL.NATIVE,
                                 parallel_level => 4);
END;
/

BEGIN
  DBMS_PARALLEL_EXECUTE.drop_task('test_task1');
END;
/