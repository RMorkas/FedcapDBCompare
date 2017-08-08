CREATE TABLE [dbo].[ScheduleCourseFederalActivity] (
    [SchedCourseFederalId] INT IDENTITY (1, 1) NOT NULL,
    [CourseId]             INT NULL,
    [FederalActivityId]    INT NULL,
    CONSTRAINT [PK_ScheduleCourseFederalActivities] PRIMARY KEY CLUSTERED ([SchedCourseFederalId] ASC),
    CONSTRAINT [FK_ScheduleCourseFederalActivity_FederalActivityType] FOREIGN KEY ([FederalActivityId]) REFERENCES [dbo].[FederalActivityType] ([FederalActivityId]),
    CONSTRAINT [FK_ScheduleCourseFederalActivity_ScheduleCourse] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[ScheduleCourse] ([CourseId])
);

