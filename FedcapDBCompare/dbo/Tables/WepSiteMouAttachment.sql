CREATE TABLE [dbo].[WepSiteMouAttachment] (
    [WepSiteMouAttachmentId] INT             IDENTITY (1, 1) NOT NULL,
    [MouFileBinary]          VARBINARY (MAX) NOT NULL,
    [MouFileName]            VARCHAR (100)   NULL,
    [WepSiteId]              INT             NOT NULL,
    [DocumentDate]           DATETIME        NULL,
    [IsDeleted]              BIT             CONSTRAINT [DF_WepSiteMouAttachment_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WepSiteMouAttachment] PRIMARY KEY CLUSTERED ([WepSiteMouAttachmentId] ASC),
    CONSTRAINT [FK_WepSiteMouAttachment_WepSite] FOREIGN KEY ([WepSiteId]) REFERENCES [dbo].[WepSite] ([WepSiteId])
);



