from subprocess import run
ip = "192.168.55.106"
login = "SA"
password = "ZAQ!2wsx"
database = "Project"

def runQ(query: str):
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-d'+database,'-Q '+ query])

def runF(filePath: str):
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-d'+database,'-i'+ filePath])

def clean():
    run(['sqlcmd', '-S' + ip, '-U' + login, '-P' + password,'-Q '+ "DROP DATABASE " + database + " \n GO \n CREATE DATABASE " + database])

clean()
runF("functions_and_procedures/getYearMonth.sql")