IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ocensa_rpt_get_2day_export_report')
    BEGIN
        PRINT 'Dropping Procedure ocensa_rpt_get_2day_export_report'
        DROP  Procedure  ocensa_rpt_get_2day_export_report
    END
GO

PRINT 'Creating procedure ocensa_rpt_get_2day_export_report' 
GO


create proc ocensa_rpt_get_2day_export_report 
	@systemId bigint,---Sistema
	@startDate datetime,--Programa Ventanas MES
	@endDate datetime ,--Programa Ventanas MES
	@productId  nvarchar(max) = null,--Producto (for multiple or single or no selection criteria)
	@shipperId bigint = null,---Remitente
	@customerId bigint = null,--Contacto con el remitente
	@strBeginDate datetime = null,--Fecha del reporte
	@accountingMonth nvarchar(max) = null---Meses con parada del sistema 
	/*@contractnum nvarchar(max) = null---Contactos del reporte*/ --remove this drop down as adviced by David.

as
declare 
@startDate_pre datetime,
@endDate_pre datetime,
@report_date datetime
set @startDate_pre=dateadd(mm,-1,@startDate)
set @endDate_pre =dateadd(mm,-1,@endDate)
set @report_date = (case when day(@strBeginDate)<=12 then convert(varchar, year(@strBeginDate))
					+ '-'+right('0'+convert(varchar, day(@strBeginDate)),2)
					+'-'+right('0'+convert(varchar, month(@strBeginDate)),2)
					else @strBeginDate end)

CREATE TABLE #Temp
(
	DISPLAY_VALUE NVARCHAR(255)
	,SHORT_NAME  NVARCHAR(255)
	,BILL_ATTN NVARCHAR(max)	
	,PHONE NVARCHAR(15)
	,FAX NVARCHAR(15)
	,STREET_ADDRESS_1 NVARCHAR(255)
	,STREET_ADDRESS_2 NVARCHAR(255)
	,CITY NVARCHAR(100)
	,COUNTRY NVARCHAR(100)
	,PHONE_ADD NVARCHAR(15)
	,PRODUCT_NAME NVARCHAR(255)
	,COMPANYNAME NVARCHAR(255)
	,CARGUE NVARCHAR(100)
	,VESSEL_EXP NVARCHAR(100)
	,LOCATION_CODE NVARCHAR(100)
	,VOLUME NVARCHAR(100)
	,MASTER_SHIPPER_ID BIGINT
	,SECTION int
	,PRE_NOM_VOL DECIMAL(20,4)
	,NOM_VOL DECIMAL(20,4)
	,FECHA VARCHAR(10)
	,PRODUCT_CODE NVARCHAR(50)
	,EMAIL NVARCHAR(100)
	
)

/*--- LOGIC TO INSERT THE COMMA SEPARATED LIST OF REPORT CONTACTS INTO TEMPTABLE
IF ISNULL(@CONTRACTNUM,'')<>''
BEGIN
		---INSERT COMMA SEPARATED LIST OF SHIPPER INTO TABLE VARIABLE
		
		DECLARE @TEMPSHIPPER TABLE (FLAG INT IDENTITY(1,1), MASTER_SHIPPER_ID BIGINT)

		DECLARE @IDX INT   
			DECLARE @SLICE VARCHAR(8000)       

			SELECT @IDX = 1          

			WHILE @IDX!= 0       
			BEGIN       
				SET @IDX = CHARINDEX(',',@CONTRACTNUM)       
				IF @IDX!=0       
					SET @SLICE = LEFT(@CONTRACTNUM,@IDX - 1)       
				ELSE       
					SET @SLICE = @CONTRACTNUM   

				IF(LEN(@SLICE)>0)  
					INSERT INTO @TEMPSHIPPER(MASTER_SHIPPER_ID) VALUES(@SLICE)
							
				SET @CONTRACTNUM = RIGHT(@CONTRACTNUM,LEN(@CONTRACTNUM) - @IDX) 
		      
			END
END
*/
--- LOGIC TO INSERT THE COMMA SEPARATED LIST OF PRODUCTS INTO TEMPTABLE
IF ISNULL(@PRODUCTID,'')<>''
BEGIN
		---INSERT COMMA SEPARATED LIST OF PRODUCTS INTO TABLE VARIABLE
		
		DECLARE @TEMPPRODUCT TABLE (FLAG INT IDENTITY(1,1), MASTER_PRODUCT_ID BIGINT)

		DECLARE @ID INT   
			DECLARE @SLICE_P VARCHAR(8000)       

			SELECT @ID = 1          

			WHILE @ID!= 0       
			BEGIN       
				SET @ID = CHARINDEX(',',@PRODUCTID)       
				IF @ID!=0       
					SET @SLICE_P = LEFT(@PRODUCTID,@ID - 1)       
				ELSE       
					SET @SLICE_P = @PRODUCTID   

				IF(LEN(@SLICE_P)>0)  
					INSERT INTO @TEMPPRODUCT(MASTER_PRODUCT_ID) VALUES(@SLICE_P)
							
				SET @PRODUCTID = RIGHT(@PRODUCTID,LEN(@PRODUCTID) - @ID) 
		      
			 END
