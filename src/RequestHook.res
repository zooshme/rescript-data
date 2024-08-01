open Fetch

type t<'a> = {
  data: Data.t<'a>,
  send: unit => Promise.t<unit>,
}

let useRequest = (
  ~endpoint: string,
  ~headers: array<(string, string)>,
  ~credentials: requestCredentials,
  ~method: method,
  ~timeout: int=5000,
  ~body: option<Json.Value.t>=?,
  ~decode: Json.Decode.t<'a>,
) => {
  let (data: Data.t<'a>, setData) = React.useState(_ => Data.NotAsked)

  let controller = AbortController.make()

  let options: Request.init = {
    switch method {
    | #GET => {
        method,
        headers: Headers.fromArray(headers),
        credentials,
        signal: controller->AbortController.signal,
      }
    | _ => {
        method,
        headers: Headers.fromArray(headers),
        credentials,
        body: body
        ->Option.map(Json.Encode.encode(_, ~indentLevel=0))
        ->Option.getOr("")
        ->Body.string,
        signal: controller->AbortController.signal,
      }
    }
  }

  let request = Request.make(endpoint, options)

  let send_ = async () => {
    try {
      setData(_ => Data.Loading)

      let timeoutId = setTimeout(() => {
        controller->AbortController.abort(~reason="Request timed out")
        setData(_ => Data.Error("Request timed out"))
      }, timeout)

      let response = await request->send

      clearTimeout(timeoutId)

      let json = await response->Response.json

      switch json->Json.Decode.decode(decode) {
      | Ok(data) => setData(_ => Data.Data(data))
      | Error(error) => setData(_ => Data.Error(error->Json.Decode.errorToString))
      }
    } catch {
    | Exn.Error(e) =>
      switch Exn.message(e) {
      | Some(_) => setData(_ => Data.Error("Request timed out"))
      | None => setData(_ => Data.Error("An error occurred"))
      }
    }
  }

  let hookReturn: t<'a> = {
    data,
    send: send_,
  }

  hookReturn
}
