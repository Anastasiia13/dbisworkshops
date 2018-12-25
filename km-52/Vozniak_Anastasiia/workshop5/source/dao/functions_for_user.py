import cx_Oracle
from dao.connection_info import *


def loginUser(user_email, user_password):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    user = cursor.callfunc("user_package.login", cx_Oracle.STRING, [user_email, user_password])

    cursor.close()
    connection.close()

    return user


def regUser(user_role, user_name, mid_name, user_surname, USER_email, USER_PASSWORD):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    cursor.callproc("user_package.register", [user_role, user_name, mid_name, user_surname, USER_email, USER_PASSWORD])
    cursor.close()
    connection.close()

    return USER_email


def getUserList():
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    query = 'SELECT * FROM users'
    cursor.execute(query)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result


def getConsult(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    consult = cursor.callfunc("consultation_package.get_cons_list", cx_Oracle.STRING, [user_email])

    cursor.close()
    connection.close()

    return consult


def getWishlist(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    wishlist = cursor.callfunc("wishlist_package.get_wish", cx_Oracle.STRING, [user_email])

    cursor.close()
    connection.close()

    return wishlist


def getRecords(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    records = cursor.callfunc("record_package.get_records", cx_Oracle.STRING, [user_email])

    cursor.close()
    connection.close()

    return records


def updateUser(user_name, mid_name, user_surname, user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("user_package.update_user", [user_name, mid_name, user_surname, user_email])

    cursor.close()
    connection.close()

    return user_email


def deleteUser(user_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("user_package.del_user", [user_email])

    cursor.close()
    connection.close()


def updateConsult(subject, classroom, building, cons_begin, cons_end, cons_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("consultation_package.update_consult", [subject, classroom, building, cons_begin, cons_end, cons_id])

    cursor.close()
    connection.close()

    return cons_id


def deleteConsult(cons_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("consultation_package.del_cons", [cons_id])

    cursor.close()
    connection.close()

    return cons_id


def addConsult(user_email, subject, classroom, building, cons_begin, cons_end):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("consultation_package.ADD_cons", [user_email, subject, classroom, building, cons_begin, cons_end])

    cursor.close()
    connection.close()

    return user_email


def updateRecord(rec_id, rec_date):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("record_package.update_record", [rec_id, rec_date])

    cursor.close()
    connection.close()

    return rec_id


def deleteRecord(rec_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("record_package.del_rec", [rec_id])

    cursor.close()
    connection.close()

    return rec_id


def addRecord(user_email, cons_id, rec_date):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("record_package.ADD_record", [user_email, cons_id, rec_date])

    cursor.close()
    connection.close()

    return user_email


def updateWishlist(subject, wish_date, teacher_email, wish_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("wishlist_package.update_wish", [subject, wish_date, teacher_email, wish_id])

    cursor.close()
    connection.close()

    return wish_id


def deleteWish(wish_id):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("wishlist_package.del_wish", [wish_id])

    cursor.close()
    connection.close()

    return wish_id


def addWish(subject, wish_date, teacher_email, stud_email):
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    cursor.callproc("wishlist_package.add_wish", [subject, wish_date, teacher_email, stud_email])

    cursor.close()
    connection.close()

    return stud_email


if __name__ == "__main__":
    print(getUserList())