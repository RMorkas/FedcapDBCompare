CREATE TABLE [dbo].[FormTestTable] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [IsActive]      BIT           NULL,
    [CompanyId]     INT           NULL,
    [FirstName]     VARCHAR (50)  NULL,
    [LastName]      VARCHAR (50)  NULL,
    [CaseNumber]    VARCHAR (50)  NULL,
    [DOB]           SMALLDATETIME NULL,
    [FormVersionId] INT           NULL,
    [IsDeleted]     BIT           NULL,
    [CreatedBy]     VARCHAR (50)  NULL,
    [CreatedAt]     DATETIME      NULL,
    [UpdatedBy]     VARCHAR (50)  NULL,
    [UpdatedAt]     DATETIME      NULL,
    CONSTRAINT [PK_FormTestTable] PRIMARY KEY CLUSTERED ([Id] ASC)
);

