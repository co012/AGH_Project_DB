# Dokumentacja  
## Schemat  
![Schemat](schemat.png)
## Tabele  
### Branches  
Tabela przechowuje dane o oddziałach firmy  

**BranchId**- Identyfikator oddziału  
**Street**- Ulica  
**StreetNumber**- Numer budynku  
**Apartament**- Numer pokoju/apartamentu  
**City**- Miasto  
**PostCode**-Kod pocztowy
**Area**-Powierzchnia lokalu

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







