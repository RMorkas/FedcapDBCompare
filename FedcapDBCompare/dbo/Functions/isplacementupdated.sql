  create function dbo.isplacementupdated (@placementid int, @clientid int) returns int
  as
  begin
  declare @found int
  set @found = 0

  select @found = p.PlacementEntryID from 
  dbo.clientcontact existingnote 
inner join dbo.PlacementEntry p  on p.PlacementEntryID = existingnote.logtableid
  and p.PlacementEntryID = @placementid
and  existingnote.ClientId = @clientid and existingnote.Title in ('New Placement','Updated Placement') 

   return @found

  end 