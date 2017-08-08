CREATE TABLE [dbo].[Schedule] (
    [ScheduleId]                  INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]                   INT           NULL,
    [SiteId]                      INT           NULL,
    [ClientId]                    INT           NULL,
    [ClassInstRoomId]             INT           NULL,
    [EventId]                     INT           NULL,
    [EventUserId]                 INT           NULL,
    [ExternalAddress]             VARCHAR (300) NULL,
    [DayName]                     VARCHAR (50)  NULL,
    [Date]                        SMALLDATETIME NULL,
    [StartTime]                   DATETIME      NULL,
    [EndTime]                     DATETIME      NULL,
    [ScheduledHours]              INT           NULL,
    [NoteSchedule]                VARCHAR (MAX) NULL,
    [AttendanceStatus]            INT           NULL,
    [AttendanceType]              INT           NULL,
    [SignInTime]                  DATETIME      NULL,
    [SignOutTime]                 DATETIME      NULL,
    [NoteAttendance]              VARCHAR (MAX) NULL,
    [IsDeleted]                   BIT           CONSTRAINT [DF_Schedule_IsDeleted] DEFAULT ((0)) NULL,
    [IsCoreActivity]              BIT           NULL,
    [FederalActivityId]           INT           NULL,
    [CreatedBy]                   VARCHAR (80)  NULL,
    [CreatedAt]                   DATETIME      NULL,
    [UpdatedBy]                   VARCHAR (80)  NULL,
    [UpdatedAt]                   DATETIME      NULL,
    [ExcuseNote]                  VARCHAR (MAX) NULL,
    [IsVisible]                   BIT           CONSTRAINT [DF_Schedule_IsActive] DEFAULT ((1)) NULL,
    [CourseId]                    INT           NULL,
    [WepSitePositionAssignmentId] INT           NULL,
    CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED ([ScheduleId] ASC),
    CONSTRAINT [FK_Schedule_ScheduleClassInstRoom] FOREIGN KEY ([ClassInstRoomId]) REFERENCES [dbo].[ScheduleClassInstRoom] ([ClassInstRoomId]),
    CONSTRAINT [FK_Schedule_ScheduleEvent] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ScheduleEvent] ([EventId])
);


GO
CREATE NONCLUSTERED INDEX [index_ScheduleClientId]
    ON [dbo].[Schedule]([ClientId] ASC);


GO
CREATE NONCLUSTERED INDEX [index_ScheduleDate]
    ON [dbo].[Schedule]([Date] ASC);


GO




CREATE TRIGGER [dbo].[ScheduledLog] ON [dbo].[Schedule] 
FOR UPDATE , INSERT
AS

/*
******	Standard Script to Create LOG Trigger on Parent table  ******
*/

Declare @TableName nvarchar(80) , @count int , @index int, @columnName nvarchar(100) , @oldValue nvarchar(max) ,@newValue nvarchar(max) , 
@SQLString nvarchar(Max) , @outPut nvarchar(max), @TableId int , @PKFieldName nvarchar(80),
@PKFieldValue int , @SavedBy varchar(80) , @SavedAt DateTime , @UpdatedBy varchar(80) , @TranSavedId int , @IsUpdatedTrigger int,
@lastSequence int, @MaxRetry int, @RetryCount int

SET @RetryCount = 0
SET @MaxRetry = 3
Set @TableName = N'Schedule'

IF OBJECT_ID('tempdb.dbo.#Inserted', 'U') IS NOT NULL
  DROP TABLE #Inserted; 

IF OBJECT_ID('tempdb.dbo.#Deleted', 'U') IS NOT NULL
  DROP TABLE #Deleted; 

SELECT * INTO #Inserted  FROM inserted
SELECT * INTO #Deleted  FROM deleted

Select @IsUpdatedTrigger = Count(*) From #Deleted

--To get count of columns.
SELECT @count = Count(Column_Name)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName

--To get tableId and Primary Key Field name
SELECT @TableId = TableId , @PKFieldName = PKFieldName FROM Fed_LogTables With(NoLock) Where TableName = @TableName

--To get primary key value
SET @SQLString = ' select @outPut = [' + @PKFieldName + '] from #Inserted '
exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
Set @PKFieldValue =  CAST(@outPut AS int)

--To get last Sequence.
SELECT @lastSequence = ISNULL((Max(ISNULL([Sequence],0)) + 1),1) FROM [dbo].[Fed_LogTransaction] with(nolock) WHERE [TableId] = @TableId AND [PKFieldValue] = @PKFieldValue

