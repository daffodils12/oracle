CREATE OR REPLACE package body SCOTT.pkg_emp_local_type as
procedure prc_emp_local as 
l_tab t_tab;
begin
    select *
    bulk collect into l_tab
    from emp;

    dbms_output.put_line('Emp records');
    for cur_rec in (select * from table(l_tab)) loop
        dbms_output.put_line(cur_rec.empno||', '||cur_rec.ename);    
    end loop;

end;
end;

/
