from wtforms import TextField, StringField, IntegerField, TextAreaField, SubmitField, RadioField, SelectField, PasswordField
from flask import Flask, render_template, request, flash
from wtforms import validators, ValidationError
from flask_wtf import Form

class LoginForm(Form):
    email = StringField("User`s email", [validators.DataRequired("Please, enter your email."),
                                         validators.Length(8, 35, "Email consists of minimum 8 symbols, maximum - 35")])

    password = PasswordField("User`s Password", [validators.DataRequired("Please, enter your password."),
                                                 validators.Length(8, 20, "Password consists of min 8 symbols, max-20")])

    submit = SubmitField("OK")