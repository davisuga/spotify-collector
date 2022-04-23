open Cohttp_lwt_unix
open Lwt

let tap fn x =
  fn x;
  x

let show_response resp body =
  let code = resp |> Response.status |> Cohttp.Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n"
    (resp |> Response.headers |> Cohttp.Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body: %s\n" body

module Spotify = struct
  let base_url = "https://api.spotify.com/v1"

  type time_range = Short_term | Medium_term | Long_term
  type top_type = Tracks | Artists

  let string_of_time_range = function
    | Short_term -> "short_term"
    | Medium_term -> "medium_term"
    | Long_term -> "long_term"

  let string_of_top_type = function Tracks -> "tracks" | Artists -> "artists"

  let get spotify_token path params =
    let headers =
      Cohttp.Header.of_list [ ("Authorization", "Bearer " ^ spotify_token) ]
    in
    let withPath = Uri.of_string (base_url ^ path) in
    Uri.add_query_params' withPath params
    |> Client.get ~headers
    |> tap (fun _ -> print_endline ("url: " ^ base_url ^ path))

  let getTops ?(limit = 100) ?(time_range = Short_term) ?(offset = 0)
      ?(top_type = Tracks) token =
    get token
      ("/me/top/" ^ string_of_top_type top_type)
      [
        ("limit", string_of_int limit);
        ("time_range", string_of_time_range time_range);
        ("offset", string_of_int offset);
      ]
    >>= fun (res, body) ->
    let _ = show_response res body in
    Cohttp_lwt.Body.to_string body

  let save_data data = data

  let authorize _ =
    let url =
      "https://accounts.spotify.com/authorize?client_id=2c07c58bb20c4f529f5e262b85b6b1ba&response_type=token&state=67ff85d4-955a-44bf-b778-5bdba96f9903&scope=user-top-read%20playlist-modify-public%20playlist-modify-private%20user-read-private%20user-read-recently-played&redirect_uri=https%3A%2F%2Fwww.statsforspotify.com%2Flogin%2Fcallback&show_dialog=false"
    in
    Client.get (Uri.of_string url) >>= fun (res, body) ->
    let _ = show_response res body in
    Cohttp_lwt.Body.to_string body
end
