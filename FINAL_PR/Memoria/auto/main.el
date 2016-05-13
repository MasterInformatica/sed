(TeX-add-style-hook "main"
 (lambda ()
    (LaTeX-add-bibliographies
     "references")
    (TeX-add-symbols
     '("todo" 1)
     '("TODO" 1)
     "HRule")
    (TeX-run-style-hooks
     "hyperref"
     "float"
     "amsmath"
     "fleqn"
     "subcaption"
     "graphicx"
     "booktabs"
     "xcolor"
     "lastpage"
     "fancyhdr"
     "listings"
     "procnames"
     "fullpage"
     ""
     "babel"
     "spanish"
     "inputenc"
     "latin1"
     "latex2e"
     "art11"
     "article"
     "a4paper"
     "11pt"
     "Cascaras/title"
     "Capitulos/s1-introduccion"
     "Capitulos/s2-camera")))

