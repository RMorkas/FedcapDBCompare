CREATE TABLE [dbo].[ScheduleInstructor] (
    [InstructorId] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]    INT          NULL,
    [SiteId]       INT          NULL,
    [FirstName]    VARCHAR (50) NULL,
    [LastName]     VARCHAR (50) NULL,
    [CellPhone]    VARCHAR (15) NULL,
    [HomePhone]    VARCHAR (15) NULL,
    [Email]        VARCHAR (50) NULL,
    [IsDev]        BIT          NULL,
    [IsUAT]        BIT          NULL,
    [IsStaging]    BIT          NULL,
    [IsProd]       BIT          NULL,
    CONSTRAINT [PK_ScheduleInstructor] PRIMARY KEY CLUSTERED ([InstructorId] ASC)
);

