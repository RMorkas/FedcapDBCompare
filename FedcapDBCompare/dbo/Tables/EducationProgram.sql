CREATE TABLE [dbo].[EducationProgram] (
    [EducationProgramId]  INT            IDENTITY (1, 1) NOT NULL,
    [EducationProviderId] INT            NOT NULL,
    [StreetAddress]       VARCHAR (50)   NULL,
    [City]                VARCHAR (25)   NULL,
    [State]               VARCHAR (25)   NULL,
    [ZipCode]             VARCHAR (20)   NULL,
    [ContactName]         VARCHAR (100)  NULL,
    [PhoneNumber]         VARCHAR (20)   NULL,
    [ProgramName]         VARCHAR (100)  NULL,
    [CreatedBy]           VARCHAR (80)   NULL,
    [CreatedAt]           DATETIME       NULL,
    [UpdatedBy]           VARCHAR (80)   NULL,
    [UpdatedAt]           DATETIME       NULL,
    [IsDeleted]           BIT            CONSTRAINT [DF_EducationProgram_IsDeleted] DEFAULT ((0)) NOT NULL,
    [AttainmentTypeId]    INT            NULL,
    [InfoUrl]             VARCHAR (200)  NULL,
    [Description]         VARCHAR (2000) NULL,
    CONSTRAINT [PK_EducationProgram] PRIMARY KEY CLUSTERED ([EducationProgramId] ASC),
    CONSTRAINT [FK_EducationProgram_EducationProvider] FOREIGN KEY ([EducationProviderId]) REFERENCES [dbo].[EducationProvider] ([EducationProviderId])
);

