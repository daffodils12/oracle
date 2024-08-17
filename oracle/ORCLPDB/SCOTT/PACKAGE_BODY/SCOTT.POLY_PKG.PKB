CREATE OR REPLACE PACKAGE BODY SCOTT.poly_pkg AS

  FUNCTION describe (tab IN OUT DBMS_TF.table_t)
    RETURN DBMS_TF.describe_t
  AS
  BEGIN
    -- Make sure the for_read flag for each real column
    -- is set, or get_row_set has no values.
    FOR i IN 1 .. tab.column.count LOOP 
      CONTINUE WHEN NOT DBMS_TF.supported_type(tab.column(i).description.TYPE);
      tab.column(i).for_read := TRUE;
    END LOOP;

    -- Add the new JSON_DOC column.
    RETURN DBMS_TF.describe_t(
             new_columns => DBMS_TF.columns_new_t(1 => DBMS_TF.column_metadata_t(name =>'JSON_DOC'))
           );   
  END;

  PROCEDURE fetch_rows AS 
    l_row_set    DBMS_TF.row_set_t;
    l_new_col    DBMS_TF.tab_varchar2_t;
    l_row_count  PLS_INTEGER;
  BEGIN
    DBMS_TF.get_row_set(l_row_set, row_count => l_row_count);
    --DBMS_TF.trace(l_row_set);

    -- Populate the new column with a JSON doc of the associated row.
    FOR row_num IN 1 .. l_row_count LOOP
      l_new_col(row_num) := DBMS_TF.row_to_char(l_row_set, row_num); 
    END LOOP;

    -- Associate the new values with the new column.
    DBMS_TF.put_col(1, l_new_col);
  END; 

END poly_pkg;

/
