IF OBJECT_ID('tempdb..#PersonLogEntries')IS NOT NULL
   DROP TABLE #PersonLogEntries;
GO

--Create temporary schema to hold input sample data
CREATE  TABLE  #PersonLogEntries
(
nationality   VARCHAR(20),
personid   INT,
[date]      DATE ,
mode      VARCHAR(5)

)
GO

--Some sample data.
INSERT INTO #PersonLogEntries (nationality,personid,[date],mode) 
VALUES 
('lib','123','20110101','entry'),
('fr','1254','20120504','entry'),
('spain','201','20130707','entry'),
('civ','658465','20130908','entry'),
('lib','123','20110503','exit'),
('lib','123','20110504','entry'),
('lib','123','20110508','exit'),
('civ','658465','20130928','exit')
GO

SELECT * FROM #PersonLogEntries

--The below CTE: CTE_StayLog will contain each visit of a person and how many days one stayed during the visit.
--The same person might have visited more than once.
;WITH CTE_StayLog AS
(
   SELECT   
         PENTRY.nationality,
         PENTRY.personid, 
         PENTRY.[DATE] AS EntryDate, 
         PEX.ExitDate, 
         DATEDIFF(DAY,PENTRY.[DATE],PEX.ExitDate) AS DaysOfStayPerVisit, 
         ROW_NUMBER()OVER(PARTITION BY PENTRY.personid ORDER BY PENTRY.[date] ASC) AS EntryNumber
   FROM #PersonLogEntries AS PENTRY
   OUTER APPLY
      (
         SELECT   MIN([date]) AS ExitDate  --Get the minimum exit date for each entry date. will be NULL if there is no exit.
         FROM   #PersonLogEntries AS PEXIT 
         WHERE   PEXIT.mode = 'exit'
         AND      PENTRY.personid = PEXIT.personid 
         AND      PEXIT.[date] > PENTRY.[date]
      ) as PEX
   WHERE PENTRY.mode = 'entry'
)
--If average stay per person is needed
SELECT nationality, personid, AVG(DaysOfStayPerVisit)
FROM   CTE_StayLog AS CTE
WHERE   CTE.ExitDate IS NOT NULL --People (rather entries) who do not have an exit date are ignored.
GROUP BY nationality, personid