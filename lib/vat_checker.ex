defmodule TogglVatChecker.VatChecker do
  @moduledoc """
  Validates a given VAT number
  """

  alias TogglVatChecker.{Error, SoapRequester}

  @type opts :: [endpoint: :live | :test]
  @type ok :: {:ok, valid? :: boolean}
  @type error :: {:error, Error.t}

  @doc "Checks that a given number is valid"
  @spec check(vat_number :: String.t, opts) :: ok | error
  def check(vat_number, opts \\ []) do
    with {:ok, country, number} <- split(vat_number),
         endpoint <- Keyword.get(opts, :endpoint, :test),
         service <- Keyword.get(opts, :service, &SoapRequester.request/3),
         {:ok, body} <- service.(country, number, endpoint) do
      parse(body)
    end
  end

  @spec split(String.t) :: {:ok, String.t, String.t} | error
  defp split(<< country::binary-size(2), number::binary >>) do
    {:ok, country, number}
  end
  defp split(number) do
    short = "invalid number"
    long = ~s(Could not parse "#{number}" as VAT number.)

    {:error, Error.from(short, long)}
  end

  @spec parse(String.t) :: ok | error
  defp parse(body) do
    if String.contains?(body, "checkVatResponse") do
      {:ok, valid?(body)}
    else
      {:error, parse_fault(body)}
    end
  end

  @spec valid?(String.t) :: boolean
  defp valid?(body) do
    String.contains?(body, "<valid>true</valid>")
  end

  @spec parse_fault(String.t) :: Error.t
  defp parse_fault(body) do
    Error.from("error", body)
  end
end
