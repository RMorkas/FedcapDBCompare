CREATE TABLE [dbo].[HRAActionCodes] (
    [case number]     VARCHAR (10) NULL,
    [suffix]          VARCHAR (2)  NULL,
    [line]            VARCHAR (2)  NULL,
    [appreg]          VARCHAR (10) NULL,
    [cin]             VARCHAR (8)  NULL,
    [action date]     DATETIME     NULL,
    [action code]     VARCHAR (4)  NULL,
    [sequence number] VARCHAR (2)  NULL,
    [create date]     DATETIME     NULL,
    [fad date]        DATETIME     NULL,
    [program status]  VARCHAR (5)  NULL,
    [site code]       VARCHAR (5)  NULL,
    [JBCD]            VARCHAR (2)  NULL,
    [completion code] VARCHAR (4)  NULL,
    [completion date] DATETIME     NULL,
    [App Time]        CHAR (6)     NULL,
    [local office]    VARCHAR (3)  NULL,
    [local worker]    VARCHAR (5)  NULL,
    [fad worker]      VARCHAR (5)  NULL,
    [wms office]      VARCHAR (3)  NULL,
    [AH]              VARCHAR (1)  NULL,
    [wms worker]      VARCHAR (5)  NULL,
    [ssn]             VARCHAR (9)  NULL,
    [User ID]         CHAR (6)     NULL,
    [es code]         VARCHAR (2)  NULL,
    [wms reason]      VARCHAR (3)  NULL,
    [N]               INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_HRAActionCodes] PRIMARY KEY CLUSTERED ([N] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_actionC]
    ON [dbo].[HRAActionCodes]([action code] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_actionD]
    ON [dbo].[HRAActionCodes]([action date] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_case_comb]
    ON [dbo].[HRAActionCodes]([case number] ASC, [suffix] ASC, [line] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_CIN]
    ON [dbo].[HRAActionCodes]([cin] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_complC]
    ON [dbo].[HRAActionCodes]([completion code] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_complD]
    ON [dbo].[HRAActionCodes]([completion date] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_fad]
    ON [dbo].[HRAActionCodes]([fad date] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_local_office]
    ON [dbo].[HRAActionCodes]([local office] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_SiteCode]
    ON [dbo].[HRAActionCodes]([site code] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_ssn]
    ON [dbo].[HRAActionCodes]([ssn] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_activity_FAD_Worker]
    ON [dbo].[HRAActionCodes]([fad worker] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_activity_test_User_ID]
    ON [dbo].[HRAActionCodes]([User ID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_ssn_actiondate_actioncode_sitecode]
    ON [dbo].[HRAActionCodes]([ssn] ASC, [action date] ASC, [action code] ASC, [site code] ASC);

