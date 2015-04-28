
type (_, _) wire =
  | WArr: ('a -> 'b) -> ('a, 'b) wire
  | WConst: 'b -> (_, 'b) wire
  | WGen: ((unit -> float) -> 'a -> 'b * ('a, 'b) wire) -> ('a, 'b) wire
  | WId: ('a, 'a) wire

let step_wire_int
  : type input out . (input, out) wire -> (unit -> float) -> input -> out * (input, out) wire
  = fun w time_gen input -> match w with
    | WArr f -> (f input, w)
    | WConst mx -> (mx, w)
    | WGen f -> f time_gen input
    | WId -> (input, w)

let pure x = WConst x

let rec apply wf wx = WGen (fun ds input ->
    let f, nwf = step_wire_int wf ds input in
    let x, nwx = step_wire_int wx ds input in
    (f x, apply nwf nwx))

let rec map f = function (WArr g)        -> WArr (fun x -> f (g x))
                       | (WConst mx)     -> WConst (f mx)
                       | (WGen mx) as wx -> WGen (fun ds input -> let x, nwx = step_wire_int wx ds input in
                                                   (f x, map f nwx))
                       | WId             -> WArr f

let lift = map

let lift2 f w1 w2 = apply (map f w1) w2

let lift3 f w1 w2 w3 = apply (apply (map f w1) w2) w3

let id = WId

let rec ( >>> ) wx wy = WGen (fun ds input -> let (x,nwx) = step_wire_int wx ds input in
                             let (y, nwy) = step_wire_int wy ds x in
                             (y, nwx >>> nwy))

let arr f = WArr f

let rec first wx = WGen (fun ds (a, in2) -> let x, nwx = step_wire_int wx ds a in
                          ((x, in2), first nwx))

let second f = let swap (x,y) = y,x in
  arr swap >>> first f >>> arr swap

let ( *** ) f g = first f >>> second g

let ( &&& ) f g = (arr (fun b -> b,b)) >>> f *** g

let (^>>) f g = arr f >>> g

let (>>^) f g = f >>> arr g

module Time = struct

  type t = float

  let default_step =
    let init_t = Unix.gettimeofday () in
    fun () -> Unix.gettimeofday () -. init_t

  let time =
    let rec f get_time _ = let t = get_time () in t, w
    and w = WGen f
    in w

end

let step_wire ?(step=Time.default_step) wire input = step_wire_int wire step input

module Util = struct

(*
 We could use:
 type 'o out_wire = { wire : 'a . ('a, 'o) wire }
 It works, but is a bit heavyweight, in practice,
 using a (unit, 'o) wire should be enough.
*)
  let print_wire show wire =
    let rec loop w =
      let output, w = step_wire wire () in
      Printf.printf "\r%s\027[K" (show output) ;
      loop w
    in
    loop wire

end
