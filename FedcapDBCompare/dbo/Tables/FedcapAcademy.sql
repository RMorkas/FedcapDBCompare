CREATE TABLE [dbo].[FedcapAcademy] (
    [EnrollmentId]          INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]             INT           NULL,
    [ClientId]              INT           NULL,
    [StartDate]             SMALLDATETIME NULL,
    [EndDate]               SMALLDATETIME NULL,
    [EnrollmentEndDate]     SMALLDATETIME NULL,
    [ClientUserName]        VARCHAR (50)  NULL,
    [TotalHours]            INT           NULL,
    [EnrollNote]            VARCHAR (MAX) NULL,
    [IsDeleted]             BIT           CONSTRAINT [DF_FedcapAcademy_IsDeleted] DEFAULT ((0)) NULL,
    [IsLocked]              BIT           CONSTRAINT [DF_FedcapAcademy_IsLocked] DEFAULT ((0)) NULL,
    [IsSentToFedcapAcademy] BIT           CONSTRAINT [DF_FedcapAcademy_IsSentToFedcapAcademy] DEFAULT ((0)) NULL,
    [CreatedBy]             VARCHAR (80)  NULL,
    [CreatedAt]             DATETIME      NULL,
    [UpdatedBy]             VARCHAR (80)  NULL,
    [UpdatedAt]             DATETIME      NULL,
    CONSTRAINT [PK_FedcapAcademy] PRIMARY KEY CLUSTERED ([EnrollmentId] ASC)
);

