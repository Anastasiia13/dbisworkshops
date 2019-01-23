from flask_wtf import FlaskForm
from wtforms import  SubmitField, RadioField

class UserShow(FlaskForm):
    user_list = RadioField("Користувачі", coerce=int)
    back = SubmitField('<- Назад')
    delete = SubmitField('Видалити')
    update = SubmitField('Редагувати')