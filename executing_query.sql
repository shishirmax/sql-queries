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

bcp dbo.tblHomeSpotter in D:\Edina\HomeSpotterFeed\12Dec17\edina_contata_sessions.csv 
-S tcp:contata.database.windows.net -d Edina -U contata.admin@contata -P C@ntata123 -a 16384 -b 20000 -q -c -t","

alter  procedure SP_RunBCPScript
@tbName		varchar(100),
@filePath	varchar(100),
@dbName		varchar(100),
@sep		varchar(5)
as
declare @cmd varchar(500)
begin
	set @cmd  = 'bcp'+
				@tbName+'in'+
				@filePath + '-S tcp:contata.database.windows.net -d'+@dbName+'-U contata.admin@contata -P C@ntata123 -a 16384 -b 20000 -q -c -t'+@sep
		print @cmd + '...'
		exec xp_cmdShell @cmd
end

EXEC SP_RunBCPScript 'dbo.tblHomeSpotter',
				'D:\Edina\HomeSpotterFeed\12Dec17\edina_contata_sessions.csv',
				'Edina',
				'","'










select * from INFORMATION_SCHEMA.TABLES
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'tblHomeSpotter'
if exists(select * from INFORMATION_SCHEMA.TABLES T 
              where T.TABLE_NAME = 'tblHomeSpotter') 
