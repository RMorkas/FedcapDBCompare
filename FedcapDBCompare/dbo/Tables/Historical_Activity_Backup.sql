CREATE TABLE [dbo].[Historical_Activity_Backup] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [ImportDate]        DATETIME      NULL,
    [CompanyId]         INT           NULL,
    [ClientId]          VARCHAR (20)  NULL,
    [FederalActivityId] INT           NULL,
    [Type]              VARCHAR (5)   NULL,
    [StartDate]         DATETIME      NULL,
    [EndDate]           DATETIME      NULL,
    [Description]       VARCHAR (100) NULL,
    [IsProcessed]       BIT           NULL,
    [WeeklyHours]       INT           NULL,
    [AttendanceType]    VARCHAR (5)   NULL,
    CONSTRAINT [PK__Historical_Act] PRIMARY KEY CLUSTERED ([Id] ASC)
);

