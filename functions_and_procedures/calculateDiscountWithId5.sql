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