




Create proc [dbo].[DeleteHistoricalActivity]
@companyId int
AS
Declare @scheduledId int, @clientId int, @caseStatus varchar(2)

DECLARE cursorSchedule CURSOR -- Declare cursor
static
FOR
	
--	select MAX(ScheduleId) AS ScheduleId from dbo.Schedule ss with(nolock) join CaseClient cc with(nolock) on cc.ClientId = ss.ClientId join VW_CaseMonthlyCalc vw with(nolock) on cc.CaseId = vw.CaseId
--	where ss.ClientId in 
--	(
--		SELECT        ClientId
--		FROM            dbo.Schedule
--		WHERE        (IsVisible = 0)
--		GROUP BY ClientId
--	)
----and
----ss.IsVisible = 0
--and
--YEAR(ss.[Date]) = YEAR(vw.MonthDate) AND MONTH(ss.[Date]) = MONTH(vw.MonthDate)
--and ss.UpdatedAt is null and
--vw.CaseJSJRActualHoursFY >= 481
--group by ss.ClientId, vw.MonthDate

--select max(ScheduleId) as ScheduleId from
--(
--select ROW_NUMBER() over(PARTITION BY clientId ORDER BY clientId) as id , clientId, s.ScheduleId from dbo.Schedule s with(nolock)
--where IsDeleted  = 0 and IsVisible = 1 and UpdatedAt = '04/14/2017'
--group by ClientId, right(convert(varchar(10),s.Date,103),7), s.ScheduleId
--) as temp
--group by ClientId


SELECT ScheduleId
FROM
(
    SELECT ROW_NUMBER() OVER(PARTITION BY clientId, RIGHT(CONVERT(VARCHAR(10), s.Date, 103), 7) ORDER BY clientId) AS id,
           clientId,
           s.ScheduleId,
           RIGHT(CONVERT(VARCHAR(10), s.Date, 103), 7) AS Mnth
    FROM dbo.Schedule s WITH (nolock)
    WHERE IsDeleted = 0
          AND IsVisible = 1
          AND FederalActivityId IN(1, 2, 3)
    GROUP BY ClientId,
             RIGHT(CONVERT(VARCHAR(10), s.Date, 103), 7),
             s.ScheduleId
) AS temp
WHERE id = 1
ORDER BY ClientId;


OPEN cursorSchedule -- open the cursor

FETCH NEXT FROM cursorSchedule INTO @scheduledId

WHILE @@FETCH_STATUS = 0
BEGIN
	
	UPDATE dbo.Schedule SET NoteSchedule = NoteSchedule + ' '
	WHERE dbo.Schedule.ScheduleId = @scheduledId

	FETCH NEXT FROM cursorSchedule INTO @scheduledId
END
CLOSE cursorSchedule -- close the cursor
DEALLOCATE cursorSchedule -- Deallocate the cursor
