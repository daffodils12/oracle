CREATE OR REPLACE TRIGGER SCOTT.tab1_ariu_trg
AFTER INSERT OR UPDATE ON SCOTT.TAB1
FOR EACH ROW
BEGIN
  IF inserting THEN
    trigger_api.tab1_row_change(p_id => :new.id, p_action => 'INSERT');
  ELSE
    trigger_api.tab1_row_change(p_id => :new.id, p_action => 'UPDATE');
  END IF;
END;
/
