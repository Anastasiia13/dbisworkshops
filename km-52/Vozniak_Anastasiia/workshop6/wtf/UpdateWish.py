from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, DateTimeField, SelectField


class UpdateWishlist(FlaskForm):
    back = SubmitField('<- Назад')
    subject_list = RadioField('Предмет',coerce=int)
    begin = DateTimeField(' Початок', format = "%d-%m-%Y %H:%M")
    add = SubmitField('OK')
    # update = SubmitField('Редагувати')