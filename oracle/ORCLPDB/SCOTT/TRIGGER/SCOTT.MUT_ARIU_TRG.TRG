CREATE OR REPLACE TRIGGER SCOTT.Mut_ariu_trg
AFTER INSERT OR UPDATE ON SCOTT.MUT
FOR EACH ROW
BEGIN

  IF inserting THEN
      INSERT INTO Mut_audit (id, action, Mut_id, record_count, created_time)
      VALUES (Mut_audit_seq.NEXTVAL, 'INSERT', :new.id, 1, SYSTIMESTAMP);
  ELSE
      INSERT INTO Mut_audit (id, action, Mut_id, record_count, created_time)
        VALUES (Mut_audit_seq.NEXTVAL, 'UPDATE', :new.id, 1, SYSTIMESTAMP);
  END IF;
END;
/
