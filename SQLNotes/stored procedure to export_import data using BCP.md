```SQL
create Proc Sp_Export_Or_import_Table @dbName     varchar(30), 
                                      @tbName     varchar(30), 
                                      @filePath   varchar(80), 
                                      @cmode      char(6), 
                                      @sep        char(1), 
                                      @usr        varchar(30), 
                                      @pwd        varchar(30) 
as 
declare @cmd varchar(200) 
begin 
  IF @cmode = 'EXPORT' 
  begin 
      set @cmd = 'bcp.exe ' +  
                 @dbName + '..' + @tbName +  ' out '  + 
                 @filePath + ' -c -q -C1252 -U ' + @usr + 
                 ' -P ' + @pwd + ' -t' + @sep 
      print @cmd + '...' 
      exec xp_cmdShell @cmd 
  end 
  IF  @cmode = 'IMPORT' 
  begin 
     set @cmd = 'bcp.exe ' +  
                 @dbName + '..' + @tbName +  ' in '  + 
                 @filePath + ' -c -q -C1252 -U ' + @usr + 
                 ' -P ' + @pwd + ' -t' + @sep 
      print @cmd + '...' 
     exec xp_cmdShell @cmd   
  end 
End 
go 
```



## How To Use it 
## Export a Table From a given DataBase to a File. 

```SQL
Exec Sp_Export_Or_import_Table 'Northwind', 
                               'Orders', 
                               'c:tempdbNorthwind_Orders.Dat', 
                               'EXPORT', 
                               '@', 
                               'iecdba', 
                               'sapwd' 
-- Import a table to a given DataBase from a File 
use pubs 
go 
select * into newOrders from northwind..orders where 0 = 1 
go 
use master 
go 
Exec Sp_Export_Or_import_Table  'pubs', 
                               'NewOrders', 
                               'c:tempdbNorthwind_Orders.Dat', 
                               'IMPORT', 
                               '@', 
                               'iecdba', 
                               'sapwd' 
```							   
