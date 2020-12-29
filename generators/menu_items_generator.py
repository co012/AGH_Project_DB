from .useful_functions import *
import pyodbc
from lorem_text import lorem

def generateMenuItems(dataFolderPath:str):
    dishesList = csvToList(dataFolderPath+"dishes.csv")
    for d in dishesList:
        d.append(lorem.paragraph())
        d.append("$" + str(random.randint(0,100)) + '.' + generateRandomNumbersSeq(2))
        d.append("1999-07-24")
        d.append("2000-07-02")

    return dishesList

def populateDatabaseWithMenuItems(cursor, dataFolderPath:str):

    menuItems = generateMenuItems(dataFolderPath)
    cursor.fast_executemany = False
    cursor.executemany("INSERT INTO MenuItems(Name,CategoryId,Description,UnitPrice,LastTimeAdded,LastTimeRemoved) VALUES (?,?,?,?,?,?)",menuItems)
    cursor.commit()