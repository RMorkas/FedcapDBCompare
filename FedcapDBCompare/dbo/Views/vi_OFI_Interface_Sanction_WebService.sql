CREATE view [dbo].[vi_OFI_Interface_Sanction_WebService]
as
SELECT top 100 percent 
	 [dbo].[OFI_Interface_sanction_Audit].scheduleid as Unique_ID, 
	  [OFI office]
      ,clientno as [Client_No]
    --   ,[non compliance type]
      ,format([Date],'yyyy-MM-dd')  as [Date of Non Compliance Event]
     ,'' + replace(replace(isnull([Details of Non Compliance],''),char(13),' '),char(10),' ') + '' as [Details of Non Compliance]
      --,[First Sanction]
      ,format([Verbal Contact Date Time],'yyyy-MM-ddTHH:mm:ss') as [Verbal Contact Attempt Date/Time]
      ,format([Mail Contact Date Time],'yyyy-MM-ddTHH:mm:ss') as [Mail Contact Attempt Date/Time]
      ,format([Home Visit Date Time],'yyyy-MM-ddTHH:mm:ss') as [Home Visit Contact Attempt Date/Time]
      ,case [Contact Established] when 'Yes' then 'Y' else 'N' end as [Contact Established] 

      , case [Good cause claimed] when 'Yes' then 'Y' else 'N' end as [Good cause claimed]
      ,''+ isnull([Good cause claimed text],'') + '' as [Good cause claimed text]
      ,[Good cause Type]
      ,'' + isnull([Good cause Denial Text],'') + '' as [Good cause Denial Text]
      ,isnull([Staff member Witness],'') as [Staff member Witness]
      ,isnull([BTC Staff member Phone],'') as [BTC Staff member Phone]
  FROM [dbo].[OFI_Interface_sanction_Audit]  where datediff(d,[dateadded], getdate()) < 5 
    and clientno not like '%test%'
order by clientno