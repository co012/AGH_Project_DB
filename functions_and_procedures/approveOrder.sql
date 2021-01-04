CREATE PROCEDURE approveOrder (@orderId INT,@employeeId INT)
AS
BEGIN
UPDATE Orders
SET OrderApprovedDate = GETDATE(),StatusId = 2,EmployeeId = @employeeId
WHERE OrderId = @orderId
END