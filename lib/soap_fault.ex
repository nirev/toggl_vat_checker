defmodule TogglVatChecker.SoapFault do
  @moduledoc """
  Maps SOAP faults to `TogglVatChecker.Error`s with description
  """

  alias TogglVatChecker.Error

  @doc """
  Builds a `TogglVatChecker.Error` with description for given SOAP fault.
  """
  @spec to_error(String.t) :: Error.t
  def to_error(code) do
    Error.from(code, description(code))
  end

  @spec description(String.t) :: String.t
  def description(code) do
    case code do
      "INVALID_INPUT" ->
        "The provided CountryCode is invalid or the VAT number is empty."

      "GLOBAL_MAX_CONCURRENT_REQ" ->
        "Your Request for VAT validation has not been processed; the maximum number of concurrent requests has been reached. Please re-submit your request later or contact TAXUD-VIESWEB@ec.europa.eu for further information: Your request cannot be processed due to high traffic on the web application. Please try again later."

      "MS_MAX_CONCURRENT_REQ" -> "Your Request for VAT validation has not been processed; the maximum number of concurrent requests for this Member State has been reached. Please re-submit your request later or contact TAXUD-VIESWEB@ec.europa.eu for further information: Your request cannot be processed due to high traffic towards the Member State you are trying to reach. Please try again later."

      "SERVICE_UNAVAILABLE" -> "An error was encountered either at the network level or the Web application level. Try again later."

      "MS_UNAVAILABLE" -> "The application at the Member State is not replying or not available. Please refer to the Technical Information page to check the status of the requested Member State. Try again later."

      "TIMEOUT" -> "The application did not receive a reply within the allocated time period. Try again later."

      _other -> ""
    end
  end
end
