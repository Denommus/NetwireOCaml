type ('a, 'b) wire

val stepWire: ('a, 'b) wire -> (unit -> float) -> 'a -> 'b * ('a, 'b) wire
