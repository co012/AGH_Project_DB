-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-12-28 14:24:25.356

-- tables
-- Table: Branches
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

-- Table: Categories
CREATE TABLE Categories (
    CategoryId int  NOT NULL IDENTITY,
    CategoryName varchar(30)  NOT NULL,
    Description text  NOT NULL,
    CONSTRAINT Categories_pk PRIMARY KEY  (CategoryId)
);

-- Table: CompanyInfo
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

-- Table: Customers
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

-- Table: DiscountsTypes
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

INSERT INTO DiscountsTypes(Description, CurrentMinDiscount, CurrentMaxDiscount, MinPrice,MinOrders,Duration)
VALUES ('Po realizacji ustalonej liczby zamówień Z1 za co najmniej określoną kwotę K1 za każde zamówienie R1% zniżki na wszystkie zamówienia
Po realizacji kolejnych Z1 zamówień za co najmniej określoną kwotę K1 każde: dodatkowe R1% zniżki na wszystkie zamówienia', 0.03,0.06,30,10,0)

INSERT INTO DiscountsTypes(Description, CurrentMinDiscount, CurrentMaxDiscount, MinPrice,MinOrders,Duration)
VALUES('Po realizacji zamówień za łączną kwotę K2: jednorazowa zniżka R2% na zamówienia
złożone przez D1 dni, począwszy od dnia przyznania zniżk',0.03,0.03,1000,0,7)

INSERT INTO DiscountsTypes(Description, CurrentMinDiscount, CurrentMaxDiscount, MinPrice,MinOrders,Duration)
VALUES('Po realizacji zamówień za łączną kwotę MinPrice: jednorazowa zniżka CurrentMinDiscount
na zamówienia złożone przez Duration dni, począwszy od dnia przyznania zniżki.',0.05,0.05,5000,0,7)

INSERT INTO DiscountsTypes(Description, CurrentMinDiscount, CurrentMaxDiscount, MinPrice,MinOrders,Duration)
VALUES('Za każdy kolejny miesiąc, w którym dokonano co najmniej FZ zamówień za łączną kwotę co
najmniej FK1: rabat FR1% (np. FR1 = 0,1%). W przypadku braku ciągłości w zamówieniach
rabat zeruje się. Łączny, maksymalny rabat, to FM%',0.001,0.04,5,500,31)

INSERT INTO DiscountsTypes(Description, CurrentMinDiscount, CurrentMaxDiscount, MinPrice,MinOrders,Duration)
VALUES('Za każdy kolejny kwartał, w którym dokonano zamówień za łączną kwotę FK2: rabat
kwotowy równy FR2% z łącznej kwoty, z którą zrealizowano zamówienie.',0.05,0.05,0,10000,122);

-- Table: Employees
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

-- Table: IntermediateProducts
CREATE TABLE IntermediateProducts (
    ProductId int  NOT NULL IDENTITY,
    ProductName varchar(30)  NOT NULL,
    Notes text  NULL,
    CONSTRAINT IntermediateProducts_pk PRIMARY KEY  (ProductId)
);

-- Table: Menu
CREATE TABLE Menu (
    MenuPosition int  NOT NULL IDENTITY,
    MenuItemId int  NOT NULL,
    IsAvailable bit  NOT NULL,
    CONSTRAINT Menu_pk PRIMARY KEY  (MenuPosition)
);

-- Table: MenuItems
CREATE TABLE MenuItems (
    MenuItemId int  NOT NULL IDENTITY,
    CategoryId int  NOT NULL,
    UnitPrice money  NOT NULL CHECK (UnitPrice > 0),
    Description text  NOT NULL,
    Picture image  NOT NULL,
    LastTimeAdded date  NOT NULL,
    LastTimeRemoved date  NOT NULL,
    CONSTRAINT MenuItems_pk PRIMARY KEY  (MenuItemId)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderId int  NOT NULL IDENTITY,
    MenuItemId int  NOT NULL,
    Quantity int  NOT NULL CHECK (Quantity > 0),
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderId,MenuItemId)
);

-- Table: OrderStatuses
CREATE TABLE OrderStatuses (
    StatusId int  NOT NULL IDENTITY,
    StatusName varchar(30)  NOT NULL,
    Description text  NULL,
    CONSTRAINT OrderStatuses_pk PRIMARY KEY  (StatusId)
);

INSERT INTO OrderStatuses (StatusName,Description)
VALUES ('Order Placed','Order was placed by customer,
        and needs to be confirmed by an employee')

INSERT INTO OrderStatuses (StatusName,Description)
VALUES ('Accepted','Order was confirmed by an employee')
        
INSERT INTO OrderStatuses (StatusName,Description)
VALUES ('Served','Order was served')
        
INSERT INTO OrderStatuses (StatusName,Description)
VALUES ('Done','Order is complete')

INSERT INTO OrderStatuses (StatusName,Description)
VALUES ('Canceled','Order was canceled');

-- Table: Orders
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
    InvoiceTaken bit  NOT NULL DEFAULT 0,
    CONSTRAINT checkForStatusInter CHECK ((StatusId = 1 AND NOT CustomerId = NULL) OR (StatusId = 2 AND NOT EmployeeId = NULL AND NOT OrderApprovedDate = NULL) OR (StatusId = 3 AND NOT OrderServedDate = NULL) OR (StatusId > 3)),
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderId)
);

CREATE INDEX Status on Orders (StatusId ASC)
;

-- Table: Positions
CREATE TABLE Positions (
    PositionId int  NOT NULL IDENTITY,
    PositionName varchar(30)  NOT NULL,
    CONSTRAINT Positions_pk PRIMARY KEY  (PositionId)
);

-- Table: RecipesAndSuch
CREATE TABLE RecipesAndSuch (
    MenuItemId int  NOT NULL,
    ProductId int  NOT NULL,
    QuantityNeeded real  NOT NULL CHECK (QuantityNeeded > 0),
    CONSTRAINT RecipesAndSuch_pk PRIMARY KEY  (MenuItemId,ProductId)
);

-- Table: ReservationsInfo
CREATE TABLE ReservationsInfo (
    OrderId int  NOT NULL,
    TableId int  NOT NULL,
    ReservedFor varchar(255)  NOT NULL,
    ReservedFrom datetime  NOT NULL,
    ReservedTo datetime  NOT NULL,
    CONSTRAINT ReservationTimeMustBePositive CHECK ((ReservedTo - ReservedFrom) > 0),
    CONSTRAINT ReservationsInfo_pk PRIMARY KEY  (OrderId,TableId)
);

-- Table: Storage
CREATE TABLE Storage (
    BranchId int  NOT NULL,
    ProductId int  NOT NULL,
    Quantity real  NOT NULL CHECK (Quantity >=0),
    QuantityUnit varchar(30)  NOT NULL,
    MinQuantity real  NOT NULL,
    CONSTRAINT Storage_pk PRIMARY KEY  (ProductId,BranchId)
);

-- Table: Tables
CREATE TABLE Tables (
    TableId int  NOT NULL IDENTITY,
    Chairs tinyint  NOT NULL,
    BranchId int  NOT NULL,
    IsAvailable bit  NOT NULL,
    CONSTRAINT Tables_pk PRIMARY KEY  (TableId)
);

CREATE INDEX Branch on Tables (BranchId ASC)
;

-- foreign keys
-- Reference: Customers_CompanyInfo (table: Customers)
ALTER TABLE Customers ADD CONSTRAINT Customers_CompanyInfo
    FOREIGN KEY (CompanyId)
    REFERENCES CompanyInfo (CompanyId);

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

-- Reference: Menu_MenuItems (table: Menu)
ALTER TABLE Menu ADD CONSTRAINT Menu_MenuItems
    FOREIGN KEY (MenuItemId)
    REFERENCES MenuItems (MenuItemId);

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

-- Reference: RecipesAndSuch_IntermediateProducts (table: RecipesAndSuch)
ALTER TABLE RecipesAndSuch ADD CONSTRAINT RecipesAndSuch_IntermediateProducts
    FOREIGN KEY (ProductId)
    REFERENCES IntermediateProducts (ProductId);

-- Reference: RecipesAndSuch_MenuItems (table: RecipesAndSuch)
ALTER TABLE RecipesAndSuch ADD CONSTRAINT RecipesAndSuch_MenuItems
    FOREIGN KEY (MenuItemId)
    REFERENCES MenuItems (MenuItemId);

-- Reference: ReservationsInfo_Orders (table: ReservationsInfo)
ALTER TABLE ReservationsInfo ADD CONSTRAINT ReservationsInfo_Orders
    FOREIGN KEY (OrderId)
    REFERENCES Orders (OrderId);

-- Reference: ReservationsInfo_Tables (table: ReservationsInfo)
ALTER TABLE ReservationsInfo ADD CONSTRAINT ReservationsInfo_Tables
    FOREIGN KEY (TableId)
    REFERENCES Tables (TableId);

-- Reference: Storage_Branches (table: Storage)
ALTER TABLE Storage ADD CONSTRAINT Storage_Branches
    FOREIGN KEY (BranchId)
    REFERENCES Branches (BranchId);

-- Reference: Storage_IntermediateProducts (table: Storage)
ALTER TABLE Storage ADD CONSTRAINT Storage_IntermediateProducts
    FOREIGN KEY (ProductId)
    REFERENCES IntermediateProducts (ProductId);

-- Reference: Tables_Branches (table: Tables)
ALTER TABLE Tables ADD CONSTRAINT Tables_Branches
    FOREIGN KEY (BranchId)
    REFERENCES Branches (BranchId);

-- End of file.

