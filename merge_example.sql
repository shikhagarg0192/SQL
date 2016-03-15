if object_id('BookInventory','U') is not null
drop table BookInventory
CREATE TABLE BookInventory  -- target
(
  TitleID INT NOT NULL PRIMARY KEY,
  Title NVARCHAR(100) NOT NULL,
  Quantity INT NOT NULL
    CONSTRAINT Quantity_Default_1 DEFAULT 0
)

IF OBJECT_ID ('BookOrder', 'U') IS NOT NULL
DROP TABLE dbo.BookOrder;
 
CREATE TABLE dbo.BookOrder  -- source
(
  TitleID INT NOT NULL PRIMARY KEY,
  Title NVARCHAR(100) NOT NULL,
  Quantity INT NOT NULL
    CONSTRAINT Quantity_Default_2 DEFAULT 0
);

INSERT BookInventory VALUES
  (1, 'The Catcher in the Rye', 6),
  (2, 'Pride and Prejudice', 3),
  (3, 'The Great Gatsby', 0),
  (5, 'Jane Eyre', 0),
  (6, 'Catch 22', 0),
  (8, 'Slaughterhouse Five', 4);
INSERT BookOrder VALUES
  (1, 'The Catcher in the Rye', 3),
  (3, 'The Great Gatsby', 0),
  (4, 'Gone with the Wind', 4),
  (5, 'Jane Eyre', 5),
  (7, 'Age of Innocence', 8);
  
select * from BookInventory;

declare @mergeoutput table
(actiontype nvarchar(10),
deltitleid int,
institleid int,
deltitle NVARCHAR(100),
institle NVARCHAR(100),
delqty int,
insqty int);

  
merge BookInventory bi
using BookOrder bo
on bi.titleid = bo.titleid
when matched and (bi.quantity + bo.quantity=0)
then delete
when matched then
	update 
		set bi.quantity = bi.quantity + bo.quantity
when not matched by target then
	insert (titleid, title, quantity)
	values ( bo.titleid, bo.title, bo.quantity)
when not matched by source and
	bi.quantity=0 then
	delete
output
$action,
Deleted.titleid,
inserted.titleid,
Deleted.title,
inserted.title,
Deleted.quantity,
inserted.quantity
into @mergeoutput;
	
select * from BookInventory

select * from @mergeoutput