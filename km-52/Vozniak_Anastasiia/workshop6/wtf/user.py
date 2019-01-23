from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, validators, PasswordField, RadioField

class UserForm(FlaskForm):
    role = RadioField("", choices=[('Викладач', 'Викладач'), ('Студент', 'Студент')], validators=[validators.DataRequired('Required')])
    name = StringField('Ім`я: ', validators=[validators.DataRequired('Required')])
    midname = StringField('По-батькові: ', validators=[validators.DataRequired('Required')])
    surname = StringField('Прізвище: ', validators=[validators.DataRequired('Required')])
    email = StringField('Email: ', validators=[validators.DataRequired('Required')])
    password = PasswordField('Password: ', validators=[validators.DataRequired('Required')])
    back = SubmitField('<- Назад')
    addbutton = SubmitField('Додати')