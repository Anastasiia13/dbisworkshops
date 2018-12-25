ALTER TABLE consultation
   DROP CONSTRAINT fk_subject_consultation;

ALTER TABLE consultation
   DROP CONSTRAINT fk_classroom_consultation;

ALTER TABLE consultation
   DROP CONSTRAINT fk_user_consultation;

ALTER TABLE RECORD
   DROP CONSTRAINT fk_consultation_record;

ALTER TABLE RECORD
   DROP CONSTRAINT fk_user_record;

ALTER TABLE users
   DROP CONSTRAINT fk_role_user;

ALTER TABLE wishlist
   DROP CONSTRAINT fk_subject_wishlist;

ALTER TABLE wishlist
   DROP CONSTRAINT fk_user_wishlist;

DROP TABLE classroom CASCADE CONSTRAINTS;

DROP INDEX teacher_consults_student_fk;

DROP INDEX consultation_has_a_subject_fk;

DROP INDEX in_class_are_consultations_fk;

DROP TABLE consultation CASCADE CONSTRAINTS;

DROP INDEX students_make_records_fk;

DROP INDEX records_on_consultation_fk;

DROP TABLE RECORD CASCADE CONSTRAINTS;

DROP TABLE ROLE CASCADE CONSTRAINTS;

DROP TABLE subject CASCADE CONSTRAINTS;

DROP INDEX user_has_a_role_fk;

DROP TABLE users CASCADE CONSTRAINTS;

DROP INDEX on_subject_is_wishlist_fk;

DROP INDEX student_has_a_wishlist_fk;

DROP TABLE wishlist CASCADE CONSTRAINTS;

/*==============================================================*/
/* Table: CLASSROOM                                             */
/*==============================================================*/
CREATE TABLE classroom 
(
   classroom_number     VARCHAR2(20)          NOT NULL,
   classroom_building   INTEGER              NOT NULL,
   CONSTRAINT pk_classroom PRIMARY KEY (classroom_number, classroom_building)
);

/*==============================================================*/
/* Table: CONSULTATION                                          */
/*==============================================================*/
CREATE TABLE consultation 
(
   user_email_fk        VARCHAR2(150)         NOT NULL,
   subject_name_fk      VARCHAR2(70)         NOT NULL,
   classroom_number_fk  VARCHAR2(20)          NOT NULL,
   classroom_building_fk INTEGER              NOT NULL,
   consultation_begin   DATE                 NOT NULL,
   consultation_end     DATE                 NOT NULL,
   consultation_id      INTEGER              NOT NULL,
   CONSTRAINT pk_consultation PRIMARY KEY (consultation_id)
);

/*==============================================================*/
/* Index: IN_CLASS_ARE_CONSULTATIONS_FK                         */
/*==============================================================*/
CREATE INDEX in_class_are_consultations_fk ON consultation (
   classroom_number_fk ASC,
   classroom_building_fk ASC
);

/*==============================================================*/
/* Index: CONSULTATION_HAS_A_SUBJECT_FK                         */
/*==============================================================*/
CREATE INDEX consultation_has_a_subject_fk ON consultation (
   subject_name_fk ASC
);

/*==============================================================*/
/* Index: TEACHER_CONSULTS_STUDENT_FK                           */
/*==============================================================*/
CREATE INDEX teacher_consults_student_fk ON consultation (
   user_email_fk ASC
);

/*==============================================================*/
/* Table: RECORD                                                */
/*==============================================================*/
CREATE TABLE RECORD 
(
   user_email_fk        VARCHAR2(150)         NOT NULL,
   consultation_id_fk   INTEGER              NOT NULL,
   consult_date         DATE                 NOT NULL,
   record_id            INTEGER              NOT NULL,
   CONSTRAINT pk_record PRIMARY KEY (record_id)
);

/*==============================================================*/
/* Index: RECORDS_ON_CONSULTATION_FK                            */
/*==============================================================*/
CREATE INDEX records_on_consultation_fk ON RECORD (
   consultation_id_fk ASC
);

/*==============================================================*/
/* Index: STUDENTS_MAKE_RECORDS_FK                              */
/*==============================================================*/
CREATE INDEX students_make_records_fk ON RECORD (
   user_email_fk ASC
);

/*==============================================================*/
/* Table: ROLE                                                  */
/*==============================================================*/
CREATE TABLE ROLE 
(
   user_role            VARCHAR2(30)         NOT NULL,
   CONSTRAINT pk_role PRIMARY KEY(user_role)
);

/*==============================================================*/
/* Table: SUBJECT                                               */
/*==============================================================*/
CREATE TABLE subject 
(
   subject_name         VARCHAR2(70)         NOT NULL,
   CONSTRAINT pk_subject PRIMARY KEY (subject_name)
);

/*==============================================================*/
/* Table: users                                                */
/*==============================================================*/
CREATE TABLE users 
(
   user_role_fk         VARCHAR2(30)         NOT NULL,
   user_name            VARCHAR2(80)         NOT NULL,
   user_surname         VARCHAR2(80)         NOT NULL,
   user_email           VARCHAR2(150)         NOT NULL,
   user_password        VARCHAR2(80)         NOT NULL,
   middle_name          VARCHAR2(80)         NOT NULL,
   CONSTRAINT pk_user PRIMARY KEY (user_email)
);

