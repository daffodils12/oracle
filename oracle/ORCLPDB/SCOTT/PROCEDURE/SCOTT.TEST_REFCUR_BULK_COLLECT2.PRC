CREATE OR REPLACE PROCEDURE SCOTT.test_refcur_bulk_collect2(p_srf in SYS_REFCURSOR)
AS
    v_tbl t_tf_order_tbl := t_tf_order_tbl();
BEGIN

    loop
        FETCH p_srf                  
        BULK COLLECT INTO v_tbl;  

        FOR i IN v_tbl.FIRST .. v_tbl.LAST
        LOOP        
            dbms_output.put_line(v_tbl(i).order_id||', '||v_tbl(i).line_qty||', '||v_tbl(i).total_value);
        END LOOP; 
        exit when p_srf%NOTFOUND;
    end loop;
	CLOSE p_srf;
END;

/
