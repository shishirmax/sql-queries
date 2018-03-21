--Convert 2 rows to fields in SQL Server
IF OBJECT_ID('tempdb.dbo.#MyTable') IS not NULL DROP TABLE #MyTable

CREATE TABLE #MyTable (
    Direction varchar(1),
    DateKey int,
    ID varchar(8),
    [Sessions] int
    )

insert into #MyTable values('S', 20180301, 'ID123456', 46)
insert into #MyTable values('R', 20180301, 'ID123456', 99)
insert into #MyTable values('S', 20182103, 'ID123458', 34)
insert into #MyTable values('R', 20182103, 'ID123458', 65)


select DateKey, ID,
    max(case Direction when 'S' then [Sessions] end) as S_Sessions,
    max(case Direction when 'R' then [Sessions] end) as R_Sessions       
from #MyTable
group by DateKey, ID

drop TABLE #MyTable