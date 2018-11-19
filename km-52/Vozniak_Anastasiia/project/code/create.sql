/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     18.11.2018 22:23:43                          */
/*==============================================================*/


alter table CONSULTATION
   drop constraint FK_TEACHER_CONSULTATION;

alter table CONSULTATION
   drop constraint FK_CLASSROOM_CONSULTATION;

alter table RECORD_ON_CONSULTATION
   drop constraint FK_CONSULTATION_RECORD;

alter table RECORD_ON_CONSULTATION
   drop constraint FK_STUDENT_RECORD;

alter table SCHEDULE_CONSULTATION
   drop constraint FK_TEACHER_SCHEDULE;

drop table CLASSROOM cascade constraints;

drop table CONSULTATION cascade constraints;

drop table RECORD_ON_CONSULTATION cascade constraints;

drop table SCHEDULE_CONSULTATION cascade constraints;

drop table STUDENT cascade constraints;

drop table TEACHER cascade constraints;

/*==============================================================*/
/* Table: CLASSROOM                                             */
/*==============================================================*/
create table CLASSROOM 
(
   CLASSROOM_NUMBER     VARCHAR2(5)          not null,
   CLASSROOM_BUILDING   INTEGER              not null,
   constraint PK_CLASSROOM primary key (CLASSROOM_NUMBER, CLASSROOM_BUILDING)
);

/*==============================================================*/
/* Table: CONSULTATION                                          */
/*==============================================================*/
create table CONSULTATION 
(
   CONSULTATION_ID      INTEGER              not null,
   TEACHER_ID_FK        INTEGER              not null,
   CLASSROOM_NUMBER_FK  VARCHAR2(5)          not null,
   CLASSROOM_BUILDING_FK INTEGER              not null,
   CONSULTATION_DATE    DATE                 not null,
   CONSULTATION_TIME    DATE                 not null,
   CONSULTATION_TYPE    VARCHAR2(14)         not null CHECK (CONSULTATION_TYPE IN ('Групова', 'Індивідуальна'));,
   CONSULTATION_SUBJECT VARCHAR2(100),
   CONSULATION_DURATION INTEGER              not null,
   constraint PK_CONSULTATION primary key (CONSULTATION_ID)
);

/*==============================================================*/
/* Table: RECORD_ON_CONSULTATION                                */
/*==============================================================*/
create table RECORD_ON_CONSULTATION 
(
   CONSULTATION_ID_FK     INTEGER              not null,
   STUDENT_ID_FK        INTEGER              not null,
   constraint PK_RECORD_ON_CONSULTATION primary key (CONSULTATION_ID, STUDENT_ID_FK)
);

/*==============================================================*/
/* Table: SCHEDULE_CONSULTATION                                 */
/*==============================================================*/
create table SCHEDULE_CONSULTATION 
(
   SCHEDULE_CONSULT_DAY VARCHAR2(12)         not null,
   TEACHER_ID_FK_1      INTEGER              not null,
   SCHEDULE_CONSULT_START DATE                 not null,
   SCHEDULE_CONSULT_END DATE                 not null,
   constraint PK_SCHEDULE_CONSULTATION primary key (SCHEDULE_CONSULT_DAY, TEACHER_ID_FK_1)
);

/*==============================================================*/
/* Table: STUDENT                                               */
/*==============================================================*/
create table STUDENT 
(
   STUDENT_NAME         VARCHAR2(20)         not null,
   STUDENT_SURNAME      VARCHAR2(20)         not null,
   STUDENT_EMAIL        VARCHAR2(30)         not null,
   STUDENT_GROUP        VARCHAR2(8)          not null,
   STUDENT_ID           INTEGER              not null,
   constraint PK_STUDENT primary key (STUDENT_ID)
);

/*==============================================================*/
/* Table: TEACHER                                               */
/*==============================================================*/
create table TEACHER 
(
   TEACHER_NAME         VARCHAR2(20)         not null,
   TEACHER_SURNAME      VARCHAR2(20)         not null,
   TEACHER_EMAIL        VARCHAR2(30)         not null,
   TEACHER_FACULTY      VARCHAR2(5)          not null,
   TEACHER_ID           INTEGER              not null,
   constraint PK_TEACHER primary key (TEACHER_ID)
);

alter table CONSULTATION
   add constraint FK_TEACHER_CONSULTATION foreign key (TEACHER_ID_FK)
      references TEACHER (TEACHER_ID);

alter table CONSULTATION
   add constraint FK_CLASSROOM_CONSULTATION foreign key (CLASSROOM_NUMBER_FK, CLASSROOM_BUILDING_FK)
      references CLASSROOM (CLASSROOM_NUMBER, CLASSROOM_BUILDING);

alter table RECORD_ON_CONSULTATION
   add constraint FK_CONSULTATION_RECORD foreign key (CONSULTATION_ID_FK)
      references CONSULTATION (CONSULTATION_ID);

alter table RECORD_ON_CONSULTATION
   add constraint FK_STUDENT_RECORD foreign key (STUDENT_ID_FK)
      references STUDENT (STUDENT_ID);

alter table SCHEDULE_CONSULTATION
   add constraint FK_TEACHER_SCHEDULE foreign key (TEACHER_ID_FK_1)
      references TEACHER (TEACHER_ID);
	  
	  
	  
	  

