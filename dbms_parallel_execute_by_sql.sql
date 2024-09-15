exec DBMS_PARALLEL_EXECUTE.drop_task (task_name => 'test_task_sql');
exec DBMS_PARALLEL_EXECUTE.create_task (task_name => 'test_task_sql');

SELECT DBMS_PARALLEL_EXECUTE.generate_task_name
FROM   dual;

DECLARE
  l_stmt CLOB;
BEGIN
  l_sql_stmt := 'SELECT DISTINCT num_col, num_col FROM test_tab';

  DBMS_PARALLEL_EXECUTE.create_chunks_by_sql(task_name => 'test_task_sql',
                                             sql_stmt  => l_sql_stmt,
                                             by_rowid  => FALSE);
END;
/


SELECT chunk_id, status, start_id, end_id
FROM   user_parallel_execute_chunks
WHERE  task_name = 'test_task_sql'
ORDER BY chunk_id;


DECLARE
  l_sql_stmt VARCHAR2(32767);
BEGIN
  l_sql_stmt := 'UPDATE test_tab t 
                 SET    t.num_col = t.num_col + 10,
                        t.session_id = SYS_CONTEXT(''USERENV'',''SESSIONID'')
                        WHERE num_col BETWEEN :start_id AND :end_id';

  DBMS_PARALLEL_EXECUTE.run_task(task_name      => 'test_task_sql',
                                 sql_stmt       => l_sql_stmt,
                                 language_flag  => DBMS_SQL.NATIVE,
                                 parallel_level => 10);
END;
/

SELECT chunk_id, status, start_id, end_id
FROM   user_parallel_execute_chunks
WHERE  task_name = 'test_task_sql'
ORDER BY chunk_id;

SELECT session_id, num_col,COUNT(*)
FROM   test_tab
GROUP BY session_id,num_col
ORDER BY session_id,num_col;

select * from test_tab;