CREATE OR REPLACE procedure SCOTT.prc_load_orders (p_srf_orders in sys_refcursor) as

v_tab_tbl   t_tf_order_tbl:=t_tf_order_tbl();
begin
    fetch p_srf_orders bulk collect into v_tab_tbl;

    dbms_output.put_line('Nr of rows to load :'||v_tab_tbl.count);
    FORALL i in v_tab_tbl.FIRST..v_tab_tbl.LAST 
        INSERT INTO order_lines_bulk
        values(v_tab_tbl(i).order_id,v_tab_tbl(i).line_qty,v_tab_tbl(i).total_value)
        log errors into err$_order_lines_bulk reject limit unlimited;

    close p_srf_orders;
end;

/
