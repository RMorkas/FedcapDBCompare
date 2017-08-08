CREATE TABLE [dbo].[ACC_Company] (
    [CompanyId]   INT           NOT NULL,
    [CompanyName] NVARCHAR (50) NULL,
    CONSTRAINT [PK_ACC_Division] PRIMARY KEY CLUSTERED ([CompanyId] ASC)
);

