CREATE OR REPLACE PACKAGE USER_PACKAGE AS

    TYPE T_USER IS RECORD (
    u_role "USER".user_role_fk%type,
   	u_name "USER".user_name%type,
    u_mid_name "USER".middle_name%type,
    u_surname "USER".user_surname%type,
    u_email "USER".user_email%type,
	u_password "USER".user_password%type
    );
    
    TYPE USER_TABLE IS 
    	TABLE OF T_USER;
        
    FUNCTION LOG_IN(u_email IN "USER".user_email%type,
	user_password IN "USER".user_password%type)
    	RETURN USER_TABLE PIPELINED;
        
  PROCEDURE REGISTER(u_role IN "USER".user_role_fk%type,
   	u_name IN "USER".user_name%type,
    u_mid_name IN "USER".middle_name%type,
    u_surname IN "USER".user_surname%type,
    u_email IN "USER".user_email%type,
	u_password IN "USER".user_password%type);
    
    
    PROCEDURE del_user(
        u_email IN "USER".user_email%type);
        
    PROCEDURE update_user(
   	u_name "USER".user_name%type,
    u_mid_name "USER".middle_name%type,
    u_surname "USER".user_surname%type,
    u_email "USER".user_email%type
    );    
END;

CREATE OR REPLACE PACKAGE BODY USER_PACKAGE AS
    FUNCTION LOG_IN(u_email IN "USER".user_email%type,
	u_password IN "USER".user_password%type)
    RETURN USER_TABLE PIPELINED AS
    CURSOR CUR IS
      SELECT *
      FROM "USER"
      WHERE  "USER".user_email = u_email
        AND "USER".user_password = u_password;
    BEGIN
      FOR rec IN CUR
      LOOP
        pipe row (rec);
      end loop;
    END;

  PROCEDURE REGISTER(u_role IN "USER".user_role_fk%type,
   	u_name IN "USER".user_name%type,
    u_mid_name IN "USER".middle_name%type,
    u_surname IN "USER".user_surname%type,
    u_email IN "USER".user_email%type,
	u_password IN "USER".user_password%type) AS
    BEGIN
      INSERT INTO "USER"(
        USER_ROLE_FK,
        USER_NAME,
        MIDDLE_NAME,
        USER_SURNAME,
        USER_EMAIL,
        USER_PASSWORD
    )VALUES (
      u_role,
      u_name,
      u_mid_name,
      u_surname,
      u_email,
      u_password);
    END;
 
PROCEDURE del_user( u_email IN "USER".user_email%type
    )is
    begin
        delete from "USER"
        where user_email = u_email;
end del_user; 

PROCEDURE update_user(
   	u_name "USER".user_name%type,
    u_mid_name "USER".middle_name%type,
    u_surname "USER".user_surname%type,
    u_email "USER".user_email%type
    ) IS BEGIN
    UPDATE "USER"
        SET
        USER_NAME = u_name,
        MIDDLE_NAME = u_mid_name,
        USER_SURNAME = u_surname
    WHERE
        user_email = u_email;
END update_consult; 



END;