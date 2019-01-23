from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField


class AbcForm(FlaskForm):
    back = SubmitField('<- Назад')
    country = StringField('country')
    submit = SubmitField('ok')
