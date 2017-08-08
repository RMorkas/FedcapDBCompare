CREATE view [dbo].[vi_OFI_Interface_Sanction]
as
SELECT top 100 percent 
	  [OFI office]
      ,[clientNo]
      ,[caseNo]
   --   ,[non compliance type]
      ,convert(varchar(50), [Date],101)  as [Date of Non Compliance Event]
     ,'' + replace(replace(isnull([Details of Non Compliance],''),char(13),' '),char(10),' ') + '' as [Details of Non Compliance]
      --,[First Sanction]
      ,convert(varchar(50),[Verbal Contact Date Time],100) as [Verbal Contact Attempt Date/Time]
      ,convert(varchar(50),[Mail Contact Date Time],100) as [Mail Contact Attempt Date/Time]
      ,convert(varchar(50),[Home Visit Date Time],100) as [Home Visit Contact Attempt Date/Time]
      ,[Contact Established]
      , [Good cause claimed]
      ,''+ isnull([Good cause claimed text],'') + '' as [Good cause claimed text]
      ,[Good cause Type]
      ,'' + isnull([Good cause Denial Text],'') + '' as [Good cause Denial Text]
      ,isnull([Staff member Witness],'') as [Staff member Witness]
      ,isnull([BTC Staff member Phone],'') as [BTC Staff member Phone]
  FROM [dbo].[OFI_Interface_sanction_Audit]  where datediff(d,[dateadded], getdate()) = 0 
    and clientno not like '%test%'
order by clientno