END

--- LOGIC TO INSERT THE COMMA SEPARATED LIST OF SYSTEM SHUTDOWN MONTH(S) INTO TEMPTABLE
IF ISNULL(@ACCOUNTINGMONTH,'')<>''
BEGIN
		---INSERT COMMA SEPARATED LIST OF SYSTEM SHUTDOWN MONTH(S) INTO TABLE VARIABLE
		
		DECLARE @TEMPMONTH TABLE (FLAG INT IDENTITY(1,1), MONTH_NUM VARCHAR(50),report_dt date)

		DECLARE @ID_M INT   
			DECLARE @SLICE_M VARCHAR(8000),@monthname varchar(20), @year varchar(4),@date date    

			SELECT @ID_M = 1          

			WHILE @ID_M!= 0       
			BEGIN       
				SET @ID_M = CHARINDEX(',',@ACCOUNTINGMONTH)       
				IF @ID_M!=0       
					SET @SLICE_M = LEFT(@ACCOUNTINGMONTH,@ID_M - 1)       
				ELSE       
					SET @SLICE_M = @ACCOUNTINGMONTH   
					set @monthname = left(@SLICE_M,len(@SLICE_M)-5)
					set @year =  right(@SLICE_M,4)
					if (@monthname in ('enero','january'))
					begin
						set @date=@year+'-01-01'
					end
					if (@monthname in ('febrero','february'))
					begin
						set @date=@year+'-02-01'
					end
					if (@monthname in ('marzo','march'))
					begin
						set @date=@year+'-03-01'
					end
					if (@monthname in ('abril','april'))
					begin
						set @date=@year+'-04-01'
					end
					if (@monthname in ('mayo','may'))
					begin
						set @date=@year+'-05-01'
					end
					if (@monthname in ('junio','june'))
					begin
						set @date=@year+'-06-01'
					end
					if (@monthname in ('julio','july'))
					begin
						set @date=@year+'-07-01'
					end
					if (@monthname in ('agosto','august'))
					begin
						set @date=@year+'-08-01'
					end
					if (@monthname in ('septiembre','september'))
					begin
						set @date=@year+'-09-01'
					end
					if (@monthname in ('octubre','october'))
					begin
						set @date=@year+'-10-01'
					end
					if (@monthname in ('noviembre','november'))
					begin
						set @date=@year+'-11-01'
					end
					if (@monthname in ('diciembre','december'))
					begin
						set @date=@year+'-12-01'
					end
				IF(LEN(@SLICE_M)>0)  
					INSERT INTO @TEMPMONTH(MONTH_NUM,report_dt) VALUES(@SLICE_M,@date)
							
				SET @ACCOUNTINGMONTH = RIGHT(@ACCOUNTINGMONTH,LEN(@ACCOUNTINGMONTH) - @ID_M) 
		      
			 END

END

---  CREATE TEMP TABLE TO MAP SCHEDUER LOCATION WITH SYNTHESIS LOCATION.

CREATE TABLE #TEMPLOCATION
(
	ID INT IDENTITY(1,1)
	,SCHEDULERLOCID INT
	,SYNTHESISLOCID INT	
)

INSERT INTO #TEMPLOCATION VALUES (144,133)
INSERT INTO #TEMPLOCATION VALUES (143,134)
INSERT INTO #TEMPLOCATION VALUES (145,135)

------------------------------------------------------------------------

--- /*INSERT FOR 'CONTACTO CON EL REMITENTE' WHERE IT DEPENDS ONLY ON THE PARAMETER SELECT BY USER FOR FILTER REPORT. */
INSERT INTO #TEMP 
	(SHORT_NAME,DISPLAY_VALUE,BILL_ATTN,PHONE,FAX,STREET_ADDRESS_1,
	 STREET_ADDRESS_2,CITY,COUNTRY,PHONE_ADD,EMAIL,SECTION)
