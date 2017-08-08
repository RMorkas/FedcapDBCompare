CREATE proc isValidVocEd
@companyId int,
@clientId int,
@date smalldatetime
AS
Select Distinct top 1 right(convert(varchar(10),[Date],105),7) MonthYear From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @companyId
AND
s.ClientId = @clientId
AND
s.AttendanceStatus in (0,1,2,3,5)  --Scheduled
AND
S.FederalActivityId = 8 --(Vocational Educational Training)
AND
ISNULL(s.IsDeleted,0) = 0
AND
right(convert(varchar(10),[Date],105),7) = right(convert(varchar(10),@date,105),7)