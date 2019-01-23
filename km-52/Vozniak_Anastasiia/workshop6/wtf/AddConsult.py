from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, DateTimeField

class AddConsult(FlaskForm):
    back = SubmitField('<- Назад')
    subject = StringField('Предмет')
    classroom = StringField(' Аудиторія')
    build = StringField('Корпус ')
    begin = DateTimeField(' Початок', format = "%d-%m-%Y %H:%M")
    cons_end = DateTimeField(' Кінець', format = "%d-%m-%Y %H:%M")
    add = SubmitField('OK')
    # update = SubmitField('Редагувати')