
SET NOCOUNT ON

IF OBJECT_ID('STATS') IS NOT NULL DROP TABLE STATS
IF OBJECT_ID('STATIONS') IS NOT NULL DROP TABLE STATIONS
IF OBJECT_ID('OPERATORS') IS NOT NULL DROP TABLE OPERATORS
IF OBJECT_ID('REVIEWS') IS NOT NULL DROP TABLE REVIEWS


select * from STATS
select * from STATIONS
select * from OPERATORS
select * from REVIEWS

-- Create and populate table with Station
CREATE TABLE STATIONS(ID INTEGER PRIMARY KEY, CITY NVARCHAR(20), STATE CHAR(2), LAT_N REAL, LONG_W REAL);
INSERT INTO STATIONS VALUES (13, 'Phoenix', 'AZ', 33, 112); 
INSERT INTO STATIONS VALUES (44, 'Denver', 'CO', 40, 105); 
INSERT INTO STATIONS VALUES (66, 'Caribou', 'ME', 47, 68);

-- Create and populate table with Operators
CREATE TABLE OPERATORS(ID INTEGER PRIMARY KEY, NAME NVARCHAR(20), SURNAME NVARCHAR(20));
INSERT INTO  OPERATORS VALUES (50, 'John "The Fox"', 'Brown'); 
INSERT INTO  OPERATORS VALUES (51, 'Paul', 'Smith'); 
INSERT INTO  OPERATORS VALUES (52, 'Michael', 'Williams'); 

-- Create and populate table with normalized temperature and precipitation data
CREATE TABLE STATS (
		STATION_ID INTEGER REFERENCES STATIONS(ID),
		MONTH INTEGER CHECK (MONTH BETWEEN 1 AND 12), 
		TEMP_F REAL CHECK (TEMP_F BETWEEN -80 AND 150), 
		RAIN_I REAL CHECK (RAIN_I BETWEEN 0 AND 100), PRIMARY KEY (STATION_ID, MONTH));
INSERT INTO STATS VALUES (13,  1, 57.4, 0.31); 
INSERT INTO STATS VALUES (13,  7, 91.7, 5.15); 
INSERT INTO STATS VALUES (44,  1, 27.3, 0.18); 
INSERT INTO STATS VALUES (44,  7, 74.8, 2.11); 
INSERT INTO STATS VALUES (66,  1, 6.7, 2.10); 
INSERT INTO STATS VALUES (66,  7, 65.8, 4.52);

-- Create and populate table with Review
CREATE TABLE REVIEWS(STATION_ID     INTEGER,STATION_MONTH  INTEGER,OPERATOR_ID INTEGER)	
insert into REVIEWS VALUES (13,1,50)
insert into REVIEWS VALUES (13,7,50)
insert into REVIEWS VALUES (44,7,51)
insert into REVIEWS VALUES (44,7,52)
insert into REVIEWS VALUES (44,7,50)
insert into REVIEWS VALUES (66,1,51)
insert into REVIEWS VALUES (66,7,51)



-- Create JsonEscape function

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[qfn_JsonEscape](@value nvarchar(max) )
returns nvarchar(max)
as begin
 
 if (@value is null) return 'null'
 if (TRY_PARSE( @value as float) is not null) return @value

 set @value=replace(@value,CHAR(92),CHAR(92)+CHAR(92))
 set @value=replace(@value,CHAR(34),CHAR(92)+CHAR(34))

 set @value=replace(@value,'/',CHAR(92)+'/')
 set @value=replace(@value,CHAR(10),CHAR(92)+'n')
 set @value=replace(@value,CHAR(13),CHAR(92)+'r')
 set @value=replace(@value,CHAR(19),CHAR(92)+'t')


 return CHAR(34)+@value+CHAR(34)

end
           
GO
           
CREATE FUNCTION [dbo].[qfn_XmlToJson]
(
	@XmlData xml
)
RETURNS nvarchar(max)
AS
BEGIN
	declare @m nvarchar(max)
	SELECT @m='['+Stuff(
		(
		
		SELECT theline from																				
	(SELECT ','+' {'+																							
				Stuff(
					(SELECT ',"'+coalesce(b.c.value('local-name(.)', 'NVARCHAR(255)'),'')+'":'+			
						case when b.c.value('count(*)','int')=0 then 
                         dbo.qfn_JsonEscape(b.c.value('text()[1]','NVARCHAR(MAX)')) 
						else dbo.qfn_XmlToJson(b.c.query('*'))
						end
						
					from x.a.nodes('*') b(c)																
					for xml path(''),TYPE).value('(./text())[1]','NVARCHAR(MAX)')
				,1,1,'')+'}'																				
				
			from @XmlData.nodes('/*') x(a)																
			) JSON(theLine)																					
			
	
			
			for xml path(''),TYPE).value('.','NVARCHAR(MAX)' )
			,1,1,'')+']'																						--remove the first leading comma
	return @m
END           

--Executing the Function
select dbo.qfn_XmlToJson(
	(
	select stations.ID,stations.CITY,stations.STATE,stations.LAT_N,stations.LONG_W ,
		 (	select stats.*, 
				( select OPERATORS.*  from OPERATORS inner join reviews on OPERATORS.ID=reviews.OPERATOR_ID
				  where reviews.STATION_ID=STATS.STATION_ID and reviews.STATION_MONTH=STATS.MONTH for xml path('operator'),type) operators
			from STATS where STATS.STATION_ID=stations.ID for xml path('stat'),type
		 ) stats 
	from stations for xml path('stations'),type
	)
)