import cx_Oracle
from dao.connection_info import *
from datetime import datetime


def loginUser(user_email, user_password):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    user = cursor.callfunc("user_package.login", cx_Oracle.STRING, [user_email, user_password])

    cursor.close()
    connection.close()

    return user


def getRole(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("user_package.get_role", cx_Oracle.STRING, [user_email])

    cursor.close()
    connection.close()
    return result


def getName(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("user_package.get_name", cx_Oracle.STRING, [user_email])

    cursor.close()
    connection.close()
    return result


def is_user(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    count = cursor.callfunc("user_package.is_user", cx_Oracle.NATIVE_INT, [user_email])

    cursor.close()
    connection.close()

    return count


def is_password(user_email, user_pass):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    count = cursor.callfunc("user_package.is_pass", cx_Oracle.NATIVE_INT, [user_email, user_pass])

    cursor.close()
    connection.close()

    return count


def addUser(role, name, mid_name, surname, email, u_pass):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("user_package.add_user", cx_Oracle.STRING, [role, name, mid_name, surname, email, u_pass])
    cursor.close()
    connection.close()

    return result


def getUsers():
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()
    query = 'SELECT * FROM users'
    cursor.execute(query)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result


def getUsersRole():
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()
    query = 'SELECT user_role_fk,count(*) FROM users group by user_role_fk'
    cursor.execute(query)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result

def getConsult(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    query = 'select * from table(consultation_package.get_cons_list(:user_email))'
    cursor.execute(query, user_email=user_email)

    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result


def getTeachers(user_role):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    query = 'select * from table(user_package.get_teacher(:user_role))'
    cursor.execute(query, user_role=user_role)

    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result


def getSubj():
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select consultation.SUBJECT_NAME_FK, count(*) from consultation GROUP BY consultation.SUBJECT_NAME_FK'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result


def getConsultby(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    query = 'select user_email_fk, count(user_email_fk) from consultation group by user_email_fk'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result

def getAllRecords(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    query = 'select * from table(record_package.get_all_records(:user_email))'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result


def getAllWish(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    query = 'select * from table(wishlist_package.get_all_wish(:user_email))'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result

def getConsultByTheme(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    query = 'select * from table(consultation_package.get_cons_list(:user_email)) group by SUBJECT_NAME_FK'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result


def getWishlist(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    query = 'SELECT * FROM table(wishlist_package.get_wish(:user_email))'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result


def getRecords(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'SELECT * FROM table(record_package.get_records(:user_email))'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result


def getRecordsByDate(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'SELECT * FROM table(record_package.get_records(:user_email)) group by RECORD.CONSULT_DATE'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    return result


def updateUser(user_name, mid_name, user_surname, user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("user_package.update_user", [user_name, mid_name, user_surname, user_email])

    cursor.close()
    connection.close()

    return result


def deleteUser(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("user_package.del_user", [user_email])

    cursor.close()
    connection.close()


def updateConsult(subject, classroom, building, cons_begin, cons_end, cons_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("consultation_package.update_consult", cx_Oracle.STRING,
                             [subject, classroom, building, cons_begin, cons_end, cons_id])

    cursor.close()
    connection.close()

    return result


def deleteConsult(cons_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("consultation_package.del_cons", cx_Oracle.STRING, [cons_id])

    cursor.close()
    connection.close()

    return result


def addConsult(user_email, subject, classroom, build, begin, cons_end):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("consultation_package.add_consult", cx_Oracle.STRING,
                             [user_email, subject, classroom, build, begin, cons_end])

    cursor.close()
    connection.close()

    return result


def updateRecord(rec_id, rec_date):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("record_package.update_record", cx_Oracle.STRING, [rec_id, rec_date])

    cursor.close()
    connection.close()

    return result


def deleteRecord(rec_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("record_package.del_rec", [rec_id])

    cursor.close()
    connection.close()


def addRecord(user_email, cons_id, rec_date):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("record_package.add_record", cx_Oracle.STRING, [user_email, cons_id, rec_date])

    cursor.close()
    connection.close()

    return result


def updateWishlist(subject, wish_date, teacher_email, wish_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("wishlist_package.update_wish", cx_Oracle.STRING,
                             [subject, wish_date, teacher_email, wish_id])

    cursor.close()
    connection.close()

    return result


def deleteWish(wish_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("wishlist_package.del_wish", [wish_id])

    cursor.close()
    connection.close()



def addWish(subject, wish_date, teacher_email, stud_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("wishlist_package.add_wish",cx_Oracle.STRING,
                             [subject, wish_date, teacher_email, stud_email])

    cursor.close()
    connection.close()

    return result


def getSubjects(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()
    query = 'select * from table(subject_package.get_subjects(:user_email))'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result

def getClass(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()
    query = 'select * from table(classroom_package.get_class(:user_email))'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result


def getBuild(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()
    query = 'select * from table(classroom_package.get_build(:user_email))'
    cursor.execute(query, user_email=user_email)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result


def addSubject(user_email, subject_name):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("subject_package.add_subject", cx_Oracle.STRING, [user_email, subject_name])

    cursor.close()
    connection.close()

    return result


def addClassroom(user_email, classroom, build):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("classroom_package.add_class", cx_Oracle.STRING, [user_email, classroom, build])

    cursor.close()
    connection.close()

    return result


def delSubject(subject_name):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("subject_package.del_subject", [subject_name])

    cursor.close()
    connection.close()

    return result


def updateSubject(old_name, new_name):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("subject_package.del_subject", [old_name, new_name])

    cursor.close()
    connection.close()

    return result


def CountCountry(country):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    result = cursor.callfunc("abc_package.count_country", cx_Oracle.NATIVE_INT, [country])

    cursor.close()
    connection.close()

    return result


if __name__ == "__main__":
    print(getAllWish('boris_1@gmail.com'))
    #print(updateRecord('2006', datetime.strptime("05-12-18 16:40", "%d-%m-%y %H:%M")))
