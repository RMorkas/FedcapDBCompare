CREATE TABLE [dbo].[FedcapAcademy_Import] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [ImportDate]       SMALLDATETIME NULL,
    [CompanyId]        INT           NULL,
    [FAClientId]       VARCHAR (80)  NULL,
    [ClientId]         INT           NULL,
    [CertificationId]  VARCHAR (100) NULL,
    [PathwayId]        INT           NULL,
    [FACourseId]       VARCHAR (80)  NULL,
    [FACourseName]     VARCHAR (300) NULL,
    [CourseId]         INT           NULL,
    [CourseName]       VARCHAR (300) NULL,
    [ActivityId]       VARCHAR (50)  NULL,
    [RecordType]       VARCHAR (10)  NULL,
    [ActivityDate]     DATETIME      NOT NULL,
    [TimeSpent]        TIME (7)      NOT NULL,
    [FirstAccess]      DATETIME      NULL,
    [LastAccess]       DATETIME      NULL,
    [CompletionStatus] VARCHAR (20)  NULL,
    [CompletionDate]   DATETIME      NULL,
    [Score]            INT           NULL,
    [IsProcessed]      BIT           NULL,
    [ProcessedDate]    SMALLDATETIME NULL,
    [HomeWorkHours]    INT           NULL,
    [RejectedHours]    INT           NULL,
    [RejectedReason]   VARCHAR (300) NULL,
    [FirstName]        VARCHAR (50)  NULL,
    [LastName]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_FedcapAcademy_Import] PRIMARY KEY CLUSTERED ([Id] ASC)
);



