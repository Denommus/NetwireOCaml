type (_, _) wire =
  | WArr : ('a -> 'b) -> ('a, 'b) wire
  | WConst : 'b -> (_, 'b) wire
  | WGen : ((unit -> float) -> 'a -> 'b * ('a, 'b) wire) -> ('a, 'b) wire
  | WId : ('a, 'a) wire

let step_wire_int : type input out.
    (input, out) wire -> (unit -> float) -> input -> out * (input, out) wire =
 fun w time_gen input ->
  match w with
  | WArr f -> (f input, w)
  | WConst mx -> (mx, w)
  | WGen f -> f time_gen input
  | WId -> (input, w)

let pure x = WConst x

let rec apply wf wx =
  WGen
    (fun ds input ->
      let f, nwf = step_wire_int wf ds input in
      let x, nwx = step_wire_int wx ds input in
      (f x, apply nwf nwx))

let ( <*> ) wf wx = apply wf wx

let rec map : type input out1 out2.
    (out1 -> out2) -> (input, out1) wire -> (input, out2) wire =
 fun f -> function
  | WArr g -> WArr (fun x -> f (g x))
  | WConst mx -> WConst (f mx)
  | WGen _mx as wx ->
      WGen
        (fun ds input ->
          let x, nwx = step_wire_int wx ds input in
          (f x, map f nwx))
  | WId -> WArr f

let ( <$> ) f w = map f w
let lift = map
let lift2 f w1 w2 = apply (map f w1) w2
let lift3 f w1 w2 w3 = apply (apply (map f w1) w2) w3
let id = WId

let rec ( >>> ) wx wy =
  WGen
    (fun ds input ->
      let x, nwx = step_wire_int wx ds input in
      let y, nwy = step_wire_int wy ds x in
      (y, nwx >>> nwy))

let arr f = WArr f

let rec first wx =
  WGen
    (fun ds (a, in2) ->
      let x, nwx = step_wire_int wx ds a in
      ((x, in2), first nwx))

let second f =
  let swap (x, y) = (y, x) in
  arr swap >>> first f >>> arr swap

let ( *** ) f g = first f >>> second g
let ( &&& ) f g = arr (fun b -> (b, b)) >>> f *** g
let ( ^>> ) f g = arr f >>> g
let ( >>^ ) f g = f >>> arr g
let empty = WConst None

let rec ( <+> ) : type input out.
    (input, out option) wire ->
    (input, out option) wire ->
    (input, out option) wire =
 fun w1 w2 ->
  match (w1, w2) with
  | WConst (Some _), _ -> w1
  | WId, _ -> w1
  | WConst None, _ -> w2
  | _, _ ->
      let choose = function
        | (Some _ as mx1), _ -> mx1
        | _, (Some _ as mx2) -> mx2
        | None, None -> None
      in
      WGen
        (fun ds input ->
          let mx1, nw1 = step_wire_int w1 ds input in
          let mx2, nw2 = step_wire_int w2 ds input in
          (choose (mx1, mx2), nw1 <+> nw2))

let ( <|> ) = ( <+> )

let rec left w =
  WGen
    (fun ds -> function
      | Either.Left x ->
          let y, nw = step_wire_int w ds x in
          (Either.Left y, left nw)
      | Either.Right x -> (Either.Right x, left w))

let rec right w =
  WGen
    (fun ds -> function
      | Either.Left x -> (Either.Left x, right w)
      | Either.Right x ->
          let y, nw = step_wire_int w ds x in
          (Either.Right y, right nw))

let ( +++ ) w1 w2 = left w1 >>> right w2

let ( ||| ) w1 w2 =
  let untag = function Either.Left x -> x | Either.Right y -> y in
  w1 +++ w2 >>> arr untag

let rec dimap : type a b c d. (a -> b) -> (c -> d) -> (b, c) wire -> (a, d) wire
    =
 fun f g -> function
  | WArr h -> WArr (fun x -> f x |> h |> g)
  | WConst mx -> WConst (g mx)
  | WId -> WArr (fun x -> f x |> g)
  | WGen h ->
      WGen (fun ds input -> f input |> h ds |> fun (x, y) -> (g x, dimap f g y))

let rec lmap : type a b c. (a -> b) -> (b, c) wire -> (a, c) wire =
 fun f -> function
  | WArr g -> WArr (fun x -> f x |> g)
  | WConst mx -> WConst mx
  | WId -> WArr f
  | WGen g ->
      WGen (fun ds input -> f input |> g ds |> fun (x, w) -> (x, lmap f w))

let mk_const x = WConst x
let mk_empty = WConst None
let mk_gen f = WGen f
let mk_id = WId

module NetTime = struct
  type t = float

  let gettimeofday () = Time.gettimeofday ()

  let default_step =
    let init_t = gettimeofday () in
    fun () -> gettimeofday () -. init_t

  let time =
    let rec f get_time _ =
      let t = get_time () in
      (t, w)
    and w = WGen f in
    w
end

let step_wire ?(step = NetTime.default_step) wire input =
  step_wire_int wire step input

module Util = struct
  (*
 We could use:
 type 'o out_wire = { wire : 'a . ('a, 'o) wire }
 It works, but is a bit heavyweight, in practice,
 using a (unit, 'o) wire should be enough.
*)
  let print_wire show wire =
    let rec loop _w =
      let output, w = step_wire wire () in
      Printf.printf "\r%s\027[K" (show output);
      loop w
    in
    loop wire
end
