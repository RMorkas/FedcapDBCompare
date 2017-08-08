CREATE TABLE [dbo].[UserCustomControl] (
    [UserCustomControlId] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]           INT          NULL,
    [ModuleId]            INT          NULL,
    [IsActive]            BIT          CONSTRAINT [DF_UserCustomControl_IsActive] DEFAULT ((1)) NULL,
    [LabelCustomControl]  VARCHAR (50) NULL,
    [UserCustomFiledName] VARCHAR (50) NULL,
    [ControlOrder]        INT          NULL,
    [IsRequired]          BIT          NULL,
    CONSTRAINT [PK_UserCustomControl] PRIMARY KEY CLUSTERED ([UserCustomControlId] ASC)
);

