create or replace PACKAGE subject_package IS
type subject_table is record(
    subj subject.SUBJECT_NAME%TYPE);
    
type subj_table is table of subject_table;

    FUNCTION get_subjects(u_email IN consultation.USER_EMAIL_FK%type) 
    RETURN subj_table
    PIPELINED;

    FUNCTION add_subject(
    u_email IN consultation.USER_EMAIL_FK%type,
    subj IN subject.SUBJECT_NAME%TYPE
    )return VARCHAR2;

    FUNCTION del_subject (
         subj IN subject.SUBJECT_NAME%TYPE
    )return VARCHAR2;

    FUNCTION update_subject(
    old_subj IN subject.SUBJECT_NAME%TYPE,
    new_subj IN subject.SUBJECT_NAME%TYPE
    )return VARCHAR2;

end subject_package;
/   
create or replace PACKAGE BODY subject_package IS
    FUNCTION get_subjects(u_email IN consultation.USER_EMAIL_FK%type) 
    RETURN subj_table
    PIPELINED
    IS
    TYPE subj_cursor_type IS REF CURSOR;
       subj_cursor subj_cursor_type;
        cursor_data subject_table;
        query_str VARCHAR2(1000);
    BEGIN
        query_str:= 'SELECT * from subject';
    
        OPEN subj_cursor FOR query_str;
        
        LOOP
            FETCH subj_cursor INTO cursor_data;
            EXIT WHEN (subj_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;
    END get_subjects;

    FUNCTION add_subject(
    u_email IN consultation.USER_EMAIL_FK%type,
    subj IN subject.SUBJECT_NAME%TYPE
    )return VARCHAR2 is
    s_count integer;
    subj_count_ex exception;
    subj_is_ex exception;
    message VARCHAR2(150);
    u_role users.USER_ROLE_FK%type;
    role_ex exception;
    subj_name_ex exception;
    begin
    
    select count(SUBJECT_NAME) into s_count
    from subject where SUBJECT_NAME=subj; 
    
    select USER_ROLE_FK into u_role from users where USER_EMAIL=u_email;
    message:='ok';  
    if s_count=1 then
        raise subj_count_ex;
    end if;
    if u_role!='Викладач' then
        raise role_ex;
    end if; 
    if not REGEXP_LIKE (subj, '^[-0-9a-zA-ZА-Яа-яЇїіІЙй\s]') then
        raise subj_name_ex;
    end if;
    
    insert into subject(SUBJECT_NAME) values(subj);
    COMMIT;
    return message;
     exception
        when role_ex then
            message:='Тільки викладач може додати предмет (тему)';
            return message;
        when subj_count_ex then
            message:='Такий предмет(тема) вже існує';
            return message;   
        when subj_name_ex then
            message:='Невалідна назва';
            return message; 
    end add_subject;
    

    FUNCTION del_subject (
         subj IN subject.SUBJECT_NAME%TYPE
    )return VARCHAR2 is
    cons_count integer;
    cons_count_ex exception;
    message VARCHAR2(150);
    subj_is_ex exception;
    s_count integer;
    begin
    select count(SUBJECT_NAME) into s_count
    from subject where SUBJECT_NAME=subj;
    select count(SUBJECT_NAME_FK) into cons_count
    from consultation where SUBJECT_NAME_FK=subj;
    if cons_count!=0 then
        raise cons_count_ex;
    end if;
    if s_count=0 then
        raise subj_is_ex;
    end if;
        delete from subject
        where SUBJECT_NAME =subj;
    COMMIT;
    return message;
        exception
        when cons_count_ex then
            message:='Ви не можете видалити цей предмет (тему)';
        return message;
        when subj_is_ex then
            message:='Такий предмет(тема) не існує';
            return message;   
    end del_subject;
    

    FUNCTION update_subject(
    old_subj IN subject.SUBJECT_NAME%TYPE,
    new_subj IN subject.SUBJECT_NAME%TYPE
    )return VARCHAR2
    IS message VARCHAR2(150);
    subj_is_ex exception;
    subj_name_ex exception;
    s_count integer;
    cons_count integer;
    cons_count_ex exception;
    BEGIN
    select count(SUBJECT_NAME) into s_count 
    from subject where SUBJECT_NAME=old_subj;
    select count(SUBJECT_NAME_FK) into cons_count
    from consultation where SUBJECT_NAME_FK=old_subj;
    message:='ok';
    if s_count=0 then
        raise subj_is_ex;
    end if;
    if not REGEXP_LIKE (new_subj, '^[-0-9a-zA-ZА-Яа-яЇїіІЙй\s]') then
        raise subj_name_ex;
    end if;
    if cons_count=0 then
    UPDATE subject
        SET
    SUBJECT_NAME = new_subj
    WHERE
        SUBJECT_NAME = old_subj;
    COMMIT;
        return message;
    else raise cons_count_ex;
    end if;
    exception
        when cons_count_ex then
            message:='Ви не можете змінити назву';
        return message;
         when subj_is_ex then
            message:='Цього предмету (теми) не існує';
        return message;
        when subj_name_ex then
            message:='Невалідна назва';
            return message;         
    end update_subject;

end subject_package;  

/

