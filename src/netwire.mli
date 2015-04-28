type ('input, 'output) wire

val step_wire: ?step:(unit -> float) -> ('a, 'b) wire -> 'a -> 'b * ('a, 'b) wire

val pure: 'a -> (_, 'a) wire

val apply: ('i, 'a -> 'b) wire -> ('i, 'a) wire -> ('i, 'b) wire

val map: ('a -> 'b) -> ('a, 'a) wire -> ('a, 'b) wire

val lift: ('a -> 'b) -> ('a, 'a) wire -> ('a, 'b) wire

val lift2: ('a -> 'b -> 'c) -> ('a, 'a) wire -> ('a, 'b) wire -> ('a, 'c) wire

val lift3: ('a -> 'b -> 'c -> 'd) -> ('a, 'a) wire -> ('a, 'b) wire ->
  ('a, 'c) wire -> ('a, 'd) wire

val id: ('a, 'a) wire

val ( >>> ): ('a, 'b) wire -> ('b, 'c) wire -> ('a, 'c) wire

val arr: ('a -> 'b) -> ('a, 'b) wire

val first: ('a, 'b) wire -> ('a * 'c, 'b * 'c) wire

val second: ('a, 'b) wire -> ('c * 'a, 'c * 'b) wire

val ( *** ): ('a, 'b) wire -> ('a2, 'b2) wire -> ('a * 'a2, 'b * 'b2) wire

val ( &&& ): ('a, 'b) wire -> ('a, 'b2) wire -> ('a, 'b * 'b2) wire

val ( ^>> ): ('a -> 'b) -> ('b, 'c) wire -> ('a, 'c) wire

val ( >>^ ): ('a, 'b) wire -> ('b -> 'c) -> ('a, 'c) wire

module Time : sig
  type t = float

  val time : (_, float) wire

end


module Util : sig
  val print_wire : ('o -> string) -> (unit, 'o) wire -> 'e
end
