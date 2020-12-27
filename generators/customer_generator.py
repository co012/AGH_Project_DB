import re
import random
import pyodbc

def reduceData(filePath: str ,columsInReduced,reducedFilePath: str):
    reducedFile = open(reducedFilePath,"w+")
    file = open(filePath)

    colums = file.readline().split(sep=",")
    print(colums)
    for line in file:
        fields = line.split(sep=",")
        newLine = ""
        for n in range(len(colums)):
            if colums[n] in columsInReduced:
                newLine+= fields[n] + ","
        
        newLine = re.sub(" {2,}"," ",newLine)
        newLine = newLine.replace("\"","")
        reducedFile.write(newLine[0:-1] + "\n")


def csvToList(filePath):
    file = open(filePath)
    toReturn = []
    for line in file:
        toReturn.append(line.split(","))
    return toReturn

def generateRandomNumbesrsSeq(n,m):
    numbers = ["0","1","2","3","4","5","6","7","8","9"]
    seqes = []
    while(len(seqes) < n):
        seq = ''.join(random.choices(numbers,k=m))
        if not seq in seqes:
            seqes.append(seq)
    
    return seqes


def generateNIPs(n):
    return generateRandomNumbesrsSeq(n,10)

def generataPhoneNumbers(n):
    return generateRandomNumbesrsSeq(n,9)

def unpackListOfLists(listOfLists : list , i: int):
    toReturn = []
    for l in listOfLists:
        toReturn.append(l[i])

    return toReturn

def getRideOfEndLine(strings : list):
    for i in range(len(strings)):
        strings[i] = strings[i].replace("\n",'')


def generateCustomers(n,companiesNumber: int, dataFolderPath):
    
    femaleNames = unpackListOfLists(csvToList(dataFolderPath + "female_names.csv"),0)
    getRideOfEndLine(femaleNames)
    random.shuffle(femaleNames)
    femaleLastNames = unpackListOfLists(csvToList(dataFolderPath + "female_last_names.csv"),0)
    random.shuffle(femaleLastNames)
    getRideOfEndLine(femaleLastNames)
    maleNames = unpackListOfLists(csvToList(dataFolderPath + "male_names.csv"),0)
    random.shuffle(maleNames)
    getRideOfEndLine(maleNames)
    maleLastNames = unpackListOfLists(csvToList(dataFolderPath + "male_last_names.csv"),0)
    random.shuffle(maleLastNames)
    getRideOfEndLine(maleLastNames)
    emailLastPart = unpackListOfLists(csvToList(dataFolderPath + "email_after_@.csv"),0)
    getRideOfEndLine(emailLastPart)
    phones = generataPhoneNumbers(n)


    customers = []

    for _ in range(n):
        if random.randint(0,1) == 0:
            name = femaleNames.pop()
            lastName = femaleLastNames.pop()
        else:
            name = maleNames.pop()
            lastName = maleLastNames.pop()

        email = name.replace(" ","") + str(random.randint(0,10)) + '@' +random.choice(emailLastPart)
        phone = phones.pop()

        customers.append([name,lastName,email,phone,0,None])

    companies = generateCompanies(companiesNumber,dataFolderPath)

    toAddCompany = random.sample(customers,companiesNumber)

    for i in range(len(toAddCompany)):
        toAddCompany[i][-1] = i + 1
        toAddCompany[i][-2] = 1;

    return customers
        

def generateCompanies(n, dataFolderPath):
    companyNames = unpackListOfLists(csvToList(dataFolderPath + "company_names.csv"),0)
    getRideOfEndLine(companyNames)
    random.shuffle(companyNames)
    streets = unpackListOfLists(csvToList(dataFolderPath + "streets.csv"),0)
    getRideOfEndLine(streets)
    random.shuffle(streets)
    cities = unpackListOfLists(csvToList(dataFolderPath + "cities.csv"),0)
    getRideOfEndLine(cities)
    random.shuffle(cities)
    NIPs = generateNIPs(n)
    
    companies = []

    for _ in range(n):
        companyName = companyNames.pop()
        street = random.choice(streets)
        streetNumber = str(random.randint(1,100))
        postCode = generateRandomNumbesrsSeq(1,2)[0] + "-" + generateRandomNumbesrsSeq(1,3)[0]
        citie = random.choice(cities)
        nip = NIPs.pop()

        companies.append([companyName,street,streetNumber,postCode,citie,nip])

    return companies


def populateDatabaseWithCustomersAndCompanies(server:str, login:str, password:str, database:str, dataFolderPath:str, customersNumber:int, companiesNumber:int):
    cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+login+';PWD='+password)
    cursor = cnxn.cursor()

    customers = generateCustomers(customersNumber,companiesNumber,dataFolderPath)
    companies = generateCompanies(companiesNumber,dataFolderPath)

    cursor.fast_executemany = True
    cursor.executemany("INSERT INTO CompanyInfo(Name, Street, StreetNumber, PostCode, City, NIP) VALUES (?,?,?,?,?,?)",companies)
    cursor.executemany("INSERT INTO Customers(ContactPersonFirstName,ContactPersonLastName,Email,Phone,RepresentingCompany,CompanyId) VALUES (?,?,?,?,?,?)",customers)
    cursor.commit()

