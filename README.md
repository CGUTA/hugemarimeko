# hugemarimeko

Required parameters:

--input # delimited file with format: 
		#id lenght obs1 obs2 ...

--width # pixels of output png
--height # pixels of output png

Optional parameters:
--outdir # where results are placed. (Default .)

--paired_input # File with updated values for file input to draw marimeko slope

--orientation # Should the bars be drawn UP or DOWN (Default UP)
--colors # hex colors for every observation (Default #000000 for all)

--background_greyscale # 0-255 (Default 255)

--sort # sort base on lenght or slope (default no sort)
		# Note: slopes only ocurr when paired_input values are different from originals
--sort_direction # if sort is used: ascending descending (Default ascending)

--gap #pixel gab between bars (Default 2)