CREATE TABLE [dbo].[LoginLog] (
    [LogTranId]     INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]     INT          NULL,
    [GroupId]       INT          NULL,
    [UserId]        INT          NULL,
    [UserName]      VARCHAR (80) NULL,
    [LoginDate]     DATETIME     NULL,
    [VersionNumber] VARCHAR (20) NULL,
    [HostName]      VARCHAR (80) NULL,
    CONSTRAINT [PK_LoginLog] PRIMARY KEY CLUSTERED ([LogTranId] ASC)
);

