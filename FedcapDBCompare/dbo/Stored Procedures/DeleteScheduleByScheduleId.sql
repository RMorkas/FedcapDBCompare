
create proc [dbo].[DeleteScheduleByScheduleId]
@CompanyId int,
@clientId int,
@updatedBy varchar(80),
@updateAt datetime,
@lstScheduleId StringList  READONLY 
AS
Update dbo.Schedule Set IsDeleted = 1, UpdatedBy = @updatedBy, UpdatedAt= @updateAt
Where CompanyId = @CompanyId And ClientId = @clientId And ScheduleId in (select item From @lstScheduleId) 