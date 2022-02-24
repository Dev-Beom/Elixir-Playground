defmodule PhoenixExqWeb.PageController do
  require Logger

  use PhoenixExqWeb, :controller

  def index(conn, _params) do
    Exq.enqueue(Exq, "jobs", Demo.Worker, [conn.port])
    render(conn, "index.html")
  end
end
