select * from RevenueTxnMapping
where revenueClassifiedTerms = 'Revenue_Classification' -- Card ATM: 4

select SUM(Amount) AMount, revenueTypeId , periodYear, PeriodMonth , RevenueDataCategory from ProgramRevenueCollection
WHERE RevenueDataCategory IN ( 'Point in time data', 'Actual ME Data')
AND revenueTypeId IN (1, 2)
AND PeriodYear = 2017
--AND ProgramNumber = 82047701477
GROUP BY revenueTypeId , periodYear, PeriodMonth , RevenueDataCategory

--SELECT * FROM DimProgram WHERE ProgramName = 'Alaska Airlines Insight Community'

select SUM(Amount) AMount, revenueTypeId , periodYear, PeriodMonth , RevenueDataCategory from ProgramRevenueCollection
WHERE RevenueDataCategory IN ( 'Point in time data', 'Actual ME Data')
AND revenueTypeId IN (31)
AND PeriodYear = 2017
GROUP BY revenueTypeId , periodYear, PeriodMonth , RevenueDataCategory
order by PeriodMonth desc

select SUM(Amount) AMount, revenueTypeId , periodYear, PeriodMonth , RevenueDataCategory from ProgramRevenueCollection
WHERE RevenueDataCategory IN ( 'Point in time data', 'Actual ME Data')
AND revenueTypeId IN (4)
AND PeriodYear = 2017
GROUP BY revenueTypeId , periodYear, PeriodMonth , RevenueDataCategory