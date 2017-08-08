CREATE TABLE [dbo].[ScheduleEventUser] (
    [EventUserId] INT IDENTITY (1, 1) NOT NULL,
    [UserId]      INT NULL,
    [EventId]     INT NULL,
    CONSTRAINT [PK_ScheduleEventUser] PRIMARY KEY CLUSTERED ([EventUserId] ASC),
    CONSTRAINT [FK_ScheduleEventUser_ScheduleEvent] FOREIGN KEY ([EventId]) REFERENCES [dbo].[ScheduleEvent] ([EventId]),
    CONSTRAINT [FK_ScheduleEventUser_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserID])
);

