CREATE TABLE [dbo].[ChildCareProviderType] (
    [ChildCareProviderTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [Code]                    VARCHAR (5)   NOT NULL,
    [Description]             VARCHAR (100) NULL,
    [CompanyId]               INT           NULL,
    CONSTRAINT [PK_ChildCareProviderType] PRIMARY KEY CLUSTERED ([ChildCareProviderTypeId] ASC)
);

