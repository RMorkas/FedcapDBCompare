CREATE TABLE [dbo].[PlacementEntryFollowUp] (
    [FollowUpId]         INT             IDENTITY (1, 1) NOT NULL,
    [PlacementEntryId]   INT             NULL,
    [FollowUpReason]     VARCHAR (200)   NULL,
    [FollowUpDate]       SMALLDATETIME   NULL,
    [FollowUpType]       TINYINT         CONSTRAINT [DF_PlacementEntryFollowUp_FollowUpType] DEFAULT ((0)) NULL,
    [FollowUpDetails]    VARCHAR (MAX)   NULL,
    [NextFollowUp]       BIT             NULL,
    [NextFollowUpDate]   SMALLDATETIME   NULL,
    [NextFollowUpType]   TINYINT         CONSTRAINT [DF_PlacementEntryFollowUp_NextFollowUpType] DEFAULT ((0)) NULL,
    [NextFollowUpReason] VARCHAR (200)   CONSTRAINT [DF_PlacementEntryFollowUp_NextFollowUpReason] DEFAULT ((0)) NULL,
    [CreatedBy]          VARCHAR (80)    NULL,
    [CreatedAt]          DATETIME        NULL,
    [UpdatedBy]          VARCHAR (80)    NULL,
    [UpdatedAt]          DATETIME        NULL,
    [Salary]             DECIMAL (18, 2) NULL,
    [SalaryRate]         TINYINT         NULL,
    [SalaryPerHour]      DECIMAL (18, 2) NULL,
    [HoursPerWeek]       INT             NULL,
    CONSTRAINT [PK_PlacementEntryFollowUp] PRIMARY KEY CLUSTERED ([FollowUpId] ASC),
    CONSTRAINT [FK_PlacementEntryFollowUp_PlacementEntry] FOREIGN KEY ([PlacementEntryId]) REFERENCES [dbo].[PlacementEntry] ([PlacementEntryID])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' 1 Office visit ; 2 Phone ; 3 Email ; 0 Empty(for initial placements only)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntryFollowUp', @level2type = N'COLUMN', @level2name = N'FollowUpType';




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' 1 Office visit ; 2 Phone ; 3 Email ;', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntryFollowUp', @level2type = N'COLUMN', @level2name = N'NextFollowUpType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' 0 Office visit ; 1 Phone ; 2 Email ;', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PlacementEntryFollowUp', @level2type = N'COLUMN', @level2name = N'NextFollowUpReason';

