-- Given below procedure passes sys_refcursor as a parameter and extracts
-- and displays the data from the passed sysrefcursor
create or replace procedure sysrefcur_test (p_srf sys_refcursor) as
	TYPE v_order_row is record
	(order_id number,
	line_qty number,
	total_Value number);
		
	v_orow	v_order_row:=v_order_row(); 
	
begin
    loop
        fetch p_srf into v_orow;
        exit when p_srf%notfound;
		dbms_output.put_line(v_orow.order_id||', '||v_orow.line_qty||', '||v_orow.total_Value);
    end loop;
end;
/

set serverout on;
exec sysrefcur_test(fn_srf_get_order_rows(100));


