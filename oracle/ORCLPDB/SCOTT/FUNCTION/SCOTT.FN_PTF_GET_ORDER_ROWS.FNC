CREATE OR REPLACE function SCOTT.fn_ptf_get_order_rows(p_order_id varchar2) return t_tf_order_tbl PIPELINED  as

CURSOR C1 IS
select order_id,line_qty,total_value
from order_lines
where order_id=p_order_id;

cur_c1_row  c1%rowtype;
begin
    for cur_c1_row in c1 loop
        PIPE ROW(t_tf_order_row(cur_c1_row.order_id,cur_c1_row.line_qty,cur_c1_row.total_value));
    end loop;

    return;
end;
/
