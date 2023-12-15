defmodule Greeting do
  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [upcase: :boolean])

    case opts[:upcase] do
      true -> IO.puts("GOOD MORNING!")
      _ -> IO.puts("Good morning!")
    end
  end
end
