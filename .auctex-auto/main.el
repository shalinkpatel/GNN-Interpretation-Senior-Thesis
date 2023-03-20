(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "11pt" "twoside")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("natbib" "sort&compress") ("algorithm2e" "ruled" "vlined")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "1_intro"
    "2_related"
    "3_method"
    "4_exp"
    "5_results"
    "6_discuss"
    "article"
    "art11"
    "url"
    "graphicx"
    "natbib"
    "geometry"
    "authblk"
    "amsmath"
    "amsfonts"
    "tabularx"
    "ragged2e"
    "booktabs"
    "titlesec"
    "amssymb"
    "comment"
    "subcaption"
    "xcolor"
    "hyperref"
    "dsfont"
    "float"
    "algorithm2e")
   (TeX-add-symbols
    '("fixme" 2)
    '("shorten" 1))
   (LaTeX-add-bibliographies
    "refs"))
 :latex)

