CREATE TABLE [dbo].[CrS_Timekeeping_rejection] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [DateTimeStamp]    DATETIME      NULL,
    [ClientId]         INT           NULL,
    [DTSAssignmentId]  VARCHAR (11)  NULL,
    [CIN]              VARCHAR (9)   NULL,
    [RecordType]       VARCHAR (1)   NULL,
    [ActivityDate]     VARCHAR (11)  NULL,
    [ActivityCode]     VARCHAR (2)   NULL,
    [ActivityHours]    INT           NULL,
    [DeleteIndicator]  VARCHAR (1)   NULL,
    [ErrorCode]        VARCHAR (3)   NULL,
    [ErrorDescription] VARCHAR (125) NULL,
    [RunId]            INT           NULL,
    CONSTRAINT [PK_CrS_Timekeeping_rejection] PRIMARY KEY CLUSTERED ([ID] ASC)
);

