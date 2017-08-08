CREATE TABLE [dbo].[FedCapActivityLog] (
    [LogTranId]  INT          IDENTITY (1, 1) NOT NULL,
    [LoginLogId] INT          NULL,
    [CompanyId]  INT          NULL,
    [GroupId]    INT          NULL,
    [UserId]     INT          NULL,
    [UserName]   VARCHAR (80) NULL,
    [ModuleId]   INT          NULL,
    [TranType]   VARCHAR (50) NULL,
    [TranDate]   DATETIME     NULL,
    CONSTRAINT [PK_FedCapActivityLog] PRIMARY KEY CLUSTERED ([LogTranId] ASC),
    CONSTRAINT [FK_FedCapActivityLog_LoginLog] FOREIGN KEY ([LoginLogId]) REFERENCES [dbo].[LoginLog] ([LogTranId])
);

