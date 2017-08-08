
CREATE PROC [dbo].[temp_GeneratePeriod]
@Id int, @jobStart smalldatetime, @endDate smalldatetime,@periodId int, @mileston int,@sequence int
AS

DECLARE @availabilityDate smalldatetime, @expirationDate smalldatetime, @isJobLost bit


Set @availabilityDate = (Select DATEADD(day,@mileston,@jobStart))
Set @expirationDate = (SELECT DATEADD(day,@mileston + 75 + 1,@jobStart))

IF (@endDate IS NULL)
	SET @isJobLost = 0
ELSE IF(@availabilityDate > @endDate)
	SET @isJobLost = 1
ELSE
	SET @isJobLost = 0
	
  
INSERT INTO [dbo].[PlacementPeriod] (PlacementEntryID, [Sequence], PeriodId, Comment, AvailabilityDate, ExpirationDate, PlacementRetentionId, IsLostJob, IsReplaced)
Values(@Id, @sequence, @periodId, NULL, @availabilityDate, @expirationDate, NuLL, @isJobLost,0);