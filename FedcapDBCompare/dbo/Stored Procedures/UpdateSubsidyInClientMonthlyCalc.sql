CREATE Proc [dbo].[UpdateSubsidyInClientMonthlyCalc]
as

declare change_cursor cursor for
select [ClientMonthlyCalcId]
      --,[MonthDate]
      --,cmc.[CaseClientId]
      --,cmc.[FoodStampSubsidy]
      --,cmc.[TANSubsidy]
	  --,c.CaseId
      ,c.[FoodStampSubsidy]
      ,c.[TANSubsidy]
  FROM [dbo].[ClientMonthlyCalc] cmc
  left join [dbo].[CaseClient] cc on cc.CaseClientId = cmc.CaseClientId
  left join [dbo].[Case] c on c.CaseId = cc.CaseId
  where MonthDate > getdate() and (isnull(c.FoodStampSubsidy, 0) <> isnull(cmc.FoodStampSubsidy, 0) or isnull(c.TANSubsidy, 0) <> isnull(cmc.TANSubsidy, 0))

declare @newFoodStampSubsidy decimal, @newTANFSubsidy decimal
declare @calcId int

open change_cursor;

fetch next from change_cursor
into @calcId, @newFoodStampSubsidy, @newTANFSubsidy;

while @@FETCH_STATUS = 0
begin
   update [dbo].[ClientMonthlyCalc]
   set FoodStampSubsidy = isnull(@newFoodStampSubsidy, 0), TANSubsidy = isnull(@newTANFSubsidy, 0)
   where ClientMonthlyCalcId = @calcId

   fetch next from change_cursor
   into @calcId, @newFoodStampSubsidy, @newTANFSubsidy;
end

close change_cursor;
deallocate change_cursor;


