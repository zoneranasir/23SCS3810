"""
CS3810: Principles of Database Systems
Instructor: Thyago Mota
Student(s): Zonera Nasir 
Description: A data load script for the IPPS database
"""

import psycopg2
import configparser as cp
import csv 

# Load database connection parameters from ConfigFile.properties
config = cp.RawConfigParser()
config.read('ConfigFile.properties')
params = dict(config.items('db'))

conn = None

# Connect to the PostgreSQL database
conn = psycopg2.connect(**params)

if conn: 
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')
    
    # Set the file path for the CSV data
    path = './MUP_IHP_RY22_P02_V10_DY20_PrvSvc.csv'
    
    with open(path, 'r') as file:
        reader = csv.reader(file)
        next(reader) # Skip header row

        with conn.cursor() as cursor:
            for row in reader:
                # Define SQL statements for inserting data into tables
                # Define SQL statements for inserting data into tables
                provider_sql = """INSERT INTO providers (Rndrng_Prvdr_CCN, Rndrng_Prvdr_Org_Name, Rndrng_Prvdr_St, Rndrng_Prvdr_City, Rndrng_Prvdr_State_Abrvtn, Rndrng_Prvdr_State_FIPS, Rndrng_Prvdr_Zip5, Rndrng_Prvdr_RUCA, Rndrng_Prvdr_RUCA_Desc)
                VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s) ON CONFLICT (Rndrng_Prvdr_CCN) DO NOTHING;"""

                diagnosis_sql = "INSERT INTO diagnosis (DRG_Cd, DRG_Desc) VALUES (%s, %s) ON CONFLICT (DRG_Cd) DO NOTHING;"

                inpatient_hospital_service_sql = """INSERT INTO Inpatient_Hospital_Service(Rndrng_Prvdr_CCN, DRG_Cd, Tot_Dschrgs, 
                Avg_Submtd_Cvrd_Chrg, Avg_Tot_Pymt_Amt, Avg_Mdcr_Pymt_Amt) VALUES (%s, %s, %s, %s, %s, %s) 
                ON CONFLICT (Rndrng_Prvdr_CCN, DRG_Cd) DO NOTHING;"""

                provider_values = (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8])
                cursor.execute(provider_sql, provider_values)

                diagnosis_values = (row[9], row[10])
                cursor.execute(diagnosis_sql, diagnosis_values)


                ihs_values = (row[0], row[9], int(row[11]), float(row[12]), float(row[13]), float(row[14]))
                cursor.execute(inpatient_hospital_service_sql, ihs_values)

print('Data loaded successfully!')
conn.commit()
print('Bye!')
conn.close()