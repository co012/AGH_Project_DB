import pyodbc
import random
from .useful_functions import *


def generateBranches(dataFolderPath:str, branchesNumber:int):
    streets = random.choices(unpackListOfLists(csvToList(dataFolderPath + "streets.csv"),0),k=branchesNumber)
    streetsNumbers = [str(random.randint(1,200)) + random.choice(['A','B','']) for _ in range(branchesNumber)]
    apartaments = [ getAtRandomNoneOrThat(str(random.randint(1,100)),0.7) for _ in range(branchesNumber)]
    cities = random.choices(unpackListOfLists(csvToList(dataFolderPath + "cities.csv"),0),k=branchesNumber)
    postCodes = [generateRandomNumbersSeq(2) + '-' + generateRandomNumbersSeq(3) for _ in range(branchesNumber)]
    areas = [random.randint(1000,10000) /100  for _ in range(branchesNumber)]

    toReturn = []
    for _ in range(branchesNumber):
        toReturn.append((streets.pop(),streetsNumbers.pop(),apartaments.pop(),cities.pop(),postCodes.pop(),areas.pop()))

    return toReturn
    

def populateDatabaseWithBranches(cursor, dataFolderPath:str, branchesNumber:int):
    branches = generateBranches(dataFolderPath,branchesNumber)
    cursor.fast_executemany = True
    cursor.executemany("INSERT INTO Branches(Street, StreetNumber, Apartament, City, PostCode, Area) VALUES (?,?,?,?,?,?)",branches)
    cursor.commit()