RETRY:
BEGIN TRANSACTION
BEGIN TRY

	IF(@IsUpdatedTrigger = 0)
	BEGIN
		SET @SQLString ='Insert Into [dbo].[Fed_LogTransaction] (TableId, PKFieldValue,Sequence, SavedBy, SavedAt)
						 SELECT ' + Cast(@TableId as varchar(100)) + ' , ' + @PKFieldName + ' , ' + Cast(@lastSequence AS nvarchar(max)) + ' , CreatedBy , CreatedAt FROM #Inserted '
	END
	ELSE
	BEGIN
		SET @SQLString ='Insert Into [dbo].[Fed_LogTransaction] (TableId, PKFieldValue,Sequence, SavedBy, SavedAt)
						 SELECT ' + Cast(@TableId as varchar(100)) + ' , ' + @PKFieldName + ' , ' + Cast(@lastSequence AS nvarchar(max)) + ' , UpdatedBy , UpdatedAt FROM #Inserted '
	END

	exec sp_executesql @SQLString
	
	SET @RetryCount = 0
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT 'Rollback Transaction'
	ROLLBACK TRANSACTION
	IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
	BEGIN
		IF (@RetryCount < @MaxRetry)
		BEGIN
			SET @RetryCount = @RetryCount + 1
			WAITFOR DELAY '00:00:00.10' -- Wait for 5 ms
			GOTO RETRY
		END
		ELSE
		BEGIN
			SET @RetryCount = 0
			Return
		END
	END
END CATCH

SET @TranSavedId = (SELECT IDENT_CURRENT('Fed_LogTransaction'))
SELECT @SavedBy = [SavedBy] , @SavedAt = [SavedAt] FROM [dbo].[Fed_LogTransaction] With(nolock) WHERE [TranSavedId] = @TranSavedId

Set @index = 1;
While (@index <= @count)
	BEGIN
		SET @outPut = null;
		Set @oldValue = null;
		Set @newValue = null;

		SELECT @columnName = COLUMN_NAME 
							FROM INFORMATION_SCHEMA.COLUMNS 
							WHERE TABLE_NAME = @TableName 
							AND ORDINAL_POSITION = @index
							ORDER BY ORDINAL_POSITION ASC
		--print ' ================ ' + @columnName
	
		IF (@IsUpdatedTrigger = 1) --Execute this part only for update transaction
			BEGIN
				SET @SQLString = ' select @outPut = [' + @columnName + '] from #Deleted '
				exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
				Set @oldValue =  @outPut
			END

		SET @SQLString = 'select @outPut = [' + @columnName + '] from #Inserted '
		exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
		Set @newValue = @outPut
	
		exec InsertLogData @TranSavedId ,NULL, NULL, @columnName , @oldValue , @newValue , @SavedBy

		SET @index = @index + 1;
	END
GO



CREATE TRIGGER [dbo].[ScheduleCalc] ON [dbo].[Schedule] 
After INSERT, UPDATE, Delete
AS

Declare @CompanyId int, @ClientId int, @monthDate smalldatetime, @StartDate smalldatetime, @EndDate Smalldatetime, @AttendStatus int,
@DOB smalldatetime, @Age int, @TeenAge int, @HSDiploma Bit, @GED bit,
@ActiveCaseId int, @CaseClientId int, @ClientMonthlyCalcId int,
@ScheduledHours int, @ActualHours int,
@IsTeenParent int,
@CoreActualHours int, @NonCoreActualHours int, @CoreScheduledHours int, @NonCoreScheduledHours int, @ScheduledRemainingHours int,
@FLSAActualHours int, @FLSAScheduledHours int, @RemainingFLSAScheduledHours int, @FLSAAttendStatusScheduledHrs int,
@FiscalStartDate smalldatetime, @FiscalEndDate smalldatetime, @RemaingCoreEDREHours int, @ClientEDREHoursFY int, @ClientRemainingEDREHoursFY int,
@VocEdMaxMonths int, @ClientVocEdMonths int, @ClientRemainingVocEdMonths int, @ClientVocEdMonthsScheduled int,
@WEPMaxHours int, @ClientWEPHours int, @ClientRemainingWEPHours int,
@OJTMaxHours int, @ClientOJTHours int, @ClientRemainingOJTHours int, @ClientOJTScheduledHrs int,
@JSJRMaxHours int, @ClientJSJRHoursFY int, @ClientRemainingJSJRHoursFY int, @ClientJSJRScheduledHrs int,
@ClientJSJRConsecutiveHoursFY int, @ClientRemainingJSJRConsecutiveHoursFY int,
@AbsentHoursMonthCount int, @AbsentHoursYearCount int, 
@FoodStampSubsidy numeric(18,2), @TANSubsidy numeric(18,2), @ChildCareSubsidy bit, @IsTwoParentCase bit, @IsChildUnderSix bit,
@ClientVOCEDHours int, @ClientVOCEDScheduledHrs int, @MaxRetry int, @RetryCount int,
@EmploymentScheduledHours int, @EmploymentActualHours int

