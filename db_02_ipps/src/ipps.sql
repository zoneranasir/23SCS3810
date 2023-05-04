-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Zonera Nasir 
-- Description: IPPS database

DROP DATABASE ipps;

CREATE DATABASE ipps;

\c ipps

-- create tables

-- Create Providers Table
CREATE TABLE Providers (
    Rndrng_Prvdr_CCN VARCHAR(6) PRIMARY KEY,
    Rndrng_Prvdr_Org_Name VARCHAR(100) NOT NULL,
    Rndrng_Prvdr_St VARCHAR(100) NOT NULL,
    Rndrng_Prvdr_City VARCHAR(100) NOT NULL,
    Rndrng_Prvdr_State_Abrvtn  CHAR(2) NOT NULL,
    Rndrng_Prvdr_State_FIPS CHAR(2) NOT NULL,
    Rndrng_Prvdr_Zip5 CHAR(5) NOT NULL,
    Rndrng_Prvdr_RUCA VARCHAR(5) NOT NULL,
    Rndrng_Prvdr_RUCA_Desc VARCHAR(100) NOT NULL
);

-- Create Diagnosis Table
CREATE TABLE Diagnosis (
  DRG_Cd VARCHAR(10) PRIMARY KEY,
  DRG_Desc VARCHAR(255)
);


-- Create Inpatient_Hospital_Service Table
CREATE TABLE Inpatient_Hospital_Service (
  Rndrng_Prvdr_CCN VARCHAR(6) REFERENCES Providers(Rndrng_Prvdr_CCN),
  DRG_Cd VARCHAR(10) REFERENCES Diagnosis(DRG_Cd),
  Tot_Dschrgs INTEGER,
  Avg_Submtd_Cvrd_Chrg NUMERIC(10,2),
  Avg_Tot_Pymt_Amt NUMERIC(10,2),
  Avg_Mdcr_Pymt_Amt NUMERIC(10,2),
  PRIMARY KEY (Rndrng_Prvdr_CCN, DRG_Cd)
);


-- create user with appropriate access to the tables
CREATE USER ipps WITH PASSWORD '1234';
GRANT ALL PRIVILEGES ON DATABASE ipps TO ipps;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ipps;

-- queries

-- a) List all diagnosis in alphabetical order.    

SELECT DISTINCT DRG_Desc FROM Diagnosis ORDER BY DRG_Desc ASC;

/* drg_desc                               
----------------------------------------------------------------------
 ACUTE ADJUSTMENT REACTION AND PSYCHOSOCIAL DYSFUNCTION
 ACUTE LEUKEMIA WITHOUT MAJOR O.R. PROCEDURES WITH MCC
 ACUTE LEUKEMIA W/O MAJOR O.R. PROCEDURE W CC
 ACUTE MAJOR EYE INFECTIONS WITH CC/MCC
 "ACUTE MYOCARDIAL INFARCTION, DISCHARGED ALIVE WITH CC"
 ACUTE MYOCARDIAL INFARCTION, DISCHARGED ALIVE W MCC
 ACUTE MYOCARDIAL INFARCTION, DISCHARGED ALIVE W/O CC/MCC
 "ACUTE MYOCARDIAL INFARCTION, EXPIRED WITH MCC"
 ADRENAL AND PITUITARY PROCEDURES WITH CC/MCC
 ADRENAL & PITUITARY PROCEDURES W/O CC/MCC
 "AFTERCARE, MUSCULOSKELETAL SYSTEM AND CONNECTIVE TISSUE WITH MCC"
 "AFTERCARE, MUSCULOSKELETAL SYSTEM AND CONNECTIVE TISSUE WITHOUT CC/
 AFTERCARE, MUSCULOSKELETAL SYSTEM & CONNECTIVE TISSUE W CC
 AFTERCARE W CC/MCC
 AFTERCARE WITHOUT CC/MCC
 AICD GENERATOR PROCEDURES
 "ALCOHOL, DRUG ABUSE OR DEPENDENCE, LEFT AMA"
 "ALCOHOL, DRUG ABUSE OR DEPENDENCE WITHOUT REHABILITATION THERAPY WI
 ALCOHOL/DRUG ABUSE OR DEPENDENCE W/O REHABILITATION THERAPY W/O MCC
 ALCOHOL/DRUG ABUSE OR DEPENDENCE W REHABILITATION THERAPY
 ALLERGIC REACTIONS WITHOUT MCC
--More--
*/

