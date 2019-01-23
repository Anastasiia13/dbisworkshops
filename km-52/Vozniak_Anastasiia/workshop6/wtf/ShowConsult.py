from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, DateTimeField


class ShowConsult(FlaskForm):
    back = SubmitField('<- Назад')
    consult_list = RadioField("Список консультацій: ", coerce=int)
    delete = SubmitField('Видалити')
    add = SubmitField('Додати')
    update = SubmitField('Редагувати')
    # filter_d = StringField('По даті: ')
    # filter_t = StringField('По темі: ')
    # filtering = SubmitField('Сортувати: ')



