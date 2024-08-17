CREATE OR REPLACE PROCEDURE SCOTT.prc_get_orders (p_order_id NUMBER) IS
TYPE orders_tab_type IS
TABLE OF order_lines%ROWTYPE;
v_orders orders_tab_type;
BEGIN
	SELECT * BULK COLLECT INTO v_orders
	FROM order_lines
	where order_id = p_order_id;

	 DBMS_OUTPUT.PUT_LINE ('order_id'
	   || ' ' || 'line_qty'||' '||'total_Value');    
	FOR i IN 1 .. v_orders.COUNT
	LOOP
	 DBMS_OUTPUT.PUT_LINE (v_orders(i).order_id
	   || ' ' || v_orders (i).line_qty||' '||v_orders(i).total_Value);
	END LOOP;
END;

/
