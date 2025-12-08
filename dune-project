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
 (depends
  (core (= v0.17.1))
  (core_kernel (= v0.17.0))
  (crunch (= 4.0.0))
  (domainslib (= 0.5.2))
  (ocaml (= 5.2.1))
  (ocamlformat (= 0.28.1))
  (ppx_typed_fields (= v0.17.0))
  (raylib (= 1.5.1)))
 (synopsis "A template for OCaml gamedev")
 (description "Using raylib")
 (tags (gamedev template)))
