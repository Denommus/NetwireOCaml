open Netwire


let () = Util.print_wire (Printf.sprintf "%f") (apply (map (fun () -> ((+.) 20.)) id) Time.time)