SET @RetryCount = 0
SET @MaxRetry = 3

Set @ClientMonthlyCalcId = 0;
Set @TeenAge = 20;
------------------

--Select the inserted Record.
Select @CompanyId=CompanyId, @ClientId = ClientId, @monthDate = [Date], @AttendStatus = AttendanceStatus from inserted

--Only fire the Trigger for BTC
IF(@CompanyId <> 8) 
BEGIN
	return
END
-----------------

SET  @EndDate = DATEADD(day, DATEDIFF(day, 0, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@monthDate)+1,0))), 0)
SET  @StartDate = DATEADD(month, DATEDIFF(month, 0, @monthDate), 0)
-----------------

Select @FiscalStartDate = StartDate, @FiscalEndDate = EndDate, @VocEdMaxMonths = VocEdMaxMonths, @RemaingCoreEDREHours = RemaingCoreEDREHours From VW_CompanyFiscalCalc FY With(Nolock)
WHERE 
FY.CompanyId = @CompanyId
AND
(
(dateadd(day,0,datediff(day,0, @monthDate))>= dateadd(day,0,datediff(day,0, FY.StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, @monthDate))<= dateadd(day,0,datediff(day,0, FY.EndDate)))
)

SET @VocEdMaxMonths = ISNULL(@VocEdMaxMonths,0)
SET @RemaingCoreEDREHours = ISNULL(@RemaingCoreEDREHours,0)
-----------------

--Select Client.
Select @ActiveCaseId = ActiveCaseId, @DOB = DOB, @HSDiploma = ISNULL(HSDiploma,0), @GED = ISNULL(GED,0) From dbo.Client 
Where CompanyId = @CompanyId 
AND 
ClientId = @ClientId

-----------------

--Select CaseClient.
Select @CaseClientId = [CaseClientId] FROM [dbo].[CaseClient] CC With(Nolock)
WHERE
CC.CaseId = @ActiveCaseId
AND
CC.ClientId = @ClientId

IF(@CaseClientId IS NULL OR @CaseClientId = 0)
Return;
------------------

--get Client's Age
Set @Age = DATEDIFF(YY, @DOB, GETDATE())

------------------

SELECT  @WEPMaxHours = dbo.CaseType.WEPMaxHours, @OJTMaxHours = dbo.CaseType.OJTMaxHours, @JSJRMaxHours = dbo.CaseType.JSJRMaxHours,
@FoodStampSubsidy = dbo.[Case].FoodStampSubsidy, @TANSubsidy = dbo.[Case].TANSubsidy,
@ChildCareSubsidy = dbo.[Case].ChildCareSubsidy, @IsTwoParentCase = dbo.[Case].IsTwoParentCase,
@IsChildUnderSix = dbo.[Case].IsChildUnderSix
FROM    dbo.[Case] With(Nolock) INNER JOIN dbo.CaseType With(Nolock) ON dbo.[Case].CaseTypeId = dbo.CaseType.CaseTypeId
WHERE
dbo.[Case].CaseId = @ActiveCaseId

SET @WEPMaxHours = ISNULL(@WEPMaxHours,0)
SET @OJTMaxHours = ISNULL(@OJTMaxHours,0)
SET @JSJRMaxHours = ISNULL(@JSJRMaxHours,0)
SET @FoodStampSubsidy = ISNULL(@FoodStampSubsidy,0)
SET @TANSubsidy = ISNULL(@TANSubsidy,0)
SET @ChildCareSubsidy = ISNULL(@ChildCareSubsidy,0)
SET @IsTwoParentCase = ISNULL(@IsTwoParentCase,0)
SET @IsChildUnderSix = ISNULL(@IsChildUnderSix,0)

