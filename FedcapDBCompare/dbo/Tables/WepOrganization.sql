CREATE TABLE [dbo].[WepOrganization] (
    [WepOrganizationId] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT           NOT NULL,
    [Name]              VARCHAR (100) NOT NULL,
    [Director]          VARCHAR (100) NULL,
    [IndustryId]        INT           NULL,
    [CreatedBy]         VARCHAR (50)  NULL,
    [CreatedAt]         DATETIME      NULL,
    [UpdatedBy]         VARCHAR (50)  NULL,
    [UpdatedAt]         DATETIME      NULL,
    [IsDeleted]         BIT           CONSTRAINT [DF_WepOrganization_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WepOrganization] PRIMARY KEY CLUSTERED ([WepOrganizationId] ASC)
);

