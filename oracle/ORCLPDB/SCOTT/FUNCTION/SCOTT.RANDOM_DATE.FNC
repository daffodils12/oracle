CREATE OR REPLACE FUNCTION SCOTT.random_date(
 p_from IN DATE,
 p_to IN DATE
) RETURN DATE
 IS
 BEGIN
 RETURN p_from + DBMS_RANDOM.VALUE() * (p_to - p_from + 1);
 END random_date;

/
