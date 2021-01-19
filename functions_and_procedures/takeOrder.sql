CREATE PROCEDURE takeOrder
(@branchId INT,@customerId INT,@employeeId INT,@discountType INT, @orderServeDate DATETIME,@orderDetails OrderDetailsTable READONLY,@reservations ReservationTable READONLY)
AS
BEGIN

DECLARE @priceWithoutDiscount MONEY = (SELECT SUM(UnitPrice * Quantity) FROM MenuItems LEFT JOIN @orderDetails od ON MenuItems.MenuItemId = od.MenuItemId);
DECLARE @finalPrice MONEY;
DECLARE @discount REAL;

SET @discount = dbo.getDiscount(@discountType,@customerId)

SET @finalPrice = @priceWithoutDiscount * (1 - ISNULL(@discount,0))

DECLARE @withReservation BIT = (SELECT (CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END)  FROM @reservations)
IF @withReservation = 1 AND @customerId = NULL RETURN 
IF (SELECT COUNT(*) FROM @orderDetails) > (SELECT COUNT(*) FROM MenuView INNER JOIN @orderDetails od ON od.MenuItemId = MenuView.MenuItemId) RETURN; 

DECLARE @orderIdTable TABLE(orderId INT);
INSERT INTO Orders(BranchId,CustomerId,EmployeeId,StatusId,WithReservation,PriceWithoutDiscount,DiscountTypeId,Discount,FinalPrice,Paid,OrderMadeDate,OrderApprovedDate,OrderServeDate)
OUTPUT inserted.OrderId INTO @orderIdTable
VALUES(@branchId,@customerId,@employeeId,2,@withReservation,@priceWithoutDiscount,@discountType,@discount,@finalPrice,0,GETDATE(),GETDATE(),@orderServeDate);

DECLARE @orderId INT = (SELECT TOP 1 orderId FROM @orderIdTable);

INSERT INTO OrderDetails SELECT @orderId,MenuItemId,Quantity FROM @orderDetails;
IF (SELECT COUNT(*) FROM OrderDetails WHERE OrderId = @orderId ) < (SELECT COUNT(*) FROM @orderDetails) 
BEGIN
DELETE FROM Orders WHERE OrderId = @orderId;
RETURN
END
INSERT INTO ReservationsInfo SELECT @orderId,* FROM @reservations
IF (SELECT COUNT(*) FROM ReservationsInfo WHERE OrderId = @orderId) < (SELECT COUNT(*) FROM @reservations) DELETE FROM Orders WHERE OrderId = @orderId

END