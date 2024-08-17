CREATE OR REPLACE PROCEDURE SCOTT.test_plscope (p_in  IN  NUMBER) AS
  l_var NUMBER;
BEGIN
  l_var := p_in;

  l_var := l_var + 1;
END;

/
