CREATE OR REPLACE PACKAGE wishlist_package AS
type wishlist_table is record(
    wish_date wishlist.wish_date%type,
    u_email_t wishlist.USER_EMAIL_t%type,
    wish_subject wishlist.SUBJECT_NAME_FK1%TYPE
    );
    
    FUNCTION get_wish(
    u_email_s IN wishlist.USER_EMAIL_S%type) 
    RETURN wishlist_table
    PIPELINED;

    PROCEDURE add_wish(
    wish_subject IN wishlist.SUBJECT_NAME_FK1%TYPE,
    wish_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    u_email_s IN wishlist.USER_EMAIL_s%type,
    wish_id IN wishlist.wish_id%type
    );

    PROCEDURE del_wish (
         wish_id IN wishlist.wish_id%type
    );

    PROCEDURE update_wish(
    wish_subject IN wishlist.SUBJECT_NAME_FK1%TYPE,
    wish_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    wish_id IN wishlist.wish_id%type
    );
    
end record_package;

   
CREATE OR REPLACE PACKAGE BODY record_package AS
    
    FUNCTION get_wish(
    u_email_s IN wishlist.USER_EMAIL_S%type) 
    RETURN wishlist_table
    PIPELINED
        is
        cursor wish_cur is 
        select *
        from wishlist 
        where wishlist.USER_EMAIL_S= u_email_s;
        
        begin
        for cur in wish_cur
        loop
            pipe row(cur);
        end loop;
end get_wish;
    
    PROCEDURE add_wish(
    wish_subject IN wishlist.SUBJECT_NAME_FK1%TYPE,
    wish_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    u_email_s IN wishlist.USER_EMAIL_s%type,
    wish_id IN wishlist.wish_id%type
    ) is
    
    begin
    insert into wishlist(
    SUBJECT_NAME_FK1,
    wish_date,
    USER_EMAIL_t,
    USER_EMAIL_s,
    wish_id
    ) values(
    wish_subject,
    wish_date,
    u_email_t,
    u_email_s,
    wish_id
    );
end add_wish;
    
PROCEDURE del_wish(
       wish_id IN wishlist.wish_id%type
    )is
    begin
        delete from wishlist
        where wish_id = wish_id;
end del_wish;

PROCEDURE update_wish(
    wish_subject IN wishlist.SUBJECT_NAME_FK1%TYPE,
    wish_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    wish_id IN wishlist.wish_id%type
    ) IS BEGIN
    UPDATE record
        SET
    SUBJECT_NAME_FK1 = wish_subject,
    wish_date = wish_date,
    USER_EMAIL_t = u_email_t
    WHERE
        wish_id= wish_id;
END update_wish; 

end wishlist_package;    