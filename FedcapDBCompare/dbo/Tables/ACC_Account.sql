CREATE TABLE [dbo].[ACC_Account] (
    [AccountId]   INT           NOT NULL,
    [AccountName] VARCHAR (200) NULL,
    CONSTRAINT [PK_ACC_Account] PRIMARY KEY CLUSTERED ([AccountId] ASC)
);

