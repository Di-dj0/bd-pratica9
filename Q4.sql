CREATE OR REPLACE FUNCTION FUNC_JOB_HISTORY(v_employee int) RETURNS varchar AS $$
DECLARE

-- 	declare auxiliaries
	v_job_title JOBS.JOB_TITLE%TYPE;
	v_job_title_hist JOBS.JOB_TITLE%TYPE;
	
	aux_array VARCHAR(35) ARRAY;
	
-- 	and declare a cursor for each of the job titles in history
	job_cursor CURSOR FOR 
		SELECT JOB_TITLE
		FROM JOBS
		INNER JOIN JOB_HISTORY ON JOB_HISTORY.JOB_ID = JOBS.JOB_ID
		WHERE EMPLOYEE_ID = v_employee;
	 
BEGIN
    
-- 	fetch the current job title
	SELECT JOB_TITLE 
        INTO  v_job_title
	FROM EMPLOYEES
	NATURAL JOIN JOBS
	WHERE EMPLOYEE_ID = v_employee;
	
-- 	initiate the array with the first space as the current job title
	aux_array[0] = v_job_title::varchar(35);
	
	
-- 	open the cursor for job history
	OPEN job_cursor;
	
-- 	100 is an arbitrary number, is expected that none of the options are an employee with more than 100 titles in history
	FOR i IN 1..100
	
	LOOP
		
-- 		"for each job title in history..."
		FETCH job_cursor INTO v_job_title_hist;
		EXIT WHEN NOT FOUND;
		
-- 		"...check if this title is not in the response array,..."
		IF(aux_array[i-1] != v_job_title_hist::varchar(35))
-- 			"...if not, put it in the array in the last position."
			THEN aux_array[i] = v_job_title_hist;
		END IF;
		
	END LOOP;
	
-- 	close the job history cursor
	CLOSE job_cursor;

-- 	a function just so that the complete array is displayed in the "messages" tab
	RAISE NOTICE '%', aux_array;

   	RETURN aux_array;

END $$ LANGUAGE plpgsql;