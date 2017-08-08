CREATE proc InsertLogTran
@TableId int,
@PKFieldValue int,
@Sequence int,
@SavedBy varchar(50),
@SavedAt smalldatetime
AS
Insert Into [dbo].[Fed_LogTransaction] (TableId, PKFieldValue,[Sequence], SavedBy, SavedAt)
Values (@tableId, @PKFieldValue, @Sequence, @SavedBy, @SavedAt)