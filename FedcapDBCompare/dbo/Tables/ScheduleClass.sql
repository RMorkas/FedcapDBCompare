CREATE TABLE [dbo].[ScheduleClass] (
    [ClassId]           INT           IDENTITY (1, 1) NOT NULL,
    [ClassDescription]  VARCHAR (100) NULL,
    [StartTime]         DATETIME      NULL,
    [EndTime]           DATETIME      NULL,
    [FederalActivityId] INT           NULL,
    [IsDeleted]         BIT           CONSTRAINT [DF_ScheduleClass_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]         VARCHAR (80)  NULL,
    [CreatedAt]         DATETIME      NULL,
    [UpdatedBy]         VARCHAR (80)  NULL,
    [UpdatedAt]         DATETIME      NULL,
    CONSTRAINT [PK_ScheduleClass] PRIMARY KEY CLUSTERED ([ClassId] ASC)
);

