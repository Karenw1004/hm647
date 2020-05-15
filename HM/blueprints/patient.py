from flask import flash, request, Blueprint, render_template, redirect, session, flash, url_for
from HM.database import *

patient = Blueprint('patient',__name__)
db = database()

def is_logged_in(): 
    if 'username' in session:
        return True
    else:
        return False


@patient.route('/payment', methods=['GET','POST'])
def payment():
    if (request.method == "POST"):
        name = request.form["name"].lower()
        sex = request.form["sex"]
        blood = request.form["blood"]

        list_of_treament_and_one_sum = db.get_bill(name,sex,blood)

        return render_template('bill.html', data=list_of_treament_and_one_sum , name=name, sex=sex, blood=blood)

    else:
        return render_template('payment.html')

@patient.route('/update_bill', methods=['POST'])
def update_bill():
    if (request.method == "POST"):
        
        return redirect(url_for('patient.payment'))
    else:
        return render_template('payment.html')
