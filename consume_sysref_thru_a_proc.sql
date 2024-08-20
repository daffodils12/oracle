create or replace procedure prc_srf_get_order_rows(p_srf_order_rows in SYS_REFCURSOR) as

TYPE tf_order_row is record
(order_id number,
line_qty number,
total_value number);

TYPE tf_order_tbl is table of tf_order_row;

v_tab_tbl tf_order_tbl:=tf_order_tbl();
begin
    loop
        fetch p_srf_order_rows bulk collect into v_tab_tbl;       
        
        dbms_output.put_line('v_tab_tbl.count :'||v_tab_tbl.COUNT);
        for i in v_tab_tbl.FIRST..v_tab_tbl.LAST loop
            dbms_output.put_line('Orders :'||v_tab_tbl(i).order_id||', '||v_tab_tbl(i).line_Qty||', '||v_tab_tbl(i).total_Value);
        end loop;
         exit when p_srf_order_rows%notfound;
    end loop;

end;
/

set serverout on;
exec prc_srf_get_order_rows(fn_srf_get_order_rows(100));