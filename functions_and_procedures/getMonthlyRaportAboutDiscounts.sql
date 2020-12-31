CREATE FUNCTION getWeeklyRaportAboutDiscounts(@date DATE)
RETURNS @discountReportTable TABLE (DiscountId INT, TotalPriceWithoutDiscount INT, TotalLoss INT, OrdersWithDiscountNumber INT)
AS
BEGIN

INSERT INTO @discountReportTable SELECT DiscountTypeId,SUM(PriceWithoutDiscount),SUM(PriceWithoutDiscount) - SUM(FinalPrice),COUNT(*) FROM Orders
WHERE YEAR(@date) = YEAR(OrderMadeDate) AND DATEPART(WEEK,@date) = DATEPART(WEEK,OrderMadeDate) GROUP BY DiscountTypeId



RETURN;
END;