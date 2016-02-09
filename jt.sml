exception UnknownCommand of string;

structure JS = struct
datatype value
  = OBJECT of (string, value) HashTable.hash_table
  | ARRAY  of value list
  | BOOL   of bool
  | INT    of IntInf.int
  | FLOAT  of real
  | STRING of string
  | NULL
end

fun processArgument(JS.OBJECT json, arg: string) =
  case arg
   of "-k" => app (fn (k,_) => print(k ^ "\n")) (HashTable.listItemsi(json))
    | _    => raise UnknownCommand(arg)

fun makeError(msg: string) = (
    TextIO.output (TextIO.stdErr, (msg ^ "\n"));
    OS.Process.failure
)

fun toJS(JSON.ARRAY x)   = JS.ARRAY(map toJS x)
  | toJS (JSON.OBJECT x) = (
      let val ht = HashTable.mkTable(HashString.hashString, op=)(42, Fail "not found")
      in app (fn (k,v) => HashTable.insert ht (k, (toJS v))) x;
         JS.OBJECT(ht)
      end
  )
  | toJS (JSON.NULL)     = JS.NULL
  | toJS (JSON.BOOL x)   = JS.BOOL(x)
  | toJS (JSON.INT x)    = JS.INT(x)
  | toJS (JSON.FLOAT x)  = JS.FLOAT(x)
  | toJS (JSON.STRING x) = JS.STRING(x)

fun readJson() =
  toJS(JSONParser.parse(TextIO.stdIn))

datatype cmd
  = DOWN of string
  | GOSUB of cmd list

(* fun readCommands(args: string list) = *)
(*   case args of Empty => raise Fail("no arguments") *)
(*              | (x::rest) => ( *)
(*                  case x of "[" => GOSUB(readCommands(rest)) *)
(*                          | "]" => None *)
(*                          | _ => DOWN(x) *)
(*              ) *)

fun main(name: string, args: string list) =
  let val jsonValue = readJson()
  in processArgument(jsonValue, (hd args));
     OS.Process.success
  end
  handle UnknownCommand(x) => makeError("Unknown command: " ^ x)
       | e => makeError (exnMessage(e))

val _ = OS.Process.exit(main(CommandLine.name(), CommandLine.arguments()))
