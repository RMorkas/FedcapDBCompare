


CREATE Function [dbo].[IsClientSanction]
(
@monthdate smalldatetime,
@caseId int
)
RETURNS bit
AS
BEGIN
declare @startMonth  smalldatetime, @isClientSanction bit, @count int, @startDate  smalldatetime
--set @monthdate = '04/30/2017'
--set @caseId = 30
SET @startDate = DATEADD(month, DATEDIFF(month, 0, @monthdate), 0)
Set @startMonth = DATEADD(mm,-11, @monthdate);
Set @startMonth = DATEADD(month, DATEDIFF(month, 0, @startMonth), 0)
set @isClientSanction = 0;
Set @count = 0;

SELECT distinct @count = COUNT(CaseId)
FROM    dbo.ClientSanction with(nolock) INNER JOIN
        dbo.CaseClient cc with(nolock) ON dbo.ClientSanction.Clientid = cc.ClientId
WHERE
cc.CaseId = @caseId
and
Sanction_StartDate <= @monthdate 
AND
(Sanction_EndDate IS NULL OR Sanction_EndDate >= @startDate)
IF(@count > 0)
--		SET @isClientSanction = 1;
--ELSE
BEGIN
	Set @count = 0;
	WITH caseSanction (Sanction_StartDate,Sanction_EndDate,CaseId,Clientid)
	as
	(
	SELECT distinct Sanction_StartDate = 
			CASE 
				WHEN Datediff(mm ,Sanction_StartDate, Isnull(Sanction_EndDate, @monthdate)) + 1 > 12 Then @startMonth 
				else Sanction_StartDate 
			end, Isnull(Sanction_EndDate, @monthdate) as Sanction_EndDate, CaseId, cc.Clientid
	FROM    dbo.ClientSanction with(nolock) INNER JOIN
			dbo.CaseClient cc with(nolock) ON dbo.ClientSanction.Clientid = cc.ClientId
	WHERE
	(Sanction_StartDate >= @startMonth OR (Sanction_StartDate < @startMonth AND Sanction_EndDate IS NULL)) AND cc.CaseId = @caseId
	)

	SELECT @count = SUM(Datediff(mm ,Sanction_StartDate,Sanction_EndDate) + 1) 
	FROM caseSanction
	Where CaseId = @caseId
	--group by CaseId
	--Having SUM(Datediff(mm ,Sanction_StartDate,Sanction_EndDate) + 1) > 3

	IF(@count >3)
		SET @isClientSanction = 0;
	ELSE
		SET @isClientSanction = 1;
END

Return @isClientSanction
END





