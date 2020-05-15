from flask import flash, request, Blueprint, render_template, redirect, session, flash, url_for
from HM.database import *

patient = Blueprint('patient',__name__)
db = database()

def is_logged_in(): 
    if 'username' in session:
        return True
    else:
        return False


@patient.route('/payment')
def payment():
    return render_template('payment.html')