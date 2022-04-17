open Utils.Env

let main =
  match getVar "API_KEY" with
  | Error msg -> print_string msg
  | Ok key -> print_string key
