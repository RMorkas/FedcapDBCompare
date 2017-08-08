CREATE TABLE [dbo].[ClientFca] (
    [ClientFcaId]          INT            IDENTITY (1, 1) NOT NULL,
    [ClientId]             INT            NOT NULL,
    [ShortTermGoal]        VARCHAR (3000) NULL,
    [LongTermGoal]         VARCHAR (3000) NULL,
    [IsDisagreed]          BIT            NOT NULL,
    [ParticipantSignature] VARCHAR (MAX)  NULL,
    [FcaDate]              DATETIME       NULL,
    [ScanImageId]          INT            NULL,
    [ReasonTypeId]         INT            NULL,
    [ActivityDays]         INT            NULL,
    [ActivityHours]        INT            NULL,
    [ActivityStartDate]    DATETIME       NULL,
    [ActivityEndDate]      DATETIME       NULL,
    [FormVersionId]        INT            NULL,
    [CreatedAt]            DATETIME       NULL,
    [CreatedBy]            VARCHAR (80)   NULL,
    [UpdatedAt]            DATETIME       NULL,
    [UpdatedBy]            VARCHAR (80)   NULL,
    [IsLocked]             BIT            CONSTRAINT [DF_ClientFca_IsLocked] DEFAULT ((0)) NOT NULL,
    [IsDeleted]            BIT            CONSTRAINT [DF_ClientFca_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ClientFca] PRIMARY KEY CLUSTERED ([ClientFcaId] ASC),
    CONSTRAINT [FK_ClientFca_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_ClientFca_FormVersion] FOREIGN KEY ([FormVersionId]) REFERENCES [dbo].[FormVersion] ([FormVersionId])
);


GO
CREATE TRIGGER [dbo].[ClientFcaLog] ON [dbo].[ClientFca] 
FOR UPDATE , INSERT
AS

/*
******	Standard Script to Create LOG Trigger on Parent table  ******
*/

Declare @TableName nvarchar(80) , @count int , @index int, @columnName nvarchar(100) , @oldValue nvarchar(max) ,@newValue nvarchar(max) , 
@SQLString nvarchar(Max) , @outPut nvarchar(max), @TableId int , @PKFieldName nvarchar(80),
@PKFieldValue int , @SavedBy varchar(80) , @SavedAt DateTime , @UpdatedBy varchar(80) , @TranSavedId int , @IsUpdatedTrigger int,
@lastSequence int, @ChildRowsCount int , @ChildTableName varchar(80) , @ChildPKName varchar(80), @MaxRetry int, @RetryCount int

Set @TableName = N'ClientFca'

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

--/*
--****************************
--Set Child Table Name and Child PK if exist else comment Procedure.
--****************************
--*/
Set @ChildTableName = 'ClientFcaActivity'
SET @ChildPKName = 'ClientFcaActivityId'

Exec UpdateChildTables @ChildTableName , @ChildPKName , @PKFieldName , @PKFieldValue

Set @ChildTableName = 'ClientFcaSupportService'
SET @ChildPKName = 'ClientFcaSupportServiceId'

Exec UpdateChildTables @ChildTableName , @ChildPKName , @PKFieldName , @PKFieldValue