(lang dune 3.17)

(name netwire)

(generate_opam_files)

(package
 (name netwire)
 (synopsis "An AFRP library based on Netwire")
 (description "An AFRP library based on Netwire")
 (depends
  (ocaml (>= 5.0))))

(package
 (name netwireTime)
 (synopsis "Helper library for netwire")
 (description "Helper library for getting current time in netwire")
 (depends
  (ocaml (>= 5.0))))
