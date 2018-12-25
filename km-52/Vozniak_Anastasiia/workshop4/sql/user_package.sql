CREATE OR REPLACE PACKAGE USER_PACKAGE AS

    TYPE T_USER IS RECORD (
    u_role USERs.user_role_fk%type,
   	u_name USERs.user_name%type,
    u_mid_name USERs.middle_name%type,
    u_surname USERs.user_surname%type,
    u_email USERs.user_email%type
    );
    
    TYPE USER_TABLE IS 
    	TABLE OF T_USER;
        
    FUNCTION LOGIN(u_email IN users.user_email%type,
	u_password IN users.user_password%type)
    	RETURN USER_TABLE PIPELINED;
        
  PROCEDURE REGISTER(u_role IN users.user_role_fk%type,
   	u_name IN users.user_name%type,
    u_mid_name IN users.middle_name%type,
    u_surname IN users.user_surname%type,
    u_email IN users.user_email%type,
	u_password IN users.user_password%type);
    
    
    PROCEDURE del_user(
        u_email IN users.user_email%type);
        
    PROCEDURE update_user(
   	u_name users.user_name%type,
    u_mid_name users.middle_name%type,
    u_surname users.user_surname%type,
    u_email users.user_email%type
    );    
END;
/
CREATE OR REPLACE PACKAGE BODY USER_PACKAGE AS
    FUNCTION LOGIN(u_email IN users.user_email%type,
	u_password IN users.user_password%type)
    	RETURN USER_TABLE PIPELINED
        is
     email_num integer;
        cursor us_cur is 
        select user_role_fk,
   	user_name,
    middle_name,
    user_surname,
   user_email
      FROM users
      WHERE  users.user_email = u_email
        AND users.user_password = u_password;
    BEGIN
        select count(user_email) into email_num
        FROM users
      WHERE  users.user_email = u_email
        AND users.user_password = u_password;
    if email_num=1 then
      FOR cur IN us_cur
      LOOP
        pipe row (cur);
      end loop;
       DBMS_OUTPUT.put_line('Successfully logged in');
      else DBMS_OUTPUT.put_line('You are not signed on yet. Please, sign on');
      end if;
END login;

  PROCEDURE REGISTER(u_role IN users.user_role_fk%type,
   	u_name IN users.user_name%type,
    u_mid_name IN users.middle_name%type,
    u_surname IN users.user_surname%type,
    u_email IN users.user_email%type,
	u_password IN users.user_password%type) AS
    BEGIN
      INSERT INTO users(
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
 
PROCEDURE del_user( u_email IN users.user_email%type
    )is
    begin
        delete from users
        where user_email = u_email;
end del_user; 

PROCEDURE update_user(
   	u_name users.user_name%type,
    u_mid_name users.middle_name%type,
    u_surname users.user_surname%type,
    u_email users.user_email%type
    ) IS BEGIN
    UPDATE users
        SET
        USER_NAME = u_name,
        MIDDLE_NAME = u_mid_name,
        USER_SURNAME = u_surname
    WHERE
        user_email = u_email;
END update_user; 



END;
/
