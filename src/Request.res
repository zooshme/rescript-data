open Fetch

type t<'a> = {
  data: Data.t<'a>,
  send: unit => unit,
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
  let timeoutId = setTimeout(() => {
    controller->AbortController.abort("Request timed out")
    setData(_ => Data.Error("Request timed out"))
  }, timeout)

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

  let send_ = () => {
    setData(_ => Data.Loading)
    request
    ->send
    ->Promise.then(response => {
      clearTimeout(timeoutId)
      response->Response.json
    })
    ->Promise.then(json => {
      switch json->Json.Decode.decode(decode) {
      | Ok(data) => setData(_ => Data.Data(data))
      | Error(error) => setData(_ => Data.Error(error->Json.Decode.errorToString))
      }
      Promise.resolve()
    })
    ->ignore
  }

  let hookReturn: t<'a> = {
    data,
    send: send_,
  }

  hookReturn
}
