CREATE TABLE [dbo].[Historical_Activity] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [ImportDate]        DATETIME      CONSTRAINT [DF_Historical_Activity_ImportDate] DEFAULT (getdate()) NULL,
    [CompanyId]         INT           NULL,
    [ClientId]          VARCHAR (20)  NULL,
    [FederalActivityId] INT           NULL,
    [Type]              VARCHAR (5)   NULL,
    [StartDate]         DATETIME      NULL,
    [EndDate]           DATETIME      NULL,
    [Description]       VARCHAR (100) NULL,
    [IsProcessed]       BIT           CONSTRAINT [DF_Historical_Activity_IsProcessed] DEFAULT ((0)) NULL,
    [WeeklyHours]       INT           NULL,
    [AttendanceType]    VARCHAR (5)   NULL,
    CONSTRAINT [PK__Historic__3214EC0718777F3D] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_Historical_Actvity]
    ON [dbo].[Historical_Activity]([ImportDate] ASC, [CompanyId] ASC, [ClientId] ASC, [FederalActivityId] ASC, [Type] ASC, [StartDate] ASC, [AttendanceType] ASC);

