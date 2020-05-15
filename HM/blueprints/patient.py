from flask import flash, request, Blueprint, render_template, redirect, session, flash, url_for
from HM.database import *

patient = Blueprint('patient',__name__)
db = database()

def is_logged_in(): 
    if 'username' in session:
        return True
    else:
        return False


@patient.route('/paysearch', methods=['GET','POST'])
def payment():
    if (request.method == "POST"):
        name = request.form["name"].lower()
        sex = request.form["sex"]
        blood = request.form["blood"]

        print(name)
        print(sex)
        print(blood)

        db.get_bill(name,sex,blood)

        return render_template('paysearch.html')

    else:
        return render_template('paysearch.html')