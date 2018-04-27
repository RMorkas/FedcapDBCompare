CREATE TABLE [dbo].[ScheduleType] (
    [TypeId]     INT           IDENTITY (1, 1) NOT NULL,
    [CategoryId] INT           NULL,
    [TypeName]   VARCHAR (100) NULL,
    [IsDeleted]  BIT           CONSTRAINT [DF_ScheduleType_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy]  VARCHAR (80)  NULL,
    [CreatedAt]  DATETIME      NULL,
    [UpdatedBy]  VARCHAR (80)  NULL,
    [UpdatedAt]  DATETIME      NULL,
    [IsDev]      BIT           NULL,
    [IsUAT]      BIT           NULL,
    [IsStaging]  BIT           NULL,
    [IsProd]     BIT           NULL,
    CONSTRAINT [PK_ScheduleType] PRIMARY KEY CLUSTERED ([TypeId] ASC),
    CONSTRAINT [FK_ScheduleType_ScheduleCategory] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[ScheduleCategory] ([CategoryId])
);

