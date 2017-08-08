CREATE TABLE [dbo].[PlacementPeriod] (
    [PlacementPeriodId]    INT           IDENTITY (1, 1) NOT NULL,
    [PlacementEntryID]     INT           NULL,
    [Sequence]             INT           NULL,
    [PeriodId]             INT           NULL,
    [Comment]              VARCHAR (250) NULL,
    [AvailabilityDate]     SMALLDATETIME NULL,
    [ExpirationDate]       SMALLDATETIME NULL,
    [PlacementRetentionId] INT           NULL,
    [IsLostJob]            BIT           NULL,
    [IsReplaced]           BIT           NULL,
    CONSTRAINT [PK_PlacementPeriod] PRIMARY KEY CLUSTERED ([PlacementPeriodId] ASC),
    CONSTRAINT [FK_PlacementPeriod_PlacementEntry] FOREIGN KEY ([PlacementEntryID]) REFERENCES [dbo].[PlacementEntry] ([PlacementEntryID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from enum table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementPeriod', @level2type = N'COLUMN', @level2name = N'PeriodId';

