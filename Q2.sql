-- creating the new table for testing the function created in the last question
DROP TABLE IF EXISTS USERS CASCADE;

CREATE TABLE IF NOT EXISTS USERS (
    USER_ID INTEGER NOT NULL,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_PASSWD CHAR(8)
);

ALTER TABLE USERS ADD CONSTRAINT PK_USERS PRIMARY KEY (USER_ID);
ALTER TABLE USERS ADD CONSTRAINT UK_USER_NAME UNIQUE (USER_NAME);
ALTER TABLE USERS ADD CONSTRAINT CK_PASSWD CHECK (CHAR_LENGTH(USER_PASSWD) >= 2);
ALTER TABLE USERS ADD CONSTRAINT CK_USERNM CHECK (CHAR_LENGTH(USER_NAME) >= 2);

INSERT INTO USERS (SELECT EMPLOYEE_ID, LOWER(EMAIL), NULL 
				   FROM EMPLOYEES);

-- actually appling the function
UPDATE USERS SET USER_PASSWD = FUNC_CK(USER_NAME);