CREATE ROLE [ObjectExecute]
    AUTHORIZATION [dbo];


GO
EXECUTE sp_addrolemember @rolename = N'ObjectExecute', @membername = N'FedCapCMDbUser';

