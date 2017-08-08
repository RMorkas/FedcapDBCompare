CREATE TABLE [dbo].[ClientVocAssessment] (
    [VocAssessmentId]           INT             IDENTITY (1, 1) NOT NULL,
    [CompanyId]                 INT             NULL,
    [ClientId]                  INT             NULL,
    [IsTABE]                    BIT             NULL,
    [IsCareerScope]             BIT             NULL,
    [IsVocInterest]             BIT             NULL,
    [IsPineyMountain]           BIT             NULL,
    [IsOther]                   BIT             NULL,
    [TABEDate]                  SMALLDATETIME   NULL,
    [TABETypeId]                INT             NULL,
    [ReadingScore]              NUMERIC (18, 2) NULL,
    [WritingScore]              NUMERIC (18, 2) NULL,
    [MathScore]                 NUMERIC (18, 2) NULL,
    [LanguageScore]             NUMERIC (18, 2) NULL,
    [ReadingLevelId]            INT             NULL,
    [WritingLevelId]            INT             NULL,
    [MathLevelId]               INT             NULL,
    [LanguageLevelId]           INT             NULL,
    [TABENotes]                 VARCHAR (3000)  NULL,
    [CareerScopeDate]           SMALLDATETIME   NULL,
    [ArtisticScore]             INT             NULL,
    [ScientificScore]           INT             NULL,
    [PlantsScore]               INT             NULL,
    [ProtectiveScore]           INT             NULL,
    [MechanicalScore]           INT             NULL,
    [IndustrialScore]           INT             NULL,
    [BusinessScore]             INT             NULL,
    [SellingScore]              INT             NULL,
    [AccommodatingScore]        INT             NULL,
    [HumanitarianScore]         INT             NULL,
    [LeadingScore]              INT             NULL,
    [PhysicalScore]             INT             NULL,
    [ArtisticPercentage]        NUMERIC (18, 2) NULL,
    [ScientificPercentage]      NUMERIC (18, 2) NULL,
    [PlantsPercentage]          NUMERIC (18, 2) NULL,
    [ProtectivePercentage]      NUMERIC (18, 2) NULL,
    [MechanicalPercentage]      NUMERIC (18, 2) NULL,
    [IndustrialPercentage]      NUMERIC (18, 2) NULL,
    [BusinessPercentage]        NUMERIC (18, 2) NULL,
    [SellingPercentage]         NUMERIC (18, 2) NULL,
    [AccommodatingPercentage]   NUMERIC (18, 2) NULL,
    [HumanitarianPercentage]    NUMERIC (18, 2) NULL,
    [LeadingPercentage]         NUMERIC (18, 2) NULL,
    [PhysicalPercentage]        NUMERIC (18, 2) NULL,
    [ArtisticLevelId]           INT             NULL,
    [ScientificLevelId]         INT             NULL,
    [PlantsLevelId]             INT             NULL,
    [ProtectiveLevelId]         INT             NULL,
    [MechanicalLevelId]         INT             NULL,
    [IndustrialLevelId]         INT             NULL,
    [BusinessLevelId]           INT             NULL,
    [SellingLevelId]            INT             NULL,
    [AccommodatingLevelId]      INT             NULL,
    [HumanitarianLevelId]       INT             NULL,
    [LeadingLevelId]            INT             NULL,
    [PhysicalLevelId]           INT             NULL,
    [CareerScopeNotes1]         VARCHAR (3000)  NULL,
    [LearningAbilityScore]      INT             NULL,
    [VerbalAptScore]            INT             NULL,
    [NumericalAptScore]         INT             NULL,
    [SpatialAptScore]           INT             NULL,
    [FormPercScore]             INT             NULL,
    [ClericalPercScore]         INT             NULL,
    [MotorScore]                INT             NULL,
    [FingerDexScore]            INT             NULL,
    [ManualDexScore]            INT             NULL,
    [LearningAbilityPercentage] NUMERIC (18, 2) NULL,
    [VerbalAptPercentage]       NUMERIC (18, 2) NULL,
    [NumericalAptPercentage]    NUMERIC (18, 2) NULL,
    [SpatialAptPercentage]      NUMERIC (18, 2) NULL,
    [FormPercPercentage]        NUMERIC (18, 2) NULL,
    [ClericalPercPercentage]    NUMERIC (18, 2) NULL,
    [MotorPercentage]           NUMERIC (18, 2) NULL,
    [FingerDexPercentage]       NUMERIC (18, 2) NULL,
    [ManualDexPercentage]       NUMERIC (18, 2) NULL,
    [LearningAbilityLevelId]    INT             NULL,
    [VerbalAptLevelId]          INT             NULL,
    [NumericalAptLevelId]       INT             NULL,
    [SpatialAptLevelId]         INT             NULL,
    [FormPercLevelId]           INT             NULL,
    [ClericalPercLevelId]       INT             NULL,
    [MotorLevelId]              INT             NULL,
    [FingerDexLevelId]          INT             NULL,
    [ManualDexLevelId]          INT             NULL,
    [CareerScopeNotes2]         VARCHAR (3000)  NULL,
    [VocInterestDate]           SMALLDATETIME   NULL,
    [AutomotiveLevelId]         INT             NULL,
    [ClericalLevelId]           INT             NULL,
    [FoodServiceLevelId]        INT             NULL,
    [HorticultureLevelId]       INT             NULL,
    [PersonalLevelId]           INT             NULL,
    [MaterialsLevelId]          INT             NULL,
    [BuildingLevelId]           INT             NULL,
    [AnimalCareLevelId]         INT             NULL,
    [PatientCareLevelId]        INT             NULL,
    [HousekeepingLevelId]       INT             NULL,
    [LaundryLevelId]            INT             NULL,
    [VocInterestNotes]          VARCHAR (3000)  NULL,
    [Behavebservations]         VARCHAR (3000)  NULL,
    [NETCode]                   VARCHAR (80)    NULL,
    [NETDescription]            VARCHAR (3000)  NULL,
    [GOECode]                   VARCHAR (80)    NULL,
    [GOEDescription]            VARCHAR (3000)  NULL,
    [PineyMountainDate]         DATETIME        NULL,
    [KinestheticScore]          INT             NULL,
    [IsKinesthetic]             BIT             NULL,
    [VisualScore]               INT             NULL,
    [IsVisual]                  BIT             NULL,
    [TactileScore]              INT             NULL,
    [IsTactile]                 BIT             NULL,
    [AuditoryScore]             INT             NULL,
    [IsAuditory]                BIT             NULL,
    [GroupScore]                INT             NULL,
    [IsGroup]                   BIT             NULL,
    [IndividualScore]           INT             NULL,
    [IsIndividual]              BIT             NULL,
    [DesignFormalScore]         INT             NULL,
    [IsDesignFormal]            BIT             NULL,
    [DesignInformalScore]       INT             NULL,
    [IsDesignInformal]          BIT             NULL,
    [WellLitScore]              INT             NULL,
    [IsWellLit]                 BIT             NULL,
    [DimScore]                  INT             NULL,
    [IsDim]                     BIT             NULL,
    [WarmScore]                 INT             NULL,
    [IsWarm]                    BIT             NULL,
    [CoolScore]                 INT             NULL,
    [IsCool]                    BIT             NULL,
    [QuietScore]                INT             NULL,
    [IsQuiet]                   BIT             NULL,
    [NoiseScore]                INT             NULL,
    [IsNoise]                   BIT             NULL,
    [OralScore]                 INT             NULL,
    [IsOral]                    BIT             NULL,
    [WrittenScore]              INT             NULL,
    [IsWritten]                 BIT             NULL,
    [OutdoorsScore]             INT             NULL,
    [IsOutdoors]                BIT             NULL,
    [IndoorsScore]              INT             NULL,
    [IsIndoors]                 BIT             NULL,
    [SedentaryScore]            INT             NULL,
    [IsSedentary]               BIT             NULL,
    [NonSedentaryScore]         INT             NULL,
    [IsNonSedentary]            BIT             NULL,
    [LiftingScore]              INT             NULL,
    [IsLifting]                 BIT             NULL,
    [DataScore]                 INT             NULL,
    [IsData]                    BIT             NULL,
    [PeopleScore]               INT             NULL,
    [IsPeople]                  BIT             NULL,
    [ThingsScore]               INT             NULL,
    [IsThings]                  BIT             NULL,
    [FormVersionId]             INT             NULL,
    [CreatedBy]                 VARCHAR (80)    NULL,
    [CreatedAt]                 DATETIME        NULL,
    [UpdatedBy]                 VARCHAR (80)    NULL,
    [UpdatedAt]                 DATETIME        NULL,
    [IsLocked]                  BIT             CONSTRAINT [DF_ClientVocAssessment_IsLocked] DEFAULT ((0)) NOT NULL,
    [IsDeleted]                 BIT             CONSTRAINT [DF_ClientVocAssessment_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ClientVocAssessment] PRIMARY KEY CLUSTERED ([VocAssessmentId] ASC),
    CONSTRAINT [FK_ClientVocAssessment_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId])
);


