CREATE FUNCTION getMonthlyRaportAboutMenu(@date DATE)
RETURNS @menuReportTable TABLE (MenuItemId INT,Sold INT, AddedToMenuDate DATE)
AS
BEGIN

INSERT INTO @menuReportTable
SELECT OrderDetails.MenuItemId,SUM(Quantity),MAX(LastTimeAdded) FROM OrderDetails
LEFT JOIN Orders ON OrderDetails.OrderId = Orders.OrderId
LEFT JOIN MenuItems ON MenuItems.MenuItemId = OrderDetails.MenuItemId
WHERE DATEPART(month,OrderMadeDate) = DATEPART(month,@date)
GROUP BY OrderDetails.MenuItemId



RETURN;
END;