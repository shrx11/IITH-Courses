# Instructions to run the files:

  

  

After extracting the zip file submitted, there will be a single folder named **49assgn2**:

  

- Add the **source.txt** file to this folder

  

These are the following files in the folder:

  

-  **create.sql** - This creates the schemas for the database.

  

-  **populate.py** - This will parse the data from **source.txt** and loads the database.

  

-  **run.sh** - this shell script freshly creates the database and runs the **create.sql** file

  

-  **db_research_engine_dump.sql** - PG database dump file.


  

-  **ER_final_group49.png** - Updated ER diagram according to which schemas are defined.

- **query.sql**- This file contains all the queries asked in assignment3.


  

- To run:

-  ```$ bash run.sh ```

-  ```$ python3 populate.py ```

  

- Estimated time taken to load the database is **9-10 min**

  

- This creates and populates all the tables into the database “research_engine” as a test user ```testuser```.

  

-  **Note:** 
	- Enter the sudo password whenever required.
	- Indexing for ids for papers, authors and venues starts from 1.
	- Run the queries one by one in `query.sql`
	- As the indexing starts from 1, kindly evaluate the results of our  queries from `query.sql` using the database restored from our dump file.