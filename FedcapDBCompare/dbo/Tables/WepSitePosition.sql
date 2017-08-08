CREATE TABLE [dbo].[WepSitePosition] (
    [WepSitePositionId] INT            IDENTITY (1, 1) NOT NULL,
    [WepSiteId]         INT            NOT NULL,
    [PositionTypeId]    INT            NULL,
    [NumberOfSlots]     INT            NULL,
    [Languages]         VARCHAR (100)  NULL,
    [Description]       VARCHAR (2000) NULL,
    [CreatedBy]         VARCHAR (50)   NULL,
    [CreatedAt]         DATETIME       NULL,
    [UpdatedBy]         VARCHAR (50)   NULL,
    [UpdatedAt]         DATETIME       NULL,
    [IsDeleted]         BIT            CONSTRAINT [DF_WebProviderPosition_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WepSitePosition] PRIMARY KEY CLUSTERED ([WepSitePositionId] ASC),
    CONSTRAINT [FK_WepSitePosition_WepSite] FOREIGN KEY ([WepSiteId]) REFERENCES [dbo].[WepSite] ([WepSiteId])
);

