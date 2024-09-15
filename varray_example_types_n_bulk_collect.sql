CREATE OR REPLACE PROCEDURE PRC_ORDERS_VARRAY_TYPE(p_order_id in NUMBER) as
    
    TYPE t_order_type IS VARRAY(200) OF t_tf_order_row;
    t_orders t_order_type := t_order_type();
	
	CURSOR C1(p_order_id number) is
	SELECT t_tf_order_row(ORDER_ID,LINE_QTY,TOTAL_VALUE) FROM ORDER_LINES
	WHERE ORDER_ID=p_order_id;
BEGIN
	dbms_output.put_line('order_lines rows');
    OPEN C1(P_ORDER_ID);
    LOOP
        FETCH C1 BULK COLLECT INTO t_orders;        
        EXIT WHEN C1%NOTFOUND;    
    END LOOP;  
	CLOSE C1;	
    FOR i IN t_orders.FIRST..t_orders.LAST LOOP
        dbms_output.put_line(t_orders(i).order_id||' ,'||t_orders(i).line_qty||' ,'||t_orders(i).total_value);
    END LOOP;
    
    dbms_output.put_line('The number of orders is ' || t_orders.COUNT);
    
END;
/

set serverout on;
exec PRC_ORDERS_VARRAY_TYPE(101);