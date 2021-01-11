# Dokumentacja  
## Schemat  
![Schemat](schemat.png)
## Tabele  
### Branches  
Tabela przechowuje dane o oddziałach firmy.  

**BranchId** - Identyfikator oddziału  
**Street** - Ulica  
**StreetNumber** - Numer budynku  
**Apartament** - Numer pokoju/apartamentu  
**City** - Miasto  
**PostCode** - Kod pocztowy  
**Area** - Powierzchnia lokalu  

```SQL
CREATE TABLE Branches (
    BranchId int  NOT NULL IDENTITY,
    Street varchar(255)  NOT NULL,
    StreetNumber varchar(10)  NOT NULL,
    Apartament varchar(10)  NULL,
    City varchar(30)  NOT NULL,
    PostCode varchar(30)  NOT NULL,
    Area real  NOT NULL,
    CONSTRAINT Branches_pk PRIMARY KEY  (BranchId)
);
```

### Categories
Tabela przechowuje informacje o danych kategoriach dań.  

**CategoryId** - Identyfikator kategorii  
**CategoryName** - Nazwa kategorii  
**Description** - Opis kategorii  

```SQL
CREATE TABLE Categories (
    CategoryId int  NOT NULL IDENTITY,
    CategoryName varchar(64)  NOT NULL,
    Description text  NOT NULL,
    CONSTRAINT Categories_pk PRIMARY KEY  (CategoryId)
);
```

### CompanyInfo
Przechowuje informacje o firmie klienta w tym dane potrzebne do faktury.  

**CompanyId** - Identyfikator firmy  
**Name** - Nazwa firmy  
**Street** - Ulica na której znajduje się jej oddział  
**StreetNumber** - Numer budynku  
**PostCode** - Adres pocztowy  
**City** - Miasto  
**NIP** - NIP firmy (narzucony jest na to pole warunek UNIQUE)  

```SQL
CREATE TABLE CompanyInfo (
    CompanyId int  NOT NULL IDENTITY,
    Name varchar(255)  NOT NULL,
    Street varchar(30)  NOT NULL,
    StreetNumber varchar(10)  NOT NULL,
    PostCode varchar(6)  NOT NULL,
    City varchar(255)  NOT NULL,
    NIP char(10)  NOT NULL,
    CONSTRAINT NIP UNIQUE (NIP),
    CONSTRAINT CompanyInfo_pk PRIMARY KEY  (CompanyId)
);
```

### Customers
Przechowuje informacje o klientach. Na tabele narzucony jest warunek by RepresentingCompany = (NOT CompanyId = NULL)  

**CustomerId** - Identyfikator klienta  
**ContactPersonFirstName** - Imię osoby kontaktowej, w przypadku klientów indywidualnych jest to imię klienta  
**ContactPersonLastName**   - Nazwisko osoby kontaktowej, w przypadku klientów indywidualnych jest to nazwisko klienta  
**Email** - E-mali klienta  
**Phone** - Telefon kontaktowy  
**RepresentingCompany** - Flaga informująca czy klient jest indywidualny ( = 0) czy raczej reprezentuje firmę ( = 1)  
**CompanyId** - Identyfikator firmy, może przyjmować wartość NULL    

```SQL
CREATE TABLE Customers (
    CustomerId int  NOT NULL IDENTITY,
    ContactPersonFirstName varchar(30)  NOT NULL,
    ContactPersonLastName varchar(30)  NOT NULL,
    Email varchar(320)  NOT NULL,
    Phone varchar(16)  NOT NULL,
    RepresentingCompany bit  NOT NULL,
    CompanyId int  NULL,
    CONSTRAINT CompanyNameAndIsACompany CHECK ((RepresentingCompany = 1 AND NOT CompanyId = NULL) OR  (RepresentingCompany = 0 AND CompanyId = NULL) ),
    CONSTRAINT CustomerId PRIMARY KEY  (CustomerId)
);
```

### DiscountsTypes
Przechowuje informacje o dostępnych rabatach, z tabelą mocno związane są funkcje calculateDiscountWithIdX gdzie X to identyfikator rabatu i w ich dokumentacji należy szukać szczegółowych informacji o znaczeniu danego pola.   

