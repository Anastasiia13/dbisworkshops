CREATE OR REPLACE PACKAGE USER_PACKAGE AS

    TYPE T_USER IS RECORD (
    u_role USERs.user_role_fk%type,
   	u_name USERs.user_name%type,
    u_mid_name USERs.middle_name%type,
    u_surname USERs.user_surname%type,
    u_email USERs.user_email%type
    );
        TYPE Teachers IS RECORD (
   	u_name USERs.user_name%type,
    u_mid_name USERs.middle_name%type,
    u_surname USERs.user_surname%type,
    u_email USERs.user_email%type,
    u_role USERs.user_role_fk%type
    );
    TYPE USER_TABLE IS 
    	TABLE OF T_USER;
         TYPE T_TABLE IS 
    	TABLE OF teachers;   
        
    FUNCTION get_user (u_email IN users.user_email%type DEFAULT NULL
    ) RETURN USER_TABLE
        PIPELINED;
    FUNCTION get_teacher (u_role IN users.user_role_fk%type 
    ) RETURN T_TABLE
        PIPELINED;
    
    FUNCTION is_user(u_email IN users.user_email%type)
    	RETURN integer;
        
    FUNCTION is_pass(u_email IN users.user_email%type,
	u_password IN users.user_password%type)
    	RETURN INTEGER;
        
  FUNCTION add_user(
    u_role IN users.user_role_fk%type,
   	u_name IN users.user_name%type,
    u_mid_name IN users.middle_name%type,
    u_surname IN users.user_surname%type,
    u_email IN users.user_email%type,
	u_password IN users.user_password%type)
    return VARCHAR2;
    
    
    PROCEDURE del_user(
        u_email IN users.user_email%type);
        
    FUNCTION update_user(
   	u_name users.user_name%type,
    u_mid_name users.middle_name%type,
    u_surname users.user_surname%type,
    u_email users.user_email%type,
    u_password IN users.user_password%type
    ) return VARCHAR2;   
       
     FUNCTION get_role (u_email IN users.user_email%type 
    ) RETURN varchar2;
    
    FUNCTION get_name (u_email IN users.user_email%type 
    ) RETURN varchar2;
