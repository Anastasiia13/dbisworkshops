from flask import Flask, render_template, request, session, url_for, redirect, make_response
from dao.functions import *
from datetime import datetime, timedelta
from wtf.abc import AbcForm
from wtf.login import LoginForm
from wtf.user import UserForm
from wtf.init_form import first_pageF
from wtf.ShowUsers import *
from wtf.ShowConsult import *
from wtf.AddConsult import *
from wtf.UpdateConsult import *
from wtf.ShowRecords import *
from wtf.AddRecord import *
from wtf.UpdateRecord import *
from wtf.ShowWishlist import *
from wtf.UpdateWish import *
from wtf.AddWish import *
import plotly
import plotly.graph_objs as go
import json

app = Flask(__name__, template_folder='templates')
app.secret_key = 'My_key'


# @app.route('/',methods=['GET','POST'])
# def index():
#     render_template('index.html')
#
#
@app.route('/abc', methods=['GET', 'POST'])
def abc():
    form = AbcForm()
    if request.method == 'POST':
        country = request.form.get('country')
        result = CountCountry(country=country)
        return render_template('abc.html', myform=form, result=result)
    return render_template('abc.html', myform=form)


@app.route('/', methods=['POST', 'GET'])
def index():
    redirect(url_for('index'))
    first_page = first_pageF()
    if 'email' in session:
        email = session['email']
        user_name = session['user_name']
        role = session['role']
        return render_template('index.html',  form=first_page, email=email, user_name=user_name, role=role)
    elif request.cookies.get('email')!=None:
        email = request.cookies.get('email')
        user_name = request.cookies.get('name')
        role = request.cookies.get('role')
        return render_template('index.html', form=first_page, email=email, user_name=user_name, role=role)
    else:
        return "<div>Ви не ввійшли<br><a href = '/login/'></b>" + "Натисніть тут, щоб ввійти</b></a><br>" + \
                "<a href='/registration'></b>Або тут, щоб зареєструватися</b></a></div>"


