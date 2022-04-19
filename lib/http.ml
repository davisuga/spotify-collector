(* open Cohttp *)
module Spotify = struct
  let base_url_raw = "https://api.spotify.com/v1"
  let base_url = Uri.of_string base_url_raw

  let getTops ?(limit = 20) ?(time_range = "short_term") ?(offset = 5) =
    let withPath = Uri.with_path base_url "/me/top/tracks" in
    Uri.add_query_params' withPath
      [
        ("limit", string_of_int limit);
        ("time_range", time_range);
        ("offset", string_of_int offset);
      ]
end
