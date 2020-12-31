CREATE VIEW PossibleMenuItemsView
AS
SELECT MenuItemId,Name,UnitPrice FROM MenuItems WHERE DATEDIFF(MONTH,LastTimeRemoved,GETDATE()) >= 1 AND LastTimeAdded < LastTimeRemoved