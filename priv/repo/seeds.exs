# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pelnance.Repo.insert!(%Pelnance.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pelnance.Currencies
alias Pelnance.Types

currencies = [
  %{name: "Euro", symbol: "€"},
  %{name: "Dollar", symbol: "$"},
  %{name: "Pound", symbol: "£"},
  %{name: "Yen", symbol: "¥"}
]

Enum.each(currencies, fn currency -> Currencies.create_currency(currency) end)

types = [
  %{name: "Income", icon: "hero-arrow-trending-up"},
  %{name: "Expense", icon: "hero-arrow-trending-down"}
]

Enum.each(types, fn type -> Types.create_type(type) end)
