type ('input, 'output) wire

val step_wire: ?step:(unit -> float) -> ('a, 'b) wire -> 'a -> 'b * ('a, 'b) wire

val pure: 'a -> (_, 'a) wire

val apply: ('i, 'a -> 'b) wire -> ('i, 'a) wire -> ('i, 'b) wire

val map: ('a -> 'b) -> ('a, 'a) wire -> ('a, 'b) wire

val arr: ('a -> 'b) -> ('a, 'b) wire

val id: ('a, 'a) wire

module Time : sig
  type t = float

  val time : (_, float) wire

end


module Util : sig
  val print_wire : ('o -> string) -> (unit, 'o) wire -> 'e
end
