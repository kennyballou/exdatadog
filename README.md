# Exdatadog #

(Unofficial) Elixir DataDog Client API.

This is a work-in-progress implementation, expect some churn and no semantic
compatibility between versions.

## Installation ##

This package is made available through [hex.pm][1], use the following
instructions to add to your project:

1. Add `exdatadog` to your list of dependencies in `mix.exs`:

   ```elixir
   def deps do
     [{:exdatadog, "~> 0.1.0"}]
   end
   ```

2. Ensure `exdatadog` is started before your application:

   ```elixir
   def application do
     [applications: [:exdatadog]]
   end
   ```

## LICENSE ##

This package is made available as free and open source software, AS-IS and
without waranty, under the terms and conditions of the Apache 2.0 license. For
more information see the included `LICENSE` file or [read the license
online][2].

[1]: https://hex.pm/packages/exdatadog

[2]: https://www.apache.org/licenses/LICENSE-2.0
