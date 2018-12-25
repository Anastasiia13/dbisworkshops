from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)
consult_dictionary = {
    "user_email": "serg@gmail.com",
    "subject": "АСД",
    "consult_begin": "01-12-2018 13:00"
}

class_dictionary = {
    "class_number": "10а",
    "building": "20"
}
available_dictionary = dict.fromkeys(['consultation', 'classroom', 'all'], "dictionary_name")


@app.route('/api/<action>', methods=['GET'])
def apiget(action):
    if action == "consultation":
        return render_template("consultation.html", consultation=consult_dictionary)

    elif action == "classroom":
        return render_template("classroom.html", classroom=class_dictionary)

    elif action == "all":
        return render_template("all.html", consultation=consult_dictionary, classroom=class_dictionary)

    else:
        return render_template("404.html", action_value=action)


@app.route('/api', methods=['POST'])
def apipost():

    if request.form["action"] == "consult_update":
        consult_dictionary["user_email"] = request.form["email"]
        consult_dictionary["subject"] = request.form["subj"]
        consult_dictionary["consult_begin"] = request.form["begin"]
        return redirect(url_for('apiget', action="all"))


@app.route('/api', methods=['POST'])
def apipost1():

    if request.form["action"] == "class_update":
        class_dictionary["class_number"] = request.form["number"]
        class_dictionary["building"] = request.form["build"]
        return redirect(url_for('apiget', action="all"))


if __name__ == '__main__':
    app.run(debug=True)
