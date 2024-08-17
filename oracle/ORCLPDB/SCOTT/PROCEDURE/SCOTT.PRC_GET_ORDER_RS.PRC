CREATE OR REPLACE procedure SCOTT.prc_get_order_rs(p_order_id number,
                                             p_rs out sys_refcursor) as
begin
    open p_rs for
    select order_id,line_qty,total_Value
    from order_lines
    where order_id=p_order_id;
end;

/
