CREATE PROCEDURE serveOrder (@orderId INT)
AS
BEGIN
UPDATE Orders
SET OrderServedDate = GETDATE(),StatusId = 3
WHERE OrderId = @orderId
END