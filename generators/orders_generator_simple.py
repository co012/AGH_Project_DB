from os import stat
from math import floor
from .useful_functions import *
import pyodbc

def namesGenerator(dataFolderPath:str):
    femaleNames = unpackListOfLists(csvToList(dataFolderPath + "female_names.csv"),0)
    femaleLastNames = unpackListOfLists(csvToList(dataFolderPath + "female_last_names.csv"),0)
    maleNames = unpackListOfLists(csvToList(dataFolderPath + "male_names.csv"),0)
    maleLastNames = unpackListOfLists(csvToList(dataFolderPath + "male_last_names.csv"),0)

    while True :
        if random.randint(0,1) == 0:
            name = random.choice(femaleNames)
            lastName = random.choice(femaleLastNames)
        else:
            name = random.choice(maleNames)
            lastName = random.choice(maleLastNames)

        yield name + " " + lastName



def generateReservation(nameG,year,tableIds:list):
    dates =  [ getRandomDateTime(year,year+1), getRandomDateTime(year,year)]
    return [random.choice(tableIds), next(nameG), min(dates),max(dates)]
    
    
def generateOrderDetail(menuItemIdsAndTheirPrices):
    price = 0
    menuItemsIdsAndQuantity = [] 
    for i in range(random.randint(1,10)):
        c = random.choice(menuItemIdsAndTheirPrices)
        q = random.randint(1,10)
        menuItemsIdsAndQuantity.append([c[0],q])
        price += c[1]*q

    return price,menuItemsIdsAndQuantity


def generateCompleteOrCanceledOrderPack(nameG, branchIds:list,tableData:list, employeeIdsAndBranches:list, customerIds:list, menuItemsIdsAndPrices:list):
    branch = random.choice(branchIds)
    employee = random.choice(unpackListOfLists(filter(lambda t: t[1] == branch,employeeIdsAndBranches),0))
    customer = random.choice(customerIds)
    status = random.choice([4,4,4,4,4,4,4,5])
    priceWithoutDiscout,menuItemIdsAndQuantity = generateOrderDetail(menuItemsIdsAndPrices)
    discountTypeId = None
    discount = 0
    finalPrice = priceWithoutDiscout
    paid = status == 4

    year = random.randint(2010,2020)
    dates = [getRandomDateTime(year,year+1) for _ in range(4)]
    dates.sort()
    orderMadeDate = dates[0]
    orderApprovedDate = dates[1]
    orderServeDate = dates[2]
    orderServedDate = dates[3]

    tables = unpackListOfLists(filter(lambda x: x[1] == branch,tableData),0)
    reservations = [generateReservation(nameG,year,tables) for _ in range(floor(abs(random.gauss(0,1))))]
    withReserwation = len(reservations) > 0


    return [menuItemIdsAndQuantity, 
    [branch,employee,customer,status
    ,withReserwation,priceWithoutDiscout,
    discountTypeId,discount,finalPrice,paid,
    orderMadeDate,orderServeDate,orderApprovedDate,orderServedDate],
    reservations]


    


def populateDatabaseWithOrders(cursor, dataFolderPath:str,ordersNumber:int):
    nameGen = namesGenerator(dataFolderPath)
    dishesAndTheirPrices = cursor.execute("SELECT MenuItemId,UnitPrice FROM MenuItems").fetchall()
    tables = cursor.execute("SELECT TableId,BranchId FROM Tables").fetchall()
    customerIds = unpackListOfLists(cursor.execute("SELECT CustomerId FROM Customers").fetchall(),0)
    employeeIdsAndBranches = cursor.execute("SELECT EmployeeId,BranchId FROM Employees").fetchall()
    branchIds = unpackListOfLists(cursor.execute("SELECT BranchId FROM Branches").fetchall(),0)

    for _ in range(ordersNumber):
        orderPack = generateCompleteOrCanceledOrderPack(nameGen,branchIds,tables,employeeIdsAndBranches,customerIds,dishesAndTheirPrices)
        cursor.execute("""INSERT INTO Orders
        (BranchId,EmployeeId,CustomerId,StatusId,WithReservation,PriceWithoutDiscount,DiscountTypeId,
        Discount,FinalPrice,Paid,OrderMadeDate,OrderServeDate,OrderApprovedDate,OrderServedDate) 
        OUTPUT INSERTED.OrderId
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?) """,orderPack[1])
        orderId = cursor.fetchval()

        for orderDetail in orderPack[0]:
            cursor.execute("INSERT INTO OrderDetails VALUES(?,?,?)",orderId,orderDetail[0],orderDetail[1])

        for reservation in orderPack[2]:
            cursor.execute("INSERT INTO ReservationsInfo VALUES(?,?,?,?,?)",orderId,*reservation)