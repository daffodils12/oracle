CREATE OR REPLACE package SCOTT.pkg_emp_local as
TYPE t_Tab is TABLE OF emp%rowtype;

procedure prc_emp_local;
end;

/
