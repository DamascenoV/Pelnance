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

# Create types

types = [
  %{name: "Income", subtraction: false},
  %{name: "Expense", subtraction: true},
]

Enum.each(types, &(Pelnance.Types.create_type(&1)))
