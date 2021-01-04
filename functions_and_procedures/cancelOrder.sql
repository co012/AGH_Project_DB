CREATE PROCEDURE cancelOrder (@orderId INT)
AS
BEGIN
UPDATE Orders
SET StatusId = 5
WHERE OrderId = @orderId
END