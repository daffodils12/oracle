--generate simple xml for specific records
select xmltype(cursor(select * from emp where deptno=10)) dept_10_xml from dual;

--generate xml for dept records
select xmltype(cursor(select d.deptno as deptno,d.dname as dept_name
                      from dept d)) from dual; 
            
--generate nested xml for dept and emp records
select xmltype(cursor(select d.deptno as deptno,d.dname as dept_name,
                      cursor(select e.deptno as deptno1,e.ename as ename,e.job as job,e.sal as sal
                              from emp e where e.deptno=d.deptno) as emp
                      from dept d)) dept_emp_xml from dual;  
                      


select  xmlelement("depts",
            xmlagg(
                xmlforest(d.deptno as "deptno",
                            d.dname as "dname"
                        )
                )
        ) xmltype
     from dept d;

 select  xmlelement("emps",
            xmlagg(
                xmlforest(e.empno as "empno",
                          e.ename as "ename",
                          e.job as "job",
                          e.sal as "sal",
                          to_char(e.hiredate,'dd-mon-yyyy') as "hiredate")
                )
        ) xmltype
     from emp e;     
