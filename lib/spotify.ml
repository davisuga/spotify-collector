open Utils.Env
open Http

let main =
  match getVar "TOKEN" with
  | Error msg -> print_string msg
  | Ok key -> Spotify.getTops key |> Lwt_main.run |> print_string
