(lang dune 3.17)

(name netwire)

(using melange 0.1)

(license "MIT")

(maintainers "Denommus")

(authors "Denommus")

(homepage "https://github.com/Denommus/NetwireOCaml/")

(bug_reports "https://github.com/Denommus/NetwireOCaml/issues")

(version 0.1)

(generate_opam_files)

(package
 (name netwire)
 (synopsis "An AFRP library based on Netwire")
 (description "An AFRP library based on Netwire")
 (depends
  (ocaml (>= 5.2))))

(package
 (name netwireUnix)
 (synopsis "An AFRP library based on Netwire - Native implementation")
 (description "An AFRP library based on Netwire")
 (depends
  (ocaml (>= 5.2))))

(package
 (name netwireJs)
 (synopsis "An AFRP library based on Netwire - Melange implementation")
 (description "An AFRP library based on Netwire")
 (depends
  (ocaml (>= 5.2))
  melange))
