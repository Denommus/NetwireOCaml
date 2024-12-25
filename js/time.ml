let gettimeofday () = Js.Date.make () |> Js.Date.getTime |> (( *. ) 0.001)
