CREATE TABLE [dbo].[User] (
    [UserID]                INT           IDENTITY (1, 1) NOT NULL,
    [GroupId]               INT           NULL,
    [UserName]              VARCHAR (50)  NULL,
    [FirstName]             VARCHAR (50)  NULL,
    [MiddleInitial]         VARCHAR (50)  NULL,
    [LastName]              VARCHAR (50)  NULL,
    [HomePhone]             VARCHAR (50)  NULL,
    [CellPhone]             VARCHAR (50)  NULL,
    [EMail]                 VARCHAR (100) NULL,
    [Address]               VARCHAR (100) NULL,
    [City]                  VARCHAR (50)  NULL,
    [State]                 VARCHAR (50)  NULL,
    [ZipCode]               INT           NULL,
    [JobTitle]              VARCHAR (100) NULL,
    [Department]            VARCHAR (50)  NULL,
    [LastAccessDate]        DATETIME      NULL,
    [IsActive]              BIT           NULL,
    [SecurityLevel]         INT           NULL,
    [SiteId]                INT           NULL,
    [IsJobLead]             BIT           NULL,
    [IsCaseManager]         BIT           NULL,
    [IsWEPSpecialist]       BIT           NULL,
    [IsRetentionSpecialist] BIT           NULL,
    [IsAccountManager]      BIT           NULL,
    [workphone]             VARCHAR (50)  NULL,
    [IsUserCustom1]         BIT           CONSTRAINT [DF_User_IsUserCustom1] DEFAULT ((0)) NULL,
    [IsUserCustom2]         BIT           CONSTRAINT [DF_User_IsUserCustom2] DEFAULT ((0)) NULL,
    [IsUserCustom3]         BIT           CONSTRAINT [DF_User_IsUserCustom3] DEFAULT ((0)) NULL,
    [IsUserCustom4]         BIT           CONSTRAINT [DF_User_IsUserCustom4] DEFAULT ((0)) NULL,
    [IsUserCustom5]         BIT           CONSTRAINT [DF_User_IsUserCustom5] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO
-- Trigger to add events to users when added to the user table
CREATE TRIGGER [dbo].[UpdateScheduleEventUser] ON [dbo].[User]
AFTER INSERT
AS
     DECLARE @userId INT
	DECLARE @GroupId INT
	DECLARE @companyId INT

     SELECT @userId = UserID, @GroupId = GroupId FROM inserted
	SELECT @companyId=CompanyId FROM [dbo].[Group] where GroupId=@GroupId

     INSERT INTO ScheduleEventUser (UserId,EventId)
            SELECT u.UserID, s.EventId
            FROM [User] u, ScheduleEvent s
            WHERE u.UserID = @userId AND (s.CompanyId = @companyId) AND (s.IsDeleted = 0) AND (s.IsActive = 1) AND (s.SiteId IS NULL)
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'null OR 0 is general user, 1 Superuser', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'User', @level2type = N'COLUMN', @level2name = N'SecurityLevel';

