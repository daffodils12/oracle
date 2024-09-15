CREATE OR REPLACE PROCEDURE PRC_ORDERS_VARRAY(p_order_id in NUMBER) as
    TYPE r_order_type IS RECORD(
        order_id order_lines.order_id%TYPE,
        line_qty order_lines.line_qty%TYPE,
		total_value order_lines.total_value%TYPE
    ); 
    
    TYPE t_order_type IS VARRAY(200) 
        OF r_order_type;

    t_orders t_order_type := t_order_type();
	
	CURSOR C1(p_order_id number) is
	SELECT ORDER_ID,LINE_QTY,total_value FROM ORDER_LINES
	WHERE ORDER_ID=p_order_id;
BEGIN
	dbms_output.put_line('order_lines rows');
    -- fetch data from a cursor
    FOR r_order_type IN C1(p_order_id) LOOP
        t_orders.EXTEND;
        t_orders(t_orders.LAST).order_id := r_order_type.order_id;
        t_orders(t_orders.LAST).line_qty  := r_order_type.line_qty;
        t_orders(t_orders.LAST).total_value  := r_order_type.total_value;
    END LOOP;        
		
    FOR i IN t_orders.FIRST..t_orders.LAST 
    LOOP
        dbms_output.put_line(t_orders(i).order_id||' ,'||t_orders(i).line_qty||' ,'||t_orders(i).total_value);
    END LOOP;
    
    dbms_output.put_line('The number of orders is ' || t_orders.COUNT);
END;
/

select * from order_lines;

set serverout on;
exec PRC_ORDERS_VARRAY(101);