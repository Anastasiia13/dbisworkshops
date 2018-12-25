create or replace PACKAGE record_package IS
type rec_table is record(
    rec_date RECORD.CONSULT_DATE%type,
    u_email_t consultation.USER_EMAIL_FK%type,
    cons_subject consultation.SUBJECT_NAME_FK%TYPE,
    cons_class consultation.CLASSROOM_NUMBER_FK%type,
    cons_building consultation.CLASSROOM_BUILDING_FK%type);
type record_table is table of rec_table;

    FUNCTION get_records(
    u_email_s IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED;

    PROCEDURE add_record(
    u_email_s IN record.USER_EMAIL_FK%type,
    cons_id IN record.CONSULTATION_ID_FK%type,
    rec_date IN record.CONSULT_DATE%type
    );

    PROCEDURE del_rec (
         rec_id in record.RECORD_ID%type
    );

    PROCEDURE update_record (
    rec_id in record.RECORD_ID%type,
    rec_date IN record.CONSULT_DATE%type
    );

end record_package;
/   
create or replace PACKAGE BODY record_package IS
    FUNCTION get_records(
    u_email_s IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED
        is
        cursor rec_cur is 
        select 
        record.consult_date,
        consultation.user_email_fk,
        SUBJECT_NAME_FK,
        CLASSROOM_NUMBER_FK,
        CLASSROOM_BUILDING_FK
        from record
        inner join consultation
        on RECORD.USER_EMAIL_FK = u_email_s
        and consultation.CONSULTATION_ID=record.CONSULTATION_ID_FK;

        begin
        for cur in rec_cur
        loop
            pipe row(cur);
        end loop;
    end get_records;

    PROCEDURE add_record(
    u_email_s IN record.USER_EMAIL_FK%type,
    cons_id IN record.CONSULTATION_ID_FK%type,
    rec_date IN record.CONSULT_DATE%type
    )is
    rec_id integer;
    begin
    select max(record_id) into rec_id
    from record;
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
    end add_record;

    PROCEDURE del_rec (
         rec_id in record.RECORD_ID%type
    ) is
        begin
        delete from record
        where record_id =rec_id;

    end del_rec;

    PROCEDURE update_record (
    rec_id in record.RECORD_ID%type,
    rec_date IN record.CONSULT_DATE%type
    )
    IS BEGIN
    UPDATE record
        SET
    CONSULT_DATE = rec_date
    WHERE
        record_id= rec_id;
    end update_record;

end record_package;  

/

