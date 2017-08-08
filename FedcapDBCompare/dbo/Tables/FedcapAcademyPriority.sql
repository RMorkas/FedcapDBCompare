CREATE TABLE [dbo].[FedcapAcademyPriority] (
    [PriorityId]        INT IDENTITY (1, 1) NOT NULL,
    [EnrollmentId]      INT NULL,
    [FederalActivityId] INT NULL,
    [Priority]          INT NULL,
    [Hours]             INT NULL,
    CONSTRAINT [PK_FedcapAcademyPriorities] PRIMARY KEY CLUSTERED ([PriorityId] ASC),
    CONSTRAINT [FK_FedcapAcademyPriorities_FedcapAcademy] FOREIGN KEY ([EnrollmentId]) REFERENCES [dbo].[FedcapAcademy] ([EnrollmentId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The value will be 1,2,3,4 based on the oder which the user choose it', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FedcapAcademyPriority', @level2type = N'COLUMN', @level2name = N'Priority';

