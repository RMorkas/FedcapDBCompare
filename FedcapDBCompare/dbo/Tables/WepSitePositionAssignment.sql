CREATE TABLE [dbo].[WepSitePositionAssignment] (
    [WepSitePositionAssignmentId] INT      IDENTITY (1, 1) NOT NULL,
    [WepSitePositionId]           INT      NULL,
    [ClientId]                    INT      NOT NULL,
    [StartDate]                   DATETIME NULL,
    [EndDate]                     DATETIME NULL,
    [IsActive]                    BIT      CONSTRAINT [DF_WebProviderPositionAssignment_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WepSitePositionAssignment] PRIMARY KEY CLUSTERED ([WepSitePositionAssignmentId] ASC),
    CONSTRAINT [FK_WepSitePositionAssignment_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_WepSitePositionAssignment_WepSitePosition] FOREIGN KEY ([WepSitePositionId]) REFERENCES [dbo].[WepSitePosition] ([WepSitePositionId])
);

