CREATE TABLE [dbo].[DatabaseEnvironments] (
    [DBId]         INT           IDENTITY (1, 1) NOT NULL,
    [DatabaseName] VARCHAR (125) NULL,
    [Environment]  VARCHAR (20)  NULL,
    CONSTRAINT [PK_DatabaseEnvironments] PRIMARY KEY CLUSTERED ([DBId] ASC)
);

