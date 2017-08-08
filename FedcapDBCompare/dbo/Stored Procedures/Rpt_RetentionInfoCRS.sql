
CREATE proc [dbo].[Rpt_RetentionInfoCRS]
@companyId int,
@DBName varchar(max),
@RetenationStatus int =null,
@Date smalldatetime =null,
@Where varchar(Max) =null
AS

Declare @SqlString varchar(Max)

Set dateformat mdy

Set @SqlString = '

Declare @Status int
SET @Status = ' + CAST(@RetenationStatus as varchar(max)) + '

SELECT temp.*, 
	CASE 
			WHEN temp.CompanyId = 9 Then --B2W
				CASE WHEN MilestonePeriod = 30 THEN dateadd(day, MilestonePeriod + 40 , JobStart )
					 ELSE dateadd(day, MilestonePeriod + 60 , JobStart )
				END
			ELSE
				CASE WHEN BillingType LIKE ''%offline%'' THEN dateadd(day, MilestonePeriod + 75 + 30 , JobStart )
					 ELSE dateadd(day, MilestonePeriod + 75 , JobStart )
				END
	END	AS ExpireDate,
	dbo.VW_HRACases.SSN, 
    dbo.VW_HRACases.HRACaseNumber, dbo.VW_HRACases.Suffix, dbo.VW_HRACases.LineNumber, dbo.VW_HRACases.CIN, dbo.VW_HRACases.CaseSurname, 
    dbo.VW_HRACases.CaseFirstName, dbo.VW_HRACases.IsPrivilegeRequired
