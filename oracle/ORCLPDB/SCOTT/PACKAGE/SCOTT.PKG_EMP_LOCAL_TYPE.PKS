CREATE OR REPLACE package SCOTT.pkg_emp_local_type as

TYPE t_tab is TABLE OF EMP%ROWTYPE;
procedure prc_emp_local;
end;

/
