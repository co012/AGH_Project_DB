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

SET @minDiscount = (SELECT CurrentMinDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @maxDiscount = (SELECT CurrentMaxDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @minPrice = (SELECT MinPrice FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @minOrders = (SELECT MinOrders FROM DiscountsTypes WHERE DiscountTypeId = @typeId);
SET @from = (SELECT YM FROM
(SELECT dbo.GETYEARMOUNTH(OrderMadeDate) as YM,FinalPrice 
FROM Orders WHERE dbo.GETYEARMOUNTH(OrderMadeDate)  < dbo.GETYEARMOUNTH(GETDATE()) AND CustomerId = @customerId) as T)




RETURN 0;
END
