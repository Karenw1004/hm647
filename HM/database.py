import mysql.connector
import bcrypt

class database:
    def __init__(self):
        self.conn = 0
        self.mycursor = 0
        self.working = False
        try:
            self.conn = mysql.connector.connect(user='karenws',password='eiR4eiyi',host='mysql.eecs.ku.edu',database='karenws',charset='utf8')
            self.mycursor = self.conn.cursor(buffered=True)
            self.working = True
        except ImportError:
            print("database() error: MySQL-Connector could not be imported")
        except mysql.connector.Error as err:
            print("database() error: {}".format(err))
    
    def login(self, username, password):
        """ 
        Check user credential 
        
        Param:
        - username (str)
        - password (str)
        Return:
        - (bool)
        """
        if (self.working):
            
            self.mycursor.execute(f"SELECT * from doctor where USERNAME='{username}'")
            result = self.mycursor.fetchall()
            print("HERE")
            if len(result) == 1:
                # Check if password match
                if bcrypt.checkpw(password.encode(), result[0][2].encode()):
                    return result
                else:
                    return False # Wrong Password
            else:
                return False
            
        else:
            return False # Have not set the mysql connector
    def number_dict(self):
        if (self.working):
            self.mycursor.execute("SHOW TABLES")
            table_name_list = self.mycursor.fetchall()

            result_dict = {}
            
            for table_name_tuple in table_name_list:
                table_name = table_name_tuple[0]
                if (table_name=="bed" or table_name=="doctor" or table_name=="patient" or table_name=="treatment"):
                    self.mycursor.execute(f"SELECT COUNT(*) FROM {table_name}")
                    result_dict[table_name] = self.mycursor.fetchone()[0]     

            return result_dict
        else:
            return False
    def get_all_patient_info_list(self):
        if (self.working):
            self.mycursor.execute(f"SELECT * FROM patient")
            result = self.mycursor.fetchall()
            
            result_list = []
            
            for patient_id, name, sex, blood, heart, temp, pulse, bed, room in result:
                temp_dict = {}
                temp_dict["PATIENT_ID"] = patient_id
                temp_dict["NAME"] = name
                temp_dict["SEX"] = sex
                temp_dict["BLOOD"] = blood
                temp_dict["HEART_RATE"] = heart
                temp_dict["TEMPERATURE"] = temp
                temp_dict["PULSE"] = pulse
                result_list.append(temp_dict) 
            return result_list
            
        else:
            return False
    def register(self, username, password, fullname):
        if (self.working):
                self.mycursor.execute(f"SELECT NAME FROM doctor WHERE USERNAME='{username}';")
                result = self.mycursor.fetchall()
                
                if len(result) == 0: #if none, it is a good username
                    # Hash password
                    salt = bcrypt.gensalt()
                    OK = bcrypt.hashpw("admin".encode("utf-8"), salt)
                    LOL = OK.decode("utf-8")
                    print(LOL)
                    hashed = bcrypt.hashpw(password.encode("utf-8"), salt)
                    password = hashed.decode("utf-8")

                    self.mycursor.execute("SELECT MAX(DOCTOR_ID) FROM doctor;")
                    the_last_id = self.mycursor.fetchone()[0]  
                    
                    sql = ("INSERT INTO `doctor`(`DOCTOR_ID`, `USERNAME`, `PASSWORD`, `NAME`, `IS_AT_WORK`) VALUES (%s, %s, %s, %s, %s) ")
                    val = (int(the_last_id+1), username, password, fullname,b'0')
                    self.mycursor.execute(sql, val)
                    self.conn.commit()
                    return True
                else:
                    return False
        else:
            return False # Not connected to server
    def get_all_treatment_list(self):
        if (self.working):
            self.mycursor.execute(f"SELECT * FROM treatment")
            result = self.mycursor.fetchall()
            
            result_list = []
            
            for treament_id, name, price in result:
                temp_dict = {}
                temp_dict["TREATMENT_ID"] = treament_id
                temp_dict["NAME"] = name
                temp_dict["PRICE"] = price
                result_list.append(temp_dict) 
            return result_list
            
        else:
            return False
    def get_bill(self, name,sex,blood):
        if (self.working):
            # Get the list of treatment price and name of a certain patient name sex and blood
            self.mycursor.execute(f'''
            SELECT patient.PATIENT_ID, treatment.NAME, treatment.PRICE
            FROM patient
            JOIN prescribe on prescribe.PATIENT_ID = patient.PATIENT_ID
            JOIN treatment on prescribe.TREATMENT_ID= treatment .TREATMENT_ID
            WHERE patient.NAME='{name}' AND patient.SEX='{sex}' AND patient.BLOOD='{blood}'
            ''')
            result = self.mycursor.fetchall()

            if len(result) == 0: #
                return False
            else:
                result_list = []
                
                treatment_list = []
                for patient_id, treatment_name , treatment_price in result:
                    temp_dict = {}
                    temp_dict["NAME"] = treatment_name
                    temp_dict["PRICE"] = treatment_price
                    treatment_list.append(temp_dict) 

    
                # Get the sum of treatment price of a certain patient name sex and blood
                self.mycursor.execute(f'''
                    SELECT SUM(treatment.PRICE)
                    FROM patient
                    JOIN prescribe on prescribe.PATIENT_ID = patient.PATIENT_ID
                    JOIN treatment on prescribe.TREATMENT_ID= treatment .TREATMENT_ID
                    WHERE patient.NAME='{name}' AND patient.SEX='{sex}' 
                    AND patient.BLOOD='{blood}' AND prescribe.IS_PAID=0
                    GROUP BY patient.PATIENT_ID
                ''')
                total_treatment_price = self.mycursor.fetchone()
                total_treatment_price = total_treatment_price[0]

                result_list.append(treatment_list)
                result_list.append(total_treatment_price)
                result_list.append(result[0][0])
                
                return result_list
        else:
            return False

    def pay_bill(self,patient_id):
        if (self.working):
            # Update the attribute to is paid when you click the pay button
            self.mycursor.execute(f'''UPDATE prescribe SET IS_PAID=1 WHERE PATIENT_ID={patient_id}''')
            self.conn.commit()   
                
            return True
        else:
            return False

    def remove_treatment(self,treament_id):
        if (self.working):
            # Delete the treatment that has the same treatment_id 
            self.mycursor.execute(f"DELETE FROM treatment where TREATMENT_ID='{treament_id}' " )
            self.conn.commit()   
                
            return True
        else:
            return False