FROM 
(
SELECT    distinct    dbo.PlacementEntry.PlacementEntryID, dbo.PlacementEntry.HRACaseID,  dbo.PlacementEntry.CellPhone, dbo.PlacementEntry.HomePhone, dbo.PlacementEntry.SiteId, dbo.Site.SiteName, 
                         dbo.PlacementEntry.EmployerId, dbo.Employer.FirstName AS EmployerName,  dbo.Enumes.Item AS IndustryName, 
                         dbo.PlacementEntry.SectorId, dbo.Sector.SetcorName, dbo.SectorTitle.Title, ISNULL(dbo.PlacementEntry.SalaryRate,0) AS SalaryRate, 
						 CASE
						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 0 THEN  ''Hour''
						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 1 THEN ''Bi-Weekly''
						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 2 THEN ''Annual''
						 Else ''''
						 End AS SalaryType, 
						 
						 ISNULL(dbo.PlacementEntry.Salary,0) AS Salary, 
                         ISNULL(dbo.PlacementEntry.SalaryPerHour,0) AS SalaryPerHour, dbo.PlacementEntry.PlacementTypeId, Enumes_1.Item AS PlacementTypeDesc, dbo.PlacementEntry.PlacementSourceId, 
                         Enumes_2.Item AS PlacementSourceDesc, dbo.PlacementEntry.HoursPerWeek, dbo.PlacementEntry.JobStart, dbo.PlacementEntry.EndDate, 
                         dbo.PlacementEntry.EmpLocationId, Enumes_3.Item AS BillingType,
						  
						 CASE 
							WHEN @status = 6 THEN
								dbo.getMilsonDesc(@status,dbo.PlacementEntry.JobStart, dbo.PlacementEntry.EndDate, dbo.PlacementPeriod.PeriodId, Enumes_3.Item)
							ELSE	
								dbo.getMilsonDesc(@status,dbo.PlacementPeriod.AvailabilityDate,ISNULL(dbo.PlacementEntry.EndDate,' + '''' + CONVERT(varchar(max),@Date,101) + '''' +			') ,dbo.PlacementPeriod.PeriodId, Enumes_3.Item)  
							END
								AS Milestone ,
						 datediff(day,dbo.PlacementEntry.JobStart,ISNULL(dbo.PlacementEntry.EndDate, ' + '''' + CONVERT(varchar(max),@Date,101) + '''' + ')) AS DaysWork ,
						 CASE 
							WHEN @Status = 6 THEN
								CASE 
									WHEN datediff(day,dbo.PlacementEntry.JobStart,dbo.PlacementEntry.EndDate) < 30 THEN 30
									WHEN datediff(day,dbo.PlacementEntry.JobStart,dbo.PlacementEntry.EndDate) < 90 THEN 90
									WHEN datediff(day,dbo.PlacementEntry.JobStart,dbo.PlacementEntry.EndDate) < 180 THEN 180
									ELSE 0
								END
							ELSE Enumes_4.Item 
						END AS MilestonePeriod, 
						CASE 
							WHEN @Status = 1 THEN 0
							ELSE ISNULL(RetentionStatusId,0)
						END AS RetentionStatusId, dbo.getSubmitComment(PlacementEntry.PlacementEntryID,RetentionId,RetentionStatusId,@Status) AS SubmitComment,
						CASE 
							WHEN @status = 2 THEN dbo.getTempComment(PlacementEntry.PlacementEntryID,RetentionId,RetentionStatusId,@Status)
							ELSE NULL 
						END	AS YourComment,
						CASE 
							WHEN @Status = 6 THEN 0
							ELSE dbo.PlacementPeriod.PeriodId
						END AS RetentionId, dbo.PlacementPeriod.PlacementPeriodId,
						dbo.getSavedBy(PlacementEntry.PlacementEntryID,RetentionId,RetentionStatusId,@Status) AS SaveBy, 
						dbo.getSavedAt(PlacementEntry.PlacementEntryID,RetentionId,RetentionStatusId,@Status) AS SaveAt,
						dbo.PlacementPeriod.AvailabilityDate,
						dbo.[User].FirstName + '' '' + dbo.[User].LastName as RetentionName,dbo.PlacementEntry.CompanyId,
						LeadUsers.FirstName + '' '' + LeadUsers.LastName AS LeadUserName,
						custStatus.Item AS CustomerStatus
FROM            dbo.PlacementEntry with(nolock) INNER JOIN
                         dbo.PlacementPeriod with(nolock) ON dbo.PlacementEntry.PlacementEntryID = dbo.PlacementPeriod.PlacementEntryID INNER JOIN
                         dbo.Site ON dbo.PlacementEntry.SiteId = dbo.Site.SiteId INNER JOIN
                         dbo.Employer with(nolock) ON dbo.PlacementEntry.EmployerId = dbo.Employer.EmployerId INNER JOIN
                         dbo.Enumes ON dbo.Employer.IndustryId = dbo.Enumes.EnumId INNER JOIN
                         dbo.Sector ON dbo.PlacementEntry.SectorId = dbo.Sector.SectorId INNER JOIN
                         dbo.Enumes AS Enumes_1 ON dbo.PlacementEntry.PlacementTypeId = Enumes_1.EnumId INNER JOIN
                         dbo.Enumes AS Enumes_2 ON dbo.PlacementEntry.PlacementSourceId = Enumes_2.EnumId INNER JOIN
                         dbo.Enumes AS Enumes_3 ON dbo.PlacementEntry.BillingTypeId = Enumes_3.EnumId INNER JOIN
                         dbo.SectorTitle ON dbo.PlacementEntry.TitleId = dbo.SectorTitle.SectorTitleId LEFT OUTER JOIN
                         dbo.PlacementRetention with(nolock) ON dbo.PlacementPeriod.PlacementPeriodId = dbo.PlacementRetention.PlacementPeriodId INNER JOIN
                         dbo.Enumes AS Enumes_4 ON dbo.PlacementPeriod.PeriodId = Enumes_4.EnumId Left outer Join
						 dbo.[User] ON dbo.PlacementEntry.[RetentionSpecialistId] = dbo.[User].UserID Left outer JOIN
                         dbo.[User] AS LeadUsers ON dbo.PlacementEntry.PlacementLeadUserId = LeadUsers.UserID LEFT OUTER JOIN
						 dbo.Enumes AS custStatus with(nolock) ON dbo.PlacementEntry.CustomerStatusId = custStatus.EnumId
WHERE
dbo.PlacementEntry.CompanyId = ' + Cast(@companyId as varchar(max)) + 
' 
AND 
IsNull(dbo.PlacementEntry.[IsDeleted],0) = 0 

'
+ 
@Where  
+
'
) AS temp INNER JOIN

dbo.VW_HRACases ON temp.HRACaseID = dbo.VW_HRACases.HRACaseID AND temp.CompanyId = dbo.VW_HRACases.CompanyId 

WHERE temp.MileStone IS NOT NULL 

order by ExpireDate Desc '

execute (@SqlString)