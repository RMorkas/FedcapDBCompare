CREATE TABLE [dbo].[temp] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [CaseManagerName] VARCHAR (100) NULL,
    [LINDID]          VARCHAR (50)  NULL,
    [CaseManagerID]   INT           NULL,
    CONSTRAINT [PK_temp] PRIMARY KEY CLUSTERED ([id] ASC)
);

