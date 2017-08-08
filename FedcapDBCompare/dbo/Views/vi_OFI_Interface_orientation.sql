CREATE view [dbo].[vi_OFI_Interface_orientation]
as
SELECT distinct top 100 percent
	  [OFI_Office]
      ,isnull([ClientNo],'') as [Client Identifier]
      ,isnull([CaseNo],'') as [Case Identifier]
      ,convert(varchar(50),[Date]) as [Scheduled Orientation Date/Time]
      ,[Orientation_Attended]
      ,case cast([New_Orientation_Date] as varchar(50)) when 'Jan  1 1900 12:00AM' then '' else  convert(varchar(50), [New_Orientation_Date]) end
	  as [New_Orientation_Date], good_cause_notes as [Good Cause Notes]
  
  FROM [dbo].[OFI_Interface_Orientation_Audit] with (Nolock)  where datediff(d,dateadded, getdate()) = 0 
    and clientno not like '%test%'   order by [Client Identifier]