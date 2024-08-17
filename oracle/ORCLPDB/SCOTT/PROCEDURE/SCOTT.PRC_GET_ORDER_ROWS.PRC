CREATE OR REPLACE procedure SCOTT.prc_get_order_rows(p_order_id in number) is
TYPE t_row is record 
(order_id number,
line_qty number,
total_value number);
TYPE t_tab is table of t_row;
l_tab t_tab:=t_tab();
l_idx number;

cursor c1 is 
select order_id,line_qty,total_value
from order_lines
where order_id=p_order_id;

begin
    open c1;
    loop
        fetch c1 bulk collect into l_tab;

        for i in l_tab.first..l_tab.last loop        
            dbms_output.put_line('Orders :'||l_tab(i).order_id||', '||l_tab(i).line_qty||', '||l_tab(i).total_Value);
        end loop;
        exit when c1%notfound;    
    end loop;    
end;

/
