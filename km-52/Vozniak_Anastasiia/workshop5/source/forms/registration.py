from flask_wtf import Form
from wtforms import TextField, StringField, IntegerField, TextAreaField, SubmitField, RadioField, SelectField, \
    PasswordField
from flask import Flask, render_template, request, flash
from wtforms import validators, ValidationError


class RegForm(Form):
    user_role = RadioField("Роль", choices=[('S', 'Студент'), ('T', 'Викладач')])

    user_name = StringField("Ім'я", [validators.DataRequired("Будь-ласка, введіть ім'я"),
                                         validators.Length(2, 25, "Довжина від 2 до 25 символів")])

    mid_name = StringField("По-батькові", [validators.DataRequired("Будь-ласка, введіть по-батькові"),
                                            validators.Length(2, 25, "Довжина від 2 до 25 символів")])

    user_surname = StringField("Прізвище", [validators.DataRequired("Будь-ласка, введіть прізвище"),
                                            validators.Length(2, 25, "Довжина від 2 до 25 символів")])

    user_email = StringField("Email", [validators.Email("Ваш email некоректний")])

    user_password = PasswordField("Пароль", [validators.DataRequired("Будь-ласка, введіть пароль"),
                                                 validators.Length(6, 20, "Довжина від 6 до 20 символів")])

    submit = SubmitField("ОК")