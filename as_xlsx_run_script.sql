create or replace directory app_dir as '/opt/oracle/appdir';
 
grant read, write on directory app_dir to hr;

--connect to HR schema to run this report
exec salary_by_all_depts_rpt.run_Report;


