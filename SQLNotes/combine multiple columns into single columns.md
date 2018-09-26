# combine multiple columns into single columns

Need an output like display all different column data coresponding to same ID into single column

|ID |C1     |C2     |C3     |
|---|-------|-------|-------|
|1	|ABC	|DEF	|GHI    |
|2	|LMNO	|PQRS	|TUVW   |
|3	|XYZ	|A12B	|C12D   |

*Required Output*

|ID |Comp   |
|---|-------|
|1	|ABC    |
|1	|DEF    |
|1	|GHI    |
|2	|LMNO   |
|2	|PQRS   |
|2	|TUVW   |
|3	|A12B   |
|3	|C12D   |
|3	|XYZ    |

*Query*

```SQL
SELECT ID,Company_1 AS Company
FROM MYTBL
UNION
SELECT ID,Company_2 AS Company
FROM MYTBL
UNION
SELECT ID,Company_3 AS Company
FROM MYTBL
```