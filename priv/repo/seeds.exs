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

currencies = [
  %Currencies.Currency{name: "Euro", symbol: "€"},
  %Currencies.Currency{name: "Dollar", symbol: "$"},
  %Currencies.Currency{name: "Pound", symbol: "£"},
  %Currencies.Currency{name: "Yen", symbol: "¥"}
]

Enum.each(currencies, fn currency -> Currencies.create_currency(currency) end)
