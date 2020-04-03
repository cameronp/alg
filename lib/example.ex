defmodule Example do
  def parse(s) do
    {:ok, tokens, _} = String.to_char_list(s) |> :lexer.string()
    tokens |> :parser.parse()
  end
end
