CREATE TABLE [dbo].[Site_Mapping] (
    [CompanyId]       INT          NULL,
    [ReferringSiteId] VARCHAR (20) NULL,
    [SiteId]          INT          NULL,
    [SiteMappingId]   INT          IDENTITY (1, 1) NOT NULL,
    [IsDev]           BIT          NULL,
    [IsUAT]           BIT          NULL,
    [IsStaging]       BIT          NULL,
    [IsProd]          BIT          NULL,
    CONSTRAINT [PK_Site_Mapping] PRIMARY KEY CLUSTERED ([SiteMappingId] ASC)
);

