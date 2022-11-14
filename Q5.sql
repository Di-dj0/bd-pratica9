CREATE OR REPLACE FUNCTION CHECK_JOB_HISTORY() RETURNS TRIGGER AS $$
	 
BEGIN

-- 	check if the employee has an entry in job_history table
	IF(NOT EXISTS ( SELECT EMPLOYEE_ID FROM JOB_HISTORY WHERE JOB_HISTORY.EMPLOYEE_ID = OLD.employee_id) )
-- 		if it doesnt exists, then the start_date value is equal to the hire_date
		THEN 
-- 		here is established that the employee is in they first job and is getting a promotion.
-- 		so, for job_history, his current job is added in the table
		INSERT INTO JOB_HISTORY VALUES(OLD.employee_id, 
										OLD.hire_date,
										now(),
										OLD.job_id,
										OLD.department_id);
	ELSE
	
-- 		if exist, then the start_date value fetch the last end_date value in job_history
		
-- 		here is another problem. now we need to get the last register in the job_history table
-- 		as expressed in the use of "MAX()" for the "end_date" value, fetching the last end_date registered
		INSERT INTO JOB_HISTORY VALUES(OLD.employee_id, 
										(SELECT MAX(end_date) end_date 
										 	FROM JOB_HISTORY 
										 	WHERE JOB_HISTORY.EMPLOYEE_ID = OLD.employee_id),
									   	now(),
										OLD.job_id,
										OLD.department_id);
										
	END IF;
	
-- 	values structure for job_history = (employee_id, start_date, end_date, job_id, department_id)
						
	RETURN NEW;

END $$ LANGUAGE plpgsql;

--////////////////////////////////

-- create the trigger
CREATE TRIGGER trg_employee_history_check
	BEFORE UPDATE ON employees
	FOR EACH ROW EXECUTE PROCEDURE CHECK_JOB_HISTORY();