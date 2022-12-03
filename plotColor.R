# Function used to return the right call for geom_point or geom_jitter. The parameters go as follows:
# > selected_args is a string with the name of all the desired arguments concatenated.
# > var_solid is also a string, storing either "variable" or "solidcolor"
# > color will either be the name of a variable or the hex code
# > size may have a numeric value
# > shape may have a variable name

# The function will check whether var_solid is equal to a variable or not, that will define whether the color will be used as a variable or only change the color of the plot.
# Regardless of TRUE or FALSE,the function will then enter a switch using selected_args to match with all possible combinations of arguments the user may have selected and call geom_point() or geom_jitter accordingly()
drawPointColor <- function(selected_args, var_solid, color, size = NULL, shape = NULL){
    if(var_solid == "variable"){
        switch(selected_args,
               "color" = geom_point(aes(color = .data[[color]])),
               "colorsize" = geom_point(size = size,
                                        aes(color = .data[[color]])),
               "colorshape" = geom_point(aes(color = .data[[color]],
                                             shape = .data[[shape]])),
               "colorsizeshape" = geom_point(size = size,
                                             aes(color = .data[[color]],
                                                 shape = .data[[shape]])),
               "colorjitter" = geom_jitter(aes(color = .data[[color]])),
               "colorsizejitter" = geom_jitter(size = size,
                                               aes(color = .data[[color]])),
               "colorshapejitter" = geom_jitter(aes(color = .data[[color]],
                                                    shape = .data[[shape]])),
               "colorsizeshapejitter" = geom_jitter(size = size,
                                                    aes(color = .data[[color]],
                                                        shape = .data[[shape]]))
        )
    }else{
        switch(selected_args,
               "color" = geom_point(aes(color = color)),
               "colorsize" = geom_point(size = size,
                                        aes(color = color)),
               "colorshape" = geom_point(aes(color = color,
                                             shape = .data[[shape]])),
               "colorsizeshape" = geom_point(size = size,
                                             aes(color = color,
                                                 shape = .data[[shape]])),
               "colorjitter" = geom_jitter(aes(color = color)),
               "colorsizejitter" = geom_jitter(size = size,
                                               aes(color = color)),
               "colorshapejitter" = geom_jitter(aes(color = color,
                                                    shape = .data[[shape]])),
               "colorsizeshapejitter" = geom_jitter(size = size,
                                                    aes(color = color,
                                                        shape = .data[[shape]]))
        )
    }
}