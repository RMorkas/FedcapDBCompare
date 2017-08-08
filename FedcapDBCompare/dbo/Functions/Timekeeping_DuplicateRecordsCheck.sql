

CREATE FUNCTION [dbo].[Timekeeping_DuplicateRecordsCheck](
@dtsassignmentid nvarchar(11),
@Date datetime
)

RETURNS int
AS
BEGIN
	
declare @retval varchar(50),
       	@counttotal int

		Select @counttotal = count(te.id) from dbo.Crs_timekeeping_export te with (nolock) 
		where  te.Activitydate = @Date and te.dtsassignmentid = @dtsassignmentid  
		 and isnull(te.DeleteIndicator,'N') <> 'Y'  and te.Status = 'Updated' and not exists 
		(select au.id from dbo.Crs_timekeeping_export_audit au with (nolock) 
		where au.activityhours = te.activityhours and au.activitycodeid = te.activitycodeid 
		and au.dtsassignmentid = @dtsassignmentid  and isnull(au.DeleteIndicator,'N') <> 'Y'  
		and datediff(d,au.Activitydate, @Date) = 0  and au.Status IN ('Updated','rejected')) 

		If @counttotal > 0
			Return 1
		else
		begin
			Select @counttotal = count(au.id) from dbo.Crs_timekeeping_export_audit au with (nolock)  where 
			 au.Activitydate = @Date and au.dtsassignmentid = @dtsassignmentid  and  isnull(au.DeleteIndicator,'N') <> 'Y' 
			 and au.Status = 'Updated' 
			and not exists 
			(select te.id from dbo.Crs_timekeeping_export te  with (nolock)  where te.activityhours = au.activityhours and te.activitycodeid = au.activitycodeid and te.dtsassignmentid = @dtsassignmentid 
			and te.activitydate = @Date and  isnull(te.Deleteindicator,'N') <> 'Y'  and te.Status = 'Updated'  )  

			If @counttotal > 0
				Return 1
			else
				Return 0
		end

return 0
END

