from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, DateTimeField, SelectField


class ChooseTeacher(FlaskForm):
    back = SubmitField('<- Назад')
    teachers = RadioField('Викладачі',coerce=int)
    add = SubmitField('OK')


class Consults(FlaskForm):
    back = SubmitField('<- Назад')
    consult_list = RadioField('Консультації', coerce=int)
    add = SubmitField('OK')


class AddRecord(FlaskForm):
    back = SubmitField('<- Назад')
    begin = DateTimeField(' Початок', format = "%d-%m-%Y %H:%M")
    add = SubmitField('OK')
