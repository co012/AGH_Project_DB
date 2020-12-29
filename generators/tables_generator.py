from .useful_functions import *
import pyodbc

def generateTables(tablesNumber:int,bracheIds:list):
    tables = [[random.randint(1,100),random.choice(bracheIds),"1999-07-24","2000-07-02"] for _ in range(tablesNumber)]
    return tables


def populateDatabaseWithTables(cursor, tablesNumber:int):

    rows = cursor.execute("SELECT BranchId FROM Branches").fetchall()
    tables = generateTables(tablesNumber,unpackListOfLists(rows,0))
    cursor.fast_executemany = True
    cursor.executemany("INSERT INTO Tables(Chairs,BranchId,UnavailableFrom,UnavailableTo) VALUES (?,?,?,?)",tables)
    cursor.commit()