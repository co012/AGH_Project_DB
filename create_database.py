from subprocess import run
from generators.customer_generator import populateDatabaseWithCustomersAndCompanies
from generators.branches_generator import populateDatabaseWithBranches
from generators.employees_generator import populateDatabaseWithEployeesAndTheirPositions
from generators.categories_generator import populateDatabaseWithCategories
from generators.menu_items_generator import populateDatabaseWithMenuItems
from generators.tables_generator import populateDatabaseWithTables
from generators.orders_generator_simple import populateDatabaseWithOrders
from os import listdir
import pyodbc

ip = "192.168.55.104"
login = "SA"
password = "ZAQ!2wsx"
database = "Project"

def runQ(query: str):
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-d'+database,'-Q '+ query])

def runF(filePath: str):
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-d'+database,'-i'+ filePath])

def clean():
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-Q '+ "DROP DATABASE " + database + " \n GO \n CREATE DATABASE " + database + " COLLATE Polish_CI_AS"])

def addElementsFromFolderToDatabase(folderPath:str):
    filesNames = listdir(folderPath)
    for fileName in filesNames:
        runF(folderPath + fileName)



clean()
addElementsFromFolderToDatabase("functions_and_procedures/")
addElementsFromFolderToDatabase("views/")
#addElementsFromFolderToDatabase("functions_and_procedures/")
runF("i_guess_projek_create.sql")
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+ip+';DATABASE='+database+';UID='+login+';PWD='+password)
cursor = cnxn.cursor()
dataFolderPath = "generators/data/"
print("PopulateWithCustomersAndCompanies: START")
populateDatabaseWithCustomersAndCompanies(cursor,dataFolderPath,50,10)
print("PopulateWithCustomersAndCompanies: END")
print("PopulateWithBranches: START")
populateDatabaseWithBranches(cursor,dataFolderPath,5)
print("PopulateWithBranches: END")
print("PopulateWithEmployeesAndTheirPositions: START")
populateDatabaseWithEployeesAndTheirPositions(cursor,dataFolderPath,50)
print("PopulateWithEmployeesAndTheirPositions: END")
print("PopulateWithCategories: START")
populateDatabaseWithCategories(cursor,dataFolderPath)
print("PopulateWithCategories: END")
print("PopulateWithMenuItems: START")
populateDatabaseWithMenuItems(cursor,dataFolderPath)
print("PopulateWithMenuItems: END")
print("PopulateWithTables: START")
populateDatabaseWithTables(cursor, 100)
print("PopulateWithTables: END")
print("PopulateWithOrders: START")
populateDatabaseWithOrders(cursor,dataFolderPath,1000)
print("PopulateWithOrders: END")


