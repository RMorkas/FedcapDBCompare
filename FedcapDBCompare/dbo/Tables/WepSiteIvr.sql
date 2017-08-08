CREATE TABLE [dbo].[WepSiteIvr] (
    [WepSiteIvrId] INT          IDENTITY (1, 1) NOT NULL,
    [PhoneNumber]  VARCHAR (20) NULL,
    [WepSiteId]    INT          NULL,
    CONSTRAINT [PK_WepSiteIvr] PRIMARY KEY CLUSTERED ([WepSiteIvrId] ASC),
    CONSTRAINT [FK_WepSiteIvr_WepSite] FOREIGN KEY ([WepSiteId]) REFERENCES [dbo].[WepSite] ([WepSiteId])
);

