


CREATE Proc [dbo].[UpdateChildTables]
@ChildTableName varchar(80),
@ChildPKName varchar(80),
@ParentPKName varchar(80),
@ParentPKValue int
AS
Declare @SQLString nvarchar(Max)
SET @SQLString = '
Declare @count int , @index int, @ChildRowsCount int
SET @index = 1
SELECT ROW_NUMBER() OVER (ORDER BY ' + @ChildPKName + ') AS RowIndex, ' + @ChildPKName + 
' INTO #ChildData FROM ' + @ChildTableName + ' With(Nolock) WHERE ' + @ParentPKName + ' = ' + CAST(@ParentPKValue AS varchar(80)) +
' 
SET @ChildRowsCount = (SELECT COUNT(*) FROM #ChildData)

WHILE (@index <= @ChildRowsCount)
	BEGIN
		Update ' + @ChildTableName + ' SET ParentLastSave = GETDATE() Where ' + @ParentPKName + ' = ' + CAST(@ParentPKValue AS varchar(80)) + ' AND ' + @ChildPKName + ' = (SELECT ' + @ChildPKName + ' FROM #ChildData WHERE RowIndex = @index)' +
		' 
		SET @index = @index + 1;
	END'
--Print @SQLString
Execute(@SQLString)