(lang dune 3.17)

(name netwire)

(using melange 0.1)

(license "MIT")

(maintainers "Denommus")

(generate_opam_files)

(package
 (name netwire)
 (synopsis "An AFRP library based on Netwire")
 (description "An AFRP library based on Netwire")
 (depends
  (ocaml (>= 5.0))))

(package
 (name netwireUnix)
 (synopsis "An AFRP library based on Netwire - Native implementation")
 (description "An AFRP library based on Netwire")
 (depends
  (ocaml (>= 5.0))))

(package
 (name netwireJs)
 (synopsis "An AFRP library based on Netwire - Melange implementation")
 (description "An AFRP library based on Netwire")
 (depends
  (ocaml (>= 5.0))
  melange))
