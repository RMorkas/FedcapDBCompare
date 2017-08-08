Create Procedure [dbo].[Crs_Timekeeping_Rejection_Report]
as	
begin
	select 'Total Rejections: ' + cast(count(id) as varchar(20))  FROM [dbo].[CrS_Timekeeping_rejection] where datediff(d,getdate(),datetimestamp) = 0 
	
	Select count(*) as [Count], ErrorDescription as [Error Description] FROM [dbo].[CrS_Timekeeping_rejection] where datediff(d,getdate(),datetimestamp) = 0 
	group by ErrorDescription
end
