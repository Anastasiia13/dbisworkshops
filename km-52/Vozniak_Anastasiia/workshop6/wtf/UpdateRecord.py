from flask_wtf import FlaskForm
from wtforms import SubmitField, RadioField, StringField, DateTimeField, SelectField


class UpdateRecord(FlaskForm):
    back = SubmitField('<- Назад')
    begin =StringField('Дата')
    add = SubmitField('OK')