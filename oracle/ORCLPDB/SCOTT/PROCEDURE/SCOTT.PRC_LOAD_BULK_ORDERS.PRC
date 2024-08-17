CREATE OR REPLACE procedure SCOTT.prc_load_bulk_orders as

cursor c1 is
select t_tf_order_row(order_id,line_qty,total_Value)
from order_lines;

v_tbl   t_tf_order_tbl:=t_tf_order_tbl();
v_cnt number:=0;
begin
    open c1;
    loop
        fetch c1 bulk collect into v_tbl limit 1000;

        v_cnt:=v_cnt+1000;
        if  mod(v_Cnt,1000)=0 then
            commit;
            dbms_output.put_line('Processed 10k rows.');
        end if;
        FORALL i in v_tbl.FIRST..v_tbl.LAST 
            INSERT INTO ORDER_LINES_BULK
            VALUES(v_tbl(i).order_id,v_tbl(i).line_qty,v_tbl(i).total_Value)
            log errors into err$_order_lines_bulk reject limit unlimited;

        exit when c1%notfound;


    end loop;
    commit;

end;

/
