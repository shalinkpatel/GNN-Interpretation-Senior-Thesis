(TeX-add-style-hook
 "1_intro"
 (lambda ()
   (TeX-run-style-hooks
    "images/graph_ex")
   (LaTeX-add-labels
    "sec:intro"
    "fig:graph_ex"
    "sec:intro-interp"
    "fig:bnn_overview"
    "fig:prior"
    "sec:bayes-by-backprop"
    "fig:nf"))
 :latex)

