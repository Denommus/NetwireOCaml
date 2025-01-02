type ('input, 'output) wire

val step_wire :
  ?step:(unit -> float) -> ('a, 'b) wire -> 'a -> 'b * ('a, 'b) wire

val loop : initial:'c -> ('a * 'c, 'b * 'c) wire -> ('a, 'b) wire

val pure : 'a -> (_, 'a) wire
val apply : ('i, 'a -> 'b) wire -> ('i, 'a) wire -> ('i, 'b) wire
val ( <*> ) : ('i, 'a -> 'b) wire -> ('i, 'a) wire -> ('i, 'b) wire
val map : ('a -> 'b) -> ('i, 'a) wire -> ('i, 'b) wire
val ( <$> ) : ('a -> 'b) -> ('i, 'a) wire -> ('i, 'b) wire
val lift : ('a -> 'b) -> ('i, 'a) wire -> ('i, 'b) wire
val lift2 : ('a -> 'b -> 'c) -> ('i, 'a) wire -> ('i, 'b) wire -> ('i, 'c) wire

val lift3 :
  ('a -> 'b -> 'c -> 'd) ->
  ('i, 'a) wire ->
  ('i, 'b) wire ->
  ('i, 'c) wire ->
  ('i, 'd) wire

val id : ('a, 'a) wire
val ( >>> ) : ('a, 'b) wire -> ('b, 'c) wire -> ('a, 'c) wire
val arr : ('a -> 'b) -> ('a, 'b) wire
val first : ('a, 'b) wire -> ('a * 'c, 'b * 'c) wire
val second : ('a, 'b) wire -> ('c * 'a, 'c * 'b) wire
val ( *** ) : ('a, 'b) wire -> ('a2, 'b2) wire -> ('a * 'a2, 'b * 'b2) wire
val ( &&& ) : ('a, 'b) wire -> ('a, 'b2) wire -> ('a, 'b * 'b2) wire
val ( ^>> ) : ('a -> 'b) -> ('b, 'c) wire -> ('a, 'c) wire
val ( >>^ ) : ('a, 'b) wire -> ('b -> 'c) -> ('a, 'c) wire
val empty : (_, 'a option) wire

val ( <+> ) :
  ('a, 'b option) wire -> ('a, 'b option) wire -> ('a, 'b option) wire

val ( <|> ) :
  ('a, 'b option) wire -> ('a, 'b option) wire -> ('a, 'b option) wire

val left : ('a, 'b) wire -> (('a, 'c) Either.t, ('b, 'c) Either.t) wire
val right : ('a, 'b) wire -> (('c, 'a) Either.t, ('c, 'b) Either.t) wire

val ( +++ ) :
  ('a1, 'b1) wire ->
  ('a2, 'b2) wire ->
  (('a1, 'a2) Either.t, ('b1, 'b2) Either.t) wire

val ( ||| ) : ('a, 'c) wire -> ('b, 'c) wire -> (('a, 'b) Either.t, 'c) wire
val dimap : ('a -> 'b) -> ('c -> 'd) -> ('b, 'c) wire -> ('a, 'd) wire
val lmap : ('a -> 'b) -> ('b, 'c) wire -> ('a, 'c) wire
val mk_const : 'a -> (_, 'a) wire
val mk_empty : (_, _ option) wire
val mk_gen : ((unit -> float) -> 'a -> 'b * ('a, 'b) wire) -> ('a, 'b) wire
val mk_id : ('a, 'a) wire

module NetTime : sig
  type t = float

  val time : (_, float) wire
end

module Util : sig
  val print_wire : ('o -> string) -> (unit, 'o) wire -> 'e
end
