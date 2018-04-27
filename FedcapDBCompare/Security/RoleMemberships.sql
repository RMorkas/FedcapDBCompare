EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'FEDCAP\VKhandelwal';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'FEDCAP\SAshrit';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'FEDCAP\Rmorkas';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'FEDCAP\sbraksmajer';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'FEDCAP\IYeliseyev';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'FedCapCMDbUser';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'FEDCAP\sbraksmajer';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'FEDCAP\IYeliseyev';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'FedCapCMDbUser';

