"""
CS3810: Principles of Database Systems
Instructor: Thyago Mota
Student: Zonera Nasir 
Description: ORM script to show campers in a given program
"""

import configparser as cp
from sqlalchemy import create_engine
from sqlalchemy.engine import URL
from sqlalchemy import Column, Integer, String, Date, Double, ForeignKey
from sqlalchemy.orm import relationship, sessionmaker, declarative_base

Base = declarative_base()

'''
This class represents a camper entity
'''
class Camper(Base): 
    # TODO #1 complete the mapping of class Camper and table campers

    __tablename__ = 'campers'
    id     = Column(Integer, primary_key=True)
    name   = Column(String(50), nullable=False)
    dob    = Column(Date, nullable=False)
    gender = Column(String(10))
    cabin = Column(String(50), ForeignKey('cabins.name'))
    
    # programs will allow the retrieval of all programs that a camper is in via the intermediate table "participates"
    programs = relationship("Program", secondary="participates")

    def __str__(self): 
        str_gender = self.gender
        if not self.gender:
            str_gender = '?'
        return '{' + str(self.id) + ',' + self.name + ',' + str(self.dob) + ',' + str_gender + '}'

'''
This class represents the intermediate table between campers and programs 
'''
class Participate(Base):
    # TODO #2 complete the mapping of class Participate and table participates
    '''
    __tablename__ = ...
    program = Column(..., ForeignKey(...), primary_key=True) 
    camper = Column(..., ForeignKey(...), primary_key=True)
    '''
    __tablename__ = "participates"
    camper = Column(Integer, ForeignKey('campers.id'), primary_key=True)
    program = Column(String(50), ForeignKey('programs.name'), primary_key=True)

'''
This class represents a program entity
'''
class Program(Base):
    # TODO #3 complete the mapping of class Program and table programs
    '''
    __tablename__ = ...
    name = Column(..., primary_key=True) 
    descr = Column(...)
    price = Column(...)
    '''
    __tablename__ = "programs"
    name = Column(String(50), primary_key=True)
    descr = Column(String(200), nullable=False)
    price = Column(Double(10, 2))

    # campers will allow the retrieval of all campers that are enrolled in a program via the intermediate table "participates"
    campers = relationship("Camper", secondary="participates", back_populates="programs")

    def __str__(self): 
        return '{' + self.name + "," + self.descr + ',' + str(self.price) + '}'

config = cp.RawConfigParser()
config.read('ConfigFile.properties')
params = dict(config.items('db'))

url = URL.create(
    "postgresql+psycopg2",
    username=params['user'],
    password=params['password'],
    host=params['host'],
    port=params['port'],
    database=params['dbname']
)

engine = create_engine(url)
if engine: 
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')
    Session = sessionmaker(engine)
    session = Session()
    # TODO #4 ask the user for the name of a program 
    '''
    name = ... 
    '''
    name = input("Enter the name of the program: ")

    # retrieves program info without any SQL (wow!)
    program = session.get(Program, name)

    # TODO #5 check if the program exists and if yes show the program info including all campers enrolled in the program 
    if program:
        print("Program info:")
        print("Name:", program.name)
        print("Description:", program.descr)
        print("Price:", program.price)
        
        # Get the list of campers enrolled in the program
        campers = program.campers
        if campers:
            print("Campers enrolled:")
            for camper in campers:
                print(camper.name)
        else:
            print("No campers enrolled in this program.")
    else:
        print("Program does not exist.")