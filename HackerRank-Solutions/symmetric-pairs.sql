--Symmetric Pairs
--https://www.hackerrank.com/challenges/symmetric-pairs/problem
WITH f1 
     AS (SELECT x, 
                y, 
                Row_number() 
                  OVER( 
                    partition BY x, y 
                    ORDER BY x) AS cnt 
         FROM   functions) 
SELECT DISTINCT f1.x, 
                f1.y 
FROM   f1 
       INNER JOIN functions f2 
               ON f1.x = f2.y 
                  AND f1.y = f2.x 
                  AND ( f1.x != f1.y 
                         OR cnt > 1 ) 
WHERE  f1.x <= f1.y 
ORDER  BY f1.x; 