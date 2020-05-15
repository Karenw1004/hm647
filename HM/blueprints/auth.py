from flask import flash, request, Blueprint, render_template, redirect, session, flash, url_for
from HM.database import *

auth = Blueprint('auth',__name__)
db = database()

def is_logged_in(): 
    if 'username' in session:
        return True
    else:
        return False
@auth.route('/')
def index():
    return render_template('index.html')

@auth.route('/login', methods=['GET','POST'])
def login():
    if (request.method == "POST"):
        username = request.form["username"].lower()
        password = request.form["password"]

        result = db.login(username, password)
        if (result != False):
            session['username'] = result[0][1].lower()
            session['password'] = result[0][2]
            session['name']= result[0][3]
            flash('You were successfully logged in','success')
            return redirect(url_for('doctor.dashboard'))
        else:
            flash('Invalid credentials','error')
            return render_template('login.html') 
    else:
        return render_template('login.html')

@auth.route('/register',methods=["GET", "POST"])
def register():
    if request.method == "POST":
        name = request.form.get("name")

        username = request.form.get("username").lower()
        password1 = request.form.get("password1")
        password2 = request.form.get("password2")

        if (password1 != password2):
            flash('Password do not match','error')
            return render_template('register.html')
        else:
            register_success = db.register(username, password1, name)
            if (register_success):
                flash(f'User {username} has been successfully created','success')
                return redirect(url_for('auth.login'))

            else:
                flash(f'User {username} has already exist','error')
                return redirect(url_for('auth.register'))

    else:
        print("lol")
        return render_template('register.html')


@auth.route('/logout')
def logout():
    session.clear()
    flash('You have logged out ','info')
    return redirect(url_for('auth.login'))
