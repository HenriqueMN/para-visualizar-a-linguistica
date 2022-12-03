drawBarplot <- function(number_of_vars, var_solid = NULL, color_value = NULL, position = NULL){
    if(number_of_vars == 1){
        if(!is.null(color_value)){
            if(var_solid == "variable"){
                geom_bar(position = position,
                         aes(fill = .data[[color_value]]))
            }else{
                geom_bar(aes(fill = color_value))
            }
        }else{
            geom_bar()
        }
    }else{
        if(!is.null(color_value)){
            if(var_solid == "variable"){
                geom_col(position = position,
                         aes(fill = .data[[color_value]]))
            }else{
                geom_col(aes(fill = color_value))
            }
        }else{
            geom_col()
        }
    }
}

drawBoxplot <- function(violin, var_solid = NULL, color_value = NULL){
    if(!is.null(color_value)){
        if(var_solid == "variable"){
            if(violin == TRUE){
                geom_violin(aes(fill = .data[[color_value]]))
            }else{
                geom_boxplot(aes(fill = .data[[color_value]]))
            }
        }else{
            if(violin == TRUE){
                geom_violin(aes(fill = color_value))
            }else{
                geom_boxplot(aes(fill = color_value))
            }
        }
    }else{
        if(violin == TRUE){
            geom_violin()
        }else{
            geom_boxplot()
        }
    }
}