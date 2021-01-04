CREATE PROCEDURE finishOrder (@orderId INT)
AS
BEGIN
UPDATE Orders
SET StatusId = 4
WHERE OrderId = @orderId
END