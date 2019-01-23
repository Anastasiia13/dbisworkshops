from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, DateTimeField, SelectField


class UpdateConsult(FlaskForm):
    back = SubmitField('<- Назад')
    subject_list = RadioField('Предмет',coerce=int)
    classroom = StringField(' Аудиторія')
    build = StringField('Корпус ')
    begin = DateTimeField(' Початок', format = "%d-%m-%Y %H:%M")
    cons_end = DateTimeField(' Кінець', format = "%d-%m-%Y %H:%M")
    add = SubmitField('OK')
    # update = SubmitField('Редагувати')