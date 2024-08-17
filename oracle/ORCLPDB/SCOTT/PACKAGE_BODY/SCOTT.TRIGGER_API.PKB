CREATE OR REPLACE PACKAGE BODY SCOTT.trigger_api AS

PROCEDURE Mut_row_change (p_id      IN  Mut.id%TYPE,
                           p_action  IN  VARCHAR2) IS
BEGIN
  INSERT INTO Mut_mods (id, action) VALUES (p_id, p_action);
END Mut_row_change;

PROCEDURE Mut_statement_change IS
  l_count  NUMBER(10);
BEGIN
  FOR i IN (SELECT * FROM Mut_mods) LOOP
    SELECT COUNT(*)
    INTO   l_count
    FROM   Mut;

    INSERT INTO Mut_audit (id, action, Mut_id, record_count, created_time)
    VALUES (Mut_audit_seq.NEXTVAL, i.action, i.id, l_count, SYSTIMESTAMP);
  END LOOP;
  commit;
END Mut_statement_change;

END trigger_api;

/
