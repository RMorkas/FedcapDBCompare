CREATE TABLE [dbo].[CV_JobOrder] (
    [JobOrderId]                 INT             IDENTITY (1, 1) NOT NULL,
    [CompanyId]                  INT             NULL,
    [EmployerLocationId]         INT             NULL,
    [IsActive]                   BIT             NULL,
    [JobOrderTrNo]               INT             NULL,
    [JobTitle]                   VARCHAR (50)    NULL,
    [SectorId]                   INT             NULL,
    [JobVisibilityId]            INT             NULL,
    [VisibilitySiteId]           INT             NULL,
    [EmploymentTypeId]           INT             NULL,
    [Duration]                   NUMERIC (18, 1) NULL,
    [FromWages]                  NUMERIC (18, 2) NULL,
    [ToWages]                    NUMERIC (18, 2) NULL,
    [JobOpeningDate]             SMALLDATETIME   NULL,
    [JobClosingDate]             SMALLDATETIME   NULL,
    [EducationId]                INT             NULL,
    [MinExperience]              NUMERIC (18, 1) NULL,
    [ComputerLevelId]            INT             NULL,
    [PermittedBackgroundId]      INT             NULL,
    [JobLeadUserId]              INT             NULL,
    [MinTabeReading]             NUMERIC (18, 1) NULL,
    [MinTabeMath]                NUMERIC (18, 1) NULL,
    [HasPersonalDriverLicense]   BIT             NULL,
    [HasCommercialDriverLicense] BIT             NULL,
    [RequiredDrugTest]           BIT             NULL,
    [LiftMax]                    NUMERIC (18, 2) NULL,
    [CanStandLongPeriod]         BIT             NULL,
    [CanSitLongPeriod]           BIT             NULL,
    [SummaryDesc]                VARCHAR (MAX)   NULL,
    [Courses]                    VARCHAR (MAX)   NULL,
    [Skills]                     VARCHAR (MAX)   NULL,
    [Certifications]             VARCHAR (MAX)   NULL,
    [Languages]                  VARCHAR (60)    NULL,
    [OpenVacancies]              INT             NULL,
    [IsDeleted]                  BIT             CONSTRAINT [DF_CV_JobOrder_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]                  VARCHAR (80)    NULL,
    [CreatedAt]                  DATETIME        NULL,
    [UpdatedBy]                  VARCHAR (80)    NULL,
    [UpdatedAt]                  DATETIME        NULL,
    CONSTRAINT [PK_CV_JobOrder] PRIMARY KEY CLUSTERED ([JobOrderId] ASC),
    CONSTRAINT [FK_CV_JobOrder_EmployerLocation] FOREIGN KEY ([EmployerLocationId]) REFERENCES [dbo].[EmployerLocation] ([EmpLocationId]),
    CONSTRAINT [FK_CV_JobOrder_Sector] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[Sector] ([SectorId])
);


GO
CREATE TRIGGER [dbo].[sendEmailForNewJobOrder] ON [dbo].[CV_JobOrder] 
After INSERT
AS
Declare @companyId int, @jobVisibilityId int, @VisibilitySiteId int, @xml nvarchar(max), @body nvarchar(max), @LeadName nvarchar(max), @leadId int, @Email nvarchar(max)

Select @companyId = CompanyId, @jobVisibilityId = JobVisibilityId, @VisibilitySiteId = VisibilitySiteId, @leadId = JobLeadUserId from inserted
IF(@jobVisibilityId = 305)
	return
ELSE
BEGIN
	IF(@jobVisibilityId = 306) --Site Wide
	BEGIN
			select @Email = Email from dbo.[Site] where SiteId = @VisibilitySiteId
	END
	ELSE IF(@jobVisibilityId = 307) --Project Wide
	BEGIN
			select @Email = Email from dbo.[Company] where CompanyId = @companyId
	END

IF(@Email IS NOT NULL)
BEGIN
	SET @xml = CAST(( SELECT job.JobOrderTrNo AS 'td','', emp.FirstName AS 'td','',job.JobTitle AS 'td','',
				   CONVERT(varchar(max),job.JobOpeningDate,101) AS 'td','',CONVERT(varchar(max),job.JobClosingDate,101) AS 'td',''
				   FROM  inserted job inner join EmployerLocation loc on job.EmployerLocationId = loc.EmpLocationId
				   inner join Employer emp on loc.EmployerId = emp.EmployerId
				   ORDER BY JobOrderTrNo 
				   FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

	Select @LeadName = (FirstName + ' ' + LastName)  From dbo.[User] WHERE UserID = @leadId
	    
	SET @body ='<html><body><H4>New Job order created today lead by ' + @LeadName + ' </H4>
	    			<table border = 1> 
					<tr>
					<th> JobOrder N# </th> <th> Employer </th> <th> Job Title </th> <th> Opened Date </th> <th> Closed Date </th></tr>' 

					SET @body = @body + @xml +'</table><br/> 
					Kind regards<br/>
					FedCap System 
					<br/>
					<br/>
					</body></html>'

					exec msdb.dbo.sp_send_dbmail @profile_name='MyTestMail',
					@recipients=@Email,
					@subject='New Job order created today',
					@body=@body,
					@body_format = 'HTML'
END
END
GO
DISABLE TRIGGER [dbo].[sendEmailForNewJobOrder]
    ON [dbo].[CV_JobOrder];


GO
CREATE TRIGGER [dbo].[joborderLog] ON [dbo].[CV_JobOrder] 
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
Set @TableName = N'CV_JobOrder'

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