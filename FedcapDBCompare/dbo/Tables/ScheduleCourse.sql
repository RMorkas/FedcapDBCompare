CREATE TABLE [dbo].[ScheduleCourse] (
    [CourseId]   INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]  INT           NULL,
    [IsActive]   BIT           CONSTRAINT [DF_ScheduleCourse_IsActive] DEFAULT ((1)) NULL,
    [CourseNo]   INT           NOT NULL,
    [CourseName] VARCHAR (200) NULL,
    [EventId]    INT           NULL,
    [IsDeleted]  BIT           CONSTRAINT [DF_ScheduleCourse_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]  VARCHAR (80)  NULL,
    [CreatedAt]  DATETIME      NULL,
    [UpdatedBy]  VARCHAR (80)  NULL,
    [UpdatedAt]  DATETIME      NULL,
    CONSTRAINT [PK_ScheduleCourse_1] PRIMARY KEY CLUSTERED ([CourseId] ASC)
);

