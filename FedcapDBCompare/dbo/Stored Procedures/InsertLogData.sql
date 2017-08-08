CREATE PROC [dbo].[InsertLogData]
@TranSavedId Int,
@ChildTableName varchar(80),
@ChildPKValue int,
@FieldName varchar(80),
@OldValue nvarchar(max),
@NewValue nvarchar(max),
@SavedBy varchar(80)
AS
INSERT INTO [dbo].[Fed_LogTransactionData] Values(@TranSavedId,@ChildTableName,@ChildPKValue, @FieldName, @OldValue, @NewValue, @SavedBy, GETDATE())
