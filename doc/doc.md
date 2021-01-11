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
Przechowuje informacje o klientach.  

**CustomerId** - Identyfikator klienta  
**ContactPersonFirstName** - Imię osoby kontaktowej, w przypadku klientów indywidualnych jest to imię klienta  
**ContactPersonLastName**   - Nazwisko osoby kontaktowej, w przypadku klientów indywidualnych jest to nazwisko klienta  
**Email** - E-mali klienta  
**Phone** - Telefon kontaktowy  
**RepresentingCompany** - Flaga informująca czy klient jest indywidualny ( = 0) czy raczej reprezentuje firmę ( = 1)  
**CompanyId** - Identyfikator firmy, może przyjmować wartość NULL  

Na tabele narzucony jest warunek by RepresentingCompany = (NOT CompanyId = NULL)  

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







