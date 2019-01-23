from flask_wtf import FlaskForm
from wtforms import SubmitField

class first_pageF(FlaskForm):
    auth = SubmitField("Авторизація")
    reg = SubmitField("Реєстрація")
    logout = SubmitField("Вийти")
    abc = SubmitField("count")
    show_consult = SubmitField("Консультації")
    show_records = SubmitField("Записи")
    show_wishlist = SubmitField("Список побажань")
    show_users = SubmitField("Користувачі")
    show_stat = SubmitField("Статистика")