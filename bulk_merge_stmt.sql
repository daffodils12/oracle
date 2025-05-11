--Bulk collect with Merge statement
                                                     --Bulk collect with Merge statement

--1. First create the following tables.

CREATE TABLE JOB_LOG
(JOB_NAME VARCHAR2(1000 BYTE), 
JOB_START_DT DATE, 
JOB_END_DT DATE, 
JOB_LOG VARCHAR2(4000 BYTE)
);



CREATE TABLE BULK_MERGE_TEST
(ID NUMBER(10,0), 
CODE VARCHAR2(10 BYTE), 
DESCRIPTION VARCHAR2(50 BYTE), 
 CONSTRAINT BULK_MERGE_TEST_PK PRIMARY KEY (ID)
);	

	

CREATE TABLE BULK_MERGE_TEST2 
AS SELECT * FROM BULK_MERGE_TEST;

  

 

--2. Populate both the tables BULK_MERGE_TEST and BULK_MERGE_TEST2

declare

begin

	for i in 1..10000 loop
		insert into BULK_MERGE_TEST
		(id, code, description)
		values(i,i,'Description '||i);		

		insert into BULK_MERGE_TEST2
		(id, code, description)
		values(i,i,'Description '||i);		
	end loop;
	commit;	

end;
/  



--3. Delete a few records in table BULK_MERGE_TEST2
delete from BULK_MERGE_TEST2 where id between 2100 and 3150;
commit;

--4. Run the following bulk collect with MERGE script.
set serverout on;
declare
TYPE t_tab is table of BULK_MERGE_TEST%rowtype;
v_tab t_tab:=t_tab();

cursor c1 is
select * from BULK_MERGE_TEST 
order by id;

l_start_dt date:=sysdate;
l_cnt number:=0;
v_tot_recs_in_db number:=0;
v_tot_recs_ins   number:=0;

begin

    insert into job_log
    values('BULK_MERGE',l_start_dt,null,'Job Started...');
    commit;

    select count(*) into v_tot_recs_in_db from BULK_MERGE_TEST2;

    open c1;
    loop
        fetch c1 bulk collect into v_tab limit 100;
      
        for i in 1..v_tab.COUNT loop
                MERGE into BULK_MERGE_TEST2 d
                USING (select v_tab(i).id as id,
                              v_tab(i).code as code,
                              v_tab(i).description as description
                        from dual) s       --Note we are using the Bulk collect as a the Source table
                ON (s.id=d.id)

                WHEN MATCHED THEN
                    update set
                    code=s.code,
                    description='merge stmt '||s.description
                WHEN NOT MATCHED THEN
                    insert 
                    (id,code,description)
                    values (s.id,s.code,s.description);                                  
        end loop;

        l_cnt:=l_cnt+v_tab.count;
        select count(*) into v_tot_recs_ins from BULK_MERGE_TEST2;
        
            update job_log set job_end_dt=sysdate,
                               job_log='Processed rows cnt:'||l_cnt||' upd/ins rows '||
							   ((v_tot_recs_in_db+l_cnt)-v_tot_recs_ins)||'/'||(v_tot_recs_ins-v_tot_recs_in_db)
                where job_name='BULK_MERGE'
                and job_start_dt=l_start_dt;
            
            dbms_output.put_line('Processed rows cnt:'||l_cnt);
            commit;        

         exit when c1%notfound; 
    end loop;
    close c1;

    update job_log set job_end_dt=sysdate,
                       job_log='Completed processing rows cnt:'||l_cnt||' upd/ins rows '||((v_tot_recs_in_db+l_cnt)-v_tot_recs_ins)||'/'||(v_tot_recs_ins-v_tot_recs_in_db)
        where job_name='BULK_MERGE'
        and job_start_dt=l_start_dt;   

    dbms_output.put_line('Completed processing cnts:'||l_cnt);
    commit;
	
end;
/



--5. Query the JOB_LOG table to see the status of the job.
alter session set NLS_DATE_FORMAT='mm/dd/yyyy hh:mi:ss';
select * from job_log;