DECLARE
  l_sql_stmt VARCHAR2(1000);
  l_try NUMBER;
  l_status NUMBER;
BEGIN
 
  -- Create the TASK
  DBMS_PARALLEL_EXECUTE.CREATE_TASK ('test_task_by_rowid');
 
  -- Chunk the table by ROWID
  DBMS_PARALLEL_EXECUTE.CREATE_CHUNKS_BY_ROWID('test_task_by_rowid', 'SCOTT', 'TEST_TAB', true, 10000);
 
  -- Execute the DML in parallel
  l_sql_stmt := 'update TEST_TAB t 
      SET t.num_col = t.num_col + 10,
          t.session_id = SYS_CONTEXT(''USERENV'',''SESSIONID'')
      WHERE rowid BETWEEN :start_id AND :end_id';
  DBMS_PARALLEL_EXECUTE.RUN_TASK('test_task_by_rowid', l_sql_stmt, DBMS_SQL.NATIVE,
                                 parallel_level => 10);
 
  -- If there is an error, RESUME it for at most 2 times.
  L_try := 0;
  L_status := DBMS_PARALLEL_EXECUTE.TASK_STATUS('test_task_by_rowid');
  WHILE(l_try < 2 and L_status != DBMS_PARALLEL_EXECUTE.FINISHED) 
  LOOP
    L_try := l_try + 1;
    DBMS_PARALLEL_EXECUTE.RESUME_TASK('test_task_by_rowid');
    L_status := DBMS_PARALLEL_EXECUTE.TASK_STATUS('test_task_by_rowid');
  END LOOP;
 
  -- Done with processing; drop the task
  DBMS_PARALLEL_EXECUTE.DROP_TASK('test_task_by_rowid');
   
END;
/