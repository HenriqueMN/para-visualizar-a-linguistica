loadFile <- function(name, path, header){
    ext <- tools::file_ext(name) # The ext variable stores the extension of the uploaded file
    # The switch() uses the variable ext to execute the right line of code, so if the extension is "csv" it'll execute the code that reads csv files.
    switch(ext,
           # vroom() is used for both the speed and the flexibility of accepting multiple delimiters arguments, so it's easier to read .csv files with a single function in contrast to using read_csv and read_csv2 from readr to read comma and semicolon respectively
           csv = vroom(path, 
                       col_names = header), # Code to read .csv
           tsv = vroom(path, delim = "\t",
                       col_names = header), # Code to read .tsv
           txt = vroom(path,
                       col_names = header), # Code to read .txt file with any of the supported delimiters
           xlsx = read_xlsx(path,
                            col_names = header), # Code to read .xlsx
           xls = read_xls(path,
                          col_names = header), # Code to read .xls
           validate("Arquivo inválido, por favor insira um arquivo em formato .csv, .tsv, .txt, .xlsx ou .xls.") # Default, if the file format isn't one of the five accepted formats it'll print the message asking for a file in one of them.
    )
}