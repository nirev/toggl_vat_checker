defmodule TogglVatChecker.CLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias TogglVatChecker.CLI
  alias TogglVatChecker.Error

  defmodule ValidChecker do
    def check(_, _), do: {:ok, true}
  end

  defmodule InvalidChecker do
    def check(_, _), do: {:ok, false}
  end

  defmodule ErrorChecker do
    def check(_, _) do
      {:error, %Error{short: "some error",
                     long: "something bad happened"}}
    end
  end

  test "valid number" do
    assert capture_io(fn ->
      CLI.main(["DE292188391"], ValidChecker)
    end) == "Valid\n"
  end

  test "invalid number" do
    assert capture_io(fn ->
      CLI.main(["DE292188391"], InvalidChecker)
    end) == "Invalid\n"
  end

  test "error when checking" do
    assert capture_io(fn ->
      CLI.main(["DE292188391"], ErrorChecker)
    end) == "ERROR: some error\nsomething bad happened\n"
  end

  test "invalid input" do
    assert catch_exit(
      assert capture_io(:stderr, fn ->
        CLI.main(["not", "valid"])
      end) =~ "Invalid parameters!"
    ) == {:shutdown, 1}
  end
end
