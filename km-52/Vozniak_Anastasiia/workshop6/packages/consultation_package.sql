ALTER SESSION SET nls_date_format = 'DD-MM-YYYY HH24:MI'; 
create or replace PACKAGE consultation_package AS
type cons_list is record(
    cons_subject consultation.SUBJECT_NAME_FK%TYPE,
    cons_class consultation.CLASSROOM_NUMBER_FK%type,
    cons_building consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin consultation.CONSULTATION_BEGIN%type,
    cons_end consultation.CONSULTATION_END%type,
    cons_id consultation.CONSULTATION_id%type
);

type consult_list is table of cons_list;

    FUNCTION get_cons_list(u_email IN consultation.USER_EMAIL_FK%type) 
    RETURN consult_list
    PIPELINED;
    

    FUNCTION add_consult(
    u_email IN consultation.USER_EMAIL_FK%type,
    cons_subject IN consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type
    )RETURN VARCHAR2;
    
    FUNCTION del_cons (
        cons_id IN consultation.CONSULTATION_ID%type
    )return VARCHAR2;
    
    function update_consult (
    cons_subject IN consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type,
    cons_id IN consultation.CONSULTATION_ID%type
    ) return varchar2;

end consultation_package;
/
create or replace PACKAGE BODY consultation_package IS
    FUNCTION get_cons_list(u_email IN consultation.USER_EMAIL_FK%type) 
    RETURN consult_list
    PIPELINED
        is
        TYPE cons_cursor_type IS REF CURSOR;
       cons_cursor cons_cursor_type;
        cursor_data cons_list;
        query_str VARCHAR2(1000);
    BEGIN
        query_str:= '
        select consultation.SUBJECT_NAME_FK,
        consultation.CLASSROOM_NUMBER_FK,
        consultation.CLASSROOM_BUILDING_FK,
        consultation.CONSULTATION_BEGIN,
        consultation.CONSULTATION_END,
        consultation.CONSULTATION_ID
        from consultation ';
        if u_email is not NULL then
            query_str:= query_str||' where TRIM(consultation.USER_EMAIL_FK) = trim('''||u_email||''')';
        end if;
        OPEN cons_cursor FOR query_str;
        
        LOOP
            FETCH cons_cursor INTO cursor_data;
            EXIT WHEN ( cons_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;
end get_cons_list;

    FUNCTION add_consult(
    u_email IN consultation.USER_EMAIL_FK%type,
    cons_subject IN consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type
    )RETURN VARCHAR2 is
    cons_id number;
    message VARCHAR2(150);
    date_ex exception;
    role_ex exception;
    subject_ex exception;
    building_ex exception;
    class_ex exception;
    c_begin date;
    is_subj integer;
    u_role users.USER_ROLE_FK%type;
    begin
    
   SELECT TO_date(SYSDATE, 'DD-MM-YYYY HH24:MI') into c_begin FROM DUAL;
   
    select USER_ROLE_FK into u_role from users 
    where USER_EMAIL=u_email;
    
    select count(subject_name) into is_subj 
    from subject where subject_name=cons_subject;
    
    select max (consultation_id) into cons_id
    from consultation;
    
    message:='ok'; 
    if u_role!='Викладач' then
        raise role_ex;
    end if;
    
    if cons_begin<c_begin then
        raise date_ex;
    end if;
    
    if not REGEXP_LIKE(cons_subject,'^[-0-9a-zA-ZА-Яа-яЇїіІЙй\s]') then
            raise subject_ex;
    end if;
    
    if cons_building<=0 or cons_building>40 then
            raise building_ex;
    end if;
    
    if not REGEXP_LIKE(cons_class,'^[0-9]{1,3}[а-я]{0,1}') then
            raise class_ex;
    end if;
    if is_subj=0 then
        raise subject_ex;
    end if;
    
    insert into consultation(
    USER_EMAIL_FK,
    SUBJECT_NAME_FK,
    CLASSROOM_NUMBER_FK,
    CLASSROOM_BUILDING_FK,
    CONSULTATION_BEGIN,
    CONSULTATION_END,
    consultation.consultation_id
    
    ) values(
    u_email,
    cons_subject,
    cons_class,
    cons_building,
    cons_begin,
    cons_end,
    cons_id+1
    );
    
    commit;
    return message;
     exception
        when role_ex then
            message:='Тільки викладач може створити консультацію';
            return message;
        when date_ex then
            message:='Невірна дата';
            return message;
        when subject_ex then
            message:='Невірно введений предмет';
            return message;
         when building_ex then
            message:='Невірно введений корпус';
            return message;  
         when class_ex then
            message:='Невірно введена аудиторія';
            return message;    
end add_consult;

 FUNCTION del_cons(
    cons_id IN consultation.CONSULTATION_ID%type
    )return varchar2 is
    message varchar2(150);
    rec_count integer;
    record_ex exception;
    u_role users.user_role_fk%type;
    u_email users.user_email%type;
    
    begin
    message:='ok';
    
    select USER_EMAIL_FK into u_email
    from consultation where consultation_id = cons_id;
    
    select user_role_fk into u_role
    from users where user_email=u_email;
    
    select count(record_id) into rec_count
    from record where consultation_id_fk = cons_id;
    if u_role!='Викладач' then
         raise record_ex;
    end if;
    if rec_count>0 then
        raise record_ex;
    end if;
        delete from consultation
        where consultation_id = cons_id;
        commit;
        return message;
    exception 
    when record_ex then
        message:='Ви не можете видалити консультацію';
        return message;
end del_cons;

    function update_consult (
    cons_subject IN consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type,
    cons_id IN consultation.CONSULTATION_ID%type
    ) return varchar2 IS 
    message VARCHAR2(150);
    date_ex exception;
    subject_ex exception;
    building_ex exception;
    class_ex exception;
    c_begin date;
    is_subj integer;
    BEGIN
    SELECT TO_date(SYSDATE, 'DD-MM-YYYY HH24:MI') into c_begin FROM DUAL;
    
    select count(subject_name) into is_subj 
    from subject where subject_name=cons_subject;
     message:='ok'; 
    
    if cons_begin<c_begin then
        raise date_ex;
    end if;
    
    if not REGEXP_LIKE(cons_subject,'^[-0-9a-zA-ZА-Яа-яЇїіІЙй\s]') then
            raise subject_ex;
    end if;
    
    if cons_building<=0 or cons_building>40 then
            raise building_ex;
    end if;
    
    if not REGEXP_LIKE(cons_class,'^[0-9]{1,3}[а-я]{0,1}') then
            raise class_ex;
    end if;
    if is_subj=0 then
        raise subject_ex;
    end if;
    UPDATE consultation
        SET
            SUBJECT_NAME_FK = cons_subject,
            CLASSROOM_NUMBER_FK = cons_class,
            CLASSROOM_BUILDING_FK = cons_building,
            CONSULTATION_BEGIN = cons_begin,
            CONSULTATION_END = cons_end 
    WHERE
        consultation_id = cons_id;
         commit;
    return message;
     exception
        when date_ex then
            message:='Невірна дата';
            return message;
        when subject_ex then
            message:='Невірно введений предмет';
            return message;
         when building_ex then
            message:='Невірно введений корпус';
            return message;  
         when class_ex then
            message:='Невірно введена аудиторія';
            return message; 
END update_consult; 
end consultation_package;  
  
/

