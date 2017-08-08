CREATE TABLE [dbo].[ClientIntake] (
    [ClientIntakeId]                   INT             IDENTITY (1, 1) NOT NULL,
    [CompanyId]                        INT             NOT NULL,
    [ClientId]                         INT             NOT NULL,
    [GenderId]                         INT             NULL,
    [HouseholdSize]                    INT             NULL,
    [HasPriorASPIREHistory]            BIT             CONSTRAINT [DF_ClientIntake_HasPriorASPIREHistory] DEFAULT ((0)) NULL,
    [HasMedicalIssue]                  BIT             CONSTRAINT [DF_ClientIntake_HasMedicalIssue] DEFAULT ((0)) NULL,
    [HasMedDoc]                        BIT             CONSTRAINT [DF_ClientIntake_HasMedDoc] DEFAULT ((0)) NULL,
    [HomePhone]                        VARCHAR (80)    NULL,
    [UseVoicemailHomePhone]            BIT             CONSTRAINT [DF_ClientIntake_UseVoicemailHomePhone] DEFAULT ((0)) NULL,
    [MobilePhone]                      VARCHAR (80)    NULL,
    [UseVoicemailMobilePhone]          BIT             CONSTRAINT [DF_ClientIntake_UseVoicemailMobilePhone] DEFAULT ((0)) NULL,
    [OtherPhone]                       VARCHAR (80)    NULL,
    [UseVoicemailOtherPhone]           BIT             CONSTRAINT [DF_ClientIntake_UseVoicemailOtherPhone] DEFAULT ((0)) NULL,
    [Email]                            VARCHAR (80)    NULL,
    [UseEmail]                         BIT             CONSTRAINT [DF_ClientIntake_UseEmail] DEFAULT ((0)) NULL,
    [ContactPreferenceId]              INT             NULL,
    [IsCurrentlyAtPermanentResidence]  BIT             CONSTRAINT [DF_ClientIntake_IsCurrentlyAtPermanentResidence] DEFAULT ((0)) NULL,
    [ResidentialAddressStreet]         VARCHAR (300)   NULL,
    [ResidentialAddressCity]           VARCHAR (80)    NULL,
    [ResidentialAddressState]          VARCHAR (80)    NULL,
    [ResidentialAddressZip]            VARCHAR (80)    NULL,
    [IsMailingSameResidential]         BIT             CONSTRAINT [DF_ClientIntake_IsMailingSameResidential] DEFAULT ((0)) NULL,
    [MailingAddressStreet]             VARCHAR (300)   NULL,
    [MailingAddressCity]               VARCHAR (80)    NULL,
    [MailingAddressState]              VARCHAR (80)    NULL,
    [MailingAddressZip]                VARCHAR (80)    NULL,
    [HousingCosts]                     NUMERIC (18, 2) NULL,
    [HousingBenefits]                  NUMERIC (18, 2) NULL,
    [HousingCostTypeId]                INT             NULL,
    [HousingTypeId]                    INT             NULL,
    [EmergencyName]                    VARCHAR (80)    NULL,
    [EmergencyHomePhone]               VARCHAR (80)    NULL,
    [EmergencyMobilePhone]             VARCHAR (80)    NULL,
    [EmergencyEmail]                   VARCHAR (80)    NULL,
    [EmergencyRelationshipToClienId]   INT             NULL,
    [IsCurrentHousingStable]           BIT             CONSTRAINT [DF_ClientIntake_IsCurrentHousingStable] DEFAULT ((0)) NULL,
    [HasBeenHomeless]                  BIT             CONSTRAINT [DF_ClientIntake_HasBeenHomeless] DEFAULT ((0)) NULL,
    [IsAtRiskForHomelessness]          BIT             CONSTRAINT [DF_ClientIntake_IsAtRiskForHomelessness] DEFAULT ((0)) NULL,
    [HomelessnessComments]             VARCHAR (2000)  NULL,
    [IsInterviewInEnglish]             BIT             CONSTRAINT [DF_ClientIntake_IsInterviewInEnglish] DEFAULT ((0)) NULL,
    [IsTranslatorRequired]             BIT             CONSTRAINT [DF_ClientIntake_IsTranslatorRequired] DEFAULT ((0)) NULL,
    [PrimaryLanguageId]                INT             NULL,
    [DoesSpeakEnglish]                 BIT             CONSTRAINT [DF_ClientIntake_DoesSpeakEnglish] DEFAULT ((0)) NULL,
    [DoesReadEnglish]                  BIT             CONSTRAINT [DF_ClientIntake_DoesReadEnglish] DEFAULT ((0)) NULL,
    [DoesWriteEnglish]                 BIT             CONSTRAINT [DF_ClientIntake_DoesWriteEnglish] DEFAULT ((0)) NULL,
    [LanguageAccommodationComments]    VARCHAR (2000)  NULL,
    [TravelToAppointmentTodayId]       INT             NULL,
    [TravelToAppointmentFutureId]      INT             NULL,
    [TravelIndepepndentlyId]           INT             NULL,
    [IsPhysicallyImpaired]             BIT             CONSTRAINT [DF_ClientIntake_IsPhysicallyImpaired] DEFAULT ((0)) NULL,
    [IsUnableToDrive]                  BIT             CONSTRAINT [DF_ClientIntake_IsUnableToDrive] DEFAULT ((0)) NULL,
    [IsNotWithinTravelDistance]        BIT             CONSTRAINT [DF_ClientIntake_IsNotWithinTravelDistance] DEFAULT ((0)) NULL,
    [NoAccessToReliableTransportation] BIT             CONSTRAINT [DF_ClientIntake_NoAccessToReliableTransportation] DEFAULT ((0)) NULL,
    [TravelAccommodationComments]      VARCHAR (2000)  NULL,
    [IsCurrentlyWorking]               BIT             CONSTRAINT [DF_ClientIntake_IsCurrentlyWorking] DEFAULT ((0)) NULL,
    [ReceiveCashAssistance]            BIT             CONSTRAINT [DF_ClientIntake_ReceiveCashAssistance] DEFAULT ((0)) NULL,
    [ReceiveSSIBenefits]               BIT             CONSTRAINT [DF_ClientIntake_ReceiveSSIBenefits] DEFAULT ((0)) NULL,
    [ReceiveUnemploymentBenefits]      BIT             CONSTRAINT [DF_ClientIntake_ReceiveUnemploymentBenefits] DEFAULT ((0)) NULL,
    [HasInsuranceCoverage]             BIT             CONSTRAINT [DF_ClientIntake_HasInsuranceCoverage] DEFAULT ((0)) NULL,
    [ReceiveVeteransBenefits]          BIT             CONSTRAINT [DF_ClientIntake_ReceiveVeteransBenefits] DEFAULT ((0)) NULL,
    [FinancialStatusComments]          VARCHAR (2000)  NULL,
    [HasBeenAbused]                    BIT             CONSTRAINT [DF_ClientIntake_HasBeenAbused] DEFAULT ((0)) NULL,
    [IsAbusedVerbally]                 BIT             CONSTRAINT [DF_ClientIntake_IsAbusedVerbally] DEFAULT ((0)) NULL,
    [IsAbusedPhysically]               BIT             CONSTRAINT [DF_ClientIntake_IsAbusedPhysically] DEFAULT ((0)) NULL,
    [IsAbusedSexually]                 BIT             CONSTRAINT [DF_ClientIntake_IsAbusedSexually] DEFAULT ((0)) NULL,
    [CurrentlyAbusiveRelationship]     BIT             CONSTRAINT [DF_ClientIntake_CurrentlyAbusiveRelationship] DEFAULT ((0)) NULL,
    [KnowAvailableResources]           BIT             CONSTRAINT [DF_ClientIntake_KnowAvailableResources] DEFAULT ((0)) NULL,
    [AbuseImpactsCurrentJob]           BIT             CONSTRAINT [DF_ClientIntake_AbuseImpactsCurrentJob] DEFAULT ((0)) NULL,
    [DomesticViolenceComments]         VARCHAR (2000)  NULL,
    [ParticipantAttestation]           VARCHAR (500)   NULL,
    [Signature]                        VARCHAR (MAX)   NULL,
    [IntakeDate]                       SMALLDATETIME   NULL,
    [UseSMSHomePhone]                  BIT             CONSTRAINT [DF_ClientIntake_UseSMSHomePhone] DEFAULT ((0)) NULL,
    [UseSMSMobilePhone]                BIT             CONSTRAINT [DF_ClientIntake_UseSMSMobilePhone] DEFAULT ((0)) NULL,
    [UseSMSOtherPhone]                 BIT             CONSTRAINT [DF_ClientIntake_UseSMSOtherPhone] DEFAULT ((0)) NULL,
    [FormVersionId]                    INT             NULL,
    [CreatedBy]                        VARCHAR (80)    NULL,
    [CreatedAt]                        DATETIME        NULL,
    [UpdatedBy]                        VARCHAR (80)    NULL,
    [UpdatedAt]                        DATETIME        NULL,
    [ReasonTypeId]                     INT             NULL,
    [ScanImageId]                      INT             NULL,
    [ResidentialAddressStreet2]        VARCHAR (300)   NULL,
    [MailingAddressStreet2]            VARCHAR (300)   NULL,
    [NumChildren]                      INT             NULL,
    [CaresForSickFamilyMember]         BIT             NULL,
    [HasChildren]                      BIT             NULL,
    [RelationshipStatusId]             INT             NULL,
    [IsLocked]                         BIT             CONSTRAINT [DF_ClientIntake_IsLocked] DEFAULT ((0)) NOT NULL,
    [IsDeleted]                        BIT             CONSTRAINT [DF_ClientIntake_IsDeleted] DEFAULT ((0)) NOT NULL,
    [AssignedStaffMemberId]            INT             NULL,
    CONSTRAINT [PK_ClientIntake] PRIMARY KEY CLUSTERED ([ClientIntakeId] ASC),
    CONSTRAINT [FK_ClinetIntake_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_ClinetIntake_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_ClinetIntake_FormVersion] FOREIGN KEY ([FormVersionId]) REFERENCES [dbo].[FormVersion] ([FormVersionId])
);


GO





CREATE TRIGGER [dbo].[ClientIntakeLog] ON [dbo].[ClientIntake] 
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
Set @TableName = N'ClientIntake'

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

