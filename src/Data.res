type t<'a> =
  | NotAsked
  | Loading
  | Data('a)
  | Error(string)

//#region Generators
let make = () => NotAsked
//#region

//#region Getters
let getData = (data: t<'a>): option<'a> => {
  switch data {
  | Data(value) => Some(value)
  | _ => None
  }
}

let getError = (data: t<'a>): option<string> => {
  switch data {
  | Error(value) => Some(value)
  | _ => None
  }
}
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

//#region Updaters
let update = (data: t<'a>, f: 'a => 'a): t<'a> => {
  switch data {
  | Data(value) => Data(f(value))
  | _ => data
  }
}
//#region

//#region Mappers
let map = (data: t<'a>, f: 'a => 'b): t<'b> => {
  switch data {
  | Data(value) => Data(f(value))
  | _ => data
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
