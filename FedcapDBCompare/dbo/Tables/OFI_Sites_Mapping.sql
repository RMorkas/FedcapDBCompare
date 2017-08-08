CREATE TABLE [dbo].[OFI_Sites_Mapping] (
    [OFI_SiteID] INT NOT NULL,
    [SiteID]     INT NOT NULL,
    CONSTRAINT [PK_OFI_Sites_Mapping] PRIMARY KEY CLUSTERED ([OFI_SiteID] ASC, [SiteID] ASC)
);

