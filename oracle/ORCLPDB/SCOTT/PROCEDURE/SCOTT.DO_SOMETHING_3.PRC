CREATE OR REPLACE PROCEDURE SCOTT.do_something_3 (p_times  IN  NUMBER) AS
  l_dummy  NUMBER;
BEGIN
  FOR i IN 1 .. p_times LOOP
    SELECT l_dummy + 1
    INTO   l_dummy
    FROM   dual;
  END LOOP;
END;

/
