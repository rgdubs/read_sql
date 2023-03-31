
# Used to print out the information schema into a table.
quicktable_info = function(con, ...) {
  con <- con
  args <-  ensyms(...)

  tbl(con, in_schema("information_schema", "columns")) %>%
      select(contains(c("table_schema", "table_name","column_name"),ignore.case=TRUE))

} 

# Search the tables in the information schema
quicktable_search = function(con, ...) {
  con <- con
  args <-  ensyms(...)

  tbl(con, in_schema("information_schema", "tables")) %>%
    select(contains("table_name",ignore.case = TRUE)) %>%
    collect() %>%
    filter(if_any(everything(), ~str_detect(.x, paste("(?i)", args[2], sep = ""))) & nchar(table_name) == nchar(args[2]))
}


quicktable_call = function(con, ...) {
  con <- con
  args <-  ensyms(...)


  # Formats
  basic_sql = expr(tbl(con,in_schema(paste(args[1]), paste(args[2]))))
  mysql = expr(tbl(con,paste(args[1])))


  switch(
    class(con)
    ,"Redshift" = eval(basic_sql)
    ,"PostgreSQL" = eval(basic_sql)
    ,"Microsoft SQL Server" = eval(basic_sql)
    ,"SQLiteConnection" = eval(mysql)
    ,stop("You gotta give me something.")
  )

}


read_sql = function(con, ...) {
  con <- con
  args <-  ensyms(...)


  if (paste(args[1]) == "info") {
    quicktable_info(con)

  } else if (paste(args[1]) == "search") {
    quicktable_search(con, ...)

  } else {
    quicktable_call(con, ...)

  }

}
