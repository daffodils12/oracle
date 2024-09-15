exec DBMS_PARALLEL_EXECUTE.drop_task (task_name => 'test_task_num_col');
exec DBMS_PARALLEL_EXECUTE.create_task (task_name => 'test_task_num_col');

SELECT DBMS_PARALLEL_EXECUTE.generate_task_name
FROM   dual;

DECLARE
v_task_name varchar2(20);
l_sql_stmt VARCHAR2(32767);
BEGIN
    DBMS_PARALLEL_EXECUTE.create_task (task_name => 'test_task_num_col');
    
    SELECT DBMS_PARALLEL_EXECUTE.generate_task_name into v_task_name FROM   dual;
    
     DBMS_PARALLEL_EXECUTE.create_chunks_by_number_col(task_name    => 'test_task_num_col',
                                                    table_owner  => 'SCOTT',
                                                    table_name   => 'TEST_TAB',
                                                    table_column => 'ID',
                                                    chunk_size   => 10000);


  l_sql_stmt := 'UPDATE test_tab t 
                 SET    t.num_col = t.num_col + 10,
                        t.session_id = SYS_CONTEXT(''USERENV'',''SESSIONID'')
                 WHERE num_col BETWEEN :start_id AND :end_id';

  DBMS_PARALLEL_EXECUTE.run_task(task_name      => 'test_task_num_col',
                                 sql_stmt       => l_sql_stmt,
                                 language_flag  => DBMS_SQL.NATIVE,
                                 parallel_level => 10);
                                 
    DBMS_PARALLEL_EXECUTE.drop_task (task_name => 'test_task_num_col');                                 
END;
/

SELECT chunk_id, status, start_id, end_id
FROM   user_parallel_execute_chunks
WHERE  task_name = 'test_task_num_col'
ORDER BY chunk_id;

select * from test_tab

select num_col,count(*)
from test_tab
group by num_col;