CREATE TABLE [dbo].[Client] (
    [ClientId]                            INT           IDENTITY (1, 1) NOT NULL,
    [IsActive]                            BIT           NULL,
    [ActiveCaseId]                        INT           NULL,
    [CompanyId]                           INT           NULL,
    [ClientNo]                            VARCHAR (20)  NULL,
    [Suffix]                              VARCHAR (2)   NULL,
    [LineNumber]                          VARCHAR (2)   NULL,
    [CIN]                                 VARCHAR (9)   NULL,
    [CaseLastName]                        VARCHAR (50)  NULL,
    [CaseFirstName]                       VARCHAR (50)  NULL,
    [CaseMiddleName]                      VARCHAR (50)  NULL,
    [PhoneNumber]                         VARCHAR (20)  NULL,
    [CellPhone]                           VARCHAR (20)  NULL,
    [Email]                               VARCHAR (50)  NULL,
    [LeaseSigningDate]                    SMALLDATETIME NULL,
    [LeaseStartDate]                      SMALLDATETIME NULL,
    [HHSize]                              INT           NULL,
    [LINCID]                              VARCHAR (20)  NULL,
    [StreetAddress]                       VARCHAR (50)  NULL,
    [ApartmentNumber]                     VARCHAR (50)  NULL,
    [ResidenceBorough]                    VARCHAR (25)  NULL,
    [City]                                VARCHAR (25)  NULL,
    [State]                               VARCHAR (25)  NULL,
    [ZipCode]                             VARCHAR (20)  NULL,
    [DOB]                                 DATETIME      NULL,
    [SSN]                                 VARCHAR (9)   NULL,
    [LandLordId]                          INT           NULL,
    [EffectiveDate]                       DATETIME      NULL,
    [HRAServiceBorough]                   INT           NULL,
    [ReferringOfficeNumber]               INT           NULL,
    [ReferralDate]                        DATETIME      NULL,
    [HSDiploma]                           BIT           NULL,
    [GED]                                 BIT           NULL,
    [IsDeleted]                           BIT           CONSTRAINT [DF_Client_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]                           VARCHAR (50)  NULL,
    [CreatedAt]                           DATETIME      NULL,
    [UpdatedBy]                           VARCHAR (50)  NULL,
    [UpdatedAt]                           DATETIME      NULL,
    [WorkTelephoneNumber]                 VARCHAR (20)  NULL,
    [MailingAddressStreet]                VARCHAR (50)  NULL,
    [MailingAddressCity]                  VARCHAR (25)  NULL,
    [MailingAddressState]                 VARCHAR (25)  NULL,
    [MailingAddressZipCode]               VARCHAR (20)  NULL,
    [AlienNumber]                         VARCHAR (10)  NULL,
    [MarriedIndicator]                    VARCHAR (1)   NULL,
    [PrimaryLanguageId]                   INT           NULL,
    [GenderId]                            INT           NULL,
    [SiteId]                              INT           NULL,
    [AssignedStaffMemberId]               INT           NULL,
    [SanctionHistoryCount]                INT           NULL,
    [TANF_MONTHS_COUNTER]                 INT           NULL,
    [MonthsCaringForChildUnder1Exemption] INT           NULL,
    [MailingAddressStreet2]               VARCHAR (50)  NULL,
    [HighestEducation]                    VARCHAR (2)   NULL,
    [IPVHistoryCount]                     INT           NULL,
    [FoodStamp_Exculsion]                 INT           NULL,
    [FoodStampBenefitMonth]               DATETIME      NULL,
    [TANFBenefitMonth]                    DATETIME      NULL,
    [TANFExtensionStatusIndicator]        VARCHAR (1)   NULL,
    [IsPrivilegeRequired]                 BIT           CONSTRAINT [DF_Client_IsPrivilegeRequired] DEFAULT ((0)) NULL,
    [SanctionEffectiveDate]               DATETIME      NULL,
    [ExemptionEffectiveDate]              DATETIME      NULL,
    CONSTRAINT [PK_Case] PRIMARY KEY CLUSTERED ([ClientId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Client_Enumes] FOREIGN KEY ([PrimaryLanguageId]) REFERENCES [dbo].[Enumes] ([EnumId]),
    CONSTRAINT [FK_Client_LINC_LandLord] FOREIGN KEY ([LandLordId]) REFERENCES [dbo].[LINC_LandLord] ([LandLordId])
);


GO
CREATE NONCLUSTERED INDEX [idx_ClientNo]
    ON [dbo].[Client]([ClientNo] DESC);


GO
CREATE NONCLUSTERED INDEX [idx_ActiveCaseId]
    ON [dbo].[Client]([ActiveCaseId] DESC);


GO


-- Trigger to Update SiteId in [Client] and [Case] tables
CREATE TRIGGER [dbo].[UpdateSiteId] ON [dbo].[Client]
AFTER UPDATE
AS
IF ((SELECT TRIGGER_NESTLEVEL()) > 1) RETURN
IF UPDATE(SiteId)
    BEGIN
        DECLARE @ActiveCaseId INT, @SiteId INT
        SELECT @ActiveCaseId = [ActiveCaseId] FROM inserted
        SELECT @SiteId = [SiteId] FROM inserted
        BEGIN TRAN
		  UPDATE [dbo].[Client] SET SiteId = @SiteId WHERE ActiveCaseId = @ActiveCaseId
		  UPDATE [dbo].[Case] SET SiteId = @SiteId WHERE CaseId = @ActiveCaseId
		  IF @@ERROR > 0
			 ROLLBACK TRAN
        COMMIT TRAN
    END

GO




CREATE TRIGGER [dbo].[ClientLog] ON [dbo].[Client] 
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
Set @TableName = N'Client'

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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'S-Single;M-Married;P-Separated;W-Widowed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client', @level2type = N'COLUMN', @level2name = N'MarriedIndicator';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Come from the user table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client', @level2type = N'COLUMN', @level2name = N'AssignedStaffMemberId';

