open Utils.Env

let main =
  match getVar "CLIENT_SECRET" with
  | Error msg -> print_string msg
  | Ok key -> print_string key
