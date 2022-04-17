open Utils.String
open Utils.Env

let getArgs =
  match Sys.argv with
  | [| _path; "Hello" |] -> "Hello World"
  | [| _path; "Goodbye" |] -> "Goodbye World"
  | [| head; tail |] -> "head = " ^ head ^ " and tail =" ^ tail
  | a -> joinArray " " a |> print_string |> fun () -> "No args here"

let main =
  match getVar "API_KEY" with
  | Error msg -> print_string msg
  | Ok key -> print_string key
