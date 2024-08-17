CREATE OR REPLACE TYPE SCOTT.emp_row_type AS OBJECT
(
  empno         NUMBER(4),
  ename         VARCHAR2(10),
  sal           NUMBER(7,2),
  complex       NUMBER(7,2)
);

/
