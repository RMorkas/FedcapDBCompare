CREATE TABLE [dbo].[Site] (
    [SiteId]        INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]     INT           NULL,
    [IsActive]      BIT           CONSTRAINT [DF_Site_IsAcive] DEFAULT ((1)) NULL,
    [SiteType]      TINYINT       NULL,
    [SiteName]      VARCHAR (80)  NULL,
    [Email]         NVARCHAR (50) NULL,
    [StreetAddress] VARCHAR (50)  NULL,
    [City]          VARCHAR (25)  NULL,
    [State]         VARCHAR (25)  NULL,
    [ZipCode]       VARCHAR (20)  NULL,
    [IsDeleted]     BIT           CONSTRAINT [DF_Site_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]     VARCHAR (80)  NULL,
    [CreatedAt]     DATETIME      NULL,
    [UpdatedBy]     VARCHAR (80)  NULL,
    [UpdatedAt]     DATETIME      NULL,
    [SitePhone]     VARCHAR (50)  NULL,
    [sitemanagerid] INT           NULL,
    CONSTRAINT [PK_Sites] PRIMARY KEY CLUSTERED ([SiteId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 Clinc ; 1 non Clinc', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Site', @level2type = N'COLUMN', @level2name = N'SiteType';