/**********************************************************************************************/
Declare @tempStartDate smalldatetime
IF(MONTH(@monthDate) = MONTH(GETDATE()) AND YEAR(@monthDate) = YEAR(GETDATE()))
	SET @tempStartDate = GETDATE()
ELSE
	SET @tempStartDate = @StartDate

--Select SUM(ScheduledHours) FROM dbo.Schedule S
--WHERE

--Set Actual Hours
--IF(@AttendStatus = 1 OR @AttendStatus = 3) --Attended OR Excused
--	Set @ActualHours = @ScheduledHours;
--ELSE
--	Set @ActualHours = 0;

--------------

--CoreActualHours
Select @CoreActualHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.IsCoreActivity = 1
AND
ISNULL(s.IsDeleted,0) = 0

SET @CoreActualHours = ISNULL(@CoreActualHours,0)
--------------

--NonCoreActualHours
Select @NonCoreActualHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.ISCoreActivity = 0
AND
ISNULL(s.IsDeleted,0) = 0

SET @NonCoreActualHours = ISNULL(@NonCoreActualHours,0)
-----------------

--CoreScheduledHours
Select @CoreScheduledHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
S.ISCoreActivity = 1
AND
s.AttendanceStatus = 0 --Scheduled
AND
ISNULL(s.IsDeleted,0) = 0

SET @CoreScheduledHours = ISNULL(@CoreScheduledHours,0)
---------------

--NonCoreScheduledHours
Select @NonCoreScheduledHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
S.ISCoreActivity = 0
AND
s.AttendanceStatus = 0 --Scheduled
AND
ISNULL(s.IsDeleted,0) = 0

SET @NonCoreScheduledHours = ISNULL(@NonCoreScheduledHours,0)
----------------

--@ScheduledRemainingHours
Select @ScheduledRemainingHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @tempStartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
s.AttendanceStatus = 0 --Scheduled
AND
ISNULL(s.IsDeleted,0) = 0

SET @ScheduledRemainingHours = ISNULL(@ScheduledRemainingHours,0)
-----------------

--FLSAActualHours
Select @FLSAActualHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
S.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.FederalActivityId in (4,7) --(Work Experience or Community Service)
AND
ISNULL(s.IsDeleted,0) = 0

SET @FLSAActualHours = ISNULL(@FLSAActualHours,0)
-------------------

--FLSATotalHours
Select @FLSAScheduledHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
S.AttendanceStatus Not in (4) --All scheduled hours expect absent
AND
S.FederalActivityId in (4,7) --(Work Experience or Community Service)
AND
ISNULL(s.IsDeleted,0) = 0

SET @FLSAScheduledHours = ISNULL(@FLSAScheduledHours,0)

-------------------

--RemainingFLSAScheduledHours
Select @RemainingFLSAScheduledHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @tempStartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
s.AttendanceStatus = 0 --Scheduled
AND
S.FederalActivityId in (4,7) --(Work Experience or Community Service)
AND
ISNULL(s.IsDeleted,0) = 0

SET @RemainingFLSAScheduledHours = ISNULL(@RemainingFLSAScheduledHours,0)
--------------------

--Deteremine if the client IsTeenParent or Not
IF((@Age < @TeenAge) OR (@Age = @TeenAge AND DATEPART(MM,@DOB) >= DATEPART(MM,@tempStartDate)) AND  @HSDiploma = 0 AND @GED = 0)
BEGIN
	SET @IsTeenParent = 1
END
ELSE
	SET @IsTeenParent = 0

---------------------

--ClientEDREHoursFY
Select @ClientEDREHoursFY = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @FiscalStartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@FiscalEndDate)))
)
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.FederalActivityId = 10 --(Education Directly Related to Employment)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientEDREHoursFY = ISNULL(@ClientEDREHoursFY,0)

------------------

--ClientRemainingEDREHoursFY
SET @ClientRemainingEDREHoursFY = @RemaingCoreEDREHours + @ClientEDREHoursFY

-------------------

--ClientVocEdMonths
Select @ClientVocEdMonths = COUNT(Distinct right(convert(varchar(10),[Date],105),7)) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
--AND
--(
--(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @FiscalStartDate))) 
--AND 
--(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@FiscalEndDate)))
--)
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.FederalActivityId = 8 --(Vocational Educational Training)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientVocEdMonths = ISNULL(@ClientVocEdMonths,0)

-------------------

