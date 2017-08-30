-- Data Preperation for demo
--DECLARE Score 
CREATE TABLE Score
(MIPlayer VARCHAR(50), AgainstTeam VARCHAR(50), IPLYear INT, Runs INT, Average INT)
 
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Rohit Sharma', 'Delhi Daredavils', 2015, 78, 70)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Rohit Sharma', 'Gujrat Lions', 2015, 56, 60)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Rohit Sharma', 'Kings XI Punjab', 2015, 100, 120)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Rohit Sharma', 'Delhi Daredavils', 2016, 30, 77)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Rohit Sharma', 'Gujrat Lions', 2016, 67, 70)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Rohit Sharma', 'Kings XI Punjab', 2016, 25, 80)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Bumrah', 'Delhi Daredavils', 2015, 80, 70)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Bumrah', 'Gujrat Lions', 2015, 56, 70)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Bumrah', 'Kings XI Punjab', 2015, 90, 80)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Bumrah', 'Delhi Daredavils', 2016, 30, 100)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Bumrah', 'Gujrat Lions', 2016, 20, 100)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Bumrah', 'Kings XI Punjab', 2016, 25, 100)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Goplal', 'Delhi Daredavils', 2015, 80, 88)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Goplal', 'Gujrat Lions', 2015, 45, 88)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Goplal', 'Kings XI Punjab', 2015, 30, 90)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Goplal', 'Delhi Daredavils', 2016, 80, 70)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Goplal', 'Gujrat Lions', 2016, 20, 60)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('Goplal', 'Kings XI Punjab', 2016, 25, 100)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('McClenaghan', 'Delhi Daredavils', 2015, 70, 56)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('McClenaghan', 'Gujrat Lions', 2015, 10, 40)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('McClenaghan', 'Kings XI Punjab', 2015, 20, 30)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('McClenaghan', 'Delhi Daredavils', 2016, 80, 70)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('McClenaghan', 'Gujrat Lions', 2016, 80, 95)
INSERT INTO Score (MIPlayer, AgainstTeam, IPLYear, Runs, Average) VALUES('McClenaghan', 'Kings XI Punjab', 2016, 100, 120)
 
--Query for ResultSet 0
SELECT * FROM Score


--Query for ResultSet 1 -- Row_Number() Example
SELECT MIPlayer, AgainstTeam, IPLYear, Runs, Average AS Avg,
ROW_NUMBER() OVER(ORDER BY RUNS DESC) As [RANK] FROM Score
 
--Query for ResultSet 2 -- Row_Number() Example
SELECT MIPlayer, AgainstTeam, IPLYear, Runs, Average AS Avg,
ROW_NUMBER() OVER(PARTITION BY AgainstTeam ORDER BY RUNS DESC) As [RANK] FROM Score
 
--Query for ResultSet 3 -- Row_Number() Example
SELECT MIPlayer, AgainstTeam, IPLYear, Runs, Average AS Avg,
ROW_NUMBER() OVER(PARTITION BY AgainstTeam, IPLYear ORDER BY RUNS DESC) As [RANK] FROM Score
 
--Query for ResultSet 4 -- Row_Number() Example
SELECT MIPlayer, AgainstTeam, IPLYear, Runs, Average AS Avg,
ROW_NUMBER() OVER(PARTITION BY AgainstTeam, IPLYear ORDER BY RUNS DESC, Average DESC) As [RANK] FROM Score
 
--Query for ResultSet 5 -- RANK() Example
SELECT MIPlayer, AgainstTeam, IPLYear, Runs, Average AS Avg,
RANK() OVER(PARTITION BY AgainstTeam, IPLYear ORDER BY RUNS DESC, Average DESC) As [RANK] FROM Score
 
--Query for ResultSet 6 -- DENSE_RANK() Example
SELECT MIPlayer, AgainstTeam, IPLYear, Runs, Average AS Avg,
DENSE_RANK() OVER(PARTITION BY AgainstTeam, IPLYear ORDER BY RUNS DESC, Average DESC) As [RANK] FROM Score
 
--Query for ResultSet 7 -- NTILE(n) Example
SELECT MIPlayer, AgainstTeam, IPLYear, Runs, Average AS Avg,
NTILE(3) OVER(PARTITION BY AgainstTeam ORDER BY RUNS DESC) As [RANK] FROM Score