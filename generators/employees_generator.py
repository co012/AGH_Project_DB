import pyodbc
import random
from .useful_functions import *

def generateEmployees(dataFolderPath:str, employeesNumber:int, positionsNumbers:int,branchesIds:list):
    positions = random.choices([i+1 for i in range(positionsNumbers)],k= employeesNumber)

    femaleNames = unpackListOfLists(csvToList(dataFolderPath + "female_names.csv"),0)
    random.shuffle(femaleNames)
    femaleLastNames = unpackListOfLists(csvToList(dataFolderPath + "female_last_names.csv"),0)
    random.shuffle(femaleLastNames)
    maleNames = unpackListOfLists(csvToList(dataFolderPath + "male_names.csv"),0)
    random.shuffle(maleNames)
    maleLastNames = unpackListOfLists(csvToList(dataFolderPath + "male_last_names.csv"),0)
    random.shuffle(maleLastNames)
    fullNames = []
    for _ in range(employeesNumber):
        if random.randint(0,1) == 0:
            name = femaleNames.pop()
            lastName = femaleLastNames.pop()
        else:
            name = maleNames.pop()
            lastName = maleLastNames.pop()

        fullNames.append((name,lastName))

    birthDates = [getRandomDate(1960,2000) for _ in range(employeesNumber)]
    hireDates = [getRandomDate(2010,2020) for _ in range(employeesNumber)]
    phones = generateRandomNumbersSeqs(employeesNumber,9)
    branches = random.choices(branchesIds,k=employeesNumber)

    toReturn = []
    for _ in range(employeesNumber):
        firsName,lastName = fullNames.pop()
        toReturn.append((positions.pop(),lastName,firsName,birthDates.pop(),hireDates.pop(),phones.pop(),branches.pop()))

    return toReturn
    

def populateDatabaseWithEployeesAndTheirPositions(cursor, dataFolderPath:str, employeesNumber:int):

    positions = csvToList(dataFolderPath + "positions.csv")
    rows = cursor.execute("SELECT BranchId FROM Branches").fetchall()
    employees = generateEmployees(dataFolderPath,employeesNumber,len(positions),unpackListOfLists(rows,0))
    cursor.fast_executemany = False
    cursor.executemany("INSERT INTO Positions(PositionName) VALUES (?)",positions)
    cursor.executemany("INSERT INTO Employees(PositionId,LastName,FirstName,BirthDate,HireDate,Phone,BranchId) VALUES (?,?,?,?,?,?,?)",employees)
    cursor.commit()