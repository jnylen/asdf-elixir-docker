# asdf-elixir

Docker container based on Alpine linux distribution.

It has:

1. Erlang last releases for each major version: `20.*`
1. Elixir last releases for each major version: `1.8.*`
1. NodeJS last releases for each LTS version: `8.*`

Additional features:

1. Starting command: `/bin/bash`, so you should override it when using for prod and test environments.
1. Ports are not exposed, you should do it by yourself in `dev` and `prod` environments for `Phoenix` development.
1. `tzinfo` included. So you can use `timex` for free.