-- b) List the names and correspondent states (including Washington D.C.) of all of the providers in alphabetical order (state first, provider name next, no repetition). 

SELECT DISTINCT Rndrng_Prvdr_St AS state, Rndrng_Prvdr_Org_Name AS provider_name 
FROM Providers 
ORDER BY Rndrng_Prvdr_St, Rndrng_Prvdr_Org_Name ASC;

/*
 state                     |                   provider_name                    
----------------------------------------------+----------------------------------------------------
 10000 Telegraph Road                         | Beaumont Hospital - Taylor
 10000 W Colonial Dr                          | Orlando Health-Health Central Hospital
 1000 36th St                                 | Cleveland Clinic Indian River Hospital
 1000 Blythe Blvd                             | Carolinas Medical Center/Behav Health
 1000 Bower Hill Road                         | St Clair Hospital
 1000 Carondelet Dr                           | St Joseph Medical Center
 1000 Dutch Ridge Road                        | Heritage Valley Beaver
 1000 East 100 North                          | Mountain View Hospital
 1000 East Mountain Boulevard                 | Geisinger Wyoming Valley Medical Center
 1000 East Washington Street                  | Medina Hospital
 1000 E Main St                               | Hendricks Regional Health
 1000 First Street North                      | Shelby Baptist Medical Center
 1000 Fourth Street Sw                        | Mercyone North Iowa Medical Center
 1000 Greenley Road                           | Adventist Health Sonora
 1000 Harrington St                           | Mclaren Macomb
 1000 Health Center Drive P O Box 372         | Sarah Bush Lincoln Health Center
 1000 Hospital Drive                          | Mcpherson Hospital Inc
 1000 Johnson Ferry Road, Ne                  | Northside Hospital
 1000 Lincoln St                              | Colorado Plains Medical Center
 1000 Mar-Walt Dr                             | Fort Walton Beach Medical Center
 1000 Mckinley Park Drive                     | Marion General Hospital
--More--
*/

-- c) List the total number of providers.

SELECT COUNT(*) AS total_providers 
FROM Providers;

/*
FROM Providers;
 total_providers 
-----------------
            3065
(1 row)
*/

-- d) List the total number of providers per state (including Washington D.C.) in alphabetical order (also printing out the state).  

SELECT Rndrng_Prvdr_State_Abrvtn AS state, COUNT(*) AS total_providers
FROM Providers
GROUP BY Rndrng_Prvdr_State_Abrvtn
ORDER BY state ASC;

/*
state | total_providers 
-------+-----------------
 AK    |               8
 AL    |              79
 AR    |              43
 AZ    |              57
 CA    |             282
 CO    |              49
 CT    |              26
 DC    |               6
 DE    |               6
 FL    |             165
 GA    |              92
 HI    |              12
 IA    |              33
 ID    |              15
 IL    |             121
 IN    |              80
 KS    |              47
 KY    |              61
 LA    |              84
 MA    |              55
 MD    |              45
--More--
*/

-- e) List the providers names in Denver (CO) or in Lakewood (CO) in alphabetical order  

SELECT Rndrng_Prvdr_Org_Name AS provider_name
FROM Providers
WHERE Rndrng_Prvdr_City IN ('Denver', 'Lakewood') AND Rndrng_Prvdr_State_Abrvtn = 'CO'
ORDER BY Rndrng_Prvdr_Org_Name ASC;

