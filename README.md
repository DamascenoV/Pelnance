# Pelnance

WIP (Work in Progress) - This is still in development version so somethings can not work as expected.
This is a simple project to learn Phoenix framework / Elixir.

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix



### The features that I want:

* Accounts
* Transactions (Income, Expenses) -> Can have documents attached
* Creation of categories, currencies
* Dashboard to see the stats of the month, half-year, year
* Translations (en and pt-br)
* Recurrent Transactions (Income and Expenses) -> This can be configure by the user
* Goals -> Like some list that things that the user want to achieve



### TO DO

 * [x] - When create a transaction save the account balance
 * [x] - Goals
 * [] - Settings page
    - [] - Dashboard Settings (Put some configurations like time to show the stats of the dashboard (month, half-year, year))
 * [] - When creating a transaction change the difference in accounts balance
 * [] - In the page of the Account show the transactions
 * [] - Dashboard
 * [] - Translations
 * [x] - Migrations to default types (Expenses, Income) -> Maybe remove the possibility to create a type
    - [] - Expenses Default Categories (House, Car, Food, Transfer)
    - [] - Income Default Categories (Salary, Bonus, Income, Transfer)
 * [] - Recurrent transactions
 * [] - Add Documents in the transaction
 * [] - Tests
    - [] - Liveview Tests
 * [x] - Table filters -> Flop
 * [] - Improve layout
 * [] - Dark mode
 * [] - Charts
 * [] - API? (Future Mobile App)
