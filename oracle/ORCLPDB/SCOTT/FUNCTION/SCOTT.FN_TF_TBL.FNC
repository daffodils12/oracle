CREATE OR REPLACE FUNCTION SCOTT.fn_tf_tbl(P_ROWS NUMBER) RETURN t_tf_tbl AS
l_tab t_tf_tbl:=t_tf_tbl();
BEGIN

    FOR i in 1..P_ROWS LOOP
        l_tab.extend;
        l_tab(i):=t_tf_row(i,'Desc '||i);
    END LOOP;

    RETURN l_tab;
END;

/
