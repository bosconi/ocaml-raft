open Core.Std
open Async.Std

type role = Follower | Candidate | Leader 

type log_entry = 
  { term: int;
    index: int;
    command: string; }

type state = 
  { candidate_id: int;
    mutable all_ids: int list;
    mutable leader_id: int option;
    mutable cnt_role: role;
    mutable cnt_term: int;
    mutable voted_for: int option;
    mutable log: log_entry list }

(*
let run_leader state = 
  (* this node has just won a eletion *) 
  send all appendEntries term:int leader_id:int prev_log_index:int prev_log_term:int (entries: log_entry list) commitIndex:int 

let requestVote term:int candidate_id:int last_log_index:int last_log_term:int = 

let appendEntries term:int leader_id:int prev_log_index:int prev_log_term:int (entries: log_entry list) commitIndex:int =

let clientrequest command:string =
  match state.cnt_role with 
  |Follower -> return "Failure: please ask"^state.leader_id
  |Candidate -> return "Failure: try again later"
  |Leader -> *)

let run ~port = 
  (* assume this the first time candidate has been started up *)
  let state = { candidate_id =1000; 
                all_ids=[];
		leader_id= None;
		cnt_role = Follower;
		cnt_term = 0;
		voted_for = None;
		log = []; } in
  Tcp.connect (Tcp.to_host_and_port "localhost" port)
  >>= (fun (_,_,w) -> Writer.write w "hello\n"; Writer.close w )

 
let () =
  Command.async_basic
    ~summary:"Start an raft node"
    Command.Spec.(
      empty
      +> flag "-port" (optional_with_default 8888 int)
        ~doc:" Port to listen on (default 8888)"
    )
    (fun port () -> run ~port)
  |> Command.run
