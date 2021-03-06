create or replace PACKAGE consultation_package AS
type cons_list is record(
    cons_subject consultation.SUBJECT_NAME_FK%TYPE,
    cons_class consultation.CLASSROOM_NUMBER_FK%type,
    cons_building consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin consultation.CONSULTATION_BEGIN%type,
    cons_end consultation.CONSULTATION_END%type
);

type consult_list is table of cons_list;
    FUNCTION get_cons_list(u_email IN consultation.USER_EMAIL_FK%type) 
    RETURN consult_list
    PIPELINED;

    PROCEDURE add_cons(
    u_email IN consultation.USER_EMAIL_FK%type,
    cons_subject IN consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type
    );
    PROCEDURE del_cons (
        cons_id IN consultation.CONSULTATION_ID%type
    );
    PROCEDURE update_consult (
    cons_subject consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type,
    cons_id consultation.CONSULTATION_ID%type
    );

end consultation_package;
/
create or replace PACKAGE BODY consultation_package IS
    FUNCTION get_cons_list(u_email IN consultation.USER_EMAIL_FK%type) 
    RETURN consult_list
    PIPELINED
        is
        cursor cons_cur is 
        select consultation.SUBJECT_NAME_FK,
        consultation.CLASSROOM_NUMBER_FK,
        consultation.CLASSROOM_BUILDING_FK,
        consultation.CONSULTATION_BEGIN,
        consultation.CONSULTATION_END
        from consultation
        where user_email_fk=u_email;
        begin
        for cur in cons_cur
        loop
            pipe row(cur);
        end loop;
end get_cons_list;

PROCEDURE add_cons(
    u_email IN consultation.USER_EMAIL_FK%type,
    cons_subject IN consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type
    )  is
cons_id integer;
    begin
    select max (consultation_id) into cons_id
    from consultation;
    insert into consultation(
    USER_EMAIL_FK,
    SUBJECT_NAME_FK,
    CLASSROOM_NUMBER_FK,
    CLASSROOM_BUILDING_FK,
    CONSULTATION_BEGIN,
    CONSULTATION_END,
    CONSULTATION_ID
    ) values(
    u_email,
    cons_subject,
    cons_class,
    cons_building,
    cons_begin,
    cons_end,
    cons_id+1
    );
end add_cons;

PROCEDURE del_cons (
        cons_id IN consultation.CONSULTATION_ID%type
    )is
    begin
        delete from consultation
        where consultation_id = cons_id;
end del_cons;

PROCEDURE update_consult(
    cons_subject consultation.SUBJECT_NAME_FK%TYPE,
    cons_class IN consultation.CLASSROOM_NUMBER_FK%type,
    cons_building IN consultation.CLASSROOM_BUILDING_FK%type,
    cons_begin IN consultation.CONSULTATION_BEGIN%type,
    cons_end IN consultation.CONSULTATION_END%type,
    cons_id consultation.CONSULTATION_ID%type
    ) IS BEGIN
    UPDATE consultation
        SET
            SUBJECT_NAME_FK = cons_subject,
            CLASSROOM_NUMBER_FK = cons_class,
            CLASSROOM_BUILDING_FK = cons_building,
            CONSULTATION_BEGIN = cons_begin,
            CONSULTATION_END = cons_end 
    WHERE
        consultation_id = cons_id;
END update_consult; 
end consultation_package;  
  
/

