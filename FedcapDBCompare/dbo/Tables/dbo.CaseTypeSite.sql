CREATE TABLE [dbo].[CaseTypeSite] (
    [CaseTypeSiteId] INT IDENTITY (1, 1) NOT NULL,
    [CaseTypeId]     INT NULL,
    [SiteId]         INT NULL,
    [IsDev]          BIT NULL,
    [IsUAT]          BIT NULL,
    [IsStaging]      BIT NULL,
    [IsProd]         BIT NULL,
    CONSTRAINT [PK_CaseTypeSite] PRIMARY KEY CLUSTERED ([CaseTypeSiteId] ASC),
    CONSTRAINT [FK_CaseTypeSite_CaseType] FOREIGN KEY ([CaseTypeId]) REFERENCES [dbo].[CaseType] ([CaseTypeId]),
    CONSTRAINT [FK_CaseTypeSite_Site] FOREIGN KEY ([SiteId]) REFERENCES [dbo].[Site] ([SiteId])
);

