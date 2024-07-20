type data<'a> =
  | NotAsked
  | Loading
  | Data('a)
  | Error(string)

//#region Generators
let make = () => NotAsked
//#region

//#region Checkers
let isNotAsked = (data: data<'a>) => {
  switch data {
  | NotAsked => true
  | _ => false
  }
}

let isLoading = (data: data<'a>) => {
  switch data {
  | Loading => true
  | _ => false
  }
}

let isData = (data: data<'a>) => {
  switch data {
  | Data(_) => true
  | _ => false
  }
}

let isError = (data: data<'a>) => {
  switch data {
  | Error(_) => true
  | _ => false
  }
}
//#region

//#region Transformers
let toData = (data: data<'a>): option<'a> => {
  switch data {
  | Data(value) => Some(value)
  | _ => None
  }
}
//#region
