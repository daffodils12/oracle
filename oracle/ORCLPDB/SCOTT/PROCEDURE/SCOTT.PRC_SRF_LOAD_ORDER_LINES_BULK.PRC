CREATE OR REPLACE procedure SCOTT.prc_srf_load_order_lines_bulk as
CURSOR C1 IS
select t_tf_order_row(order_id,line_qty,total_value)
from order_lines
order by order_id;

v_tab_tbl t_tf_order_tbl:=t_tf_order_tbl();
v_cnt number:=0;
begin
    execute immediate 'truncate table order_lines_bulk';
    execute immediate 'truncate table err$_order_lines_bulk';
    open c1;
    loop
        fetch c1 bulk collect into v_tab_tbl limit 1000;

        v_cnt:=v_cnt+1000;
        dbms_output.put_line('v_tab_tbl.LAST :'||v_tab_tbl.LAST);
        FORALL i in v_tab_tbl.FIRST..v_tab_tbl.LAST 
            INSERT INTO ORDER_LINES_BULK
            VALUES(v_tab_tbl(i).order_id,v_tab_tbl(i).line_qty,v_tab_tbl(i).total_Value)
            log errors into ERR$_order_lines_bulk REJECT LIMIT UNLIMITED;

        if mod(v_cnt,10000)=0 then
            commit;
            dbms_output.put_line('processed 10k rows.');
        end if;
        exit when c1%notfound;

    end loop;
    close c1;

end;

/
