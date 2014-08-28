open Core.Std
open Common

type t =
  {
  reason: termination;
  time: string;
  replica_pkts: int;
  client_pkts: int;
  leader_est: string;
  client_latency: string;
  avalability: float;
  election_time: string; 
  }

val to_string: t -> string
