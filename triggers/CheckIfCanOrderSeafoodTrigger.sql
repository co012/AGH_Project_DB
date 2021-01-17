CREATE TRIGGER CheckIfCanOrderSeafoodTrigger
ON OrderDetails
INSTEAD OF INSERT
AS
BEGIN

DECLARE @ordersToCheck TABLE(OrderId INT);
INSERT INTO @ordersToCheck SELECT DISTINCT OrderId FROM inserted LEFT JOIN MenuItems ON inserted.MenuItemId = MenuItems.MenuItemId WHERE CategoryId in (5,17);

DECLARE @datesToCheck TABLE (OrderMadeDate DATE,OrderServeDate DATE)
INSERT INTO @datesToCheck SELECT OrderMadeDate,OrderServeDate FROM Orders INNER JOIN @ordersToCheck otc ON otc.OrderId = Orders.OrderId
-- SUNDAY ~ 1
IF 0 < (SELECT COUNT(*) FROM @datesToCheck WHERE  DATEPART(weekday,OrderServeDate) < 5)
BEGIN
RAISERROR('Cant order seefood on that day',-1,-1)
RETURN
END

IF 0 < (SELECT COUNT(*) FROM @datesToCheck WHERE DATEDIFF(day,OrderMadeDate,OrderServeDate) < DATEPART(day,OrderMadeDate))
BEGIN
RAISERROR('It is to late to order seefood for this day',-1,-1)
RETURN
END 

INSERT INTO OrderDetails SELECT * FROM inserted
END