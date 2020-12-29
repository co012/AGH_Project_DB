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

ip = "192.168.55.108"
login = "SA"
password = "ZAQ!2wsx"
database = "Project"

def runQ(query: str):
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-d'+database,'-Q '+ query])

def runF(filePath: str):
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-d'+database,'-i'+ filePath])

def clean():
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-Q '+ "DROP DATABASE " + database + " \n GO \n CREATE DATABASE " + database + " COLLATE Polish_CI_AS"])

def addFunctionsAndProceduresToDatabase(folderPath:str):
    filesNames = listdir(folderPath)
    for fileName in filesNames:
        runF(folderPath + fileName)



clean()
addFunctionsAndProceduresToDatabase("functions_and_procedures/")
runF("i_guess_projek_create.sql")
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+ip+';DATABASE='+database+';UID='+login+';PWD='+password)
cursor = cnxn.cursor()
dataFolderPath = "generators/data/"
populateDatabaseWithCustomersAndCompanies(cursor,dataFolderPath,500,50)
populateDatabaseWithBranches(cursor,dataFolderPath,10)
populateDatabaseWithEployeesAndTheirPositions(cursor,dataFolderPath,50)
populateDatabaseWithCategories(cursor,dataFolderPath)
populateDatabaseWithMenuItems(cursor,dataFolderPath)
populateDatabaseWithTables(cursor, 100)
populateDatabaseWithOrders(cursor,dataFolderPath,10)
