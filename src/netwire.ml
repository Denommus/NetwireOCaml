type ('a, 'b) wire =
  | WArr: ('a -> 'b) -> ('a, 'b) wire
  | WConst: 'b -> (_, 'b) wire
  | WGen: ((unit -> float) -> 'a -> 'b * ('a, 'b) wire) -> ('a, 'b) wire
  | WId: ('a, 'a) wire

let stepWire
  : type a b . (a, b) wire -> (unit -> float) -> a -> b * (a, b) wire
  = fun w ds mx' -> match w with
    | (WArr f) -> (f mx', w)
    | (WConst mx) -> (mx, w)
    | (WGen f) -> f ds mx'
    | WId -> (mx', w)
