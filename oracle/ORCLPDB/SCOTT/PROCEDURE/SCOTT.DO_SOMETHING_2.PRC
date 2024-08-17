CREATE OR REPLACE PROCEDURE SCOTT.do_something_2 (p_times  IN  NUMBER) AS
BEGIN
  FOR i IN 1 .. p_times LOOP
    do_something_3(p_times => p_times);
  END LOOP;
END;

/