--ClientRemainingVocEdMonths
SET @ClientRemainingVocEdMonths = @VocEdMaxMonths - @ClientVocEdMonths;

-------------------

--ClientWEPHours
Select @ClientWEPHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.FederalActivityId = 4 --(Work Experience)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientWEPHours = ISNULL(@ClientWEPHours,0)
-------------------

--ClientRemainingWEPHours
SET @ClientRemainingWEPHours = @WEPMaxHours - @ClientWEPHours

------------------

--ClientOJTActualHours
Select @ClientOJTHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
s.AttendanceStatus in (1,2,3,5) --Attend or excuse
AND
S.FederalActivityId = 5 --(On-the-Job Training)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientOJTHours = ISNULL(@ClientOJTHours,0)

-------------------

--ClientRemainingOJTHours
SET @ClientRemainingOJTHours = @OJTMaxHours - @ClientOJTHours

------------------

--ClientJSJRHoursFY
Select @ClientJSJRHoursFY = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @FiscalStartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@FiscalEndDate)))
)
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.FederalActivityId = 6 --(Job Search and Job Readiness Assistance)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientJSJRHoursFY = ISNULL(@ClientJSJRHoursFY,0)
--------------------

--ClientRemainingOJTHours
SET @ClientRemainingJSJRHoursFY = @JSJRMaxHours - @ClientJSJRHoursFY

------------------

/*New Fields Added*/
-------------------

--FLSAAttendStatusScheduledHrs
Select @FLSAAttendStatusScheduledHrs = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
S.AttendanceStatus = 0 --Scheduled
AND
S.FederalActivityId in (4,7) --(Work Experience or Community Service)
AND
ISNULL(s.IsDeleted,0) = 0

SET @FLSAAttendStatusScheduledHrs = ISNULL(@FLSAAttendStatusScheduledHrs,0)

----------------

--ClientOJTScheduledHours
Select @ClientOJTScheduledHrs = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
s.AttendanceStatus = 0 --Scheduled
AND
S.FederalActivityId = 5 --(On-the-Job Training)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientOJTScheduledHrs = ISNULL(@ClientOJTScheduledHrs,0)

-------------------

--ClientJSJRScheduledHoursFY
Select @ClientJSJRScheduledHrs = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @FiscalStartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@FiscalEndDate)))
)
AND
s.AttendanceStatus = 0 --Scheudled
AND
S.FederalActivityId = 6 --(Job Search and Job Readiness Assistance)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientJSJRScheduledHrs = ISNULL(@ClientJSJRScheduledHrs,0)

------------------------


--ClientVOCEDHours
Select @ClientVOCEDHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
--AND
--(
--(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @FiscalStartDate))) 
--AND 
--(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@FiscalEndDate)))
--)
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse
AND
S.FederalActivityId = 8 --(Vocational Educational Training)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientVOCEDHours = ISNULL(@ClientVOCEDHours,0)

---------------------------

--ClientVOCEDScheduledHrs
Select @ClientVOCEDScheduledHrs = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
--AND
--(
--(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @FiscalStartDate))) 
--AND 
--(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@FiscalEndDate)))
--)
AND
s.AttendanceStatus = 0 --Scheduled
AND
S.FederalActivityId = 8 --(Vocational Educational Training)
AND
ISNULL(s.IsDeleted,0) = 0

SET @ClientVOCEDScheduledHrs = ISNULL(@ClientVOCEDScheduledHrs,0)

-------------

--ClientVocEdMonthsScheduled
Select @ClientVocEdMonthsScheduled = count(Distinct right(convert(varchar(10),[Date],105),7)) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
s.AttendanceStatus = 0  --Scheduled
AND
S.FederalActivityId = 8 --(Vocational Educational Training)
AND
ISNULL(s.IsDeleted,0) = 0
AND right(convert(varchar(10),[Date],105),7)  NOT IN
 (
	    Select Distinct right(convert(varchar(10),[Date],105),7) From dbo.Schedule S With(NOLock)
		Where
		s.CompanyId = @CompanyId
		AND
		s.ClientId = @ClientId
		AND
		s.AttendanceStatus in (1,2,3,5)  --Scheduled
		AND
		S.FederalActivityId = 8 --(Vocational Educational Training)
		AND
		ISNULL(s.IsDeleted,0) = 0
 )

 SET @ClientVocEdMonthsScheduled = ISNULL(@ClientVocEdMonthsScheduled,0)

/*========================================================================================*/

