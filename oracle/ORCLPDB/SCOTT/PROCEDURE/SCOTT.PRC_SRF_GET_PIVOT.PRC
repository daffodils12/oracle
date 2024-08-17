CREATE OR REPLACE procedure SCOTT.prc_srf_Get_pivot(p_tbl_nm varchar2,p_col1 varchar2,p_col2 varchar2)
as

v_sql_stmt	varchar2(200);
begin

	v_sql_stmt := 'select distinct '||p_col2||' from '||p_tbl_nm;
    dbms_output.put_line('v_sql_stmt :'||v_sql_stmt);


end;

/
