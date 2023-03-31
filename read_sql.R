quicktable_bookmarks = function(con, ...) {
  con <- con
  args <-  ensyms(...)

  tbl(con, in_schema("information_schema", "columns")) %>%
      select(contains(c("table_schema", "table_name","column_name"),ignore.case=TRUE))

}

quicktable_lazy = function(con, ...) {
  con <- con
  args <-  ensyms(...)

  tbl(con, in_schema("information_schema", "tables")) %>%
    select(contains("table_name",ignore.case = TRUE)) %>%
    collect() %>%
    filter(if_any(everything(),~str_detect(.x,paste("(?i)",args[2],sep="")))) # finish this by adding in detection of length()

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


  if (args[1] == "info") {
    quicktable_bookmarks(con)

  } else if (args[1] == "lazy") {
    quicktable_lazy(con, ...)

  } else {
    quicktable_call(con, ...)

  }

}
