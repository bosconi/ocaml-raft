module type MACHINE =
  sig
  type t with sexp (*holds the state of the machine *)
  type cmd with sexp
  type res with sexp
  val commit_many: t -> cmd list -> t
  val init : unit -> t
  val to_string : t -> string
  val cmd_to_string : cmd -> string
  val res_to_string : res -> string
  val gen_workload : int -> cmd list
   val gen_results : int -> res list
  val get_last_res: t -> res
  val check_cmd: t -> cmd -> res option 
  val expected_serial: t -> cmd -> bool
  end
module KeyValStr : MACHINE
