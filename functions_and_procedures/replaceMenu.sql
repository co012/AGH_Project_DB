CREATE PROCEDURE replaceMenu(@replacement MenuReplacement READONLY)
AS
BEGIN
DELETE FROM Menu WHERE MenuItemId IN (SELECT OldMenuItemId FROM @replacement)
INSERT INTO Menu (MenuItemId) SELECT NewMenuItemId FROM @replacement
END