TYPE CurTblTyp  IS REF CURSOR;
cur_tbl    CurTblTyp; 
TYPE l_tbl_t IS TABLE OF tablename.%ROWTYPE;
l_tbl_data l_tbl_t ;

OPEN cur_tbl FOR  'SELECT * FROM  :s ' USING b.table_name;
FETCH cur_tbl BULK COLLECT INTO l_tbl_data LIMIT 5000;
EXIT WHEN cur_tbl%NOTFOUND;     
CLOSE cur_tbl;         

FORALL i IN 1 .. l_tbl_data .count
EXECUTE IMMEDIATE 'insert into '||l_tbl_nm||' values (:1)' USING 
l_tbl_data(i);

  -- Perform a bulk operation.
  BEGIN
    FORALL i IN l_tab.first .. l_tab.last SAVE EXCEPTIONS
      INSERT INTO exception_test
      VALUES l_tab(i);
  EXCEPTION
    WHEN ex_dml_errors THEN
      l_error_count := SQL%BULK_EXCEPTIONS.count;
      DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
      FOR i IN 1 .. l_error_count LOOP
        DBMS_OUTPUT.put_line('Error: ' || i || 
          ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
          ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;
  END;