Select @ClientMonthlyCalcId = ClientMonthlyCalcId FROM dbo.ClientMonthlyCalc CM With(Nolock)
WHERE
CM.CaseClientId = @CaseClientId
AND
DATEPART(MM,CM.MonthDate) = DATEPART(MM,@monthDate)
AND
DATEPART(YYYY,CM.MonthDate) = DATEPART(YYYY,@monthDate)

SET @ClientMonthlyCalcId = ISNULL(@ClientMonthlyCalcId,0)

/*========================================================================================*/

--EmploymentScheduledHours
Select @EmploymentScheduledHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
s.AttendanceStatus = 0 --Scheduled
AND
ISNULL(s.IsDeleted,0) = 0
AND
ISNULL(s.IsVisible,0) = 1
AND
S.FederalActivityId in (1,2,3) --Unsub Employ, Sub Priv Employ, Sub Pub Employ

SET @EmploymentScheduledHours = ISNULL(@EmploymentScheduledHours,0)

/*========================================================================================*/

--EmploymentActualHours
Select @EmploymentActualHours = SUM(ScheduledHours) From dbo.Schedule S With(NOLock)
Where
s.CompanyId = @CompanyId
AND
s.ClientId = @ClientId
AND
(
(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
AND 
(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@EndDate)))
)
AND
s.AttendanceStatus in (1,2,3,5) --Attend or Late or excuse or holiday
AND
ISNULL(s.IsDeleted,0) = 0
AND
ISNULL(s.IsVisible,0) = 1
AND
S.FederalActivityId in (1,2,3) --Unsub Employ, Sub Priv Employ, Sub Pub Employ

SET @EmploymentActualHours = ISNULL(@EmploymentActualHours,0)



