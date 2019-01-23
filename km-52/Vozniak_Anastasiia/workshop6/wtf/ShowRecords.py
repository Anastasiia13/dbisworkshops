from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, validators

class ShowRecords(FlaskForm):
    record_list = RadioField("Список записів: ", coerce=int)
    back = SubmitField('<- Назад')
    delete = SubmitField('Видалити')
    add = SubmitField('Додати')
    update = SubmitField('Редагувати')
