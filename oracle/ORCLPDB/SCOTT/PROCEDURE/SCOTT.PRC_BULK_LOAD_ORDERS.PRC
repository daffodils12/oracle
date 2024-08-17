CREATE OR REPLACE procedure SCOTT.prc_bulk_load_orders as
CURSOR c1 is
select t_tf_order_row(order_id,line_qty,total_value)
from order_lines
order by order_id;

v_tbl   t_tf_order_tbl:=t_tf_order_tbl();
begin
    open c1;
    loop
        fetch c1 bulk collect into v_tbl;

        forall i in v_tbl.FIRST..v_tbl.LAST
            insert into order_lines_bulk
            values (v_tbl(i).order_id,v_tbl(i).line_qty,v_tbl(i).total_value)
            log errors into err$_order_lines_bulk reject limit unlimited;
        exit when c1%notfound;
    end loop;
    close c1;
end;

/
