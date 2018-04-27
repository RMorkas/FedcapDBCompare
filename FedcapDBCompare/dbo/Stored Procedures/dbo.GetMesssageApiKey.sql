create proc GetMesssageApiKey
@companyId int=null
AS
IF(ISNull(@companyId,0) > 0)
    Select ApiKey, ApiAuthorization from Fed_messageApikey with(nolock) where CompanyId = @companyId
ELSE
    Select ApiKey, ApiAuthorization from Fed_messageApikey with(nolock) where CompanyId IS NULL