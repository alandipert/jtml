fun main(name: string, args: string list) =
  let
      val jsonValue = JSONParser.parse(TextIO.stdIn);
  in
      JSONPrinter.print(TextIO.stdOut, jsonValue);
      OS.Process.success
  end

val _ = OS.Process.exit(main(CommandLine.name(), CommandLine.arguments()))
