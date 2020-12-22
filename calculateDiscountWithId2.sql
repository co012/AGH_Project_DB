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

IF (SELECT COUNT(*) FROM Orders WHERE CustomerId = @CustomerId AND DiscountTypeId = @typeId) > 0
BEGIN
	DECLARE @discountDate DATETIME = 
	(SELECT TOP 1 OrderMadeDate FROM Orders WHERE CustomerId = @CustomerId AND DiscountTypeId = @typeId ORDER BY OrderMadeDate ASC);

	IF DATEDIFF(day,@discountDate,GETDATE()) < @duration RETURN @discount
	ELSE RETURN 0;
END
ELSE IF (SELECT SUM(FinalPrice) FROM Orders  WHERE CustomerId = @CustomerId AND DiscountTypeId = @typeId) > @minVal RETURN @discount;

RETURN 0

END;