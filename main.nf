

prots_ch = Channel.fromPath(params.input)
opt_file = file(params.paired_input)

process marimeko_preprocessing {
  input:
  file file1 from prots_ch
  file fileopt from opt_file

  output:
  file "marimeko_processed.psv" into marimeko

  script:
  template "preprocessing.R"
}

process marimeko_plotting {
	publishDir "$params.outdir/", mode: 'copy', saveAs: { filename -> "${datasetID}_$filename" }
  input:
  file "marimeko_processed.psv" from marimeko

  output:
  file "marimeko_output.png"

  script:
  template "marimeko.py"
}