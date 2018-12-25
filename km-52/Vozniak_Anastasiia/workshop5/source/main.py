from flask import Flask, render_template, request, flash, session, url_for, redirect, make_response
from forms.registration import RegForm
from forms.login import LoginForm
from forms.work_with_consultation import ConsultForm
from dao.functions_for_user import *
from datetime import datetime, timedelta

main = Flask(__name__)
main.secret_key = 'development key'


@main.route('/', methods=['POST', 'GET'])
def index():
    form = ConsultForm()

    consultlist = getConsult(session['user_email'])
    if request.method == 'POST':
        if not form.validate():
            user_email = session['user_email']
            return render_template('index.html', form=form, user_email=user_email, is_exist='')
        else:
            user_email = session['user_email']
            is_exist = False
            for file in consultlist:
                if file[0] == request.form['cons_id']:
                    is_exist = True
                    break

            if is_exist:
                if request.form['operation'] == 'U':
                    consult = updateConsult(
                        request.form['subject'],
                        request.form['classroom'],
                        request.form['building'],
                        request.form['cons_begin'],
                        request.form['cons_end'],
                        request.form['cons_id']
                    )
                elif request.form['operation'] == 'D':
                    consult = deleteConsult(
                        request.form['cons_id']
                    )
                elif request.form['operation'] == 'A':
                    consult = addConsult(
                        request.form['user_email'],
                        request.form['subject'],
                        request.form['classroom'],
                        request.form['building'],
                        request.form['cons_begin'],
                        request.form['cons_end']
                    )
                return render_template('index.html', form=form, user_email=user_email, is_exist='%s successfully changed' % consult)
            else:
                return render_template('index.html', form=form, user_email=user_email, is_exist='current consultation does not exist.')
    else:
        if 'user_email' in session:
            user_email = session['user_email']
            if user_email is None:
                return "<div>You are not logged in <br><a href = '/login'></b>" + "Click here to log in</b></a><br>" + \
                       "<a href='/registration'></b>Or here to create an account</b></a></div>"
            return render_template('index.html', form=form, user_email=user_email, is_exist='')
        else:
            user_email = request.cookies.get('user_email')
            session['user_email'] = user_email
            if user_email is None:
                return "<div>You are not logged in <br><a href = '/login'></b>" + "Click here to log in</b></a><br>" + \
                       "<a href='/registration'></b>Or here to create an account</b></a></div>"
            else:
                return render_template('index.html', form=form, user_email=user_email, is_exist='')


@main.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    userList = getUserList()

    if request.method == 'POST':
        if not form.validate():
            return render_template('login.html', form=form, is_exist='')
        else:
            is_exist = False
            for user in userList:
                if user[0] == request.form['user_email']:
                    is_exist = True
                    break

            if is_exist:
                session['user_email'] = request.form['user_email']
                response = make_response(redirect(url_for('index')))
                expires = datetime.now()
                expires += timedelta(weeks=10)
                response.set_cookie('user_email', request.form['user_email'], expires=expires)
                return response
            else:
                return render_template('login.html', form=form, is_exist='User with current email does not exists.')
    else:
        if 'user_email' in session:
            return render_template('login.html', form=form, is_exist='')
        else:
            user_email = request.cookies.get('user_email')
            session['user_email'] = user_email
            if user_email is None:
                return render_template('login.html', form=form, is_exist='')
            else:
                return redirect(url_for('index'))


@main.route('/registration', methods=['GET', 'POST'])
def registration():
    form = RegForm()

    userList = getUserList()
    if request.method == 'POST':
        if not form.validate():
            return render_template('registration.html', form=form, is_unique='')
        else:
            is_unique = True
            for user in userList:
                if user[0] == request.form['login']:
                    is_unique = False
                    break

            if not is_unique:
                return render_template('registration.html', form=form, is_unique='User with current email already exists.')
            else:
                user_email = regUser(
                    request.form['user_role'],
                    request.form['user_name'],
                    request.form['mid_name'],
                    request.form['user_surname'],
                    request.form['user_email'],
                    request.form['user_password']
                )

                session['user_email'] = user_email
                response = make_response(redirect(url_for('index')))
                expires = datetime.now()
                expires += timedelta(weeks=10)
                response.set_cookie('login', user_email, expires=expires)
                return response

    return render_template('registration.html', form=form, is_unique='')


@main.route('/logout')
def logout():
    session.pop('user_email', None)
    response = make_response(redirect(url_for('index')))
    response.set_cookie('user_email', '', expires=0)
    return response


if __name__ == '__main__':
    main.run(debug=True)