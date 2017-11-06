open Netwire


let () =
  (fun _ x -> x +. 20.) <$> id <*> NetTime.time
  |> Util.print_wire (Printf.sprintf "%f")
