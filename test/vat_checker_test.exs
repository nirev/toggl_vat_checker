defmodule TogglVatChecker.VatCheckerTest do
  use ExUnit.Case

  alias TogglVatChecker.Error
  alias TogglVatChecker.VatChecker

  test "valid VAT" do
    service = make_service(valid_response("true"))
    response = VatChecker.check("XXX", [service: service])

    assert response == {:ok, true}
  end

  test "invalid VAT" do
    service = make_service(valid_response("false"))
    response = VatChecker.check("XXX", [service: service])

    assert response == {:ok, false}
  end

  test "error from SOAP" do
    service = make_service(fault_response("MS_UNAVAILABLE"))
    response = VatChecker.check("XXX", [service: service])

    assert {:error, %Error{short: "MS_UNAVAILABLE"}} = response
  end

  test "error requesting service" do
    service = make_service({:error, %Error{}})
    response = VatChecker.check("XXX", [service: service])

    assert {:error, %Error{}} = response
  end

  defp make_service(response) do
    fn _, _, _ -> response end
  end

  defp valid_response(valid?) do
    body =
      ~s(<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <checkVatResponse xmlns="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
      <countryCode>DE</countryCode>
      <vatNumber>296459264</vatNumber>
      <requestDate>2017-09-21+02:00</requestDate>
      <valid>#{valid?}</valid>
      <name>---</name>
      <address>---</address>
      </checkVatResponse>
      </soap:Body>
      </soap:Envelope>)

    {:ok, body}
  end

  defp fault_response(fault) do
    body =
      ~s(<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <soap:Fault>
      <faultcode>soap:Server</faultcode>
      <faultstring>#{fault}</faultstring>
      </soap:Fault>
      </soap:Body>
      </soap:Envelope>)

    {:ok, body}
  end
end
