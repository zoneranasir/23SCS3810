-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student: Zonera Nasir 
-- Description: Exam 2 Take Home


--Q1
--Create all the tables after normalization and populate them with the information from the (unnormalized) table.

CREATE DATABASE exam2;

\c exam2

--Create and populate table Employees. Create trigger function doit and trigger trigger_doit. Simulate the insert of the new employee named Paul and copy and paste the result of querying Paul's salary (as a comment in the script).

--Create Cars table
CREATE TABLE Cars(
    plate_number VARCHAR(10) PRIMARY KEY,
    car_type VARCHAR(20) NOT NULL,
    base_rent NUMERIC NOT NULL
);

--Insert into Cars table 
INSERT INTO Cars (plate_number, car_type, base_rent)
VALUES ('XYZ-123', 'sedan', 40.00),
       ('ZZW-444', 'suv', 60.00),
       ('KKK-001', 'suv', 60.00);

--Create Customers Table
CREATE TABLE Customers(
    cust_id INTEGER PRIMARY KEY,
    cust_name VARCHAR(15)
);

INSERT INTO Customers(cust_id,cust_name)
VALUES (101, 'Sam'),
       (202, 'Jill');

-- Create Features table
CREATE TABLE Features (
    feature_id INT PRIMARY KEY,
    feature_descr VARCHAR(255),
    feature_price DECIMAL(10, 2)
);

INSERT INTO Features (feature_id, feature_descr, feature_price)
VALUES (1, 'gps', 10.00),
       (2, 'full tank', 40.00),
       (3, 'ezpass', 15.00),
       (4, 'self-driving', 200.00);

-- Create Rentals table
CREATE TABLE Rentals (
    plate_number VARCHAR(10),
    cust_id INT,
    date_rental DATE,
    feature_id INT,
    PRIMARY KEY (plate_number, cust_id, date_rental),
    FOREIGN KEY (plate_number) REFERENCES Cars (plate_number),
    FOREIGN KEY (cust_id) REFERENCES Customers (cust_id),
    FOREIGN KEY (feature_id) REFERENCES Features (feature_id)
);

INSERT INTO Rentals (plate_number, cust_id, date_rental, feature_id)
VALUES ('XYZ-123', 101, '2023-01-01', 1),
       ('XYZ-123', 101, '2023-01-01', 2),
       ('XYZ-123', 101, '2023-01-01', 3),
       ('ZZW-444', 202, '2023-01-02', 1),
       ('KKK-001', 101, '2023-03-05', 1),
       ('KKK-001', 101, '2023-02-05', 2),
       ('KKK-001', 101, '2023-02-05', 4);

--Q2
--Create and populate table **Employees**. 
CREATE TABLE Employees(
    ssn INT PRIMARY KEY,
    name TEXT NOT NULL,
    sal DECIMAL(10,2) NOT NULL,
    sup INT,
    FOREIGN KEY (sup) REFERENCES Employees (ssn)
);

INSERT INTO Employees(ssn, name, sal, sup)
VALUES (123456, 'Joe', 65.00, NULL),
       (456789, 'Marta', 75.00, NULL);


--Create trigger function **doit** and trigger **trigger_doit**. 
CREATE function doit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE sup_sal DECIMAL(10,2);
    BEGIN
        sup_sal := (
            SELECT sal FROM Employees WHERE ssn = NEW.sup
        );
        IF NEW.sup IS NOT NULL AND NEW.sal > sup_sal THEN 
            NEW.sal = sup_sal;
        END IF;
        RETURN NEW;
    END;
$$;

--DROP FUNCTION IF EXISTS doit();

CREATE TRIGGER trigger_doit
    BEFORE INSERT ON Employees
    FOR EACH ROW 
        EXECUTE PROCEDURE doit();


--Simulate the insert of the new employee named Paul and copy and paste the result of querying Paul's salary (as a comment in the script).
-- Inserting Paul with a salary of 80.00 and sup as 456789
INSERT INTO Employees VALUES
(678901, 'Paul', 90.00, 456789);

-- Querying Paul's salary
SELECT sal FROM Employees WHERE name = 'Paul';

/*
exam2=# SELECT sal FROM Employees WHERE name = 'Paul';
  sal  
-------
 75.00
(1 row)
*/



--Q3
--Create and populate table Visitors. Write all SQL statements asked in the exam (a, b, and c).

CREATE TABLE Visitors(
    id SERIAL PRIMARY KEY,
    date_time TIMESTAMP NOT NULL,
    floor INT NOT NULL,
    left_building BOOLEAN
);

INSERT INTO Visitors (date_time,floor, left_building)
VALUES('2023-04-01 10:00:00', 5, 'f'),
      ('2023-04-01 10:15:00', 3, 't'),
      ('2023-04-01 10:15:00', 3, 't'),
      ('2023-04-01 10:15:00', 2, 'f'),
      ('2023-04-01 10:15:00', 3, 't'),
      ('2023-04-02 07:15:00', 6, 't'),
      ('2023-04-02 09:15:00', 1, 'f');

--SQL statement that aims to retrieve the total number of visitors of all times:

SELECT COUNT(*) AS visitors FROM Visitors;

--SQL statement to retrieve the total number of visitors per day in chronological order:

SELECT DATE(date_time) AS day, COUNT(*) AS visitors FROM Visitors GROUP BY DATE(date_time) ORDER BY day ASC;

--SQL statement to retrieve the total number of visitors that havents left the building on 2023-04-04:

SELECT COUNT(*) AS visitors_still_in_the_building FROM Visitors WHERE left_building = 'f' AND DATE(date_time) = '2023-04-04';




--Q4
--Create and populate tables Specialties and MadScientists.

CREATE TABLE Specialties(
    specialty INT PRIMARY KEY,
    descr VARCHAR(50)
);

INSERT INTO Specialties (specialty, descr)
VALUES (101, 'revivification'),
       (202, 'time travelling'),
       (303, 'head transplantation');

CREATE TABLE MadScientists(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    specialty INT,
    FOREIGN KEY (specialty) REFERENCES Specialties (specialty)
);

INSERT INTO MadScientists(name, specialty)
VALUES ('Victor Frankestein', 101),
       ('Emmett Brown', 202),
       ('The Brain', NULL);


--Write all SQL statements asked in the exam (a, b, and c). 
--1. To display the names and specialty descriptions of all mad scientists in alphabetical order
SELECT MadScientists.name, Specialties.descr
FROM MadScientists
JOIN Specialties ON MadScientists.specialty = Specialties.specialty
ORDER BY MadScientists.name ASC;

--2. To display the name(s) of the mad scientist(s) that does(do) not have a specialty in alphabetical order
SELECT name
FROM MadScientists
WHERE specialty IS NULL
ORDER BY name ASC;

--Copy and paste the result of query c (as a comment in the script).
SELECT *
FROM MadScientists
FULL OUTER JOIN Specialties ON MadScientists.specialty = Specialties.specialty;

/* id |        name        | specialty | specialty |        descr         
----+--------------------+-----------+-----------+----------------------
  1 | Victor Frankestein |       101 |       101 | revivification
  2 | Emmett Brown       |       202 |       202 | time travelling
  3 | The Brain          |           |           | 
    |                    |           |       303 | head transplantation
(4 rows)
*/