/*==============================================================*/
/* Index: USER_HAS_A_ROLE_FK                                    */
/*==============================================================*/
CREATE INDEX user_has_a_role_fk ON users (
   user_role_fk ASC
);

/*==============================================================*/
/* Table: WISHLIST                                              */
/*==============================================================*/
CREATE TABLE wishlist 
(
   subject_name_fk1     VARCHAR2(70)         NOT NULL,
   user_email_t       VARCHAR2(150)         NOT NULL,
   user_email_s       VARCHAR2(150)         NOT NULL,
   wish_date            DATE                 NOT NULL,
   wish_id              INTEGER              NOT NULL,
   CONSTRAINT pk_wishlist PRIMARY KEY (wish_id)
);

/*==============================================================*/
/* Index: STUDENT_HAS_A_WISHLIST_FK                             */
/*==============================================================*/
CREATE INDEX student_has_a_wishlist_fk ON wishlist (
   user_email_s ASC
);

/*==============================================================*/
/* Index: ON_SUBJECT_IS_WISHLIST_FK                             */
/*==============================================================*/
CREATE INDEX on_subject_is_wishlist_fk ON wishlist (
   subject_name_fk1 ASC
);

ALTER TABLE consultation
   ADD CONSTRAINT fk_subject_consultation FOREIGN KEY (subject_name_fk)
      REFERENCES subject (subject_name);

ALTER TABLE consultation
   ADD CONSTRAINT fk_classroom_consultation FOREIGN KEY (classroom_number_fk, classroom_building_fk)
      REFERENCES classroom (classroom_number, classroom_building);

ALTER TABLE consultation
   ADD CONSTRAINT fk_user_consultation FOREIGN KEY (user_email_fk)
      REFERENCES users (user_email);

ALTER TABLE RECORD
   ADD CONSTRAINT fk_consultation_record FOREIGN KEY (consultation_id_fk)
      REFERENCES consultation (consultation_id);

ALTER TABLE RECORD
   ADD CONSTRAINT fk_user_record FOREIGN KEY (user_email_fk)
      REFERENCES users (user_email);

ALTER TABLE users
   ADD CONSTRAINT fk_role_user FOREIGN KEY (user_role_fk)
      REFERENCES ROLE (user_role);

ALTER TABLE wishlist
   ADD CONSTRAINT fk_subject_wishlist FOREIGN KEY (subject_name_fk1)
      REFERENCES subject (subject_name);

ALTER TABLE wishlist
   ADD CONSTRAINT fk_user_wishlist FOREIGN KEY (user_email_s)
      REFERENCES users (user_email);

ALTER TABLE users
    ADD CONSTRAINT check_email 
    CHECK (REGEXP_LIKE (user_email, '^[A-Z0-9._-]+@[A-Z0-9._-]+\.[A-Z]{2,4}'));

ALTER TABLE users
    ADD CONSTRAINT check_password 
	CHECK (REGEXP_LIKE(user_password, '^[0-9a-zA-Z]{6,20}'));
	
ALTER TABLE users
    ADD CONSTRAINT check_name 
    CHECK (REGEXP_LIKE (user_name, '^[ЇІА-Я]{1}[іїа-я]{1,20}'));

ALTER TABLE users
    ADD CONSTRAINT check_surname 
    CHECK (REGEXP_LIKE (user_surname, '^[ЇІА-Я]{1}[іїа-я]{1,20}'));	
	
ALTER TABLE users
    ADD CONSTRAINT check_mid_name 
    CHECK (REGEXP_LIKE (middle_name, '^[ЇІА-Я]{1}[іїа-я]{1,20}'));	
	
ALTER TABLE subject
    ADD CONSTRAINT check_subject
    CHECK (REGEXP_LIKE (subject_name, '^[-0-9a-zA-ZА-Яа-яЇїіІЙй\s]'));
	
ALTER TABLE classroom
    ADD CONSTRAINT check_building
    CHECK (classroom_building>0 AND classroom_building<40);

ALTER TABLE wishlist
    ADD CONSTRAINT check_wish
    CHECK (wish_id>0 AND wish_id<1000);
	
ALTER TABLE consultation
    ADD CONSTRAINT check_consult_id
    CHECK (consultation_id>1001 AND consultation_id<2000); 

ALTER TABLE RECORD
    ADD CONSTRAINT check_record_id
    CHECK (record_id>2001 AND record_id<3000); 	
	
ALTER TABLE consultation
	ADD CONSTRAINT check_consult_date
	CHECK (consultation_begin < consultation_end);
		
	
ALTER TABLE classroom
    ADD CONSTRAINT check_class 
    CHECK (REGEXP_LIKE (classroom_number, '^[0-9]{1,3}[а-я]{0,1}'));
	
ALTER TABLE ROLE
	ADD CONSTRAINT check_role
	CHECK (user_role='Студент' OR  user_role='Викладач' OR  user_role='Адмін');
