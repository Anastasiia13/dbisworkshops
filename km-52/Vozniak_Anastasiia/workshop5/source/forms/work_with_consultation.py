from flask_wtf import Form
from wtforms import TextField, StringField, IntegerField, TextAreaField, SubmitField, RadioField, SelectField, \
    PasswordField, DateField, HiddenField
from flask import Flask, render_template, request, flash
from wtforms import validators, ValidationError


class ConsultForm(Form):

    user_email = HiddenField("email", [validators.DataRequired("email")])

    subject = StringField("subject", [validators.DataRequired("Please, enter subject.")])

    classroom = StringField("classroom", [validators.DataRequired("Please, enter classroom")])

    building = StringField("building", [validators.DataRequired("Please, enter building")])

    cons_begin = DateField('Start', format='%d-%m-%Y %h-%m', validators=(validators.Optional(),))

    cons_end = DateField('End', format='%d-%m-%Y %h-%m', validators=(validators.Optional(),))

    operation = RadioField("Type of operation", choices=[('U', 'Update'), ('A', 'Add'), ('D', 'Delete')])

    submit = SubmitField("OK")