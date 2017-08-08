CREATE TABLE [dbo].[PlacementEntry] (
    [PlacementEntryID]      INT             IDENTITY (1, 1) NOT NULL,
    [HRACaseID]             INT             NULL,
    [IsFIA3AEntered]        BIT             NULL,
    [Reason]                VARCHAR (300)   NULL,
    [SectorId]              INT             NULL,
    [Title]                 VARCHAR (100)   NULL,
    [Department]            VARCHAR (100)   NULL,
    [Salary]                DECIMAL (18, 2) NULL,
    [SalaryRate]            TINYINT         NULL,
    [SalaryPerHour]         DECIMAL (18, 2) NULL,
    [HoursPerWeek]          INT             NULL,
    [EmployerId]            INT             NULL,
    [EmpLocationId]         INT             NULL,
    [Email]                 NVARCHAR (80)   NULL,
    [HomePhone]             VARCHAR (50)    NULL,
    [CellPhone]             VARCHAR (50)    NULL,
    [Address]               VARCHAR (100)   NULL,
    [City]                  VARCHAR (50)    NULL,
    [State]                 VARCHAR (50)    NULL,
    [ZipCode]               INT             NULL,
    [SiteId]                INT             NULL,
    [HasBenefits]           BIT             NULL,
    [PaidSickLeave]         BIT             NULL,
    [PaidSickLeaveUnderNYC] BIT             NULL,
    [Vacation]              BIT             NULL,
    [Medical]               BIT             NULL,
    [Dental]                BIT             NULL,
    [401K]                  BIT             NULL,
    [PlacementSourceId]     INT             NULL,
    [MatchedByUserId]       VARCHAR (40)    NULL,
    [PlacementLeadUserId]   VARCHAR (40)    NULL,
    [PlacementTypeId]       INT             NULL,
    [CompanyId]             INT             NULL,
    [JobStart]              SMALLDATETIME   NULL,
    [EndDate]               SMALLDATETIME   NULL,
    [JobEndReasonId]        INT             NULL,
    [IsDeleted]             BIT             CONSTRAINT [DF_PlacementEntry_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]             VARCHAR (80)    NULL,
    [CreatedAt]             DATETIME        NULL,
    [UpdatedBy]             VARCHAR (80)    NULL,
    [UpdatedAt]             DATETIME        NULL,
    [TitleId]               INT             NULL,
    [BillingTypeId]         INT             NULL,
    [NotBillableReasonId]   INT             NULL,
    [FIAEntryDate]          SMALLDATETIME   NULL,
    [SecondJobStartDate]    SMALLDATETIME   NULL,
    [RetentionSpecialistId] INT             NULL,
    [CustomerStatusId]      INT             NULL,
    [EW]                    BIT             NULL,
    [LINC]                  BIT             NULL,
    [30Street]              BIT             NULL,
    [Riker]                 BIT             NULL,
    [EmploymentTypeId]      INT             NULL,
    [AssistedById]          VARCHAR (40)    NULL,
    CONSTRAINT [PK_PlacementEntry] PRIMARY KEY CLUSTERED ([PlacementEntryID] ASC),
    CONSTRAINT [FK_PlacementEntry_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_PlacementEntry_Employer] FOREIGN KEY ([EmployerId]) REFERENCES [dbo].[Employer] ([EmployerId]),
    CONSTRAINT [FK_PlacementEntry_Site] FOREIGN KEY ([SiteId]) REFERENCES [dbo].[Site] ([SiteId])
);


GO

CREATE TRIGGER [dbo].[placementLog] ON [dbo].[PlacementEntry] 
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
Set @TableName = N'PlacementEntry'

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
CREATE TRIGGER [dbo].[RetentionHistory] ON [dbo].[PlacementEntry] 
after UPDATE , INSERT, Delete
AS
--BEGIN TRAN

Declare @placementId int, @newRetentioSpecialId int, @oldRetentioSpecialId int

Select @placementId = PlacementEntryId,  @newRetentioSpecialId = RetentionSpecialistId From inserted;
Select  @oldRetentioSpecialId = RetentionSpecialistId From deleted;

IF(@oldRetentioSpecialId = @newRetentioSpecialId)
return;

Declare @ID int
Select @ID = ID from [dbo].[PlacementSpecialistHistory] as History
WHERE
history.PlacementEntryId = @placementId
AND
history.RetentionSpecialistId = @oldRetentioSpecialId
AND
history.ToDate IS NULL

IF(@ID IS NULL)
BEGIN
	INSERT INTO [dbo].[PlacementSpecialistHistory] (PlacementEntryId, RetentionSpecialistId, FromDate, ToDate)
	Values(@placementId, @newRetentioSpecialId, getDate(), null)
END
ELSE
BEGIN
	Update [dbo].[PlacementSpecialistHistory] SET ToDate = GETDATE()
	WHERE ID = @ID

	INSERT INTO [dbo].[PlacementSpecialistHistory] (PlacementEntryId, RetentionSpecialistId, FromDate, ToDate)
	Values(@placementId, @newRetentioSpecialId, getDate(), null)

END
--COMMIT TRAN
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from Enum table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'SectorId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 Hour ; 1 Bi-Weekly ; 2 Annual; 3 Weekly', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'SalaryRate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from Enums table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'PlacementSourceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from LoginTable in ALL Sector DB', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'MatchedByUserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from LoginTable in ALL Sector DB', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'PlacementLeadUserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from Enums table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'PlacementTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'equal true mean is deleted record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'IsDeleted';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from Enum Id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'TitleId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from Enum Id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'BillingTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from Enum Id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'NotBillableReasonId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'B2W - From Enum', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'CustomerStatusId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'B2W', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'EW';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'B2W', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'LINC';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'B2W', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'30Street';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'B2W', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'Riker';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'B2W - Enum', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'EmploymentTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'B2W  Login Table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntry', @level2type = N'COLUMN', @level2name = N'AssistedById';

