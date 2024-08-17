DECLARE

BEGIN
  DBMS_HPROF.start_profiling (location => 'PROFILER_DIR',
    filename => 'prc_load_order.txt');
   
    for c1 in (select distinct order_id from order_lines order by order_id) loop 
        prc_load_order(fn_srf_get_order(c1.order_id));
    end loop;

  DBMS_HPROF.stop_profiling;
END;
/


DECLARE
  l_runid  NUMBER;
BEGIN
  l_runid := DBMS_HPROF.analyze (
               location    => 'PROFILER_DIR',
               filename    => 'prc_load_order.txt',
               run_comment => 'prc_load_order run');
                    
  DBMS_OUTPUT.put_line('l_runid=' || l_runid);
END;
/