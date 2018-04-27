CREATE TABLE [dbo].[FederalActivityType] (
    [FederalActivityId]       INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT          NULL,
    [FederalActivityName]     VARCHAR (80) NULL,
    [ActivityCode]            VARCHAR (6)  NULL,
    [Abbreviation]            VARCHAR (20) NULL,
    [IsFedcapAcademy]         BIT          CONSTRAINT [DF_FederalActivityType_IsFedcapAcademy] DEFAULT ((0)) NULL,
    [FederalActivityPriority] INT          NULL,
    [IsHomeWorkHours]         BIT          NULL,
    [IsDev]                   BIT          NULL,
    [IsUAT]                   BIT          NULL,
    [IsStaging]               BIT          NULL,
    [IsProd]                  BIT          NULL,
    CONSTRAINT [PK_FederalActivityType] PRIMARY KEY CLUSTERED ([FederalActivityId] ASC)
);

