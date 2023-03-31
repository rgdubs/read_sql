# read_sql


My SQL Reading Helper function for R

This should work as a functional R package:
```
library(devtools)
install_github("rgdubs/read_sql")
```

Usage: 
```

read_sql(con,schema_name,table_name) # Typical mode to return a table

read_sql(con,info) # Return the information schema of the database

read_sql(con,search,"criterea") # Return a list of tables meeting your search criterea

```