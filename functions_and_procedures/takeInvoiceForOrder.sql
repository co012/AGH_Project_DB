CREATE PROCEDURE takeInvoiceForOrder
(@orderId INT)
AS
BEGIN

IF (SELECT RepresentingCompany FROM Orders LEFT JOIN Customers ON Customers.CustomerId = Orders.CustomerId WHERE OrderId = @orderId) = 0 RETURN

DECLARE @customerId INT = (SELECT CustomerId FROM Orders WHERE OrderId = @orderId)

SELECT Name,Street,StreetNumber,City,PostCode,NIP FROM CompanyInfo LEFT JOIN Customers ON Customers.CompanyId = CompanyInfo.CompanyId WHERE @customerId = CustomerId

SELECT MAX(Name),SUM(Quantity) AS Quantity, (SUM(Quantity) * MAX(UnitPrice)) AS Price FROM OrderDetails LEFT JOIN MenuItems ON OrderDetails.MenuItemId = MenuItems.MenuItemId WHERE OrderId = @orderId GROUP BY OrderDetails.MenuItemId

SELECT SUM(PriceWithoutDiscount) as TotalPriceWithoutDiscount,SUM(FinalPrice) AS TotalFinalPrice FROM Orders WHERE OrderId = @orderId
END