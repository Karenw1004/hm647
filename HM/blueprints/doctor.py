from flask import flash, request, Blueprint, render_template, redirect, session, flash, url_for
from HM.database import *

doctor = Blueprint('doctor',__name__)
db = database()

def is_logged_in(): 
    if 'username' in session:
        return True
    else:
        return False

@doctor.route('/dashboard', methods=['GET','POST'])
def dashboard():
    if (is_logged_in()):
        count_dict = database().number_dict()
        return render_template('dashboard.html', count_dict=count_dict)
    else:
        flash('You are not logged in ','warning')
        return redirect(url_for('auth.login'))

@doctor.route('/patient')
def patient():
    if (is_logged_in()):
        data = db.get_all_patient_info_list()
        return render_template('patient.html', data=data)
    else:
        flash('You are not logged in ','warning')
        return redirect(url_for('auth.login'))

@doctor.route('/treatment')
def treatment():
    if (is_logged_in()):
        data = db.get_all_treatment_list()
        icon_list = ['viruses','radiation-alt','disease','crutch','dna','capsules','dumbbell','flask','assistive-listening-systems', 'brain']
        return render_template('treatment.html', data=data, list= icon_list)
    else:
        flash('You are not logged in ','warning')
        return redirect(url_for('auth.login'))


