CREATE FUNCTION getRaportAboutCustomers()
RETURNS @customerRaportTable TABLE (CustomerId INT, OrdersMade INT, TotalPriceWithoutDiscount MONEY,TotalFinalPrice MONEY, TotalLoseOnDiscounts MONEY)
AS
BEGIN

INSERT INTO @customerRaportTable SELECT CustomerId,COUNT(*),SUM(PriceWithoutDiscount),SUM(FinalPrice),SUM(PriceWithoutDiscount - FinalPrice) FROM Orders WHERE NOT StatusId = 5 GROUP BY CustomerId

RETURN;
END