CREATE TABLE [dbo].[ScheduleRoom] (
    [RoomId]    INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId] INT          NULL,
    [SiteId]    INT          NULL,
    [RoomNo]    INT          NULL,
    [RoomDesc]  VARCHAR (80) NULL,
    [RoomMax]   INT          NULL,
    [IsDeleted] BIT          CONSTRAINT [DF_ScheduleRoom_IsDeleted] DEFAULT ((0)) NULL,
    [CreatedBy] VARCHAR (80) NULL,
    [CreatedAt] DATETIME     NULL,
    [UpdatedBy] VARCHAR (80) NULL,
    [UpdatedAt] DATETIME     NULL,
    [IsDev]     BIT          NULL,
    [IsUAT]     BIT          NULL,
    [IsStaging] BIT          NULL,
    [IsProd]    BIT          NULL,
    CONSTRAINT [PK_ScheduleRoom] PRIMARY KEY CLUSTERED ([RoomId] ASC)
);

