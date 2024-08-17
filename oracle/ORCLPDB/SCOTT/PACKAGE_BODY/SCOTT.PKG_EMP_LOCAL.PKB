CREATE OR REPLACE package body SCOTT.pkg_emp_local as

procedure prc_emp_local as
v_tab t_Tab;
begin
    select *
    bulk collect into v_tab
    from emp;

    for cur_rec in (select * from table(v_tab)) loop
        dbms_output.put_line(cur_rec.empno||', '||cur_rec.ename);
    end loop;

end;
end;

/
