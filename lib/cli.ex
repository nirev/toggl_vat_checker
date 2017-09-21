defmodule TogglVatChecker.CLI do
  @moduledoc """
  CLI for Toggle Vat Checker

  ## Examples

      # defaults to using test endpoint
      ./toggle_vat_checker NL802465602B01

      # use live production endpoint
      ./toggle_vat_checker --endpoint live NL802465602B01
  """

  alias TogglVatChecker.{Error, VatChecker}

  @doc """
  Entry point
  """
  @spec main([String.t]) :: :ok | no_return
  def main(args \\ [], checker \\ VatChecker) do
    with {vat_number, opts} <- parse_args(args) do
      vat_number
      |> checker.check(opts)
      |> print()
    end
  end

  @spec parse_args([String.t]) :: {String.t, VatChecker.opts} | no_return
  defp parse_args(args) do
    case OptionParser.parse(args, strict: [live: :boolean]) do
      {[], [vat_number], _} ->
        {vat_number, [endpoint: :test]}

      {[live: true], [vat_number], _} ->
        {vat_number, [endpoint: :live]}

      _otherwise ->
        exit_with_help()
    end
  end

  @spec exit_with_help() :: no_return
  defp exit_with_help do
    script_name = :escript.script_name()
    message = """
    Invalid parameters!
    Use:
    \t#{script_name} [--live] vat_number
    """

    IO.puts :stderr, message
    exit({:shutdown, 1})
  end

  @spec print({:ok, boolean} | {:error, Error.t}) :: :ok
  defp print({:ok, _valid = true}), do: IO.puts("Valid")
  defp print({:ok, _valid = false}), do: IO.puts("Invalid")
  defp print({:error, %{short: short, long: description}}) do
    IO.puts("ERROR: #{short}")
    IO.puts(description)
  end
end
