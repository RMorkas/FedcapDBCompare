CREATE TABLE [dbo].[ClientContact] (
    [ClientContactId]         INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT           NULL,
    [ClientId]                INT           NULL,
    [IsContact]               BIT           NULL,
    [Title]                   VARCHAR (200) NULL,
    [ContactTypeId]           INT           NULL,
    [ContactMethodId]         INT           NULL,
    [ContactDate]             SMALLDATETIME NULL,
    [ContactTime]             DATETIME      NULL,
    [IsContactMade]           BIT           NULL,
    [ContactNote]             VARCHAR (MAX) NULL,
    [GoodCauseReasonId]       INT           NULL,
    [IsGoodCauseClaimed]      BIT           NULL,
    [IsGoodCauseApproved]     BIT           NULL,
    [GoodCauseDenialNote]     VARCHAR (MAX) NULL,
    [IsClientAcceptedSendMsg] BIT           NULL,
    [MessageId]               INT           NULL,
    [NonComplianceLetterId]   INT           NULL,
    [FormVersionId]           INT           NULL,
    [IsDeleted]               BIT           NULL,
    [CreatedBy]               VARCHAR (80)  NULL,
    [CreatedAt]               DATETIME      NULL,
    [UpdatedBy]               VARCHAR (80)  NULL,
    [UpdatedAt]               DATETIME      NULL,
    [logtableid]              INT           NULL,
    [GoodCauseClaimsNote]     VARCHAR (MAX) NULL,
    [IsLocked]                BIT           CONSTRAINT [DF_ClientContact_IsLocked] DEFAULT ((0)) NULL,
    [requeststatus]           INT           NULL,
    CONSTRAINT [PK_ClientContact] PRIMARY KEY CLUSTERED ([ClientContactId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_ClientId]
    ON [dbo].[ClientContact]([ClientId] DESC);


GO
Create TRIGGER [dbo].[ContactAudit] ON dbo.ClientContact 
after UPDATE , INSERT, Delete
AS
Declare @TableName varchar(50), @formId int, @updatedBy varchar(80), @isDeleted bit
Set @TableName = 'ClientContact'

Select @formId = FormId from dbo.formInfo Where FormName = @TableName

Select @updatedBy = UpdatedBy, @isDeleted = IsDeleted  From inserted

If(@updatedBy IS NULL)
BEGIN
	Insert into [dbo].[FormAudit] (FormId, FormRecordId, SavedDate, SavedBy, TransType)
	Select @formId, ClientContactId, [CreatedAt] , [CreatedBy], 'Insert' From inserted
END
ELSE IF(@isDeleted = 0 or @isDeleted IS NULL)
BEGIN
	Insert into [dbo].[FormAudit] (FormId, FormRecordId, SavedDate, SavedBy, TransType)
	Select @formId, ClientContactId, [UpdatedAt] , [UpdatedBy] , 'Update' From inserted
END
ELSE IF(@isDeleted = 1)
BEGIN
	Insert into [dbo].[FormAudit] (FormId, FormRecordId, SavedDate, SavedBy, TransType)
	Select @formId, ClientContactId, [UpdatedAt] , [UpdatedBy] , 'Delete' From inserted
END

GO

Create TRIGGER [dbo].[ClientContactLog] ON [dbo].[ClientContact] 
FOR UPDATE , INSERT
AS

/*
******	Standard Script to Create LOG Trigger on Parent table  ******
*/

Declare @TableName nvarchar(80) , @count int , @index int, @columnName nvarchar(100) , @oldValue nvarchar(max) ,@newValue nvarchar(max) , 
@SQLString nvarchar(Max) , @outPut nvarchar(max), @TableId int , @PKFieldName nvarchar(80),
@PKFieldValue int , @SavedBy varchar(80) , @SavedAt DateTime , @UpdatedBy varchar(80) , @TranSavedId int , @IsUpdatedTrigger int,
@lastSequence int, @ChildRowsCount int , @ChildTableName varchar(80) , @ChildPKName varchar(80), @MaxRetry int, @RetryCount int

Set @TableName = N'ClientContact'

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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'True Contact; Fasle  Note', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ClientContact', @level2type = N'COLUMN', @level2name = N'IsContact';

