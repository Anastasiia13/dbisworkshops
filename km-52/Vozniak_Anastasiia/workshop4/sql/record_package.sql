CREATE OR REPLACE PACKAGE record_package AS
type record_table is record(
    rec_date RECORD.CONSULT_DATE%type,
    u_email_t consultation.USER_EMAIL_FK%type,
    cons_subject consultation.SUBJECT_NAME_FK%TYPE,
    cons_class consultation.CLASSROOM_NUMBER_FK%type,
    cons_building consultation.CLASSROOM_BUILDING_FK%type);
    
    FUNCTION get_records(
    u_email_s IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED;

    PROCEDURE add_record(
    u_email_s IN record.USER_EMAIL_FK%type,
    cons_id IN record.CONSULTATION_ID_FK%type,
    rec_date IN record.CONSULT_DATE%type,
    rec_id in record.RECORD_ID%type
    );

    PROCEDURE del_rec (
         rec_id in record.RECORD_ID%type
    );

    PROCEDURE update_record (
    rec_id in record.RECORD_ID%type,
    rec_date IN record.CONSULT_DATE%type
    );
    
end record_package;

   
CREATE OR REPLACE PACKAGE BODY record_package AS
    
    FUNCTION get_records(
    u_email_s IN RECORD.USER_EMAIL_FK%type) 
    RETURN record_table
    PIPELINED
        is
        create table consult_id as select CONSULTATION_ID_FK from RECORD
        where RECORD.USER_EMAIL_FK = u_email_s;
        cursor rec_cur is 
        select distinct
        RECORD.CONSULT_DATE,
        consultation.USER_EMAIL_FK,
        consultation.SUBJECT_NAME_FK,
        consultation.CLASSROOM_NUMBER_FK,
        consultation.CLASSROOM_BUILDING_FK
        from record inner join consult_id on 
        record.CONSULTATION_ID_FK=consult_id.CONSULTATION_ID_FK
        inner join consultation on record.CONSULTATION_ID_FK=consultation.CONSULTATION_ID;
        
        begin
        for cur in rec_cur
        loop
            pipe row(cur);
        end loop;
end get_records;
    
PROCEDURE add_record(
    PROCEDURE add_record(
    u_email_s IN record.USER_EMAIL_FK%type,
    cons_id IN record.CONSULTATION_ID_FK%type,
    rec_date IN record.CONSULT_DATE%type,
    rec_id in record.RECORD_ID%type
    ) is
    
    begin
    insert into record(
    USER_EMAIL_FK,
    CONSULTATION_ID_FK,
    CONSULT_DATE,
    RECORD_ID
    ) values(
    u_email_s,
    cons_id,
    rec_date,
    rec_id 
    );
end add_record;
    
PROCEDURE del_rec(
        rec_id in record.RECORD_ID%type
    )is
    begin
        delete from record
        where record_id = rec_id;
end del_rec;

PROCEDURE update_record(
    rec_id in record.RECORD_ID%type,
    rec_date IN record.CONSULT_DATE%type
    ) IS BEGIN
    UPDATE record
        SET
    CONSULT_DATE=rec_date
    WHERE
        RECORD_ID= rec_id;
END update_record; 

end record_package;    