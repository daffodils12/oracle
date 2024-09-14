select * from xml_tab1;

with dept_Data as
(select xt.*
from xml_tab1 x,
xmltable('/depts/dept'
    passing x.xml_data
    COLUMNS
        deptno number path 'deptno',
        dname varchar2(20) path 'dname',
        emps xmltype path 'EMPS'    
) xt
), emp_data as
(select d.deptno,d.dname,xt2.*
from dept_Data d
left outer join
xmltable('/EMPS/emp'
    passing d.emps
    COLUMNS
        empno number path 'empno',
        ename varchar2(20) path 'ename',
        job varchar2(20) path 'job',
        sal varchar2(20) path 'sal',
        hiredate varchar2(20) path 'hiredate'    
) xt2 on (1=1)) 
select * from emp_data;