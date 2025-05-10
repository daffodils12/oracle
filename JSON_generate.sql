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

--Generate simple json document for all records
select json_object(*) from emp;

--Generate simple json document for all records pretty
select json_serialize(json_object(* returning clob) pretty) from emp;

--Generate json document for group of records
select deptno,json_arrayagg(json_object(*)) from emp
group by deptno;

--generate nested JSON Doc example
select json_serialize(
    json_array(json_object(key 'DEPT' value
                    json_array(json_object(key 'DEPTNAME' value d.dname,
                                            key 'EMPS' value e.emp_json)))) 
            pretty) dept_emp_json
from 
dept d,
(select deptno,json_arrayagg(json_object(*)) emp_json from emp
group by deptno) e
where d.deptno=e.deptno
