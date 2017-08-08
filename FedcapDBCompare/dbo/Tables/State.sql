CREATE TABLE [dbo].[State] (
    [StateCode] VARCHAR (3)  NOT NULL,
    [StateName] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED ([StateCode] ASC)
);

