CREATE TABLE [dbo].[ErrorLog] (
    [ErrorLogId]     INT           IDENTITY (1, 1) NOT NULL,
    [ErrorTime]      DATETIME      NULL,
    [CompanyId]      INT           NULL,
    [UserName]       VARCHAR (80)  NULL,
    [ClassName]      VARCHAR (80)  NULL,
    [ProcedureName]  VARCHAR (128) NULL,
    [IsSqlException] BIT           NULL,
    [ExceptionType]  VARCHAR (MAX) NULL,
    [ErrorNumber]    INT           NULL,
    [ErrorState]     INT           NULL,
    [ErrorLine]      INT           NULL,
    [ErrorMessage]   VARCHAR (MAX) NULL,
    [InnerException] VARCHAR (MAX) NULL,
    [IsHandledError] BIT           NULL,
    CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([ErrorLogId] ASC)
);