SELECT 
	MBE.SHORT_NAME,CON.DISPLAY_VALUE,CON.BILL_ATTN, CON.PHONE, CON.FAX,
	AD.STREET_ADDRESS_1,AD.STREET_ADDRESS_2,AD.CITY, AD.COUNTRY, AD.PHONE ADDRESS_PHONE, CON.EMAIL,1
	FROM CONTACT CON
	INNER JOIN [ADDRESS] AD ON CON.ADDRESS_ID=AD.ADDRESS_ID
	INNER JOIN MASTER_BUSINESS_ENTITY MBE ON MBE.MASTER_BE_ID=CON.MASTER_BUSINESS_ENTITY_ID
	WHERE CON.CONTACT_ID = @CUSTOMERID--BUSINESS ENTITY NAME FORM 'CONTACTO CON EL REMITENTE'
	

---/*INSERT FOR 'CONTACTOS DEL REPORTE' WHERE IT DEPENDS ON THE MULTI SELECTION OF SHIPPERS FROM THE FILTER*/
INSERT INTO #TEMP 
	(MASTER_SHIPPER_ID,COMPANYNAME,BILL_ATTN,SECTION)
SELECT DISTINCT
	TS.SHIPPER_ID,MBE.SHORT_NAME AS COMPANYNAME,
	STUFF(( SELECT  ' / ' + c.BILL_ATTN 
                FROM    BATCH_SCHEDULE_DETAIL bsd2
                INNER JOIN CONTACT C ON C.MASTER_BUSINESS_ENTITY_ID = bsd2.SHIPPER_ID
                WHERE   TS.SHIPPER_ID = bsd2.SHIPPER_ID and ts.PRODUCT_ID=BSD2.PRODUCT_ID
						AND TS.BATCH_SCHEDULE_ID=BSD2.BATCH_SCHEDULE_ID
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') BILL_ATTN,
	2
	FROM MASTER_BUSINESS_ENTITY MBE
		INNER JOIN BATCH_SCHEDULE_DETAIL TS ON TS.SHIPPER_ID = MBE.MASTER_BE_ID
		LEFT JOIN @TEMPPRODUCT TP ON (TP.MASTER_PRODUCT_ID=TS.PRODUCT_ID)
		WHERE (TS.COMMENT LIKE '%:M-%' OR TS.COMMENT LIKE '%:K-%')
		AND TS.START_TIME>= @STARTDATE
		AND TS.START_TIME < @ENDDATE
		AND (TS.SHIPPER_ID=@shipperId OR @shipperId IS NULL)
		AND (@PRODUCTID IS NULL OR TP.MASTER_PRODUCT_ID=TS.PRODUCT_ID)
		GROUP BY TS.SHIPPER_ID,MBE.SHORT_NAME,ts.PRODUCT_ID,TS.BATCH_SCHEDULE_ID

----
INSERT INTO #TEMP (FECHA,CARGUE,VESSEL_EXP,LOCATION_CODE,VOLUME,PRODUCT_NAME,PRODUCT_CODE,SECTION)
SELECT distinct
	RIGHT('0'+CONVERT(VARCHAR,DAY(bsd.START_TIME)),2)+'-'+RIGHT('0'+CONVERT(VARCHAR,DAY(dateadd(day,1,bsd.START_TIME))),2) FECHA,
	substring(comment,10,(len(comment)-10)) CARGUE,
	STUFF(( SELECT  ' + ' + mbe.display_value 
                FROM    BATCH_SCHEDULE_DETAIL bsd2
                INNER JOIN MASTER_BUSINESS_ENTITY MBE ON MBE.MASTER_BE_ID=BSD2.SHIPPER_ID 
                WHERE   BSD.comment = bsd2.comment and BSD.PRODUCT_ID=BSD2.PRODUCT_ID
                and RIGHT('0'+CONVERT(VARCHAR,DAY(bsd.START_TIME)),2)+'-'+RIGHT('0'+CONVERT(VARCHAR,DAY(dateadd(day,1,bsd.START_TIME))),2) =
                RIGHT('0'+CONVERT(VARCHAR,DAY(bsd2.START_TIME)),2)+'-'+RIGHT('0'+CONVERT(VARCHAR,DAY(dateadd(day,1,bsd2.START_TIME))),2)
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')+' ' + mp.product_code vessel_exp ,
	ML.LOCATION_NAME TLU,
	STUFF(( SELECT  ' + ' + convert(varchar,convert(int,bsd3.quantity/1000)) 
                FROM    BATCH_SCHEDULE_DETAIL bsd3
                WHERE   BSD.comment = bsd3.comment and BSD.PRODUCT_ID=BSD3.PRODUCT_ID
                and RIGHT('0'+CONVERT(VARCHAR,DAY(bsd.START_TIME)),2)+'-'+RIGHT('0'+CONVERT(VARCHAR,DAY(dateadd(day,1,bsd.START_TIME))),2) =
                RIGHT('0'+CONVERT(VARCHAR,DAY(bsd3.START_TIME)),2)+'-'+RIGHT('0'+CONVERT(VARCHAR,DAY(dateadd(day,1,bsd3.START_TIME))),2)
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')+' KB' VOLUME,
	MP.PRODUCT_NAME,
	MP.PRODUCT_CODE,
	3                 
	FROM BATCH_SCHEDULE_DETAIL BSD
		INNER JOIN MASTER_PRODUCT MP ON MP.MASTER_PRODUCT_ID = BSD.PRODUCT_ID
		--INNER JOIN #TEMPLOCATION TL ON TL.SCHEDULERLOCID=BSD.LOCATION_ID /*commented because now systhesis location would be same as scheduler locations*/
		LEFT JOIN @TEMPPRODUCT TP ON (TP.MASTER_PRODUCT_ID=BSD.PRODUCT_ID)
		INNER JOIN MASTER_LOCATION ML ON BSD.LOCATION_ID=ML.MASTER_LOCATION_ID
	WHERE (BSD.COMMENT LIKE '%:M-%' OR BSD.COMMENT LIKE '%:K-%')
		AND BSD.START_TIME>= @STARTDATE
		AND BSD.START_TIME < @ENDDATE
		AND (BSD.SHIPPER_ID=@shipperId OR @shipperId IS NULL)
		AND (ML.MASTER_SYSTEM_ID = @SYSTEMID OR @SYSTEMID IS NULL)
		AND (@PRODUCTID IS NULL OR TP.MASTER_PRODUCT_ID=BSD.PRODUCT_ID)
		GROUP BY
		RIGHT('0'+CONVERT(VARCHAR,DAY(bsd.START_TIME)),2)+'-'+RIGHT('0'+CONVERT(VARCHAR,DAY(dateadd(day,1,bsd.START_TIME))),2),
		BSD.COMMENT,
		ML.LOCATION_NAME,
		MP.PRODUCT_NAME,
		MP.PRODUCT_CODE,
		BSD.PRODUCT_ID

--- update for nom value for selected system months
update #TEMP 
		set PRE_NOM_VOL=
	(
		SELECT SUM(IRT.ITEM_REQUEST_QTY_PER_DAY) AS PRE_NOM_VOL
		FROM INV_REQUEST INV
		INNER JOIN INV_REQUEST_ITEM IRT ON INV.SA_REQ_ID=IRT.SA_REQ_ID
		LEFT JOIN @TEMPPRODUCT TP ON (TP.MASTER_PRODUCT_ID=IRT.MASTER_PRODUCT_ID)
		--inner join @TEMPMONTH tm on 1=1 and tm.flag=1
		WHERE IRT.ACTIVE_IND=1
				AND RECEIPT_DELIVERY_IND='R'
				AND (@PRODUCTID IS NULL OR TP.MASTER_PRODUCT_ID=IRT.MASTER_PRODUCT_ID)
				--AND INV.TRANSFER_DATE between tm.report_dt and dateadd(mm,1,tm.report_dt)
				AND INV.TRANSFER_DATE between dateadd(mm,-1,@STARTDATE) and @STARTDATE
	)
update #TEMP 
		set NOM_VOL=
	(
		SELECT SUM(IRT.ITEM_REQUEST_QTY_PER_DAY) AS NOM_VOL
		FROM INV_REQUEST INV
		INNER JOIN INV_REQUEST_ITEM IRT ON INV.SA_REQ_ID=IRT.SA_REQ_ID
		LEFT JOIN @TEMPPRODUCT TP ON (TP.MASTER_PRODUCT_ID=IRT.MASTER_PRODUCT_ID)
		--inner join @TEMPMONTH tm on 1=1 and tm.flag=2
		WHERE IRT.ACTIVE_IND=1
				AND RECEIPT_DELIVERY_IND='R'
				AND (@PRODUCTID IS NULL OR TP.MASTER_PRODUCT_ID=IRT.MASTER_PRODUCT_ID)
				--AND INV.TRANSFER_DATE between tm.report_dt and dateadd(mm,1,tm.report_dt)
				AND INV.TRANSFER_DATE between @STARTDATE and @ENDDATE
	)		

SELECT
	SHORT_NAME,
	DISPLAY_VALUE,
	PHONE,
	FAX,
	STREET_ADDRESS_1,
	STREET_ADDRESS_2,
	CITY,
	COUNTRY,
	PHONE_ADD,
	MASTER_SHIPPER_ID,
	COMPANYNAME,
	BILL_ATTN,
	SECTION,
	FECHA,
	CARGUE,
	VESSEL_EXP,
	LOCATION_CODE,
	VOLUME,
	PRODUCT_NAME,
	PRODUCT_CODE,
	NOM_VOL,
	PRE_NOM_VOL,
	dateadd(d,-1,@report_date) report_date,
	EMAIL
	FROM #TEMP

	

	
