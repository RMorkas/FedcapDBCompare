CREATE TABLE [dbo].[CaseClientHistory] (
    [HistoryId]    INT      IDENTITY (1, 1) NOT NULL,
    [CaseClientId] INT      NULL,
    [CaseId]       INT      NULL,
    [ClientId]     INT      NULL,
    [StartDate]    DATETIME NULL,
    [EndDate]      DATETIME NULL,
    CONSTRAINT [PK_CaseClientHistory] PRIMARY KEY CLUSTERED ([HistoryId] ASC)
);

