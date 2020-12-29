from .useful_functions import *
import pyodbc
from lorem_text import lorem

def generateCategories(dataFolderPath:str):
    categories =unpackListOfLists(csvToList(dataFolderPath + "categories.csv"),0)
    toReturn = []
    for c in categories:
        toReturn.append((c,lorem.paragraph()))

    return toReturn


def populateDatabaseWithCategories(cursor, dataFolderPath:str):

    categories = generateCategories(dataFolderPath)
    cursor.fast_executemany = False
    cursor.executemany("INSERT INTO Categories(CategoryName,Description) VALUES (?,?)",categories)
    cursor.commit()