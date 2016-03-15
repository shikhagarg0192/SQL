create table test1(
id int,
user1 varchar(10),
activity varchar(10),
pageurl varchar(10)
)

insert into test1 values(1,'Me','act1','ab'),(2,'Me','act1','cd'),(3,'you','act2','xy'),(4,'you','act2','yz')

          
select user1, activity ,stuff((
select distinct ','+pageurl 
from test1
where user1 = t.user1 and activity=t.activity
 for xml path ('')),1,1,'') as urllist        
from test1 t
group by user1,activity
   

