CREATE OR REPLACE procedure SCOTT.prc_load_order(p_srf sys_refcursor) as
v_tab t_tf_order_tbl := t_tf_order_tbl();
begin
    fetch p_srf bulk collect into v_tab;

    --dbms_output.put_line('Order_id :'||v_tab(1).order_id||' Rows loaded :'||v_tab.count);
    forall i in v_tab.FIRST..v_tab.LAST 
        insert into order_lines_bulk  
        values(v_tab(i).order_id,v_tab(i).line_qty,v_tab(i).total_value)
        log errors into err$_order_lines_bulk reject limit unlimited;

    close p_srf;

end;

/
