create or replace PACKAGE wishlist_package IS
type wishlist_table is record(
    w_date wishlist.wish_date%type,
    u_email_t wishlist.USER_EMAIL_t%type,
    wish_subject wishlist.SUBJECT_NAME_FK1%TYPE
    );

    type wish_table is table of wishlist_table;
    FUNCTION get_wish(
    u_email_s IN wishlist.USER_EMAIL_S%type) 
    RETURN wish_table
    PIPELINED;

    PROCEDURE add_wish(
    wish_subject IN wishlist.SUBJECT_NAME_FK1%TYPE,
    w_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    u_email_s IN wishlist.USER_EMAIL_s%type
    );

    PROCEDURE del_wish (
         w_id IN wishlist.wish_id%type
    );

    PROCEDURE update_wish(
    wish_subject IN wishlist.SUBJECT_NAME_FK1%TYPE,
    w_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    w_id IN integer
    );

end wishlist_package;
/
ALTER SESSION SET nls_date_format = 'DD-MM-YYYY HH24:MI'; 
create or replace PACKAGE BODY wishlist_package IS
    
    FUNCTION get_wish(
    u_email_s IN wishlist.USER_EMAIL_S%type) 
    RETURN wish_table
    PIPELINED
        is
        cursor wish_cur is 
        select   wishlist.wish_date,
    wishlist.USER_EMAIL_t,
    wishlist.SUBJECT_NAME_FK1
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
    w_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    u_email_s IN wishlist.USER_EMAIL_s%type
    ) is w_id INTEGER;
    begin
    select max (wish_id) into w_id
    from wishlist;
    insert into wishlist(
    SUBJECT_NAME_FK1,
    wish_date,
    USER_EMAIL_t,
    USER_EMAIL_s,
    wish_id
    ) values(
    wish_subject,
    w_date,
    u_email_t,
    u_email_s,
    w_id+1
    );
end add_wish;

PROCEDURE del_wish(
       w_id IN wishlist.wish_id%type
    )is
    begin
        delete from wishlist
        where wish_id = w_id;
end del_wish;

PROCEDURE update_wish(
    wish_subject IN wishlist.SUBJECT_NAME_FK1%TYPE,
    w_date IN wishlist.wish_date%type,
    u_email_t IN wishlist.USER_EMAIL_t%type,
    w_id IN integer
    ) IS BEGIN
    UPDATE wishlist
        SET
    SUBJECT_NAME_FK1 = wish_subject,
    wish_date = w_date,
    USER_EMAIL_t = u_email_t
    WHERE wish_id= w_id;
    
END update_wish; 

end wishlist_package;    

/
