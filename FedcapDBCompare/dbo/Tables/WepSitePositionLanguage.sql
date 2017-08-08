CREATE TABLE [dbo].[WepSitePositionLanguage] (
    [WepSitePositionLanguageId] INT IDENTITY (1, 1) NOT NULL,
    [WepSitePositionId]         INT NULL,
    [LanguageId]                INT NOT NULL,
    CONSTRAINT [PK_WepSitePositionLanguage] PRIMARY KEY CLUSTERED ([WepSitePositionLanguageId] ASC),
    CONSTRAINT [FK_WepSitePositionLanguage_WepSitePosition] FOREIGN KEY ([WepSitePositionId]) REFERENCES [dbo].[WepSitePosition] ([WepSitePositionId])
);

