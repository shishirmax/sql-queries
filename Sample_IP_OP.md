Here is my query    

    Select distinct ASSOCIATE_ID, 
                    Rate_Billed, 
                    Currency, 
                    RateMultiplier, 
                    UOM,
                    MONTH, 
                    YEAR= MAX(YEAR) over (partition by associate_id) 
    from  asso_billinghrs

   **Below is the sample data.**

|ASSOCIATE_ID	|Rate_Billed |	Currency|	RateMultiplier|	UOM	|MONTH|YEAR|
|---------------|------------|----------|-----------------|-----|-----|----|
|1	            |23.78	     |USD	    |1	              |B	|11	  |2013|
|1	            |23.78	     |USD	    |1	              |B	|2	  |2014|
|1	            |23.78	     |USD	    |1	              |B	|3	  |2014|
|2	            |1	         |INR	    |0.0146701	      |C    |1	  |2017|
|2	            |1	         |INR	    |0.0147451	      |C    |1	  |2017|




**Below is the output**

|ASSOCIATE_ID|	Rate_Billed|Currency|RateMultiplier|UOM|MONTH|YEAR|
|------------|-------------|--------|--------------|---|-----|----| 
|1	         |23.78	       |USD	    |1	           |B  |3	 |2014|
|2	         |1	           |INR	    |0.0147451	   |C  |1	 |2017|


 Get latest salary of each associate in sql table having month and year column also. Each associate have minimum 4 to 5 records
Thanks

