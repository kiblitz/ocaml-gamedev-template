(lang dune 3.18)

(name ocaml-gamedev-template)
(generate_opam_files true)

(source (github kiblitz/ocaml-gamedev-template))
(authors "kiblitz")
(maintainers "kiblitz")
(license MIT)
(documentation https://github.com/kiblitz/ocaml-gamedev-template)

(package
 (name ocaml-gamedev-template)
 (synopsis "A template for OCaml gamedev")
 (description "Using raylib")
 (depends ocaml)
 (tags (gamedev template)))
