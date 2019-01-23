SET SERVEROUTPUT ON

DECLARE
    result   VARCHAR2(150);
BEGIN
    result :=record_package.get_records('ivanov@mail.com');
    dbms_output.put_line(result);
END;

ALTER SESSION SET nls_date_format = 'DD-MM-YYYY HH24:MI'; 
--переглянути записи на консультацію

SELECT
    *
FROM
    TABLE ( record_package.get_records('ivanov@mail.com') );

SELECT
    *
FROM
    TABLE ( record_package.add_record('ivanov@mail.com', '1003', '02-12-2018 12:30') );

SELECT
    *
FROM
    TABLE ( record_package.update_record('2006', '05-12-2018 14:30') );

EXEC record_package.del_rec('2003');

SELECT
    *
FROM
    TABLE ( subject_package.get_subjects('ivanov@mail.com') );

 subject_package.add_subject('boris_1@gmail.com', 'Нелінійний аналіз');

 subject_package.update_subject('Нелінійний аналіз', 'Нелінійний');

 subject_package.del_subject('Нелінійний');

user_package.add_user('Студент', 'Петро', 'Петрович', 'Петров', 'petrov@gmail.com', '123456');

user_package.is_user('petrov@gmail.com', '123456');

user_package.update_user('Петро', 'Петрович', 'Боровий', 'petrov@gmail.com', '1111');

EXEC user_package.del_user('petrov@gmail.com');

--переглянути консультації викладача

SELECT
    *
FROM
    TABLE ( consultation_package.get_cons_list('boris_1@gmail.com') );

EXEC consultation_package.add_cons('boris_1@gmail.com', 'АСД', '505', '12', '28-12-2018 09:30', '28-12-2018 11:30');

EXEC consultation_package.update_consult('АСД', '505', '12', '28-12-2018 10:00', '28-12-2018 11:30', '1006');

EXEC consultation_package.del_cons('1006');

wishlist_package.init;
--переглянути список побажань

SELECT
    *
FROM
    TABLE ( wishlist_package.get_wish('fed123@gmail.com') );

EXEC wishlist_package.add_wish('Вища математика', '28-12-2018 11:30', 'boris_1@gmail.com', 'ivanov@mail.com');

wishlist_package.update_wish('Вища математика', '27-12-2018 12:30', 'boris_1@gmail.com', '5');

EXEC
    wishlist_package.del_wish('5');
/