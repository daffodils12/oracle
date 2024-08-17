CREATE OR REPLACE PACKAGE SCOTT.poly_pkg AS

  FUNCTION my_ptf(tab IN TABLE)
  RETURN TABLE PIPELINED
    ROW POLYMORPHIC USING poly_pkg;

  FUNCTION describe (tab IN OUT DBMS_TF.table_t)
    RETURN DBMS_TF.describe_t;

  PROCEDURE fetch_rows;
END poly_pkg;

/
