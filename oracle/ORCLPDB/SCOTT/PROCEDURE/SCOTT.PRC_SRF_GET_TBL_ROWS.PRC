CREATE OR REPLACE procedure SCOTT.prc_srf_get_tbl_rows(p_tbl_nm in VARCHAR2)  as 

cursor c1 is
	select column_name
	from user_tab_Columns
	where table_name=p_tbl_nm
	order by column_id;

c1_row 	c1%rowtype;	
v_tbl_cols	varchar2(32767):='select ';
v_srf	sys_refcursor;
v_rec_cnt   number:=0;
v_col_cnt   number:=0;
begin
    select count(*)
    into v_rec_cnt
    from user_Tab_columns
    where table_name=p_tbl_nm;

	open c1;
	loop
		fetch c1 into c1_row;
		exit when c1%notfound;
        v_col_cnt:=v_col_cnt+1;
        if v_col_cnt!=v_rec_cnt then
            v_tbl_cols:=v_tbl_cols||c1_row.column_name||',';		
		else
            v_tbl_cols:=v_tbl_cols||c1_row.column_name;
        end if;
	end loop;
	close c1;
	if v_tbl_cols=' select ' then
		raise_application_error(20001,'Table does not exist');
	end if;	
	v_tbl_cols:=v_tbl_cols||' from '||p_tbl_nm||';';
	dbms_output.put_line('v_tbl_cols :'||v_tbl_cols);

	--open v_srf for v_tbl_cols;

	--return v_srf;

end;

/
