#1) 
library(DBI)
library(RSQLite)

drv <- dbDriver("SQLite")
chinook_db <- dbConnect(drv, dbname = "./Documents/notes/PSTAT 10 HW/Chinook_Sqlite.sqlite")

# 2)
# a) primary keys uniquely identify rows (records) from a table
#  foreign keys establish relationships between tables, one primary key
#  from one table to the other.

# b) primary/foreign keys model real world relationships and relations.

# c) SQL: Structure Query language: we can interact with relational database
#  SQLite: specific implementation (different with unique features)- smaller
#  limited to different features

# 3) 
# a. List all the tables in the database 
dbListTables(chinook_db)

# b. List all foreign key relationships in the database 
dbGetQuery(chinook_db, "pragma foreign_key_list('Album')")
dbGetQuery(chinook_db, "pragma foreign_key_list('Artist')")
dbGetQuery(chinook_db, "pragma foreign_key_list('Customer')")
dbGetQuery(chinook_db, "pragma foreign_key_list('Employee')")
dbGetQuery(chinook_db, "pragma foreign_key_list('Genre')")
dbGetQuery(chinook_db, "pragma foreign_key_list('Invoice')")
dbGetQuery(chinook_db, "pragma foreign_key_list('InvoiceLine')")
dbGetQuery(chinook_db, "pragma foreign_key_list('MediaType')")
dbGetQuery(chinook_db, "pragma foreign_key_list('Playlist')")
dbGetQuery(chinook_db, "pragma foreign_key_list('PlaylistTrack')")
dbGetQuery(chinook_db, "pragma foreign_key_list('Track')")

# Can also use a loop to do this: 
tables <- dbListTables(chinook_db)
for (tbl in tables){
  print(dbGetQuery(chinook_db, paste("pragma foreign_key_list(",tbl,")")))
}

  # 1. Album.ArtistId -> Artist.ArtistId
  # 2. Customer.SupportRepId -> Employee.EmployeeId
  # 3. Employee.ReportsTo -> Employee.EmployeeId
  # 4. Invoice.CustomerId -> Customer.CustomerId
  # 5. InvoiceLine.TrackId -> Track.TrackId
  # 6. InvoiceLine.InvoiceId -> Invoice.InvoiceId
  # 7. PlaylistTrack.TrackId -> Track.TrackId
  # 8. PlaylistTrack.PlaylistId -> Playlist.PlaylistId
  # 9. Track.MediaTypeId -> MediaType.MediaTypeId
  # 10. Track.GenreId -> Genre.GenreId
  # 11. Track.Album -> AlbumId.AlbumId

# 4) 
# a. Select the CustomerId, FirstName, LastName, State, Country of 
# all customers living in California 
dbGetQuery(chinook_db, "select CustomerId, FirstName, LastName, State,
           Country from Customer where State is 'CA'")
# b. How many customers are from USA?
dbGetQuery(chinook_db, "SELECT COUNT(*) AS customers FROM Customer WHERE Country
                        = 'USA'")
    # 13 customers are from the USA.

# 5) Choose another table from the database. Write a SQL query, and describe. 
dbGetQuery(chinook_db, "select Title from Album where Title like '%y' ")
# This query only retrieves titles from the table 'Album' if the song title 
# ends with the letter 'y'. 

dbDisconnect(chinook_db)
# LEARNING GAINS
# Gain 1: Built on my understanding of how to find foreign key lists and relations. 
# Gain 2: Learned how to specify characteristics of my dbGetQuery functions to 
# retrieve certain values. 
# Gain 3: Properly learned how to implement the select count(*) function for dbGetQuery. 

Tiny_Clothes <- dbConnect(RSQLite::SQLite(), "Tiny_Clothes.sqlite")

# EXTRA PRACTICE QUESTIONS: 

# 1) a. Write down the schema for each of the relations CUSTOMER, PRODUCT, SALES_ORDER_LINE
  # For CUSTOMER, the columns are CUST_NO, NAME, ADDRESS
  # For PRODUCT, columns are PROD_NO, NAME, COLOR
  # For SALES_ORDER_LINE, columns are ORDER_NO, PROD_NO, QUANTITY

# 1) b. Identify the primary key for each relation and any foreign keys for each. 
# PRIMARY KEYS: 
# PRODUCT: {PROD_NO}
# SALES_ORDER_LINE: {ORDER_NO}
# CUSTOMER: {CUST_NO}

# FOREIGN KEYS:
# PRODUCT: no foreign key
# SALES_ORDER_LINE: PROD_NO
# CUSTOMER: no foreign key 


# 1) c. Suggest suitable domain for each attribute of PRODUCT. 
# (Data Type of the columns of product and their range if it can be defined)
# Data type of PROD_NO: integer
# PROD_NO(1, INF)
# Data type of NAME: string
# NAME{PANTS,SOCKS,SHIRTS}
# Data type of COLOR: string
# NAME{BLUE,KHAKI, GREEN,WHITE}

# 2) Find the age of the oldest employee at 'Tiny Clothes'
dbGetQuery(Tiny_Clothes, "select max(AGE) from EMPLOYEE ") # age 65

# 3) Are there any employees under the 50 whose name contains the letter 'R'?
dbGetQuery(Tiny_Clothes, "select NAME from EMPLOYEE where NAME like'%R%' and (AGE < 50)")
  # none 

# 4) Retrieve the employment number of the sales department manager.
dbGetQuery(Tiny_Clothes, "select EMP_NO from EMPLOYEE where DEPT_NO is 'D3'")
  # E5

dbGetQuery(Tiny_Clothes, 
           "SELECT MANAGER, Name
           FROM DEPARTMENT
           WHERE NAME = 'Sales'")

# 5) How many departments are there at 'Tiny Clothes'?
dbGetQuery(Tiny_Clothes, "select count(*) from DEPARTMENT")
  # 3 departments

# 6) What is Carol's customer number?
dbGetQuery(Tiny_Clothes, "select CUST_NO from CUSTOMER where NAME is 'CAROL'")
  # C3

# 7) Who works in Department D2?
dbGetQuery(Tiny_Clothes, "select NAME from EMPLOYEE where DEPT_NO is 'D2'")
  # Brown

# 8) Should Tiny Clothes sell PINK SOCKS? How would you answer this question 
  # if you were asked by a non-technical manager?
# No, Tiny Clothes should not sell pink socks because according to SALES_ORDER_LINE, 
# there are 20 white socks that have been sold. However, in INVOICES, there are no
# white socks ordered. Therefore, socks may not be a popular product. In addition, 
# there are no green socks being ordered as well, therefore socks are not a popular
# product in general. 
dbGetQuery(Tiny_Clothes, "select QUANTITY from SALES_ORDER_LINE where PROD_NO is 'p4'")
dbGetQuery(Tiny_Clothes, "select QUANTITY from INVOICES where PROD_NO is 'p4'")
dbGetQuery(Tiny_Clothes, "select QUANTITY from INVOICES where PROD_NO is 'p3'")
dbGetQuery(Tiny_Clothes, "select QUANTITY from SALES_ORDER_LINE where PROD_NO is 'p3'")

dbGetQuery(Tiny_Clothes, "Select PRODUCT.NAME,PRODUCT.COLOR, INVOICES.QUANTITY  
           FROM PRODUCT LEFT JOIN INVOICES 
           ON PRODUCT.PROD_NO = INVOICES.PROD_NO")

# 9) Retrieve the employment number of the sales department manager. 
dbGetQuery(Tiny_Clothes, "select EMP_NO from EMPLOYEE where DEPT_NO is 'D3'")
  # E5






