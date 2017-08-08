CREATE TABLE [dbo].[Historical_Extension] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ImportDate]         DATETIME       NULL,
    [ClientNo]           VARCHAR (20)   NULL,
    [Type]               VARCHAR (5)    NULL,
    [Status]             VARCHAR (5)    NULL,
    [Denial]             VARCHAR (5)    NULL,
    [StartDate]          DATETIME       NULL,
    [EndDate]            DATETIME       NULL,
    [ApprovedDeniedDate] DATETIME       NULL,
    [Indicator]          VARCHAR (2)    NULL,
    [Reason]             VARCHAR (2000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

