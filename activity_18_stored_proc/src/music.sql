CREATE DATABASE music; 

\c music

CREATE TABLE Albums ( 
  id SERIAL NOT NULL PRIMARY KEY, 
  title VARCHAR(30) NOT NULL, 
  artist VARCHAR(30) NOT NULL, 
  year INT NOT NULL 
); 

CREATE TABLE Tracks ( 
  id INT NOT NULL, 
  num INT NOT NULL, 
  name VARCHAR(30) NOT NULL, 
  PRIMARY KEY (id, num), 
  FOREIGN KEY (id) REFERENCES Albums (id) 
); 

CREATE FUNCTION check_year(year INT) RETURNS INT
    LANGUAGE plpgsql
    AS 
    $$
        BEGIN
            IF year >= 1950 THEN 
                RETURN year; 
            ELSE 
                RAISE EXCEPTION 'Year is invalid!!!';
            END IF;
        END;
    $$;

CREATE PROCEDURE number_albums(IN art VARCHAR(30))
    LANGUAGE plpgsql
    AS 
    $$
        BEGIN
            PERFORM COUNT(*) FROM Albums WHERE Albums.artist = art; 
        END;
    $$;



