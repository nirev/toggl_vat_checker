defmodule TogglVatChecker.Error do
  @moduledoc """
  Something bad happened. Has short and long description.
  """
  defstruct [:short, :long]

  @type t :: %__MODULE__{short: String.t,
                         long: String.t}

  @spec from({:error, HTTPoison.Error.t}) :: t
  def from({:error, %HTTPoison.Error{reason: reason}}) do
    %__MODULE__{short: "error requesting service",
                long: reason}
  end

  @spec from(short :: String.t, long :: String.t) :: t
  def from(short, long) when is_binary(short) and is_binary(long) do
    %__MODULE__{short: short, long: long}
  end
end
