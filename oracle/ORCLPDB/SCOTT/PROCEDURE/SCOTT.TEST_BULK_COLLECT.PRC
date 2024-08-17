CREATE OR REPLACE PROCEDURE SCOTT.test_bulk_collect(p_ref_cursor IN OUT SYS_REFCURSOR)
AS
    l_recs test_tab_type := test_tab_type();
BEGIN

    FETCH p_ref_cursor                     -- run-time error happens here when in debug mode
    BULK COLLECT INTO l_recs;  

    FOR i IN l_recs.FIRST .. l_recs.LAST
    LOOP
        l_recs(i).tdesc := 'updated' || i;   -- the real procedure will do some heavy biz logic for each row.
    END LOOP;

    OPEN p_ref_cursor FOR
    SELECT *
    FROM TABLE(l_recs);

END;

/
