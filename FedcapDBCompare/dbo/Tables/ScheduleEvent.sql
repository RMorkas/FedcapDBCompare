CREATE TABLE [dbo].[ScheduleEvent] (
    [EventId]           INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT          NULL,
    [SiteId]            INT          NULL,
    [TypeId]            INT          NULL,
    [AllowConflict]     BIT          NULL,
    [EventName]         VARCHAR (50) NULL,
    [IsDeleted]         BIT          CONSTRAINT [DF_ScheduleEvent_IsDeleted] DEFAULT ((0)) NULL,
    [FederalActivityId] INT          NULL,
    [CreatedBy]         VARCHAR (80) NULL,
    [CreatedAt]         DATETIME     NULL,
    [UpdatedBy]         VARCHAR (80) NULL,
    [UpdatedAt]         DATETIME     NULL,
    [IsAutoAbsent]      BIT          NULL,
    [IsAutoPresent]     BIT          NULL,
    [IsActive]          BIT          CONSTRAINT [DF_ScheduleEvent_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_ScheduleEvent] PRIMARY KEY CLUSTERED ([EventId] ASC),
    CONSTRAINT [FK_ScheduleEvent_ScheduleType1] FOREIGN KEY ([TypeId]) REFERENCES [dbo].[ScheduleType] ([TypeId])
);

