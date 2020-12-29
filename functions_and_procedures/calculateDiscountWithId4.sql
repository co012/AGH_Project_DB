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
SET @from = ( SELECT TOP 1 YM FROM
(SELECT YM,Count(*) as OrdersMade, sum(FinalPrice) as TotalPrice FROM
(SELECT dbo.getYearMonth(OrderMadeDate) as YM,FinalPrice 
FROM Orders WHERE dbo.getYearMonth(OrderMadeDate)  < @nowYM AND CustomerId = @customerId AND NOT StatusId = 5 ) as T GROUP BY T.YM ORDER BY T.YM DESC) AS T2
WHERE T2.OrdersMade < @minOrders OR T2.TotalPrice < @minPrice
);

IF @from = NULL SET @from = 0;

RETURN (SELECT COUNT(DISTINCT dbo.getYearMonth(OrderMadeDate)) FROM Orders WHERE dbo.getYearMonh(OrderMadeDate) > @from);
END
