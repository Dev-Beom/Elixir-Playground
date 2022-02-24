defmodule PhoenixExq.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_exq,
    adapter: Ecto.Adapters.MyXQL
end
