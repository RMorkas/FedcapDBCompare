CREATE  procedure [dbo].[GenerateACFReport] (@startdate datetime, @enddate datetime)
as 
begin


--declare @startdate datetime
--declare @enddate datetime


--set @startdate = '08/01/2017'
--set @enddate = '08/31/2017'

select  distinct dbo.client.clientno as [Client ID], cast(year(@startdate) as varchar) + isnull(RIGHT('00' + cast(month(@Startdate) as varchar(2)),2),'00') as [Reporting Month],CaseNo, 
case when [dbo].[getTotalPayment](dbo.client.clientid,@startdate, @enddate) = 0 or  isnull([dbo].[ACF_GetAverageHours](1,dbo.client.clientid,@startdate,@enddate,'',2),0) + 
 isnull([dbo].[ACF_GetAverageHours](2,dbo.client.clientid,@startdate,@enddate,'',2),0) + 
 isnull([dbo].[ACF_GetAverageHours](3,dbo.client.clientid,@startdate,@enddate,'',2),0) = 0  then 2 else 1 end as [Employment Status],
case [dbo].[getTotalPayment](dbo.client.clientid,@startdate, @enddate) when 0 then '00' else isnull([dbo].[ACF_GetAverageHours](1,dbo.client.clientid,@startdate,@enddate,'',2),'00') end as [Unsubsidized Employment],
case [dbo].[getTotalPayment](dbo.client.clientid,@startdate, @enddate) when 0 then '00' else isnull([dbo].[ACF_GetAverageHours](2,dbo.client.clientid,@startdate,@enddate,'',2),'00') end  as [Subsidized Private Employment], 
case [dbo].[getTotalPayment](dbo.client.clientid,@startdate, @enddate) when 0 then '00' else isnull([dbo].[ACF_GetAverageHours](3,dbo.client.clientid,@startdate,@enddate,'',2),'00') end as  [Subsidized Public Employment],
isnull([dbo].[ACF_GetAverageHours](4,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as  [Work Expirience Hours of Participation],
isnull([dbo].[ACF_GetAverageHours](4,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') as  [Work Expirience Excused Absence Hours],
isnull([dbo].[ACF_GetAverageHours](4,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [[Work Expirience Holiday Hours],
isnull([dbo].[ACF_GetAverageHours](5,dbo.client.clientid,@startdate,@enddate,'',2),'00') as  [On the Job training Hours of Participation],
--Job Search and Job Readiness
isnull([dbo].[ACF_GetAverageHours](6,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as [Job Search and Job Readiness Hours of Participation], 
isnull([dbo].[ACF_GetAverageHours](6,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') as  [Job Search and Job Readiness Excused Absence Hours], 
isnull([dbo].[ACF_GetAverageHours](6,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [Job Search and Job Readiness Holiday Hours],
--Community Service
isnull([dbo].[ACF_GetAverageHours](7,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as [Community Service Hours of Participation], 
isnull([dbo].[ACF_GetAverageHours](7,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') as  [Community Service Excused Absence Hours], 
isnull([dbo].[ACF_GetAverageHours](7,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [Community Service Holiday Hours],
--Vocational Educational Training
isnull([dbo].[ACF_GetAverageHours](8,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as [Vocational Education Training Hours of Participation], 
isnull([dbo].[ACF_GetAverageHours](8,dbo.client.clientid,@startdate,@enddate,'excused',2),'00') as  [Vocational Education Training Excused Absence Hours], 
isnull([dbo].[ACF_GetAverageHours](8,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [Vocational Education Training Holiday Hours],
--Job Skills Training Employment Related
isnull([dbo].[ACF_GetAverageHours](9,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as [Job Skills Training Employment Related Hours of Participation], 
isnull([dbo].[ACF_GetAverageHours](9,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') as  [Job Skills Training Employment Related Excused Absence Hours], 
isnull([dbo].[ACF_GetAverageHours](9,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [Job Skills Training Employment Related Holiday Hours],
--Education Directly Related to Employment
isnull([dbo].[ACF_GetAverageHours](10,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as [Education Related to Employed No HS Diploma Hours of Participation], 
isnull([dbo].[ACF_GetAverageHours](10,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') as  [Education Related to Employed No HS Diploma Excused Absence Hours], 
isnull([dbo].[ACF_GetAverageHours](10,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [Education Related to Employed No HS Diploma Holiday Hours],
--Satisfactory Attendance at secondary school or GED course
isnull([dbo].[ACF_GetAverageHours](12,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as [Satisfactory School Attendance Hours of Participation], 
isnull([dbo].[ACF_GetAverageHours](12,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') as  [Satisfactory School Attendance Excused Absence Hours], 
isnull([dbo].[ACF_GetAverageHours](12,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [Satisfactory School Attendance Holiday Hours],
--Providing Child Care Services to Community Service Program Participant
isnull([dbo].[ACF_GetAverageHours](11,dbo.client.clientid,@startdate,@enddate,'attended',2),'00') as [Providing ChildCare Hours of Participation], 
isnull([dbo].[ACF_GetAverageHours](11,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') as  [Providing ChildCare Excused Absence Hours], 
isnull([dbo].[ACF_GetAverageHours](11,dbo.client.clientid,@startdate,@enddate,'holiday',2),'00') as  [Providing ChildCare Holiday Hours],
isnull([dbo].[ACF_GetAverageHours](20,dbo.client.clientid,@startdate,@enddate,'',2),'00') as  [Other Work Activities Hours of Participation], --need  to add calculations check 
case  when [case].CaseTypeId <3  then Right('00' + CAST(dbo.getFLSACreditHours([Case].CaseId,@enddate)  as varchar(2)),2) else '00' end  as  [Number of Deemed Hours for the Overall Rate],
case  when [case].CaseTypeId > 2  then Right('00' + CAST(dbo.getFLSACreditHours([Case].CaseId,@enddate)  as varchar(2)),2) else '00' end  as [Number of Deemed Hours for the Two-Parent Rate],
 
--Amount of Earned Income
case isnull([dbo].[ACF_GetAverageHours](1,dbo.client.clientid,@startdate,@enddate,'',2),0) + 
 isnull([dbo].[ACF_GetAverageHours](2,dbo.client.clientid,@startdate,@enddate,'',2),0) + 
 isnull([dbo].[ACF_GetAverageHours](3,dbo.client.clientid,@startdate,@enddate,'',2),0) when 0
then '00' else [dbo].[getTotalPayment](dbo.client.clientid,@startdate, @enddate) end as  [Amount of Earned Income]


from dbo.client with (nolock) 
inner join dbo.caseclient with (nolock) on client.clientid = [caseclient].clientId  and dbo.client.CompanyId = 8 

inner join [dbo].[Case] with (nolock) on dbo.caseclient.caseid= [dbo].[Case].CaseId --and dbo.Client.ActiveCaseId= [dbo].[Case].CaseId

inner join  [dbo].[VW_CaseExemptionHistory] on  [dbo].[VW_CaseExemptionHistory].CaseId = dbo.caseClient.caseid

inner join [dbo].[Historical_Referral] r with (nolock) on r.CaseId = [case].caseno and 
((datediff(d,r.OrientationDate,@enddate) >= 0  
or r.OrientationDate is null and datediff(d,r.ImportDate,@enddate) >= 0))

inner join [dbo].[CaseStatusHistory] with (nolock) on [dbo].[CaseStatusHistory].Caseid = [case].caseid and 
lower([dbo].[CaseStatusHistory].Status) = 'o' and datediff(d,[dbo].[CaseStatusHistory].Status_StartDate, @enddate) >= 0 
  and (datediff(d, @startdate, [dbo].[CaseStatusHistory].Status_endDate) >= 0 or [dbo].[CaseStatusHistory].Status_endDate is null)

--where 
--dbo.IsClientSanction( @enddate,dbo.[case].caseid) =0

--and ([VW_CaseExemptionHistory].StartDate is null or datediff(d,@enddate, [VW_CaseExemptionHistory].StartDate) > 0)  and 
--([VW_CaseExemptionHistory].endDate is null or  datediff(d,[VW_CaseExemptionHistory].endDate,@startdate) >0 )




--from dbo.client with (nolock) 
--inner join [dbo].[Case] on dbo.Client.ActiveCaseId= [dbo].[Case].CaseId
--where dbo.[case].caseid in (
--SELECT [dbo].[CaseStatushistory].[Caseid]
-- FROM [dbo].[CaseStatusHistory] where [dbo].[CaseStatusHistory].Status = 'O' and datediff(d,[dbo].[CaseStatusHistory].Status_StartDate, @enddate) >= 0 
--  and datediff(d, @startdate, isnull([dbo].[CaseStatusHistory].Status_endDate,'01/01/2020')) >= 0) 
-- and dbo.IsClientSanction( @enddate,dbo.[case].caseid) =0 
-- and datediff(d,@enddate, isnull(client.ExemptionEffectiveDate,'01/01/2020')) > 0 

end