RETRY:
BEGIN TRANSACTION
BEGIN TRY
	IF(@ClientMonthlyCalcId = 0)
	BEGIN
		INSERT [dbo].[ClientMonthlyCalc] (MonthDate, CaseClientId, ClientCoreActualHours, ClientNonCoreActualHours, ClientCoreScheduledHours, ClientNonCoreScheduledHours, ClientScheduledRemainingHours, ClientFLSAActualHours, ClientFLSAScheduledHours, ClientRemainingFLSAScheduledHours, IsTeenParentWithNoHSGED, ClientVocEdMonths, ClientRemainingVocEdMonths, ClientWEPHours, ClientRemainingWEPHours, ClientOJTHours, ClientRemainingOJTHours, ClientJSJRHoursFY, ClientRemainingJSJRHoursFY, ClientJSJRConsecutiveHoursFY, ClientRemainingJSJRConsecutiveHoursFY, AbsentHoursMonthCount, AbsentHoursYearCount, ClientEDREHoursFY, ClientRemainingEDREHoursFY, FoodStampSubsidy, TANSubsidy, ChildCareSubsidy, IsTwoParentCase, IsChildUnderSix,
		ClientFLSAAttendStatusScheduledHrs, ClientOJTScheduledHrs, ClientJSJRScheduledHoursFY, ClientVOCEDHrs, ClientVOCEDScheduledHrs, ClientVocEdMonthsScheduled, EmploymentScheduledHours, EmploymentActualHours)
		VALUES
		(
			@EndDate, @CaseClientId, @CoreActualHours, @NonCoreActualHours, @CoreScheduledHours, @NonCoreScheduledHours, @ScheduledRemainingHours, @FLSAActualHours, @FLSAScheduledHours, @RemainingFLSAScheduledHours,
			@IsTeenParent, @VocEdMaxMonths, @ClientRemainingVocEdMonths, @ClientWEPHours, @ClientRemainingWEPHours, @ClientOJTHours, @ClientRemainingOJTHours, @ClientJSJRHoursFY, @ClientRemainingJSJRHoursFY,
			@ClientJSJRConsecutiveHoursFY, @ClientRemainingJSJRConsecutiveHoursFY, @AbsentHoursMonthCount, @AbsentHoursYearCount,
			@ClientEDREHoursFY, @ClientRemainingEDREHoursFY, @FoodStampSubsidy, @TANSubsidy, @ChildCareSubsidy, @IsTwoParentCase,@IsChildUnderSix,
			@FLSAAttendStatusScheduledHrs, @ClientOJTScheduledHrs, @ClientJSJRScheduledHrs, @ClientVOCEDHours, @ClientVOCEDScheduledHrs, @ClientVocEdMonthsScheduled,
			@EmploymentScheduledHours, @EmploymentActualHours
		)
	END
	ELSE
	BEGIN
		Update [dbo].[ClientMonthlyCalc] SET
		ClientCoreActualHours = @CoreActualHours, ClientNonCoreActualHours = @NonCoreActualHours, ClientCoreScheduledHours = @CoreScheduledHours, 
		ClientNonCoreScheduledHours = @NonCoreScheduledHours, ClientScheduledRemainingHours = @ScheduledRemainingHours, ClientFLSAActualHours = @FLSAActualHours, ClientFLSAScheduledHours = @FLSAScheduledHours, ClientRemainingFLSAScheduledHours = @RemainingFLSAScheduledHours, IsTeenParentWithNoHSGED = @IsTeenParent, 
		ClientVocEdMonths = @ClientVocEdMonths, ClientRemainingVocEdMonths = @ClientRemainingVocEdMonths, ClientWEPHours = @ClientWEPHours, 
		ClientRemainingWEPHours = @ClientRemainingWEPHours, ClientOJTHours = @ClientOJTHours, ClientRemainingOJTHours = @ClientRemainingOJTHours, 
		ClientJSJRHoursFY = @ClientJSJRHoursFY, ClientRemainingJSJRHoursFY = @ClientRemainingJSJRHoursFY, ClientJSJRConsecutiveHoursFY = @ClientJSJRConsecutiveHoursFY, ClientRemainingJSJRConsecutiveHoursFY = @ClientRemainingJSJRConsecutiveHoursFY, AbsentHoursMonthCount = @AbsentHoursMonthCount, 
		AbsentHoursYearCount = @AbsentHoursYearCount, ClientEDREHoursFY = @ClientEDREHoursFY, ClientRemainingEDREHoursFY = @ClientRemainingEDREHoursFY, 
		--FoodStampSubsidy = @FoodStampSubsidy, TANSubsidy = @TANSubsidy, 
		ChildCareSubsidy = @ChildCareSubsidy, IsTwoParentCase = @IsTwoParentCase, IsChildUnderSix = @IsChildUnderSix,
		ClientFLSAAttendStatusScheduledHrs = @FLSAAttendStatusScheduledHrs, ClientOJTScheduledHrs = @ClientOJTScheduledHrs, ClientJSJRScheduledHoursFY = @ClientJSJRScheduledHrs, 
		ClientVOCEDHrs = @ClientVOCEDHours, ClientVOCEDScheduledHrs = @ClientVOCEDScheduledHrs, ClientVocEdMonthsScheduled = @ClientVocEdMonthsScheduled,
		EmploymentScheduledHours = @EmploymentScheduledHours, EmploymentActualHours = @EmploymentActualHours
		Where ClientMonthlyCalcId = @ClientMonthlyCalcId
	END
SET @RetryCount = 0
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
	BEGIN
		IF (@RetryCount < @MaxRetry)
		BEGIN
			SET @RetryCount = @RetryCount + 1
			WAITFOR DELAY '00:00:00.10' -- Wait for 5 ms
			GOTO RETRY
		END
		ELSE
		BEGIN
			SET @RetryCount = 0
			Return
		END
	END
END CATCH


IF(@CaseClientId IS NOT NULL)
BEGIN

RETRYUpdate:
BEGIN TRANSACTION
BEGIN TRY
	Update [dbo].[ClientMonthlyCalc]
	SET
	ClientVocEdMonths = @ClientVocEdMonths, ClientRemainingVocEdMonths = @ClientRemainingVocEdMonths, ClientVocEdMonthsScheduled = @ClientVocEdMonthsScheduled
	WHERE
	CaseClientId = @CaseClientId
SET @RetryCount = 0
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
	BEGIN
		IF (@RetryCount < @MaxRetry)
		BEGIN
			SET @RetryCount = @RetryCount + 1
			WAITFOR DELAY '00:00:00.10' -- Wait for 5 ms
			GOTO RETRYUpdate
		END
		ELSE
		BEGIN
			SET @RetryCount = 0
			Return
		END
	END
END CATCH
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 Attended; 2 Late; 3 Excused; 4 Absent; 5 Holiday;', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Schedule', @level2type = N'COLUMN', @level2name = N'AttendanceStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 Manally, 2 CardSignin, 3 IVR, 4 System', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Schedule', @level2type = N'COLUMN', @level2name = N'AttendanceType';

