type t<'a> =
  | NotAsked
  | Loading
  | Data('a)
  | Error(string)

//#region Generators
let make = () => NotAsked
//#region

//#region Checkers
let isNotAsked = (data: t<'a>) => {
  switch data {
  | NotAsked => true
  | _ => false
  }
}

let isLoading = (data: t<'a>) => {
  switch data {
  | Loading => true
  | _ => false
  }
}

let isData = (data: t<'a>) => {
  switch data {
  | Data(_) => true
  | _ => false
  }
}

let isError = (data: t<'a>) => {
  switch data {
  | Error(_) => true
  | _ => false
  }
}
//#region

//#region Transformers
let toData = (data: t<'a>): option<'a> => {
  switch data {
  | Data(value) => Some(value)
  | _ => None
  }
}
//#region