/*
                  provider_name                  
-------------------------------------------------
 Centura Health-Porter Adventist Hospital
 Centura Health-St Anthony Hospital
 Denver Health Medical Center
 Orthocolorado Hospital At St Anthony Med Campus
 Presbyterian St Luke's Medical Center
 Rose Medical Center
 Saint Joseph Hospital
(7 rows)
*/

-- f) List the number of providers per RUCA code (showing the code and description)

SELECT Rndrng_Prvdr_RUCA AS ruca_code, Rndrng_Prvdr_RUCA_Desc AS ruca_description, COUNT(*) AS provider_count
FROM Providers
GROUP BY Rndrng_Prvdr_RUCA, Rndrng_Prvdr_RUCA_Desc
ORDER BY Rndrng_Prvdr_RUCA ASC;

/*
 ruca_code |                                           ruca_description                                           | provider_count 
-----------+------------------------------------------------------------------------------------------------------+----------------
 1         | Metropolitan area core: primary flow within an urbanized area of 50,000 and greater                  |           2068
 10        | Rural areas: primary flow to a tract outside a urbanized area of 50,000 and greater or UC            |             34
 10.1      | Secondary flow 30% to <50% to a urbanized area of 50,000 and greater                                 |              1
 10.2      | Secondary flow 30% to <50% to a urban cluster of 10,000 to 49,999                                    |              1
 1.1       | Secondary flow 30% to <50% to a larger urbanized area of 50,000 and greater                          |             49
 2         | Metropolitan area high commuting: primary flow 30% or more to a urbanized area of 50,000 and greater |            108
 2.1       | Secondary flow 30% to <50% to a larger urbanized area of 50,000 and greater                          |              3
 3         | Metropolitan area low commuting: primary flow 10% to <30% to a urbanized area of 50,000 and greater  |              6
 4         | Micropolitan area core: primary flow within an urban cluster of 10,000 to 49,999                     |            498
 4.1       | Secondary flow 30% to <50% to a urbanized area of 50,000 and greater                                 |             27
 5         | Micropolitan high commuting: primary flow 30% or more to a urban cluster of 10,000 to 49,999         |             28
 6         | Micropolitan low commuting: primary flow 10% to <30% to a urban cluster of 10,000 to 49,999          |              2
 7         | Small town core: primary flow within an urban cluster of 2,500 to 9,999                              |            199
 7.1       | Secondary flow 30% to <50% to a urbanized area of 50,000 and greater                                 |             12
 7.2       | Secondary flow 30% to <50% to a urban cluster of 10,000 to 49,999                                    |              3
 8         | Small town high commuting: primary flow 30% or more to a urban cluster of 2,500 to 9,999             |             10
 9         | Small town low commuting: primary flow 10% to <30% to a urban cluster of 2,500 to 9,999              |              2
 99        | Unknown                                                                                              |             14
(18 rows)
*/

-- g) Show the DRG description for code 308 

SELECT DRG_Desc AS drg_description
FROM Diagnosis
WHERE DRG_Cd = '308'
LIMIT 1;

/*
                 drg_description                 
-------------------------------------------------
 CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W MCC
(1 row)
*/

-- h) List the top 10 providers (with their correspondent state) that charged (as described in Avg_Submtd_Cvrd_Chrg) the most for the DRG code 308. Output should display the provider name, their city, state, and the average charged amount in descending order.   

SELECT Rndrng_Prvdr_Org_Name AS provider_name, Rndrng_Prvdr_City AS city, Rndrng_Prvdr_State_Abrvtn AS state, AVG(Avg_Submtd_Cvrd_Chrg) AS avg_charged_amount
FROM Inpatient_Hospital_Service
JOIN Providers ON Inpatient_Hospital_Service.Rndrng_Prvdr_CCN = Providers.Rndrng_Prvdr_CCN
WHERE DRG_Cd = '308'
GROUP BY Rndrng_Prvdr_Org_Name, Rndrng_Prvdr_City, Rndrng_Prvdr_State_Abrvtn
ORDER BY avg_charged_amount DESC
LIMIT 10;

