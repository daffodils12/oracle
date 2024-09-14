select xmlelement("depts",
        xmlagg(
         xmlelement("dept",
            xmlforest(d.deptno as "deptno",
            d.dname as "dname",
            (select xmlagg(
                    xmlelement("emp",
                     xmlforest(e.empno as "empno",
                              e.ename as "ename",
                              e.job as "job",
                              e.sal as "sal",
                              to_char(e.hiredate,'dd-mon-yyyy') as "hiredate")
                            )
                     )                                         
                     from emp e      
                     where e.deptno=d.deptno
            ) as "emps"
)))) as "emp_dept" from dept d;