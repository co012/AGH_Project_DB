from subprocess import run
from generators.customer_generator import populateDatabaseWithCustomersAndCompanies
from os import listdir

ip = "192.168.55.106"
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
populateDatabaseWithCustomersAndCompanies("192.168.55.106","SA","ZAQ!2wsx","Project","generators/data/",500,50)
