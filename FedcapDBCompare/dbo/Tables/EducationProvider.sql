CREATE TABLE [dbo].[EducationProvider] (
    [EducationProviderId] INT           IDENTITY (1, 1) NOT NULL,
    [SchoolTypeId]        INT           NULL,
    [Name]                VARCHAR (100) NULL,
    [StreetAddress]       VARCHAR (50)  NULL,
    [City]                VARCHAR (25)  NULL,
    [State]               VARCHAR (25)  NULL,
    [ZipCode]             VARCHAR (20)  NULL,
    [Website]             VARCHAR (100) NULL,
    [CreatedBy]           VARCHAR (80)  NULL,
    [CreatedAt]           DATETIME      NULL,
    [UpdatedBy]           VARCHAR (80)  NULL,
    [UpdatedAt]           DATETIME      NULL,
    [IsDeleted]           BIT           CONSTRAINT [DF_EducationProvider_IsDeleted] DEFAULT ((0)) NOT NULL,
    [PhoneNumber]         VARCHAR (20)  NULL,
    [InfoUrl]             VARCHAR (200) NULL,
    CONSTRAINT [PK_EducationProvider] PRIMARY KEY CLUSTERED ([EducationProviderId] ASC)
);

