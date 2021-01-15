DECLARE @customerId INT;

DECLARE @ids TABLE(id INT);
INSERT INTO Customers (ContactPersonFirstName,ContactPersonLastName,Email,Phone,RepresentingCompany)
OUTPUT inserted.CustomerId INTO @ids
VALUES ('discountTest','1','c@o.pl','123123123',0)

SET @customerId = (SELECT TOP 1 id FROM @ids)

SELECT dbo.calculateDiscountWithId1(@customerId) AS Given, 0 AS Expected

DECLARE @minVal MONEY;
DECLARE @minOrders INT;
SET @minVal = (SELECT MinPrice FROM DiscountsTypes where DiscountTypeId = 1);
SET @minOrders = (SELECT MinOrders FROM DiscountsTypes where DiscountTypeId = 1)

DECLARE @i INT = 0
WHILE @i < @minOrders
BEGIN
INSERT INTO Orders(BranchId,CustomerId,StatusId,WithReservation,PriceWithoutDiscount,DiscountTypeId,Discount,FinalPrice,Paid,OrderMadeDate,OrderServeDate)
--OUTPUT inserted.*
VALUES(1,@customerId,4,0,@minVal,NULL,0,@minVal,0,GETDATE(),GETDATE());
SET @i = @i + 1;
END

SELECT dbo.calculateDiscountWithId1(@customerId) AS Given, (SELECT CurrentMinDiscount FROM DiscountsTypes WHERE DiscountTypeId = 1) AS Expected

--SELECT * FROM Orders WHERE CustomerId = @customerId

SET @i  = 0
WHILE @i < @minOrders
BEGIN
INSERT INTO Orders(BranchId,CustomerId,StatusId,WithReservation,PriceWithoutDiscount,DiscountTypeId,Discount,FinalPrice,Paid,OrderMadeDate,OrderServeDate)
--OUTPUT inserted.*
VALUES(1,@customerId,4,0,@minVal,NULL,0,@minVal,0,GETDATE(),GETDATE());
SET @i = @i + 1;
END

SELECT dbo.calculateDiscountWithId1(@customerId) AS Given, (SELECT CurrentMaxDiscount FROM DiscountsTypes WHERE DiscountTypeId = 1) AS Expected
--Company Test
DELETE FROM @ids
INSERT INTO CompanyInfo(Name, Street, StreetNumber, PostCode, City, NIP)
OUTPUT inserted.CompanyId INTO @ids
VALUES ('T','E','S','T','1','1929219219')
UPDATE Customers SET RepresentingCompany = 1,CompanyId = (SELECT TOP 1 id FROM @ids) WHERE CustomerId = @customerId
SELECT dbo.calculateDiscountWithId1(@customerId) AS Given, 0 AS Expected
DELETE FROM Customers WHERE CustomerId = @customerId