END USER_PACKAGE;
/
CREATE OR REPLACE PACKAGE BODY USER_PACKAGE IS

    FUNCTION get_user(u_email IN users.user_email%type DEFAULT NULL
    ) RETURN USER_TABLE
        PIPELINED
    IS
        TYPE user_cursor_type IS REF CURSOR;
        user_cursor   user_cursor_type;
        cursor_data   T_USER;
        query_str     VARCHAR2(1000char);
    BEGIN
        query_str := 'select 
            u_role ,
   	u_name ,
    u_mid_name ,
    u_surname ,
    u_email from users';
        IF u_email IS NOT NULL THEN
            query_str := query_str
            || ' where TRIM(users.user_email) = trim('''
            || u_email
            || ''')';
        END IF;

        OPEN user_cursor FOR query_str;

        LOOP
            FETCH user_cursor INTO cursor_data;
            EXIT WHEN ( user_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;

    END get_user;
    
    
    
        FUNCTION get_teacher (u_role IN users.user_role_fk%type
    ) RETURN T_TABLE
        PIPELINED    IS
        TYPE user_cursor_type IS REF CURSOR;
        user_cursor   user_cursor_type;
        cursor_data   teachers;
        query_str     VARCHAR2(1000char);
    BEGIN
        query_str := 'select user_name,
        middle_name,
        user_surname,
        user_email,
        user_role_fk
        from users ';
        if u_role is not NULL then
            query_str:= query_str||' where TRIM(users.USER_role_fk) = trim('''||u_role||''')';
        end if;
        OPEN user_cursor FOR query_str;

        LOOP
            FETCH user_cursor INTO cursor_data;
            EXIT WHEN ( user_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;

    END get_teacher;
    
    FUNCTION is_pass(u_email IN users.user_email%type,
	u_password IN users.user_password%type)
    	RETURN INTEGER IS
        counter   INTEGER;
    BEGIN
        SELECT COUNT(*) INTO
            counter
        FROM
            users
        WHERE
            TRIM(users.user_email) = TRIM(u_email)
            AND   TRIM(users.user_password) = TRIM(u_password);

        RETURN counter;
        end;

    FUNCTION is_user(u_email IN users.user_email%type)
    	RETURN INTEGER IS
        counter   INTEGER;
    BEGIN
        SELECT COUNT(*) INTO
            counter
        FROM
            users
        WHERE
            TRIM(users.user_email) = TRIM(u_email);

        RETURN counter;
END is_user;
    

  FUNCTION add_user(
    u_role IN users.user_role_fk%type,
   	u_name IN users.user_name%type,
    u_mid_name IN users.middle_name%type,
    u_surname IN users.user_surname%type,
    u_email IN users.user_email%type,
	u_password IN users.user_password%type)
    return VARCHAR2
    IS
        message VARCHAR2(150);
        pass_ex EXCEPTION;
        name_ex EXCEPTION;
        surname_ex EXCEPTION;
        mid_name_ex EXCEPTION;
        email_ex EXCEPTION;
        user_is_ex EXCEPTION;
        role_ex exception;
        user_count integer;
    BEGIN
    message:='ok';
    select count(user_email) into user_count
    from users where user_email=u_email;
    
        if not REGEXP_LIKE(u_password,'^[0-9a-zA-Z]{6,20}' ) then
            raise pass_ex;
        end if;
        
        if u_name is not NULL and not REGEXP_LIKE(u_name,'^[ЇІА-Я]{1}[іїа-я]{1,20}' ) then
            raise name_ex;
        end if;
        
        if u_surname is not NULL and not REGEXP_LIKE(u_surname,'^[ЇІА-Я]{1}[іїа-я]{1,20}') then
            raise surname_ex;
        end if;
        
        if u_mid_name is not NULL and not REGEXP_LIKE(u_mid_name,'^[ЇІА-Я]{1}[іїа-я]{1,20}') then
            raise mid_name_ex;
        end if;
        
        if user_count=1 then
            raise user_is_ex;
        end if;
        
        if not REGEXP_LIKE(u_email,'^[A-Z0-9._-]+@[A-Z0-9._-]+\.[A-Z]{2,4}') then
            raise email_ex;
        end if;
        
        if u_role!='Студент' and u_role!='Викладач' then
            raise role_ex;
        end if;
        
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
      commit;
      return message;
      exception
        when pass_ex then
            message:='Невалідний пароль';
            return message;
        when name_ex then
            message:='Невалідне ім`я';
            return message;
        when surname_ex then
            message:='Невалідне прізвище';
            return message;
        when mid_name_ex then
            message:='Невалідне по-батькові';
            return message;
        when email_ex then
            message:='Невалідний email';
            return message;
        when user_is_ex then
            message:='Такий користувач вже існує';
            return message;
        when role_ex then
            message:='Невалідна роль';
            return message;
    END add_user;
 
PROCEDURE del_user( u_email IN users.user_email%type
    )is
    begin
        delete from users
        where user_email = u_email;
        commit;
end del_user; 

FUNCTION update_user(
   	u_name users.user_name%type,
    u_mid_name users.middle_name%type,
    u_surname users.user_surname%type,
    u_email users.user_email%type,
    u_password IN users.user_password%type
    ) return VARCHAR2 IS 
        message VARCHAR2(150);
        pass_ex EXCEPTION;
        name_ex EXCEPTION;
        surname_ex EXCEPTION;
        mid_name_ex EXCEPTION;
    BEGIN
    message:='ok';
            if not REGEXP_LIKE(u_password,'^[0-9a-zA-Z]{6,20}' ) then
            raise pass_ex;
        end if;
        
        if u_name is not NULL and not REGEXP_LIKE(u_name,'^[ЇІА-Я]{1}[іїа-я]{1,20}' ) then
            raise name_ex;
        end if;
        
        if u_surname is not NULL and not REGEXP_LIKE(u_surname,'^[ЇІА-Я]{1}[іїа-я]{1,20}') then
            raise surname_ex;
        end if;
        
        if u_mid_name is not NULL and not REGEXP_LIKE(u_mid_name,'^[ЇІА-Я]{1}[іїа-я]{1,20}') then
            raise mid_name_ex;
        end if;
        
    UPDATE users
        SET
        USER_NAME = u_name,
        MIDDLE_NAME = u_mid_name,
        USER_SURNAME = u_surname,
        USER_PASSWORD = u_password
    WHERE
        user_email = u_email;
        commit;
        return message;
          exception
        when pass_ex then
            message:='Невалідний пароль';
            return message;
        when name_ex then
            message:='Невалідне ім`я';
            return message;
        when surname_ex then
            message:='Невалідне прізвище';
            return message;
        when mid_name_ex then
            message:='Невалідне по-батькові';
            return message;
END update_user; 

FUNCTION get_role (u_email IN users.user_email%type 
    ) RETURN varchar2
    is
    message VARCHAR2(150);
    role varchar2(150);
    user_is_ex EXCEPTION;
    is_us integer;
    begin
    role:='no';
    is_us:=is_user(u_email);
    if is_us=1 then
    select user_role_fk into role from users
    where user_email=u_email;
    return role;
    else raise user_is_ex;
    end if;
    exception
        when user_is_ex then
            message:='Такого користувача не існує';
        return message;
    end get_role;
    
    FUNCTION get_name (u_email IN users.user_email%type 
    ) RETURN varchar2
    is
    message VARCHAR2(150);
    name varchar2(150);
    user_is_ex EXCEPTION;
    is_us integer;
    begin
    name:='no';
    is_us:=is_user(u_email);
    if is_us=1 then
    select user_name into name from users
    where user_email=u_email;
    return name;
    else raise user_is_ex;
    end if;
    exception
        when user_is_ex then
            message:='Такого користувача не існує';
        return message;
    end get_name;


END;
/