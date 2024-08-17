CREATE OR REPLACE PROCEDURE SCOTT.test_refcur_bulk_collect(p_ref_cursor IN SYS_REFCURSOR)
AS

TYPE t_tf_order_row is record
(order_id number,
line_qty number,
total_value number);

TYPE t_tf_order_tbl is TABLE OF t_tf_order_row;

    v_tbl t_tf_order_tbl := t_tf_order_tbl();
BEGIN

    FETCH p_ref_cursor                     -- run-time error happens here when in debug mode
    BULK COLLECT INTO v_tbl;  

    FOR i IN v_tbl.FIRST .. v_tbl.LAST
    LOOP        
		dbms_output.put_line(v_tbl(i).order_id||', '||v_tbl(i).line_qty||', '||v_tbl(i).total_value);
    END LOOP;    
END;

/
