# Toggl Vat Checker - Coding Test

[![Build Status](https://travis-ci.org/nirev/toggl_vat_checker.svg?branch=master)](https://travis-ci.org/nirev/toggl_vat_checker)

## Description

A simple CLI app to verify VAT numbers, built using Elixir.

## Usage

Environment:
- elixir 1.5.1
- erlang 20.0

### compiling

```shell
git clone git@github.com:nirev/toggl_vat_checker.git
cd toggle_vat_checker
mix deps.get
mix escript.build
```

### running cli

```shell
# using test endpoint
./toggl_vat_checker <vat_number>

# using live endpoint
./toggl_vat_checker --live <vat_number>
```

### running tests

```shell
mix test
```

### documentation

Documentation is available at https://nirev.github.io/toggl_vat_checker/  
It was generated with ex_doc using:

```shell
mix docs
```

### static code analysis

[Credo](https://github.com/rrrene/credo) is used for code styling check

```shell
mix credo
```

[Dialyxir](https://github.com/jeremyjh/dialyxir) for warnings regarding 
type mismatch and other common mistakes.

The first run takes a while, as it must build a lookup table.

```shell
mix dialyzer
```
