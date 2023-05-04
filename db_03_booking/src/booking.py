"""
CS3810: Principles of Database Systems
Instructor: Thyago Mota
Student(s): Zonera Nasir 
Description: A room reservation system
"""

import psycopg2
from psycopg2 import extensions, errors
import configparser as cp
from datetime import datetime

def menu(): 
    print('1. List')
    print('2. Reserve')
    print('3. Delete')
    print('4. Quit')

def db_connect():
    config = cp.RawConfigParser()
    config.read('ConfigFile.properties')
    params = dict(config.items('db'))
    conn = psycopg2.connect(**params)
    conn.autocommit = False
    conn.set_isolation_level(extensions.ISOLATION_LEVEL_SERIALIZABLE) 
    with conn.cursor() as cur: 
        cur.execute('''
            PREPARE QueryReservationExists AS 
                SELECT * FROM Reservations 
                WHERE abbr = $1 AND room = $2 AND date = $3 AND period = $4;
        ''')
        cur.execute('''
            PREPARE QueryReservationExistsByCode AS 
                SELECT * FROM Reservations 
                WHERE code = $1;
        ''')
        cur.execute('''
            PREPARE NewReservation AS 
                INSERT INTO Reservations (abbr, room, date, period) VALUES
                ($1, $2, $3, $4);
        ''')
        cur.execute('''
            PREPARE UpdateReservationUser AS 
                UPDATE Reservations SET "user" = $1
                WHERE abbr = $2 AND room = $3 AND date = $4 AND period = $5; 
        ''')
        cur.execute('''
            PREPARE DeleteReservation AS 
                DELETE FROM Reservations WHERE code = $1;
        ''')
    return conn

# TODO: display all reservations in the system using the information from ReservationsView
def list_op(conn):
    with conn.cursor() as cur:
        cur.execute('SELECT * FROM ReservationsView;')
        rows = cur.fetchall()
        print('\nReservations:\n')
        print(" code  |     date     |   period   |    start    |      end     |    room    |   name")
        print("-------+--------------+------------+-------------+--------------+------------+----------------")
        for row in rows:
            code = str(row[0])
            date = row[1].strftime('%Y-%m-%d')
            period = row[2]
            start = row[3].strftime('%H:%M:%S')
            end = row[4].strftime('%H:%M:%S')
            building_room = row[5]
            name = row[6]
            print(f"    {code}  |  {date}  |\t    {period}\t   |   {start}  |   {end}   |   {building_room}  |   {name}")
        print('')
    # CHECKED AND WORKING

# TODO: reserve a room on a specific date and period, also saving the user who's the reservation is for
def reserve_op(conn):
    abbr = input('Abbreviation(AES/JSS): ')
    room = input('Room(210/230): ')
    date = input('Date (YYYY-MM-DD): ')
    period = input('Period (A-H): ')
    user = input('User(1-3): ')

    with conn.cursor() as cur:
        # Wrapped in try/except to rollback if error occurs
        try : 
            # check if reservation exists
            cur.execute('EXECUTE QueryReservationExists (%s, %s, %s, %s);', (abbr, room, date, period))
            existing_reservation = cur.fetchone()
            if existing_reservation is not None:
                print('\nA reservation already exists for the provided room, date, and period.\n')
                conn.rollback()

            # Creates new reservation if it doesn't exist
            else:
                print('\nCreating New Reservation...\n')
                # create reservation
                cur.execute('EXECUTE NewReservation (%s, %s, %s, %s);', (abbr, room, date, period))
                cur.execute('EXECUTE UpdateReservationUser (%s, %s, %s, %s, %s);', (user, abbr, room, date, period))
                conn.commit()

                # print reservation code
                cur.execute('SELECT code FROM Reservations WHERE abbr = %s AND room = %s AND date = %s AND period = %s;', (abbr, room, date, period))
                code = cur.fetchone()[0]
                print(f'Reservation created with code {code}.\n')
        except:
            conn.rollback()
            print('\nError: Reservation could not be created.\n')

    # CHECKED AND WORKING

# TODO: delete a reservation given its code
def delete_op(conn):
    code = input('\nPlease Enter Reservation Code you wish to delete: ')
    with conn.cursor() as cur:
        try:
            cur.execute('EXECUTE QueryReservationExistsByCode (%s);', (code,))
            if cur.fetchone() is None:
                conn.rollback()
                print('Reservation not found.')
            else:
                
                cur.execute('EXECUTE DeleteReservation (%s);', (code,))
                conn.commit()
                print('\nReservation Successfully Deleted!\n')
        except:
            conn.rollback()
            print('\nError: Reservation could not be deleted.\n')
    # CHECKED AND WORKING

if __name__ == "__main__":
    with db_connect() as conn:
        op = 0
        while op != 4: 
            menu()
            op = int(input('\nEnter your option: '))
            if op == 1: 
                list_op(conn)
            elif op == 2:
                reserve_op(conn)
            elif op == 3:
                delete_op(conn)
            elif op == 4:
                print ('Goodbye!')