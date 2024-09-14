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