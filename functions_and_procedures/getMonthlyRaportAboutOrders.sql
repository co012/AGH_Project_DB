CREATE FUNCTION getMonthlyReportAboutOrders(@date DATE)
RETURNS @orderReportTable TABLE(OrderStatus INT,OrdersMade INT)
AS
BEGIN
INSERT INTO @orderReportTable SELECT StatusId,COUNT(*) FROM Orders WHERE YEAR(@date) = YEAR(OrderMadeDate) AND DATEPART(month,@date) = DATEPART(month,OrderMadeDate) GROUP BY StatusId;
RETURN;
END