/*
               provider_name               |     city      | state | avg_charged_amount  
-------------------------------------------+---------------+-------+---------------------
 Capital Health Regional Medical Center    | Trenton       | NJ    | 223187.080000000000
 Capital Health Medical Center - Hopewell  | Pennington    | NJ    | 221399.000000000000
 Westchester Medical Center                | Valhalla      | NY    | 187337.130000000000
 Stanford Health Care                      | Stanford      | CA    | 174801.890000000000
 Northbay Medical Center                   | Fairfield     | CA    | 161592.850000000000
 Ucsf Medical Center                       | San Francisco | CA    | 161309.130000000000
 Valley Hospital Medical Center            | Las Vegas     | NV    | 158245.700000000000
 Carepoint Health - Bayonne Medical Center | Bayonne       | NJ    | 154446.230000000000
 Doctors Medical Center                    | Modesto       | CA    | 153425.710000000000
 Riverside Community Hospital              | Riverside     | CA    | 150379.050000000000
(10 rows)
*/


-- i) List the average charges (as described in Avg_Submtd_Cvrd_Chrg) of all providers per state for the DRG code 308. Output should display the state and the average charged amount per state in descending order (of the charged amount) using only two decimals. 

SELECT Rndrng_Prvdr_State_Abrvtn AS state, ROUND(AVG(Avg_Submtd_Cvrd_Chrg), 2) AS avg_charged_amount
FROM Inpatient_Hospital_Service
JOIN Providers ON Inpatient_Hospital_Service.Rndrng_Prvdr_CCN = Providers.Rndrng_Prvdr_CCN
WHERE DRG_Cd = '308'
GROUP BY Rndrng_Prvdr_State_Abrvtn
ORDER BY avg_charged_amount DESC;

/*
 state | avg_charged_amount 
-------+--------------------
 NV    |           86969.86
 NJ    |           79081.46
 CA    |           76216.25
 AK    |           64860.73
 CO    |           60273.79
 DC    |           58729.32
 AZ    |           56401.11
 FL    |           54499.60
 TX    |           52108.56
 NY    |           48791.85
 PA    |           45994.39
 AL    |           43761.75
 WA    |           43680.90
 OK    |           43405.75
 GA    |           43191.06
 SC    |           42884.44
 KS    |           42475.33
 IL    |           40891.65
 NM    |           40112.99
 HI    |           39817.39
 LA    |           39066.92
--More--
*/

-- j) Which provider and clinical condition pair had the highest difference between the amount charged (as described in Avg_Submtd_Cvrd_Chrg) and the amount covered by Medicare only (as described in Avg_Mdcr_Pymt_Amt)?

SELECT Rndrng_Prvdr_Org_Name AS provider_name, DRG_Desc AS clinical_condition, (AVG(Avg_Submtd_Cvrd_Chrg) - AVG(Avg_Mdcr_Pymt_Amt)) AS difference
FROM Inpatient_Hospital_Service
JOIN Providers ON Inpatient_Hospital_Service.Rndrng_Prvdr_CCN = Providers.Rndrng_Prvdr_CCN
JOIN Diagnosis ON Inpatient_Hospital_Service.DRG_Cd = Diagnosis.DRG_Cd
GROUP BY Rndrng_Prvdr_Org_Name, DRG_Desc
ORDER BY difference DESC
LIMIT 1;

/*
        provider_name        |                          clinical_condition                          |      difference      
-----------------------------+----------------------------------------------------------------------+----------------------
 Cedars-Sinai Medical Center | "ECMO OR TRACHEOSTOMY WITH MV >96 HOURS OR PRINCIPAL DIAGNOSIS EXCEP | 3247002.530000000000
(1 row)
*/