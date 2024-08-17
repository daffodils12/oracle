CREATE OR REPLACE PACKAGE SCOTT.trigger_api AS

PROCEDURE Mut_row_change (p_id      IN  Mut.id%TYPE,
                           p_action  IN  VARCHAR2);

END trigger_api;

/
