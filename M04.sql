
docker run --rm --name postgres -e POSTGRES_PASSWORD=135791 -v /Users/zoneranasir/Spring2023/CS3810DB/postgres:/var/lib/postgresql/data postgres   
docker exec -it postgres psql -U postgres



CREATE DATABASE test2;

\c test2

DROP TABLE 

CREATE TABLE Movies(
    title   CHAR(100),
    year    INT,
    length  INT,
    genre   CHAR(10) DEFAULT '?'
);

CREATE TABLE Stars (
    name    CHAR(30)    UNIQUE,
    gender  CHAR(1)     DEFAULT '?'
);

CREATE TABLE Stars (
    name    CHAR(30)    PRIMARY KEY,
    gender  CHAR(1)     DEFAULT '?'
);

CREATE TABLE Movies(
    title   CHAR(100),
    year    INT,
    length  INT,
    genre   CHAR(10) DEFAULT '?',
    UNIQUE (title,year)
);

CREATE TABLE Movies(
    title   CHAR(100),
    year    INT,
    length  INT,
    genre   CHAR(10) DEFAULT '?',
    PRIMARY KEY (title,year)
);

-- how to create a table --

CREATE TABLE Stars (
    name    CHAR(30)    PRIMARY KEY,
    gender  CHAR(1)     DEFAULT '?'
);

INSERT INTO Stars VALUES
('Jane', 'F'),
('Harris', 'M');

\copy Stars from