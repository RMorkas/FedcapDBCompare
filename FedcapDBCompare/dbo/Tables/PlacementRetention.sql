CREATE TABLE [dbo].[PlacementRetention] (
    [PlacementRetentionId] INT           IDENTITY (1, 1) NOT NULL,
    [PlacementEntryID]     INT           NULL,
    [Sequence]             INT           NULL,
    [RetentionId]          INT           NULL,
    [RetentionStatusId]    INT           NULL,
    [Comment]              VARCHAR (400) NULL,
    [TempComment]          VARCHAR (400) NULL,
    [DocumentId]           INT           NULL,
    [SaveBy]               VARCHAR (80)  NULL,
    [SaveAt]               DATETIME      NULL,
    [PlacementPeriodId]    INT           NULL,
    [IsBilled]             BIT           CONSTRAINT [DF_PlacementRetention_IsBilled] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PlacementRetention] PRIMARY KEY CLUSTERED ([PlacementRetentionId] ASC),
    CONSTRAINT [FK_PlacementRetention_PlacementEntry] FOREIGN KEY ([PlacementEntryID]) REFERENCES [dbo].[PlacementEntry] ([PlacementEntryID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from enum table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementRetention', @level2type = N'COLUMN', @level2name = N'RetentionId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Read from enum table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementRetention', @level2type = N'COLUMN', @level2name = N'RetentionStatusId';

