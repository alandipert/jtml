structure Dict = StringRedBlackDict

structure JS = struct
datatype value
  = OBJECT of value Dict.dict
  | ARRAY  of value vector
  | BOOL   of bool
  | INT    of IntInf.int
  | FLOAT  of real
  | STRING of string
  | NULL
datatype key
  = IKEY of Int.int
  | SKEY of string
end

fun findIn(obj: JS.value, ks: JS.key list) =
  case (obj, ks) of
      (JS.OBJECT(m), JS.SKEY(s)::more) =>
      (case (Dict.find m s) of
           SOME v => findIn(v, more)
         | NONE => NONE)
    | (JS.ARRAY(v), JS.IKEY(i)::more) =>
      (case (i < Vector.length(v)) of
           true => findIn(Vector.sub(v, i), more)
         | false => NONE)
    | (_, []) => SOME(obj)
    | _ => NONE

fun main(name: string, args: string list) =
  let val n1 = JS.STRING("hello")
      val l1 = JS.ARRAY(Vector.fromList([n1]))
      val m1 = JS.OBJECT(Dict.insert Dict.empty "foo" l1)
      val v1 = findIn(m1, [JS.SKEY("foo"), JS.IKEY(0)])
  in
    (print
         (case v1 of
              SOME(JS.STRING(s)) => s
            | SOME(_) => "not found"
            | NONE => "not found");
     OS.Process.success)
  end

val _ = OS.Process.exit(main(CommandLine.name(), CommandLine.arguments()))
