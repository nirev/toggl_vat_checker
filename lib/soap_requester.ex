defmodule TogglVatChecker.SoapRequester do
  @moduledoc """
  Issues requests to VAT validation SOAP service
  """

  alias TogglVatChecker.Error

  @type endpoint :: :live | :test
  @type ok :: {:ok, body :: String.t}
  @type error :: {:error, Error.t}

  @doc "Makes a request for validating VAT number using chosen endpoint"
  @spec request(country :: String.t, number :: String.t, endpoint) :: ok | error
  def request(country, number, endpoint) do
    url = endpoint_url(endpoint)
    case HTTPoison.post url, params(country, number) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status_code: code}} ->
        short = "error request service"
        long = "status_code: #{code}"
        {:error, Error.from(short, long)}

      error = {:error, _} ->
        Error.from(error)
    end
  end

  @spec params(country :: String.t, number :: String.t) :: String.t
  defp params(country, number) do
    ~s(<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
    <checkVat xmlns="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
    <countryCode>#{country}</countryCode>
    <vatNumber>#{number}</vatNumber>
    </checkVat>
    </Body>
    </Envelope>)
  end

  @spec endpoint_url(endpoint) :: String.t
  defp endpoint_url(:test) do
    "http://ec.europa.eu/taxation_customs/vies/services/checkVatTestService"
  end
  defp endpoint_url(:live) do
    "http://ec.europa.eu/taxation_customs/vies/services/checkVatService"
  end

end
