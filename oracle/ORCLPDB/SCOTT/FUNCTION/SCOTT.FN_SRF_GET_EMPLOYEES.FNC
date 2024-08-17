CREATE OR REPLACE function SCOTT.fn_srf_get_employees(p_job in varchar2) return sys_refcursor as

v_srf sys_refcursor;
begin
    open v_srf for 
    select ename,job,sal
    from emp
    where job=p_job;

    return v_srf;
end;

/
