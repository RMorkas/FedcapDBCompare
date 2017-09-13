CREATE TABLE [dbo].[ScheduleCourseMapping] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [CourseNo]       INT           NULL,
    [CourseName]     VARCHAR (500) NULL,
    [IsEDRE]         CHAR (10)     NULL,
    [IsVocED]        CHAR (10)     NULL,
    [IsSTOT]         CHAR (10)     NULL,
    [IsJSJR]         CHAR (10)     NULL,
    [IsJSDRE]        CHAR (10)     NULL,
    [EDREFederalId]  INT           NULL,
    [VocEDFederalId] INT           NULL,
    [STOTFederalId]  INT           NULL,
    [JSJRFederalId]  INT           NULL,
    [JSDREFederalId] INT           NULL,
    [IsCourseExist]  BIT           NULL,
    CONSTRAINT [PK_ScheduleCourseMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);