GO
CREATE TRIGGER [dbo].[VocAssessmentAudit] ON dbo.ClientVocAssessment 
after UPDATE , INSERT, Delete
AS
Declare @TableName varchar(50), @formId int, @updatedBy varchar(80), @isDeleted bit
Set @TableName = 'ClientVocAssessment'

Select @formId = FormId from dbo.formInfo Where FormName = @TableName

Select @updatedBy = UpdatedBy, @isDeleted = IsDeleted  From inserted

If(@updatedBy IS NULL)
BEGIN
	Insert into [dbo].[FormAudit] (FormId, FormRecordId, SavedDate, SavedBy, TransType)
	Select @formId, VocAssessmentId, [CreatedAt] , [CreatedBy], 'Insert' From inserted
END
ELSE IF(@isDeleted = 0 or @isDeleted IS NULL)
BEGIN
	Insert into [dbo].[FormAudit] (FormId, FormRecordId, SavedDate, SavedBy, TransType)
	Select @formId, VocAssessmentId, [UpdatedAt] , [UpdatedBy] , 'Update' From inserted
END
ELSE IF(@isDeleted = 1)
BEGIN
	Insert into [dbo].[FormAudit] (FormId, FormRecordId, SavedDate, SavedBy, TransType)
	Select @formId, VocAssessmentId, [UpdatedAt] , [UpdatedBy] , 'Delete' From inserted
