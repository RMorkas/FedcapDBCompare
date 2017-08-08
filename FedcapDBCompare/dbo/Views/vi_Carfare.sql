CREATE VIEW [dbo].[vi_Carfare]
AS
SELECT   2 as companyid,   'FEDCAP R2' as Vendor_name,  HRACases.HRACaseID, Ltrim(RTRim(HRACases.CaseSurname))  + ', ' +  HRACases.CaseFirstName as CaseName, HRACases.Cin, HRACases.SSN, HRACases.HraCaseNumber + '-' +  
                         HRACases.Suffix + '-' + HRACases.LineNumber  as CaseNumber, CarfareStatus.IssueDate, 
                            CASE WHEN DollarAmt < 31 THEN 'Daily' WHEN DollarAmt < 112 THEN 'Weekly' WHEN DollarAmt >= 112 THEN 'Monthly' ELSE '' END AS TypeOfCard, 
                         CarfareAmts.Trips AS NumberOfTripsTakenDuringReportingPeriod, CarfareAmts.DollarAmt AS 'AmountToBeReimbursed', 
                       --  CASE WHEN locationDesc = 'Sunset Terrace' THEN 'NYCSS' WHEN LocationDesc LIKE '%NSLIJ%' THEN 'Rego Park' WHEN LocationDesc LIKE '%ELM%' THEN '25 Elm Place'
                       --   WHEN LocationDesc LIKE '%Montague%' THEN '200 Montague' ELSE WeCARELocations.LocationDesc END AS Site, 
					   ltrim(rtrim(wecarelocations.combineddescription)) as Site, 
                        CarfareIssuanceReasons.Description, CarfareStatus.Tracknumber, Cmcaseforms.LastSavedBy, cmcaseforms.LastSavedWhen,CarfareIssuanceReasons.id as apptid
FROM            ALLSECTOR.Arborfedcap_rpt.dbo.CarfareStatus carfarestatus INNER JOIN
                         ALLSECTOR.Arborfedcap_rpt.dbo.CarfareAmts carfareamts ON carfareamts.ID = carfarestatus.AmtCode INNER JOIN
                         ALLSECTOR.Arborfedcap_rpt.dbo.CarfareIssuanceReasons CarfareIssuanceReasons ON CarfareIssuanceReasons.ID = carfarestatus.ReasonCode INNER JOIN
                         ALLSECTOR.Arborfedcap_rpt.dbo.WeCARELocations WeCARELocations ON WeCARELocations.LocationCode = carfarestatus.Location INNER JOIN
                         ALLSECTOR.Arborfedcap_rpt.dbo.HRACases hracases ON hracases.HRACaseID = carfarestatus.HRACaseID
						 inner join ALLSECTOR.Arborfedcap_rpt.dbo.cmcaseforms cmcaseforms on cmcaseforms.tracknumber=  carfarestatus.tracknumber 
WHERE        (carfarestatus.Signed = 1) -- and IssueDate between '3/1/2016' and '3/31/2016' 
--union
--SELECT    1 as companyid,  'FEDCAP R1' as Vendor_name,  HRACases.HRACaseID, Ltrim(RTRim(HRACases.CaseSurname))  + ', ' +  HRACases.CaseFirstName as CaseName, HRACases.Cin, HRACases.SSN, HRACases.HraCaseNumber + '-' +  
--                         HRACases.Suffix + '-' + HRACases.LineNumber  as CaseNumber, CarfareStatus.IssueDate, 
--                            CASE WHEN DollarAmt < 31 THEN 'Daily' WHEN DollarAmt < 112 THEN 'Weekly' WHEN DollarAmt >= 112 THEN 'Monthly' ELSE '' END AS TypeOfCard, 
--                         CarfareAmts.Trips AS NumberOfTripsTakenDuringReportingPeriod, CarfareAmts.DollarAmt AS 'AmountToBeReimbursed', 
--                       --  CASE WHEN locationDesc = 'Sunset Terrace' THEN 'NYCSS' WHEN LocationDesc LIKE '%NSLIJ%' THEN 'Rego Park' WHEN LocationDesc LIKE '%ELM%' THEN '25 Elm Place'
--                       --   WHEN LocationDesc LIKE '%Montague%' THEN '200 Montague' ELSE WeCARELocations.LocationDesc END AS Site, 
--					   ltrim(rtrim(wecarelocations.combineddescription)) as Site, 
--                        CarfareIssuanceReasons.Description, CarfareStatus.Tracknumber, Cmcaseforms.LastSavedBy, cmcaseforms.LastSavedWhen,CarfareIssuanceReasons.id as apptid
--FROM            ALLSECTOR.Arborfedcap_rpt_r1.dbo.CarfareStatus carfarestatus INNER JOIN
--                         ALLSECTOR.Arborfedcap_rpt_r1.dbo.CarfareAmts carfareamts ON carfareamts.ID = carfarestatus.AmtCode INNER JOIN
--                         ALLSECTOR.Arborfedcap_rpt_r1.dbo.CarfareIssuanceReasons CarfareIssuanceReasons ON CarfareIssuanceReasons.ID = carfarestatus.ReasonCode INNER JOIN
--                         ALLSECTOR.Arborfedcap_rpt_r1.dbo.WeCARELocations WeCARELocations ON WeCARELocations.LocationCode = carfarestatus.Location INNER JOIN
--                         ALLSECTOR.Arborfedcap_rpt_r1.dbo.HRACases hracases ON hracases.HRACaseID = carfarestatus.HRACaseID
--						 inner join ALLSECTOR.Arborfedcap_rpt_r1.dbo.cmcaseforms cmcaseforms on cmcaseforms.tracknumber=  carfarestatus.tracknumber 
--WHERE        (carfarestatus.Signed = 1) -- and IssueDate between '3/1/2016' and '3/31/2016' 


