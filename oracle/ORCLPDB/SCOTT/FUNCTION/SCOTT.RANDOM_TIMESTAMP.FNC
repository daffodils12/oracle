CREATE OR REPLACE FUNCTION SCOTT.random_timestamp(
 p_from IN TIMESTAMP,
 p_to IN TIMESTAMP
) RETURN TIMESTAMP
 IS
 BEGIN
 RETURN p_from + DBMS_RANDOM.VALUE() * (p_to - p_from + interval '1' day);
 END random_timestamp;

/
