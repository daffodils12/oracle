select json_object(key 'depts' value (
        select json_arrayagg(
         json_object(key 'deptno' value d.deptno,
                    key 'dname' value d.dname
         )
        ) from dept d 
    )) from dual;
    

select json_object(key 'emps' value (
        select json_arrayagg(
         json_object(key 'empno' value e.empno,
                    key 'ename' value e.ename,
                    key 'job' value e.job,
                    key 'sal' value e.sal,
                    key 'hiredate' value to_char(e.hiredate,'dd-mon-yyyy')
         )
        ) from emp e 
    )) from dual;    