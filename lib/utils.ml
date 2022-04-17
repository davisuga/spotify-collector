module String = struct
  let catStringWith separator strA strB = strA ^ separator ^ strB
  let joinArray separator arr = Array.fold_left (catStringWith separator) "" arr
end

module Env = struct
  let getVar name =
    try Ok (Unix.getenv name)
    with Not_found -> Error ("Variable " ^ name ^ " not found")
end
