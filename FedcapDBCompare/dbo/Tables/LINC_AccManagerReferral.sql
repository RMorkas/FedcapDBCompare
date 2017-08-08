CREATE TABLE [dbo].[LINC_AccManagerReferral] (
    [ReferralAccManagerId] INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]             INT           NULL,
    [AccountManagerID]     INT           NULL,
    [ReferralDateAM]       SMALLDATETIME NULL,
    [IsAttendedMeeting]    INT           NULL,
    [MeetingDate]          SMALLDATETIME NULL,
    [JobReadyId]           INT           NULL,
    [ActionTakenId]        INT           NULL,
    [ResultId]             INT           NULL,
    [Note]                 VARCHAR (300) NULL,
    [CreatedBy]            VARCHAR (80)  NULL,
    [CreatedAt]            DATETIME      NULL,
    [UpdatedBy]            VARCHAR (80)  NULL,
    [UpdatedAt]            DATETIME      NULL,
    CONSTRAINT [PK_LINC_AccManagerReferral] PRIMARY KEY CLUSTERED ([ReferralAccManagerId] ASC),
    CONSTRAINT [FK_LINC_AccManagerReferral_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId])
);

