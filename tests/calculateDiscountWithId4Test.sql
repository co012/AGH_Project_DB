DECLARE @customerId INT;

DECLARE @ids TABLE(id INT);
INSERT INTO Customers (ContactPersonFirstName,ContactPersonLastName,Email,Phone,RepresentingCompany)
OUTPUT inserted.CustomerId INTO @ids
VALUES ('discountTest','4','c@o.pl','123123223',0)

SET @customerId = (SELECT TOP 1 id FROM @ids)

DELETE FROM @ids WHERE id = @customerId
INSERT INTO CompanyInfo(Name, Street, StreetNumber, PostCode, City, NIP)
OUTPUT inserted.CompanyId INTO @ids
VALUES ('T','E','S','T','4','1929416319')


UPDATE Customers SET RepresentingCompany = 1,CompanyId = (SELECT TOP 1 id FROM @ids) WHERE CustomerId = @customerId

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

DECLARE @i INT = 0;
DECLARE @d DATE  = DATEADD(month,-1,GETDATE());

WHILE (@i-1) * @minDiscount <= @maxDiscount
BEGIN
SELECT dbo.calculateDiscountWithId4(@customerId) AS Given, @i * @minDiscount AS Expected

DECLARE @j INT = 0;
WHILE @j < @minOrders
BEGIN
INSERT INTO Orders(BranchId,CustomerId,StatusId,WithReservation,PriceWithoutDiscount,DiscountTypeId,Discount,FinalPrice,Paid,OrderMadeDate,OrderServeDate)
--OUTPUT inserted.*
VALUES(1,@customerId,4,0,CEILING(@minPrice/@minOrders),NULL,0,CEILING(@minPrice/@minOrders),0,@d,@d);
SET @j = @j + 1;
END
SET @d = DATEADD(month,-1,@d);
SET @i = @i + 1;
END

SELECT dbo.calculateDiscountWithId4(@customerId) AS Given, @maxDiscount AS Expected

DELETE FROM Orders WHERE CustomerId = @customerId AND MONTH(OrderMadeDate) = MONTH(DATEADD(month,-1,GETDATE()))

SELECT dbo.calculateDiscountWithId4(@customerId) AS Given, 0 AS Expected
DELETE FROM CompanyInfo WHERE CompanyId = (SELECT TOP 1 id FROM @ids)
DELETE FROM Customers WHERE CustomerId = @customerId
