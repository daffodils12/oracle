create or replace package salary_by_all_depts_rpt
as

    GC_DIR constant all_directories.directory_name%type := 'JAGAN_DIR';

    -- Package members to generate the individual worksheets in the report workbook.
    -- These would normally be private.
    procedure title_sheet;
    procedure job_summary_sheet;
    procedure detail_sheet;

    -- Main entry point - this is the procedure to create the report itself.
    procedure run_report;
end salary_by_all_depts_rpt;

create or replace package body salary_by_all_depts_rpt
as
        
    procedure title_sheet
    is 
        v_dept_name varchar2(250);
		v_row		number:=1;
		v_rgb varchar2(25):='0000ff'; --blue color
    begin

        -- the value of width appears to be 1/10th of the default width of a column.
        -- Default is 2.47 cm (24.7 mm), which makes 1 2.47 mm
        -- For reference, the title of the report is 27 characters 
        as_xlsx.set_column_width(p_col => 1,p_width => 20,p_sheet => 1);
        as_xlsx.set_column_width(p_col => 2,p_width => 25,p_sheet => 1);


		--Print Report Title
		as_xlsx.set_row( 1,p_sheet => 1,p_fillId =>as_xlsx.get_fill( 'solid', '0000ff')) ;			
		as_xlsx.cell(1,v_row,'Department id', 	p_sheet => 1, p_numFmtId =>  0, p_fontId => as_xlsx.get_font( 'Arial', p_rgb => 'ffff00', p_bold => true));
		as_xlsx.cell(2,v_row,'Department name', p_sheet => 1, p_numFmtId =>  0, p_fontId => as_xlsx.get_font( 'Arial', p_rgb => 'ffff00', p_bold => true));		
		as_xlsx.freeze_rows( p_nr_rows => 1,p_sheet => 1);

		v_row:=v_row+1;
		For i in (select department_id dept_id,department_name dept_name from departments order by department_id) loop
			-- Parameter Name in A3
			as_xlsx.cell(1,v_row, i.dept_id, p_sheet => 1, p_numFmtId =>  0);						
			as_xlsx.cell(2,v_row, i.dept_name, p_sheet => 1, p_numFmtId => 0);				
			v_row:=v_row+1;
		End Loop;

		as_xlsx.set_autofilter(p_column_start => 1,p_column_end => 2,p_row_start => 1,p_row_end => v_row,p_sheet => 1);		

    end title_sheet;

    procedure job_summary_sheet
    is
        v_row pls_integer := 1; -- need to account for the header row
        v_ave_sal number;
        v_sal_mid_range number;
		v_rgb varchar2(10);
    begin

    -- Set the column widths to allow for the header lengths
    as_xlsx.set_column_width( p_col => 1, p_width => 20, p_sheet => 2);
    as_xlsx.set_column_width( p_col => 2, p_width => 35, p_sheet => 2);
    as_xlsx.set_column_width( p_col => 3, p_width => 20, p_sheet => 2);
    as_xlsx.set_column_width( p_col => 4, p_width => 15, p_sheet => 2);

    -- Set the column headings
    -- NOTE - for second and subsequent sheets, we need to specify the number format or else we'll get
    -- ORA-1403 no data found at line 724 of AS_XLSX.
    -- Specifying the sheet number as it seems sensible to do so at this point !
	as_xlsx.set_row( 1,p_sheet => 2, p_fontId => as_xlsx.get_font( 'Arial', p_rgb => '009933',p_bold => true ), p_fillId => 				as_xlsx.get_fill( 'solid', '00ff40') ) ;
    as_xlsx.cell(1,v_row,'Department Name', p_sheet => 2, p_numFmtId =>  0);
    as_xlsx.cell(2,v_row, 'Job Title',p_sheet => 2, p_numFmtId =>  0);
    as_xlsx.cell(3,v_row, 'No of Employees', p_sheet => 2, p_numFmtId =>  0);
    as_xlsx.cell(4,v_row, 'Total Salary', p_sheet => 2, p_numFmtId =>  0);
	as_xlsx.freeze_rows( p_nr_rows => 1,p_sheet => 2);

    -- Retrive the data rows and populate the relevant cells, applying any
    -- conditional formatting.
    for r_jobs in (
        select dept.department_name, job.job_title, 
            count(emp.employee_id) as employees,
            sum(emp.salary) as total_salary,
            job.min_salary, job.max_salary
        from employees emp
        inner join departments dept
            on dept.department_id = emp.department_id
        inner join jobs job
            on job.job_id = emp.job_id    
        group by dept.department_name, job.job_title,
        job.min_salary, job.max_salary
        order by job.max_salary desc, job.job_title)
    loop
        v_row := v_row + 1;
        as_xlsx.cell(1, v_row, r_jobs.department_name, p_numFmtId =>  0, p_sheet => 2);
        as_xlsx.cell(2, v_row, r_jobs.job_title,  p_numFmtId =>  0, p_sheet => 2);
        as_xlsx.cell(3, v_row, r_jobs.employees,  p_numFmtId =>  0, p_sheet => 2);

        -- If the average salary is lower than the mid-range for this job then
        -- display in red because someone needs a pay rise !
        -- Otherwise, display in green
        v_ave_sal := r_jobs.total_salary / r_jobs.employees;
        v_sal_mid_range :=  r_jobs.min_salary + ((r_jobs.max_salary - r_jobs.min_salary) / 2);
        if v_ave_sal > v_sal_mid_range then
            v_rgb := '009200'; -- green
        else    
            v_rgb := 'ff0000'; -- red
        end if;
        as_xlsx.cell(4, v_row, r_jobs.total_salary, 
            p_fontId => as_xlsx.get_font( 'Arial', p_rgb => v_rgb ),
            p_numFmtId => 0, 
            p_sheet => 2);

    end loop;
	as_xlsx.set_autofilter(p_column_start => 1,p_column_end => 4,p_row_start => 1,p_row_end => v_row,p_sheet => 2);

    end job_summary_sheet;

    procedure detail_sheet is
        v_rc sys_refcursor;
		v_row number:=0;
		v_rgb VARCHAR2(25):='00bfff'; -- light blue color
    begin 
        -- Format the column headings in the ref cursor query
        open v_rc for 
            select emp.employee_id as "Employee ID", 
                emp.first_name as "First Name", 
                emp.last_name as "Last Name",
                job.job_title as "Job Title", 
                emp.salary as "Salary"
            from employees emp
            inner join jobs job
                on job.job_id = emp.job_id;

        as_xlsx.query2sheet( v_rc, p_sheet => 3);

        -- Any formatting gets overwritten by the query2sheet so
        -- we need to do it afterwards
		as_xlsx.freeze_rows( p_nr_rows => 1,p_sheet => 3);
        as_xlsx.set_column_width( p_col => 1, p_width => 15, p_sheet => 3);
        as_xlsx.set_column_width( p_col => 2, p_width => 15, p_sheet => 3);
        as_xlsx.set_column_width( p_col => 3, p_width => 15, p_sheet => 3);
        as_xlsx.set_column_width( p_col => 4, p_width => 15, p_sheet => 3);

		as_xlsx.cell(1,1, 'Employee ID', p_sheet => 3, p_numFmtId =>  0, p_fontId => as_xlsx.get_font( 'Arial', p_rgb => '3333cc', p_bold => true),p_fillId => as_xlsx.get_fill( 'solid', '00bfff'));
		as_xlsx.cell(2,1, 'First Name', p_sheet => 3, p_numFmtId =>  0, p_fontid => as_xlsx.get_font('Arial', p_bold => true, p_rgb => '3333cc'),p_fillId => as_xlsx.get_fill( 'solid', '00bfff'));
		as_xlsx.cell(3,1, 'Last Name', p_sheet => 3, p_numFmtId =>  0, p_fontid => as_xlsx.get_font('Arial', p_bold => true, p_rgb => '3333cc'),p_fillId => as_xlsx.get_fill( 'solid', '00bfff'));
		as_xlsx.cell(4,1, 'Job Title', p_sheet => 3, p_numFmtId =>  0, p_fontid => as_xlsx.get_font('Arial', p_bold => true, p_rgb => '3333cc'),p_fillId => as_xlsx.get_fill( 'solid', '00bfff'));
		as_xlsx.cell(5,1, 'Salary', p_sheet => 3, p_numFmtId =>  0, p_fontid => as_xlsx.get_font('Arial', p_bold => true, p_rgb => '3333cc'),p_fillId => as_xlsx.get_fill( 'solid', '00bfff'));		


		select count(*) into v_row
            from employees emp
            inner join jobs job
                on job.job_id = emp.job_id;		

		as_xlsx.set_autofilter(p_column_start => 1,p_column_end => 5,p_row_start => 1,p_row_end => v_row,p_sheet => 3);


    end detail_sheet;

    procedure run_report
    is
        v_fname varchar2(250);
    begin
        v_fname := 'salary_report_for_all_depts.xlsx';
        -- Ensure we have nothing hanging around from a previous run in this session
        as_xlsx.clear_workbook;

        -- For the query2sheet call to work where it's not the first sheet or
        -- any other sheet preceeding it is not being created using this call,
        -- you need to define all of the sheets upfront.
        -- Otherwise, it will only write a single integer to that sheet.
        as_xlsx.new_sheet('Departments');
        as_xlsx.new_sheet('Summary by Job');
        as_xlsx.new_sheet('Department Employees');

        -- Call each procedure in turn to populate the worksheets
        title_sheet;
        job_summary_sheet;       
        detail_sheet;

        as_xlsx.save( GC_DIR, v_fname);        

    end run_report;    
end salary_by_all_depts_rpt;
