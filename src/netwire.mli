type ('input, 'output) wire

val step_wire: ?step:(unit -> float) -> ('a, 'b) wire -> 'a -> 'b * ('a, 'b) wire

module Time : sig
  type t = float

  val time : (_, float) wire

end


module Util : sig
  val print_wire : ('o -> string) -> (unit, 'o) wire -> 'e
end
