    ALTER SESSION SET nls_date_format = 'DD-MM-YYYY HH24:MI';   
      
    Insert into CLASSROOM (CLASSROOM_NUMBER,CLASSROOM_BUILDING) values ('10','30');
Insert into CLASSROOM (CLASSROOM_NUMBER,CLASSROOM_BUILDING) values ('107','10');
Insert into CLASSROOM (CLASSROOM_NUMBER,CLASSROOM_BUILDING) values ('10а','10');
Insert into CLASSROOM (CLASSROOM_NUMBER,CLASSROOM_BUILDING) values ('5','5');
Insert into CLASSROOM (CLASSROOM_NUMBER,CLASSROOM_BUILDING) values ('505','12');
Insert into ROLE (USER_ROLE) values ('Адмін');
Insert into ROLE (USER_ROLE) values ('Викладач');
Insert into ROLE (USER_ROLE) values ('Студент');
Insert into SUBJECT (SUBJECT_NAME) values ('АСД');
Insert into SUBJECT (SUBJECT_NAME) values ('Англійська мова');
Insert into SUBJECT (SUBJECT_NAME) values ('БЖОП');
Insert into SUBJECT (SUBJECT_NAME) values ('Вища математика');
Insert into SUBJECT (SUBJECT_NAME) values ('Математичний аналіз');
Insert into users (USER_ROLE_FK,USER_NAME,USER_SURNAME,USER_EMAIL,USER_PASSWORD,MIDDLE_NAME) values ('Студент','Федір','Федоров','fed123@gmail.com','fedfed','Федорович');
Insert into users (USER_ROLE_FK,USER_NAME,USER_SURNAME,USER_EMAIL,USER_PASSWORD,MIDDLE_NAME) values ('Студент','Іван','Іванов','ivanov@mail.com','ivan111','Іванович');
Insert into users (USER_ROLE_FK,USER_NAME,USER_SURNAME,USER_EMAIL,USER_PASSWORD,MIDDLE_NAME) values ('Викладач','Борис','Борисов','boris_1@gmail.com','123456','Борисович');
Insert into users (USER_ROLE_FK,USER_NAME,USER_SURNAME,USER_EMAIL,USER_PASSWORD,MIDDLE_NAME) values ('Викладач','Сергій','Сергієнко','serg@gmail.com','789456','Сергійович');
Insert into WISHLIST (SUBJECT_NAME_FK1,USER_EMAIL_T,USER_EMAIL_S,WISH_DATE,WISH_ID) values ('Математичний аналіз','serg@gmail.com','fed123@gmail.com',to_date('30-11-2018 14:40','DD-MM-YYYY HH24:MI'),'1');
Insert into WISHLIST (SUBJECT_NAME_FK1,USER_EMAIL_T,USER_EMAIL_S,WISH_DATE,WISH_ID) values ('Вища математика','serg@gmail.com','ivanov@mail.com',to_date('01-12-2018 13:30','DD-MM-YYYY HH24:MI'),'2');
Insert into WISHLIST (SUBJECT_NAME_FK1,USER_EMAIL_T,USER_EMAIL_S,WISH_DATE,WISH_ID) values ('Вища математика','boris_1@gmail.com','fed123@gmail.com',to_date('01-12-2018 13:30','DD-MM-YYYY HH24:MI'),'3');
Insert into WISHLIST (SUBJECT_NAME_FK1,USER_EMAIL_T,USER_EMAIL_S, WISH_DATE,WISH_ID) values ('Англійська мова','boris_1@gmail.com', 'ivanov@mail.com',to_date('03-12-2018 10:00','DD-MM-YYYY HH24:MI'),'4');
Insert into CONSULTATION (USER_EMAIL_FK,SUBJECT_NAME_FK,CLASSROOM_NUMBER_FK,CLASSROOM_BUILDING_FK,CONSULTATION_BEGIN,CONSULTATION_END,CONSULTATION_ID) values ('boris_1@gmail.com','Математичний аналіз','5','5',to_date('01-12-2018 08:30','DD-MM-YYYY HH24:MI'),to_date('01-12-2018 10:00','DD-MM-YYYY HH24:MI'),'1002');
Insert into CONSULTATION (USER_EMAIL_FK,SUBJECT_NAME_FK,CLASSROOM_NUMBER_FK,CLASSROOM_BUILDING_FK,CONSULTATION_BEGIN,CONSULTATION_END,CONSULTATION_ID) values ('boris_1@gmail.com','Вища математика','505','12',to_date('02-12-2018 12:20','DD-MM-YYYY HH24:MI'),to_date('02-12-2018 13:30','DD-MM-YYYY HH24:MI'),'1003');
Insert into CONSULTATION (USER_EMAIL_FK,SUBJECT_NAME_FK,CLASSROOM_NUMBER_FK,CLASSROOM_BUILDING_FK,CONSULTATION_BEGIN,CONSULTATION_END,CONSULTATION_ID) values ('serg@gmail.com','БЖОП','107','10',to_date('02-12-2018 12:20','DD-MM-YYYY HH24:MI'),to_date('02-12-2018 13:55','DD-MM-YYYY HH24:MI'),'1004');
Insert into CONSULTATION (USER_EMAIL_FK,SUBJECT_NAME_FK,CLASSROOM_NUMBER_FK,CLASSROOM_BUILDING_FK,CONSULTATION_BEGIN,CONSULTATION_END,CONSULTATION_ID) values ('serg@gmail.com','АСД','107','10',to_date('05-12-2018 12:20','DD-MM-YYYY HH24:MI'),to_date('05-12-2018 15:00','DD-MM-YYYY HH24:MI'),'1005');
Insert into RECORD (USER_EMAIL_FK,CONSULTATION_ID_FK,CONSULT_DATE,RECORD_ID) values ('fed123@gmail.com','1002',to_date('01-12-2018 09:30','DD-MM-YYYY HH24:MI'),'2002');
Insert into RECORD (USER_EMAIL_FK,CONSULTATION_ID_FK,CONSULT_DATE,RECORD_ID) values ('fed123@gmail.com','1003',to_date('02-12-2018 12:30','DD-MM-YYYY HH24:MI'),'2003');
Insert into RECORD (USER_EMAIL_FK,CONSULTATION_ID_FK,CONSULT_DATE,RECORD_ID) values ('ivanov@mail.com','1003',to_date('02-12-2018 12:30','DD-MM-YYYY HH24:MI'),'2004');
Insert into RECORD (USER_EMAIL_FK,CONSULTATION_ID_FK,CONSULT_DATE,RECORD_ID) values ('ivanov@mail.com','1004',to_date('02-12-2018 12:20','DD-MM-YYYY HH24:MI'),'2005');

    
