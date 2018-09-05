# RANK, DENSE_RANK and ROW_NUMBER Functions

The RANK, DENSE_RANK and ROW_NUMBER functions are used to retrieve an increasing integer value. They start with a value based on the condition imposed by the ORDER BY clause. All of these functions require the ORDER BY clause to function properly. In case of partitioned data, the integer counter is reset to 1 for each partition.

## Preparing Dummy Data

```SQL
CREATE Database ShowRoom;
GO
USE ShowRoom;

CREATE TABLE Cars
(
id INT,
name VARCHAR(50) NOT NULL,
company VARCHAR(50) NOT NULL,
power INT NOT NULL
)


USE ShowRoom
INSERT INTO Cars
VALUES
(1, 'Corrolla', 'Toyota', 1800),
(2, 'City', 'Honda', 1500),
(3, 'C200', 'Mercedez', 2000),
(4, 'Vitz', 'Toyota', 1300),
(5, 'Baleno', 'Suzuki', 1500),
(6, 'C500', 'Mercedez', 5000),
(7, '800', 'BMW', 8000),
(8, 'Mustang', 'Ford', 5000),
(9, '208', 'Peugeot', 5400),
(10, 'Prius', 'Toyota', 3200),
(11, 'Atlas', 'Volkswagen', 5000),
(12, '110', 'Bugatti', 8000),
(13, 'Landcruiser', 'Toyota', 3000),
(14, 'Civic', 'Honda', 1800),
(15, 'Accord', 'Honda', 2000)
```

## RANK Function

The RANK function is used to retrieve ranked rows based on the condition of the ORDER BY clause. For example, if you want to find the name of the car with third highest power, you can use RANK Function.
Let’s see RANK Function in action:

```SQL
SELECT name,company, power,
RANK() OVER(ORDER BY power DESC) AS PowerRank
FROM Cars
```

The script above finds and ranks all the records in the Cars table and orders them in order of descending power.

The PowerRank column in the above table contains the RANK of the cars ordered by descending order of their power. An interesting thing about the RANK function is that if there is a tie between N previous records for the value in the ORDER BY column, the RANK functions skips the next N-1 positions before incrementing the counter. For instance, in the above result, there is a tie for the values in the power column between the 1st and 2nd rows, therefore the RANK function skips the next (2-1 = 1) one record and jumps directly to the 3rd row.
The RANK function can be used in combination with the PARTITION BY clause. In that case, the rank will be reset for each new partition.

```SQL
SELECT name,company, power,
RANK() OVER(PARTITION BY company ORDER BY power DESC) AS PowerRank
FROM Cars
```

In the script above, we partition the results by company column. Now for each company, the RANK will be reset to 1

## DENSE_RANK Function

The DENSE_RANK function is similar to RANK function however the DENSE_RANK function does not skip any ranks if there is a tie between the ranks of the preceding records.

```SQL
SELECT name,company, power,
DENSE_RANK() OVER(ORDER BY power DESC) AS PowerRank
FROM Cars
```

You can see from the output that despite there being a tie between the ranks of the first two rows, the next rank is not skipped and has been assigned a value of 2 instead of 3. As with the RANK function, the PARTITION BY clause can also be used with the DENSE_RANK function

```SQL
SELECT name,company, power,
DENSE_RANK() OVER(PARTITION BY company ORDER BY power DESC) AS DensePowerRank
FROM Cars
```

