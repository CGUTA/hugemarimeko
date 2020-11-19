#!/usr/bin/env Rscript
library(data.table)
library(magrittr)

hex_to_rgb <- function(hex){
    	paste(col2rgb(hex)[,1], collapse = "_")
}

width = $params.width
height = $params.height

marimeko1 <- fread("$file1")
  if ("$fileopt" == "NO_FILE"){
   marimeko2 = fread("$file1")
  } else {
   marimeko2 = fread("$fileopt")
  }

color_conversion <- data.table(obs_id = colnames(marimeko1)[3:ncol(marimeko1)],
								color = strsplit("${params.colors}", ",") %>% hex_to_rgb)

setnames(marimeko1, 1:2, c("group", "lenght"))
setnames(marimeko2, 1:2, c("group", "lenght"))

marimeko1_melt <- melt(marimeko1, id.vars = c("group", "lenght"))
setkey(marimeko1_melt, group, lenght, variable)
marimeko2_melt <- melt(marimeko2, id.vars = c("group", "lenght"))
setkey(marimeko2_melt, group, lenght, variable)

marimeko <- marimeko1_melt[marimeko2_melt]

width = width - (nrow(marimeko) * ${params.gap})

r_height = height / max(marimeko[,.(max(value), max(i.value))])
r_width = width / marimeko[,max(lenght), by = variable][, sum(V1)]

marimeko[, value := floor(value * r_height)]
marimeko[, i.value := floor(i.value * r_height)]
marimeko[, lenght := floor(lenght * r_width)]

marimeko[, slope := 0]

if("${params.sort}" == "lenght"){
	marimeko[, slope := lenght]
} else if ("${params.sort}" == "slope"){
	marimeko[, slope := i.value - value]
} else if ("${params.sort}" == "null"){
	marimeko[, slope := 0]
}

if("${params.sort_direction}" == "descending"){
	plot_data <- marimeko[order(slope)]
} else if ("${params.sort_direction}" == "ascending"){
	plot_data <- marimeko[order(group,-slope)]
}

plot_data[, slope := NULL]

plot_data[, direction := "${params.orientation}"]

plot_data[color_conversion, on="variable==obs_id"]

#color add color

fwrite(plot_data, "marimeko_processed.psv", sep = "|")
