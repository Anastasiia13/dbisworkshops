from flask_wtf import FlaskForm
from wtforms import  SubmitField, RadioField,StringField, validators

class ShowWishlist(FlaskForm):
    wish_list = RadioField("Список побажань", coerce=int)
    back = SubmitField('<- Назад')
    delete = SubmitField('Видалити')
    choose = SubmitField('Вибрати')
    add = SubmitField('Додати')
    update = SubmitField('Редагувати')