CREATE TABLE Astronauts(
    id INT PRIMARY KEY,
    lastName VARCHAR(30),
    firstName VARCHAR(30) NOT NULL,
    suffix VARCHAR(5),
    gender VARCHAR(5) NOT NULL,
    birth DATE NOT NULL,
    city VARCHAR(30),
    state VARCHAR(5),
    country VARCHAR(30),
    status VARCHAR(15),
    daysInSpace INT NOT NULL,
    flights INT NOT NULL);

    