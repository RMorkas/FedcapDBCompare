



CREATE view [dbo].[VW_CaseExemptionHistory]
AS
SELECT DISTINCT dbo.CaseClient.CaseId, Max(dbo.OFI_ExemptionHistory.ExemptionTypeId) AS ExemptionTypeId, Min(dbo.OFI_ExemptionHistory.StartDate) As StartDate, 
                        MAX(dbo.OFI_ExemptionHistory.EndDate) As EndDate
FROM            dbo.OFI_ExemptionHistory with(nolock) RIGHT OUTER JOIN
                         dbo.CaseClient with(nolock) ON dbo.OFI_ExemptionHistory.ClientId = dbo.CaseClient.ClientId
group by dbo.CaseClient.CaseId

