# Function used to return the right call of the palette. The parameters go as follows:
# > palette is a string storing the name of the viridis' palettes or the values "default" and "gray"
# > plot_type is a string storing the type of the plot
# > color is a string storing the name of the variable to be mapped in color
# > cont_variables is a vector storing the names of all the continuous variables in the data

# The function will first use a if statement to check whether the plot is a barplot or a boxplot. If it is, it'll create "values" and assign it the string "disc_only", if it isn't, it'll also create "values" but assign it the string "both", meaning color might be a discret or a continuous variable instead of only discrete. It will then enter a switch function using "values" as expression to match
getPalette <- function(palette, plot_type, color, cont_variables){
    
    if(plot_type == "barplot" || plot_type == "boxplot"){
        values <- "disc_only"
    }else{
        values <- "both"
    }
    
    switch(values,
           "disc_only" = {
               if(palette != "default" && palette != "gray"){ # Checking if it's one of the viridis' palettes
                   scale_fill_viridis_d(option = palette)
               }else if(palette == "gray"){ # Checking if it's the gray palette
                   scale_fill_grey(start = 0.3, end = 0.9)
               }else{ # Assuming it's the default palette
                   scale_fill_hue()
               }
           },
           
           "both" = {
               if(color %in% cont_variables){
                   if(palette != "default" && palette != "gray"){
                       scale_color_viridis_c(option = palette)
                   }else if(palette == "gray"){
                       scale_color_distiller(type = "seq",
                                             direction = -1,
                                             palette = "Greys")
                   }else{
                       scale_color_continuous()
                   }
               }else{
                   # Although the calling is similar to disc_only, this one uses scale_color instead of scale_fill
                   if(palette != "default" && palette != "gray"){
                       scale_color_viridis_d(option = palette)
                   }else if(palette == "gray"){
                       scale_color_grey(start = 0.3, end = 0.9)
                   }else{
                       scale_color_hue()
                   }
               }
           }
    )
}