END

GO
CREATE TRIGGER [dbo].[VocAssessmentLog] ON dbo.ClientVocAssessment 
FOR UPDATE , INSERT
AS

Declare @TableName nvarchar(80) , @count int , @index int, @columnName nvarchar(100) , @oldValue nvarchar(max) ,@newValue nvarchar(max) , 
@SQLString nvarchar(Max) , @outPut nvarchar(max), @TableId int , @PKFieldName nvarchar(80),
@PKFieldValue int , @SavedBy varchar(80) , @SavedAt DateTime , @UpdatedBy varchar(80) , @TranSavedId int , @IsUpdatedTrigger int,
@lastSequence int,  @ChildRowsCount int , @ChildTableName varchar(80) , @ChildPKName varchar(80), @MaxRetry int, @RetryCount int

SET @RetryCount = 0
SET @MaxRetry = 3
Set @TableName = N'ClientVocAssessment'

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
	
----/*
----****************************
----Set Child Table Name and Child PK if exist else comment Procedure.
----****************************
----*/
Set @ChildTableName = 'ClientVocAssessmentGOE'
SET @ChildPKName = 'ClientVocAssessmentGOEId'

Exec UpdateChildTables @ChildTableName , @ChildPKName , @PKFieldName , @PKFieldValue

Set @ChildTableName = 'ClientVocAssessmentONet'
SET @ChildPKName = 'ClientVocAssessmentONetId'

Exec UpdateChildTables @ChildTableName , @ChildPKName , @PKFieldName , @PKFieldValue