**DiscountTypeId** - Identyfikator Rabatu  
**Description** - Opis rabatu wraz z zasadą jego naliczania  
**CurrentMinDiscount** - Minimalna aktualna wartość procentowa rabatu. Na pole narzucony jest warunek by jego wartość była w przedziale (0,1>.  
**CurrentMaxDiscount** - Maksymalna aktualna wartość procentowa rabatu. Na pole narzucony jest warunek by jego wartość była w przedziale (0,1>.  
**MinPrice** - Minimalna cena, szczegóły opisane są w Description  
**MinOrders** - Minimalna liczba zamówień, szczegóły opisane są w Description  
**Duration** - Czas trwania,  szczegóły opisane są w Description  

```SQL
CREATE TABLE DiscountsTypes (
    DiscountTypeId int  NOT NULL IDENTITY,
    Description text  NOT NULL,
    CurrentMinDiscount real  NOT NULL CHECK (CurrentMinDiscount <= 1 and 0 < CurrentMinDiscount),
    CurrentMaxDiscount real  NOT NULL CHECK (CurrentMaxDiscount <=1 and 0 < CurrentMaxDiscount),
    MinPrice money  NULL,
    MinOrders int  NULL,
    Duration int  NULL,
    CONSTRAINT DiscountsTypes_pk PRIMARY KEY  (DiscountTypeId)
);

```

### Employees
Tabel przechowuje informacje o pracownikach.  

**EmployeeId** - Identyfikator pracownika  
**PositionId** - Identyfikator tytułu zawodowego  
**LastName** - Nazwisko pracownika  
**FirstName** - Imię pracownika  
**BirthDate** - Data urodzenia  
**HireDate** - Data zatrudnienia  
**Phone** - Telefon kontaktowy  
**BranchId** - Identyfikator oddziału, który zatrudnia pracownika  

```SQL
CREATE TABLE Employees (
    EmployeeId int  NOT NULL IDENTITY,
    PositionId int  NOT NULL,
    LastName varchar(30)  NOT NULL,
    FirstName varchar(30)  NOT NULL,
    BirthDate date  NOT NULL,
    HireDate date  NOT NULL,
    Phone varchar(16)  NOT NULL,
    BranchId int  NOT NULL,
    CONSTRAINT Employees_pk PRIMARY KEY  (EmployeeId)
);
```

### MenuItems
Tabela przechowuje dane o możliwych potrawach/napojach do umieszczenia w menu.  

**MenuItemId** - Identyfikator potrawy  
**CategoryId** - Identyfikator kategorii potrawy  
**Name** - Nazwa potrawy  
**Description** - Opis  
**UnitPrice** - Cena  
**LastTimeAdded** - Data ostatniego dodania potrawy do menu  
**LastTimeRemoved** - Data ostatniego ściągnięcia potrawy z menu  

```SQL
CREATE TABLE MenuItems (
    MenuItemId int  NOT NULL IDENTITY,
    CategoryId int  NOT NULL,
    Name varchar(64)  NOT NULL,
    Description text  NOT NULL,
    UnitPrice money  NOT NULL,
    LastTimeAdded date  NOT NULL,
    LastTimeRemoved date  NOT NULL,
    CONSTRAINT MenuItems_pk PRIMARY KEY  (MenuItemId)
);
```

### OrderDetails
Tabela przechowuje informacje o potrawach w danym zamówieniu.  

**OrderId** - Identyfikator zamówienia  
**MenuItemId** - Identyfikator potrawy  
**Quantity** - Ilość danej potrawy w zamówieniu  

```SQL
CREATE TABLE OrderDetails (
    OrderId int  NOT NULL,
    MenuItemId int  NOT NULL,
    Quantity int  NOT NULL CHECK (Quantity > 0),
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderId,MenuItemId)
);
```

### OrderStatuses
Tabela przechowuje informacje o możliwych statusach zamówienia.  

**StatusId** - Identyfikator statusu  
**StatusName** - Nazwa statusu  
**Description** - Opis co dany status oznacza  

```SQL
CREATE TABLE OrderStatuses (
    StatusId int  NOT NULL IDENTITY,
    StatusName varchar(30)  NOT NULL,
    Description text  NULL,
    CONSTRAINT OrderStatuses_pk PRIMARY KEY  (StatusId)
);
```

### Orders
Przechowuje Informacje o zamówieniu. W zależności od statusu zamówienia na tabele narzucone są różne warunki.  

**OrderId** - Identyfikator zamówienia  
**BranchId** - Identyfikator oddziału w którym realizowane jest zamówienie  
**EmployeeId** - Identyfikator pracownika przyjmującego zamówienie  
**CustomerId** - Identyfikator klienta składającego zamówienie  
**StatusId** - Identyfikator statusu zamówienia  
**WithReservation** - Flaga informująca czy z zamówieniem skojarzona jest rezerwacja (=1)  
**PriceWithoutDiscount** - Cena bez rabatu  
**DiscountTypeId** - Identyfikator rabatu  
**Discount** - Wartość rabatu  
**FinalPrice** - cena z rabatem  
**Paid** - Flaga informująca czy zamówienie zostało opłacone  
**OrderMadeDate** - Czas złożenia zamówienia  
**OrderServeDate** - Czas w którym zamówienie powinno być odebrane  
**OrderApprovedDate** - Czas zatwierdzenia zamówienia przez pracownika  
**OrderServedDate** - Czas odebrania zamówienia  

Tabela posiada index na StatusId  

```SQL
CREATE TABLE Orders (
    OrderId int  NOT NULL IDENTITY,
    BranchId int  NOT NULL,
    EmployeeId int  NULL,
    CustomerId int  NULL,
    StatusId int  NOT NULL,
    WithReservation bit  NOT NULL DEFAULT 0,
    PriceWithoutDiscount money  NOT NULL,
    DiscountTypeId int  NULL,
    Discount real  NOT NULL DEFAULT 0 CHECK (Discount <= 1 and Discount >= 0),
    FinalPrice money  NOT NULL,
    Paid bit  NOT NULL,
    OrderMadeDate datetime  NOT NULL,
    OrderServeDate datetime  NOT NULL,
    OrderApprovedDate datetime  NULL,
    OrderServedDate datetime  NULL,
    CONSTRAINT checkForStatusInter CHECK ((StatusId = 1 AND NOT CustomerId = NULL) OR (StatusId = 2 AND NOT EmployeeId = NULL AND NOT OrderApprovedDate = NULL) OR (StatusId = 3 AND NOT OrderServedDate = NULL) OR (StatusId > 3)),
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderId)
);

CREATE INDEX Status on Orders (StatusId ASC);
```

### Positions
Przechowuje dane o tytułach zawodowych.  

**PositionId** - Identyfikator tytułu  
**PositionName** - Nazwa tytułu  


```SQL
CREATE TABLE Positions (
    PositionId int  NOT NULL IDENTITY,
    PositionName varchar(30)  NOT NULL,
    CONSTRAINT Positions_pk PRIMARY KEY  (PositionId)
);
```

### ReservationsInfo
Przechowuje dane o rezerwacjach. Narzucono warunek by czas rezerwacji był większy od 0.  

**OrderId** - Identyfikator zamówienia  
**TableId** - Identyfikator stolika  
**ReservedFor** - Dla kogo zarezerwowano stolik  
**ReservedFrom** - Czas rozpoczęcia rezerwacji  
**ReservedTo** - Czas zakończenia rezerwacji  

```SQL
CREATE TABLE ReservationsInfo (
    OrderId int  NOT NULL,
    TableId int  NOT NULL,
    ReservedFor varchar(255)  NOT NULL,
    ReservedFrom datetime  NOT NULL,
    ReservedTo datetime  NOT NULL,
    CONSTRAINT ReservationTimeMustBePositive CHECK ((ReservedTo - ReservedFrom) > 0),
    CONSTRAINT ReservationsInfo_pk PRIMARY KEY  (OrderId,TableId)
);
```

### Tables
Tabela przechowuje dane o stolikach.  

**TableId** - Identyfikator stolika  
**Chairs** - Liczba krzeseł przy stoliku  
**BranchId** - Identyfikator oddziału w którym znajduje się stolik  
**UnavailableFrom** - Data startu niedostępności stolika  
**UnavailableTo** - Data końca niedostępności stolika  

Tabela posiada index na kolumnie BranchId

```SQL
CREATE TABLE Tables (
    TableId int  NOT NULL IDENTITY,
    Chairs tinyint  NOT NULL,
    BranchId int  NOT NULL,
    UnavailableFrom date  NOT NULL,
    UnavailableTo date  NOT NULL,
    CONSTRAINT Tables_pk PRIMARY KEY  (TableId)
);

CREATE INDEX Branch on Tables (BranchId ASC)
;
```

### UnavailableMenuItems
Przechowuje informacje o wyczerpaniu danej pozycji z menu.  

**BranchId** - Identyfikator oddziału w którym wyczerpano danie  
**MenuItemId** - Identyfikator dania  

```SQL
CREATE TABLE UnavailableMenuItems (
    BranchId int  NOT NULL,
    MenuItemId int  NOT NULL,
    CONSTRAINT UnavailableMenuItems_pk PRIMARY KEY  (BranchId,MenuItemId)
);
```

## Relacje
```SQL
-- foreign keys
-- Reference: Customers_CompanyInfo (table: Customers)
ALTER TABLE Customers ADD CONSTRAINT Customers_CompanyInfo
    FOREIGN KEY (CompanyId)
    REFERENCES CompanyInfo (CompanyId)
    ON DELETE  CASCADE;

-- Reference: Employees_Branches (table: Employees)
ALTER TABLE Employees ADD CONSTRAINT Employees_Branches
    FOREIGN KEY (BranchId)
    REFERENCES Branches (BranchId);

-- Reference: Employees_Positions (table: Employees)
ALTER TABLE Employees ADD CONSTRAINT Employees_Positions
    FOREIGN KEY (PositionId)
    REFERENCES Positions (PositionId);

-- Reference: MenuItems_Categories (table: MenuItems)
ALTER TABLE MenuItems ADD CONSTRAINT MenuItems_Categories
    FOREIGN KEY (CategoryId)
    REFERENCES Categories (CategoryId);

-- Reference: OrderDetails_MenuItems (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_MenuItems
    FOREIGN KEY (MenuItemId)
    REFERENCES MenuItems (MenuItemId);

-- Reference: OrderDetails_Orders (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Orders
    FOREIGN KEY (OrderId)
    REFERENCES Orders (OrderId);

-- Reference: Orders_Branches (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Branches
    FOREIGN KEY (BranchId)
    REFERENCES Branches (BranchId);

-- Reference: Orders_Customers (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Customers
    FOREIGN KEY (CustomerId)
    REFERENCES Customers (CustomerId);

-- Reference: Orders_DiscountsTypes (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_DiscountsTypes
    FOREIGN KEY (DiscountTypeId)
    REFERENCES DiscountsTypes (DiscountTypeId);

-- Reference: Orders_Employees (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Employees
    FOREIGN KEY (EmployeeId)
    REFERENCES Employees (EmployeeId);

-- Reference: Orders_OrderStatuses (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_OrderStatuses
    FOREIGN KEY (StatusId)
    REFERENCES OrderStatuses (StatusId);

-- Reference: ReservationsInfo_Orders (table: ReservationsInfo)
ALTER TABLE ReservationsInfo ADD CONSTRAINT ReservationsInfo_Orders
    FOREIGN KEY (OrderId)
    REFERENCES Orders (OrderId);

-- Reference: ReservationsInfo_Tables (table: ReservationsInfo)
ALTER TABLE ReservationsInfo ADD CONSTRAINT ReservationsInfo_Tables
    FOREIGN KEY (TableId)
    REFERENCES Tables (TableId);

-- Reference: Tables_Branches (table: Tables)
ALTER TABLE Tables ADD CONSTRAINT Tables_Branches
    FOREIGN KEY (BranchId)
    REFERENCES Branches (BranchId);

-- Reference: UnavalibleMenuItems_Branches (table: UnavailableMenuItems)
ALTER TABLE UnavailableMenuItems ADD CONSTRAINT UnavalibleMenuItems_Branches
    FOREIGN KEY (BranchId)
    REFERENCES Branches (BranchId);

-- Reference: UnavalibleMenuItems_MenuItems (table: UnavailableMenuItems)
ALTER TABLE UnavailableMenuItems ADD CONSTRAINT UnavalibleMenuItems_MenuItems
    FOREIGN KEY (MenuItemId)
    REFERENCES MenuItems (MenuItemId)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

```

## Widoki
### PossibleMenuItems
Wyświetla dania które można dodać do menu.  

```SQL
CREATE VIEW PossibleMenuItemsView
AS
SELECT MenuItemId,Name,UnitPrice FROM MenuItems WHERE DATEDIFF(MONTH,LastTimeRemoved,GETDATE()) >= 1 AND LastTimeAdded < LastTimeRemoved
```

## Funkcje i Procedury
### approveOrder
Procedura do wykorzystania przez pracownika do zatwierdzania zamówień złożonych przez internet.  
#### Parametry
**@orderId** - Identyfikator zamówienia do zatwierdzenia  
**@employeeId** - Identyfikator pracownika zatwierdzającego zamówienie 

```SQL
CREATE PROCEDURE approveOrder (@orderId INT,@employeeId INT)
AS
BEGIN
UPDATE Orders
SET OrderApprovedDate = GETDATE(),StatusId = 2,EmployeeId = @employeeId
WHERE OrderId = @orderId
END
```
### calculateDiscountWithId1
Funkcja obliczająca rabat reprezentowany w tablicy DiscountsTypes z polem DiscountTypeId = 1.  
#### Parametry
**@CustomerId** - Identyfikator klienta  
#### Wynik
Rabat reprezentowany przez wartość typu REAL,w przypadku gdy klient nie przysługuje rabat zwraca 0.  

```SQL
CREATE FUNCTION calculateDiscountWithId1 (@CustomerId INT)
RETURNS REAL
AS
BEGIN
DECLARE @typeId INT = 1;
DECLARE @minVal MONEY;
DECLARE @minOrders INT;
SET @minVal = (SELECT MinPrice FROM DiscountsTypes where DiscountTypeId = @typeId);
SET @minOrders = (SELECT MinOrders FROM DiscountsTypes where DiscountTypeId = @typeId)

IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @CustomerId) = 1 RETURN 0;

DECLARE @var REAL = 0;
SET @var = (SELECT COUNT(*) FROM Orders WHERE CustomerId = @CustomerId AND FinalPrice > @minVal AND NOT StatusId = 5);

IF @var >= 2 * @minOrders RETURN (SELECT CurrentMaxDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId)
ELSE IF @var >= 1 * @minOrders RETURN (SELECT CurrentMinDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId);

RETURN 0

END;
```
### calculateDiscountWithId2
Funkcja obliczająca rabat reprezentowany w tablicy DiscountsTypes z polem DiscountTypeId = 2.  
#### Parametry
**@CustomerId** - Identyfikator klienta  
#### Wynik
Rabat reprezentowany przez wartość typu REAL,w przypadku gdy klient nie przysługuje rabat zwraca 0.  

```SQL
CREATE FUNCTION calculateDiscountWithId2 (@CustomerId INT)
RETURNS REAL
AS
BEGIN
DECLARE @typeId INT = 2;
DECLARE @minVal MONEY;
DECLARE @discount REAL;
DECLARE @duration INT;
SET @minVal = (SELECT MinPrice FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @discount = (SELECT CurrentMinDiscount From DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @duration = (SELECT Duration From DiscountsTypes WHERE DiscountTypeId = @typeId);

IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @CustomerId) = 1 RETURN 0;

IF (SELECT COUNT(*) FROM Orders WHERE CustomerId = @CustomerId AND DiscountTypeId = @typeId) > 0
BEGIN
	DECLARE @discountDate DATETIME = 
	(SELECT TOP 1 OrderMadeDate FROM Orders WHERE CustomerId = @CustomerId AND DiscountTypeId = @typeId ORDER BY OrderMadeDate ASC);

	IF DATEDIFF(day,@discountDate,GETDATE()) < @duration RETURN @discount
	ELSE RETURN 0;
END
ELSE IF (SELECT SUM(FinalPrice) FROM Orders  WHERE CustomerId = @CustomerId  AND NOT StatusId = 5) > @minVal RETURN @discount;

RETURN 0
END;
```
### calculateDiscountWithId3
Funkcja obliczająca rabat reprezentowany w tablicy DiscountsTypes z polem DiscountTypeId = 3.  
#### Parametry
**@CustomerId** - Identyfikator klienta  
#### Wynik
Rabat reprezentowany przez wartość typu REAL,w przypadku gdy klient nie przysługuje rabat zwraca 0. 

```SQL
CREATE FUNCTION calculateDiscountWithId3 (@CustomerId INT)
RETURNS REAL
AS
BEGIN
DECLARE @typeId INT = 3;
DECLARE @minVal MONEY;
DECLARE @discount REAL;
DECLARE @duration INT;
SET @minVal = (SELECT MinPrice FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @discount = (SELECT CurrentMinDiscount From DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @duration = (SELECT Duration From DiscountsTypes WHERE DiscountTypeId = @typeId);

IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @CustomerId) = 1 RETURN 0;

IF (SELECT COUNT(*) FROM Orders WHERE CustomerId = @CustomerId AND DiscountTypeId = @typeId) > 0
BEGIN
	DECLARE @discountDate DATETIME = 
	(SELECT TOP 1 OrderMadeDate FROM Orders WHERE CustomerId = @CustomerId AND DiscountTypeId = @typeId ORDER BY OrderMadeDate ASC);

	IF DATEDIFF(day,@discountDate,GETDATE()) < @duration RETURN @discount
	ELSE RETURN 0;
END
ELSE IF (SELECT SUM(FinalPrice) FROM Orders  WHERE CustomerId = @CustomerId  AND NOT StatusId = 5) > @minVal RETURN @discount;

RETURN 0

END;
```
### calculateDiscountWithId4
Funkcja obliczająca rabat reprezentowany w tablicy DiscountsTypes z polem DiscountTypeId = 4.  
#### Parametry
**@customerId** - Identyfikator klienta  
#### Wynik
Rabat reprezentowany przez wartość typu REAL,w przypadku gdy klient nie przysługuje rabat zwraca 0.  

```SQL
CREATE FUNCTION calculateDiscountWithId4 (@customerId INT )
RETURNS REAL
AS
BEGIN
DECLARE @typeId INT = 4;
DECLARE @from INT;
DECLARE @minDiscount REAL;
DECLARE @maxDiscount REAL;
DECLARE @minPrice MONEY;
DECLARE @minOrders INT;
DECLARE @nowYM INT;

SET @minDiscount = (SELECT CurrentMinDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @maxDiscount = (SELECT CurrentMaxDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @minPrice = (SELECT MinPrice FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @minOrders = (SELECT MinOrders FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @nowYM = dbo.getYearMonth(GETDATE());


IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @customerId) = 0 RETURN 0;

DECLARE @maxStreak INT = CEILING( @maxDiscount / @minDiscount );
DECLARE @streak INT = 0;
DECLARE @YMIterator INT = dbo.getPreviousYearMonth(@nowYM);

WHILE @streak < @maxStreak
BEGIN
    DECLARE @TotalPrice MONEY, @OrdersMade INT;
    SELECT @TotalPrice =  SUM(FinalPrice), @OrdersMade = COUNT(*) FROM Orders WHERE CustomerId = @customerId AND dbo.getYearMonth(OrderMadeDate) = @YMIterator AND NOT StatusId = 5;
    IF ISNULL(@TotalPrice,0) < @minPrice OR @OrdersMade < @minOrders BREAK;
    SET @streak = @streak + 1;
    SET @YMIterator = dbo.getPreviousYearMonth(@YMIterator);
END


IF @maxDiscount < @minDiscount * @streak RETURN @maxDiscount;
RETURN @minDiscount * @streak;
END
```
### calculateDiscountWithId5
Funkcja obliczająca rabat reprezentowany w tablicy DiscountsTypes z polem DiscountTypeId = 5.  
#### Parametry
**@customerId** - Identyfikator klienta  
#### Wynik
Rabat reprezentowany przez wartość typu REAL,w przypadku gdy klient nie przysługuje rabat zwraca 0.  

```SQL
CREATE FUNCTION calculateDiscountWithId5 (@customerId INT )
RETURNS REAL
AS
BEGIN
DECLARE @typeId INT = 5;
DECLARE @minDiscount REAL;
DECLARE @minPrice MONEY;
DECLARE @nowYQ INT;
SET @minDiscount = (SELECT CurrentMinDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @minPrice = (SELECT MinPrice FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @nowYQ = dbo.getYearQuater(GETDATE());


IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @customerId) = 0 RETURN 0;


DECLARE @streak INT = 0;
DECLARE @YQIterator INT = dbo.getPreviousYearQuater(@nowYQ);

WHILE @streak * @minDiscount < 1
BEGIN
    DECLARE @TotalPrice MONEY;
    (SELECT @TotalPrice = SUM(FinalPrice) FROM Orders WHERE CustomerId = @customerId AND dbo.getYearQuater(OrderMadeDate) = @YQIterator AND NOT StatusId = 5)
    IF ISNULL(@TotalPrice,0)  < @minPrice BREAK;
    SET @streak = @streak + 1;
    SET @YQIterator = dbo.getPreviousYearQuater(@YQIterator);
END

RETURN @minDiscount * @streak;
END
```


 






