CREATE TABLE [dbo].[Fed_SystemVersion] (
    [VersionId]      INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT           NULL,
    [PublishedDate]  SMALLDATETIME NULL,
    [VersionNumber]  VARCHAR (20)  NULL,
    [IsRequired]     BIT           NULL,
    [WarningTimeout] INT           NULL,
    CONSTRAINT [PK_Fed_SystemVersion] PRIMARY KEY CLUSTERED ([VersionId] ASC)
);

