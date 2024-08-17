delete FROM order_lines_bulk 
WHERE rowid in ( SELECT MIN(rowid) FROM order_lines_bulk 
                where order_id=101
                GROUP BY order_id,line_qty,total_value );    