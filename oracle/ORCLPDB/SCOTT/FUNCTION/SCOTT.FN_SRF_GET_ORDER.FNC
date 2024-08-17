CREATE OR REPLACE function SCOTT.fn_srf_get_order(p_order_id number) return SYS_REFCURSOR as

v_srf   sys_refcursor;
begin
    open v_srf for
    select t_tf_order_row(order_id,line_qty,total_value)
    from order_lines
    where order_id=p_order_id;

    return v_srf;
end;

/
