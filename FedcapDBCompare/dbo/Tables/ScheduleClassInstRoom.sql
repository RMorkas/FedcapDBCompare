CREATE TABLE [dbo].[ScheduleClassInstRoom] (
    [ClassInstRoomId] INT IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT NULL,
    [SiteId]          INT NULL,
    [TypeId]          INT NULL,
    [ClassId]         INT NULL,
    [RoomId]          INT NULL,
    [InstructorId]    INT NULL,
    [IsAutoAbsent]    BIT NULL,
    [IsAutoPresent]   BIT NULL,
    CONSTRAINT [PK_ScheduleClassInstRoom] PRIMARY KEY CLUSTERED ([ClassInstRoomId] ASC),
    CONSTRAINT [FK_ScheduleClassInstRoom_ScheduleClass] FOREIGN KEY ([ClassId]) REFERENCES [dbo].[ScheduleClass] ([ClassId]),
    CONSTRAINT [FK_ScheduleClassInstRoom_ScheduleInstructor] FOREIGN KEY ([InstructorId]) REFERENCES [dbo].[ScheduleInstructor] ([InstructorId]),
    CONSTRAINT [FK_ScheduleClassInstRoom_ScheduleRoom] FOREIGN KEY ([RoomId]) REFERENCES [dbo].[ScheduleRoom] ([RoomId]),
    CONSTRAINT [FK_ScheduleClassInstRoom_ScheduleType] FOREIGN KEY ([TypeId]) REFERENCES [dbo].[ScheduleType] ([TypeId])
);

