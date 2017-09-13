CREATE TABLE [dbo].[FedcapAcademyMapping] (
    [Id]        INT          IDENTITY (1, 1) NOT NULL,
    [username]  VARCHAR (80) NULL,
    [firstname] VARCHAR (80) NULL,
    [lastname]  VARCHAR (80) NULL,
    [ClientNo]  VARCHAR (50) NULL,
    [ClientId]  INT          NULL,
    [DateAdded] DATETIME     NULL
);

