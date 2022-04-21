open Utils.Env
open Http.Spotify
open Lwt

let main =
  let categories = [ Tracks; Artists ] in
  match getVar "TOKEN" with
  | Error msg -> print_string msg
  | Ok key ->
      categories
      |> List.map (fun top_type -> getTops ~top_type key >|= print_string)
      |> Lwt.join |> Lwt_main.run |> ignore
