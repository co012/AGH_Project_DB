CREATE VIEW MenuView
AS
SELECT MenuItemId,Name,UnitPrice FROM MenuItems WHERE LastTimeAdded > LastTimeRemoved