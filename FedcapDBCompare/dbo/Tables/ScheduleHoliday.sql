CREATE TABLE [dbo].[ScheduleHoliday] (
    [HolidayId]   INT           IDENTITY (1, 1) NOT NULL,
    [HolidayDate] SMALLDATETIME NULL,
    [HolidayName] VARCHAR (50)  NULL,
    [IsDeleted]   BIT           CONSTRAINT [DF_ScheduleHoliday_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]   VARCHAR (80)  NULL,
    [CreatedAt]   DATETIME      NULL,
    [UpdatedBy]   VARCHAR (80)  NULL,
    [UpdatedAt]   DATETIME      NULL,
    CONSTRAINT [PK_ScheduleHoliday] PRIMARY KEY CLUSTERED ([HolidayId] ASC)
);

