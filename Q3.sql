CREATE OR REPLACE FUNCTION SALARY_ADJUST() RETURNS VOID AS $$
DECLARE

-- 	declare auxiliaries
	emp_cursor CURSOR FOR 
		SELECT employee_id
		FROM employees;
	
	v_min_salary numeric(8,2);
	v_max_salary numeric(8,2);
	cur_salary numeric(8,2);
	new_salary numeric(8,2);
	
	v_employee INT;
	aux INT;

BEGIN

	OPEN emp_cursor;
	
	LOOP
	
		FETCH emp_cursor INTO v_employee;
		EXIT WHEN NOT FOUND;
		
-- 		initiate aux as zero
		aux = 0;

-- 		fetch the salary of the employee
		SELECT SALARY
			INTO cur_salary
		FROM EMPLOYEES  WHERE EMPLOYEE_ID = v_employee;

-- 		fetch the min and max salary from the jobs table
		SELECT MIN_SALARY, MAX_SALARY
			INTO v_min_salary, v_max_salary
		FROM EMPLOYEES
		NATURAL JOIN JOBS
		WHERE EMPLOYEE_ID = v_employee;

-- 		check if salary is less than minimal
		IF(cur_salary < v_min_salary) 
			THEN new_salary = v_min_salary; aux = 1;
		END IF;
		
-- 		a second check to see if the current salary is higher than the max salary
		IF(cur_salary > v_max_salary)
			THEN new_salary = v_max_salary; aux = 1;
		END IF;

-- 		check if salary is in between min and max salary
		IF(aux = 0) THEN
			IF((cur_salary >= v_min_salary) AND (cur_salary <= v_max_salary))
				THEN 
-- 					check if the current salary plus ten percent still below the max salary
					IF((cur_salary + (cur_salary * 0.1)) <= v_max_salary)
						THEN new_salary = (cur_salary + (cur_salary * 0.1));
					ELSE
						new_salary = cur_salary;
					END IF;
			END IF;
		END IF;
		
-- 		update the salary to the new salary
		UPDATE EMPLOYEES SET SALARY = new_salary
		WHERE EMPLOYEE_ID = v_employee;
		
	END LOOP;
	
	CLOSE emp_cursor;
	
END $$ LANGUAGE plpgsql;