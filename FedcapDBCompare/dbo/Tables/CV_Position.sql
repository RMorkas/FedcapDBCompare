CREATE TABLE [dbo].[CV_Position] (
    [PositionId]      INT           IDENTITY (1, 1) NOT NULL,
    [ResumeId]        INT           NULL,
    [Title]           VARCHAR (80)  NULL,
    [SectorId]        INT           NULL,
    [StartDate]       SMALLDATETIME NULL,
    [EndDate]         SMALLDATETIME NULL,
    [ExperienceYears] NUMERIC (18)  NULL,
    [Company]         VARCHAR (80)  NULL,
    [City]            VARCHAR (50)  NULL,
    [State]           VARCHAR (25)  NULL,
    [Country]         VARCHAR (80)  NULL,
    [Summary]         VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED ([PositionId] ASC),
    CONSTRAINT [FK_CV_Position_CV_Resume] FOREIGN KEY ([ResumeId]) REFERENCES [dbo].[CV_BaseResume] ([ResumeId]),
    CONSTRAINT [FK_CV_Position_Sector] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[Sector] ([SectorId])
);


GO
CREATE TRIGGER [dbo].[positionLog] ON [dbo].[CV_Position] 
FOR UPDATE , INSERT
AS

/*
******	Standard Script to Create Trigger on Child table  ******
*/

Declare @TableName nvarchar(80) ,@PartentTable nvarchar(80), @count int , @index int, @columnName nvarchar(100) , @oldValue nvarchar(max) ,@newValue nvarchar(max) , 
@SQLString nvarchar(Max) , @outPut nvarchar(max), @TableId int , @PKFieldName nvarchar(80),
@PKFieldValue int , @SavedBy varchar(80) , @SavedAt DateTime , @UpdatedBy varchar(80) , @TranSavedId int , @IsUpdatedTrigger int,
@lastSequence int, @ChildPKValue int ,@ChildPKName varchar(80) , @IsInsertedTran bit

SET @PartentTable = 'CV_BaseResume'
Set @TableName = N'CV_Position'
SET @ChildPKName = 'PositionId'

IF OBJECT_ID('tempdb.dbo.#Inserted', 'U') IS NOT NULL
  DROP TABLE #Inserted; 

IF OBJECT_ID('tempdb.dbo.#Deleted', 'U') IS NOT NULL
  DROP TABLE #Deleted; 

SELECT * INTO #Inserted  FROM inserted
SELECT * INTO #Deleted  FROM deleted

--To get the value of Child Primary Key
SET @outPut = null;
SET @SQLString = ' select @outPut = [' + @ChildPKName + '] from #Inserted '
exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
Set @ChildPKValue =  CAST(@outPut AS int)

Select @IsUpdatedTrigger = Count(*) From #Deleted


--To get count of columns.
SELECT @count = Count(Column_Name)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName

--To get tableId and Primary Key Field name
SELECT @TableId = TableId , @PKFieldName = PKFieldName FROM Fed_LogTables Where TableName = @PartentTable

--To get primary key value
SET @outPut = NULL;
SET @SQLString = ' select @outPut = [' + @PKFieldName + '] from #Inserted '
exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
Set @PKFieldValue =  CAST(@outPut AS int)

If(@IsUpdatedTrigger = 0)
	BEGIN
		SET @outPut = null;
		SET @SQLString = ' select @outPut =  UpdatedAt  from  ' + @PartentTable + ' Where  ' + @PKFieldName + '  =  ' + CAST(@PKFieldValue AS nvarchar(80))
		exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
		IF(@outPut IS NOT NULL)
			BEGIN
				Return;
			END
	END

--To get the GroupID
SELECT @TranSavedId = Max(TranSavedId) FROM [dbo].[Fed_LogTransaction] WHERE [TableId] = @TableId AND [PKFieldValue] = @PKFieldValue

SELECT @SavedBy = [SavedBy] , @SavedAt = [SavedAt] FROM [dbo].[Fed_LogTransaction] WHERE [TranSavedId] = @TranSavedId

Set @index = 1;
While (@index <= @count)
	begin
		SET @outPut = null;
		Set @oldValue = null;
		Set @newValue = null;
		SELECT @columnName = COLUMN_NAME 
							FROM INFORMATION_SCHEMA.COLUMNS 
							WHERE TABLE_NAME = @TableName 
							AND ORDINAL_POSITION = @index
							ORDER BY ORDINAL_POSITION ASC

		IF (@IsUpdatedTrigger = 1) --Execute this part only for update transaction
			BEGIN
				SET @SQLString = ' select @outPut = [' + @columnName + '] from #Deleted '
				exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
				Set @oldValue =  @outPut
			END

		SET @SQLString = 'select @outPut = [' + @columnName + '] from #Inserted '
		exec sp_executesql @SQLString, N'@outPut nvarchar(max) out', @outPut = @outPut out
		Set @newValue = @outPut

		exec InsertLogData @TranSavedId ,@TableName ,@ChildPKValue,  @columnName , @oldValue , @newValue , @SavedBy

		SET @index = @index + 1;
	END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from Enum Table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CV_Position', @level2type = N'COLUMN', @level2name = N'SectorId';

