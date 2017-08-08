Create proc getTabScores
@clientId int,
@companyId int
as
declare @sqlString nvarchar(max),@server varchar(50)

IF @companyId = 1
SET @server = '[ALLSECTOR_PROD_R1]'
ELSE
SET @server = '[ALLSECTOR_PROD_R2]'

set @sqlString = 'SELECT *
FROM OPENQUERY(' + @server + ', ''SELECT data.* FROM dbo.cmdata data WITH (NOLOCK) JOIN 
									[dbo].[cmcaseforms] form ON data.RecordId = form.TrackNumber
									WHERE form.FormId = 804 AND data.FieldName IN (''''readingscore_TABE'''', ''''appliedmath_TABE'''') AND form.CaseId = ' + cast(@clientId as varchar(100)) + '
									ORDER BY data.ID'')'
execute(@sqlString)