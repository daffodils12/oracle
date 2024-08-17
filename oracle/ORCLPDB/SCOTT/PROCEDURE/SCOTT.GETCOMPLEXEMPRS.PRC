CREATE OR REPLACE PROCEDURE SCOTT.GetComplexEmpRS (p_deptno    IN  emp.deptno%TYPE,
                           p_recordset OUT types.cursor_type) AS 
  v_tab  emp_tab_type := emp_tab_type();
BEGIN

  -- Populate PL/SQL table.
  FOR cur_row IN (SELECT * FROM emp WHERE deptno = p_deptno) LOOP
    v_tab.extend;
    v_tab(v_tab.Last) := emp_row_type(cur_row.empno, cur_row.ename, cur_row.sal, NULL);
  END LOOP;

  -- Do complex processing that can't be done from SQL alone.
  FOR cur_row IN 1 .. v_tab.count LOOP
    v_tab(cur_row).complex := v_tab(cur_row).sal + 1000;
  END LOOP;

  -- Open REF CURSOR for outout.
  OPEN p_recordset FOR
    SELECT emp_row_type(empno,
           ename,
           sal,
           sal+1000)
    FROM   TABLE(CAST(v_tab As emp_tab_type))
    ORDER BY ename; 
END GetComplexEmpRS;

/
