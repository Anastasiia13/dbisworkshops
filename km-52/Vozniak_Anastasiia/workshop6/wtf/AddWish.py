from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, DateTimeField, SelectField


class ChooseTeacher(FlaskForm):
    back = SubmitField('<- Назад')
    teachers = RadioField('Викладачі',coerce=int)
    add = SubmitField('OK')


class Subjects(FlaskForm):
    back = SubmitField('<- Назад')
    subject_list = RadioField('Тема', coerce=int)
    add = SubmitField('OK')


class AddWish(FlaskForm):
    back = SubmitField('<- Назад')
    begin = DateTimeField(' Початок', format = "%d-%m-%Y %H:%M")
    add = SubmitField('OK')
