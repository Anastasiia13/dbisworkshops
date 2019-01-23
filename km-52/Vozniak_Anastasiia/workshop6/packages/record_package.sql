ALTER SESSION SET nls_date_format = 'DD-MM-YYYY HH24:MI'; 
create or replace PACKAGE record_package IS
type rec_table is record(
    cons_subject consultation.SUBJECT_NAME_FK%TYPE,
    teacher_name users.USER_NAME%type, 
    teacher_mid_name users.MIDDLE_NAME%type, 
    teacher_surname users.USER_SURNAME%type,
    rec_date RECORD.CONSULT_DATE%type,
    cons_class consultation.CLASSROOM_NUMBER_FK%type,
    cons_building consultation.CLASSROOM_BUILDING_FK%type,
    cons_id consultation.CONSULTATION_ID%type,
    rec_id record.RECORD_ID%type);
type record_table is table of rec_table;

    FUNCTION get_records(
    u_email_s IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED;
    FUNCTION get_all_records(
    u_email_t IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED;
    FUNCTION add_record(
    u_email_s IN record.USER_EMAIL_FK%type,
    cons_id IN record.CONSULTATION_ID_FK%type,
    rec_date IN record.CONSULT_DATE%type
    )return VARCHAR2;

    PROCEDURE del_rec (
         rec_id in record.RECORD_ID%type
    );

    FUNCTION update_record (
    rec_id in record.RECORD_ID%type,
    rec_date IN record.CONSULT_DATE%type
    )return VARCHAR2;

end record_package;
/   
create or replace PACKAGE BODY record_package IS
    FUNCTION get_records(
    u_email_s IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED
    IS
    TYPE record_cursor_type IS REF CURSOR;
       record_cursor record_cursor_type;
        cursor_data rec_table;
        query_str VARCHAR2(1000);
    BEGIN
        query_str:= '
        SELECT 
        consultation.SUBJECT_NAME_FK Subject, 
        users.USER_NAME,users.MIDDLE_NAME,users.USER_SURNAME,
        RECORD.CONSULT_DATE, 
        consultation.CLASSROOM_NUMBER_FK,
        consultation.CLASSROOM_BUILDING_FK,
        consultation.CONSULTATION_ID,
        record.RECORD_ID
        FROM record inner join consultation 
        on record.CONSULTATION_ID_FK=consultation.CONSULTATION_ID
        join users on consultation.USER_EMAIL_FK=users.USER_EMAIL';
        
        if u_email_s  is not NULL then
            query_str:= query_str||' where TRIM(RECORD.USER_EMAIL_FK) = trim('''||u_email_s||''')';
        end if;
        OPEN record_cursor FOR query_str;
        
        LOOP
            FETCH record_cursor INTO cursor_data;
            EXIT WHEN ( record_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;
    END get_records;
    
    
   FUNCTION get_all_records(
    u_email_t IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED
    IS
    TYPE record_cursor_type IS REF CURSOR;
       record_cursor record_cursor_type;
        cursor_data rec_table;
        query_str VARCHAR2(1000);
    BEGIN
        query_str:= '
        SELECT 
        consultation.SUBJECT_NAME_FK Subject, 
        users.USER_NAME,users.MIDDLE_NAME,users.USER_SURNAME PIB,
        RECORD.CONSULT_DATE, 
        consultation.CLASSROOM_NUMBER_FK,
        consultation.CLASSROOM_BUILDING_FK,
        consultation.CONSULTATION_ID,
        record.RECORD_ID
        FROM record inner join consultation 
        on record.CONSULTATION_ID_FK=consultation.CONSULTATION_ID
        join users on record.USER_EMAIL_FK=users.USER_EMAIL';
        
        if u_email_t  is not NULL then
            query_str:= query_str||' where TRIM(consultation.USER_EMAIL_FK) = trim('''||u_email_t||''')';
        end if;
        OPEN record_cursor FOR query_str;
        
        LOOP
            FETCH record_cursor INTO cursor_data;
            EXIT WHEN ( record_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;
    END get_all_records;
    
    
    FUNCTION add_record(
    u_email_s IN record.USER_EMAIL_FK%type,
    cons_id IN record.CONSULTATION_ID_FK%type,
    rec_date IN record.CONSULT_DATE%type
    )return VARCHAR2 is
    message VARCHAR2(150);
    rec_id integer;
    c_begin date;
    c_end date;
    u_role users.USER_ROLE_FK%type;
    c_count integer;
    date_ex exception;
    count_ex exception;
    role_ex exception;
    begin
    select CONSULTATION_END into c_END
    from consultation where CONSULTATION_ID=cons_id;
    
    select CONSULTATION_BEGIN into c_begin
    from consultation where CONSULTATION_ID=cons_id;
    
    select count(cons_id) into c_count
    from record where CONSULTATION_ID_FK=cons_id and
    USER_EMAIL_FK=u_email_s;
    
    select max(record_id) into rec_id
    from record;
    
    select USER_ROLE_FK into u_role from users where USER_EMAIL=u_email_s;
    message:='ok';  
    if u_role!='Студент' then
        raise role_ex;
    end if;
    if  rec_date<c_begin or rec_date>c_end  then
        raise date_ex;
    end if;
    if c_count>=1 then
        raise count_ex;
    end if;
    
    insert into record(
    USER_EMAIL_FK,
    CONSULTATION_ID_FK,
    CONSULT_DATE,
    RECORD_ID
    ) values(
   u_email_s,
   cons_id,
   rec_date,
   rec_id+1
    );
    COMMIT;
    return message;
     exception
        when role_ex then
            message:='Тільки студент може записатись на консультацію';
            return message;
        when date_ex then
            message:='Невірна дата';
            return message;
        when count_ex then
            message:='Ви вже записані на цю консультацію';
            return message;
    end add_record;

    PROCEDURE del_rec (
         rec_id in record.RECORD_ID%type
    ) is
        begin
        delete from record
        where record_id =rec_id;
    COMMIT;
    end del_rec;

    FUNCTION update_record(
    rec_id in record.RECORD_ID%type,
    rec_date IN record.CONSULT_DATE%type
    )return VARCHAR2 
    IS message VARCHAR2(30);
    date_ex exception;
    c_begin date;
    c_end date;
    cons_id record.CONSULTATION_ID_FK%type;
    BEGIN
    select CONSULTATION_ID_fk into cons_id from record
    where RECORD_ID=rec_id;
    
    select CONSULTATION_END into c_END
    from consultation where CONSULTATION_ID=cons_id;
    
    select CONSULTATION_BEGIN into c_begin
    from consultation where CONSULTATION_ID=cons_id;
    message:='ok';
    if  rec_date<c_begin or rec_date>c_end  then
        raise date_ex;
    end if;
    UPDATE record
        SET
    CONSULT_DATE = rec_date
    WHERE
        record_id= rec_id;
    COMMIT;
        return message;
    exception
        when date_ex then
            message:='invalid date';
        return message;
    end update_record;

end record_package;  

/