@app.route('/login/', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    if request.method == 'POST':
        is_exist = is_user(request.form['email'])
        if is_exist == 0:
            result = 'Такого користувача не існує'
            return render_template("login.html", myform=form, result=result)
        else:
            is_pass = is_password(request.form['email'], request.form['password'])
            if is_pass != 0:
                session['email'] = request.form['email']
                email = request.form['email']
                session['user_name'] = getName(user_email=email)
                session['role'] = getRole(user_email=email)
                response = make_response(redirect(url_for('index')))
                expires = datetime.now()
                expires += timedelta(weeks=10)
                response.set_cookie('role', session['role'], expires=expires)
                response.set_cookie('name', session['user_name'], expires=expires)
                response.set_cookie('email', session['email'], expires=expires)
                return response
            else:
                result = 'Невірний пароль'
                return render_template("login.html", myform=form, result=result)

    return render_template('login.html', myform=form)


@app.route('/logout')
def logout():
    session.pop('email', None)

    response = make_response(redirect(url_for('index')))
    response.set_cookie('email', '', expires=0)
    return response


@app.route('/registration', methods=['GET', 'POST'])
def registration():
    form_reg = UserForm()
    if request.method == 'POST':
        session['email'] = request.form['email']
        if form_reg.validate() == False:
            return render_template('user.html', myform=form_reg)
        else:
            result = addUser(
                role=request.form["role"],
                name=request.form["name"],
                mid_name=request.form["midname"],
                surname=request.form["surname"],
                email=request.form["email"],
                u_pass=request.form["password"]
            )
            if result != 'ok':
                return render_template('user.html', myform=form_reg, result=result)
            response = make_response(redirect(url_for('registration')))
            expires = datetime.now()
            expires += timedelta(days=60)
            response.set_cookie('login_cook', request.form['email'], expires=expires)
            return response
    return render_template('user.html', myform=form_reg)


@app.route('/showUsers', methods=['GET','POST'])
def show_users():
    formShow = UserShow()
    allUsers = getUsers()
    formShow.user_list.choices = [(int(allUsers.index(current)), current) for current in allUsers]
    if request.method == 'POST':
        if formShow.validate() == False:
            return render_template('ShowUsers.html', myform=formShow)
        else:
            if formShow.delete.data:
                email = allUsers[int(request.form['user_list'])][3]
                deleteUser(user_email=email)
                allUsers = getUsers()
                formShow.user_list.choices = [(int(allUsers.index(current)), current) for current in allUsers]
                return render_template('ShowUsers.html', myform=formShow)

    return render_template('ShowUsers.html', myform=formShow)




@app.route('/showConsult', methods=['GET', 'POST'])
def show_consult():
    delete_form = ShowConsult()
    allConsult = getConsult(session['email'])
    delete_form.consult_list.choices = [(int(allConsult.index(current)), current) for current in allConsult]
    if request.method == 'POST':
        if delete_form.validate() == False:
            return render_template('ShowConsult.html', delete_form=delete_form)
        else:
            if delete_form.delete.data:
                consult_id = allConsult[int(request.form['consult_list'])][5]
                session['cons_id']=consult_id
                result = deleteConsult(cons_id=consult_id)
                allConsult = getConsult(session['email'])
                delete_form.consult_list.choices = [(int(allConsult.index(current)), current) for current
                                                    in allConsult]
                return render_template('ShowConsult.html', delete_form=delete_form, result=result)
            if delete_form.update.data:
                session['consult_id'] = allConsult[int(request.form['consult_list'])][5]
                session['subj'] = allConsult[int(request.form['consult_list'])][0]
                session['clas '] = allConsult[int(request.form['consult_list'])][1]
                session['building '] = allConsult[int(request.form['consult_list'])][2]
                session['cons_begin'] = allConsult[int(request.form['consult_list'])][3]
                session['end '] = allConsult[int(request.form['consult_list'])][4]
                return redirect(url_for('update_consult'))

    return render_template('ShowConsult.html', delete_form=delete_form)


@app.route('/updateConsult', methods=['GET', 'POST'])
def update_consult():
    update_form = UpdateConsult()
    subject_list = getSubjects(session['email'])
    update_form.subject_list.choices = [(int(subject_list.index(currents)), currents) for currents in subject_list]
    consult_id = session['consult_id']
    if request.method == 'POST':
        if update_form.validate() == False:
            return render_template('UpdateConsult.html', update_form=update_form)

        else:
                result = updateConsult(
                    # subject=request.form['subject'],
                    subject = subject_list[int(request.form['subject_list'])][0],
                    classroom = request.form['classroom'],
                    building = request.form['build'],
                    cons_begin = datetime.strptime(request.form['begin'], "%d-%m-%Y %H:%M"),
                    cons_end = datetime.strptime(request.form['cons_end'], "%d-%m-%Y %H:%M"),
                    cons_id=consult_id)
                # addSubject(session['email'], request.form['subject'])
                if result != 'ok':
                    return render_template('UpdateConsult.html', update_form=update_form, result=result)

                return render_template('UpdateConsult.html', update_form=update_form, result=result)
    return render_template('UpdateConsult.html', update_form=update_form)



@app.route('/addConsult', methods=['GET', 'POST'])
def add_consult():
    add_form = AddConsult()
    if request.method == 'POST':
        if add_form.validate() == False:
            return render_template('AddConsult.html', add_form=add_form)
        else:
            result = addConsult(
                user_email=session['email'],
                subject=request.form['subject'],
                classroom=request.form['classroom'],
                build=request.form['build'],
                begin=datetime.strptime(request.form['begin'], "%d-%m-%Y %H:%M"),
                cons_end=datetime.strptime(request.form['cons_end'],"%d-%m-%Y %H:%M")

            )
            addSubject(session['email'],request.form['subject'])
            if result != 'ok':
                return render_template('AddConsult.html', add_form=add_form, result=result)
            response = make_response(redirect(url_for('add_consult')))
            expires = datetime.now()
            expires += timedelta(days=60)
            response.set_cookie('email', session['email'], expires=expires)
            return response
    return render_template('AddConsult.html', add_form=add_form)

@app.route('/showAllRecords', methods=['GET', 'POST'])
def show_all_record():
    delete_form = ShowRecords()
    allRecord = getAllRecords(session['email'])
    delete_form.record_list.choices = [(int(allRecord.index(current)), current) for current in allRecord]
    # product_name = [row[0] for row in product_list]
    if request.method == 'POST':
        if delete_form.validate() == False:
            return render_template('AllRecords.html', delete_form=delete_form)
        else:
            if delete_form.delete.data:
                record_id = allRecord[int(request.form['record_list'])][8]
                deleteRecord(rec_id=record_id)
                allRecord = getRecords(session['email'])
                delete_form.record_list.choices = [(int(allRecord.index(current)), current) for current in allRecord]
                return render_template('AllRecords.html', delete_form=delete_form)


    return render_template('AllRecords.html', delete_form=delete_form)


@app.route('/showRecord', methods=['GET', 'POST'])
def show_record():
    delete_form = ShowRecords()
    allRecord = getRecords(session['email'])
    delete_form.record_list.choices = [(int(allRecord.index(current)), current) for current in allRecord]
    # product_name = [row[0] for row in product_list]
    if request.method == 'POST':
        if delete_form.validate() == False:
            return render_template('ShowRecords.html', delete_form=delete_form)
        else:
            if delete_form.delete.data:
                record_id = allRecord[int(request.form['record_list'])][8]
                deleteRecord(rec_id=record_id)
                allRecord = getRecords(session['email'])
                delete_form.record_list.choices = [(int(allRecord.index(current)), current) for current in allRecord]
                return render_template('ShowRecords.html', delete_form=delete_form)
            if delete_form.update.data:
                session['rec_id']=allRecord[int(request.form['record_list'])][8]
                return redirect(url_for('update_record'))

    return render_template('ShowRecords.html', delete_form=delete_form)


@app.route('/addRecord', methods=['GET', 'POST'])
def add_record():
    choose_form = ChooseTeacher()
    consult_form=Consults()
    add_form= AddRecord()
    teachers = getTeachers('Викладач')
    choose_form.teachers.choices = [(int(teachers.index(current)), current) for current in teachers]

    if request.method == 'POST':
        if choose_form.validate() == False:
            return render_template('AddRecord.html',choose_form =choose_form)

        else:
            if choose_form.add.data:
                session['teacher'] = teachers[int(request.form['teachers'])][3]
                print (session['teacher'])
                return redirect(url_for('add_record1'))

    return render_template('AddRecord.html',choose_form =choose_form)


@app.route('/addRecord1', methods=['GET', 'POST'])
def add_record1():
    consult_form=Consults()
    consult_list = getConsult(session['teacher'])
    consult_form.consult_list.choices = [(int(consult_list.index(current)), current)
                                         for current in consult_list]
    if request.method == 'POST':
        if consult_form.validate() == False:
            return render_template('AddRecord1.html',consult_form=consult_form)

        else:
            if consult_form.add.data:
                session['consult_id'] = consult_list[int(request.form['consult_list'])][5]
                print (session['consult_id'])
                return redirect(url_for('add_record2'))



    return render_template('AddRecord1.html',consult_form=consult_form)


@app.route('/addRecord2', methods=['GET', 'POST'])
def add_record2():
    add_form = AddRecord()
    if request.method == 'POST':
        if add_form.validate() == False:
            return render_template('AddRecord2.html', add_form=add_form)

        else:
            if add_form.add.data:
                result = addRecord(
                    user_email=session['email'],
                    cons_id=session['consult_id'],
                    rec_date=datetime.strptime(request.form['begin'], "%d-%m-%Y %H:%M"))
                if result != 'ok':
                    return render_template('AddRecord2.html', add_form=add_form, result=result)
                return render_template('AddRecord2.html', add_form=add_form)

    return render_template('AddRecord2.html', add_form=add_form)



@app.route('/updateRecord', methods=['GET', 'POST'])
def update_record():
    update_form = UpdateRecord()
    delete_form = ShowRecords()
    if request.method == 'POST':
        if update_form.validate() == False:
            return render_template('UpdateRecord.html', update_form=update_form)

        else:
            if update_form.add.data:
                result = updateRecord(
                    rec_id=session['rec_id'],
                    rec_date=datetime.strptime(request.form['begin'], "%d-%m-%Y %H:%M"))
                if result != 'ok':
                    return render_template('UpdateRecord.html', update_form=update_form, result=result)
                return render_template('UpdateRecord.html', update_form=update_form)

    return render_template('UpdateRecord.html', update_form=update_form)


@app.route('/showAllWish', methods=['GET', 'POST'])
def show_all_wish():
    delete_form = ShowWishlist()
    allWish = getAllWish(session['email'])
    delete_form.wish_list.choices = [(int(allWish.index(current)), current) for current in allWish]
    # product_name = [row[0] for row in product_list]
    if request.method == 'POST':
        if delete_form.validate() == False:
            return render_template('AllWish.html', delete_form=delete_form)
        else:
            if delete_form.delete.data:
                wishlist_id = allWish[int(request.form['wish_list'])][3]
                print (wishlist_id)
                deleteWish(wish_id=wishlist_id)
                allWish = getAllWish(session['email'])
                delete_form.wish_list.choices = [(int(allWish.index(current)), current) for current in allWish]
                return render_template('AllWish.html', delete_form=delete_form)

    return render_template('AllWish.html', delete_form=delete_form)


@app.route('/showWish', methods=['GET', 'POST'])
def show_wish():
    delete_form = ShowWishlist()
    allWish = getWishlist(session['email'])
    delete_form.wish_list.choices = [(int(allWish.index(current)), current) for current in allWish]
    # product_name = [row[0] for row in product_list]
    if request.method == 'POST':
        if delete_form.validate() == False:
            return render_template('ShowWishlist.html', delete_form=delete_form)
        else:
            if delete_form.delete.data:
                wish_id = allWish[int(request.form['wish_list'])][3]
                deleteWish(wish_id=wish_id)
                allWish = getWishlist(session['email'])
                delete_form.wish_list.choices = [(int(allWish.index(current)), current) for current in allWish]
                return render_template('ShowWishlist.html', delete_form=delete_form)
            if delete_form.update.data:
                session['wish_teacher']=allWish[int(request.form['wish_list'])][1]
                session['wish_id']=allWish[int(request.form['wish_list'])][3]
                return redirect(url_for('update_wish'))

    return render_template('ShowWishlist.html', delete_form=delete_form)


@app.route('/addWish', methods=['GET', 'POST'])
def add_wish():
    choose_form = ChooseTeacher()
    consult_form=Consults()
    add_form= AddRecord()
    teachers = getTeachers('Викладач')
    choose_form.teachers.choices = [(int(teachers.index(current)), current) for current in teachers]

    if request.method == 'POST':
        if choose_form.validate() == False:
            return render_template('AddWish.html',choose_form =choose_form)

        else:
            if choose_form.add.data:
                session['teacher'] = teachers[int(request.form['teachers'])][3]
                print (session['teacher'])
                return redirect(url_for('add_wish1'))

    return render_template('AddWish.html',choose_form =choose_form)


@app.route('/addWish1', methods=['GET', 'POST'])
def add_wish1():
    subj_form=Subjects()
    subject_list = getSubjects(session['email'])
    subj_form.subject_list.choices = [(int(subject_list.index(current)), current)
                                         for current in subject_list]
    if request.method == 'POST':
        if subj_form.validate() == False:
            return render_template('AddWish1.html',subj_form=subj_form)

        else:
            if subj_form.add.data:
                session['subj_name'] = subject_list[int(request.form['subject_list'])][0]
                print (session['subj_name'])
                return redirect(url_for('add_wish2'))

    return render_template('AddWish1.html', subj_form=subj_form)


@app.route('/addWish2', methods=['GET', 'POST'])
def add_wish2():
    add_form = AddWish()
    if request.method == 'POST':
        if add_form.validate() == False:
            return render_template('AddWish2.html', add_form=add_form)

        else:
            if add_form.add.data:
                result = addWish(
                    subject=session['subj_name'],
                    wish_date=datetime.strptime(request.form['begin'], "%d-%m-%Y %H:%M"),
                    teacher_email=session['teacher'],
                    stud_email=session['email'])
                if result != 'ok':
                    return render_template('AddWish2.html', add_form=add_form, result=result)
                return render_template('AddWish2.html', add_form=add_form)

    return render_template('AddWish2.html', add_form=add_form)


@app.route('/updateWish', methods=['GET', 'POST'])
def update_wish():
    update_form = UpdateWishlist()
    subject_list = getSubjects(session['email'])
    update_form.subject_list.choices = [(int(subject_list.index(currents)), currents) for currents in subject_list]
    if request.method == 'POST':
        if update_form.validate() == False:
            return render_template('UpdateWish.html', update_form=update_form)

        else:
            if update_form.add.data:
                result = updateWishlist(
                    subject=subject_list[int(request.form['subject_list'])][0],
                    wish_date=datetime.strptime(request.form['begin'], "%d-%m-%Y %H:%M"),
                    teacher_email=session['wish_teacher'],
                    wish_id=session['wish_id'])
                if result != 'ok':
                    return render_template('UpdateWish.html', update_form=update_form, result=result)
                return render_template('UpdateWish.html', update_form=update_form)

    return render_template('UpdateWish.html', update_form=update_form)
@app.route('/showStat', methods=['GET','POST'])
def show_stat():
    first_stat = getSubj()
    second_stat = getUsersRole()
    labels = [str(cur[0]) for cur in second_stat]
    values = [cur[1] for cur in second_stat]
    consult_res=go.Pie(labels=labels, values=values)

    count_res =go.Bar(
        x=[cur[0] for cur in first_stat],
        y=[cur[1] for cur in first_stat]
    )
    dataPie = [consult_res]
    dataBar = [count_res]
    graphJSONbar = json.dumps(dataBar, cls=plotly.utils.PlotlyJSONEncoder)
    graphJSONPie = json.dumps(dataPie, cls=plotly.utils.PlotlyJSONEncoder)
    return render_template('statistic.html', graphJSONbar=graphJSONbar, graphJSONPie=graphJSONPie)


if __name__ == "__main__":
    app.run()