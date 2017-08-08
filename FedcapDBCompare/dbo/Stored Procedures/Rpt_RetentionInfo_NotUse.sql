
Create proc [dbo].[Rpt_RetentionInfo_NotUse]
@companyId int,
@DBName varchar(max),
@RetenationStatus int =null,
@Date smalldatetime =null,
@Where varchar(Max) =null
AS

Declare @SqlString varchar(Max) , @sqlCMDataTable varchar(Max) , @sqlHraCase varchar(Max), @SQL varchar(max)

Set dateformat mdy

Set @SQL = '''' + ' 
Declare @paramter varchar(50)
SET @paramter = ''''txtScan1''''

Select distinct ' + @DBName +'.dbo.cmconvertlist.CaseID , Cast(CONVERT(VARCHAR(20), ' + @DBName + '.dbo.CMData.Value,101) as smalldatetime) AS CMDateValue , ' + @DBName + '.dbo.cmconvertlist.DocType FROM ' + @DBName + '.dbo.cmconvertlist INNER JOIN ' + @DBName + '.dbo.CMData ON ' + @DBName + '.dbo.cmconvertlist.RecordID = ' + @DBName + '.dbo.CMData.RecordID 
WHERE        
(' + @DBName + '.dbo.CMData.FieldName = @paramter) 
AND  
(' + @DBName + '.dbo.cmconvertlist.Status in (3,15,16))
 AND  
(' + @DBName + '.dbo.cmconvertlist.DocType in (8716 , 8717 , 8718))  ' + ''''

Set @sqlCMDataTable = 
'Declare @CMDataTable Table
(
	[CaseID] [INT] NOT NULL,
	[CMDateValue] smalldatetime NULL,
	[DocType] [INT] NOT NULL
)

INSERT INTO @CMDataTable 
Select CaseID , CMDateValue , DocType
FROM  OPENQUERY(ALLSECTOR, ' + @SQL + ')'


Set @sqlHraCase = ' Declare @HRACases Table(
	[HRACaseID] [int],
	[HRACaseNumber] [varchar](10) NULL,
	[Suffix] [varchar](2) NULL,
	[LineNumber] [varchar](2) NULL,
	[CIN] [varchar](9) NULL,
	[CaseSurname] [varchar](50) NULL,
	[CaseFirstName] [varchar](50) NULL,
	[SSN] [varchar](9) NULL
) 

INSERT INTO @HRACases 
SELECT  HRACaseID , HRACaseNumber , Suffix , LineNumber , CIN , Rtrim(CaseSurname) AS CaseSurname , Rtrim(CaseFirstName) AS CaseFirstName , SSN FROM  OPENQUERY(ALLSECTOR, ' + '''' + 'Select  HRACaseID , HRACaseNumber , Suffix ,LineNumber, CIN , CaseSurname , CaseFirstName , SSN From ' + @DBName + '.dbo.HRACases' + '''' + ')

'

Set @SqlString = '
Declare @Status int
SET @Status = ' + CAST(@RetenationStatus as varchar(max)) + '

SELECT * FROM 
(
SELECT   distinct     dbo.PlacementEntry.PlacementEntryID, dbo.PlacementEntry.HRACaseID, HRACases_1.SSN, HRACases_1.HRACaseNumber, HRACases_1.Suffix, HRACases_1.LineNumber,HRACases_1.CIN,
                         HRACases_1.CaseSurname, HRACases_1.CaseFirstName, dbo.PlacementEntry.CellPhone, dbo.PlacementEntry.HomePhone, dbo.PlacementEntry.SiteId, 
                         dbo.Site.SiteName, dbo.PlacementEntry.EmployerId, dbo.Employer.FirstName AS EmployerName, dbo.Employer.IndustryId, dbo.Enumes.Item AS IndustryName, dbo.PlacementEntry.SectorId, 
                         EnumSector.Item AS SectorName, EnumTitle.Item As Title, 
						 isnull(dbo.PlacementEntry.SalaryRate , 0) AS SalaryRate,
						 CASE
						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 0 THEN ' + '''' + 'Hour' + '''' +
'						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 1 THEN ' + '''' + 'Bi-Weekly' + '''' +
'						 WHEN isnull(dbo.PlacementEntry.SalaryRate , 0) = 2 THEN ' + '''' + 'Annual' + '''' +
'						 Else ''''''''
						 End AS SalaryType, dbo.PlacementEntry.Salary,Isnull(dbo.PlacementEntry.SalaryPerHour , 0) AS SalaryPerHour,
						 dbo.PlacementEntry.PlacementTypeId, 
                         EnumType.Item AS PlacementTypeDesc, dbo.PlacementEntry.PlacementSourceId, EnumSource.Item AS PlacementSourceDesc, dbo.PlacementEntry.HoursPerWeek, 
                         dbo.PlacementEntry.JobStart, dbo.PlacementEntry.EndDate, 
                         dbo.PlacementEntry.EmpLocationId, EnumBilling.Item AS BillingType , 
						 CASE 
							WHEN @status = 3 THEN
								dbo.getMilsonDesc(@status,dbo.PlacementEntry.JobStart, dbo.PlacementEntry.EndDate,ISNULL(CMScanFile.DocType,0) , dbo.test.Milstone)  
							ELSE	
								dbo.getMilsonDesc(@status,dbo.PlacementEntry.JobStart,' + '''' + CONVERT(varchar(max),@Date,101) + '''' + ',ISNULL(CMScanFile.DocType,0) ,dbo.test.Milstone)  
							END
								AS Milestone ,
						 datediff(day,dbo.PlacementEntry.JobStart,ISNULL(dbo.PlacementEntry.EndDate, ' + '''' + CONVERT(varchar(max),@Date,101) + '''' + ')) AS DaysWork 

FROM            dbo.PlacementEntry INNER JOIN
                         @HRACases AS HRACases_1 ON dbo.PlacementEntry.HRACaseID = HRACases_1.HRACaseID INNER JOIN
                         dbo.Site ON dbo.PlacementEntry.SiteId = dbo.Site.SiteId INNER JOIN
                         dbo.Employer ON dbo.PlacementEntry.EmployerId = dbo.Employer.EmployerId INNER JOIN
                         dbo.Enumes ON dbo.Employer.IndustryId = dbo.Enumes.EnumId INNER JOIN
                         dbo.Enumes AS EnumSector ON dbo.PlacementEntry.SectorId = EnumSector.EnumId INNER JOIN
                         dbo.Enumes AS EnumType ON dbo.PlacementEntry.PlacementTypeId = EnumType.EnumId INNER JOIN
                         dbo.Enumes AS EnumSource ON dbo.PlacementEntry.PlacementSourceId = EnumSource.EnumId LEFT OUTER JOIN
						 dbo.Enumes AS EnumTitle ON dbo.PlacementEntry.TitleId = EnumTitle.EnumId INNER JOIN
						 dbo.Enumes AS EnumBilling ON dbo.PlacementEntry.BillingTypeId = EnumBilling.EnumId LEFT OUTER JOIN
						 @CMDataTable as CMScanFile ON dbo.PlacementEntry.HRACaseID = CMScanFile.CaseID Cross JOIN
						 dbo.test
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
) AS temp
WHERE temp.MileStone IS NOT NULL '

EXECUTE ( @sqlCMDataTable + @sqlHraCase  + ' ' + @SqlString )

--Print @sqlCMDataTable + @sqlHraCase  + ' ' + @SqlString




--exec Rpt_RetentionInfo 1 , 'Arborfedcap_RPT_R1' ,1 ,'10/14/2015',''

