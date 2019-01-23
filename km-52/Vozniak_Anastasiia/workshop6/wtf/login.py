from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, validators, PasswordField, BooleanField


class LoginForm(FlaskForm):
    back = SubmitField('<- Назад')
    email = StringField('email: ', validators=[validators.DataRequired('Required')])
    password = PasswordField('пароль: ', validators=[validators.DataRequired('Required')])
    # remember_me = BooleanField('Запам"ятати')
    submit = SubmitField('Вхід')