open Core.Std
open Common

let cmdspec () = 
  Command.Spec.(
    empty
    +> flag "-nodes" (required int) 
      ~doc:"int Number of nodes to simulate, must be 2 or greater"
    +> flag "-eligible" (optional int)
      ~doc:"int Number of simulated nodes which are eligible for leadership, default to all"
    +> flag "-termOnTimeout" (optional_with_default 5000 int)
      ~doc:"int The maximum number of terms before termination"
    +> flag "-d" no_arg
      ~doc:"flag Enable debugging output (disabled by default)"
    +> flag "-json" no_arg
      ~doc:"flag Enable JSON Output (disabled by default)"
    +> flag "-iter" (optional_with_default 1 int) 
      ~doc:"int Number of Simulations to run (not working) "
    +> flag "-data" (optional string) 
      ~doc:"filename File to output data to as .data (currently not working)"
    +> flag "-follower" (required Parser.distribution)
      ~doc:"distribution Follower timeout statistical distribution"
    +> flag "-candidate" (required Parser.distribution)
      ~doc:"distribution Candidate timeout statistical distribution"
    +> flag "-leader" (required Parser.distribution)
      ~doc:"distribution LeadersStatistical distribution"     
    +> flag "-delay" (required Parser.distribution)
      ~doc:"distribution Packet Delay statistical distribution"
    +> flag "-failure" (optional Parser.distribution)
      ~doc:"distribution Node failure statistical distribution"
    +> flag "-recover" (optional Parser.distribution)
      ~doc:"distribution Node recovery statistical distribution"
    +> flag "-termOnElec" no_arg
       ~doc:"flag Terminate when a leader has successfully been established"
    +> flag "-termOnClient" no_arg
       ~doc:"flag Terminate when a client workload is empty"
    +> flag "-cmds" (optional_with_default 5 int)
        ~doc:"int Size of test workload"
    +> flag "-clientWaitSuccess" (optional_with_default 0 int)
      ~doc:"int Time a client waits after a successful requests"
    +> flag "-clientWaitFailure" (optional_with_default 0 int)
      ~doc:"int Time a client waits after a failed requests"        
    +> flag "-clientTimeout" (optional_with_default 100 int)
      ~doc:"int Timeout that a client waits for the response from the cluster"  
    +> flag "-backoff" no_arg
      ~doc:"flag Enable the binary exponential for candidates with majority rejections" 
    +> flag "-loss" (optional_with_default 0.0 float)
      ~doc:"float Probability that a packet will be lost in the network"
    +> flag "-hist" no_arg
      ~doc:"flag Enable storage of simulation trace"
    +> flag "-conservative" no_arg
      ~doc:"flag Enable conservative use of AppendEntries so they only go out on each ehop"
)

let cmdparser =
  Command.basic
  ~summary:"Discrete Event Simulator for Raft's Leader Election"
  ~readme: (fun () -> "see github.com/heidi-ann/ocaml-raft for more information ")
  Command.Spec.(
    empty
     ++ cmdspec ()
      )
  (fun nodes eligible term debug_enabled json_enabled iter data follower candidate leader delay failure recover term_ele 
      term_client cmds wait_succ wait_fail timeout_client backoff loss hist cons () ->  
    printf "%s" (Parser.run ~time:Real ~nodes ~eligible ~term ~debug_enabled ~json_enabled ~iter ~data ~follower ~candidate ~leader ~delay 
    ~failure ~recover ~term_ele ~term_client ~cmds ~wait_succ ~wait_fail ~timeout_client ~backoff ~loss ~hist ~cons )) 

let () = Command.run cmdparser
