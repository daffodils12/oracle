CREATE OR REPLACE function SCOTT.fn_srf_Get_order_rows(p_order_id number) return sys_refcursor as

v_srf   sys_refcursor;
begin
    open v_srf for select order_id,line_qty,total_value from order_lines where order_id=p_order_id;

    return v_srf;

end;

/
