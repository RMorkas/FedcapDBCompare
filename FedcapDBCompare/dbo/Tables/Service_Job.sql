CREATE TABLE [dbo].[Service_Job] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (150) NULL,
    [Type]        VARCHAR (10)  NULL,
    [FileName]    VARCHAR (50)  NULL,
    [CreateDate]  DATETIME      CONSTRAINT [DF_Service_Job_CreateDate] DEFAULT (getdate()) NULL,
    [Transferred] BIT           CONSTRAINT [DF_Service_Job_Transferred] DEFAULT ((0)) NULL,
    [Archived]    BIT           CONSTRAINT [DF_Service_Job_Archived] DEFAULT ((0)) NULL,
    [Processed]   BIT           CONSTRAINT [DF_Service_Job_Processed] DEFAULT ((0)) NULL,
    [FailRetry]   BIT           CONSTRAINT [DF_Service_Job_FailRetry] DEFAULT (NULL) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

