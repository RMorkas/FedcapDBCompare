CREATE TABLE [dbo].[ScheduleCategory] (
    [CategoryId]   INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]    INT           NULL,
    [CategoryName] VARCHAR (100) NULL,
    [IsDeleted]    BIT           CONSTRAINT [DF_ScheduleCategory_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]    VARCHAR (80)  NULL,
    [CreatedAt]    DATETIME      NULL,
    [UpdatedBy]    VARCHAR (80)  NULL,
    [UpdatedAt]    DATETIME      NULL,
    CONSTRAINT [PK_ScheduleCategory] PRIMARY KEY CLUSTERED ([CategoryId] ASC)
);

