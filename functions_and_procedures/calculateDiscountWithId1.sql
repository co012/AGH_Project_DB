CREATE FUNCTION calculateDiscountWithId1 (@CustomerId INT)
RETURNS REAL
AS
BEGIN
DECLARE @typeId INT = 1;
DECLARE @minVal MONEY;
DECLARE @minOrders INT;
SET @minVal = (SELECT MinPrice FROM DiscountsTypes where DiscountTypeId = @typeId);
SET @minOrders = (SELECT MinOrders FROM DiscountsTypes where DiscountTypeId = @typeId)

DECLARE @var REAL = 0;
SET @var = (SELECT COUNT(*) FROM Orders WHERE CustomerId = @CustomerId AND FinalPrice > @minVal AND NOT StatusId = 5)/@minOrders;

IF @var >= 2 RETURN (SELECT CurrentMaxDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId)
ELSE IF @var >= 1 RETURN (SELECT CurrentMinDiscount FROM DiscountsTypes WHERE DiscountTypeId = @typeId);

RETURN 0

END;