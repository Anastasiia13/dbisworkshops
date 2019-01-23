from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, validators

class UserDelete(FlaskForm):
    deleteUser = StringField('Видалити користувача: ', validators=[validators.DataRequired('Required')])
    deletebutton = SubmitField('Видалити')