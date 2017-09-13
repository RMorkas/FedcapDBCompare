CREATE  procedure [dbo].[Imaging_transactionFile] (@ClientId int)
as 
begin

select top 1 
  (select top 1 hracasenumber from Historical_B2WReferral where dtsclientid = client.clientno order by importdate desc) as Case_Number, cast([case].suffix as varchar(2)) as Suffix,
cast([case].[LineNumber] as varchar(2)) as Line_Number, client.CIN , client.caselastname as LAST_NAME,client.CaseFirstName as FIRST_NAME,left(client.CaseMiddleName,1) as MID_NAME,  isnull(client.SSN,'') as SSN,
 (select top 1 LocalOfficeCode from Historical_B2WReferral where dtsclientid = client.clientno order by importdate desc)  as SITE_ID,
  case dbo.client.genderid when 591 then 'M' when 592 then 'F' else 'U' end  as SEX,
 convert(varchar(30), client.dob,101) as DOB
from dbo.client 
inner join caseclient on caseclient.clientid = client.clientid 
 and dbo.client.clientid =@clientid
 and dbo.client.companyid = 9 
inner join [case] on [case].caseid = caseclient.caseid 



 end