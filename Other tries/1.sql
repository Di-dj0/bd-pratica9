CREATE OR REPLACE FUNCTION FUNC_CK(p_text VARCHAR) RETURNS VARCHAR AS $$
DECLARE

	--declaring auxiliaries
    text_size NUMERIC;
	key_value INT;
	ascii_value INT;
	error_msg TEXT := 'Existe(m) caracter(es) inválido(s)!';
	string_res TEXT := '';
	
BEGIN
    
	--create a key
	key_value := 5;
	
	--take the input size
	text_size := LENGTH(p_text);
	
	
	FOR i IN 1..text_size
	LOOP
	
		--update the current ascii_value to the current letter
		ascii_value = ASCII(SUBSTRING(p_text FROM i FOR 1));
		
		--check if letter is a special character
		IF ((ascii_value < 65) OR (ascii_value BETWEEN 91 AND 96) OR (ascii_value > 122))
			THEN RETURN error_msg;
		
		--if not, run the logic below
		ELSE
			string_res := CONCAT(string_res, CHR(ascii_value + key_value));
		END IF;
			
	END LOOP;
	
	--return the response string
	RETURN string_res;
END;

$$ LANGUAGE plpgsql;


--SELECT FUNC_CK('abzde');

--SELECT ASCII('z');
			
--SELECT regexp_matches('abç', '@[a-z]', 'i');