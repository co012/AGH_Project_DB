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


IF (SELECT RepresentingCompany FROM Customers WHERE CustomerId = @customerId) = 0 RETURN 0;

DECLARE @maxStreak INT = CEILING( @maxDiscount / @minDiscount );
DECLARE @streak INT = 0;
DECLARE @YMIterator INT = dbo.getPreviousYearMonth(@nowYM);

WHILE @streak < @maxStreak
BEGIN
    DECLARE @TotalPrice MONEY, @OrdersMade INT;
    SELECT @TotalPrice =  SUM(FinalPrice), @OrdersMade = COUNT(*) FROM Orders WHERE CustomerId = @customerId AND dbo.getYearMonth(OrderMadeDate) = @YMIterator AND NOT StatusId = 5;
    IF ISNULL(@TotalPrice,0) < @minPrice OR @OrdersMade < @minOrders BREAK;
    SET @streak = @streak + 1;
    SET @YMIterator = dbo.getPreviousYearMonth(@YMIterator);
END


IF @maxDiscount < @minDiscount * @streak RETURN @maxDiscount;
RETURN @minDiscount * @streak;
END
